//:://////////////////////////////////////////////////////////////////////////
//:: Rescue
//:: nx_s2_rescue
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/27/2007
//:: Copyright (c) 2007 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	When Rescue Mode is activated (a free action), allies within 5 ft. take
	half damage; the amount of damage not taken by your allies is taken by you.
		You also gain DR 2/- while in Rescue Mode.
*/
//:: AFW-OEI 07/17/2007: NX1 VFX; up radius to 10'.

#include "_HkSpell"
#include "_SCInclude_Songs"

int CanRescue( object oRescuer )
{
	if (CSLGetHasEffectType( oRescuer, EFFECT_TYPE_PARALYZE ) ||
		CSLGetHasEffectType( oRescuer, EFFECT_TYPE_STUNNED ) ||
		CSLGetHasEffectType( oRescuer, EFFECT_TYPE_SLEEP ) ||
		CSLGetHasEffectType( oRescuer, EFFECT_TYPE_PETRIFY ) )
		
	{
		FloatingTextStrRefOnCreature(112849, oRescuer); // * You can not use this feat at this time *
		return FALSE;
	}

	return TRUE;
}

int ToggleRescue ( object oRescuer )
{
	int nRescueSpellId = SCFindEffectSpellId(EFFECT_TYPE_RESCUE, oRescuer);

	// Rescue is on, so toggle it off.
	if (nRescueSpellId != -1)
	{
			effect eCheck = GetFirstEffect(oRescuer);
			while (GetIsEffectValid(eCheck))
			{
				if (GetEffectType(eCheck) == EFFECT_TYPE_RESCUE)
				{
					RemoveEffect(oRescuer, eCheck);
				}
				
				eCheck = GetNextEffect(oRescuer);
			}
			return FALSE;
	}
	// Didn't find any Rescue effects, so turn it on.
	else
	{
			effect eRescue = EffectRescue(GetSpellId());
		effect eDur    = EffectVisualEffect(VFX_DUR_RESCUER);
		eRescue = EffectLinkEffects(eRescue, eDur);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eRescue, oRescuer);
			return TRUE;
	}
}

void RunRescue(object oRescuer, int iSpellId)
{
	if ( !CanRescue( oRescuer ) )
	{
		return;
	}
	
	// Make sure we still have an active Rescue Mode effect
	int nRescueSpellId = SCFindEffectSpellId(EFFECT_TYPE_RESCUE);
	if (nRescueSpellId != iSpellId)
	{   // Exit out if Rescue Mode is off.
			return;
	}
	
	float fDuration = 4.0;  // 4 seconds for each pulse.
	location lRescuerLocation = GetLocation(oRescuer);
	
	effect eDR = EffectDamageReduction(2, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE); // DR 2/-
				eDR = ExtraordinaryEffect(eDR);
				
	effect eShare = EffectShareDamage(oRescuer);
				eShare = ExtraordinaryEffect(eShare);
	effect eVFX   = EffectBeam(VFX_BEAM_RESCUEE, oRescuer, BODY_NODE_CHEST);
				eVFX   = ExtraordinaryEffect(eVFX);
	effect eLink  = EffectLinkEffects(eShare, eVFX);
				eLink  = SetEffectSpellId(eLink, iSpellId);
	
	// See if the rescuer has any effects other than the placeholder EFFECT_RESCUE.
	int bRescuerAlreadyHasRescueEffects = FALSE;
	effect eCheck = GetFirstEffect(oRescuer);
	while (GetIsEffectValid(eCheck))
	{
			if (GetEffectSpellId(eCheck) == iSpellId && GetEffectType(eCheck) != EFFECT_TYPE_RESCUE)
			{
				bRescuerAlreadyHasRescueEffects = TRUE;
				break;
			}
			eCheck = GetNextEffect(oRescuer);
	}
	
	// Apply Rescue effects
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lRescuerLocation);
	while (GetIsObjectValid(oTarget))
	{
			if (!GetIsDead(oTarget))
			{
				if (!GetHasSpellEffect(iSpellId, oTarget) || (oTarget == oRescuer && !bRescuerAlreadyHasRescueEffects))
				{   // Target either has no Rescue effects yet, or is the Rescuer who has no real Rescue effects yet.
					if (oTarget == oRescuer)
					{   // Rescuer gets DR
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oTarget, fDuration);
					}
					else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oRescuer))
					{   // Everyone else gets a Share Damage effect
							SignalEvent(oTarget, EventSpellCastAt(oRescuer, iSpellId, FALSE));
							HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId );    // Share damage & VFX
					}
				}
				else
				{   // Refresh Rescue effect durations.
					RefreshSpellEffectDurations(oTarget, iSpellId, fDuration);
				}
			}
	
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lRescuerLocation);
	}
	
	// Schedule the next ping
	DelayCommand(2.5f, RunRescue(oRescuer, iSpellId));
}


void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	if (!CanRescue( OBJECT_SELF ))
	{
		return;
	}
	
	if (ToggleRescue(OBJECT_SELF))
	{
		DelayCommand(0.1f, RunRescue(OBJECT_SELF, GetSpellId()));
	}
}
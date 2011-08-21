//::///////////////////////////////////////////////
//:: Pulse: Lightning
//:: NW_S0_CallLghtn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All creatures within 10ft of the creature take
	1d6 per HD up to 10d6
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes =106884;
	//Declare major variables
	int iDamage;

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_LIGHTNING, SC_SHAPE_BEAM ); 
	int iImpactEffect = HkGetShapeEffect( VFX_IMP_LIGHTNING_S, SC_SHAPE_NONE );
	int iPulseEffect = HkGetShapeEffect( VFX_IMP_PULSE_COLD, SC_SHAPE_NONE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eVis = EffectVisualEffect(iImpactEffect);
	effect eHowl = EffectVisualEffect(iPulseEffect);
	DelayCommand(0.5, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eHowl, GetLocation(OBJECT_SELF)));

	effect eLightning = EffectBeam(iShapeEffect, OBJECT_SELF,BODY_NODE_CHEST);
	float fDelay;
	int iHD = GetHitDice(OBJECT_SELF);
	int iDC = 10 + iHD;
	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		if(oTarget != OBJECT_SELF)
		{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_LIGHTNING, TRUE ));
					//Roll the damage
					iDamage = d6(iHD);
					//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
					//Determine effect delay
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					eHowl = EffectDamage(iDamage, iDamageType);
					if(iDamage > 0)
					{
							//Apply the VFX impact and effects
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget, 0.5));
					}
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
	}
}
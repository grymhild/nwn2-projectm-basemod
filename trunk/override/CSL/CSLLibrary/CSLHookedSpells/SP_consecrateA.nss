//::///////////////////////////////////////////////
//:: Consecrate (OnEnter)
//:: sg_s0_consecratA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation
	Level: Clr 2
	Components: V, S
	Casting Time: 1 action
	Range: Close
	Area: 20-ft. radius emanation
	Duration: 2 hours/level
	Saving Throw: None
	Spell Resistance: No

	This spell blesses an area with positive energy.
	All Charisma checks made to turn undead within
	this area gain a +3 sacred bonus. Undead entering
	this area suffer minor disruption, giving them a
	-1 sacred penalty on attack rolls, damage rolls,
	and saves. Undead cannot be created within or
	summoned into a consecrated area.

	Consecrate counters and dispels Desecrate.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 29, 2004
//:://////////////////////////////////////////////
/*
Evocation
Level: Clr 2
Components: V, S
Casting Time: 1 action
Range: Close
Area: 20-ft. radius emanation
Duration: 2 hours/level
Saving Throw: None
Spell Resistance: No

This spell blesses an area with positive energy.  All Charisma checks made to turn undead within
this area gain a +3 sacred bonus.  Undead entering this area suffer minor disruption, giving them a
-1 sacred penalty on attack rolls, damage rolls, and saves.  Undead cannot be created within or
summoned into a consecrated area.

Consecrate counters and dispels Desecrate.


*/

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_CONSECRATE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	//int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CONSECRATE, FALSE));
	CSLEnviroEntry( oTarget, CSL_ENVIRO_HOLY, GetAreaOfEffectCreator() );
	
	
	/*
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eAttackPenalty = EffectAttackDecrease(1);
	effect eDamagePenalty = EffectDamageDecrease(1);
	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1);
	effect eUndeadLink = EffectLinkEffects(eAttackPenalty, eDamagePenalty);
	eUndeadLink = EffectLinkEffects(eUndeadLink, eSavePenalty);

	effect eImpVis = EffectVisualEffect(VFX_COM_HIT_DIVINE);
	effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CONSECRATE, FALSE));
	if(GetHasSpellEffect(SPELL_DESECRATE, oTarget))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DESECRATE );
	}
	else
	{
		if(GetHasSpellEffect(SPELL_CONSECRATE, oTarget))
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_CONSECRATE );
		}
		if( CSLGetIsUndead(oTarget) )
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eUndeadLink, oTarget);
		}
		else
		{
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
		}
	}
	*/
}
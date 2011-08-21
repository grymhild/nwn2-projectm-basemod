//::///////////////////////////////////////////////
//:: Desecrate (OnEnter)
//:: sg_s0_desecrateA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation
	Level: Clr 2, Evil 2
	Components: V, S
	Casting Time: 1 action
	Range: Close
	Area: 20-ft. radius emanation
	Duration: 2 hours/level
	Saving Throw: None
	Spell Resistance: No

	This spell imbues an area with negative energy.
	All Charisma checks made to turn undead within
	this area suffer a -3 profane penalty. Undead entering
	this area gain a +1 sacred bonus on attack rolls, damage rolls,
	and saves. Undead created within or
	summoned into a consecrated area gain +1 hit
	point per HD.

	Desecrate counters and dispels Consecrate.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 30, 2004
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_DESECRATE;
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
	//int 	iMetamagic 	= HkGetMetaMagicFeat();
	//float 	fDuration; 		//= HkGetSpellDuration(iCasterLevel);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	//int 	iDieType 		= 0;
	//int 	iNumDice 		= 0;
	int 	iBonus 		= 1;
	//int 	iDamage 		= 0;
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DESECRATE, FALSE));
	CSLEnviroEntry( oTarget, CSL_ENVIRO_PROFANE, GetAreaOfEffectCreator() );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	/*
	effect eAttackBonus = EffectAttackIncrease(iBonus);
	effect eDamageBonus = EffectDamageIncrease(iBonus);
	effect eSaveBonus = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus);
	effect eUndeadLink = EffectLinkEffects(eAttackBonus, eDamageBonus);
	eUndeadLink = EffectLinkEffects(eUndeadLink, eSaveBonus);

	effect eImpVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
	effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
	eUndeadLink = EffectLinkEffects(eUndeadLink, eDur);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DESECRATE, FALSE));
	if(GetHasSpellEffect(SPELL_CONSECRATE, oTarget))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_CONSECRATE );
	}
	else
	{
		if( GetHasSpellEffect(SPELL_DESECRATE, oTarget) )
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DESECRATE );
		}
		if( CSLGetIsUndead(oTarget, TRUE) )
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);
		}
		else
		{
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eUndeadLink, oTarget);
		}
	}
	*/
}
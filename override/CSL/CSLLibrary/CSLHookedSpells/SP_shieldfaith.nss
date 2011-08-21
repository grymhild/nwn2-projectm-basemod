//::///////////////////////////////////////////////
//:: Shield of Faith
//:: x0_s0_ShieldFait.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +2 deflection AC bonus, +1 every 6 levels (max +5)
 Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:


// JLR - OEI 08/24/05 -- Metamagic changes


////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHIELD_OF_FAITH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
	int iSpellPower = HkGetSpellPower( oCaster, 30 );
	
	int iValue = HkCapAC( 2 + (iSpellPower)/6 );
	
	effect eAC = EffectACIncrease(iValue, AC_DEFLECTION_BONUS);

	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_SHIELD_OF_FAITH);
	effect eLink = EffectLinkEffects(eAC, eDur);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Fire spell cast at event for target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SHIELD_OF_FAITH, FALSE));
	
	//Apply VFX impact and bonus effects
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_SHIELD_OF_FAITH);

	HkPostCast(oCaster);
}
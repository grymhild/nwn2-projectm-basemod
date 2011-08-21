//::///////////////////////////////////////////////
//:: Guarding the Lord
//:: NW_S2_GuardLord.nss
//:://////////////////////////////////////////////
/*
	Target creature gains +1 Deflection bonus to
	AC, +1 resistance to saves, and takes 30%
	damage.  50% of the original damage is applied
	to the caster of this spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 10, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001



// JLR - OEI 08/23/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_FT_guardingthel();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HoursToSeconds( HkGetSpellDuration( oCaster, 60, CLASS_TYPE_RACIAL ));

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eAC = EffectACIncrease(1, AC_DEFLECTION_BONUS);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
	effect eDmg = EffectShareDamage(oCaster, 30, 50);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
	
	effect eLink = EffectLinkEffects(eAC, eSave);
	eLink = EffectLinkEffects(eLink, eDmg);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = ExtraordinaryEffect(eLink);
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SHIELD_OTHER, FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	
	HkPostCast(oCaster);
}
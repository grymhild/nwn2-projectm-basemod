//::///////////////////////////////////////////////
//:: Shield Other
//:: NW_S0_ShldOther.nss
//:://////////////////////////////////////////////
/*
	Target creature gains +1 Deflection bonus to
	AC, +1 resistance to saves, and takes 1/2
	damage.  Excess damage is applied to the
	caster of this spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 14, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/23/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_shieldother();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHIELD_OTHER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	



	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	float fDuration = HoursToSeconds( HkGetSpellDuration( OBJECT_SELF ) );

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eAC = EffectACIncrease(1, AC_DEFLECTION_BONUS);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
	effect eDmg = EffectShareDamage(OBJECT_SELF);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SHIELD );

	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
	
	effect eLink = EffectLinkEffects(eAC, eSave);
	eLink = EffectLinkEffects(eLink, eDmg);
	eLink = EffectLinkEffects(eLink, eDur);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	
	HkPostCast(oCaster);
}


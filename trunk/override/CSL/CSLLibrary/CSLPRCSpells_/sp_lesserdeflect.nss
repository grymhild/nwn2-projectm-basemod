//::///////////////////////////////////////////////
//:: Name 	Lesser Deflect
//:: FileName sp_deflect.nss
//:://////////////////////////////////////////////
/**@file Lesser Deflect
Abjuration [Force]
Level: Duskblade 1, sorcerer/wizard 1
Components: V
Casting Time: 1 immediate action
Range: Personal
Duration: 1 round or until discharged

You project a field of ivisible force, creating a
short-lived protective barrier. You gain a
deflection bonus to your AC against a single attack;
this bonus is equal to +1 per three caster levels
(maximum +5).

**/


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LESSER_DEFLECT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	
	//fDuration = RoundsToSeconds(1);
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//int nMetaMagic = HkGetMetaMagicFeat();
	int nSpell = HkGetSpellId();
	int nBonus = CSLGetMin(5, (nCasterLvl/3));

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oCaster,FALSE, nSpell, oCaster);

	effect eBonus = EffectACIncrease(AC_DEFLECTION_BONUS, nBonus);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oCaster, fDuration);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}



//::///////////////////////////////////////////////
//:: Name 	Aberrate
//:: FileName sp_aberrate.nss
//:://////////////////////////////////////////////
/**@file Aberrate
Transmutation [Evil]
Level: Sor/Wiz 1
Components: V, S, Fiend
Casting Time: 1 action
Range: Touch
Target: One living creature
Duration: 10 minutes/level
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster transforms one creature into an aberration.
The subject's form twists and mutates into a hideous
mockery of itself. The subject's type changes to
aberration, and it gains a +1 natural armor bonus to
AC (due to the toughening and twisting of the flesh)
for every four levels the caster has, up to a maximum
of +5.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ABERRATE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	object oTarget = HkGetSpellTarget();
	//object oSkin = CSLGetPCSkin(oCaster);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	//float fDur = (600.0f * nCasterLvl);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int bFriendly = TRUE;
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	if(oCaster == oTarget) bFriendly = FALSE;

	int iSpellPower = HkGetSpellPower(oCaster,30);
	int nBonus = CSLGetMax( HkCapAC( iSpellPower/4 ),1) ;
	
	//Signal spell firing
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, bFriendly));
	//SPRaiseSpellCastAt(oTarget, bFriendly, SPELL_ABERRATE, oCaster);

	//if friendly
	if(GetIsReactionTypeFriendly(oTarget, oCaster) ||
	//or failed SR check
	(!HkResistSpell(oCaster, oTarget )))
	{
		//if friendly
		if(GetIsReactionTypeFriendly(oTarget, oCaster) ||
		//or failed save
		(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL)))
		{
			//itemproperty ipRace = ItemPropertyBonusFeat(FEAT_ABERRATION);
			effect eArmor = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
			effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			//AddItemProperty(DURATION_TYPE_TEMPORARY, ipRace, oSkin, fDuration);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArmor, oTarget, fDuration);
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}



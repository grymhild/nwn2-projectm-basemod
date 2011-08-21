//::///////////////////////////////////////////////
//:: Name 	Exalted Raiment
//:: FileName sp_exaltd_raim.nss
//:://////////////////////////////////////////////
/**@file Exalted Raiment
Abjuration
Level: Sanctified 6
Components: V, DF, Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: Robe, garment, or outfit touched
Duration: 1 minute/level
Saving Throw: Will negates (harmless, object)
Spell Resistance: Yes (harmless, object)

You imbue a robe, priestly garment, or outfit of
regular clothing with divine power. The spell bestows
the following effects for the duration:

	- +1 sacred bonus to AC per five caster levels
	(max +4 at 20th level)

	- Damage reduction 10/evil

	- Spell resistance 5 + 1/caster level (max SR 25
	at 20th level

	- Reduces ability damage due to spell casting by 1,
	to a minimum of 1 point (but does not reduce the
	sacrifice cost of this spell).

	Sacrifice: 1d4 points of Strength damage

Author: 	Tenjac
Created: 	6/28/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_ip_srcost"

#include "_HkSpell"
#include "_SCInclude_Necromancy"

int GetERSpellResistance(int nCasterLvl)
{
	int nSRBonus = CSLGetMin(nCasterLvl, 20);
	return CSLSpellIntToResistanceProp( nSRBonus+5 );
}




void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EXALTED_RAIMENT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	
	object oMyArmor = IPGetTargetedOrEquippedArmor(TRUE);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower(oCaster,20);
	int nSR = CSLSpellIntToResistanceProp(iSpellPower+5);
	//float fDur = (60.0f * nCasterLvl);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eArmor = EffectACIncrease( HkCapAC(iSpellPower/5 ), AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
	itemproperty ipArmor = ItemPropertyACBonus( HkCapAC(iSpellPower/5) );
	itemproperty ipDR 	= ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGERESIST_10);
	itemproperty ipSR 	= ItemPropertyBonusSpellResistance(nSR);

	//check to make sure it has no AC
	int nAC = GetBaseAC(oMyArmor);

	//object is valid but has no AC value (clothes, robes, etc).
	if((GetIsObjectValid(oMyArmor)) && (nAC < 1))
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArmor, oMyArmor, fDuration);
		CSLSafeAddItemProperty(oMyArmor, ipSR, fDuration);
		SetLocalInt(oMyArmor, "PRC_Has_Exalted_Raiment", 1);
		DelayCommand(fDuration, DeleteLocalInt(oMyArmor, "PRC_Has_Exalted_Raiment"));
	}

	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d4(1), 0);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




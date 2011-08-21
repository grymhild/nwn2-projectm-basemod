/** @file
* @brief Include file for Dex's changes to arcane archer
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_HkSpell"
#include "_CSLCore_Items"


int SCGetBowType()
{
	int nLauncherBaseItemType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
	if (nLauncherBaseItemType!=BASE_ITEM_LONGBOW && nLauncherBaseItemType!=BASE_ITEM_SHORTBOW) return BASE_ITEM_SHORTBOW;
	return nLauncherBaseItemType;
}

int SCArcaneArcherBonusDamage()
{
	return (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF)+1) / 2;
}

int SCArcaneArcherArrowDamage(int bCrit=FALSE, object oCaster = OBJECT_SELF)
{
	int iDamage;
	int bSpec = FALSE;
	int bGrSpec = FALSE;
	int bEpSpec = FALSE;
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	if (!GetIsObjectValid(oItem)) // NOT VALID ITEM, EXIT NOW
	{
		return 0;
	}
	if (GetBaseItemType(oItem)==BASE_ITEM_LONGBOW)
	{
		iDamage = 8; //d8();
		bSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW, oCaster);
		bGrSpec = GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_LONGBOW, oCaster);
		bEpSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW, oCaster);
	}
	else if (GetBaseItemType(oItem)==BASE_ITEM_SHORTBOW)
	{
		iDamage = 6; //d6();
		bSpec = GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW, oCaster);
		bGrSpec = GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_SHORTBOW, oCaster);
		bEpSpec = GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW, oCaster);
	}
	else
	{
		return 0; // NOT VALID BOW, EXIT NOW
	}
	iDamage += GetAbilityModifier(ABILITY_STRENGTH, oCaster);
	if (bSpec) iDamage +=2;
	if (bGrSpec) iDamage +=2;
	if (bEpSpec) iDamage +=2;
	if (bCrit) iDamage *=3;
	int iSpellId = GetSpellId();
	if (iSpellId==SPELLABILITY_AA_SEEKER_ARROW_1 || iSpellId==SPELLABILITY_AA_SEEKER_ARROW_2 || iSpellId==SPELLABILITY_AA_ARROW_OF_DEATH)
	{
		int nMultiplier = 2;
		int iCasterLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oCaster);
		if (iCasterLevel>5) nMultiplier += iCasterLevel / 5;
		iDamage *= nMultiplier;
	}
	return iDamage;
}

void SCArcaneArcherArrowLaunch(object oCaster, object oTarget, float fTravelTime, int iTouch, int nPathType, int iDamageType) {

	location lTarget = GetLocation(oTarget);
	location lSource = GetLocation(oCaster);
	int nAttackResult = OVERRIDE_ATTACK_RESULT_MISS;

	if (iTouch!=TOUCH_ATTACK_RESULT_MISS)
	{
		int bCrit = (iTouch==TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT));
		if (bCrit)
		{
			nAttackResult = OVERRIDE_ATTACK_RESULT_CRITICAL_HIT;
		}
		else
		{
			nAttackResult = OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL;
		}
		int iDamage = SCArcaneArcherArrowDamage(bCrit, oCaster);
		int iBonus = SCArcaneArcherBonusDamage();
		int nDamagePower = CSLGetDamagePowerConstantFromNumber(iBonus);
		int bIgnoreResistance = (iBonus>5);
		if (bCrit)
		{
			iBonus *= 3;
		}
		effect ePhysical = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING, nDamagePower, bIgnoreResistance);
		effect eMagic = EffectDamage(iBonus, DAMAGE_TYPE_MAGICAL, nDamagePower, bIgnoreResistance);
		DelayCommand(fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget));
		DelayCommand(fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget));
	}
	SpawnItemProjectile(oCaster, oTarget, lSource, lTarget, BASE_ITEM_LONGBOW, nPathType, nAttackResult, iDamageType);
}
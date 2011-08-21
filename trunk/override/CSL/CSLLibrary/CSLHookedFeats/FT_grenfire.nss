//::///////////////////////////////////////////////
//:: Alchemists fire
//:: x0_s3_alchem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grenade.
	Fires at a target. If hit, the target takes
	direct damage. If missed, all enemies within
	an area of effect take splash damage.

	HOWTO:
	- If target is valid attempt a hit
		- If miss then MISS
		- If hit then direct damage
	- If target is invalid or MISS
		- have area of effect near target
		- everyone in area takes splash damage
*/

#include "_HkSpell"
//#include "_CSLCore_Items"
#include "_SCInclude_Trap"


void AddFlamingEffectToWeapon(object oTarget, float fDuration) {
	//forget the fancy on-hit spell and just go with elemental damage item property.
	string sTag = GetStringLowerCase(GetTag(GetSpellCastItem()));

	int iBonus = IP_CONST_DAMAGEBONUS_1d4;
	if      (sTag=="n2_it_alch_2") iBonus = IP_CONST_DAMAGEBONUS_1d6;
	else if (sTag=="n2_it_alch_3") iBonus = IP_CONST_DAMAGEBONUS_1d8;
	else if (sTag=="n2_it_alch_4") iBonus = IP_CONST_DAMAGEBONUS_1d10;

	itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, iBonus);

	CSLSafeAddItemProperty(oTarget, ipFlame, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	CSLSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
	return;
}

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	//Declare major variables
	object oCaster = OBJECT_SELF;
	effect eVis = EffectVisualEffect(VFX_COM_HIT_FIRE);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	object oTarget = HkGetSpellTarget();
	int nTarget = GetObjectType(oTarget);
	int iDuration = 4;
	int iCasterLevel = 1;

	if (nTarget==OBJECT_TYPE_ITEM)
	{
		if (CSLItemGetIsMeleeWeapon(oTarget))
		{
			if (GetIsObjectValid(oTarget))
			{
				SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oTarget), HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				AddFlamingEffectToWeapon(oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				return;
			}
		}
		else
		{
			FloatingTextStrRefOnCreature(100944, oCaster);
		}
	}
	else if(nTarget==OBJECT_TYPE_CREATURE)
	{
		string sTag = GetStringLowerCase(GetTag(GetSpellCastItem()));
		int nDmg = 0;
		int nSplashDmg = 0;
		if (sTag=="x1_wmgrenade002")
		{
			nDmg = d6(1);
			nSplashDmg = 1;
		}
		else if (sTag=="n2_it_alch_2")
		{
			nDmg = d8(1);
			nSplashDmg = 2;
		}
		else if (sTag=="n2_it_alch_3")
		{
			nDmg = d10(1);
			nSplashDmg = d4(1);
		}
		else if (sTag=="n2_it_alch_4")
		{
			nDmg = d6(2);
			nSplashDmg = d4(1) + 1;
		}
		SCDoGrenade(nDmg, nSplashDmg, VFX_HIT_SPELL_FIRE, VFX_HIT_AOE_FIRE, DAMAGE_TYPE_FIRE, RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE);
	}
}
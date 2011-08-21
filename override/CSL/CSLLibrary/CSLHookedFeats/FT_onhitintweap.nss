//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: x2_s3_onhitcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Items"
#include "_SCInclude_IntWeapon"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_HOSTILE;

	object oItem;        // The item casting triggering this spellscript
	object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
	object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

	// fill the variables
	oSpellOrigin = OBJECT_SELF;
	oSpellTarget = HkGetSpellTarget();
	oItem        =  GetSpellCastItem();

	if (GetIsObjectValid(oItem))
	{
		//-----------------------------------------------------------------------
		// we only care for creatures
		//-----------------------------------------------------------------------
		if (GetObjectType(oSpellTarget) != OBJECT_TYPE_CREATURE)
		{
				return;
		}

		//-----------------------------------------------------------------------
		// Only if this weapon is an intelligent weapon, fire up interj. code
		//-----------------------------------------------------------------------
		if (CSLItemGetIsIntelligentWeapon(oItem))
		{
			IWPlayRandomHitQuote(oSpellOrigin,oItem,oSpellTarget);
		}
	}
}
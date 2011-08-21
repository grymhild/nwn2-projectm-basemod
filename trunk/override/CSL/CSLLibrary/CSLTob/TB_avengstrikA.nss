//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/13/2009									//
//	Name: TB_avengingstriA							//
//	Description: As a swift action, grants the		//
//	player their CHA bonus against evil outsiders	//
//	for one round.									//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "tob_x2_inc_itemprop"


#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	int nUses = GetLocalInt(oPC, "AvengingStrikeUses");

	if ((nUses > 0) && !HkSwiftActionIsActive(oPC) )
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

		if (oWeapon == OBJECT_INVALID)
		{
			oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS);
		}

		int nMyCHA = GetAbilityModifier(ABILITY_CHARISMA);
		int nPlus = TOBGetDamageByDamageBonus(nMyCHA);
		itemproperty ipDamage = ItemPropertyEnhancementBonusVsRace(RACIAL_TYPE_OUTSIDER, nPlus);

		effect eAvStrike = EffectNWN2SpecialEffectFile("ror_blue_eyes_con1", oPC);
		eAvStrike = SupernaturalEffect(eAvStrike);

		CSLSafeAddItemProperty(oWeapon, ipDamage, 3.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAvStrike, oPC, 3.0f);
		SetLocalInt(oPC, "AvengingStrikeUses", nUses - 1);
		TOBRunSwiftAction(213, "F");
	}
	else SendMessageToPC(oPC, "<color=red>You must rest before you can use Avenging Strike again.</color>");
}
//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 9/4/2009							//
//	Title: TB_bo_searingblade					//
//	Description: Swift Action; Adds 2d6+1	//
//	per iniator level fire damage for one	//
//	round.									//
//////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_variables"
//#include "bot9s_inc_maneuvers"
//#include "tob_i0_spells"
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
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------

	if ( !HkSwiftActionIsActive(oPC) )
	{
		object oMyWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		int nNumber = d6(2) + TOBGetInitiatorLevel(oPC);
		int nDamage = CSLGetDamageBonusConstantFromNumber(nNumber);

		if (GetIsObjectValid(oMyWeapon))
		{
		//	itemproperty ipFire = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nDamage);
			itemproperty ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
			CSLSafeAddItemProperty(oMyWeapon, ipVis, 6.0f, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		//	CSLSafeAddItemProperty(oMyWeapon, ipFire, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		// Removed due to a weird bug that ocurred when the PC died that prevented the removal of the damage property.
			effect eFire = EffectDamageIncrease(nDamage, DAMAGE_TYPE_FIRE);
			eFire = SupernaturalEffect(eFire);
			eFire = SetEffectSpellId(eFire, 6541); // spells 2da placeholder for boosts

			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, 6541 );

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 6.0f);
			TOBRunSwiftAction(23, "B");
			TOBExpendManeuver(23, "B");
		}
		else SendMessageToPC(oPC, "<color=red>You must have a weapon equipped.</color>");
	}
}

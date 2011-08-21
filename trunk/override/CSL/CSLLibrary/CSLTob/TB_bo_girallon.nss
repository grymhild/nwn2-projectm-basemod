//////////////////////////////////////////////////////////////////
//	Author: Drammel												//
//	Date: 10/29/2009											//
//	Title: TB_bo_girallon											//
//	Description: If you strike an opponent multiple times during//
// your turn, you also deal rend damage. This damage is based //
// on the number of times you strike your opponent during your //
// turn. For two successful attacks you deal 8d6 rending 	//
// damage. For three attacks 10d6, for four 12d6, for five 	//
// 14d6, for six 16d6, for seven 18d6, and for eight and above //
// 20d6. The rend damage is dealt six seconds after you 		//
// initiate this maneuver. If you attack multiple opponents 	//
// during your turn, you gain this extra damage against each of//
// them. A creature takes rend damage based on the number of 	//
// attacks that hit it, not the number of successful attacks 	//
// you make. For example, if you hit a fire giant three times //
// and an evil cleric twice during your turn, the fire giant 	//
// takes rend damage for three attacks and the cleric takes 	//
// rend damage for two attacks. 							//
//////////////////////////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_TomeBattle"
	// Hit tracking and number of objects are handled in bot9s_inc_maneuvers.
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"

void CleanUp()
{
	object oPC = OBJECT_SELF;

	int n;
	object oFoe;

	n = 1;
	oFoe = GetLocalObject(oPC, "GirallonFoe" + IntToString(n));

	while (GetIsObjectValid(oFoe))
	{
		DeleteLocalObject(oPC, "GirallonFoe" + IntToString(n));
		DeleteLocalInt(oPC, "GirallonHits" + IntToString(n));

		n++;
		oFoe = GetLocalObject(oPC, "GirallonFoe" + IntToString(n));
	}
}

void GirallonWindmillFleshRip(object oOffHand, object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID)
{	
	int nDamageType = CSLGetWeaponDamageType(oOffHand); // One is just as good as the other for this maneuver.
	int nStr; // The actual rend is defined by the fact that it adds Str + 1.5 damage to an attack.

	nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	nStr += FloatToInt(IntToFloat(nStr) * 1.5f);

	DeleteLocalInt(oPC, "Girallon");
	TOBBasicAttackAnimation(oOffHand, 1, TRUE, TRUE);

	object oFoe;
	int n, nDamage, nHits;
	effect eDamage;

	n = 1;
	oFoe = GetLocalObject(oPC, "GirallonFoe" + IntToString(n));

	while (GetIsObjectValid(oFoe))
	{
		nHits = GetLocalInt(oPC, "GirallonHits" + IntToString(n));

		switch (nHits)
		{
			case 0: nDamage = 0;		break;
			case 1: nDamage = 0;		break;
			case 2: nDamage = d6(8) + nStr;		eDamage = EffectDamage(nDamage, nDamageType);	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);	break;
			case 3: nDamage = d6(10) + nStr;	eDamage = EffectDamage(nDamage, nDamageType);	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);	break;
			case 4: nDamage = d6(12) + nStr;	eDamage = EffectDamage(nDamage, nDamageType);	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);	break;
			case 5: nDamage = d6(14) + nStr;	eDamage = EffectDamage(nDamage, nDamageType);	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);	break;
			case 6: nDamage = d6(16) + nStr;	eDamage = EffectDamage(nDamage, nDamageType);	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);	break;
			case 7: nDamage = d6(18) + nStr;	eDamage = EffectDamage(nDamage, nDamageType);	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);	break;
			default:nDamage = d6(20) + nStr;	eDamage = EffectDamage(nDamage, nDamageType);	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oFoe);	break;
		}

		n++;
		oFoe = GetLocalObject(oPC, "GirallonFoe" + IntToString(n));
	}

	CleanUp();
}

void CheckOverride(object oOffHand, object oPC, object oToB )
{
	object oPC = OBJECT_SELF;

	if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
	{
		DelayCommand(0.1f, CheckOverride(oOffHand,oPC,oToB));
	}
	else
	{
		SetLocalInt(oPC, "Girallon", 1);
		TOBManageCombatOverrides(TRUE);
		DelayCommand(6.0f, TOBProtectedClearCombatOverrides(oPC));
		DelayCommand(6.0f, GirallonWindmillFleshRip( oOffHand, oPC, oToB ));
	}
}

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	if (GetIsObjectValid(oOffHand))
	{
		if ( !HkSwiftActionIsActive(oPC) )
		{
			if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
			{
				DelayCommand(0.1f, CheckOverride( oOffHand,oPC,oToB )); //Added so that hit tracking doesn't stop in the middle of the maneuver's duration.
			}
			else
			{
				SetLocalInt(oPC, "Girallon", 1);
				TOBManageCombatOverrides(TRUE);
				DelayCommand(6.0f, TOBProtectedClearCombatOverrides(oPC));
				DelayCommand(6.0f, GirallonWindmillFleshRip(oOffHand,oPC,oToB));
			}

			TOBRunSwiftAction(172, "B");
			TOBExpendManeuver(172, "B");
		}
	}
	else SendMessageToPC(oPC, "<color=red>Girallon Windmill Flesh Rip requires you to be equipped with two weapons before you can initiate it.</color>");
}

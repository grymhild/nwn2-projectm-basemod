//ga_leave_encounter
//this script fires when the player leaves an encounter.
//If this is being fired after a successful encounter, nVictory should be 1.
//If the party is fleeing, it should be 0.
//#include "ginc_overland"
//
#include "_CSLCore_Math"
#include "_SCInclude_Overland"
#include "_SCInclude_Group"

void main(int bVictory)
{
	object oPC = GetPCSpeaker();
	
	int nEnemy = 1;
	int nItem = 1;
	int nPlaceable = 1;
	int nAoE = 1;
	
	object oGroundItem	= GetNearestObject(OBJECT_TYPE_ITEM, oPC, nItem);
	object oCreature	= GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_BOTH, oPC, nEnemy);
	object oPlaceable	= GetNearestObject(OBJECT_TYPE_PLACEABLE, oPC, nPlaceable);
	object oAoE			= GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oPC);
	
	/*	Destroy any hostile creatures which are still alive.	*/
	while(GetIsObjectValid(oCreature))			
	{
		if(!GetFactionEqual(oCreature, oPC))	//Don't delete members of the Player Faction, because that will make the player sad.
		{
			//PrettyDebug("Removing remaining creatures.");
			object oItem = GetFirstItemInInventory(oCreature);
			while(GetIsObjectValid(oItem))
			{
				//PrettyDebug("Removing Item from Creature");
				DestroyObject(oItem, 0.2f);
				oItem = GetNextItemInInventory(oCreature);
			}
			DestroyObject(oCreature, 0.5f);
		}
		nEnemy++;
		oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,CREATURE_ALIVE_BOTH, oPC, nEnemy);
	}

	/*	Destroy all items which are lying on the ground.	*/	
	while (GetIsObjectValid(oGroundItem))
	{
		//PrettyDebug("Removing trash.");
		DestroyObject(oGroundItem, 0.5f);
		nItem++;
		oGroundItem = GetNearestObject(OBJECT_TYPE_ITEM, oPC, nItem);
	}
	
	/*	Destroy any Placeables containing items	*/
	while (GetIsObjectValid(oPlaceable))
	{
		if(GetHasInventory(oPlaceable))
		{
			object oItem = GetFirstItemInInventory(oPlaceable);
			while(GetIsObjectValid(oItem))
			{
				//PrettyDebug("Removing Item from Placeable Container");
				DestroyObject(oItem, 0.2f);
				oItem = GetNextItemInInventory(oPlaceable);
			}
			
			//PrettyDebug("Removing placeable with inventory.");
			DestroyObject(oPlaceable, 0.5f);
		}
		
		nPlaceable++;
		oPlaceable = GetNearestObject(OBJECT_TYPE_PLACEABLE, oPC, nPlaceable);
	}
	
	while(GetIsObjectValid(oAoE))
	{
		object oAoECreator = GetAreaOfEffectCreator(oAoE);
		if( GetFactionEqual(oAoECreator, oPC) == FALSE || GetAreaOfEffectDuration(oAoE) != DURATION_TYPE_PERMANENT )
		{
			//PrettyDebug("Removing AoE.");
			DestroyObject(oAoE, 0.5f);
		}
		nAoE++;
		oAoE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oPC, nAoE);
	}	
	SCResetGroup(ENC_GROUP_NAME_1);
	SCResetGroup(ENC_GROUP_NAME_2);
	SCResetGroup(ENC_GROUP_NAME_3);
	SCResetGroup(ENC_GROUP_NAME_4);
	SCResetGroup(ENC_GROUP_NAME_5);
	
	if(GetLocalInt(GetArea(OBJECT_SELF), "bMated"))
	{
		if(SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_1, TRUE) == FALSE &&
			SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_2, TRUE) == FALSE &&
			SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_3, TRUE) == FALSE &&
			SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_4, TRUE) == FALSE &&
			SCGetIsGroupValid("COMBATANT_2" + ENC_GROUP_NAME_5, TRUE) == FALSE )
		{
			object oCombatant2 = GetLocalObject(GetArea(OBJECT_SELF), "oCombatant2");
			if( GetTag(oCombatant2) != "nx2_ac_caravan1" || GetTag(oCombatant2) != "nx2_ac_caravan2" || GetTag(oCombatant2) != "nx2_ac_caravan3" )
			{
//				effect eDamage = EffectDamage(GetCurrentHitPoints(oCombatant2));
//				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCombatant2);
			}
			else if(GetIsObjectValid(oCombatant2)) 
			{
				DestroyObject(oCombatant2);
			}
		}
		
		SCResetGroup("COMBATANT_2" + ENC_GROUP_NAME_1);
		SCResetGroup("COMBATANT_2" + ENC_GROUP_NAME_2);
		SCResetGroup("COMBATANT_2" + ENC_GROUP_NAME_3);
		SCResetGroup("COMBATANT_2" + ENC_GROUP_NAME_4);
		SCResetGroup("COMBATANT_2" + ENC_GROUP_NAME_5);
	}
	
	if(bVictory)												//This section, which awards Bonus XP, is only run for victory.
	{
		object oArea = GetArea(OBJECT_SELF);
		int nEncounterEL = GetLocalInt(oArea, "nEncounterEL");
		if( nEncounterEL > 0)
		{
			int nPartyCR = GetPartyChallengeRating();
			//PrettyDebug("EL:" + IntToString(nEncounterEL) + ", Party CR:" + IntToString(nPartyCR));
			int nXP = GetEncounterXP(nPartyCR, nEncounterEL);
			
			if(GetLocalInt(GetArea(OBJECT_SELF), "bMated"))
				nXP /= 10;
				
			//PrettyDebug("nXP:" + IntToString(nXP));
			AwardEncounterXP(nXP);
			SetLocalInt(GetArea(OBJECT_SELF), "nEncounterEL", 0);
			SetLocalInt(GetArea(OBJECT_SELF), "bMated", FALSE);
		}
	}
	
	else
	{
		CSLIncrementGlobalInt("00_nYellowDragonCount", 1);
		if(GetGlobalInt("00_nYellowDragonCount") >= 50 && GetGlobalInt("00_bYellowDragon") == FALSE)
		{
			object oMember	= GetFirstFactionMember(oPC, FALSE);
	
			while (GetIsObjectValid(oMember))
			{
				FeatAdd(oMember, FEAT_EPITHET_YELLOW_DRAGON, FALSE, TRUE, TRUE);
				oMember		= GetNextFactionMember(oPC, FALSE);
			}
			
			SetGlobalInt("00_bYellowDragon", TRUE);
		}
		
		if (GetLocalInt(GetArea(OBJECT_SELF), "bMated"))
		{
			object oCombatant2 = GetLocalObject(GetArea(OBJECT_SELF), "oCombatant2");
			if( GetTag(oCombatant2) != "nx2_ac_caravan1" || GetTag(oCombatant2) != "nx2_ac_caravan2" || GetTag(oCombatant2) != "nx2_ac_caravan3" )
			{
				effect eDamage = EffectDamage(GetCurrentHitPoints(oCombatant2));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCombatant2);
			}
		}
		/*
		if( CSLIncrementGlobalInt("00_nYellowDragonCount", 1) >= 50)
		{
			object oMember	= GetFirstFactionMember(oPC, FALSE);
	
			while (GetIsObjectValid(oMember))
			{
				FeatAdd(oMember, FEAT_EPITHET_YELLOW_DRAGON, FALSE);
				oMember		= GetNextFactionMember(oPC, FALSE);
			}
		}
		*/
	}
	if(GetIsPC(oPC))
	{
		//PrettyDebug("Restoring Overland Map position.");
		RestorePlayerMapLocation(oPC);
	}
	
}
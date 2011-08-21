// NW_C2_DEFAULT9
/*
	Default OnSpawn handler
 
	To create customized spawn scripts, use the "Custom OnSpawn" script template. 
*/
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 12/11/2002
//:://////////////////////////////////////////////////
//:: Updated 2003-08-20 Georg Zoeller: Added check for variables to active spawn in conditions without changing the spawnscript
// ChazM 6/20/05 ambient anims flag set on spawn for encounter cratures.
// ChazM 1/6/06 modified call to WalkWayPoints()
// DBR 2/03/06  Added option for a spawn script (AI stuff, but also handy in general)
// ChazM 8/22/06 Removed reference to "kinc_globals".
// ChazM 3/8/07 Added campaign level creature spawn modifications script.  Moved excess commented code out to template.
// ChazM 4/5/07 Incorporeal creatures immune to non magic weapons
// Carpot 4/13/08 attempt to blend Seed's version of nw_c2_default9 as it hasn't been maintained through patches
// at least one patch at least, 1.12

#include "_CSLCore_Strings"
#include "_CSLCore_Visuals"
// Seed eliminated default drops, thus removed x0_i0_treasure
// However, CD Aulepp's random treasure scripts didn't, thus, might be dependant upon them
// Hence, I may need to put it back in 
// #include "x0_i0_treasure"
#include "x2_inc_switches"
// Seed adds three DEX2 customized inclusions
#include "_SCInclude_Encounter"


#include "_SCInclude_AI"
#include "_SCInclude_Treasure"


void VariableCreateAndEquip(string sVariable, int iSlot)
{
   object oMinion = OBJECT_SELF;
   object oItem = OBJECT_INVALID;
   string sResRef = GetLocalString(oMinion, sVariable);
   sResRef = CSLNth_GetRandomElement(sResRef);
   if (sResRef!="")
   {
	oItem = CreateItemOnObject(sResRef, oMinion);
	ClearAllActions(TRUE);
	DelayCommand(0.3, ActionEquipItem(oItem, iSlot));
   }
}

void AddDamage(object oMinion) {
   if (GetIsDead(oMinion)) return;
   object oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oMinion);
   if (oItem==OBJECT_INVALID) {
	DelayCommand(3.0, AddDamage(oMinion));
	return;
   }
   int iDamageType = CSLPickOneInt(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGETYPE_SONIC); 
   AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(iDamageType, IP_CONST_DAMAGEBONUS_2d4), oItem);
}

void main()
{
	object oCreature = OBJECT_SELF;
	string sTag = GetTag(oCreature);	
	
	if (GetLocalInt(oCreature, "X2_L_SPAWN_USE_SEARCH") == TRUE) 
	{
		SCSetSpawnInCondition(CSL_FLAG_SEARCH);
	}
	
	if (GetLocalInt(oCreature, "X2_L_SPAWN_USE_AMBIENT_IMMOBILE") == TRUE) 
	{
		SCSetSpawnInCondition(CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
	}
	
	if (GetLocalInt(oCreature, "X2_L_SPAWN_USE_AMBIENT") == TRUE) 
	{
		SCSetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS);
	}
	
	if (GetLocalInt(oCreature, "X2_L_SPAWN_USE_STEALTH") == TRUE) 
	{
		SCSetSpawnInCondition(CSL_FLAG_STEALTH);
	}
	
	// transitions flags set in the module to use spawn in conditions
	if (GetLocalInt(oCreature, "flee_yes") ) 
	{
		SCSetSpawnInCondition(CSL_FLAG_FLEE, TRUE, oCreature);
	}
	
	// vastly reduce how often random spawns dispel players
	if ( !CSLGetIsBoss(oCreature) && d20() < 20 )
	{
		SetLocalInt(oCreature, "X2_HENCH_DO_NOT_DISPEL", TRUE );
	}
	
	// * Civilized creatures with this flag set will randomly use a few voicechats. It's a good
	// * idea to avoid putting this on multiple creatures using the same voiceset.
	if (d100()==1) CSLSetAnimationCondition(CSL_ANIM_FLAG_CHATTER);
	
	
	// ***** DEFAULT GENERIC BEHAVIOR (DO NOT TOUCH) ***** //
	
	// * Goes through and sets up which shouts the NPC will listen to.
	// *
	SCSetListeningPatterns();
	
	// * Walk among a set of waypoints.
	// * 1. Find waypoints with the tag "WP_" + NPC TAG + "_##" and walk
	// *    among them in order.
	// * 2. If the tag of the Way Point is "POST_" + NPC TAG, stay there
	// *    and return to it after combat.
	//
	// * Optional Parameters:
	// * void WalkWayPoints(int nRun = FALSE, float fPause = 1.0)
	//
	// * If "CSL_FLAG_DAY_NIGHT_POSTING" is set above, you can also
	// * create waypoints with the tags "WN_" + NPC Tag + "_##"
	// * and those will be walked at night. (The standard waypoints
	// * will be walked during the day.)
	// * The night "posting" waypoint tag is simply "NIGHT_" + NPC tag.
	SCWalkWayPoints(FALSE, "spawn"); 
	
	// ***** ADD ANY SPECIAL ON-SPAWN CODE HERE ***** //
	
	if (GetIsEncounterCreature())
	{
		
		if (GetSpawnCount(oCreature) > 12) 
		{
			DestroyObject(oCreature);
			return;		
		}
		
		int nCnt = IncSpawnCount(oCreature);
	   
		int nDelay = 120 - CSLGetMin(80, nCnt * 4); // DETERMINE HOW LONG A SPAWN HAS UNTIL DESPAWN IS CALLED, MIN 20 SEC
	
		DelayCommand(nDelay+0.0, Despawn(oCreature));
	
		// if (d4()==1) SetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS, TRUE); // 25% CHANCE OF DOING AMBIENT STUFF
	
		// **** Special Combat Tactics *****//
		// * These are special flags that can be set on creatures to make them follow certain specialized combat tactics.
		// * NOTE: ONLY ONE OF THESE SHOULD BE SET ON A SINGLE CREATURE.
		if (d10()==1) //  10% chance that spawns with Stealth Skills will use them
		{
			int nStealth = GetSkillRank(SKILL_MOVE_SILENTLY) + GetSkillRank(SKILL_HIDE);
			if (nStealth>=GetHitDice(oCreature)) SCSetSpawnInCondition(CSL_FLAG_STEALTH);
			else if (d4()==1) CSLSetCombatCondition(CSL_COMBAT_FLAG_AMBUSHER); // HIT AND RUN STEALTH AMBUSHER
		} 
		else if ( CSLGetIsHoldingRangedWeapon() ) 
		{
			CSLSetCombatCondition(CSL_COMBAT_FLAG_RANGED); // * Will attempt to stay at ranged distance from their target.
		} 
		else if (d10()==1) // * Defensive attacker Will use defensive combat feats and parry
		{
			CSLSetCombatCondition(CSL_COMBAT_FLAG_DEFENSIVE);
		}


		if (!Random(100)) // 1 in 100 will get droppable treasure added and do some special combat stuff
		{
			int iClass = GetClassByPosition(1);
			if (d3()==1 && (iClass==CLASS_TYPE_BARD || iClass==CLASS_TYPE_ROGUE || iClass==CLASS_TYPE_WIZARD || iClass==CLASS_TYPE_SORCERER)) 
			{
				SCTreas_CreateArcaneScroll(oCreature, GetHitDice(oCreature));
			} 
			else if (d3()==1 && (iClass==CLASS_TYPE_CLERIC || iClass==CLASS_TYPE_DRUID || iClass==CLASS_TYPE_ROGUE)) 
			{
				SCTreas_CreateDivineScroll(oCreature, GetHitDice(oCreature));
			} 
			else 
			{
				SCTreas_CreateRandomPotion(oCreature, d3());
			}
		}

		// SPECIAL SPAWN-IN FOR ANIMAL COMPANIONS
		if (sTag=="indadupriest")
		{
			object oMinion = MakeCreature("iriomote", oCreature, FALSE);
			AssignCommand(oMinion, ActionForceFollowObject(oCreature, 1.0));
			DelayCommand(nDelay+0.0, Despawn(oMinion));
		}
		
		if (sTag=="rocktroll" || sTag=="rocktroll_elder" || sTag=="rocktroll_witch" )
		{
			int iRoll = Random(100);
			if ( iRoll > 90 )
			{
				object iHeart = CreateItemOnObject("Dex_trollheart", oCreature);
				SetDroppableFlag (iHeart, TRUE);
				SetPickpocketableFlag (iHeart, TRUE);
				// For testing I will set to identified. Normally the item won't be
				// identified. Change to FALSE after testing.
				SetIdentified (iHeart, TRUE);
			}
		}
		
		if (CSLStringStartsWith(sTag, "drowarcher")) 
		{
			object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
			int nMetal = 29 + d4();
			AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyUnlimitedAmmo(nMetal), oItem);
			AddDamage(oCreature);
		}
	
	
   }

	// * If Incorporeal, apply changes
	if (GetLocalInt(oCreature, "X2_L_IS_INCORPOREAL"))
	{
		effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_NORMAL);
		eConceal = ExtraordinaryEffect(eConceal);
		effect eGhost = EffectCutsceneGhost();
		eGhost = ExtraordinaryEffect(eGhost);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConceal, oCreature);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, oCreature);
	}
	//DBR 2/03/06 - added option for a spawn script (ease of AI hookup)
	string sSpawnScript=GetLocalString(oCreature,"SpawnScript");
	if (sSpawnScript!="")
	{
		ExecuteScript(sSpawnScript,oCreature);
	}
	// Attempt to blend in random treasure per CD Aulepp's scripts here	
	// This line calls out CD Aulepp's random loot system
	//ExecuteScript ("fw_random_loot", oCreature);
	DelayCommand( CSLRandomUpToFloat(),ExecuteScript ("hench_SCPreprocess", oCreature) );
	
}
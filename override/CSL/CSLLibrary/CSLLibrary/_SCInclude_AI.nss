/** @file
* @brief Include File for AI Artificial Intelligence
*
* Using TonyK's AI as a base, heavily reworked 
* 
*
* @ingroup scinclude
* @author TonyK, Brian T. Meyer and others

this file combines the following files

hench_i0_act.nss
hench_i0_ai.nss
hench_i0_assoc.nss
hench_i0_attack.nss
hench_i0_buff.nss
hench_i0_custom.nss
hench_i0_dispel.nss
hench_i0_equip.nss
hench_i0_generic.nss
hench_i0_heal.nss
hench_i0_hensho.nss
hench_i0_initialize.nss
hench_i0_itemsp.nss
hench_i0_melee.nss
hench_i0_monsho.nss
hench_i0_options.nss
hench_i0_spells.nss
hench_i0_strings.nss
hench_i0_target.nss
x0_i0_anims.nss
x0_i0_behavior.nss
//#include "nwn2_inc_spells"
//#include "x0_i0_assoc"
//#include "x0_i0_henchman"
//#include "x0_i0_voice"
//#include "x2_i0_spells"
//#include "ginc_debug"
//#include "x0_i0_equip"
x0_i0_voice
x0_i0_modes
x0_i0_walkway
x0_i0_equip
x0_i0_enemy.nss
x0_i0_match.nss
x0_i0_spawncond.nss
*/

/*

     Companion and Monster AI

    This file is used for global options for AI.

*/


/*
The_Puppeteer 11-27-10

sod_ai_i

This is the fleeing script for scouts, wildlife, merchants, commoners and cowardly bosses.  Setting different variables on the creature will
determine the behavior used by the creature.  This system requires special waypoints to be setup in all areas that contain
creatures using this script.

This script will be separated into proper includes and event scripts eventually.

variables:

int flee_yes  Setting this to 1 will activate the fleeing system.

int flee_boss:  Setting to 1 will make this creature flee to the boss exit waypoint. (wyp_flee_boss)

int flee_wildlife  Setting to 1 will make this creature run about randomly until it is far enough away from hostiles to escape.

int flee_scout  Setting to 1 will cause this creature to move to a rally point. (wyp_flee_scout)

int flee_road  Setting to 1 causes the creature to flee to a transition trigger.

int flee_edge  Setting to 1 has the creature exit off the edge of the map. (wyp_flee_edge)

int flee_commoner  Setting to 1 has the creature run to the safest location.  (wyp_flee_commoner)
*/



//#include "_HkSpell"
#include "_CSLCore_Config_c"
#include "_SCInclude_AI_c"

#include "_CSLCore_Messages"
//#include "nw_i0_generic"	// has CSLSetAssociateState()
//#include "x0_i0_petrify"	// has RemoveEffectOfType()
#include "_CSLCore_Magic"
#include "_CSLCore_UI"
#include "_CSLCore_Items"

#include "_CSLCore_Position"

//#include "x2_inc_itemprop"
//#include "x0_i0_spells"

//#include "x0_i0_match"
#include "x2_inc_switches" // this i am using, does not include anything else
#include "x0_i0_campaign" // keep this include, does not include anything else

//#include "x0_i0_assoc"
//#include "ginc_debug"
//#include "x0_i0_talent"
//#include "ginc_math"

#include "_CSLCore_Info"
#include "_SCInclude_Songs"


#include "_CSLCore_Combat"
#include "_CSLCore_Visuals"

#include "_SCInclude_Doors"

#include "_SCInclude_Waypoints"

#include "_CSLCore_Reputation"
#include "_CSLCore_ObjectArray"

//#include "x0_i0_assoc"

//#include "x0_i0_enemy"
//#include "ginc_debug"
//#include "x2_inc_switches"

//-------------------------------------------------
// Structs
//-------------------------------------------------

// This structure is used to collect the number of enemies and
// allies in a situation and their respective challenge rating.
struct sSituation
{
    int ENEMY_NUM;
    int ALLY_NUM;
    int ENEMY_CR;
    int ALLY_CR;
};


// prefix notation is "r" for structure definition, "o" for instance of structure.
struct rValidTalent
{
     talent tTalent;	// Talent in question 
     // int bUseAtLocation;	// set to true to signal talent to be used at location instead of on object
     object oTarget;	// tareget of the talent
     int bValid;		// FALSE indicates should be treated as TALENT_INVALID (if it existed)
};

struct EldritchTarget
{
	int nAffected;
	object oTarget;	
};

struct EldritchShape
{
	int nSpell;
	object oTarget;
};

// this is the structure that is used to store information about a potential spell to cast
struct sSpellInformation
{
    talent tTalent;
    int spellLevel;
    int spellInfo;
    int spellID;
    int otherID;
    int castingInfo;

    int shape;
    float range;
    float radius;

    object oTarget;
    location lTargetLoc;
};

struct sSpellInformation gsBestDispel;
struct sSpellInformation gsBestBreach;
struct sSpellInformation gsGustOfWind;
struct sSpellInformation gsSpellResistanceReduction;
struct sSpellInformation gsMeleeAttackspInfo;
struct sSpellInformation gsDelayedAttrBuff;
struct sSpellInformation gsPolyAttrBuff;
struct sSpellInformation gsPolymorphspInfo;
struct sSpellInformation gsAttackTargetInfo;  // main global for holding best attack option
struct sSpellInformation gsBuffTargetInfo;  // main global for holding best buff option
struct sSpellInformation gsBestSelfInvisibility;	// best self invisibility
struct sSpellInformation gsBestSelfHide;	// best self hide (early rounds)
struct sSpellInformation gsCurrentspInfo;

// instance Prefix for rTactics is tac
// ex:
// struct rTactics tacAI
struct rTactics
{
	// amount of each to use in decison making
    int nOffense;
    int nCompassion;
    int nMagic;
    int nMagicOld;
	int nStealth;
	
	int bScaredOfSilence;	
	int bTacticChosen;
};


struct sEnhancementLevel
{
	float breach;
	float dispel;
};


// attack and damage information in one place
struct sAttackInfo
{
    int attackBonus;
    int damageBonus;
};

// information about the spells damage
struct sDamageInformation
{
    float amount;
    int damageTypeMask;
    int count;
    int damageType1;
    int damageType2;
    int numberOfDamageTypes;
};

//-------------------------------------------------
// Prototypes
//-------------------------------------------------


void SCAIDetermineCombatRound(object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10, object oCharacter = OBJECT_SELF );

void SCAISpellAttack(int saveType, int iTargetInformation, object oCharacter = OBJECT_SELF);

void SCAISpellAttackSpecial(object oCharacter = OBJECT_SELF);

float SCAIMeleeAttack(object oTarget, int iPosEffectsOnSelf, int bImmobileNoRange, object oCharacter = OBJECT_SELF);

void SCAICombatRound( object oIntruder, object oCharacter = OBJECT_SELF );

void SCAIFireHenchman(object oPC, object oHench=OBJECT_SELF);

void SCAIDoRespawnCheck(object oPC, int nChecks, object oHench=OBJECT_SELF);

void SCAIRespondToShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID, int nBanInventory=FALSE, object oCharacter = OBJECT_SELF );

void SCAIInitCachedCreatureInformation(object oTarget, object oCharacter = OBJECT_SELF);
int SCAIIsCachedCreatureInformationExpired(object oTarget, object oCharacter = OBJECT_SELF);

int SCHenchCheckDetectInvisibility(object oCharacter = OBJECT_SELF);

//-------------------------------------------------
// Function Definitions
//-------------------------------------------------

// Force move to exit WP and destroy self or despawn if roster member
void SCActionForceExit(string sExitTag = "WP_EXIT", int bRun=FALSE)
{
	//location lExitLoc = GetLocation(FindDestinationByTag(sExitTag));
	//ActionForceMoveToLocation(lExitLoc, bRun);
	//object oExit = GetObjectByTag(sExitTag);
	object oExit = GetNearestObjectByTag(sExitTag);
	if (GetIsObjectValid(oExit))
	{
		ActionForceMoveToObject(oExit, bRun);
		ActionDoCommand(SetCommandable(TRUE));
		// SetPlotFlag(OBJECT_SELF,FALSE);
		CSLActionRemoveMyself();
		//ActionDoCommand(DestroyObject(OBJECT_SELF));
		SetCommandable(FALSE);
	}
	else
	{
		CSLActionRemoveMyself();
	}		
}

// Force creature w/ Tag sCreatureTag to move to exit WP and destroy self or despawn if roster member
// requires message which is higher level, need to move to better spot like AI
void SCForceExit(string sCreatureTag, string sWPTag, int bRun=FALSE)
{
	object oCreature = CSLGetTarget(sCreatureTag);
	AssignCommand(oCreature, SCActionForceExit(sWPTag, bRun));
}



// companion or henchman battle cry, called during attack
void SCHenchBattleCry()
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchBattleCry Start", GetFirstPC() ); }
/*
    // left in case anyone wants this
    
    string sName = GetName(oCharacter);
    // Probability of Battle Cry. MUST be a number from 1 to at least 8
    int iSpeakProb = Random(125)+1;
    if (FindSubString(sName,"Sharw") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Take this, fool!"); break;
       case 2: SpeakString("Spare me your song and dance!"); break;
       case 3: SpeakString("To hell with you, hideous fiend!"); break;
       case 4: SpeakString("Come here. Come here I say!"); break;
       case 5: SpeakString("How dare you, impetuous beast?"); break;
       case 6: SpeakString("Pleased to meet you!"); break;
       case 7: SpeakString("Fantastic. Just fantastic!"); break;
       case 8: SpeakString("You CAN do better than this, can you not?"); break;

       default: break;
    }

    if (FindSubString(sName,"Tomi") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Tomi's got a little present for you here!"); break;
       case 2: SpeakString("Poor sod, soon to bite the earth!"); break;
       case 3: SpeakString("Think twice before messing with Tomi!"); break;
       case 4: SpeakString("Tomi's fast; YOU are slow!"); break;
       case 5: SpeakString("Your momma raised ya to become THIS?"); break;
       case 6: SpeakString("Hey! Where's your manners!"); break;
       case 7: SpeakString("Tomi's got a BIG problem with you. Scram!"); break;
       case 8: SpeakString("You're an ugly little beastie, ain't ya?"); break;

       default: break;
    }

    if (FindSubString(sName,"Grim") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Destruction for all!"); break;
       case 2: SpeakString("Embrace Death, and long for it!"); break;
       case 3: SpeakString("My Silent Lord comes to take you!"); break;
       case 4: SpeakString("Be still: your End approaches."); break;
       case 5: SpeakString("Prepare yourself! Your time is near!"); break;
       case 6: SpeakString("Eternal Silence engulfs you!"); break;
       case 7: SpeakString("I am at one with my End. And you?"); break;
       case 8: SpeakString("Suffering ends; but Death is eternal!"); break;
       default: break;
    }

    if (FindSubString(sName,"Dael") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("I'd spare you if you would only desist."); break;
       case 2: SpeakString("It needn't end like this. Leave us be!"); break;
       case 3: SpeakString("You attack us, only to die. Why?"); break;
       case 4: SpeakString("Must you all chase destruction? Very well!"); break;
       case 5: SpeakString("It does not please me to crush you like this."); break;
       case 6: SpeakString("Do not provoke me!"); break;
       case 7: SpeakString("I am at my wit's end with you all!"); break;
       case 8: SpeakString("Do you even know what you face?"); break;
       default: break;
    }

    if (FindSubString(sName,"Linu") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("Oooops! I nearly fell!"); break;
       case 2: SpeakString("What is your grievance? Begone!"); break;
       case 3: SpeakString("I won't allow you to harm anyone else!"); break;
       case 4: SpeakString("Retreat or feel Sehanine's wrath!"); break;
       case 5: SpeakString("By Sehanine Moonbow, you will not pass unchecked."); break;
       case 6: SpeakString("Smite you I will, though unwillingly."); break;
       case 7: SpeakString("Sehanine willing, you'll soon be undone!"); break;
       case 8: SpeakString("Have you no shame? Then suffer!"); break;
       default: break;
    }

    if (FindSubString(sName,"Boddy") == 0)
    switch (iSpeakProb) {
       case 1: SpeakString("You face a sorcerer of considerable power!"); break;
       case 2: SpeakString("I find your resistance illogical."); break;
       case 3: SpeakString("I bind the powers of the very Planes!"); break;
       case 4: SpeakString("Fighting for now, and research for later."); break;
       case 5: SpeakString("Sad to destroy a fine specimen such as yourself."); break;
       case 6: SpeakString("Your chances of success are quite low, you know?"); break;
       case 7: SpeakString("It's hard to argue with these fools."); break;
       case 8: SpeakString("Now you are making me lose my patience."); break;
       default: break;
    } */
}


// monster battle cry, called during attack
void SCMonsterBattleCry()
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCMonsterBattleCry Start", GetFirstPC() ); }

}

// Set a true/false persistent value on oTarget
void SCSetCampaignBooleanValue(object oTarget, string sVarname, int bVal=TRUE)
{
    if (GetIsObjectValid(oTarget) && sVarname != "") {
        SetCampaignDBInt(oTarget, sVarname, bVal);
    }
}



// Set the respawn point to the current location of the caller.
void SCSetRespawnLocation(object oTarget=OBJECT_SELF)
{
    SetLocalLocation(oTarget, "X0_RESPAWN_LOC", GetLocation(oTarget));
}


// Get the current respawn point for the caller
location SCGetRespawnLocation(object oTarget=OBJECT_SELF)
{
    return GetLocalLocation(oTarget, "X0_RESPAWN_LOC");
}


// Set whether an NPC has a one-liner available to make
void SCSetOneLiner(int bHasOneLiner=TRUE, int nLine=0, object oNPC=OBJECT_SELF)
{
    if (bHasOneLiner) {
        SetLocalInt(oNPC, HENCH_ONELINER_VARNAME, nLine);
        //DBG_msg("Setting var " + HENCH_ONELINER_VARNAME
        //    + " to " + IntToString(nLine));
    } else {
        SetLocalInt(oNPC, HENCH_ONELINER_VARNAME, FALSE);
        //DBG_msg("Turning off one-liner");
    }
}

// Call to indicate this NPC has some advice to
// give to this PC and which advice set if so.
void SCSetHasAdvice(object oPC, int bHasAdvice=TRUE, int nAdvice=0, object oNPC=OBJECT_SELF)
{
    if (bHasAdvice) {
        SetLocalInt(oPC, GetTag(oNPC) + "_ADV", nAdvice);
        //DBG_msg("Setting var " + GetTag(oNPC) + "_ADV"
        //    + " to " + IntToString(nAdvice));
    } else {
        SetLocalInt(oPC, GetTag(oNPC) + "_ADV", FALSE);
        //DBG_msg("Turning off advice");
    }
}

// Call to set the interjection value
void SCSetInterjection(object oPC, int nInter=0, object oNPC=OBJECT_SELF)
{
    SetLocalInt(oPC, GetTag(oNPC) + "_INTJ_SET", nInter);
    //DBG_msg("Set var " + GetTag(oNPC) + "_INTJ_SET"
    //        + " to " + IntToString(nInter));
}

// Call to indicate this NPC has an interjection to
// make to this PC right now and which one if so.
void SCSetHasInterjection(object oPC, int bHasInter=TRUE, int nInter=0, object oNPC=OBJECT_SELF)
{
    if (bHasInter) {
        SetLocalInt(oPC, GetTag(oNPC) + "_INTJ", TRUE);
        //DBG_msg("Set var " + GetTag(oNPC) + "_INTJ"
        //    + " to TRUE");
        SetLocalInt(oPC, GetTag(oNPC) + "_INTJ_SET", nInter);
        //DBG_msg("Set var " + GetTag(oNPC) + "_INTJ_SET"
        //    + " to " + IntToString(nInter));
    } else {
        SetLocalInt(oPC, GetTag(oNPC) + "_INTJ", FALSE);
        //DBG_msg("Turned off interjection");
    }
}

// Call to clear all dialogue events
void SCClearAllDialogue(object oPC, object oNPC=OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCClearAllDialogue Start", GetFirstPC() ); }
    // Clear the advice and one-liner for the henchman
    SCSetHasAdvice(oPC, FALSE, 0, oNPC);
    SCSetOneLiner(FALSE, 0, oNPC);

    // This sets the interjection to 0 and then clears the
    // interjection being available
    SCSetInterjection(oPC, 0, oNPC);
    SCSetHasInterjection(oPC, FALSE, 0, oNPC);
}


float SCGetCurrentSpellEffectWeight()
{
    return GetLocalFloat(GetModule(), gsCurrentSpellInfoStr + "EffectWeight");
}

int SCGetCurrentSpellEffectTypes()
{
    return GetLocalInt(GetModule(), gsCurrentSpellInfoStr + "EffectTypes");
}

int SCGetCurrentSpellDamageInfo()
{
    return GetLocalInt(GetModule(), gsCurrentSpellInfoStr + "DamageInfo");
}

int SCGetCurrentSpellSaveType()
{
    return GetLocalInt(GetModule(), gsCurrentSpellInfoStr + "SaveType");
}

int SCGetCurrentSpellSaveDCType()
{
    return GetLocalInt(GetModule(), gsCurrentSpellInfoStr + "SaveDCType");
}












// Find a friend within the given distance and talk to them.
// Returns TRUE on success, FALSE on failure.
int SCAnimActionFindFriend(float fMaxDistance, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionFindFriend Start", GetFirstPC() ); }
	
	// Try and find a friend to talk to
	object oFriend = CSLGetRandomNearbyFriend(fMaxDistance);
	// if no true friends found, look for a quasi-friend
	if (!GetIsObjectValid(oFriend))
		oFriend = CSLGetRandomQuasiFriend(fMaxDistance);
	
	if (GetIsObjectValid(oFriend) && !SCGetIsBusyWithAnimation(oFriend)) 
	{
		int nHDiff = GetHitDice(oCharacter) - GetHitDice(oFriend);
		SCAnimActionStartTalking(oFriend, nHDiff);
		return 1;
	}
    return 0;
}

// Find a placeable within the given distance and interact
// with it.
// Returns TRUE on success, FALSE on failure.
int SCAnimActionFindPlaceable(float fMaxDistance)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionFindPlaceable Start", GetFirstPC() ); }
    
    object oPlaceable = CSLGetRandomObjectByTag("NW_INTERACTIVE", SC_DISTANCE_SHORT);
    if (GetIsObjectValid(oPlaceable)) {
        SCAnimActionStartInteracting(oPlaceable);
        return 1;
    }
    return 0;
}



// If it is night, go back to our home waypoint, if we have one.
// This is only meaningful for mobile NPCs who would have left
// their homes during the day.
// Returns TRUE on success, FALSE on failure.
int SCAnimActionGoHome( object oCharacter = OBJECT_SELF )
{
    object oHome = SCGetCreatureHomeWaypoint();
    if ( GetIsObjectValid(oHome) && !GetIsDay() && GetArea(oCharacter) != GetArea(oHome)) {
        ClearAllActions();
        SCAnimActionGoOutside( oCharacter );
        SCAnimActionGoThroughDoor(GetLocalObject(oCharacter,
                                               "NW_ANIM_DOOR_HOME"));
        return TRUE;
    }
    return FALSE;
}

// If it is day, leave our home area, if we have one.
// This is only meaningful for mobile NPCs.
// Returns TRUE on success, FALSE on failure.
int SCAnimActionLeaveHome(object oCharacter = OBJECT_SELF)
{
    object oHome = SCGetCreatureHomeWaypoint();
    if ( GetIsObjectValid(oHome) && GetIsDay() && GetArea(oCharacter) == GetArea(oHome)) {
        // Find the nearest door and walk out
        ClearAllActions();
        object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
        if (!GetIsObjectValid(oDoor) || GetLocked(oDoor))
            return FALSE;

        object oDest = GetTransitionTarget(oDoor);
        if (GetIsObjectValid(oDest)) {
            SetLocalObject(oCharacter, "NW_ANIM_DOOR_HOME", oDest);
            SCAnimActionGoThroughDoor(oDoor);
            return TRUE;
        }
    }
    return FALSE;
}


// If a PC is in the NPC's home and has not been challenged before,
// challenge them.
// This involves speaking a one-liner conversation from the
// conversation file "x0_npc_homeconv", set above.
// Returns TRUE on success, FALSE on failure.
int SCAnimActionChallengeIntruder( object oCharacter = OBJECT_SELF)
{
    object oHome = SCGetCreatureHomeWaypoint();
    if (GetIsObjectValid(oHome) && GetArea(oCharacter) == GetArea(oHome)) {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
        if (GetIsObjectValid(oPC) && !GetLocalInt(oCharacter, GetName(oPC) + "_CHALLENGED")) {
            ClearAllActions();
            ActionDoCommand(SetFacingPoint(GetPosition(oPC)));
            ActionDoCommand(SpeakOneLinerConversation("x0_npc_homeconv", oPC));
            SetLocalInt(oCharacter, GetName(oPC) + "_CHALLENGED", TRUE);
            return TRUE;
        }
    }
    return FALSE;
}






// Mark the caller as civilized based on its racialtype.
// This will not unset the CSL_ANIM_FLAG_IS_CIVILIZED flag
// if it was set outside.
void SCCheckIsCivilized( object oCharacter = OBJECT_SELF)
{
    int nRacialType = GetRacialType(oCharacter);
    switch (nRacialType)
    {
		case RACIAL_TYPE_DWARF :
		case RACIAL_TYPE_ELF :
		case RACIAL_TYPE_GNOME :
		case RACIAL_TYPE_HALFELF :
		case RACIAL_TYPE_HALFLING :
		case RACIAL_TYPE_HALFORC :
		case RACIAL_TYPE_HUMAN :
		case RACIAL_TYPE_HUMANOID_GOBLINOID :
		case RACIAL_TYPE_HUMANOID_REPTILIAN :
		case RACIAL_TYPE_HUMANOID_ORC:
			CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_CIVILIZED);
    }
}


// TRUE if the given creature has the given mode active
int SCGetModeActive(int nMode, object oCharacter=OBJECT_SELF)
{
	if ( nMode == NW_MODE_STEALTH)
	{
		return GetActionMode(oCharacter,ACTION_MODE_STEALTH);
	}
	else if (nMode ==  NW_MODE_DETECT)
	{
		return GetActionMode(oCharacter,ACTION_MODE_DETECT);
	}
	return (GetLocalInt(oCharacter, "NW_MODES_CONDITION") & nMode);
}

// Mark that the given creature has the given mode active or not
void SCSetModeActive(int nMode, int bActive=TRUE, object oCharacter= OBJECT_SELF)
{

    if (nMode ==  NW_MODE_STEALTH)
    {
        SetActionMode(oCharacter,ACTION_MODE_STEALTH,bActive);
    }
        else if (nMode ==  NW_MODE_DETECT)
    {
        SetActionMode(oCharacter,ACTION_MODE_DETECT,bActive);
    }
    else //dummy
    {
        int nCurrentModes = GetLocalInt(oCharacter, "NW_MODES_CONDITION");
        if (bActive) 
        {
            SetLocalInt(oCharacter, "NW_MODES_CONDITION", nCurrentModes | nMode);
        }
        else
        {
            SetLocalInt(oCharacter, "NW_MODES_CONDITION", nCurrentModes & ~nMode);
        }
    }
}







// Check to see if we should switch on detect/stealth mode
void SCCheckCurrentModes()
{
    //wSpeakString("running check current modes");
    object oWay = GetNearestObject(OBJECT_TYPE_WAYPOINT);
    string sTag = GetTag(oWay);
    if (sTag == "NW_STEALTH")
    {
        if (SCGetModeActive(NW_MODE_STEALTH))
        {
            // turn off stealth mode
            SCSetModeActive(NW_MODE_STEALTH, FALSE);
        }
        else
        {
            // turn on stealth mode
            SCSetModeActive(NW_MODE_STEALTH);
        }
    }
    else if (sTag == "NW_DETECT")
    {
        if (SCGetModeActive(NW_MODE_DETECT))
        {
            // turn off detect mode
            SCSetModeActive(NW_MODE_DETECT);
        }
        else
        {
            // turn on detect mode
            SCSetModeActive(NW_MODE_DETECT);
        }
    }
}


// Check if the creature should be active and turn off if not,
// returning FALSE. This respects the CSL_ANIM_FLAG_CONSTANT
// setting.
int SCCheckIsAnimActive( object oCharacter = OBJECT_SELF )
{
    // Unless we're set to be constant, turn off if there's
    // no PC in the area
    if ( ! CSLGetAnimationCondition(CSL_ANIM_FLAG_CONSTANT))
    {
        object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,  PLAYER_CHAR_IS_PC);
        if ( !GetIsObjectValid(oPC) || GetArea(oPC) != GetArea(oCharacter))
        {
            // turn off
            CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_ACTIVE, FALSE);
            return FALSE;
        }
    }
    return TRUE;
}


// Check to see if we're in the middle of some action
// so we don't interrupt or pile actions onto the queue.
// Returns TRUE if in the middle of an action, FALSE otherwise.
int SCCheckCurrentAction()
{
    int nAction = GetCurrentAction();
    if (nAction == ACTION_SIT)
    {
        // low prob of getting up, so we don't bop up and down constantly
        if (Random(10) == 0)
        {
            SCAnimActionGetUpFromChair();
        }
        return TRUE;
    }
    else if (nAction != ACTION_INVALID)
    {
        // we're doing *something*, don't switch
        return TRUE;
    }
    return FALSE;
}

// General initialization for animations.
// Called from all the Play_* functions.
void SCAnimInitialization(object oCharacter = OBJECT_SELF )
{
    // If we've been set to be constant, flag us as
    // active.

    CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_ACTIVE);

    // Set our home, if we have one
    SCSetCreatureHomeWaypoint();

    // Mark whether we're civilized or not
    SCCheckIsCivilized(oCharacter);

    CSLSetAnimationCondition(CSL_ANIM_FLAG_INITIALIZED);

}



// Perform a mobile action for an uncivilized creature.
// Includes:
// - perform random limited animations
// - walk to an 'NW_STOP' waypoint in the area
// - random walk if none available
void SCAnimActionPlayRandomUncivilized()
{
    int nRoll = Random(6);

    if (nRoll != 5) {
        if (SCAnimActionGoToStop(1000.0))
            return;
        // no stops, so random walk

        ClearAllActions();
        ActionRandomWalk();
    }

    // Play one of our few random animations
    SCAnimActionPlayRandomBasicAnimation();
}






// Avian creatures will fly around randomly.
void SCPlayMobileAmbientAnimations_Avian(object oCharacter = OBJECT_SELF)
{
    int nRoll = d4();
    object oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCharacter, nRoll, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

    ClearAllActions();
    if(GetIsObjectValid(oFriend))
    {
        int nBird = d4();
        if(nBird == 1)
        {
            ActionMoveToObject(oFriend, TRUE);
        }
        else if (nBird == 2 || nBird == 3)
        {
            SCAnimActionRandomMoveAway(oFriend, 100.0);
        }
        else
        {
            effect eBird = EffectDisappearAppear(GetLocation(oFriend));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBird, oCharacter, 4.0);
            SCAnimActionRandomMoveAway(oFriend, 100.0);
        }
    }
    else
    {
        ActionRandomWalk();
    }
}


// Perform a strictly immobile action.
// Includes:
// - turn towards a nearby unoccupied friend and 'talk'
// - turn towards a nearby placeable and interact
// - turn around randomly
// - play a random animation
void SCAnimActionPlayRandomImmobile(object oCharacter = OBJECT_SELF)
{
    int nRoll = Random(12);

    // If we're talking, either keep going or stop.
    // Low prob of stopping, since both parties have
    // a chance and conversations are cool.
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_TALKING))	
	{
        object oFriend = CSLGetCurrentFriend( oCharacter );
        int nHDiff = GetHitDice(oCharacter) - GetHitDice(oFriend);

        if (nRoll == 0) {
            SCAnimActionStopTalking(oFriend, nHDiff);
        } else {
            SCAnimActionPlayRandomTalkAnimation(nHDiff);
        }
        return;
    }

    // If we're interacting with a placeable, either keep going or
    // stop. High probability of stopping, since looks silly to
    // constantly turn something on-and-off.
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_INTERACTING)) {
        if (nRoll < 4)
        {
            SCAnimActionStopInteracting( oCharacter );
        }
        else
        {
            SCAnimActionPlayRandomInteractAnimation(CSLGetCurrentInteractionTarget( oCharacter ));
        }
        return;
    }

    // If we got here, we're not busy at the moment.

    // Clean out the action queue
    ClearAllActions();
    if (nRoll <=9)
    {
        if (SCAnimActionFindFriend(SC_DISTANCE_LARGE))
        {
            return;
        }
    }

    if (nRoll > 9) {
        // Try and interact with a nearby placeable
        if (SCAnimActionFindPlaceable(SC_DISTANCE_SHORT))
        {
            return;
        }
    }

    // Default: clear our action queue and play a random animation
    if ( nRoll < 5 ) {
        // Turn around and play a random animation

        // BK Feb 2003: I got rid of this because I've never seen it look appropriate
        // it always looks out of place and unrealistic
        SCAnimActionPlayRandomAnimation();
    } else {
        // Just play a random animation
        SCAnimActionPlayRandomAnimation();
    }
}


// Perform a random close-range action.
// This will include:
// - any of the immobile actions
// - close any nearby doors, then return to current position
// - go to a nearby placeable and interact with it
// - go to a nearby friend and interact with them
// - walk to a nearby 'NW_STOP' waypoint
// - going back to starting point
void SCAnimActionPlayRandomCloseRange(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionPlayRandomCloseRange Start", GetFirstPC() ); }
    
    if (SCGetIsBusyWithAnimation(oCharacter)) {
        // either we're already in conversation or
        // interacting with something, so continue --
        // all handled already in RandomImmobile.
        SCAnimActionPlayRandomImmobile();
        return;
    }

    // If we got here, we're not busy

    // Clean out the action queue
    ClearAllActions();

    // Possibly close open doors
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_CLOSE_DOORS) && SCAnimActionCloseRandomDoor( oCharacter )) {
        return;
    }

    // For the rest of these, we check for specific rolls,
    // to ensure that we don't do a lot of lookups on any one
    // given pass.

    int nRoll = Random(6);

    // Possibly start talking to a friend
    if (nRoll == 0 || nRoll == 1) {
        if (SCAnimActionFindFriend(SC_DISTANCE_LARGE))
            return;
        // fall through to default
    }

    // Possibly start fiddling with a placeable
    if (nRoll == 2) {
        if (SCAnimActionFindPlaceable(SC_DISTANCE_LARGE))
            return;
        // fall through if no placeable found
    }

    // Possibly sit down
    if (nRoll == 3) {
        if (SCAnimActionSitInChair(SC_DISTANCE_LARGE))
            return;
    }

    // Go to a nearby stop
    if (nRoll == 4) {
        if (SCAnimActionGoToStop(SC_DISTANCE_LARGE)) {
            return;
        }

        // No stops, so do a random walk and then come back
        // to our current location
        ClearAllActions();
        location locCurr = GetLocation(oCharacter);
        ActionRandomWalk();
        ActionMoveToLocation(locCurr);
    }

    if (nRoll == 5 && !CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE)) {
        // Move back to starting point, saved at initialization
        ActionMoveToLocation(GetLocalLocation(oCharacter,
                                              "ANIM_START_LOCATION"));
        return;
    }

    // Default: do a random immobile animation
    SCAnimActionPlayRandomImmobile();
}



// This function should be used for any NPCs that should
// not move around. It should be called by the creature
// that you want to perform the animations.
//
// Creatures who call this function will never leave the
// area they spawned in.
//
// Injured creatures will rest at their starting location.
//
// Creatures who have the CSL_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE
// flag set will move around slightly within the area.
// Creatures in an area with an "interior" waypoint (NW_HOME,
// NW_SHOP, NW_TAVERN) will be set to have this flag automatically.
//
// Close-range creatures will move around the area, frequently
// returning to their starting point, interacting with other
// creatures and placeables. They will visit NW_STOP waypoints
// in their immediate vicinity, and they will close opened doors.
//
// In all other cases, the creature will not move from its starting
// position. They will turn around randomly, turn to and 'talk' to
// other NPCs in their immediate vicinity, and interact with
// placeables in their immediate vicinity.
void SCPlayImmobileAmbientAnimations(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCPlayImmobileAmbientAnimations Start", GetFirstPC() ); }
    
    if (!CSLGetAnimationCondition(CSL_ANIM_FLAG_INITIALIZED)) {
        // General initialization
        SCAnimInitialization( oCharacter );

        // if we are at home, make us mobile in close-range
        if (GetIsObjectValid(SCGetCreatureHomeWaypoint())) {
            CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE);
        }

        // also save our starting location
        SetLocalLocation(oCharacter,
                         "ANIM_START_LOCATION",
                         GetLocation(oCharacter));
    }

    // Short-circuit everything if we're not active yet
    if (!CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_ACTIVE))
        return;



    // Check if we should turn off
    if (!SCCheckIsAnimActive(oCharacter))
        return;



    // Check current actions so we don't interrupt something in progress
    if (SCCheckCurrentAction()) {
        return;
    }
	

    // Check if current modes should change
    SCCheckCurrentModes();


    // Challenge an intruding PC
    if (SCAnimActionChallengeIntruder(oCharacter)) {
        return;
    }

    int bIsCivilized = CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_CIVILIZED);

    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE))
    {
        SCAnimActionPlayRandomCloseRange();
    }
    else 
    {
        SCAnimActionPlayRandomImmobile();
    }
}




// Perform a mobile action.
// Includes:
// - walk to an 'NW_STOP' waypoint in the area
// - walk to an area door and possibly go inside
// - go outside if previously went inside
// - fall through to SC AnimActionPlayRandomCloseRange
void SCAnimActionPlayRandomMobile(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionPlayRandomMobile Start", GetFirstPC() ); }
    
    if (SCGetIsBusyWithAnimation(oCharacter)) {
        // either we're already in conversation or
        // interacting with something, so continue --
        // all handled already in RandomImmobile.
        SCAnimActionPlayRandomImmobile();
        return;
    }

    // If we got here, we're not busy

    // Clean out the action queue
    ClearAllActions();

    int nRoll = Random(9);

    if (nRoll == 0) {
        // If we're inside, possibly leave
        if (SCAnimActionGoOutside( oCharacter ))
            return;
    }

    if (nRoll == 1) {
        // Possibly go into an interior area
        if ( SCAnimActionGoInside( oCharacter ) )
            return;
    }

    // If we fell through or got a random number
    // less than 7, go to a stop waypoint, or random
    // walk if no stop waypoints were found.
    if (nRoll < 5) {
        // Pass in a huge number so any stop will be valid
        if (SCAnimActionGoToStop(1000.0))
            return;

        // If no stops, do a random walk
        ClearAllActions();
        ActionRandomWalk();
        return;
    }

    
    // MODIFIED February 14 2003. Will play an immobile animation, if nothing else found to do

    SCPlayImmobileAmbientAnimations();
}

// This function should be used for mobile NPCs and monsters
// other than avian ones. It should be called by the creature
// that you want to perform the animations.
//
// Creatures will interact with each other and move around,
// possibly even moving between areas.
//
// Creatures who are spawned in an area with the "NW_HOME" tag
// will mark that area as their home, leave from the nearest
// door during the day, and return at night.
//
// Injured creatures will go to the nearest "NW_SAFE" waypoint
// in their immediate area and rest there.
//
// If at any point the nearest waypoint is "NW_DETECT" or
// "NW_STEALTH", the creature will toggle search/stealth mode
// respectively.
//
// Creatures who are spawned in an outdoor area (for instance,
// in city streets) will go inside areas that have one of the
// interior waypoints (NW_TAVERN, NW_SHOP), if those areas
// are connected by an unlocked door. They will come back out
// as well.
//
// Creatures will also move randomly between objects in their
// area that have the tag "NW_STOP".
//
// Mobile creatures will have all the same behaviors as immobile
// creatures, just tending to move around more.
void SCPlayMobileAmbientAnimations_NonAvian(object oCharacter = OBJECT_SELF)
{

    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCPlayMobileAmbientAnimations_NonAvian Start", GetFirstPC() ); }
    
    if (!CSLGetAnimationCondition(CSL_ANIM_FLAG_INITIALIZED)) {
        // General initialization
        SCAnimInitialization( oCharacter );

        // Mark us as mobile
        CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE);
    }

    // Short-circuit everything if we're not active yet
    if (!CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_ACTIVE))
        return;

    // Check if we should turn off
    if (!SCCheckIsAnimActive(oCharacter))
        return;


    int nCurrentAction = GetCurrentAction();

    // Check current actions so we don't interrupt something in progress
    // Feb 14 2003: Because of the random walkthere needs to be a chance
    //  to stop walking.
    // May 26 2004: Added ACTION_RANDOMWALK to the exclusion list.
    if (SCCheckCurrentAction() && (nCurrentAction != ACTION_MOVETOPOINT)&& (nCurrentAction != ACTION_WAIT) && (nCurrentAction != ACTION_RANDOMWALK)) {
        return;
    }

    // Check if current modes should change
    SCCheckCurrentModes();


    int bIsCivilized = CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_CIVILIZED);
    if (bIsCivilized)
    {


        // Challenge an intruding PC
        if (SCAnimActionChallengeIntruder(oCharacter)) {
            return;
        }

        // Check if we should go home
        if (SCAnimActionGoHome()) {
            return;
        }

        // Check if we should leave home
        if (SCAnimActionLeaveHome()) {
            return;
        }

        // Otherwise, do something random
        SCAnimActionPlayRandomMobile();
    } else
    {
        SCAnimActionPlayRandomUncivilized();
    }
}


void SCIntitializeHealingInfo(int bForce, object oCharacter = OBJECT_SELF )
{
	if (bForce)
	{
		gfHealingThreshold = 0.9999;
		giRegenHealScaleAmount = gbAnyValidTarget ? 0 : 3;
		giHealingDivisor = 10000;	
	}
	else
	{	
		gfHealingThreshold = 0.5;
		if (CSLGetAssociateState(CSL_ASC_HEAL_AT_75, oCharacter))
		{
			gfHealingThreshold = 0.75;
		}
		else if (CSLGetAssociateState(CSL_ASC_HEAL_AT_25, oCharacter ))
		{
			gfHealingThreshold = 0.25;
		}
		giRegenHealScaleAmount = gbAnyValidTarget ? 0 : 1;
		giHealingDivisor = gbMeleeAttackers ?  8 : 15;
	}	
}





float SCGetd20Chance(int limit)
{
    limit += 21;
    if (limit >= 20)
    {
        return 1.0;
    }
    if (limit <= 0)
    {
        return 0.0;
    }
    return IntToFloat(limit) / 20.0;
}


float SCGetd20ChanceLimited(int limit)
{
    if (limit <= 1)
    {
        return 0.05;
    }
    if (limit >= 19)
    {
        return 0.95;
    }
    return IntToFloat(limit) / 20.0;
}


float SCGet2d20Chance(int limit)
{
    if (limit <= -20)
    {
        return 0.0;
    }
    if (limit >= 19)
    {
        return 1.0;
    }
    if (limit <= 0)
    {
        limit += 20;
        return IntToFloat((limit + 1) * limit) / 800.0;
    }
    limit = 19 - limit;
    return 1.0 - IntToFloat((limit + 1) * limit) / 800.0;
}




float SCCheckGrappleResult(object oTarget, int nCasterCheck, int nCheckType)
{
    float fResult = 1.0;

    // grapple hit check
    if (nCheckType & GRAPPLE_CHECK_HIT)
    {
        int nGrappleCheck = nCasterCheck - 1 /* large size */ - GetAC(oTarget);
		if (CSLGetHasSizeIncreaseEffect(oTarget))
		{
			nGrappleCheck -= 4;
		}			
        fResult *= SCGetd20Chance(nGrappleCheck);
    }
     // grapple hold check
    if (nCheckType & GRAPPLE_CHECK_HOLD)
    {
        int nGrappleCheck = nCasterCheck + 4 /* large size */ -
            (GetBaseAttackBonus(oTarget) + CSLGetSizeModifierGrapple(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget));
		if (CSLGetHasSizeIncreaseEffect(oTarget))
		{
			nGrappleCheck -= 4;
		}			
        fResult *= SCGet2d20Chance(nGrappleCheck);
    }
    // bull rush
    if (nCheckType & GRAPPLE_CHECK_RUSH)
    {
        int nRushCheck = nCasterCheck -
            (GetAbilityModifier(ABILITY_STRENGTH, oTarget) + CSLGetSizeModifierGrapple(oTarget));
        fResult *= SCGet2d20Chance(nRushCheck);
    }
    // strength
    if (nCheckType & GRAPPLE_CHECK_STR)
    {
        int nStrCheck = nCasterCheck - GetAbilityScore(oTarget, ABILITY_STRENGTH);
        fResult *= SCGet2d20Chance(nStrCheck);
    }
    return fResult;
}


int SCGetCreaturePoisonDC(object oCharacter = OBJECT_SELF)
{
    int nRacial = GetRacialType(oCharacter);
    int nHD = GetHitDice(oCharacter);

    //Determine the poison type based on the Racial Type and HD
    switch (nRacial)
    {
        case RACIAL_TYPE_OUTSIDER:
            if (nHD <= 9)
            {
                return 13; // POISON_QUASIT_VENOM;
            }
            if (nHD < 13)
            {
                return 20; // POISON_BEBILITH_VENOM;
            }
            return 21; // POISON_PIT_FIEND_ICHOR;
        case RACIAL_TYPE_VERMIN:
            if (nHD < 3)
            {
                return 11; // POISON_TINY_SPIDER_VENOM;
            }
            if (nHD < 6)
            {
                return 11; // POISON_SMALL_SPIDER_VENOM;
            }
            if (nHD < 9)
            {
                return 14; // POISON_MEDIUM_SPIDER_VENOM;
            }
            if (nHD < 12)
            {
                return 18; // POISON_LARGE_SPIDER_VENOM;
            }
            if (nHD < 15)
            {
                return 26; // POISON_HUGE_SPIDER_VENOM;
            }
            if (nHD < 18)
            {
                return 36; // POISON_GARGANTUAN_SPIDER_VENOM;
            }
            return 35;  // POISON_COLOSSAL_SPIDER_VENOM;
        default:
            if (nHD < 3)
            {
                return 10; // POISON_NIGHTSHADE;
            }
            if (nHD < 6)
            {
                return 15; // POISON_BLADE_BANE;
            }
            if (nHD < 9)
            {
                return 12; // POISON_BLOODROOT;
            }
            if (nHD < 12)
            {
                return 18; // POISON_LARGE_SPIDER_VENOM;
            }
            if (nHD < 15)
            {
                return 17; // POISON_LICH_DUST;
            }
            if (nHD < 18)
            {
                return 18; // POISON_DARK_REAVER_POWDER;
            }
            return 20; //  POISON_BLACK_LOTUS_EXTRACT;
    }
    return 10;
}


int SCGetCreatureDiseaseDC(int checkType, object oCharacter = OBJECT_SELF)
{
    //Determine the disease type based on the Racial Type and HD
    int nRacial = GetRacialType(oCharacter);
    if (checkType == DISEASE_CHECK_CONE)
    {
        int nHD = GetHitDice(oCharacter);
        switch (nRacial)
        {
            case RACIAL_TYPE_OUTSIDER:
                return 18; // DISEASE_DEMON_FEVER
            case RACIAL_TYPE_VERMIN:
                return 13; // DISEASE_VERMIN_MADNESS
            case RACIAL_TYPE_UNDEAD:
                if(nHD <= 3)
                {
                    return 15; // DISEASE_ZOMBIE_CREEP;
                }
                else if (nHD > 3 && nHD <= 10)
                {
                    return 18; // DISEASE_GHOUL_ROT
                }
                else
                {
                    return 20; // DISEASE_MUMMY_ROT
                }
        }
        if(nHD <= 3)
        {
           return 12; // DISEASE_MINDFIRE
        }
        else if (nHD > 3 && nHD <= 10)
        {
            return 15; // DISEASE_RED_ACHE
        }
        return 13; // DISEASE_SHAKES
    }

    switch (nRacial)
    {
        case RACIAL_TYPE_VERMIN:
            return 13; // DISEASE_VERMIN_MADNESS
        case RACIAL_TYPE_UNDEAD:
            return 12; // DISEASE_FILTH_FEVER
        case RACIAL_TYPE_OUTSIDER:
            if(checkType == DISEASE_CHECK_BOLT && GetTag(oCharacter) == "NW_SLAADRED")
            {
                return 17; // DISEASE_RED_SLAAD_EGGS
            }
            return 18; // DISEASE_DEMON_FEVER
        case RACIAL_TYPE_MAGICAL_BEAST:
            return 25; // DISEASE_SOLDIER_SHAKES
        case RACIAL_TYPE_ABERRATION:
            return 16; // DISEASE_BLINDING_SICKNESS
    }

    if(checkType == DISEASE_CHECK_BOLT)
    {
        return 25; // DISEASE_SOLDIER_SHAKES
    }
    return 12; // DISEASE_MINDFIRE
}


int SCGetCurrentSpellSaveDC(int bFoundItemSpell, int spellLevel, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetCurrentSpellSaveDC Start", GetFirstPC() ); }
    
    int saveDCType = SCGetCurrentSpellSaveDCType();
    int saveDC;

    if (saveDCType < 0)
    {
        saveDC = (bFoundItemSpell ? (spellLevel * 3) / 2 + 10 : giMySpellCasterDC + spellLevel) + saveDCType - HENCH_SAVEDC_SPELL;
    }
    else if (saveDCType < HENCH_SAVEDC_HD_1)
    {
        saveDC = saveDCType;
    }
    else
    {
        switch (saveDCType)
        {
			case HENCH_SAVEDC_HD_1:
				saveDC = 10 + GetHitDice(oCharacter);
				break;
			case HENCH_SAVEDC_HD_2:
				saveDC = 10 + GetHitDice(oCharacter) / 2;
				break;
			case HENCH_SAVEDC_HD_4:
				saveDC = 10 + GetHitDice(oCharacter) / 4;
				break;
			case HENCH_SAVEDC_HD_2_CONST:
				saveDC = 10 + GetHitDice(oCharacter) / 2 + GetAbilityModifier(ABILITY_CONSTITUTION);
				break;
			case HENCH_SAVEDC_HD_2_CONST_MINUS_5:
				saveDC = 10 + GetHitDice(oCharacter) / 2 + GetAbilityModifier(ABILITY_CONSTITUTION) - 5;
				break;
			case HENCH_SAVEDC_HD_2_WIS:
				saveDC = 10 + GetHitDice(oCharacter) / 2 + GetAbilityModifier(ABILITY_WISDOM);
				break;
			case HENCH_SAVEDC_HD_2_PLUS_5:
				saveDC = 10 + GetHitDice(oCharacter) / 2 + 5;	
				break;
			case HENCH_SAVEDC_HD_2_CHA:
				saveDC = 10 + GetHitDice(oCharacter) / 2 + GetAbilityModifier(ABILITY_CHARISMA);
				break;
			case HENCH_SAVEDC_DISEASE_BOLT:
				saveDC = SCGetCreatureDiseaseDC(DISEASE_CHECK_BOLT);
				break;
			case HENCH_SAVEDC_DISEASE_CONE:
				saveDC = SCGetCreatureDiseaseDC(DISEASE_CHECK_CONE);
				break;
			case HENCH_SAVEDC_DISEASE_PULSE:
				saveDC = SCGetCreatureDiseaseDC(DISEASE_CHECK_PULSE);
				break;
			case HENCH_SAVEDC_POISON:
				saveDC = SCGetCreaturePoisonDC();
				break;
			case HENCH_SAVEDC_EPIC:
				if ((gsCurrentspInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK) == HENCH_CASTING_INFO_USE_SPELL_TALENT)
				{
					saveDC = 25 + GetAbilityModifier(ABILITY_CHARISMA);
				}
				else
				{
					// don't need epic DC since it's built into the function itself and includes all bonuses
					saveDC = 25 + GetAbilityModifier(ABILITY_CHARISMA); // HkGetSpellSaveDC( oCharacter, OBJECT_INVALID, gsCurrentspInfo.spellID );
				}
				break;
			case HENCH_SAVEDC_DEATHLESS_MASTER_TOUCH:
				saveDC = 17 + ((GetLevelByClass(CLASS_TYPE_PALEMASTER,oCharacter) > 10) ? ((GetLevelByClass(CLASS_TYPE_PALEMASTER,oCharacter) - 10) / 2) : 0);
				break;
			case HENCH_SAVEDC_UNDEAD_GRAFT:
				saveDC = /* 14 - 5 */ 9 + GetLevelByClass(CLASS_TYPE_PALEMASTER)/2;
				break;
			case HENCH_SAVEDC_SPELL_NO_SPELL_LEVEL:
				saveDC = giMySpellCasterDC;
				break;
			case HENCH_SAVEDC_BARD_SLOWING:
				saveDC =  13 + (giMySpellCasterLevel / 2) + GetAbilityModifier(ABILITY_CHARISMA);
				break;
			case HENCH_SAVEDC_BARD_FASCINATE:
				saveDC =  11 + GetAbilityModifier(ABILITY_CHARISMA);
				break;
			default:
			// shouldn't get here
				saveDC = 15;
        }
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCGetCurrentSpellSaveDC End", GetFirstPC() ); }
    return saveDC;
}




int SCGetCurrentSpellBuffAmount(int casterLevel, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetCurrentSpellBuffAmount Start", GetFirstPC() ); }
    
    int buffInfo = SCGetCurrentSpellDamageInfo();

    int buffAmount = HENCH_SPELL_INFO_BUFF_AMOUNT_MASK & buffInfo;
    int buffType = buffInfo & HENCH_SPELL_INFO_BUFF_MASK;
    switch (buffType)
    {
    case HENCH_SPELL_INFO_BUFF_CASTER_LEVEL:
        break;
    case HENCH_SPELL_INFO_BUFF_HD_LEVEL:
        casterLevel = GetHitDice(oCharacter);
        break;
    case HENCH_SPELL_INFO_BUFF_FIXED:
        return buffAmount;
    case HENCH_SPELL_INFO_BUFF_CHARISMA:
        return GetAbilityModifier(ABILITY_CHARISMA);
    case HENCH_SPELL_INFO_BUFF_DRAGON:
        casterLevel = GetHitDice(oCharacter);
        if (casterLevel > 37)
        {
            casterLevel = 12;
        }
        else if (casterLevel > 33)
        {
            casterLevel = 11;
        }
        else
        {
            casterLevel = (casterLevel - 1) / 3 + 3;
        }
        break;
    }

    int maxCasterLevel = (HENCH_SPELL_INFO_BUFF_LEVEL_LIMIT_MASK & buffInfo) >> 8;
    if (maxCasterLevel > 0)
    {
        if (casterLevel > maxCasterLevel)
        {
            casterLevel = maxCasterLevel;
        }
    }
    casterLevel -= (HENCH_SPELL_INFO_BUFF_LEVEL_ADJ_MASK & buffInfo) >> 20;

    if (maxCasterLevel > 0)
    {
        if (casterLevel > maxCasterLevel)
        {
            casterLevel = maxCasterLevel;
        }
    }

    int levelDiv = ((HENCH_SPELL_INFO_BUFF_LEVEL_DIV_MASK & buffInfo) >> 16) + 1;


    switch (HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_MASK & buffInfo)
    {
    case HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_DICE:
        return (buffAmount * (casterLevel / levelDiv) + 1) / 2;
    case HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_ADJ:
        return buffAmount + casterLevel / levelDiv;
//  case HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_COUNT:
//      return buffAmount * result.count;
    case HENCH_SPELL_INFO_BUFF_LEVEL_TYPE_CONST:
        return buffAmount * casterLevel / levelDiv;
    }
    return 3;
}


//*GZ: 2003-07-23. Properly calculated enhancement bonus
int SCArcaneArcherCalculateBonus(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCArcaneArcherCalculateBonus Start", GetFirstPC() ); }
    
    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oCharacter);

    if (nLevel == 0) //not an arcane archer?
    {
        return 0;
    }
    int nBonus = ((nLevel+1)/2); // every odd level after 1 get +1
    return nBonus;
}

int SCArcaneArcherDamageDoneByBow(int bCrit = FALSE, object oUser = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCArcaneArcherDamageDoneByBow Start", GetFirstPC() ); }
    
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int nDamage;
    int bSpec = FALSE;
    int bGrSpec = FALSE;
    int bEpSpec = FALSE;

    if (GetIsObjectValid(oItem) == TRUE)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW )
        {
            nDamage = d8();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bGrSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bEpSpec = TRUE;
            }
        }
        else
        if (GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW)
        {
            nDamage = d6();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bGrSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bEpSpec = TRUE;
            }
        }
        else
            return 0;
    }
    else
    {
            return 0;
    }

    // add strength bonus
    if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIGHTY))
    {
        int nStrength = GetAbilityModifier(ABILITY_STRENGTH,oUser);
        nDamage += nStrength;
    }
    nDamage += SCArcaneArcherCalculateBonus();

    if (bSpec == TRUE)
    {
        nDamage +=2;
    }
    if (bGrSpec == TRUE)
    {
        nDamage +=2;
    }
    if (bEpSpec == TRUE)
    {
        nDamage +=2;
    }
    if (bCrit == TRUE)
    {
         nDamage *=3;
    }

    return nDamage;
}




struct sDamageInformation SCGetCurrentSpellDamage(int casterLevel, int bIsItem, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "SCGetCurrentSpellDamage Start", GetFirstPC() ); }
    
    struct sDamageInformation result;

    result.count = 1;

    int damageInfo = SCGetCurrentSpellDamageInfo();

    int curDamageScan = damageInfo & HENCH_SPELL_INFO_DAMAGE_TYPE_MASK;
    result.damageTypeMask = curDamageScan;

    int curDamageIndex;
    int iIteration = 0;
	
    while (curDamageScan > 0 && iIteration < 30)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        iIteration++; // was doing a TMI in this function, this is capping how many it can check
        if (curDamageScan & 0x1)
        {
            result.numberOfDamageTypes ++;
            if (result.numberOfDamageTypes == 1)
            {
                result.damageType1 = 1 << curDamageIndex;
            }
            else
            {
                result.damageType2 = 1 << curDamageIndex;
            }
        }
        curDamageScan = curDamageScan >> 1;
        curDamageIndex ++;
    }

    int damageAmount =  (HENCH_SPELL_INFO_DAMAGE_AMOUNT_MASK & damageInfo) >> 12;
    int damageType = damageInfo & HENCH_SPELL_INFO_DAMAGE_MASK;
    switch (damageType)
    {
		case HENCH_SPELL_INFO_DAMAGE_CASTER_LEVEL:
		case HENCH_SPELL_INFO_DAMAGE_CURE:
			break;
		case HENCH_SPELL_INFO_DAMAGE_HD_LEVEL:
			casterLevel = GetHitDice(oCharacter);
			break;
		case HENCH_SPELL_INFO_DAMAGE_FIXED:
			result.amount = IntToFloat(damageAmount);
			result.count = ((HENCH_SPELL_INFO_DAMAGE_FIXED_COUNT & damageInfo) >> 24) + 1;
			return result;
		case HENCH_SPELL_INFO_DAMAGE_DRAGON:
			casterLevel = GetHitDice(oCharacter);
			if (casterLevel > 37)
			{
				casterLevel = 12;
			}
			else if (casterLevel > 33)
			{
				casterLevel = 11;
			}
			else
			{
				casterLevel = (casterLevel - 1) / 3 + 3;
			}
			break;
		case HENCH_SPELL_INFO_DAMAGE_SPECIAL_COUNT:
			{
				int maxCasterLevel = (HENCH_SPELL_INFO_DAMAGE_LEVEL_LIMIT_MASK & damageInfo) >> 20;
				if (maxCasterLevel > 0)
				{
					maxCasterLevel ++;
					if (casterLevel > maxCasterLevel)
					{
						casterLevel = maxCasterLevel;
					}
				}
				casterLevel ++;
				int levelDiv = ((HENCH_SPELL_INFO_DAMAGE_LEVEL_DIV_MASK & damageInfo) >> 26) + 1;
				casterLevel /= levelDiv;
				result.count = casterLevel;
				result.amount = IntToFloat(damageAmount * casterLevel);			
			}
			return result;
		case HENCH_SPELL_INFO_DAMAGE_CUSTOM:
			casterLevel += 15;  // this is divided by three
			break;
		case HENCH_SPELL_INFO_DAMAGE_DRAG_DISP:
			casterLevel = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oCharacter);
			if (casterLevel < 7)
			{
				casterLevel = 2;
			}
			else if (casterLevel < 10)
			{
				casterLevel = 4;
			}
			else if (casterLevel < 13)
			{
				casterLevel = 6;
			}
			else
			{
				casterLevel = 6 + ((casterLevel - 10) / 3);
			}
			break;
		case HENCH_SPELL_INFO_DAMAGE_AA_LEVEL:
			if ((HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_MASK & damageInfo) == HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_DICE)
			{
				casterLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER);
				if (casterLevel > 10)
				{
					casterLevel = 10 + ((casterLevel - 10) / 2);
				}
				else
				{
					casterLevel = 10;
				}
			}
			else
			{
				result.amount = IntToFloat(SCArcaneArcherDamageDoneByBow());
				return result;
			}
			break;
		case HENCH_SPELL_INFO_DAMAGE_LAY_ON_HANDS:
			{
				int nAmount = GetAbilityModifier(ABILITY_CHARISMA);
				if (nAmount <= 0)
				{
					result.amount = 0.0;
					return result;
				}
				nAmount *= GetLevelByClass(CLASS_TYPE_PALADIN) + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION) +
					GetLevelByClass(CLASS_KAED_HOSPITALER) + GetLevelByClass(CLASS_KAED_CHAMPION_WILD);
				if (nAmount <= 0)
				{
					result.amount = 0.0;
					return result;
				}
				result.amount = IntToFloat(nAmount);
				return result;
			}
		case HENCH_SPELL_INFO_DAMAGE_BARD_PERFORM:
			{
				location locCaster	= GetLocation(oCharacter);
				int nNumEnemies   = 0;			
				// Count up enemy targets so we can divide up damage evenly.  Stop if there's more than 6, since min damage is floored at Total/6.
				object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster);
				while(GetIsObjectValid(oTarget))
				{
					//DEBUGGING// igDebugLoopCounter += 1;
					if ( SCGetIsObjectValidSongTarget( oTarget ) &&  GetIsEnemy( oTarget ) )
					{
						nNumEnemies ++;
					}				
					if (nNumEnemies >= 6)
					{   // Don't need to go higher than 6 enemies.
						break;
					}		
					oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster );
				}
				if (nNumEnemies <= 0)
				{
					result.amount = 0.0;
					return result;
				}			
				int nPerformSkill = GetSkillRank(SKILL_PERFORM, oCharacter);
				result.amount = (2.0 * nPerformSkill) / nNumEnemies;    // Damage per target is (2*Perform)/Number of Enemies, capped at most 6 enemies.
				result.count = 3;
				return result;
			}
			return result;
		case HENCH_SPELL_INFO_DAMAGE_WARLOCK:
			result.amount = IntToFloat((7 * giWarlockDamageDice + 1 ) / 2);
			if (gbWarlockMaster)
			{
				result.amount *= 1.5;
			}
			return result;
		case HENCH_SPELL_INFO_DAMAGE_CHARISMA:
			casterLevel = GetAbilityModifier(ABILITY_CHARISMA);
			return result;
    }

    int maxCasterLevel = (HENCH_SPELL_INFO_DAMAGE_LEVEL_LIMIT_MASK & damageInfo) >> 20;
    if (maxCasterLevel > 0)
    {
        maxCasterLevel *= 5;
        if (casterLevel > maxCasterLevel)
        {
            casterLevel = maxCasterLevel;
        }
    }

    if (damageType == HENCH_SPELL_INFO_DAMAGE_CURE)
    {
        damageAmount += casterLevel;
        if (!bIsItem && GetHasFeat(FEAT_HEALING_DOMAIN_POWER, oCharacter))
        {
            damageAmount += (damageAmount / 2);
        }
        if (!bIsItem && GetHasFeat(FEAT_AUGMENT_HEALING, oCharacter))
        {
            // max caster level related to spell level * 5
            damageAmount += 2 * (maxCasterLevel / 5);
        }
        result.amount = IntToFloat(damageAmount);
        return result;
    }

    int levelDiv = ((HENCH_SPELL_INFO_DAMAGE_LEVEL_DIV_MASK & damageInfo) >> 26) + 1;


    switch (HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_MASK & damageInfo)
    {
    case HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_DICE:
        result.amount = IntToFloat((damageAmount * (casterLevel / levelDiv) + 1) / 2);
        break;
    case HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_ADJ:
        result.amount = IntToFloat(damageAmount + casterLevel / levelDiv);
        break;
    case HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_COUNT:
        result.count = casterLevel / levelDiv;
        result.amount = IntToFloat(damageAmount * result.count);
        break;
    case HENCH_SPELL_INFO_DAMAGE_LEVEL_TYPE_CONST:
        result.amount = IntToFloat(damageAmount * casterLevel / levelDiv);
        break;
    default:
        result.amount = 10.0;
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCGetCurrentSpellDamage End", GetFirstPC() ); }
    return result;
}


float SCGetDamageResistImmunityAdjustment(object oTarget, float damageAmount, int damageType, int count)
{
    if (GetLocalInt(oTarget, "HenchDamageInformation") & damageType)
    {
        damageAmount *= CSLDataArray_GetFloat(oTarget, "HenchDamageImmunity", damageType);
        damageAmount -= CSLDataArray_GetInt(oTarget, "HenchDamageResist", damageType) * count;
        if (damageAmount < 0.5)
        {
            damageAmount = 0.0;
        }
    }
    return damageAmount;
}


float SCCalculateDamageWeight(float damageAmount, object oTarget)
{
    int currentHitPoints = GetCurrentHitPoints(oTarget);
    if (currentHitPoints < 1)
    {
		if (GetIsDead(oTarget, TRUE))
		{
			return 0.0;	// dead is dead
		}
        // assume a bleed system is used
		return 0.1;
    }
    damageAmount /= IntToFloat(currentHitPoints);
    if (damageAmount > 1.0)
    {
        damageAmount = 1.0;
    }
    return damageAmount;
}


float SCGetConcetrationWeightAdjustment(int spellInformation, int spellLevel)
{
    float result = 1.0;
    if (spellInformation & HENCH_SPELL_INFO_UNLIMITED_FLAG)
    {
        result *= 1.2;
    }
    if (gbMeleeAttackers & (spellInformation & HENCH_SPELL_INFO_CONCENTRATION_FLAG))
    {
        if (spellInformation & HENCH_SPELL_INFO_ITEM_FLAG)
        {
            result *= 0.33;
        }
        else
        {
            result *= SCGetd20Chance(giMySpellCastingConcentration - 15 - spellLevel);
        }
    }
    return result;
}


int SCGetSpellInformation(int nSpellID)
{
    gsCurrentSpellInfoStr = "HENCH_SPELL_ID_INFO" + IntToString(nSpellID);

    int spellIDInfo = GetLocalInt(GetModule(), gsCurrentSpellInfoStr);

    if ((spellIDInfo & HENCH_SPELL_INFO_VERSION_MASK) != HENCH_SPELL_INFO_VERSION)
    {
        string columnInfo = Get2DAString("henchspells", "SpellInfo", nSpellID);
        spellIDInfo = StringToInt(columnInfo);
        if (spellIDInfo == 0)
        {
            // don't know anything about this spell
            spellIDInfo = HENCH_SPELL_INFO_VERSION | HENCH_SPELL_INFO_IGNORE_FLAG;
        }
        else
        {
            string targetInfoStr = Get2DAString("henchspells", "TargetInfo", nSpellID);
            SetLocalInt(GetModule(), gsCurrentSpellInfoStr + "TargetInfo", StringToInt(targetInfoStr));

            targetInfoStr = Get2DAString("henchspells", "EffectWeight", nSpellID);
            SetLocalFloat(GetModule(), gsCurrentSpellInfoStr + "EffectWeight", StringToFloat(targetInfoStr));

            targetInfoStr = Get2DAString("henchspells", "EffectTypes", nSpellID);
            SetLocalInt(GetModule(), gsCurrentSpellInfoStr + "EffectTypes", StringToInt(targetInfoStr));

            targetInfoStr = Get2DAString("henchspells", "DamageInfo", nSpellID);
            SetLocalInt(GetModule(), gsCurrentSpellInfoStr + "DamageInfo", StringToInt(targetInfoStr));

            targetInfoStr = Get2DAString("henchspells", "SaveType", nSpellID);
            SetLocalInt(GetModule(), gsCurrentSpellInfoStr + "SaveType", StringToInt(targetInfoStr));

            targetInfoStr = Get2DAString("henchspells", "SaveDCType", nSpellID);
            SetLocalInt(GetModule(), gsCurrentSpellInfoStr + "SaveDCType", StringToInt(targetInfoStr));
        }
        SetLocalInt(GetModule(), gsCurrentSpellInfoStr, spellIDInfo);
    }

    return spellIDInfo;
}




//::///////////////////////////////////////////////
//:: Get Percentage of HP Loss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Determine the percentage of hit points the object has left.
   Used to determine whether the assoc should heal their master.
   Returns an integer between 0 - 100.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
//:://////////////////////////////////////////////
int SCGetPercentageHPLoss(object oWounded)
{
    float fMaxHP = IntToFloat(GetMaxHitPoints(oWounded));
    float fCurrentHP = IntToFloat(GetCurrentHitPoints(oWounded));
    float fHP_Perc = (fCurrentHP / fMaxHP) * 100;

    int nHP = FloatToInt(fHP_Perc);
    return nHP;
}







//::///////////////////////////////////////////////
//:: Should I Heal My Master
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the healing variable for the master
    and then asks if the master if below that level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
//:://////////////////////////////////////////////
int SCGetAssociateHealMaster( object oCharacter = OBJECT_SELF )
{
    if(CSLGetAssociateState(CSL_ASC_HAVE_MASTER, oCharacter ))
    {
        object oMaster = GetMaster();
        int nLoss = SCGetPercentageHPLoss(oMaster);
        if(!GetIsDead(oMaster))
        {
            if(CSLGetAssociateState(CSL_ASC_HEAL_AT_75, oCharacter ) && nLoss <= 75)
            {
                return TRUE;
            }
            else if(CSLGetAssociateState(CSL_ASC_HEAL_AT_50, oCharacter) && nLoss <= 50)
            {
                return TRUE;
            }
            else if(CSLGetAssociateState(CSL_ASC_HEAL_AT_25, oCharacter ) && nLoss <= 25)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}


int SCGetIsFocused(object oTarget=OBJECT_SELF)
{
    int iFocused = GetLocalInt(oTarget, VAR_FOCUSED);
	if (IsInConversation(oTarget)  && iFocused != FOCUSED_NONE)
	{
		iFocused = FOCUSED_FULL;
	}
	return (iFocused);
}



void SCResetHenchmenState(object oCharacter = OBJECT_SELF)
{
    SetCommandable(TRUE);
    DeleteLocalObject(oCharacter, "NW_GENERIC_DOOR_TO_BASH");
    DeleteLocalInt(oCharacter, "NW_GENERIC_DOOR_TO_BASH_HP");
    CSLSetAssociateState(CSL_ASC_IS_BUSY, FALSE);
    ClearAllActions();
}


//Helper for S C SpecialTacticsRanged() -- returns Ammo of base type nAmmoType
object SCGetAmmoInInventory(int nAmmoType)
{
	//DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "SCGetAmmoInInventory Start", GetFirstPC() ); }
	object oItem = GetFirstItemInInventory();
	while(GetIsObjectValid(oItem) && GetBaseItemType(oItem) != nAmmoType)
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		oItem = GetNextItemInInventory();	
	}
	if(GetBaseItemType(oItem) != nAmmoType)
	{
		return OBJECT_INVALID;
	}
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCGetAmmoInInventory End", GetFirstPC() ); }
	return oItem;
}







// Count the number of enemies and allies in a given radius
// and their respective total CRs (slightly rounded, since
// we use integers instead of floats).
// This returns a "struct sSituation" type value. To use, do
// something like the following:
//
//   struct sSituation sitCurr = SC CountEnemiesAndAllies(20.0);
//   int nNumEnemies = sitCurr.ENEMY_NUM;
//   int nNumAllies = sitCurr.ALLY_NUM;
//   int nAllyCR = sitCurr.ALLY_CR;
//   int nEnemyCR = sitCurr.ENEMY_CR;
struct sSituation SCCountEnemiesAndAllies(float fRadius=20.0, object oSource= OBJECT_SELF)
{
    struct sSituation sitCurrent;
    sitCurrent.ENEMY_NUM = 0;
    sitCurrent.ALLY_NUM = 0;
    sitCurrent.ENEMY_CR = 0;
    sitCurrent.ALLY_CR = 0;
	int iIteration = 0;
	
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "SCCountEnemiesAndAllies Start", GetFirstPC() ); }
	
    location lSource = GetLocation(oSource);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lSource, TRUE);
    while(GetIsObjectValid(oTarget) && iIteration < 30 ) // note that it just does not matter if there are more than this many
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        iIteration++;
        if (GetObjectSeen(oTarget))
        {
            if (GetIsEnemy(oTarget))
            {
                if (GetIsPC(oTarget) == TRUE)
                {
                    sitCurrent.ENEMY_CR += GetHitDice(oTarget);
                }
                else
                {
                    sitCurrent.ENEMY_CR += FloatToInt(GetChallengeRating(oTarget));
                }

                sitCurrent.ENEMY_NUM++;
            }
            else if (GetIsFriend(oTarget))
            {
                if (GetIsPC(oTarget) == TRUE)
                {
                    sitCurrent.ALLY_CR += GetHitDice(oTarget);
                }
                else
                {
                    sitCurrent.ALLY_CR += FloatToInt(GetChallengeRating(oTarget));
                }
                sitCurrent.ALLY_NUM++;
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lSource, TRUE);
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCCountEnemiesAndAllies End", GetFirstPC() ); }
    return sitCurrent;
}


// Returns TRUE if the given opponent is a melee
// attacker, meaning they are in melee range and
// equipped with a melee weapon.
int SCGetIsMeleeAttacker(object oAttacker)
{
    //DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "SCGetIsMeleeAttacker Start", GetFirstPC() ); }
    if (GetDistanceToObject(oAttacker) > MELEE_DISTANCE)
    {
        return FALSE;
	}
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
    if (GetIsObjectValid(oRight) && CSLItemGetIsMeleeWeapon(oRight))
    {
        return TRUE;
	}
	
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker);
    if (GetIsObjectValid(oLeft) && CSLItemGetIsMeleeWeapon(oLeft))
    {
        return TRUE;
	}
	
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCGetIsMeleeAttacker End", GetFirstPC() ); }
    return FALSE;
}





//    Check how many enemies are within 5m of the
//    target object.
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 11, 2001
int SCGetNumberOfMeleeAttackers(object oCharacter = OBJECT_SELF)
{
    
    //DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "SCGetNumberOfMeleeAttackers Start", GetFirstPC() ); }
    int nCnt = 0;
	int bEnemyClose = FALSE;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,  5.0,  GetLocation(oCharacter), FALSE);
    while ( GetIsObjectValid(oTarget) && nCnt < 20 )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if(!GetIsDead(oTarget))
        {
			if(GetIsEnemy(oTarget))
			{
            	nCnt++;
				if (!bEnemyClose && GetDistanceBetween(oCharacter, oTarget) < 2.3f)
				{
					bEnemyClose = TRUE;
				}
			}
		}
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, GetLocation(oCharacter), FALSE);
    }
	if(bEnemyClose)
	{
		SetLocalInt(oCharacter, "EVENFLW_AI_CLOSE", TRUE);
	}
	else 
	{
		DeleteLocalInt(oCharacter, "EVENFLW_AI_CLOSE");
	}
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCGetNumberOfMeleeAttackers End", GetFirstPC() ); }
    return (nCnt);
}




//    Takes a target object and a radius and
//    returns how many targets of the caster's faction
//    are in that zone.
int SCCheckFriendlyFireOnTarget(object oTarget, float fDistance = 7.5, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "SCCheckFriendlyFireOnTarget Start "+GetName(oTarget), GetFirstPC() ); }
    
    int nCnt, nHD, nMyHD;
    nMyHD = GetHitDice(oCharacter);
    object oCheck = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oTarget));
    while(GetIsObjectValid(oCheck))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        //Use this instead of GetIsFriend to make sure that friendly casualties do not occur.
        //Formerlly GetIsReactionTypeFriendly(oCheck)
        nHD = GetHitDice(oCheck);
        if ( (GetIsFriend(oCheck)) && oTarget != oCheck && nMyHD <= (nHD * 2) )
        {
            if ( !GetIsReactionTypeFriendly(oCheck) || GetHenchman(oCharacter) != oCheck )
            {
                nCnt++;
            }
        }
        oCheck = GetNextObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oTarget));
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCCheckFriendlyFireOnTarget End", GetFirstPC() ); }
    return nCnt;
}


//    Takes a target object and a radius and
//    returns how many targets of the enemy faction
//    are in that zone.
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
int SCCheckEnemyGroupingOnTarget(object oTarget, float fDistance = 7.5)
{
    //DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "SCCheckEnemyGroupingOnTarget Start "+GetName(oTarget), GetFirstPC() ); }
    
    int nCnt;
	int bAvoidObjects = FALSE;
	
	if (CSLGetAssociateState(CSL_ASC_POWER_CASTING) 
		|| CSLGetAssociateState(CSL_ASC_SCALED_CASTING) )  
		bAvoidObjects = 1;
		
    object oCheck = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oCheck))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if( GetIsEnemy(oCheck)  && oTarget != oCheck  && GetDistanceBetween(oTarget, oCheck) <= 5.0f)
        {
            nCnt++;
        } 
		// if we are avoiding objects and this is a non-plot placeable, then subtract 1 from the enemy count
		else if( bAvoidObjects  && GetObjectType(oCheck)==OBJECT_TYPE_PLACEABLE && !GetPlotFlag(oCheck))
		{			
			nCnt--;
		}			
        oCheck = GetNextObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oTarget), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE);
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCCheckEnemyGroupingOnTarget End", GetFirstPC() ); }
    return nCnt;
}





object SCGetNearestNonEnemy(object oCharacter = OBJECT_SELF)
{
	int iIteration = 0;
	
	object oFriend = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCharacter), TRUE);
	while( GetIsObjectValid(oFriend) && iIteration < 40 )
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		iIteration++;
		if(!GetIsEnemy(oFriend) && !CSLGetAssociateState(CSL_ASC_MODE_DYING, oFriend))
		{
			break;
		}
		oFriend = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCharacter), TRUE);
	}
	return oFriend;
}

/* void main() {} /* */

// Put on queue of creature to do a DCR.
// Using this allows the DCR call to be decoupled from the script, allowing it to take
// advantage of DCR enhancements without needing to be recompiled.
//void SCAssignDCR( object oCharacter = OBJECT_SELF )
//{
//	AssignCommand(oCharacter, ExecuteScript("gr_dcr", oCharacter));
//}








// * this is just a wrapper around ActionAttack
// * to make sure the creature equips weapons
void SCWrapperActionAttack(object oTarget)
{
        // Feb 28: Always try to equip weapons at this point
    CSLEquipAppropriateWeapons(oTarget, CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON));
    ActionAttack(oTarget);
}

// Try a spell to produce a particular spell effect.
// This will only cast the spell if the target DOES NOT already have the
// given spell effect, and the caster possesses the spell.
//
// Returns TRUE on success, FALSE on failure.
int SCTrySpell(int nSpell, object oTarget=OBJECT_SELF, object oCaster= OBJECT_SELF)
{
    if ( GetHasSpell(nSpell, oCaster) && !GetHasSpellEffect(nSpell, oTarget) && GetSpellKnown( oCaster, nSpell )  )
    {
        AssignCommand(oCaster, ActionCastSpellAtObject(nSpell, oTarget));
        return TRUE;
    }
    return FALSE;
}


int SCConvertImmunityStringToType (string sImmunityType)
{
	int nRet = 0;
	if (sImmunityType == "")										nRet = IMMUNITY_TYPE_NONE;
	else if (sImmunityType == "Mind_Affecting")	nRet = IMMUNITY_TYPE_MIND_SPELLS;
	else if (sImmunityType == "Death")			nRet = IMMUNITY_TYPE_DEATH;
	else if (sImmunityType == "Poison")			nRet = IMMUNITY_TYPE_POISON;
	else if (sImmunityType == "Disease")			nRet = IMMUNITY_TYPE_DISEASE;
	else if (sImmunityType == "Fear")				nRet = IMMUNITY_TYPE_FEAR;
	else if (sImmunityType == "Ability_Drain")	nRet = IMMUNITY_TYPE_ABILITY_DECREASE;
	else if (sImmunityType == "Divine")			nRet = SCFAKE_IMMUNITY_TYPE_DIVINE;
	else if (sImmunityType == "Acid")				nRet = SCFAKE_IMMUNITY_TYPE_ACID;
	else if (sImmunityType == "Fire")				nRet = SCFAKE_IMMUNITY_TYPE_FIRE;
	else if (sImmunityType == "Electricity")		nRet = SCFAKE_IMMUNITY_TYPE_ELECTRICITY;
	else if (sImmunityType == "Cold")				nRet = SCFAKE_IMMUNITY_TYPE_COLD;
	else if (sImmunityType == "Sonic")			nRet = SCFAKE_IMMUNITY_TYPE_SONIC;
	else if (sImmunityType == "Negative")			nRet = SCFAKE_IMMUNITY_TYPE_NEGATIVE;
	else if (sImmunityType == "Positive")			nRet = SCFAKE_IMMUNITY_TYPE_POSITIVE;
	else if (sImmunityType == "Non_Spirit")		nRet = SCFAKE_IMMUNITY_TYPE_NON_SPIRIT;
	else if (sImmunityType == "Knockdown")			nRet = IMMUNITY_TYPE_KNOCKDOWN;
	
	return (nRet);                                                   
}		


int SCIsNegativeImmuneRace(object oTarget)
{
	int iRet = FALSE;
    int nRacialType = GetRacialType(oTarget);
	if (nRacialType == RACIAL_TYPE_UNDEAD 
		|| nRacialType==RACIAL_TYPE_CONSTRUCT 
		|| GetSubRace(oTarget)==RACIAL_SUBTYPE_CONSTRUCT)
		iRet = TRUE;
	return (iRet);
}			

int SCIsNegativeImmune(int nImmunityType)
{
	int nRet = FALSE;
	if (nImmunityType == IMMUNITY_TYPE_MIND_SPELLS
		|| nImmunityType == IMMUNITY_TYPE_DEATH
		|| nImmunityType == IMMUNITY_TYPE_POISON
		|| nImmunityType == IMMUNITY_TYPE_DISEASE
		|| nImmunityType == IMMUNITY_TYPE_FEAR 			
		|| nImmunityType == SCFAKE_IMMUNITY_TYPE_NEGATIVE
		|| nImmunityType == IMMUNITY_TYPE_ABILITY_DECREASE)
		nRet = TRUE;		
	return (nRet);
}

int SCIsElementalRace(object oTarget)
{
    int nRacialType = GetRacialType(oTarget);
	return (nRacialType==RACIAL_TYPE_ELEMENTAL);
}

int SCIsElementalImmune(int nImmunityType)
{
	int nRet = FALSE;
	if (nImmunityType == IMMUNITY_TYPE_MIND_SPELLS
		|| nImmunityType == IMMUNITY_TYPE_POISON
		|| nImmunityType == IMMUNITY_TYPE_DISEASE)
		nRet = TRUE;		
	return (nRet);
}


int SCHasRacialImmunity(object oTarget, int nImmunityType)
{
	int nRet = FALSE;
	if (SCIsNegativeImmuneRace(oTarget) && SCIsNegativeImmune(nImmunityType))
	{
		nRet = TRUE;
	}
	else if (SCIsElementalRace(oTarget) && SCIsElementalImmune(nImmunityType))
	{
		nRet = TRUE;
	}
	
	return (nRet);	
}

int SCIsTargetImmune(int nImmunityType, object oTarget)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCIsTargetImmune Start", GetFirstPC() ); }
	
	object oSelf = OBJECT_SELF;

	if (nImmunityType == IMMUNITY_TYPE_NONE)
		return (FALSE);

	// is target a race that should have special immunities (even though they may not actually be applied)
	if (SCHasRacialImmunity(oTarget, nImmunityType))	
	{
		return(TRUE);
	}	
	
	// if the immunity type is Non_Spirit we want to make sure we don't have a non spirit
	if(nImmunityType == SCFAKE_IMMUNITY_TYPE_NON_SPIRIT && !GetIsSpirit(oTarget))
	{
		return(TRUE);
	}
	
	// *** PARTY MEMBERS ONLY PAST HERE ***
	// only party members will figure out additional kinds of immunities beyond this point.
	int bPartyMember = GetIsRosterMember(oSelf) || GetIsOwnedByPlayer(oSelf);
	if (!bPartyMember)
	{
		return(FALSE);
	}		
	
	// does target have an immunity?
	// Note: this won't check the "fake" immunities types (negative values)
	if ((nImmunityType>0) && GetIsImmune(oTarget, nImmunityType, oSelf))
	{
		return(TRUE);
	} 

	// special exceptions 
	if (nImmunityType == IMMUNITY_TYPE_FEAR)
	{
		// note: spells + death immunity checked in SC IsTargetImmuneToSpell()
		//if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oSelf)
		//	|| (nSpellId==SPELL_WEIRD || nSpellId==SPELL_PHANTASMAL_KILLER) 
		//		&& GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH, oSelf) ) 	
		
		// mind spell immunity also gives fear immunity
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oSelf))
		{
			return(TRUE);
		}				
	}

	return (FALSE);
}

// Immunity Type in the spells 2da is given by string.            
int SCGetSpellImmunityType (int nSpellId)
{
	string sImmunityType = Get2DAString("spells", "ImmunityType", nSpellId);
	int nImmunityType = SCConvertImmunityStringToType(sImmunityType);
	
	return (nImmunityType);
}		

int SCIsTargetImmuneToSpell(int nSpellId, object oTarget)
{
	object oSelf = OBJECT_SELF;

	int nImmunityType = SCGetSpellImmunityType(nSpellId);
	int bRet = SCIsTargetImmune(nImmunityType, oTarget);
	
	// special exceptions 
	if (nImmunityType == IMMUNITY_TYPE_FEAR)
	{
		// 2 spells check death immunity even though fear is the immunity type.
		if ((nSpellId==SPELL_WEIRD || nSpellId==SPELL_PHANTASMAL_KILLER) 
			&& GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH, oSelf) ) 	
		{
			return(TRUE);
		}				
	}

	
	return (bRet);
}	




// Returns TRUE if the specified behavior flag is set on the caller
int SCGetBehaviorState(int nCondition, object oCharacter = OBJECT_SELF)
{
    int nPlot = GetLocalInt(oCharacter, "NW_BEHAVIOR_MASTER");
    if(nPlot & nCondition)
    {
        return TRUE;
    }
    return FALSE;
}


 // wrapper for GetCreatureTalentRandom() using flag specified on the creature.
talent SCGetCreatureTalentRandomStd(int nCategory, object oCharacter= OBJECT_SELF)
{
	return (GetCreatureTalentRandom(nCategory, oCharacter, GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE")));
}
// wrapper for GetCreatureTalentBest() using flag specified on the creature.
talent SCGetCreatureTalentBestStd(int nCategory, int nCRMax, object oCharacter= OBJECT_SELF)
{
	return (GetCreatureTalentBest(nCategory, nCRMax, oCharacter, GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE")));
}


// * Wrapper function so that I could add a variable to allow randomization
// * to the AI.
// * WARNING: This will make the AI cast spells badly if they have a bad
// * spell selection (i.e., only turn randomization on if you know what you are doing
// *
// * nCRMax only applies if bRandom is FALSE
// * oCharacter is the creature checking to see if it has the talent
talent SCGetCreatureTalent(int nCategory, int nCRMax, int bRandom=FALSE, object oCharacter = OBJECT_SELF)
{
    // * bRandom can be overridden by the variable X2_SPELL_RANDOM = 1
    if (bRandom == FALSE)
    {
        bRandom = GetLocalInt(oCharacter, "X2_SPELL_RANDOM");
    }

    if (bRandom == FALSE)
    {
        return SCGetCreatureTalentBestStd(nCategory, nCRMax, oCharacter);
    }
    else
    // * randomize it
    {
        return SCGetCreatureTalentRandomStd(nCategory, oCharacter);
    }
}


// Behavior1 = Hated Class
void SCSetupBehavior(int nBehaviour, object oCharacter = OBJECT_SELF)
{
    int nHatedClass = Random(10);
    nHatedClass = nHatedClass + 1;     // for purposes of using 0 as a
                                       // unitialized value.
                                       // will decrement in SC AcquireTarget
    SetLocalInt(oCharacter, "NW_L_BEHAVIOUR1", nHatedClass);
}

// for use on enemies, because some(dragons, dryads,others) have no caster classes, but have spells as special abilities
int SCHasHarmfulSpell(object oTarget)
{
	int bHarmfulSpell = FALSE;
	
	if(	GetIsTalentValid(SCGetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, oTarget))
		|| GetIsTalentValid(SCGetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_RANGED , oTarget))
		|| GetIsTalentValid(SCGetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_TOUCH, oTarget))
		|| GetIsTalentValid(SCGetCreatureTalentRandomStd(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, oTarget))
		)
				bHarmfulSpell = TRUE;
		
	return bHarmfulSpell;
}

// for allies, because they all have valid classes with spells
int SCHasCasterLevels(object oTarget)
{
	int bCaster = FALSE;
	if(	GetLevelByClass(CLASS_TYPE_BARD, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_CLERIC, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_DRUID, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_PALADIN, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_RANGER, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_SORCERER, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_WARLOCK, oTarget) > 1
		|| GetLevelByClass(CLASS_TYPE_WIZARD, oTarget) > 1
		)
				bCaster = TRUE;
		
	return bCaster;
}


int SCGetFeatImmunityType (int nFeatId)
{
	string sImmunityType = Get2DAString("feat", "ImmunityType", nFeatId);
	int nImmunityType = SCConvertImmunityStringToType(sImmunityType);
	
	return (nImmunityType);
}

int SCIsTargetImmuneToFeat(int nFeatId, object oTarget)
{
	int nImmunityType = SCGetFeatImmunityType(nFeatId);
	int bRet = SCIsTargetImmune(nImmunityType, oTarget);
	return (bRet);
}


// CSLGetLocalIntBitState(oCharacter, "NW_GENERIC_MASTER", CSL_FLAG_DAY_NIGHT_POSTING )

// Returns TRUE if the specified condition has been set on the
// caller, otherwise FALSE.
int SCGetSpawnInCondition(int nCondition, object oCharacter = OBJECT_SELF)
{
    return CSLGetLocalIntBitState(oCharacter, "NW_GENERIC_MASTER", nCondition);
}

// Sets the listening patterns and local variables needed
// for the given spawn-in condition on the caller.
void SCSetSpawnInLocals(int nCondition, object oCharacter = OBJECT_SELF)
{
    if(nCondition == CSL_FLAG_SHOUT_ATTACK_MY_TARGET)
    {
        // Listen for shouts from allies directing
        // the caller to attack their targets
        SetListenPattern(oCharacter, "NW_ATTACK_MY_TARGET",  5);
    }
    else if(nCondition == CSL_FLAG_ESCAPE_RETURN)
    {
        // Mark our starting location (here)
        SetLocalLocation(oCharacter,  "NW_GENERIC_START_POINT",  GetLocation(oCharacter));
    }
    else if(nCondition == CSL_FLAG_TELEPORT_LEAVE)
    {
        // Mark our starting location (here)
        SetLocalLocation(oCharacter, "NW_GENERIC_START_POINT",  GetLocation(oCharacter));
    }
    
    SetListenPattern(oCharacter, "NW_SNEAKERFOUND",  101);
}


// Sets the specified spawn-in condition on the caller as directed.
void SCSetSpawnInCondition(int nCondition, int bValid = TRUE, object oCharacter = OBJECT_SELF)
{
	CSLSetLocalIntBitState(oCharacter, "NW_GENERIC_MASTER", nCondition, bValid );

}



//::///////////////////////////////////////////////
//:: SC SetListeningPatterns
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Sets the correct listen checks on the NPC by
    determining what talents they possess or what
    class they use.

    This is also a good place to set up all of
    the sleep and appear disappear animations for
    various models.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 24, 2001
//:://////////////////////////////////////////////
void SCSetListeningPatterns(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetListeningPatterns Start", GetFirstPC() ); }
    
    if(SCGetSpawnInCondition(CSL_FLAG_APPEAR_SPAWN_IN_ANIMATION))
    {
        effect eAppear = EffectAppear();
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eAppear, oCharacter);
    }

    SetListening(oCharacter, TRUE);

    SetListenPattern(oCharacter, "NW_I_WAS_ATTACKED", 1);
    
	SetListenPattern(oCharacter, "NW_SNEAKERFOUND",  101);
    //This sets the commoners listen pattern to mob under
    //certain conditions
    if(GetLevelByClass(CLASS_TYPE_COMMONER) > 0)
    {
        SetListenPattern(oCharacter, "NW_MOB_ATTACK", 2);
    }
    SetListenPattern(oCharacter, "NW_I_AM_DEAD", 3);

    SetListenPattern(oCharacter, "inventory",101);
	
	SetListenPattern(oCharacter, "pick",102);
    SetListenPattern(oCharacter, "trap", 103);
    
    //Set a custom listening pattern for the creature so that placables with
    //"NW_BLOCKER" + Blocker NPC Tag will correctly call to their blockers.
    string sBlocker = "NW_BLOCKER_BLK_" + GetTag(oCharacter);
    SetListenPattern(oCharacter, sBlocker, 4);
    SetListenPattern(oCharacter, "NW_CALL_TO_ARMS", 6);
    
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCSetListeningPatterns End", GetFirstPC() ); }
}




// * Do I have any effect on me that came from a mind affecting spell?
int SCMatchDoIHaveAMindAffectingSpellOnMe(object oTarget)
{
    if  (
        GetHasSpellEffect(SPELL_SLEEP, oTarget) ||
        GetHasSpellEffect(SPELL_DAZE, oTarget) ||
        GetHasSpellEffect(SPELL_HOLD_ANIMAL, oTarget) ||
        GetHasSpellEffect(SPELL_HOLD_MONSTER, oTarget) ||
        GetHasSpellEffect(SPELL_HOLD_PERSON, oTarget) ||
        GetHasSpellEffect(SPELL_CHARM_MONSTER, oTarget) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON, oTarget) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON_OR_ANIMAL, oTarget) ||
        GetHasSpellEffect(SPELL_MASS_CHARM, oTarget) ||
        GetHasSpellEffect(SPELL_DOMINATE_ANIMAL, oTarget) ||
        GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oTarget) ||
        GetHasSpellEffect(SPELL_DOMINATE_PERSON, oTarget) ||
        GetHasSpellEffect(SPELL_CONFUSION, oTarget)  ||
        GetHasSpellEffect(SPELL_MIND_FOG, oTarget)   ||
        GetHasSpellEffect(SPELL_CLOUD_OF_BEWILDERMENT, oTarget)   ||
        GetHasSpellEffect(SPELLABILITY_BOLT_DOMINATE,oTarget) ||
        GetHasSpellEffect(SPELLABILITY_BOLT_CHARM,oTarget) ||
        GetHasSpellEffect(SPELLABILITY_BOLT_CONFUSE,oTarget) ||
        GetHasSpellEffect(SPELLABILITY_BOLT_DAZE,oTarget)
        )
        return TRUE;
    return FALSE;
}


// Paus
int SCMatchPersonSpells(int iSpell) {

   switch (iSpell) {
        case SPELL_HOLD_PERSON:
        case SPELL_CHARM_PERSON:
        case SPELL_DOMINATE_PERSON:
            return TRUE; break;

        default: break;
    }

    return FALSE;
}



//int TalentFeatCheck(talent tUse, object oTarget)
int SCTalentFeatFilter(talent tUse, object oTarget)
{
	int iId = GetIdFromTalent(tUse);
	if(GetHasFeatEffect(iId, oTarget))
	{
		return FALSE;
	}
	else if(SCIsTargetImmuneToFeat(iId, oTarget))
	{
		return FALSE;
	}
	return TRUE;
} 



int SCEvenTalentSpellFilter(talent tUse, object oTarget) 
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCEvenTalentSpellFilter Start", GetFirstPC() ); }
    
    int iId = GetIdFromTalent(tUse);
	if (iId == SPELL_FIRE_STORM || iId == SPELL_STORM_OF_VENGEANCE) {
        if(GetDistanceToObject(oTarget) > 10.0)
        	ActionMoveToObject(oTarget, TRUE, 9.0);
    }
	else if(iId == SPELL_GREATER_FIREBURST) {
        if(GetDistanceToObject(oTarget) > 9.0)
        	ActionMoveToObject(oTarget, TRUE, 8.0);	
	}
	else if(iId == SPELL_FIREBURST) {
        if(GetDistanceToObject(oTarget) > 4.0)
        	ActionMoveToObject(oTarget, TRUE, 3.5);
	}
    else if(iId==SPELLABILITY_GAZE_PETRIFY)
	{
        if(GetDistanceToObject(oTarget)>10.0) 
		{
            ActionMoveToObject(oTarget, TRUE, 9.0);
        }
	}
		
	//if we cannot see that we are casting at
	if(!GetObjectSeen(oTarget))
	{	
		// get the category of spell
		string sSpellCategory = Get2DAString("spells", "Category", iId);
		int iCategory = StringToInt(sSpellCategory);
		//if harmful don't cast move towards target
		if(	iCategory == TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT || 
			iCategory == TALENT_CATEGORY_HARMFUL_RANGED || 
			iCategory == TALENT_CATEGORY_HARMFUL_TOUCH  ||
			iCategory == TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT ||
			iCategory == TALENT_CATEGORY_HARMFUL_MELEE)
			{
				ActionMoveToObject(oTarget, TRUE, 4.0f);
			}
		// otherwise beneficial to us now so cast on self then hunt down target
		else 
		{
			object oDamager = GetLastHostileActor();
			ActionUseTalentOnObject(tUse, oTarget);
			ActionMoveToObject(oDamager, TRUE, 4.0f);
		}
		
	}
	//otherwise do what you have to
	else
	{
		ActionUseTalentOnObject(tUse, oTarget);
	}
	return TRUE;
}



int SCIsSafeToUseSilence(object oTarget, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCIsSafeToUseSilence Start "+GetName(oTarget), GetFirstPC() ); }
	
	location lTarget 	= GetLocation(oTarget);
	int nTotalEnemies;
	int nEnemyCasters;
	int nAllyCasters;
	float fPercentCasters;
	int bSafeToUse = TRUE;
	
	// go through all objects in a shape sized similar to silence aoe
	object oTemp = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	while(GetIsObjectValid(oTemp))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		// never ok to silence yourself
		if(oCharacter == oTemp)
			return FALSE;
		// never ok to silence a pc
		if(GetIsPC(oTemp))
			return FALSE;
		// if an enemy
		if(GetIsEnemy(oTarget))
		{	
			// increase enemy count
			nTotalEnemies++;
			// if they have harmful spells
			if(SCHasHarmfulSpell(oTemp))
				// increse count of enemy caster
				nEnemyCasters++;
		}
		// if an ally
		else 
		{
			// check to see if they have any levels in the main spell casting classes
			if(SCHasCasterLevels(oTemp))
				// if true then increase ally caster count
				nAllyCasters++;
		}
		oTemp = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	}
	//PrettyDebug("Total Enemies: " + IntToString(nTotalEnemies));
	//PrettyDebug("Total Enemy Casters: " + IntToString(nEnemyCasters));
	//PrettyDebug("Total Ally Casters: " + IntToString(nAllyCasters));
	// calculate percentage of enemy casters to total enemies
	fPercentCasters = IntToFloat(nEnemyCasters) / IntToFloat(nTotalEnemies);
	//PrettyDebug("Percentage of Enemy Casters: " + FloatToString(fPercentCasters));
	// if you have more ally casters than enemy casters in the area do not cast spell
	if (nAllyCasters > nEnemyCasters)
		bSafeToUse = FALSE;
	// if there are any allies casters in the area and a small percentage of enemies are caster, do not cast spell
	if ((nAllyCasters > 0) && (fPercentCasters <= 0.25))
		bSafeToUse = FALSE;
	// if there are no casters in the areas don't cast the spell
	if (nEnemyCasters == 0)
		bSafeToUse = FALSE;
	// otherwise it is ok
	return bSafeToUse;
}



int SCWrongAlign(object oTarget, object oCharacter = OBJECT_SELF) 
{
    int align=GetAlignmentGoodEvil(oCharacter);
    int ethos=GetAlignmentLawChaos(oCharacter);
    if(align==ALIGNMENT_GOOD && GetAlignmentGoodEvil(oTarget)==ALIGNMENT_GOOD ||
        align==ALIGNMENT_EVIL && GetAlignmentGoodEvil(oTarget)==ALIGNMENT_EVIL ||
        align==ALIGNMENT_NEUTRAL && ethos==ALIGNMENT_LAWFUL && GetAlignmentLawChaos(oTarget)==ALIGNMENT_LAWFUL ||
        align==ALIGNMENT_NEUTRAL && ethos==ALIGNMENT_CHAOTIC && GetAlignmentLawChaos(oTarget)==ALIGNMENT_CHAOTIC ||
        ethos==ALIGNMENT_NEUTRAL && align==ALIGNMENT_NEUTRAL && GetAlignmentGoodEvil(oTarget)==ALIGNMENT_NEUTRAL)
      return TRUE;
    return FALSE;
}


// Determine whether or not we think the spell to be cast will be effective.
int SCIsSpellEffectiveAgainstTarget(int iId, object oTarget, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCIsSpellEffectiveAgainstTarget Start", GetFirstPC() ); }
	
	int iRet = TRUE;	
    int nTargetRacialType = GetRacialType(oTarget);

	// everyone knows these
	if ((iId==SPELL_DOMINATE_ANIMAL || iId==SPELL_HOLD_ANIMAL) && nTargetRacialType!=RACIAL_TYPE_ANIMAL  
		|| iId==SPELL_CRUMBLE && nTargetRacialType!=RACIAL_TYPE_CONSTRUCT 
		|| iId==SPELL_CONTROL_UNDEAD && (GetHitDice(oTarget) >  GetCasterLevel(oCharacter)*2 || nTargetRacialType != RACIAL_TYPE_UNDEAD) 
		|| iId==SPELL_UNDEATH_TO_DEATH && (GetHitDice(oTarget)>8 || nTargetRacialType != RACIAL_TYPE_UNDEAD) 
		|| (iId == SPELL_DROWN || iId==SPELL_FLESH_TO_STONE) && !CSLGetIsLiving(oTarget) == TRUE 
		|| iId == SPELL_SLEEP && (GetHitDice(oTarget) > 4 || nTargetRacialType==RACIAL_TYPE_ELF || nTargetRacialType==RACIAL_TYPE_HALFELF) 
		)		
	{
		iRet = FALSE;	
	}
	
	// only special people will identify these immunities - people like party members!
	if (GetIsPC(GetFactionLeader(oCharacter)))
	{ 
		if (( (iId==SPELL_HAMMER_OF_THE_GODS && d4()==1 || iId==SPELL_WORD_OF_FAITH) && SCWrongAlign(oTarget)) // can't tell alignment by looking
			|| (iId==SPELL_WORD_OF_FAITH && GetHitDice(oTarget)>GetLevelByClass(CLASS_TYPE_CLERIC)) 
			|| iId == SPELL_ENERGY_DRAIN && GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL) 
			|| iId == SPELL_POWER_WORD_KILL && GetCurrentHitPoints(oTarget) > 100 
			|| (iId == SPELL_ENTANGLE || iId==SPELL_WEB) && (GetIsImmune(oTarget, IMMUNITY_TYPE_ENTANGLE) || GetLevelByClass(CLASS_TYPE_DRUID, oTarget)>1) // immunity won't be so obvious at fir
			|| (iId==SPELL_GREASE || iId==SPELL_SPIKE_GROWTH) && GetLevelByClass(CLASS_TYPE_DRUID, oTarget)>1
			)
		{
			iRet = FALSE;	
		}
		
		//if we have a troll that is very low on health
		if(GetEventHandler(oTarget, CREATURE_SCRIPT_ON_DAMAGED) == "gb_troll_dmg" && GetCurrentHitPoints(oTarget) <= 10)
		{
			// if the spell immunity type is flame or acid, cast it
			if( SCGetSpellImmunityType(iId) == -2 || SCGetSpellImmunityType(iId) == -3)
			{
				iRet = TRUE;
			}	
			// otherwise don't waste the spell
			else
			{
				iRet = FALSE;
			}
		}
	}		
	return (iRet);
}



int SCEvenTalentCheck(talent tUse, object oTarget, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCEvenTalentCheck Start", GetFirstPC() ); }
    
    if(!GetIsTalentValid(tUse)) 
		return FALSE;
		
    int iId = GetIdFromTalent(tUse);
    int nTalentType=GetTypeFromTalent(tUse);
	
    if(nTalentType == TALENT_TYPE_SPELL) 
	{
		if(GetIsEnemy(oTarget)) 
		{
			if(GetSpellLevel(iId)==0) 
				return FALSE;
			int level=0;
			int spellcraft;
			if(GetGameDifficulty()>=GAME_DIFFICULTY_DIFFICULT) 
				spellcraft=40;
			else 
				spellcraft=GetSkillRank(SKILL_SPELLCRAFT)+d20();
				
			if(GetGameDifficulty()==GAME_DIFFICULTY_CORE_RULES) 
				spellcraft+=5;
				
			if(spellcraft>=11 && iId==SPELL_MAGIC_MISSILE && GetHasSpellEffect(SPELL_SHIELD, oTarget)) 
				return FALSE;
			else if(spellcraft>=16 && GetHasSpellEffect(SPELL_GLOBE_OF_INVULNERABILITY, oTarget)) 
				level=4;
			else if(spellcraft>=14 && GetHasSpellEffect(SPELL_LESSER_GLOBE_OF_INVULNERABILITY, oTarget)) 
				level=3;
			else if(spellcraft>=16 && GetHasSpellEffect(SPELL_ETHEREAL_VISAGE, oTarget)) 
				level=2;
			else if(spellcraft>=12 && GetHasSpellEffect(SPELL_GHOSTLY_VISAGE, oTarget)) 
				level=1;
			if(level) 
			{
				if(GetSpellLevel(iId)<=level)
						return FALSE;
			}
			int nTargetRacialType = GetRacialType(oTarget);
			
			if(iId==SPELL_CONTROL_UNDEAD || iId==SPELL_UNDEATH_TO_DEATH) 
			{
				if(nTargetRacialType != RACIAL_TYPE_UNDEAD)
						return FALSE;
			} 
			else 
			{
				int chance		= GetHitDice(oCharacter)+d20();
				int negimmune 	= nTargetRacialType==RACIAL_TYPE_UNDEAD ||
									nTargetRacialType==RACIAL_TYPE_CONSTRUCT || 
									GetSubRace(oTarget)==RACIAL_SUBTYPE_CONSTRUCT;
								
				int iselem		= nTargetRacialType==RACIAL_TYPE_ELEMENTAL;
				if(negimmune || iselem) 
					chance=20;
				if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES) 
					chance+=5;
				if(GetIsEnemy(oTarget, oCharacter) && chance>15) 
				{
					if (SCIsTargetImmuneToSpell(iId, oTarget))
						return FALSE;
				}
			}
			if (!SCIsSpellEffectiveAgainstTarget( iId, oTarget))
				return FALSE;
			
			if (SCMatchPersonSpells(iId) && !CSLGetIsHumanoid(oTarget))
				return FALSE;
			
			if (iId>=SPELL_BIGBYS_FORCEFUL_HAND && iId<=SPELL_BIGBYS_CRUSHING_HAND)
				if (GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTarget) ||
					GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTarget) ||
					GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTarget) ||
					GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTarget))
					return FALSE;
		}// end if(GetIsEnemy(oTarget))
		
		if ((iId == SPELL_KEEN_EDGE)) 
		{
			int nWeaponType = GetWeaponType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
			if ((nWeaponType == WEAPON_TYPE_BLUDGEONING)||(nWeaponType == WEAPON_TYPE_NONE))
			{
				return FALSE;
			}
		}
		
		if ((iId == SPELL_WEAPON_OF_IMPACT)) 
		{
			int nWeaponType = GetWeaponType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget));
			if (nWeaponType != WEAPON_TYPE_BLUDGEONING)
			{
				return FALSE;
			}
		}
		
		if(iId==SPELL_FLAME_WEAPON) 
		{
			if(!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget)) ||
				GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget)))
				return FALSE;
		}	
		if(iId==SPELL_SILENCE)
		{
        	if(!SCIsSafeToUseSilence(oTarget)) 
			{
           		return FALSE;
        	}
		}
		
    } // end if(nTalentType == TALENT_TYPE_SPELL) 
	
    return TRUE;
}





//::///////////////////////////////////////////////
//:: Verify Melee Talent Use
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//
//  Makes sure that certain talents are not used
//  on Elementals, Undead or Constructs
//
//  - December 18 2002: Do not use smite evil on good people
//
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 23, 2002
//:://////////////////////////////////////////////
int SCVerifyCombatMeleeTalent(talent tUse, object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCVerifyCombatMeleeTalent Start", GetFirstPC() ); }
    
    int iRet = TRUE;
    int nFeatID = GetIdFromTalent(tUse);
    if(nFeatID == FEAT_SAP ||
       nFeatID == FEAT_STUNNING_FIST)
    {
        int nRacial = GetRacialType(oTarget);
        if(nRacial == RACIAL_TYPE_CONSTRUCT ||
           nRacial == RACIAL_TYPE_UNDEAD ||
           nRacial == RACIAL_TYPE_ELEMENTAL ||
           nRacial == RACIAL_TYPE_VERMIN)
        {
            iRet = FALSE;
        }
    } 
    else if (nFeatID == FEAT_SMITE_EVIL) 
    {
        int nAlign = GetAlignmentGoodEvil(oTarget);
        if (nAlign != ALIGNMENT_EVIL)
        {
            iRet = FALSE;
        }            
    } 
    else if (nFeatID == FEAT_SMITE_GOOD) 
    {
        int nAlign = GetAlignmentGoodEvil(oTarget);
        if (nAlign != ALIGNMENT_GOOD)
        {
            iRet = FALSE;
        }            
    }
    
    return (iRet);
}


//::///////////////////////////////////////////////
//:: Verify Disarm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//    Checks that the melee talent being used
//    is Disarm and if so then if the target has a
//    weapon.
//
//    This should return TRUE if:
//    - we are not trying to use disarm
//    - we are using disarm appropriately
//
//    This should return FALSE if:
//    - we are trying to use disarm on an inappropriate target
//    - we are using disarm too frequently
//
//    If this returns FALSE, we will fall back to a standard
//    melee attack instead.
int SCVerifyDisarm(talent tUse, object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCVerifyDisarm Start", GetFirstPC() ); }
    
    if(GetTypeFromTalent(tUse) == TALENT_TYPE_FEAT
       && GetIdFromTalent(tUse) == FEAT_DISARM)
    {

        // * If the creature is not capable of being disarmed
        // * don't waste time trying to do so
        // * October 3, Brent
        if (GetIsCreatureDisarmable(oTarget) == FALSE)
        {
            return FALSE;
        }

        // * the associates given Disarm were given it intentionally
        // * they try to use this ability as often as possible
        int bIsAssociate = FALSE;
        if (GetIsObjectValid(GetMaster()) == TRUE)
        {
            bIsAssociate = TRUE;
        }
        // * disarm happens infrequently
        if (d10() > 4 && bIsAssociate == FALSE) return FALSE;

        object oSlot1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
        object oSlot2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

        if(GetIsObjectValid(oSlot1) || GetIsObjectValid(oSlot2))
        {
            if(GetIsObjectValid(oWeapon) && !GetWeaponRanged(oWeapon))
            {
                // Enemy has a weapon and so do we
                return TRUE;
            }
            else if (GetIsObjectValid(oWeapon2) && !GetWeaponRanged(oWeapon2))
            {
                // ditto
                return TRUE;
            } else {
                // they've got something, but we don't!
                // BK Changed this to return true. Creatures that do not
                // carry weapons should still be capable of disarming
                // people. If you don't want an unarmed creature to attempt
                // a disarm, then don't give it the disarm feat in the first place.
                return TRUE;
            }
        } else {
            // they don't have anything to disarm!
            return FALSE;
        }
    } // end if using FEAT_DISARM

    // We're not trying to use disarm, everything's OK
    return TRUE;
}



int SCEvenTalentFilter(talent tUse, object oTarget, int bJustTest=FALSE)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCEvenTalentFilter Start", GetFirstPC() ); }
	
	if(IsInConversation(oTarget)) 
		return FALSE;
	if(!GetIsTalentValid(tUse)) 
		return FALSE;
	if(bJustTest) 
		return SCEvenTalentCheck(tUse, oTarget);
		
	int iType=GetTypeFromTalent(tUse);
	ClearAllActions();
	CSLEquipAppropriateWeapons(oTarget, CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON));
	switch (iType)
	{
		case TALENT_TYPE_SPELL:
		{
			return SCEvenTalentSpellFilter(tUse, oTarget);
		}
			
		case TALENT_TYPE_FEAT:
			if (!SCVerifyCombatMeleeTalent(tUse, oTarget) || !SCVerifyDisarm(tUse, oTarget))
			{
				SCWrapperActionAttack(oTarget);
				return FALSE;
			}
			else
			{	
				int bFeatOkToUse = SCTalentFeatFilter(tUse, oTarget);
				if(!bFeatOkToUse)
				{
					SCWrapperActionAttack(oTarget);
					return bFeatOkToUse;
				}
			}
			
			break;
			
		case TALENT_TYPE_SKILL:
			break;
	}
    ActionUseTalentOnObject(tUse, oTarget);
    return TRUE;
}




// Special tactics for ranged fighters.
// The caller will attempt to stay in ranged distance and
// will make use of active ranged combat feats (Rapid Shot
// and Called Shot).
// If the target is too close and is not currently attacking
// the caller, the caller will instead try to find a ranged
// enemy to attack. If that fails, the caller will try to run
// away from the target to a ranged distance.
// This will fall through and return FALSE after three
// consecutive attempts to get away from an opponent within
// melee distance, at which point the caller will use normal
// tactics until they are again at a ranged distance from
// their target.
// Returns TRUE on success, FALSE on failure.
int SCSpecialTacticsRanged(object oTarget, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSpecialTacticsRanged Start "+GetName(oTarget), GetFirstPC() ); }
    
    // // MyPrintString("ranged combat");

    if (GetDistanceToObject(oTarget) < 5.0) {
        // too close to our target! move away.
        // MyPrintString("Too close to " + GetName(oTarget));
        int bFoundBetterTarget = FALSE;
        if (GetAttackTarget(oTarget) != oCharacter) {
            // they aren't attacking us, so let's check if
            // we have a ranged enemy
            object oRangedEnemy = CSLFindSingleRangedTarget(oCharacter);
            if (GetIsObjectValid(oRangedEnemy) && oRangedEnemy != oTarget) {
                oTarget = oRangedEnemy;
                bFoundBetterTarget = TRUE;
                // MyPrintString("Found better target: " + GetName(oTarget));
            }
        }

        if (!bFoundBetterTarget) {
            // prevent constant attempts to run away
            int nAttempts = GetLocalInt(oCharacter, "X0_MOVE_AWAY_ATTEMPTS");
            if (nAttempts < 3) {
                // MyPrintString("Trying to move away");
                ClearAllActions();
                ActionMoveAwayFromObject(oTarget, TRUE, 10.0);
                SetLocalInt(oCharacter, "X0_MOVE_AWAY_ATTEMPTS", nAttempts++);
            } else {
                // fall through to regular combat until
                // we're far enough away again
                // MyPrintString("Tried to move away too many times, giving up");
                return FALSE;
            }
        }
    } else {
        // MyPrintString("far enough away from " + GetName(oTarget));
        SetLocalInt(oCharacter, "X0_MOVE_AWAY_ATTEMPTS", 0);
    }

    if (! GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCharacter )) ) 
    {
        // MyPrintString("Not wielding ranged! Switching");
        ClearAllActions();
        ActionEquipMostDamagingRanged();
    }
	
	//make sure we've got ammo equipped if applicable
	int nWeaponType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
	int nAmmoType = -1;
	int nAmmoSlot = -1;
	object oAmmo;
	switch(nWeaponType)
	{
	case BASE_ITEM_LONGBOW:
	case BASE_ITEM_SHORTBOW:
		nAmmoType = BASE_ITEM_ARROW;
		nAmmoSlot = INVENTORY_SLOT_ARROWS;
		break;
	case BASE_ITEM_HEAVYCROSSBOW:
	case BASE_ITEM_LIGHTCROSSBOW:
		nAmmoType = BASE_ITEM_BOLT;
		nAmmoSlot = INVENTORY_SLOT_BOLTS;
		break;
	case BASE_ITEM_SLING:
		nAmmoType = BASE_ITEM_BULLET;
		nAmmoSlot = INVENTORY_SLOT_BULLETS;
		break;	
	}
	
	if(nAmmoType >= 0) //need to check for ammo
	{
		oAmmo = GetItemInSlot(nAmmoSlot);
		if(!GetIsObjectValid(oAmmo))
		{
			oAmmo = SCGetAmmoInInventory(nAmmoType);
			if(GetIsObjectValid(oAmmo))
			{
				ActionEquipItem(oAmmo, nAmmoSlot);
			}
		}
	}

    // Occasionally use active feats
    int nRand = Random(5);
    int nFeat = -1;
    if (nRand == 0 && GetHasFeat(FEAT_CALLED_SHOT, oCharacter)) {
        // try called shot if we have it
        nFeat = FEAT_CALLED_SHOT;
    }
    else if (nRand == 1 && GetHasFeat(FEAT_RAPID_SHOT, oCharacter) ) 
    {
    	// True if the item is a longbow or shortbow
		switch (GetBaseItemType( GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCharacter) ))
		{
			case BASE_ITEM_LONGBOW:
			case BASE_ITEM_SHORTBOW:
				nFeat = FEAT_RAPID_SHOT;
		}
    }

    if (nFeat != -1)
    {
        ClearAllActions();
        ActionUseFeat(nFeat, oTarget);
        return TRUE;
    }

    // If we fall through, just make a standard attack
    SCWrapperActionAttack(oTarget);
    return TRUE;
}

// Special tactics for ambushers.
// Ambushers will first attempt to get out of sight
// of their target if currently visible to that target.
// If not visible to the target, they will use any invisibility/
// hide powers they have.
// Once hidden, they will then attempt to attack the target using
// standard AI.
// Returns TRUE on success, FALSE on failure.
int SCSpecialTacticsAmbusher(object oTarget, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSpecialTacticsAmbusher Start "+GetName(oTarget), GetFirstPC() ); }
    
    int bIsSeen = GetObjectSeen(oCharacter, oTarget);
    int bTried = GetLocalInt(oCharacter, "X0_TRIED_TO_HIDE");
    if ( bIsSeen && !bTried) {
        ClearAllActions();

        // get out of sight
        ActionMoveAwayFromObject(oTarget, TRUE, 30.0);

        // use any hiding talents we have
        if (GetHasSkill(SKILL_HIDE)) {
            ActionUseSkill(SKILL_HIDE, oCharacter);
        }

        if (GetHasSkill(SKILL_MOVE_SILENTLY)) {
            ActionUseSkill(SKILL_MOVE_SILENTLY, oCharacter);
        }

// JLR - OEI 07/11/05 -- Name Changed
        if (!SCTrySpell(SPELL_GREATER_INVISIBILITY)) {
            SCTrySpell(SPELL_INVISIBILITY);
        }

        SetLocalInt(oCharacter, "X0_TRIED_TO_HIDE", TRUE);
        return TRUE;
    }

    if (!bIsSeen && GetDistanceToObject(oTarget) < 10.0) {
        // we successfully hid, so let's get ready to try it again
        SetLocalInt(oCharacter, "X0_TRIED_TO_HIDE", FALSE);
    }

    // If we're hidden and close by, just attack normally
    return FALSE;
}

// Special tactics for defensive fighters
// This will attempt to use the active defensive feats such as
// Knockdown and Combat Expertise, and also use Parry mode, when these
// are appropriate. Falls through to standard combat on failure.
// Returns TRUE on success, FALSE on failure.
int SCSpecialTacticsDefensive(object oTarget, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSpecialTacticsDefensive Start "+GetName(oTarget), GetFirstPC() ); }
    
    int nFeat = -1;
    int nSkill = -1;


    // use knockdown occasionally if we have it
    // and the target is not immune
    int nRand = Random(4);
    if (nRand == 0) {
        int nMySize = GetCreatureSize(oCharacter);
        if (GetHasFeat(FEAT_IMPROVED_KNOCKDOWN, oCharacter))
        {
            nFeat = FEAT_IMPROVED_KNOCKDOWN;
            nMySize++;
        } else if (GetHasFeat(FEAT_KNOCKDOWN, oCharacter))
        {
            nFeat = FEAT_KNOCKDOWN;
        }

        // prevent silly use of knockdown on immune or
        // too-large targets
        if (GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN)
            || GetCreatureSize(oTarget) > nMySize+1 )
            nFeat = -1;
    }

    // We use improved combat expertise if BAB+10 > opponent AC
    // We use combat expertise if BaseAttackBonus+15 > opponent AC
    // If we have both, use both.
    //int tempExpertise = 389;
    //int tempImprovedExpertise = 390;
    int bHasExpertise = GetHasFeat(FEAT_COMBAT_EXPERTISE, oCharacter);
    int bHasImprovedExpertise = GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE, oCharacter);
    if (nFeat == -1 && (bHasExpertise || bHasImprovedExpertise)) {
        int nBAB = GetBaseAttackBonus(oCharacter);
        int nAC = GetAC(oTarget);
        if (nBAB + 15 > nAC) {
            // we can use either
            if (nRand < 2) {
                nFeat = FEAT_IMPROVED_COMBAT_EXPERTISE;
            } else {
                nFeat = FEAT_COMBAT_EXPERTISE;
            }
        } else if (nBAB + 10 > nAC) {
            // only use improved
            nFeat = FEAT_IMPROVED_COMBAT_EXPERTISE;
        }
    }

    if (nFeat != -1) {
        // MyPrintString("Defensive combat: Using feat: " + IntToString(nFeat));
        CSLEquipAppropriateWeapons(oTarget);
        ActionUseFeat(nFeat, oTarget);
        return TRUE;
    }

	int bCombatModeUseDisabled = GetLocalInt( oCharacter, "N2_COMBAT_MODE_USE_DISABLED" );
	if ( bCombatModeUseDisabled == FALSE )
	{
		// Only use parry on an active melee attacker, and
		// only if our parry skill > our AC - 10
		// JE, Apr.14,2004: Bugfix to make this actually work. Thanks to the message board
		// members who investigated this.
		object oEnemy = GetLastHostileActor();
		if (GetIsObjectValid(oEnemy)
			&& GetAttackTarget(oEnemy) == oCharacter
			&& SCGetIsMeleeAttacker(oEnemy)
			&& oEnemy==oTarget)
		{
			int nParrySkill = GetSkillRank(SKILL_PARRY);
			int nAC = GetAC(oCharacter);
			if (nParrySkill > (nAC - 10) ) {
				// MyPrintString("Defensive combat: Using parry skill ");
				CSLEquipAppropriateWeapons(oTarget);
				//ActionUseSkill(SKILL_PARRY, oTarget);
				SetActionMode(oCharacter, ACTION_MODE_PARRY, TRUE);
				ActionAttack(oTarget);
				return TRUE;
			}
		}
	}
	
    // MyPrintString("falling through to normal tactics");
    // MyPrintString("last hostile: " + GetName(oEnemy));
    // MyPrintString("their attack target: " + GetName(GetAttackTarget(oEnemy)));

    return FALSE;
}




// Special tactics for cowardly creatures
// Cowards act as follows:
// - if you and your friends outnumber the enemy by 6:1 or
//   by more than 10, fall through to normal combat.
// - if you are currently being attacked by a melee attacker,
//   fight defensively (see SC SpecialTacticsDefensive).
// - if there is a "NW_SAFE" waypoint in your area that is
//   out of sight of the target, run to it.
// - otherwise, run away randomly from the target.
// Returns TRUE on success, FALSE on failure.
int SCSpecialTacticsCowardly(object oTarget, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSpecialTacticsCowardly Start "+GetName(oTarget), GetFirstPC() ); }
    
    // See what our overall situation looks like
    struct sSituation sitCurrent = SCCountEnemiesAndAllies();
    if ( ((sitCurrent.ENEMY_NUM + 10) <= (sitCurrent.ALLY_NUM + 1))
         ||
         ( (sitCurrent.ENEMY_NUM * 6) <= (sitCurrent.ALLY_NUM + 1))) {
        // me and my pals really outnumber the enemy
        // MyPrintString("Cowardly, but we outnumber the enemy");
        // MyPrintString("Enemies: " + IntToString(sitCurrent.ENEMY_NUM));
        // MyPrintString("Allies: " + IntToString(sitCurrent.ALLY_NUM));
        return FALSE;
    }

    // Are we pinned down by a melee attacker?
    object oLastEnemy = GetLastHostileActor();
    if ( GetIsObjectValid(oLastEnemy)
         && SCGetIsMeleeAttacker(oLastEnemy)
         && GetAttackTarget(oLastEnemy)==oCharacter) {
        // we're being attacked, so try and hold 'em off
        // MyPrintString("Under melee attack by " + GetName(oLastEnemy));
        return SCSpecialTacticsDefensive(oLastEnemy);
    }

    // Try and find someplace safe to run to
    int nNth = 1;
    object oSafe = GetNearestObjectByTag("NW_SAFE", oCharacter, nNth);
    while (GetIsObjectValid(oSafe) && GetObjectSeen(oSafe, oTarget))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        nNth++;
        oSafe = GetNearestObjectByTag("NW_SAFE", oCharacter, nNth);
    }
    if (GetIsObjectValid(oSafe))
    {
        // MyPrintString("Running to safepoint");
        ClearAllActions();
        ActionMoveToObject(oSafe);
        return TRUE;
    }

    // Failed, just try and run anywhere
    // MyPrintString("Running away anywhere");
    ClearAllActions();
    ActionMoveAwayFromObject(oTarget, TRUE, 30.0);
    return TRUE;
}

// This function checks for the special tactics flags and
// chooses tactics appropriately for each.
// Returns TRUE on success, FALSE on failure.
int SCSpecialTactics(object oTarget)
{
    if (CSLGetCombatCondition(CSL_COMBAT_FLAG_COWARDLY)
        && SCSpecialTacticsCowardly(oTarget))
        return TRUE;

    if (CSLGetCombatCondition(CSL_COMBAT_FLAG_AMBUSHER)
        && SCSpecialTacticsAmbusher(oTarget))
        return TRUE;

    if (CSLGetCombatCondition(CSL_COMBAT_FLAG_RANGED)
        && SCSpecialTacticsRanged(oTarget))
        return TRUE;

    if (CSLGetCombatCondition(CSL_COMBAT_FLAG_DEFENSIVE)
        && SCSpecialTacticsDefensive(oTarget))
        return TRUE;

    return FALSE;

}



// * had to add this commandable wrapper to track down a bug in the henchmen
void SCWrapCommandable(int bCommand, object oHench)
{
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "SCWrapCommandable Start", GetFirstPC() ); }
/*   string s ="";
    if (bCommand)
        s = "TRUE";
    else
        s = "FALSE";
    SendMessageToPC(GetFirstPC(), GetName(oCharacter) + " commandable set to " + s);*/
    int iIteration = 0;
    while ( GetCommandable(oHench) != bCommand && iIteration < 30 )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        iIteration++;
        SetCommandable(bCommand, oHench);
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCWrapCommandable End", GetFirstPC() ); }
}





/*** DEATH FUNCTIONS ***/

// Set on the henchman to indicate s/he died; can also be used to
// unset this variable.
void SCSetDidDie(int bDie=TRUE, object oHench=OBJECT_SELF)
{
    CSLSetBooleanValue(oHench, HENCH_DEATH_VARNAME, bDie);
}


// Set got killed
void SCSetKilled(object oPC, object oHench=OBJECT_SELF, int bKilled=TRUE)
{
    CSLSetBooleanValue(oPC, GetTag(oHench) + "_GOTKILLED", bKilled);
}



// Set that this PC resurrected the henchman
void SCSetResurrected(object oPC, object oHench=OBJECT_SELF, int bResurrected=TRUE)
{
    CSLSetBooleanValue(oPC, GetTag(oHench) + "_RESURRECTED", bResurrected);
}

// Determine if this PC resurrected the henchman
int SCGetResurrected(object oPC, object oHench=OBJECT_SELF)
{
    return CSLGetBooleanValue(oPC, GetTag(oHench) + "_RESURRECTED");
}



// Handle the respawning of the henchman back at either the
// respawn location or the starting location
void SCRespawnHenchman(object oHench=OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCRespawnHenchman Start", GetFirstPC() ); }
	
    // : REMINDER: The delay is here for a reason
    // Remove effects on the henchman
    DelayCommand(0.1, CSLRemoveAllEffects(oHench));

    // Resurrect
    DelayCommand(0.2,
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                     EffectResurrection(),
                                     oHench));

    // Heal back to full hp
    DelayCommand(0.3,
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                     EffectHeal(GetMaxHitPoints(oHench)),
                                     oHench));

    // Set back to destroyable
    DelayCommand(5.1,
                 AssignCommand(oHench,
                               SetIsDestroyable(TRUE, TRUE, TRUE)));


    // Handle sending back to respawn point
    location lRespawn = SCGetRespawnLocation(oHench);

    // Check for validity
    if (GetIsObjectValid(GetAreaFromLocation(lRespawn)))
    {
        DelayCommand(0.3, JumpToLocation(lRespawn));
    }// else
    //{
    //    DelayCommand(0.3, ActionSpeakString("NO VALID RESPAWN POINT FOUND"));
    //}
}




// Stop keeping dead by playing the 'woozy' standing animation.
void SCStopKeepingDead(object oHench=OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCStopKeepingDead Start", GetFirstPC() ); }
    
    DelayCommand(0.1, SCWrapCommandable(TRUE, oHench));
    DelayCommand(0.2, AssignCommand(oHench, PlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 6.0)));
    DelayCommand(0.3, SCWrapCommandable(FALSE, oHench));
}


// *returns true if oHench is a follower
int SCGetIsFollower(object oHench)
{
    return GetLocalInt(oHench, "X2_JUST_A_FOLLOWER");
}

// * count number of henchman
// * if nFollowersInstead = TRUE then count the # of
int SCGetNumberOfHenchmen(object oPC, int bFollowersInstead=FALSE)
{
    //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "SCGetNumberOfHenchmen Start", GetFirstPC() ); }
    
    int i = 1;
    int nCount = 0;
    int bDone = FALSE;
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
	
	while ( GetIsObjectValid(oHench) )
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		if (bFollowersInstead == FALSE && SCGetIsFollower(oHench) == FALSE)
		{
			nCount++;
		}
		else if (bFollowersInstead == TRUE && SCGetIsFollower(oHench) == TRUE)
		{
			nCount++;
		}
	
		i++;
		oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
	}
	
	/*
	
	
	
    do
    {
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
        i++;
        if (GetIsObjectValid(oHench) == TRUE)
        {
			// * if the creature is marked as a follower
			// * they do not count against the henchman limit
			if (bFollowersInstead == FALSE && SCGetIsFollower(oHench) == FALSE)
			{
				nCount++;
			}
			else if (bFollowersInstead == TRUE && SCGetIsFollower(oHench) == TRUE)
			{
				nCount++;
			}
        }
        else
        {
            bDone = TRUE;
        }
    }
    while (bDone == FALSE );
    */
	
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCGetNumberOfHenchmen End", GetFirstPC() ); }
	
    return nCount;

}

// * Fires the first henchman who is not
// * a follower
void SCFireFirstHenchman(object oPC)
{
    int i = 1;
    int bDone = FALSE;
    
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
	while( GetIsObjectValid(oHench) )
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		if (SCGetIsFollower(oHench) == FALSE)
		{
			SCAIFireHenchman(oPC, oHench);
			bDone = TRUE;
		}
			i++;
		oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
	}
	
	/*
    do
    {
        oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
        i++;
        if (GetIsObjectValid(oHench) == TRUE)
        {
            // * if the creature is marked as a follower
            // * they do not count against the henchman limit
            if (SCGetIsFollower(oHench) == FALSE)
            {
                SCAIFireHenchman(oPC, oHench);
                bDone = TRUE;
            }
        }
        else
        {
            bDone = TRUE;
        }
    }
    while (bDone == FALSE);
	*/

}

// Indicate whether the player has ever hired this henchman
void SCSetPlayerHasHired(object oPC, object oHench=OBJECT_SELF, int bHired=TRUE)
{
    if (!GetIsObjectValid(oHench))
    {
    	return;
    }
    CSLSetBooleanValue(oPC, GetTag(oHench) + "_HIRED", bHired);
}

// Determine whether the player has ever hired this henchman
int SCGetPlayerHasHired(object oPC, object oHench=OBJECT_SELF)
{
    if (!GetIsObjectValid(oHench)) {return FALSE;}
    return CSLGetBooleanValue(oPC, GetTag(oHench) + "_HIRED");
}


// Indicate whether the player has ever hired this henchman in this
// campaign.
void SCSetPlayerHasHiredInCampaign(object oPC, object oHench=OBJECT_SELF, int bHired=TRUE)
{
    if (!GetIsObjectValid(oHench)) {return;}
    SCSetCampaignBooleanValue(oPC, GetTag(oHench) + "_HIRED", bHired);
}

// Set the last master
void SCSetLastMaster(object oPC, object oHench=OBJECT_SELF)
{
    SetLocalObject(oHench, HENCH_LASTMASTER_VARNAME, oPC);
}

// Set whether the henchman quit this player's employ
void SCSetDidQuit(object oPC, object oHench=OBJECT_SELF, int bQuit=TRUE)
{
    if (!GetIsObjectValid(oHench)) {return;}
    CSLSetBooleanValue(oPC, GetTag(oHench) + "_QUIT", bQuit);
}

// Levels a henchman up to the given level, alternating
// between the first and second classes if they are multiclassed.
// 0 as a max level means they will try to keep their levels balanced
void SCLevelHenchmanUpTo(object oHenchman, int nLevel, int nClass2=CLASS_TYPE_INVALID, int nMaxLevelInSecondClass=0, int nPackageClass1=PACKAGE_INVALID, int nPackageClass2=PACKAGE_INVALID)
{
	//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "SCLevelHenchmanUpTo Start", GetFirstPC() ); }
    int nPackageToUse = nPackageClass1;


    if ( !GetIsObjectValid(oHenchman) || GetHitDice(oHenchman) >= nLevel)
        return;

    // * she has 3 rogue levels, decrement nLevel by this
    if (GetTag(oHenchman) == "x2_hen_nathyra" && nClass2 == CLASS_TYPE_ASSASSIN)
    {
        nLevel = nLevel - 3;
    }

    int nClass1 = GetClassByPosition(1, oHenchman);
    if (nClass2 == CLASS_TYPE_INVALID)
    {
        nClass2 = GetClassByPosition(2, oHenchman);
    }

    int nLevel1 = GetLevelByClass(nClass1, oHenchman);
    int nLevel2 = GetLevelByClass(nClass2, oHenchman);

    int nClassToLevelUp;

    while ( (nLevel1 + nLevel2) < nLevel )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if ( nClass2 != CLASS_TYPE_INVALID && (nLevel1 > nLevel2) )
        {
            nClassToLevelUp = nClass2;
            nLevel2++;
            nPackageToUse = nPackageClass2;
        }
        else
        {
            nClassToLevelUp = nClass1;
             nPackageToUse = nPackageClass1;
            nLevel1++;
        }

        // * if you have exceeded your max level in the second class
        // * only level up in the first class from this point forward
        if (nLevel2 > nMaxLevelInSecondClass)
        {
            nClassToLevelUp = nClass1;
            nPackageToUse = nPackageClass1;
        }

        // * Additional Rules
        // * The player can choose a levelup stratedgy for the henchman
        // * 0 = Normal, as per designer rules
        // * 1 = Secondary Class: only take levels in your second class
        // * 2 = First class: only take levels in your first class
        // * Note: This choice overrides the above nMaxLevelInSecondClass
        int nRule = GetLocalInt(oHenchman, "X0_L_LEVELRULES");

        // HACK: If in XP2, reverse the rules
        if (GetLocalInt(GetModule(), "X2_L_XP2") == 1)
        {
            if (nRule == 1)
             nRule = 2;
            else
            if (nRule == 2)
             nRule = 1;
        }

        if (nRule == 1)
        {
            nClassToLevelUp = nClass2;
            nPackageToUse = nPackageClass2;
        }
        else
        if (nRule == 2)
        {
            nClassToLevelUp = nClass1;
        }
        if (!LevelUpHenchman(oHenchman, nClassToLevelUp, FALSE, nPackageToUse))
        {
            // * In case the levelup failed (july 2003) for a prestige class
            // * try one more time to levelup the primary class.
            // * this way classes with an alternate prestige class will attempt
            // * always to gain that class but fail until they meet the prereqs
            // Feb. 11, 2004 - JE: Made this more generic, to fix evil aribeth
            // at high levels. Instead of trying class 1, it tries the OTHER class,
            // since it's possible for the first class to fail.
            int nClassToLevelUp2;
            if(nClassToLevelUp==nClass2)
            {
                nClassToLevelUp2 = nClass1;
                nPackageToUse = nPackageClass1;
            }
            else
            {
                nClassToLevelUp2 = nClass2;
                nPackageToUse = nPackageClass2;
            }
            if (nClassToLevelUp2==CLASS_TYPE_INVALID ||
                !LevelUpHenchman(oHenchman, nClassToLevelUp2, FALSE, nPackageToUse))
            {
                SendMessageToPC(GetFirstPC(), "Level Up Failed For "
                                              + GetName(oHenchman)
                                              + " in class "
                                              + IntToString(nClassToLevelUp));

                //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCLevelHenchmanUpTo End", GetFirstPC() ); }
                return;
            }
        }
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCLevelHenchmanUpTo End", GetFirstPC() ); }
}



// * Adjusts the levels for the henchmen
int SCAdjustXP2Levels(int nLevel, int nMin=13, int nAdjust=2)
{
    nLevel = nLevel - nAdjust;
    if (nLevel < nMin)
     nLevel = nMin;
    return nLevel;
}





// * levels up the henchman assigned to oPC
// * Modified for XP2 so that it cycles through
// * all the available henchmen and levels them all up
// *
void SCLevelUpXP1Henchman(object oPC)
{
    //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "SCLevelUpXP1Henchman Start", GetFirstPC() ); }
    
    if ( !GetIsObjectValid(oPC) )
        return;

    int i = 1;
    object oAssociate;
    for (i=1; i<= GetMaxHenchmen(); i++)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        oAssociate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);

        if ( GetIsObjectValid(oAssociate) )
        {
            // * Followers do not level up
            if (GetLocalInt(oAssociate, "X2_JUST_A_FOLLOWER") == FALSE)
            {
                int nResult;
                int nLevel = GetHitDice(oPC);
                string sTag = GetStringLowerCase(GetTag(oAssociate));



                // ********************************
                // XP2 Stuff
                // * if a mini henchman
                // * nLevel = nLevel - 2;
                // * because they are always 2 levels
                // * behind the player.
                // ********************************
                if (sTag == "x2_hen_deekin")
                {
                    //nLevel = SC AdjustXP2Levels(nLevel);
                    SCLevelHenchmanUpTo(oAssociate, nLevel, 37, 40, 72, 117);
                }
                else
                if (sTag == "x2_hen_daelan")
                {
                    // * druid would have to be exposed
                    nLevel = SCAdjustXP2Levels(nLevel);
                    SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_DRUID, 0, 105);
                }
                else
                if (sTag == "x2_hen_sharwyn")
                {
                    nLevel = SCAdjustXP2Levels(nLevel);
                    SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_FIGHTER, 40, 106, 114);
                }
                else
                if (sTag == "x2_hen_linu")
                {
                // * leveling up as a fighter would have to be exposed
                    nLevel = SCAdjustXP2Levels(nLevel);
                    SCLevelHenchmanUpTo(oAssociate, nLevel,CLASS_TYPE_FIGHTER , 0, 104);
                }
                else
                if (sTag == "x2_hen_tomi")
                {   
                    nLevel = SCAdjustXP2Levels(nLevel);
                    SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_SHADOWDANCER, 40, 103, 116);
                }
                else
                if (sTag == "x2_hen_nathyra")
                {
                    // After one level of wizard
                    // she will take one level of rogue.

                    if (GetHitDice(oAssociate) <= 6)
                    {
                        SCLevelHenchmanUpTo(oAssociate, 12, CLASS_TYPE_ROGUE, 3, 101, 8);
                        if (nLevel >= 14)
                            SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_ASSASSIN, 40, 101, 115);
                    }
                    else
                    {
                        SCLevelHenchmanUpTo(oAssociate, nLevel , CLASS_TYPE_ASSASSIN, 40, 101, 115);
                    }
                }
                else
                if (sTag == "x2_hen_valen")
                {
                    SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_WEAPON_MASTER, 40, 102,113);
                }
                else
                // * Aribeth
                if (sTag =="h2_aribeth")                {
                    /* Aribeth has special rules
                       - if she is good, she'll level up as a paladin
                       - if she is evil, she'll level up as a blackguard
                    */
                    if (GetAlignmentGoodEvil(oAssociate) == ALIGNMENT_GOOD)
                    {
                        SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_INVALID, 0, 129);
                    }
                    else
                    // Blackguard
                    {
                        SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_BLACKGUARD, 40, 129, 130);
                    }

                }


                // ********************************
                // XP1 Stuff
                // ********************************
                if ( sTag == "x0_hen_xan" )
                {
                    SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_BARBARIAN, 2);
                }
                else if (sTag == "x0_hen_dor")
                {
                    SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_CLERIC, 20);
                }
                else if (sTag == "x0_hen_dee")
                {
                    SCLevelHenchmanUpTo(oAssociate, nLevel, CLASS_TYPE_ROGUE, 0);
                }
                else
                {
                    SCLevelHenchmanUpTo(oAssociate, nLevel);
                }
            } // Follower
        } // valid associate
    } // Loop
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCLevelUpXP1Henchman End", GetFirstPC() ); }
}



// Can be used for both initial hiring and rejoining.
void SCHireHenchman(object oPC, object oHench=OBJECT_SELF, int bAdd=TRUE)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHireHenchman Start", GetFirstPC() ); }
    
    if ( !GetIsObjectValid(oPC) || !GetIsObjectValid(oHench) )
    {
        return;
    }

    // Fire the PC's former henchman if necessary
//    object oFormerHench = GetAss*ociate(ASSOCIATE_TYPE_HENCHMAN, oPC, 1);
    int nCountHenchmen = SCGetNumberOfHenchmen(oPC);
    int nNumberOfFollowers = SCGetNumberOfHenchmen(oPC, TRUE);
    // * The true number of henchmen are the number of hired
    nCountHenchmen = nCountHenchmen ;

    int nMaxHenchmen = X2_NUMBER_HENCHMEN;

    // Adding this henchman would exceed the module imposed
    // henchman limit.
    // Fire the first henchman
    // The third slot is reserved for the follower
    if ( (nCountHenchmen  >= nMaxHenchmen) && bAdd == TRUE)
    {
        SCFireFirstHenchman(oPC);
    }


    // Mark the henchman as working for the given player
    if (!SCGetPlayerHasHired(oPC, oHench))
    {
        // This keeps track if the player has EVER hired this henchman
        // Floodgate only (XP1). Should never store info to a database as game runs, only between modules or in Persistent setting
        if (GetLocalInt(GetModule(), "X2_L_XP2") !=  1)
        {
            SCSetPlayerHasHiredInCampaign(oPC, oHench);
        }
        SCSetPlayerHasHired(oPC, oHench);
    }
    SCSetLastMaster(oPC, oHench);

    // Clear the 'quit' setting in case we just persuaded
    // the henchman to rejoin us.
    SCSetDidQuit(oPC, oHench, FALSE);

    // If we're hooking back up with the henchman after s/he
    //  died, clear that.
    SCSetDidDie(FALSE, oHench);
    SCSetKilled(oPC, oHench, FALSE);
    SCSetResurrected(oPC, oHench, FALSE);

    // Turn on standard henchman listening patterns
    SetAssociateListenPatterns(oHench);

    // By default, companions come in with Attack Nearest and Follow
    // modes enabled.
    SetLocalInt(oHench, "NW_COM_MODE_COMBAT", ASSOCIATE_COMMAND_ATTACKNEAREST);
    SetLocalInt(oHench, "NW_COM_MODE_MOVEMENT", ASSOCIATE_COMMAND_FOLLOWMASTER);

    // Add the henchman
    if (bAdd == TRUE)
    {
        AddHenchman(oPC, oHench);
        DelayCommand(1.0, AssignCommand(oHench, SCLevelUpXP1Henchman(oPC)));
    }

}

// * Wrapper function added to fix bugs in the dying-state
// * process. Need to figure out whenever his value changes.
void SCSetHenchmanDying(object oHench=OBJECT_SELF, int bIsDying=TRUE)
{
    CSLSetAssociateState(CSL_ASC_MODE_DYING, bIsDying, oHench);
}



void SCPostRespawnCleanup(object oHench=OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCPostRespawnCleanup Start", GetFirstPC() ); }
    
    DelayCommand(1.0, SCSetHenchmanDying(oHench, FALSE));

    // Clear henchman being busy
    DelayCommand(1.1, CSLSetAssociateState(CSL_ASC_IS_BUSY, FALSE, oHench));

    // Clear the plot flag
    DelayCommand(1.2, SetPlotFlag(oHench, FALSE));

}



// This function actually invokes the respawn.
void SCDoRespawn(object oPC, object oHench=OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCDoRespawn Start", GetFirstPC() ); }
	
	SCStopKeepingDead(oHench);
	
	// Set henchman commandable
	DelayCommand(0.4,
					SCWrapCommandable(TRUE, oHench));
	
	// if (GetCurrentHitPoints(oHench) > 0)
	if (GetLocalInt(oHench, "X0_L_WAS_HEALED") == 10)
	{
		SetLocalInt(oHench, "X0_L_WAS_HEALED",0);
		// Hey, we've been stabilized! Good on you, master.
		SCSetResurrected(oPC, oHench);
	
		// Automatically re-add the henchman   BK 2003 Don't rehire them completely since they were never not hired.
		SCHireHenchman(oPC, oHench, FALSE);
	}
	else
	{
	
		// * only in Chapter 1 will the henchmen respawn
		// * somewhere, otherwise they'll stay where they are.
		if (GetTag(GetModule()) == "x0_module1")
		{
			// Indicate that this master got us killed
			SCSetKilled(oPC, oHench);
			RemoveHenchman(oPC, oHench);
			// Do the respawn
			DelayCommand(1.0, SCRespawnHenchman(oHench));
		}
	}
	SCPostRespawnCleanup(oHench);
}


// Determine if this henchman is currently dying
int SCGetIsHenchmanDying(object oHench=OBJECT_SELF)
{
    int bHenchmanDying = CSLGetAssociateState(CSL_ASC_MODE_DYING, oHench);
    if (bHenchmanDying == TRUE)
    {
        //brentDebug("henchman is dying");
        return TRUE;
    }
    else
    {
        //brentDebug("Henchman is not dying");
        return FALSE;
    }
}


// See if our maximum wait time has passed
int SCGetHasMaxWaitPassed(int nChecks)
{
    return ( (nChecks * HENCH_DELAY_BETWEEN_RESPAWN_CHECKS) >= HENCH_MAX_RESPAWN_WAIT ) ;
}


// Do the checking to see if we respawn -- this function works
// in a circle with SCAIDoRespawnCheck.
void SCRespawnCheck(object oPC, int nChecks=0, object oHench=OBJECT_SELF)
{
    //DBG_msg("Doing respawn check " + IntToString(nChecks + 1));
    DelayCommand(HENCH_DELAY_BETWEEN_RESPAWN_CHECKS, SCAIDoRespawnCheck(oPC, nChecks+1, oHench));
}


// Perform a single respawn check -- this function works
// in a circle with SC RespawnCheck.
void SCAIDoRespawnCheck(object oPC, int nChecks, object oHench=OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAIDoRespawnCheck Start", GetFirstPC() ); }
    
    // * if a healing spell has been used on henchmen, they ain't dead no more
    if (SCGetIsHenchmanDying(oHench) == FALSE)
        return;

    if ( GetCurrentHitPoints(oHench) == 1 && SCGetHasMaxWaitPassed(nChecks))
    {
        SCDoRespawn(oPC, oHench);
    }
    else if (GetCurrentHitPoints(oHench) == 1
        &&
        ( GetArea(oPC) != GetArea(oHench) || GetIsDead(oPC)) )
    {
        SCDoRespawn(oPC, oHench);
    }
    else if (GetCurrentHitPoints(oHench) > 1 && !SCGetResurrected(oPC))
    {
        // We're alive, must have been resurrected
        // Do the 'respawn' anyway to clean up after death
        //DBG_msg("Master stabilized us, respawning");
        SCDoRespawn(oPC, oHench);
    }
    else
    {
        // We aren't resurrecting yet, but keep checking
        SCRespawnCheck(oPC, nChecks, oHench);
    }
}



// Returns TRUE if the henchman is currently hired
int SCGetIsHired(object oHench=OBJECT_SELF)
{
    return GetIsObjectValid(GetMaster(oHench));
}




// Use to fire the PC's current henchman
void SCAIFireHenchman(object oPC, object oHench=OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAIFireHenchman Start", GetFirstPC() ); }
    
    if ( !GetIsObjectValid(oPC) || !GetIsObjectValid(oHench) )
    {
        //DBG_msg("Invalid PC or henchman!");
        return;
    }
    // * turn off stealth mode
    SetActionMode(oHench, ACTION_MODE_STEALTH, FALSE);
    // If we're firing the henchman after s/he died,
    // clear that first, since we're not really "hired"
    SCSetDidDie(FALSE, oHench);
    SCSetKilled(oPC, oHench, FALSE);
    SCSetResurrected(oPC, oHench, FALSE);

    // Now double-check that this is actually our master
    if (!SCGetIsHired(oHench) || GetMaster(oHench) != oPC)
    {
        //DBG_msg("SC FireHenchman: not hired or this PC isn't her master.");
        return;
    }

    // Remove the henchman
    AssignCommand(oHench, ClearAllActions());
    RemoveHenchman(oPC, oHench);

    //Store former henchmen for retrieval in Interlude
    // April 28 2003. This storage only happens in Chapter 1
    string sModTag = GetTag(GetModule());
    if (sModTag == "x0_module1")
    {
        if (GetTag(oHench) == "x0_hen_xan")
            StoreCampaignObject("dbHenchmen", "xp0_hen_xan", oHench);
        else if (GetTag(oHench) == "x0_hen_dor")
            StoreCampaignObject("dbHenchmen", "xp0_hen_dor", oHench);
    }

    // Clear everything that was previously set, EXCEPT
    // that the player has hired -- that info we want to
    // keep for the future.

    // Clear this out so if the henchman gets killed while
    // unhired, she won't think this PC is still her master
    SCSetLastMaster(OBJECT_INVALID, oHench);

    // Clear dialogue events
    SCClearAllDialogue(oPC, oHench);

    // Send the henchman home
    // APril 2003: Cut this. Make them stay where they are.
   // ExecuteScript(HENCH_GOHOME_SCRIPT, oHench);
}











// * Oct 14 - added the oHench parameters
string SCGetDialogFile(object oPC, string sHenchmenDlg, string sPreHenchDlg, object oHench=OBJECT_SELF)
{
        if ( SCGetPlayerHasHired(oPC, oHench) == TRUE)
        {
            return sHenchmenDlg;
        }
        else
        {
            return sPreHenchDlg;

        }
}

//::///////////////////////////////////////////////
//:: SC GetDialogFileToUse
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the filename for the appropriate
    dialog file to be used.

    Henchmen have various dialog files throughout
    the game.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: August 2003
//:://////////////////////////////////////////////

string SCGetDialogFileToUse(object oPC, object oHench = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetDialogFileToUse Start", GetFirstPC() ); }
    
    string sTag = GetTag(oHench);
    string sModuleTag = GetTag(GetModule());
    // * Chapter 2

    // * Chapter 1 only
    if (sModuleTag == "x0_module1")
    {
        if (sTag == "x2_hen_sharwyn")
        {
            return SCGetDialogFile(oPC, "xp2_hen_shar", "q2asharwyn", oHench);
        }
        else
        if (sTag == "x2_hen_daelan")
        {
            return SCGetDialogFile(oPC, "xp2_hen_dae", "q2adaelan", oHench);
        }
        else
        if (sTag == "x2_hen_tomi")
        {
            return SCGetDialogFile(oPC, "xp2_hen_tomi", "q2atomi", oHench);
        }
        else
        if (sTag == "x2_hen_linu")
        {
            return SCGetDialogFile(oPC, "xp2_hen_linu", "q2alinu", oHench);
        }
        else
        if (sTag == "x2_hen_deekin")
        {
            return SCGetDialogFile(oPC, "xp2_hen_dee", "pre_deekin", oHench);
        }
    }
    else
    if (sModuleTag == "x0_module2" || sModuleTag == "x0_module3")
    {
        // * valen and nathyrra have area specific dialog
        string sAreaTag = GetTag(GetArea(oPC));
        if (sTag == "x2_hen_valen")
        {
            if (sAreaTag == "q2a1_temple"  && !GetIsObjectValid(GetMaster(oHench)))
            {
                return "xp2_valen";
            }

            return "xp2_hen_val";
        }
        else
        if (sTag == "x2_hen_nathyra" )
        {
            if (sAreaTag == "q2a1_temple" && !GetIsObjectValid(GetMaster(oHench)))
            {
                return "xp2_nathyrra";
            }

            return "xp2_hen_nat";
        }
    }
    return "";
}



//::///////////////////////////////////////////////
//:: SC AdjustBehaviorVariable
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

// Overriding "behavior" variables.
// If a variable has been stored on the creature it overrides the above
// class defaults

int SCAdjustBehaviorVariable(int nVar, string sVarName, object oCharacter = OBJECT_SELF)
{
    int nPlace =GetLocalInt(oCharacter, sVarName);
    if (nPlace > 0)
    {
        return nPlace;
    }
    //return nVar; // * return the original value
    return 0;
}


// Return the combat difficulty.
// This is only used for henchmen and its only function currently
// is to keep henchmen from casting spells in an easy fight.
// This determines the difficulty by counting the number of allies
// and enemies and their respective CRs, then converting the value
// into a "spell CR" rating.
// A value of 20 means use whatever you have, a negative value
// means a very easy fight.
// * Only does something if Enable is turned on, since I originally turned this function off
int SCGetCombatDifficulty(object oRelativeTo= OBJECT_SELF, int bEnable=FALSE)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetCombatDifficulty Start", GetFirstPC() ); }
    
    // DECEMBER 2002
    // * if I am not a henchman then DO NOT use combat difficulty
    // * simply use whatever I have available

    // FEBRUARY 2003
    // * Testing indicated that people were just too confused
    // * when they saw their henchmen not casting spells
    // * so this functionality has been cut entirely.

    // if (GetHenchman(GetMaster()) != oRelativeTo)
    if (bEnable == FALSE)
        return 20;

    // * Count Enemies
    struct sSituation sitCurr = SCCountEnemiesAndAllies(20.0, oRelativeTo);
    int nNumEnemies = sitCurr.ENEMY_NUM;
    int nNumAllies = sitCurr.ALLY_NUM;
    int nAllyCR = sitCurr.ALLY_CR;
    int nEnemyCR = sitCurr.ENEMY_CR;

    // * If for some reason no enemies then return low number
    if (nNumEnemies == 0) return -3;
    if (nNumAllies == 0) nNumAllies = 1;

    // * Average CR of enemies vs. Average CR of the players
    // * The + 5.0 is for flash. It would be boring if equally matched
    // * opponents never cast spells at each other.
    int nDiff = (nEnemyCR/nNumEnemies) - (nAllyCR/nNumAllies) + 3;

    // * if my side is outnumbered, then add difficulty to it
    if (nNumEnemies > (nNumAllies + 1))
        nDiff += 10;

    if (nDiff <= 1)
        return -2;

    // We now convert this number into the "spell CR" --
    // spell CR is as follows:
    // spell innate level * 2 - 1
    // eg, cantrip: innate level 0: spell CR -1
    // level 1 spell: innate level 1: spell CR 1
    // level 4 spell: innate level 4: spell CR 7
    // etc
    nDiff = (nDiff * 2) - 1;

    // * If I am at less than 50% hit-points add +10 -->
    // * it means that things are going badly for me
    // * and I need an edge
    if (GetCurrentHitPoints() <= GetMaxHitPoints()/2)
    {
        nDiff = nDiff + 10;
	}
    // * if not a low number then just return the difficulty
    // * converted into 'spell rounding'
    return nDiff;
}




//    A more intelligent invisibility solution,
//    along the lines of the one used in
//    the various end-user AIs.
//:: Created By:  Brent
//:: Created On:  June 14, 2003
// EPF 6/5/06 -- Added Warlock options for invisibility.
int SCInvisibleBecome(object oSelf = OBJECT_SELF, int isInvis=FALSE)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInvisibleBecome Start", GetFirstPC() ); }
	
	if(GetLocalInt(oSelf, "X2_L_STOPCASTING") == 10) {
		if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oSelf))
        	SetActionMode(oSelf, ACTION_MODE_STEALTH, TRUE);
		return FALSE;
	}
	
	int hasDarkness		=  GetHasSpellEffect(SPELL_DARKNESS, oSelf) 
						|| GetHasSpellEffect(SPELL_I_DARKNESS, oSelf) 
						|| GetHasSpellEffect(SPELL_SHADOW_CONJURATION_DARKNESS, oSelf);
						
	int iWarlockDarkness = GetHasSpell(SPELL_I_DARKNESS, oSelf) && !hasDarkness;
    int iDarkness 		= GetHasSpell(SPELL_DARKNESS, oSelf) && !hasDarkness;
	
	if (GetHasSpell(SPELL_GREATER_INVISIBILITY, oSelf) 
		|| GetHasSpell(SPELL_INVISIBILITY, oSelf) 
		|| GetHasSpell(724, oSelf) 
		|| GetHasSpell(SPELL_INVISIBILITY_SPHERE, oSelf) 
		|| iDarkness 
		|| iWarlockDarkness 
		|| GetHasSpell(SPELL_SANCTUARY, oSelf) 
		|| GetHasSpell(SPELL_ETHEREALNESS, oSelf) 
		|| GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oSelf) == TRUE 
		|| GetHasSpell(SPELL_I_RETRIBUTIVE_INVISIBILITY, oSelf) 
		|| GetHasSpell(SPELL_I_WALK_UNSEEN, oSelf))
    {
        if(isInvis<=0) // close or not invisible
        {
            object oSeeMe = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oSelf, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_TRUE_SEEING);
            if(!GetIsObjectValid(oSeeMe))
            {
				int nDiff = SCGetCombatDifficulty(oSelf, TRUE);
                if (nDiff > -1)
                {
					if (GetHasSpell(SPELL_ETHEREALNESS, oSelf)) {
                        ClearAllActions();
						AssignCommand(oSelf, ActionCastSpellAtObject(SPELL_ETHEREALNESS, oSelf) );
                        return TRUE;
					} else if(GetHasSpell(724, oSelf)) { // ethereal jaunt
                        ClearAllActions();
						AssignCommand(oSelf,ActionCastSpellAtObject(724, oSelf) );
                        return TRUE;
					}
					
					if(!isInvis) 
					{ // don't do if close
						oSeeMe = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oSelf, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_SEE_INVISIBILITY);
						if(!GetIsObjectValid(oSeeMe)) 
						{
							ClearAllActions();
							if(GetHasSpell(SPELL_I_RETRIBUTIVE_INVISIBILITY, oSelf)) {
								AssignCommand(oSelf,ActionCastSpellAtObject(SPELL_I_RETRIBUTIVE_INVISIBILITY, oSelf, METAMAGIC_NONE, TRUE));
								return TRUE;
							} else if(GetHasSpell(SPELL_GREATER_INVISIBILITY, oSelf)) {
								AssignCommand(oSelf,ActionCastSpellAtObject(SPELL_GREATER_INVISIBILITY, oSelf));
								return TRUE;
							} else if(GetHasSpell(SPELL_I_WALK_UNSEEN, oSelf)) {
								AssignCommand(oSelf,ActionCastSpellAtObject(SPELL_I_WALK_UNSEEN, oSelf, METAMAGIC_NONE, TRUE));
								return TRUE;
							} else if (GetHasSpell(SPELL_INVISIBILITY, oSelf)) {
								AssignCommand(oSelf,ActionCastSpellAtObject(SPELL_INVISIBILITY, oSelf));
								return TRUE;
							} else if (GetHasSpell(SPELL_INVISIBILITY_SPHERE, oSelf)) {
								AssignCommand(oSelf,ActionCastSpellAtObject(SPELL_INVISIBILITY_SPHERE, oSelf) );
								return TRUE;
							}
						}
					}
					
					if (iWarlockDarkness) 
					{
						ClearAllActions();
						AssignCommand(oSelf,ActionCastSpellAtObject(SPELL_I_DARKNESS, oSelf, METAMAGIC_NONE, TRUE));
                        return TRUE;
					} 
					else if (iDarkness==TRUE) 
					{
						ClearAllActions();
                        AssignCommand(oSelf,ActionCastSpellAtObject(SPELL_DARKNESS, oSelf));
                        return TRUE;
                    } 
                    else if (GetHasSpell(SPELL_SANCTUARY, oSelf)) 
                    {
						ClearAllActions();
                        AssignCommand(oSelf,ActionCastSpellAtObject(SPELL_SANCTUARY, oSelf));
                        return TRUE;
                    } 
                    else if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oSelf)) 
                    {
                        SetActionMode(oSelf, ACTION_MODE_STEALTH, TRUE);
                    }
                }
            }
        }
    }
 	return FALSE;
}


// * Returns true if a wizard, warlock, or sorcerer and wearing armor
int SCGetShouldNotCastSpellsBecauseofArmor(object oTarget, int nClass)
{

    if (GetArcaneSpellFailure(oTarget) > 15 &&
		(nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_WARLOCK || nClass == CLASS_TYPE_BARD))
    {
        return TRUE;
    }
    return FALSE;
}



//    Tests to see if already running a determine
//    combatround this round.
//:: Created By:   Brent
//:: Created On:   July 11 2003
int __SCInCombatRound(object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "__SCInCombatRound Start", GetFirstPC() ); }
    // * if just in attackaction, turn combat round off
    // * if simply fighting it is okay to turn the combat round off
    // * and try again because it doesn't hurt an attackaction
    // * to be reiniated whereas it does break a spell
    int nCurrentAction =  GetCurrentAction(oCharacter);
    if (nCurrentAction == ACTION_ATTACKOBJECT || nCurrentAction == ACTION_INVALID)// || nCurrentAction == ACTION_MOVETOPOINT)
    {
        return FALSE;
    }
    if (GetLocalInt(oCharacter, "X2_L_MUTEXCOMBATROUND") == TRUE)
    {
        //SpeakString("DEBUG:: In Combat Round, busy.");
        return TRUE;
    }
    return FALSE;
}

//    Will set the exclusion variable on whether
//    in combat or not.
//    This is to prevent multiple firings
//    of determinecombatround in one round
//:: Created By: Brent
//:: Created On: July 11 2003
void __SCTurnCombatRoundOn(int bBool, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "__SCTurnCombatRoundOn Start", GetFirstPC() ); }
    
    if (bBool == TRUE)
    {
        SetLocalInt(oCharacter, "X2_L_MUTEXCOMBATROUND", TRUE);
    }
    else
    {
        // * delay it turning off like an action
        ActionDoCommand(SetLocalInt(oCharacter, "X2_L_MUTEXCOMBATROUND", FALSE));
    }
}

//:://///////////////////////////////////////////////////////////////////////////////
//:: SC GetIsInCutscene()
//:: Determines whether the target is a member of the PC's faction and if any member
//:: is involved in a conversation -- this is a condition for short circuiting 
//:: SC DetermineCombatRound() so that hostile creatures can't attack conversing PCs or
//:: their party.
//::
//:: EPF, OEI 7/29/05
//:: DBR, OEI 5/30/06 - changed check to MP flagged cutscenes.
//:://///////////////////////////////////////////////////////////////////////////////
int SCGetIsInCutscene(object oTarget)
{
	// BMA-OEI 3/10/06
	object oPC = GetFirstPC();
		
	// If oTarget is not in the PC faction
	if (GetFactionEqual(oTarget, oPC) == FALSE)
	{
		return (FALSE);
	}

	// For each member in PC faction
	object oMem = GetFirstFactionMember(oPC, FALSE);

	while ( GetIsObjectValid(oMem) )
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		// If any member is in conversation
		if ( IsInMultiplayerConversation(oMem) )
		{
			return (TRUE);
		}
		
		oMem = GetNextFactionMember(oPC, FALSE);
	}

	return (FALSE);
}



//	This function is for choosing what tactics to use when fighting a door.
//	oDoorIntruder is the door to fight, and the function is run on the combating creature.
//	Returns 1 on a succesful choice of tactic (which should always occur) and 0 when no tactics were chosen.
int SCChooseTacticsForDoor(object oDoorIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF)
{
	if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK, oCharacter))
	{
		ActionUseFeat(FEAT_IMPROVED_POWER_ATTACK, oDoorIntruder);
		return 1;
	}
	else if(GetHasFeat(FEAT_POWER_ATTACK, oCharacter))
	{
		ActionUseFeat(FEAT_POWER_ATTACK, oDoorIntruder);
		return 1;
	}
	else
	{
		//SC WrapperActionAttack(oDoorIntruder);
		ActionAttack(oDoorIntruder);
		return 1;
	}
	return 0;	//unreachable, technically
}


//    Used in SC DetermineCombatRound to keep a
//    henchmen bashing doors.
//	
//	Also used to limit the tactics used when fighting a door.
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
int SCBashDoorCheck(object oIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF)
{
   //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCBashDoorCheck Start", GetFirstPC() ); }
   
   int bDoor = FALSE;
    //This code is here to make sure that henchmen keep bashing doors and placables.
    object oDoor = GetLocalObject(oCharacter, "NW_GENERIC_DOOR_TO_BASH");

	if (GetIsObjectValid(oDoor))	//run tests to see if we should bash this door that we received from a shout
	{
		if (!(!GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN))
    				|| (!GetIsObjectValid(oIntruder) && !GetIsObjectValid(CSLGetCurrentMaster()))))
				oDoor = OBJECT_INVALID; //That last check was to prevent a henchmen or creatures form attacking a door if they are in combat (and have bigger concerns)
		else if (GetIsTrapped(oDoor) ) oDoor = OBJECT_INVALID; //Don't attack a trapped door.
   		else if (!GetLocked(oDoor)) oDoor = OBJECT_INVALID;	//Don't attack a Locked door.
	}
	//From the original SC BashDoorCheck(), this handles the door that we were shouted to attack.							
    if(GetIsObjectValid(oDoor))
    {
        int nDoorMax = GetMaxHitPoints(oDoor);
        int nDoorNow = GetCurrentHitPoints(oDoor);
        int nCnt = GetLocalInt(oCharacter,"NW_GENERIC_DOOR_TO_BASH_HP");//this variable appears to be a misnomer, and is used to keep track of how many times we have tried to bash this door.
		if(nDoorMax == nDoorNow)
        {
            nCnt++;
            SetLocalInt(oCharacter,"NW_GENERIC_DOOR_TO_BASH_HP", nCnt);
        }
        if(nCnt <= 0)
        {
            bDoor = SCChooseTacticsForDoor(oDoor);
        }
        if(bDoor == FALSE)
        {
            SCVoiceCuss();
            DeleteLocalObject(oCharacter, "NW_GENERIC_DOOR_TO_BASH");
            DeleteLocalInt(oCharacter, "NW_GENERIC_DOOR_TO_BASH_HP");
        }
		return bDoor;
    }
	else	//We either were not shouted to attack a door, or we decided that the shouted door is not good to attack.
	{		//Now we check oIntruder to see if the object we were going to attack anyway is a door.
		if (GetObjectType(oIntruder)==OBJECT_TYPE_DOOR)
		{
			return SCChooseTacticsForDoor(oIntruder);
		}			
	}
	return FALSE;    //did nothing
}






//    This function works in tandem with an encounter
//    to spawn in guards to fight for the attacked
//    NPC.  MAKE SURE THE ENCOUNTER TAG IS SET TO:
//             "ENC_" + NPC TAG
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001

//Presently Does not work with the current implementation of encounter trigger
void SCSetSummonHelpIfAttacked(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetSummonHelpIfAttacked Start", GetFirstPC() ); }
    
    string sEncounter = "ENC_" + GetTag(oCharacter);
    object oTrigger = GetObjectByTag(sEncounter);

    if(GetIsObjectValid(oTrigger))
    {
        SetEncounterActive(TRUE, oTrigger);
    }
}

//:: Set, Get Activate,Flee to Exit
//    The target object flees to the specified
//    way point and then destroys itself, to be
//    respawned at a later point.  For unkillable
//    sign post characters who are not meant to fight back.
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001

//This function is used only because ActionDoCommand can only accept void functions
void SCCreateSignPostNPC(string sTag, location lLocal)
{
    CreateObject(OBJECT_TYPE_CREATURE, sTag, lLocal);
}

void SCActivateFleeToExit(object oCharacter = OBJECT_SELF)
{
     //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCActivateFleeToExit Start", GetFirstPC() ); }
     
     //minor optimizations - only grab these variables when actually needed
     //can make for larger code, but it's faster
     //object oExitWay = GetWaypointByTag("EXIT_" + GetTag(oCharacter));
     //location lLocal = GetLocalLocation(oCharacter, "NW_GENERIC_START_POINT");
     //string sTag = GetTag(oCharacter);

     //I suppose having this as a variable made it easier to change at one point....
     //but it never changes, and is only used twice, so we don't need it
     //float fDelay =  6.0;

     int nPlot = GetLocalInt(oCharacter, "NW_GENERIC_MASTER");

     if( nPlot & CSL_FLAG_TELEPORT_RETURN || nPlot & CSL_FLAG_TELEPORT_LEAVE)
     {
        if ( CSLGetCanTeleport(oCharacter) )
        {
			//effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
			//ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCharacter);
			if(nPlot & CSL_FLAG_TELEPORT_RETURN)
			{
				location lLocal = GetLocalLocation(oCharacter, "NW_GENERIC_START_POINT");
				string sTag = GetTag(oCharacter);
				DelayCommand(6.0, ActionDoCommand(SCCreateSignPostNPC(sTag, lLocal)));
			}
			ActionDoCommand(DestroyObject(oCharacter, 0.75));
			return;
        }
     }
     
	if(nPlot & CSL_FLAG_ESCAPE_LEAVE)
	{
		object oExitWay = GetWaypointByTag("EXIT_" + GetTag(oCharacter));
		ActionMoveToObject(oExitWay, TRUE);
		ActionDoCommand(DestroyObject(oCharacter, 1.0));
	}
	else if(nPlot & CSL_FLAG_ESCAPE_RETURN)
	{
		string sTag = GetTag(oCharacter);
		object oExitWay = GetWaypointByTag("EXIT_" + sTag);
		ActionMoveToObject(oExitWay, TRUE);
		location lLocal = GetLocalLocation(oCharacter, "NW_GENERIC_START_POINT");
		DelayCommand(6.0, ActionDoCommand(SCCreateSignPostNPC(sTag, lLocal)));
		ActionDoCommand(DestroyObject(oCharacter, 1.0));
	}
     
}

object SOD_PickSafestEscapeExit(string sTag, object oFleeing, object oHostile)
{
	int nNth = 1;
	
	object oWaypoint = GetNearestObjectByTag(sTag, oFleeing, nNth);
	float fFleeingToWaypoint;
	float fHostileToWaypoint;
	float fDifference;
	
	while (nNth < 6)
	{
		fDifference = 100.0;
		
		if (GetIsObjectValid(oHostile))
		{
			fFleeingToWaypoint = GetDistanceBetween(oFleeing, oWaypoint);
			fHostileToWaypoint = GetDistanceBetween(oHostile, oWaypoint);
			fDifference = fHostileToWaypoint - fFleeingToWaypoint;
		}
	
		if (fDifference > 0.0f)
		{
			return oWaypoint;
		}
		nNth++;
		oWaypoint = GetNearestObjectByTag(sTag, oFleeing, nNth);
	}
	return GetNearestObjectByTag(sTag, oFleeing, 1);
}

int SCGetFleeToExit(object oCharacter = OBJECT_SELF)
{
    int nPlot = GetLocalInt(oCharacter, "NW_GENERIC_MASTER");
    if(nPlot & CSL_FLAG_ESCAPE_RETURN)
    {
        return TRUE;
    }
    else if(nPlot & CSL_FLAG_ESCAPE_LEAVE)
    {
        return TRUE;
    }
    else if(nPlot & CSL_FLAG_TELEPORT_RETURN)
    {
        return TRUE;
    }
    else if(nPlot & CSL_FLAG_TELEPORT_LEAVE)
    {
       return TRUE;
    }
    else if ( nPlot & CSL_FLAG_FLEE )
    {
    	return TRUE;
    }
    return FALSE;
}

void SOD_FleeAllHostiles(object oFleeing)
{
//	SpeakString("I'm thinking about running!", TALKVOLUME_SHOUT);

	//object oHostile = SOD_GetNearestSeenHostile(oFleeing);
	object oHostile = CSLGetNearestPerceivedEnemy(oFleeing);
	//object oNearest = SOD_GetNearestSeen(oFleeing);
	object oNearest = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oFleeing, 1);
	
/*	
	if ((!GetIsObjectValid(oHostile))&&(!GetIsObjectValid(oNearest)))
	{
		DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
		return;
	}
*/
	
	int bSpooked = GetLocalInt(oFleeing, "flee_spooked");
	int nWasAttacked = GetLocalInt(oFleeing, "flee_attacked");
	effect eEffect = EffectDamage(999, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
	float fDistance;
	object oWaypoint;
	string sTag;
	string sScript;
	
//	if ((!GetIsPC(oHostile))
//	{
//		SpeakString("NPC's don't scare me!");
//		return;
//	}
	
//	SpeakString("Augh!  A monster!");
	
//	if (!bSpooked)
//	{
//		SetLocalInt(oFleeing, "flee_spooked", 1);
//	}

//Creature will shy away from hostiles.
	int bWildlife = GetLocalInt(oFleeing, "flee_wildlife");
	
	if (bWildlife)
	{
		if ((!GetIsObjectValid(oNearest))&&(!bSpooked))
		{
			DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
			return;
		}
		
		if (!bSpooked)
		{
			SetLocalInt(oFleeing, "flee_spooked", 1);
		}
	
		fDistance = GetDistanceBetween(oFleeing, oNearest);
	
		if ((nWasAttacked > 0)&&(nWasAttacked < 11))
		{
			nWasAttacked++;
			SetLocalInt(oFleeing, "flee_attacked", nWasAttacked);
			
			ClearAllActions(TRUE);
			ActionMoveAwayFromObject(oNearest, TRUE, 25.0f);
			DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
			return;
		}
		
		if (nWasAttacked > 10)
		{
			string sScript = GetLocalString(oFleeing, "flee_script");
			
			if (sScript != "")
			{
				ExecuteScript(sScript, oFleeing);
			}
		
			SetScriptHidden(oFleeing, 1, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oFleeing, 0.0f);
			return;
		}
	
		if (!GetIsObjectValid(oNearest))
		{
				DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
				return;
		}
		
//Creatures will not at the sight of druids or those of their own faction.
		int nDruidRanks = GetLevelByClass(3, oNearest);
		
		if ((GetFactionEqual(oNearest, oFleeing))||(nDruidRanks > 0))
		{
			if (!GetIsEnemy(oNearest))
			{
				DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
				return;
			}
		}
		
		if (!nWasAttacked)
		{
			if (fDistance < 21.0f)
			{
				ClearAllActions(TRUE);
				ActionMoveAwayFromObject(oNearest, TRUE, 20.0f);
			}
		
			else
			{
				ClearAllActions(TRUE);
				ActionMoveAwayFromObject(oNearest, FALSE, 15.0f);
			}
			
			DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
			return;
		}
		
//		DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
	}

	
//Commoner setting that has them flee to the closest safe waypoint that leads away
//from the nearest hostile.
	int bCommoner = GetLocalInt(oFleeing, "flee_commoner");
	if (bCommoner)
	{
		if (!nWasAttacked)
		{
			if (!GetIsObjectValid(oHostile))
			{
				DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
				return;
			}
			
			if (!bSpooked)
			{
				SetLocalInt(oFleeing, "flee_spooked", 1);
			}
		}
	
//		SpeakString("Common tripe!");
		sTag = "wyp_flee_commoner";
		oWaypoint = SOD_PickSafestEscapeExit( sTag, oFleeing, oHostile);
		
		if (!GetIsObjectValid(oWaypoint))
		{
			DeleteLocalInt(oFleeing, "flee_commoner");
			SetLocalInt(oFleeing, "flee_wildlife", 1);
			DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
			return;
		}
		
		fDistance = GetDistanceBetween(oFleeing, oWaypoint);
		
		if (fDistance < 8.0f)
		{
			sScript = GetLocalString(oFleeing, "flee_script");
			
			if (sScript != "")
			{
				ExecuteScript(sScript, oFleeing);
			}
		
			SetScriptHidden(oFleeing, 1, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oFleeing, 0.0f);
			return;
		}
		
		ClearAllActions(TRUE);
		ActionMoveToObject(oWaypoint, TRUE, 1.0f);
		DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
	}

	
//Flees to the edge of the map assuming the proper waypoints are found.
	int bEdge = GetLocalInt(oFleeing, "flee_edge");
	if (bEdge)
	{
		if (!nWasAttacked)
		{
			if (!GetIsObjectValid(oHostile))
			{
				DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
				return;
			}
			
			if (!bSpooked)
			{
				SetLocalInt(oFleeing, "flee_spooked", 1);
			}
		}
	
//		SpeakString("I'm feeling edgy!");
		sTag = "wyp_flee_edge";
		oWaypoint = SOD_PickSafestEscapeExit( sTag, oFleeing, oHostile);
		
		if (!GetIsObjectValid(oWaypoint))
		{
			DeleteLocalInt(oFleeing, "flee_edge");
			SetLocalInt(oFleeing, "flee_wildlife", 1);
			DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
			return;
		}
		
		fDistance = GetDistanceBetween(oFleeing, oWaypoint);
		
		if (fDistance < 5.0f)
		{
			string sScript = GetLocalString(oFleeing, "flee_script");
			
			if (sScript != "")
			{
				ExecuteScript(sScript, oFleeing);
			}
		
			SetScriptHidden(oFleeing, 1, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oFleeing, 0.0f);
			return;
		}
		
		ClearAllActions(TRUE);
		ActionMoveToObject(oWaypoint, TRUE, 1.0f);
		DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
	}

//Flees to a rally point then turns to fight.
	int bScout = GetLocalInt(oFleeing, "flee_scout");
	if (bScout)
	{
//		SpeakString("Scouts shout!", TALKVOLUME_SHOUT);
		sTag = "wyp_flee_scout";
		oWaypoint = GetLocalObject(oFleeing, "oWaypoint");
		fDistance = GetDistanceBetween(oFleeing, oWaypoint);
		
		if ((!GetIsObjectValid(oHostile))&&(!bSpooked))
		{
			DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
			return;
		}
		
		if (!bSpooked)
		{
			SetLocalInt(oFleeing, "flee_spooked", 1);
		}
		
		if (!GetIsObjectValid(oWaypoint))
		{
			oWaypoint = SOD_PickSafestEscapeExit( sTag, oFleeing, oHostile);
			fDistance = GetDistanceBetween(oFleeing, oWaypoint);
			
			SetLocalObject(oFleeing, "oWaypoint", oWaypoint);
		}
		
		if ((fDistance < 10.0f)||(!GetIsObjectValid(oWaypoint)))
		{
			sScript = GetLocalString(oFleeing, "flee_script");
			
//			SpeakString("We are done scouting!", TALKVOLUME_SHOUT);
			
			if (sScript != "")
			{
//				SpeakString("Execute script " + sScript +" !", TALKVOLUME_SHOUT);
				ExecuteScript(sScript, oFleeing);
			}
		
			DeleteLocalInt(oFleeing, "flee_scout");
			DeleteLocalInt(oFleeing, "flee_yes");
			DeleteLocalInt(oFleeing, "flee_spooked");
			return;
		}
		
		ClearAllActions(TRUE);
		ActionMoveToObject(oWaypoint, TRUE, 1.0f);
		DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
	}

//Flees to the nearest transition that leads away from the closest enemy.
	int bRoad = GetLocalInt(oFleeing, "flee_road");
	if (bRoad)
	{
		object oTransition = GetLocalObject(oFleeing, "oExit");
		fDistance = GetDistanceBetween(oFleeing, oTransition);
//		SpeakString("Over hill, over road!");
		
		if ((!GetIsObjectValid(oHostile))&&(!bSpooked))
		{
			DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
			return;
		}
		
		if (!bSpooked)
		{
			SetLocalInt(oFleeing, "flee_spooked", 1);
		}
		
		if(!GetIsObjectValid(oTransition))
		{
			oTransition = CSLGetBestExit(oFleeing);
			SetLocalObject(oFleeing, "oExit", oTransition);
			fDistance = GetDistanceBetween(oFleeing, oTransition);
		}
		
		if (fDistance < 5.0f)
		{
			sScript = GetLocalString(oFleeing, "flee_script");
			
			if (sScript != "")
			{
				ExecuteScript(sScript, oFleeing);
			}
		
			SetScriptHidden(oFleeing, 1, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oFleeing, 0.0f);
			return;
		}
		
		ClearAllActions(TRUE);
		ActionMoveToObject(oTransition, TRUE, 1.0f);
		DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
	}

//Flees to a designated escape point or turns to fight if none is present.
	int bBoss = GetLocalInt(oFleeing, "flee_boss");
	if (bBoss)
	{
		if (!nWasAttacked)
		{
			if (!GetIsObjectValid(oHostile))
			{
				DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
				return;
			}
		}
	
//		SpeakString("Who do you think the boss is around here?!");
		sTag = "wyp_flee_boss";
		oWaypoint = SOD_PickSafestEscapeExit( sTag, oFleeing, oHostile);
		fDistance = GetDistanceBetween(oFleeing, oWaypoint);
		
		if (!GetIsObjectValid(oWaypoint))
		{
			string sScript = GetLocalString(oFleeing, "flee_script");
			
			if (sScript != "")
			{
				ExecuteScript(sScript, oFleeing);
			}
		
			DeleteLocalInt(oFleeing, "flee_boss");
			DeleteLocalInt(oFleeing, "flee_yes");
			DeleteLocalInt(oFleeing, "flee_spooked");
			return;
		}
		
		if (fDistance < 5.0f)
		{
			string sScript = GetLocalString(oFleeing, "flee_script");
			
			if (sScript != "")
			{
				ExecuteScript(sScript, oFleeing);
			}
		
			SetScriptHidden(oFleeing, 1, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oFleeing, 0.0f);
			return;
		}
		
		ClearAllActions(TRUE);
		ActionMoveToObject(oWaypoint, TRUE, 1.0f);
		DelayCommand(3.0f, SOD_FleeAllHostiles(oFleeing));
	}
}



//    Checks if the NPC has sleep on them because
//    of ambient animations. Sleeping creatures
//    must make a DC 15 listen check.
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 27, 2002
void SCRemoveAmbientSleep( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCRemoveAmbientSleep Start", GetFirstPC() ); }
    
    if(CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SLEEP))
    {
        effect eSleep = GetFirstEffect(oCharacter);
        while( GetIsEffectValid(eSleep) )
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            if(GetEffectCreator(eSleep) == oCharacter)
            {
                int nRoll = d20();
                nRoll += GetSkillRank(SKILL_LISTEN);
                nRoll += GetAbilityModifier(ABILITY_WISDOM);
                if(nRoll > 15)
                {
                    RemoveEffect(oCharacter, eSleep);
                }
            }
            eSleep = GetNextEffect(oCharacter);
        }
    }
}


//    Finds the closest locked object to the object
//    passed in up to a maximum of 10 objects.
//:: Created By: Preston Watamaniuk
//:: Created On: March 15, 2002
object SCGetLockedObject(object oMaster)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetLockedObject Start", GetFirstPC() ); }
    
    int nCnt = 1;
    int bValid = TRUE;
    object oLastObject = GetNearestObjectToLocation(OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetLocation(oMaster), nCnt);
    while (GetIsObjectValid(oLastObject) && bValid == TRUE)
    {
        //COMMENT THIS BACK IN WHEN DOOR ACTION WORKS ON PLACABLE.
		//DEBUGGING// igDebugLoopCounter += 1;
        //object oItem = GetFirstItemInInventory(oLastObject);
        if(GetLocked(oLastObject))
        {
            return oLastObject;
        }
        nCnt++;
        if(nCnt == 10)
        {
            bValid = FALSE;
        }
        oLastObject = GetNearestObjectToLocation(OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetLocation(oMaster), nCnt);
    }
    return OBJECT_INVALID;
}


//:: Play Mobile Ambient Animations
//:: This function is now just a wrapper around
//:: code from x0_i0_anims.
void SCPlayMobileAmbientAnimations(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCPlayMobileAmbientAnimations Start", GetFirstPC() ); }
    
    if(!SCGetSpawnInCondition(CSL_FLAG_AMBIENT_ANIMATIONS_AVIAN,oCharacter)) {
        // not a bird
        SCPlayMobileAmbientAnimations_NonAvian(oCharacter);
    } else {
        // a bird
        SCPlayMobileAmbientAnimations_Avian(oCharacter);
    }
}

// FLEE COMBAT AND HOSTILES
int SCTalentFlee(object oIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentFlee Start", GetFirstPC() ); }
    
    //MyPrintString("SC TalentFlee Enter");
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetLastHostileActor();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
        {
            oTarget = CSLGetNearestSeenEnemy();
            float fDist = GetDistanceBetween(oCharacter, oTarget);
            if(!GetIsObjectValid(oTarget))
            {
                //MyPrintString("SC TalentFlee Failed Exit");
                return FALSE;
            }
        }
    }
    //MyPrintString("SC TalentFlee Successful Exit");
    ClearAllActions();
    //Look at this to remove the delay
    ActionMoveAwayFromObject(oTarget, TRUE, 10.0f);
    DelayCommand(4.0, ClearAllActions());
    return TRUE;
}


//    Determines the special behavior used by the NPC.
//    Generally all NPCs who you want to behave differently
//    than the defualt behavior.
//    For these behaviors, passing in a valid object will
//    cause the creature to become hostile the the attacker.
//
//    MODIFIED February 7 2003:
//    - Rearranged logic order a little so that the creatures
//    will actually randomwalk when not fighting
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 14, 2001
void SCDetermineSpecialBehavior(object oIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF)
{
    object oTarget = CSLGetNearestSeenEnemy();
    if(SCGetBehaviorState(CSL_FLAG_BEHAVIOR_OMNIVORE))
    {
        int bAttack = FALSE;
        if(!GetIsObjectValid(oIntruder))
        {
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()) &&
               !GetIsObjectValid(GetAttackTarget()))
            {
                if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 8.0)
                {
                    if(!GetIsFriend(oTarget))
                    {
                        if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0)
                        {
                            SetIsTemporaryEnemy(oTarget, oCharacter, FALSE, 20.0);
                            bAttack = TRUE;
                            SCAIDetermineCombatRound(oTarget);
                        }
                    }
                }
            }
        }
        else if(!IsInConversation(oCharacter))
        {
            bAttack = TRUE;
            SCAIDetermineCombatRound(oIntruder);
        }

        // * if not attacking, the wander
        if (bAttack == FALSE)
        {
            ClearAllActions();
            ActionRandomWalk();
            return;
        }
    }
    else if(SCGetBehaviorState(CSL_FLAG_BEHAVIOR_HERBIVORE))
    {
        if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
           !GetIsObjectValid(GetAttemptedSpellTarget()) &&
           !GetIsObjectValid(GetAttackTarget()))
        {
            if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 6.0)
            {
                if(!GetIsFriend(oTarget))
                {
                    if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0)
                    {
                        SCTalentFlee(oTarget);
                    }
                }
            }
        }
        else if(!IsInConversation(oCharacter))
        {
            ClearAllActions();
            ActionRandomWalk();
            return;
        }
    }
}


//    Determines which of a NPCs three classes to
//    use in SC DetermineCombatRound
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
// Creatures can now have 4 classes
int SCDetermineClassToUse(object oCharacter = OBJECT_SELF)
{
    int nClass;
    int nTotal = GetHitDice(oCharacter);

    int nClass1 = GetClassByPosition(1);
    int nClass2 = GetClassByPosition(2);
    int nClass3 = GetClassByPosition(3);

    int nState1 = GetLevelByClass(nClass1) * 100 / nTotal;
    int nState2 = nState1 + GetLevelByClass(nClass2) * 100 / nTotal;
    int nState3 = nState2 + GetLevelByClass(nClass3) * 100 / nTotal;

    int nUseClass = d100();

    if(nUseClass <= nState1)
    {
        nClass = nClass1;
    }
    //else if(nUseClass > nState1 && nUseClass <= nState2)
    else if(nUseClass <= nState2)
    {
        nClass = nClass2;
    }
    else if(nUseClass <= nState3)
    {
        nClass = nClass3;
    }
	else
    {
        nClass = GetClassByPosition(4);
    }

    return nClass;
}


// used by Talent functions
// int bFactionOnly: TRUE = look only at our faction, FALSE = Look at all in sphere of specified radius
// float fRadius: Radius of sphere (only if bFactionOnly=FALSE)
object SCGetFirstTalentTarget(int bFactionOnly, float fRadius, object oCharacter = OBJECT_SELF)
{
	if(bFactionOnly)
		return GetFirstFactionMember(oCharacter, FALSE);
	else
    	return GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCharacter), TRUE);
}


// used by Talent functions
object SCGetNextTalentTarget(int bFactionOnly, float fRadius, object oCharacter = OBJECT_SELF)
{
	if(bFactionOnly)
		return GetNextFactionMember(oCharacter, FALSE);
	else
        return GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCharacter), TRUE);
}	



// Returns TRUE if oSelf is hidden either
// magically or via stealth
int SCInvisibleTrue(object oSelf= OBJECT_SELF)
{
	object oTarget;
	if( CSLGetHasEffectTypeGroup(oSelf,EFFECT_TYPE_SANCTUARY,EFFECT_TYPE_ETHEREAL) || GetLocalInt(oTarget, "Is_Ethereal") || GetLocalInt(oTarget, "X2_L_IS_INCORPOREAL") )
	{
		return TRUE;
	}
	
    if(GetLocalInt(oSelf, "EVENFLW_AI_CLOSE")) 
    {
    	return -1;
    }
    
    if(GetActionMode(oSelf, ACTION_MODE_STEALTH) )
    {
        return TRUE;
    }
    
    if(CSLGetHasEffectTypeGroup(oSelf,EFFECT_TYPE_INVISIBILITY ,EFFECT_TYPE_GREATERINVISIBILITY) || GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oSelf))
    {
		return TRUE;
    }
    
	if( GetHasSpellEffect(SPELL_DARKNESS, oSelf) )
	{
		return 2;
	}
    return FALSE;
}



int SCCheckForInvis(object oIntruder, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckForInvis Start", GetFirstPC() ); }
	
	if(SCInvisibleTrue(oIntruder)==TRUE) return TRUE;
	object target=GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oCharacter));
	int total=0;
	while( GetIsObjectValid(target) && total<5)
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		if(GetIsEnemy(target) && SCInvisibleTrue(target)==TRUE)
			return TRUE;
		total++;
		target=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oCharacter));
	}
	return FALSE;
}



talent SCSilenceCheck(talent tUse, object oCharacter = OBJECT_SELF) 
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSilenceCheck Start", GetFirstPC() ); }
	
	if(GetIsTalentValid(tUse) && GetTypeFromTalent(tUse)==TALENT_TYPE_SPELL) {
		talent alt;
		if(CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SILENCE))
		{
			return alt;
		}
	}
	return tUse;
}

talent SCEvenGetCreatureTalent(int nCategory, int nCRMax, int bRandom, int CheckSilence=FALSE, object oCharacter = OBJECT_SELF) 
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCEvenGetCreatureTalent Start", GetFirstPC() ); }
	
	talent tUse;
	if(!bRandom) {
		tUse=SCGetCreatureTalentBestStd(nCategory, nCRMax, oCharacter);
		if(CheckSilence)
			return SCSilenceCheck(tUse);
		return tUse;
	}
	tUse=SCGetCreatureTalentRandomStd(nCategory, oCharacter);
	int CR=0, count=0, castingmode=0, play=4;
	if(CSLGetAssociateState(CSL_ASC_POWER_CASTING)) castingmode=2;
	else if(CSLGetAssociateState(CSL_ASC_SCALED_CASTING)) castingmode=3;
	while( !CR && count<6 && GetIsTalentValid(tUse))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		if(GetTypeFromTalent(tUse)!=TALENT_TYPE_SPELL) {
			return tUse;
		}
		CR=GetSpellLevel(GetIdFromTalent(tUse))*2;
		if(CR<nCRMax-play) CR=0;
		if(castingmode && CR>nCRMax+play) CR=0;
		count++;
		play+=d2();
		if(!CR) tUse=SCGetCreatureTalentRandomStd(nCategory, oCharacter);
	}
	if(CR) {
		if(CheckSilence)
			return SCSilenceCheck(tUse);
		return tUse;
	}
	tUse=SCGetCreatureTalent(nCategory, nCRMax, bRandom, oCharacter);
	if(CheckSilence)
		return SCSilenceCheck(tUse);
	return tUse;
}






int SCTalentHeal(int nForce = FALSE, object oTarget = OBJECT_SELF, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentHeal Start", GetFirstPC() ); }
    
    int nCurrent;
    int nBase;
	int total;
	int overkill=0;
    talent tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, 20, TRUE, TRUE);
	int owned=GetIsRosterMember(oCharacter) || GetIsOwnedByPlayer(oCharacter);
	if(CSLGetAssociateState(CSL_ASC_OVERKIll_CASTING)) overkill=1;
	if(GetIsTalentValid(tUse))
    {
      	total = 0;
		int nMass=0;
		oTarget=SCGetFirstTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
      	while (GetIsObjectValid(oTarget) && (owned || total<5))
      	{
       		//DEBUGGING// igDebugLoopCounter += 1;
       		total++;
       		if(oTarget!=oCharacter && !GetIsEnemy(oTarget) && GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD && GetArea(oCharacter)==GetArea(oTarget) && GetDistanceBetween(oCharacter, oTarget)<RADIUS_SIZE_COLOSSAL)
      		{
       			if (nForce == TRUE)
       				nCurrent = GetCurrentHitPoints(oTarget);
       			else
       				nCurrent = GetCurrentHitPoints(oTarget)*2;
       			nBase = GetMaxHitPoints(oTarget);
       			if((nCurrent <= nBase || overkill && GetCurrentHitPoints(oTarget) < GetMaxHitPoints(oTarget)-19)
					&& !GetIsDead(oTarget))
       				nMass += 1;
        		if (nMass > 2)
       			{
                	SCEvenTalentFilter(tUse, oTarget);
        			return TRUE;
       			}
      		}
			oTarget=SCGetNextTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
     	}
    }
    tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, TALENT_ANY, FALSE, TRUE);
    if(!GetIsTalentValid(tUse)) return FALSE;
    total = 0;
	oTarget=SCGetFirstTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
    while (GetIsObjectValid(oTarget) && (owned || total<5) && total<20 )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        total++;
        if(oTarget!=oCharacter && !GetIsEnemy(oTarget) && GetArea(oCharacter)==GetArea(oTarget) && GetDistanceBetween(oCharacter, oTarget)<RADIUS_SIZE_COLOSSAL)
        {
            if (nForce == TRUE) {
                nCurrent = GetCurrentHitPoints(oTarget);
				nBase = GetMaxHitPoints(oTarget);
            } else {
            	nCurrent = GetCurrentHitPoints(oTarget);
				if(overkill)
					nBase=GetMaxHitPoints(oTarget)*3/4;
				else nBase = GetMaxHitPoints(oTarget)/2;
            }
			int mod=24;
			if(GetIdFromTalent(tUse)==SPELL_HEAL) mod=100;
            if((nCurrent <= nBase || overkill && GetCurrentHitPoints(oTarget) < GetMaxHitPoints(oTarget)-mod)
				&& !GetIsDead(oTarget))
            {
				if(GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD) {
					SCEvenTalentFilter(tUse, oTarget);
        			return TRUE;
				} /*else {
					int spell=0;
					if(GetHasSpell(SPELL_HARM)) spell=SPELL_HARM;
					else if(GetAlignmentGoodEvil(oCharacter)==ALIGNMENT_EVIL){
						if(GetHasSpell(SPELL_INFLICT_CRITICAL_WOUNDS)) spell=SPELL_INFLICT_CRITICAL_WOUNDS;
						else if(GetHasSpell(SPELL_INFLICT_SERIOUS_WOUNDS)) spell=SPELL_INFLICT_SERIOUS_WOUNDS;
						else if(GetHasSpell(SPELL_INFLICT_MODERATE_WOUNDS)) spell=SPELL_INFLICT_MODERATE_WOUNDS;
						else if(GetHasSpell(SPELL_INFLICT_LIGHT_WOUNDS)) spell=SPELL_INFLICT_LIGHT_WOUNDS;
					}
					if(spell) {
						ClearAllActions();
						ActionCastSpellAtObject(spell, oTarget);
						return TRUE;
					}
				}*/
            }
        }
		oTarget=SCGetNextTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
    }
    return FALSE;
}


int SCTalentResurrect( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentResurrect Start", GetFirstPC() ); }
	
	if(CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SILENCE)) return 0;
    int nSpell;
    int total= 0;
    if(GetHasSpell(SPELL_RESURRECTION, oCharacter))
     	nSpell = SPELL_RESURRECTION;
    else if(GetHasSpell(SPELL_RAISE_DEAD, oCharacter))
     	nSpell = SPELL_RAISE_DEAD;
    else return FALSE;
	int owned=GetIsRosterMember(oCharacter) || GetIsOwnedByPlayer(oCharacter);
	object oTarget;
	oTarget=SCGetFirstTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
	while(GetIsObjectValid(oTarget) && (owned || total<5) && total<20  )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        total++;
        if(!GetIsEnemy(oTarget) && GetIsDead(oTarget) && GetRacialType(oTarget)!=RACIAL_TYPE_UNDEAD && GetArea(oCharacter)==GetArea(oTarget) && GetDistanceBetween(oCharacter, oTarget)<RADIUS_SIZE_COLOSSAL)
        {
			ClearAllActions();
          	AssignCommand(oCharacter, ActionCastSpellAtObject(nSpell, oTarget) );
         	return TRUE;
        }
		oTarget=SCGetNextTalentTarget(owned, RADIUS_SIZE_COLOSSAL);
    }
    return FALSE;
}



// Utility function for SC TalentCureCondition
// Checks to see if the creature has the given condition in the
// given condition value.
// To use, you must first calculate the nCurrentConditions value
// with SC GetCurrentNegativeConditions.
// The value of nCondition can be any of the COND_* constants
// declared in x0_i0_talent.
int SCGetHasNegativeCondition(int nCondition, int nCurrentConditions)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetHasNegativeCondition Start", GetFirstPC() ); }
    
    return (nCurrentConditions & nCondition);
}


int SCGetIsPositiveBuffSpellWithNegativeEffect(int iSpellId)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetIsPositiveBuffSpellWithNegativeEffect Start", GetFirstPC() ); }
	
	if (
	       iSpellId == SPELL_ENLARGE_PERSON
		|| iSpellId == SPELL_RIGHTEOUS_MIGHT
		|| iSpellId == SPELL_STONE_BODY
		|| iSpellId == SPELL_IRON_BODY
		|| iSpellId == SPELL_LIGHT
		|| iSpellId == SPELL_NONMAGICLIGHT
		|| iSpellId == SPELL_DAYLIGHT_CLERIC
		|| iSpellId == SPELL_DAYLIGHT
		|| iSpellId == SPELL_REDUCE_PERSON
		|| iSpellId == SPELL_REDUCE_ANIMAL
		|| iSpellId == SPELL_REDUCE_PERSON_GREATER
		|| iSpellId == SPELL_REDUCE_PERSON_MASS
		|| iSpellId == FOREST_MASTER_OAK_HEART
		|| iSpellId == SPELLABILITY_GRAY_ENLARGE
		|| iSpellId == SPELL_TORTOISE_SHELL
		|| iSpellId == SPELL_FOUNDATION_OF_STONE
		|| iSpellId == SPELL_BLADE_BARRIER_SELF
		
		)
		{
			return TRUE;
		}
	return FALSE;					
}


// Utility function for SC TalentCureCondition()
// Returns an integer with bitwise flags set that represent the
// current negative conditions on the creature.
// To be used with SC GetHasNegativeCondition.
int SCGetCurrentNegativeConditions(object oCharacter)
{
    //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "SCGetCurrentNegativeConditions Start", GetFirstPC() ); }
    
    int nSum = 0;
    int nType=-1;
	int nSpellId = -1;
    effect eEffect = GetFirstEffect(oCharacter);
	
    while(GetIsEffectValid(eEffect)) 
	{
        //DEBUGGING// igDebugLoopCounter += 1;
        nType = GetEffectType(eEffect);
        nSpellId = GetEffectSpellId(eEffect); // the spell this effect comes from
		if (!SCGetIsPositiveBuffSpellWithNegativeEffect(nSpellId))
		{
			switch (nType) 
			{
				case EFFECT_TYPE_DISEASE:           nSum = nSum | COND_DISEASE; break;
				case EFFECT_TYPE_POISON:            nSum = nSum | COND_POISON; break;
				case EFFECT_TYPE_CURSE:             nSum = nSum | COND_CURSE; break;
				case EFFECT_TYPE_NEGATIVELEVEL:     nSum = nSum | COND_DRAINED; break;
				case EFFECT_TYPE_ABILITY_DECREASE:	nSum = nSum | COND_ABILITY; break;
					//if(GetEffectSpellId(eEffect)!=SPELL_ENLARGE_PERSON) nSum = nSum | COND_ABILITY;
					//break;
				case EFFECT_TYPE_BLINDNESS:
				case EFFECT_TYPE_DEAF:              nSum = nSum | COND_BLINDDEAF; break;
					case EFFECT_TYPE_FRIGHTENED:        nSum = nSum | COND_FEAR; break;
				case EFFECT_TYPE_SLOW:				nSum = nSum | COND_SLOW; break;
				case EFFECT_TYPE_PARALYZE:          nSum = nSum | COND_PARALYZE; break;
				case EFFECT_TYPE_PETRIFY:           nSum = nSum | COND_PETRIFY; break;
			}
		}			
        eEffect = GetNextEffect(oCharacter);
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCGetCurrentNegativeConditions End", GetFirstPC() ); }
    return nSum;
}


/*
These are the effects the various restore spells negate
Lesser Restore:
EFFECT_TYPE_ABILITY_DECREASE
EFFECT_TYPE_AC_DECREASE
EFFECT_TYPE_ATTACK_DECREASE
EFFECT_TYPE_DAMAGE_DECREASE
EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
EFFECT_TYPE_SAVING_THROW_DECREASE
EFFECT_TYPE_SPELL_RESISTANCE_DECREASE
EFFECT_TYPE_SKILL_DECREASE

Restore: (above +)
EFFECT_TYPE_BLINDNESS
EFFECT_TYPE_DEAF
EFFECT_TYPE_PARALYZE
EFFECT_TYPE_NEGATIVELEVEL
  
Greater Restore: (above +)
EFFECT_TYPE_CURSE
EFFECT_TYPE_DISEASE
EFFECT_TYPE_POISON
EFFECT_TYPE_CHARMED
EFFECT_TYPE_DOMINATED
EFFECT_TYPE_DAZED
EFFECT_TYPE_CONFUSED
EFFECT_TYPE_FRIGHTENED
EFFECT_TYPE_SLOW
EFFECT_TYPE_STUNNED

*/
int SCGetHasConditionCuredBySpell(int nSum, int nSpellId)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetHasConditionCuredBySpell Start", GetFirstPC() ); }
	
	int nRet = FALSE;
	int LesserRestoreConditions = COND_ABILITY;
	int RestoreConditions = LesserRestoreConditions|COND_BLINDDEAF|COND_PARALYZE|COND_DRAINED;
	int GreaterRestoreConditions = RestoreConditions|COND_POISON|COND_DISEASE|COND_CURSE|COND_FEAR|COND_SLOW;
	
	switch (nSpellId)
	{
		case SPELL_NEUTRALIZE_POISON:
			nRet = (SCGetHasNegativeCondition(COND_POISON, nSum));
			break;
			
		case SPELL_REMOVE_DISEASE:
			nRet = (SCGetHasNegativeCondition(COND_DISEASE, nSum));
			break;

		case SPELL_REMOVE_CURSE:
			nRet = (SCGetHasNegativeCondition(COND_CURSE, nSum));
			break;

		case SPELL_REMOVE_BLINDNESS_AND_DEAFNESS:
			nRet = (SCGetHasNegativeCondition(COND_BLINDDEAF, nSum));
			break;

																
		case SPELL_LESSER_RESTORATION:
			nRet = (SCGetHasNegativeCondition(LesserRestoreConditions, nSum));
			break;

		case SPELL_RESTORATION:
			nRet = (SCGetHasNegativeCondition(RestoreConditions, nSum));
			break;

		case SPELL_GREATER_RESTORATION:
			nRet = (SCGetHasNegativeCondition(GreaterRestoreConditions, nSum));
			break;

		// probably won't be a potion of this, and if there was, how would you use it?			
		/*
		case SPELL_STONE_TO_FLESH:
			nRet = (SC GetHasNegativeCondition(GreaterRestoreConditions, nSum));
			break;
			
		case SPELL_REMOVE_PARALYSIS:
			nRet = (SC GetHasNegativeCondition(COND_PARALYZE, nSum));
			break;

		case SPELL_REMOVE_FEAR:
			nRet = (SC GetHasNegativeCondition(COND_FEAR, nSum));
			break;
		*/			
	}
	return (nRet);
}





// pick a random conditional potion and see if I can use it.
int SCTalentCureConditionSelf(int nSum, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentCureConditionSelf Start", GetFirstPC() ); }
	
	if (nSum == 0)
		return FALSE; // no negative condtions to cure

	//SpeakString("Pondering using a potion to cure myself...");
	talent tUse = SCGetCreatureTalentRandomStd(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, oCharacter);
	if (GetIsTalentValid(tUse))
	{
			int nSpellId = GetIdFromTalent(tUse);
		int nType=GetTypeFromTalent(tUse);
		if (nType == TALENT_TYPE_SPELL)
		{
			if (SCGetHasConditionCuredBySpell(nSum, nSpellId))
			{
				return(SCEvenTalentFilter(tUse, oCharacter));
			}
		}
	}
    return FALSE;
}							



// CURE DISEASE, POISON ETC
int SCTalentCureCondition( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentCureCondition Start", GetFirstPC() ); }
	
	// if we are silenced then nevermind.
	if (CSLGetHasEffectType(oCharacter, EFFECT_TYPE_SILENCE)) 
		return 0;
		
    int nSum;		// bit flag list of negative conditions
    int nCondLR;	// count of the number of conditions that could be healed by any restoration
    int nCondR;		// count of the number of conditions that could be healed by restoration or greater restoration
    int nCondGR;	// count of the number of conditions that could be healed by greater restoration
	int nMinCond;
    int nSpell;
	int nTargetCount = 0;	// count of number of creatures looked at
	int bOwned = GetIsRosterMember(oCharacter) || GetIsOwnedByPlayer(oCharacter);
	
	
	object oTarget=SCGetFirstTalentTarget(bOwned, RADIUS_SIZE_LARGE);
	
	// only look at first few (5) targets for those who aren't PC's or Companions
    while(GetIsObjectValid(oTarget) && ( bOwned || nTargetCount < 5 ) && nTargetCount < 20) 
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		// we'll help anyone who is not an enemy (used to be GetIsFriend())
        // if(GetIsFriend(oTarget)) {
        if(!GetIsEnemy(oTarget)) 
		{
            nSpell = 0;
            nSum = SCGetCurrentNegativeConditions(oTarget);
            // friend has negative effects -- try and heal them

            // These effects will be healed in reverse order if
            // we have the spells for them and don't have
            // restoration.
            if (nSum != 0) 
			{
                if (SCGetHasNegativeCondition(COND_POISON, nSum)) {
                    nCondGR++;
                    if (GetHasSpell(SPELL_NEUTRALIZE_POISON, oCharacter))
                        nSpell = SPELL_NEUTRALIZE_POISON;
                }
                if (SCGetHasNegativeCondition(COND_DISEASE, nSum)) {
                    nCondGR++;
                    if (GetHasSpell(SPELL_REMOVE_DISEASE, oCharacter))
                        nSpell = SPELL_REMOVE_DISEASE;
                }
                if (SCGetHasNegativeCondition(COND_CURSE, nSum)) {
                    nCondGR++;
                    if (GetHasSpell(SPELL_REMOVE_CURSE, oCharacter))
                        nSpell = SPELL_REMOVE_CURSE;
                }
                if (SCGetHasNegativeCondition(COND_BLINDDEAF, nSum)) {
                    nCondR++;
                    if (GetHasSpell(SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, oCharacter))
                        nSpell = SPELL_REMOVE_BLINDNESS_AND_DEAFNESS;
                }
                if (SCGetHasNegativeCondition(COND_PARALYZE, nSum)) {
                    nCondR++;
                    if(GetHasSpell(SPELL_REMOVE_PARALYSIS, oCharacter))
                        nSpell=SPELL_REMOVE_PARALYSIS;
                }
                if (SCGetHasNegativeCondition(COND_FEAR, nSum)) {
                    nCondGR++;
                    if(GetHasSpell(SPELL_REMOVE_FEAR, oCharacter))
                        nSpell=SPELL_REMOVE_FEAR;
                }
				
                // For the conditions that can only be cured by
                // restoration, we add 1
                if (SCGetHasNegativeCondition(COND_DRAINED, nSum)) {
                    nCondR++; // += 2;
                }
                if (SCGetHasNegativeCondition(COND_ABILITY, nSum)) {
                    nCondLR++; // += 2;
                }
                if (SCGetHasNegativeCondition(COND_SLOW, nSum)) {
                    nCondGR++;
				}
				
				// shoule we use a restoration spell instead?
				nMinCond = 1; // minimum number of conditions we must be able to negate to make this worthwhile
				if (nSpell>0) // we have something we could use already, so only use restore if we can remove 2 things...
					nMinCond = 2;
				
				// can we get rid of more things than if we just used one of the above spells?					
                if ((nCondLR >= nMinCond) && (GetHasSpell(SPELL_LESSER_RESTORATION, oCharacter))) 
				{
					nMinCond = nCondLR+1;
                	nSpell = SPELL_LESSER_RESTORATION;
				}
				// can we get rid of even more things with a restore?					
                if ((nCondR+nCondLR >= nMinCond) && (GetHasSpell(SPELL_RESTORATION, oCharacter))) // can we get rid of more GR only conditions than we could with spells?
				{
					nMinCond = nCondR+nCondLR+1;
					nSpell = SPELL_RESTORATION;
				}
				
				// can we get rid of even more things with a greater restore?					
                if ((nCondGR+nCondR+nCondLR >= nMinCond) && (GetHasSpell(SPELL_GREATER_RESTORATION, oCharacter))) // can we get rid of more GR only conditions than we could with spells?
				{
					nSpell = SPELL_GREATER_RESTORATION;
				}
				
                if (SCGetHasNegativeCondition(COND_PETRIFY, nSum)) {
                    //nCond++; // this effect are not cured by restoration
                    if(GetHasSpell(SPELL_STONE_TO_FLESH, oCharacter))
                        nSpell=SPELL_STONE_TO_FLESH;
                }
                if(nSpell != 0) {
                    ClearAllActions();
                    AssignCommand(oCharacter, ActionCastSpellAtObject(nSpell, oTarget) );
                    return TRUE;
                }
				else
				{  	// we don't have a spell to cure a condition
					// maybe we have a condition that could be cured by a potion on ourselves
					if (oTarget == oCharacter)
					{
						SCTalentCureConditionSelf(nSum);
					}						
				}
				
            }
        }
		nTargetCount++;
		oTarget=SCGetNextTalentTarget(bOwned, RADIUS_SIZE_LARGE);
    }
    return FALSE;
}

// Cast a spell mantle or globe of invulnerability protection on
// yourself.
int SCTalentSelfProtectionMantleOrGlobe()
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentSelfProtectionMantleOrGlobe Start", GetFirstPC() ); }
    
    //Mantle Protections
    if (SCTrySpell(SPELL_GREATER_SPELL_MANTLE))
        return TRUE;

    if (SCTrySpell(SPELL_SPELL_MANTLE))
        return TRUE;

    if (SCTrySpell(SPELL_GLOBE_OF_INVULNERABILITY))
        return TRUE;

    if (SCTrySpell(SPELL_LESSER_GLOBE_OF_INVULNERABILITY))	// JLR - OEI 07/11/05 -- Name Changed
        return TRUE;

    return FALSE;
}






int SCTrySpellGroup(int nSpell1, int nSpell2, int nSpell3=-1, int nSpell4=-1, object oTarget=OBJECT_SELF, object oCaster= OBJECT_SELF, int nSpell5=-1, int nSpell6=-1)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTrySpellGroup Start", GetFirstPC() ); }
	
	if(GetHasSpellEffect(nSpell1, oTarget) || GetHasSpellEffect(nSpell2, oTarget) || 
		nSpell3!=-1 && GetHasSpellEffect(nSpell3, oTarget) || (nSpell4!=-1 && GetHasSpellEffect(nSpell4, oTarget) ||
		(nSpell5!=-1 && GetHasSpellEffect(nSpell5, oTarget) || (nSpell6!=-1 && GetHasSpellEffect(nSpell6, oTarget)))))
		return -1;
	if(nSpell1==SPELL_ENERGY_IMMUNITY && (GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_ACID, oTarget) ||
	GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_COLD, oTarget) || GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_ELECTRICAL, oTarget) || 
		GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_FIRE, oTarget) || GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_SONIC, oTarget))) return FALSE;
    if(GetHasSpell(nSpell1, oCaster)) {
		AssignCommand(oCaster, ClearAllActions() );
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell1, oTarget));
        return TRUE;
    } else if(GetHasSpell(nSpell2, oCaster)) {
		AssignCommand(oCaster, ClearAllActions() );
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell2, oTarget));
        return TRUE;
    } else if(nSpell3!=-1 && GetHasSpell(nSpell3, oCaster)) {
		AssignCommand(oCaster, ClearAllActions() );
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell3, oTarget));
        return TRUE;
    } else if(nSpell4!=-1 && GetHasSpell(nSpell4, oCaster)) {
		AssignCommand(oCaster, ClearAllActions() );
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell4, oTarget));
        return TRUE;
    } else if(nSpell5!=-1 && GetHasSpell(nSpell5, oCaster)) {
		AssignCommand(oCaster, ClearAllActions() );
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell5, oTarget));
        return TRUE;
    } else if(nSpell6!=-1 && GetHasSpell(nSpell6, oCaster)) {
		AssignCommand(oCaster, ClearAllActions() );
		AssignCommand(oCaster, ActionCastSpellAtObject(nSpell6, oTarget));
        return TRUE;
    }
    return FALSE;
}


int SCTalentAdvancedBuff2(object oTarget=OBJECT_SELF, object oIntruder=OBJECT_INVALID, int ismage=0, int castingmode=0, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentAdvancedBuff2 Start "+GetName(oTarget), GetFirstPC() ); }
	
	if (CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SILENCE)) 
		return 0;
	int bValid = FALSE;
	int hd = GetHitDice(oIntruder);
	if (castingmode<3) 
		hd += 5;
	int melee = GetLocalInt(oTarget, "EVENFLW_NUM_MELEE");
	
	if (hd > GetHitDice(oTarget)/3 
		|| melee)
	{		
		if (oTarget==oCharacter)
		{
			if(SCTrySpellGroup(SPELL_PREMONITION, SPELL_GREATER_STONESKIN, SPELL_I_DARK_FORESIGHT, SPELL_STONESKIN, oTarget)==TRUE) 
				bValid = TRUE;
		} 
		else 
		{
			if(SCTrySpell(SPELL_STONESKIN, oTarget)) 
				bValid=TRUE;
		}
	}
			
	if (castingmode<2 || hd>GetHitDice(oTarget)-5) 
	{
		if(!bValid && melee) 
		{
			if (!GetHasSpellEffect(SPELL_GREATER_INVISIBILITY, oTarget) 
				&& !GetHasSpellEffect(SPELL_I_RETRIBUTIVE_INVISIBILITY, oTarget)) 
			{
				if (GetModuleSwitchValue("EVENFLW_SWITCHES")<2) 
				{
					if (SCTrySpell(SPELL_GREATER_INVISIBILITY, oTarget)) 
						bValid=TRUE;
					if (oTarget==oCharacter 
						&& SCTrySpell(SPELL_I_RETRIBUTIVE_INVISIBILITY, oTarget)) 
						bValid=TRUE;
				} 
				else if(oTarget==oCharacter) 
				{
					if(SCTrySpellGroup(SPELL_MIRROR_IMAGE, SPELL_DISPLACEMENT, -1, -1, oTarget)==TRUE) bValid=TRUE;
				} 
				else if(SCTrySpell(SPELL_DISPLACEMENT, oTarget)) 
					bValid=TRUE;
			} 
			else 
			{
				if(oTarget==oCharacter && SCTrySpell(SPELL_MIRROR_IMAGE, oTarget)) 
					bValid=TRUE;
			}					
			if(oTarget==oCharacter) 
			{
				if(!bValid && SCTrySpellGroup(SPELL_SHADOW_SHIELD, SPELL_ETHEREAL_VISAGE, SPELL_GHOSTLY_VISAGE, -1, oTarget)==TRUE) bValid=TRUE;
				if(!bValid && SCTrySpellGroup(SPELL_ELEMENTAL_SHIELD, SPELL_DEATH_ARMOR, -1, -1, oTarget)==TRUE) bValid=TRUE;
			}
		}
		if(ismage) 
		{
			if(!bValid && oTarget==oCharacter && SCTrySpellGroup(SPELL_MIND_BLANK, SPELL_LESSER_MIND_BLANK, -1, -1, oTarget)==TRUE) bValid=TRUE;
			if(!bValid && SCTrySpellGroup(SPELL_ENERGY_IMMUNITY, SPELL_PROTECTION_FROM_ENERGY, SPELL_RESIST_ENERGY, SPELL_ENDURE_ELEMENTS, oTarget)==TRUE) bValid=TRUE;
		}
	}
	return bValid;
}





//  Gets the local int off of the character
//  determining what the Last Spell Cast was.
//
//  Sets the local int on of the character
//  storing what the Last Spell Cast was.
//
//  Compares whether the local is the same as the
//  currently selected spell.
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 27, 2002
int SCGetLastGenericSpellCast(object oCharacter = OBJECT_SELF)
{
    return GetLocalInt(oCharacter, "NW_GENERIC_LAST_SPELL");
}

void SCSetLastGenericSpellCast(int nSpell, object oCharacter = OBJECT_SELF)
{
    SetLocalInt(oCharacter, "NW_GENERIC_LAST_SPELL", nSpell);
    // February 2003. Needed to add a way for this to reset itself, so that
    // spell might indeed be atempted later.
    DelayCommand(8.0,SetLocalInt(oCharacter, "NW_GENERIC_LAST_SPELL", -1));
}


int SCCompareLastSpellCast(int nSpell)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCompareLastSpellCast Start", GetFirstPC() ); }
    
    int nLastSpell = SCGetLastGenericSpellCast();
    if(nSpell == nLastSpell)
    {
        return TRUE;
        SCSetLastGenericSpellCast(-1);
    }
    return FALSE;
}

int SCTestTalent(talent tUse, object oTarget, int isArea=FALSE) 
{
    if(GetIsTalentValid(tUse))
    {
        if( (GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL &&
            !GetHasSpellEffect(GetIdFromTalent(tUse), oTarget) &&
            !SCCompareLastSpellCast(GetIdFromTalent(tUse)) ) ||
            GetTypeFromTalent(tUse) != TALENT_TYPE_SPELL )
        {
            if( GetTypeFromTalent(tUse) == TALENT_TYPE_SPELL)
            {
                SCSetLastGenericSpellCast(GetIdFromTalent(tUse));
            }
			if(SCEvenTalentCheck(tUse, oTarget)) {
				if(!isArea)
            		return SCEvenTalentFilter(tUse, oTarget);
				else {
					ClearAllActions();
					ActionUseTalentAtLocation(tUse, GetLocation(oTarget));
            	}
				return TRUE;
			}
        }
    }
	return FALSE;
}



//:: Get CR Max for Talents
//
//    Determines the Spell CR to be used in the
//    given situation
//
//    BK: changed this. It returns the the max CR for
//    this particular scenario.
//
//    NOTE: Will apply to all creatures though it may
//    be necessary to limit it just for associates.
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 18, 2001
int SCGetCRMax( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetCRMax Start", GetFirstPC() ); }
    
    //int nCR;

    // * retrieves the combat difficulty that has been stored
    // * from being set in SC DetermineCombatRound
    //int nDiff =  GetLocalInt(oCharacter, "NW_L_COMBATDIFF");

    if  (NO_SMART == TRUE)
    {
        return 20;
   }
   else
   {
       return GetLocalInt(oCharacter, "NW_L_COMBATDIFF"); // the max CR of any talent that is going to be used
   }
}




int SCgenericAttemptHarmful(talent tUse, object oTarget, int cat)
{
	if(SCTestTalent(tUse, oTarget)) return TRUE;
	int nSteps;
	int nCR=SCGetCRMax();
	int cumm=0;
	for(nSteps=0; nSteps<5; nSteps++)
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		cumm+=d2()+1;
		nCR-=cumm;
		if(nCR<4) nCR=4;
        tUse = SCEvenGetCreatureTalent(cat, nCR, d2()-1);
        if(SCTestTalent(tUse, oTarget)) return TRUE;
    }
    return FALSE;
}


// sub function of SC TalentDebuff()
int SCSumMord( object oCharacter = OBJECT_SELF )
{
	if(GetModuleSwitchValue("EVENFLW_SWITCHES")>1) return 0;
    int nCnt=0;
    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCharacter), TRUE);
    while( GetIsObjectValid(oTarget) )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if(GetIsEnemy(oTarget) && !GetIsDead(oTarget)) nCnt++;
        else if(!GetIsDead(oTarget)) nCnt--;
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oCharacter), TRUE);
    }
    return nCnt;
}




int SCTalentOthers(int nCompassion, object oIntruder=OBJECT_INVALID, int ismage=0, int castingmode=0, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentOthers Start", GetFirstPC() ); }
    
    int total=0;
	int t1, t2;
	switch(d4()) {
	case 1:t1=TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE;
	break;
	case 2:t1=TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE;
	break;
	case 3:t1=TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF;
	break;
	case 4:t1=TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF;
	break;
	}
	switch(d2()) {
	case 1:t2=TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT;
	break;
	case 2:t2=TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT;
	break;
	}
	if(d2()==1) {
		total=t2;
		t2=t1;
		t1=total;
		total=0;
	}
	int seed=d2();
	talent tUse1=SCEvenGetCreatureTalent(t1, SCGetCRMax(), d2()-1, TRUE);
	talent tUse2=SCEvenGetCreatureTalent(t2, SCGetCRMax(), d2()-1, TRUE);
	if(seed==1) {
		if((nCompassion<50 || d2()==1) && SCTalentAdvancedBuff2(oCharacter, oIntruder, ismage, castingmode)) return TRUE;
		if(SCTestTalent(tUse1, oCharacter)) return TRUE;
		if(SCTestTalent(tUse2, oCharacter)) return TRUE;
	}
	if(nCompassion<50) return 0;
	int owned=GetIsRosterMember(oCharacter) || GetIsOwnedByPlayer(oCharacter);
	object oTarget=SCGetFirstTalentTarget(owned, RADIUS_SIZE_LARGE);
	while (GetIsObjectValid(oTarget) && (owned || total<5) && total < 20)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        total++;
        if(!GetIsEnemy(oTarget) && !GetIsDead(oTarget) && GetArea(oCharacter)==GetArea(oTarget) && GetDistanceBetween(oCharacter, oTarget)<RADIUS_SIZE_LARGE)
        {
			if(d4()==1 && SCTalentAdvancedBuff2(oTarget, oIntruder, ismage, castingmode)) return TRUE;
          	if(SCTestTalent(tUse1, oTarget)) return TRUE;
			if(SCTestTalent(tUse2, oTarget)) return TRUE;
        }
		oTarget=SCGetNextTalentTarget(owned, RADIUS_SIZE_LARGE);
    }
	if(seed==2) {
		if(SCTestTalent(tUse1, oCharacter)) return TRUE;
		if(SCTestTalent(tUse2, oCharacter)) return TRUE;
	}
    return FALSE;
}


int SCTalentLastDitch( object oCharacter = OBJECT_SELF )
{
	int ret=0;
	int issilenced=CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SILENCE);
	if(!issilenced) {
		if(SCTrySpell(SPELL_DIVINE_POWER, oCharacter)) return TRUE;
		ret=SCTrySpellGroup(SPELL_SHAPECHANGE, SPELL_I_WORD_OF_CHANGING, SPELL_TENSERS_TRANSFORMATION, SPELL_IRON_BODY, oCharacter, oCharacter, SPELL_POLYMORPH_SELF, SPELL_STONE_BODY);
	}
	if(ret) SetLocalInt(oCharacter, "EVENFLW_AI_UNPOLY", 1);
	if(!ret && !(GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE")& 0x2) &&
	!CSLGetHasEffectType(oCharacter,EFFECT_TYPE_POLYMORPH)) {
		if(GetHasFeat(FEAT_ELEMENTAL_SHAPE, oCharacter)) {
			AssignCommand(oCharacter, ClearAllActions() );
			AssignCommand(oCharacter,ActionUseFeat(FEAT_ELEMENTAL_SHAPE, oCharacter) );
			SetLocalInt(oCharacter, "EVENFLW_AI_UNPOLY", 1);
			return TRUE;
		}
		if(GetHasFeat(FEAT_WILD_SHAPE, oCharacter))  {
			AssignCommand(oCharacter, ClearAllActions() );
			AssignCommand(oCharacter, ActionUseFeat(FEAT_WILD_SHAPE, oCharacter) );
			SetLocalInt(oCharacter, "EVENFLW_AI_UNPOLY", 1);
			return TRUE;
		}
	}
	if(!ret && !issilenced && SCTrySpell(SPELL_TRUE_STRIKE, oCharacter)) return TRUE;
	return ret;
}


int SCTalentCantrip(object oIntruder, object oCharacter = OBJECT_SELF) 
{
    if(GetHitDice(oIntruder)>5 || GetHitDice(oCharacter)>5 || CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SILENCE)) return FALSE;
    int nSpell=-1;
    int seed1=SPELL_ACID_SPLASH, seed2=SPELL_RAY_OF_FROST;
    int dropout=0;
    if(d2()==1) {
        seed1=SPELL_RAY_OF_FROST;
        seed2=SPELL_ACID_SPLASH;
    }
    if(GetHasSpell(SPELL_RESISTANCE, oCharacter) && d2()==1 && !GetHasSpellEffect(SPELL_RESISTANCE,oCharacter) && GetDistanceBetween(oCharacter, oIntruder)>10.0f) {
        nSpell=SPELL_RESISTANCE;
        oIntruder=oCharacter;
    } else if(GetHasSpell(SPELL_DAZE, oCharacter) && !GetIsImmune(oIntruder, IMMUNITY_TYPE_MIND_SPELLS) && !GetHasSpellEffect(SPELL_DAZE, oIntruder))
        nSpell=SPELL_DAZE;
    else if(GetHasSpell(SPELL_FLARE, oCharacter) &&!GetHasSpellEffect(SPELL_FLARE, oIntruder))
        nSpell=SPELL_FLARE;
    else if(GetHasSpell(seed1, oCharacter))
        nSpell=seed1;
    else if(GetHasSpell(seed2, oCharacter))
        nSpell=seed2;
    else if(GetHasSpell(SPELL_VIRTUE, oCharacter) && !GetHasSpellEffect(SPELL_VIRTUE, oCharacter) && GetDistanceBetween(oCharacter, oIntruder)>10.0f) {
        nSpell=SPELL_VIRTUE;
		oIntruder=oCharacter;
    }
    if(nSpell!=-1) {
		AssignCommand(oCharacter, ClearAllActions() );
        AssignCommand(oCharacter, ActionCastSpellAtObject(nSpell, oIntruder) );
        return TRUE; 
    }
    return FALSE;
}

int SCTalentBuffSelf( object oCharacter = OBJECT_SELF )
{
    int total=0;
	int t1=TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION;
	int t2=TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION;
	if(d2()==1) {
		total=t2;
		t2=t1;
		t1=total;
	}
	talent tUse1=SCEvenGetCreatureTalent(t1, SCGetCRMax(), d2()-1);
	talent tUse2=SCEvenGetCreatureTalent(t2, SCGetCRMax(), d2()-1);
	if(SCTestTalent(tUse1, oCharacter)) return TRUE;
	if(SCTestTalent(tUse2, oCharacter)) return TRUE;
	return FALSE;
}




int SCTalentSeeInvisible( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentSeeInvisible Start", GetFirstPC() ); }
	
	if(CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SILENCE)) return 0;
    int nSpell;
    int bValid = FALSE;
    if(GetHasSpell(SPELL_TRUE_SEEING, oCharacter))
    {
        nSpell = SPELL_TRUE_SEEING;
        bValid = TRUE;
    }
    else if(GetHasSpell(SPELL_I_SEE_THE_UNSEEN, oCharacter))
	{
		nSpell = SPELL_I_SEE_THE_UNSEEN;
        bValid = TRUE;
	}
	else if(GetHasSpell(SPELL_BLINDSIGHT, oCharacter))
	{
		nSpell = SPELL_BLINDSIGHT;
        bValid = TRUE;
	}
	else if(GetHasSpell(SPELL_SEE_INVISIBILITY, oCharacter))
    {
        nSpell = SPELL_SEE_INVISIBILITY;
        bValid = TRUE;
    }
	else if(GetHasSpell(SPELL_INVISIBILITY_PURGE, oCharacter))
    {
        nSpell = SPELL_INVISIBILITY_PURGE;
        bValid = TRUE;
    }
    if(bValid == TRUE)
    {
        AssignCommand(oCharacter, ClearAllActions() );
        AssignCommand(oCharacter, ActionCastSpellAtObject(nSpell, oCharacter) );
    }
    return bValid;
}


/* todo need to figure out if this is causing the big issues*/
int SCTalentSummonAllies( object oCharacter = OBJECT_SELF )
{
    /*/DEBUGGING/*/ if (DEBUGGING >= 2) { CSLDebug(  "SCTalentSummonAllies Start for "+GetName(oCharacter), GetFirstPC() ); }
    //return FALSE;
    if(!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)))
    {
        int nCR = SCGetCRMax();
		if(!CSLGetHasEffectType(oCharacter, EFFECT_TYPE_SILENCE) && nCR>=18 && GetHasSpell(SPELL_GATE, oCharacter) && (GetHasSpell(321, oCharacter) || GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oCharacter) || GetHasSpellEffect(321, oCharacter)) ) 
		{
			ClearAllActions();
			if(!GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oCharacter) && !GetHasSpellEffect(321, oCharacter)) {
				AssignCommand(oCharacter,  ActionCastSpellAtObject(321, oCharacter) );//, METAMAGIC_ANY, TRUE);
			}
			// TODO put this back // 
			AssignCommand(oCharacter, ActionCastSpellAtObject(SPELL_GATE, oCharacter) );
			return TRUE;
		}
        talent tUse = SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES, nCR, FALSE, oCharacter );
        if(GetIsTalentValid(tUse) && GetCreatureHasTalent( tUse, oCharacter ) )
        {
            location lSelf;
            object oTarget =  CSLFindSingleRangedTarget(oCharacter);
            if(GetIsObjectValid(oTarget))
            {
                vector vTarget = GetPosition(oTarget);
                vector vSource = GetPosition(oCharacter);
                vector vDirection = vTarget - vSource;
                float fDistance = VectorMagnitude(vDirection) / 2.0f;
                vector vPoint = VectorNormalize(vDirection) * fDistance + vSource;
                lSelf = Location(GetArea(oCharacter), vPoint, GetFacing(oCharacter));
            }
            else
            {
                lSelf = GetLocation(oCharacter);
            }
            ClearAllActions();
            if(GetIsObjectValid(GetMaster()))
            {
                AssignCommand(oCharacter, ActionUseTalentAtLocation(tUse, GetLocation(GetMaster())) );
            }
            else
            {
                AssignCommand(oCharacter, ActionUseTalentAtLocation(tUse, lSelf) );
            }
            return TRUE;
        }
	}
    return FALSE;
}


int SCCheckNonOffensiveMagic(object oIntruder, int nOffense, int nCompassion, int nMagic, int iCastingMode, object oCharacter = OBJECT_SELF)
{
   	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckNonOffensiveMagic Start", GetFirstPC() ); }
   	
    if (nCompassion > 50) {
        SetLocalInt(oCharacter, "NW_L_MEMORY", CHOOSETACTICS_MEMORY_DEFENSE_OTHERS);
        if(SCTalentHeal( FALSE, oCharacter) == TRUE) return 99;
		if(SCTalentResurrect()) return 99;
        if(SCTalentCureCondition() == TRUE) return 99;
    }
    if (nOffense<= 50 && nMagic > 50) {
        SetLocalInt(oCharacter, "NW_L_MEMORY", CHOOSETACTICS_MEMORY_DEFENSE_SELF);
        int nCaster = GetLevelByClass(CLASS_TYPE_WIZARD, oIntruder) +
            GetLevelByClass(CLASS_TYPE_SORCERER, oIntruder) +
            GetLevelByClass(CLASS_TYPE_BARD, oIntruder)+
			GetLevelByClass(CLASS_TYPE_CLERIC, oIntruder) +
            GetLevelByClass(CLASS_TYPE_DRUID, oIntruder);
		if(iCastingMode==2) nCaster+=5;
        if (iCastingMode<2 || nCaster > GetHitDice(oCharacter)/2)
        {
			nCaster=1;
            if (SCTalentSelfProtectionMantleOrGlobe())
                return 99;
        } else nCaster=0;
        int seed=d4();
        if(seed!=1 && nCompassion<51 || seed>2) {
            if(SCTalentAdvancedBuff2(oCharacter, oIntruder, nCaster, iCastingMode) == TRUE) return 99;
        } else {
            if(SCTalentOthers(nCompassion, oIntruder, nCaster, iCastingMode)) return 99;
        }
        if(SCTalentSummonAllies() == TRUE) return 99;
        if(!(GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE")&0x1) && SCTalentBuffSelf() == TRUE) return 99; // potions
        if(SCCheckForInvis(oIntruder) && SCTalentSeeInvisible() == TRUE) return 99;
    }
	return 0;
}

int SCGetScaledCastingMagic(int iCastingMode, int nMagic, int def, int random=FALSE, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetScaledCastingMagic Start", GetFirstPC() ); }
	
	switch(iCastingMode) {
		case 1: nMagic=55;
		break;
		case 2: nMagic=45-GetHitDice(oCharacter)/3;
		break;
		case 3: if(random) nMagic=Random(nMagic)+1;
				else nMagic=40-GetHitDice(oCharacter)/2;
		break;
		default: if(random) nMagic=Random(def)+1;
				else nMagic=def;
	}
	return nMagic;
}


void SCInitializeSeed(int iCastingMode, object oIntruder, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeSeed Start", GetFirstPC() ); }
	
	int diff=20;
	if(iCastingMode>1)
		diff=GetHitDice(oIntruder);
	if(iCastingMode==2)
		diff+=5;
	if(diff>20) diff=20;
	if(d2()==1) {
		if(diff>GetHitDice(oCharacter))
			diff=GetHitDice(oCharacter)+1;
		diff-=d4()+1;
		if(diff<4) diff=4;
	}
	SetLocalInt(oCharacter, "NW_L_COMBATDIFF", diff);
}



int SCGetMelee() {
	object weapon=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	if(!GetIsObjectValid(weapon) || CSLItemGetIsMeleeWeapon(weapon)) return TRUE;
	return FALSE;
}

// returns percentage of hitpoints remaining
int SCGetHPPercentage(object oTarget=OBJECT_SELF)
{
	return ((GetCurrentHitPoints(oTarget)*100)/GetMaxHitPoints(oTarget));
}


int SCGetCastingMode(int iMyHPPercentage)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetCastingMode Start", GetFirstPC() ); }
	
	int iCastingMode = 0;
	
	if(iMyHPPercentage < 50) 
		iCastingMode=0;
	else if(CSLGetAssociateState(CSL_ASC_OVERKIll_CASTING)) 
		iCastingMode=1;
	else if(CSLGetAssociateState(CSL_ASC_POWER_CASTING)) 
		iCastingMode=2;
	else if(CSLGetAssociateState(CSL_ASC_SCALED_CASTING)) 
		iCastingMode=3;
		
	return (iCastingMode);
}



struct rTactics SCCreateTactics(int nOffense=0, int nCompassion=0, int nMagic=0, int nMagicOld=0, int nStealth=0, int bScaredOfSilence=0, int bTacticChosen=0)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCreateTactics Start", GetFirstPC() ); }
	
	struct rTactics tacAI;
	
    tacAI.nOffense			= nOffense;
    tacAI.nCompassion		= nCompassion;
    tacAI.nMagic			= nMagic;
    tacAI.nMagicOld			= nMagicOld;
	tacAI.nStealth			= nStealth;
									
	tacAI.bScaredOfSilence	= bScaredOfSilence;	
	tacAI.bTacticChosen		= bTacticChosen;
	
	return (tacAI);
}










 // * Tries to do the Ki Damage ability
int SCTryKiDamage(object oTarget, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTryKiDamage Start "+GetName(oTarget), GetFirstPC() ); }
    
    if (GetIsObjectValid(oTarget) == FALSE)
    {
        return FALSE;

    }
    if (GetHasFeat(FEAT_KI_DAMAGE, oCharacter) == TRUE)
    {
        // * Evaluation:
        // * Must have > 40 hitpoints AND  (damage reduction OR damage resistance)
        // * Or just have over 200 hitpoints
        int bHasDamageReduction = FALSE;
        int bHasDamageResistance = FALSE;
        int bHasHitpoints = FALSE;
        int bHasMassiveHitpoints = FALSE;
        int bOutNumbered = FALSE;

        int nCurrentHP = GetCurrentHitPoints(oTarget);
        if (nCurrentHP > 40)
            bHasHitpoints = TRUE;
        if (nCurrentHP > 200)
            bHasMassiveHitpoints = TRUE;
        if (CSLGetHasEffectType(oTarget,EFFECT_TYPE_DAMAGE_REDUCTION) == TRUE)
            bHasDamageReduction = TRUE;
        if (CSLGetHasEffectType(oTarget,EFFECT_TYPE_DAMAGE_RESISTANCE) == TRUE)
            bHasDamageResistance = TRUE;

        if (GetIsObjectValid(CSLGetNearestEnemy(oCharacter, 3)) == TRUE)
        {
            bOutNumbered = TRUE;
        }

        if ( (bHasHitpoints && (bHasDamageReduction || bHasDamageResistance) ) || (bHasMassiveHitpoints) || (bHasHitpoints && bOutNumbered) )
        {
            ClearAllActions();
            ActionUseFeat(FEAT_KI_DAMAGE, oTarget);
            return TRUE;
        }
    }
    return FALSE;
}
 





// Using a long list of "if's" because it's much easer to work with in the script debugger.
int SCValidTarget(object oTarget, object oCharacter = OBJECT_SELF ) 
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCValidTarget Start "+GetName(oTarget), GetFirstPC() ); }	
	if (GetIsObjectValid(oTarget))
	{
		if (oTarget!=oCharacter)
		{
			if ( !GetIsDead(oTarget, FALSE ) )
			{
				if (GetIsEnemy(oTarget))
				{
					if (!GetFactionEqual(oCharacter, oTarget) || GetLocalInt(oCharacter, "EVENFLW_AI_CONFUSED")) 
					{
						if (!CSLGetAssociateState(CSL_ASC_MODE_DYING, oTarget))
						{
							//if (GetPlotFlag(oTarget) == FALSE)
							if (GetAssociateType(oTarget) != ASSOCIATE_TYPE_FAMILIAR)
							{
								return TRUE;
							}
						}
					}	
						
				}
			}	
					
		}			
					
	}
	return FALSE;
}




int SCTalentSneakAttack( object oCharacter = OBJECT_SELF )
{
    
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentSneakAttack Start", GetFirstPC() ); }
    
    if(GetHasFeat(FEAT_SNEAK_ATTACK, oCharacter)) {
    	object oFriend = SCGetNearestNonEnemy( oCharacter );
        if(GetIsObjectValid(oFriend)) 
		{
             object oTarget = GetLastHostileActor(oFriend);
             if(GetIsObjectValid(oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK, oCharacter) &&
				GetAttackTarget(oTarget)!=oCharacter && SCValidTarget(oTarget)) 
				{
                 ActionAttack(oTarget);
                 return TRUE;
             }
         }
	}
    return FALSE;
}





// DRAGON COMBAT
// * February 2003: Cut the melee interaction (BK)
int SCTalentDragonCombat(object oIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF)
{
    //MyPrintString("SC TalentDragonCombat Enter");
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oTarget))
    {
        oTarget = GetAttemptedAttackTarget();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
        {
            oTarget = GetLastHostileActor();
            if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
            {
                oTarget = CSLGetNearestPerceivedEnemy();
                if(!GetIsObjectValid(oTarget))
                {
                    return FALSE;
                }
            }
        }
    }
    int nCnt = GetLocalInt(oCharacter, "NW_GENERIC_DRAGONS_BREATH");
    talent tUse = SCGetCreatureTalent(TALENT_CATEGORY_DRAGONS_BREATH, SCGetCRMax());
    //SpeakString(IntToString(nCnt));
    if(GetIsTalentValid(tUse) && GetCreatureHasTalent( tUse, oCharacter ) && nCnt >= 2)
    {
        //MyPrintString("SC TalentDragonCombat Successful Exit");
        SCEvenTalentFilter(tUse, oTarget);
        nCnt = 0;
        SetLocalInt(oCharacter, "NW_GENERIC_DRAGONS_BREATH", nCnt);
        return TRUE;
    }
    // * breath weapons only happen every 3 rounds
    nCnt++;
    SetLocalInt(oCharacter, "NW_GENERIC_DRAGONS_BREATH", nCnt);

    //MyPrintString("SC TalentDragonCombat Failed Exit");
    //SetLocalInt(oCharacter, "NW_GENERIC_DRAGONS_BREATH", nCnt);
    return FALSE;
}



// Return TRUE if oObject is affected by a Normal Bard Song
int SCGetHasNormalBardSongSpellEffect( object oObject= OBJECT_SELF )
{
	if ( GetHasSpellEffect( SPELLABILITY_SONG_COUNTERSONG, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_HAVEN_SONG, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_IRONSKIN_CHANT, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_HEROICS, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_LEGION, oObject ) )
	{
		return ( TRUE );
	}
			
	return ( FALSE );
}

// Return TRUE if oObject is affected by an Inspire Bard Song
int SCGetHasInspireBardSongSpellEffect( object oObject= OBJECT_SELF )
{
	if ( GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COURAGE, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COMPETENCE, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_DEFENSE, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_REGENERATION, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_TOUGHNESS, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_SLOWING, oObject ) ||
			GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_JARRING, oObject ) )
	{
		return ( TRUE );
	}
			
	return ( FALSE );
}

// Return a useable Normal Bard Song feat, or 0 if none found.
int SCGetNormalBardSongFeat( object oCharacter= OBJECT_SELF )
{
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_LEGION, oCharacter ) )
		return ( FEAT_BARDSONG_INSPIRE_LEGION );
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_HEROICS, oCharacter ) )
		return ( FEAT_BARDSONG_INSPIRE_HEROICS );
	if ( GetHasFeat( FEAT_BARDSONG_IRONSKIN_CHANT, oCharacter) )
		return ( FEAT_BARDSONG_IRONSKIN_CHANT );
	return ( 0 );
}



// Return a useable Inspire Bard Song feat, or 0 if none found.
int SCGetInspireBardSongFeat( object oCharacter= OBJECT_SELF ) 
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetInspireBardSongFeat Start", GetFirstPC() ); }
	
	if ( GetHasFeat( FEAT_BARDSONG_INSPIRE_COURAGE, oCharacter ) )
		return ( FEAT_BARDSONG_INSPIRE_COURAGE );
	return ( 0 );
}




// Return TRUE if chose to sing a Bard Song
int SCTalentBardSong(object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentBardSong Start", GetFirstPC() ); }
	
	int nBardLevels = GetLevelByClass( CLASS_TYPE_BARD, oCharacter );
	if ( nBardLevels < 1 )
	{
		return ( FALSE );
	}

	int nBardFeat;

	//if ( SC GetHasNormalBardSongSpellEffect( oCharacter ) == FALSE )
	if ( SCGetHasNormalBardSongSpellEffect( oCharacter ) == FALSE && SCGetHasInspireBardSongSpellEffect( oCharacter ) == FALSE)
	{
		nBardFeat = SCGetNormalBardSongFeat();
		if ( nBardFeat > 0 )
		{
			ClearAllActions();
			ActionUseFeat( nBardFeat, oCharacter );
			return ( TRUE );
		}
	} 

	if ( SCGetHasInspireBardSongSpellEffect( oCharacter ) == FALSE )
	{
		nBardFeat = SCGetInspireBardSongFeat();
		if ( nBardFeat > 0 )
		{
			ClearAllActions();
			ActionUseFeat( nBardFeat, oCharacter );
			return ( TRUE );
		}
	}
	return ( FALSE );
}






// Check if we can already determine from the class what to do.
int SCTryClassTactic(object oIntruder, int nClass, int bNoFeats, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTryClassTactic Start", GetFirstPC() ); }
	
	int bTacticChosen = FALSE;
	
    switch (nClass)
    {
        case CLASS_TYPE_COMMONER:
        	bTacticChosen = SCTalentFlee(oIntruder);
			break;
			
		//------------------------------------------			
		
        case CLASS_TYPE_DRAGONDISCIPLE:
			if (!bNoFeats 
				&& GetHasFeat(FEAT_DRAGON_DIS_BREATH, oCharacter) 
				&& d4()==1)
    		{
        		ClearAllActions();
        		AssignCommand(oCharacter, ActionCastSpellAtObject(690, CSLGetNearestEnemy(), METAMAGIC_ANY, TRUE) );
        		DecrementRemainingFeatUses(oCharacter, FEAT_DRAGON_DIS_BREATH);
        		bTacticChosen = TRUE;
    		}
			break;
			
		//------------------------------------------			
			
		case CLASS_TYPE_BARD:
			if (!bNoFeats 
				&& SCTalentBardSong() == TRUE)
			{
				bTacticChosen = TRUE;
			}
			break;
			
			
		//------------------------------------------			
			
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_ARCANE_ARCHER:
			if (!GetLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED") 
				&& GetHasFeat(FEAT_RAPID_SHOT, oCharacter))
			{				
				SetActionMode(oCharacter, ACTION_MODE_RAPID_SHOT, TRUE);
				bTacticChosen = FALSE; // still need to choose a tactic
			}
			break;
	
		//------------------------------------------			
			
        case CLASS_TYPE_BARBARIAN:
			if (!bNoFeats 
				&& !GetHasFeatEffect(FEAT_BARBARIAN_RAGE) 
				&& GetHasFeat(FEAT_BARBARIAN_RAGE, oCharacter)) 
			{
				ClearAllActions();
				ActionUseFeat(FEAT_BARBARIAN_RAGE, oCharacter);
				ActionAttack(oIntruder);
        		bTacticChosen = TRUE;
			}
			break;
			
		//------------------------------------------			
			
		case CLASS_TYPE_FRENZIEDBERSERKER:
			if (!bNoFeats 
				&& !GetHasFeatEffect(FEAT_FRENZY_1) 
				&& GetHasFeat(FEAT_FRENZY_1, oCharacter)) 
			{
				ClearAllActions();
				ActionUseFeat(FEAT_FRENZY_1, oCharacter);
				ActionAttack(oIntruder);
        		bTacticChosen = TRUE;
			}
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_MONK:
			SetActionMode(oCharacter, ACTION_MODE_FLURRY_OF_BLOWS, TRUE);
			bTacticChosen = FALSE; // still need to choose a tactic
			break;

		//------------------------------------------			
			
        default:
            break;
    }

	return (bTacticChosen);
}
	
struct rTactics SCCalculateTacticsByClass(struct rTactics tacAI, object oIntruder, int nClass, int iCastingMode, object oCharacter = OBJECT_SELF )
{	
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCalculateTacticsByClass Start", GetFirstPC() ); }
    
    int nOffense			= tacAI.nOffense;
    int nCompassion			= tacAI.nCompassion;
    int nMagic				= tacAI.nMagic;
    int nMagicOld			= tacAI.nMagicOld;
	int nStealth			= tacAI.nStealth;
									
	int bScaredOfSilence	= tacAI.bScaredOfSilence;	
	int bTacticChosen		= tacAI.bTacticChosen; // this function should not choose a tactic.

	
	// Classes determine the "base" levels for the tactic types.  
	// Thus the values are generally overridden, not modified	
    switch (nClass)
    {
        case CLASS_TYPE_COMMONER:
			nOffense 				= 0; 
			nCompassion 			= 0; 
			nMagic 					= 0;  
			break;
		//------------------------------------------			
			
        case CLASS_TYPE_PALEMASTER:
		case CLASS_TYPE_ARCANETRICKSTER:
        case CLASS_TYPE_WIZARD:
        case CLASS_TYPE_SORCERER:
			bScaredOfSilence		= TRUE;
			nMagic 					= SCGetScaledCastingMagic(iCastingMode, 40, 100);
			if(iCastingMode ==1 ) 
				nMagic				= 100;
            nCompassion 			= 42; 
			break;
		//------------------------------------------			
		
        case CLASS_TYPE_DRAGONDISCIPLE:
		case CLASS_TYPE_BARD:
			bScaredOfSilence		= TRUE;
			// continue
			
        case CLASS_TYPE_HARPER:
		case CLASS_TYPE_ELDRITCH_KNIGHT:
			nMagic 					= SCGetScaledCastingMagic(iCastingMode, 40, 43);
            nCompassion 			= 43; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_CLERIC:
			if (GetHitDice(oIntruder) > GetHitDice(oCharacter)) 
				nStealth			= 70;
			bScaredOfSilence		= TRUE;
			// continue

		case CLASS_TYPE_WARPRIEST:
			nMagic 					= SCGetScaledCastingMagic(iCastingMode, 40, 44);
			nCompassion				= 45; 
			break;

		//------------------------------------------			
						
        case CLASS_TYPE_DRUID:
			nMagic 					= SCGetScaledCastingMagic(iCastingMode, 40, 55);
			bScaredOfSilence		= TRUE;
            nCompassion 			= 45; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_RANGER:
        case CLASS_TYPE_PALADIN:
			nCompassion				= 43;
			// continue
			
        case CLASS_TYPE_ARCANE_ARCHER:
        case CLASS_TYPE_BLACKGUARD:
			nMagic 					= SCGetScaledCastingMagic(iCastingMode, 50, 50, TRUE);
            break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_BARBARIAN:
		case CLASS_TYPE_FRENZIEDBERSERKER:
			nMagic 					= SCGetScaledCastingMagic(iCastingMode, 40, 40, TRUE);
            nOffense 				= 50; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_ROGUE:
		case CLASS_TYPE_SHADOWTHIEFOFAMN:
        case CLASS_TYPE_SHADOWDANCER:
        case CLASS_TYPE_ASSASSIN:
			nMagic 					= SCGetScaledCastingMagic(iCastingMode, 40, 40, TRUE);
			nStealth				= 100; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_MONK:
        case CLASS_TYPE_WEAPON_MASTER:
        case CLASS_TYPE_DWARVENDEFENDER:
        case CLASS_TYPE_FIGHTER:
		case CLASS_NWNINE_WARDER:
		case CLASS_TYPE_DUELIST:
			nMagic 					= SCGetScaledCastingMagic(iCastingMode, 40, 40, TRUE);
            break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_UNDEAD:
            nCompassion 			= 40; 
			nMagic 					= 40; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_OUTSIDER:
            nMagic 					= 40; 
			nCompassion				= 0;
            if (GetAlignmentGoodEvil(oCharacter) == ALIGNMENT_GOOD)
            {
                nCompassion 		= 41;
            }
            break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_CONSTRUCT:
        case CLASS_TYPE_ELEMENTAL:
            nCompassion 			= 0;
			nMagic 					= 40; 
			break;
			
		//------------------------------------------			
			
        case CLASS_TYPE_DRAGON:
            nCompassion 			= 20; 
			nMagic 					= 40; 
			break;
			
		//------------------------------------------			
			
		case CLASS_TYPE_WARLOCK:
			bScaredOfSilence		= FALSE;
			nCompassion 			= 0; 
			nMagic 					= 80; 
			break;
			
		//------------------------------------------			
			
        default:
            break;
    }
	return (SCCreateTactics(nOffense, nCompassion, nMagic, nMagicOld, nStealth, bScaredOfSilence, bTacticChosen));
}


// Could be a problem if anyone decides to make an Army of Warlocks mod.
struct EldritchTarget SCGetBestEldritchAOETarget(int nShape, float fDimension, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetBestEldritchAOETarget Start", GetFirstPC() ); }
	
	object oCurrent;
	object oTarget;
	location lTargetLocation;
	int nCurrentAffected;
	struct EldritchTarget etReturnTarget;
	int i = 1;

	etReturnTarget.nAffected = 0;
	etReturnTarget.oTarget = OBJECT_INVALID;

	oCurrent = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY, oCharacter, i);
	while(GetIsObjectValid(oCurrent))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		nCurrentAffected = 0;
		lTargetLocation = GetLocation(oCurrent);
	
		oTarget = GetFirstObjectInShape(nShape, fDimension, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
		while(GetIsObjectValid(oTarget))
		{
			//DEBUGGING// igDebugLoopCounter += 1;
			if(GetIsEnemy(oTarget))
			{
				nCurrentAffected++;
			}
			oTarget = GetNextObjectInShape(nShape, fDimension, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
		}	
		if(nCurrentAffected > etReturnTarget.nAffected)
		{
			etReturnTarget.nAffected = nCurrentAffected;
			etReturnTarget.oTarget = oCurrent;
		}
		i++;
		oCurrent = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,oCharacter,i);
		if(GetDistanceToObject(oCurrent) > 20.f)	//we don't want to check every enemy in the level, just close ones.
			break;
	}

	return etReturnTarget;
}

struct EldritchShape SCGetBestEldritchShape(object oIntruder, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetBestEldritchShape Start", GetFirstPC() ); }
	
	//Look for the blast effect that will do the most damage
	int nCasterLvl = GetLevelByClass(CLASS_TYPE_WARLOCK);
	int nBestSpell = -1;
	int nBestAffected = 1;
    int nAffectedChain = 0;
	location lTargetLocation = GetLocation(oIntruder);
	object oTarget;
	struct EldritchTarget etBestTarget;
	struct EldritchShape esBestShape;
	esBestShape.nSpell = -1;
	esBestShape.oTarget = oIntruder;
	
	//60 feet is the effective range of Eldritch blast.  Anything longer, use Spear.
	if(GetHasSpell(SPELL_I_ELDRITCH_SPEAR, oCharacter) && GetDistanceToObject(oIntruder) > FeetToMeters(60.f))
	{
//		PrettyDebug("Chain is most effective.");
		esBestShape.nSpell = SPELL_I_ELDRITCH_SPEAR;
		return esBestShape;
	}
	
//	PrettyDebug("Trying chain.");
	if(GetHasSpell(SPELL_I_ELDRITCH_CHAIN, oCharacter))
	{
		//Chain has our biggest potential radius, making it the best possible shape unless a different shape can
		//affect more than chain's maximum.
		if ( nCasterLvl >= 20 )      { nAffectedChain = 4; }
		else if ( nCasterLvl >= 15 ) { nAffectedChain = 3; }
		else if ( nCasterLvl >= 10 ) { nAffectedChain = 2; }
		else                         { nAffectedChain = 1; }
	}

	if(nAffectedChain > nBestAffected)
	{
//		PrettyDebug("Chain is most effective.");
		nBestAffected = nAffectedChain;
		esBestShape.nSpell = SPELL_I_ELDRITCH_CHAIN;
	}
	
//	PrettyDebug("Trying cone.");
	if(GetHasSpell(SPELL_I_ELDRITCH_CONE, oCharacter))
	{
		etBestTarget = SCGetBestEldritchAOETarget(SHAPE_SPELLCONE, 11.f);
		if(etBestTarget.nAffected > nBestAffected)
		{
//			PrettyDebug("Cone is most effective.");
			nBestAffected = etBestTarget.nAffected;
			esBestShape.nSpell = SPELL_I_ELDRITCH_CONE;
			esBestShape.oTarget = etBestTarget.oTarget;
		}
	}
	
//	PrettyDebug("Trying doom.");
	if(GetHasSpell(SPELL_I_ELDRITCH_DOOM, oCharacter))
	{
		etBestTarget = SCGetBestEldritchAOETarget(SHAPE_SPHERE, RADIUS_SIZE_HUGE);
		if(etBestTarget.nAffected > nBestAffected)
		{
//			PrettyDebug("Doom is most effective.");
			nBestAffected = etBestTarget.nAffected;
			esBestShape.nSpell = SPELL_I_ELDRITCH_DOOM;
			esBestShape.oTarget = etBestTarget.oTarget;
		}	
	}
	return esBestShape;
}
		
int SCGetInvocationSpellFromMetamagic(int nMeta)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetInvocationSpellFromMetamagic Start", GetFirstPC() ); }
	
	switch(nMeta)
	{
	case METAMAGIC_INVOC_FRIGHTFUL_BLAST :
		return SPELL_I_FRIGHTFUL_BLAST;
	case METAMAGIC_INVOC_DRAINING_BLAST :
		return SPELL_I_DRAINING_BLAST;
	case METAMAGIC_INVOC_BESHADOWED_BLAST :
		return SPELL_I_BESHADOWED_BLAST;
	case METAMAGIC_INVOC_BRIMSTONE_BLAST :
		return SPELL_I_BRIMSTONE_BLAST;
	case METAMAGIC_INVOC_HELLRIME_BLAST :
		return SPELL_I_HELLRIME_BLAST;
	case METAMAGIC_INVOC_BEWITCHING_BLAST :
		return SPELL_I_BEWITCHING_BLAST;
	case METAMAGIC_INVOC_NOXIOUS_BLAST :
		return SPELL_I_NOXIOUS_BLAST;
	case METAMAGIC_INVOC_VITRIOLIC_BLAST :
		return SPELL_I_VITRIOLIC_BLAST;
	case METAMAGIC_INVOC_UTTERDARK_BLAST :
		return SPELL_I_UTTERDARK_BLAST;
	}
	return -1;
}
		
int SCGetInvocationEssenceByIndex(int nLevel, int nIndex)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetInvocationEssenceByIndex Start", GetFirstPC() ); }
	
	if(nLevel == 1)
	{
		switch(nIndex)
		{
		case 1: return METAMAGIC_INVOC_FRIGHTFUL_BLAST;
		case 2:	return METAMAGIC_INVOC_DRAINING_BLAST;
		}
	}
	else if (nLevel == 2)
	{
		switch(nIndex)
		{
		case 1: return METAMAGIC_INVOC_BESHADOWED_BLAST;
		case 2: return METAMAGIC_INVOC_BRIMSTONE_BLAST;
		case 3:	return METAMAGIC_INVOC_HELLRIME_BLAST;
		}
	}
	else if(nLevel == 3)
	{
		switch(nIndex)
		{
		case 1: return METAMAGIC_INVOC_BEWITCHING_BLAST;
		case 2: return METAMAGIC_INVOC_NOXIOUS_BLAST;
		case 3: return METAMAGIC_INVOC_VITRIOLIC_BLAST;
		}
	}
	else if (nLevel == 4)
	{
		switch(nIndex)
		{
		case 1: return METAMAGIC_INVOC_UTTERDARK_BLAST;
		}
	}
	//PrettyError("nwn2_inc_talent - GetInvocationIndexByEssence(): Unable to locate Invocation Essence.");
	return METAMAGIC_NONE;
}

int SCGetRandomInvocationEssenceByLevel(int nLevel, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetRandomInvocationEssenceByLevel Start", GetFirstPC() ); }
	
	int nSpells, nIndex;
	
	//decide how big the random roll is, based on the Warlock's current spell table.
	switch(nLevel)
	{
		case 1:
			nSpells = 2;
			break;
		case 2:
			nSpells = 3;
			break;
		case 3:
			nSpells = 3;
			break;
		case 4:
			nSpells = 1;
			break;
	}
	
	nIndex = Random(nSpells) + 1;
	int nEssence = SCGetInvocationEssenceByIndex(nLevel, nIndex);
	int i;
	for(i = 0; i < nSpells; i++)
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		//pick a random index to start from, then cycle through
		//looking for one that the player has.
		nEssence = SCGetInvocationEssenceByIndex(nLevel, nIndex);
		if(nEssence != METAMAGIC_NONE && GetHasSpell(SCGetInvocationSpellFromMetamagic(nEssence), oCharacter))
			return nEssence;
		
		nIndex++;
		if(nIndex >= nSpells)
		{
			nIndex = 1;	//restart the cycle.	
		}
	}
	return METAMAGIC_NONE;
}
	
int SCGetBestInvocationEssenceMetamagic()
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetBestInvocationEssenceMetamagic Start", GetFirstPC() ); }
	
	int nLevel = GetLevelByClass(CLASS_TYPE_WARLOCK);
	int nEssenceLevel, nEssence;
	
	//what level of essence invocations can I cast?
	if(nLevel >= 16)
	{
		nEssenceLevel = 4;	
	}
	else if (nLevel >= 11)
	{
		nEssenceLevel = 3;	
	}
	else if(nLevel >=  6)
	{
		nEssenceLevel = 2;	
	}
	else
	{
		nEssenceLevel = 1;
	}
		
	while(nEssenceLevel > 0)
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		nEssence = 	SCGetRandomInvocationEssenceByLevel(nEssenceLevel);
		if( nEssence != METAMAGIC_NONE )
		{
			return nEssence;
		}
		nEssenceLevel--;
	}
	
	return METAMAGIC_NONE;
}

int SCGetBestEldritchBlastFeat()
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetBestEldritchBlastFeat Start", GetFirstPC() ); }
	
	int nLevel = GetLevelByClass(CLASS_TYPE_WARLOCK);
	int nFeatLevel;
		
	if(nLevel < 13)
	{
		nFeatLevel = (nLevel+1) / 2;	
	}
	else if(nLevel <= 16)
	{
		nFeatLevel = 7;
	} 
	else if(nLevel <= 19)
	{
		nFeatLevel = 8;	
	}
	else
	{
		nFeatLevel = 9;
	}
	switch(nFeatLevel)
	{
		case 1:
			return FEAT_ELDRITCH_BLAST_1;
		case 2:
			return FEAT_ELDRITCH_BLAST_2;
		case 3:
			return FEAT_ELDRITCH_BLAST_3;
		case 4:
			return FEAT_ELDRITCH_BLAST_4;
		case 5:
			return FEAT_ELDRITCH_BLAST_5;
		case 6:
			return FEAT_ELDRITCH_BLAST_6;
		case 7:
			return FEAT_ELDRITCH_BLAST_7;
		case 8:
			return FEAT_ELDRITCH_BLAST_8;
		case 9:
			return FEAT_ELDRITCH_BLAST_9;
	}
	return FEAT_INVALID;
}



talent SCGetWarlockInvocationTalent(int bRandom, object oIntruder)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetWarlockInvocationTalent Start", GetFirstPC() ); }
	
	talent tUse;
	int nEnemy = SCCheckEnemyGroupingOnTarget(oIntruder);
	int nSeed=d2()+nEnemy;
	if(CSLGetAssociateState(CSL_ASC_SCALED_CASTING)) 
	{
		if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES)
			nSeed=0;
		else nSeed-=2;
	} else if(CSLGetAssociateState(CSL_ASC_POWER_CASTING)) nSeed-=1;
	if(nSeed > 1) 
	{
		tUse = SCGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, SCGetCRMax(), bRandom);
	}
	if(!GetIsTalentValid(tUse))
    {
    	tUse = SCGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, SCGetCRMax(), bRandom);
    }
	return tUse;
}

int SCTalentWarlockSpellAttack(object oIntruder, object oCaster = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentWarlockSpellAttack Start", GetFirstPC() ); }
    
    talent tUse;
    object oTarget = oIntruder;
	struct EldritchShape esBestShape;
	int nMetamagicEssence;
	int bRandomize;
		
	if(Random(3) == 0)	//try a non-eldritch-blast invocation
	{
		bRandomize = Random(3) > 0 ? TRUE : FALSE;	// with some probability, we randomize the Warlock's invocations so he's not always using the best one.
		
		tUse = SCGetWarlockInvocationTalent(bRandomize, oIntruder);
		
		// * if something was valid, attempt to use that something intelligently
		if (GetIsTalentValid(tUse))
		{
			if (!GetHasSpellEffect(GetIdFromTalent(tUse), oTarget))
			{
				SCSetLastGenericSpellCast(GetIdFromTalent(tUse));
				ActionUseTalentOnObject(tUse, oTarget);
				return TRUE;
			}
		}
	}
	
	//Try an eldritch blast.  Pick the optimal shape, pick the best available essence to attach as metamagic.
	esBestShape = SCGetBestEldritchShape(oTarget);
	nMetamagicEssence = SCGetBestInvocationEssenceMetamagic();
	oTarget = esBestShape.oTarget;	//the optimal shape may be centered on a different target.
	if(esBestShape.nSpell > 0)
	{
		SCSetLastGenericSpellCast(esBestShape.nSpell);
		AssignCommand(oCaster, ActionCastSpellAtObject(esBestShape.nSpell, oTarget, nMetamagicEssence) );
		return TRUE;
	}
	else if(nMetamagicEssence != METAMAGIC_NONE)	//we can just cast the essence if we don't have a good shape for it.
	{
		SCSetLastGenericSpellCast(esBestShape.nSpell);
		AssignCommand(oCaster, ActionCastSpellAtObject(SCGetInvocationSpellFromMetamagic(nMetamagicEssence), oTarget) );
		return TRUE;
	}
	else
	{
		int nFeat = SCGetBestEldritchBlastFeat();
		if(nFeat != FEAT_INVALID)
		{
			SCSetLastGenericSpellCast(844);	//844 is Eldritch Blast.
			AssignCommand(oCaster, ActionUseFeat(nFeat,oTarget) );	
			return TRUE;
		}
	}


		
	return FALSE;
}



int SCTalentHealingSelf(int bForce = FALSE, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentHealingSelf Start", GetFirstPC() ); }
    
    int nCurrent = GetCurrentHitPoints(oCharacter);
    int nBase = GetMaxHitPoints(oCharacter);
	int nRace = GetRacialType(oCharacter);
	if ( nCurrent  >= nBase && bForce != TRUE )
	{
		return FALSE;
	}
	// these guys can't use normal healing
    if (nRace != RACIAL_TYPE_UNDEAD && nRace != RACIAL_TYPE_CONSTRUCT  && nRace != RACIAL_TYPE_OOZE)
    {
        if( (nCurrent*2 < nBase) || (bForce == TRUE) )
        {
				int iExcludeFlag = GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE");
            talent tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, SCGetCRMax(), FALSE, TRUE);
			if ( GetIsTalentValid(tUse) && (GetLocalInt(oCharacter, "X2_L_STOPCASTING") != 10) && (GetHasFeat(FEAT_NATURAL_SPELL, oCharacter, TRUE) || !CSLGetHasEffectType(oCharacter,EFFECT_TYPE_POLYMORPH) ))
            {
				if(!GetLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED") && GetLocalInt(oCharacter, "EVENFLW_NUM_MELEE")&& (SCGetLastGenericSpellCast() != 0))
					SetActionMode(oCharacter, ACTION_MODE_DEFENSIVE_CAST, TRUE);
                SCEvenTalentFilter(tUse, oCharacter);
                return TRUE;
            }
            else if(!(GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE")&0x1))
            {
                tUse = GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, SCGetCRMax(), oCharacter, iExcludeFlag);
                if(GetIsTalentValid(tUse))
                {
                    SCEvenTalentFilter(tUse, oCharacter);
                    return TRUE;
                }
            }
        }
		
    }
	if((GetIsOwnedByPlayer(oCharacter) || GetIsRosterMember(oCharacter)) && (nCurrent*2 < nBase && d6()==1 || nCurrent*4 < nBase && d4()==1) )
	{
		PlayVoiceChat(VOICE_CHAT_HEALME);
    }
    return FALSE;
}






struct rTactics SCCalculateTactics(struct rTactics tacAI, object oIntruder, float fDistanceToIntruder, int nClass, int iCastingMode, int isSilenced, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCalculateTactics Start", GetFirstPC() ); }
    
    int nPreviousMemory 	= GetLocalInt(oCharacter, "NW_L_MEMORY");

    int nOffense			= tacAI.nOffense;
    int nCompassion			= tacAI.nCompassion;
    int nMagic				= tacAI.nMagic;
    int nMagicOld			= tacAI.nMagicOld;
	int nStealth			= tacAI.nStealth;
									
	int bScaredOfSilence	= tacAI.bScaredOfSilence;	
	int bTacticChosen		= tacAI.bTacticChosen;
	
	int iHpsPercentage = SCGetHPPercentage( oCharacter );
	
	// tend toward stealthy if wounded
	if ( iHpsPercentage < 50 )
		nStealth += 10;	

	// Racial adjustments
    if (GetRacialType(oCharacter) == RACIAL_TYPE_UNDEAD  && nCompassion > 40  && iHpsPercentage < 75)
	{		
        nCompassion = 0;
	}
	
	// random adjustments			
    nOffense 	= Random(10) + nOffense;
    nMagic 		= Random(10) + nMagic;
    nCompassion = Random(10) + nCompassion;
	
	// Bahavior variable adjustments
    nMagic 		= nMagic + SCAdjustBehaviorVariable(nMagic, "X2_L_BEH_MAGIC");	
    nOffense 	= nOffense + SCAdjustBehaviorVariable(nOffense, "X2_L_BEH_OFFENSE");
    nCompassion = nCompassion + SCAdjustBehaviorVariable(nCompassion, "X2_L_BEH_COMPASSION");
	
	// feat adjustments
    if (GetIsObjectValid(oIntruder) && !GetHasFeat(FEAT_COMBAT_CASTING, oCharacter))
    {
        if (fDistanceToIntruder <= 5.f) 
		{
            nOffense = nOffense + 20;
            nMagic = nMagic - 20;
        }
    }
	
	// casting mode adjustments
    if (iCastingMode!=2 && fDistanceToIntruder > 2.5f)
        nMagic = nMagic + 15;
		
	// Intruder stats adjustments		
    nMagic = nMagic + GetHitDice(oIntruder);
	
	// previous choices adjustments	
    if ((nPreviousMemory == CHOOSETACTICS_MEMORY_DEFENSE_OTHERS)
        || (nPreviousMemory == CHOOSETACTICS_MEMORY_DEFENSE_SELF))
    {
        nOffense = nOffense + Random(40);
    }
	
	// remember magic score at this point.
	nMagicOld = nMagic;
	
	// adjustments if incapable of casting
    if (GetHasFeatEffect(FEAT_BARBARIAN_RAGE) 
		|| SCGetShouldNotCastSpellsBecauseofArmor(oCharacter, nClass)
        || GetLocalInt(oCharacter, "X2_L_STOPCASTING") == 10 
		|| GetHasFeatEffect(FEAT_FRENZY_1) 
		|| GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION, oCharacter) 
		|| GetHasSpellEffect(SPELL_TRUE_STRIKE, oCharacter))
    {
		nCompassion = 0;
        nMagic = 0;
    }
	
	// polymorphed adjustments for casting
	// AFW-OEI 07/12/2007: Don't unpolymorph if you're polymorph locked
	if (CSLGetHasEffectType(oCharacter,EFFECT_TYPE_POLYMORPH)	&& !GetPolymorphLocked(oCharacter)
		&& (!GetHasFeat(FEAT_NATURAL_SPELL, oCharacter, TRUE) || !CSLGetHasEffectType(oCharacter,EFFECT_TYPE_WILDSHAPE))) 
	{
		int unpoly = GetLocalInt(oCharacter, "EVENFLW_AI_UNPOLY");
		if(!unpoly) 
		{
			SetLocalInt(oCharacter, "EVENFLW_AI_UNPOLY", 1);
			DelayCommand(RoundsToSeconds(5), SetLocalInt(oCharacter, "EVENFLW_AI_UNPOLY", 2));
		}
		if(unpoly==2 && d6()==1) 
		{
			effect eff = GetFirstEffect(oCharacter);
			while (GetIsEffectValid(eff)) 
			{
				//DEBUGGING// igDebugLoopCounter += 1;
				if(GetEffectType(eff)==EFFECT_TYPE_POLYMORPH) 
				{
					RemoveEffect(oCharacter, eff);
					break;
				}
				eff=GetNextEffect(oCharacter);
			}
		} 
		else 
			nMagic=0;
	} 
	else 
		DeleteLocalInt(oCharacter, "EVENFLW_AI_UNPOLY");
	
	
	// silence
	if(isSilenced) 
	{
		if (GetLocalInt(oCharacter, "EVENFLW_NOT_SILENCE_SCARED") 
			|| GetLocalInt(oCharacter, "EVENFLW_SILENCE"))
				bScaredOfSilence = FALSE;
	} 
	else 
	{
		DeleteLocalInt(oCharacter, "EVENFLW_NOT_SILENCE_SCARED");
		DeleteLocalInt(oCharacter, "EVENFLW_SILENCE");
	}
	
	
    int isInvis = SCInvisibleTrue(oCharacter);
    if (!GetObjectSeen(oCharacter, oIntruder) 
		&& isInvis == TRUE 
		&& nMagic > 0 
		&& !isSilenced)
    {
        if (nStealth==100 || GetActionMode(oCharacter, ACTION_MODE_STEALTH) == TRUE)
        {
          nOffense = 100; // * if in stealth attempt sneak attacks
        } 
		else if(d4()!=1) 
		{
            nOffense = 7;
            if (nMagic < 51)
			{ 
				nMagic += 10;
			}	
			nCompassion += d10();
			if ( iHpsPercentage < 80)
            	if(SCTalentHealingSelf(TRUE) == TRUE)
				{
					bTacticChosen = TRUE;
				}					
        }
    } 
	else
	{ 
		if ((nStealth==100 || (!isSilenced && (nStealth>=Random(100)))) 
			&& SCInvisibleBecome(oCharacter, isInvis) == TRUE) 
		{
			bTacticChosen = TRUE;
		}			
	}
	
	return (SCCreateTactics(nOffense, nCompassion, nMagic, nMagicOld, nStealth, bScaredOfSilence, bTacticChosen));
}


int SCTalentDebuff(object oIntruder=OBJECT_INVALID, object oCharacter = OBJECT_SELF) 
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentDebuff Start", GetFirstPC() ); }
	
	if(GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL") || CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SILENCE)) 
	{
		return FALSE;
	}
	int hd=GetHitDice(oCharacter);
	if(!CSLGetAssociateState(CSL_ASC_SCALED_CASTING)) hd/=2;
    if(GetHitDice(oIntruder)<hd) return FALSE;
    int canbanish=0;
    if(GetHasSpell(SPELL_BANISHMENT, oCharacter)) canbanish=SPELL_BANISHMENT;
    else if(GetHasSpell(SPELL_DISMISSAL, oCharacter)) canbanish=SPELL_DISMISSAL;
    if(canbanish) {
    	object master=GetMaster(oIntruder);
        if(GetIsObjectValid(master) && GetLocalString(oIntruder, "X2_S_PM_IMMUNE_DISMISSAL")!="IMMUNE" &&
               (GetAssociate(ASSOCIATE_TYPE_SUMMONED, master) == oIntruder ||
               GetAssociate(ASSOCIATE_TYPE_FAMILIAR, master) == oIntruder ||
               GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, master) == oIntruder ||
               canbanish==SPELL_BANISHMENT && GetRacialType(oIntruder) == RACIAL_TYPE_OUTSIDER ) ) {
            ClearAllActions();
			AssignCommand(oCharacter, ActionCastSpellAtObject(canbanish, oIntruder) );
            return TRUE;
        }
	}
    int canbuff=0;
    if(GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oCharacter) || GetHasSpell(SPELL_GREATER_SPELL_BREACH, oCharacter) || GetHasSpell(SPELL_LESSER_SPELL_BREACH, oCharacter))
    {
    	canbuff=1;
    }
    if(!canbuff && GetHitDice(oIntruder)<GetHitDice(oCharacter)+5 && ( GetHitDice(oIntruder)<25 &&  GetHasSpell(SPELL_GREATER_DISPELLING, oCharacter) ||  GetHitDice(oIntruder)<15 && GetHasSpell(SPELL_DISPEL_MAGIC, oCharacter) || GetHitDice(oIntruder)<10 && GetHasSpell(SPELL_LESSER_DISPEL, oCharacter) ))
    {
    	canbuff+=2;
    }
    if(!canbuff) return FALSE;

    int shouldbuff=0;
    effect eEffect = GetFirstEffect(oIntruder);
    while ( GetIsEffectValid(eEffect) == TRUE )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        int nEffectID = GetEffectSpellId(eEffect);
        if(!GetIsObjectValid(GetEffectCreator(eEffect)) || GetIsEnemy(oIntruder, GetEffectCreator(eEffect))) {
            shouldbuff=0;
            break;
        }
        if (nEffectID != -1 && GetEffectSubType(eEffect)!=SUBTYPE_EXTRAORDINARY)
            shouldbuff++;
        eEffect = GetNextEffect(oIntruder);
    }
    if(GetHasSpellEffect(SPELL_PREMONITION, oIntruder)) shouldbuff+=2;
    if(GetHasSpellEffect(SPELL_GREATER_SPELL_MANTLE, oIntruder)) shouldbuff+=2;
    if(GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oIntruder)) shouldbuff+=2;
    if(GetHasSpellEffect(SPELL_SPELL_MANTLE, oIntruder)) shouldbuff+=1;
    if(GetHasSpellEffect(SPELL_SHADOW_SHIELD, oIntruder)) shouldbuff+=1;
    if(GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD, oIntruder)) shouldbuff+=2;
	if(GetHasSpellEffect(SPELL_MIRROR_IMAGE, oIntruder)) shouldbuff+=1;
    int nSpell=-1;
    if(shouldbuff>5 && GetHasSpell(SPELL_MORDENKAINENS_DISJUNCTION, oCharacter))
        if(shouldbuff+SCSumMord()>5)
            nSpell=SPELL_MORDENKAINENS_DISJUNCTION;
    else if(GetHasSpell(SPELL_GREATER_SPELL_BREACH, oCharacter) &&
        (shouldbuff>3 || shouldbuff>2 && !GetHasSpell(SPELL_LESSER_SPELL_BREACH, oCharacter)) )
        nSpell=SPELL_GREATER_SPELL_BREACH;
    else if(canbuff>1 && shouldbuff>1 && GetHitDice(oIntruder)<25 && GetHasSpell(SPELL_GREATER_DISPELLING, oCharacter))
        nSpell=SPELL_GREATER_DISPELLING;
    else if(shouldbuff>1 && GetHasSpell(SPELL_LESSER_SPELL_BREACH, oCharacter))
        nSpell=SPELL_LESSER_SPELL_BREACH;
    else if(canbuff>1 && shouldbuff>1 && GetHitDice(oIntruder)<15 && GetHasSpell(SPELL_DISPEL_MAGIC, oCharacter))
        nSpell=SPELL_DISPEL_MAGIC;
    else if(canbuff>1 && shouldbuff>1 && GetHitDice(oIntruder)<10 && GetHasSpell(SPELL_LESSER_DISPEL, oCharacter))
        nSpell=SPELL_LESSER_DISPEL;
    if(nSpell!=-1) {
		ClearAllActions();
        AssignCommand(oCharacter, ActionCastSpellAtObject(nSpell, oIntruder) );
        return TRUE;
    }
    return FALSE;
}



int SCTalentMeleeAttacked(object oIntruder = OBJECT_INVALID, int nMelee=0)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentMeleeAttacked Start", GetFirstPC() ); }
	
	if(!GetIsObjectValid(oIntruder)) return FALSE;
    talent tUse;
    object oTarget = oIntruder;
    int nCR = SCGetCRMax();
	int nSeed=d2();
	if(CSLGetAssociateState(CSL_ASC_SCALED_CASTING)) {
			if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES)
				nSeed=10;
			else nSeed+=2;
		} else if(CSLGetAssociateState(CSL_ASC_POWER_CASTING)) nSeed+=1;
    if(nMelee == 1)
    {
        tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH, nCR, d2()-1, TRUE);
		if(SCTestTalent(tUse, oTarget)) return TRUE;
        tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR, d2()-1, TRUE);
        if (SCgenericAttemptHarmful(tUse, oTarget, TALENT_CATEGORY_HARMFUL_RANGED)) return TRUE;	
        tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, nCR, d2()-1, TRUE);
        if(SCTestTalent(tUse, oTarget)) return TRUE;
		if(GetGameDifficulty()<GAME_DIFFICULTY_CORE_RULES) {
			tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR, d2()-1, TRUE);
        	if(SCTestTalent(tUse, oTarget)) return TRUE;
		}
    }
    else if (nMelee > nSeed)
    {
        tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, nCR, d2()-1, TRUE);
        if(SCTestTalent(tUse, oTarget)) return TRUE;
		if(GetGameDifficulty()<GAME_DIFFICULTY_CORE_RULES) {
			tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR, d2()-1, TRUE);
        	if(SCTestTalent(tUse, oTarget)) return TRUE;
		}
        tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_TOUCH, nCR, d2()-1, TRUE);
        if(SCTestTalent(tUse, oTarget)) return TRUE;
        tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR, d2()-1, TRUE);
        if(SCgenericAttemptHarmful(tUse, oTarget, TALENT_CATEGORY_HARMFUL_RANGED)) return TRUE;	
    }
    return FALSE;
}



int SCTalentRangedEnemies(object oIntruder = OBJECT_INVALID)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentRangedEnemies Start", GetFirstPC() ); }
	
	if(!GetIsObjectValid(oIntruder)) return FALSE;
    talent tUse;
    object oTarget = oIntruder;
    int nCR = SCGetCRMax();
    if(GetIsObjectValid(oTarget))
    {
        int nEnemy = SCCheckEnemyGroupingOnTarget(oTarget);
		int nSeed=d2()+nEnemy;
		if(CSLGetAssociateState(CSL_ASC_SCALED_CASTING)) {
			if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES)
				nSeed=0;
			else nSeed-=2;
		} else if(CSLGetAssociateState(CSL_ASC_POWER_CASTING)) nSeed-=1;
        if(nSeed<3)
        {
         	tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR, d2()-1, TRUE);
        	if(SCgenericAttemptHarmful(tUse, oTarget, TALENT_CATEGORY_HARMFUL_RANGED)) return TRUE;	
       	}
        if(GetGameDifficulty()>=GAME_DIFFICULTY_CORE_RULES && SCCheckFriendlyFireOnTarget(oTarget) > 0)// &&  nEnemy > 0)
        {
            tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT,
                                         nCR, d2()-1, TRUE);
            if(SCTestTalent(tUse, oTarget)) return TRUE;
        }
        else if(nSeed > 1)
        {
            tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, nCR, d2()-1, TRUE);
            if(SCTestTalent(tUse, oTarget, TRUE)) return TRUE;
            else
            {
                tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT,
                                             nCR, d2()-1, TRUE);
                if(SCTestTalent(tUse, oTarget)) return TRUE;
            }
        }
		if(nSeed>=3) {
        	tUse = SCEvenGetCreatureTalent(TALENT_CATEGORY_HARMFUL_RANGED, nCR, d2()-1, TRUE);
        	if(SCgenericAttemptHarmful(tUse, oTarget, TALENT_CATEGORY_HARMFUL_RANGED)) return TRUE;	
		}
    }
    return FALSE;
}




// KNOCKDOWN / IMPROVED KNOCKDOWN
// This function tries to use the knockdown feat on oIntruder.
// returns TRUE on Knockdown is ok to try on this combat round,
// returns FALSE if Knockdown will not be tried for whatever reason.
// If TRUE is returned, Kncokdown will already have been put on the action queue.
int SCTalentKnockdown(object oIntruder, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentKnockdown Start", GetFirstPC() ); }
	
	int nFeat=-1;
    // use knockdown occasionally if we have it
    // and the target is not immune
	int nMySize = GetCreatureSize(oCharacter);
    if (GetHasFeat(FEAT_IMPROVED_KNOCKDOWN, oCharacter))
	{
		nFeat = FEAT_IMPROVED_KNOCKDOWN;
        nMySize++;
    }
	else if (GetHasFeat(FEAT_KNOCKDOWN, oCharacter))
		nFeat = FEAT_KNOCKDOWN;

    // prevent silly use of knockdown on immune or
    // too-large targets
    if (GetIsImmune(oIntruder, IMMUNITY_TYPE_KNOCKDOWN) || (GetCreatureSize(oIntruder) > nMySize+1) )
        nFeat = -1;		
	if ((GetHasFeatEffect(FEAT_IMPROVED_KNOCKDOWN, oIntruder))||(GetHasFeatEffect(FEAT_KNOCKDOWN, oIntruder)))
		nFeat = -1;			

    if (nFeat != -1)
	{
		ClearAllActions();
        ActionUseFeat(nFeat, oIntruder);
        return TRUE;
    }
	return FALSE;
}



// TURN UNDEAD
int SCTalentUseTurning(object oUndead=OBJECT_INVALID, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentUseTurning Start", GetFirstPC() ); }
    
    int nCount;
    if(GetHasFeat(FEAT_TURN_UNDEAD, oCharacter))
    {
        if(!GetIsObjectValid(oUndead)) oUndead = CSLGetNearestPerceivedEnemy();
        int nHD = GetHitDice(oUndead);
		if(GetDistanceBetween(oCharacter, oUndead)>=1.5*RADIUS_SIZE_COLOSSAL) return FALSE;
        if(!GetIsObjectValid(oUndead) || GetIsDead(oUndead) || CSLGetHasEffectType(oUndead,EFFECT_TYPE_TURNED)
           || GetHitDice(oCharacter) <= nHD || GetLocalObject(oCharacter, "EVENFLW_LAST_TURN_TARGET")==oUndead)
        {
            return FALSE;
        }
        int TurnLevel=GetLevelByClass(CLASS_TYPE_CLERIC);
        if(GetLevelByClass(CLASS_TYPE_PALADIN)>3) TurnLevel+=GetLevelByClass(CLASS_TYPE_PALADIN)-3;
        if(GetLevelByClass(CLASS_TYPE_BLACKGUARD)>2) TurnLevel+=GetLevelByClass(CLASS_TYPE_BLACKGUARD)-2;
		if(TurnLevel <= nHD) return FALSE;
        if(GetHasFeat(FEAT_PLANT_DOMAIN_POWER, oCharacter) && GetRacialType(oUndead)==RACIAL_TYPE_VERMIN)
            nCount=1;
        if(GetRacialType(oUndead)==RACIAL_TYPE_UNDEAD)
			nCount=1;
        if(nCount > 0)
        {
            ClearAllActions();	
			SetLocalObject(oCharacter, "EVENFLW_LAST_TURN_TARGET", oUndead);
            ActionUseFeat(FEAT_TURN_UNDEAD, oCharacter);
            return TRUE;
        }
    }
    return FALSE;
}



// * Returns true if the creature's variable
// * set on it rolled against a d100
// * says it is okay to whirlwind.
// * Added this because it got silly to see creatures
// * constantly whirlwinded
int SCGetOKToWhirl(object oCharacter)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetOKToWhirl Start", GetFirstPC() ); }
    
    int nWhirl = GetLocalInt(oCharacter, "X2_WHIRLPERCENT");



    if (nWhirl == 0 || nWhirl == 100)
    {
        return TRUE; // 0 or 100 is 100%
    }
    else
    {
        if (Random(100) + 1 <= nWhirl)
        {
            return TRUE;
        }

    }
    return FALSE;
}


// MELEE ATTACK OTHERS
//
//  ISSUE 1: Talent Melee Attack should set the Last Spell Used to 0 so that melee casters can use
//  a single special ability.

int SCWhirlwindGetNumberOfMeleeAttackers(float fDist=5.0, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCWhirlwindGetNumberOfMeleeAttackers Start", GetFirstPC() ); }
    
    object oOne = CSLGetNearestEnemy(oCharacter, 1);

    if (GetIsObjectValid(oOne) == TRUE)
    {
        object oTwo = CSLGetNearestEnemy(oCharacter, 2);
        if (GetDistanceToObject(oOne) <= fDist && GetIsObjectValid(oTwo) == TRUE)
        {
            if (GetDistanceToObject(oTwo) <= fDist)
            {
                // * DO NOT WHIRLWIND if any of the targets are "large" or bigger
                // * it seldom works against such large opponents.
                // * Though its okay to use Improved Whirlwind against these targets
                // * October 13 - Brent
                if (GetHasFeat(FEAT_IMPROVED_WHIRLWIND, oCharacter))
                {
                    return TRUE;
                }
                else
                if (GetCreatureSize(oOne) < CREATURE_SIZE_LARGE && GetCreatureSize(oTwo) < CREATURE_SIZE_LARGE)
                {
                    return TRUE;
                }
                return FALSE;
            }
        }
    }
    return FALSE;
}


int SCTalentMeleeAttack(object oIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentMeleeAttack Start", GetFirstPC() ); }
    
    object oTarget = oIntruder;
    if( !GetIsObjectValid(oTarget)
        || GetArea(oTarget) != GetArea(oCharacter)
        // not clear to me why we check this here...
        // || GetPlotFlag(oCharacter) == TRUE)
        || CSLGetAssociateState(CSL_ASC_MODE_DYING, oTarget))
    {
        oTarget = GetAttemptedAttackTarget();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget)
           || (!GetObjectSeen(oTarget) && !GetObjectHeard(oTarget))
           || GetArea(oTarget) != GetArea(oCharacter)
           || GetPlotFlag(oCharacter) == TRUE)
        {
            oTarget = GetLastHostileActor();
            if(!GetIsObjectValid(oTarget)
               || GetIsDead(oTarget)
               || GetArea(oTarget) != GetArea(oCharacter)
               || GetPlotFlag(oCharacter) == TRUE)
            {
                oTarget = CSLGetNearestPerceivedEnemy();
                if(!GetIsObjectValid(oTarget)) {
                    return FALSE;
                }
            }
        }
    }


    talent tUse;

    // If the difference between the attacker's AC and our
    // attack capabilities is greater than 10, we just use
    // a straightforward attack; otherwise, we try our best
    // melee talent.
    int nAC = GetAC(oTarget);
    float fAttack;
    int nAttack = GetHitDice(oCharacter);

    fAttack = (IntToFloat(nAttack) * 0.75)
        + IntToFloat(GetAbilityModifier(ABILITY_STRENGTH));

    //fAttack = IntToFloat(nAttack) + GetAbilityModifier(ABILITY_STRENGTH);

    int nDiff = nAC - nAttack;

    // * only the playable races have whirlwind attack
    // * Attempt to Use Whirlwind Attack
    int bOkToWhirl = SCGetOKToWhirl(oCharacter);
    int bHasFeat = GetHasFeat(FEAT_WHIRLWIND_ATTACK, oCharacter);
    int bPlayableRace = FALSE;
    if (GetIsPlayableRacialType(oCharacter) || GetTag(oCharacter) == "x2_hen_valen")
      bPlayableRace = TRUE;

	// BMA-OEI 10/12/06: Check if Combat Mode Switching is disabled
	int bCombatModeUseDisabled = GetLocalInt( oCharacter, "N2_COMBAT_MODE_USE_DISABLED" );

    int bNumberofAttackers = SCWhirlwindGetNumberOfMeleeAttackers(WHIRL_DISTANCE);
    if (bOkToWhirl == TRUE && bHasFeat == TRUE  &&   bPlayableRace == TRUE
       &&  bNumberofAttackers == TRUE)
    {
        ClearAllActions();
        ActionUseFeat(FEAT_WHIRLWIND_ATTACK, oCharacter);
        return TRUE;
    }
    else
    // * Try using combat expertise
    if ((bCombatModeUseDisabled == FALSE) && GetHasFeat(FEAT_COMBAT_EXPERTISE, oCharacter) && nDiff < 12)
    {
        ClearAllActions();
        SetActionMode(oCharacter, ACTION_MODE_COMBAT_EXPERTISE, TRUE);
        SCWrapperActionAttack(oTarget);
        return TRUE;
    }
    else
    // * Try using expertise
    if ((bCombatModeUseDisabled == FALSE) && GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE, oCharacter) && nDiff < 15)
    {
        ClearAllActions();
        SetActionMode(oCharacter, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE, TRUE);
        SCWrapperActionAttack(oTarget);
        return TRUE;
    }
    else
    if(nDiff < 10)
    {
        ClearAllActions();
        // * this function will call the BK function
        CSLEquipAppropriateWeapons(oTarget,CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON) );
        tUse = SCGetCreatureTalent(TALENT_CATEGORY_HARMFUL_MELEE,
                                     SCGetCRMax());

        if(GetIsTalentValid(tUse)
           && SCVerifyDisarm(tUse, oTarget)
           && SCVerifyCombatMeleeTalent(tUse, oTarget))
        {
            // February 6 2003: Did not have a clear all actions before it
            SCEvenTalentFilter(tUse, oTarget);
            return TRUE;
        }
        else
        {
            //MyPrintString("SC TalentMeleeAttack Successful Exit");
            SCWrapperActionAttack(oTarget);
            return TRUE;
        }
    }
    else
    {
        ClearAllActions();
        // * this function will call the BK function
        CSLEquipAppropriateWeapons(oTarget,CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON));
        SCWrapperActionAttack(oTarget);
        return TRUE;
    }

    return FALSE;
}



int SCDetermineActionFromTactics(struct rTactics tacAI, object oIntruder, float fDistanceToIntruder, int nClass, int iCastingMode, int isSilenced, int bNoFeats, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCDetermineActionFromTactics Start", GetFirstPC() ); }
    
    int nOffense			= tacAI.nOffense;
    int nCompassion			= tacAI.nCompassion;
    int nMagic				= tacAI.nMagic;
    int nMagicOld			= tacAI.nMagicOld;
	int nStealth			= tacAI.nStealth;
									
	int bScaredOfSilence	= tacAI.bScaredOfSilence;	
	int bTacticChosen		= tacAI.bTacticChosen;
	
	int iNumMeleeAttackers	=SCGetNumberOfMeleeAttackers();

		
    if (nOffense <= 5 
		|| isSilenced 
			&& nMagic>50 
			&& bScaredOfSilence 
			&& GetIsObjectValid(GetLocalObject(oCharacter, "EVENFLW_SILENCE")))
    {
		if (bScaredOfSilence) 
		{
			ActionMoveAwayFromObject(GetLocalObject(oCharacter, "EVENFLW_SILENCE"), TRUE, 7.0f);
			DelayCommand(3.0f, SCAIDetermineCombatRound(oIntruder));
			return 99;
        } 
		else
		{
			if (SCTalentFlee(oIntruder) == TRUE) 
				return 99;
		}				
    }
	
	if(oIntruder==oCharacter) 
		nOffense = 0;
		
	SetLocalInt(oCharacter, "EVENFLW_NUM_MELEE", iNumMeleeAttackers);
	
	if(!GetLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED")) 
	{
		if ((fDistanceToIntruder < 5.0 || iNumMeleeAttackers) && (nMagic>50 || nCompassion>50) && (SCGetLastGenericSpellCast() != 0))
			SetActionMode(oCharacter, ACTION_MODE_DEFENSIVE_CAST, TRUE);
	}
	
	SCInitializeSeed(iCastingMode, oIntruder);
	
	if(SCCheckNonOffensiveMagic(oIntruder, nOffense, nCompassion, nMagic, iCastingMode)) return 99;
	
	if(oIntruder==oCharacter) return 1;
	
    if (nMagic > 50)
    {
        SetLocalInt(oCharacter, "NW_L_MEMORY", CHOOSETACTICS_MEMORY_OFFENSE_SPELL);
        if (!bNoFeats && SCTalentUseTurning(oIntruder) == TRUE) return 99;
		if(SCTalentDebuff(oIntruder)) return 99;
		if(nClass == CLASS_TYPE_WARLOCK) if(SCTalentWarlockSpellAttack(oIntruder)) return 99;
		
		if(GetLocalInt(oCharacter, "EVENFLW_AI_CLOSE")) 
		{
        	if(SCTalentMeleeAttacked(oIntruder, iNumMeleeAttackers) == TRUE) return 99;
        	if(SCTalentRangedEnemies(oIntruder) == TRUE) return 99;
		} 
		else 
		{
        	if(SCTalentRangedEnemies(oIntruder) == TRUE) return 99;
			if(!GetLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED") && (SCGetLastGenericSpellCast() != 0))
				SetActionMode(oCharacter, ACTION_MODE_DEFENSIVE_CAST, TRUE);
			if(SCTalentMeleeAttacked(oIntruder, 1) == TRUE) return 99;
		}
    }
	
	if (nOffense>50 
		&& nMagic>50 
		&& d2()!=1) 
	{
		if(SCCheckNonOffensiveMagic(oIntruder, 10, 0, nMagic, iCastingMode)) return 99;
	}
	
	if(nMagic>50) 
	{
		int lastditch=SCTalentLastDitch();
		if(lastditch==TRUE) return 99;
		if(!lastditch) 
		{
			if(GetLevelByClass(CLASS_TYPE_WARLOCK) && SCTalentWarlockSpellAttack(oIntruder)) return 99;
			if(SCTalentCantrip(oIntruder)) return 99;
		}
	}
	
	if(nMagic==0 && nMagicOld>50) 
	{
		if(!(GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE") & TALENT_EXCLUDE_ITEM) 
			&& SCTalentBuffSelf() == TRUE) 
		{			
			return 99;
		}			
	}
	
	if(nMagic>50) 
		SetLocalInt(oCharacter, "EVENFLW_NOT_SILENCE_SCARED", 1);
		
    SetLocalInt(oCharacter, "NW_L_MEMORY", CHOOSETACTICS_MEMORY_OFFENSE_MELEE);
	
	if (!bNoFeats			
		&& Random(12) == 0	// we only want to do this occasionally
		&& SCGetMelee() 		
		&& SCTalentKnockdown(oIntruder)==TRUE )
	{
		ActionAttack(oIntruder);
		return 99;
	}
			
    if (SCTryKiDamage(oIntruder) == TRUE) return 99;
    if (SCTalentSneakAttack() == TRUE) return 99;
    if (SCTalentDragonCombat(oIntruder)) {return 99;}
    if (SCTalentMeleeAttack(oIntruder) == TRUE) return 99;

	return 1;	
}


int SCChooseTactics(object oIntruder, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCChooseTactics Start", GetFirstPC() ); }
	
	if(SCTalentHealingSelf() == TRUE) return 99;
    if (SCSpecialTactics(oIntruder)) return 99;
	
	int iExcludeFlag 	= GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE");
	int bNoFeats 		= iExcludeFlag & TALENT_EXCLUDE_ABILITY;
    int nClass 			= SCDetermineClassToUse();
		
	float fDistanceToIntruder = GetDistanceToObject(oIntruder);
	int iCastingMode	= SCGetCastingMode( SCGetHPPercentage( oCharacter ) );
	int isSilenced		= CSLGetHasEffectType(oCharacter,EFFECT_TYPE_SILENCE);
	
	// tactics vars - base values
    int nOffense 		= 40;
    int nCompassion		= 25;
    int nMagic 			= 55;
    int nMagicOld		= 0;
	int nStealth		= 30;
	int bScaredOfSilence= FALSE;
	struct rTactics tacAI = SCCreateTactics(nOffense, nCompassion, nMagic, nMagicOld, nStealth, bScaredOfSilence, FALSE);

		
	// Stuff chosen here will short circuit all the tactics calculations 	
	if (SCTryClassTactic(oIntruder, nClass, bNoFeats) == TRUE)
		return 99;

	if(GetCreatureSize(oIntruder) > 4)
	{
		fDistanceToIntruder -= 10.5f;
	}
	
	tacAI = SCCalculateTacticsByClass(tacAI, oIntruder, nClass, iCastingMode);
	if (tacAI.bTacticChosen == TRUE) return 99;

	tacAI = SCCalculateTactics(tacAI, oIntruder, fDistanceToIntruder, nClass, iCastingMode, isSilenced);
	if (tacAI.bTacticChosen == TRUE) return 99;

	return (SCDetermineActionFromTactics(tacAI, oIntruder, fDistanceToIntruder, nClass, iCastingMode, isSilenced, bNoFeats));

} 






// Choose a new nearby target. Target must be an enemy, perceived,
// and not in dying mode. If possible, we first target members of
// a class we hate.
object SCChooseNewTarget( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCChooseNewTarget Start", GetFirstPC() ); }
    
    int nHatedClass = GetLocalInt(oCharacter, "NW_L_BEHAVIOUR1") - 1;

    // * if the object has no hated class, then assign it
    // * a random one.
    // * NOTE: Classes are off-by-one
    if (nHatedClass == -1)
    {
        SCSetupBehavior(1);
        nHatedClass = GetLocalInt(oCharacter, "NW_L_BEHAVIOUR1") - 1;
    }


    // * First try to attack the class you hate the most
    object oTarget = CSLGetNearestPerceivedEnemy(oCharacter, 1,
                                              CREATURE_TYPE_CLASS,
                                              nHatedClass);

    if (GetIsObjectValid(oTarget) && !CSLGetAssociateState(CSL_ASC_MODE_DYING, oTarget))
	{
		//if in Defend master, skip this step because of the over-ruling behaviors of defend master
		if (!(CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER))) 
			// familiars of hated type don't qualify
			if (GetAssociateType(oTarget) != ASSOCIATE_TYPE_FAMILIAR)
				return oTarget;
	}
    // If we didn't find one with the criteria, look
    // for a nearby one
    // * Keep looking until we find a perceived target that
    // * isn't in dying mode
    oTarget = CSLGetNearestPerceivedEnemy();
    int nNth = 1, nSaveNth;
	object oSaveTarget;
    while ( GetIsObjectValid(oTarget) && CSLGetAssociateState(CSL_ASC_MODE_DYING, oTarget) )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        nNth++;
        oTarget = CSLGetNearestPerceivedEnemy(oCharacter, nNth);
    }
	
	// if target is a familiar, keep looking
	if (GetIsObjectValid(oTarget) && GetAssociateType(oTarget) == ASSOCIATE_TYPE_FAMILIAR)
	{
		oSaveTarget = oTarget;
		nSaveNth = nNth;
        nNth++;
		oTarget = CSLGetNearestPerceivedEnemy(oCharacter, nNth);
		while ((GetIsObjectValid(oTarget) && CSLGetAssociateState(CSL_ASC_MODE_DYING, oTarget)) || (GetAssociateType(oTarget) == ASSOCIATE_TYPE_FAMILIAR))
		{
			//DEBUGGING// igDebugLoopCounter += 1;
			nNth++;
			oTarget = CSLGetNearestPerceivedEnemy(oCharacter, nNth);
		}
	
		// if couldn't find a non-familiar to attack, then attack the familiar.
		if (!GetIsObjectValid(oTarget))
		{
			oTarget = oSaveTarget;
			nNth = nSaveNth;
		}
	}

	//Warning - SC GetAssociateState is doing double duty here, making sure oCharacter is an associate and also making sure it is set to stand ground.
	//	This function is run for all creatures, not just associates.
	if (CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER)) // have associates w/ Defend Master stay in sight of Master		
	{
		object oMaster = CSLGetCurrentMaster();
		while (GetIsObjectValid(oTarget) && ((!GetIsInCombat(oTarget)) || CSLGetAssociateState(CSL_ASC_MODE_DYING, oTarget) || ((GetDistanceBetween(oMaster, oTarget) >= DEFEND_MASTER_MAX_TARGET_DISTANCE))))
		{
       		//DEBUGGING// igDebugLoopCounter += 1;
       		nNth++;
       		oTarget = CSLGetNearestPerceivedEnemy(oCharacter, nNth);
    	}
	}	
	
    return oTarget;
}






object SCAcquireTarget( object oCharacter = OBJECT_SELF ) 
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAcquireTarget Start", GetFirstPC() ); }
    
    object oLastTarget = GetAttackTarget();
	// The last target must be valid and also seen 
	// (if target teleports away to unseen location, this should prevent chase.)
    if(SCValidTarget(oLastTarget) && GetObjectSeen(oLastTarget))
    {
        return oLastTarget;
    }
    else
    {
        oLastTarget = SCChooseNewTarget();
    }
    
    if(SCValidTarget(oLastTarget))
    {
    	CSLEquipAppropriateWeapons(oLastTarget);
        return oLastTarget;
	}
	
	// not a valid target, search for a new target.
	int bInvisible = SCInvisibleTrue(oLastTarget);
	oLastTarget=GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, GetLocation(oCharacter), TRUE);
	while(GetIsObjectValid(oLastTarget))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		if ( SCValidTarget(oLastTarget) )
		{
			if( GetObjectSeen(oLastTarget) || bInvisible != TRUE || ( GetHasFeat(FEAT_BLIND_FIGHT, oCharacter) && GetObjectHeard(oLastTarget) ) ) // || ) {
			{
				break;
			}
		}
		oLastTarget=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, GetLocation(oCharacter), TRUE);
	}
    CSLEquipAppropriateWeapons(oLastTarget);
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCAcquireTarget End", GetFirstPC() ); }
    return oLastTarget;
}



//    Returns true if something that shouldn't
//    have happened, happens. Will abort this combat round.
// @todo Need to see why it uses oIntruder but has oCharacter being checked for the effectype
int SCEvaluationSanityCheck( object oIntruder, float fFollow, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCEvaluationSanityCheck Start", GetFirstPC() ); }
    
    // Pausanias: sanity check for various effects
    if ( CSLGetHasEffectTypeGroup(oCharacter,EFFECT_TYPE_PARALYZE,EFFECT_TYPE_STUNNED,EFFECT_TYPE_FRIGHTENED,EFFECT_TYPE_SLEEP,EFFECT_TYPE_DAZED) )
        return TRUE;

    // * no point in seeing if intruder has same master if no valid intruder
    if (!GetIsObjectValid(oIntruder))
        return FALSE;

    // Pausanias sanity check: do not attack target
    // if you share the same master.
    object oMaster = GetMaster();
    int iHaveMaster = GetIsObjectValid(oMaster);
    if (iHaveMaster && GetMaster(oIntruder) == oMaster)
        return TRUE;

    return FALSE; //* COntinue on with SCAIDetermineCombatRound
}






//  Checks if the passed object has an Attempted
//  Attack or Spell Target
//  Created By: Preston Watamaniuk
//  Created On: March 13, 2002
int SCGetIsFighting(object oFighting)
{
    /*
    object oAttack = GetAttemptedAttackTarget();
    object oSpellTarget = GetAttemptedSpellTarget();

    if(GetIsObjectValid( GetAttemptedAttackTarget() ) || GetIsObjectValid( GetAttemptedSpellTarget() ) )
    {
        return TRUE;
    }
    return FALSE;
    */
    return ( GetIsObjectValid( GetAttemptedAttackTarget() ) || GetIsObjectValid( GetAttemptedSpellTarget() ) );
}


 
 

//:://////////////////////////////////////////////////////////
//:: Talent checks and use functions
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////////////////
//
//    This is a series of functions that check
//    if a particular type of talent is available and
//    if so then use that talent.
//
//:://////////////////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////////////////








// ACTIVATE AURAS
int SCTalentPersistentAbilities( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTalentPersistentAbilities Start", GetFirstPC() ); }
	
	// BMA-OEI 9/20/06: Disable spell casting while Polymorphed
	if ( CSLGetHasEffectType( oCharacter,EFFECT_TYPE_POLYMORPH )  == TRUE )
	{
		return ( FALSE );
	}
	
    //MyPrintString("SC TalentPersistentAbilities Enter");
    talent tUse = SCGetCreatureTalent(TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT, SCGetCRMax());
    int nSpellID;
    if(GetIsTalentValid(tUse))
    {
        nSpellID = GetIdFromTalent(tUse);
        if(!GetHasSpellEffect(nSpellID, oCharacter))
        {
            //MyPrintString("SC TalentPersistentAbilities Successful Exit");
            SCEvenTalentFilter(tUse, oCharacter);
            return TRUE;
        }
    }
    //MyPrintString("SC TalentPersistentAbilities Failed Exit");
    return FALSE;
}





//===========================================
// VERSION 2.0 TALENTS
//===========================================







// does the spell have a healishness feel to it?
int SCGetIsHealingRelatedSpell(int nSpellID)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetIsHealingRelatedSpell Start", GetFirstPC() ); }
	
	int iRet = FALSE;
	
	if (( nSpellID == SPELL_CURE_LIGHT_WOUNDS ) 
		|| ( nSpellID == SPELL_CURE_MINOR_WOUNDS ) 
		|| ( nSpellID == SPELL_CURE_MODERATE_WOUNDS ) 
		|| ( nSpellID == SPELL_CURE_CRITICAL_WOUNDS ) 
		|| ( nSpellID == SPELL_CURE_SERIOUS_WOUNDS ) 
		|| ( nSpellID == SPELL_HEAL ) 
		|| ( nSpellID == SPELL_HEALINGKIT )
		|| ( nSpellID == SPELLABILITY_LAY_ON_HANDS ) 
		|| ( nSpellID == SPELLABILITY_WHOLENESS_OF_BODY )
		|| ( nSpellID == SPELL_MASS_CURE_LIGHT_WOUNDS ) // JLR - OEI 08/23/05 -- Renamed for 3.5
		|| ( nSpellID == SPELL_RAISE_DEAD ) 
		|| ( nSpellID == SPELL_RESURRECTION ) 
		|| ( nSpellID == SPELL_MASS_HEAL ) 
		|| ( nSpellID == SPELL_GREATER_RESTORATION ) 
		|| ( nSpellID == SPELL_REGENERATE ) 
		|| ( nSpellID == SPELL_AID ) 
		|| ( nSpellID == SPELL_VIRTUE ) )
	{
		iRet = TRUE;
	}
	return iRet;	
}







// This check is run before the default scripts (nw_c2's) explicitly tell a creature to attack a target
// it is NOT checked in Determine Combat Round. 
int SCGetIsValidRetaliationTarget(object oTarget, object oRetaliator= OBJECT_SELF) 
{
	if (GetPlotFlag(oRetaliator) && !GetIsEnemy(oTarget, oRetaliator))	//please don't attack any neutral or friends if I am plot
		return FALSE; //not cool to attack this guy
	return TRUE; //ok to attack this guy
}








// Return faction leader of oPC. If faction leader is not a PC, return OBJECT_INVALID.
object SCGetPCLeader(object oPC= OBJECT_SELF)
{
	object oMaster = GetFactionLeader(oPC);

	if (GetIsPC(oMaster) == FALSE)
	{
		oMaster = OBJECT_INVALID;
	}

	return (oMaster);
}



// returns true or false
int SCIsHenchman(object oThisHenchman, object oPC)
{
	if (!GetIsPC(oPC)) 
		return FALSE;

	object oHenchman;
	int i;
	for (i=1; i<=GetMaxHenchmen(); i++)
   	{
		//DEBUGGING// igDebugLoopCounter += 1;
		oHenchman = GetHenchman(oPC, i);
			if (GetIsObjectValid(oHenchman))
			if (oHenchman == oThisHenchman)
					return TRUE;
	}
	return FALSE;
}



// Returns henchman with specified tag if found
object SCGetHenchmanByTag(object oPC, string sHenchmanTag="", object oCharacter = OBJECT_SELF)
{
	if (sHenchmanTag == "")
		sHenchmanTag = GetTag(oCharacter);

	object oHenchman;
	int i;
	for (i=1; i<=GetMaxHenchmen(); i++)
   	{
		//DEBUGGING// igDebugLoopCounter += 1;
		oHenchman = GetHenchman(oPC, i);
		//PrintString ("Henchman [" + IntToString(i) + "] = " + GetName(oHenchman));
			if (GetIsObjectValid(oHenchman))
		{
			//PrintString ("Henchman [" + IntToString(i) + "] = " + GetName(oHenchman));
			if (sHenchmanTag == GetTag(oHenchman))
					return oHenchman;
		}
	}
	return OBJECT_INVALID;
}




// Removes henchman with specified tag if found
int SCRemoveHenchmanByTag(object oPC, string sHenchmanTag = "")
{
    object oHenchman = SCGetHenchmanByTag(oPC, sHenchmanTag);

    if (GetIsObjectValid(oHenchman))
    {
        RemoveHenchman(oPC, oHenchman);
		AssignCommand(oHenchman, ClearAllActions(TRUE)); // needed to get rid of autofollow
		return TRUE;
    }
	return FALSE;
}		
















// makes RosterMember appear at his designated hangout
void SCSpawnNonPartyRosterMemberAtHangout(string sRMRosterName)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSpawnNonPartyRosterMemberAtHangout Start", GetFirstPC() ); }
	
	// if RM doesn't exist (will exist if in party)
	if (GetIsObjectValid(GetObjectFromRosterName(sRMRosterName)) == FALSE)
	{
		//PrettyDebug(" - Object deosn't exist");
		// is current hang out spot to be found in this module?
		object oHangOut = SCGetHangoutObject(sRMRosterName);
		if (GetIsObjectValid(oHangOut) == TRUE)
		{
			//PrettyDebug(" - Hangout location found, spawning " + sRMRosterName);
			location lHangOut = GetLocation(oHangOut);
			object oRM = SpawnRosterMember(sRMRosterName, lHangOut);
			//if (!GetIsObjectValid(oRM))
			//{
				//PrettyError("Failed in spawn " + sRMRosterName + " from roster." );
			//}
			return;
		}
	}
	//PrettyDebug(" - " + sRMRosterName + " not spawned from roster." );

}

// 
void SCGoToHangOutSpot(string sRosterName)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGoToHangOutSpot Start", GetFirstPC() ); }
	
	object oRM = GetObjectFromRosterName(sRosterName);
	string sName = GetName(oRM);
	if (!GetIsObjectValid(oRM))	
	{ // no roster member instance available, so attempt to spawn in.
		SCSpawnNonPartyRosterMemberAtHangout(sRosterName);
		return;
	}
	
	// remove RM from party.
	object oPC = CSLGetCurrentMaster(oRM);
	int bDespawnNPC=FALSE; // wait till later to determine whether we should despawn.
	RemoveRosterMemberFromParty( sRosterName, oPC, bDespawnNPC);
	
	
	// move or despawn RM as needed to go to hangout.
	object oHangOut = SCGetHangoutObject(sRosterName);
	if (!GetIsObjectValid(oHangOut))	
	{ // hangout is not in this module, despawn and let module load take care of it.

		DespawnRosterMember( sRosterName );
	} 
	else if (GetArea(oHangOut) == GetArea(oRM))
	{	// if in same area, walk to spot
    	AssignCommand(oRM, ClearAllActions(TRUE));
    	AssignCommand(oRM, ActionForceMoveToObject(oHangOut));
	}
	else
	{ // jump to hang out spot in another area.
    	AssignCommand(oRM, ClearAllActions(TRUE));
    	AssignCommand(oRM, ActionJumpToObject(oHangOut));
	}
}	


// Despawn all companions in oPC's party (faction)
void SCDespawnAllCompanions(object oPC)
{
	object oFM = GetFirstFactionMember(oPC, FALSE);
	string sRosterName;
	while (GetIsObjectValid(oFM) == TRUE)
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		PrintString("SC DespawnAllCompanions: "+GetName(oFM));
		if (GetIsRosterMember(oFM) == TRUE)
		{
			sRosterName = GetRosterNameFromObject(oFM);
			DespawnRosterMember(sRosterName);
			oFM = GetFirstFactionMember(oPC, FALSE);
		}
		else
		{
			oFM = GetNextFactionMember(oPC, FALSE);
		}
	}
}


// Check if oMember is in first PC's party (faction)
int SCGetIsObjectInParty(object oMember)
{
	return (GetFactionEqual(oMember, GetFirstPC()));
}

// Despawn all roster members in module. Option bExcludeParty=TRUE to ignore party members.
// Useful to update roster state before a module transition.
void SCDespawnAllRosterMembers(int bExcludeParty=FALSE)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCDespawnAllRosterMembers Start", GetFirstPC() ); }
	
	object oMember;
	string sRosterID = GetFirstRosterMember();

	// For each roster ID
	while (sRosterID != "")
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		oMember = GetObjectFromRosterName(sRosterID);
		
		// If they're in the game
		if (GetIsObjectValid(oMember) == TRUE)
		{
			// And in my party
			if (SCGetIsObjectInParty(oMember) == TRUE)
			{
				if (bExcludeParty == FALSE)
				{
					RemoveRosterMemberFromParty(sRosterID, GetFirstPC(), TRUE);
				}
			}
			else
			{
				DespawnRosterMember(sRosterID);
			}
		}
	
		sRosterID = GetNextRosterMember();
	}
}
	
// Remove all selectable roster members from oPC's party
// - bIgnoreSelectable: If TRUE, also despawn non-Selectable roster members
void SCRemoveRosterMembersFromParty( object oPC, int bDespawnNPC=TRUE, int bIgnoreSelectable=FALSE )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCRemoveRosterMembersFromParty Start", GetFirstPC() ); }
	
	string sRosterName;
		
	// For each party member
	object oMember = GetFirstFactionMember( oPC, FALSE );
	while ( GetIsObjectValid( oMember ) == TRUE )
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		sRosterName = GetRosterNameFromObject( oMember );

		// If party member is a roster member	
		if ( sRosterName != "" )
		{
			// And party member is not required
			if ( ( bIgnoreSelectable ) || ( GetIsRosterMemberSelectable( sRosterName ) == TRUE ) )
			{
				// If party member is controlled by a PC
				if ( GetIsPC( oMember ) == TRUE )
				{
					// Force PC into original character
					SetOwnersControlledCompanion( oMember );
				}		
				
				RemoveRosterMemberFromParty( sRosterName, oPC, bDespawnNPC );
				oMember = GetFirstFactionMember( oPC, FALSE );
			}
			else
			{
				oMember = GetNextFactionMember( oPC, FALSE );
			}
		}
		else
		{
			oMember = GetNextFactionMember( oPC, FALSE );
		}
	}	
}

	
// Despawn non-party roster members and save module state before transitioning to a new module
// - sModuleName: Name of module to load
// - sWaypoint: Optional starting point for party
void SCSaveRosterLoadModule( string sModuleName, string sWaypoint="" )
{
	// Save non-party roster member states
	SCDespawnAllRosterMembers( TRUE );
	LoadNewModule( sModuleName, sWaypoint );
}





// Set player queued action local var to bQueued
void SCSetHasPlayerQueuedAction( object oCharacter, int bQueued )
{
	SetLocalInt( oCharacter, "N2_PLAYER_QUEUED_ACTION", bQueued );
}



// Sets oCharacter's preferred attack target to oTarget
void SCSetPlayerQueuedTarget( object oCharacter, object oTarget )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetPlayerQueuedTarget Start", GetFirstPC() ); }
	
	SetLocalObject( oCharacter, "N2_PLAYER_QUEUED_TARGET", oTarget );
}



// Stores attempted attack target as preferred attack target
// Used for SC HenchmenCombatRound() to prevent smashing player queued attacks
// * GetAttemptedAttackTarget() returns caller's ACTION_ATTACKOBJECT target
void SCStorePlayerQueuedTarget( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCStorePlayerQueuedTarget Start", GetFirstPC() ); }
	
	object oTarget = GetAttemptedAttackTarget();
	SCSetPlayerQueuedTarget( oCharacter, oTarget );
}



// User defined event handler for unpossessing a party member
// Queue player queued action lock to circumvent SC DetermineCombatRound()
void SCPlayerControlUnpossessed( object oCharacter )
{
	
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCPlayerControlUnpossessed Start", GetFirstPC() ); }
	//PrettyDebug( "ginc_companion: " + GetName( oCharacter ) + " has been unpossessed (EVENT_PLAYER_CONTROL_CHANGED)." );

 	if (GetIsOwnedByPlayer(oCharacter))  
	{
		ExecuteScript("gr_pc_spawn", oCharacter);
	}

	if ( GetCommandable( oCharacter ) == TRUE )
	{
		// BMA-OEI 9/13/06: Clear or save preferred attack target
		AssignCommand( oCharacter, SCStorePlayerQueuedTarget() );
	
		SCSetHasPlayerQueuedAction( oCharacter, TRUE );
		AssignCommand( oCharacter, ActionDoCommand( SCSetHasPlayerQueuedAction( oCharacter, FALSE ) ) );		
	}	
	
}


// Return value of player queued action local var
// Used to prevent SC DetermineCombatRound() clearing actions queued during player possession
int SCGetHasPlayerQueuedAction( object oCharacter )
{
	int nPlot = GetLocalInt(oCharacter, "NW_GENERIC_MASTER");
    if(nPlot & CSL_FLAG_BUSYMOVING) // this is a special queue forcing a creature to go somewhere
    {
    	return TRUE;
    }
	
	int bQueued = GetLocalInt( oCharacter, "N2_PLAYER_QUEUED_ACTION" );
	int nAction = GetCurrentAction( oCharacter );
	
	// Safety: If following, attacking, or no more actions in queue
	if ( ( nAction == ACTION_FOLLOW ) || ( nAction == ACTION_ATTACKOBJECT ) || ( GetNumActions( oCharacter ) == 0 ) )
	{
		bQueued = FALSE;
	}
	

	return ( bQueued );
}

// Return's oCharacter's preferred attack target
// Used in SC HenchmenCombatRound() to prevent smashing player queued attacks
object SCGetPlayerQueuedTarget( object oCharacter )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetPlayerQueuedTarget Start", GetFirstPC() ); }
	
	object oTarget = GetLocalObject( oCharacter, "N2_PLAYER_QUEUED_TARGET" );
	return ( oTarget );
}



void SCSetHenchOption(int nCondition, int bValid)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetHenchOption Start", GetFirstPC() ); }
    
    int nPlot = GetGlobalInt("HENCH_GLOBAL_OPTIONS");
    if(bValid)
    {
        nPlot = nPlot | nCondition;
    }
    else
    {
        nPlot = nPlot & ~nCondition;
    }
    SetGlobalInt("HENCH_GLOBAL_OPTIONS", nPlot);
}


int SCGetHenchOption(int nSel)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetHenchOption Start", GetFirstPC() ); }
	
	int nResult = GetGlobalInt("HENCH_GLOBAL_OPTIONS");
	if (!nResult)
	{
		nResult = GetCampaignInt(HENCH_CAMPAIGN_DB, "HENCH_GLOBAL_OPTIONS");
		nResult |= HENCH_OPTION_SET_ONCE;
    	SetGlobalInt("HENCH_GLOBAL_OPTIONS", nResult);
	}
	return nResult & nSel;
}


// prevent heartbeat detection of enemies
int SCGetUseHeartbeatDetect( object oCharacter = OBJECT_SELF )
{
	return !(GetPlotFlag(oCharacter) || IsInMultiplayerConversation(GetFirstPC()));
}


float SCGetDispelChance(object oCreator)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetDispelChance Start", GetFirstPC() ); }
	
	if (GetIsObjectValid(oCreator))
	{
		//if ( !GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL")	)
		//{
		//	return 0;
		//}
		
		
		int nCasterLevel = GetCasterLevel(oCreator);	// this isn't always accurate (reset every spell)	
		if (nCasterLevel <= 0)
		{
			nCasterLevel = GetHitDice(oCreator);
		}	
		return SCGetd20Chance(giBestDispelCastingLevel - nCasterLevel - 11);
	}
	return SCGetd20Chance(giBestDispelCastingLevel - 21 /* 10 - 11 */);
}



float SCGetRawThreatRating(object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 20) { CSLDebug(  "SCGetRawThreatRating Start "+GetName(oTarget), GetFirstPC() ); }
    
    int lastTestHitDice = GetLocalInt(oTarget, "HenchThreatRating");
    int hitDice = GetHitDice(oTarget);
    float fThreat;
    if (GetHitDice(oTarget) == lastTestHitDice)
    {
        fThreat = GetLocalFloat(oTarget, "HenchThreatRating");
    }
    else
    {
        fThreat = IntToFloat(GetHitDice(oTarget));
        fThreat = pow(1.5, fThreat * HENCH_HITDICE_TO_CR);
        int iAssocType = GetAssociateType(oTarget);
        if (iAssocType == ASSOCIATE_TYPE_FAMILIAR)
        {
            fThreat *= 0.1;
        }
        else if (iAssocType != ASSOCIATE_TYPE_NONE && iAssocType != ASSOCIATE_TYPE_HENCHMAN)
        {
            fThreat *= 0.8;
        }
        if ((GetLevelByClass(CLASS_TYPE_WIZARD, oTarget) >= 5) || (GetLevelByClass(CLASS_TYPE_SORCERER, oTarget) >= 6))
        {
            fThreat *= 1.3;
        }
        else if ((GetLevelByClass(CLASS_TYPE_DRAGON, oTarget) >= 11))
        {
            // dragons are extra tough
            fThreat *= 1.5;
        }
        if (fThreat < 0.001)
        {
            fThreat = 0.001;
        }
        SetLocalFloat(oTarget, "HenchThreatRating", fThreat);
        SetLocalInt(oTarget, "HenchThreatRating", hitDice);
    }
    //DEBUGGING// if (DEBUGGING >= 20) { CSLDebug(  "SCGetRawThreatRating End", GetFirstPC() ); }
    return fThreat;
}





float SCGetThreatRating(object oTarget, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 20) { CSLDebug(  "SCGetThreatRating Start "+GetName(oTarget), GetFirstPC() ); }
    
    if (oTarget == oCharacter)
    {
         //DEBUGGING// if (DEBUGGING >= 20) { CSLDebug(  "SCGetThreatRating oTarget == oCharacter", GetFirstPC() ); }
        return gfAdjustedThreatRating;
    }
    float fThreat = SCGetRawThreatRating(oTarget);
    if (giSpecialTargeting)
    {
        if (giSpecialTargeting & HENCH_SPECIAL_TARGETING_SINGLE)
        {
            if (oTarget == goOverrideTarget)
            {
                //DEBUGGING// if (DEBUGGING >= 20) { CSLDebug(  "SCGetThreatRating (oTarget == goOverrideTarget)", GetFirstPC() ); }
                return fThreat;
            }
            //DEBUGGING// if (DEBUGGING >= 20) { CSLDebug(  "SCGetThreatRating return 0.0", GetFirstPC() ); }
            return 0.0;
        }
        else if (GetIsEnemy(oTarget))
        {
/*            if (giSpecialTargeting & HENCH_SPECIAL_TARGETING_RACE)
            {
                if (GetRacialType(oTarget) == x)
                {
                    fThreat *= 2;
                }
            }
            if (giSpecialTargeting & HENCH_SPECIAL_TARGETING_CLASS)
            {

            } */
        }
    }
    if (oTarget == goOverrideTarget)
    {
        fThreat *= gfOverrideTargetWeight;
    }
     //DEBUGGING// if (DEBUGGING >= 20) { CSLDebug(  "SCGetThreatRating End", GetFirstPC() ); }
    return fThreat;
}



// Jugalator Script Additions
// Return 1 if target is enhanced with a beneficial
// spell that can be dispelled (= from a spell script), 2 if the
// effects can be breached, 0 otherwise.
// TK changed to not look for magical effects only
struct sEnhancementLevel SCGetHasBeneficialEnhancement(object oTarget, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetHasBeneficialEnhancement Start "+GetName(oTarget), GetFirstPC() ); }
	
	struct sEnhancementLevel result;
    effect eCheck = GetFirstEffect(oTarget);
	int lastSpellId = -1;
	int bCheckDispel = gsBestDispel.spellID > 0;
	int bCheckBreach = gsBestBreach.spellID > 0;
	
	if ( GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL")	)
	{
		bCheckDispel = FALSE;
		bCheckBreach = FALSE;
	}
	
    while (GetIsEffectValid(eCheck))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		int iType = GetEffectType(eCheck);
		if ((iType != EFFECT_TYPE_VISUALEFFECT) && (GetEffectSubType(eCheck) == SUBTYPE_MAGICAL))
		{
			if (bCheckBreach)
			{
				int iSpell = GetEffectSpellId(eCheck);
				if (iSpell != lastSpellId)
				{
					lastSpellId = iSpell;
					switch(iSpell)
					{
						case SPELL_ETHEREALNESS: // greater sanctuary
						case SPELL_GREATER_SPELL_MANTLE:
						case SPELL_SPELL_MANTLE:
						case SPELL_PREMONITION:
						case SPELL_SHADOW_SHIELD:
						case SPELL_GREATER_STONESKIN:
						case SPELL_STONESKIN:
						case SPELL_ETHEREAL_VISAGE:
						case SPELLR_MESTILS_ACID_SHEATH:
						case SPELL_LEAST_SPELL_MANTLE:
						case SPELL_MIND_BLANK:
						case SPELL_LESSER_MIND_BLANK:
						case SPELL_PROTECTION_FROM_SPELLS:
							result.breach = HENCH_MAX_ENCHANTMENT_WEIGHT;
							bCheckBreach = FALSE;
							break;
						case SPELL_GLOBE_OF_INVULNERABILITY:
						case SPELL_ENERGY_BUFFER:
						case SPELL_LESSER_GLOBE_OF_INVULNERABILITY:
						case SPELL_SPELL_RESISTANCE:
						case SPELL_LESSER_SPELL_MANTLE:
						case SPELL_ELEMENTAL_SHIELD:
						case SPELL_PROTECTION_FROM_ENERGY:
						case SPELL_RESIST_ENERGY:
						case SPELL_DEATH_ARMOR:
							result.breach += 0.2;
							if (result.breach >= HENCH_MAX_ENCHANTMENT_WEIGHT)
							{
								result.breach = HENCH_MAX_ENCHANTMENT_WEIGHT;
								bCheckBreach = FALSE;
							}
							break;
						case SPELL_GHOSTLY_VISAGE:
						case SPELL_ENDURE_ELEMENTS:
						case SPELL_SHADOW_CONJURATION_MAGE_ARMOR:
						case SPELL_SANCTUARY:
						case SPELL_MAGE_ARMOR:
						case SPELL_SHIELD:
						case SPELL_SHIELD_OF_FAITH:
						case SPELL_RESISTANCE:
							result.breach += 0.1;
							if (result.breach >= HENCH_MAX_ENCHANTMENT_WEIGHT)
							{
								result.breach = HENCH_MAX_ENCHANTMENT_WEIGHT;
								bCheckBreach = FALSE;
							}
							break;
					}
				}
			}
			
			if (bCheckDispel)
			{
				// Found an effect applied by a spell script - check the effect type
				switch(iType)
				{
				case EFFECT_TYPE_VISUALEFFECT:	// this effect is very common, don't check everything
					break;
				case EFFECT_TYPE_REGENERATE:
				case EFFECT_TYPE_SANCTUARY:
				case EFFECT_TYPE_IMMUNITY:
				case EFFECT_TYPE_INVULNERABLE:
				case EFFECT_TYPE_HASTE:
				case EFFECT_TYPE_ELEMENTALSHIELD:
				case EFFECT_TYPE_SPELL_IMMUNITY:
				case EFFECT_TYPE_SPELLLEVELABSORPTION:
				case EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE:
				case EFFECT_TYPE_DAMAGE_INCREASE:
				case EFFECT_TYPE_DAMAGE_REDUCTION:
				case EFFECT_TYPE_DAMAGE_RESISTANCE:
				case EFFECT_TYPE_POLYMORPH:
				case EFFECT_TYPE_ETHEREAL:
				case EFFECT_TYPE_INVISIBILITY:
				case EFFECT_TYPE_ABSORBDAMAGE:
					if (result.dispel < HENCH_MAX_ENCHANTMENT_WEIGHT)
					{
						result.dispel += 0.5 * SCGetDispelChance(GetEffectCreator(eCheck));
						if (result.dispel >= HENCH_MAX_ENCHANTMENT_WEIGHT)
						{
							result.dispel = HENCH_MAX_ENCHANTMENT_WEIGHT;
							bCheckDispel = FALSE;
						}
					}
					break;
				case EFFECT_TYPE_ABILITY_INCREASE:
				case EFFECT_TYPE_AC_INCREASE:
				case EFFECT_TYPE_ATTACK_INCREASE:
				case EFFECT_TYPE_CONCEALMENT:
				case EFFECT_TYPE_ENEMY_ATTACK_BONUS:
				case EFFECT_TYPE_MOVEMENT_SPEED_INCREASE:
				case EFFECT_TYPE_SAVING_THROW_INCREASE:
				case EFFECT_TYPE_SEEINVISIBLE:
				case EFFECT_TYPE_SKILL_INCREASE:
				case EFFECT_TYPE_SPELL_RESISTANCE_INCREASE:
				case EFFECT_TYPE_TEMPORARY_HITPOINTS:
				case EFFECT_TYPE_TRUESEEING:
				case EFFECT_TYPE_ULTRAVISION:
				case EFFECT_TYPE_MAX_DAMAGE:
				case EFFECT_TYPE_BONUS_HITPOINTS:
					if (result.dispel < HENCH_MAX_ENCHANTMENT_WEIGHT)
					{
						result.dispel += 0.1 * SCGetDispelChance(GetEffectCreator(eCheck));
						if (result.dispel >= HENCH_MAX_ENCHANTMENT_WEIGHT)
						{
							result.dispel = HENCH_MAX_ENCHANTMENT_WEIGHT;
							bCheckDispel = FALSE;
						}
					}
					break;
/*				case EFFECT_TYPE_PARALYZE:
				case EFFECT_TYPE_STUNNED:
				case EFFECT_TYPE_FRIGHTENED:
				case EFFECT_TYPE_SLEEP:
				case EFFECT_TYPE_DAZED:
				case EFFECT_TYPE_CONFUSED:
				case EFFECT_TYPE_TURNED:
				case EFFECT_TYPE_PETRIFY:
				case EFFECT_TYPE_CUTSCENEIMMOBILIZE:
				case EFFECT_TYPE_MESMERIZE:
					{
							// if disabled don't dispel
						struct sEnhancementLevel noResult;
						return noResult;
					} */
				}
			}
		}
        eCheck = GetNextEffect(oTarget);
    }
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetHasBeneficialEnhancement calling SCGetThreatRating", GetFirstPC() ); }
	float targetWeight = SCGetThreatRating(oTarget, oCharacter);
	result.breach *= targetWeight;	
	result.dispel *= targetWeight;	
	
	if (bCheckDispel)
	{
			// check if target has summons
		object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oTarget);
		if (GetIsObjectValid(oSummon))
		{
		//    if (GetTag(oSummon) != "X2_S_DRGRED001" && GetTag(oSummon) != "X2_S_MUMMYWARR")
			{
				result.dispel += SCGetDispelChance(oTarget) * SCGetThreatRating(oSummon, oCharacter);
				if (result.dispel >= HENCH_MAX_ENCHANTMENT_WEIGHT * targetWeight)
				{
					result.dispel = HENCH_MAX_ENCHANTMENT_WEIGHT * targetWeight;
				}
			}
		}
	}
	return result;
}




int SCGetCreatureUseItems(object oCharacter)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetCreatureUseItems Start", GetFirstPC() ); }
    
    if (GetIsPlayableRacialType(oCharacter))
    {
        return TRUE;
    }
    int nAppearanceType = GetAppearanceType(oCharacter);
    string sUseItemsSizeStr = "HENCH_AI_USE_ITEMS_" + IntToString(nAppearanceType);
    object oModule = GetModule();
    int useItems = GetLocalInt(oModule, sUseItemsSizeStr);
    if (useItems == 0)
    {
        if ((GetRacialType(oCharacter) == RACIAL_TYPE_DRAGON) || (nAppearanceType == 1011))
        {
            useItems = 1;
        }
        else
        {
            useItems = StringToInt(Get2DAString("appearance", "BodyType", nAppearanceType)) > 0 ? 2 : 1;
            SetLocalInt(oModule, sUseItemsSizeStr, useItems);
        }
    }
    return useItems > 1;
}


int SCGetCreatureHasItemProperty(int nItemProperty, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetCreatureHasItemProperty Start", GetFirstPC() ); }
    
    int i;
    for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        object oItem = GetItemInSlot(i, oCharacter);
        if(GetItemHasItemProperty(oItem, nItemProperty))
        {
            return TRUE;
        }
    }
    return FALSE;
}






int SCHenchGetAoESpellInfo(object oAreaOfEffect)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetAoESpellInfo Start", GetFirstPC() ); }
	
	int result = GetLocalInt(oAreaOfEffect, "HenchPersistTag");
	if (result & HENCH_PERSIST_SPELL_FLAG)
	{
		return result;
	}
	object oModule = GetModule();
	int spellID = GetAreaOfEffectSpellId(oAreaOfEffect);
	if (spellID > 0)
	{	
		result = GetLocalInt(oModule, "HenchPersistSpellID" + IntToString(spellID));
	}
	if (!result)
	{		
		string sTag = GetTag(oAreaOfEffect);
		result = GetLocalInt(oModule, "HenchPersistTag" + sTag);
		if (!result)
		{
			result = HENCH_PERSIST_SPELL_FLAG;
			object oCreator = GetAreaOfEffectCreator(oAreaOfEffect);
			if (GetIsObjectValid(oCreator))
			{
				int iStrLen = GetStringLength(sTag) - GetStringLength(ObjectToString(oCreator));
				if (iStrLen > 0)
				{	
					string sLookup = GetStringRight(sTag, iStrLen);
					result = GetLocalInt(oModule, "HenchPersistSpellID" + sLookup);
				}
			}
		}
		if (result & HENCH_PERSIST_CHECK_HEARTBEAT)
		{
			sTag = GetStringLowerCase(GetEventHandler(oAreaOfEffect, SCRIPT_AOE_ON_HEARTBEAT));
			int testResult = GetLocalInt(oModule, "HenchPersistTag" + sTag);
			if (testResult)
			{
				result = testResult;
			}
		}
	}
	SetLocalInt(oAreaOfEffect, "HenchPersistTag", result);
	return result;
}





object SCHenchGetAOEProblem(int currentNegEffects, int currentPosEffects, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCHenchGetAOEProblem Start", GetFirstPC() ); }
	
	int bCheckFriendsAOE = GetGameDifficulty() >= GAME_DIFFICULTY_CORE_RULES;
	object oArea = GetArea(oCharacter);
	object oAOE = GetFirstSubArea(oArea,  GetPosition(oCharacter)); 
	int curLoopCount = 0;
	int iteration = 0;
	int iCachedDamageInfo;
	while ( GetIsObjectValid(oAOE) && curLoopCount <= 10  && iteration < 8 )
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		if (GetObjectType(oAOE) == OBJECT_TYPE_AREA_OF_EFFECT)
		{
			//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCHenchGetAOEProblem AOE Loop Start", GetFirstPC() ); }
			curLoopCount++;
			object oAOECreator = GetAreaOfEffectCreator(oAOE);
			int bFriendsAOE;
			if (GetObjectType( oAOECreator ) != OBJECT_TYPE_CREATURE)
			{
				oAOECreator = OBJECT_INVALID;
			}
			else
			{
				bFriendsAOE = GetFactionEqual(oAOECreator) || GetIsFriend(oAOECreator);
			}
			if (bCheckFriendsAOE || !bFriendsAOE)
			{
				int persistSpellFlags = SCHenchGetAoESpellInfo(oAOE);
				if ((persistSpellFlags & HENCH_PERSIST_HARMFUL) && (!bFriendsAOE || (bCheckFriendsAOE && (persistSpellFlags & HENCH_PERSIST_UNFRIENDLY))) && (persistSpellFlags & (HENCH_PERSIST_CAN_DISPEL | HENCH_PERSIST_MOVE_AWAY)))
				{
					iteration++;
					int nSpellID = persistSpellFlags & HENCH_PERSIST_SPELL_MASK;					
					// check damage				
					int nSpellInformation = SCGetSpellInformation(nSpellID);
					int damageInfo = SCGetCurrentSpellDamageInfo() & HENCH_SPELL_INFO_DAMAGE_TYPE_MASK;				
					if ( damageInfo )
					{
						//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCHenchGetAOEProblem calling SCGetCurrentSpellDamage", GetFirstPC() ); }
						struct sDamageInformation spellDamage = SCGetCurrentSpellDamage( GetCasterLevel(oAOECreator), FALSE);					
						float currentDamageAmount = spellDamage.amount;
	
						if (spellDamage.numberOfDamageTypes == 1)
						{								
							currentDamageAmount = SCGetDamageResistImmunityAdjustment(oCharacter, currentDamageAmount, spellDamage.damageType1, spellDamage.count);					
						}
						else
						{							
							currentDamageAmount = SCGetDamageResistImmunityAdjustment(oCharacter, currentDamageAmount / 2, spellDamage.damageType1, spellDamage.count) + SCGetDamageResistImmunityAdjustment(oCharacter, currentDamageAmount / 2, spellDamage.damageType2, spellDamage.count);					
						}
						
						if (SCCalculateDamageWeight(currentDamageAmount, oCharacter) > 0.33)
						{
							return oAOE;
						}
					}					
					// check negative effects
					int effectTypes = SCGetCurrentSpellEffectTypes();					
					if (effectTypes & HENCH_EFFECT_TYPE_SILENCE)
					{
						if (GetLevelByClass(CLASS_TYPE_WIZARD) > 3 || GetLevelByClass(CLASS_TYPE_SORCERER) > 4 || GetLevelByClass(CLASS_TYPE_BARD) > 3)
						{
							return oAOE;
						}
					}
					else if (effectTypes)
					{
						if ((nSpellID == SPELL_CLOUDKILL) && (GetHitDice(oCharacter) < 7))
						{						
							effectTypes = HENCH_EFFECT_TYPE_DEATH;
						}
						if ((effectTypes & ~HENCH_EFFECT_IMPAIRED) == 0)
						{
							if (currentNegEffects & effectTypes)
							{
								return oAOE;
							}
						}
						else
						{					
							int saveType = SCGetCurrentSpellSaveType();
							int immunity1 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK) >> 6;
							int immunity2 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY2_MASK) >> 12;
							int immunityMind = saveType & HENCH_SPELL_SAVE_TYPE_MIND_SPELL_FLAG;
							
							switch (nSpellID)
							{
								case SPELL_CLOUDKILL:
									if (GetHitDice(oCharacter) < 7)
									{						
										immunity2 = IMMUNITY_TYPE_DEATH;
									}
									else
									{
										immunity2 = IMMUNITY_TYPE_ABILITY_DECREASE;
									}
									break;
								case SPELL_GHOUL_TOUCH:
									immunityMind = FALSE;
									immunity1 = IMMUNITY_TYPE_POISON;
									break;
							}
							int bDoAction;
							
							if (immunityMind && GetIsImmune(oCharacter, IMMUNITY_TYPE_MIND_SPELLS, oAOECreator))
							{
							}
							else if (immunity2)
							{
								if (!(GetIsImmune(oCharacter, immunity1, oAOECreator) ||
									GetIsImmune(oCharacter, immunity2, oAOECreator)))
								{
									bDoAction = TRUE;
								}
							}
							else if (immunity1)
							{					
								if (!GetIsImmune(oCharacter, immunity1, oAOECreator))
								{
									bDoAction = TRUE;
								}
							}
							else
							{
								bDoAction = TRUE;
							}
							if (bDoAction)
							{
								return oAOE;					
							}
						}
					}
				}
			}
			//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchGetAOEProblem AOE END", GetFirstPC() ); }
		}
		oAOE = GetNextSubArea(oArea); 
	}
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchGetAOEProblem End", GetFirstPC() ); }
	return OBJECT_INVALID;
}




void SCHenchCheckDispel( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckDispel Start", GetFirstPC() ); }
	
	int damageInfo = SCGetCurrentSpellDamageInfo();
	if (damageInfo & HENCH_SPELL_INFO_DAMAGE_BREACH)
	{
		if ((gsCurrentspInfo.spellLevel > gsBestBreach.spellLevel) || 
			((gsCurrentspInfo.spellLevel == gsBestBreach.spellLevel) &&
			(gsBestBreach.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) &&
			!(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG)))
		{
			gsBestBreach = gsCurrentspInfo;		
		}	
	}	
	if (damageInfo & HENCH_SPELL_INFO_DAMAGE_DISPEL)
	{
		if ((gsCurrentspInfo.spellLevel > gsBestDispel.spellLevel) || 
			((gsCurrentspInfo.spellLevel == gsBestDispel.spellLevel) &&
			(gsBestDispel.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) &&
			!(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG)))
		{
			gsBestDispel = gsCurrentspInfo;
			if (gsBestDispel.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG)
			{
				giBestDispelCastingLevel = gsBestDispel.spellLevel * 2 - 1;
			}
			else
			{			
				int maxCasterLevel = (HENCH_SPELL_INFO_DAMAGE_LEVEL_LIMIT_MASK & damageInfo) >> 20;
				if (maxCasterLevel > 0)
				{
					maxCasterLevel *= 5;
					if (giMySpellCasterLevel > maxCasterLevel)
					{
						giBestDispelCastingLevel = maxCasterLevel;
					}	
					else
					{
						giBestDispelCastingLevel = giMySpellCasterLevel;
					}
				}
				else
				{
					giBestDispelCastingLevel = giMySpellCasterLevel;
				}
			}							
		}	
	}
	if (damageInfo & HENCH_SPELL_INFO_DAMAGE_RESIST)
	{
		int reductionLevel = (HENCH_SPELL_INFO_DAMAGE_AMOUNT_MASK & damageInfo) >> 12;

		if ((reductionLevel > giBestSpellResistanceReduction) ||
			((reductionLevel == giBestSpellResistanceReduction) && (gsCurrentspInfo.spellLevel > gsSpellResistanceReduction.spellLevel)))
		{
			giBestSpellResistanceReduction = reductionLevel;
			gsSpellResistanceReduction = gsCurrentspInfo;
		}	
	}	
}


// if object specified, make sure in range of dispel
// try to minimize friendly targets in dispel area

location SCFindBestDispelLocation(object oAOEProblem = OBJECT_INVALID, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCFindBestDispelLocation Start", GetFirstPC() ); }
    
    location testTargetLoc;
    int curLoopCount = 1;
    object oTestTarget;
    int extraEnemyCount;
    object oResultTarget = OBJECT_INVALID;
    globalBestEnemyCount = -100;
    int bFoundTargetObject;
    int bHasAOEProblem = GetIsObjectValid(oAOEProblem);
    int bFoundAnyTarget;

    object oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, 1);
    while (GetIsObjectValid(oTarget) && curLoopCount <= 10 && GetDistanceToObject(oTarget) <= 9.0)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        testTargetLoc = GetLocation(oTarget);
        extraEnemyCount = 0;
        bFoundTargetObject = FALSE;
        bFoundAnyTarget = FALSE;

        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        oTestTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTestTarget))
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            if (GetObjectType(oTestTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                if (oTestTarget == oAOEProblem)
                {
                    bFoundTargetObject = TRUE;
                }
                if (GetStringLeft(GetTag(oTestTarget), 8) == "VFX_PER_")
                {
                    if (GetIsEnemy(GetAreaOfEffectCreator(oTestTarget)))
                    {
                        bFoundAnyTarget = TRUE;
                        extraEnemyCount ++;
                    }
                    else if (GetFactionEqual(GetAreaOfEffectCreator(oTestTarget)) || GetIsFriend(GetAreaOfEffectCreator(oTestTarget)))
                    {
                        if (!bHasAOEProblem)
                        {
                            extraEnemyCount = -100;
                            break;
                        }
                        extraEnemyCount --;
                    }
                }
            }
            else
            {
                    // TODO SC GetHasBeneficialEnhancement removed because too many instruction error
                if (GetIsEnemy(oTestTarget) /* && SC GetHasBeneficialEnhancement(oTestTarget) */)
                {
                    extraEnemyCount ++;
                }
                else if (GetFactionEqual(oTestTarget) || GetIsFriend(oTestTarget) /* && SC GetHasBeneficialEnhancement(oTestTarget) */)
                {
                    extraEnemyCount --;
                }
            }
            //Select the next target within the spell shape.
            oTestTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
        }
        if (bFoundTargetObject || (!bHasAOEProblem && bFoundAnyTarget))
        {
            if (extraEnemyCount > globalBestEnemyCount)
            {
                globalBestEnemyCount = extraEnemyCount;
                oResultTarget = oTarget;
            }
        }
        curLoopCount ++;
        oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, curLoopCount);
    }
    if (globalBestEnemyCount < 0)
    {
        return GetLocation(oAOEProblem);
    }
    return GetLocation(oResultTarget);
}





int SCGetCreaturePosEffects(object oTarget,object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 12) { CSLDebug(  "SCGetCreaturePosEffects Start "+GetName(oTarget), GetFirstPC() ); }
    
    if (SCAIIsCachedCreatureInformationExpired(oTarget,oCharacter))
    {
        SCAIInitCachedCreatureInformation(oTarget);
    }
    return GetLocalInt(oTarget, "HenchCurPosEffects");
}

int SCGetCreatureNegEffects(object oTarget,object oCharacter = OBJECT_SELF)
{
    //int iOldDebugging = DEBUGGING;
	////DEBUGGING// if (DEBUGGING > 8 && DEBUGGING < 10) { DEBUGGING = 12; }
    
    //DEBUGGING// if (DEBUGGING >= 12) { CSLDebug(  "SCGetCreatureNegEffects Start "+GetName(oTarget), GetFirstPC() ); }
    
    if (SCAIIsCachedCreatureInformationExpired(oTarget,oCharacter))
    {
        SCAIInitCachedCreatureInformation(oTarget);
    }
    //DEBUGGING = iOldDebugging;
    return GetLocalInt(oTarget, "HenchCurNegEffects");
}



void SCHenchGetBestDispelTarget( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetBestDispelTarget Start", GetFirstPC() ); }
	
	if ((gsBestBreach.spellID <= 0) && (gsBestDispel.spellID <= 0))
	{
		return;
	}
	
	float fMaxWeight;
	object oBestTarget;
	int bUseBreach;
	
    if ((gsBestDispel.spellID > 0) && !gbDisabledAllyFound && !GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL"))
    {
		object oFriend;
		int iLoopLimit;

		if (!gbDisableNonHealorCure)
		{
			iLoopLimit = 7;
			int curLoopCount = 1;
			oFriend = GetLocalObject(oCharacter, "HenchObjectSeen");
			while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
			{
				//DEBUGGING// igDebugLoopCounter += 1;
				if (SCGetCreatureNegEffects(oFriend) & HENCH_EFFECT_TYPE_DOMINATED)
				{
					int bFound;
                    effect eEffect = GetFirstEffect(oFriend);
                    //DEBUGGING// igDebugLoopCounter += 1;
                    while (GetIsEffectValid(eEffect))
                    {
                        if (GetEffectType(eEffect) == EFFECT_TYPE_DOMINATED)
                        {
                            if (GetEffectSubType(eEffect) == SUBTYPE_MAGICAL)
                            {
                                bFound = TRUE;
                            }
                            break;
                        }
                        eEffect = GetNextEffect(oFriend);
                    }
					if (bFound)
					{
						//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetBestDispelTarget calling SCGetThreatRating", GetFirstPC() ); }
						fMaxWeight = SCGetThreatRating(oFriend, oCharacter) * 2.0 * SCGetDispelChance(GetEffectCreator(eEffect));
						oBestTarget = oFriend;
					}
				} 
				oFriend = GetLocalObject(oFriend, "HenchObjectSeen");	
			}
			if (GetIsObjectValid(goCharmedAlly))
			{			
				int bFound;
				effect eEffect = GetFirstEffect(goCharmedAlly);
				while (GetIsEffectValid(eEffect))
				{
					//DEBUGGING// igDebugLoopCounter += 1;
					if (GetEffectType(eEffect) == EFFECT_TYPE_CHARMED)
					{
						if (GetEffectSubType(eEffect) == SUBTYPE_MAGICAL)
						{
							bFound = TRUE;
						}
						break;
					}
					eEffect = GetNextEffect(goCharmedAlly);
				}
				if (bFound)
				{
					float fCurWeight = SCGetThreatRating(goCharmedAlly, oCharacter) * SCGetDispelChance(GetEffectCreator(eEffect));
					if (fCurWeight > fMaxWeight)
					{
						fMaxWeight = fCurWeight;
						oBestTarget = goCharmedAlly;
					}
				}
			}
		}
		
        oFriend = oCharacter;
        iLoopLimit = gsBestDispel.range == 0.0 ? 1 : 7;
		int curLoopCount = 1;
		while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
		{
			//DEBUGGING// igDebugLoopCounter += 1;
			if (GetLocalInt(oFriend, "HenchCurNegEffects") & HENCH_EFFECT_DISABLED_NO_PETRIFY)
			{
                effect eEffect = GetFirstEffect(oFriend);
				int bFound;
                
                while (GetIsEffectValid(eEffect))
                {
                    //DEBUGGING// igDebugLoopCounter += 1;
                    if (GetEffectSubType(eEffect) == SUBTYPE_MAGICAL)
                    {
						switch (GetEffectType(eEffect))
						{
						case EFFECT_TYPE_VISUALEFFECT:	// this effect is very common, don't check everything
							break;
						case EFFECT_TYPE_PARALYZE:
						case EFFECT_TYPE_STUNNED:
						case EFFECT_TYPE_FRIGHTENED:
						case EFFECT_TYPE_SLEEP:
						case EFFECT_TYPE_DAZED:
						case EFFECT_TYPE_CONFUSED:
                            bFound = TRUE;
							break;
                        }
                    }
                    eEffect = GetNextEffect(oFriend);
                }
				if (bFound)
				{
					float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * SCGetDispelChance(GetEffectCreator(eEffect));
					if (curEffectWeight > fMaxWeight)
					{
						fMaxWeight = curEffectWeight;
						oBestTarget = oFriend;
					}
					break;
				}		
			}
			oFriend = GetLocalObject(oFriend, "HenchAllyList");
			curLoopCount ++;
		}
	}
	
	if (!gbDisableNonHealorCure)
	{
			// try to limit the casting of dispel/breach in case it fails
		int combatRoundCount = GetLocalInt(oCharacter, "tkCombatRoundCount");
		int lastDispel = GetLocalInt(oCharacter, "tkLastDispel");
		if ((lastDispel == 0) || (lastDispel < combatRoundCount - 5))
		{			
			object oTarget = GetLocalObject(oCharacter, "HenchLineOfSight");
			while (GetIsObjectValid(oTarget))
			{
				//DEBUGGING// igDebugLoopCounter += 1;
				if ((GetDistanceToObject(oTarget) <= 20.0) && !(SCGetCreatureNegEffects(oTarget) & HENCH_EFFECT_DISABLED_OR_IMMOBILE))
				{				
					struct sEnhancementLevel enhanceLevel = SCGetHasBeneficialEnhancement(oTarget);
					if (enhanceLevel.breach > fMaxWeight)
					{
						oBestTarget = oTarget;
						fMaxWeight = enhanceLevel.breach;
						bUseBreach = TRUE;
					}
					if (enhanceLevel.dispel > fMaxWeight)
					{
						oBestTarget = oTarget;
						fMaxWeight = enhanceLevel.dispel;
						bUseBreach = FALSE;
					}
				}
				oTarget = GetLocalObject(oTarget, "HenchLineOfSight");
			}			
			// TODO removed for now
		/*
			location dispLoc = SC FindBestDispelLocation();
			if ((nBenTargetEffect == 0 && globalBestEnemyCount > 0) ||
				(nBenTargetEffect > 0 && globalBestEnemyCount > 2))
			{
				areaSpellTargetLoc = dispLoc;
				nAreaSpellExtraTargets = globalBestEnemyCount;
				iGlobalTargetType = TARGET_SPELL_AT_LOCATION;
				iGlobalSpell = iBestDispel;
				return TRUE;
			} */
		}
	}
	
	if (fMaxWeight > 0.0)
	{
		if (bUseBreach)
		{
			fMaxWeight *= SCGetConcetrationWeightAdjustment(gsBestBreach.spellInfo, gsBestBreach.spellLevel);		
			if (fMaxWeight >= gfAttackTargetWeight)
			{
				gfAttackTargetWeight = fMaxWeight;		
				gsAttackTargetInfo = gsBestBreach;			
				gsAttackTargetInfo.oTarget = oBestTarget;
			}
		}
		else
		{
			fMaxWeight *= SCGetConcetrationWeightAdjustment(gsBestDispel.spellInfo, gsBestDispel.spellLevel);		
			if (fMaxWeight >= gfAttackTargetWeight)
			{
				gfAttackTargetWeight = fMaxWeight;		
				gsAttackTargetInfo = gsBestDispel;			
				gsAttackTargetInfo.oTarget = oBestTarget;
			}
		}	
	}
}


void SCHenchResetCombatRound( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchResetCombatRound Start", GetFirstPC() ); }
    
    SetLocalObject(oCharacter, HENCH_AI_SCRIPT_INTRUDER_OBJ, OBJECT_INVALID);
    SetLocalInt(oCharacter, HENCH_AI_SCRIPT_FORCE, FALSE);
    SetLocalInt(oCharacter, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_NOT_RUN);
	DeleteLocalInt(oCharacter, HENCH_AI_BLOCKED);
}


void SCSetEnemyLocation(object oEnemy, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetEnemyLocation Start", GetFirstPC() ); }
    
    SetLocalInt(oCharacter, HENCH_LAST_HEARD_OR_SEEN, TRUE);
    location enemyLocation = GetLocation(oEnemy);
    SetLocalLocation(oCharacter, HENCH_LAST_HEARD_OR_SEEN, enemyLocation);
}


void SCClearEnemyLocation( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCClearEnemyLocation Start", GetFirstPC() ); }
    
    DeleteLocalInt(oCharacter, HENCH_LAST_HEARD_OR_SEEN);
    DeleteLocalLocation(oCharacter, HENCH_LAST_HEARD_OR_SEEN);
}


void SCHenchDetermineCombatRound(object oIntruder = OBJECT_INVALID, int bForceInterrupt = FALSE, int bForceTarget = FALSE, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchDetermineCombatRound Start", GetFirstPC() ); }
    
    if(CSLGetAssociateState(CSL_ASC_IS_BUSY))
    {
        //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchDetermineCombatRound (Busy) End", GetFirstPC() ); }
        return;
    }

    string sAIScript = GetLocalString(oCharacter, "AIScript");
    if (sAIScript == "")
    {
        sAIScript = "hench_o0_ai";
    }

    if (bForceTarget)
    {
        SetLocalObject(oCharacter, HENCH_AI_SCRIPT_INTRUDER_OBJ, oIntruder);
        SetLocalInt(oCharacter, HENCH_AI_SCRIPT_FORCE, TRUE);
    }
    else if (GetIsObjectValid(oIntruder) && !GetLocalInt(oCharacter, HENCH_AI_SCRIPT_FORCE))
    {
        SetLocalObject(oCharacter, HENCH_AI_SCRIPT_INTRUDER_OBJ, oIntruder);
    }

        // check if we have to actually determine to rerun ai
    int iAIScriptRunState = GetLocalInt(oCharacter, HENCH_AI_SCRIPT_RUN_STATE);

    if (iAIScriptRunState == HENCH_AI_SCRIPT_IN_PROGRESS)
    {
        //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchDetermineCombatRound (in progress) End", GetFirstPC() ); }
        return;
    }

    if (bForceInterrupt)
    {
        SetLocalInt(oCharacter, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
        DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, oCharacter));
        //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchDetermineCombatRound (Interupt) End", GetFirstPC() ); }
        return;
    }

    if (iAIScriptRunState == HENCH_AI_SCRIPT_NOT_RUN)
    {
        // first run of SC HenchDetermineCombatRound
        SetLocalInt(oCharacter, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
        DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, oCharacter));
        //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchDetermineCombatRound (not run) End", GetFirstPC() ); }
        return;
    }
    object oLastTarget = GetLocalObject(oCharacter, "LastTarget");

    if (!GetIsObjectValid(oLastTarget) || GetIsDead(oLastTarget) || !GetIsEnemy(oLastTarget) || GetLocalInt(oLastTarget, "RunningAway"))
    {
        oLastTarget = OBJECT_INVALID;
    }
    else if (!GetObjectSeen(oLastTarget) && !GetObjectHeard(oLastTarget))
    {
        oLastTarget = OBJECT_INVALID;
    }
    if (!GetIsObjectValid(oLastTarget))
    {
        // prevent too many calls to main script if already moving to an unseen and
        // unheard monster
        if (!GetLocalInt(oCharacter, HENCH_LAST_HEARD_OR_SEEN) || GetObjectSeen(oIntruder) || GetObjectHeard(oIntruder))
        {
            SetLocalInt(oCharacter, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
            DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, oCharacter));
        }
    }
    else if (GetIsObjectValid(oIntruder))
    {
        if (GetDistanceToObject(oIntruder) <= 5.0 && GetDistanceToObject(oLastTarget) > 5.0)
        {
            SetLocalInt(oCharacter, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
            DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, oCharacter));
        }
        else if (GetObjectSeen(oIntruder) && !GetObjectSeen(oLastTarget))
        {
            SetLocalInt(oCharacter, HENCH_AI_SCRIPT_RUN_STATE, HENCH_AI_SCRIPT_IN_PROGRESS);
            DelayCommand(HENCH_AI_SCRIPT_DELAY, ExecuteScript(sAIScript, oCharacter));
        }
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchDetermineCombatRound End", GetFirstPC() ); }
}



void SCHenchTestStepLocation(location destLocation, location oldLocation, int curTest, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTestStepLocation Start", GetFirstPC() ); }
	
	if (GetIsPC(oCharacter))
	{
		return;	// I am done		
	}	
	
	if (GetDistanceBetweenLocations(oldLocation, GetLocation(oCharacter)) > 0.75)
	{
		SCHenchDetermineCombatRound(OBJECT_INVALID, TRUE);
		return;
	}
	
	if (curTest >= HENCH_STEP_NONE)
	{	
		ActionWait(2.0);
		ActionDoCommand(SCHenchDetermineCombatRound(OBJECT_INVALID, TRUE));	
		return;
	}	
	
    vector vTarget = GetPositionFromLocation(destLocation);
    vector vSource = GetPosition(oCharacter);
    vector vDirection = vTarget - vSource;
	float fAngle = VectorToAngle(vDirection);
	
	fAngle += 20 - Random(41);
	if (curTest == HENCH_STEP_RIGHT)
	{
		fAngle += 60;
	}
	else if (curTest == HENCH_STEP_LEFT)
	{
		fAngle -= 60;
	}
	fAngle = CSLGetNormalizedDirection(fAngle);

    vector vPoint =	AngleToVector(fAngle) * (1.2 + IntToFloat(Random(10)) / 2.0) + vSource;
   	location newLoc = Location(GetArea(oCharacter), vPoint, GetFacing(oCharacter));
	location destLocation = CalcSafeLocation(oCharacter, newLoc, 2.0, TRUE, FALSE);
	object oTest = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, destLocation, 1);
	
	curTest++;
	if ((GetDistanceBetweenLocations(destLocation, newLoc) <= 2.0))
	{
		ActionMoveToLocation(destLocation, TRUE);
		ActionDoCommand(SCHenchTestStepLocation(destLocation, oldLocation, curTest));
		return;	
	}
	SCHenchTestStepLocation(destLocation, oldLocation, curTest);	
}



int SCMoveToLastSeenOrHeard(int bDoSearch = TRUE, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCMoveToLastSeenOrHeard Start", GetFirstPC() ); }
    
    location moveToLoc = GetLocalLocation(oCharacter, HENCH_LAST_HEARD_OR_SEEN);
    if (GetDistanceBetweenLocations(GetLocation(oCharacter), moveToLoc) <= 5.0)
    {
        ClearAllActions();
        SCClearEnemyLocation();
        // go to search
        // TODO add spells to help search
        if ( SCHenchCheckDetectInvisibility(oCharacter) )
        {
        	DelayCommand(6.0, SCHenchDetermineCombatRound(OBJECT_INVALID, TRUE));
        	return FALSE;
        }
        
        if (bDoSearch)
        {
            // search around for awhile
            SetActionMode(oCharacter, ACTION_MODE_DETECT, TRUE);
            ActionRandomWalk();
            DelayCommand(10.0,  SCHenchDetermineCombatRound(OBJECT_INVALID, TRUE));
        }
        return FALSE;
    }
    else
    {
        ClearAllActions();
		vector destVec = GetPositionFromLocation(moveToLoc);
		destVec.x += Random(10) / 5.0 - 1.0;
		destVec.y += Random(10) / 5.0 - 1.0;		
        location destLocation = CalcSafeLocation(oCharacter, Location(GetArea(oCharacter), destVec, GetFacing(oCharacter)), 15.0, FALSE, TRUE);
        if (GetDistanceBetweenLocations(destLocation, GetLocation(oCharacter)) > 0.1)
        {
            ActionMoveToLocation(destLocation, TRUE);
			ActionDoCommand(SCHenchTestStepLocation(destLocation, GetLocation(oCharacter), HENCH_STEP_FORWARD));
            return TRUE;
        }
        else
        {
			SCHenchTestStepLocation(destLocation, GetLocation(oCharacter), HENCH_STEP_FORWARD);
            return FALSE;
        }
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCMoveToLastSeenOrHeard End", GetFirstPC() ); }
}


int SCHenchCheckEventClearAllActions(int bEndOfRound, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckEventClearAllActions Start", GetFirstPC() ); }
    
    if (bEndOfRound)
    {
        DeleteLocalInt(oCharacter, HENCH_AI_SCRIPT_HB);
    }
    int nCurAction = GetCurrentAction();

    if (nCurAction == ACTION_ATTACKOBJECT)
    {
        if (bEndOfRound)
        {
            ClearAllActions();
        }
    }
	else if (nCurAction == ACTION_INVALID)
	{
		ClearAllActions();
	}
    else if (nCurAction == ACTION_CASTSPELL || nCurAction == ACTION_ITEMCASTSPELL)
    {
        // check cancel if target has died
        // TODO better check for a location target spell
        object oLastSpellTarget = GetAttemptedSpellTarget();
        if (!GetIsObjectValid(oLastSpellTarget) ||
			!GetObjectType(oLastSpellTarget) ||	// sometimes object type 0 is returned on invalid target                    
            !GetIsDead(oLastSpellTarget, TRUE) ||
            (GetSpellId() == SPELL_RAISE_DEAD) ||
            (GetSpellId() == SPELL_RESURRECTION) ||
			(GetSpellId() == 1157 /* spirit shaman raise dead*/))
        {
            return TRUE;
        }
        // cancel spell - continue on
        ClearAllActions();
    }
	else if (nCurAction == ACTION_HEAL || nCurAction == ACTION_KIDAMAGE || nCurAction == ACTION_SMITEGOOD || nCurAction == ACTION_TAUNT || nCurAction == ACTION_REST ) /* || nCurAction == ACTION_DISABLETRAP || nCurAction == ACTION_RECOVERTRAP || nCurAction == ACTION_ANIMALEMPATHY || nCurAction == ACTION_COUNTERSPELL) */
	{
		return TRUE;
	}
    else
    {
		ClearAllActions();
    }
    return FALSE;
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchCheckEventClearAllActions End", GetFirstPC() ); }
}


int SCHenchCheckHeartbeatCombat(int bSetFlag = TRUE, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckHeartbeatCombat Start", GetFirstPC() ); }
	
	DeleteLocalInt(oCharacter, HENCH_AI_BLOCKED);
    if (GetLocalInt(oCharacter, HENCH_AI_SCRIPT_HB))
    {
        return TRUE;
    }
	if (bSetFlag)
	{
    	SetLocalInt(oCharacter, HENCH_AI_SCRIPT_HB, TRUE);
	}
    int nCurAction = GetCurrentAction();
    return (nCurAction == ACTION_INVALID) || (nCurAction == ACTION_MOVETOPOINT) ||  (nCurAction == ACTION_FOLLOW) || (nCurAction == HENCH_ACTION_MOVETOLOCATION);
}



// start combat after action complete
void SCHenchStartCombatRoundAfterAction(object oTarget, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchStartCombatRoundAfterAction Start "+GetName(oTarget), GetFirstPC() ); }
    
    SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, TRUE);
    ActionDoCommand(SCHenchDetermineCombatRound(oTarget, TRUE));
    DelayCommand(2.0, SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, FALSE));
}


void SCHenchStartCombatRoundAfterDelay(object oTarget, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchStartCombatRoundAfterDelay Start "+GetName(oTarget), GetFirstPC() ); }
    
    SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, FALSE);
    SCHenchDetermineCombatRound(oTarget, TRUE);
}


void SCHenchStartAttack(object oIntruder, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchStartAttack Start", GetFirstPC() ); }
    
    SetLocalObject(oCharacter, HENCH_AI_SCRIPT_INTRUDER_OBJ, oIntruder);
    ExecuteScript("hench_o0_att", oCharacter);
}


// FLEE COMBAT AND HOSTILES
int SCHenchTalentFlee(object oIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTalentFlee Start", GetFirstPC() ); }
    
    object oTarget = oIntruder;
    if(!GetIsObjectValid(oIntruder))
    {
        oTarget = GetLastHostileActor();
        if(!GetIsObjectValid(oTarget) || GetIsDead(oTarget))
        {
            oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
            float fDist = GetDistanceBetween(oCharacter, oTarget);
            if(!GetIsObjectValid(oTarget))
            {
                return FALSE;
            }
        }
    }
    ClearAllActions();
    //Look at this to remove the delay
    ActionMoveAwayFromObject(oTarget, TRUE, 10.0f);
    DelayCommand(4.0, ClearAllActions());
    return TRUE;
}




int SCIsOnOppositeSideOfDoor(object oDoor, object obj1, object obj2)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCIsOnOppositeSideOfDoor Start", GetFirstPC() ); }
    
    float fDoorAngle = GetFacing(oDoor);
    vector vDoor = GetPosition(oDoor);
    vector v1 = GetPosition(obj1);
    vector v2 = GetPosition(obj2);
    float fAngle1 = VectorToAngle(v1 - vDoor);
    float fAngle2 = VectorToAngle(v2 - vDoor);	
	return (cos(fAngle1 - fDoorAngle) * cos(fAngle2 - fDoorAngle)) < -0.00001;
}




int SCHenchEnemyOnOtherSideOfDoor(object oTarget, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchEnemyOnOtherSideOfDoor Start "+GetName(oTarget), GetFirstPC() ); }
    
    float fEnemyDistance = GetDistanceToObject(oTarget);
    vector vMiddle = GetPosition(oCharacter) + GetPosition(oTarget);
    vMiddle /= 2.0;
    location middleLoc = Location(GetArea(oCharacter), vMiddle, GetFacing(oCharacter));
    float fRadius = fEnemyDistance < 15.0 ? 15.0 : fEnemyDistance;	
	int bIngoreDoorWarning = !GetIsObjectValid(GetFactionLeader(oCharacter));

    object oDoor = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, middleLoc,
                    FALSE, OBJECT_TYPE_DOOR);					
    while (GetIsObjectValid(oDoor))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (!GetIsOpen(oDoor) && (bIngoreDoorWarning || GetLocalInt(oDoor, "tkDoorWarning")))
        {
            if (SCIsOnOppositeSideOfDoor(oDoor, oTarget, oCharacter))
            {
                return TRUE;
            }
        }
        oDoor = GetNextObjectInShape(SHAPE_SPHERE, fRadius, middleLoc,
                    FALSE, OBJECT_TYPE_DOOR);
    }
    return FALSE;
}

object SCGetNearestSeenOrHeardEnemyNotDead( int bIngoreHeard = FALSE, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetNearestSeenOrHeardEnemyNotDead Start", GetFirstPC() ); }
    
    int curCount = 1;
    object oTarget;
    while (curCount<50)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, curCount, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(oTarget))
        {
            break;
        }
        if (!GetPlotFlag(oTarget))
        {
            return oTarget;
        }
        curCount++;
    }
	if (bIngoreHeard)
	{
    	return OBJECT_INVALID;
	}
    curCount = 1;
    while (curCount<50)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, curCount, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
        if (!GetIsObjectValid(oTarget))
        {
            return OBJECT_INVALID;
        }
		if (!GetPlotFlag(oTarget) && !SCHenchEnemyOnOtherSideOfDoor(oTarget))
        {
            return oTarget;
        }
        curCount++;
    }
    return OBJECT_INVALID;
}



void SCHenchDetermineSpecialBehavior(object oIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchDetermineSpecialBehavior Start", GetFirstPC() ); }
    
    object oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, 1, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);

    // Omnivore behavior routine
    if(SCGetBehaviorState(CSL_FLAG_BEHAVIOR_OMNIVORE))
    {
        // no current attacker and not currently in combat
        if(!GetIsObjectValid(oIntruder) && !GetIsInCombat())
        {
            // does not have a current target
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) &&
               !GetIsObjectValid(GetAttemptedSpellTarget()) &&
               !GetIsObjectValid(GetAttackTarget()))
            {
                // enemy creature nearby
                if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 13.0)
                {
                    ClearAllActions();
                    SCHenchDetermineCombatRound(oTarget);
                    return;
                }
                int nTarget = 1;
                oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, nTarget,
                                             CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL);

                // neutral creature, too close
                while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 7.0)
                {
                    //DEBUGGING// igDebugLoopCounter += 1;
                    if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0 && GetAssociateType(oTarget) != ASSOCIATE_TYPE_ANIMALCOMPANION)
                    {
                        // oTarget has neutral reputation, and is NOT a druid or ranger or an "Animal Companion"
                        SetLocalInt(oCharacter, "lcTempEnemy", 8);
                        SetIsTemporaryEnemy(oTarget);
                        ClearAllActions();
                        SCHenchDetermineCombatRound(oTarget);
                        return;
                    }
                    oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, ++nTarget,
                                                 CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL);
                }

                // non friend creature, too close
                nTarget = 1;
                oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, oCharacter, nTarget);

                // heard neutral or enemy creature, too close
                while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 7.0)
                {
                    //DEBUGGING// igDebugLoopCounter += 1;
                    if(!GetIsFriend(oTarget) && GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0 && GetAssociateType(oTarget) != ASSOCIATE_TYPE_ANIMALCOMPANION)
                    {
                        // oTarget has neutral reputation, and is NOT a druid or ranger or an "Animal Companion"
                        SetLocalInt(oCharacter, "lcTempEnemy", 8);
                        SetIsTemporaryEnemy(oTarget);
                        ClearAllActions();
                        SCHenchDetermineCombatRound(oTarget);
                        return;
                    }
                    oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, oCharacter, ++nTarget);
                }

                if(!IsInConversation(oCharacter))
                {
                    // 25% chance of just standing around instead of constantly
                    // randWalking; i thought it looked odd seeing the animal(s)
                    // in a constant state of movement, was not realistic,
                    // at least according to my Nat'l Geographic videos
                    if ( (d4() != 1) && (GetCurrentAction() == ACTION_RANDOMWALK) )
                    {
                        return;
                    }
                    else if ( (d4() == 1) && (GetCurrentAction() == ACTION_RANDOMWALK) )
                    {
                        ClearAllActions();
                        return;
                    }
                    else
                    {
                        ClearAllActions();
                        ActionRandomWalk();
                        return;
                    }
                }
            }
        }
        else if(!IsInConversation(oCharacter)) // enter combat when attacked
        {
            // after a while (20-25 seconds), omnivore (boar) "gives up"
            // chasing someone who didn't hurt it. but if the person fought back
            // this condition won't run and the boar will fight to death
            if(GetLocalInt(oCharacter, "lcTempEnemy") != FALSE && (GetLastDamager() == OBJECT_INVALID || GetLastDamager() != oTarget) )
            {
                int nPatience = GetLocalInt(oCharacter, "lcTempEnemy");
                if (nPatience <= 1)
                {
                    ClearAllActions();
                    ClearPersonalReputation(oTarget);  // reset reputation
                    DeleteLocalInt(oCharacter, "lcTempEnemy");
                    return;
                }
                SetLocalInt(oCharacter, "lcTempEnemy", --nPatience);
            }
            ClearAllActions();
            SCHenchDetermineCombatRound(oIntruder);
        }
    }

    // Herbivore behavior routine
    else if(SCGetBehaviorState(CSL_FLAG_BEHAVIOR_HERBIVORE))
    {
        // no current attacker & not currently in combat
        if(!GetIsObjectValid(oIntruder) && !GetIsInCombat())
        {
            if(!GetIsObjectValid(GetAttemptedAttackTarget()) && // does not have a current target
               !GetIsObjectValid(GetAttemptedSpellTarget()) &&
               !GetIsObjectValid(GetAttackTarget()))
            {
                // NWN2 OC uses the herbivore for NPCs, don't have them run away
                if (((GetRacialType(oCharacter) == RACIAL_TYPE_ANIMAL) || (GetRacialType(oCharacter) == RACIAL_TYPE_BEAST)) &&
                    (GetAppearanceType(oCharacter) > APPEARANCE_TYPE_HUMAN))
                {
                    if(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 13.0) // enemy creature, too close
                    {
                        ClearAllActions();
                        ActionMoveAwayFromObject(oTarget, TRUE, 16.0); // flee from enemy
                        return;
                    }
                    int nTarget = 1;
                    oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, nTarget,
                                                 CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL);
                    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 7.0) // only consider close creatures
                    {
                        //DEBUGGING// igDebugLoopCounter += 1;
                        if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0 && GetAssociateType(oTarget) != ASSOCIATE_TYPE_ANIMALCOMPANION)
                        {
                            // oTarget has neutral reputation, and is NOT a druid or ranger or Animal Companion
                            ClearAllActions();
                            ActionMoveAwayFromObject(oTarget, TRUE, 16.0); // run away
                            return;
                        }
                        oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, ++nTarget,
                                                     CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_NEUTRAL);
                    }
                    nTarget = 1;
                    oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, oCharacter, nTarget);
                    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 7.0) // only consider close creatures
                    {
                        //DEBUGGING// igDebugLoopCounter += 1;
                        if(!GetIsFriend(oTarget) && GetLevelByClass(CLASS_TYPE_DRUID, oTarget) == 0 && GetLevelByClass(CLASS_TYPE_RANGER, oTarget) == 0 && GetAssociateType(oTarget) != ASSOCIATE_TYPE_ANIMALCOMPANION)
                        {
                            // oTarget has neutral reputation, and is NOT a druid or ranger or Animal Companion
                            ClearAllActions();
                            ActionMoveAwayFromObject(oTarget, TRUE, 16.0); // run away
                            return;
                        }
                        oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, oCharacter, ++nTarget);
                    }
                    if(!IsInConversation(oCharacter))
                    {
                        // 75% chance of randomWalking around, 25% chance of just standing there. more realistic
                        if ( (d4() != 1) && (GetCurrentAction() == ACTION_RANDOMWALK) )
                        {
                            return;
                        }
                        else if ( (d4() == 1) && (GetCurrentAction() == ACTION_RANDOMWALK) )
                        {
                            ClearAllActions();
                            return;
                        }
                        else
                        {
                            ClearAllActions();
                            ActionRandomWalk();
                            return;
                        }
                    }
                }
            }
        }
        else if (!IsInConversation(oCharacter)) // NEW BEHAVIOR - run away when attacked
        {
            // NWN2 OC uses the herbivore for NPCs, don't have them run away
            if (((GetRacialType(oCharacter) == RACIAL_TYPE_ANIMAL) || (GetRacialType(oCharacter) == RACIAL_TYPE_BEAST)) &&
                (GetAppearanceType(oCharacter) > APPEARANCE_TYPE_HUMAN))
            {
                ClearAllActions();
                ActionMoveAwayFromLocation(GetLocation(oCharacter), TRUE, 16.0);
            }
            else
            {
                ClearAllActions();
                ActionRandomWalk();
            }
        }
    }
}


int SCHenchGetIsEnemyPerceived(int bIngoreHearing, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetIsEnemyPerceived Start", GetFirstPC() ); }
    
    object oClosestSeen = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);

    if (GetIsObjectValid(oClosestSeen) && !GetPlotFlag(oClosestSeen))
    {
        return TRUE;
    }
	if (bIngoreHearing)
	{
		return FALSE;
	}
    object oClosestHeard = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    if (GetIsObjectValid(oClosestHeard) && !GetPlotFlag(oClosestHeard))
    {
        if (GetDistanceToObject(oClosestHeard) > HENCH_HEARING_DISTANCE)
        {
            return FALSE;
        }
        object oRealMaster = GetFactionLeader(oCharacter);
        if (GetIsObjectValid(oRealMaster))
        {
            if (GetDistanceBetween(oRealMaster, oClosestHeard) <= HENCH_MASTER_HEARING_DISTANCE)
            {
                return !SCHenchEnemyOnOtherSideOfDoor(oClosestHeard);
            }
        }
    }
    return FALSE;
}





object SCGetNearestTougherFriend(object oSelf, object oPC, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetNearestTougherFriend Start", GetFirstPC() ); }
    
    int i = 0;

    object oFriend = oSelf;

    int nEqual = 0;
    int nNear = 0;
    while (GetIsObjectValid(oFriend))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (GetDistanceBetween(oSelf, oFriend) < 40.0 && oFriend != oSelf)
        {
            ++nNear;
            if (GetHitDice(oFriend) > GetHitDice(oSelf))
                return oFriend;
            if (GetHitDice(oFriend) == GetHitDice(oSelf))
                ++nEqual;
        }
        ++i;
        oFriend =  GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND,
            oSelf, i);
    }

    SetLocalInt(oCharacter,"LocalBoss",FALSE);
    if (nEqual == 0)
        if (nNear > 0 || GetHitDice(oPC) - GetHitDice(oCharacter) < 2)
    {
        SetLocalInt(oCharacter,"LocalBoss",TRUE);
    }

    return OBJECT_INVALID;
}



int SCCheckStealth( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckStealth Start", GetFirstPC() ); }
    
    int nStealthCheck = GetLocalInt(oCharacter, "canStealth");
    if (nStealthCheck == 0)
    {
        int nThreshold = GetHitDice(oCharacter) / 2;
        nStealthCheck = ((GetSkillRank(SKILL_HIDE, oCharacter, TRUE) > nThreshold) ||
            (GetSkillRank(SKILL_MOVE_SILENTLY, oCharacter, TRUE) > nThreshold)) ? 1 : 2;
        SetLocalInt(oCharacter, "canStealth", nStealthCheck);
    }
    return nStealthCheck == 1;
}




int SCDoStealthAndWander( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCDoStealthAndWander Start", GetFirstPC() ); }
    
    // Pausanias: monsters try to find you.
	DeleteLocalInt(oCharacter, "MonsterWander");
    int scoutMode = GetLocalInt(oCharacter, "ScoutMode");
    if (scoutMode == 0)
    {
        scoutMode = d2();
        SetLocalInt(oCharacter, "ScoutMode", scoutMode);
    }
    if (GetPlotFlag(oCharacter))
    {
        return FALSE;
    }
    int nStealthAndWander = SCGetHenchOption(HENCH_OPTION_STEALTH | HENCH_OPTION_WANDER);
    if (!nStealthAndWander)
    {
        return FALSE;
    }

    // Auldar: and they now stealth if they have some skill points (and not marked with plot flag)
    object oNearestHostile = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY);


    if (!GetIsObjectValid(oNearestHostile))
    {
        return FALSE;
    }
    object oPC = GetFactionLeader(oNearestHostile);
    if (!GetIsObjectValid(oPC))
    {
        return FALSE;
    }


    int bActionsCleared = FALSE;
    if ((nStealthAndWander & HENCH_OPTION_STEALTH) && !GetPlotFlag(oCharacter) &&
        !GetActionMode(oCharacter, ACTION_MODE_STEALTH))
    {
        // Auldar: Checking if the NPC is hostile to the PC and has skill points in Hide
        // or move silently, and it not marked Plot. If so, go stealthy even if not flagged
        // by the module creator as Stealth on spawn, as long as the PC or associate is hostile and close.
        if (SCCheckStealth())
        {
                // Auldar: Check how far away the nearest hostile Creature is
            float enemyDistance = GetDistanceToObject(oNearestHostile);

            if ((enemyDistance <= HENCH_STEALTH_DIST_THRESHOLD) && (enemyDistance != -1.0))
            {
                ClearAllActions();
                bActionsCleared = TRUE;
                SetActionMode(oCharacter, ACTION_MODE_STEALTH, TRUE);
            }
        }
        // Auldar: here ends Auldar's NPC stealth code. Back to Paus' work :)
    }
        // Auldar: Reducing the distance from 40.0 to 25.0 to reduce the "bloodbath" effect
        // requested by FoxBat.
    if ((nStealthAndWander & HENCH_OPTION_WANDER) && GetDistanceToObject(oPC) < 25.0)
    {
        object oTarget = SCGetNearestTougherFriend(oCharacter,oPC);
        if (!GetLocalInt(oCharacter, "LocalBoss"))
        {
            int fDist = 15;
            if (!GetIsObjectValid(oTarget) || scoutMode == 1)
            {
                fDist = 10;
                oTarget = oPC;
                if (d10() > 5) fDist = 25;
            }
            location lNew;
            if (GetLocalInt(oCharacter, "OpenedDoor"))
            {
                lNew = GetLocalLocation(oCharacter, "ScoutZone");
                DeleteLocalInt(oCharacter, "OpenedDoor");
            }
            else
            {
                vector vLoc = GetPosition(oTarget);
                vLoc.x += fDist-IntToFloat(Random(2*fDist+1));
                vLoc.y += fDist-IntToFloat(Random(2*fDist+1));
                vLoc.z += fDist-IntToFloat(Random(2*fDist+1));
                lNew = Location(GetArea(oTarget),vLoc,0.);
                SetLocalLocation(oCharacter, "ScoutZone", lNew);
            }
            if (!bActionsCleared)
            {
                ClearAllActions();
            }
            ActionMoveToLocation(lNew);
			SetLocalInt(oCharacter, "MonsterWander", TRUE);
            return TRUE;
        }
    }
    return FALSE;
}


void SCCheckRemoveStealth( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckRemoveStealth Start", GetFirstPC() ); }
    
    if (GetActionMode(oCharacter, ACTION_MODE_STEALTH))
    {
        int iCheckStealthAmount = GetSkillRank(SKILL_HIDE) + GetSkillRank(SKILL_MOVE_SILENTLY) + 5;

        SetActionMode(oCharacter, ACTION_MODE_STEALTH, FALSE);

        location testLocation = GetLocation(oCharacter);

        object oEnemy = GetFirstObjectInShape(SHAPE_SPHERE, 15.0, testLocation, TRUE);
        while(GetIsObjectValid(oEnemy))
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            if (GetActionMode(oEnemy, ACTION_MODE_STEALTH) && (GetFactionEqual(oEnemy) || GetIsFriend(oEnemy)) && !GetIsPC(oEnemy))
            {
                if (GetSkillRank(SKILL_HIDE, oEnemy) + GetSkillRank(SKILL_MOVE_SILENTLY, oEnemy) <= iCheckStealthAmount)
                {
                    SetActionMode(oEnemy, ACTION_MODE_STEALTH, FALSE);
                }
            }
            oEnemy = GetNextObjectInShape(SHAPE_SPHERE, 15.0, testLocation, TRUE);
        }
    }
}


void SCHenchTestStep(object oTarget, location oldLocation, int curTest, object oCharacter = OBJECT_SELF )
{
	int iOldDebugging = DEBUGGING;
	//DEBUGGING// if (DEBUGGING > 8 && DEBUGGING < 10) { DEBUGGING = 10; }
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTestStep Start "+GetName(oTarget), GetFirstPC() ); }
	
	if (GetIsPC(oCharacter))
	{
		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTestStep Done1", GetFirstPC() ); }
		DEBUGGING = iOldDebugging; // set this back
		return;	// I am done		
	}	
	
	if (GetDistanceBetweenLocations(oldLocation, GetLocation(oCharacter)) > 0.75)
	{
		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTestStep SCHenchDetermineCombatRound", GetFirstPC() ); }
		SCHenchDetermineCombatRound(oTarget, TRUE);
		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTestStep Done2", GetFirstPC() ); }
		DEBUGGING = iOldDebugging; // set this back
		return;
	}
	
	if (curTest >= HENCH_STEP_NONE) // this caps it out at 3 iterations, preventing a tmi basically
	{	
		SetLocalInt(oCharacter, HENCH_AI_BLOCKED, TRUE);
		SCHenchDetermineCombatRound(oTarget, TRUE);
		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTestStep Done3", GetFirstPC() ); }
		DEBUGGING = iOldDebugging; // set this back
		return;
	}	
	
    vector vTarget = GetPosition(oTarget);
    vector vSource = GetPosition(oCharacter);
    vector vDirection = vTarget - vSource;
	float fAngle = VectorToAngle(vDirection);
	
	fAngle += 10 - Random(21);
	if (curTest == HENCH_STEP_RIGHT)
	{
		fAngle += 45;
	}
	else if (curTest == HENCH_STEP_LEFT)
	{
		fAngle -= 45;
	}
	fAngle = CSLGetNormalizedDirection(fAngle);

    vector vPoint =	AngleToVector(fAngle) * (1.2 + IntToFloat(Random(10)) / 10.0) + vSource;
   	location newLoc = Location(GetArea(oCharacter), vPoint, GetFacing(oCharacter));
	location destLocation = CalcSafeLocation(oCharacter, newLoc, 2.0, TRUE, FALSE);
//	object oTest = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, destLocation, 1);
	
	curTest++;
	if ((GetDistanceBetweenLocations(destLocation, newLoc) <= 2.0))
	{
//			" test " + LocationToString(newLoc) + " dest " + LocationToString(destLocation));
		ActionMoveToLocation(destLocation, TRUE);
		ActionDoCommand(SCHenchTestStep(oTarget, oldLocation, curTest));
		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTestStep Done4", GetFirstPC() ); }
		DEBUGGING = iOldDebugging; // set this back
		return;	
	}
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchTestStep End", GetFirstPC() ); }
	DEBUGGING = iOldDebugging; // set this back
	SCHenchTestStep(oTarget, oldLocation, curTest);	
}

void SCHenchCheckAttackSecondaryTarget(object oOriginalTarget, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckAttackSecondaryTarget Start", GetFirstPC() ); }
	
	if (GetIsPC(oCharacter))
	{
		return;	// I am done		
	}
	object oTestTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
           oCharacter, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
           CREATURE_TYPE_IS_ALIVE, TRUE);
	if (oTestTarget != oOriginalTarget)
	{
		SetLocalObject(oCharacter, "LastTarget", oTestTarget);
		ActionAttack(oTestTarget);
	}
	// last ditch attempt to get unstuck
	ActionDoCommand(SCHenchTestStep(oTestTarget, GetLocation(oCharacter), HENCH_STEP_FORWARD));
	if (!GetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL))
	{
		SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, TRUE);
		DelayCommand(2.0, SCHenchStartCombatRoundAfterDelay(oTestTarget));
	}
}


void SCHenchMoveAndDetermineCombatRound(object oTarget, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchMoveAndDetermineCombatRound Start "+GetName(oTarget), GetFirstPC() ); }
	
	if (GetIsPC(oCharacter))
	{
		return;	// I am done		
	}
	if (!GetIsObjectValid(oTarget) || GetIsDead(oTarget, TRUE))
	{
		return;
	}
	if (GetDistanceToObject(oTarget) > 4.0)
	{
		location targetLocation = GetLocation(oTarget);
		vector testPosition = GetPosition(oTarget);
		testPosition += GetPosition(oCharacter);
		testPosition /= 2.0;
		location destLocation = CalcSafeLocation(oCharacter, Location(GetArea(oCharacter), testPosition, GetFacing(oCharacter)), 5.0, TRUE, FALSE);
		if (GetDistanceBetweenLocations(destLocation, targetLocation) < (GetDistanceToObject(oTarget) - 2.5))
		{
			ActionMoveToLocation(destLocation, TRUE);
			if (!GetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL))
			{
				SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, TRUE);
				DelayCommand(2.0, SCHenchStartCombatRoundAfterDelay(oTarget));
			}
			ActionDoCommand(SCHenchCheckAttackSecondaryTarget(oTarget));			
			return;
		}
		else
		{
			SetLocalLocation(oCharacter, "HENCH_LAST_ATTACK_LOC", GetLocation(oCharacter));
		}
	}
	SCHenchCheckAttackSecondaryTarget(oTarget);
}


void SCHenchMoveToMaster(object oMaster, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchMoveToMaster Start", GetFirstPC() ); }
	
	if (GetIsPC(oCharacter))
	{
		return;	// I am done		
	}
	if (GetDistanceToObject(oMaster) > 4.0)
	{
		int nCurAction = GetCurrentAction(oCharacter);	
		if (nCurAction == ACTION_FOLLOW)
		{	
			ClearAllActions();
		}
		location targetLocation = GetLocation(oMaster);
		vector testPosition = GetPosition(oMaster);
		testPosition += GetPosition(oCharacter);
		testPosition /= 2.0;
		location destLocation = CalcSafeLocation(oCharacter, Location(GetArea(oCharacter), testPosition, GetFacing(oCharacter)), 5.0, TRUE, FALSE);
		if (GetDistanceBetweenLocations(destLocation, targetLocation) < (GetDistanceToObject(oMaster) - 2.5))
		{
			ActionMoveToLocation(destLocation, TRUE);
			if (!GetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL))
			{
				SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, TRUE);
				DelayCommand(2.0, SCHenchStartCombatRoundAfterDelay(OBJECT_INVALID));
			}
			return;
		}
		else
		{
			SetLocalLocation(oCharacter, "HENCH_LAST_ATTACK_LOC", GetLocation(oCharacter));
		}
	}
}



void SCInitializeMonsterAllyDamage( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeMonsterAllyDamage Start", GetFirstPC() ); }
	
	if (SCGetHenchOption(HENCH_OPTION_MONSTER_ALLY_DAMAGE))
	{
		int nAlignment = GetAlignmentGoodEvil(oCharacter);
		if (nAlignment == ALIGNMENT_GOOD)
		{
			gfMaximumAllyDamage	= HENCH_LOW_ALLY_DAMAGE_THRESHOLD;
			gfAllyDamageWeight = HENCH_LOW_ALLY_DAMAGE_WEIGHT;
		}
		else if (nAlignment == ALIGNMENT_EVIL)
		{
			gfMaximumAllyDamage	= HENCH_EXTR_ALLY_DAMAGE_THRESHOLD;
			gfAllyDamageWeight = HENCH_HIGH_ALLY_DAMAGE_WEIGHT;
			gfMaximumAllyEffect = 0.3;	// allow minor effects to be used
		}
		else
		{
			gfMaximumAllyDamage	= HENCH_HIGH_ALLY_DAMAGE_THRESHOLD;
			gfAllyDamageWeight = HENCH_MED_ALLY_DAMAGE_WEIGHT;
		}
	}
	else
	{
		gfMaximumAllyDamage	= HENCH_LOW_ALLY_DAMAGE_THRESHOLD;
		gfAllyDamageWeight = HENCH_LOW_ALLY_DAMAGE_WEIGHT;
	}
}

int SCGetHenchPartyState(int nCondition, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetHenchPartyState Start", GetFirstPC() ); }
    
    object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oCharacter));
    int nResult = GetLocalInt(oPlayerCharacter, "HENCH_PARTY_SETTINGS");	
	if (!nResult)
	{
		nResult = GetCampaignInt(HENCH_CAMPAIGN_DB, "HENCH_PARTY_SETTINGS");
		nResult |= HENCH_OPTION_SET_ONCE;
    	SetLocalInt(oPlayerCharacter, "HENCH_PARTY_SETTINGS", nResult);
	}	
    return nResult & nCondition;
}



void SCInitializeAssociateAllyDamage()
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeAssociateAllyDamage Start", GetFirstPC() ); }
	
	if (SCGetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE))
	{
		gfMaximumAllyDamage	= HENCH_HIGH_ALLY_DAMAGE_THRESHOLD;
		gfAllyDamageWeight = HENCH_HIGH_ALLY_DAMAGE_WEIGHT;
	}
	else if (SCGetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE))
	{
		gfMaximumAllyDamage	= HENCH_MED_ALLY_DAMAGE_THRESHOLD;
		gfAllyDamageWeight = HENCH_MED_ALLY_DAMAGE_WEIGHT;
	}
	else
	{
		gfMaximumAllyDamage	= HENCH_LOW_ALLY_DAMAGE_THRESHOLD;
		gfAllyDamageWeight = HENCH_LOW_ALLY_DAMAGE_WEIGHT;
	}
}



void SCHenchCheckIfAttackSpellToCastOnObject(float fFinalTargetWeight, object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckIfAttackSpellToCastOnObject Start", GetFirstPC() ); }
    
    if (fFinalTargetWeight > 0.0)
    {
        fFinalTargetWeight *= SCGetConcetrationWeightAdjustment(gsCurrentspInfo.spellInfo, gsCurrentspInfo.spellLevel);

        if (fFinalTargetWeight >= gfAttackTargetWeight)
        {

            if ((gfAttackTargetWeight == 0.0) || (fFinalTargetWeight >= gfAttackTargetWeight * 1.02) ||
                (gsCurrentspInfo.spellLevel < gsAttackTargetInfo.spellLevel) ||
                !GetIsObjectValid(gsAttackTargetInfo.oTarget))
            {
                gfAttackTargetWeight = fFinalTargetWeight;
                gsAttackTargetInfo = gsCurrentspInfo;
                gsAttackTargetInfo.oTarget = oTarget;
            }
        }
    }
}


int SCHenchGetClassFlags(int nClass)
{
	int iOldDebugging = DEBUGGING;
	//DEBUGGING// if (DEBUGGING > 8 && DEBUGGING < 10) { DEBUGGING = 10; }
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetClassFlags Start", GetFirstPC() ); }
	
	string currentClassInfo = "HENCH_CLASS_ID_INFO" + IntToString(nClass);
	
	int flags = GetLocalInt(GetModule(), currentClassInfo);
	if ((flags & HENCH_SPELL_INFO_VERSION_MASK) != HENCH_SPELL_INFO_VERSION)
	{
        flags = StringToInt(Get2DAString("henchclasses", "Flags", nClass));
		if (flags == 0)
		{		
            flags = HENCH_SPELL_INFO_VERSION | HENCH_CLASS_BUFF_OTHERS_MEDIUM | HENCH_CLASS_ATTACK_FULL;	// put in some default for unknow class		
		}
		else
		{
			if (flags & HENCH_CLASS_FEAT_SPELLS)
			{				
				int featSpellIndex = 1;
				while ( featSpellIndex <= 11 ) // 11 columns
				{
					//DEBUGGING// igDebugLoopCounter += 1;
					int featSpellInfo = StringToInt(Get2DAString("henchclasses", "FeatSpell" + IntToString(featSpellIndex), nClass));					
					if (!featSpellInfo)
					{
						break;
					}
					SetLocalInt(GetModule(), currentClassInfo + "FS" + IntToString(featSpellIndex), featSpellInfo);				
					featSpellIndex++;
				}
				DeleteLocalInt(GetModule(), currentClassInfo + "FS" + IntToString(featSpellIndex));
			}
		}
		if ((flags & HENCH_CLASS_SPELL_PROG_MASK) && !(flags & HENCH_CLASS_PRC_FLAG))
		{
			int practicedSpellCasterFeat = CSLGetClassesDataFEATPracticedSpellcaster( nClass );					
			SetLocalInt(GetModule(), "HENCH_PS_INFO" + IntToString(nClass), practicedSpellCasterFeat);		
		}	
		SetLocalInt(GetModule(), currentClassInfo, flags);	
	}
	DEBUGGING = iOldDebugging; // set this back
	return flags;
}


void SCHenchCheckTurnUndead( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckTurnUndead Start", GetFirstPC() ); }
    
    // don't turn again until five checks have passed
    int combatRoundCount = GetLocalInt(oCharacter, "tkCombatRoundCount");
    int lastTurning = GetLocalInt(oCharacter, "tkLastTurning");
    if (lastTurning != 0 && lastTurning > combatRoundCount - 5)
    {
        return;
    }

    int nClassLevel;
	int iPosition = 1;
    int nClassPosLevel = GetLevelByPosition(iPosition);	
	while ((nClassPosLevel > 0) && (iPosition <= 4))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		//int nClass = SCHenchGetClassByPosition(iPosition, nClassPosLevel);
		int nClass = GetClassByPosition(iPosition);
		int nClassFlags = SCHenchGetClassFlags(nClass);		
		if (nClassFlags & HENCH_CLASS_TURN_UNDEAD_STACK)
		{		
			nClassLevel += nClassPosLevel;
		}
		nClassPosLevel = GetLevelByPosition(++iPosition);
	}
    int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
    int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    if((nBlackguardlevel - 2) > 0 && (nBlackguardlevel > nPaladinLevel))
    {
        nClassLevel += (nBlackguardlevel - 2);
    }
    else if((nPaladinLevel - 3) > 0)
    {
        nClassLevel += (nPaladinLevel - 3);
	}
	if (GetHasFeat(FEAT_IMPROVED_TURNING, oCharacter))
	{
		nClassLevel++;
	}
    int nTurnLevel = nClassLevel;

    //Flags for bonus turning types
    int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER, oCharacter) || GetHasFeat(FEAT_EARTH_DOMAIN_POWER, oCharacter) ||  GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oCharacter) || GetHasFeat(FEAT_WATER_DOMAIN_POWER, oCharacter);
    int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER, oCharacter);
    int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER, oCharacter);
    int nOutsider = GetHasFeat(FEAT_GOOD_DOMAIN_POWER, oCharacter) || GetHasFeat(FEAT_EVIL_DOMAIN_POWER, oCharacter) || GetHasFeat(FEAT_EPIC_PLANAR_TURNING, oCharacter);

    //Flag for improved turning ability
    int nSun = GetHasFeat(FEAT_SUN_DOMAIN_POWER, oCharacter);

    //Make a turning check roll, modify if have the Sun Domain
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    // normal check is d20 - changed to not try very often for very difficult turn
 	int nTurnCheck = d10(2) +  nChrMod;              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
 	int nTurnHD = d6(2) + nChrMod + nClassLevel;   //The number of HD of undead that can be turned.

    if(nSun)
    {
        nTurnCheck += d4();
		nTurnHD += d6();
    }
    if (nTurnCheck < 0)
    {
        nTurnCheck = 0;
    }
    else if (nTurnCheck > 22)
    {
        nTurnCheck = 22;
    }
	if (GetHasFeat(FEAT_EMPOWER_TURNING, oCharacter))
	{
		nTurnHD += (nTurnHD/2);
	}
    //Determine the maximum HD of the undead that can be turned.
    nTurnLevel += (nTurnCheck + 2) / 3 - 4;
		

    float fTotalChallenge;
	int nHDCount = 0;	
	location lMyLocation = GetLocation( oCharacter );
	float fSize = 2.0 * RADIUS_SIZE_COLOSSAL;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, lMyLocation, TRUE);	
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while( GetIsObjectValid(oTarget) && nHDCount < nTurnHD )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCharacter) && oTarget != oCharacter)
        {
            int nRacial = GetRacialType(oTarget);
            if (((nRacial == RACIAL_TYPE_UNDEAD) && !CSLGetHasEffectType(oTarget,EFFECT_TYPE_TURNED )) ||
                ((nRacial == RACIAL_TYPE_VERMIN) && nVermin) ||
                ((nRacial == RACIAL_TYPE_ELEMENTAL) && nElemental) ||
                ((nRacial == RACIAL_TYPE_CONSTRUCT) && nConstructs) ||
                ((nRacial == RACIAL_TYPE_OUTSIDER) && nOutsider && !CSLGetHasEffectType(oTarget,EFFECT_TYPE_TURNED)))
			{
				int nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
				if ((nHD <= nTurnLevel) && (nHD <= (nTurnHD - nHDCount)))
				{
					float fCurChallenge;
					if (!(SCGetCreatureNegEffects(oTarget) & HENCH_EFFECT_DISABLED))
					{
						if (nRacial == RACIAL_TYPE_CONSTRUCT)
						{					
							fCurChallenge = SCGetThreatRating(oTarget,oCharacter) * SCCalculateDamageWeight(IntToFloat(2 * nTurnLevel), oTarget);
						}
						else if ((nClassLevel/2) >= nHD)
						{
							fCurChallenge = SCGetThreatRating(oTarget,oCharacter);
						}
						else
						{
							fCurChallenge = 0.9 * SCGetThreatRating(oTarget,oCharacter);
						}
					}
					if (GetIsEnemy(oTarget))
					{
						fTotalChallenge += fCurChallenge;
					}
					else if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED)
					{
						// summons are expendable
						fTotalChallenge -= fCurChallenge;
					}
					else
					{
						// don't turn allies
						return;					
					}
					nHDCount += nHD;
				}
			}
        }
        //Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, lMyLocation, TRUE);
    }
	
	fTotalChallenge *= gfAttackWeight;
	
	if (fTotalChallenge > gfAttackTargetWeight)
	{		
		gfAttackTargetWeight = fTotalChallenge;		
		gsAttackTargetInfo = gsCurrentspInfo;
		gsAttackTargetInfo.oTarget = oCharacter;
	}	
}




string SCHenchGetAssocString(int iAssocType)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetAssocString Start", GetFirstPC() ); }
    
    if (iAssocType == ASSOCIATE_TYPE_FAMILIAR)
    {
        return "Fam";
    }
    else if (iAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION)
    {
        return "Ani";
    }
    else if (iAssocType == ASSOCIATE_TYPE_SUMMONED)
    {
        return "Sum";
    }
    else if (iAssocType == ASSOCIATE_TYPE_DOMINATED)
    {
        return "Dom";
    }
    return "null";
}


void SCHenchSetDefSettings(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchSetDefSettings Start", GetFirstPC() ); }
    
    int iAssocType = GetAssociateType(oCharacter);
    if ((iAssocType == ASSOCIATE_TYPE_NONE) ||
        (iAssocType == ASSOCIATE_TYPE_HENCHMAN))
    {
        return;
    }

    string preDefStr = SCHenchGetAssocString(iAssocType);
    object oPC = GetMaster(oCharacter);
    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    SetLocalInt(oPC, preDefStr + "NW_ASSOCIATE_MASTER", GetLocalInt(oCharacter, "NW_ASSOCIATE_MASTER"));
    SetLocalInt(oPC, preDefStr + "X2_HENCH_STEALTH_MODE", GetLocalInt(oCharacter, "X2_HENCH_STEALTH_MODE"));
    SetLocalInt(oPC, preDefStr + "X2_L_STOPCASTING", GetLocalInt(oCharacter, "X2_L_STOPCASTING"));
    SetLocalInt(oPC, preDefStr + "X2_HENCH_DO_NOT_DISPEL", GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL"));
    SetLocalInt(oPC, preDefStr + "HENCH_ASSOCIATE_SETTINGS", GetLocalInt(oCharacter, "HENCH_ASSOCIATE_SETTINGS"));
}


void SCHenchGetDefSettings(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetDefSettings Start", GetFirstPC() ); }
    
    if (GetLocalInt(oCharacter, "HENCH_DEF_SETTINGS_SET"))
    {
        return;
    }

    SetLocalInt(oCharacter, "HENCH_DEF_SETTINGS_SET", TRUE);

    int iAssocType = GetAssociateType(oCharacter);
    if ((iAssocType == ASSOCIATE_TYPE_NONE) ||
        (iAssocType == ASSOCIATE_TYPE_HENCHMAN))
    {
        return;
    }

    string preDefStr = SCHenchGetAssocString(iAssocType);
    object oPC = GetMaster(oCharacter);
    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    object oTarget;
    object oSource;
    string preSrcStr;
        // check if the PC has never had settings copied
        // for associate type
    if (!GetLocalInt(oPC, preDefStr + "HENCH_DEF_SETTINGS_SET"))
    {
        SetLocalInt(oPC, preDefStr + "HENCH_DEF_SETTINGS_SET", TRUE);
        oTarget = oPC;
        oSource = oCharacter;
        preSrcStr = preDefStr;
        preDefStr = "";
    }
    else
    {
        oTarget = oCharacter;
        oSource = oPC;
        preSrcStr = "";
    }

    SetLocalInt(oTarget, preSrcStr + "NW_ASSOCIATE_MASTER",
        GetLocalInt(oSource, preDefStr + "NW_ASSOCIATE_MASTER"));
    SetLocalInt(oTarget, preSrcStr + "X2_HENCH_STEALTH_MODE",
        GetLocalInt(oSource, preDefStr + "X2_HENCH_STEALTH_MODE"));
    SetLocalInt(oTarget, preSrcStr + "X2_L_STOPCASTING",
        GetLocalInt(oSource, preDefStr + "X2_L_STOPCASTING"));
    SetLocalInt(oTarget, preSrcStr + "X2_HENCH_DO_NOT_DISPEL",
        GetLocalInt(oSource, preDefStr + "X2_HENCH_DO_NOT_DISPEL"));
    SetLocalInt(oTarget, preSrcStr + "HENCH_ASSOCIATE_SETTINGS",
        GetLocalInt(oSource, preDefStr + "HENCH_ASSOCIATE_SETTINGS"));
}




void SCClearForceOptions( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCClearForceOptions Start", GetFirstPC() ); }
    
    DeleteLocalObject(oCharacter, "tk_master_lock_failed");
    DeleteLocalInt(oCharacter, "tk_force_trap");
}


void SCOpenLock(object oLock, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCOpenLock Start", GetFirstPC() ); }
    
    if (GetIsObjectValid(oLock))
    {
        SetLocalObject(oCharacter, "tk_master_lock_failed", oLock);
        ExecuteScript("hench_o0_act", oCharacter);
    }
}


void SCForceTrap(object oTrap, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCForceTrap Start", GetFirstPC() ); }
    
    if (GetIsObjectValid(oTrap))
    {
        SetLocalObject(oCharacter, "tk_master_lock_failed", oTrap);
        SetLocalInt(oCharacter, "tk_force_trap", TRUE);
        ExecuteScript("hench_o0_act", oCharacter);
    }
}


void SCHenchResetHenchmenState( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchResetHenchmenState Start", GetFirstPC() ); }
    
    SetCommandable(TRUE);
    DeleteLocalObject(oCharacter, "NW_GENERIC_DOOR_TO_BASH");
    DeleteLocalInt(oCharacter, "NW_GENERIC_DOOR_TO_BASH_HP");
    DeleteLocalInt(oCharacter, "HenchCurHealCount");
    DeleteLocalInt(oCharacter, "HenchHealType");
    DeleteLocalInt(oCharacter, "HenchHealState");
    DeleteLocalObject(oCharacter, "Henchman_Spell_Target");
    CSLSetAssociateState(CSL_ASC_IS_BUSY, FALSE);
    SCClearForceOptions();
    ClearAllActions();
}


void SCSetHenchAssociateState(int nCondition, int bValid, object oCharacter)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetHenchAssociateState Start", GetFirstPC() ); }
    
    int nPlot = GetLocalInt(oCharacter, "HENCH_ASSOCIATE_SETTINGS");
    if(bValid)
    {
        nPlot = nPlot | nCondition;
    }
    else
    {
        nPlot = nPlot & ~nCondition;
    }
    SetLocalInt(oCharacter, "HENCH_ASSOCIATE_SETTINGS", nPlot);
}


void SCSetHenchPartyState(int nCondition, int bValid, object oCharacter)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetHenchPartyState Start", GetFirstPC() ); }
    
    object oPlayerCharacter = GetOwnedCharacter(GetFactionLeader(oCharacter));
    int nPlot = GetLocalInt(oPlayerCharacter, "HENCH_PARTY_SETTINGS");
    if(bValid)
    {
        nPlot = nPlot | nCondition;
    }
    else
    {
        nPlot = nPlot & ~nCondition;
    }
    SetLocalInt(oPlayerCharacter, "HENCH_PARTY_SETTINGS", nPlot);
}


void SCHenchClearPersistedObject(object oTarget, string storageString)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchClearPersistedObject Start "+GetName(oTarget), GetFirstPC() ); }
    
    DeleteLocalObject(oTarget, storageString);
    DeleteLocalString(oTarget, storageString);
    DeleteLocalInt(oTarget, storageString);
}


object SCHenchGetPersistedObject(object oTarget, string storageString, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetPersistedObject Start "+GetName(oTarget), GetFirstPC() ); }
    
    object oObject = GetLocalObject(oTarget, storageString);

    if (!GetIsObjectValid(oObject))
    {
        string tagToFollow = GetLocalString(oTarget, storageString);
        if (tagToFollow != "")
        {
            oObject = GetObjectByTag(tagToFollow);
            if (GetIsObjectValid(oObject))
            {
				if (GetFactionEqual(oObject, oTarget))
				{
					SetLocalObject(oTarget, storageString, oObject);
				}
				else
				{
					oObject = OBJECT_INVALID;
				}
            }
            else
            {
				// check if name was used instead
				object oPartyMember = GetFirstFactionMember(oCharacter, FALSE);
				while(GetIsObjectValid(oPartyMember))
				{
					//DEBUGGING// igDebugLoopCounter += 1;
					if (GetName(oPartyMember) == tagToFollow)
					{
						break;					
					}
					oPartyMember = GetNextFactionMember(oCharacter, FALSE);
				}
				if (GetIsObjectValid(oPartyMember))
				{				
					oObject = oPartyMember;				
				}
				else
				{
                	DeleteLocalString(oTarget, storageString);
				}
            }
        }
    }
    if (GetIsObjectValid(oObject))
    {
        if (!GetFactionEqual(oObject, oTarget))
        {
            oObject = OBJECT_INVALID;
            SCHenchClearPersistedObject(oTarget, storageString);
        }
        else
        {
            int assocType = GetLocalInt(oTarget, storageString);
            if (assocType != GetAssociateType(oObject))
            {
                object oAssociate = GetAssociate(assocType, oObject);
                if (GetIsObjectValid(oAssociate))
                {
                    oObject = oAssociate;
                    SetLocalObject(oTarget, storageString, oObject);
                }
            }
        }
    }
    return oObject;
}


void SCHenchSetPersistedObject(object oTarget, object oObject, string storageString)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchSetPersistedObject Start "+GetName(oTarget), GetFirstPC() ); }
    
    int assocType = GetAssociateType(oObject);
    if (assocType != ASSOCIATE_TYPE_NONE)
    {
        oObject = GetMaster(oObject);
    }
    SetLocalObject(oTarget, storageString, oObject);
	string tagToFollow = GetTag(oObject);
	if (tagToFollow == "")
	{
		tagToFollow = GetName(oObject);	
	}	
    SetLocalString(oTarget, storageString, tagToFollow);
    SetLocalInt(oTarget, storageString, assocType);

    // prevent circular leaders
    object oNextObject = oObject;
    while (GetIsObjectValid(oNextObject))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (oNextObject == oTarget)
        {
            SCHenchClearPersistedObject(oNextObject, storageString);
            break;
        }
        oNextObject = SCHenchGetPersistedObject(oNextObject, storageString);
    }
}



object SCHenchGetFollowLeader( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetFollowLeader Start", GetFirstPC() ); }
    
    if (GetLocalInt(oCharacter, "DoNotAttack"))
    {
        return CSLGetCurrentMaster();
    }
    else
    {
        object oLeader = SCHenchGetPersistedObject(oCharacter, "HenchFollowTarget");
        if (GetIsObjectValid(oLeader))
        {
            return oLeader;
        }
        else if (!GetLocalInt(oCharacter, "HenchFollowTarget"))
        {
            return CSLGetCurrentMaster();
        }
        else
        {
            return OBJECT_INVALID;
        }
    }
}


void SCHenchFollowLeader( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchFollowLeader Start", GetFirstPC() ); }
	
	if (CSLGetAssociateState(CSL_ASC_MODE_PUPPET) && !((GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR) || SCGetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW)))
	{
		return;
	}
    object oLeader =  SCHenchGetFollowLeader();
    if (GetCurrentAction() == ACTION_FOLLOW)
    {
        ClearAllActions();
    }	
    if (!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) && GetIsObjectValid(oLeader))
    {
        ActionForceFollowObject(oLeader, CSLGetFollowDistance());
    }
}


void SCHenchSetLeader(object oTarget, object oLeader, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchSetLeader Start "+GetName(oTarget), GetFirstPC() ); }
    
    SCHenchSetPersistedObject(oTarget, oLeader, "HenchFollowTarget");
    DeleteLocalInt(oTarget, "HenchFollowTarget");
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == oCharacter)
        {
            SCHenchFollowLeader();
        }
        else
        {
            AssignCommand(oTarget, SCHenchFollowLeader());
        }
    }
}


void SCHenchSetNoLeader(object oTarget, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchSetNoLeader Start "+GetName(oTarget), GetFirstPC() ); }
    
    SCHenchClearPersistedObject(oTarget, "HenchFollowTarget");
    SetLocalInt(oTarget, "HenchFollowTarget", TRUE);
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == oCharacter)
        {
            ClearAllActions();
        }
        else
        {
            AssignCommand(oTarget, ClearAllActions());
        }
    }
}


void SCHenchSetDefaultLeader(object oTarget, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchSetDefaultLeader Start "+GetName(oTarget), GetFirstPC() ); }
    
    SCHenchClearPersistedObject(oTarget, "HenchFollowTarget");
    DeleteLocalInt(oTarget, "HenchFollowTarget");
    if ((GetCurrentAction(oTarget) == ACTION_FOLLOW) && !GetIsPC(oTarget))
    {
        if (oTarget == oCharacter)
        {
            SCHenchFollowLeader();
        }
        else
        {
            AssignCommand(oTarget, SCHenchFollowLeader());
        }
    }
}



object SCHenchGetDefendee( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetDefendee Start", GetFirstPC() ); }
    
    object oDefendee = SCHenchGetPersistedObject(oCharacter, "HenchDefendTarget");
    if (GetIsObjectValid(oDefendee))
    {
        return oDefendee;
    }
    return CSLGetCurrentMaster();
}


void SCHenchSetDefendee(object oTarget, object oDefendee)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchSetDefendee Start "+GetName(oTarget), GetFirstPC() ); }
    
    SCHenchSetPersistedObject(oTarget, oDefendee, "HenchDefendTarget");
}


void SCHenchSetDefaultDefendee(object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchSetDefaultDefendee Start "+GetName(oTarget), GetFirstPC() ); }
    
    SCHenchClearPersistedObject(oTarget, "HenchDefendTarget");
}


int SCGetHenchAssociateState(int nCondition, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetHenchAssociateState Start", GetFirstPC() ); }
    
    int result = GetLocalInt(oCharacter, "HENCH_ASSOCIATE_SETTINGS");
    if (!result)
    {
        // check global setting to disable
        if (GetIsObjectValid(GetFactionLeader(oCharacter)) && !SCGetHenchOption(HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET))
        {
            result |=  HENCH_ASC_BEEN_SET_ONCE | HENCH_ASC_ENABLE_HEALING_ITEM_USE |
				HENCH_ASC_DISABLE_POLYMORPH;
            int iBABLevel;
			if (GetRacialType(oCharacter) == RACIAL_TYPE_UNDEAD)
			{
				iBABLevel = 1;
			}
            else
            {
                int iBABTest = 10 * GetBaseAttackBonus(oCharacter);
				int iHitDice = GetHitDice(oCharacter);
                if (iBABTest >= 8 * iHitDice)
                {
                    iBABLevel = 2;  // high BAB creature
                }
                else if (iBABTest >= 6 * iHitDice)
                {
                    iBABLevel = 1; // medium BAB creature
                }
                else
                {
                    iBABLevel = 0; // low BAB creature
                }
            }
            if (GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCharacter)))
            {
                iBABLevel = 0; // treat as low BAB creature in order to keep using ranged weapons
                CSLSetAssociateState(CSL_ASC_USE_RANGED_WEAPON, TRUE, oCharacter);
            }
            int associateType = GetAssociateType(oCharacter);
            if ((associateType == ASSOCIATE_TYPE_NONE) || (associateType == ASSOCIATE_TYPE_HENCHMAN))
            {
                // still allow use of ranged weapons (prevents running off)
                CSLSetAssociateState(CSL_ASC_USE_RANGED_WEAPON, TRUE, oCharacter);
            }
            // set follow and switch to melee distance
            if (iBABLevel == 0) // low BAB creature
            {
                CSLSetAssociateState(CSL_ASC_DISTANCE_2_METERS, FALSE, oCharacter);
                CSLSetAssociateState(CSL_ASC_DISTANCE_4_METERS, FALSE, oCharacter);
                CSLSetAssociateState(CSL_ASC_DISTANCE_6_METERS, TRUE, oCharacter);
                result |= HENCH_ASC_MELEE_DISTANCE_NEAR | HENCH_ASC_ENABLE_BACK_AWAY;
            }
            else if (iBABLevel == 1) // medium BAB creature
            {
                CSLSetAssociateState(CSL_ASC_DISTANCE_2_METERS, FALSE, oCharacter);
                CSLSetAssociateState(CSL_ASC_DISTANCE_4_METERS, TRUE, oCharacter);
                CSLSetAssociateState(CSL_ASC_DISTANCE_6_METERS, FALSE, oCharacter);
                result |= HENCH_ASC_MELEE_DISTANCE_MED;
            }
            else // high BAB creature
            {
                CSLSetAssociateState(CSL_ASC_DISTANCE_2_METERS, TRUE, oCharacter);
                CSLSetAssociateState(CSL_ASC_DISTANCE_4_METERS, FALSE, oCharacter);
                CSLSetAssociateState(CSL_ASC_DISTANCE_6_METERS, FALSE, oCharacter);
                result |= HENCH_ASC_MELEE_DISTANCE_FAR | HENCH_ASC_MELEE_DISTANCE_ANY;
            }
            // set overkill casting mode
            CSLSetAssociateState(CSL_ASC_OVERKIll_CASTING, TRUE, oCharacter);
            CSLSetAssociateState(CSL_ASC_POWER_CASTING, FALSE, oCharacter);
            CSLSetAssociateState(CSL_ASC_SCALED_CASTING, FALSE, oCharacter);
            DeleteLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED");
            SetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL", 10);
        }
        SetLocalInt(oCharacter, "HENCH_ASSOCIATE_SETTINGS", result);
    }
     //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCGetHenchAssociateState End", GetFirstPC() ); }
    return result & nCondition;
}



object SCGetTopMaster(object oAssociate = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetTopMaster Start", GetFirstPC() ); }
    
    object oMaster = GetMaster(oAssociate);
    if (GetIsObjectValid(oMaster) && GetAssociateType(oMaster) == ASSOCIATE_TYPE_HENCHMAN)
    {
        return oMaster;
    }
    return oAssociate;
}


void SCHenchCheckOutOfCombatStealth(object oRealMaster, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckOutOfCombatStealth Start", GetFirstPC() ); }
    
    if (!(GetLocalInt(oCharacter, "DoNotAttack") && !SCGetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE)))
    {
        // Check to see if should re-enter stealth mode
        int nStealth = GetLocalInt(SCGetTopMaster(), "X2_HENCH_STEALTH_MODE");
        if ((nStealth == 1) || (nStealth == 2))
        {
            if (!GetActionMode(oCharacter, ACTION_MODE_STEALTH))
            {
                SetActionMode(oCharacter, ACTION_MODE_STEALTH, TRUE);
            }
        }
        else
        {
            if (SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE) ||
				!GetActionMode(oRealMaster, ACTION_MODE_STEALTH))
            {
                SetActionMode(oCharacter, ACTION_MODE_STEALTH, FALSE);
            }
        }
    }
}


void SCHenchPlayerControlPossessed( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchPlayerControlPossessed Start", GetFirstPC() ); }
    
    object oLeader = GetFactionLeader( oCharacter );
    if ( oLeader == oCharacter )
    {
        object oPM = GetFirstFactionMember( oCharacter, FALSE );
        while ( GetIsObjectValid( oPM ) == TRUE )
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            // If I'm currently following somebody
            if ( GetCurrentAction( oPM ) == ACTION_FOLLOW )
            {
                // But I'm not possessed, not myself, and not an associate
                if ( ( GetIsPC( oPM ) == FALSE ) &&
                     ( oPM != oLeader ) &&
                     ( GetAssociateType( oPM ) == ASSOCIATE_TYPE_NONE ) &&
 						(!CSLGetAssociateState(CSL_ASC_MODE_PUPPET, oPM) || SCGetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW)))
               {
                    AssignCommand( oPM, ClearAllActions() );
                    AssignCommand( oPM, SCHenchFollowLeader());
                }
            }

            oPM = GetNextFactionMember( oCharacter, FALSE );
        }
    }
}


void SCHenchHandlePlayerControlChanged( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchHandlePlayerControlChanged Start", GetFirstPC() ); }
    
    if (GetIsPC(oCharacter))
    {
        SCHenchPlayerControlPossessed(oCharacter);
    }
    else
    {
		if (GetCurrentAction(oCharacter) == ACTION_ATTACKOBJECT)
		{
			SetLocalObject(oCharacter, "HenchLastPlayerAttackTarget", GetAttemptedAttackTarget());
		}
		else
		{
			DeleteLocalObject(oCharacter, "HenchLastPlayerAttackTarget");
		}	
        SCPlayerControlUnpossessed(oCharacter);
    }
}


void SCHenchGuiBehaviorInit(object oPlayerObject, object oTargetObject, string sScreen, int bFirstTime = FALSE )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGuiBehaviorInit Start", GetFirstPC() ); }
    
    SCHenchGetDefSettings(oTargetObject);
    SCHenchSetDefSettings(oTargetObject);

    int iState;

    // associate settings

        // weapon switching
    iState = SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_WEAPON_SWITCH_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_WEAPON_SWITCH_STATE_BUTTON_OFF", iState);

        // use ranged weapons
    iState = CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RANGED_WEAPONS_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RANGED_WEAPONS_STATE_BUTTON_OFF", !iState);

        // switch to melee distance
    iState = SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_NEAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_NEAR", iState);
    iState = SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_MED, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_MED", iState);
    iState = SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MELEEDIST_STATE_BUTTON_FAR", iState);

        // back away
    iState = SCGetHenchAssociateState(HENCH_ASC_ENABLE_BACK_AWAY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_BACK_AWAY_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_BACK_AWAY_STATE_BUTTON_OFF", !iState);

        // summons
    iState = SCGetHenchAssociateState(HENCH_ASC_DISABLE_SUMMONS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SUMMONS_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SUMMONS_STATE_BUTTON_OFF", iState);

        // dual wielding
    iState = SCGetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_ON", iState);
    iState = SCGetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_OFF", iState);
    iState = SCGetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING, oTargetObject) || SCGetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DUAL_WIELDING_STATE_BUTTON_DEFAULT", !iState);

    // heavy off hand
    iState = SCGetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_HEAVY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HEAVY_OFF_HAND_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HEAVY_OFF_HAND_STATE_BUTTON_OFF", iState);

    // shield use
    iState = SCGetHenchAssociateState(HENCH_ASC_DISABLE_SHIELD_USE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SHIELD_USE_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_SHIELD_USE_STATE_BUTTON_OFF", iState);

    // recover traps
    iState = SCGetHenchAssociateState(HENCH_ASC_RECOVER_TRAPS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_STATE_BUTTON_ON", iState && SCGetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS, oTargetObject));
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_SAFE_STATE_BUTTON_ON", iState && !SCGetHenchAssociateState(HENCH_ASC_NON_SAFE_RECOVER_TRAPS, oTargetObject));
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RECOVER_TRAPS_STATE_BUTTON_OFF", !iState);

    // auto open locks
    iState = SCGetHenchAssociateState(HENCH_ASC_AUTO_OPEN_LOCKS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_OPEN_LOCKS_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_OPEN_LOCKS_STATE_BUTTON_OFF", !iState);

    // auto pickup
	iState = SCGetHenchAssociateState(HENCH_ASC_AUTO_PICKUP, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_PICKUP_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_PICKUP_STATE_BUTTON_OFF", !iState);

    // polymorph
    iState = SCGetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_POLYMORPH_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_POLYMORPH_STATE_BUTTON_OFF", iState);

    // infinite buff
    iState = SCGetHenchAssociateState(HENCH_ASC_DISABLE_INFINITE_BUFF, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_INFINITE_BUFF_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_INFINITE_BUFF_STATE_BUTTON_OFF", iState);

    // enable cure and healing item use
    iState = SCGetHenchAssociateState(HENCH_ASC_ENABLE_HEALING_ITEM_USE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_HEAL_ITEM_USE_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_HEAL_ITEM_USE_STATE_BUTTON_OFF", !iState);

    // disable automatic hiding
    iState = SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_HIDE, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HIDING_STATE_BUTTON_ON", !iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_HIDING_STATE_BUTTON_OFF", iState);

        // guard distance
    iState = SCGetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_NEAR", iState);
    iState = SCGetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_MED, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_MED", iState);
    iState = SCGetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_FAR", iState);
    iState = SCGetHenchAssociateState(HENCH_ASC_GUARD_DISTANCE_NEAR | HENCH_ASC_GUARD_DISTANCE_MED | HENCH_ASC_GUARD_DISTANCE_FAR, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_GUARDDIST_STATE_BUTTON_DEFAULT", !iState);

    string userText = GetStringByStrRef(232555); 	// Following
    object oLeader = SCHenchGetPersistedObject(oTargetObject, "HenchFollowTarget");
    if (GetIsObjectValid(oLeader))
    {
        userText += GetName(oLeader);
    }
    else if (!GetLocalInt(oTargetObject, "HenchFollowTarget"))
    {
        if (!GetAssociateType(oTargetObject))
        {
            userText += GetStringByStrRef(232556);	// PC
        }
        else
        {
            userText += GetStringByStrRef(232557);	// Master (default)
        }
    }
    else
    {
        userText += GetStringByStrRef(232558);	// no one
    }
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_FOLLOW_TARGET_BUTTON_TEXT", -1, userText);

    userText = GetStringByStrRef(232559);
    object oDefender = SCHenchGetPersistedObject(oTargetObject, "HenchDefendTarget");
    if (GetIsObjectValid(oDefender))
    {
        userText += GetName(oDefender);
    }
    else
    {
        if (!GetAssociateType(oTargetObject))
        {
            userText += GetStringByStrRef(232556);	// PC
        }
        else
        {
            userText += GetStringByStrRef(232557);	// Master (default)
        }
    }
    SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_DEFEND_TARGET_BUTTON_TEXT", -1, userText);

    // disable melee attacks
    iState = SCGetHenchAssociateState(HENCH_ASC_NO_MELEE_ATTACKS, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_MELEE_ATTACK_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISABLE_MELEE_ATTACK_STATE_BUTTON_OFF", !iState);

    // use melee weapons if any members of party are in melee range of target
    iState = SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_ANY, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_MELEE_ANY_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ENABLE_MELEE_ANY_STATE_BUTTON_OFF", !iState);

    // pause every round if in puppet mode and pause and switch is turned on
	if (bFirstTime)
	{
		SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_EVERY_ROUND_COL_HEADER", -1, "Puppet mode pause every round");
	}
    iState = SCGetHenchAssociateState(HENCH_ASC_PAUSE_EVERY_ROUND, oTargetObject);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_EVERY_ROUND_STATE_BUTTON_ON", iState);
    SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_EVERY_ROUND_STATE_BUTTON_OFF", !iState);

    if (sScreen == "SCREEN_CHARACTER")
    {
        // party options

        // unequip weapons outside of combat
        iState = SCGetHenchPartyState(HENCH_PARTY_UNEQUIP_WEAPONS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_UNEQUIP_WEAPONS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_UNEQUIP_WEAPONS_STATE_BUTTON_OFF", !iState);

        // summon familiars outside of combat
        iState = SCGetHenchPartyState(HENCH_PARTY_SUMMON_FAMILIARS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_FAMILIARS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_FAMILIARS_STATE_BUTTON_OFF", !iState);

        // summon animal companions outside of combat
        iState = SCGetHenchPartyState(HENCH_PARTY_SUMMON_COMPANIONS, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_COMPANIONS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SUMMON_COMPANIONS_STATE_BUTTON_OFF", !iState);
		
        // ally damage
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_LOW", SCGetHenchPartyState(HENCH_PARTY_LOW_ALLY_DAMAGE, oTargetObject) || 
			!(SCGetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, oTargetObject) || SCGetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, oTargetObject)));
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_MED", SCGetHenchPartyState(HENCH_PARTY_MEDIUM_ALLY_DAMAGE, oTargetObject));
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ALLY_DAMAGE_STATE_BUTTON_HIGH", SCGetHenchPartyState(HENCH_PARTY_HIGH_ALLY_DAMAGE, oTargetObject));		

        // disable peaceful follow mode
        iState = SCGetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PEACEFUL_FOLLOW_STATE_BUTTON_ON", !iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PEACEFUL_FOLLOW_STATE_BUTTON_OFF", iState);

        // disable self buff or heal
        iState = SCGetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SELF_BUFF_OR_HEAL_STATE_BUTTON_ON", !iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_SELF_BUFF_OR_HEAL_STATE_BUTTON_OFF", iState);

        // disable showing weapon switching messages
		if (bFirstTime)
		{
			SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_WEAP_SWITCH_MESS_COL_HEADER", -1, "Weapon switching messages (Party)");
		}
        iState = SCGetHenchPartyState(HENCH_PARTY_DISABLE_WEAPON_EQUIP_MSG, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_WEAP_SWITCH_MESS_STATE_BUTTON_ON", !iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_WEAP_SWITCH_MESS_STATE_BUTTON_OFF", iState);

        // disable showing weapon switching messages
		if (bFirstTime)
		{
			SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_PUPPET_FOLLOW_COL_HEADER", -1, "Puppet follow (Party)");
		}
        iState = SCGetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW, oTargetObject);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PUPPET_FOLLOW_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PUPPET_FOLLOW_STATE_BUTTON_OFF", !iState);
								
        // global options

        // monster stealth
        iState = SCGetHenchOption(HENCH_OPTION_STEALTH);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_STEALTH_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_STEALTH_STATE_BUTTON_OFF", !iState);

        // monster wander
        iState = SCGetHenchOption(HENCH_OPTION_WANDER);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_WANDER_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_WANDER_STATE_BUTTON_OFF", !iState);

        // monster open doors
        iState = SCGetHenchOption(HENCH_OPTION_OPEN);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_OPEN_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_OPEN_STATE_BUTTON_OFF", !iState);

        // monster unlock doors
        iState = SCGetHenchOption(HENCH_OPTION_UNLOCK);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_UNLOCK_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_UNLOCK_STATE_BUTTON_OFF", !iState);

        // knockdown
        iState = SCGetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED);
        if (iState)
        {
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_ON", FALSE);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_SOMETIMES", FALSE);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_OFF", TRUE);
        }
        else
        {
            iState = SCGetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_ON", !iState);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_SOMETIMES", iState);
            SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_KNOCKDOWN_STATE_BUTTON_OFF", FALSE);
        }

        // auto behavior set
        iState = SCGetHenchOption(HENCH_OPTION_DISABLE_AUTO_BEHAVIOR_SET);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BEHAVIOR_SET_STATE_BUTTON_OFF", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BEHAVIOR_SET_STATE_BUTTON_ON", !iState);

        // non members of PC party automatically use long duration buffs at start of combat
        iState = SCGetHenchOption(HENCH_OPTION_ENABLE_AUTO_BUFF);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_LONG_STATE_BUTTON_ON", iState && !SCGetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_MED_STATE_BUTTON_ON", iState && SCGetHenchOption(HENCH_OPTION_ENABLE_AUTO_MEDIUM_BUFF));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_BUFF_STATE_BUTTON_OFF", !iState);

        // non members of PC party get healing potions, etc. at start of combat
        iState = SCGetHenchOption(HENCH_OPTION_ENABLE_ITEM_CREATION);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_CREATE_ITEMS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_AUTO_CREATE_ITEMS_STATE_BUTTON_OFF", !iState);

        // non members of PC party are able to use equipped items (run at start of combat)
        iState = SCGetHenchOption(HENCH_OPTION_ENABLE_EQUIPPED_ITEM_USE);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_USE_EQUIPPED_ITEMS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_USE_EQUIPPED_ITEMS_STATE_BUTTON_OFF", !iState);

        // Warlock hideous blow single round
        iState = SCGetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HIDEOUS_BLOW_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HIDEOUS_BLOW_STATE_BUTTON_OFF", !iState);
		
        // Monster ally damage (area of effect spells)
        iState = SCGetHenchOption(HENCH_OPTION_MONSTER_ALLY_DAMAGE);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_ALLY_DAMAGE_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_MONSTER_ALLY_DAMAGE_STATE_BUTTON_OFF", !iState);
	
        // heartbeat detection of enemies
		if (bFirstTime)
		{
        	SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_COL_HEADER", -1, "Heartbeat detection of enemies (Global)");
        	SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_SEEN_TEXT_BUTTON_ON", -1, "Seen only");
		}
        iState = SCGetHenchOption(HENCH_OPTION_DISABLE_HB_DETECTION);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_STATE_BUTTON_ON", !iState && !SCGetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_SEEN_STATE_BUTTON_ON", !iState && SCGetHenchOption(HENCH_OPTION_DISABLE_HB_HEARING));
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_HB_DETECTION_STATE_BUTTON_OFF", iState);

        // puppet mode pause and switch
		if (bFirstTime)
		{
        	SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_AND_SWITCH_COL_HEADER", -1, "Pause and switch control (Global)");
		}
        iState = SCGetHenchOption(HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_AND_SWITCH_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_AND_SWITCH_STATE_BUTTON_OFF", !iState);

		// pause for traps
		if (bFirstTime)
		{
        	SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_FOR_TRAPS_COL_HEADER", -1, "Pause for traps (Global)");
		}
        iState = SCGetHenchOption(HENCH_OPTION_ENABLE_PAUSE_FOR_TRAPS);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_FOR_TRAPS_STATE_BUTTON_ON", iState);
        SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PAUSE_FOR_TRAPS_STATE_BUTTON_OFF", !iState);
	}
}


int SCHenchCheckPartyMemberInCombat(object oPartyMember)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckPartyMemberInCombat Start", GetFirstPC() ); }
    
    object oClosestSeen = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                    oPartyMember, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
                    CREATURE_TYPE_IS_ALIVE, TRUE);
    if (GetIsObjectValid(oClosestSeen) && (GetDistanceBetween(oPartyMember, oClosestSeen) < 20.0))
    {
        return TRUE;
    }
    object oClosestHeard = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
                    oPartyMember, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,
                    CREATURE_TYPE_IS_ALIVE, TRUE);
   	return GetIsObjectValid(oClosestHeard) && (GetDistanceBetween(oPartyMember, oClosestHeard) < 20.0) &&
		LineOfSightObject(oPartyMember, oClosestHeard);
}


int SCHenchCheckPlayerPause( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckPlayerPause Start", GetFirstPC() ); }
	
	if (!SCGetHenchOption(HENCH_OPTION_ENABLE_PAUSE_AND_SWITCH))
	{
		return FALSE;
	}
	
	// make sure not disabled
	if (GetCurrentHitPoints(oCharacter) <= 0)
	{
		return FALSE;
	}
	effect eCurEffect = GetFirstEffect(oCharacter);
	while (GetIsEffectValid(eCurEffect))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		switch (GetEffectType(eCurEffect))
		{
			case EFFECT_TYPE_PARALYZE:
			case EFFECT_TYPE_STUNNED:
			case EFFECT_TYPE_FRIGHTENED:
			case EFFECT_TYPE_SLEEP:
			case EFFECT_TYPE_CONFUSED:
			case EFFECT_TYPE_TURNED:
			case EFFECT_TYPE_PETRIFY:
				return FALSE;
		}
		eCurEffect = GetNextEffect(oCharacter);			
	}		
	
	int bEnemyFound;
    object oPartyMember = GetFirstFactionMember(oCharacter, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		// don't interrupt cutscenes
		if (IsInMultiplayerConversation(oPartyMember))
		{
			return FALSE;
		}
		if (SCHenchCheckPartyMemberInCombat(oPartyMember))
		{
			bEnemyFound = TRUE;
		}
        oPartyMember = GetNextFactionMember(oCharacter, FALSE);
    }
	if (!bEnemyFound)
	{
		return FALSE;
	}
		
	
	if (SCGetHenchAssociateState(HENCH_ASC_PAUSE_EVERY_ROUND) ||
		(GetCurrentAction() != ACTION_ATTACKOBJECT) ||
		(GetLocalObject(oCharacter, "HenchLastPlayerAttackTarget") != GetAttemptedAttackTarget()))
	{
		SetPause(TRUE);		
		// this call crashes the toolset when compiling
//		if (!GetIsCompanionPossessionBlocked(oCharacter))
		{
			SetOwnersControlledCompanion(GetFactionLeader(oCharacter), oCharacter);		
		}
		return TRUE;			
	}	
	return FALSE;			
}


void SCHenchPauseForTraps( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchPauseForTraps Start", GetFirstPC() ); }
	
	if (!SCGetHenchOption(HENCH_OPTION_ENABLE_PAUSE_FOR_TRAPS))
	{
		return;
	}
	if (GetObjectType(GetLastTrapDetected()) != OBJECT_TYPE_TRIGGER)
	{
		return;
	}		
    object oPartyMember = GetFirstFactionMember(oCharacter, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		// don't interrupt cutscenes
		if (IsInMultiplayerConversation(oPartyMember))
		{
			return;
		}
        oPartyMember = GetNextFactionMember(oCharacter, FALSE);
    }
	SpeakString(GetName(oCharacter) + " found a trap");
	DelayCommand(0.1, SetPause(TRUE));	// wait for red trap highlight to show	
}



// have party check out trap if needed
void SCHenchTrapDetected( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTrapDetected Start", GetFirstPC() ); }
	
	//CSLMessage_PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(oCharacter, FALSE);
    while(GetIsObjectValid(oPartyMember))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		int nAssocType = GetAssociateType(oPartyMember);
 		if (oPartyMember != oCharacter && !GetIsPC(oPartyMember) && (nAssocType == ASSOCIATE_TYPE_NONE ||
			nAssocType == ASSOCIATE_TYPE_HENCHMAN || nAssocType == ASSOCIATE_TYPE_FAMILIAR))
		{
			SignalEvent(oPartyMember, EventUserDefined(HENCH_EVENT_PARTY_SAW_TRAP));
		}
        oPartyMember = GetNextFactionMember(oCharacter, FALSE);
    }
}





void SCSetNonActiveEnemy(object oTarget, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetNonActiveEnemy Start "+GetName(oTarget), GetFirstPC() ); }
	
	if (GetFactionEqual(oTarget, oCharacter))
	{
		// ignore faction members that somehow have been marked hostile
		if (GetObjectSeen(oTarget) && (GetLocalInt(oTarget, "HenchCurNegEffects") & HENCH_EFFECT_TYPE_CHARMED))
		{
			if (!GetIsObjectValid(goCharmedAlly) || (SCGetRawThreatRating(oTarget) > SCGetRawThreatRating(goCharmedAlly)))
			{
				goCharmedAlly = oTarget;			
			}
		}
		return;	
	}	
    if (!GetIsObjectValid(goClosestNonActiveEnemy))
    {
        goClosestNonActiveEnemy = oTarget;
        return;
    }
    if (GetPlotFlag(oTarget))
    {
        return;
    }
    if (GetPlotFlag(goClosestNonActiveEnemy))
    {
        goClosestNonActiveEnemy = oTarget;
        return;
    }
    if (giIntelligenceLevel <= HENCH_INT_LOW)
    {
        goClosestNonActiveEnemy = oTarget;
        return;
    }
    if (GetLocalInt(oTarget, "RunningAway"))
    {
        return;
    }
    if (GetLocalInt(goClosestNonActiveEnemy, "RunningAway"))
    {
        goClosestNonActiveEnemy = oTarget;
        return;
    }
}


void SCInitializeBasicTargetInfo( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeBasicTargetInfo Start", GetFirstPC() ); }
    int iIteration = 1;

    gfAdjustedThreatRating = SCGetRawThreatRating(oCharacter);
    int iIntelligence = GetAbilityScore(oCharacter, ABILITY_INTELLIGENCE);
    if (iIntelligence < 6)
    {
        giIntelligenceLevel = HENCH_INT_VERY_LOW;
    }
    else if (iIntelligence < 8)
    {
        giIntelligenceLevel = HENCH_INT_LOW;
    }
    else if (iIntelligence < 13)
    {
        giIntelligenceLevel = HENCH_INT_AVG;
    }
    else if (iIntelligence < 17)
    {
        giIntelligenceLevel = HENCH_INT_HIGH;
    }
    else
    {
        giIntelligenceLevel = HENCH_INT_VERY_HIGH;
    }

    iIteration = 1;
    goClosestSeenEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    while ( GetIsObjectValid(goClosestSeenEnemy) )
    {
         //DEBUGGING// igDebugLoopCounter += 1;
         //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeBasicTargetInfo seen start "+GetName( goClosestSeenEnemy ), GetFirstPC() ); }
         giCurSeenCreatureCount = iIteration;
        
        if (GetPlotFlag(goClosestSeenEnemy))
		{
			// special test for zombies attacking Slaan
			if ((GetTag(GetArea(oCharacter)) != "HighCliffManorExterior") || (FindSubString(GetTag(oCharacter), "ombie") < 0))
			{
            	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "running SCSetNonActiveEnemy from SCInitializeBasicTargetInfo1", GetFirstPC() ); }
            	SCSetNonActiveEnemy(goClosestSeenEnemy);
			}
		}
		else if(GetLocalInt(goClosestSeenEnemy, "RunningAway") || ((giIntelligenceLevel > HENCH_INT_LOW) ?
            (SCGetCreatureNegEffects(goClosestSeenEnemy) & HENCH_EFFECT_DISABLED) :
			(SCGetCreatureNegEffects(goClosestSeenEnemy) & HENCH_EFFECT_TYPE_CHARMED)))
        {
            //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "running SCSetNonActiveEnemy from SCInitializeBasicTargetInfo2", GetFirstPC() ); }
            SCSetNonActiveEnemy(goClosestSeenEnemy);
        }
        // never consider dying henchman
        else if (!CSLGetAssociateState(CSL_ASC_MODE_DYING, goClosestSeenEnemy))
        {
            break;
        }
        iIteration++;
        if ( iIteration > 50 ) // safety here
    	{
    		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeBasicTargetInfo seen greater than 50 escaping "+GetName( goClosestSeenEnemy ), GetFirstPC() ); }
    		break;
    	}
        goClosestSeenEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    }
	
	iIteration = 1;
    goClosestHeardEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    while ( GetIsObjectValid(goClosestHeardEnemy) )
    {
       //DEBUGGING// igDebugLoopCounter += 1;
       giCurHeardCreatureCount = iIteration;
        //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeBasicTargetInfo heard start"+GetName( goClosestHeardEnemy ), GetFirstPC() ); }
       if (SCHenchEnemyOnOtherSideOfDoor(goClosestHeardEnemy))
        {
            // ignore creatures on other side of checked door
            goClosestHeardEnemy = OBJECT_INVALID;
            break;  // don't keep checking
        }
        else if (GetPlotFlag(goClosestHeardEnemy) ||  GetLocalInt(goClosestHeardEnemy, "RunningAway") || ((giIntelligenceLevel > HENCH_INT_LOW) ?
            (SCGetCreatureNegEffects(goClosestHeardEnemy) & HENCH_EFFECT_DISABLED) :
			(SCGetCreatureNegEffects(goClosestHeardEnemy) & HENCH_EFFECT_TYPE_CHARMED)))
        {
            //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "running SCSetNonActiveEnemy from SCInitializeBasicTargetInfo3", GetFirstPC() ); }
            SCSetNonActiveEnemy(goClosestHeardEnemy);
        }
        // never consider dying henchman
        else if (!CSLGetAssociateState(CSL_ASC_MODE_DYING, goClosestHeardEnemy))
        {
            break;
        }
        
        iIteration++;
        if ( iIteration > 50 ) // safety here
    	{
    			//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeBasicTargetInfo heard greater than 50 escaping "+GetName( goClosestHeardEnemy ), GetFirstPC() ); }
    		break;
    	}
    	goClosestHeardEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    }
    gbLineOfSightHeardEnemy = GetIsObjectValid(goClosestHeardEnemy) && LineOfSightObject(oCharacter, goClosestHeardEnemy);

    // find dying creatures to finish off
	if (!SCGetHenchOption(HENCH_OPTION_DISABLE_ATTACK_DYING))
	{
		int curCount = 1;
		iIteration = 1;
		object oDyingEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, FALSE);
		while (GetIsObjectValid(oDyingEnemy))
		{
			//DEBUGGING// igDebugLoopCounter += 1;
			curCount = iIteration;
			if (GetPlotFlag(oDyingEnemy))
			{
				// ignore plot creatures
			}
			else if (!GetIsDead(oDyingEnemy, TRUE))
			{
				// replace non active with dying to finish off
				goClosestNonActiveEnemy = oDyingEnemy;
				break;
			}
			
			iIteration++;
			if ( iIteration > 50 ) // safety here
			{
					//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeBasicTargetInfo heard greater than 50 escaping "+GetName( oDyingEnemy ), GetFirstPC() ); }
				break;
			}
			oDyingEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, FALSE);
		}
	}

    if (GetIsObjectValid(goClosestSeenEnemy))
    {
        if (GetIsObjectValid(goClosestHeardEnemy) &&
            (GetDistanceToObject(goClosestHeardEnemy) < GetDistanceToObject(goClosestSeenEnemy)))
        {
            goClosestSeenOrHeardEnemy = goClosestHeardEnemy;
        }
        else
        {
            goClosestSeenOrHeardEnemy = goClosestSeenEnemy;
        }
    }
    else
    {
        goClosestSeenOrHeardEnemy = goClosestHeardEnemy;
    }

    gbMeleeAttackers =  GetIsObjectValid(goClosestSeenOrHeardEnemy) && (GetDistanceToObject(goClosestSeenOrHeardEnemy) < 5.0) && (fabs(GetPosition(oCharacter).z - GetPosition(goClosestSeenOrHeardEnemy).z) < 2.0);

    if (gbMeleeAttackers && (goClosestSeenOrHeardEnemy == goClosestHeardEnemy) && !gbLineOfSightHeardEnemy)
    {
        gbMeleeAttackers = FALSE;
    }

    gbAnyValidTarget = GetIsObjectValid(goClosestSeenOrHeardEnemy) || GetIsObjectValid(goClosestNonActiveEnemy);
}



int SCInitializeSingleAlly(object oAlly, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeSingleAlly Start", GetFirstPC() ); }

    giSpecialTargeting = HENCH_SPECIAL_TARGETING_SINGLE;
    goOverrideTarget = oAlly;
    if (oAlly == oCharacter)
    {
        DeleteLocalObject(oCharacter, "HenchAllyList");
        DeleteLocalObject(oCharacter, "HenchAllyLineOfSight");
    }
    else
    {
        gfAdjustedThreatRating = 0.0;
        SetLocalObject(oCharacter, "HenchAllyLineOfSight", oAlly);
        DeleteLocalObject(oAlly, "HenchAllyLineOfSight");
        if (!GetObjectSeen(oAlly))
        {
            DeleteLocalObject(oCharacter, "HenchAllyList");
            return FALSE;
        }
        SetLocalObject(oCharacter, "HenchAllyList", oAlly);
        DeleteLocalObject(oAlly, "HenchAllyList");
    }
    return TRUE;
}


void SCInitializeAllyList(int bUseThreshold = TRUE, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeAllyList Start", GetFirstPC() ); }

    float myThreatRating = SCGetRawThreatRating(oCharacter);
    DeleteLocalObject(oCharacter, "HenchAllyLineOfSight");
    float fThresHold = bUseThreshold ? myThreatRating * 0.33 : -1000.0;
    int nMaxNumAlliesToFind = bUseThreshold ? 5 : 15;
    int alliesFound;

    int curCount;
    while ((curCount <= 30) && (alliesFound <= nMaxNumAlliesToFind))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		object oFriend = GetNearestObject(OBJECT_TYPE_CREATURE, oCharacter, ++curCount);
        if (!GetIsObjectValid(oFriend) || (GetDistanceToObject(oFriend) > 20.0))
        {
			break;
        }
		
		// hack, hack, hack - members of PC party are not "friends" but they can be found by searching neutrals with GetFactionEqual
		if (((bUseThreshold && GetIsFriend(oFriend)) || GetFactionEqual(oFriend)) && (GetObjectSeen(oFriend) || (GetDistanceToObject(oFriend) < 10.0) || LineOfSightObject(oCharacter, oFriend)))
        {
			int negEffects = SCGetCreatureNegEffects(oFriend);
			if (GetIsDead(oFriend))
			{
				if (GetIsDead(oFriend, TRUE))
				{
					if (!GetIsObjectValid(goDeadFriend) && GetObjectSeen(oFriend, oCharacter) && GetFactionEqual(oFriend) && (GetAssociateType(oFriend) == ASSOCIATE_TYPE_NONE))
					{
						goDeadFriend = oFriend;										
					} 				
					continue;
				}			
				negEffects |= HENCH_EFFECT_TYPE_DYING;
    			SetLocalInt(oFriend, "HenchCurNegEffects", negEffects);
			}
            int nAssocType = GetAssociateType(oFriend);
            if ((nAssocType != ASSOCIATE_TYPE_FAMILIAR) && !(negEffects & HENCH_EFFECT_DISABLED))
            {
                if (!GetIsObjectValid(goClosestSeenFriend) /* || (GetDistanceToObject(oFriend) < GetDistanceToObject(goClosestSeenFriend))*/)
                {
                    goClosestSeenFriend = oFriend;
                }
            }
            // remove summon, familiar, and dominated
            if ((nAssocType != ASSOCIATE_TYPE_DOMINATED) && (nAssocType != ASSOCIATE_TYPE_SUMMONED) &&  (nAssocType != ASSOCIATE_TYPE_FAMILIAR) )
            {
                float curThreatRating = SCGetRawThreatRating(oFriend);
                if (curThreatRating >= fThresHold)
                {
                    object oPrevTestObject = oCharacter;
                    object oTestObject = GetLocalObject(oCharacter, "HenchAllyLineOfSight");
                    while (GetIsObjectValid(oTestObject))
                    {
                        //DEBUGGING// igDebugLoopCounter += 1;
                        if (SCGetRawThreatRating(oTestObject) < curThreatRating)
                        {
                            break;
                        }
                        oPrevTestObject = oTestObject;
                        oTestObject = GetLocalObject(oTestObject, "HenchAllyLineOfSight");
                    }
                    SetLocalObject(oPrevTestObject, "HenchAllyLineOfSight", oFriend);
                    SetLocalObject(oFriend, "HenchAllyLineOfSight", oTestObject);

                    alliesFound++;
                }
            }
        }
    }
    // make ourselves better than our strongest friend
    object oBestFriend = GetLocalObject(oCharacter, "HenchAllyLineOfSight");
    if (GetIsObjectValid(oBestFriend))
    {
        float friendRating = SCGetRawThreatRating(oBestFriend) * 1.05;
        if (gfAdjustedThreatRating < friendRating)
        {
            gfAdjustedThreatRating = friendRating;
        }
    }
	object oCurObject = oCharacter;
	object oCurObjectSeen = oCharacter;
    while (GetIsObjectValid(oCurObject))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		if (GetObjectSeen(oCurObject))
		{
			SetLocalObject(oCurObjectSeen, "HenchAllyList", oCurObject);
			oCurObjectSeen = oCurObject;
		}
		oCurObject = GetLocalObject(oCurObject, "HenchAllyLineOfSight");
    }
    DeleteLocalObject(oCurObjectSeen, "HenchAllyList");
}


void SCInitializeTargetLists(object oIntruder, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeTargetLists Start", GetFirstPC() ); }

    SCInitializeAllyList();
	
	int iIteration = 1;
	
    goLastTarget = GetLocalObject(oCharacter, "LastTarget");
    if (GetIsObjectValid(oIntruder))
    {
        goOverrideTarget = oIntruder;
        gfOverrideTargetWeight = 10.0;
    }
    else
    {
        goOverrideTarget = goLastTarget;
        gfOverrideTargetWeight = 1.2;
    }

    // quick setup for low int creatures
    if (giIntelligenceLevel < HENCH_INT_AVG)
    {
        if (GetIsObjectValid(goClosestSeenEnemy))
        {
            SetLocalObject(oCharacter, "HenchObjectSeen", goClosestSeenEnemy);
            DeleteLocalObject(goClosestSeenEnemy, "HenchObjectSeen");
            SCGetThreatRating(goClosestSeenEnemy,oCharacter);
        }
        else
        {
            DeleteLocalObject(oCharacter, "HenchObjectSeen");
        }
        if (GetIsObjectValid(goClosestSeenOrHeardEnemy) && ((goClosestSeenOrHeardEnemy == goClosestSeenEnemy) || gbLineOfSightHeardEnemy))
        {
            SetLocalObject(oCharacter, "HenchLineOfSight", goClosestSeenOrHeardEnemy);
            DeleteLocalObject(goClosestSeenOrHeardEnemy, "HenchLineOfSight");
            SCGetThreatRating(goClosestSeenOrHeardEnemy,oCharacter);
        }
        else
        {
            DeleteLocalObject(oCharacter, "HenchLineOfSight");
        }
        // low int can still remember last target if seen
        if (giIntelligenceLevel == HENCH_INT_LOW && GetIsObjectValid(goLastTarget)
            && !GetIsDead(goLastTarget) && !GetLocalInt(goLastTarget, "RunningAway") && GetObjectSeen(goLastTarget))
        {
            SCGetThreatRating(goLastTarget,oCharacter);
            if (goLastTarget != goClosestSeenEnemy)
            {
                SetLocalObject(goClosestSeenEnemy, "HenchObjectSeen", goLastTarget);
                DeleteLocalObject(goLastTarget, "HenchObjectSeen");
            }
            if (goLastTarget != goClosestSeenOrHeardEnemy)
            {
                SetLocalObject(goClosestSeenOrHeardEnemy, "HenchLineOfSight", goLastTarget);
                DeleteLocalObject(goLastTarget, "HenchLineOfSight");
            }
        }
        return;
    }

    int iMaxNumberToFind = GetAbilityScore(oCharacter, ABILITY_INTELLIGENCE) - 5;
	if (iMaxNumberToFind > 15)
    {
        iMaxNumberToFind = 15;
    }

    if (GetIsObjectValid(goClosestSeenEnemy))
    {
        SetLocalObject(oCharacter, "HenchObjectSeen", goClosestSeenEnemy);
        DeleteLocalObject(goClosestSeenEnemy, "HenchObjectSeen");
        SCGetThreatRating(goClosestSeenEnemy,oCharacter);
		
		iIteration = 1;
		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeTargetLists1 loop1 start giCurSeenCreatureCount="+IntToString(iIteration), GetFirstPC() ); }
		object oCurSeen = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,  CREATURE_TYPE_IS_ALIVE, TRUE);
        while ( GetIsObjectValid(oCurSeen) && giCurSeenCreatureCount <= iMaxNumberToFind )
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeTargetLists1 loop1 giCurSeenCreatureCount="+IntToString(iIteration)+" Name="+GetName(oCharacter)+" who sees "+GetName(oCurSeen), GetFirstPC() ); }
			giCurSeenCreatureCount = iIteration;
			
            if (CSLGetAssociateState(CSL_ASC_MODE_DYING, oCurSeen))
            {
                // ignore dying creatures
            }
            else if (GetPlotFlag(oCurSeen) || GetLocalInt(oCurSeen, "RunningAway") ||  (SCGetCreatureNegEffects(oCurSeen) & HENCH_EFFECT_DISABLED))
            {
                //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "running SCSetNonActiveEnemy from SCInitializeTargetLists1", GetFirstPC() ); }
                SCSetNonActiveEnemy(oCurSeen);
            }
            else
            {
                float curThreat = SCGetThreatRating(oCurSeen,oCharacter);
                object oPrevTestObject = oCharacter;
                object oTestObject = GetLocalObject(oCharacter, "HenchObjectSeen");
                while (GetIsObjectValid(oTestObject))
                {
                    //DEBUGGING// igDebugLoopCounter += 1;
                    if (SCGetThreatRating(oTestObject,oCharacter) < curThreat)
                    {
                        break;
                    }
                    oPrevTestObject = oTestObject;
                    oTestObject = GetLocalObject(oTestObject, "HenchObjectSeen");
                }
                SetLocalObject(oPrevTestObject, "HenchObjectSeen", oCurSeen);
                SetLocalObject(oCurSeen, "HenchObjectSeen", oTestObject);
            }
            
            iIteration++;
            
            if ( iIteration > 50 ) // safety here
			{
				//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeTargetLists seen greater than 50 escaping "+GetName( goClosestSeenEnemy ), GetFirstPC() ); }
				break;
			}
            oCurSeen = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,  CREATURE_TYPE_IS_ALIVE, TRUE);
        }
    }
    else
    {
        if (GetIsObjectValid(goClosestNonActiveEnemy) && GetObjectSeen(goClosestNonActiveEnemy))
        {
            SetLocalObject(oCharacter, "HenchObjectSeen", goClosestNonActiveEnemy);
            DeleteLocalObject(goClosestNonActiveEnemy, "HenchObjectSeen");
        }
        else
        {
            DeleteLocalObject(oCharacter, "HenchObjectSeen");
        }
    }

    object oCurObject = oCharacter;
    while (GetIsObjectValid(oCurObject))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		object oNext = GetLocalObject(oCurObject, "HenchObjectSeen");

        SetLocalObject(oCurObject, "HenchLineOfSight", oNext);
        oCurObject = oNext;
    }

    if (GetIsObjectValid(goClosestHeardEnemy))
    {
        if (gbLineOfSightHeardEnemy)
        {
            float curThreat = SCGetThreatRating(goClosestHeardEnemy,oCharacter);

            object oPrevTestObject = oCharacter;
            object oTestObject = GetLocalObject(oCharacter, "HenchLineOfSight");
            while (GetIsObjectValid(oTestObject))
            {
                //DEBUGGING// igDebugLoopCounter += 1;
                //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeTargetLists1 loop2", GetFirstPC() ); }
                if (SCGetThreatRating(oTestObject,oCharacter) < curThreat)
                {
                    break;
                }
                oPrevTestObject = oTestObject;
                oTestObject = GetLocalObject(oTestObject, "HenchLineOfSight");
            }
            SetLocalObject(oPrevTestObject, "HenchLineOfSight", goClosestHeardEnemy);
            SetLocalObject(goClosestHeardEnemy, "HenchLineOfSight", oTestObject);
        }

        // limit the max number of heard targets to find, limit in any case to 3
        iMaxNumberToFind /= 2;
        if (iMaxNumberToFind > 3)
        {
            iMaxNumberToFind = 3;
        }
		
		
		iIteration = 1;
		object oCurHeard = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,  CREATURE_TYPE_IS_ALIVE, TRUE);
        while ( GetIsObjectValid(oCurHeard) && giCurHeardCreatureCount <= iMaxNumberToFind)
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            giCurHeardCreatureCount = iIteration;
            
            if (CSLGetAssociateState(CSL_ASC_MODE_DYING, oCurHeard) || !LineOfSightObject(oCharacter, oCurHeard))
            {
                // ignore dying creatures, not line of sight
            }
            else if (GetPlotFlag(oCurHeard) ||  GetLocalInt(oCurHeard, "RunningAway") || (SCGetCreatureNegEffects(oCurHeard) & HENCH_EFFECT_DISABLED))
            {
                //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "running SCSetNonActiveEnemy from SCInitializeTargetLists2", GetFirstPC() ); }
                SCSetNonActiveEnemy(oCurHeard);
            }
            else
            {
                float curThreat = SCGetThreatRating(oCurHeard,oCharacter);

                object oPrevTestObject = oCharacter;
                object oTestObject = GetLocalObject(oCharacter, "HenchLineOfSight");
                while (GetIsObjectValid(oTestObject))
                {
                    //DEBUGGING// igDebugLoopCounter += 1;
                    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeTargetLists1 loop3", GetFirstPC() ); }
                    if (SCGetThreatRating(oTestObject,oCharacter) < curThreat)
                    {
                        break;
                    }
                    oPrevTestObject = oTestObject;
                    oTestObject = GetLocalObject(oTestObject, "HenchLineOfSight");
                }
                SetLocalObject(oPrevTestObject, "HenchLineOfSight", oCurHeard);
                SetLocalObject(oCurHeard, "HenchLineOfSight", oTestObject);
            }
            iIteration++;
            if ( iIteration > 50 ) // safety here
			{
				//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeTargetLists1 seen greater than 50 escaping "+GetName( oCurHeard ), GetFirstPC() ); }
				break;
			}
            oCurHeard = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,  CREATURE_TYPE_IS_ALIVE, TRUE);
        }
    }

    if (!GetIsObjectValid(GetLocalObject(oCharacter, "HenchLineOfSight")))
    {
        if (GetIsObjectValid(goClosestNonActiveEnemy) && !GetObjectSeen(goClosestNonActiveEnemy) &&  LineOfSightObject(oCharacter, goClosestNonActiveEnemy))
        {
            SetLocalObject(oCharacter, "HenchLineOfSight", goClosestNonActiveEnemy);
            DeleteLocalObject(goClosestNonActiveEnemy, "HenchLineOfSight");
        }
    }


}


void SCAddToTargetLists(object oTarget, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAddToTargetLists Start "+GetName(oTarget), GetFirstPC() ); }
	
	if (GetObjectSeen(oTarget))
	{
		SetLocalObject(oTarget, "HenchLineOfSight", GetLocalObject(oCharacter, "HenchLineOfSight"));
		SetLocalObject(oCharacter, "HenchLineOfSight", oTarget);
		SetLocalObject(oTarget, "HenchObjectSeen", GetLocalObject(oCharacter, "HenchObjectSeen"));
		SetLocalObject(oCharacter, "HenchObjectSeen", oTarget);
	}
	else if (GetObjectHeard(oTarget))
	{
		SetLocalObject(oTarget, "HenchLineOfSight", GetLocalObject(oCharacter, "HenchLineOfSight"));
		SetLocalObject(oCharacter, "HenchLineOfSight", oTarget);
	}
	else
	{
		goNotHeardOrSeenEnemy = oTarget;	
	}
}



// Pausanias's version of the last: float SC GetEnemyChallenge()
// My formula: Total Challenge of Enemy = log ( Sum (2**challenge) )
// Auldar: Changed to 1.5 at Paus' request to better mirror the 3E DMG
float SCGetEnemyChallenge(object oRelativeTo = OBJECT_SELF, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetEnemyChallenge Start", GetFirstPC() ); }
    int iIteration;
    float fChallenge;

    if (GetIsObjectValid(goNotHeardOrSeenEnemy))
    {
        fChallenge = SCGetRawThreatRating(goNotHeardOrSeenEnemy);
    }
	if (GetIsObjectValid(goClosestHeardEnemy) && !gbLineOfSightHeardEnemy)
	{
        fChallenge += SCGetRawThreatRating(goClosestHeardEnemy);
	}
    object oTarget = GetLocalObject(oCharacter, "HenchLineOfSight");
    while (GetIsObjectValid(oTarget))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        fChallenge += SCGetRawThreatRating(oTarget);
        oTarget = GetLocalObject(oTarget, "HenchLineOfSight");
    }
    // get remaining seen and heard enemies - don't check disabled
    iIteration = 1;
    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,  oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    while (GetIsObjectValid(oTarget))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetEnemyChallenge loop "+GetName( oTarget ), GetFirstPC() ); }
        giCurSeenCreatureCount = iIteration;
        
        fChallenge += SCGetRawThreatRating(oTarget);
        
        iIteration++;
        if ( iIteration > 50 ) // safety here
		{
			//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetEnemyChallenge seen greater than 50 escaping "+GetName( oTarget ), GetFirstPC() ); }
			break;
		}
		oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,  oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    }
    
    iIteration = 1;
    oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    while ( GetIsObjectValid(oTarget) )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetEnemyChallenge loop2 "+GetName( oTarget ), GetFirstPC() ); }
        giCurHeardCreatureCount = iIteration;
        
        fChallenge += SCGetRawThreatRating(oTarget);
        iIteration++;
        if ( iIteration > 50 ) // safety here
		{
			//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetEnemyChallenge seen greater than 50 escaping "+GetName( oTarget ), GetFirstPC() ); }
			break;
		}
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, iIteration, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    }
	fChallenge = log(fChallenge);
	
	float fFriendChallenge;	
	oTarget = GetFirstFactionMember(oRelativeTo, FALSE);
	while (GetIsObjectValid(oTarget))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetEnemyChallenge loop3", GetFirstPC() ); }
		if (!GetIsDead(oTarget))
		{
        	fFriendChallenge += SCGetRawThreatRating(oTarget) * GetCurrentHitPoints(oTarget) / GetMaxHitPoints(oTarget);
		}
		oTarget = GetNextFactionMember(oRelativeTo, FALSE);
	}
	fFriendChallenge = log(fFriendChallenge);
	
	// factor of 3.0 is to get result close to previous version that only counted self
	return ((fChallenge - fFriendChallenge) / HENCH_LOG_POINT_FLOAT) + 3.0; 
}


int SCMoveToAwayFromTarget(object oTarget, object oSource, float fDistance, float fMaxDistance, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCMoveToAwayFromTarget Start "+GetName(oTarget), GetFirstPC() ); }
    
    vector vTarget = GetPosition(oTarget);
    vector vSource = GetPosition(oSource);
    vector vDirection = vTarget - vSource;
    // if at different heights, don't move
    if (fabs(vDirection.z) > 2.0)
    {
        return FALSE;
    }

    float fSourceTargetDistance = GetDistanceBetween(oTarget, oSource) + fDistance;
    if (fSourceTargetDistance > fMaxDistance)
    {
        fDistance =  fMaxDistance - GetDistanceBetween(oTarget, oSource);
        if (fDistance <= 1.0)
        {
            return FALSE;
        }
    }


    vector vPoint = VectorNormalize(vDirection) * -fDistance + vSource;
    location testLoc = Location(GetArea(oCharacter), vPoint, GetFacing(oCharacter));

    // check if test location is good, ignore if not
    location safeLoc = CalcSafeLocation(oCharacter, testLoc, 1.0, TRUE, FALSE);
    if (GetDistanceBetweenLocations(GetLocation(oCharacter), safeLoc) < 1.0)
    {
        return FALSE;
    }
	
    float fRadius = GetDistanceToObject(goClosestSeenOrHeardEnemy) + 0.5;
    object oClosestEnemy = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, safeLoc, FALSE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oClosestEnemy))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (GetIsEnemy(oClosestEnemy) &&  (GetObjectSeen(oClosestEnemy) || GetObjectHeard(oClosestEnemy)))
        {
            return FALSE;
        }
        oClosestEnemy = GetNextObjectInShape(SHAPE_SPHERE, fRadius, safeLoc, FALSE, OBJECT_TYPE_CREATURE);
    }



    ClearAllActions();
    ActionMoveToLocation(safeLoc, TRUE);
    return TRUE;
}


int SCMoveTowardsTarget(object oTarget, object oSource, float fDistance, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCMoveTowardsTarget Start "+GetName(oTarget), GetFirstPC() ); }
    
    vector vTarget = GetPosition(oTarget);
    vector vSource = GetPosition(oSource);
    vector vDirection = vTarget - vSource;
    // if at different heights, don't move
  	if (fabs(vDirection.z) > 2.0)
    {
        return FALSE;
    }

    vector vPoint = VectorNormalize(vDirection) * fDistance + vSource;
    location testLoc = Location(GetArea(oCharacter), vPoint, GetFacing(oCharacter));

    // check if test location is good, ignore if not
    location safeLoc = CalcSafeLocation(oCharacter, testLoc, 1.0, TRUE, FALSE);
    if (GetDistanceBetweenLocations(GetLocation(oCharacter), safeLoc) < 1.0)
    {
        return FALSE;
    }

    ClearAllActions();
    ActionMoveToLocation(safeLoc, TRUE);
    return TRUE;
}


int SCHenchHeadedInMyDirection(object oTarget, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchHeadedInMyDirection Start "+GetName(oTarget), GetFirstPC() ); }
    
    int nCurAction = GetCurrentAction(oTarget);
    if ((nCurAction != ACTION_MOVETOPOINT) && (nCurAction != HENCH_ACTION_MOVETOLOCATION))
    {
        return FALSE;
    }
    return CSLGetNormalizedDirection(GetFacing(oTarget) - VectorToAngle(GetPosition(oCharacter) - GetPosition(oTarget)) + 15.0) < 30.0;
}



int SCCheckMoveAwayFromEnemies( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckMoveAwayFromEnemies Start", GetFirstPC() ); }
    
    if (GetCurrentAction() != ACTION_INVALID)
    {
        return FALSE;
    }

    if (!GetIsObjectValid(goClosestSeenOrHeardEnemy))
    {
		return FALSE;
    }
    float fDistance = GetDistanceToObject(goClosestSeenOrHeardEnemy);
    if (fDistance >= 15.0)
    {
        return FALSE;
    }

    float fMaxDistance;
    if (GetIsObjectValid(goClosestSeenFriend))
    {
        fMaxDistance = GetDistanceToObject(goClosestSeenFriend) + 3.0;
        if (fMaxDistance > 10.0)
        {
            fMaxDistance = 10.0;
        }
    }
    else
    {
        fMaxDistance = 1000.0;
    }

	int bReturnResult;
    object oEnemy = GetLocalObject(oCharacter, "HenchLineOfSight");
    while (GetIsObjectValid(oEnemy))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (!(GetLocalInt(oEnemy, "HenchCurNegEffects") & HENCH_EFFECT_DISABLED_AND_IMMOBILE))
        {
			bReturnResult = TRUE;
            if ((GetDistanceToObject(oEnemy) < fMaxDistance) &&
                !GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEnemy)))
            {
                if ((GetAttackTarget(oEnemy) == oCharacter) || SCHenchHeadedInMyDirection(oEnemy))
                {
                    return FALSE;
                }
            }
        }
        oEnemy = GetLocalObject(oEnemy, "HenchLineOfSight");
    }
    return bReturnResult;
}


int SCMoveAwayFromEnemies(object oTarget, float fMaxTargetRange, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCMoveAwayFromEnemies Start "+GetName(oTarget), GetFirstPC() ); }
    
    if (GetDistanceToObject(oTarget) >= fMaxTargetRange)
    {
        return FALSE;
    }

    float fTestDisatnce = fMaxTargetRange - HENCH_DISTANCE_BEHIND_FRIEND;
    int index = 1;
    object oFriend = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, index++);
    // TODO change to get closest melee char????
    while (GetIsObjectValid(oFriend) && (GetDistanceToObject(oFriend) < fTestDisatnce))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (oFriend != oCharacter && (GetIsFriend(oFriend) || GetFactionEqual(oFriend)) &&
            (GetDistanceBetween(oTarget, oFriend) < fTestDisatnce) &&
            !(SCGetCreatureNegEffects(oFriend) & HENCH_EFFECT_DISABLED) &&
            ((oTarget == oCharacter) || LineOfSightObject(oFriend, oTarget)))
        {
            if (SCMoveToAwayFromTarget(oTarget, oFriend, HENCH_DISTANCE_BEHIND_FRIEND, fMaxTargetRange))
            {
                return TRUE;
            }
        }
        oFriend = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, oCharacter, index++);
    }
    if (LineOfSightObject(oTarget, oCharacter))
    {
        return SCMoveToAwayFromTarget(oTarget, oCharacter, HENCH_MOVE_BACK_DISTANCE, fMaxTargetRange);
    }
    return FALSE;
}





//69MEH69 Added for multiple henchmen command relay
void SCRelayCommandToAssociates(int nShoutIndex, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCRelayCommandToAssociates Start", GetFirstPC() ); }
    
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
    if(GetIsObjectValid(oFamiliar))
    {
        AssignCommand(oFamiliar, SCAIRespondToShout(oCharacter, nShoutIndex));
    }
    object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
    if(GetIsObjectValid(oAnimal))
    {
        AssignCommand(oAnimal, SCAIRespondToShout(oCharacter, nShoutIndex));
    }
    object oSummoned = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    if(GetIsObjectValid(oSummoned))
    {
        AssignCommand(oSummoned, SCAIRespondToShout(oCharacter, nShoutIndex));
    }
    object oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED);
    if(GetIsObjectValid(oDominated))
    {
        AssignCommand(oDominated, SCAIRespondToShout(oCharacter, nShoutIndex));
    }
}


// sends commands to associates of creature
// TODO floating text is not shown for associates of associates
void SCRelayModeToAssociates(int nActionMode, int nValue, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCRelayModeToAssociates Start", GetFirstPC() ); }
    
    SetActionMode(oCharacter, nActionMode, nValue);
    object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
    if(GetIsObjectValid(oFamiliar))
    {
        SetActionMode(oFamiliar, nActionMode, nValue);
    }
    object oAnimal = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
    if(GetIsObjectValid(oAnimal))
    {
        SetActionMode(oAnimal, nActionMode, nValue);
    }
    object oSummoned = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    if(GetIsObjectValid(oSummoned))
    {
        SetActionMode(oSummoned, nActionMode, nValue);
    }
    object oDominated = GetAssociate(ASSOCIATE_TYPE_DOMINATED);
    if(GetIsObjectValid(oDominated))
    {
        SetActionMode(oDominated, nActionMode, nValue);
    }
}




void SCHenchStartRangedBashDoor(object oDoor, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchStartRangedBashDoor Start", GetFirstPC() ); }
	
	ActionEquipMostDamagingRanged(oDoor);
    if (GetDistanceToObject(oDoor) < 5.0)
    {
         ActionMoveAwayFromObject(oDoor, FALSE, 5.0);
    }
    else
    {
        ActionWait(0.5);
    }
    ActionAttack(oDoor);
    SetLocalObject(oCharacter, "NW_GENERIC_DOOR_TO_BASH", oDoor);
}





void SCSetCombatMode(int nCombatMode = -1, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetCombatMode Start1", GetFirstPC() ); }
    
    // -2 means don't change anything
    if (nCombatMode < -1)
    {
        return;
    }
    
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetCombatMode Start2", GetFirstPC() ); }
    int index;
    for (index = ACTION_MODE_PARRY; index <= ACTION_MODE_DIRTY_FIGHTING; index ++)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        int bEnable = nCombatMode == index;
        if (GetActionMode(oCharacter, index) != bEnable)
        {
            if (bEnable)
            {
                SetActionMode(oCharacter, index, TRUE);
            }
            else
            {
                SetActionMode(oCharacter, index, FALSE);
            }
        }
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCSetCombatMode End", GetFirstPC() ); }
}




void SCUseCombatAttack(object oTarget, int nFeatID = -1, int nCombatMode = -1, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCUseCombatAttack Start "+GetName(oTarget), GetFirstPC() ); }
    
    SCSetCombatMode(nCombatMode);
    if (nFeatID < 0)
    {
        ActionAttack(oTarget);
    }
    else
    {
        ActionUseFeat(nFeatID, oTarget);
    }
    SetLocalLocation(oCharacter, "HENCH_LAST_ATTACK_LOC", GetLocation(oCharacter));
}



void SCHenchAttackObject(object oTarget, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchAttackObject Start "+GetName(oTarget), GetFirstPC() ); }
    
    if (GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
    {
        SCUseCombatAttack(oTarget);
    }
    else if(GetHasFeat(FEAT_IMPROVED_POWER_ATTACK, oCharacter))
    {
        SCUseCombatAttack(oTarget, FEAT_IMPROVED_POWER_ATTACK);
    }
    else if(GetHasFeat(FEAT_POWER_ATTACK, oCharacter))
    {
        SCUseCombatAttack(oTarget, FEAT_POWER_ATTACK);
    }
    else
    {
        SCUseCombatAttack(oTarget);
    }
}

void SCHenchAttackNearest( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchAttackNearest Start", GetFirstPC() ); }
    
    // Familiars are not combat oriented and won't respond to Attack Nearest shouts.
    if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
    {
        return;
    }
    ClearAllActions();
    SCSetPlayerQueuedTarget(oCharacter, OBJECT_INVALID);
    SCHenchResetHenchmenState();
    CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, FALSE);
    CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE);
    if (GetLocalInt(oCharacter, "DoNotAttack"))
    {
        DeleteLocalInt(oCharacter, "DoNotAttack");
		if (!SCGetHenchPartyState(HENCH_PARTY_DISABLE_PEACEFUL_MODE))
		{
			SpeakStringByStrRef(230409);
		}
    }
    object oClosest = SCGetNearestSeenOrHeardEnemyNotDead(FALSE);
    DeleteLocalObject(oCharacter, "LastTarget");
    if (GetIsObjectValid(oClosest))
    {
        SCHenchDetermineCombatRound(oClosest, TRUE, TRUE);
    }
    else
    {
        // * bonus feature. If master is attacking a door or container, issues VWE Attack Nearest
        // * will make henchman join in on the fun
        object oTarget = GetAttackTarget(GetFactionLeader(oCharacter));
        if (GetIsObjectValid(oTarget) && (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE || GetObjectType(oTarget) == OBJECT_TYPE_DOOR))
        {
            if (GetTrapDetectedBy(oTarget, oCharacter))
            {
                SCHenchStartRangedBashDoor(oTarget);
            }
            else
            {
                SCHenchAttackObject(oTarget);
                SetLocalObject(oCharacter, "NW_GENERIC_DOOR_TO_BASH", oTarget);
            }
        }
        else
        {
            SCHenchFollowLeader();
        }
    }
}


void SCHenchFollowMaster( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchFollowMaster Start", GetFirstPC() ); }
    
    if (!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND))
    {
        int nAssocType = GetAssociateType(oCharacter);
        if (nAssocType == ASSOCIATE_TYPE_NONE || nAssocType == ASSOCIATE_TYPE_HENCHMAN)
            SpeakStringByStrRef(230410);
        else if (nAssocType == ASSOCIATE_TYPE_FAMILIAR)
            SpeakStringByStrRef(230410);
        else if (nAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION)
            SpeakString("[" + GetName(oCharacter) + GetStringByStrRef(230411));
        else
            SpeakString(GetStringByStrRef(230412) + GetName(oCharacter) + GetStringByStrRef(230413));

		SetLocalInt(oCharacter, "DoNotAttack", TRUE);
		SetLocalInt(oCharacter, "HenchShouldIAttackMessageGiven", TRUE);

    	object oMaster = CSLGetCurrentMaster();
        if (!GetActionMode(oMaster, ACTION_MODE_STEALTH))
        {
            SetActionMode(oCharacter, ACTION_MODE_STEALTH, FALSE);
        }
        if ((!GetActionMode(oMaster, ACTION_MODE_DETECT) || GetHasFeat(FEAT_KEEN_SENSE, oMaster)) && !GetHasFeat(FEAT_KEEN_SENSE, oCharacter))
        {
            SetActionMode(oCharacter, ACTION_MODE_DETECT, FALSE);
        }
        if (!GetHasFeat(FEAT_SWIFT_TRACKER, oCharacter))
        {
            SetActionMode(oCharacter, HENCH_ACTION_MODE_TRACKING, FALSE);
        }
    }
    SCSetPlayerQueuedTarget(oCharacter, OBJECT_INVALID);
    SCHenchResetHenchmenState();
    DeleteLocalInt(oCharacter, "Scouting");
    CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE);
    SCHenchFollowLeader();
}


void SCHenchGuardMaster( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGuardMaster Start", GetFirstPC() ); }
    
    // Familiars are not combat oriented and won't respond to Attack Nearest shouts.
    if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
    {
        return;
    }
    SCSetPlayerQueuedTarget(oCharacter, OBJECT_INVALID);
    SCHenchResetHenchmenState();
    DeleteLocalInt(oCharacter, "DoNotAttack");
    DelayCommand(2.5, SCVoiceCanDo());
    //Companions will only attack the Masters Last Attacker
    CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER);
    CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE);
    object oRealMaster = CSLGetCurrentMaster();
    if(GetIsObjectValid(GetLastHostileActor(oRealMaster)))
    {
        SCHenchDetermineCombatRound(GetLastHostileActor(oRealMaster), TRUE, TRUE);
    }
    else
    {
        SCHenchFollowLeader();
    }
}


void SCHenchStandGround( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchStandGround Start", GetFirstPC() ); }
	
	SCSetPlayerQueuedTarget(oCharacter, OBJECT_INVALID);
	CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND);
	CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, FALSE);
	DelayCommand(2.0, SCVoiceCanDo());
	ActionAttack(OBJECT_INVALID);
	ClearAllActions();
}



int SCTryCastWarlockBuffSpell(int nSpellID, int bCheat, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTryCastWarlockBuffSpell Start", GetFirstPC() ); }
    
    if (GetHasSpell(nSpellID, oCharacter))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        if (!GetHasSpellEffect(nSpellID, oCharacter))
        {
            if (!bCheat)
            {
                ClearAllActions();
            }
            AssignCommand(oCharacter, ActionCastSpellAtObject(nSpellID, oCharacter, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, bCheat) );
            SetLocalObject(oCharacter, "HenchLastSpellTarget", oCharacter);
            return !bCheat;
        }
    }
    return FALSE;
}


int SCTryCastWarlockBuffSpells(int bCheat, object oCaster = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTryCastWarlockBuffSpells Start", GetFirstPC() ); }
    
    // check able to cast - skip if any spell failure
    if (CSLGetHasEffectType(oCaster,EFFECT_TYPE_SPELL_FAILURE) ) // || CSLGetHasEffectType(oCaster,EFFECT_TYPE_SILENCE)
    {
        return TRUE;
    }
    if (SCTryCastWarlockBuffSpell(SPELL_I_DARK_FORESIGHT, bCheat))
    {
        return TRUE;
    }
    if (bCheat && SCTryCastWarlockBuffSpell(SPELL_I_FLEE_THE_SCENE, bCheat))
    {
        return TRUE;
    }
    if (SCTryCastWarlockBuffSpell(SPELL_I_DARK_ONES_OWN_LUCK, bCheat))
    {
        return TRUE;
    }
    if (SCTryCastWarlockBuffSpell(SPELL_I_WALK_UNSEEN, bCheat))
    {
        return TRUE;
    }
    if (SCTryCastWarlockBuffSpell(SPELL_I_LEAPS_AND_BOUNDS, bCheat))
    {
        return TRUE;
    }
    if (SCTryCastWarlockBuffSpell(SPELL_I_ENTROPIC_WARDING, bCheat))
    {
        return TRUE;
    }
    if (SCTryCastWarlockBuffSpell(SPELL_I_DEVILS_SIGHT, bCheat))
    {
        return TRUE;
    }
    if (SCTryCastWarlockBuffSpell(SPELL_I_SEE_THE_UNSEEN, bCheat))
    {
        return TRUE;
    }
    /*
    if (!bCheat && GetHasSpell(SPELL_I_FLEE_THE_SCENE))
    {
        // special code to check friends
        SCInitializeAllyList(FALSE);
        object oFriend = oCaster;
        while (GetIsObjectValid(oFriend))
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            if (GetFactionEqual(oFriend) && !SCGetCreatureHasItemProperty(ITEM_PROPERTY_HASTE, oFriend) &&  !CSLGetHasEffectType(oFriend,EFFECT_TYPE_HASTE))
            {
                ClearAllActions();
                ActionCastSpellAtObject(SPELL_I_FLEE_THE_SCENE, oCaster, METAMAGIC_NONE);
                SetLocalObject(oCaster, "HenchLastSpellTarget", oCharacter);
                return TRUE;
            }
            oFriend = GetLocalObject(oFriend, "HenchAllyLineOfSight");
        }
    }
    */
    if (SCTryCastWarlockBuffSpell(SPELL_I_BEGUILING_INFLUENCE, bCheat))
    {
        return TRUE;
    }
    if (SCTryCastWarlockBuffSpell(1059, bCheat))	// Otherworldly Whispers
    {
        return TRUE;
    }
	//SPELL_I_THE_DEAD_WALK ??
    return FALSE;
}


int SCTryCastBardBuffSpells(object oCaster = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCTryCastBardBuffSpells Start", GetFirstPC() ); }
    
    // check able to cast - skip if any spell failure
    if (CSLGetHasEffectType(oCaster,EFFECT_TYPE_SILENCE))
    {
        return TRUE;
    }
    if (GetHasFeat(FEAT_BARDSONG_INSPIRE_REGENERATION, oCaster))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        SCInitializeAllyList(FALSE);
        object oFriend = oCaster;
        while (GetIsObjectValid(oFriend))
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            if (GetDistanceToObject(oFriend) <= RADIUS_SIZE_COLOSSAL &&
                (GetCurrentHitPoints(oFriend) < GetMaxHitPoints(oFriend)) &&
                !CSLGetHasEffectType(oFriend,EFFECT_TYPE_DEAF ) && 
				(GetRacialType(oFriend) != RACIAL_TYPE_CONSTRUCT) &&
				(GetRacialType(oFriend) != RACIAL_TYPE_UNDEAD))
            {
                if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_REGENERATION, oFriend))
                {
                    // leave existing one alone
                    return FALSE;
                }
                ClearAllActions();
                ActionUseFeat(FEAT_BARDSONG_INSPIRE_REGENERATION, oCaster);
                SetLocalObject(oCaster, "HenchLastSpellTarget", oCaster);
                return TRUE;
            }
            oFriend = GetLocalObject(oFriend, "HenchAllyLineOfSight");
        }
    }
    if (GetHasFeat(FEAT_BARDSONG_INSPIRE_COMPETENCE, oCaster))
    {
        gbFoundInfiniteBuffSpell = TRUE;
        if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_COMPETENCE, oCaster))
        {
            // leave existing one alone
            return FALSE;
        }
        ClearAllActions();
        ActionUseFeat(FEAT_BARDSONG_INSPIRE_COMPETENCE, oCaster);
        SetLocalObject(oCaster, "HenchLastSpellTarget", oCaster);
        return TRUE;
    }
    return FALSE;
}



object SCGetBestHealingKit( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetBestHealingKit Start", GetFirstPC() ); }
    
    object oKit;
    int iRunningValue;
    int iItemValue, iStackSize;
    
    object oItem = GetFirstItemInInventory( oCharacter );
    while(GetIsObjectValid(oItem))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        // skip past any items in a container
        if (GetHasInventory(oItem))
        {
            object oContainer = oItem;
            object oSubItem = GetFirstItemInInventory(oContainer);
            oItem = GetNextItemInInventory(oCharacter);
            while (GetIsObjectValid(oSubItem))
            {
                //DEBUGGING// igDebugLoopCounter += 1;
                oItem = GetNextItemInInventory(oCharacter);
                oSubItem = GetNextItemInInventory(oContainer);
            }
            continue;
        }
		switch (GetBaseItemType(oItem))
		{
			case BASE_ITEM_HEALERSKIT:
			{
				iItemValue = GetGoldPieceValue(oItem);
				iStackSize = GetNumStackedItems(oItem);
				// Stacked kits be worth what they should be separately.
				iItemValue = iItemValue/iStackSize;
				if(iItemValue > iRunningValue)
				{
					iRunningValue = iItemValue;
					oKit = oItem;
				}
				break;
			}
/*			case BASE_ITEM_POTIONS:
			case BASE_ITEM_SPELLSCROLL:
			case BASE_ITEM_GRENADE:
//				if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL))
				{
					SetItemCharges(oItem, 1);
				}
				break; */
		}			
        oItem = GetNextItemInInventory( oCharacter );
    }
    return oKit;
}




void SCHenchCheckIfHighestSpellLevelToCast(float fFinalTargetWeight, object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckIfHighestSpellLevelToCast Start", GetFirstPC() ); }
    
    if (fFinalTargetWeight > 0.0)
    {
        fFinalTargetWeight *= SCGetConcetrationWeightAdjustment(gsCurrentspInfo.spellInfo, gsCurrentspInfo.spellLevel);
		giNumberOfPendingBuffs++;
        if ((fFinalTargetWeight >= gfBuffTargetWeight) &&
			((gfBuffTargetWeight == 0.0) || (fFinalTargetWeight >= gfBuffTargetWeight * 1.02) ||
            (gsCurrentspInfo.spellLevel > gsBuffTargetInfo.spellLevel)))
        {
			bfBuffTargetAccumWeight = fFinalTargetWeight + bfBuffTargetAccumWeight / 2.0;
            gfBuffTargetWeight = fFinalTargetWeight;
            gsBuffTargetInfo = gsCurrentspInfo;
            gsBuffTargetInfo.oTarget = oTarget;
        }
		else
		{
			bfBuffTargetAccumWeight += fFinalTargetWeight / 2.0;
		}
    }
}


void SCHenchCheckIfLowestSpellLevelToCast(float fFinalTargetWeight, object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckIfLowestSpellLevelToCast Start", GetFirstPC() ); }
    
    if (fFinalTargetWeight > 0.0)
    {
        fFinalTargetWeight *= SCGetConcetrationWeightAdjustment(gsCurrentspInfo.spellInfo, gsCurrentspInfo.spellLevel);
		giNumberOfPendingBuffs++;
        if ((fFinalTargetWeight >= gfBuffTargetWeight) && 
			((gfBuffTargetWeight == 0.0) || (fFinalTargetWeight >= gfBuffTargetWeight * 1.02) ||
                (gsCurrentspInfo.spellLevel < gsBuffTargetInfo.spellLevel)))
        {
			bfBuffTargetAccumWeight = fFinalTargetWeight + bfBuffTargetAccumWeight / 2.0;
            gfBuffTargetWeight = fFinalTargetWeight;
            gsBuffTargetInfo = gsCurrentspInfo;
            gsBuffTargetInfo.oTarget = oTarget;
        }
		else
		{
			bfBuffTargetAccumWeight += fFinalTargetWeight / 2.0;
		}
    }
}




void SCCheckHealingListInit( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckHealingListInit Start", GetFirstPC() ); }
	
	if (gbHealingListInit)
	{
		return;	
	}	
	object oFriend = oCharacter;
    while (GetIsObjectValid(oFriend))
    {	
		//DEBUGGING// igDebugLoopCounter += 1;
		int iBase = GetMaxHitPoints(oFriend);
		int currentRegenerateAmount = GetLocalInt(oFriend, "HenchRegenerationRate");		
		int iCurrent = GetCurrentHitPoints(oFriend) + currentRegenerateAmount * giRegenHealScaleAmount;		
		float healthRatio = IntToFloat(iCurrent) / IntToFloat(iBase);			
		if (healthRatio < gfHealingThreshold)
		{
			SetLocalInt(oFriend, "SC_HEALING_CURRENT_INFO", iCurrent); 
		}
		else
		{
			SetLocalInt(oFriend, "SC_HEALING_CURRENT_INFO", HENCH_HEALING_NOTNEEDED); 
		}		
		oFriend = GetLocalObject(oFriend, "HenchAllyLineOfSight");
    }
	
	if (GetRacialType(oCharacter) == RACIAL_TYPE_UNDEAD)
	{
		gbHealingAttackWeight = 1.0;
		gbHarmAttackWeight = 0.33;		// preserve inflict spells
	}
	else
	{
		gbHarmAttackWeight = 1.0;
		gbHealingAttackWeight = 0.33;	// preserver harm spells
	}
	gbHealingListInit = TRUE;
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCCheckHealingListInit End", GetFirstPC() ); }
}




void SCHenchCheckRegeneration( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckRegeneration Start", GetFirstPC() ); }
	
	SCCheckHealingListInit();
	object oFriend = oCharacter;
	int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 7;
	int curLoopCount = 1;
	
	float maxEffectWeight;
	object oBestTarget;
	object oTestTarget = oCharacter;		
	int bIsAreaSpell = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	float fRange;
	string sTargetList;	
	if (bIsAreaSpell)
	{
		fRange = gbMeleeAttackers ? gsCurrentspInfo.range : 20.0;
		sTargetList = "HenchAllyLineOfSight";
	}
	else
	{
		fRange = gbMeleeAttackers ? HENCH_ALLY_MELEE_TOUCH_RANGE : 20.0;
		sTargetList = "HenchAllyList";
	}
	
	int spellID = gsCurrentspInfo.spellID;
	
	int regenerateAmount;
	int numRegenerateRounds;
	if (spellID == SPELLABILITY_FIENDISH_RESILIENCE)
	{
		if (GetHasFeat(FEAT_EPIC_FIENDISH_RESILIENCE_25, oCharacter, TRUE))
		{
			regenerateAmount = 25;
		}
		else if (GetHasFeat(FEAT_FIENDISH_RESILIENCE_5, oCharacter, TRUE))
		{
			regenerateAmount = 5;
		}
		else if (GetHasFeat(FEAT_FIENDISH_RESILIENCE_2, oCharacter, TRUE))
		{
			regenerateAmount = 2;
		}
		else
		{
			regenerateAmount = 1;
		}
		regenerateAmount *= HENCH_AI_REGEN_RATE_ROUNDS;
		numRegenerateRounds = 20;
	}
	else if (spellID == SPELLABILITY_SONG_INSPIRE_REGENERATION)
	{
		if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_REGENERATION, oCharacter))
		{
			return;
		}
			// regenerate 1, 2, 3 every other round x/2
        if(giMySpellCasterLevel >= 12)
		{
			regenerateAmount = 1 + ((giMySpellCasterLevel - 7) / 5);
		}
        else
		{
			regenerateAmount = 1;
		}
		regenerateAmount *= HENCH_AI_REGEN_RATE_ROUNDS / 2;
		numRegenerateRounds = 100;
	}
	else if (spellID == SPELL_REGENERATE)
	{	
		numRegenerateRounds = 10;	
	}
	else
	{	
		int nCasterLevel = (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ? (gsCurrentspInfo.spellLevel * 2) - 1 : giMySpellCasterLevel;
		if (spellID == SPELL_VIGOR)
		{
			regenerateAmount = 2 * HENCH_AI_REGEN_RATE_ROUNDS;
			if (nCasterLevel < 15)
			{
				numRegenerateRounds = nCasterLevel + 10;
			}
			else
			{
				numRegenerateRounds = 25;
			}
		}
		else if (spellID == SPELL_LESSER_VIGOR)
		{
			regenerateAmount = HENCH_AI_REGEN_RATE_ROUNDS;
			if (nCasterLevel < 5)
			{
				numRegenerateRounds = nCasterLevel + 10;
			}
			else
			{
				numRegenerateRounds = 15;
			}
		}
		else if (spellID == SPELL_MASS_LESSER_VIGOR)
		{
			regenerateAmount = HENCH_AI_REGEN_RATE_ROUNDS;
			if (nCasterLevel < 15)
			{
				numRegenerateRounds = nCasterLevel + 10;
			}
			else
			{
				numRegenerateRounds = 25;
			}
		}
		else if (spellID == SPELL_VIGOROUS_CYCLE)
		{
			regenerateAmount = 3 * HENCH_AI_REGEN_RATE_ROUNDS;
			if (nCasterLevel < 30)
			{
				numRegenerateRounds = nCasterLevel + 10;
			}
			else
			{
				numRegenerateRounds = 40;
			}
		}
	}
	
	int iHealAmount;
	if (gbAnyValidTarget)
	{
		iHealAmount = regenerateAmount / HENCH_AI_REGEN_RATE_ROUNDS;	
	}
	else
	{
		iHealAmount = regenerateAmount * numRegenerateRounds / HENCH_AI_REGEN_RATE_ROUNDS;	
	}
			
	while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
	{	
		//DEBUGGING// igDebugLoopCounter += 1;
		int iCurrent = GetLocalInt(oFriend, "SC_HEALING_CURRENT_INFO");
		if ((iCurrent != HENCH_HEALING_NOTNEEDED) && (GetDistanceBetween(oTestTarget, oFriend) <= fRange))
		{
			int iBase = GetMaxHitPoints(oFriend);
			if (spellID == SPELL_REGENERATE)
			{
				regenerateAmount = iBase * HENCH_AI_REGEN_RATE_ROUNDS / 10; 
				if (gbAnyValidTarget)
				{
					iHealAmount = regenerateAmount * 2 / HENCH_AI_REGEN_RATE_ROUNDS;	
				}
				else
				{
					iHealAmount = iBase;	
				}
			}
			
					
			if ((spellID == SPELLABILITY_SONG_INSPIRE_REGENERATION) &&
				((GetRacialType(oFriend) == RACIAL_TYPE_CONSTRUCT) || (GetRacialType(oFriend) == RACIAL_TYPE_UNDEAD) ||
				(GetLocalInt(oFriend, "HenchCurNegEffects") & HENCH_EFFECT_DYING_OR_DEAF)))
			{
				// has no effect
			}
			else
			{		
				int posEffects = GetLocalInt(oFriend, "HenchCurPosEffects");
				int currentRegenerateAmount = GetLocalInt(oFriend, "HenchRegenerationRate");
			
				if (iHealAmount >= (iBase / giHealingDivisor))
				{
					if ((currentRegenerateAmount < regenerateAmount) || ((currentRegenerateAmount == regenerateAmount) &&
						!(posEffects & HENCH_EFFECT_TYPE_REGENERATE)))
					{
						float curTargetWeight = iHealAmount / IntToFloat(iBase - iCurrent);
						if (curTargetWeight > 1.0)
						{
							curTargetWeight = 1.0;
						}
						curTargetWeight *= SCGetThreatRating(oFriend,oCharacter);
						if (gbDisableNonHealorCure || oFriend == oCharacter)
						{
							// make sure to heal self
							curTargetWeight *= HENCH_HEALSELF_WEIGHT_ADJUSTMENT;
						}
						else
						{
							curTargetWeight *= HENCH_HEALOTHER_WEIGHT_ADJUSTMENT;
						}
						curTargetWeight *= (1.0 - (IntToFloat(iCurrent) / IntToFloat(iBase)));
						if (gbDisableNonHealorCure || (GetLocalInt(oFriend, HENCH_HEAL_SELF_STATE) <= HENCH_HEAL_SELF_CANT) || GetIsPC(oFriend))
						{						
							if (bIsAreaSpell)
							{
								if (!GetIsObjectValid(oBestTarget))
								{
									oBestTarget = oFriend;
									oTestTarget = oFriend; 
									fRange = gsCurrentspInfo.radius;
								}
								maxEffectWeight += curTargetWeight;
							}
							else if (curTargetWeight > maxEffectWeight)
							{
								maxEffectWeight = curTargetWeight;
								oBestTarget = oFriend;
							}
						}
					}
					else
					{
						if ((oFriend == oCharacter) && (iHealAmount >= (iBase / giHealingDivisor)))
						{
							SetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_WAIT);
						}
					}
				}
			}
		}
	
		oFriend = GetLocalObject(oFriend, sTargetList);
		curLoopCount ++;
	}
    
    if (maxEffectWeight > 0.0)
	{		
        SCHenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestTarget);
    }
}


void SCHenchCheckHealSpecial( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckHealSpecial Start", GetFirstPC() ); }
	
	SCCheckHealingListInit();
	object oFriend = oCharacter;
	int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 7;
	int curLoopCount = 1;
	
	int spellID = gsCurrentspInfo.spellID;
	float fRange = gbMeleeAttackers ? HENCH_ALLY_MELEE_TOUCH_RANGE : 20.0;

	int iHealAmount;
	int bIngore50PercentCap = TRUE;
	int bHealUndead = TRUE;
	if (spellID == SPELL_REJUVENATION_COCOON)
	{
		int nCasterLevel = (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ? 9 : giMySpellCasterLevel;
		if (nCasterLevel > 15)
		{
			nCasterLevel = 15;
		}
		iHealAmount = 6 * nCasterLevel;
	}
	else if (spellID == SPELLABILITY_WHOLENESS_OF_BODY)
	{		
		iHealAmount = GetLevelByClass(CLASS_TYPE_MONK, oCharacter) * 2;
	}
	else if (spellID == HENCH_HEALING_KIT_ID)
	{
		iHealAmount = 11 + GetSkillRank(SKILL_HEAL) + CSLGetWeaponEnhancementBonus(goHealingKit);
		if (!gbMeleeAttackers)
		{
			// take 20
			iHealAmount += 9;
		}		
	}
	else if (spellID == SPELL_HEAL_ANIMAL_COMPANION)
	{	
		oFriend = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
		if (!GetIsObjectValid(oFriend) || !GetObjectSeen(oFriend) ||
			(GetDistanceToObject(oFriend) > (gbMeleeAttackers ? 5.0 : 20.0)))
		{
			return;
		}
		iLoopLimit = 1;
		int nCasterLevel = (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ? (gsCurrentspInfo.spellLevel * 2) - 1 : giMySpellCasterLevel;
		if (nCasterLevel > 15)
		{
			iHealAmount = 150;
		}
		else
		{
			iHealAmount = nCasterLevel * 10;
		}
	}
	else if (spellID == SPELL_KAED_Blood_of_the_Martyr)
	{
		if (!gbAnyValidTarget || (GetCurrentHitPoints() < 50))
		{
			return;
		}	
		oFriend = GetLocalObject(oCharacter, "HenchAllyList");
		iHealAmount = 20;
	}
	else if (spellID == SPELL_KAED_SPELLABILITY_Healing_Touch)
	{
		iHealAmount = giMySpellCasterLevel * 3;
		bIngore50PercentCap = !CSLGetPreferenceSwitch("TouchofHealingUse50PercentCap",TRUE);
		bHealUndead = FALSE;
	}
	else if (spellID == SPELL_KAED_SPELLABILITY_TOUCHWILD)
	{	
		iHealAmount = GetAbilityModifier(ABILITY_CHARISMA);
		iHealAmount *= GetLevelByClass(CLASS_TYPE_PALADIN) + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION) +
			GetLevelByClass(CLASS_KAED_HOSPITALER) + GetLevelByClass(CLASS_KAED_CHAMPION_WILD);
		if (iHealAmount <= 0)
		{
			return;
		}
	}
			
	float maxEffectWeight;
	object oBestTarget;
	while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
	{	
		//DEBUGGING// igDebugLoopCounter += 1;
		int iCurrent = GetLocalInt(oFriend, "SC_HEALING_CURRENT_INFO");
		if ((iCurrent != HENCH_HEALING_NOTNEEDED) && (GetDistanceToObject(oFriend) <= fRange)&&
			(bHealUndead || (GetRacialType(oFriend) != RACIAL_TYPE_UNDEAD)))
		{	
			int iBase = GetMaxHitPoints(oFriend);
					
	
			if (bIngore50PercentCap || (GetCurrentHitPoints(oFriend) < (iBase / 2)))
			{	
				if (iHealAmount >= (iBase / giHealingDivisor))
				{
					float curTargetWeight = iHealAmount / IntToFloat(iBase - iCurrent);
					if (curTargetWeight > 1.0)
					{
						curTargetWeight = 1.0;
					}
					curTargetWeight *= SCGetThreatRating(oFriend,oCharacter);
					if (gbDisableNonHealorCure || oFriend == oCharacter)
					{
						// make sure to heal self
						curTargetWeight *= HENCH_HEALSELF_WEIGHT_ADJUSTMENT;
					}
					else
					{
						curTargetWeight *= HENCH_HEALOTHER_WEIGHT_ADJUSTMENT;
					}
					curTargetWeight *= (1.0 - (IntToFloat(iCurrent) / IntToFloat(iBase)));
					if ((curTargetWeight > maxEffectWeight) &&
						(gbDisableNonHealorCure || (GetLocalInt(oFriend, HENCH_HEAL_SELF_STATE) <= HENCH_HEAL_SELF_CANT)) || GetIsPC(oFriend))
					{
						maxEffectWeight = curTargetWeight;
						oBestTarget = oFriend;
					}
				}
				else
				{
					if ((oFriend == oCharacter) && (iHealAmount >= (iBase / giHealingDivisor)))
					{
						SetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_WAIT);
					}
				}
			}
		}
	
		oFriend = GetLocalObject(oFriend, "HenchAllyList");
		curLoopCount ++;
	}
	
	if (spellID == SPELL_KAED_Blood_of_the_Martyr)
	{
		// reduce weight due to damage to self
		int currentRegenerateAmount = GetLocalInt(oCharacter, "HenchRegenerationRate");
		int currentDamageAmount = 20 - currentRegenerateAmount * giRegenHealScaleAmount;
		if (currentDamageAmount > 0)
		{
			maxEffectWeight	-= SCGetThreatRating(oCharacter,oCharacter) * SCCalculateDamageWeight(IntToFloat(currentDamageAmount), oCharacter);
		}
	}
    
    if (maxEffectWeight > 0.0)
	{		
        SCHenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestTarget);
    }
}


void SCHenchRaiseDead( object oCharacter = OBJECT_SELF )
{    
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchRaiseDead Start", GetFirstPC() ); }
    
    if (!GetIsObjectValid(goDeadFriend))
    {
        return;
    }
	// don't raise dead near enemies
	if (gsCurrentspInfo.spellID != SPELL_RESURRECTION)
	{
		object oNearestEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
            goDeadFriend, 1, CREATURE_TYPE_IS_ALIVE, TRUE);
		if (GetIsObjectValid(oNearestEnemy) && (GetDistanceBetween(goDeadFriend, oNearestEnemy) < 10.0))
		{
			return;
		}	
	}
	
    float curEffectWeight = SCGetThreatRating(goDeadFriend,oCharacter) * SCGetCurrentSpellEffectWeight() *
        HENCH_HEALOTHER_WEIGHT_ADJUSTMENT;
        
    SCHenchCheckIfLowestSpellLevelToCast(curEffectWeight, goDeadFriend);
}







int SCHenchPerceiveSpellcasterThreat( object oCharacter = OBJECT_SELF )
{
    int iOldDebugging = DEBUGGING;
    //DEBUGGING// if (DEBUGGING > 8 && DEBUGGING < 10) { DEBUGGING = 10; }
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchPerceiveSpellcasterThreat Start", GetFirstPC() ); }
    
    int mageThreshold = GetHitDice(oCharacter) * 2 / 3;
    if (mageThreshold > 15)
    {
        mageThreshold = 15;
    }
    int clericThreshold = GetHitDice(oCharacter) * 4 / 5;
    if (clericThreshold > 15)
    {
        clericThreshold = 15;
    }	
    goBestSpellCaster = GetLocalObject(oCharacter, "HenchLineOfSight");
    while (GetIsObjectValid(goBestSpellCaster))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		int spellCastingLevel;
		int bDivine;			
		int iPosition = 1;
		int nClassLevel = GetLevelByPosition(iPosition, goBestSpellCaster);		
		while ((nClassLevel > 0) && (iPosition <= 4))
		{
			//DEBUGGING// igDebugLoopCounter += 1;
			//int nClass = SCHenchGetClassByPosition(iPosition, nClassLevel, goBestSpellCaster);
			int nClass = GetClassByPosition(iPosition, goBestSpellCaster);
			int nClassFlags = SCHenchGetClassFlags(nClass);		
			int testSpellProgFlags = nClassFlags & HENCH_CLASS_SPELL_PROG_MASK;
			if (testSpellProgFlags && !(nClassFlags & HENCH_CLASS_FOURTH_LEVEL_NEEDED) && ((nClassFlags & HENCH_CLASS_PRC_FLAG) || (nClassLevel >= 3)))
			{
				spellCastingLevel += nClassLevel;					
				if ((nClassFlags & HENCH_CLASS_DIVINE_FLAG) || (nClass == CLASS_TYPE_WARLOCK))
				{
					bDivine = TRUE;
				}
			}
			iPosition++;
			nClassLevel = GetLevelByPosition(iPosition, goBestSpellCaster);	
		}		
		if ((spellCastingLevel >= mageThreshold) && (!bDivine || (spellCastingLevel >= clericThreshold)))
		{		
			DEBUGGING = iOldDebugging; // set this back
			return TRUE;
		}
        goBestSpellCaster = GetLocalObject(goBestSpellCaster, "HenchLineOfSight");
    }
    DEBUGGING = iOldDebugging; // set this back
    return FALSE;
}





int SCHenchUseSpellProtections()
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchUseSpellProtections Start", GetFirstPC() ); }
	
	// only do the first check
    if (giHenchUseSpellProtectionsChecked)
    {
        return giHenchUseSpellProtectionsChecked == HENCH_GLOBAL_FLAG_TRUE ? TRUE : FALSE;
    }
	if (SCHenchPerceiveSpellcasterThreat())
    {
        giHenchUseSpellProtectionsChecked = HENCH_GLOBAL_FLAG_TRUE;
        return TRUE;
    }
    giHenchUseSpellProtectionsChecked = HENCH_GLOBAL_FLAG_FALSE;
    return FALSE;
}


void SCHenchCheckCureCondition( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckCureCondition Start", GetFirstPC() ); }
	
	int cureMask = SCGetCurrentSpellEffectTypes();
	int saveType = SCGetCurrentSpellSaveType();
	int immunity1;
    if (!(gbDisableNonHealorCure ||
		(gbDisableNonUnlimitedOrHealOrCure && !(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_UNLIMITED_FLAG))))
    {
        immunity1 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK) >> 6;
        if (immunity1 && !SCHenchUseSpellProtections())
        {
            immunity1 = 0;
        }
    }

		
	float maxEffectWeight;
	object oBestTarget;
	object oTestTarget = oCharacter;		
	int bIsAreaSpell = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	float fRange;
	string sTargetList;	
	if (bIsAreaSpell)
	{
		fRange = gbMeleeAttackers ? gsCurrentspInfo.range : 20.0;
		sTargetList = "HenchAllyLineOfSight";
	}
	else
	{
		fRange = gbMeleeAttackers ? HENCH_ALLY_MELEE_TOUCH_RANGE : 20.0;
		sTargetList = "HenchAllyList";
	}

	object oFriend = oCharacter;
	if (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG)
	{
		oFriend = GetLocalObject(oCharacter, sTargetList);
	}
	
	int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 7;
	int curLoopCount = 1;
	while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		if (GetDistanceBetween(oTestTarget, oFriend) <= fRange)
		{		
			int curNegEffects = GetLocalInt(oFriend, "HenchCurNegEffects") & cureMask;
			if ((curNegEffects != 0) || immunity1)
			{
				float curEffectWeight = SCGetThreatRating(oFriend,oCharacter);
			
				if (curNegEffects & HENCH_EFFECT_DISABLED)
				{
					gbDisabledAllyFound = TRUE;
				}
				else if (curNegEffects & HENCH_EFFECT_IMPAIRED)
				{
					curEffectWeight *= 0.3;
				}
				else if (immunity1 && !GetIsImmune(oFriend, immunity1))
				{
					curEffectWeight *= 0.2;
				}
				else if (curNegEffects)
				{
					curEffectWeight *= 0.05;
				}
				else
				{
					curEffectWeight = 0.0;
				}
				if (curEffectWeight > 0.0)
				{           		
					if (oFriend != oCharacter)
					{
						// adjust for compassion
						curEffectWeight *= gfBuffOthersWeight;			
					}
					if (bIsAreaSpell)
					{
						if (!GetIsObjectValid(oBestTarget))
						{
							oBestTarget = oFriend;
							oTestTarget = oFriend; 
							fRange = gsCurrentspInfo.radius;
						}
						maxEffectWeight += curEffectWeight;
					}
					else
					{
						if (curEffectWeight > maxEffectWeight)
						{
							maxEffectWeight = curEffectWeight;
							oBestTarget = oFriend;
						}
					}
				}
			}
		}
		oFriend = GetLocalObject(oFriend, sTargetList);
		curLoopCount ++;
	}
	
	if (!gbDisableNonHealorCure)
	{
		if (cureMask & HENCH_EFFECT_TYPE_DOMINATED)
		{
			iLoopLimit = 7;
			int curLoopCount = 1;
			oFriend = GetLocalObject(oCharacter, "HenchObjectSeen");
			while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
			{
				//DEBUGGING// igDebugLoopCounter += 1;
				int curNegEffects = SCGetCreatureNegEffects(oFriend) & cureMask;
				if (curNegEffects & HENCH_EFFECT_TYPE_DOMINATED)
				{			
					gbDisabledAllyFound = TRUE;
					float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * 2.0;
					if (curEffectWeight > maxEffectWeight)
					{
						maxEffectWeight = curEffectWeight;
						oBestTarget = oFriend;
					}
				} 
				curLoopCount++;
				oFriend = GetLocalObject(oFriend, "HenchObjectSeen");
			}	
		}
		if ((cureMask & HENCH_EFFECT_TYPE_CHARMED) && GetIsObjectValid(goCharmedAlly))
		{
			gbDisabledAllyFound = TRUE;
			float curEffectWeight = SCGetThreatRating(oFriend,oCharacter);
			if (curEffectWeight > maxEffectWeight)
			{
				maxEffectWeight = curEffectWeight;
				oBestTarget = oFriend;
			}
		}
	}
       
    if (maxEffectWeight > 0.0)
	{		
        SCHenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestTarget);
    }
}















struct sAttackInfo SCGetItemAttackBonus(object oTarget, object oItem)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetItemAttackBonus Start "+GetName(oTarget), GetFirstPC() ); }
    
    struct sAttackInfo sReturnVal;
    // TODO not getting damage bonus, base item damage yet
//  int damageAdjust;

    itemproperty oProp = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(oProp))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        int bGetSetting;
        int bAdjustDamage;
        switch (GetItemPropertyType(oProp))
        {
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            bAdjustDamage = TRUE;
        case ITEM_PROPERTY_ATTACK_BONUS:
            bGetSetting = TRUE;
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
            bAdjustDamage = TRUE;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
            switch (GetItemPropertySubType(oProp))
            {
            case IP_CONST_ALIGNMENTGROUP_NEUTRAL:
                bGetSetting = (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL) ||
                    (GetAlignmentLawChaos(oTarget) == ALIGNMENT_NEUTRAL);
                break;
            case IP_CONST_ALIGNMENTGROUP_LAWFUL:
                bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL;
                break;
            case IP_CONST_ALIGNMENTGROUP_CHAOTIC:
                bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC;
                break;
            case IP_CONST_ALIGNMENTGROUP_GOOD:
                bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD;
                break;
            case IP_CONST_ALIGNMENTGROUP_EVIL:
                bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL;
                break;
            }
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
            bAdjustDamage = TRUE;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
            bGetSetting = GetItemPropertySubType(oProp) == GetRacialType(oTarget);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
            bAdjustDamage = TRUE;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
            {
                int iSpecificAlignment = GetItemPropertySubType(oProp);
                switch (iSpecificAlignment % 3)
                {
                case 0:
                    bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD;
                    break;
                case 1:
                    bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL;
                    break;
                case 2:
                    bGetSetting = GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL;
                    break;
                }
                if (bGetSetting)
                {
                    bGetSetting = FALSE;
                    switch (iSpecificAlignment / 3)
                    {
                    case 0:
                        bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_LAWFUL;
                        break;
                    case 1:
                        bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_NEUTRAL;
                        break;
                    case 2:
                        bGetSetting = GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC;
                        break;
                    }
                }
            }
            break;
/*      case ITEM_PROPERTY_MIGHTY:
            {
                int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oCharacter);
                int itemPropValue = GetItemPropertyCostTableValue(oProp);
                if (itemPropValue < nStrMod)
                {
                    nStrMod = itemPropValue;
                }
                damageAdjust += nStrMod;
            }
            break; */
        }
        if (bGetSetting)
        {
            int itemPropValue = GetItemPropertyCostTableValue(oProp);
            if (itemPropValue > sReturnVal.attackBonus)
            {
                 sReturnVal.attackBonus = itemPropValue;
            }
            if (bAdjustDamage && (itemPropValue > sReturnVal.damageBonus))
            {
                 sReturnVal.damageBonus = itemPropValue;
            }
        }
        oProp = GetNextItemProperty(oItem);
    }
    return sReturnVal;
}




struct sAttackInfo SCGetMeleeAttackBonus(object oCharacter, object oWeaponRight, object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetMeleeAttackBonus Start", GetFirstPC() ); }
    
    struct sAttackInfo sReturnVal;
    // Finesse only if we are using a proper weapon
    int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oCharacter);
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oCharacter);
    int bCanFinesse = GetHasFeat(FEAT_WEAPON_FINESSE, oCharacter) && (nDexMod > nStrMod);

    object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCharacter);
    if (GetIsObjectValid(oWeaponRight))
    {
        sReturnVal = SCGetItemAttackBonus(oTarget, oWeaponRight);
        if (bCanFinesse)
        {
            switch (GetBaseItemType(oWeaponRight))
            {
                // only these weapons can be finessed
            case BASE_ITEM_DAGGER:
            case BASE_ITEM_HANDAXE:
            case BASE_ITEM_KAMA:
            case BASE_ITEM_KUKRI:
            case BASE_ITEM_LIGHTHAMMER:
            case BASE_ITEM_LIGHTMACE:
            case BASE_ITEM_RAPIER:
            case BASE_ITEM_SHORTSWORD:
            case BASE_ITEM_SHURIKEN:
            case BASE_ITEM_SICKLE:
            case BASE_ITEM_THROWINGAXE:
                break;
            default:
                bCanFinesse = FALSE;
            }
        }

        if (!GetIsObjectValid(oWeaponLeft))
        {
            if (CSLGetMeleeWeaponSize(oWeaponRight) >= GetCreatureSize(oCharacter))
            {
                sReturnVal.damageBonus += nStrMod / 2;
            }
        }
    }
    else
    {
            // note: creature weapons can be finessed
        oWeaponRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCharacter);
        if (GetIsObjectValid(oWeaponRight))
        {
            sReturnVal = SCGetItemAttackBonus(oTarget, oWeaponRight);
        }
        else
        {
            oWeaponRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCharacter);
            if (GetIsObjectValid(oWeaponRight))
            {
                sReturnVal = SCGetItemAttackBonus(oTarget, oWeaponRight);
            }
            else
            {
                oWeaponRight = GetItemInSlot(INVENTORY_SLOT_ARMS, oCharacter);
                if (GetIsObjectValid(oWeaponRight))
                {
                    sReturnVal = SCGetItemAttackBonus(oTarget, oWeaponRight);
                }
            }
        }
    }
    int nOffHandWeaponSize = CSLGetMeleeWeaponSize(oWeaponLeft);
    if (nOffHandWeaponSize > 0)
    {
        if (nOffHandWeaponSize == GetCreatureSize(oCharacter))
        {
            sReturnVal.attackBonus -= 2;
        }
        else
        {
            // TODO more could be done here
            sReturnVal.attackBonus -= 4;
        }
    }
    if(bCanFinesse)
    {
        sReturnVal.attackBonus += nDexMod;
    }
    else
    {
        sReturnVal.attackBonus += nStrMod;
    }
    sReturnVal.damageBonus += nStrMod;
    return sReturnVal;
}


struct sAttackInfo SCGetRangeAttackBonus(object oCharacter, object oRangedWeapon, object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetRangeAttackBonus Start", GetFirstPC() ); }
    
    struct sAttackInfo nReturnVal = SCGetItemAttackBonus(oTarget, oRangedWeapon);
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oCharacter);
    int nWisMod = GetAbilityModifier(ABILITY_WISDOM, oCharacter);
    if (GetHasFeat(FEAT_ZEN_ARCHERY, oCharacter) && (nWisMod > nDexMod))
    {
        nReturnVal.attackBonus += nWisMod;
    }
    else
    {
        nReturnVal.attackBonus += nDexMod;
    }
    int itemType = GetBaseItemType(oRangedWeapon);
    if ((itemType == BASE_ITEM_LONGBOW) || (itemType  == BASE_ITEM_SHORTBOW))
    {
        int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oCharacter);
        if (nLevel > 0)
        {
            nLevel = (nLevel+1)/2;
            nReturnVal.attackBonus += nLevel;
            nReturnVal.damageBonus += nLevel;
        }
    }
    return nReturnVal;
}







struct sAttackInfo SCGetAttackBonus(object oCharacter, object oTarget)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetAttackBonus Start", GetFirstPC() ); }
    
    struct sAttackInfo sReturnVal;
    object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCharacter);
    if (GetWeaponRanged(oRightWeapon))
    {
        sReturnVal = SCGetRangeAttackBonus(oCharacter, oRightWeapon, oTarget);
    }
    else
    {
        sReturnVal = SCGetMeleeAttackBonus(oCharacter, oRightWeapon, oTarget);
    }
    sReturnVal.attackBonus += GetLocalInt(oCharacter, "HenchAttackBonus");
    return sReturnVal;
}







int SCHenchDoTalentMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bAllowFeatUse, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchDoTalentMeleeAttack Start "+GetName(oTarget), GetFirstPC() ); }
    
    object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int bRangedWeapon = GetWeaponRanged(oRightWeapon);

    if (!bRangedWeapon && SCGetHenchAssociateState(HENCH_ASC_NO_MELEE_ATTACKS))
    {
		// TODO use defensive combat modes
        if (gbEnableMoveAway)
        {
            if (SCMoveAwayFromEnemies(oTarget, 9.0))
            {
                SCHenchStartCombatRoundAfterAction(oTarget);
//              gbEnableMoveAway = FALSE;
//              ActionDoCommand(SC HenchDoTalentMeleeAttack(oTarget, fThresholdDistance, iCreatureType));
            }
        }		
		// fight defensively
		if (!GetLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED"))
		{	
			if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE, oCharacter))
			{		
				SCSetCombatMode(ACTION_MODE_IMPROVED_COMBAT_EXPERTISE);
			}
			else if (GetHasFeat(FEAT_COMBAT_EXPERTISE, oCharacter))
			{		
				SCSetCombatMode(ACTION_MODE_COMBAT_EXPERTISE);		
			}
			else if ((GetSkillRank(SKILL_PARRY) > (GetAC(oCharacter) - 10)) && 
				(GetAttackTarget(oTarget) == oCharacter))
			{		
				SCSetCombatMode(ACTION_MODE_PARRY);		
			}
			else
			{
				SCSetCombatMode(-1);		
			} 
		}
		// passive attack - don't move location, turn off for now
//		ActionAttack(oTarget, TRUE);
        return FALSE;
    }

    if (!GetObjectSeen(oTarget) && !gbLineOfSightHeardEnemy)
    {
        int index = 1;
        object oTest = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, index);
        while ( GetIsObjectValid(oTest) && index <= 5)
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            if (!GetIsEnemy(oTest) && LineOfSightObject(oTest, oTarget))
            {
                vector vTarget = GetPosition(oTarget);
                vector vSource = GetPosition(oTest);
                vector vDirection = vTarget - vSource;
                vector vPoint = VectorNormalize(vDirection) * -6.5 + vSource;
                location targetLocation = Location(GetArea(oCharacter), vPoint, GetFacing(oCharacter));

                location destLocation = CalcSafeLocation(oCharacter, targetLocation, 5.0, TRUE, FALSE);
                if (GetDistanceBetweenLocations(destLocation, GetLocation(oCharacter)) > 0.2)
                {
					// int bResult = ActionUseSkill(SKILL_TAUNT, oTarget);
					// ClearAllActions();
                    ActionMoveToLocation(destLocation, TRUE);

                    if (!GetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL))
                    {
                        SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, TRUE);
                        DelayCommand(2.0, SCHenchStartCombatRoundAfterDelay(oTarget));
                    }

					// ActionDoCommand(SC HenchDetermineCombatRound(oTarget, TRUE));
                    return FALSE;
                }
                else
                {
                    SetLocalLocation(oCharacter, "HENCH_LAST_ATTACK_LOC", GetLocation(oCharacter));
                }
            }
            
            index++;
            object oTest = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, index);
        }
    }

	if (!bRangedWeapon && (GetDistanceToObject(oTarget) > 7.5))
	{	
		if (!GetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL))
		{
			SetLocalInt(oCharacter, HENCH_AI_SCRIPT_POLL, TRUE);
			DelayCommand(2.0, SCHenchStartCombatRoundAfterDelay(oTarget));
		}
	}


    int iIntCheck = GetAbilityScore(oCharacter, ABILITY_INTELLIGENCE) - 2;
    if (iIntCheck < 6)
    {
        // have less smart creatures not use best combat feats all the time
        if (iIntCheck < 1)
        {
            iIntCheck = 1;
        }
        if (iIntCheck < d6())
        {
            SCUseCombatAttack(oTarget);
            return TRUE;
        }
    }
	
	if (bAllowFeatUse && GetHasFeat(FEAT_STORMLORD_SHOCK_WEAPON, oCharacter))
	{
		if (GetIsObjectValid(oRightWeapon))
		{
			int nItemType = GetBaseItemType(oRightWeapon);
			if ((nItemType == BASE_ITEM_DART) ||
				(nItemType == BASE_ITEM_SHURIKEN) ||
				(nItemType == BASE_ITEM_THROWINGAXE) ||
				(nItemType == BASE_ITEM_SPEAR))
			{			
				int bFound;			
				itemproperty curItemProp = GetFirstItemProperty(oRightWeapon);
				while(GetIsItemPropertyValid(curItemProp))
				{
					//DEBUGGING// igDebugLoopCounter += 1;
//					int iItemTypeValue = GetItemPropertyType(curItemProp);
//						" isub type " + IntToString(GetItemPropertySubType(curItemProp)) + " cost table " + IntToString(GetItemPropertyCostTableValue(curItemProp)) +
//						" item param 1 " + IntToString(GetItemPropertyParam1(curItemProp)) + " item param 1 value " + IntToString(GetItemPropertyParam1Value(curItemProp)));				
					if ((GetItemPropertyType(curItemProp) == ITEM_PROPERTY_DAMAGE_BONUS) &&
						(GetItemPropertySubType(curItemProp) == IP_CONST_DAMAGETYPE_ELECTRICAL) &&
						(GetItemPropertyCostTableValue(curItemProp) == IP_CONST_DAMAGEBONUS_1d8))
					{					
						bFound = TRUE;
						break;
					}			
                	curItemProp = GetNextItemProperty(oRightWeapon);			
				}
				if (!bFound)
				{			
					ClearAllActions();
					ActionUseFeat(FEAT_STORMLORD_SHOCK_WEAPON, oCharacter);
					return TRUE;
				}
			}
		} 
	}

    int iAC = GetAC(oTarget);
    int iNewBAB = GetBaseAttackBonus(oCharacter) + 5 + d4(2);

    int bCombatModeUseEnabled = !GetLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED");
	
	int bCanUseFlurryOfBlows = GetHasFeat(FEAT_FLURRY_OF_BLOWS, oCharacter) &&
		(!GetIsObjectValid(oRightWeapon) ||
        (GetBaseItemType(oRightWeapon) == BASE_ITEM_KAMA) ||
        (GetBaseItemType(oRightWeapon) == BASE_ITEM_QUARTERSTAFF) ||
		(GetBaseItemType(oRightWeapon) == BASE_ITEM_SHURIKEN)) &&
		(GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST)) == ARMOR_RANK_NONE);

    if (bRangedWeapon)
    {
        if (gbEnableMoveAway)
        {
            if (SCMoveAwayFromEnemies(oTarget, 9.0))
            {
                SCHenchStartCombatRoundAfterAction(oTarget);
//              gbEnableMoveAway = FALSE;
//              ActionDoCommand(SC HenchDoTalentMeleeAttack(oTarget, fThresholdDistance, iCreatureType));
                return FALSE;
            }
        }
		if (bCombatModeUseEnabled)
		{
			// TODO add FEAT_COMBATSTYLE_RANGER_ARCHERY_MANY_SHOT?
			// Always use if present
			int bHasRapidShot = GetHasFeat(FEAT_RAPID_SHOT, oCharacter);
			if (!bHasRapidShot)
			{
				if (GetHasFeat(FEAT_COMBATSTYLE_RANGER_ARCHERY_RAPID_SHOT, oCharacter))
				{
					object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST);
					bHasRapidShot = !GetIsObjectValid(oArmor) || GetArmorRank(oArmor) <= ARMOR_RANK_LIGHT;
				}
			}
			if (bHasRapidShot)
			{
				int iItemType = GetBaseItemType(oRightWeapon);
				if (iItemType == BASE_ITEM_SHORTBOW || iItemType == BASE_ITEM_LONGBOW)
				{
					SCUseCombatAttack(oTarget, -1, ACTION_MODE_RAPID_SHOT);
					return TRUE;
				}
			}
			// flurry of blows with shuriken
			if (bCanUseFlurryOfBlows)
			{
				SCUseCombatAttack(oTarget, -1, ACTION_MODE_FLURRY_OF_BLOWS);
				return TRUE;
			}
			// TODO power attack works with throwing axes
		}
        SCUseCombatAttack(oTarget);
        return TRUE;
    }

    struct sAttackInfo attackInfo = SCGetMeleeAttackBonus(oCharacter, oRightWeapon, oTarget);
    iNewBAB += attackInfo.attackBonus;

    float relativeChallenge;
    if (iCreatureType == 0)
    {
        // monsters always use best feat
        relativeChallenge = -10.0;
    }
    else
    {
    // TODO change to GetRawChallengeRating?
        relativeChallenge = IntToFloat(GetHitDice(oCharacter)) * HENCH_HITDICE_TO_CR;
        relativeChallenge -= IntToFloat(GetHitDice(oTarget)) * HENCH_HITDICE_TO_CR;
    }

    int preferredActionMode;
	if (bCombatModeUseEnabled)
	{
		if (bCanUseFlurryOfBlows && (GetLevelByClass(CLASS_TYPE_MONK) >= 9))
		{
			preferredActionMode = ACTION_MODE_FLURRY_OF_BLOWS;
		}
		else
		{
			preferredActionMode = -1; 
		}
	}
	else
	{
		preferredActionMode = -2;
	}

    int bStartOfRound = (GetCurrentAction() == ACTION_INVALID);
	int bAllowLimitedUseFeats = bAllowFeatUse && bStartOfRound &&
		!(GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE") & TALENT_EXCLUDE_ABILITY);
    if (bAllowLimitedUseFeats && (GetDistanceToObject(oTarget) < 5.0))
    {
        // For use against them evil pests! Top - one use only anyway.
        if (GetHasFeat(FEAT_SMITE_EVIL, oCharacter) &&
            (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) &&
            (relativeChallenge <= 2.0) &&
			((iNewBAB - 2) < iAC))
        {
            SCUseCombatAttack(oTarget, FEAT_SMITE_EVIL, preferredActionMode);
            return TRUE;
        }
        if (GetHasFeat(FEAT_SMITE_GOOD, oCharacter) &&
            (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD) &&
            (relativeChallenge <= 2.0) &&
			((iNewBAB - 2) < iAC))
        {
            SCUseCombatAttack(oTarget, FEAT_SMITE_GOOD, preferredActionMode);
            return TRUE;
        }
        if (GetHasFeat(1761, oCharacter) &&     // FEAT_SMITE_INFIDEL
            (GetAlignmentGoodEvil(oTarget) != GetAlignmentGoodEvil(oCharacter)) &&
            (relativeChallenge <= 2.0) &&
			((iNewBAB - 2) < iAC))
        {
            SCUseCombatAttack(oTarget, 1761, preferredActionMode);
            return TRUE;
        }
        if (GetHasFeat(FEAT_SACRED_VENGEANCE, oCharacter) && GetHasFeat(FEAT_TURN_UNDEAD, oCharacter) &&
            (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) &&
            (relativeChallenge <= 0.0))
        {
            ActionUseFeat(FEAT_SACRED_VENGEANCE, oTarget);
            SCUseCombatAttack(oTarget, -1, preferredActionMode);
            return TRUE;
        }
    }

    int powerAttackLevel = GetHasFeat(FEAT_IMPROVED_POWER_ATTACK, oCharacter) ? 2 : GetHasFeat(FEAT_POWER_ATTACK, oCharacter) ? 1 : 0;
    if (bCombatModeUseEnabled && powerAttackLevel)
    {
        int iOurSize = GetCreatureSize(oCharacter);
        int iWeaponSize = CSLGetMeleeWeaponSize(oRightWeapon);

        if (!GetIsObjectValid(oRightWeapon) || (iWeaponSize >= iOurSize))
        {
            if (GetActionMode(oCharacter, ACTION_MODE_IMPROVED_POWER_ATTACK))
            {
                SetActionMode(oCharacter, ACTION_MODE_IMPROVED_POWER_ATTACK, FALSE);
            }
            if (GetActionMode(oCharacter, ACTION_MODE_POWER_ATTACK))
            {
                SetActionMode(oCharacter, ACTION_MODE_POWER_ATTACK, FALSE);
            }

            if (!GetIsWeaponEffective(oTarget))
            {
                if (powerAttackLevel > 1)
                {
                    preferredActionMode = ACTION_MODE_IMPROVED_POWER_ATTACK;
                }
                else
                {
                    preferredActionMode = ACTION_MODE_POWER_ATTACK;
                }
            }

        }
        else
        {
            // can't use power attack with light weapons
            powerAttackLevel = 0;
        }
    }
	
    // * only the playable races have whirlwind attack
    // * Attempt to Use Whirlwind Attack
    if (bCombatModeUseEnabled && bAllowFeatUse && GetHasFeat(FEAT_WHIRLWIND_ATTACK, oCharacter) && SCGetOKToWhirl(oCharacter))
    {
            // set number of whirlwind targets needed equal to the number of attacks per round + 1
        int iAttackThreshold = (GetBaseAttackBonus(oCharacter) + 9) / 5;
        float fThresholdDistance;
        int iSizeThreshold;
        if (GetHasFeat(FEAT_IMPROVED_WHIRLWIND, oCharacter))
        {
            fThresholdDistance = 10.0;
            iSizeThreshold = CREATURE_SIZE_HUGE;
        }
        else
        {
            fThresholdDistance = 3.0;
            iSizeThreshold = CREATURE_SIZE_MEDIUM;
        }

        object oTestTarget = GetLocalObject(oCharacter, "HenchLineOfSight");
        while (GetIsObjectValid(oTestTarget))
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            if ((GetDistanceToObject(oTestTarget) <= fThresholdDistance) &&
                (GetCreatureSize(oTestTarget) <= iSizeThreshold))
            {
                --iAttackThreshold;
                if (iAttackThreshold <= 0)
                {
                    break;
                }
            }
            oTestTarget = GetLocalObject(oTestTarget, "HenchLineOfSight");
        }
        if (iAttackThreshold <= 0)
        {
            SCUseCombatAttack(oTarget, FEAT_WHIRLWIND_ATTACK, preferredActionMode);
            ActionAttack(oTarget);  // must keep in attack mode after whirlwind
            return TRUE;
        }
    }
        // TODO update for HotU, dwarven defender (is same as barb rage?)
    if (bAllowLimitedUseFeats && (relativeChallenge <= 2.0) && SCTryKiDamage(oTarget))
    {
        return TRUE;
    }

    if (bAllowLimitedUseFeats &&
        (d6() == 1) &&
        !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, oCharacter) &&
        (iNewBAB >= iAC))
    {
        int bHasQuiveringPalm = GetHasFeat(FEAT_QUIVERING_PALM, oCharacter);
        int bHasStunningFist = GetHasFeat(FEAT_STUNNING_FIST, oCharacter);
        if ((bHasQuiveringPalm || bHasStunningFist) &&
            relativeChallenge <= 2.0  &&
            (GetHitDice(oCharacter) / 2 + 10 + GetAbilityModifier(ABILITY_WISDOM) >=
            GetFortitudeSavingThrow(oTarget) + 5 + Random(15)))
        {
            if (!(SCGetCreatureNegEffects(oTarget) & HENCH_EFFECT_DISABLED))
            {
                if (bHasQuiveringPalm && !GetIsObjectValid(oRightWeapon))
                {
                    SCUseCombatAttack(oTarget, FEAT_QUIVERING_PALM, preferredActionMode);
                    return TRUE;
                }
                if (bHasStunningFist)
                {
                    int iMod = iNewBAB;
                    if (GetIsObjectValid(oRightWeapon) || (GetLevelByClass(CLASS_TYPE_MONK) == 0))
                    {
                        iMod -= 4;
                    }
                    if (iMod >= iAC)
                    {
                        SCUseCombatAttack(oTarget, FEAT_STUNNING_FIST, preferredActionMode);
                        return TRUE;
                    }
                }
            }
        }
    }
	
    int bHasImprovedKnockdown = GetHasFeat(FEAT_IMPROVED_KNOCKDOWN, oCharacter);
    if(bAllowFeatUse && bCombatModeUseEnabled && (bHasImprovedKnockdown || GetHasFeat(FEAT_KNOCKDOWN, oCharacter)) &&
        !SCGetHenchOption(HENCH_OPTION_KNOCKDOWN_DISABLED) &&
        (!SCGetHenchOption(HENCH_OPTION_KNOCKDOWN_SOMETIMES) || (d8() == 1)) &&
        !GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN, oCharacter) &&
        !GetHasFeatEffect(FEAT_KNOCKDOWN, oTarget) &&
        !GetHasFeatEffect(FEAT_IMPROVED_KNOCKDOWN, oTarget))
    {
        // By far the BEST feat to use - knocking them down lets you freely attack them!
        // These return 1-5, based on size.
        int iOurSize = GetCreatureSize(oCharacter);
        int iTheirSize = GetCreatureSize(oTarget);
        if (abs(iOurSize - iTheirSize) <= 1)
        {
            if (bHasImprovedKnockdown)
            {
                iOurSize++;
            }
            int iOurCheck = GetAbilityModifier(ABILITY_STRENGTH, oCharacter) +
                ((iOurSize - iTheirSize) * 4);
            int iOppCheck = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
            int iOppDexCheck = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
            if (iOppDexCheck > iOppCheck)
            {
                iOppCheck = iOppDexCheck;
            }
            if(iOurCheck + d4(2) - 5 > iOppCheck)
            {
                int allyAttacking;
                int allyDoesKnockdown = 1;

                object oTest = GetFirstObjectInShape(SHAPE_SPHERE, 6.5, GetLocation(oTarget), TRUE);
                while(GetIsObjectValid(oTest))
                {
                     //DEBUGGING// igDebugLoopCounter += 1;
                     if ((oTest != oCharacter) && (GetAttackTarget(oTest) == oTarget))
                     {
                        if (GetObjectSeen(oTest) || GetObjectHeard(oTest))
                        {
                            allyAttacking = TRUE;
                            if (GetHasFeat(FEAT_KNOCKDOWN, oTest))
                            {
                                allyDoesKnockdown ++;
                            }
                        }
                     }
                     oTest = GetNextObjectInShape(SHAPE_SPHERE, 6.5, GetLocation(oTarget), TRUE);
                }

                // check that we have more than one attack in a round or nearby friend also attacking
                if ((Random(allyDoesKnockdown) == 0) && (allyAttacking ||
                    (GetBaseAttackBonus(oCharacter) > 5) && ((iNewBAB - 5) >= iAC)))
                {
                    SCUseCombatAttack(oTarget, bHasImprovedKnockdown ? FEAT_IMPROVED_KNOCKDOWN : FEAT_KNOCKDOWN, preferredActionMode);
                    return TRUE;
                }
            }
        }
    }

    // start using expertise if have under 50% hit points and friend is near
    if (bCombatModeUseEnabled && SCGetPercentageHPLoss(oCharacter) < 50 && GetIsObjectValid(goClosestSeenFriend) &&
        (GetHasFeat(FEAT_COMBAT_EXPERTISE, oCharacter) || GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE, oCharacter)))
    {
        // get estimation of opponent attack vs. my AC
        int iMyAC = GetAC(oCharacter);
        int iTargetsBAB = GetBaseAttackBonus(oTarget) + 3 + d4(2) + SCGetAttackBonus(oTarget, oCharacter).attackBonus;

        if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE, oCharacter) && (iTargetsBAB - 5) >= iMyAC)
        {
            SCUseCombatAttack(oTarget, -1, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE);
            return TRUE;
        }
        if (iTargetsBAB >= iMyAC)
        {
            SCUseCombatAttack(oTarget, -1, ACTION_MODE_COMBAT_EXPERTISE);
            return TRUE;
        }
    }

        // TODO defensive stance, flourish, impromptu sneak attack
    // check for using feint
    if (GetHasFeat(FEAT_FEINT, oCharacter) && GetHasFeat(FEAT_SNEAK_ATTACK, oCharacter) &&
		bStartOfRound && bCombatModeUseEnabled && bAllowFeatUse &&		
        (GetAttackTarget(oTarget) == oCharacter) &&
        GetObjectSeen(oTarget) &&
        !GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK, oCharacter))
    {
        int iTargetIntelligence = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
        if (iTargetIntelligence > 0)
        {
            int testDC = GetSkillRank(SKILL_BLUFF) - GetBaseAttackBonus(oTarget) - GetSkillRank(SKILL_SPOT, oTarget);
            if (iTargetIntelligence <= 2)
            {
                testDC -= 8;
            }
            else if (!CSLGetIsHumanoid(oTarget))
            {
                testDC -= 4;
            }
            testDC += 5 + d4(2);
            if ((testDC > 0) && (testDC > iNewBAB - iAC - 5))
            {
                SCUseCombatAttack(oTarget, FEAT_FEINT);
                return TRUE;
            }
        }
    }
	
    // Only use parry on an active melee attacker, and
    // only if our parry skill > our AC - 10
    // JE, Apr.14,2004: Bugfix to make this actually work. Thanks to the message board
    // members who investigated this.
    if (bCombatModeUseEnabled && GetSkillRank(SKILL_PARRY) > (GetAC(oCharacter) - 10))
    {
    // TODO add support for improved parry, etc.
        object oTargetRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        if (GetAttackTarget(oTarget) == oCharacter &&
            GetIsObjectValid(oTargetRightWeapon) &&
            !GetWeaponRanged(oTargetRightWeapon))
        {
            int iAttackChance = GetBaseAttackBonus(oTarget) + SCGetAttackBonus(oTarget, oCharacter).attackBonus - GetAC(oCharacter);
            if ((iAttackChance > -20) && (SCGetPercentageHPLoss(oCharacter) < 65))
            {
                if (GetIsObjectValid(goClosestSeenFriend) && GetDistanceToObject(goClosestSeenFriend) <= 5.0)
                {
                    SCUseCombatAttack(oTarget, -1, ACTION_MODE_PARRY);
                    return TRUE;
                }
            }
        }
    }

	if (GetHasFeat(1970 /*FEAT_EXPOSE_WEAKNESS*/, oCharacter) && bAllowFeatUse)
	{
		SCUseCombatAttack(oTarget, 1970, preferredActionMode);
		return TRUE;
	}

    //
    // Auldar: Give 10% chance to Taunt if target is within 3.5 meters and is a challenge, if Skill points have been
    // spent in Taunt skill indicating intention to use, and a taunt isn't in effect
    //
    if (bAllowFeatUse && bCombatModeUseEnabled && (d10() == 1) && (GetSkillRank(SKILL_TAUNT, oCharacter, TRUE) > 0) &&
		((relativeChallenge <= 2.0) || (GetHitDice(oTarget) > (GetHitDice(oCharacter) - 2)))
        && (GetDistanceToObject(oTarget) <= 3.5) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCharacter))
    {
        // Auldar: Adding a check for the Taunt skill, and ensuring that no one with ONLY a CHA mod to
        // Taunt will use the skill.
        // This confirms that some points are spent in the skill indicating an intention for the NPC to use them.
        // Also using 69MEH69's idea to check for a negative modifier so we don't subtract a negative number (ie add)
        // to the skill check
        if ((GetSkillRank(SKILL_TAUNT) + d4(2)) > GetWillSavingThrow(oTarget))
        {
			ClearAllActions();
            ActionUseSkill(SKILL_TAUNT, oTarget);
            return TRUE;
        }
    }

    if (bAllowFeatUse && bCombatModeUseEnabled && d4() == 1 && (GetHasFeat(FEAT_IMPROVED_DISARM, oCharacter) || (GetHasFeat(FEAT_DISARM, oCharacter) && d2() == 1)) &&
        GetIsCreatureDisarmable(oTarget) &&
        ((GetIsObjectValid(oRightWeapon) && !GetWeaponRanged(oRightWeapon)) || !GetIsObjectValid(oRightWeapon)))
    {
        object oTargetRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        if (GetIsObjectValid(oTargetRightWeapon) && !GetWeaponRanged(oTargetRightWeapon))
        {
            int iOurSize = GetCreatureSize(oCharacter);
            int iTheirSize = GetCreatureSize(oTarget);

            int iWeaponSize;
            if (GetIsObjectValid(oRightWeapon))
            {
                iWeaponSize = CSLGetMeleeWeaponSize(oRightWeapon);
            }
            else
            {
                iWeaponSize = iOurSize;
            }
            int iTargetWeaponSize = CSLGetMeleeWeaponSize(oTargetRightWeapon);

            int iTargetsBAB = GetBaseAttackBonus(oTarget) + 5 + d4(2) + SCGetAttackBonus(oTarget, oCharacter).attackBonus;

            if (iNewBAB + 4 * (iOurSize - iTheirSize + iWeaponSize - iTargetWeaponSize) - 5 > iTargetsBAB)
            {
                SCUseCombatAttack(oTarget, GetHasFeat(FEAT_IMPROVED_DISARM, oCharacter) ?
                    FEAT_IMPROVED_DISARM : FEAT_DISARM);
                return TRUE;
            }
        }
    }

    if (preferredActionMode >= 0)
    {
        SCUseCombatAttack(oTarget, -1, preferredActionMode);
        return TRUE;
    }

    // This activates an extra attack, only unarmed and kama
    if (bCombatModeUseEnabled && bCanUseFlurryOfBlows)
    {
		SCUseCombatAttack(oTarget, -1, ACTION_MODE_FLURRY_OF_BLOWS);
		return TRUE;
    }

    if (bCombatModeUseEnabled && powerAttackLevel)
    {
        // -6 to hit - make sure by extra 5
        if ((powerAttackLevel > 1) && ((iNewBAB - 14) >= iAC))
        {
            SCUseCombatAttack(oTarget, -1, ACTION_MODE_IMPROVED_POWER_ATTACK);
            return TRUE;
        }
        // is a -3 to hit - make sure by extra 5
        if ((iNewBAB - 8) >= iAC)
        {
            SCUseCombatAttack(oTarget, -1, ACTION_MODE_POWER_ATTACK);
            return TRUE;
        }
    }
	
    SCUseCombatAttack(oTarget, -1, preferredActionMode);
	return TRUE;
}






void SCSetWeaponPreference(object oWeapon, int iWeaponType, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetWeaponPreference Start", GetFirstPC() ); }
    
    switch (iWeaponType)
    {
        case HENCH_AI_STORED_MELEE_FLAG:
            SetLocalObject(oCharacter, "HenchStoredMeleeWeapon", oWeapon);
            break;
        case HENCH_AI_STORED_RANGED_FLAG:
            SetLocalObject(oCharacter, "HenchStoredRangedWeapon", oWeapon);
            break;
        case HENCH_AI_STORED_SHIELD_FLAG:
            SetLocalObject(oCharacter, "StoredShield", oWeapon);
            break;
        case HENCH_AI_STORED_OFF_HAND_FLAG:
            SetLocalObject(oCharacter, "StoredOffHand", oWeapon);
            break;
    }
}







void SCRegetWeaponPreference( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCRegetWeaponPreference Start", GetFirstPC() ); }
    
    string weaponPrefString = GetTag(oCharacter) + "HenchStoredPrefWeapon";
    object oTest;
    int weaponFlags;
    int allWeaponFlags;

    DeleteLocalObject(oCharacter, "HenchStoredMeleeWeapon");
    DeleteLocalObject(oCharacter, "HenchStoredRangedWeapon");
    DeleteLocalObject(oCharacter, "StoredShield");
    DeleteLocalObject(oCharacter, "StoredOffHand");

    oTest = oCharacter;
    weaponFlags = GetLocalInt(oTest, weaponPrefString);
    if (weaponFlags)
    {
        SCSetWeaponPreference(oTest, weaponFlags);
        allWeaponFlags |= weaponFlags;
    }
    oTest = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCharacter);
    weaponFlags = GetLocalInt(oTest, weaponPrefString);
    if (weaponFlags)
    {
        SCSetWeaponPreference(oTest, weaponFlags);
        allWeaponFlags |= weaponFlags;
    }
    oTest = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCharacter);
    weaponFlags = GetLocalInt(oTest, weaponPrefString);
    if (weaponFlags)
    {
        SCSetWeaponPreference(oTest, weaponFlags);
        allWeaponFlags |= weaponFlags;
    }
    oTest = GetFirstItemInInventory(oCharacter);
    while (GetIsObjectValid(oTest))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        weaponFlags = GetLocalInt(oTest, weaponPrefString);
        if (weaponFlags)
        {
            SCSetWeaponPreference(oTest, weaponFlags);
            allWeaponFlags |= weaponFlags;
        }
        oTest = GetNextItemInInventory(oCharacter);
    }
    SetLocalInt(oCharacter, "HenchStoredPrefWeapon", allWeaponFlags);
}



int SCGetIsPCGroup(object oAssociate = OBJECT_SELF)
{
    return GetIsObjectValid(GetFactionLeader(oAssociate));
}


void SCEquipShield(int bIndicateStatus, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCEquipShield Start", GetFirstPC() ); }
    
    int iHaveShieldStatus = GetLocalInt(oCharacter, "HaveShieldStatus");
    object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    if (SCGetHenchAssociateState(HENCH_ASC_DISABLE_SHIELD_USE))
    {
		if (GetIsObjectValid(oShield))
		{
			switch (GetBaseItemType(oShield))
			{
            case BASE_ITEM_TOWERSHIELD:
            case BASE_ITEM_LARGESHIELD:
            case BASE_ITEM_SMALLSHIELD:
                ActionUnequipItem(oShield);
				break;
			}				
		}	
        return;
    }
    if (iHaveShieldStatus == 2)
    {
        // not really a shield, get rid of
        if (GetIsObjectValid(oShield))
        {
            ActionUnequipItem(oShield);
        }
        return;
    }
    if ((iHaveShieldStatus == 1) || (GetLocalInt(oCharacter, "HenchStoredPrefWeapon") & HENCH_AI_STORED_SHIELD_FLAG))
    {
        object oStoredShield = GetLocalObject(oCharacter, "StoredShield");
        if (GetIsObjectValid(oShield) && (oStoredShield == oShield))
        {
            return;
        }
        if (GetLocalInt(oCharacter, "HenchStoredPrefWeapon") & HENCH_AI_STORED_SHIELD_FLAG)
        {
            SCRegetWeaponPreference();
            oStoredShield = GetLocalObject(oCharacter, "StoredShield");
        }
        if (GetIsObjectValid(oStoredShield) && (GetItemPossessor(oStoredShield) == oCharacter) &&
            (oStoredShield != oShield))
        {
            ActionEquipItem(oStoredShield, INVENTORY_SLOT_LEFTHAND);
            return;
        }
    }

    int nMaxValue = 0;
    int iCreatureSize = GetCreatureSize(oCharacter);
//    object oRealMaster = GetRealMaster();
    int bNoPCMaster = !SCGetIsPCGroup();
    if (GetIsObjectValid(oShield))
    {
        int nSize = 1;      // note start at one less so easy compare with creature size
        switch (GetBaseItemType(oShield))
        {
            case BASE_ITEM_TOWERSHIELD:
                nSize ++;
            case BASE_ITEM_LARGESHIELD:
                nSize ++;
            case BASE_ITEM_SMALLSHIELD:
                if (bNoPCMaster || GetIdentified(oShield))
                {
                    int bPlotFlag = GetPlotFlag(oShield);
                    if (bPlotFlag)
                    {
                        SetPlotFlag(oShield, FALSE);
                    }
                    nMaxValue = GetGoldPieceValue(oShield);
                    if (bPlotFlag)
                    {
                        SetPlotFlag(oShield, TRUE);
                    }
                }
                else
                {
                    nMaxValue = 2;
                }
                break;
/*            case BASE_ITEM_TORCH:
                nMaxValue = 1;
                break; */
            default:
                // not a shield - remove
                ActionUnequipItem(oShield);
                oShield = OBJECT_INVALID;
                break;
        }
    }

    int iNewShield = FALSE;
    int tempValue;
    int bHasShieldProf = GetHasFeat(FEAT_SHIELD_PROFICIENCY, oCharacter);
    int bNoTowerShieldProf = !GetHasFeat(FEAT_TOWER_SHIELD_PROFICIENCY, oCharacter);
    int bCantUseShield = FALSE;
//    int bCanUseTorch = (iCreatureSize > 1) && SCGetCreatureUseItems(oCharacter);

    object oItem = GetFirstItemInInventory();
    while (GetIsObjectValid(oItem))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        // skip past any items in a container
        if (GetHasInventory(oItem))
        {
            object oContainer = oItem;
            object oSubItem = GetFirstItemInInventory(oContainer);
            oItem = GetNextItemInInventory();
            while (GetIsObjectValid(oSubItem))
            {
                //DEBUGGING// igDebugLoopCounter += 1;
                oItem = GetNextItemInInventory();
                oSubItem = GetNextItemInInventory(oContainer);
            }
            continue;
        }
        int nSize = 1;      // note start at one less so easy compare with creature size
        switch (GetBaseItemType(oItem))
        {
            case BASE_ITEM_TOWERSHIELD:
                if (bNoTowerShieldProf)
                {
                    break;
                }
                nSize ++;
            case BASE_ITEM_LARGESHIELD:
                nSize ++;
            case BASE_ITEM_SMALLSHIELD:
                if (bHasShieldProf && (iCreatureSize >= nSize))
                {
                    if (bNoPCMaster || GetIdentified(oItem))
                    {
                        int bPlotFlag = GetPlotFlag(oItem);
                        if (bPlotFlag)
                        {
                            SetPlotFlag(oItem, FALSE);
                        }
                        tempValue = GetGoldPieceValue(oItem);
                        if (bPlotFlag)
                        {
                            SetPlotFlag(oItem, TRUE);
                        }
                    }
                    else
                    {
                        tempValue = 2;
                    }
                    if (tempValue > nMaxValue)
                    {
                        nMaxValue = tempValue;
                        oShield = oItem;
                        iNewShield = TRUE;
                    }
                }
                else
                {
                    bCantUseShield = TRUE;
                }
                break;
/*            case BASE_ITEM_TORCH:
                if (bCanUseTorch && (1 > nMaxValue))
                {
                    nMaxValue = 1;
                    oShield = oItem;
                    iNewShield = TRUE;
                } */
                break;
            default:
                break;

        }
        oItem = GetNextItemInInventory();
    }
    if (nMaxValue > 0)
    {
        SetLocalInt(oCharacter, "HaveShieldStatus", 1);
        SetLocalObject(oCharacter, "StoredShield", oShield);
    }
    else
    {
        SetLocalInt(oCharacter, "HaveShieldStatus", 2);
        DeleteLocalObject(oCharacter, "StoredShield");
    }
    if (iNewShield)
    {
        ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND);
    }
    else if (bCantUseShield && bIndicateStatus)
    {
		//	"I don't know how to use this shield."
        SpeakStringByStrRef(230391);
    }
}




void SCSetWeaponState(int nCondition, int bValid = TRUE, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetWeaponState Start", GetFirstPC() ); }
    
    int nStatus = GetLocalInt(oCharacter, HENCH_AI_WEAPON);
    if (bValid)
    {
        nStatus = nStatus | nCondition;
        SetLocalInt(oCharacter, HENCH_AI_WEAPON, nStatus);
    }
    else
    {
        nStatus = nStatus & ~nCondition;
        SetLocalInt(oCharacter, HENCH_AI_WEAPON, nStatus);
    }
}

/*
// this is just ideas as this point
const int HENCH_SCAI_WEAP_NONE = BIT0; // const int HENCH_AI_WEAPON_INIT = BIT0;
const int HENCH_SCAI_WEAP_NONE = BIT1; // const int HENCH_AI_HAS_MELEE = BIT1;
const int HENCH_SCAI_WEAP_NONE = BIT2; // const int HENCH_AI_HAS_MELEE_WEAPON = BIT2;
const int HENCH_SCAI_WEAP_NONE = BIT3; //const int HENCH_AI_HAS_RANGED_WEAPON = BIT3;
add arrows, bolts, bullets
add feats

GetIdentified(object oItem);

const string HENCH_SCAI_WEAPON = "HENCH_AI_WEAPON"; // var to hold information in

const string HENCH_SCAI_MAINMELEE
const string HENCH_SCAI_MAINRANGED


int SCGetCacheWeaponInformation



*/

int SCGetInitWeaponStatus( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetInitWeaponStatus Start", GetFirstPC() ); }
    
    int nResult = GetLocalInt(oCharacter, HENCH_AI_WEAPON);
    if (nResult)
    {
        return nResult;
    }
    // nResult = HENCH_AI_WEAPON_INIT; // not really needed but want to make sure it's known that this should be 0 at this point
    

    int bHasMeleeWeapon;
    int bHasMeleeAttack;
    int bHasRangedWeapon;

    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if (GetIsObjectValid(oItem))
    {
        if (GetWeaponRanged(oItem))
        {
           bHasRangedWeapon = TRUE;
        }
        else if (CSLGetMeleeWeaponSize(oItem) > 0)
        {
           bHasMeleeWeapon = TRUE;
        }
    }
	
	/*
	!( bHasMeleeWeapon && bHasRangedWeapon ) in the following ALWAYS are true, since it will never have both set to true based on previous code
	
	!( TRUE && FALSE = FALSE ) = TRUE
	!( FALSE && TRUE = FALSE ) = TRUE
	!( FALSE && FALSE = FALSE ) = TRUE
	!( TRUE && TRUE = TRUE ) = FALSE
	
	*/
    oItem = GetFirstItemInInventory();
    while (GetIsObjectValid(oItem) && !(bHasMeleeWeapon && bHasRangedWeapon))   
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        // skip past any items in a container
        if (GetHasInventory(oItem))
        {
            object oContainer = oItem;
            object oSubItem = GetFirstItemInInventory(oContainer);
            oItem = GetNextItemInInventory();
            while (GetIsObjectValid(oSubItem))
            {
                //DEBUGGING// igDebugLoopCounter += 1;
                oItem = GetNextItemInInventory();
                oSubItem = GetNextItemInInventory(oContainer);
            }
            continue;
        }
        if (!bHasRangedWeapon && GetWeaponRanged(oItem))
        {
            bHasRangedWeapon = TRUE;
        }
        else if (!bHasMeleeWeapon && CSLGetMeleeWeaponSize(oItem) > 0)
        {
           bHasMeleeWeapon = TRUE;
        }
        oItem = GetNextItemInInventory();
    }
    if (!bHasMeleeWeapon)
    {
        if (GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oCharacter))
        {
            bHasMeleeAttack = TRUE;
        }
        else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R)))
        {
            bHasMeleeAttack = TRUE;
        }
        else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B)))
        {
            bHasMeleeAttack = TRUE;
        }
        else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L)))
        {
            bHasMeleeAttack = TRUE;
        }
    }
    else
    {
        bHasMeleeAttack = TRUE;
    }
    
    if (bHasMeleeAttack)
    {
        nResult |= HENCH_AI_HAS_MELEE;
    }
    
    if (bHasMeleeWeapon)
    {
        nResult |= HENCH_AI_HAS_MELEE_WEAPON;
    }
    if (bHasRangedWeapon)
    {
        nResult |= HENCH_AI_HAS_RANGED_WEAPON;
    }

    SetLocalInt(oCharacter, HENCH_AI_WEAPON, nResult);
    return nResult;
}


void SCUnequipWeapons()
{
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if (GetWeaponType(oRight) != WEAPON_TYPE_NONE)
    {
        ActionUnequipItem(oRight);
    }
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    if (GetWeaponType(oLeft) != WEAPON_TYPE_NONE)
    {
        ActionUnequipItem(oLeft);
    }
}



void SCUnequipHands()
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCUnequipHands Start", GetFirstPC() ); }
    
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    if (GetIsObjectValid(oRight))
    {
        ActionUnequipItem(oRight);
    }
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    if (GetIsObjectValid(oLeft))
    {
        ActionUnequipItem(oLeft);
    }
}






int SCEquipMeleeWeapons(object oTarget, int bIndicateStatus, int iCallNumber, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCEquipMeleeWeapons Start "+GetName(oTarget), GetFirstPC() ); }
	
	//	float time = IntToFloat(GetTimeSecond()) + IntToFloat(GetTimeMillisecond()) /1000.0;

    int nWeaponStatus = SCGetInitWeaponStatus();
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

    if (iCallNumber == 1)
    {
		if (GetLocalInt(oCharacter, "HenchStoredPrefWeapon") & HENCH_AI_STORED_MELEE_FLAG)
		{
			object oStoredMeleeWeapon = GetLocalObject(oCharacter, "HenchStoredMeleeWeapon");
            if (!GetIsObjectValid(oStoredMeleeWeapon) || (GetItemPossessor(oStoredMeleeWeapon) != oCharacter))
            {
                SCRegetWeaponPreference();
                oStoredMeleeWeapon = GetLocalObject(oCharacter, "HenchStoredMeleeWeapon");
            }
			if (oStoredMeleeWeapon == oCharacter)
			{			
				if (GetIsObjectValid(oRight))
				{				
					SCUnequipWeapons();
					ActionWait(0.3);
					return FALSE;
				}
			}
			if (!GetIsObjectValid(oRight) || (oRight != oStoredMeleeWeapon))
			{
				if (GetIsObjectValid(oStoredMeleeWeapon) && (oRight != oStoredMeleeWeapon))
				{
					ActionEquipItem(oStoredMeleeWeapon, INVENTORY_SLOT_RIGHTHAND);
					ActionWait(0.3);
					return FALSE;
				}
			}
			else
			{
				iCallNumber = 2;
			}
		}
		else
		{
			if (!(nWeaponStatus & HENCH_AI_HAS_MELEE_WEAPON))
			{
				if ((nWeaponStatus & HENCH_AI_HAS_MELEE))
				{
					// no weapons, has creature attacks, make sure ranged weapons removed
					SCUnequipHands();
					ActionEquipMostDamagingMelee(oTarget);
				}
				return TRUE;
			}
			else if (GetIsObjectValid(oRight))
			{
				if (GetWeaponRanged(oRight))
				{
					SCUnequipHands();
					ActionEquipMostDamagingMelee(oTarget);
					ActionWait(0.3);
					return FALSE;
				}
				else
				{
					SetLocalInt(oCharacter, HENCH_AI_WEAPON, nWeaponStatus | HENCH_AI_WEAPON_INIT | HENCH_AI_HAS_MELEE );
				}
			}
			ActionEquipMostDamagingMelee(oTarget);
		}
    }

    int iCreatureSize = GetCreatureSize(oCharacter);
    int iRWeaponSize = CSLGetMeleeWeaponSize(oRight);

    if (GetHasFeat(FEAT_MONKEY_GRIP, oCharacter))
    {
        if (iRWeaponSize > (iCreatureSize + 1))
        {
            // two handed weapon - done
            return TRUE;
        }
    }
    else
    {
        if (iRWeaponSize > iCreatureSize)
        {
            // two handed weapon - done
            return TRUE;
        }
    }
    // for dual weapon selection, must wait until right weapon is equipped
    if (!GetIsObjectValid(oRight))
    {
        if (nWeaponStatus & HENCH_AI_HAS_MELEE)
        {
            return TRUE;
        }
        else
        {
            SCSetWeaponState(HENCH_AI_HAS_MELEE_WEAPON, FALSE);
            return TRUE;
        }
    }
    else if (iCallNumber == 2 && GetWeaponRanged(oRight) && (nWeaponStatus & HENCH_AI_HAS_MELEE))
    {
        ActionEquipMostDamagingMelee();
        return FALSE;
    }

    int dualWieldState;
    if (SCGetHenchAssociateState(HENCH_ASC_ENABLE_DUAL_WIELDING))
    {
        dualWieldState = 1;
    }
    else if (SCGetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_WIELDING))
    {
        dualWieldState = 2;
    }
    else
    {
        dualWieldState = GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oCharacter) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_TWO_WEAPON_FIGHTING, oCharacter) ? 1 : 2;
    }

    if (dualWieldState == 2)
    {
        SCEquipShield(bIndicateStatus);
        return TRUE;
    }
    // already have something in left
    object oOrigLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    int iHaveOffHandStatus = GetLocalInt(oCharacter, "HaveOffhandStatus");
    if (iHaveOffHandStatus == 2)
    {
        SCEquipShield(bIndicateStatus);
        return TRUE;
    }
    if ((iHaveOffHandStatus == 1) || (GetLocalInt(oCharacter, "HenchStoredPrefWeapon") & HENCH_AI_STORED_OFF_HAND_FLAG))
    {
        object oStoredOffHand = GetLocalObject(oCharacter, "StoredOffHand");
        if (GetIsObjectValid(oOrigLeft) && (oStoredOffHand == oOrigLeft))
        {
            return TRUE;
        }
        if (GetLocalInt(oCharacter, "HenchStoredPrefWeapon") & HENCH_AI_STORED_OFF_HAND_FLAG)
        {
            SCRegetWeaponPreference();
            oStoredOffHand = GetLocalObject(oCharacter, "StoredOffHand");
        }
        if (GetIsObjectValid(oStoredOffHand) && (GetItemPossessor(oStoredOffHand) == oCharacter) &&
            (oRight != oStoredOffHand))
        {
            ActionEquipItem(oStoredOffHand, INVENTORY_SLOT_LEFTHAND);
            return TRUE;
        }
    }

    object oLeft = OBJECT_INVALID;
    int nLeftPrevEquip = GetIsObjectValid(oOrigLeft);
    int nMaxValue = 0;
    int iMaxWeaponSize = iCreatureSize;
    if (SCGetHenchAssociateState(HENCH_ASC_DISABLE_DUAL_HEAVY, oCharacter) && (iRWeaponSize >= iCreatureSize))
    {
        iMaxWeaponSize--;
    }
    int iCurWeaponSize;
    if (nLeftPrevEquip)
    {
        iCurWeaponSize = CSLGetMeleeWeaponSize(oOrigLeft);
        if (iCurWeaponSize != 0 && iCurWeaponSize <= iMaxWeaponSize)
        {
            if (GetIdentified(oOrigLeft))
            {
                int bPlotFlag = GetPlotFlag(oOrigLeft);
                if (bPlotFlag)
                {
                    SetPlotFlag(oOrigLeft, FALSE);
                }
                nMaxValue = GetGoldPieceValue(oOrigLeft);
                if (bPlotFlag)
                {
                    SetPlotFlag(oOrigLeft, TRUE);
                }
            }
            else
            {
                nMaxValue = 1;
            }
            oLeft = oOrigLeft;
        }
    }
    // Then look for more than 1 single handed melee weapon
    int iNewOffHand = FALSE;

    object oItem = GetFirstItemInInventory();
    while (GetIsObjectValid(oItem))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        // skip past any items in a container
        if (GetHasInventory(oItem))
        {
            object oContainer = oItem;
            object oSubItem = GetFirstItemInInventory(oContainer);
            oItem = GetNextItemInInventory();
            while (GetIsObjectValid(oSubItem))
            {
                //DEBUGGING// igDebugLoopCounter += 1;
                oItem = GetNextItemInInventory();
                oSubItem = GetNextItemInInventory(oContainer);
            }
            continue;
        }
        int nItemType = GetBaseItemType(oItem);
        if (nItemType != BASE_ITEM_LIGHTFLAIL && nItemType != BASE_ITEM_MORNINGSTAR &&
            nItemType != BASE_ITEM_WHIP)
        {
            iCurWeaponSize = CSLGetMeleeWeaponSize(oItem);
            if (iCurWeaponSize != 0 && iCurWeaponSize <= iMaxWeaponSize)
            {
                int tempValue;
                if (GetIdentified(oItem))
                {
                    int bPlotFlag = GetPlotFlag(oItem);
                    if (bPlotFlag)
                    {
                        SetPlotFlag(oItem, FALSE);
                    }
                    tempValue = GetGoldPieceValue(oItem);
                    if (bPlotFlag)
                    {
                        SetPlotFlag(oItem, TRUE);
                    }
                }
                else
                {
                    tempValue = 1;
                }
                if (tempValue > nMaxValue)
                {
                    nMaxValue = tempValue;
                    oLeft = oItem;
                    iNewOffHand = TRUE;
               }
            }
        }
        oItem = GetNextItemInInventory();
    }
    if (nMaxValue > 0)
    {
        SetLocalInt(oCharacter, "HaveOffhandStatus", 1);
        SetLocalObject(oCharacter, "StoredOffHand", oLeft);
    }
    else
    {
        SetLocalInt(oCharacter, "HaveOffhandStatus", 2);
        DeleteLocalObject(oCharacter, "StoredOffHand");
    }
    if (iNewOffHand)
    {
        ActionEquipItem(oLeft, INVENTORY_SLOT_LEFTHAND);
    }
    else if (GetIsObjectValid(oOrigLeft) && oOrigLeft == oLeft)
    {
        // nothing to do
    }
    else
    {
        SCEquipShield(bIndicateStatus);
    }
    return TRUE;
}


int SCEquipRangedWeapon(object oTarget, int bIndicateStatus, int iCallNumber, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCEquipRangedWeapon Start "+GetName(oTarget), GetFirstPC() ); }
	
	//  float time = IntToFloat(GetTimeSecond()) + IntToFloat(GetTimeMillisecond()) /1000.0;
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

    if (iCallNumber == 1)
    {
		if (GetLocalInt(oCharacter, "HenchStoredPrefWeapon") & HENCH_AI_STORED_RANGED_FLAG)
		{
			object oStoredRangedWeapon = GetLocalObject(oCharacter, "HenchStoredRangedWeapon");
			if (!GetIsObjectValid(oRight) || (oRight != oStoredRangedWeapon))
			{
				if (!GetIsObjectValid(oStoredRangedWeapon) || (GetItemPossessor(oStoredRangedWeapon) != oCharacter))
				{
					SCRegetWeaponPreference();
					oStoredRangedWeapon = GetLocalObject(oCharacter, "HenchStoredRangedWeapon");
				}
				if (GetIsObjectValid(oStoredRangedWeapon) && (oStoredRangedWeapon != oRight))
				{
					ActionEquipItem(oStoredRangedWeapon, INVENTORY_SLOT_RIGHTHAND);
					ActionWait(0.3);
					return FALSE;
				}
			}
			else
			{
				iCallNumber = 2;
			}
		}
		else
		{
			ActionEquipMostDamagingRanged(oTarget);
			return FALSE;
		}
    }

    if (!GetWeaponRanged(oRight))
    {
        if (iCallNumber == 2)
        {
			if (GetLocalInt(oCharacter, "HenchStoredPrefWeapon") & HENCH_AI_STORED_RANGED_FLAG)
			{
				ActionEquipMostDamagingRanged(oTarget);
			}
            ActionWait(0.6);
            return FALSE;
        }

        SCSetWeaponState(HENCH_AI_HAS_RANGED_WEAPON, FALSE);
        SetLocalInt(oCharacter, "UseRangedWeapons", FALSE);
        return SCEquipMeleeWeapons(oTarget, bIndicateStatus, 1);
    }

    switch (GetBaseItemType(oRight))
    {
    case BASE_ITEM_DART:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_SLING:
    case BASE_ITEM_THROWINGAXE:
        SCEquipShield(bIndicateStatus);
        break;
    }
    return TRUE;
}




void SCActionContinueMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bAllowFeatUse, int iCallNumber, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCActionContinueMeleeAttack Start "+GetName(oTarget), GetFirstPC() ); }
    
    if (GetLocalInt(oCharacter, "UseRangedWeapons"))
    {
        if (!SCEquipRangedWeapon(oTarget, iCreatureType == 1, iCallNumber))
        {
            ActionDoCommand(SCActionContinueMeleeAttack(oTarget, fThresholdDistance, iCreatureType, bAllowFeatUse, iCallNumber + 1));
            return;
        }
    }
    else
    {
        if (!SCEquipMeleeWeapons(oTarget, iCreatureType == 1, iCallNumber))
        {
            ActionDoCommand(SCActionContinueMeleeAttack(oTarget, fThresholdDistance, iCreatureType, bAllowFeatUse, iCallNumber + 1));
            return;
        }
    }
    if (SCHenchDoTalentMeleeAttack(oTarget, fThresholdDistance, iCreatureType, bAllowFeatUse) && !GetLocalInt(oCharacter, HENCH_AI_BLOCKED))
	{
		ActionDoCommand(SCHenchMoveAndDetermineCombatRound(oTarget));
	}
}


//::///////////////////////////////////////////////
//:: Equip Appropriate Weapons
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the user get his best weapons.  If the
    user is a Henchmen then he checks the player
    preference.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 2, 2002
//:://////////////////////////////////////////////

int SCHenchEquipAppropriateWeapons(object oTarget, float fThresholdDistance, int bIndicateSwitch, int bPolymorphed, int bRangedOverride = FALSE, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchEquipAppropriateWeapons Start "+GetName(oTarget), GetFirstPC() ); }
	
    if (bPolymorphed)
    {
        return TRUE;
    }
    // Roster Companions and characters owned by players will not try to switch weapons on their own
    //PrettyDebug(GetName(oCharacter) + "CSLEquipAppropriateWeapons" );

    if (SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH))
//  if (GetIsRosterMember(oCharacter) || GetIsOwnedByPlayer(oCharacter))
    {
        return TRUE;
    }

    int nWeaponStatus = SCGetInitWeaponStatus();
    int bUseRanged;

    if (nWeaponStatus & HENCH_AI_HAS_RANGED_WEAPON)
    {
        // has ranged weapons
        if (bRangedOverride)
        {
            bUseRanged = TRUE;
        }
        else
        {
         //   object oRealMaster = GetRealMaster();
            if(SCGetIsPCGroup() && !CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON))
            {
                bUseRanged = FALSE;
            }
            else
            {
                if (nWeaponStatus & HENCH_AI_HAS_MELEE)
                {
                    // if has melee weapons (includes creature weapons & monk class)
                    // if z distance is greater than two then assume cliff
                    bUseRanged = (GetDistanceToObject(oTarget) > fThresholdDistance) ||
                         (fabs(GetPosition(oCharacter).z - GetPosition(oTarget).z) > 2.0);
				}
				else
                {
                   bUseRanged = TRUE;
                }
            }
        }
    }
    else
    {
        bUseRanged = FALSE;
    }
    if (bIndicateSwitch && (bRangedOverride || CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON)))
    {
        if (!(nWeaponStatus & HENCH_AI_HAS_RANGED_WEAPON))
        {
            DeleteLocalInt(oCharacter, "SwitchedToMelee");
            DeleteLocalInt(oCharacter, "SwitchedToRanged");
        }
        else if (bRangedOverride && !CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON))
        {
            int bSwitchedToRanged = GetLocalInt(oCharacter, "SwitchedToRanged");
            if (bUseRanged && !bSwitchedToRanged)
            {
				//	"I'm stuck. Switching to my missile weapon."
                SpeakStringByStrRef(230395);
                SetLocalInt(oCharacter, "SwitchedToRanged", TRUE);
            }
            else if (!bUseRanged && bSwitchedToRanged)
            {
				//	"I'm switching back to my melee weapon for now."
                SpeakStringByStrRef(230396);
                DeleteLocalInt(oCharacter, "SwitchedToRanged");
            }
        }
        else
        {
            int bSwitchedToMelee = GetLocalInt(oCharacter, "SwitchedToMelee");
            if (bUseRanged && bSwitchedToMelee)
            {
				//	"I'm switching back to my missile weapon."
                SpeakStringByStrRef(230393);
                DeleteLocalInt(oCharacter, "SwitchedToMelee");
            }
            else if (!bUseRanged && !bSwitchedToMelee)
            {
				//	"I'm switching to my melee weapon for now."
                SpeakStringByStrRef(230394);
                SetLocalInt(oCharacter, "SwitchedToMelee", TRUE);
            }
        }
    }
    SetLocalInt(oCharacter, "UseRangedWeapons", bUseRanged);
    if (bUseRanged)
    {
        return SCEquipRangedWeapon(oTarget, bIndicateSwitch, 1);
    }
    else
    {
        return SCEquipMeleeWeapons(oTarget, bIndicateSwitch, 1);
    }
}

// MELEE ATTACK OTHERS
/*
    Auldar: Made changes here to use Taunt when appropriate as well as more accurate calculations for
    To-Hit vs Target AC.

    Tony: Made major changes in using attack feats. Heavily modified code from Jasperre.
*/

int SCHenchTalentMeleeAttack(object oTarget, float fThresholdDistance, int iCreatureType, int bPolymorphed, int iRangedOverride, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTalentMeleeAttack Start "+GetName(oTarget), GetFirstPC() ); }
    
    if (iCreatureType == 0)
    {
       SCMonsterBattleCry();
    }
    else if (iCreatureType == 1)
    {
       SCHenchBattleCry();
    }
    if (!GetIsObjectValid(oTarget))
    {
        oTarget = goSaveMeleeAttackTarget;
    }

    if (!GetIsObjectValid(oTarget))
    {
        if (GetIsObjectValid(goClosestSeenOrHeardEnemy))
        {
            oTarget = goClosestSeenOrHeardEnemy;
        }
        else if (GetIsObjectValid(goClosestNonActiveEnemy))
        {
            oTarget = goClosestNonActiveEnemy;
        }
    }

    if (GetDistanceToObject(oTarget) <= fThresholdDistance)
    {
        // make sure we go melee
        fThresholdDistance = 1000.0;
    }
    else if (SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_ANY))
    {
        object oFriend = GetLocalObject(oCharacter, "HenchAllyLineOfSight");
        while (GetIsObjectValid(oFriend))
        {
			//DEBUGGING// igDebugLoopCounter += 1;
			object oClosestEnemyOfFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
				oFriend, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN,
				CREATURE_TYPE_IS_ALIVE, TRUE);
            if (GetIsObjectValid(oClosestEnemyOfFriend) &&
				(GetDistanceBetween(oFriend, oClosestEnemyOfFriend) <= fThresholdDistance))
            {
                // make sure we go melee
                fThresholdDistance = 1000.0;
                break;
            }
			oClosestEnemyOfFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
				oFriend, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_HEARD_AND_NOT_SEEN,
				CREATURE_TYPE_IS_ALIVE, TRUE);
            if (GetIsObjectValid(oClosestEnemyOfFriend) &&
				(GetDistanceBetween(oFriend, oClosestEnemyOfFriend) <= fThresholdDistance))
            {
                // make sure we go melee
                fThresholdDistance = 1000.0;
                break;
            }
            oFriend = GetLocalObject(oFriend, "HenchAllyLineOfSight");
        }
    }



    SetLocalObject(oCharacter, "LastTarget", oTarget);

    if (!SCHenchEquipAppropriateWeapons(oTarget, fThresholdDistance, (iCreatureType == 1) &&
		!SCGetHenchPartyState(HENCH_PARTY_DISABLE_WEAPON_EQUIP_MSG), bPolymorphed, iRangedOverride))
    {
        ActionDoCommand(SCActionContinueMeleeAttack(oTarget, fThresholdDistance, iCreatureType, !bPolymorphed, 2));
    }
    else
    {
        if (SCHenchDoTalentMeleeAttack(oTarget, fThresholdDistance, iCreatureType, !bPolymorphed) && !GetLocalInt(oCharacter, HENCH_AI_BLOCKED))
		{
			ActionDoCommand(SCHenchMoveAndDetermineCombatRound(oTarget));
		}
    }

    return TRUE;
}


//::///////////////////////////////////////////////
//:: Bash Doors
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used in SC DetermineCombatRound to keep a
    henchmen bashing doors.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
//:://////////////////////////////////////////////



void SCHenchEquipDefaultWeapons(object oCharacter = OBJECT_SELF, int bShowStatus = FALSE)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchEquipDefaultWeapons Start", GetFirstPC() ); }
    
    if (bShowStatus)
    {
        SetLocalInt(oCharacter, "HenchShowWeaponStatus", TRUE);
    }
    ExecuteScript("hench_o0_equip", oCharacter);
}

int SCHenchBashDoorCheck(int bPolymorphed, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchBashDoorCheck Start", GetFirstPC() ); }
    
    int bDoor = FALSE;
    //This code is here to make sure that henchmen keep bashing doors and placeables.
    object oDoor = GetLocalObject(oCharacter, "NW_GENERIC_DOOR_TO_BASH");

    if(GetIsObjectValid(oDoor))
    {
        int nDoorMax = GetMaxHitPoints(oDoor);
        int nDoorNow = GetCurrentHitPoints(oDoor);
        int nCnt = GetLocalInt(oCharacter,"NW_GENERIC_DOOR_TO_BASH_HP");
//        if(GetLocked(oDoor) || GetIsTrapped(oDoor))
        {
            if(nDoorMax == nDoorNow)
            {
                nCnt++;
                SetLocalInt(oCharacter,"NW_GENERIC_DOOR_TO_BASH_HP", nCnt);
            }
            if(nCnt <= 2)
            {
                bDoor = TRUE;
                SCHenchAttackObject(oDoor);
            }
        }
        if(!bDoor)
        {
            DeleteLocalObject(oCharacter, "NW_GENERIC_DOOR_TO_BASH");
            DeleteLocalInt(oCharacter, "NW_GENERIC_DOOR_TO_BASH_HP");
            SCVoiceCuss();
            ActionDoCommand(SCHenchEquipDefaultWeapons());
        }
    }
    return bDoor;
}












void SCHenchCheckBuff(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckBuff Start", GetFirstPC() ); }
    
    int saveType = SCGetCurrentSpellSaveType();

    int effectTypes = SCGetCurrentSpellEffectTypes();

    if (effectTypes == HENCH_EFFECT_TYPE_SAVING_THROW_INCREASE)
    {
        if (!SCHenchUseSpellProtections())
        {
            return;
        }
    }
    int immunity1 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK) >> 6;
//  int nItemProp =  (saveType & HENCH_SPELL_SAVE_TYPE_SAVES_MASK) >> 18;

    float effectWeight = SCGetCurrentSpellEffectWeight();

	int spellShape = gsCurrentspInfo.shape;
	
	int bIsAreaSpell = spellShape != HENCH_SHAPE_NONE;
	float fRange;
	string sTargetList;	
	if (bIsAreaSpell)
	{
		// for an area of effect spell (i.e. bless), don't cast if you already have the effect
		if (GetHasSpellEffect(gsCurrentspInfo.spellID, oCharacter))
		{
			return;
		}	
		fRange = gsCurrentspInfo.radius;
		sTargetList = "HenchAllyLineOfSight";
	}
	else
	{
		fRange = gbMeleeAttackers ? HENCH_ALLY_MELEE_TOUCH_RANGE : 20.0;
		sTargetList = "HenchAllyList";
	}
	
    object oFriend;
    if (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG)
    {
        oFriend = GetLocalObject(oCharacter, sTargetList);
    }
    else
    {
        oFriend = oCharacter;
    }

    int iLoopLimit = ((spellShape == HENCH_SHAPE_NONE) && (gsCurrentspInfo.range == 0.0)) ? 1 : 7;
	
    int curLoopCount = 1;

    float maxEffectWeight;


    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        int  skip;
		if (GetLocalInt(oFriend, "HenchCurNegEffects") & HENCH_EFFECT_DISABLED)
		{
			skip = TRUE;
		}
        else if (spellShape == HENCH_SHAPE_FACTION)
        {
            skip = !GetFactionEqual(oFriend);
        }
        else
        {
            skip = GetDistanceToObject(oFriend) > fRange;
        }
        if (!skip)
        {
            float curEffectWeight = effectWeight;
            if (!immunity1 || !GetIsImmune(oFriend, immunity1))
            {
                if (effectTypes != 0)
                {
                    int maskResult = GetLocalInt(oFriend, "HenchCurPosEffects") & effectTypes;
                    if (maskResult == effectTypes)
                    {
                        skip = TRUE;
                    }
                    else if (maskResult != 0)
                    {
                        curEffectWeight /= 2.0;
                    }
                }
                if (!skip)
                {
                       // found target
                    curEffectWeight *= SCGetThreatRating(oFriend,oCharacter);
                    if (oFriend == oCharacter)
                    {
                        curEffectWeight *= gfBuffSelfWeight;
                    }
                    else
                    {
                        // adjust for compassion
                        curEffectWeight *= gfBuffOthersWeight;
                    }


                    maxEffectWeight += curEffectWeight;

                    if (!bIsAreaSpell)
                    {
                        break;
                    }
                }
            }
        }
        curLoopCount ++;
        oFriend = GetLocalObject(oFriend, sTargetList);
        
    }

    if (maxEffectWeight > 0.0)
    {
        SCHenchCheckIfHighestSpellLevelToCast(maxEffectWeight, bIsAreaSpell ? oCharacter : oFriend);
    }
}




void SCHenchInitMeleeAttackers(object oCharacter = OBJECT_SELF)
{
 	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchInitMeleeAttackers Start", GetFirstPC() ); }
 	
 	if (gbMeleeTargetInit)
    {
        return;
    }
    gbMeleeTargetInit = 1;
    DeleteLocalObject(oCharacter, "HenchMeleeTarget");
    DeleteLocalFloat(oCharacter, "HenchMeleeTarget");
	DeleteLocalObject(oCharacter, "HenchMeleeWeaponTarget");
    float fDistanceThreshold = gbMeleeAttackers ? 5.0 : 20.0;

    object oEnemy = GetLocalObject(oCharacter, "HenchLineOfSight");
    while (GetIsObjectValid(oEnemy))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        object oFriend = GetAttackTarget(oEnemy);
        if (GetIsObjectValid(oFriend) && ((gbMeleeTargetInit < 6) || oFriend == oCharacter) &&
            (GetDistanceToObject(oFriend) < fDistanceThreshold))
        {
            int nAssocType = GetAssociateType(oFriend);
            if (oFriend == oCharacter || (nAssocType != ASSOCIATE_TYPE_DOMINATED &&
                nAssocType != ASSOCIATE_TYPE_SUMMONED && nAssocType != ASSOCIATE_TYPE_FAMILIAR))
            {
                object oList = oCharacter;
                while (GetIsObjectValid(oList))
                {
                    //DEBUGGING// igDebugLoopCounter += 1;
                    if (oList == oFriend)
                    {
                        break;
                    }
                    oList = GetLocalObject(oList, "HenchMeleeTarget");
                }
                float currentValue;
                if (GetIsObjectValid(oList))
                {
                    currentValue = GetLocalFloat(oFriend, "HenchMeleeTarget");
                }
                else
                {
                    oList = GetLocalObject(oCharacter, "HenchMeleeTarget");
                    SetLocalObject(oFriend, "HenchMeleeTarget", oList);
                    SetLocalObject(oCharacter, "HenchMeleeTarget", oFriend);
                    gbMeleeTargetInit ++;					
					
                	DeleteLocalObject(oFriend, "HenchMeleeWeaponTarget");
                }
				float meleeChance = SCGetd20ChanceLimited(GetBaseAttackBonus(oEnemy) +
                    SCGetAttackBonus(oEnemy, oFriend).attackBonus - GetAC(oFriend) + 21);
				if (!GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oEnemy)))
				{
					meleeChance *= (1.0 - GetLocalFloat(oFriend, "HenchMeleeConcealment"));				
                	object oFirstEnemy = GetLocalObject(oFriend, "HenchMeleeWeaponTarget");
                	SetLocalObject(oFriend, "HenchMeleeWeaponTarget", oEnemy);
                	SetLocalObject(oEnemy, "HenchMeleeWeaponTarget", oFirstEnemy);				
                	SetLocalFloat(oEnemy, "HenchMeleeWeaponTarget", meleeChance);
				}
				else
				{
					meleeChance *= (1.0 - GetLocalFloat(oFriend, "HenchRangedConcealment"));				
				}
                currentValue += (1.0 - currentValue) * meleeChance;
                SetLocalFloat(oFriend, "HenchMeleeTarget", currentValue);
                if (oFriend == oCharacter)
                {
                    gbIAmMeleeTarget++;
                }
            }
        }
        oEnemy = GetLocalObject(oEnemy, "HenchLineOfSight");
    }

}

int SCGetCreatureAbilityIncrease(object oTarget, int nAbilityType)
{
    // assume already initialized
    int abilityBitMask = 1 << nAbilityType;
    if (abilityBitMask & GetLocalInt(oTarget, "HenchAbilityIncrease"))
    {
        return CSLDataArray_GetInt(oTarget, "HenchAbilityIncrease", nAbilityType);
    }
    return 0;
}

int SCGetCreatureACBonus(object oTarget, int nACType)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetCreatureACBonus Start "+GetName(oTarget), GetFirstPC() ); }
    
    // assume already initialized
    int abilityBitMask = 1 << (nACType + HENCH_AC_INCREASE_OFFSET);
    if (abilityBitMask & GetLocalInt(oTarget, "HenchAbilityIncrease"))
    {
        return CSLDataArray_GetInt(oTarget, "HenchACIncrease", nACType);
    }
    return 0;
}



int SCGetTouchAC(object oTarget)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetTouchAC Start "+GetName(oTarget), GetFirstPC() ); }
	
	int touchAC;

	if (GetLocalInt(oTarget, "HenchLastEffectQuery") == GetLocalInt(oTarget, "HenchLastTouchACTime"))
	{
		touchAC = GetLocalInt(oTarget, "HenchLastTouchAC");
	}
	else
	{
		touchAC = SCGetCreatureACBonus(oTarget, AC_DEFLECTION_BONUS) -
			GetCreatureSize(oTarget) + CREATURE_SIZE_MEDIUM;
		int classCheck = GetLevelByClass(CLASS_TYPE_MONK, oTarget);
		if (classCheck)
		{
			touchAC += classCheck / 5 + GetAbilityModifier(ABILITY_WISDOM, oTarget);		

			classCheck = GetLevelByClass(CLASS_TYPE_SACREDFIST, oTarget);
			if (classCheck)
			{
				touchAC += classCheck / 5 + 1;		
			}								
		}
		if (!(SCGetCreatureNegEffects(oTarget) & HENCH_EFFECT_DISABLED))
		{
			touchAC += GetAbilityModifier(ABILITY_DEXTERITY, oTarget) + 
				SCGetCreatureACBonus(oTarget, AC_DODGE_BONUS) +
				GetSkillRank(SKILL_TUMBLE, oTarget, TRUE) / 10;
		
			classCheck = GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE, oTarget);
			if (classCheck)
			{
				int abilityModifier =  GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
				if (classCheck >= abilityModifier)
				{
					touchAC += abilityModifier;
				}
				else
				{							
					touchAC += classCheck;							
				}
			}
			classCheck = GetLevelByClass(CLASS_TYPE_DUELIST, oTarget);
			if (classCheck)
			{
				int abilityModifier =  GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
				if (classCheck >= abilityModifier)
				{
					touchAC += abilityModifier;
				}
				else
				{							
					touchAC += classCheck;
				}
			}							
		}						
	
		SetLocalInt(oTarget, "HenchLastTouchAC", touchAC);						
		SetLocalInt(oTarget, "HenchLastTouchACTime", GetLocalInt(oTarget, "HenchLastEffectQuery"));
	}

	return touchAC;
}




void SCHenchCheckACBuff(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckACBuff Start", GetFirstPC() ); }
    
    SCHenchInitMeleeAttackers();

    int bSelfOnly = gsCurrentspInfo.range < 0.1;
    if (bSelfOnly && !gbIAmMeleeTarget)
    {
        return;
    }

	int spellID = gsCurrentspInfo.spellID;
    int saveType = SCGetCurrentSpellSaveType();
    int bFoundItemSpell = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG;
    int amount = SCGetCurrentSpellBuffAmount(bFoundItemSpell ? (gsCurrentspInfo.spellLevel * 2) - 1 : giMySpellCasterLevel);
    int acType =  (saveType & HENCH_SPELL_SAVE_TYPE_SAVES_MASK) >> 18;
    float effectWeight = SCGetCurrentSpellEffectWeight();
	int checkItems = SCGetCurrentSpellSaveDCType();
	int checkMoveSpeedDecrease = checkItems & HENCH_AC_CHECK_MOVEMENT_SPEED_DECREASE;
	checkItems = checkItems & HENCH_AC_CHECK_EQUIPPED_ITEMS;

    float maxEffectWeight;
    object oBestFriend;

    object oFriend = oCharacter;

    if (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG)
    {
        oFriend = GetLocalObject(oFriend, "HenchMeleeTarget");
    }


    while (GetIsObjectValid(oFriend))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        int curACBonus = amount;
		
		if (checkItems)
		{
			if (checkItems == HENCH_AC_CHECK_ARMOR)
			{
				object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oFriend);
				if (!GetIsObjectValid(oArmor) || (GetBaseItemType(oArmor) != BASE_ITEM_ARMOR))
				{
					curACBonus = 0;
				}
			}
			else
			{
				object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oFriend);
				if (!GetIsObjectValid(oShield) || (GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD &&
					GetBaseItemType(oShield) != BASE_ITEM_SMALLSHIELD &&
					GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD))
				{
					curACBonus = 0;
				}
			}
		}
        if (checkMoveSpeedDecrease && !GetIsImmune(oFriend, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE))
        {
			if (!gbMeleeAttackers || (SCGetPercentageHPLoss(oFriend) > 30))
			{
            	curACBonus = 0;
			}
        }		
        if (curACBonus > 0)
		{
			if (acType != AC_DODGE_BONUS)
			{
				if (SCGetCreaturePosEffects(oFriend) & HENCH_EFFECT_TYPE_AC_INCREASE)
				{
					curACBonus -= SCGetCreatureACBonus(oFriend, acType);
				}
			}
			else if (GetHasSpellEffect(spellID, oFriend))
			{				
				curACBonus = 0;
			}
		}
        if (curACBonus > 1)
        {
            float targetChance = GetLocalFloat(oFriend, "HenchMeleeTarget");
            if (oFriend == oCharacter && targetChance < 0.01)
            {
                if ((gsCurrentspInfo.spellLevel > gsMeleeAttackspInfo.spellLevel))
                {
                    gsMeleeAttackspInfo = gsCurrentspInfo;
                }
            }
            else
            {
                float curEffectWeight = effectWeight * curACBonus * targetChance;

                    // found target
                curEffectWeight *= SCGetThreatRating(oFriend,oCharacter);
                if (oFriend == oCharacter)
                {
                    curEffectWeight *= gfBuffSelfWeight;
                }
                else
                {
                    // adjust for compassion
                    curEffectWeight *= gfBuffOthersWeight;
                }

                if (curEffectWeight > maxEffectWeight)
                {
                    maxEffectWeight = curEffectWeight;
                    oBestFriend = oFriend;
                }
            }
        }
        if (bSelfOnly)
        {
            break;
        }
        oFriend = GetLocalObject(oFriend, "HenchMeleeTarget");
    }
    if (maxEffectWeight > 0.0)
    {
        SCHenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}


void SCHenchCheckDRBuff(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckDRBuff Start", GetFirstPC() ); }
    
    SCHenchInitMeleeAttackers();
	

    int bSelfOnly = gsCurrentspInfo.range < 0.1;
    if (bSelfOnly && !gbIAmMeleeTarget)
    {
        return;
    }

    int saveType = SCGetCurrentSpellSaveType();
    float effectWeight = SCGetCurrentSpellEffectWeight();

    float maxEffectWeight;
    object oBestFriend;

    object oFriend = oCharacter;

    if (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG)
    {
        oFriend = GetLocalObject(oFriend, "HenchMeleeTarget");
    }


    while (GetIsObjectValid(oFriend))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (!(SCGetCreaturePosEffects(oFriend) & HENCH_EFFECT_TYPE_DAMAGE_REDUCTION))
        {
            float targetChance = GetLocalFloat(oFriend, "HenchMeleeTarget");
            if (oFriend == oCharacter && targetChance < 0.01)
            {
                if ((gsCurrentspInfo.spellLevel > gsMeleeAttackspInfo.spellLevel))
                {
                    gsMeleeAttackspInfo = gsCurrentspInfo;
                }
            }
            else
            {
                float curEffectWeight = effectWeight * targetChance;
                    // found target
                curEffectWeight *= SCGetThreatRating(oFriend,oCharacter);
                if (oFriend == oCharacter)
                {
                    curEffectWeight *= gfBuffSelfWeight;
                }
                else
                {
                    // adjust for compassion
                    curEffectWeight *= gfBuffOthersWeight;
                }
                if (curEffectWeight > maxEffectWeight)
                {
                    maxEffectWeight = curEffectWeight;
                    oBestFriend = oFriend;
                }
            }
        }
        if (bSelfOnly)
        {
            break;
        }
        oFriend = GetLocalObject(oFriend, "HenchMeleeTarget");
    }
    if (maxEffectWeight > 0.0)
    {
        SCHenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}


void SCHenchCheckSpellProtections(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckSpellProtections Start", GetFirstPC() ); }
    
    if (!SCHenchUseSpellProtections())
    {
        return;
    }

    int protMask = SCGetCurrentSpellEffectTypes();

    float maxEffectWeight = SCGetThreatRating(goBestSpellCaster,oCharacter) * 0.9;


    object oBestTarget;

    int estResistance = 12 + (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ? 9 : giMySpellCasterLevel;
    estResistance *= 2;
    estResistance /= 3;

    object oFriend = oCharacter;
    int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 7;
	float fRange = gbMeleeAttackers ? HENCH_ALLY_MELEE_TOUCH_RANGE : 20.0;
    int curLoopCount = 1;
    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
        if (curLoopCount == 2)
        {
            // adjust for compassion
            maxEffectWeight *= gfBuffOthersWeight;
        }
		if ((GetDistanceToObject(oFriend) <= fRange) && !(GetLocalInt(oFriend, "HenchCurNegEffects") & HENCH_EFFECT_DISABLED))
		{
			if (protMask == 0)
			{
				if (GetSpellResistance(oFriend) < estResistance)
				{
					oBestTarget = oFriend;
					break;
				}
			}
			else
			{
				if (!(SCGetCreaturePosEffects(oFriend) & protMask))
				{
					oBestTarget = oFriend;
					break;
				}
			}
		}
        oFriend = GetLocalObject(oFriend, "HenchAllyList");
        curLoopCount ++;
    }
    if (GetIsObjectValid(oBestTarget))
    {
        SCHenchCheckIfHighestSpellLevelToCast(maxEffectWeight, oBestTarget);
    }
}



void SCHenchMeleeAttackSpell( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchMeleeAttackSpell Start", GetFirstPC() ); }
    
    if (!(gbMeleeAttackers || gbDoingBuff))
    {
        return;
    }
	int spellID = gsCurrentspInfo.spellID;
	if (GetHasSpellEffect(spellID, oCharacter) || GetHasSpellEffect(SPELL_TRUE_STRIKE, oCharacter) || GetHasSpellEffect(1700, oCharacter))
	{
		return;
	}	
	if (giMySpellCasterLevel <= giMeleeAttackLevel)
	{
		return;
	}
	int spellInfo = SCGetCurrentSpellSaveType();	
	// check for conflicts
	switch (spellInfo)
	{
		case 1:
			if (spellID == SPELLABILITY_FRENZY)
			{
				if (GetHasSpellEffect(SPELLABILITY_BARBARIAN_RAGE, oCharacter))
				{
					return;
				}
				if (GetCurrentHitPoints(oCharacter) < ((4 + GetAbilityModifier(ABILITY_CONSTITUTION)) * 6))
				{
					return;
				}
			}
			else if (GetHasSpellEffect(SPELLABILITY_FRENZY, oCharacter))
			{
				return;
			}
			break;
		case 2:
			if (GetHasSpellEffect(1007, oCharacter) || GetHasSpellEffect(SPELL_STORM_AVATAR, oCharacter))
			{
				return;
			}
			if (GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)))
			{
				return;
			}
			break;
		case 3:			
			if (GetRacialType(goSaveMeleeAttackTarget) != RACIAL_TYPE_UNDEAD)
			{
				return;
			}
			if (SCGetRawThreatRating(goSaveMeleeAttackTarget) < (SCGetRawThreatRating(oCharacter) - 2.0))
			{
				return;
			}
			break;
		case 4:
			if (GetHasSpellEffect(SPELL_BATTLETIDE, oCharacter) || GetHasSpellEffect(963, oCharacter))
			{
				return;
			}
			break;
		case 5:
			if (GetCurrentHitPoints(oCharacter) < 35)
			{
				return;
			}
			if (SCGetRawThreatRating(goSaveMeleeAttackTarget) < (SCGetRawThreatRating(oCharacter)))
			{
				return;
			}
			break;
		case 6:
			if (!GetIsObjectValid(goSaveMeleeAttackTarget) || (gfSaveAttackChance > 0.5))
			{
				return;
			}
			if (SCGetRawThreatRating(goSaveMeleeAttackTarget) < (SCGetRawThreatRating(oCharacter) - 2.0))
			{
				return;
			}
			break;
		case 7:
			if (!GetIsObjectValid(goSaveMeleeAttackTarget) || ((SCGetRawThreatRating(goSaveMeleeAttackTarget) < (SCGetRawThreatRating(oCharacter) - 2.0)) && GetIsWeaponEffective(goSaveMeleeAttackTarget)))
			{
				return;
			}
			break;
	}
	if (giMeleeAttackLevel < giMySpellCasterLevel)
	{
		gsMeleeAttackspInfo = gsCurrentspInfo;
		giMeleeAttackLevel = giMySpellCasterLevel;
	}
}


void SCHenchMeleeAttackBuff(object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchMeleeAttackBuff Start", GetFirstPC() ); }
	
	if (GetHasSpellEffect(SPELL_TRUE_STRIKE, oCharacter) || GetHasSpellEffect(1700, oCharacter))
	{
		return;
	}
    object oBestFriend;
    float maxEffectWeight;

    object oFriend = oCharacter;
	float fRange = gsCurrentspInfo.range;
    int iLoopLimit = fRange == 0.0 ? 1 : 5;
	int bIsAreaSpell = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	if (bIsAreaSpell)
	{
		iLoopLimit = 5;
		fRange = gsCurrentspInfo.radius;		
	}
    int curLoopCount = 1;
    float effectWeight = SCGetCurrentSpellEffectWeight();
	int spellInfo = SCGetCurrentSpellSaveType();

    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		int racialCheck;
		if (spellInfo & 0x2)	// animal check
		{
			int nRacialType = GetRacialType(oFriend);
			racialCheck = (nRacialType == RACIAL_TYPE_ANIMAL) ||
				(nRacialType == RACIAL_TYPE_BEAST);
		}
		else if (!(spellInfo & 0x4))	// humanoid check
		{
			racialCheck = CSLGetIsHumanoid(oFriend) ||
				(GetSubRace(oFriend) == RACIAL_SUBTYPE_GITHYANKI) ||
				(GetSubRace(oFriend) == RACIAL_SUBTYPE_GITHZERAI);
		}
		if (racialCheck && (GetDistanceToObject(oFriend) <= fRange))
		{
			if ( !( CSLGetHasSizeIncreaseEffect(oFriend) || CSLGetHasSizeDecreaseEffect(oFriend) ) )
			{
				int preferReduce = GetHasFeat(FEAT_WEAPON_FINESSE, oFriend) ||
					(GetAbilityModifier(ABILITY_DEXTERITY, oFriend) > GetAbilityModifier(ABILITY_STRENGTH, oFriend));				
				if ((preferReduce && (spellInfo & 0x1)) ||
					(!preferReduce && !(spellInfo & 0x1)) && (gbDoingBuff ||
						!GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFriend))))
				{
					float adjustment;
					if (curLoopCount == 1)
					{
						adjustment = gfBuffSelfWeight;
						if (gbMeleeAttackers && !bIsAreaSpell)
						{
							int testLevel = (spellInfo & 0x4) ? giMySpellCasterLevel : 2 + giMySpellCasterLevel / 4;
							if (giMeleeAttackLevel < testLevel)
							{
								gsMeleeAttackspInfo = gsCurrentspInfo;
								giMeleeAttackLevel = testLevel;
							}
						}
					}
					else
					{
						adjustment = gfBuffOthersWeight;
					}
					float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * effectWeight * adjustment *
						GetBaseAttackBonus(oFriend)/ GetHitDice(oFriend) ;
					if (bIsAreaSpell)
					{					
						maxEffectWeight += curEffectWeight;					
					}
					else if (curEffectWeight > maxEffectWeight)
					{
						oBestFriend = oFriend;
						maxEffectWeight = curEffectWeight;
					}
				}
				else if (bIsAreaSpell)
				{
					return;	// prevent use
				}
			}
			else if (bIsAreaSpell)
			{
				return;	// prevent use
			}
		}
        oFriend = GetLocalObject(oFriend, "HenchAllyList");
        curLoopCount ++;
    }

    if (maxEffectWeight > 0.0)
    {
        SCHenchCheckIfHighestSpellLevelToCast(maxEffectWeight,  bIsAreaSpell ? oCharacter : oBestFriend);
    }
}



float SCHenchGetEnergyImmunityWeight(object oTarget, int baseImmunityFlags, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchGetEnergyImmunityWeight Start "+GetName(oTarget), GetFirstPC() ); }
	
	int resistanceFlag = baseImmunityFlags & HENCH_IMMUNITY_WEIGHT_RESISTANCE;	
	int resistanceAmount = (baseImmunityFlags & HENCH_IMMUNITY_WEIGHT_AMOUNT_MASK) >> HENCH_IMMUNITY_WEIGHT_AMOUNT_SHIFT;
	int damageTypeInfo = baseImmunityFlags & HENCH_SPELL_INFO_DAMAGE_TYPE_MASK;
	

	float testDamageAmount;
	if (resistanceFlag)
	{
		testDamageAmount = IntToFloat(resistanceAmount);
	}
	else
	{
		testDamageAmount = 100.0;
	}	
	float curEffectWeight;
	int numDamageTypes;
	if (baseImmunityFlags & HENCH_IMMUNITY_ONLY_ONE)
	{
		curEffectWeight += SCGetDamageResistImmunityAdjustment(oTarget, testDamageAmount, damageTypeInfo, 1);
		numDamageTypes ++;	
	}
	else
	{
		if (damageTypeInfo & DAMAGE_TYPE_ACID)
		{
			curEffectWeight += SCGetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_ACID, 1);	
			numDamageTypes ++;	
		}
		if (damageTypeInfo & DAMAGE_TYPE_COLD)
		{
			curEffectWeight += SCGetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_COLD, 1);	
			numDamageTypes ++;	
		}
		if (damageTypeInfo & DAMAGE_TYPE_ELECTRICAL)
		{
			curEffectWeight += SCGetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_ELECTRICAL, 1);	
			numDamageTypes ++;	
		}
		if (damageTypeInfo & DAMAGE_TYPE_FIRE)
		{
			curEffectWeight += SCGetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_FIRE, 1);	
			numDamageTypes ++;	
		}
		if (damageTypeInfo & DAMAGE_TYPE_SONIC)
		{
			curEffectWeight += SCGetDamageResistImmunityAdjustment(oTarget, testDamageAmount, DAMAGE_TYPE_SONIC, 1);	
			numDamageTypes ++;	
		}
	}
	if (curEffectWeight <= 4.0)
	{
		return 0.0;
	}
	int damageDealtByType;
	if (gbDoingBuff)
	{
		if (baseImmunityFlags & HENCH_IMMUNITY_GENERAL)
		{
			damageDealtByType = GetMaxHitPoints(oTarget);
		}
		else
		{		
			damageDealtByType = FloatToInt(curEffectWeight - testDamageAmount * numDamageTypes - 5);			
		}
	}
	else
	{
		damageDealtByType = GetDamageDealtByType(damageTypeInfo);
	}
	if (damageDealtByType <= 0)
	{
		curEffectWeight = 0.0;
	}
	else
	{
		if (resistanceFlag)
		{
			damageDealtByType *= 3;
			if (damageDealtByType > resistanceAmount)
			{
				damageDealtByType = resistanceAmount;
			}		
		}
		else
		{
			damageDealtByType = (damageDealtByType * resistanceAmount) / 100;
		}
		curEffectWeight *= SCGetThreatRating(oTarget,oCharacter) * IntToFloat(damageDealtByType)
			/ IntToFloat(GetMaxHitPoints(oTarget));
	}
	if ((baseImmunityFlags & HENCH_IMMUNITY_GENERAL) && SCHenchUseSpellProtections())
	{	
		curEffectWeight += SCGetThreatRating(goBestSpellCaster,oCharacter) * 0.55;
	}
	return curEffectWeight;	
}


void SCHenchCheckElementalShield( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckElementalShield Start", GetFirstPC() ); }
    
    if ((SCGetCreaturePosEffects(oCharacter) & HENCH_EFFECT_TYPE_ELEMENTALSHIELD))
    {
        return;
    }
	
    SCHenchInitMeleeAttackers();
	
	float curEffectWeight;
	
	object oEnemy = GetLocalObject(oCharacter, "HenchMeleeWeaponTarget");
	if (GetIsObjectValid(oEnemy))
	{
		int spellLevel = gsCurrentspInfo.spellLevel;
		int bFoundItemSpell = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG;
		int nCasterLevel =  bFoundItemSpell ? (spellLevel * 2) - 1 : giMySpellCasterLevel;
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCHenchCheckElementalShield calling SCGetCurrentSpellDamage", GetFirstPC() ); }		
		struct sDamageInformation spellDamage = SCGetCurrentSpellDamage(nCasterLevel, bFoundItemSpell);
		float spellDamageAmount = spellDamage.amount;
		int spellDamageType = spellDamage.damageType1;
		
		do
		{			
			//DEBUGGING// igDebugLoopCounter += 1;
			int testCount = (GetBaseAttackBonus(oEnemy) / 7 + 1) * 3;	
			float damageAmount = SCGetDamageResistImmunityAdjustment(oEnemy, spellDamageAmount * testCount, spellDamageType, testCount);
			float damageWeight = SCCalculateDamageWeight(damageAmount, oEnemy);
			curEffectWeight += damageWeight * SCGetThreatRating(oEnemy,oCharacter) * GetLocalFloat(oEnemy, "HenchMeleeWeaponTarget");
		
			oEnemy = GetLocalObject(oEnemy, "HenchMeleeWeaponTarget");			
		} while (GetIsObjectValid(oEnemy));
		
		curEffectWeight += SCHenchGetEnergyImmunityWeight(oCharacter, SCGetCurrentSpellSaveType(), oCharacter);
		
		if (curEffectWeight > 0.0)
		{
			SCHenchCheckIfLowestSpellLevelToCast(curEffectWeight, oCharacter);
		}	
	}
}


void SCHenchCheckEnergyProt(object oCharacter = OBJECT_SELF)
{	
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckEnergyProt Start", GetFirstPC() ); }
	
	int spellID = gsCurrentspInfo.spellID; 
	int baseImmunityFlags = SCGetCurrentSpellSaveType();

    float maxEffectWeight;
    object oBestTarget;
    object oFriend = oCharacter;
    int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 5;
	float fRange = gbMeleeAttackers ? HENCH_ALLY_MELEE_TOUCH_RANGE : 20.0;
    int curLoopCount = 1;
    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		if ((GetDistanceToObject(oFriend) <= fRange) && !GetHasSpellEffect(spellID, oFriend))
		{
			float curEffectWeight = SCHenchGetEnergyImmunityWeight(oFriend, baseImmunityFlags, oCharacter);
			if (curLoopCount == 2)
			{
				// adjust for compassion
				curEffectWeight *= gfBuffOthersWeight;
			}
			if (curEffectWeight > maxEffectWeight)
			{
				maxEffectWeight = curEffectWeight;
				oBestTarget = oFriend;
			}
		}
        oFriend = GetLocalObject(oFriend, "HenchAllyList");
        curLoopCount ++;
    }	
	if (maxEffectWeight > 0.0)
	{	
		SCHenchCheckIfHighestSpellLevelToCast(maxEffectWeight, oBestTarget);
	}
}



void SCHenchCheckAttrBuff(object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckAttrBuff Start", GetFirstPC() ); }
	
	int spellID = gsCurrentspInfo.spellID; 
    int abilityType = SCGetCurrentSpellEffectTypes();
    int baseIncreaseAmount;
    if (spellID == SPELL_HENCH_Owl_Insight)
    {
        baseIncreaseAmount = giMySpellCasterLevel / 2;
    }
    else
    {
        baseIncreaseAmount = SCGetCurrentSpellDamageInfo();
    }
	
	
	int bIsAreaSpell = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	float fRange;
	string sTargetList;	
	if (bIsAreaSpell)
	{
		fRange = gsCurrentspInfo.radius;
		sTargetList = "HenchAllyLineOfSight";
	}
	else
	{
		fRange = gbMeleeAttackers ? HENCH_ALLY_MELEE_TOUCH_RANGE : 20.0;
		sTargetList = "HenchAllyList";
	}

    object oBestFriend = oCharacter;
    float maxEffectWeight;

	object oFriend = oCharacter;
	int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 5;
	int curLoopCount;
	while ((curLoopCount < iLoopLimit) && GetIsObjectValid(oFriend))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		if (GetDistanceToObject(oFriend) <= fRange)
		{
			int posEffects = SCGetCreaturePosEffects(oFriend);	
			int curIncreaseAmount = baseIncreaseAmount - SCGetCreatureAbilityIncrease(oFriend, abilityType);
			
			if (curIncreaseAmount > 1)
			{		
				float adjustment;
				if (curLoopCount == 0)
				{
					adjustment = gfBuffSelfWeight;
				}
				else
				{
					adjustment = gfBuffOthersWeight;
				}
				// TODO add more checks/change checks				
				if (abilityType < 3 /* str, dex, con */)
				{	
					int bMeleeChar = (posEffects & HENCH_EFFECT_TYPE_POLYMORPH) ||
						(GetBaseAttackBonus(oFriend) >= (3 * GetHitDice(oFriend) / 4));
		
					object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFriend);
					int bRanged = GetWeaponRanged(oRightWeapon);
		
					if (gbDoingBuff && bMeleeChar && SCGetHenchAssociateState(HENCH_ASC_MELEE_DISTANCE_FAR | HENCH_ASC_MELEE_DISTANCE_ANY, oFriend))
					{
						bRanged = FALSE;
					}
		
					if (abilityType == ABILITY_CONSTITUTION)
					{
						if (!bRanged || (SCGetPercentageHPLoss(oFriend) <= 90))
						{
							if (bMeleeChar)
							{
								float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * HENCH_ATTRI_BUFF_SCALE_MED * IntToFloat(curIncreaseAmount) * adjustment;
								if (bIsAreaSpell)
								{
									maxEffectWeight += curEffectWeight;
								}
								else if (curEffectWeight > maxEffectWeight)
								{
									maxEffectWeight = curEffectWeight;
									oBestFriend = oFriend;
								}
							}
							else if (oFriend == oCharacter)
							{
								if (gsCurrentspInfo.spellLevel > gsDelayedAttrBuff.spellLevel)
								{
									gsDelayedAttrBuff = gsCurrentspInfo;
								}
							}
						}
						else if (oFriend == oCharacter)
						{
							if (gsCurrentspInfo.spellLevel > gsPolyAttrBuff.spellLevel)
							{
								gsPolyAttrBuff = gsCurrentspInfo;
							}
						}
					}
					else if (abilityType == ABILITY_STRENGTH)
					{
						if (!bRanged && !GetHasFeat(FEAT_WEAPON_FINESSE, oFriend))
						{
							if (bMeleeChar)
							{
								float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * HENCH_ATTRI_BUFF_SCALE_HIGH * IntToFloat(curIncreaseAmount) * adjustment;
								if (bIsAreaSpell)
								{
									maxEffectWeight += curEffectWeight;
								}
								else if (curEffectWeight > maxEffectWeight)
								{
									maxEffectWeight = curEffectWeight;
									oBestFriend = oFriend;
								}
							}
							else if (oFriend == oCharacter)
							{
								if (gsCurrentspInfo.spellLevel > gsDelayedAttrBuff.spellLevel)
								{
									gsDelayedAttrBuff = gsCurrentspInfo;
								}
							}
						}
						else if (oFriend == oCharacter)
						{
							if (gsCurrentspInfo.spellLevel > gsPolyAttrBuff.spellLevel)
							{
								gsPolyAttrBuff = gsCurrentspInfo;
							}
						}
					}
					else /* abilityType == ABILITY_DEXTERITY */
					{
						if (bRanged || GetHasFeat(FEAT_WEAPON_FINESSE, oFriend))
						{
							if (bMeleeChar)
							{
								float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * HENCH_ATTRI_BUFF_SCALE_HIGH * IntToFloat(curIncreaseAmount) * adjustment;
								if (bIsAreaSpell)
								{
									maxEffectWeight += curEffectWeight;
								}
								else if (curEffectWeight > maxEffectWeight)
								{
									maxEffectWeight = curEffectWeight;
									oBestFriend = oFriend;
								}
							}
							else if (oFriend == oCharacter)
							{
								if (gsCurrentspInfo.spellLevel > gsDelayedAttrBuff.spellLevel)
								{
									gsDelayedAttrBuff = gsCurrentspInfo;
								}
							}
						}
					}
				}
				else if (abilityType == ABILITY_WISDOM)
				{
					if ((GetLevelByClass(CLASS_TYPE_CLERIC, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_DRUID, oFriend) > 0) ||
						(GetLevelByClass(CLASS_TYPE_MONK, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oFriend) > 0))
					{
						float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * HENCH_ATTRI_BUFF_SCALE_LOW * IntToFloat(curIncreaseAmount) * adjustment;
						if (bIsAreaSpell)
						{
							maxEffectWeight += curEffectWeight;
						}
						else if (curEffectWeight > maxEffectWeight)
						{
							maxEffectWeight = curEffectWeight;
							oBestFriend = oFriend;
						}
					}
				}
				else if (abilityType == ABILITY_INTELLIGENCE)
				{
					if (GetLevelByClass(CLASS_TYPE_WIZARD, oFriend) > 0)
					{
						float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * HENCH_ATTRI_BUFF_SCALE_LOW * IntToFloat(curIncreaseAmount) * adjustment;
						if (bIsAreaSpell)
						{
							maxEffectWeight += curEffectWeight;
						}
						else if (curEffectWeight > maxEffectWeight)
						{
							maxEffectWeight = curEffectWeight;
							oBestFriend = oFriend;
						}
					}
				}
				else /* abilityType == ABILITY_CHARISMA */
				{
					if ((GetLevelByClass(CLASS_TYPE_BARD, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_SORCERER, oFriend) > 0) ||
						(GetLevelByClass(CLASS_TYPE_WARLOCK, oFriend) > 0) || (GetLevelByClass(CLASS_TYPE_PALADIN, oFriend) > 0)  ||
						(GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oFriend) > 0))
					{
						float curEffectWeight = SCGetThreatRating(oFriend,oCharacter) * HENCH_ATTRI_BUFF_SCALE_LOW * IntToFloat(curIncreaseAmount) * adjustment;
						if (bIsAreaSpell)
						{
							maxEffectWeight += curEffectWeight;
						}
						else if (curEffectWeight > maxEffectWeight)
						{
							maxEffectWeight = curEffectWeight;
							oBestFriend = oFriend;
						}
					}
				}
            }
        }
		oFriend = GetLocalObject(oFriend, sTargetList);
		curLoopCount ++;
    }

	if (maxEffectWeight > 0.0)
	{		
        SCHenchCheckIfLowestSpellLevelToCast(maxEffectWeight, bIsAreaSpell ? oCharacter : oBestFriend);
    }
}


location SCGetSummonLocation(float spellRange, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetSummonLocation Start", GetFirstPC() ); }
    
    object oTarget;
    if (GetIsObjectValid(goClosestSeenOrHeardEnemy))
    {
        oTarget = goClosestSeenOrHeardEnemy;
    }
    else if (GetIsObjectValid(goNotHeardOrSeenEnemy))
    {
        oTarget = goNotHeardOrSeenEnemy;
    }
    else if (GetIsObjectValid(GetMaster()))
    {
        oTarget = GetMaster();
    }
    else
    {
        return GetLocation(oCharacter);
    }
    vector vTarget = GetPosition(oTarget);
    vector vSource = GetPosition(oCharacter);
    vector vDirection = vTarget - vSource;
    float fDistance = VectorMagnitude(vDirection);
    // try to get summons just in front of target
    fDistance -= 3.0;
    if (fDistance < 0.5)
    {
        return GetLocation(oCharacter);
    }
    // maximum distance is spellrange
    if (fDistance > spellRange)
    {
        fDistance = spellRange;
    }
    vector vPoint = VectorNormalize(vDirection) * fDistance + vSource;
    return Location(GetArea(oCharacter), vPoint, GetFacing(oCharacter));
}


void SCHenchCheckSummons( object oCharacter = OBJECT_SELF )
{
    float effectWeight = SCGetCurrentSpellEffectWeight() * gfSummonAdjustment * gfBuffSelfWeight;
    // the summon location spell is set during casting
    SCHenchCheckIfHighestSpellLevelToCast(effectWeight, oCharacter);
}


void SCHenchCheckProtEvil( object oCharacter = OBJECT_SELF )
{
    object oBestEnemy = GetLocalObject(oCharacter, "HenchLineOfSight");
    if (gbDoingBuff || (GetIsObjectValid(oBestEnemy) && (GetAlignmentGoodEvil(oBestEnemy) == ALIGNMENT_EVIL)))
    {
        SCHenchCheckBuff();
    }
}


void SCHenchCheckProtGood( object oCharacter = OBJECT_SELF )
{
    object oBestEnemy = GetLocalObject(oCharacter, "HenchLineOfSight");
    if (GetIsObjectValid(oBestEnemy) && (GetAlignmentGoodEvil(oBestEnemy) == ALIGNMENT_GOOD))
    {
        SCHenchCheckBuff();
    }
}



void SCHenchCheckWeaponBuff( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckWeaponBuff Start", GetFirstPC() ); }
    
    int nItemProp = SCGetCurrentSpellEffectTypes();	
	int nEnhanceLevel = SCGetCurrentSpellSaveDCType();
    int nDamageType = SCGetCurrentSpellDamageInfo();
    if (nEnhanceLevel >= 100)
    {
        int nCasterLevel = (gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG) ?
            (gsCurrentspInfo.spellLevel * 2) - 1 : giMySpellCasterLevel;
        if (nEnhanceLevel == 100)
        {
            nEnhanceLevel = nCasterLevel / 4;
            if (nEnhanceLevel > 5)
            {
                nEnhanceLevel = 5;
            }
        }
        else if (nEnhanceLevel == 101)
        {
            nEnhanceLevel = (nCasterLevel + 1) / 3;
            if (nEnhanceLevel > 5)
            {
                nEnhanceLevel = 5;
            }
        }
		else if (nEnhanceLevel == 102)
		{
			nEnhanceLevel = nCasterLevel / 3 - 1;
			if (nEnhanceLevel > 5)
			{
				nEnhanceLevel = 5;
			}
			else if (nEnhanceLevel < 1)
			{
				nEnhanceLevel = 1;
			}
		}
        else
        {
            // error
            nEnhanceLevel = 1;
        }
    }
    int nFlags = SCGetCurrentSpellSaveType();
		
	if (nFlags & HENCH_WEAPON_HOLY_SWORD)
	{
		if (GetLevelByClass(CLASS_TYPE_PALADIN, oCharacter) <= 0)
		{
			return;
		}
		// make this spell self only
		gsCurrentspInfo.range = 0.0;
	}
	if (nFlags & HENCH_WEAPON_UNDEAD_FLAG)
	{
		if (GetRacialType(goSaveMeleeAttackTarget) != RACIAL_TYPE_UNDEAD)
		{
			return;
		}
	}
	
    float effectWeight = SCGetCurrentSpellEffectWeight();
	int spellID = gsCurrentspInfo.spellID; 
		
	if (GetIsObjectValid(goSaveMeleeAttackTarget))
	{
		effectWeight *= SCGetThreatRating(goSaveMeleeAttackTarget,oCharacter);
		if (nDamageType)
		{
			effectWeight *= SCGetDamageResistImmunityAdjustment(goSaveMeleeAttackTarget, 5.0, nDamageType, 1) / 5.0;
			if (effectWeight <= 0.01)
			{
				return;
			}
		}		
	}	
	
    int bDruidSpell = nFlags & HENCH_WEAPON_DRUID_FLAG;

//      " en " + IntToString(nEnhanceLevel) + " flags " + IntToString(nFlags) + " weight " + FloatToString(effectWeight) + " druid " + IntToString(bDruidSpell));

    object oBestFriend;
    float maxEffectWeight;

    object oFriend = oCharacter;
    int iLoopLimit = gsCurrentspInfo.range == 0.0 ? 1 : 5;
	float fRange = gbMeleeAttackers ? HENCH_ALLY_MELEE_TOUCH_RANGE : 20.0;
    int curLoopCount = 1;
    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		if (bDruidSpell)
		{
            if (curLoopCount == 1)
            {
                oFriend = oCharacter;
                if (!CSLGetIsAnimalOrBeastOrDragon(oCharacter))
                {
                    curLoopCount ++;
                    continue;
                }
            }
            else if (curLoopCount == 2)
            {
                oFriend = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
                if (!GetIsObjectValid(oFriend) || !CSLGetIsAnimalOrBeastOrDragon(oFriend))
                {
                    break;
                }
            }
            else
            {
                break;
            }
        }

        if (!GetHasSpellEffect(spellID, oFriend) && (GetDistanceToObject(oFriend) <= fRange))
        {
            // get weapon
            object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFriend);
            if (!GetIsObjectValid(oWeapon1))
            {
                oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oFriend);
                if (!GetIsObjectValid(oWeapon1))
                {
                    oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oFriend);
                    if (!GetIsObjectValid(oWeapon1))
                    {
                        oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oFriend);
                    }
                }
            }
            if (GetIsObjectValid(oWeapon1) && !GetWeaponRanged(oWeapon1))
            {
                int nWeaponType = GetWeaponType(oWeapon1);
                if (nWeaponType != WEAPON_TYPE_NONE)
                {
                    int bValid = TRUE;
                    float curEffectWeight = effectWeight;

                    if (nFlags & HENCH_WEAPON_STAFF_FLAG)
                    {
                        if (GetBaseItemType(oWeapon1) != BASE_ITEM_QUARTERSTAFF)
                        {
                            bValid = FALSE;
                        }
                    }
                    if (nFlags & HENCH_WEAPON_SLASH_FLAG)
                    {
                        if (nWeaponType != WEAPON_TYPE_PIERCING &&
                            nWeaponType != WEAPON_TYPE_SLASHING &&
                            nWeaponType != WEAPON_TYPE_PIERCING_AND_SLASHING)
                        {
                            bValid = FALSE;
                        }
                    }
                    if (nFlags & HENCH_WEAPON_BLUNT_FLAG)
                    {
                        if (nWeaponType != WEAPON_TYPE_BLUDGEONING)
                        {
                            bValid = FALSE;
                        }
                    }
                    if (nItemProp > 0)
                    {
                        if (GetItemHasItemProperty(oWeapon1, nItemProp))
                        {
                            bValid = FALSE;
                        }
                    }
                    if (nEnhanceLevel > 0)
                    {
                        int nBonus = nEnhanceLevel - SCGetItemAttackBonus(goSaveMeleeAttackTarget, oWeapon1).attackBonus;
                        if (nBonus > 0)
                        {
                            curEffectWeight *= IntToFloat(nBonus);
                        }
                        else
                        {
                            bValid = FALSE;
                        }
                    }
					if (nDamageType)
					{
						itemproperty curItemProp = GetFirstItemProperty(oWeapon1);
						while(GetIsItemPropertyValid(curItemProp))
						{
							//DEBUGGING// igDebugLoopCounter += 1;
//								" isub type " + IntToString(GetItemPropertySubType(curItemProp)) + " cost table " + IntToString(GetItemPropertyCostTableValue(curItemProp)) +
//								" item param 1 " + IntToString(GetItemPropertyParam1(curItemProp)) + " item param 1 value " + IntToString(GetItemPropertyParam1Value(curItemProp)));				
							if ((GetItemPropertyType(curItemProp) == ITEM_PROPERTY_DAMAGE_BONUS) &&
								(GetItemPropertyDurationType(curItemProp) == DURATION_TYPE_TEMPORARY))
							{					
								bValid = FALSE;
								break;
							}			
							curItemProp = GetNextItemProperty(oWeapon1);			
						}
					}
                    if (bValid)
                    {
                        if (oFriend == oCharacter)
                        {
                            if (!((SCGetCreaturePosEffects(oCharacter) & HENCH_EFFECT_TYPE_POLYMORPH) ||
                                (GetBaseAttackBonus(oCharacter) >= (3 * GetHitDice(oCharacter) / 4))))
                            {
                                curEffectWeight = -1.0;
                                if (gsCurrentspInfo.spellLevel > gsMeleeAttackspInfo.spellLevel)
                                {
                                    gsMeleeAttackspInfo = gsCurrentspInfo;
                                }
                            }
                            else
                            {
                                curEffectWeight *= gfBuffSelfWeight;
                            }
                        }
                        else
                        {
                            // adjust for compassion
                            curEffectWeight *= gfBuffOthersWeight;
                        }
                        if (curEffectWeight > maxEffectWeight)
                        {
                            oBestFriend = oFriend;
                            maxEffectWeight = curEffectWeight;
                        }
                    }
                }
            }
        }
        oFriend = GetLocalObject(oFriend, "HenchAllyList");
        curLoopCount ++;
    }

    if (maxEffectWeight > 0.0)
    {
        SCHenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}




void SCHenchCheckPolymorph( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckPolymorph Start", GetFirstPC() ); }
	
	int nPolymorphFlags = SCGetCurrentSpellEffectTypes();
    int nPosEffects = SCGetCreaturePosEffects(oCharacter);
	
	if (nPolymorphFlags & HENCH_POLYMORPH_CHECK_NON_POLYMORPH)
	{
		if (nPosEffects & HENCH_EFFECT_TYPE_DAMAGE_REDUCTION)
		{
			return;
		}
	}
	else
	{
		if (nPosEffects & HENCH_EFFECT_TYPE_POLYMORPH)
		{
			return;
		}
	}
	if (!(nPolymorphFlags & HENCH_POLYMORPH_CHECK_NON_POLYMORPH) || (gbAnySpellcastingClasses & HENCH_ARCANE_SPELLCASTING) ||
		!GetIsImmune(oCharacter, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE))
	{
		if (!gbMeleeAttackers && !GetHasFeat(FEAT_NATURAL_SPELL, oCharacter) && !(nPolymorphFlags & HENCH_POLYMORPH_CHECK_NATURAL_SPELL))
		{
			return;
		}
		if (GetHasFeat(FEAT_NATURAL_SPELL, oCharacter) && (GetHasFeat(FEAT_ELEMENTAL_SHAPE, oCharacter) || GetHasFeat(FEAT_WILD_SHAPE, oCharacter)) &&
			!(nPolymorphFlags & HENCH_POLYMORPH_CHECK_NATURAL_SPELL))
		{
			// don't polymorph into a shape with no spellcasting
			return;
		}
	}
	else
	{
		// this spell is a buff, treat as a damage reduction spell (stoneskin for cleric)
    	SCHenchInitMeleeAttackers();
		if (gbIAmMeleeTarget)
		{
            float targetChance = GetLocalFloat(oCharacter, "HenchMeleeTarget");
            if (targetChance >= 0.01)
			{
                float curEffectWeight = 0.9 * targetChance;
                    // found target
                curEffectWeight *= SCGetThreatRating(oCharacter,oCharacter);
                curEffectWeight *= gfBuffSelfWeight;				
        		SCHenchCheckIfLowestSpellLevelToCast(curEffectWeight, oCharacter);
				return;
			} 		
		}	
	}
	
    float effectWeight = SCGetCurrentSpellEffectWeight();
	if ((nPolymorphFlags & HENCH_POLYMORPH_CHECK_MAGIC_FANG) && GetHasSpell(SPELL_GREATER_MAGIC_FANG, oCharacter))
	{
		effectWeight += 5.0;
	}
    if (effectWeight > gfMaxPolymorph)
    {
        gsPolymorphspInfo = gsCurrentspInfo;
        gfMaxPolymorph = effectWeight;
    }
}


void SCHenchCheckConcealment(float fConcealAmount, float fWeight, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckConcealment Start", GetFirstPC() ); }
    
    SCHenchInitMeleeAttackers();

    int bSelfOnly = gsCurrentspInfo.range < 0.1;
    if (bSelfOnly && !gbIAmMeleeTarget)
    {
        return;
    }

    float maxEffectWeight;
    object oBestFriend;

    object oFriend = oCharacter;
	
    while (GetIsObjectValid(oFriend))
    {	
        //DEBUGGING// igDebugLoopCounter += 1;
        float curConcealment = fConcealAmount - GetLocalFloat(oFriend, "HenchRangedConcealment");
		
        if (curConcealment > 0.15)
        {
            float targetChance = GetLocalFloat(oFriend, "HenchMeleeTarget");
			float curEffectWeight = fWeight * curConcealment * targetChance;

			// found target
			curEffectWeight *= SCGetThreatRating(oFriend,oCharacter);
			if (oFriend == oCharacter)
			{
				curEffectWeight *= gfBuffSelfWeight;
			}
			else
			{
				// adjust for compassion
				curEffectWeight *= gfBuffOthersWeight;
			}
			
			if (curEffectWeight > maxEffectWeight)
			{
				maxEffectWeight = curEffectWeight;
				oBestFriend = oFriend;
			}
        }
        if (bSelfOnly)
        {
            break;
        }
        oFriend = GetLocalObject(oFriend, "HenchMeleeTarget");
    }
    if (maxEffectWeight > 0.0)
    {
        SCHenchCheckIfLowestSpellLevelToCast(maxEffectWeight, oBestFriend);
    }
}




void SCHenchConcealment( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchConcealment Start", GetFirstPC() ); }
	
	int bIsDarkness = gsCurrentspInfo.shape != HENCH_SHAPE_NONE;
	float fWeight;
	if (bIsDarkness)
	{
		if (HENCH_DARKNESS_CHECK_NOT_INITIALIZED == giDarknessCheck)
		{
			if (!GetActionMode(oCharacter, ACTION_MODE_STEALTH))
			{
				SCHenchInitMeleeAttackers();
				if (gbIAmMeleeTarget && (GetLocalFloat(oCharacter, "HenchMeleeTarget") > 0.5))
				{
					giDarknessCheck = HENCH_DARKNESS_CHECK_ENABLE;
				}
				else
				{
					giDarknessCheck = HENCH_DARKNESS_CHECK_DISABLE;
				}
			}
			else
			{
				giDarknessCheck = HENCH_DARKNESS_CHECK_DISABLE;
			}
		}
		if (giDarknessCheck != HENCH_DARKNESS_CHECK_ENABLE)
		{
			return;
		}
		fWeight = 1.0;
	}
	else
	{
		fWeight = 2.0;
	}	
	SCHenchCheckConcealment(SCGetCurrentSpellEffectWeight(), fWeight);
}


void SCHenchCheckAnimalCompanionBuff(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckAnimalCompanionBuff Start", GetFirstPC() ); }
    
    object oFriend = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
    if (!GetIsObjectValid(oFriend) ||
        (GetDistanceToObject(oFriend) > (gbMeleeAttackers ? 5.0 : 20.0)))
    {
        return;
    }	
	int spellID = gsCurrentspInfo.spellID;
    if (GetHasSpellEffect(spellID, oFriend))
	{
		return;
	}	
    if (spellID == SPELL_AWAKEN)
    {
        int strIncAmount = 4 - SCGetCreatureAbilityIncrease(oFriend, ABILITY_STRENGTH);
        if (strIncAmount < 0)
        {
            strIncAmount = 0;
        }
        int conIncAmount = 4 - SCGetCreatureAbilityIncrease(oFriend, ABILITY_CONSTITUTION);
        if (conIncAmount < 0)
        {
            conIncAmount = 0;
        }
        float curEffectWeight = 0.06 + HENCH_ATTRI_BUFF_SCALE_HIGH * (strIncAmount + conIncAmount) * SCGetThreatRating(oFriend,oCharacter);
        SCHenchCheckIfLowestSpellLevelToCast(curEffectWeight, oFriend);
    }
    else if (spellID == SPELL_NATURE_AVATAR)
    {
		int iRacialType = GetRacialType(oFriend);
    	if ((iRacialType != RACIAL_TYPE_ANIMAL) &&
        	(iRacialType != RACIAL_TYPE_BEAST) &&
        	(iRacialType != RACIAL_TYPE_VERMIN))
		{
			return;
		}
        int posEffects = SCGetCreaturePosEffects(oFriend);
        float curEffectWeight;
        if (!(posEffects & HENCH_EFFECT_TYPE_HASTE))
        {
            curEffectWeight += 0.3;
        }
        if (!(posEffects & HENCH_EFFECT_TYPE_TEMPORARY_HITPOINTS))
        {
            curEffectWeight += 0.2;
        }
        if (!(posEffects & HENCH_EFFECT_TYPE_DAMAGE_INCREASE))
        {
            curEffectWeight += 0.15;
        }
        curEffectWeight *= SCGetThreatRating(oFriend,oCharacter);
        SCHenchCheckIfLowestSpellLevelToCast(curEffectWeight, oFriend);
    }
    else if (spellID == 1828)		// Nature's Favor
    {
        int posEffects = SCGetCreaturePosEffects(oFriend);
        float curEffectWeight;
        if (!(posEffects & HENCH_EFFECT_TYPE_DAMAGE_INCREASE))
        {
            curEffectWeight += 0.15;
        }
        if (!(posEffects & HENCH_EFFECT_TYPE_ATTACK_INCREASE))
        {
            curEffectWeight += 0.15;
        }
        curEffectWeight *= SCGetThreatRating(oFriend,oCharacter);
        SCHenchCheckIfLowestSpellLevelToCast(curEffectWeight, oFriend);
    }
}


void SCHenchCheckInvisibility( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckInvisibility Start", GetFirstPC() ); }
    
    int spellEffectTypes = SCGetCurrentSpellEffectTypes();
	
	
	if (spellEffectTypes & HENCH_EFFECT_TYPE_CONCEALMENT)
	{
		SCHenchCheckConcealment(0.5, 2.5);	
	}	
	float curWeight = SCGetCurrentSpellEffectWeight();
	if (spellEffectTypes & HENCH_EFFECT_TYPE_ETHEREAL)
	{
		if (SCGetCreaturePosEffects(oCharacter) & HENCH_EFFECT_TYPE_ETHEREAL)
		{
			return;
		}	
	}
	else
	{
		if (gbTrueSeeingNear)
		{
			return;
		}
		if (spellEffectTypes & HENCH_EFFECT_TYPE_INVISIBILITY)
		{
			if (gbSeeInvisNear)
			{
				return;
			}		
		}
		else if (spellEffectTypes & HENCH_EFFECT_TYPE_SANCTUARY)
		{		
			int saveDC;
			int spellID = gsCurrentspInfo.spellID;
			
			if (spellID == SPELLABILITY_DIVINE_PROTECTION)
			{
				saveDC = 10 + GetAbilityModifier(ABILITY_CHARISMA) + GetLevelByClass(CLASS_TYPE_CLERIC);			
			}
			else if (spellID == SPELLABILITY_SONG_HAVEN_SONG)
			{
				saveDC = 11 + (GetSkillRank(SKILL_PERFORM) / 2);
			}		
			else // SPELL_SANCTUARY
			{
				saveDC = SCGetCurrentSpellSaveDC(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG, 1);
			}
			object oTarget = GetLocalObject(oCharacter, "HenchLineOfSight");
			if (!GetIsObjectValid(oTarget))
			{			
				oTarget = goClosestSeenOrHeardEnemy;
			}
			if (GetIsObjectValid(oTarget))
			{
				float fChance = SCGetd20ChanceLimited(saveDC - GetWillSavingThrow(oTarget));
				if (fChance < 0.67)
				{
					return;
				}
				curWeight *= fChance;
			}
		}
		else if (spellEffectTypes == 0)
		{
			if (!GetActionMode(oCharacter, ACTION_MODE_STEALTH) || GetHasSpellEffect(gsCurrentspInfo.spellID, oCharacter))
			{
				return;
			}
			if (GetHasSpellEffect(SPELLABILITY_DIVINE_TRICKERY, oCharacter) || GetHasSpellEffect(SPELLABILITY_ROGUES_CUNNING, oCharacter) || GetHasSpellEffect(SPELL_CAMOFLAGE, oCharacter) || GetHasSpellEffect(SPELL_MASS_CAMOFLAGE, oCharacter))
			{
				return;
			}
			if (curWeight > gfSelfHideWeight)
			{
				gfSelfHideWeight = curWeight;
				gsBestSelfHide = gsCurrentspInfo;
			}
			return;
		}
	}
    if (curWeight > gfSelfInvisiblityWeight)
    {
        gfSelfInvisiblityWeight = curWeight;
        gsBestSelfInvisibility = gsCurrentspInfo;
    }
    if (curWeight > gfSelfHideWeight)
    {
        gfSelfHideWeight = curWeight;
        gsBestSelfHide = gsCurrentspInfo;
    }
}




void SCInitializeCreatureInformation(object oTarget)
{
    SCAIInitCachedCreatureInformation(oTarget);

    SetLocalInt(oTarget, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_UNKNOWN);
}














int SCGetIsLowBAB( object oCharacter = OBJECT_SELF )
{
	return ((5 * GetBaseAttackBonus(oCharacter)) < (3 *  GetHitDice(oCharacter)));
}













void SCCleanCombatVars( object oCharacter = OBJECT_SELF )
{
    DeleteLocalInt(oCharacter, "tkCombatRoundCount");
    DeleteLocalInt(oCharacter, "tkLastDragonBreath");
    DeleteLocalInt(oCharacter, "tkLastDispel");
    DeleteLocalInt(oCharacter, "tkLastDominate");
    DeleteLocalInt(oCharacter, "tkLastTurning");
    DeleteLocalObject(oCharacter, "LastTarget");
    DeleteLocalLocation(oCharacter, "HENCH_LAST_ATTACK_LOC");
    DeleteLocalInt(oCharacter, HENCH_AI_SCRIPT_HB);
	DeleteLocalInt(oCharacter, HENCH_AI_BLOCKED);
	DeleteLocalInt(oCharacter, "HenchShouldIAttackMessageGiven");
}


void SCReportUnseenAllies(object oCharacter = OBJECT_SELF)
{
    location testTargetLoc = GetLocation(oCharacter);
    object oAllyTest = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oAllyTest))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if ((oAllyTest != oCharacter) && !GetObjectSeen(oAllyTest) && GetFactionEqual(oAllyTest))
        {
			//	"I can't see "
            SpeakString(GetStringByStrRef(230439) + GetName(oAllyTest));
        }
        oAllyTest = GetNextObjectInShape(SHAPE_SPHERE, 20.0, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE);
    }
}






int SCGetIsDisabled(object oTarget)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        switch (GetEffectType(eCheck))
        {
        case EFFECT_TYPE_PARALYZE:
        case EFFECT_TYPE_STUNNED:
        case EFFECT_TYPE_FRIGHTENED:
        case EFFECT_TYPE_SLEEP:
        case EFFECT_TYPE_DAZED:
        case EFFECT_TYPE_CONFUSED:
        case EFFECT_TYPE_TURNED:
        case EFFECT_TYPE_PETRIFY:
		case EFFECT_TYPE_MESMERIZE:
		case EFFECT_TYPE_CUTSCENE_PARALYZE:
             return TRUE;
        }

        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}








void SCActionContinueEquip(object oTarget, int bIndicateStatus, int iCallNumber, object oCharacter = OBJECT_SELF )
{
    if (GetLocalInt(oCharacter, "UseRangedWeapons"))
    {
        if (!SCEquipRangedWeapon(oTarget, bIndicateStatus, iCallNumber))
        {
            ActionDoCommand(SCActionContinueEquip(oTarget, bIndicateStatus, iCallNumber + 1));
        }
    }
    else
    {
        if (!SCEquipMeleeWeapons(oTarget, bIndicateStatus, iCallNumber))
        {
            ActionDoCommand(SCActionContinueEquip(oTarget, bIndicateStatus, iCallNumber + 1));
        }
    }
}




void SCClearWeaponStates(object oCharacter = OBJECT_SELF)
{
    DeleteLocalInt(oCharacter, "SwitchedToMelee");
    DeleteLocalInt(oCharacter, "SwitchedToRanged");
    DeleteLocalInt(oCharacter, "HaveShieldStatus");
    DeleteLocalObject(oCharacter, "StoredShield");
    DeleteLocalInt(oCharacter, "HaveOffhandStatus");
    DeleteLocalObject(oCharacter, "StoredOffHand");
    DeleteLocalInt(oCharacter, HENCH_AI_WEAPON);
}


void SCActionChangeEquippedWeapons( object oCharacter = OBJECT_SELF )
{
    ClearAllActions();
    SCClearWeaponStates(oCharacter);
    SCHenchEquipDefaultWeapons(oCharacter, !SCGetHenchPartyState(HENCH_PARTY_DISABLE_WEAPON_EQUIP_MSG));
}


void SCChangeEquippedWeapons( object oCharacter = OBJECT_SELF )
{
    if (oCharacter == OBJECT_SELF)
    {
        SCActionChangeEquippedWeapons();
    }
    else
    {
        AssignCommand(oCharacter, SCActionChangeEquippedWeapons());
    }
}



/*

    Companion and Monster AI

    This file contains functions used in the default On* scripts
    for henchman actions during noncombat. This includes dealing
    with traps, locks, items, and containers

*/


//void main() {  }








int SCGetIAmNotDoingAnything( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetIAmNotDoingAnything Start", GetFirstPC() ); }
    
    int currentAction = GetCurrentAction(oCharacter);

    return !IsInConversation(oCharacter)
        && !GetIsObjectValid(GetAttemptedAttackTarget())
        && !GetIsObjectValid(GetAttemptedSpellTarget())
        && currentAction != ACTION_REST
        && currentAction != ACTION_DISABLETRAP
        && currentAction != ACTION_OPENLOCK
        && currentAction != ACTION_USEOBJECT
        && currentAction != ACTION_RECOVERTRAP
        && currentAction != ACTION_EXAMINETRAP
        && currentAction != ACTION_PICKUPITEM
        && currentAction != ACTION_HEAL
        && currentAction != ACTION_TAUNT;
}


int SCHenchCheckArea(int nClearActions = FALSE, object oCharacter = OBJECT_SELF )
{
    //    only execute if we have something to do
    if (!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) &&
		(!CSLGetAssociateState(CSL_ASC_MODE_PUPPET) || SCGetHenchPartyState(HENCH_PARTY_ENABLE_PUPPET_FOLLOW)) &&
		!GetLocalInt(oCharacter, "DoNotAttack") &&
        SCGetIAmNotDoingAnything() &&
        ((GetHasSkill(SKILL_DISABLE_TRAP) && CSLGetAssociateState(CSL_ASC_DISARM_TRAPS)) ||				
		SCGetHenchAssociateState(HENCH_ASC_AUTO_OPEN_LOCKS | HENCH_ASC_AUTO_PICKUP) ||		
        GetIsObjectValid(GetLocalObject(oCharacter, "tk_master_lock_failed"))))
    {
		ExecuteScript("hench_o0_act", oCharacter);
		return GetLocalInt(oCharacter, "tk_action_result");
    }
    else
    {
        SCClearForceOptions();
    }
    return FALSE;
}





// void main() {    }


//::///////////////////////////////////////////////
//:: Respond To Shouts
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the listener to react in a manner
    consistent with the given shout but only to one
    combat shout per round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////

//NOTE ABOUT COMMONERS
/*
    Commoners are universal cowards.  If you attack anyone they will flee for 4 seconds away from the attacker.
    However to make the commoners into a mob, make a single commoner at least 10th level of the same faction.
    If that higher level commoner is attacked or killed then the commoners will attack the attacker.  They will disperse again
    after some of them are killed.  Should NOT make multi-class creatures using commoners.
*/
//NOTE ABOUT BLOCKERS
/*
    It should be noted that the Generic Script for On Dialogue attempts to get a local set on the shouter by itself.
    This object represents the LastOpenedBy object.  It is this object that becomes the oIntruder within this function.
*/

//NOTE ABOUT INTRUDERS
/*
    The intruder object is for cases where a placable needs to pass a LastOpenedBy Object or a AttackMyAttacker
    needs to make his attacker the enemy of everyone.
    
    
    int GetObjectSeen( oResponder, oShouter);
    int GetObjectHeard( oResponder, oShouter);
    float GetDistanceBetween(object oObjectA, object oObjectB);
    int LineOfSightObject( object oSource, object oTarget );
    
    
    
*/

int SCGetCanHearShouter( object oShouter, object oResponder )
{
	if ( oShouter==OBJECT_INVALID || oResponder==OBJECT_INVALID || oShouter == oResponder ) { return FALSE; } // make sure they are actually objects
	
	// basically make it so a 5% always hears, and a 5% never hears, just to keep things livley
	int iRoll = d20();
	if ( iRoll == 20 ) 
	{
		return TRUE;
	}
		
	
	object oArea = GetArea( oShouter );
	if ( oArea != GetArea( oResponder ) )
	{
		return FALSE;
	}
	
	
	float fDistance = GetDistanceBetween( oShouter, oResponder);
	
	if ( iRoll == 1 && fDistance > 20.0f ) 
	{
		return FALSE;
	}
	
	float fSeeingRange = 0.0f;
	float fHearingRange = 0.0f;
	// deal with hearing first
	if ( GetObjectHeard( oResponder, oShouter) )
	{
		fHearingRange = GetLocalFloat( oArea, "CSL_MAXHEARINGRANGE");
		if ( fHearingRange >= 0.0f )
		{
			if ( GetIsAreaInterior( GetArea(oShouter ) ) )
			{
				fHearingRange = 30.0f;
			}
			else
			{
				fHearingRange = 60.0f;
			}
		}
	}
	
	if ( fDistance < fHearingRange/2.0f ) // they are so close they can always hear, even thru walls and doors
	{
		return TRUE;
	}
		
	if ( GetObjectSeen( oResponder, oShouter) )
	{
		fSeeingRange = GetLocalFloat( oArea, "CSL_MAXSEEINGRANGE");
		if ( fSeeingRange >= 0.0f )
		{
			if ( GetIsAreaInterior( GetArea(oShouter ) ) )
			{
				fSeeingRange = 100.0f;
			}
			else
			{
				fSeeingRange = 150.0f;
			}
		}
	}
	else if ( GetHasFeat(FEAT_BLIND_FIGHT, oResponder) )
	{
		fSeeingRange = 25.0f;
	}
	
	if ( fDistance > fSeeingRange ) // Completely out of perception range, so avoid LOS check
	{
		return FALSE;
	}
	
	if ( LineOfSightObject( oResponder, oShouter ) )
	{
	
		if ( fDistance < fHearingRange || fDistance < fSeeingRange )
		{
			return TRUE;
		}
	}
	
	return FALSE;
}

// modified form of shout handler, calls different routines
void SCHenchMonRespondToShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchMonRespondToShout Start", GetFirstPC() ); }
    
    if ( !SCGetCanHearShouter( oShouter, oCharacter ) )
    {
    	return;
    }
    // Pausanias: Do not respond to shouts if you've surrendered.
	// don't respond to shouts if flagged as plot
    if (GetLocalInt(oCharacter, "Generic_Surrender") || GetPlotFlag())
	{
		return;
	}

    switch (nShoutIndex)
    {
        case 1://NW_GENERIC_SHOUT_I_WAS_ATTACKED:
        case 3://NW_GENERIC_SHOUT_I_AM_DEAD:
            {
                object oTarget = oIntruder;
                if (!GetIsObjectValid(oTarget))
                {
                    oTarget = GetLastHostileActor(oShouter);
                    if (!GetIsObjectValid(oTarget))
                    {
                        oTarget = GetLocalObject(oShouter, "LastTarget");
                    }
                }
                if (!SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
                {
                    if (!GetLevelByClass(CLASS_TYPE_COMMONER))
                    {
                        if (!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
                        {
                            if (GetIsObjectValid(oTarget))
                            {
                                 if (!GetIsFriend(oTarget) && (GetFactionEqual(oShouter) || GetIsFriend(oShouter)))
                                 {
                                    SCRemoveAmbientSleep();
                                    SCHenchDetermineCombatRound(oTarget);
                                }
                            }
                        }
                    }
                    else if (GetLevelByClass(CLASS_TYPE_COMMONER, oShouter) >= 10)
                    {
                         SCHenchStartAttack(GetLastHostileActor(oShouter));
                    }
                    else
                    {
                        SCHenchDetermineCombatRound(oTarget);
                    }
                }
                else
                {
                    SCHenchDetermineSpecialBehavior();
                }
            }
            break;

        case 2://NW_GENERIC_SHOUT_MOB_ATTACK:
            {
                if (!SCGetBehaviorState(CSL_FLAG_BEHAVIOR_SPECIAL))
                {
                    //Is friendly check to make sure that only like minded commoners attack.
                    if (GetFactionEqual(oShouter) || GetIsFriend(oShouter))
                    {
                         SCHenchStartAttack(GetLastHostileActor(oShouter));
                    }
                }
                else
                {
                    SCHenchDetermineSpecialBehavior();
                }
            }
            break;

        //For this shout to work the object must shout the following
        //string sHelp = "NW_BLOCKER_BLK_" + GetTag(oCharacter);
        case 4: //BLOCKER OBJECT HAS BEEN DISTURBED
            {
                if (!GetLevelByClass(CLASS_TYPE_COMMONER))
                {
                    if (!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
                    {
                        if (GetIsObjectValid(oIntruder))
                        {
                            SetIsTemporaryEnemy(oIntruder);
                            SCHenchDetermineCombatRound(oIntruder);
                        }
                    }
                }
                else if (GetLevelByClass(CLASS_TYPE_COMMONER, oShouter) >= 10)
                {
                    SCHenchStartAttack(GetLastHostileActor(oShouter));
                }
                else
                {
                    SCHenchDetermineCombatRound();
                }
            }
            break;

        case 5: //ATTACK MY TARGET NW_ATTACK_MY_TARGET
            {
                if (GetFactionEqual(oShouter) || GetIsFriend(oShouter))
                {
                    AdjustReputation(oIntruder, oCharacter, -100);
                    SetIsTemporaryEnemy(oIntruder);
                    SCHenchDetermineCombatRound(oIntruder);
                }
            }
            break;

        case 6: //CALL_TO_ARMS 
            {
                //This was once commented out.
                SCHenchDetermineCombatRound();
            }
            break;
        case 101: //RESPOND TO SNEAKER, they were gaming the AI
            //if ( SCHenchCheckDetectInvisibility(oCharacter) 
            SCSetSpawnInCondition(CSL_FLAG_SEARCH,TRUE,oCharacter);
            
            
            
            SCMoveToLastSeenOrHeard(TRUE, oCharacter );
            break;       
    }
}








int SCHasItemTalentSpell(int spellID)
{
    if (giItemTalentSpellCount < 1)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID1)
    {
        return 1;
    }
    if (giItemTalentSpellCount < 2)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID2)
    {
        return 2;
    }
    if (giItemTalentSpellCount < 3)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID3)
    {
        return 3;
    }
    if (giItemTalentSpellCount < 4)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID4)
    {
        return 4;
    }
    if (giItemTalentSpellCount < 5)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID5)
    {
        return 5;
    }
    if (giItemTalentSpellCount < 6)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID6)
    {
        return 6;
    }
    if (giItemTalentSpellCount < 7)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID7)
    {
        return 7;
    }
    if (giItemTalentSpellCount < 8)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID8)
    {
        return 8;
    }
    if (giItemTalentSpellCount < 9)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID9)
    {
        return 9;
    }
    if (giItemTalentSpellCount < 10)
    {
        return FALSE;
    }
    if (spellID == giItemSpellID10)
    {
        return 10;
    }
    return TRUE;
}


void SCAddItemTalentSpell(int spellID)
{
    if (giItemTalentSpellCount >= HENCH_AI_MAXITEM_TALENTSPELLCOUNT)
    {
        return;
    }
    giItemTalentSpellCount ++;

    if (giItemTalentSpellCount == 1)
    {
        giItemSpellID1 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 2)
    {
        giItemSpellID2 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 3)
    {
        giItemSpellID3 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 4)
    {
        giItemSpellID4 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 5)
    {
        giItemSpellID5 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 6)
    {
        giItemSpellID6 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 7)
    {
        giItemSpellID7 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 8)
    {
        giItemSpellID8 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 9)
    {
        giItemSpellID9 = spellID;
        return;
    }
    if (giItemTalentSpellCount == 10)
    {
        giItemSpellID10 = spellID;
        return;
    }
}


void SCHenchCheckCastAuraSpell( object oCharacter = OBJECT_SELF )
{
	if (giAuraSpellToCast > 0)
	{
		// TODO put this back // AssignCommand(oCharacter, ActionCastSpellAtObject(giAuraSpellToCast, oCharacter, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
		// removes the cheat casting from the AI
		AssignCommand(oCharacter, ActionCastSpellAtObject(giAuraSpellToCast, oCharacter, METAMAGIC_NONE, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
	}
}



int SCHenchCheckDetectInvisibility(object oCharacter = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "SCHenchCheckDetectInvisibility Start", GetFirstPC() ); }
	
    object oTarget;
	int targetUsingStealth;
	int targetPositiveEffects;
	if (gbDoingBuff)
	{
		oTarget = oCharacter;
		targetPositiveEffects = HENCH_EFFECT_TYPE_INVISIBILITY | HENCH_EFFECT_TYPE_SANCTUARY;
	}
    else if (GetIsObjectValid(goClosestHeardEnemy))
    {
        oTarget = goClosestHeardEnemy;
		targetUsingStealth = GetStealthMode(oTarget);
		targetPositiveEffects = SCGetCreaturePosEffects(oTarget);
    }
    else if (GetIsObjectValid(goNotHeardOrSeenEnemy))
    {
        oTarget = goNotHeardOrSeenEnemy;
		targetUsingStealth = GetStealthMode(oTarget);
		targetPositiveEffects = SCGetCreaturePosEffects(oTarget);
    }
    else
    {
        return FALSE;
    }
	if (targetPositiveEffects & HENCH_EFFECT_TYPE_ETHEREAL)
	{
		return FALSE;
	}
	if (targetUsingStealth)
	{
		// if using stealth but easy to spot, don't count
		targetUsingStealth = GetSkillRank(SKILL_SPOT) < (GetSkillRank(SKILL_HIDE, oTarget) - 5);
	}
	
	int nSpellID = gsCurrentspInfo.spellID;
    int effectTypes = SCGetCurrentSpellEffectTypes();
	if (nSpellID == SPELL_INVISIBILITY_PURGE)
	{
		if (GetHasSpellEffect(SPELL_INVISIBILITY_PURGE, oCharacter))
		{
			return FALSE;
		}
		if (GetDistanceToObject(oTarget) > 10.0)
		{
			return FALSE;
		}
		effectTypes	= HENCH_EFFECT_TYPE_SEEINVISIBILE;	// treat as if see invisible
	}

    object oBestFriend = oCharacter;
    float maxEffectWeight;

    object oFriend = oCharacter;
    int iLoopLimit = (gbMeleeAttackers || (gsCurrentspInfo.range == 0.0)) ? 1 : 5;
    int curLoopCount = 1;
    float effectWeight = SCGetCurrentSpellEffectWeight();


    while (curLoopCount <= iLoopLimit && GetIsObjectValid(oFriend))
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		if (!(GetLocalInt(oFriend, "HenchCurNegEffects") & HENCH_EFFECT_DISABLED))
		{
			float curEffectWeight = effectWeight;
			if (curLoopCount == 1)
			{
				curEffectWeight *= gfBuffSelfWeight;
			}
			else
			{
				curEffectWeight *= gfBuffOthersWeight;
			}
			if (effectTypes)
			{
				int posEffects = SCGetCreaturePosEffects(oFriend);
				if (!((HENCH_EFFECT_TYPE_TRUESEEING | effectTypes) & posEffects) && !targetUsingStealth)
				{			
					if (targetPositiveEffects & ((effectTypes & HENCH_EFFECT_TYPE_TRUESEEING) ? HENCH_EFFECT_TYPE_INVISIBILITY | HENCH_EFFECT_TYPE_SANCTUARY : HENCH_EFFECT_TYPE_INVISIBILITY))
					{
						if (curEffectWeight > maxEffectWeight)
						{
							oBestFriend = oFriend;
							maxEffectWeight = curEffectWeight;
						}
					}
				}
			}
			else
			{
				if (!(GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, oFriend) ||		
					GetHasSpellEffect(SPELL_AMPLIFY, oFriend)))
				{
					if (gbDoingBuff || (nSpellID != SPELL_AMPLIFY) || !GetObjectHeard(oTarget, oFriend))
					{					
						if (curEffectWeight > maxEffectWeight)
						{
							oBestFriend = oFriend;
							maxEffectWeight = curEffectWeight;
						}
					}
				}
			}
		}
        oFriend = GetLocalObject(oFriend, "HenchAllyList");
        curLoopCount ++;
    }
	
	maxEffectWeight *= SCGetThreatRating(oTarget,oCharacter);
    if (maxEffectWeight > 0.0)
    {
        SCHenchCheckIfHighestSpellLevelToCast(maxEffectWeight, oBestFriend);
        return TRUE;
    }
    
    if ( GetActionMode(oCharacter, ACTION_MODE_DETECT) != TRUE && !GetHasFeat( FEAT_KEEN_SENSE,  oCharacter ) && GetSkillRank( SKILL_SPOT, oCharacter )  > 4 ) 
	{
		SetActionMode(oCharacter, ACTION_MODE_DETECT, TRUE);
		return TRUE;
	}
            
    return FALSE;
}



void SCDispatchSpell(int nItemType, object oCharacter = OBJECT_SELF )
{
	int iOldDebugging = DEBUGGING;
	//DEBUGGING// if (DEBUGGING > 8 && DEBUGGING < 10) { DEBUGGING = 10; }
	//DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "SCDispatchSpell Start nItemType="+IntToString(nItemType), GetFirstPC() ); }
    
    int iTargetInformation = GetLocalInt(GetModule(), gsCurrentSpellInfoStr + "TargetInfo");
    gsCurrentspInfo.shape = iTargetInformation & HENCH_SPELL_TARGET_SHAPE_MASK;
    switch (iTargetInformation & HENCH_SPELL_TARGET_RANGE_MASK)
    {
		case HENCH_SPELL_TARGET_RANGE_PERSONAL:
			gsCurrentspInfo.range = 0.0;
			break;
		case HENCH_SPELL_TARGET_RANGE_TOUCH:
			gsCurrentspInfo.range = 4.0;
			break;
		case HENCH_SPELL_TARGET_RANGE_SHORT:
			gsCurrentspInfo.range = 8.0;
			break;
		case HENCH_SPELL_TARGET_RANGE_MEDIUM:
			gsCurrentspInfo.range = 20.0;
			break;
		case HENCH_SPELL_TARGET_RANGE_LONG:
			gsCurrentspInfo.range = 40.0;
			break;
		case HENCH_SPELL_TARGET_RANGE_INFINITE:
			gsCurrentspInfo.range = 300.0;
			break;
    }
    if (nItemType)
    {
        gsCurrentspInfo.spellInfo |= HENCH_SPELL_INFO_ITEM_FLAG;
        if (nItemType == HENCH_ITEM_TYPE_POTION)
        {
            gsCurrentspInfo.range = 0.0;
        }
        else
        {
                // wands, etc. don't have AoO
            gsCurrentspInfo.spellInfo &= HENCH_SPELL_INFO_REMOVE_CONCENTRATION_FLAG;
        }
    }
    gsCurrentspInfo.radius = IntToFloat((iTargetInformation & HENCH_SPELL_TARGET_RADIUS_MASK) >> 6) / 10.0;


    int iSpellType = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK;
    if (!(gsCurrentspInfo.spellInfo & gbSpellInfoCastMask))
    {
        return;
    }
    
	//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCDispatchSpell iSpellType="+IntToString(iSpellType), GetFirstPC() ); }
    switch (iSpellType)
    {
		case HENCH_SPELL_INFO_SPELL_TYPE_ATTACK:
		case HENCH_SPELL_INFO_SPELL_TYPE_HEAL:
		case HENCH_SPELL_INFO_SPELL_TYPE_HARM:
			//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCDispatchSpell calling SCAISpellAttack", GetFirstPC() ); }
			SCAISpellAttack(SCGetCurrentSpellSaveType(), iTargetInformation, oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_BUFF:
			SCHenchCheckBuff(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_AC_BUFF:
			SCHenchCheckACBuff(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_DR_BUFF:
			SCHenchCheckDRBuff(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_PERSISTENTAREA:
			// just activate with quick cast if not present
			if (!GetHasSpellEffect(gsCurrentspInfo.spellID, oCharacter))
			{
				giAuraSpellToCast = gsCurrentspInfo.spellID;			
			}
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH:
			if (!SCGetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH))
			{
				SCHenchCheckPolymorph(oCharacter);
			}
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_DISPEL:
			SCHenchCheckDispel(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_INVISIBLE:
			if (gbCheckInvisbility)
			{
				SCHenchCheckInvisibility(oCharacter);
			}
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_CURECONDITION:
			SCHenchCheckCureCondition(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_SUMMON:
			if (!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)) && !SCGetHenchAssociateState(HENCH_ASC_DISABLE_SUMMONS))
			{
				SCHenchCheckSummons(oCharacter);
			}
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_ATTR_BUFF:
			SCHenchCheckAttrBuff(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_ENGR_PROT:
			SCHenchCheckEnergyProt(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK:
			SCHenchMeleeAttackSpell(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_ARCANE_ARCHER:
			{
				int itemType = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
				if ((itemType == BASE_ITEM_LONGBOW) || (itemType == BASE_ITEM_SHORTBOW))
				{
					//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCDispatchSpell 2 calling SCAISpellAttack", GetFirstPC() ); }
					SCAISpellAttack(SCGetCurrentSpellSaveType(), iTargetInformation, oCharacter);
				}
			}
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_SPELL_PROT:
			SCHenchCheckSpellProtections();
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_DRAGON_BREATH:
			{
				int combatRoundCount = GetLocalInt(oCharacter, "tkCombatRoundCount");
				int lastDragonBreath = GetLocalInt(oCharacter, "tkLastDragonBreath");
				if (lastDragonBreath == 0 || lastDragonBreath < combatRoundCount - 2)
				{
					// breath is unlimited
					gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_REGULAR | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
					gsCurrentspInfo.otherID = METAMAGIC_NONE;
					//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCDispatchSpell 3 calling SCAISpellAttack", GetFirstPC() ); }
					SCAISpellAttack(SCGetCurrentSpellSaveType(), iTargetInformation, oCharacter);
				}
			}
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_DETECT_INVIS:
			SCHenchCheckDetectInvisibility(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_DOMINATE:
			if (!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED)))
			{
				int lastDominate = GetLocalInt(oCharacter, "tkLastDominate");
				int combatRoundCount = GetLocalInt(oCharacter, "tkCombatRoundCount");
				if (lastDominate == 0 && lastDominate >= combatRoundCount - 7)
				{
					//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCDispatchSpell 4 calling SCAISpellAttack", GetFirstPC() ); }
					SCAISpellAttack(SCGetCurrentSpellSaveType(), iTargetInformation, oCharacter);
				}
			}
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_WEAPON_BUFF:
			SCHenchCheckWeaponBuff(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_BUFF_ANIMAL_COMP:
			SCHenchCheckAnimalCompanionBuff(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_PROT_EVIL:
			SCHenchCheckProtEvil(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_PROT_GOOD:
			SCHenchCheckProtGood(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_REGENERATE:
			SCHenchCheckRegeneration(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_GUST_OF_WIND:
			gsGustOfWind = gsCurrentspInfo;
	// TODO MotB disabled for now, check friendly AoEs SCAISpellAttack(SCGetCurrentSpellSaveType());
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_ELEMENTAL_SHIELD:
			SCHenchCheckElementalShield(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_TURN_UNDEAD:
			SCHenchCheckTurnUndead(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_MELEE_ATTACK_BUFF:
			SCHenchMeleeAttackBuff(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_RAISE_DEAD:
			SCHenchRaiseDead(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_CONCEALMENT:
			SCHenchConcealment(oCharacter);
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_ATTACK_SPECIAL:
			SCAISpellAttackSpecial();
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_HEAL_SPECIAL:
			SCHenchCheckHealSpecial();
			break;
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCDispatchSpell End", GetFirstPC() ); }
    DEBUGGING = iOldDebugging;
}


void SCHenchTalentSpellDispatch(talent tTalent, int nSpellID, int spellIDInfo, int nItemType, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 8) { CSLDebug(  "SCHenchTalentSpellDispatch Start", GetFirstPC() ); }
	if ((spellIDInfo == 0) || (spellIDInfo & HENCH_SPELL_INFO_MASTER_OR_IGNORE_FLAG))
	{
		return;
	}
	
	gsCurrentspInfo.spellID = nSpellID;
	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_TALENT;
	gsCurrentspInfo.tTalent = tTalent;
	gsCurrentspInfo.otherID = -1;
	gsCurrentspInfo.spellLevel = (spellIDInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	gsCurrentspInfo.spellInfo = spellIDInfo;
	
	//DEBUGGING// if (DEBUGGING >= 8) { CSLDebug(  "SCHenchTalentSpellDispatch Calling SCDispatchSpell nItemType", GetFirstPC() ); }
	SCDispatchSpell(nItemType, oCharacter );
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchTalentSpellDispatch End", GetFirstPC() ); }
}


void SCHenchFeatDispatch(int nFeatID, int nSpellID, int bUseCheatCast, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 8) { CSLDebug(  "SCHenchFeatDispatch Start", GetFirstPC() ); }
	int spellInformation = SCGetSpellInformation(nSpellID);
    if (spellInformation & HENCH_SPELL_INFO_MASTER_FLAG)
    {
		string sMasterSpellInfoStr = gsCurrentSpellInfoStr;
		int spellID;
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + "TargetInfo");
		if (!spellID)
		{
			return;
		}
		SCHenchFeatDispatch(nFeatID, spellID, TRUE, oCharacter);
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + "EffectTypes");
		if (!spellID)
		{
			return;
		}
		SCHenchFeatDispatch(nFeatID, spellID, TRUE, oCharacter);
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + "DamageInfo");
		if (!spellID)
		{
			return;
		}
		SCHenchFeatDispatch(nFeatID, spellID, TRUE, oCharacter);
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + "SaveType");
		if (!spellID)
		{
			return;
		}
		SCHenchFeatDispatch(nFeatID, spellID, TRUE, oCharacter);
		spellID = GetLocalInt(GetModule(), sMasterSpellInfoStr + "SaveDCType");
		if (!spellID)
		{
			return;
		}
		SCHenchFeatDispatch(nFeatID, spellID, TRUE, oCharacter);
		return;
    }
	
    if (bUseCheatCast)
    {
    	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
    }
	else
	{
    	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID;
	}
    gsCurrentspInfo.spellID = nSpellID;
    gsCurrentspInfo.otherID = nFeatID;
	gsCurrentspInfo.spellInfo = spellInformation;
    gsCurrentspInfo.spellLevel = (spellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	//DEBUGGING// if (DEBUGGING >= 8) { CSLDebug(  "SCHenchFeatDispatch Calling SCDispatchSpell HENCH_ITEM_TYPE_NONE", GetFirstPC() ); }
    SCDispatchSpell(HENCH_ITEM_TYPE_NONE, oCharacter);
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchFeatDispatch End", GetFirstPC() ); }
}


void SCHenchSpontaneousDispatch(int nSpellID, int bForceUnlimited, object oCharacter = OBJECT_SELF)
{
   	//DEBUGGING// if (DEBUGGING >= 8) { CSLDebug(  "SCHenchSpontaneousDispatch Start", GetFirstPC() ); }
   	
   	gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_REGULAR | HENCH_CASTING_INFO_CHEAT_CAST_FLAG | (giMySpellCasterLevel << HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT);
    gsCurrentspInfo.spellID = nSpellID;
    gsCurrentspInfo.otherID = METAMAGIC_NONE;
	int spellInformation = SCGetSpellInformation(nSpellID);
	if (bForceUnlimited)
	{
		spellInformation |= HENCH_SPELL_INFO_UNLIMITED_FLAG;
	}
	gsCurrentspInfo.spellInfo = spellInformation;
    gsCurrentspInfo.spellLevel = (spellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;

    SCDispatchSpell(HENCH_ITEM_TYPE_NONE, oCharacter);
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchSpontaneousDispatch End", GetFirstPC() ); }
}


int SCFindItemSpellTalentsByCategory(int nCategory, int maximumToFind, int talentExclude, int nItemType, object oCharacter = OBJECT_SELF)
{
    /*/DEBUGGING/*/ if (DEBUGGING >= 2) { CSLDebug(  "SCFindItemSpellTalentsByCategory Start", GetFirstPC() ); }
    
    int iIteration = 0;
    int spellsFound;
    int iTestCR = 20;
    talent tBest;
	
    while (iTestCR >= 0 && iIteration < 5)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        iIteration++;
        talent tBest = GetCreatureTalentBest(nCategory, iTestCR, oCharacter, talentExclude);
        if (!GetIsTalentValid(tBest))
        {
            if (spellsFound == 0)
            {
                return 0;
            }
            break;
        }
        int nType = GetTypeFromTalent(tBest);
        if (nType == TALENT_TYPE_SPELL)
        {
            int nNewSpellID = GetIdFromTalent(tBest);
			int iSpellInformation = SCGetSpellInformation(nNewSpellID);
            if (!SCHasItemTalentSpell(nNewSpellID))
            {
                SCAddItemTalentSpell(nNewSpellID);
                spellsFound ++;
					/*/DEBUGGING/*/ if (DEBUGGING >= 2) { CSLDebug(  "SCFindItemSpellTalentsByCategory call SCHenchTalentSpellDispatch iTestCR="+IntToString(iTestCR), GetFirstPC() ); }
                SCHenchTalentSpellDispatch(tBest, nNewSpellID, iSpellInformation, nItemType);
				
				if (giCheckSpontaneousFlags == talentExclude)
				{
					string cacheName = gsSpontaneousClassCache + IntToString(nNewSpellID);
					int cacheValue = GetLocalInt(GetModule(), cacheName);
					if (!cacheValue)
					{
						string columnInfo = Get2DAString("spells", gsSpontaneousClassColumn, nNewSpellID);
						int spontaneousSpellLevel = StringToInt(columnInfo);
						if ((spontaneousSpellLevel != 0) || (FindSubString("*", columnInfo) < 0))
						{
							cacheValue = (1 << spontaneousSpellLevel);
						}
						else
						{
							cacheValue = 0x80000000;
						}
						SetLocalInt(GetModule(), cacheName, cacheValue);
					}
					giCheckSpontaneousLevels |= cacheValue;				
				}
                if (spellsFound >= maximumToFind)
                {
                    return spellsFound;
                }
            }
			if (nItemType)
			{
				// you can only find one item with GetCreatureTalentBest
				break;
			}			
			int curCR = (iSpellInformation & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> 12; // HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT - 1 makes it two times spell level
			iTestCR = iTestCR < curCR ? iTestCR : curCR;
        }
		else
		{
			break;
		}
        iTestCR -= 2;
    }
	
    int nTry;

    while (nTry < 5)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        tBest = GetCreatureTalentRandom(nCategory, oCharacter, talentExclude);
        int nType = GetTypeFromTalent(tBest);
        if (nType == TALENT_TYPE_SPELL)
        {
            int nNewSpellID = GetIdFromTalent(tBest);
            int iSpellInformation = SCGetSpellInformation(nNewSpellID);


            if (!SCHasItemTalentSpell(nNewSpellID))
            {
                SCAddItemTalentSpell(nNewSpellID);
                spellsFound ++;
                SCHenchTalentSpellDispatch(tBest, nNewSpellID, iSpellInformation, nItemType);				
            }
        }

        if (spellsFound >= maximumToFind)
        {
            return spellsFound;
        }
        nTry ++;
    }
    /*/DEBUGGING/*/ if (DEBUGGING >= 2) { CSLDebug(  "SCFindItemSpellTalentsByCategory End", GetFirstPC() ); }
    return spellsFound;
}


int SCCheckSpontaneousCureOrInflictSpell(int nSpellID, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckSpontaneousCureOrInflictSpell Start", GetFirstPC() ); }
	if (!GetHasSpell(nSpellID, oCharacter))
	{
		return FALSE;
	}
	
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckSpontaneousCureOrInflictSpell and has spell", GetFirstPC() ); }
    int spellInfo = SCGetSpellInformation(nSpellID);	
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	
	if (giCheckSpontaneousLevels & (1 << spellLevel))
	{
		gsCurrentspInfo.spellInfo = spellInfo;	
		gsCurrentspInfo.spellLevel = spellLevel;
		gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT | HENCH_CASTING_INFO_CHEAT_CAST_FLAG |
			(giMySpellCasterLevel << HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT);
		gsCurrentspInfo.range = 4.0;
		gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
		gsCurrentspInfo.spellID = nSpellID;
		gsCurrentspInfo.otherID = METAMAGIC_NONE;
		//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckSpontaneousCureOrInflictSpell calling SCAISpellAttack", GetFirstPC() ); }
		SCAISpellAttack(SCGetCurrentSpellSaveType(), HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG, oCharacter);	
	}
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCCheckSpontaneousCureOrInflictSpell End", GetFirstPC() ); }
    return TRUE;
}


int SCCheckSpontaneousMassCureOrInflictSpell(int nSpellID, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckSpontaneousMassCureOrInflictSpell Start", GetFirstPC() ); }
	
	if (!GetHasSpell(nSpellID, oCharacter))
	{
		return FALSE;
	}
    int spellInfo = SCGetSpellInformation(nSpellID);	
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	
	if (giCheckSpontaneousLevels & (1 << spellLevel))
	{
		gsCurrentspInfo.spellInfo = spellInfo;	
		gsCurrentspInfo.spellLevel = spellLevel;
		gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT | HENCH_CASTING_INFO_CHEAT_CAST_FLAG | (giMySpellCasterLevel << HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT);
		gsCurrentspInfo.range = 8.0;
		gsCurrentspInfo.radius = RADIUS_SIZE_LARGE;
		gsCurrentspInfo.shape = SHAPE_SPHERE;
		gsCurrentspInfo.spellID = nSpellID;
		gsCurrentspInfo.otherID = METAMAGIC_NONE;
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCCheckSpontaneousMassCureOrInflictSpell calling SCAISpellAttack", GetFirstPC() ); }
		SCAISpellAttack(SCGetCurrentSpellSaveType(), HENCH_SPELL_TARGET_SHAPE_LOOP, oCharacter);
	}
	
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCCheckSpontaneousMassCureOrInflictSpell End", GetFirstPC() ); }
    return TRUE;
}




void SCInitializeSpellTalentCategory(int nCategory, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 4) { CSLDebug(  "SCInitializeSpellTalentCategory Start", GetFirstPC() ); }
	
	giItemTalentSpellCount = giItemTalentSpellStart;
	int spellCount = 10;
	if (gbUseSpells)
	{
		//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeSpellTalentCategory calling 1 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		spellCount -= SCFindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_SPELLS_ONLY, FALSE, oCharacter);
	}
	if (gbUseAbilities)
	{
		//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeSpellTalentCategory calling 2 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		spellCount -= SCFindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE, oCharacter);
	}
	if (gbUseItems)
	{
		//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeSpellTalentCategory calling 3 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
	}
	
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeSpellTalentCategory End", GetFirstPC() ); }
}


void SCInitializeSpellTalentCategoryNoItems(int nCategory, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 4) { CSLDebug(  "SCInitializeSpellTalentCategoryNoItems Start", GetFirstPC() ); }
	
	giItemTalentSpellCount = giItemTalentSpellStart;
	int spellCount = 10;
	if (gbUseSpells)
	{
		//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeSpellTalentCategoryNoItems calling 4 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		spellCount -= SCFindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_SPELLS_ONLY, FALSE, oCharacter);
	}
	if (gbUseAbilities)
	{
		//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeSpellTalentCategoryNoItems calling 5 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(nCategory, spellCount, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE, oCharacter);
	}
	
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeSpellTalentCategoryNoItems End", GetFirstPC() ); }
}




void SCInitializeEpicSpells( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 4) { CSLDebug(  "SCInitializeEpicSpells Start", GetFirstPC() ); }
	
	if ((GetHitDice(oCharacter) <= 20) || gbDisableHighLevelSpells || gbDisablingEffect)
	{
		return;
	}
    if (GetHasFeat(FEAT_EPIC_BLINDING_SPEED, oCharacter))
    {
        SCHenchFeatDispatch(FEAT_EPIC_BLINDING_SPEED, 647, FALSE, oCharacter);
    }
	// the DC get done wrong due to cheat casting appears to be fixed at +3 ability mod	
    if (GetHasFeat(FEAT_EPIC_SPELL_HELLBALL, oCharacter))
    {
        SCHenchFeatDispatch(FEAT_EPIC_SPELL_HELLBALL, 636, TRUE, oCharacter);
    }
	if (GetHasFeat(1971 /* FEAT_EPIC_LAST_STAND */, oCharacter) && GetIsObjectValid(GetFactionLeader(oCharacter)))
    {
        SCHenchFeatDispatch(1971, 1067, FALSE, oCharacter);
    }
    if (GetHasFeat(1991 /* FEAT_EPIC_SPELL_DAMNATION */, oCharacter))
    {
        SCHenchFeatDispatch(1991, 1076, FALSE, oCharacter);
    }
    if (GetHasFeat(1992 /* FEAT_EPIC_SPELL_ENTROPIC_HUSK */, oCharacter))
    {
        SCHenchFeatDispatch(1992, 1077, FALSE, oCharacter);
    }
    if (GetHasFeat(1993 /* FEAT_EPIC_SPELL_EPIC_GATE */, oCharacter))
    {
        SCHenchFeatDispatch(1993, 1078, FALSE, oCharacter);
    }
    if (GetHasFeat(1995 /* FEAT_EPIC_SPELL_VAMPIRIC_FEAST */, oCharacter))
    {
        SCHenchFeatDispatch(1995, 1080, FALSE, oCharacter);
    }
    
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeEpicSpells End", GetFirstPC() ); }
}



void SCInitializeSpellTalents( object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 4) { CSLDebug(  "SCInitializeSpellTalents Start", GetFirstPC() ); }
	
	int iCheckSpontaneousSpells;
	int iCheckSpontaneousLevels;
	
	if (!gbDisablingEffect)
    {
		if ((gbSpellInfoCastMask & HENCH_SPELL_INFO_HEAL_OR_CURE) &&
			(GetLevelByClass(CLASS_TYPE_CLERIC) > 0))
		{		
			giCheckSpontaneousFlags = HENCH_TALENT_USE_SPELLS_ONLY;
			gsSpontaneousClassColumn = "Cleric";
			gsSpontaneousClassCache = "HenchSpontCleric";
			iCheckSpontaneousSpells = (GetAlignmentGoodEvil(oCharacter) == ALIGNMENT_EVIL) ? HENCH_CHECK_SPONTANEOUS_HARM : HENCH_CHECK_SPONTANEOUS_HEAL;
		}
	}	

	if (gbUseAbilities)
	{	
		SCInitializeEpicSpells();
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 7 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_DRAGONS_BREATH, 3, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE, oCharacter);
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 8 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
        SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_PERSISTENT_AREA_OF_EFFECT, 3, HENCH_TALENT_USE_ABILITIES_ONLY, FALSE, oCharacter);
	}

	SCInitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_RANGED, oCharacter);	
	SCInitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_TOUCH, oCharacter);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
	{
		if (SCHasItemTalentSpell(SPELL_INFLICT_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x010;
		}
		if (SCHasItemTalentSpell(SPELL_INFLICT_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x008;
		}
		if (SCHasItemTalentSpell(SPELL_INFLICT_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x004;
		}
		if (SCHasItemTalentSpell(SPELL_INFLICT_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x002;
		}
	}
	SCInitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, oCharacter);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
	{
		if (SCHasItemTalentSpell(SPELL_MASS_INFLICT_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x100;
		}
		if (SCHasItemTalentSpell(SPELL_MASS_INFLICT_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x080;
		}
		if (SCHasItemTalentSpell(SPELL_MASS_INFLICT_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x040;
		}
		if (SCHasItemTalentSpell(SPELL_MASS_INFLICT_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x020;
		}
	}
	SCInitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, oCharacter);
	
	if (gbUseItems)
	{
		giItemTalentSpellCount = giItemTalentSpellStart;
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 9 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_RANGED, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
		giItemTalentSpellCount = giItemTalentSpellStart;
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 10 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_TOUCH, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
		giItemTalentSpellCount = giItemTalentSpellStart;
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 11 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_AREAEFFECT_DISCRIMINANT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
		giItemTalentSpellCount = giItemTalentSpellStart;
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 12 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_HARMFUL_AREAEFFECT_INDISCRIMINANT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
	}	
	// todo see if this fixes the errant summons - this did not fix the issue, something else was causing the random castings
	if ( !GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_SUMMON")	)
	{
		SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES, oCharacter);
	}
	if ( !GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL")	)
	{
		SCInitializeSpellTalentCategory(TALENT_CATEGORY_DISPEL, oCharacter);
	}
	SCInitializeSpellTalentCategory(TALENT_CATEGORY_SPELLBREACH, oCharacter);
		
    SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT, oCharacter);
    SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF, oCharacter);
	if (gbUseItems)
	{
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 13 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION, oCharacter);
	}
    SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE, oCharacter);
    SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_AREAEFFECT, oCharacter);
    SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SELF, oCharacter);
	if (gbUseItems)
	{
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 14 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION, oCharacter);
	}
    SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_SINGLE, oCharacter);
    SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT, oCharacter);
    SCInitializeSpellTalentCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE, oCharacter);
	if (gbUseItems)
	{
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 15 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 10, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION, oCharacter);
	}
		
    // 0 talent category is misc spells (***** category in spells.2da)
    SCInitializeSpellTalentCategory(0, oCharacter);
		
    SCInitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, oCharacter);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
	{
		if (SCHasItemTalentSpell(SPELL_CURE_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x010;
		}
		if (SCHasItemTalentSpell(SPELL_CURE_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x008;
		}
		if (SCHasItemTalentSpell(SPELL_CURE_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x004;
		}
		if (SCHasItemTalentSpell(SPELL_CURE_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x002;
		}
	}
	if (gbUseItems)
	{
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 16 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION, oCharacter);
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 17 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION, oCharacter);
	}
    SCInitializeSpellTalentCategoryNoItems(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, oCharacter);
	if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
	{
		if (SCHasItemTalentSpell(SPELL_MASS_CURE_CRITICAL_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x100;
		}
		if (SCHasItemTalentSpell(SPELL_MASS_CURE_SERIOUS_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x080;
		}
		if (SCHasItemTalentSpell(SPELL_MASS_CURE_MODERATE_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x040;
		}
		if (SCHasItemTalentSpell(SPELL_MASS_CURE_LIGHT_WOUNDS))
		{
			iCheckSpontaneousLevels |= 0x020;
		}
	}
	if (gbUseItems)
	{
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeSpellTalents calling 18 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
		SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, 3, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION, oCharacter);
	}
	
	SCInitializeSpellTalentCategory(TALENT_CATEGORY_CANTRIP, oCharacter);
	if (iCheckSpontaneousSpells)
	{
		if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
		{
			if (SCHasItemTalentSpell(SPELL_CURE_MINOR_WOUNDS))			
			{
				iCheckSpontaneousLevels |= 0x001;
			}
		}
		else if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
		{
			if (SCHasItemTalentSpell(SPELL_INFLICT_MINOR_WOUNDS))			
			{
				iCheckSpontaneousLevels |= 0x001;
			}
		}
		
		giCheckSpontaneousLevels &= ~iCheckSpontaneousLevels;

		if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HEAL)
		{		
			SCCheckSpontaneousCureOrInflictSpell(SPELL_CURE_CRITICAL_WOUNDS);
			SCCheckSpontaneousCureOrInflictSpell(SPELL_CURE_SERIOUS_WOUNDS);
			SCCheckSpontaneousCureOrInflictSpell(SPELL_CURE_MODERATE_WOUNDS);
			SCCheckSpontaneousCureOrInflictSpell(SPELL_CURE_LIGHT_WOUNDS);
			SCCheckSpontaneousCureOrInflictSpell(SPELL_CURE_MINOR_WOUNDS);
			
			SCCheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_CRITICAL_WOUNDS);
			SCCheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_SERIOUS_WOUNDS);
			SCCheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_MODERATE_WOUNDS);
			SCCheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_CURE_LIGHT_WOUNDS);
		}
		else if (iCheckSpontaneousSpells == HENCH_CHECK_SPONTANEOUS_HARM)
		{				
			SCCheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_CRITICAL_WOUNDS);
			SCCheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_SERIOUS_WOUNDS);
			SCCheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_MODERATE_WOUNDS);
			SCCheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_LIGHT_WOUNDS);
			SCCheckSpontaneousCureOrInflictSpell(SPELL_INFLICT_MINOR_WOUNDS);
			
			SCCheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_CRITICAL_WOUNDS);
			SCCheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_SERIOUS_WOUNDS);
			SCCheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_MODERATE_WOUNDS);
			SCCheckSpontaneousMassCureOrInflictSpell(SPELL_MASS_INFLICT_LIGHT_WOUNDS);
		}
	}
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCInitializeSpellTalents End", GetFirstPC() ); }
}
	

int SCHenchGetHasInspireBardSongSpellEffect( object oObject= OBJECT_SELF )
{
    if ( GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COURAGE, oObject ) ||
//       GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_COMPETENCE, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_DEFENSE, oObject ) ||
//       GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_REGENERATION, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_TOUGHNESS, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_SLOWING, oObject ) ||
         GetHasSpellEffect( SPELLABILITY_SONG_INSPIRE_JARRING, oObject ) ||
         GetHasSpellEffect( 1074, oObject )) // FEAT_EPIC_SONG_OF_REQUIEM
    {
        return ( TRUE );
    }

    return ( FALSE );
}


void SCHenchCheakFeatSpellPacked(int packedInfo, object oCharacter = OBJECT_SELF )
{
	int nFeat = packedInfo & HENCH_FEAT_SPELL_MASK_FEAT;
	if (GetHasFeat(nFeat, oCharacter))
	{
		int nSpell = (packedInfo & HENCH_FEAT_SPELL_MASK_SPELL) >> 16;	
		SCHenchFeatDispatch(nFeat, nSpell, packedInfo & HENCH_FEAT_SPELL_MASK_SPELL, oCharacter);	
	}
}


int SCHenchReserveGetHasSpellRegular(int nSpell, object oCharacter = OBJECT_SELF )
{
	int nCount = GetHasSpell(nSpell, oCharacter);
	if (!nCount)
	{
		return FALSE;
	}	
	if ((GetLevelByClass(CLASS_TYPE_BARD) > 3) || (GetLevelByClass(CLASS_TYPE_SORCERER) > 3) ||
		(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL) > 3))
	{
		if (nCount > 1)
		{
			return TRUE;
		}	
	}	
	// reserve the spell
	SCAddItemTalentSpell(nSpell);
	giItemTalentSpellStart++;
	return TRUE;
}


int SCHenchReserveGetHasSpellCure(int nSpell, object oCharacter = OBJECT_SELF)
{
	int nCount = GetHasSpell(nSpell, oCharacter);
	if (!nCount)
	{
		return FALSE;
	}	
	if ((GetLevelByClass(CLASS_TYPE_BARD) > 3) || (GetLevelByClass(CLASS_TYPE_CLERIC) > 3) ||
		(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL) > 3))
	{
		if (nCount > 1)
		{
			return TRUE;
		}	
	}	
	// reserve the spell
	SCAddItemTalentSpell(nSpell);
	giItemTalentSpellStart++;
	return TRUE;
}


int SCGetAcidReserveDamageDice(object oCharacter = OBJECT_SELF)
{
	if (SCHenchReserveGetHasSpellRegular(173,oCharacter))
		return 9;
	if (SCHenchReserveGetHasSpellRegular(71,oCharacter)) // Greater_Shadow_Conjuration
		return 7;	
	if (SCHenchReserveGetHasSpellRegular(0,oCharacter))
		return 6;	
	if (SCHenchReserveGetHasSpellRegular(873,oCharacter))
		return 5;	
	if (SCHenchReserveGetHasSpellRegular(1859,oCharacter) || SCHenchReserveGetHasSpellRegular(1205,oCharacter))
		return 4;		
	if ( SCHenchReserveGetHasSpellRegular(523,oCharacter) || SCHenchReserveGetHasSpellRegular(1753,oCharacter) || SCHenchReserveGetHasSpellRegular(1814,oCharacter) )  // 1753 Energized_Shield, 1814 Weapon_Energy
		return 3;		
	if ( SCHenchReserveGetHasSpellRegular(115,oCharacter) || SCHenchReserveGetHasSpellRegular(1747,oCharacter) ) // 1747 Lesser_Energized_Shield
		return 2;		
	return 0;
}

int SCGetSonicReserveDamageDice(object oCharacter = OBJECT_SELF)
{
	if ( SCHenchReserveGetHasSpellRegular(1038,oCharacter) || SCHenchReserveGetHasSpellRegular(1820,oCharacter) )
		return 8;
	if ( SCHenchReserveGetHasSpellRegular(1016,oCharacter) || SCHenchReserveGetHasSpellRegular(1813,oCharacter) || SCHenchReserveGetHasSpellRegular(2027,oCharacter) )
		return 5;
	if ( SCHenchReserveGetHasSpellRegular(1861,oCharacter) || SCHenchReserveGetHasSpellRegular(1037,oCharacter) || SCHenchReserveGetHasSpellRegular(1743,oCharacter) || SCHenchReserveGetHasSpellRegular(1173,oCharacter)  || SCHenchReserveGetHasSpellRegular(1209,oCharacter))
		return 4;
	if ( SCHenchReserveGetHasSpellRegular(1753,oCharacter) || SCHenchReserveGetHasSpellRegular(1829,oCharacter) )  // 1753 Energized_Shield
		return 3;
	return 0;
}

int SCGetFieryBurstReserveDamageDice(object oCharacter = OBJECT_SELF)
{
	if (SCHenchReserveGetHasSpellRegular(116,oCharacter) || SCHenchReserveGetHasSpellRegular(158,oCharacter) || SCHenchReserveGetHasSpellRegular(48,oCharacter) )
		return 9;
	if (SCHenchReserveGetHasSpellRegular(89,oCharacter) || SCHenchReserveGetHasSpellRegular(2025,oCharacter))
		return 8;
	if ( SCHenchReserveGetHasSpellRegular(39,oCharacter) || SCHenchReserveGetHasSpellRegular(57,oCharacter) )
		return 7;
	if ( SCHenchReserveGetHasSpellRegular(61,oCharacter) || SCHenchReserveGetHasSpellRegular(440,oCharacter) || SCHenchReserveGetHasSpellRegular(446,oCharacter) || SCHenchReserveGetHasSpellRegular(869,oCharacter) || SCHenchReserveGetHasSpellRegular(871,oCharacter) )
		return 5;
	if ( SCHenchReserveGetHasSpellRegular(47,oCharacter) || SCHenchReserveGetHasSpellRegular(191,oCharacter) || SCHenchReserveGetHasSpellRegular(1826,oCharacter) || SCHenchReserveGetHasSpellRegular(1208,oCharacter))
		return 4;
	if ( SCHenchReserveGetHasSpellRegular(58,oCharacter) || SCHenchReserveGetHasSpellRegular(59,oCharacter) || SCHenchReserveGetHasSpellRegular(1753,oCharacter) || SCHenchReserveGetHasSpellRegular(1759,oCharacter) || SCHenchReserveGetHasSpellRegular(1814,oCharacter) )
		return 3;
	if ( SCHenchReserveGetHasSpellRegular(518,oCharacter) || SCHenchReserveGetHasSpellRegular(542,oCharacter) || SCHenchReserveGetHasSpellRegular(851,oCharacter) || SCHenchReserveGetHasSpellRegular(1001,oCharacter) || SCHenchReserveGetHasSpellRegular(1055,oCharacter) || SCHenchReserveGetHasSpellRegular(1747,oCharacter) || SCHenchReserveGetHasSpellRegular(1858,oCharacter) )
		return 2;
	return 0;
}


int SCGetForceReserveDamageDice(object oCharacter = OBJECT_SELF)
{
	if (SCHenchReserveGetHasSpellRegular(463,oCharacter))
		return 9;
	if (SCHenchReserveGetHasSpellRegular(462,oCharacter))
		return 8;
	if ( SCHenchReserveGetHasSpellRegular(123,oCharacter) || SCHenchReserveGetHasSpellRegular(461,oCharacter) )
		return 7;
	if ( SCHenchReserveGetHasSpellRegular(448,oCharacter) || SCHenchReserveGetHasSpellRegular(460,oCharacter) )
		return 6;
	if (SCHenchReserveGetHasSpellRegular(459,oCharacter))
		return 5;
	if ( SCHenchReserveGetHasSpellRegular(1863,oCharacter) || SCHenchReserveGetHasSpellRegular(447,oCharacter) )
		return 4;
	return 0;
}

int SCGetElecReserveDamageDice(object oCharacter = OBJECT_SELF)
{
	if (SCHenchReserveGetHasSpellRegular(173,oCharacter))
		return 9;
	if (SCHenchReserveGetHasSpellRegular(14,oCharacter))
		return 6;
	if (SCHenchReserveGetHasSpellRegular(1015,oCharacter))
		return 5;
	if (SCHenchReserveGetHasSpellRegular(1827,oCharacter) || SCHenchReserveGetHasSpellRegular(1162,oCharacter)  || SCHenchReserveGetHasSpellRegular(1207,oCharacter))
		return 4;
	if ( SCHenchReserveGetHasSpellRegular(11,oCharacter) || SCHenchReserveGetHasSpellRegular(101,oCharacter) || SCHenchReserveGetHasSpellRegular(526,oCharacter) || SCHenchReserveGetHasSpellRegular(1753,oCharacter) || SCHenchReserveGetHasSpellRegular(1814,oCharacter) )
		return 3;
	return 0;
}

int SCGetNecroReserveLevel(object oCharacter = OBJECT_SELF)
{
	if ( SCHenchReserveGetHasSpellRegular(51,oCharacter) || SCHenchReserveGetHasSpellRegular(190,oCharacter) )
		return 9;
	if ( SCHenchReserveGetHasSpellRegular(29,oCharacter) || SCHenchReserveGetHasSpellRegular(367,oCharacter) || SCHenchReserveGetHasSpellRegular(898,oCharacter) || SCHenchReserveGetHasSpellRegular(1018,oCharacter) )
		return 8;
	if ( SCHenchReserveGetHasSpellRegular(28,oCharacter) || SCHenchReserveGetHasSpellRegular(56,oCharacter) || SCHenchReserveGetHasSpellRegular(366,oCharacter) || SCHenchReserveGetHasSpellRegular(895,oCharacter) || 
		SCHenchReserveGetHasSpellRegular(1032,oCharacter) || SCHenchReserveGetHasSpellRegular(1796,oCharacter) )
		return 7;
	if ( SCHenchReserveGetHasSpellRegular(18,oCharacter) || SCHenchReserveGetHasSpellRegular(30,oCharacter) || SCHenchReserveGetHasSpellRegular(77,oCharacter) || SCHenchReserveGetHasSpellRegular(528,oCharacter) || SCHenchReserveGetHasSpellRegular(892,oCharacter) )
		return 6;
	if ( SCHenchReserveGetHasSpellRegular(19,oCharacter) || SCHenchReserveGetHasSpellRegular(23,oCharacter) || SCHenchReserveGetHasSpellRegular(164,oCharacter) || SCHenchReserveGetHasSpellRegular(1017,oCharacter) )
		return 5;
	if ( SCHenchReserveGetHasSpellRegular(38,oCharacter) || SCHenchReserveGetHasSpellRegular(52,oCharacter) || SCHenchReserveGetHasSpellRegular(435,oCharacter) || SCHenchReserveGetHasSpellRegular(1773,oCharacter) )
		return 4;
	if ( SCHenchReserveGetHasSpellRegular(2,oCharacter) || SCHenchReserveGetHasSpellRegular(27,oCharacter) || SCHenchReserveGetHasSpellRegular(54,oCharacter) || SCHenchReserveGetHasSpellRegular(129,oCharacter) || SCHenchReserveGetHasSpellRegular(188,oCharacter) || 
		SCHenchReserveGetHasSpellRegular(434,oCharacter) || SCHenchReserveGetHasSpellRegular(513,oCharacter) || SCHenchReserveGetHasSpellRegular(1036,oCharacter) )
		return 3;
	return 0;
}

int SCGetColdReserveLevel(object oCharacter = OBJECT_SELF)
{
	if ( SCHenchReserveGetHasSpellRegular(158,oCharacter) || SCHenchReserveGetHasSpellRegular(1045))
		return 9;
	if (SCHenchReserveGetHasSpellRegular(886,oCharacter))
		return 8;
	if (SCHenchReserveGetHasSpellRegular(25,oCharacter))
		return 5;
	if ( SCHenchReserveGetHasSpellRegular(47,oCharacter) || SCHenchReserveGetHasSpellRegular(368,oCharacter) || SCHenchReserveGetHasSpellRegular(1043,oCharacter) || SCHenchReserveGetHasSpellRegular(1825,oCharacter) || SCHenchReserveGetHasSpellRegular(1206,oCharacter) )
		return 4;
	if ( SCHenchReserveGetHasSpellRegular(1031,oCharacter) || SCHenchReserveGetHasSpellRegular(1753,oCharacter) || SCHenchReserveGetHasSpellRegular(1814,oCharacter) )
		return 3;
	if ( SCHenchReserveGetHasSpellRegular(1042,oCharacter) || SCHenchReserveGetHasSpellRegular(1747,oCharacter) || SCHenchReserveGetHasSpellRegular(2028,oCharacter))
		return 2;
	return 0;
}

int SCGetHealingReserveLevel(object oCharacter = OBJECT_SELF)
{
	if ( SCHenchReserveGetHasSpellCure(897,oCharacter) || SCHenchReserveGetHasSpellRegular(114,oCharacter) )
		return 8;
	if ( SCHenchReserveGetHasSpellCure(894,oCharacter) || SCHenchReserveGetHasSpellRegular(374,oCharacter) || SCHenchReserveGetHasSpellRegular(70,oCharacter) || SCHenchReserveGetHasSpellRegular(153,oCharacter) )
		return 7;
	if ( SCHenchReserveGetHasSpellCure(891,oCharacter) || SCHenchReserveGetHasSpellRegular(79,oCharacter) || SCHenchReserveGetHasSpellRegular(1023,oCharacter) )
		return 6;
	if ( SCHenchReserveGetHasSpellCure(80,oCharacter) || SCHenchReserveGetHasSpellRegular(1030,oCharacter) || SCHenchReserveGetHasSpellRegular(142,oCharacter) || SCHenchReserveGetHasSpellRegular(1004,oCharacter) )
		return 5;
	if ( SCHenchReserveGetHasSpellCure(31,oCharacter) || SCHenchReserveGetHasSpellRegular(152,oCharacter) )
		return 4;
	if ( SCHenchReserveGetHasSpellCure(35,oCharacter) || SCHenchReserveGetHasSpellRegular(126,oCharacter) || SCHenchReserveGetHasSpellRegular(145,oCharacter) || SCHenchReserveGetHasSpellRegular(147,oCharacter) || 
		SCHenchReserveGetHasSpellRegular(1020,oCharacter) || SCHenchReserveGetHasSpellRegular(1022,oCharacter) )
		return 3;
	if ( SCHenchReserveGetHasSpellCure(34,oCharacter) || SCHenchReserveGetHasSpellRegular(149,oCharacter) || SCHenchReserveGetHasSpellRegular(97,oCharacter) || SCHenchReserveGetHasSpellRegular(1169,oCharacter) )
		return 2;
	return 0;
}

int SCGetWarReserveLevel(object oCharacter = OBJECT_SELF)
{
	if (SCHenchReserveGetHasSpellRegular(131,oCharacter)) //Level 9
		return 9;
	if (SCHenchReserveGetHasSpellRegular(132,oCharacter)) //Level 8
		return 8;
	if (SCHenchReserveGetHasSpellRegular(1011,oCharacter)) //Level 7
		return 7;
	if (SCHenchReserveGetHasSpellRegular(5,oCharacter)) //Level 6
		return 6;
	if (SCHenchReserveGetHasSpellRegular(61,oCharacter)) //Level 5
		return 5;
	if (SCHenchReserveGetHasSpellRegular(42,oCharacter)) //Level 4
		return 4;
	return 0;
}

int SCGetPolyReserveLevel(object oCharacter = OBJECT_SELF)
{
	if (SCHenchReserveGetHasSpellRegular(161,oCharacter)) //Level 9
		return 9;
	if (SCHenchReserveGetHasSpellRegular(184,oCharacter)) //Level 6
		return 6;
	if (SCHenchReserveGetHasSpellRegular(130,oCharacter)) //Level 4
		return 4;
	if (SCHenchReserveGetHasSpellRegular(305,oCharacter))
		return 9;
	return 0;
}


void SCHenchReserveFeatDispatch(int nFeatID, int nSpellID, int nSpellLevel, int bCheatCast = FALSE, object oCharacter = OBJECT_SELF)
{
	if (nSpellLevel <= 0)
	{	
		return;
	}	
	if (bCheatCast)
	{
		gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID | HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
	}
	else
	{
		gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_FEATID;
	}
	gsCurrentspInfo.spellID = nSpellID;
	gsCurrentspInfo.otherID = nFeatID;
	gsCurrentspInfo.spellInfo = SCGetSpellInformation(nSpellID);
	gsCurrentspInfo.spellLevel = nSpellLevel;
	
	int saveCasterLevel = giMySpellCasterLevel;
	// leave DC as primary ability class
	//giMySpellCasterDC = 10 + GetAbilityModifier(iAbility);
	// change caster level to damage dice (proper number of hit dice)
	giMySpellCasterLevel = nSpellLevel;
	SCDispatchSpell(HENCH_ITEM_TYPE_NONE, oCharacter );
	giMySpellCasterLevel = saveCasterLevel;
}


void SCHenchCheckReserveFeats( object oCharacter = OBJECT_SELF )
{
    if (GetHasFeat(3092 /* FEAT_RESERVE_ACIDIC_SPLATTER */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3092, 1864, SCGetAcidReserveDamageDice(oCharacter), FALSE, oCharacter);
    }
    if (GetHasFeat(3094 /* FEAT_RESERVE_FIERY_BURST */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3094, 1866, SCGetFieryBurstReserveDamageDice(oCharacter), FALSE, oCharacter);
    }
    if (GetHasFeat(3096 /* FEAT_RESERVE_INVISIBLE_NEEDLE */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3096, 1868, SCGetForceReserveDamageDice(oCharacter), FALSE, oCharacter);
    }
    if (GetHasFeat(3097 /* FEAT_RESERVE_MINOR_SHAPESHIFT */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3097, 1920, SCGetPolyReserveLevel(oCharacter), TRUE, oCharacter);
    }
    if (GetHasFeat(3098 /* FEAT_RESERVE_STORM_BOLT */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3098, 1870, SCGetElecReserveDamageDice(oCharacter), TRUE, oCharacter);
    }
    if (GetHasFeat(3099 /* FEAT_RESERVE_SICKENING_GRASP */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3099, 1871, SCGetNecroReserveLevel(oCharacter), FALSE, oCharacter);
    }
    if (GetHasFeat(3101 /* FEAT_RESERVE_WINTERS_BLAST */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3101, 1873, SCGetColdReserveLevel(oCharacter), TRUE, oCharacter);
    }
    if (GetHasFeat(3102 /* FEAT_RESERVE_HOLY_WARRIOR */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3102, 1874, SCGetWarReserveLevel(oCharacter), FALSE, oCharacter);
    }
    if (GetHasFeat(3104 /* FEAT_RESERVE_TOUCH_OF_HEALING */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3104, 1876,  SCGetHealingReserveLevel(oCharacter), FALSE, oCharacter);
    }
    if (GetHasFeat(3093 /* FEAT_RESERVE_CLAP_OF_THUNDER */, oCharacter))
    {
        SCHenchReserveFeatDispatch(3093, 1865, SCGetSonicReserveDamageDice(oCharacter), FALSE, oCharacter);
    }
}

int SCGetBardicClassLevel(object oCharacter = OBJECT_SELF )
{
	return GetLevelByClass(CLASS_TYPE_BARD, oCharacter) + GetLevelByClass(CLASS_KAED_STORMSINGER, oCharacter) + GetLevelByClass(CLASS_KAED_CANAITH_LYRIST, oCharacter);
}


void SCInitializeFeats( object oCharacter = OBJECT_SELF )
{
	SCCacheStats( oCharacter );
	HkCacheAIProperties( oCharacter );
	
	// check for general feats
    if (GetHasFeat(FEAT_TURN_UNDEAD, oCharacter))
    {
        SCHenchFeatDispatch(FEAT_TURN_UNDEAD, SPELLABILITY_TURN_UNDEAD, FALSE, oCharacter);

        int abilityModifier = GetAbilityModifier(ABILITY_CHARISMA);
        // in order to prevent constant calling if Charisma low, do random check
        if ((abilityModifier > 0) && ((abilityModifier * abilityModifier) >= Random(100)))
        {
            if (GetHasFeat(FEAT_DIVINE_MIGHT, oCharacter))
            {
                SCHenchFeatDispatch(FEAT_DIVINE_MIGHT, SPELL_DIVINE_MIGHT, FALSE, oCharacter);
            }
            if (GetHasFeat(FEAT_DIVINE_SHIELD, oCharacter) && (SCGetPercentageHPLoss(oCharacter) < 50))
            {
                SCHenchFeatDispatch(FEAT_DIVINE_SHIELD, SPELL_DIVINE_SHIELD, FALSE, oCharacter);
            }
			if (GetHasFeat(FEAT_DIVINE_VENGEANCE, oCharacter))
			{
				SCHenchFeatDispatch(FEAT_DIVINE_VENGEANCE, SPELL_DIVINE_VENGEANCE, FALSE, oCharacter);
			}			
        }
		if (GetHasFeat(2255 /* FEAT_SACRED_PURIFICATION */, oCharacter))
		{
			SCHenchFeatDispatch(2255, 1215, FALSE, oCharacter);
		}
    }
	
	// check for class feats
	int iPosition = 1;
    int nClassLevel = GetLevelByPosition(iPosition);	
	while ((nClassLevel > 0) && (iPosition <= 4))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		//int nClass = SCHenchGetClassByPosition(iPosition, nClassLevel);
		int nClass = GetClassByPosition(iPosition);
		int nClassFlags = SCHenchGetClassFlags(nClass);
		//int iSpellPower = GetLocalInt(oCharacter, "SC_iSpellPower"+IntToString( iClassRow ) );
		
		if ((nClassFlags & HENCH_CLASS_FEAT_SPELLS) && (!gbDisablingEffect || (nClassFlags & HENCH_CLASS_IGNORE_SILENCE)))
		{			
			// set up casting level, DC			
			//int iAbility = ((nClassFlags & HENCH_CLASS_ABILITY_MODIFIER_MASK) >> HENCH_CLASS_ABILITY_MODIFIER_SHIFT) + ABILITY_CONSTITUTION;
			giMySpellCasterDC = HkGetSpellSaveDC( oCharacter, OBJECT_INVALID, -1, nClass );
			// giMySpellCasterDC = 10 + GetAbilityModifier(iAbility);
			giMySpellCasterLevel = HkGetSpellPower( oCharacter, 60,  nClass ); // nClassLevel;
			//giMySpellCasterSpellPenetration = giMySpellCasterLevel;
			giMySpellCasterSpellPenetration = HkGetSpellPenetration( oCharacter, nClass );
			
			string currentClassInfo = "HENCH_CLASS_ID_INFO" + IntToString(nClass);
			int featSpellIndex = 1;
			while (TRUE)
			{
				//DEBUGGING// igDebugLoopCounter += 1;
				int featSpellInfo = GetLocalInt(GetModule(), currentClassInfo + "FS" + IntToString(featSpellIndex));				
				if (!featSpellInfo)
				{
					break;
				}
				SCHenchCheakFeatSpellPacked(featSpellInfo);
				featSpellIndex ++;
			}						
			if (nClass == CLASS_TYPE_SPIRIT_SHAMAN)
			{		
				if (GetIsSpirit(GetLocalObject(oCharacter, "HenchLineOfSight")))
				{
					if (GetHasFeat(FEAT_CHASTISE_SPIRITS, oCharacter))
					{
						SCHenchFeatDispatch(FEAT_CHASTISE_SPIRITS, 1094, FALSE, oCharacter);
						// TODO Weaken Spirits?
					}
					if (GetHasFeat(2021, oCharacter) && GetIsObjectValid(GetFactionLeader(oCharacter)))
					{
						SCHenchFeatDispatch(2021, SPELLABILITY_WARDING_OF_THE_SPIRITS, FALSE, oCharacter);
					}
				}
			}
		}				
		nClassLevel = GetLevelByPosition(++iPosition);
	}
	
    if (GetHasFeat(FEAT_WILD_SHAPE, oCharacter) && !(gbDisablingEffect & HENCH_DISABLE_EFFECT_SILENCE))
    {
            // note: elephant's hide and oaken resilience are free actions
        if (GetHasFeat(FEAT_ELEPHANTS_HIDE, oCharacter) && !GetHasSpell(SPELL_TORTOISE_SHELL, oCharacter)  && (gbSpellInfoCastMask & HENCH_SPELL_INFO_MEDIUM_DUR_BUFF))
        {
            int posEffects = SCGetCreaturePosEffects(oCharacter);
            if (!(posEffects & HENCH_EFFECT_TYPE_POLYMORPH))
            {
                if (!(posEffects & HENCH_EFFECT_TYPE_AC_INCREASE) ||
                    (SCGetCreatureACBonus(oCharacter, AC_NATURAL_BONUS) <= 5))
                {
                    ActionUseFeat(FEAT_ELEPHANTS_HIDE, oCharacter);
                }
            }
        }
        if (GetHasFeat(FEAT_OAKEN_RESILIENCE, oCharacter) && !(GetHasFeat(FEAT_ELEMENTAL_SHAPE, oCharacter) ||   GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON, oCharacter) || GetHasFeat(2111, oCharacter) || SCGetHenchAssociateState(HENCH_ASC_DISABLE_POLYMORPH)) && (gbSpellInfoCastMask & HENCH_SPELL_INFO_MEDIUM_DUR_BUFF))
        {
            if (!GetIsImmune(oCharacter, IMMUNITY_TYPE_CRITICAL_HIT))
            {
                ActionUseFeat(FEAT_OAKEN_RESILIENCE, oCharacter);
            }
        }
        SCHenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_WILD_SHAPE_BROWN_BEAR, TRUE, oCharacter);

        if (GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON, oCharacter))
        {
            SCHenchFeatDispatch(FEAT_WILD_SHAPE, 707, TRUE, oCharacter);
            SCHenchFeatDispatch(FEAT_WILD_SHAPE, 708, TRUE, oCharacter);
            SCHenchFeatDispatch(FEAT_WILD_SHAPE, 709, TRUE, oCharacter);
        }
        if (GetHasFeat(2001, oCharacter))
        {
            SCHenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_WINTER_WOLF, TRUE, oCharacter);
        }
        if (GetHasFeat(2111, oCharacter))
        {
            SCHenchFeatDispatch(FEAT_WILD_SHAPE, SPELLABILITY_PLANT_WILD_SHAPE_TREANT, TRUE, oCharacter);
        }
    }
	if ((GetLevelByClass(CLASS_TYPE_BARD) > 0) && !(gbDisablingEffect & HENCH_DISABLE_EFFECT_SILENCE))
	{		
		//giMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);
		//giMySpellCasterLevel = SCGetBardicClassLevel(oCharacter);
    	//giMySpellCasterSpellPenetration = giMySpellCasterLevel;
    	
    	giMySpellCasterDC = HkGetSpellSaveDC( oCharacter, OBJECT_INVALID, -1, CLASS_TYPE_BARD );
		giMySpellCasterLevel = HkGetSpellPower( oCharacter, 60,  CLASS_TYPE_BARD );
    	giMySpellCasterSpellPenetration = HkGetSpellPenetration( oCharacter, CLASS_TYPE_BARD );
    	
		if (GetHasFeat(FEAT_BARD_SONGS, oCharacter))
		{
			if (!SCGetHasNormalBardSongSpellEffect())
			{
				if (GetHasFeat(FEAT_BARDSONG_COUNTERSONG, oCharacter))
				{
					SCHenchFeatDispatch(FEAT_BARDSONG_COUNTERSONG, SPELLABILITY_SONG_COUNTERSONG, FALSE, oCharacter);
				}
/*				if (GetHasFeat(FEAT_BARDSONG_FASCINATE)) effect has a problem with the AI
				{
					SC HenchFeatDispatch(FEAT_BARDSONG_FASCINATE, SPELLABILITY_SONG_FASCINATE, FALSE);
				} */
				if (GetHasFeat(FEAT_BARDSONG_HAVEN_SONG, oCharacter))
				{
					SCHenchFeatDispatch(FEAT_BARDSONG_HAVEN_SONG, SPELLABILITY_SONG_HAVEN_SONG, FALSE, oCharacter);
				}
				if (GetHasFeat(FEAT_BARDSONG_INSPIRE_HEROICS, oCharacter))
				{
					if (GetHasFeat(FEAT_EPIC_CHORUS_OF_HEROISM, oCharacter, TRUE))
					{
						if (GetIsObjectValid(GetFactionLeader(oCharacter)))
						{						
							SCHenchFeatDispatch(FEAT_EPIC_CHORUS_OF_HEROISM, 1158, FALSE, oCharacter);
						}
					}
					else
					{
						SCHenchFeatDispatch(FEAT_BARDSONG_INSPIRE_HEROICS, SPELLABILITY_SONG_INSPIRE_HEROICS, FALSE, oCharacter);
					}
				}
				if (GetHasFeat(FEAT_BARDSONG_INSPIRE_LEGION, oCharacter) && GetIsObjectValid(GetFactionLeader(oCharacter)))
				{
					SCHenchFeatDispatch(FEAT_BARDSONG_INSPIRE_LEGION, SPELLABILITY_SONG_INSPIRE_LEGION, FALSE, oCharacter);
				}
				// Not done FEAT_BARDSONG_IRONSKIN_CHANT (faction only), FEAT_BARDSONG_SONG_OF_FREEDOM, Song_Cloud_Mind
			}
			if (GetHasFeat(FEAT_CURSE_SONG, oCharacter))
			{
				object oTest = GetLocalObject(oCharacter, "HenchLineOfSight");
				int bUseCurseSong;
				while (GetIsObjectValid(oTest))
				{
					//DEBUGGING// igDebugLoopCounter += 1;
					if (GetHasSpellEffect(SPELLABILITY_EPIC_CURSE_SONG, oTest))
					{
						bUseCurseSong = FALSE;
						break;
					}					
					bUseCurseSong = TRUE;
					oTest = GetLocalObject(oTest, "HenchLineOfSight");					
				}
				if (bUseCurseSong)
				{
					SCHenchFeatDispatch(FEAT_CURSE_SONG, SPELLABILITY_EPIC_CURSE_SONG, FALSE, oCharacter);
				}
			}
			if (GetHasFeat(1988, oCharacter) && !GetHasSpellEffect(1074, oCharacter)) // FEAT_EPIC_SONG_OF_REQUIEM
			{
				SCHenchFeatDispatch(1988, 1074, FALSE, oCharacter);
			}
		}
		if (!SCHenchGetHasInspireBardSongSpellEffect())
		{
			if (GetHasFeat(FEAT_BARDSONG_INSPIRE_COURAGE, oCharacter))
			{
				SCHenchFeatDispatch(FEAT_BARDSONG_INSPIRE_COURAGE, SPELLABILITY_SONG_INSPIRE_COURAGE, FALSE, oCharacter);
			}
			if (GetHasFeat(FEAT_BARDSONG_INSPIRE_DEFENSE, oCharacter))
			{
				SCHenchFeatDispatch(FEAT_BARDSONG_INSPIRE_DEFENSE, SPELLABILITY_SONG_INSPIRE_DEFENSE, FALSE, oCharacter);
			}
			/* if (GetHasFeat(FEAT_BARDSONG_INSPIRE_JARRING, oCharacter))
			{
				SC HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_JARRING, SPELLABILITY_SONG_INSPIRE_JARRING, FALSE);
			} */
			if (GetHasFeat(FEAT_BARDSONG_INSPIRE_REGENERATION, oCharacter))
			{
				SCHenchFeatDispatch(FEAT_BARDSONG_INSPIRE_REGENERATION, SPELLABILITY_SONG_INSPIRE_REGENERATION, FALSE, oCharacter);
			}
			/* if (GetHasFeat(FEAT_BARDSONG_INSPIRE_SLOWING, oCharacter))
			{
				SC HenchFeatDispatch(FEAT_BARDSONG_INSPIRE_SLOWING, SPELLABILITY_SONG_INSPIRE_SLOWING, FALSE);
			} */
			if (GetHasFeat(FEAT_BARDSONG_INSPIRE_TOUGHNESS, oCharacter))
			{
				SCHenchFeatDispatch(FEAT_BARDSONG_INSPIRE_TOUGHNESS, SPELLABILITY_SONG_INSPIRE_TOUGHNESS, FALSE, oCharacter);
			}
			// Not done FEAT_BARDSONG_INSPIRE_COMPETENCE
		}
	}
		
	// check for racial sub type feats
	int nRacialSubType = GetSubRace(oCharacter);
	string currentRacialInfo = "HENCH_RACIAL_ID_INFO" + IntToString(nRacialSubType);	
	int nRacialFlags = GetLocalInt(GetModule(), currentRacialInfo);
	if ((nRacialFlags & HENCH_SPELL_INFO_VERSION_MASK) != HENCH_SPELL_INFO_VERSION)
	{
        nRacialFlags = StringToInt(Get2DAString("henchracial", "Flags", nRacialSubType));
		if (nRacialFlags == 0)
		{
            nRacialFlags = HENCH_SPELL_INFO_VERSION;
		}
		else
		{
			if (nRacialFlags & HENCH_RACIAL_FEAT_SPELLS)
			{
				int featSpellIndex = 1;
				while (TRUE)
				{
					//DEBUGGING// igDebugLoopCounter += 1;
					int featSpellInfo = StringToInt(Get2DAString("henchracial", "FeatSpell" + IntToString(featSpellIndex), nRacialSubType));					
					if (!featSpellInfo)
					{
						break;
					}
					SetLocalInt(GetModule(), currentRacialInfo + "FS" + IntToString(featSpellIndex), featSpellInfo);				
					featSpellIndex ++;
				}
				DeleteLocalInt(GetModule(), currentRacialInfo + "FS" + IntToString(featSpellIndex));
			}
		}
		SetLocalInt(GetModule(), currentRacialInfo, nRacialFlags);	
	}

	if ((nRacialFlags & HENCH_RACIAL_FEAT_SPELLS) && !gbDisablingEffect)
	{	
		giMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);
		giMySpellCasterLevel = GetTotalLevels(oCharacter, TRUE);
    	giMySpellCasterSpellPenetration = giMySpellCasterLevel;
	
		int featSpellIndex = 1;
		while (TRUE)
		{
			//DEBUGGING// igDebugLoopCounter += 1;
			int featSpellInfo = GetLocalInt(GetModule(), currentRacialInfo + "FS" + IntToString(featSpellIndex));				
			if (!featSpellInfo)
			{
				break;
			}
			SCHenchCheakFeatSpellPacked(featSpellInfo);
			featSpellIndex ++;
		}
	}
    if (GetHasFeat(FEAT_FEY_HERITAGE, oCharacter) && !gbDisablingEffect)
    {
		giMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);
		giMySpellCasterLevel = GetTotalLevels(oCharacter, TRUE);
    	giMySpellCasterSpellPenetration = giMySpellCasterLevel;
        if (GetHasFeat(FEAT_FEY_LEGACY, oCharacter))
        {
            SCHenchFeatDispatch(FEAT_FEY_LEGACY, 26, TRUE, oCharacter);
        }
        if (GetHasFeat(FEAT_FEY_PRESENCE, oCharacter))
        {
            SCHenchFeatDispatch(FEAT_FEY_PRESENCE, 855, TRUE, oCharacter);
        }
    }
    else if (GetHasFeat(FEAT_FIENDISH_HERITAGE, oCharacter) && !gbDisablingEffect)
    {
		giMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);
		giMySpellCasterLevel = GetTotalLevels(oCharacter, TRUE);
    	giMySpellCasterSpellPenetration = giMySpellCasterLevel;
        if (GetHasFeat(FEAT_FIENDISH_LEGACY, oCharacter))
        {
            SCHenchFeatDispatch(FEAT_FIENDISH_LEGACY, 179, TRUE, oCharacter);
        }
        if (GetHasFeat(FEAT_FIENDISH_PRESENCE, oCharacter))
        {
            SCHenchFeatDispatch(FEAT_FIENDISH_PRESENCE, 54, TRUE, oCharacter);
        }
    }
	int nAtWillSpell = GetLocalInt(oCharacter, "AtWillSpell1");
	if (nAtWillSpell)
	{
		giMySpellCasterDC = 10 + GetAbilityModifier(ABILITY_CHARISMA);		
		giMySpellCasterLevel = GetLocalInt(oCharacter, "HenchAWCasterLevel");
		if (giMySpellCasterLevel <= 0)
		{
			giMySpellCasterLevel = 10;
		}		
    	giMySpellCasterSpellPenetration = giMySpellCasterLevel;	
		int nAtWillIndex = 1;	
		do		
		{		
			//DEBUGGING// igDebugLoopCounter += 1;
			SCHenchSpontaneousDispatch(nAtWillSpell, TRUE);		
			nAtWillIndex ++;
			nAtWillSpell = GetLocalInt(oCharacter, "AtWillSpell" + IntToString(nAtWillIndex));		
		} 	while (nAtWillSpell);	
	}
}


void SCInitializeWarlockAttackSpell(int nSpellID, int nSpellLevel, object oCharacter = OBJECT_SELF )
{
    int originalSpellInformation = SCGetSpellInformation(nSpellID);
    int saveType = SCGetCurrentSpellSaveType();


//      spInfo.tTalent = tTalent;
    gsCurrentspInfo.spellInfo = originalSpellInformation;
    gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_SPELL_WARLOCK;
    gsCurrentspInfo.spellID = nSpellID;

    if (GetHasSpell(SPELL_I_ELDRITCH_SPEAR, oCharacter))
    {
        gsCurrentspInfo.spellLevel = 1;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_SPEAR;
        gsCurrentspInfo.range = 40.0;
        gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
        //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeWarlockAttackSpell calling SCAISpellAttack", GetFirstPC() ); }
        SCAISpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG, HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG, oCharacter);
    }
    if (GetHasSpell(SPELL_I_HIDEOUS_BLOW, oCharacter))
    {
        if ((GetDistanceToObject(goClosestSeenOrHeardEnemy) < 5.0) &&
            (SCGetInitWeaponStatus() & HENCH_AI_HAS_MELEE))
        {
            gsCurrentspInfo.spellLevel = 1;
            gsCurrentspInfo.otherID = SPELL_I_HIDEOUS_BLOW;
            gsCurrentspInfo.range = 5.0;
            gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
            //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeWarlockAttackSpell 2 calling SCAISpellAttack", GetFirstPC() ); }
            SCAISpellAttack(saveType, 0, oCharacter);
        }
    }
    if (GetHasSpell(SPELL_I_ELDRITCH_CONE, oCharacter))
    {
        gsCurrentspInfo.spellLevel = 3;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_CONE;
        gsCurrentspInfo.shape = SHAPE_SPELLCONE;
        gsCurrentspInfo.radius = 11.0;
        gsCurrentspInfo.range = 8.0;
		// shift over save info to second position		
		int originalSave1Info = (saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK) * HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT;	
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeWarlockAttackSpell 3 calling SCAISpellAttack", GetFirstPC() ); }	
        SCAISpellAttack((saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK_REMOVE) | HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX |
			HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION | HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG |
			HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG | originalSave1Info, HENCH_SPELL_TARGET_SHAPE_LOOP, oCharacter);
    }
    gsCurrentspInfo.range = 20.0;       // the rest of the spells have range 20
    if (GetHasSpell(SPELL_I_ELDRITCH_CHAIN, oCharacter))
    {
        gsCurrentspInfo.spellLevel = 2;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_CHAIN;
        gsCurrentspInfo.shape = SHAPE_SPHERE;
        gsCurrentspInfo.radius = RADIUS_SIZE_COLOSSAL;
        //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeWarlockAttackSpell 4 calling SCAISpellAttack", GetFirstPC() ); }
        SCAISpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG | HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG, HENCH_SPELL_TARGET_SHAPE_LOOP | HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG | HENCH_SPELL_TARGET_SECONDARY_TARGETS | HENCH_SPELL_TARGET_CHECK_COUNT | HENCH_SPELL_TARGET_SECONDARY_HALF_DAM, oCharacter);
    }
    if (GetHasSpell(SPELL_I_ELDRITCH_DOOM, oCharacter))
    {
        gsCurrentspInfo.spellLevel = 4;
        gsCurrentspInfo.otherID = SPELL_I_ELDRITCH_DOOM;
        gsCurrentspInfo.shape = SHAPE_SPHERE;
        gsCurrentspInfo.radius = RADIUS_SIZE_HUGE;
		// shift over save info to second position		
		int originalSave1Info = (saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK) * HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT;
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeWarlockAttackSpell 5 calling SCAISpellAttack", GetFirstPC() ); }		
        SCAISpellAttack((saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_MASK_REMOVE) | HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX |
			HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION | HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG |
			originalSave1Info, HENCH_SPELL_TARGET_SHAPE_LOOP, oCharacter);
    }
    gsCurrentspInfo.spellLevel = nSpellLevel;
    gsCurrentspInfo.otherID = -1;
    gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
	if ((nSpellID == SPELLABILITY_I_ELDRITCH_BLAST) && (giWarlockDamageDice > 9))
	{
		// for some reason raw eldritch blast ingnores spell resistance at the 10th dice
		saveType &= ~HENCH_SPELL_SAVE_TYPE_SR_FLAG;
	}
	//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeWarlockAttackSpell 6 calling SCAISpellAttack", GetFirstPC() ); }
    SCAISpellAttack(saveType | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG, HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG, oCharacter);
}


void SCInitializeWarlockAttackSpells( object oCharacter = OBJECT_SELF )
{
    if (!gbUseSpells)
    {
        return;
    }
    int warlockLevel = GetLevelByClass(CLASS_TYPE_WARLOCK);
    if (warlockLevel < 1)
    {
        return;
    }	
	// epic warlock spells
	if (gbUseAbilities && (GetHitDice(oCharacter) > 20) && !gbDisableHighLevelSpells  && !gbDisablingEffect)
	{	
		if (GetHasFeat(1996 /* FEAT_EPIC_SPELL_DAMNATION_WARLOCK */, oCharacter))
		{
			SCHenchFeatDispatch(1996, 1076, FALSE, oCharacter);
		}
		if (GetHasFeat(1997 /* FEAT_EPIC_SPELL_ENTROPIC_HUSK_WARLOCK */, oCharacter))
		{
			SCHenchFeatDispatch(1997, 1077, FALSE, oCharacter);
		}
		if (GetHasFeat(1998 /* FEAT_EPIC_SPELL_EPIC_GATE_WARLOCK */, oCharacter))
		{
			SCHenchFeatDispatch(1998, 1078, FALSE, oCharacter);
		}
		if (GetHasFeat(1999 /* FEAT_EPIC_SPELL_HELLBALL_WARLOCK */, oCharacter))
		{
			SCHenchFeatDispatch(1999, 636, TRUE, oCharacter);
		}
		if (GetHasFeat(2000 /* FEAT_EPIC_SPELL_VAMPIRIC_FEAST_WARLOCK */, oCharacter))
		{
			SCHenchFeatDispatch(2000, 1080, FALSE, oCharacter);
		}
		if (GetHasFeat(3224 /* FEAT_EPIC_SPELL_EPIC_GATE */, oCharacter))
		{
			SCHenchFeatDispatch(3224, 1078, FALSE, oCharacter);
		}	
	}	
	
    if (!(HENCH_SPELL_INFO_UNLIMITED_FLAG & gbSpellInfoCastMask))
    {
        return;
    }
	// adjust warlock level for PrCs
	if (GetHasFeat(3271 /*FEAT_HEARTWARDER_SPELLCASTING_WARLOCK*/, oCharacter))
	{
		warlockLevel += GetLevelByClass(131 /*CLASS_HEARTWARDER*/);
	}
	if (GetHasFeat(3545 /*FEAT_STORMSINGER_SPELLCASTING_WARLOCK*/, oCharacter))
	{
		warlockLevel += GetLevelByClass(109 /*CLASS_STORMSINGER*/);
	}
	if (GetHasFeat(3341 /*FEAT_KOT_SPELLCASTING_WARLOCK*/, oCharacter))
	{
		warlockLevel += GetLevelByClass(132 /*CLASS_KNIGHT_TIERDRIAL*/);
	}
	if (GetHasFeat(3372 /*FEAT_DRSLR_SPELLCASTING_WARLOCK*/, oCharacter))
	{
		warlockLevel += (GetLevelByClass(134 /*CLASS_DRAGONSLAYER*/) + 1) / 2;
	}
	
    if (warlockLevel > 20)
    {
        giWarlockDamageDice = (warlockLevel - 2) / 2;
    	giWarlockMinSaveDC = giMySpellCasterDC + 9 + (warlockLevel - 20) / 3;
    }
	else
	{
		if (warlockLevel <= 12)
		{
			giWarlockDamageDice = (warlockLevel + 1) / 2;
		}
		else
		{
			giWarlockDamageDice = (warlockLevel + 7) / 3;
		}
		giWarlockMinSaveDC = giMySpellCasterDC + giWarlockDamageDice;
	}
	
	int saveOldSpellCasterSpellPenetration = giMySpellCasterSpellPenetration;
	if (warlockLevel > 9)
	{
		// warlock caster level seems to be capped at level 9 for spell resistance
		giMySpellCasterSpellPenetration -= warlockLevel - 9;
	}	
	
    int featIndex;
    for (featIndex = FEAT_EPIC_ELDRITCH_BLAST_1; featIndex <= FEAT_EPIC_ELDRITCH_BLAST_10; featIndex++)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (!GetHasFeat(featIndex, oCharacter))
        {
            break;
        }
        giWarlockDamageDice++;
    }
		// Fey Power Heritage Feat gives +1 to Warlock Level for this
	if (GetHasFeat(FEAT_FEY_POWER, oCharacter) || GetHasFeat(FEAT_FIENDISH_POWER, oCharacter))						
	{ 
        giWarlockDamageDice++;
	}
    gbWarlockMaster = GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCharacter);

    SCInitializeWarlockAttackSpell(SPELLABILITY_I_ELDRITCH_BLAST, giWarlockDamageDice);
    if (GetHasSpell(SPELL_I_VITRIOLIC_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_VITRIOLIC_BLAST, 3);
    }
    if (GetHasSpell(SPELL_I_UTTERDARK_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_UTTERDARK_BLAST, 4);
    }
    if (GetHasSpell(SPELL_I_NOXIOUS_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_NOXIOUS_BLAST, 3);
    }
    if (GetHasSpell(SPELL_I_BEWITCHING_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_BEWITCHING_BLAST, 3);
    }
    if (GetHasSpell(1131, oCharacter))	// binding blast
    {
        SCInitializeWarlockAttackSpell(1131, 7);
    }
    if (GetHasSpell(1130, oCharacter))	// hindering blast
    {
        SCInitializeWarlockAttackSpell(1130, 4);
    }
    if (GetHasSpell(SPELL_I_HELLRIME_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_HELLRIME_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_BRIMSTONE_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_BRIMSTONE_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_BESHADOWED_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_BESHADOWED_BLAST, 2);
    }
    if (GetHasSpell(SPELL_I_DRAINING_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_DRAINING_BLAST, 1);
    }
    if (GetHasSpell(SPELL_I_FRIGHTFUL_BLAST, oCharacter))
    {
        SCInitializeWarlockAttackSpell(SPELL_I_FRIGHTFUL_BLAST, 1);
    }
	
	giMySpellCasterSpellPenetration = saveOldSpellCasterSpellPenetration;
}


void SCInitializeSpellCasting( object oCharacter = OBJECT_SELF )
{
	// need to replace with cachestats instead
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeSpellCasting Start", GetFirstPC() ); }
	SCCacheStats( oCharacter );
	HkCacheAIProperties( oCharacter );
	
	int iBestCastingClass = GetLocalInt(oCharacter, "SCAI_sCasterClass" );
	//int iBestCastingClass = HkGetBestCasterClass( oCharacter );
	
	int spellCastingLevel;
	int spellCastingDC;
	int spellCastingFlags;	
	int prcBonusSpellCastingLevel;
	int sneakAttackDice = GetLocalInt(oCharacter, "SCAI_sSneakDice" );

	int iPosition = 1;
    int nClassLevel = GetLevelByPosition(iPosition);
	
	while ((nClassLevel > 0) && (iPosition <= 4))
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		//int nClass = SCHenchGetClassByPosition(iPosition, nClassLevel);
		int nClass = GetClassByPosition(iPosition);
		int nClassFlags = SCHenchGetClassFlags(nClass);		
		
		
		
		int testSpellProgFlags = nClassFlags & HENCH_CLASS_SPELL_PROG_MASK;
		if (testSpellProgFlags && !((nClassFlags & HENCH_CLASS_FOURTH_LEVEL_NEEDED) && (nClassLevel < 5)))
		{				
			//int testSpellCastingLevel;
			//testSpellCastingLevel 
			
			/*
			switch (testSpellProgFlags)
			{
				case HENCH_FULL_SPELL_PROGRESSION:
					testSpellCastingLevel = nClassLevel;
					break;
				case HENCH_SKIP_FIRST_SPELL_PROGRESSION:
					testSpellCastingLevel = nClassLevel - 1;
					break;
				case HENCH_EVERY_OTHER_ODD_SPELL_PROGRESSION:
					testSpellCastingLevel = (nClassLevel + 1) / 2;
					break;
				case HENCH_EVERY_OTHER_EVEN_SPELL_PROGRESSION:
					testSpellCastingLevel = nClassLevel / 2;
					break;
				case HENCH_SKIP_FOURTH_SPELL_PROGRESSION:
					testSpellCastingLevel = nClassLevel - nClassLevel / 4;
					break;
				case HENCH_SKIP_FIRST_THIRD_SPELL_PROGRESSION:
					testSpellCastingLevel = nClassLevel * 2 / 3;
					break;
			}
			
			if (nClassFlags & HENCH_CLASS_PRC_FLAG)
			{			
				prcBonusSpellCastingLevel += testSpellCastingLevel;			
			}
			else
			{			
				int practicedSpellCasterFeat = GetLocalInt(GetModule(), "HENCH_PS_INFO" + IntToString(nClass));
				if (practicedSpellCasterFeat && GetHasFeat(practicedSpellCasterFeat, oCharacter))
				{
					testSpellCastingLevel += 4;
				}
				if (testSpellCastingLevel > spellCastingLevel)
				{
					spellCastingLevel = testSpellCastingLevel;
					spellCastingFlags = nClassFlags;
				}				
			}
			*/
			
			if (iBestCastingClass == nClass )
			{
				//spellCastingLevel = GetLocalInt(oCharacter, "SCAI_sCasterPower" ); // HkGetSpellPower( oCharacter, 60,  nClass );
				spellCastingFlags = nClassFlags;
				//spellCastingDC = GetLocalInt(oCharacter, "SCAI_sSpellPenetration" ); // HkGetSpellSaveDC( oCharacter, OBJECT_INVALID, -1, nClass );
				//prcBonusSpellCastingLevel  = HkGetPracticedBonus( oCharacter, nClass );
			}
				
			if (nClassFlags & HENCH_CLASS_DIVINE_FLAG)
			{			
            	gbAnySpellcastingClasses |= HENCH_DIVINE_SPELLCASTING;
			}
			else
			{			
				if (!GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_3, oCharacter))
				{
					if (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_WIZARD)
					{
						if (GetArcaneSpellFailure(oCharacter) > 20)
						{
        					giExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
						}
					}
					else if (nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_WARLOCK)
					{
													// FEAT_ARMORED_CASTER_BARD FEAT_ARMORED_CASTER_WARLOCK
						if (GetArcaneSpellFailure(oCharacter) > ((GetHasFeat(1859, oCharacter) || GetHasFeat(1860, oCharacter)) ? 45 : 30))
						{
        					giExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
						}
					}
				}
            	gbAnySpellcastingClasses |= HENCH_ARCANE_SPELLCASTING;
			}
			//if (nClassFlags & HENCH_CLASS_DC_BONUS_FLAG)
			//{			
			//	giMySpellCasterDC += 1 + nClassLevel / 2;
			//}
		}
		
		
		/*
		switch (nClassFlags & HENCH_CLASS_SA_MASK)
		{
			case HENCH_CLASS_SA_NONE:
				break;			
			case HENCH_CLASS_SA_EVERY_OTHER_ODD:
				sneakAttackDice += (nClassLevel + 1) / 2;
				break;
			case HENCH_CLASS_SA_EVERY_OTHER_EVEN:
				sneakAttackDice += nClassLevel / 2;
				break;
			case HENCH_CLASS_SA_EVERY_THIRD_SKIP_FIRST:
				sneakAttackDice += (nClassLevel - 1) / 3;
				break;
			case HENCH_CLASS_SA_EVERY_THIRD:
				sneakAttackDice += nClassLevel / 3;
				break;
			case HENCH_CLASS_SA_EVERY_THIRD_FROM_TWO:
				sneakAttackDice += (nClassLevel + 1) / 3;
				break;
			case HENCH_CLASS_SA_EVERY_THIRD_FROM_ONE:
				sneakAttackDice += (nClassLevel + 2) / 3;
				break;
			default: // HENCH_CLASS_SA_EVERY_FORTH
				sneakAttackDice += nClassLevel / 4;
				break;
		}
		*/
		nClassLevel = GetLevelByPosition(++iPosition);
	}
	
	if (spellCastingFlags)
	{	
		//spellCastingLevel += prcBonusSpellCastingLevel;	
		//if (spellCastingLevel > GetHitDice(oCharacter))
		//{			
		//	spellCastingLevel = GetHitDice(oCharacter);
		//}
		//int iAbility = ((spellCastingFlags & HENCH_CLASS_ABILITY_MODIFIER_MASK) >> HENCH_CLASS_ABILITY_MODIFIER_SHIFT) + ABILITY_CONSTITUTION;
		//GetLocalInt(oCharacter, "SCAI_sCasterPower" );
		giMySpellCasterDC = GetLocalInt(oCharacter, "SCAI_sCasterSaveDC" );
		giMySpellCasterLevel = GetLocalInt(oCharacter, "SCAI_sCasterPower" );
		giMySpellCasterSpellPenetration = GetLocalInt(oCharacter, "SCAI_sSpellPenetration");
	}
	else
	{
		giMySpellCasterLevel = GetLocalInt(oCharacter, "HenchSACasterLevel");
		if (giMySpellCasterLevel <= 0)
		{
			giMySpellCasterLevel = GetCasterLevel(oCharacter);
			if (giMySpellCasterLevel <= 0)
			{
				giMySpellCasterLevel = GetHitDice(oCharacter);
			}
		}
		giMySpellCasterDC = 10+GetAbilityModifier(ABILITY_CHARISMA);
		giMySpellCasterSpellPenetration = giMySpellCasterLevel;
	}
    //if (giMySpellCasterLevel > 22)
    //{
    //    giMySpellCasterDC += (giMySpellCasterLevel - 20) / 3;
    //}
	//if (GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCharacter))
	//{
	//	giMySpellCasterDC ++;
	//}

    //giMySpellCasterDC += 10;
     // HkGetSpellPenetration( oCharacter, iBestCastingClass );
	
	/*
    if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCharacter))
    {
        nMySpellCasterSpellPenetrationBonus = 6;
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCharacter))
    {
        nMySpellCasterSpellPenetrationBonus = 4;
    }
    else if (GetHasFeat(FEAT_SPELL_PENETRATION, oCharacter))
    {
        nMySpellCasterSpellPenetrationBonus = 2;
    }
    */

    //giMySpellCasterSpellPenetration = giMySpellCasterLevel + nMySpellCasterSpellPenetrationBonus;
    giMySpellCastingConcentration = GetSkillRank(SKILL_CONCENTRATION);
    if (GetHasFeat(FEAT_COMBAT_CASTING, oCharacter))
    {
        giMySpellCastingConcentration += 4;
    }

    giMyRangedTouchAttack = GetBaseAttackBonus(oCharacter) + GetLocalInt(oCharacter, "HenchAttackBonus") + 11 /* 21 - 10 */;
    giMyMeleeTouchAttack = giMyRangedTouchAttack + GetAbilityModifier(ABILITY_STRENGTH);
    giMyRangedTouchAttack += GetAbilityModifier(ABILITY_DEXTERITY);
}


void SCInitializeItemSpells(int negativeEffects, int positiveEffects, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCInitializeItemSpells Start", GetFirstPC() ); }
    
    SetLocalObject(oCharacter, "HenchLastSpellTarget", oCharacter);

    int itemSpellsFound = FALSE;


	if (negativeEffects & HENCH_EFFECT_TYPE_SILENCE)
	{
		gbDisablingEffect = HENCH_DISABLE_EFFECT_SILENCE;
	}
	if (gfSpellFailureChance > 0.5)
	{
		gbDisablingEffect |= HENCH_DISABLE_EFFECT_NO_MAGIC;
	}

    giExcludedItemTalents = GetLocalInt(oCharacter, "N2_TALENT_EXCLUDE");

	goHealingKit = SCGetBestHealingKit( oCharacter );

    SCInitializeSpellCasting( oCharacter );

	

    if (!gbAnySpellcastingClasses || (gbDisablingEffect & HENCH_DISABLE_EFFECT_NO_MAGIC))
    {
        giExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
    }
    int bPolymorphed = positiveEffects & (HENCH_EFFECT_TYPE_POLYMORPH | HENCH_EFFECT_TYPE_WILDSHAPE);
    int bCheckForHealingAndCuringItems;
    if (bPolymorphed || !GetIsObjectValid(GetFirstItemInInventory()) || !SCGetCreatureUseItems(oCharacter))
    {
        giExcludedItemTalents |= TALENT_EXCLUDE_ITEM;
    }
    else if ((giExcludedItemTalents & TALENT_EXCLUDE_ITEM) && SCGetHenchAssociateState(HENCH_ASC_ENABLE_HEALING_ITEM_USE))
    {
        bCheckForHealingAndCuringItems = TRUE;
    }

    if (bPolymorphed)
    {

        if (!(positiveEffects & HENCH_EFFECT_TYPE_WILDSHAPE) || !GetHasFeat(FEAT_NATURAL_SPELL, oCharacter))
        {
            giExcludedItemTalents |= TALENT_EXCLUDE_SPELL;
        }

        giExcludedItemTalents |= TALENT_EXCLUDE_ABILITY;
/*
        no polymorph spell use in NWN2
        int polymorphShape = GetLocalInt(oCharacter, "HenchPolymorphType");
        int polymorphSpellIndex;
        for (polymorphSpellIndex = 1; polymorphSpellIndex <= 3; polymorphSpellIndex++)
        {
            int polymorphSpell = StringToInt(Get2DAString("polymorph", "SPELL" + IntToString(polymorphSpellIndex), polymorphShape));
            if (polymorphSpell <= 0)
            {
                break;
            }
            SCHenchSpontaneousDispatch(polymorphSpell, TRUE);
        } */
/*
        no potion use in NWN2
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_PROTECTION_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION);
        FindItemSpellTalentsByCategory2(TALENT_CATEGORY_BENEFICIAL_ENHANCEMENT_POTION, 5, TALENT_EXCLUDE_SPELL | TALENT_EXCLUDE_ABILITY, HENCH_ITEM_TYPE_POTION); */
    }
    else if (GetHasSkill(SKILL_HEAL) &&
        ((!(giExcludedItemTalents & TALENT_EXCLUDE_ITEM)) || bCheckForHealingAndCuringItems) &&
        (gbSpellInfoCastMask & HENCH_SPELL_INFO_HEAL_OR_CURE))
    {
        if (GetIsObjectValid(goHealingKit))
        {
            gsCurrentspInfo.castingInfo = HENCH_CASTING_INFO_USE_HEALING_KIT;
            gsCurrentspInfo.spellID = HENCH_HEALING_KIT_ID;
            gsCurrentspInfo.otherID = -1;
            gsCurrentspInfo.spellInfo = HENCH_SPELL_INFO_SPELL_TYPE_HEAL_SPECIAL | HENCH_SPELL_INFO_ITEM_FLAG;
            gsCurrentspInfo.spellLevel = 6;     // make this equivalent to a heal spell
            gsCurrentspInfo.shape = HENCH_SHAPE_NONE;
            gsCurrentspInfo.range = 4.0;

            SCHenchCheckHealSpecial();
        }
    }
	
	gbUseSpells = !(giExcludedItemTalents & TALENT_EXCLUDE_SPELL);
	gbUseAbilities = !(giExcludedItemTalents & TALENT_EXCLUDE_ABILITY);
	gbUseItems = !(giExcludedItemTalents & TALENT_EXCLUDE_ITEM);
	
	SCInitializeWarlockAttackSpells( oCharacter );
    if (gbUseAbilities && !(gbDisablingEffect & HENCH_DISABLE_EFFECT_NO_MAGIC))
    {
		SCHenchCheckReserveFeats(oCharacter);
    }	
	SCInitializeSpellTalents(oCharacter);

    if (bCheckForHealingAndCuringItems)
    {
		int saveDisableNonUnlimitedOrHealOrCure = gbDisableNonUnlimitedOrHealOrCure;
		gbDisableNonUnlimitedOrHealOrCure = TRUE;
        //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeItemSpells calling 19 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
        SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_POTION, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION, oCharacter);
        //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeItemSpells calling 20 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
        SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_TOUCH, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
        //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeItemSpells calling 21 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
        SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_HEALING_AREAEFFECT, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
        //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeItemSpells calling 22 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
        SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_POTION, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_POTION, oCharacter);
        //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeItemSpells calling 23 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
        SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_SINGLE, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
        //DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCInitializeItemSpells calling 24 SCFindItemSpellTalentsByCategory", GetFirstPC() ); }
        SCFindItemSpellTalentsByCategory(TALENT_CATEGORY_BENEFICIAL_CONDITIONAL_AREAEFFECT, 5, HENCH_TALENT_USE_ITEMS_ONLY, HENCH_ITEM_TYPE_OTHER, oCharacter);
		gbDisableNonUnlimitedOrHealOrCure = saveDisableNonUnlimitedOrHealOrCure;
    }

    if (gbUseAbilities)
    {
        SCInitializeFeats(oCharacter);
    }
}


void SCHenchDecrementSpontaneousSpell(int nSpellID, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchDecrementSpontaneousSpell Start", GetFirstPC() ); }
	
	int originalCount = GetHasSpell(nSpellID, oCharacter);
	DecrementRemainingSpellUses(oCharacter, nSpellID);
	int newCount = GetHasSpell(nSpellID, oCharacter);
	
	
	if (newCount < originalCount)
	{	
		return;
	}
	
	int spellInfo = SCGetSpellInformation(nSpellID);
	int spellLevel = (spellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
	int spellCR = spellLevel * 2;
	
	int talentCategory;
	int highestLevelSpell = -1;
	int decrementSpellID;
	for (talentCategory = TALENT_CATEGORY_CANTRIP; talentCategory--; talentCategory >= 0)
	{	
        //DEBUGGING// igDebugLoopCounter += 1;
        talent tBest = GetCreatureTalentBest(talentCategory, spellCR, oCharacter, HENCH_TALENT_USE_SPELLS_ONLY);
		if (GetIsTalentValid(tBest))
		{		
            int testSpellID = GetIdFromTalent(tBest);
			int testSpellInfo = SCGetSpellInformation(testSpellID);
			int testSpellLevel = (testSpellInfo & HENCH_SPELL_INFO_SPELL_LEVEL_MASK) >> HENCH_SPELL_INFO_SPELL_LEVEL_SHIFT;
			if (testSpellLevel > highestLevelSpell)
			{
				highestLevelSpell = testSpellLevel;
				decrementSpellID = testSpellID;
 				if (highestLevelSpell >= spellLevel)
				{
					break;
				}			
			}
		}
	}
	if (highestLevelSpell >= 0)
	{	
		DecrementRemainingSpellUses(oCharacter, decrementSpellID);
	}
}


void SCHenchCheckPolymorphFeatDecrement(int featID, object oHenchman = OBJECT_SELF )
{
	if (CSLGetHasEffectType(oHenchman,EFFECT_TYPE_POLYMORPH))
	{
		DecrementRemainingFeatUses(oHenchman, featID);
	}

}


void SCHenchCastSpell(struct sSpellInformation spInfo, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCastSpell Start", GetFirstPC() ); }
	
	int castingType = spInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK;
    if ((castingType == HENCH_CASTING_INFO_USE_SPELL_WARLOCK) &&
        (spInfo.otherID == SPELL_I_HIDEOUS_BLOW))
    {
		object oRightHandWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        SCHenchEquipAppropriateWeapons(spInfo.oTarget, 100.0, FALSE, FALSE);
        if (GetWeaponRanged(oRightHandWeapon))
        {
            ActionWait(1.0);
        }
        else if (CSLGetHasEffectType(oCharacter,EFFECT_TYPE_HIDEOUS_BLOW))
        {
            if ((GetCurrentAction() != ACTION_ATTACKOBJECT) ||
                (GetAttackTarget(oCharacter) != spInfo.oTarget))
            {
                ClearAllActions();
                ActionAttack(spInfo.oTarget);
            }
			SCHenchCheckCastAuraSpell();
            return;
        }
    }
	else
	{
    	ClearAllActions();
		SCHenchCheckCastAuraSpell();
	}


    switch (spInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK)
    {
		case HENCH_SPELL_INFO_SPELL_TYPE_HEAL:
		case HENCH_SPELL_INFO_SPELL_TYPE_HARM:
		case HENCH_SPELL_INFO_SPELL_TYPE_REGENERATE:
		case HENCH_SPELL_INFO_SPELL_TYPE_HEAL_SPECIAL:
			if (spInfo.oTarget == OBJECT_SELF && GetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE) == HENCH_HEAL_SELF_CANT)
			{
				if (gbAnyValidTarget && (gsBestSelfInvisibility.spellID > 0))
				{
						// become invisible
					spInfo = gsBestSelfInvisibility;
					spInfo.oTarget = oCharacter;
					castingType = spInfo.castingInfo & HENCH_CASTING_INFO_USE_MASK;
				}
				// indicate to others that going to heal self
				SetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_IN_PROG);
			}
			break;
		case HENCH_SPELL_INFO_SPELL_TYPE_SUMMON:
			if (spInfo.range == 0.0)
			{
				spInfo.oTarget = oCharacter;
			}
			else
			{
				spInfo.oTarget = OBJECT_INVALID;
				spInfo.lTargetLoc =  SCGetSummonLocation(spInfo.range);
			}
			break;
    }

    if (gbMeleeAttackers && !SCGetHenchAssociateState(HENCH_ASC_DISABLE_AUTO_WEAPON_SWITCH))
    {
        SCEquipShield(FALSE);
    }

    if (gbEnableMoveAway && GetIsObjectValid(spInfo.oTarget) && ((((spInfo.shape == HENCH_SHAPE_NONE) &&
        ((spInfo.range > 5.0) || (spInfo.oTarget == oCharacter)))) || (spInfo.castingInfo & HENCH_CASTING_INFO_RANGED_SEL_AREA_FLAG)))
    {
        gbEnableMoveAway = FALSE;
        if (spInfo.oTarget == oCharacter)
        {
            if (SCMoveAwayFromEnemies(goClosestSeenOrHeardEnemy, 9.0))
            {
                SCHenchStartCombatRoundAfterAction(OBJECT_INVALID);
                return;
            }
        }
        else
        {
            if (SCMoveAwayFromEnemies(spInfo.oTarget, spInfo.range > 10.0 ? 8.0 : spInfo.range - 1.0))
            {
                SCHenchStartCombatRoundAfterAction(spInfo.oTarget);
                return;
            }
        }
    }


    if ((spInfo.spellInfo & HENCH_SPELL_INFO_CONCENTRATION_FLAG) &&
        !(spInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG))
    {
		if (!GetLocalInt(oCharacter, "N2_COMBAT_MODE_USE_DISABLED"))
		{
			int bCurrentDefCastMode = GetActionMode(oCharacter, ACTION_MODE_DEFENSIVE_CAST);
			int bNewDefCastMode = gbMeleeAttackers && (SCGetd20Chance(giMySpellCastingConcentration - 15 - spInfo.spellLevel) > 0.67);
	
	
			if (bCurrentDefCastMode != bNewDefCastMode)
			{
				SetActionMode(oCharacter, ACTION_MODE_DEFENSIVE_CAST, bNewDefCastMode);
			}
			if (!bNewDefCastMode)
			{
				if (GetHasFeat(FEAT_IMPROVED_COMBAT_EXPERTISE, oCharacter))
				{
					if (!GetActionMode(oCharacter, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE))
					{
						SetActionMode(oCharacter, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE, TRUE);
					}
				}
				else if (GetHasFeat(FEAT_COMBAT_EXPERTISE, oCharacter))
				{		
					if (!GetActionMode(oCharacter, ACTION_MODE_COMBAT_EXPERTISE))
					{
						SetActionMode(oCharacter, ACTION_MODE_COMBAT_EXPERTISE, TRUE);
					}
				}
			}
		}
    }
	DeleteLocalInt(oCharacter, "HenchSpellCasterLevelOverride");
    if (castingType == HENCH_CASTING_INFO_USE_SPELL_TALENT)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
            SetLocalObject(oCharacter, "HenchLastSpellTarget", spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(oCharacter, "LastTarget", spInfo.oTarget);
            }
            ActionUseTalentOnObject(spInfo.tTalent, spInfo.oTarget);
        }
        else
        {
            ActionUseTalentAtLocation(spInfo.tTalent, spInfo.lTargetLoc);
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_SPELL_FEATID)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
            SetLocalObject(oCharacter, "HenchLastSpellTarget", spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(oCharacter, "LastTarget", spInfo.oTarget);
            }
            if (spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_CAST_FLAG)
            {
                //AssignCommand(oCharacter, ActionCastSpellAtObject(spInfo.spellID, spInfo.oTarget, METAMAGIC_NONE, TRUE) );
                AssignCommand(oCharacter, ActionCastSpellAtObject(spInfo.spellID, spInfo.oTarget, METAMAGIC_NONE, FALSE) );				
				if ((spInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK) == HENCH_SPELL_INFO_SPELL_TYPE_POLYMORPH)
				{
					DelayCommand(4.5, SCHenchCheckPolymorphFeatDecrement(spInfo.otherID));
				}
				else
				{				
                	ActionDoCommand(DecrementRemainingFeatUses(oCharacter, spInfo.otherID));
				}
            }
            else
            {
                ActionUseFeat(spInfo.otherID, spInfo.oTarget);
            }
        }
        else
        {
            // TODO see if this is messing it up // ActionCastSpellAtLocation(spInfo.spellID, spInfo.lTargetLoc, METAMAGIC_NONE, TRUE);
            ActionDoCommand(DecrementRemainingFeatUses(oCharacter, spInfo.otherID));
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_SPELL_WARLOCK)
    {
        if (GetIsObjectValid(spInfo.oTarget))
        {
            SetLocalObject(oCharacter, "HenchLastSpellTarget", spInfo.oTarget);
            SetLocalObject(oCharacter, "LastTarget", spInfo.oTarget);
        }
        if (spInfo.otherID > 0)
        {
            int nMetamagicEssence = METAMAGIC_NONE;
            switch (spInfo.spellID)
            {
            case SPELL_I_FRIGHTFUL_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_FRIGHTFUL_BLAST;
                break;
            case SPELL_I_DRAINING_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_DRAINING_BLAST;
                break;
            case SPELL_I_BESHADOWED_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BESHADOWED_BLAST;
                break;
            case SPELL_I_BRIMSTONE_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BRIMSTONE_BLAST;
                break;
            case SPELL_I_HELLRIME_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_HELLRIME_BLAST;
                break;
            case SPELL_I_BEWITCHING_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_BEWITCHING_BLAST;
                break;
            case SPELL_I_NOXIOUS_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_NOXIOUS_BLAST;
                break;
            case SPELL_I_VITRIOLIC_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_VITRIOLIC_BLAST;
                break;
            case SPELL_I_UTTERDARK_BLAST:
                nMetamagicEssence = METAMAGIC_INVOC_UTTERDARK_BLAST;
                break;
			case 1131:	// binding blast
                nMetamagicEssence = METAMAGIC_INVOC_BINDING_BLAST;
                break;			
			case 1130:	// hindering blast
                nMetamagicEssence = METAMAGIC_INVOC_HINDERING_BLAST;
                break;
            }
            if (GetIsObjectValid(spInfo.oTarget))
            {
				if ((spInfo.otherID == SPELL_I_HIDEOUS_BLOW) && SCGetHenchOption(HENCH_OPTION_HIDEOUS_BLOW_INSTANT))
				{
					// make hideous blow instance so it doesn' take two rounds
                	AssignCommand(oCharacter, ActionCastSpellAtObject(spInfo.otherID, spInfo.oTarget, nMetamagicEssence, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
				}
				else
				{
                	AssignCommand(oCharacter, ActionCastSpellAtObject(spInfo.otherID, spInfo.oTarget, nMetamagicEssence) );
				}
            }
            else
            {
                AssignCommand(oCharacter, ActionCastSpellAtLocation(spInfo.otherID, spInfo.lTargetLoc, nMetamagicEssence) );
            }
        }
        else if (spInfo.spellID != SPELLABILITY_I_ELDRITCH_BLAST)
        {
            AssignCommand(oCharacter, ActionCastSpellAtObject(spInfo.spellID,  spInfo.oTarget) );
        }
        else
        {
            int nFeat = SCGetBestEldritchBlastFeat();
            ActionUseFeat(nFeat, spInfo.oTarget);
        }
    }
    else if ((castingType == HENCH_CASTING_INFO_USE_SPELL_REGULAR) || (castingType == HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT))
    {
		int bUseCheatCast = spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_CAST_FLAG;
		if (bUseCheatCast)
		{
			// set the cheat cast caster level
			SetLocalInt(oCharacter, "HenchSpellCasterLevelOverride", (spInfo.castingInfo & HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_MASK) >> HENCH_CASTING_INFO_CHEAT_SPELL_LEVEL_SHIFT);
			DelayCommand(5.0, DeleteLocalInt(oCharacter, "HenchSpellCasterLevelOverride"));
		}
        if (GetIsObjectValid(spInfo.oTarget))
        {
            SetLocalObject(oCharacter, "HenchLastSpellTarget", spInfo.oTarget);
            if (GetIsEnemy(spInfo.oTarget))
            {
                SetLocalObject(oCharacter, "LastTarget", spInfo.oTarget);
            }
            bUseCheatCast = FALSE;
            AssignCommand(oCharacter, ActionCastSpellAtObject(spInfo.spellID, spInfo.oTarget, spInfo.otherID, bUseCheatCast) );
        }
        else
        {
            // TODO see if this is messing it up //
            bUseCheatCast = FALSE;
            ActionCastSpellAtLocation(spInfo.spellID, spInfo.lTargetLoc, spInfo.otherID, bUseCheatCast);
        }
        if (castingType == HENCH_CASTING_INFO_USE_SPELL_CURE_OR_INFLICT)
        {
            int nMainSpell = spInfo.spellID;
            ActionDoCommand(SCHenchDecrementSpontaneousSpell(nMainSpell));
        }
    }
    else if (castingType == HENCH_CASTING_INFO_USE_HEALING_KIT)
    {
        ActionUseSkill(SKILL_HEAL, spInfo.oTarget, 0, goHealingKit);
    }
		
	switch (spInfo.spellInfo & HENCH_SPELL_INFO_SPELL_TYPE_MASK)
    {
	case HENCH_SPELL_INFO_SPELL_TYPE_ATTACK:
		if (spInfo.castingInfo & HENCH_CASTING_INFO_PERSISTENT_SPELL_FLAG)
		{
			// create marker so other party members won't duplicate persistent AoE spells
			location lTarget;
			if (GetIsObjectValid(spInfo.oTarget))
			{
				lTarget = GetLocation(spInfo.oTarget);
			}
			else
			{
				lTarget = spInfo.lTargetLoc;
			}
			object oMarker = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", lTarget, FALSE, "persist_spell_marker");
			DestroyObject(oMarker, 4.0);
			SetLocalObject(oMarker, "persist_spell_marker", oCharacter);
			SetLocalInt(oMarker, "persist_spell_marker", GetLocalInt(GetModule(), "HenchPersistSpellID" + IntToString(spInfo.spellID)));
		}
		break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DISPEL:
        SetLocalInt(oCharacter, "tkLastDispel", GetLocalInt(oCharacter, "tkCombatRoundCount"));
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DRAGON_BREATH:
       SetLocalInt(oCharacter, "tkLastDragonBreath", GetLocalInt(oCharacter, "tkCombatRoundCount"));
       break;
    case HENCH_SPELL_INFO_SPELL_TYPE_DOMINATE:
        SetLocalInt(oCharacter, "tkLastDominate", GetLocalInt(oCharacter, "tkCombatRoundCount"));
        break;
    case HENCH_SPELL_INFO_SPELL_TYPE_TURN_UNDEAD:
        SetLocalInt(oCharacter, "tkLastTurning",  GetLocalInt(oCharacter, "tkCombatRoundCount"));
        break;
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCHenchCastSpell End", GetFirstPC() ); }
}


int SCHenchCheckSpellToCast(int currentRound, int bTestOnly = FALSE, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckSpellToCast Start", GetFirstPC() ); }
	
    SCHenchGetBestDispelTarget();

    struct sSpellInformation spInfo;
    int bFound;
	
	// check best option for invisibility and
	// check if some pending buff or early rounds with sneak attacks and melee attack chosen	
	if ((gsBestSelfHide.spellID > 0) && (((bfBuffTargetAccumWeight > gfAttackTargetWeight) && 
		(giNumberOfPendingBuffs > 2)) || ((currentRound < 3) &&
		GetHasFeat(FEAT_SNEAK_ATTACK, oCharacter) && (gsAttackTargetInfo.spellID < 0))))
	{
        spInfo = gsBestSelfHide;
        spInfo.oTarget = oCharacter;
        bFound = TRUE;
        gbEnableMoveAway = FALSE;
    }
    else if ((gsAttackTargetInfo.spellID >= 0) && (gfAttackTargetWeight >= gfBuffTargetWeight))
    {
        spInfo = gsAttackTargetInfo;
        bFound = TRUE;
    }
    else if ((gsBuffTargetInfo.spellID >= 0) && (gfBuffTargetWeight > gfAttackTargetWeight))
    {
        spInfo = gsBuffTargetInfo;
        bFound = TRUE;
    }
    else if ((gsMeleeAttackspInfo.spellID > 0) && (SCGetConcetrationWeightAdjustment(gsMeleeAttackspInfo.spellInfo, gsMeleeAttackspInfo.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        spInfo = gsMeleeAttackspInfo;
        spInfo.oTarget = oCharacter;
        bFound = TRUE;
        gbEnableMoveAway = FALSE;
    }
    else if ((gsDelayedAttrBuff.spellID > 0) && (SCGetConcetrationWeightAdjustment(gsDelayedAttrBuff.spellInfo, gsDelayedAttrBuff.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        spInfo = gsDelayedAttrBuff;
        spInfo.oTarget = oCharacter;
        bFound = TRUE;
        gbEnableMoveAway = FALSE;
    }
    else if ((gsPolymorphspInfo.spellID > 0) && (SCGetConcetrationWeightAdjustment(gsPolymorphspInfo.spellInfo, gsPolymorphspInfo.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
    {
        if ((gsPolyAttrBuff.spellID > 0) && (SCGetConcetrationWeightAdjustment(gsPolyAttrBuff.spellInfo, gsPolyAttrBuff.spellLevel) >= (IntToFloat(Random(100)) / 100.0)))
        {
            spInfo = gsPolyAttrBuff;
        }
        else
        {
            spInfo = gsPolymorphspInfo;
        }
        spInfo.oTarget = oCharacter;
        bFound = TRUE;
        gbEnableMoveAway = FALSE;
    }

    if (bFound)
    {
        if (!bTestOnly)
        {
            SCHenchCastSpell(spInfo);
        }
        return TRUE;
    }

    return FALSE;
}


int SCCheckAOEForSelf(int currentNegEffects, int currentPosEffects, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCheckAOEForSelf Start", GetFirstPC() ); }
    
    object oAOE = SCHenchGetAOEProblem(currentNegEffects, currentPosEffects);

    if (!GetIsObjectValid(oAOE))
    {
        return FALSE;
    }

    int bDisableRemove;	
	object oAOECreator = GetAreaOfEffectCreator(oAOE);
		
	if (GetFactionEqual(oAOECreator) || GetIsFriend(oAOECreator))
	{
		bDisableRemove = TRUE;
	}
	
	int persistSpellFlags = SCHenchGetAoESpellInfo(oAOE);
	if (!bDisableRemove)
	{
		if ((persistSpellFlags & HENCH_PERSIST_FOG) && (gsGustOfWind.spellID > 0))
		{
			gsGustOfWind.oTarget = OBJECT_INVALID;
			gsGustOfWind.lTargetLoc = SCFindBestDispelLocation(oAOE);
			SCHenchCastSpell(gsGustOfWind);
			return TRUE;
		}
		if ((persistSpellFlags & HENCH_PERSIST_CAN_DISPEL) && (gsBestDispel.spellID > 0) && !GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL"))
		{		
			int nSpellInformation = SCGetSpellInformation(persistSpellFlags & HENCH_PERSIST_SPELL_MASK);		
    		if ((nSpellInformation & HENCH_SPELL_TARGET_RANGE_MASK) == HENCH_SPELL_TARGET_RANGE_PERSONAL)
			{
				gsBestDispel.oTarget = oAOECreator;
				SCHenchCastSpell(gsBestDispel);
				return TRUE;
			}
			gsBestDispel.oTarget = OBJECT_INVALID;
			gsBestDispel.lTargetLoc = SCFindBestDispelLocation(oAOE);
			SCHenchCastSpell(gsBestDispel);
			return TRUE;
		}
	}
    if (!gbMeleeAttackers && (persistSpellFlags & HENCH_PERSIST_MOVE_AWAY) && !(currentNegEffects & HENCH_EFFECT_IMMOBILE))
    {	
		if ((persistSpellFlags & HENCH_PERSIST_SPELL_MASK) == SPELL_SILENCE)
		{
			// make sure we don't have silence effect
			effect eCurEffect = GetFirstEffect(oCharacter);
			while (GetIsEffectValid(eCurEffect))
			{
				//DEBUGGING// igDebugLoopCounter += 1;
				if (GetEffectType(eCurEffect) == EFFECT_TYPE_AREA_OF_EFFECT)
				{
                	if (GetEffectSpellId(eCurEffect) == SPELL_SILENCE)
					{
						// can't run away from self
						return FALSE;
					}
				}
				eCurEffect = GetNextEffect(oCharacter);			
			}		
		}	
            // run away if no melee attackers
        ActionMoveAwayFromLocation(GetLocation(oAOE), TRUE, 10.0);
        return TRUE;
    }
    return FALSE;
}











void SCHenchInitializeInvisibility(int posEffectsOnSelf, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchInitializeInvisibility Start", GetFirstPC() ); }
    
    if (posEffectsOnSelf & HENCH_EFFECT_INVISIBLE)
    {
        return;
    }
    gbCheckInvisbility = TRUE;

    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_TRUE_SEEING)))
    {
        gbTrueSeeingNear = TRUE;
        return;
    }
    // since SC GetCreatureHasItemProperty is an expensive call, only do for closest
    if (GetIsObjectValid(goClosestSeenEnemy))
    {
     /*   if (GetHasFeat(FEAT_BLINDSIGHT_60_FEET, oTarget))
        {
            return TRUE;
        } */
        if (SCGetCreatureHasItemProperty(ITEM_PROPERTY_TRUE_SEEING, goClosestSeenEnemy))
        {
            gbTrueSeeingNear = TRUE;
            return;
        }
    }
    if (GetIsObjectValid(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_HAS_SPELL_EFFECT, SPELL_SEE_INVISIBILITY)))
    {
        gbSeeInvisNear = TRUE;
        return;
    }
}


void SCHenchTalentStealth(int bInvisible, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchTalentStealth Start", GetFirstPC() ); }
    
    if (GetActionMode(oCharacter, ACTION_MODE_STEALTH))
    {
        return;
    }
   int bHideInPlainSight = bInvisible || GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oCharacter) ||
        (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT_OUTDOORS, oCharacter) &&
		GetIsAreaNatural(GetArea(oCharacter)) &&
		!GetIsAreaInterior(GetArea(oCharacter)) &&
		GetIsAreaAboveGround(GetArea(oCharacter)));
    if (!bHideInPlainSight && !SCGetSpawnInCondition(CSL_FLAG_STEALTH) &&
        !(SCGetHenchOption(HENCH_OPTION_STEALTH) & HENCH_OPTION_STEALTH))
    {
        return;
    }

    int nThreshold = GetHitDice(oCharacter) / 2;
    if ((GetSkillRank(SKILL_HIDE, oCharacter, TRUE) <= nThreshold) &&
        (GetSkillRank(SKILL_MOVE_SILENTLY, oCharacter, TRUE) <= nThreshold))
    {
        return;
    }

    if (bHideInPlainSight ||
        (!GetIsObjectValid(goClosestSeenEnemy) &&
        !LineOfSightObject(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY), oCharacter)))
    {
        // try to sneak up to target
        SetActionMode(oCharacter, ACTION_MODE_STEALTH, TRUE);
    }
}




void SCHenchCheckIfAttackSpellToCastAtLocation(float fFinalTargetWeight, location lTargetLocation)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchCheckIfAttackSpellToCastAtLocation Start", GetFirstPC() ); }
    
    if (fFinalTargetWeight > 0.0)
    {
        fFinalTargetWeight *= SCGetConcetrationWeightAdjustment(gsCurrentspInfo.spellInfo, gsCurrentspInfo.spellLevel);

        if (fFinalTargetWeight >= gfAttackTargetWeight)
        {

            if ((gfAttackTargetWeight == 0.0) || (fFinalTargetWeight >= gfAttackTargetWeight * 1.02) ||
                (gsCurrentspInfo.spellLevel < gsAttackTargetInfo.spellLevel))
            {
                gfAttackTargetWeight = fFinalTargetWeight;

                gsAttackTargetInfo = gsCurrentspInfo;
                gsAttackTargetInfo.oTarget = OBJECT_INVALID;
                gsAttackTargetInfo.lTargetLoc = lTargetLocation;
            }
        }
    }
}



void SCHenchInitiailizePersistentSpellInfo()
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCHenchInitiailizePersistentSpellInfo Start", GetFirstPC() ); }
	
	object oModule = GetModule();
	if (GetLocalInt(oModule, "HenchPersistSpellInit") < HENCH_PERSIST_SPELL_VERSION)
	{
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_FOGACID", 0x46CF0000);
        SetLocalInt(oModule, "HenchPersistSpellID0", 0x46CF0000);
        SetLocalInt(oModule, "HenchPersistSpellID745", 0x46CF0000);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_FOGKILL", 0x45CF0017);
        SetLocalInt(oModule, "HenchPersistSpellID23", 0x45CF0017);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_DARKNESS", 0x42450024);
        SetLocalInt(oModule, "HenchPersistSpellID36", 0x42450024);
        SetLocalInt(oModule, "HenchPersistSpellID345", 0x42450024);
        SetLocalInt(oModule, "HenchPersistSpellID606", 0x42450024);
        SetLocalInt(oModule, "HenchPersistSpellID810", 0x42450024);
        SetLocalInt(oModule, "HenchPersistSpellID941", 0x42450024);
        SetLocalInt(oModule, "HenchPersistSpellID1196", 0x42450024);
        SetLocalInt(oModule, "HenchPersistSpellID1704", 0x42450024);
        SetLocalInt(oModule, "HenchPersistSpellID1722", 0x42450024);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_DELAY_BLAST_FIREBALL", 0x474F0027);
        SetLocalInt(oModule, "HenchPersistSpellID39", 0x474F0027);
        SetLocalInt(oModule, "HenchPersistSpellID971", 0x474F0027);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_ENTANGLE", 0x41470035);
        SetLocalInt(oModule, "HenchPersistSpellID53", 0x41470035);
        SetLocalInt(oModule, "HenchPersistTagx2_s0_vinementc", 0x43460212);
        SetLocalInt(oModule, "HenchPersistSpellID530", 0x43460212);
        SetLocalInt(oModule, "HenchPersistTagx2_s0_vinemhmpc", 0x43460213);
        SetLocalInt(oModule, "HenchPersistSpellID531", 0x43460213);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_FOGGHOUL", 0x42670040);
        SetLocalInt(oModule, "HenchPersistSpellID64", 0x42670040);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_GREASE", 0x41470042);
        SetLocalInt(oModule, "HenchPersistSpellID66", 0x41470042);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_FOGFIRE", 0x48CF0059);
        SetLocalInt(oModule, "HenchPersistSpellID89", 0x48CF0059);
        SetLocalInt(oModule, "HenchPersistSpellID744", 0x48CF0059);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_INVISIBILITY_PURGE", 0x4365005B);
        SetLocalInt(oModule, "HenchPersistSpellID91", 0x4365005B);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_INVIS_SPHERE", 0x4361005C);
        SetLocalInt(oModule, "HenchPersistSpellID92", 0x4361005C);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_CIRCGOOD", 0x43410068);
        SetLocalInt(oModule, "HenchPersistSpellID104", 0x43410068);
        SetLocalInt(oModule, "HenchPersistTagx0_s0_dirgehb", 0x466601BD);
        SetLocalInt(oModule, "HenchPersistSpellID445", 0x466601BD);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_CIRCEVIL", 0x43410069);
        SetLocalInt(oModule, "HenchPersistSpellID105", 0x43410069);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_FOGMIND", 0x45C70076);
        SetLocalInt(oModule, "HenchPersistSpellID118", 0x45C70076);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_SILENCE", 0x424F00A3);
        SetLocalInt(oModule, "HenchPersistSpellID163", 0x424F00A3);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_FOGSTINK", 0x43CF00AB);
        SetLocalInt(oModule, "HenchPersistSpellID171", 0x43CF00AB);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_STORM", 0x494B00AD);
        SetLocalInt(oModule, "HenchPersistSpellID173", 0x494B00AD);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_WALLFIRE", 0x444F00BF);
        SetLocalInt(oModule, "HenchPersistSpellID191", 0x444F00BF);
        SetLocalInt(oModule, "HenchPersistSpellID343", 0x444F00BF);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_WEB", 0x424700C0);
        SetLocalInt(oModule, "HenchPersistSpellID192", 0x424700C0);
        SetLocalInt(oModule, "HenchPersistSpellID352", 0x424700C0);
        SetLocalInt(oModule, "HenchPersistTagx2_s1_bebwebc", 0x490602DB);
        SetLocalInt(oModule, "HenchPersistSpellID731", 0x490602DB);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_BLINDING", 0x452300C3);
        SetLocalInt(oModule, "HenchPersistSpellID195", 0x452300C3);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_FROST", 0x442300C4);
        SetLocalInt(oModule, "HenchPersistSpellID196", 0x442300C4);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_ELECTRICAL", 0x442300C5);
        SetLocalInt(oModule, "HenchPersistSpellID197", 0x442300C5);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_FEAR", 0x442300C6);
        SetLocalInt(oModule, "HenchPersistSpellID198", 0x442300C6);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_FIRE", 0x442300C7);
        SetLocalInt(oModule, "HenchPersistSpellID199", 0x442300C7);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_MENACE", 0x432300C8);
        SetLocalInt(oModule, "HenchPersistSpellID200", 0x432300C8);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_PROTECTION", 0x412100C9);
        SetLocalInt(oModule, "HenchPersistSpellID201", 0x412100C9);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_STUN", 0x452300CA);
        SetLocalInt(oModule, "HenchPersistSpellID202", 0x452300CA);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_UNEARTHLY", 0x472300CB);
        SetLocalInt(oModule, "HenchPersistSpellID203", 0x472300CB);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_UNNATURAL", 0x432300CC);
        SetLocalInt(oModule, "HenchPersistSpellID204", 0x432300CC);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_TYRANT_FOG", 0x43A30132);
        SetLocalInt(oModule, "HenchPersistSpellID306", 0x43A30132);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_AURA_OF_COURAGE", 0x4121013A);
        SetLocalInt(oModule, "HenchPersistSpellID314", 0x4121013A);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_DROWNED", 0x43270145);
        SetLocalInt(oModule, "HenchPersistSpellID325", 0x43270145);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_EVARDS_BLACK_TENTACLES", 0x444F0177);
        SetLocalInt(oModule, "HenchPersistSpellID375", 0x444F0177);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_DRAGON_FEAR", 0x4723019C);
        SetLocalInt(oModule, "HenchPersistSpellID412", 0x4723019C);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_SPIKE_GROWTH", 0x434F01C6);
        SetLocalInt(oModule, "HenchPersistSpellID454", 0x434F01C6);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_CHOKE_POWDER", 0x434F01D3);
        SetLocalInt(oModule, "HenchPersistSpellID467", 0x434F01D3);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_BATTLETIDE", 0x45630205);
        SetLocalInt(oModule, "HenchPersistSpellID517", 0x45630205);
        SetLocalInt(oModule, "HenchPersistSpellID963", 0x45630205);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_STONEHOLD", 0x464F0223);
        SetLocalInt(oModule, "HenchPersistSpellID547", 0x464F0223);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_GLYPH", 0x434F0225);
        SetLocalInt(oModule, "HenchPersistSpellID549", 0x434F0225);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_FOGBEWILDERMENT", 0x42CF0239);
        SetLocalInt(oModule, "HenchPersistSpellID569", 0x42CF0239);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_CHILLING_TENTACLES", 0x454F033F);
        SetLocalInt(oModule, "HenchPersistSpellID831", 0x454F033F);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_WALL_PERILOUS_FLAME", 0x454F0345);
        SetLocalInt(oModule, "HenchPersistSpellID837", 0x454F0345);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_SHADOW_PLAGUE", 0x412703AA);
        SetLocalInt(oModule, "HenchPersistSpellID938", 0x412703AA);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_PROTECTIVE_AURA", 0x412103BD);
        SetLocalInt(oModule, "HenchPersistSpellID957", 0x412103BD);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_WAR_GLORY", 0x416703BF);
        SetLocalInt(oModule, "HenchPersistSpellID959", 0x416703BF);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_AURA_OF_DESPAIR", 0x412303C8);
        SetLocalInt(oModule, "HenchPersistSpellID968", 0x412303C8);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_HEZROU_STENCH", 0x492303D5);
        SetLocalInt(oModule, "HenchPersistSpellID981", 0x492303D5);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_GHAST_STENCH", 0x442303D6);
        SetLocalInt(oModule, "HenchPersistSpellID982", 0x442303D6);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_WALLBLADE", 0x464F03DA);
        SetLocalInt(oModule, "HenchPersistSpellID986", 0x464F03DA);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_BLADE_BARRIER", 0x466F03DB);
        SetLocalInt(oModule, "HenchPersistSpellID987", 0x466F03DB);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_BODY_SUN", 0x426703E9);
        SetLocalInt(oModule, "HenchPersistSpellID1001", 0x426703E9);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_WALL_DISPEL_MAGIC", 0x45570409);
        SetLocalInt(oModule, "HenchPersistSpellID1033", 0x45570409);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_GREAT_WALL_DISPEL_MAGIC", 0x4857040A);
        SetLocalInt(oModule, "HenchPersistSpellID1034", 0x4857040A);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_REACH_TO_THE_BLAZE", 0x42670419);
        SetLocalInt(oModule, "HenchPersistSpellID1049", 0x42670419);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_SHROUDING_FOG", 0x42C5041A);
        SetLocalInt(oModule, "HenchPersistSpellID1050", 0x42C5041A);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_KELEMVORS_GRACE", 0x4161049F);
        SetLocalInt(oModule, "HenchPersistSpellID1183", 0x4161049F);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_HELLFIRE_SHIELD", 0x416304A3);
        SetLocalInt(oModule, "HenchPersistSpellID1187", 0x416304A3);
        SetLocalInt(oModule, "HenchPersistTagVFX_MOB_PRC_CIRCEVIL", 0x434106AD);
        SetLocalInt(oModule, "HenchPersistSpellID1709", 0x434106AD);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_NI_TEAMWORK", 0x4961072E);
        SetLocalInt(oModule, "HenchPersistSpellID1838", 0x4961072E);
        SetLocalInt(oModule, "HenchPersistSpellID1839", 0x4961072E);
        SetLocalInt(oModule, "HenchPersistSpellID1878", 0x4961072E);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_STORMSINGER_STORM", 0x494B076B);
        SetLocalInt(oModule, "HenchPersistSpellID1899", 0x494B076B);
        SetLocalInt(oModule, "HenchPersistTagVFX_PER_RADIANT_AURA", 0x42630799);
        SetLocalInt(oModule, "HenchPersistSpellID1945", 0x42630799);

		SetLocalInt(oModule, "HenchPersistSpellInit", HENCH_PERSIST_SPELL_VERSION);
	}
}



// * called from state scripts (nw_g0_charm) to signal
// * to other party members to help me out
void SCSendForHelp( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSendForHelp Start", GetFirstPC() ); }
    
    // Apr. 1/04 (not an April Fool's joke, sorry)
    // Make sure we are in a PC's party. NPC's won't use the event fired...
    if(!GetIsPC(GetFactionLeader(oCharacter)))
    {
        // Stop
        return;
    }

    // *
    // * September 2003
    // * Was this a disabling type spell
    // * Signal an event so that my party members
    // * can check to see if they can remove it for me
    // *
    object oParty = GetFirstFactionMember(oCharacter, FALSE);
    while (GetIsObjectValid(oParty) == TRUE)
    {
		//DEBUGGING// igDebugLoopCounter += 1;
        SignalEvent(oParty, EventUserDefined(46500));
        oParty = GetNextFactionMember(oCharacter, FALSE);
    }

}




// Manually pick the nearest locked object
int SCManualPickNearestLock()
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCManualPickNearestLock Start", GetFirstPC() ); }
    
    object oLastObject = SCGetLockedObject(CSLGetCurrentMaster());

    //MyPrintString("Attempting to unlock: " + GetTag(oLastObject));
    return SCAttemptToOpenLock(oLastObject);
}











// Handles responses to henchmen commands, including both radial
// menu and voice commands.
void SCRespondToHenchmenShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID, int nBanInventory=FALSE, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCRespondToHenchmenShout Start", GetFirstPC() ); }
    // * if petrified, jump out
    if ( CSLGetHasEffectType(oCharacter,EFFECT_TYPE_PETRIFY) )
    {
        return;
    }

    // * MODIFIED February 19 2003
    // * Do not respond to shouts if in dying mode
    if (SCGetIsHenchmanDying() == TRUE)
        return;

    // Do not respond to shouts if you've surrendered.
/*    int iSurrendered = GetLocalInt(oCharacter,"Generic_Surrender");
    if (iSurrendered)
        return;*/
    if(GetLocalInt(oCharacter,"Generic_Surrender")) return;

    object oLastObject;
    object oTrap;
    object oMaster = CSLGetCurrentMaster();

    object oTarget;

    //ASSOCIATE SHOUT RESPONSES
    switch(nShoutIndex)
    {

    // * toggle search mode for henchmen
    case ASSOCIATE_COMMAND_TOGGLESEARCH:
    {
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_TOGGLESEARCH command." );
        if (GetActionMode(oCharacter, ACTION_MODE_DETECT) == TRUE)
        {
            SetActionMode(oCharacter, ACTION_MODE_DETECT, FALSE);
        }
        else
        {
            SetActionMode(oCharacter, ACTION_MODE_DETECT, TRUE);
        }
        break;
    }
    // * toggle stealth mode for henchmen
    case ASSOCIATE_COMMAND_TOGGLESTEALTH:
    {
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_TOGGLESTEALTH command." );
        //SpeakString(" toggle stealth");
        if (GetActionMode(oCharacter, ACTION_MODE_STEALTH) == TRUE)
        {
            SetActionMode(oCharacter, ACTION_MODE_STEALTH, FALSE);
        }
        else
        {
            SetActionMode(oCharacter, ACTION_MODE_STEALTH, TRUE);
        }
        break;
    }
    // * June 2003: Stop spellcasting
    case ASSOCIATE_COMMAND_TOGGLECASTING:
    {
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_TOGGLECASTING command." );
        if (GetLocalInt(oCharacter, "X2_L_STOPCASTING") == 10)
        {
           // SpeakString("Was in no casting mode. Switching to cast mode");
            SetLocalInt(oCharacter, "X2_L_STOPCASTING", 0);
            SCVoiceCanDo();
        }
        else
        if (GetLocalInt(oCharacter, "X2_L_STOPCASTING") == 0)
        {
         //   SpeakString("Was in casting mode. Switching to NO cast mode");
            SetLocalInt(oCharacter, "X2_L_STOPCASTING", 10);
            SCVoiceCanDo();
        }
      break;
    }
    case ASSOCIATE_COMMAND_INVENTORY:
        // feb 18. You are now allowed to access inventory during combat.
         if (nBanInventory == TRUE)
        {
            SpeakStringByStrRef(9066);
        }
        else
        {
            // * cannot modify disabled equipment
            if (GetLocalInt(oCharacter, "X2_JUST_A_DISABLEEQUIP") == FALSE)
            {
                OpenInventory(oCharacter, oShouter);
            }
            else
            {
                // * feedback as to why
                SendMessageToPCByStrRef(oMaster, 100895);
            }

        }

        break;

    case ASSOCIATE_COMMAND_PICKLOCK:
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_PICKLOCK command." );
        SCManualPickNearestLock();
        break;

    case ASSOCIATE_COMMAND_DISARMTRAP: // Disarm trap
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_DISARMTRAP command." );
        SCAttemptToDisarmTrap(GetNearestTrapToObject(oMaster), TRUE);
        break;

    case ASSOCIATE_COMMAND_ATTACKNEAREST:
		// Familiars are not combat oriented and won't respond to Attack Nearest shouts.
		if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
			break;
	
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_ATTACKNEAREST command." );
		// BMA-OEI 9/13/06: Clear player queued preferred target
		SCSetPlayerQueuedTarget( oCharacter, OBJECT_INVALID );
        SCResetHenchmenState();
        CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, FALSE);
        CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE);
        SCAIDetermineCombatRound();

        // * bonus feature. If master is attacking a door or container, issues VWE Attack Nearest
        // * will make henchman join in on the fun
        oTarget = GetAttackTarget(oMaster);
        if (GetIsObjectValid(oTarget) == TRUE)
        {
            if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE || GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
            {
                ActionAttack(oTarget);
            }
        }
        break;

    case ASSOCIATE_COMMAND_FOLLOWMASTER:
		// BMA-OEI 9/13/06: Clear player queued preferred target
		SCSetPlayerQueuedTarget( oCharacter, OBJECT_INVALID );
        SCResetHenchmenState();
        CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE);
        DelayCommand(HENCH_BK_VOICE_RESPOND_DELAY, SCVoiceCanDo());

        
        ActionForceFollowObject(oMaster, CSLGetFollowDistance());
        CSLSetAssociateState(CSL_ASC_IS_BUSY);
        DelayCommand(HENCH_BK_FOLLOW_BUSY_DELAY, CSLSetAssociateState(CSL_ASC_IS_BUSY, FALSE));
        break;

    case ASSOCIATE_COMMAND_GUARDMASTER:
    {
		// Familiars are not combat oriented and won't respond to Guard Me shouts.
		if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
			break;
	
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_GUARDMASTER command." );
		// BMA-OEI 9/13/06: Clear player queued preferred target
		SCSetPlayerQueuedTarget( oCharacter, OBJECT_INVALID );
        SCResetHenchmenState();
        //DelayCommand(HENCH_BK_VOICE_RESPOND_DELAY, SC VoiceCannotDo());

        //Companions will only attack the Masters Last Attacker
        CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER);
        CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE);
        object oLastAttackerOfMaster = GetLastHostileActor(oMaster);
        // * for some reason this is too often invalid. still the routine
        // * works corrrectly
        SetLocalInt(oCharacter, "X0_BATTLEJOINEDMASTER", TRUE);
        //SC HenchmenCombatRound(oLastAttackerOfMaster);
        SCAICombatRound( oLastAttackerOfMaster ); // SC HenchmenCombatRound() should pick a more appropriate target.
        break;
    }
    case ASSOCIATE_COMMAND_HEALMASTER:
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_HEALMASTER command." );
        //Ignore current healing settings and heal me now

		// BMA-OEI 9/13/06: Clear player queued preferred target
		SCSetPlayerQueuedTarget( oCharacter, OBJECT_INVALID );
        SCResetHenchmenState();
        //SetCommandable(TRUE);
        if(SCTalentCureCondition())
        {
            DelayCommand(HENCH_BK_VOICE_RESPOND_DELAY, SCVoiceCanDo());
            return;
        }

        if(SCTalentHeal(TRUE, oMaster))
        {
            DelayCommand(HENCH_BK_VOICE_RESPOND_DELAY, SCVoiceCanDo());
            return;
        }

        DelayCommand(HENCH_BK_VOICE_RESPOND_DELAY, SCVoiceCannotDo());
        break;

    case ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK:
        //Check local for re-try locked doors
        if((!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND))
           && CSLGetAssociateState(CSL_ASC_RETRY_OPEN_LOCKS) && (!CSLGetAssociateState(CSL_ASC_MODE_PUPPET)))	//DBR 8/03/06 If I am a puppet. I put nothing on the ActionQueue myself.
           {
            oLastObject = SCGetLockedObject(oMaster);
            SCAttemptToOpenLock(oLastObject);
        }
        break;


    case ASSOCIATE_COMMAND_STANDGROUND:
		//PrettyDebug( GetName(oCharacter) + " has received an ASSOCIATE_COMMAND_STANDGROUND command." );
        //No longer follow the master or guard him
		// BMA-OEI 9/13/06: Clear player queued preferred target
		SCSetPlayerQueuedTarget( oCharacter, OBJECT_INVALID );
        CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND);
        CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, FALSE);
        DelayCommand(HENCH_BK_VOICE_RESPOND_DELAY, SCVoiceCanDo());
        ActionAttack(OBJECT_INVALID);
        ClearAllActions();
        break;



        // ***********************************
        // * AUTOMATIC SHOUTS - not player
        // *   initiated
        // ***********************************
    case ASSOCIATE_COMMAND_MASTERSAWTRAP:
		//DBR 8/03/06 If I am a puppet. I put nothing on the ActionQueue myself.
		if (CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
			break;
			
        if(!GetIsInCombat())
        {
            if (!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND))	

            {
                oTrap = GetLastTrapDetected(oMaster);
                SCAttemptToDisarmTrap(oTrap);
            }
        }
        break;

    case ASSOCIATE_COMMAND_MASTERUNDERATTACK:
		// Familiars are not combat oriented and won't respond to this shout.
		if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
			break;
			
		//If I am a puppet. I put nothing on the ActionQueue myself.
		if (CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
			break;
	
        // * July 15, 2003: Make this only happen if not
        // * in combat, otherwise the henchman will
        // * ping pong between targets
		
		// BMA-OEI 7/08/06 -- Preserve action queue unless set to defend master
		if ( GetIsInCombat(oCharacter) == FALSE )
		{
			if ( CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER) == TRUE )
			{
				SCAICombatRound( GetLastHostileActor(oMaster) );
			}
			else if ( ( CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) == FALSE ) &&
						( GetNumActions(oCharacter) == 0 ) )
			{
				SCAICombatRound( GetLastHostileActor(oMaster) );
			}
		}
        break;

    case ASSOCIATE_COMMAND_MASTERATTACKEDOTHER:
		// Familiars are not combat oriented and won't respond to this shout.
		if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
			break;	
	
		//If I am a puppet. I put nothing on the ActionQueue myself.
		if (CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
			break;
	
		// BMA-OEI 7/08/06 -- Preserve action queue unless set to defend master
		if ( (GetIsInCombat(oCharacter) == FALSE)  && (GetCurrentAction() != ACTION_CASTSPELL))
		{
			if ( CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER) == TRUE )
			{ 
				//ClearAllActions();
				SCAICombatRound( GetAttackTarget(oMaster) );
			}
			else if ( ( CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) == FALSE ) &&
						( GetNumActions(oCharacter) == 0 ) )
			{
				SCAICombatRound( GetAttackTarget(oMaster) );
			}
		}		
        break;

    case ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED:
		// Familiars are not combat oriented and won't respond to this shout.
		if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
			break;	
	
		//If I am a puppet. I put nothing on the ActionQueue myself.
		if (CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
			break;
	
        if(!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND))
        {
            if(!GetIsInCombat(oCharacter) && (GetCurrentAction() != ACTION_CASTSPELL))
            {   // SpeakString("here 753");
                object oAttacker = GetGoingToBeAttackedBy(GetMaster());
                // April 2003: If my master can see the enemy, then I can too.
                // Potential Side effect : Henchmen may run
                // to stupid places, trying to get an enemy
                if(GetIsObjectValid(oAttacker) && GetObjectSeen(oAttacker, GetMaster()))
                {
                   // SpeakString("Defending Master");
                    //ClearAllActions();
                    //ActionMoveToObject(oAttacker, TRUE, 7.0);
                    SCAICombatRound(oAttacker);

                }
            }
        }

	/*			
		// BMA-OEI 7/08/06 -- Preserve action queue unless set to defend master
		if ( GetIsInCombat(oCharacter) == FALSE )
		{
			if ( SC GetAssociateState(CSL_ASC_MODE_DEFEND_MASTER) == TRUE )
			{
				SC HenchmenCombatRound( GetGoingToBeAttackedBy(oMaster) );
			}
			else if ( ( SC GetAssociateState(CSL_ASC_MODE_STAND_GROUND) == FALSE ) &&
						( GetNumActions(oCharacter) == 0 ) )
			{
				SC HenchmenCombatRound( GetGoingToBeAttackedBy(oMaster) );
			}
		}
	*/		
        break;

    case ASSOCIATE_COMMAND_LEAVEPARTY:
        {
            string sTag = GetTag(GetArea(oMaster));
            // * henchman cannot be kicked out in the reaper realm
            // * Followers can never be kicked out
            if (sTag == "GatesofCania" || SCGetIsFollower(oCharacter) == TRUE)
                return;

            if(GetIsObjectValid(oMaster))
            {
                ClearAllActions();
                if(GetAssociateType(oCharacter) == ASSOCIATE_TYPE_HENCHMAN)
                {
                    SCAIFireHenchman(oMaster, oCharacter);
                }
            }
            break;
        }
    }

}


//    This function is the master function for the
//    generic include and is called from the main
//    script.  This function is used in lieu of
//    any actual scripting.
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
void SCAIDetermineCombatRound(object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAIDetermineCombatRound Start", GetFirstPC() ); }
	
	//MyPrintString("************** DETERMINE COMBAT ROUND START *************");
    //MyPrintString("**************  " + GetTag(oCharacter) + "  ************");

    // Abort out of here, if petrified
    if (CSLGetHasEffectType(oCharacter,EFFECT_TYPE_PETRIFY) == TRUE)
    {
        return;
    }

    // Fix for ActionRandomWalk blocking the action queue under certain circumstances
    if (GetCurrentAction() == ACTION_RANDOMWALK)
    {
        ClearAllActions();
    }

    // ----------------------------------------------------------------------------------------
    // July 27/2003 - Georg Zoeller,
    // Added to allow a replacement for determine combat round
    // If a creature has a local string variable named X2_SPECIAL_COMBAT_AI_SCRIPT
    // set, the script name specified in the variable gets run instead
    // see x2_ai_behold for details:
    // ----------------------------------------------------------------------------------------
    string sSpecialAI = GetLocalString(oCharacter, "X2_SPECIAL_COMBAT_AI_SCRIPT");
    if (sSpecialAI != "")
    {
        SetLocalObject(oCharacter, "X2_NW_I0_GENERIC_INTRUDER", oIntruder);
        ExecuteScript(sSpecialAI, oCharacter);
        if (GetLocalInt(oCharacter, "X2_SPECIAL_COMBAT_AI_SCRIPT_OK"))
        {
            DeleteLocalInt(oCharacter, "X2_SPECIAL_COMBAT_AI_SCRIPT_OK");
            return;
        }
    }


    // ----------------------------------------------------------------------------------------
    // SC DetermineCombatRound: EVALUATIONS
    // ----------------------------------------------------------------------------------------
    if(CSLGetAssociateState(CSL_ASC_IS_BUSY))
    {
        return;
    }

    if(SCBashDoorCheck(oIntruder)) {return;}

	if (GetObjectType(oIntruder)==OBJECT_TYPE_TRIGGER) //Don't try to attack trigger. You will be unable to.
		oIntruder = OBJECT_INVALID;
	if ((GetObjectType(oIntruder)==OBJECT_TYPE_PLACEABLE) && (!GetUseableFlag(oIntruder))) //Don't try to attack non-usable placeables. You will be unable to.
		oIntruder = OBJECT_INVALID;
	
    // ----------------------------------------------------------------------------------------
    // BK: stop fighting if something bizarre that shouldn't happen, happens
    // ----------------------------------------------------------------------------------------
    if (SCEvaluationSanityCheck(oIntruder, CSLGetFollowDistance()) == TRUE)
        return;

    // ** Store How Difficult the combat is for this round
    int nDiff = SCGetCombatDifficulty();
    SetLocalInt(oCharacter, "NW_L_COMBATDIFF", nDiff);

    // MyPrintString("COMBAT: " + IntToString(nDiff));

    // ----------------------------------------------------------------------------------------
    // If no special target has been passed into the function
    // then choose an appropriate target
    // ----------------------------------------------------------------------------------------
	if (GetIsObjectValid(oIntruder) == FALSE)
        oIntruder = SCAcquireTarget();

	// ----------------------------------------------------------------------------------------
	// 7/29/05 -- EPF, OEI
	// Due to the many, many plot-related cutscenes, we have decided to prevent anyone in the 
	// PC faction from being attacked while they are in conversation.  Eventually, this should
	// probably include a check to see if the conversation itself is a plot cutscene, but for
	// now that flag is NYI.  Effectively, this is just a "pause" on combat until the
	// conversation ends.  Then the PC party is fair game.
	// 5/30/06 -- DBR, OEI
	// Flag is IN! SC GetIsInCutscene() now only checks for multiplayer flagged cutscenes.
	// ----------------------------------------------------------------------------------------
	if(SCGetIsInCutscene(oIntruder))
	{
		PrintString("SC DetermineCombatRound(): In cutscene.  Aborting function.");
		ClearAllActions(TRUE);
		ActionWait(3.f);
		ActionDoCommand(SCAIDetermineCombatRound());
		return;
	}
	
    // If for some reason my target is dead, then leave
    // the poor guy alone. Jeez. What kind of monster am I?
    if (GetIsDead(oIntruder) == TRUE)
    {
        return;
    }

    // ----------------------------------------------------------------------------------------
    //   JULY 11 2003
    //   If in combat round already (variable set) do not enter it again.
    //   This is meant to prevent multiple calls to SC DetermineCombatRound
    //   from happening during the *same* round.
	//
    //   This variable is turned on at the start of this function call.
    //   It is turned off at each "return" point for this function
    // ----------------------------------------------------------------------------------------
    if (__SCInCombatRound() == TRUE)
    {
        return;
    }

    __SCTurnCombatRoundOn(TRUE);

    // ----------------------------------------------------------------------------------------
    // SC DetermineCombatRound: ACTIONS
    // ----------------------------------------------------------------------------------------
    if(GetIsObjectValid(oIntruder))
    {

        if(SCTalentPersistentAbilities()) // * Will put up things like Auras quickly
        {
            __SCTurnCombatRoundOn(FALSE);
            return;
        }

        // If a succesful tactic has been chosen then exit this function directly
        if (SCChooseTactics(oIntruder) == 99)
        {
            __SCTurnCombatRoundOn(FALSE);
            return;
        }

        // This check is to make sure that people do not drop out of
        // combat before they are supposed to.
        object oNearEnemy = CSLGetNearestSeenEnemy();
        SCAIDetermineCombatRound(oNearEnemy);

        return;
    }
     __SCTurnCombatRoundOn(FALSE);

    // ----------------------------------------------------------------------------------------
    // This is a call to the function which determines which
    // way point to go back to.
    // ----------------------------------------------------------------------------------------
    ClearAllActions();
    SetLocalObject(oCharacter, "NW_GENERIC_LAST_ATTACK_TARGET", OBJECT_INVALID);
    SCWalkWayPoints();
}


//::///////////////////////////////////////////////
//:: SC GetBehavior
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Set/get functions for CONTROL PANEL behavior
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int SCGetBehavior(int nBehavior, object oCharacter = OBJECT_SELF )
{
    return GetLocalInt(oCharacter, "NW_L_BEHAVIOR" + IntToString(nBehavior));
}



//::///////////////////////////////////////////////
//:: SC CombatAttemptHeal
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Attempt to heal self and then master
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int SCCombatAttemptHeal(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCombatAttemptHeal Start", GetFirstPC() ); }
    
    // * if master is disabled then attempt to free master
    object oMaster = CSLGetCurrentMaster();


    // *turn into a match function...
    if (SCMatchDoIHaveAMindAffectingSpellOnMe(oMaster)) {
        //int nSpellToUse = -1;

        if (GetHasSpell(SPELL_DISPEL_MAGIC, oCharacter) && !GetLocalInt(oCharacter, "X2_HENCH_DO_NOT_DISPEL")	)
        {
            ClearAllActions();
            ActionCastSpellAtLocation(SPELL_DISPEL_MAGIC, GetLocation(oMaster));
            return TRUE;
        }
    }

    int iHealMelee = TRUE;
    if (SCGetBehavior(HENCH_BK_HEALINMELEE) == FALSE)
        iHealMelee = FALSE;


    object oNearestEnemy = CSLGetNearestSeenEnemy();

    float fDistance = 0.0;
    if (GetIsObjectValid(oNearestEnemy)) {
        fDistance = GetDistanceToObject(oNearestEnemy);
    }

    int iHP = SCGetPercentageHPLoss(oCharacter);

    // if less than 10% hitpoints then pretend that I am allowed
    // to heal in melee. Things are getting desperate
    if (iHP < 10)
     iHealMelee = TRUE;

    int iAmFamiliar = (GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oMaster) == oCharacter);

    // * must be out of Melee range or ALLOWED to heal in melee
    if (fDistance > HENCH_BK_HEALTHRESHOLD || iHealMelee) {
        int iAmHenchman = GetAssociateType(oCharacter) == ASSOCIATE_TYPE_HENCHMAN;
        int iAmCompanion = (GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION,oMaster) == oCharacter);
        int iAmSummoned = (GetAssociate(ASSOCIATE_TYPE_SUMMONED,oMaster) == oCharacter);

        // Condition for immediate self-healing
        // Hit-point at less than 50% and random chance
        if (iHP < 50) {
            // verbalize
            if (iAmHenchman || iAmFamiliar) {
                // * when hit points less than 10% will whine about
                // * being near death
                if (iHP < 10 && Random(5) == 0)
                    SCVoiceNearDeath();
            }

            // attempt healing
            if (d100() > iHP-20) {
                ClearAllActions();
                if (SCTalentHealingSelf()) return TRUE;
                if (iAmHenchman || iAmFamiliar)
                    if (Random(100) > 80) SCVoiceHealMe();
            }
        }

        // ********************************
        // Heal master if needed.
        // ********************************

        if (SCGetAssociateHealMaster( oCharacter ))
        {
            if (SCTalentHeal( FALSE, oCharacter))
            {
                return TRUE;
            }
            else
            {
                return FALSE;
            }
        }
    }

    // * No healing done, continue with combat round
    return FALSE;
}

// Set Behavior on object oSelf
// oSelf - object to be acted upon
// iStrRef - str ref of the description
void SCSetBehaviorOnObject(object oSelf, int iStrRef)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetBehaviorOnObject Start", GetFirstPC() ); }
	
	//object oSelf = GetControlledCharacter(oCharacter);
	
	//CSLMessage_PrettyMessage("SC SetBehaviorOnObject: " + GetName(oSelf) + " iStrRef=" + IntToString(iStrRef) );

	switch (iStrRef)
	{
		case STR_REF_BEHAVIOR_FOLLOWDIST_NEAR:
		case STR_REF_BEHAVIOR_FOLLOWDIST_MED:
		case STR_REF_BEHAVIOR_FOLLOWDIST_FAR:
			CSLSetAssociateState( CSL_ASC_DISTANCE_2_METERS, (iStrRef==STR_REF_BEHAVIOR_FOLLOWDIST_NEAR), oSelf ); 
			CSLSetAssociateState( CSL_ASC_DISTANCE_4_METERS, (iStrRef==STR_REF_BEHAVIOR_FOLLOWDIST_MED), oSelf );
			CSLSetAssociateState( CSL_ASC_DISTANCE_6_METERS, (iStrRef==STR_REF_BEHAVIOR_FOLLOWDIST_FAR), oSelf );
			break;
	
		case STR_REF_BEHAVIOR_DEF_MASTER_ON:
			CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, TRUE, oSelf);
			break;

		case STR_REF_BEHAVIOR_DEF_MASTER_OFF:
			CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, FALSE, oSelf);
			break;

		case STR_REF_BEHAVIOR_RETRY_LOCKS_ON:
			CSLSetAssociateState(CSL_ASC_RETRY_OPEN_LOCKS, TRUE, oSelf);
			break;
			
		case STR_REF_BEHAVIOR_RETRY_LOCKS_OFF:	
			CSLSetAssociateState(CSL_ASC_RETRY_OPEN_LOCKS, FALSE, oSelf);
			break;
	
		case STR_REF_BEHAVIOR_STEALTH_MODE_NONE:
			//ClearAllActions();
			SetLocalInt(oSelf, "X2_HENCH_STEALTH_MODE", 0);
    		SetActionMode(oSelf, ACTION_MODE_STEALTH, FALSE);
			break;
	
		case STR_REF_BEHAVIOR_STEALTH_MODE_PERM:
			ClearAllActions();
			SetLocalInt(oSelf, "X2_HENCH_STEALTH_MODE", 1);
			DelayCommand(1.0, SetActionMode(oSelf, ACTION_MODE_STEALTH, TRUE));
			break;
	
		case STR_REF_BEHAVIOR_STEALTH_MODE_TEMP:
			ClearAllActions();
			SetLocalInt(oSelf, "X2_HENCH_STEALTH_MODE", 2);
			DelayCommand(1.0, SetActionMode(oSelf, ACTION_MODE_STEALTH, TRUE));
			break;
	
		case STR_REF_BEHAVIOR_DISARM_TRAPS_ON:
			//CSLMessage_PrettyMessage("SC SetBehavior: STR_REF_BEHAVIOR_DISARM_TRAPS_ON");
			CSLSetAssociateState(CSL_ASC_DISARM_TRAPS, TRUE, oSelf);
			break;

		case STR_REF_BEHAVIOR_DISARM_TRAPS_OFF:
			//CSLMessage_PrettyMessage("SC SetBehavior: STR_REF_BEHAVIOR_DISARM_TRAPS_OFF");
			CSLSetAssociateState(CSL_ASC_DISARM_TRAPS, FALSE, oSelf);
			break;
	
	
		case STR_REF_BEHAVIOR_DISPEL_ON:
			SetLocalInt(oSelf, "X2_HENCH_DO_NOT_DISPEL", FALSE);
			break;

		case STR_REF_BEHAVIOR_DISPEL_OFF:
			SetLocalInt(oSelf, "X2_HENCH_DO_NOT_DISPEL", TRUE);
			break;
	
		case STR_REF_BEHAVIOR_CASTING_OFF:
			//CSLMessage_PrettyMessage("SC SetBehavior: STR_REF_BEHAVIOR_CASTING_OFF");
			SetLocalInt(oSelf, "X2_L_STOPCASTING", 10);  // casting off is 10 for this
			break;

		case STR_REF_BEHAVIOR_CASTING_OVERKILL:
			//CSLMessage_PrettyMessage("SC SetBehavior: STR_REF_BEHAVIOR_CASTING_OVERKILL");

			SetLocalInt(oSelf, "X2_L_STOPCASTING", 0);
			CSLSetAssociateState(CSL_ASC_OVERKIll_CASTING, TRUE, oSelf);
			CSLSetAssociateState(CSL_ASC_POWER_CASTING, FALSE, oSelf);
			CSLSetAssociateState(CSL_ASC_SCALED_CASTING, FALSE, oSelf);
			break;

		case STR_REF_BEHAVIOR_CASTING_POWER:
			//CSLMessage_PrettyMessage("SC SetBehavior: STR_REF_BEHAVIOR_CASTING_POWER");
			SetLocalInt(oSelf, "X2_L_STOPCASTING", 0); // casting on is 0 for this
			CSLSetAssociateState(CSL_ASC_OVERKIll_CASTING, FALSE, oSelf);
			CSLSetAssociateState(CSL_ASC_POWER_CASTING, TRUE, oSelf);
			CSLSetAssociateState(CSL_ASC_SCALED_CASTING, FALSE, oSelf);			
			break;

		case STR_REF_BEHAVIOR_CASTING_SCALED: 
			//CSLMessage_PrettyMessage("SC SetBehavior: STR_REF_BEHAVIOR_CASTING_SCALED");
			SetLocalInt(oSelf, "X2_L_STOPCASTING", 0);
			CSLSetAssociateState(CSL_ASC_OVERKIll_CASTING, FALSE, oSelf);
			CSLSetAssociateState(CSL_ASC_POWER_CASTING, FALSE, oSelf);
			CSLSetAssociateState(CSL_ASC_SCALED_CASTING, TRUE, oSelf);			
			break;
			
		// to use items we set item exclusion to false			
		case STR_REF_BEHAVIOR_ITEM_USE_ON:
			CSLSetLocalIntBitState(oSelf, "N2_TALENT_EXCLUDE", TALENT_EXCLUDE_ITEM, FALSE);
			break;
			
		// to not use items we set item exclusion to true			
		case STR_REF_BEHAVIOR_ITEM_USE_OFF:
			CSLSetLocalIntBitState(oSelf, "N2_TALENT_EXCLUDE", TALENT_EXCLUDE_ITEM, TRUE);
			break;

		// to use abilities (feats, skills, and special abilities) we set ability exclusion to false			
		case STR_REF_BEHAVIOR_FEAT_USE_ON:
			CSLSetLocalIntBitState(oSelf, "N2_TALENT_EXCLUDE", TALENT_EXCLUDE_ABILITY, FALSE);
			break;
			
		// to not use abilities we set ability exclusion to true			
		case STR_REF_BEHAVIOR_FEAT_USE_OFF:
			CSLSetLocalIntBitState(oSelf, "N2_TALENT_EXCLUDE", TALENT_EXCLUDE_ABILITY, TRUE);
			break;

		case STR_REF_BEHAVIOR_PUPPET_ON:
			//CSLMessage_PrettyMessage("SC SetBehavior: STR_REF_BEHAVIOR_PUPPET_ON");
			
			if(GetCurrentAction() == ACTION_FOLLOW || GetCurrentAction() == ACTION_WAIT)
				ClearAllActions();
			
			CSLSetAssociateState(CSL_ASC_MODE_PUPPET, TRUE, oSelf);
			break;

		case STR_REF_BEHAVIOR_PUPPET_OFF:
			//CSLMessage_PrettyMessage("SC SetBehavior: STR_REF_BEHAVIOR_PUPPET_OFF");
			CSLSetAssociateState(CSL_ASC_MODE_PUPPET, FALSE, oSelf);
			break;
		
		case STR_REF_BEHAVIOR_COMBAT_MODE_USE_ON:
			SetLocalInt(oSelf, "N2_COMBAT_MODE_USE_DISABLED", FALSE);
			break;
		
		case STR_REF_BEHAVIOR_COMBAT_MODE_USE_OFF:
			SetLocalInt(oSelf, "N2_COMBAT_MODE_USE_DISABLED", TRUE);
			break;

		default:	
			//PrettyError( "gui_bhvr_inc: Behavior " + IntToString( iStrRef ) + " definition does not exist." );
			break;														
	}		
}



// 0 = off
// 1 = on
int SCGetObjectPuppetMode(object oTarget)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetObjectPuppetMode Start "+GetName(oTarget), GetFirstPC() ); }
	
	// Puppet Mode
	int iState = CSLGetAssociateState(CSL_ASC_MODE_PUPPET, oTarget);
	//CSLMessage_PrettyMessage("SC GuiBehaviorInit(): iState for " + GetName(oSelf) + " (Puppet Mode)=" + IntToString(iState));
	//SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_PUPPET_ON, (iState) );
	//SetGUIObjectDisabled(oPlayerObject, sScreen, BEHAVIOR_PUPPET_OFF, (!iState));
	return (iState);
}



// 0 = ALL Puppet Mode off
// 1 = All Puppet Mode on
// 2 = Some on, Some off
int SCGetObjectPuppetModeAll(object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGetObjectPuppetModeAll Start", GetFirstPC() ); }
	
	int nRet;
	object oPC = oCharacter;
	//CSLMessage_PrettyMessage("oCharacter = " + GetName(oCharacter));
	// object oOwnedChar = GetOwnedCharacter(oPC); // oCharacter is the owned char, and this function will return ""
	int i = 0;
	//CSLMessage_PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
	int nPuppetMode = 0;
    // We stop when there are no more valid PC's in the party.
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		//CSLMessage_PrettyMessage("SC SetBehaviorAll: Party char # " + IntToString(i) + " = " + GetName(oPartyMember));
 		if (GetIsRosterMember(oPartyMember) || (oPartyMember == oPC))
		{
			i++;
			if (SCGetObjectPuppetMode(oPartyMember)!=FALSE)
				nPuppetMode++;
		}
        oPartyMember = GetNextFactionMember(oPC, FALSE);
    }
	//PrettyDebug("Total party members:" + IntToString(i));
	//PrettyDebug("Num party members in puppet mode:" + IntToString(nPuppetMode));
	if (nPuppetMode == i)
		nRet = 1;
	else if (nPuppetMode == 0)		
		nRet = 0;
	else
		nRet = 2;
		
	return (nRet);				
}



// set up the AI MODE GUI with info
// oPlayerObject - the player object who's looking at the GUI
// sScreen - The GUI screen being looked at.
void SCGuiAIModeInit(object oPlayerObject)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGuiAIModeInit Start", GetFirstPC() ); }
	
	int nAllPuppetMode = SCGetObjectPuppetModeAll();
	
	// this only allows changing of main image and not hover
	//SetGUITexture(oPC, "SCREEN_PLAYERMENU", GUI_PLAYERMENU_CLOCK_BUTTON, sImage);
	//PrettyDebug("nAllPuppetMode = " + IntToString(nAllPuppetMode));
	SetGUIObjectHidden(oPlayerObject, "SCREEN_PLAYERMENU", "AI_OFF_BUTTON", nAllPuppetMode!=1);
	SetGUIObjectHidden(oPlayerObject, "SCREEN_PLAYERMENU", "AI_ON_BUTTON", nAllPuppetMode!=0);
	SetGUIObjectHidden(oPlayerObject, "SCREEN_PLAYERMENU", "AI_MIXED_BUTTON", nAllPuppetMode!=2);

}


// set up the Behavior Panel GUI with all the info for the selectable states
// oPlayerObject - the player object who's looking at the GUI
// oTargetObject - the object who's information is being displayed in the GUI
// sScreen - The GUI screen being looked at.
void SCGuiBehaviorInit(object oPlayerObject, object oTargetObject, string sScreen)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCGuiBehaviorInit Start", GetFirstPC() ); }
	
	SCGuiAIModeInit(oPlayerObject);

	int iState;
	//object oSelf = GetControlledCharacter(oCharacter);

	//CSLMessage_PrettyMessage("gui_bhvr_update: oSelf=" + GetName(oTargetObject) + " sScreen=" + sScreen);
	
	int	bHideInfluenceDisplay = TRUE;
	
    // influence vars are set in the NX1 campaign scripts - DoInfluenceEffects()
    // in kinc_companions.  This will otherwise be false.
    // DoInfluenceEffects() is called in kb_comp_roster_spawn as well as when a "SC SetInfluence" function is called
	if (GetLocalInt(oTargetObject, "GUI_DisplayInfluence") == TRUE)
	{
		bHideInfluenceDisplay = FALSE;
		int nVarIndex = 1;
        
        // ExecuteScript("gui_store_influence", oTargetObject); // this sets up the next 2 vars.
        int iInfluence = GetLocalInt(oTargetObject, "influence");
        int iInfluenceBandStrRef = GetLocalInt(oTargetObject, "influence_band");
        string sInfluenceBand = GetStringByStrRef(iInfluenceBandStrRef);
        string sVarValue = IntToString(iInfluence) + " - " + sInfluenceBand;
		SetLocalGUIVariable(oPlayerObject, sScreen, nVarIndex, sVarValue);
	}	
	
    string sUIObjectName = "INFLUENCE_CONTAINER";
	//PrettyDebug("Hiding! sScreen=" + sScreen + " : " +
    //            "sUIObjectName = " + sUIObjectName + " : " +
    //            "bHideInfluenceDisplay = " + IntToString(bHideInfluenceDisplay));
                
    //RWT-OEI 02/23/06
    //This function will set a GUI object as hidden or visible on a GUI panel on
    //the client.
    //The panel must be located within the [ScriptGUI] section of the ingamegui.ini
    //in order to let this script function have any effect on it.
    //Also, the panel must be in memory. Which means the panel should probably not have
    //any idle expiration times set in the <UIScene> tag that would cause the panel to
    //unload
    // void SetGUIObjectHidden( object oPlayer, string sScreenName, string sUIObjectName, int bHidden );
    SetGUIObjectHidden(oPlayerObject, sScreen, sUIObjectName, bHideInfluenceDisplay);
		
	// *** Follow Distance
    if ( CSLGetAssociateState( CSL_ASC_DISTANCE_2_METERS, oTargetObject ) )
    {
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_NEAR", TRUE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_MED", FALSE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_FAR", FALSE );
    }
    else if ( CSLGetAssociateState( CSL_ASC_DISTANCE_4_METERS, oTargetObject ) )
    {
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_NEAR", FALSE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_MED", TRUE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_FAR", FALSE );
    }
    else  if ( CSLGetAssociateState( CSL_ASC_DISTANCE_6_METERS, oTargetObject ) )
    {
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_NEAR", FALSE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_MED", FALSE );
		SetGUIObjectDisabled( oPlayerObject, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_FAR", TRUE );
    }
	//iState = 
	//SetGUIObjectDisabled( oSelf, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_NEAR", (iState==CSL_ASC_DISTANCE_2_METERS) );
	//SetGUIObjectDisabled( oSelf, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_MED", (iState==CSL_ASC_DISTANCE_4_METERS) );
	//SetGUIObjectDisabled( oSelf, sScreen, "BEHAVIOR_FOLLOWDIST_STATE_BUTTON_FAR", (iState==CSL_ASC_DISTANCE_6_METERS) );
	
	// defend master mode
	iState = CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, oTargetObject);
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DEF_MASTER_STATE_BUTTON_ON", (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DEF_MASTER_STATE_BUTTON_OFF", (!iState));

	// retry open locks mode					
	iState = CSLGetAssociateState(CSL_ASC_RETRY_OPEN_LOCKS, oTargetObject);
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RETRY_LOCKS_STATE_BUTTON_ON", (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_RETRY_LOCKS_STATE_BUTTON_OFF", (!iState));
	
	// stealthy mode
	iState = GetLocalInt(oTargetObject, "X2_HENCH_STEALTH_MODE");
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_NONE", (iState==0) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_PERM", (iState==1));
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_STEALTH_MODE_STATE_BUTTON_TEMP", (iState==2));

	// Disarm traps
	iState = CSLGetAssociateState(CSL_ASC_DISARM_TRAPS, oTargetObject);
	//CSLMessage_PrettyMessage("SC GuiBehaviorInit(): iState =" + IntToString(iState));
	
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISARM_STATE_BUTTON_ON", (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISARM_STATE_BUTTON_OFF", (!iState));

	// Displel mode
	iState = (GetLocalInt(oTargetObject, "X2_HENCH_DO_NOT_DISPEL") == FALSE);
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISPEL_STATE_BUTTON_ON", (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_DISPEL_STATE_BUTTON_OFF", (!iState));

	// Casting mode 
	iState = (GetLocalInt(oTargetObject, "X2_L_STOPCASTING") == 0);
	//SetGUIObjectDisabled(oSelf, sScreen, BEHAVIOR_CASTING_ON, (iState) );
	//SetGUIObjectDisabled(oSelf, sScreen, BEHAVIOR_CASTING_OFF, (!iState));
	//CSLMessage_PrettyMessage("SC GuiBehaviorInit(): iState =" + IntToString(iState));
	
	if (iState == FALSE)
	{
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_CASTING_STATE_BUTTON_OVERKILL", FALSE );
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_CASTING_STATE_BUTTON_POWER", FALSE );
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_CASTING_STATE_BUTTON_SCALED", FALSE );
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_CASTING_STATE_BUTTON_OFF", TRUE);
	}
	else
	{
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_CASTING_STATE_BUTTON_OVERKILL", CSLGetAssociateState( CSL_ASC_OVERKIll_CASTING, oTargetObject ) );
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_CASTING_STATE_BUTTON_POWER", CSLGetAssociateState( CSL_ASC_POWER_CASTING, oTargetObject ) );
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_CASTING_STATE_BUTTON_SCALED", CSLGetAssociateState( CSL_ASC_SCALED_CASTING, oTargetObject ) );
		SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_CASTING_STATE_BUTTON_OFF", FALSE);
	}

	// Use Items
	//iState = (GetLocalInt(oSelf, "N2_TALENT_EXCLUDE") == 0); // 1st bit is item usage
	iState = (CSLGetLocalIntBitState(oTargetObject, "N2_TALENT_EXCLUDE", TALENT_EXCLUDE_ITEM) == FALSE);
	//CSLMessage_PrettyMessage("SC GuiBehaviorInit(): iState =" + IntToString(iState));
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ITEM_USE_STATE_BUTTON_ON", (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_ITEM_USE_STATE_BUTTON_OFF", (!iState));

	// Use Items
	iState = (CSLGetLocalIntBitState(oTargetObject, "N2_TALENT_EXCLUDE", TALENT_EXCLUDE_ABILITY) == FALSE);
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_FEAT_USE_STATE_BUTTON_ON", (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_FEAT_USE_STATE_BUTTON_OFF", (!iState));

	// Puppet Mode
	iState = CSLGetAssociateState(CSL_ASC_MODE_PUPPET, oTargetObject);
	//CSLMessage_PrettyMessage("SC GuiBehaviorInit(): iState for " + GetName(oSelf) + " (Puppet Mode)=" + IntToString(iState));
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PUPPET_STATE_BUTTON_ON", (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_PUPPET_STATE_BUTTON_OFF", (!iState));
	
	// Use Combat Mode
	iState = (GetLocalInt(oTargetObject, "N2_COMBAT_MODE_USE_DISABLED") == FALSE);
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_COMBAT_MODE_USE_STATE_BUTTON_ON", (iState) );
	SetGUIObjectDisabled(oPlayerObject, sScreen, "BEHAVIOR_COMBAT_MODE_USE_STATE_BUTTON_OFF", (!iState));	
}


//::///////////////////////////////////////////////
//:: SC CombatFollowMaster
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Forces the henchman to follow the player.
    Will even do this in the middle of combat if the
    distance it too great
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int SCCombatFollowMaster(object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCCombatFollowMaster Start", GetFirstPC() ); }
    
    object oMaster = CSLGetCurrentMaster();
    int iAmHenchman = (GetHenchman(oMaster) == oCharacter);
    int iAmFamiliar = (GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oMaster) == oCharacter);

    if(SCGetBehavior(HENCH_BK_CURRENT_AI_MODE) != HENCH_BK_AI_MODE_RUN_AWAY)
    {
        // * double follow threshold if in combat (May 2003)
        float fFollowThreshold = HENCH_BK_FOLLOW_THRESHOLD;
        if (GetIsInCombat(oCharacter) == TRUE)
        {
            fFollowThreshold = HENCH_BK_FOLLOW_THRESHOLD * 2.0;
        }
        if(GetDistanceToObject(oMaster) > fFollowThreshold)
        {
            if(GetCurrentAction(oMaster) != ACTION_FOLLOW)
            {
                ClearAllActions();
                //MyPrintString("*****EXIT on follow master.*******");
                ActionForceFollowObject(oMaster, CSLGetFollowDistance());
				CSLSetAssociateState(CSL_ASC_IS_BUSY);
        		DelayCommand(5.0, CSLSetAssociateState(CSL_ASC_IS_BUSY, FALSE));
                return TRUE;
            }
        }
		else
		{
			if ( GetCurrentAction(oCharacter) == ACTION_FOLLOW )
			{
				ClearAllActions();
			}
		}
    }


//       4. If in 'NEVER FIGHT' mode will not fight but should TELL the player
//      that they are in NEVER FIGHT mode
    if (SCGetBehavior(HENCH_BK_NEVERFIGHT) == TRUE)
    {

    	ClearAllActions();
//    ActionWait(6.0);
//    ActionDoCommand(DelayCommand(5.9, SetCommandable(TRUE)));
//    SetCommandable(FALSE);
        if (d10() > 7)
        {
            if (iAmHenchman || iAmFamiliar)
                SCVoiceLookHere();
        }
    	return TRUE;
    }


    return FALSE;
}


// Mithrates did this
void CombatMoveToLocation(location lDestination, object oMover=OBJECT_SELF)
{
	CSLSetCombatCondition(CSL_FLAG_BUSYMOVING, TRUE, oMover );
	SetLocalLocation(oMover, "MyDestination", lDestination);
	SetLocalInt(oMover, "CombatMovement", 1);
	ExecuteScript("gb_comp_movetolocation",oMover);
}

// Mithrates did this
void CombatMoveTerminate(object oMover=OBJECT_SELF)
{
	CSLSetCombatCondition(CSL_FLAG_BUSYMOVING, FALSE, oMover );
	DeleteLocalLocation(oMover, "MyDestination");
	DeleteLocalInt(oMover, "CombatMovement");
	DeleteLocalInt(oMover, "PerturbationDirection");
}

// Set Behavior on all companions in the party and on this player's controlled character.
void SCSetBehaviorAll(int iStrRef, object oPC = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCSetBehaviorAll Start", GetFirstPC() ); }
	
	//CSLMessage_PrettyMessage("oCharacter = " + GetName(oCharacter));
	// object oOwnedChar = GetOwnedCharacter(oPC); // oCharacter is the owned char, and this function will return ""
	int i = 1;
	//CSLMessage_PrettyMessage("oOwnedChar = " + GetName(oOwnedChar));
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
    // We stop when there are no more valid PC's in the party.
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		//CSLMessage_PrettyMessage("SC SetBehaviorAll: Party char # " + IntToString(i) + " = " + GetName(oPartyMember));
		i++;
 		if (GetIsRosterMember(oPartyMember) || (oPartyMember == oPC))
		{
			SCSetBehaviorOnObject(oPartyMember, iStrRef);
		}
        oPartyMember = GetNextFactionMember(oPC, FALSE);
    }
	
	//SC SetBehavior(iStrRef);
	object oPlayerObject = GetControlledCharacter(oPC);
	object oTargetObject = oPlayerObject;
	string sScreen = "SCREEN_CHARACTER";
	
	SetGUIObjectText(oPlayerObject, sScreen, "BEHAVIORDESC_TEXT", iStrRef, "" );
	SCGuiBehaviorInit(oPlayerObject, oTargetObject, sScreen);
}











void SCAISpellAttack(int saveType, int iTargetInformation, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack Start", GetFirstPC() ); }
	
	// SC HenchCheckIfHighestSpellLevelToCast(100000.0, oCharacter);
	int spellShape = gsCurrentspInfo.shape;
    int checkType = saveType & HENCH_SPELL_SAVE_TYPE_CUSTOM_MASK;
    int bIsBeneficial = (checkType == HENCH_ATTACK_CHECK_HEAL) || (checkType == HENCH_ATTACK_CHECK_NEG_HEALING);

	if (!bIsBeneficial)
	{
		if (spellShape != HENCH_SHAPE_NONE)
		{
			if (giCurNumMaxAreaTest > HENCH_MAX_AREA_TARGET_CHECKS)
			{		
				return;
			}
		}
		else
		{
			if (giCurNumMaxSingleTest > HENCH_MAX_SINGLE_TARGET_CHECKS)
			{		
				return;
			}
		}
	}

	int spellID = gsCurrentspInfo.spellID;
	float spellRange = gsCurrentspInfo.range;
	float spellRadius = gsCurrentspInfo.radius;


	if ( iTargetInformation & HENCH_SPELL_TARGET_PERSISTENT_SPELL)
	{	
		if (spellRange < 0.1)
		{
			if (GetHasSpellEffect(spellID, oCharacter))
			{
				// don't keep repeating some attack spells
				return;
			}
		}
		else
		{
			int persistentSpellStr = GetLocalInt(GetModule(), "HenchPersistSpellID" + IntToString(spellID)) & HENCH_PERSIST_SPELL_LEVEL_MASK;		
			int curLoopCount = 1;
			object oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oCharacter, curLoopCount);
			float fCheckRange = spellRange + spellRadius;
			while (GetIsObjectValid(oAOE) && GetDistanceToObject(oAOE) <= fCheckRange && curLoopCount < 20)
			{
				//DEBUGGING// igDebugLoopCounter += 1;
				object oAOECreator = GetAreaOfEffectCreator(oAOE);		
				if (GetFactionEqual(oAOECreator) || GetIsFriend(oAOECreator))
				{		
					int persistSpellFlags = SCHenchGetAoESpellInfo(oAOE);
					if (persistSpellFlags & HENCH_PERSIST_HARMFUL)
					{
						if ((persistSpellFlags & HENCH_PERSIST_SPELL_LEVEL_MASK) >= persistentSpellStr)
						{
							spellRange = GetDistanceToObject(oAOE) - spellRadius - 1.5;
							if (spellRange < 0.0)
							{
								return;
							}
						}
					}
				}
				curLoopCount++;
				oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT, oCharacter, curLoopCount);
			}			
			
			curLoopCount = 1;
			oAOE = GetNearestObjectByTag("persist_spell_marker", oCharacter, curLoopCount);
			while (GetIsObjectValid(oAOE) && GetDistanceToObject(oAOE) <= fCheckRange && curLoopCount < 20 )
			{
				//DEBUGGING// igDebugLoopCounter += 1;
				object oAOECreator = GetLocalObject(oAOE, "persist_spell_marker");		
				if (GetFactionEqual(oAOECreator) || GetIsFriend(oAOECreator))
				{		
					int persistSpellFlags = GetLocalInt(oAOE, "persist_spell_marker");		
					if (persistSpellFlags & HENCH_PERSIST_HARMFUL)
					{
						if ((persistSpellFlags & HENCH_PERSIST_SPELL_LEVEL_MASK) >= persistentSpellStr)
						{
							spellRange = GetDistanceToObject(oAOE) - spellRadius - 1.5;
							if (spellRange < 0.0)
							{
								return;
							}
						}
					}
				}
				curLoopCount++;
				oAOE = GetNearestObjectByTag("persist_spell_marker", oCharacter, curLoopCount);
			}
		}
		gsCurrentspInfo.castingInfo |= HENCH_CASTING_INFO_PERSISTENT_SPELL_FLAG;	
	}
	
	float effectWeight = SCGetCurrentSpellEffectWeight(); 
	struct sDamageInformation spellDamage;
	int bFoundItemSpell = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG;
	int spellLevel = gsCurrentspInfo.spellLevel;
    int nCasterLevel =  bFoundItemSpell ? (spellLevel * 2) - 1 : giMySpellCasterLevel;
		
	if (iTargetInformation & HENCH_SPELL_TARGET_SCALE_EFFECT)
	{
		effectWeight *= SCGetCurrentSpellBuffAmount(nCasterLevel); 	
		if (spellID == SPELLABILITY_EPIC_CURSE_SONG)
		{
			int bardLevel = giMySpellCasterLevel;
			if (bardLevel >= 8)
			{
				int nPerformCheck = GetSkillRank(SKILL_PERFORM) / 5 + 10;
				if (nPerformCheck < bardLevel)
				{
					bardLevel = nPerformCheck;
				} 
				if (bardLevel >= 16)
				{
					spellDamage.amount = bardLevel * 2.0 - 12.0;
				}
				else if (bardLevel >= 14)
				{
					spellDamage.amount = 16.0;
				}
				else
				{
					spellDamage.amount = 8.0;
				}				
				spellDamage.damageTypeMask = DAMAGE_TYPE_SONIC;
				spellDamage.count = 1;
				spellDamage.damageType1 = DAMAGE_TYPE_SONIC;
				spellDamage.numberOfDamageTypes = 1;
			}	
		}
	}	
	else
	{	
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack calling SCGetCurrentSpellDamage", GetFirstPC() ); }
		spellDamage = SCGetCurrentSpellDamage(nCasterLevel, bFoundItemSpell);
	}
	
	if (bIsBeneficial)
	{
		float spellDamageAmount = spellDamage.amount;
		if (spellShape != HENCH_SHAPE_NONE)
		{
			if (checkType == HENCH_ATTACK_CHECK_HEAL)
			{
				if (spellDamageAmount < gfMinHealAmountArea)
				{
					return;
				}
			}
			else
			{
				if (spellDamageAmount < gfMinHarmAmountArea)
				{
					return;
				}			
			}
		}
		else if (spellRange > 0.0)
		{
			if (checkType == HENCH_ATTACK_CHECK_HEAL)
			{
				if (spellDamageAmount < gfMinHealAmountSingle)
				{
					return;
				}
			}
			else
			{
				if (spellDamageAmount < gfMinHarmAmountSingle)
				{
					return;
				}
			}
		}
		//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack calling SCCheckHealingListInit", GetFirstPC() ); }
		SCCheckHealingListInit();
	}	
	
	int nTargetType = HENCH_ATTACK_TARGET_START;	
    string sTargetList;		
    float testRange;
		
	
	int immunity1 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY1_MASK) >> 6;
	int immunity2 = (saveType & HENCH_SPELL_SAVE_TYPE_IMMUNITY2_MASK) >> 12;
	int immunityMind = saveType & HENCH_SPELL_SAVE_TYPE_MIND_SPELL_FLAG;
	
	int effectTypes = SCGetCurrentSpellEffectTypes();
		
    int bCheckSR = saveType & HENCH_SPELL_SAVE_TYPE_SR_FLAG;
	int bCheckNecromancy = iTargetInformation & HENCH_SPELL_TARGET_NECROMANCY_SPELL;
	int bRegularSpell = iTargetInformation & HENCH_SPELL_TARGET_REGULAR_SPELL;
	int iCheckTouch = saveType &
		(HENCH_SPELL_SAVE_TYPE_TOUCH_MELEE_FLAG | HENCH_SPELL_SAVE_TYPE_TOUCH_RANGE_FLAG);
	int nTouchCheck;
	if (iCheckTouch)
	{
		if (!gbRangedTouchAttackInit)
		{	
			location selfLoc = GetLocation(oCharacter);
			object oTestTarget = GetFirstObjectInShape(SHAPE_SPHERE, 53.0, selfLoc, FALSE, OBJECT_TYPE_CREATURE);
			while (GetIsObjectValid(oTestTarget))
			{
					//DEBUGGING// igDebugLoopCounter += 1;
						// reset flag on nearby creatures
				DeleteLocalInt(oTestTarget, HENCH_RANGED_TOUCH_SAVEINFO);
				oTestTarget = GetNextObjectInShape(SHAPE_SPHERE, 53.0, selfLoc, FALSE, OBJECT_TYPE_CREATURE);
			}
			gbRangedTouchAttackInit = TRUE;
		}
		if (saveType & HENCH_SPELL_SAVE_TYPE_TOUCH_MELEE_FLAG)
		{
			nTouchCheck = giMyMeleeTouchAttack;
			iCheckTouch = HENCH_MELEE_TOUCH_REGULAR;
		}
		else
		{
			nTouchCheck = giMyRangedTouchAttack;
			iCheckTouch = HENCH_RANGED_TOUCH_REGULAR;
		}
		if (gbWarlockMaster && (checkType == HENCH_ATTACK_CHECK_WARLOCK))
		{
			nTouchCheck += 2;
			iCheckTouch *= 2;
		}
		gsRangeSaveStr = HENCH_RANGED_TOUCH_SAVEINFO + IntToString(iCheckTouch);
	}
    int checkFriendly = bIsBeneficial || (saveType & HENCH_SPELL_SAVE_TYPE_CHECK_FRIENDLY_FLAG);

	int nSpellPentetration =  bFoundItemSpell ? nCasterLevel : giMySpellCasterSpellPenetration;
	
	int saveDC = SCGetCurrentSpellSaveDC(bFoundItemSpell, spellLevel);
		
    if (spellShape == HENCH_SHAPE_NONE || spellShape == SHAPE_SPHERE || spellShape == SHAPE_CUBE)
    {
        testRange = spellRange;
    }
    else
    {
        testRange = spellRadius;
    }
		

	// note (testRange < 1.0) - self target spells don't hurt you	
	int bNotSelf = (saveType & HENCH_SPELL_SAVE_TYPE_NOTSELF_FLAG) || ((testRange < 1.0) && !bIsBeneficial);

	int bAllowWeightSave;
	int totalTargetsTested;
	int totalTargetsLimit;
		
	int bDoLoop = iTargetInformation & HENCH_SPELL_TARGET_SHAPE_LOOP;
		
	int firstSaveType = saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_SAVE_MASK;
	int firstSaveKind = saveType & HENCH_SPELL_SAVE_TYPE_SAVES1_KIND_MASK;
	int secondSaveType = saveType & HENCH_SPELL_SAVE_TYPE_SAVES2_SAVE_MASK;
	int secondSaveKind = saveType & HENCH_SPELL_SAVE_TYPE_SAVES2_KIND_MASK;
		
	if ( bDoLoop )
	{
		if (!(iTargetInformation & HENCH_SPELL_TARGET_MISSILE_TARGETS))
		{
			totalTargetsLimit = 12;
			bAllowWeightSave = TRUE;
		
			location selfLoc = GetLocation(oCharacter);
			float testRadius = spellRadius + spellRange;
			object oTestTarget = GetFirstObjectInShape(SHAPE_SPHERE, testRadius, selfLoc, FALSE, OBJECT_TYPE_CREATURE);
			while ( GetIsObjectValid(oTestTarget) )
			{
					//DEBUGGING// igDebugLoopCounter += 1;
					// reset flag on nearby creatures
				SetLocalFloat(oTestTarget, "HENCH_CREATURE_SAVE", HENCH_CREATURE_SAVE_UNKNOWN);
				oTestTarget = GetNextObjectInShape(SHAPE_SPHERE, testRadius, selfLoc, FALSE, OBJECT_TYPE_CREATURE);
			}
		}
		// else only one target for missile (totalTargetsLimit is zero)
	}
	else
	{
		totalTargetsLimit = 6;	
	}
	
    int curLoopCount = 1;
	int iLoopLimit;
		
	object oFinalTarget;
	float fFinalTargetWeight;
	location lFinalLocation;
	int bUseFinalTargetObject;
			
	int bDisableCheckEnemies = gbDisableNonHealorCure || (gbDisableNonUnlimitedOrHealOrCure && !(gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_UNLIMITED_FLAG));
		
	object oCurTarget;
	int iIteration = 0;
    while ( iIteration < 20)
    {
		//DEBUGGING// igDebugLoopCounter += 1;
		iIteration++;
		if (GetIsObjectValid(oCurTarget))
		{
			oCurTarget = GetLocalObject(oCurTarget, sTargetList);
		}	
			if (!GetIsObjectValid(oCurTarget) || (curLoopCount > iLoopLimit))
		{			
			curLoopCount = 1;
			if (nTargetType == HENCH_ATTACK_TARGET_START)
			{		
				if (testRange < 1.0)
				{
					if (bIsBeneficial)
					{
						if (gbDisableNonHealorCure && !bDoLoop && (goOverrideTarget != oCharacter))
						{
							return;
						}				
						if (!bDoLoop)
						{
							if (GetLocalInt(oCharacter, "SC_HEALING_CURRENT_INFO") == HENCH_HEALING_NOTNEEDED)
							{
								return;
							}
						}
					}
					totalTargetsLimit = 0;	// force only one test
					nTargetType = HENCH_ATTACK_TARGET_SELF;
            		oCurTarget = oCharacter;
					}
				else if (bIsBeneficial)
				{
					nTargetType = HENCH_ATTACK_TARGET_ALLIES;
					// set allies up, include self
					
					if (iTargetInformation & HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG)
					{
						sTargetList = "HenchAllyList";
					}
					else
					{
						sTargetList = "HenchAllyLineOfSight";
					}
				
                    iLoopLimit = (bDoLoop || !gbDisableNonHealorCure) ? 3 : 7;
            		
            		oCurTarget = oCharacter;
            		
            		if (bNotSelf)
            		{	
            			oCurTarget = GetLocalObject(oCurTarget, sTargetList);
						if (GetIsObjectValid(oCurTarget))
            			{
            				curLoopCount = 2;
            			}
            			else
            			{
            				nTargetType = HENCH_ATTACK_TARGET_ENEMIES;								
            			}					
            		}
				}
				else
				{
					nTargetType = HENCH_ATTACK_TARGET_ENEMIES;					
				}
			}
			else if (nTargetType == HENCH_ATTACK_TARGET_ALLIES)
			{
				if (bDisableCheckEnemies)
				{				
					break;
				}

				nTargetType = HENCH_ATTACK_TARGET_ENEMIES;
								
				if (spellShape != HENCH_SHAPE_NONE)
				{
					if (giCurNumMaxAreaTest > HENCH_MAX_AREA_TARGET_CHECKS)
					{
                        if (bIsBeneficial)
                        {
                            // allow final check for beneficial spells
                            break;
                        }
						return;
					}
				}
				else
				{
					if (giCurNumMaxSingleTest > HENCH_MAX_SINGLE_TARGET_CHECKS)
					{		
                        if (bIsBeneficial)
                        {
                            // allow final check for beneficial spells
                            break;
                        }
						return;
					}
				}				
			}
			else
			{
				break;
			}
			if (nTargetType == HENCH_ATTACK_TARGET_ENEMIES)
			{
				//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack HENCH_ATTACK_TARGET_ENEMIES", GetFirstPC() ); }
				iLoopLimit = 15;
				if (iTargetInformation & HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG)
				{
					sTargetList = "HenchObjectSeen";
				}
				else
				{
					sTargetList = "HenchLineOfSight";
				}
				oCurTarget = GetLocalObject(oCharacter, sTargetList);
				if (!GetIsObjectValid(oCurTarget))
				{
					break;
				}
			}
		}
		

		if (nTargetType == HENCH_ATTACK_TARGET_ALLIES)
		{		
			//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack HENCH_ATTACK_TARGET_ALLIES", GetFirstPC() ); }
			if (GetLocalInt(oCurTarget, "SC_HEALING_CURRENT_INFO") == HENCH_HEALING_NOTNEEDED)
			{
				continue;
			}
			if (bDoLoop)
			{
				if (gbMeleeAttackers && GetDistanceToObject(oCurTarget) > testRange)
				{
					continue;
				}
			}
			else
			{
				if (gbMeleeAttackers && GetDistanceToObject(oCurTarget) > HENCH_ALLY_MELEE_TOUCH_RANGE)
				{
					continue;
				}
			}			
        	curLoopCount++;			
		}
        else
		{
        	curLoopCount++;	
			if (GetDistanceToObject(oCurTarget) > testRange)
			{
				continue;
			}
		}

        location testTargetLoc;
        int bTargetFound = !gbMeleeAttackers;
				
    	object oTestTarget;
		
		int nCountLimit;
		float fAccumChance;
		
		
		if ( bDoLoop )
		{
			
			testTargetLoc = GetLocation(oCurTarget);
			if (iTargetInformation & HENCH_SPELL_TARGET_SECONDARY_TARGETS)
			{
				//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack HENCH_SPELL_TARGET_SECONDARY_TARGETS", GetFirstPC() ); }
				
				bAllowWeightSave = FALSE;
				oTestTarget = oCurTarget;
				if (gsCurrentspInfo.otherID == SPELL_I_ELDRITCH_CHAIN)
				{
					int nCasterLvl = GetLevelByClass(CLASS_TYPE_WARLOCK);
					if (GetHasFeat(FEAT_FEY_POWER, oCharacter) || GetHasFeat(FEAT_FIENDISH_POWER, oCharacter))
					{
						nCasterLvl ++;
					}
					if (nCasterLvl >= 20)
					{
						nCountLimit = 5;
					}
					else
					{
						nCountLimit = nCasterLvl / 5 + 1;
					}
				}
				else
				{
					nCountLimit = 1000;
				}
			}
			else
			{
				if (iTargetInformation & HENCH_SPELL_TARGET_MISSILE_TARGETS)
				{
					//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack HENCH_SPELL_TARGET_MISSILE_TARGETS", GetFirstPC() ); }
					
					if (spellID == SPELLABILITY_AA_HAIL_OF_ARROWS)
					{
						nCountLimit = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER);
						spellDamage.count = 1;
					}
					else
					{
						nCountLimit = CSLCountEnemies(testTargetLoc);
						if (nCountLimit == 0)
						{
							return;
						}
						if (nCountLimit > spellDamage.count)
						{
							nCountLimit = spellDamage.count;
						}
						if ((nCountLimit == 1) && (spellDamage.count > 10))
						{
							spellDamage.amount = (10 * spellDamage.amount) / spellDamage.count;			
							spellDamage.count = 10;
						}
						else
						{
							spellDamage.amount /= nCountLimit;
							spellDamage.count /= nCountLimit;
						}
					}					
				}
				// Declare the spell shape, size and the location.  Capture the first target object in the shape.
				// note: GetPosition is needed for SHAPE_SPELLCYLINDER
					oTestTarget = GetFirstObjectInShape(spellShape, spellRadius, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCharacter));
			}
		}
		else
		{
			oTestTarget = oCurTarget;
		}
 		float fTotalWeight;
		
		int nShapeLoopCount;
		
       //Cycle through the targets within the spell shape until an invalid object is captured.
       iIteration = 0;
        while ( GetIsObjectValid(oTestTarget) && iIteration < 20 )
        {
			//DEBUGGING// igDebugLoopCounter += 1;
			totalTargetsTested ++;
			iIteration++; // sanity cap
			
			float curTargetWeight;
			int bIsEnemy;
			int bIsFriend;
		
			if (bAllowWeightSave)
            {
                curTargetWeight = GetLocalFloat(oTestTarget, "HENCH_CREATURE_SAVE");
            }
            else
            {
                curTargetWeight = HENCH_CREATURE_SAVE_UNKNOWN;
            }
			
			
			if ( bDoLoop  )
			{
				
				if (iTargetInformation & HENCH_SPELL_TARGET_CHECK_COUNT)
				{
					if ((iTargetInformation & HENCH_SPELL_TARGET_SECONDARY_TARGETS) && (nShapeLoopCount > 0))
					{
						if (oTestTarget != oCurTarget)
						{
							if (GetIsEnemy(oCurTarget) && !GetIsDead(oCurTarget))
							{
								--nCountLimit;
							}
						}
					}
					else if (iTargetInformation & HENCH_SPELL_TARGET_MISSILE_TARGETS)
					{
						if (GetIsEnemy(oCurTarget))
						{
							--nCountLimit;
						}
					}
					else
					{
						--nCountLimit;
					}					
					if (nCountLimit < 0)
					{
						// make sure no more checks
						break;
					}
				}
				if ((curTargetWeight == HENCH_CREATURE_SAVE_UNKNOWN) && ((oCurTarget != oTestTarget) || (oCurTarget == oCharacter)))
				{		
					//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack 1 HENCH_CREATURE_SAVE_UNKNOWN", GetFirstPC() ); }
					
					if (GetIsDead(oTestTarget) || (oTestTarget == oCharacter && bNotSelf) || (!GetObjectSeen(oTestTarget) && !GetObjectHeard(oTestTarget) && oTestTarget != oCharacter))
					{
						curTargetWeight = 0.0;
						SetLocalFloat(oTestTarget, "HENCH_CREATURE_SAVE", curTargetWeight);
					}
					else
					{
						bIsEnemy = GetIsEnemy(oTestTarget);
						bIsFriend = GetFactionEqual(oTestTarget) || GetIsFriend(oTestTarget);
						if ((bIsFriend && !checkFriendly) || (!bIsFriend && !bIsEnemy))
						{
							curTargetWeight = 0.0;
							SetLocalFloat(oTestTarget, "HENCH_CREATURE_SAVE", curTargetWeight);
						}
						else if (bIsFriend && checkFriendly)
						{
							if (GetAssociateType(oTestTarget) == ASSOCIATE_TYPE_DOMINATED)
							{
								if (!bIsBeneficial || (checkType == HENCH_ATTACK_CHECK_HEAL ? GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD : GetRacialType(oTestTarget) != RACIAL_TYPE_UNDEAD))
								{
									// a hostile spell on a dominated creature breaks the domination                        
									curTargetWeight = -1.5 * SCGetThreatRating(oTestTarget,oCharacter);
									SetLocalFloat(oTestTarget, "HENCH_CREATURE_SAVE", curTargetWeight);
								}
							}
						}
					}
				}
			}
							
            if (curTargetWeight == HENCH_CREATURE_SAVE_UNKNOWN)
            {
				//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack 2 HENCH_CREATURE_SAVE_UNKNOWN", GetFirstPC() ); }
				int nTempResult;
  				float fCurChance = 1.0; //  TODO this causes higher level spells to be used when lower
					// level ones will work just as well 0.95 + IntToFloat(Random(11)) / 100.0;				
				int currentSaveDC = saveDC;		// some checks adjust saves
				float currentDamageAmount = spellDamage.amount;
				float currentEffectWeight = effectWeight;
             	int currentFirstSaveType = firstSaveType;
                int currentFirstSaveKind = firstSaveKind;
				int currentEffectTypes = effectTypes;
				int currentCheckSaves = TRUE;
				
				int currentCreatureNegativeEffects = SCGetCreatureNegEffects(oTestTarget);
				if (bIsEnemy && (currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
				{
					currentEffectWeight = 0.0;			
				}
				
				if (iTargetInformation & HENCH_SPELL_TARGET_SECONDARY_TARGETS)
				{
					if (!nShapeLoopCount)
					{
						if (iCheckTouch && (currentFirstSaveType == HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX))
						{
							// remove reflex saves
							currentFirstSaveType = 0;
						}
					}
					else
					{
						// secondary targets 1/2 damage
						if (iTargetInformation & HENCH_SPELL_TARGET_SECONDARY_HALF_DAM)
						{				
							currentDamageAmount /= 2.0;
						}
					}					
				}
				
				//DEBUGGING// if (DEBUGGING >= 5) { CSLDebug(  "SCAISpellAttack switch checkType="+IntToString(checkType), GetFirstPC() ); }
				switch (checkType)
				{
					case HENCH_ATTACK_NO_CHECK:
						break;
					case HENCH_ATTACK_CHECK_HEAL:
						if (GetLocalInt(oTestTarget, "IMMUNE_TO_HEAL"))
						{
							nTempResult = TRUE;
						}
						else
						{
							bIsFriend = GetFactionEqual(oTestTarget) || GetIsFriend(oTestTarget);
							if (GetRacialType(oTestTarget) != RACIAL_TYPE_UNDEAD)
							{
								if (bIsFriend)
								{
									currentCheckSaves = FALSE;	// indicates that this is beneficial
								}
								else
								{
									nTempResult = TRUE;
								}
							}
							else if (!bIsFriend)
							{
								nTempResult = bDisableCheckEnemies;
								fCurChance *= gbHealingAttackWeight;
							}
						}
						break;
					case HENCH_ATTACK_CHECK_NEG_HEALING:
						if (GetLocalInt(oTestTarget, "IMMUNE_TO_HEAL"))
						{
							nTempResult = TRUE;
						}
						else
						{
							bIsFriend = GetFactionEqual(oTestTarget) || GetIsFriend(oTestTarget);
							if (GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD)
							{
								if (bIsFriend)
								{
									currentCheckSaves = FALSE;	// indicates that this is beneficial
								}
								else
								{
									nTempResult = TRUE;
								}
							}
							else if (!bIsFriend)
							{
								nTempResult = bDisableCheckEnemies;
								fCurChance *= gbHarmAttackWeight;
							}
						}
						break;
					case HENCH_ATTACK_CHECK_HUMANOID:
						nTempResult = !CSLGetIsHumanoid(oTestTarget);
						break;
					case HENCH_ATTACK_CHECK_NOT_ALREADY_EFFECTED:
						nTempResult = GetHasSpellEffect(spellID, oTestTarget);
						break;
					case HENCH_ATTACK_CHECK_INCORPOREAL:
						nTempResult = GetCreatureFlag(oTestTarget, CREATURE_VAR_IS_INCORPOREAL);
						break;
	/*                case HENCH_ATTACK_CHECK_DARKNESS:
						nTempResult = oTestTarget == oCharacter ||
								(SC GetCreaturePosEffects(oTestTarget) & (HENCH_EFFECT_TYPE_ULTRAVISION  | HENCH_EFFECT_TYPE_TRUESEEING)) ||
							//  GetHasFeat(FEAT_BLINDSIGHT_60_FEET, oTestTarget) ||
							GetHasFeat(FEAT_BLIND_FIGHT, oTestTarget) ||
							(bIsFriend && (GetHasSpell(SPELL_TRUE_SEEING, oTestTarget) ||
							GetHasSpell(SPELL_BLINDSIGHT, oTestTarget) ||
							GetHasSpell(SPELL_I_DEVILS_SIGHT, oTestTarget)));
						break; */
					case HENCH_ATTACK_CHECK_PETRIFY:
						nTempResult = CSLGetIsImmuneToPetrification(oTestTarget);
						break;
					case HENCH_ATTACK_CHECK_ANIMAL:
						nTempResult = GetRacialType(oTestTarget) != RACIAL_TYPE_ANIMAL &&
							GetRacialType(oTestTarget) != RACIAL_TYPE_BEAST;
						break;
					case HENCH_ATTACK_CHECK_NOT_CONSTRUCT_OR_UNDEAD:
						nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_CONSTRUCT ||
							GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD;
						break;
					case HENCH_ATTACK_CHECK_DROWN:
						nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_CONSTRUCT ||
							GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD ||
							GetRacialType(oTestTarget) == RACIAL_TYPE_ELEMENTAL;
						if (!nTempResult)
						{
							if (spellID == SPELLABILITY_PULSE_DROWN)
							{
								if (GetAssociateType(oCharacter) != ASSOCIATE_TYPE_SUMMONED)
								{
									fTotalWeight -= SCGetRawThreatRating(oCharacter) / 2.0;							
								}
							}
							else if ((spellID == SPELL_DROWN) || (spellID == SPELL_MASS_DROWN) || (spellID == 1174 /* boss drown */))
							{
								currentDamageAmount = 0.9 * IntToFloat(GetCurrentHitPoints(oTestTarget));
								currentDamageAmount = SCGetDamageResistImmunityAdjustment(oTestTarget, currentDamageAmount, DAMAGE_TYPE_BLUDGEONING, 1);
								currentEffectWeight = SCCalculateDamageWeight(currentDamageAmount, oTestTarget);
								currentDamageAmount = 0.0;
							}					
						}
						break;
					case HENCH_ATTACK_CHECK_SLEEP:
						nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_CONSTRUCT ||
							GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD ||
							GetHitDice(oTestTarget) > 5;
						break;
					case HENCH_ATTACK_CHECK_BIGBY:
						if (spellID == SPELL_BIGBYS_INTERPOSING_HAND)
						{					
							nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_INTERPOSING_HAND, oTestTarget);						
						}
						else if (spellID == SPELL_BIGBYS_FORCEFUL_HAND)
						{					
							nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_FORCEFUL_HAND, oTestTarget);						
							if (!nTempResult)
							{					
								fCurChance *= SCCheckGrappleResult(oTestTarget, 14, GRAPPLE_CHECK_RUSH);
							}					
						}
						else if (spellID == SPELL_BIGBYS_GRASPING_HAND)
						{					
							nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget);						
							if (!nTempResult)
							{					
								fCurChance *= SCCheckGrappleResult(oTestTarget, nCasterLevel + CSLGetAbilityScoreByClass(oCharacter) + 10, GRAPPLE_CHECK_HIT | GRAPPLE_CHECK_HOLD);
							}					
						}
						else if (spellID == SPELL_BIGBYS_CLENCHED_FIST)
						{					
							nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget);						
							if (!nTempResult)
							{					
								fCurChance *= SCCheckGrappleResult(oTestTarget, nCasterLevel + CSLGetAbilityScoreByClass(oCharacter) + 11, GRAPPLE_CHECK_HIT);
							}					
						}
						else /* if (spellID == SPELL_BIGBYS_CRUSHING_HAND) */
						{					
							nTempResult = GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTestTarget) || GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTestTarget);						
							if (!nTempResult)
							{					
								fCurChance *= SCCheckGrappleResult(oTestTarget, nCasterLevel + CSLGetAbilityScoreByClass(oCharacter) + 12, GRAPPLE_CHECK_HIT | GRAPPLE_CHECK_HOLD);
							}					
						}
						break;
					case HENCH_ATTACK_CHECK_UNDEAD:
						nTempResult = GetRacialType(oTestTarget) != RACIAL_TYPE_UNDEAD;
						break;
					case HENCH_ATTACK_CHECK_NOT_UNDEAD:
						nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD;
						break;
					case HENCH_ATTACK_CHECK_IMMUNITY_PHANTASMS:
						nTempResult = GetHasFeat(FEAT_IMMUNITY_PHANTASMS, oTestTarget) ||
							GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, oCharacter) ||
							GetIsImmune(oTestTarget, IMMUNITY_TYPE_FEAR, oCharacter);
						if (!nTempResult)
						{
							fCurChance *= SCGetd20ChanceLimited(currentSaveDC - GetWillSavingThrow(oTestTarget) - (bRegularSpell ? GetLocalInt(oTestTarget, "HenchSpellSaveBonus") : 0));
						}
						break;
					case HENCH_ATTACK_CHECK_MAGIC_MISSLE:
						nTempResult = GetHasSpellEffect(SPELL_SHIELD, oTestTarget) ||
							GetHasSpellEffect(SPELL_SHADES_TARGET_CASTER, oTestTarget) ||
							GetHasSpellEffect(SPELL_NIGHTSHIELD, oTestTarget);
						break;
					case HENCH_ATTACK_CHECK_INFERNO_OR_COMBUST:
						nTempResult = GetHasSpellEffect(SPELL_INFERNO, oTestTarget) ||
							GetHasSpellEffect(SPELL_COMBUST, oTestTarget);
						break;
					case HENCH_ATTACK_CHECK_DISMISSAL_OR_BANISHMENT:
						{
							int bBanish = spellID == SPELL_BANISHMENT;
	
							int nAssocType = GetAssociateType(oTestTarget);
							int nRacial = GetRacialType(oTestTarget);
							nTempResult = !(nAssocType == ASSOCIATE_TYPE_SUMMONED ||
								nAssocType == ASSOCIATE_TYPE_FAMILIAR ||
								nAssocType == ASSOCIATE_TYPE_ANIMALCOMPANION ||
								nRacial == RACIAL_TYPE_OUTSIDER ||
								(!bBanish && (nRacial == RACIAL_TYPE_ELEMENTAL))) /*||
								GetLocalInt(oTestTarget, sHenchPseudoSummon))*/;
							if (!nTempResult && !bBanish)
							{
								currentSaveDC += nCasterLevel - GetHitDice(oTestTarget);
							}	
						}				
						break;
					case HENCH_ATTACK_CHECK_SPELLCASTER:
						if (GetLevelByClass(CLASS_TYPE_WIZARD, oTestTarget) >= 5 ||
							GetLevelByClass(CLASS_TYPE_SORCERER, oTestTarget) >= 6 ||
							GetLevelByClass(CLASS_TYPE_BARD, oTestTarget) >= 5)
						{					
							currentEffectWeight = 0.65;
						}
						else
						{
							nTempResult = GetLevelByClass(CLASS_TYPE_CLERIC, oTestTarget) < 5 &&
								GetLevelByClass(CLASS_TYPE_DRUID, oTestTarget) < 5 &&
								GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oTestTarget) < 6 &&
								GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oTestTarget) < 6 &&
								GetLevelByClass(CLASS_TYPE_WARLOCK, oTestTarget) < 10;
						}
						break;
					case HENCH_ATTACK_CHECK_NOT_ELF:
						nTempResult = GetRacialType(oTestTarget) == RACIAL_TYPE_ELF;
						break;
					case HENCH_ATTACK_CHECK_CONSTRUCT:
						nTempResult = GetRacialType(oTestTarget) != RACIAL_TYPE_CONSTRUCT;
						break;
					case HENCH_ATTACK_CHECK_SEARING_LIGHT:			
						if (GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD)
						{
							currentDamageAmount = nCasterLevel > 10 ? 35.0 : 3.5 * nCasterLevel;
						}
						else if (GetRacialType(oTestTarget) == RACIAL_TYPE_CONSTRUCT)
						{
							currentDamageAmount = nCasterLevel > 10 ? 17.5 : 1.75 * nCasterLevel;
						}
						break;
					case HENCH_ATTACK_CHECK_MINDBLAST:
						{
							int nApp = GetAppearanceType(oTestTarget);
							nTempResult = nApp == 413 || nApp== 414 || nApp == 415;
						}
						break;
					case HENCH_ATTACK_CHECK_EVARDS_TENTACLES:
						if (spellID == SPELL_I_CHILLING_TENTACLES)
						{
							currentDamageAmount += SCGetDamageResistImmunityAdjustment(oTestTarget, 7.0, DAMAGE_TYPE_COLD, 1);
						}
						fCurChance *= SCCheckGrappleResult(oTestTarget, 6, GRAPPLE_CHECK_HIT);
						break;
					case HENCH_ATTACK_CHECK_IRONHORN:
						fCurChance *= SCCheckGrappleResult(oTestTarget, 20, GRAPPLE_CHECK_STR);
						break;
					case HENCH_ATTACK_CHECK_PRISM:
						{
							int test = Random(8);
							if  (test == 0)
							{
								// fire
								currentDamageAmount = SCGetDamageResistImmunityAdjustment(oTestTarget, 20.0, DAMAGE_TYPE_FIRE, 1);
							}
							else if (test == 1)
							{
								// acid						
								currentDamageAmount = SCGetDamageResistImmunityAdjustment(oTestTarget, 40.0, DAMAGE_TYPE_ACID, 1);
							}
							else if (test == 2)
							{
								// electricity						
								currentDamageAmount = SCGetDamageResistImmunityAdjustment(oTestTarget, 80.0, DAMAGE_TYPE_ELECTRICAL, 1);
							}
							else if (test == 3)
							{
								// poison
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_POISON, oCharacter);
								if (!nTempResult)
								{
									currentEffectWeight = 0.1;
									currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_FORT;
									currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
								}
							}
							else if (test == 4)
							{
								// paralyze
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, oCharacter) ||
									GetIsImmune(oTestTarget, IMMUNITY_TYPE_PARALYSIS, oCharacter);
								if (!nTempResult)
								{
									currentEffectWeight = 0.95;
									currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_FORT;
									currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
								}
							}
							else if (test == 5)
							{
								// confusion
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, oCharacter) ||
									GetIsImmune(oTestTarget, IMMUNITY_TYPE_CONFUSED, oCharacter);
								if (!nTempResult)
								{
									currentEffectWeight = 0.80;
									currentFirstSaveType = 0;
									currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
								}
							}
							else if (test == 6)
							{
								// death
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, oCharacter);
								if (!nTempResult)
								{
									currentEffectWeight = 1.00;
									currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_WILL;
									currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
								}
							}
							else
							{
								// flesh to stone
								nTempResult = CSLGetIsImmuneToPetrification(oTestTarget);
								if (!nTempResult)
								{
									currentEffectWeight = 1.00;
									currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_FORT;
									currentFirstSaveKind = HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY;
								}
							}
						}
						break;
					case HENCH_ATTACK_CHECK_SPIRIT:
						nTempResult = !GetIsSpirit(oTestTarget);
						break;
					case HENCH_ATTACK_CHECK_WORDOFFAITH:
						if (GetAssociateType(oTestTarget) == ASSOCIATE_TYPE_SUMMONED)
						{					
							currentEffectWeight = 1.00;
							nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, oCharacter);
							currentEffectTypes = 0;
						}
						else
						{
							int hitDice = GetHitDice(oTestTarget);
							if (hitDice <= 4)
							{
								currentEffectWeight = 1.00;
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, oCharacter);
								currentEffectTypes = 0;
							}
							else if (hitDice < 8)
							{
								currentEffectWeight = 0.95;
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, oCharacter) ||
									(GetIsImmune(oTestTarget, IMMUNITY_TYPE_STUN, oCharacter) && 
									GetIsImmune(oTestTarget, IMMUNITY_TYPE_CONFUSED, oCharacter));
								currentEffectTypes = HENCH_EFFECT_TYPE_CONFUSED | HENCH_EFFECT_TYPE_STUNNED;
							}
							else if (hitDice < 12)
							{
								currentEffectWeight = 0.75;
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, oCharacter) ||
									GetIsImmune(oTestTarget, IMMUNITY_TYPE_STUN, oCharacter);
								currentEffectTypes = HENCH_EFFECT_TYPE_STUNNED;
							}
							else
							{
								// default is the blind effect
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_BLINDNESS, oCharacter);
							}
						}
						break;
					case HENCH_ATTACK_CHECK_CLOUDKILL:
						{
							int hitDice = GetHitDice(oTestTarget);
							if (hitDice <= 3)
							{
								currentEffectWeight = 1.00;
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, oCharacter);
								currentEffectTypes = 0;
								currentFirstSaveType = 0;
							}
							else if ((hitDice <= 6) && !GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, oCharacter))
							{
								currentEffectWeight = 1.0;
								currentEffectTypes = 0;
							}
							else
							{
								// default is the ability damage
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_ABILITY_DECREASE, oCharacter);
							}
						}				
						break;
					case HENCH_ATTACK_CHECK_HUMANOID_OR_ANIMAL:
						nTempResult = !(CSLGetIsHumanoid(oTestTarget) || (GetRacialType(oTestTarget) == RACIAL_TYPE_ANIMAL));
						break;
					case HENCH_ATTACK_CHECK_DAZE:
						nTempResult = (GetHitDice(oTestTarget) > 5) || !CSLGetIsHumanoid(oTestTarget);
						break;
					case HENCH_ATTACK_CHECK_TASHAS:
						nTempResult = GetHasSpellEffect(spellID, oTestTarget);
						if (GetRacialType(oTestTarget) != GetRacialType(oCharacter))
						{
							currentSaveDC -= 4;
						}
						break;
					case HENCH_ATTACK_CHECK_CAUSE_FEAR:
						nTempResult = GetHitDice(oTestTarget) > 5;
						break;
					case HENCH_ATTACK_CHECK_PERCENTAGE:
						currentDamageAmount = currentDamageAmount / 100.0 * IntToFloat(GetCurrentHitPoints(oTestTarget));
						break;
					case HENCH_ATTACK_CHECK_CREEPING_DOOM:
						if (spellID == SPELL_I_TENACIOUS_PLAGUE)
						{
							fCurChance *= SCCheckGrappleResult(oTestTarget, 5 + 2 * GetAbilityModifier(ABILITY_CHARISMA, oCharacter), GRAPPLE_CHECK_HIT);
						}
						else
						{
							fCurChance *= SCCheckGrappleResult(oTestTarget, 7 + 2 * GetAbilityModifier(ABILITY_WISDOM, oCharacter), GRAPPLE_CHECK_HIT);
						}			
						break;
					case HENCH_ATTACK_CHECK_DEATH_KNELL:
						nTempResult = GetCurrentHitPoints(oTestTarget) > 3;
						break;
					case HENCH_ATTACK_CHECK_WARLOCK:
						if (currentSaveDC < giWarlockMinSaveDC)
						{
							currentSaveDC = giWarlockMinSaveDC;
						}
						if (secondSaveKind == HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_EVASION && 
							(GetHasFeat(FEAT_EVASION, oTestTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTestTarget)))
						{
								// if you get no damage with these spells, effect doesn't happen					
							currentEffectWeight *= SCGetd20ChanceLimited(currentSaveDC - GetReflexSavingThrow(oTestTarget) - (bRegularSpell ? GetLocalInt(oTestTarget, "HenchSpellSaveBonus") : 0));
						}
						// shapes don't stack
						if ((gsCurrentspInfo.otherID) > 0 ? GetHasSpellEffect(gsCurrentspInfo.otherID, oTestTarget) :
							GetHasSpellEffect(spellID, oTestTarget))
						{
							currentEffectWeight = 0.0;
						}
							// fire, acid doesn't stack either
						else if (spellID == SPELL_I_VITRIOLIC_BLAST)
						{
							currentDamageAmount += SCGetDamageResistImmunityAdjustment(oTestTarget, 7.0, DAMAGE_TYPE_ACID, 1);
						}
						else if (spellID == SPELL_I_BRIMSTONE_BLAST)
						{
							currentDamageAmount += SCGetDamageResistImmunityAdjustment(oTestTarget, 7.0, DAMAGE_TYPE_FIRE, 1);
						}
						else if ((spellID == SPELL_I_FRIGHTFUL_BLAST) && (GetHitDice(oTestTarget) > 5))
						{
							currentEffectWeight = 0.0;
						}
						if (gsCurrentspInfo.otherID == SPELL_I_HIDEOUS_BLOW)
						{				
							currentDamageAmount += 5 + GetAbilityModifier(ABILITY_STRENGTH, oCharacter);
						}
						break;
					case HENCH_ATTACK_CHECK_MOONBOLT:
						{
							int nRacial = GetRacialType(oTestTarget);
							nTempResult = nRacial == RACIAL_TYPE_CONSTRUCT;
							if (!nTempResult)
							{
								if (nRacial == RACIAL_TYPE_UNDEAD)
								{				
									if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_KNOCKDOWN, oCharacter))
									{
										nTempResult = TRUE;
									}
									else
									{									
										currentFirstSaveType = HENCH_SPELL_SAVE_TYPE_SAVE1_WILL;									
										currentEffectWeight = 0.75;	
									}
								}
								else
								{							
									nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_ABILITY_DECREASE, oCharacter);
								}
							}
						}				
						break;
					case HENCH_ATTACK_CHECK_SWAMPLUNG:
						{
							int nRacial = GetRacialType(oTestTarget);				
							nTempResult = nRacial == RACIAL_TYPE_CONSTRUCT || nRacial == RACIAL_TYPE_ELEMENTAL ||
								nRacial == RACIAL_TYPE_VERMIN || nRacial == RACIAL_TYPE_OOZE || nRacial == RACIAL_TYPE_OUTSIDER ||
								nRacial == RACIAL_TYPE_UNDEAD;				
						}
						break;
					case HENCH_ATTACK_CHECK_SEEN:
						nTempResult = !GetObjectSeen(oTestTarget);
						break;
					case HENCH_ATTACK_CHECK_COLOR_SPRAY:
						{
							int hitDice = GetHitDice(oTestTarget);
							if (hitDice < 2)
							{
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_SLEEP, oCharacter);
							}
							else if (hitDice > 2 && hitDice < 5)
							{
								currentEffectWeight = 0.5;
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_BLINDNESS, oCharacter);
							}
							else
							{
								currentEffectWeight = 0.75;
								nTempResult = GetIsImmune(oTestTarget, IMMUNITY_TYPE_STUN, oCharacter);
							}				
						}
						break;
					case HENCH_ATTACK_CHECK_SUNBEAM:
						if (GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD)
						{
							currentDamageAmount = nCasterLevel > 20 ? 70.0 : 3.5 * nCasterLevel;
						}
						break;
					case HENCH_ATTACK_CHECK_SUNBURST:
						if (GetRacialType(oTestTarget) == RACIAL_TYPE_UNDEAD)
						{
							int nApperanceType =  GetAppearanceType(oTestTarget);                        
							if ((nApperanceType == APPEARANCE_TYPE_VAMPIRE_MALE) ||
								(nApperanceType == APPEARANCE_TYPE_VAMPIRE_FEMALE))
							{
								currentDamageAmount = 10000.0;                        
							}
							else
							{
								currentDamageAmount = nCasterLevel > 25 ? 87.5 : 3.5 * nCasterLevel;                        
							}
						}                    
						break;
					case HENCH_ATTACK_CHECK_MEDIUM:
						nTempResult = GetCreatureSize(oTestTarget) > CREATURE_SIZE_MEDIUM;
						break;
					case HENCH_ATTACK_CHECK_CASTIGATE:
						if (GetAlignmentLawChaos(oTestTarget) != GetAlignmentLawChaos(oCharacter))
						{
							if (GetAlignmentGoodEvil(oTestTarget) == GetAlignmentGoodEvil(oCharacter))
							{
								currentDamageAmount /= 2;
							}
						}
						else
						{
							if (GetAlignmentGoodEvil(oTestTarget) != GetAlignmentGoodEvil(oCharacter))
							{
								currentDamageAmount /= 2;
							}
							else
							{
								nTempResult = TRUE;
							}
						}
						break;
					case HENCH_ATTACK_CHECK_FIGHTER:
						{
							int nCurAction = GetCurrentAction(oTestTarget);
							nTempResult = (nCurAction != ACTION_ATTACKOBJECT) &&
								(nCurAction != HENCH_ACTION_MOVETOLOCATION) &&
								(nCurAction != ACTION_MOVETOPOINT);
							if (!nTempResult)
							{
								if (GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTestTarget)))
								{
									currentEffectWeight /= 2.0;
								}
							}
						}
						break;
					case HENCH_ATTACK_CHECK_NOT_DEAF:
						nTempResult = currentCreatureNegativeEffects & HENCH_EFFECT_TYPE_DEAF;
						break;
					case HENCH_ATTACK_CHECK_HOLY_BLAS:				
						nTempResult = GetHasSpellEffect(spellID, oTestTarget) || GetAlignmentGoodEvil(oTestTarget) != (spellID == 1793 ? ALIGNMENT_GOOD : ALIGNMENT_EVIL);
						if (!nTempResult)
						{
							if (GetSubRace(oTestTarget) == RACIAL_SUBTYPE_OUTSIDER)
							{
								currentEffectWeight = 1.00;
								currentEffectTypes = 0;	
								currentSaveDC += 4;
								immunityMind = FALSE;
								immunity1 = 0;
							}
							else
							{
								currentFirstSaveType = 0;
								immunity1 = IMMUNITY_TYPE_DAZED;
								immunityMind = TRUE;
								int hitDiceDiff = GetHitDice(oCharacter) - GetHitDice(oTestTarget);
								if (hitDiceDiff < 0)
								{
									nTempResult = TRUE;
								}
								else if (hitDiceDiff < 5)
								{
									// leave as default
								}
								else
								{
									if (!GetIsImmune(oTestTarget, IMMUNITY_TYPE_PARALYSIS, oCharacter))
									{								
										currentEffectWeight = 0.90;
										immunity1 = 0;
									}
									if (hitDiceDiff >= 10)
									{
										if (!GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, oCharacter))
										{
											currentEffectWeight = 1.0;
											immunityMind = FALSE;
											immunity1 = 0;
										}
									}
								}
							}
						}
						break;	
					case HENCH_ATTACK_CHECK_EVIL:					
						nTempResult = GetAlignmentGoodEvil(oTestTarget) != ALIGNMENT_EVIL;
						break;		
				}

				if (!nTempResult && currentEffectWeight >= 0.0)
				{
					if ((immunityMind && GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, oCharacter)) ||
						(immunity1 && (GetIsImmune(oTestTarget, immunity1, oCharacter) ||
						(immunity2 && GetIsImmune(oTestTarget, immunity2, oCharacter)))))
					{
						currentEffectWeight = 0.0;
						if (secondSaveType)
						{
							currentFirstSaveType = -1;
							currentFirstSaveKind = -1;
						}
						else
						{
							currentFirstSaveType = 0;
						}
					}					
				}
				if (!nTempResult && currentEffectWeight >= 0.0)
				{
					if (currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED)
					{
						currentEffectWeight = 0.0;
					}
					else
					{
						if ((currentEffectTypes & currentCreatureNegativeEffects) == currentEffectTypes)
						{
							currentEffectWeight = 0.0;
						}
						else if ((currentEffectTypes & currentCreatureNegativeEffects) != 0)
						{
							currentEffectWeight /= 2.0;
						}
					}
				}
				if (nTempResult || fCurChance <= 0.0)
				{
					// GetLocalInt can only be used because SC GetCreatureNegEffects has been already called
					if (bIsEnemy && bCheckSR && GetLocalInt(oTestTarget, "HenchCurPosEffects") & HENCH_EFFECT_TYPE_SPELL_SHIELD)
					{
							// even though the spell is ineffective, it is useful for tearing down the spell shield
						curTargetWeight = 0.25;
					}
					else
					{
						curTargetWeight = 0.0;
					}
				}
				else
				{
					if (currentCheckSaves)
					{
						if (bCheckSR)
						{
							if (bCheckNecromancy &&
								// GetLocalInt can only be used because SC GetCreatureNegEffects has been already called
								(GetLocalInt(oTestTarget, "HenchCurPosEffects") & HENCH_EFFECT_TYPE_IMMUNE_NECROMANCY))
							{
								fCurChance = 0.0;
							}
							else if (GetLocalInt(oTestTarget, "HenchSpellLevelProtect") >= spellLevel)
							{
								fCurChance = 0.0;
							}
							else if (bIsEnemy && GetLocalInt(oTestTarget, "HenchCurPosEffects") & HENCH_EFFECT_TYPE_SPELL_SHIELD)
							{
									// spell is useful for tearing down the spell shield
								fCurChance = (1.0 - fCurChance) / 4.0;
							}
							else
							{
								fCurChance *= SCGetd20Chance(nSpellPentetration - GetSpellResistance(oTestTarget));
							}
						}
				
						// adjust damage based on immunities and resistances
						// TODO this should be below in the code for resistances, but too many branches						
						int curTargetDamageInfo = GetLocalInt(oTestTarget, "HenchDamageInformation") & spellDamage.damageTypeMask;
						if (curTargetDamageInfo)
						{
							// do some damage adjusting!
							int numberOfDamageTypes = spellDamage.numberOfDamageTypes;
							if (numberOfDamageTypes == 1)
							{								
								currentDamageAmount *= CSLDataArray_GetFloat(oTestTarget, "HenchDamageImmunity", spellDamage.damageType1);
								currentDamageAmount -= CSLDataArray_GetInt(oTestTarget, "HenchDamageResist", spellDamage.damageType1) * spellDamage.count;
								if (currentDamageAmount < 0.5)
								{			
									currentDamageAmount = 0.0;
								}
							}
							else
							{							
								currentDamageAmount = SCGetDamageResistImmunityAdjustment(oTestTarget, currentDamageAmount / 2, spellDamage.damageType1, spellDamage.count) +
									SCGetDamageResistImmunityAdjustment(oTestTarget, currentDamageAmount / 2, spellDamage.damageType2, spellDamage.count);					
							}
						}	
											
						float ratio = 1.0;						
											
						if (currentFirstSaveType)
						{
							switch (currentFirstSaveType)
							{
							case HENCH_SPELL_SAVE_TYPE_SAVE1_FORT:
								ratio = SCGetd20ChanceLimited(currentSaveDC - GetFortitudeSavingThrow(oTestTarget) - (bRegularSpell ? GetLocalInt(oTestTarget, "HenchSpellSaveBonus") : 0));
								break;
							case HENCH_SPELL_SAVE_TYPE_SAVE1_REFLEX:
								ratio = SCGetd20ChanceLimited(currentSaveDC - GetReflexSavingThrow(oTestTarget) - (bRegularSpell ? GetLocalInt(oTestTarget, "HenchSpellSaveBonus") : 0));
								break;
							case HENCH_SPELL_SAVE_TYPE_SAVE1_WILL:
								ratio = SCGetd20ChanceLimited(currentSaveDC - GetWillSavingThrow(oTestTarget) - (bRegularSpell ? GetLocalInt(oTestTarget, "HenchSpellSaveBonus") : 0));
								break;
							}
							switch (currentFirstSaveKind)
							{
							case HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_ONLY:
								if (secondSaveType == 0)
								{
									curTargetWeight = currentEffectWeight * ratio;
									if (currentDamageAmount > 0.0)
									{				
										curTargetWeight += SCCalculateDamageWeight(currentDamageAmount, oTestTarget);
									}
								}
								else if (currentFirstSaveType == (secondSaveType / HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT))
								{
									curTargetWeight = currentEffectWeight * ratio;
								}
								else
								{
									fCurChance *= ratio;									
								}
								break;
								case HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_HALF:							
								curTargetWeight = ratio * SCCalculateDamageWeight(currentDamageAmount, oTestTarget) +
									(1.0 - ratio) * SCCalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget); 
								break;							
								case HENCH_SPELL_SAVE_TYPE_SAVE1_EFFECT_DAMAGE:
								curTargetWeight = ratio * currentEffectWeight +
									(1.0 - ratio) * SCCalculateDamageWeight(currentDamageAmount, oTestTarget);
								break;	
								case HENCH_SPELL_SAVE_TYPE_SAVE1_DAMAGE_EVASION:
								if (GetHasFeat(FEAT_IMPROVED_EVASION, oTestTarget))
								{
									curTargetWeight = ratio * SCCalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget);
								}
								else if (GetHasFeat(FEAT_EVASION, oTestTarget))
								{
									curTargetWeight = ratio * SCCalculateDamageWeight(currentDamageAmount, oTestTarget);
								}
								else
								{
									curTargetWeight = ratio * SCCalculateDamageWeight(currentDamageAmount, oTestTarget) +
										(1.0 - ratio) * SCCalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget);
								}
								break;
							default:
								curTargetWeight = 0.0;
							}
							if (secondSaveType)
							{
								if (secondSaveType != (currentFirstSaveType * HENCH_SPELL_SAVE_TYPE_SAVE12_SHIFT))
								{						
									switch (secondSaveType)
									{
									case HENCH_SPELL_SAVE_TYPE_SAVE2_FORT:
										ratio = SCGetd20ChanceLimited(currentSaveDC - GetFortitudeSavingThrow(oTestTarget) - (bRegularSpell ? GetLocalInt(oTestTarget, "HenchSpellSaveBonus") : 0));
										break;
									case HENCH_SPELL_SAVE_TYPE_SAVE2_REFLEX:
										ratio = SCGetd20ChanceLimited(currentSaveDC - GetReflexSavingThrow(oTestTarget) - (bRegularSpell ? GetLocalInt(oTestTarget, "HenchSpellSaveBonus") : 0));
										break;
									case HENCH_SPELL_SAVE_TYPE_SAVE2_WILL:
										ratio = SCGetd20ChanceLimited(currentSaveDC - GetWillSavingThrow(oTestTarget) - (bRegularSpell ? GetLocalInt(oTestTarget, "HenchSpellSaveBonus") : 0));
										break;
									}
								}
								switch (secondSaveKind)
								{
								case HENCH_SPELL_SAVE_TYPE_SAVE2_EFFECT_ONLY:
									curTargetWeight += currentEffectWeight * ratio;
									break;
								case HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_HALF:
									curTargetWeight += ratio * SCCalculateDamageWeight(currentDamageAmount, oTestTarget) +
										(1.0 - ratio) * SCCalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget); 
									break;							
								case HENCH_SPELL_SAVE_TYPE_SAVE2_EFFECT_DAMAGE:
									curTargetWeight += ratio * currentEffectWeight +
										(1.0 - ratio) * SCCalculateDamageWeight(currentDamageAmount, oTestTarget);
									break;	
								case HENCH_SPELL_SAVE_TYPE_SAVE2_DAMAGE_EVASION:							
									if (GetHasFeat(FEAT_IMPROVED_EVASION, oTestTarget))
									{
										curTargetWeight = ratio * SCCalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget);
									}
									else if (GetHasFeat(FEAT_EVASION, oTestTarget))
									{
										curTargetWeight = ratio * SCCalculateDamageWeight(currentDamageAmount, oTestTarget);
									}
									else
									{
										curTargetWeight = ratio * SCCalculateDamageWeight(currentDamageAmount, oTestTarget) +
											(1.0 - ratio) * SCCalculateDamageWeight(currentDamageAmount / 2.0, oTestTarget);
									}
									break;
								}
							}
						}
						else
						{
							curTargetWeight = currentEffectWeight + SCCalculateDamageWeight(currentDamageAmount, oTestTarget);
						}
						if (curTargetWeight > 1.0)
						{				
							curTargetWeight = 1.0;
						}
						if (bIsFriend && (fCurChance > 0.0)) 					
						{
							if (oTestTarget == oCharacter)
							{
								// always look out for number one
								if (currentEffectWeight > 0.0)
								{
									curTargetWeight = HENCH_CREATURE_SAVE_ABORT;
								}
								// don't drop self HP too much
								else if (curTargetWeight > HENCH_LOW_ALLY_DAMAGE_THRESHOLD)
								{
									curTargetWeight = HENCH_CREATURE_SAVE_ABORT;
								}
								else
								{
									curTargetWeight *= HENCH_LOW_ALLY_DAMAGE_WEIGHT * SCGetThreatRating(oTestTarget,oCharacter) * gfAttackWeight * fCurChance;                           
								}
							}
							else
							{						
								if (GetAssociateType(oTestTarget) == ASSOCIATE_TYPE_SUMMONED)
								{
									// summons are expendable
									curTargetWeight *= gfAllyDamageWeight * SCGetThreatRating(oTestTarget,oCharacter) * gfAttackWeight * fCurChance;                           
								}
								// avoid putting negative effects on allies
								else if (currentEffectWeight > gfMaximumAllyEffect)
								{
									curTargetWeight = HENCH_CREATURE_SAVE_ABORT;
								}
								// don't drop ally HP too much
								else if (curTargetWeight > gfMaximumAllyDamage)
								{
									curTargetWeight = HENCH_CREATURE_SAVE_ABORT;
								}
								else
								{
									curTargetWeight *= gfAllyDamageWeight * SCGetThreatRating(oTestTarget,oCharacter) * gfAttackWeight * fCurChance;                           
								}
							}
						}
						else						
						{						
								if ((GetDistanceToObject(oTestTarget) < 7.5) &&
								((curTargetWeight * fCurChance) > 0.0001))
							{
								bTargetFound = TRUE;
							}
							curTargetWeight *= SCGetThreatRating(oTestTarget,oCharacter) * gfAttackWeight * fCurChance;                           
						}                        
					}
					else
					{
						int currentRegenerateAmount = GetLocalInt(oTestTarget, "HenchRegenerationRate");
						int iCurrent = GetCurrentHitPoints(oTestTarget) + currentRegenerateAmount * giRegenHealScaleAmount;
						int iBase = GetMaxHitPoints(oTestTarget);
						
						float healthRatio = IntToFloat(iCurrent) / IntToFloat(iBase);
						

						if ((healthRatio < gfHealingThreshold) &&
							(currentDamageAmount >= IntToFloat(iBase / giHealingDivisor)))
						{
							if (gbDisableNonHealorCure || (GetLocalInt(oTestTarget, HENCH_HEAL_SELF_STATE) <= HENCH_HEAL_SELF_CANT) || GetIsPC(oTestTarget))
							{
								// this actually heals the target (a friend)
								curTargetWeight = currentDamageAmount / IntToFloat(iBase - iCurrent);
								if (curTargetWeight > 1.0)
								{
									curTargetWeight = 1.0;
								}
								curTargetWeight *= SCGetThreatRating(oTestTarget,oCharacter);
								if (gbDisableNonHealorCure || oTestTarget == oCharacter)
								{
									// make sure to heal self
									curTargetWeight *= HENCH_HEALSELF_WEIGHT_ADJUSTMENT;
								}
								else
								{
									curTargetWeight *= HENCH_HEALOTHER_WEIGHT_ADJUSTMENT;
								}
								curTargetWeight *= (1.0 - healthRatio);
									if (GetDistanceToObject(oTestTarget) < 7.5)
								{
									bTargetFound = TRUE;
								}
							}
							else
							{
								curTargetWeight = 0.0;
							}
						}
						else
						{
							curTargetWeight = 0.0;
							if ((oTestTarget == oCharacter) && (currentDamageAmount >= IntToFloat(iBase / giHealingDivisor)))
							{
    							SetLocalInt(oCharacter, HENCH_HEAL_SELF_STATE, HENCH_HEAL_SELF_WAIT);
							}
						}
					}					
				}
				if (bAllowWeightSave)
				{
					SetLocalFloat(oTestTarget, "HENCH_CREATURE_SAVE", curTargetWeight);
				}				
            }
			
			if (curTargetWeight == HENCH_CREATURE_SAVE_ABORT)
			{
				fTotalWeight = HENCH_CREATURE_SAVE_ABORT;
				break;
			}
						
			// check touch attacks
			if (iCheckTouch)
			{
				if (!GetIsEnemy(oTestTarget))
				{
				}				
				else if ((gsCurrentspInfo.otherID != SPELL_I_ELDRITCH_CHAIN) && (nShapeLoopCount > 0))
				{
				}
				else
				{
					float fTouchChance;
					int touchFlags = GetLocalInt(oTestTarget, HENCH_RANGED_TOUCH_SAVEINFO);
					if (touchFlags & iCheckTouch)
					{
						fTouchChance = GetLocalFloat(oTestTarget, gsRangeSaveStr);
					}
					else
					{
						int touchAC = SCGetTouchAC(oTestTarget);
											
						fTouchChance = SCGetd20ChanceLimited(nTouchCheck - touchAC);								
						if (iCheckTouch & (HENCH_MELEE_TOUCH_REGULAR | HENCH_MELEE_TOUCH_PLUS_TWO))
						{
							fTouchChance *= 1.0 - GetLocalFloat(oTestTarget, "HenchMeleeConcealment");
						}
						else
						{
							fTouchChance *= 1.0 - GetLocalFloat(oTestTarget, "HenchRangedConcealment");
						}
						SetLocalFloat(oTestTarget, gsRangeSaveStr, fTouchChance);
						touchFlags |= iCheckTouch;
						SetLocalInt(oTestTarget, HENCH_RANGED_TOUCH_SAVEINFO, touchFlags);
					}
					
					if (gsCurrentspInfo.otherID == SPELL_I_ELDRITCH_CHAIN)
					{
						if (!nShapeLoopCount)
						{
							fAccumChance = fTouchChance;
						}
						else if (oCurTarget != oTestTarget)
						{
							fAccumChance *= fTouchChance;
						}
						curTargetWeight *= fAccumChance;
					}
					else
					{
						curTargetWeight *= fTouchChance;
					}			
				}					
			}			
			fTotalWeight += curTargetWeight;
								
			if (!bDoLoop || (nShapeLoopCount > 19))
			{
				break;
			}
			if (iTargetInformation & HENCH_SPELL_TARGET_SECONDARY_TARGETS)
			{
				do
				{
					//DEBUGGING// igDebugLoopCounter += 1;
					if (!nShapeLoopCount)
					{				
						// hack, reset back to first shape target after first iteration
						oTestTarget = GetFirstObjectInShape(spellShape, spellRadius, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCharacter));
						bAllowWeightSave = TRUE;
					}
					else
					{
						//Select the next target within the spell shape.
						oTestTarget = GetNextObjectInShape(spellShape, spellRadius, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCharacter));
					}
					nShapeLoopCount++;
				} while ( GetIsObjectValid(oTestTarget) && oCurTarget == oTestTarget);
			}
			else
			{
				//Select the next target within the spell shape.
				oTestTarget = GetNextObjectInShape(spellShape, spellRadius, testTargetLoc, TRUE, OBJECT_TYPE_CREATURE, GetPosition(oCharacter));
				nShapeLoopCount++;
			}
        }
		
		if (bTargetFound && (fTotalWeight > fFinalTargetWeight))
		{
			fFinalTargetWeight = fTotalWeight;
			oFinalTarget = oCurTarget;
			lFinalLocation = testTargetLoc;
			bUseFinalTargetObject = spellShape == HENCH_SHAPE_NONE ||
				(iTargetInformation & HENCH_SPELL_TARGET_VIS_REQUIRED_FLAG) || (oCurTarget == oCharacter) ||
				(GetObjectSeen(oCurTarget) && (spellShape == SHAPE_SPELLCONE || spellShape == SHAPE_CONE || !checkFriendly));
		}
		// don't check too many targets
		if (totalTargetsTested >= totalTargetsLimit)
		{
			break;
		}
    }
	
	if (spellShape == HENCH_SHAPE_NONE)
	{
		giCurNumMaxSingleTest += totalTargetsTested;
	}
	else
	{
		giCurNumMaxAreaTest += totalTargetsTested;
	}
    
	if (fFinalTargetWeight > 0.0)
	{
		if (iTargetInformation & HENCH_SPELL_TARGET_RANGED_SEL_AREA_FLAG)	
		{
			gsCurrentspInfo.castingInfo |= HENCH_CASTING_INFO_RANGED_SEL_AREA_FLAG;	
		}
		if (bUseFinalTargetObject)
		{
        	SCHenchCheckIfAttackSpellToCastOnObject(fFinalTargetWeight, oFinalTarget);
		}
		else
		{		
        	SCHenchCheckIfAttackSpellToCastAtLocation(fFinalTargetWeight, lFinalLocation);
		}
    }
	
	if (bIsBeneficial)
	{	
		float spellDamageAmount = spellDamage.amount;
		if (spellShape != HENCH_SHAPE_NONE)
		{
			if (checkType == HENCH_ATTACK_CHECK_HEAL)
			{
				if (giCurNumMaxAreaTest > HENCH_MAX_AREA_TARGET_CHECKS)
				{
					gfMinHealAmountArea = 100000.0;	// prevent any more attempts			
				}
				else if (!gbDisableNonHealorCure)
				{
						if (fFinalTargetWeight > gfMinHealWeightArea)
					{				
						gfMinHealWeightArea = fFinalTargetWeight;
						gfMinHealAmountArea = gfLastHealAmountArea;
						gfLastHealAmountArea = spellDamageAmount;
					}
					else if (spellDamageAmount > gfMinHealAmountArea)
					{
						gfMinHealAmountArea = spellDamageAmount;
						gfLastHealAmountArea = gfMinHealAmountArea;
					}
				}
			}
			else
			{
				if (giCurNumMaxAreaTest > HENCH_MAX_AREA_TARGET_CHECKS)
				{
					gfMinHarmAmountArea = 100000.0;	// prevent any more attempts			
				}
				else if (!gbDisableNonHealorCure)
				{
						if (fFinalTargetWeight > gfMinHarmWeightArea)
					{				
						gfMinHarmWeightArea = fFinalTargetWeight;
						gfMinHarmAmountArea = gfLastHarmAmountArea;
						gfLastHarmAmountArea = spellDamageAmount;
					}
					else if (spellDamageAmount > gfMinHarmAmountArea)
					{
						gfMinHarmAmountArea = spellDamageAmount;
						gfLastHarmAmountArea = gfMinHarmAmountArea;
					}
				}
			}
		}
		else if (spellRange > 0.0)
		{
			if (checkType == HENCH_ATTACK_CHECK_HEAL)
			{
				if (giCurNumMaxSingleTest > HENCH_MAX_SINGLE_TARGET_CHECKS)
				{
					gfMinHealAmountSingle = 100000.0;	// prevent any more attempts			
				}
				else if (!gbDisableNonHealorCure)
				{
						if (fFinalTargetWeight > gfMinHealWeightSingle)
					{				
						gfMinHealWeightSingle = fFinalTargetWeight;
						gfMinHealAmountSingle = gfLastHealAmountSingle;
						gfLastHealAmountSingle = spellDamageAmount;
					}
					else if (spellDamageAmount > gfMinHealAmountSingle)
					{
						gfMinHealAmountSingle = spellDamageAmount;
						gfLastHealAmountSingle = gfMinHealAmountSingle;
					}
				}
			}
			else
			{
				if (giCurNumMaxSingleTest > HENCH_MAX_SINGLE_TARGET_CHECKS)
				{
					gfMinHarmAmountSingle = 100000.0;	// prevent any more attempts			
				}
				else if (!gbDisableNonHealorCure)
				{
						if (fFinalTargetWeight > gfMinHarmWeightSingle)
					{				
						gfMinHarmWeightSingle = fFinalTargetWeight;
						gfMinHarmAmountSingle = gfLastHarmAmountSingle;
						gfLastHarmAmountSingle = spellDamageAmount;
					}
					else if (spellDamageAmount > gfMinHarmAmountSingle)
					{
						gfMinHarmAmountSingle = spellDamageAmount;
						gfLastHarmAmountSingle = gfMinHarmAmountSingle;
					}
				}
			}
		}
	}
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCAISpellAttack End", GetFirstPC() ); }
}


void SCAISpellAttackSpecial(object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAISpellAttackSpecial Start", GetFirstPC() ); }
	
	int spellID = gsCurrentspInfo.spellID;
	int saveType = SCGetCurrentSpellSaveType();	
	float testRange = gsCurrentspInfo.range;
    int bCheckSR = saveType & HENCH_SPELL_SAVE_TYPE_SR_FLAG;
	int bFoundItemSpell = gsCurrentspInfo.spellInfo & HENCH_SPELL_INFO_ITEM_FLAG;	
	int spellLevel = gsCurrentspInfo.spellLevel;
    int nCasterLevel =  bFoundItemSpell ? (spellLevel * 2) - 1 : giMySpellCasterLevel;
	int nSpellPentetration =  bFoundItemSpell ? nCasterLevel : giMySpellCasterSpellPenetration;
		

	object oTestTarget = GetLocalObject(oCharacter, "HenchObjectSeen");	
	object oBestTarget;
	float maxEffectWeight;
	int totalTargetsTested;

	while (GetIsObjectValid(oTestTarget) && (totalTargetsTested < 6))
	{
			//DEBUGGING// igDebugLoopCounter += 1;
			if (GetDistanceToObject(oTestTarget) <= testRange)
		{		
			totalTargetsTested ++;
			if (giCurNumMaxSingleTest++ > HENCH_MAX_SINGLE_TARGET_CHECKS)
			{		
				break;
			}			
			int currentCreatureNegativeEffects = SCGetCreatureNegEffects(oTestTarget);
			
			float curEffectWeight;		
			int skipTarget;
		
			switch (spellID)
			{
			case SPELL_POWORD_WEAKEN:
			case SPELL_POWORD_MALADROIT:
				if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_ABILITY_DECREASE, oCharacter))
				{
					skipTarget = TRUE;
				}		
				else 
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 75) ||
						(currentCreatureNegativeEffects & (HENCH_EFFECT_DISABLED | HENCH_EFFECT_IMPAIRED | HENCH_EFFECT_TYPE_ABILITY_DECREASE)) ||				
						!GetIsObjectValid(GetAttackTarget(oTestTarget)))
					{
						skipTarget = TRUE;
					}
					else if (nTargetHP > 50)
					{
						curEffectWeight = 0.015;
					}
					else if (nTargetHP > 25)
					{
						curEffectWeight = 0.02;
					}
					else
					{
						curEffectWeight = 0.03;
					}		
				}
				break;
			case SPELL_POWORD_BLIND:		
				if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_BLINDNESS, oCharacter))
				{
					skipTarget = TRUE;
				}		
				else 
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 200) ||
						(currentCreatureNegativeEffects & (HENCH_EFFECT_DISABLED | HENCH_EFFECT_IMPAIRED)))
					{
						skipTarget = TRUE;
					}
					else if (nTargetHP > 100)
					{
						curEffectWeight = 0.2;
					}
					else if (nTargetHP > 50)
					{
						curEffectWeight = 0.3;
					}
					else
					{
						curEffectWeight = 0.35;
					}		
				}
				break;
			case SPELL_POWORD_PETRIFY:	
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 100) ||
						(currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
					{
						skipTarget = TRUE;
					}
					else
					{
						curEffectWeight = 1.0;
					}		
				}
				break;
			case SPELL_POWER_WORD_DISABLE:
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 50) || (nTargetHP < 2) ||
						(currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
					{
						skipTarget = TRUE;
					}
					else
					{
						curEffectWeight = SCCalculateDamageWeight(IntToFloat(nTargetHP - 1), oTestTarget);
					}
				}
				break;				
			case SPELL_POWER_WORD_KILL:
				if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_DEATH, oCharacter))
				{
					skipTarget = TRUE;
				}		
				else 
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 100) ||
						(currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
					{
						skipTarget = TRUE;
					}
					else
					{
						curEffectWeight = 1.0;
					}		
				}
				break;
			case SPELL_POWER_WORD_STUN:
				if (GetIsImmune(oTestTarget, IMMUNITY_TYPE_MIND_SPELLS, oCharacter) ||
					GetIsImmune(oTestTarget, IMMUNITY_TYPE_STUN, oCharacter))
				{
					skipTarget = TRUE;
				}		
				else 
				{
					int	nTargetHP =	GetCurrentHitPoints(oTestTarget);
					if ((nTargetHP > 150) ||
						(currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED))
					{
						skipTarget = TRUE;
					}
					else if (nTargetHP > 100)
					{
						curEffectWeight = 0.70;
					}
					else if (nTargetHP > 50)
					{
						curEffectWeight = 0.75;
					}
					else
					{
						curEffectWeight = 0.8;
					}		
				}
				break;
			case 1132:		// Shadow Simulacrum
			case 1133:		// Glass Doppelganger
				if (!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED)))
				{				
					int nTargetHD = GetHitDice(oTestTarget);
					if (spellID == 1132)
					{
						if (nTargetHD > (2 * nCasterLevel))
						{
							skipTarget = TRUE;
							break;
						}
						curEffectWeight = 0.75;
					}
					else
					{
						if ((nTargetHD > nCasterLevel) || (nTargetHD > 15))
						{
							skipTarget = TRUE;
							break;
						}
						curEffectWeight = 0.25;
					}
					curEffectWeight *= SCGetRawThreatRating(oTestTarget);
					curEffectWeight *= IntToFloat(GetCurrentHitPoints(oTestTarget)) / (4.5 * nTargetHD);
					curEffectWeight *= IntToFloat(GetBaseAttackBonus(oTestTarget)) / (0.75 * nTargetHD);					
					curEffectWeight *= gfSummonAdjustment * gfBuffSelfWeight;
				}
				break;
			}
		
			if (!skipTarget)
			{
				if (currentCreatureNegativeEffects & HENCH_EFFECT_DISABLED)
				{
					curEffectWeight = 0.0;			
				}
				else if (bCheckSR)
				{
					if (GetLocalInt(oTestTarget, "HenchSpellLevelProtect") >= spellLevel)
					{
						curEffectWeight = 0.0;
					}
					else
					{						
						curEffectWeight *= SCGetd20Chance(nSpellPentetration - GetSpellResistance(oTestTarget));
					}
				}
				
				curEffectWeight *=  SCGetThreatRating(oTestTarget,oCharacter);
				
				if (curEffectWeight > maxEffectWeight)
				{
					oBestTarget = oTestTarget;
					maxEffectWeight = curEffectWeight;
				}
			}
		}
		oTestTarget = GetLocalObject(oTestTarget, "HenchObjectSeen");	
	}
	if (maxEffectWeight > 0.0)
	{	
		SCHenchCheckIfAttackSpellToCastOnObject(maxEffectWeight, oBestTarget);
	}
}


float SCAIMeleeAttack(object oTarget, int iPosEffectsOnSelf, int bImmobileNoRange, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAIMeleeAttack Start "+GetName(oTarget), GetFirstPC() ); }
    
    float fMaxRange = gbMeleeAttackers ? GetDistanceToObject(goClosestSeenOrHeardEnemy) + 1.5 : 1000.0;
	
	if (bImmobileNoRange)
	{
		fMaxRange = 3.5;
	}

    int bHasSneakAttack = GetHasFeat(FEAT_SNEAK_ATTACK, oCharacter);
	int bIsInvisible = iPosEffectsOnSelf & HENCH_EFFECT_INVISIBLE;
	int bWeaponIsRanged = GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND));
			
    if (!GetIsObjectValid(oTarget))
    {
        float curMaxThreatRating;
		object oTestTarget = GetLocalObject(oCharacter, "HenchLineOfSight");
		
		if (GetIsObjectValid(goClosestNonActiveEnemy) &&
			(oTestTarget != goClosestNonActiveEnemy) &&
			(GetDistanceToObject(goClosestNonActiveEnemy) <= fMaxRange) &&
			LineOfSightObject(oCharacter, goClosestNonActiveEnemy))
		{
			// if target is non active finish them off		
			if (SCGetCreatureNegEffects(goClosestNonActiveEnemy) & HENCH_EFFECT_DISABLED_INACTIVE_SHORT_DURATION)
			{
				// insert ourselves into the list
				SetLocalObject(goClosestNonActiveEnemy, "HenchLineOfSight", oTestTarget);
				oTestTarget = goClosestNonActiveEnemy;
			}
		}		
		
		int iIteration = 0;
        while (GetIsObjectValid(oTestTarget) && iIteration < 20 )
        {
			//DEBUGGING// igDebugLoopCounter += 1;
			iIteration++;
			float fDistanceToTarget = GetDistanceToObject(oTestTarget);
            if (fDistanceToTarget <= fMaxRange)
            {
                float curThreatRating = GetLocalFloat(oTestTarget, "HenchThreatRating");

                if (!GetObjectSeen(oTestTarget))
                {
                    curThreatRating /= 2.0;
                }
				else if (bWeaponIsRanged)
				{
					curThreatRating *= 1.0 - GetLocalFloat(oTestTarget, "HenchRangedConcealment");
				}
				else
				{
					curThreatRating *= 1.0 - GetLocalFloat(oTestTarget, "HenchMeleeConcealment");
				}
				if (GetIsWeaponEffective(oTestTarget))
				{
					// provide bonus to gang up on damaged targets
					curThreatRating *= 2.0 - IntToFloat(GetCurrentHitPoints(oTestTarget)) / IntToFloat(GetMaxHitPoints(oTestTarget));
	
					// extra damage for sneak attack
					if (bHasSneakAttack && GetObjectSeen(oTestTarget) &&
							!GetIsImmune(oTestTarget, IMMUNITY_TYPE_SNEAK_ATTACK, oCharacter) &&
							(fDistanceToTarget <= HENCH_MAX_SNEAK_ATTACK_DISTANCE) &&
							(bIsInvisible || (GetAttackTarget(oTestTarget) != oCharacter) ||
							(GetLocalInt(oTestTarget, "HenchCurNegEffects") & HENCH_EFFECT_DISABLED)))
                    {
                        curThreatRating *= 2.0;
                    }
					// encentive to finish off disabled opponents
					else if (GetLocalInt(oTestTarget, "HenchCurNegEffects") & HENCH_EFFECT_DISABLED)
					{
                        curThreatRating *= 1.5;
					}
				}
				else
				{
					curThreatRating /= 5.0;
				}
				
                if (curThreatRating > curMaxThreatRating)
                {
                    oTarget = oTestTarget;
                    curMaxThreatRating = curThreatRating;
                }
            }
 			oTestTarget = GetLocalObject(oTestTarget, "HenchLineOfSight");
		}
    }
	
	if (!GetIsObjectValid(oTarget))
	{	
		return 0.0;
	}
	
	goSaveMeleeAttackTarget = oTarget;
	
	int baseAttackBonus = GetBaseAttackBonus(oCharacter);
	
	struct sAttackInfo attackInfo = SCGetAttackBonus(oCharacter, oTarget);
	
	// not completely accurate - guess at weapon damage amount
	float damageGuess = 4.5 + attackInfo.damageBonus;
	

	float result;
	int attackBonus = attackInfo.attackBonus + 20 - GetAC(oTarget);
	
	int bHasted = iPosEffectsOnSelf & HENCH_EFFECT_TYPE_HASTE;
	int bBABAbove20LevelAdjust; // according to notes from expansion, more than four attacks per round can happen at epic levels
	/*
	int bBABAbove20LevelAdjust = GetHitDice(oCharacter);
	if (bBABAbove20LevelAdjust > 21)
	{
		bBABAbove20LevelAdjust -= 20;
		bBABAbove20LevelAdjust /= 2;	
	}
	else
	{
		bBABAbove20LevelAdjust = 0;
	}*/
	
	do
	{
		//DEBUGGING// igDebugLoopCounter += 1;
		float curChance = SCGetd20ChanceLimited(baseAttackBonus + attackBonus);
		if (bHasted)
		{
			curChance *= 2.0;		
			bHasted = FALSE;
		}
		result += curChance;		
		baseAttackBonus -= 5;
	} while (baseAttackBonus > bBABAbove20LevelAdjust);
	
	if (!GetObjectSeen(oTarget))
	{
		result /= 2.0;
	}
	if (bWeaponIsRanged)
	{
		result *= 1.0 - GetLocalFloat(oTarget, "HenchRangedConcealment");
	}
	else
	{
		result *= 1.0 - GetLocalFloat(oTarget, "HenchMeleeConcealment");
	}
	gfSaveAttackChance = result;
	result *= damageGuess;
	return SCCalculateDamageWeight(result, oTarget) * SCGetThreatRating(oTarget,oCharacter) / ((GetIsWeaponEffective(oTarget) ||
		(SCGetCreaturePosEffects(oTarget) & HENCH_EFFECT_TYPE_DAMAGE_REDUCTION)) ? 1.0 : 5.0);	
}



// * Special combat round precursor for associates and companions
// associates and companions have lots of extra reasons why they might not want to fight
// such as having player queued actions we don't want to interrupte or not attaking anyone in the
// same party, etc...
void SCAICombatRound( object oIntruder, object oCharacter = OBJECT_SELF )
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAICombatRound Start", GetFirstPC() ); }
	
	//DBR 8/03/06 I am a puppet. I put nothing on the ActionQueue myself.
	if (CSLGetAssociateState(CSL_ASC_MODE_PUPPET)==TRUE)	
		return;
	
	//DBR 9/12/06 - If there are player-queued action on me, return.
	if (SCGetHasPlayerQueuedAction(oCharacter))
		return;
        

	if (GetIsObjectValid(oIntruder) == TRUE)
    {
        // If we're in the same party then we should all be friends.
        // Make sure rep is good, and continue doing whatever you were doing.
        if (GetFactionEqual(oIntruder, oCharacter) == TRUE )
        {
            //PrettyDebug("Damager was in my faction - aborting");
            ClearPersonalReputation( oIntruder, oCharacter );
            return;
        }
        
        // if this is not an enemy then continue doing whatever you were doing.
        // If the non-enemy damager is my current target, clear it - this can happen if he surrenders.
        if (GetIsEnemy(oIntruder) == FALSE)
        {
        	// * If someone has surrendered, then don't attack them.
            // * feb 25 2003
            if (GetAttackTarget(oCharacter) == oIntruder)
                ClearAllActions(TRUE);
            //ActionAttack(OBJECT_INVALID); // Effect???
            return;
        }
    }
	
	if ( ( CSLGetAssociateState(CSL_ASC_IS_BUSY) == TRUE ) ||
			//( SC GetAssociateState(CSL_ASC_MODE_STAND_GROUND) == TRUE ) ||
			( CSLGetAssociateState(CSL_ASC_MODE_DYING) == TRUE ) )
	{
		return;
	}

    // ****************************************
    // SETUP AND SANITY CHECKS (Quick Returns)
    // ****************************************

    // * BK: stop fighting if something bizarre that shouldn't happen, happens
    if ( SCEvaluationSanityCheck(oIntruder, CSLGetFollowDistance()) == TRUE )
	{
		return;
	}	
	
    // June 2/04: Fix for when henchmen is told to use stealth until next fight
	if ( GetLocalInt(oCharacter, "X2_HENCH_STEALTH_MODE") == 2 )
	{
		SetLocalInt( oCharacter, "X2_HENCH_STEALTH_MODE", 0 );
	}
	
	if ( SCBashDoorCheck(oIntruder) == TRUE )
	{
		return;
	}
	
    // * Store how difficult the combat is for this round	
	int nDiff = SCGetCombatDifficulty();
	SetLocalInt( oCharacter, "NW_L_COMBATDIFF", nDiff );
	
	object oMaster = CSLGetCurrentMaster();
	int bHasMaster = GetIsObjectValid( oMaster );

	// BMA-OEI 9/13/06: Player Queued Target override
	object oPreferredTarget = SCGetPlayerQueuedTarget( oCharacter );
	if ( ( GetIsObjectValid( oPreferredTarget ) == TRUE ) && 
			( GetIsDead( oPreferredTarget ) == FALSE ) &&
			( GetArea( oPreferredTarget ) == GetArea( oCharacter ) ) )
	{
		oIntruder = oPreferredTarget;
	}
	else
	{
		SCSetPlayerQueuedTarget( oCharacter, OBJECT_INVALID );
		
		if ( bHasMaster == TRUE )
		{
			// *******************************************
			// Healing
			// *******************************************
			// The FIRST PRIORITY: self-preservation
			// The SECOND PRIORITY: heal master;
			if ( SCCombatAttemptHeal() == TRUE )
			{
				return;
			}
			
			// NEXT priority: follow or return to master for up to three rounds.
			if ( SCCombatFollowMaster() == TRUE )
			{
				return;
			}
			
			//5. This check is to see if the master is being attacked and in need of help
			// * Guard Mode -- only attack if master attacking
			// * or being attacked.
			if ( CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER) == TRUE )
			{
				object oMasterIntruder = GetLastHostileActor( oMaster );
				
				if ( GetIsObjectValid(oMasterIntruder) == FALSE )
				{
					// MODIFIED Major change. Defend is now Defend only if I attack
					// February 11 2003
					oMasterIntruder = GetAttackTarget( oMaster );
				}
	
				if ( GetIsObjectValid(oMasterIntruder) == TRUE )
				{
					// BMA-OEI 10/20/06: Defend master against non-associates only
					if ( ( GetMaster(oCharacter) != oMasterIntruder ) &&
							( GetMaster(oMasterIntruder) != oCharacter ) )
					{
						SetLocalInt( oCharacter, "X0_BATTLEJOINEDMASTER", TRUE );
						oIntruder = oMasterIntruder;
					}
				}
			}
		}
	}
	
	// BMA-OEI 7/17/06 -- Find a suitable target
	// DBR 8/29/06 - commenting out, this is handled in SC DetermineCombatRound().
	/*if ( GetIsObjectValid(oIntruder) == FALSE )
	{
		oIntruder = GetAttackTarget( oCharacter );
		
		if ( GetIsObjectValid(oIntruder) == FALSE )
		{
			oIntruder = GetAttemptedSpellTarget();
			
			if ( ( GetIsObjectValid(oIntruder) == FALSE ) || ( GetIsEnemy(oIntruder) == FALSE ) )
			{
				oIntruder = GetNearestCreature( CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCharacter, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN );
			}
		}
	}*/

	//DBR 8/29/06 - also handled in SC DetermineCombatRound() - and this variable is never read anywhere! Only set.
	/*if ( GetIsObjectValid(oIntruder) == FALSE )
	{
		SetLocalInt( oCharacter, "X0_BATTLEJOINEDMASTER", FALSE );
		return;
	}*/
	
	if ( GetAssociateType(oCharacter) == ASSOCIATE_TYPE_HENCHMAN )
	{
		// 5% chance per round of laughing at the relative challenge of the encounter
		if ( ( nDiff <= 1 ) && ( d20() == 20 ) )
		{
			SCVoiceLaugh( TRUE );
		}
	}
/*	
	// BMA-OEI 7/18/06 -- Stop following if you've made it this far
	if ( GetCurrentAction(oCharacter) == ACTION_FOLLOW )
	{
		ClearAllActions();
	}
*/	
    // Fall through to generic combat
	SCAIDetermineCombatRound( oIntruder );
}



void SCAIRespondToShout(object oShouter, int nShoutIndex, object oIntruder = OBJECT_INVALID, int nBanInventory=FALSE, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAIRespondToShout Start", GetFirstPC() ); }
    
    // * if petrified, jump out
    if (CSLGetHasEffectType(oCharacter,EFFECT_TYPE_PETRIFY))
    {
        return;
    }
    // * MODIFIED February 19 2003
    // * Do not respond to shouts if in dying mode
    if (CSLGetAssociateState(CSL_ASC_MODE_DYING))
    {
        return;
    }
    // Pausanias: Do not respond to shouts if you've surrendered.
    int iSurrendered = GetLocalInt(oCharacter,"Generic_Surrender");
    if (iSurrendered) return;

    object oMaster = CSLGetCurrentMaster();

    switch (nShoutIndex)
    {
        // * toggle search mode for henchmen
        case ASSOCIATE_COMMAND_TOGGLESEARCH:
            if (GetActionMode(oCharacter, ACTION_MODE_DETECT))
            {
                SCRelayModeToAssociates(ACTION_MODE_DETECT, FALSE);
            }
            else
            {
                SCRelayModeToAssociates(ACTION_MODE_DETECT, TRUE);
            }
            break;
        // * toggle stealth mode for henchmen
        case ASSOCIATE_COMMAND_TOGGLESTEALTH:
            if (GetActionMode(oCharacter, ACTION_MODE_STEALTH))
            {
                SetActionMode(oCharacter, ACTION_MODE_STEALTH, FALSE);
                SCRelayModeToAssociates(ACTION_MODE_STEALTH, FALSE);
            }
            else
            {
                SetActionMode(oCharacter, ACTION_MODE_STEALTH, TRUE);
                SCRelayModeToAssociates(ACTION_MODE_STEALTH, TRUE);
            }
            break;
        // * June 2003: Stop spellcasting
        case ASSOCIATE_COMMAND_TOGGLECASTING:
            if (GetLocalInt(oCharacter, "X2_L_STOPCASTING") == 10)
            {
               // SpeakString("Was in no casting mode. Switching to cast mode");
                SetLocalInt(oCharacter, "X2_L_STOPCASTING", 0);
                SCVoiceCanDo();
            }
            else if (GetLocalInt(oCharacter, "X2_L_STOPCASTING") == 0)
            {
             //   SpeakString("Was in casting mode. Switching to NO cast mode");
                SetLocalInt(oCharacter, "X2_L_STOPCASTING", 10);
                SCVoiceCanDo();
            }
            break;
        case ASSOCIATE_COMMAND_INVENTORY:
            if (nBanInventory)
            {
                SpeakStringByStrRef(9066);
            }
            else
            {
                if (!GetLocalInt(oCharacter, "X2_JUST_A_DISABLEEQUIP"))
                {
                    SCClearWeaponStates();
                    // fix problem with unidentified equipped items
                    int i;
                    for(i = 0; i < NUM_INVENTORY_SLOTS; ++i)
                    {
                        //DEBUGGING// igDebugLoopCounter += 1;
                        object oItem = GetItemInSlot(i);
                        if (oItem != OBJECT_INVALID)
                        {
                            switch (GetBaseItemType(oItem))
                            {
                            case BASE_ITEM_CREATUREITEM:
                            case BASE_ITEM_CBLUDGWEAPON:
                            case BASE_ITEM_CSLASHWEAPON:
                            case BASE_ITEM_CSLSHPRCWEAP:
                            case BASE_ITEM_CPIERCWEAPON:
                                break;
                            default:
                                SetIdentified(oItem, TRUE);
                                break;
                            }
                        }
                    }
                    OpenInventory(oCharacter, oShouter);
                }
                else
                {
                    // * feedback as to why
                    SendMessageToPCByStrRef(oMaster, 100895);
                }
            }
            break;
        case ASSOCIATE_COMMAND_ATTACKNEAREST: //Used to de-activate AGGRESSIVE DEFEND MODE
			SCHenchAttackNearest();
			if (GetIsPC(oMaster))
			{
				// reset PC too
				CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, FALSE, oMaster);
				CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE, oMaster);
				DeleteLocalInt(oMaster, "DoNotAttack");
			}
            break;
        case ASSOCIATE_COMMAND_FOLLOWMASTER: //Only used to retreat, or break free from Stand Ground Mode
			SCHenchFollowMaster();
			if (GetIsPC(oMaster))
			{
				SetLocalInt(oMaster, "DoNotAttack", TRUE);
				DeleteLocalInt(oMaster, "Scouting");
				CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE, oMaster);
			}
            break;
        case ASSOCIATE_COMMAND_GUARDMASTER: //Used to activate AGGRESSIVE DEFEND MODE
			SCHenchGuardMaster();
			if (GetIsPC(oMaster))
			{
				DeleteLocalInt(oMaster, "DoNotAttack");
				//Companions will only attack the Masters Last Attacker
				CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, TRUE, oMaster);
				CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, FALSE, oMaster);
			}
            break;
        case ASSOCIATE_COMMAND_STANDGROUND: //No longer follow the master or guard him
			SCHenchStandGround();
			if (GetIsPC(oMaster))
			{		
				CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, TRUE, oMaster);
				CSLSetAssociateState(CSL_ASC_MODE_DEFEND_MASTER, FALSE, oMaster);
			}
            break;
        case ASSOCIATE_COMMAND_MASTERUNDERATTACK:  //Check whether the master has you in AGGRESSIVE DEFEND MODE
            if(!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) && !CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
            {
                // Familiars are not combat oriented and won't respond to Attack Nearest shouts.
                if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
                {
                    break;
                }
                //Check the henchmen's current target
                object oTarget = GetAttemptedAttackTarget();
                object oRealMaster = CSLGetCurrentMaster();
                if(!GetIsObjectValid(oTarget))
                {
                    oTarget = GetAttemptedSpellTarget();
                    if(!GetIsObjectValid(oTarget))
                    {
                        if(CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER))
                        {
                            SCHenchDetermineCombatRound(GetLastHostileActor(oRealMaster));
                        }
                        else
                        {
                            SCHenchDetermineCombatRound();
                        }
                    }
                }
                //Switch targets only if the target is not attacking the master and is greater than 6.0 from
                //the master.
                if(GetAttackTarget(oTarget) != oRealMaster && GetDistanceBetween(oTarget, oRealMaster) > 6.0)
                {
                    if(CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER) && GetIsObjectValid(GetLastHostileActor(oRealMaster)))
                    {
                        SCHenchDetermineCombatRound(GetLastHostileActor(oRealMaster));
                    }
                }
                SCRelayCommandToAssociates(nShoutIndex);
            }
            break;

        case ASSOCIATE_COMMAND_MASTERATTACKEDOTHER:
            if(!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) && !CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
            {
                // Familiars are not combat oriented and won't respond to Attack Nearest shouts.
                if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
                {
                    break;
                }
                if(!CSLGetAssociateState(CSL_ASC_MODE_DEFEND_MASTER))
                {
                    if(!SCGetIsFighting(oCharacter))
                    {
                        object oAttack = GetAttackTarget(CSLGetCurrentMaster());
                        if(GetIsObjectValid(oAttack))
                        {
                            SCHenchDetermineCombatRound(oAttack);
                        }
                    }
                    SCRelayCommandToAssociates(nShoutIndex);
                }
            }
            break;

        case ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED:
            if(!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND) && !CSLGetAssociateState(CSL_ASC_MODE_PUPPET))
            {
                // Familiars are not combat oriented and won't respond to Attack Nearest shouts.
                if (GetAssociateType(oCharacter) == ASSOCIATE_TYPE_FAMILIAR)
                {
                    break;
                }
                if(!SCGetIsFighting(oCharacter))
                {
                    object oAttacker = GetGoingToBeAttackedBy(CSLGetCurrentMaster());
                    if(GetIsObjectValid(oAttacker))
                    {
                        SCHenchDetermineCombatRound(oAttacker);
                    }
                }
                SCRelayCommandToAssociates(nShoutIndex);
            }
            break;

        case ASSOCIATE_COMMAND_HEALMASTER: //Ignore current healing settings and heal me now
            SCSetPlayerQueuedTarget(oCharacter, OBJECT_INVALID);
            SCHenchResetHenchmenState();
            SetLocalInt(oCharacter, "HenchCurHealCount", 1);
            SetLocalObject(oCharacter, "Henchman_Spell_Target", oMaster);
            SetLocalInt(oCharacter, "HenchHealType", HENCH_CNTX_MENU_HEAL);
            DeleteLocalInt(oCharacter, "HenchHealState");
            ExecuteScript("hench_o0_heal", oCharacter);
            break;

        case ASSOCIATE_COMMAND_PICKLOCK:
            SCOpenLock(SCGetLockedObject(oMaster));
            break;

        case ASSOCIATE_COMMAND_DISARMTRAP:
            SCForceTrap(GetNearestTrapToObject(oMaster));
            break;

        case ASSOCIATE_COMMAND_MASTERSAWTRAP:
		// implemented a different way that works with companions
//            if (!SC GetAssociateState(CSL_ASC_MODE_PUPPET))
//            {
//               SC HenchCheckArea(TRUE);
//            }
            break;

        case ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK: //Check local for Re-try locked doors and
            if ((!CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND)) && CSLGetAssociateState(CSL_ASC_RETRY_OPEN_LOCKS)
                && (!CSLGetAssociateState(CSL_ASC_MODE_PUPPET)))    //DBR 8/03/06 If I am a puppet. I put nothing on the ActionQueue myself.
            {
                SCOpenLock(SCGetLockedObject(oMaster));
            }
            {
                // send pick lock to familiar
                object oFamiliar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
                if (GetIsObjectValid(oFamiliar))
                {
                    AssignCommand(oFamiliar, SCAIRespondToShout(oCharacter, nShoutIndex));
                }
            }
            break;

        case ASSOCIATE_COMMAND_LEAVEPARTY:
            {
                string sTag = GetTag(GetArea(oMaster));
                // * henchman cannot be kicked out in the reaper realm
                // * Followers can never be kicked out
                if (sTag == "GatesofCania" || SCGetIsFollower(oCharacter) == TRUE)
                    return;

                if(GetIsObjectValid(oMaster))
                {
                    ClearAllActions();
                    if(GetAssociateType(oCharacter) == ASSOCIATE_TYPE_HENCHMAN)
                    {
                        SCAIFireHenchman(oMaster, oCharacter);
                    }
                }
                break;
            }

    }
}


int SCAIIsCachedCreatureInformationExpired(object oTarget, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 15) { CSLDebug(  "SCAIIsCachedCreatureInformationExpired Start "+GetName(oTarget), GetFirstPC() ); }
    
    int lastQueryTime = GetLocalInt(oTarget, "HenchLastEffectQuery");
    if (!lastQueryTime)
    {
        //DEBUGGING// if (DEBUGGING >= 15) { CSLDebug(  "SCAIIsCachedCreatureInformationExpired end TRUE", GetFirstPC() ); }
        return TRUE;
    }
    int lastEffectCheckDiff = GetTimeSecond() + 1 - lastQueryTime;
    if (lastEffectCheckDiff < 0)
    {
        lastEffectCheckDiff += 60;
    }
//  if (lastEffectCheckDiff > gICheckCreatureInfoStaleTime)
//  {
//  }
	//DEBUGGING// if (DEBUGGING >= 15) { CSLDebug(  "SCAIIsCachedCreatureInformationExpired end TRUE", GetFirstPC() ); }
    if ( lastEffectCheckDiff > gICheckCreatureInfoStaleTime )
    {
    	return TRUE;
    }
    return FALSE;
}






void SCAIInitCachedCreatureInformation(object oTarget, object oCharacter = OBJECT_SELF)
{
    //int iOldDebugging = DEBUGGING;
    HkCacheAIProperties( oTarget, TRUE );
    
    ////DEBUGGING// if (DEBUGGING > 0 && DEBUGGING < 10) { DEBUGGING = 10; }
    //DEBUGGING// if (DEBUGGING >= 15) { CSLDebug(  "SCAIInitCachedCreatureInformation Start "+GetName(oTarget), GetFirstPC() ); }
    
    int negEffects;
    int posEffects;
    int abilityMask;
    int attackBonus;
    int iSpellLevelProt = -1;
    int damageInformation;
    float fRangedConcealment;
    float fMeleeConcealment;
	int iRegenerationRate;
	
	float damageValuef;
	float fConcealment;
	int testAbility, abilityBitMask,abilityIncrease,abilityType;
	int acBitMask, acDecrease,acIncrease,acType;
	int damageType,damageValue;
	int regenRate, regenSpeed;
	int spellId,spellLevel,spellSchool,levelsAbsorbed,nSpellID;

	int iSpellSaveBonus = GetSkillRank(SKILL_SPELLCRAFT, oTarget, TRUE) / 5;
	
	
	//DEBUGGING// if (DEBUGGING >= 15) { CSLDebug(  "SCAIInitCachedCreatureInformation Effect Processing", GetFirstPC() ); }
	
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
    	//DEBUGGING// igDebugLoopCounter += 1;
//		{
//			int testSpellLevel0 = GetEffectInteger(eCheck, 0);
//			int testSpellLevel1 = GetEffectInteger(eCheck, 1);
//			int testSpellLevel2 = GetEffectInteger(eCheck, 2);
//			int testSpellLevel3 = GetEffectInteger(eCheck, 3);
//			int testSpellLevel4 = GetEffectInteger(eCheck, 4);
//			int testSpellLevelm1 = GetEffectInteger(eCheck, -1);
//		}


		// look at replacing the english names here with constants from the DMFI for use in translations.
		int iEffectId = GetEffectType(eCheck);
		switch ( iEffectId/10)
		{
			case 7: // this is out of order to make visual effects go faster
					switch ( iEffectId )
					{
						case EFFECT_TYPE_VISUALEFFECT: // this is out of order since it's used so much, should reduce the total number of operations quite a bit
							break;
						case EFFECT_TYPE_ULTRAVISION:
							posEffects |= HENCH_EFFECT_TYPE_ULTRAVISION;
							break;
						case EFFECT_TYPE_MISS_CHANCE:
							break;
						case EFFECT_TYPE_CONCEALMENT:
							posEffects |= HENCH_EFFECT_TYPE_CONCEALMENT;
							{
								fConcealment = IntToFloat(GetEffectInteger(eCheck, 0)) / 100.0;
								nSpellID = GetEffectSpellId(eCheck);
								if ((nSpellID != 945) && (nSpellID != SPELL_I_ENTROPIC_WARDING) &&
									(nSpellID != SPELL_STORM_AVATAR) &&  (nSpellID != SPELL_ENTROPIC_SHIELD))
								{
									if (fConcealment > fMeleeConcealment)
									{
										fMeleeConcealment = fConcealment;
									}
								}
								if (fConcealment > fRangedConcealment)
								{
									fRangedConcealment = fConcealment;
								}
							}
							break;
						case EFFECT_TYPE_SPELL_IMMUNITY:
							break;
						case EFFECT_TYPE_DISAPPEARAPPEAR:
							break;
						case EFFECT_TYPE_SWARM:
							break;
						case EFFECT_TYPE_TURN_RESISTANCE_DECREASE:
							break;
						case EFFECT_TYPE_TURN_RESISTANCE_INCREASE:
							break;
						case EFFECT_TYPE_PETRIFY:
							negEffects |= HENCH_EFFECT_TYPE_PETRIFY;
							break;
					}
					break;
			
			case 0:
					// add psionic if there is a need
					switch ( iEffectId )
					{
						case EFFECT_TYPE_INVALIDEFFECT:
							break;
						case EFFECT_TYPE_DAMAGE_RESISTANCE:
							{
								damageType =  GetEffectInteger(eCheck, 0);
								damageValue = GetEffectInteger(eCheck, 1);
								if (damageInformation & damageType)
								{
									damageValue += CSLDataArray_GetInt(oTarget, "HenchDamageResist", damageType);
								}
								else
								{
									damageInformation |= damageType;
									CSLDataArray_SetFloat(oTarget, "HenchDamageImmunity", damageType, 1.0);
								}
								CSLDataArray_SetInt(oTarget, "HenchDamageResist", damageType, damageValue);
							}
							break;
						case EFFECT_TYPE_REGENERATE:
							posEffects |= HENCH_EFFECT_TYPE_REGENERATE;			
							{
								regenRate = GetEffectInteger(eCheck, 0);
								regenSpeed = GetEffectInteger(eCheck, 1);
								if (regenSpeed)
								{
									iRegenerationRate += regenRate * 24000 /* HENCH_AI_REGEN_RATE_ROUNDS * 6000 */ / regenSpeed;
								}
							}
							break;
						case EFFECT_TYPE_DAMAGE_REDUCTION:
							posEffects |= HENCH_EFFECT_TYPE_DAMAGE_REDUCTION;
							break;
						case EFFECT_TYPE_TEMPORARY_HITPOINTS:
							posEffects |= HENCH_EFFECT_TYPE_TEMPORARY_HITPOINTS;
							break;
					}
					break;
			case 1:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_ENTANGLE:
							negEffects |= HENCH_EFFECT_TYPE_ENTANGLE;
							break;
						case EFFECT_TYPE_INVULNERABLE:
							break;
						case EFFECT_TYPE_DEAF:
							negEffects |= HENCH_EFFECT_TYPE_DEAF;
							break;
						case EFFECT_TYPE_RESURRECTION:
							break;
						case EFFECT_TYPE_IMMUNITY:
							break;
						case EFFECT_TYPE_ENEMY_ATTACK_BONUS:
							break;
						case EFFECT_TYPE_ARCANE_SPELL_FAILURE:
							break;
					}
					break;
			case 2:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_AREA_OF_EFFECT:
							break;
						case EFFECT_TYPE_BEAM:
							break;
						case EFFECT_TYPE_CHARMED:
							negEffects |= HENCH_EFFECT_TYPE_CHARMED;
							break;
						case EFFECT_TYPE_CONFUSED:
							negEffects |= HENCH_EFFECT_TYPE_CONFUSED;
							break;
						case EFFECT_TYPE_FRIGHTENED:
							negEffects |= HENCH_EFFECT_TYPE_FRIGHTENED;
							break;
						case EFFECT_TYPE_DOMINATED:
							negEffects |= HENCH_EFFECT_TYPE_DOMINATED;
							break;
						case EFFECT_TYPE_PARALYZE:
							negEffects |= HENCH_EFFECT_TYPE_PARALYZE;
							break;
						case EFFECT_TYPE_DAZED:
							negEffects |= HENCH_EFFECT_TYPE_DAZED;
							break;
						case EFFECT_TYPE_STUNNED:
							negEffects |= HENCH_EFFECT_TYPE_STUNNED;
							break;
					}
					break;
			case 3:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_SLEEP:
							negEffects |= HENCH_EFFECT_TYPE_SLEEP;
							break;
						case EFFECT_TYPE_POISON:
							negEffects |= HENCH_EFFECT_TYPE_POISON;
							break;
						case EFFECT_TYPE_DISEASE:
							negEffects |= HENCH_EFFECT_TYPE_DISEASE;
							break;
						case EFFECT_TYPE_CURSE:
							negEffects |= HENCH_EFFECT_TYPE_CURSE;
							break;
						case EFFECT_TYPE_SILENCE:
							negEffects |= HENCH_EFFECT_TYPE_SILENCE;
							break;
						case EFFECT_TYPE_TURNED:
							break;
						case EFFECT_TYPE_HASTE:
							posEffects |= HENCH_EFFECT_TYPE_HASTE;
							break;
						case EFFECT_TYPE_SLOW:
							negEffects |= HENCH_EFFECT_TYPE_SLOW;			
							
							// slow decreases dodge and attack bonus by 1
							acBitMask = 1 << (AC_DODGE_BONUS + HENCH_AC_INCREASE_OFFSET);
							if (abilityMask & acBitMask)
							{
								testAbility = CSLDataArray_GetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS);
								CSLDataArray_SetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS, testAbility - 1);
							}
							else
							{
								abilityMask |= acBitMask;
								CSLDataArray_SetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS, -1);
							}
							attackBonus--;
							
							break;
						case EFFECT_TYPE_ABILITY_INCREASE:
							posEffects |= HENCH_EFFECT_TYPE_ABILITY_INCREASE;
							if (GetEffectSpellId(eCheck) != SPELLABILITY_BARBARIAN_RAGE)
							{
								abilityType = GetEffectInteger(eCheck, 0);
								abilityIncrease = GetEffectInteger(eCheck, 1);
								abilityBitMask = 1 << abilityType;
				
								if (abilityMask & abilityBitMask)
								{
									testAbility = CSLDataArray_GetInt(oTarget, "HenchAbilityIncrease", abilityType);
									if (testAbility < abilityIncrease)
									{
										CSLDataArray_SetInt(oTarget, "HenchAbilityIncrease", abilityType, abilityIncrease);
									}
								}
								else
								{
									abilityMask |= abilityBitMask;
									CSLDataArray_SetInt(oTarget, "HenchAbilityIncrease", abilityType, abilityIncrease);
								}
							}
							break;
						case EFFECT_TYPE_ABILITY_DECREASE:
							if (!(GetFactionEqual(GetEffectCreator(eCheck), oTarget) || GetIsFriend(GetEffectCreator(eCheck), oTarget)))
							{
								negEffects |= HENCH_EFFECT_TYPE_ABILITY_DECREASE;
							}
							break;
							break;
					}
					break;
			case 4:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_ATTACK_INCREASE:
							attackBonus += GetEffectInteger(eCheck, 0);
							posEffects |= HENCH_EFFECT_TYPE_ATTACK_INCREASE;
							break;
						case EFFECT_TYPE_ATTACK_DECREASE:
							if (!(GetFactionEqual(GetEffectCreator(eCheck), oTarget) || GetIsFriend(GetEffectCreator(eCheck), oTarget)))
							{
								negEffects |= HENCH_EFFECT_TYPE_ATTACK_DECREASE;
							}
							attackBonus -= GetEffectInteger(eCheck, 0);
							break;
						case EFFECT_TYPE_DAMAGE_INCREASE:
							posEffects |= HENCH_EFFECT_TYPE_DAMAGE_INCREASE;
							break;
						case EFFECT_TYPE_DAMAGE_DECREASE:
							negEffects |= HENCH_EFFECT_TYPE_DAMAGE_DECREASE;
							break;
						case EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE:
							{
								damageType =  GetEffectInteger(eCheck, 0);
								damageValuef = - IntToFloat(GetEffectInteger(eCheck, 1)) / 100.0;
								if (damageInformation & damageType)
								{
									damageValuef += CSLDataArray_GetFloat(oTarget, "HenchDamageImmunity", damageType);
								}
								else
								{
									damageValuef += 1.0;
									damageInformation |= damageType;
									CSLDataArray_SetInt(oTarget, "HenchDamageResist", damageType, 0);
								}
								CSLDataArray_SetFloat(oTarget, "HenchDamageImmunity", damageType, damageValuef);
							}
							break;
						case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
							break;
						case EFFECT_TYPE_AC_INCREASE:
							posEffects |= HENCH_EFFECT_TYPE_AC_INCREASE;
							
							acType = GetEffectInteger(eCheck, 0);
							acIncrease = GetEffectInteger(eCheck, 1);
							acBitMask = 1 << (acType + HENCH_AC_INCREASE_OFFSET);
			
							if (abilityMask & acBitMask)
							{
								testAbility = CSLDataArray_GetInt(oTarget, "HenchACIncrease", acType);
								if (acType == AC_DODGE_BONUS)
								{
									CSLDataArray_SetInt(oTarget, "HenchACIncrease", acType, testAbility + acIncrease);
								}
								else if (testAbility < acIncrease)
								{
									CSLDataArray_SetInt(oTarget, "HenchACIncrease", acType, acIncrease);
								}
							}
							else
							{
								abilityMask |= acBitMask;
								CSLDataArray_SetInt(oTarget, "HenchACIncrease", acType, acIncrease);
							}
							
							break;
						case EFFECT_TYPE_AC_DECREASE:
							if (!(GetFactionEqual(GetEffectCreator(eCheck), oTarget) || GetIsFriend(GetEffectCreator(eCheck), oTarget)))
							{
								negEffects |= HENCH_EFFECT_TYPE_AC_DECREASE;
							}
							{
								acDecrease = - GetEffectInteger(eCheck, 1);
								acBitMask = 1 << (/* AC_DODGE_BONUS + */ HENCH_AC_INCREASE_OFFSET);
								if (abilityMask & acBitMask)
								{
									testAbility = CSLDataArray_GetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS);
									CSLDataArray_SetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS, testAbility + acDecrease);
								}
								else
								{
									abilityMask |= acBitMask;
									CSLDataArray_SetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS, acDecrease);
								}   			
							}	
							break;
						case EFFECT_TYPE_MOVEMENT_SPEED_INCREASE:
							break;
						case EFFECT_TYPE_MOVEMENT_SPEED_DECREASE:
							if (!(GetFactionEqual(GetEffectCreator(eCheck), oTarget) || GetIsFriend(GetEffectCreator(eCheck), oTarget)))
							{
								negEffects |= HENCH_EFFECT_TYPE_MOVEMENT_SPEED_DECREASE;
							}
							break;
					}
					break;
			case 5:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_SAVING_THROW_INCREASE:
							posEffects |= HENCH_EFFECT_TYPE_SAVING_THROW_INCREASE;
							if (GetEffectInteger(eCheck, 2) == SAVING_THROW_TYPE_SPELL)
							{
								iSpellSaveBonus += GetEffectInteger(eCheck, 0);				
							}
							break;
						case EFFECT_TYPE_SAVING_THROW_DECREASE:
							negEffects |= HENCH_EFFECT_TYPE_SAVING_THROW_DECREASE;
							break;
						case EFFECT_TYPE_SPELL_RESISTANCE_INCREASE:
							break;
						case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
							break;
						case EFFECT_TYPE_SKILL_INCREASE:
							break;
						case EFFECT_TYPE_SKILL_DECREASE:
							negEffects |= HENCH_EFFECT_TYPE_SKILL_DECREASE;
							break;
						case EFFECT_TYPE_INVISIBILITY:
							posEffects |= HENCH_EFFECT_TYPE_INVISIBILITY;
							break;
						case EFFECT_TYPE_GREATERINVISIBILITY:
							posEffects |= HENCH_EFFECT_TYPE_GREATER_INVIS;
							break;
						case EFFECT_TYPE_DARKNESS:
							break;
						case EFFECT_TYPE_DISPELMAGICALL:
							break;
					}
					break;
			case 6:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_ELEMENTALSHIELD:
							posEffects |= HENCH_EFFECT_TYPE_ELEMENTALSHIELD;
							break;
						case EFFECT_TYPE_NEGATIVELEVEL:
							negEffects |= HENCH_EFFECT_TYPE_NEGATIVELEVEL;
							break;
						case EFFECT_TYPE_POLYMORPH:
							posEffects |= HENCH_EFFECT_TYPE_POLYMORPH;
							SetLocalInt(oCharacter, "HenchPolymorphType", GetEffectInteger(eCheck, 0));
							if (GetEffectInteger(eCheck, 3))
							{
								posEffects |= HENCH_EFFECT_TYPE_WILDSHAPE;
							}
							//          {
							//              int testSpellLevel0 = GetEffectInteger(eCheck, 0);
							//              int testSpellLevel1 = GetEffectInteger(eCheck, 1);
							//              int testSpellLevel2 = GetEffectInteger(eCheck, 2);
							//              int testSpellLevel3 = GetEffectInteger(eCheck, 3);
							//          }
							break;
						case EFFECT_TYPE_SANCTUARY:
							{
								// unable to tell apart - use spell id
								spellId = GetEffectSpellId(eCheck);
								if ((spellId == 724 /* ethereal jaunt */) || (spellId == SPELL_ETHEREALNESS))
								{
									posEffects |= HENCH_EFFECT_TYPE_ETHEREAL;
								}
								else
								{
									posEffects |= HENCH_EFFECT_TYPE_SANCTUARY;
								}
							}
							break;
						case EFFECT_TYPE_TRUESEEING:
							posEffects |= HENCH_EFFECT_TYPE_TRUESEEING;
							break;
						case EFFECT_TYPE_SEEINVISIBLE:
							posEffects |= HENCH_EFFECT_TYPE_SEEINVISIBILE;
							break;
						case EFFECT_TYPE_TIMESTOP:
							posEffects |= HENCH_EFFECT_TYPE_TIMESTOP;
							break;
						case EFFECT_TYPE_BLINDNESS:
							negEffects |= HENCH_EFFECT_TYPE_BLINDNESS;
							break;
						case EFFECT_TYPE_SPELLLEVELABSORPTION:
							posEffects |= HENCH_EFFECT_TYPE_SPELLLEVELABSORPTION;
							
							levelsAbsorbed = GetEffectInteger(eCheck, 1);				
							if (levelsAbsorbed == 0)
							{
								spellSchool = GetEffectInteger(eCheck, 2);
								if (spellSchool == SPELL_SCHOOL_GENERAL)
								{
									spellLevel = GetEffectInteger(eCheck, 0);
									if (spellLevel > iSpellLevelProt)
									{
										iSpellLevelProt = spellLevel;
									}
								}
								else if (spellSchool == SPELL_SCHOOL_NECROMANCY)
								{
									posEffects |= HENCH_EFFECT_TYPE_IMMUNE_NECROMANCY;
								}				
							}
							else
							{
								posEffects |= HENCH_EFFECT_TYPE_SPELL_SHIELD;
							}
							
							break;
						case EFFECT_TYPE_DISPELMAGICBEST:
							break;
					}
					break;
			case 8:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_CUTSCENE_PARALYZE:
							if ( GetEffectSpellId(eCheck) == SPELL_MERCY )
							{
								negEffects |= HENCH_EFFECT_DISABLED;
							}
						
							negEffects |= HENCH_EFFECT_TYPE_CUTSCENE_PARALYZE;
							break;
						case EFFECT_TYPE_ETHEREAL:
							posEffects |= HENCH_EFFECT_TYPE_ETHEREAL;
							break;
						case EFFECT_TYPE_SPELL_FAILURE:
							// negEffects |= HENCH_EFFECT_TYPE_SPELL_FAILURE;
							if (oTarget == oCharacter)
							{
								gfSpellFailureChance += IntToFloat(GetEffectInteger(eCheck, 0)) / 100.0 * (1.0 - gfSpellFailureChance);
							}
							break;
						case EFFECT_TYPE_CUTSCENEGHOST:
							break;
						case EFFECT_TYPE_CUTSCENEIMMOBILIZE:
							break;
						case EFFECT_TYPE_BARDSONG_SINGING:
							break;
						case EFFECT_TYPE_HIDEOUS_BLOW:
							break;
						case EFFECT_TYPE_NWN2_DEX_ACMOD_DISABLE:
							break;
						case EFFECT_TYPE_DETECTUNDEAD:
							break;
						case EFFECT_TYPE_SHAREDDAMAGE:
							break;
					}
					break;
			case 9:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_ASSAYRESISTANCE:
							break;
						case EFFECT_TYPE_DAMAGEOVERTIME:
							break;
						case EFFECT_TYPE_ABSORBDAMAGE:
							posEffects |= HENCH_EFFECT_TYPE_ABSORBDAMAGE;
							break;
						case EFFECT_TYPE_AMORPENALTYINC:
							break;
						case EFFECT_TYPE_DISINTEGRATE:
							break;
						case EFFECT_TYPE_HEAL_ON_ZERO_HP:
							break;
						case EFFECT_TYPE_BREAK_ENCHANTMENT:
							break;
						case EFFECT_TYPE_MESMERIZE:
							negEffects |= HENCH_EFFECT_TYPE_MESMERIZE;
							break;
						case EFFECT_TYPE_ON_DISPEL:
							break;
						case EFFECT_TYPE_BONUS_HITPOINTS:
							break;
					}
					break;
			case 10:
					switch ( iEffectId )
					{
						case EFFECT_TYPE_JARRING:
							break;
						case EFFECT_TYPE_MAX_DAMAGE:
							break;
						case EFFECT_TYPE_WOUNDING:
							break;
						case EFFECT_TYPE_WILDSHAPE:
							break;
						case EFFECT_TYPE_EFFECT_ICON:
							break;
						case EFFECT_TYPE_RESCUE:
							break;
						case EFFECT_TYPE_DETECT_SPIRITS:
							break;
						case EFFECT_TYPE_DAMAGE_REDUCTION_NEGATED:
							break;
						case EFFECT_TYPE_CONCEALMENT_NEGATED:
							break;
						case EFFECT_TYPE_INSANE:
							break;
					}
					break;
			case 11:
					if ( iEffectId == EFFECT_TYPE_HITPOINT_CHANGE_WHEN_DYING ) 
					{
						// do nothing, not even in list; 
					}
					break;
		}
        eCheck = GetNextEffect(oTarget);
    }
    //DEBUGGING// if (DEBUGGING >= 15) { CSLDebug(  "SCAIInitCachedCreatureInformation Effect Processing End", GetFirstPC() ); }
	
	// go ahead and save effects, if it did this half way, it should keep it from running over and over
	// this is to help out incase there are so many items that things TMI on me
	SetLocalInt(oTarget, "HenchCurPosEffects", posEffects);
    SetLocalInt(oTarget, "HenchCurNegEffects", negEffects);
    SetLocalInt(oTarget, "HenchAbilityIncrease", abilityMask);
    SetLocalInt(oTarget, "HenchAttackBonus", attackBonus);
    SetLocalInt(oTarget, "HenchSpellLevelProtect", iSpellLevelProt);
    SetLocalInt(oTarget, "HenchDamageInformation", damageInformation);
    SetLocalFloat(oTarget, "HenchRangedConcealment", fRangedConcealment);
    SetLocalFloat(oTarget, "HenchMeleeConcealment", fMeleeConcealment);
	SetLocalInt(oTarget, "HenchRegenerationRate", iRegenerationRate);
	SetLocalInt(oTarget, "HenchSpellSaveBonus", iSpellSaveBonus);
	
    SetLocalInt(oTarget, "HenchLastEffectQuery", GetTimeSecond() + 1);

	CSLCacheCreatureItemInformation( oTarget ); // make sure cache is still available
	
	posEffects != GetLocalInt(oTarget, "SC_ITEM_POSITIVE_EFFECTS" );
    negEffects != GetLocalInt(oTarget, "SC_ITEM_NEGATIVE_EFFECTS" );
    
    
    GetLocalInt(oTarget, "SC_ITEM_AC_TOTAL" );
    //GetLocalInt(oTarget, "SC_ITEM_AC_TOTAL_TOUCH" );
    //GetLocalInt(oTarget, "SC_ITEM_AC_TOTAL_FLATFOOTED" );
    
    CSLMaxLocalInt(oTarget, "HenchACIncrease"+IntToString(AC_DODGE_BONUS), GetLocalInt(oTarget, "SC_ITEM_AC_DODGE" ), TRUE );
    CSLMaxLocalInt(oTarget, "HenchACIncrease"+IntToString(AC_NATURAL_BONUS), GetLocalInt(oTarget, "SC_ITEM_AC_NATURAL" ), TRUE );
    CSLMaxLocalInt(oTarget, "HenchACIncrease"+IntToString(AC_ARMOUR_ENCHANTMENT_BONUS), GetLocalInt(oTarget, "SC_ITEM_AC_ARMOR" ), TRUE );
    CSLMaxLocalInt(oTarget, "HenchACIncrease"+IntToString(AC_SHIELD_ENCHANTMENT_BONUS), GetLocalInt(oTarget, "SC_ITEM_AC_SHIELD" ), TRUE );
    CSLMaxLocalInt(oTarget, "HenchACIncrease"+IntToString(AC_DEFLECTION_BONUS), GetLocalInt(oTarget, "SC_ITEM_AC_DEFLECTION" ), TRUE );
    
    
    
    int iDamageItemInfoMask = GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_TYPES"  );
    if ( iDamageItemInfoMask != 0 )
    {
		damageInformation |= iDamageItemInfoMask;
		
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_MAGICAL), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_MAGICAL) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_ACID), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_ACID) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_COLD), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_COLD) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_DIVINE), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_DIVINE) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_ELECTRICAL), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_ELECTRICAL) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_FIRE), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_FIRE) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_NEGATIVE), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_NEGATIVE) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_POSITIVE), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_POSITIVE) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchDamageResist"+IntToString(DAMAGE_TYPE_SONIC), GetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_SONIC) ), TRUE );
		
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString(DAMAGE_TYPE_MAGICAL), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_MAGICAL) ), TRUE );
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString(DAMAGE_TYPE_ACID), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_ACID) ), TRUE );
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString((DAMAGE_TYPE_COLD)), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString((DAMAGE_TYPE_COLD)) ), TRUE );
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString(DAMAGE_TYPE_DIVINE), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_DIVINE) ), TRUE );
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString(DAMAGE_TYPE_ELECTRICAL), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_ELECTRICAL) ), TRUE );
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString(DAMAGE_TYPE_FIRE), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_FIRE) ), TRUE );
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString(DAMAGE_TYPE_NEGATIVE), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_NEGATIVE) ), TRUE );
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString(DAMAGE_TYPE_POSITIVE), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_POSITIVE) ), TRUE );
		CSLMaxLocalFloat(oTarget, "HenchDamageImmunity"+IntToString(DAMAGE_TYPE_SONIC), GetLocalFloat(oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_SONIC) ), TRUE );
    }
    
    int iAbilityItemInfoMask = GetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_TYPES");
    if ( iAbilityItemInfoMask != 0 )
    {
		abilityMask |= iAbilityItemInfoMask;
		CSLMaxLocalInt(oTarget, "HenchAbilityIncrease"+IntToString(ABILITY_STRENGTH), GetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_STRENGTH) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchAbilityIncrease"+IntToString(ABILITY_DEXTERITY), GetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_DEXTERITY) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchAbilityIncrease"+IntToString(ABILITY_CONSTITUTION), GetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_CONSTITUTION) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchAbilityIncrease"+IntToString(ABILITY_INTELLIGENCE), GetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_INTELLIGENCE) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchAbilityIncrease"+IntToString(ABILITY_WISDOM), GetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_WISDOM) ), TRUE );
		CSLMaxLocalInt(oTarget, "HenchAbilityIncrease"+IntToString(ABILITY_CHARISMA), GetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_CHARISMA) ), TRUE );		
	}
	// GetLocalInt( oTarget, "SC_ITEM_SR" ); // not used yet
	iSpellLevelProt = CSLGetMax( GetLocalInt( oTarget, "SC_ITEM_SPELLIMMUNITY_BY_LEVEL" ) );
	//GetLocalInt(oTarget, "SC_ITEM_IMMUNITY_SCHOOLS" );
    //GetLocalInt(oTarget, "SC_ITEM_IMMUNITY_SPELLS" );
	iRegenerationRate += GetLocalInt(oTarget, "SC_ITEM_REGENERATION_RATE" );
	//DEBUGGING// if (DEBUGGING >= 15) { CSLDebug(  "SCAIInitCachedCreatureInformation Item Processing End", GetFirstPC() ); }
	
	
    if (posEffects & HENCH_EFFECT_TYPE_HASTE)
    {
        //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAIInitCachedCreatureInformation Haste Processing", GetFirstPC() ); }
        // haste increased dodge and attack bonus by 1
        int acBitMask = 1 << (AC_DODGE_BONUS + HENCH_AC_INCREASE_OFFSET);
        if (abilityMask & acBitMask)
        {
            int testAbility = CSLDataArray_GetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS);
            CSLDataArray_SetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS, testAbility + 1);
        }
        else
        {
            abilityMask |= acBitMask;
            CSLDataArray_SetInt(oTarget, "HenchACIncrease", AC_DODGE_BONUS, 1);
        }
        attackBonus++;
    }

    if (GetImmortal(oTarget) && (GetCurrentHitPoints(oTarget) <= 10))
    {
        //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAIInitCachedCreatureInformation Immortal Processing", GetFirstPC() ); }
        int bNotATroll = GetEventHandler(oTarget, CREATURE_SCRIPT_ON_DAMAGED) != "gb_troll_dmg";
        int damageType = DAMAGE_TYPE_BLUDGEONING; // 1
        while (damageType <= DAMAGE_TYPE_SONIC) // 2048
        {
            //DEBUGGING// igDebugLoopCounter += 1;
            // a troll with low hitpoints resistant to everything but acid and fire
            if (bNotATroll || ((damageType != DAMAGE_TYPE_ACID) && (damageType != DAMAGE_TYPE_FIRE)))
            {
                if (!(damageInformation & damageType))
                {
                    damageInformation |= damageType;
                    CSLDataArray_SetInt(oTarget, "HenchDamageResist", damageType, 0);
                }
                CSLDataArray_SetFloat(oTarget, "HenchDamageImmunity", damageType, 0.0);
            }
            damageType *= 2;
        }
    }

    SetLocalInt(oTarget, "HenchCurPosEffects", posEffects);
    SetLocalInt(oTarget, "HenchCurNegEffects", negEffects);
    SetLocalInt(oTarget, "HenchAbilityIncrease", abilityMask);
    SetLocalInt(oTarget, "HenchAttackBonus", attackBonus);
    SetLocalInt(oTarget, "HenchSpellLevelProtect", iSpellLevelProt);
    SetLocalInt(oTarget, "HenchDamageInformation", damageInformation);
    SetLocalFloat(oTarget, "HenchRangedConcealment", fRangedConcealment);
    SetLocalFloat(oTarget, "HenchMeleeConcealment", fMeleeConcealment);
	SetLocalInt(oTarget, "HenchRegenerationRate", iRegenerationRate);
	SetLocalInt(oTarget, "HenchSpellSaveBonus", iSpellSaveBonus);
	
    SetLocalInt(oTarget, "HenchLastEffectQuery", GetTimeSecond() + 1);
    //DEBUGGING// if (DEBUGGING >= 15) { CSLDebug(  "SCAIInitCachedCreatureInformation End", GetFirstPC() ); }
    
    //DEBUGGING = iOldDebugging; // set this back
}



/*
TacticalState - controls tactics

Afraid - runs or the like, using spells to hide and run, teleport and the like

Confused - acts in a random manner

Mob - acts as a swarm or large group

Defensive - focuses on buffing and preventing getting hurt

Protective - focuses on protecting a given target

Aggressive - ranged - prefers ranged attacks

Aggressive - melee

Squad - melee in a formation5

Overconfidence - does not try that hard, uses less than great attacks and defenses


spell cache information

1. inventory items

1. Direct Attack Type Spells
   WillSave or disable
   FortSave or disable
   ReflexSave or disable
   GrappleStreSave or disable
   Fire Damage
   Cold Damage
   Negative Damage
   Sonic Damage
   Divine or other Damage
   Ability Drain Damage

2. Battlefield Control AOE's - used to control the situation
   Darkness

3. Defensive Buffs


4. Mitigating Attacks - Counterspelling, removing effects


5. Healing



*/



/*	Overland Map include file
	JH/EF-OEI: 01/16/08
	NLC: 2/4/08 - added tons of new functions and reformatted
	NLC: 6/29/08 - adding goodie system, moving constants to ginc_overland_constants
	JSH-OEI 7/11/08 - Commented out line in SpawnSpecialEncounter which was breaking stuff.
*/
#include "_CSLCore_Math"
#include "_CSLCore_Strings"
#include "_CSLCore_Player"
#include "_SCInclude_Group"
#include "_SCInclude_Overland_c"

//#include "nw_i0_generic"
//#include "nw_i0_plot"
//#include "ginc_debug"
//#include "ginc_math"

//#include "ginc_item"
//#include "ginc_2da"

#include "_CSLCore_Messages"
//#include "ginc_combat"

#include "_SCInclude_Waypoints"
#include "_SCInclude_Clock"

//#include "ginc_2da"

//Function Prototypes------------------------------

//Terrain
int GetCurrentPCTerrain();
int GetNumTerrainMaps(int nTerrain);
int GetTerrainType(object oTrigger);
int GetTerrainAtLocation(location lLocation);
float GetTerrainMovementRate(int nTerrainType);
float GetTerrainModifiedRate(object oCreature, int nTerrainType);
string GetTerrainWPPrefix(int nTerrain);
string GetTerrainAudioTrack(int nTerrainType);
object GetNearestTerrainTrigger(object oPC);

//Encounters
int GetNumValidRows(string sTable);
int GetEncounterRow(string sTable);
int GetNumHostileEncounters(object oArea = OBJECT_SELF);
int GetEncounterXP(int nPartyCR, int nEncEL);
void AwardEncounterXP(int nXP);
string GetEncounterConversation();
string GetEncounterRR(string sTable, int nRow);
string GetEncounterTable(object oEncounterSource);	//EncounterSource can be a trigger or an area
int SetEncounterBribeValue(object oEncounter);
int ModEncounterBribeValue(float fModPercent);

//Special Encounters
string GetSpecialEncounterTable(object oArea = OBJECT_SELF);
int GetSpecialEncounterRow(string sTable);
object SpawnSpecialEncounter(string sTable, location lLocation);

//PartyActorFunctions
object SetPartyActor(object oNewActor, object oCurrentOverride = OBJECT_INVALID);
void DisplayChallengeRating(object oPC, object oCreature);
int GetPartyChallengeRating();

//Player Location Functions
void StorePlayerMapLocation(object oPC);
void RestorePlayerMapLocation(object oPC);
location GetGlobalLocation(string sVar);
void SetGlobalLocation(string sVar, location lTarget);
void SetCurrentPCTerrain(int nTerrain);

//Random Encounter Setup Functions
void BeginRandomWalk();
void MoveEncounterToSpawnLocation(object oEncounter, object oPC);
int InitializeEncounter(object oPC);
location GetEncounterSpawnLocation(object oPC, float fSpotDistance);
location CreateTestEncounterSpawnLocation(object oPC, float fDist = 8.0f);
object CreateEncounterNearPC(object oPC);
void SetEncounterLocalVariables(object oEncounter, string sEncounterTable, int nRow);

//Neutral Encounter Setup Functions
void InitializeNeutralEncounter(object oPC, object oArea = OBJECT_SELF);
int GetCurrentEncounterPopulation(object oPC, string sEncounterTag);
int GetEncounterMaxPopulation(string sTable, int nRow);

//Special Encounter Setup Functions
void InitializeSpecialEncounter(object oPC);
void ResetSpecialEncounterTimer(object oArea = OBJECT_SELF);
void SetSEStartLocation(location lLocation, object oSE = OBJECT_SELF);
location GetSEStartLocation(object oSE = OBJECT_SELF);

//Secret Location Tag Parsing Functions
string GetTravelPlaceableResRef(object oIpoint = OBJECT_SELF);
string GetDestWPTag(object oPlaceable = OBJECT_SELF);
string GetExitWPTag(object oPlaceable = OBJECT_SELF);

//Random Encounter Dialog Skill Use Effects
effect EffectShaken();
effect EffectOffGuard();

//OLMap Transition Functions
void ExitOverlandMap(object oPC);

//Goodie Functions

void GerminateGoodies( int nTotal, object oArea = OBJECT_SELF);
string GetGoodieTable(object oSeed);
int GetIsGoodieValidForTerrain(string sGoodieTable, int nRow, int nTerrain);
location GetGoodieLocation(object oSeed);
int CreateGoodie(object oSeed);
void SetGoodieData(object oGoodie, string sGoodieTable, int nRow);
int GetGoodieRow(string sTable);

//OLMap UI Functions

//Activates the OL Map UI for oPC. This closes the default UI Elements that are intended to be hidden 
//on the OL Map and opens the new OL UI objects for the pc.
void ActivateOLMapUI(object oPC);

//Deactivates the OL Map UI for oPC. This closes the OL Map UI Elements 
//and re-opens the default UI objects for the PC.
void DeactivateOLMapUI(object oPC);


//Getters - Functions for other systems to read into the AI state of creatures/
int GetIsActorChasing(object oEnc);

//Utility Functions
void RemoveAggroVFX(object oEnc = OBJECT_SELF);
void RunStateManager(object oPC);
void PursueParty(object oPC);
void SetOLBehaviorState(int nBehaviorState, object oEnc = OBJECT_SELF);
void SetEncounterFlagAfraid(object oEnc);
int GetIsSearchSuccessful(object oPC, object oEnc = OBJECT_SELF);
int GetIsEncounterScared(object oEnc = OBJECT_SELF);
float DecrementSearchCooldown(object oEnc = OBJECT_SELF);
float IncrementLifespanTimer(object oEnc = OBJECT_SELF);
float IncrementChaseTimer(object oEnc = OBJECT_SELF);
void PlayCombatStinger();

//AI Update Functions
void RunDumbAI();
void RunUnalertAI();
void RunAlertAI();
void RunChasingAI();
void RunNPCChasingAI();
void RunNPCCombatAI();
void RunCombatAI();
void RunChattingAI();
void RunFleeingAI();
void RunDespawningAI();

//State Transition Functions
void ResetBehavior();
void TransitionNoneToDumb();
void TransitionNoneToAlert();
void TransitionNoneToUnalert();
void TransitionNoneToDespawning();
void TransitionDumbToUnalert();
void TransitionDumbToAlert();
void TransitionDumbToDespawning();
void TransitionUnalertToDumb();
void TransitionUnalertToAlert();
void TransitionUnalertToDespawning();
void TransitionAlertToUnalert();
void TransitionAlertToChasing();
void TransitionAlertToFleeing();
void TransitionChasingToDespawning();
void TransitionChasingToCombat();
void TransitionChasingToChatting();
void TransitionChasingToFleeing();
void TransitionChattingToChasing();
void TransitionChattingToFleeing();
void TransitionFleeingToDespawning();
void TransitionDespawningToNone();
void TransitionToNPCChasing(object oNPC);
void TransitionToNPCCombat(object oNPC, object oEncounter = OBJECT_SELF);

//Guard Functions
void RunGuardAI(object oGuard = OBJECT_SELF);
object GetNeutralInRange(object oEncounter = OBJECT_SELF);
float GetPCOrNeutralDistance(object oPC, object oEncounter = OBJECT_SELF);
int DetermineNPCCombatOutcome(object oNPC, object oEncounter = OBJECT_SELF);


// SetCutsceneModeParty()
//
// Sets the cutscene mode of oPC's party to be true, thereby freezing all PCs and associates in the party.
// if bInCutscene is FALSE, the function returns oPC's party to their normal unfrozen states.
// NOTE: internally calls FreezeAllAssociates().
void SetCutsceneModeParty(object oPC, int bInCutscene = TRUE);

// FadeToBlackParty()
//
// Fades out for all PCs in oPC's party.  Fades in (from black) if bFadeOut is FALSE.
// fFadeSpeed is the time in seconds to complete the fade
// fSafeDelay is the time after which the game will automatically fade in, in the event
// that the scripter forgot to fade in manually.
// nColor is for the color the screen should fade to.
void FadeToBlackParty(object oPC, int bFadeOut = TRUE, float fFadeSpeed = 1.f, float fSafeDelay = 15.f, int nColor = 0);

// SetCutsceneModeAllPCs()
//
// Sets the cutscene mode of all PCs in the module to the value of bInCutscene.
void SetCutsceneModeAllPCs(int bInCutscene = TRUE);

// FadeToBlackAllPCs()
//
// Fades out for all PCs.  Fades in (from black) if bFadeOut is FALSE.
// fFadeSpeed is the time in seconds to complete the fade
// fSafeDelay is the time after which the game will automatically fade in, in the event
// that the scripter forgot to fade in manually.
void FadeToBlackAllPCs(int bFadeOut = TRUE, float fFadeSpeed = 1.f, float fSafeDelay = 15.f);

// FreezeAllAssociates()
// 
// Calls FreezeAssociate for all NPCs in oPC's party, including familiars, henchmen, etc.
// if bValid is FALSE, it will unfreeze the associates.
void FreezeAllAssociates(object oPC, int bValid = TRUE);

// FreezeAssociate()
// 
// Sets associate state to STAND GROUND, which effectively incapacitates them until their state
// is changed again.
// oPC is the PC whose associates we're freezing
// nNth is the nth instance of that associate type (nth henchman, for instance).
// if bValid is FALSE, it will unfreeze the associates.
void FreezeAssociate(object oPC, int bValid, int nType, int nNth = 1);

// Make oCreature (or faction) conversable (remove bad effects, revive, clear actions)
void MakeConversable(object oCreature=OBJECT_SELF, int bFaction=FALSE);

// Call appropriate MakeConversable() to prepare for conversation
//void PrepareForConversation(object oCreature=OBJECT_SELF);

// Prepare and fire conversation immediately
void FireAndForgetConversation(object oSpeaker, object oPC, string sDialog);

// Determine if a cutscene is waiting to be played	
int GetIsCutscenePending(struct CutsceneInfo stCI);
	
// Initialize CutsceneInfo struct
struct CutsceneInfo ResetCutsceneInfo(struct CutsceneInfo stCI);

// Return CutsceneInfo struct of pending cutscene
struct CutsceneInfo SetupCutsceneInfo(struct CutsceneInfo stCI, string sSpeakerTag, object oPC, string sDialog, int bCutsceneCondition);

// Check if any member of oPC's party is in conversation
int GetIsPartyInConversation(object oPC);

// Set oPC's party's Plot Flag
void SetPartyPlotFlag(object oPC, int bPlotFlag);

// Clear all oPC's party's actions
void ClearPartyActions(object oPC, int bClearCombatState=FALSE);

// ScriptHide all creatures hostile to oPC in area
void HideHostileCreatures(object oPC, object oArea=OBJECT_INVALID);

// Remove effect cutscene paralyze on oCreature
void RemoveEffectCutsceneParalyze(object oCreature);

// Show all hostile creatures hidden with HideHostileCreatures()
void ShowHostileCreatures(object oPC, object oArea=OBJECT_INVALID);

// Jump PC party to oSpeaker
void JumpPartyToSpeaker(object oPC, object oSpeaker);

// Save PC party's AI states
void SavePartyAIState(object oPC);

// Load PC party's AI states
void LoadPartyAIState(object oPC);

// Lock from CombatCutsceneCleanUp until conversation has time to begin
void SetCombatCutsceneLocked(int bLocked);

// Check if CombatCutsceneSetup has recently been executed
int GetIsCombatCutsceneLocked();

// Temp-Lock, save AI states, hide hostile creatures, set party Plot Flag
// returns reference to the IP Cleaner
//object CombatCutsceneSetup(object oPC);
object CombatCutsceneSetup(object oPC, string sConversation="");

// load AI states, show hostile creatures, set party Plot Flag
void CombatCutsceneCleanUp(object oPC, object oArea=OBJECT_INVALID);

// Check if we should clean up a CombatCutscene (conversation has ended)
void AttemptCombatCutsceneCleanUp();

// Re-queue AttemptCombatCutsceneCleanUp()
void QueueCombatCutsceneCleanUp();

int ForceIPCleanerCleanup(object oIPCleaner);
int ForceIPCleanerCleanupForConversation(string sConversation);

// Save ACTION_MODE_* status
void SaveActionModes( object oCreature );

// Restore saved ACTION_MODE_* status
void LoadActionModes( object oCreature );

// Execute SaveActionModes() for each member in oPC's faction
void SavePartyActionModes( object oPC );

// Execute LoadActionModes() for each member in oPC's faction
void LoadPartyActionModes( object oPC );


// Set camera of oPC to point in direction of oTarget at the distance and pitch indicated.
void SetCameraFacingPoint(object oPC, object oTarget, float fDistance = -1.0, float fPitch = -1.0, int nTransitionType = CAMERA_TRANSITION_TYPE_SNAP);

// Set camera facing of all players in oPC's party to point in direction of oTarget at the distance and pitch indicated.
void SetCameraFacingPointParty(object oPC, object oTarget, float fDistance = -1.0, float fPitch = -1.0, int nTransitionType = CAMERA_TRANSITION_TYPE_SNAP);



void SetCutsceneModeParty(object oPC, int bInCutscene)
{
	object oPCFacMem = GetFirstFactionMember(oPC);
	
	//iterate through all PCs in oPC's faction, freeze their associates.
	while(GetIsObjectValid(oPCFacMem))
	{
		SetCutsceneMode(oPCFacMem, bInCutscene);
		FreezeAllAssociates(oPCFacMem, bInCutscene);
		oPCFacMem = GetNextFactionMember(oPC);
	}
}

void FadeToBlackParty(object oPC, int bFadeOut, float fFadeSpeed, float fSafeDelay, int nColor)
{
	object oPCFacMem = GetFirstFactionMember(oPC);	
	while(GetIsObjectValid(oPCFacMem))
    {
        if(bFadeOut)
		{
			FadeToBlack(oPCFacMem, fFadeSpeed, fSafeDelay, nColor);
		}
		else 
		{
			FadeFromBlack(oPCFacMem, fFadeSpeed);
		}
        oPCFacMem = GetNextFactionMember(oPC);
    } 
}

void SetCutsceneModeAllPCs(int bInCutscene)
{
	object oPC = GetFirstPC();
	
	while(GetIsObjectValid(oPC))
    {
		AssignCommand(oPC, ClearAllActions(TRUE));
        SetCutsceneMode(oPC, bInCutscene);
        oPC = GetNextPC();
    } 
}

void FadeToBlackAllPCs(int bFadeOut, float fFadeSpeed, float fSafeDelay)
{
	object oPC = GetFirstPC();
	
	while(GetIsObjectValid(oPC))
    {
		AssignCommand(oPC, ClearAllActions(TRUE));
        if(bFadeOut)
		{
			FadeToBlack(oPC, fFadeSpeed, fSafeDelay);
		}
		else 
		{
			FadeFromBlack(oPC, fFadeSpeed);
		}
        oPC = GetNextPC();
    } 
}

void FreezeAssociate(object oPC, int bValid, int nType, int nNth)
{
    object oAssoc = GetAssociate(nType, oPC, nNth);

    //OnHeartbeat calls ActionForceFollow if the CSL_ASC_MODE_STAND_GROUND
    //flag is set to FALSE.
    CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, bValid, oAssoc);

    //If we're freezing...
    if(bValid)
    {
        //clear any currently active ActionForceFollow commands that
        //OnHeartbeat might've already triggered.
        AssignCommand(oAssoc, ClearAllActions(TRUE));
    }
}

void FreezeAllAssociates(object oPC, int bValid)
{
    //Iterate through all possible associates, freezing them one-by-one.
    if ( GetIsPossessedFamiliar( oPC ) )
    {
    	DelayCommand(0.25f, ExecuteScript("_mod_onswitchchars", oPC ) );
    	UnpossessFamiliar(oPC);
    }
    object oAssoc;

    FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_ANIMALCOMPANION);
    FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_DOMINATED);
    FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_FAMILIAR);
    FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_SUMMONED);

    int i;
    for(i = 1; i <= GetMaxHenchmen(); i++)
    {
        FreezeAssociate(oPC, bValid, ASSOCIATE_TYPE_HENCHMAN, i);
    }
}

// Check if a status effect type can break a conversation
// Based on effect types defined in nwscript.nss as of 1/18/06
int GetIsEffectTypeBad(int nEffectType)
{
	return ((nEffectType == EFFECT_TYPE_ENTANGLE) ||
			(nEffectType == EFFECT_TYPE_DEAF) ||
			(nEffectType == EFFECT_TYPE_ARCANE_SPELL_FAILURE) ||
			(nEffectType == EFFECT_TYPE_CHARMED) ||
			(nEffectType == EFFECT_TYPE_CONFUSED) ||
			(nEffectType == EFFECT_TYPE_FRIGHTENED) ||
			(nEffectType == EFFECT_TYPE_PARALYZE) ||
			(nEffectType == EFFECT_TYPE_DAZED) ||
			(nEffectType == EFFECT_TYPE_STUNNED) ||
			(nEffectType == EFFECT_TYPE_SLEEP) ||
			(nEffectType == EFFECT_TYPE_POISON) ||
			(nEffectType == EFFECT_TYPE_DISEASE) ||
			(nEffectType == EFFECT_TYPE_CURSE) ||
			(nEffectType == EFFECT_TYPE_SILENCE) ||
			(nEffectType == EFFECT_TYPE_SLOW) ||
			(nEffectType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE) ||
			(nEffectType == EFFECT_TYPE_INVISIBILITY) ||
			(nEffectType == EFFECT_TYPE_GREATERINVISIBILITY) ||
			(nEffectType == EFFECT_TYPE_DARKNESS) ||
			(nEffectType == EFFECT_TYPE_BLINDNESS) ||
			(nEffectType == EFFECT_TYPE_PETRIFY) ||
			(nEffectType == EFFECT_TYPE_TURNED) ||
			(nEffectType == EFFECT_TYPE_DOMINATED) ||
			(nEffectType == EFFECT_TYPE_CUTSCENE_PARALYZE) ||
			(nEffectType == EFFECT_TYPE_CUTSCENEGHOST) ||
			(nEffectType == EFFECT_TYPE_CUTSCENEIMMOBILIZE) ||					
			(nEffectType == EFFECT_TYPE_FRIGHTENED)	||
			(nEffectType == EFFECT_TYPE_POLYMORPH) ||
			(nEffectType == EFFECT_TYPE_SWARM)	||
			(nEffectType == EFFECT_TYPE_WOUNDING)
			);
			//(nEffectType == EFFECT_TYPE_NEGATIVELEVEL) ||
			//(nEffectType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE) ||
			//(nEffectType == EFFECT_TYPE_ETHEREAL) ||
}

// Clear effects on oCreature
void RemoveAllEffects(object oCreature, int bBadOnly)
{
	// Check if oCreature is valid
	if (GetIsObjectValid(oCreature) == FALSE) return;
	
	effect eEffect = GetFirstEffect(oCreature);
	int nEffectType;
	int nEffectDuration;

	// For each effect
	while (GetIsEffectValid(eEffect) == TRUE)
	{
		if (bBadOnly == FALSE)
		{
			// Remove them all EXCEPT PERSISTENT AoE's!!! FOUND YOU YOU JERK (JWR-OEI)
		if (!(GetEffectDurationType(eEffect) == DURATION_TYPE_PERMANENT && GetEffectType(eEffect) == EFFECT_TYPE_AREA_OF_EFFECT && GetEffectCreator(eEffect) == oCreature ) )
			{
				RemoveEffect(oCreature, eEffect);
			}
		}
		else
		{
			nEffectType = GetEffectType(eEffect);
			nEffectDuration = GetEffectDurationType(eEffect);
			
			// Remove if bad // Duration check may not need to be here?
			if (GetIsEffectTypeBad(nEffectType) == TRUE && nEffectDuration != DURATION_TYPE_PERMANENT)
			{
				RemoveEffect(oCreature, eEffect);
			}
		}

		eEffect = GetNextEffect(oCreature);
	}
}

// Make oCreature (or faction) conversable (remove bad effects, revive)
void MakeConversable(object oCreature=OBJECT_SELF, int bFaction=FALSE)
{
	if (bFaction == TRUE)
	{
		// Make faction conversable
		object oMember = GetFirstFactionMember(oCreature, FALSE);
		while (GetIsObjectValid(oMember) == TRUE)
		{
			AssignCommand(oMember, MakeConversable(oMember, FALSE));
			oMember = GetNextFactionMember(oCreature, FALSE);
		}
	}
	else
	{
		// BMA-OEI 8/15/06: Unlock action queue
		SetCommandable( TRUE, oCreature );
		// BMA-OEI 9/13/06: Clear player queued preferred target 
		SetLocalObject( oCreature, "N2_PLAYER_QUEUED_TARGET", OBJECT_INVALID );
		
		RemoveAllEffects(oCreature, TRUE);
				
		if (GetIsDead(oCreature) == TRUE)
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oCreature);
		}
	}
}

// Call appropriate MakeConversable() to prepare for conversation
//void PrepareForConversation(object oCreature=OBJECT_SELF)
//{
//	// Include faction if oCreature is PC
//	MakeConversable(oCreature, GetIsPC(oCreature));
//}

// Prepare and fire conversation immediately
void FireAndForgetConversation(object oSpeaker, object oPC, string sDialog)
{
	MakeConversable(oPC, TRUE);
	MakeConversable(oSpeaker, FALSE);
	AssignCommand(oSpeaker, ClearAllActions(TRUE));
	AssignCommand(oSpeaker, ActionStartConversation(oPC, sDialog, FALSE, FALSE, TRUE, FALSE));
}

// Determine if a cutscene is waiting to be played	
int GetIsCutscenePending(struct CutsceneInfo stCI)
{
	return (stCI.bCutscenePending);
}	
	
// Initialize CutsceneInfo struct
struct CutsceneInfo ResetCutsceneInfo(struct CutsceneInfo stCI)
{
	stCI.bCutscenePending = FALSE;
	stCI.nCutsceneInfoCount = 0;

	return (stCI);
}

// Return CutsceneInfo struct of pending cutscene
struct CutsceneInfo SetupCutsceneInfo(struct CutsceneInfo stCI, string sSpeakerTag, object oPC, string sDialog, int bCutsceneCondition)
{
	// Unique cutscene identifier
	stCI.nCutsceneInfoCount = stCI.nCutsceneInfoCount + 1;

	if (bCutsceneCondition == TRUE)
	{
		string sPlayedVar = "CI_CS_" + IntToString(stCI.nCutsceneInfoCount) + "_PLAYED";
		int bPlayedAlready = GetLocalInt(OBJECT_SELF, sPlayedVar);
		
		if (bPlayedAlready == FALSE)
		{
			if (sSpeakerTag != "")
			{
				stCI.oSpeaker = GetNearestObjectByTag(sSpeakerTag, oPC);
			}
	
			if (GetIsObjectValid(stCI.oSpeaker) == FALSE)
			{
				//PrettyError("SetupCutsceneInfo: ERROR - Pending cutscene with invalid SPEAKER: " + sSpeakerTag + "!");
				return (stCI);
			}
		
			if (GetIsPC(stCI.oSpeaker) == TRUE)
				//PrettyError("SetupCutsceneInfo: WARNING - SPEAKER: " + sSpeakerTag + " is controlled by a PC.");
		
			stCI.sDialog = sDialog;
	
			if (sDialog == "")
				//PrettyError("SetupCutsceneInfo: WARNING - Pending cutscene with unspecified dialog.");
	
			stCI.bCutscenePending = TRUE;
			SetLocalInt(OBJECT_SELF, sPlayedVar, TRUE);
		}
	}
	
	return (stCI);
}
	
// Check if any member of oPC's party is in conversation
int GetIsPartyInConversation(object oPC)
{
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		if (IsInConversation(oMember) == TRUE)
		{
			return (TRUE);
		}

		oMember = GetNextFactionMember(oPC, FALSE);
	}
	
	return (FALSE);
}

// Set oPC's party's Plot Flag
void SetPartyPlotFlag(object oPC, int bPlotFlag)
{
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		SetPlotFlag(oMember, bPlotFlag);

		oMember = GetNextFactionMember(oPC, FALSE);
	}
}

// Clear all oPC's party's actions
void ClearPartyActions(object oPC, int bClearCombatState=FALSE)
{
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		AssignCommand(oMember, ClearAllActions(bClearCombatState));

		oMember = GetNextFactionMember(oPC, FALSE);
	}
}

// ScriptHide all creatures hostile to oPC in area
void HideHostileCreatures( object oPC, object oArea=OBJECT_INVALID )
{
	// Guarantee a valid oArea
	if ( GetIsObjectValid( oArea ) == FALSE )
	{
		oArea = GetArea( oPC );
	}

	// Search oArea for valid creatures and area_of_effects
	//int nCount = 1;		
	//object oCreature = GetNearestCreature( CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, OBJECT_SELF, nCount, CREATURE_TYPE_SCRIPTHIDDEN, CREATURE_SCRIPTHIDDEN_TRUE );
	int nType;
	object oCreature = GetFirstObjectInArea( oArea );
	
	while (GetIsObjectValid(oCreature) == TRUE)
	{
		nType = GetObjectType( oCreature );
	
		// If our object is a creature
		if ( nType == OBJECT_TYPE_CREATURE )
		{	
			// Check if it's visible
			if ( GetScriptHidden( oCreature ) == FALSE )
			{
				// Check if it's alive
				if ( GetIsDead( oCreature ) == FALSE )
				{
					// And check if it's hostile to oPC
					if ( GetIsEnemy( oCreature, oPC ) == TRUE )
					{
						SetScriptHidden( oCreature, TRUE );
						SetLocalInt( oCreature, TEMP_HOSTILE_VAR, 1 );
					}
				}
			}
		}
			else if ( nType == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			// Destroy potential problem causing AoEs
			//	SendMessageToPC(oPC, "Removing AOE Effect");
			object oAoECreator = GetAreaOfEffectCreator(oCreature);
			//SendMessageToPC(oPC, "Duration type is: "+IntToString(GetAreaOfEffectDuration(oCreature)));
			// this next line is to make sure you don't strip permanent AOE's like
			// Aura of Courage or Hellfire Shield!
			if ( (GetFactionEqual( oAoECreator, oPC) == FALSE ) || ( GetAreaOfEffectDuration(oCreature) != DURATION_TYPE_PERMANENT ) )
			{
				DestroyObject( oCreature, 0.1f );
			}
		}
	
		//nCount = nCount + 1;
		//oCreature = GetNearestCreature( CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, OBJECT_SELF, nCount, CREATURE_TYPE_SCRIPTHIDDEN, CREATURE_SCRIPTHIDDEN_TRUE );
		oCreature = GetNextObjectInArea( oArea );
	}
}

// Remove effect cutscene paralyze on oCreature
void RemoveEffectCutsceneParalyze(object oCreature)
{
	effect eEffect = GetFirstEffect(oCreature);

	while (GetIsEffectValid(eEffect) == TRUE)
	{
		if (GetEffectType(eEffect) == EFFECT_TYPE_CUTSCENE_PARALYZE)
		{
			RemoveEffect(oCreature, eEffect);
			return;
		}
		
		eEffect = GetNextEffect(oCreature);
	}
}

// Show all hostile creatures hidden with HideHostileCreatures()
void ShowHostileCreatures(object oPC, object oArea=OBJECT_INVALID)
{
	if (GetIsObjectValid(oArea) == FALSE)
	{
		oArea = GetArea(oPC);
	}

	object oCreature = GetFirstObjectInArea(oArea);

	while (GetIsObjectValid(oCreature) == TRUE)
	{
		if(!GetIsDM(oCreature))
		{
			if ((GetScriptHidden(oCreature) == TRUE) && (GetLocalInt(oCreature, TEMP_HOSTILE_VAR) == 1))
			{
				SetScriptHidden(oCreature, FALSE);
				SetLocalInt(oCreature, TEMP_HOSTILE_VAR, 0);
			}
		}
		oCreature = GetNextObjectInArea(oArea);
	}
}

// Jump PC party to oSpeaker
void JumpPartyToSpeaker(object oPC, object oSpeaker)
{
	object oArea = GetArea(oSpeaker);
	object oMember = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oMember) == TRUE)
	{
		if (GetArea(oMember) == oArea)
		{
			AssignCommand(oMember, JumpToObject(oSpeaker));
		}

		oMember = GetNextFactionMember(oPC, FALSE);
	}
}

// Save oCreature's Stand Ground state
void SaveStandGroundState(object oCreature)
{
	int nValue = CSLGetAssociateState(CSL_ASC_MODE_STAND_GROUND, oCreature);
	SetLocalInt(oCreature, STAND_GROUND_VAR, nValue);
}

// Load oCreature's Stand Ground state
void LoadStandGroundState(object oCreature)
{
	int nValue = GetLocalInt(oCreature, STAND_GROUND_VAR);
	CSLSetAssociateState(CSL_ASC_MODE_STAND_GROUND, nValue, oCreature);
}

// Lock from CombatCutsceneCleanUp until conversation has time to begin
void SetCombatCutsceneLocked(int bLocked)
{
	SetGlobalInt(COMBAT_LOCK_VAR, bLocked);
}

// Check if CombatCutsceneSetup has recently been executed
int GetIsCombatCutsceneLocked()
{
	return GetGlobalInt(COMBAT_LOCK_VAR);
}

// Temp-Lock, hide hostile creatures, set party Plot Flag
object CombatCutsceneSetup(object oPC, string sConversation="")
{
	
	SetCombatCutsceneLocked(1);

	HideHostileCreatures(oPC);
	SetPartyPlotFlag(oPC, TRUE);
	
	// BMA-OEI 9/14/06: Effort to preserve action mode settings prior to combat cutscenes
	SavePartyActionModes( oPC );
	
	DelayCommand(1.0f, SetCombatCutsceneLocked(0));
	
	// Clean up when conversation ends
	string sNewTag = "";
	if (sConversation != "")
		sNewTag = IPC_TAG_PREFIX + sConversation;
		
	object oIPCleaner = CreateObject(OBJECT_TYPE_PLACEABLE, IPC_RESREF, GetLocation(oPC), FALSE, sNewTag); // if sNewTag=="", tag will use what's in blueprint
	AssignCommand(oIPCleaner, QueueCombatCutsceneCleanUp());	
	return (oIPCleaner);
}

// Show hostile creatures, set party Plot Flag (MUST BE EXECUTED ON AN IPOINT CLEANER)
void CombatCutsceneCleanUp(object oPC, object oArea=OBJECT_INVALID)
{

	//PrettyDebug("doing CombatCutsceneCleanUp()");
	
	// BMA-OEI 9/14/06: Effort to preserve action mode settings prior to combat cutscenes
	LoadPartyActionModes( oPC );
	
	SetPartyPlotFlag(oPC, FALSE);			
	ShowHostileCreatures(oPC, oArea);
}


// returns error code, 0 = success
int ForceIPCleanerCleanup(object oIPCleaner)
{
	if (!GetIsObjectValid(oIPCleaner))
	{			
		//PrettyError("ForceIPCleanerCleanup() oIPCleaner is invalid");
		return (2); // can't find IP cleaner
	}
	
	// we execute the script to ensure clean up is done by the time we return control. 
	// an AssignCommand would simply drop it in the queue and no synchronous guarantee
			
	// Show hostile creatures, set party Plot Flag (MUST BE EXECUTED ON AN IPOINT CLEANER)
	ExecuteScript("go_force_cutscene_cleanup", oIPCleaner);
	//AssignCommandvoid CombatCutsceneCleanUp(object oPC, object oArea=OBJECT_INVALID)
	
	return (0);
}

int ForceIPCleanerCleanupForConversation(string sConversation)
{
	string sIPCTag = IPC_TAG_PREFIX + sConversation;
	object oIPC = GetNearestObjectByTag(sIPCTag);
	if (!GetIsObjectValid(oIPC))
	{
		oIPC = GetObjectByTag(sIPCTag);
	}		
	if (!GetIsObjectValid(oIPC))
	{
		//PrettyError("ForceIPCleanerCleanupByTag() can't find sIPCTag =" + sIPCTag);
		return (1); // can't find IP cleaner
	}
	
	int nRet = ForceIPCleanerCleanup(oIPC);
	return nRet;
}

// Check if we should clean up a CombatCutscene (conversation has ended) (MUST BE EXECUTED ON AN IPOINT CLEANER)
void AttemptCombatCutsceneCleanUp()
{
	if (GetLocalInt(OBJECT_SELF, IPC_DELETE_SELF) == 0)
	{
		object oPC = GetFirstPC();
	
		if ((GetIsCombatCutsceneLocked() == 0) && (GetIsPartyInConversation(oPC) == FALSE))
		{
			CombatCutsceneCleanUp(oPC, GetArea(OBJECT_SELF));
			SetLocalInt(OBJECT_SELF, IPC_DELETE_SELF, 1);
		}
	}
	else
	{
		DestroyObject(OBJECT_SELF);
	}
}

// Re-queue AttemptCombatCutsceneCleanUp() (MUST BE EXECUTED ON AN IPOINT CLEANER)
void QueueCombatCutsceneCleanUp()
{
	DelayCommand(1.5f, AttemptCombatCutsceneCleanUp());
}

// Save ACTION_MODE_* status
void SaveActionModes( object oCreature )
{
	int nMode;
	int nStatus;
	for ( nMode = 0; nMode <= NUM_ACTION_MODES; nMode++ )
	{
		nStatus = GetActionMode( oCreature, nMode );
		SetLocalInt( oCreature, ACTION_MODE_PREFIX + IntToString( nMode ), nStatus );
	}
}

// Restore saved ACTION_MODE_* status
void LoadActionModes( object oCreature )
{
	int nMode;
	int nStatus;
	for ( nMode = 0; nMode <= NUM_ACTION_MODES; nMode++ )
	{
		nStatus = GetLocalInt( oCreature, ACTION_MODE_PREFIX + IntToString( nMode ) );
		SetActionMode( oCreature, nMode, nStatus );
	}
}

// Execute SaveActionModes() for each member in oPC's faction
void SavePartyActionModes( object oPC )
{
	object oFM = GetFirstFactionMember( oPC, FALSE );

	while ( GetIsObjectValid( oFM ) == TRUE )
	{
		SaveActionModes( oFM );
		oFM = GetNextFactionMember( oPC, FALSE );
	}
}

// Execute LoadActionModes() for each member in oPC's faction
void LoadPartyActionModes( object oPC )
{
	object oFM = GetFirstFactionMember( oPC, FALSE );

	while ( GetIsObjectValid( oFM ) == TRUE )
	{
		LoadActionModes( oFM );
		oFM = GetNextFactionMember( oPC, FALSE );
	}
}

// Set camera of oPC to point in direction of oTarget at the distance and pitch indicated.
void SetCameraFacingPoint(object oPC, object oTarget, float fDistance = -1.0, float fPitch = -1.0, int nTransitionType = CAMERA_TRANSITION_TYPE_SNAP)
{
	vector vPC = GetPosition(oPC);
	vector vTarget = GetPosition(oTarget);
	vector vDifference = vTarget - vPC; // this gives us a vector pointing from PC to Target
	float fDirection = VectorToAngle(vDifference);  // we just need the angle of that vector

	AssignCommand(oPC, SetCameraFacing(fDirection, fDistance, fPitch, nTransitionType));	
}

// Set camera facing of all players in oPC's party to point in direction of oTarget at the distance and pitch indicated.
void SetCameraFacingPointParty(object oPC, object oTarget, float fDistance = -1.0, float fPitch = -1.0, int nTransitionType = CAMERA_TRANSITION_TYPE_SNAP)
{
	object oPartyMember = GetFirstFactionMember(oPC, TRUE); // only look at PC's

	while(GetIsObjectValid(oPartyMember))
	{
		SetCameraFacingPoint(oPartyMember, oTarget, fDistance, fPitch, nTransitionType);
		oPartyMember = GetNextFactionMember(oPC, TRUE);
	}
}


//Getters - Functions for other systems to read into the AI state of creatures/
int GetIsActorChasing(object oEnc)
{
	int nBehaviorState = GetLocalInt(OBJECT_SELF, VAR_BEHAVIOR_STATE);
	if(nBehaviorState == BEHAVIOR_STATE_CHASING)
		return TRUE;
		
	else
		return FALSE;
}

/*
	NLC - Overland MAP AI State Manager
	This organizes how AIs transition from one behavior state to another
	on the OL MAP, and runs the appropriate AI when necessary.
*/
void RunStateManager(object oPC)
{
	float fLifespanTimer			= GetLocalFloat(OBJECT_SELF, VAR_LIFESPAN_TIMER);
	float fChaseTimer				= GetLocalFloat(OBJECT_SELF, VAR_CHASE_TIMER);
	float fSearchCooldown			= GetLocalFloat(OBJECT_SELF, VAR_SEARCH_COOLDOWN);
	float fSearchDist 				= GetLocalFloat(OBJECT_SELF, "fSearchDist");
	float fLifespan					= IntToFloat(GetLocalInt(OBJECT_SELF, VAR_ENC_LIFESPAN));
	float fPCDistance 				= GetDistanceBetween(oPC, OBJECT_SELF);
	
	int nBehaviorState		 		= GetLocalInt(OBJECT_SELF, VAR_BEHAVIOR_STATE);	
	
	switch ( nBehaviorState )
	{
		
		case BEHAVIOR_STATE_NONE:
		{
			if (fLifespanTimer >= fLifespan)
				TransitionNoneToDespawning();
				
			else if (fPCDistance <= fSearchDist)
				TransitionNoneToAlert();
		
			else if (fPCDistance <= AI_AWARENESS_DISTANCE)
				TransitionNoneToUnalert();
						
			else
				TransitionNoneToDumb();
		}
		break;
			
		case BEHAVIOR_STATE_DUMB:
		{
			if (fLifespanTimer >= fLifespan)
				TransitionDumbToDespawning();

			if (fPCDistance <= fSearchDist)
			{
				TransitionDumbToAlert();
			}
			
			object oNeutral = GetNeutralInRange();
			if(GetIsObjectValid(oNeutral) && fLifespanTimer > 0.0f && !GetIsPC(oNeutral) && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") == FALSE)
			{
				TransitionToNPCChasing(oNeutral);
			}
			else if (fPCDistance <= AI_AWARENESS_DISTANCE)
			{
				TransitionDumbToUnalert();
			}
			else
				RunDumbAI();
		}
		break;
		
		case BEHAVIOR_STATE_UNALERT:
		{
			if (fLifespanTimer >= fLifespan)
				TransitionDumbToDespawning();

			if (fPCDistance <= fSearchDist)
			{
				TransitionUnalertToAlert();
			}
			
			else if (fPCDistance > AI_AWARENESS_DISTANCE)
			{
				TransitionUnalertToDumb();
			}
			
			object oNeutral = GetNeutralInRange();
			if(GetIsObjectValid(oNeutral) && fLifespanTimer > 0.0f && !GetIsPC(oNeutral) && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") == FALSE)
			{
				TransitionToNPCChasing(oNeutral);
			}
			
			else
				RunUnalertAI();	
		}		
		break;
		
		case BEHAVIOR_STATE_ALERT:
		{
			if(IsInConversation(oPC))
			{
				ClearAllActions(TRUE);
			}
			
			else if (fSearchCooldown == 0.0f && fPCDistance > fSearchDist)			
			{
				TransitionAlertToUnalert();
			}
			object oNeutral = GetNeutralInRange();
			if(GetIsObjectValid(oNeutral) && fLifespanTimer > 0.0f && !GetIsPC(oNeutral) && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") == FALSE)
			{
				TransitionToNPCChasing(oNeutral);
			}
			
			else if ( fSearchCooldown <= 0.0f)
			{
				SetLocalFloat(OBJECT_SELF, "fSearchCooldown", SEARCH_COOLDOWN);
				
				
				if(GetIsSearchSuccessful(oPC))
				{
					if( GetIsEncounterScared() )
					{
						TransitionAlertToFleeing();
					}
					
					else 
					{
						TransitionAlertToChasing();
					}
				}
				
				else
				{
					effect eAlert = EffectNWN2SpecialEffectFile("fx_OverlandMap_Searching01");
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAlert, OBJECT_SELF, SEARCH_COOLDOWN);
					// JWR-OEI 10/03/08: Move away, otherwise fPCDistance > fSearchDist
					// will NEVER be true and we're stuck in a loop!
					//ActionMoveAwayFromObject(oPC, FALSE);
					// using away from location to help prevent them getting stuck
					// against walls in confined spaces.
					ActionMoveAwayFromLocation(GetLocation(OBJECT_SELF));
					
				}
			}
			
			else
			{
				RunAlertAI();
			}
		}
		break;
		
		case BEHAVIOR_STATE_NPC_CHASING:
		{
			object oNPC = GetLocalObject(OBJECT_SELF, "oFollow");
			float fNPCDistance = GetDistanceBetween(OBJECT_SELF, oNPC);
			
			if(!GetIsObjectValid(oNPC) || GetIsPC(oNPC) || GetScriptHidden(oNPC))
			{
				DeleteLocalObject(OBJECT_SELF, "oFollow");
				ResetBehavior();
			}
			
			else if(fNPCDistance <= ENCOUNTER_CONVERSATION_DISTANCE)
			{
				TransitionToNPCCombat(oNPC);
			}
			
			else
				RunNPCChasingAI();
			
		}
		break;
		
		case BEHAVIOR_STATE_NPC_COMBAT:
		{
			object oNPC = GetLocalObject(OBJECT_SELF, "oFollow");
			if(!GetIsObjectValid(oNPC) || GetIsPC(oNPC) || GetScriptHidden(oNPC))
			{
				DeleteLocalObject(OBJECT_SELF, "oFollow");
				ResetBehavior();
			}
			
			else
				RunNPCCombatAI();
		}
		break;
		
		case BEHAVIOR_STATE_CHASING:
		{
			/*			
			if( GetIsEncounterScared() )
				TransitionChasingToFleeing();
			Commenting this out for performance reasons			
			PrettyDebug("Search Cooldown:" + FloatToString(fSearchCooldown) + " fChaseTimer:" + FloatToString(fChaseTimer) );
			*/
						
			if (fSearchCooldown == 0.0f && fPCDistance > fSearchDist)
				TransitionChasingToDespawning();
			
			object oNeutral = GetNeutralInRange();
			if( GetIsObjectValid(oNeutral) && fLifespanTimer > 0.0f && !GetIsPC(oNeutral) && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") == FALSE && GetDistanceBetween(oNeutral, OBJECT_SELF) < fPCDistance )
			{
				TransitionToNPCChasing(oNeutral);
			}
			
			else if (fChaseTimer > AI_CHASE_DURATION)
			{
				TransitionChasingToDespawning();
			}
			
			else if (fPCDistance <= ENCOUNTER_CONVERSATION_DISTANCE)
			{
				//PrettyDebug("ginc_overland_ai: Starting convo with " + GetTag(OBJECT_SELF));
				TransitionChasingToChatting();
				ClearAllActions(TRUE);
				PlayCombatStinger();
				ActionStartConversation(oPC, GetEncounterConversation(), FALSE,FALSE,TRUE,FALSE);
			}
			
			else
				RunChasingAI();
		}
		break;
		
		case BEHAVIOR_STATE_CHATTING:
			if( !IsInConversation(OBJECT_SELF) )
				TransitionChattingToChasing();
			
			else
				RunChattingAI();
		break;
		
		case BEHAVIOR_STATE_FLEEING:
			RunFleeingAI();
		break;
		
		case BEHAVIOR_STATE_DESPAWNING:
			if( GetLocalInt(OBJECT_SELF, VAR_SE_FLAG) &&		//if I have a Local Location I am a Special Encounter
				GetDistanceBetweenLocations( GetLocation(OBJECT_SELF), GetSEStartLocation() ) < 1.0f)
			
				TransitionDespawningToNone();
			else
				RunDespawningAI();
		break;
		
		default:
		break;
	}
}

void RemoveAggroVFX(object oEnc = OBJECT_SELF)
{
	effect eEffect = GetFirstEffect(oEnc);
	//PrettyDebug("Removing aggro vfx from " + GetName(oEnc));
	while(GetIsEffectValid(eEffect))
	{
		//PrettyDebug("Effect");
		///PrettyDebug(IntToString(GetEffectSpellId(eEffect)));
		if(GetEffectSpellId(eEffect) == AGGRO_VFX_ID)
			RemoveEffect(oEnc, eEffect);
		
		eEffect = GetNextEffect(oEnc);
	}	
}

/*	Assigns the overland creature to pursue the party.	*/
void PursueParty(object oPC)
{
	if(GetIsPC(oPC)) 
	{
		//PrettyDebug(GetName(OBJECT_SELF) + "Target Acquired.");
		ClearAllActions(TRUE);
		SetLocalObject(OBJECT_SELF, "oFollow",oPC);
		ActionForceFollowObject(oPC,0.f);
		ActionDoCommand(SignalEvent(OBJECT_SELF, EventUserDefined(100)));
	}
}

void PursueNPC(object oNPC)
{
	ClearAllActions(TRUE);
	SetLocalObject(OBJECT_SELF, "oFollow", oNPC);
	ActionForceFollowObject(oNPC,0.f);
}

void SetOLBehaviorState(int nBehaviorState, object oEnc)
{
	SetLocalInt(oEnc, VAR_BEHAVIOR_STATE, nBehaviorState);
}

void SetEncounterFlagAfraid(object oEnc)
{
	SetLocalInt(oEnc, "nAfraid", 1);
}

int GetIsSearchSuccessful(object oPC, object oEnc = OBJECT_SELF)
{
	int nSurvivalDC = GetLocalInt(oEnc, "nSurvivalDC");
	int nSkillToUse = SKILL_HIDE;
	
	if( GetSkillRank(SKILL_MOVE_SILENTLY, oPC) > GetSkillRank(SKILL_HIDE, oPC))
		nSkillToUse = SKILL_MOVE_SILENTLY;
	
	int nResult = GetIsSkillSuccessful(oPC, nSkillToUse, nSurvivalDC, FALSE);
	
	if(GetLocalInt(oEnc, "bSearchSuccess") == FALSE && nResult)			//If this is the first time you succeeded.
	{
		string sFeedback = "<color=DEEPSKYBLUE>";
		sFeedback += GetStringByStrRef(StringToInt(Get2DAString("skills", "NAME", nSkillToUse)));	//Skill +
		sFeedback += " ";
		sFeedback += GetStringByStrRef(5352);											//success +
		sFeedback += " ";
		sFeedback += GetStringByStrRef(7603);										// vs. +
		sFeedback += " ";
		sFeedback += GetName(oEnc);
		sFeedback += "</color>";
		SetLocalInt(oEnc, "bSearchSuccess", TRUE);
		FloatingTextStringOnCreature(sFeedback, oPC, FALSE);
	}
	
	else if (nResult == FALSE)
	{
		string sFeedback = "<color=Red>";
		sFeedback += GetStringByStrRef(StringToInt(Get2DAString("skills", "NAME", nSkillToUse)));	//Skill +
		sFeedback += " ";
		sFeedback += GetStringByStrRef(53300);											//failed  +
		sFeedback += " ";
		sFeedback += GetStringByStrRef(7603);										// vs. +
		sFeedback += " ";
		sFeedback += GetName(oEnc);
		sFeedback += "</color>";
		FloatingTextStringOnCreature(sFeedback, oPC, FALSE);		
	}
	
	SetLocalFloat(oEnc, VAR_SEARCH_COOLDOWN, SEARCH_COOLDOWN);
	return !nResult;
}
	
int GetIsEncounterScared(object oEnc = OBJECT_SELF)
{
	if (GetLocalInt(oEnc, "NX2_ENC_NO_FEAR"))	//If the encounter is flagged to be fearless, be fearless (regardless of what the flag says).
		return FALSE;
	
	else if (GetLocalInt(oEnc, "nAfraid"))	//If the Afraid flag is set, the encounter is scared. No brainer here.
		return TRUE;
	
	else 
	{
		object oPC	= GetFactionLeader(GetFirstPC());
	
		float fCR = GetChallengeRating(oEnc) + 5;
	
		//	If the party has Fearsome Roster or Improved Fearsome Roster feat,
		//	monsters run away as if the party is 1 or 2 CRs higher than it
		//	really is.
		if (GetHasFeat(FEAT_TW_FEARSOME_ROSTER, oPC))
			fCR = GetChallengeRating(oEnc) + 4;
		
		if (GetHasFeat(FEAT_TW_IMPROVED_FEARSOME_ROSTER, oPC))
			fCR = GetChallengeRating(oEnc) + 3;
		
		if( FloatToInt(fCR) < GetPartyChallengeRating() )
		{
			SetEncounterFlagAfraid(oEnc);
			return TRUE;
		}	
	}
	
	return FALSE;
}

float DecrementSearchCooldown(object oEnc = OBJECT_SELF)
{
	float fCooldown = GetLocalFloat(oEnc, VAR_SEARCH_COOLDOWN);
	float fHeartrate = IntToFloat(GetCustomHeartbeat(OBJECT_SELF)) / 1000.0f; //heartrate in seconds
	
	fCooldown -= fHeartrate;
	
	if(fCooldown < 0.0f)
		fCooldown = 0.0f;
	
	SetLocalFloat(oEnc, VAR_SEARCH_COOLDOWN, fCooldown);
	return fCooldown;
}

float IncrementLifespanTimer(object oEnc = OBJECT_SELF)
{
	float fHeartrate = IntToFloat(GetCustomHeartbeat(OBJECT_SELF)) / 1000.0f;
	float fLifespanTimer = GetLocalFloat(OBJECT_SELF, VAR_LIFESPAN_TIMER);
	
	if(fLifespanTimer >= 0.0f)				//Lifespan timers less than zero indicate that the creature is immortal.
		fLifespanTimer += fHeartrate;
	
	SetLocalFloat(oEnc, VAR_LIFESPAN_TIMER, fLifespanTimer);
	
	return fLifespanTimer;
}

float IncrementChaseTimer(object oEnc = OBJECT_SELF)
{
	float fHeartrate = IntToFloat(GetCustomHeartbeat(OBJECT_SELF)) / 1000.0f;
	float fChaseTimer = GetLocalFloat(OBJECT_SELF, VAR_CHASE_TIMER);
	
	fChaseTimer += fHeartrate;
	
	SetLocalFloat(oEnc, VAR_CHASE_TIMER, fChaseTimer);
	
	return fChaseTimer;
}

void RunDumbAI()
{
}

void RunUnalertAI()
{
	//PrettyDebug(GetName(OBJECT_SELF) + "Running Unalert AI");
	int iBehavior = Random(100)+1;
	
	if(iBehavior <=10)
	{
		ClearAllActions(TRUE);
		//ActionPlayAnimation(ANIMATION_FIREFORGET_SEARCH);
		//DelayCommand(5.0f, ActionRandomWalk());
	}
		
	else if ( GetCurrentAction() != ACTION_RANDOMWALK)
	{
		ClearAllActions(TRUE);
		ActionRandomWalk();
	}
}

void RunAlertAI()
{
	//PrettyDebug(GetName(OBJECT_SELF) + "Running alert AI");
/*	int iBehavior = Random(99)+1;

	if(iBehavior <=50)
	{
		ClearAllActions(TRUE);
		//ActionPlayAnimation(ANIMATION_FIREFORGET_SEARCH);	
	}
		
	else if ( GetCurrentAction() != ACTION_MOVETOPOINT)
	{
		ClearAllActions(TRUE);
		ActionRandomWalk();
	}
*/
}

void RunChasingAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Chase AI");
	object oFollow = GetLocalObject(OBJECT_SELF, "oFollow");
	if(IsInConversation(GetFactionLeader(GetFirstPC())))
	{
		ClearAllActions(TRUE);
		return;
	}
	IncrementChaseTimer();
	
	if(GetCurrentAction() != ACTION_FOLLOW || GetScriptHidden(oFollow))
	{
		object oPC = GetFactionLeader(GetFirstPC());
//		vector vTarget = GetPosition(oPC);
//		SetFacingPoint(vTarget);			//Commenting out for Performance.
		PursueParty(oPC);
	}
	
	else if(!GetIsObjectValid(oFollow))
	{
		ClearAllActions(TRUE);
		//ActionPlayAnimation(ANIMATION_FIREFORGET_SEARCH);
		DelayCommand(5.0f, ActionRandomWalk());
		SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
	}
}

void RunNPCChasingAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Chase AI");
	object oFollow = GetLocalObject(OBJECT_SELF, "oFollow");
	if(IsInConversation(GetFirstPC()))
	{
		ClearAllActions(TRUE);
		return;
	}
	
	if(GetCurrentAction() != ACTION_FOLLOW )
	{
//		object oPC = GetFactionLeader(GetFirstPC());
//		vector vTarget = GetPosition(oPC);
//		SetFacingPoint(vTarget);			//Commenting out for Performance.
		PursueNPC(oFollow);
	}
	
	else if(!GetIsObjectValid(oFollow))
	{
		ClearAllActions(TRUE);
		//ActionPlayAnimation(ANIMATION_FIREFORGET_SEARCH);
		DelayCommand(5.0f, ActionRandomWalk());
		SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
	}
}

void RunNPCCombatAI()
{
	object oNPC = GetLocalObject(OBJECT_SELF, "oFollow");
	ClearCombatOverrides(OBJECT_SELF);
	ClearCombatOverrides(oNPC);
	
	if(GetIsPC(oNPC))
	{
		ClearAllActions(TRUE);
		DeleteLocalObject(OBJECT_SELF, "oFollow");
		ResetBehavior();
	}
	
	else
	{
		ClearAllActions(TRUE);
	
		AssignCommand(oNPC, ClearAllActions(TRUE));
	
		int nResult = DetermineNPCCombatOutcome(oNPC, OBJECT_SELF);
	
		if (nResult == NPC_COMBAT_RESULT_NPC_DAMAGE)
		{
			SetCombatOverrides(OBJECT_SELF, oNPC, 1, 0, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 1,1, TRUE, TRUE, TRUE, TRUE);
			SetCombatOverrides(oNPC, OBJECT_SELF, 1, 0, OVERRIDE_ATTACK_RESULT_MISS, 0,0, TRUE, TRUE, TRUE, TRUE);
			ActionAttack(oNPC);
			AssignCommand(oNPC, ActionAttack(OBJECT_SELF));
		}
	
		else if (nResult == NPC_COMBAT_RESULT_ENC_DAMAGE)
		{
			SetCombatOverrides(oNPC, OBJECT_SELF, 1, 0, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, 1,1, TRUE, TRUE, TRUE, TRUE);
			SetCombatOverrides(OBJECT_SELF, oNPC, 1, 0, OVERRIDE_ATTACK_RESULT_MISS, 0,0, TRUE, TRUE, TRUE, TRUE);
			AssignCommand(oNPC, ActionAttack(OBJECT_SELF));
			ActionAttack(oNPC);
		}
	}
}

void RunChattingAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Chatting AI");
}

// JWR-OEI 10/02/08 - Cleaned up typos, fixed case where fleeing mobs 
// just "stand around" and various polish.
void RunFleeingAI()
{
	//	PrettyDebug(GetName(OBJECT_SELF) + "Running Flee AI");
	object oPC = GetFactionLeader(GetFirstPC());
	int nCowerCounter = GetLocalInt(OBJECT_SELF, "nCower");
	float fDist = GetDistanceBetween(OBJECT_SELF, oPC);
	//SpeakString("**** (Distance-----> "+FloatToString(fDist)+" nCowerCounter----->"+IntToString(nCowerCounter));

	if ( fDist > 9.0f || nCowerCounter > 12000)
	{
		TransitionFleeingToDespawning();
	}
	else if( fDist <= 9.0f )
	{
		ClearAllActions(TRUE);
		int nHeartbeat = GetCustomHeartbeat(OBJECT_SELF);
		CSLIncrementLocalInt(OBJECT_SELF, "nCower", nHeartbeat);
		if ( nCowerCounter > 8000 )
			ActionMoveAwayFromObject(oPC, FALSE);
		
		//PlayCustomAnimation(OBJECT_SELF, "idlecower", 1);
	}
}

void RunDespawningAI()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Running Despawn AI");
	object oPC = GetFactionLeader(GetFirstPC());


	if ( GetLocalInt(OBJECT_SELF, VAR_SE_FLAG) )
	{
		ClearAllActions(TRUE);
		ActionMoveToLocation(GetLocalLocation(OBJECT_SELF, VAR_SE_START_LOC), TRUE);
	}

	else if(GetDistanceBetween(OBJECT_SELF, oPC) > 5.0f)
	{
		RemoveSEFFromObject(OBJECT_SELF, "fx_map_hostile");
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_ambient_fade"), OBJECT_SELF);
		DestroyObject(OBJECT_SELF, 1.0f);
	}	

	else if ( GetCurrentAction() != ACTION_MOVETOPOINT)
	{
		ClearAllActions(TRUE);
		ActionMoveAwayFromObject(oPC);
	}

}

void ResetBehavior()
{
	ClearAllActions(TRUE);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_NONE);
	object oPC = GetFactionLeader(GetFirstPC());
	RunStateManager(oPC);
}
void TransitionNoneToUnalert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Transitioning None to Unalert");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
}

void TransitionNoneToAlert()
{
// 	PrettyDebug(GetName(OBJECT_SELF) + "Transition None To Alert");
	ClearAllActions(TRUE);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_ALERT);
}

void TransitionNoneToDumb()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Transitioning None to Dumb");
	SetOLBehaviorState(BEHAVIOR_STATE_DUMB);
}

void TransitionNoneToDespawning()
{
//	PrettyDebug(GetName(OBJECT_SELF) + ":TransitionNoneToDespawning");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	
	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	ActionMoveAwayFromObject(oPC);
}

void TransitionDumbToUnalert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "Transitioning Dumb to Unlaret");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
}
void TransitionDumbToAlert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionDumbToAlert");
	ClearAllActions(TRUE);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_ALERT);
}

void TransitionDumbToDespawning()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionDumbToDespawning");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	
	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	ActionMoveAwayFromObject(oPC);
}
void TransitionUnalertToDumb()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionUnalertToDumb");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DUMB);
}

void TransitionUnalertToAlert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionUnalertToAlert");
	ClearAllActions(TRUE);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_ALERT);
}

void TransitionUnalertToDespawning()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionUnalertToDespawning");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	
	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	ActionMoveAwayFromObject(oPC);
}
void TransitionAlertToUnalert()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionAlertToUnAlert");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_UNALERT);
}

void TransitionAlertToChasing()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionAlertToChasing");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_CHASING);
	SetOLBehaviorState(BEHAVIOR_STATE_CHASING);
	object oPC = GetFactionLeader(GetFirstPC());
	vector vTarget = GetPosition(oPC);
	
	effect eChase = EffectNWN2SpecialEffectFile("fx_OverlandMap_Detect");
	eChase = SetEffectSpellId(eChase, AGGRO_VFX_ID);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChase, OBJECT_SELF);
	
	SetFacingPoint(vTarget);
	PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
	PursueParty(oPC);
}

void TransitionAlertToFleeing()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionAlertToFleeing");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_FLEEING);

	effect eCower = EffectNWN2SpecialEffectFile("fx_OverlandMap_Cower");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCower, OBJECT_SELF);

	object oPC = GetFactionLeader(GetFirstPC());
		
	ClearAllActions(TRUE);
	// JWR-OEI - Set to False to stop "jerkiness" of
	// OL creatures running away at first.
	ActionMoveAwayFromObject(oPC, FALSE);
}

void TransitionChasingToDespawning()
{
	//PrettyDebug(GetName(OBJECT_SELF) + " TransitionChasingToDespawning");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	effect eDeaggro = EffectNWN2SpecialEffectFile("fx_OverlandMap_Deaggro");
	object oPC = GetFactionLeader(GetFirstPC());
	
	RemoveAggroVFX(OBJECT_SELF);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeaggro, OBJECT_SELF);
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	ActionMoveAwayFromObject(oPC);
}

void TransitionChasingToChatting()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionChasingToChatting");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_CHATTING);
}

void TransitionChasingToFleeing()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionChasingToFleeing");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_FLEEING);
	
	effect eCower = EffectNWN2SpecialEffectFile("fx_OverlandMap_Cower");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCower, OBJECT_SELF);
	
	object oPC = GetFactionLeader(GetFirstPC());
	ClearAllActions(TRUE);
	ActionMoveAwayFromObject(oPC, TRUE);
}

void TransitionChattingToChasing()
{
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_CHASING);
	SetOLBehaviorState(BEHAVIOR_STATE_CHASING);

	object oPC = GetFactionLeader(GetFirstPC());
	vector vTarget = GetPosition(oPC);
	
	
	SetFacingPoint(vTarget);
	PursueParty(oPC);
}

void TransitionChattingToFleeing()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionChattingToFleeing");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_FLEEING);

	effect eCower = EffectNWN2SpecialEffectFile("fx_OverlandMap_Cower");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCower, OBJECT_SELF);

	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	ActionMoveAwayFromObject(oPC, TRUE);
}

void TransitionFleeingToDespawning()
{
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DEFAULT);
	SetOLBehaviorState(BEHAVIOR_STATE_DESPAWNING);
	
	object oPC = GetFactionLeader(GetFirstPC());
	
	ClearAllActions(TRUE);
	SetEventHandler(OBJECT_SELF, EVENT_DIALOGUE, "");
	// JWR-OEI changed this because they're fleeing! They should run!
	ActionMoveAwayFromObject(oPC, TRUE);
}


void TransitionDespawningToNone()
{
//	PrettyDebug(GetName(OBJECT_SELF) + "TransitionDespawningToNone");
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_DETECTING);
	SetOLBehaviorState(BEHAVIOR_STATE_NONE);
}

void TransitionToNPCChasing(object oNPC)
{
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_CHASING);
	SetOLBehaviorState(BEHAVIOR_STATE_NPC_CHASING);
	SetOLBehaviorState(BEHAVIOR_STATE_NPC_CHASING, oNPC);
	ClearAllActions(TRUE);
	PursueNPC(oNPC);
}

const int SC_WALK_FLAG_PAUSED           = 0x00000010;

void TransitionToNPCCombat(object oNPC, object oEncounter = OBJECT_SELF)
{
	AssignCommand(oNPC, ClearAllActions(TRUE));
	ClearAllActions(TRUE);
	
	SetOLBehaviorState(BEHAVIOR_STATE_NPC_COMBAT, oNPC);
	SetOLBehaviorState(BEHAVIOR_STATE_NPC_COMBAT);
	
	CSLSetLocalIntBitState(oNPC, "NW_WALK_CONDITION", SC_WALK_FLAG_PAUSED, TRUE ); 
	//AssignCommand(oNPC, SCSetWalkCondition(NW_WALK_FLAG_PAUSED, TRUE));
	SetCustomHeartbeat(oNPC, HEARTBEAT_RATE_COMBAT);
	SetCustomHeartbeat(OBJECT_SELF, HEARTBEAT_RATE_COMBAT);
	
	SetLocalObject(oNPC, "oChasing", OBJECT_SELF);
	
	// Set up the encounter mating placeable.
	object oIP = CreateObject(OBJECT_TYPE_PLACEABLE, "nx2_plc_enc_ipoint", GetLocation(OBJECT_SELF));
	SetCustomHeartbeat(oIP, 500);
	SetLocalObject(oIP, "oCombatant1", OBJECT_SELF);
	SetLocalObject(oIP, "oCombatant2", oNPC);
	
	RunNPCCombatAI();
}

object GetNeutralInRange(object oEncounter = OBJECT_SELF)
{
	float fSearchDist = GetLocalFloat(oEncounter, "fSearchDist");
	location lEnc = GetLocation(oEncounter);
	object oGuard = GetFirstObjectInShape(SHAPE_SPHERE, fSearchDist, lEnc, TRUE);
	object oRet = OBJECT_INVALID;
	while(GetIsObjectValid(oGuard))
	{
		if( GetLocalInt(oGuard, "bGuard") && !GetScriptHidden(oGuard) && !GetIsPC(oGuard) &&
			GetLocalInt(oGuard, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_CHASING &&
			GetLocalInt(oGuard, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_COMBAT)
		{	
			return oGuard;
		}
		else if( GetLocalInt(oGuard, "bNeutral") && !GetIsPC(oGuard) && !GetScriptHidden(oGuard) &&
			(GetLocalInt(oGuard, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_CHASING &&
			 GetLocalInt(oGuard, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_COMBAT &&
			 !GetLocalInt(oGuard, "bWaylaid") ) )
		{
			oRet = oGuard;
		}
		
		oGuard = GetNextObjectInShape(SHAPE_SPHERE, fSearchDist, lEnc, TRUE);
	}
	
	return oRet;
}

float GetPCOrNeutralDistance(object oPC, object oEncounter = OBJECT_SELF)
{
	float fResult = GetDistanceBetween(oPC, oEncounter);
	object oNeutral = GetNeutralInRange();
	if(GetIsObjectValid(oNeutral))
	{
		float fNeutralDistance = GetDistanceBetween(oEncounter, oNeutral);
		if( fNeutralDistance < fResult )
			fResult = fNeutralDistance;
	}
	
	return fResult;
}

int DetermineNPCCombatOutcome(object oNPC, object oEncounter = OBJECT_SELF)
{
	int nNeutralCR	= FloatToInt(GetChallengeRating(oNPC));
	int nEncCR		= FloatToInt(GetChallengeRating(oEncounter));
	
	if (GetGlobalInt("00_bWeaponsUpgraded")==TRUE)
	{
		nNeutralCR+= 2;
	}
	
	if (GetGlobalInt("00_bArmorUpgraded")==TRUE)
	{
		nNeutralCR+= 2;
	}
	
	int nEncAdvantage = nEncCR - nNeutralCR;
	nEncAdvantage *= 5;
	
	int nEncWinChance = 50 + nEncAdvantage;
//	PrettyDebug("WinChance: " + IntToString(nEncWinChance));
	if (nEncWinChance < 5)
		nEncWinChance = 5;
		
	if (nEncWinChance > 95)
		nEncWinChance = 95;
		
	int nResult = Random(100)+1;
//	PrettyDebug("WinChance: " + IntToString(nEncWinChance));
//	PrettyDebug("Result: " +  IntToString(nResult));
	
	if(nResult > nEncWinChance)
		return NPC_COMBAT_RESULT_ENC_DAMAGE;
		
	else
		return NPC_COMBAT_RESULT_NPC_DAMAGE;
}

//Guard AI
void RunGuardAI(object oGuard = OBJECT_SELF)
{
	int nBehaviorState = GetLocalInt(oGuard, VAR_BEHAVIOR_STATE);
	
	object oChasing = GetLocalObject(oGuard, "oChasing");

	if(nBehaviorState == BEHAVIOR_STATE_NPC_COMBAT && GetIsObjectValid(oChasing))
	{
		return;
	}
	
	else if(nBehaviorState == BEHAVIOR_STATE_NPC_COMBAT)
	{
		DeleteLocalObject(oGuard, "oChasing");

		CSLSetLocalIntBitState(oGuard, "NW_WALK_CONDITION", SC_WALK_FLAG_PAUSED, FALSE ); 
		//AssignCommand(oGuard, SCSetWalkCondition(NW_WALK_FLAG_PAUSED, FALSE));

		//AssignCommand(oGuard, SCSetWalkCondition(NW_WALK_FLAG_PAUSED, FALSE));
		SetOLBehaviorState(BEHAVIOR_STATE_NONE, oGuard);
	}
	
	if(GetIsObjectValid(oChasing))
	{
		if(GetDistanceBetween(oGuard, oChasing) < ENCOUNTER_CONVERSATION_DISTANCE)
		{
			ClearAllActions(TRUE);
			SetOLBehaviorState(BEHAVIOR_STATE_NPC_COMBAT);
			AssignCommand(oChasing, TransitionToNPCCombat(oGuard));
		}
		
		else if(GetCurrentAction(oGuard) != ACTION_FOLLOW)
		{
			ClearAllActions(TRUE);
			AssignCommand(oGuard, ActionForceFollowObject(oChasing, 0.0f));
		}
	}

	
	location lGuard = GetLocation(oGuard);
	object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, 5.0f, lGuard, TRUE);
	
	while(GetIsObjectValid(oCreature))
	{
		if(	GetLocalInt(oCreature, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_CHASING &&
			GetLocalInt(oCreature, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_NPC_COMBAT  &&
			GetLocalInt(oCreature, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_FLEEING  	 &&
			GetLocalInt(oCreature, VAR_BEHAVIOR_STATE) != BEHAVIOR_STATE_DESPAWNING )
		{
			if(GetLocalInt(oCreature, "nLifespan") > 0 && !GetLocalInt(oCreature, "bAfraid") && GetLocalInt(OBJECT_SELF, "bSpecialEncounter") != TRUE)
			{

				ClearAllActions(TRUE);
				AssignCommand(oGuard, ActionForceFollowObject(oCreature, 0.0f));
				SetLocalObject(oGuard, "oChasing", oCreature);
			}
		}
		oCreature = GetNextObjectInShape(SHAPE_SPHERE, 5.0f, lGuard, TRUE);
	}
	
	if (SCGetWalkCondition(NW_WALK_FLAG_CONSTANT))
	{
		SCWalkWayPoints(TRUE, "heartbeat");
	}
}

// Randomly plays one of three combat stingers.
void PlayCombatStinger()
{
	int nNum = Random(3) + 1;
	string sStinger = "nx2_mus_entercombat" + IntToString(nNum);
	PlaySound(sStinger, TRUE);
	
	//PrettyDebug("ginc_overland_ai: Playing combat stinger " + sStinger);
}

//Function Declarations------------------------------
/*----------------------\
|	Terrain Functions	|
\----------------------*/
int GetCurrentPCTerrain()
{
	return GetGlobalInt(VAR_PC_TERRAIN);
}

int GetNumTerrainMaps(int nTerrain)
{
	switch(nTerrain)
	{
	case TERRAIN_FOREST:
		return 1;
	case TERRAIN_DESERT:
		return 1;
	case TERRAIN_BEACH:
		return 1;
	case TERRAIN_ROAD:
		return 1;		
	case TERRAIN_PLAINS:
		return 1;
	case TERRAIN_JUNGLE:
		return 1;
	case TERRAIN_HILLS:
		return 1;
	case TERRAIN_SWAMP:
		return 1;
	}
	//PrettyDebug("No terrain maps for terrain type " + IntToString(nTerrain));
	return 0;
}

int GetTerrainType(object oTrigger)
{
	return GetLocalInt(oTrigger,"nTerrain");
}

int GetTerrainAtLocation(location lLocation)
{
	object oArea = GetAreaFromLocation(lLocation);
	object oTrigger = GetFirstSubArea(oArea, GetPositionFromLocation(lLocation));
	int i=0;
	while ( GetTag(oTrigger) != "nx2_tr_terrain" && GetIsObjectValid(oTrigger))
	{
		oTrigger = GetNextSubArea(oArea);
	}
	
	int nResult = GetLocalInt(oTrigger,"nTerrain");
	return nResult;
}

/* Returns the terrain movement penalty applied to the party's movement*/
float GetTerrainMovementRate(int nTerrainType)
{
	string sRate = Get2DAString(TABLE_MOVEMENT_RATE, "Movement_Rate", nTerrainType);
	float fRate = StringToFloat(sRate);
	
	/*(switch(nTerrainType)
	{
	case TERRAIN_ROAD:
		return TERRAIN_RATE_ROAD;
	case TERRAIN_JUNGLE:
		return TERRAIN_RATE_JUNGLE;
	case TERRAIN_DESERT:
		return TERRAIN_RATE_DESERT;
	case TERRAIN_PLAINS:
		return TERRAIN_RATE_PLAINS;
	case TERRAIN_FOREST:
		return TERRAIN_RATE_FOREST;
	case TERRAIN_HILLS:
		return TERRAIN_RATE_HILLS;
	case TERRAIN_MOUNTAINS:
		return TERRAIN_RATE_MOUNTAINS;
	case TERRAIN_SWAMP:
		return TERRAIN_RATE_SWAMP;
	}*/
	
	return fRate;
}
float GetTerrainModifiedRate(object oCreature, int nTerrainType)
{
	float fNewRate	= GetTerrainMovementRate(nTerrainType);
	//if(GetIsPC(oCreature))
		//PrettyDebug("fNewRate:" + FloatToString(fNewRate));

	//	For every 1 rank of Survival, the entering character/creature gets a
	//	+0.01 bonus to his movement rate.
	float fSurvivalMod	= NX2_TERRAIN_SPD_SURVIVAL_MOD * IntToFloat(GetSkillRank(SKILL_SURVIVAL, oCreature));
	
	//if(GetIsPC(oCreature))
		//PrettyDebug("fSurvivalMod:" + FloatToString(fSurvivalMod));
	
	fNewRate += fSurvivalMod;
	
	//	Cap the maximum move rate at Road speed (set in om_terrain_rate.2da)
	if (fNewRate > GetTerrainMovementRate(TERRAIN_ROAD))
		fNewRate = GetTerrainMovementRate(TERRAIN_ROAD);
	
	if (GetHasFeat(FEAT_EPITHET_FAV_OF_THE_ROAD, oCreature, TRUE))
	{
		fNewRate += NX2_TERRAIN_SPD_FAV_ROAD_BONUS;
	}
	
	if (GetLocalInt(oCreature, "bHostile") && !GetLocalInt(oCreature, "bAfraid") )
	{
		fNewRate *= NX2_TERRAIN_SPD_HOSTILE_MULT;
	}
	
	/*	Neutral encounters move slightly slower than the party.	*/
	if (GetLocalInt(oCreature, "bNeutral"))
	{
		fNewRate *= NX2_TERRAIN_SPD_NEUTRAL_MULT;
	}
	
	if (GetLocalInt(oCreature, "bAfraid"))
	{
		fNewRate *= NX2_TERRAIN_SPD_AFRAID_MULT;
	}

	//if(GetIsPC(oCreature))		
		//PrettyDebug("New movement rate: " + FloatToString(fNewRate));
		
	return fNewRate;
}
int GetTerrainBGM(int nTerrainType)
{
	int nResult = StringToInt(Get2DAString(TABLE_MOVEMENT_RATE, "Music_Track", nTerrainType));
	return nResult;
}

string GetTerrainAudioTrack(int nTerrainType)
{
	switch(nTerrainType)
	{
	case TERRAIN_ROAD:
	//	return 152;
		return "sfx_road";
	case TERRAIN_JUNGLE:
		//return 149;
		return "sfx_forest";
	case TERRAIN_DESERT:
		//return 151;
		return "sfx_desert";
	case TERRAIN_BEACH:
		//return 148;
		return "sfx_sea";
	case TERRAIN_PLAINS:
		//return 150;
		return "sfx_plains";
	}
	return "";
}

string GetTerrainWPPrefix(int nTerrain)
{
	switch(nTerrain)
	{
	case TERRAIN_FOREST:
		return WP_PREFIX_FOREST;
	case TERRAIN_DESERT:
		return WP_PREFIX_DESERT;
	case TERRAIN_BEACH:
		return WP_PREFIX_BEACH;
	case TERRAIN_ROAD:
		return WP_PREFIX_ROAD;	
	case TERRAIN_HILLS:
		return WP_PREFIX_HILLS;
	case TERRAIN_JUNGLE:
		return WP_PREFIX_JUNGLE;
	case TERRAIN_SWAMP:
		return WP_PREFIX_SWAMP;
	case TERRAIN_PLAINS:
		return WP_PREFIX_PLAINS;	
	}
	//PrettyDebug("Unable to find Terrain WP prefix for terrain " + IntToString(nTerrain));
	return "";
}

/*	Get number of valid rows in the Encounter List 2DA. This will allow
	use to randomly pick a valid row from the list when it's time to 
	spawn the encounter on the overland map.	*/
int GetNumValidRows(string sTable)
{
	int nCurrentRow			= 1;
	int nMaxRows			= 0;
	string sColumn			= "Label";
	string sEncounterName	= Get2DAString(sTable, sColumn, nCurrentRow);
	
	while (sEncounterName != "")
	{
		nMaxRows++;
		nCurrentRow++;
		sEncounterName	= Get2DAString(sTable, sColumn, nCurrentRow);
	}
		
	//PrettyDebug("Found " + IntToString(nMaxRows) + " valid rows.");
	return nMaxRows;
}


/*	Get the row in which the encounter resref is listed.	*/
int GetEncounterRow(string sTable)
{
	string sShutoffVariable;
	int nEncounterRow;
	int nEncounterShutoff;
	
	nEncounterRow = Random(GetNumValidRows(sTable))+1;
	sShutoffVariable = Get2DAString(sTable, SHUTOFF_COLUMN, nEncounterRow);
	nEncounterShutoff = GetGlobalInt(sShutoffVariable);
	if(nEncounterShutoff)
		return FALSE;
	
	else return nEncounterRow;
}

/*	Check the row of the Encounter List 2DA to see what encounter spawns.	*/
string GetEncounterRR(string sTable, int nEncounterRow)
{
	//string sTable			= "wm_encounters";
	//int nEncounterRow		= Random(GetNumValidRows(sTable))+1;
	
	string sCol 			= "ENC_RESREF";	
	string sEncounterRR		= Get2DAString(sTable, sCol, nEncounterRow);	
		
	return sEncounterRR;
}

/*	Check to see which Encounter List Table 2DA to pull monsters from.	*/
string GetEncounterTable(object oEncounterSource)
{
	int nRow		= GetLocalInt(oEncounterSource, "nEncounterTable");
	string sCol		= ENC_2DA;
	
	string sTable 	= Get2DAString(ENCOUNTER_AREAS_2DA, sCol, nRow);
	
	//PrettyDebug("Encounter Table: " + sTable);

	return sTable;		
}

int GetEncounterXP(int nPartyCR, int nEncEL)
{
	string sELColumn = "EL";
	sELColumn += IntToString(nEncEL);	//EL Columns are in the format ELX where X is the EL of the encounter.
	int nXP = StringToInt(Get2DAString(ENC_XP_2DA, sELColumn, nPartyCR));	//The Party's CR determines the Row of the 2DA.
	string sMessage = IntToString(nXP);
	return nXP;
}

void AwardEncounterXP(int nXP)
{
	CSLPlayerMessageBroadcastByStrRef(STRREF_ENC_XP_AWARD);
	object oPC = GetFirstPC();
	object oTarg = GetFirstFactionMember(oPC, FALSE);
	int nPartyMembers = 0;
	while(GetIsObjectValid(oTarg))
    {
		if(GetIsRosterMember(oTarg) || GetIsOwnedByPlayer(oTarg))
			nPartyMembers++;
			
     	oTarg = GetNextFactionMember(oPC, FALSE);
	}
	
	nXP /= nPartyMembers;
	
	oTarg = GetFirstFactionMember(oPC);
    while(GetIsObjectValid(oTarg))
    {
		if(GetIsRosterMember(oTarg) || GetIsOwnedByPlayer(oTarg))
			GiveXPToCreature( oTarg,nXP );
		
		oTarg = GetNextFactionMember(oPC);
    }
}

int SetEncounterBribeValue(object oEncounter)
{
	float fCR = GetChallengeRating(oEncounter);
	float fValue = 2*fCR;
	fValue = pow(fValue, 2.0f);
	
	int nResult = FloatToInt(fValue);
	if(nResult < 10)
		nResult = 10;
	
	SetCustomToken( 1000, IntToString(nResult));
	SetGlobalInt("BRIBE_AMOUNT", nResult);
	
	return nResult;
}

int ModEncounterBribeValue(float fModPercent)
{
	int nCurrentAmount = GetGlobalInt("BRIBE_AMOUNT");
	float fCurrentAmount = IntToFloat(nCurrentAmount);
	//PrettyDebug(FloatToString(fModPercent) + " percent of " + FloatToString(fCurrentAmount));			
	float fResult = (fCurrentAmount * fModPercent * 0.01f);
	int nResult = FloatToInt(fResult);
	//PrettyDebug("New Bribe Value:" + IntToString(nResult));
	SetCustomToken( 1000, IntToString(nResult));
	SetGlobalInt("BRIBE_AMOUNT", nResult);
	
	return nResult;
}

/*--------------------------\
|	Party Actor Functions	|
\--------------------------*/
object SetPartyActor(object oNewActor, object oCurrentOverride = OBJECT_INVALID)
{
	object oCurrentActor;
	int bOverride;
	if(oCurrentOverride == OBJECT_INVALID)
	{
		oCurrentActor = GetLocalObject(GetModule(), "oPartyLeader");
		bOverride = FALSE;
	}	
	
	else
	{
		oCurrentActor = oCurrentOverride;
		bOverride = TRUE;
	}
	//PrettyDebug("Current Actor:" + GetName(oCurrentActor));
	//PrettyDebug("New Actor:" + GetName(oNewActor));
	AssignCommand(oCurrentActor, ClearAllActions(TRUE));
	AssignCommand(oNewActor, ClearAllActions(TRUE));
	
	SetScriptHidden(oCurrentActor, TRUE, FALSE);
	SetScriptHidden(oNewActor, FALSE);
	
	location lLocation = GetLocation(oCurrentActor);
	if(bOverride == FALSE)		//If we are aborting a selection don't jump.
		AssignCommand(oNewActor, JumpToLocation(lLocation));
	
	DelayCommand(0.1f, SetFactionLeader(oNewActor));
	SetOwnersControlledCompanion( oCurrentActor, oNewActor );
	SetLocalObject(GetModule(), "oPartyLeader", oNewActor);
	
	object oTerrain = GetNearestTerrainTrigger(oNewActor);
	int nTerrain = GetTerrainType(oTerrain);
	float fNewRate = GetTerrainModifiedRate(oNewActor, nTerrain);
	SetMovementRateFactor(oNewActor, fNewRate);
	return oNewActor;
}

int GetPartyChallengeRating()
{
	object oPartyMember = GetFirstFactionMember(GetFirstPC(), FALSE);
	int nHD;
	int nTotalPartyLevels;
	int nPartySize;
	float fPartyCR;
	
	while (GetIsObjectValid(oPartyMember))
	{
		nHD = GetTotalLevels(oPartyMember, FALSE);
		nTotalPartyLevels = nTotalPartyLevels + nHD;
		nPartySize++;
		oPartyMember = GetNextFactionMember(GetFirstPC(), FALSE);
	}
	
	fPartyCR = IntToFloat(nTotalPartyLevels) / IntToFloat(nPartySize);
	
	return FloatToInt(fPartyCR);
}

/*	Update spawned creature with CR info and color code him
	appropriately based on the party's CR vs. creature CR.	*/
void DisplayChallengeRating(object oPC, object oCreature)
{
	string sName	= GetName(oCreature);
	string sCR		= GetStringByStrRef(234257); // "CR "
	int nEnemyCR	= FloatToInt(GetChallengeRating(oCreature));
	int nPartyCR	= GetPartyChallengeRating();
	int nCRDiff		= nEnemyCR - nPartyCR;
	
	//PrettyDebug(sName + "CR: " + IntToString(nEnemyCR));
	//PrettyDebug("Party CR: " + IntToString(nPartyCR));
	
	//	Impossible - CR +5
	if (nCRDiff >= 5)
		SetFirstName(oCreature, sName + "\n" + "(" + "<color=FUCHSIA>" + sCR + IntToString(nEnemyCR) + "</color>" + ")");
	
	//	Overpowering - CR +4/+3
	else if (nCRDiff == 4 || nCRDiff == 3)
		SetFirstName(oCreature, sName + "\n" + "(" + "<color=RED>" + sCR + IntToString(nEnemyCR) + "</color>" +")");
	
	//	Very Difficult - CR +2/+1
	else if (nCRDiff == 2 || nCRDiff == 1)
		SetFirstName(oCreature, sName + "\n" + "(" + "<color=ORANGE>" + sCR + IntToString(nEnemyCR) + "</color>" +")");	
	
	//	Challenging - CR +0/-1
	else if (nCRDiff == 0 || nCRDiff == -1)
		SetFirstName(oCreature, sName + "\n" + "(" + "<color=YELLOW>" + sCR + IntToString(nEnemyCR) + "</color>" + ")");
	
	//	Moderate - CR -2/-3
	else if (nCRDiff == -2 || nCRDiff == -3)
		SetFirstName(oCreature, sName + "\n" + "(" + "<color=DEEPSKYBLUE>" + sCR + IntToString(nEnemyCR) + "</color>" + ")");
	
	//	Easy - CR -4/-5
	else if (nCRDiff == -4 || nCRDiff == -5)
		SetFirstName(oCreature, sName + "\n" + "(" + "<color=LIME>" + sCR + IntToString(nEnemyCR) + "</color>" + ")");
							
	//	Effortless - CR -6
	else
		SetFirstName(oCreature, sName + "\n" + "(" + "<color=WHITE>" + sCR + IntToString(nEnemyCR) + "</color>" + ")");
}

/*------------------------------\
|	Special Encounter Functions	|
\------------------------------*/
string GetSpecialEncounterTable(object oArea = OBJECT_SELF)
{
	string sTable 	= GetLocalString(oArea, VAR_SE_TABLE);
	
	//PrettyDebug("Special Encounter Table: " + sTable);

	return sTable;	
}


object SpawnSpecialEncounter(string sTable, location lLocation)
{
	int nEncounterRow = Random(GetNumValidRows(sTable))+1;
	string sResRef = Get2DAString(sTable, "ENC_RESREF", nEncounterRow);
	
	int nValidTerrain = StringToInt(Get2DAString(sTable, "nTerrain", nEncounterRow));
	int bSEFired = GetGlobalInt(sResRef + "_FIRED");
	
	if( GetTerrainAtLocation(lLocation) == nValidTerrain && !bSEFired)
	{
		SetGlobalInt(sResRef + "_FIRED", TRUE);
		//PrettyDebug("Spawning sEncounterRR:"+sResRef);
		object oSE = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLocation);
		
			SetEncounterLocalVariables(oSE, sTable, nEncounterRow);
		
		SetSEStartLocation(lLocation, oSE);
		SetLocalInt(OBJECT_SELF, VAR_SE_FLAG, TRUE);
		return oSE;
	}
	
	else return OBJECT_INVALID;
}

void SetSEStartLocation(location lLocation, object oSE = OBJECT_SELF)
{
	SetLocalLocation(oSE, VAR_SE_START_LOC, lLocation);
}
location GetSEStartLocation(object oSE = OBJECT_SELF)
{
	return GetLocalLocation(oSE, VAR_SE_START_LOC);
}

/*------------------------------\
|	Player Location Functions	|
\------------------------------*/
void SetCurrentPCTerrain(int nTerrain)
{
	//PrettyDebug("PC terrain type = " + IntToString(nTerrain));
	SetGlobalInt(VAR_PC_TERRAIN, nTerrain);
}

void SetGlobalLocation(string sVar, location lTarget)
{
	object oArea = GetAreaFromLocation(lTarget);
	vector vTarg = GetPositionFromLocation(lTarget);
	float fFace = GetFacingFromLocation(lTarget);
	
	SetGlobalFloat(sVar + "x", vTarg.x);
	SetGlobalFloat(sVar + "y", vTarg.y);
	SetGlobalFloat(sVar + "z", vTarg.z);
	SetGlobalFloat(sVar + "f", fFace);
	SetGlobalString(sVar + "a", GetTag(oArea));
}

location GetGlobalLocation(string sVar)
{
	float x = GetGlobalFloat(sVar + "x");
	float y = GetGlobalFloat(sVar + "y");
	float z = GetGlobalFloat(sVar + "z");
	float fFace = GetGlobalFloat(sVar + "f");
	object oArea = GetObjectByTag(GetGlobalString(sVar + "a"));
	
	return Location(oArea,Vector(x,y,z),fFace);
}

/*	Stores the party's current location on the Overland Map.	*/
void StorePlayerMapLocation(object oPC)
{
	//PrettyDebug("Storing Overland Map location.");
	SetGlobalLocation(VAR_PARTY_LOCATION, GetLocation(oPC));
	object oPlayerMarker = GetObjectByTag(TAG_PLAYER_MARKER);
	
	/*	Remove the previous marker.	*/		
	if(GetIsObjectValid(oPlayerMarker))
	{
		DestroyObject(oPlayerMarker);
	}
}

/*	Restores the party to its last location on the Overland Map.	*/
void RestorePlayerMapLocation(object oPC)
{
	//PrettyDebug("Overland Map location restored.");
	location lPC = GetGlobalLocation(VAR_PARTY_LOCATION);
	object oPlayerMarker = CreateObject(OBJECT_TYPE_WAYPOINT, TAG_PLAYER_MARKER, lPC);
	object oFailSafe = GetObjectByTag(TAG_HOSTILE_SPAWN);
	
	object oFM = GetFirstFactionMember( oPC, FALSE );
	while ( GetIsObjectValid( oFM ) == TRUE )
	{
		effect eEffect = GetFirstEffect(oFM);
		while(GetIsEffectValid(eEffect))
		{
			if(GetEffectType(eEffect) == EFFECT_TYPE_HITPOINT_CHANGE_WHEN_DYING)
			{
				if(GetEffectInteger(eEffect, 0) != TRUE)
				{
					effect eDeath = EffectDeath(FALSE,FALSE,TRUE,TRUE);
					DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oFM));
				}
			}
			
			eEffect = GetNextEffect(oFM);
		}
		oFM = GetNextFactionMember( oPC, FALSE );
	}
	if (!GetIsObjectValid(oPlayerMarker))
	{
		//PrettyDebug("Error! No restore point found!");
		JumpPartyToArea(oPC, oFailSafe);
	}
	
	JumpPartyToArea(oPC, oPlayerMarker);
}

string GetEncounterConversation()
{
	//PrettyDebug(GetLocalString(OBJECT_SELF, "sConv"));
	return GetLocalString(OBJECT_SELF, "sConv");
}


/*	Randomly determine how many creatures in the subgroup show up in total. Min
	and max values are drawn from the relevant Encounter List 2DA.	*/
int GetTotalCreatures(int nMin, int nMax)
{
	int nTotal;

	if (nMax > nMin)
	{ 
		nTotal = Random(nMax - nMin + 1) + nMin;
	}
	
	else if (nMin == nMax)
	{
		nTotal = nMax;							// Min = Max, so always spawn that number of creatures.
	}
	
	//else if (nMin > nMax)
	//{
		//PrettyDebug ("Minimum creatures is higher than maximum! This is an error in the encounter 2da");
	//}	 
	
	return nTotal;
}

void ApplyDialogSkillEffect(object oEncCreature, int nDialogSkill, int nSkillMargin)
{
	switch (nDialogSkill)
	{
		case SKILL_DIPLOMACY:
		break;
						
		case SKILL_BLUFF:
		{
			if(nSkillMargin > 10)
				nSkillMargin = 10;
			
			int nRoundsOffGuard = nSkillMargin;
			
			float fSecondsOffGuard = IntToFloat(nRoundsOffGuard) * 6.0f;
			//PrettyDebug("Applying Offguard Effect for " + FloatToString(fSecondsOffGuard) + " seconds to" + GetName(oEncCreature));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectOffGuard(), oEncCreature, fSecondsOffGuard);
		}
		break;
						
		case SKILL_INTIMIDATE:
		{
			if(nSkillMargin > 10)
				nSkillMargin = 10;
			
			int nRoundsFrightened = nSkillMargin - 5;				//Maximum 5 rounds frightened
			
			float fSecondsFrightened = IntToFloat(nRoundsFrightened) * 6.0f;
			//PrettyDebug("Applying Frightened Effect for " + FloatToString(fSecondsFrightened) + " seconds.");
			if(fSecondsFrightened > 0.0f)
			{
				//PrettyDebug("Applying Frightened Effect");
				nSkillMargin -= 5;
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oEncCreature, fSecondsFrightened);
			}
						
			
			float fSecondsShaken = IntToFloat(nSkillMargin) * 6.0f;
			//PrettyDebug("Applying Shaken Effect for " + FloatToString(fSecondsShaken) + " seconds.");
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectShaken(), oEncCreature, fSecondsShaken);
		}			
		break;

	}
}

void SpawnEncounterSubgroup(object oWP, string sCreatureRR, int nNumCreatures, int bForceHostile, int nDialogSkill, int nSkillMargin, string sGroupName)
{
	location lSpawn;
	location lWP		= GetLocation(oWP);
	float fFacing		= GetFacing(oWP);
	int nRR 			= 1; // Always a minimum of 1 creature

	while(nRR <= nNumCreatures)
	{
		lSpawn = SCGetBMALocation(lWP, nRR, 3.0f);
		//PrettyDebug("Spawning " + sCreatureRR + " at waypoint " + GetTag(oWP) + " at position " + VectorToString(GetPositionFromLocation(lSpawn)));
		object oEncCreature = CreateObject(OBJECT_TYPE_CREATURE, sCreatureRR, lSpawn);
		
		if(bForceHostile)
			ChangeToStandardFaction(oEncCreature, STANDARD_FACTION_HOSTILE);
			
		if(nDialogSkill)
		{
			ApplyDialogSkillEffect(oEncCreature, nDialogSkill, nSkillMargin);
			//PrettyDebug("Applying Dialog Skill:" + IntToString(nDialogSkill) + " to " + GetName(oEncCreature));
		}
		
		SCGroupAddMember(sGroupName, oEncCreature);
		nRR++;
	}
}


void SpawnEncounterCreatures(object oWP, int nDialogSkill, int nSkillMargin, int bGroup1ForceHostile = FALSE, int bGroup2ForceHostile = FALSE, 
							int bGroup3ForceHostile = FALSE, int bGroup4ForceHostile = FALSE, int bGroup5ForceHostile = FALSE, string sGroupNamePrefix = "")
{
	/*	Retrieve the values of the Encounter List 2DA and row stored on the
		overland map creature.	*/
	string sEncounterList2DA	= GetLocalString(OBJECT_SELF, "sEncounterList2DA");
	int nEncounterIndex			= GetLocalInt(OBJECT_SELF, "nRow");
	
	string sCreatureCol	= "CREATURE_RESREF_";
	string sMinCol 		= "MIN_RR_";
	string sMaxCol 		= "MAX_RR_";
	
	string sCreature1	= Get2DAString(sEncounterList2DA, sCreatureCol + "1", nEncounterIndex);
	string sCreature2	= Get2DAString(sEncounterList2DA, sCreatureCol + "2", nEncounterIndex);
	string sCreature3	= Get2DAString(sEncounterList2DA, sCreatureCol + "3", nEncounterIndex);
	string sCreature4	= Get2DAString(sEncounterList2DA, sCreatureCol + "4", nEncounterIndex);
	string sCreature5	= Get2DAString(sEncounterList2DA, sCreatureCol + "5", nEncounterIndex);
	
	string sMinRR1 = Get2DAString(sEncounterList2DA, sMinCol + "1", nEncounterIndex);
	string sMinRR2 = Get2DAString(sEncounterList2DA, sMinCol + "2", nEncounterIndex);
	string sMinRR3 = Get2DAString(sEncounterList2DA, sMinCol + "3", nEncounterIndex);
	string sMinRR4 = Get2DAString(sEncounterList2DA, sMinCol + "4", nEncounterIndex);
	string sMinRR5 = Get2DAString(sEncounterList2DA, sMinCol + "5", nEncounterIndex);
	
	string sMaxRR1 = Get2DAString(sEncounterList2DA, sMaxCol + "1", nEncounterIndex);
	string sMaxRR2 = Get2DAString(sEncounterList2DA, sMaxCol + "2", nEncounterIndex);
	string sMaxRR3 = Get2DAString(sEncounterList2DA, sMaxCol + "3", nEncounterIndex);
	string sMaxRR4 = Get2DAString(sEncounterList2DA, sMaxCol + "4", nEncounterIndex);
	string sMaxRR5 = Get2DAString(sEncounterList2DA, sMaxCol + "5", nEncounterIndex);
	
	int nMinRR1 = StringToInt(sMinRR1); 
	int nMaxRR1 = StringToInt(sMaxRR1);
		
	int nMinRR2 = StringToInt(sMinRR2); 
	int nMaxRR2 = StringToInt(sMaxRR2); 
		
	int nMinRR3 = StringToInt(sMinRR3); 
	int nMaxRR3 = StringToInt(sMaxRR3); 
		
	int nMinRR4 = StringToInt(sMinRR4); 
	int nMaxRR4 = StringToInt(sMaxRR4); 
		
	int nMinRR5 = StringToInt(sMinRR5); 
	int nMaxRR5 = StringToInt(sMaxRR5); 
	
	int nTotal;
		
	/*	Check to see if there's a valid resref entered, and if so, spawn
		the randomly generated number of creatures.	*/
	if (sCreature1 != "")
	{
		nTotal = GetTotalCreatures(nMinRR1, nMaxRR1);
		//PrettyDebug("Spawning creature group 1.");
		SpawnEncounterSubgroup(oWP, sCreature1, nTotal, bGroup1ForceHostile, nDialogSkill, nSkillMargin, sGroupNamePrefix + ENC_GROUP_NAME_1);
	}
	
	if (sCreature2 != "")
	{
		nTotal = GetTotalCreatures(nMinRR2, nMaxRR2);
		//PrettyDebug("Spawning creature group 2.");
		SpawnEncounterSubgroup(oWP, sCreature2, nTotal, bGroup2ForceHostile, nDialogSkill, nSkillMargin, sGroupNamePrefix + ENC_GROUP_NAME_2);
	}
	
	if (sCreature3 != "")
	{
		nTotal = GetTotalCreatures(nMinRR3, nMaxRR3);
		//PrettyDebug("Spawning creature group 3.");
		SpawnEncounterSubgroup(oWP, sCreature3, nTotal, bGroup3ForceHostile, nDialogSkill, nSkillMargin, sGroupNamePrefix + ENC_GROUP_NAME_3);
	}
	
	if (sCreature4 != "")
	{
		nTotal = GetTotalCreatures(nMinRR4, nMaxRR4);
		//PrettyDebug("Spawning creature group 4.");
		SpawnEncounterSubgroup(oWP, sCreature4, nTotal, bGroup4ForceHostile, nDialogSkill, nSkillMargin, sGroupNamePrefix + ENC_GROUP_NAME_4);
	}
	
	if (sCreature5 != "")
	{
		nTotal = GetTotalCreatures(nMinRR5, nMaxRR5);
		//PrettyDebug("Spawning creature group 5.");
		SpawnEncounterSubgroup(oWP, sCreature5, nTotal, bGroup5ForceHostile, nDialogSkill, nSkillMargin, sGroupNamePrefix + ENC_GROUP_NAME_5);
	}
}		



string GetEncounterWPSuffix(int bEnemy = FALSE)
{
	string sResult;
	
	if(bEnemy)
		sResult = WP_ENEMY_DESIGNATOR;
		
	else
		sResult = WP_PARTY_DESIGNATOR;
	
	sResult += WP_SUFFIX_DEFAULT;
	
	return sResult;

}

/*	Choose a random map from the appropriate terrain type and spawn in the
	creatures.	*/
void InitiateEncounter(int nDialogSkill, int nSkillDC, int bGroup1ForceHostile = FALSE, int bGroup2ForceHostile = FALSE, 
						int bGroup3ForceHostile = FALSE, int bGroup4ForceHostile = FALSE, int bGroup5ForceHostile = FALSE, object oPC = OBJECT_INVALID)
{
	int nTerrain		= GetCurrentPCTerrain();
	int nSkillRanks	= GetSkillRank(nDialogSkill, oPC);
	int nSkillMargin = nSkillRanks - nSkillDC;
	int nRand			= Random(GetNumTerrainMaps(nTerrain)) + 1;
	
	string sPrefix		= GetTerrainWPPrefix(nTerrain);

	if(nRand < 10)
	{
		sPrefix += "0";
	}			
	string sPartyWP, sEnemyWP;
	
	sPrefix += IntToString(nRand);
		
	sPartyWP += sPrefix;
	sEnemyWP += sPrefix;
	sPartyWP += GetEncounterWPSuffix();
	sEnemyWP += GetEncounterWPSuffix(TRUE);
	
	object oPartyWP = GetObjectByTag(sPartyWP);
	object oEnemyWP = GetObjectByTag(sEnemyWP);
	
	//Failsafe - if the waypoint is invalid you'll now go to plains.
	if(GetIsObjectValid(oPartyWP) == FALSE || GetIsObjectValid(oEnemyWP) == FALSE )
	{
		//PrettyDebug("The Party and/or Enemy Destination waypoints are invalid! Rerouting to plains01. This is a bug.", CSL_PRETTY_DURATION, POST_COLOR_ERROR);
		oPartyWP = GetObjectByTag(WP_PARTY_FAILSAFE);
		oEnemyWP = GetObjectByTag(WP_ENEMY_FAILSAFE);
	}
	
	RemoveAllEffects(oPC,FALSE);
	
	SpawnEncounterCreatures(oEnemyWP, nDialogSkill, nSkillMargin, bGroup1ForceHostile, bGroup2ForceHostile, 
							bGroup3ForceHostile, bGroup4ForceHostile, bGroup5ForceHostile);
	
	StorePlayerMapLocation(oPC);
	object oEncArea = GetArea(oPartyWP);
	SetCurrentPCTerrain(0);
	SetLocalInt(oEncArea, "nEncounterEL", FloatToInt(GetChallengeRating(OBJECT_SELF)));
	ExitOverlandMap(oPC);
	JumpPartyToArea(oPC, oPartyWP);
}

location GetEncounterSpawnLocation(object oPC, float fSpotDistance)
{
	vector vPC = GetPosition(oPC);
	float fAngle = CSLRandomUpToFloat(360.0);
	
	float iXVariance = cos(fAngle)*fSpotDistance;
	float iYVariance = sin(fAngle)*fSpotDistance;
						
	vPC.x += iXVariance;
	vPC.y += iYVariance;
	
	location lResult = Location(GetArea(oPC), vPC, 180.0);
	return lResult;
}

object GetNearestTerrainTrigger(object oPC)
{
	location lTest = GetLocation(oPC);			//Pick a random encounter point near the player.
	object oArea = GetArea(oPC);
		
	object oTrigger = GetFirstSubArea(oArea, GetPositionFromLocation(lTest));
	
	while( GetIsObjectValid(oTrigger) && ( GetTag(oTrigger) != "nx2_tr_terrain" ) )
	{
		oTrigger = GetNextSubArea(oArea);
	}
	
	if(GetIsObjectValid(oTrigger))
		return oTrigger;
		
	else
		return GetNearestObjectByTag("nx2_tr_terrain", oPC);
}


/*--------------------------\
|	Encounter Functions		|
\--------------------------*/
int InitializeEncounter(object oPC)
{
	if(GetGlobalInt(VAR_ENC_IGNORE))
	{
		return FALSE;
	}
	
	object oEncounter = CreateEncounterNearPC(oPC);
	
	if(GetIsObjectValid(oEncounter))
	{
		effect eSpawn = EffectNWN2SpecialEffectFile(VFX_HOSTILE_ENC_SPAWN);
		effect eHostile = EffectNWN2SpecialEffectFile(VFX_HOSTILE_ENC);
		SetLocalInt(oEncounter, "bHostile", TRUE);
		SetCustomHeartbeat(oEncounter, 6000);		//Initialize the custom heartbeat system... this could cause a weird problem if it failed for whatever reasons...
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpawn, oEncounter));
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHostile, oEncounter));
		DelayCommand(0.1f, BeginRandomWalk());
		string sFeedback = GetStringByStrRef(233947) + " ";
		sFeedback += GetName(oEncounter);
		
		FloatingTextStringOnCreature(sFeedback, oPC, FALSE);
		return TRUE;
	}
	
	else
	{
		//PrettyDebug("Invalid Encounter.  Please Report this as a bug.");
		return FALSE;
	}
}

void BeginRandomWalk()
{
	ClearAllActions(TRUE);
	ActionRandomWalk();
}

float DetermineEncounterDistance(object oPC)
{
	object oArea = GetArea(oPC);
	
	int nSkillToUse = SKILL_SPOT;
	if( GetSkillRank(SKILL_LISTEN, oPC) > GetSkillRank(SKILL_SPOT, oPC))
		nSkillToUse = SKILL_LISTEN;
	
	int nDC = GetLocalInt(GetNearestTerrainTrigger(oPC), "nDetectDC");
	
	if(nDC == 0)
		nDC = GetLocalInt(oArea, "nDetectDC");
		
	if(GetIsSkillSuccessful(oPC, nSkillToUse, nDC))
		return CSLRandomBetweenFloat(9.0f, 12.0f);
		
	else
		return CSLRandomBetweenFloat(4.0f, 6.0f);
}

object CreateEncounterNearPC(object oPC)
{
	object oResult;
	int iValidResult = FALSE;
	object oWP = GetNearestObjectByTag(TAG_HOSTILE_SPAWN, oPC);

	object oArea = GetArea(oPC);	
	
	float fDist = DetermineEncounterDistance(oPC);
	//PrettyDebug("fDist = " + FloatToString(fDist));

	do{
		location lTest = CreateTestEncounterSpawnLocation(oPC, fDist);			//Pick a random encounter point near the player.
		
		object oTrigger = GetFirstSubArea(oArea, GetPositionFromLocation(lTest));
	
		while( GetIsObjectValid(oTrigger) && ( GetTag(oTrigger) != "nx2_tr_terrain" ) )
		{
			oTrigger = GetNextSubArea(oArea);
		}
		
		//make sure we have an actual valid "terrain" trigger
		if (!GetIsObjectValid(oTrigger))
			return OBJECT_INVALID;
		
		string sEncounterTable = GetEncounterTable(oTrigger);			//Get the encounter data from that trigger.
		
		int nRow = GetEncounterRow(sEncounterTable);
		
		if(!nRow)
			return OBJECT_INVALID;
		
		string sEncounterRR = GetEncounterRR(sEncounterTable, nRow);
	
		//PrettyDebug("Encounter resref: " + sEncounterRR);
//		PrettyDebug("Spawning " + sEncounterRR + ".");
	
		oResult = CreateObject( OBJECT_TYPE_CREATURE, sEncounterRR, GetLocation(oWP) );		//Create the appropriate encounter for the trigger
		
		DisplayChallengeRating(oPC, oResult);	
			
		//PrettyDebug(GetTag(oResult));
		if( !GetIsObjectValid(oResult) )
		{
			//PrettyDebug("Table: " + sEncounterTable + " Row: " + IntToString(nRow) + " is invalid... spawn table is bad");
			return OBJECT_INVALID;
		}

		location lSafe = CalcSafeLocation(oResult, lTest, 1.0, FALSE, FALSE);	//Find out if the test location is valid for the creature
		
		vector vTest = GetPositionFromLocation(lTest);								//Get the vector data from the test and safe locations
		vector vSafe = GetPositionFromLocation(lSafe);
		

		
		if( CSLCompareVectors2D(vTest, vSafe) )							//If we've created a valid object 
		{																//and we're placing it in a safe spot (i.e. vTest and vSafe are equal)
			iValidResult = TRUE;										//Break the loop,
			SetEncounterLocalVariables(oResult, sEncounterTable, nRow);	//Set the proper variables on the object
			AssignCommand(oResult, JumpToLocation(lTest));				//and move the creature to the test/safe spot.
		}
		
		else
			DestroyObject(oResult);
			
	}while(iValidResult == FALSE);
	
	return oResult;
}


void MoveEncounterToSpawnLocation(object oEncounter, object oPC)
{
	location lLocation, lSafe;
	vector vTest, vSafe;
				
	do{
		//PrettyDebug("Generating Random Location");
		lLocation = GetEncounterSpawnLocation(oPC, 12.0f);
		lSafe = CalcSafeLocation(oEncounter, lLocation, 1.0, FALSE, FALSE);
				
		vTest = GetPositionFromLocation(lLocation);
		vSafe = GetPositionFromLocation(lSafe);
	}while (!CSLCompareVectors2D(vTest, vSafe));
			
	
}

void SetEncounterLocalVariables(object oEncounter, string sEncounterTable, int nRow)
{
	string sConv = Get2DAString(sEncounterTable, "sConv", nRow);
	int nLifespan = StringToInt(Get2DAString(sEncounterTable, VAR_ENC_LIFESPAN, nRow));
	float fSearchDist = StringToFloat(Get2DAString(sEncounterTable, "fSearchDist", nRow));
	int nSurvivalDC = StringToInt(Get2DAString(sEncounterTable, "nSurvivalDC", nRow));
	/*	Store the name of the Encounter List 2DA and the row of the
		encounter on the newly spawned overland map creature. When it comes time
		to spawn the encounter on a map, it will reference the correct
		Encounter List 2DA and draw creatures from the appropriate row.	*/
	/* Store the Overland Map Gameplay Variables on the Creature. */
	
	SetLocalString(oEncounter, "sEncounterList2DA", sEncounterTable);
	SetLocalInt(oEncounter, "nRow", nRow);
	SetLocalString(oEncounter, "sConv", sConv);
	
//	PrettyDebug("Encounter Conversation:"+sConv);
//	PrettyDebug("Encounter Lifespan:"+IntToString(nLifespan));
	
	SetLocalInt(oEncounter, VAR_ENC_LIFESPAN, nLifespan);
	SetLocalFloat(oEncounter, "fSearchDist", fSearchDist);
	SetLocalInt(oEncounter, "nSurvivalDC", nSurvivalDC);
}

location CreateTestEncounterSpawnLocation(object oPC, float fDist = 8.0f)
{
	location lLocation, lSafe;
	vector vTest, vSafe;

	do{
		//PrettyDebug("Generating Random Location");
		lLocation = GetEncounterSpawnLocation(oPC, fDist);
		lSafe = CalcSafeLocation(oPC, lLocation, 1.0, FALSE, FALSE);
				
		vTest = GetPositionFromLocation(lLocation);
		vSafe = GetPositionFromLocation(lSafe);
	}while (!CSLCompareVectors2D(vTest, vSafe));

	return lLocation;
}

//This function will repopulate all "always on" encounters, and will also attempt to spawn a random non-always on encounter
void InitializeNeutralEncounter(object oPC, object oArea = OBJECT_SELF)
{

	string sTable = GetEncounterTable(oArea);
	int nNumRows = GetNum2DARows( sTable );
	
	//Spawn all of the "always on" encounters - if we don't already have enough.
	int i = 1;
	for (i = 0; i <= nNumRows; i++)
	{
		if(StringToInt(Get2DAString(sTable, "bAlwaysOn", i)))
		{
			string sEncounterRR = GetEncounterRR(sTable, i);
			
			int nMaxPop = GetEncounterMaxPopulation(sTable, i);
			int nCurrentPop = GetCurrentEncounterPopulation(oPC, sEncounterRR);
			
			if(nCurrentPop <= nMaxPop )
			{
				int j;
				for(j = nCurrentPop; j <= nMaxPop; j++)
				{
					object oWP = GetNearestObjectByTag(TAG_NEUTRAL_SPAWN, oPC);
	
					object oEnc = CreateObject(OBJECT_TYPE_CREATURE, sEncounterRR, GetLocation(oWP));
					
					DisplayChallengeRating(oPC, oEnc);
					SetLocalInt(oEnc, "bNeutral", TRUE);
					SetEncounterLocalVariables(oEnc, sTable, i);
				}
			}
		}
	}
	
	int nRow;
	do{
		nRow = GetEncounterRow(sTable);
	} while( StringToInt(Get2DAString(sTable, "bAlwaysOn", nRow)) != TRUE );
	
	string sEncounterRR = GetEncounterRR(sTable, nRow);
	
	if( GetCurrentEncounterPopulation(oPC, sEncounterRR) >= GetEncounterMaxPopulation(sTable, nRow) )
	{
		//PrettyDebug("Too many of " + sEncounterRR);
		return;
	}

	else
	{
		object oWP = GetNearestObjectByTag(TAG_NEUTRAL_SPAWN, oPC);

		object oEnc = CreateObject(OBJECT_TYPE_CREATURE, sEncounterRR, GetLocation(oWP));
		SetLocalInt(oEnc, "bNeutral", TRUE);
		SetEncounterLocalVariables(oEnc, sTable, nRow);
	}
}

int GetCurrentEncounterPopulation(object oPC, string sEncounterTag)
{
	object oCreature = GetNearestObjectByTag(sEncounterTag, oPC);
	
	if (oCreature == OBJECT_INVALID)
		return 0;
		
	else
	{
		int i=1;
		while(GetIsObjectValid(oCreature))
		{
			i++;
			oCreature = GetNearestObjectByTag(sEncounterTag, oPC, i);
		}
		
		return i;
	}
}

int GetEncounterMaxPopulation(string sTable, int nRow)
{
	int nResult = StringToInt(Get2DAString(sTable, MAX_POP_COLUMN, nRow));
	return nResult;
}

void InitializeSpecialEncounter(object oPC)
{
	if(!GetGlobalInt(VAR_ENC_IGNORE))
	{
		location lPlayerLocation = GetLocation(oPC);
		location lSavedLocation = GetGlobalLocation("00_lSavedLocation");
		if(lPlayerLocation != lSavedLocation)
		{
			//PrettyDebug("Spawning a Special Encounter.");
			string sTable = GetSpecialEncounterTable(GetArea(oPC));
			location lLocation = CreateTestEncounterSpawnLocation(oPC);
			SpawnSpecialEncounter(sTable, lLocation);
			SetGlobalLocation("00_lSavedLocation", lPlayerLocation);
		}
	}
}

void ResetSpecialEncounterTimer(object oArea = OBJECT_SELF)
{
	int nSpecialEncounterCooldown = Random(SE_RATE_VARIANCE) + (SE_RATE_MINIMUM) + 1;
	SetLocalInt(oArea, VAR_ENC_SPECIAL_COOLDOWN, nSpecialEncounterCooldown);
}

/*
used CSLStringAfter instead of this function, need to research the effect this willhave
string GetStringSuffix(string sStringToTest, string sDelimiter = "_")
{
	int i=1;
	string sResult, sTemp;
	
	while( i <= GetStringLength(sStringToTest) )
	{
		sResult = GetStringRight(sStringToTest, i);
				
		int nTemp = i+1;
		sTemp = GetStringRight(sStringToTest, nTemp);

		if( TestStringAgainstPattern( sDelimiter + "**", sTemp) )
			return sResult;
		
		else
			i++;
	}
	
	return "";
}
*/

string GetTravelPlaceableResRef(object oIpoint = OBJECT_SELF)
{
	string sIpointTag = GetTag(oIpoint);
	string sPrefix = CSLStringBefore(sIpointTag,"_");
	string sSuffix = CSLStringAfter(sIpointTag,"_");
	
	string sResult = sPrefix + PLC_TRAVEL_TAG + sSuffix;
	return sResult;
}

string GetDestWPTag(object oPlaceable = OBJECT_SELF)
{
	string sPlcTag = GetTag(oPlaceable);
	string sSuffix = CSLStringBefore(sPlcTag,"_");	//We need to convert fyy_plc_to_fxx
	string sPrefix = CSLStringAfter(sPlcTag,"_");	//to fxx_wp_from_fyy
	
	string sResult = sPrefix + WP_DEST_TAG + sSuffix;
	return sResult;
}

string GetExitWPTag(object oPlaceable = OBJECT_SELF)
{
	string sPlcTag = GetTag(oPlaceable);
	string sPrefix = CSLStringBefore(sPlcTag,"_");
	string sSuffix = CSLStringAfter(sPlcTag,"_");
	
	string sResult = sPrefix + WP_DEST_TAG + sSuffix;
	return sResult;
}

effect EffectShaken()
{
	effect eLink = EffectLinkEffects(EffectAttackDecrease(-2), EffectSavingThrowDecrease(SAVING_THROW_ALL, -2));
	effect eResult = EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_confusion"), eLink);
	
	return eResult;
}

effect EffectOffGuard()
{
	effect eLink = EffectLinkEffects(EffectACDecrease(-2), EffectSavingThrowDecrease(SAVING_THROW_ALL, -2));
	effect eResult = EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_confusion"), eLink);
	
	return eResult;
}

void ExitOverlandMap(object oPC)
{
	object oParty = GetFirstFactionMember(oPC, FALSE); 

	while (GetIsObjectValid(oParty))
	{
		//PrettyDebug("Removing all effects from " + GetName(oParty));
		RemoveAllEffects(oParty, FALSE);
		
		if(GetIsPC(oParty))
		{
			DeactivateOLMapUI(oParty);
		}
				
		SetLocalInt(oParty, "bLoaded", FALSE); 
		/* Restore the PC's default movement rate	*/
		//float fCurrentRate = GetMovementRateFactor(oParty);
		//float fRestoredRate = (1.00f - fCurrentRate) + fCurrentRate;
		SetMovementRateFactor(oParty, 1.00f);
		
		if(GetScriptHidden(oParty))
			SetScriptHidden(oParty, FALSE);
		
		ClearCombatOverrides(oParty);
		SetCurrentPCTerrain(0);
		SetLocalInt(oParty, "pcshrunk", FALSE);
		oParty = GetNextFactionMember(oPC, FALSE);
	}
}

/*--------------------------\
|		Goodie Functions	|
\--------------------------*/
void GerminateGoodies(int nTotal, object oArea = OBJECT_SELF)
{
	int nGoodiesSpawned = 0;
	int i = GetGlobalInt("00_nGoodieIterator");
	object oSeed = GetObjectByTag(IP_GOODIE_SEED_TAG, i);
	
	if(!GetIsObjectValid(oSeed))
	{
		//PrettyDebug("No object seeds for this area!");
		return;
	}
	
	
	while(nGoodiesSpawned <= nTotal)		//Repeat this process until we've hit the cap for total goodies.
	{
		int nWeight = GetLocalInt(oSeed, VAR_GOODIES_WEIGHT);
		int j = 0;
		while(j < nWeight)				//Create a number of goodies equal to the seed's weight. This allows us to have some
		{
			//PrettyDebug("Starting Goodie Loop. j:" + IntToString(j)+ " nWeight:" + IntToString(nWeight));							//seeds weighted more heavily than others.
			int bGoodieMade = CreateGoodie(oSeed);
			if(bGoodieMade)
			{
				//PrettyDebug("Created Goodie");
				j++;
				nGoodiesSpawned++;
			}
		}
		
		++i;									//After you're done with one seed for this iteration, move to the next seed.
		oSeed = GetObjectByTag(IP_GOODIE_SEED_TAG, i);
		
		if(!GetIsObjectValid(oSeed))			//If we've hit the end of the seed list, return to the first seed.
		{
			oSeed = GetObjectByTag(IP_GOODIE_SEED_TAG);
			i=0;
		}
	}
	
	SetGlobalInt("00_nGoodieIterator", i);
}
									
int CreateGoodie(object oSeed)
{
	object oResult;
	string sGoodieTable = GetLocalString(oSeed, VAR_GOODIES_TABLE);
	//PrettyDebug("Creating a goodie from the following table:" + sGoodieTable);
	object oArea = GetArea(oSeed);
	
	location lTest = GetGoodieLocation(oSeed);			//Pick a random encounter point near the player.
		
	object oTrigger = GetFirstSubArea(oArea, GetPositionFromLocation(lTest));
	object oSavedTrigger = OBJECT_INVALID;
	
	while( GetIsObjectValid(oTrigger))	//Search through the triggers at the location,
	{											
		if(GetTag(oTrigger) == "nx2_tr_terrain")									//Save off a terrain trigger if we hit one.
			oSavedTrigger = oTrigger;
			
		else if(GetTag(oTrigger) == "nx2_tr_nogoodies")								//Alternately, if we hit a nogoodie trigger don't spawn anything here.
		{
			//PrettyDebug("hitting a nogoodie trigger...");
			return FALSE;
		}
		
		oTrigger = GetNextSubArea(oArea);											//(or we've exhausted the list)
	}
	
	oTrigger = oSavedTrigger;														//Now we copy the saved terrain trigger back to oTrigger.
																					//if we never found one, we abort because it will be OBJECT_INVALID.
	if (!GetIsObjectValid(oTrigger))
	{
		//PrettyDebug("Trigger is invalid.");
		return FALSE;
	}	
	int nTerrain = GetTerrainType(oTrigger);
	int nRow;
	do{
		//PrettyDebug("Searching the goodie table...");
		nRow = GetGoodieRow(sGoodieTable);
	}while(GetIsGoodieValidForTerrain(sGoodieTable, nRow, nTerrain) == FALSE);
		
	string sGoodieRR = Get2DAString(sGoodieTable, VAR_GOODIES_RR_ROW, nRow);
	//PrettyDebug("Creating goodie with RR: " + sGoodieRR);	
	oResult = CreateObject( OBJECT_TYPE_PLACEABLE, "nx2_ip_goodie", lTest);		//Create the appropriate goodie
	
	int nDiscoverySkill = StringToInt(Get2DAString(sGoodieTable, "DISCOVERY_SKILL", nRow));
	int nDiscoveryDC = StringToInt(Get2DAString(sGoodieTable, "DISCOVERY_DC", nRow));
	string sDiscovery = GetStringByStrRef(StringToInt(Get2DAString(sGoodieTable, "DISCOVERY_STRREF", nRow)));

	SetLocalInt(oResult, VAR_GOODIES_DISC_SKILL, nDiscoverySkill);
	SetLocalInt(oResult, VAR_GOODIES_DISC_DC, nDiscoveryDC);
	SetLocalInt(oResult, "nRow", nRow);					//Set the proper variables on the object
	SetLocalString(oResult, "sGoodieTable", sGoodieTable);
	
	SetLocalString(oResult, VAR_GOODIES_DISC_STR, sDiscovery);
		
	return TRUE;
}

void SetGoodieData(object oGoodie, string sGoodieTable, int nRow)
{
	string sName = GetStringByStrRef(StringToInt(Get2DAString(sGoodieTable, "NAME_STRREF", nRow)));

	string sActivate = GetStringByStrRef(StringToInt(Get2DAString(sGoodieTable, "ACTIVATE_STRREF", nRow)));
	
	int nRewardGold = StringToInt(Get2DAString(sGoodieTable, "REWARD_GOLD", nRow));
	int nRewardXP = StringToInt(Get2DAString(sGoodieTable, "REWARD_XP", nRow));
	string sRewardItems = Get2DAString(sGoodieTable, "REWARD_ITEMS", nRow);
	string sRewardGoods = Get2DAString(sGoodieTable, "REWARD_GOODS", nRow);
	string sRewardRareRes = Get2DAString(sGoodieTable, "REWARD_RARERES", nRow);
	
	SetLocalString(oGoodie, VAR_GOODIES_NAME, sName);	
		
	SetLocalString(oGoodie, VAR_GOODIES_AC_STR, sActivate);
	
	SetLocalInt(oGoodie, VAR_GOODIES_GOLD, nRewardGold);
	SetLocalInt(oGoodie, VAR_GOODIES_XP, nRewardXP);
	SetLocalString(oGoodie, VAR_GOODIES_ITEMS, sRewardItems);
	SetLocalString(oGoodie, VAR_GOODIES_GOODS, sRewardGoods);
	SetLocalString(oGoodie, VAR_GOODIES_RARERES, sRewardRareRes);
}

int GetIsGoodieValidForTerrain(string sGoodieTable, int nRow, int nTerrain)
{
	string sTerrainList = Get2DAString(sGoodieTable, VAR_GOODIES_TERRAIN_ROW, nRow);
	int i = 1;
	int nValidTerrain = CSLNth_GetNthElementInt(sTerrainList, i);
	
	while(nValidTerrain)
	{
		//PrettyDebug("Checking the terrain type...");
		if (nTerrain == nValidTerrain)						//If the terrain we are searching for matches one of the listed types
			return TRUE;									//Return TRUE.
		
		else												//Otherwise move to the next element.
		{
			++i;
			nValidTerrain = CSLNth_GetNthElementInt(sTerrainList, i);
		}
	}
	
	return FALSE;											//If we parsed the entire list without returning TRUE, then nTerrain 
}															//is not valid for the current Goodie we are testing, so return FALSE.

void AwardGoodieItems(object oUser, string sItems)
{
	
	int i=1;
	string sParam = CSLNth_GetNthElement(sItems, i);
	
	
	while(sParam != "")
	{
		int nNum = StringToInt( CSLNth_GetNthElement(sItems, i+1) );	//The NEXT parameter we are setting equal to the number to create.
		
		if ( nNum != 0 )										//if nNum is a valid int, we are going to use it as an iterator.
		{
			int j;
			for( j = 0; j < nNum; j++)
			{
				CreateItemOnObject(sParam, oUser);
			}
			
			i += 2;												//We want to increment i by 2 in this case to skip the iterator.
		}
		
		else
		{
			CreateItemOnObject(sParam, oUser);
			++i;
		}
		
		sParam = CSLNth_GetNthElement(sItems, i);
	}
}

location GetGoodieLocation(object oSeed)
{
	location lLocation, lSafe;
	vector vTest, vSafe;
	float fRadius = GetLocalFloat(oSeed, VAR_GOODIES_RADIUS);		
	do{
		lLocation = CSLGetRandomLocationAroundObject(fRadius, oSeed, FALSE);
		lSafe = CalcSafeLocation(GetFirstPC(), lLocation, 1.0, FALSE, FALSE);
		//PrettyDebug("TestingVectors...");		
		vTest = GetPositionFromLocation(lLocation);
		vSafe = GetPositionFromLocation(lSafe);
	}while (!CSLCompareVectors2D(vTest, vSafe));

	return lSafe;
}

int GetGoodieRow(string sTable)
{
	int nRow;
		
	nRow = Random(GetNumValidRows(sTable))+1;	
	return nRow;
}

/*--------------------------\
|	OL Map UI Functions		|
\--------------------------*/

//Activates the OL Map UI for oPC. This closes the default UI Elements that are intended to be hidden 
//on the OL Map and opens the new OL UI objects for the pc.
void ActivateOLMapUI(object oPC)
{
	//Close all of the Ingame UI elements we want hidden.
	CloseGUIScreen(oPC, GUI_SCREEN_DEFAULT_PARTY_BAR);
	CloseGUIScreen(oPC, GUI_SCREEN_DEFAULT_HOTBAR);
	CloseGUIScreen(oPC, GUI_SCREEN_DEFAULT_HOTBAR_2);
	CloseGUIScreen(oPC, GUI_SCREEN_DEFAULT_HOTBAR_V1);
	CloseGUIScreen(oPC, GUI_SCREEN_DEFAULT_HOTBAR_V2);
	CloseGUIScreen(oPC, GUI_SCREEN_DEFAULT_MODEBAR);
	CloseGUIScreen(oPC, GUI_SCREEN_DEFAULT_PLAYERMENU);
	CloseGUIScreen(oPC, GUI_SCREEN_DEFAULT_ACTIONQUEUE);
	CloseGUIScreen(oPC, "SCREEN_VOICEMENU");
	
	//Open the new Custom UI Elements for the OL Map.
	DisplayGuiScreen(oPC, GUI_SCREEN_OL_PARTY_BAR, FALSE, XML_OL_PARTY_BAR);
	DisplayGuiScreen(oPC, GUI_SCREEN_OL_FRAME, FALSE, XML_OL_FRAME);
	DisplayGuiScreen(oPC, GUI_SCREEN_OL_MENU, FALSE, XML_OL_MENU);
	CSLUpdateClockForAllPlayers();
}

//Deactivates the OL Map UI for oPC. This closes the OL Map UI Elements 
//and re-opens the default UI objects for the PC.
void DeactivateOLMapUI(object oPC)
{
	//Close all of the Ingame UI elements we want hidden.
	CloseGUIScreen(oPC, GUI_SCREEN_OL_PARTY_BAR);
	CloseGUIScreen(oPC, GUI_SCREEN_OL_FRAME);
	CloseGUIScreen(oPC, GUI_SCREEN_OL_MENU);
	
	//Open the new Custom UI Elements for the OL Map.
	DisplayGuiScreen(oPC, GUI_SCREEN_DEFAULT_PARTY_BAR, FALSE);
	DisplayGuiScreen(oPC, GUI_SCREEN_DEFAULT_HOTBAR, FALSE);
	DisplayGuiScreen(oPC, GUI_SCREEN_DEFAULT_HOTBAR_2, FALSE);
	DisplayGuiScreen(oPC, GUI_SCREEN_DEFAULT_HOTBAR_V1, FALSE);
	DisplayGuiScreen(oPC, GUI_SCREEN_DEFAULT_HOTBAR_V2, FALSE);
	DisplayGuiScreen(oPC, GUI_SCREEN_DEFAULT_MODEBAR, FALSE);
	DisplayGuiScreen(oPC, GUI_SCREEN_DEFAULT_PLAYERMENU, FALSE);
	DisplayGuiScreen(oPC, GUI_SCREEN_DEFAULT_ACTIONQUEUE, FALSE);
	//CSLUpdateClockForAllPlayers(); // Commented out as a test
}




// Wrapper for ShowWorldMap().  This stores the origin and map name on the
// PC for later use by the various world map scripts.
// The world map scripts won't function properly if these vars are not saved on the PC.
void DoShowWorldMap(string sMap, object oPC, string sOrigin)
{
	// BMA-OEI 8/22/06 -- Autosave before transition
	if (GetGlobalInt(CAMPAIGN_SWITCH_WORLD_MAP_AUTO_SAVE))
	{
		CSLAttemptSinglePlayerAutoSave();
	}
	// store map and origin on player for use w/ map scripts
	SetLocalString(oPC, "00_sWORLD_MAP_NAME", sMap);
	SetLocalString(oPC, "00_sWORLD_MAP_HOTSPOT_ORIGIN", sOrigin);
	ShowWorldMap(sMap, oPC, sOrigin );
}

// returns row number of match or -1 if not found.
// searches from start row to endrow for matching values in 2 columns.  Searches the entire 2DA if iEndRow is unspecified.
// search stops if empty string is returned (may be due to file, column, or row is not found or entry is "****")
int Search2DA2Col(string s2DA, string sColumn1, string sColumn2, string sMatchElement1, string sMatchElement2, int iStartRow=0, int iEndRow = -1)
{
	int i = iStartRow;
	string sEntry1;
	string sEntry2;
	
	if( iEndRow == -1)
		iEndRow = GetNum2DARows( s2DA );
		
	while (i <= iEndRow)
	{
		sEntry1 = Get2DAString(s2DA, sColumn1, i);
		if (sEntry1 == sMatchElement1)
		{
			sEntry2 = Get2DAString(s2DA, sColumn2, i);
			if (sEntry2 == sMatchElement2)
			{
				return i;
			}				
		}
		
		if (sEntry1 == "")
			return -1;
		i++;
	}
	return -1;
}

//Simple wrapper to save space - gets an entry in a 2DA and converts it to an int.
int Get2DAInt(string s2DA, string sColumn, int nRow)
{
	string sStringToConvert = Get2DAString(s2DA, sColumn, nRow);
	int iResult = StringToInt(sStringToConvert);
	return iResult;
}

//------------------------------------------------------------------------------
// Get a 2da String or the supplied default if string is empty
//------------------------------------------------------------------------------
string Get2DAStringOrDefault(string s2DA, string sColumn, int nRow, string sDefault)
{
    string sRet;
    sRet =Get2DAString(s2DA, sColumn, nRow);
    //if (sRet == "****" || sRet == "") 
	// "****" is translated to "" by Get2DAString()
    if (sRet == "") 
    {
        sRet = sDefault;
    }
    return sRet;

}

// returns row number of match or -1 if not found.
// searches from start row to endrow
// search stops if empty string is returned (may be due to file, column, or row is not found or entry is "****"
int Search2DA(string s2DA, string sColumn, string sMatchElement, int iStartRow=0, int iEndRow=-1)
{
	int i = iStartRow;
	string sEntry;
	
	if(iEndRow == -1)
		iEndRow = GetNum2DARows( s2DA );
	
	while (i <= iEndRow)
	{
		sEntry = Get2DAString(s2DA, sColumn, i);
		//PrettyDebug("row ["+ IntToString(i) + "] sEntry = " + sEntry);
		if (sEntry == sMatchElement)
			return i;
		if (sEntry == "")
			return -1;
		i++;
	}
	return -1;
}

string GetHotspots2DA(string sMapName)
{
	return (sMapName + "_hs");
}

string GetHotspotConnections2DA(string sMapName)
{
	return (sMapName + "_hsc");
}


// returns -1 if not found
int GetHotspotRow(string s2DA, string sHotspot)
{
	int iHotspotRow = Search2DA(s2DA, "HotspotTag", sHotspot);
	return (iHotspotRow);
}






// returns -1 if not found
int GetHotspotConnectionRow(string s2DA, string sHotspotOrigin, string sHotspotDestination)
{
	int iHotspotConnectionsRow = Search2DA2Col(s2DA, "OriginTag", "DestinationTag", sHotspotOrigin, sHotspotDestination);
	return (iHotspotConnectionsRow);
}


void FlagHotspotVisibility(int bVisible, string sMap, string sHotspot)
{
	SetGlobalInt("00_VIS" + sMap + sHotspot, bVisible);
}

// whether to show or hide each hotspot is determined by the setting of
// global variables.  The world map conditional script looks at these.
int GetHotspotVisibleFlag(string sMap, string sHotspot)
{
	return GetGlobalInt("00_VIS" + sMap + sHotspot);
}

void FlagHotspotsMatchingRangeVisibility(int bVisible, string sMap, string sCol, int nMin, int nMax)
{
	string s2DA = GetHotspots2DA(sMap);
	int nRow=0;
	
	string sHotspot = Get2DAString(s2DA, "HotspotTag", nRow);
	string sEntry;
	int nEntry;
	
	// look throug all hotspots
	while (sHotspot != "")
	{
		sEntry = Get2DAString(s2DA, sCol, nRow);
		nEntry = StringToInt(sEntry);
		
		if (CSLGetIsNumber(sEntry) && CSLIsWithinRange(nEntry, nMin, nMax))
		{
			FlagHotspotVisibility(bVisible, sMap, sHotspot);
		}			
		nRow++;
		sHotspot = Get2DAString(s2DA, "HotspotTag", nRow);
	}
}



//
void FlagHotspotsMatchingStringVisibility(int bVisible, string sMap, string sCol, string sMatchValue)
{
	string s2DA = GetHotspots2DA(sMap);
	int nRow=0;
	
	string sHotspot = Get2DAString(s2DA, "HotspotTag", nRow);
	string sEntry = Get2DAString(s2DA, sCol, nRow);
	
	// look throug all hotspots
	while (sHotspot != "")
	{
		if (sEntry == sMatchValue)
		{
			FlagHotspotVisibility(bVisible, sMap, sHotspot);
		}			
		nRow++;
		sEntry = Get2DAString(s2DA, sCol, nRow);
		sHotspot = Get2DAString(s2DA, "HotspotTag", nRow);
	}
}




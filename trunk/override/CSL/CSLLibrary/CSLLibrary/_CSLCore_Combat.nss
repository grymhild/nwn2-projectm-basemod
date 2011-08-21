/** @file
* @brief Combat related functions
*
* Good portion of this code was developed by Drammel for the Tome of Battle
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////




/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCConstants"
//#include "_SCUtilityConstants"
#include "_CSLCore_Math"
#include "_CSLCore_Magic"
#include "_CSLCore_Position"
#include "_CSLCore_Feats_c"
#include "_CSLCore_Visuals_c"
#include "_CSLCore_Visuals"
#include "_CSLCore_Info"
#include "_CSLCore_Items"
#include "_CSLCore_Objects"
#include "x2_inc_switches"

// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

/*
int CSLIgnoreTargetRulesGetFirstIndex(object oCaster, object oTarget);
void CSLIgnoreTargetRulesRemoveEntry(object oCaster, int nEntry);
void CSLIgnoreTargetRulesEnqueueTarget(object oCaster, object oTarget);
void CSLIgnoreTargetRulesActionCastSpellAtObject(int iSpellId, object oTarget, int iMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int iDomainLevel=0, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE);
void CSLIgnoreTargetRulesActionCastSpellAtObjectArea(int nShapeType, float fShapeSize, int iSpellId, object oTarget, int iMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int iDomainLevel=0, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE);
void CSLIgnoreTargetRulesActionCastSpellAtLocationArea(int nShapeType, float fShapeSize, int iSpellId, location lTargetLocation, int iMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE);
int CSLGetIsStandardHostileTarget(object oTarget, object oSource);
int CSLSpellsIsTarget(object oTarget, int nTargetType, object oSource);
int CSLCountEnemies(location lTarget, float fRadius=RADIUS_SIZE_GARGANTUAN, int nMaxEnemies=100);

int CSLIsGazeAttackBlocked(object oCreature);
int CSLTouchAttackRanged(object oTarget, int bDisplayFeedback=TRUE, int iBonus=0, int bUseRangedOverride = FALSE);
int CSLGrappleCheck(object oCaster, object oTarget, int iAttackerBonus);
int CSLEvaluateSneakAttack(object oTarget, object oSneakAttacker);
int CSLIsTargetConcealed(object oTarget, object oSneakAttacker);
int CSLGetSneakLevels(object oTarget);
int CSLGetTotalSneakDice(object oTarget, object oSneakAttacker);
int CSLIsTargetValidForSneakAttack(object oTarget, object oSneakAttacker);
void CSLReduceBreathableRounds( object oTarget, int iRounds, int Repetitions = 1, int iRequiredSpellId = -1 );

*/
/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

const int SPELLCOMBAT_DAMAGEEFFECT = -20000;

/**  
* Sets up a script to run when a creature gets damaged, works as a wrapper to allow this to work on PCs
* @param oObject
* @param sScriptName Name of script to trigger on damaged
*/
void CSLSetOnDamagedScript( object oObject, string sScriptName )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLSetOnDamagedScript Start", GetFirstPC() ); }
	
	//string sLastScript = GetEventHandler( oObject, CREATURE_SCRIPT_ON_DAMAGED );
	string sLastScript = GetLocalString(oObject, "SC_OLDONDAMAGED" );
	
	if ( GetIsPC(oObject) || GetIsOwnedByPlayer(oObject) )
	{
		object oDamagedProxy = GetObjectByTag(  "DAMAGEPROXY_"+ObjectToString(oObject) );
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oObject, oObject, SPELLCOMBAT_DAMAGEEFFECT );
		if ( sScriptName == "" && GetIsObjectValid( oDamagedProxy ) )
		{
			DestroyObject(oDamagedProxy, 0.0f, FALSE);
		}
		else
		{
			if ( !GetIsObjectValid( oDamagedProxy ) )
			{
				oDamagedProxy = CreateObject(OBJECT_TYPE_CREATURE, "c_damageproxy", GetLocation(CSLCoreDataPointGet()), FALSE, "c_scriptrunner" );
				SetLocalObject( oDamagedProxy, "DAMAGE_PROXY_ORIGINAL", oObject );
			}
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId(EffectShareDamage( oDamagedProxy, 100, 100 ), SPELLCOMBAT_DAMAGEEFFECT), oObject, HoursToSeconds(48));
			SetEventHandler( oDamagedProxy, CREATURE_SCRIPT_ON_DAMAGED, sScriptName );
		}
	
	}
	else // must be an NPC of some sort, just ignore DM's
	{
		if ( sScriptName == "" )
		{
			// put things to how they were
			SetEventHandler( oObject, CREATURE_SCRIPT_ON_DAMAGED, sLastScript );
		}
		else
		{
			if ( sLastScript == "" && sLastScript != sScriptName  )
			{
				// store any previous script
				SetLocalString(oObject, "SC_OLDONDAMAGED", GetEventHandler( oObject, CREATURE_SCRIPT_ON_DAMAGED ) );
			}
			SetEventHandler( oObject, CREATURE_SCRIPT_ON_DAMAGED, sScriptName );
		}
	}
}


/**  
* Gets the originally damaged creature for a damage event
* @param oObject
* @param sScriptName Name of script to trigger on damaged
*/
object CSLGetOriginalDamageTarget( object oObject )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetOriginalDamageTarget Start", GetFirstPC() ); }
	
	object oOriginal = GetLocalObject( oObject, "DAMAGE_PROXY_ORIGINAL" );
	if ( GetIsObjectValid( oOriginal ) ) 
	{
		return oOriginal;
	}
	return oObject;
}

/**  
* This gets just the physical damage dealt, since for example: GetDamageDealtByType(DAMAGE_TYPE_SLASHING) returns -1 when the damage type is slashing
* You should use other functions to determine when this function is of use based on the weapon held ( using GetLastWeaponUsed )
* @author based on comments by OEI, with input from Vanes and J.O.G
* @replaces GetDamageDealtByType
*/
int CSLGetPhysicalDamageDealt()
{
	int iDamage = GetTotalDamageDealt();			
	int i;	
	for ( i = DAMAGE_TYPE_MAGICAL; i <= DAMAGE_TYPE_SONIC; i <<= 1 ) 
	{
		if (GetDamageDealtByType(i) > 0 )
		{
			iDamage -= GetDamageDealtByType(i);
		}
	}
	return iDamage;
}


/**  
* Wrapper function whose sole purpose is to prevent needing to include the AI system, runs as a separate script the AI round determination logic
* @param oObject
* @param sScriptName Name of script to trigger on damaged
* @replaces SCAssignDCR
*/
void CSLDetermineCombatRound( object oSubject = OBJECT_SELF, object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10 )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLDetermineCombatRound Start", GetFirstPC() ); }
	
	SetLocalObject(oSubject, "CSL_INTRUDER", oIntruder);
	SetLocalInt(oSubject, "CSL_AIDIFFICULTY", nAI_Difficulty );
	ExecuteScript("_mod_determinecombatround", oSubject);
}	

// @replaces StandardAttack
void CSLAttackTarget(object oAttacker, object oTarget, int bSetToHostile=TRUE)
{
    if (DEBUGGING >= 7) { CSLDebug(  "CSLAttackTarget Start", GetFirstPC() ); }
    
    //PrintString ("Setting " + GetName(oAttacker) + " to attack " + GetName(oTarget));

	// make sure action queue is empty / conversation is finished
	AssignCommand(oAttacker, ClearAllActions(TRUE));
	// make target enemy of attacker, don't mess with this if already hostile
	if ( !GetIsEnemy(oTarget,oAttacker) && bSetToHostile)
	{
    	SetIsTemporaryEnemy(oTarget,oAttacker); // this requires personal reputations
    	if ( !GetIsEnemy(oTarget,oAttacker) ) // GetReputation(oAttacker, oTarget) > 10 ) // 0 - 10 is hostile, don't need to do anything
    	{
    		ChangeToStandardFaction(oAttacker, STANDARD_FACTION_HOSTILE);
    	}
	}
	// tell attacker to initiate combat - attacker will determine best who to attack and how.
    //AssignCommand(oAttacker, SCAIDetermineCombatRound());
	AssignCommand(oAttacker, CSLDetermineCombatRound(oAttacker,oTarget) );
	
    // This is here only temporarily to further push an attack because above not fully working currently
    AssignCommand(oAttacker, ActionAttack(oTarget));
}

/**  
* Description
* @author
* @param nDam
* @param iDamageType DAMAGE_TYPE_*
* @param oTarget
* @see 
* @return 
*/
int CSLAdjustPiercingDamage(int nDam, int iDamageType, object oTarget)
{		
	if (DEBUGGING >= 7) { CSLDebug(  "CSLAdjustPiercingDamage Start", GetFirstPC() ); }
	
	int nDamage = nDam;
	if (GetIsObjectValid(oTarget))
	{
		int PercentVuln = 0;
	    effect eVuln = GetFirstEffect(oTarget);	
	    while (GetIsEffectValid(eVuln))
	    {
			if (GetEffectType(eVuln) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE)
			{
				int nDamageType = GetEffectInteger(eVuln, 0);	//Dmg Type
				if (nDamageType == iDamageType)
				{
					int iVuln = GetEffectInteger(eVuln, 1);	 //Vuln %
					PercentVuln += iVuln;
				}				
			}
	        eVuln = GetNextEffect(oTarget);
	    }	
			
		object oChest = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
		if (GetIsObjectValid(oChest))
		{
			int iIpDamageSubtype = CSLGetIPDamageTypeByDamageType(iDamageType);
			
			int iHasVuln = GetItemHasItemProperty(oChest, ITEM_PROPERTY_DAMAGE_VULNERABILITY);	
			if (iHasVuln)
			{	
				int iTable;
				int iTableVal;
				int iSubType;
				itemproperty ip = GetFirstItemProperty(oChest);
				while (GetIsItemPropertyValid(ip))
				{	
					iTable = GetItemPropertyCostTable(ip); // 22 = Dmg Vuln Table
					iSubType = GetItemPropertySubType(ip); //Dmg Type
					
					if (iTable == 22 && iSubType == iIpDamageSubtype )	
					{		
						iTableVal = GetItemPropertyCostTableValue(ip); //Vuln %
						if (iTableVal == 4)
							PercentVuln += 50;
						else
						if (iTableVal == 7)
							PercentVuln += 100;	
						else
						if (iTableVal == 3)
							PercentVuln += 25;
						else
						if (iTableVal == 1)
							PercentVuln += 5; 
						else
						if (iTableVal == 5)
							PercentVuln += 75;
						else
						if (iTableVal == 6)
							PercentVuln += 90;
						else
						if (iTableVal == 2)
							PercentVuln += 10;																										
					}													
					ip = GetNextItemProperty(oChest);
				}
			}
		}
		
		if (PercentVuln > 100)
			PercentVuln = 100;	
			
		if (PercentVuln > 0)
			nDamage = nDamage + (nDamage * PercentVuln / 100);
	}
	return nDamage;
}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Iterates through the list of objects on oCaster. Returns the index of the first occurance of oTarget.
// Returns 1 or higher if a matching object was found.
// Returns -1 if the entry is not in the list.
int CSLIgnoreTargetRulesGetFirstIndex(object oCaster, object oTarget)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIgnoreTargetRulesGetFirstIndex Start", GetFirstPC() ); }
	
	int nITREntries = GetLocalInt(oCaster, SCITR_NUM_ENTRIES);
	int i;
	object oEntry;
	for (i=1; i<=nITREntries; i++)
	{
		oEntry = GetLocalObject(oCaster, SCITR_ENTRY_PREFIX + IntToString(i));
		if (oEntry == oTarget)
			return i;
	}
	return -1;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Regarding the list of objects on oCaster - this removes the entry with index nEntry from the list.
// side affect is that it changes the order of the list. But order is not important with the ITR object list.
void CSLIgnoreTargetRulesRemoveEntry(object oCaster, int nEntry)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIgnoreTargetRulesRemoveEntry Start", GetFirstPC() ); }
	
	int nITREntries = GetLocalInt(oCaster, SCITR_NUM_ENTRIES);
	if ((nITREntries>0) && (nEntry>0) && (nEntry<=nITREntries))
	{
		object oEntry = GetLocalObject(oCaster, SCITR_ENTRY_PREFIX + IntToString(nITREntries));
		SetLocalObject(oCaster, SCITR_ENTRY_PREFIX + IntToString(nEntry), GetLocalObject(oCaster, SCITR_ENTRY_PREFIX + IntToString(nITREntries))); //replace nEntry with last object in list.
		DeleteLocalObject(oCaster, SCITR_ENTRY_PREFIX + IntToString(nITREntries));
		SetLocalInt(oCaster, SCITR_NUM_ENTRIES, nITREntries-1); //decrement list total
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
//Enqueues a target on a spell caster as an acceptable target to bypass the CSLSpellsIsTarget() check on.
// oCaster - the creature casting the spell.
// oTarget - the spell target.
void CSLIgnoreTargetRulesEnqueueTarget(object oCaster, object oTarget)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIgnoreTargetRulesEnqueueTarget Start", GetFirstPC() ); }
	
	int nITREntries = GetLocalInt(oCaster, SCITR_NUM_ENTRIES) + 1;
	SetLocalObject(oCaster, SCITR_ENTRY_PREFIX + IntToString(nITREntries), oTarget);
	SetLocalInt(oCaster,SCITR_NUM_ENTRIES,nITREntries);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Enqueues a spell that will ignore the CSLSpellsIsTarget logic.
// Does so by storing temporary variables on the caster of OK targets to bypass on.
// Parameters the same as ActionCastSpellAtObject() in nwscript.nss
void CSLIgnoreTargetRulesActionCastSpellAtObject(int iSpellId, object oTarget, int iMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int iDomainLevel=0, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIgnoreTargetRulesActionCastSpellAtObject Start", GetFirstPC() ); }
	
	CSLIgnoreTargetRulesEnqueueTarget(OBJECT_SELF, oTarget);
	ActionCastSpellAtObject(iSpellId, oTarget, iMetaMagic,bCheat,iDomainLevel,iProjectilePathType, bInstantSpell);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Enqueues a spell that will ignore the CSLSpellsIsTarget logic.
// Variation: this will target all within the nShapeType and fShapeSize parameters. (ex SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL)
//   try to match the nShapeType and fShapeSize parameters to prevent lingerings ITR variables.
// Other parameters are the same as ActionCastSpellAtObject() in nwscript.nss
void CSLIgnoreTargetRulesActionCastSpellAtObjectArea(int nShapeType, float fShapeSize, int iSpellId, object oTarget, int iMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int iDomainLevel=0, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIgnoreTargetRulesActionCastSpellAtObjectArea Start", GetFirstPC() ); }
	
	oTarget = GetFirstObjectInShape(nShapeType, fShapeSize, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		CSLIgnoreTargetRulesEnqueueTarget(OBJECT_SELF, oTarget);
			//Get the next target in the specified area around the caster
			oTarget = GetNextObjectInShape(nShapeType, fShapeSize, GetLocation(OBJECT_SELF));
	}
	ActionCastSpellAtObject(iSpellId,oTarget,iMetaMagic,bCheat, iDomainLevel,iProjectilePathType, bInstantSpell);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Enqueues a spell that will ignore the CSLSpellsIsTarget logic.
// Variation: this will target all within the nShapeType and fShapeSize parameters. (ex SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL)
//   try to match the nShapeType and fShapeSize parameters to prevent lingerings ITR variables.
// Other parameters are the same as ActionCastSpellAtLocation() in nwscript.nss
void CSLIgnoreTargetRulesActionCastSpellAtLocationArea(int nShapeType, float fShapeSize, int iSpellId, location lTargetLocation, int iMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIgnoreTargetRulesActionCastSpellAtLocationArea Start", GetFirstPC() ); }
	
	object oTarget = GetFirstObjectInShape(nShapeType, fShapeSize, lTargetLocation);
	while(GetIsObjectValid(oTarget))
	{
		CSLIgnoreTargetRulesEnqueueTarget(OBJECT_SELF, oTarget);
			//Get the next target in the specified area around the caster
			oTarget = GetNextObjectInShape(nShapeType, fShapeSize, lTargetLocation);
	}
	ActionCastSpellAtLocation(iSpellId,lTargetLocation,iMetaMagic,bCheat,iProjectilePathType, bInstantSpell);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsStandardHostileTarget(object oTarget, object oSource)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetIsStandardHostileTarget Start", GetFirstPC() ); }
	
	int nReturnValue = FALSE;

	int bTargetIsPC = GetIsPC(oTarget);
	int bNotAFriend = FALSE;
	int bReactionTypeFriendly = GetIsReactionTypeFriendly(oTarget, oSource);
	int bInSameFaction = GetFactionEqual(oTarget, oSource);
	if (bReactionTypeFriendly == FALSE && bInSameFaction == FALSE)
	{
			bNotAFriend = TRUE;
	}

	// * Local Override is just an out for end users who want
	// * the area effect spells to hurt 'neutrals'
	if (GetLocalInt(GetModule(), "X0_G_ALLOWSPELLSTOHURT") == 10)
	{
			bTargetIsPC = TRUE;
	}

	int bSelfTarget = FALSE; //GetMaster(oHench)
	object oTargetMaster = CSLGetCurrentRealMaster( oTarget );    // 9/19/06 - BDF: changed to CSLGetCurrentMaster() for companion consideration
	object oSourceMaster = CSLGetCurrentRealMaster( oSource );  // CSLGetCurrentMaster() will return OBJECT_INVALID when the queried object is not in a PC party.

	// March 25 2003. The player itself can be harmed
	// by their own area of effect spells if in Hardcore mode...
	if (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL)
	{
			// Have I hit myself with my spell?
			// 11/10/06 - BDF(OEI): non-PC-party NPCs should not be able to hurt themselves in Hardcore+ difficulty;
			//  it may not please the rules purist, but this is a difficulty consideration, not a rules consideration,
			//  and allowing a hostile NPC to kill itself with its own AOEs does not make the game more difficult.
			if ( oTarget == oSource && GetIsObjectValid(oSourceMaster) )
			{
				bSelfTarget = TRUE;
			}
			else
			// * Is the target an associate of the spellcaster
			if (oTargetMaster == oSource)
			{
				bSelfTarget = TRUE;
			}
			// 11/10/06 - BDF(OEI): CSLGetCurrentMaster() will return OBJECT_INVALID when the queried object is not in a PC party.
			//  This causes non-PC-party NPCs to affect one another even if they are not hostile to one another.  Bad.
			else if (oTargetMaster == oSourceMaster
					&& GetIsObjectValid(oSourceMaster)
					&& GetIsObjectValid(oTargetMaster)  ) // This will also ensure that PC party members in multiplayer are affected
			{
				bSelfTarget = TRUE;
			}
	}

	// April 9 2003
	// Hurt the associates of a hostile player
	if (bSelfTarget == FALSE && GetIsObjectValid(oTargetMaster) == TRUE)
	{
		// * I am an associate
		// * of someone


		// For associates, check target's master (instead of target)
		if ( GetIsReactionTypeHostile(oTargetMaster, oSource) == TRUE )
		{
			bSelfTarget = TRUE;
		}

		// 8/17/06 - BDF-OEI: NWN2 doesn't use personal reputation, so PCs in the same party
		// will consider one another neutral by default; therefore, only hurt associates of HOSTILE PCs
		// Otherwise, we are using personal reputation and neutrality is not a consideration
				// AWD-OEI only do the following check if we are playing hardcore

		if (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL)
		{
			if (GetGlobalInt("N2_S_USE_PERSONAL_REP") )
			{
				if (GetIsReactionTypeFriendly(oTargetMaster,oSource) == FALSE && GetIsPC(oTargetMaster) == TRUE)
				{
				   bSelfTarget = TRUE;
				}        
			}
		}
	}


	// Assumption: In Full PvP players, even if in same party, are Neutral
	// * GZ: 2003-08-30: Patch to make creatures hurt each other in hardcore mode...

	if (GetIsReactionTypeHostile(oTarget,oSource))
	{
			nReturnValue = TRUE;         // Hostile creatures are always a target
	}
	else if (bSelfTarget == TRUE)
	{
			nReturnValue = TRUE;         // Targetting Self (set above)?
	}
	else if (bTargetIsPC && bNotAFriend)
	{
			nReturnValue = TRUE;         // Enemy PC
	}
	else if(bInSameFaction && (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL))
	{
		nReturnValue = TRUE;
	}
	else if (bNotAFriend && (GetGameDifficulty() > GAME_DIFFICULTY_NORMAL))
	{
			if ( GetModuleSwitchValue( MODULE_SWITCH_ENABLE_NPC_AOE_HURT_ALLIES) == TRUE)
			{
				nReturnValue = TRUE;        // Hostile Creature and Difficulty > Normal
			}                               // note that in hardcore mode any creature is hostile
	}
	return (nReturnValue);
}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLSpellsIsTarget(object oTarget, int nTargetType, object oSource)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLSpellsIsTarget Start", GetFirstPC() ); }
	
	// If the target is a ScriptHidden creature, we do not want to affect it.
	if ( GetScriptHidden(oTarget) == TRUE )
	{
		return FALSE;
	}

	// If we want to ignore the rules of target selection for this spell, always return true.
	int nEntry = CSLIgnoreTargetRulesGetFirstIndex(oSource, oTarget);
	if (nEntry != -1)
	{
		CSLIgnoreTargetRulesRemoveEntry(oSource, nEntry);
		return TRUE;
	}

	// * if dead, not a valid target
	if (GetIsDead(oTarget, TRUE ) == TRUE)
	{
		return FALSE;
	}

	// early out if the targets are the same...
	if ( oTarget == oSource )
	{
		if ( nTargetType == SCSPELL_TARGET_ALLALLIES )
		{
			return TRUE;
		}
		//else                                 return FALSE;
	}


	int iReturnValue = FALSE;

	switch (nTargetType)
	{
			// * this kind of spell will affect all friendlies and anyone in my
			// * party, even if we are upset with each other currently.
			case SCSPELL_TARGET_ALLALLIES:
				if(GetIsReactionTypeFriendly(oTarget,oSource) || GetFactionEqual(oTarget,oSource))
				{
					iReturnValue = TRUE;
				}
				break;
			case SCSPELL_TARGET_STANDARDHOSTILE:
				iReturnValue = CSLGetIsStandardHostileTarget(oTarget, oSource);
				break;
			// * only harms enemies, ever
			// * current list:call lightning, isaac missiles, firebrand, chain lightning, dirge, Nature's balance,
			// * Word of Faith, bard songs that should never affect friendlies
			case SCSPELL_TARGET_SELECTIVEHOSTILE:
				// 10/23/06 - BDF(OEI): added GetIsReactionTypeHostile() since GetIsEnemy may not capture all cases
				if( GetIsEnemy(oTarget,oSource) || GetIsReactionTypeHostile(oTarget, oSource) )
				{
					iReturnValue = TRUE;
				}
				break;
			case SCSPELL_TARGET_ALL:
				// Added this just to have a simple way of targeting everything while still allowing the get is deac checks
				iReturnValue = TRUE;
				break;
	}

	/* 10/20/06 - BDF(OEI): this block of code is now deprecated.  It essentially prevents companions from damaging the
								party in Hardcore difficulty, which isn't very hardcore at all
	// GZ: Creatures with the same master will never damage each other
	if ( nTargetType != SCSPELL_TARGET_ALLALLIES ) // 9/25/06 - BDF: Added this conditional to limit this filter to damaging spells
	{
		if ( !GetIsPC(oTarget) && !GetIsPC(oSource) )   // 10/03/06 - BDF: this further reinforces that this block
		{                                   // will only run when the target and source are NOT PC's
			//if (GetMaster(oTarget) != OBJECT_INVALID && GetMaster(oSource) != OBJECT_INVALID )
			if (CSLGetCurrentMaster(oTarget) != OBJECT_INVALID && CSLGetCurrentMaster(oSource) != OBJECT_INVALID )   // 9/19/06 - BDF: changed to CSLGetCurrentMaster() for companion consideration
			{
					//if (GetMaster(oTarget) == GetMaster(oSource))
					if (CSLGetCurrentMaster(oTarget) == CSLGetCurrentMaster(oSource))  // 9/19/06 - BDF: changed to CSLGetCurrentMaster() for companion consideration
					{
						if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_MULTI_HENCH_AOE_DAMAGE) == 0 )
						{
							iReturnValue = FALSE;
						}
					}
			}
		}
	}
	*/

	return iReturnValue;
}




/**  
* Count number of enemies within radius of target location up to nMaxEnemies
* @author
* @param 
* @see 
* @return 
*/
// 
int CSLCountEnemies(location lTarget, float fRadius=RADIUS_SIZE_GARGANTUAN, int nMaxEnemies=100)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLCountEnemies Start", GetFirstPC() ); }
	
	int nEnemies = 0;
	object oTarget   = OBJECT_INVALID;

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget) && nEnemies <= nMaxEnemies )
	{
			// * caster cannot be harmed by this spell
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF))
			{
				// * You can only fire missiles on visible targets
				if (GetObjectSeen(oTarget,OBJECT_SELF))
				{
					nEnemies++;
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	return (nEnemies);
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLGetTouchType(int iTouch)
{
	if (iTouch==TOUCH_ATTACK_RESULT_HIT)	return "Touch Hit";
	if (iTouch==TOUCH_ATTACK_RESULT_MISS)	return "Touch Miss";
	if (iTouch==TOUCH_ATTACK_RESULT_CRITICAL) return "Touch Critical";
	return "TouchMiss" + IntToString(iTouch);
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// * This reduces the breathable rounds over time, usually due to the given spell which causes the character to lose control, drop out once the character is drowning
void CSLReduceBreathableRounds( object oTarget, int iRounds, int Repetitions = 1, int iRequiredSpellId = -1 )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLReduceBreathableRounds Start", GetFirstPC() ); }
	
	if ( GetLocalInt(oTarget, "UNDERWATER") )
	{
		SetLocalInt( oTarget, "CSL_LOSTBREATH", GetLocalInt( oTarget, "CSL_LOSTBREATH")+iRounds );
	}
	/*
	Repetitions--;
	
	if (  Repetitions > 0 && GetLocalInt(oTarget, "CSL_CHARSTATE") & CSL_CHARSTATE_SUBMERGED  &&  ( iRequiredSpellId = -1 || GetHasSpellEffect( iRequiredSpellId, oTarget ) ) )
	{
		//DelayCommand( 6.0f, CSLReduceBreathableRounds( oTarget, iRounds, Repetitions, iRequiredSpellId ) );
	}
	*/
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLAbilityCheck( object oChar, int iAbility, int iDC = 10, int iRollModifier = 0, int bOneAlwaysFails = TRUE, int bTwentyAlwaysSucceeds = TRUE, int bShowFeedback = TRUE  )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLAbilityCheck Start", GetFirstPC() ); }
	
	int iResult = FALSE;

	int iAbilityModifier = GetAbilityModifier(iAbility, oChar);
	int iRoll = d20();
	if ( iRoll == 1 && bOneAlwaysFails == TRUE )
	{
		iResult = FALSE;
	}
	else if ( iRoll == 20 && bTwentyAlwaysSucceeds == TRUE )
	{
		iResult = TRUE;
	}
	else if (  iRoll+iAbilityModifier+iRollModifier < iDC )
	{
		iResult = FALSE;
	}
	else
	{
		iResult = TRUE;
	}
	
	if ( bShowFeedback )
	{
		if ( iResult )
		{
			SendMessageToPC( oChar , "Ability Check Succeeded: Roll of "+IntToString(iRoll)+"+Modifier "+IntToString( iAbilityModifier+iRollModifier )+" = "+IntToString(iRoll+iAbilityModifier+iRollModifier)+"vs DC "+IntToString( iDC ) );
		}
		else
		{
			SendMessageToPC( oChar , "Ability Check Failed: Roll of "+IntToString(iRoll)+"+Modifier "+IntToString( iAbilityModifier+iRollModifier )+" = "+IntToString(iRoll+iAbilityModifier+iRollModifier)+"vs DC "+IntToString( iDC ) );		
		}
		
	}	
	return iResult;
}




/**  
* @author
* @param 
* @see 
* @return 
*/
// Using Jailiax's spellcasting framework for my basic starting point
// Get the saving throw (fortitude, reflex or will) of a creature, door, or placeable.
// Contrary to GetFortitudeSavingThrow() function and the like, this function
// take into account active effects and item properties' increased and decreased
// saving throws versus specific effects.
// - oTarget Creature, door, or placeable from which the saving throw is get
// - iSave SAVING_THROW_FORT, SAVING_THROW_REFLEX or SAVING_THROW_WILL
// - iSaveVsType SAVING_THROW_TYPE_* constant
// * Returns the specified saving throw
//int HkSavingThrow(int iSavingThrow, object oTarget, int iDC, int iSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay=0.0 )
/*
int CSLSaveCheckFromJailiax(int iSave, object oTarget, int iSaveVsType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay=0.0, int bShowResults = TRUE )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLSaveCheckFromJailiax Start", GetFirstPC() ); }
	
	// Test if the target is a valid creature
	if (!GetIsObjectValid(oTarget))
	{
		return 0;
	}
	
	// Get the base saving throw
	int iBaseSave;
	switch (iSave)
	{
		case SAVING_THROW_FORT :
			iBaseSave = GetFortitudeSavingThrow(oTarget);
			break;
		case SAVING_THROW_REFLEX :
			iBaseSave = GetReflexSavingThrow(oTarget);
			break;
		case SAVING_THROW_WILL :
			iBaseSave = GetWillSavingThrow(oTarget);
			break;
	}

	if ( ( GetObjectType(oTarget) != OBJECT_TYPE_DOOR) && ( GetObjectType(oTarget) != OBJECT_TYPE_PLACEABLE) )
	{
		// must be a creature
		
		// Get the effect modifier
		int iEffectModifier = 0;
		int iSaveTemp;
		int iSaveVsTypeTemp;
		effect eLoop = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eLoop))
		{
			if (GetEffectType(eLoop) == EFFECT_TYPE_SAVING_THROW_INCREASE)
			{
				// Get the saving throw type (SAVING_THROW_* constant)
				iSaveTemp = GetEffectInteger(eLoop, 1);
				// Get the type of decreased saving throw (SAVING_THROW_TYPE_* constant)
				iSaveVsTypeTemp = GetEffectInteger(eLoop, 2);
				
				if (((iSaveTemp == iSave) || (iSaveTemp == SAVING_THROW_ALL))
				 && (iSaveVsTypeTemp == iSaveVsType))
				{
					iEffectModifier += GetEffectInteger(eLoop, 0);
				}
			}
			else if (GetEffectType(eLoop) == EFFECT_TYPE_SAVING_THROW_DECREASE)
			{
				// Get the saving throw type (SAVING_THROW_* constant)
				iSaveTemp = GetEffectInteger(eLoop, 1);
				// Get the type of decreased saving throw (SAVING_THROW_TYPE_* constant)
				iSaveVsTypeTemp = GetEffectInteger(eLoop, 2);
				
				if (((iSaveTemp == iSave) || (iSaveTemp == SAVING_THROW_ALL))
				 && (iSaveVsTypeTemp == iSaveVsType))
				{
					// Get the saving throw decreased value
					iEffectModifier -= GetEffectInteger(eLoop, 0);
				}
			}
			eLoop = GetNextEffect(oTarget);
		}
	
		// Get the item properties' saving throws vs type
		int iIPSaveVsType = -1;
		switch (iSaveVsType)
		{
			case SAVING_THROW_TYPE_ALL :			iIPSaveVsType = IP_CONST_SAVEVS_UNIVERSAL; break;
			case SAVING_THROW_TYPE_ACID :			iIPSaveVsType = IP_CONST_SAVEVS_ACID; break;
			case SAVING_THROW_TYPE_COLD :			iIPSaveVsType = IP_CONST_SAVEVS_COLD; break;
			case SAVING_THROW_TYPE_DEATH :			iIPSaveVsType = IP_CONST_SAVEVS_DEATH; break;
			case SAVING_THROW_TYPE_DISEASE :		iIPSaveVsType = IP_CONST_SAVEVS_DISEASE; break;
			case SAVING_THROW_TYPE_DIVINE :			iIPSaveVsType = IP_CONST_SAVEVS_DIVINE; break;
			case SAVING_THROW_TYPE_ELECTRICITY :	iIPSaveVsType = IP_CONST_SAVEVS_ELECTRICAL; break;
			case SAVING_THROW_TYPE_FEAR	:			iIPSaveVsType = IP_CONST_SAVEVS_FEAR; break;
			case SAVING_THROW_TYPE_FIRE :			iIPSaveVsType = IP_CONST_SAVEVS_FIRE; break;
			case SAVING_THROW_TYPE_MIND_SPELLS :	iIPSaveVsType = IP_CONST_SAVEVS_MINDAFFECTING; break;
			case SAVING_THROW_TYPE_NEGATIVE :		iIPSaveVsType = IP_CONST_SAVEVS_NEGATIVE; break;
			case SAVING_THROW_TYPE_POISON :			iIPSaveVsType = IP_CONST_SAVEVS_POISON; break;
			case SAVING_THROW_TYPE_POSITIVE :		iIPSaveVsType = IP_CONST_SAVEVS_POSITIVE; break;
			case SAVING_THROW_TYPE_SONIC :			iIPSaveVsType = IP_CONST_SAVEVS_SONIC; break;
		}
	
		// Get the item property modifier
		int iItemPropModifier = 0;
		if (iIPSaveVsType != -1)
		{
			// Loop all all items held by the creature
			itemproperty ipLoop;
			object oItemHeld; int iLoop;
			for (iLoop = 0; iLoop < 17; iLoop++)
			{
				oItemHeld = GetItemInSlot(iLoop, oTarget);
				if (GetIsObjectValid(oItemHeld)
				 && (GetItemHasItemProperty(oItemHeld, ITEM_PROPERTY_SAVING_THROW_BONUS)
				  || GetItemHasItemProperty(oItemHeld, ITEM_PROPERTY_DECREASED_SAVING_THROWS)))
				{
					// Loop all item propeties of an item
					ipLoop = GetFirstItemProperty(oItemHeld);
					while (GetIsItemPropertyValid(ipLoop))
					{
						// Item property that increases saving throws vs type found
						if ((GetItemPropertyType(ipLoop) == ITEM_PROPERTY_SAVING_THROW_BONUS)
						 && ((GetItemPropertySubType(ipLoop) == iIPSaveVsType)
						  || (GetItemPropertySubType(ipLoop) == IP_CONST_SAVEVS_UNIVERSAL)))
							iItemPropModifier += GetItemPropertyCostTableValue(ipLoop);
						// Item property that decreases saving throws vs type found
						else if ((GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DECREASED_SAVING_THROWS)
						 && ((GetItemPropertySubType(ipLoop) == iIPSaveVsType)
						  || (GetItemPropertySubType(ipLoop) == IP_CONST_SAVEVS_UNIVERSAL)))
							iItemPropModifier -= GetItemPropertyCostTableValue(ipLoop);
						ipLoop = GetNextItemProperty(oItemHeld);
					}
				}
			}
		}
	
		iBaseSave = iBaseSave + iEffectModifier + iItemPropModifier;
	}
	
	
	if ( GetObjectType( oSaveVersus ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		oSaveVersus = GetAreaOfEffectCreator();
	}
	return iBaseSave;
}
*/


/**  
* @author
* @param 
* @see 
* @return 
*/
/*
int CSLSavingThrowFromPRC(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    if (DEBUGGING >= 7) { CSLDebug(  "CSLSavingThrowFromPRC Start", GetFirstPC() ); }
    
    // -------------------------------------------------------------------------
    // GZ: sanity checks to prevent wrapping around
    // -------------------------------------------------------------------------
    if (nDC<1)
       nDC = 1;
    else if (nDC > 255)
      nDC = 255;

    effect eVis;
    int bValid = FALSE;
    int nSpellID;
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }

    nSpellID = GetSpellId();

    // *
    //    return 0 = FAILED SAVE
    //    return 1 = SAVE SUCCESSFUL
    //    return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
   // * /
    if(bValid == 0)
    {
        if((nSaveType == SAVING_THROW_TYPE_DEATH
         || nSpellID == SPELL_WEIRD
         || nSpellID == SPELL_FINGER_OF_DEATH) &&
         nSpellID != SPELL_HORRID_WILTING)
        {
            eVis = EffectVisualEffect(VFX_IMP_DEATH);
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
    }
    if(bValid == 2)
    {
        eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    }
    if(bValid == 1 || bValid == 2)
    {
        if(bValid == 2)
        {
            // If the spell is save immune then the link must be applied in order to get the true immunity
            // to be resisted.  That is the reason for returing false and not true.  True blocks the
            //  application of effects.
            bValid = FALSE;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}
*/

/**  
* @author
* @param 
* @see 
* @return 
*/
//------------------------------------------------------------------------------
// returns TRUE if a creature is not in the condition to use gaze attacks
// i.e. blindness
//------------------------------------------------------------------------------
int CSLIsGazeAttackBlocked(object oCreature)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIsGazeAttackBlocked Start", GetFirstPC() ); }
	
	if ( CSLGetHasEffectType( oCreature, EFFECT_TYPE_BLINDNESS ) )
	{
			FloatingTextStrRefOnCreature(84530, oCreature ,FALSE); // * blinded
			return TRUE;
	}
	return FALSE;
}





/**  
* @author
* @param 
* @see 
* @return 
*/
// The caller will perform a Ranged Touch Attack on oTarget
// * iBonus is an additonal bonus to the attack roll.
// * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
// * UPDATE - Brock H - 08/16/05 - 
// * These return TOUCH_ATTACK_RESULT_MISS, TOUCH_ATTACK_RESULT_HIT, or TOUCH_ATTACK_RESULT_CRITICAL
int CSLTouchAttackRanged(object oTarget, int bDisplayFeedback=TRUE, int iBonus=0, int bUseRangedOverride = FALSE, object oAttacker = OBJECT_SELF )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLTouchAttackRanged Start", GetFirstPC() ); }
	
	if ( GetHasFeat( FEAT_POINT_BLANK_SHOT, OBJECT_SELF ) )
	{
		if(  GetDistanceToObject(oTarget) <= 9.144f ) // this is in point blank range
		{
			iBonus += 1;
		}
	}
	
	if ( bUseRangedOverride == TRUE && GetHasFeat( FEAT_DEFLECT_ARROWS, oTarget)  )
	{
		object oCaster = OBJECT_SELF;
		// subtract the strength bonus
		
		iBonus = iBonus - GetAbilityModifier(ABILITY_STRENGTH, oCaster);
		//iBonus = iBonus - GetAbilityScore(oCaster, ABILITY_STRENGTH, FALSE);
		
		// add in the dex bonus
		iBonus = iBonus + GetAbilityModifier(ABILITY_DEXTERITY, oCaster);
		//iBonus = iBonus + GetAbilityScore(oCaster, ABILITY_DEXTERITY, FALSE);
		
		return TouchAttackMelee( oTarget, bDisplayFeedback, iBonus);
	}
	else
	{
		return TouchAttackRanged( oTarget, bDisplayFeedback, iBonus);
	}
	
	//TOUCH_ATTACK_RESULT_MISS
	//TOUCH_ATTACK_RESULT_HIT
	//TOUCH_ATTACK_RESULT_CRITICAL
	
	///Attacker: 1d20 + base attack bonus + bonus stat (see above for type) + attack bonuses
	//Defender: 10 + Dexterity bonus + Dodge AC bonus + Deflection AC bonus+  Size modifier	
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// The caller will perform a Ranged Touch Attack on oTarget
// * iBonus is an additonal bonus to the attack roll.
// * Returns 0 on a miss, 1 on a hit and 2 on a critical hit
// * UPDATE - Brock H - 08/16/05 - 
// * These return TOUCH_ATTACK_RESULT_MISS, TOUCH_ATTACK_RESULT_HIT, or TOUCH_ATTACK_RESULT_CRITICAL
int CSLTouchAttackMelee(object oTarget, int bDisplayFeedback=TRUE, int iBonus=0, object oAttacker = OBJECT_SELF )
{
	return TouchAttackMelee( oTarget, bDisplayFeedback, iBonus);
}

/*
const int SC_TOUCH_UNKNOWN = 0;
const int SC_TOUCH_MELEE = 1;
const int SC_TOUCH_RANGED = 2;
const int SC_TOUCHSPELL_MELEE = 3;
const int SC_TOUCHSPELL_RANGED = 4;
const int SC_TOUCHSPELL_RAY = 5;
*/


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGrappleCheck(object oCaster, object oTarget, int iAttackerBonus)
{
    if (DEBUGGING >= 7) { CSLDebug(  "CSLGrappleCheck Start", GetFirstPC() ); }
    
    int nAttackerBonus = 0;
    int nDefenderBonus = 0;
    
	nDefenderBonus = CSLGetSizeModifierGrapple( oTarget );
	
    //nAttackerBonus = GetCasterLevel(oCaster) + 8;
    nDefenderBonus = GetBaseAttackBonus(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + nDefenderBonus;

	int nCasterVal = d20(1) + iAttackerBonus;
    int nTargetVal = d20(1) + nDefenderBonus;
	
    if( nCasterVal > nTargetVal )
    {
    	return TRUE;
    }
	return FALSE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns the low end of the critical range for the weapon the caller of the
// function has equipped.
// was GetCriticalRange
int CSLGetCriticalRange(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetCriticalRange Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	int nWeapon = GetBaseItemType(oWeapon);
	int nBaseRange = CSLGetItemDataCriticalThreat(nWeapon);
	int nImprCrit = CSLGetItemDataPrefFeatImprovedCritical(nWeapon);
	int nNoStack = 0;
	int nSubtract, nRange;

	// Base crit range of the weapon.	
	if (nBaseRange == 1)
	{
		nSubtract += 0;
	}
	else if (nBaseRange == 2)
	{
		nSubtract += 1;
	}
	else if (nBaseRange == 3)
	{
		nSubtract += 2;
	}
	
	// Ki Critical feat for Weapon Masters.
	if (GetHasFeat(FEAT_KI_CRITICAL))
	{
		int nWoC = CSLGetItemDataPrefFeatWeaponOfChoice(nWeapon);

		if (GetHasFeat(nWoC))
		{
			nSubtract += 2;
		}
	}
	
	// Properties that don't stack together.
	
	if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_KEEN) && (nNoStack == 0))
	{
		if (nBaseRange == 1)
		{
			nSubtract += 1;
			nNoStack = 1;
		}
		else if (nBaseRange == 2)
		{
			nSubtract += 2;
			nNoStack = 1;
		}
		else if (nBaseRange == 3)
		{
			nSubtract += 3;
			nNoStack = 1;
		}
	}
	
	if ((GetHasFeat(nImprCrit)) && (nNoStack == 0))
	{
		if (nBaseRange == 1)
		{
			nSubtract += 1;
			nNoStack = 1;
		}
		else if (nBaseRange == 2)
		{
			nSubtract += 2;
			nNoStack = 1;
		}
		else if (nBaseRange == 3)
		{
			nSubtract += 3;
			nNoStack = 1;
		}
	}
	

	if ((GetHasSpellEffect(SPELL_KEEN_EDGE) || GetHasSpellEffect(SPELL_WEAPON_OF_IMPACT)))
	{
		if (nNoStack == 0)
		{
			if (nBaseRange == 1)
			{
				nSubtract += 1;
				nNoStack = 1;
			}
			else if (nBaseRange == 2)
			{
				nSubtract += 2;
				nNoStack = 1;
			}
			else if (nBaseRange == 3)
			{
				nSubtract += 3;
				nNoStack = 1;
			}
		}
	}
	
	nRange = 20 - nSubtract;
	return nRange;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns any bonuses to critical confirmation rolls.
int CSLGetCriticalConfirmMod(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetCriticalConfirmMod Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	int nWeapon = GetBaseItemType(oWeapon);
	int nConfirm = 0;
	int nPowerCrit = CSLGetItemDataPrefFeatPowerCritical(nWeapon);
	
	if (GetHasFeat(nPowerCrit))
	{
		nConfirm += 4;
	}
	
	if (GetHasFeat(FEAT_BATTLE_ARDOR, oPC))
	{
		int nMyInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC );

		if (nMyInt < 1)
		{
			nConfirm += 0;
		}
		else nConfirm += nMyInt;
	}	
	return nConfirm;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns the critical multiplier of oWeapon.
int CSLGetCriticalMultiplier(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetCriticalMultiplier Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	int nWeapon = GetBaseItemType(oWeapon);
	int nCritMult = CSLGetItemDataCriticalHitMultiplier(nWeapon);

	if (GetHasFeat(FEAT_INCREASE_MULTIPLIER))
	{
		nCritMult += 1;
	}
	return nCritMult;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns oTarget's attack modifier for a Touch attack.
// -bRanged: TRUE for a ranged touch, FALSE for melee.
int CSLGetTouchAB(object oTarget, int bRanged = FALSE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetTouchAB Start", GetFirstPC() ); }
	
	int nBAB = GetTRUEBaseAttackBonus(oTarget);
	int nAbilityMod;
	int nBonus;

	if (bRanged == FALSE)
	{
		nAbilityMod = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
		
		if (GetHasFeat(2107, oTarget)) //FEAT_WEAPON_FOCUS_MELEE_TOUCH_ATTACK
		{
			nBonus += 1;
		}
	}
	else if (bRanged == TRUE)
	{
		nAbilityMod = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);

		if (GetHasFeat(2108, oTarget)) //FEAT_WEAPON_FOCUS_RANGED_TOUCH_ATTACK
		{
			nBonus += 1;
		}
	}

	effect eAB = GetFirstEffect(oTarget);

	while (GetIsEffectValid(eAB))
	{
		if (GetEffectType(eAB) == EFFECT_TYPE_ATTACK_INCREASE)
		{
			int nEffectBonus = GetEffectInteger(eAB, 0);
			nBonus += nEffectBonus;
		}
		else if (GetEffectType(eAB) == EFFECT_TYPE_ATTACK_DECREASE)
		{
			int nEffectBonus = GetEffectInteger(eAB, 0);
			nBonus -= nEffectBonus;
		}
		
		eAB = GetNextEffect(oTarget);
	}

	int nTotal = nBAB + nAbilityMod + nBonus;
	return nTotal;
}


/**  
// Determines if oPC is currently suffering from a miss chance effect.
// If they are this function also makes the miss chance roll and stores the
// result on oPC under the int index name "bot9s_misschance_int".
// HasMissChance
* @author
* @param 
* @see 
* @return 
*/
int CSLHasMissChance(object oPC)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLHasMissChance Start", GetFirstPC() ); }
	
	effect eMiss;
	int nReturn;

	nReturn = FALSE;
	eMiss = GetFirstEffect(oPC);

	while (GetIsEffectValid(eMiss))
	{
		if (GetEffectType(eMiss) == EFFECT_TYPE_BLINDNESS)
		{
			if (GetHasFeat(FEAT_BLIND_FIGHT, oPC))
			{
				int nd100 = d100(1);
				int nD100 = d100(1);

				if ((nd100 < 50) && (nD100 < 50))
				{
					SetLocalInt(oPC, "bot9s_misschance_int", 1);
					nReturn = TRUE;
					break;
				}
				else SetLocalInt(oPC, "bot9s_misschance_int", 0);
			}
			else if (d100(1) < 50)
			{
				SetLocalInt(oPC, "bot9s_misschance_int", 1);
				nReturn = TRUE;
				break;
			}
			else SetLocalInt(oPC, "bot9s_misschance_int", 0);
		}
		else if (GetEffectType(eMiss) == EFFECT_TYPE_MISS_CHANCE)
		{
			int nChance = GetEffectInteger(eMiss, 0);

			if (d100(1) < nChance)
			{
				SetLocalInt(oPC, "bot9s_misschance_int", 1);
				nReturn = TRUE;
				break;
			}
			else SetLocalInt(oPC, "bot9s_misschance_int", 0);
		}

		eMiss = GetNextEffect(oPC);
	}

	return nReturn;			
}






/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSneakLevels(object oTarget)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetSneakLevels Start", GetFirstPC() ); }
	
	int nClassLevel = 0;
	int nSneakLevels = 0;
	
	// Stock classes
	nClassLevel = GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE, oTarget);	
	if (nClassLevel > 1)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	nClassLevel = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oTarget);	
	if (nClassLevel > 1)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
		
	nClassLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	nClassLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oTarget);	
	if (nClassLevel > 3)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	if (GetLevelByClass(CLASS_NWNINE_WARDER, oTarget) > 2)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}		
			
	nClassLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	nClassLevel = GetLevelByClass(CLASS_TYPE_SHADOWTHIEFOFAMN, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	// Begin my classes
	
	nClassLevel = GetLevelByClass(CLASS_CHARNAG_MAELTHRA, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	nClassLevel = GetLevelByClass(CLASS_SHADOWBANE_STALKER, oTarget);
	if (nClassLevel > 2)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}		
	
	nClassLevel = GetLevelByClass(CLASS_SKULLCLAN_HUNTER, oTarget);
	if (nClassLevel > 2)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}		
	
	nClassLevel = GetLevelByClass(CLASS_WHIRLING_DERVISH, oTarget);
	if (nClassLevel > 2)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
		
	nClassLevel = GetLevelByClass(CLASS_DARK_LANTERN, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}		
	
	nClassLevel = GetLevelByClass(CLASS_DREAD_COMMANDO, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
		
	nClassLevel = GetLevelByClass(CLASS_THUG, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}


	nClassLevel = GetLevelByClass(CLASS_TYPE_AVENGER, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
		
	nClassLevel = GetLevelByClass(CLASS_BLACK_FLAME_ZEALOT, oTarget);
	if (nClassLevel > 2)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	nClassLevel = GetLevelByClass(CLASS_DIVINE_SEEKER, oTarget);
	if (nClassLevel > 1)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	nClassLevel = GetLevelByClass(CLASS_NIGHTSONG_INFILTRATOR, oTarget);
	if (nClassLevel > 3)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	nClassLevel = GetLevelByClass(CLASS_NIGHTSONG_ENFORCER, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	//1.38
	nClassLevel = GetLevelByClass(CLASS_DAGGERSPELL_MAGE, oTarget);
	if (nClassLevel > 2)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	nClassLevel = GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oTarget);
	if (nClassLevel > 2)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}
		
	nClassLevel = GetLevelByClass(CLASS_NINJA, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	nClassLevel = GetLevelByClass(CLASS_SCOUT, oTarget);
	if (nClassLevel > 0)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	nClassLevel = GetLevelByClass(CLASS_WILD_STALKER, oTarget);
	if (nClassLevel > 1)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}


	nClassLevel = GetLevelByClass(CLASS_GHOST_FACED_KILLER, oTarget);
	if (nClassLevel > 1)
	{
		nSneakLevels = nSneakLevels + nClassLevel;
	}


	return nSneakLevels;
	
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetTotalSneakDice(object oTarget, object oSneakAttacker = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetTotalSneakDice Start", GetFirstPC() ); }
	
	int iDice = 0;
	int nClassLevel = 0;
	int nSneakLevels = 0;
	
	// Stock classes
	
	nClassLevel = GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE, oSneakAttacker);	
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel + 1) / 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	
	nClassLevel = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oSneakAttacker);	
	if (nClassLevel > 1)
	{
		iDice = iDice + nClassLevel / 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
		
	nClassLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel + 1) / 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	nClassLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oSneakAttacker);	
	if (nClassLevel > 3)
	{
		iDice = iDice + (nClassLevel - 1) / 3;
		nSneakLevels = nSneakLevels + nClassLevel;
	}

	if (GetLevelByClass(CLASS_NWNINE_WARDER, oSneakAttacker) > 2)
	{
		iDice = iDice + 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}		
			
	nClassLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oSneakAttacker);
	if (nClassLevel > 0)
	{
		if (GetHasFeat(FEAT_DARING_OUTLAW , oSneakAttacker))
		{
			nClassLevel += GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oSneakAttacker);
		}
		iDice = iDice + (nClassLevel + 1) / 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	nClassLevel = GetLevelByClass(CLASS_TYPE_SHADOWTHIEFOFAMN, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel + 1) / 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	// Begin my classes
	
	nClassLevel = GetLevelByClass(CLASS_CHARNAG_MAELTHRA, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + ((nClassLevel + 1)/2);
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	
	nClassLevel = GetLevelByClass(CLASS_SHADOWBANE_STALKER, oSneakAttacker);
	if (nClassLevel > 2)
	{
		iDice = iDice + nClassLevel / 3;
		nSneakLevels = nSneakLevels + nClassLevel;
	}			
	
	nClassLevel = GetLevelByClass(CLASS_SKULLCLAN_HUNTER, oSneakAttacker);
	if (nClassLevel > 2)
	{
		iDice = iDice + nClassLevel / 3;
		nSneakLevels = nSneakLevels + nClassLevel;
	}		
	
	nClassLevel = GetLevelByClass(CLASS_WHIRLING_DERVISH, oSneakAttacker);
	if (nClassLevel > 2)
	{
		iDice = iDice + nClassLevel / 3;
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
		
	nClassLevel = GetLevelByClass(CLASS_DARK_LANTERN, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel / 2 );
		nSneakLevels = nSneakLevels + nClassLevel;
	}		
	
	nClassLevel = GetLevelByClass(CLASS_DREAD_COMMANDO, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel + 1) / 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
		
	nClassLevel = GetLevelByClass(CLASS_THUG, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel / 2 );
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	nClassLevel = GetLevelByClass(CLASS_TYPE_AVENGER, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel + 1) / 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
		
	nClassLevel = GetLevelByClass(CLASS_BLACK_FLAME_ZEALOT, oSneakAttacker);
	if (nClassLevel > 2)
	{
		iDice = iDice + nClassLevel / 3;
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	nClassLevel = GetLevelByClass(CLASS_DIVINE_SEEKER, oSneakAttacker);
	if (nClassLevel > 1)
	{
		iDice = iDice + (nClassLevel + 1) / 3;
		nSneakLevels = nSneakLevels + nClassLevel;
	}	
	
	nClassLevel = GetLevelByClass(CLASS_NIGHTSONG_INFILTRATOR, oSneakAttacker);
	if (nClassLevel > 3)
	{
		iDice = iDice + nClassLevel / 4;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	nClassLevel = GetLevelByClass(CLASS_NIGHTSONG_ENFORCER, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel + 2) / 3;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	//1.38
	nClassLevel = GetLevelByClass(CLASS_NINJA, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice  + (nClassLevel + 1) / 2;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	nClassLevel = GetLevelByClass(CLASS_SCOUT, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice  + (nClassLevel + 3) / 4;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	nClassLevel = GetLevelByClass(CLASS_DAGGERSPELL_MAGE, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice + (nClassLevel / 3);
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	nClassLevel = GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice  + (nClassLevel / 3);
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	nClassLevel = GetLevelByClass(CLASS_GHOST_FACED_KILLER, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice  + (nClassLevel + 1) / 3;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	nClassLevel = GetLevelByClass(CLASS_WILD_STALKER, oSneakAttacker);
	if (nClassLevel > 0)
	{
		iDice = iDice  + (nClassLevel + 2) / 4;
		nSneakLevels = nSneakLevels + nClassLevel;
	}
	
	if ( GetIsObjectValid(oTarget) &&  GetHasFeat(FEAT_IMPROVED_UNCANNY_DODGE, oTarget, TRUE))
	{
		if ( nSneakLevels > ( CSLGetSneakLevels(oTarget) + 3) ) // Need to be >= Target Dice + 4
		{
			return iDice;
		}
		else
		{
			return 0;
		}
	}		
	return iDice;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLIsTargetConcealed(object oTarget, object oSneakAttacker)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIsTargetConcealed Start", GetFirstPC() ); }
	
	//int bIsConcealed = FALSE;
	int bAttackerHasTrueSight =  CSLGetHasEffectType( oSneakAttacker, EFFECT_TYPE_TRUESEEING ) || GetHasSpellEffect( SPELL_TRUE_SEEING, oSneakAttacker );
	int bAttackerCanSeeInvisble = CSLGetHasEffectType( oSneakAttacker, EFFECT_TYPE_SEEINVISIBLE );
	int bAttackerUltraVision = CSLGetHasEffectType(oSneakAttacker, EFFECT_TYPE_ULTRAVISION);
	
	if (CSLGetHasEffectType(oTarget, EFFECT_TYPE_CONCEALMENT_NEGATED))
	{
		return FALSE;
	}
	else if ((GetHasFeat(2031, oSneakAttacker)) && (GetIsSpirit(oTarget))) // Ghost Warrior
	{
		return FALSE;
	}
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_50, oTarget) )
	{
		return TRUE;
	}
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_40, oTarget) )     
	{
		return TRUE;
	}
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_30, oTarget) )     
	{
		return TRUE;
	}
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_20, oTarget) )     
	{
		return TRUE;
	}
	else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_10, oTarget) )     
	{
		return TRUE;
	}
	else if(GetStealthMode(oTarget) == STEALTH_MODE_ACTIVATED && !GetObjectSeen(oTarget, oSneakAttacker) )  
	{
		return TRUE;
	}
	else if(!GetObjectSeen(oTarget, oSneakAttacker)) // Removed the mode check because initiating a strike seems to jump out of Stealth before the check is made.
	{
		return TRUE;
	}
	else if(CSLGetHasEffectType(oTarget,EFFECT_TYPE_SANCTUARY) && !bAttackerHasTrueSight )
	{
		return TRUE;
	}
	else if(CSLGetHasEffectType(oTarget,EFFECT_TYPE_INVISIBILITY) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble )
	{
		return TRUE;
	}
	else if(CSLGetHasEffectType(oTarget,EFFECT_TYPE_DARKNESS) && !bAttackerHasTrueSight && !bAttackerUltraVision)
	{
		return TRUE;
	}
	else if(GetHasFeatEffect(FEAT_EMPTY_BODY, oTarget) )
	{
		return TRUE;
	}
	else if(CSLGetHasEffectType(oTarget,EFFECT_TYPE_ETHEREAL) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble  )
	{
		return TRUE;
	}
	else if(CSLGetHasEffectType(oTarget,EFFECT_TYPE_CONCEALMENT) && !bAttackerHasTrueSight)
	{
		return TRUE;
	}	
	return FALSE;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// Makes the caller of the function constantly turn to face oTarget. Does the same thing as CSLTurnToFaceObject except that it checks for range and if oPC and oTarget are alive.
void CSLWatchOpponent(object oTarget, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLWatchOpponent Start", GetFirstPC() ); }
	
	if ((GetCurrentHitPoints(oTarget) > 0) && (GetCurrentHitPoints(oPC) > 0))
	{
		// Must add HITDIST to the preload data when I get it sorted out.
		float fRange = CSLGetMeleeRange(oPC) + CSLGetHitDistance(oTarget);
		
		if (GetDistanceToObject(oTarget) <= fRange)
		{
			AssignCommand(oPC,  SetFacingPoint( GetPosition(oTarget)));
		}
	}
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// Determines if the PC is flanking the target or not.  Returns TRUE if they are.
int CSLIsFlankValid(object oPC, object oTarget)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIsFlankValid Start", GetFirstPC() ); }
	
	object oFlanker, oWeapon;
	location lPC = GetLocation(oPC);
	float fWeapon = CSLGetMeleeRange(oPC);
	float fFace = GetFacing(oPC); // Doesn't appear to update sometimes.  Possibly the reason that normal sneak attacks can sometimes miss from a perfect flank and hit from odd places.
	float fFoeGirth = CSLGetGirth(oTarget);
	float fRange = FeetToMeters(30.0f) + fFoeGirth;
	float fFoeDist = GetDistanceBetween(oPC, oTarget);
	float fFlankerRange, fDistance, fFlankerFace, fMaxFlankDistance;
	int nFlank, nFlankFace, nDamageType;

	nFlank = FALSE;
	oFlanker = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	if ((oFlanker != oPC) && (!GetIsReactionTypeHostile(oFlanker, oPC))) // Don't bother if we don't need to.
	{
		fFlankerRange = CSLGetMeleeRange(oFlanker);
		fMaxFlankDistance = fFoeGirth + fFlankerRange + fWeapon + 0.1f;
		fDistance = GetDistanceBetween(oPC, oFlanker);
		fFlankerFace = GetFacing(oFlanker);
		nFlankFace = CSLIsDirectionWithinTolerance(fFace, fFlankerFace, 135.0f);
	}

	while (GetIsObjectValid(oFlanker))
	{
		if (GetLocalInt(oFlanker, "OverrideFlank") == 1)
		{
			nFlank = TRUE;
			return nFlank;
		}
		else if ((!GetIsReactionTypeHostile(oFlanker, oPC)) && (oFlanker != oPC) && (nFlankFace == FALSE) && (fDistance <= fMaxFlankDistance) && (fDistance > fFoeDist) && (GetIsObjectValid(oTarget)) && (GetAttackTarget(oFlanker) == oTarget))
		{
			nFlank = TRUE;
			return nFlank;
		}
		else
		{
			oFlanker = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}
		
		if ((oFlanker != oPC) && (!GetIsReactionTypeHostile(oFlanker, oPC))) // Don't bother if we don't need to.
		{
			fFlankerRange = CSLGetMeleeRange(oFlanker);
			fMaxFlankDistance = fFoeGirth + fFlankerRange + fWeapon + 0.1f;
			fDistance = GetDistanceBetween(oPC, oFlanker);
			fFlankerFace = GetFacing(oFlanker);
			nFlankFace = CSLIsDirectionWithinTolerance(fFace, fFlankerFace, 135.0f);
		}
	}
	return nFlank;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Sneak Attack can't be used against targets with concealment, this is a bit of a mess, need to rethink the logic better
int CSLIsTargetValidForSneakAttack(object oTarget, object oSneakAttacker)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIsTargetValidForSneakAttack Start", GetFirstPC() ); }
	
	int nEpicPrecision = FALSE;
	object oAttackedByTarget = GetAttackTarget(oTarget);

	//Don't bother if the target is out of range
	if (GetDistanceBetween(oSneakAttacker, oTarget) < ( FeetToMeters(30.0f) + CSLGetGirth(oSneakAttacker) - CSLGetGirth(oTarget) ) )
	{
		//Don't bother if the target is immune, need to add in the various exceptions to immunity based on feats and the like
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK, oSneakAttacker) || GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, oSneakAttacker))
		{ 
			if (GetHasFeat(2128, oSneakAttacker))
			{
				nEpicPrecision = TRUE;
			}
			else
			{
				if (DEBUGGING >= 6) { CSLDebug(  " immune to sneak ", oSneakAttacker  ); }
				return FALSE;
			}

		}
		
		int nSneakLevels = CSLGetSneakLevels(oSneakAttacker);
		
		if (nSneakLevels < 1)
		{
			if (DEBUGGING >= 6) { CSLDebug(  " No sneaklevels ", oSneakAttacker  ); }
			return FALSE;
		}
		
		
		if ( CSLGetIsIncapacitated( oTarget, FALSE,  FALSE, !GetHasFeat( FEAT_BLIND_FIGHT, oTarget), TRUE, TRUE, TRUE) )
		{
			if (DEBUGGING >= 6) { CSLDebug(  " is incapacitated so TRUE ", oSneakAttacker  ); }
			if (nEpicPrecision)
			{
				return 2;
			}
			return TRUE;
		}
		
		
		if (GetHasFeat(FEAT_IMPROVED_UNCANNY_DODGE, oTarget, TRUE))
		{
			if (nSneakLevels > (CSLGetSneakLevels(oTarget) + 3) ) // Need to be >= Target Dice + 4
			{
				if (DEBUGGING >= 6) { CSLDebug(  " uncanny dodge false ", oSneakAttacker  ); }
				return FALSE;
			}
		}

		
		
		
		//if ( CSLIsTargetConcealed(oSneakAttacker, oTarget) )
		//{
	//		if (DEBUGGING >= 6) { CSLDebug(  " concealed attacker true ", oSneakAttacker  ); }
		//	return TRUE;
		//}
		//else
		if ( !GetObjectSeen( oSneakAttacker, oTarget) )
		{
			if (DEBUGGING >= 6) { CSLDebug(  " can't see you so can sneak ", oSneakAttacker  ); }
			if (nEpicPrecision)
			{
				return 2;
			}
			return TRUE;
		}
		else if ( !GetIsInCombat(oTarget) )
		{
			if (DEBUGGING >= 6) { CSLDebug(  " not in combat ", oSneakAttacker  ); }
			if (nEpicPrecision)
			{
				return 2;
			}
			return TRUE; // Flat-footed.
		}
		else if ( GetLocalInt(oTarget, "OverrideFlatFootedAC") )
		{
			if (DEBUGGING >= 6) { CSLDebug(  " override flat footed ", oSneakAttacker  ); }
			if (nEpicPrecision)
			{
				return 2;
			}
			return TRUE;
		}
		else if (oAttackedByTarget == oSneakAttacker) //Head to Head requires the target be unable to defend themself
		{
			if (DEBUGGING >= 6) { CSLDebug(  " sneaker is directly fighting with victim false ", oSneakAttacker  ); }
			return FALSE;
		}
		
		//Don't bother if the target is concealed
		if ( CSLIsTargetConcealed(oTarget, oSneakAttacker) )
		{
			if (DEBUGGING >= 6) { CSLDebug(  " target concealed false ", oSneakAttacker  ); }
			return FALSE;
		}
		
		if ( CSLIsFlankValid(oSneakAttacker, oTarget)  ) //Listed as 'else if' because if we're already a target the flank doesn't matter.
		{
			if (DEBUGGING >= 6) { CSLDebug(  " valid flank true ", oSneakAttacker  ); }
			if (nEpicPrecision)
			{
				return 2;
			}
			return TRUE;
		}
		//return TRUE;  // Should check if flanking but this is good for now.
			
	} // end distance check
	if (DEBUGGING >= 6) { CSLDebug(  " nothing else false ", oSneakAttacker  ); }
	return FALSE;
}







/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLEvaluateSneakAttack(object oTarget, object oSneakAttacker)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLEvaluateSneakAttack Start", GetFirstPC() ); }
	
	if ( !CSLGetPreferenceSwitch("SneakAttackSpells",FALSE) )
	{
		return 0;
	}
	int nIsTargetValidForSneakAttack = CSLIsTargetValidForSneakAttack( oTarget, oSneakAttacker);
	if (  nIsTargetValidForSneakAttack )
	{
		int iDice = CSLGetTotalSneakDice(oTarget, oSneakAttacker);
		
		if (iDice > 0)
		{
			if (nIsTargetValidForSneakAttack == 2)
			{
				iDice = iDice / 2;
			}
			int iDamage =  d6(iDice);
			if ( iDamage > 0 )
			{
				FloatingTextStringOnCreature("Sneak Attack!", oSneakAttacker);
				SendMessageToPC(oSneakAttacker, "Sneak Attack! ("+IntToString(iDamage)+")");
				return iDamage;	
			}
		}
		else
		{
			return 0;
		}
	}		
	return 0;

}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns the damage of a die with nDice sides, for nNum amount of Dice accounting for max damage effects and chaos effects.
int CSLGetDamageByDice(int nDice, int nNum, object oPC = OBJECT_SELF )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetDamageByDice Start", GetFirstPC() ); }
	
	//object oToB = CSLGetDataStore(oPC);
	int nDamage, nCheck;
	effect eMax;

	eMax = GetFirstEffect(oPC);

	while (GetIsEffectValid(eMax))
	{
		int nType = GetEffectType(eMax);

		if (nType == EFFECT_TYPE_MAX_DAMAGE)
		{
			nCheck = 1;
			break;
		}
		eMax = GetNextEffect(oPC);
	}

	if (nCheck == 1) // Max damage effect and Aura of Chaos would crash these functions if stacked.
	{
		nDamage = nDice * nNum;
	}
	else if ( GetLocalInt(oPC, "Stance") == STANCE_AURA_OF_CHAOS || GetLocalInt(oPC, "Stance2") == STANCE_AURA_OF_CHAOS )
	{
		int nTotal, n;

		n = 1;

		while (n <= nNum)
		{
			switch (nDice)
			{
				case 2:	nDamage = d2(1);	break;
				case 3:	nDamage = d3(1);	break;
				case 4:	nDamage	= d4(1);	break;
				case 6: nDamage = d6(1);	break;
				case 8: nDamage = d8(1);	break;
				case 10:nDamage = d10(1);	break;
				case 12:nDamage = d12(1);	break;
				case 20:nDamage = d20(1);	break;
				default:nDamage = 1;		break;
			}

			if (nDamage < nDice) // Damage die is not max value.
			{
				nTotal += nDamage;
				n++;
			}
			else nTotal += nDamage;
		}

		nDamage = nTotal;
	}
	else
	{
		switch (nDice)
		{
			case 2:	nDamage = d2(nNum);	break;
			case 3:	nDamage = d3(nNum);	break;
			case 4:	nDamage	= d4(nNum);	break;
			case 6: nDamage = d6(nNum);	break;
			case 8: nDamage = d8(nNum);	break;
			case 10:nDamage = d10(nNum);break;
			case 12:nDamage = d12(nNum);break;
			case 20:nDamage = d20(nNum);break;
			default:nDamage = 1;		break;
		}
	}
	
	return nDamage;	
}




/**  
* @author
* @param 
* @see 
* @return 
*/
// Temporary Effects.  Each Needs to be applied seperately to get the proper durations.
// Simulates the effects of Invisible Blade's Bleeding Wound.
// Only meant for use in conjunction with TOBSneakAttack.
effect CSLIBBleedingWound()
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLIBBleedingWound Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	effect eBlW;
	
	if (GetHasFeat(2054, oPC)) //Bleeding Wound 3
	{
		eBlW = EffectDamageOverTime(6, 6.0f, DAMAGE_TYPE_MAGICAL, TRUE);
	}
	else if (GetHasFeat(2053, oPC)) //Bleeding Wound 2
	{
		eBlW = EffectDamageOverTime(4, 6.0f, DAMAGE_TYPE_MAGICAL, TRUE);
	}
	else if (GetHasFeat(2052, oPC)) //Bleeding Wound
	{
		eBlW = EffectDamageOverTime(2, 6.0f, DAMAGE_TYPE_MAGICAL, TRUE);
	}
	return eBlW;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Debuffs the Target's AC for one round.
effect CSLMissileVolley(object oPC, object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLMissileVolley Start", GetFirstPC() ); }
	
	effect eVolley = EffectACDecrease(1, AC_DODGE_BONUS, DAMAGE_TYPE_SLASHING);
	return eVolley;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// Creates the effect of the PC throwing the target.
// The target is thrown ahead of the PC.
// - oTarget: The creature we want to throw
// - fDistance: How far we want to throw him.
// - bRecordLanding: Store the location that oTarget lands at as 
// "bot9s_landing" on oPC, when this value is set to TRUE.
// - bAhead: When set to true will find a location directly in front of the 
// player, otherwise a random location fDistance away is used.
void CSLThrowTarget(object oTarget, float fDistance, int bRecordLanding = FALSE, int bAhead = TRUE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLThrowTarget Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oArea = GetArea(oPC);
	float fFive = FeetToMeters(5.0f);
	location lThrowLocation;

	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	// -5 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-10 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-15 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-20 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-25 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-30 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-35 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-40 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-45 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-50 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;

	//-55 feet
	if (bAhead == TRUE)
	{
		lThrowLocation = CSLGetAheadLocation(oPC, fDistance);
	}
	else lThrowLocation = CSLGetRandomLocation(oArea, oPC, fDistance);

	if (GetIsLocationValid(lThrowLocation))
	{
		AssignCommand(oTarget, ClearAllActions());
		AssignCommand(oTarget, DelayCommand(0.5f, ActionDoCommand(ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM))));
		AssignCommand(oTarget, JumpToLocation(lThrowLocation));

		if (bRecordLanding == TRUE)
		{
			SetLocalLocation(oPC, "bot9s_landing", lThrowLocation);
		}
	}
	else if ((fDistance - fFive) > 0.0f)
	{
		fDistance -= fFive;
	}
	else return;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns the maximum Dexterity bonus of oArmor.
// This function was written by Elysius, modified by Mithdradates May 3, 2008
// Updated for patch 1.23 by Drammel 8/12/2009.
int CSLGetMaxDexBonus(object oArmor)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetMaxDexBonus Start", GetFirstPC() ); }
	
	int nMaxDexBonus;
	int nArmor;

	if (oArmor == OBJECT_INVALID)
	{
		nArmor = 0; //Prevents the function from shutting down.
	}
	else nArmor = GetArmorRulesType(oArmor);

	string s2da = Get2DAString("armorrulestats", "MAXDEXBONUS", nArmor);

	if (s2da == "")
	{
		nMaxDexBonus = 100;
	}
	else 
	{
		nMaxDexBonus = StringToInt(s2da);
	}
    return nMaxDexBonus;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
//Function to get the dodge and dex AC of a creature.
// This function was written by Mithdradates May 3, 2008.
// GetDodgeAC
int CSLGetDodgeAC(object oCreature=OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetDodgeAC Start", GetFirstPC() ); }
	
	int iAC=0;
	int iACdown=0;
	int iAChaste=0;
	effect eEffect=GetFirstEffect(oCreature);
	while (GetIsEffectValid(eEffect))
	{
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_INCREASE&&GetEffectInteger(eEffect,0)==AC_DODGE_BONUS) iAC+=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_DECREASE&&GetEffectInteger(eEffect,0)==AC_DODGE_BONUS) iAC-=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_HASTE) iAChaste=1;
		eEffect=GetNextEffect(oCreature);
	};
	object oItem=GetItemInSlot(INVENTORY_SLOT_BOOTS,oCreature);
	itemproperty ipProp;
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS) iAC+=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC) iACdown+=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	int i;
	for (i=0; i<NUM_INVENTORY_SLOTS; i++)
	{
		oItem=GetItemInSlot(i,oCreature);
		if (GetIsObjectValid(oItem))
		{		
			ipProp=GetFirstItemProperty(oItem);
			while(GetIsItemPropertyValid(ipProp))
			{
				if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_HASTE) iAChaste=1;
				ipProp=GetNextItemProperty(oItem);
			};
		};
	};
	iAC+=iAChaste;
	if (iAC>20) iAC=20;
	if (iACdown>20) iACdown=20;
	iAC+=GetSkillRank(SKILL_TUMBLE, oCreature, TRUE)/10;
	i=GetAbilityModifier(ABILITY_DEXTERITY, oCreature);
	if (i>CSLGetMaxDexBonus(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))) i=CSLGetMaxDexBonus(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature));
	iAC+=i;
	if (GetHasFeat(FEAT_DODGE,oCreature,TRUE)) iAC++;
	if (GetHasFeat(1082,oCreature,TRUE)) iAC+=4; //FEAT_SVIRFNEBLIN_DODGE
	if (GetHasFeat(1575,oCreature,TRUE)) iAC+=4; //FEAT_IMPROVED_DEFENSE_4
	else if (GetHasFeat(1574,oCreature,TRUE)) iAC+=3; //FEAT_IMPROVED_DEFENSE_3
	else if (GetHasFeat(1573,oCreature,TRUE)) iAC+=2; //FEAT_IMPROVED_DEFENSE_2
	else if (GetHasFeat(1572,oCreature,TRUE)) iAC+=1; //FEAT_IMPROVED_DEFENSE_1
	i=0;
	if (GetHasFeat(FEAT_CANNY_DEFENSE,oCreature,TRUE))
	{
		oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCreature);
		if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))==ARMOR_RANK_NONE&&GetBaseItemType(oItem)!=BASE_ITEM_LARGESHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_SMALLSHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_TOWERSHIELD)
		{
			i=GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
			if (i>GetLevelByClass(CLASS_TYPE_DUELIST,oCreature)) i=GetLevelByClass(CLASS_TYPE_DUELIST,oCreature);
		}
	}
	int j=0;
	if (GetHasFeat(2049,oCreature,TRUE))
	{
		if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))==ARMOR_RANK_NONE)
		{
			j=GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
			if (j>GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE,oCreature)) j=GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE,oCreature);
		}
	}
	if (j>i) iAC+=j;
	else iAC+=i;
	return iAC-iACdown;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Function to get the touch AC of a creature.
// This function was written by Mithdradates May 9, 2008.
int CSLGetTouchAC(object oCreature=OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetTouchAC Start", GetFirstPC() ); }
	
	int iAC=0;
	int iACDeflection=0;
	int iACDefDown=0;
	int iACdown=0;
	int iAChaste=0;
	effect eEffect=GetFirstEffect(oCreature);
	while (GetIsEffectValid(eEffect))
	{
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_INCREASE&&GetEffectInteger(eEffect,0)==AC_DODGE_BONUS) iAC+=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_INCREASE&&GetEffectInteger(eEffect,0)==AC_DEFLECTION_BONUS&&GetEffectInteger(eEffect,1)>iACDeflection) iACDeflection=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_DECREASE&&GetEffectInteger(eEffect,0)==AC_DODGE_BONUS) iAC-=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_AC_DECREASE&&GetEffectInteger(eEffect,0)==AC_DEFLECTION_BONUS&&GetEffectInteger(eEffect,1)>iACDefDown) iACDefDown=GetEffectInteger(eEffect,1);
		if (GetEffectType(eEffect)==EFFECT_TYPE_HASTE) iAChaste=1;
		eEffect=GetNextEffect(oCreature);
	};
	object oItem=GetItemInSlot(INVENTORY_SLOT_BOOTS,oCreature);
	itemproperty ipProp;
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS) iAC+=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC) iACdown+=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_BELT,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_CLOAK,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_HEAD,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_LEFTRING,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCreature);
	if (GetIsObjectValid(oItem))
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCreature);
	if (GetIsObjectValid(oItem)&&GetBaseItemType(oItem)!=BASE_ITEM_LARGESHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_SMALLSHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_TOWERSHIELD)
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oCreature);
	if (GetIsObjectValid(oItem)&&GetBaseItemType(oItem)!=BASE_ITEM_BRACER)
	{		
		ipProp=GetFirstItemProperty(oItem);
		while(GetIsItemPropertyValid(ipProp))
		{
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_AC_BONUS&&GetItemPropertyCostTableValue(ipProp)>iACDeflection) iACDeflection=GetItemPropertyCostTableValue(ipProp);
			if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_DECREASED_AC&&GetItemPropertyCostTableValue(ipProp)>iACDefDown) iACDefDown=GetItemPropertyCostTableValue(ipProp);
			ipProp=GetNextItemProperty(oItem);
		};
	};
	int i;
	for (i=0; i<NUM_INVENTORY_SLOTS; i++)
	{
		oItem=GetItemInSlot(i,oCreature);
		if (GetIsObjectValid(oItem))
		{		
			ipProp=GetFirstItemProperty(oItem);
			while(GetIsItemPropertyValid(ipProp))
			{
				if (GetItemPropertyType(ipProp)==ITEM_PROPERTY_HASTE) iAChaste=1;
				ipProp=GetNextItemProperty(oItem);
			};
		};
	};
	iAC+=iAChaste;
	if (iAC>20) iAC=20;
	if (iACdown>20) iACdown=20;
	iAC+=GetSkillRank(SKILL_TUMBLE, oCreature, TRUE)/10;
	i=GetAbilityModifier(ABILITY_DEXTERITY, oCreature);
	if (i>CSLGetMaxDexBonus(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))) i=CSLGetMaxDexBonus(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature));
	iAC+=i;
	if (GetHasFeat(FEAT_LUCK_OF_HEROES,oCreature,TRUE)) iAC++;
	if (GetHasFeat(FEAT_LUCKY,oCreature,TRUE)) iAC++;
	iAC+=3-GetCreatureSize(oCreature);
	if (GetActionMode(oCreature,ACTION_MODE_COMBAT_EXPERTISE)) iAC+=3;
	if (GetActionMode(oCreature,ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)) iAC+=6;
	if (GetHasFeat(1082,oCreature,TRUE)) iAC+=4; //FEAT_SVIRFNEBLIN_DODGE
	if (GetHasFeat(1575,oCreature,TRUE)) iAC+=4; //FEAT_IMPROVED_DEFENSE_4
	else if (GetHasFeat(1574,oCreature,TRUE)) iAC+=3; //FEAT_IMPROVED_DEFENSE_3
	else if (GetHasFeat(1573,oCreature,TRUE)) iAC+=2; //FEAT_IMPROVED_DEFENSE_2
	else if (GetHasFeat(1572,oCreature,TRUE)) iAC+=1; //FEAT_IMPROVED_DEFENSE_1
	i=0;
	if (GetHasFeat(FEAT_CANNY_DEFENSE,oCreature,TRUE))
	{
		oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oCreature);
		if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))==ARMOR_RANK_NONE&&GetBaseItemType(oItem)!=BASE_ITEM_LARGESHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_SMALLSHIELD&&GetBaseItemType(oItem)!=BASE_ITEM_TOWERSHIELD)
		{
			i=GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
			if (i>GetLevelByClass(CLASS_TYPE_DUELIST,oCreature)) i=GetLevelByClass(CLASS_TYPE_DUELIST,oCreature);
		}
	}
	int j=0;
	if (GetHasFeat(2049,oCreature,TRUE)) //FEAT_UNFETTERED_DEFENSE
	{
		if (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST,oCreature))==ARMOR_RANK_NONE)
		{
			j=GetAbilityModifier(ABILITY_INTELLIGENCE, oCreature);
			if (j>GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE,oCreature)) j=GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE,oCreature);
		}
	}

	if (GetIsInCombat(oCreature))
	{
		object oFoe = GetLastAttacker(oCreature);
		object oTarget = GetAttackTarget(oCreature);
		object oChest = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
		int nArmor = GetArmorRank(oChest);
		int nSwash = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oCreature);

		if ((nSwash > 0) && (oFoe == oTarget) && (nArmor <= ARMOR_RANK_LIGHT))
		{
			if (nSwash >= 30) // Swashbuckler's Dodge +6
			{
				iAC += 6;
			}
			else if (nSwash >= 25)  // Swashbuckler's Dodge +5
			{
				iAC += 5;
			}
			else if (nSwash >= 20)  // Swashbuckler's Dodge +4
			{
				iAC += 4;
			}
			else if (nSwash >= 15)  // Swashbuckler's Dodge +3
			{
				iAC += 3;
			}
			else if (nSwash >= 10)  // Swashbuckler's Dodge +2
			{
				iAC += 2;
			}
			else if (nSwash >= 5)  // Swashbuckler's Dodge +1
			{
				iAC += 1;
			}
		}
		
		if (GetHasFeat(FEAT_DODGE, oCreature, TRUE) && (oFoe == oTarget))
		{
			iAC += 1;
		}
	}

	if (j>i) iAC+=j;
	else iAC+=i;
	return iAC-iACdown+10+iACDeflection-iACDefDown;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns a creature's Flat Footed AC value.  This value is equal to the forumla:
// Flat-footed AC = AC - Dex bonus - dodge bonuses.  It usually applies when a
// creature is ambushed or suprised.
int CSLGetFlatFootedAC(object oCreature)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetFlatFootedAC Start", GetFirstPC() ); }
	
	int nTotalAC = GetAC(oCreature);
	int nDodgeAC = CSLGetDodgeAC(oCreature);  //Includes the Dex mod in the calculation.
	int nFlatFootAC = nTotalAC - nDodgeAC;

	return nFlatFootAC;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns TRUE if oTarget is flat-footed.
int CSLGetIsFlatFooted(object oTarget)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetIsFlatFooted Start", GetFirstPC() ); }
	
	if (GetHasFeat(FEAT_UNCANNY_DODGE, oTarget))
	{
		return FALSE;
	}
	else if (GetLocalInt(oTarget, "OverrideFlatFootedAC") == 1)
	{
		return TRUE;
	}
	else if (!GetIsInCombat(oTarget))
	{
		return TRUE;
	}
	else return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
//Returns if oTarget is in fRange of oCreature
//Returns TRUE or FALSE
int CSLGetIsInMeleeRange(object oTarget, object oCreature)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetIsInMeleeRange Start", GetFirstPC() ); }
	
	float fRange = CSLGetMeleeRange(oTarget);
		
	if (GetDistanceBetween(oCreature, oTarget) <= fRange)
	{
		return TRUE;
	}
	else return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
//Returns the first enemy of oCreature in fRange
// * Returns OBJECT_INVALID if no enemy is found
object CSLGetFirstEnemyInMeleeRange(object oCreature)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetFirstEnemyInMeleeRange Start", GetFirstPC() ); }
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oCreature));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCreature) && !GetIsDead(oTarget))
		{
			if(CSLGetIsInMeleeRange(oTarget, oCreature))
			{
				return oTarget;
				break;
			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oCreature));
	}
	
	return OBJECT_INVALID;
}




/**  
* @author
* @param 
* @see 
* @return 
*/
//Function to get the AB of the object oCreature
int CSLGetMaxAB(object oCreature, object oWeapon, object oTarget)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLGetMaxAB Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oCreature);

	object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
	object oOffHand;

	if ((oLeft == OBJECT_INVALID) && (!GetIsPlayableRacialType(oCreature)))
	{
		oOffHand = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);
	}
	else oOffHand = oLeft;

	int iAB = GetBaseAttackBonus(oCreature);
	int iAttackDecrease = 0;
	int nWeapon = GetBaseItemType(oWeapon);

	int nWFFeat = CSLGetItemDataPrefFeatWeaponFocus( nWeapon);
	int nGWFFeat = CSLGetItemDataPrefFeatGreaterWeaponFocus(nWeapon);
	int nEWFFeat = CSLGetItemDataPrefFeatEpicWeaponFocus(nWeapon);
	int nWoCFeat = CSLGetItemDataPrefFeatWeaponOfChoice(nWeapon);

	// Flanking Bonuses

	if (CSLIsFlankValid(oCreature, oTarget) == TRUE)
	{
		iAB += 2;
		
		if (GetHasFeat(FEAT_TW_SUPERIOR_FLANK, oCreature) == TRUE)
		{
			iAB += 2;
		}
		
		if (GetHasFeat(2142, oCreature) == TRUE) // Improved Flanking
		{
			iAB +=2;
		}
	}
	
	// Add ability modifier
	if (GetWeaponRanged(oWeapon))
	{
		if (GetHasFeat(FEAT_ZEN_ARCHERY, oCreature, TRUE) && GetAbilityModifier(ABILITY_WISDOM, oCreature) > GetAbilityModifier(ABILITY_DEXTERITY, oCreature))
		{	
			iAB = iAB + GetAbilityModifier(ABILITY_WISDOM, oCreature);
		}
		else iAB = iAB + GetAbilityModifier(ABILITY_DEXTERITY, oCreature);
		
		if ((GetDistanceToObject(oTarget) < FeetToMeters(15.0f)) && (GetHasFeat(FEAT_POINT_BLANK_SHOT, oCreature) == FALSE))
		{
			iAttackDecrease += 4;
		}
	}
	else 
	{
		if (GetHasFeat(FEAT_WEAPON_FINESSE, oCreature, TRUE) && GetAbilityModifier(ABILITY_DEXTERITY,oCreature) > GetAbilityModifier(ABILITY_STRENGTH, oCreature) && (CSLItemGetWeaponSize(oCreature)<=WEAPON_SIZE_SMALL || nWeapon == BASE_ITEM_RAPIER || nWeapon == BASE_ITEM_RAPIER_R))
		{
			iAB = iAB + GetAbilityModifier(ABILITY_DEXTERITY,oCreature);
		}
		else iAB=iAB+GetAbilityModifier(ABILITY_STRENGTH, oCreature);
	}
	
	// Add weapon size and dual wielding effects
	if (GetIsObjectValid(oOffHand) && CSLItemGetWeaponSize(oCreature) > GetCreatureSize(oCreature) || CSLItemGetWeaponSize(oCreature) > GetCreatureSize(oCreature)+1) iAB=iAB-2;
	if (GetIsObjectValid(oOffHand) && GetBaseItemType(oOffHand)!= BASE_ITEM_SMALLSHIELD && GetBaseItemType(oOffHand)!= BASE_ITEM_LARGESHIELD)
	{
		if (GetBaseItemType(oOffHand) == BASE_ITEM_TOWERSHIELD) iAB=iAB-2;

		if (oWeapon == oOffHand)// Checking for the Offhand weapon.
		{
			if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE))
			{
				iAB=iAB-0;
			}
			else if (GetLocalInt(oToB, "Strike") == 185) // Wolf Fang Strike
			{
				iAB=iAB-2;
			}
			else if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oCreature, TRUE) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_TWO_WEAPON_FIGHTING, oCreature, TRUE)) 
			{
				if (CSLItemGetWeaponSize(oOffHand) < GetCreatureSize(oCreature)) iAB=iAB-2;
				else iAB=iAB-4;
			}
			else 
			{
				if (CSLItemGetWeaponSize(oOffHand) < GetCreatureSize(oCreature)) iAB=iAB-8;
			 	else iAB=iAB-10;
			}
		}
		else // Checking for the Onhand weapon.
		{
			if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE))
			{
				iAB=iAB-0;
			}
			else if (GetLocalInt(oToB, "Strike") == 185) // Wolf Fang Strike
			{
				iAB=iAB-2;
			}
			else if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oCreature, TRUE) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_TWO_WEAPON_FIGHTING, oCreature, TRUE)) 
			{
				if (CSLItemGetWeaponSize(oOffHand) < GetCreatureSize(oCreature)) iAB=iAB-2;
				else iAB=iAB-4;
			}
			else 
			{
				if (CSLItemGetWeaponSize(oOffHand) < GetCreatureSize(oCreature)) iAB=iAB-4;
			 	else iAB=iAB-6;
			}
		}
	}
	
	// Weapon feat effects

	if (nWeapon == BASE_ITEM_LONGBOW)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_LONGBOW, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LONGBOW, oCreature, TRUE)) iAB=iAB+2;
		if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_5, oCreature, TRUE)) iAB=iAB+5;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_4, oCreature, TRUE)) iAB=iAB+4;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_3, oCreature, TRUE)) iAB=iAB+3;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_2, oCreature, TRUE)) iAB=iAB+2;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_1, oCreature, TRUE)) iAB=iAB+1;		
	}
	else if (nWeapon == BASE_ITEM_SHORTBOW)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_SHORTBOW, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHORTBOW, oCreature, TRUE)) iAB=iAB+2;	
		if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_5, oCreature, TRUE)) iAB=iAB+5;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_4, oCreature, TRUE)) iAB=iAB+4;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_3, oCreature, TRUE)) iAB=iAB+3;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_2, oCreature, TRUE)) iAB=iAB+2;
		else if (GetHasFeat(FEAT_PRESTIGE_ENCHANT_ARROW_1, oCreature, TRUE)) iAB=iAB+1;
	}
	else if (nWeapon == BASE_ITEM_SHURIKEN)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_SHURIKEN, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SHURIKEN, oCreature, TRUE)) iAB=iAB+2;
		if (GetHasFeat(FEAT_GOOD_AIM, oCreature, TRUE)) iAB=iAB+1;	
	}
	else if (nWeapon == BASE_ITEM_SLING)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_SLING, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_SLING, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_SLING, oCreature, TRUE)) iAB=iAB+2;	
		if (GetHasFeat(FEAT_GOOD_AIM, oCreature, TRUE)) iAB=iAB+1;
	}
	else if (nWeapon == BASE_ITEM_THROWINGAXE)
	{	
		if (GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_THROWINGAXE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE, oCreature, TRUE)) iAB=iAB+2;	
		if (GetHasFeat(FEAT_GOOD_AIM, oCreature, TRUE)) iAB=iAB+1;
	}
	else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature)))
	{
		if (GetHasFeat(nWFFeat, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(nGWFFeat, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(nEWFFeat, oCreature, TRUE)) iAB=iAB+2;
		if (GetHasFeat(nWoCFeat, oCreature, TRUE) && GetHasFeat(FEAT_SUPERIOR_WEAPON_FOCUS, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(nWoCFeat, oCreature, TRUE) && GetHasFeat(FEAT_EPIC_SUPERIOR_WEAPON_FOCUS, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(nWoCFeat, oCreature, TRUE) && GetHasFeat(FEAT_EPIC_SUPERIOR_WEAPON_FOCUS, oCreature, TRUE) && (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER) > 15)) iAB=iAB+1;
		if (GetHasFeat(nWoCFeat, oCreature, TRUE) && GetHasFeat(FEAT_EPIC_SUPERIOR_WEAPON_FOCUS, oCreature, TRUE) && (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER) > 18)) iAB=iAB+1;
	}
	else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature))||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oCreature))||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oCreature)))
	{
		if (GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_CREATURE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CREATURE, oCreature, TRUE)) iAB=iAB+2;
	
		oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
			
		if (GetIsObjectValid(oWeapon)==FALSE) oWeapon=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oCreature);
		if (GetIsObjectValid(oWeapon)==FALSE) oWeapon=GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oCreature);	
	}
	else
	{
		if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_UNARMED, oCreature, TRUE)) iAB=iAB+1;
		if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED, oCreature, TRUE)) iAB=iAB+2;	
	}

	
	if ((CSLGetIsFavoredEnemy(oCreature, oTarget)) && (GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES, oCreature)))
	{
		iAB += 2;
	}
	
	if (GetHasFeat(FEAT_EPIC_PROWESS, oCreature))
	{
		iAB += 1;
	}
	
	if ((GetHasFeat(2103, oCreature)) && (nWeapon != OBJECT_TYPE_INVALID)) // Sarced Fist Code of Conduct
	{
		iAttackDecrease += 8;
	}
	
	// Mode Effects
	
	if (GetActionMode(oCreature, ACTION_MODE_POWER_ATTACK))
	{
		 iAttackDecrease += 3;
	}
	else if (GetActionMode(oCreature, ACTION_MODE_IMPROVED_POWER_ATTACK))
	{
		iAttackDecrease += 6;
	}
	
	if (GetActionMode(oCreature, ACTION_MODE_COMBAT_EXPERTISE))
	{
		 iAttackDecrease += 3;
	}
	else if (GetActionMode(oCreature, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE))
	{
		iAttackDecrease += 6;
	}
	
	if (GetActionMode(oCreature, ACTION_MODE_FLURRY_OF_BLOWS))
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK)) + (GetLevelByClass(CLASS_TYPE_SACREDFIST)) < 5)
		{
			iAttackDecrease += 2;
		}
		else if ((GetLevelByClass(CLASS_TYPE_MONK)) + (GetLevelByClass(CLASS_TYPE_SACREDFIST)) < 10)
		{
			iAttackDecrease += 1;
		}
	}
	

	if (GetActionMode(oCreature, ACTION_MODE_RAPID_SHOT))
	{
		if (GetHasFeat(FEAT_IMPROVED_RAPID_SHOT))
		{
			iAttackDecrease += 0;
		}
		else iAttackDecrease += 2;
	}
	
	if (GetLocalInt(oToB, "SnapKick") == 1)
	{
		iAttackDecrease += 2;
	}

	// Misc Effects and Enchantment
	
	int iWeaponEnhancement = 0;
	itemproperty ipAB = GetFirstItemProperty(oWeapon);
	
	while (GetIsItemPropertyValid(ipAB))
	{
		if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_ENHANCEMENT_BONUS || GetItemPropertyType(ipAB) == ITEM_PROPERTY_ATTACK_BONUS)
		{
			iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(ipAB);
		}
		else if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP || GetItemPropertyType(ipAB) == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP)
		{
			int nGoodEvil = GetAlignmentGoodEvil(oTarget);
			int nLawChaos = GetAlignmentLawChaos(oTarget);
			
			if ((GetItemPropertySubType(ipAB) == nGoodEvil) || (GetItemPropertySubType(ipAB) == nLawChaos))
			{
				iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(ipAB);
			}
		}
		else if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP || GetItemPropertyType(ipAB) == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)
		{
			int nTargetRace = GetRacialType(oTarget);
			
			if (GetItemPropertySubType(ipAB) == nTargetRace)
			{
				iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(ipAB);
			}
		}
		else if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT || GetItemPropertyType(ipAB) == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)
		{
			int nAlignment = CSLGetCreatureAlignment(oTarget);
			
			if (GetItemPropertySubType(ipAB) == nAlignment)
			{
				iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(ipAB);
			}
		}
		else if (GetItemPropertyType(ipAB) == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER || GetItemPropertyType(ipAB) == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)
		{
			iAttackDecrease = iAttackDecrease + GetItemPropertyCostTableValue(ipAB);
		}	
		ipAB=GetNextItemProperty(oWeapon);
	}
	
	if (!GetIsObjectValid(oWeapon)) // love for monks
	{
		object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS);
		itemproperty iArm = GetFirstItemProperty(oArms);
		
		while (GetIsItemPropertyValid(iArm))
		{
			if (GetItemPropertyType(iArm) == ITEM_PROPERTY_ATTACK_BONUS)
			{
				iWeaponEnhancement = iWeaponEnhancement + GetItemPropertyCostTableValue(iArm);
			}
			else if (GetItemPropertyType(iArm) == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)
			{
				iAttackDecrease = iAttackDecrease + GetItemPropertyCostTableValue(iArm);
			}
			iArm = GetNextItemProperty(oArms);
		}
	}
	
	effect eAB = GetFirstEffect(oCreature);
	while (GetIsEffectValid(eAB))
	{
		if (GetEffectType(eAB) == EFFECT_TYPE_ATTACK_INCREASE)
		{
			iWeaponEnhancement = iWeaponEnhancement + GetEffectInteger(eAB, 0);
		}
		else if (GetEffectType(eAB) == EFFECT_TYPE_ATTACK_DECREASE)
		{
			iAttackDecrease = iAttackDecrease + GetEffectInteger(eAB, 0);
		}	
		eAB = GetNextEffect(oCreature);
	}

	iAB = iAB + iWeaponEnhancement - iAttackDecrease;
	return iAB;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Overrides the number used in the calculation of the Target's AC value.
// -oTarget: The creature that we're determining AC for.
// -nType: 1 = Touch AC, 2 = Flat Footed AC, 3 = Specific AC.
// -nAC: Only valid when nType is equal to 3.  Allows you to set the AC to any number.
void CSLOverrideAttackRollAC(object oTarget, int nType, int nAC = 0)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLOverrideAttackRollAC Start", GetFirstPC() ); }
	
	if (nType == 1)
	{
		SetLocalInt(oTarget, "OverrideTouchAC", 1);
	}
	else if (nType == 2)
	{
		SetLocalInt(oTarget, "OverrideFlatFootedAC", 1);
	}
	else if (nType == 3)
	{
		SetLocalInt(oTarget, "OverrideAC", nAC);
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Overrides the D20 roll component of the attack roll.
// -nNumber: Value of the roll.  Can actually be above 20 if you really want to.
void CSLOverrideD20Roll(object oTarget, int nNumber)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLOverrideD20Roll Start", GetFirstPC() ); }
	
	SetLocalInt(oTarget, "OverrideD20", 1);
	SetLocalInt(oTarget, "D20OverrideNum", nNumber);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Overrides the critical confirmantion roll's result.
// -nNumber: Value of the roll.  Can actually be above 20 if you really want to.
// -bVS: When set to true a creature using a strike against oTarget will gain a
// bonus of nNumber to the critical confirmation roll.  Otherwise, this function
// treats nNumber as the exact number of the critical confirmation roll that
// oTarget makes.
void CSLOverrideCritConfirmRoll(object oTarget, int nNumber, int bVS = FALSE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLOverrideCritConfirmRoll Start", GetFirstPC() ); }
	
	if (bVS == FALSE)
	{
		SetLocalInt(oTarget, "OverrideCritConfirm", 1);
	}
	else SetLocalInt(oTarget, "OverrideCritConfirm", 2);

	SetLocalInt(oTarget, "CCOverrideNum", nNumber);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Overrides the player's attack bonus.
// -nNumber: Value of the bonus.
void CSLOverrideAttackBonus(object oTarget, int nNumber)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLOverrideAttackBonus Start", GetFirstPC() ); }
	
	SetLocalInt(oTarget, "OverrideAttackBonus", 1);
	SetLocalInt(oTarget, "ABOverrideNum", nNumber);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Overrides the player's weapon's critical range.
// -nNumber: Value of the minimum range.
void CSLOverrideCritRange(object oTarget, int nNumber)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLOverrideCritRange Start", GetFirstPC() ); }
	
	SetLocalInt(oTarget, "OverrideCritRange", 1);
	SetLocalInt(oTarget, "CROverrideNum", nNumber);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Overrides the player's bonus to the critical confirmation roll.
// -nNumber: Value of the bonus.
void CSLOverrideCritConfirmationBonus(object oTarget, int nNumber)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLOverrideCritConfirmationBonus Start", GetFirstPC() ); }
	
	SetLocalInt(oTarget, "OverrideCritConfirmBonus", 1);
	SetLocalInt(oTarget, "CCBOverrideNum", nNumber);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Overrides the result of the attack roll.
// -nNumber: 0 = Miss, 1 = Hit, 2 = Critical Hit.
void CSLOverrideHit(object oTarget, int nNumber)
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLOverrideHit Start", GetFirstPC() ); }
	
	SetLocalInt(oTarget, "OverrideHit", 1);
	SetLocalInt(oTarget, "HitOverrideNum", nNumber);
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// Plays a sound based on the results of TOBStrikeAttackRoll.
// -oWeapon: Weapon in right or left hand.
// -oTarget: Creature where we want to play the hit or miss sound.
// -nHit: Either a miss, hit, or critical hit. 0, 1, or 2.
// -fDelay: Amount of time to delay the sound effect by.  There is a minimum 0.1 delay while the sound 
// creature is created.
// -nAttackCry: Plays the character's attacking grunt sound while set to TRUE.
// -sOverride: For a valid sound creature's tag, this will use that creature's sfx instead of the normal sfx.
//	Set it to FALSE if you wish to use another sound or none at all when attacking.
void CSLStrikeAttackSound(object oWeapon, object oTarget, int nHit, float fDelay = 0.0f, int bAttackCry = TRUE, string sOverride = "" )
{
	if (DEBUGGING >= 7) { CSLDebug(  "CSLStrikeAttackSound Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	location lTarget = GetLocation(oTarget);
	string sNinja;// Name of the creature to create, which plays the sound.
	
	if ((bAttackCry == TRUE) && (GetIsPC(oPC)))
	{
		int nD3 = d3(1);
	
		switch (nD3)
		{
			case 1: PlayVoiceChat(VOICE_CHAT_GATTACK1, oPC); break;
			case 2: PlayVoiceChat(VOICE_CHAT_GATTACK2, oPC); break;
			case 3: PlayVoiceChat(VOICE_CHAT_GATTACK3, oPC); break;
		}
	}

	if (nHit > 0)
	{
		DelayCommand(fDelay + 0.1f, StrikeItemPropSound(oWeapon, oTarget));
	}

	if (sOverride != "")
	{
		sNinja = sOverride;
	}
	else sNinja = SoundNinja(oWeapon, oTarget, nHit);

	DelayCommand(fDelay, CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, sNinja, lTarget));
}






/*
///////////////////////////////////////////////////////////////////////////////
// SetCombatOverrides / ClearCombatOverrides
///////////////////////////////////////////////////////////////////////////////
// Created By:  Brock Heinz - OEI
// Created On:  02/02/06
// Description: This is a basic way to force a specific outcome during a 
//              creature's combat round. This is primarily designed as a
//              cutscene aid, and is not intended for use on creatures
//              with whom the player can normally interact. Therefore, these
//              settings are not saved. 
//              ClearCombatOverrides() should be called on the creature when 
//              the cutscene is complete. 
// Arguments:
// oCreature - The creature to set the overrides on. 
// oTarget - This should be a creature, door, or placeable.  
//      Passing in INVALID_OBJECT Will allow normal target selection to occur.
// nAttackResult - An attack can have one of many different outcomes.
//  You can force the attack results to be a specific outcome, or specify 
//  "INVALID" to allow the normal attack rolls to occur.
// nOnHandAttacks, nOffHandAttacks
//  Creaturs must have a total of 1-6 attacks per round. Entering -1 for either of 
//  these means that the default logic will be used to determine attacks per 
//  round for that hand. 
// nMinDamage, nMaxDamage
//  These are used to set the range for a random damage amount. For example, 
//  (1,6) would mean that 1-6 points of damage would be done. These can be set 
//  to the same value, and you can specify 0,0 for "no damage". Using -1 for 
//  either of these means that the default damage calculations will be used. 
// bSuppressBroadcastAOO -  If TRUE then this creature can potentially cause an 
//  attack of opportunity from nearby creatures. If FALSE, this will be supressed
// bSuppressMakeAOO -  If TRUE then this creature will make attacks of 
//  opportunity when they are available. If FALSE, this will be supressed
// bIgnoreTargetReaction -  Normally, ActionAttack() calls are rejected if they 
//  are made on a hostile or neutral target. Setting this to TRUE 
//  will bypass that check. 
// bSuppressFeedbackText - If set to TRUE, this can be used to keep this 
//  creature's combat round feedback from being displayed.
///////////////////////////////////////////////////////////////////////////////
void SetCombatOverrides( object oCreature, object oTarget, int nOnHandAttacks, int nOffHandAttacks, int nAttackResult, int nMinDamage, int nMaxDamage, int bSuppressBroadcastAOO, int bSuppressMakeAOO, int bIgnoreTargetReaction, int bSuppressFeedbackText );
void ClearCombatOverrides( object oCreature );



*/

/** @file
* @brief Include File for Doors and door related spells
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_HkSpell"
#include "_CSLCore_Position"
#include "_CSLCore_Visuals"

#include "_CSLCore_Reputation"

#include "_CSLCore_Position"

/*
// prototypes
void ApplyArcaneLock( object oDoor, object oCaster = OBJECT_SELF );
void SCOpenArcaneLock( object oDoor, object oOpeningChar );
void SCRemoveArcaneLock( object oDoor, int iFollowChildren = TRUE );
void SCKnockArcaneLockRemove( object oDoor );
void SCKnockArcaneLock( object oDoor );
int SCIsArcaneLocked( object oDoor );
int SCAttemptKnockSpell(object oLocked);
void SCHandleBlockedDoor( object oDoor, object oChar);
int SCGetIsDoorInLineOfSight(object oTarget);
float CSLGetCosAngleBetween(object Loc1, object Loc2);
*/



// * attempts to disarm last trap (called from SCRespondToShout and heartbeat
int SCAttemptToDisarmTrap(object oTrap, int bWasShout = FALSE)
{
    //MyPrintString("Attempting to disarm: " + GetTag(oTrap));

    // * May 2003: Don't try to disarm a trap with no trap
    if (GetIsTrapped(oTrap) == FALSE)
    {
        return FALSE;
    }

    // * June 2003. If in 'do not disarm trap' mode, then do not disarm traps
    if(!CSLGetAssociateState(CSL_ASC_DISARM_TRAPS))
    {
        return FALSE;
    }


    int bValid = GetIsObjectValid(oTrap);
    int bISawTrap = GetTrapDetectedBy(oTrap, OBJECT_SELF);
    int bCloseEnough = GetDistanceToObject(oTrap) <= 15.0;
    int bInLineOfSight = CSLGetIsInLineOfSight(oTrap);


    if(bValid == FALSE || bISawTrap == FALSE || bCloseEnough == FALSE || bInLineOfSight == FALSE)
    {
        //MyPrintString("Failed basic disarm check");
        if (bWasShout == TRUE)
            SCVoiceCannotDo();
        return FALSE;
    }

    //object oTrapSaved = GetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_TRAP");
    SetLocalObject(OBJECT_SELF, "NW_ASSOCIATES_LAST_TRAP", oTrap);
    // We can tell we can't do it
        string sID = ObjectToString(oTrap);
    int nSkill = GetSkillRank(SKILL_DISABLE_TRAP);
    int nTrapDC = GetTrapDisarmDC(oTrap);
    if ( nSkill > 0 && (nSkill  + 20) >= nTrapDC && GetTrapDisarmable(oTrap)) {
        ClearAllActions();
        if (ActionUseSkill(SKILL_DISABLE_TRAP, oTrap))
		{
			// ChazM 8/31/06 - Don't turn off commandability - players should always be able to control companions.
			// Also, this can get stuck if the trap is unreachable.
        	//ActionDoCommand(SetCommandable(TRUE));
        	ActionDoCommand(SCVoiceTaskComplete());
        	//SetCommandable(FALSE);
        	return TRUE;
		}
		else
		{
			// action can't be put on queue - probably can't path
       		return FALSE;
		}
    } 
	
	if (GetHasSpell(SPELL_FIND_TRAPS) && GetTrapDisarmable(oTrap) && GetLocalInt(oTrap, "NW_L_IATTEMPTEDTODISARMNOWORK") ==0)
    {
       // SpeakString("casting");
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_FIND_TRAPS, oTrap);
        SetLocalInt(oTrap, "NW_L_IATTEMPTEDTODISARMNOWORK", 10);
        return TRUE;
    }
	
    // MODIFIED February 7 2003. Merged the 'attack object' inside of the bshout
    // this is not really something you want the henchmen just to go and do
    // spontaneously
    if (bWasShout)
    {
        ClearAllActions();

        //SpeakStringByStrRef(40551); // * Out of game indicator that this trap can never be disarmed by henchman.
        if  (GetLocalInt(OBJECT_SELF, "X0_L_SAWTHISTRAPALREADY" + sID) != 10)
        {
            string sSpeak = GetStringByStrRef(40551);
            SendMessageToPC(CSLGetCurrentMaster(), sSpeak);
            SetLocalInt(OBJECT_SELF, "X0_L_SAWTHISTRAPALREADY" + sID, 10);
        }
        if (GetObjectType(oTrap) != OBJECT_TYPE_TRIGGER)
        {
            // * because Henchmen are not allowed to switch weapons without the player's
            // * say this needs to be removed
            // it's an object we can destroy ranged
            // ActionEquipMostDamagingRanged(oTrap);
            ActionAttack(oTrap);
            SetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH", oTrap);
            return TRUE;
        }

        // Throw ourselves on it nobly! :-)
       	ActionMoveToLocation(GetLocation(oTrap));
        SetFacingPoint(GetPositionFromLocation(GetLocation(oTrap)));
        ActionRandomWalk();
        return TRUE;
    }
	
    if (nSkill > 0)
    {

        // * BK Feb 6 2003
        // * Put a check in so that when a henchmen who cannot disarm a trap
        // * sees a trap they do not repeat their voiceover forever
        if  (GetLocalInt(OBJECT_SELF, "X0_L_SAWTHISTRAPALREADY" + sID) != 10)
        {
            SCVoiceCannotDo();
            SetLocalInt(OBJECT_SELF, "X0_L_SAWTHISTRAPALREADY" + sID, 10);
           string sSpeak = GetStringByStrRef(40551);
           SendMessageToPC(CSLGetCurrentMaster(), sSpeak);
        }

        return FALSE;
    }

    return FALSE;
}


//Pausanias: Is there a closed door in the line of sight.
// * is door in line of sight
int SCGetIsDoorInLineOfSight(object oTarget)
{
    float fMeDoorDist;

    object oView = GetFirstObjectInShape(SHAPE_SPHERE, 40.0, GetLocation(OBJECT_SELF), TRUE,OBJECT_TYPE_DOOR);

    float fMeTrapDist = GetDistanceBetween( oTarget, OBJECT_SELF);

    while (GetIsObjectValid(oView))
    {
		fMeDoorDist = GetDistanceBetween(oView,OBJECT_SELF);
        //SpeakString("Trap3 : "+FloatToString(fMeTrapDist)+" "+FloatToString(fMeDoorDist));
        if (fMeDoorDist < fMeTrapDist && !GetIsTrapped(oView))
        {
            if (GetIsDoorActionPossible(oView,DOOR_ACTION_OPEN) || GetIsDoorActionPossible(oView,DOOR_ACTION_UNLOCK))
            {
                float fAngle = CSLGetCosAngleBetween(oView,oTarget);
                //SpeakString("Angle: "+FloatToString(fAngle));
                if (fAngle > 0.5)
                {
                    // if (d10() > 7)
                    // SpeakString("There's something fishy near that door...");
                    return TRUE;
                }
            }
		}
        oView = GetNextObjectInShape(SHAPE_SPHERE,40.0, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_DOOR);
    }

    //SpeakString("No matches found");
    return FALSE;
}

int SCIsArcaneLocked( object oDoor )
{
	if ( GetLocalString(oDoor, "SC_ARCANELOCK_CASTERTAG" ) != "" )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


//* attempts to cast knock to open the door
int SCAttemptKnockSpell(object oDoor)
{
    // If that didn't work, let's try using a knock spell
    if (GetHasSpell(SPELL_KNOCK)
        && ( GetIsDoorActionPossible(oDoor, DOOR_ACTION_KNOCK) || SCIsArcaneLocked( oDoor ) || GetIsPlaceableObjectActionPossible(oDoor, PLACEABLE_ACTION_KNOCK)))
    {
        if (SCGetIsDoorInLineOfSight(oDoor) == FALSE)
        {
            // For whatever reason, GetObjectSeen doesn't return seen doors.
            //if (GetObjectSeen(oLocked))
            if (LineOfSightObject(OBJECT_SELF, oDoor) == TRUE)
            {
                ClearAllActions(FALSE);
                ClearAllActions();
                SCVoiceCanDo();
                ActionWait(1.0);
                ActionCastSpellAtObject(SPELL_KNOCK, oDoor);
                ActionWait(1.0);
                return TRUE;
            }
        }

    }
    return FALSE;
}


// * Attempt to open a given locked object.
int SCAttemptToOpenLock(object oLocked)
{

    // * September 2003
    // * if door is set to not be something
    // * henchmen should bash open  (like mind flayer beds)
    // * then ignore it.
    if (GetLocalInt(oLocked, "X2_L_BASH_FALSE") == 1)
    {
        return FALSE;
    }
    int bNeedKey = FALSE;
    int bInLineOfSight = TRUE;

    if (GetLockKeyRequired(oLocked) == TRUE)
    {
        bNeedKey = TRUE ;
    }

    // * October 17 2003 - BK - Decided that line of sight for doors is not relevant
    // * was causing too many errors.
    //if (CSLGetIsInLineOfSight(oLocked) == FALSE)
    //{
    //    bInLineOfSight = TRUE;
   // }
    if ( !GetIsObjectValid(oLocked)
         || bNeedKey == TRUE
         || bInLineOfSight == FALSE )
         //|| GetObjectSeen(oLocked) == FALSE) This check doesn't work.
         {
        // Can't open this, so skip the checks
        //MyPrintString("Failed basic check");
        SCVoiceCannotDo();
        return FALSE;
    }

    // We might be able to open this

    int bCanDo = FALSE;

    // First, let's see if we notice that it's trapped
    if (GetIsTrapped(oLocked) && GetTrapDetectedBy(oLocked, OBJECT_SELF))
    {
        // Ick! Try and disarm the trap first
        //MyPrintString("Trap on it to disarm");
        if (! SCAttemptToDisarmTrap(oLocked))
        {
            // * Feb 11 2003. Attempt to cast knock because its
            // * always safe to cast it, even on a trapped object
            if (SCAttemptKnockSpell(oLocked) == TRUE)
            {
                return TRUE;
            }
            //SCVoicePicklock();
            SCVoiceNo();
            return FALSE;
        }
    }

    // Now, let's try and pick the lock first
    int nSkill = GetSkillRank(SKILL_OPEN_LOCK);
    if (nSkill > 0) {
        nSkill += GetAbilityModifier(ABILITY_DEXTERITY);
        nSkill += 20;
    }

    if (nSkill > GetLockUnlockDC(oLocked)
        &&
        (GetIsDoorActionPossible(oLocked,
                                 DOOR_ACTION_UNLOCK)
         || GetIsPlaceableObjectActionPossible(oLocked,
                                               PLACEABLE_ACTION_UNLOCK))) {
        ClearAllActions();
        SCVoiceCanDo();
        ActionWait(1.0);
        ActionUseSkill(SKILL_OPEN_LOCK,oLocked);
        ActionWait(1.0);
        bCanDo = TRUE;
    }

    if (!bCanDo)
        bCanDo = SCAttemptKnockSpell(oLocked);


    if (!bCanDo
        //&& GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH) >= 16 Removed since you now have control over their bashing via dialog
        && !GetPlotFlag(oLocked)
        && (GetIsDoorActionPossible(oLocked,
                                    DOOR_ACTION_BASH)
            || GetIsPlaceableObjectActionPossible(oLocked,
                                                  PLACEABLE_ACTION_BASH))) {
        ClearAllActions();
        SCVoiceCanDo();
        ActionWait(1.0);

        // MODIFIED February 2003
        // Since the player has direct control over weapon, automatic equipping is frustrating.
        // removed.
        //        ActionEquipMostDamagingMelee(oLocked);
        ActionAttack(oLocked);
        SetLocalObject(OBJECT_SELF, "NW_GENERIC_DOOR_TO_BASH", oLocked);
        bCanDo = TRUE;
    }

    if (!bCanDo && !GetPlotFlag(oLocked) && GetHasSpell(SPELL_MAGIC_MISSILE))
    {
        ClearAllActions();
        ActionCastSpellAtObject(SPELL_MAGIC_MISSILE,oLocked);
        return TRUE;
    }

    // If we did it, let the player know
    if(!bCanDo) {
        SCVoiceCannotDo();
    } else {
        ActionDoCommand(SCVoiceTaskComplete());
        return TRUE;
    }

    return FALSE;
}


void SCRemoveArcaneLock( object oDoor, int iFollowChildren = TRUE )
{
	// put things back how they were
	SetHardness( GetLocalInt(oDoor, "SC_ARCANELOCK_HARDNESS"),  oDoor );
	SetEventHandler(oDoor, SCRIPT_DOOR_ON_OPEN, GetLocalString(oDoor, "SC_ARCANELOCK_OLDONOPEN" ) );
	DeleteLocalString( oDoor, "SC_ARCANELOCK_OLDONOPEN");
	
	DeleteLocalInt(oDoor, "SC_ARCANELOCK_HARDNESS" );
	//SetLocalInt(oDoor, "SC_ARCANELOCK_LOCKED", GetLocked( oDoor ) );
	DeleteLocalInt(oDoor, "SC_ARCANELOCK_CASTERPOINTER" );
	DeleteLocalInt(oDoor, "SC_ARCANELOCK_CASTERLEVEL" );
	DeleteLocalInt(oDoor, "SC_ARCANELOCK_CASTERTAG"  );
	DeleteLocalInt(oDoor, "SC_ARCANELOCK_OLDONOPEN" );
	DeleteLocalInt(oDoor, "SC_ARCANELOCK_KNOCKED" );
	
	CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oDoor, oDoor, 3804);
	
	if ( iFollowChildren == TRUE ) // prevents a loop
	{
		object 	oDoor2 = GetTransitionTarget(oDoor); // try to get any linked doors if there are any
		if ( GetObjectType( oDoor2 ) == OBJECT_TYPE_DOOR )
		{
			AssignCommand(oDoor2, DelayCommand( 1.0, SCRemoveArcaneLock(oDoor2, FALSE)));
		}
	}
}

void SCKnockArcaneLockRemove( object oDoor )
{
	SetLocalInt(oDoor, "SC_ARCANELOCK_KNOCKED", FALSE );
}

void SCKnockArcaneLock( object oDoor )
{
	if ( GetLocalString(oDoor, "SC_ARCANELOCK_CASTERTAG") != "" )
	{
		SetLocalInt(oDoor, "SC_ARCANELOCK_KNOCKED", TRUE );
		SpeakString( "The Arcane Lock Has Been Temporarily Removed" );
		DelayCommand( TurnsToSeconds(10),SCKnockArcaneLockRemove( oDoor ) );
	}
}




// implementation
void SCApplyArcaneLock( object oDoor, object oCaster = OBJECT_SELF )
{
	if ( GetObjectType( oDoor ) == OBJECT_TYPE_DOOR ) // ||  GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE )
	{
		ActionCloseDoor( oDoor );
		SCKnockArcaneLockRemove( oDoor );
		int iSpellPower = HkGetSpellPower( oCaster );
		SetLocalInt(oDoor, "SC_ARCANELOCK_HARDNESS", GetHardness( oDoor ) );
		//SetLocalInt(oDoor, "SC_ARCANELOCK_UNLOCKDC", GetLockUnlockDC( oDoor ) );
		//SetLocalInt(oDoor, "SC_ARCANELOCK_LOCKED", GetLocked( oDoor ) );
		SetLocalInt(oDoor, "SC_ARCANELOCK_CASTERPOINTER", ObjectToInt(oCaster));
		SetLocalInt(oDoor, "SC_ARCANELOCK_CASTERLEVEL", HkGetCasterLevel( oCaster ) );
		
		SetLocalInt(oDoor, "SC_ARCANELOCK_SPELLDISPELDC", HkDispelDC( oCaster, HkGetSpellClass( oCaster ) ) );
		
		SetLocalString(oDoor, "SC_ARCANELOCK_CASTERTAG", GetName( oCaster ) );
		SetLocalString(oDoor, "SC_ARCANELOCK_OLDONOPEN",GetEventHandler(oDoor, SCRIPT_DOOR_ON_OPEN ) );
		SetEventHandler(oDoor, SCRIPT_DOOR_ON_OPEN, "SP_arcanelockonopen");
		
		SetHardness( (iSpellPower/2) + GetHardness( oDoor ) + 10,  oDoor );
		//SetLockUnlockDC( iSpellPower + GetHardness( oDoor ) + 5,  oDoor );
			
		effect eEffect = EffectTemporaryHitpoints( iSpellPower*5 );
		
		eEffect = EffectLinkEffects( eEffect, EffectOnDispel(0.0f, SCRemoveArcaneLock( oDoor ) ) );
		
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oDoor );
	}
}






// deprecating
void SCHandleBlockedDoor( object oDoor, object oChar)
{
	int nInt = GetAbilityScore( oChar, ABILITY_INTELLIGENCE );
    int nStr = GetAbilityScore( oChar, ABILITY_STRENGTH );

    if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_OPEN) &&  nInt >= 3)
    {
		if ( SCIsArcaneLocked( oDoor ) )
		{
			if ( !SCAttemptKnockSpell( oDoor ) && GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && nStr >= 12 )
			{
				DoDoorAction(oDoor, DOOR_ACTION_BASH);
			}
		}
		else
		{
			DoDoorAction(oDoor, DOOR_ACTION_OPEN);
		}
    }

    else if(GetIsDoorActionPossible(oDoor, DOOR_ACTION_BASH) && nStr >= 14)
    {
        DoDoorAction(oDoor, DOOR_ACTION_BASH);
    }
}













void SCOpenDoor( object oDoor, object oOpeningChar )
{
	
	if ( GetLocalInt(oDoor, "SC_ARCANELOCK_KNOCKED" ) == TRUE )
	{
		SpeakString( "This is Knocked" );
	}
	
	if ( GetLocalString(oDoor, "SC_ARCANELOCK_CASTERTAG" ) == "" || GetLocalString(oDoor, "SC_ARCANELOCK_CASTERTAG" ) ==  GetName( oOpeningChar ) || GetLocalInt(oDoor, "SC_ARCANELOCK_KNOCKED" ) == TRUE  )
	{
		//SetLocked(oDoor, FALSE);
		//ActionOpenDoor(oDoor1);
		AssignCommand(oDoor, DelayCommand( 0.1f, ActionOpenDoor( oDoor )));
		AssignCommand(oDoor, DelayCommand( 30.0, ActionCloseDoor( oDoor )));
		
		object oDoor2 = GetTransitionTarget(oDoor); // try to get any linked doors if there are any
		if ( GetObjectType( oDoor2 ) == OBJECT_TYPE_DOOR )
		{
			AssignCommand(oDoor, DelayCommand( 0.1f, ActionOpenDoor( oDoor2 )));
			AssignCommand(oDoor2, DelayCommand( 30.0, ActionCloseDoor(oDoor2)));
		}
	}
	else
	{
		// just close said door
		
		if (DEBUGGING >= 6) { CSLDebug(  "Arcane Lock: "+GetName( oOpeningChar )+" can't open door locked By " +GetLocalString(oDoor, "SC_ARCANELOCK_CASTERTAG"), oOpeningChar ); }
		
		AssignCommand( oDoor, ClearAllActions( TRUE ) );
		AssignCommand(	oDoor, ActionCloseDoor(oDoor) );
		SpeakString( "This Door Is Magically Held" );
	}
}



void SCOpenArcaneLock( object oDoor, object oOpeningChar )
{
	
	if ( GetLocalInt(oDoor, "SC_ARCANELOCK_KNOCKED" ) == TRUE )
	{
		SpeakString( "This is Knocked" );
	}
	
	if ( GetLocalString(oDoor, "SC_ARCANELOCK_CASTERTAG" ) ==  GetName( oOpeningChar ) || GetLocalInt(oDoor, "SC_ARCANELOCK_KNOCKED" ) == TRUE  )
	{
		//SetLocked(oDoor, FALSE);
		//ActionOpenDoor(oDoor1);
		AssignCommand(oDoor, DelayCommand( 30.0, ActionCloseDoor( oDoor )));
		
		object oDoor2 = GetTransitionTarget(oDoor); // try to get any linked doors if there are any
		if ( GetObjectType( oDoor2 ) == OBJECT_TYPE_DOOR )
		{
			AssignCommand(oDoor2, DelayCommand( 30.0, ActionCloseDoor(oDoor2)));
		}
	}
	else
	{
		// just close said door
		
		if (DEBUGGING >= 6) { 
		CSLDebug(  "Arcane Lock: "+GetName( oOpeningChar )+" can't open door locked By " +GetLocalString(oDoor, "SC_ARCANELOCK_CASTERTAG"), oOpeningChar );}
		
		AssignCommand( oDoor, ClearAllActions( TRUE ) );
		AssignCommand(	oDoor, ActionCloseDoor(oDoor) );
		SpeakString( "This Door Is Magically Held" );
	}
}


void SConDoorDeath( object oDoor ) 
{
	SCRemoveArcaneLock( oDoor );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oDoor)), oDoor);
	AssignCommand(oDoor, ActionUnlockObject(oDoor));
	AssignCommand(oDoor, ActionOpenDoor(oDoor));
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHealOnZeroHP(oDoor, 10), oDoor);
}


/// Notes 
		//SetEventHandler(oTarget, SCRIPT_DOOR_ON_SPELLCASTAT, "SP_arcanelockdispel");
		
		// get if it is locked
		//GetLocked(oTarget);
		//GetLockLockable(object);
		
		//SetEventHandler(oTarget, SCRIPT_TRIGGER_ON_DISARMED, "nx2_b_symbol_disarm");
		//SetEventHandler(oTarget, SCRIPT_TRIGGER_ON_TRAPTRIGGERED, "nx2_b_symbol_triggered");
		
		/*
		int SCRIPT_DOOR_ON_OPEN            = 0;
int SCRIPT_DOOR_ON_CLOSE           = 1;
int SCRIPT_DOOR_ON_DAMAGE          = 2;
int SCRIPT_DOOR_ON_DEATH           = 3;
int SCRIPT_DOOR_ON_DISARM          = 4;
int SCRIPT_DOOR_ON_HEARTBEAT       = 5;
int SCRIPT_DOOR_ON_LOCK            = 6;
int SCRIPT_DOOR_ON_MELEE_ATTACKED  = 7;
int SCRIPT_DOOR_ON_SPELLCASTAT     = 8;
int SCRIPT_DOOR_ON_TRAPTRIGGERED   = 9;
int SCRIPT_DOOR_ON_UNLOCK          = 10;
int SCRIPT_DOOR_ON_USERDEFINED     = 11;
int SCRIPT_DOOR_ON_CLICKED         = 12;
int SCRIPT_DOOR_ON_DIALOGUE        = 13;
int SCRIPT_DOOR_ON_FAIL_TO_OPEN    = 14;

// Placeable
int SCRIPT_PLACEABLE_ON_CLOSED              = 0;
int SCRIPT_PLACEABLE_ON_DAMAGED             = 1;
int SCRIPT_PLACEABLE_ON_DEATH               = 2;
int SCRIPT_PLACEABLE_ON_DISARM              = 3;
int SCRIPT_PLACEABLE_ON_HEARTBEAT           = 4;
int SCRIPT_PLACEABLE_ON_INVENTORYDISTURBED  = 5;
int SCRIPT_PLACEABLE_ON_LOCK                = 6;
int SCRIPT_PLACEABLE_ON_MELEEATTACKED       = 7;
int SCRIPT_PLACEABLE_ON_OPEN                = 8;
int SCRIPT_PLACEABLE_ON_SPELLCASTAT         = 9;
int SCRIPT_PLACEABLE_ON_TRAPTRIGGERED       = 10;
int SCRIPT_PLACEABLE_ON_UNLOCK              = 11;
int SCRIPT_PLACEABLE_ON_USED                = 12;
int SCRIPT_PLACEABLE_ON_USER_DEFINED_EVENT  = 13;
int SCRIPT_PLACEABLE_ON_DIALOGUE            = 14;
		*/
		

//	}
//	else
//	{
		// wasted spell
//	}
	
	
	/*
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	float fDelay;
	int nResist;

	while(GetIsObjectValid(oTarget))
	{
			SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId(), FALSE ));
			fDelay = CSLRandomBetweenFloat(0.5, 2.5);
			if(!GetPlotFlag(oTarget) && GetLocked(oTarget))
			{
				nResist =  GetDoorFlag(oTarget,DOOR_FLAG_RESIST_KNOCK);
				if (nResist == 0)
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					AssignCommand(oTarget, ActionUnlockObject(oTarget));
				}
				else if  (nResist == 1)
				{
					FloatingTextStrRefOnCreature(83887,OBJECT_SELF);   //
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	*/
//}


		
//	if(fShutDelay == -1.0)
//		return;
//	else if(fShutDelay == 0.0)
//		fShutDelay = fShutDefault;
		
	/*
		object 	oDoor1 			= OBJECT_SELF;
	//object oPC = GetClickingObject();
	object oPC = GetLastOpenedBy();
	object 	oDoor2 			= GetTransitionTarget(oDoor1); // try to get any linked doors if there are any
	//float	fShutDefault	= 30.0;
	//float  	fShutDelay 		= GetLocalFloat(oDoor1, "AUTO_SHUT_DELAY");
	// only allow if caster is the one opening the door
	*/
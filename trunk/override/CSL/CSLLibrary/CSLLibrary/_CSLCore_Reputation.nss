/** @file
* @brief Reputations functions including alignment, reputation and factions
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/


// int nPlot = GetLocalInt(oCharacter, "NW_GENERIC_MASTER");
/*
const int CSL_FLAG_STEALTH                     = BIT3;
const int CSL_FLAG_AMBIENT_ANIMATIONS          = BIT20;
const int CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS = BIT22;
const int CSL_FLAG_FAST_BUFF_ENEMY             = BIT27;
const int CSL_COMBAT_FLAG_AMBUSHER          = BIT4;
const int CSL_COMBAT_FLAG_RANGED          = BIT1;
*/
/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCUtility"
#include "_CSLCore_Math_c"
#include "_CSLCore_Strings"
#include "_CSLCore_Position"
#include "_CSLCore_Visuals_c"
// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

// these are constants to control overall behavior
const int CSL_FLAG_SPECIAL_CONVERSATION        = BIT1;  // 0x00000001;
const int CSL_FLAG_SHOUT_ATTACK_MY_TARGET      = BIT2;  // 0x00000002;
const int CSL_FLAG_STEALTH                     = BIT3;  // 0x00000004;
const int CSL_FLAG_SEARCH                      = BIT4;  // 0x00000008;
const int CSL_FLAG_SET_WARNINGS                = BIT5;  // 0x00000010;
const int CSL_FLAG_ESCAPE_RETURN               = BIT6;  // 0x00000020; //Failed
const int CSL_FLAG_ESCAPE_LEAVE                = BIT7;  // 0x00000040;
const int CSL_FLAG_TELEPORT_RETURN             = BIT8;  // 0x00000080; //Failed
const int CSL_FLAG_TELEPORT_LEAVE              = BIT9;  // 0x00000100;
const int CSL_FLAG_PERCIEVE_EVENT              = BIT10; // 0x00000200;
const int CSL_FLAG_ATTACK_EVENT                = BIT11; // 0x00000400;
const int CSL_FLAG_DAMAGED_EVENT               = BIT12; // 0x00000800;
const int CSL_FLAG_SPELL_CAST_AT_EVENT         = BIT13; // 0x00001000;
const int CSL_FLAG_DISTURBED_EVENT             = BIT14; // 0x00002000;
const int CSL_FLAG_END_COMBAT_ROUND_EVENT      = BIT15; // 0x00004000;
const int CSL_FLAG_ON_DIALOGUE_EVENT           = BIT16; // 0x00008000;
//const int CSL_FLAG_RESTED_EVENT              = BIT17; // 0x00010000;
//const int CSL_FLAG_DEATH_EVENT               = BIT18; // 0x00020000;
const int CSL_FLAG_SPECIAL_COMBAT_CONVERSATION = BIT19; // 0x00040000;
const int CSL_FLAG_AMBIENT_ANIMATIONS          = BIT20; // 0x00080000;
const int CSL_FLAG_HEARTBEAT_EVENT             = BIT21; // 0x00100000;
const int CSL_FLAG_IMMOBILE_AMBIENT_ANIMATIONS = BIT22; // 0x00200000;
const int CSL_FLAG_DAY_NIGHT_POSTING           = BIT23; // 0x00400000;
const int CSL_FLAG_AMBIENT_ANIMATIONS_AVIAN    = BIT24; // 0x00800000;
const int CSL_FLAG_APPEAR_SPAWN_IN_ANIMATION   = BIT25; // 0x01000000;
const int CSL_FLAG_SLEEPING_AT_NIGHT           = BIT26; // 0x02000000;
const int CSL_FLAG_FAST_BUFF_ENEMY             = BIT27;  // 0x04000000;

// new flags
const int CSL_FLAG_GENERAL                     = BIT17; // group AI, this is a boss // 0x00010000;
const int CSL_FLAG_MINION                      = BIT18; // group AI, this is a minion // 0x00020000;

const int CSL_FLAG_FLEE            = BIT28; // SOD's flee system // 0x04000000;
const int CSL_FLAG_BUSYMOVING             = BIT29; // 0x04000000;
const int CSL_FLAG_XXX4            = BIT30; // 0x04000000;
const int CSL_FLAG_XXX5            = BIT31; // 0x04000000;


const int CSL_COMBAT_FLAG_RANGED            = 0x00000001;
const int CSL_COMBAT_FLAG_DEFENSIVE         = 0x00000002;
const int CSL_COMBAT_FLAG_COWARDLY          = 0x00000004;
const int CSL_COMBAT_FLAG_AMBUSHER          = 0x00000008;

// different range but same constant names here
const int CSL_FLAG_BEHAVIOR_SPECIAL       = 0x00000001; // Special behavior
const int CSL_FLAG_BEHAVIOR_OMNIVORE      = 0x00000004; //Will only attack if approached
const int CSL_FLAG_BEHAVIOR_HERBIVORE     = 0x00000008; //Will never attack.  Will always flee.



// Act constants.
// these define the kinds of acts that can be performed.
// *** Good & Evil
const int ACT_EVIL_INCARNATE	= -4;
const int ACT_EVIL_FIENDISH		= -3;
const int ACT_EVIL_MALEVOLENT	= -2;
const int ACT_EVIL_IMPISH		= -1;

const int ACT_GOOD_KINDLY		= 1;
const int ACT_GOOD_BENEVOLENT	= 2;
const int ACT_GOOD_SAINTLY		= 3;
const int ACT_GOOD_INCARNATE	= 4;

// *** Law & Chaos
const int ACT_CHAOTIC_INCARNATE	= -4;
const int ACT_CHAOTIC_ANARCHIC	= -3;
const int ACT_CHAOTIC_FEY		= -2;
const int ACT_CHAOTIC_WILD		= -1;

const int ACT_LAWFUL_HONEST		= 1;
const int ACT_LAWFUL_ORDERLY	= 2;
const int ACT_LAWFUL_PARAGON	= 3;
const int ACT_LAWFUL_INCARNATE	= 4;



// Alignment scale values. 
const int ALIGN_SCALE_MIN 							= 0;
const int ALIGN_SCALE_MAX 							= 100;
// evil/chaotic
const int ALIGN_SCALE_LOW_BAND_LOWER_BOUNDARY 		= 0;
const int ALIGN_SCALE_LOW_BAND_MIDDLE 				= 15;
const int ALIGN_SCALE_LOW_BAND_UPPER_BOUNDARY 		= 30;
// neutral
const int ALIGN_SCALE_NEUTRAL_BAND_LOWER_BOUNDARY 	= 31;
const int ALIGN_SCALE_NEUTRAL_BAND_MIDDLE 			= 50;
const int ALIGN_SCALE_NEUTRAL_BAND_UPPER_BOUNDARY 	= 69;
// goood/lawful
const int ALIGN_SCALE_HIGH_BAND_LOWER_BOUNDARY 		= 70;
const int ALIGN_SCALE_HIGH_BAND_MIDDLE 				= 85;
const int ALIGN_SCALE_HIGH_BAND_UPPER_BOUNDARY 		= 100;
/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////


// Alignment Axis constants for comparing function in sg_inc_wrappers
const int   ALIGNMENT_AXIS_GOODEVIL = 0;
const int   ALIGNMENT_AXIS_LAWCHAOS = 1;

const int   ALIGNMENT_LG = 0;
const int   ALIGNMENT_LN = 1;
const int   ALIGNMENT_LE = 2;
const int   ALIGNMENT_NG = 3;
const int   ALIGNMENT_N  = 4;
const int   ALIGNMENT_NE = 5;
const int   ALIGNMENT_CG = 6;
const int   ALIGNMENT_CN = 7;
const int   ALIGNMENT_CE = 8;

//Distance
const int CSL_ASC_DISTANCE_2_METERS =   0x00000001;
const int CSL_ASC_DISTANCE_4_METERS =   0x00000002;
const int CSL_ASC_DISTANCE_6_METERS =   0x00000004;

// Percentage of master's damage at which the
// assoc will try to heal them.
const int CSL_ASC_HEAL_AT_75 =          0x00000008;
const int CSL_ASC_HEAL_AT_50 =          0x00000010;
const int CSL_ASC_HEAL_AT_25 =          0x00000020;

//Auto AI
const int CSL_ASC_AGGRESSIVE_BUFF =     0x00000040;
const int CSL_ASC_AGGRESSIVE_SEARCH =   0x00000080;
const int CSL_ASC_AGGRESSIVE_STEALTH =  0x00000100;

//Open Locks on master fail
const int CSL_ASC_RETRY_OPEN_LOCKS =    0x00000200;

//Casting power
const int CSL_ASC_OVERKIll_CASTING =    0x00000400; // GetMax Spell
const int CSL_ASC_POWER_CASTING =       0x00000800; // Get Double CR or max 4 casting
const int CSL_ASC_SCALED_CASTING =      0x00001000; // CR + 4;

const int CSL_ASC_USE_CUSTOM_DIALOGUE = 0x00002000;
const int CSL_ASC_DISARM_TRAPS =        0x00004000;
const int CSL_ASC_USE_RANGED_WEAPON   = 0x00008000;

// Playing Dead mode, used to make sure the associate is
// not targeted while dying.
const int CSL_ASC_MODE_DYING          = 0x00010000;

// DBR 8/3/6 - I am a puppet. Put nothing on the action queue on my own except force follow
const int CSL_ASC_MODE_PUPPET = 		   0x00020000;

//Guard Me Mode, Attack Nearest sets this to FALSE.
const int CSL_ASC_MODE_DEFEND_MASTER =  0x04000000;

//The Henchman will ignore move to object in their OnHeartbeat.
//If this is set to FALSE then they are in follow mode.
const int CSL_ASC_MODE_STAND_GROUND =   0x08000000;

const int CSL_ASC_MASTER_GONE =         0x10000000;

const int CSL_ASC_MASTER_REVOKED =      0x20000000;

//Only busy if attempting to bash or pick a lock or dead
const int CSL_ASC_IS_BUSY =             0x40000000;

//Not actually used, here for system continuity
const int CSL_ASC_HAVE_MASTER =         0x80000000;

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAlignbits(int iAlign)
{
   switch (iAlign)
   {
       case ALIGNMENT_NEUTRAL: return 1;
       case ALIGNMENT_GOOD:    return 2;
       case ALIGNMENT_EVIL:    return 4;
   }
   return 0;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSetAlignment(object oPC, int nLawChaos, int nGoodEvil)
{
	AdjustAlignment(oPC, ALIGNMENT_NEUTRAL, 100); // RESET TO NEUTRAL
	if ( nLawChaos == ALIGNMENT_LAWFUL )
	{
		AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 100);
	}
	else if ( nLawChaos == ALIGNMENT_CHAOTIC )
	{
		AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 100);
	}
	
	if ( nGoodEvil == ALIGNMENT_GOOD )
	{
		AdjustAlignment(oPC, ALIGNMENT_GOOD, 100);
	}
	else if ( nGoodEvil == ALIGNMENT_EVIL )
	{
		AdjustAlignment(oPC, ALIGNMENT_EVIL, 100);
	}
}



/**  
* Wraps the alignment check functions into one call
* @author 2005 Karl Nickels (Syrus Greycloak)
* @param 
* @see 
* @return 
*/
int CSLGetCreatureAlignmentEqual(object oCreature, int iCompareAlignTo, int iAxis = ALIGNMENT_AXIS_GOODEVIL) 
{
    
    int iAlignment;
    
    if(iAxis==ALIGNMENT_AXIS_GOODEVIL)
    {
        iAlignment=GetAlignmentGoodEvil(oCreature);
    }
    else
    {
        iAlignment=GetAlignmentLawChaos(oCreature);
    }
    
    return (iAlignment==iCompareAlignTo);
}

// Adjust Alignment notes: 
// Alignment is not treated as a continuous scale running from 0 to 100, but in three bands running from 0 to 30, 31 to 69 and 70 to 100. 
// Whenever a call to AdjustAlignment takes you over one of these boundaries, 
// your characters alignment is automatically placed at the middle of the new band, ie 15, 50 or 85. 

int CSLGetLawChaosActAdjustment(int iLawChaosActType)
{	
	int iAdjustment = 0;
	switch ( iLawChaosActType )
	{
	    case ACT_CHAOTIC_INCARNATE:
	        iAdjustment = -70;
	        break;
	    case ACT_CHAOTIC_ANARCHIC:
	        iAdjustment = -10;
	        break;
	    case ACT_CHAOTIC_FEY:
	        iAdjustment = -3;
	        break;
	    case ACT_CHAOTIC_WILD:
	        iAdjustment = -1;
	        break;
	    case 0:	// Neutral acts not currently tracked
	        iAdjustment = 0;
	        break;
	    case ACT_LAWFUL_HONEST:
	        iAdjustment = 1;
	        break;
	    case ACT_LAWFUL_ORDERLY:
	        iAdjustment = 3;
	        break;
	    case ACT_LAWFUL_PARAGON:
	        iAdjustment = 10;
	        break;
	    case ACT_LAWFUL_INCARNATE:
	        iAdjustment = 70;
	        break;
	}
	return (iAdjustment);
}	



int CSLGetGoodEvilActAdjustment(int iGoodEvilActType)
{	
	int iAdjustment = 0;
	switch ( iGoodEvilActType )
	{
	    case ACT_EVIL_INCARNATE:
	        iAdjustment = -70;
	        break;
	    case ACT_EVIL_FIENDISH:
	        iAdjustment = -10;
	        break;
	    case ACT_EVIL_MALEVOLENT:
	        iAdjustment = -3;
	        break;
	    case ACT_EVIL_IMPISH:
	        iAdjustment = -1;
	        break;
	    case 0:	// Neutral acts not currently tracked
	        iAdjustment = 0;
	        break;
	    case ACT_GOOD_KINDLY:
	        iAdjustment = 1;
	        break;
	    case ACT_GOOD_BENEVOLENT:
	        iAdjustment = 3;
	        break;
	    case ACT_GOOD_SAINTLY:
	        iAdjustment = 10;
	        break;
	    case ACT_GOOD_INCARNATE:
	        iAdjustment = 70;
	        break;
	}
	return (iAdjustment);
}

// Adjust toward law or chaos by iAdjustment
void CSLAdjustAlignmentLawChaos(object oPC, int iAdjustment)
{
    if (iAdjustment > 0) 
		AdjustAlignment(oPC, ALIGNMENT_LAWFUL, iAdjustment);
    else 
		AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, -iAdjustment);
}

// Adjust toward good or evil by iAdjustment
void CSLAdjustAlignmentGoodEvil(object oPC, int iAdjustment)
{
    if (iAdjustment > 0) 
		AdjustAlignment(oPC, ALIGNMENT_GOOD, iAdjustment);
    else 
		AdjustAlignment(oPC, ALIGNMENT_EVIL, -iAdjustment);
}

int CSLLawChaosAxisAdjustment(object oPC, int iLawChaosActType)
{	
	int iAdjustment = CSLGetLawChaosActAdjustment(iLawChaosActType);
	CSLAdjustAlignmentLawChaos(oPC, iAdjustment);
	return (iAdjustment);
}

int CSLGoodEvilAxisAdjustment(object oPC, int iGoodEvilActType)
{	
	int iAdjustment = CSLGetGoodEvilActAdjustment(iGoodEvilActType);
	CSLAdjustAlignmentGoodEvil(oPC, iAdjustment);
	return (iAdjustment);
}


// get adjustment that is always in the direction of neutral (50)
int CSLGetNeutralAdjustment(int nAlignmentValue, int nAdjustment)
{
	int nNewAdjustment = 0;
	int nMaxAdjustment = ALIGN_SCALE_NEUTRAL_BAND_MIDDLE - nAlignmentValue;
	int nSign = nMaxAdjustment/abs(nMaxAdjustment);
	int nMaxAdjustmentMag = abs(nMaxAdjustment);
	int nAdjustmentMag = abs(nAdjustment);
	
	if (nMaxAdjustmentMag < nAdjustmentMag)
		nNewAdjustment = nMaxAdjustmentMag * nSign;
	else
		nNewAdjustment = nAdjustmentMag * nSign;
		
	return (nNewAdjustment);
}





/**  
* Wraps the alignment check functions into one call
* and returns one alignment constant for a particular
* alignment
* @param 
* @see 
* @return 
*/
int CSLGetCreatureAlignment(object oCreature)
{
    int iAlignmentLC = GetLawChaosValue(oCreature);
    int iAlignmentGE = GetGoodEvilValue(oCreature);
    int iAlignment;
    
    if(iAlignmentLC >= 70)
    {
        if (iAlignmentGE >= 70)
        {
            iAlignment = ALIGNMENT_LG;
        }
        else if ( iAlignmentGE <= 30 )
        {
            iAlignment = ALIGNMENT_LE;
        }
        else
        {
            iAlignment = ALIGNMENT_LN;
        }
        
    }
    else if (iAlignmentLC <= 30)
    {
        if (iAlignmentGE >= 70)
        {
            iAlignment = ALIGNMENT_CG;
        }
        else if ( iAlignmentGE <= 30 )
        {
            iAlignment = ALIGNMENT_CE;
        }
        else
        {
            iAlignment = ALIGNMENT_CN;
        }
        
    }
    else
    {
        if (iAlignmentGE >= 70)
        {
            iAlignment = ALIGNMENT_NG;
        }
        else if ( iAlignmentGE <= 30 )
        {
            iAlignment = ALIGNMENT_NE;
        }
        else
        {
            iAlignment = ALIGNMENT_N;
        }
        
    }
    
    
    return iAlignment;
}

/**  
* Wraps the alignment check functions into one call
* and returns one alignment constant for a particular
* alignment
* @author 2006 Karl Nickels (Syrus Greycloak)
* This had error where Neutral Evil came back as Neutral Good, every other thing worked right 
* @param 
* @see 
* @return 
*/
/*
int CSLGetCreatureAlignmentOld(object oCreature)
{
    
    int iAlignmentGE = GetAlignmentGoodEvil(oCreature);
    int iAlignmentLC = GetAlignmentLawChaos(oCreature);
    
    int iAlignment;
    
    if(iAlignmentLC==ALIGNMENT_LAWFUL)
    {
        if(iAlignmentGE==ALIGNMENT_GOOD)
        {
            iAlignment = ALIGNMENT_LG;
        }
        else if(iAlignmentGE==ALIGNMENT_NEUTRAL)
        {
            iAlignment = ALIGNMENT_LN;
        }
        else // if(iAlignmentGE==ALIGNMENT_EVIL)
        {
            iAlignment = ALIGNMENT_LE;
        }
    }
    else if(iAlignmentLC==ALIGNMENT_NEUTRAL)
    {
        if(iAlignmentGE==ALIGNMENT_GOOD)
        {
            iAlignment = ALIGNMENT_NG;
        }
        else if(iAlignmentGE==ALIGNMENT_NEUTRAL)
        {
            iAlignment = ALIGNMENT_N;
        }
        else // if(iAlignmentGE==ALIGNMENT_EVIL)
        {
            iAlignment = ALIGNMENT_NE;
        }
    }
    else // iAlignmentLC = ALIGNMENT_CHAOTIC
    {
        if(iAlignmentGE==ALIGNMENT_GOOD)
        {
            iAlignment = ALIGNMENT_CG;
        }
        else if(iAlignmentGE==ALIGNMENT_NEUTRAL)
        {
            iAlignment = ALIGNMENT_CN;
        }
        else // if(iAlignmentGE==ALIGNMENT_EVIL)
        {
            iAlignment = ALIGNMENT_CE;
        }
    }
    
    return iAlignment;
}
*/

/**  
* Returns Icon representing the given alignment
* @author
* @param 
* @see 
* @return 
*/
string CSLGetAlignmentToIcon( int iAlign )
{
	if ( iAlign == ALIGNMENT_LG ) { return "align_lg.tga"; }
	if ( iAlign == ALIGNMENT_LN ) { return "align_ln.tga"; }
	if ( iAlign == ALIGNMENT_LE ) { return "align_le.tga"; }
	if ( iAlign == ALIGNMENT_NG ) { return "align_ng.tga"; }
	if ( iAlign == ALIGNMENT_N ) { return "align_nn.tga"; }
	if ( iAlign == ALIGNMENT_NE ) { return "align_ne.tga"; }
	if ( iAlign == ALIGNMENT_CG ) { return "align_cg.tga"; }
	if ( iAlign == ALIGNMENT_CN ) { return "align_cn.tga"; }
	if ( iAlign == ALIGNMENT_CE ) { return "align_ce.tga"; }
	return "align_n";
}

/**  
* returns descriptive string based on ALIGNMENT_* constant
* @author
* @param iAlign ALIGNMENT_* constant
* @see 
* @return 
*/
string CSLGetAlignmentToString( int iAlign )
{
	if ( iAlign == ALIGNMENT_LG ) { return "Lawful Good"; }
	if ( iAlign == ALIGNMENT_LN ) { return "Lawful Neutral"; }
	if ( iAlign == ALIGNMENT_LE ) { return "Lawful Evil"; }
	if ( iAlign == ALIGNMENT_NG ) { return "Neutral Good"; }
	if ( iAlign == ALIGNMENT_N ) { return "True Neutral"; }
	if ( iAlign == ALIGNMENT_NE ) { return "Neutral Evil"; }
	if ( iAlign == ALIGNMENT_CG ) { return "Chaotic Good"; }
	if ( iAlign == ALIGNMENT_CN ) { return "Chaotic Neutral"; }
	if ( iAlign == ALIGNMENT_CE ) { return "Chaotic Evil"; }
	return "";
}


string CSLGetAlignmentToAbbrevString( int iAlign )
{
	if ( iAlign == ALIGNMENT_LG ) { return "LG"; }
	if ( iAlign == ALIGNMENT_LN ) { return "LN"; }
	if ( iAlign == ALIGNMENT_LE ) { return "LE"; }
	if ( iAlign == ALIGNMENT_NG ) { return "NG"; }
	if ( iAlign == ALIGNMENT_N ) { return "TN"; }
	if ( iAlign == ALIGNMENT_NE ) { return "NE"; }
	if ( iAlign == ALIGNMENT_CG ) { return "CG"; }
	if ( iAlign == ALIGNMENT_CN ) { return "CN"; }
	if ( iAlign == ALIGNMENT_CE ) { return "CE"; }
	return "";
}


/**  
* Get the Nth nearest Creature By Reputation
* Does not return dead or hidden creatures
* @author
* @param oTarget Target
* @param iRpt REPUTATION_TYPE_* constant
* @param iNth Nth nearest
* @see 
* @return 
*/
object CSLGetNearestCreatureByReputation(object oTarget, int iRpt, int iNth=1)
{
	return GetNearestCreature(CREATURE_TYPE_REPUTATION, iRpt, oTarget, iNth, CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, CREATURE_TYPE_SCRIPTHIDDEN, CREATURE_SCRIPTHIDDEN_FALSE);
}

/**  
* Get nearest Hostile Creature
* @author
* @param  oTarget : Target
* @see 
* @return 
*/
object CSLGetNearestHostile(object oTarget)
{
	return CSLGetNearestCreatureByReputation(oTarget, REPUTATION_TYPE_ENEMY);
}

/**  
* Get nearest Neutral Creature
* @author
* @param  oTarget Target
* @see 
* @return 
*/
object CSLGetNearestNeutral(object oTarget)
{
	return CSLGetNearestCreatureByReputation(oTarget, REPUTATION_TYPE_NEUTRAL);
}

/**  
* Get nearest Friendly Creature
* @author
* @param  oTarget : Target
* @see 
* @return 
*/
object CSLGetNearestFriend(object oTarget)
{
	return CSLGetNearestCreatureByReputation(oTarget, REPUTATION_TYPE_FRIEND);
}


/**  
* Get a random nearby Creature By Reputation
* Does not return dead or hidden creatures
* @author
* @param oTarget Target
* @param iRpt REPUTATION_TYPE_*
* @see 
* @return 
*/
object CSLGetRandomCreatureByReputation(object oTarget, int iRpt)
{
	
	int iNth;
	// Don't spend too much resources, search for 3-12 creature 
	// Search backward so that if won't always return the nearest one
	object oTarget;
	for( iNth = d4(3); iNth > 0; iNth-- )
	{
		oTarget = CSLGetNearestCreatureByReputation(oTarget, iRpt, iNth);
		if( GetIsObjectValid(oTarget) )
		{
			return oTarget;
		}
	}
	return OBJECT_INVALID;
}


/**  
* Get random nearby Hostile Creature
* @author
* @param oTarget Target
* @see 
* @return 
*/
object CSLGetRandomHostile(object oTarget)
{
	return CSLGetRandomCreatureByReputation(oTarget, REPUTATION_TYPE_ENEMY);
}

/**  
* Get random nearby Neutral Creature
* @author
* @param oTarget Target
* @see 
* @return 
*/
object CSLGetRandomNeutral(object oTarget)
{
	return CSLGetRandomCreatureByReputation(oTarget, REPUTATION_TYPE_NEUTRAL);
}

/**  
* Get random nearby Friendly Creature
* @author
* @param oTarget : Target
* @see 
* @return 
*/
object CSLGetRandomFriend(object oTarget)
{
	return CSLGetRandomCreatureByReputation(oTarget, REPUTATION_TYPE_FRIEND);
}

// TRUE if the given creature has the given condition set
int CSLGetAnimationCondition(int nCondition, object oCreature=OBJECT_SELF)
{
    return (GetLocalInt(oCreature, "NW_ANIM_CONDITION") & nCondition);
}

// Get a random nearby friend within the specified distance limit,
// that isn't busy doing something else.
object CSLGetRandomNearbyFriend(float fMaxDistance, object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "CSLGetRandomFriend Start", GetFirstPC() ); }
    
    object oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCharacter, d2(),  CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);

    if (GetIsObjectValid(oFriend)
        && !GetIsPC(oFriend)
        && CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_ACTIVE, oFriend)
        && !IsInConversation(oFriend)
        && !GetIsInCombat(oFriend)
        && GetDistanceToObject(oFriend) <= fMaxDistance )
    {
        return oFriend;
    }

    return OBJECT_INVALID;
}



/**  
* Description
* @author PRC
* @param
* @todo need to rework this
* @return 
*/
int CSLGetIsValidAlignment( int iLawChaos, int iGoodEvil,int iAlignRestrict, int iAlignRstrctType, int iInvertRestriction )
{
    //deal with no restrictions first
    if(iAlignRstrctType == 0)
        return TRUE;
    //convert the ALIGNMENT_* into powers of 2
    iLawChaos = FloatToInt(pow(2.0, IntToFloat(iLawChaos-1)));
    iGoodEvil = FloatToInt(pow(2.0, IntToFloat(iGoodEvil-1)));
    //initialise result varaibles
    int iAlignTest, iRetVal = TRUE;
    //do different test depending on what type of restriction
    if(iAlignRstrctType == 1 || iAlignRstrctType == 3)   //I.e its 1 or 3
        iAlignTest = iLawChaos;
    if(iAlignRstrctType == 2 || iAlignRstrctType == 3) //I.e its 2 or 3
        iAlignTest = iAlignTest | iGoodEvil;
    //now the real test.
    if(iAlignRestrict & iAlignTest)//bitwise AND comparison
        iRetVal = FALSE;
    //invert it if applicable
    if(iInvertRestriction)
        iRetVal = !iRetVal;
    //and return the result
    return iRetVal;
}

/**  
* Description
* @author PRC
* @param
* @todo need to rework this
* @return 
*/
int CSLCompareAlignment(object oSource, object oTarget)
{
    int iStepDif;
    int iGE1 = GetAlignmentGoodEvil(oSource);
    int iLC1 = GetAlignmentLawChaos(oSource);
    int iGE2 = GetAlignmentGoodEvil(oTarget);
    int iLC2 = GetAlignmentLawChaos(oTarget);

    if(iGE1 == ALIGNMENT_GOOD){
        if(iGE2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iGE2 == ALIGNMENT_EVIL)
            iStepDif += 2;
    }
    if(iGE1 == ALIGNMENT_NEUTRAL){
        if(iGE2 != ALIGNMENT_NEUTRAL)
            iStepDif += 1;
    }
    if(iGE1 == ALIGNMENT_EVIL){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_GOOD)
            iStepDif += 2;
    }
    if(iLC1 == ALIGNMENT_LAWFUL){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_CHAOTIC)
            iStepDif += 2;
    }
    if(iLC1 == ALIGNMENT_NEUTRAL){
        if(iLC2 != ALIGNMENT_NEUTRAL)
            iStepDif += 1;
    }
    if(iLC1 == ALIGNMENT_CHAOTIC){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_LAWFUL)
            iStepDif += 2;
    }
    return iStepDif;
}


/**  
* Get Faction's reputation type towards target
* @author
* @param iFct : Faction 
* @param oTarget : Target
* @see 
* @return  REPUTATION_TYPE_*
*/
int CSLGetFactionDisposition(int iFct, object oTarget)
{
	int iRpt = GetStandardFactionReputation(iFct, oTarget);
	if( iRpt <= 10 ){ return REPUTATION_TYPE_ENEMY; }
	if( iRpt >= 90 ){ return REPUTATION_TYPE_FRIEND; }
	return REPUTATION_TYPE_NEUTRAL;
}

/**  
* Get the Nth nearest Creature to location
* Does not return dead or hidden creatures
* @author
* @param lLoc location
* @param iNth Nth nearest
* @see 
* @return 
*/
object CSLGetCreatureNearLocation(location lLoc, int iNth=1)
{
	return GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, CREATURE_ALIVE_TRUE, lLoc, iNth, CREATURE_TYPE_SCRIPTHIDDEN, CREATURE_SCRIPTHIDDEN_FALSE);
}

/**  
* Get creature with certain reputation towards a faction
* @author
* @param lLoc : Location
* @param iFct : Faction 
* @param iRpt : REPUTATION_TYPE_*
* @see 
* @return 
*/
object CSLGetNearestCreatureByDisposition(location lLoc, int iFct, int iRpt)
{
	int iNth;
	// Don't spend too much resources, search for 10
	// return OBJECT_INVALID if can't find one
	object oTarget;
	for( iNth = 1; iNth < 10; iNth++ )
	{
		oTarget = CSLGetCreatureNearLocation(lLoc, iNth);
		if( !GetIsObjectValid(oTarget) ){ return OBJECT_INVALID; }
		if( CSLGetFactionDisposition(iFct, oTarget) == iRpt ){ return oTarget; }
	}
	return OBJECT_INVALID;
}

/**  
* Get nearest Creature Hostile to Faction
* @author
* @param lLoc : Location
* @param iFct : Faction 
* @see 
* @return 
*/
object CSLGetNearestHostileByDisposition(location lLoc, int iFct)
{
	return CSLGetNearestCreatureByDisposition(lLoc, iFct, REPUTATION_TYPE_ENEMY);
}

/**  
* Get nearest Creature Neutral
* @author
* @param lLoc : Location
* @param iFct : Faction 
* @see 
* @return 
*/
object CSLGetNearestNeutralByDisposition(location lLoc, int iFct)
{
	return CSLGetNearestCreatureByDisposition(lLoc, iFct, REPUTATION_TYPE_NEUTRAL);
}

/**  
* Get nearest Creature Friendly to Faction
* @author
* @param lLoc : Location
* @param iFct : Faction 
* @see 
* @return 
*/
object CSLGetNearestFriendByDisposition(location lLoc, int iFct)
{
	return CSLGetNearestCreatureByDisposition(lLoc, iFct, REPUTATION_TYPE_FRIEND);
}

/**  
* Get a random creature with certain reputation towards a faction
* close to a location
* @author
* @param lLoc : Location
* @param iFct : Faction 
* @see 
* @return 
*/
object CSLGetRandomCreatureByDisposition(location lLoc, int iFct, int iRpt)
{
	int iNth;
	// Don't spend too much resources, search for 5-20 creature 
	// Search backward so that if won't always return the nearest one
	// return OBJECT_INVALID if can't find one
	object oTarget;
	for( iNth = d4(5); iNth > 0; iNth-- )
	{
		oTarget = CSLGetCreatureNearLocation(lLoc, iNth);
		if( GetIsObjectValid(oTarget) )
		{
			if( CSLGetFactionDisposition(iFct, oTarget) == iRpt ){ return oTarget; }
		}
	}
	return OBJECT_INVALID;
}

/**  
* Get random Creature Hostile to Faction
* @author
* @param lLoc : Location
* @param iFct : Faction 
* @see 
* @return 
*/
object CSLGetRandomHostileByDisposition(location lLoc, int iFct)
{
	return CSLGetRandomCreatureByDisposition(lLoc, iFct, REPUTATION_TYPE_ENEMY);
}

/**  
* Get random Creature Neutral to Faction
* @author
* @param lLoc : Location
// iFct : Faction 
* @see 
* @return 
*/
object CSLGetRandomNeutralByDisposition(location lLoc, int iFct)
{
	return CSLGetRandomCreatureByDisposition(lLoc, iFct, REPUTATION_TYPE_NEUTRAL);
}

/**  
* Get random Creature Friendly to Faction
* @author
* @param lLoc : Location
* @param iFct : Faction 
* @see 
* @return 
*/
object CSLGetRandomFriendByDisposition(location lLoc, int iFct)
{
	return CSLGetRandomCreatureByDisposition(lLoc, iFct, REPUTATION_TYPE_FRIEND);
}

/**  
*  Get the name of a standard Faction
* Return Faction_x for nonstandard Faction
* @author
* @param iFct
* @see 
* @return 
*/
string CSLGetStandardFactionName(int iFct)
{
	switch(iFct)
	{
		case STANDARD_FACTION_HOSTILE : return CSLColorText("Hostile", COLOR_RED );
		case STANDARD_FACTION_COMMONER: return "Commoner";
		case STANDARD_FACTION_MERCHANT: return "Merchant";
		case STANDARD_FACTION_DEFENDER: return CSLColorText("Defender", COLOR_GREEN );
	}
	return "Faction_"+IntToString(iFct);
}




// True if the object is NOT the caller's henchman
int CSLAssociateCheck(object oCheck)
{
    object oHench = GetAssociate(ASSOCIATE_TYPE_HENCHMAN);
    if(oCheck != oHench)
    {
        return TRUE;
    }
    return FALSE;
}

void CSLSetAssociateState(int nCondition, int bValid = TRUE, object oAssoc=OBJECT_SELF)
{
    //SpawnScriptDebugger();
    int nPlot = GetLocalInt(oAssoc, "NW_ASSOCIATE_MASTER");
    if(bValid == TRUE)
    {
        nPlot = nPlot | nCondition;
        SetLocalInt(oAssoc, "NW_ASSOCIATE_MASTER", nPlot);
    }
    else if (bValid == FALSE)
    {
        nPlot = nPlot & ~nCondition;
        SetLocalInt(oAssoc, "NW_ASSOCIATE_MASTER", nPlot);
    }
}

/*
void CSLSetAssociateState(int nCondition, int bValid = TRUE, object oAssoc=OBJECT_SELF)
{
    //SpawnScriptDebugger();
    int nPlot = GetLocalInt(oAssoc, "NW_ASSOCIATE_MASTER");
    if(bValid == TRUE)
    {
        nPlot = nPlot | nCondition;
        SetLocalInt(oAssoc, "NW_ASSOCIATE_MASTER", nPlot);
    }
    else if (bValid == FALSE)
    {
        nPlot = nPlot & ~nCondition;
        SetLocalInt(oAssoc, "NW_ASSOCIATE_MASTER", nPlot);
    }
}
*/
int CSLGetAssociateState(int nCondition, object oAssoc=OBJECT_SELF)
{
    //SpawnScriptDebugger();
    if(nCondition == CSL_ASC_HAVE_MASTER)
    {
        if(GetIsObjectValid(GetMaster(oAssoc)))
        {
            return TRUE;
        }
    }
    else
    {
        int nPlot = GetLocalInt(oAssoc, "NW_ASSOCIATE_MASTER");
        if(nPlot & nCondition)
            return TRUE;
    }
    return FALSE;
}



// Determine the distance we should follow at
float CSLGetFollowDistance(object oTarget=OBJECT_SELF)
{
    float fDistance;
    if(CSLGetAssociateState(CSL_ASC_DISTANCE_2_METERS, oTarget))
    {
        fDistance = 2.4;
    }
    else if(CSLGetAssociateState(CSL_ASC_DISTANCE_4_METERS, oTarget))
    {
        fDistance = 4.0;
    }
    else if(CSLGetAssociateState(CSL_ASC_DISTANCE_6_METERS, oTarget))
    {
        fDistance = 6.0;
    }

    return fDistance;
}


//::///////////////////////////////////////////////
//:: Set Associate Start Location
//:: Copyright (c) 2001 Bioware Corp.
//:: Created By: Preston Watmaniuk
//:: Created On: Nov 21, 2001
//:://////////////////////////////////////////////
void CSLSetAssociateStartLocation()
{
    SetLocalLocation(OBJECT_SELF, "NW_ASSOCIATE_START", GetLocation(OBJECT_SELF));
}

//::///////////////////////////////////////////////
//:: Get Associate Start Location // this is not being used
//:: Copyright (c) 2001 Bioware Corp.
//:: Created By: Preston Watmaniuk
//:: Created On: Nov 21, 2001
//:://////////////////////////////////////////////
location CSLGetAssociateStartLocation()
{
    return GetLocalLocation(OBJECT_SELF, "NW_ASSOCIATE_START");
}

// @todo fix this function, has duplicate prototype
// * duplciate implementation from cslcore player
// * Returns master of henchmen or faction leader of PC party
/*
object CSLGetCurrentMaster( object oFollower=OBJECT_SELF )
{
    object oMaster = GetMaster( oFollower );
	
	if ( GetIsObjectValid(oMaster) == FALSE )
	{
		// Roster companions should return their party leader
		// Similar to SCGetPCLeader() in ginc_companions
		//if ( GetFactionEqual(oFollower, GetFirstPC()) == TRUE )	// 9/19/06 - BDF: this conditional doesn't work in multiplayer muli-party
		//{
			//oMaster = GetPCFactionLeader( oFollower );	// GetFactionLeader() returns OBJECT_INVALID for non-PC faction members
			oMaster = GetFactionLeader( oFollower );	// GetFactionLeader() returns OBJECT_INVALID for non-PC faction members
			
			// Master doesn't need to be player-possessed (player might be possessing a familiar)
			//if ( GetIsPC(oMaster) == FALSE )
			//{
			//	oMaster = OBJECT_INVALID;
			//}
		//}	
	}
	
	return ( oMaster );
}
*/

/**  
* @author
* @param 
* @see 
* @return 
*/
// * Returns master of henchmen or faction leader of PC party
object CSLGetCurrentMaster( object oFollower=OBJECT_SELF )
{
    object oMaster = GetMaster( oFollower );
	
	if ( GetIsObjectValid(oMaster) == FALSE )
	{
		// Roster companions should return their party leader
		// Similar to SCGetPCLeader() in ginc_companions
		//if ( GetFactionEqual(oFollower, GetFirstPC()) == TRUE )	// 9/19/06 - BDF: this conditional doesn't work in multiplayer muli-party
		//{
			//oMaster = GetPCFactionLeader( oFollower );	// GetFactionLeader() returns OBJECT_INVALID for non-PC faction members
			oMaster = GetFactionLeader( oFollower );	// GetFactionLeader() returns OBJECT_INVALID for non-PC faction members
			
			// Master doesn't need to be player-possessed (player might be possessing a familiar)
			//if ( GetIsPC(oMaster) == FALSE )
			//{
			//	oMaster = OBJECT_INVALID;
			//}
		//}	
	}
	
	return ( oMaster );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * Returns master of henchmen or faction leader of PC party
object CSLGetCurrentRealMaster( object oFollower=OBJECT_SELF )
{
    object oMaster = GetMaster( oFollower );
	
	if ( GetIsObjectValid(oMaster) == FALSE )
	{
		oMaster = oFollower;
	}
	
	return ( oMaster );
}

int CSLGetIsLawful(object oCreature)
{
	return(GetAlignmentLawChaos(oCreature) == ALIGNMENT_LAWFUL);
}

int CSLGetIsChaotic(object oCreature)
{
	return(GetAlignmentLawChaos(oCreature) == ALIGNMENT_CHAOTIC);
}

int CSLGetIsGood(object oCreature)
{
	return(GetAlignmentGoodEvil(oCreature) == ALIGNMENT_GOOD);
}

int CSLGetIsEvil(object oCreature)
{
	return(GetAlignmentGoodEvil(oCreature) == ALIGNMENT_EVIL);
}



/*
// Act constants.
// these define the kinds of acts that can be performed.
// *** Good & Evil
const int ACT_EVIL_INCARNATE	= -4;
const int ACT_EVIL_FIENDISH		= -3;
const int ACT_EVIL_MALEVOLENT	= -2;
const int ACT_EVIL_IMPISH		= -1;

const int ACT_GOOD_KINDLY		= 1;
const int ACT_GOOD_BENEVOLENT	= 2;
const int ACT_GOOD_SAINTLY		= 3;
const int ACT_GOOD_INCARNATE	= 4;

// *** Law & Chaos
const int ACT_CHAOTIC_INCARNATE	= -4;
const int ACT_CHAOTIC_ANARCHIC	= -3;
const int ACT_CHAOTIC_FEY		= -2;
const int ACT_CHAOTIC_WILD		= -1;

const int ACT_LAWFUL_HONEST		= 1;
const int ACT_LAWFUL_ORDERLY	= 2;
const int ACT_LAWFUL_PARAGON	= 3;
const int ACT_LAWFUL_INCARNATE	= 4;



// Alignment scale values. 
const int ALIGN_SCALE_MIN 							= 0;
const int ALIGN_SCALE_MAX 							= 100;
// evil/chaotic
const int ALIGN_SCALE_LOW_BAND_LOWER_BOUNDARY 		= 0;
const int ALIGN_SCALE_LOW_BAND_MIDDLE 				= 15;
const int ALIGN_SCALE_LOW_BAND_UPPER_BOUNDARY 		= 30;
// neutral
const int ALIGN_SCALE_NEUTRAL_BAND_LOWER_BOUNDARY 	= 31;
const int ALIGN_SCALE_NEUTRAL_BAND_MIDDLE 			= 50;
const int ALIGN_SCALE_NEUTRAL_BAND_UPPER_BOUNDARY 	= 69;
// goood/lawful
const int ALIGN_SCALE_HIGH_BAND_LOWER_BOUNDARY 		= 70;
const int ALIGN_SCALE_HIGH_BAND_MIDDLE 				= 85;
const int ALIGN_SCALE_HIGH_BAND_UPPER_BOUNDARY 		= 100;

// 


// functions to check if creature is lawful, evil, etc...




// Adjust Alignment notes: 
// Alignment is not treated as a continuous scale running from 0 to 100, but in three bands running from 0 to 30, 31 to 69 and 70 to 100. 
// Whenever a call to AdjustAlignment takes you over one of these boundaries, 
// your characters alignment is automatically placed at the middle of the new band, ie 15, 50 or 85. 

int CSLGetLawChaosActAdjustment(int iLawChaosActType)
{	
	int iAdjustment = 0;
	switch ( iLawChaosActType )
	{
	    case ACT_CHAOTIC_INCARNATE:
	        iAdjustment = -70;
	        break;
	    case ACT_CHAOTIC_ANARCHIC:
	        iAdjustment = -10;
	        break;
	    case ACT_CHAOTIC_FEY:
	        iAdjustment = -3;
	        break;
	    case ACT_CHAOTIC_WILD:
	        iAdjustment = -1;
	        break;
	    case 0:	// Neutral acts not currently tracked
	        iAdjustment = 0;
	        break;
	    case ACT_LAWFUL_HONEST:
	        iAdjustment = 1;
	        break;
	    case ACT_LAWFUL_ORDERLY:
	        iAdjustment = 3;
	        break;
	    case ACT_LAWFUL_PARAGON:
	        iAdjustment = 10;
	        break;
	    case ACT_LAWFUL_INCARNATE:
	        iAdjustment = 70;
	        break;
	}
	return (iAdjustment);
}	



int CSLGetGoodEvilActAdjustment(int iGoodEvilActType)
{	
	int iAdjustment = 0;
	switch ( iGoodEvilActType )
	{
	    case ACT_EVIL_INCARNATE:
	        iAdjustment = -70;
	        break;
	    case ACT_EVIL_FIENDISH:
	        iAdjustment = -10;
	        break;
	    case ACT_EVIL_MALEVOLENT:
	        iAdjustment = -3;
	        break;
	    case ACT_EVIL_IMPISH:
	        iAdjustment = -1;
	        break;
	    case 0:	// Neutral acts not currently tracked
	        iAdjustment = 0;
	        break;
	    case ACT_GOOD_KINDLY:
	        iAdjustment = 1;
	        break;
	    case ACT_GOOD_BENEVOLENT:
	        iAdjustment = 3;
	        break;
	    case ACT_GOOD_SAINTLY:
	        iAdjustment = 10;
	        break;
	    case ACT_GOOD_INCARNATE:
	        iAdjustment = 70;
	        break;
	}
	return (iAdjustment);
}

// Adjust toward law or chaos by iAdjustment
void CSLAdjustAlignmentLawChaos(object oPC, int iAdjustment)
{
    if (iAdjustment > 0) 
		AdjustAlignment(oPC, ALIGNMENT_LAWFUL, iAdjustment);
    else 
		AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, -iAdjustment);
}

// Adjust toward good or evil by iAdjustment
void CSLAdjustAlignmentGoodEvil(object oPC, int iAdjustment)
{
    if (iAdjustment > 0) 
		AdjustAlignment(oPC, ALIGNMENT_GOOD, iAdjustment);
    else 
		AdjustAlignment(oPC, ALIGNMENT_EVIL, -iAdjustment);
}


int CSLLawChaosAxisAdjustment(object oPC, int iLawChaosActType)
{	
	int iAdjustment = CSLGetLawChaosActAdjustment(iLawChaosActType);
	CSLAdjustAlignmentLawChaos(oPC, iAdjustment);
	return (iAdjustment);
}

int CSLGoodEvilAxisAdjustment(object oPC, int iGoodEvilActType)
{	
	int iAdjustment = CSLGetGoodEvilActAdjustment(iGoodEvilActType);
	CSLAdjustAlignmentGoodEvil(oPC, iAdjustment);
	return (iAdjustment);
}



// get adjustment that is always in the direction of neutral (50)
int CSLGetNeutralAdjustment(int nAlignmentValue, int nAdjustment)
{
	int nNewAdjustment = 0;
	int nMaxAdjustment = ALIGN_SCALE_NEUTRAL_BAND_MIDDLE - nAlignmentValue;
	int nSign = nMaxAdjustment/abs(nMaxAdjustment);
	int nMaxAdjustmentMag = abs(nMaxAdjustment);
	int nAdjustmentMag = abs(nAdjustment);
	
	if (nMaxAdjustmentMag < nAdjustmentMag)
		nNewAdjustment = nMaxAdjustmentMag * nSign;
	else
		nNewAdjustment = nAdjustmentMag * nSign;
		
	return (nNewAdjustment);
}

*/



// Mark that the given creature has the given condition set
void CSLSetAnimationCondition(int nCondition, int bValid=TRUE, object oCreature=OBJECT_SELF)
{
    int nCurrentCond = GetLocalInt(oCreature, "NW_ANIM_CONDITION");
    if (bValid) {
        SetLocalInt(oCreature, "NW_ANIM_CONDITION", nCurrentCond | nCondition);
    } else {
        SetLocalInt(oCreature, "NW_ANIM_CONDITION", nCurrentCond & ~nCondition);
    }
}


// Gets the nearest enemy.
object CSLGetNearestEnemy(object oSource= OBJECT_SELF, int nNth = 1)
{
    return GetNearestCreature(CREATURE_TYPE_REPUTATION,
                              REPUTATION_TYPE_ENEMY,
                              oSource, nNth);
}


// Returns the nearest object that can be seen, then checks for
// the nearest heard target.
// You may pass in any of the CREATURE_TYPE_* constants
// used in GetNearestCreature as nCriteriaType, with
// corresponding values for nCriteriaValue.
object CSLGetNearestPerceivedEnemy(object oSource= OBJECT_SELF, int nNth = 1, int nCriteriaType=1000, int nCriteriaValue=1000)
{
    object oTarget;

    if (nCriteriaType != 1000)
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,  oSource, nNth,  CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, nCriteriaType, nCriteriaValue);
    }
    else
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oSource, nNth, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    }

    if(GetIsObjectValid(oTarget))
    {
        return oTarget; // found one
	}
        // * NEVER NEVER Look for heard enemies.
        // * it makes creatures go 'hunting' for enemies way past
        // * where they should be looking for them.
        // * BK Feb 2003

    return OBJECT_INVALID; // oTarget;
}

// Get the nearest seen enemy. This will NOT return an enemy that is
// heard but not seen; for that, use SC GetNearestPerceivedEnemy instead.
object CSLGetNearestSeenEnemy(object oSource= OBJECT_SELF, int nNth = 1)
{
    return GetNearestCreature(CREATURE_TYPE_REPUTATION,
                              REPUTATION_TYPE_ENEMY,
                              oSource, nNth,
                              CREATURE_TYPE_PERCEPTION,
                              PERCEPTION_SEEN);
}

/*
object SOD_GetNearestSeenHostile(object oFleeing)
{
	int nNth = 1;
	object oHostile = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oFleeing, nNth);
	int bSeen;
	
	while (nNth <6)
	{
		bSeen = GetObjectSeen(oHostile, oFleeing);
		
		if (bSeen)
		{
			return oHostile;
		}
		nNth++;
		oHostile = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oFleeing, nNth);
	}
	return OBJECT_INVALID;
}
*/



// Set a specific creature (or OBJECT_INVALID to clear) as the caller's "friend"
void CSLSetCurrentFriend(object oFriend, object oCharacter = OBJECT_SELF)
{
    if (!GetIsObjectValid(oFriend)) {
        DeleteLocalObject(oCharacter, "NW_ANIM_FRIEND");
    } else {
        SetLocalObject(oCharacter, "NW_ANIM_FRIEND", oFriend);
    }
}

// Get the caller's current friend, if set; OBJECT_INVALID otherwise
object CSLGetCurrentFriend( object oCharacter = OBJECT_SELF)
{
    return GetLocalObject(oCharacter, "NW_ANIM_FRIEND");
}





// Get a random nearby quasi - friend (high neutral) within the specified distance limit,
// that isn't busy doing something else.
object CSLGetRandomQuasiFriend(float fMaxDistance, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "CSLGetRandomQuasiFriend Start", GetFirstPC() ); }
    
    object oFriend = GetNearestCreature(CREATURE_TYPE_REPUTATION,
                                        REPUTATION_TYPE_NEUTRAL,
                                        oCharacter, d2(),
                                        CREATURE_TYPE_PERCEPTION,
                                        PERCEPTION_SEEN);

	if (GetReputation(oCharacter, oFriend) < 75)
		return (OBJECT_INVALID);
		
    if (GetIsObjectValid(oFriend)
        && !GetIsPC(oFriend)
        && CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_ACTIVE, oFriend)
        && !IsInConversation(oFriend)
        && !GetIsInCombat(oFriend)
        && GetDistanceToObject(oFriend) <= fMaxDistance)
    {
        return oFriend;
    }

    return OBJECT_INVALID;
}

// Get a random nearby object within the specified distance with
// the specified tag.
object CSLGetRandomObjectByTag(string sTag, float fMaxDistance, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "CSLGetRandomObjectByTag Start", GetFirstPC() ); }
    
    int nNth;
    if (fMaxDistance == SC_DISTANCE_SHORT) {
        nNth = d2();
    } else if (fMaxDistance == SC_DISTANCE_MEDIUM) {
        nNth = d4();
    } else {
        nNth = d6();
    }
    object oObj = GetNearestObjectByTag(sTag, oCharacter, nNth);
    if (GetIsObjectValid(oObj) && GetDistanceToObject(oObj) <= fMaxDistance)
        return oObj;
    return OBJECT_INVALID;
}

// Get a random nearby object within the specified distance with
// the specified type.
// nObjType: Any of the OBJECT_TYPE_* constants
object CSLGetRandomObjectByType(int nObjType, float fMaxDistance, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "CSLGetRandomObjectByType Start", GetFirstPC() ); }
    
    int nNth;
    if (fMaxDistance == SC_DISTANCE_SHORT) {
        nNth = d2();
    } else if (fMaxDistance == SC_DISTANCE_LARGE) {
        nNth = d4();
    } else {
        nNth = d6();
    }
    object oObj = GetNearestObject(nObjType, oCharacter, nNth);
    if (GetIsObjectValid(oObj) && GetDistanceToObject(oObj) <= fMaxDistance)
        return oObj;
    return OBJECT_INVALID;
}

// Get a random "NW_STOP" object in the area.
// If fMaxDistance is non-zero, will return OBJECT_INVALID
// if the stop is too far away.
// The first time this is called in a given area, it cycles
// through all the stops in the area and stores them.
object CSLGetRandomStop(float fMaxDistance, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "CSLGetRandomStop Start", GetFirstPC() ); }
    
    object oStop;
    object oArea = GetArea(oCharacter);
    if (! GetLocalInt(oArea, "ANIM_STOPS_INITIALIZED") ) {
        // first time -- look up all the stops in the area and store them
        int nNth = 1;
        oStop = GetNearestObjectByTag("NW_STOP");
        while (GetIsObjectValid(oStop) && nNth < 30 )
        {
			//DEBUGGING// igDebugLoopCounter += 1;//DEBUGGING// igDebugLoopCounter += 1;
            SetLocalObject(oArea, "ANIM_STOP_" + IntToString(nNth), oStop);
            nNth++;
            oStop = GetNearestObjectByTag("NW_STOP", oCharacter, nNth);
        }
        SetLocalInt(oArea, "ANIM_STOPS", nNth-1);
        SetLocalInt(oArea, "ANIM_STOPS_INITIALIZED", TRUE);
    }

    int nStop = Random(GetLocalInt(oArea, "ANIM_STOPS")) + 1;
    oStop = GetLocalObject(oArea, "ANIM_STOP_" + IntToString(nStop));
    
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "CSLGetRandomStop End", GetFirstPC() ); }
    
    if (GetIsObjectValid(oStop) && GetDistanceToObject(oStop) <= fMaxDistance)
    {
        return oStop;
    }
    return OBJECT_INVALID;
}


// Set an object (or OBJECT_INVALID to clear) as the caller's interactive target.
void CSLSetCurrentInteractionTarget(object oTarget, object oCharacter = OBJECT_SELF)
{
    if (!GetIsObjectValid(oTarget)) {
        DeleteLocalObject(oCharacter, "NW_ANIM_TARGET");
    } else {
        SetLocalObject(oCharacter, "NW_ANIM_TARGET", oTarget);
    }
}

// Get the caller's current interaction target, if set; OBJECT_INVALID otherwise
object CSLGetCurrentInteractionTarget( object oCharacter = OBJECT_SELF)
{
    return GetLocalObject(oCharacter, "NW_ANIM_TARGET");
}


// =================================================================
// Faction and Reputation
// =================================================================





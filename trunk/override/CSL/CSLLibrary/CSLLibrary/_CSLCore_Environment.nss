/** @file
* @brief Environment Functions related to weather, terrain, water, breathing, and challenges created by an area
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/


/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////
// *********************************************
// **                 Fire                    **
// **  ( Thanks to Obsidian Shore - Wyvern )  **
// *********************************************

/* - FROM P&P DESCRIPTION -
Catching On Fire
Characters exposed to burning oil, bonfires, and noninstantaneous magic fires might find their
clothes, hair, or equipment on fire. Spells with an instantaneous duration don't normally set a
character on fire, since the heat and flame from these come and go in a flash. 

Characters at risk of catching fire are allowed a DC 15 Reflex save to avoid this fate. If a
character's clothes or hair catch fire, he takes 1d6 points of damage immediately. In each
subsequent round, the burning character must make another Reflex saving throw. Failure means
he takes another 1d6 points of damage that round. Success means that the fire has gone out.
(That is, once he succeeds on his saving throw, he’s no longer on fire.) 

A character on fire may automatically extinguish the flames by jumping into enough water to
douse himself. If no body of water is at hand, rolling on the ground or smothering the fire
with cloaks or the like permits the character another save with a +4 bonus. 

Those unlucky enough to have their clothes or equipment catch fire must make DC 15 Reflex
saves for each item. Flammable items that fail take the same amount of damage as the character. 
*/

// *********************************************
// **                 Water                   **
// **  ( Pain - Seed - Ideas by Dunniteowl and Wyvern )  **
// *********************************************
/*

Water slowing of 50%
Checks for models height, and drowns player only when head goes under.
Certain races and creatures and polymorphs are not affected by slowing or drowning ( water genasi, constructs, weasels can swim etc. )
Spells with a verbal component cannot be cast while holding breath unless player has metamagic to avoid issue.
Fire Spells require a DC check to cast
Acid based spells last one category of time shorter ( turns become rounds, hours become turns, rounds become seconds )
Area of effect spells have their durations shortened.
Invisibility does not work, and just provides concealment which persists with greater, and ends when they attack with regular.
Character can hold breath for twice their con score in rounds. Last 10 rounds count down to 0 after which they have to do fortitude saves to avoid damage.
Spells and damage can lower the rounds you can hold.
DC increases each round after breath holding stops and player gets a saving throw or they drown taking 10% of their hitpoints in damage.
When drowning player must save vs fear, note that once failed they basically are going to die.


Adding in Abyssa Weather system as a base
*/

/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////
#include "_CSLCore_Math"
#include "_CSLCore_Position"
// #include "_CSLCore_Strings"
#include "_CSLCore_Magic"
//#include "_CSLCore_Visuals_c"

#include "_CSLCore_Time"
#include "_CSLCore_Info"

#include "_CSLCore_Combat"
#include "_CSLCore_Visuals"

#include "_CSLCore_Feats_c"
#include "_CSLCore_Appearance"

/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////




const int CSL_ENVIRO_NONE = BIT0;
const int CSL_ENVIRO_AIRPOCKET = BIT1; // * works as a cutter ( air inside a water area )
const int CSL_ENVIRO_WATER = BIT2; // BIT2; // * water environment ( fire does not work well )
const int CSL_ENVIRO_FIRE = BIT3; // * area is in flames ( damaging, water or ice does not work well )
const int CSL_ENVIRO_MAGMA = BIT4; // areas floor is very hot ( damaging )
const int CSL_ENVIRO_COLD			= BIT5; // * area is very cold ( damaging )
const int CSL_ENVIRO_STORM	= BIT6; // area is electrically active ( thunder and lightning damaging )
const int CSL_ENVIRO_ACIDIC 		= BIT7; // * area is acidic ( damaging )
const int CSL_ENVIRO_NEGATIVE		= BIT8; // * area is pure negative ( damaging to living )
const int CSL_ENVIRO_POSITIVE		= BIT9; // area is pure positive ( damaging to dead )
// THESE ARE CONDITIONS
const int CSL_ENVIRO_GALE			= BIT10; // * ( GUST OF WIND TYPE EFFECT )
const int CSL_ENVIRO_LTVEGETATION	= BIT11; // * ( COVER )
const int CSL_ENVIRO_VEGETATION	= BIT12; // * ( MOVEMENT )
const int CSL_ENVIRO_SLIPPERY		= BIT13; // * ( MOVEMENT )
const int CSL_ENVIRO_HARDTERRAIN	= BIT14; // ( slow movement rocky, sand, mud )
const int CSL_ENVIRO_BLINDING		= BIT15; // ( SANDSTORM OR ICESTORM )
const int CSL_ENVIRO_DISEASE		= BIT16; // ( CONTAGIOUS )
const int CSL_ENVIRO_POISON		= BIT17; // ( POISON GAS )
const int CSL_ENVIRO_STENCH		= BIT18; // ( AMBIENCE, JUST TO TELL IT STINKS )
const int CSL_ENVIRO_FLAMMABLE	= BIT19; // ( COMBAT, PRONE TO FIRES )
// light and dark
const int CSL_ENVIRO_BRIGHT		= BIT20; // * AREA IS BRIGHT ( AFFECT HIDING )
const int CSL_ENVIRO_DARK			= BIT21; // * AREA IS DARK ( AFFECT HIDING )
// Alignment
const int CSL_ENVIRO_HOLY			= BIT22; // * ( BOOSTS GOOD MAGIC, WEAKENSEVIL )
const int CSL_ENVIRO_PROFANE		= BIT23; // * ( BOOSTS EVIL MAGIC, WEAKENS GOOD )
const int CSL_ENVIRO_LAW			= BIT24; // * ( BOOSTS LAWFUL MAGIC, WEAKENS CHAOS )
const int CSL_ENVIRO_CHAOS		= BIT25; // * ( BOOSTS CHAOS MAGIC, WEAKENS LAW )
// Other effects
const int CSL_ENVIRO_DEADMAGIC	= BIT26; // * MAGIC DOES NOT WORK
const int CSL_ENVIRO_WILDMAGIC	= BIT27; // * MAGIC WORKS TOO WELL
const int CSL_ENVIRO_TOWN			= BIT28; // * FOR SERVER MANAGEMENT
const int CSL_ENVIRO_REST			= BIT29; // * FOR SERVER MANAGEMENT
const int CSL_ENVIRO_NOREST		= BIT30; // * FOR SERVER MANAGEMENT
const int CSL_ENVIRO_ANCHORED		= BIT31; // * NO TELEPORT BLOCKER



const int CSL_CHARSTATE_NONE			= BIT0;
const int CSL_CHARSTATE_WEATHER		= BIT1;
const int CSL_CHARSTATE_WATER			= BIT2;
const int CSL_CHARSTATE_BREATHHOLD	= BIT3;
const int CSL_CHARSTATE_SPLASHING 	= BIT4;
const int CSL_CHARSTATE_WADING 		= BIT5;
const int CSL_CHARSTATE_SUBMERGED 	= BIT6;

const int CSL_CHARSTATE_DROWNING		= BIT7;
const int CSL_CHARSTATE_PANICKED		= BIT8;
const int CSL_CHARSTATE_ACIDIC		= BIT9;
const int CSL_CHARSTATE_GALE			= BIT10; // * ( GUST OF WIND TYPE EFFECT )
const int CSL_CHARSTATE_LTVEGETATION	= BIT11; // * ( COVER )
const int CSL_CHARSTATE_VEGETATION	= BIT12; // * ( MOVEMENT )
const int CSL_CHARSTATE_SLIPPERY		= BIT13; // * ( MOVEMENT )
const int CSL_CHARSTATE_HARDTERRAIN	= BIT14; // ( slow movement rocky, sand, mud )
const int CSL_CHARSTATE_BLINDING		= BIT15; // ( SANDSTORM OR ICESTORM )
const int CSL_CHARSTATE_DISEASE		= BIT16; // ( CONTAGIOUS )
const int CSL_CHARSTATE_POISON		= BIT17; // ( POISON GAS )
const int CSL_CHARSTATE_STENCH		= BIT18; // ( AMBIENCE, JUST TO TELL IT STINKS )
const int CSL_CHARSTATE_FLAMMABLE		= BIT19; // ( COMBAT, PRONE TO FIRES )
const int CSL_CHARSTATE_BRIGHT		= BIT20; // * AREA IS BRIGHT ( AFFECT HIDING )
const int CSL_CHARSTATE_DARK			= BIT21; // * AREA IS DARK ( AFFECT HIDING )
const int CSL_CHARSTATE_HOLY			= BIT22; // * ( BOOSTS GOOD MAGIC, WEAKENSEVIL )
const int CSL_CHARSTATE_PROFANE		= BIT23; // * ( BOOSTS EVIL MAGIC, WEAKENS GOOD )
const int CSL_CHARSTATE_LAW			= BIT24; // * ( BOOSTS LAWFUL MAGIC, WEAKENS CHAOS )
const int CSL_CHARSTATE_CHAOS			= BIT25; // * ( BOOSTS CHAOS MAGIC, WEAKENS LAW )
const int CSL_CHARSTATE_DEADMAGIC		= BIT26;
const int CSL_CHARSTATE_WILDMAGIC		= BIT27;
const int CSL_CHARSTATE_CONFUSED		= BIT28;
const int CSL_CHARSTATE_BURNING		= BIT29;
const int CSL_CHARSTATE_FREEZING		= BIT30;
const int CSL_CHARSTATE_ANCHORED		= BIT31;

// Water States
//const int CSL_WATERSTATE_NONE = 0;
//const int CSL_WATERSTATE_SPLASHING = 1;
//const int CSL_WATERSTATE_WADING = 2;
//const int CSL_WATERSTATE_SUBMERGED = 3;


// SpellId's for effects
int CSL_ENVIRO_SPELLIDSTART	= 8000; // * Used to determine the start of the 31 spellid range, note it uses negative ints but i still want to keep it away from real spellids
int CSL_ENVIRO_SPELLIDEND = 9000;

const int SPELLENVIRO_WATERSLOWING = -10; // deprecating
const int SPELLENVIRO_TERRAINSLOWING = -11; // deprecating
const int SPELLENVIRO_BURNING = -12;
const int SPELLENVIRO_HOLY = -13;
const int SPELLENVIRO_PROFANE = -14;
const int SPELLENVIRO_LAWFUL = -15;
const int SPELLENVIRO_CHAOS = -16;

const int SPELLENVIRO_VEGETATION = -17;
const int SPELLENVIRO_LTVEGETATION = -18;

const int SPELLENVIRO_SLOWING = -19;

const int SPELLENVIRO_DEADMAGIC = -21;

string CSL_ENVIRO_HEARTBEAT_SCRIPT = "TG_EnviroControl";


// Weather type - can coincide
const int CSL_WEATHER_TYPE_NONE = BIT0; // No Weather, remove basically
const int CSL_WEATHER_TYPE_WIND = BIT1; // Mainly just windy
const int CSL_WEATHER_TYPE_RAIN = BIT2; // Rain storm
const int CSL_WEATHER_TYPE_SNOW = BIT3; // snow storm

const int CSL_WEATHER_TYPE_ACIDIC = BIT5; // acidic
const int CSL_WEATHER_TYPE_FIERY = BIT6; // fiery
const int CSL_WEATHER_TYPE_HAIL = BIT7; // hail
const int CSL_WEATHER_TYPE_FLOOD = BIT8; // flood
const int CSL_WEATHER_TYPE_THUNDER = BIT9; // thunder
// POWER
const int CSL_WEATHER_POWER_OFF = BIT10; // OFF
const int CSL_WEATHER_POWER_WEAK = BIT11; // WEAK
const int CSL_WEATHER_POWER_LIGHT = BIT12; // LIGHT
const int CSL_WEATHER_POWER_MEDIUM = BIT13; // MEDIUM
const int CSL_WEATHER_POWER_HEAVY = BIT14; // HEAVY
const int CSL_WEATHER_POWER_STORMY = BIT15; // STORMY

// Environmental Dangers
const int CSL_WEATHER_RANDOMLIGHTNING = BIT16; // Random Lightning strikes
const int CSL_WEATHER_RANDOMEXPLODE = BIT17; // Random Fiery, Acidic, or Sonic Strikes, will use environment information
const int CSL_WEATHER_RANDOMBOULDERS = BIT18; // Random Boulder Strikes
const int CSL_WEATHER_RANDOMTORNADOS = BIT19; // Random Tornados
const int CSL_WEATHER_RANDOMGUSTS = BIT20; // Random Gusts of wind

// Danger Frequency
const int CSL_WEATHER_RANDOM_RARELY = BIT21; // Random Fiery Strikes
const int CSL_WEATHER_RANDOM_SELDOM = BIT22; // Random Fiery Strikes
const int CSL_WEATHER_RANDOM_OFTEN = BIT23; // Random Fiery Strikes

// Atmosphere
const int CSL_WEATHER_ATMOS_NONE = BIT24; // white gentle fog
const int CSL_WEATHER_ATMOS_HAZE = BIT25; // white gentle fog
const int CSL_WEATHER_ATMOS_FOG = BIT26; // white heavy fog
const int CSL_WEATHER_ATMOS_SMOKE = BIT27; // dark gray fog smoke
const int CSL_WEATHER_ATMOS_BLACK = BIT28; // dark black fog smoke
const int CSL_WEATHER_ATMOS_FIERY = BIT29; // red fiery fog
const int CSL_WEATHER_ATMOS_ACIDIC = BIT30; // green poison fog
const int CSL_WEATHER_ATMOS_SAND = BIT31; // blinding sand

const int WEATHER_FREQUENCY_SPORADIC = 0;
const int WEATHER_FREQUENCY_RARELY = 1;
const int WEATHER_FREQUENCY_SELDOM = 2;
const int WEATHER_FREQUENCY_OFTEN = 3;


const int AMBIENT_WINDSOFT = 30;
const int AMBIENT_WINDMEDIUM = 31;
const int AMBIENT_WINDSTRONG = 32;
const int AMBIENT_RAINLIGHT = 38;
const int AMBIENT_RAINHARD = 39;
const int AMBIENT_RAINHEAVY = 40;
const int AMBIENT_RAINSTORMY = 41;
const int AMBIENT_LAVA = 28;


const string ENVIRO_SEF_SMOKE = "fx_enviro_smoke";
const string ENVIRO_SEF_YELLOWFOG = "fx_enviro_yellowfog";
const string ENVIRO_SEF_BLACKFOG = "fx_enviro_blackfog";
const string ENVIRO_SEF_ORANGEFOG = "fx_enviro_orangefog";
const string ENVIRO_SEF_AQUAFOG = "fx_enviro_aquafog";
const string ENVIRO_SEF_REDFOG = "fx_enviro_redfog";
const string ENVIRO_SEF_PURPLEFOG = "fx_enviro_purplefog";
const string ENVIRO_SEF_WHITEFOG = "fx_enviro_whitefog";
const string ENVIRO_SEF_WHITEHAZE = "fx_enviro_whitehaze";
const string ENVIRO_SEF_BLUEFOG = "fx_enviro_bluefog";
const string ENVIRO_SEF_GREENFOG = "fx_enviro_greenfog";
const string ENVIRO_SEF_PINKFOG = "fx_enviro_pinkfog";
const string ENVIRO_SEF_SNOWLIGHT = "fx_enviro_snowlight";
const string ENVIRO_SEF_SNOWMEDIUM = "fx_enviro_snowmedium";
const string ENVIRO_SEF_SNOWHEAVY = "fx_enviro_snowheavy";
const string ENVIRO_SEF_ACIDICRAIN = "fx_enviro_acidicrain";


const string ENVIRO_SEF_SANDSTORM = "fx_enviro_sandstorm";
const string ENVIRO_SEF_THUNDER = "fx_enviro_thunderlightening";



// ground effects
const string ENVIRO_SEF_SNOWGROUND = "fx_enviro_snowyground";
const string ENVIRO_SEF_SANDGROUND = "fx_enviro_sandyground";

const int CSL_ENVIRO_GROUND_NONE = 0;
const int CSL_ENVIRO_GROUND_SNOW = 1;
const int CSL_ENVIRO_GROUND_SAND = 3;



const string CSL_WATERLEVELPLACEABLE = "plc_waterlevel";


// visual effects
const int VFXSC_FX_LIGHTNINGSTRIKE1 = 2190;
const int VFXSC_FX_LIGHTNINGSTRIKE2 = 2191;
const int VFXSC_FX_LIGHTNINGSTRIKE3 = 2192;
const int VFXSC_FX_LIGHTNINGSTRIKE4 = 2193;
const int VFXSC_FX_LIGHTNINGSTRIKE5 = 2194;
const int VFXSC_FX_LIGHTNINGSTRIKE6 = 2195;


/*
Notes to integrate, these are used in artillery include
	float fWindSpeed = GetLocalFloat( oArea, "CSLENVIRO_WINDSPEED" );
	float fWindDirection = GetLocalFloat( oArea, "CSLENVIRO_WINDDIRECTION" );
	float fWindForceCoefficient = GetLocalFloat( oArea, "CSLENVIRO_WINDCOEFFICIENT" );
	float fAirDragCoefficient = CSLDefineLocalFloat( oArea, "CSLENVIRO_AIRDRAGCOEFFICIENT", 30.0f );
*/


// not really used but need to check that
/*
//This controls how many regions you have in your module.
const int AB_REGION_COUNT = 3;

//This controls the timer for the overall weather system (in seconds). Increasing
//the value will extend the time between weather changes.
//Default: 1800.0
const float AB_WEATHER_TIMER = 90.0;

//This controls the timer for the lightning effects (in seconds). Increasing this
//will lower the frequency of lightning strikes when a Thunderstorm occurs.
//Default: 20.0
const float AB_LIGHTNING_TIMER = 20.0;

//These constants are the base tags of the Weather System components.
const string AB_MAINWS = "ab_weatherstation_main";
const string AB_WEATHERSTATION = "ab_weatherstation";
const string AB_THUNDER_SHORT = "ab_thunder_";
const string AB_LIGHTNING_SHORT = "ab_lightning_";

//These constants are called by the timer system. Do not modify.
const string AB_WEATHER_SCRIPT = "ab_weather_exe";
const string AB_LIGHTNING_SCRIPT = "ab_weather_lightning";
*/

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////


int CSLEnviroGetExpirationRound( float fDuration );
int CSLEnviroGetIsHigherLevelDarknessEffectsInArea( location lTarget, int iSpellLevel, float fRadius = 20.0f);
int CSLEnviroHoldBreath( int iBreathHoldingRounds, int iPreviousHitpoints, object oPC = OBJECT_SELF );
int CSLEnviroToggleWaterStateBits( int iCharState, int iBitToSet = 0 );
void CSLEnviroBurningExtinguish( object oPC = OBJECT_SELF );
void CSLEnviroBurningStart( int iStartingDC = 10, object oPC = OBJECT_SELF );
void CSLEnviroLighteningBolt( location lStartLocation, location lEndLocation, int iShape = SHAPE_SPHERE, float fRadius = RADIUS_SIZE_HUGE, int iBoltDC = 20 ); // SHAPE_SPHERE
void CSLEnviroObjectHeartbeat( object oPC, object oEC );
void CSLEnviroSetWeather( object oArea, int iWeatherState );
void CSLEnviroWindGust( location lStartLocation, location lEndLocation, int iShape = SHAPE_CONE, float fRadius = RADIUS_SIZE_HUGE, int iGustDC = 20 ); // SHAPE_SPHERE
void CSLEnviroWindGustEffect( location lStartLocation, object oTarget );
void CSLExplosion( location lStartLocation, location lEndLocation, int iShape = SHAPE_SPHERE, float fRadius = RADIUS_SIZE_HUGE, int iImpactDC = 20 );




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
int CSLEnviroGetSpellId( int iEnvironment )
{
	switch(iEnvironment)
    {
        case CSL_ENVIRO_AIRPOCKET:
        	return -( 1 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_WATER:
        	return -( 2 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_FIRE:
        	return -( 3 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_MAGMA:
        	return -( 4 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_COLD:
        	return -( 5 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_STORM:
        	return -( 6 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_ACIDIC:
        	return -( 7 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_NEGATIVE:
        	return -( 8 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_POSITIVE:
        	return -( 9 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_GALE:
        	return -( 10 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_LTVEGETATION:
        	return -( 11 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_VEGETATION:
        	return -( 12 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_SLIPPERY:
        	return -( 13 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_HARDTERRAIN:
        	return -( 14 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_BLINDING:
        	return -( 15 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_DISEASE:
        	return -( 16 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_POISON:
        	return -( 17 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_STENCH:
        	return -( 18 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_FLAMMABLE:
        	return -( 19 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_BRIGHT:
        	return -( 20 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_DARK:
        	return -( 21 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_HOLY:
        	return -( 22 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_PROFANE:
        	return -( 23 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_LAW:
        	return -( 24 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_CHAOS:
        	return -( 25 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_DEADMAGIC:
        	return -( 26 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_WILDMAGIC:
        	return -( 27 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_TOWN:
        	return -( 28 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_REST:
        	return -( 29 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_NOREST:
        	return -( 30 + CSL_ENVIRO_SPELLIDSTART );
        	break;
        case CSL_ENVIRO_ANCHORED:
        	return -( 31 + CSL_ENVIRO_SPELLIDSTART );
        	break;
    }
    return CSL_ENVIRO_SPELLIDSTART;

}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroRemoveEffects( object oTarget, int bFullRemove = FALSE )
{
	
	if ( bFullRemove ) // used on death, or upon a dm commend, completely pulling from any system
	{
		int iAreaState = GetLocalInt( oTarget, "CSL_ENVIRO" );
		if (iAreaState != CSL_ENVIRO_NONE ) 
		{
			if (iAreaState & CSL_ENVIRO_ACIDIC ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_ACIDIC ) );
			}
			if (iAreaState & CSL_ENVIRO_AIRPOCKET ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_AIRPOCKET ) );
			}
			if (iAreaState & CSL_ENVIRO_ANCHORED ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_ANCHORED ) );
			}
			if (iAreaState & CSL_ENVIRO_BLINDING ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_BLINDING ) );
			}
			if (iAreaState & CSL_ENVIRO_BRIGHT ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_BRIGHT ) );
			}
			if (iAreaState & CSL_ENVIRO_CHAOS )  
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_CHAOS ) );
			}
			if (iAreaState & CSL_ENVIRO_COLD ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_COLD ) );
			}
			if (iAreaState & CSL_ENVIRO_DARK ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_DARK ) );
			}
			if (iAreaState & CSL_ENVIRO_DEADMAGIC ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_DEADMAGIC ) );
			}
			if (iAreaState & CSL_ENVIRO_DISEASE ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_DISEASE ) );
			}
			if (iAreaState & CSL_ENVIRO_FIRE ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_FIRE ) );
			}
			if (iAreaState & CSL_ENVIRO_FLAMMABLE ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_FLAMMABLE ) );
			}
			if (iAreaState & CSL_ENVIRO_GALE ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_GALE ) );
			}
			if (iAreaState & CSL_ENVIRO_HARDTERRAIN ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_HARDTERRAIN ) );
			}
			if (iAreaState & CSL_ENVIRO_HOLY ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_HOLY ) );
			}
			if (iAreaState & CSL_ENVIRO_LAW ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_LAW ) );
			}
			if (iAreaState & CSL_ENVIRO_LTVEGETATION ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_LTVEGETATION ) );
			}
			if (iAreaState & CSL_ENVIRO_MAGMA ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_MAGMA ) );
			}
			if (iAreaState & CSL_ENVIRO_NEGATIVE ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_NEGATIVE ) );
			}
			if (iAreaState & CSL_ENVIRO_NOREST ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_NOREST ) );
			}
			if (iAreaState & CSL_ENVIRO_POISON )  
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_POISON ) );
			}
			if (iAreaState & CSL_ENVIRO_POSITIVE )  
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_POSITIVE ) );
			}
			if (iAreaState & CSL_ENVIRO_PROFANE ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_PROFANE ) );
			}
			if (iAreaState & CSL_ENVIRO_REST ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_REST ) );
			}
			if (iAreaState & CSL_ENVIRO_SLIPPERY )  
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_SLIPPERY ) );
			}
			if (iAreaState & CSL_ENVIRO_STENCH ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_STENCH ) );
			}
			if (iAreaState & CSL_ENVIRO_STORM ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_STORM ) );
			}
			if (iAreaState & CSL_ENVIRO_TOWN ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_TOWN ) );
			}
			if (iAreaState & CSL_ENVIRO_VEGETATION ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_VEGETATION ) );
			}
			if (iAreaState & CSL_ENVIRO_WATER ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_WATER ) );
			}
			if (iAreaState & CSL_ENVIRO_WILDMAGIC ) 
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, CSLEnviroGetSpellId( CSL_ENVIRO_WILDMAGIC ) );
			}
			DeleteLocalInt( oTarget, "CSL_ENVIRO" );
		}
		
		DeleteLocalInt( oTarget, "CSL_CHARSTATE" ); 
		
		DeleteLocalInt( oTarget, "CSL_KNOCKDOWN" );
		DeleteLocalInt( oTarget, "CSL_BURNING" );
		DeleteLocalInt( oTarget, "CSL_SOAKED" );
		
		DeleteLocalInt( oTarget, "CSL_FLAMMABLE" );
		DeleteLocalInt( oTarget, "CSL_FREEZING" );
		DeleteLocalInt( oTarget, "CSL_CHILLED" );
		DeleteLocalInt( oTarget, "CSL_GUSTED" );
		DeleteLocalInt( oTarget, "CSL_HOLDBREATH" );
		DeleteLocalFloat( oTarget, "CSL_WATERSURFACEHEIGHT" );
		
	}
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELLENVIRO_BURNING, SPELLENVIRO_HOLY, SPELLENVIRO_PROFANE, SPELLENVIRO_LAWFUL, SPELLENVIRO_CHAOS, SPELLENVIRO_VEGETATION, SPELLENVIRO_LTVEGETATION, SPELLENVIRO_SLOWING, SPELLENVIRO_DEADMAGIC );
	
	
}






/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLEnviroStateToString( int iAreaState )
{
	
	string sDescriptor = "";
	if (iAreaState==CSL_ENVIRO_NONE ) return "None";
	if (iAreaState & CSL_ENVIRO_ACIDIC ) sDescriptor += "Acidic ";
	if (iAreaState & CSL_ENVIRO_AIRPOCKET ) sDescriptor += "Airpocket ";
	if (iAreaState & CSL_ENVIRO_ANCHORED ) sDescriptor += "Anchored ";
	if (iAreaState & CSL_ENVIRO_BLINDING ) sDescriptor += "Blinding ";
	if (iAreaState & CSL_ENVIRO_BRIGHT ) sDescriptor += "Bright ";
	if (iAreaState & CSL_ENVIRO_CHAOS ) sDescriptor += "Chaos ";
	if (iAreaState & CSL_ENVIRO_COLD ) sDescriptor += "Cold ";
	if (iAreaState & CSL_ENVIRO_DARK ) sDescriptor += "Dark ";
	if (iAreaState & CSL_ENVIRO_DEADMAGIC ) sDescriptor += "Deadmagic ";
	if (iAreaState & CSL_ENVIRO_DISEASE ) sDescriptor += "Disease ";
	if (iAreaState & CSL_ENVIRO_FIRE ) sDescriptor += "Fire ";
	if (iAreaState & CSL_ENVIRO_FLAMMABLE ) sDescriptor += "Flammable ";
	if (iAreaState & CSL_ENVIRO_GALE ) sDescriptor += "Gale ";
	if (iAreaState & CSL_ENVIRO_HARDTERRAIN ) sDescriptor += "HardTerrain ";
	if (iAreaState & CSL_ENVIRO_HOLY ) sDescriptor += "Holy ";
	if (iAreaState & CSL_ENVIRO_LAW ) sDescriptor += "Law ";
	if (iAreaState & CSL_ENVIRO_LTVEGETATION ) sDescriptor += "LtVegetation ";
	if (iAreaState & CSL_ENVIRO_MAGMA ) sDescriptor += "Magma ";
	if (iAreaState & CSL_ENVIRO_NEGATIVE ) sDescriptor += "Negative ";
	if (iAreaState & CSL_ENVIRO_NOREST ) sDescriptor += "Norest ";
	if (iAreaState & CSL_ENVIRO_POISON ) sDescriptor += "Poison ";
	if (iAreaState & CSL_ENVIRO_POSITIVE ) sDescriptor += "Positive ";
	if (iAreaState & CSL_ENVIRO_PROFANE ) sDescriptor += "Profane ";
	if (iAreaState & CSL_ENVIRO_REST ) sDescriptor += "Rest ";
	if (iAreaState & CSL_ENVIRO_SLIPPERY ) sDescriptor += "Slippery ";
	if (iAreaState & CSL_ENVIRO_STENCH ) sDescriptor += "Stench ";
	if (iAreaState & CSL_ENVIRO_STORM ) sDescriptor += "Storm ";
	if (iAreaState & CSL_ENVIRO_TOWN ) sDescriptor += "Town ";
	if (iAreaState & CSL_ENVIRO_VEGETATION ) sDescriptor += "Vegetation ";
	if (iAreaState & CSL_ENVIRO_WATER ) sDescriptor += "Water ";
	if (iAreaState & CSL_ENVIRO_WILDMAGIC ) sDescriptor += "Wild ";
	return CSLTrim( sDescriptor );
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLEnviroCharStateToString( int iCharState )
{
	string sDescriptor = "";
	if (iCharState==CSL_CHARSTATE_NONE ) return "None";
	if (iCharState & CSL_CHARSTATE_WEATHER ) sDescriptor += "Weather ";
	if (iCharState & CSL_CHARSTATE_WATER ) sDescriptor += "Water ";
	if (iCharState & CSL_CHARSTATE_BREATHHOLD ) sDescriptor += "Breathhold ";
	if (iCharState & CSL_CHARSTATE_SPLASHING ) sDescriptor += "Splashing ";
	if (iCharState & CSL_CHARSTATE_WADING ) sDescriptor += "Wading ";
	if (iCharState & CSL_CHARSTATE_SUBMERGED ) sDescriptor += "Submerged ";
	if (iCharState & CSL_CHARSTATE_DROWNING ) sDescriptor += "Drowning ";
	if (iCharState & CSL_CHARSTATE_PANICKED ) sDescriptor += "Panicked ";
	if (iCharState & CSL_CHARSTATE_ACIDIC ) sDescriptor += "Acidic ";
	if (iCharState & CSL_CHARSTATE_GALE ) sDescriptor += "Gale ";
	if (iCharState & CSL_CHARSTATE_LTVEGETATION ) sDescriptor += "LtVegetation ";
	if (iCharState & CSL_CHARSTATE_VEGETATION ) sDescriptor += "Vegetation ";
	if (iCharState & CSL_CHARSTATE_SLIPPERY ) sDescriptor += "Slippery ";
	if (iCharState & CSL_CHARSTATE_HARDTERRAIN ) sDescriptor += "HardTerrain ";
	if (iCharState & CSL_CHARSTATE_BLINDING ) sDescriptor += "Blinding ";
	if (iCharState & CSL_CHARSTATE_DISEASE ) sDescriptor += "Disease ";
	if (iCharState & CSL_CHARSTATE_POISON ) sDescriptor += "Poison ";
	if (iCharState & CSL_CHARSTATE_STENCH ) sDescriptor += "Stench ";
	if (iCharState & CSL_CHARSTATE_FLAMMABLE ) sDescriptor += "Flammable ";
	if (iCharState & CSL_CHARSTATE_BRIGHT ) sDescriptor += "Bright ";
	if (iCharState & CSL_CHARSTATE_DARK ) sDescriptor += "Dark ";
	if (iCharState & CSL_CHARSTATE_HOLY ) sDescriptor += "Holy ";
	if (iCharState & CSL_CHARSTATE_PROFANE ) sDescriptor += "Profane ";
	if (iCharState & CSL_CHARSTATE_LAW ) sDescriptor += "Law ";
	if (iCharState & CSL_CHARSTATE_CHAOS ) sDescriptor += "Chaos ";
	if (iCharState & CSL_CHARSTATE_DEADMAGIC ) sDescriptor += "DeadMagic ";
	if (iCharState & CSL_CHARSTATE_WILDMAGIC ) sDescriptor += "Wildmagic ";
	if (iCharState & CSL_CHARSTATE_CONFUSED ) sDescriptor += "Confused ";
	if (iCharState & CSL_CHARSTATE_BURNING ) sDescriptor += "Burning ";
	if (iCharState & CSL_CHARSTATE_FREEZING ) sDescriptor += "Freezing ";
	if (iCharState & CSL_CHARSTATE_ANCHORED ) sDescriptor += "Anchored ";
	return CSLTrim( sDescriptor );
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLWeatherStateToString( int iWeatherState )
{
	
	string sDescriptor = "";
	if (iWeatherState==CSL_WEATHER_TYPE_NONE ) { return "None"; }
	if (iWeatherState & CSL_WEATHER_TYPE_WIND ) { sDescriptor += "Wind "; } 
	if (iWeatherState & CSL_WEATHER_TYPE_RAIN ) { sDescriptor += "Rain "; }
	if (iWeatherState & CSL_WEATHER_TYPE_SNOW )  { sDescriptor += "Snow "; }
	if (iWeatherState & CSL_WEATHER_TYPE_ACIDIC ) { sDescriptor += "Acidic "; }
	if (iWeatherState & CSL_WEATHER_TYPE_FIERY ) { sDescriptor += "Fiery "; }
	if (iWeatherState & CSL_WEATHER_TYPE_HAIL )  { sDescriptor += "Hail "; }
	if (iWeatherState & CSL_WEATHER_TYPE_FLOOD ) { sDescriptor += "Flooded "; }
	if (iWeatherState & CSL_WEATHER_TYPE_THUNDER ) { sDescriptor += "Thunder "; }
	if (iWeatherState & CSL_WEATHER_ATMOS_SAND ) { sDescriptor += "Sandstorm "; }
	
	if (iWeatherState & CSL_WEATHER_POWER_OFF ) { sDescriptor += "Off ";}
	else if (iWeatherState & CSL_WEATHER_POWER_WEAK )  { sDescriptor += "Weak "; }
	else if (iWeatherState & CSL_WEATHER_POWER_LIGHT ) { sDescriptor += "Light "; }
	else if (iWeatherState & CSL_WEATHER_POWER_MEDIUM ) { sDescriptor += "Medium "; }
	else if (iWeatherState & CSL_WEATHER_POWER_HEAVY ) { sDescriptor += "Heavy "; }
	else if (iWeatherState & CSL_WEATHER_POWER_STORMY ) { sDescriptor += "Stormy "; }
	else { sDescriptor += "Off "; }
	
	if (iWeatherState & CSL_WEATHER_RANDOMLIGHTNING ) sDescriptor += "Lightning ";
	if (iWeatherState & CSL_WEATHER_RANDOMEXPLODE ) sDescriptor += "Explosions ";
	if (iWeatherState & CSL_WEATHER_RANDOMBOULDERS ) sDescriptor += "Boulders ";
	if (iWeatherState & CSL_WEATHER_RANDOMTORNADOS ) sDescriptor += "Tornados ";
	if (iWeatherState & CSL_WEATHER_RANDOMGUSTS ) sDescriptor += "Gusts ";
	
	if (iWeatherState & CSL_WEATHER_RANDOM_RARELY ) sDescriptor += "Rarely ";
	else if (iWeatherState & CSL_WEATHER_RANDOM_SELDOM ) sDescriptor += "Seldon ";
	else if (iWeatherState & CSL_WEATHER_RANDOM_OFTEN ) sDescriptor += "Often ";
	else { sDescriptor += "Sporadic "; }
	
	if (iWeatherState & CSL_WEATHER_ATMOS_NONE ) sDescriptor += "Clear Skies";
	if (iWeatherState & CSL_WEATHER_ATMOS_HAZE ) sDescriptor += "Hazy ";
	if (iWeatherState & CSL_WEATHER_ATMOS_FOG ) sDescriptor += "White Fog ";
	if (iWeatherState & CSL_WEATHER_ATMOS_SMOKE ) sDescriptor += "Billowing Smoke ";
	if (iWeatherState & CSL_WEATHER_ATMOS_BLACK ) sDescriptor += "Black Fog ";
	if (iWeatherState & CSL_WEATHER_ATMOS_FIERY ) sDescriptor += "Reddish Fog ";
	if (iWeatherState & CSL_WEATHER_ATMOS_ACIDIC ) sDescriptor += "Greenish Fog ";
	
	return CSLTrim( sDescriptor );
}

/**  
* control object (invisible placeable)(ipoint) and heartbeat which manages environmental effects, thanks to nytirs system
* @author
* @param 
* @see 
* @return 
*/
object CSLEnviroGetControl( object oThingInTargetArea = OBJECT_SELF )
{
	object oModule = GetModule();
	object oEC = GetLocalObject( oModule, "ENVIRO_CONTROL" );
	if( !GetIsObjectValid(oEC) )
	{
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		if (DEBUGGING >= 8) { CSLDebug("CSLEnviroGetControl creating heartbeat object", GetFirstPC() ); }
		//SendMessageToPC( GetFirstPC(), "Environment Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		oEC = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation( oThingInTargetArea ), FALSE, "plc_environmentcontrol"); 
		
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oEC, TRUE);
		SetEventHandler(oEC, SCRIPT_PLACEABLE_ON_HEARTBEAT, CSL_ENVIRO_HEARTBEAT_SCRIPT);
		SetLocalObject(oModule, "ENVIRO_CONTROL", oEC);
		
		SetFirstName(oEC, "Environment");
		SetLastName(oEC, "");
	}
	return oEC;
}



/**  
* control object (invisible placeable)(ipoint) and heartbeat which manages timer effects, thanks to nytirs system
* @author
* @param 
* @see 
* @return 
*/
object CSLEnviroGetTimerControl( object oThingInTargetArea = OBJECT_SELF )
{
	object oModule = GetModule();
	object oEC = GetLocalObject( oModule, "ENVIRO_TIMER_CONTROL" );
	if( !GetIsObjectValid(oEC) )
	{
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		if (DEBUGGING >= 8) { CSLDebug("CSLEnviroGetTimerControl creating heartbeat object", GetFirstPC() ); }
		//SendMessageToPC( GetFirstPC(), "Environment Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		oEC = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation( oThingInTargetArea ), FALSE, "plc_environmentcontrol"); 
		
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oEC, TRUE);
		//SetEventHandler(oEC, SCRIPT_PLACEABLE_ON_HEARTBEAT, CSL_ENVIRO_HEARTBEAT_SCRIPT);
		SetLocalObject(oModule, "ENVIRO_TIMER_CONTROL", oEC);
	}
	return oEC;
}



/**  
* control object (invisible placeable)(ipoint) and heartbeat which manages weather effects, thanks to nytirs system
* @author
* @param 
* @see 
* @return 
*/
object CSLEnviroGetWeatherControl( object oThingInTargetArea = OBJECT_SELF )
{
	object oModule = GetModule();
	object oEC = GetLocalObject( oModule, "ENVIRO_WEATHER_CONTROL" );
	if( !GetIsObjectValid(oEC) )
	{
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		if (DEBUGGING >= 8) { CSLDebug("CSLEnviroGetControl creating heartbeat object", GetFirstPC() ); }
		//SendMessageToPC( GetFirstPC(), "Environment Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		oEC = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation( oThingInTargetArea ), FALSE, "plc_environmentcontrol"); 
		
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oEC, TRUE);
		//SetEventHandler(oEC, SCRIPT_PLACEABLE_ON_HEARTBEAT, CSL_ENVIRO_HEARTBEAT_SCRIPT);
		SetLocalObject(oModule, "ENVIRO_WEATHER_CONTROL", oEC);
		
		// go ahead and also start up enviro control.
		CSLEnviroGetControl( oThingInTargetArea );
	}
	return oEC;
}




/**  
* Converts the current Enviro Properties to a string
* @author
* @param 
* @see 
* @return 
*/
string CSLEnviroPropertiesToString( object oArea )
{
	int iCurrentWeather = GetLocalInt( oArea, "CSL_WEATHERSTATE") ;
	string sMessage = "Weather for Area "+GetName( oArea );
	int bShowRandom = FALSE;
	// deal with power
	if ( iCurrentWeather & CSL_WEATHER_POWER_WEAK )
	{
		sMessage += " Power is Weak(1)";
	}
	else if ( iCurrentWeather & CSL_WEATHER_POWER_LIGHT )
	{
		sMessage += " Power is Light(1)";
	}
	else if ( iCurrentWeather & CSL_WEATHER_POWER_MEDIUM )
	{
		sMessage += " Power is Medium(1)";
	}
	else if ( iCurrentWeather & CSL_WEATHER_POWER_HEAVY )
	{
		sMessage += " Power is Heavy(1)";
	}
	else if ( iCurrentWeather & CSL_WEATHER_POWER_STORMY )
	{
		sMessage += " Power is Stormy(1)";
	}
	else
	{
		sMessage += " Power is None(0)";
	}

	if ( iCurrentWeather &  CSL_WEATHER_TYPE_ACIDIC )
	{
		sMessage += ", Acidic";
	}
	if ( iCurrentWeather &  CSL_WEATHER_TYPE_FIERY )
	{
		sMessage += ", Fiery";
	}
	if ( iCurrentWeather &  CSL_WEATHER_TYPE_HAIL )
	{
		sMessage += ", Hail";
	}
	if ( iCurrentWeather &  CSL_WEATHER_TYPE_FLOOD )
	{
		sMessage += ", Flood";
	}
	if ( iCurrentWeather &  CSL_WEATHER_TYPE_THUNDER )
	{
		sMessage += ", Lightning";
	}
	
	// deal with power
	
	if ( iCurrentWeather & CSL_WEATHER_ATMOS_HAZE )
	{
		sMessage += ", Fog is haze";
	}
	else if ( iCurrentWeather & CSL_WEATHER_ATMOS_FOG )
	{
		sMessage += ", Fog is fog";
	}
	else if ( iCurrentWeather & CSL_WEATHER_ATMOS_SMOKE )
	{
		sMessage += ", Fog is smoke";
	}
	else if ( iCurrentWeather & CSL_WEATHER_ATMOS_BLACK )
	{
		sMessage += ", Fog is black";
	}
	else if ( iCurrentWeather & CSL_WEATHER_ATMOS_FIERY )
	{
		sMessage += ", Fog is red";
	}
	else if ( iCurrentWeather & CSL_WEATHER_ATMOS_ACIDIC )
	{
		sMessage += ", Fog is green";
	}
	else if ( iCurrentWeather & CSL_WEATHER_ATMOS_SAND )
	{
		sMessage += ", Fog is sand";
	}
	
	if ( iCurrentWeather & CSL_WEATHER_RANDOMLIGHTNING )
	{
		sMessage += ", Thunder";
		bShowRandom = TRUE;
	}
	if ( iCurrentWeather & CSL_WEATHER_RANDOMEXPLODE )
	{
		sMessage += ", Explosions";
		bShowRandom = TRUE;
	}
	if ( iCurrentWeather & CSL_WEATHER_RANDOMBOULDERS )
	{
		sMessage += ", Boulders";
		bShowRandom = TRUE;
	}
	if ( iCurrentWeather & CSL_WEATHER_RANDOMTORNADOS )
	{
		sMessage += ", Tornadoes";
		bShowRandom = TRUE;
	}
	if ( iCurrentWeather & CSL_WEATHER_RANDOMGUSTS )
	{
		sMessage += ", Wind Gusts";
		bShowRandom = TRUE;
	}
	
	if ( bShowRandom )
	{
		if ( iCurrentWeather & CSL_WEATHER_RANDOM_SELDOM )
		{
			sMessage += " Seldom";
		}
		else if ( iCurrentWeather & CSL_WEATHER_ATMOS_FIERY )
		{
			sMessage += " Often";
		}
		else
		{
			sMessage += " Rarely";
		}
	
	}
	return sMessage;
}





/**  
* Overall Area Manager control object (invisible placeable)(ipoint) and heartbeat which manages Areas, thanks to nytirs system
* @author
* @param 
* @see 
* @return 
*/
object CSLEnviroGetAreaManager( object oThingInTargetArea = OBJECT_SELF )
{
	object oModule = GetModule();
	//object oAM = GetLocalObject( oModule, "AREA_CONTROL" );
	object oAM = GetObjectByTag( "AREA_CONTROL" );
	if( !GetIsObjectValid(oAM) )
	{
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		
		//SendMessageToPC( GetFirstPC(), "Environment Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		oAM = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation( oThingInTargetArea ), FALSE, "AREA_CONTROL"); 
		
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oAM, TRUE);
		//SetEventHandler(oAM, SCRIPT_PLACEABLE_ON_HEARTBEAT, CSL_ENVIRO_HEARTBEAT_SCRIPT);
		//SetLocalObject(oModule, "AREA_CONTROL", oAM);
	}
	return oAM;
}

/**  
* Area control object (invisible placeable)(ipoint) and heartbeat which creatures in a given area, thanks to nytirs system
* contains all PC's and significant NPC's in an area
* areas wihtout this will have nothing going on so can be ignored
* ones that exist but without any active creatures in them can be cleaned up
* basically used to cache where things are - for scrying, area cleanup when folks leave an area 
* @author
* @param 
* @see 
* @return 
*/
object CSLEnviroGetAreaControl( object oArea, object oThingInTargetArea = OBJECT_SELF )
{
	object oAC = GetObjectByTag( "AREA_CONTROL_"+ObjectToString(oArea) );
	
	if( !GetIsObjectValid(oAC) )
	{
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		
		//SendMessageToPC( GetFirstPC(), "Environment Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		oAC = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation( oThingInTargetArea ), FALSE, "AREA_CONTROL_"+ObjectToString(oArea) ); 
		
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oAC, TRUE);
		
		object oAM = CSLEnviroGetAreaManager();
		SetLocalObject(oAM, "AREA_CONTROL_"+ObjectToString(oArea), oAC );
	}
	return oAC;
}








/**  
* Runs the correct script based on an areas state
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroEntryScriptByAreaState( object oPC, int iAreaState )
{
	if ( iAreaState == CSL_ENVIRO_NONE )
	{
		return; // nothing to do here
	}
	
	if ( iAreaState & CSL_ENVIRO_ACIDIC )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Acidic_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_AIRPOCKET )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_AirPocket_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_ANCHORED )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Anchored_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_BLINDING )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Blinding_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_BRIGHT )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Bright_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_CHAOS )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Chaos_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_COLD )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Cold_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_DARK )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Dark_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_DEADMAGIC )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_DeadMagic_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_DISEASE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Disease_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_FIRE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Fire_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_FLAMMABLE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Flammable_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_GALE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Gale_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_HARDTERRAIN )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_HardTerrain_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_HOLY )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Holy_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_LAW )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Law_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_LTVEGETATION )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_LtVegetation_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_MAGMA )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Magma_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_NEGATIVE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Negative_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_NOREST )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_NoRest_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_POISON )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Poison_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_POSITIVE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Positive_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_PROFANE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Profane_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_REST )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Rest_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_SLIPPERY )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Slippery_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_STENCH )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Stench_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_STORM )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Storm_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_TOWN )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Town_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_VEGETATION )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Vegetation_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_WATER )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Water_OnEnter", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_WILDMAGIC )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_WildMagic_OnEnter", oPC ) );
	}

}


/**  
* Runs the correct exit script based on the areas state
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroExitScriptByAreaState( object oPC, int iAreaState )
{
	if ( iAreaState == CSL_ENVIRO_NONE )
	{
		return; // nothing to do here
	}
	if ( iAreaState & CSL_ENVIRO_ACIDIC )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Acidic_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_AIRPOCKET )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_AirPocket_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_ANCHORED )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Anchored_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_BLINDING )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Blinding_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_BRIGHT )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Bright_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_CHAOS )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Chaos_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_COLD )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Cold_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_DARK )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Dark_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_DEADMAGIC )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_DeadMagic_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_DISEASE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Disease_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_FIRE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Fire_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_FLAMMABLE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Flammable_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_GALE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Gale_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_HARDTERRAIN )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_HardTerrain_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_HOLY )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Holy_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_LAW )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Law_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_LTVEGETATION )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_LtVegetation_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_MAGMA )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Magma_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_NEGATIVE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Negative_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_NOREST )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_NoRest_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_POISON )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Poison_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_POSITIVE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Positive_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_PROFANE )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Profane_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_REST )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Rest_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_SLIPPERY )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Slippery_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_STENCH )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Stench_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_STORM )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Storm_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_TOWN )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Town_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_VEGETATION )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Vegetation_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_WATER )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_Water_OnExit", oPC ) );
	}
	if ( iAreaState & CSL_ENVIRO_WILDMAGIC )
	{
		DelayCommand( CSLRandomBetweenFloat(0.5f, 1.5f), ExecuteScript( "TG_AM_WildMagic_OnExit", oPC ) );
	}
}




/**  
* Changes a triggers state dynamically
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroChangeTriggerState( object oArea, int iNewAreaState )
{
	int iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
	SetLocalInt( oArea, "CSL_ENVIRO",  iNewAreaState );
	
	// i am not using iCombinedAreaState, i just need to get a combined version so i can subtract out what has changed if anything
	int iCombinedAreaState = iAreaState | iNewAreaState;

	int iAddedStates = iCombinedAreaState & ~iAreaState;
	int iRemovedStates = iCombinedAreaState & ~iNewAreaState;
	
	if ( iAddedStates != 0  || iRemovedStates != 0 ) // if nothing is changed we don't have to iterate at all
	{
		object oPC;
		
		// this is an area or a trigger, not sure if i can refer to things in an area with a triggers iterator
		oPC = GetFirstInPersistentObject(oArea, OBJECT_TYPE_CREATURE); // object GetFirstObjectInArea(object oArea=OBJECT_INVALID);
		while(GetIsObjectValid(oPC))
		{	
			if ( iAddedStates != 0 )
			{
				CSLEnviroEntryScriptByAreaState( oPC, iAddedStates );
			}
			
			if ( iRemovedStates != 0 )
			{
				CSLEnviroExitScriptByAreaState( oPC, iRemovedStates );
			}
		
			oPC = GetNextInPersistentObject(oArea, OBJECT_TYPE_CREATURE); // object GetNextObjectInArea(object oArea=OBJECT_INVALID);
		}
	}
}


/**  
* Changes an areas state dynamically
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroChangeAreaState( object oArea, int iNewAreaState  )
{
	int iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
	SetLocalInt( oArea, "CSL_ENVIRO",  iNewAreaState );
	
	// i am not using iCombinedAreaState, i just need to get a combined version so i can subtract out what has changed if anything
	int iCombinedAreaState = iAreaState | iNewAreaState;

	int iAddedStates = iCombinedAreaState & ~iAreaState;
	int iRemovedStates = iCombinedAreaState & ~iNewAreaState;
	
	if ( iAddedStates != 0  || iRemovedStates != 0 ) // if nothing is changed we don't have to iterate at all
	{
		object oPC = GetFirstObjectInArea(oArea); // object GetFirstObjectInArea(oArea);
		while(GetIsObjectValid(oPC))
		{
			if ( GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC )  )
			{
				
				if ( iAddedStates != 0 )
				{
					CSLEnviroEntryScriptByAreaState( oPC, iAddedStates );
					//CSLAddLocalBit( oPC, "CSL_CHARSTATE", iAddedStates );
					//SetLocalObject( CSLEnviroGetControl(), ObjectToString(oPC), oPC );
				}
				
				if ( iRemovedStates != 0 )
				{
					CSLEnviroExitScriptByAreaState( oPC, iRemovedStates );
					//CSLSubLocalBit( oPC, "CSL_CHARSTATE", iRemovedStates );
				}
			}
			oPC = GetNextObjectInArea(oArea); // object GetNextObjectInArea(object oArea=OBJECT_INVALID);
		}
	}
}



/**  
* Change all the states of PC in a given area
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroChangeAreaCharacterState( object oArea, int iState, int bAddState = TRUE )
{
	object oPC = GetFirstObjectInArea(oArea); // object GetFirstObjectInArea(oArea);
	while(GetIsObjectValid(oPC))
	{
		if ( GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC )  )
		{
			
			if ( bAddState )
			{
				CSLAddLocalBit( oPC, "CSL_CHARSTATE", iState );
				SetLocalObject( CSLEnviroGetControl(), ObjectToString(oPC), oPC );
			}
			else
			{
				CSLSubLocalBit( oPC, "CSL_CHARSTATE", iState );
			}
		}
		oPC = GetNextObjectInArea(oArea); // object GetNextObjectInArea(object oArea=OBJECT_INVALID);
	}
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroObjectIsWithin( object oPC, int iEnvironmentType )
{
	int iSpellId = CSLEnviroGetSpellId( iEnvironmentType );
	if ( GetHasSpellEffect( iSpellId, oPC ) ) 
	{
		return TRUE;
	}
	
	// yes duplicated, have to choose this or the previous logic to actually handle how this works
	int iEnviroState = GetLocalInt( oPC, "CSL_ENVIRO" );
	if ( iEnviroState & iEnvironmentType )
	{
		return TRUE;
	}
	return FALSE;
}


/**  
* Get the Enviro state value for the given object/player
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroObjectGetStatus( object oPC )
{
	return GetLocalInt( oPC, "CSL_ENVIRO" );
}





/**  
* Returns true if target location has an AOE or trigger that matches iEnvironmentType
* @author
* @param 
* @see 
* @return TRUE or FALSE
*/
int CSLEnviroLocationIsWithin( location lTarget, int iEnvironmentType )
{
	object oSubArea = GetFirstSubArea( GetAreaFromLocation(lTarget), GetPositionFromLocation( lTarget ) );
	int iEnviroState = 0;
	while( GetIsObjectValid( oSubArea ) )
	{
		if ( GetLocalInt(oSubArea, "CSL_ENVIRO" ) & iEnvironmentType ) { return TRUE; }
		oSubArea = GetNextSubArea( GetAreaFromLocation(lTarget) );
	}
	return FALSE;
}

/**  
* Returns the Status for a given location, which can be looked at with bitwise math to see what conditions apply
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroLocationGetStatus( location lTarget )
{
	object oSubArea = GetFirstSubArea( GetAreaFromLocation(lTarget), GetPositionFromLocation( lTarget ) );
	int iEnviroState = 0;
	while( GetIsObjectValid( oSubArea ) )
	{
		iEnviroState |= GetLocalInt(oSubArea, "CSL_ENVIRO" );
		oSubArea = GetNextSubArea( GetAreaFromLocation(lTarget) );
	}
	return iEnviroState;
}









/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetEnviroStateSound( int iWeatherState  )
{
	if (iWeatherState & CSL_WEATHER_POWER_OFF )
	{
		return 0;
	}
	else if ( ( iWeatherState & CSL_WEATHER_POWER_WEAK || iWeatherState & CSL_WEATHER_POWER_LIGHT ) && iWeatherState & CSL_WEATHER_TYPE_RAIN )
	{
		return AMBIENT_RAINLIGHT;
	}
	else if ( iWeatherState & CSL_WEATHER_POWER_MEDIUM && iWeatherState & CSL_WEATHER_TYPE_RAIN )
	{
		return AMBIENT_RAINHARD;
	}
	else if ( ( iWeatherState & CSL_WEATHER_POWER_HEAVY || iWeatherState & CSL_WEATHER_POWER_STORMY ) && iWeatherState & CSL_WEATHER_TYPE_RAIN )
	{
		return AMBIENT_RAINSTORMY;
	}
	else if ( ( iWeatherState & CSL_WEATHER_POWER_WEAK || iWeatherState & CSL_WEATHER_POWER_LIGHT ) && iWeatherState & CSL_WEATHER_TYPE_WIND )
	{
		return AMBIENT_WINDSOFT;
	}
	else if ( iWeatherState & CSL_WEATHER_POWER_MEDIUM && iWeatherState & CSL_WEATHER_TYPE_WIND )
	{
		return AMBIENT_WINDMEDIUM;
	}
	else if ( ( iWeatherState & CSL_WEATHER_POWER_HEAVY || iWeatherState & CSL_WEATHER_POWER_STORMY ) && iWeatherState & CSL_WEATHER_TYPE_WIND )
	{
		return AMBIENT_WINDSTRONG;
	}
	else if ( iWeatherState & CSL_WEATHER_TYPE_FIERY )
	{
		return AMBIENT_LAVA;
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
int CSLEnviroGetEnviroStatePower( int iWeatherState  )
{
	if ( iWeatherState == 0) // short circuit if it's not set at all
	{
		return WEATHER_POWER_OFF;
	}
	if (iWeatherState & CSL_WEATHER_POWER_OFF )
	{
		return WEATHER_POWER_OFF;
	}
	else if ( iWeatherState & CSL_WEATHER_POWER_WEAK )
	{
		return WEATHER_POWER_WEAK;
	}
	else if ( iWeatherState & CSL_WEATHER_POWER_LIGHT )
	{
		return WEATHER_POWER_LIGHT;
	}
	else if ( iWeatherState & CSL_WEATHER_POWER_MEDIUM )
	{
		return WEATHER_POWER_MEDIUM;
	}
	else if ( iWeatherState & CSL_WEATHER_POWER_HEAVY )
	{
		return WEATHER_POWER_HEAVY;
	}
	else if ( iWeatherState & CSL_WEATHER_POWER_STORMY )
	{
		return WEATHER_POWER_STORMY;
	}
	return WEATHER_POWER_OFF;

}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroSetEnviroStatePower( int iWeatherState, int iWeatherPower  )
{
	
	iWeatherState &= ~CSL_WEATHER_POWER_OFF;
	iWeatherState &= ~CSL_WEATHER_POWER_WEAK;
	iWeatherState &= ~CSL_WEATHER_POWER_LIGHT;
	iWeatherState &= ~CSL_WEATHER_POWER_MEDIUM;
	iWeatherState &= ~CSL_WEATHER_POWER_HEAVY;
	iWeatherState &= ~CSL_WEATHER_POWER_STORMY;
	
	if ( iWeatherPower == WEATHER_POWER_OFF )
	{
		return iWeatherState | CSL_WEATHER_POWER_OFF;
	}
	else if ( iWeatherPower == WEATHER_POWER_WEAK )
	{
		return iWeatherState | CSL_WEATHER_POWER_WEAK;
	}
	else if ( iWeatherPower == WEATHER_POWER_LIGHT )
	{
		return iWeatherState | CSL_WEATHER_POWER_LIGHT;
	}
	else if ( iWeatherPower == WEATHER_POWER_MEDIUM )
	{
		return iWeatherState | CSL_WEATHER_POWER_MEDIUM;
	}
	else if ( iWeatherPower == WEATHER_POWER_HEAVY )
	{
		return iWeatherState | CSL_WEATHER_POWER_HEAVY;
	}
	else if ( iWeatherPower == WEATHER_POWER_STORMY )
	{
		return iWeatherState | CSL_WEATHER_POWER_STORMY;
	}
	else if ( iWeatherPower > WEATHER_POWER_STORMY )
	{
		return iWeatherState | CSL_WEATHER_POWER_STORMY;
	}
	else
	{
		return iWeatherState | CSL_WEATHER_POWER_OFF;
	}
	
	return iWeatherState;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetEnviroStateFrequency( int iWeatherState  )
{
	if ( iWeatherState == 0) // short circuit if it's not set at all
	{
		return WEATHER_FREQUENCY_SPORADIC;
	}
	
	if ( iWeatherState & CSL_WEATHER_RANDOM_RARELY )
	{
		return WEATHER_FREQUENCY_RARELY;
	}
	else if ( iWeatherState & CSL_WEATHER_RANDOM_SELDOM )
	{
		return WEATHER_FREQUENCY_SELDOM;
	}
	else if ( iWeatherState & CSL_WEATHER_RANDOM_OFTEN )
	{
		return WEATHER_FREQUENCY_OFTEN;
	}
	else
	{
		return WEATHER_FREQUENCY_SPORADIC;
	}
	return WEATHER_FREQUENCY_SPORADIC;
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroSetEnviroStateFrequency( int iWeatherState, int iWeatherFrequency  )
{
	
	iWeatherState &= ~CSL_WEATHER_RANDOM_RARELY;
	iWeatherState &= ~CSL_WEATHER_RANDOM_SELDOM;
	iWeatherState &= ~CSL_WEATHER_RANDOM_OFTEN;
	
	if ( iWeatherFrequency == WEATHER_FREQUENCY_SPORADIC )
	{
		return iWeatherState;
	}
	else if ( iWeatherFrequency == WEATHER_FREQUENCY_RARELY )
	{
		return iWeatherState | CSL_WEATHER_RANDOM_RARELY;
	}
	else if ( iWeatherFrequency == WEATHER_FREQUENCY_SELDOM )
	{
		return iWeatherState | CSL_WEATHER_RANDOM_SELDOM;
	}
	else if ( iWeatherFrequency == WEATHER_FREQUENCY_OFTEN )
	{
		return iWeatherState | CSL_WEATHER_RANDOM_OFTEN;
	}
	else if ( iWeatherFrequency > WEATHER_FREQUENCY_OFTEN )
	{
		return iWeatherState | CSL_WEATHER_RANDOM_OFTEN;
	}
	else
	{
		return iWeatherState;
	}
	
	return iWeatherState;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroAdjustEnviroStatePower( object oArea, int iPowerAdjust  )
{
	int iWeatherState = GetLocalInt( oArea, "CSL_WEATHERSTATE");
	int iOrigWeatherState = iWeatherState;
	
	int iWeatherPower = CSLEnviroGetEnviroStatePower( iWeatherState )+iPowerAdjust;
	
	if ( ( iWeatherPower + iPowerAdjust ) < 0 )
	{
		iWeatherState = CSL_WEATHER_TYPE_NONE; // removes all weather effects entirely, note this is actually a rare condition
	}
	else
	{
	
		iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, iWeatherPower  );
	}
	if ( iWeatherState != iOrigWeatherState )
	{
		CSLEnviroSetWeather( oArea, iWeatherState );
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroAdjustEnviroStateFrequency( object oArea, int iPowerAdjust  )
{
	int iWeatherState = GetLocalInt( oArea, "CSL_WEATHERSTATE");
	int iOrigWeatherState = iWeatherState;
	
	int iWeatherFrequency = CSLEnviroGetEnviroStateFrequency( iWeatherState )+iPowerAdjust;
	
	
	iWeatherState = CSLEnviroSetEnviroStateFrequency( iWeatherState, iWeatherFrequency  );
	if ( iWeatherState != iOrigWeatherState )
	{
		CSLEnviroSetWeather( oArea, iWeatherState );
	}
}

/*
brianmeyerdesign:  SRD 3.5 says: Torch: A torch burns for 1 hour, clearly illuminating a 20-foot
radius and providing shadowy illumination out to a 40- foot radius. If a torch is used in combat,
treat it as a one-handed improvised weapon that deals bludgeoning damage equal to that of a gauntlet
of its size, plus 1 point of fire damage.
*/

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
object CSLTorchGetControl( object oThingInTargetArea = OBJECT_SELF )
{
	object oAC = GetObjectByTag( "TORCH_CONTROL" );
	
	if( !GetIsObjectValid(oAC) )
	{
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		
		oAC = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation( oThingInTargetArea ), FALSE, "TORCH_CONTROL" ); 
		
		SetPlotFlag(oAC, TRUE);
		// make sure we have a heartbeat going
		CSLEnviroGetControl();
	}
	return oAC;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLTorchGetDuration( object oItem )
{
	int iDuration = GetLocalInt( oItem, "CSL_ROUNDSFUEL" );
	if ( ! iDuration )
	{
		iDuration = FloatToInt( HoursToSeconds(1) / 6 );
		SetLocalInt( oItem, "CSL_ROUNDSFUEL", iDuration );
		//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLTorchHeartBeat working on "+IntToString(count)+" objects" ); }
		if (DEBUGGING >= 8) { CSLDebug( "Your Torch has a duration of "+IntToString( iDuration ), GetItemPossessor(oItem) ); }
	}
	return iDuration;
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTorchExtinguish( object oItem, object oPC = OBJECT_SELF )
{
	if(GetIsObjectValid(oItem) && GetBaseItemType( oItem ) == BASE_ITEM_TORCH && GetResRef( oItem ) == "csl_torch"  )
	{
		SetLocalInt( oPC, "CSL_TORCH", FALSE );
		
		if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -SPELLABILITY_LITTORCH ) )
		{
			if ( GetLocalInt( oItem, "CSL_ROUNDSLIT" ) > CSLTorchGetDuration( oItem ) )
			{
				SendMessageToPC( oPC, "This Torch is Burned Out");
			}
		}
	//CSLRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_VISUALEFFECT, -1);
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTorchExtinguishObject( object oPC = OBJECT_SELF )
{
	SetLocalInt( oPC, "CSL_TORCH", FALSE );
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -SPELLABILITY_LITTORCH ) )
	{
		SendMessageToPC( oPC, "Your Torch Went Out");
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTorchLight( object oItem, object oPC = OBJECT_SELF )
{
	if(GetIsObjectValid(oItem) && GetBaseItemType( oItem ) == BASE_ITEM_TORCH && GetResRef( oItem ) == "csl_torch" )
	{
		//itemproperty ipAdd = ItemPropertyVisualEffect( ITEM_VISUAL_TORCH );
		//CSLRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_VISUALEFFECT, -1);
		//CSLSafeAddItemProperty(oItem, ipAdd);
		int iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" ); 
		int iSoaked = GetLocalInt( oPC, "CSL_SOAKED" );
		
		if ( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC ) != oItem )
		{
			ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND);
		}
		int iRoundsLit = GetLocalInt( oItem, "CSL_ROUNDSLIT" );
		if ( iCharState & CSL_CHARSTATE_SUBMERGED )
		{
			SetLocalInt( oPC, "CSL_TORCH", FALSE );
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -SPELLABILITY_LITTORCH );
			SendMessageToPC( oPC, "You can't light a torch underwater.");
		}
		else if ( iSoaked > 4 )
		{
			SetLocalInt( oPC, "CSL_TORCH", FALSE );
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -SPELLABILITY_LITTORCH );
			SendMessageToPC( oPC, "Your torch is wet, you need to wait and dry out a bit.");
		}
		else if ( iRoundsLit > CSLTorchGetDuration( oItem ) ) // 10 is low just to develop it all
		{
			SetLocalInt( oPC, "CSL_TORCH", FALSE );
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -SPELLABILITY_LITTORCH );
			SendMessageToPC( oPC, "This Torch is Burned Out");
		}
		else if ( !CSLEnviroGetIsHigherLevelDarknessEffectsInArea( GetLocation(oPC), 0, 5.0f) )
		{
			SetLocalInt( oPC, "CSL_TORCH", TRUE );
			string sAOETag = ""; // HkAOETag( oCaster, -SPELLABILITY_LITTORCH, iSpellPower, FALSE  );		
			effect eLight = EffectVisualEffect( VFXSC_DUR_LITTORCH );
			eLight = EffectLinkEffects(eLight, EffectAreaOfEffect(AOE_MOB_LIGHT) ); //, "", "", "", sAOETag) );
			eLight = SetEffectSpellId(eLight, -SPELLABILITY_LITTORCH );
			eLight = SupernaturalEffect(eLight);
			//HkApplyTargetTag( oTarget, oCaster, -SPELLABILITY_LITTORCH, fDuration  );
			ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLight, oPC );
		}
		else
		{
			SetLocalInt( oPC, "CSL_TORCH", FALSE );
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -SPELLABILITY_LITTORCH );
		}
   }
   
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTorchEquip( object oItem, object oPC = OBJECT_SELF )
{
	if(GetIsObjectValid(oItem) && GetBaseItemType( oItem ) == BASE_ITEM_TORCH && GetResRef( oItem ) == "csl_torch"  )
	{
		CSLTorchLight( oItem, oPC );
		SetLocalObject( CSLTorchGetControl(), ObjectToString( oItem ), oItem );
	}
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTorchUnEquip( object oItem, object oPC = OBJECT_SELF )
{
	if(GetIsObjectValid(oItem) && GetBaseItemType( oItem ) == BASE_ITEM_TORCH && GetResRef( oItem ) == "csl_torch"  )
	{
		CSLTorchExtinguish( oItem, oPC );
		DeleteLocalObject( CSLTorchGetControl(), ObjectToString( oItem ) );
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTorchToggle( object oItem, object oPC = OBJECT_SELF )
{
	if ( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC ) != oItem )
	{
		DelayCommand( 0.5f, ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND) );
	}
	else if ( GetHasSpellEffect( -SPELLABILITY_LITTORCH, oPC) )
	{
		CSLTorchExtinguish( oItem, oPC );
	}
	else
	{
		CSLTorchLight( oItem, oPC );
	}

}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLTorchHeartBeat()
{
	object oTC = CSLTorchGetControl();
	int count = GetVariableCount( oTC );
	
	int x;
	object oCurrent;
	string sCurrent;
	//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLTorchHeartBeat working on "+IntToString(count)+" objects" ); }
	for (x = count-1; x >= 0; x--) 
	{
		sCurrent = GetVariableName(oTC, x);
		oCurrent = GetVariableValueObject(oTC, x );

		if ( GetIsObjectValid( oCurrent ) )
		{
			
			int iRoundsLit = CSLIncrementLocalInt( oCurrent, "CSL_ROUNDSLIT", 1);
			//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLTorchHeartBeat working on Torch of "+GetName( GetItemPossessor(oCurrent) )+" has been lit for "+IntToString( iRoundsLit ) ); }
			if ( iRoundsLit > CSLTorchGetDuration( oCurrent ) ) // 10 is low just to develop it all
			{
				// go ahead and kill it
				CSLTorchExtinguish( oCurrent, GetItemPossessor(oCurrent) );
			}
			
			//object GetItemPossessor(object oItem);
			//CSLEnviroObjectHeartbeat( oCurrent );
		}
		else
		{
			DeleteLocalObject( oTC, sCurrent );
		}
	}
}




// * Toggles the fog

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroSetEnviroStateFog( int iWeatherState, int iFogState  )
{
	iWeatherState &= ~CSL_WEATHER_ATMOS_NONE;
	iWeatherState &= ~CSL_WEATHER_ATMOS_HAZE;
	iWeatherState &= ~CSL_WEATHER_ATMOS_FOG;
	iWeatherState &= ~CSL_WEATHER_ATMOS_SMOKE;
	iWeatherState &= ~CSL_WEATHER_ATMOS_BLACK;
	iWeatherState &= ~CSL_WEATHER_ATMOS_FIERY;
	iWeatherState &= ~CSL_WEATHER_ATMOS_ACIDIC;
	iWeatherState &= ~CSL_WEATHER_ATMOS_SAND;
	
	if ( iFogState == 0 )
	{
		return iWeatherState | CSL_WEATHER_ATMOS_NONE;
	}
	else if ( iFogState & CSL_WEATHER_ATMOS_HAZE )
	{
		return iWeatherState | CSL_WEATHER_ATMOS_HAZE;
	}
	else if ( iFogState & CSL_WEATHER_ATMOS_FOG )
	{
		return iWeatherState | CSL_WEATHER_ATMOS_FOG;
	}
	else if ( iFogState & CSL_WEATHER_ATMOS_SMOKE )
	{
		return iWeatherState | CSL_WEATHER_ATMOS_SMOKE;
	}
	else if ( iFogState & CSL_WEATHER_ATMOS_BLACK )
	{
		return iWeatherState | CSL_WEATHER_ATMOS_BLACK;
	}
	else if ( iFogState & CSL_WEATHER_ATMOS_FIERY )
	{
		return iWeatherState | CSL_WEATHER_ATMOS_FIERY;
	}
	else if ( iFogState & CSL_WEATHER_ATMOS_ACIDIC )
	{
		return iWeatherState | CSL_WEATHER_ATMOS_ACIDIC;
	}
	else if ( iFogState & CSL_WEATHER_ATMOS_SAND )
	{
		return iWeatherState | CSL_WEATHER_ATMOS_SAND;
	}
	else
	{
		return iWeatherState | CSL_WEATHER_ATMOS_NONE;
	}
	
	return iWeatherState;

}


// * Returns the Status for a given location, which can be looked at with bitwise math to see what conditions apply
// * if the position is exactly 0, it's considered false, so nothing can be at precisely at 0

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
float CSLEnviroGetWaterHeightAtLocation( location lTarget )
{
	object oArea = GetAreaFromLocation(lTarget);
	float fWaterHeight = 0.0f;
	float fNewWaterHeight = 0.0f;
	if ( GetLocalInt( oArea, "CSL_WEATHERSTATE" ) & CSL_WEATHER_TYPE_FLOOD )
	{
		fWaterHeight = GetLocalFloat(oArea, "CSL_WATERFLOODHEIGHT" );
	}
	else if ( GetLocalInt( oArea, "CSL_ENVIRO" ) & CSL_ENVIRO_WATER )
	{
		fNewWaterHeight = GetLocalFloat(oArea, "CSL_WATERSURFACEHEIGHT" );
		if ( fNewWaterHeight != 0.0f )
		{
			return fNewWaterHeight;
		}
		else
		{
			return 999999999999.99f; // a massive nonsense number
		}
	
	}
	
	object oSubArea = GetFirstSubArea( oArea, GetPositionFromLocation( lTarget ) );
	while( GetIsObjectValid( oSubArea ) )
	{
		if ( GetLocalInt(oSubArea, "CSL_ENVIRO" ) & CSL_ENVIRO_WATER )
		{
			fNewWaterHeight = GetLocalFloat(oSubArea, "CSL_WATERSURFACEHEIGHT" );
			if ( fNewWaterHeight != 0.0f )
			{
				if ( fWaterHeight == 0.0f || fWaterHeight < fNewWaterHeight )
				{
					fWaterHeight = fNewWaterHeight;
				}
			}
			else if ( GetObjectType( oSubArea ) == OBJECT_TYPE_TRIGGER )
			{
				fNewWaterHeight = CSLGetZFromObject( oSubArea );
				if ( fWaterHeight == 0.0f || fWaterHeight < fNewWaterHeight )
				{
					fWaterHeight = fNewWaterHeight;
				}
			}
		}
		oSubArea = GetNextSubArea( oArea );
	}
	return fWaterHeight;
}




/**  
* Description
* @deprecated
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroSlowingWater( object oPC, int iRateDecrease = 50 )
{
	if (DEBUGGING >= 4) { CSLDebug(  "CSLEnviroSlowingWater Slowing Factor="+IntToString(iRateDecrease), oPC ); }
	if ( CSLGetIsSwimmer( oPC ) )
	{
		iRateDecrease = 0;
	}
	
	if ( iRateDecrease == 0 || iRateDecrease != GetLocalInt( oPC, "CSL_WATERSLOWINGFACTOR" ) )
	{
		if (DEBUGGING >= 4) { CSLDebug(  "CSLEnviroSlowingWater Removing Previous Effect", oPC ); }
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_WATERSLOWING );
	}
	
	if ( iRateDecrease > 0 && !CSLHasSpellIdGroup( oPC, SPELLENVIRO_WATERSLOWING ) )
	{
		if (DEBUGGING >= 4) { CSLDebug( "CSLEnviroSlowingWater Applying new  Effect", oPC); }	
		SendMessageToPC( oPC, "Applying Water Slowing of "+IntToString( iRateDecrease ) );
		effect eWaterSlowing = SupernaturalEffect(EffectMovementSpeedDecrease( iRateDecrease ));
		eWaterSlowing = SetEffectSpellId(eWaterSlowing, SPELLENVIRO_WATERSLOWING );
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWaterSlowing, oPC);
	}
	SetLocalInt( oPC, "CSL_WATERSLOWINGFACTOR", iRateDecrease );
}


/**  
* Description
* @deprecated
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroSlowingTerrain( object oPC, int iRateDecrease = 50 )
{
	
	//if ( CSLGetIsSwimmer( oPC ) )
	//{
	//	iRateDecrease = 0;
	//}
	
	if ( iRateDecrease == 0 || iRateDecrease != GetLocalInt( oPC, "CSL_TERRAINSLOWINGFACTOR" ) )
	{
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_TERRAINSLOWING );
	}
	
	if ( iRateDecrease > 0 && !CSLHasSpellIdGroup( oPC, SPELLENVIRO_TERRAINSLOWING ))
	{
		SendMessageToPC( oPC, "Applying Terrain Slowing of "+IntToString( iRateDecrease ) );
		effect eTerrainSlowing = SupernaturalEffect(EffectMovementSpeedDecrease( iRateDecrease ));
		eTerrainSlowing = SetEffectSpellId(eTerrainSlowing, SPELLENVIRO_TERRAINSLOWING );
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTerrainSlowing, oPC);
	}
	SetLocalInt( oPC, "CSL_TERRAINSLOWINGFACTOR", iRateDecrease );
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroSlowing( object oPC, int iRateDecrease = 50 )
{
	
	//if ( CSLGetIsSwimmer( oPC ) )
	//{
	//	iRateDecrease = 0;
	//}
	
	if ( iRateDecrease == 0 || iRateDecrease != GetLocalInt( oPC, "CSL_ENVIROSLOWINGFACTOR" ) )
	{
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_SLOWING );
	}
	
	if ( iRateDecrease > 0 && !CSLHasSpellIdGroup( oPC, SPELLENVIRO_SLOWING ))
	{
		SendMessageToPC( oPC, "Applying Terrain Slowing of "+IntToString( iRateDecrease ) );
		effect eTerrainSlowing = SupernaturalEffect(EffectMovementSpeedDecrease( iRateDecrease ));
		eTerrainSlowing = SetEffectSpellId(eTerrainSlowing, SPELLENVIRO_SLOWING );
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTerrainSlowing, oPC);
	}
	SetLocalInt( oPC, "CSL_ENVIROSLOWINGFACTOR", iRateDecrease );
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroConcealmentTerrain( object oPC, int iRateConcealment = 50 )
{
	if ( iRateConcealment == 0 || iRateConcealment != GetLocalInt( oPC, "CSL_TERRAINCONCEALMENTFACTOR" ) )
	{
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_TERRAINSLOWING );
	}
	
	if ( iRateConcealment > 0 && !CSLHasSpellIdGroup( oPC, SPELLENVIRO_TERRAINSLOWING ))
	{
		SendMessageToPC( oPC, "Applying Terrain Concealment of "+IntToString( iRateConcealment ) );
		effect eConcealment = SupernaturalEffect(EffectConcealment( iRateConcealment, MISS_CHANCE_TYPE_VS_RANGED ));
		eConcealment = SetEffectSpellId(eConcealment, SPELLENVIRO_TERRAINSLOWING );
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConcealment, oPC);
	}
	SetLocalInt( oPC, "CSL_TERRAINCONCEALMENTFACTOR", iRateConcealment );
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroRemoveInvisibilityWhenInWater( object oPC = OBJECT_SELF )
{
	
	int bRemove = FALSE;
	effect eSearch = GetFirstEffect(oPC);
	while (GetIsEffectValid(eSearch))
	{
		int bRestart = FALSE;
		//Check to see if the effect matches a particular type defined below
		if ( GetEffectType(eSearch)==EFFECT_TYPE_INVISIBILITY || GetEffectType(eSearch)==EFFECT_TYPE_GREATERINVISIBILITY )
		{
			RemoveEffect(oPC, eSearch);
			bRemove = TRUE;
			bRestart = TRUE;
		}
		if (bRestart) eSearch = GetFirstEffect(oPC);
		else eSearch = GetNextEffect(oPC);
	}
	return bRemove;
}

// run on triggers and on every round water is active on a character

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroCheckWaterState( object oPC = OBJECT_SELF, int iCharState = -1, int iEnviroState = -1, int iAreaState = -1, int iWeatherState = -1 )
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	if (DEBUGGING >= 4) { CSLDebug( "CSLEnviroCheckWaterState Start",oPC ); }
	
	if ( iCharState == -1 )
	{
		iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" ); 
	}
	
	// iCharState is not being used, mainly for consistency
	object oArea = GetArea(oPC);
	if ( iEnviroState == -1 )
	{
		iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
		iEnviroState = GetLocalInt( oPC, "CSL_ENVIRO" );
		
		iEnviroState |= iAreaState;
	}
	
	if ( iWeatherState == -1 )
	{
		iWeatherState = GetLocalInt( GetArea(oPC), "CSL_WEATHERSTATE");
	}
	
	int bKnockDown = GetLocalInt( oPC, "CSL_KNOCKDOWN" );
	int iBurning = GetLocalInt( oPC, "CSL_BURNING" );
	
	
	
	// int iWaterState = GetLocalInt( oPC, "CSL_WATERSTATE" );
	
	
	//CSLEnviroObjectIsWithin( oPC, CSL_ENVIRO_WATER )
	//int iBreathholdingRounds = GetLocalInt( oPC, "CSL_BREATHHOLDING" );
	
	int iSoaked = GetLocalInt( oPC, "CSL_SOAKED" );
	
	// int iWaterState = GetLocalInt( oPC, "CSL_WATERSTATE" );
	
	// get the powerlevel 1-5 from the environment
	int iRainPower = GetWeather(oArea, WEATHER_TYPE_RAIN);
	int iSnowPower = GetWeather(oArea, WEATHER_TYPE_SNOW);
	int iThunderPower = GetWeather(oArea, WEATHER_TYPE_LIGHTNING);
	
	iSoaked = CSLGetMax( iSoaked, iRainPower );
	iSoaked = CSLGetMax( iSoaked, ( iSnowPower/2 ) );
	
	if (DEBUGGING >= 8) { CSLDebug(  "CSLEnviroCheckWaterState "+IntToString(iEnviroState), oPC ); }
	// Deal with water
	if ( ( iEnviroState & CSL_ENVIRO_WATER || iWeatherState & CSL_WEATHER_TYPE_FLOOD ) && !( iEnviroState & CSL_ENVIRO_AIRPOCKET ) )
	{
		if (DEBUGGING >= 4) { CSLDebug(  "CSLEnviroCheckWaterState Enviro is water", oPC ); }
		
		float fWaterLevel = GetLocalFloat( oPC, "CSL_WATERSURFACEHEIGHT" );
		if (DEBUGGING >= 6) { CSLDebug( "CSLEnviroCheckWaterState 1", oPC); }
		if ( iAreaState & CSL_ENVIRO_WATER ) // entire area is underater
		{
			float fNewWaterLevel = GetLocalFloat(oArea, "CSL_WATERSURFACEHEIGHT" );
			if ( fNewWaterLevel != 0.0f ) // there is a specific water level set, just use the areas level, means a flood usually
			{
				fWaterLevel = fNewWaterLevel;
			}
			else
			{
				fWaterLevel = 999999999999.99f; // a massive nonsense number
			}
		
		}
		else if ( iWeatherState & CSL_WEATHER_TYPE_FLOOD )
		{
			float fNewWaterLevel = GetLocalFloat(oArea, "CSL_WATERFLOODHEIGHT" );
			if ( fNewWaterLevel != 0.0f && fNewWaterLevel > fWaterLevel ) // there is a flood going on
			{
				fWaterLevel = fNewWaterLevel;
			}		
		}
		if (DEBUGGING >= 6) { CSLDebug(  "CSLEnviroCheckWaterState 5", oPC ); }
		 // set by triggers as character moves around
		//int bInWaterDeep = GetLocalInt( GetArea(oPC), "INWATER"); // set by the area itself
		float fZPosition = CSLGetZFromObject( oPC );
		
		if ( fZPosition+CSLGetCreatureHeight( oPC ) < fWaterLevel )
		{
			//iWaterState = CSL_WATERSTATE_SUBMERGED;
			//if (DEBUGGING >= 6) { SendMessageToPC( oPC, "CSLEnviroCheckWaterState 2" ); }
			iCharState = CSLEnviroToggleWaterStateBits( iCharState, CSL_CHARSTATE_SUBMERGED );
			//CSLEnviroSlowingWater( oPC, 50 );
			//if (DEBUGGING >= 6) { SendMessageToPC( oPC, "CSLEnviroCheckWaterState 3" ); }
			iSoaked = CSLGetMax( 21, iSoaked );
			CSLTorchExtinguishObject( oPC );
			if (DEBUGGING >= 4) { CSLDebug( "CSL_WATERSTATE_SUBMERGED DeepWater", oPC ); }
			
			
		}
		else if ( fZPosition > fWaterLevel )
		{
			//iWaterState = CSL_WATERSTATE_NONE;
			iCharState = CSLEnviroToggleWaterStateBits( iCharState, CSL_CHARSTATE_NONE );
			//CSLEnviroSlowingWater( oPC, 0 );
			if (DEBUGGING >= 4) { CSLDebug( "CSL_WATERSTATE_NONE ZPosition="+CSLFormatFloat( fZPosition )+" > WaterLevel="+CSLFormatFloat( fWaterLevel ), oPC ); }
		}
		else if ( bKnockDown > 0 || CSLGetHasEffectType( oPC, EFFECT_TYPE_SLEEP ) )
		{
			//iWaterState = CSL_WATERSTATE_SUBMERGED;
			// i can tie in emotes as well for this
			iCharState = CSLEnviroToggleWaterStateBits( iCharState, CSL_CHARSTATE_SUBMERGED );
			//CSLEnviroSlowingWater( oPC, 50 );
			
			// is there any other way to determine if they are prone/laying down in any way, need to check for that knock down effect as well. Will only happen if their feet are under water in some way.
			
			iSoaked = CSLGetMax( 11, iSoaked );
			if (DEBUGGING >= 4) { CSLDebug(  "CSL_WATERSTATE_SUBMERGED Prone", oPC ); }
		}
		else if ( fZPosition+CSLGetCreatureHeight( oPC )*0.8994f < fWaterLevel )
		{
			//iWaterState = CSL_WATERSTATE_SUBMERGED;
			//if (DEBUGGING >= 6) { SendMessageToPC( oPC, "CSLEnviroCheckWaterState 9" ); }
			iCharState = CSLEnviroToggleWaterStateBits( iCharState, CSL_CHARSTATE_SUBMERGED );
			//if (DEBUGGING >= 6) { SendMessageToPC( oPC, "CSLEnviroCheckWaterState 10" ); }
			//CSLEnviroSlowingWater( oPC, 50 );
			//if (DEBUGGING >= 6) { SendMessageToPC( oPC, "CSLEnviroCheckWaterState 11" ); }
			iSoaked = CSLGetMax( 16, iSoaked );
			if (DEBUGGING >= 4) {CSLDebug( "CSL_WATERSTATE_SUBMERGED ZPosition="+CSLFormatFloat( fZPosition )+" Height="+CSLFormatFloat( CSLGetCreatureHeight( oPC ) )+" * 0.8994f="+CSLFormatFloat( fZPosition+( CSLGetCreatureHeight( oPC )*0.8994f ) )+" < WaterLevel="+CSLFormatFloat( fWaterLevel ), oPC ); }
		}
		else if ( fZPosition+CSLGetCreatureHeight( oPC )*0.5f < fWaterLevel )
		{
			//if (DEBUGGING >= 6) { SendMessageToPC( oPC, "CSLEnviroCheckWaterState 6" ); }
			//CSLEnviroSlowingWater( oPC, 25 );
			//if (DEBUGGING >= 6) { SendMessageToPC( oPC, "CSLEnviroCheckWaterState 7" ); }
			//iWaterState = CSL_WATERSTATE_WADING;
			iCharState = CSLEnviroToggleWaterStateBits( iCharState, CSL_CHARSTATE_WADING );
			//if (DEBUGGING >= 6) { SendMessageToPC( oPC, "CSLEnviroCheckWaterState 8" ); }
			iSoaked = CSLGetMax( 4, iSoaked );
			if (DEBUGGING >= 4) {CSLDebug(  "CSL_WATERSTATE_WADING ZPosition="+CSLFormatFloat( fZPosition )+" Height="+CSLFormatFloat( CSLGetCreatureHeight( oPC ) )+" * 0.5f="+CSLFormatFloat( fZPosition+( CSLGetCreatureHeight( oPC )*0.5f ) )+" < WaterLevel="+CSLFormatFloat( fWaterLevel ), oPC ); }
		}
		else
		{
			//CSLEnviroSlowingWater( oPC, 10 );
			//iWaterState = CSL_WATERSTATE_SPLASHING;
			iCharState = CSLEnviroToggleWaterStateBits( iCharState, CSL_CHARSTATE_SPLASHING );
			iSoaked = CSLGetMax( 2, iSoaked );
			if (DEBUGGING >= 4) { CSLDebug(  "CSL_WATERSTATE_SPLASHING ZPosition="+CSLFormatFloat( fZPosition )+" Height="+CSLFormatFloat( CSLGetCreatureHeight( oPC ) )+" * 0.5f="+CSLFormatFloat( fZPosition+( CSLGetCreatureHeight( oPC )*0.5f ) )+" < WaterLevel="+CSLFormatFloat( fWaterLevel ), oPC ); }
		}
	}
	else if ( iCharState & ( CSL_CHARSTATE_SPLASHING | CSL_CHARSTATE_WADING | CSL_CHARSTATE_SUBMERGED ) )
	{
		//CSLEnviroSlowingWater( oPC, 0 );
		//iWaterState = CSL_WATERSTATE_NONE;
		iCharState = CSLEnviroToggleWaterStateBits( iCharState, CSL_CHARSTATE_NONE );
		if (DEBUGGING >= 4) { CSLDebug( "CSL_WATERSTATE_NONE Leaving Trigger", oPC ); }
	}
	
	if ( ( iCharState & ( CSL_CHARSTATE_SPLASHING | CSL_CHARSTATE_WADING | CSL_CHARSTATE_SUBMERGED ) || iSoaked > 3 ) && CSLEnviroRemoveInvisibilityWhenInWater(oPC) )
	{
		SendMessageToPC( oPC, "While you are invisible, the water makes you quite visible");
	}
	
	if ( iSoaked > 0 )
	{
		SetLocalInt( oPC, "CSL_SOAKED", iSoaked-1 ); // being soaked can persist after one leaves a water area
	}
	
	
	if ( iBurning )
	{
		if ( iCharState & CSL_CHARSTATE_SUBMERGED  || iCharState & CSL_CHARSTATE_WADING )
		{
			SendMessageToPC(oPC, "The water has extinguished the flames");
			CSLEnviroBurningExtinguish( oPC );
		}
		else
		{
			CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_BURNING );
		}
	}
	
	/*
	if ( iCharState & CSL_CHARSTATE_SUBMERGED   ) // || iCharState & CSL_CHARSTATE_WADING
	{
		CSLAnimationOverride( oPC, CSL_ANIMATEOVERRIDE_SWIMMING );
	}
	else if ( GetLocalInt( oPC, "CSL_ANIMATEOVERRIDE" ) )
	{
		CSLAnimationOverride( oPC, CSL_ANIMATEOVERRIDE_NONE );
	}
	*/
	
	SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
	//SetLocalInt( oPC, "CSL_WATERSTATE", iWaterState );
	
	return iCharState;
}


// run on triggers and on every round water is active on a character
// handles areas being blessed or cursed

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroCheckDeityState( object oPC = OBJECT_SELF, int iCharState = -1, int iEnviroState = -1, int iAreaState = -1 )
{
	
/*
int CSL_ENVIRO_HOLY			= BIT22; // * ( BOOSTS GOOD MAGIC, WEAKENSEVIL )
int CSL_ENVIRO_PROFANE		= BIT23; // * ( BOOSTS EVIL MAGIC, WEAKENS GOOD )
int CSL_ENVIRO_LAW			= BIT24; // * ( BOOSTS LAWFUL MAGIC, WEAKENS CHAOS )
int CSL_ENVIRO_CHAOS		= BIT25; // * ( BOOSTS CHAOS MAGIC, WEAKENS LAW )


	int CSL_CHARSTATE_HOLY			= BIT22; // * ( BOOSTS GOOD MAGIC, WEAKENSEVIL )
int CSL_CHARSTATE_PROFANE		= BIT23; // * ( BOOSTS EVIL MAGIC, WEAKENS GOOD )
int CSL_CHARSTATE_LAW			= BIT24; // * ( BOOSTS LAWFUL MAGIC, WEAKENS CHAOS )
int CSL_CHARSTATE_CHAOS			= BIT25; // * ( BOOSTS CHAOS MAGIC, WEAKENS LAW )
const int SPELLENVIRO_HOLY = -13;
const int SPELLENVIRO_PROFANE = -14;
const int SPELLENVIRO_LAWFUL = -15;
const int SPELLENVIRO_CHAOS = -16;


if ( iRateDecrease == 0 || iRateDecrease != GetLocalInt( oPC, "CSL_TERRAINSLOWINGFACTOR" ) )
	{
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_TERRAINSLOWING );
	}
	
	if ( iRateDecrease > 0 && !GetHasSpellEffect( SPELLENVIRO_TERRAINSLOWING, oPC ))
	{
		SendMessageToPC( oPC, "Applying Terrain Slowing of "+IntToString( iRateDecrease ) );
		effect eWaterSlowing = SupernaturalEffect(EffectMovementSpeedDecrease( iRateDecrease ));
		eWaterSlowing = SetEffectSpellId(eWaterSlowing, SPELLENVIRO_TERRAINSLOWING );
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWaterSlowing, oPC);
	}
	
	*/
	
	//SendMessageToPC( oPC, "CSLEnviroCheckDeityState Running2" );
	object oArea = GetArea(oPC);
	if ( iEnviroState == -1 )
	{
		iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
		iEnviroState = iAreaState | GetLocalInt( oPC, "CSL_ENVIRO" );
	}
	
	if ( iCharState == -1 )
	{
		iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );
	}
	
	//SendMessageToPC( oPC, "CSLEnviroCheckDeityState 2 iEnviroState="+IntToString( iEnviroState )+" iCharState="+IntToString( iCharState )+" and "+IntToString( GetHasSpellEffect( SPELLENVIRO_HOLY, oPC ) ) );
	
	// Deal with Consecrated Holy Areas
	if ( iEnviroState & CSL_ENVIRO_HOLY  )
	{
		if ( !GetHasSpellEffect( SPELLENVIRO_HOLY, oPC ) ) 
		{
			//SendMessageToPC( oPC, "CSLEnviroCheckDeityState does not have effect" );
			
			SetLocalInt( oPC, "CSL_CHARSTATE", iCharState | CSL_CHARSTATE_HOLY );
			effect eHolyEffects;
			if( CSLGetIsUndead( oPC, TRUE ) )
			{
				//SendMessageToPC( GetFirstPC(), "CSLEnviroCheckDeityState Applying Undead Effect" );
				eHolyEffects = EffectAttackDecrease(1);
				eHolyEffects = EffectLinkEffects( eHolyEffects, EffectDamageDecrease(1) );
				eHolyEffects = EffectLinkEffects( eHolyEffects, EffectSavingThrowDecrease(SAVING_THROW_ALL, 1) );
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_DIVINE), oPC);
			}
			else
			{
				//SendMessageToPC( GetFirstPC(), "CSLEnviroCheckDeityState Applying non-Undead Effect" );
				eHolyEffects = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
			}
			eHolyEffects = SupernaturalEffect(eHolyEffects);
			eHolyEffects = SetEffectSpellId(eHolyEffects, SPELLENVIRO_HOLY );
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHolyEffects, oPC);
		}
	}
	else if (  GetHasSpellEffect( SPELLENVIRO_HOLY, oPC ) )  // iCharState & CSL_CHARSTATE_HOLY ) //
	{
		//SendMessageToPC( oPC, "CSLEnviroCheckDeityState has effect going to remove" );
		iCharState &= ~CSL_CHARSTATE_HOLY;
		SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
		if (DEBUGGING >= 4) { CSLDebug( "CSLEnviroCheckDeityState Removing Effect", GetFirstPC() ); }
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_HOLY );
	}

	
	// Deal with Profane UnHoly Areas
	if ( iEnviroState & CSL_CHARSTATE_PROFANE  )
	{
		if ( !GetHasSpellEffect( SPELLENVIRO_PROFANE, oPC ) ) 
		{
			SetLocalInt( oPC, "CSL_CHARSTATE", iCharState | CSL_CHARSTATE_PROFANE );
			effect eProfaneEffects;
			if( CSLGetIsUndead( oPC, TRUE ) )
			{
				eProfaneEffects = EffectAttackIncrease(1);
				eProfaneEffects = EffectLinkEffects( eProfaneEffects, EffectDamageIncrease(1) );
				eProfaneEffects = EffectLinkEffects( eProfaneEffects, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1) );
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_HIT_NEGATIVE), oPC);
			}
			else
			{
				eProfaneEffects = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
			}
			eProfaneEffects = SupernaturalEffect(eProfaneEffects);
			eProfaneEffects = SetEffectSpellId(eProfaneEffects, SPELLENVIRO_PROFANE );
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eProfaneEffects, oPC);
		}
		
	}
	else if ( GetHasSpellEffect( SPELLENVIRO_PROFANE, oPC ) )  // iCharState & CSL_CHARSTATE_PROFANE ) //
	{
		//SendMessageToPC( oPC, "CSLEnviroCheckDeityState has effect going to remove" );
		iCharState &= ~CSL_CHARSTATE_PROFANE;
		SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
		//if (DEBUGGING >= 4) { SendMessageToPC( GetFirstPC(), "CSLEnviroCheckDeityState Removing Effect" ); }
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_PROFANE );
	}
	
	/*
	// Deal with Lawful Areas
	if ( iEnviroState & CSL_ENVIRO_LAW  )
	{
		if ( !iCharState & CSL_CHARSTATE_LAW )
		{
			SetLocalInt( oPC, "CSL_CHARSTATE", iCharState | CSL_CHARSTATE_LAW );
			effect eChaosEffects = SupernaturalEffect(EffectMovementSpeedDecrease( iRateDecrease ));
			eChaosEffects = SetEffectSpellId(eChaosEffects, SPELLENVIRO_LAWFUL );
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eChaosEffects, oPC);
		}
		
	}
	else if ( iCharState & CSL_CHARSTATE_LAW )
	{
		iCharState &= ~CSL_CHARSTATE_LAW;
		SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_LAWFUL );
	}
	
	// Deal with Chaos Areas
	if ( iEnviroState & CSL_ENVIRO_CHAOS  )
	{
		if ( !iCharState & CSL_CHARSTATE_CHAOS )
		{
			SetLocalInt( oPC, "CSL_CHARSTATE", iCharState | CSL_CHARSTATE_CHAOS );
			
			effect eLawfulEffects = SupernaturalEffect(EffectMovementSpeedDecrease( iRateDecrease ));
			eLawfulEffects = SetEffectSpellId(eLawfulEffects, SPELLENVIRO_CHAOS );
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLawfulEffects, oPC);
		}
		
	}
	else if ( iCharState & CSL_CHARSTATE_CHAOS )
	{
		iCharState &= ~CSL_CHARSTATE_CHAOS;
		SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_CHAOS );
	}
	*/
	return iCharState;
}



// run on triggers and on every round water is active on a character

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroCheckDeadMagicState( object oPC = OBJECT_SELF, int iCharState = -1, int iEnviroState = -1, int iAreaState = -1 )
{
	//object oArea = GetArea(oPC);
	if ( iEnviroState == -1 )
	{
		iAreaState = GetLocalInt( GetArea(oPC), "CSL_ENVIRO" );
		iEnviroState = iAreaState | GetLocalInt( oPC, "CSL_ENVIRO" );
	}
	
	if ( iCharState == -1 )
	{
		iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );
	}
	
	// Deal with deadmagic
	if ( iEnviroState & CSL_ENVIRO_DEADMAGIC  )
	{
		SetLocalInt( oPC, "HKPERM_Blocked", TRUE );
		SetLocalInt( oPC, "DEAD_MAGIC", TRUE );
		if ( !GetHasSpellEffect( SPELLENVIRO_DEADMAGIC, oPC ) ) 
		{
			
			iCharState |= CSL_CHARSTATE_DEADMAGIC;
			
			if ( CSLRemoveAllMagicalEffects( oPC ) ) // only removes the first time
			{
				SendMessageToPC( oPC, "All of your magical effects suddenly extinguish.");
				// save them so i can reapply later
			}
			
			ApplyEffectToObject( DURATION_TYPE_PERMANENT, SetEffectSpellId( EffectVisualEffect( VFXSC_PLACEHOLDER ), SPELLENVIRO_DEADMAGIC ), oPC );
	
			SetLocalInt( oPC, "CSL_CHARSTATE", iCharState  );
		}
		
	}
	else if (  GetHasSpellEffect( SPELLENVIRO_DEADMAGIC, oPC ) )
	{
		SetLocalInt( oPC, "HKPERM_Blocked", FALSE );
		SetLocalInt( oPC, "DEAD_MAGIC", FALSE );
		if ( iCharState & CSL_CHARSTATE_DEADMAGIC )
		{
			iCharState &= ~CSL_CHARSTATE_DEADMAGIC;
			SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
		}
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_DEADMAGIC );
		
		
		// reapply lost effects here
	}
	return iCharState;
}

// void CSLEnviroSlowing( object oPC, int iRateDecrease = 50 )

// run on triggers and on every round water is active on a character
/*
int CSLEnviroCheckTerrainState( object oPC = OBJECT_SELF, int iCharState = -1, int iEnviroState = -1, int iAreaState = -1 )
{
	//const int SPELLENVIRO_VEGETATION = -17;
	//const int SPELLENVIRO_LTVEGETATION = -18;
//effect EffectConcealment(25%, MISS_CHANCE_TYPE_VS_RANGED );
//const int CSL_CHARSTATE_LTVEGETATION	= BIT11; // * ( COVER )
//const int CSL_CHARSTATE_VEGETATION	= BIT12; // * ( MOVEMENT )
//const int CSL_CHARSTATE_SLIPPERY		= BIT13; // * ( MOVEMENT )
//const int CSL_CHARSTATE_HARDTERRAIN	= BIT14; // ( slow movement rocky, sand, mud )

	object oArea = GetArea(oPC);
	if ( iEnviroState == -1 )
	{
		iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
		iEnviroState = iAreaState | GetLocalInt( oPC, "CSL_ENVIRO" );
	}
	
	if ( iCharState == -1 )
	{
		iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );
	}
	
	int iRateDecrease = 0;
	
	if ( iEnviroState & CSL_ENVIRO_VEGETATION  )
	{
		iRateDecrease += 25;
		
		eVegetation = EffectConcealment(25%, MISS_CHANCE_TYPE_VS_RANGED );
		
		eHolyEffects = SupernaturalEffect(eVegetation);
		eHolyEffects = SetEffectSpellId(eVegetation, SPELLENVIRO_VEGETATION );
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVegetation, oPC);
		
	}
	
	else if ( GetHasSpellEffect( SPELLENVIRO_VEGETATION, oPC ) )  // iCharState & CSL_CHARSTATE_HOLY ) //
	{
		//SendMessageToPC( oPC, "CSLEnviroCheckDeityState has effect going to remove" );
		iCharState &= ~CSL_CHARSTATE_VEGETATION;
		SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
		if (DEBUGGING >= 4) { SendMessageToPC( GetFirstPC(), "CSLEnviroCheckTerrainState Removing Effect" ); }
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_VEGETATION );
	}
	
	
	
	if ( iEnviroState & CSL_ENVIRO_HARDTERRAIN  )
	{
		iRateDecrease += 50;
	}
	
	CSLEnviroSlowingTerrain( oPC, iRateDecrease );
	
	/*
	// Deal with deadmagic
	if ( iEnviroState & CSL_ENVIRO_DEADMAGIC  )
	{
		SetLocalInt( oPC, "HKPERM_Blocked", TRUE );
		SetLocalInt( oPC, "DEAD_MAGIC", TRUE );
		if ( !iCharState & CSL_CHARSTATE_DEADMAGIC )
		{
			SetLocalInt( oPC, "CSL_CHARSTATE", iCharState | CSL_CHARSTATE_DEADMAGIC );
			if ( CSLRemoveAllMagicalEffects( oPC ) ) // only removes the first time
			{
				SendMessageToPC( oPC, "All of your magical effects suddenly extinguish.");
			}
		}
		
	}
	else 
	{
		SetLocalInt( oPC, "HKPERM_Blocked", FALSE );
		SetLocalInt( oPC, "DEAD_MAGIC", FALSE );
		if ( iCharState & CSL_CHARSTATE_DEADMAGIC )
		{
			iCharState = iCharState - CSL_CHARSTATE_DROWNING;
			SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
		}
	}
	
	return iCharState;
}
*/


// void CSLEnviroSlowing( object oPC, int iRateDecrease = 50 )
// run on triggers and on every round water is active on a character

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroCheckSlowingState( object oPC = OBJECT_SELF, int iCharState = -1, int iEnviroState = -1, int iAreaState = -1 )
{
	//const int SPELLENVIRO_VEGETATION = -17;
	//const int SPELLENVIRO_LTVEGETATION = -18;
//effect EffectConcealment(25%, MISS_CHANCE_TYPE_VS_RANGED );
//const int CSL_CHARSTATE_LTVEGETATION	= BIT11; // * ( COVER )
//const int CSL_CHARSTATE_VEGETATION	= BIT12; // * ( MOVEMENT )
//const int CSL_CHARSTATE_SLIPPERY		= BIT13; // * ( MOVEMENT )
//const int CSL_CHARSTATE_HARDTERRAIN	= BIT14; // ( slow movement rocky, sand, mud )
// 
	
	
	object oArea = GetArea(oPC);
	if ( iEnviroState == -1 )
	{
		iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
		iEnviroState = iAreaState | GetLocalInt( oPC, "CSL_ENVIRO" );
	}
	
	if ( iCharState == -1 )
	{
		iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );
	}
	
	int iRateDecrease = 0;
	int iRateIncrease = 0;
	
	if ( !CSLGetIsSwimmer( oPC ) )
	{
		if ( iCharState & CSL_CHARSTATE_SUBMERGED  )
		{
			if ( GetHasFeat( FEAT_IMPROVED_SWIMMING, oPC ) )
			{
				iRateDecrease += 37;
			}
			else
			{
				iRateDecrease += 75;
			}
		}
		else if ( iCharState & CSL_CHARSTATE_WADING  )
		{
			if ( GetHasFeat( FEAT_IMPROVED_SWIMMING, oPC ) )
			{
				iRateDecrease += 25;
			}
			else
			{
				iRateDecrease += 50;
			}
		}
		else if ( iCharState & CSL_CHARSTATE_SPLASHING  )
		{
			if ( GetHasFeat( FEAT_IMPROVED_SWIMMING, oPC ) )
			{
				iRateDecrease += 12;
			}
			else
			{
				iRateDecrease += 25;
			}
		}
	}
	else if ( GetHasFeat( FEAT_IMPROVED_SWIMMING, oPC ) ) // swimmers with this get a speed increase
	{
		if ( iCharState & CSL_CHARSTATE_SUBMERGED  )
		{
			iRateIncrease += 50;
		}
		else if ( iCharState & CSL_CHARSTATE_WADING  )
		{
			iRateIncrease += 25;
		}
		else if ( iCharState & CSL_CHARSTATE_SPLASHING  )
		{
			iRateIncrease += 10;
		}
	}
	
	
	if ( !CSLGetIsFlying(oPC) )
	{
		if ( iEnviroState & CSL_ENVIRO_SLIPPERY  )
		{
			iRateDecrease += 10;
		}
		
		if ( iEnviroState & CSL_ENVIRO_VEGETATION && !GetHasFeat( FEAT_WOODLAND_STRIDE, oPC ) )
		{
			iRateDecrease += 25;
		}
		
		if ( iEnviroState & CSL_ENVIRO_HARDTERRAIN  )
		{
			if ( GetHasFeat( FEAT_IMPROVED_CLIMBING, oPC ) )
			{
				iRateDecrease += 25;
			}
			else
			{
				iRateDecrease += 50;
			}
		}
	}
	
	int iSurvival = GetSkillRank( SKILL_SURVIVAL, oPC )/2;
	
	// keep it within range
	iRateDecrease = CSLGetMax( 0, iRateDecrease-iSurvival);
	iRateDecrease = CSLGetMin( 85, iRateDecrease);
	
	CSLEnviroSlowing( oPC, iRateDecrease );
	
	return iCharState;
}

// run on triggers and on every round water is active on a character

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroCheckConcealmentState( object oPC = OBJECT_SELF, int iCharState = -1, int iEnviroState = -1, int iAreaState = -1 )
{
	object oArea = GetArea(oPC);
	if ( iEnviroState == -1 )
	{
		iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
		iEnviroState = iAreaState | GetLocalInt( oPC, "CSL_ENVIRO" );
	}
	
	
	
	if ( iCharState == -1 )
	{
		iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );
	}
	
	int iRateConcealment = 0;
	
	if ( iCharState & CSL_CHARSTATE_SUBMERGED )
	{
		//no damage, they are under water so can ignore it
		iRateConcealment += 50;
	}
	else if ( iCharState & CSL_CHARSTATE_WADING )
	{
		iRateConcealment += 25;
	}	
		
		
	
	if ( iCharState & CSL_CHARSTATE_LTVEGETATION  )
	{
		iRateConcealment += 10;
	}
	
	if ( iCharState & CSL_CHARSTATE_VEGETATION  )
	{
		iRateConcealment += 25;
	}
	
	CSLEnviroConcealmentTerrain( oPC, iRateConcealment );
	
	return iCharState;
}

/**  
* does fast updates of a character
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroCheckCharacterState( object oPC, int iEnvironmentType )
{
	// iEnvironmentType is the type of environments this covers
	/*
	if ( iEnviroState == -1 )
	{
		iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
		iEnviroState = iAreaState | GetLocalInt( oPC, "CSL_ENVIRO" );
	}
	
	
	int iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );
	*/
	
	if (DEBUGGING >= 8) { CSLDebug(  "CSLEnviroCheckCharacterState iEnvironmentType="+IntToString(iEnvironmentType)+" ", oPC ); }


	if ( iEnvironmentType & CSL_ENVIRO_DEADMAGIC )
	{
		CSLEnviroCheckDeadMagicState( oPC );
	}
	
	if ( iEnvironmentType & ( CSL_ENVIRO_WATER | CSL_ENVIRO_AIRPOCKET ) )
	{
		CSLEnviroCheckWaterState( oPC );
	}
	
	
	if ( iEnvironmentType & ( CSL_ENVIRO_HARDTERRAIN | CSL_ENVIRO_VEGETATION | CSL_ENVIRO_WATER | CSL_ENVIRO_AIRPOCKET ) )
	{
		// has to happen after water since it uses the character state bit
		CSLEnviroCheckSlowingState( oPC );
	}
	

	if ( iEnvironmentType & ( CSL_ENVIRO_HOLY | CSL_ENVIRO_PROFANE |  CSL_ENVIRO_CHAOS |  CSL_ENVIRO_LAW ) )
	{
		CSLEnviroCheckDeityState( oPC );
	}
	
	if ( iEnvironmentType & ( CSL_CHARSTATE_LTVEGETATION | CSL_ENVIRO_VEGETATION | CSL_ENVIRO_WATER | CSL_ENVIRO_AIRPOCKET  ) )
	{
		CSLEnviroCheckConcealmentState( oPC );
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroBarrier( object oTarget, int iVisualEffect = VFX_COM_HIT_FROST, string sMessage = "** Some type of barrier is impeding your travels. **", object oSubArea = OBJECT_SELF )
{
	AssignCommand( oTarget, ClearAllActions() );
	AssignCommand(oTarget, SetFacingPoint( GetPosition(oSubArea))); // fix the walking sideways issue
	ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(iVisualEffect), oTarget);
	
	location lTarget = CSLGetBehindLocation(oTarget, SC_DISTANCE_TINY);
	
	DelayCommand( 0.25f, AssignCommand(oTarget, JumpToLocation(lTarget)));
	DelayCommand( 0.5f, CSLMoveOutOfObject( oTarget, oSubArea, 2 ) ); // use this to make sure target is not in the given area
	if ( sMessage != "" )
	{
		FloatingTextStringOnCreature(sMessage, oTarget, FALSE);
	}
}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroBlock( location lTarget, object oTarget, int iVisualEffect = VFX_COM_HIT_FROST, string sMessage = "** Some type of barrier is impeding your travels. **", object oSubArea = OBJECT_SELF )
{
	if ( iVisualEffect != VFX_NONE )
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iVisualEffect), oTarget);
	}
	//location lTarget = CSLGetBehindLocation(oTarget);
	AssignCommand( oTarget, ClearAllActions() );
	DelayCommand( 0.25f, AssignCommand(oTarget, JumpToLocation(lTarget)));
	// DelayCommand( 0.5f, CSLMoveOutOfObject( oTarget, oSubArea, 2 ) ); // use this to make sure target is not in the given area
	
	if ( sMessage != "" )
	{
		FloatingTextStringOnCreature(sMessage, oTarget, FALSE);
	}
	
	
	
	/* if they are still in trigger or AOE, use this to get them out, need to build a helper delay function to implement this but use it as a safety check
	AssignCommand(oTarget, ClearAllActions(TRUE));
			AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));
	
	*/
}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroEntry( object oPC, int iEnvironmentType, object oEnviroObject = OBJECT_SELF )
{
	if ( !GetIsObjectValid( oPC )  ) { return; }
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	if ( oEnviroObject == OBJECT_INVALID )
	{
		int iSelfType = GetObjectType( OBJECT_SELF );
		if ( iSelfType == OBJECT_TYPE_CREATURE )
		{
			oEnviroObject = GetArea(oPC);
		}
		else if ( iSelfType == OBJECT_TYPE_TRIGGER )
		{
			oEnviroObject = OBJECT_SELF;
			// oPC =  GetEnteringObject();
		}
		else if ( iSelfType == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			oEnviroObject = GetAreaOfEffectCreator();
		}
		else
		{
			oEnviroObject = OBJECT_SELF;
		}
	
	}

	int iEnviroState = GetLocalInt( oPC, "CSL_ENVIRO" );
	iEnviroState |= iEnvironmentType; // bitwise add
	SetLocalInt( oPC, "CSL_ENVIRO", iEnviroState );
	
	if (DEBUGGING >= 2) { CSLDebug( "Entering 6 "+CSLEnviroStateToString(iEnvironmentType), oPC ); }

	//int iSpellId = ( iEnvironmentType+CSL_ENVIRO_SPELLIDSTART );
	int iSpellId = CSLEnviroGetSpellId( iEnvironmentType );
	// CSLIncrementLocalInt( oPC, "INWATER", 1 );
		//SendMessageToPC( oPC, "entry SpellId4="+IntToString(iSpellId) );
	// VFXSC_PLACEHOLDER = 1800 a blank visual effect basically
	// not sure if i even need both visual and the integer tracking the effect, will probably near the end pick the better option
	// but it might just make it easier to spot if a character has any effects in the range instead of checking 31 different effects
	/*if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), oPC, iSpellId );
	}
	else
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oPC, iSpellId );
	}
	*/
	ApplyEffectToObject( DURATION_TYPE_PERMANENT, SetEffectSpellId( EffectVisualEffect( VFXSC_PLACEHOLDER ), iSpellId ), oPC );
	
	// Need to register object to make sure it's being tracked here
	SetLocalObject( CSLEnviroGetControl(), ObjectToString(oPC), oPC );
	
	if ( iEnvironmentType & CSL_ENVIRO_WATER   )
	{
		float fWaterLevel = GetLocalFloat( GetArea(oPC), "CSL_WATERSURFACEHEIGHT" );
		if ( fWaterLevel == 0.0f && GetObjectType( oEnviroObject ) == OBJECT_TYPE_TRIGGER )
		{
			fWaterLevel = CSLGetZFromObject( oEnviroObject );
		}
		SetLocalFloat( oPC, "CSL_WATERSURFACEHEIGHT", fWaterLevel );
	}
	
	if ( iEnvironmentType & CSL_ENVIRO_WATER && CSLGetIsBlockedByWater(oPC)  )
	{
		CSLEnviroBlock( CSLGetBehindLocation(oPC, SC_DISTANCE_TINY), oPC, VFX_NONE, "** You cannot cross areas of water **", oEnviroObject );
	}
	
	if ( iEnvironmentType & CSL_ENVIRO_FIRE && CSLGetIsBlockedByFire(oPC)  )
	{
		CSLEnviroBlock( CSLGetBehindLocation(oPC, SC_DISTANCE_TINY), oPC, VFX_NONE, "** You cannot cross areas of fire **", oEnviroObject );
	}
	
	if ( iEnvironmentType & CSL_ENVIRO_ANCHORED  && CSLGetIsIncorporeal(oPC) )
	{
		CSLEnviroBarrier( oPC, VFX_COM_HIT_FROST, "** Some type of barrier is impeding your travels. **", oEnviroObject );
	}
	
	if (  iEnvironmentType & CSL_ENVIRO_STORM   )
	{
		SendMessageToPC(oPC, "You feel a Tingly feeling all over!");
	}
	
	CSLEnviroCheckCharacterState( oPC, iEnvironmentType );
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroExit( object oPC, int iEnvironmentType, object oEnviroObject = OBJECT_INVALID )
{
	if ( !GetIsObjectValid( oPC )  ) { return; }
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	if ( oEnviroObject == OBJECT_INVALID )
	{
		int iSelfType = GetObjectType( OBJECT_SELF );
		if ( iSelfType == OBJECT_TYPE_CREATURE )
		{
			oEnviroObject = GetArea(oPC);
		}
		else if ( iSelfType == OBJECT_TYPE_TRIGGER )
		{
			oEnviroObject = OBJECT_SELF;
			// oPC =  GetEnteringObject();
		}
		else if ( iSelfType == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			oEnviroObject = GetAreaOfEffectCreator();
		}
		else
		{
			oEnviroObject = OBJECT_SELF;
		}
	
	}
	
	int iEnviroState = GetLocalInt( oPC, "CSL_ENVIRO" );
	//int iSpellId = ( iEnvironmentType+CSL_ENVIRO_SPELLIDSTART );
	int iSpellId = CSLEnviroGetSpellId( iEnvironmentType );
	//SendMessageToPC( oPC, "exit SpellId4="+IntToString(iSpellId) );
	
	if (DEBUGGING >= 2) { CSLDebug( "Exiting 6 "+CSLEnviroStateToString(iEnvironmentType), oPC ); }
	// CSLDecrementLocalInt(oPC, "INWATER", 1);
	
	if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_AREA_OF_EFFECT )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_FIRSTONLYCREATOR, GetAreaOfEffectCreator(), oPC, iSpellId );
	}
	else
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_FIRSTONLYCREATOR, OBJECT_SELF, oPC, iSpellId );
	}
	/*
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, oPC, iSpellId ) )
	{
		if (DEBUGGING >= 2) { SendMessageToPC( oPC, "Removing tracking effect."); }
	}
	else
	{
		if (DEBUGGING >= 2) { SendMessageToPC( oPC, "Not removing tracking effect."); }
	}
	*/
	
	if (DEBUGGING >= 2) { CSLDebug( CSLAllEffectsToString( oPC ), oPC ); }
	//if ( GetHasSpellEffect( iSpellId, oPC ) ) 
	if ( CSLHasSpellIdGroup( oPC, iSpellId ) ) 
	{
		if (DEBUGGING >= 2) { CSLDebug( "still has tracking effect.", oPC ); }
	
	}
	else
	{
		if (DEBUGGING >= 2) { CSLDebug(  "does not have any tracking effect anymore.", oPC); }
		// remove the state var via bitwise math
		//if ( iEnviroState & iEnvironmentType )
		//{
			if (DEBUGGING >= 2) { CSLDebug( "Removing state var iEnvironmentType="+CSLEnviroStateToString(iEnvironmentType)+" from iEnviroState="+CSLEnviroStateToString(iEnviroState), oPC ); }
		//	iEnviroState = iEnviroState - iEnvironmentType;
		//	SetLocalInt( oPC, "CSL_ENVIRO", iEnviroState );
		//}
		iEnviroState &= ~iEnvironmentType;
		SetLocalInt( oPC, "CSL_ENVIRO", iEnviroState );
		//}
		
	}
	
	// leaving a trigger, only triggers can set height
	if ( iEnvironmentType & CSL_ENVIRO_WATER   )
	{
		// fixes issues with exiting a trigger and the true height is no longer known.
		// && GetObjectType( oEnviroObject ) == OBJECT_TYPE_TRIGGER
		float fWaterHeight = CSLEnviroGetWaterHeightAtLocation( GetLocation( oPC ) );
		if ( fWaterHeight != 0.0f )
		{
			// if it does not get a height, it just leaves the old height there
			SetLocalFloat( oPC, "CSL_WATERSURFACEHEIGHT", fWaterHeight );
		}
		
		if ( !(iEnviroState & CSL_ENVIRO_WATER) && CSLGetIsRestrainedByWater(oPC) )
		{
			CSLEnviroBlock( CSLGetBehindLocation(oPC), oPC, VFX_NONE, "** You cannot leave the water **" );
		}
	}
	CSLEnviroCheckCharacterState( oPC, iEnvironmentType );
}







/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroAreaEntry( object oPC, object oArea )
{
	if ( GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC )  )
	{
		SetLocalObject( CSLEnviroGetAreaControl( oArea ), ObjectToString(oPC), oPC );
		
		int iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
		
		CSLEnviroEntryScriptByAreaState( oPC, iAreaState );
		
		if ( GetLocalInt( GetArea(oPC), "CSL_WEATHERSTATE") )
		{
			CSLAddLocalBit( oPC, "CSL_CHARSTATE", CSL_CHARSTATE_WEATHER );
			SetLocalObject( CSLEnviroGetControl(), ObjectToString(oPC), oPC );
		}
	}
	
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroAreaExit( object oPC, object oArea )
{
	if (  GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC )  )
	{
		DeleteLocalObject( CSLEnviroGetAreaControl( oArea ), ObjectToString(oPC) );
		
		int iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
		
		CSLSubLocalBit( oPC, "CSL_CHARSTATE", CSL_CHARSTATE_WEATHER );
		
		CSLEnviroExitScriptByAreaState( oPC, iAreaState );
		
		DeleteLocalFloat( oPC, "CSL_WATERSURFACEHEIGHT" );
		
	}
}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroEquip( object oItem, object oPC = OBJECT_SELF )
{
	if(GetIsObjectValid(oItem) && GetBaseItemType( oItem ) == BASE_ITEM_TORCH && GetResRef( oItem ) == "csl_torch"  )
	{
		CSLTorchEquip( oItem, oPC );
	}
	
	
	//if ( GetBaseItemType( oItem ) == BASE_ITEM_ARMOR ) // BASE_ITEM_BOOTS
	//{
	
	//}
	
	return;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroUnequip( object oItem, object oPC = OBJECT_SELF )
{
	if(GetIsObjectValid(oItem) && GetBaseItemType( oItem ) == BASE_ITEM_TORCH && GetResRef( oItem ) == "csl_torch"  )
	{
		CSLTorchUnEquip( oItem, oPC );
	}
	return;
}

// randomly adjusts one area, this does not need to be that quick but the more areas involved will slow down changing

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroWeatherBeat()
{
	object oWC = CSLEnviroGetWeatherControl();
	int count = GetVariableCount( oWC );	
	
	if ( d100() > count )
	{
		return;
	
	}
	
	//sCurrent = GetVariableName(oEC, x);
	object oArea = GetVariableValueObject( oWC, Random(count) );
	
	if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroWeatherBeat working on adjusting "+GetName(oArea)+" out of "+IntToString(count)+" Areas with active weather", GetFirstPC() ); }
	
	//oArea = GetObjectByTag(sAreaTag);
	// Turn off any current weather effects
	if ( GetIsObjectValid( oArea ) )
	{
		int iCurrentWeather = GetLocalInt( oArea, "CSL_WEATHERSTATE") ;
		int iWeatherPower = CSLEnviroGetEnviroStatePower( iCurrentWeather );	
		iWeatherPower = CSLPickOneInt( iWeatherPower, iWeatherPower, iWeatherPower+1, iWeatherPower-1, iWeatherPower, iWeatherPower+1, iWeatherPower-1, iWeatherPower-1, iWeatherPower+2 );
		iWeatherPower = CSLGetWithinRange(iWeatherPower, 0, 5); // -2, -1, 0, +1, +2 to whatever the current weather is, tending towards no changes or an increase
		iCurrentWeather = CSLEnviroSetEnviroStatePower( iCurrentWeather, iWeatherPower );
		if (DEBUGGING >= 1 ) { CSLDebug( "CSLEnviroWeatherBeat changing adjusting "+GetName(oArea)+" power to "+IntToString(iWeatherPower)+" iCurrentWeather="+CSLWeatherStateToString(iCurrentWeather), GetFirstPC() ); }
		
		CSLEnviroSetWeather( oArea, iCurrentWeather );
		 
	}
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroThunderObject( object oArea, int bState = TRUE )
{
	if ( bState == TRUE )
	{
		object oObjectToDelete = GetObjectByTag("ab_ambientlightning"+ObjectToString(oArea) );
		if( GetIsObjectValid( oObjectToDelete ) )
		{
			DelayCommand( CSLRandomBetweenFloat(2.5f, 3.5f), DestroyObject(oObjectToDelete) ); // allow some overlap
		}
		
		object oCreated = CreateObject(OBJECT_TYPE_PLACED_EFFECT, ENVIRO_SEF_THUNDER, CSLGetCenterPointOfArea(oArea, 0.0f), FALSE, "ab_ambientlightning"+ObjectToString(oArea));
		if( GetIsObjectValid( oCreated ) )
		{
			if (DEBUGGING >= 1) { CSLDebug( "CSLEnviro Created Thunder Placeable", GetFirstPC() ); }
		}
		else
		{
			if (DEBUGGING >= 1) { CSLDebug( "CSLEnviro Failed to create Thunder Placeable", GetFirstPC() ); }
		}
		
		
		SetLocalInt( oArea, "CSL_THUNDEREPIRATIONROUND", CSLEnviroGetExpirationRound( 60.0f ) );
		
		
	}
	else
	{
		object oObjectToDelete = GetObjectByTag("ab_ambientlightning"+ObjectToString(oArea) );
		if( GetIsObjectValid( oObjectToDelete ) )
		{
			DelayCommand( CSLRandomBetweenFloat(2.5f, 3.5f), DestroyObject(oObjectToDelete) ); // allow some overlap
		}
		if (DEBUGGING >= 1) { CSLDebug( "CSLEnviro Deleting Thunder Placeable", GetFirstPC() ); }
		SetLocalInt( oArea, "CSL_THUNDEREPIRATIONROUND", -1 );
	
	}

}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroWeatherPeriodicEffects()
{
	if (DEBUGGING >= 1) { CSLDebug( "CSLEnviro Periodic Effects", GetFirstPC() ); }
	
	object oWC = CSLEnviroGetWeatherControl();
	int count = GetVariableCount( oWC );	
	int iCurrentRound = GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" );
	int iWeatherState;
	int iWeatherPower;
	location lLocation;
	int x;
	object oArea;
	string sArea;
	//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLTorchHeartBeat working on "+IntToString(count)+" objects" ); }
	for (x = count-1; x >= 0; x--) 
	{
		sArea = GetVariableName(oWC, x);
		oArea = GetVariableValueObject(oWC, x );

		if ( GetIsObjectValid( oArea ) )
		{
			iWeatherState = GetLocalInt( oArea, "CSL_WEATHERSTATE");
			iWeatherPower = CSLEnviroGetEnviroStatePower( iWeatherState );
			if ( iWeatherPower > 0 )
			{
				if( iWeatherState & CSL_WEATHER_TYPE_THUNDER )
				{
					//if (DEBUGGING >= 1) { SendMessageToPC( GetFirstPC(), "Current Round is "+IntToString(iCurrentRound)+" and expiration round is "+IntToString( GetLocalInt( oArea, "CSL_THUNDEREPIRATIONROUND") ) ); }
					if ( GetLocalInt( oArea, "CSL_THUNDEREPIRATIONROUND") < iCurrentRound )
					{
						CSLEnviroThunderObject( oArea, TRUE );
					}
				}
				
				if ( iWeatherState & CSL_WEATHER_RANDOM_OFTEN && d3() == 3 ||  ( iWeatherState & CSL_WEATHER_RANDOM_SELDOM && d6() == 6 ) ||  ( iWeatherState & CSL_WEATHER_RANDOM_RARELY && d12() == 12  ) ||  ( d20() == 20 )   )
				{
					if ( iWeatherState & CSL_WEATHER_RANDOMLIGHTNING )
					{
						if (DEBUGGING >= 1) { CSLDebug(  "CSLEnviro Random Lightning", GetFirstPC() ); }
						lLocation = CSLGetRandomSpotInArea( oArea, TRUE );
						CSLEnviroLighteningBolt( lLocation, lLocation, SHAPE_SPHERE, RADIUS_SIZE_HUGE, 20 );
					
					}
				}
				
				if ( iWeatherState & CSL_WEATHER_RANDOM_OFTEN && d3() == 3 ||  ( iWeatherState & CSL_WEATHER_RANDOM_SELDOM && d6() == 6 ) ||  ( iWeatherState & CSL_WEATHER_RANDOM_RARELY && d12() == 12  ) ||  ( d20() == 20 )   )
				{
					if ( iWeatherState & CSL_WEATHER_RANDOMEXPLODE )
					{
						if (DEBUGGING >= 1) { CSLDebug( "CSLEnviro Random Explosions", GetFirstPC() ); }
						lLocation = CSLGetRandomSpotInArea( oArea, TRUE );
						CSLExplosion( lLocation, lLocation, SHAPE_SPHERE, RADIUS_SIZE_HUGE, 20 );
					}
				}
				
				if ( iWeatherState & CSL_WEATHER_RANDOM_OFTEN && d3() == 3 ||  ( iWeatherState & CSL_WEATHER_RANDOM_SELDOM && d6() == 6 ) ||  ( iWeatherState & CSL_WEATHER_RANDOM_RARELY && d12() == 12  ) ||  ( d20() == 20 )   )
				{
					
					if ( iWeatherState & CSL_WEATHER_RANDOMBOULDERS )
					{
						if (DEBUGGING >= 1) { CSLDebug( "CSLEnviro Random Boulders", GetFirstPC() ); }
						lLocation = CSLGetRandomSpotInArea( oArea, TRUE );
					
					}
				}
				
				if ( iWeatherState & CSL_WEATHER_RANDOM_OFTEN && d3() == 3 ||  ( iWeatherState & CSL_WEATHER_RANDOM_SELDOM && d6() == 6 ) ||  ( iWeatherState & CSL_WEATHER_RANDOM_RARELY && d12() == 12  ) ||  ( d20() == 20 )   )
				{
					if ( iWeatherState & CSL_WEATHER_RANDOMTORNADOS )
					{
						if (DEBUGGING >= 1) { CSLDebug( "CSLEnviro Random Tornados", GetFirstPC() ); }
						lLocation = CSLGetRandomSpotInArea( oArea, TRUE );
					
					}
				}
				
				if ( iWeatherState & CSL_WEATHER_RANDOM_OFTEN && d3() == 3 ||  ( iWeatherState & CSL_WEATHER_RANDOM_SELDOM && d6() == 6 ) ||  ( iWeatherState & CSL_WEATHER_RANDOM_RARELY && d12() == 12  ) ||  ( d20() == 20 )   )
				{
					if ( iWeatherState & CSL_WEATHER_RANDOMGUSTS )
					{
						if (DEBUGGING >= 1) { CSLDebug( "CSLEnviro Random Wind", GetFirstPC() ); }
						CSLEnviroWindGust( CSLGetRandomSpotInArea( oArea, TRUE ), CSLGetRandomSpotInArea( oArea, TRUE ) ); // SHAPE_SPHERE
					}
				}
				
				if ( iWeatherState & CSL_WEATHER_TYPE_FLOOD && iWeatherState & CSL_WEATHER_TYPE_RAIN && iWeatherPower > 0)
				{
					SetLocalFloat(oArea, "CSL_WATERFLOODHEIGHT", GetLocalFloat(oArea, "CSL_WATERFLOODHEIGHT")+(IntToFloat(iWeatherPower)*0.025) ) ;
					
					CSLEnviroSetWeather( oArea, iWeatherState );
				
				}
			}
			//object GetItemPossessor(object oItem);
			//CSLEnviroObjectHeartbeat( oCurrent );
		}
		else
		{
			DeleteLocalObject( oWC, sArea );
		}
	}
	
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroAreaEffectsRemove( object oArea )
{
	string sTagName = "CSLEffectIn"+ObjectToString(oArea);
	
	int bDestroyed = FALSE;
	//int x;
	//for (x = count-1; x >= 0; x--) 
	//{
	
	int iCounter;
	object oObjectToDelete = GetObjectByTag(sTagName, iCounter);
	while( GetIsObjectValid( oObjectToDelete ) )
	{
		DelayCommand( CSLRandomBetweenFloat(2.5f, 3.5f), DestroyObject(oObjectToDelete) ); // allow some overlap
		iCounter++;
		oObjectToDelete = GetObjectByTag(sTagName, iCounter);
		bDestroyed = TRUE;
	}
	
	if ( bDestroyed )
	{
		if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroAreaEffectsRemove Cleared effects", GetFirstPC() ); }
	}
}




/**  
* Distributes Placed SEFS of size 10 by 10 generally evenly through an area
* @author
* @param oArea
* @param iTileX
* @param iTileY
* @param sSEFName is the various ENVIRO_SEF_SMOKE variables
* @param sTagName
* @param fheightAdjust
* @param iObjectType = OBJECT_TYPE_PLACEABLE, OBJECT_TYPE_PLACED_EFFECT
* @see 
* @return 
*/
void CSLEnviroTileEffectsFill( object oArea, int iTileX, int iTileY, string sSEFName, string sTagName, float fheightAdjust = 0.0f, int iObjectType = OBJECT_TYPE_PLACED_EFFECT )
{
	location lEffectPosition = CSLGetLocationByTileCoordinate( oArea, iTileX, iTileY, fheightAdjust ); // gets center point of tile at XY position

	CreateObject(iObjectType, sSEFName, lEffectPosition, FALSE, sTagName);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroTileEffectsFillFixed( object oArea, int iTileX, int iTileY, string sSEFName, string sTagName, float fheight = 0.0f, int iObjectType = OBJECT_TYPE_PLACED_EFFECT )
{
	location lEffectPosition = CSLGetLocationByTileCoordinateFixed( oArea, iTileX, iTileY, fheight ); // gets center point of tile at XY position

	CreateObject(iObjectType, sSEFName, lEffectPosition, FALSE, sTagName);
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroAreaEffectsFill( object oArea, string sSEFName, float fheightAdjust = 0.0f, int bRemovePrevious = FALSE, int iSpacing = 3, int iObjectType = OBJECT_TYPE_PLACED_EFFECT )
{
	if ( bRemovePrevious )
	{
		CSLEnviroAreaEffectsRemove( oArea );
	}
	
	// Make sure it's valid
	int iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	if ( iHeight == 0 )
	{
		oArea = GetArea(oArea);
		iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	}
	int iWidth = GetAreaSize( AREA_WIDTH, oArea );
	
	int iTileX;
	int iTileY;
	string sTagName = "CSLEffectIn"+ObjectToString(oArea);
	
	for (iTileX = iWidth; iTileX >= 0; iTileX--) 
	{
		if ( !( iTileX % iSpacing ) ) // only do the even ones
		{
			for (iTileY = iHeight; iTileY >= 0; iTileY--) 
			{
				if ( !( iTileY % iSpacing ) )
				{
					DelayCommand( CSLRandomBetweenFloat(1.0f, 4.0f),CSLEnviroTileEffectsFill( oArea, iTileX, iTileY, sSEFName, sTagName, fheightAdjust, iObjectType) );
				}
				/* Won't work until copyobject is made to work on other things.
				if ( GetIsObjectValid( oCreated ) )
				{
					CopyObject(oCreated, lEffectPosition );
					object oCreated = CreateObject(OBJECT_TYPE_PLACED_EFFECT, sSEFName, lEffectPosition, FALSE, sTagName);
				}
				else
				{
					object oCreated = CreateObject(OBJECT_TYPE_PLACED_EFFECT, sSEFName, lEffectPosition, FALSE, sTagName);
				}
				*/
			}
		}
	}
	
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroAreaEffectsFillFixed( object oArea, string sSEFName, float fheight = 0.0f, int bRemovePrevious = FALSE, int iSpacing = 3, int iObjectType = OBJECT_TYPE_PLACED_EFFECT )
{
	if ( bRemovePrevious )
	{
		CSLEnviroAreaEffectsRemove( oArea );
	}
	
	// Make sure it's valid
	int iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	if ( iHeight == 0 )
	{
		oArea = GetArea(oArea);
		iHeight = GetAreaSize( AREA_HEIGHT, oArea );
	}
	int iWidth = GetAreaSize( AREA_WIDTH, oArea );
	
	int iTileX;
	int iTileY;
	string sTagName = "CSLEffectIn"+ObjectToString(oArea);
	if (DEBUGGING >= 8) { CSLDebug(  "CSLEnviroAreaEffectsFillFixed filling with "+sSEFName, GetFirstPC() ); }
	for (iTileX = iWidth; iTileX >= 0; iTileX--) 
	{
		if ( !( iTileX % iSpacing ) ) // only do the even ones
		{
			for (iTileY = iHeight; iTileY >= 0; iTileY--) 
			{
				if ( !( iTileY % iSpacing ) )
				{
					DelayCommand( CSLRandomBetweenFloat(1.0f, 4.0f),CSLEnviroTileEffectsFillFixed( oArea, iTileX, iTileY, sSEFName, sTagName, fheight, iObjectType) );
				}
			}
		}
	}
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroSetGroundEffect( object oArea, int iGroundEffect = 0 ) 
{
	// lets see if we have a ground effect already
	object oGroundEffect = GetObjectByTag( "CSLEffectGroundIn"+ObjectToString(oArea) );
	int iCurrentGroundEffect = CSL_ENVIRO_GROUND_NONE;
	if	( GetIsObjectValid( oGroundEffect ) )
	{
		if ( iGroundEffect != CSL_ENVIRO_GROUND_NONE )
		{
			iCurrentGroundEffect = GetLocalInt( oGroundEffect, "CSLEFFECTTYPE");
		}
		
		
		if ( iGroundEffect == CSL_ENVIRO_GROUND_NONE || iGroundEffect != iCurrentGroundEffect )
		{
			DelayCommand( 1.0f, DestroyObject(oGroundEffect) );
		}
	}
	
	// create a ground effect if it does not match
	if ( iGroundEffect != iCurrentGroundEffect )
	{
		string sPlacedEffectName = "";
		if ( iGroundEffect == CSL_ENVIRO_GROUND_SNOW )
		{
			sPlacedEffectName = ENVIRO_SEF_SNOWGROUND;
		}
		else if ( iGroundEffect == CSL_ENVIRO_GROUND_SAND )
		{
			sPlacedEffectName = ENVIRO_SEF_SANDGROUND;
		}
		
		
		if ( sPlacedEffectName != "" )
		{
			oGroundEffect = CreateObject(OBJECT_TYPE_PLACED_EFFECT, sPlacedEffectName, CSLGetCenterPointOfArea( oArea ), FALSE, "CSLEffectGroundIn"+ObjectToString(oArea) );
			SetLocalInt( oGroundEffect, "CSLEFFECTTYPE", iGroundEffect);
		}
	}

}





/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLSetNWN2Fog( object oTarget, int nColor, float fFogStart, float fFogEnd)
{
	SetNWN2Fog( oTarget, FOG_TYPE_NWN2_SUNRISE, nColor, fFogStart, fFogEnd );
	SetNWN2Fog( oTarget, FOG_TYPE_NWN2_DAYTIME, nColor, fFogStart, fFogEnd );
	SetNWN2Fog( oTarget, FOG_TYPE_NWN2_SUNSET, nColor, fFogStart, fFogEnd );
	SetNWN2Fog( oTarget, FOG_TYPE_NWN2_MOONRISE, nColor, fFogStart, fFogEnd );
	SetNWN2Fog( oTarget, FOG_TYPE_NWN2_NIGHTTIME, nColor, fFogStart, fFogEnd );
	SetNWN2Fog( oTarget, FOG_TYPE_NWN2_MOONSET, nColor, fFogStart, fFogEnd );
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLResetNWN2Fog(object oTarget )
{
	ResetNWN2Fog( oTarget, FOG_TYPE_NWN2_SUNRISE);
	ResetNWN2Fog( oTarget, FOG_TYPE_NWN2_DAYTIME);
	ResetNWN2Fog( oTarget, FOG_TYPE_NWN2_SUNSET);
	ResetNWN2Fog( oTarget, FOG_TYPE_NWN2_MOONRISE);
	ResetNWN2Fog( oTarget, FOG_TYPE_NWN2_NIGHTTIME);
	ResetNWN2Fog( oTarget, FOG_TYPE_NWN2_MOONSET);
}





/**  
* handles atmosphere, rain and fog in one function
* Used to set the weather as needed, once set it will randomly vary either decreasing or decreasing
* using CSL_WEATHER_TYPE_NONE for weather state will change the weather to none at all
* Note that the weather does visuals and the random damage effects ( lightning, fireballs, acid
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroSetWeather( object oArea, int iWeatherState )
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	// GetLocalObject( CSLEnviroGetWeatherControl(), ObjectToString(oArea) );
	SetLocalObject( CSLEnviroGetWeatherControl(), ObjectToString(oArea), oArea );
	//object oLC = CSLEnviroLightningControl( oArea );
	int iAreaState = GetLocalInt( oArea, "CSL_ENVIRO" );
	int iOldWeatherState = GetLocalInt( oArea, "CSL_WEATHERSTATE");
	float fWaterLevel = GetLocalFloat(oArea, "CSL_WATERFLOODHEIGHT" );
	float fPrevWaterLevel = GetLocalFloat(oArea, "CSL_PREVWATERFLOODHEIGHT" );
		
	//if (DEBUGGING >= 1) { SendMessageToPC( GetFirstPC(), "CSLEnviroSetWeather setting weather to "+CSLWeatherStateToString(iWeatherState)+" in area "+GetName(oArea)+" from "+CSLWeatherStateToString(iOldWeatherState) ); }
	
	
	int iWeatherType = -1;
	int iWeatherPower = -1;
	int nRainSound = 0;
	int bRemovePreviousEfectFill = TRUE;
	
	
	if ( iWeatherState & CSL_WEATHER_TYPE_FLOOD && fWaterLevel != fPrevWaterLevel ) 
	{
		// must rerun now
	}
	else if ( iOldWeatherState == iWeatherState )
	{
		//if (DEBUGGING >= 1) { SendMessageToPC( GetFirstPC(), "CSLEnviroSetWeather Nothing to change" ); }
		return;
	}
	
	
	if ( iWeatherState == 0 )
	{
		//if (DEBUGGING >= 1) { SendMessageToPC( GetFirstPC(), "CSLEnviroSetWeather clearing weather in area "+GetName(oArea) ); }
		// reset the area settings, turn off the volume since we have no idea what the volume shoult be.
		SetWeather(oArea, WEATHER_TYPE_INVALID, WEATHER_POWER_USE_AREA_SETTINGS);
		CSLResetNWN2Fog(oArea);
		AmbientSoundStop(oArea);
				
		int iTrueAreaAmbientSound = GetLocalInt( oArea, "CSL_AMBIENTSOUND" );
		if ( iTrueAreaAmbientSound != 0 )
		{
			AmbientSoundChangeDay(oArea, iTrueAreaAmbientSound);
			AmbientSoundChangeNight(oArea, iTrueAreaAmbientSound);
			AmbientSoundSetNightVolume(oArea, 50);
			AmbientSoundSetDayVolume(oArea, 50);
			AmbientSoundPlay(oArea);
		}
		else
		{
			AmbientSoundChangeDay(oArea, 0);
			AmbientSoundChangeNight(oArea, 0);
			AmbientSoundSetNightVolume(oArea, 0);
			AmbientSoundSetDayVolume(oArea, 0);
			//AmbientSoundPlay(oArea);
		}
		DeleteLocalObject( CSLEnviroGetWeatherControl(), ObjectToString(oArea) );
		DelayCommand( 0.5f, CSLEnviroAreaEffectsRemove( oArea ) );
		CSLEnviroSetGroundEffect( oArea, CSL_ENVIRO_GROUND_NONE );
		//CSLEnviroSetFloodEffect( oArea, CSL_ENVIRO_GROUND_NONE );
		SetLocalInt( oArea, "CSL_WEATHERSTATE", 0 );
		
		CSLEnviroThunderObject( oArea, FALSE );
		//object oPC = GetFirstInPersistentObject(oArea, OBJECT_TYPE_CREATURE); // object GetFirstObjectInArea(oArea);
		//while(GetIsObjectValid(oPC))
		//{
		//	if ( GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC )  )
		//	{
		//		CSLSubLocalBit( oPC, "CSL_CHARSTATE", CSL_CHARSTATE_WEATHER );
		//	}
	//		oPC = GetNextInPersistentObject(oArea, OBJECT_TYPE_CREATURE); // object GetNextObjectInArea(object oArea=OBJECT_INVALID);
	//	}
		
		CSLEnviroChangeAreaCharacterState( oArea, CSL_CHARSTATE_WEATHER, FALSE );
		return;
	}
	else
	{
		//if (DEBUGGING >= 1) { SendMessageToPC( GetFirstPC(), "CSLEnviroSetWeather adjusting weather in area "+GetName(oArea) ); }
		iWeatherPower = CSLEnviroGetEnviroStatePower( iWeatherState );
		nRainSound = CSLEnviroGetEnviroStateSound( iWeatherState );
		
		if( iWeatherState & CSL_WEATHER_TYPE_FLOOD )
		{
			//float fWaterLevel = 0.0f;
			
			//if (  fOldWaterLevel != 0.0f )
			//{
			//	fWaterLevel = fOldWaterLevel + ( 1.0f*iWeatherPower );
			//}
			
			
			//fWaterLevel = CSLGetZFromObject( GetFirstPC() );
			//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLEnviroSetWeather Making flood at "+FloatToString(fWaterLevel) ); }
			if ( fWaterLevel != fPrevWaterLevel )
			{
				bRemovePreviousEfectFill = TRUE;
			}
			CSLEnviroAreaEffectsFillFixed( oArea, CSL_WATERLEVELPLACEABLE, fWaterLevel, bRemovePreviousEfectFill, 6, OBJECT_TYPE_PLACEABLE );
			SetLocalFloat(oArea, "CSL_WATERFLOODHEIGHT", fWaterLevel );
			SetLocalFloat(oArea, "CSL_PREVWATERFLOODHEIGHT", fWaterLevel );
			bRemovePreviousEfectFill = FALSE;
		}
		
		
		
		
		
		//Deal with sound effects
		if (iWeatherState & CSL_WEATHER_TYPE_RAIN )
		{
			//if (DEBUGGING >= 1) { SendMessageToPC( GetFirstPC(), "Setting Up Rain Power = "+IntToString( iWeatherPower ) ); }
			SetWeather(oArea, WEATHER_TYPE_RAIN, iWeatherPower );
			if ( iWeatherState & CSL_WEATHER_ATMOS_ACIDIC )
			{
				if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather Making acidic rain", GetFirstPC() ); }
				DelayCommand( 0.5f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_ACIDICRAIN, 0.0f, bRemovePreviousEfectFill ) );
				bRemovePreviousEfectFill = FALSE;
			}
		}
		else
		{
			//if (DEBUGGING >= 1) { SendMessageToPC( GetFirstPC(), "Turning off rain" ); }
			SetWeather(oArea, WEATHER_TYPE_RAIN, WEATHER_POWER_OFF ); // always leave it on rain
		}
		
		
		
		if( ( iWeatherState & CSL_WEATHER_TYPE_THUNDER ) ) // delete the thunder right away
		{
			CSLEnviroThunderObject( oArea, TRUE );
		}
		else
		{
			CSLEnviroThunderObject( oArea, FALSE );
		}
		
		
		
		
		
		//Deal with sound effects
		if ( nRainSound && GetLocalInt( oArea, "CSL_WEATHERSOUND") != nRainSound )
		{
			SetLocalInt( oArea, "CSL_WEATHERSOUND", nRainSound);
			AmbientSoundStop(oArea);
			AmbientSoundChangeDay(oArea, nRainSound);
			AmbientSoundSetDayVolume(oArea, 50);
			AmbientSoundChangeNight(oArea, nRainSound);
			AmbientSoundSetNightVolume(oArea, 50);
			AmbientSoundPlay(oArea);
		}
		else if ( !nRainSound )
		{
			AmbientSoundSetNightVolume(oArea, 0);
			AmbientSoundSetDayVolume(oArea, 0);
		}
		
		
		
		if ( iWeatherState & CSL_WEATHER_TYPE_SNOW )
		{
			//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLEnviroSetWeather weather  set to snow" ); }
			
			if ( iWeatherState & CSL_WEATHER_POWER_WEAK || iWeatherState & CSL_WEATHER_POWER_LIGHT )
			{
				if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather weather  set to weak snow", GetFirstPC() ); }
				DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_SNOWLIGHT, 0.0f, bRemovePreviousEfectFill ) );
				bRemovePreviousEfectFill = FALSE;
			}
			else if ( iWeatherState & CSL_WEATHER_POWER_MEDIUM )
			{
				if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather weather  set to medium snow", GetFirstPC() ); }
				DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_SNOWMEDIUM, 0.0f, bRemovePreviousEfectFill ) );
				bRemovePreviousEfectFill = FALSE;
			}
			else if ( iWeatherState & CSL_WEATHER_POWER_HEAVY || iWeatherState & CSL_WEATHER_POWER_STORMY)
			{
				if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather weather  set to stormy snow", GetFirstPC() ); }
				DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_SNOWHEAVY, 0.0f, bRemovePreviousEfectFill ) );
				bRemovePreviousEfectFill = FALSE;
			}
		}
		
		
		// set up ground effects
		if ( iWeatherState & CSL_WEATHER_TYPE_SNOW )
		{
			CSLEnviroSetGroundEffect( oArea, CSL_ENVIRO_GROUND_SNOW ); 
		}
		else if ( iWeatherState & CSL_WEATHER_ATMOS_SAND )
		{
			CSLEnviroSetGroundEffect( oArea, CSL_ENVIRO_GROUND_SAND ); 
		}
		else
		{
			CSLEnviroSetGroundEffect( oArea, CSL_ENVIRO_GROUND_NONE );
		}
		
		/*
		if ( iWeatherPower == WEATHER_POWER_OFF ) // iWeatherState & CSL_WEATHER_ATMOS_NONE || 
		{
			if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLEnviroSetWeather weather  set to no visual effects" ); }
			CSLResetNWN2Fog(oArea);
			if (  bRemovePreviousEfectFill )
			{
				DelayCommand( 0.5f, CSLEnviroAreaEffectsRemove( oArea ) );
			}
		}
		else 
		*/
		if ( iWeatherState & CSL_WEATHER_ATMOS_HAZE )
		{
			if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather fog  set to haze", GetFirstPC() ); }
			CSLSetNWN2Fog( oArea, COLOR_WHITE, 35.0f-(iWeatherPower*3.0f), 180.0f-(iWeatherPower*16.0f) );
			DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_WHITEHAZE, 0.0f, bRemovePreviousEfectFill ) );
			bRemovePreviousEfectFill = FALSE;
		}
		else if ( iWeatherState & CSL_WEATHER_ATMOS_FOG )
		{
			if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather fog  set to fog", GetFirstPC() ); }
			CSLSetNWN2Fog( oArea,  COLOR_WHITE, 30.0f-(iWeatherPower*4.0f), 125.0f-(iWeatherPower*5.0f));
			DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_WHITEFOG, 0.0f, bRemovePreviousEfectFill ) );
			bRemovePreviousEfectFill = FALSE;
		}
		else if ( iWeatherState & CSL_WEATHER_ATMOS_SMOKE )
		{
			if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather fog  set to smoke", GetFirstPC() ); }
			CSLSetNWN2Fog( oArea,  COLOR_GREY, 35.0f-(iWeatherPower*2.0f), 160.0f-(iWeatherPower*5.0f));
			DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_SMOKE, 0.0f, bRemovePreviousEfectFill ) );
			bRemovePreviousEfectFill = FALSE;
		}
		else if ( iWeatherState & CSL_WEATHER_ATMOS_BLACK )
		{
			if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather fog  set to black", GetFirstPC() ); }
			CSLSetNWN2Fog( oArea,  COLOR_BLACK, 40.0f-(iWeatherPower*2.0f), 160.0f-(iWeatherPower*5.0f));
			DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_BLACKFOG, 0.0f, bRemovePreviousEfectFill ) );
			bRemovePreviousEfectFill = FALSE;
		}
		else if ( iWeatherState & CSL_WEATHER_ATMOS_FIERY )
		{
			if (DEBUGGING >= 8) { CSLDebug(  "CSLEnviroSetWeather fog  set to fiery", GetFirstPC() ); }
			CSLSetNWN2Fog( oArea,  COLOR_RED, 40.0f-(iWeatherPower*2.0f), 160.0f-(iWeatherPower*5.0f));
			DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_REDFOG, 0.0f, bRemovePreviousEfectFill ) );
			bRemovePreviousEfectFill = FALSE;
		}
		else if ( iWeatherState & CSL_WEATHER_ATMOS_ACIDIC )
		{
			if (DEBUGGING >= 8) { CSLDebug(  "CSLEnviroSetWeather fog  set to acidic", GetFirstPC() ); }
			CSLSetNWN2Fog( oArea,  COLOR_GREEN, 40.0f-(iWeatherPower*2.0f), 160.0f-(iWeatherPower*5.0f));
			DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_GREENFOG, 0.0f, bRemovePreviousEfectFill ) );
			bRemovePreviousEfectFill = FALSE;
		}
		else if ( iWeatherState & CSL_WEATHER_ATMOS_SAND )
		{
			if (DEBUGGING >= 8) { CSLDebug(  "CSLEnviroSetWeather fog  set to sand", GetFirstPC() ); }
			CSLSetNWN2Fog( oArea,  COLOR_BROWN, 15.0f-(iWeatherPower*3.0f), 100.0f-(iWeatherPower*15.0f));
			//DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_ORANGEFOG, 0.0f, bRemovePreviousEfectFill ) );
			
			DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_SANDSTORM, 0.0f, bRemovePreviousEfectFill ) );
			bRemovePreviousEfectFill = FALSE;
		}
		else if ( iWeatherState & CSL_WEATHER_TYPE_SNOW )
		{
			if (DEBUGGING >= 8) { CSLDebug(  "CSLEnviroSetWeather fog  set to snow", GetFirstPC() ); }
			CSLSetNWN2Fog( oArea,  COLOR_WHITE, 30.0f-(iWeatherPower*5.0f), 120.0f-(iWeatherPower*15.0f));
			DelayCommand( 1.0f, CSLEnviroAreaEffectsFill( oArea, ENVIRO_SEF_ORANGEFOG, 0.0f, bRemovePreviousEfectFill ) );
			bRemovePreviousEfectFill = FALSE;
		}
		else
		{
			if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroSetWeather weather  set to no visual effects", GetFirstPC() ); }
			CSLResetNWN2Fog(oArea);
			if (  bRemovePreviousEfectFill )
			{
				DelayCommand( 0.5f, CSLEnviroAreaEffectsRemove( oArea ) );
			}
		}
		SetLocalInt( oArea, "CSL_WEATHERSTATE", iWeatherState );
		
		//object oPC = GetFirstInPersistentObject(oArea, OBJECT_TYPE_CREATURE); // object GetFirstObjectInArea(oArea);
		//while(GetIsObjectValid(oPC))
		//{
		//	if ( GetIsPC( oPC ) || GetIsOwnedByPlayer( oPC )  )
		//	{
		//		CSLAddLocalBit( oPC, "CSL_CHARSTATE", CSL_CHARSTATE_WEATHER );
		//		SetLocalObject( CSLEnviroGetControl(), ObjectToString(oPC), oPC );
		//	}
		//	oPC = GetNextInPersistentObject(oArea, OBJECT_TYPE_CREATURE); // object GetNextObjectInArea(object oArea=OBJECT_INVALID);
		//}
		if ( !iOldWeatherState )
		{
			CSLEnviroChangeAreaCharacterState( oArea, CSL_CHARSTATE_WEATHER );
		}
	}
}



/**  
* Gets the round a given effect is going to expire
* Used to store an expiration time for later usage
* Dependant on the current round number being constantly updated in this implementation
* probably can revise so it uses the servers uptime instead
* might be good to tag the session as well to remove the issue of effects cast on a previous session
* designed to approximate results
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetExpirationRound( float fDuration )
{
	int iCurrentRound = GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" );
	
	if ( iCurrentRound == 0 )
	{
		// heartbeat is not running yet, lets start it, might give folks an extra round for the first time half the time, but it should already be started in the module events.
		// attached to environment since that is doing other work this is combined with
		CSLEnviroGetControl();
	}
	
	// int iRoundsDuration = FloatToInt( fDuration / 6.0f );
	
	//return iCurrentRound + iRoundsDuration;
	return ( iCurrentRound + FloatToInt( fDuration/6.0f )  );
}


/**  
* Gets the remaining duration based on the expiration round
* Used to store an expiration time for later usage
* Only works in rounds but it can be off by up to a round or so
* @author
* @param 
* @see 
* @return 
*/
float CSLEnviroGetRemainingDuration( int iExpirationRound )
{
	int iCurrentRound = GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" );
	
	int iRemainingDuration = iExpirationRound - iCurrentRound;
	
	if ( iExpirationRound == 0 || iRemainingDuration <= 0 ) 
	{
		return 0.0f;
	}
	return RoundsToSeconds(iRemainingDuration);
}


/**  
* Enviro Control Heart Beat
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroControlHB()
{
	
	
	object oEC = CSLEnviroGetControl();
	object oModule = GetModule();
	int iCurrentRound = GetLocalInt( oModule, "CSL_CURRENT_ROUND" )+1;
	SetLocalInt( oModule, "CSL_CURRENT_ROUND", iCurrentRound );
	
	// string get the current time in minutes
	// get the current beat number since module start
	// get the current
	
	
	/*
	// Loop thru the PCs
	object oPC;
	oPC = GetFirstPC();
	while ( GetIsObjectValid( oPC ) )
	{
		// Add in other heartbeat checks here, make sure everything here is very optimized as it gets run a lot
		// Need to look at how this gets implemented in the long run
		//SendMessageToPC( oPC, "Heart beating");
		
		
		
		checkHeartBeatElaborateParry( oPC );
		checkHeartBeatDeadlyDefense( oPC );
		checkHeartBeatTwoWeaponDefense( oPC );
		
		// This is probably obsolete
		// Note that this is only for the MP Invis fix, and if not used the entire heartbeat could be removed, and if used this variable check should be removed as well
		//if ( GetLocalInt( GetModule(), "SC_MPINVISFIX" ) == TRUE )
		//{
		//	// this checks for the invisibility status, and removes or adds it as needed
		//	SCHeartBeatInvisCheck( oPC );
		//}
		
		
		oPC = GetNextPC();
	}
	*/
	
	

	int count = GetVariableCount( oEC );
	
	if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroControlHB working on "+IntToString(count)+" objects", GetFirstPC() ); }
	int x;
	object oCurrent;
	string sCurrent;
	int iEnviroStatus = 0;
	int iCharStatus = 0;

	for (x = count-1; x >= 0; x--) 
	{
		sCurrent = GetVariableName(oEC, x);
		oCurrent = GetVariableValueObject(oEC, x );
		
		
		if (DEBUGGING >= 8) { CSLDebug( "iterating on "+sCurrent+" for objects #"+IntToString(count)+" "+GetName( oCurrent ), GetFirstPC() ); }
		if ( GetIsObjectValid( oCurrent ) )
		{
			if ( GetIsObjectValid(GetArea(oCurrent)) && !GetLocalInt(oCurrent, "TRANSITION") ) // make sure they are not in process of a transition - just wait until they are done
			{
				iEnviroStatus = GetLocalInt( oCurrent, "CSL_ENVIRO" );
				iCharStatus = GetLocalInt( oCurrent, "CSL_CHARSTATE" );
				if ( iEnviroStatus == CSL_ENVIRO_NONE && iCharStatus == CSL_CHARSTATE_NONE )
				{
					if (DEBUGGING >= 8) { CSLDebug( "Removing "+sCurrent, GetFirstPC() ); }
					DeleteLocalObject( oEC, sCurrent ); // no status, we can stop tracking
				}
				else
				{
					// Do the drowning things, or whatever else here.
					// One branch for each state perhaps or all the logic in one place
					//ExecuteScript(SCR_EX_VD, oCurrent);
					//LaunchCoverFire(sArmy, ACS_BRR); //Barrage
					//LaunchCoverFire(sArmy, ACS_CTP); //Catapult
					// Drown effects
					// Lights
					DelayCommand(CSLRandomUpToFloat(0.5f),CSLEnviroObjectHeartbeat( oCurrent, oEC ));
				}
			}
		}
		else
		{
			DeleteLocalObject( oEC, sCurrent );
		}
	}
	
	//int iWeatherTicks = 15;
	//int iLightningTicks = 3;
	//if ( !( iCurrentRound % iWeatherTicks ) )
	//{
	
	
	if (DEBUGGING >= 5) { CSLDebug( "Main Beat "+IntToString(iCurrentRound), GetFirstPC() ); }
	// round is 6 seconds
	if ( iCurrentRound % 10 == 0 )
	{
		// minute event
		if (DEBUGGING >= 5) { CSLDebug( "Minute Beat "+IntToString(iCurrentRound), GetFirstPC() ); }
		DelayCommand(CSLRandomUpToFloat(3.0f), ExecuteScript("_mod_ontimeminute", GetModule() ) );
		
		if ( iCurrentRound % 150 == 0 )
		{
			if (DEBUGGING >= 5) { CSLDebug( "Quarter Beat "+IntToString(iCurrentRound), GetFirstPC() ); }
			DelayCommand(CSLRandomUpToFloat(5.0f), ExecuteScript("_mod_ontimequarter", GetModule() ) );
			
			if ( iCurrentRound % 600 == 0 )
			{
				if (DEBUGGING >= 5) { CSLDebug( "Hour Beat "+IntToString(iCurrentRound), GetFirstPC() ); }
				DelayCommand(CSLRandomUpToFloat(5.0f), ExecuteScript("_mod_ontimehour", GetModule() ) );
			}
		}
	}
	
	
	CSLEnviroWeatherBeat(); // changes weather
	
	if ( !( iCurrentRound % 2 ) )
	{
		CSLEnviroWeatherPeriodicEffects(); // causes periodic effects
	}	
	
	CSLTorchHeartBeat();

}




/**  
* Heals or harms a target, and if a player hits double the max they explode
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroApplyPositiveEffect( object oTarget, int nDamage)
{
	if ( CSLGetIsUndead( oTarget, TRUE ) )
	{
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
		eDam = EffectLinkEffects(eDam, EffectVisualEffect( VFX_HIT_SPELL_HOLY ));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	}
	else
	{
		effect eHealing;
		effect eDam;
		float fDelay;
		int iDamage;
		location lTarget = GetLocation(oTarget);
		int iMaxHitpoints = GetMaxHitPoints(oTarget);
		int iCurrentHitpoints = GetCurrentHitPoints(oTarget);
		int iNewHitPoints = iCurrentHitpoints+nDamage-iMaxHitpoints;
		
		
		
		int nHitDice = CSLGetMax( iMaxHitpoints / 20, 1 );
		if ( iNewHitPoints > iMaxHitpoints*2 )
		{
			// explode them
			effect eExplode = EffectVisualEffect( VFXSC_FNF_EXPLODE_POSITIVE );
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget );
			object oCurrentTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
			while (GetIsObjectValid(oCurrentTarget))
			{
				
					//Fire cast spell at event for the specified target
					//SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FIREBALL, TRUE ));
					//Get the distance between the explosion and the target to calculate delay
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oCurrentTarget))/20;
					
						//Roll damage for each target
						iDamage = d6(nHitDice);

						//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
						iDamage = GetReflexAdjustedDamage(iDamage, oCurrentTarget, 10+nHitDice, DAMAGE_TYPE_POSITIVE);
						//Set the damage effect
						if(iDamage > 0)
						{
							// Apply effects to the currently selected target.
							DelayCommand(fDelay, CSLEnviroApplyPositiveEffect( oCurrentTarget, iDamage ) );
						}
					
				
				//Select the next target within the spell shape.
				oCurrentTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_PLACEABLE);
			}
			
		}
		else if ( iCurrentHitpoints+nDamage > iMaxHitpoints )
		{
			
			
			if ( iCurrentHitpoints < iMaxHitpoints )
			{
				// heal em back to max real fast
				int iHealAmount = iMaxHitpoints-iCurrentHitpoints;
				eHealing = EffectHeal(iHealAmount);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealing, oTarget);
				nDamage = nDamage - iHealAmount;
			}
			
			
			// remove previous fixes
			if ( nDamage )
			{
				effect eHealing = EffectTemporaryHitpoints(nDamage);
				eHealing = EffectLinkEffects(eHealing, EffectVisualEffect( VFX_HIT_SPELL_HOLY ));
				CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, EFFECT_TYPE_TEMPORARY_HITPOINTS );
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealing, oTarget);
			}
		}
		else
		{
			// just heal em
			eHealing = EffectHeal(nDamage);
			eHealing = EffectLinkEffects(eHealing, EffectVisualEffect( VFX_HIT_SPELL_HOLY ));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealing, oTarget);
		}
	}

}



/**  
* EnviroObjectHeartbeatEvent
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroObjectHeartbeat( object oPC, object oEC )
{
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	
	if ( !GetIsObjectValid( oPC ) || !GetIsObjectValid( GetArea(oPC) ) || GetLocalInt( oPC, "TRANSITION" ) )
	{
		return;
	}
	
	int iPreviousHitpoints = GetLocalInt( oPC, "CSL_CURRENTHPS"  );
	
	if (DEBUGGING >= 8) { CSLDebug(  "CSLEnviroObjectHeartbeat",oPC ); }
	
	int iAreaState = GetLocalInt( GetArea(oPC), "CSL_ENVIRO" );
	
	int iCurrentWeather = GetLocalInt( GetArea(oPC), "CSL_WEATHERSTATE");
	
	int iEnviroState = iAreaState | GetLocalInt( oPC, "CSL_ENVIRO" );
	int iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );
	
	
	int iSoaked = GetLocalInt( oPC, "CSL_SOAKED" );
	
	// **********************************
	// **          Slippery            **
	// **********************************
	// has to happen prior to water depth since if they are knocked down, they will be affected by being underwater
	if ( iEnviroState & CSL_ENVIRO_SLIPPERY && !CSLGetIsIncorporeal( oPC ) && !GetIsImmune( oPC, IMMUNITY_TYPE_KNOCKDOWN ) ) 
	{
		if ( CSLCompareLastPosition( oPC, "LASTLOC" ) )
		{
			// need to check for motion, they can't slip if they hold still
			int iSaveDC = 15+iSoaked;
			if( !ReflexSave(oPC, iSaveDC, SAVING_THROW_TYPE_NONE, oEC ) ) // HkSavingThrow(SAVING_THROW_REFLEX, oPC, iSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
			{
				if ( !GetIsImmune( oPC, IMMUNITY_TYPE_KNOCKDOWN ) )
				{
					effect eSlippery = ExtraordinaryEffect( EffectKnockdown() );
					// eSlippery = EffectLinkEffects(eSlippery, EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT) );
					eSlippery = SetEffectSpellId(eSlippery, -SPELL_GREASE);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlippery, oPC, 4.0f);
					CSLIncrementLocalInt_Timed(oPC, "CSL_KNOCKDOWN", 4.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					SendMessageToPC(oPC, "You slip and fall");
				}
			}
		}
	}
	
	// **********************************
	// **       WATER and DROWNING     **
	// **********************************
	iCharState = CSLEnviroCheckWaterState( oPC, iCharState, iEnviroState, iAreaState, iCurrentWeather );
	int iBurning = GetLocalInt( oPC, "CSL_BURNING" );
	int iFlammable = GetLocalInt( oPC, "CSL_FLAMMABLE" );
	int iFreezing = GetLocalInt( oPC, "CSL_FREEZING" );
	int iChilled = GetLocalInt( oPC, "CSL_CHILLED" );
	int iGusted = GetLocalInt( oPC, "CSL_GUSTED" );
	int iBreathHoldingRounds = GetLocalInt( oPC, "CSL_HOLDBREATH" );
	if ( iCharState & CSL_CHARSTATE_SUBMERGED && GetIsOwnedByPlayer( oPC ) && !GetIsDead(oPC) && !CSLGetHasEffectType( oPC, EFFECT_TYPE_PETRIFY ) && CSLGetIsDrownable( oPC, TRUE ) )
	{		
		if (DEBUGGING >= 4) { CSLDebug( "Submerged Breath Holding="+IntToString(iBreathHoldingRounds), oPC ); }
		iBreathHoldingRounds = CSLEnviroHoldBreath( iBreathHoldingRounds, iPreviousHitpoints, oPC );
		
		SetLocalInt( oPC, "CSL_HOLDBREATH", iBreathHoldingRounds );
		
		if ( iBurning )
		{
			iFlammable = FALSE;
			iBurning = FALSE;
			SendMessageToPC(oPC, "The water has extinguished the flames");
			
			CSLEnviroBurningExtinguish(oPC);
		}
		if ( iBreathHoldingRounds )
		{
			iCharState |= CSL_CHARSTATE_BREATHHOLD;
		}
		CSLEnviroCheckSlowingState( oPC );
	}
	else if ( iCharState &  CSL_CHARSTATE_BREATHHOLD || iBreathHoldingRounds > 0 )
	{
		SetLocalInt( oPC, "CSL_HOLDBREATH", 0 );
		DeleteLocalInt( oPC, "CSL_HOLDBREATH" );
		if (DEBUGGING >= 4) { CSLDebug( "Not Submerged Breath Holding="+IntToString(iBreathHoldingRounds), oPC ); }

		if ( !GetIsDead(oPC) )
		{
			SendMessageToPC(oPC, "You take in a big breath of air");
		}
		
		//SetLocalInt( oPC, "CSL_HOLDBREATH", 0 );
		//iBreathHoldingRounds = 0; // CSLGetMax( iBreathHoldingRounds-10, 0 );
		//SetLocalInt( oPC, "CSL_HOLDBREATH", 0 );
		SetLocalInt( oPC, "CSL_CURRENTHPS", GetCurrentHitPoints(oPC) );
		
		
		
		//SetLocalInt( oPC, "UW_DROWNING", FALSE );
		//SetLocalInt( oPC, "UW_PANICKED", FALSE );
		iCharState &= ~CSL_CHARSTATE_BREATHHOLD;
		iCharState &= ~CSL_CHARSTATE_DROWNING;
		iCharState &= ~CSL_CHARSTATE_PANICKED;
		SetLocalInt( oPC, "CSL_WATERDC", 10 );
		
		CSLEnviroCheckSlowingState( oPC );
	}
	
	// **********************************
	// **              WIND            **
	// **********************************
	if ( iEnviroState & CSL_ENVIRO_GALE )
	{
		if ( d2() == 1 )
		{
			iBurning = FALSE;
			iFlammable = FALSE;
			CSLEnviroBurningExtinguish(oPC);
			
			SendMessageToPC(oPC, "The wind has extinguished the flames");
		}
		else
		{
			iBurning = iBurning+5;
		}
		
		if ( !FortitudeSave(oPC, 20-CSLGetSizeModifierGrapple(oPC) ) )
		{
			CSLEnviroWindGustEffect( GetLocation(oPC), oPC );
		}
	}
	
	// **********************************
	// **            ACIDIC DAMAGE     **
	// **********************************
	if ( ( iCurrentWeather & CSL_WEATHER_ATMOS_ACIDIC || iEnviroState & CSL_ENVIRO_ACIDIC ) && !GetIsImmune( oPC, IMMUNITY_TYPE_POISON ) )
	{
		int nDamage;
		int iAcidWeatherPower;
		if ( iCurrentWeather & CSL_WEATHER_ATMOS_ACIDIC )
		{
			iAcidWeatherPower = CSLEnviroGetEnviroStatePower( iCurrentWeather );
		}
		
		
		if ( iCharState & CSL_CHARSTATE_SUBMERGED )
		{
			//no damage, they are under water so can ignore it
			nDamage = 0;
		}
		else if ( iCharState & CSL_CHARSTATE_WADING )
		{
			//no damage, they are under water so can ignore it
			nDamage = d3(1);
		}
		else if ( iAcidWeatherPower > 0 && iEnviroState & CSL_ENVIRO_ACIDIC )
		{
			nDamage = d6(1)+d3(iAcidWeatherPower);
		}
		else if ( iAcidWeatherPower > 0 )
		{
			nDamage = d3(iAcidWeatherPower);
		}
		else
		{
			nDamage = d6(1);
		}
		
		if ( nDamage )
		{
			SetLastName(oEC, "");
			SetFirstName(oEC, "Acid");
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
			eDam = EffectLinkEffects(eDam, EffectVisualEffect( VFX_HIT_SPELL_ACID ));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
			SetFirstName(oEC, "Environment");
		}
		
	
	}
	
	// **********************************
	// **            COLD DAMAGE       **
	// **********************************
	if (DEBUGGING >= 8) { CSLDebug( "CSLEnviroObjectHeartbeat iEnviroState="+IntToString( iEnviroState )+" iCurrentWeather="+IntToString( iCurrentWeather )+" iChilled="+IntToString( iChilled ), GetFirstPC() ); }
	if ( iEnviroState & CSL_ENVIRO_COLD )
	{
		iChilled = CSLGetMax( iChilled, 20 );
		iFreezing = CSLGetMax( 10, iFreezing );
		iCharState &= CSL_CHARSTATE_FREEZING;
		
	//iFreezing;
	}
	else if ( iCurrentWeather & CSL_WEATHER_TYPE_SNOW )
	{
		iChilled += CSLEnviroGetEnviroStatePower( iCurrentWeather );
		if ( iChilled > 50 )
		{
			iFreezing = 3+iGusted+CSLEnviroGetEnviroStatePower( iCurrentWeather );
			iChilled = 5;
		}
	}
	else if ( iChilled )
	{
		iChilled = 0;
	}
	
	// **********************************
	// **          ELECTRIC DAMAGE     **
	// **********************************
	if ( iEnviroState & CSL_ENVIRO_STORM )
	{
		// need to do random lightening bolts here
		if ( d10() == 10 )
		{
			CSLEnviroLighteningBolt( GetLocation( oPC ), GetLocation( oPC ), SHAPE_SPHERE, RADIUS_SIZE_HUGE, 20 );
		}
		
	}
	
	// **********************************
	// **          NEGATIVE DAMAGE     **
	// **********************************
	if ( iEnviroState & CSL_ENVIRO_NEGATIVE )
	{
		// need to heal if they are undead here
		int nDamage = d6();
		if ( nDamage )
		{
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
			eDam = EffectLinkEffects(eDam, EffectVisualEffect( VFX_HIT_SPELL_NECROMANCY ));
			SetLastName(oEC, "");
			SetFirstName(oEC, "Shadows");
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
			SetFirstName(oEC, "Environment");
		}
	
	}
	
	
	// **********************************
	// **          POSITIVE DAMAGE     **
	// **********************************
	if ( iEnviroState & CSL_ENVIRO_POSITIVE )
	{
		// need to harm if they are undead here, heal if living, if twice hit points, you explode
		int nDamage = d6();
		SetLastName(oEC, "");
		SetFirstName(oEC, "Light");
		CSLEnviroApplyPositiveEffect( oPC, nDamage );
		SetFirstName(oEC, "Environment");
	
	}
	
	
	if ( iEnviroState & CSL_ENVIRO_DEADMAGIC || iCharState & CSL_CHARSTATE_DEADMAGIC )
	{
		CSLEnviroCheckDeadMagicState( oPC, iCharState, iEnviroState, iAreaState );
	}
	
	// **********************************************
	// **  HIDING - Light Vegetation, Dark, Light  **
	// **********************************************
	if ( iEnviroState & CSL_ENVIRO_LTVEGETATION )
	{
		// this is done on entry, nothing to do here yet
	
	}
	
	if ( iEnviroState & CSL_ENVIRO_BRIGHT )
	{
	
		// this is done on entry, nothing to do here yet
	}
	
	if ( iEnviroState & CSL_ENVIRO_DARK )
	{
		// this is done on entry, nothing to do here yet
	
	}
	
	// **************************************************************
	// **  MOVEMENT - Heavy Vegetation, Hard Terrain and Slippery  **
	// **************************************************************
	if ( iEnviroState & CSL_ENVIRO_VEGETATION || iEnviroState & CSL_ENVIRO_HARDTERRAIN )
	{
		// this is done on entry, nothing to do here yet
	
	}
	
	

	// ***********************************
	// **      POISON AND BLINDING      **
	// ***********************************
	if ( ( iCurrentWeather & CSL_WEATHER_ATMOS_SAND || iEnviroState & CSL_ENVIRO_BLINDING ) ) // Blinding sand, snow or the like
	{
		int iSaveDC = 15+iGusted;
		float fDelay = CSLRandomBetweenFloat(0.0, 2.0);
		//if(!HkSavingThrow(SAVING_THROW_REFLEX, oPC, iSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
		
		
		if ( iCurrentWeather & CSL_WEATHER_ATMOS_SAND && !( iCharState & CSL_CHARSTATE_SUBMERGED ) )
		{
			int iSandWeatherPower = CSLEnviroGetEnviroStatePower( iCurrentWeather );
			int iDamage;
			int iOrigDamage;
			if ( iSandWeatherPower == WEATHER_POWER_HEAVY )
			{
				if ( iCharState & CSL_CHARSTATE_WADING )
				{
					iOrigDamage = d2(1);
				}
				else
				{
					iOrigDamage = d3(1);
				}
			
			}
			else if ( iSandWeatherPower == WEATHER_POWER_STORMY )
			{
				if ( iCharState & CSL_CHARSTATE_WADING )
				{
					iOrigDamage = d3(1);
				}
				else
				{
					iOrigDamage = d6(1);
				}
			}
			iDamage = GetReflexAdjustedDamage(iOrigDamage, oPC, iSaveDC+iSandWeatherPower, SAVING_THROW_TYPE_NONE);
			
			if ( iOrigDamage > 0 && iDamage == iOrigDamage )
			{
				DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING), oPC));
				if ( !GetIsImmune( oPC, IMMUNITY_TYPE_BLINDNESS ) )
				{
					effect eBlind = EffectVisualEffect(VFX_DUR_SPELL_BLIND_DEAF);
					eBlind = EffectLinkEffects(eBlind, EffectBlindness() );
					eBlind = SetEffectSpellId(eBlind, -SPELL_BLINDNESS_AND_DEAFNESS);
					DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 6.0) );
					DelayCommand( fDelay, SendMessageToPC(oPC, "The Sand Violently Bites into your flesh and blinds you"));
				}
				else
				{
					DelayCommand( fDelay, SendMessageToPC(oPC, "The Sand Violently Bites into your flesh"));
				}
			}
			else if ( iOrigDamage > 0 && iDamage > 0 )
			{
				DelayCommand( CSLRandomBetweenFloat(0.0, 2.0), ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING), oPC));
				DelayCommand( fDelay, SendMessageToPC(oPC, "The Sand Violently Bites into your flesh"));
			}
			else if ( iSandWeatherPower == WEATHER_POWER_WEAK ||   iSandWeatherPower == WEATHER_POWER_LIGHT || iSandWeatherPower == WEATHER_POWER_MEDIUM )
			{
				if ( !ReflexSave(oPC, iSaveDC+iSandWeatherPower, SAVING_THROW_TYPE_NONE, oEC ) )
				{
					effect eBlind = EffectVisualEffect(VFX_DUR_SPELL_BLIND_DEAF);
					eBlind = EffectLinkEffects(eBlind, EffectBlindness() );
					eBlind = SetEffectSpellId(eBlind, -SPELL_BLINDNESS_AND_DEAFNESS);
					DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 6.0) );
					DelayCommand( fDelay, SendMessageToPC(oPC, "The Sand blinds you"));				
				}
			}
		
		}
		else if( iEnviroState & CSL_ENVIRO_BLINDING && !GetIsImmune( oPC, IMMUNITY_TYPE_BLINDNESS )  && !ReflexSave(oPC, iSaveDC, SAVING_THROW_TYPE_NONE, oEC ) ) // HkSavingThrow(SAVING_THROW_REFLEX, oPC, iSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
		{
			effect eBlind = EffectVisualEffect(VFX_DUR_SPELL_BLIND_DEAF);
			eBlind = EffectLinkEffects(eBlind, EffectBlindness() );
			eBlind = SetEffectSpellId(eBlind, -SPELL_BLINDNESS_AND_DEAFNESS);
			DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 6.0) );
			DelayCommand( fDelay, SendMessageToPC(oPC, "You Become Blinded"));
		}
	
	}

	if ( !( iCharState & CSL_CHARSTATE_SUBMERGED) && iEnviroState & CSL_ENVIRO_POISON && !GetIsImmune( oPC, IMMUNITY_TYPE_POISON ) ) // Poison Gas of some sort
	{
		effect ePoison = EffectPoison(POISON_LARGE_SCORPION_VENOM);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oPC);
	
	}
	
	// **********************************
	// **            FIRE DAMAGE       **
	// **********************************
	if ( iEnviroState & CSL_ENVIRO_MAGMA )
	{
		if ( !CSLGetIsFireBased( oPC ) )
		{
			int iDamage = GetReflexAdjustedDamage(d4(1), oPC, 24, SAVING_THROW_TYPE_FIRE);
			if (iDamage)
			{
				DelayCommand(0.25f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_FIRE), oPC));
				//DelayCommand(0.35f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oPC)); // VFX_IMP_FLAME_M
				FloatingTextStringOnCreature(CSLPickOne("Yeow!","Ouch","Hot Foot!","Sizzle"), oPC, TRUE);
				iFlammable++;
			}
		}
		else
		{
			
			DelayCommand(0.25f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal( d4() ), oPC));
			DelayCommand(0.30f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_FIRE), oPC));
		
		}
		
		
		iFlammable++;
		iFlammable = CSLGetMin( iFlammable, 20 );
		if ( iSoaked )
		{	
			iSoaked--;
		}
	}
	else if ( iEnviroState & CSL_ENVIRO_FLAMMABLE || iEnviroState & CSL_ENVIRO_FIRE )
	{
		iFlammable = 10;
		if ( iBurning )
		{
			iBurning = CSLGetMin(iBurning, 15);
		}
		else
		{
			iBurning = 20;
		}
	}
	else if ( iFlammable )
	{
		iFlammable = 0;
	}
	
	if ( iEnviroState & CSL_ENVIRO_FIRE || iFlammable > 15 )
	{
		if ( !(iBurning) )
		{
			SendMessageToPC(oPC, "You Burst into flames");
		}
		iFlammable = CSLGetMax( iFlammable, 20 );
		iBurning = CSLGetMax( 10, iBurning );
		
	}
	
	// **********************************
	// **            BURNING           **
	// **********************************
	if ( iBurning )
	{
		if ( iSoaked )
		{	
			iBurning -= iSoaked;
			iSoaked--;
		}
		iBurning = CSLGetMin( iBurning, 40 );

		//if( !GetIsInCombat(oPC) )
		//{
			// A character out of combat will be assumed to be actively putting out the fire: Stop Drop and Roll.
			// This is an indirect approach
		//	SendMessageToPC(oPC, "Trying to stop drop and roll");
		//	CSLEmoteDoStopDropAndRoll( oPC );
		//}
		
		
		if ( GetLocalInt( oPC, "CSL_STOPDROPANDROLL" ) )
		{
			AssignCommand(oPC, SpeakString("*tries to put out fire*"));
			DeleteLocalInt( oPC, "CSL_STOPDROPANDROLL" );
		
			iBurning = iBurning - 4;			
		}
		
		
		if( iBurning < 5 || ReflexSave( oPC, iBurning, SAVING_THROW_TYPE_FIRE, oEC ) )
		{
			iBurning = FALSE;
			iCharState & ~CSL_CHARSTATE_BURNING;
		}
	}
	
	
	if ( iFreezing || iEnviroState & CSL_ENVIRO_COLD )
	{
		int nDamage = 1;
		if ( iFreezing > 9 )
		{
			nDamage = d6(1+iGusted);
		}
		else
		{
			int iSurvival = GetSkillRank( SKILL_SURVIVAL, oPC )/5;
			
			nDamage = CSLGetMax(iFreezing, 5)+iGusted;
			
			if ( iSurvival )
			{
				nDamage -= iSurvival;
			}
		}
		
		if ( iGusted )
		{
			iFreezing = iFreezing + iGusted;
		}
		else
		{
			iFreezing--;
		}
		
		if ( nDamage )
		{
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
			//eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_ICE));
			SetLastName(oEC, "");
			SetFirstName(oEC, "Severe Cold");
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
			SetFirstName(oEC, "Environment");
		}
		
		if ( !iFreezing && iCharState & CSL_CHARSTATE_FREEZING )
		{
			iCharState & ~CSL_CHARSTATE_FREEZING;
		}
	}
	
	
	if ( iBurning || iEnviroState & CSL_ENVIRO_FIRE )
	{
		int nDamage = d6(1+iGusted);
		effect eDam;
		if ( !CSLGetIsFireBased( oPC ) )
		{
			eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
		}
		else
		{
			eDam = EffectHeal(nDamage);
		}
		effect eVis2 = EffectVisualEffect(VFX_DUR_FIRE);
		string sVFXForFire = "sfx_fire";
		if ( iGusted || iBurning == 1 )
		{
			sVFXForFire = "fx_fire_lg";
			eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_FIRE));
		}
		
		if ( iGusted )
		{
			iBurning = iBurning + iGusted;
		}
		else
		{
			iBurning--;
		}
		SetLastName(oEC, "");
		SetFirstName(oEC, "Flames"); // this is the name of the damaging object
		
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oPC);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId( eVis2, SPELLENVIRO_BURNING ), oPC, RoundsToSeconds(1));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId( EffectNWN2SpecialEffectFile( sVFXForFire ), SPELLENVIRO_BURNING ), oPC, 6.0);
		SetFirstName(oEC, "Environment");
		if ( !iBurning && iCharState & CSL_CHARSTATE_BURNING )
		{
			iCharState & ~CSL_CHARSTATE_BURNING;
		}
	}
	
	
	
	SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
	SetLocalInt( oPC, "CSL_BURNING", iBurning );
	//SetLocalInt( oPC, "CSL_FREEZING", iFreezing );// not saved unlike burning
	SetLocalInt( oPC, "CSL_FLAMMABLE", iFlammable );
	SetLocalInt( oPC, "CSL_CHILLED", iChilled );
	SetLocalInt( oPC, "CSL_SOAKED", iSoaked );
	
	SetLocalInt( oPC, "CSL_CURRENTHPS", GetCurrentHitPoints(oPC) );
}


/**  
* Gets if a character is currently flagged as underwater
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetIsUnderWater( object oCaster )
{
	if ( GetLocalInt( oCaster, "CSL_CHARSTATE" ) & CSL_CHARSTATE_SUBMERGED )
	{
		return TRUE;
	}
	return FALSE;
}

/**  
* Run in the spell hook on the caster
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroSpellHookCasterCheck( int iCasterState, int iCharState = 0, object oCaster = OBJECT_SELF, int iSpellId = -1, int iDescriptor = -1, int iClass = 255, int iSpellLevel = -1, int iSpellSchool = -1, int iSpellSubSchool = -1, int iAttributes = -1 )
{
	
	
	// **********************************
	// **        BREATH HOLDING        **
	// **********************************
	/*
	// this should already be done
	int iAreaState = GetLocalInt( GetArea(oPC), "CSL_ENVIRO" );
	int iEnviroState = iAreaState | GetLocalInt( oPC, "CSL_ENVIRO" );
	int iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );
	*/
	
	
	
	
	
	if ( iCharState < 1 )
	{
		iCharState = 0;
	} 
	if ( iDescriptor < 1 ) { iDescriptor = 0; }
	if ( iCasterState < 1 ) { iCasterState = 0; }
	if ( iSpellSchool < 1 ) { iSpellSchool = 0; }
	if ( iSpellSubSchool < 1 ) { iSpellSubSchool = 0; }
	if ( iAttributes < 1 ) { iAttributes = 0; }
	
	
	if ( iCasterState & CSL_ENVIRO_WATER || iCharState & ( CSL_CHARSTATE_SPLASHING | CSL_CHARSTATE_WADING | CSL_CHARSTATE_SUBMERGED ) )
	{
		iCharState = CSLEnviroCheckWaterState( oCaster, iCharState, iCasterState );
	}
	
	
	int iBreathHolding = GetLocalInt( oCaster, "CSL_HOLDBREATH");
	
	if ( iBreathHolding > 0) //( CSLGetIsDrownable( oCaster ) && !GetHasSpellEffect( SPELL_WATER_BREATHING, oCaster ) )
	{
		// check for if spell needs verbal component
		int iMetaMagic = CSLGetAutomaticMetamagic( GetMetaMagicFeat(), oCaster ); // { GetMetaMagicFeat();
		
		iMetaMagic = CSLGetAutomaticMetamagic( GetMetaMagicFeat() );
		
		
		iMetaMagic &= CSLReadIntModifier( oCaster, "Spell_MetaMagic" );
		// GetHasFeat( FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1, oCaster )
	
		//SendMessageToPC(oCaster, "Metamagic = "+IntToString(iMetaMagic) );
		if (  !( iMetaMagic & METAMAGIC_SILENT ) && CSLGetIsVerbalComponentRequired( iSpellId ) )
		{
			SendMessageToPC(oCaster, "You cannot cast this spell when you cannot breathe");
			SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
			return FALSE;
		}
	}
	
	
	// **********************************
	// **            HOLY              **
	// **********************************
	if ( iCasterState & CSL_ENVIRO_HOLY )
	{
		if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD  )
		{
			SetLocalInt( oCaster, "HKTEMP_TurnAdj", 3 );
		}
		
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL && ( iSpellSubSchool & SPELL_SUBSCHOOL_SUMMONING ||  iSpellSubSchool & SPELL_SUBSCHOOL_ANIMATE )  )
		{
			SendMessageToPC(oCaster, "The holy nature of this area blocks your magic");
			SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
			return FALSE;
		}
		/*
		if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Evil spell in Holy", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
		*/	
	}
	
	// **********************************
	// **           PROFANE            **
	// **********************************
	if ( iCasterState & CSL_ENVIRO_PROFANE )
	{
		if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD  )
		{
			SetLocalInt( oCaster, "HKTEMP_TurnAdj", -3 );
		}
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD && ( iSpellSubSchool & SPELL_SUBSCHOOL_SUMMONING ||  iSpellSubSchool & SPELL_SUBSCHOOL_ANIMATE )  )
		{
			SendMessageToPC(oCaster, "The profane nature of this area blocks your magic");
			SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
			return FALSE;
		}
		
		/*
		if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Good spell in Profane", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
		*/
	}
	
	// **********************************
	// **             LAW              **
	// **********************************
	if ( iCasterState & CSL_ENVIRO_LAW )
	{
		/*
		if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Chaos spell in Law", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		if ( iDescriptor & SCMETA_DESCRIPTOR_LAW  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
		*/
	
	}
	
	
	
	// **********************************
	// **          CHAOS              **
	// **********************************
	if ( iCasterState & CSL_ENVIRO_CHAOS )
	{
		/*
		if ( iDescriptor & SCMETA_DESCRIPTOR_LAW  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Law spell in Chaos", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
		*/
	
	}
	
	
	// **********************************
	// **             FIRE              **
	// **********************************
	if ( iDescriptor & SCMETA_DESCRIPTOR_FIRE && iCasterState & CSL_ENVIRO_FLAMMABLE )
	{
		CSLEnviroBurningStart( 15, oCaster );	
	}
	
	return TRUE;

}

/**  
* Does an Impeded Magic Check
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroImpededMagicCheck( object oCaster, string sDescription = "Casting spell Impeded", int ibaseDC = 20, int iSpellLevel = -1, int iClass = -1 )
{
	if ( iSpellLevel == -1 )
	{
		iSpellLevel = GetLocalInt(oCaster, "HKTEMP_SpellLevel" );
	}
	
	if ( iClass == -1 )
	{
		iClass = GetLocalInt(oCaster, "HKTEMP_Class" );
	}
	
	//int iCastingClass = GetLastSpellCastClass();
	int iDC = ibaseDC + iSpellLevel;
	int iSpellCraftRanks = GetSkillRank(SKILL_SPELLCRAFT, oCaster);
	
	int iAbility;
	if ( iClass == 255 )
	{
		iAbility = ABILITY_CHARISMA; // default if not class returns
	}
	else
	{
		iAbility = CSLGetMainStatByClass( iClass, "DC" );
	}	
	int iAbilityMod = GetAbilityModifier( iAbility, oCaster);
	
	int iSkillCheckRoll = d20()+iSpellCraftRanks+iAbilityMod;
	
	string sMessage = "Spellcraft check: "+sDescription+" vs DC "+IntToString(iDC)+": Roll "+IntToString(iSkillCheckRoll);

	if(iSkillCheckRoll>=iDC)
	{
		sMessage = sMessage+" Successful.";
		if(GetIsPC(oCaster))
		{
			SendMessageToPC(oCaster, sMessage);
		}
		return TRUE;
		
	}
	else
	{
		sMessage = sMessage+" Failure.";
		SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
		if( GetIsPC(oCaster) )
		{
			SendMessageToPC(oCaster, sMessage);
		}
		return FALSE;
	}
	return TRUE;
}

/**  
* Spellhook run on the target or the target location ( indirectly )
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroSpellHookTargetCheck( int iTargetState,  int iCharState = -1, object oCaster = OBJECT_SELF, int iSpellId = -1, int iDescriptor = -1, int iClass = 255, int iSpellLevel = -1, int iSpellSchool = -1, int iSpellSubSchool = -1, int iAttributes = -1 )
{
	if (DEBUGGING >= 8) { CSLDebug("CSLEnviroSpellHookTargetCheck( "+IntToString(iTargetState)+", "+IntToString(iCharState)+" )", oCaster ); }
	int iDamageModType = CSLReadIntModifier( oCaster, "damagemodtype" );
	int bHasCharState = TRUE;
	
	if ( iCharState < 0 )
	{
		bHasCharState = FALSE;
		iCharState = 0;
	} 
	if ( iDescriptor < 1 ) { iDescriptor = 0; }
	if ( iTargetState < 1 ) { iTargetState = 0; }
	if ( iSpellSchool < 1 ) { iSpellSchool = 0; }
	if ( iSpellSubSchool < 1 ) { iSpellSubSchool = 0; }
	if ( iAttributes < 1 ) { iAttributes = 0; }
	
	// **********************************
	// **             TOWN             **
	// **********************************
	/*
	if ( iTargetState & CSL_ENVIRO_TOWN && iAttributes & SCMETA_ATTRIBUTES_CANTCASTINTOWN )
	{
		SendMessageToPC(oCaster, "This spell is not permitted in town.");
		SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
		return FALSE;
	}
	*/
	
	
	// **********************************
	// **          DEAD MAGIC          **
	// **********************************
	/*
		These planes have no magic at all. A plane with the dead magic trait functions in all respects
		like an antimagic field spell. Divination spells cannot detect subjects within a dead magic
		plane, nor can a spellcaster use teleport or another spell to move in or out. The only exception
		to the 'no magic' rule is permanent planar portals, which still function normally.
	*/
	if ( iTargetState & CSL_ENVIRO_DEADMAGIC && iAttributes & SCMETA_ATTRIBUTES_MAGICAL )
	{
		SendMessageToPC(oCaster, "Magic is Deadened Where you targeted");
		SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
		return FALSE;
	}
	
	// **********************************
	// **          WILD MAGIC          **
	// **********************************
	/*
		On a plane with the wild magic trait spells and spell-like abilities function in radically
		different and sometimes dangerous ways. Any spell or spell-like ability used on a wild magic
		plane has a chance to go awry. The caster must make a level check (DC 15 + the level of the
		spell or effect) for the magic to function normally. For spell-like abilities, use the level or
		HD of the creature employing the ability for the caster level check and the level of the
		spell-like ability to set the DC for the caster level check. Failure on this check means that
		something strange happens; roll d% and consult the following table.
	*/
	if ( iTargetState & CSL_ENVIRO_WILDMAGIC && iAttributes & SCMETA_ATTRIBUTES_MAGICAL )
	{
		// Just do random damage for now, need to vary i more
		SendMessageToPC(oCaster, "You sense your magic has gone awry somehow" );
		SetLocalInt( OBJECT_SELF, "HKTEMP_damagemodtype", CSLPickOneInt(DAMAGE_TYPE_COLD, DAMAGE_TYPE_FIRE, DAMAGE_TYPE_ACID, DAMAGE_TYPE_ELECTRICAL, DAMAGE_TYPE_SONIC, DAMAGE_TYPE_NEGATIVE, DAMAGE_TYPE_POSITIVE ) );
		if (DEBUGGING >= 8) { CSLDebug( "Hook: Damage Set to <color=red>"+CSLDamagetypeToString( GetLocalInt( OBJECT_SELF, "HKTEMP_damagemodtype"))+"</color>" ); }
	
	}
	
	// **********************************
	// **          ANCHORED            **
	// **********************************
	if ( iTargetState & CSL_ENVIRO_ANCHORED && iSpellSubSchool & ( SPELL_SUBSCHOOL_TELEPORTATION | SPELL_SUBSCHOOL_CALLING ) )
	{
		SendMessageToPC(oCaster, "The target area is anchored and your spell fizzles");
		return FALSE;
	}
	
	
	// **********************************
	// **            HOLY              **
	// **********************************
	if ( iTargetState & CSL_ENVIRO_HOLY )
	{
		if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Evil spell in Holy", 20, iSpellLevel, iClass ) )
			{
				SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
				return FALSE;
			}
			
			if ( iSpellSubSchool & SPELL_SUBSCHOOL_SUMMONING ||  iSpellSubSchool & SPELL_SUBSCHOOL_ANIMATE  )
			{
				SendMessageToPC(oCaster, "The holy nature of this area blocks your magic");
				SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
				return FALSE;
			}
		
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
		
		
	}
	
	// **********************************
	// **           PROFANE            **
	// **********************************
	if ( iTargetState & CSL_ENVIRO_PROFANE )
	{
		if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Good spell in Profane", 20, iSpellLevel, iClass ) )
			{
				SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
	}
	
	// **********************************
	// **             LAW              **
	// **********************************
	if ( iTargetState & CSL_ENVIRO_LAW )
	{
		if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Chaos spell in Law", 20, iSpellLevel, iClass ) )
			{
				SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		if ( iDescriptor & SCMETA_DESCRIPTOR_LAW  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
	
	}
	
	// **********************************
	// **          CHAOS              **
	// **********************************
	if ( iTargetState & CSL_ENVIRO_CHAOS )
	{
		if ( iDescriptor & SCMETA_DESCRIPTOR_LAW  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Law spell in Chaos", 20, iSpellLevel, iClass ) )
			{
				SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
	
	}
	
	// **********************************
	// **          NEGATIVE            **
	// **********************************
	/*	
		The Plane of Shadow is a dimly lit dimension that is both coterminous to and coexistent with the
		Material Plane. It overlaps the Material Plane much as the Ethereal Plane does, so a planar
		traveler can use the Plane of Shadow to cover great distances quickly.
	
		The Plane of Shadow is also coterminous to other planes. With the right spell, a character can
		use the Plane of Shadow to visit other realities.
	
		The Plane of Shadow is a world of black and white; color itself has been bleached from the
		environment. It is otherwise appears similar to the Material Plane.
	
		Despite the lack of light sources, various plants, animals, and humanoids call the Plane of
		Shadow home.
	
		The Plane of Shadow is magically morphic, and parts continually flow onto other planes. As a
		result, creating a precise map of the plane is next to impossible, despite the presence of
		landmarks.
	
		The Plane of Shadow has the following traits.
	
		Magically morphic. Certain spells modify the base material of the Plane of Shadow. The utility
		and power of these spells within the Plane of Shadow make them particularly useful for explorers
		and natives alike. Mildly neutral-aligned. Enhanced magic. Spells with the shadow descriptor are
		enhanced on the Plane of Shadow. Such spells are cast as though they were prepared with the
		Maximize Spell feat, though they don't require the higher spell slots.
	
		Furthermore, specific spells become more powerful on the Plane of Shadow. Shadow conjuration and
		shadow evocation spells are 30% as powerful as the conjurations and evocations they mimic (as
		opposed to 20%). Greater shadow conjuration and greater shadow evocation are 70% as powerful
		(not 60%), and a shades spell conjures at 90% of the power of the original (not 80%).
	
		Impeded magic. Spells that use or generate light or fire may fizzle when cast on the Plane of
		Shadow. A spellcaster attempting a spell with the light or fire descriptor must succeed on a
		Spellcraft check (DC 20 + the level of the spell). Spells that produce light are less effective
		in general, because all light sources have their ranges halved on the Plane of Shadow. Despite
		the dark nature of the Plane of Shadow, spells that produce, use, or manipulate darkness are
		unaffected by the plane.
		
		
		Negative Energy Plane To an observer, there's little to see on the Negative Energy Plane. It
		is a dark, empty place, an eternal pit where a traveler can fall until the plane itself
		steals away all light and life. The Negative Energy Plane is the most hostile of the Inner
		Planes, and the most uncaring and intolerant of life. Only creatures immune to its
		life-draining energies can survive there.

		The Negative Energy Plane has the following traits.

		Subjective directional gravity. Major negative-dominant. Some areas within the plane have
		only the minor negative-dominant trait, and these islands tend to be inhabited. Enhanced
		magic. Spells and spell-like abilities that use negative energy are maximized (as if the
		Maximize Spell metamagic feat had been used on them, but the spells don't require
		higher-level slots). Spells and spell-like abilities that are already maximized are
		unaffected by this benefit. Class abilities that use negative energy, such as rebuking and
		controlling undead, gain a +10 bonus on the roll to determine Hit Dice affected. Impeded
		magic. Spells and spell-like abilities that use positive energy, including cure spells, are
		impeded. Characters on this plane take a -10 penalty on Fortitude saving throws made to
		remove negative levels bestowed by an energy drain attack. Random Encounters Because the
		Negative Energy Plane is virtually devoid of creatures, random encounters on the plane are
		exceedingly rare.
	*/
	if ( iTargetState & CSL_ENVIRO_NEGATIVE )
	{
		// Fire and light descriptors are impeded
		if ( iDescriptor & ( SCMETA_DESCRIPTOR_LIGHT | SCMETA_DESCRIPTOR_FIRE ) )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Light spell in shadow", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
		}
		else if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE  || iSpellSubSchool & SPELL_SUBSCHOOL_HEALING && !( iDamageModType & DAMAGE_TYPE_NEGATIVE ) )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Positive spell in negative", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
		}
			
			
		if ( iDescriptor & SCMETA_DESCRIPTOR_LIGHT )
		{
			SetLocalInt( oCaster, "HKTEMP_Spell_DurationCatAdj", -1 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 50 );
		}
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		
		if ( iSpellSubSchool & SPELL_SUBSCHOOL_HEALING && !( iDamageModType & DAMAGE_TYPE_NEGATIVE ) )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 75 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE || iDamageModType & DAMAGE_TYPE_NEGATIVE )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
		}
		
		// shadow descriptor spells do more damage, and they are always maximized
		if ( iSpellSubSchool & SPELL_SUBSCHOOL_SHADOW )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
			SetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic", GetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic") | METAMAGIC_MAXIMIZE );
		}
	}
	
	// **********************************
	// **           POSITIVE           **
	// **********************************
	/*
		Positive Energy Plane The Positive Energy Plane has no surface and is akin to the Elemental
		Plane of Air with its wide-open nature. However, every bit of this plane glows brightly with
		innate power. This power is dangerous to mortal forms, which are not made to handle it. Despite
		the beneficial effects of the plane, it is one of the most hostile of the Inner Planes. An
		unprotected character on this plane swells with power as positive energy is force-fed into her.
		Then, her mortal frame unable to contain that power, she immolates as if she were a small planet
		caught at the edge of a supernova. Visits to the Positive Energy Plane are brief, and even then
		travelers must be heavily protected.
	
		The Positive Energy Plane has the following traits.
	
		Subjective directional gravity. Major positive-dominant. Some regions of the plane have the
		minor positive-dominant trait instead, and those islands tend to be inhabited. Enhanced magic.
		Spells and spell-like abilities that use positive energy, including cure spells, are maximized
		(as if the Maximize Spell metamagic feat had been used on them, but the spells don't require
		higher-level slots). Spells and spell-like abilities that are already maximized are unaffected
		by this benefit. Class abilities that use positive energy, such as turning and destroying
		undead, gain a +10 bonus on the roll to determine Hit Dice affected. (Undead are almost
		impossible to find on this plane, however.) Impeded magic. Spells and spell-like abilities that
		use negative energy (including inflict spells) are impeded. Random Encounters Because the
		Positive Energy Plane is virtually devoid of creatures, random encounters on the plane are
		exceedingly rare.
	*/
	if ( iTargetState & CSL_ENVIRO_POSITIVE )
	{
		if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE || iDamageModType & DAMAGE_TYPE_NEGATIVE || iSpellSubSchool & SPELL_SUBSCHOOL_SHADOW )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting negative spell in positive", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 70 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		// Boosts
		if ( iDescriptor & SCMETA_DESCRIPTOR_LIGHT )
		{
			SetLocalInt( oCaster, "HKTEMP_Spell_DurationCatAdj", 1 );
		}
		if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
			SetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic", GetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic") | METAMAGIC_MAXIMIZE );
		}
		
		if ( iSpellSubSchool & SPELL_SUBSCHOOL_HEALING && !( iDamageModType & DAMAGE_TYPE_NEGATIVE ) )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 125 );
			SetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic", GetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic") | METAMAGIC_MAXIMIZE );
		}
		
		// Reductions
		if ( iDescriptor & SCMETA_DESCRIPTOR_DARKNESS )
		{
			SetLocalInt( oCaster, "HKTEMP_Spell_DurationCatAdj", -1 );
		}
		
		if ( iSpellSubSchool & SPELL_SUBSCHOOL_SHADOW )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 70 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
	
	}
	
	
	// **********************************
	// **            FIRE              **
	// **********************************
	/*
		Everything is alight on the Elemental Plane of Fire. The ground is nothing more than great,
		evershifting plates of compressed flame. The air ripples with the heat of continual firestorms,
		and the most common liquid is magma, not water. The oceans are made of liquid flame, and the
		mountains ooze with molten lava. Fire survives here without need for fuel or air, but flammables
		brought onto the plane are consumed readily.
	
		The Elemental Plane of Fire has the following traits.
	
		Fire-dominant. Enhanced magic. Spells and spell-like abilities with the fire descriptor are both
		maximized and enlarged (as if the Maximize Spell and Enlarge Spell had been used on them, but
		the spells don't require higher-level slots). Spells and spell-like abilities that are already
		maximized or enlarged are unaffected by this benefit. Impeded magic. Spells and spell-like abilities 
		that use or create water (including spells of the Water domain and spells that summon water elementals 
		or outsiders with the water subtype) are impeded.
	*/
	if ( iTargetState & ( CSL_ENVIRO_FIRE | CSL_ENVIRO_MAGMA )  )
	{
		
		if ( iDescriptor & ( SCMETA_DESCRIPTOR_WATER ) )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Water spell in Fire", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
		}
		
		if ( iDamageModType == DAMAGE_TYPE_FIRE || ( iDamageModType == 0 && iDescriptor & SCMETA_DESCRIPTOR_FIRE )  )
		{
			//SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic", GetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic") | METAMAGIC_MAXIMIZE );
		}
		
		if ( iDamageModType == DAMAGE_TYPE_COLD || ( iDamageModType == 0 && iDescriptor & SCMETA_DESCRIPTOR_COLD )  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 70 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
	
	}
	
	// **********************************
	// **             COLD             **
	// **********************************
	if ( iTargetState & CSL_ENVIRO_COLD )
	{
		if ( iDamageModType == DAMAGE_TYPE_FIRE || ( iDamageModType == 0 && iDescriptor & SCMETA_DESCRIPTOR_FIRE )  )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Fire spell in Extreme Cold", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 70 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 75 );
		}
		
		if ( iDamageModType == DAMAGE_TYPE_COLD || ( iDamageModType == 0 && iDescriptor & SCMETA_DESCRIPTOR_COLD )  )
		{
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic", GetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic") | METAMAGIC_MAXIMIZE );
		}
		
		
	
	}
	
	
	// **********************************
	// **          UNDERWATER          **
	// **********************************
	/*
		The Elemental Plane of Water is a sea without a floor or a surface, an entirely fluid
		environment lit by a diffuse glow. It is one of the more hospitable of the Inner Planes once
		a traveler gets past the problem of breathing the local medium.

		The eternal oceans of this plane vary between ice cold and boiling hot, between saline and
		fresh. They are perpetually in motion, wracked by currents and tides. The plane's permanent
		settlements form around bits of flotsam and jetsam suspended within this endless liquid.
		These settlements drift on the tides of the Elemental Plane of Water.

		The Elemental Plane of Water has the following traits.

		Subjective directional gravity. The gravity here works similar to that of the Elemental
		Plane of Air. But sinking or rising on the Elemental Plane of Water is slower (and less
		dangerous) than on the Elemental Plane of Air. Water-dominant. Enhanced magic. Spells and
		spell-like abilities that use or create water are both extended and enlarged (as if the
		Extend Spell and Enlarge Spell metamagic feats had been used on them, but the spells don't
		require higher-level slots). Spells and spell-like abilities that are already extended or
		enlarged are unaffected by this benefit. Impeded magic. Spells and spell-like abilities with
		the fire descriptor (including spells of the Fire domain) are impeded.
	*/
	//CSL_ENVIRO_WATER = BIT2
	//CSL_CHARSTATE_SPLASHING
	//CSL_CHARSTATE_WADING
	//CSL_CHARSTATE_SUBMERGED
	//"CSLEnviroSpellHookTargetCheck TargetState=0 iCharState=-1 iDamageModType=0 CSLDescriptorsToString=Fire )"	
	
	
	
	if ( ( !bHasCharState && iTargetState & CSL_ENVIRO_WATER ) || ( bHasCharState && iCharState & ( CSL_CHARSTATE_SPLASHING | CSL_CHARSTATE_WADING | CSL_CHARSTATE_SUBMERGED ) )  )
	{
		if (DEBUGGING >= 8) { CSLDebug("CSLEnviroSpellHookTargetCheck TargetState="+IntToString(iTargetState)+" iCharState="+IntToString(iCharState)+" iDamageModType="+CSLDamagetypeToString(iDamageModType)+" CSLDescriptorsToString="+CSLDescriptorsToString(iDescriptor)+" )", oCaster ); }
		if ( iDamageModType == DAMAGE_TYPE_FIRE || ( iDamageModType == 0 && iDescriptor & SCMETA_DESCRIPTOR_FIRE )  )
		{
			
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Fire spell in water", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
			
			/*
			int iCastingClass = GetLastSpellCastClass();
			int iDC = 20 + iSpellLevel;
			int iSpellCraftRanks = GetSkillRank(SKILL_SPELLCRAFT, oCaster);
			int iINTMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
			int iSkillCheckRoll = d20()+iSpellCraftRanks+iINTMod;
			
			string sMessage = "Spellcraft check: Casting Fire spell underwater vs DC "+IntToString(iDC)+": Roll "+IntToString(iSkillCheckRoll);
	
			if(iSkillCheckRoll>=iDC)
			{
				sMessage = sMessage+" Successful.";
				if(GetIsPC(oCaster))
				{
					SendMessageToPC(oCaster, sMessage);
				}
				
			}
			else
			{
				sMessage = sMessage+" Failure.";
				SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
				if( GetIsPC(oCaster) )
				{
					SendMessageToPC(oCaster, sMessage);
				}
			}
			*/
		}
		
		// Sonic spells are doubled in range
		if ( iDamageModType == DAMAGE_TYPE_SONIC || ( iDamageModType == 0 && iDescriptor & SCMETA_DESCRIPTOR_SONIC )  )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 200 );
		}
		
		
		if ( iDamageModType == DAMAGE_TYPE_ACID || ( iDamageModType == 0 && iDescriptor & SCMETA_DESCRIPTOR_ACID )  )
		{
			SetLocalInt( oCaster, "HKTEMP_Spell_DurationCatAdj", -1 );
		}
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_GAS || iDescriptor & SCMETA_DESCRIPTOR_AIR )
		{
			SetLocalInt( oCaster, "HKTEMP_Spell_DurationCatAdj", -1 );
		}
		
		
		// Bambardment does half damage underwater
		if ( iSpellId == SPELL_BOMBARDMENT )
		{
			SetLocalInt( oCaster, "HKTEMP_damagemodpercent", 50 );
		}
		
		//Electrical spells are different in shape
		if ( iSpellId == SPELL_LIGHTNING_BOLT )
		{
			//void ActionCastSpellAtObject(int nSpell, object oTarget, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nDomainLevel=0, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE);
			//void   ActionCastSpellAtLocation(int nSpell, location lTargetLocation, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE, int nDomainLevel=0 );
	
			AssignCommand(oCaster, ActionCastSpellAtLocation(SPELL_SCINTILLATING_SPHERE, GetSpellTargetLocation(), METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
			SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
		}
		
		if ( iDescriptor & ( SCMETA_DESCRIPTOR_WATER ) )
		{
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic", GetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic") | METAMAGIC_EXTEND );
		}
		
		
	}
	
	
	
	// **********************************
	// **             GALE             **
	// **********************************
	// CSL_ENVIRO_STORM is kind of related but focuses on more electrical activity
	/*
		Elemental Plane Of Air The Elemental Plane of Air is an empty plane, consisting of sky above and sky
		below.
		
		The Elemental Plane of Air is the most comfortable and survivable of the Inner Planes, and it is the
		home of all manner of airborne creatures. Indeed, flying creatures find themselves at a great
		advantage on this plane. While travelers without flight can survive easily here, they are at a
		disadvantage.
		
		The Elemental Plane of Air has the following traits.
		
		Subjective directional gravity. Inhabitants of the plane determine their own 'down' direction.
		Objects not under the motive force of others do not move. Air-dominant. Enhanced magic. Spells and
		spell-like abilities that use, manipulate, or create air (including spells of the Air domain) are
		both empowered and enlarged (as if the Empower Spell and Enlarge Spell metamagic feats had been used
		on them, but the spells don't require higher-level slots). Impeded magic. Spells and spell-like
		abilities that use or create earth (including spells of the Earth domain and spells that summon
		earth elementals or outsiders with the earth subtype) are impeded.
	*/
	if ( iTargetState & CSL_ENVIRO_GALE )
	{
		if ( iDescriptor & SCMETA_DESCRIPTOR_GAS )
		{
			SetLocalInt( oCaster, "HKTEMP_Spell_DurationCatAdj", -1 );
		}
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )
		{
			//SetLocalInt( oCaster, "HKTEMP_Spell_DurationCatAdj", 1 );
			SetLocalInt( oCaster, "HKTEMP_sizemodpercent", 150 );
			SetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic", GetLocalInt( oCaster, "HKTEMP_Spell_MetaMagic") | METAMAGIC_EMPOWER );
		}
		
		if ( iDescriptor & SCMETA_DESCRIPTOR_EARTH )
		{
			if ( !CSLEnviroImpededMagicCheck( oCaster, "Casting Earth spell in Wind", 20, iSpellLevel, iClass ) )
			{
				return FALSE;
			}
		}
	}
	return TRUE;
}


/**  
* Initiates the burning event, just does the visual and the heartbeat will do the damage later
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroBurningStart( int iStartingDC = 10, object oPC = OBJECT_SELF )
{
	effect eBurning = EffectNWN2SpecialEffectFile( "fx_fire_lg" );
	eBurning = SetEffectSpellId(eBurning, SPELLENVIRO_BURNING );
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBurning, oPC, 6.0);
	SetLocalInt( oPC, "CSL_BURNING", CSLGetMax(iStartingDC, 10) );
	CSLAddLocalBit( oPC, "CSL_CHARSTATE", CSL_CHARSTATE_BURNING );
	SetLocalObject( CSLEnviroGetControl(), ObjectToString(oPC), oPC );
}



/**  
* Does an Environmental Check to see if conflicting environmental types cancel each other out
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroConfictContest( object oCaster, string sDescription, int iDC, int iSaveDC )
{
	
	int iCheckRoll = d20();
	
	int iCheckTotal = iCheckRoll+iDC;
	//string sMessage = "Environment check: "+sDescription+" vs DC "+IntToString(iSaveDC)+": Roll "+IntToString(iCheckRoll)+" + "+IntToString(iDC)+" = "+IntToString(iCheckTotal);

	if(iCheckRoll == 1 )
	{
		return FALSE;
	}
	
	if(iCheckRoll == 20 || (iCheckTotal>=iSaveDC))
	{
		//sMessage = sMessage+" Successful.";
		if( sDescription != "" && GetIsPC(oCaster))
		{
			//SendMessageToPC(oCaster, sMessage);
			SendMessageToPC(oCaster, sDescription );
		}
		return TRUE;
		
	}
	//else
	//{
		//sMessage = sMessage+" Failure.";
		//if( GetIsPC(oCaster) )
		//{
		//	SendMessageToPC(oCaster, sMessage);
		//}
		//return FALSE;
	//}
	return FALSE;
}



/**  
* Initiates the burning on a AOE
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroIgniteAOE( int iStartingDC, object oAOE, object oCaster = OBJECT_SELF )
{
	int iDispelDC;
	int iSpellID = GetAreaOfEffectSpellId( oAOE ); 
	
	
	if ( iSpellID == SPELL_GREASE )
	{
		iDispelDC = CSLGetAOETagInt( SCSPELLTAG_SPELLDISPELDC, oAOE );
		if ( CSLEnviroConfictContest( oCaster, "You ignited the Grease", iStartingDC, iDispelDC ) )  // 9+21 = 30 vs 50, 30 vs 35
		{
			int iEndingRound = CSLGetAOETagInt( SCSPELLTAG_ENDINGROUND, oAOE );
			
			
			float fRemainingDuration = CSLGetMinf( CSLEnviroGetRemainingDuration( iEndingRound ), 24.0f);
			//string sAOETag =  HkAOETag( oCaster, -SPELL_GREASE, iStartingDC,  fRemainingDuration, FALSE  );
			effect eNewAOE = EffectAreaOfEffect(AOE_PER_RADFIRE, "", "", "", GetTag(oAOE) );
			DelayCommand( 0.1f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eNewAOE, GetLocation(oAOE), fRemainingDuration ) );
			DelayCommand( fRemainingDuration, DestroyObject(oAOE) );
			//SendMessageToPC(oCaster, "AOE with duration of"+FloatToString(fRemainingDuration)+" Ending on round "+IntToString(iEndingRound)+" current round "+IntToString(GetLocalInt( GetModule(), "CSL_CURRENT_ROUND" )) );
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile( "fx_blazing_fire_lg" ), GetLocation(oAOE), 2.0f );
			
			return;
		}
	}
	
	int iTargetDescriptor = CSLGetAOETagInt( SCSPELLTAG_DESCRIPTOR, oAOE );
	if ( iTargetDescriptor & SCMETA_DESCRIPTOR_WATER )
	{
		iDispelDC = CSLGetAOETagInt( SCSPELLTAG_SPELLDISPELDC, oAOE );
		if ( CSLEnviroConfictContest( oCaster, "You evaporated the Water", iStartingDC+10, iDispelDC  ) )
		{
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile( "fx_blazing_fire_lg" ), GetLocation(oAOE), 4.0f );
			DelayCommand( 3.0f, DestroyObject(oAOE) );
			return;
		}
	}
	
	if ( iTargetDescriptor & SCMETA_DESCRIPTOR_COLD )
	{
		int iSaveDC = CSLGetAOETagInt( SCSPELLTAG_SPELLDISPELDC, oAOE );
		if ( CSLEnviroConfictContest( oCaster, "You melted the ice", iStartingDC+10, iDispelDC  ) )
		{
			ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile( "fx_blazing_fire_lg" ), GetLocation(oAOE), 4.0f );
			DelayCommand( 3.0f, DestroyObject(oAOE) );
			return;
		}
	}
}

/**  
* Initiates the possible ignition of a target
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroIgniteTarget( int iDC, object oTarget, object oCaster = OBJECT_SELF ) // tests for if the given target can be ignited
{
	//int iEnviroStatus = GetLocalInt( oTarget, "CSL_ENVIRO" );
	//int iCharStatus = GetLocalInt( oTarget, "CSL_CHARSTATE" );
	int iSave = GetReflexSavingThrow(oTarget);
	if ( CSLGetIsFireBased( oTarget ) )
	{
		return;
	}
	if ( CSLGetElementalType( oTarget ) == SCRACE_ELEMENTALTYPE_WATER )
	{
		return;
	}
	iDC -= GetLocalInt( oTarget, "CSL_SOAKED");
	if ( GetLocalInt( oTarget, "CSL_FLAMMABLE") )
	{
		iDC += GetLocalInt( oTarget, "CSL_FLAMMABLE");
	}
	else
	{
		iSave += 20;
	}
	if ( iDC > 0 && CSLEnviroConfictContest( oCaster, "You ignited "+GetName(oTarget), iDC, iSave ) )  // 9+21 = 30 vs 50, 30 vs 35
	{
		CSLEnviroBurningStart( 10, oTarget);
	}
}

/**  
* Puts a creature currently burning back to a non burning state
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroBurningExtinguish( object oPC = OBJECT_SELF )
{
	CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLENVIRO_BURNING );
	SetLocalInt( oPC, "CSL_FLAMMABLE", 0 );
	SetLocalInt( oPC, "CSL_BURNING", 0 );
	CSLSubLocalBit( oPC, "CSL_CHARSTATE", CSL_CHARSTATE_BURNING );
}




/**  
* Applies the effects of a gust of wind on a single target
* @author
* @param 
* @see CSLEnviroWindGust
* @return 
*/
void CSLEnviroWindGustEffect( location lStartLocation, object oTarget )
{
	if ( GetIsObjectValid(oTarget) )
	{
			effect eDamage;
			float fDelay = GetDistanceBetweenLocations(lStartLocation, GetLocation(oTarget))/20;
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
			
			
			if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
			{
				if ( !CSLGetPreferenceSwitch("GustsLimitedToCloudSpells",FALSE) || CSLGetIsCloud( GetAreaOfEffectSpellId( oTarget ) ) )
				{
					DestroyObject(oTarget);
				}
			}
			else if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
			{
				if ( GetLocked(oTarget) == FALSE  && GetLocalString(oTarget, "SC_ARCANELOCK_CASTERTAG") == "" )
				{
					if (GetIsOpen(oTarget) == FALSE)
					{
						AssignCommand(oTarget, ActionOpenDoor(oTarget));
					}
					else
					{
						AssignCommand(oTarget, ActionCloseDoor(oTarget));
					}
				}
			}
			else
			{
				fDelay = GetDistanceBetweenLocations(lStartLocation, GetLocation(oTarget))/20;
				
				int iCreatureSize = GetCreatureSize(oTarget);
				int bFlying = CSLGetIsFlying(oTarget);
				int bKnockDown = FALSE;
				int iThrownFeet = 0;
				int iThrownDamage = 0;
				
				if ( bFlying && iCreatureSize == CREATURE_SIZE_TINY  )
				{
					iThrownFeet = d6()*10;
					iThrownDamage = d6(2);
				}
				else if ( iCreatureSize == CREATURE_SIZE_TINY  )
				{
					iThrownFeet = d4()*10;
					iThrownDamage = d4( CSLGetMax(iThrownFeet/10,1) );
					bKnockDown = TRUE;
				}
				else if ( bFlying && iCreatureSize == CREATURE_SIZE_SMALL  )
				{
					iThrownFeet = d6()*10;
				}
				else if ( iCreatureSize == CREATURE_SIZE_SMALL  )
				{
					bKnockDown = TRUE;
				}
				else if ( bFlying && ( iCreatureSize == CREATURE_SIZE_MEDIUM || iCreatureSize == CREATURE_SIZE_INVALID ) )
				{
					iThrownFeet = d6()*5;
				}
				else if ( iCreatureSize == CREATURE_SIZE_MEDIUM || iCreatureSize == CREATURE_SIZE_INVALID  )
				{
					bKnockDown = TRUE;
				}
				
				
				
				if ( iThrownFeet > 0 )
				{
					float fDistance = FeetToMeters(IntToFloat(iThrownFeet));
					CSLHurlTargetFromLocation(lStartLocation, oTarget, fDistance);
					SendMessageToPC( oTarget, "The wind throws you "+IntToString(iThrownFeet)+" Feet" );
					if ( iThrownDamage > 0 )
					{
						eDamage = EffectDamage(iThrownDamage, DAMAGE_TYPE_BLUDGEONING);
						ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
						
					}
				}
				
				if ( bKnockDown )
				{
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, RoundsToSeconds(1));
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  RoundsToSeconds(1), 1); // so i can track the fact they are knocked down and for how long, no other way to determine
						SendMessageToPC( oTarget, "The strong wind knocks you down" );
					}
				}
				
					
				effect eWind = EffectSkillDecrease(SKILL_LISTEN, 4);
				if ( GetWeaponRanged( GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget) ) )
				{
					eWind = EffectLinkEffects( eWind, EffectAttackDecrease(4, ATTACK_BONUS_MISC) );
					SendMessageToPC( oTarget, "You find it harder to aim into the strong wind" );
				}
				
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWind, oTarget, RoundsToSeconds(1) );
				
				
				CSLIncrementLocalInt( oTarget, "GUSTED", 1 );
				DelayCommand(6.0f+fDelay, CSLDecrementLocalInt_Void( oTarget, "GUSTED", 1 ) );
				
				//Apply effects to the currently selected target.
				//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				//This visual effect is applied to the target object not the location as above.  This visual effect
				//represents the flame that erupts on the target not on the ground.
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay,CSLTorchExtinguishObject( oTarget ) );
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_GLITTERDUST, SPELL_DECK_BUTTERFLYSPRAY);
				
			}
	}
}



/**  
* Creates a Wind Gust Area of Effect
* @author
* @param 
* @see 
* @return 
*/
void CSLEnviroWindGust( location lStartLocation, location lEndLocation, int iShape = SHAPE_CONE, float fRadius = RADIUS_SIZE_HUGE, int iGustDC = 20 ) // SHAPE_SPHERE
{
	int iObjectType;
	//effect eImpactVis = EffectVisualEffect( VFX_HIT_AOE_EVOCATION );
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lEndLocation);

	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(iShape, fRadius, lEndLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT, GetPositionFromLocation( lStartLocation ) );
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
		iObjectType = GetObjectType(oTarget);
		if ( iObjectType == OBJECT_TYPE_AREA_OF_EFFECT || iObjectType == OBJECT_TYPE_DOOR )
		{
			CSLEnviroWindGustEffect( lStartLocation, oTarget );
		}
		else if ( FortitudeSave(oTarget, iGustDC-CSLGetSizeModifierGrapple(oTarget) ) )
		{
			//SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE ));
			CSLTorchExtinguishObject( oTarget );
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_GLITTERDUST, SPELL_DECK_BUTTERFLYSPRAY);
		}
		else
		{
			CSLEnviroWindGustEffect( lStartLocation, oTarget );
			//SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE ));
		}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(iShape, fRadius, lEndLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT, GetPositionFromLocation( lStartLocation ) );
	}
}


/**  
* Description
* @author
* @todo need to make this a true lightning bolt, only really affecting if the player is a pc or a pc can see it.
* @param 
* @see 
* @return 
*/
void CSLEnviroLighteningBolt( location lStartLocation, location lEndLocation, int iShape = SHAPE_SPHERE, float fRadius = RADIUS_SIZE_HUGE, int iBoltDC = 20 ) // SHAPE_SPHERE
{
	int iObjectType;
	float fDelay;
	int iCasterLevel = 10;
	int iSaveType = SAVING_THROW_TYPE_ELECTRICITY ;
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = VFX_HIT_SPELL_LIGHTNING;
	int iDamageType = DAMAGE_TYPE_ELECTRICAL ;
	//int iImpactVis = VFX_SPELL_HIT_CALL_LIGHTNING;
	int iDurVis = VFX_SPELL_DUR_CALL_LIGHTNING;
	int iDamage;
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

    
    effect eLightningStrike = EffectVisualEffect(iHitEffect); //EffectLinkEffects(EffectVisualEffect(iHitEffect), EffectVisualEffect(iImpactVis));
    
    //effect eVis = EffectVisualEffect(iHitEffect);
	//effect eVis2 = EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING); //VFX_SPELL_HIT_CALL_LIGHTNING
	///effect eDur = ; //VFX_SPELL_DUR_CALL_LIGHTNING
	//effect eLink = EffectLinkEffects(eVis, eVis2);
    effect eDam;
    
    
    /*
    const int  = 2190;
const int  = 2191;
const int  = 2192;
const int  = 2193;
const int  = 2194;
const int  = 2195;

*/

	int iShapeEffect = CSLPickOneInt(VFXSC_FX_LIGHTNINGSTRIKE1, VFXSC_FX_LIGHTNINGSTRIKE2, VFXSC_FX_LIGHTNINGSTRIKE3, VFXSC_FX_LIGHTNINGSTRIKE4, VFXSC_FX_LIGHTNINGSTRIKE5, VFXSC_FX_LIGHTNINGSTRIKE6 );
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lEndLocation);
	
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING), GetLocation(oLocator));
	
	
	// 
	
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(iShape, fRadius, lEndLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE , GetPositionFromLocation( lStartLocation ) );
	
	if ( GetIsObjectValid(oTarget) ) // move the bolt to hit the first target
	{
		ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(iShapeEffect), GetLocation(oTarget) );
	}
	else
	{
		ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(iShapeEffect), lStartLocation );
	}
	
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
		//iObjectType = GetObjectType(oTarget);
		fDelay = CSLRandomBetweenFloat(0.05f, 0.45f);
		//Roll damage for each target
		iDamage = d6(iCasterLevel);
		//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
		iDamage = GetReflexAdjustedDamage(iDamage, oTarget, iBoltDC, iSaveType );
		//Set the damage effect
		eDam = EffectDamage(iDamage, iDamageType);
		if(iDamage > 0)
		{
			// Apply effects to the currently selected target.
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			//This visual effect is applied to the target object not the location as above.  This visual effect
			//represents the flame that erupts on the target not on the ground.
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLightningStrike, oTarget));
		}
		
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(iShape, fRadius, lEndLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE , GetPositionFromLocation( lStartLocation ) );
	}
	
	
}
			
				

/**  
* Creates an explosion effect
* @author
* @param 
* @see 
* @return 
*/
void CSLExplosion( location lStartLocation, location lEndLocation, int iShape = SHAPE_SPHERE, float fRadius = RADIUS_SIZE_HUGE, int iImpactDC = 20 )
{
	
		//effect eDam;
		float fDelay;
		int iDamage;
		int iNewDamage;
		//location lStartLocation = GetLocation(oTarget);
		int iFireDamage = 5;
		int iBluntDamage = 5;
		int iSaveType = SAVING_THROW_TYPE_ALL;
		int iDamageType = DAMAGE_TYPE_FIRE;
		
		effect eDamage;
		effect eKnock = EffectKnockdown();

	// explode them
		effect eExplode = EffectVisualEffect( CSLGetAOEExplodeByDamageType( iDamageType ) );
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lStartLocation );
		object oCurrentTarget = GetFirstObjectInShape(iShape, fRadius, lStartLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE  );
		while (GetIsObjectValid(oCurrentTarget))
		{
			iDamage = d6(iFireDamage);
			iNewDamage = GetReflexAdjustedDamage(iDamage, oCurrentTarget, iImpactDC, iSaveType );
			//Set the damage effect
			//eDam = EffectDamage(iDamage, iDamageType);
			if(iDamage == iNewDamage ) // they did not save at all
			{
				eDamage = EffectDamage(iNewDamage, iDamageType);
				eDamage = EffectLinkEffects( eDamage, EffectDamage(d6(iBluntDamage), DAMAGE_TYPE_BLUDGEONING) );
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCurrentTarget);
				CSLHurlTargetFromLocation(lStartLocation, oCurrentTarget, fRadius );
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oCurrentTarget, 4.0f);
				if ( !GetIsImmune( oCurrentTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
				{
					CSLIncrementLocalInt_Timed(oCurrentTarget, "CSL_KNOCKDOWN",  4.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
				}
			
			}
			else if ( iNewDamage > 0 ) // they saved and take some damage
			{
				eDamage = EffectDamage(iNewDamage, iDamageType);
				eDamage = EffectLinkEffects( eDamage, EffectDamage(d6(iBluntDamage)/2, DAMAGE_TYPE_BLUDGEONING) );
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCurrentTarget);
			
			}
			
			//Select the next target within the spell shape.
			oCurrentTarget = GetNextObjectInShape(iShape, fRadius, lStartLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
		}	
}



/**  
* Handles the holding breath checks each round
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroHoldBreath( int iBreathHoldingRounds, int iPreviousHitpoints, object oPC = OBJECT_SELF )
{
	int iRoundsCanHold = GetAbilityScore( oPC, ABILITY_CONSTITUTION, FALSE)*2;
	
	int iCurrentHitponts = GetCurrentHitPoints(oPC);
	int iMaxHitponts = GetMaxHitPoints(oPC);
	
	int iCharState = GetLocalInt( oPC, "CSL_CHARSTATE" );

	int iDC = GetLocalInt( oPC, "CSL_WATERDC" );
	int iAirBubbles = 0;
	
	if ( GetLocalInt( oPC, "CSL_LOSTBREATH" ) )
	{
		iBreathHoldingRounds = iBreathHoldingRounds+GetLocalInt( oPC, "CSL_LOSTBREATH" );
		//AssignCommand( oPC, ClearAllActions(TRUE) );
		FloatingTextStringOnCreature("*gulp*", oPC, TRUE);
		DeleteLocalInt( oPC, "CSL_LOSTBREATH" );
	}
	
	if ( iPreviousHitpoints != 0 && iCurrentHitponts < iPreviousHitpoints )
	{
		// we've lost hit points, this does not include hitpoints lost from drowning
		if( !GetIsSkillSuccessful(oPC, SKILL_CONCENTRATION, 10 + ( ( iPreviousHitpoints - iCurrentHitponts ) / iMaxHitponts )*10 ) )
		{
			//AssignCommand( oPC, ClearAllActions(TRUE) );
			iBreathHoldingRounds += ( ( iPreviousHitpoints - iCurrentHitponts ) / iMaxHitponts )*10;
			SendMessageToPC(oPC, "You could not concentrate well enough and lost some air!");
		}
	}
	
	 
	
	if ( iBreathHoldingRounds > iRoundsCanHold )
	{
		// now is getting hard to save, must save each round to avoid drowning
		
		
		if ( iCharState & CSL_CHARSTATE_DROWNING || !CSLAbilityCheck( oPC, ABILITY_CONSTITUTION, iDC, 0, TRUE, TRUE, TRUE  )  )
		{
			 if ( !iCharState & CSL_CHARSTATE_DROWNING)
			 {
				iDC = 20; // this is no longer used to the con check, but will be recycled for the morale check
			 }
			 iCharState |= CSL_CHARSTATE_DROWNING;
			 SendMessageToPC(oPC, "You cannot fight the urge to breath any longer! With a gasp, you inhale a large amount of water into your lungs!");
			 int iDamage = CSLGetMax( iMaxHitponts / 10, 1 );
			 ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE), oPC);
			  
			 if ( GetHasSpellEffect(-SPELL_FEAR,oPC) || !WillSave(oPC, iDC, SAVING_THROW_TYPE_FEAR) )
			 {
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SetEffectSpellId( CSLGetFearEffect(TRUE), -SPELL_FEAR), oPC, 9.0f);
			 }
			 
			 if ( iCurrentHitponts < (iMaxHitponts/2) ) // when hit points are reduced below half
			 {
				iDC++;
			 }
			 iDC++;
			 iBreathHoldingRounds++; // loses breath even faster now, but it's not going to be noticed really
			 FloatingTextStringOnCreature("*choke*", oPC, TRUE);
		}
		else
		{
			SendMessageToPC(oPC, "You struggle to hold your breath and are not sure how long you can continue!");
		}
		iDC++;
	
	}
	//else if ( iBreathHoldingRounds == iRoundsCanHold-5 ) 
	//{
	//	SendMessageToPC(oPC, "You have a short time, " + IntToString(iRoundsCanHold-iBreathHoldingRounds) + " rounds, before holding your breath will become very difficult.");
	//}
	else if ( iBreathHoldingRounds > 0 && ( iBreathHoldingRounds > iRoundsCanHold-10 || CSLGetIsDivisible( iRoundsCanHold-iBreathHoldingRounds,5 ) ) ) 
	{
		FloatingTextStringOnCreature("( "+IntToString( iRoundsCanHold-iBreathHoldingRounds )+" )", oPC, TRUE);
	}
	
	
	if ( iBreathHoldingRounds == 0 ) 
	{
		// You can hold your breath for a number of rounds equal to twice your constitution score.
		iBreathHoldingRounds = 1;
		iDC = 10; 
		SendMessageToPC(oPC, "You start holding your breath and have " + IntToString(iRoundsCanHold) + " rounds, before holding your breath will become very difficult.");
		
	}
	else
	{
		if ( !GetIsInCombat( oPC ) )
		{
			iAirBubbles = GetLocalInt( oPC, "CSL_AIRBUBBLES");
		}
		
		if ( iAirBubbles && iBreathHoldingRounds > 3 )
		{
			iBreathHoldingRounds -= iAirBubbles;
		}
		else
		{
			iBreathHoldingRounds++;
		}
	}
	SetLocalInt( oPC, "CSL_WATERDC", iDC );
	SetLocalInt( oPC, "CSL_CHARSTATE", iCharState );
	return iBreathHoldingRounds;
}


/**  
* Correctly toggles the various water state bits in the characters state
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroToggleWaterStateBits( int iCharState, int iBitToSet = 0 )
{
	
	iCharState &= ~CSL_CHARSTATE_SPLASHING;
	iCharState &= ~CSL_CHARSTATE_WADING;
	iCharState &= ~CSL_CHARSTATE_SUBMERGED;
	
	if ( iBitToSet == 0 )
	{
		return iCharState;
	}
	else
	{
		return iCharState | iBitToSet;
		//iCharState |= iBitToSet;
		//return iCharState;
	}
}









/**  
* Removes lower level darkness effects in the given area
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroRemoveLowerLevelDarknessEffect(int iSpellLevel, object oTarget)
{
    int bRemoved = FALSE;
    switch(iSpellLevel)
    {
        case 10: 
        case 9: 
        case 8:
        case 7:
		case 6:
		case 5:
		case 4:
			if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DEEPER_DARKNESS, SPELL_BLACKLIGHT) )
			{ 
				bRemoved = TRUE;
			}
		case 3:
			if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DARKNESS, SPELLABILITY_AS_DARKNESS, SPELLABILITY_DRIDERDARKNESS, SPELL_SHADOW_CONJURATION_DARKNESS ) )
			{ 
				bRemoved = TRUE;
			}
		case 2:
			
		case 1:
		case 0:
    }
    return bRemoved;
}



/**  
* Removes lower level light effects in the given area
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroRemoveLowerLevelLightEffect(int iSpellLevel, object oTarget)
{
    int bRemoved = FALSE;
    switch(iSpellLevel)
    {
        case 10: 
        case 9: 
        case 8:
        case 7:
		case 6:
		case 5:
		case 4:
			if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DAYLIGHT_CLERIC, SPELL_DAYLIGHT ) )
			{ 
				bRemoved = TRUE;
			}
		case 3:
			
		case 2:
		case 1:
		
			if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LIGHT, SPELL_NONMAGICLIGHT, -SPELLABILITY_LITTORCH ) )
			{ 
				bRemoved = TRUE;
			}
		case 0:
    }
    return bRemoved;
}




/**  
* Checks for lower level darkness effects in the given area
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetHasLowerLevelDarknessEffect(int iSpellLevel, object oTarget)
{
    switch(iSpellLevel)
    {
        case 10: 
        case 9: 
        case 8:
        case 7:
		case 6:
		case 5:
		case 4:
			if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DEEPER_DARKNESS, SPELL_BLACKLIGHT ))
			{ 
				return TRUE;
			}
		case 3:
			
		
			if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DARKNESS, SPELLABILITY_AS_DARKNESS, SPELLABILITY_DRIDERDARKNESS, SPELL_SHADOW_CONJURATION_DARKNESS ))
			{
				return TRUE;
			}
		case 2:
		case 1:
		case 0:
    }
    return FALSE;
}



/**  
* Checks for lower level light effects in the given area
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetHasLowerLevelLightEffect(int iSpellLevel, object oTarget)
{
    switch(iSpellLevel)
    {
        case 10: 
        case 9: 
        case 8:
        case 7:
		case 6:
		case 5:
		case 4:
			if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DAYLIGHT, SPELL_DAYLIGHT_CLERIC ))
			{ 
				return TRUE;
			}
		case 3:
		case 2:
		case 1:
		if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_LIGHT, SPELL_NONMAGICLIGHT, -SPELLABILITY_LITTORCH ))
			{
				return TRUE;
			}
		case 0:
			if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DAYLIGHT, SPELL_DAYLIGHT_CLERIC ))
			{ 
				return TRUE;
			}
		
    }
    return FALSE;
}



/**  
* Checks if an effect is a higher level darkness effect
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetHasHigherLevelDarknessEffect(int iSpellLevel, object oTarget)
{
    switch(iSpellLevel)
    {
		case -1:
		case 0:
		case 1:
			if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DARKNESS, SPELLABILITY_AS_DARKNESS, SPELLABILITY_DRIDERDARKNESS, SPELL_SHADOW_CONJURATION_DARKNESS ))
			{
				return TRUE;
			}
		case 2:
			if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DEEPER_DARKNESS, SPELL_BLACKLIGHT ))
			{ 
				return TRUE;
			}
		case 3:
		case 4:
		case 5:
		case 6:
        case 7:
        case 8:
        case 9: 
        case 10:
    }
    return FALSE;
}



/**  
* Checks if an effect is a higher level light effect
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetHasHigherLevelLightEffect(int iSpellLevel, object oTarget)
{
    switch(iSpellLevel)
    {
		case -1:
			if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_LIGHT, SPELL_NONMAGICLIGHT, -SPELLABILITY_LITTORCH ))
			{
				return TRUE;
			}
		case 0:
		case 1:
		case 2:
			if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DAYLIGHT, SPELL_DAYLIGHT_CLERIC ))
			{ 
				return TRUE;
			}
		case 3:
		case 4:
		case 5:
		case 6:
        case 7:
        case 8:
        case 9: 
        case 10: 
    }
    return FALSE;
}





/**  
* Checks for higher level light effects in the given area
* @author
* @param 
* @see 
* @replaces SCGetHigherLvlLightEffectsInArea(int iSpellId, location lTarget) 
* @return 
*/
int CSLEnviroGetIsHigherLevelLightEffectsInArea( location lTarget, int iSpellLevel, float fRadius = 20.0f)
{
    object oTarget;
    
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fRadius), lTarget, FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT );

    while(GetIsObjectValid(oTarget))
    {
		switch(iSpellLevel)
		{
			case -1:
				if( GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_LIGHT, -SPELLABILITY_LITTORCH, SPELL_NONMAGICLIGHT  ) )
				{
					return TRUE;
                }
                else if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_LIGHT, SPELL_NONMAGICLIGHT, -SPELLABILITY_LITTORCH ))
                {
					return TRUE;
				}
			case 0:
			case 1:
			case 2:
				if( GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_DAYLIGHT, SPELL_DAYLIGHT_CLERIC ) )
				{
					return TRUE;
                }
                else if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DAYLIGHT, SPELL_DAYLIGHT_CLERIC ))
                {
					return TRUE;
				}
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9: 
			case 10: 
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fRadius), lTarget, FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_CREATURE);
    }
    return FALSE;
}


/**  
* Checks for higher level darkness effects in the given area
* @author
* @param 
* @see 
* @replaces SCGetHigherLvlDarknessEffectsInArea(int iSpellId, location lTarget)
* @return 
*/
int CSLEnviroGetIsHigherLevelDarknessEffectsInArea( location lTarget, int iSpellLevel, float fRadius = 20.0f)
{
    object oTarget;
    
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fRadius), lTarget, FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT );

    while(GetIsObjectValid(oTarget))
    {
		switch(iSpellLevel)
		{
			case -1:
			case 0:
			case 1:
				if( GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_DARKNESS, SPELLABILITY_AS_DARKNESS, SPELLABILITY_DRIDERDARKNESS, SPELL_SHADOW_CONJURATION_DARKNESS ) )
				{
					return TRUE;
                }
                else if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DARKNESS, SPELLABILITY_AS_DARKNESS, SPELLABILITY_DRIDERDARKNESS, SPELL_SHADOW_CONJURATION_DARKNESS ))
                {
					return TRUE;
				}
			case 2:
				if( GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_DAYLIGHT_CLERIC, SPELL_DAYLIGHT ) )
				{
					return TRUE;
                }
                else if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_DEEPER_DARKNESS, SPELL_BLACKLIGHT ))
                {
					return TRUE;
				}
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9: 
			case 10:
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fRadius), lTarget, FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_CREATURE);
    }
    return FALSE;
}


/**  
* Removes lower level light effects in an area
* @author
* @param 
* @see 
* @replaces SCRemoveLowerLvlLightEffectsInArea(int iSpellId, location lTarget)
* @return 
*/
int CSLEnviroRemoveLowerLevelLightEffectsInArea( location lTarget, int iSpellLevel, float fRadius = 10.0f)
{
    object oTarget;
    int bRemoved = FALSE;
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fRadius), lTarget, FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT );

    while(GetIsObjectValid(oTarget))
    {
        switch(iSpellLevel)
		{
			case 10: 
			case 9: 
			case 8:
			case 7:
			case 6:
			case 5:
			case 4:
			case 3:
				if(GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_DAYLIGHT_CLERIC, SPELL_DAYLIGHT ) )
				{
					DestroyObject(oTarget);
					bRemoved = TRUE;
                }
                else
                {
					if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DAYLIGHT_CLERIC, SPELL_DAYLIGHT ) )
					{
						bRemoved = TRUE;
					}
				}
			
			case 2:
			case 1:
			case 0:
			//object GetAreaOfEffectCreator(object oAreaOfEffectObject=OBJECT_SELF);
			//int GetAreaOfEffectSpellId( object oAreaOfEffectObject=OBJECT_SELF );
			// if(GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_LIGHT, -SPELLABILITY_LITTORCH ) )
			// , 
				if(GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && GetAreaOfEffectSpellId( oTarget ) == SPELL_LIGHT )
				{
					DestroyObject(oTarget);
					bRemoved = TRUE;
                }
                else if(GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && GetAreaOfEffectSpellId( oTarget ) == -SPELLABILITY_LITTORCH )
				{
					
					CSLTorchExtinguishObject( GetAreaOfEffectCreator(oTarget) );
					// make sure AOE goes away, may or may not be needed
					DestroyObject(oTarget);
					bRemoved = TRUE;
                }
                else
                {
					if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LIGHT, SPELL_NONMAGICLIGHT, -SPELLABILITY_LITTORCH ) )
					{
						bRemoved = TRUE;
					}
				}
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fRadius), lTarget, FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_CREATURE);
    }
    return bRemoved;
}





/**  
* Removes lower level darkness effects in an area
* @author
* @param 
* @see 
* @replaces SCRemoveLowerLvlDarknessEffectsInArea(int iSpellId, location lTarget)
* @return 
*/
int CSLEnviroRemoveLowerLevelDarknessEffectsInArea( location lTarget, int iSpellLevel, float fRadius = 10.0f)
{
    object oTarget;
	int bRemoved = FALSE;
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(fRadius), lTarget, FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oTarget))
    {
        switch(iSpellLevel)
		{
			case 10: 
			case 9: 
			case 8:
			case 7:
			case 6:
			case 5:
			case 4:
			case 3:
				if(GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_DEEPER_DARKNESS, SPELL_BLACKLIGHT ) )
				{
					DestroyObject(oTarget);
                }
                else
                {
					if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DEEPER_DARKNESS, SPELL_BLACKLIGHT) )
					{
						bRemoved = TRUE;
					}
				}
			case 2:
				if(GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT && CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_DEEPER_DARKNESS, SPELL_BLACKLIGHT ) )
				{
					DestroyObject(oTarget);
                }
                else
                {
					if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DARKNESS, SPELLABILITY_AS_DARKNESS, SPELLABILITY_DRIDERDARKNESS, SPELL_SHADOW_CONJURATION_DARKNESS) )
					{
						bRemoved = TRUE;
					}
				}
			case 1:
			case 0:
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(fRadius), lTarget, FALSE, OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR | OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    }
    return bRemoved;
}



/**  
* Get the Spell Level for the given Darkness or Light Spell
* @author
* @param 
* @see 
* @return 
*/
int CSLEnviroGetLightDarkSpellLevel( int iSpellId )
{
	// this is also where i organize which spells are which level
	switch(iSpellId)
    {
		case SPELL_DAYLIGHT_CLERIC:
			return 3;
			break;
		case SPELL_DAYLIGHT:
			return 3;
			break;
		case SPELL_DEEPER_DARKNESS:
			return 3;
			break;
		case SPELL_BLACKLIGHT:
			return 3;
			break;
		case SPELL_DARKNESS:
		case SPELLABILITY_AS_DARKNESS:
		case SPELLABILITY_DRIDERDARKNESS:
			return 2;
			break;
		case SPELL_LIGHT:
		case SPELL_NONMAGICLIGHT:
		case -SPELLABILITY_LITTORCH:
			return 0;
			break;
		case SPELL_SHADOW_CONJURATION_DARKNESS:
            return 2; // 4 is level but should this be 2 since it's casting a lower level spell
			break;
	}
	return -1;
}
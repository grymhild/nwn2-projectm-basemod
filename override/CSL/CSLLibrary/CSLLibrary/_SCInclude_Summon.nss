/** @file
* @brief Include File for Summon Magic System
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/




/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////
const int CSL_SUMMONMETHOD_NONE = 0;
const int CSL_SUMMONMETHOD_SINGLE = 1; // Simply summons the given creature
const int CSL_SUMMONMETHOD_RADIAL = 3; // Each radial spell correlates to a different column, this allows using a lower level version for example, 1st column is used with master spell, other 5 are used with subradials
const int CSL_SUMMONMETHOD_RANDOM = 4; // Each column present has an equal chance of being used ( the **** doesn't count )
const int CSL_SUMMONMETHOD_CHAIN = 5; // Each column present is used as a chain summon, once all the first set of summons are killed, the second set appears
const int CSL_SUMMONMETHOD_LEVELED = 6; // 6 columns correlate to the caster levels, allowing the creature to improve as you increase in level, generally improving every 5 levels, 0-5, 6-10, 11-15, 16-20, 21-25, 26-30

// these are D&D terms
const int CSL_SUMMONCONTROL_FREEAGENT = 2; // Creature is free willed, basically this just spawns creatures
const int CSL_SUMMONCONTROL_SERVANT = 3; // Creature is completely under the control and the side of the caster
const int CSL_SUMMONCONTROL_SLAVE = 4; // Creature is completely under the control of the caster, but if given the chance will turn on the said caster ( certain magics can steal control )
const int CSL_SUMMONCONTROL_PAID_SERVITUDE = 5; // Creature is only under control if the caster offers a suitable offering ( larva for a demon for example, basically a material component, if caster does not have it, the summon turns on them )

const int CSL_SUMMONCONTROL_PROTECTED_SERVITUDE = 6; // Creature is only under control while the caster is protected, generally with something like a protection from evil or a pentagram
const int CSL_SUMMONCONTROL_TIMED_SERVITUDE = 7; // Creature is only under control for a limited duration ( generally about 10 rounds )
const int CSL_SUMMONCONTROL_WILLED_SERVITUDE = 8; // Creature is only under control for a limited duration based on the will of the caster, a stronger summon will attempt to break free, and hits to the caster can disrupt the will power
const int CSL_SUMMONCONTROL_CONCENTRATE_SERVITUDE = 9; // Creature is only under control for a limited duration based on the concentration of the caster, the caster casting any other spells will end the effect ( SetLocalInt(oSummon,"X2_L_CREATURE_NEEDS_CONCENTRATION",TRUE); )

// these are based on NWN2 spell effects, the above use domination
const int CSL_SUMMONCONTROL_EFFECTSUMMON = 11; // Creature is limited to a single creature at a time, and will be despawned on creation of a new creature
const int CSL_SUMMONCONTROL_EFFECTSWARM = 12;

// constants
const int SPELL_SUMMON_CREATURE_0 = 5839;

//SPELL_SUMMON_CREATURE_I = 174;
const int SPELL_SUMMON_CREATURE_I_NORMAL = 5840;
const int SPELL_SUMMON_CREATURE_I_D3_0 = 5841;

// SPELL_SUMMON_CREATURE_II = 175;
const int SPELL_SUMMON_CREATURE_II_NORMAL = 5842;
const int SPELL_SUMMON_CREATURE_II_D3_I = 5843;
const int SPELL_SUMMON_CREATURE_II_D4P1_0 = 5844;

//SPELL_SUMMON_CREATURE_III = 176;
//SPELL_BG_Summon_Creature_III;
const int SPELL_SUMMON_CREATURE_III_NORMAL = 5845;
const int SPELL_SUMMON_CREATURE_III_D3_II = 5846;
const int SPELL_SUMMON_CREATURE_III_D4P1_I = 5847;
const int SPELL_SUMMON_CREATURE_III_D4P1_0 = 5848;

//SPELL_SUMMON_CREATURE_IV = 177;
const int SPELL_SUMMON_CREATURE_IV_NORMAL = 5849;
const int SPELL_SUMMON_CREATURE_IV_D3_III = 5850;
const int SPELL_SUMMON_CREATURE_IV_D4P1_II = 5851;
const int SPELL_SUMMON_CREATURE_IV_D4P1_I = 5852;
const int SPELL_SUMMON_CREATURE_IV_D4P1_0 = 5853;

//SPELL_SUMMON_CREATURE_V = 179;
const int SPELL_SUMMON_FIENDISH_LEGACY = 5838;
const int SPELL_SUMMON_CREATURE_V_NORMAL = 5854;
const int SPELL_SUMMON_CREATURE_V_D3_IV = 5855;
const int SPELL_SUMMON_CREATURE_V_D4P1_III = 5856;
const int SPELL_SUMMON_CREATURE_V_D4P1_II = 5857;
const int SPELL_SUMMON_CREATURE_V_D4P1_I = 5858;

//SPELL_SUMMON_CREATURE_VI = 180;
const int SPELL_SUMMON_CREATURE_VI_NORMAL = 5859;
const int SPELL_SUMMON_CREATURE_VI_D3_V = 5860;
const int SPELL_SUMMON_CREATURE_VI_D4P1_IV = 5861;
const int SPELL_SUMMON_CREATURE_VI_D4P1_III = 5862;
const int SPELL_SUMMON_CREATURE_VI_D4P1_II = 5863;

//SPELL_SUMMON_CREATURE_VII = 181;
const int SPELL_SUMMON_CREATURE_VII_NORMAL = 5864;
const int SPELL_SUMMON_CREATURE_VII_D3_VI = 5865;
const int SPELL_SUMMON_CREATURE_VII_D4P1_V = 5866;
const int SPELL_SUMMON_CREATURE_VII_D4P1_IV = 5867;
const int SPELL_SUMMON_CREATURE_VII_D4P1_III = 5868;

//SPELL_SUMMON_CREATURE_VIII = 182;
//SPELL_SHADES_TARGET_GROUND;
const int SPELL_SUMMON_CREATURE_VIII_NORMAL = 5869;
const int SPELL_SUMMON_CREATURE_VIII_D3_VII = 5870;
const int SPELL_SUMMON_CREATURE_VIII_D4P1_VI = 5871;
const int SPELL_SUMMON_CREATURE_VIII_D4P1_V = 5872;
const int SPELL_SUMMON_CREATURE_VIII_D4P1_IV = 5873;

//SPELL_SUMMON_CREATURE_IX = 178;
const int SPELL_SUMMON_CREATURE_IX_NORMAL = 5874;
const int SPELL_SUMMON_CREATURE_IX_D3_VIII = 5875;
const int SPELL_SUMMON_CREATURE_IX_D4P1_VII = 5876;
const int SPELL_SUMMON_CREATURE_IX_D4P1_VI = 5877;
const int SPELL_SUMMON_CREATURE_IX_D4P1_V = 5878;

/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

#include "_HkSpell"
#include "_CSLCore_ObjectVars"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

void SCSummonRemove( object oSummon );


/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/*

Various 2da's configure how this works, or it can be adjusted on the fly via databases, designed initially to work like the vanilla game and from 2da's, the fact it loads it into memory into a control object means
An option to indicate ALL tables are loaded will allow database based systems to not keep loading, possibly add an option to change the summons on the fly and save this back to the database

Storage configuration for a single table. Tables for Magic, Nature, Undead, and Planar for 
		each alignment ( demonic, angelic, chaotic, lawful ) and for each alignment and for the 4 elements ( fire, water, air, earth ).
        Variation tables for specific environments, table names are stored on the triggers or area in question. Note variation tables should
        have similar methods since it's going to vary which one is used. Descriptors will be used to help determine how some of this works.
        Some spells are planned, like a corrupting summon AOE which causes all summoning to summon creatures that are Free willed AND are
        demons under no ones control, similar to some areas which have strong undead presences.

Column Definitions
Label - name of the level, not used except for the 2da editors reference, can list the names of the
    spells. ( LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5, LEVEL_6, LEVEL_7, LEVEL_8, LEVEL_9, 
    LEVEL_10, LEVEL_11_GATE, LEVEL_12_GATE, LEVEL_13_EPIC, LEVEL_14_EPIC, LEVEL_15_EPIC )
    Generally the rows are set up as follows, one for each spell, monster summoning 1 would do
    the LEVEL_1 slot, but via a feat that enhances might do the LEVEL_2 slot. Note the epic spells are
    in the higher slots along with the summoning, as well as the gate.

Method = The summonin logic used to determine how the creature is picked and other advanced features.
	 None: Nothing is summoned
	 Single: Only Resref_1 is used and the rest are ignored. Simplest method.
	 Radial: This correlates to having radials set up for spells, each Resref_2,
	         Resref_3, etc correlates to a different sub menu, and Resref_1 
	         is used by NPCs and for those not using the radial. 
	 Random: Resref_1, Resref_2, Resref_3, etc used is entirely random. **** are ignored.
	 Chain: This works like single, in that when the first creature(Resref_1) is killed, 
	        Resref_2 is automatically summoned, and so forth. 
	        If multiple all of that group have to be killed before the chain kicks in.
	 Leveled: uses LeveledStart, and LeveledSteps to determine how this works, if nothing there
	          it defaults to 0 start and 5 interval which is improving every 5 levels, 0-5, 6-10,
	          11-15, 16-20, 21-25, 26-30 and changing the Resref_1 column each time.

Control = various systems for control of the summoned creature
	Free: Creature is free willed, basically this just spawns creatures
	Servant: Creature is completely under the control and the side of the caster
	Slave: Creature is completely under the control of the caster, but if given the chance will turn
	       on the said caster ( certain magics can steal control )
	Protected: Creature is only under control while the caster is protected, generally with
	       something like a protection from evil or a pentagram
	Timed: Creature is only under control for a limited duration ( generally about 10 rounds ) then
	       it goes hostile
	Willed: Creature is only under control for a limited duration based on the will of the caster, a
	       stronger summon will attempt to break free, and hits to the caster can disrupt the will power
	Concentrate: Creature is only under control for a limited duration based on the concentration of
	       the caster, the caster casting any other spells will end the effect
	       ( SetLocalInt(oSummon,"X2_L_CREATURE_NEEDS_CONCENTRATION",TRUE); )
	Paid: Creature is only under control if the caster offers a suitable offering ( larva for a
	       demon for example, basically a material component, if caster does not have it, the summon turns
	       on them ) You have to have a material component or the summon goes hostile right away.

Resref_1 to Resref_6 = 6 different fields ( resref field, can hold multiple creatures and special
    codes but defines the creature summoned and number appearing )

			A | character ( pipe ) indicates that there are multiple choices
			A : character ( colon ) indicates quantity which precedes it, it can be 1d4 or 4 for example
			A ? is replaced with the caster level of the given spell, note 
			that enhancements allow this to exceed level 30, need up to 35 as a max
			
			Examples:
				Simplest 
				"c_dogwolf" // up to 4 resrefs are available based on the above
				
				Multiple Choice, equal chance of each showing up
				"c_dogwolf|c_dogwolf2"
				
				Multiple, summons 2 of the given creature
				"2:c_dogwolf"
				
				Multiple, summones from 1 to up to 2 of the given creature, try not 
				to exceed 10 total which is the sanity cap ( rolling 2d6 and getting 
				12 will make 10 summons appear, but if the total is 9, 9 will show up )
				"1d2:c_dogwolf"
				
				And this can be combined, this does cats, dogs or rats equal chance, but it also does 1d4 
				if it's cats, one dog, or 5 rats. The dog will use the resref of c_dog5 if its a level 5 caster.
				( you'd have to make 35 or so blueprints to cover all possible levels )
				"1d4:c_cat|c_dog?|5:c_rat"

OnSummonScript = runs on the summon being created, and in addition to the event which is triggered,
    for making fire creatures die immediately in water for example

OnUnSummonScript = runs on the spells duration ending, or on the caster resting, dying, being
    dispelled and the like, and in addition to the event which is triggered

OnSummonEffect = visual effect applied to the summon, used to color or adjust the summons to match
    the area it's in

LeveledStart = 0
LeveledSteps = 5 - these two fields correlate to the leveled option, this lets you do the default
    which does level 0 correlating to the 1st resref, and at 5th it steps up to the next resref. This
    can be changed to start at level 9 for example and step up like 9, 12, 15, 18, 21, 24, and would be
    entered as 9 and 3 in these fields.

Protection = Caster must have this spell id or the summon turns on them. The protection from evil is hard wired to know about variations.
	FromEvil
	FromGood
	FromChaos
	FromLaw
	Pentagram
	Sanctuary

Formation = Default formation if multiple creatures. Defaults to none, and will look at grinning fools code on his new UI for doing this later on.


Events:
OnSummon   = edit _mod_onsummoncreature.nss to modify this or add extra rules
OnUnsummon = edit _mod_onunsummoncreature.nss to modify this or add extra rules
OnSummonHeartbeat = edit _mod_onsummonheartbeat.nss to modify this or add extra rules, this should be avoided



Implementation:

Just some detail to allow folks to implement database driven instead of 2da based versions. Data is structured. If someone does the DB work i'll make a wrapper and let that structure be the standard, to me 2da's are good enough since it's cached, but a DB would allow dm's to adjust what is summoned on the fly.


DataStorageObject: stores a cache of all this 2da data, it' s created and filled with content on an initialization, also allows shifting to database based systems since both the database and the 2da's store things on this object so the scripter can set them up as needed.

// This configures a single spell for example, showing the naming system and the stored information
int DATAOBJECT["MAGIC-LEVEL_2-METHOD"]= CSL_SUMMONMETHOD_SINGLE
int DATAOBJECT["MAGIC-LEVEL_2-CONTROL"]= CSL_SUMMONCONTROL_SLAVE
string DATAOBJECT["MAGIC-LEVEL_2-RESREF1"]="c_dogwolf" // up to 4 resrefs are available based on the above
string DATAOBJECT["MAGIC-LEVEL_2-RESREF2"]="c_dogwolf2" // choices stored separated by pipes here

// this shows which tables are available, if it's set up but 2da is missing it just uses the core table
int DATAOBJECT["MAGIC"]=TRUE; // indicates the magic table is loaded
int DATAOBJECT["MAGIC-UNDERWATER"]=TRUE; // indicates the water table exists
int DATAOBJECT["MAGIC-FIRE"]=FALSE; // indicates this table does not exist

// will be adding feature to allow redirects between tables so you don't have to load an entire table into the object.

SummonedCreatureHandler: - Iterates the summons and fixes issues with ones that are no longer controled, their duration has expired or the like, planned but since it's registering summons as they are created it will scale and only cause issues if there are a lot of summons.



/////////////////////////////////////////////////////

Now if this same spell is cast under water, table name is changed from "MAGIC" to "MAGIC-UNDERWATER", if there is an "UNDERWATER" table it is used instead.

This is called the override and is stored in HKTEMP_ or as a variable on the area. Basically only one override can be in effect at one time, but this can probably be extended.
This also is affected by the environment modifiers at the target location, if it's targeting a fire, the summons will be from the "FIRE" table if it exists. ( for example undead might be another blueprint which happens to be on fire like the hellfire skeletons )

Tables that are attempted to be loaded are stored on the data object, so if it does not exist it's only checked once.

So on the data object
 


Now table types can vary, a specific character can have his own version of a table as well, which is modified in memory via feats and the like, this only replaces a main table
( in other words a character can have a specific table replacing a normal table - but if they end up using the underwater table for example it ends up using the alternate instead )
( code to remove tables which are for individiual characters if they are logged off will be needed to have this work on servers that don't reset, or for them to reinitialize )
So the magic and magic underwater tables become
"MAGIC-CHARNAME"
"MAGIC-UNDERWATER-CHARNAME"

Table routing, a table can be rerouted to another type

Main Tables
Magic - basic monster summoning spell which summon magical beasts
Nature - summons beasts of the forests
Undead - Necromancy


Planar - note that these resolve around descriptors to a degree
	Elemental has tables for each element
	Water
	Fire
	Air
	Earth
	
	Planar has tables for each 
	Profane - summons creatures which are devils and demons from the outer planes
	Angelic - Summons creatures from the heavens, angels and the hosts of heaven
	Chaotic - Summons the creatures of chaos, tend to be singular creatures of more power which are not always under control of the caster
	Lawful - Summons the creatures of law, tend to be formations basically

10-20

// this function is called from a given spell
void SCSummonCreature( sSummoningTable, object oCaster, int iCasterLevel, int iSummonLevel, float fDuration, int iSummonEffect, location lTargetLocation int iMainSpellId = -1, int iRadialSpellId1 = -1, iRadialSpellId2 = -1, iRadialSpellId3 = -1, iRadialSpellId4 = -1, iRadialSpellId5 = -1)


if (GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL) || GetHasSpellEffect(SPELL_HOLY_AURA))
	{


*/

/*
void MultisummonPreSummon(object oPC = OBJECT_SELF, int bOverride = FALSE)
{
    if(!CSLGetPreferenceSwitch(PRC_MULTISUMMON) && !bOverride)
        return;
    int i=1;
    int nCount = CSLGetPreferenceSwitch(PRC_MULTISUMMON);
    if(bOverride)
    {
        nCount = bOverride;
    }
    
    if(nCount < 0 || nCount == 1)
    {
        nCount = 99;
    }
    
    if(nCount > 99)
    {
        nCount = 99;
    }   
    CSLMultiSummonStacking(oPC,nCount);
}

*/

// This blocks the ability to destroy summons while they are created, soas to allow multiple summons to appear
// Need to test how this works
// Idea from the PRC
void CSLMultiSummonStacking( object oCaster = OBJECT_SELF, int iMaxAllowedSummons = 1, float fSafeDuration = 0.1f )
{
	if ( iMaxAllowedSummons == 1 )
	{
		return;
	}
	int i = 1;
	object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    while(GetIsObjectValid(oSummon) && i < iMaxAllowedSummons )
    {
        AssignCommand(oSummon, SetIsDestroyable(FALSE, FALSE, FALSE));
        AssignCommand(oSummon, DelayCommand( fSafeDuration, SetIsDestroyable(TRUE, FALSE, FALSE)));
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
    }
}


int CSLGetControlledUndeadTotalHD(object oPC = OBJECT_SELF)
{
    int nTotalHD;
    int i = 1;
    object oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummonTest))
    {
        if( CSLGetIsUndead(oSummonTest) )
        {
            nTotalHD += GetHitDice(oSummonTest);
        }
        if(DEBUGGING)FloatingTextStringOnCreature(GetName(oSummonTest)+" is summon number "+IntToString(i), oPC);
        i++;
        oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
    return nTotalHD;
}


int SCGetControlledFiendTotalHD(object oPC = OBJECT_SELF)
{
    int nTotalHD;
    int i = 1;
    object oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummonTest))
    {
        if( CSLGetIsFiend(oSummonTest) )
        {
            nTotalHD += GetHitDice(oSummonTest);
        }
        if(DEBUGGING)FloatingTextStringOnCreature(GetName(oSummonTest)+" is summon number "+IntToString(i), oPC);
        i++;
        oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
    return nTotalHD;
}

int SCGetControlledCelestialTotalHD(object oPC = OBJECT_SELF)
{
    int nTotalHD;
    int i = 1;
    object oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummonTest))
    {
        if(CSLGetIsOutsider(oSummonTest) && GetAlignmentGoodEvil(oSummonTest) == ALIGNMENT_GOOD)
            nTotalHD += GetHitDice(oSummonTest);
        if(DEBUGGING)FloatingTextStringOnCreature(GetName(oSummonTest)+" is summon number "+IntToString(i), oPC);
        i++;
        oSummonTest = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
    return nTotalHD;
}



// this just covers the basic monster summoning spells for the magical line of spells
int SCSummonGetLevel( int iSpellId )
{
	switch ( iSpellId )
	{
		case SPELL_SUMMON_CREATURE_0: 
			return 0;
			break;
		
		case SPELL_SUMMON_CREATURE_I:
		case SPELL_SUMMON_CREATURE_I_NORMAL:
		case SPELL_SUMMON_CREATURE_I_D3_0:
			return 1;
			break;
		
		case SPELL_SUMMON_CREATURE_II:
		case SPELL_SUMMON_CREATURE_II_NORMAL:
		case SPELL_SUMMON_CREATURE_II_D3_I:
		case SPELL_SUMMON_CREATURE_II_D4P1_0: 

			return 2;
			break;
		
		case SPELL_SUMMON_CREATURE_III:
		case SPELL_BG_Summon_Creature_III:
		case SPELL_SUMMON_CREATURE_III_NORMAL:
		case SPELL_SUMMON_CREATURE_III_D3_II:
		case SPELL_SUMMON_CREATURE_III_D4P1_I:
		case SPELL_SUMMON_CREATURE_III_D4P1_0: 
			return 3;
			break;
		
		case SPELL_SUMMON_CREATURE_IV:
		case SPELL_SUMMON_CREATURE_IV_NORMAL:
		case SPELL_SUMMON_CREATURE_IV_D3_III:
		case SPELL_SUMMON_CREATURE_IV_D4P1_II:
		case SPELL_SUMMON_CREATURE_IV_D4P1_I:
		case SPELL_SUMMON_CREATURE_IV_D4P1_0: 
			return 4;
			break;
		
		case SPELL_SUMMON_CREATURE_V:
		case SPELL_SUMMON_FIENDISH_LEGACY:
		case SPELL_SUMMON_CREATURE_V_NORMAL:
		case SPELL_SUMMON_CREATURE_V_D3_IV:
		case SPELL_SUMMON_CREATURE_V_D4P1_III:
		case SPELL_SUMMON_CREATURE_V_D4P1_II:
		case SPELL_SUMMON_CREATURE_V_D4P1_I:
			return 5;
			break;
		
		case SPELL_SUMMON_CREATURE_VI:
		case SPELL_SUMMON_CREATURE_VI_NORMAL:
		case SPELL_SUMMON_CREATURE_VI_D3_V:
		case SPELL_SUMMON_CREATURE_VI_D4P1_IV:
		case SPELL_SUMMON_CREATURE_VI_D4P1_III:
		case SPELL_SUMMON_CREATURE_VI_D4P1_II:
			return 6;
			break;
		
		case SPELL_SUMMON_CREATURE_VII:
		case SPELL_SUMMON_CREATURE_VII_NORMAL:
		case SPELL_SUMMON_CREATURE_VII_D3_VI:
		case SPELL_SUMMON_CREATURE_VII_D4P1_V:
		case SPELL_SUMMON_CREATURE_VII_D4P1_IV:
		case SPELL_SUMMON_CREATURE_VII_D4P1_III:
			return 7;
			break;
		
		case SPELL_SUMMON_CREATURE_VIII:
		case SPELL_SHADES_TARGET_GROUND:
		case SPELL_SUMMON_CREATURE_VIII_NORMAL:
		case SPELL_SUMMON_CREATURE_VIII_D3_VII:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_VI:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_V:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_IV:
			return 8;
			break;
			
		case SPELL_SUMMON_CREATURE_IX:
		case SPELL_SUMMON_CREATURE_IX_NORMAL:
		case SPELL_SUMMON_CREATURE_IX_D3_VIII:
		case SPELL_SUMMON_CREATURE_IX_D4P1_VII:
		case SPELL_SUMMON_CREATURE_IX_D4P1_VI:
		case SPELL_SUMMON_CREATURE_IX_D4P1_V:
			return 9;
			break;
			
		default:
			return 1;
	}
	return 1;
}


/*
Type of Feat: Spellcasting
You have been trained in a druidic tradition focusing on becoming one of nature's avengers. You consider the use of arcane magic to be a vile and unnatural act.
Prerequisite: Animal Companion or Elemental Companion
Benefit: The duration of your summon creature spells is doubled. Creatures summoned by those spells receive a +3 bonus on their attack rolls.
Use: Automatic.
Affected spells: Elemental Swarm, Greater Planar Binding, Lesser Planar Binding, Planar Binding and Summon Creature I-IX
*/
int SCSummonGetIsAshboundSpell( int iSpellId )
{
	switch ( iSpellId )
	{
		case SPELL_SUMMON_CREATURE_0:
		case SPELL_SUMMON_CREATURE_I:
		case SPELL_SUMMON_CREATURE_II:
		case SPELL_SUMMON_CREATURE_III:
		case SPELL_SUMMON_CREATURE_IV:
		case SPELL_SUMMON_CREATURE_V:
		case SPELL_SUMMON_CREATURE_VI:
		case SPELL_SUMMON_CREATURE_VII:
		case SPELL_SUMMON_CREATURE_VIII:
		case SPELL_SUMMON_CREATURE_IX:
		case SPELL_ELEMENTAL_SWARM:
		case SPELL_GREATER_PLANAR_BINDING:
		case SPELL_LESSER_PLANAR_BINDING:
		case SPELL_PLANAR_BINDING:
			return TRUE;
			break;
	}
	
	return FALSE;

}

// this just covers the basic monster summoning spells
int SCSummonGetMainSpellId( int iSpellId )
{
	switch ( iSpellId )
	{
		case SPELL_SUMMON_CREATURE_0: 
			return SPELL_SUMMON_CREATURE_0;
			break;
		
		case SPELL_SUMMON_CREATURE_I:
		case SPELL_SUMMON_CREATURE_I_NORMAL:
		case SPELL_SUMMON_CREATURE_I_D3_0:
			return SPELL_SUMMON_CREATURE_I;
			break;
		
		case SPELL_SUMMON_CREATURE_II:
		case SPELL_SUMMON_CREATURE_II_NORMAL:
		case SPELL_SUMMON_CREATURE_II_D3_I:
		case SPELL_SUMMON_CREATURE_II_D4P1_0: 
			return SPELL_SUMMON_CREATURE_II;
			break;
		
		case SPELL_SUMMON_CREATURE_III:
		case SPELL_BG_Summon_Creature_III:
		case SPELL_SUMMON_CREATURE_III_NORMAL:
		case SPELL_SUMMON_CREATURE_III_D3_II:
		case SPELL_SUMMON_CREATURE_III_D4P1_I:
		case SPELL_SUMMON_CREATURE_III_D4P1_0: 
			return SPELL_SUMMON_CREATURE_III;
			break;
		
		case SPELL_SUMMON_CREATURE_IV:
		case SPELL_SUMMON_CREATURE_IV_NORMAL:
		case SPELL_SUMMON_CREATURE_IV_D3_III:
		case SPELL_SUMMON_CREATURE_IV_D4P1_II:
		case SPELL_SUMMON_CREATURE_IV_D4P1_I:
		case SPELL_SUMMON_CREATURE_IV_D4P1_0: 
			return SPELL_SUMMON_CREATURE_IV;
			break;
		
		case SPELL_SUMMON_CREATURE_V:
		case SPELL_SUMMON_FIENDISH_LEGACY:
		case SPELL_SUMMON_CREATURE_V_NORMAL:
		case SPELL_SUMMON_CREATURE_V_D3_IV:
		case SPELL_SUMMON_CREATURE_V_D4P1_III:
		case SPELL_SUMMON_CREATURE_V_D4P1_II:
		case SPELL_SUMMON_CREATURE_V_D4P1_I:
			return SPELL_SUMMON_CREATURE_V;
			break;
		
		case SPELL_SUMMON_CREATURE_VI:
		case SPELL_SUMMON_CREATURE_VI_NORMAL:
		case SPELL_SUMMON_CREATURE_VI_D3_V:
		case SPELL_SUMMON_CREATURE_VI_D4P1_IV:
		case SPELL_SUMMON_CREATURE_VI_D4P1_III:
		case SPELL_SUMMON_CREATURE_VI_D4P1_II:
			return SPELL_SUMMON_CREATURE_VI;
			break;
		
		case SPELL_SUMMON_CREATURE_VII:
		case SPELL_SUMMON_CREATURE_VII_NORMAL:
		case SPELL_SUMMON_CREATURE_VII_D3_VI:
		case SPELL_SUMMON_CREATURE_VII_D4P1_V:
		case SPELL_SUMMON_CREATURE_VII_D4P1_IV:
		case SPELL_SUMMON_CREATURE_VII_D4P1_III:
			return SPELL_SUMMON_CREATURE_VII;
			break;
		
		case SPELL_SUMMON_CREATURE_VIII:
		case SPELL_SHADES_TARGET_GROUND:
		case SPELL_SUMMON_CREATURE_VIII_NORMAL:
		case SPELL_SUMMON_CREATURE_VIII_D3_VII:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_VI:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_V:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_IV:
			return SPELL_SUMMON_CREATURE_VIII;
			break;
		case SPELL_SUMMON_CREATURE_IX:
		case SPELL_SUMMON_CREATURE_IX_NORMAL:
		case SPELL_SUMMON_CREATURE_IX_D3_VIII:
		case SPELL_SUMMON_CREATURE_IX_D4P1_VII:
		case SPELL_SUMMON_CREATURE_IX_D4P1_VI:
		case SPELL_SUMMON_CREATURE_IX_D4P1_V:
			return SPELL_SUMMON_CREATURE_IX;
			break;
		default:
			return SPELL_SUMMON_CREATURE_I;
	}
	return SPELL_SUMMON_CREATURE_I;
}

// this just covers the basic monster summoning spells
int SCSummonGetColumn( int iSpellId )
{
	switch ( iSpellId )
	{
		case SPELL_SUMMON_CREATURE_0:
		case SPELL_SUMMON_CREATURE_I:
		case SPELL_SUMMON_CREATURE_II:
		case SPELL_SUMMON_CREATURE_III:
		case SPELL_BG_Summon_Creature_III:
		case SPELL_SUMMON_CREATURE_IV:
		case SPELL_SUMMON_CREATURE_V:
		case SPELL_SUMMON_CREATURE_VI:
		case SPELL_SUMMON_CREATURE_VII:
		case SPELL_SUMMON_CREATURE_VIII:
		case SPELL_SHADES_TARGET_GROUND:
		case SPELL_SUMMON_CREATURE_IX:
		case SPELL_SUMMON_FIENDISH_LEGACY:
			return 1;
			break;
			
		case SPELL_SUMMON_CREATURE_I_NORMAL:
		case SPELL_SUMMON_CREATURE_II_NORMAL:
		case SPELL_SUMMON_CREATURE_III_NORMAL:
		case SPELL_SUMMON_CREATURE_IV_NORMAL:
		case SPELL_SUMMON_CREATURE_V_NORMAL:
		case SPELL_SUMMON_CREATURE_VI_NORMAL:
		case SPELL_SUMMON_CREATURE_VII_NORMAL:
		case SPELL_SUMMON_CREATURE_VIII_NORMAL:
		case SPELL_SUMMON_CREATURE_IX_NORMAL:
			return 2;
			break;
		
		case SPELL_SUMMON_CREATURE_I_D3_0:
		case SPELL_SUMMON_CREATURE_II_D3_I:
		case SPELL_SUMMON_CREATURE_III_D3_II:
		case SPELL_SUMMON_CREATURE_IV_D3_III:
		case SPELL_SUMMON_CREATURE_V_D3_IV:
		case SPELL_SUMMON_CREATURE_VI_D3_V:
		case SPELL_SUMMON_CREATURE_VII_D3_VI:
		case SPELL_SUMMON_CREATURE_VIII_D3_VII:
		case SPELL_SUMMON_CREATURE_IX_D3_VIII:
			return 3;
			break;

		case SPELL_SUMMON_CREATURE_II_D4P1_0:
		case SPELL_SUMMON_CREATURE_III_D4P1_I:
		case SPELL_SUMMON_CREATURE_IV_D4P1_II:
		case SPELL_SUMMON_CREATURE_V_D4P1_III:
		case SPELL_SUMMON_CREATURE_VI_D4P1_IV:
		case SPELL_SUMMON_CREATURE_VII_D4P1_V:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_VI:
		case SPELL_SUMMON_CREATURE_IX_D4P1_VII:
			return 4;
			break;

		case SPELL_SUMMON_CREATURE_III_D4P1_0:
		case SPELL_SUMMON_CREATURE_IV_D4P1_I:
		case SPELL_SUMMON_CREATURE_V_D4P1_II:
		case SPELL_SUMMON_CREATURE_VI_D4P1_III:
		case SPELL_SUMMON_CREATURE_VII_D4P1_IV:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_V:
		case SPELL_SUMMON_CREATURE_IX_D4P1_VI:
			return 5;
			break;

		case SPELL_SUMMON_CREATURE_IV_D4P1_0:
		case SPELL_SUMMON_CREATURE_V_D4P1_I:
		case SPELL_SUMMON_CREATURE_VI_D4P1_II:
		case SPELL_SUMMON_CREATURE_VII_D4P1_III:
		case SPELL_SUMMON_CREATURE_VIII_D4P1_IV:
		case SPELL_SUMMON_CREATURE_IX_D4P1_V:
			return 6;
			break;
		

		default:
			return 1;
	}
	return 1;

}

object SCSummonsGetDataObject( object oThingInTargetArea = OBJECT_SELF )
{
	object oSD = GetLocalObject( GetModule(), "SUMMONS_DATAOBJECT" );
	if( !GetIsObjectValid(oSD) )
	{
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		//if (DEBUGGING >= 8) { CSLDebug("CSLEnviroGetControl creating heartbeat object", GetFirstPC() ); }
		//SendMessageToPC( GetFirstPC(), "Environment Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		oSD = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation( oThingInTargetArea ), FALSE, "plc_summonsdata"); 
		
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oSD, TRUE);
		// SetEventHandler(oSD, SCRIPT_PLACEABLE_ON_HEARTBEAT, CSL_SUMMONS_HEARTBEAT_SCRIPT); re-enable this later
		SetLocalObject(GetModule(), "SUMMONS_DATAOBJECT", oSD);
		
		SetFirstName(oSD, "Summons");
		SetLastName(oSD, "Dataobject");
	}
	return oSD;
}



	
// * this boosts the level of the spell the caster is casting a summon as
int SCGetSummonBonus( object oCaster = OBJECT_SELF, string sSummonTable = "" )
{ 
	// int iCurrentSchool = GetLocalInt( oCaster, "HKTEMP_School" );
	
	int iBonus = 0;
	
	// need to determine if this truly is animal or not, assume this applies whenever "Nature" table
	if ( sSummonTable == "Nature" && GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oCaster)) // WITH THE ANIMAL DOMAIN
	{
		iBonus++; // SCSummonGetTable
	} 
	
	// bonus from conjuration focus usually, but illusion and necro can boost shades and undead
	iBonus += CSLGetMin( HkGetSpellDCBonus( oCaster ), CSLGetPreferenceInteger("SummonConjurationFocusMaxBonus", 0 ));
	
	
	if ( GetHasFeat(FEAT_AUGMENT_SUMMONING, oCaster) )
	{
		if ( GetLocalInt( oCaster, "HKTEMP_SubSchool" ) == SPELL_SUBSCHOOL_SUMMONING )
		{
			iBonus += CSLGetMin( 2, CSLGetPreferenceInteger("SummonAugmentMaxBonus", 2 ));
		}
	}// WITH THE SUMMON AUGMENTATION FEAT
	if ( GetHasFeat( FEAT_RED_WIZARD_SPELLCASTING_WIZARD, oCaster ) ) // it's a red wizard, check for bonuses
	{
		iBonus +=  CSLGetMin( HkGetRedWizardBonus( oCaster )/2, CSLGetPreferenceInteger("SummonRedWizardMaxBonus", 0 ));
		
		; // max of 2, which is half of 5, it's assumed he already gets spell focus at 1, so with all focus it ends up being 5
	}
	//if (nLvl<9 && iBonus) FloatingTextStringOnCreature("Summon boosted to level " + IntToString(CSLGetMin(9, nLvl+iBonus)), OBJECT_SELF, FALSE);
	return iBonus;
}


// use the descriptor to determine the following
// SUMMON = 1; // Creature is maintained as a an effect of the spell, and as such can be dispelled or dismissed at will.
// CALLING = 2; // Creature is only removed at end of spells duration, but is not dispellable
// SHADOW = 3; // Creature is an illusion

string SCSummonMethodToString( int iMethod )
{
	if ( iMethod == CSL_SUMMONMETHOD_NONE ) { return "None";}
	if ( iMethod == CSL_SUMMONMETHOD_SINGLE ) { return "Single";}
	if ( iMethod == CSL_SUMMONMETHOD_RADIAL ) { return "Radial";}
	if ( iMethod == CSL_SUMMONMETHOD_RANDOM ) { return "Random";}
	if ( iMethod == CSL_SUMMONMETHOD_CHAIN ) { return "Chain";}
	if ( iMethod == CSL_SUMMONMETHOD_LEVELED ) { return "Leveled";}
	return "Single"; // this is the default when there is an error
}

int SCSummonMethodToInt( string sMethod )
{
	sMethod = GetStringLowerCase( sMethod );
	if ( sMethod == "none" ) { return CSL_SUMMONMETHOD_NONE;}
	if ( sMethod == "single" ) { return CSL_SUMMONMETHOD_SINGLE;}
	if ( sMethod == "radial") { return CSL_SUMMONMETHOD_RADIAL;}
	if ( sMethod == "random" ) { return CSL_SUMMONMETHOD_RANDOM;}
	if ( sMethod == "chain") { return CSL_SUMMONMETHOD_CHAIN;}
	if ( sMethod == "leveled" ) { return CSL_SUMMONMETHOD_LEVELED;}
	return CSL_SUMMONMETHOD_SINGLE; // this is the default when there is an error

}

string SCSummonControlTypeToString( int iMethod )
{
	if ( iMethod == CSL_SUMMONCONTROL_FREEAGENT ) { return "Free";}
	if ( iMethod == CSL_SUMMONCONTROL_SERVANT ) { return "Servant";}
	if ( iMethod == CSL_SUMMONCONTROL_SLAVE ) { return "Slave";}
	if ( iMethod == CSL_SUMMONCONTROL_PROTECTED_SERVITUDE ) { return "Protected";}
	if ( iMethod == CSL_SUMMONCONTROL_TIMED_SERVITUDE ) { return "Timed";}
	if ( iMethod == CSL_SUMMONCONTROL_WILLED_SERVITUDE ) { return "Willed";}
	if ( iMethod == CSL_SUMMONCONTROL_CONCENTRATE_SERVITUDE ) { return "Concentrate";}
	if ( iMethod == CSL_SUMMONCONTROL_PAID_SERVITUDE ) { return "Paid";}
	if ( iMethod == CSL_SUMMONCONTROL_EFFECTSUMMON ) { return "effectsummon";}
	if ( iMethod == CSL_SUMMONCONTROL_EFFECTSWARM ) { return "effectswarm";}
	return "Slave"; // this is the default when there is an error
}


int SCSummonControlTypeToInt( string sMethod )
{
	sMethod = GetStringLowerCase( sMethod );
	if ( sMethod == "free" ) { return CSL_SUMMONCONTROL_FREEAGENT;}
	if ( sMethod == "servant" ) { return CSL_SUMMONCONTROL_SERVANT;}
	if ( sMethod == "slave") { return CSL_SUMMONCONTROL_SLAVE;}
	if ( sMethod == "protected" ) { return CSL_SUMMONCONTROL_PROTECTED_SERVITUDE;}
	if ( sMethod == "timed") { return CSL_SUMMONCONTROL_TIMED_SERVITUDE;}
	if ( sMethod == "willed" ) { return CSL_SUMMONCONTROL_WILLED_SERVITUDE;}
	if ( sMethod == "concentrate" ) { return CSL_SUMMONCONTROL_CONCENTRATE_SERVITUDE;}
	if ( sMethod == "paid" ) { return CSL_SUMMONCONTROL_PAID_SERVITUDE;}
	if ( sMethod == "effectsummon" ) { return CSL_SUMMONCONTROL_EFFECTSUMMON;}
	if ( sMethod == "effectswarm" ) { return CSL_SUMMONCONTROL_EFFECTSWARM;}
	return CSL_SUMMONCONTROL_SLAVE; // this is the default when there is an error
}




// Get the g control object (invisible placeable)(ipoint).
// Create one if missing. Battle control monitors the battlefield 
// and performs all neccessary administration using heartbeat script.
// Originally planned to use Area heartbeat to act as Battle control
// but SetEventHandler does not work on area
/*
object SCSummonsGetControl( object oThingInTargetArea = OBJECT_SELF )
{
	object oModule = GetModule();
	object oSC = GetLocalObject( oModule, "SUMMONS_CONTROL" );
	if( !GetIsObjectValid(oSC) )
	{
		//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
		//if (DEBUGGING >= 8) { CSLDebug("CSLEnviroGetControl creating heartbeat object", GetFirstPC() ); }
		//SendMessageToPC( GetFirstPC(), "Environment Control Created in "+GetName( oAR ) );
		// Battle control not exist, Create one
		oSC = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_ipoint ", GetLocation( oThingInTargetArea ), FALSE, "plc_summonscontrol"); 
		
		//CSLCreatePlacable("plc_ipoint ", oThingInTargetArea, "plc_environmentcontrol");
		// Register New Battle Control
		SetPlotFlag(oSC, TRUE);
		// SetEventHandler(oSC, SCRIPT_PLACEABLE_ON_HEARTBEAT, CSL_SUMMONS_HEARTBEAT_SCRIPT); re-enable this later
		SetLocalObject(oModule, "SUMMONS_CONTROL", oSC);
		
		SetFirstName(oSC, "Summons");
		SetLastName(oSC, "");
	}
	return oSC;
}
*/





// Enviro Control Heart Beat
/*
void SCSummonsControlHB()
{
	object oSC = SCSummonsGetControl();
	object oModule = GetModule();
	int iCurrentRound = GetLocalInt( oModule, "CSL_CURRENT_ROUND" ); // just to have available, actually maintained in the environment system

	int count = GetVariableCount( oSC );
	
	//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLEnviroControlHB working on "+IntToString(count)+" objects" ); }
	int x;
	object oCurrent;
	string sCurrent;
	int iEnviroStatus = 0;
	int iCharStatus = 0;

	for (x = count-1; x >= 0; x--) 
	{
		sCurrent = GetVariableName(oSC, x);
		oCurrent = GetVariableValueObject(oSC, x );
		
		
		//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "iterating on "+sCurrent+" for objects #"+IntToString(count)+" "+GetName( oCurrent ) ); }
		if ( GetIsObjectValid( oCurrent ) )
		{
			if ( GetIsObjectValid(GetArea(oCurrent)) && !GetLocalInt(oCurrent, "TRANSITION") ) // make sure they are not in process of a transition - just wait until they are done
			{
				iEnviroStatus = GetLocalInt( oCurrent, "CSL_ENVIRO" );
				iCharStatus = GetLocalInt( oCurrent, "CSL_CHARSTATE" );
				if ( iEnviroStatus == CSL_ENVIRO_NONE && iCharStatus == CSL_CHARSTATE_NONE )
				{
					//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "Removing "+sCurrent ); }
					DeleteLocalObject( oSC, sCurrent ); // no status, we can stop tracking
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
					CSLEnviroObjectHeartbeat( oCurrent, oSC );
				}
			}
		}
		else
		{
			DeleteLocalObject( oSC, sCurrent );
		}
	}
	
	//int iWeatherTicks = 15;
	//int iLightningTicks = 3;
	//if ( !( iCurrentRound % iWeatherTicks ) )
	//{
	CSLEnviroWeatherBeat(); // changes weather
	if ( !( iCurrentRound % 2 ) )
	{
		CSLEnviroWeatherPeriodicEffects(); // causes periodic effects
	}	
	
	CSLTorchHeartBeat();
		//if (DEBUGGING >= 8) { SendMessageToPC( GetFirstPC(), "CSLEnviroControlHB setting weather iCurrentRound="+IntToString(iCurrentRound)+" % iWeatherTicks="+IntToString(iWeatherTicks) ); }
	//}
	
	

}
*/


// this is used to maintain totals of summons and the like
int SCSummonRemoveIfMoreThanHitDice(object oPC, int iMaxHitDice )
{
	int nCnt = 0;
	if (GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC)==OBJECT_INVALID) 
	{
		return 0;
	}
	
	object oArea = GetArea(oPC);
	object oSummon = GetFirstObjectInArea(oArea);
	while (GetIsObjectValid(oSummon))
	{
		if (GetObjectType(oSummon)==OBJECT_TYPE_CREATURE)
		{
			
			if ( GetLocalObject(oSummon, "MASTER" ) ==  oPC )
			{   //if (GetMaster(oSummon)==oPC && CSLGetIsUndead( oSummon ) ) {
				nCnt += GetHitDice(oSummon);
				if ( nCnt > iMaxHitDice )
				{
					SCSummonRemove( oSummon );
				}
			}
		}
		oSummon = GetNextObjectInArea(oArea);
	}
	return nCnt;
}



// this is used to maintain totals of summons and the like
int SCSummonCountHitDice(object oPC)
{
	int nCnt = 0;
	if (GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC)==OBJECT_INVALID) 
	{
		return 0;
	}
	
	object oArea = GetArea(oPC);
	object oSummon = GetFirstObjectInArea(oArea);
	while (GetIsObjectValid(oSummon))
	{
		if (GetObjectType(oSummon)==OBJECT_TYPE_CREATURE)
		{
			
			if ( GetLocalObject(oSummon, "MASTER" ) ==  oPC )
			{   //if (GetMaster(oSummon)==oPC && CSLGetIsUndead( oSummon ) ) {
				nCnt += GetHitDice(oSummon);
			}
		}
		oSummon = GetNextObjectInArea(oArea);
	}
	return nCnt;
}

// this is used to maintain totals of summons and the like
int SCSummonCount(object oPC)
{
	int nCnt = 0;
	if (GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC)==OBJECT_INVALID) 
	{
		return 0;
	}
	
	object oArea = GetArea(oPC);
	object oSummon = GetFirstObjectInArea(oArea);
	while (GetIsObjectValid(oSummon))
	{
		if (GetObjectType(oSummon)==OBJECT_TYPE_CREATURE)
		{
			
			if ( GetLocalObject(oSummon, "MASTER" ) ==  oPC )
			{   //if (GetMaster(oSummon)==oPC && CSLGetIsUndead( oSummon ) ) {
				nCnt++;
			}
		}
		oSummon = GetNextObjectInArea(oArea);
	}
	return nCnt;
}


// this is used to maintain totals of summons and the like
void SCSummonsExecuteScript(object oPC, string sScriptName = "_mod_onunsummoncreature" )
{
	int nCnt = 0;
	if (GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC)==OBJECT_INVALID ) 
	{
		return;
	}
	
	object oArea = GetArea(oPC);
	object oSummon = GetFirstObjectInArea(oArea);
	while ( GetIsObjectValid( oSummon ) )
	{
		if (GetObjectType(oSummon)==OBJECT_TYPE_CREATURE)
		{
			
			if ( GetLocalObject(oSummon, "MASTER" ) ==  oPC )
			{   //if (GetMaster(oSummon)==oPC && CSLGetIsUndead( oSummon ) ) {
				DelayCommand(0.5f, ExecuteScript( sScriptName, oSummon ) );
			}
		}
		oSummon = GetNextObjectInArea(oArea);
	}
}

void SCSummonLoadTable( string sSummoningTable, int bForceReload = FALSE )
{
	//"summon_magic-underwater.2da"; 27 letters
	//"summon_magic-1234567890123.2da"; 5 digit main name, 13 for subcategories 
	string sSummoningTableFile = "summon_"+sSummoningTable;
	if ( bForceReload )
	{
		Clear2DACache( sSummoningTableFile );
	}
	
	///SendMessageToPC( GetFirstPC(), "Working with file "+sSummoningTableFile  );
	
	object oSD = SCSummonsGetDataObject();
	string sTableName = GetStringUpperCase( sSummoningTable ); // ."-LEVEL_";
	string sSummonLevel;
	
	
	int iNumberRows = GetNum2DARows( sSummoningTableFile );
	if ( iNumberRows == -1 )
	{
		// mark the table as not available so no further needless attempts are made
		SetLocalInt(oSD, sTableName, -1);
		return;
	}
	SetLocalInt(oSD, sTableName, iNumberRows );
	
	int iSummonMethod;
	int iSummonControl;
	string sSummonScript;
	string sSummonResref1;
	string sSummonResref2;
	string sSummonResref3;
	string sSummonResref4;
	string sSummonResref5;
	string sSummonResref6;
	
	string sOnSummonScript;
	string sOnUnSummonScript;
	string sOnSummonEffect;
	string sOnUnSummonEffect;
	int iLeveledStart;
	int iLeveledSteps;
	string sProtection;
	string sFormation;
	string sSummonLevelLabel;
	string sDurationEffect;
	
	int iCurrentRow;
	for (iCurrentRow = 0; iCurrentRow < iNumberRows; iCurrentRow++) 
	{
		sSummonLevelLabel = sTableName+"-LEVEL_"+IntToString(iCurrentRow);
		iSummonMethod = SCSummonMethodToInt( Get2DAString(sSummoningTableFile, "Method", iCurrentRow) );		
		iSummonControl = SCSummonControlTypeToInt( Get2DAString(sSummoningTableFile, "Control", iCurrentRow) );		
		
		sOnSummonScript = Get2DAString(sSummoningTableFile, "OnSummonScript", iCurrentRow);
		sOnUnSummonScript = Get2DAString(sSummoningTableFile, "OnUnSummonScript", iCurrentRow);
		sOnSummonEffect = Get2DAString(sSummoningTableFile, "OnSummonEffect", iCurrentRow);
		sOnUnSummonEffect = Get2DAString(sSummoningTableFile, "OnUnSummonEffect", iCurrentRow);
		sDurationEffect = Get2DAString(sSummoningTableFile, "DurationEffect", iCurrentRow);
		
		SetLocalInt(oSD, sSummonLevelLabel+"-METHOD", iSummonMethod );
		SetLocalInt(oSD, sSummonLevelLabel+"-CONTROL", iSummonControl );
		
		if ( sOnSummonScript != "" )
		{
			SetLocalString(oSD, sSummonLevelLabel+"-SUMMONSCRIPT", sOnSummonScript );
		}
		
		if ( sOnUnSummonScript != "" )
		{
			SetLocalString(oSD, sSummonLevelLabel+"-UNSUMMONSCRIPT", sOnUnSummonScript );
		}
		
		if ( sOnSummonEffect != "" )
		{
			SetLocalString(oSD, sSummonLevelLabel+"-SUMMONEFFECT", sOnSummonEffect );
		}
		
		if ( sOnUnSummonEffect != "" )
		{
			SetLocalString(oSD, sSummonLevelLabel+"-UNSUMMONEFFECT", sOnUnSummonEffect );
		}
		
		if ( sDurationEffect != "" )
		{
			SetLocalString(oSD, sSummonLevelLabel+"-DURATIONEFFECT", sDurationEffect );
		}
		
		if ( iSummonMethod == CSL_SUMMONMETHOD_LEVELED )
		{
			iLeveledStart = StringToInt( Get2DAString(sSummoningTableFile, "LeveledStart", iCurrentRow) ); 
			iLeveledSteps = StringToInt( Get2DAString(sSummoningTableFile, "LeveledSteps", iCurrentRow) );
			if ( iLeveledStart < 1 ) { iLeveledStart = 1; }
			if ( iLeveledSteps < 1 ) { iLeveledSteps = 5; }
			
			SetLocalInt(oSD, sSummonLevelLabel+"-LEVELEDSTART", CSLGetMin(iLeveledStart,30) );
			SetLocalInt(oSD, sSummonLevelLabel+"-LEVELEDSTEPS", CSLGetMin(iLeveledSteps,30) );
		}
	
		if ( iSummonControl == CSL_SUMMONCONTROL_PROTECTED_SERVITUDE )
		{
			sProtection = Get2DAString(sSummoningTableFile, "Protection", iCurrentRow);
			if ( sProtection != "" )
			{
				SetLocalString(oSD, sSummonLevelLabel+"-PROTECTION", sProtection );
			}
		}
		sFormation = Get2DAString(sSummoningTableFile, "Formation", iCurrentRow);
		if ( sFormation != "" )
		{
			SetLocalString(oSD, sSummonLevelLabel+"-FORMATION", sFormation );
		}
		
		
		
		// only gets next resref if the first is filled out, might cause some confusion but all the values should be filled out in some manner.
		sSummonResref1 = Get2DAString(sSummoningTableFile, "ResRef_1", iCurrentRow);
		if ( sSummonResref1 != "" )
		{
			SetLocalString(oSD, sSummonLevelLabel+"-RESREF1", sSummonResref1);
			
			sSummonResref2 = Get2DAString(sSummoningTableFile, "ResRef_2", iCurrentRow);
			if ( sSummonResref2 != "" )
			{
				SetLocalString(oSD, sSummonLevelLabel+"-RESREF2", sSummonResref2);
			
				sSummonResref3 = Get2DAString(sSummoningTableFile, "ResRef_3", iCurrentRow);
				if ( sSummonResref3 != "" )
				{
					SetLocalString(oSD, sSummonLevelLabel+"-RESREF3", sSummonResref3);
				
					sSummonResref4 = Get2DAString(sSummoningTableFile, "ResRef_4", iCurrentRow);
					if ( sSummonResref4 != "" )
					{
						SetLocalString(oSD, sSummonLevelLabel+"-RESREF4", sSummonResref4);
					
						sSummonResref5 = Get2DAString(sSummoningTableFile, "ResRef_5", iCurrentRow);
						if ( sSummonResref5 != "" )
						{
							SetLocalString(oSD, sSummonLevelLabel+"-RESREF5", sSummonResref5);
							
							sSummonResref6 = Get2DAString(sSummoningTableFile, "ResRef_6", iCurrentRow);
							if ( sSummonResref6 != "" )
							{
								SetLocalString(oSD, sSummonLevelLabel+"-RESREF6", sSummonResref6);
							}
						}
					}
				}
			}
		}
	}
}




int SCSummonGetMethod( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalInt(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-METHOD" );
}


int SCSummonGetControlType( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalInt(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-CONTROL" );
}

string SCSummonGetSummonScript( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalString(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-SUMMONSCRIPT" );
}

string SCSummonGetUnSummonScript( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalString(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-UNSUMMONSCRIPT" );
}

string SCSummonGetSummonEffect( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalString(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-SUMMONEFFECT" );
}

string SCSummonGetUnSummonEffect( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalString(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-UNSUMMONEFFECT" );
}

string SCSummonGetDurationEffect( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalString(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-DURATIONEFFECT" );
}


string SCSummonGetProtection( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalString(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-PROTECTION" );
}

string SCSummonGetFormation( object oSD, string sSummoningTable, int iSummonLevel )
{
	return GetLocalString(oSD, GetStringUpperCase(sSummoningTable)+"-LEVEL_"+IntToString(iSummonLevel)+"-FORMATION" );
}



/*
const int CSL_SUMMONMETHOD_SINGLE = 1; // Simply summons the given creature
const int CSL_SUMMONMETHOD_RADIAL = 3; // Each radial spell correlates to a different column, this allows using a lower level version for example, 1st column is used with master spell, other 5 are used with subradials
const int CSL_SUMMONMETHOD_RANDOM = 4; // Each column present has an equal chance of being used ( the **** doesn't count )
const int CSL_SUMMONMETHOD_CHAIN = 5; // Each column present is used as a chain summon, once all the first set of summons are killed, the second set appears
const int CSL_SUMMONMETHOD_LEVELED = 6; // 6 columns correlate to the caster levels, allowing the creature to improve as you increase in level, generally improving every 5 levels, 0-5, 6-10, 11-15, 16-20, 21-25, 26-30
*/

string SCSummonGetResref( object oSD, string sSummoningTable, int iSummonMethod, int iSpellPower, int iSummonLevel, int iMainSpellId = -1, int iSummonColumn = -1 )
{
	//SendMessageToPC( GetFirstPC(), "sSummoningTable="+sSummoningTable+" iSummonMethod="+IntToString(iSummonMethod)+" iSpellPower="+IntToString(iSpellPower)+" iSummonLevel="+IntToString(iSummonLevel)+" iSummonColumn="+IntToString(iSummonColumn) );
	
	
	string sSummonResref = "";
	
	string sSummonResref1;
	string sSummonResref2;
	string sSummonResref3;
	string sSummonResref4;
	string sSummonResref5;
	string sSummonResref6;
	
	string sTableName = GetStringUpperCase( sSummoningTable ); 
	
	if ( iSummonMethod == CSL_SUMMONMETHOD_SINGLE )
	{
		sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF1" );
	}
	else if ( iSummonMethod == CSL_SUMMONMETHOD_RADIAL )
	{
		int iCurrentSpellId = GetSpellId();
		
		if ( sSummonResref == "" && iSummonColumn >= 6 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF6" );
			//SendMessageToPC( GetFirstPC(), sSummonResref +" found at "+ sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF6" );
		}
		if ( sSummonResref == "" && iSummonColumn >= 5 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF5" );
			//SendMessageToPC( GetFirstPC(), sSummonResref +" found at "+ sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF5" );
		}
		if ( sSummonResref == "" && iSummonColumn >= 4 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF4" );
			//SendMessageToPC( GetFirstPC(), sSummonResref +" found at "+ sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF4" );
		}
		if ( sSummonResref == "" && iSummonColumn >= 3 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF3" );
			//SendMessageToPC( GetFirstPC(), sSummonResref +" found at "+ sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF3" );
		}	
		if ( sSummonResref == "" && iSummonColumn >= 2 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF2" );
			//SendMessageToPC( GetFirstPC(), sSummonResref +" found at "+ sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF2" );
		}
		
		
		if ( sSummonResref == "" )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF1" );
			//SendMessageToPC( GetFirstPC(), sSummonResref +" defaulted at "+ sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF1" );
		}
		
		
	}
	else if ( iSummonMethod == CSL_SUMMONMETHOD_RANDOM )
	{
		sSummonResref1 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF1" );
		sSummonResref2 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF2" );
		sSummonResref3 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF3" );
		sSummonResref4 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF4" );
		sSummonResref5 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF5" );
		sSummonResref6 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF6" );
		
		sSummonResref = CSLPickOne( sSummonResref1, sSummonResref2, sSummonResref3, sSummonResref4, sSummonResref5, sSummonResref6 );
		
	}
	else if ( iSummonMethod == CSL_SUMMONMETHOD_CHAIN )
	{
		// no idea how i am going to make this work as of yet ... kind of illogical since the handler really can't be inside this function ... very rare usage though only affecting a few spells.
		sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF1" );
		/*
		sSummonResref2 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF2" );
		sSummonResref3 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF3" );
		sSummonResref4 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF4" );
		sSummonResref5 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF5" );
		sSummonResref6 = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF6" );
		*/
	
	}
	else if ( iSummonMethod == CSL_SUMMONMETHOD_LEVELED )
	{			
		int iLeveledStart = GetLocalInt(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-LEVELEDSTART" );
		int iLeveledSteps = GetLocalInt(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-LEVELEDSTEPS" );
		
		if ( sSummonResref == "" && iSpellPower > iLeveledStart+iLeveledSteps*5 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF6" );
		}
		
		if ( sSummonResref == "" && iSpellPower > iLeveledStart+iLeveledSteps*4 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF5" );
		}
		
		if ( sSummonResref == "" && iSpellPower > iLeveledStart+iLeveledSteps*3 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF4" );
		}
		
		if ( sSummonResref == "" && iSpellPower > iLeveledStart+iLeveledSteps*2 )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF3" );
		}
		
		if ( sSummonResref == "" && iSpellPower > iLeveledStart+iLeveledSteps )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF2" );
		}
		
		if ( sSummonResref == "" && iSpellPower > iLeveledStart )
		{
			sSummonResref = GetLocalString(oSD, sTableName+"-LEVEL_"+IntToString(iSummonLevel)+"-RESREF1" );
		}
	
	}
	
	// fix anything which has a dynamic resref, one per level of caster
	sSummonResref = CSLReplaceSubString(sSummonResref, "?", IntToString( iSpellPower ) );
	
	// returns a single column value
	return sSummonResref; // "c_rat?:2d4";
}



int SCCheckSummonTable( string sSummoningTable )
{
	string sTableName = GetStringUpperCase( sSummoningTable );
	object oSD = SCSummonsGetDataObject();
	int iNumberRows = GetLocalInt(oSD, sTableName );
	if ( iNumberRows == 0 )
	{
		//SendMessageToPC( GetFirstPC(), "Reloading "+sSummoningTable  );
		SCSummonLoadTable( sSummoningTable );
		iNumberRows = GetLocalInt(oSD, sTableName );
	}
	//SendMessageToPC( GetFirstPC(), CSLPrintVariables( oSD ) );
	
	
	return iNumberRows;
}

// this just covers the basic monster summoning spells
string SCSummonGetTable( string sMainTable, int iSpellId, location lTarget, int iClass = 255, object oCaster = OBJECT_SELF )
{
	/// First base this on the area of the summon
	string sTable = GetLocalString( GetArea(oCaster), "CSL_SUMMONTABLE" );
	if ( sTable != "" )
	{
		if ( SCCheckSummonTable( sTable ) )
		{
			return sTable;
		}
	}
	
	/// Second base this on the state at the target location, ie if it's a wall of fire spell it's fire state and you might summon fire imps, same with wall of cold, etc.
	/// Note that target state will be ignored if environment system and triggers are not being used
	// int iTargetState = GetLocalInt( oCaster, "HKTEMP_TargetState" );
	
	int iTargetState = CSLEnviroLocationGetStatus( lTarget );//
	if (DEBUGGING >= 1) { CSLDebug( "Location Status is "+IntToString( iTargetState ), oCaster, OBJECT_INVALID, "LightSlateGray" ); }
	if ( iTargetState != 0 )
	{
		
		if ( iTargetState & CSL_ENVIRO_WATER )
		{
			if ( SCCheckSummonTable( "Water" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_WATER);
				return "Water";
			}
		}
		
		if ( iTargetState & CSL_ENVIRO_FIRE )
		{
			if ( SCCheckSummonTable( "Fire" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_FIRE);
				return "Fire";
			}
		}
		
		if ( iTargetState & CSL_ENVIRO_COLD )
		{
			//sTable = "Cold";
			if ( SCCheckSummonTable( "Cold" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_COLD);
				return "Cold";
			}
		}
		
		if ( iTargetState & CSL_ENVIRO_STORM )
		{
			//sTable = "Air";
			if ( SCCheckSummonTable( "Air" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_AIR);
				return "Air";
			}
		}
		
		if ( iTargetState & CSL_ENVIRO_NEGATIVE )
		{
			//sTable = "Death";
			if ( SCCheckSummonTable( "Death" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_NEGATIVE);
				return "Death";
			}
		}
		
		if ( iTargetState & CSL_ENVIRO_HOLY )
		{
			//sTable = "Good";
			if ( SCCheckSummonTable( "Good" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_GOOD);
				return "Good";
			}
		}
		
		if ( iTargetState & CSL_ENVIRO_PROFANE )
		{
			//sTable = "Evil";
			if ( SCCheckSummonTable( "Evil" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EVIL);
				return "Evil";
			}
		}
		
		if ( iTargetState & CSL_ENVIRO_LAW )
		{
			//sTable = "Law";
			if ( SCCheckSummonTable( "Law" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_LAW);
				return "Law";
			}
		}
		if ( iTargetState & CSL_ENVIRO_CHAOS )
		{
			//sTable = "Chaos";
			if ( SCCheckSummonTable( "Chaos" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_CHAOS);
				return "Chaos";
			}
		}
	}
	
	/// Base this on the character, this should be set up in the modules on load event
	sTable = GetLocalString( GetArea(oCaster), "CSL_SUMMONTABLE_"+IntToString(iClass) );
	if ( sTable != "" )
	{
		if ( SCCheckSummonTable( sTable ) )
		{
			return sTable;
		}
	}
	
	if ( iClass == CLASS_TYPE_DRUID || iClass == CLASS_TYPE_SPIRIT_SHAMAN || iClass == CLASS_TYPE_CLERIC && GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oCaster ) )
	{
		if ( SCCheckSummonTable( "Nature" ) )
		{
			return "Nature";
		}
	}
	
	if ( iClass == CLASS_TYPE_CLERIC || iClass == CLASS_TYPE_FAVORED_SOUL )
	{
		sTable = CSLGetLegalCharacterString( GetStringLowerCase(GetDeity( oCaster )), "abcdefghijklmnopqrstuvwxyz");
		if ( SCCheckSummonTable( sTable ) )
		{
			return sTable;
		}
		
	}
	
	// based on alignment
	if ( iClass == CLASS_TYPE_CLERIC || iClass == CLASS_TYPE_PALADIN || iClass == CLASS_TYPE_BLACKGUARD )
	{
		// based on the deity really, use players alignment for now though, lean towards good and evil, with chaos and law as options
		// not sure on neutrals
		if ( GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL )
		{
			if ( SCCheckSummonTable( "Evil" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EVIL);
				return "Evil";
			}
		}
		else if ( GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD )
		{
			if ( SCCheckSummonTable( "Good" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_GOOD);
				return "Good";
			}
		}
		else if ( GetAlignmentLawChaos(oCaster) == ALIGNMENT_CHAOTIC )
		{
			if ( SCCheckSummonTable( "Chaos" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_CHAOS);
				return "Chaos";
			}
		}
		else if ( GetAlignmentLawChaos(oCaster) == ALIGNMENT_LAWFUL )
		{
			if ( SCCheckSummonTable( "Law" ) )
			{
				CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_LAW);
				return "Law";
			}
		}
	}
	
	if ( GetHasFeat( FEAT_FIENDISH_POWER,  oCaster) )
	{
		if ( SCCheckSummonTable( "Evil" ) )
		{
			CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EVIL);
			return sTable;
		}
	}
	else if ( GetHasFeat( FEAT_FEY_POWER,  oCaster) )
	{
		if ( SCCheckSummonTable( "Chaos" ) )
		{
			CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_CHAOS);
			return sTable;
		}
	}
	
	return sMainTable;
	
}

// makes a creature a normal hostile opponent, will tend to focus on the caster
void SCSummonFree( object oSummon )
{
	// makes a given creature no longer existing
	//location lLocation = GetLocation(OBJECT_SELF);
	//string sNewTag = sTag + IntToString(Random(100)); // Just in case!
	
	object oCaster = GetLocalObject(oSummon, "MASTER" );
	
	string sDisp = GetName(oSummon)+ " " + GetStringByStrRef(233589);
	FloatingTextStringOnCreature(sDisp, oCaster); // turns on the party.
	//object oBadDevil = CreateObject(OBJECT_TYPE_CREATURE, sTag, lLocation, TRUE, sNewTag);	
	//effect eDam = EffectDamage(nDamage);
	//ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oBadDevil);
	
	if ( GetIsObjectValid(oCaster ) )
	{
		CSLAttackTarget(oSummon, oCaster, TRUE);
	}

}

int SCSummonIsCasterProtected( object oCaster, string sSummoningTable = "", object oSummon = OBJECT_INVALID )
{
	int bChecked = FALSE;
	
	
	// get the table we are using
	if ( sSummoningTable == "" && GetIsObjectValid( oSummon ) )
	{
		sSummoningTable = GetLocalString(oSummon, "CSLSUMMON_SUMMONTABLE" );
	}
	
	
	if( sSummoningTable == "Evil" || GetAlignmentGoodEvil(oSummon) == ALIGNMENT_EVIL || sSummoningTable == "Death" || CSLGetIsUndead(oSummon)  )
	{
		if ( GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL) || GetHasSpellEffect(SPELL_HOLY_AURA) || GetHasSpellEffect(SPELL_CONSECRATED_AURA) )
		{
			return TRUE;
		}
		// note evil creatures will attack evil casters and enjoy it, so caster alignment does not come into play
		bChecked = TRUE;
	}
	else if( ( sSummoningTable == "Good" || GetAlignmentGoodEvil(oSummon) == ALIGNMENT_GOOD ) )
	{
		if ( GetHasSpellEffect(SPELL_PROTECTION_FROM_GOOD) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_GOOD) || GetHasSpellEffect(SPELL_UNHOLY_AURA) )
		{
			return TRUE;
		}
		
		if ( GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD )
		{
			return TRUE; // give caster a free pass, since he is on the side of good
		}
		bChecked = TRUE;
	
	}
	
	if( ( sSummoningTable == "Law" || GetAlignmentGoodEvil(oSummon) == ALIGNMENT_LAWFUL ) )
	{
		if ( GetHasSpellEffect(SPELL_PROTECTION_FROM_LAW) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_LAW) )
		{
			return TRUE;
		}
		
		if ( GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD )
		{
			return TRUE; // give caster a free pass, since he is on the side of good
		}
		bChecked = TRUE;
	
	}
	else if( ( sSummoningTable == "Chaos" || GetAlignmentGoodEvil(oSummon) == ALIGNMENT_CHAOTIC ) )
	{
		if ( GetHasSpellEffect(SPELL_PROTECTION_FROM_CHAOS) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_CHAOS) || GetHasSpellEffect(SPELL_SHIELD_OF_LAW) )
		{
			return TRUE;
		}
		bChecked = TRUE;
	}
	
	
	if( sSummoningTable == "Fire" || CSLGetIsFireBased( oSummon ) )
	{
		if ( GetHasSpellEffect(SPELLABILITY_AURA_COLD) )
		{
			return TRUE;
		}
		// note evil creatures will attack evil casters and enjoy it, so caster alignment does not come into play
		bChecked = TRUE;
	}
	
	if( sSummoningTable == "Cold" || CSLGetIsColdBased(oSummon) )
	{
		if ( GetHasSpellEffect(SPELLABILITY_AURA_FIRE) || GetHasSpellEffect(SPELL_FIRE_AURA) || GetHasSpellEffect(SPELLABILITY_BLAZING_AURA) )
		{
			return TRUE;
		}
		// note evil creatures will attack evil casters and enjoy it, so caster alignment does not come into play
		bChecked = TRUE;
	}
	
	
	if ( bChecked != TRUE ) // none apply, use protection from evil as a fail over
	{
		if ( GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL) || GetHasSpellEffect(SPELL_HOLY_AURA)  )
		{
			return TRUE;
		}
	
	}
	
	return FALSE;
}


// provides round to round control of a summon to implement special behaviors, put this in whatever heart beat is applied to the summon
void SCSummonHeartbeatControl( object oSummon )
{
	int iSummonControlType = GetLocalInt(oSummon, "CSLSUMMON_CONTROLTYPE" );
	object oCaster = GetLocalObject(oSummon, "MASTER" );
	
	if ( iSummonControlType == CSL_SUMMONCONTROL_PROTECTED_SERVITUDE  )
	{
		if ( !SCSummonIsCasterProtected( oCaster, "", oSummon) )
		{
			SCSummonFree( oSummon );
		}
	}
	else if ( iSummonControlType == CSL_SUMMONCONTROL_WILLED_SERVITUDE )
	{
		// do a will save for the summon which tends to be rarely won
	}
	else if ( iSummonControlType == CSL_SUMMONCONTROL_TIMED_SERVITUDE )
	{
		int iEndingRound = GetLocalInt(oSummon, "CSLSUMMON_ENDINGCONTROL");
		float fRemainingDuration = CSLEnviroGetRemainingDuration( iEndingRound );
		if ( fRemainingDuration > 0.0f )
		{
			SCSummonFree( oSummon );
		}		//,  //CSLEnviroGetExpirationRound( CSLRandomBetweenFloat( fDuration/4, fDuration ) ) )
	}
}

//  object oCaster, string sSummoningTable, int iSummonLevel, int iPowerLevel, float fDuration, location lSummonLocation, int iImpactEffect = VFX_FNF_SUMMON_UNDEAD, int iMainSpellId = -1, int iSummonColumn = -1
// this creates a summoned creature using the cutscene dominated method to allow multiple creatures
object SCSummonCreateCreature( string sResRef, string sChainRemaining, location lSummonLocation, float fDuration, object oCaster = OBJECT_SELF, int iClass = 255,  string sOnSummonEffect = "", string sOnUnSummonEffect = "", string sOnSummonScript = "", string sOnUnSummonScript = "", string sDurationEffect = "", int iMainSpellId = -1, string sSummonTableUsed = "", int iSummonControlType = -1 )
{
	if (DEBUGGING >= 1) { CSLDebug( "SCSummonCreateCreature sResRef="+sResRef+" iMainSpellId="+IntToString( iMainSpellId ), oCaster, OBJECT_INVALID, "LightSlateGray" ); }
	effect eImpactEffect;
	if ( sOnSummonEffect != "" )
	{
		if ( CSLGetIsNumber(sOnSummonEffect) )
		{
			eImpactEffect = EffectVisualEffect( StringToInt(sOnSummonEffect) );
		}
		else
		{
			eImpactEffect = EffectNWN2SpecialEffectFile( sOnSummonEffect);
		}
	}
	else
	{
		eImpactEffect = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE);
	}
	
	// set up the effects
	effect eDurationEffect = EffectCutsceneDominated();
	if ( sDurationEffect != "" )
	{
		if ( CSLGetIsNumber(sDurationEffect) )
		{
			eDurationEffect = EffectLinkEffects( eDurationEffect, EffectVisualEffect( StringToInt(sDurationEffect) ) );
		}
		else
		{
			eDurationEffect =  EffectLinkEffects( eDurationEffect, EffectNWN2SpecialEffectFile(sDurationEffect) );
		}
	}
	
	int bStartHostile = FALSE;
	if ( iSummonControlType == CSL_SUMMONCONTROL_PROTECTED_SERVITUDE && !SCSummonIsCasterProtected( oCaster, sSummonTableUsed ) )
	{
		bStartHostile = TRUE;
	}
	
	eDurationEffect = ExtraordinaryEffect( eDurationEffect );
	eDurationEffect = SetEffectSpellId( eDurationEffect, -iMainSpellId );
	// +" iQuantity="+IntToString( iQuantity )
	if (DEBUGGING >= 1) { CSLDebug( "SCSummonCreateCreature sResRef=("+sResRef+")", oCaster, OBJECT_INVALID, "LightSlateGray" ); }
	
	object oSummon = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSummonLocation, FALSE);
	//ChangeFaction(oSummon, oCaster );
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurationEffect, oSummon, HoursToSeconds(48));
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactEffect, lSummonLocation);
	
	FloatingTextStringOnCreature("A " + GetName(oSummon) + " is now at your service.", oCaster, FALSE);
	SetLastName(oSummon, "of " + GetName(oCaster));//GetName(oMinion)+
	// add object to control object
	
	HkApplySummonTag( oSummon, oCaster, iMainSpellId, iClass );
	// now apply class features to the summon here via onsummon script
	
	if ( sOnSummonScript != "" ) { DelayCommand(0.35f, ExecuteScript(sOnSummonScript, oSummon ) ); }
	
	if ( sChainRemaining != "" ) { SetLocalString(oSummon, "CSLSUMMON_CHAIN_REMAINING", sChainRemaining ); }	
	if ( sOnUnSummonScript != "" ) { SetLocalString(oSummon, "CSLSUMMON_UNSUMMON_SCRIPT", sOnUnSummonScript ); }
	if ( sOnUnSummonEffect != "" ) { SetLocalString(oSummon, "CSLSUMMON_UNSUMMON_EFFECT", sOnUnSummonEffect ); }
	if ( sOnSummonScript != "" ) { SetLocalString(oSummon, "CSLSUMMON_SUMMON_SCRIPT", sOnSummonScript ); }
	if ( sOnSummonEffect != "" ) { SetLocalString(oSummon, "CSLSUMMON_SUMMON_EFFECT", sOnSummonEffect ); }
	
	if ( sSummonTableUsed != "" ) { SetLocalString(oSummon, "CSLSUMMON_SUMMONTABLE", sSummonTableUsed ); }
	
	if ( sDurationEffect != "" ) { SetLocalString(oSummon, "CSLSUMMON_DURATION_EFFECT", sDurationEffect ); }
	if ( iSummonControlType > 0 ) { SetLocalInt(oSummon, "CSLSUMMON_CONTROLTYPE", iSummonControlType ); }
	
	if ( iSummonControlType == CSL_SUMMONCONTROL_CONCENTRATE_SERVITUDE ) // go ahead and set this variable as well
	{
		SetLocalInt(oSummon,"X2_L_CREATURE_NEEDS_CONCENTRATION",TRUE);
	}
	else if ( iSummonControlType ==  CSL_SUMMONCONTROL_TIMED_SERVITUDE )
	{
		SetLocalInt(oSummon, "CSLSUMMON_ENDINGROUND",  CSLEnviroGetExpirationRound( CSLRandomBetweenFloat( fDuration/4, fDuration ) ) );
	}
	DelayCommand(0.25f, ExecuteScript("_mod_onsummoncreature", oSummon ) );
	DelayCommand(fDuration, ExecuteScript("_mod_onunsummoncreature", oSummon ) );
	
	if ( bStartHostile )
	{
		DelayCommand( 1.0f,SCSummonFree( oSummon ) );
	}
	
	return oSummon;
}

/*
const int SPELL_PROTECTION_FROM_ALIGNMENT = 321;
const int SPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT = 322;
SPELL_AURA_VERSUS_ALIGNMENT


SPELL_DESECRATE
SPELL_CONSECRATE
SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA


SPELLABILITY_AURA_OF_COURAGE

SPELL_AURAOFGLORY

int         = 103;

int           = 106;

int              = 136;  // RWT-OEI 03/19/07 - Removed the extra _ mark from this name
int SPELL_PROTECTION_FROM_ENERGY            = 137;  // JLR - OEI 07/11/05 -- Name changed from "Prot. from Elements"
int               = 138;
int               = 139;
int                = 140;
int SPELL_PROTECTION_FROM_SPELLS            = 141;

int SPELLABILITY_AURA_BLINDING              = 195;
int                   = 196;
int SPELLABILITY_AURA_ELECTRICITY           = 197;
int                   = 199;
int SPELLABILITY_AURA_PROTECTION            = 201;
int SPELLABILITY_AURA_UNEARTHLY_VISAGE      = 203;
int SPELLABILITY_AURA_UNNATURAL             = 204;


Magic
Water

Air




*/


// * iSummonLevel = The level of the summoning, for levels 1-9 correlating with the spells levels, with epic levels up to 15 to allow for increased and augmented summoning feats

/*

const int CSL_SUMMONCONTROL_FREEAGENT = 2; // Creature is free willed, basically this just spawns creatures
const int CSL_SUMMONCONTROL_SERVANT = 3; // Creature is completely under the control and the side of the caster
const int CSL_SUMMONCONTROL_SLAVE = 4; // Creature is completely under the control of the caster, but if given the chance will turn on the said caster ( certain magics can steal control )
const int CSL_SUMMONCONTROL_PROTECTED_SERVITUDE = 6; // Creature is only under control while the caster is protected, generally with something like a protection from evil or a pentagram
const int CSL_SUMMONCONTROL_TIMED_SERVITUDE = 7; // Creature is only under control for a limited duration ( generally about 10 rounds )
const int CSL_SUMMONCONTROL_WILLED_SERVITUDE = 8; // Creature is only under control for a limited duration based on the will of the caster, a stronger summon will attempt to break free, and hits to the caster can disrupt the will power
const int CSL_SUMMONCONTROL_CONCENTRATE_SERVITUDE = 9; // Creature is only under control for a limited duration based on the concentration of the caster, the caster casting any other spells will end the effect ( SetLocalInt(oSummon,"X2_L_CREATURE_NEEDS_CONCENTRATION",TRUE); )
const int CSL_SUMMONCONTROL_PAID_SERVITUDE = 10; // Creature is only under control if the caster offers a suitable offering ( larva for a demon for example, basically a material component, if caster does not have it, the summon turns on them )

// these are based on NWN2 spell effects, the above use domination
const int CSL_SUMMONCONTROL_EFFECTSUMMON = 11; // Creature is limited to a single creature at a time, and will be despawned on creation of a new creature


*/
void SCSummonCreature( object oCaster, string sSummoningTable, int iSummonLevel, int iPowerLevel, float fDuration, location lSummonLocation, int iMainSpellId = -1, int iSummonColumn = -1, int iSummonControlType = -1)
{	
	//SendMessageToPC( GetFirstPC(), "sSummoningTable="+sSummoningTable+" iSummonLevel="+IntToString(iSummonLevel)+" iPowerLevel="+IntToString(iPowerLevel)+" fDuration="+FloatToString(fDuration)+" iMainSpellId="+IntToString(iMainSpellId)+" iSummonColumn="+IntToString(iSummonColumn) );
	if (DEBUGGING >= 1) { CSLDebug( "sSummoningTable="+sSummoningTable+" iSummonLevel="+IntToString( iSummonLevel )+"  iPowerLevel="+IntToString(iPowerLevel), oCaster, OBJECT_INVALID, "LightSlateGray" ); }
	
	object oSD = SCSummonsGetDataObject();
	SCCheckSummonTable( sSummoningTable );
	
	int iClass = GetLocalInt( oCaster, "HKTEMP_Class" )-1;
	
	if ( iClass == CLASS_TYPE_DRUID && SCSummonGetIsAshboundSpell( iMainSpellId ) && GetHasFeat(FEAT_ASHBOUND, oCaster) )
	{
		fDuration = fDuration * 2;
	}
	
	int iMaxAllowedSummons = ( HkGetBestCasterLevel( oCaster )*4 )-( iSummonLevel*2 );
	// remove prior to casting the spell, so it removes previous summons only...subtracts summonlevel times 2 to make room for new summons
	SCSummonRemoveIfMoreThanHitDice(oCaster, iMaxAllowedSummons );
	
	int iSummonMethod = SCSummonGetMethod( oSD, sSummoningTable, iSummonLevel );
	if ( iSummonControlType == -1 )
	{
		iSummonControlType = SCSummonGetControlType( oSD, sSummoningTable, iSummonLevel );
	}
	string sResRef = SCSummonGetResref( oSD, sSummoningTable, iSummonMethod, iPowerLevel, iSummonLevel, iMainSpellId, iSummonColumn );
	string sResRef2, sResRef3, sResRef4, sChainRemaining;
	
	string sOnSummonScript = SCSummonGetSummonScript( oSD, sSummoningTable, iSummonLevel );
	string sOnUnSummonScript = SCSummonGetUnSummonScript( oSD, sSummoningTable, iSummonLevel );
	string sOnSummonEffect = SCSummonGetSummonEffect( oSD, sSummoningTable, iSummonLevel );
	string sOnUnSummonEffect = SCSummonGetUnSummonEffect( oSD, sSummoningTable, iSummonLevel );
	string sDurationEffect = SCSummonGetDurationEffect( oSD, sSummoningTable, iSummonLevel );
	string sProtection = SCSummonGetProtection( oSD, sSummoningTable, iSummonLevel );
	string sFormation = SCSummonGetFormation( oSD, sSummoningTable, iSummonLevel );
	
	
	if (DEBUGGING >= 1) { CSLDebug( "sResRef="+sResRef+" iSummonMethod="+IntToString( iSummonMethod )+" iSummonControlType="+IntToString( iSummonControlType ), oCaster, OBJECT_INVALID, "LightSlateGray" ); }
	
	
	if (  iSummonControlType == CSL_SUMMONCONTROL_EFFECTSWARM )
	{
		// use pipes to determine the different creatures which appear
		//sResRef = CSLNth_GetRandomElement(sResRef,"|"); // is there even a pipe here
		sResRef = CSLNth_GetNthElement(sResRef, 1, "|"); // c_elmairelder|c_elmwaterelder|c_elmfireelder|c_elmearthelder
		sResRef2 = CSLNth_GetNthElement(sResRef, 2, "|");
		sResRef3 = CSLNth_GetNthElement(sResRef, 3, "|");
		sResRef4 = CSLNth_GetNthElement(sResRef, 4, "|");		
	}
	else if ( iSummonMethod == CSL_SUMMONMETHOD_CHAIN )
	{
		sChainRemaining = CSLNth_Shift(sResRef, "|"); // gets first item from the given array
		sResRef = CSLNth_GetLast();
	}
	else // pick a random creature from the pipes
	{
		sResRef = CSLNth_GetRandomElement(sResRef,"|"); // is there even a pipe here
	}
	if (DEBUGGING >= 1) { CSLDebug( "sResRef2="+sResRef, oCaster, OBJECT_INVALID, "LightSlateGray" ); }
	//SendMessageToPC( GetFirstPC(), "sResRef="+sResRef );
	
	
	// figure out how many
	int iQuantity = 1;
	int iPosition = FindSubString( sResRef, ":" );
	if ( iPosition > -1 )
	{
		string sQuantity = GetStringLeft( sResRef, iPosition );
		sResRef = GetStringRight( sResRef, GetStringLength(sResRef)-(iPosition+1) );
		
		iQuantity = CSLRollStringtoInt( sQuantity );
		
		// debugging to make sure i have the string positioning right.
		//SendMessageToPC( GetFirstPC(), "Rolling: "+sQuantity+" for a quantity of "+IntToString( iQuantity )+" of " + sResRef  );
	}
	
	iQuantity = CSLGetMax( 1, iQuantity ); // make sure at least one
	iQuantity = CSLGetMin( 10, iQuantity ); // make sure not more than 10, which is probably twice what it should be, this can be raised to whatever cap makes sense ( thinking it should be really 6 at most or there will be issues but this should be decided in the config files and not here, this is just for sanity )
		
	
	if (DEBUGGING >= 1) { CSLDebug( "sResRef3="+sResRef, oCaster, OBJECT_INVALID, "LightSlateGray" ); }
	
	if ( iSummonControlType == CSL_SUMMONCONTROL_EFFECTSUMMON )
	{
		float fDelay = 1.0f;
		CSLMultiSummonStacking( oCaster, iMaxAllowedSummons, fDelay+0.5f );
		effect eSummon = EffectSummonCreature(sResRef, StringToInt(sOnSummonEffect), fDelay);
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration );
	}
	else if ( iSummonControlType == CSL_SUMMONCONTROL_EFFECTSWARM ) // method should be chain normally
	{
		effect eImpactEffect;
		if ( sOnSummonEffect != "" )
		{
			if ( CSLGetIsNumber(sOnSummonEffect) )
			{
				eImpactEffect = EffectVisualEffect( StringToInt(sOnSummonEffect) );
			}
			else
			{
				eImpactEffect = EffectNWN2SpecialEffectFile( sOnSummonEffect);
			}
		}
		else
		{
			eImpactEffect = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE); // default summon effect
		}
		
		float fDelay = 1.0f;
		int iLooping = FALSE;
		effect eSummon = EffectSwarm(iLooping, sResRef, sResRef2, sResRef3, sResRef4);
		//eSummon = EffectSwarm(FALSE, "csl_sum_elem_air_21greater", "csl_sum_elem_air_21greater","csl_sum_elem_air_21greater","csl_sum_elem_air_21greater");
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactEffect, lSummonLocation);
		//eSummon = EffectSummonCreature(sResRef, StringToInt(sOnSummonEffect), fDelay);
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration );
		// HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, oCaster, fDuration);
	}
	else // default is CSL_SUMMONCONTROL_SLAVE which uses cutscene domination
	{
		
		if (DEBUGGING >= 1) { CSLDebug( "sResRef Final="+sResRef+" iQuantity="+IntToString( iQuantity ), oCaster, OBJECT_INVALID, "LightSlateGray" ); }
		int iCurrentRow;
		for (iCurrentRow = 1; iCurrentRow <= iQuantity; iCurrentRow++) 
		{	
			// use the formations code of some sort to vary the position they pop into
			SCSummonCreateCreature( sResRef, sChainRemaining, lSummonLocation, fDuration, oCaster, iClass,  sOnSummonEffect, sOnUnSummonEffect, sOnSummonScript, sOnUnSummonScript, sDurationEffect, iMainSpellId, sSummoningTable, iSummonControlType );
			sChainRemaining = ""; // only should store the chain on the first one, i expect chaining will only be in effect with single creatures at a time, but can be more complex
		}
		
		
	}
}






// cleanly despawns the given creature
void SCSummonRemove( object oSummon )
{
	int iSpellId = GetLocalInt( oSummon, "SCSummon" );
	//if ( !GetIsObjectValid( GetLocalObject(oSummon , "MASTER") )
	if ( iSpellId == 0 )
	{
		return;
	}
	
	
	string sOnUnSummonEffect = GetLocalString(oSummon, "CSLSUMMON_UNSUMMON_EFFECT" );
	
	if ( sOnUnSummonEffect != "" )
	{
		if ( CSLGetIsNumber(sOnUnSummonEffect) )
		{
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( StringToInt(sOnUnSummonEffect) ), GetLocation(oSummon));
		}
		else
		{
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sOnUnSummonEffect), GetLocation(oSummon));
		}
	}
	else
	{
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_MEDIUM_SMOKEPUFF), GetLocation(oSummon));
	}
	
	effect e2 = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
	e2 = SetEffectSpellId( EffectLinkEffects( e2,  EffectCutsceneParalyze()), -1);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, oSummon);
	if ( GetLocalInt( oSummon, "DIED" ) ) 
	{
		SetPlotFlag(oSummon, FALSE);
		SetImmortal(oSummon, FALSE);
		CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oSummon, oSummon, -iSpellId );
		DestroyObject(oSummon, 0.50f); // need to make sure it's dead
	}
	else
	{
		SetPlotFlag(oSummon, FALSE);
		SetImmortal(oSummon, FALSE);
		DelayCommand(0.75f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oSummon, oSummon, -iSpellId ) );
		DestroyObject(oSummon, 0.80f);
	}
	
	//DelayCommand(0.25f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE, TRUE, TRUE), oSummon));

	//DelayCommand(2.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oTarget)*2), oSummon));

}





// code from the summon monster spell
void SCSummonBoost(object oSummon, object oMaster, int iBonus = 0  )
{
	int iSpellId = GetLocalInt( oSummon, "SCSummon" );
	
	int nDamBonus = 0;
	if      (iBonus==1) {nDamBonus = DAMAGE_BONUS_1;}
	else if (iBonus==2) {nDamBonus = DAMAGE_BONUS_2;}
	else if (iBonus==3) {nDamBonus = DAMAGE_BONUS_3;}
	else if (iBonus==4) {nDamBonus = DAMAGE_BONUS_4;}
	else if (iBonus==5) {nDamBonus = DAMAGE_BONUS_5;}
	int nElement = DAMAGE_TYPE_ACID;
	
	if (GetHasFeat(FEAT_AUGMENT_SUMMONING, oMaster))
	{
		if ( GetLocalInt( oMaster, "HKTEMP_SubSchool" ) == SPELL_SUBSCHOOL_SUMMONING )
		{
			// Each creature you conjure with a summon spell gains a +4 enhancement bonus to Strength and Constitution for the duration it is summoned.
			SetBaseAbilityScore(oSummon, ABILITY_STRENGTH, GetAbilityScore(oSummon, ABILITY_STRENGTH, TRUE ) + 4);
			SetBaseAbilityScore(oSummon, ABILITY_CONSTITUTION, GetAbilityScore(oSummon, ABILITY_CONSTITUTION, TRUE ) + 4);
		}
	}
	
	// Beckon the frozen feat by kaedrin
	if (GetHasFeat(FEAT_BECKON_THE_FROZEN, oMaster))
	{
		effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
		effect eDmgImm = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999,0);
		effect eDmgVul = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50);
		effect eLink = EffectLinkEffects(eDmgVul, eDmgImm);
		eLink = EffectLinkEffects(eLink, eDmg);
		eLink = SetEffectSpellId(eLink,FEAT_BECKON_THE_FROZEN);
		eLink = SupernaturalEffect(eLink);	
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon));
	}
	
	if ( CSLGetIsElemental( oSummon ) == TRUE )
	{
		int iType = CSLGetElementalType( oSummon );
		if ( iType == SCRACE_ELEMENTALTYPE_FIRE ) { nElement = DAMAGE_TYPE_FIRE; }
		else if ( iType == SCRACE_ELEMENTALTYPE_AIR ) { nElement = DAMAGE_TYPE_SONIC; }
		else if ( iType == SCRACE_ELEMENTALTYPE_WATER ) { nElement = DAMAGE_TYPE_COLD; }
		else if ( iType == SCRACE_ELEMENTALTYPE_EARTH ) { nElement = DAMAGE_TYPE_ACID; }
		
		// augment elemental feat - need to sideways set this up so it works on elemental tables
		if ( GetHasFeat(FEAT_AUGMENT_ELEMENTAL, oMaster))
		{	
			effect eLink = EffectTemporaryHitpoints(GetHitDice(oSummon)*2);
			eLink = SetEffectSpellId(eLink,FEAT_AUGMENT_ELEMENTAL);
			eLink = SupernaturalEffect(eLink);	
			DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon));
			
			itemproperty iEnhance = ItemPropertyEnhancementBonus(2);	
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oSummon);
			if (GetIsObjectValid(oWeapon))
			{
				AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
			}
			
			oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oSummon);
			if (GetIsObjectValid(oWeapon))
			{
				AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
			}
			
			oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oSummon);
			if (GetIsObjectValid(oWeapon))
			{
				AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
			}
		
		}
	}
	
	if ( nDamBonus > 0 )
	{
		FloatingTextStringOnCreature("Summon AC/Damage Bonus +" + IntToString(iBonus), oSummon, FALSE);
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(nDamBonus, nElement ), oSummon);
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(iBonus), oSummon);
	}
	
	// ashbound feat by kaedrin
	if ( GetHasFeat(FEAT_ASHBOUND, oMaster) && SCSummonGetIsAshboundSpell( iSpellId ) )
	{
		FloatingTextStringOnCreature("Summon Ashbound Bonus +" + IntToString(3), oSummon, FALSE);
		effect eLink = EffectAttackIncrease(3);
		eLink = SetEffectSpellId(eLink, -FEAT_ASHBOUND );
		eLink = SupernaturalEffect(eLink);	
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon));
	}
	
}

/*
Old Versions
string GetElementType(string sAir, string sWater, string sFire, string sEarth) {
	string dom1 = "";
	string dom2 = "";
	if (GetHasFeat(FEAT_AIR_DOMAIN_POWER))   if (dom1=="") dom1=sAir  ; else dom2=sAir;   //return sAir;
	if (GetHasFeat(FEAT_WATER_DOMAIN_POWER)) if (dom1=="") dom1=sWater; else dom2=sWater; //return sWater;
	if (GetHasFeat(FEAT_FIRE_DOMAIN_POWER))  if (dom1=="") dom1=sFire ; else dom2=sFire;  //return sFire;
	if (GetHasFeat(FEAT_EARTH_DOMAIN_POWER)) if (dom1=="") dom1=sEarth; else dom2=sEarth; //return sEarth;
	if (dom1!="") return CSLPickOne(dom1, dom2); // IF THEY ARE SPECIAL, PICK ONE OF THE SPECIALTIES
	return CSLPickOne(sAir, sWater, sFire, sEarth); // OTHERWISE, RANDOMIZE!
}

int GetEffectID( int iSpellId ) {
	return VFX_HIT_SPELL_SUMMON_CREATURE;
}

int GetSummonLevel(int iSpellId) { // MAX OF 14 WITH ALL FEATS
	int nLvl = 1;
	if      (iSpellId==SPELL_SUMMON_CREATURE_I)    nLvl = 1;
	else if (iSpellId==SPELL_SUMMON_CREATURE_II)   nLvl = 2;
	else if (iSpellId==SPELL_SUMMON_CREATURE_III)  nLvl = 3;
	else if (iSpellId==SPELL_BG_Summon_Creature_III)  nLvl = 3;
	else if (iSpellId==SPELL_SUMMON_CREATURE_IV)   nLvl = 4;
	else if (iSpellId==SPELL_SUMMON_CREATURE_V)    nLvl = 5;
	else if (iSpellId==SPELL_SUMMON_CREATURE_VI)   nLvl = 6;
	else if (iSpellId==SPELL_SUMMON_CREATURE_VII)  nLvl = 7;
	else if (iSpellId==SPELL_SHADES_TARGET_GROUND) nLvl = 7; // SPECIAL
	else if (iSpellId==SPELL_SUMMON_CREATURE_VIII) nLvl = 8;
	else if (iSpellId==SPELL_SUMMON_CREATURE_IX)   nLvl = 9;

	int iBonus = 0;
	if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION))         iBonus++;
	if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION)) iBonus++;
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION))    iBonus++;
	if (GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))             iBonus++; //WITH THE ANIMAL DOMAIN
	if (GetHasFeat(FEAT_AUGMENT_SUMMONING))               iBonus+=2; //WITH THE SUMMON AUGMENTATION FEAT
	if (nLvl<9 && iBonus) FloatingTextStringOnCreature("Summon boosted to level " + IntToString(CSLGetMin(9, nLvl+iBonus)), OBJECT_SELF, FALSE);
	return nLvl+iBonus;
}

string GetSummonResRef(int nLvl) {
	string sSummon = "c_rat";
	if      (nLvl==1) sSummon = "c_dogwolf";
	else if (nLvl==2) sSummon = "c_badgerdire";
	else if (nLvl==3) sSummon = "c_dogwolfdire";
	else if (nLvl==4) sSummon = "c_boardire";
	else if (nLvl==5) sSummon = "c_dogshado";
	else if (nLvl==6) sSummon = "c_beardire";
	else if (nLvl==7) sSummon = GetElementType("c_elmairhuge",   "c_elmwaterhuge",   "c_elmfirehuge",   "c_elmearthhuge");
	else if (nLvl==8) sSummon = GetElementType("c_elmairgreater","c_elmwatergreater","c_elmfiregreater","c_elmearthgreater");
	else if (nLvl>=9) sSummon = GetElementType("c_elmairelder",  "c_elmwaterelder",  "c_elmfireelder",  "c_elmearthelder");
	return sSummon;
}
*/
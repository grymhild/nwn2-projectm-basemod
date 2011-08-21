/** @file
* @brief Feat related constants
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////
// adding
const int FEAT_MOTHER_CYST = -999998;
const int FEAT_FRENZY = -999999;
                     
// need to work on the feat id's for these
// FEAT_EVASION
// FEAT_IMPROVED_EVASION
const int FEAT_METTLE = 681899; // evasion for both will AND fortitude saves, in TOB it's 6818
const int FEAT_IMPROVEDMETTLE = 681899; // improved evasion for both will AND fortitude saves
const int FEAT_METTLE_OF_FORTITUDE = 681899; // evasion for fortitude
const int FEAT_METTLE_OF_WILL = 681899;	// evasion for will
const int FEAT_IMPROVED_METTLE_OF_FORTITUDE = 681899; // improved evasion for fortitude
const int FEAT_IMPROVED_METTLE_OF_WILL = 681899; // improved evasion for will
const int FEAT_METTLE_OF_IRONED_WILL = 681899; // as FEAT_METTLE_OF_WILL but requires wearing heavy armor, for class iron mind from races of stone, only works when in heavy armor
const int FEAT_METTLE_OF_IRONED_FORTITUDE = 681899; // as FEAT_METTLE_OF_FORTITUDE but requires wearing heavy armor, for class iron mind from races of stone, only works when in heavy armor



const int FEAT_EVASION_CHAINED = 681899; // allows evasion to work when wearing medium armor
const int FEAT_EVASION_IRONED = 681899; // allow evasion to work when wearing heavy armor

const int SCSTR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS   = 40550;
const int SCSTR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS = 85587;
const int SCSTR_REF_FEEDBACK_NO_MORE_FEAT_USES    = 66797; // AFW-OEI 02/28/2007
const string SCRESREF_DEFAULT_WAYPOINT = "nw_waypoint001";


const int FEAT_ELEMSHAPE_EMBERGUARD = 3518;
const int FEAT_AUGMENT_ELEMENTAL = 3519;
const int FEAT_ASHBOUND = 3520;
const int FEAT_SHARED_FURY = 3522;

const int FEAT_MELEE_WEAPON_MASTERY_B = 3524;
const int FEAT_MELEE_WEAPON_MASTERY_P = 3525;
const int FEAT_MELEE_WEAPON_MASTERY_S = 3526;
const int FEAT_SILVER_FANG = 3527;
const int FEAT_SILVER_FANG_COMP = 3528;
const int FEAT_DRAGONSONG = 3529;
const int FEAT_ABILITY_FOCUS_BARDSONG = 3530;
const int FEAT_ABILITY_FOCUS_ELDRITCH_BLAST = 3531;
const int FEAT_ABILITY_FOCUS_INVOCATIONS = 3532;
const int FEAT_SANCTIFY_STRIKES = 3533;
const int FEAT_HEAVY_ARMOR_OPTIMIZATION = 3534;
const int FEAT_GREATER_HEAVY_ARMOR_OPTIMIZATION = 3535;

const int FEAT_BARDSONG_SNOWFLAKE_WARDANCE = 3552;
const int FEAT_CHARNAG_WAY_SHADOW = 3772;
const int SPELLABILITY_CHARNAG_WAY_KINSLAYER = 2146;


const int SPELLABILITY_WEAPON_SUPREMACY = 2012;
const int SPELLABILITY_MELEE_WEAPON_MASTERY_B = 2013;
const int SPELLABILITY_MELEE_WEAPON_MASTERY_P = 2014;
const int SPELLABILITY_MELEE_WEAPON_MASTERY_S = 2015;
const int SPELLABILITY_SANCTIFY_STRIKES = 2016;
const int SPELLABILITY_DRAGONSONG = 2017;
const int SPELLABILITY_HEAVY_ARMOR_OPTIMIZATION = 2018;
const int SPELLABILITY_GREATER_HEAVY_ARMOR_OPTIMIZATION = 2019;
const int SPELLABILITY_FOTF_AC_BONUS = 2020;
const int SPELLABILITY_FOTF_UNARMED_BONUS = 2021;
const int SPELLABILITY_FOTF_FERAL_STANCE = 2022;
const int SPELLABILITY_COTSF_BLESSING_CHAMP = 2024;


// these are in nwscript
//int FEAT_EPIC_AUTOMATIC_QUICKEN_1     =  857;
//int FEAT_EPIC_AUTOMATIC_QUICKEN_2     =  858;
//int FEAT_EPIC_AUTOMATIC_QUICKEN_3     =  859;
// these are not

// Missing Feats
const int FEAT_BATTLE_CASTER = 1766;
const int FEAT_IMPROVED_CRITICAL_FALCHION				=	1589;
const int FEAT_WEAPON_FOCUS_FALCHION					=	1590;
const int FEAT_WEAPON_SPECIALIZATION_FALCHION			=	1591;
const int FEAT_EPIC_DEVASTATING_CRITICAL_FALCHION		=	1592;
const int FEAT_EPIC_WEAPON_FOCUS_FALCHION				=	1593;
const int FEAT_EPIC_WEAPON_SPECIALIZATION_FALCHION		=	1594;
const int FEAT_EPIC_OVERWHELMING_CRITICAL_FALCHION		=	1595;
const int FEAT_WEAPON_OF_CHOICE_FALCHION				=	1596;
const int FEAT_GREATER_WEAPON_FOCUS_FALCHION			=	1597;
const int FEAT_GREATER_WEAPON_SPECIALIZATION_FALCHION	=	1598;
const int FEAT_POWER_CRITICAL_FALCHION					=	1599;
const int FEAT_IMPROVED_CRITICAL_WARMACE				=	1825;
const int FEAT_WEAPON_FOCUS_WARMACE						=	1826;
const int FEAT_WEAPON_SPECIALIZATION_WARMACE			=	1827;
const int FEAT_WEAPON_OF_CHOICE_WARMACE					=	1828;
const int FEAT_GREATER_WEAPON_FOCUS_WARMACE				=	1829;
const int FEAT_GREATER_WEAPON_SPECIALIZATION_WARMACE	=	1830;
const int FEAT_POWER_CRITICAL_WARMACE					=	1831;
//const int FEAT_EPIC_DEVASTATING_CRITICAL_WARMACE		=	1925; Removed in feats 2da
const int FEAT_EPIC_WEAPON_FOCUS_WARMACE				=	1926;
const int FEAT_EPIC_WEAPON_SPECIALIZATION_WARMACE		=	1927;
const int FEAT_EPIC_OVERWHELMING_CRITICAL_WARMACE		=	1928;
const int FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING			=	1972;
const int FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING	= 1973;

//const int FEAT_ELABORATE_PARRY = 1742;
const int FEAT_LAYONHANDS_HOSTILE = 2989;

const int FEAT_RANGED_TOUCH_SPELL_SPECIALIZATION = 2991;
const int FEAT_MELEE_TOUCH_SPELL_SPECIALIZATION = 2992;

const int FEAT_CROSSBOW_SNIPER = 3129;
const int FEAT_SACRED_VOW = 3130;
const int FEAT_EXALTED_NATURAL_ATTACK = 3131;
const int FEAT_EXALTED_WILD_SHAPE = 3132;
const int FEAT_EXALTED_COMPANION = 3133;
const int FEAT_RANGED_WEAPON_MASTERY = 3134;


const int FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE_1 = 3028;
const int FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE_2 = 3029;
const int FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE_3 = 3030;
const int FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE_4 = 3031;
const int FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE_5 = 3032;
const int FEAT_PRESTIGE_SPELL_GHOSTLY_VISAGE_6 = 3033;
const int FEAT_PRESTIGE_DARKNESS_1 = 3034;
const int FEAT_PRESTIGE_DARKNESS_2 = 3035;
const int FEAT_PRESTIGE_DARKNESS_3 = 3036;
const int FEAT_PRESTIGE_DARKNESS_4 = 3037;
const int FEAT_PRESTIGE_DARKNESS_5 = 3038;
const int FEAT_PRESTIGE_DARKNESS_6 = 3039;
const int FEAT_PRESTIGEx_INVISIBILITY_1 = 3040;
const int FEAT_PRESTIGEx_INVISIBILITY_2 = 3041;
const int FEAT_PRESTIGEx_INVISIBILITY_3 = 3042;
const int FEAT_PRESTIGEx_INVISIBILITY_4 = 3043;
const int FEAT_PRESTIGEx_INVISIBILITY_5 = 3044;
const int FEAT_PRESTIGEx_INVISIBILITY_6 = 3045;
const int FEAT_PRESTIGE_IMP_INVISIBILITY_1 = 3046;
const int FEAT_PRESTIGE_IMP_INVISIBILITY_2 = 3047;
const int FEAT_PRESTIGE_IMP_INVISIBILITY_3 = 3048;
const int FEAT_PRESTIGE_IMP_INVISIBILITY_4 = 3049;
const int FEAT_PRESTIGE_IMP_INVISIBILITY_5 = 3050;
const int FEAT_PRESTIGE_IMP_INVISIBILITY_6 = 3051;


const int FEAT_EPIC_WIDEN_AURA_DESPAIR = 3052;
const int FEAT_EPIC_IMPROVED_AURA_DESPAIR = 3053;


const int FEAT_EPITHET_CELERITY_DOMAIN = 3058;
const int FEAT_EPITHET_DWARF_DOMAIN = 3059;
const int FEAT_EPITHET_ELF_DOMAIN = 3060;
const int FEAT_EPITHET_FATE_DOMAIN = 3061;
const int FEAT_EPITHET_HATRED_DOMAIN = 3062;
const int FEAT_EPITHET_MYSTICISM_DOMAIN = 3063;
const int FEAT_EPITHET_PESTILENCE_DOMAIN = 3064;
const int FEAT_EPITHET_STORM_DOMAIN = 3065;
const int FEAT_EPITHET_SUFFERING_DOMAIN = 3066;
const int FEAT_EPITHET_TYRANNY_DOMAIN = 3067;
const int FEAT_EPITHET_REPOSE_DOMAIN = 3068;
const int FEAT_EPITHET_COURAGE_DOMAIN = 3069;
const int FEAT_EPITHET_GLORY_DOMAIN = 3070;
const int FEAT_EPITHET_PURIFICATION_DOMAIN = 3071;
const int FEAT_EPITHET_COMPETITION_DOMAIN = 3072;
const int FEAT_DOMAIN_INSPIRE_HATRED = 3073;
const int FEAT_DOMAIN_MYSTIC_PROT = 3074;
const int FEAT_DOMAIN_PAIN_TOUCH = 3075;
const int FEAT_DOMAIN_DEATH_TOUCH = 3076;


const int FEAT_RESERVE_ACIDIC_SPLATTER = 3092;
const int FEAT_RESERVE_CLAP_OF_THUNDER = 3093;
const int FEAT_RESERVE_FIERY_BURST = 3094;
const int FEAT_RESERVE_HURRICANE_BREATH = 3095;
const int FEAT_RESERVE_INVISIBLE_NEEDLE = 3096;
const int FEAT_RESERVE_MINOR_SHAPESHIFT = 3097;
const int FEAT_RESERVE_STORM_BOLT = 3098;
const int FEAT_RESERVE_SICKENING_GRASP = 3099;
const int FEAT_RESERVE_SUMMON_ELEMENTAL = 3100;
const int FEAT_RESERVE_WINTERS_BLAST = 3101;
const int FEAT_RESERVE_HOLY_WARRIOR = 3102;

const int FEAT_RESERVE_TOUCH_OF_HEALING = 3104;
const int FEAT_RESERVE_UMBRAL_SHROUD = 3105;








const int FEAT_FAST_HEALING_II = 3193;
const int FEAT_GTR_2WPN_DEFENSE = 3194;
const int FEAT_BECKON_THE_FROZEN = 3195;

const int FEAT_ARMOR_SPECIALIZATION_MEDIUM = 3198;
const int FEAT_ARMOR_SPECIALIZATION_HEAVY = 3199;
const int FEAT_EPIC_INSPIRATION = 3200;
const int FEAT_SONG_OF_THE_HEART = 3201;

const int FEAT_DAYLIGHT_ENDURANCE = 3203;
const int FEAT_DAYLIGHT_ADAPTION = 3203;
const int FEAT_OVERSIZE_TWO_WEAPON_FIGHTING = 3204;

const int FEAT_BATTLE_DANCER = 3206;
const int FEAT_FIERY_FIST = 3207;

const int FEAT_UNARMED_COMBAT_MASTERY = 3209;

const int FEAT_FOREST_MASTER_FOREST_HAMMER = 3218;


const int FEAT_DEADLY_DEFENSE = 3237;


const int FEAT_BARB_WHIRLWIND_FRENZY = 3251;

const int PARRY_AC_BONUS = -4006;
const int UNCANNY_DODGE_BONUS = -4007;
const int SCOUT_FIX_BONUS = -4008;



const int FEAT_FROSTMAGE_PIERCING_COLD = 3285;
const int FEAT_SACREDFIST_CODE_OF_CONDUCT = 3316;

const int FEAT_DARING_OUTLAW = 3319;
const int FEAT_MELODIC_CASTING = 3330;
const int FEAT_LYRIC_THAUM_SONIC_MIGHT = 3331;


const int FEAT_PRACTICED_SPELLCASTER_ASSASSIN = 3353;
const int FEAT_PRACTICED_SPELLCASTER_BLACKGUARD = 3354;
const int FEAT_PRACTICED_SPELLCASTER_AVENGER = 3355;
const int FEAT_DIVCHA_SPELLCASTING = 3356;
const int FEAT_INTUITIVE_ATTACK = 3357;


const int FEAT_RESERVE_PROTECTIVE_WARD = 3553;


const int FEAT_CRAFT_ROD  = 3843;

const int FEAT_CRAFT_STAFF = 3844;

const int FEAT_FORGE_RING = 3845;



/*
const int FEAT_DRSLR_SPELLCASTING_WARLOCK = 3372;
const int FEAT_DRSLR_SPELLCASTING_ASSASSIN = 3373;
const int FEAT_DRSLR_SPELLCASTING_AVENGER = 3374;
const int FEAT_DRSLR_SPELLCASTING_BLACKGUARD = 3375;
*/

const int FEAT_ENERGY_SUBSTITUTION = -1;

// const int FEAT_COUNTERSPELL = 5951; // defined with magic system
const int FEAT_QUICKEN_SPELLLIKEABILITY = 5952;
const int FEAT_EMPOWER_SPELLLIKEABILITY = 5953;
const int FEAT_MAXIMIZE_SPELLLIKEABILITY = 5954;
const int FEAT_STILL_SPELLLIKEABILITY = 5955;
const int FEAT_EXTEND_SPELLLIKEABILITY = 5956;
const int FEAT_PERSISTENT_SPELLLIKEABILITY = 5957;

const int FEAT_IMPROVED_SWIMMING = 5960;
const int FEAT_IMPROVED_CLIMBING = 5961;

const int FEAT_FIENDISH_ADAPTATION = 5962;
const int FEAT_FEY_ADAPTATION = 5963;
const int FEAT_DESERT_ADAPTATION = 5964;
const int FEAT_FIRE_ADAPTATION = 5965;
const int FEAT_MAGMA_ADAPTATION = 5966;
const int FEAT_WATER_ADAPTATION = 5967;
const int FEAT_STORM_ADAPTATION = 5968;
const int FEAT_COLD_ADAPTATION = 5969;
const int FEAT_ACIDIC_ADAPTATION = 5970;
const int FEAT_POSITIVE_ADAPTATION = 5971;
const int FEAT_NEGATIVE_ADAPTATION = 5972;

// Hurling items
const int FEAT_ROCK_THROWING = 5973; // or cows, linked to spell
const int FEAT_ROCK_CATCHING = 5974; // reflex roll to catch rocks, basically like parry
const int FEAT_AWESOME_BLOW = 5975; // ( blows that send it's smaller opponents flying like bowling pins )

// Charging based attacks, which are part of a charge or hurl the opponent
const int FEAT_BULL_RUSH = 5976; // earth elemental knocks back single target
const int FEAT_IMPROVED_BULL_RUSH = 5977; // earth elemental knocks back single target, no AoO
const int FEAT_RHINO_CHARGE = 5978; // knocks down and back anyone in path
const int FEAT_TRAMPLING_CHARGE = 5979; // knocks over and damages anyone knocked down under your feet
const int FEAT_POWERFUL_CHARGE = 5980; // damage increase in round after a charge
const int FEAT_POUNCE = 5981; // allowed full attack after a charge, done as a full set of attacks like glaive
const int FEAT_OVERRUN_ENGULF = 5982; // allowed full attack after a charge
const int FEAT_BURROWCHARGE = 5983; // Ankheg charge attack from under the ground
const int FEAT_LEAPATTACK = 5984; // Bulette, special attack with more attacks, needs animations

// Grappling based attacks - these grapple the opponent and can be used to carry them or restrict movement - related to bigby
const int FEAT_GRAB = 5985; // note this is via hand or via mouth
const int FEAT_IMPROVEDGRAB = 5986; // T Rex in mouth, will vary WHERE by creature
const int FEAT_SNATCH = 5987; // ( grapple attack - 3 or more sizes smaller can be grabbed in hands, beak or claw ) - no idea difference between this and grab except the size limitation
const int FEAT_VORTEX = 5988; // water elemental, any who are picked up get carried along
const int FEAT_WHIRLWIND = 5989; // air elemental or a tornado, any who are picked up get carried along - basically it's like a ride

// a grapple that does not restrict movement, but allows the attacker to ride the targets back
const int FEAT_ATTACH = 5990; // stirge - does not restrict the targets movement but makes the grappler attach to the target

// Grapple required attacks-  extra attacks which can be used after a grapple
const int FEAT_ENGULF = 5991; // Cloaker and gelatinous cube
const int FEAT_SWALLOW_WHOLE = 5992; // ( after grapple attack puts them into special digestion area)
const int FEAT_CONSTRICT = 5993; // ( grapple attack )
const int FEAT_REND = 5994; // ( gray render ) damage after a grapple/grab
const int FEAT_BLOOD_DRAIN = 5995; // stirge - drains blood when attached

// Ankheg and Xorn, those with movement in earth
const int FEAT_BURROWSANCTUARY = 5996; // creature goes underground, effectively safe from all attacks - perhaps earthquake can affect it - basically a mode with cutscene invisibility//collision off/and other etheralness
const int FEAT_BURROWDOOR = 5997;  // like dimension door, but with a delay between going under and reappearing ( limbo for a few rounds, but ideally it can be made to work with a real PC while i test it out
const int FEAT_TREMORSENSE = 5998; // can see things when underground or blinded

//int FEAT_ARCANE_DEFENSE_ABJURATION = 415;

/*
35	SpellFocusFire	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
393	GreatSpellFocusFire	2783	2791	ife_greatspellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	****	****	35	****	0	0	1	****	****	****	****	0.5	****	****	6	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_GREATER_SPELL_FOCUS_ABJURATION	6	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
610	EpicSpellFocusFire	4083	4084	ife_epicspellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	9	****	393	****	0	0	1	****	****	****	****	0.5	****	****	16	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_EPIC_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	1	EPIC_FT_CAT	0	0	****	****	0	0	****	****	****
415	ArcaneDefenseFire	2815	2823	ife_arcanedefense	****	****	****	****	****	****	****	****	****	****	****	****	****	****	****	35	****	0	0	1	****	****	****	****	1	****	****	7	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_ARCANE_DEFENSE_ABJURATION	6	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellEnhanceFire	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
393	GrSpllEnhanceFire	2783	2791	ife_greatspellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	****	****	35	****	0	0	1	****	****	****	****	0.5	****	****	6	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_GREATER_SPELL_FOCUS_ABJURATION	6	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellSpecializationFire	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****


// odd ones - make time of day dependent...
35	SpellFocusDawn	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellFocusSolar	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellFocusDusk	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellFocusLunar	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellEnhanceDawn	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellEnhanceSolar	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellEnhanceDusk	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****
35	SpellEnhanceLunar	425	426	ife_spellfocus	****	****	****	****	****	****	****	****	****	****	****	****	****	1	****	****	****	0	0	0	****	****	****	****	1	****	****	3	****	****	****	****	****	****	****	****	****	****	****	****	****	FEAT_SPELL_FOCUS_ABJURATION	4	****	****	****	****	****	0	SPELLCASTING_FT_CAT	0	0	****	****	0	0	****	****	****


SpellHamperedEvasion

NONE
FIRE
COLD
ELECTRICAL
SONIC
ACID 
NEGATIVE
POSITIVE
DIVINE
FORCE	
AIR
WATER	
EARTH
LIGHT
DARKNESS	
GOOD
EVIL	
LAW
CHAOS
DEATH
GAS
SLEEP
CALLING
CREATION 
HEALING
SUMMONING
CHARM
SHADOW 
*/

// Tome of Battle
const int FEAT_SENSE_MAGIC								=	6801;
const int FEAT_AC_BONUS_SWORDSAGE						=	6802;
const int FEAT_DUAL_BOOST								=	6803;
//6804-6811 Are reserved for Saint.
const int FEAT_WEAPON_PROFICIENCY_SAINT					=	6805;
const int FEAT_AIM										=	6806;
const int FEAT_FURIOUS_COUNTERSTRIKE					=	6812;
const int FEAT_STEELY_RESOLVE							=	6813;
const int FEAT_INDOMITABLE_SOUL_CRUSADER				=	6814;
const int FEAT_ZEALOUS_SURGE							=	6815;
const int FEAT_SMITE									=	6816;
const int FEAT_DIEHARD_CRUSADER							=	6817;

const int FEAT_BATTLE_CLARITY							=	6819;
const int FEAT_WEAPON_APTITUDE							=	6820;
const int FEAT_FURIOUS_COUNTERSTRIKE_A					=	6821;
const int FEAT_BATTLE_ARDOR								=	6822;
const int FEAT_AVENGING_STRIKE_USES						=	6823;
const int FEAT_BATTLE_CUNNING							=	6824;
const int FEAT_BATTLE_SKILL								=	6825;
const int FEAT_BATTLE_MASTERY							=	6826;
const int FEAT_CRUSADER_RECOVERY						=	6827;
const int FEAT_STANCE_MASTERY							=	6828;
const int FEAT_SMITE_USES								=	6829;
const int FEAT_ADAPTIVE_STYLE							=	6830;
const int FEAT_AVENGING_STRIKE							=	6831;
const int FEAT_DESERT_FIRE								=	6832;
const int FEAT_DESERT_WIND_DODGE						=	6833;
const int FEAT_DEVOTED_BULWARK							=	6834;
const int FEAT_DIVINE_SPIRIT							=	6835;
const int FEAT_EXTRA_GRANTED_MANEUVER					=	6836;
const int FEAT_EXTRA_READIED_MANEUVER					=	6837;
const int FEAT_FALLING_SUN_ATTACK						=	6838;
const int FEAT_IRONHEART_AURA							=	6839;
const int FEAT_MARTIAL_STANCE							=	6840;
const int FEAT_MARTIAL_STUDY							=	6841;
const int FEAT_RAPID_ASSAULT							=	6842;
const int FEAT_SHADOW_BLADE								=	6843;
const int FEAT_SHADOW_TRICKSTER							=	6844;
const int FEAT_SONG_OF_THE_WHITE_RAVEN					=	6845;
const int FEAT_SNAP_KICK								=	6846;
const int FEAT_STONE_POWER								=	6847;
const int FEAT_SUDDEN_RECOVERY							=	6848;
const int FEAT_SUPERIOR_UNARMED_STRIKE					=	6849;
const int FEAT_TIGER_BLOODED							=	6850;
const int FEAT_VITAL_RECOVERY							=	6851;
const int FEAT_WHITE_RAVEN_DEFENSE						=	6852;
const int FEAT_MARTIAL_STANCE_2							=	6853;
const int FEAT_MARTIAL_STANCE_3							=	6854;
const int FEAT_MARTIAL_STUDY_2							=	6855;
const int FEAT_MARTIAL_STUDY_3							=	6856;
const int FEAT_SWORDSAGE								=	6857;
const int FEAT_CRUSADER									=	6858;
const int FEAT_WARBLADE									=	6859;
const int FEAT_SAINT									=	6860;
const int FEAT_DW_INITIATE								=	6861;
const int FEAT_DW_NOVICE								=	6862;
const int FEAT_DW_ADEPT									=	6863;
const int FEAT_DW_VETERAN								=	6864;
const int FEAT_DW_MASTER								=	6865;
const int FEAT_DS_INITIATE								=	6866;
const int FEAT_DS_NOVICE								=	6867;
const int FEAT_DS_ADEPT									=	6868;
const int FEAT_DS_VETERAN								=	6869;
const int FEAT_DS_MASTER								=	6870;
const int FEAT_DM_INITIATE								=	6871;
const int FEAT_DM_NOVICE								=	6872;
const int FEAT_DM_ADEPT									=	6873;
const int FEAT_DM_VETERAN								=	6874;
const int FEAT_DM_MASTER								=	6875;
const int FEAT_IH_INITIATE								=	6876;
const int FEAT_IH_NOVICE								=	6877;
const int FEAT_IH_ADEPT									=	6878;
const int FEAT_IH_VETERAN								=	6879;
const int FEAT_IH_MASTER								=	6880;
const int FEAT_SS_INITIATE								=	6881;
const int FEAT_SS_NOVICE								=	6882;
const int FEAT_SS_ADEPT									=	6883;
const int FEAT_SS_VETERAN								=	6884;
const int FEAT_SS_MASTER								=	6885;
const int FEAT_SH_INITIATE								=	6886;
const int FEAT_SH_NOVICE								=	6887;
const int FEAT_SH_ADEPT									=	6888;
const int FEAT_SH_VETERAN								=	6889;
const int FEAT_SH_MASTER								=	6890;
const int FEAT_SD_INITIATE								=	6891;
const int FEAT_SD_NOVICE								=	6892;
const int FEAT_SD_ADEPT									=	6893;
const int FEAT_SD_VETERAN								=	6894;
const int FEAT_SD_MASTER								=	6895;
const int FEAT_TC_INITIATE								=	6896;
const int FEAT_TC_NOVICE								=	6897;
const int FEAT_TC_ADEPT									=	6898;
const int FEAT_TC_VETERAN								=	6899;
const int FEAT_TC_MASTER								=	6900;
const int FEAT_WR_INITIATE								=	6901;
const int FEAT_WR_NOVICE								=	6902;
const int FEAT_WR_ADEPT									=	6903;
const int FEAT_WR_VETERAN								=	6904;
const int FEAT_WR_MASTER								=	6905;
const int FEAT_BLADE_MEDITATION_DW						=	6906;
const int FEAT_BLADE_MEDITATION_DS						=	6907;
const int FEAT_BLADE_MEDITATION_DM						=	6908;
const int FEAT_BLADE_MEDITATION_IH						=	6909;
const int FEAT_BLADE_MEDITATION_SS						=	6910;
const int FEAT_BLADE_MEDITATION_SH						=	6911;
const int FEAT_BLADE_MEDITATION_SD						=	6912;
const int FEAT_BLADE_MEDITATION_TC						=	6913;
const int FEAT_BLADE_MEDITATION_WR						=	6914;
const int FEAT_STUDENT_OF_THE_SUBLIME_WAY				=	6915;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DW	=	6916;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DM	=	6917;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SS	=	6918;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SH	=	6919;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SD	=	6920;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_TC	=	6921;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DW		=	6922;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DM		=	6923;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SS		=	6924;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SH		=	6925;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SD		=	6926;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_TC		=	6927;
const int FEAT_DISCIPLINE_FOCUS_WEAPON_FOCUS			=	6928;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DW2	=	6929;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DM2	=	6930;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SS2	=	6931;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SH2	=	6932;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SD2	=	6933;
const int FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_TC2	=	6934;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DW2	=	6935;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DM2	=	6936;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SS2	=	6937;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SH2	=	6938;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SD2	=	6939;
const int FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_TC2	=	6940;
const int FEAT_WEAPON_SPECIALIZATION					=	6941;
const int FEAT_GREATER_WEAPON_SPECIALIZATION			=	6942;
const int FEAT_GREATER_WEAPON_FOCUS						=	6943;
const int FEAT_MARTIAL_ADEPT							=	6944;
const int FEAT_MARTIAL_STUDY_TOGGLE						=	6945;









// Miscelaneous Attacks
const int FEAT_DRENCH = -1; // water elemental - dispels magic on any fire descriptor spells, puts out any fire based spells
const int FEAT_BURN = -1; // fire elemental - any hit can catch on fire, and who hit also take fire damage
const int FEAT_SONICSCREAM = -1; // Destrachan breath weapon
const int FEAT_SPITACID = -1; // for ankheg and a few others
const int FEAT_MOAN = -1; // Cloaker
const int FEAT_RUST = -1; // Rust monster
const int FEAT_SLIME = -1; // Aboleth
const int FEAT_MUCUS_CLOUD = -1; // Aboleth













const int DOMAIN_CELERITY = 32;
const int DOMAIN_DWARF = 33;
const int DOMAIN_ELF = 34;
const int DOMAIN_FATE = 35;
const int DOMAIN_HATRED = 36;
const int DOMAIN_MYSTICISM = 37;
const int DOMAIN_PESTILENCE = 38;
const int DOMAIN_STORM = 39;
const int DOMAIN_SUFFERING = 40;
const int DOMAIN_TYRANNY = 41;
const int DOMAIN_REPOSE = 42;
const int DOMAIN_COURAGE = 43;
const int DOMAIN_GLORY = 44;
const int DOMAIN_PURIFICATION = 45;
const int DOMAIN_COMPETITION = 46;




//  This seems to still work :) Domain constants - same as FEAT_xxx_DOMAIN_POWER
const int   DOMAIN_WAR          = FEAT_WAR_DOMAIN_POWER;
const int   DOMAIN_STRENGTH     = FEAT_STRENGTH_DOMAIN_POWER;
const int   DOMAIN_PROTECTION   = FEAT_PROTECTION_DOMAIN_POWER;
const int   DOMAIN_LUCK         = FEAT_LUCK_DOMAIN_POWER;
const int   DOMAIN_DEATH        = FEAT_DEATH_DOMAIN_POWER;
const int   DOMAIN_AIR          = FEAT_AIR_DOMAIN_POWER;
const int   DOMAIN_ANIMAL       = FEAT_ANIMAL_DOMAIN_POWER;
const int   DOMAIN_DESTRUCTION  = FEAT_DESTRUCTION_DOMAIN_POWER;
const int   DOMAIN_EARTH        = FEAT_EARTH_DOMAIN_POWER;
const int   DOMAIN_EVIL         = FEAT_EVIL_DOMAIN_POWER;
const int   DOMAIN_FIRE         = FEAT_FIRE_DOMAIN_POWER;
const int   DOMAIN_GOOD         = FEAT_GOOD_DOMAIN_POWER;
const int   DOMAIN_HEALING      = FEAT_HEALING_DOMAIN_POWER;
const int   DOMAIN_KNOWLEDGE    = FEAT_KNOWLEDGE_DOMAIN_POWER;
const int   DOMAIN_MAGIC        = FEAT_MAGIC_DOMAIN_POWER;
const int   DOMAIN_PLANT        = FEAT_PLANT_DOMAIN_POWER;
const int   DOMAIN_SUN          = FEAT_SUN_DOMAIN_POWER;
const int   DOMAIN_TRAVEL       = FEAT_TRAVEL_DOMAIN_POWER;
const int   DOMAIN_TRICKERY     = FEAT_TRICKERY_DOMAIN_POWER;
const int   DOMAIN_WATER        = FEAT_WATER_DOMAIN_POWER;
// custom domains - be sure to update when updating the custom feat constants
//const int   DOMAIN_ORC          = xxFEAT_ORC_DOMAIN_POWER;
//const int   DOMAIN_CHARM        = xxFEAT_CHARM_DOMAIN_POWER;
//const int   DOMAIN_CHAOS        = xxFEAT_CHAOS_DOMAIN_POWER;
//const int   DOMAIN_LAW          = xxFEAT_LAW_DOMAIN_POWER;
//const int   DOMAIN_SLIME        = xxFEAT_SLIME_DOMAIN_POWER;
//const int   DOMAIN_DARKNESS     = xxFEAT_DARKNESS_DOMAIN_POWER;
//const int   DOMAIN_DROW         = xxFEAT_DROW_DOMAIN_POWER;
//const int   DOMAIN_DWARF        = xxFEAT_DWARF_DOMAIN_POWER;
//const int   DOMAIN_UNDEATH      = xxFEAT_UNDEATH_DOMAIN_POWER;
//const int   DOMAIN_HALFLING     = xxFEAT_HALFLING_DOMAIN_POWER;
//const int   DOMAIN_HATRED       = xxFEAT_HATRED_DOMAIN_POWER;
//const int   DOMAIN_TYRANNY      = xxFEAT_TYRANNY_DOMAIN_POWER;
//const int   DOMAIN_ILLUSION     = xxFEAT_ILLUSION_DOMAIN_POWER;

// Feat Effects

const int SPELL_FEAT_DWD				=	6504;
const int SPELL_FEAT_SSAC				=	6520;
const int SPELL_FEAT_BCLARITY			=	6524;
const int SPELL_FEAT_DDP				=	6531;
const int SPELL_FEAT_SHADOW_BLADE		=	6843;

// Disciplines

const int DESERT_WIND		=	1;
const int DEVOTED_SPIRIT	=	2;
const int DIAMOND_MIND		=	3;
const int IRON_HEART		=	4;
const int SETTING_SUN		=	5;
const int SHADOW_HAND		=	6;
const int STONE_DRAGON		=	7;
const int TIGER_CLAW		=	8;
const int WHITE_RAVEN		=	9;

// Maneuvers and Stances

// Desert Wind

const int STRIKE_BLFLOURISH	=	1;		//Blistering Flourish
const int BOOST_BRNBLADE	=	2;		//Burning Blade
const int BOOST_BRNBRAND	=	3;		//Burning Brand
const int STRIKE_DTHMARK	=	4;		//Death Mark
const int STRIKE_DSRTTEMP	=	5;		//Desert Tempest
const int BOOST_DSTREMBER	=	6;		//Distracting Ember
const int STRIKE_DRGFLAME	=	7;		//Dragon's Flame
const int STRIKE_FANTHEFLM	=	8;		//Fan the Flames
const int STANCE_FRYASLT	=	9;		//Fiery Assautlt
const int COUNTER_FIRERPST	=	10;		//Fire Riposte
const int STRIKE_FIRESNAKE	=	11;		//Firesnake
const int STANCE_FLMSBLSS	=	12;		//Flame's Blessing
const int STRIKE_FLSHSUN	=	13;		//Flashing Sun
const int STRIKE_HTCHLFLM	=	14;		//Hatchling's Flame
const int STANCE_HOLOSTCLK	=	15;		//Holocost Cloak
const int BOOST_INFERNOBLD	=	16;		//Inferno Blade
const int STRIKE_INFERNOBLST=	17;		//Inferno Blast
const int COUNTER_LPNFLAME	=	18;		//Leaping Flame
const int STRIKE_LNGNINFRNO	=	19;		//Lingering Inferno
const int STRIKE_RNGOFFIRE	=	20;		//Ring of Fire
const int STANCE_RSNPHEONIX	=	21;		//Rising Pheonix
const int STRIKE_SLMDRCHRG	=	22;		//Salamander Charge
const int BOOST_SRNGBLD		=	23;		//Searing Blade
const int STRIKE_SRNGCHRG	=	24;		//Searing Charge
const int BOOST_WINDSTRIDE	=	25;		//Wind Stride
const int STRIKE_WYRMSFLAME	=	26;		//Wyrm's Flame
const int COUNTER_ZPHYRDNC	=	27;		//Zephyr Dance

// Devoted Spirit

const int STANCE_AURA_OF_CHAOS				=	28;
const int STANCE_AURA_OF_PERFECT_ORDER		=	29;
const int STANCE_AURA_OF_TRIUMPH			=	30;
const int STANCE_AURA_OF_TYRANNY			=	31;
const int STRIKE_CASTIGATING_STRIKE			=	32;
const int STRIKE_CRUSADERS_STRIKE			=	33;
const int STRIKE_DAUNTING_STRIKE			=	34;
const int BOOST_DEFENSIVE_REBUKE			=	35;
const int STRIKE_DIVINE_SURGE				=	36;
const int STRIKE_DIVINE_SURGE_GREATER		=	37;
const int STRIKE_DOOM_CHARGE				=	38;
const int STRIKE_ENTANGLING_BLADE			=	39;
const int STRIKE_FOEHAMMER					=	40;
const int STANCE_IMMORTAL_FORTITUDE			=	41;
const int STANCE_IRON_GUARDS_GLARE			=	42;
const int STRIKE_LAW_BEARER					=	43;
const int STANCE_MARTIAL_SPIRIT				=	44;
const int STRIKE_RADIANT_CHARGE				=	45;
const int STRIKE_RALLYING_STRIKE			=	46;
const int STRIKE_REVITALIZING_STRIKE		=	47;
const int COUNTER_SHIELD_BLOCK				=	48;
const int COUNTER_SHIELD_COUNTER			=	49;
const int STRIKE_OF_RIGHTEOUS_VITALITY		=	50;
const int STANCE_THICKET_OF_BLADES			=	51;
const int STRIKE_TIDE_OF_CHAOS				=	52;
const int STRIKE_VANGUARD_STRIKE			=	53;

// Diamond Mind

const int COUNTER_ACTION_BEFORE_THOUGHT		=	54;
const int STRIKE_AVALANCHE_OF_BLADES		=	55;
const int STRIKE_BOUNDING_ASSAULT			=	56;
const int COUNTER_DIAMOND_DEFENSE			=	57;
const int STRIKE_DNBLADE					=	58;
const int STRIKE_DISRUPTING_BLOW			=	59;
const int STRIKE_EMERALD_RAZOR				=	60;
const int STANCE_HEARING_THE_AIR			=	61;
const int STRIKE_INSIGHTFUL_STRIKE			=	62;
const int STRIKE_INSIGHTFUL_STRIKE_GREATER	=	63;
const int COUNTER_MIND_OVER_BODY			=	64;
const int STRIKE_MIND_STRIKE				=	65;
const int BOOST_MOMENT_OF_ALACRITY			=	66;
const int COUNTER_MOMENT_OF_PERFECT_MIND	=	67;
const int STANCE_PEARL_OF_BLACK_DOUBT		=	68;
const int BOOST_QUICKSILVER_MOTION			=	69;
const int COUNTER_RAPID_COUNTER				=	70;
const int STRIKE_RNBLADE					=	71;
const int STRIKE_SNBLADE					=	72;
const int STANCE_OF_ALACRITY				=	73;
const int STANCE_OF_CLARITY					=	74;
const int STRIKE_TIME_STANDS_STILL			=	75;

// Iron Heart

const int STANCE_ABSOLUTE_STEEL				=	76;
const int STRIKE_ADAMANTINE_HURRICANE		=	77;
const int STANCE_DANCING_BLADE_FORM			=	78;
const int STRIKE_DAZING_STRIKE				=	79;
const int STRIKE_DISARMING_STRIKE			=	80;
const int STRIKE_EXORCISM_OF_STEEL			=	81;
const int STRIKE_FINISHING_MOVE				=	82;
const int BOOST_IRON_HEART_ENDURANCE		=	83;
const int COUNTER_IRON_HEART_FOCUS			=	84;
const int STRIKE_IRON_HEART_SURGE			=	85;
const int COUNTER_LIGHTNING_RECOVERY		=	86;
const int STRIKE_LIGHTNING_THROW			=	87;
const int COUNTER_MANTICORE_PARRY			=	88;
const int STRIKE_MITHRAL_TORNADO			=	89;
const int STANCE_PUNISHING_STANCE			=	90;
const int BOOST_SCYTHING_BLADE				=	91;
const int STRIKE_STEEL_WIND					=	92;
const int STRIKE_STEELY_STRIKE				=	93;
const int STRIKE_OF_PERFECT_CLARITY			=	94;
const int STANCE_SUPREME_BLADE_PARRY		=	95;
const int COUNTER_WALL_OF_BLADES			=	96;

// Setting Sun

const int COUNTER_BAFFLING_DEFENSE			=	97;
const int STRIKE_BALLISTA_THROW				=	98;
const int STRIKE_CLEVER_POSITIONING			=	99;
const int STRIKE_COMET_THROW				=	100;
const int COUNTER_CHARGE					=	209;
const int STRIKE_DEVASTATING_THROW			=	101;
const int COUNTER_FEIGNED_OPENING			=	102;
const int COUNTER_FOOLS_STRIKE				=	103;
const int STANCE_GHOSTLY_DEFENSE			=	104;
const int STANCE_GIANT_KILLING_STYLE		=	105;
const int STRIKE_HYDRA_SLAYING_STRIKE		=	106;
const int STRIKE_MIGHTY_THROW				=	107;
const int COUNTER_MIRRORED_PURSUIT			=	108;
const int COUNTER_SCORPION_PARRY			=	109;
const int STANCE_SHIFTING_DEFENSE			=	110;
const int STRIKE_SOARING_THROW				=	111;
const int COUNTER_STALKING_SHADOW			=	112;
const int STANCE_STEP_OF_THE_WIND			=	113;
const int STRIKE_OF_THE_BROKEN_SHIELD		=	114;
const int STRIKE_TORNADO_THROW				=	115;

// Shadow Hand

const int STANCE_ASSNS_STANCE				=	116;
const int STANCE_BALANCE_SKY				=	117;
const int STRIKE_BLOODLETTING_STRIKE		=	118;
const int STANCE_CHILD_SHADOW				=	119;
const int STRIKE_CLINGING_SHADOW_STRIKE		=	120;
const int BOOST_CLOAK_OF_DECEPTION			=	121;
const int STANCE_DANCE_SPIDER				=	122;
const int STRIKE_DEATH_IN_THE_DARK			=	123;
const int STRIKE_DRAIN_VITALITY				=	124;
const int STRIKE_ENERVATING_SHADOW_STRIKE	=	125;
const int STRIKE_FSCIE_STRIKE				=	126;
const int STRIKE_GHOST_BLADE				=	127;
const int STRIKE_HAND_OF_DEATH				=	128;
const int STANCE_ISLAND_OF_BLADES			=	129;
const int STRIKE_OBSCURING_SHADOW_VEIL		=	130;
const int COUNTER_ONE_WITH_SHADOW			=	131;
const int STRIKE_SHADOW_BLADE_TECHNIQUE		=	132;
const int BOOST_SHADOW_BLINK				=	133;
const int STRIKE_SHADOW_GARROTE				=	134;
const int STRIKE_SHADOW_JAUNT				=	135;
const int STRIKE_SHADOW_NOOSE				=	136;
const int BOOST_SHADOW_STRIDE				=	137;
const int STRIKE_STALKER_IN_THE_NIGHT		=	138;
const int STANCE_DANCING_MOTH				=	139;
const int STRIKE_STRENGTH_DRAINING_STRIKE	=	140;

// Stone Dragon

const int STRIKE_ADAMANTINE_BONES				=	141;
const int STRIKE_ANCIENT_MOUNTAIN_HAMMER		=	142;
const int STRIKE_BONESPLITTING_STRIKE			=	143;
const int STRIKE_BONECRUSHER					=	144;
const int BOOST_BOULDER_ROLL					=	145;
const int STRIKE_CHARGING_MINOTAUR				=	146;
const int STRIKE_COLOSSUS_STRIKE				=	147;
const int STRIKE_CRUSHING_VISE					=	148;
const int STANCE_CRUSHING_WEIGHT_OF_THE_MOUNTAIN=	149;
const int STRIKE_EARTHSTRIKE_QUAKE				=	150;
const int STRIKE_ELDER_MOUNTAIN_HAMMER			=	151;
const int STANCE_GIANTS_STANCE					=	152;
const int STRIKE_IRON_BONES						=	153;
const int STRIKE_IRRESISTIBLE_MOUNTAIN_STRIKE	=	154;
const int BOOST_MOUNTAIN_AVALANCHE				=	155;
const int STRIKE_MOUNTAIN_HAMMER				=	156;
const int STRIKE_MOUNTAIN_TOMBSTONE_STRIKE		=	157;
const int STRIKE_OVERWHELMING_MOUNTAIN_STRIKE	=	158;
const int STANCE_ROOTS_OF_THE_MOUNTAIN			=	159;
const int STRIKE_STONE_BONES					=	160;
const int STRIKE_STONE_DRAGONS_FURY				=	161;
const int STRIKE_STONE_VISE						=	162;
const int STANCE_STONEFOOT_STANCE				=	163;
const int STANCE_STRENGTH_OF_STONE				=	164;

// Tiger Claw

const int STANCE_BLOOD_IN_THE_WATER			=	165;
const int STRIKE_CLAW_AT_THE_MOON			=	166;
const int BOOST_DANCING_MONGOOSE			=	167;
const int STRIKE_DEATH_FROM_ABOVE			=	168;
const int STRIKE_FERAL_DEATH_BLOW			=	169;
const int STRIKE_FLESH_RIPPER				=	170;
const int BOOST_FOUNTAIN_OF_BLOOD			=	171;
const int BOOST_GIRALLON_WINDMILL_FLESH_RIP	=	172;
const int STRIKE_HAMSTRING_ATTACK			=	173;
const int STANCE_HUNTERS_SENSE				=	174;
const int STANCE_LEAPING_DRAGON_STANCE		=	175;
const int STRIKE_POUNCING_CHARGE			=	176;
const int STANCE_PREY_ON_THE_WEAK			=	177;
const int STRIKE_RABID_BEAR_STRIKE			=	178;
const int STRIKE_RABID_WOLF_STRIKE			=	179;
const int BOOST_RAGING_MONGOOSE				=	180;
const int STRIKE_SOARING_RAPTOR_STRIKE		=	181;
const int BOOST_SUDDEN_LEAP					=	182;
const int STRIKE_SWOOPING_DRAGON_STRIKE		=	183;
const int STRIKE_WOLF_CLIMBS_THE_MOUNTAIN	=	184;
const int STRIKE_WOLF_FANG_STRIKE			=	185;
const int STANCE_WOLF_PACK_TACTICS			=	186;
const int STANCE_WOLVERINE_STANCE			=	187;

// White Raven

const int STRIKE_BATTLE_LEADERS_CHARGE		=	188;
const int STANCE_BOLSTERING_VOICE			=	189;
const int BOOST_CLARION_CALL				=	190;
const int BOOST_COVERING_STRIKE				=	191;
const int STRIKE_DOUSE_THE_FLAMES			=	192;
const int STRIKE_FLANKING_MANEUVER			=	193;
const int STRIKE_LEADING_THE_ATTACK			=	194;
const int STANCE_LEADING_THE_CHARGE			=	195;
const int BOOST_LIONS_ROAR					=	196;
const int BOOST_ORDER_FORGED_FROM_CHAOS		=	197;
const int STANCE_PRESS_THE_ADVANTAGE		=	198;
const int STANCE_SWARM_TACTICS				=	199;
const int STRIKE_SWARMING_ASSAULT			=	200;
const int STRIKE_TACTICAL_STRIKE			=	201;
const int STANCE_TACTICS_OF_THE_WOLF		=	202;
const int STRIKE_WAR_LEADERS_CHARGE			=	203;
const int STRIKE_WAR_MASTERS_CHARGE			=	204;
const int STRIKE_WHITE_RAVEN_HAMMER			=	205;
const int STRIKE_WHITE_RAVEN_STRIKE			=	206;
const int BOOST_WHITE_RAVEN_TACTICS			=	207;


/*
////
const int SPELLTOB_STRIKE_BLFLOURISH	=	-6001;		//Blistering Flourish
const int SPELLTOB_BOOST_BRNBLADE	=	-6002;		//Burning Blade
const int SPELLTOB_BOOST_BRNBRAND	=	-6003;		//Burning Brand
const int SPELLTOB_STRIKE_DTHMARK	=	-6004;		//Death Mark
const int SPELLTOB_STRIKE_DSRTTEMP	=	-6005;		//Desert Tempest
const int SPELLTOB_BOOST_DSTREMBER	=	-6006;		//Distracting Ember
const int SPELLTOB_STRIKE_DRGFLAME	=	-6007;		//Dragon's Flame
const int SPELLTOB_STRIKE_FANTHEFLM	=	-6008;		//Fan the Flames
const int SPELLTOB_STANCE_FRYASLT	=	-6009;		//Fiery Assautlt
const int SPELLTOB_COUNTER_FIRERPST	=	-6010;		//Fire Riposte
const int SPELLTOB_STRIKE_FIRESNAKE	=	-6011;		//Firesnake
const int SPELLTOB_STANCE_FLMSBLSS	=	-6012;		//Flame's Blessing
const int SPELLTOB_STRIKE_FLSHSUN	=	-6013;		//Flashing Sun
const int SPELLTOB_STRIKE_HTCHLFLM	=	-6014;		//Hatchling's Flame
const int SPELLTOB_STANCE_HOLOSTCLK	=	-6015;		//Holocost Cloak
const int SPELLTOB_BOOST_INFERNOBLD	=	-6016;		//Inferno Blade
const int SPELLTOB_STRIKE_INFERNOBLST=	-6017;		//Inferno Blast
const int SPELLTOB_COUNTER_LPNFLAME	=	-6018;		//Leaping Flame
const int SPELLTOB_STRIKE_LNGNINFRNO	=	-6019;		//Lingering Inferno
const int SPELLTOB_STRIKE_RNGOFFIRE	=	-6020;		//Ring of Fire
const int SPELLTOB_STANCE_RSNPHEONIX	=	-6021;		//Rising Pheonix
const int SPELLTOB_STRIKE_SLMDRCHRG	=	-6022;		//Salamander Charge
const int SPELLTOB_BOOST_SRNGBLD		=	-6023;		//Searing Blade
const int SPELLTOB_STRIKE_SRNGCHRG	=	-6024;		//Searing Charge
const int SPELLTOB_BOOST_WINDSTRIDE	=	-6025;		//Wind Stride
const int SPELLTOB_STRIKE_WYRMSFLAME	=	-6026;		//Wyrm's Flame
const int SPELLTOB_COUNTER_ZPHYRDNC	=	-6027;		//Zephyr Dance

// Devoted Spirit

const int SPELLTOB_STANCE_AURA_OF_CHAOS				=	-6028;
const int SPELLTOB_STANCE_AURA_OF_PERFECT_ORDER		=	-6029;
const int SPELLTOB_STANCE_AURA_OF_TRIUMPH			=	-6030;
const int SPELLTOB_STANCE_AURA_OF_TYRANNY			=	-6031;
const int SPELLTOB_STRIKE_CASTIGATING_STRIKE			=	-6032;
const int SPELLTOB_STRIKE_CRUSADERS_STRIKE			=	-6033;
const int SPELLTOB_STRIKE_DAUNTING_STRIKE			=	-6034;
const int SPELLTOB_BOOST_DEFENSIVE_REBUKE			=	-6035;
const int SPELLTOB_STRIKE_DIVINE_SURGE				=	-6036;
const int SPELLTOB_STRIKE_DIVINE_SURGE_GREATER		=	-6037;
const int SPELLTOB_STRIKE_DOOM_CHARGE				=	-6038;
const int SPELLTOB_STRIKE_ENTANGLING_BLADE			=	-6039;
const int SPELLTOB_STRIKE_FOEHAMMER					=	-6040;
const int SPELLTOB_STANCE_IMMORTAL_FORTITUDE			=	-6041;
const int SPELLTOB_STANCE_IRON_GUARDS_GLARE			=	-6042;
const int SPELLTOB_STRIKE_LAW_BEARER					=	-6043;
const int SPELLTOB_STANCE_MARTIAL_SPIRIT				=	-6044;
const int SPELLTOB_STRIKE_RADIANT_CHARGE				=	-6045;
const int SPELLTOB_STRIKE_RALLYING_STRIKE			=	-6046;
const int SPELLTOB_STRIKE_REVITALIZING_STRIKE		=	-6047;
const int SPELLTOB_COUNTER_SHIELD_BLOCK				=	-6048;
const int SPELLTOB_COUNTER_SHIELD_COUNTER			=	-6049;
const int SPELLTOB_STRIKE_OF_RIGHTEOUS_VITALITY		=	-6050;
const int SPELLTOB_STANCE_THICKET_OF_BLADES			=	-6051;
const int SPELLTOB_STRIKE_TIDE_OF_CHAOS				=	-6052;
const int SPELLTOB_STRIKE_VANGUARD_STRIKE			=	-6053;

// Diamond Mind

const int SPELLTOB_COUNTER_ACTION_BEFORE_THOUGHT		=	-6054;
const int SPELLTOB_STRIKE_AVALANCHE_OF_BLADES		=	-6055;
const int SPELLTOB_STRIKE_BOUNDING_ASSAULT			=	-6056;
const int SPELLTOB_COUNTER_DIAMOND_DEFENSE			=	-6057;
const int SPELLTOB_STRIKE_DNBLADE					=	-6058;
const int SPELLTOB_STRIKE_DISRUPTING_BLOW			=	-6059;
const int SPELLTOB_STRIKE_EMERALD_RAZOR				=	-6060;
const int SPELLTOB_STANCE_HEARING_THE_AIR			=	-6061;
const int SPELLTOB_STRIKE_INSIGHTFUL_STRIKE			=	-6062;
const int SPELLTOB_STRIKE_INSIGHTFUL_STRIKE_GREATER	=	-6063;
const int SPELLTOB_COUNTER_MIND_OVER_BODY			=	-6064;
const int SPELLTOB_STRIKE_MIND_STRIKE				=	-6065;
const int SPELLTOB_BOOST_MOMENT_OF_ALACRITY			=	-6066;
const int SPELLTOB_COUNTER_MOMENT_OF_PERFECT_MIND	=	-6067;
const int SPELLTOB_STANCE_PEARL_OF_BLACK_DOUBT		=	-6068;
const int SPELLTOB_BOOST_QUICKSILVER_MOTION			=	-6069;
const int SPELLTOB_COUNTER_RAPID_COUNTER				=	-6070;
const int SPELLTOB_STRIKE_RNBLADE					=	-6071;
const int SPELLTOB_STRIKE_SNBLADE					=	-6072;
const int SPELLTOB_STANCE_OF_ALACRITY				=	-6073;
const int SPELLTOB_STANCE_OF_CLARITY					=	-6074;
const int SPELLTOB_STRIKE_TIME_STANDS_STILL			=	-6075;

// Iron Heart

const int SPELLTOB_STANCE_ABSOLUTE_STEEL				=	-6076;
const int SPELLTOB_STRIKE_ADAMANTINE_HURRICANE		=	-6077;
const int SPELLTOB_STANCE_DANCING_BLADE_FORM			=	-6078;
const int SPELLTOB_STRIKE_DAZING_STRIKE				=	-6079;
const int SPELLTOB_STRIKE_DISARMING_STRIKE			=	-6080;
const int SPELLTOB_STRIKE_EXORCISM_OF_STEEL			=	-6081;
const int SPELLTOB_STRIKE_FINISHING_MOVE				=	-6082;
const int SPELLTOB_BOOST_IRON_HEART_ENDURANCE		=	-6083;
const int SPELLTOB_COUNTER_IRON_HEART_FOCUS			=	-6084;
const int SPELLTOB_STRIKE_IRON_HEART_SURGE			=	-6085;
const int SPELLTOB_COUNTER_LIGHTNING_RECOVERY		=	-6086;
const int SPELLTOB_STRIKE_LIGHTNING_THROW			=	-6087;
const int SPELLTOB_COUNTER_MANTICORE_PARRY			=	-6088;
const int SPELLTOB_STRIKE_MITHRAL_TORNADO			=	-6089;
const int SPELLTOB_STANCE_PUNISHING_STANCE			=	-6090;
const int SPELLTOB_BOOST_SCYTHING_BLADE				=	-6091;
const int SPELLTOB_STRIKE_STEEL_WIND					=	-6092;
const int SPELLTOB_STRIKE_STEELY_STRIKE				=	-6093;
const int SPELLTOB_STRIKE_OF_PERFECT_CLARITY			=	-6094;
const int SPELLTOB_STANCE_SUPREME_BLADE_PARRY		=	-6095;
const int SPELLTOB_COUNTER_WALL_OF_BLADES			=	-6096;

// Setting Sun

const int SPELLTOB_COUNTER_BAFFLING_DEFENSE			=	-6097;
const int SPELLTOB_STRIKE_BALLISTA_THROW				=	-6098;
const int SPELLTOB_STRIKE_CLEVER_POSITIONING			=	-6099;
const int SPELLTOB_STRIKE_COMET_THROW				=	-60100;
const int SPELLTOB_COUNTER_CHARGE					=	-6209;
const int SPELLTOB_STRIKE_DEVASTATING_THROW			=	-6101;
const int SPELLTOB_COUNTER_FEIGNED_OPENING			=	-6102;
const int SPELLTOB_COUNTER_FOOLS_STRIKE				=	-6103;
const int SPELLTOB_STANCE_GHOSTLY_DEFENSE			=	-6104;
const int SPELLTOB_STANCE_GIANT_KILLING_STYLE		=	-6105;
const int SPELLTOB_STRIKE_HYDRA_SLAYING_STRIKE		=	-6106;
const int SPELLTOB_STRIKE_MIGHTY_THROW				=	-6107;
const int SPELLTOB_COUNTER_MIRRORED_PURSUIT			=	-6108;
const int SPELLTOB_COUNTER_SCORPION_PARRY			=	-6109;
const int SPELLTOB_STANCE_SHIFTING_DEFENSE			=	-6110;
const int SPELLTOB_STRIKE_SOARING_THROW				=	-6111;
const int SPELLTOB_COUNTER_STALKING_SHADOW			=	-6112;
const int SPELLTOB_STANCE_STEP_OF_THE_WIND			=	-6113;
const int SPELLTOB_STRIKE_OF_THE_BROKEN_SHIELD		=	-6114;
const int SPELLTOB_STRIKE_TORNADO_THROW				=	-6115;

// Shadow Hand

const int SPELLTOB_STANCE_ASSNS_STANCE				=	-6116;
const int SPELLTOB_STANCE_BALANCE_SKY				=	-6117;
const int SPELLTOB_STRIKE_BLOODLETTING_STRIKE		=	-6118;
const int SPELLTOB_STANCE_CHILD_SHADOW				=	-6119;
const int SPELLTOB_STRIKE_CLINGING_SHADOW_STRIKE		=	-6120;
const int SPELLTOB_BOOST_CLOAK_OF_DECEPTION			=	-6121;
const int SPELLTOB_STANCE_DANCE_SPIDER				=	-6122;
const int SPELLTOB_STRIKE_DEATH_IN_THE_DARK			=	-6123;
const int SPELLTOB_STRIKE_DRAIN_VITALITY				=	-6124;
const int SPELLTOB_STRIKE_ENERVATING_SHADOW_STRIKE	=	-6125;
const int SPELLTOB_STRIKE_FSCIE_STRIKE				=	-6126;
const int SPELLTOB_STRIKE_GHOST_BLADE				=	-6127;
const int SPELLTOB_STRIKE_HAND_OF_DEATH				=	-6128;
const int SPELLTOB_STANCE_ISLAND_OF_BLADES			=	-6129;
const int SPELLTOB_STRIKE_OBSCURING_SHADOW_VEIL		=	-6130;
const int SPELLTOB_COUNTER_ONE_WITH_SHADOW			=	-6131;
const int SPELLTOB_STRIKE_SHADOW_BLADE_TECHNIQUE		=	-6132;
const int SPELLTOB_BOOST_SHADOW_BLINK				=	-6133;
const int SPELLTOB_STRIKE_SHADOW_GARROTE				=	-6134;
const int SPELLTOB_STRIKE_SHADOW_JAUNT				=	-6135;
const int SPELLTOB_STRIKE_SHADOW_NOOSE				=	-6136;
const int SPELLTOB_BOOST_SHADOW_STRIDE				=	-6137;
const int SPELLTOB_STRIKE_STALKER_IN_THE_NIGHT		=	-6138;
const int SPELLTOB_STANCE_DANCING_MOTH				=	-6139;
const int SPELLTOB_STRIKE_STRENGTH_DRAINING_STRIKE	=	-6140;

// Stone Dragon

const int SPELLTOB_STRIKE_ADAMANTINE_BONES				=	-6141;
const int SPELLTOB_STRIKE_ANCIENT_MOUNTAIN_HAMMER		=	-6142;
const int SPELLTOB_STRIKE_BONESPLITTING_STRIKE			=	-6143;
const int SPELLTOB_STRIKE_BONECRUSHER					=	-6144;
const int SPELLTOB_BOOST_BOULDER_ROLL					=	-6145;
const int SPELLTOB_STRIKE_CHARGING_MINOTAUR				=	-6146;
const int SPELLTOB_STRIKE_COLOSSUS_STRIKE				=	-6147;
const int SPELLTOB_STRIKE_CRUSHING_VISE					=	-6148;
const int SPELLTOB_STANCE_CRUSHING_WEIGHT_OF_THE_MOUNTAIN=	-6149;
const int SPELLTOB_STRIKE_EARTHSTRIKE_QUAKE				=	-6150;
const int SPELLTOB_STRIKE_ELDER_MOUNTAIN_HAMMER			=	-6151;
const int SPELLTOB_STANCE_GIANTS_STANCE					=	-6152;
const int SPELLTOB_STRIKE_IRON_BONES						=	-6153;
const int SPELLTOB_STRIKE_IRRESISTIBLE_MOUNTAIN_STRIKE	=	-6154;
const int SPELLTOB_BOOST_MOUNTAIN_AVALANCHE				=	-6155;
const int SPELLTOB_STRIKE_MOUNTAIN_HAMMER				=	-6156;
const int SPELLTOB_STRIKE_MOUNTAIN_TOMBSTONE_STRIKE		=	-6157;
const int SPELLTOB_STRIKE_OVERWHELMING_MOUNTAIN_STRIKE	=	-6158;
const int SPELLTOB_STANCE_ROOTS_OF_THE_MOUNTAIN			=	-6159;
const int SPELLTOB_STRIKE_STONE_BONES					=	-6160;
const int SPELLTOB_STRIKE_STONE_DRAGONS_FURY				=	-6161;
const int SPELLTOB_STRIKE_STONE_VISE						=	-6162;
const int SPELLTOB_STANCE_STONEFOOT_STANCE				=	-6163;
const int SPELLTOB_STANCE_STRENGTH_OF_STONE				=	-6164;

// Tiger Claw

const int SPELLTOB_STANCE_BLOOD_IN_THE_WATER			=	-6165;
const int SPELLTOB_STRIKE_CLAW_AT_THE_MOON			=	-6166;
const int SPELLTOB_BOOST_DANCING_MONGOOSE			=	-6167;
const int SPELLTOB_STRIKE_DEATH_FROM_ABOVE			=	-6168;
const int SPELLTOB_STRIKE_FERAL_DEATH_BLOW			=	-6169;
const int SPELLTOB_STRIKE_FLESH_RIPPER				=	-6170;
const int SPELLTOB_BOOST_FOUNTAIN_OF_BLOOD			=	-6171;
const int SPELLTOB_BOOST_GIRALLON_WINDMILL_FLESH_RIP	=	-6172;
const int SPELLTOB_STRIKE_HAMSTRING_ATTACK			=	-6173;
const int SPELLTOB_STANCE_HUNTERS_SENSE				=	-6174;
const int SPELLTOB_STANCE_LEAPING_DRAGON_STANCE		=	-6175;
const int SPELLTOB_STRIKE_POUNCING_CHARGE			=	-6176;
const int SPELLTOB_STANCE_PREY_ON_THE_WEAK			=	-6177;
const int SPELLTOB_STRIKE_RABID_BEAR_STRIKE			=	-6178;
const int SPELLTOB_STRIKE_RABID_WOLF_STRIKE			=	-6179;
const int SPELLTOB_BOOST_RAGING_MONGOOSE				=	-6180;
const int SPELLTOB_STRIKE_SOARING_RAPTOR_STRIKE		=	-6181;
const int SPELLTOB_BOOST_SUDDEN_LEAP					=	-6182;
const int SPELLTOB_STRIKE_SWOOPING_DRAGON_STRIKE		=	-6183;
const int SPELLTOB_STRIKE_WOLF_CLIMBS_THE_MOUNTAIN	=	-6184;
const int SPELLTOB_STRIKE_WOLF_FANG_STRIKE			=	-6185;
const int SPELLTOB_STANCE_WOLF_PACK_TACTICS			=	-6186;
const int SPELLTOB_STANCE_WOLVERINE_STANCE			=	-6187;

// White Raven

const int SPELLTOB_STRIKE_BATTLE_LEADERS_CHARGE		=	-6188;
const int SPELLTOB_STANCE_BOLSTERING_VOICE			=	-6189;
const int SPELLTOB_BOOST_CLARION_CALL				=	-6190;
const int SPELLTOB_BOOST_COVERING_STRIKE				=	-6191;
const int SPELLTOB_STRIKE_DOUSE_THE_FLAMES			=	-6192;
const int SPELLTOB_STRIKE_FLANKING_MANEUVER			=	-6193;
const int SPELLTOB_STRIKE_LEADING_THE_ATTACK			=	-6194;
const int SPELLTOB_STANCE_LEADING_THE_CHARGE			=	-6195;
const int SPELLTOB_BOOST_LIONS_ROAR					=	-6196;
const int SPELLTOB_BOOST_ORDER_FORGED_FROM_CHAOS		=	-6197;
const int SPELLTOB_STANCE_PRESS_THE_ADVANTAGE		=	-6198;
const int SPELLTOB_STANCE_SWARM_TACTICS				=	-6199;
const int SPELLTOB_STRIKE_SWARMING_ASSAULT			=	-6200;
const int SPELLTOB_STRIKE_TACTICAL_STRIKE			=	-6201;
const int SPELLTOB_STANCE_TACTICS_OF_THE_WOLF		=	-6202;
const int SPELLTOB_STRIKE_WAR_LEADERS_CHARGE			=	-6203;
const int SPELLTOB_STRIKE_WAR_MASTERS_CHARGE			=	-6204;
const int SPELLTOB_STRIKE_WHITE_RAVEN_HAMMER			=	-6205;
const int SPELLTOB_STRIKE_WHITE_RAVEN_STRIKE			=	-6206;
const int SPELLTOB_BOOST_WHITE_RAVEN_TACTICS			=	-6207;
*/
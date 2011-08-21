/** @file
* @brief Include File for Warlock Invocations
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



//::///////////////////////////////////////////////
//:: Warlock Invocations Include
//:: NW_I0_INVOCATIONS
//:://////////////////////////////////////////////
/*
	Warlock Eldritch Essence & Blast Shape Invocations
	can be combined together (one of each) to modify
	the basic Eldritch Blast (Feat) behavior.
	Eldritch Essence Invocations apply extra effects to
	the target(s), whereas Blast Shape Invocations
	modify the # of targets affected.

	Internally, these combined invocations prioritize
	on the Blast Shape Invocations as the primary Spell.
	What this means is that the Blast Shape will always
	be the stored "Spell" in the UI, with the Essences
	being "Metamagics" that are applied to it.  This is
	because Blast Shapes control Ranges/AoE, and also so
	that only the Blast Shape Scripts need to worry about
	whether they have combined effects...
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 19, 2005
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox (BDF - OEI)
//:: Modified On: 6/29/06
//:: Modified the "Shape" functions to check for essences and create corresponding EffectVisualEffect
//:: Also modified the parameters of DoEldritchBlast, DoEldritchCombinedEffects, and DoEssenceXXX to recognize if they were called by "shapes"
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Necromancy"


//#include "_SCSpellHook"



// might need this one for some reason #include "ginc_debug"

const int STRREF_HELLFIRE_BONUS    		= 220796;  // Bonus Damage (Hellfire): ( in use )
const int STRREF_HELLFIRE_SHIELD_NAME   = 220779;  // Hellfire Shield ( in use )
const int STRREF_HELLFIRE_BLAST_NAME    = 220783;  // Hellfire Blast ( in use )
//const int STRREF_HELLFIRE_SHIELD_1 		= 220804;  //  drains  									REMOVED!!!
const int STRREF_HELLFIRE_FEEDBACK   = 220805;  // 's Constitution by 						CHANGED
const int STRREF_HELLFIRE_SHIELD_NO_CON = 233608; //Constitution isn't high enough to use Hellfire Shied.
//const int STRREF_HELLFIRE_SHIELD_START  = 220802;  //  is surrounded by an aura of hellfire.    REMOVED!!!
//const int STRREF_HELLFIRE_SHIELD_STOP   = 220803;  //  is no longer protected by hellfire.      REMOVED!!!
//const int STRREF_HELLFIRE_SHIELD_NO_CONST = 220806; // 's Constitution isn't high enough to use REMOVED!!!

// JWR-OEI: 09/24/2008 - Global Variable to track CON damage output
int nHellfireConDmg = 0;

// JWR - OEI 06/18/2008 -- Hellfire Warlock Damage Bonus functions
//void HellfireShieldFeedbackMsg(int x, int strref, object oCaster);
//void HellfireShieldFeedbackMsg(int nHellfireApplyConDmg, int strref, object oCaster);
//int IsHellfireBlastActive(object oCaster=OBJECT_SELF);
//int GetHellfireBlastDiceBonus(object oCaster=OBJECT_SELF);
//void PrintHellfireBonusMsg(int iDice);

/*
// JLR - OEI 07/20/05 -- Warlock Funcs
// Returns the highest level of Eldritch Blast available
int GetEldritchBlastLevel(object oCaster);

// Returns the base damage from the Eldritch Blast
int GetEldritchBlastDmg(object oCaster, object oTarget, int nAllowReflexSave, int nIgnoreResists, int nHalfDmg, int iTouch=1, int bCalledFromShape=FALSE, int iMetaMagic = -1 );

// Does the actual Eldritch Blast...returns TRUE if it succeeded (so can do secondary effects)
int DoEldritchBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nDmgType = DAMAGE_TYPE_MAGICAL, int nAllowReflexSave = FALSE, int nIgnoreResists = FALSE, int nHalfDmg = FALSE, int nVFX = VFX_BEAM_ELDRITCH, int iMetaMagic = -1);

// Does the Metamagic Combined Effects
int DoEldritchCombinedEffects(object oTarget, int bDoTouchTest = FALSE, int nAllowReflexSave = FALSE, int nHalfDmg = FALSE, int nIgnoreResists = FALSE, int iMetaMagic = -1 );
void DoEldritchCombinedEffectsWrapper(object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE);

// These do the Eldritch Essence Effects:
int  DoEssenceBeshadowedBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceBewitchingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceBrimstoneBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceDrainingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceFrightfulBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceHellrimeBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceNoxiousBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceUtterdarkBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceVitriolicBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
void RunEssenceBrimstoneBlastImpact(object oTarget, object oCaster, int nRoundsLeft, int iDC );
void RunEssenceVitriolicBlastImpact(object oTarget, object oCaster, int nRoundsLeft);
int  DoEssenceHinderingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int  DoEssenceBindingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);

// cmi_ code

int DoEssenceUndBaneBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int DoEssenceRepellBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);
int DoEssenceTempestBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1);


int DoShapeMetaDoom( object oCaster = OBJECT_SELF, int iMetaMagic = -1);

int SCGetWarlockSpellLevel();

// These do the Blast Shape Effects:
int DoShapeEldritchChain( object oCaster = OBJECT_SELF );
int DoShapeEldritchCone( object oCaster = OBJECT_SELF );
int DoShapeEldritchDoom( object oCaster = OBJECT_SELF );
int DoShapeEldritchSpear( object oCaster = OBJECT_SELF );
int DoShapeHideousBlow( object oCaster = OBJECT_SELF );
*/

//::///////////////////////////////////////////////
//:: Functions
//::///////////////////////////////////////////////

// -------------------------------------------------------------------
// Printes Hellfire message JWR-OEI
// -------------------------------------------------------------------
void HellfireShieldFeedbackMsg(int nHellfireApplyConDmg, int strref, object oCaster)
{
	// nerf to limit it to one per attack
	if ( CSLGetPreferenceSwitch("HellfireLimitToOnePerUse",FALSE) )
	{
		nHellfireApplyConDmg = 1;
	}
	// have to check if immune, if so, will apply damage
	//effect eConst = EffectAbilityDecrease(ABILITY_CONSTITUTION, nHellfireApplyConDmg );
	//eConst = SetEffectSpellId(eConst, -2); // set to invalid spell ID for stacking
	//ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConst, oCaster);
	
	string sLocalizedTextMsg = GetStringByStrRef( STRREF_HELLFIRE_FEEDBACK );
	string sLocalizedTextName = GetStringByStrRef( strref ); // is it hellfire blast or shield?
	string sName = GetName( oCaster );
	string sHellfireFeedbackMsg = "<c=tomato>" + sName + ": " + sLocalizedTextName + sLocalizedTextMsg + IntToString( nHellfireApplyConDmg )+ ". </c>";
	//	SendMessageToPC( oCaster, sHellfireFeedbackMsg );
	FloatingTextStringOnCreature(sHellfireFeedbackMsg, oCaster);
	
	int iOriginalCon = GetAbilityScore(oCaster, ABILITY_CONSTITUTION, FALSE);
	
	if ( ! GetIsImmune(oCaster, IMMUNITY_TYPE_ABILITY_DECREASE, oCaster ) )
	{
		SCApplyDeadlyAbilityDrainEffect( nHellfireApplyConDmg, ABILITY_CONSTITUTION, oCaster );
	}
	else if ( CSLGetPreferenceSwitch("HellfireForceDamageIfImmune",FALSE) )
	{
		// this means they are cheating
		int iDamage = ( GetHitDice( oCaster )*nHellfireApplyConDmg )/2 ;
	}
	
	// i've applied the damage no need to track any more
	nHellfireConDmg = 0;
}


// -------------------------------------------------------------------
// Prints the Hellfire Bonus if you have the HellfireEffect active JWR-OEI
// -------------------------------------------------------------------
void PrintHellfireBonusMsg(int iDice)
{
	string sLocalizedText = GetStringByStrRef( STRREF_HELLFIRE_BONUS );
	string sDiceBonus = " ("+IntToString(iDice)+"d6)";
	string sHellfireFeedbackMsg = "<c=tomato>" + sLocalizedText + " </c>"+sDiceBonus;
	SendMessageToPC( OBJECT_SELF, sHellfireFeedbackMsg );
}
// -------------------------------------------------------------------
// Returns the damage bonus provided by Hellfire Blast JWR-OEI
// -------------------------------------------------------------------
int GetHellfireBlastDiceBonus(object oCaster = OBJECT_SELF )
{
	return 2*GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, oCaster);
}

// -------------------------------------------------------------------
// Determines if Hellfire Blast is active JWR-OEI
// -------------------------------------------------------------------
int IsHellfireBlastActive(object oCaster = OBJECT_SELF)
{

	// check CON
	int nCurrCon = GetAbilityScore( oCaster, ABILITY_CONSTITUTION );
	int iActionMode = GetActionMode(oCaster, ACTION_MODE_HELLFIRE_BLAST);
	
	if (DEBUGGING >= 6) { CSLDebug(  "Testing Hellfire Blast Mode: "+IntToString(iActionMode), oCaster ); }
	
	if ( iActionMode )
	{
		if ( nCurrCon < 1 || GetIsImmune(oCaster, IMMUNITY_TYPE_ABILITY_DECREASE) )
		{
			SetActionMode(oCaster, ACTION_MODE_HELLFIRE_BLAST, 0);
			return FALSE;
		}
		//	PrettyDebug("Hellfire Mode Active!");
		return TRUE;
	}
	else
	{
		//	PrettyDebug("Hellfire Mode InActive!");
		return FALSE;	
	}
	return FALSE;
}

void SCWarlockAdjustMetamagic( object oCaster )
{
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABILITY_MAXIMIZE_ELDBLAST ) ) // GetHasSpell(SPELLABILITY_MAXIMIZE_ELDBLAST, oCaster)
	{
		SendMessageToPC(oCaster, "Maximizing Eldritch Blast");
		CSLAddLocalBit(oCaster, "HKTEMP_Spell_MetaMagic", METAMAGIC_EMPOWER);
	}
	
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABILITY_MAXIMIZE_ELDBLAST ) ) // GetHasSpell(SPELLABILITY_EMPOWER_ELDBLAST, oCaster)
	{
		SendMessageToPC(oCaster, "Empowering Eldritch Blast");
		CSLAddLocalBit(oCaster, "HKTEMP_Spell_MetaMagic", METAMAGIC_EMPOWER);
	}
}



void SCWarlockPostCast( object oCaster = OBJECT_SELF )
{
	// this cleans up the variables in case of a miss and then displays the messages saying that it was maximized or empowered
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABILITY_MAXIMIZE_ELDBLAST ) ) // GetHasSpell(SPELLABILITY_MAXIMIZE_ELDBLAST, oCaster)
	{
		SendMessageToPC(oCaster, "Maximizing Eldritch Blast");
	}
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABILITY_EMPOWER_ELDBLAST ) ) // GetHasSpell(SPELLABILITY_EMPOWER_ELDBLAST, oCaster)
	{
		SendMessageToPC(oCaster, "Empowering Eldritch Blast");
	}

}


int SCGetWarlockSpellLevel()
{
	int iEffectiveSpellLevel = 1; // blasts are always level 1 regardless
	int iSpellId = GetSpellId();
	int iMetaMagic = HkGetMetaMagicFeat();
	if      (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)   { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 3 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)   { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)    { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 8 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST)  { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)    { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 7 ); }
	
	else if (iMetaMagic & METAMAGIC_INVOC_UNDBANE_BLAST)    { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 3 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_REPELL_BLAST)     { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if (iMetaMagic & METAMAGIC_INVOC_TEMPEST_BLAST)    { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	
	if ( iSpellId == SPELLABILITY_DREAD_SEIZURE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELLABILITY_HIDEOUS_BLOW_IMPACT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 1 ); }
	else if ( iSpellId == SPELLABILITY_HINDERING_BLAST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELLABILITY_OTHERWORLDLY_WHISPERS ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_BEGUILING_INFLUENCE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_BREATH_OF_NIGHT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 0 ); }
	else if ( iSpellId == SPELL_I_CHARM ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_CHILLING_TENTACLES ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 5 ); }
	else if ( iSpellId == SPELL_I_CURSE_OF_DESPAIR ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_DARKNESS ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_DARK_PREMONITION ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 9 ); }
	else if ( iSpellId == SPELL_I_DARK_ONES_OWN_LUCK ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_DEVILS_SIGHT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_DEVOUR_MAGIC ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if ( iSpellId == SPELL_I_ELDRITCH_CHAIN ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_ELDRITCH_CONE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 5 ); }
	else if ( iSpellId == SPELL_I_ELDRITCH_DOOM ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 8 ); }
	else if ( iSpellId == SPELL_I_ELDRITCH_SPEAR ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_ENTROPIC_WARDING ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_FLEE_THE_SCENE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_HIDEOUS_BLOW ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 1 ); }
	else if ( iSpellId == SPELL_I_LEAPS_AND_BOUNDS ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_PATH_OF_SHADOW ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if ( iSpellId == SPELL_I_RETRIBUTIVE_INVISIBILITY ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if ( iSpellId == SPELL_I_SEE_THE_UNSEEN ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_TENACIOUS_PLAGUE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if ( iSpellId == SPELL_I_THE_DEAD_WALK ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_UTTERDARK_BLAST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 8 ); }
	else if ( iSpellId == SPELL_I_VOIDSENSE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_VORACIOUS_DISPELLING ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_WALK_UNSEEN ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	else if ( iSpellId == SPELL_I_WALL_OF_PERILOUS_FLAME ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 5 ); }
	else if ( iSpellId == SPELL_I_WORD_OF_CHANGING ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 5 ); }
	
	else if ( iSpellId == SPELL_I_DARKFORESIGHT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 9 ); }
	else if ( iSpellId == SPELL_I_CASTERS_LAMENT ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 8 ); }
	else if ( iSpellId == SPELL_I_CAUSTIC_MIRE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_FRIGHTFUL_PRESENCE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 3 ); }
	else if ( iSpellId == SPELL_I_HELLSPAWNGRACE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if ( iSpellId == SPELL_I_IGNOREPYRE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == Instill_Vulnerability ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 7 ); }
	else if ( iSpellId == SPELL_I_REPELL_BLAST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 6 ); }
	else if ( iSpellId == SPELL_I_TEMPEST_BLAST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 4 ); }
	else if ( iSpellId == SPELL_I_UNDEADBANEBLST ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 3 ); }
	else if ( iSpellId == SPELL_Eldritch_Glaive ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 2 ); }
	/* assuming already dealt with these
	SPELLABILITY_BINDING_BLAST
	SPELL_I_BESHADOWED_BLAST
	SPELL_I_BEWITCHING_BLAST
	SPELL_I_BRIMSTONE_BLAST
	SPELL_I_DRAINING_BLAST
	SPELL_I_FRIGHTFUL_BLAST
	SPELL_I_HELLRIME_BLAST
	SPELL_I_NOXIOUS_BLAST
	SPELL_I_VITRIOLIC_BLAST
	
	feat //else if ( iSpellId == SPELLABILITY_FIENDISH_RESILIENCE ) { iEffectiveSpellLevel = CSLGetMax( iEffectiveSpellLevel, 00 ); }
	
	*/
	return iEffectiveSpellLevel;
}


int GetInvocationSaveDC(object oCaster, int nInvocation = 0)
{
	//DC = 10 + (spell level) + (spellcaster's ability mod) + (spellcaster's feat bonuses)
	int iDC = 10;
	
	// iDC = iDC + HkGetCasterLevel(oCaster, CLASS_TYPE_WARLOCK) + GetAbilityModifier(ABILITY_CHARISMA, oCaster) + GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCaster);
	
	iDC = iDC + SCGetWarlockSpellLevel() + GetAbilityModifier(ABILITY_CHARISMA, oCaster) + GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCaster);
	
	if (nInvocation == 0 && GetHasFeat(FEAT_ABILITY_FOCUS_ELDRITCH_BLAST, oCaster))
	{
		iDC += 2;
	}
	if (nInvocation == 1 && GetHasFeat(FEAT_ABILITY_FOCUS_INVOCATIONS, oCaster))
	{
		iDC += 2;	
	}
	//int ()
	//int iDC = HkGetSpellSaveDC();
	return iDC;
}

// -------------------------------------------------------------------
// Returns the highest level of Eldritch Blast available
int GetEldritchBlastLevel(object oCaster)
{
	int nBlstLvl = 0;
	
	int nCasterLevel = HkGetSpellPower( oCaster, CLASS_TYPE_WARLOCK );//  GetWarlockCasterLevel(oCaster);
	if (nCasterLevel > 21)
	{
		nBlstLvl = ((nCasterLevel - 20) / 2) + 9;
	}
	else if (nCasterLevel > 10)
	{
		nBlstLvl = ((nCasterLevel - 8) / 3) + 5;
	}
	else
	{
		nBlstLvl = (nCasterLevel + 1) / 2;
	}
	/*
	if      (GetHasFeat(FEAT_ELDRITCH_BLAST_14, oCaster )) nBlstLvl = 14;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_13, oCaster )) nBlstLvl = 13;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_12, oCaster )) nBlstLvl = 12;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_11, oCaster )) nBlstLvl = 11;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_10, oCaster )) nBlstLvl = 10;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_9 , oCaster )) nBlstLvl =  9;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_8 , oCaster )) nBlstLvl =  8;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_7 , oCaster )) nBlstLvl =  7;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_6 , oCaster )) nBlstLvl =  6;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_5 , oCaster )) nBlstLvl =  5;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_4 , oCaster )) nBlstLvl =  4;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_3 , oCaster )) nBlstLvl =  3;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_2 , oCaster )) nBlstLvl =  2;
	else if (GetHasFeat(FEAT_ELDRITCH_BLAST_1 , oCaster )) nBlstLvl =  1;
	*/
	
	if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_1, oCaster) )
	{
		if      (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_10, oCaster)) nBlstLvl+=10;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_9 , oCaster)) nBlstLvl+= 9;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_8 , oCaster)) nBlstLvl+= 8;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_7 , oCaster)) nBlstLvl+= 7;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_6 , oCaster)) nBlstLvl+= 6;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_5 , oCaster)) nBlstLvl+= 5;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_4 , oCaster)) nBlstLvl+= 4;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_3 , oCaster)) nBlstLvl+= 3;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_2 , oCaster)) nBlstLvl+= 2;
		else if (GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_1 , oCaster)) nBlstLvl+= 1;
	}
	
	if (GetHasFeat(FEAT_PRACTICED_INVOKER,oCaster))
	{
		nBlstLvl += GetLocalInt(oCaster, "SC_sPracticedLevels"+IntToString(CLASS_TYPE_WARLOCK) )/2; // add in whatever practiced levels bonus they are getting, really could just make all this caster level based
	}

	object oNeck = GetItemInSlot(INVENTORY_SLOT_NECK, oCaster);
	if ( GetIsObjectValid(oNeck))
	{
		string sTag = GetStringLeft(GetTag(oNeck), 12);
		if ( sTag == "cmi_amulet01")
		{
			nBlstLvl++;		
		}
		else if ( sTag == "cmi_amulet02")
		{
			nBlstLvl += 2;
		}
	}
	
	// NOTE: Need to Add in Prestige "+1 Spellcasting" Bonuses here...
	return nBlstLvl;
}

// Returns the base damage from the Eldritch Blast
int GetEldritchBlastDmg(object oCaster, object oTarget, int nAllowReflexSave, int nIgnoreResists, int nHalfDmg, int iTouch=1, int bCalledFromShape=FALSE, int iMetaMagic = -1 )
{
	int nDmg = 0;
	
	
	
	// Note: Caster Lvl is /2 for purposes of Spell Resistance (done internally in code)
	if ( nIgnoreResists || !HkResistSpell(oCaster, oTarget))
	{   //Make SR Check
		int nDmgDice = GetEldritchBlastLevel(oCaster);
		int nBonusDice = 0; // default
       
		if ( iMetaMagic == -1)
		{
			int iMetaMagic = HkGetMetaMagicFeat();
		}
		
		if ( iMetaMagic & METAMAGIC_INVOC_UNDBANE_BLAST)
		{
			if ( CSLGetIsUndead(oTarget) )
			{
				nDmgDice += 2;
			}
		}
		
		// JWR-OEI 06/18/2008: Hellfire Warlock can modify this into "Hellfire Blast"
		//SpeakString("Checking to add Hellfire Damage:");
		if (IsHellfireBlastActive(oCaster))
		{ 
			nBonusDice = GetHellfireBlastDiceBonus(oCaster);
			PrintHellfireBonusMsg(nBonusDice);			
			nDmgDice = nDmgDice+nBonusDice;
		}
		
		//Maximize Eldritch Blast

		//if (GetLocalInt(oCaster, "MaxEldBlast"))
		//{
		//	nDmg = 6 * (nDmgDice);
		//}
		SCWarlockAdjustMetamagic( oCaster );
		nDmg = HkApplyMetamagicVariableMods(d6(nDmgDice), 6 * nDmgDice, iMetaMagic )+ HkGetWarlockBonus(oCaster);

		if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCaster))
		{
			nDmg += nDmg/2;
		}
		
		// nDmg = d6(nDmgDice) + HkGetWarlockBonus(oCaster);
		
		if (nHalfDmg)
		{
			nDmg = CSLGetMax(1, nDmg / 2);
		}
		
		if ( !bCalledFromShape || GetSpellId() == SPELL_I_ELDRITCH_SPEAR)
		{
			nDmg = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, nDmg, SC_TOUCHSPELL_RAY );
		}
		
		if (nAllowReflexSave)
		{ // Some Invocations allow chance to halve the damage
			nDmg = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nDmg, oTarget, GetInvocationSaveDC(oCaster, FALSE) );
		}
		
		//if (GetSpellId()==931)
		//{
		//	nDmg *= 2; // 931 = SPELL_I_HIDEOUS_BLOW_IMPACT
		//}
	}
	return nDmg;
}


int DoEldritchBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nDmgType = DAMAGE_TYPE_MAGICAL, int nAllowReflexSave = FALSE, int nIgnoreResists = FALSE, int nHalfDmg = FALSE, int nVFX = VFX_BEAM_ELDRITCH, int iMetaMagic = -1)
{
	// Default Blast w/no mods
	if ( iMetaMagic == -1)
	{
		int iMetaMagic = HkGetMetaMagicFeat();
	}
	int nHitVFX = VFX_INVOCATION_ELDRITCH_HIT;   // default is Edlritch
	int iTouch;
	
	if      (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)   { nHitVFX = VFX_INVOCATION_DRAINING_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)  { nHitVFX = VFX_INVOCATION_FRIGHTFUL_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST) { nHitVFX = VFX_INVOCATION_BESHADOWED_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)  { nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)   { nHitVFX = VFX_INVOCATION_HELLRIME_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST) { nHitVFX = VFX_INVOCATION_BEWITCHING_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)    { nHitVFX = VFX_INVOCATION_NOXIOUS_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)  { nHitVFX = VFX_INVOCATION_VITRIOLIC_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)  { nHitVFX = VFX_INVOCATION_UTTERDARK_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST)  { nHitVFX = VFX_INVOCATION_HINDERING_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)    { nHitVFX = VFX_INVOCATION_BINDING_HIT; }
	else if (iMetaMagic & METAMAGIC_INVOC_UNDBANE_BLAST )  { nHitVFX = VFX_INVOCATION_UTTERDARK_HIT; }
    else if (iMetaMagic & METAMAGIC_INVOC_REPELL_BLAST )   { nHitVFX = VFX_INVOCATION_BINDING_HIT; }
    else if (iMetaMagic & METAMAGIC_INVOC_TEMPEST_BLAST )  { nHitVFX = VFX_INVOCATION_BEWITCHING_HIT; }
    
	if (!bCalledFromShape)
	{// We only want to display the beam visual effect if the blast was NOT called from any of the Shape spells; otherwise, the shape will already have been displayed.
		effect eBeam = EffectBeam(nVFX, oCaster, BODY_NODE_HAND);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.0, -2); // make it an invalid spellid soas to not interfere with anything else
	}
	
	// JWR-OEI 06/18/2008: Hellfire Warlock can modify this into "Hellfire Blast"
	//	SpeakString("Checking to do Con Damage");
	if ( IsHellfireBlastActive( oCaster ) && 
	(GetObjectType(oTarget)==OBJECT_TYPE_CREATURE && 
	oTarget != OBJECT_SELF && 
	GetIsReactionTypeHostile(oTarget)))
	{
		if (!bCalledFromShape)
		{
			// we're not called from a shape so this is just a regular eldritch blast
			nHellfireConDmg = 1;
			HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, oCaster);
		}
		else
		{
			// we are called from a shape, so we're gonna display output later.
			// SpeakString("Incrementing Con Counter ("+IntToString(nHellfireConDmg)+") Name: "+GetName(oTarget));
			nHellfireConDmg++;
		}
	}	

	
	int nTouchAttack = TOUCH_ATTACK_RESULT_HIT;
	
	if (bDoTouchTest) //These are all ranged
	{
		int iBonus = 0;
		if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCaster)) 
		{
			iBonus += 2;
		}
		object oScepter = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		if (GetIsObjectValid(oScepter) && (GetTag(oScepter) == "cmi_wlkscptr01"))
		{
			iBonus += 2;
		}
		
		
		if (CSLGetHasEffectType(oCaster, EFFECT_TYPE_POLYMORPH))
		{
			if (!GetHasFeat(FEAT_GUTTURAL_INVOCATIONS, oCaster))
			{
				iBonus -= 20;
				SendMessageToPC(oCaster,"You are exploiting the casting of spells while polymorphed without the Guttural Invocations feat. Your touch attack has been penalized 20 points.");			
			}				
		}
	
		if (GetActionMode(oCaster, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) == TRUE)
		{
			iBonus -= 6;
		}
		else if (GetActionMode(oCaster, ACTION_MODE_COMBAT_EXPERTISE) == TRUE)
		{
			iBonus -= 3;
		}
		
		nTouchAttack = CSLTouchAttackRanged(oTarget, TRUE, iBonus, TRUE);
		if (GetLocalInt(oCaster, "NW_EB_TOUCH_RESULT"))
		{
			SetLocalInt(oCaster, "NW_EB_TOUCH_RESULT", nTouchAttack); //collect only when requested
		}
		if (nTouchAttack==TOUCH_ATTACK_RESULT_MISS)
		{ // Failed
			if (oTarget != oCaster)
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
			}
			return FALSE;
		}
	}
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		int nDmg = GetEldritchBlastDmg(oCaster, oTarget, nAllowReflexSave, nIgnoreResists, nHalfDmg, nTouchAttack);
		if (nDmg)
		{  // Make sure wasn't resisted
			if (oTarget != oCaster)
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
			}
			effect eDam = EffectDamage(nDmg, nDmgType);
			effect eVis = EffectVisualEffect(nHitVFX);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
			DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			return TRUE;
		}
		else
		{
			if (oTarget != oCaster)
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE ));
			}
		}
	}
	/* @todo need to verify i need these, or if i can use my own systems for this */
	
	return FALSE;
}



int DoEssenceDrainingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_DRAINING_RAY))
	{
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oCaster, FALSE)))
			{
				CSLUnstackSpellEffects(oTarget, SPELL_I_DRAINING_BLAST);
				effect eSlow = EffectVisualEffect(VFX_IMP_SLOW);
				eSlow = EffectLinkEffects(eSlow, EffectSlow());
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, 6.0, SPELL_I_DRAINING_BLAST);
				return TRUE;
			}
		}
	}
	return FALSE;
}

int DoEssenceFrightfulBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_FRIGHTFUL_RAY))
	{
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) //(GetHitDice(oTarget) < 6) &&
		{
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oCaster, FALSE), SAVING_THROW_TYPE_FEAR))
			{
				// CSLUnstackSpellEffects(oTarget, SPELL_I_FRIGHTFUL_BLAST);
				effect eLink = EffectVisualEffect(VFX_DUR_SPELL_FEAR);
				eLink = EffectLinkEffects(eLink, EffectFrightened());
				eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS));
				eLink = EffectLinkEffects(eLink, EffectDamageDecrease(2));
				eLink = EffectLinkEffects(eLink, EffectAttackDecrease(2));
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10), SPELL_I_FRIGHTFUL_BLAST);
				return TRUE;
			}
		}
	}
	return FALSE;
}

int DoEssenceBeshadowedBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BESHADOWED_RAY))
	{
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, GetInvocationSaveDC(oCaster, FALSE)))
			{
				CSLUnstackSpellEffects(oTarget, SPELL_I_BESHADOWED_BLAST );
				effect eLink = EffectBlindness();
				eLink = EffectLinkEffects(eLink, EffectACDecrease(2));
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0, SPELL_I_BESHADOWED_BLAST);
				int nDex = GetAbilityScore(oTarget, ABILITY_DEXTERITY) - 10;
				if (nDex>0)
				{
					effect eDex = EffectAbilityDecrease( ABILITY_DEXTERITY, nDex);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, 6.0, SPELL_I_BESHADOWED_BLAST);
				}
				return TRUE;
			}
		}
	}
	return FALSE;
}

void RunEssenceBrimstoneBlastImpact(object oTarget, object oCaster, int nRoundsLeft, int iDC )
{
	if ( GetIsObjectValid(oTarget) && !GetIsDead(oTarget) && GetHasSpellEffect(SPELL_I_BRIMSTONE_BLAST, oTarget) )
	{
		//int iDC = SCGetDelayedSpellInfoSaveDC(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster);
		if (!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, SAVING_THROW_TYPE_FIRE))
		{
			int iBonus = HkGetWarlockBonus(oCaster);
			int nDmg = d6(iBonus)/2;
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg, DAMAGE_TYPE_FIRE), oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDmg, DAMAGE_TYPE_ACID), oTarget);
			nRoundsLeft = nRoundsLeft - 1;
			if (nRoundsLeft) 
			{
				DelayCommand(6.0, RunEssenceBrimstoneBlastImpact(oTarget, oCaster, nRoundsLeft, iDC ));   // Delay for one more round
			}
		}
	}
}

int DoEssenceBrimstoneBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	int nHasSpellEffect = GetHasSpellEffect(SPELL_I_BRIMSTONE_BLAST, oTarget); // SAVE THIS NOW SO IT WON'T AUTO FAIL LATER
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_FIRE, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BRIMSTONE_RAY))
	{
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if (nHasSpellEffect) return FALSE;
			int iDuration = HkGetSpellDuration(oCaster);
			int nRoundsLeft = CSLGetMax(1, iDuration / 4);
			int iDC = GetInvocationSaveDC(oCaster, FALSE );
			//SCSaveDelayedSpellInfo(SPELL_I_BRIMSTONE_BLAST, oTarget, oCaster, iDC);
			effect eVFX = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_FIRE));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, RoundsToSeconds(nRoundsLeft), SPELL_I_BRIMSTONE_BLAST);
			DelayCommand(6.0, RunEssenceBrimstoneBlastImpact(oTarget, oCaster, nRoundsLeft, iDC ));   // First check should be one round after the blast hit

			return TRUE;
		}
	}
	return FALSE;
}

int DoEssenceHellrimeBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_COLD, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_HELLRIME_RAY))
	{
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, GetInvocationSaveDC(oCaster, FALSE)))
			{
				CSLUnstackSpellEffects(oTarget, SPELL_I_HELLRIME_BLAST );
				effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, RoundsToSeconds(10), SPELL_I_HELLRIME_BLAST);
				return TRUE;
			}
		}
	}
	return FALSE;
}

int DoEssenceBewitchingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1)
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BEWITCHING_RAY)) {
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oCaster, FALSE), SAVING_THROW_TYPE_MIND_SPELLS))
			{
				// CSLUnstackSpellEffects(oTarget, GetSpellId());
				effect eLink = EffectVisualEffect(VFX_DUR_SPELL_CONFUSION);
				eLink = EffectLinkEffects(eLink, EffectConfused());
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0, SPELL_I_BEWITCHING_BLAST);
				return TRUE;
			}
		}
	}
	return FALSE;
}

int DoEssenceNoxiousBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1)
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_NOXIOUS_RAY)) {
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, GetInvocationSaveDC(oCaster, FALSE)))
			{
				//CSLUnstackSpellEffects(oTarget, GetSpellId());
				effect eLink = EffectVisualEffect(VFX_DUR_SPELL_DAZE);
				eLink = EffectLinkEffects(eLink, EffectDazed());
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 60.0, SPELL_I_NOXIOUS_BLAST);
				return TRUE;
			}
		}
	}
	return FALSE;
}


// This here needs some work, there is no spell id, stacking is an issue, needs to be done just once per round
// need to get teh VFX work corrected i think, if no VFX then exit out
// Don't need to track the duration either, but that might help deal with some bugs to leave it as is.
void RunEssenceVitriolicBlastImpact(object oTarget, object oCaster, int nRoundsLeft)
{
	if ( GetIsObjectValid(oTarget) && !GetIsDead(oTarget) && nRoundsLeft > 0 && GetHasSpellEffect(SPELL_I_VITRIOLIC_BLAST, oTarget) )
	{
		int iBonus = HkGetWarlockBonus(oCaster);
		int nDmg = d6(2) + iBonus;
		effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_ACID);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
		nRoundsLeft = nRoundsLeft - 1;
		DelayCommand(RoundsToSeconds(1), RunEssenceVitriolicBlastImpact(oTarget, oCaster, nRoundsLeft));   // Delay for one more round
	} 
}

int DoEssenceVitriolicBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1)
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_ACID, nAllowReflexSave, TRUE, nHalfDmg, VFX_INVOCATION_VITRIOLIC_RAY))
	{
		if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
		{
			int iDC = GetInvocationSaveDC(oCaster, FALSE);

			if (GetHasSpellEffect(SPELL_I_VITRIOLIC_BLAST, oTarget))
			{
				return FALSE;
			}
			
			int iCasterLevel = HkGetSpellPower( oCaster, CLASS_TYPE_WARLOCK );
			int nRoundsLeft = iCasterLevel / 4;
			
			// apply a VFX so we can make sure the effect persists on the target
			effect eDur = ExtraordinaryEffect( EffectVisualEffect( VFX_DUR_SPELL_MELFS_ACID_ARROW ) );
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nRoundsLeft), SPELL_I_VITRIOLIC_BLAST );
			
			DelayCommand(6.0, RunEssenceVitriolicBlastImpact(oTarget, oCaster, nRoundsLeft)); // First check should be one round after the blast hit
			return TRUE;
		}
	}
	return FALSE;
}

int DoEssenceUtterdarkBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_NEGATIVE, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_UTTERDARK_RAY))
	{
		if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, GetInvocationSaveDC(oCaster, FALSE)))
		{
			//CSLUnstackSpellEffects(oTarget, SPELL_I_UTTERDARK_BLAST ); // this should stack the draining
			//effect eVis = EffectVisualEffect(VFX_DUR_SPELL_ENERGY_DRAIN);
			//eDrain = SupernaturalEffect(EffectLinkEffects(eDrain, EffectNegativeLevel(2)));
			
			
			int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
			SCApplyDeadlyAbilityLevelEffect( 2, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oCaster, iSneakDamage );
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_SPELL_ENERGY_DRAIN), oTarget);
			
			//iDamage = nDrain * CSLGetHPPerLevel(oTarget);
			//if ( iDamage > GetCurrentHitPoints(oTarget) )
			//{
			//	iDamage = GetCurrentHitPoints(oTarget)-d4();
			//}
			
			//if ( iDamage > 0 )
			//{
			//	ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE) , oTarget );
			//}
			
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget, 0.0, -2); // makes it invalid spellid as well // SPELL_I_UTTERDARK_BLAST
			return TRUE;
		}
	}
	return FALSE;
}

int DoEssenceHinderingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_HINDERING_RAY))
	{
		if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oCaster, FALSE) ))
		{
			CSLUnstackSpellEffects(oTarget, SPELLABILITY_HINDERING_BLAST );
			effect eLink = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
			eLink = EffectLinkEffects(eLink, EffectSlow());
			eLink = SupernaturalEffect(eLink);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1), SPELLABILITY_HINDERING_BLAST );
			return TRUE;
		}
	}
	return FALSE;
}

int DoEssenceBindingBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	if (DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BINDING_RAY))
	{
		if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oCaster, FALSE) ))
		{
			CSLUnstackSpellEffects(oTarget, SPELLABILITY_BINDING_BLAST);
			effect eLink = EffectVisualEffect(VFX_DUR_STUN);
			eLink = EffectLinkEffects(eLink, EffectStunned());
			eLink = SupernaturalEffect(eLink);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1), SPELLABILITY_BINDING_BLAST);
			return TRUE;
		}
	}
	return FALSE;
}



int DoEssenceUndBaneBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	// First, do Base Effects:
	DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_UTTERDARK_RAY, iMetaMagic);
	return TRUE;
}


int DoEssenceRepellBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1)
{
	// First, do Base Effects:
	if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BINDING_RAY, iMetaMagic) )
	{
		// Additional Effects: (Dex Penalty)
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{
			//Make SR Check
			if(!HkResistSpell(oCaster, oTarget))
			{
				if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, GetInvocationSaveDC(OBJECT_SELF, FALSE)))
				{
					float fDuration = 4.0f;

					effect eKD = EffectKnockdown();
					//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
					//effect eVis = EffectVisualEffect( VFX_INVOCATION_HELLRIME_HIT );	// handled by DoEldritchBlast()
				// effect eLink = EffectLinkEffects(eDex, eDur);
					eKD = SetEffectSpellId(eKD, SPELL_I_REPELL_BLAST); //needed to keep different essences stack, if using same shape

					// Spell Effects not allowed to stack...
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_I_REPELL_BLAST );

					//Apply the effect and VFX impact
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKD, oTarget, fDuration);
					//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
					return TRUE;
				}
			}
		}
	}
	return FALSE;
}

int DoEssenceTempestBlast(object oCaster, object oTarget, int bCalledFromShape = FALSE, int bDoTouchTest = TRUE, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE, int iMetaMagic = -1 )
{
	// First, do Base Effects:
	if ( DoEldritchBlast(oCaster, oTarget, bCalledFromShape, bDoTouchTest, DAMAGE_TYPE_ELECTRICAL, nAllowReflexSave, FALSE, nHalfDmg, VFX_INVOCATION_BINDING_RAY, iMetaMagic) )
	{
		// Additional Effects: (Dex Penalty)
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{
			if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, GetInvocationSaveDC(oCaster, FALSE)))
			{
				float fDuration = RoundsToSeconds(1);

				effect eDaze = EffectDazed();
				eDaze = SetEffectSpellId(eDaze, SPELL_I_TEMPEST_BLAST); //needed to keep different essences stack, if using same shape
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_I_TEMPEST_BLAST );
				//Apply the effect and VFX impact
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDuration);
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by DoEldritchBlast()
				return TRUE;
			}
		}
	}
	return FALSE;
}


int DoEldritchCombinedEffects(object oTarget, int bDoTouchTest = FALSE, int nAllowReflexSave = FALSE, int nHalfDmg = FALSE, int nIgnoreResists = FALSE, int iMetaMagic = -1 )
{
	if ( iMetaMagic == -1 )
	{
		iMetaMagic = HkGetMetaMagicFeat();
	}
	if      (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)   { return DoEssenceDrainingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)  { return DoEssenceFrightfulBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST) { return DoEssenceBeshadowedBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)  { return DoEssenceBrimstoneBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)   { return DoEssenceHellrimeBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST) { return DoEssenceBewitchingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)    { return DoEssenceNoxiousBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)  { return DoEssenceVitriolicBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)  { return DoEssenceUtterdarkBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST)  { return DoEssenceHinderingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)    { return DoEssenceBindingBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_UNDBANE_BLAST )   { return DoEssenceUndBaneBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_REPELL_BLAST )    { return DoEssenceRepellBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_TEMPEST_BLAST )   { return DoEssenceTempestBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, nAllowReflexSave, nHalfDmg, iMetaMagic); }
	else return DoEldritchBlast(OBJECT_SELF, oTarget, TRUE, bDoTouchTest, DAMAGE_TYPE_MAGICAL, nAllowReflexSave, nIgnoreResists, nHalfDmg, iMetaMagic);
}


//int METAMAGIC_ELDRITCH_SHAPES = (METAMAGIC_INVOC_ELDRITCH_SPEAR | METAMAGIC_INVOC_HIDEOUS_BLOW | METAMAGIC_INVOC_ELDRITCH_CHAIN | METAMAGIC_INVOC_ELDRITCH_CONE | METAMAGIC_INVOC_ELDRITCH_DOOM);




void DoEldritchCombinedEffectsWrapper(object oTarget, int nAllowReflexSave=FALSE, int nHalfDmg=FALSE)
{
	DoEldritchCombinedEffects(oTarget, FALSE, nAllowReflexSave, nHalfDmg);
}



int DoShapeEldritchSpear( object oCaster = OBJECT_SELF )
{
	object oTarget = HkGetSpellTarget();
	int iMetaMagic = HkGetMetaMagicFeat();
	if      (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)   { return DoEssenceDrainingBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)  { return DoEssenceFrightfulBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST) { return DoEssenceBeshadowedBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)  { return DoEssenceBrimstoneBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)   { return DoEssenceHellrimeBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST) { return DoEssenceBewitchingBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)    { return DoEssenceNoxiousBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)  { return DoEssenceVitriolicBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)  { return DoEssenceUtterdarkBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST)  { return DoEssenceHinderingBlast( OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)    { return DoEssenceBindingBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_UNDBANE_BLAST )   { return DoEssenceUndBaneBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_REPELL_BLAST )    { return DoEssenceRepellBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else if (iMetaMagic & METAMAGIC_INVOC_TEMPEST_BLAST )   { return DoEssenceTempestBlast(OBJECT_SELF, oTarget, FALSE, TRUE, FALSE, FALSE, iMetaMagic); }
	else                                                    { return DoEldritchBlast(OBJECT_SELF, oTarget, FALSE, TRUE); }
	return FALSE;
}



int DoShapeEldritchChain( object oCaster = OBJECT_SELF )
{
	
	int iCasterLevel = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK );// CSLGetMin(20, GetCasterLevel(oCaster));
	int nNumAffected = 0;
	int iMetaMagic = HkGetMetaMagicFeat();
	int nChain1VFX = VFX_INVOCATION_ELDRITCH_CHAIN; // default Chain1 is Eldritch
	int nChain2VFX = VFX_INVOCATION_ELDRITCH_CHAIN2;   // default Chain2 is Eldritch
	int nHitVFX = VFX_INVOCATION_ELDRITCH_HIT;   // default nHitVFX is Eldritch
	if (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_DRAINING_CHAIN;
		nChain2VFX = VFX_INVOCATION_DRAINING_CHAIN2;
		nHitVFX = VFX_INVOCATION_DRAINING_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_FRIGHTFUL_CHAIN;
		nChain2VFX = VFX_INVOCATION_FRIGHTFUL_CHAIN2;
		nHitVFX = VFX_INVOCATION_FRIGHTFUL_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_BESHADOWED_CHAIN;
		nChain2VFX = VFX_INVOCATION_BESHADOWED_CHAIN2;
		nHitVFX = VFX_INVOCATION_BESHADOWED_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_BRIMSTONE_CHAIN;
		nChain2VFX = VFX_INVOCATION_BRIMSTONE_CHAIN2;
		nHitVFX = VFX_INVOCATION_BRIMSTONE_HIT;
	}
	else if ( (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST) || (iMetaMagic & METAMAGIC_INVOC_TEMPEST_BLAST) )
	{
		nChain1VFX = VFX_INVOCATION_HELLRIME_CHAIN;
		nChain2VFX = VFX_INVOCATION_HELLRIME_CHAIN2;
		nHitVFX = VFX_INVOCATION_HELLRIME_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_BEWITCHING_CHAIN;
		nChain2VFX = VFX_INVOCATION_BEWITCHING_CHAIN2;
		nHitVFX = VFX_INVOCATION_BEWITCHING_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_NOXIOUS_CHAIN;
		nChain2VFX = VFX_INVOCATION_NOXIOUS_CHAIN2;
		nHitVFX = VFX_INVOCATION_NOXIOUS_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_VITRIOLIC_CHAIN;
		nChain2VFX = VFX_INVOCATION_VITRIOLIC_CHAIN2;
		nHitVFX = VFX_INVOCATION_VITRIOLIC_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_UTTERDARK_CHAIN;
		nChain2VFX = VFX_INVOCATION_UTTERDARK_CHAIN2;
		nHitVFX = VFX_INVOCATION_UTTERDARK_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_HINDERING_CHAIN;
		nChain2VFX = VFX_INVOCATION_HINDERING_CHAIN2;
		nHitVFX = VFX_INVOCATION_HINDERING_HIT;
	}
	else if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)
	{
		nChain1VFX = VFX_INVOCATION_BINDING_CHAIN;
		nChain2VFX = VFX_INVOCATION_BINDING_CHAIN2;
		nHitVFX = VFX_INVOCATION_BINDING_HIT;
	}
	effect eLightning = EffectBeam(nChain1VFX, oCaster, BODY_NODE_HAND);
	effect eVis = EffectVisualEffect(nHitVFX);
	object oFirstTarget = HkGetSpellTarget();
	object oHolder;
	object oTarget;
	location lSpellLocation;
//	SetLocalInt(oCaster, "NW_EB_TOUCH_RESULT", TOUCH_ATTACK_RESULT_HIT); //setting this to non-zero will trigger collecting touch attack success info from DoEldritchCombinedEffects
//	if (DoEldritchCombinedEffects(oFirstTarget))
//	{
//		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);
//	}

	int iBonus = 0;  // The_Puppeteer 1-14-10 Moved from below to here to support the use of CSLTouchAttackRanged for int iTouch.
	float fRadius = RADIUS_SIZE_COLOSSAL;
	if ( GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCaster) )
	{
		iBonus = 2;
		fRadius = fRadius * 2;
	}
	
	object oScepter = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCaster);
	if (GetIsObjectValid(oScepter) && (GetTag(oScepter) == "cmi_wlkscptr01"))
	{
		iBonus += 2;
	}
	
	if (CSLGetHasEffectType( OBJECT_SELF, EFFECT_TYPE_POLYMORPH ))
	{
		if (!GetHasFeat(FEAT_GUTTURAL_INVOCATIONS, OBJECT_SELF))
		{
			iBonus -= 20;
			SendMessageToPC(OBJECT_SELF,"You are exploiting the casting of spells while polymorphed without the Guttural Invocations feat. Your touch attack has been penalized 20 points.");			
		}				
	}
	
	if (GetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) == TRUE)
	{
		iBonus -= 6;
	}
	else if (GetActionMode(OBJECT_SELF, ACTION_MODE_COMBAT_EXPERTISE) == TRUE)
	{
		iBonus -= 3;
	}
//	int iTouch = GetLocalInt(oCaster, "NW_EB_TOUCH_RESULT");
//	DeleteLocalInt(oCaster, "NW_EB_TOUCH_RESULT");
	int iTouch = CSLTouchAttackRanged(oFirstTarget, TRUE, iBonus, TRUE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oFirstTarget, 0.5);
	if (iTouch==TOUCH_ATTACK_RESULT_MISS)
	{
		return FALSE; // Failed to hit 1st Target, end the chain
	}
	
	SetLocalInt(oCaster, "NW_EB_TOUCH_RESULT", TOUCH_ATTACK_RESULT_HIT); //setting this to non-zero will trigger collecting touch attack success info from DoEldritchCombinedEffects
	if (DoEldritchCombinedEffects(oFirstTarget))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);
	}


	// ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oFirstTarget, 0.5);
	DeleteLocalInt(oCaster, "NW_EB_TOUCH_RESULT");
	
	//if (iTouch==TOUCH_ATTACK_RESULT_MISS) 
	//{
	//	return FALSE; // Failed to hit 1st Target, end the chain
	//}
	
	float fDelay = 0.2;
	int nCnt = 0;
	int nMaxCnt = 1;
	if      (iCasterLevel >= 30) nMaxCnt = 6;
	else if (iCasterLevel >= 25) nMaxCnt = 5;
	else if (iCasterLevel >= 20) nMaxCnt = 4;
	else if (iCasterLevel >= 15) nMaxCnt = 3;
	else if (iCasterLevel >= 10) nMaxCnt = 2;
	
	
	
	
	
	
	eLightning = EffectBeam(nChain2VFX, oFirstTarget, BODY_NODE_CHEST);
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE );
	while (GetIsObjectValid(oTarget) && nCnt<nMaxCnt)
	{
		//Make sure the caster's faction is not hit and the first target is not hit
		if (oTarget != oFirstTarget && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster)
		{
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 0.5));
			iTouch = CSLTouchAttackRanged(oTarget, TRUE, iBonus, TRUE);
			if (iTouch==TOUCH_ATTACK_RESULT_MISS) return FALSE;
			DelayCommand(fDelay, DoEldritchCombinedEffectsWrapper(oTarget, FALSE, iTouch!=TOUCH_ATTACK_RESULT_CRITICAL || GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			oHolder = oTarget;
			eLightning = EffectBeam( nChain2VFX, oHolder, BODY_NODE_CHEST );
			fDelay = fDelay + 0.1f;
			if (!GetIsDead(oTarget))
			{
				nCnt++; // added the GetIsDead check to keep from cheating the player when corpses are hit, which were counting against the max count
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE);
	}
	if (IsHellfireBlastActive( oCaster ) && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, oCaster);
		nHellfireConDmg = 0;
	}
	
	/* should already be dealt with
	if (GetLocalInt(oCaster, "MaxEldBlast"))
	{
		SendMessageToPC(oCaster, "Maximizing Eldritch Blast");
	}
	if (GetLocalInt(oCaster, "EmpEldBlast"))
	{
		SendMessageToPC(oCaster, "Empowering Eldritch Blast");		
	}
	SetLocalInt(oCaster, "MaxEldBlast", 0);
	SetLocalInt(oCaster, "EmpEldBlast", 0);
	*/
		
	// this cleans up the variables in case of a miss
	SCWarlockPostCast(oCaster);
	return TRUE;
}

int DoShapeHideousBlow( object oCaster = OBJECT_SELF )
{
	object oTarget = HkGetSpellTarget();
	return DoEldritchCombinedEffects(oTarget, FALSE, FALSE, FALSE, TRUE);
}

int DoShapeEldritchCone( object oCaster = OBJECT_SELF )
{
	location lTargetLocation = GetSpellTargetLocation();
	int iMetaMagic = HkGetMetaMagicFeat();
	int nConeVFX = VFX_INVOCATION_ELDRITCH_CONE; // default cone is Eldritch
	if      (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)   { nConeVFX = VFX_INVOCATION_DRAINING_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)  { nConeVFX = VFX_INVOCATION_FRIGHTFUL_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST) { nConeVFX = VFX_INVOCATION_BESHADOWED_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)  { nConeVFX = VFX_INVOCATION_BRIMSTONE_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)   { nConeVFX = VFX_INVOCATION_HELLRIME_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST) { nConeVFX = VFX_INVOCATION_BEWITCHING_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)    { nConeVFX = VFX_INVOCATION_NOXIOUS_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)  { nConeVFX = VFX_INVOCATION_VITRIOLIC_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)  { nConeVFX = VFX_INVOCATION_UTTERDARK_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST)  { nConeVFX = VFX_INVOCATION_HINDERING_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)    { nConeVFX = VFX_INVOCATION_BINDING_CONE; }
	else if (iMetaMagic & METAMAGIC_INVOC_UNDBANE_BLAST )  { nConeVFX = VFX_INVOCATION_UTTERDARK_CONE; }
    else if (iMetaMagic & METAMAGIC_INVOC_REPELL_BLAST )   { nConeVFX = VFX_INVOCATION_BINDING_CONE; }
    else if (iMetaMagic & METAMAGIC_INVOC_TEMPEST_BLAST )  { nConeVFX = VFX_INVOCATION_BEWITCHING_CONE; }
	
	
	
	float fCone = RADIUS_SIZE_VAST; // was 11.0
    if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, OBJECT_SELF))	
	{
		fCone = fCone * 2;
	}
	
	effect eCone = EffectVisualEffect(nConeVFX);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, 1.0);
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fCone, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (oTarget!=OBJECT_SELF) DoEldritchCombinedEffects(oTarget, FALSE, TRUE);
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fCone, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	}
	if (IsHellfireBlastActive( oCaster ) && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}
	
	
	SCWarlockPostCast(oCaster);
	return TRUE;
}

int DoShapeEldritchDoom( object oCaster = OBJECT_SELF )
{
	int iMetaMagic = HkGetMetaMagicFeat();
	int nDoomVFX = VFX_INVOCATION_ELDRITCH_AOE;  // default Doom is Eldritch
	if      (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)  { nDoomVFX = VFX_INVOCATION_DRAINING_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST) { nDoomVFX = VFX_INVOCATION_FRIGHTFUL_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST){ nDoomVFX = VFX_INVOCATION_BESHADOWED_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST) { nDoomVFX = VFX_INVOCATION_BRIMSTONE_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)  { nDoomVFX = VFX_INVOCATION_HELLRIME_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST){ nDoomVFX = VFX_INVOCATION_BEWITCHING_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)   { nDoomVFX = VFX_INVOCATION_NOXIOUS_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST) { nDoomVFX = VFX_INVOCATION_VITRIOLIC_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST) { nDoomVFX = VFX_INVOCATION_UTTERDARK_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST) { nDoomVFX = VFX_INVOCATION_HINDERING_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)   { nDoomVFX = VFX_INVOCATION_BINDING_DOOM; }
	else if (iMetaMagic & METAMAGIC_INVOC_UNDBANE_BLAST )  { nDoomVFX = VFX_INVOCATION_UTTERDARK_DOOM; }
    else if (iMetaMagic & METAMAGIC_INVOC_REPELL_BLAST )   { nDoomVFX = VFX_INVOCATION_BINDING_DOOM; }
    else if (iMetaMagic & METAMAGIC_INVOC_TEMPEST_BLAST )  { nDoomVFX = VFX_INVOCATION_BEWITCHING_DOOM; }
	location lTarget = GetSpellTargetLocation();
	effect eExplode = EffectVisualEffect(nDoomVFX);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	while ( GetIsObjectValid(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF )
	{
		if ( !((iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST) && ( CSLGetIsUndead( oTarget )  ) ) )
		{
			DoEldritchCombinedEffects(oTarget, FALSE, TRUE);
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}	
	}
	if (IsHellfireBlastActive( oCaster ) && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}
	
	
	SCWarlockPostCast(oCaster);
	return TRUE;
}

int DoShapeMetaDoom( object oCaster = OBJECT_SELF, int iMetaMagic = -1)
{
	oCaster = OBJECT_SELF;
	int nDoomVFX = VFX_INVOCATION_ELDRITCH_AOE;	// default Doom is Eldritch

	// adjust the VFX according to the essence

	if ( iMetaMagic == METAMAGIC_INVOC_UNDBANE_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_UTTERDARK_DOOM; }
	else if ( iMetaMagic == METAMAGIC_INVOC_REPELL_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_BINDING_DOOM; }
	else if ( iMetaMagic == METAMAGIC_INVOC_TEMPEST_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_BEWITCHING_DOOM; }

	else if ( iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST ) 		{ nDoomVFX = VFX_INVOCATION_DRAINING_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_FRIGHTFUL_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST ) { nDoomVFX = VFX_INVOCATION_BESHADOWED_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_BRIMSTONE_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_HELLRIME_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST ) { nDoomVFX = VFX_INVOCATION_BEWITCHING_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_NOXIOUS_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_VITRIOLIC_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_UTTERDARK_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_HINDERING_DOOM; }
	else if ( iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST ) 	{ nDoomVFX = VFX_INVOCATION_BINDING_DOOM; }
		
	//Get the spell target location as opposed to the spell target.
	location lTarget = GetSpellTargetLocation();
	float fRadius = RADIUS_SIZE_HUGE;
    if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, OBJECT_SELF))	
	{
		fRadius = fRadius * 2;
	}
	// Visual on the Location itself...
	effect eExplode = EffectVisualEffect( nDoomVFX );
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

	//Declare the spell shape, size and the location. Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
		// Handle combined Eldritch Essence Effects, if any
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF )
		{
			DoEldritchCombinedEffects(oTarget, TRUE, FALSE, FALSE, iMetaMagic);
		}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	if (IsHellfireBlastActive( oCaster ) && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}

	SCWarlockPostCast(oCaster);
	return TRUE;
}















void DoEldritchGlaiveAnimations( object oPC  = OBJECT_SELF )
{
	int iMetaMagic = HkGetMetaMagicFeat();
	
	
	int bPlayAnim = TRUE; 
	//int CSLGetIsAShield( int nBase )
	// Checks if oPC has weapons equiped
	/*
	object oItemR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
	object oItemL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	
	if (GetIsObjectValid(oItemL))
    {
        if ( CSLGetIsAShield( GetBaseItemType(oItemL) ) )
        {
            bPlayAnim = FALSE;
        }
    }
    if ( GetIsObjectValid(oItemR ) )
    {
        bPlayAnim = FALSE;
    }
	*/
	if (bPlayAnim)
	{
		/*
		if ( iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )
		{
			effect eGlaiveConj = EffectVisualEffect(VFXSC_DUR_ELDGLAIVE_BRIM);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGlaiveConj , oPC , 3.0f);		
		}
	    else if ( iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST ) 
		{
			effect eGlaiveConj = EffectVisualEffect(VFXSC_DUR_ELDGLAIVE_HELL);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGlaiveConj , oPC , 3.0f);		
		}
	    else if ( iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )
		{
			effect eGlaiveConj = EffectVisualEffect(VFXSC_DUR_ELDGLAIVE_VITR);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGlaiveConj , oPC , 3.0f);		
		}
		else{		
			effect eGlaiveConj = EffectVisualEffect(VFXSC_DUR_ELDGLAIVE_ELDR);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGlaiveConj , oPC , 3.0f);
		}
		*/
		
		PlayCustomAnimation(oPC, "Glaive0"+IntToString(d4()), 0, 1.0);
						
	}
	else
	{
		
		
		//If oPC has weapons equiped
		// Plays standard animation & VFX
		PlayCustomAnimation(oPC, "cleave", 0, 1.0); // "def_conjure"
		//Standard Eldritch conjure	VFX
		//effect eEldrConj = EffectVisualEffect( VFXSC_DUR_ELDGLAIVE_CONJ );	
		//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEldrConj , oPC , 3.0f);
	}
}


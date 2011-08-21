/** @file
* @brief Include for Abjuration spells, Dispels and Breaches and other protective magic
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/




/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
//                     Notes
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
// Dispel Magic/Breach Override
/*
[quote="The DC to dispel an effect is calculated as"][code]Effect DC = 70 + AbjurationDefenseBonus(3) + CreatorLevel + CreatorStatBonus[/code][/quote]
[quote="The Caster roll to beat this DC is calculated as"][code]Caster Roll = d100() + AdjurationFocuses(3-6) + CasterLevel + CasterStatBonus - 5 * (9-DispelLevel)[/code][/quote]
[quote="# Effects Dispelled by Spell"][code]
Spell                Single  AoE  Lvl  Special
Lesser Pilfer Magic    1     -    3    +2 AB /+2 Saves for 10 rounds
Lesser Dispel          4     1    3
Dispel                 6     2    5
Pilfer Magic           1     -    5    +3 AB /+3 Saves for 10 rounds
Voracious Dispel       4     -    5    Target takes 3 Dam/Spell Lvl Removed
Greater Dispel         8     3    7
Greater Pilfer Magic   1     -    7    +4 AB /+4 Saves for 10 rounds
Devour Magic           6     -    8    Caster gains +3 HP/Spell Lvl Removed
Mord's                12     4    9[/code][/quote]


[quote="Breach targets the following spells (in this order)"]Greater Spell Mantle

* Spell Resistance
[quote="*"]These spells have been added to the breach list in DEX. The Caster must beat the above Dispel DC roll for the protection to be breached.[/quote]
[/quote]

If you have recommendations for new NWN2 spells that should be on this list, please post your suggestions below.
*/

/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
//                     Includes
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
#include "_CSLCore_Magic"
#include "_HkSpell"
#include "_SCInclude_Doors"
#include "_SCInclude_Evocation"
#include "_SCInclude_Invocations"

/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
//                     Constants
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
const int BREACH_SPELL_COUNT = 44;

int SC_DISPEL_FAILED = 0;
int SC_DISPEL_REMOVED = 1;
int SC_DISPEL_REMOVED_ORPHAN = 2;
int SC_DISPEL_REMOVED_SELF = 3;
int SC_DISPEL_REMOVED_DM = 4;

/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
//                     Prototypes
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/



/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
//                     Implementation
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/

string SCGetDispellName(int iSpellId)
{
	if (iSpellId==SPELL_LESSER_DISPEL)						return "Lesser Dispel";
	if (iSpellId==SPELL_LESSER_DISPEL_FRIEND)				return "Lesser Dispel (Friend)";
	if (iSpellId==SPELL_LESSER_DISPEL_HOSTILE)				return "Lesser Dispel (Hostile)";
	if (iSpellId==SPELL_LESSER_DISPEL_AOE)					return "Lesser Dispel (AoE)";

	if (iSpellId==SPELL_DISPEL_MAGIC)						return "Dispel";
	if (iSpellId==SPELL_DISPEL_MAGIC_FRIEND)				return "Dispel (Friend)";
	if (iSpellId==SPELL_DISPEL_MAGIC_HOSTILE)				return "Dispel (Hostile)";
	if (iSpellId==SPELL_DISPEL_MAGIC_AOE)					return "Dispel (AoE)";

	if (iSpellId==SPELL_I_VORACIOUS_DISPELLING)				return "Voracious Dispelling";

	if (iSpellId==SPELL_GREATER_DISPELLING)					return "Greater Dispel";
	if (iSpellId==SPELL_GREATER_DISPELLING_FRIEND)			return "Greater Dispel (Friend)";
	if (iSpellId==SPELL_GREATER_DISPELLING_HOSTILE)			return "Greater Dispel (Hostile)";
	if (iSpellId==SPELL_GREATER_DISPELLING_AOE)				return "Greater Dispel (AoE)";

	if (iSpellId==SPELL_I_DEVOUR_MAGIC)						return "Devour Magic";

	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION)			return "Mordenkainen's Disjunction";
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_FRIEND)	return "Mordenkainen's Disjunction (Friend)";
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_HOSTILE)	return "Mordenkainen's Disjunction (Hostile)";
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_AOE)		return "Mordenkainen's Disjunction (AoE)";
	if (iSpellId==SPELLABILITY_DISCHORD_DISJUNCT)			return "Anti-Magic Melody";
	if (iSpellId==SPELL_CHAIN_DISPEL)						return "Chain Dispel";
	
	if (iSpellId==SPELL_I_CASTERS_LAMENT)					return "Caster's Lament";
	
	if (iSpellId==SPELL_REAVING_DISPEL)						return "Reaving Dispel";

	if (iSpellId==SPELL_WALL_DISPEL_MAGIC)					return "Wall of Dispelling";
	if (iSpellId==SPELL_GREATER_WALL_DISPEL_MAGIC)			return "Wall of Greater Dispelling";
	
	if (iSpellId==SPELL_TRUE_NAME)							return "True Name";
	
	if (iSpellId==SPELL_BREAK_ENCHANTMENT)					return "Break Enchantment";

	 // Dispel Psionics psi_pow_dispel	
	 // sp_dispelalignment.nss
	// 
	// SPELL_DISPEL_ALIGNMENT
	if (iSpellId==SPELL_DISPEL_ALIGNMENT) 					return "Dispel Alignment"; // capped at breaching on enchantment, not really a dispel
	if (iSpellId==SPELL_DISPELLING_TOUCH)					return "Dispelling Touch"; // capped at 10
	if (iSpellId==SPELL_EPIC_SUP_DIS)						return "Superb Dispelling"; // capped at 40
	if (iSpellId==SPELL_SLASHING_DISPEL)					return "Slashing Dispel";  // sp_slash_displ.nss  // capped at level 10, this is dispel magic with damage feature added
	 
	
	if (iSpellId==SPELLABILITY_AA_SEEKER_ARROW_1 || iSpellId==SPELLABILITY_AA_SEEKER_ARROW_2) {
		int nAA = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);
		if (nAA<7) return "Lesser Anti-Magic Seeker";
		if (nAA<10) return "Anti-Magic Seeker";
		return "Greater Anti-Magic Seeker";
	}
	if (iSpellId==SPELLABILITY_PILFER_MAGIC) {
		int nAT = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, OBJECT_SELF);
		if (nAT<5) return "Lesser Pilfer Magic";
		if (nAT<9) return "Pilfer Magic";
		return "Greater Pilfer Magic";
	}
	
	
	
	if (CSLItemGetIsMeleeWeapon(GetSpellCastItem()))    return "On-Hit Dispel";
	return "Unknown Dispell Spell";
}

int SCGetDispellCount(int iSpellId, int bSingle = TRUE)
{
	if (iSpellId==SPELL_LESSER_DISPEL)						return bSingle ? 3 : 1;
	if (iSpellId==SPELL_LESSER_DISPEL_FRIEND)				return 1;
	if (iSpellId==SPELL_LESSER_DISPEL_HOSTILE)				return 1;
	if (iSpellId==SPELL_LESSER_DISPEL_AOE)					return 1;

	if (iSpellId==SPELL_DISPEL_MAGIC)						return bSingle ? 4 : 2;
	if (iSpellId==SPELL_DISPEL_MAGIC_FRIEND)				return 4;
	if (iSpellId==SPELL_DISPEL_MAGIC_HOSTILE)				return 4;
	if (iSpellId==SPELL_DISPEL_MAGIC_AOE)					return 2;
	
	if (iSpellId==SPELL_DISPEL_ALIGNMENT) 					return 1; // capped at breaching on enchantment, not really a dispel
	if (iSpellId==SPELL_DISPELLING_TOUCH)					return 4; // capped at 10
	
	if (iSpellId==SPELL_SLASHING_DISPEL)					return bSingle ? 4 : 2;;  // sp_slash_displ.nss  // capped at level 10, this is dispel magic with damage feature added
	
	
	if (iSpellId==SPELL_I_VORACIOUS_DISPELLING)				return 4;
	if (iSpellId==SPELL_WALL_DISPEL_MAGIC)					return 3;
	if (iSpellId==SPELL_I_DEVOUR_MAGIC)						return 6;

	if (iSpellId==SPELL_GREATER_DISPELLING)					return bSingle ? 7 : 3;
	if (iSpellId==SPELL_GREATER_DISPELLING_FRIEND)			return 7;
	if (iSpellId==SPELL_GREATER_DISPELLING_HOSTILE)			return 7;
	if (iSpellId==SPELL_GREATER_DISPELLING_AOE)				return 3;
	
	if (iSpellId==SPELL_I_CASTERS_LAMENT)					return bSingle ? 7 : 3;			
	
	if (iSpellId==SPELL_CHAIN_DISPEL)						return 7;

	if (iSpellId==SPELL_GREATER_WALL_DISPEL_MAGIC)         return 4;

	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION)         return bSingle ? 10: 4;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_FRIEND)  return 10;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_HOSTILE) return 10;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_AOE)     return 4;
	if (iSpellId==SPELLABILITY_DISCHORD_DISJUNCT)			return  bSingle ? 10: 4;
	if (iSpellId==SPELL_EPIC_SUP_DIS)						return bSingle ? 10: 4; // capped at 40
	
	if (iSpellId==SPELL_REAVING_DISPEL)     				return bSingle ? 7 : 3; // like greater dispel
	
	if (iSpellId==SPELL_TRUE_NAME) 							return 60;
	if (iSpellId==SPELL_BREAK_ENCHANTMENT)					return 60;
	if (iSpellId==SPELLABILITY_PILFER_MAGIC)       			return 1; // NO AOE AVAILABLE
	if (iSpellId==SPELLABILITY_AA_SEEKER_ARROW_1 || iSpellId==SPELLABILITY_AA_SEEKER_ARROW_2) return 4;
	if (CSLItemGetIsMeleeWeapon(GetSpellCastItem())) 		return 1;
	return 1;
}

int SCGetDispelPowerCap(int iSpellId, int bSingle = TRUE)
{
	if (iSpellId==SPELL_LESSER_DISPEL)						return 5;
	if (iSpellId==SPELL_LESSER_DISPEL_FRIEND)				return 5;
	if (iSpellId==SPELL_LESSER_DISPEL_HOSTILE)				return 5;
	if (iSpellId==SPELL_LESSER_DISPEL_AOE)					return 5;

	if (iSpellId==SPELL_DISPEL_MAGIC)						return 10;
	if (iSpellId==SPELL_DISPEL_MAGIC_FRIEND)				return 10;
	if (iSpellId==SPELL_DISPEL_MAGIC_HOSTILE)				return 10;
	if (iSpellId==SPELL_DISPEL_MAGIC_AOE)					return 10;

	if (iSpellId==SPELL_I_VORACIOUS_DISPELLING)				return 10;
	if (iSpellId==SPELL_WALL_DISPEL_MAGIC)					return 10;
	if (iSpellId==SPELL_I_DEVOUR_MAGIC)						return 20;

	if (iSpellId==SPELL_GREATER_DISPELLING)					return 20;
	if (iSpellId==SPELL_GREATER_DISPELLING_FRIEND)			return 20;
	if (iSpellId==SPELL_GREATER_DISPELLING_HOSTILE)			return 20;
	if (iSpellId==SPELL_GREATER_DISPELLING_AOE)				return 20;
	

	if (iSpellId==SPELL_BREAK_ENCHANTMENT)					return 15;
	if (iSpellId==SPELL_CHAIN_DISPEL)						return 25;

	if (iSpellId==SPELL_GREATER_WALL_DISPEL_MAGIC)         return 20;

	if (iSpellId==SPELL_I_CASTERS_LAMENT)					return 20;
	
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION)         return 30;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_FRIEND)  return 30;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_HOSTILE) return 30;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_AOE)     return 30;
	if (iSpellId==SPELLABILITY_DISCHORD_DISJUNCT)          return 30;
	if (iSpellId==SPELL_EPIC_SUP_DIS)						return 40;
	
	if (iSpellId==SPELL_DISPEL_ALIGNMENT) 					return 10; // capped at breaching on enchantment, not really a dispel
	if (iSpellId==SPELL_DISPELLING_TOUCH)					return 10; // capped at 10
	if (iSpellId==SPELL_SLASHING_DISPEL)					return 10;  // sp_slash_displ.nss  // capped at level 10, this is dispel magic with damage feature added

	
	if (iSpellId==SPELL_TRUE_NAME)							return 60;
	
	if (iSpellId==SPELL_REAVING_DISPEL)						return 20; // like greater dispel
	

	if (iSpellId==SPELLABILITY_PILFER_MAGIC)       return 5; // NO AOE AVAILABLE
	if (iSpellId==SPELLABILITY_AA_SEEKER_ARROW_1 || iSpellId==SPELLABILITY_AA_SEEKER_ARROW_2) return 10;
	if (CSLItemGetIsMeleeWeapon(GetSpellCastItem())) return 10;
	return 1;
}


effect SCGetDispelVisual(int iSpellId)
{
	if (iSpellId==SPELL_I_VORACIOUS_DISPELLING)    return EffectVisualEffect(VFX_INVOCATION_ELDRITCH_HIT);
	if (iSpellId==SPELL_WALL_DISPEL_MAGIC)         return EffectVisualEffect(VFX_HIT_SPELL_WALL_OF_DISPEL);
	if (iSpellId==SPELL_GREATER_WALL_DISPEL_MAGIC) return EffectVisualEffect(VFX_HIT_SPELL_WALL_OF_DISPEL);
	return EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
}

/*********************************************************************/
/*********************************************************************/
/*********************************************************************/
//                     Original Version
/*********************************************************************/
/*********************************************************************/
/*********************************************************************/



// you make a caster level check (1d20 + caster level, maximum +15) against a DC of 11 + caster level of the effect
// you make a caster level check (1d20 + caster level, maximum +10) against a DC of 11 + caster level of the effect
int SCCheckRemoveEffect( object oTarget, object oCaster, effect eEffect, int iDispelSpellID) // string sSpellName = ;
{
	
	//int iCurSpellLevel = HkGetSpellLevel( iSpellId );
	// SPELL_BREAK_ENCHANTMENT
	object oCreator = GetEffectCreator(eEffect);
	
	if ( GetIsDM( oCaster ) )
	{
		return SC_DISPEL_REMOVED_DM;
	}
	else if ( !GetIsObjectValid( oCreator ) )
	{
		return SC_DISPEL_REMOVED_ORPHAN;
	}
	else if ( oCreator == oCaster )
	{
		return SC_DISPEL_REMOVED_SELF;
	}
	else
	{
		int iRoll;
		int nDispelCheck = HkDispelCheck( oCaster, iDispelSpellID );
		int iSpellId = GetEffectSpellId(eEffect);
		
		int iCreatorLevel = CSLGetTargetTagInt( SCSPELLTAG_CASTERLEVEL, oTarget, iSpellId);
		if ( iCreatorLevel == -1) // was not stored so lets fail over to the old way
		{
			iCreatorLevel = HkGetCasterLevel( oCreator );
		}
		int nDispelDC = CSLGetTargetTagInt( SCSPELLTAG_SPELLDISPELDC, oTarget, iSpellId);
		if ( nDispelDC == -1) // was not stored so lets fail over to the old way
		{
			nDispelDC = HkDispelDC( oCreator );
		}
		
		if ( SC_DISPELRULES == 3 )
		{
			iRoll = d100(); // APPLY ROLLBONUS AS A MIN ON THE DIE ROLL
		}
		else
		{
			iRoll = d20();
		}
		int nCasterRoll = nDispelCheck + iRoll;
		
		
		if ( ( nDispelCheck + iRoll ) > nDispelDC )
		{
			if (DEBUGGING >= 5) { CSLDebug( "\n   --> " + CSLGetSpellDataName(iSpellId) + " [" + IntToString(nDispelCheck) + "+" + IntToString(iRoll)+"] = " +IntToString( nDispelCheck + iRoll )+" vs DC " + IntToString(nDispelDC), oCaster, oTarget  ); }
			return SC_DISPEL_REMOVED;	
		}
		if (DEBUGGING >= 5) { CSLDebug( "\n   --> " + CSLGetSpellDataName(iSpellId) + " [" + IntToString(nDispelCheck) + "+" + IntToString(iRoll)+"] = " +IntToString( nDispelCheck + iRoll )+" vs DC " + IntToString(nDispelDC), oCaster, oTarget  ); }
		return SC_DISPEL_FAILED;
	}
	return SC_DISPEL_FAILED;
}


void SCOnDispelRetributiveCallback(object oCaster, int iSaveDC)
{

	if (!GetIsObjectValid(oCaster))
	{
		return;
	}
	location lTarget = GetLocation(oCaster);
	float fDistToDelay = 0.25f;
	int nDamageAmt;
	float fDelay;
	float fDuration = 2.0 + HkGetWarlockBonus(oCaster);
	
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_INVOCATION_ELDRITCH_AOE), lTarget);
	
	effect eStun = EffectVisualEffect(VFX_DUR_STUN);
	eStun = EffectLinkEffects(eStun, EffectStunned());
	eStun = EffectLinkEffects(eStun, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oCaster)
		{
			
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) * fDistToDelay ;
			
			int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, oTarget, iSaveDC, SAVING_THROW_TYPE_NONE, oCaster );
			if ( iAdjustedDamage >= SAVING_THROW_METHOD_FORHALFDAMAGE )
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectAttackDecrease(1)), oTarget);
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE ) // partial damage is full hit point damage
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fDuration));	
					nDamageAmt = GetEldritchBlastDmg(oCaster, oTarget, FALSE, TRUE, FALSE);
				}
				else
				{
					nDamageAmt = GetEldritchBlastDmg(oCaster, oTarget, FALSE, TRUE, FALSE)/2;
				}
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamageAmt, DAMAGE_TYPE_SONIC), oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_SONIC), oTarget));
			
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	//CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
}





void SCDispelTarget(object oTarget, object oCaster, int nLimit=999, int iDispelSpellID = -1, int bReaving = FALSE )
{
	
	if ( !GetIsObjectValid( oTarget ) )
	{
		return;
	}
	object oTable = CSLDataObjectGet( "Magic" );
	// This is pulled in from OEI versions of dispel scripts, thinking this might be an option
	//--------------------------------------------------------------------------
	// Don't dispel magic on petrified targets
	// this change is in to prevent weird things from happening with 'statue'
	// creatures. Also creature can be scripted to be immune to dispel
	// magic as well.
	//--------------------------------------------------------------------------
	if ( GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") == 10)
	{
			if (DEBUGGING >= 5) { CSLDebug(  "SCDispelMagic: Target Immune", oCaster, oTarget  ); }
			return;
	}
	
	if ( iDispelSpellID != SPELL_BREAK_ENCHANTMENT && CSLGetHasEffectType( oTarget,EFFECT_TYPE_PETRIFY ) == TRUE  )
	{
			if (DEBUGGING >= 5) { CSLDebug(  "SCDispelMagic: Target Immune", oCaster, oTarget  ); }
			return;
	}
	
	if (DEBUGGING >= 5) { CSLDebug( "SCDispelTarget: Starting", oCaster, oTarget  ); }
	int nCount = 0;
	int iDC;           // 15+Effect creator level
	int nDCBonus;      // Target arcane defense abjuration
	if ( iDispelSpellID == -1 )
	{
		iDispelSpellID = HkGetSpellId();      // Spell ID
	}
	string sSpellName = SCGetDispellName(iDispelSpellID); // Spell name
	string sSpellList = "|"; // LIST OF SPELLS CHECKED
	string sSuccess = "   <color=limegreen>*Success* -- these effects were dispelled:";
	string sFailure = "   <color=pink>*Failure* -- these effects were not dispelled:";
	string sMessage;
	int nSuccessCnt = 0;
	int nFailureCnt = 0;
	
	/*
	int iLevelAdjust = 5 * (9 - CSLGetDispellLevel(iSpellId));
	int nCasterStat = HkGetBestCasterModifier(oCaster);
	
	// Visual Special Effects
	effect eVis = SCGetDispelVisual(iDispelSpellID);
	
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iDispelSpellID, CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)));
	
	
	/*
	string sFormula = "\nFormula is: CasterLvl*2+StatBonus+AdjFocusBonus-SpellAdjust+d100\n   vs DC 70+CreatorLvl*2+StatBonus+AdjDefenseBonus";
	
	if (GetIsPC(oTarget)) SendMessageToPC(oTarget, GetName(oCaster) + " casts " + sSpellName + " on you." + sFormula);
	SendMessageToPC(oCaster, sSpellName + " cast on " + GetName(oTarget) + sFormula);
	
	int iRollBonus = 0;
	if ( SC_DISPELRULES == 3 ) // abjuration focus helps with the roll
	{
		if      (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster))    iRollBonus += 9;
		else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster)) iRollBonus += 6;
		else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCaster))         iRollBonus += 3;
	}
	
	
	
	
	int nCasterBonus = (iCasterLevel * 2) + nCasterStat + iRollBonus - iLevelAdjust;
	string sCasterBonus = IntToString(iCasterLevel * 2) + "+" + IntToString(nCasterStat) + "+" + IntToString(iRollBonus) + "-" + IntToString(iLevelAdjust);
	*/
	int iSpellId;
	string sSpellId;
	int nDispelCheck = HkDispelCheck( oCaster, iDispelSpellID );
	int nSumLevels = 0;
	int iRoll;
	object oCreator;
	int iCreatorLevel;
	int nCreatorStat;
	int nCasterRoll;
	int nDispelDC;
	
	if ( GetObjectType(oTarget)==OBJECT_TYPE_DOOR )
	{
		if ( iDispelSpellID != SPELL_BREAK_ENCHANTMENT && SCIsArcaneLocked( oTarget ) ) // arcane lock is abjuration
		{
			iSpellId      = 3804;
			sSpellName    = "Arcane Lock";
			
			iCreatorLevel = GetLocalInt(oTarget, "SC_ARCANELOCK_CASTERLEVEL" );
			nDispelDC = GetLocalInt(oTarget, "SC_ARCANELOCK_SPELLDISPELDC" );
			if ( nDispelDC == -1 || nDispelDC == 0 )
			{
				iDC           = 70;
				nDispelDC     = iDC + (iCreatorLevel * 2) + 20;
				if ( SC_DISPELRULES == 3 )
				{
					iRoll = d100(); // APPLY ROLLBONUS AS A MIN ON THE DIE ROLL
				}
				else
				{
					iRoll = d20();
				}
			}
			
			//nCasterRoll   = ;
			
			/*
			sMessage  = "\n   --> " + sSpellName;
			sMessage += " [" + sCasterBonus + "+" + IntToString(iRoll);
			sMessage += "] " + IntToString(nCasterRoll);
			sMessage += " vs DC " + IntToString(nDispelDC);
			sMessage += " [" + IntToString(iDC) + "+" + IntToString(iCreatorLevel * 2) + "+" + "20" + "]";
			*/
			
			sMessage  = "\n   --> " + sSpellName + " [" + IntToString(nDispelCheck) + "+" + IntToString(iRoll)+"] = " +IntToString( nDispelCheck + iRoll )+" vs DC " + IntToString(nDispelDC);
			
			if ( ( nDispelCheck + iRoll ) > nDispelDC)
			{
				nSuccessCnt++;
				sSuccess += sMessage;
				SCRemoveArcaneLock( oTarget );
				nSumLevels += 2;
			}
			else
			{
				nFailureCnt++;
				sFailure += sMessage;
			}
			
			
		}
	}
	
	if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE)
	{
		int iSummonSpellId = GetLocalInt( oTarget, "SCSummon" );
		if ( iDispelSpellID != SPELL_BREAK_ENCHANTMENT && iSummonSpellId != 0 ) // it's a summon, which means i can destroy it, break enchantment does not affect this
		{
			object oMaster = GetLocalObject(oTarget, "MASTER" );
			int iSpellLevel = CSLGetTargetTagInt( SCSPELLTAG_SPELLLEVEL, oTarget, iSpellId);
			int iResult = FALSE;
			
			if ( GetIsDM( oMaster ) )
			{
				iResult = TRUE;
				sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled by DM";
			}
			else if ( !GetIsObjectValid( oMaster ) )
			{
				iResult = TRUE;
				sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled";
				
			}
			else if ( oMaster == oCaster )
			{
				if (DEBUGGING >= 5) { CSLDebug( "Self", oCaster, oTarget  ); }
				iResult = TRUE;
				sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled by Yourself";
			}
			else
			{
		
				iCreatorLevel = CSLGetTargetTagInt( SCSPELLTAG_CASTERLEVEL, oTarget, iSpellId);
				nDispelDC = CSLGetTargetTagInt( SCSPELLTAG_SPELLDISPELDC, oTarget, iSpellId);
				
				if ( iCreatorLevel == -1) { iCreatorLevel = HkGetCasterLevel( oMaster ); }
				if ( nDispelDC == -1) { nDispelDC = HkDispelDC( oMaster ); }
				
				if ( SC_DISPELRULES == 3 )
				{
					iRoll = d100(); // APPLY ROLLBONUS AS A MIN ON THE DIE ROLL
				}
				else
				{
					iRoll = d20();
				}
				nCasterRoll = nDispelCheck + iRoll;
				
				
				sMessage  = "\n   --> " + GetName( oTarget ) + " [" + IntToString(nDispelCheck) + "+" + IntToString(iRoll)+"] = " +IntToString( nDispelCheck + iRoll )+" vs DC " + IntToString(nDispelDC);
				
				if ( ( nDispelCheck + iRoll ) > nDispelDC )
				{
					iResult = TRUE;
					
					DelayCommand(1.0f, ExecuteScript("_mod_onunsummoncreature", oTarget ) );
					nSuccessCnt++;
					nSumLevels += iSpellLevel;
					sSuccess += sMessage;
				}
				else
				{
					iResult = FALSE;
					nFailureCnt++;
					sFailure += sMessage;
				}
			}
			
		
		
			if ( iResult )
			{
				DelayCommand(1.0f, ExecuteScript("_mod_onunsummoncreature", oTarget ) );
				nSuccessCnt++;
				nSumLevels += iSpellLevel;
				sSuccess += sMessage;
			}
			else
			{
				nFailureCnt++;
				sFailure += sMessage;
			}
		}
		
	}
	
	int iValidForDispel;
	int iTargetSpellLevel;
	int iCurSpellLevel;
	int iSpellSchool;
	
	string sEffectsProccessingList;
	
	if ( iDispelSpellID == SPELL_BREAK_ENCHANTMENT )
	{
		sEffectsProccessingList = CSLGetDelimitedEffectsOnTarget( oTarget, 2 );
	}
	else
	{
		sEffectsProccessingList = CSLGetDelimitedEffectsOnTarget( oTarget, 1 );
	}
	
	int i;
	int iEffectsCount = CSLNth_GetCount( sEffectsProccessingList );
	for ( i = 1; i <= iEffectsCount; i++)
	{
		string sSpellId = CSLNth_GetNthElement(sEffectsProccessingList, i);
		if ( sSpellId != "" )
		{
			iSpellId = StringToInt(sSpellId);
			
			if (DEBUGGING >= 5) { CSLDebug( "SCDispelTarget: proccessing "+CSLGetSpellDataName(iSpellId), oCaster, oTarget  ); }
			//sSpellName      = Get2DAString("spells", "Label", iSpellId);

			int iResult = FALSE;
			
			sSpellName = CSLGetSpellDataName(iSpellId); //CSLGetSpellDataName(iSpellId); //
			
			//sSpellList += sSpellId + "|"; // ADD TO DONE LIST
			//oCreator = GetEffectCreator(eEffect);
			oCreator = IntToObject( CSLGetTargetTagInt( SCSPELLTAG_CASTERPOINTER, oTarget, iSpellId ) );
			
			if ( GetIsDM( oCaster ) )
			{
				if (DEBUGGING >= 5) { CSLDebug( "DM", oCaster, oTarget  ); }
				iResult = TRUE;
				sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled by DM";
			}
			else if ( !GetIsObjectValid( oCreator ) )
			{
				if (DEBUGGING >= 5) { CSLDebug( "Invalid", oCaster, oTarget  ); }
				iResult = TRUE;
				sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled";
				
			}
			else if ( oCreator == oCaster )
			{
				if (DEBUGGING >= 5) { CSLDebug( "Self", oCaster, oTarget  ); }
				iResult = TRUE;
				sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled by Yourself";
			}
			else
			{
				
				iCreatorLevel = CSLGetTargetTagInt( SCSPELLTAG_CASTERLEVEL, oTarget, iSpellId);
				if ( iCreatorLevel == -1)
				{
					iCreatorLevel = HkGetCasterLevel( oCreator );
				}
				nDispelDC = CSLGetTargetTagInt( SCSPELLTAG_SPELLDISPELDC, oTarget, iSpellId);
				if ( nDispelDC == -1)
				{
					nDispelDC = HkDispelDC( oCreator  );
				}
				
				if ( SC_DISPELRULES == 3 )
				{
					iRoll = d100(); // APPLY ROLLBONUS AS A MIN ON THE DIE ROLL
				}
				else
				{
					iRoll = d20();
				}
				nCasterRoll   = nDispelCheck + iRoll;
				
				
				if ( ( nDispelCheck + iRoll ) > nDispelDC )
				{
					iResult = TRUE;	
				}
				
				sMessage  = "\n   --> " + sSpellName + " [" + IntToString(nDispelCheck) + "+" + IntToString(iRoll)+"] = " +IntToString( nDispelCheck + iRoll )+" vs DC " + IntToString(nDispelDC);
				if (DEBUGGING >= 5) { CSLDebug( sMessage, oCaster, oTarget  ); }
			}
			
			// empower the dm's
			//if (GetIsDM(oChar)) return 60;
			
			if ( iResult )
			{
				DeleteLocalInt(oTarget, "HenchLastEffectQuery" ); // force the AI to reload effects on target
				
				if ( iSpellId == SPELL_CONTROL_UNDEAD || iSpellId == SPELL_DOMINATE_ANIMAL || iSpellId == SPELL_DOMINATE_MONSTER || iSpellId == SPELL_DOMINATE_PERSON )
				{
					if (!GetIsPC(oTarget))
					{
						DelayCommand( 0.5f, AssignCommand(oTarget, ClearAllActions()) );
						DelayCommand( 2.0f, AssignCommand(oTarget, ActionAttack(oCreator)) );
					}
				}
				nSuccessCnt++;
				sSuccess += sMessage;
				
				//bReaving = TRUE;
				if ( bReaving )
				{
					// void CSLTransferEffectSpellIdSingle_Void(int RemoveMethod, object oCreator, object oTarget, object oReceiver, int iSpellId, int iEffectTypeID = -1, int nEffectSubType = -1 )
					if (DEBUGGING >= 5) { CSLDebug( "----Going to Transfer Effects " + CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
					DelayCommand( 0.1f, CSLTransferEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCreator, oTarget, oCaster, iSpellId ) );
				}
				else
				{
					if (DEBUGGING >= 5) { CSLDebug( "----Going to Remove Effects " + CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
					DelayCommand( 0.1f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCreator, oTarget, iSpellId ) );
				}
				
				if ( iSpellId = SPELL_I_RETRIBUTIVE_INVISIBILITY )
				{
					
					int iExplodeDC =  CSLGetTargetTagInt( SCSPELLTAG_SPELLSAVEDC, oTarget, iSpellId);
					int iExplodeMetaMagic =  CSLGetTargetTagInt( SCSPELLTAG_METAMAGIC, oTarget, iSpellId);
					int iExplodeSpellPower =  CSLGetTargetTagInt( SCSPELLTAG_SPELLPOWER, oTarget, iSpellId);
					//object oInvisCaster = IntToObject(CSLGetTargetTagInt( SCSPELLTAG_CASTERPOINTER, oTarget, iSpellId));
					
					DelayCommand( 2.0f, SCOnDispelRetributiveCallback(oTarget, iExplodeDC ) );
				}
				
				// RemoveEffect(oTarget, eEffect);
				nSumLevels += StringToInt(CSLGetSpellDataLevel(iSpellId));
				//nSumLevels += StringToInt( Get2DAString("spells", "LVL", iSpellId));
				nCount++;         // INCREMENT EFFECTS DISPELLED COUNT
			}
			else
			{
				nFailureCnt++;
				sFailure += sMessage;
			}
			
		
			
			
			
		}
	}
	
	/*
	for( iTargetSpellLevel = 0; iTargetSpellLevel >= 0; iTargetSpellLevel--) // change this to 10 later, this uses the full code to do this now, see if it fixes the TMI bugs
	{
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect) && nCount < nLimit)
	{
		iValidForDispel = FALSE;
		iSpellId = GetEffectSpellId(eEffect);
		iCurSpellLevel = HkGetSpellLevel( iSpellId );
		sSpellId = IntToString(iSpellId);
		
		//
		if ( iSpellId > -1 && GetEffectSubType(eEffect) == SUBTYPE_MAGICAL && iDispelSpellID == SPELL_BREAK_ENCHANTMENT )
		{
			// enchantments, transmutations, and curses, only does harmful effects
			iSpellSchool = CSLGetTargetTagInt( SCSPELLTAG_SPELLSCHOOL, oTarget, iSpellId);
			if ( GetEffectType(eEffect) == EFFECT_TYPE_PETRIFY || GetEffectType(eEffect) == EFFECT_TYPE_CURSE || iSpellId == SPELLABILITY_MASS_FOWL ) // always do these
			{
				iValidForDispel = TRUE;
			}
			else if ( ( iSpellSchool == SPELL_SCHOOL_ENCHANTMENT || iSpellSchool == SPELL_SCHOOL_TRANSMUTATION ) && CSLGetEffectTypeBenefical(GetEffectType(eEffect)) == 0)
			{
				if ( // these have negative effects but are actually beneficial
					iSpellId != SPELL_ENLARGE_PERSON &&
					iSpellId != SPELL_RIGHTEOUS_MIGHT &&
					iSpellId != SPELL_STONE_BODY &&
					iSpellId != SPELL_IRON_BODY &&
					iSpellId != SPELL_REDUCE_PERSON &&
					iSpellId != SPELL_REDUCE_ANIMAL &&
					iSpellId != SPELL_REDUCE_PERSON_GREATER &&
					iSpellId != SPELL_REDUCE_PERSON_MASS &&
					iSpellId != FOREST_MASTER_OAK_HEART &&
					iSpellId != SPELLABILITY_GRAY_ENLARGE
				)
				{
					iValidForDispel = TRUE;
				}
			}
		}
		else if ( iSpellId > -1 && GetEffectSubType(eEffect) == SUBTYPE_MAGICAL && ( iTargetSpellLevel == 0 || iTargetSpellLevel == iCurSpellLevel  ) )
		{
			iValidForDispel = TRUE;
		}
		
		if ( iValidForDispel )
		{
			if (DEBUGGING >= 5) { CSLDebug( "SCDispelTarget: proccessing "+CSLGetSpellDataName(iSpellId), oCaster, oTarget  ); }
			//sSpellName      = Get2DAString("spells", "Label", iSpellId);
			if ( FindSubString(sSpellList, "|" + sSpellId + "|") == -1 )
			{ // NOT DONE YET
				int iResult = FALSE;
				
				sSpellName    = CSLGetSpellDataName(iSpellId); //
				
				sSpellList += sSpellId + "|"; // ADD TO DONE LIST
				oCreator      = GetEffectCreator(eEffect);
				
				if ( GetIsDM( oCaster ) )
				{
					if (DEBUGGING >= 5) { CSLDebug( "DM", oCaster, oTarget  ); }
					iResult = TRUE;
					sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled by DM";
				}
				else if ( !GetIsObjectValid( oCreator ) )
				{
					if (DEBUGGING >= 5) { CSLDebug( "Invalid", oCaster, oTarget  ); }
					iResult = TRUE;
					sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled";
					
				}
				else if ( oCreator == oCaster )
				{
					if (DEBUGGING >= 5) { CSLDebug( "Self", oCaster, oTarget  ); }
					iResult = TRUE;
					sMessage  = "\n   --> " + sSpellName + " Automatically Dispelled by Yourself";
				}
				else
				{
					
					iCreatorLevel = CSLGetTargetTagInt( SCSPELLTAG_CASTERLEVEL, oTarget, iSpellId);
					if ( iCreatorLevel == -1)
					{
						iCreatorLevel = HkGetCasterLevel( GetEffectCreator(eEffect) );
					}
					nDispelDC = CSLGetTargetTagInt( SCSPELLTAG_SPELLDISPELDC, oTarget, iSpellId);
					if ( nDispelDC == -1)
					{
						nDispelDC = HkDispelDC( GetEffectCreator(eEffect)  );
					}
					
					if ( SC_DISPELRULES == 3 )
					{
						iRoll = d100(); // APPLY ROLLBONUS AS A MIN ON THE DIE ROLL
					}
					else
					{
						iRoll = d20();
					}
					nCasterRoll   = nDispelCheck + iRoll;
					
					
					if ( ( nDispelCheck + iRoll ) > nDispelDC )
					{
						iResult = TRUE;	
					}
					
					sMessage  = "\n   --> " + sSpellName + " [" + IntToString(nDispelCheck) + "+" + IntToString(iRoll)+"] = " +IntToString( nDispelCheck + iRoll )+" vs DC " + IntToString(nDispelDC);
					if (DEBUGGING >= 5) { CSLDebug( sMessage, oCaster, oTarget  ); }
				}
				
				// empower the dm's
				//if (GetIsDM(oChar)) return 60;
				
				if ( iResult )
				{
					if (GetEffectType(eEffect)==EFFECT_TYPE_DOMINATED)
					{
						if (!GetIsPC(oTarget))
						{
							DelayCommand( 0.5f, AssignCommand(oTarget, ClearAllActions()) );
							DelayCommand( 2.0f, AssignCommand(oTarget, ActionAttack(oCreator)) );
						}
					}
					nSuccessCnt++;
					sSuccess += sMessage;
					
					//bReaving = TRUE;
					if ( bReaving )
					{
						// void CSLTransferEffectSpellIdSingle_Void(int RemoveMethod, object oCreator, object oTarget, object oReceiver, int iSpellId, int iEffectTypeID = -1, int nEffectSubType = -1 )
						if (DEBUGGING >= 5) { CSLDebug( "----Going to Transfer Effects " + CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
						DelayCommand( 0.1f, CSLTransferEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCreator, oTarget, oCaster, iSpellId ) );
					}
					else
					{
						if (DEBUGGING >= 5) { CSLDebug( "----Going to Remove Effects " + CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
						DelayCommand( 0.1f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCreator, oTarget, iSpellId ) );
					}
					// RemoveEffect(oTarget, eEffect);
					nSumLevels += StringToInt(CSLGetSpellDataLevel(iSpellId));
					//nSumLevels += StringToInt( Get2DAString("spells", "LVL", iSpellId));
					nCount++;         // INCREMENT EFFECTS DISPELLED COUNT
				}
				else
				{
					nFailureCnt++;
					sFailure += sMessage;
				}
			}
		}
		eEffect = GetNextEffect(oTarget);
	}
	}
	*/
	if (!nSuccessCnt) sSuccess += " None!";
	else sSuccess += "\n   --> Total Spell Levels removed: " + IntToString(nSumLevels);
	if (!nFailureCnt) sFailure += " None!";
	
	SendMessageToPC(oCaster, sSuccess);
	SendMessageToPC(oCaster, sFailure);
	if (GetIsPC(oTarget) && oTarget!=oCaster)
	{
		SendMessageToPC(oTarget, "<color=limegreen>" + sSuccess);
		SendMessageToPC(oTarget, "<color=pink>" + sFailure);
	}
	
	if (nSumLevels && oCaster!=oTarget)
	{ // FOR WARLOCK'S CALL BACK
		//iSpellId = GetSpellId(); // REREAD DUE TO REASSIGN ABOVE
		if (iDispelSpellID==SPELL_I_DEVOUR_MAGIC)
		{
			int nBonusHP = nSumLevels * 3;
			CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, EFFECT_TYPE_TEMPORARY_HITPOINTS );
			// SCRemoveTempHitPoints();
			int nHeal = CSLGetMin(nBonusHP, GetMaxHitPoints(oCaster) - GetCurrentHitPoints(oCaster));
			nBonusHP -= nHeal;
			if (nHeal)
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oCaster);
				SendMessageToPC(  oCaster, "You healed " + IntToString(nHeal) + " hitpoints from Devour Magic." );
			}
			if (nBonusHP)
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect( EffectTemporaryHitpoints(nBonusHP) ), oCaster, 60.0f);
				SendMessageToPC(  oCaster, "You gained " + IntToString(nBonusHP) + " temporary hitpoints from Devour Magic." );
			}
		}
		else if (iDispelSpellID==SPELL_I_VORACIOUS_DISPELLING)
		{
			int iDamage = nSumLevels * 3;
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage), oTarget);
			SendMessageToPC( oCaster, "You caused " + IntToString(iDamage) + " damage from Voracious Dispelling." );
		}
		else if (iDispelSpellID==SPELL_SLASHING_DISPEL)
		{
			int iDamage = nSumLevels * 2;
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage), oTarget);
			SendMessageToPC( oCaster, "You caused " + IntToString(iDamage) + " damage from Slashing Dispel." );
		}
		
		else if (iDispelSpellID==SPELLABILITY_PILFER_MAGIC)
		{
			CSLUnstackSpellEffects(oTarget, GetSpellId());
			int nAT = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster);
			if (nAT<5) nAT = 2;
			else if (nAT<9) nAT = 3;
			else nAT = 4;
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectAttackIncrease(nAT), EffectSavingThrowIncrease(SAVING_THROW_ALL, nAT)), oCaster, RoundsToSeconds(10)+GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster));
			SendMessageToPC(  oCaster, "You gained +" + IntToString(nAT) + " AB/+" + IntToString(nAT) + " Saves from Pilfer Magic." );
		}
	}
	//return nSuccessCnt;
}



void SCDispelAoE(object oAoE, object oCaster, int iDispelSpellID = -1, int iClass = 255 )
{
	if (DEBUGGING >= 6) { CSLDebug(  "SCDispelAoE: Starting", oCaster  ); }
	
	int iAOESpellId = CSLGetAOETagInt( SCSPELLTAG_SPELLID, oAoE );
	
	if ( CSLGetPreferenceSwitch("DispelIgnoresClouds",FALSE) &&  CSLGetIsCloud ( iAOESpellId ) == 2 )
	{
		return;
	}
	
	// check if aura
	if ( GetAreaOfEffectDuration(oAoE) == DURATION_TYPE_PERMANENT)
	{
        return;
	}
	
	
	// make sure we have valid attributes coming in
	if ( iDispelSpellID == -1 )
	{
		iDispelSpellID = HkGetSpellId();
	}
	
	if ( iClass == 255 )
	{
		iClass = HkGetSpellClass( oCaster );
	}
	
	string sSpellName = SCGetDispellName(iDispelSpellID);
	
	string sAOEName = CSLGetAOETagString( SCSPELLTAG_NAME, oAoE );
	
	int nDispelDC = CSLGetAOETagInt( SCSPELLTAG_SPELLDISPELDC, oAoE );
	
	
	object oCreator = GetAreaOfEffectCreator( oAoE );
	
	if ( nDispelDC == -1 )
	{
		nDispelDC = HkDispelDC( oCreator );
	}
	
	int nDispelCheck = HkDispelCheck( oCaster, iDispelSpellID, iClass );
		
	int iRoll = d100();
		
	int nCasterRoll = nDispelCheck + iRoll;
	
	if (GetIsPC(oCreator) && oCreator!=oCaster)
	{
		SendMessageToPC(oCreator, GetName(oCaster) + " casts AOE " + sSpellName + " on your " + sAOEName );
	}
	SendMessageToPC(oCaster, sSpellName + "ing " + sAOEName + " of " + GetName(oCreator) );
	
	string sRoll = " Caster Check " + IntToString( nDispelCheck ) + " + Roll "+ IntToString( iRoll ) + " = "+ IntToString( nCasterRoll ) +" vs DC " + IntToString(nDispelDC) + " ( Formula is in Spell Description )";
	string sMessage;
	
	if ( GetIsDM(oCaster) || GetIsDMPossessed(oCaster) )
	{
		DestroyObject (oAoE);
		sMessage = "<color=limegreen>*Success* DM Dispelled Automatically";
	}
	else if ( oCaster==oCreator )
	{
		DestroyObject (oAoE);
		sMessage = "<color=limegreen>*Success* Dispelled Your Own Effect Automatically";
	}
	else if (nCasterRoll > nDispelDC)
	{
		DestroyObject (oAoE);
		sMessage = "<color=limegreen>*Success*" + sRoll;
	}
	else
	{
		sMessage = "<color=pink>*Failure*" + sRoll;
	}
	//if (GetIsPC(oCreator) && oCreator!=oCaster) SendMessageToPC(oCreator, sMessage);
	//SendMessageToPC(oCaster, sMessage);
	if (GetIsPC(oCaster))
	{
		SendMessageToPC( oCaster, sMessage );
	}
}


int SCGetSpellBreachProtection(int nLastChecked)
{
	if (nLastChecked == 1) return SPELL_ETHEREALNESS;                                /* 9 */ // greater sanctuary
	if (nLastChecked == 2) return SPELL_GREATER_SPELL_MANTLE;                        /* 9 */
	if (nLastChecked == 3) return SPELL_SHADES_TARGET_CASTER;                        /* 9 */
	if (nLastChecked == 4) return SPELL_PREMONITION;                                 /* 8 */
	if (nLastChecked == 5) return SPELL_MIND_BLANK;                                  /* 8 */
	if (nLastChecked == 6) return SPELL_SHADOW_SHIELD;                               /* 7 */
	if (nLastChecked == 7) return SPELL_ETHEREAL_JAUNT;                              /* 7 */
	if (nLastChecked == 8) return SPELL_ENERGY_IMMUNITY;                             /* 7 */
	if (nLastChecked == 9) return SPELL_ENERGY_IMMUNITY_ACID;                        /* 7 */
	if (nLastChecked == 10) return SPELL_ENERGY_IMMUNITY_COLD;                       /* 7 */
	if (nLastChecked == 11) return SPELL_ENERGY_IMMUNITY_ELECTRICAL;                 /* 7 */
	if (nLastChecked == 12) return SPELL_ENERGY_IMMUNITY_FIRE;                       /* 7 */
	if (nLastChecked == 13) return SPELL_ENERGY_IMMUNITY_SONIC;                      /* 7 */
	if (nLastChecked == 14) return SPELL_SPELL_MANTLE;                                /* 7 */
	if (nLastChecked == 15) return SPELL_PROTECTION_FROM_SPELLS;                      /* 7 */
	if (nLastChecked == 16) return SPELL_GREATER_STONESKIN;                           /* 6 */
	if (nLastChecked == 17) return SPELL_GLOBE_OF_INVULNERABILITY;                    /* 6 */
	if (nLastChecked == 18) return SPELL_ETHEREAL_VISAGE;                             /* 5 */
	if (nLastChecked == 19) return SPELL_LESSER_MIND_BLANK;                           /* 5 */
	if (nLastChecked == 20) return SPELL_LESSER_SPELL_MANTLE;                         /* 5 */
	if (nLastChecked == 21) return SPELL_STONESKIN;                                   /* 4 */
	if (nLastChecked == 22) return SPELL_SPELL_IMMUNITY;                              /* 4 */
	if (nLastChecked == 23) return SPELL_LEAST_SPELL_MANTLE;                          /* 4 */
	if (nLastChecked == 24) return SPELL_LESSER_GLOBE_OF_INVULNERABILITY;             /* 4 */
	if (nLastChecked == 25) return SPELL_SHADOW_CONJURATION_MAGE_ARMOR;               /* 4 */
	if (nLastChecked == 26) return SPELL_IMPROVED_MAGE_ARMOR;                         /* 3 */
	if (nLastChecked == 27) return SPELL_PROTECTION_FROM_ENERGY;                      /* 3 */
	if (nLastChecked == 28) return SPELL_SHIELDIMPROVED;                              /* 3 */
	if (nLastChecked == 29) return SPELL_GHOSTLY_VISAGE;                              /* 2 */
	if (nLastChecked == 30) return SPELL_SILENCE;                                     /* 2 */
	if (nLastChecked == 31) return SPELL_ELEMENTAL_SHIELD;                            /* 2 */
	if (nLastChecked == 32) return SPELL_MIRROR_IMAGE;                                /* 2 */
	if (nLastChecked == 33) return SPELL_PROTECTION_FROM_ARROWS;                      /* 2 */
	if (nLastChecked == 34) return SPELL_RESIST_ENERGY;                               /* 2 */
	if (nLastChecked == 35) return SPELL_DEATH_ARMOR;                                 /* 2 */
	if (nLastChecked == 36) return SPELL_MAGE_ARMOR;                                  /* 1 */
	if (nLastChecked == 37) return SPELL_FOUNDATION_OF_STONE;                         /* 1 */
	if (nLastChecked == 38) return SPELL_RESISTANCE;                                  /* 1 */
	if (nLastChecked == 39) return SPELL_SANCTUARY;                                   /* 1 */
	if (nLastChecked == 40) return SPELL_SHIELD;                                      /* 1 */
	if (nLastChecked == 41) return SPELL_ENTROPIC_SHIELD;                             /* 1 */
	if (nLastChecked == 42) return SPELL_SHIELD_OF_FAITH;                             /* 1 */
	if (nLastChecked == 43) return SPELL_ENDURE_ELEMENTS;                             /* 1 */
	if (nLastChecked == 44) return SPELL_SPELL_RESISTANCE;                            /* 5 */
	return SPELL_RESISTANCE;
}

void SCSpellBreach(object oCaster, object oTarget, int nBreachMax, int nSR, int iDispelSpellID = SPELL_GREATER_SPELL_BREACH)
{
	if (DEBUGGING >= 6) { CSLDebug(  "SCSpellBreach: Starting", oCaster, oTarget  ); }
	int nBreachCnt = 0;
	int nCheckSpell = 0;

	string sSpellName; // Spell name
	string sSuccess = "   <color=limegreen>*Success* -- these protections were breached:";
	//SendMessageToPC( oCaster, "Starting" );
	if      (iDispelSpellID==SPELL_LESSER_SPELL_BREACH)       sSpellName = "Lesser Spell Breach";
	else if (iDispelSpellID==SPELL_GREATER_SPELL_BREACH)      sSpellName = "Greater Spell Breach";
	else if (iDispelSpellID==SPELL_MORDENKAINENS_DISJUNCTION) sSpellName = "Mordenkainen's Breach";

	if (GetIsPC(oTarget)) { SendMessageToPC(oTarget, GetName(oCaster) + " casts " + sSpellName + " on you.");}
	SendMessageToPC(oCaster, sSpellName + " cast on " + GetName(oTarget));
	
	
	if (!GetIsReactionTypeFriendly(oTarget))
	{
		//SendMessageToPC( oCaster, "2" );
		if (DEBUGGING >= 6) { CSLDebug(  "SCSpellBreach: Reducing SR", oCaster, oTarget  ); }
		effect eLink = EffectSpellResistanceDecrease(nSR);
		eLink = EffectLinkEffects( eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE) );
		eLink = ExtraordinaryEffect( eLink );
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10), iDispelSpellID );
		//SendMessageToPC( oCaster, "3" );
		if (iDispelSpellID != SPELL_MORDENKAINENS_DISJUNCTION) // don't want to do it twice
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iDispelSpellID));
		}
		/* Revised version PAIN
		
		Making the script use the standardized remove script to ensure it safely removes all the effect of a given type
		
		*/
		//SendMessageToPC( oCaster, "4" );
		int nNextSpellID;
		int bRemoved;
		while ( nCheckSpell <= BREACH_SPELL_COUNT && nBreachCnt < nBreachMax )
		{
			bRemoved = FALSE;
			//SendMessageToPC( oCaster, "SCGetSpellBreachProtection");
			nNextSpellID = SCGetSpellBreachProtection(nCheckSpell);
			//SendMessageToPC( oCaster, "Currentingworking on nCheckSpell="+IntToString(nCheckSpell)+" nNextSpellID="+IntToString(nNextSpellID) );
			if (DEBUGGING >= 6) { CSLDebug(  "SCBreach: Working on "+IntToString( nNextSpellID ), oCaster, oTarget  ); }
			
				// use the old script for this effect so it can do the breach check
				// rework remove function to include a dc check to work like this
				//SendMessageToPC( oCaster, "5" );
				if ( GetHasSpellEffect(nNextSpellID, oTarget) )
				{
				//SendMessageToPC( oCaster, "5.5" );
				if ( nNextSpellID == SPELL_SPELL_RESISTANCE )
				{
					int bRemoved = FALSE;
					int bSpecialDone = FALSE;
					//SendMessageToPC( oCaster, "6" );
					effect eProtection = GetFirstEffect(oTarget);
					while (GetIsEffectValid(eProtection))
					{
						if (GetEffectSpellId(eProtection)==nNextSpellID)
						{
							if (!bSpecialDone)
							{
								//SendMessageToPC( oCaster, "7" );
								bRemoved = SCCheckRemoveEffect( oTarget, oCaster, eProtection, iDispelSpellID);
								if ( !bRemoved  )
								{
									sSuccess  += "\n   --> FAILED to remove Spell Resistance";
								}
							}
							bSpecialDone = TRUE;
							//SendMessageToPC( oCaster, "8" );
							if (bRemoved)
							{
								RemoveEffect(oTarget, eProtection);
								eProtection = GetFirstEffect(oTarget); // start over
							}
							else
							{
								eProtection = GetNextEffect(oTarget);
							}
						}
					}
				}
				else
				{
					//SendMessageToPC( oCaster, "9" );
					bRemoved = CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, nNextSpellID );
				}
			
				if (bRemoved)
				{
					//SendMessageToPC( oCaster, "10" );
					nBreachCnt++;
					sSpellName = CSLGetSpellDataName(nNextSpellID);
					sSuccess  += "\n   --> " + sSpellName;
				}
				}
				nCheckSpell++;
			}
	
			
			if (!nBreachCnt)
			{
				sSuccess += " None!";
			}
		
		CSLPlayerMessageSplit( sSuccess, oCaster, oTarget  );
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oTarget);
	}
}






void SCApplyBlasphemyEffect(object oTarget, int iHD, int iCasterHD, int iSpellDC )
{	
	
	if ( CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ) )
	{
		// it can't hear me
			return;
	}
	
	float fParaDur = 0.0f;
	float fBlindDur = 0.0f;
	
	float fDeafDur = HkApplyMetamagicDurationMods( RoundsToSeconds( d4() ));
	
	fBlindDur = HkApplyMetamagicDurationMods( RoundsToSeconds( d4(2) ));
	
	if( GetIsPC(oTarget) )
	{
		fParaDur = HkApplyMetamagicDurationMods(RoundsToSeconds( d4() ));
	}
	else
	{
		fParaDur = HkApplyMetamagicDurationMods(RoundsToSeconds( d10() ));
	}

	int nWeakStr = d6(2);
	int nWeakDur = d4(2);
	float fWeakDur = HkApplyMetamagicDurationMods(RoundsToSeconds(nWeakDur));
	
	float fDelay = CSLRandomBetweenFloat(0.4, 1.1);
	int SpellId = GetSpellId();		
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
	
	if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSpellDC))
	{
		effect eDamage = EffectDamage(d6(2), DAMAGE_TYPE_SONIC);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);	
	}
	
	if (iHD <= iCasterHD)
	{
		
		if ( !GetIsPC(oTarget) || !HkSavingThrow( SAVING_THROW_FORT, oTarget, iSpellDC+4 ))
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, SpellId );		
			
			if ( iHD <= (iCasterHD - 1) )
			{
				effect eBlind = EffectBlindness();
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, fBlindDur);
			}
			/*
			if ( iHD > (iCasterHD - 5) )
			{
				effect eWeak = EffectAbilityDecrease(ABILITY_STRENGTH, nWeakStr);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeak, oTarget, fWeakDur);
			}
			*/
			if ( iHD <= (iCasterHD - 5) )
			{
				effect ePara = EffectParalyze(iSpellDC,SAVING_THROW_WILL); 
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, fParaDur);
			}
			if ( iHD <= (iCasterHD - 10) )
			{
				if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
				{
					effect eDeath = EffectVisualEffect( VFX_HIT_AOE_ABJURATION );
					eDeath = EffectLinkEffects(eDeath, EffectDeath(FALSE,TRUE,TRUE));
					DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
				}
				else if ( CSLGetIsUndead( oTarget ) )
				{
					effect eDeath = EffectVisualEffect( VFX_HIT_AOE_ABJURATION );
					eDeath = EffectLinkEffects(eDeath, EffectDamage(GetCurrentHitPoints(oTarget)+10) );
					DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
				}
			}
	
		}
		
		//eDeaf Effect;
		effect eDeaf = EffectVisualEffect( VFX_DUR_SPELL_BESTOW_CURSE );
		eDeaf = EffectLinkEffects(eDeaf, EffectDeaf());
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDeafDur);
	
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Single Immunity Only Nerf - only works for last version cast, previous spells cast will be removed soas to only allow one immunity /
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SCUnstackEnergyImmunity( int iIgnoredImmunity, object oCaster, object oTarget )
{
	if( CSLGetPreferenceSwitch("PreventEnergyImmunityStacking", FALSE ) )
	{
		string sMessageToPlayers = "";
		// Comment out the current one, this just tests soas to do messages
		if ( iIgnoredImmunity != SPELL_ENERGY_IMMUNITY && GetHasSpellEffect(SPELL_ENERGY_IMMUNITY, oTarget) ) { sMessageToPlayers = "Removed complete energy immunity"; }
		if ( iIgnoredImmunity != SPELL_ENERGY_IMMUNITY_ACID && GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_ACID, oTarget) ) { sMessageToPlayers = "Removed acid energy immunity";}
		if ( iIgnoredImmunity != SPELL_ENERGY_IMMUNITY_ELECTRICAL && GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_ELECTRICAL, oTarget) ) { sMessageToPlayers = "Removed electrical energy immunity"; }
		if ( iIgnoredImmunity != SPELL_ENERGY_IMMUNITY_FIRE && GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_FIRE, oTarget) ) { sMessageToPlayers = "Removed fire energy immunity"; }
		if ( iIgnoredImmunity != SPELL_ENERGY_IMMUNITY_SONIC && GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_SONIC, oTarget) ) { sMessageToPlayers = "Removed sonic energy immunity"; }
		if ( iIgnoredImmunity != SPELL_ENERGY_IMMUNITY_COLD && GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_COLD, oTarget) ) { sMessageToPlayers = "Removed cold energy immunity"; }
	
		if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_ENERGY_IMMUNITY, SPELL_ENERGY_IMMUNITY_ACID, SPELL_ENERGY_IMMUNITY_COLD, SPELL_ENERGY_IMMUNITY_ELECTRICAL, SPELL_ENERGY_IMMUNITY_FIRE, SPELL_ENERGY_IMMUNITY_SONIC ) )
		{
			CSLPlayerMessageSplit( sMessageToPlayers, oCaster, oTarget); // sends to caster and target unless they are the same
		}
	}
	else
	{
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iIgnoredImmunity );
	}
	
}



//::///////////////////////////////////////////////
//:: DoSimbulsSynostodweomer
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Does the effects for Simbul's Synostodweomer
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 30, 2004
//:://////////////////////////////////////////////
void SCSimbulSynostodweomer(object oCaster, object oTarget, int iMetamagic, int iSpellId, int iSpellClass) {

    int iSpellLevel = HkGetSpellLevel( iSpellId, iSpellClass ); // ByDC
    int iHealAmount;

    switch(iMetamagic) {
        case METAMAGIC_QUICKEN:
            iSpellLevel+=4;
            break;
        case METAMAGIC_MAXIMIZE:
            iSpellLevel+=3;
            break;
        case METAMAGIC_EMPOWER:
            iSpellLevel+=2;
            break;
        case METAMAGIC_SILENT:
        case METAMAGIC_STILL:
        case METAMAGIC_EXTEND:
            iSpellLevel++;
            break;
    }

    iHealAmount=d6(iSpellLevel);
    // SGspellsCure(iHealAmount, 0, 6*iSpellLevel, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_G, SPELL_SIMBULS_SYNOSTODWEOMER);
    DeleteLocalInt(oCaster, "SIMBULS_SYNOST_MM");
    AssignCommand(oCaster, ActionMoveToObject(oTarget));
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oCaster, SPELL_SIMBULS_SYNOSTODWEOMER );

}


//::///////////////////////////////////////////////
//:: ApplyMindBlank
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Applies Mind blank to the target
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
void SCspellApplyMindBlank(object oTarget, int iSpellId, float fDelay=0.0)
{
	effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	effect eVis;
	if ( iSpellId == SPELL_LESSER_MIND_BLANK )
	{
		eVis = EffectVisualEffect( VFX_DUR_SPELL_LESSER_MIND_BLANK );
	}
	else if ( iSpellId == SPELL_MIND_BLANK )
	{
		eVis = EffectVisualEffect( VFX_DUR_SPELL_MIND_BLANK );
	}
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX

	effect eLink = EffectLinkEffects(eImm1, eVis);
	effect eSearch = GetFirstEffect(oTarget);
	int bValid;
	float fDuration = TurnsToSeconds(HkGetSpellDuration(OBJECT_SELF));

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

	//Search through effects
	while( GetIsEffectValid(eSearch) )
	{
			bValid = FALSE;
			//Check to see if the effect matches a particular type defined below
			if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
			{
				bValid = TRUE;
			}
			else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
			{
				bValid = TRUE;
			}
			else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
			{
				bValid = TRUE;
			}
			else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
			{
				bValid = TRUE;
			}
			else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
			{
				bValid = TRUE;
			}
			else if( ( GetEffectType(eSearch) == EFFECT_TYPE_DOMINATED && !GetLocalInt( oTarget, "SCSummon" ) ) )
			{
				bValid = TRUE;
			}
	// * Additional March 2003
	// * Remove any feeblemind originating effects
			else if (GetEffectSpellId(eSearch) == SPELL_FEEBLEMIND)
			{
				bValid = TRUE;
			}
			else if (GetEffectSpellId(eSearch) == SPELL_BANE)
			{
				bValid = TRUE;
			}
			 else if (GetEffectSpellId(eSearch) == SPELL_TASHAS_HIDEOUS_LAUGHTER)
			{
				bValid = TRUE;
			}
			else if (GetEffectSpellId(eSearch) == 1129) //Solipsism
			{
				bValid = TRUE;
			}
			
			//Apply damage and remove effect if the effect is a match
			if (bValid == TRUE)
			{
				RemoveEffect(oTarget, eSearch);
			}
			eSearch = GetNextEffect(oTarget);
	}

	//After effects are removed we apply the immunity to mind spells to the target
	DelayCommand(fDelay, HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, iSpellId));
	//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget)); // NWN1 VFX
}


effect SCCreateProtectionFromAlignmentLink(int nAlignment, int nPower = 1)
{
	int nFinal = nPower * 2;
	effect eAC = EffectACIncrease(nFinal, AC_DEFLECTION_BONUS);
	eAC = VersusAlignmentEffect(eAC, ALIGNMENT_ALL, nAlignment);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nFinal);
	eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlignment);
	effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, nAlignment);
	effect eDur;
	if(nAlignment == ALIGNMENT_EVIL)
	{
			//eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);  // no longer using NWN1 VFX
			eDur = EffectVisualEffect( VFX_DUR_SPELL_GOOD_CIRCLE );   // makes use of NWN2 VFX
	}
	else if(nAlignment == ALIGNMENT_GOOD)
	{
			//eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);  // no longer using NWN1 VFX
			eDur = EffectVisualEffect( VFX_DUR_SPELL_EVIL_CIRCLE );   // makes use of NWN2 VFX
	}

	//effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eImmune, eSave);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eDur);
	//eLink = EffectLinkEffects(eLink, eDur2);
	return eLink;
}


//::///////////////////////////////////////////////
//:: SCdoAura
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Used in the Alignment aura - unholy and holy
	aura scripts fromthe original campaign
	spells. Cleaned them up to be consistent.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SCdoAura(int nAlign, int nVis1, int nVis2, int iDamageType, int iSpellId = -1)
{
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	float fDuration = RoundsToSeconds(HkGetSpellDuration(OBJECT_SELF));

	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eVis = EffectVisualEffect(nVis1);
	effect eAC = EffectACIncrease(4, AC_DEFLECTION_BONUS);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4);
	//Change the effects so that it only applies when the target is evil
	effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	effect eSR = EffectSpellResistanceIncrease(25); //Check if this is a bonus or a setting.
	//effect eDur = EffectVisualEffect(nVis2);  // NWN1 VFX
	//effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);   // NWN1 VFX
	//effect eShield = EffectDamageShield(6, DAMAGE_BONUS_1d8, iDamageType);  // 10/16/06 - BDF: this effect cannot be set "vs alignment"
	effect eDamIncrease = EffectDamageIncrease( DAMAGE_BONUS_1d6, iDamageType );

	// * make them versus the alignment

	eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, nAlign);
	eSR = VersusAlignmentEffect(eSR,ALIGNMENT_ALL, nAlign);
	eAC =  VersusAlignmentEffect(eAC,ALIGNMENT_ALL, nAlign);
	eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
	//eShield = VersusAlignmentEffect(eShield,ALIGNMENT_ALL, nAlign);
	eDamIncrease = VersusAlignmentEffect( eDamIncrease, ALIGNMENT_ALL, nAlign );

	//Link effects
	effect eLink = EffectLinkEffects(eImmune, eSave);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eSR);
	//eLink = EffectLinkEffects(eLink, eDur);   // NWN1 VFX
	//eLink = EffectLinkEffects(eLink, eDur2);  // NWN1 VFX
	//eLink = EffectLinkEffects(eLink, eShield);
	eLink = EffectLinkEffects(eLink, eVis);  // NWN2 VFX
	eLink = EffectLinkEffects( eLink, eDamIncrease );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	//Apply the VFX impact and effects
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);  // NWN1 VFX
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, iSpellId );
}
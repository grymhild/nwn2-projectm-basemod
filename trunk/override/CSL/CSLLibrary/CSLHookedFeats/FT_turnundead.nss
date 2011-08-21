//::///////////////////////////////////////////////
//:: Turn Undead
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Checks domain powers and class to determine
	the proper turning abilities of the casting
	character.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 2, 2001
//:: Updated On: Jul 15, 2003 - Georg Zoeller
//:://////////////////////////////////////////////
//:: MODIFIED MARCH 5 2003 for Blackguards
//:: MODIFIED JULY 24 2003 for Planar Turning to include turn resistance hd

//:: 6/26/06 - BDF-OEI: made a revision with excluding friendlies from being targeted
//:: 08.07.06 - PKM-OEI: Changed panic to rebuke to fix the problem of terrified undead running all over the map.  Details below.
/*  Rebuke Undead:
	The character is frozen in fear and can take no actions.  A cowering character takes -2 AC and loses her Dex bonus (if any.)
	This effect replaces the panic effect.  Lasts 10 rounds.


Turn Or Rebuke Undead
Good clerics and paladins and some neutral clerics can channel positive energy, which can halt, drive off (rout), or destroy undead.

Evil clerics and some neutral clerics can channel negative energy, which can halt, awe (rebuke), control (command), or bolster undead.

Regardless of the effect, the general term for the activity is "turning." When attempting to exercise their divine control over these creatures, characters make turning checks.

Table: Turning Undead
Turning Check Result	Most Powerful Undead Affected (Maximum Hit Dice)
0 or lower				ClericÕs level -4
1Ñ3						ClericÕs level -3
4Ñ6						ClericÕs level -2
7Ñ9						ClericÕs level -1
10Ñ12					ClericÕs level
13Ñ15					ClericÕs level +1
16Ñ18					ClericÕs level +2
19Ñ21					ClericÕs level +3
22 or higher			ClericÕs level +4

Turning Checks Turning undead is a supernatural ability that a character can perform as a standard
action. It does not provoke attacks of opportunity.

You must present your holy symbol to turn undead. Turning is considered an attack.

Times per Day You may attempt to turn undead a number of times per day equal to 3 + your Charisma
modifier. You can increase this number by taking the Extra Turning feat.

Range You turn the closest turnable undead first, and you canÕt turn undead that are more than 60
feet away or that have total cover relative to you. You donÕt need line of sight to a target, but
you do need line of effect.

Turning Check The first thing you do is roll a turning check to see how powerful an undead creature
you can turn. This is a Charisma check (1d20 + your Charisma modifier). Table: Turning Undead gives
you the Hit Dice of the most powerful undead you can affect, relative to your level. On a given
turning attempt, you can turn no undead creature whose Hit Dice exceed the result on this table.

Turning Damage If your roll on Table: Turning Undead is high enough to let you turn at least some of
the undead within 60 feet, roll 2d6 + your cleric level + your Charisma modifier for turning damage.
ThatÕs how many total Hit Dice of undead you can turn.

If your Charisma score is average or low, itÕs possible to roll fewer Hit Dice of undead turned than
indicated on Table: Turning Undead.

You may skip over already turned undead that are still within range, so that you do not waste your
turning capacity on them.

Effect and Duration of Turning Turned undead flee from you by the best and fastest means available
to them. They flee for 10 rounds (1 minute). If they cannot flee, they cower (giving any attack
rolls against them a +2 bonus). If you approach within 10 feet of them, however, they overcome being
turned and act normally. (You can stand within 10 feet without breaking the turning effectÑyou just
canÕt approach them.) You can attack them with ranged attacks (from at least 10 feet away), and
others can attack them in any fashion, without breaking the turning effect.

Destroying Undead If you have twice as many levels (or more) as the undead have Hit Dice, you
destroy any that you would normally turn.

Evil Clerics and Undead Evil clerics channel negative energy to rebuke (awe) or command (control)
undead rather than channeling positive energy to turn or destroy them. An evil cleric makes the
equivalent of a turning check. Undead that would be turned are rebuked instead, and those that would
be destroyed are commanded.

Rebuked A rebuked undead creature cowers as if in awe (attack rolls against the creature get a +2
bonus). The effect lasts 10 rounds.

Commanded A commanded undead creature is under the mental control of the evil cleric. The cleric
must take a standard action to give mental orders to a commanded undead. At any one time, the cleric
may command any number of undead whose total Hit Dice do not exceed his level. He may voluntarily
relinquish command on any commanded undead creature or creatures in order to command new ones.

Dispelling Turning An evil cleric may channel negative energy to dispel a good clericÕs turning
effect. The evil cleric makes a turning check as if attempting to rebuke the undead. If the turning
check result is equal to or greater than the turning check result that the good cleric scored when
turning the undead, then the undead are no longer turned. The evil cleric rolls turning damage of
2d6 + cleric level + Charisma modifier to see how many Hit Dice worth of undead he can affect in
this way (as if he were rebuking them).

Bolstering Undead An evil cleric may also bolster undead creatures against turning in advance. He
makes a turning check as if attempting to rebuke the undead, but the Hit Dice result on Table:
Turning Undead becomes the undead creaturesÕ effective Hit Dice as far as turning is concerned
(provided the result is higher than the creaturesÕ actual Hit Dice). The bolstering lasts 10 rounds.
An evil undead cleric can bolster himself in this manner.

Neutral Clerics and Undead A cleric of neutral alignment can either turn undead but not rebuke them,
or rebuke undead but not turn them. See Turn or Rebuke Undead for more information.

Even if a cleric is neutral, channeling positive energy is a good act and channeling negative energy
is evil.

Paladins and Undead Beginning at 4th level, paladins can turn undead as if they were clerics of
three levels lower than they actually are.

Turning Other Creatures Some clerics have the ability to turn creatures other than undead.

The turning check result is determined as normal.


*/
//:: 9/06/06 - BDF-OEI: removed the outsider SR consideration b/c without Planar Turning feat
//:: it can be practiaclly impossible to turn any mid-level outsider that has 20 SR
//:: 10/18/06 - BDF(OEI): added the CSLGetHasEffectType check so that turned undead don't count against the HD (turn damage); per 3.5
//:: added various Print functions to provide better feedback for outcome
//:: AFW-OEI 02/08/2007: Planar Turning is back in.

#include "_HkSpell"

//const int STRREF_TURNING_CHECK = 0;
const int STRREF_TURNING_LEVEL = 184687;
const int STRREF_TURNING_DAMAGE = 184688;
const int STRREF_TURNING_ATTEMPT = 184689;
const int STRREF_TURNING_SUCCESS = 184690;
const int STRREF_TURNING_DESTROYED = 184691;
const int STRREF_TURNING_FAILED = 184692;
const int STRREF_HD_EXPENDED = 184693;

const int TURN_RESULT_FAILURE = 0;
const int TURN_RESULT_SUCCESS = 1;
const int TURN_RESULT_DESTROYED = 2;

//void PrintTurningCheck( int nd20, int nChrMod );
void PrintTurningLevel( int nTurnLevel, object oCaster=OBJECT_SELF );
void PrintTurningDamage( int n2d6, int nChrMod, int nClassLevel, object oCaster=OBJECT_SELF );
void PrintTurningResult( object oTarget, int nClassLevel, int nTurnLevel, int nHDRemaining, int iResult = TURN_RESULT_FAILURE, object oCaster=OBJECT_SELF );



int IsTurnTargetValid(object oTarget, int nElemental, int nVermin, int nConstructs, int nPlanar);

int IsTurnTargetValid(object oTarget, int nElemental, int nVermin, int nConstructs, int nPlanar)
{

	if (nElemental)
	{
 		if (CSLGetIsElemental(oTarget))
			return TRUE;
	}
	if (nVermin)
	{
 		if (CSLGetIsVermin(oTarget))
			return TRUE;
	}	
	if (nConstructs)
	{
 		if (CSLGetIsConstruct(oTarget))
			return TRUE;
	}
	if (nPlanar)
	{
 		if (CSLGetIsOutsider(oTarget))
			return TRUE;
	}
 	if (CSLGetIsUndead(oTarget))
		return TRUE;				

	return FALSE;
}
/* Need to add in commanding undead as well for evil clerics, and perhaps features to rebuke and command devils and angels as well */
void main()
{
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_TURN_UNDEAD; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFX_FEAT_TURN_UNDEAD;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_GOOD, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	int nClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster);
	int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN, oCaster);
	int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCaster);
	int nWarpriestLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST, oCaster);
	int nMoRLevel = GetLevelByClass(CLASS_MASTER_RADIANCE, oCaster);
	int nDoomguideLevel = GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oCaster);
	int nShadStalkerLevel = GetLevelByClass(CLASS_SHADOWBANE_STALKER, oCaster);
	int nCotSFLevel = GetLevelByClass(CLASS_CHAMP_SILVER_FLAME);
	int nEldDiscLevel = GetLevelByClass(CLASS_ELDRITCH_DISCIPLE);
	int nTotalLevel =  GetHitDice( oCaster);

	int nTurnLevel = nClericLevel;
	int nClassLevel = nClericLevel;

	// GZ: Since paladin levels stack when turning, blackguard levels should stack as well
	// GZ: but not with the paladin levels (thus else if).
	if((nBlackguardlevel - 2) > 0 && (nBlackguardlevel > nPaladinLevel))
	{
			nClassLevel += (nBlackguardlevel - 2);
			nTurnLevel  += (nBlackguardlevel - 2);
	}
	else if((nPaladinLevel - 3) > 0)
	{
// JLR - OEI 06/21/05 NWN2 3.5
			nClassLevel += (nPaladinLevel - 3);
			nTurnLevel  += (nPaladinLevel - 3);
	}
	
	if (nWarpriestLevel > 0)
	{
        nClassLevel += nWarpriestLevel;
        nTurnLevel  += nWarpriestLevel;	
	}
	
	if (nMoRLevel > 0)
	{
        nClassLevel += nMoRLevel;
        nTurnLevel  += nMoRLevel;		
	}

	if (nDoomguideLevel > 0)
	{
        nClassLevel += nDoomguideLevel;
        nTurnLevel  += nDoomguideLevel;	
	}	
	
	if (nShadStalkerLevel > 0)	

	{
        nClassLevel += nShadStalkerLevel;
        nTurnLevel  += nShadStalkerLevel;	
	}
	
	if (nCotSFLevel > 0)
	{
		nClassLevel += nCotSFLevel;
		nTurnLevel += nCotSFLevel;
	}
	
	if (nEldDiscLevel > 0)	
	{
		nClassLevel += nEldDiscLevel;
		nTurnLevel += nEldDiscLevel;
	}
	
	//Flags for bonus turning types
	int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER, oCaster) + GetHasFeat(FEAT_EARTH_DOMAIN_POWER, oCaster) + GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oCaster) + GetHasFeat(FEAT_WATER_DOMAIN_POWER, oCaster);
	int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER, oCaster);// + GetHasFeat(FEAT_ANIMAL_COMPANION, oCaster);
	int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER, oCaster);
	int nGoodOrEvilDomain =  GetHasFeat(FEAT_GOOD_DOMAIN_POWER, oCaster) + GetHasFeat(FEAT_EVIL_DOMAIN_POWER, oCaster);
	int nPlanar = GetHasFeat(FEAT_EPIC_PLANAR_TURNING, oCaster); // AFW-OEI 02/08/2007: Planar turning is back in.
	int nEmpower = GetHasFeat(FEAT_EMPOWER_TURNING, oCaster);
	int nImprovedTurning = GetHasFeat(FEAT_IMPROVED_TURNING, oCaster);
	int nKelemvorsBoon = GetHasFeat(FEAT_KELEMVORS_BOON, oCaster);
	
	if ( nKelemvorsBoon )
    {
		nClassLevel += nDoomguideLevel;
		nTurnLevel += nDoomguideLevel;	
    }
    
	if ( nImprovedTurning )
	{
		nClassLevel++;
		nTurnLevel++;
	}		
	
	// Area Modifiers Boost
	int iAreaTurningBoost = CSLReadIntModifier( oCaster, "TurnAdj" );
	if ( iAreaTurningBoost != 0 )
	{
		nClassLevel += iAreaTurningBoost;
		nTurnLevel += iAreaTurningBoost;
	}
	
    //Flag for improved turning ability
    int nSun = GetHasFeat(FEAT_SUN_DOMAIN_POWER, oCaster);	
    
	
	//IsModuleSupported(oCaster);
	// int nUseAlternateTurnUndeadRules = GetLocalInt(GetModule(), "UseAlternateTurnUndeadRules");	
	//int nPaladinOnlyAlternateTurnUndeadRule = GetLocalInt(GetModule(), "PaladinOnlyAlternateTurnUndeadRule");	

	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	
	// 
	if ( CSLGetPreferenceSwitch("UseAlternateTurnUndeadRules",FALSE) || ( nPaladinLevel > 3 && CSLGetPreferenceSwitch("PaladinOnlyAlternateTurnUndeadRule",FALSE) ) )
	{
		//Do Damage Routine
	    int nCha = GetAbilityModifier(ABILITY_CHARISMA);
		int iDamage;
		int iDC = nTurnLevel + 10 + nCha;
		
	    effect eVis = EffectVisualEffect( VFX_HIT_TURN_UNDEAD );
		effect eDamage;
			
		location lMyLocation = GetLocation( oCaster );
	    effect eImpactVis = EffectVisualEffect(VFX_FEAT_TURN_UNDEAD);
	    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lMyLocation);
	
		float fSize = 2.0 * RADIUS_SIZE_COLOSSAL;
		object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );	
	    while( GetIsObjectValid(oTarget))
	    {
	        if( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster )
	        {
	                if (IsTurnTargetValid(oTarget, nElemental, nVermin, nConstructs, nPlanar + nGoodOrEvilDomain ))
	                {
	                        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_TURN_UNDEAD));
	                        DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
							iDamage = d6(nTurnLevel);
							//
							//if (WillSave(oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster) == SAVING_THROW_CHECK_SUCCEEDED)
							//{
							//	iDamage = iDamage/2;
							//}
							//*/
							// need to review, this was set up to possibly do damage if immune
							iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster );
		           
							eDamage = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
	                        DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));						
	                }
	        }
			oTarget = GetNextObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
	    }		
	
	}
	else // Do as normal
	{
	
		//Flag for improved turning ability
		int nSun = GetHasFeat(FEAT_SUN_DOMAIN_POWER, oCaster);
	
		//Make a turning check roll, modify if have the Sun Domain
		int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
		int nTurnCheck = d20();              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
		if(nSun == TRUE)
		{
				nTurnCheck += d4();
		}
		//PrintTurningCheck( nTurnCheck, nChrMod );
		nTurnCheck += nChrMod;
		
		//Determine the maximum HD of the undead that can be turned.
		if(nTurnCheck <= 0)
		{
				nTurnLevel -= 4;
		}
		else if(nTurnCheck >= 1 && nTurnCheck <= 3)
		{
				nTurnLevel -= 3;
		}
		else if(nTurnCheck >= 4 && nTurnCheck <= 6)
		{
				nTurnLevel -= 2;
		}
		else if(nTurnCheck >= 7 && nTurnCheck <= 9)
		{
				nTurnLevel -= 1;
		}
		else if(nTurnCheck >= 10 && nTurnCheck <= 12)
		{
				//Stays the same
		}
		else if(nTurnCheck >= 13 && nTurnCheck <= 15)
		{
				nTurnLevel += 1;
		}
		else if(nTurnCheck >= 16 && nTurnCheck <= 18)
		{
				nTurnLevel += 2;
		}
		else if(nTurnCheck >= 19 && nTurnCheck <= 21)
		{
				nTurnLevel += 3;
		}
		else if(nTurnCheck >= 22)
		{
				nTurnLevel += 4;
		}
		
		PrintTurningLevel( nTurnLevel );
		
		int nTurnHD = d6(2);
		if(nSun == TRUE)
		{
				nTurnHD += d6();
		}
		PrintTurningDamage( nTurnHD, nChrMod, nClassLevel );
		nTurnHD += (nChrMod + nClassLevel);   //The number of HD of undead that can be turned.
		
		// JWR-OEI 05/22/2008 - New Turning Feat "Empower Turning"
		if ( nEmpower )
		{
			//object opc = GetFirstPC();
			nTurnHD += (nTurnHD/2);
		}
		
		//Gets all creatures in a 20m radius around the caster and turns them or not.  If the creatures
		//HD are 1/2 or less of the nClassLevel then the creature is destroyed.
		//int nCnt = 1; // 6/26/06 - BDF-OEI: no longer necessary with GetNthObjectInShape()
		int iHD, nRacial, nHDCount, bValid, iDamage, nDex;
		nHDCount = 0;
		effect eVis = EffectVisualEffect( VFX_HIT_TURN_UNDEAD ); // only used for the impact effect on constructs; all other impact effects will be as specified in VFX_FEAT_TURN_UNDEAD
		
		
		//effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR); // no longer using NWN1 VFX
			
		effect eVisTurn = EffectVisualEffect( VFX_HIT_TURN_UNDEAD ); // makes use of NWN2 VFX
		effect eDamage;
		effect eAC = EffectACDecrease( 2 ); //Rebuke behavior, lowers AC by 2.
		
		effect eTurned = EffectTurned();
		effect eDur = EffectVisualEffect(882);
		effect eLink = EffectLinkEffects(eVisTurn, eTurned);
		eLink = EffectLinkEffects( eLink, eAC );
		eLink = EffectLinkEffects(eLink, eDur);
	
		effect eDeath = SupernaturalEffect(EffectDeath(TRUE));
		location lMyLocation = GetLocation( oCaster );
	
		effect eImpactVis = EffectVisualEffect(VFX_FEAT_TURN_UNDEAD); // no longer using NWN1 VFX
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lMyLocation); // no longer using NWN1 VFX
	
		//Get nearest enemy within 20m (60ft)
		//Why are you using GetNearest instead of GetFirstObjectInShape
		//object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE , oCaster, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
		//6/26/06 - BDF-OEI: sounds good to me
		float fSize = 2.0 * RADIUS_SIZE_COLOSSAL; // RADIUS_SIZE_COLOSSAL ~= 30.0 ft
		object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
	
		//SpawnScriptDebugger();
		
		while( GetIsObjectValid(oTarget) && nHDCount < nTurnHD )
		{
				if( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster ) // AFW-OEI 06/28/2006: Hopefully, the CSLSpellsIsTarget finally excludes all friendlies
				{
					nRacial = GetRacialType(oTarget);
					nDex = GetAbilityScore( oTarget, ABILITY_DEXTERITY );

				
					iHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
	
					if(iHD <= nTurnLevel && iHD <= (nTurnHD - nHDCount))
					{
						//Check the various domain turning types
						// 10/18/06 - BDF(OEI): added the CSLGetHasEffectType check so that turned undead don't count against the HD (turn damage); per 3.5
						if( CSLGetIsUndead( oTarget ) && !CSLGetHasEffectType( oTarget, EFFECT_TYPE_TURNED ) )
						{
								bValid = TRUE;
						}
						else if ( CSLGetIsVermin( oTarget) && nVermin > 0)
						{
								bValid = TRUE;
						}
						else if ( CSLGetIsElemental( oTarget) && nElemental > 0)
						{
								bValid = TRUE;
						}
						else if ( CSLGetIsConstruct( oTarget) && nConstructs > 0)
						{
								SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_TURN_UNDEAD));
								iDamage = d3(nTurnLevel);
								eDamage = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
								HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
								DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
								nHDCount += iHD;
						}
						else if ( CSLGetIsOutsider(oTarget) && (nGoodOrEvilDomain+nPlanar > 0) && !CSLGetHasEffectType(oTarget, EFFECT_TYPE_TURNED) )
						{
								bValid = TRUE;
						}
						// * if wearing gauntlets of the lich,then can be turned
						else if (GetIsObjectValid(GetItemPossessedBy(oTarget, "x2_gauntletlich")) == TRUE)
						{
								if (GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS)) == "x2_gauntletlich")
								{
									bValid = TRUE;
								}
						}
	
						//Apply results of the turn
						if( bValid == TRUE)
						{
								//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
								if ( CSLGetIsOutsider(oTarget))
								{
									effect ePlane = EffectVisualEffect( VFX_HIT_SPELL_HOLY );
									HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePlane, oTarget);
								}
								//if(IntToFloat(nClassLevel)/2.0 >= IntToFloat(iHD))
								//{
	
								if((nClassLevel/2) >= iHD)
								{
									if ( CSLGetIsOutsider(oTarget) )
									{
										effect ePlane2 = EffectVisualEffect( VFX_IMP_UNSUMMON );
										HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePlane2, oTarget);
									}
	
									//effect ePlane2 = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY); // no longer using NWN1 VFX
									effect ePlane2 = EffectVisualEffect( VFX_HIT_SPELL_HOLY ); // makes use of NWN2 VFX
	
									//Fire cast spell at event for the specified target
									SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_TURN_UNDEAD));
									PrintTurningResult( oTarget, nClassLevel, nTurnLevel, (nTurnHD - nHDCount), TURN_RESULT_DESTROYED );
									//Destroy the target
									DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
								}
								else
								{
									//Turn the target
									//Fire cast spell at event for the specified target
									SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_TURN_UNDEAD));
									AssignCommand(oTarget, ActionMoveAwayFromObject(oCaster, TRUE));
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10));
									PrintTurningResult( oTarget, nClassLevel, nTurnLevel, (nTurnHD - nHDCount), TURN_RESULT_SUCCESS );
							
									//Rebuke behavior.  If the target has Dex greater than 10, this logic reduces it to 10, everyone else is left alone.
									if ( nDex>10 )
									{
										int nDecrease = (nDex - 10);
										effect eDec = EffectAbilityDecrease( ABILITY_DEXTERITY, nDecrease);
										HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDec, oTarget, RoundsToSeconds(10));
									}
								}
								nHDCount = nHDCount + iHD;
						}
					}
					else if ( CSLGetIsUndead( oTarget ) || ( CSLGetIsOutsider(oTarget) && (nGoodOrEvilDomain+nPlanar > 0 ) )  || ( CSLGetIsConstruct(oTarget) && ( nConstructs > 0 ) ) || ( CSLGetIsElemental(oTarget) && ( nElemental > 0 ) ) || ( CSLGetIsVermin(oTarget) && ( nVermin > 0 ) )  )
					{
						PrintTurningResult( oTarget, nClassLevel, nTurnLevel, (nTurnHD - nHDCount) );
					}
				
					bValid = FALSE;
				}
				//nCnt++;
				//oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE, oCaster, nCnt,CREATURE_TYPE_PERCEPTION , PERCEPTION_SEEN);
				oTarget = GetNextObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
		}
	}
	HkPostCast(oCaster);
}

// Chat window feeback for the turn attempt
/*
void PrintTurningCheck( int nd20, int nChrMod )
{
	string sName = GetName( oCaster );
	string sd20 = IntToString( nd20 );
	string sChrMod = IntToString( nChrMod );
	string sResult = IntToString( nd20 + nChrMod );
	string sLocalizedText = GetStringByStrRef( STRREF_TURNING_CHECK );
	string sTurningCheckFeedbackMsg = "<c=paleturquoise>" +
										sName +
										"</c><c=tomato> : Turning Check : " sLocalizedText +
										sResult +
										" : (" +
										sd20 +
										" + " +
										sChrMod +
										" = " +
										sResult +
										")</c>";

	SendMessageToPC( oCaster, sTurningCheckFeedbackMsg );
}
*/

void PrintTurningLevel( int nTurnLevel, object oCaster=OBJECT_SELF )
{
	string sName = GetName( oCaster );
	string sTurnLevel = IntToString( nTurnLevel );
	string sLocalizedText = GetStringByStrRef( STRREF_TURNING_LEVEL );
	string sTurningLevelFeedbackMsg = "<c=tomato>" + sLocalizedText + " : </c>" +  sTurnLevel;

	SendMessageToPC( oCaster, sTurningLevelFeedbackMsg );
}

void PrintTurningDamage( int n2d6, int nChrMod, int nClassLevel, object oCaster=OBJECT_SELF )
{
	string sName = GetName( oCaster );
	string s2d6 = IntToString( n2d6 );
	string sChrMod = IntToString( nChrMod );
	string sClassLevel = IntToString( nClassLevel );
	
	// had to change this WACK system to support the 
	// Empower Turning Feat JWR-OEI 05/21/08
	int iResult =  n2d6 + nChrMod + nClassLevel ;
	if (GetHasFeat(FEAT_EMPOWER_TURNING, oCaster) )
	{ 
		iResult += (iResult/2);
	}
	string sResult = IntToString(iResult);
	string sLocalizedText = GetStringByStrRef( STRREF_TURNING_DAMAGE );
	string sTurningDamageFeedbackMsg = "<c=tomato>" + sLocalizedText + " : </c>" + sResult;
	
	SendMessageToPC( oCaster, sTurningDamageFeedbackMsg );
}

void PrintTurningResult( object oTarget, int nClassLevel, int nTurnLevel, int nHDRemaining, int iResult = TURN_RESULT_FAILURE, object oCaster=OBJECT_SELF )
{
	string sName = GetName( oCaster );
	int nTargetHD = GetHitDice( oTarget ) + GetTurnResistanceHD( oTarget );
	string sTargetHD = IntToString( nTargetHD );
	string sTargetName = GetName( oTarget );
	string sTurnLevel = IntToString( nTurnLevel );
	string sHDRemaining = IntToString( nHDRemaining );
	string sHalfClassLevel = IntToString( nClassLevel / 2 );
	string sLocalizedTextAttempt = GetStringByStrRef( STRREF_TURNING_ATTEMPT );
	string sLocalizedTextResultFailure = GetStringByStrRef( STRREF_TURNING_FAILED );
	string sLocalizedTextResultSuccess = GetStringByStrRef( STRREF_TURNING_SUCCESS );
	string sLocalizedTextResultDestroyed = GetStringByStrRef( STRREF_TURNING_DESTROYED );
	string sLocalizedTextHDExpended = GetStringByStrRef( STRREF_HD_EXPENDED );
	string sTurningDamageFeedbackMsg = "<c=paleturquoise>" + sName + " " + sLocalizedTextAttempt + " " + sTargetName + " : </c><c=tomato>";
	
	if ( iResult == TURN_RESULT_SUCCESS )
	{
		sTurningDamageFeedbackMsg += ( sLocalizedTextResultSuccess + " (" + sTargetHD + " " + sLocalizedTextHDExpended + ")</c>" );
	}
	else if ( iResult == TURN_RESULT_DESTROYED )
	{
		sTurningDamageFeedbackMsg += ( sLocalizedTextResultDestroyed + " (" + sTargetHD + " " + sLocalizedTextHDExpended + ")</c>" );
	}
	else
	{
		sTurningDamageFeedbackMsg += sLocalizedTextResultFailure + "</c>";
	}
	
	SendMessageToPC( oCaster, sTurningDamageFeedbackMsg );
}
		

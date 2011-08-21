/** @file
* @brief Include File for Bard Song Magic
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/




//#include "ginc_item"
//#include "x0_i0_assoc"
//#include "x0_i0_match"
//#include "x0_i0_petrify"
//#include "x0_i0_position"
//#include "x0_i0_common"

//#include "x2_inc_switches"
//#include "_inc_propertystrings"

#include "_HkSpell"
#include "_CSLCore_Items"

/*
// * Applies ability score damage
void SCDoDirgeEffect(object oTarget);
*/




///////////////////////////////////////////////////////////////////////////////
// SCGetIsObjectValidSongTarget
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz
// Created On: 09/09/2005
// Description:   Used to determine if the object is a valid target for a song.
//          Note that this only checks to see if they can hear the bard
//          If s/he can, it returns TRUE. If s/he can't, it will return
//          FALSE;
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: added the check to see if the target is dead
int SCGetIsObjectValidSongTarget( object oTarget, float fRadius = 0.0)
{

	if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ))
	{
		// it can't hear me
			return FALSE;
	}

	if ( GetRacialType( oTarget ) == RACIAL_TYPE_INVALID )
	{
		// It's a harmonica
		return FALSE;
	}

	if ( GetIsDead(oTarget) )
	{
		return FALSE;
	}
	
	int bBOOL = !CSLIsClose( OBJECT_SELF, oTarget, fRadius );
	if ( bBOOL )
	{
		return FALSE;
	}
	
	return TRUE;
}


///////////////////////////////////////////////////////////////////////////////
// SCApplySongDurationFeatMods
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz
// Created On: 09/09/2005
// Description:   Returns a modified duration (assumed to be rounds), based
//          any feats or other items the bard has
///////////////////////////////////////////////////////////////////////////////
int SCApplySongDurationFeatMods( int iDuration, object oBard )
{

	if( GetHasFeat(FEAT_EPIC_LASTING_INSPIRATION, oBard) )
	{
			iDuration *= 10;
	}

	if( GetHasFeat(FEAT_LINGERING_SONG, oBard) )
	{
			iDuration += 5;
	}

	return iDuration;
}


///////////////////////////////////////////////////////////////////////////////
// SCGetHasMatchingEffect
///////////////////////////////////////////////////////////////////////////////
// Created By: Jesse Reynolds (JLR-OEI)
// Created On: 04/06/2006:
// Description:   Find an Effect that matches given info...
///////////////////////////////////////////////////////////////////////////////
int SCGetHasMatchingEffect( int nEffectType, int nEffectSubType, object oTarget = OBJECT_SELF )
{
	effect eCheck = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eCheck))
	{
			if(GetEffectType(eCheck) == nEffectType)
			{
				return TRUE;
			}
			eCheck = GetNextEffect(oTarget);
	}
	return FALSE;
}


///////////////////////////////////////////////////////////////////////////////
// SCFindEffectSpellId
///////////////////////////////////////////////////////////////////////////////
// Created By: Jesse Reynolds (JLR-OEI)
// Created On: 04/06/2006:
// Description:   Find the Effect matching a type, and return the associated SpellId...
///////////////////////////////////////////////////////////////////////////////
int SCFindEffectSpellId( int nEffectType, object oTarget = OBJECT_SELF )
{
	effect eCheck = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eCheck))
	{
			if(GetEffectType(eCheck) == nEffectType)
			{
				return GetEffectInteger(eCheck, 0);
			}
			eCheck = GetNextEffect(oTarget);
	}
	return -1;
}


///////////////////////////////////////////////////////////////////////////////
// SCRemoveBardSongSingingEffect
///////////////////////////////////////////////////////////////////////////////
// Created By: Jesse Reynolds (JLR-OEI)
// Created On: 04/11/2006:
// Description:   Find the singing effect if it exists, and destroy it
///////////////////////////////////////////////////////////////////////////////
void SCRemoveBardSongSingingEffect( object oTarget, int iSpellId )
{
	effect eCheck = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eCheck))
	{
			if(GetEffectType(eCheck) == EFFECT_TYPE_BARDSONG_SINGING)
			{
				if(GetEffectInteger(eCheck, 0) == iSpellId)
				{
						RemoveEffect(oTarget, eCheck);
						return;
				}
			}
			eCheck = GetNextEffect(oTarget);
	}
}


///////////////////////////////////////////////////////////////////////////////
// SCAttemptNewSong
///////////////////////////////////////////////////////////////////////////////
// Created By: Jesse Reynolds (JLR-OEI)
// Created On: 04/06/2006:
// Description:   Remove old Song if there is one...
///////////////////////////////////////////////////////////////////////////////
int SCAttemptNewSong( object oCaster, int bIsPersistent = FALSE )
{
	int nSingingSpellId = SCFindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING, oCaster);

	// First, try to break the old one...
	if(nSingingSpellId != -1)
	{
			// Remove it...
			SCRemoveBardSongSingingEffect(oCaster, nSingingSpellId);
	}

	if(bIsPersistent)
	{
			// Only start it up if we weren't cancelling it...
			if(nSingingSpellId != GetSpellId())
			{
				// Now add new singing Effect
				effect eBardSong = EffectBardSongSinging(GetSpellId());
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBardSong, oCaster, 0.0f, GetSpellId() );
				return TRUE;
			}
			return FALSE;
	}

	return TRUE;
}


///////////////////////////////////////////////////////////////////////////////
// SCApplyFriendlySongEffectsToArea
///////////////////////////////////////////////////////////////////////////////
// Created By: Jesse Reynolds (JLR-OEI)
// Created On: 04/05/2006:
// Description:   Does the actual application of linked effects to targets
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: replaced some conditionals with SCGetIsObjectValidSongTarget
//::  which unifies those checks into a single function; added CSLSpellsIsTarget for filtering targets
void SCApplyFriendlySongEffectsToArea( object oCaster, int iSpellId, float fDuration, float fRadius, effect eLink )
{
	//int iLevel      = GetLevelByClass(CLASS_TYPE_BARD);
	//SpeakString("Level: " + IntToString(iLevel) + " Ranks: " + IntToString(nRanks));

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
		
	// AFW-OEI 07/17/2006: Because the caster will already have the EFFECT_BARDSONG_SINGING
	// effect on him, we need to do some shenanigans to see if that's the only effect
	// w/ that bardsong ID.  If it is, we need to apply the bonuses for the first time.
	int bCasterAlreadyHasBardsongEffects = FALSE;
	effect eCheck = GetFirstEffect(oCaster);
	while(GetIsEffectValid(eCheck))
	{
		if (GetEffectSpellId(eCheck) == iSpellId && GetEffectType(eCheck) != EFFECT_TYPE_BARDSONG_SINGING)
		{
			//SpeakString("nwn2_inc_spells::ApplyFriendlySongEffectToArea(): Has bardsong effects other than BARDSONG_SINGING.");   // DEBUGGING
			bCasterAlreadyHasBardsongEffects = TRUE;
			break;
		}
		eCheck = GetNextEffect(oCaster);
	}
	
	while(GetIsObjectValid(oTarget))
	{
		//int nRacialType = GetRacialType(oTarget);
			
		// AFW-OEI 07/02/2007: Inspire Regen does not affect undead or constructs
		if ( SCGetIsObjectValidSongTarget(oTarget) && !( (iSpellId == SPELLABILITY_SONG_INSPIRE_REGENERATION) && ( CSLGetIsConstruct( oTarget, TRUE ) || CSLGetIsUndead( oTarget, TRUE ) ) ) )
		{
			if( (!GetHasSpellEffect(iSpellId,oTarget)) || (oTarget == oCaster && !bCasterAlreadyHasBardsongEffects) )
			{
				if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) )
				{
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oCaster, SPELLABILITY_DRPIRATE_RALLY_THE_CREW );
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
					eLink = SetEffectSpellId( eLink, iSpellId );
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId);
				}
			}
			else
			{
				// Refresh the duration
				RefreshSpellEffectDurations(oTarget, iSpellId, fDuration);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	}
}


///////////////////////////////////////////////////////////////////////////////
// SCApplyFriendlySongEffectsToParty
///////////////////////////////////////////////////////////////////////////////
// Created By: Jesse Reynolds (JLR-OEI)
// Created On: 04/06/2006:
// Description:   Does the actual application of linked effects to the entire party
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: replaced some conditionals with SCGetIsObjectValidSongTarget
//::  which unifies those checks into a single function
void SCApplyFriendlySongEffectsToParty( object oCaster, int iSpellId, float fDuration, effect eLink )
{
	object oLeader = oCaster; // GetFactionLeader( oCaster );
	object oTarget = GetFirstFactionMember( oLeader, FALSE);
	while ( GetIsObjectValid( oTarget ) )
	{
		//if ( !GetIsDead(oTarget) )  // 7/31/06 - BDF: added this check to avoid applying effects to corpses
		if ( SCGetIsObjectValidSongTarget(oTarget, RADIUS_SIZE_COLOSSAL) )
		{
				//if (!CSLGetHasEffectType( oTarget, EFFECT_TYPE_SILENCE ) && !CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ))
				//{
					if(!GetHasSpellEffect(iSpellId,oTarget))
					{
						//Fire cast spell at event for the specified target
						SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	
						//Apply the VFX impact and effects
						eLink            = SetEffectSpellId( eLink, iSpellId );
						HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId );
					}
					else
					{
						// Refresh the duration, *IFF doesn't already have the effect!*
						RefreshSpellEffectDurations(oTarget, iSpellId, fDuration);
					}
				//}
		}
		
			oTarget = GetNextFactionMember( oLeader, FALSE);
	}
}


///////////////////////////////////////////////////////////////////////////////
// SCApplyFriendlySongEffectsToTarget
///////////////////////////////////////////////////////////////////////////////
// Created By: Jesse Reynolds (JLR-OEI)
// Created On: 04/06/2006:
// Description:   Does the actual application of linked effects to a specific target
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: replaced some conditionals with SCGetIsObjectValidSongTarget
//::  which unifies those checks into a single function; added CSLSpellsIsTarget for filtering targets
void SCApplyFriendlySongEffectsToTarget( object oCaster, int iSpellId, float fDuration, effect eLink )
{
	object oTarget = HkGetSpellTarget();

	effect eVis    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );

	effect eImpact = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_SPELL_SONIC) );   // AFW-OEI 07/18/2007: NWN2 VFX
	effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_FNF_LOS_NORMAL_30) );
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oCaster));

	if(GetIsObjectValid(oTarget))
	{
		//if ( !GetIsDead(oTarget) )  // 7/31/06 - BDF: added this check to avoid applying effects to corpses
		if ( SCGetIsObjectValidSongTarget(oTarget) )
		{
				if(!GetHasSpellEffect(iSpellId,oTarget))
				{
					//if (!CSLGetHasEffectType( oTarget, EFFECT_TYPE_SILENCE ) && !CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ))
					//{
						//Fire cast spell at event for the specified target
						SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	
						if(oTarget == oCaster)
						{
								effect eLinkBard = ExtraordinaryEffect( EffectLinkEffects(eLink, eVis) );
								eLinkBard        = SetEffectSpellId( eLinkBard, iSpellId );
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, fDuration, iSpellId);
						}
						//else if(GetIsFriend(oTarget) || GetFactionEqual(oTarget))
					else if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) )
						{
								eLink            = SetEffectSpellId( eLink, iSpellId );
								eImpact          = SetEffectSpellId( eImpact, iSpellId );
								HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId);
						}
					//}
				}
				else
				{
					// Refresh the duration
					RefreshSpellEffectDurations(oTarget, iSpellId, fDuration);
				}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// SCApplyHostileSongEffectsToArea
///////////////////////////////////////////////////////////////////////////////
// Created By: Jesse Reynolds (JLR-OEI)
// Created On: 04/05/2006:
// Description:   Does the actual application of linked effects to targets
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: replaced some conditionals with SCGetIsObjectValidSongTarget
//::  which unifies those checks into a single function; added CSLSpellsIsTarget for filtering targets
///////////////////////////////////////////////////////////////////////////////
//:: 10/23/06 - BDF-OEI: changed the filter parameter in CSLSpellsIsTarget from
//    STANDARDHOSTILE to SELECTIVEHOSTILE; the old way was applying effects
//    to friendlies in Hardcore difficulty, but that's not really what
//    bard songs are all about.
void SCApplyHostileSongEffectsToArea( object oCaster, int iSpellId, float fDuration, float fRadius, effect eLink, int iSaveType = -1, int iSaveDC = 0 )
{
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));

	while(GetIsObjectValid(oTarget))
	{
		//if ( !GetIsDead(oTarget) )  // 7/31/06 - BDF: added this check to avoid applying effects to corpses
		if ( SCGetIsObjectValidSongTarget(oTarget) )
		{
				if(!GetHasSpellEffect(iSpellId,oTarget))
				{
					//if (!CSLGetHasEffectType( oTarget, EFFECT_TYPE_SILENCE ) && !CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ))
					//{
						//if(!GetIsFriend(oTarget) && !GetFactionEqual(oTarget))
					if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster) )  // 10/23/06 - BDF(OEI): was STANDARDHOSTILE
						{
								//Fire cast spell at event for the specified target
								SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
	
								// Make Save to negate
								if ((iSaveType == -1) || !HkSavingThrow(iSaveType, oTarget, iSaveDC ))
								{
									eLink            = SetEffectSpellId( eLink, iSpellId );
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId);
								}
						}
					//}
				}
				else
				{
					// Refresh the duration
					RefreshSpellEffectDurations(oTarget, iSpellId, fDuration);
				}
		}
		
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	}
}



///////////////////////////////////////////////////////////////////////////////
// SCGetCanBardSing
///////////////////////////////////////////////////////////////////////////////
// Created By: Brock Heinz
// Created On: 09/09/2005
// Description:   Used to determine if the bard can use a song feat. If s/he
//          can, it returns TRUE. If s/he can't, it will display an
//          error string and return FALSE;
///////////////////////////////////////////////////////////////////////////////
int SCGetCanBardSing( object oBard )
{
	if ( CSLGetHasEffectType( oBard, EFFECT_TYPE_SILENCE ))
	{
			FloatingTextStrRefOnCreature(85764, oBard); // * You can not use this feat while silenced *
			return FALSE;
	}

	if ( CSLGetHasEffectType( oBard, EFFECT_TYPE_PARALYZE ) ||
		CSLGetHasEffectType( oBard, EFFECT_TYPE_STUNNED ) ||
		CSLGetHasEffectType( oBard, EFFECT_TYPE_SLEEP )      ||
		CSLGetHasEffectType( oBard, EFFECT_TYPE_PETRIFY ) )
		
	{
		FloatingTextStrRefOnCreature(112849, oBard ); // * You can not use this feat at this time *
		return FALSE;
	}

	return TRUE;
}



//::///////////////////////////////////////////////
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Applies the ability score damage of the dirge effect.

	March 2003
	Because ability score penalties do not stack, I need
	to store the ability score damage done
	and increment each round.
	To that effect I am going to update the description and
	remove the dirge effects if the player leaves the area of effect.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void SCDoDirgeEffect(object oTarget)
{
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, GetAreaOfEffectCreator()))
	{
			//Fire cast spell at event for the target
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId(), TRUE ));
			//Spell resistance check
			if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
			{
			

				//Make a Fortitude Save to avoid the effects of the movement hit.
			if( !HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_ALL, OBJECT_SELF, 0.0 ) )
			{
				//HkSavingThrow( SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_ALL, GetAreaOfEffectCreator()))
				//{
					int nGetLastPenalty = GetLocalInt(oTarget, "X0_L_LASTPENALTY");
					// * increase penalty by 2
					nGetLastPenalty = nGetLastPenalty + 2;

					effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nGetLastPenalty);
					effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nGetLastPenalty);
					//change from sonic effect to bard song...
					//effect eVis =    EffectVisualEffect(VFX_HIT_SPELL_EVOCATION);  // NWN1 VFX
					effect eVis =    EffectVisualEffect( VFX_HIT_SPELL_SONIC );   // NWN2 VFX
					effect eLink = EffectLinkEffects(eDex, eStr);

					//Apply damage and visuals
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					SetLocalInt(oTarget, "X0_L_LASTPENALTY", nGetLastPenalty);
				}

			}
	}
}
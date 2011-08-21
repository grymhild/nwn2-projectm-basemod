/** @file
* @brief Info related functions used to figure out if a creature, spell or item can be categorized in a certain way
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/


/*
These are the basic Utitlities
*/
/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////



/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////

/*
These are a combination of organizing the functions from OEI,
as well as more precise versions which drill down into various things deeper.

The CSLGetIsHumanoid is pretty big bug fix as it puts this important check in a central place.

The Get is Racial types check both classes and racial type, in case module maker forgot one or the other.

*/

/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////


// negative effect bit flags for a creature
//const int HENCH_EFFECT_TYPE_NONE              = 0x0;
const int HENCH_EFFECT_TYPE_ENTANGLE            = 0x1; // 1
const int HENCH_EFFECT_TYPE_PARALYZE            = 0x2; // 2
const int HENCH_EFFECT_TYPE_DEAF                = 0x4; // 3
const int HENCH_EFFECT_TYPE_BLINDNESS           = 0x8; // 4
const int HENCH_EFFECT_TYPE_CURSE               = 0x10; // 5
const int HENCH_EFFECT_TYPE_SLEEP               = 0x20; // 6
const int HENCH_EFFECT_TYPE_CHARMED             = 0x40; // 7
const int HENCH_EFFECT_TYPE_CONFUSED            = 0x80; // 8
const int HENCH_EFFECT_TYPE_FRIGHTENED          = 0x100; // 9
const int HENCH_EFFECT_TYPE_DOMINATED           = 0x200; // 10
const int HENCH_EFFECT_TYPE_DAZED               = 0x400; // 11
const int HENCH_EFFECT_TYPE_POISON              = 0x800; // 12
const int HENCH_EFFECT_TYPE_DISEASE             = 0x1000; // 13
const int HENCH_EFFECT_TYPE_SILENCE             = 0x2000; // 14
const int HENCH_EFFECT_TYPE_SLOW                = 0x4000; // 15
const int HENCH_EFFECT_TYPE_ABILITY_DECREASE    = 0x8000; // 16
const int HENCH_EFFECT_TYPE_DAMAGE_DECREASE     = 0x10000; // 17
const int HENCH_EFFECT_TYPE_ATTACK_DECREASE     = 0x20000; // 18
const int HENCH_EFFECT_TYPE_SKILL_DECREASE      = 0x40000; // 19
//												= 0x80000; // 20
const int HENCH_EFFECT_TYPE_STUNNED             = 0x100000; // 21
const int HENCH_EFFECT_TYPE_PETRIFY             = 0x200000; // 22
const int HENCH_EFFECT_TYPE_MOVEMENT_SPEED_DECREASE = 0x400000; // 23
const int HENCH_EFFECT_TYPE_DEATH               = 0x800000; // 24
const int HENCH_EFFECT_TYPE_NEGATIVELEVEL       = 0x1000000; // 25
const int HENCH_EFFECT_TYPE_AC_DECREASE         = 0x2000000; // 26
const int HENCH_EFFECT_TYPE_SAVING_THROW_DECREASE = 0x4000000; // 27
//const int HENCH_EFFECT_TYPE_KNOCKDOWN			= 0x8000000; // 28
const int HENCH_EFFECT_TYPE_DYING            	= 0x10000000; // 29
const int HENCH_EFFECT_TYPE_MESMERIZE           = 0x20000000; // 30
//const int HENCH_EFFECT_TYPE_SPELL_FAILURE     = 0x40000000; // 31
const int HENCH_EFFECT_TYPE_CUTSCENE_PARALYZE   = 0x80000000; // 32
const int HENCH_EFFECT_DISABLED = 0x303005e2; /*HENCH_EFFECT_TYPE_PARALYZE | HENCH_EFFECT_TYPE_STUNNED |
    HENCH_EFFECT_TYPE_FRIGHTENED | HENCH_EFFECT_TYPE_SLEEP| HENCH_EFFECT_TYPE_DAZED |
    HENCH_EFFECT_TYPE_CONFUSED | HENCH_EFFECT_TYPE_TURNED | HENCH_EFFECT_TYPE_PETRIFY |
    HENCH_EFFECT_TYPE_MESMERIZE; */
const int HENCH_EFFECT_DISABLED_NO_PETRIFY = 0x301005e2; /*HENCH_EFFECT_TYPE_PARALYZE | HENCH_EFFECT_TYPE_STUNNED |
    HENCH_EFFECT_TYPE_FRIGHTENED | HENCH_EFFECT_TYPE_SLEEP| HENCH_EFFECT_TYPE_DAZED |
    HENCH_EFFECT_TYPE_CONFUSED | HENCH_EFFECT_TYPE_TURNED |
    HENCH_EFFECT_TYPE_MESMERIZE; */
const int HENCH_EFFECT_IMPAIRED = 0x01404009; /*HENCH_EFFECT_TYPE_ENTANGLE | HENCH_EFFECT_TYPE_BLINDNESS |
    HENCH_EFFECT_TYPE_SLOW | HENCH_EFFECT_TYPE_MOVEMENT_SPEED_DECREASE | HENCH_EFFECT_TYPE_NEGATIVELEVEL*/
const int HENCH_EFFECT_DISABLED_OR_IMMOBILE = 0xb03005e3; /*HENCH_EFFECT_TYPE_PARALYZE | HENCH_EFFECT_TYPE_STUNNED |
    HENCH_EFFECT_TYPE_FRIGHTENED | HENCH_EFFECT_TYPE_SLEEP| HENCH_EFFECT_TYPE_DAZED |
    HENCH_EFFECT_TYPE_CONFUSED | HENCH_EFFECT_TYPE_TURNED | HENCH_EFFECT_TYPE_PETRIFY |
    HENCH_EFFECT_TYPE_MESMERIZE | HENCH_EFFECT_TYPE_CUTSCENE_PARALYZE | HENCH_EFFECT_TYPE_ENTANGLE; */
const int HENCH_EFFECT_IMMOBILE = 0x80000001; /* HENCH_EFFECT_TYPE_CUTSCENE_PARALYZE | HENCH_EFFECT_TYPE_ENTANGLE; */
const int HENCH_EFFECT_DISABLED_AND_IMMOBILE = 0x10300022; /*HENCH_EFFECT_TYPE_PARALYZE | HENCH_EFFECT_TYPE_STUNNED |
    HENCH_EFFECT_TYPE_SLEEP | HENCH_EFFECT_TYPE_STUNNED | HENCH_EFFECT_TYPE_PETRIFY |
    HENCH_EFFECT_TYPE_DYING; */
const int HENCH_EFFECT_DYING_OR_DEAF = 0x10000004; /* HENCH_EFFECT_TYPE_DYING | HENCH_EFFECT_TYPE_DEAF; */
const int HENCH_EFFECT_DISABLED_INACTIVE_SHORT_DURATION = 0x10100422; /*HENCH_EFFECT_TYPE_PARALYZE | HENCH_EFFECT_TYPE_STUNNED |
     HENCH_EFFECT_TYPE_SLEEP| HENCH_EFFECT_TYPE_DAZED */

// positive effect bit flags for a creature
const int HENCH_EFFECT_TYPE_AC_INCREASE         = 0x1; // 1
const int HENCH_EFFECT_TYPE_REGENERATE          = 0x2; // 2 
const int HENCH_EFFECT_TYPE_ATTACK_INCREASE     = 0x4; // 3
const int HENCH_EFFECT_TYPE_DAMAGE_REDUCTION    = 0x8; // 4
const int HENCH_EFFECT_TYPE_HASTE               = 0x10; // 5
const int HENCH_EFFECT_TYPE_TEMPORARY_HITPOINTS = 0x20;  // 6
const int HENCH_EFFECT_TYPE_SANCTUARY           = 0x40; // 7
const int HENCH_EFFECT_TYPE_TIMESTOP            = 0x80; // 8
const int HENCH_EFFECT_TYPE_SPELLLEVELABSORPTION = 0x100; // 9
const int HENCH_EFFECT_TYPE_SAVING_THROW_INCREASE = 0x200; // 10
const int HENCH_EFFECT_TYPE_CONCEALMENT         = 0x400; // 11
//const int HENCH_EFFECT_TYPE_SUMMON = 0x800,     // not a "real" effect // 12
const int HENCH_EFFECT_TYPE_DAMAGE_INCREASE     = 0x1000; // 13
const int HENCH_EFFECT_TYPE_ABSORBDAMAGE        = 0x2000; // 14
// new ones
const int HENCH_EFFECT_TYPE_ETHEREAL            = 0x4000; // 15
const int HENCH_EFFECT_TYPE_INVISIBILITY        = 0x8000; // 16
const int HENCH_EFFECT_TYPE_POLYMORPH           = 0x10000; // 17
const int HENCH_EFFECT_TYPE_ULTRAVISION         = 0x20000; // 18
const int HENCH_EFFECT_TYPE_TRUESEEING          = 0x40000; // 19
const int HENCH_EFFECT_TYPE_WILDSHAPE           = 0x80000; // 20
const int HENCH_EFFECT_TYPE_GREATER_INVIS       = 0x100000; // 21
const int HENCH_EFFECT_TYPE_ELEMENTALSHIELD     = 0x200000; // 22
const int HENCH_EFFECT_TYPE_ABILITY_INCREASE    = 0x400000; // 23
const int HENCH_EFFECT_TYPE_SEEINVISIBILE		= 0x800000; // 24
//												= 0x1000000; // 25
//												= 0x2000000; // 26
//												= 0x4000000; // 27
//												= 0x8000000; // 28
//												= 0x10000000; // 29
//												= 0x20000000; // 30
const int HENCH_EFFECT_TYPE_SPELL_SHIELD		= 0x40000000; // 31
const int HENCH_EFFECT_TYPE_IMMUNE_NECROMANCY   = 0x80000000; // 32

const int HENCH_EFFECT_INVISIBLE = 0x0010c040; /* HENCH_EFFECT_TYPE_SANCTUARY | HENCH_EFFECT_TYPE_ETHEREAL | HENCH_EFFECT_TYPE_INVISIBILITY | HENCH_EFFECT_TYPE_GREATER_INVIS*/




/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////


// need to review these

//#include "_SCUtilityConstants"
#include "_CSLCore_Config"
#include "_CSLCore_Appearance_c"
#include "_CSLCore_Appearance"
//#include "_CSLCore_Class"

#include "_CSLCore_Magic"
//#include "x2_inc_switches"
// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"









/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////
/*
int CSLGetIsUndead( object  oTarget, int iProtoUndead = FALSE ); // Proto means it look for things that are shifted into being a certain form
int CSLGetIsConstruct( object oTarget, int iProtoConstruct = FALSE  );
int CSLGetIsElemental( object oTarget, int iProtoElemental = FALSE  );
int CSLGetIsVermin( object oTarget, int iProtoVermin = FALSE  );
int CSLGetIsOutsider( object oTarget, int iProtoOutsider = FALSE  );
int CSLGetIsAnimal( object oTarget  );
int CSLGetIsAnimalOrBeast( object oTarget  );
int CSLGetIsPlant( object oTarget  );
int CSLGetIsOoze( object oTarget  );
int CSLGetIsLiving( object oTarget, int iProto = FALSE   );
int CSLGetIsBloodBased( object oTarget, int iProto = FALSE   );
int CSLGetElementalType( object oTarget );
int CSLGetIsSameFaith( object oCaster, object oTarget );
int CSLGetIsWaterBased( object oTarget, int iProto = FALSE, int iIgnoreWaterElementals = FALSE );
int CSLGetIsHumanoid( object oTarget  );
// * Returns true or false depending on whether the creature is flying
int CSLGetIsFlying(object oCreature);
// * returns true if oCreature does not have a mind
int CSLGetIsMindless(object oCreature);
int CSLGetIsPolymorphed(object oTarget);
int CSLIsCreatureDestroyable(object oTarget);
// * returns true if the creature has flesh
int CSLGetIsImmuneToPetrification(object oCreature);
int CSLGetIsDismissable(object oMinion, int nDoElementals=FALSE);
int CSLGetIsHealingRelatedSpell(int iSpellId);
int CSLGetIsEnemyClose(object oPC, float fDistance);
int CSLGetIsHostilePCClose(object oPC, float fDistance, int nLevelGap=30);
//int CSLGetIsRestorative ( int iSpellId );
//int CSLGetIsBuff( int iSpellId );

string CSLCharacterStatsToString(object oPC );
int CSLGetNaturalAbilityScore( object oCreature, int nAbilityType );
string CSLGetBaseCasterTypeDescription( int iCasterType );
int CSLIsItemValid( object oItem  );
int CSLCountPlayers();

//int HkGetSpellId( object oCaster = OBJECT_SELF, int iForce = FALSE );
*/
/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns the percent remaining of oTarget's hit points.
int CSLGetPercentHP(object oTarget = OBJECT_SELF)
{
	return ((GetCurrentHitPoints(oTarget)*100)/GetMaxHitPoints(oTarget));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLCountPlayers()
{
   object oPC = GetFirstPC();
   int nCnt = 0;
   while (GetIsObjectValid(oPC))
   {
      nCnt++;
      oPC = GetNextPC();
   }
   return nCnt;
}










/**  
* @author
* @param 
* @see 
* @return 
*/
// * Implemented this soas to fix a bug where invalid items in AOEs seem to be 255 not invalid 
int CSLIsItemValid( object oItem  )
{
	if ( GetBaseItemType( oItem ) == BASE_ITEM_INVALID )
	{
		return FALSE;
	}
	
	if ( GetBaseItemType( oItem ) == 255 )
	{
		return FALSE;
	}
	return TRUE;	
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsHumanoid( object oTarget  )
{
	int nRacial = GetRacialType(oTarget);
	if ( nRacial == RACIAL_TYPE_DWARF ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_ELF ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_GNOME ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_HALFLING ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_HALFELF  ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_HALFORC ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_HUMAN ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_PLANETOUCHED ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_PLANT ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_HUMANOID_ORC ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_FEYTOUCHED  ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_DEATHTOUCHED   ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_JOTUNBLOT  ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN  ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_HUMANOID_EXTRAPLANAR ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_DRAGONBLOOD  ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_ELEMENTAL  ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_FEY ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_GIANT ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_MAGICAL_BEAST ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_OUTSIDER ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_SHAPECHANGER ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_UNDEAD ) { return FALSE; };
	if ( nRacial == RACIAL_TYPE_VERMIN ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_OOZE ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_INCORPOREAL ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_YUANTI ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_GRAYORC ) { return TRUE; }
	if ( nRacial == RACIAL_TYPE_ABERRATION ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_ANIMAL  ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_BEAST ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_CONSTRUCT ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_DRAGON ) { return FALSE; }
	if ( nRacial == RACIAL_TYPE_BARIAUR ) { return FALSE; }
	
	int nSubRace = GetSubRace(oTarget);
	if ( nSubRace == RACIAL_SUBTYPE_GITHZERAI ) { return TRUE; }
	if ( nSubRace == RACIAL_SUBTYPE_GITHYANKI ) { return TRUE; }
	
	//if ( GetIsPlayableRacialType( oTarget ) ) { return TRUE; }

	return FALSE;
}				


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsUndead( object  oTarget, int iProtoUndead = FALSE )
{
	
	//if( GetIsObjectValid( GetItemPossessedBy(oCreature, "x2_gauntletlich") ) == TRUE)
	//{
	if( GetTag(GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget) ) == "x2_gauntletlich")
	{
		return TRUE;
	}
    //}
	
	if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD || GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget) > 0 )
	{
		return TRUE;
	}
	else
	{
		if (  iProtoUndead && CSLGetHasEffectSpellIdGroup( oTarget, SPELL_Living_Undeath ) )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsConstruct( object oTarget, int iProtoConstruct = FALSE  )
{
	if(GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetLevelByClass(CLASS_TYPE_CONSTRUCT,oTarget) > 0 )
	{
		return TRUE;
	}
	else
	{
		if (  iProtoConstruct && CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHAPECHANGE_IRON_GOLEM, SPELL_IRON_BODY, SPELL_STONE_BODY ) )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsDragon( object oTarget, int iProtoDragon = FALSE  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_DRAGON || GetLevelByClass(CLASS_TYPE_DRAGON,oTarget) > 0 ) { return TRUE; }
	if (  iProtoDragon && GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE,oTarget) > 0 ) { return TRUE; }
	
	

	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsAberration( object oTarget, int iProtoAberration = FALSE  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_ABERRATION || GetLevelByClass(CLASS_TYPE_ABERRATION,oTarget) > 0 ) { return TRUE; }
	
	// ABERATE spell makes target an aberation
	if ( GetHasSpellEffect( SPELL_ABERRATE, oTarget ) ) { return TRUE; }
	//if (  iProtoDragon && GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE,oTarget) > 0 ) { return TRUE; }
	return FALSE;
}




/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsFey( object oTarget, int iProtoFey = FALSE  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_FEY || GetLevelByClass(CLASS_TYPE_FEY,oTarget) > 0 ) { return TRUE; }
	
	if ( iProtoFey && GetHasFeat( FEAT_FEY_HERITAGE, oTarget ) ) { return TRUE; }
	
	//APPEARANCE_TYPE_FAERIE_DRAGON
	//APPEARANCE_TYPE_FAIRY
	/*
	if(GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetLevelByClass(CLASS_TYPE_CONSTRUCT,oTarget) > 0 )
	{
		return TRUE;
	}
	else
	{
		if (  iProtoConstruct && CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHAPECHANGE_IRON_GOLEM, SPELL_IRON_BODY, SPELL_STONE_BODY ) )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	*/
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsFiend( object oTarget, int iProtoFiend = FALSE  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_FEY || GetLevelByClass(CLASS_TYPE_FEY,oTarget) > 0 ) { return FALSE; }
	
	if ( iProtoFiend && GetHasFeat( FEAT_FIENDISH_HERITAGE, oTarget ) ) { return TRUE; }
	if ( iProtoFiend && GetRacialType(oTarget) == RACIAL_SUBTYPE_TIEFLING ) { return TRUE; }
	
	if( GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL && ( GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || GetLevelByClass(CLASS_TYPE_OUTSIDER,oTarget) > 0 ) )
	{
		return TRUE;
	}
	
	//APPEARANCE_TYPE_DEVIL
	//APPEARANCE_TYPE_VROCK
	//APPEARANCE_TYPE_HOOK_HORROR
	//APPEARANCE_TYPE_SUCCUBUS
	/*
	if(GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetLevelByClass(CLASS_TYPE_CONSTRUCT,oTarget) > 0 )
	{
		return TRUE;
	}
	else
	{
		if (  iProtoConstruct && CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHAPECHANGE_IRON_GOLEM, SPELL_IRON_BODY, SPELL_STONE_BODY ) )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	*/
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsDevil( object oTarget, int iProtoFiend = FALSE  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_FEY || GetLevelByClass(CLASS_TYPE_FEY,oTarget) > 0 ) { return FALSE; }
	
	if ( GetAlignmentLawChaos(oTarget) != ALIGNMENT_CHAOTIC  )
	{
		if ( iProtoFiend && GetHasFeat( FEAT_FIENDISH_HERITAGE, oTarget ) ) { return TRUE; }
		if ( iProtoFiend && GetRacialType(oTarget) == RACIAL_SUBTYPE_TIEFLING ) { return TRUE; }
		
		if( GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL && ( GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || GetLevelByClass(CLASS_TYPE_OUTSIDER,oTarget) > 0 ) )
		{
			return TRUE;
		}
	
	}
	
	//APPEARANCE_TYPE_DEVIL
	//APPEARANCE_TYPE_VROCK
	//APPEARANCE_TYPE_HOOK_HORROR
	//APPEARANCE_TYPE_SUCCUBUS
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsDemon( object oTarget, int iProtoFiend = FALSE  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_FEY || GetLevelByClass(CLASS_TYPE_FEY,oTarget) > 0 ) { return FALSE; }
	
	if ( GetAlignmentLawChaos(oTarget) != ALIGNMENT_LAWFUL )
	{
		if ( iProtoFiend && GetHasFeat( FEAT_FIENDISH_HERITAGE, oTarget ) ) { return TRUE; }
		if ( iProtoFiend && GetRacialType(oTarget) == RACIAL_SUBTYPE_TIEFLING ) { return TRUE; }
		
		if( GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL && ( GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || GetLevelByClass(CLASS_TYPE_OUTSIDER,oTarget) > 0 ) )
		{
			return TRUE;
		}
	
	}
	
	//APPEARANCE_TYPE_DEVIL
	//APPEARANCE_TYPE_VROCK
	//APPEARANCE_TYPE_HOOK_HORROR
	//APPEARANCE_TYPE_SUCCUBUS
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsElemental( object oTarget, int iProtoElemental = FALSE  )
{
	if(GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL || GetLevelByClass(CLASS_TYPE_ELEMENTAL,oTarget) > 0 )
	{
		return TRUE;
	}
	else
	{
		//if (  iProtoElemental && CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHAPECHANGE_IRON_GOLEM, SPELL_IRON_BODY, SPELL_STONE_BODY ) )
		//{
		//	return TRUE;
		//}
		//else
		//{
			return FALSE;
		//}
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsVermin( object oTarget, int iProtoVermin = FALSE  )
{
	if(GetRacialType(oTarget) == RACIAL_TYPE_VERMIN || GetLevelByClass(CLASS_TYPE_VERMIN,oTarget) > 0 )
	{
		return TRUE;
	}
	else
	{
		//if (  iProtoVermin && CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHAPECHANGE_IRON_GOLEM, SPELL_IRON_BODY, SPELL_STONE_BODY ) )
		//{
		//	return TRUE;
		//}
		//else
		//{
			return FALSE;
		//}
	}
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsOutsider( object oTarget, int iProtoOutsider = FALSE  )
{
	if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER || GetLevelByClass(CLASS_TYPE_OUTSIDER,oTarget) > 0 )
	{
		return TRUE;
	}
	else
	{
		/*
		== RACIAL_TYPE_OUTSIDER && // native outsiders, monks etc are raisable
				(GetRacialType(oTarget) == RACIAL_TYPE_RAKSHASA ||
				GetRacialType(oTarget) == RACIAL_TYPE_AZER ||
				GetRacialType(oTarget) == RACIAL_TYPE_NERAPHIM ||
				GetRacialType(oTarget) == RACIAL_TYPE_SHADOWSWYFT)
		*/
		//if (  iProtoOutsider && CSLGetHasEffectSpellIdGroup( oTarget, SPELL_SHAPECHANGE_IRON_GOLEM, SPELL_IRON_BODY, SPELL_STONE_BODY ) )
		//{
		//	return TRUE;
		//}
		//else
		//{
			return FALSE;
		//}
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsAnimal( object oTarget  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_BEAST ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_VERMIN ) { return TRUE; }
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsAnimalOrBeast( object oTarget  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_BEAST ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_MAGICAL_BEAST ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_VERMIN ) { return TRUE; }
	return FALSE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsAnimalOrBeastOrDragon( object oTarget  )
{
	if ( GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_BEAST ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_MAGICAL_BEAST ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_DRAGON ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_VERMIN ) { return TRUE; }
	return FALSE;
}

int CSLGetIsPlant( object oTarget  )
{
	//if ( GetRacialType(oTarget) == RACIAL_TYPE_OOZE ) { return TRUE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_PLANT ) { return TRUE; }
	if ( GetLevelByClass( 35,oTarget) > 0 ) { return TRUE; } // 35 CLASS_TYPE_PLANT is shifter in the nwscript.nss for some reason
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsOoze( object oTarget  )
{
	//if ( GetRacialType(oTarget) == RACIAL_TYPE_OOZE ) { return TRUE; }
	if ( GetRacialType(oTarget) == RACIAL_TYPE_OOZE ) { return TRUE; }
	if ( GetLevelByClass(CLASS_TYPE_OOZE,oTarget) > 0 ) { return TRUE; } // 35
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsLiving( object oTarget, int iProto = FALSE   )
{
	if ( CSLGetIsUndead(oTarget, iProto) ) { return FALSE; }
	if ( CSLGetIsConstruct(oTarget, iProto) ) { return FALSE; }
	if ( CSLGetIsElemental(oTarget, iProto) ) { return FALSE; }
	return TRUE;
}

int CSLGetIsNearDeath( object oTarget )
{
	if ( GetCurrentHitPoints(oTarget) <= 1 )
	{
		return TRUE;
	}
	
	if ( GetCurrentHitPoints(oTarget) < ( GetMaxHitPoints(oTarget)/4 ) ) // lokey said 1/5, testing 1/4, should match the near death character state
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
int CSLGetIsDrownable( object oTarget, int iProto = FALSE   )
{
	if ( GetHasSpellEffect( SPELL_WATER_BREATHING, oTarget ) ) { return FALSE; }
	if ( GetLocalInt(oTarget, "AQUALUNG") ) { return FALSE; } // this is an item that allows underwater breathing
	if ( CSLGetIsUndead(oTarget, iProto) ) { return FALSE; }
	if ( CSLGetIsConstruct(oTarget, iProto) ) { return FALSE; }
	if ( CSLGetIsElemental(oTarget, iProto) ) { return FALSE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_WATER_GENASI ) { return FALSE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_WATER_MEPHLING_ROF ) { return FALSE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_UNDA_ROF ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_CCP_HAMMERHEAD_SHARK_LARGE ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_CCP_HAMMERHEAD_SHARK_MEDIUM  ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_CCP_MAKO_SHARK_LARGE  ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_CCP_MAKO_SHARK_MEDIUM ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_SAHUAGIN  ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_KUO_TOA  ) { return FALSE; }
	if ( CSLGetIsHumanoid(oTarget) ) { return TRUE; }
	if ( CSLGetIsOoze(oTarget) ) { return FALSE; }
	
	// CSLGetIsVermin(oTarget)  only protects vermin, rats are drownable but filth they don'd care about
	return TRUE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsSwimmer( object oTarget, int iProto = FALSE   )
{
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_WATER_GENASI ) { return TRUE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_WATER_MEPHLING_ROF ) { return TRUE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_UNDA_ROF ) { return TRUE; }
	if ( CSLGetIsOoze(oTarget) ) { return TRUE; }
	
	if ( CSLGetIsHumanoid(oTarget) ) { return FALSE; }
	
	int iAppearance = GetAppearanceType(oTarget);
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_WATER ) { return TRUE; } // 69;
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_WATER_ELDER ) { return TRUE; } // 68;
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_WATER_HUGE ) { return TRUE; } // Elemental_Water_Huge
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_WATER_GREATER ) { return TRUE; } // Elemental_Water_Greater
	if ( iAppearance == APPEAR_TYPE_SNAKE ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CARRION_CRAWLER ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_HAMMERHEAD_SHARK ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_MAKO_SHARK ) { return TRUE; }
	
	
	
	if ( iAppearance == APPEAR_TYPE_CCP_HIGHLAND_SNAKE_MEDIUM ) { return TRUE; }	
	if ( iAppearance == APPEAR_TYPE_CCP_HAMMERHEAD_SHARK_LARGE ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CCP_HAMMERHEAD_SHARK_MEDIUM  ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CCP_HIGHLAND_SNAKE_LARGE ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CCP_JUNGLE_SNAKE_LARGE  ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CCP_JUNGLE_SNAKE_MEDIUM  ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CCP_MAKO_SHARK_LARGE  ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CCP_MAKO_SHARK_MEDIUM ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CCP_POLAR_BEAR_LARGE  ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_CCP_POLAR_BEAR_MEDIUM  ) { return TRUE; }
	
	if ( iAppearance == APPEAR_TYPE_NAGA ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_SAHUAGIN  ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_KUO_TOA  ) { return TRUE; }
	
	if ( iAppearance == APPEAR_TYPE_PURRLE_WORM ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_PURRLE_WORM_TINT ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_SEA_MONSTER ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_WEASEL ) { return TRUE; }
	// CSLGetIsVermin(oTarget)  only protects vermin, rats are drownable but filth they don'd care about
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// creature cannot leave water areas
int CSLGetIsRestrainedByWater( object oTarget, int iProto = FALSE   )
{
	int iAppearance = GetAppearanceType(oTarget);
	if ( iAppearance == APPEAR_TYPE_HAMMERHEAD_SHARK ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_MAKO_SHARK ) { return TRUE; }
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// creature cannot enter an area which is of the fire type
int CSLGetIsBlockedByFire( object oTarget, int iProto = FALSE   )
{
	if ( CSLGetIsHumanoid(oTarget) ) { return FALSE; }
	
	int iAppearance = GetAppearanceType(oTarget);
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_WATER ) { return TRUE; } // 69;
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_WATER_ELDER ) { return TRUE; } // 68;
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_WATER_HUGE ) { return TRUE; } // Elemental_Water_Huge
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_WATER_GREATER ) { return TRUE; } // Elemental_Water_Greater
	if ( iAppearance == APPEAR_TYPE_HAMMERHEAD_SHARK ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_MAKO_SHARK ) { return TRUE; }
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// creature cannot enter an area which is of the water type
int CSLGetIsBlockedByWater( object oTarget, int iProto = FALSE   )
{
	if ( CSLGetIsHumanoid(oTarget) ) { return FALSE; }
	
	int iAppearance = GetAppearanceType(oTarget);
	if ( iAppearance == APPEAR_TYPE_VAMPIRE_FEMALE ) { return TRUE; } // 69;
	if ( iAppearance == APPEAR_TYPE_VAMPIRE_MALE ) { return TRUE; } // 68;
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_FIRE_HUGE ) { return TRUE; } // Elemental_Water_Huge
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_FIRE_GREATER ) { return TRUE; } // Elemental_Water_Greater
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_FIRE_ELDER ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_ELEMENTAL_FIRE ) { return TRUE; }
	if ( iAppearance == APPEAR_TYPE_EFREETI ) { return TRUE; }
	return FALSE;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsBloodBased( object oTarget, int iProto = FALSE   )
{
	if ( CSLGetIsUndead(oTarget, iProto) ) { return FALSE; }
	if ( CSLGetIsConstruct(oTarget, iProto) ) { return FALSE; }
	if ( CSLGetIsElemental(oTarget, iProto) ) { return FALSE; }
	
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_GENASI ) { return FALSE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_WATER_GENASI ) { return FALSE; }
	//if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_AIR_GENASI ) { return FALSE; }
	//if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_EARTH_GENASI ) { return FALSE; }
	
	if ( CSLGetIsHumanoid(oTarget) ) { return TRUE; }
	
	if ( CSLGetIsOoze(oTarget) ) { return FALSE; }
	// fire/cold subtype creatures do not have blood
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_GIANT_FIRE ) { return FALSE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_GIANT_FIRE_FEMALE ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_GIANT_FROST ) { return FALSE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_GIANT_FROST_FEMALE ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_MEPHIT_FIRE ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_MEPHIT_ICE ) { return FALSE; }
	return TRUE;
}


int CSLGetIsAirElementalWithinRange( location lTarget, object oCaster = OBJECT_SELF, float fRadius = RADIUS_SIZE_VAST, int iShape = SHAPE_SPHERE ) // , int iHostileSetting = SCSPELL_TARGET_ALL  )
{
	int iAppType;
	object oTarget = GetFirstObjectInShape(iShape, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	{
		//if ( CSLSpellsIsTarget( oTarget, iHostileSetting, oCaster ) )
		//{
			iAppType = GetAppearanceType(oTarget);
			if ( iAppType > 3119 && iAppType < 3148 ) // this entire range is air elementals and rain clouds
			{
				return TRUE; 
			}
			
			switch (iAppType)
			{
				case APPEAR_TYPE_ELEMENTAL_AIR: //  52;
				case APPEAR_TYPE_ELEMENTAL_AIR_ELDER: //  53;
				case APPEAR_TYPE_ELEMENTAL_AIR_HUGE: // Elemental_Air_Huge 554 555
				case APPEAR_TYPE_ELEMENTAL_AIR_GREATER: // Elemental_Air_Greater
					return TRUE;
					break;
			}
		//}
		oTarget = GetNextObjectInShape(iShape, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE  );
	}
	return FALSE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetElementalType( object oTarget )
{
	int nApp= GetAppearanceType(oTarget);
	switch (nApp)
	{
		case APPEAR_TYPE_ELEMENTAL_FIRE: // 60;
		case APPEAR_TYPE_ELEMENTAL_FIRE_ELDER: // 61;
		case APPEAR_TYPE_ELEMENTAL_FIRE_HUGE: // Elemental_Fire_Huge
		case APPEAR_TYPE_ELEMENTAL_FIRE_GREATER: // Elemental_Fire_Greater
			return SCRACE_ELEMENTALTYPE_FIRE;
			break;
		case APPEAR_TYPE_ELEMENTAL_WATER: // 69;
		case APPEAR_TYPE_ELEMENTAL_WATER_ELDER: // 68;
		case APPEAR_TYPE_ELEMENTAL_WATER_HUGE: // Elemental_Water_Huge
		case APPEAR_TYPE_ELEMENTAL_WATER_GREATER: // Elemental_Water_Greater
		case APPEAR_TYPE_ELEMENTAL_ICE: // Elemental_Ice
			return SCRACE_ELEMENTALTYPE_WATER;
			break;
		case APPEAR_TYPE_ELEMENTAL_EARTH: //  56;
		case APPEAR_TYPE_ELEMENTAL_EARTH_ELDER: // 57;
		case APPEAR_TYPE_ELEMENTAL_EARTH_HUGE: // Elemental_Earth_Huge
		case APPEAR_TYPE_ELEMENTAL_EARTH_GREATER: // Elemental_Earth_Greater	
		case APPEAR_TYPE_ELEMENTAL_MAGMA: // Elemental_Magma
		case APPEAR_TYPE_ELEMENTAL_ADAMANTIT: // Elemental_Adamantit
		case APPEAR_TYPE_ELEMENTAL_SILVER: // Elemental_Silver
			return SCRACE_ELEMENTALTYPE_EARTH;
			break;
		case APPEAR_TYPE_ELEMENTAL_AIR: //  52;
		case APPEAR_TYPE_ELEMENTAL_AIR_ELDER: //  53;
		case APPEAR_TYPE_ELEMENTAL_AIR_HUGE: // Elemental_Air_Huge
		case APPEAR_TYPE_ELEMENTAL_AIR_GREATER: // Elemental_Air_Greater
			return SCRACE_ELEMENTALTYPE_AIR;
			break;
	}
	return SCRACE_ELEMENTALTYPE_NONE;
}




/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsFireBased( object oTarget, int iProto = FALSE )
{
	if ( CSLGetIsElemental(oTarget ) )
	{
		if ( CSLGetElementalType( oTarget ) == SCRACE_ELEMENTALTYPE_FIRE ) { return 2;}
	}
	if ( iProto && GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_GENASI ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_GIANT_FIRE ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_GIANT_FIRE_FEMALE ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_MEPHIT_FIRE ) { return TRUE; }
	
	
	if (!GetIsPC(oTarget))
	{
		if ( CSLStringStartsWith(GetTag(oTarget), "fire") ) // this needs to be reviewed as it might be too broad of a match
		{
			return TRUE;
		}
	}
	
	if ( GetLocalInt( oTarget, "CSL_FIREBASED" ) )
	{
		return TRUE;
	}
	return FALSE;
}

int CSLGetIsColdBased( object oTarget, int iProto = FALSE )
{
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_ELEMENTAL_ICE ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_GIANT_FROST ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_GIANT_FROST_ALT ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_DOG_WINTER_WOLF ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_MEPHIT_ICE ) { return TRUE; }
	
	
	if (!GetIsPC(oTarget))
	{
		if ( CSLStringStartsWith(GetTag(oTarget), "cold") || CSLStringStartsWith(GetTag(oTarget), "ice" ) ) // this needs to be reviewed as it might be too broad of a match
		{
			return TRUE;
		}
	}
	
	if ( GetLocalInt( oTarget, "CSL_COLDBASED" ) )
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
int CSLGetIsWaterBased( object oTarget, int iProto = FALSE, int iIgnoreWaterElementals = FALSE )
{
	if ( CSLGetIsUndead(oTarget, iProto) ) { return FALSE; }
	if ( CSLGetIsConstruct(oTarget, iProto) ) { return FALSE; }
	if ( CSLGetIsElemental(oTarget, iProto) )
	{ 
		if ( iIgnoreWaterElementals == FALSE && CSLGetElementalType( oTarget ) == SCRACE_ELEMENTALTYPE_WATER )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}	
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_GENASI ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_GIANT_FIRE ) { return FALSE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_GIANT_FIRE_FEMALE ) { return FALSE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_MEPHIT_FIRE ) { return FALSE; }
	if ( CSLGetIsHumanoid(oTarget) ) { return TRUE; }
	return TRUE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// This is so i can hook the spells, soas to make faction based faiths for dex
// or for other servers where alignment is the focus
// Used in faith healing, recitation, and some new spells being developed
int CSLGetIsSameFaith( object oCaster, object oTarget )
{
	if( GetDeity(oTarget) == GetDeity(oCaster) )
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
* @replaces spellsIsFlying
*/
// * Returns true or false depending on whether the creature is flying
// * or not
int CSLGetIsFlying(object oCreature)
{
	int nAppearance = GetAppearanceType(oCreature);
	int bFlying = FALSE;
	switch(nAppearance)
	{
			case APPEAR_TYPE_BAT:
			case APPEAR_TYPE_ELEMENTAL_AIR:
			case APPEAR_TYPE_ELEMENTAL_AIR_ELDER:
			case APPEAR_TYPE_ELEMENTAL_AIR_HUGE:
			case APPEAR_TYPE_ELEMENTAL_AIR_GREATER:
			case APPEAR_TYPE_PIXIE:
			case APPEAR_TYPE_SYLPH:
			case APPEAR_TYPE_HOMUNCULUS:
			case APPEAR_TYPE_IMP:
			case APPEAR_TYPE_MEPHIT_FIRE:
			case APPEAR_TYPE_MEPHIT_ICE:
			case APPEAR_TYPE_SHADOW:
			case APPEAR_TYPE_SPECTRE:
			case APPEAR_TYPE_WILLOWISP:
			case APPEAR_TYPE_WRAITH:
			case APPEAR_TYPE_ELEMENTAL_WATER:
			case APPEAR_TYPE_ELEMENTAL_WATER_ELDER:
			case APPEAR_TYPE_ELEMENTAL_WATER_HUGE:
			case APPEAR_TYPE_ELEMENTAL_WATER_GREATER:
			case APPEAR_TYPE_BEHOLDER: // johnny ree
			case APPEAR_TYPE_FLYING_BOOK: // this is custom
			case APPEAR_TYPE_DEMILICH_SMALL:
			case APPEAR_TYPE_DEMILICH:
			// these dont exist
			//case APPEARANCE_TYPE_HELMED_HORROR:
			//case APPEARANCE_TYPE_ALLIP:
			//case APPEARANCE_TYPE_BAT_HORROR:
			//case APPEARANCE_TYPE_FALCON:
			//case APPEARANCE_TYPE_WYRMLING_BLACK:
			//case APPEARANCE_TYPE_WYRMLING_BLUE:
			//case APPEARANCE_TYPE_WYRMLING_BRASS:
			//case APPEARANCE_TYPE_WYRMLING_BRONZE:
			//case APPEARANCE_TYPE_WYRMLING_COPPER:
			//case APPEARANCE_TYPE_WYRMLING_GOLD:
			//case APPEARANCE_TYPE_WYRMLING_GREEN:
			//case APPEARANCE_TYPE_WYRMLING_RED:
			//case APPEARANCE_TYPE_WYRMLING_SILVER:
			//case APPEARANCE_TYPE_WYRMLING_WHITE:
			//case APPEARANCE_TYPE_SHADOW_FIEND:
			//case APPEARANCE_TYPE_MEPHIT_MAGMA:
			//case APPEARANCE_TYPE_MEPHIT_OOZE:
			//case APPEARANCE_TYPE_MEPHIT_SALT:
			//case APPEARANCE_TYPE_MEPHIT_STEAM:
			//case APPEARANCE_TYPE_MEPHIT_WATER:
			//case APPEARANCE_TYPE_QUASIT:
			//case APPEARANCE_TYPE_RAVEN:
			//case APPEARANCE_TYPE_LANTERN_ARCHON:
			//case APPEARANCE_TYPE_MEPHIT_AIR:
			//case APPEARANCE_TYPE_MEPHIT_DUST:
			//case APPEARANCE_TYPE_MEPHIT_EARTH:
			//beholder
			//case 402: //beholder
			//case 403: //beholder
			//case 419: // harpy
			//case APPEAR_TYPE_DEMILICH: // Demi Lich
			//case 472: // Hive mother
			bFlying = TRUE;
	}
	return bFlying;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns TRUE if oTarget is a favored enemy of oPC.
int CSLGetIsFavoredEnemy(object oPC, object oTarget)
{
	int nRace = GetRacialType(oTarget);
	int nSubRace = GetSubRace(oTarget);
	int bFEnemy;
	
	switch (nRace)
	{
		case RACIAL_TYPE_DWARF:					bFEnemy = GetHasFeat(261, oPC, TRUE);	break;
		case RACIAL_TYPE_ELF:					bFEnemy = GetHasFeat(262, oPC, TRUE);	break;
		case RACIAL_TYPE_GNOME:					bFEnemy = GetHasFeat(263, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFLING:				bFEnemy = GetHasFeat(264, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFELF:				bFEnemy = GetHasFeat(265, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFORC:				bFEnemy = GetHasFeat(266, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMAN:					bFEnemy = GetHasFeat(267, oPC, TRUE);	break;
		case RACIAL_TYPE_ABERRATION:			bFEnemy = GetHasFeat(268, oPC, TRUE);	break;
		case RACIAL_TYPE_ANIMAL:				bFEnemy = GetHasFeat(269, oPC, TRUE);	break;
		case RACIAL_TYPE_BEAST:					bFEnemy = GetHasFeat(270, oPC, TRUE);	break;
		case RACIAL_TYPE_CONSTRUCT:				bFEnemy = GetHasFeat(271, oPC, TRUE);	break;
		case RACIAL_TYPE_DRAGON:				bFEnemy = GetHasFeat(272, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID:	bFEnemy = GetHasFeat(273, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS:	bFEnemy = GetHasFeat(274, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_ORC:			bFEnemy = GetHasFeat(275, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN:	bFEnemy = GetHasFeat(276, oPC, TRUE);	break;
		case RACIAL_TYPE_ELEMENTAL:				bFEnemy = GetHasFeat(277, oPC, TRUE);	break;
		case RACIAL_TYPE_FEY:					bFEnemy = GetHasFeat(278, oPC, TRUE);	break;
		case RACIAL_TYPE_GIANT:					bFEnemy = GetHasFeat(279, oPC, TRUE);	break;
		case RACIAL_TYPE_MAGICAL_BEAST:			bFEnemy = GetHasFeat(280, oPC, TRUE);	break;
		case RACIAL_TYPE_OUTSIDER:				bFEnemy = GetHasFeat(281, oPC, TRUE);	break;
		case RACIAL_TYPE_SHAPECHANGER:			bFEnemy = GetHasFeat(284, oPC, TRUE);	break;
		case RACIAL_TYPE_UNDEAD:				bFEnemy = GetHasFeat(285, oPC, TRUE);	break;
		case RACIAL_TYPE_VERMIN:				bFEnemy = GetHasFeat(286, oPC, TRUE);	break;
		default:								bFEnemy = FALSE;						break;
	}
	
	if ((GetHasFeat(282, oPC, TRUE) == TRUE) && (nSubRace == RACIAL_SUBTYPE_PLANT)) // Plants have a subtype but not a race.
	{
		bFEnemy = TRUE;
	}
	return bFEnemy;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns TRUE if oPC has Improved Favored Enemy for oTarget.
int CSLGetIsImpFavoredEnemy(object oPC, object oTarget)
{
	int nRace = GetRacialType(oTarget);
	int nSubRace = GetSubRace(oTarget);
	int bFEnemy;
	
	switch (nRace)
	{
		case RACIAL_TYPE_DWARF:					bFEnemy = GetHasFeat(1198, oPC, TRUE);	break;
		case RACIAL_TYPE_ELF:					bFEnemy = GetHasFeat(1199, oPC, TRUE);	break;
		case RACIAL_TYPE_GNOME:					bFEnemy = GetHasFeat(1200, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFLING:				bFEnemy = GetHasFeat(1201, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFELF:				bFEnemy = GetHasFeat(1202, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFORC:				bFEnemy = GetHasFeat(1203, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMAN:					bFEnemy = GetHasFeat(1204, oPC, TRUE);	break;
		case RACIAL_TYPE_ABERRATION:			bFEnemy = GetHasFeat(1205, oPC, TRUE);	break;
		case RACIAL_TYPE_ANIMAL:				bFEnemy = GetHasFeat(1206, oPC, TRUE);	break;
		case RACIAL_TYPE_BEAST:					bFEnemy = GetHasFeat(1207, oPC, TRUE);	break;
		case RACIAL_TYPE_CONSTRUCT:				bFEnemy = GetHasFeat(1208, oPC, TRUE);	break;
		case RACIAL_TYPE_DRAGON:				bFEnemy = GetHasFeat(1209, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID:	bFEnemy = GetHasFeat(1210, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS:	bFEnemy = GetHasFeat(1211, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_ORC:			bFEnemy = GetHasFeat(1212, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN:	bFEnemy = GetHasFeat(1213, oPC, TRUE);	break;
		case RACIAL_TYPE_ELEMENTAL:				bFEnemy = GetHasFeat(1214, oPC, TRUE);	break;
		case RACIAL_TYPE_FEY:					bFEnemy = GetHasFeat(1215, oPC, TRUE);	break;
		case RACIAL_TYPE_GIANT:					bFEnemy = GetHasFeat(1216, oPC, TRUE);	break;
		case RACIAL_TYPE_MAGICAL_BEAST:			bFEnemy = GetHasFeat(1217, oPC, TRUE);	break;
		case RACIAL_TYPE_OUTSIDER:				bFEnemy = GetHasFeat(1218, oPC, TRUE);	break;
		case RACIAL_TYPE_SHAPECHANGER:			bFEnemy = GetHasFeat(1219, oPC, TRUE);	break;
		case RACIAL_TYPE_UNDEAD:				bFEnemy = GetHasFeat(1220, oPC, TRUE);	break;
		case RACIAL_TYPE_VERMIN:				bFEnemy = GetHasFeat(1221, oPC, TRUE);	break;
		default:								bFEnemy = FALSE;						break;
	}
	
	if ((GetHasFeat(2055, oPC, TRUE) == TRUE) && (nSubRace == RACIAL_SUBTYPE_PLANT)) // Plants have a subtype but not a race.
	{
		bFEnemy = TRUE;
	}
	return bFEnemy;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns TRUE if oPC has Power Attack Favored Enemy for oTarget.
int CSLGetIsFavoredEnemyPA(object oPC, object oTarget)
{
	int nRace = GetRacialType(oTarget);
	int nSubRace = GetSubRace(oTarget);
	int bFEnemy;
	
	switch (nRace)
	{
		case RACIAL_TYPE_DWARF:					bFEnemy = GetHasFeat(1222, oPC, TRUE);	break;
		case RACIAL_TYPE_ELF:					bFEnemy = GetHasFeat(1223, oPC, TRUE);	break;
		case RACIAL_TYPE_GNOME:					bFEnemy = GetHasFeat(1223, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFLING:				bFEnemy = GetHasFeat(1224, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFELF:				bFEnemy = GetHasFeat(1225, oPC, TRUE);	break;
		case RACIAL_TYPE_HALFORC:				bFEnemy = GetHasFeat(1226, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMAN:					bFEnemy = GetHasFeat(1227, oPC, TRUE);	break;
		case RACIAL_TYPE_ABERRATION:			bFEnemy = GetHasFeat(1228, oPC, TRUE);	break;
		case RACIAL_TYPE_ANIMAL:				bFEnemy = GetHasFeat(1229, oPC, TRUE);	break;
		case RACIAL_TYPE_BEAST:					bFEnemy = GetHasFeat(1230, oPC, TRUE);	break;
		case RACIAL_TYPE_CONSTRUCT:				bFEnemy = GetHasFeat(1231, oPC, TRUE);	break;
		case RACIAL_TYPE_DRAGON:				bFEnemy = GetHasFeat(1232, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_GOBLINOID:	bFEnemy = GetHasFeat(1233, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_MONSTROUS:	bFEnemy = GetHasFeat(1234, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_ORC:			bFEnemy = GetHasFeat(1235, oPC, TRUE);	break;
		case RACIAL_TYPE_HUMANOID_REPTILIAN:	bFEnemy = GetHasFeat(1236, oPC, TRUE);	break;
		case RACIAL_TYPE_ELEMENTAL:				bFEnemy = GetHasFeat(1237, oPC, TRUE);	break;
		case RACIAL_TYPE_FEY:					bFEnemy = GetHasFeat(1238, oPC, TRUE);	break;
		case RACIAL_TYPE_GIANT:					bFEnemy = GetHasFeat(1239, oPC, TRUE);	break;
		case RACIAL_TYPE_MAGICAL_BEAST:			bFEnemy = GetHasFeat(1240, oPC, TRUE);	break;
		case RACIAL_TYPE_OUTSIDER:				bFEnemy = GetHasFeat(1241, oPC, TRUE);	break;
		case RACIAL_TYPE_SHAPECHANGER:			bFEnemy = GetHasFeat(1242, oPC, TRUE);	break;
		case RACIAL_TYPE_UNDEAD:				bFEnemy = GetHasFeat(1243, oPC, TRUE);	break;
		case RACIAL_TYPE_VERMIN:				bFEnemy = GetHasFeat(1244, oPC, TRUE);	break;
		default:								bFEnemy = FALSE;						break;
	}
	
	if ((GetHasFeat(2089, oPC, TRUE) == TRUE) && (nSubRace == RACIAL_SUBTYPE_PLANT)) // Plants have a subtype but not a race.
	{
		bFEnemy = TRUE;
	}
	return bFEnemy;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// Returns TRUE if oPC is Raging.
int CSLGetIsRaging(object oPC)
{
	int nReturn = FALSE;
	
	if (GetHasSpellEffect(SPELLABILITY_BARBARIAN_RAGE, oPC) == TRUE)
	{
		return TRUE;
	}
	else if (GetHasSpellEffect(SPELLABILITY_EPIC_MIGHTY_RAGE, oPC) == TRUE)
	{
		return TRUE;
	}
	else if (GetHasSpellEffect(SPELLABILITY_RAGE_3, oPC) == TRUE)
	{
		return TRUE;
	}
	else if (GetHasSpellEffect(SPELLABILITY_RAGE_4, oPC) == TRUE)
	{
		return TRUE;
	}
	else if (GetHasSpellEffect(SPELLABILITY_RAGE_5, oPC) == TRUE)
	{
		return TRUE;
	}
	return nReturn;
}


//const int CREATURE_SIZE_FINE = 20;
//const int CREATURE_SIZE_DIMINUTIVE = 21;
//int CREATURE_SIZE_INVALID = 0;
//int CREATURE_SIZE_TINY =    1;
//int CREATURE_SIZE_SMALL =   2;
//int CREATURE_SIZE_MEDIUM =  3;
//int CREATURE_SIZE_LARGE =   4;
//int CREATURE_SIZE_HUGE =    5;
//const int CREATURE_SIZE_GARGANTUAN = 22;
//const int CREATURE_SIZE_COLOSSAL =23;

/**  
* @author
* @param 
* @see 
* @return 
* @replaces HasSizeIncreasingSpellEffect
*/
int CSLGetHasSizeIncreaseEffect(object oCreature)
{
	if (  GetHasSpellEffect( SPELL_ENTROPIC_HUSK,oCreature) || GetHasSpellEffect(SPELL_ENLARGE_PERSON,oCreature) || GetHasSpellEffect( SPELLABILITY_GRAYENLARGE,oCreature) || GetHasSpellEffect( SPELL_RIGHTEOUS_MIGHT,oCreature) )
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
int CSLGetHasSizeDecreaseEffect(object oCreature)
{
	if ( GetHasSpellEffect( SPELL_REDUCE_PERSON,oCreature) || GetHasSpellEffect( SPELL_REDUCE_PERSON_GREATER,oCreature) || GetHasSpellEffect( SPELL_REDUCE_ANIMAL,oCreature) || GetHasSpellEffect( SPELL_REDUCE_PERSON_MASS,oCreature) )
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
int CSLGetSizeCategory(object oCreature)
{
	
	int iCreatureSize = GetCreatureSize(oCreature); // get the real creature size...
	
	int nAppearance = GetAppearanceType(oCreature); // handles size exceptions - note that flying creatures cannot use actual height to determine this
	switch(nAppearance)
	{
		case APPEAR_TYPE_BAT:
			iCreatureSize = CREATURE_SIZE_DIMINUTIVE;
			break;
		case APPEAR_TYPE_PIXIE:
			iCreatureSize = CREATURE_SIZE_SMALL;
			break;
		case APPEAR_TYPE_SYLPH:
			iCreatureSize = CREATURE_SIZE_SMALL;
			break;
		case APPEAR_TYPE_HOMUNCULUS:
			iCreatureSize = CREATURE_SIZE_TINY;
			break;
		case APPEAR_TYPE_IMP:
			iCreatureSize = CREATURE_SIZE_TINY;
			break;
		case APPEAR_TYPE_MEPHIT_FIRE:
		case APPEAR_TYPE_MEPHIT_ICE:
			iCreatureSize = CREATURE_SIZE_SMALL;
			break;
		case APPEAR_TYPE_DEMILICH_SMALL:
		case APPEAR_TYPE_DEMILICH:
			iCreatureSize =  CREATURE_SIZE_DIMINUTIVE;
			break;
	}
	
	// figure out height from the creatures actual height...
	
	/*
	if ( iCreatureSize == CREATURE_SIZE_INVALID )
	{
		float fHeight = CSLGetCreatureHeight( oCreature );
		if ( fHeight == 0.0f )
		{
			return iCreatureSize;
		}
		else if ( fHeight <= 0.1524f ) { iCreatureSize = CREATURE_SIZE_FINE; } // CREATURE_SIZE_FINE < .5 feet  0.1524f
		else if ( fHeight <= 0.3048f ) { iCreatureSize = CREATURE_SIZE_DIMINUTIVE; } // CREATURE_SIZE_DIMINUTIVE < 1 foot  0.3048f
		else if ( fHeight <= 0.6096f ) { iCreatureSize = CREATURE_SIZE_TINY; } // CREATURE_SIZE_TINY < 2 feet 0.6096f
		else if ( fHeight <= 1.2192f ) { iCreatureSize = CREATURE_SIZE_SMALL; } // CREATURE_SIZE_SMALL < 4 feet 1.2192f
		else if ( fHeight <= 2.4384f ) { iCreatureSize = CREATURE_SIZE_MEDIUM; } // CREATURE_SIZE_MEDIUM < 8 feet  2.4384f
		else if ( fHeight <= 4.8768f ) { iCreatureSize = CREATURE_SIZE_LARGE; } // CREATURE_SIZE_LARGE < 16 feet 4.8768f
		else if ( fHeight <= 9.7536f ) { iCreatureSize = CREATURE_SIZE_HUGE; } // CREATURE_SIZE_HUGE < 32 feet 9.7536f
		else if ( fHeight <= 19.5072f ) { iCreatureSize = CREATURE_SIZE_GARGANTUAN; } // CREATURE_SIZE_GARGANTUAN < 64 feet 19.5072f
		else if ( fHeight > 19.5072f ) { iCreatureSize = CREATURE_SIZE_COLOSSAL; } // CREATURE_SIZE_COLOSSAL > 64 feet 19.5072f
		return iCreatureSize;
	}
	*/
	
	// Per SRD, reduce and enlarge adjusts creatures up and down by one category
	if (  CSLGetHasSizeIncreaseEffect(oCreature)  )
	{
		switch(iCreatureSize)
		{
			case CREATURE_SIZE_FINE:
				iCreatureSize = CREATURE_SIZE_DIMINUTIVE;
				break;
			case CREATURE_SIZE_DIMINUTIVE:
				iCreatureSize = CREATURE_SIZE_TINY;
				break;
			case CREATURE_SIZE_TINY:
				iCreatureSize = CREATURE_SIZE_SMALL;
				break;
			case CREATURE_SIZE_SMALL:
				iCreatureSize = CREATURE_SIZE_MEDIUM;
				break;
			case CREATURE_SIZE_MEDIUM:
				iCreatureSize = CREATURE_SIZE_LARGE;
				break;
			case CREATURE_SIZE_LARGE:
				iCreatureSize = CREATURE_SIZE_HUGE;
				break;
			case CREATURE_SIZE_HUGE:
				iCreatureSize = CREATURE_SIZE_GARGANTUAN;
				break;
			case CREATURE_SIZE_GARGANTUAN:
				iCreatureSize = CREATURE_SIZE_COLOSSAL;
				break;
		}
	}
	else if ( CSLGetHasSizeDecreaseEffect(oCreature) )
	{
		switch(iCreatureSize)
		{
			case CREATURE_SIZE_DIMINUTIVE:
				iCreatureSize = CREATURE_SIZE_FINE;
				break;
			case CREATURE_SIZE_TINY:
				iCreatureSize = CREATURE_SIZE_DIMINUTIVE;
				break;
			case CREATURE_SIZE_SMALL:
				iCreatureSize = CREATURE_SIZE_TINY;
				break;
			case CREATURE_SIZE_MEDIUM:
				iCreatureSize = CREATURE_SIZE_SMALL;
				break;
			case CREATURE_SIZE_LARGE:
				iCreatureSize = CREATURE_SIZE_MEDIUM;
				break;
			case CREATURE_SIZE_HUGE:
				iCreatureSize = CREATURE_SIZE_LARGE;
				break;
			case CREATURE_SIZE_GARGANTUAN:
				iCreatureSize = CREATURE_SIZE_HUGE;
				break;
			case CREATURE_SIZE_COLOSSAL:
				iCreatureSize = CREATURE_SIZE_GARGANTUAN;
				break;
		}
	}
	
	return iCreatureSize;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSizeModifierAttack(object oCreature)
{
	int iCreatureSize = CSLGetSizeCategory(oCreature);
	switch(iCreatureSize)
	{
		case CREATURE_SIZE_FINE:
			return 8;
			break;
		case CREATURE_SIZE_DIMINUTIVE:
			return 4;
			break;
		case CREATURE_SIZE_TINY:
			return 2;
			break;
		case CREATURE_SIZE_SMALL:
			return 1;
			break;
		case CREATURE_SIZE_MEDIUM:
			return 0;
			break;
		case CREATURE_SIZE_LARGE:
			return -1;
			break;
		case CREATURE_SIZE_HUGE:
			return -2;
			break;
		case CREATURE_SIZE_GARGANTUAN:
			return -4;
			break;
		case CREATURE_SIZE_COLOSSAL:
			return -8;
			break;
	}
	return 0;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// @replaces GetSizeModifier
int CSLGetSizeModifierGrapple(object oCreature)
{
	int iCreatureSize = CSLGetSizeCategory(oCreature);
	switch(iCreatureSize)
	{
		case CREATURE_SIZE_FINE:
			return -16;
			break;
		case CREATURE_SIZE_DIMINUTIVE:
			return -12;
			break;
		case CREATURE_SIZE_TINY:
			return -8;
			break;
		case CREATURE_SIZE_SMALL:
			return -4;
			break;
		case CREATURE_SIZE_MEDIUM:
			return 0;
			break;
		case CREATURE_SIZE_LARGE:
			return 4;
			break;
		case CREATURE_SIZE_HUGE:
			return 8;
			break;
		case CREATURE_SIZE_GARGANTUAN:
			return 12;
			break;
		case CREATURE_SIZE_COLOSSAL:
			return 16;
			break;
	}
	return 0;

}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSizeModifierHide(object oCreature)
{
	int iCreatureSize = CSLGetSizeCategory(oCreature);
	switch(iCreatureSize)
	{
		case CREATURE_SIZE_FINE:
			return 16;
			break;
		case CREATURE_SIZE_DIMINUTIVE:
			return 12;
			break;
		case CREATURE_SIZE_TINY:
			return 8;
			break;
		case CREATURE_SIZE_SMALL:
			return 4;
			break;
		case CREATURE_SIZE_MEDIUM:
			return 0;
			break;
		case CREATURE_SIZE_LARGE:
			return -4;
			break;
		case CREATURE_SIZE_HUGE:
			return -8;
			break;
		case CREATURE_SIZE_GARGANTUAN:
			return -12;
			break;
		case CREATURE_SIZE_COLOSSAL:
			return -16;
			break;
	}
	return 0;

}

/*

Incapacitated parameters
Always --
dead or less than 1 hit point, which don't matter really

if bImmobilized - grappled or held ( vines and web )
EFFECT_TYPE_ENTANGLE
EFFECT_TYPE_CUTSCENEIMMOBILIZE
KNOCKDOWN

if bCheckCharmed
EFFECT_TYPE_CHARMED
EFFECT_TYPE_DOMINATED

if bCheckBlindness - can it see
EFFECT_TYPE_BLINDNESS

if bCheckCognizant - does it have mental ability to think straight
EFFECT_TYPE_CONFUSED
EFFECT_TYPE_DAZED
EFFECT_TYPE_FRIGHTENED
EFFECT_TYPE_INSANE
EFFECT_TYPE_MESMERIZE
EFFECT_TYPE_PETRIFY
EFFECT_TYPE_SLEEP
EFFECT_TYPE_STUNNED

if bCheckFallen
CSL_KNOCKDOWN


if bCheckParalyzed - can't move but is aware
EFFECT_TYPE_PARALYZE
EFFECT_TYPE_CUTSCENE_PARALYZE
EFFECT_TYPE_TIMESTOP


REFLEX
bImmobilized = FALSE
bCheckCharmed = FALSE
bCheckBlindness = BLINDFIGHT based
bCheckCognizant = TRUE
bCheckFallen = TRUE
bCheckParalyzed = TRUE

FORTITUDE
bImmobilized = FALSE
bCheckCharmed = FALSE
bCheckBlindness = FALSE
bCheckCognizant = TRUE
bCheckFallen = FALSE
bCheckParalyzed = FALSE

WILL
bImmobilized = FALSE
bCheckCharmed = TRUE
bCheckBlindness = FALSE
bCheckCognizant = TRUE
bCheckFallen = FALSE
bCheckParalyzed = FALSE

*/


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsIncapacitated(object oCreature, int bImmobilized = FALSE,  int bCheckCharmed = FALSE, int bCheckBlindness = FALSE, int bCheckCognizant = TRUE, int bCheckFallen = TRUE, int bCheckParalyzed = TRUE)
{
	if ( GetIsDead( oCreature ) ) { return TRUE; }
	if ( GetCurrentHitPoints(oCreature) < 1 ) { return TRUE; }
	
	if ( bCheckFallen && GetLocalInt( oCreature, "CSL_KNOCKDOWN" ) ) { return TRUE; }
	
	effect eEffect;
	eEffect = GetFirstEffect(oCreature);
	while (GetIsEffectValid(eEffect))
	{
		if (
			bCheckParalyzed && (
			GetEffectType(eEffect) == EFFECT_TYPE_PARALYZE ||
			GetEffectType(eEffect) == EFFECT_TYPE_CUTSCENE_PARALYZE ||
			GetEffectType(eEffect) == EFFECT_TYPE_TIMESTOP  )
		)
		{ 
			return TRUE;
		}
		
		if ( bCheckCognizant && ( 
			GetEffectType(eEffect) == EFFECT_TYPE_CONFUSED ||
			GetEffectType(eEffect) == EFFECT_TYPE_DAZED ||
			GetEffectType(eEffect) == EFFECT_TYPE_FRIGHTENED ||
			GetEffectType(eEffect) == EFFECT_TYPE_INSANE ||
			GetEffectType(eEffect) == EFFECT_TYPE_MESMERIZE ||
			GetEffectType(eEffect) == EFFECT_TYPE_PETRIFY ||
			GetEffectType(eEffect) == EFFECT_TYPE_SLEEP ||
			GetEffectType(eEffect) == EFFECT_TYPE_STUNNED
			 )
		)
		{ 
			return TRUE;
		}
		
		
		if ( bCheckBlindness && ( GetEffectType(eEffect) == EFFECT_TYPE_BLINDNESS ) )
		{ // EFFECT_TYPE_DOMINATED
			return TRUE;
		}
		
		if ( bImmobilized && ( GetEffectType(eEffect) == EFFECT_TYPE_ENTANGLE || GetEffectType(eEffect) == EFFECT_TYPE_CUTSCENEIMMOBILIZE || GetLocalInt( oCreature, "CSL_KNOCKDOWN" ) ) )
		{ // EFFECT_TYPE_DOMINATED
			return TRUE;
		}
		
		if ( bCheckCharmed && ( GetEffectType(eEffect) == EFFECT_TYPE_CHARMED || ( GetEffectType(eEffect) == EFFECT_TYPE_DOMINATED && !GetLocalInt( oCreature, "SCSummon" ) ) ) )
		{ // EFFECT_TYPE_DOMINATED
			return TRUE;
		}
		eEffect = GetNextEffect(oCreature);
	}
	return FALSE;
	
	// ignoring EFFECT_TYPE_JARRING as i don't think it's in use or implemented
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// * returns true if oCreature does not have a mind
int CSLGetIsMindless(object oCreature)
{
	int nRacialType = GetRacialType(oCreature);
	switch(nRacialType)
	{
			case RACIAL_TYPE_ELEMENTAL:
			case RACIAL_TYPE_UNDEAD:
			case RACIAL_TYPE_VERMIN:
			case RACIAL_TYPE_CONSTRUCT:
			case RACIAL_TYPE_OOZE:
			return TRUE;
	}
	
	if ( CSLGetHasEffectType( oCreature, EFFECT_TYPE_PETRIFY) )
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
// Used in deck avatar
int CSLGetIsPolymorphed( object oTarget )
{
	effect eEff = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEff))
	{
		if ( GetEffectType(eEff) == EFFECT_TYPE_POLYMORPH )
		{
			return TRUE;
		}
		eEff = GetNextEffect(oTarget);
	}
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsCharmed( object oTarget )
{
	effect eEff = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEff))
	{
		if ( GetEffectType(eEff) == EFFECT_TYPE_CHARMED || ( GetEffectType(eEff) == EFFECT_TYPE_DOMINATED && !GetLocalInt( oTarget, "SCSummon" ) ) )
		{
			return TRUE;
		}
		eEff = GetNextEffect(oTarget);
	}
	return FALSE;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
//::///////////////////////////////////////////////
//:: CSLIsCreatureDestroyable
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Returns true if the creature is allowed
	to die (i.e., not plot)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
int CSLIsCreatureDestroyable(object oTarget)
{
	if (GetPlotFlag(oTarget) == FALSE && GetImmortal(oTarget) == FALSE)
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
* @replaces spellsIsImmuneToPetrification
*/
// * returns true if the creature has flesh
int CSLGetIsImmuneToPetrification(object oCreature)
{
	int nAppearance = GetAppearanceType(oCreature);
	int bImmune = FALSE;
	switch (nAppearance)
	{
		case APPEAR_TYPE_ELEMENTAL_AIR:
		case APPEAR_TYPE_ELEMENTAL_AIR_ELDER:
		case APPEAR_TYPE_ELEMENTAL_AIR_GREATER:
		case APPEAR_TYPE_ELEMENTAL_AIR_HUGE:
		case APPEAR_TYPE_ELEMENTAL_EARTH:
		case APPEAR_TYPE_ELEMENTAL_EARTH_ELDER:
		case APPEAR_TYPE_ELEMENTAL_EARTH_GREATER:
		case APPEAR_TYPE_ELEMENTAL_EARTH_HUGE:
		case APPEAR_TYPE_ELEMENTAL_FIRE:
		case APPEAR_TYPE_ELEMENTAL_FIRE_ELDER:
		case APPEAR_TYPE_ELEMENTAL_FIRE_GREATER:
		case APPEAR_TYPE_ELEMENTAL_FIRE_HUGE:
		case APPEAR_TYPE_ELEMENTAL_WATER:
		case APPEAR_TYPE_ELEMENTAL_WATER_ELDER:
		case APPEAR_TYPE_ELEMENTAL_WATER_GREATER:
		case APPEAR_TYPE_ELEMENTAL_WATER_HUGE:
		case APPEAR_TYPE_ELEMENTAL_ADAMANTIT:
		case APPEAR_TYPE_ELEMENTAL_ICE:
		case APPEAR_TYPE_ELEMENTAL_MAGMA:
		case APPEAR_TYPE_ELEMENTAL_SILVER:
		case APPEAR_TYPE_SPIDER_KRISTAL: // ???
		case APPEAR_TYPE_MEPHIT_FIRE:
		case APPEAR_TYPE_MEPHIT_ICE:
		case APPEAR_TYPE_RAVENOUS_INCARNATION: // this is a cool burning thing
		// undead that are skeletons/shadows mainly
		case APPEAR_TYPE_HORSE_SKELETAL:
		case APPEAR_TYPE_LICH:		
		case APPEAR_TYPE_DEATH_KNIGHT:
		case APPEAR_TYPE_DEMILICH:
		case APPEAR_TYPE_DEMILICH_SMALL:
		case APPEAR_TYPE_DRACOLICH:
		case APPEAR_TYPE_SHADOW:
		case APPEAR_TYPE_SHADOW_REAVER:
		case APPEAR_TYPE_SKELETON:
		case APPEAR_TYPE_SPECTRE:
		case APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER:		
		case APPEAR_TYPE_WRAITH:
		// golems
		case APPEAR_TYPE_BLADELING:
		case APPEAR_TYPE_GOLEM_BLADE:
		case APPEAR_TYPE_CLOCKROACH:
		case APPEAR_TYPE_GOLEM_CLAY:
		case APPEAR_TYPE_GOLEM_FAITHLESS:
		case APPEAR_TYPE_GOLEM_IMASKARI:
		case APPEAR_TYPE_GOLEM_IRON:
		case APPEAR_TYPE_SPIDER_BLADE:
		case APPEAR_TYPE_INVISIBLEMAN: // used for dancing weapons and the like
		case APPEAR_TYPE_NPC_HUNTERSTATUE:
		// magical beasts
		case APPEAR_TYPE_MONODRONE: // ???
		case APPEAR_TYPE_WILLOWISP:
		case APPEAR_TYPE_GARGOYLE: // duration is one round perhaps
		case APPEAR_TYPE_SPIDER_WRAITH:
		case APPEAR_TYPE_BASILIK:
		case APPEAR_TYPE_XORN:
		// these are not flesh obviously, just in case really
		case APPEAR_TYPE_CARGOSHIP:
		case APPEAR_TYPE_SIEGETOWER:
		case APPEAR_TYPE_SIEGETOWERB:
		case APPEAR_TYPE_SMUGGLERWAGON:
		case APPEAR_TYPE_PUSHBLOCK:
		// other
		case APPEAR_TYPE_ONE_OF_MANY: // ???
		case APPEAR_TYPE_FLYING_BOOK:
		
		// not in game
		//case APPEARANCE_TYPE_GOLEM_STONE:
		//case APPEARANCE_TYPE_GOLEM_CLAY:
		//case APPEARANCE_TYPE_GOLEM_BONE:
		//case APPEARANCE_TYPE_GORGON:
		//case APPEARANCE_TYPE_HEURODIS_LICH:
		//case APPEARANCE_TYPE_LANTERN_ARCHON:
		//case APPEARANCE_TYPE_SHADOW_FIEND:
		//case APPEARANCE_TYPE_SHIELD_GUARDIAN:
		//case APPEARANCE_TYPE_SKELETAL_DEVOURER:
		//case APPEARANCE_TYPE_SKELETON_CHIEFTAIN:
		//case APPEARANCE_TYPE_SKELETON_COMMON:
		//case APPEARANCE_TYPE_SKELETON_MAGE:
		//case APPEARANCE_TYPE_SKELETON_PRIEST:
		//case APPEARANCE_TYPE_SKELETON_WARRIOR:
		//case APPEARANCE_TYPE_SKELETON_WARRIOR_1:
		//case APPEARANCE_TYPE_BAT_HORROR:
		//case APPEARANCE_TYPE_BASILISK:
		//case APPEARANCE_TYPE_COCKATRICE:
		//case APPEARANCE_TYPE_MEDUSA:
		//case APPEARANCE_TYPE_ALLIP:
		//case 415: // Alhoon
		//case 418: // shadow dragon
		//case 420: // mithral golem
		//case 421: // admantium golem
		//case 430: // Demi Lich
		//case 469: // animated chest
		//case 474: // golems
		//case 475: // golems
		bImmune = TRUE;
	}

	// * GZ: Sept 2003 - Prevent people from petrifying DM, resulting in GUI even when
	//                   effect is not successful.
	if (!GetPlotFlag(oCreature) && GetIsDM(oCreature))
	{
		bImmune = FALSE;
	}
	return bImmune;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsSunDamagedCreature( object oTarget )
{
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_VAMPIRE_FEMALE ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_VAMPIRE_MALE ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEAR_TYPE_SPECTRE ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_BODAK ) { return TRUE; }
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsLightSensitiveCreature( object oTarget )
{
	// This feat allows light sensitive creatures to be treated as normal
	if ( GetHasFeat( FEAT_DAYLIGHT_ADAPATION, oTarget ) ) { return FALSE; }
	
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_DROW ) { return TRUE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_SVIRFNEBLIN ) { return TRUE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_GRAYORC ) { return TRUE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_GRAY_DWARF ) { return TRUE; }
	
	if ( GetSubRace(oTarget) == RACIAL_TYPE_HUMANOID_ORC ) { return TRUE; }
	if ( GetSubRace(oTarget) == RACIAL_SUBTYPE_HUMANOID_ORC ) { return TRUE; }
	
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_KOBOLD ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_GRAYORC ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_ORC_A ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_KOBOLD_B ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_KOBOLD_CHIEF_A ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_KOBOLD_CHIEF_B ) { return TRUE; }
	
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_VAMPIRE_FEMALE ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_VAMPIRE_MALE ) { return TRUE; }
	if ( GetAppearanceType(oTarget) == APPEAR_TYPE_SPECTRE ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_ORC_A ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_ORC_B ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_ORC_CHIEFTAIN_A ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_ORC_CHIEFTAIN_B ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_ORC_SHAMAN_A ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_ORC_SHAMAN_B ) { return TRUE; }
	//if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_BODAK ) { return TRUE; }
	/* not applicable
	APPEARANCE_TYPE_SHADOW
	APPEARANCE_TYPE_SHADOW_FIEND
	APPEARANCE_TYPE_SHADOW_REAVER
	Sahuagin
	Derro
	*/
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsInDayLight( object oTarget )
{
	if( GetHasSpellEffect(SPELL_DAYLIGHT, oTarget) || GetHasSpellEffect(SPELL_DAYLIGHT_CLERIC, oTarget) ) 
	{
		return TRUE;
	}
	if( GetIsDay() && GetIsAreaAboveGround(GetArea(oTarget)) && !GetIsAreaInterior(GetArea(oTarget)))
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
// Used in Banishment and dismissal
int CSLGetIsDismissable(object oMinion, int nDoElementals=FALSE)
{
	// Anchoring blocks all dismissal
	if ( GetHasSpellEffect( SPELL_DIMENSIONAL_ANCHOR, oMinion ) ) { return FALSE; }
	if ( GetLocalInt( oMinion, "CSL_CHARSTATE" ) & BIT31 ) { return FALSE; } // CSL_CHARSTATE_ANCHORED
	
	int nAssType = GetAssociateType(oMinion);
	if ( GetLocalInt( oMinion, "SCSummon") != 0 ) { return TRUE ; }
	if (nAssType==ASSOCIATE_TYPE_SUMMONED || nAssType==ASSOCIATE_TYPE_FAMILIAR || nAssType==ASSOCIATE_TYPE_ANIMALCOMPANION) return TRUE;
	int nRace = GetRacialType(oMinion);
	if (nRace==RACIAL_TYPE_OUTSIDER || (nDoElementals && nRace==RACIAL_TYPE_ELEMENTAL)) return TRUE;
	if ( CSLGetIsUndead( oMinion ) ) return GetLocalObject(oMinion, "DOMINATED")!=OBJECT_INVALID; // DOMINATED UNDEAD CAN BE
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// does the spell have a healishness feel to it?
int CSLGetIsHealingRelatedSpell(int iSpellId)
{
	int iRet = FALSE;
	
	if (( iSpellId == SPELL_CURE_LIGHT_WOUNDS )
		|| ( iSpellId == SPELL_CURE_MINOR_WOUNDS )
		|| ( iSpellId == SPELL_CURE_MODERATE_WOUNDS )
		|| ( iSpellId == SPELL_CURE_CRITICAL_WOUNDS )
		|| ( iSpellId == SPELL_CURE_SERIOUS_WOUNDS )
		|| ( iSpellId == SPELL_HEAL )
		|| ( iSpellId == SPELL_HEALINGKIT )
		|| ( iSpellId == SPELLABILITY_LAY_ON_HANDS )
		|| ( iSpellId == SPELLABILITY_WHOLENESS_OF_BODY )
		|| ( iSpellId == SPELL_MASS_CURE_LIGHT_WOUNDS ) // JLR - OEI 08/23/05 -- Renamed for 3.5
		|| ( iSpellId == SPELL_RAISE_DEAD )
		|| ( iSpellId == SPELL_RESURRECTION )
		|| ( iSpellId == SPELL_MASS_HEAL )
		|| ( iSpellId == SPELL_GREATER_RESTORATION )
		|| ( iSpellId == SPELL_REGENERATE )
		|| ( iSpellId == SPELL_AID )
		|| ( iSpellId == SPELL_VIRTUE ) )
	{
		iRet = TRUE;
	}
	return iRet;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
//::///////////////////////////////////////////////
//:: CSLGetIsImmuneToMagicalHealing
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Returns whether target is immune to magical
    healing
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: December 29, 2004
//:://////////////////////////////////////////////
int CSLGetIsImmuneToMagicalHealing(object oTarget)
{
    
    if ( CSLGetPreferenceSwitch("EtherealBlockHealing",FALSE)  && ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY ) == TRUE ) )
	{
		SendMessageToPC( OBJECT_SELF, "Your Healing Fizzled in the Etheral Plane!" );
		return TRUE;
	}
    
    if(GetHasSpellEffect(SPELL_CONDEMNED, oTarget))
    {
        SendMessageToPC( oTarget, "You Are Condemned And The Gods Will Not Heal You!" );
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
//::///////////////////////////////////////////////
//:: SGSetIsCorporeal
//:: 2005 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Override to force a creature to be treated as incorpreal
    (ie ethereal, gaseous form, etc)
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: June 16, 2005
//:://////////////////////////////////////////////
void CSLSetIsIncorporeal(object oTarget, int bIsCorporeal)
{

    SetLocalInt(oTarget, "X2_L_IS_INCORPOREAL", bIsCorporeal);
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsIncorporeal(object oTarget)
{
    
    if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY ) == TRUE )
	{
		return TRUE;
	}
    // if(GetHasFeat(FEAT_INCORPOREAL, oTarget)) { return TRUE; }
    // if(GetHasFeat(FEAT_ETHEREAL, oTarget)) { return TRUE; }
    
    if( GetLocalInt(oTarget, "Is_Incorporeal") )  { return TRUE; }
    if( GetLocalInt(oTarget, "Is_Ethereal") )  { return TRUE; }
    
    if ( GetRacialType(oTarget) == RACIAL_TYPE_INCORPOREAL ) { return TRUE; }
    
    if ( CSLGetHasEffectType( oTarget, EFFECT_TYPE_ETHEREAL ) ) { return TRUE; }
    
    return GetLocalInt(oTarget, "X2_L_IS_INCORPOREAL");
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsEthereal(object oTarget)
{
    
    if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY ) == TRUE )
	{
		return TRUE;
	}
    // if(GetHasFeat(FEAT_ETHEREAL, oTarget)) { return TRUE; }
    
    if( GetLocalInt(oTarget, "Is_Ethereal") )  { return TRUE; }
        
    if ( CSLGetHasEffectType( oTarget, EFFECT_TYPE_ETHEREAL ) ) { return TRUE; }
    
    return GetLocalInt(oTarget, "X2_L_IS_INCORPOREAL");
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsInvisible(object oTarget)
{
    if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_GREATER_INVISIBILITY, SPELL_INVISIBILITY, SPELLABILITY_AS_GREATER_INVISIBLITY, SPELLABILITY_AS_INVISIBILITY, SPELL_DISAPPEAR, SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY ) == TRUE )
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
int CSLGetIsMagicallyFreeToMove(object oTarget, int bNaturalHinderance = FALSE )
{
    
    if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_ASN_Freedom_of_Movement, SPELL_BG_Freedom_of_Movement, SPELL_FREEDOM_OF_MOVEMENT ) == TRUE )
	{
		return TRUE;
	}
	
	if ( bNaturalHinderance && GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) )
	{
	
		return TRUE;
	}
    

    
    //if ( GetRacialType(oTarget) == RACIAL_TYPE_INCORPOREAL ) { return TRUE; }
    
    //if ( CSLGetHasEffectType( oTarget, EFFECT_TYPE_ETHEREAL ) ) { return TRUE; }
    
    //return GetLocalInt(oTarget, "X2_L_IS_INCORPOREAL");
    return FALSE;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsImmuneToClouds(object oTarget)
{
	if ( CSLGetIsIncorporeal( oTarget) ) { return TRUE; }
	if ( GetHasSpellEffect( SPELL_FILTER, oTarget ) ) { return TRUE; }
	
	return FALSE;
}









/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsEnemyClose(object oPC, float fDistance)
{
   object oCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oPC);
   return (oCreature!=OBJECT_INVALID && GetDistanceBetween(oPC, oCreature) <= fDistance);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsHostilePCClose(object oPC, float fDistance, int nLevelGap=30)
{
   object oArea = GetArea(oPC);
   object oCreature = GetFirstPC();
   while (GetIsObjectValid(oCreature)) // LOOP OVER ALL PC'S
   { 
      if (oCreature!=oPC && GetArea(oCreature)==oArea) // IN MY AREA
      { 
         if (GetDistanceBetween(oPC, oCreature) <= fDistance)
         {
            if (GetIsReactionTypeHostile(oPC, oCreature))
            {
               return (abs(GetHitDice(oCreature) - GetHitDice(oPC)) <= nLevelGap);
            }
         }
      }
      oCreature = GetNextPC();
   }
   return FALSE;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsVerbalComponentRequired( int iSpellId )
{
	if ( FindSubString( GetStringUpperCase(Get2DAString("spells", "VS", iSpellId)), "V") == -1 )
	{
		return FALSE;
	}
	return TRUE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsSomanticComponentRequired( int iSpellId )
{
	if ( FindSubString( GetStringUpperCase(Get2DAString("spells", "VS", iSpellId)), "S") == -1 )
	{
		return FALSE;
	}
	return TRUE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Private function - Check if a spell can't be cast because of a silence effect on the caster
// JXPrivateCheckSilenceEffect
int CSLCheckSpellBlockedByVerbal(object oCaster, int iSpellId, int iMetaMagicFeat)
{
	// Get the verbal and somatic components of the spell to cast
	int bHasVerbal = CSLGetIsVerbalComponentRequired( iSpellId );
	int bHasSomatic = CSLGetIsSomanticComponentRequired( iSpellId );
	
	// Check if the verbal component prevents the spell to be cast
	if (bHasVerbal)
	{
		int bSilenceEffect = FALSE;
		effect eSilence = GetFirstEffect(oCaster);
		while (GetIsEffectValid(eSilence))
		{
			if (GetEffectType(eSilence) == EFFECT_TYPE_SILENCE)
			{
				bSilenceEffect = TRUE;
				break;
			}
			eSilence = GetNextEffect(oCaster);
		}
		// The spell can't be cast because of a silence effect on the caster
		if ((bSilenceEffect) && !(iMetaMagicFeat & METAMAGIC_SILENT))
		{
			//SendMessageToPCByStrRef(oCaster, 67640);
			return FALSE;
		}
	}

	return TRUE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Private function - Check if a spell can't be cast because of arcane spell failure
// JXPrivateCheckASF
int CSLSpellBlockedByASF(object oCaster, int iSpellId, int iMetaMagicFeat, int iClass)
{
	// Divine spells don't have spell failure, need to rework this
	if (Get2DAString("classes", "HasDivine", iClass) == "1")
		return TRUE;

	int bHasSomatic = CSLGetIsSomanticComponentRequired(iSpellId);

	// Check if the somatic component prevents the spell to be cast
	if (bHasSomatic && !(iMetaMagicFeat & METAMAGIC_STILL))
	{
		int iASF = GetArcaneSpellFailure(oCaster);
		if (iASF > 0)
		{
			int iASFCheck = d100();
			// The spell can't be cast because of arcane spell failure
			if (iASFCheck <= iASF)
			{
				if (GetIsPC(oCaster))
				{
					//string sMessageASF = GetStringByStrRef(176528);
					//sMessageASF = JXStringReplaceToken(sMessageASF, 0, IntToString(iASF));
					//sMessageASF = JXStringReplaceToken(sMessageASF, 1, IntToString(iASFCheck));
					//SendMessageToPC(oCaster, sMessageASF);
				}
				return FALSE;
			}
		}
	}

	return TRUE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetNaturalAbilityScore( object oCreature, int nAbilityType )
{
	int nRace = GetSubRace( oCreature );
	int nBaseScore = GetAbilityScore(oCreature, nAbilityType, TRUE);
	int iRacialModifier = 0;
	// iRacialModifier = StringToInt( Get2DAString("racialsubtypes", "IntAdjust", nRace) );
	switch ( nAbilityType )
	{
		case 0: // str:
			iRacialModifier = CSLGetRaceDataStrAdjust( nRace );
			break;
		case 1: // dex:
			iRacialModifier = CSLGetRaceDataDexAdjust( nRace );
			break;	
		case 2: // con:
			iRacialModifier = CSLGetRaceDataConAdjust( nRace );
			break;			
		case 3: // int:
			iRacialModifier = CSLGetRaceDataIntAdjust( nRace );
			break;			
		case 4: // wis:
			iRacialModifier = CSLGetRaceDataWisAdjust( nRace );
			break;	
		case 5: // cha:
			iRacialModifier = CSLGetRaceDataChaAdjust( nRace );
			break;
	}	
	return nBaseScore + iRacialModifier;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
/* List all effects on an object */
string CSLCharacterStatsToString(object oPC )
{
	string sMessage = "Stats for " + GetName(oPC);
	sMessage += "\n   AC: "+IntToString( GetAC( oPC ));
	sMessage += "\n   Hps: "+IntToString( GetMaxHitPoints( oPC ))+" Currently "+IntToString( GetCurrentHitPoints( oPC ));
	sMessage += "\n   Stat: Natural/Buffed";
	sMessage += "\n   Str: "+IntToString( CSLGetNaturalAbilityScore(oPC, ABILITY_STRENGTH ))+"/"+IntToString( GetAbilityScore(oPC, ABILITY_STRENGTH, FALSE));
	sMessage += "\n   Dex: "+IntToString( CSLGetNaturalAbilityScore(oPC, ABILITY_DEXTERITY ))+"/"+IntToString( GetAbilityScore(oPC, ABILITY_DEXTERITY, FALSE));
	sMessage += "\n   Con: "+IntToString( CSLGetNaturalAbilityScore(oPC, ABILITY_CONSTITUTION ))+"/"+IntToString( GetAbilityScore(oPC, ABILITY_CONSTITUTION, FALSE));
	sMessage += "\n   Int: "+IntToString( CSLGetNaturalAbilityScore(oPC, ABILITY_INTELLIGENCE ))+"/"+IntToString( GetAbilityScore(oPC, ABILITY_INTELLIGENCE, FALSE));
	sMessage += "\n   Cha: "+IntToString( CSLGetNaturalAbilityScore(oPC, ABILITY_WISDOM))+"/"+IntToString( GetAbilityScore(oPC, ABILITY_WISDOM, FALSE));
	sMessage += "\n   Cha: "+IntToString( CSLGetNaturalAbilityScore(oPC, ABILITY_CHARISMA ))+"/"+IntToString( GetAbilityScore(oPC, ABILITY_CHARISMA, FALSE));
	//sMessage += "\n   AC: "+IntToString( GetAC( oPC ));
	//sMessage += "\n   AC: "+IntToString( GetAC( oPC ));
	return sMessage;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
//::///////////////////////////////////////////////
//:: BooleanToString
//:: 2006 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Utility function for use by debugging scripts
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: February 9, 2006
//:://////////////////////////////////////////////
string CSLBooleanToString(int i) {
    
    string sTrue = "TRUE";
    string sFalse = "FALSE";
    
    if(i==0) return sFalse;

    return sTrue;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
//::///////////////////////////////////////////////
//:: FeatToString
//:: 2006 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Utility function: returns feat name from 2da file
    good for returning names instead of values for
    debugging scripts
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: February 9, 2006
//:://////////////////////////////////////////////
string CSLFeatToString(int iFeat) {
    
    string sFeatName = Get2DAString("feat","Label",iFeat);
    
    return sFeatName;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
//::///////////////////////////////////////////////
//:: SpellToString
//:: 2006 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Utility function: returns feat name from 2da file
    good for returning names instead of values for
    debugging scripts
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: February 9, 2006
//:://////////////////////////////////////////////
string CSLSpellToString(int iSpellId) {
    
    string sSpellName = Get2DAString("spells","Label",iSpellId);
    
    return sSpellName;
}



/*
// * Returns TRUE if oCreature is a dead NPC, dead PC or a dying PC.
int GetIsDead(object oCreature, int bIgnoreDying=FALSE);

// * Returns TRUE if oCreature is a Player Controlled character.
// NOTE: If the passed in creature is owned by the player, but the player is 
//		 currently controlling another creature, this will return FALSE
//		 To check for ownership, see GetIsOwnedByPlayer()
int GetIsPC(object oCreature);

// * Returns TRUE if oSource considers oTarget as an enemy.
int GetIsEnemy(object oTarget, object oSource=OBJECT_SELF);

// * Returns TRUE if oSource considers oTarget as a friend.
int GetIsFriend(object oTarget, object oSource=OBJECT_SELF);

// * Returns TRUE if oSource considers oTarget as neutral.
int GetIsNeutral(object oTarget, object oSource=OBJECT_SELF);

// - oCreature
// - nImmunityType: IMMUNITY_TYPE_*
// - oVersus: if this is specified, then we also check for the race and
//   alignment of oVersus
// * Returns TRUE if oCreature has immunity of type nImmunity versus oVersus.
int GetIsImmune(object oCreature, int nImmunityType, object oVersus=OBJECT_INVALID);

// Determine whether oSource sees oTarget.
// NOTE: This *only* works on creatures, as visibility lists are not
//       maintained for non-creature objects.
int GetObjectSeen(object oTarget, object oSource=OBJECT_SELF);

// Determine whether oSource hears oTarget.
// NOTE: This *only* works on creatures, as visibility lists are not
//       maintained for non-creature objects.
int GetObjectHeard(object oTarget, object oSource=OBJECT_SELF);

// Use this in an OnPlayerDeath module script to get the last player that died.
object GetLastPlayerDied();

// Use this in an OnItemLost script to get the item that was lost/dropped.
// * Returns OBJECT_INVALID if the module is not valid.
object GetModuleItemLost();

// Use this in an OnItemLost script to get the creature that lost the item.
// * Returns OBJECT_INVALID if the module is not valid.
object GetModuleItemLostBy();


// Get the attack target of oCreature.
// This only works when oCreature is in combat.
object GetAttackTarget(object oCreature=OBJECT_SELF);

// Get the attack type (SPECIAL_ATTACK_*) of oCreature's last attack.
// This only works when oCreature is in combat.
int GetLastAttackType(object oCreature=OBJECT_SELF);

// Get the attack mode (COMBAT_MODE_*) of oCreature's last attack.
// This only works when oCreature is in combat.
int GetLastAttackMode(object oCreature=OBJECT_SELF);

// Get the master of oAssociate.
object GetMaster(object oAssociate=OBJECT_SELF);

// * Returns TRUE if oCreature is in combat.
int GetIsInCombat(object oCreature=OBJECT_SELF);

// Get the last command (ASSOCIATE_COMMAND_*) issued to oAssociate.
int GetLastAssociateCommand(object oAssociate=OBJECT_SELF);


// Get the locked state of oTarget, which can be a door or a placeable object.
int GetLocked(object oTarget);

// Use this in a trigger's OnClick event script to get the object that last
// clicked on it.
// This is identical to GetEnteringObject.
object GetClickingObject();


// Get the henchman belonging to oMaster.
// * Return OBJECT_INVALID if oMaster does not have a henchman.
// -nNth: Which henchman to return.
object GetHenchman(object oMaster=OBJECT_SELF,int nNth=1);


// Get the gender of oCreature.
int GetGender(object oCreature);

// * Returns TRUE if tTalent is valid.
int GetIsTalentValid(talent tTalent);


// Get the target that the caller attempted to attack - this should be used in
// conjunction with GetAttackTarget(). This value is set every time an attack is
// made, and is reset at the end of combat.
// * Returns OBJECT_INVALID if the caller is not a valid creature.
object GetAttemptedAttackTarget();

// Get the type (TALENT_TYPE_*) of tTalent.
int GetTypeFromTalent(talent tTalent);

// Get the ID of tTalent.  This could be a SPELL_*, FEAT_* or SKILL_*.
int GetIdFromTalent(talent tTalent);


// Returns the stealth mode of the specified creature.
// - oCreature
// * Returns a constant STEALTH_MODE_*
int GetStealthMode(object oCreature);

// Returns the detection mode of the specified creature.
// - oCreature
// * Returns a constant DETECT_MODE_*
int GetDetectMode(object oCreature);

// Returns the defensive casting mode of the specified creature.
// - oCreature
// * Returns a constant DEFENSIVE_CASTING_MODE_*
int GetDefensiveCastingMode(object oCreature);

// returns the appearance type of the specified creature.
// * returns a constant APPEARANCE_TYPE_* for valid creatures
// * returns APPEARANCE_TYPE_INVALID for non creatures/invalid creatures
int GetAppearanceType(object oCreature);

// Gets the status of ACTION_MODE_* modes on a creature. 
int GetActionMode(object oCreature, int nMode); 

// Returns the default package selected for this creature to level up with
// - returns PACKAGE_INVALID if error occurs
int GetCreatureStartingPackage(object oCreature);

// AFW-OEI 03/12/2007
// Returns whether or not a creature is a "spirit".  Defaults to FALSE if oCreature is not
// a valid creature object.  Returns TRUE if oCreature is a Fey or Elemental, or the
// SpiritOverride flag is set on the creature blueprint.  Fey and Elementals are always
// considered spirits, regardless of the state of the SpiritOverride flag.
// - oCreature: The creature object you are testing.
int GetIsSpirit( object oCreature );
*/

// 2drunks love logic, need to mesh this in somehow

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLCanISpeakIntelligently()
{
	if(GetIsPlayableRacialType(OBJECT_SELF) || (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEY) || 
	(GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DRAGON) || (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_OUTSIDER)) {
		return TRUE;
	} else {
		return FALSE;
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLCanISpeakAtAll()
{
	int iCanSpeak = CSLCanISpeakIntelligently();
	
	if(iCanSpeak == FALSE) {
		switch(GetRacialType(OBJECT_SELF)) {
			case RACIAL_TYPE_GIANT:
			case RACIAL_TYPE_HUMANOID_GOBLINOID:
			case RACIAL_TYPE_HUMANOID_MONSTROUS:
			case RACIAL_TYPE_HUMANOID_ORC:
			case RACIAL_TYPE_HUMANOID_REPTILIAN:
				iCanSpeak = TRUE;
				break;
			default:
				iCanSpeak = FALSE;
				break;
		}
	}
	
	return iCanSpeak;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
//::///////////////////////////////////////////////
//:: CSLGetPoisonType
//:: 2005 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Removing common code out of bolts/cones monster
    abilities
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 27, 2005
//:://////////////////////////////////////////////
// Based on NWN1, need to go over what is needed for NWN2
int CSLGetPoisonType(int iCasterLevel, object oCaster=OBJECT_SELF)
{

    int iPoison;
	/*
    switch( GetRacialType(oCaster) )
	{
        case RACIAL_TYPE_OUTSIDER:
            if(iCasterLevel<10) {
                iPoison = POISON_QUASIT_VENOM;
            } else if(iCasterLevel<13) {
                iPoison = POISON_BEBILITH_VENOM;
            } else {
                iPoison = POISON_PIT_FIEND_ICHOR;
            }
            break;
        case RACIAL_TYPE_VERMIN:
            if(iCasterLevel<3) {
                iPoison = POISON_TINY_SPIDER_VENOM;
            } else if(iCasterLevel<6) {
                iPoison = POISON_SMALL_SPIDER_VENOM;
            } else if(iCasterLevel<9) {
                iPoison = POISON_MEDIUM_SPIDER_VENOM;
            } else if(iCasterLevel<12) {
                iPoison =  POISON_LARGE_SPIDER_VENOM;
            } else if(iCasterLevel<15) {
                iPoison = POISON_HUGE_SPIDER_VENOM;
            } else if(iCasterLevel<18) {
                iPoison = POISON_GARGANTUAN_SPIDER_VENOM;
            } else {
                iPoison = POISON_COLOSSAL_SPIDER_VENOM;
            }
            break;
        default:
            if(iCasterLevel<3) {
                iPoison = POISON_NIGHTSHADE;
            } else if(iCasterLevel<6) {
                iPoison = POISON_BLADE_BANE;
            } else if(iCasterLevel<9) {
                iPoison = POISON_BLOODROOT;
            } else if(iCasterLevel<12) {
                iPoison =  POISON_LARGE_SPIDER_VENOM;
            } else if(iCasterLevel<15) {
                iPoison = POISON_LICH_DUST;
            } else if(iCasterLevel<18) {
                iPoison = POISON_DARK_REAVER_POWDER;
            } else {
                iPoison = POISON_BLACK_LOTUS_EXTRACT;
            }
            break;
    }
	*/
    return iPoison;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
//::///////////////////////////////////////////////
//:: CSLGetDiseaseType
//:: 2005 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Removing common code out of bolts/cones monster
    abilities
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 27, 2005
//:://////////////////////////////////////////////
int CSLGetDiseaseType(int iCasterLevel, object oCaster=OBJECT_SELF)
{

    int iDisease;
	/*
    switch(GetRacialType(oCaster)) {
        case RACIAL_TYPE_OUTSIDER:
            iDisease = DISEASE_DEMON_FEVER;
            break;
        case RACIAL_TYPE_VERMIN:
            iDisease = DISEASE_VERMIN_MADNESS;
            break;
        case RACIAL_TYPE_UNDEAD:
            if(iCasterLevel<4) {
                iDisease = DISEASE_ZOMBIE_CREEP;
            } else if(iCasterLevel<11) {
                iDisease = DISEASE_GHOUL_ROT;
            } else {
                iDisease = DISEASE_MUMMY_ROT;
            }
        default:
            if(iCasterLevel<4) {
                iDisease = DISEASE_MINDFIRE;
            } else if(iCasterLevel<11) {
                iDisease = DISEASE_RED_ACHE;
            } else {
                iDisease = DISEASE_SHAKES;
            }
            break;
    }
	*/
    return iDisease;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLSkillTypeToString(int iSkill)
{
	if (iSkill==SKILL_APPRAISE        ) return "Appraise";
	if (iSkill==SKILL_BLUFF           ) return "Bluff";
	if (iSkill==SKILL_CONCENTRATION   ) return "Concentration";
	if (iSkill==SKILL_CRAFT_ALCHEMY   ) return "Craft Alchemy";
	if (iSkill==SKILL_CRAFT_ARMOR     ) return "Craft Armor";
	if (iSkill==SKILL_CRAFT_TRAP      ) return "Craft Trap";
	if (iSkill==SKILL_CRAFT_WEAPON    ) return "Craft Weapon";
	if (iSkill==SKILL_DIPLOMACY       ) return "Diplomacy";
	if (iSkill==SKILL_DISABLE_TRAP    ) return "Disable Trap";
	if (iSkill==SKILL_HEAL            ) return "Heal";
	if (iSkill==SKILL_HIDE            ) return "Hide";
	if (iSkill==SKILL_INTIMIDATE      ) return "Intimidate";
	if (iSkill==SKILL_LISTEN          ) return "Listen";
	if (iSkill==SKILL_LORE            ) return "Lore";
	if (iSkill==SKILL_MOVE_SILENTLY   ) return "Move Silently";
	if (iSkill==SKILL_OPEN_LOCK       ) return "Open Lock";
	if (iSkill==SKILL_PARRY           ) return "Parry";
	if (iSkill==SKILL_PERFORM         ) return "Perform";
	if (iSkill==SKILL_SEARCH          ) return "Search";
	if (iSkill==SKILL_SET_TRAP        ) return "Set Trap";
	if (iSkill==SKILL_SLEIGHT_OF_HAND ) return "Sleight of Hand";
	if (iSkill==SKILL_SPELLCRAFT      ) return "Spellcraft";
	if (iSkill==SKILL_SPOT            ) return "Spot";
	if (iSkill==SKILL_SURVIVAL        ) return "Survival";
	if (iSkill==SKILL_TAUNT           ) return "Taunt";
	if (iSkill==SKILL_TUMBLE          ) return "Tumble";
	if (iSkill==SKILL_USE_MAGIC_DEVICE) return "Use Magic Device";
	if (iSkill==SKILL_ALL_SKILLS      ) return "All Skills";
	
	string sSkill = Get2DAString("skills", "Name", iSkill);
	
	return "MissSkill" + IntToString(iSkill);
}


// Return constant value for skill n
// Used in gc_skill_dc, gc_skill_rank
int CSLGetSkillConstant(int nSkill)
{
	int nSkillVal;

	switch (nSkill)	
	{
        case 0:     // APPRAISE
            nSkillVal = SKILL_APPRAISE;
            break;
        case 1:     // BLUFF
            nSkillVal = SKILL_BLUFF;
            break;
        case 2:     // CONCENTRATION
            nSkillVal = SKILL_CONCENTRATION;
            break;
        case 3:     // CRAFT ALCHEMY
            nSkillVal = SKILL_CRAFT_ALCHEMY;
            break;
        case 4:     // CRAFT ARMOR
            nSkillVal = SKILL_CRAFT_ARMOR;
            break;
        case 5:     // CRAFT WEAPON
            nSkillVal = SKILL_CRAFT_WEAPON;
            break;
        case 6:     // DIPLOMACY
            nSkillVal = SKILL_DIPLOMACY;
            break;
        case 7:     // DISABLE DEVICE
            nSkillVal = SKILL_DISABLE_TRAP;
            break;
        case 8:     // DISCIPLINE
            nSkillVal = SKILL_DISCIPLINE;
            break;
        case 9:     // HEAL
            nSkillVal = SKILL_HEAL;
            break;
        case 10:     // HIDE
            nSkillVal = SKILL_HIDE;
            break;
        case 11:     // INTIMIDATE
            nSkillVal = SKILL_INTIMIDATE;
            break;
        case 12:     // LISTEN
            nSkillVal = SKILL_LISTEN;
            break;
        case 13:     // LORE
            nSkillVal = SKILL_LORE;
            break;
        case 14:     // MOVE SILENTLY
            nSkillVal = SKILL_MOVE_SILENTLY;
            break;
        case 15:     // OPEN LOCK
            nSkillVal = SKILL_OPEN_LOCK;
            break;
        case 16:     // PARRY
            nSkillVal = SKILL_PARRY;
            break;
        case 17:     // PERFORM
            nSkillVal = SKILL_PERFORM;
            break;
        case 18:     // RIDE
            nSkillVal = SKILL_RIDE;
            break;
        case 19:     // SEARCH
            nSkillVal = SKILL_SEARCH;
            break;
        case 20:     // SET TRAP
            nSkillVal = SKILL_CRAFT_TRAP;
            break;
        case 21:     // SLEIGHT OF HAND
            nSkillVal = SKILL_SLEIGHT_OF_HAND;
            break;
        case 22:     // SPELLCRAFT
            nSkillVal = SKILL_SPELLCRAFT;
            break;
        case 23:     // SPOT
            nSkillVal = SKILL_SPOT;
            break;
        case 24:     // SURVIVAL
            nSkillVal = SKILL_SURVIVAL;
            break;
        case 25:     // TAUNT
            nSkillVal = SKILL_TAUNT;
            break;
        case 26:     // TUMBLE
            nSkillVal = SKILL_TUMBLE;
            break;
        case 27:     // USE MAGIC DEVICE
            nSkillVal = SKILL_USE_MAGIC_DEVICE;
            break;
	}

	return (nSkillVal);
}
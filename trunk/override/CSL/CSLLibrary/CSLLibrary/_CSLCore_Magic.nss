/** @file
* @brief Magic Related Function
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

/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////
#include "_CSLCore_Math"
#include "_CSLCore_Strings"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_Position"
//#include "_CSLCore_Items" // can't include for it needs to include magic
 // need to get this working
#include "_CSLCore_Descriptor"
#include "_CSLCore_Messages"



/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////
#include "_CSLCore_Magic_c"
#include "_CSLCore_Class_c"






/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

/*
int CSLGetDispelPowerCap( int iSpellId = -1 );
int CSLGetDispellLevel(int iSpellId);
int CSLGetIsCloud ( int iSpellId );
int CSLGetAutomaticMetamagic( int iMetaMagic, object oPC = OBJECT_SELF );
int CSLGetMetaMagicSlotLevelAdjust();

int CSLGetHasEffectSpellIdGroup( object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1);


int CSLRemoveEffectSpellIdSingle(int RemoveMethod, object oCreator, object oTarget, int iSpellId, int iEffectTypeID = -1, int nEffectSubType = -1 );
int CSLRemoveEffectTypeSingle(int RemoveMethod, object oCreator, object oTarget, int iEffectTypeID, int nEffectSubType=-1 );

int CSLGetAreaOfEffectSpellIdGroup( object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1);
int CSLIsEffectSpellIdGroup( effect eEffect, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1);
void CSLRemoveEffectSpellIdGroup_Void( int RemoveMethod, object oCreator, object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1 );
int CSLRemoveEffectSpellIdGroup( int RemoveMethod, object oCreator, object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1 );

int CSLGetHasEffectType(object oTarget, int iEffectTypeID, int nEffectSubType=-1 );
int CSLRemoveEffectByType(object oPC, int nEffectType, int nEffectSubType=-1, object oCreator=OBJECT_INVALID);
int CSLRemoveEffectByCreator(object oTarget, object oCreator = OBJECT_INVALID, int bMagicalEffectsOnly = FALSE);
void CSLRemoveOrphanedEffects( object oTarget );
void CSLRemoveAllEffects( object oTarget, int iStateWhatsRemoved = FALSE, string sMessage = "" );
void CSLUnstackSpellEffects(object oPC, int iSpellId, string sWithSpell="");
void CSLRemoveAuraById( object oTarget = OBJECT_SELF, int iSpellId = -1 );

int CSLReadIntModifier( object oCaster, string sModifierName, int iModifier = 0 );
*/
/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


//------------------------------------------------------------------------------
// * This is our little concentration system for black blade of disaster
// * if the mage tries to cast any kind of spell, the blade is signaled an event to die
//------------------------------------------------------------------------------
void CSLBreakConcentrationSpells()
{
    // * At the moment we got only one concentration spell, black blade of disaster

    object oAssoc = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    if (GetIsObjectValid(oAssoc) && GetIsPC(OBJECT_SELF)) // only applies to PCS
    {
        if(GetTag(oAssoc) == "x2_s_bblade") // black blade of disaster
        {
            if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
            {
                SignalEvent(oAssoc,EventUserDefined(SC_EVENT_CONCENTRATION_BROKEN));
            }
        }
    }
}

//------------------------------------------------------------------------------
// being hit by any kind of negative effect affecting the caster's ability to concentrate
// will cause a break condition for concentration spells
//------------------------------------------------------------------------------
int CSLGetBreakConcentrationCondition(object oPlayer)
{
     effect e1 = GetFirstEffect(oPlayer);
     int nType;
     int bRet = FALSE;
     while (GetIsEffectValid(e1) && !bRet)
     {
        nType = GetEffectType(e1);

        if (nType == EFFECT_TYPE_STUNNED || nType == EFFECT_TYPE_PARALYZE ||
            nType == EFFECT_TYPE_SLEEP || nType == EFFECT_TYPE_FRIGHTENED ||
            nType == EFFECT_TYPE_PETRIFY || nType == EFFECT_TYPE_CONFUSED ||
            nType == EFFECT_TYPE_DOMINATED || nType == EFFECT_TYPE_POLYMORPH)
         {
           bRet = TRUE;
         }
                    e1 = GetNextEffect(oPlayer);
     }
    return bRet;
}

void CSLDoBreakConcentrationCheck()
{
    object oMaster = GetMaster();
    if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
    {
         if (GetIsObjectValid(oMaster))
         {
            int nAction = GetCurrentAction(oMaster);
            // master doing anything that requires attention and breaks concentration
            if (nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT ||
                nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT ||
                nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP ||
                nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL)
            {
                SignalEvent(OBJECT_SELF,EventUserDefined(SC_EVENT_CONCENTRATION_BROKEN));
            }
            else if (CSLGetBreakConcentrationCondition(oMaster))
            {
                SignalEvent(OBJECT_SELF,EventUserDefined(SC_EVENT_CONCENTRATION_BROKEN));
            }
         }
    }
}


/**  
* Get the stored attributes for a given spell ( set in the HkPreCast to cache them )
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSpellAttributes( object oCaster = OBJECT_SELF )
{
	int iAttributes = GetLocalInt( oCaster, "HKTEMP_Attributes" );
	if ( iAttributes > -1 )
	{
		return iAttributes;
	}
	return 0; // don't return any if none available, note that 0 does not mean anything, logic needs to be for positive
}

/**  
* Takes the one letter code and returns the school constant
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSchoolByInitial(string sSchool)
{
	if (sSchool=="A") return SPELL_SCHOOL_ABJURATION;
	if (sSchool=="C") return SPELL_SCHOOL_CONJURATION;
	if (sSchool=="D") return SPELL_SCHOOL_DIVINATION;
	if (sSchool=="E") return SPELL_SCHOOL_ENCHANTMENT;
	if (sSchool=="V") return SPELL_SCHOOL_EVOCATION;
	if (sSchool=="I") return SPELL_SCHOOL_ILLUSION;
	if (sSchool=="N") return SPELL_SCHOOL_NECROMANCY;
	if (sSchool=="T") return SPELL_SCHOOL_TRANSMUTATION;
	return SPELL_SCHOOL_GENERAL;
}

/**  
* Takes the school constant and returns its name as a string
* @author
* @param 
* @see 
* @return 
*/
string CSLSchoolToString(int iSpellSchool)
{
	if (iSpellSchool==SPELL_SCHOOL_ABJURATION) return "Abjuration";
	if (iSpellSchool==SPELL_SCHOOL_CONJURATION ) return "Conjuration";
	if (iSpellSchool==SPELL_SCHOOL_DIVINATION ) return "Divination";
	if (iSpellSchool==SPELL_SCHOOL_ENCHANTMENT ) return "Enchantment";
	if (iSpellSchool==SPELL_SCHOOL_EVOCATION ) return "Evocation";
	if (iSpellSchool==SPELL_SCHOOL_ILLUSION ) return "Illusion";
	if (iSpellSchool==SPELL_SCHOOL_NECROMANCY ) return "Necromancy";
	if (iSpellSchool==SPELL_SCHOOL_TRANSMUTATION ) return "Transmutation";
	return "General";
}

int CSLSchoolToSchoolItemProp(int iSpellSchool)
{
	if (iSpellSchool==SPELL_SCHOOL_ABJURATION) return IP_CONST_SPELLSCHOOL_ABJURATION;
	if (iSpellSchool==SPELL_SCHOOL_CONJURATION ) return IP_CONST_SPELLSCHOOL_CONJURATION;
	if (iSpellSchool==SPELL_SCHOOL_DIVINATION ) return IP_CONST_SPELLSCHOOL_DIVINATION;
	if (iSpellSchool==SPELL_SCHOOL_ENCHANTMENT ) return IP_CONST_SPELLSCHOOL_ENCHANTMENT;
	if (iSpellSchool==SPELL_SCHOOL_EVOCATION ) return IP_CONST_SPELLSCHOOL_EVOCATION;
	if (iSpellSchool==SPELL_SCHOOL_ILLUSION ) return IP_CONST_SPELLSCHOOL_ILLUSION;
	if (iSpellSchool==SPELL_SCHOOL_NECROMANCY ) return IP_CONST_SPELLSCHOOL_NECROMANCY;
	if (iSpellSchool==SPELL_SCHOOL_TRANSMUTATION ) return IP_CONST_SPELLSCHOOL_TRANSMUTATION;
	return -1;
}

int CSLSchoolItemPropToSchool(int iSpellSchoolProp)
{
	if (iSpellSchoolProp==IP_CONST_SPELLSCHOOL_ABJURATION) return SPELL_SCHOOL_ABJURATION;
	if (iSpellSchoolProp==IP_CONST_SPELLSCHOOL_CONJURATION ) return SPELL_SCHOOL_CONJURATION;
	if (iSpellSchoolProp==IP_CONST_SPELLSCHOOL_DIVINATION ) return SPELL_SCHOOL_DIVINATION;
	if (iSpellSchoolProp==IP_CONST_SPELLSCHOOL_ENCHANTMENT ) return SPELL_SCHOOL_ENCHANTMENT;
	if (iSpellSchoolProp==IP_CONST_SPELLSCHOOL_EVOCATION ) return SPELL_SCHOOL_EVOCATION;
	if (iSpellSchoolProp==IP_CONST_SPELLSCHOOL_ILLUSION ) return SPELL_SCHOOL_ILLUSION;
	if (iSpellSchoolProp==IP_CONST_SPELLSCHOOL_NECROMANCY ) return SPELL_SCHOOL_NECROMANCY;
	if (iSpellSchoolProp==IP_CONST_SPELLSCHOOL_TRANSMUTATION ) return SPELL_SCHOOL_TRANSMUTATION;
	return 0;
}

/**  
* Takes the subschool constant and returns its name as a string
* @author
* @param 
* @see 
* @return 
*/
string CSLSubSchoolToString(int iSpellSubSchool)
{
	if (iSpellSubSchool == SPELL_SCHOOL_GENERAL) return "None";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_CALLING ) return "Calling";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_CREATION ) return "Creation";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_HEALING ) return "Healing";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_SUMMONING ) return "Summoning";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_TELEPORTATION ) return "Teleportation";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_WILD ) return "Wild Magic";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_PACT  ) return "Pact Magic";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_DJINN ) return "Djinn";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_SCRYING ) return "Scrying";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_NAMING ) return "True Naming";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_CHARM ) return "Charm";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_COMPULSION ) return "Compulsion";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_PSIONIC  ) return "Psionic";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_FIGMENT ) return "Figment";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_GLAMER  ) return "Glamer";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_PATTERN  ) return "Pattern";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_PHANTASM  ) return "Phantasm";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_SHADOW  ) return "Shadow";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_CURSE  ) return "Curse";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_BLOOD  ) return "Blood";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_INCARNUM ) return "Incranum";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_POLYMORPH  ) return "Polymorph";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_FLESH  ) return "Flesh";
	if (iSpellSubSchool & SPELL_SUBSCHOOL_CHRONOS  ) return "Chronos";
	return "General";
}


/**  
* Takes the SC_SPELLTYPE_* constant and returns it's name in a string
* @author
* @param int iCasterType
* @see 
* @return 
*/
string CSLGetBaseCasterTypeDescription( int iCasterType )
{
	// add psionic if there is a need
	switch ( iCasterType )
	{
		case SC_SPELLTYPE_ARCANE:
			return "Arcane";
			break;
		case SC_SPELLTYPE_DIVINE:
			return "Divine";
			break;
		case SC_SPELLTYPE_ELDRITCH:
			return "Eldritch";
			break;
		case SC_SPELLTYPE_NONE:
			return "None";
			break;
		default:
			return "None";
	}
	return "None";

}

/**  
* Quick lookup to get the AOE radius in meters for common spells
* @author
* @param int iSpellId
* @see 
* @return 
*/
int CSLGetAOERadius(int iSpellId)
{
	if (iSpellId==SPELL_ACID_FOG                       ) return 5;
	if (iSpellId==SPELL_CLOUD_OF_BEWILDERMENT          ) return 5;
	if (iSpellId==SPELL_CLOUDKILL                      ) return 5;
	if (iSpellId==SPELL_CREEPING_DOOM                  ) return 7;
	if (iSpellId==SPELL_DARKNESS                       ) return 7;
	if (iSpellId==SPELL_ENTANGLE                       ) return 5;
	if (iSpellId==SPELL_EVARDS_BLACK_TENTACLES         ) return 5;
	if (iSpellId==SPELL_GLYPH_OF_WARDING               ) return 5;
	if (iSpellId==SPELL_GREASE                         ) return 6;
	if (iSpellId==SPELL_GREATER_SHADOW_CONJURATION_WEB ) return 7;
	if (iSpellId==SPELL_I_CHILLING_TENTACLES           ) return 5;
	if (iSpellId==SPELL_I_TENACIOUS_PLAGUE             ) return 7;
	if (iSpellId==SPELL_I_WALL_OF_PERILOUS_FLAME       ) return 5; // * NO RADIUS GIVEN
	if (iSpellId==SPELL_INCENDIARY_CLOUD               ) return 5;
	if (iSpellId==SPELL_MIND_FOG                       ) return 5;
	if (iSpellId==SPELL_SHADES_WALL_OF_FIRE            ) return 5; // * NO RADIUS GIVEN
	if (iSpellId==SPELL_SHADOW_CONJURATION_DARKNESS    ) return 5; // * NO RADIUS GIVEN
	if (iSpellId==SPELL_SPIKE_GROWTH                   ) return 5;
	if (iSpellId==SPELL_SILENCE                        ) return 4;
	if (iSpellId==SPELL_SILENCE_AOE                    ) return 5; // * NO RADIUS GIVEN
	if (iSpellId==SPELL_STINKING_CLOUD                 ) return 7;
	if (iSpellId==SPELL_STONEHOLD                      ) return 5;
	if (iSpellId==SPELL_STORM_OF_VENGEANCE             ) return 10;
	if (iSpellId==SPELL_VINE_MINE_CAMOUFLAGE           ) return 6;
	if (iSpellId==SPELL_VINE_MINE_ENTANGLE             ) return 6;
	if (iSpellId==SPELL_WALL_OF_FIRE                   ) return 5; // * NO RADIUS GIVEN
	if (iSpellId==SPELL_WEB                            ) return 5; // * NO RADIUS GIVEN
	//nopes
	//SP_bladebarselfA
	//SP_bladebarwallA
	
	// maybes
	//SP_delblstfirebA
	//SP_grtwalldispmA
	//SP_walldispmagiA
	//SP_spherechaosA
		
	//   if (SPELL_BATTLETIDE)                      return 4;
	//   if (SPELL_BLADE_BARRIER_SELF)              return 4;
	//   if (SPELL_BLADE_BARRIER_WALL)              return 5; // * NO RADIUS GIVEN
	//   if (SPELL_BODY_OF_THE_SUN)                 return 4;
	//   if (SPELL_GHOUL_TOUCH)                     return 2;
	//   if (SPELL_INVISIBILITY_PURGE)              return 7;
	//   if (SPELL_INVISIBILITY_SPHERE)             return 5;
	//   if (SPELL_SILENCE)                         return 4;
	return 0;
}


/**  
* Figures out the magic slot level adjustment needed for a given metamagic
* Description
* @author
* @see 
* @return 
*/
int CSLGetMetaMagicSlotLevelAdjust()
{
	int iSpellSlotLevel;
	int iMetaMagicMod = 0;
	
	int iMetaMagic = GetMetaMagicFeat();
	//SendMessageToPC(OBJECT_SELF,IntToString(iMetaMagic));
	if ( iMetaMagic > 0 )
	{
		if ( iMetaMagic & METAMAGIC_SILENT )
		{
			if ( GetHasFeat( FEAT_PRACTICAL_METAMAGIC_SILENT_SPELL ) )
			{
				iMetaMagicMod += 0;
			}
			else
			{
				iMetaMagicMod += 1;
			}
		}
		if ( iMetaMagic & METAMAGIC_STILL )
		{
			if ( GetHasFeat( FEAT_PRACTICAL_METAMAGIC_STILL_SPELL ) )
			{
				iMetaMagicMod += 0;
			}
			else
			{
				iMetaMagicMod += 1;
			}
		}
		if ( iMetaMagic & METAMAGIC_EXTEND )
		{
			if ( GetHasFeat( FEAT_PRACTICAL_METAMAGIC_EXTEND_SPELL ) )
			{
				iMetaMagicMod += 0;
			}
			else
			{
				iMetaMagicMod += 1;
			}
		}
		if ( iMetaMagic & METAMAGIC_EMPOWER )
		{
			if ( GetHasFeat( FEAT_IMPROVED_EMPOWER_SPELL ) )
			{
				iMetaMagicMod += 1;
			}
			else
			{
				iMetaMagicMod += 2;
			}
		}
		if ( iMetaMagic & METAMAGIC_MAXIMIZE )
		{
			if ( GetHasFeat( FEAT_IMPROVED_MAXIMIZE_SPELL ) )
			{
				iMetaMagicMod += 2;
			}
			else
			{
				iMetaMagicMod += 3;
			}
		}
		if ( iMetaMagic & METAMAGIC_QUICKEN )
		{
			if ( GetHasFeat( FEAT_IMPROVED_QUICKEN_SPELL ) )
			{
				iMetaMagicMod += 3;
			}
			else
			{
				iMetaMagicMod += 4;
			}
	
		}
		if ( iMetaMagic & METAMAGIC_PERMANENT ) { iMetaMagicMod += 6; }
		if ( iMetaMagic & METAMAGIC_PERSISTENT ) { iMetaMagicMod += 6; }
	}
	
	//if ( iMetaMagicMod > 0 )
	//{
	//	SendMessageToPC(OBJECT_SELF,"Metamagic Boost is "+IntToString(iMetaMagicMod));
	//}
	//return 0;
	return iMetaMagicMod;
}


/**  
* Returns the Power cap for various dispels
* @author
* @param int iSpellId = -1
* @see 
* @return 
*/
int CSLGetDispelPowerCap( int iSpellId = -1 )
{
	if (iSpellId==SPELL_LESSER_DISPEL)                     return 5;
	if (iSpellId==SPELL_LESSER_DISPEL_FRIEND)              return 5;
	if (iSpellId==SPELL_LESSER_DISPEL_HOSTILE)             return 5;
	if (iSpellId==SPELL_LESSER_DISPEL_AOE)                 return 5;
	
	if (iSpellId==SPELL_DISPEL_MAGIC)                      return 10;
	if (iSpellId==SPELL_DISPEL_MAGIC_FRIEND)               return 10;
	if (iSpellId==SPELL_DISPEL_MAGIC_HOSTILE)              return 10;
	if (iSpellId==SPELL_DISPEL_MAGIC_AOE)                  return 10;

	if (iSpellId==SPELL_I_VORACIOUS_DISPELLING)            return 10;
	if (iSpellId==SPELL_WALL_DISPEL_MAGIC)                 return 10;
	if (iSpellId==SPELL_I_DEVOUR_MAGIC)                    return 15;
	
	if (iSpellId==SPELL_GREATER_DISPELLING)                return 20;
	if (iSpellId==SPELL_GREATER_DISPELLING_FRIEND)         return 20;
	if (iSpellId==SPELL_GREATER_DISPELLING_HOSTILE)        return 20;
	if (iSpellId==SPELL_GREATER_DISPELLING_AOE)            return 20;
	
	if (iSpellId==SPELL_CHAIN_DISPEL)						return 25;
	
	if (iSpellId==SPELL_GREATER_WALL_DISPEL_MAGIC)         return 20;
	
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION)         return 60;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_FRIEND)  return 60;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_HOSTILE) return 60;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_AOE)     return 60;
	
	if (iSpellId==SPELLABILITY_AA_SEEKER_ARROW_1 || iSpellId==SPELLABILITY_AA_SEEKER_ARROW_2) {
		int nAA = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);
		if (nAA<7) return 10;
		if (nAA<10) return 20;
		return 30;
	}
	if (iSpellId==SPELLABILITY_PILFER_MAGIC) {
		int nAT = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, OBJECT_SELF);
		if (nAT<5) return 10;
		if (nAT<9) return 20;
		return 30;
	}
	return 3;


}

/**  
* Returns the spell level for various dispels
* @author
* @param int iSpellId
* @see 
* @return 
*/
int CSLGetDispellLevel(int iSpellId)
{
	if (iSpellId==SPELL_LESSER_DISPEL)						return 2;
	if (iSpellId==SPELL_LESSER_DISPEL_FRIEND)				return 2;
	if (iSpellId==SPELL_LESSER_DISPEL_HOSTILE)				return 2;
	if (iSpellId==SPELL_LESSER_DISPEL_AOE)					return 2;
	
	if (iSpellId==SPELL_DISPEL_MAGIC)						return 3;
	if (iSpellId==SPELL_DISPEL_MAGIC_FRIEND)				return 3;
	if (iSpellId==SPELL_DISPEL_MAGIC_HOSTILE)				return 3;
	if (iSpellId==SPELL_DISPEL_MAGIC_AOE)					return 3;

	if (iSpellId==SPELL_I_VORACIOUS_DISPELLING)				return 4;
	if (iSpellId==SPELL_WALL_DISPEL_MAGIC)					return 5;
	if (iSpellId==SPELL_I_DEVOUR_MAGIC)						return 6;
	
	if (iSpellId==SPELL_GREATER_DISPELLING)					return 8;
	if (iSpellId==SPELL_GREATER_DISPELLING_FRIEND)			return 8;
	if (iSpellId==SPELL_GREATER_DISPELLING_HOSTILE)			return 8;
	if (iSpellId==SPELL_GREATER_DISPELLING_AOE)				return 8;
	
	if (iSpellId==SPELL_CHAIN_DISPEL)						return 8;
	
	if (iSpellId==SPELL_GREATER_WALL_DISPEL_MAGIC)			return 8;
	
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION)			return 9;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_FRIEND)	return 9;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_HOSTILE)	return 9;
	if (iSpellId==SPELL_MORDENKAINENS_DISJUNCTION_AOE)		return 9;
	
	if (iSpellId==SPELLABILITY_AA_SEEKER_ARROW_1 || iSpellId==SPELLABILITY_AA_SEEKER_ARROW_2)
	{
		int nAA = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);
		if (nAA<7) return 3;
		if (nAA<10) return 5;
		return 7;
	}
	if (iSpellId==SPELLABILITY_PILFER_MAGIC)
	{
		int nAT = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, OBJECT_SELF);
		if (nAT<5) return 3;
		if (nAT<9) return 5;
		return 7;
	}
	return 3;
}


/**  
* Returns if a given spell is a cloud, note that it returns a 2 if really a cloud and a 1 if more of an AOE, this allows a choice as to which set of rules to use
* @author
* @param int iSpellId
* @see 
* @return 
*/
// Returns true or false based on if the SpellId is from a cloud of some sort
int CSLGetIsCloud ( int iSpellId )
{
	switch ( iSpellId )
	{
		// Obivious ones
		case SPELL_MIND_FOG:
		case SPELL_CLOUD_OF_BEWILDERMENT:
		case SPELL_CLOUDKILL:
		case SPELL_INCENDIARY_CLOUD:
		case SPELL_STINKING_CLOUD:
		case SPELL_CREEPING_DOOM:
		case SPELL_ACID_FOG:
		case SPELL_STONEHOLD:
		case SPELL_GLITTERDUST:
		case ELEM_ARCHER_ELEM_STORM:
		case SPELLABILITY_SHROUDING_FOG:
		case SPELL_ACID_STORM:
		case SPELL_BLOODSTORM:
		case SPELL_FOG_CLOUD:
		case SPELL_SHADOW_STORM:
		case SPELL_STORM_OF_VENGEANCE:
		case STORMSINGER_STORM_VENGEANCE:
			return 2;
			break;
		// Questionable, auras that clearly would be a cloud or on the wind, these would have to be Reapplied within 2-3 rounds if they were stripped before this is an option.
		//case SPELLABILITY_TYRANT_FOG_MIST
		//case SPELLABILITY_SHROUDING_FOG
		//case SPELLABILITY_HEZROU_STENCH
		// Debateable
		//case SPELL_I_TENACIOUS_PLAGUE: // ( blows the bugs away )
		// Exceptions ( thinking about balance really here, meant to be house rules for our server )
		case SPELL_SILENCE:
		case SPELL_SILENCE_AOE:
		case SPELL_INVISIBILITY_PURGE:
		// Definitely not ( fire fans flames, blade barriers would not care about wind, but some of these might be options for some mods/worlds )
		//case SPELL_I_WALL_OF_PERILOUS_FLAME:
		//case SPELL_SHADES_WALL_OF_FIRE:
		//case SPELL_WALL_OF_FIRE:
		//case SPELL_BLADE_BARRIER_WALL:
		//case SPELL_WALL_DISPEL_MAGIC:
		//case SPELL_GREATER_WALL_DISPEL_MAGIC:
		//case SPELL_DARKNESS:
		case SPELL_GREASE:
		//case SPELL_GLYPH_OF_WARDING:
		//case SPELL_DELAYED_BLAST_FIREBALL:
		//case SPELL_SHADES_TARGET_CREATURE: // ( this is del blast fireball, but it never gets delayed --fixed in 2da so it's correct and not normal fireball )
		//case SPELL_WEB:
		//case SPELL_GREATER_SHADOW_CONJURATION_WEB:
		//case SPELL_VINE_MINE:
		//case SPELL_VINE_MINE_CAMOUFLAGE:
		//case SPELL_VINE_MINE_ENTANGLE:
		//case SPELL_VINE_MINE_HAMPER_MOVEMENT:
		//case SPELL_VISAGE_OF_THE_DEITY:
		//case SPELL_Visage_Deity:
		return 1;
			break;

		default:
			return FALSE;
	}
	return FALSE;
}


/**  
* Gets the DC bonus based on epic caster level
* @author
* @param object oPC
* @see 
* @return 
*/
int CSLGetDCBonusByLevel(object oPC)
{
	int nDCBonus = 0;
	
	int iLevel = GetHitDice(oPC);
	
	if (iLevel > 28) // 29
	{
		nDCBonus += 3;
	}
	else if (iLevel > 25) // 26
	{
		nDCBonus += 2;
	}
	else if (iLevel > 22) // 23
	{
		nDCBonus += 1;
	}
	
	if (GetHasFeat(1114, oPC)) //Spellcasting Prodigy
	{
		nDCBonus += 1;
	}
	return nDCBonus;
}


/**  
* Returns the DC bonuses from school focus feats
* @author
* @param object oCaster, int iCurrentSchool
* @see 
* @return 
*/
int CSLGetDCSchoolFocusAdjustment(object oCaster, int iCurrentSchool )
{
	int iBonus = 0;

	if ( iCurrentSchool == SPELL_SCHOOL_ABJURATION )
	{
		if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oCaster))         { iBonus++; }
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oCaster)) { iBonus++; }
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oCaster))    { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_CONJURATION  )
	{
		if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oCaster))         { iBonus++; }
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster)) { iBonus++; }
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))    { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_DIVINATION )
	{
		if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oCaster))         { iBonus++; }
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINIATION, oCaster)) { iBonus++; }
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oCaster))    { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_ENCHANTMENT )
	{
		if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oCaster))         { iBonus++; }
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oCaster)) { iBonus++; }
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster))    { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_EVOCATION )
	{
		if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oCaster))         { iBonus++; }
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster)) { iBonus++; }
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster))    { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_ILLUSION )
	{
		if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oCaster))         { iBonus++; }
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oCaster)) { iBonus++; }
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oCaster))    { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_NECROMANCY )
	{
		if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oCaster))         { iBonus++; }
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oCaster)) { iBonus++; }
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oCaster))    { iBonus++; }
	}
	else if ( iCurrentSchool == SPELL_SCHOOL_TRANSMUTATION )
	{
		if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oCaster))         { iBonus++; }
		if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oCaster)) { iBonus++; }
		if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oCaster))    { iBonus++; }
	}
	return iBonus;
}



/**  
* Returns the metamagic names as a string from the given metamagic integer
* @author
* @param int iMetaMagic, int bReturnAll = FALSE
* @see 
* @return 
*/
string CSLGetMetaMagicName(int iMetaMagic, int bReturnAll = FALSE)
{
	string sMetaMagic = "";
	if (iMetaMagic==METAMAGIC_NONE)			return "";
	if (iMetaMagic & METAMAGIC_EMPOWER)		sMetaMagic += "Empowered ";
	if (iMetaMagic & METAMAGIC_EXTEND)		sMetaMagic += "Extended ";
	if (iMetaMagic & METAMAGIC_MAXIMIZE)   sMetaMagic += "Maximized ";
	if (iMetaMagic & METAMAGIC_QUICKEN)		sMetaMagic += "Quickened ";
	if (iMetaMagic & METAMAGIC_SILENT)		sMetaMagic += "Silent ";
	if (iMetaMagic & METAMAGIC_STILL)		sMetaMagic += "Stilled ";
	if (iMetaMagic & METAMAGIC_PERSISTENT)	sMetaMagic += "Persistent ";
	if (iMetaMagic & METAMAGIC_PERMANENT)	sMetaMagic += "Permanent ";
	
	if ( bReturnAll )
	{
		if (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)	sMetaMagic += "DrainingBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_ELDRITCH_SPEAR)	sMetaMagic += "EldritchSpear ";
		if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)	sMetaMagic += "FrightfulBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_HIDEOUS_BLOW)		sMetaMagic += "HideousBlow ";
		if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST)	sMetaMagic += "BeshadowedBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)	sMetaMagic += "BrimstoneBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_ELDRITCH_CHAIN)	sMetaMagic += "EldritchChain ";
		if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)	sMetaMagic += "HellrimeBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST)	sMetaMagic += "BewitchingBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_ELDRITCH_CONE)		sMetaMagic += "EldritchCone ";
		if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)		sMetaMagic += "NoxiousBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)	sMetaMagic += "VitriolicBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_ELDRITCH_DOOM)		sMetaMagic += "EldritchDoom ";
		if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)	sMetaMagic += "UtterdarkBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST)	sMetaMagic += "HinderingBlast ";
		if (iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST)		sMetaMagic += "BindingBlast ";
		//if (iMetaMagic & METAMAGIC_ANY )	sMetaMagic += "Any";
	}
	
	return sMetaMagic;
	//return "MissMetaMagic" + IntToString(iMetaMagic);
}




/**  
* Gets the automatic metamagics in use
* @author
* @param int iMetaMagic, object oPC = OBJECT_SELF
* @see 
* @return 
*/
int CSLGetAutomaticMetamagic( int iMetaMagic, object oPC = OBJECT_SELF )
{
	int iSpellSlotLevel = GetSpellLevel( GetSpellId() )+CSLGetMetaMagicSlotLevelAdjust();
	iSpellSlotLevel = CSLGetMax( CSLGetMin( iSpellSlotLevel, 9 ), 0 );
	
	if ( iSpellSlotLevel >= 7 ) // levels 7-9
	{
		if ( iSpellSlotLevel >= 9 && GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_9, oPC ) )
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		else if ( iSpellSlotLevel >= 8 &&  GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_8, oPC ) )
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		else if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_7, oPC ) ) // covers 7
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		
		if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3, oPC ) )
		{
			iMetaMagic |= METAMAGIC_SILENT;
		}
		
		if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_STILL_SPELL_3, oPC ) )
		{
			iMetaMagic |= METAMAGIC_STILL;
		}
	}
	else if ( iSpellSlotLevel >= 4 ) // levels 4-6
	{
		if ( iSpellSlotLevel >= 6 && GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_6, oPC ) )
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		else if ( iSpellSlotLevel >= 5 &&  GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_5, oPC ) )
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		else if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_4, oPC ) ) // covers 4
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		
		if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_SILENT_SPELL_2, oPC ) )
		{
			iMetaMagic |= METAMAGIC_SILENT;
		}
		
		if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_STILL_SPELL_2, oPC ) )
		{
			iMetaMagic |= METAMAGIC_STILL;
		}
	}
	else // levels 0-3
	{
		if ( iSpellSlotLevel >= 3 && GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_3, oPC ) )
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		else if ( iSpellSlotLevel >= 2 &&  GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_2, oPC ) )
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		else if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_QUICKEN_1, oPC ) ) // covers 0-1
		{
			iMetaMagic |= METAMAGIC_QUICKEN;
		}
		
		if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1, oPC ) )
		{
			iMetaMagic |= METAMAGIC_SILENT;
		}
		
		if ( GetHasFeat( FEAT_EPIC_AUTOMATIC_STILL_SPELL_1, oPC ) )
		{
			iMetaMagic |= METAMAGIC_STILL;
		}
	} 
	return iMetaMagic;
}

	
	




object oSpellTable;

/**  
* Makes sure the oSpellTable is a valid pointer to the spells dataobject
* @author
* @see 
* @return 
*/
void CSLGetSpellDataObject()
{
	if ( !GetIsObjectValid( oSpellTable ) )
	{
		oSpellTable = CSLDataObjectGet( "spells" );
	}
	//return oSpellTable;
}

string CSLGetSpellBookNameByClass( int iClass )
{
	string sSpellBook;
	switch ( iClass )
	{
		case CLASS_TYPE_BARD:
			sSpellBook = "Bard";
			break;
		case CLASS_TYPE_SORCERER:
		case CLASS_TYPE_WIZARD:
			sSpellBook = "Wiz_Sorc";
			break;
		case CLASS_TYPE_ASSASSIN:
			sSpellBook = "";
			break;
		case CLASS_TYPE_CLERIC:
		case CLASS_TYPE_FAVORED_SOUL:
			sSpellBook = "Cleric";
			break;
		case CLASS_TYPE_DRUID:
		case CLASS_TYPE_SPIRIT_SHAMAN:
			sSpellBook = "Druid";
			break;
		case CLASS_TYPE_BLACKGUARD:
			sSpellBook = "";
			break;
		case CLASS_TYPE_PALADIN:
			sSpellBook = "Paladin";
			break;
		case CLASS_TYPE_RANGER:
			sSpellBook = "Ranger";
			break;
		case CLASS_TYPE_WARLOCK:
			sSpellBook = "Warlock";
			break;
		default:
			sSpellBook = "";
	}
	return sSpellBook;
}



object CSLGetSpellBookByClass( int iClass )
{
	
	// SendMessageToPC( GetFirstPC(),"loading spellbook "+"spellbook_"+CSLGetSpellBookNameByClass( iClass )+" for class "+IntToString(iClass) );
	return CSLDataObjectGet( "spellbook_"+CSLGetSpellBookNameByClass( iClass ) );
}


int CSLGetBestAvailableSpell(object oCaster)
{
	int iClass = GetLocalInt(oCaster, "SC_iBestCasterClass" ); // this is stored on level up // SC_iBestArcaneClass  SC_iBestDivineClass
	
	object oSpellBook = CSLGetSpellBookByClass( iClass );
	if ( !GetIsObjectValid( oSpellBook ) )
	{
		//talent GetCreatureTalentBest(int nCategory, int nCRMax, object oCreature=OBJECT_SELF, 3);
		//int GetIdFromTalent(talent tTalent);
		
		return -1;
	}
	int iMaxLevel = GetLocalInt(oCaster, "SC_iBestCasterMaxSpellLevel" );
	int iTotalItems = CSLDataTableCount( oSpellBook );
	
	// go ahead and find the spot where the caster might have spells of a given level
	int iStartRow = GetLocalInt(oSpellBook, "DATATABLE_SORTQUANTITY_"+IntToString(iMaxLevel) );
	if ( iStartRow > -1 )
	{
		iTotalItems = iStartRow+GetLocalInt(oSpellBook, "DATATABLE_SORTSTART_"+IntToString(iMaxLevel) );
	}
	 
	int iRow, iCurrent;
	for ( iCurrent = iTotalItems; iCurrent >= 0; iCurrent--) 
	{
		iRow = CSLDataTableGetRowByIndex( oSpellBook, iCurrent );
		if ( GetHasSpell(iRow, oCaster) > 0 && GetSpellKnown(oCaster, iRow) ) // doing both, there is an issue with monster summoning always returning odd numbers
		{
			return iRow;
		}
	
	}
	return -1;
}






/**  
* Get the name of a spell
* @param iSpellId Identifier of the spell
* @replaces XXXJXGetSpellName
* @return the name of the specified spell
*/
string CSLGetSpellDataName(int iSpellId)
{
	CSLGetSpellDataObject();
	if ( !GetIsObjectValid( oSpellTable ) )
	{
		string sString = Get2DAString("spells", "NAME", iSpellId);
		
		if ( IntToString( StringToInt(sString) ) == sString )
		{
			string sResult=GetStringByStrRef(StringToInt(sString));
			if ( sResult != "" )
			{
				sString = CSLRemoveAllTags(sResult); // don't store any color information, if that is needed its likely larger fields which should not need it to begin with
			}
		}
		return sString;
	}
	return CSLDataTableGetStringByRow( oSpellTable, "NAME", iSpellId );
	
	//string sSpellNameStrRef = Get2DAString("spells", "NAME", iSpellId);
	//if (sSpellNameStrRef == "") return "";
	//
	//return GetStringByStrRef(StringToInt(sSpellNameStrRef));
}





/**  
* Get the range type of a spell
* @author
* @param Identifier of the spell
* @see 
* @replaces XXXJXGetSpellRangeType
* @return a SPELLRANGE_* constant
*/
int CSLGetSpellDataRangeType(int iSpellId)
{
	CSLGetSpellDataObject();
	string sRange;
	if ( !GetIsObjectValid( oSpellTable ) )
	{
		sRange = Get2DAString("spells", "Range", iSpellId);
	}
	else
	{
		sRange = CSLDataTableGetStringByRow( oSpellTable, "Range", iSpellId );
	}
	if (sRange == "S") return JX_SPELLRANGE_SHORT;
	if (sRange == "M") return JX_SPELLRANGE_MEDIUM;
	if (sRange == "L") return JX_SPELLRANGE_LONG;
	if (sRange == "P") return JX_SPELLRANGE_PERSONAL;
	if (sRange == "T") return JX_SPELLRANGE_TOUCH;
	return JX_SPELLRANGE_INVALID;
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
string CSLGetSpellDataIcon(int iSpellId)
{
	CSLGetSpellDataObject();
	if ( !GetIsObjectValid( oSpellTable ) )
	{
		return Get2DAString("spells", "IconResRef", iSpellId);
	}
	return CSLDataTableGetStringByRow( oSpellTable, "IconResRef", iSpellId );
}

/**  
* Description
* @author
* @param iSpellId
* @param iClass
* @see 
* @return 
*/
string CSLGetSpellDataLevel(int iSpellId, int iClass = CLASS_TYPE_NONE)
{
	CSLGetSpellDataObject();
	if ( !GetIsObjectValid( oSpellTable ) )
	{
		return Get2DAString("spells", "Innate", iSpellId);
	}
	// assumes iClass is a base casting class
	string sLevel = "";	
	if ( iClass != CLASS_TYPE_NONE )
	{
		string sSpellBook = CSLGetSpellBookNameByClass( iClass );
		if ( sSpellBook != "" )
		{
			sLevel = CSLDataTableGetStringByRow( oSpellTable, sSpellBook, iSpellId );
		}
	}
	if ( sLevel == "" )
	{
		sLevel = CSLDataTableGetStringByRow( oSpellTable, "Innate", iSpellId );
	}
	return sLevel;
}


/**  
* Description
* @author
* @param iSpellId
* @param iClass
* @see 
* @return 
*/
int CSLGetSpellDataSchool(int iSpellId )
{
	CSLGetSpellDataObject();
	if ( !GetIsObjectValid( oSpellTable ) )
	{
		return CSLGetSchoolByInitial(Get2DAString("spells", "School", iSpellId));
	}
	
	return CSLGetSchoolByInitial(CSLDataTableGetStringByRow( oSpellTable, "School", iSpellId ));
}



/**  
* Description
* @author
* @param int iSpellId
* @see 
* @replaces XXXJXGetSpellRange
* @return 
*/
// Get the range of a spell
// - iSpellId Identifier of the spell
// * Return the spell range
float CSLGetSpellRange(int iSpellId)
{
	int iRangeType = CSLGetSpellDataRangeType(iSpellId);
	switch (iRangeType)
	{
		case JX_SPELLRANGE_SHORT : return 8.0;
		case JX_SPELLRANGE_MEDIUM : return 20.0;
		case JX_SPELLRANGE_LONG : return 40.0;
	}
	return 0.0;
}



/**  
* Description
* @author
* @param int iSpellId
* @see 
* @replaces XXXJXGetHasSpellTargetTypeArea
* @return 
*/
// Indicate if the spell can target an area
// - iSpellId Identifier of the spell
// * Return TRUE if the spell can target an area
int CSLGetHasSpellTargetTypeArea(int iSpellId)
{
	CSLGetSpellDataObject();
	string sTargetType;
	if ( !GetIsObjectValid( oSpellTable ) )
	{
		sTargetType = Get2DAString("spells", "Innate", iSpellId);
	}
	else
	{
		sTargetType = CSLDataTableGetStringByRow( oSpellTable, "TargetType", iSpellId );
	}
	//string sTargetType = Get2DAString("spells", "TargetType", iSpellId);
	int iTargetType = CSLHexStringToInt(sTargetType);
	int iTargetTypeArea = 4;

	if (iTargetType & iTargetTypeArea == iTargetTypeArea)
	{
		return TRUE;
	}
	return FALSE;
}


/**  
* Description
* @author
* @param object oPC, int iSpellId
* @see 
* @return 
*/
// * This makes no sense, need to really look at why it is used whereever it shows up, GetHasSpell seems to do the same thing
int CSLGetHasSpell(object oPC, int iSpellId)
{
	talent tSpell = TalentSpell(iSpellId);
	if ( !GetIsTalentValid(tSpell) )
	{
		return FALSE;
	}
	if ( GetIdFromTalent(tSpell) == iSpellId && GetCreatureHasTalent( tSpell, oPC ) )
	{
		return TRUE;
	}
	return FALSE;
}


void CSLListClassSpellBook( object oCurrentSpellBook, object oReceiver, object oTarget, int iStartRow, int iEndRow, string sPreviousLevel = "" )
{
	if ( !GetIsObjectValid(oCurrentSpellBook) )
	{
		return;
	}
	
	int bCompareToTarget = FALSE; // turns on and off bolding of the given spell..
	if ( GetIsObjectValid(oTarget) )
	{
		bCompareToTarget = TRUE;
	}
	int iMaxIterations = 75;
	int iCurrentIteration = 0;
	int iRow, iCurrent;
	string sName;
	string sCurrentLevel;

	for ( iCurrent = iStartRow; iCurrent <= iEndRow; iCurrent++) // changed from <=
	{
		if ( iCurrentIteration > iMaxIterations )
		{
			DelayCommand( 0.1f, CSLListClassSpellBook( oCurrentSpellBook, oReceiver, oTarget, iCurrent, iEndRow, sPreviousLevel ) );
			return;
		}
		
		iRow = CSLDataTableGetRowByIndex( oCurrentSpellBook, iCurrent );
		//Level
		
		if ( iRow > -1 )
		{
			sName = CSLDataTableGetStringByRow( oCurrentSpellBook, "Name", iRow );
			if ( sName != "" )
			{
				sCurrentLevel = CSLDataTableGetStringByRow( oCurrentSpellBook, "Level", iRow );
				if ( sCurrentLevel != sPreviousLevel )
				{
					sPreviousLevel = sCurrentLevel;
					SendMessageToPC(oReceiver,"<b>LEVEL "+sCurrentLevel+"</b>");
				}
				// GetSpellKnown(oPC, SPELL_MAGIC_MISSILE)
				if ( bCompareToTarget && GetSpellKnown(oTarget, iRow ) ) // && GetHasSpell(iRow, oTarget) > 0 && CSLGetHasSpell(oTarget, iRow) ) // doing both, there is an issue with monster summoning always returning odd numbers
				{
					if ( GetHasSpell(iRow, oTarget) > 0 )
					{
						SendMessageToPC( oReceiver, "<color=Ivory>"+GetStringLeft(" "+IntToString(iRow)+"        ", 8) +" - "+sName+"</color>" );
					}
					else
					{
						SendMessageToPC( oReceiver, "<color=LightYellow>"+GetStringLeft(" "+IntToString(iRow)+"        ", 8) +" - "+sName+"</color>" );
					}
				}
				else
				{
					SendMessageToPC( oReceiver, "<color=Yellow>"+GetStringLeft(" "+IntToString(iRow)+"        ", 8) +" - "+sName+"</color>" );
				}
			}
		}
		
		
	}



	
}


/**  
* Description
* @author
* @param int iEffectId, int bLong = TRUE
* @see 
* @return 
*/
string CSLGetEffectSubTypeName( int iEffectId, int bLong = TRUE )
{
	if (iEffectId==SUBTYPE_EXTRAORDINARY) return (bLong) ? "Extraordinary"      : "E";
	if (iEffectId==SUBTYPE_MAGICAL) return (bLong) ? "Magical"     : "M";
	if (iEffectId==SUBTYPE_SUPERNATURAL) return (bLong) ? "Supernatural" : "S";
	
	return (bLong) ? "Unknown" : "?";
	
}


/**  
* Description
* @author
* @param int iEffectId 
* @see 
* @return 
*/
string CSLGetEffectTypeName( int iEffectId )
{
	// look at replacing the english names here with constants from the DMFI for use in translations.
	switch (iEffectId/10)
    {
		case 0:
				// add psionic if there is a need
				if ( iEffectId == EFFECT_TYPE_INVALIDEFFECT ) { return "Invalideffect"; } // 0 <--NA
				if ( iEffectId == EFFECT_TYPE_DAMAGE_RESISTANCE ) { return "Damage Resistance"; } // 1 //EffectDamageResistance
				//if ( iEffectId == EFFECT_TYPE_ABILITY_BONUS ) { return "Ability Bonus"; } // 2
				if ( iEffectId == EFFECT_TYPE_REGENERATE ) { return "Regenerate"; } // 3 //EffectRegenerate
				//if ( iEffectId == EFFECT_TYPE_SAVING_THROW_BONUS ) { return "Saving Throw Bonus"; } // 4
				//if ( iEffectId == EFFECT_TYPE_MODIFY_AC ) { return "Modify Ac"; } // 5
				//if ( iEffectId == EFFECT_TYPE_ATTACK_BONUS ) { return "Attack Bonus"; } // 6
				if ( iEffectId == EFFECT_TYPE_DAMAGE_REDUCTION ) { return "Damage Reduction"; } // 7 //EffectDamageReduction
				//if ( iEffectId == EFFECT_TYPE_DAMAGE_BONUS ) { return "Damage Bonus"; } // 8
				if ( iEffectId == EFFECT_TYPE_TEMPORARY_HITPOINTS ) { return "Temporary Hitpoints"; } // 9 //EffectTemporaryHitpoints
				break;
		case 1:
				//if ( iEffectId == EFFECT_TYPE_DAMAGE_IMMUNITY ) { return "Damage Immunity"; } // 10
				if ( iEffectId == EFFECT_TYPE_ENTANGLE ) { return "Entangle"; } // 11 //EffectEntangle
				if ( iEffectId == EFFECT_TYPE_INVULNERABLE ) { return "Invulnerable"; } // 12 <-- not sure the effect on this one
				if ( iEffectId == EFFECT_TYPE_DEAF ) { return "Deaf"; } // 13 //EffectDeaf
				if ( iEffectId == EFFECT_TYPE_RESURRECTION ) { return "Resurrection"; } // 14 //EffectResurrection
				if ( iEffectId == EFFECT_TYPE_IMMUNITY ) { return "Immunity"; } // 15 //EffectImmunity
				//if ( iEffectId == EFFECT_TYPE_BLIND ) { return "Blind"; } // 16
				if ( iEffectId == EFFECT_TYPE_ENEMY_ATTACK_BONUS ) { return "Enemy Attack Bonus"; } // 17 <-- don's see this
				if ( iEffectId == EFFECT_TYPE_ARCANE_SPELL_FAILURE ) { return "Arcane Spell Failure"; } //18 //EffectArcaneSpellFailure
				//if ( iEffectId == EFFECT_TYPE_MOVEMENT_SPEED ) { return "Movement Speed"; } // 19
				break;
        case 2:
				if ( iEffectId == EFFECT_TYPE_AREA_OF_EFFECT ) { return "Area Of Effect"; } // 20 //EffectAreaOfEffect
				if ( iEffectId == EFFECT_TYPE_BEAM ) { return "Beam"; } // 21 //EffectBeam
				//if ( iEffectId == EFFECT_TYPE_SPELL_RESISTANCE ) { return "Spell Resistance"; } // 22
				if ( iEffectId == EFFECT_TYPE_CHARMED ) { return "Charmed"; } // 23 //EffectCharmed
				if ( iEffectId == EFFECT_TYPE_CONFUSED ) { return "Confused"; } // 24 //EffectConfused
				if ( iEffectId == EFFECT_TYPE_FRIGHTENED ) { return "Frightened"; } // 25 //EffectFrightened
				if ( iEffectId == EFFECT_TYPE_DOMINATED ) { return "Dominated"; } // 26 //EffectDominated
				if ( iEffectId == EFFECT_TYPE_PARALYZE ) { return "Paralyze"; } // 27 //EffectParalyze
				if ( iEffectId == EFFECT_TYPE_DAZED ) { return "Dazed"; } // 28 //EffectDazed
				if ( iEffectId == EFFECT_TYPE_STUNNED ) { return "Stunned"; } // 29 //EffectStunned
				break;
		case 3:
				if ( iEffectId == EFFECT_TYPE_SLEEP ) { return "Sleep"; } // 30 //EffectSleep
				if ( iEffectId == EFFECT_TYPE_POISON ) { return "Poison"; } // 31 //EffectPoison
				if ( iEffectId == EFFECT_TYPE_DISEASE ) { return "Disease"; } // 32 //EffectDisease
				if ( iEffectId == EFFECT_TYPE_CURSE ) { return "Curse"; } // 33 //EffectCurse
				if ( iEffectId == EFFECT_TYPE_SILENCE ) { return "Silence"; } // 34 //EffectSilence
				if ( iEffectId == EFFECT_TYPE_TURNED ) { return "Turned"; } // 35 //EffectTurned
				if ( iEffectId == EFFECT_TYPE_HASTE ) { return "Haste"; } // 36 //EffectHaste
				if ( iEffectId == EFFECT_TYPE_SLOW ) { return "Slow"; } // 37 //EffectSlow
				if ( iEffectId == EFFECT_TYPE_ABILITY_INCREASE ) { return "Ability Increase"; } // 38 //EffectAbilityIncrease
				if ( iEffectId == EFFECT_TYPE_ABILITY_DECREASE ) { return "Ability Decrease"; } // 39//EffectAbilityDecrease
				break;
        case 4:
				if ( iEffectId == EFFECT_TYPE_ATTACK_INCREASE ) { return "Attack Increase"; } // 40 //EffectAttackIncrease
				if ( iEffectId == EFFECT_TYPE_ATTACK_DECREASE ) { return "Attack Decrease"; } // 41 //EffectAttackDecrease
				if ( iEffectId == EFFECT_TYPE_DAMAGE_INCREASE ) { return "Damage Increase"; } // 42 //EffectDamageIncrease
				if ( iEffectId == EFFECT_TYPE_DAMAGE_DECREASE ) { return "Damage Decrease"; } // 43 //EffectDamageDecrease
				if ( iEffectId == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ) { return "Damage Immunity Increase"; } // 44 //EffectDamageImmunityIncrease
				if ( iEffectId == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ) { return "Damage Immunity Decrease"; } // 45 //EffectDamageImmunityDecrease
				if ( iEffectId == EFFECT_TYPE_AC_INCREASE ) { return "Ac Increase"; } // 46 //EffectACIncrease
				if ( iEffectId == EFFECT_TYPE_AC_DECREASE ) { return "Ac Decrease"; } // 47 //EffectACDecrease
				if ( iEffectId == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ) { return "Movement Speed Increase"; } // 48 //EffectMovementSpeedIncrease
				if ( iEffectId == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ) { return "Movement Speed Decrease"; } // 49 //EffectMovementSpeedDecrease
				break;
		case 5:
				if ( iEffectId == EFFECT_TYPE_SAVING_THROW_INCREASE ) { return "Saving Throw Increase"; } // 50 //EffectSavingThrowIncrease
				if ( iEffectId == EFFECT_TYPE_SAVING_THROW_DECREASE ) { return "Saving Throw Decrease"; } // 51 //EffectSavingThrowDecrease
				if ( iEffectId == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ) { return "Spell Resistance Increase"; } // 52 //EffectSpellResistanceIncrease
				if ( iEffectId == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ) { return "Spell Resistance Decrease"; } // 53 //EffectSpellResistanceDecrease
				if ( iEffectId == EFFECT_TYPE_SKILL_INCREASE ) { return "Skill Increase"; } // 54 //EffectSkillIncrease
				if ( iEffectId == EFFECT_TYPE_SKILL_DECREASE ) { return "Skill Decrease"; } // 55 //EffectSkillDecrease
				if ( iEffectId == EFFECT_TYPE_INVISIBILITY ) { return "Invisibility"; } // 56 //EffectInvisibility
				if ( iEffectId == EFFECT_TYPE_GREATERINVISIBILITY ) { return "Greaterinvisibility"; } // 57 <- option on EffectInvisibility???
				if ( iEffectId == EFFECT_TYPE_DARKNESS ) { return "Darkness"; } // 58 //EffectDarkness
				if ( iEffectId == EFFECT_TYPE_DISPELMAGICALL ) { return "Dispel Magic All"; } // 59 //EffectDispelMagicAll
				break;
        case 6:
				if ( iEffectId == EFFECT_TYPE_ELEMENTALSHIELD ) { return "Elemental Shield"; } // 60  EffectDamageShield
				if ( iEffectId == EFFECT_TYPE_NEGATIVELEVEL ) { return "Negativelevel"; } // 61 //EffectNegativeLevel
				if ( iEffectId == EFFECT_TYPE_POLYMORPH ) { return "Polymorph"; } // 62 //EffectPolymorph
				if ( iEffectId == EFFECT_TYPE_SANCTUARY ) { return "Sanctuary"; } // 63 //EffectSanctuary
				if ( iEffectId == EFFECT_TYPE_TRUESEEING ) { return "Trueseeing"; } // 64 //EffectTrueSeeing
				if ( iEffectId == EFFECT_TYPE_SEEINVISIBLE ) { return "Seeinvisible"; } // 65 // EffectSeeInvisible
				if ( iEffectId == EFFECT_TYPE_TIMESTOP ) { return "Timestop"; } // 66 //EffectTimeStop
				if ( iEffectId == EFFECT_TYPE_BLINDNESS ) { return "Blindness"; } // 67 //EffectBlindness
				if ( iEffectId == EFFECT_TYPE_SPELLLEVELABSORPTION ) { return "Spell Level Absorption"; } // 68 //EffectSpellLevelAbsorption
				if ( iEffectId == EFFECT_TYPE_DISPELMAGICBEST ) { return "Dispelmagicbest"; } // 69 //EffectDispelMagicBest
				break;
		case 7:
				if ( iEffectId == EFFECT_TYPE_ULTRAVISION ) { return "Ultravision"; } // 70 //EffectUltravision
				if ( iEffectId == EFFECT_TYPE_MISS_CHANCE ) { return "Miss Chance"; } // 71 //EffectMissChance
				if ( iEffectId == EFFECT_TYPE_CONCEALMENT ) { return "Concealment"; } // 72 //EffectConcealment
				if ( iEffectId == EFFECT_TYPE_SPELL_IMMUNITY ) { return "Spell Immunity"; } // 73 //EffectSpellImmunity
				if ( iEffectId == EFFECT_TYPE_VISUALEFFECT ) { return "Visualeffect"; } // 74 //EffectVisualEffect
				if ( iEffectId == EFFECT_TYPE_DISAPPEARAPPEAR ) { return "Disappear Appear"; } // 75 //EffectDisappearAppear
				if ( iEffectId == EFFECT_TYPE_SWARM ) { return "Swarm"; } // 76 //EffectSwarm
				if ( iEffectId == EFFECT_TYPE_TURN_RESISTANCE_DECREASE ) { return "Turn Resistance Decrease"; } // 77 //EffectTurnResistanceDecrease
				if ( iEffectId == EFFECT_TYPE_TURN_RESISTANCE_INCREASE ) { return "Turn Resistance Increase"; } // 78 //EffectTurnResistanceIncrease
				if ( iEffectId == EFFECT_TYPE_PETRIFY ) { return "Petrify"; } // 79 //EffectPetrify
				break;
        case 8:
				if ( iEffectId == EFFECT_TYPE_CUTSCENE_PARALYZE ) { return "Cutscene Paralyze"; } // 80 //EffectCutsceneParalyze
				if ( iEffectId == EFFECT_TYPE_ETHEREAL ) { return "Ethereal"; } // 81 //EffectEthereal
				if ( iEffectId == EFFECT_TYPE_SPELL_FAILURE ) { return "Spell Failure"; } // 82 //EffectSpellFailure
				if ( iEffectId == EFFECT_TYPE_CUTSCENEGHOST ) { return "Cutscene Ghost"; } // 83 //EffectCutsceneGhost
				if ( iEffectId == EFFECT_TYPE_CUTSCENEIMMOBILIZE ) { return "Cutscene immobilize"; } // 84 //EffectCutsceneImmobilize
				if ( iEffectId == EFFECT_TYPE_BARDSONG_SINGING ) { return "Bardsong Singing"; } // 85 //EffectBardSongSinging
				if ( iEffectId == EFFECT_TYPE_HIDEOUS_BLOW ) { return "Hideous Blow"; } // 86 //EffectHideousBlow
				if ( iEffectId == EFFECT_TYPE_NWN2_DEX_ACMOD_DISABLE ) { return "Nwn2 Dex Acmod Disable"; } // 87  <-- there is no effect for this
				if ( iEffectId == EFFECT_TYPE_DETECTUNDEAD ) { return "Detect Undead"; } // 88 //EffectDetectUndead
				if ( iEffectId == EFFECT_TYPE_SHAREDDAMAGE ) { return "Shareddamage"; } // 89 //EffectShareDamage
				break;
		case 9:
				if ( iEffectId == EFFECT_TYPE_ASSAYRESISTANCE ) { return "Assay Resistance"; } // 90 //EffectAssayResistance
				if ( iEffectId == EFFECT_TYPE_DAMAGEOVERTIME ) { return "Damage Over Time"; } // 91 //EffectDamageOverTime
				if ( iEffectId == EFFECT_TYPE_ABSORBDAMAGE ) { return "Absorb Damage"; } // 92 //EffectAbsorbDamage
				if ( iEffectId == EFFECT_TYPE_AMORPENALTYINC ) { return "Amorpenaltyinc"; } // 93 //EffectArmorCheckPenaltyIncrease
				if ( iEffectId == EFFECT_TYPE_DISINTEGRATE ) { return "Disintegrate"; } // 94 //EffectDisintegrate
				if ( iEffectId == EFFECT_TYPE_HEAL_ON_ZERO_HP ) { return "Heal On Zero Hp"; } // 95 //EffectHealOnZeroHP
				if ( iEffectId == EFFECT_TYPE_BREAK_ENCHANTMENT ) { return "Break Enchantment"; } // 96 //EffectBreakEnchantment
				if ( iEffectId == EFFECT_TYPE_MESMERIZE ) { return "Mesmerize"; } // 97 //EffectMesmerize
				if ( iEffectId == EFFECT_TYPE_ON_DISPEL ) { return "On Dispel"; } // 98 //EffectOnDispel
				if ( iEffectId == EFFECT_TYPE_BONUS_HITPOINTS ) { return "Bonus Hitpoints"; } // 99 //EffectBonusHitpoints
				break;
        case 10:
				if ( iEffectId == EFFECT_TYPE_JARRING ) { return "Jarring"; } // 100 //EffectJarring
				if ( iEffectId == EFFECT_TYPE_MAX_DAMAGE ) { return "Max Damage"; } // 101 //EffectMaxDamage
				if ( iEffectId == EFFECT_TYPE_WOUNDING ) { return "Wounding"; } // 102 // <-- there is no effect for this
				if ( iEffectId == EFFECT_TYPE_WILDSHAPE ) { return "Wildshape"; } // 103 //EffectWildshape
				if ( iEffectId == EFFECT_TYPE_EFFECT_ICON ) { return "Effect Icon"; } // 104 //EffectEffectIcon
				if ( iEffectId == EFFECT_TYPE_RESCUE ) { return "Rescue"; } // 105 //EffectRescue
				if ( iEffectId == EFFECT_TYPE_DETECT_SPIRITS ) { return "Detect Spirits"; } // 106 //EffectDetectSpirits
				if ( iEffectId == EFFECT_TYPE_DAMAGE_REDUCTION_NEGATED ) { return "Damage Reduction Negated"; } // 107 //EffectDamageReductionNegated
				if ( iEffectId == EFFECT_TYPE_CONCEALMENT_NEGATED ) { return "Concealment Negated"; } // 108 //EffectConcealmentNegated
				if ( iEffectId == EFFECT_TYPE_INSANE ) { return "Insane"; } // 109 //EffectInsane
				break;
        case 11:
				if ( iEffectId == EFFECT_TYPE_HITPOINT_CHANGE_WHEN_DYING ) { return "Hitpoint Change When Dying"; } // 110 //EffectHitPointChangeWhenDying
				break;
		}
	return "Unknown";
	
	//these seem to be the effects that don't have a matching constant
	//EffectAppear
	//EffectBABMinimum <- ID 0
	//EffectCutsceneDominated <- ID 0
	//EffectDamage <-- would not have this because it does not persist
	//EffectDarkVision <- ID 0
	//EffectDeath <-- would not have this because it does not persist
	//EffectDisappear
	//EffectHeal <-- would not have this because it does not persist
	//EffectKnockdown<- ID 0
	//EffectLowLightVision<- ID 0
	//EffectModifyAttacks<- ID 0
	//EffectNWN2ParticleEffect <-- causes an error if you use it???
	//EffectNWN2ParticleEffectFile <- ????
	//EffectNWN2SpecialEffectFile <- ID 0
	//EffectSeeInvisible
	//EffectSeeTrueHPs
	//EffectSetScale
	//EffectSummonCopy
	//EffectSummonCreature


}


/**  
* Description
* @author
* @param int iEffectType
* @see 
* @return 
*/
int CSLGetEffectTypeBenefical( int iEffectType )
{	
	// returns -1 if not known
	// returns 0 if harmful
	// returns 1 if beneficial
	
	// thinking that i mainly am using it to look for buffs being present or not, so that if (CSLGetEffectTypeBenefical(iEffectType)) would work to find beneficial, and if (CSLGetEffectTypeBenefical(iEffectType)==1) would find harmfuls, and negated would find unknowns as well
	
	// add psionic if there is a need
	if ( iEffectType == EFFECT_TYPE_INVALIDEFFECT ) { return -1; } // 0
	if ( iEffectType == EFFECT_TYPE_DAMAGE_RESISTANCE ) { return 1; } // 1
	//if ( iEffectType == EFFECT_TYPE_ABILITY_BONUS ) { return "Ability Bonus"; } // 2
	if ( iEffectType == EFFECT_TYPE_REGENERATE ) { return 1; } // 3
	//if ( iEffectType == EFFECT_TYPE_SAVING_THROW_BONUS ) { return 1; } // 4
	//if ( iEffectType == EFFECT_TYPE_MODIFY_AC ) { return -1; } // 5
	//if ( iEffectType == EFFECT_TYPE_ATTACK_BONUS ) { return 1; } // 6
	if ( iEffectType == EFFECT_TYPE_DAMAGE_REDUCTION ) { return 1; } // 7
	//if ( iEffectType == EFFECT_TYPE_DAMAGE_BONUS ) { return 1; } // 8
	if ( iEffectType == EFFECT_TYPE_TEMPORARY_HITPOINTS ) { return 1; } // 9
	//if ( iEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY ) { return 1; } // 10
	if ( iEffectType == EFFECT_TYPE_ENTANGLE ) { return 0; } // 11
	if ( iEffectType == EFFECT_TYPE_INVULNERABLE ) { return 1; } // 12
	if ( iEffectType == EFFECT_TYPE_DEAF ) { return 0; } // 13
	if ( iEffectType == EFFECT_TYPE_RESURRECTION ) { return 1; } // 14
	if ( iEffectType == EFFECT_TYPE_IMMUNITY ) { return 1; } // 15
	//if ( iEffectType == EFFECT_TYPE_BLIND ) { return 0; } // 16
	if ( iEffectType == EFFECT_TYPE_ENEMY_ATTACK_BONUS ) { return 1; } // 17
	if ( iEffectType == EFFECT_TYPE_ARCANE_SPELL_FAILURE ) { return 0; } //18 
	//if ( iEffectType == EFFECT_TYPE_MOVEMENT_SPEED ) { return "Movement Speed"; } // 19
	if ( iEffectType == EFFECT_TYPE_AREA_OF_EFFECT ) { return -1; } // 20
	if ( iEffectType == EFFECT_TYPE_BEAM ) { return 0; } // 21
	//if ( iEffectType == EFFECT_TYPE_SPELL_RESISTANCE ) { return "Spell Resistance"; } // 22
	if ( iEffectType == EFFECT_TYPE_CHARMED ) { return 0; } // 23
	if ( iEffectType == EFFECT_TYPE_CONFUSED ) { return 0; } // 24
	if ( iEffectType == EFFECT_TYPE_FRIGHTENED ) { return 0; } // 25
	if ( iEffectType == EFFECT_TYPE_DOMINATED ) { return 0; } // 26
	if ( iEffectType == EFFECT_TYPE_PARALYZE ) { return 0; } // 27
	if ( iEffectType == EFFECT_TYPE_DAZED ) { return 0; } // 28
	if ( iEffectType == EFFECT_TYPE_STUNNED ) { return 0; } // 29
	if ( iEffectType == EFFECT_TYPE_SLEEP ) { return 0; } // 30
	if ( iEffectType == EFFECT_TYPE_POISON ) { return 0; } // 31
	if ( iEffectType == EFFECT_TYPE_DISEASE ) { return 0; } // 32
	if ( iEffectType == EFFECT_TYPE_CURSE ) { return 0; } // 33
	if ( iEffectType == EFFECT_TYPE_SILENCE ) { return 0; } // 34
	if ( iEffectType == EFFECT_TYPE_TURNED ) { return 0; } // 35
	if ( iEffectType == EFFECT_TYPE_HASTE ) { return 1; } // 36
	if ( iEffectType == EFFECT_TYPE_SLOW ) { return 0; } // 37
	if ( iEffectType == EFFECT_TYPE_ABILITY_INCREASE ) { return 1; } // 38
	if ( iEffectType == EFFECT_TYPE_ABILITY_DECREASE ) { return 0; } // 39
	if ( iEffectType == EFFECT_TYPE_ATTACK_INCREASE ) { return 1; } // 40
	if ( iEffectType == EFFECT_TYPE_ATTACK_DECREASE ) { return 0; } // 41
	if ( iEffectType == EFFECT_TYPE_DAMAGE_INCREASE ) { return 1; } // 42
	if ( iEffectType == EFFECT_TYPE_DAMAGE_DECREASE ) { return 0; } // 43
	if ( iEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ) { return 1; } // 44
	if ( iEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ) { return 1; } // 45
	if ( iEffectType == EFFECT_TYPE_AC_INCREASE ) { return 1; } // 46
	if ( iEffectType == EFFECT_TYPE_AC_DECREASE ) { return 0; } // 47
	if ( iEffectType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ) { return 1; } // 48
	if ( iEffectType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ) { return 0; } // 49
	if ( iEffectType == EFFECT_TYPE_SAVING_THROW_INCREASE ) { return 1; } // 50
	if ( iEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE ) { return 0; } // 51
	if ( iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ) { return 1; } // 52
	if ( iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ) { return 0; } // 53
	if ( iEffectType == EFFECT_TYPE_SKILL_INCREASE ) { return 1; } // 54
	if ( iEffectType == EFFECT_TYPE_SKILL_DECREASE ) { return 0; } // 55
	if ( iEffectType == EFFECT_TYPE_INVISIBILITY ) { return 1; } // 56
	if ( iEffectType == EFFECT_TYPE_GREATERINVISIBILITY ) { return 1; } // 57
	if ( iEffectType == EFFECT_TYPE_DARKNESS ) { return 0; } // 58
	if ( iEffectType == EFFECT_TYPE_DISPELMAGICALL ) { return -1; } // 59
	if ( iEffectType == EFFECT_TYPE_ELEMENTALSHIELD ) { return 1; } // 60
	if ( iEffectType == EFFECT_TYPE_NEGATIVELEVEL ) { return 0; } // 61
	if ( iEffectType == EFFECT_TYPE_POLYMORPH ) { return 1; } // 62
	if ( iEffectType == EFFECT_TYPE_SANCTUARY ) { return 1; } // 63
	if ( iEffectType == EFFECT_TYPE_TRUESEEING ) { return 1; } // 64
	if ( iEffectType == EFFECT_TYPE_SEEINVISIBLE ) { return 1; } // 65
	if ( iEffectType == EFFECT_TYPE_TIMESTOP ) { return -1; } // 66
	if ( iEffectType == EFFECT_TYPE_BLINDNESS ) { return 0; } // 67
	if ( iEffectType == EFFECT_TYPE_SPELLLEVELABSORPTION ) { return 1; } // 68
	if ( iEffectType == EFFECT_TYPE_DISPELMAGICBEST ) { return -1; } // 69
	if ( iEffectType == EFFECT_TYPE_ULTRAVISION ) { return 1; } // 70
	if ( iEffectType == EFFECT_TYPE_MISS_CHANCE ) { return 0; } // 71
	if ( iEffectType == EFFECT_TYPE_CONCEALMENT ) { return 1; } // 72
	if ( iEffectType == EFFECT_TYPE_SPELL_IMMUNITY ) { return 1; } // 73
	if ( iEffectType == EFFECT_TYPE_VISUALEFFECT ) { return -1; } // 74
	if ( iEffectType == EFFECT_TYPE_DISAPPEARAPPEAR ) { return -1; } // 75
	if ( iEffectType == EFFECT_TYPE_SWARM ) { return 1; } // 76
	if ( iEffectType == EFFECT_TYPE_TURN_RESISTANCE_DECREASE ) { return 0; } // 77
	if ( iEffectType == EFFECT_TYPE_TURN_RESISTANCE_INCREASE ) { return 1; } // 78
	if ( iEffectType == EFFECT_TYPE_PETRIFY ) { return 0; } // 79
	if ( iEffectType == EFFECT_TYPE_CUTSCENE_PARALYZE ) { return 0; } // 80
	if ( iEffectType == EFFECT_TYPE_ETHEREAL ) { return 1; } // 81
	if ( iEffectType == EFFECT_TYPE_SPELL_FAILURE ) { return 0; } // 82
	if ( iEffectType == EFFECT_TYPE_CUTSCENEGHOST ) { return 1; } // 83
	if ( iEffectType == EFFECT_TYPE_CUTSCENEIMMOBILIZE ) { return 0; } // 84
	if ( iEffectType == EFFECT_TYPE_BARDSONG_SINGING ) { return 1; } // 85
	if ( iEffectType == EFFECT_TYPE_HIDEOUS_BLOW ) { return 1; } // 86
	if ( iEffectType == EFFECT_TYPE_NWN2_DEX_ACMOD_DISABLE ) { return -1; } // 87
	if ( iEffectType == EFFECT_TYPE_DETECTUNDEAD ) { return 1; } // 88
	if ( iEffectType == EFFECT_TYPE_SHAREDDAMAGE ) { return 1; } // 89
	if ( iEffectType == EFFECT_TYPE_ASSAYRESISTANCE ) { return -1; } // 90
	if ( iEffectType == EFFECT_TYPE_DAMAGEOVERTIME ) { return 0; } // 91
	if ( iEffectType == EFFECT_TYPE_ABSORBDAMAGE ) { return 1; } // 92
	if ( iEffectType == EFFECT_TYPE_AMORPENALTYINC ) { return 0; } // 93
	if ( iEffectType == EFFECT_TYPE_DISINTEGRATE ) { return 0; } // 94
	if ( iEffectType == EFFECT_TYPE_HEAL_ON_ZERO_HP ) { return 1; } // 95
	if ( iEffectType == EFFECT_TYPE_BREAK_ENCHANTMENT ) { return -1; } // 96
	if ( iEffectType == EFFECT_TYPE_MESMERIZE ) { return -1; } // 97
	if ( iEffectType == EFFECT_TYPE_ON_DISPEL ) { return -1; } // 98
	if ( iEffectType == EFFECT_TYPE_BONUS_HITPOINTS ) { return 1; } // 99
	if ( iEffectType == EFFECT_TYPE_JARRING ) { return 0; } // 100
	if ( iEffectType == EFFECT_TYPE_MAX_DAMAGE ) { return 1; } // 101
	if ( iEffectType == EFFECT_TYPE_WOUNDING ) { return -1; } // 102
	if ( iEffectType == EFFECT_TYPE_WILDSHAPE ) { return 1; } // 103
	if ( iEffectType == EFFECT_TYPE_EFFECT_ICON ) { return -1; } // 104
	if ( iEffectType == EFFECT_TYPE_RESCUE ) { return 1; } // 105
	if ( iEffectType == EFFECT_TYPE_DETECT_SPIRITS ) { return 1; } // 106
	if ( iEffectType == EFFECT_TYPE_DAMAGE_REDUCTION_NEGATED ) { return 0; } // 107
	if ( iEffectType == EFFECT_TYPE_CONCEALMENT_NEGATED ) { return 0; } // 108
	if ( iEffectType == EFFECT_TYPE_INSANE ) { return 0; } // 109
	if ( iEffectType == EFFECT_TYPE_HITPOINT_CHANGE_WHEN_DYING ) { return 1; } // 110 	
	return -1;

}


 // for effect i don't know how to classify

/**  
* LESSER RESTORATION -> CSLRestore( oTarget, NEGEFFECT_TEMPORARYABILITY|NEGEFFECT_COMBAT );
* lesser Lesser restoration dispels any magical effects reducing one of the
* subject�s ability scores or cures 1d4 points of temporary ability damage to one
* of the subject�s ability scores. It also eliminates any fatigue suffered by the
* character, and improves an exhausted condition to fatigued. It does not restore
* permanent ability drain.				
*
* GREATER RESTORATION -> CSLRestore( oTarget, NEGEFFECT_ABILITY|NEGEFFECT_COMBAT|NEGEFFECT_MENTAL|NEGEFFECT_LEVEL|NEGEFFECT_PERCEPTION );
* This spell functions like lesser restoration, except that it dispels all
* negative levels afflicting the healed creature. This effect also reverses level
* drains by a force or creature, restoring the creature to the highest level it
* had previously attained. The drained levels are restored only if the time since
* the creature lost the level is no more than one week per caster level.
* Greater restoration also dispels all magical effects penalizing the creature�s
* abilities, cures all temporary ability damage, and restores all points
* permanently drained from all ability scores. It also eliminates fatigue and
* exhaustion, and removes all forms of insanity, confusion, and similar mental
* effects. Greater restoration does not restore levels or Constitution points lost
* due to death.
*
* FREEDOM OF MOVEMENT -> CSLRestore( oTarget, NEGEFFECT_MOVEMENT|NEGEFFECT_PETRIFY|NEGEFFECT_SLOWED );
*
* ga_restoration  -> CSLRestore( oTarget, NEGEFFECT_CURSE|NEGEFFECT_COMBAT|NEGEFFECT_ABILITY|NEGEFFECT_DISEASE|NEGEFFECT_POISON|NEGEFFECT_SLOWED|NEGEFFECT_MENTAL|NEGEFFECT_PERCEPTION|NEGEFFECT_LEVEL );
*
* @author
* @param 
* @see 
* @return 
*/
int CSLRestore( object oTarget, int iFilter = NEGEFFECT_NONE )
{
	if ( iFilter == NEGEFFECT_NONE )
	{
		return FALSE;
	} 
	
	int bResult = FALSE;
	
	int iEffectType;
	int iSpellId;
	effect eBad = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eBad)) 
	{
		iEffectType = GetEffectType(eBad);
		iSpellId = GetEffectSpellId(eBad);
		
		if // this is pretty complex, it first does effects, and inside each does a bitwise check for the relevant NEGEFFECT_* constant
		(
			(
				// MENTAL
				( iEffectType == EFFECT_TYPE_DAZED && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_STUNNED && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_SLEEP && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_MESMERIZE && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_JARRING && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_INSANE && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_CHARMED && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_CONFUSED && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_FRIGHTENED && iFilter & NEGEFFECT_MENTAL ) ||
				( iEffectType == EFFECT_TYPE_DOMINATED && iFilter & NEGEFFECT_MENTAL && !GetLocalInt( oTarget, "SCSummon" )  ) ||
				( iEffectType == EFFECT_TYPE_PARALYZE && iFilter & NEGEFFECT_MENTAL|NEGEFFECT_MOVEMENT ) ||
				//MOVEMENT
				( iEffectType == EFFECT_TYPE_ENTANGLE && iFilter & NEGEFFECT_MOVEMENT ) ||
				( iEffectType == EFFECT_TYPE_SLOW && iFilter & NEGEFFECT_MOVEMENT ) ||
				( iEffectType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE && iFilter & NEGEFFECT_MOVEMENT ) ||
				( iEffectType == EFFECT_TYPE_PETRIFY && iFilter & NEGEFFECT_PETRIFY ) ||
				//ABILITY
				( iEffectType == EFFECT_TYPE_ABILITY_DECREASE && iFilter & NEGEFFECT_ABILITY ) ||
				( iEffectType == EFFECT_TYPE_ABILITY_DECREASE && iFilter & NEGEFFECT_TEMPORARYABILITY && GetEffectDurationType(eBad) == DURATION_TYPE_TEMPORARY ) ||
				( iEffectType == EFFECT_TYPE_NEGATIVELEVEL && iFilter & NEGEFFECT_LEVEL ) ||
				// COMBAT
				( iEffectType == EFFECT_TYPE_ATTACK_DECREASE && iFilter & NEGEFFECT_COMBAT ) ||
				( iEffectType == EFFECT_TYPE_DAMAGE_DECREASE && iFilter & NEGEFFECT_COMBAT ) ||
				( iEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE && iFilter & NEGEFFECT_COMBAT ) ||
				( iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE && iFilter & NEGEFFECT_COMBAT ) ||
				( iEffectType == EFFECT_TYPE_AC_DECREASE && iFilter & NEGEFFECT_COMBAT ) ||
				( iEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE && iFilter & NEGEFFECT_COMBAT ) ||
				( iEffectType == EFFECT_TYPE_SKILL_DECREASE && iFilter & NEGEFFECT_COMBAT ) ||
				// PERCEPTION
				( iEffectType == EFFECT_TYPE_BLINDNESS && iFilter & NEGEFFECT_PERCEPTION ) ||
				( iEffectType == EFFECT_TYPE_DEAF && iFilter & NEGEFFECT_PERCEPTION ) ||
				//OTHERS
				( iEffectType == EFFECT_TYPE_POISON && iFilter & NEGEFFECT_POISON ) ||
				( iEffectType == EFFECT_TYPE_DISEASE && iFilter & NEGEFFECT_DISEASE ) ||
				( iEffectType == EFFECT_TYPE_CURSE && iFilter & NEGEFFECT_CURSE ) ||
				( GetTag(GetEffectCreator(eBad)) == "q6e_ShaorisFellTemple" && iFilter & NEGEFFECT_TEMPORARYABILITY ) // this supports something in the Official modules
			) 
			&& // if it's a negative effect, make sure it's not one of the following spells
			(
					iSpellId != SPELL_ENLARGE_PERSON &&
					iSpellId != SPELL_RIGHTEOUS_MIGHT &&
					iSpellId != SPELL_STONE_BODY &&
					iSpellId != SPELL_LIGHT &&
					iSpellId != -SPELL_LIGHT &&
					iSpellId != SPELL_NONMAGICLIGHT &&
					iSpellId != SPELL_DAYLIGHT_CLERIC &&
					iSpellId != SPELL_DAYLIGHT &&
					iSpellId != SPELL_IRON_BODY &&
					iSpellId != SPELL_REDUCE_PERSON &&
					iSpellId != SPELL_REDUCE_ANIMAL &&
					iSpellId != SPELL_REDUCE_PERSON_GREATER &&
					iSpellId != SPELL_REDUCE_PERSON_MASS &&
					iSpellId != FOREST_MASTER_OAK_HEART &&
					iSpellId != SPELLABILITY_GRAY_ENLARGE && 
					iSpellId != SPELL_TORTOISE_SHELL &&
					iSpellId != SPELL_FOUNDATION_OF_STONE &&
					iSpellId != SPELL_BLADE_BARRIER_SELF
			)
		)
		{
			//Remove effect if it is negative.
			RemoveEffect(oTarget, eBad);
			eBad = GetFirstEffect(oTarget);
			bResult = TRUE;
		}
		else
		{
			eBad = GetNextEffect(oTarget);
		}
	}	
	return bResult;
	/*
	
	Notes: 
	
	// these i am ignoring for now
	//( iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_MISS_CHANCE && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_TURN_RESISTANCE_DECREASE && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_DARKNESS && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_ARCANE_SPELL_FAILURE && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_SILENCE && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_TURNED && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_CUTSCENE_PARALYZE && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_SPELL_FAILURE && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_CUTSCENEIMMOBILIZE && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_DAMAGEOVERTIME && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_AMORPENALTYINC && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_WOUNDING && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_DAMAGE_REDUCTION_NEGATED && iFilter & NEGEFFECT_OTHER ) ||
	//( iEffectType == EFFECT_TYPE_CONCEALMENT_NEGATED && iFilter & NEGEFFECT_OTHER ) ||
	
	
	// these are NEGEFFECT_COMBAT
	EFFECT_TYPE_ATTACK_DECREASE
	EFFECT_TYPE_DAMAGE_DECREASE
	EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE
	EFFECT_TYPE_SPELL_RESISTANCE_DECREASE
	EFFECT_TYPE_AC_DECREASE
	EFFECT_TYPE_SAVING_THROW_DECREASE
	EFFECT_TYPE_SKILL_DECREASE
	
	// these are NEGEFFECT_MENTAL
	EFFECT_TYPE_DAZED
	EFFECT_TYPE_STUNNED
	EFFECT_TYPE_MESMERIZE
	EFFECT_TYPE_JARRING
	EFFECT_TYPE_INSANE
	EFFECT_TYPE_CHARMED
	EFFECT_TYPE_CONFUSED
	EFFECT_TYPE_FRIGHTENED
	EFFECT_TYPE_DOMINATED
	EFFECT_TYPE_PARALYZE
	
	// these are NEGEFFECT_SLEEP
	EFFECT_TYPE_SLEEP
	
	// these are NEGEFFECT_MOVEMENT
	EFFECT_TYPE_PARALYZE
	EFFECT_TYPE_ENTANGLE
	EFFECT_TYPE_SLOW
	EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
	
	// these are NEGEFFECT_PETRIFY
	EFFECT_TYPE_PETRIFY
	
	// these are NEGEFFECT_ABILITY or NEGEFFECT_TEMPORARYABILITY
	EFFECT_TYPE_ABILITY_DECREASE
	
	// these are NEGEFFECT_LEVEL
	EFFECT_TYPE_NEGATIVELEVEL
	
	// these are NEGEFFECT_PERCEPTION
	EFFECT_TYPE_BLINDNESS
	EFFECT_TYPE_DEAF
	
	// these are NEGEFFECT_SLOWED
	EFFECT_TYPE_SLOW
	
	// these are NEGEFFECT_POISON
	EFFECT_TYPE_POISON
	
	// these are NEGEFFECT_DISEASE
	EFFECT_TYPE_DISEASE
	
	// these are NEGEFFECT_CURSE
	EFFECT_TYPE_CURSE
	
	*/
}	


/** 
* Used to ensure a pseudo heartbeat is not repeating, first time effect it is run use -1 as the starting integer
* if a new beat takes over the serials will not match and this will return false
* This allows a new heartbeat to take over when needed.
* @param oControlObject, usually the player but generally what the effect is applied to
* @param sVariableName Unique name which allows multiple serials to run at once
* @param iSerial The current serial number being passed in the heartbeat function to itself
* @see CSLSerialGetCurrentValue 
* @return False means it is a duplicate heartbeat, true means its the main heartbeat
*/

int CSLSerialRepeatCheck( object oControlObject, string sVariableName, int iSerial = -1 )
{
	if ( iSerial == -1 )
	{
		SetLocalInt(oControlObject, "SERIAL_"+sVariableName, CSLGetRandomSerialNumber() );
		
		return TRUE;
	}
	else
	{
		int iCheckSerial = GetLocalInt(oControlObject, "SERIAL_"+sVariableName );
		if ( iCheckSerial != iSerial )
		{
			// duplicate older effect is still in effect
			return FALSE;
		}
	}
	return TRUE;
}

/** 
* Gets the new heartbeat serial number which is in effect
* @param oControlObject, usually the player but generally what the effect is applied to
* @param sVariableName Unique name which allows multiple serials to run at once
* @see CSLSerialRepeatCheck
* @return The current heartbeat which is on the player
*/
int CSLSerialGetCurrentValue( object oControlObject, string sVariableName )
{
	return GetLocalInt(oControlObject, "SERIAL_"+sVariableName );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Removes the effects marked with given nMarker.  Note that effects
// that can't be seen in GetFirst/NextEffect can't be removed with this.
// oTarget - creatuer with the effect(s)
// nMarker - the same value used when applying the effect with ApplyMarkedEffect
//
void CSLRemoveMarkedEffects(object oTarget, int nMarker)
{
    effect eLook = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eLook)) {
        if (GetEffectSpellId(eLook) == nMarker) {
            RemoveEffect(oTarget, eLook);
            eLook = GetFirstEffect(oTarget);    // start over to make sure linked effects are removed.
        } else {
            eLook = GetNextEffect(oTarget);
        }
    }

}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Applies an effect which can be removed with RemoveMarkedEffect
//  nDurationType - appropriate DURATION_TYPE_* constant
//  oTarget - person to apply the effect to
//        e - the effect
//   marker - a unique identifier that will be used to recognize this same
//            effect later.  Generally use a number greater than 10000 to make
//            sure this doesn't conflict with existing internal spell IDs
// fDuration - for DURATION_TYPE_TEMPORARY, specifies effect duration in seconds; otherwise ignored.
// bExtraordinary - create this as an extraordinary effect which can be removed only by resting
// bSupernatural - create this as asa supernatural effect which can only be removed explicitly through RemoveMarkedEffect
//                 this supercedes 'extraordinary'
void CSLApplyMarkedEffect(int nDurationType, effect e, object oTarget, int nMarker, float fDuration = 0.0, int bExtraordinary = FALSE, int bSupernatural = FALSE)
{
    if (bSupernatural) {
        e = SupernaturalEffect(e);
    } else if (bExtraordinary) {
        e = ExtraordinaryEffect(e);
    }
    ApplyEffectToObject(nDurationType, SetEffectSpellId(e, nMarker), oTarget, fDuration);
}



 
/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetHasEffectSpellIdGroup( object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1)
{
	if ( ( iSpellId0 != -1 && GetHasSpellEffect(iSpellId0, oTarget) ) || ( iSpellId1 != -1 && GetHasSpellEffect(iSpellId1, oTarget) ) || ( iSpellId2 != -1 && GetHasSpellEffect(iSpellId2, oTarget) ) || ( iSpellId3 != -1 && GetHasSpellEffect(iSpellId3, oTarget) ) || ( iSpellId4 != -1 && GetHasSpellEffect(iSpellId4, oTarget) ) || ( iSpellId5 != -1 && GetHasSpellEffect(iSpellId5, oTarget) ) || ( iSpellId6 != -1 && GetHasSpellEffect(iSpellId6, oTarget) ) || ( iSpellId7 != -1 && GetHasSpellEffect(iSpellId7, oTarget) ) || ( iSpellId8 != -1 && GetHasSpellEffect(iSpellId8, oTarget) ) || ( iSpellId9 != -1 && GetHasSpellEffect(iSpellId9, oTarget) ) )
	{
	if (DEBUGGING >= 8) { CSLDebug(  "CSLGetHasEffectSpellIdGroup:  Is", oTarget ); }
		return TRUE;
	}
	if (DEBUGGING >= 8) { CSLDebug(  "CSLGetHasEffectSpellIdGroup:  Not", oTarget ); }
	return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This checks if an object is one of up to 9 different SpellId's
int CSLGetAreaOfEffectSpellIdGroup( object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1)
{
	if ( ( iSpellId0 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId0 ) || ( iSpellId1 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId1 ) || ( iSpellId2 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId2 ) || ( iSpellId3 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId3 ) || ( iSpellId4 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId4 ) || ( iSpellId5 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId5 ) || ( iSpellId6 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId6 ) || ( iSpellId7 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId7 ) || ( iSpellId8 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId8 ) || ( iSpellId9 != -1 && GetAreaOfEffectSpellId( oTarget )==iSpellId9 ) )
	{
	if (DEBUGGING >= 8) { CSLDebug(  "CSLGetHasEffectSpellIdGroup:  Is", oTarget ); }
		return TRUE;
	}
	if (DEBUGGING >= 8) { CSLDebug(  "CSLGetHasEffectSpellIdGroup:  Not", oTarget ); }
	return FALSE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLIsEffectSpellIdGroup( effect eEffect, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1)
{
	if (  ( iSpellId0 != -1 && GetEffectSpellId( eEffect ) == iSpellId0 )  || ( iSpellId1 != -1 && GetEffectSpellId( eEffect ) == iSpellId1 )  || ( iSpellId2 != -1 && GetEffectSpellId( eEffect ) == iSpellId2 )  || ( iSpellId3 != -1 && GetEffectSpellId( eEffect ) == iSpellId3 )  || ( iSpellId4 != -1 && GetEffectSpellId( eEffect ) == iSpellId4 )  || ( iSpellId5 != -1 && GetEffectSpellId( eEffect ) == iSpellId5 )  || ( iSpellId6 != -1 && GetEffectSpellId( eEffect ) == iSpellId6 ) || ( iSpellId7 != -1 && GetEffectSpellId( eEffect ) == iSpellId7 )  || ( iSpellId8 != -1 && GetEffectSpellId( eEffect ) == iSpellId8 ) || ( iSpellId9 != -1 && GetEffectSpellId( eEffect ) == iSpellId9  ) )
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
int CSLRemoveEffectSpellIdGroup( int RemoveMethod, object oCreator, object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1 )
{
	// Removes a group of up to 10 effects
	if (DEBUGGING >= 8) { CSLDebug(  "CSLRemoveEffectSpellIdGroup:  Removing "+IntToString( iSpellId0 ), oCreator, oTarget ); }

	int iCasterOnly = FALSE;
	int iFirstOnly = FALSE;
	int iRemovedEffect = FALSE;
	
	if ( RemoveMethod == SC_REMOVE_FIRSTONLYCREATOR  || RemoveMethod == SC_REMOVE_ONLYCREATOR )
	{
		iCasterOnly = TRUE;
	}
	
	if ( RemoveMethod == SC_REMOVE_FIRSTONLYCREATOR  || RemoveMethod == SC_REMOVE_FIRSTALLCREATORS )
	{
		iFirstOnly = TRUE;
	}
	
	effect eEffect;
	if ( CSLGetHasEffectSpellIdGroup( oTarget, iSpellId0, iSpellId1, iSpellId2, iSpellId3, iSpellId4, iSpellId5, iSpellId6, iSpellId7, iSpellId8, iSpellId9 ) )
	{
		eEffect = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eEffect))
		{
			if ( iCasterOnly == FALSE || GetEffectCreator(eEffect) == oCreator || !GetIsObjectValid( GetEffectCreator(eEffect) ) )
			{
				//If the effect was created by the spell then remove it
				if( CSLIsEffectSpellIdGroup(eEffect, iSpellId0, iSpellId1, iSpellId2, iSpellId3, iSpellId4, iSpellId5, iSpellId6, iSpellId7, iSpellId8, iSpellId9   ) )
				{
					RemoveEffect(oTarget, eEffect);
					if (DEBUGGING >= 8) { CSLDebug( "CSLRemoveEffectSpellIdGroup: Removed Effect", oTarget ); }
					iRemovedEffect = TRUE;
					if ( iFirstOnly == TRUE )
					{
						if (DEBUGGING >= 8) { CSLDebug( "CSLRemoveEffectSpellIdGroup: First Only", oTarget ); }
						return iRemovedEffect;
					}
					eEffect = GetFirstEffect(oTarget);
				}
				else
				{
					eEffect = GetNextEffect(oTarget);
				}
			}
			else
			{
				eEffect = GetNextEffect(oTarget);
			}
		}
	}
	return iRemovedEffect;
	// return TRUE if an effect was removed
}


/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLRemoveEffectSpellIdGroup_Void( int RemoveMethod, object oCreator, object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1 )
{
	CSLRemoveEffectSpellIdGroup( RemoveMethod, oCreator, oTarget, iSpellId0, iSpellId1, iSpellId2, iSpellId3, iSpellId4, iSpellId5, iSpellId6, iSpellId7, iSpellId8, iSpellId9 );
}





/**  
Removes a single spell effect id
* @author
* @param iRemoveMethod = SC_REMOVE_FIRSTONLYCREATOR = 1, SC_REMOVE_ONLYCREATOR = 2, SC_REMOVE_FIRSTALLCREATORS = 3, SC_REMOVE_ALLCREATORS =4
* @param oCreator Caster who is removing the effect
* @param oTarget Target to remove effect from
* @param iSpellId The spell id to remove
* @param iEffectTypeID further filter by effect type
* @param nEffectSubType further filter by effect subtype
* @see 
* @return 
*/
// * Removes an SpellId from an object
// iRemoveMethod 
int CSLRemoveEffectSpellIdSingle(int iRemoveMethod, object oCreator, object oTarget, int iSpellId, int iEffectTypeID = -1, int nEffectSubType = -1 )
{
	//if (DEBUGGING >= 8) { CSLDebug( "Going to Remove Effect " + CSLGetSpellDataName(iSpellId) + " " +IntToString( iSpellId ), oCreator, oTarget); }
	
	int iCasterOnly = FALSE;
	int iFirstOnly = FALSE;
	int iRemovedEffect = FALSE;
	
	if ( iRemoveMethod == SC_REMOVE_FIRSTONLYCREATOR  || iRemoveMethod == SC_REMOVE_ONLYCREATOR )
	{
		iCasterOnly = TRUE;
	}
	
	if ( iRemoveMethod == SC_REMOVE_FIRSTONLYCREATOR  || iRemoveMethod == SC_REMOVE_FIRSTALLCREATORS )
	{
		iFirstOnly = TRUE;
	}

	//Declare major variables
	//Get the object that is exiting the AOE
	
	//Search through the valid effects on the target.
	
	if( GetHasSpellEffect( iSpellId, oTarget ) )
	{
		effect eEffect;
		eEffect = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eEffect))
		{
			if ( iCasterOnly == FALSE || GetEffectCreator(eEffect) == oCreator || !GetIsObjectValid( GetEffectCreator(eEffect) ) )
			{
				if ( iSpellId == -1 || GetEffectSpellId(eEffect) == iSpellId )
				{
					if ( iEffectTypeID == -1 || GetEffectType(eEffect) == iEffectTypeID )
					{
						if (nEffectSubType == -1 || GetEffectSubType(eEffect) == nEffectSubType)
						{
							//If the effect was created by the spell then remove it
							RemoveEffect(oTarget, eEffect);
							//if (DEBUGGING >= 8) { CSLDebug( "Removed Effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
							iRemovedEffect = TRUE;
							if ( iFirstOnly == TRUE )
							{
								return iRemovedEffect;
							}
							eEffect = GetFirstEffect(oTarget);  // 8/28/06 - BDF-OEI: start back at the beginning to ensure that linked effects are removed safely
						}
						else
						{
							//if (DEBUGGING >= 8) { CSLDebug( "Ignoring Effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
							//Get next effect on the target
							eEffect = GetNextEffect(oTarget);
						}
				
					}
					else
					{
						//if (DEBUGGING >= 8) { CSLDebug( "Ignoring Effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
						//Get next effect on the target
						eEffect = GetNextEffect(oTarget);
					}				
				
				}
				else
				{
					//if (DEBUGGING >= 8) { CSLDebug( "Ignoring Effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
					//Get next effect on the target
					eEffect = GetNextEffect(oTarget);
				}
			}
			else
			{
				//if (DEBUGGING >= 8) { CSLDebug( "Effect "+CSLGetSpellDataName(iSpellId)+" Is Not By Creator!", oCreator, oTarget); }
				//Get next effect on the target
				eEffect = GetNextEffect(oTarget);
			}
		}
	}
	//else
	//{
	// if (DEBUGGING >= 8) { CSLDebug( "Does not have effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
	//}
	return iRemovedEffect;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// this checks if a given spell is active on a player, uses actual iterator to force a check
int CSLHasSpellIdGroup( object oTarget, int iSpellId0 = -1, int iSpellId1 = -1, int iSpellId2 = -1, int iSpellId3 = -1, int iSpellId4 = -1, int iSpellId5 = -1, int iSpellId6 = -1, int iSpellId7 = -1, int iSpellId8 = -1, int iSpellId9 = -1 )
{
	// Removes a group of up to 10 effects
	//if (DEBUGGING >= 8) { CSLDebug(  "CSLHasSpellIdGroup:  checking "+IntToString( iSpellId0 ), oCreator, oTarget ); }


	
	effect eEffect;
	eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		//If the effect was created by the spell then remove it
		if( CSLIsEffectSpellIdGroup(eEffect, iSpellId0, iSpellId1, iSpellId2, iSpellId3, iSpellId4, iSpellId5, iSpellId6, iSpellId7, iSpellId8, iSpellId9   ) )
		{
			return TRUE;
		}
		else
		{
			eEffect = GetNextEffect(oTarget);
		}
	}
	return FALSE;
	// return TRUE if an effect was removed
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * Acts as a wrapper for CSLRemoveEffectSpellIdSingle, which makes it usable in delayed actions
void CSLRemoveEffectSpellIdSingle_Void(int RemoveMethod, object oCreator, object oTarget, int iSpellId )
{
	//if (DEBUGGING >= 5) { CSLDebug( "I Am Removing Effects " + CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
	CSLRemoveEffectSpellIdSingle( RemoveMethod, oCreator, oTarget, iSpellId );
}


/**  
* Removes an effect from an object
* @author
* @param iRemoveMethod = SC_REMOVE_FIRSTONLYCREATOR = 1, SC_REMOVE_ONLYCREATOR = 2, SC_REMOVE_FIRSTALLCREATORS = 3, SC_REMOVE_ALLCREATORS =4
* @param oCreator
* @param oTarget
* @param iEffectTypeID
* @param nEffectSubType
* @see 
* @return 
*/
// 
// 
int CSLRemoveEffectTypeSingle(int iRemoveMethod, object oCreator, object oTarget, int iEffectTypeID, int nEffectSubType=-1 )
{
	// Removes a group of up to 10 effects
	int iCasterOnly = FALSE;
	int iFirstOnly = FALSE;
	int iRemovedEffect = FALSE;
	
	if ( iRemoveMethod == SC_REMOVE_FIRSTONLYCREATOR  || iRemoveMethod == SC_REMOVE_ONLYCREATOR )
	{
		iCasterOnly = TRUE;
	}
	
	if ( iRemoveMethod == SC_REMOVE_FIRSTONLYCREATOR  || iRemoveMethod == SC_REMOVE_FIRSTALLCREATORS )
	{
		iFirstOnly = TRUE;
	}

	//Declare major variables
	//Get the object that is exiting the AOE
	
	//Search through the valid effects on the target.
	
	//if( GetHasSpellEffect( iEffectTypeID, oTarget ) )
	//{
		effect eEffect;
		eEffect = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eEffect))
		{
			if ( iCasterOnly == FALSE || GetEffectCreator(eEffect) == oCreator || !GetIsObjectValid( GetEffectCreator(eEffect) ) )
			{
				if (GetEffectType(eEffect) == iEffectTypeID )
				{
					if (nEffectSubType==-1 || GetEffectSubType(eEffect)==nEffectSubType)
					{	//If the effect was created by the spell then remove it
						RemoveEffect(oTarget, eEffect);
						//if ( DEBUGGING >= 8) { CSLDebug( "Removed Effect "+CSLGetSpellDataName( iEffectTypeID ), oCreator, oTarget); }
						iRemovedEffect = TRUE;
						if ( iFirstOnly == TRUE )
						{
							return iRemovedEffect;
						}
						eEffect = GetFirstEffect(oTarget);  // 8/28/06 - BDF-OEI: start back at the beginning to ensure that linked effects are removed safely
					}
					else
					{
						//Get next effect on the target
						eEffect = GetNextEffect(oTarget);
					}
				}
				else
				{
					//Get next effect on the target
					eEffect = GetNextEffect(oTarget);
				}
			}
			else
			{
				//Get next effect on the target
				eEffect = GetNextEffect(oTarget);
			}
		}
	//}
	return iRemovedEffect;
}



/**  
* @author
* @param 
* @see 
* @return 
* @replaces RemoveEffectsByType 
*/
int CSLRemoveEffectByType(object oPC, int nEffectType, int nEffectSubType=-1, object oCreator=OBJECT_INVALID)
{
	int bRemove = FALSE;
	effect eSearch = GetFirstEffect(oPC);
	while (GetIsEffectValid(eSearch))
	{
		int bRestart = FALSE;
		//Check to see if the effect matches a particular type defined below
		if (GetEffectType(eSearch)==nEffectType)
		{
			if (nEffectSubType==-1 || GetEffectSubType(eSearch)==nEffectSubType)
			{
				if (oCreator==OBJECT_INVALID)
				{
					RemoveEffect(oPC, eSearch);
					bRemove = TRUE;
					bRestart = TRUE;
				}
				else
				{
					if (GetEffectCreator(eSearch)==oCreator)
					{
						RemoveEffect(oPC, eSearch);
						bRemove = TRUE;
						bRestart = TRUE;
					}
				}
			}
		}
		if (bRestart)
		{
			eSearch = GetFirstEffect(oPC);
		}
		else
		{
			eSearch = GetNextEffect(oPC);
		}
	}
	return bRemove;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLRemoveEffectByType_Void(object oPC, int nEffectType, int nEffectSubType=-1, object oCreator=OBJECT_INVALID)
{
	CSLRemoveEffectByType(oPC, nEffectType, nEffectSubType, oCreator);
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// * Removes an SpellId from an object
// RemoveMethod = SC_REMOVE_FIRSTONLYCREATOR = 1, SC_REMOVE_ONLYCREATOR = 2, SC_REMOVE_FIRSTALLCREATORS = 3, SC_REMOVE_ALLCREATORS =4
void CSLTransferEffectSpellIdSingle_Void(int RemoveMethod, object oCreator, object oTarget, object oReceiver, int iSpellId, int iEffectTypeID = -1, int nEffectSubType = -1 )
{
	//if (DEBUGGING >= 5) { CSLDebug( "I Am Transfering Effects " + CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
	
	
	//SendMessageToPC( GetFirstPC(), "I Am Transfering Effects " + CSLGetSpellDataName(iSpellId) + " On " +GetName(oTarget) );
	
	//SendMessageToPC( GetFirstPC(), "Spell was cast by " +GetName(oCreator)+" and being transfered to "+GetName(oReceiver) );
	//	
	int iCasterOnly = FALSE;
	int iFirstOnly = FALSE;
	int iRemovedEffect = FALSE;
	effect eTransferEffects;
	effect eTempEffect;
	if ( RemoveMethod == SC_REMOVE_FIRSTONLYCREATOR  || RemoveMethod == SC_REMOVE_ONLYCREATOR )
	{
		iCasterOnly = TRUE;
	}
	
	if ( RemoveMethod == SC_REMOVE_FIRSTONLYCREATOR  || RemoveMethod == SC_REMOVE_FIRSTALLCREATORS )
	{
		iFirstOnly = TRUE;
	}
	int bTempHps = FALSE;
	//Declare major variables
	//Get the object that is exiting the AOE
	
	//Search through the valid effects on the target.
	
	if( GetHasSpellEffect( iSpellId, oTarget ) )
	{
		effect eEffect;
		int bExit = FALSE;
		int bTransfer = TRUE;
		
		if ( iSpellId != -1 || !GetHasSpellEffect( iSpellId, oReceiver)  )
		{
			bTransfer = FALSE; // I don't want to tranfer if i've already got the same spellid in effect
		}
		
		eEffect = GetFirstEffect(oTarget);
		while ( GetIsEffectValid(eEffect) && bExit == FALSE )
		{
			//SendMessageToPC( GetFirstPC(),CSLGetSpellDataName(iSpellId)+" effect "+CSLGetEffectTypeName(GetEffectType(eEffect))+" / "+CSLGetEffectSubTypeName(GetEffectType(eEffect))+" and it's "+IntToString(CSLGetEffectTypeBenefical( GetEffectType(eEffect)) ) );
			
			if ( iCasterOnly == FALSE || GetEffectCreator(eEffect) == oCreator || !GetIsObjectValid( GetEffectCreator(eEffect) ) )
			{
				if ( iSpellId == -1 || GetEffectSpellId(eEffect) == iSpellId )
				{
					if ( iEffectTypeID == -1 || GetEffectType(eEffect) == iEffectTypeID )
					{
						if (nEffectSubType == -1 || GetEffectSubType(eEffect) == nEffectSubType)
						{
							//If the effect was created by the spell then remove it
							
							//SendMessageToPC( GetFirstPC(), "Adding to Transfer");
							
							if ( bTransfer )
							{
								eTempEffect = SetEffectSpellId(eEffect, iSpellId);
								eTransferEffects = EffectLinkEffects( eTransferEffects, eTempEffect);
					
								if ( GetEffectType(eEffect) == EFFECT_TYPE_TEMPORARY_HITPOINTS )
								{
									CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oCreator, oReceiver, EFFECT_TYPE_TEMPORARY_HITPOINTS );
									bTempHps = TRUE;
								}
								
								
								float fDuration = RoundsToSeconds( d6(3) );
								//if (iMetaMagic & METAMAGIC_EXTEND)     { fDuration *= 2; }
								ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTransferEffects, oReceiver, fDuration);

							}
							
							DelayCommand( 0.5f, RemoveEffect(oTarget, eEffect) );
							
							//if (DEBUGGING >= 8) { CSLDebug( "Removed Effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
							iRemovedEffect = TRUE;
							if ( iFirstOnly == TRUE )
							{
								bExit = TRUE;
							}
							// eEffect = GetFirstEffect(oTarget);  // 8/28/06 - BDF-OEI: start back at the beginning to ensure that linked effects are removed safely
							eEffect = GetNextEffect(oTarget); // don't need to restart if using a delayed command version, this is so effects still exist when they are applied to new target i think
						}
						else
						{
							//if (DEBUGGING >= 8) { CSLDebug( "Ignoring Effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
							//Get next effect on the target
							eEffect = GetNextEffect(oTarget);
						}
				
					}
					else
					{
						//if (DEBUGGING >= 8) { CSLDebug( "Ignoring Effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
						//Get next effect on the target
						eEffect = GetNextEffect(oTarget);
					}				
				
				}
				else
				{
					//if (DEBUGGING >= 8) { CSLDebug( "Ignoring Effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
					//Get next effect on the target
					eEffect = GetNextEffect(oTarget);
				}
			}
			else
			{
				//if (DEBUGGING >= 8) { CSLDebug( "Effect "+CSLGetSpellDataName(iSpellId)+" Is Not By Creator!", oCreator, oTarget); }
				//Get next effect on the target
				eEffect = GetNextEffect(oTarget);
			}
		}
	}
	/*
	if ( GetIsObjectValid( oReceiver ) )
	{
		SendMessageToPC( GetFirstPC(), "Receiver Valid");
		if ( iRemovedEffect )
		{
			SendMessageToPC( GetFirstPC(), "There Was a removed effect");
			if ( GetIsEffectValid( eTransferEffects ) )
			{
				SendMessageToPC( GetFirstPC(), "Transfered Effect is valid");
				
				if ( iSpellId != -1 || !GetHasSpellEffect( iSpellId, oReceiver)  )
				{
					SendMessageToPC( GetFirstPC(), "Attempting Transfer");
					if ( bTempHps == TRUE )
					{
						CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oCreator, oReceiver, EFFECT_TYPE_TEMPORARY_HITPOINTS );
					}
					eTransferEffects = SetEffectSpellId( eTransferEffects, iSpellId );
					float fDuration = RoundsToSeconds( d6(3) );
					//if (iMetaMagic & METAMAGIC_EXTEND)     { fDuration *= 2; }
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTransferEffects, oReceiver, fDuration);
				}
			}
			else
			{
				SendMessageToPC( GetFirstPC(), "Transfered Effect is Invalid");
			}
		}
	}
	*/
	//else
	//{
	// if (DEBUGGING >= 8) { CSLDebug( "Does not have effect "+CSLGetSpellDataName(iSpellId), oCreator, oTarget); }
	//}
	//return iRemovedEffect;
}


const string SCTAG_WORKBENCH_PREFIX1 	= "PLC_MC_WBENCH";
const string SCTAG_WORKBENCH_PREFIX2 	= "PLC_MC_CBENCH";

// Alchemy Workbench tags
const string SCTAG_ALCHEMY_BENCH1 	= "alchemy_bench";
const string SCTAG_ALCHEMY_BENCH2 	= "PLC_MC_CBENCH01";
const string SCTAG_ALCHEMY_BENCH3 	= "alchemy";
const string SCTAG_ALCHEMY_BENCH4 	= "PLC_MR_AWBench";

// Blacksmith Workbench tags
const string SCTAG_WORKBENCH1 		= "workbench";
const string SCTAG_WORKBENCH2 		= "PLC_MC_CBENCH02";
const string SCTAG_WORKBENCH3 		= "blacksmith";
const string SCTAG_WORKBENCH4 		= "PLC_MR_WWBench";

// Magical Workbench tags
const string SCTAG_MAGICAL_BENCH1 	= "magical_bench";
const string SCTAG_MAGICAL_BENCH2 	= "PLC_MC_CBENCH03";
const string SCTAG_MAGICAL_BENCH3 	= "magical";
const string SCTAG_MAGICAL_BENCH4 	= "PLC_MR_MWBench";


// workbench vars - set to 1 to indicate workbench
const string SCVAR_ALCHEMY			= "WB_alchemy";	
const string SCVAR_BLACKSMITH 		= "WB_blacksmith";
const string SCVAR_MAGICAL 			= "WB_magical";


int CSLIsWorkbench( object oTarget )
{
	int iObjType = GetObjectType(oTarget);
	if (iObjType != OBJECT_TYPE_PLACEABLE) // alchemy workbench must be a placeable
		return FALSE;
	
	
	// knows the tags for the OC basically
	string sTargetTag = GetTag(oTarget);
	string sTargetTagPrefix = GetStringLeft(sTargetTag, GetStringLength(SCTAG_WORKBENCH_PREFIX1));
	if ((sTargetTagPrefix == SCTAG_WORKBENCH_PREFIX1) || (sTargetTagPrefix == SCTAG_WORKBENCH_PREFIX2))
		return TRUE;
	
	if ((sTargetTag == SCTAG_MAGICAL_BENCH1) || (sTargetTag == SCTAG_MAGICAL_BENCH2) || 
		(sTargetTag == SCTAG_MAGICAL_BENCH3) || (sTargetTag == SCTAG_MAGICAL_BENCH4) )
		return TRUE;
		
	if (GetLocalInt(oTarget, SCVAR_MAGICAL) == TRUE)
		return TRUE;
		
		
	if ((sTargetTag == SCTAG_WORKBENCH1) || (sTargetTag == SCTAG_WORKBENCH2) ||
		(sTargetTag == SCTAG_WORKBENCH3) || (sTargetTag == SCTAG_WORKBENCH4) )
		return TRUE;
		
	if (GetLocalInt(oTarget, SCVAR_BLACKSMITH) == TRUE)
		return TRUE;
		
	if ((sTargetTag == SCTAG_ALCHEMY_BENCH1) || (sTargetTag == SCTAG_ALCHEMY_BENCH2) ||
		(sTargetTag == SCTAG_ALCHEMY_BENCH3) || (sTargetTag == SCTAG_ALCHEMY_BENCH4) )
		return TRUE;
		
	if (GetLocalInt(oTarget, SCVAR_ALCHEMY) == TRUE)
		return TRUE;
		
	//if (IsSmithWorkbench(oTarget) || IsAlchemyWorkbench(oTarget) || IsMagicalWorkbench(oTarget))
	//	return TRUE;
	return FALSE;
}




/**  
* Checks if an object has a give effect type
* @author
* @param 
* @see 
* @return 
* @replaces GetHasEffect with parameter differences
*/
int CSLGetHasEffectType(object oTarget, int iEffectTypeID, int nEffectSubType=-1 )
{	
	effect eEffect;
	eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		if (GetEffectType(eEffect) == iEffectTypeID )
		{
			if (nEffectSubType==-1 || GetEffectSubType(eEffect)==nEffectSubType)
			{
				return TRUE;
			}
		}
		eEffect = GetNextEffect(oTarget);
	}
	return FALSE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetHasEffectTypeGroup(object oTarget, int iEffectTypeID0 = -1, int iEffectTypeID1 = -1, int iEffectTypeID2 = -1, int iEffectTypeID3 = -1, int iEffectTypeID4 = -1, int iEffectTypeID5 = -1, int iEffectTypeID6 = -1, int iEffectTypeID7 = -1, int iEffectTypeID8 = -1, int iEffectTypeID9 = -1 )
{	
	effect eEffect;
	eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		if (  ( iEffectTypeID0 != -1 && GetEffectType( eEffect ) == iEffectTypeID0 )  || ( iEffectTypeID1 != -1 && GetEffectType( eEffect ) == iEffectTypeID1 )  || ( iEffectTypeID2 != -1 && GetEffectType( eEffect ) == iEffectTypeID2 )  || ( iEffectTypeID3 != -1 && GetEffectType( eEffect ) == iEffectTypeID3 )  || ( iEffectTypeID4 != -1 && GetEffectType( eEffect ) == iEffectTypeID4 )  || ( iEffectTypeID5 != -1 && GetEffectType( eEffect ) == iEffectTypeID5 )  || ( iEffectTypeID6 != -1 && GetEffectType( eEffect ) == iEffectTypeID6 ) || ( iEffectTypeID7 != -1 && GetEffectType( eEffect ) == iEffectTypeID7 )  || ( iEffectTypeID8 != -1 && GetEffectType( eEffect ) == iEffectTypeID8 ) || ( iEffectTypeID9 != -1 && GetEffectType( eEffect ) == iEffectTypeID9  ) )
		{
			return TRUE;
		}
		eEffect = GetNextEffect(oTarget);
	}
		
	
	return FALSE;
}

/**  
* Count the number of effects on a target
* @author
* @param oTarget
* @param bBeneficalHarmful
* @param nLimit
* @see 
* @return 
*/
// * Counts how many magical effects are on a target, nLimit allows this to be capped and an early exit if more than this number
// * bBeneficalHarmful 1 = beneficial, 0 = harmful, -1 if invalid, error or things that this does not apply to, 3 will make it work for every effect, need constants probably for this
int CSLCountEffectsOnTarget( object oTarget, int bBeneficalHarmful = 1, int nLimit = 25 )
{
	int iNumberOfEffects = 0; 
	string sSpellList = "|";
	int iSpellId;
	effect eEffect = GetFirstEffect(oTarget);
	while ( GetIsEffectValid(eEffect) )
	{
		iSpellId = GetEffectSpellId(eEffect);
		//SendMessageToPC( GetFirstPC(), "We have an SpellID " + IntToString( iSpellId )+"effect "+CSLGetEffectTypeName(GetEffectType(eEffect))+" / "+CSLGetEffectSubTypeName(GetEffectType(eEffect))+" and it's "+IntToString(CSLGetEffectTypeBenefical( GetEffectType(eEffect)) ) );
		if ( iSpellId != -1 && GetEffectSubType(eEffect) == SUBTYPE_MAGICAL && ( bBeneficalHarmful == 3 || CSLGetEffectTypeBenefical( GetEffectType(eEffect) ) == bBeneficalHarmful )  )
		{
			//SendMessageToPC( GetFirstPC(), "Another effect");
			if ( FindSubString(sSpellList, "|" + IntToString(iSpellId) + "|") == -1 )
			{
				// Add to found list so we don't repeat
				//SendMessageToPC( GetFirstPC(), "Adding to Count Total Now = "+IntToString(iNumberOfEffects) );
				sSpellList += IntToString(iSpellId) + "|";
				iNumberOfEffects++;
				
				if ( iNumberOfEffects >= nLimit )
				{
					return iNumberOfEffects;
				}
			
			}
		}
		eEffect = GetNextEffect(oTarget);
	}
	//SendMessageToPC( GetFirstPC(), "Final Total Now = "+IntToString(iNumberOfEffects) );
	return iNumberOfEffects;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
effect CSLApplyEffectSubType(effect eEffect, int nEffectSubType=0)
{
	if (nEffectSubType == SUBTYPE_MAGICAL)
	{
		eEffect = MagicalEffect(eEffect);
	}
	else if (nEffectSubType == SUBTYPE_EXTRAORDINARY)
	{
		eEffect = ExtraordinaryEffect(eEffect);
	}
	else if (nEffectSubType == SUBTYPE_SUPERNATURAL)
	{
		eEffect = SupernaturalEffect(eEffect);
	}
	return (eEffect);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// remove all effects by a given creator
int CSLRemoveEffectByCreator(object oTarget, object oCreator = OBJECT_INVALID, int bMagicalEffectsOnly = FALSE)
{
	int bRemove = FALSE;
	int bCheckCreator = TRUE;
	
	if ( !GetIsObjectValid( oCreator ) )
	{
		bMagicalEffectsOnly = TRUE;
		bCheckCreator = FALSE;
	}
	
	effect eEffect = GetFirstEffect( oTarget );
	while ( GetIsEffectValid(eEffect) )
	{
		int bRestart = FALSE;
		if ( ( bCheckCreator == FALSE || GetEffectCreator(eEffect)==oCreator ) &&
		     ( bMagicalEffectsOnly == FALSE || GetEffectSubType(eEffect) == SUBTYPE_MAGICAL )  )
		{
			RemoveEffect(oTarget, eEffect);
			bRemove = TRUE;
			bRestart = TRUE;
		}
		if (bRestart)
		{
			eEffect = GetFirstEffect(oTarget);
		}
		else
		{
			eEffect = GetNextEffect(oTarget);
		}
	}
	return bRemove;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// remove all effects by a given creator which are from a very limited set of negative effects
int CSLRemoveAtWillEffectsByCreator(object oTarget, object oCreator, int bFeedBack = FALSE )
{
	int bRemove = FALSE;
	
	
	int bHoldSpell = FALSE;
	int bReduceSpell = FALSE;
	int bStoneSpell = FALSE;
	int SolipsismSpell = FALSE;
	int bSilenceSpell = FALSE;
	int bInvisSpell = FALSE;
	
	// only deal with these limited spell id's
	if ( 
		GetHasSpellEffect(SPELL_MASS_HOLD_MONSTER, oTarget) || 
		GetHasSpellEffect(SPELL_MASS_HOLD_PERSON, oTarget) || 	
		GetHasSpellEffect(SPELL_REDUCE_ANIMAL, oTarget) || 
		GetHasSpellEffect(SPELL_REDUCE_PERSON, oTarget) || 
		GetHasSpellEffect(SPELL_REDUCE_PERSON_GREATER, oTarget) || 
		GetHasSpellEffect(SPELL_REDUCE_PERSON_MASS, oTarget) || 
		GetHasSpellEffect(SPELL_SILENCE, oTarget) || 
		GetHasSpellEffect(SPELL_SOLIPSISM, oTarget) || 
		GetHasSpellEffect(SPELL_FLESH_TO_STONE, oTarget) || 
		GetHasSpellEffect(SPELL_HOLD_ANIMAL, oTarget) || 
		GetHasSpellEffect(SPELL_HOLD_MONSTER, oTarget) || 
		
		GetHasSpellEffect(SPELL_I_WALK_UNSEEN, oTarget) || 
		GetHasSpellEffect(SPELL_I_RETRIBUTIVE_INVISIBILITY, oTarget) || 
		GetHasSpellEffect(SPELL_GREATER_INVISIBILITY, oTarget) || 
		GetHasSpellEffect(SPELLABILITY_AS_GREATER_INVISIBLITY, oTarget) || 
		GetHasSpellEffect(SPELL_INVISIBILITY, oTarget) || 
		
		
		GetHasSpellEffect(SPELL_HOLD_PERSON, oTarget) 	
	)
	{
		
		effect eEffect = GetFirstEffect( oTarget );
		while ( GetIsEffectValid(eEffect) )
		{
			int bRestart = FALSE;
			if ( GetEffectCreator(eEffect)==oCreator )
			{
				if ( GetEffectSpellId(eEffect) == SPELL_MASS_HOLD_MONSTER ||  GetEffectSpellId(eEffect) == SPELL_MASS_HOLD_PERSON || GetEffectSpellId(eEffect) == SPELL_HOLD_ANIMAL || GetEffectSpellId(eEffect) == SPELL_HOLD_MONSTER ||  GetEffectSpellId(eEffect) == SPELL_HOLD_PERSON )
				{
					RemoveEffect(oTarget, eEffect);
					bRemove = TRUE;
					bRestart = TRUE;
					bHoldSpell = TRUE;
		
				}
				if ( GetEffectSpellId(eEffect) == SPELL_REDUCE_ANIMAL || GetEffectSpellId(eEffect) == SPELL_REDUCE_PERSON || GetEffectSpellId(eEffect) == SPELL_REDUCE_PERSON_GREATER || GetEffectSpellId(eEffect) == SPELL_REDUCE_PERSON_MASS )
				{
					RemoveEffect(oTarget, eEffect);
					bRemove = TRUE;
					bRestart = TRUE;
					bReduceSpell = TRUE;
		
				}
				if ( GetEffectSpellId(eEffect) == SPELL_SILENCE )
				{
					RemoveEffect(oTarget, eEffect);
					bRemove = TRUE;
					bRestart = TRUE;
					bSilenceSpell = TRUE;
				}
				if ( GetEffectSpellId(eEffect) == SPELL_SOLIPSISM )
				{
					RemoveEffect(oTarget, eEffect);
					bRemove = TRUE;
					bRestart = TRUE;
					SolipsismSpell = TRUE;
		
				}
				if ( GetEffectSpellId(eEffect) == SPELL_FLESH_TO_STONE )
				{
					RemoveEffect(oTarget, eEffect);
					bRemove = TRUE;
					bRestart = TRUE;
					bStoneSpell = TRUE;
		
				}
				
				if ( GetEffectSpellId(eEffect) == SPELL_I_WALK_UNSEEN || GetEffectSpellId(eEffect) == SPELL_INVISIBILITY || GetEffectSpellId(eEffect) == SPELL_I_RETRIBUTIVE_INVISIBILITY || GetEffectSpellId(eEffect) == SPELL_GREATER_INVISIBILITY || GetEffectSpellId(eEffect) == SPELLABILITY_AS_GREATER_INVISIBLITY )
				{
					RemoveEffect(oTarget, eEffect);
					bRemove = TRUE;
					bRestart = TRUE;
					bInvisSpell = TRUE;
		
				}
		
			}
			if (bRestart)
			{
				eEffect = GetFirstEffect(oTarget);
			}
			else
			{
				eEffect = GetNextEffect(oTarget);
			}
		}
		
	}
	if ( bRemove && bFeedBack )
	{
		string sRemovedText = "";
		if ( bHoldSpell ) { sRemovedText += "Hold "; }
		if ( bReduceSpell ) { sRemovedText += "Reduce "; }
		if ( bStoneSpell ) { sRemovedText += "Flesh to Stone "; }
		if ( SolipsismSpell ) { sRemovedText += "Solipism "; }
		if ( bSilenceSpell ) { sRemovedText += "Silence "; }
		if ( bInvisSpell ) { sRemovedText += "Invisibility "; }
		
		
		SendMessageToPC( oCreator, "You removed the "+sRemovedText+"you cast on "+GetName(oTarget) );
		SendMessageToPC( oTarget, GetName(oCreator)+" removed the "+sRemovedText+"spell from you" );
	}
	return bRemove;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// remove all effects that no longer have a valid creator
void CSLRemoveOrphanedEffects( object oTarget )
{
	int bRemove = FALSE;
	effect eEffect = GetFirstEffect(oTarget);
	while ( GetIsEffectValid(eEffect) )
	{
		int bRestart = FALSE;
		if ( !GetIsObjectValid( GetEffectCreator(eEffect) ) )
		{
			RemoveEffect(oTarget, eEffect);
			bRemove = TRUE;
			bRestart = TRUE;
		}
		if (bRestart)
		{
			eEffect = GetFirstEffect(oTarget);
		}
		else
		{
			eEffect = GetNextEffect(oTarget);
		}
	}
	//return bRemove;
}

/**  
* @author
* @param 
* @see 
* @return 
* @replaces RemoveEffects
*/
// remove all effects
void CSLRemoveAllEffects( object oTarget, int iStateWhatsRemoved = FALSE, string sMessage = "" )
{
	int bRemove = FALSE;
	effect eEffect = GetFirstEffect(oTarget);
	while ( GetIsEffectValid(eEffect) )
	{
		int bRestart = FALSE;
		if ( iStateWhatsRemoved == TRUE )
		{
			SendMessageToPC(oTarget, sMessage +" #" + IntToString(GetEffectSpellId(eEffect)) + " of Type " + IntToString(GetEffectType(eEffect)));
		}
		RemoveEffect(oTarget, eEffect);
		bRemove = TRUE;
		bRestart = TRUE;
		
		if (bRestart)
		{
			eEffect = GetFirstEffect(oTarget);
		}
		else
		{
			eEffect = GetNextEffect(oTarget);
		}
	}
	//return bRemove;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// remove all effects are magical AND that have a spellid
int CSLRemoveAllMagicalEffects( object oTarget, int iStateWhatsRemoved = FALSE, string sMessage = "" )
{
	int bRemove = FALSE;
	int bRestart = FALSE;
	effect eEffect = GetFirstEffect(oTarget);
	while ( GetIsEffectValid(eEffect) )
	{
		
		if ( GetEffectSpellId(eEffect) > -1 && GetEffectSubType(eEffect) == SUBTYPE_MAGICAL )
		{
			if ( iStateWhatsRemoved == TRUE )
			{
				SendMessageToPC(oTarget, sMessage +" #" + IntToString(GetEffectSpellId(eEffect)) + " of Type " + IntToString(GetEffectType(eEffect)));
			}
			RemoveEffect(oTarget, eEffect);
			bRemove = TRUE;
			bRestart = TRUE;
			
			
		}
		
		if (bRestart)
		{
			eEffect = GetFirstEffect(oTarget);
			bRestart = FALSE;
		}
		else
		{
			eEffect = GetNextEffect(oTarget);
		}
	}
	return bRemove;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLRemoveAllNegativeEffects( object oTarget, int iStateWhatsRemoved = FALSE, string sMessage = "" )
{
	int bRemove = FALSE;
	int bRestart = FALSE;
	effect eEffect = GetFirstEffect(oTarget);
	while ( GetIsEffectValid( eEffect ) )
	{
		
		if (GetEffectType(eEffect) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eEffect) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eEffect) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eEffect) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eEffect) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eEffect) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eEffect) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eEffect) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eEffect) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eEffect) == EFFECT_TYPE_DEAF ||
            GetEffectType(eEffect) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eEffect) == EFFECT_TYPE_NEGATIVELEVEL ||
            GetEffectType(eEffect) == EFFECT_TYPE_FRIGHTENED ||
            GetEffectType(eEffect) == EFFECT_TYPE_DAZED ||
            GetEffectType(eEffect) == EFFECT_TYPE_CONFUSED ||
            GetEffectType(eEffect) == EFFECT_TYPE_POISON ||
            GetEffectType(eEffect) == EFFECT_TYPE_DISEASE
                )
		{
			if ( iStateWhatsRemoved == TRUE )
			{
				SendMessageToPC(oTarget, sMessage +" #" + IntToString(GetEffectSpellId(eEffect)) + " of Type " + IntToString(GetEffectType(eEffect)));
			}
			RemoveEffect(oTarget, eEffect);
			bRemove = TRUE;
			bRestart = TRUE;
			
			
		}
		
		if (bRestart)
		{
			eEffect = GetFirstEffect(oTarget);
			bRestart = FALSE;
		}
		else
		{
			eEffect = GetNextEffect(oTarget);
		}
	}
	
	if ( bRemove )
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION), oTarget);
	}
	
	return bRemove;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLUnstackSpellEffects(object oPC, int iSpellId, string sWithSpell="")
{
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId ) ) 
	{
		if (sWithSpell!="")
		{
			sWithSpell = " with " + sWithSpell;
		}
		SendMessageToPC(oPC, "The effects of this spell do not stack" + sWithSpell + ".");
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLCheckNonStackingSpell(object oPC, int iSpellId, string sWithSpell)
{
	if (GetHasSpellEffect(iSpellId, oPC))
	{
		SendMessageToPC(oPC, "The effects of this spell do not stack with " + sWithSpell + ".");
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
int CSLGetHasSpellEffectByCaster(int iSpellId, object oTarget, object oCaster)
{
	if (!GetHasSpellEffect(iSpellId, oTarget)) return FALSE; // DOES HAVE THE EFFECT FROM ANY CASTER
	effect eCheck = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eCheck))
	{
		if (GetEffectSpellId(eCheck)==iSpellId && GetEffectCreator(eCheck)==oCaster) return TRUE;
		eCheck = GetNextEffect(oTarget);
	}
	return FALSE;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// Specifically removes an aura from a Target...
void CSLRemoveAuraById( object oTarget = OBJECT_SELF, int iSpellId = -1 )
{
	// Strip any Auras first
	effect eTest = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eTest))
	{
		if (GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT && GetEffectSpellId(eTest) == iSpellId )
		{
			RemoveEffect(oTarget, eTest);
		}
		eTest = GetNextEffect(oTarget);
	}
	
	// strip any extra aura objects
	
	object o = GetFirstObjectInArea(GetArea(oTarget));
	while(GetIsObjectValid(o))
	{
		if (GetObjectType(o)==OBJECT_TYPE_AREA_OF_EFFECT)
		{
			//SpeakString("FOUND AOE OBJECT WITH SPELL ID: "+IntToString(GetAreaOfEffectSpellId(o)));
					//	if (  GetAreaOfEffectSpellId(o)==SPELLABILITY_HELLFIRE_SHIELD  )


			if (  GetAreaOfEffectSpellId(o)==iSpellId && GetAreaOfEffectCreator(o) == oTarget )
			{
				//SpeakString("FOUND/DESTROY OLD AOE OBJECT");
				DestroyObject(o);
			}
		}	
		o = GetNextObjectInArea(GetArea(oTarget));
	}

}

/**  
* @author
* @param 
* @see 
* @return 
*/
//------------------------------------------------------------------------------
// GZ: 2003-Oct-15
// A different approach for timing these spells that has the positive side
// effects of making the spell dispellable as well.
// I am using the VFX applied by the spell to track the remaining duration
// instead of adding the remaining runtime on the stack
//
// This function returns FALSE if a delayed Spell effect from nSpell_ID has
// expired. See x2_s0_bigby4.nss for details
//------------------------------------------------------------------------------
// EPF-OEI 3/16/07 -- effect should expire if the campaign doesn't allow the harming of non-hostile NPCs
// and the target has ceased to be hostile to the caster.  This fixes a problem where spells like Bigby's would
// keep attacking boss characters who "surrender" at 1HP
int CSLGetDelayedSpellEffectsExpired(int nSpell_ID, object oTarget, object oCaster)
{
	if (!GetHasSpellEffect(nSpell_ID,oTarget) )
	{
		DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
		return TRUE;
	}

	//--------------------------------------------------------------------------
	// GZ: 2003-Oct-15
	// If the caster is dead or no longer there, cancel the spell, as it is
	// directed
	//--------------------------------------------------------------------------
	if( !GetIsObjectValid(oCaster))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, nSpell_ID );
		DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString(nSpell_ID));
		return TRUE;
	}

	if ( GetIsDead(oCaster) || GetIsDead(oTarget) ) // added a check to see if the target is dead so that effects don't persist on corpses
	{
		DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString(nSpell_ID));
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, nSpell_ID );
		return TRUE;
	}
	
	if(!GetGlobalInt("N2_S_USE_PERSONAL_REP") && !GetIsEnemy(oCaster,oTarget))
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
float CSLGetSpellEffectDelay(location SpellTargetLocation, object oTarget)
{
	float fDelay;
	return fDelay = GetDistanceBetweenLocations(SpellTargetLocation, GetLocation(oTarget))/20;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLRemovePermanencySpells(object oTarget)
{
	// We are applying a new Spell:Permanency Effect, get rid of any old ones!
	object oItem      = GetSpellCastItem();
	if (GetIsObjectValid(oItem) && GetBaseItemType(oItem)==BASE_ITEM_SPELLSCROLL) return; // CAN'T BE PERMANENT IF SCROLL

	int iMetaMagic = GetMetaMagicFeat();
	if ( iMetaMagic & METAMAGIC_PERMANENT )
	{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_BLINDSIGHT);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DARKVISION);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENLARGE_PERSON);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MAGE_ARMOR);
			// Alignment is tricky, because it is a master spell...
//        CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ALIGNMENT);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_EVIL);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_GOOD);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ARROWS);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_RESISTANCE);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_SEE_INVISIBILITY);
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLDestroyUnownedAOE(object oCaster, object oAOE)
{
	if ( GetIsObjectValid( oCaster) && !GetIsDead( oCaster ) )
	{
		return FALSE;
	}
	DestroyObject(oAOE);
	return TRUE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
object CSLGetNearestAOE(location lTarget, float fRadius = RADIUS_SIZE_HUGE, int iSpellId = -1)
{
	object oAOE = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_AREA_OF_EFFECT);
	while (GetIsObjectValid(oAOE))
	{
		if (iSpellId==-1)
		{
			return oAOE;
		}
		oAOE = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_AREA_OF_EFFECT);
	}
	return OBJECT_INVALID;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// * Reads modifier vars both permanent and temporary in the format of  HKTEMP_damagemodtype and HKPERM_damagemodtype returning the correct value
// * sModifierName - name of the var, the part AFTER the underscore
// * iModifier - the default value for the given var, if both are 0 ( unset ) it will return this value
int CSLReadIntModifier( object oChar, string sModifierName, int iModifier = 0 )
{
	//if (DEBUGGING >= 5) { CSLDebug("iModifier for HKPERM_"+sModifierName+" is "+IntToString(  GetLocalInt( oChar, "HKPERM_"+sModifierName ) ) ); }
	if ( GetLocalInt( oChar, "HKPERM_"+sModifierName ) != 0 )
	{
		iModifier = GetLocalInt( oChar, "HKPERM_"+sModifierName );
		if (DEBUGGING >= 5) { CSLDebug("iModifier for HKPERM_"+sModifierName+" is "+IntToString( iModifier ) ); }
	
	}
	else if ( GetLocalInt( oChar, "HKTEMP_"+sModifierName ) != 0 )
	{
		iModifier = GetLocalInt( oChar, "HKTEMP_"+sModifierName );
		if (DEBUGGING >= 5) { CSLDebug("iModifier for HKTEMP_"+sModifierName+" is "+IntToString( iModifier ) ); }
	
	}
	return iModifier;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLReadBitModifier( object oChar, string sModifierName, int iModifier = 0 )
{
	if (DEBUGGING >= 5) { CSLDebug("iModifier for HKPERM_"+sModifierName+" is "+IntToString(  GetLocalInt( oChar, "HKPERM_"+sModifierName ) ) ); }

	if ( GetLocalInt( oChar, "HKPERM_"+sModifierName ) != 0 )
	{
		iModifier |= GetLocalInt( oChar, "HKPERM_"+sModifierName );
		if (DEBUGGING >= 5) { CSLDebug("iModifier for HKPERM_"+sModifierName+" is "+IntToString( iModifier ) ); }
		if (DEBUGGING >= 5) { CSLDebug("iModifier for HKPERM_"+sModifierName+" is "+IntToString( iModifier ) ); }

	}
	else if ( GetLocalInt( oChar, "HKTEMP_"+sModifierName ) != 0 )
	{
		iModifier |= GetLocalInt( oChar, "HKTEMP_"+sModifierName );
		if (DEBUGGING >= 5) { CSLDebug("iModifier for HKTEMP_"+sModifierName+" is "+IntToString( iModifier ) ); }
	
	}
	return iModifier;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLApplyEffectPetrify(object oTarget, float fFatigueDuration, float fDelay = 0.0f )
{
    effect ePetrify = EffectPetrify();
    			DelayCommand(fDelay + 0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePetrify, oTarget, fFatigueDuration));
			DelayCommand(fDelay + 0.2f, SendMessageToPC(oTarget, "Your fatigue becomes exhaustion due to your exertions."));	

    //HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePetrify, oTarget, 0.0, TRUE, -1, HkGetCasterLevel(OBJECT_SELF), OBJECT_SELF);
}


// Removes the petrification effect.
/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLRemoveEffectPetrify(object oTarget)
{
    CSLRemoveEffectByType(oTarget, EFFECT_TYPE_PETRIFY);
}



// Petrify something permanently using the barkskin texture instead of stone.
/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLApplyEffectPetrifyWood(object oTarget)
{
    effect eFreeze = EffectCutsceneParalyze();
    effect eBark = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFreeze, oTarget);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBark, oTarget);
}

// Depetrify something turned to wood
/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLRemoveEffectPetrifyWood(object oTarget)
{
    effect eBark = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
    CSLRemoveEffectByType(oTarget, GetEffectType(eBark));
    CSLRemoveEffectByType(oTarget, EFFECT_TYPE_CUTSCENE_PARALYZE);
}




// fear and scare use this
/**  
* @author
* @param 
* @see 
* @return 
*/
effect CSLGetFearEffect(int bWithPenalties = TRUE)
{
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_FEAR);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
	eLink = EffectLinkEffects(eLink, EffectFrightened());
	if (bWithPenalties) {
		eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS));
		eLink = EffectLinkEffects(eLink, EffectDamageDecrease(2));
		eLink = EffectLinkEffects(eLink, EffectAttackDecrease(2));
	}
	return eLink;
}







/* List all effects on an object */
/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLAllEffectsToString(object oPC )
{
	int iTotalEffects = 0;
	string sMessage = "Stats for " + GetName(oPC);
	effect eSearch = GetFirstEffect(oPC);
	while (GetIsEffectValid(eSearch))
	{
		iTotalEffects++;
		int iEffectSpellId = GetEffectSpellId(eSearch);
		string sEffectTypeName = CSLGetEffectTypeName( GetEffectType(eSearch) );
		
		string sEffectSubTypeName = CSLGetEffectSubTypeName( GetEffectSubType(eSearch) );
		
		string sSpellName = CSLGetSpellDataName( iEffectSpellId );
		object oCreator = GetEffectCreator(eSearch);
		string sCreatorName = GetName(oCreator);
		int nEffectLevel = 0;
		nEffectLevel = GetLocalInt(oPC, "SC_"+IntToString( iEffectSpellId )+"_CASTERLEVEL" ); // CHECK THE STORED VARIABLE FIRST
		if ( nEffectLevel == 0 )
		{
			nEffectLevel = GetCasterLevel(oCreator); // NOT FOUND AT ALL, USE THE STANDBY HACK since i don't want to use my system here
		}
		
		
		sMessage += "\n   Effect "+IntToString(iTotalEffects)+ ": "+IntToString( iEffectSpellId )+" "+sSpellName+" // " + sEffectTypeName ;
		if ( sCreatorName != "" ){ sMessage += " By " + sCreatorName; }
		
		if ( nEffectLevel > 0 ){ sMessage += "  Lvl "+IntToString( nEffectLevel ); }
		
		eSearch = GetNextEffect(oPC);
	}
	sMessage += "\nTotal effects were "+IntToString(iTotalEffects);
	return sMessage;
}

//* Creates a list of the effects on a target, from highest spell level to lowest
/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLLevelSortedMagicalEffectsString( object oPC )
{
	string sCompleted;
	string sSpellId;
	string sLevel0;
	string sLevel1;
	string sLevel2;
	string sLevel3;
	string sLevel4;
	string sLevel5;
	string sLevel6;
	string sLevel7;
	string sLevel8;
	string sLevel9;
	
	int iCurSpellLevel;
	int iSpellId;
	
	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect))
	{
		iSpellId = GetEffectSpellId(eEffect);
		if ( iSpellId > -1 && GetEffectSubType(eEffect) == SUBTYPE_MAGICAL )
		{
			sSpellId = IntToString(iSpellId);
			iCurSpellLevel = StringToInt( CSLGetSpellDataLevel( iSpellId ) );
			if ( FindSubString(sCompleted, "|" + sSpellId + "|") == -1 )
			{
				sCompleted += sSpellId + "|";
				if ( oPC == GetEffectCreator(eEffect) )
				{
					sSpellId += "*";
				}
				
				if ( iCurSpellLevel > 8 )
				{
					sLevel9 += sSpellId + "|";
				}
				else if ( iCurSpellLevel > 5 )
				{
					if ( iCurSpellLevel > 7 )
					{
						sLevel8 += sSpellId + "|";
					}
					else if ( iCurSpellLevel > 6 )
					{
						sLevel7 += sSpellId + "|";
					}
					else
					{
						sLevel6 += sSpellId + "|";
					}
				
				}
				else if ( iCurSpellLevel > 2 )
				{
					if ( iCurSpellLevel > 4 )
					{
						sLevel5 += sSpellId + "|";
					}
					else if ( iCurSpellLevel > 3 )
					{
						sLevel4 += sSpellId + "|";
					}
					else
					{
						sLevel3 += sSpellId + "|";
					}
				
				}
				else
				{
					if ( iCurSpellLevel > 1 )
					{
						sLevel2 += sSpellId + "|";
					}
					else if ( iCurSpellLevel > 0 )
					{
						sLevel1 += sSpellId + "|";
					}
					else
					{
						sLevel0 += sSpellId + "|";
					}
				}
			}
			eEffect = GetNextEffect(oPC);
		}
	}	
	return sLevel9 + "|" + sLevel8 + "|" + sLevel7 + "|" + sLevel6+ "|" + sLevel5 + "|" + sLevel4 + "|" +sLevel3 + "|" +sLevel2 + "|" +sLevel1 + "|" + sLevel0;
}


//-----------------------------------------------------------
// Simulated Effects
//-----------------------------------------------------------

// Simulates a fatigue effect.  Can't be dispelled.
/**  
* @author
* @param 
* @see 
* @return 
*/
effect CSLEffectFatigue()
{
	// Create the fatigue penalty
	effect eStrPenalty = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
	effect eDexPenalty = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
	effect eMovePenalty = EffectMovementSpeedDecrease(10);   // 10% decrease
	
	effect eRet = EffectLinkEffects (eStrPenalty, eDexPenalty);
	eRet = EffectLinkEffects(eRet, eMovePenalty);
	eRet = ExtraordinaryEffect(eRet);
	eRet = SetEffectSpellId(eRet, FATIGUE );
	return (eRet);
}

// Simulates an Exhausted effect.  Can't be dispelled.
/**  
* @author
* @param 
* @see 
* @return 
*/
effect CSLEffectExhausted()
{
	effect eStrPenalty = EffectAbilityDecrease(ABILITY_STRENGTH, 6);
	effect eDexPenalty = EffectAbilityDecrease(ABILITY_DEXTERITY, 6);
	effect eMovePenalty = EffectMovementSpeedDecrease(50);   // 50% decrease
	
	effect eRet = EffectLinkEffects (eStrPenalty, eDexPenalty);
	eRet = EffectLinkEffects(eRet, eMovePenalty);
	eRet = ExtraordinaryEffect(eRet);
	eRet = SetEffectSpellId(eRet, EXHAUSTED );	
	return (eRet);
}


// Simulates a Sickened effect.  Can't be dispelled.
/**  
* @author
* @param 
* @see 
* @return 
*/
effect CSLEffectSickened()
{
	effect eAttackPenalty = EffectAttackDecrease(2);
	effect eDamagePenalty = EffectDamageDecrease(2);
	effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	effect eSkillPenalty = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	//effect eAbilityPenalty = EffectAbilityDecrease(, 2);
	
	effect eRet = EffectLinkEffects (eAttackPenalty, eDamagePenalty);
	eRet = EffectLinkEffects(eRet, eSavePenalty);
	eRet = EffectLinkEffects(eRet, eSkillPenalty);
	eRet = ExtraordinaryEffect(eRet);
	return (eRet);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLClearFatigue(object oTarget)
{
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, FATIGUE);
}


/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLClearExhausted(object oTarget)
{
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, EXHAUSTED);
}

///////////////////////////////////////////////////////////////////////////////
// CSLApplyFatigue
///////////////////////////////////////////////////////////////////////////////
// Created By: Andrew Woo (AFW-OEI)
// Created On: 08/08/2006
// Description:   Applies a "fatigue" effect to the target (oTarget), which lasts
// nFatigueDuration rounds.  You can delay the fatigue application by fDelay
// seconds.
///////////////////////////////////////////////////////////////////////////////
/**  
* @author OEI
* @param 
* @see 
* @return 
*/
void CSLApplyFatigue(object oTarget, float fFatigueDuration, float fDelay = 0.0f, int iRequiredSpellId = -1)
{
	// only apply if the target has an effect from the given spell id...
	if ( iRequiredSpellId != -1 && !GetHasSpellEffect(iRequiredSpellId, oTarget) )
	{
		return;
	}
	
	if ( GetHasFeat( FEAT_TIRELESS ) )	
	{
		return;
	}
	
	
	//SpeakString("Entering CSLApplyFatigue");
	
	// Only apply fatigue ifyou're not resting.
	// This is to keep you from getting fatigued if you rest while raging.
	if( !GetIsResting() )
	{	
		if ( GetHasSpellEffect(FATIGUE,oTarget) )
		{
			effect eExhausted = CSLEffectExhausted();
			DelayCommand(fDelay, CSLClearFatigue(oTarget));	
			DelayCommand(fDelay, CSLClearExhausted(oTarget));			
			DelayCommand(fDelay + 0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eExhausted, oTarget, fFatigueDuration ));
			DelayCommand(fDelay + 0.2f, SendMessageToPC(oTarget, "Your fatigue becomes exhaustion due to your exertions."));	
		}
		else
		{
			effect eFatigue = CSLEffectFatigue();
			DelayCommand(fDelay, CSLClearFatigue(oTarget));	
			DelayCommand(fDelay + 0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFatigue, oTarget, fFatigueDuration ));
			DelayCommand(fDelay + 0.2f, SendMessageToPC(oTarget, "Your become fatigued due to your exertions."));				
		}
	}
	
}


/**
* Creates a way of storing data in AOE's via the tag of the AOE
* @param iTagElement
* @param oAOE = OBJECT_SELF
* @return
* @see HkApplyTargetTag
* @see HkAOETag
* @see HkAOETag
* @replaces
*/
string CSLGetAOETagString( int iTagElement, object oAOE = OBJECT_SELF )
{
	string sAOE = GetTag( oAOE );
	string sVarName = "SCSPELLTAG"+IntToString( iTagElement );
	string sVarValue;
	
	// try to get a cached value
	sVarValue = GetLocalString( oAOE, sVarName );
	
	if ( sVarValue != "" ) // make sure something was in the cache, if it's not valid a invalid value will get stored in the AOE
	{
		return sVarValue;
	}
	else if ( GetStringLeft(sAOE, 6) == "SCAOE_" )
	{
		sVarValue = CSLNth_GetNthElement( sAOE, iTagElement, "_" );
	}
	else if ( iTagElement == SCSPELLTAG_CASTERCLASS )
	{
		sVarValue =  "255";
	}
	else
	{
		sVarValue =  "-1";
	}
	
	// set the value in the cache
	SetLocalString( oAOE, sVarName, sVarValue );

	return sVarValue;
}

/**
* Returns a Integer value for the specific named element on a AOE
* @param iTagElement
* @param oAOE = OBJECT_SELF
* @return
* @see
* @replaces
*/
int CSLGetAOETagInt( int iTagElement, object oAOE = OBJECT_SELF )
{
	return StringToInt( CSLGetAOETagString( iTagElement, oAOE )  );
}

/**
* Returns a Integer value for the specific named element on a Target
* @param iTagElement
* @param oTarget  The Target of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @return
* @see
* @replaces
*/
int CSLGetTargetTagInt( int iTagElement, object oTarget = OBJECT_SELF, int iSpellId = -1 )
{
	string sPrefix = "SC_"+IntToString(iSpellId)+"_";
	
	if ( iSpellId == -1 || ( GetLocalInt(oTarget, sPrefix+"SPELLID") == 0 && iSpellId != 0 ) ) // logically spell row 0 won't have to be dealt with since it's an AOE
	{
		// it must be invalid
		if ( iTagElement ==  SCSPELLTAG_CASTERCLASS )
		{
			return 255;
		}
		else
		{
			return -1;
		}
		
	}
	
	
	switch ( iTagElement )
	{
		case SCSPELLTAG_SPELLID:
			return GetLocalInt(oTarget, sPrefix+"SPELLID");
			break;
		case SCSPELLTAG_CASTERPOINTER:
			return StringToInt( GetLocalString(oTarget, sPrefix+"CASTERPOINTER") );
			break;
		case SCSPELLTAG_CASTERCLASS:
			return GetLocalInt(oTarget, sPrefix+"CASTERCLASS");
			break;
		case SCSPELLTAG_CASTERLEVEL:
			return GetLocalInt(oTarget, sPrefix+"CASTERLEVEL");
			break;
		case SCSPELLTAG_SPELLLEVEL:
			return GetLocalInt(oTarget, sPrefix+"SPELLLEVEL");
			break;
		case SCSPELLTAG_SPELLPOWER:
			return GetLocalInt(oTarget, sPrefix+"SPELLPOWER");
			break;
		case SCSPELLTAG_METAMAGIC:
			return GetLocalInt(oTarget, sPrefix+"METAMAGIC");
			break;
		case SCSPELLTAG_DESCRIPTOR:
			return GetLocalInt(oTarget, sPrefix+"DESCRIPTOR");
			break;	
		case SCSPELLTAG_SPELLSAVEDC:
			return GetLocalInt(oTarget, sPrefix+"SPELLSAVEDC");
			break;
		case SCSPELLTAG_SPELLRESISTDC:
			return GetLocalInt(oTarget, sPrefix+"SPELLRESISTDC");
			break;
		case SCSPELLTAG_ENDINGROUND:
			return GetLocalInt(oTarget, sPrefix+"ENDINGROUND");
			break;
		case SCSPELLTAG_SPELLSCHOOL:
			return GetLocalInt(oTarget, sPrefix+"SPELLSCHOOL");
			break;
		case SCSPELLTAG_SPELLDISPELDC:
			return GetLocalInt(oTarget, sPrefix+"SPELLDISPELDC");
			break;
	}
	return -1;
	
}

/**
* Returns a string value for the specific named element on a AOE
* @param iTagElement
* @param oTarget  The Target of the current spell
* @param iSpellId The Spellid for the current spell, if -1 it will use the engine default or the value set in the precast
* @return
* @see
* @replaces
*/
string CSLGetTargetTagString( int iTagElement, object oTarget = OBJECT_SELF, int iSpellId = -1 )
{
	string sPrefix = "SC_"+IntToString(iSpellId)+"_";
	
	if ( iSpellId == -1 || ( GetLocalInt(oTarget, sPrefix+"SPELLID") == 0 && iSpellId != 0 ) ) // logically spell row 0 won't have to be dealt with since it's an AOE
	{
		// it must be invalid
		if ( iTagElement ==  SCSPELLTAG_CASTERCLASS )
		{
			return "255";
		}
		else
		{
			return "-1";
		}
	}

	switch ( iTagElement )
	{
		case SCSPELLTAG_SPELLID:
			return GetLocalString(oTarget, sPrefix+"CASTERPOINTER");
			break;
		case SCSPELLTAG_SPELLDISPELDC:
			return GetLocalString(oTarget, sPrefix+"CASTERTAG");
			break;
		default:
			// not any class involved, return 255 for invalid we'll deal with it in the failover code in each script
			return IntToString( CSLGetTargetTagInt( iTagElement, oTarget, iSpellId ) );
	}
	return "-1";
}

//ALLEFFECTS 0
//MAGICALEFFECTS 1
//ENCHANTMENTEFFECTS 2
string CSLGetDelimitedEffectsOnTarget( object oTarget, int iEffectCategory = 1 )
{
	object oTable = CSLDataObjectGet( "spells" );
	int iValidForDispel, iSpellId, iSpellLevel, iSpellSubtype,iSpellSchool;
	string sList0,sList1,sList2,sList3,sList4,sList5,sList6,sList7,sList8,sList9,sList10,sSpellId = ""; 
	
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect) )
	{
		iSpellId = GetEffectSpellId(eEffect);
		if ( iSpellId > -1 ) // ignore negative spell effect id's used for marking targets and the like
		{
			iValidForDispel = FALSE;
			iSpellLevel = CSLGetTargetTagInt( SCSPELLTAG_SPELLLEVEL, oTarget, iSpellId ); // get a value for this that has been cached
			if ( iSpellLevel == -1 )
			{
				iSpellLevel = StringToInt( CSLDataTableGetStringByRow( oTable, "Innate", iSpellId ) );
			}	
			iSpellSubtype = GetEffectSubType(eEffect);		
			
			if ( iEffectCategory == 0 )
			{
				iValidForDispel = TRUE;
			}
			else if ( iEffectCategory == 1 && iSpellSubtype == SUBTYPE_MAGICAL ) 
			{
				iValidForDispel = TRUE;
			}
			else if ( iEffectCategory == 2 && iSpellSubtype == SUBTYPE_MAGICAL ) 
			{
				iSpellSchool = CSLGetTargetTagInt( SCSPELLTAG_SPELLSCHOOL, oTarget, iSpellId);
				if ( iSpellSchool == SPELL_SCHOOL_ENCHANTMENT || iSpellSchool == SPELL_SCHOOL_TRANSMUTATION )
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
				
			if ( iValidForDispel == TRUE )
			{
				sSpellId = IntToString(iSpellId);
				switch( iSpellLevel )
				{
					case 0:
						sList0 = CSLNth_Push(sList0, sSpellId, ",", TRUE );
						break;
					case 1:
						sList1 = CSLNth_Push(sList1, sSpellId, ",", TRUE );
						break;
					case 2:
						sList2 = CSLNth_Push(sList2, sSpellId, ",", TRUE );
						break;
					case 3:
						sList3 = CSLNth_Push(sList3, sSpellId, ",", TRUE );
						break;
					case 4:
						sList4 = CSLNth_Push(sList4, sSpellId, ",", TRUE );
						break;
					case 5:
						sList5 = CSLNth_Push(sList5, sSpellId, ",", TRUE );
						break;
					case 6:
						sList6 = CSLNth_Push(sList6, sSpellId, ",", TRUE );
						break;
					case 7:
						sList7 = CSLNth_Push(sList7, sSpellId, ",", TRUE );
						break;
					case 8:
						sList8 = CSLNth_Push(sList8, sSpellId, ",", TRUE );
						break;
					case 9:
						sList9 = CSLNth_Push(sList9, sSpellId, ",", TRUE );
						break;
					case 10:
						sList10 = CSLNth_Push(sList10, sSpellId, ",", TRUE );
						break;
					default: // defaulting, just push to the end
						sList0 = CSLNth_Push(sList0, sSpellId, ",", TRUE );
						break;
				}
			}
		}
		eEffect = GetNextEffect(oTarget);
	}
	
	return CSLNth_Merge(sList10, ",",sList9,sList8,sList7,sList6,sList5,sList4,sList3,sList2,sList1,sList0 );

}


/*
// Set eEffect to be versus a specific alignment.
// - eEffect
// - nLawChaos: ALIGNMENT_LAWFUL/ALIGNMENT_CHAOTIC/ALIGNMENT_ALL
// - nGoodEvil: ALIGNMENT_GOOD/ALIGNMENT_EVIL/ALIGNMENT_ALL
//
//	The following is a list of the effect types that can be modified by this constructor:
//	Attack Increase
//	Attack Decrease
//	Damage Increase
//	Damage Decrease
//	Sanctuary
//	Invisibility
//	Concealment
//	Damage Resistance
//	Damage Reduction (NWN1)
//	Immunity Increase
//	Immunity Decrease
//	Immunity
//	AC Increase
//	AC Decrease
//	Spell Resistance Incease
//	Spell Resistance Decrease
//	Saving Throw Increase
//	Saving Throw Decrease
//	Skill Incease
//	Skill Decrease
//	
//	Be advised that this is the COMPREHENSIVE list!  Other effect types will not
//	be modified, even if you pass a valid effect as the first parameter!///
effect VersusAlignmentEffect(effect eEffect, int nLawChaos=ALIGNMENT_ALL, int nGoodEvil=ALIGNMENT_ALL);

// Set eEffect to be versus nRacialType.
// - eEffect
// - nRacialType: RACIAL_TYPE_*
effect VersusRacialTypeEffect(effect eEffect, int nRacialType);

// Set eEffect to be versus traps.
effect VersusTrapEffect(effect eEffect);



// - nFeat: FEAT_*
// - oObject
// * Returns TRUE if oObject has effects on it originating from nFeat.
int GetHasFeatEffect(int nFeat, object oObject=OBJECT_SELF);



// Create a Damage Over Time (DOT) effect.
// - nAmount: amount of damage to be taken per time interval
// - fIntervalSeconds: length of interval in seconds
// - iDamageType: DAMAGE_TYPE_*
// - nIgnoreResistances: FALSE will use damage immunity, damage reduction, and damage resistance.  TRUE will skip all of these.
effect EffectDamageOverTime(int nAmount, float fIntervalSeconds, int iDamageType=DAMAGE_TYPE_MAGICAL, int nIgnoreResistances=FALSE);

// JLR-OEI 04/11/06 
// Returns the value of the given integer in the given Effect
int GetEffectInteger( effect eTest, int nIdx );

// JLR-OEI 04/11/06 
// Resets the durations for all effects from a given SpellId
void RefreshSpellEffectDurations( object oTarget, int iSpellId, float fDuration );

// JLR-OEI 04/11/06 
// Sets the SpellId associated with a given effect and all effects chained to it
effect SetEffectSpellId( effect eTest, int iSpellId );

// JLR-OEI 04/12/06 
// Creates a BaseAttackBonus Minimum effect
effect EffectBABMinimum( int nBABMin );

ginc_effect

// ginc_effect
/// *
//	Effects related constants and functions
//
//	Note that many of these effects are temporary.  I would not count on the SP_ effects
//	and TESTSEF effects in particular to persist until ship time, so keep that in mind. -EPF//* /
// ChazM 10/03/05	
// EPF 10/3/05
// ChazM 10/03/05 added CreateBeam(), VoidCreateBeam(), changed include file
// ChazM 10/04/05 added Note on SEF's and the nBodyPart param
// BMA-OEI 7/04/06 -- Added GetHasEffectType(), RemoveEffectByType()
// ChazM 6/22/07 -- Added Subtype supprot to GetHasEffectType(), RemoveEffectByType()

#include "ginc_param_const"

//void main (){}
	
//For reference, here are the prototypes for the related functions in nwscript.nss:
/// *
//RWT-OEI 05/31/05
//This function creates a Special Effects File effect that can
//then be applied to an object or a location
//For effects that just need a single location (or source object),
//such as particle emitters, the source loc or object comes from
//using AttachEffectToObject and AttachEffectToLocation
//For Point-to-Point effects, like beams and lightning, oTarget
//is the target object for the other end of the effect. If oTarget
//is OBJECT_INVALID, then the position located in vTargetPosition
//is used instead. 
//effect EffectNWN2SpecialEffectFile( string sFileName, object oTarget=OBJECT_INVALID, vector vTargetPosition=[0.0,0.0,0.0]  );
//
//	
//RWT-OEI 06/07/05
//This function removes 1 instance of a SEF from an object. Since
//an object can only have 1 instance of a specific SEF running on it
//at once, this should effectively remove 'all' instances of the
//specified SEF from the object
// void RemoveSEFFromObject( object oObject, string sSEFName );
//  * /

/// *
// Note on SEF's and the nBodyPart param:
// The nBodyPart piece has been moved to the .SEF file.  
// The SEF file can be used to specify which attachment points the beam should
// connect to on both the source and the target. 
// * //	
	
//Durations below this number specified in the effect applying functions will be treated as 0,
//which we take to mean you want to apply an effect permanently
const float MY_EPSILON = 0.001;

const string BLOODSPURT		= "bloodspurt.sef";
const string FX_ALTARGEN 	= "fx_altargen.sef";
const string FX_BLACK_COULD	= "fx_black_cloud.sef";
const string FX_CANDLE		= "fx_candle.sef";
const string FX_DUST 		= "fx_dust.sef";
const string FX_FIREFLIES	= "fx_fireflies.sef";
const string FX_FIREPLACE	= "fx_fireplace.sef";
const string FX_FIRE_LG		= "fx_fire_lg.sef";
const string FX_FIRE_LG_BLUR	= "fx_fire_lg_blur.sef";
const string FX_FIRE_SMOKE	= "fx_fire_smoke.sef";
const string FX_FOG_LG		= "fx_fog_lg.sef";
const string FX_LAMPGLOW	= "fx_lampglow.sef";
const string FX_LOOTBAG		= "fx_lootbag.sef";
const string FX_SPLASH		= "fx_splash.sef";
const string FX_SPLASH2		= "fx_splash2.sef";
const string FX_TORCH_BLUE	= "fx_torch_blue.sef";
const string FX_TORCHGLOW	= "fx_torchglow.sef";
const string FX_VOID		= "fx_void.sef";
const string SP_ATK_MISSILE	= "sp_atk_missile.sef";
const string SP_BLESS		= "sp_bless.sef";
const string SP_CURE_CRITICAL	= "sp_cure_critical.sef";
const string SP_CURE_LIGHT	= "sp_cure_light.sef";
const string SP_FIREBALL	= "sp_fireball.sef";
const string SP_MAGICMISSILE = "sp_magicmissile.sef";
const string SP_RAYFROST	= "sp_rayfrost.sef";



// ** FUNCTION DECLARATIONS ** 

// SEF effect functions
// ** For all below functions, Duration of 0 means effect is permanent. **
void ApplySEFToLocation(string sEffectFile, location lLoc, float fDuration = 0.f);
void ApplySEFToObject(string sEffectFile, object oTarget, float fDuration = 0.f);
void ApplySEFToObjectByTag(string sEffectFile, string sTag, float fDuration = 0.f);
void ApplySEFToWP(string sEffectFile, string sWPTag, float fDuration = 0.f);

//SEF goes to all WPs of tag sWPTag
void ApplySEFToWPs(string sEffectFile, string sWPTag, float fDuration = 0.f);
void RemoveSEFFromWP(string sEffectFile, string sWPTag );

//SEF removed from all WPs of tag sWPTag
void RemoveSEFFromWPs(string sEffectFile, string sWPTag );

// Other effect functions
effect CreateBeam(int iBeamVisualEffect, object oSource, object oTarget, int iDurationType=DURATION_TYPE_PERMANENT, 
		float fDuration = 0.0f, int nBodyPart = BODY_NODE_CHEST, int bMissEffect = FALSE);
void VoidCreateBeam(int iBeamVisualEffect, object oSource, object oTarget, int iDurationType=DURATION_TYPE_PERMANENT,
        float fDuration = 0.0f, int nBodyPart = BODY_NODE_CHEST, int bMissEffect = FALSE);
		
// Return TRUE, if oObject is affected by effect type nEffectType
//int GetHasEffectType( object oObject, int nEffectType );
int GetHasEffectType( object oObject, int nEffectType, int nEffectSubType=0 );

// Removes all effects from oObject matching effect type nEffectType
// Returns number of matching effects removed
//int RemoveEffectsByType( object oObject, int nEffectType );
int RemoveEffectsByType( object oObject, int nEffectType, int nEffectSubType=0 );



void ApplySEFToLocation(string sEffectFile, location lLoc, float fDuration = 0.f)
{
	if(fDuration < MY_EPSILON)
	{
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sEffectFile), lLoc);
	}
	else
	{
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sEffectFile), lLoc, fDuration);
	}
}

void ApplySEFToObject(string sEffectFile, object oTarget, float fDuration = 0.f)
{
	if(fDuration < MY_EPSILON)
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sEffectFile), oTarget);
	}
	else
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sEffectFile), oTarget, fDuration);
	}
}
	
void ApplySEFToObjectByTag(string sEffectFile, string sTag, float fDuration = 0.f)
{
	if(fDuration < MY_EPSILON)
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sEffectFile), GetTarget(sTag));
	}
	else
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sEffectFile), GetTarget(sTag), fDuration);
	}
}

void ApplySEFToWP(string sEffectFile, string sWPTag, float fDuration = 0.f)
{
	if(fDuration < MY_EPSILON)
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sEffectFile), GetTarget(sWPTag));
	}
	else
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sEffectFile), GetTarget(sWPTag), fDuration);
	}
}

void ApplySEFToWPs(string sEffectFile, string sWPTag, float fDuration = 0.f)
{
	object oWP = GetObjectByTag(sWPTag);
	int i = 1;

	while(GetIsObjectValid(oWP))
	{
		if(fDuration < MY_EPSILON)
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile(sEffectFile), GetTarget(sWPTag));
		}
		else
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sEffectFile), GetTarget(sWPTag), fDuration);
		}
		oWP = GetObjectByTag(sWPTag,i);
		i++;
	}
}



void RemoveSEFFromWP(string sEffectFile, string sWPTag )
{
	RemoveSEFFromObject( GetTarget(sWPTag), sEffectFile );
}


void RemoveSEFFromWPs(string sEffectFile, string sWPTag )
{
	object oWP = GetObjectByTag(sWPTag);
	int i = 1;

	while(GetIsObjectValid(oWP))
	{
		RemoveSEFFromObject(oWP, sEffectFile);
		oWP = GetObjectByTag(sWPTag,i);
		i++;
	}
}


// create a beam between two objects
effect CreateBeam(int iBeamVisualEffect, object oSource, object oTarget, int iDurationType=DURATION_TYPE_PERMANENT, 
		float fDuration = 0.0f, int nBodyPart = BODY_NODE_CHEST, int bMissEffect = FALSE)
{
    effect eBeam = EffectBeam(iBeamVisualEffect, oSource, nBodyPart);
    ApplyEffectToObject(iDurationType, eBeam, oTarget, fDuration);
	return (eBeam);
}

void VoidCreateBeam(int iBeamVisualEffect, object oSource, object oTarget, int iDurationType=DURATION_TYPE_PERMANENT,
        float fDuration = 0.0f, int nBodyPart = BODY_NODE_CHEST, int bMissEffect = FALSE)
{
    CreateBeam(iBeamVisualEffect, oSource, oTarget, iDurationType,
         fDuration, nBodyPart, bMissEffect);
}

// Return TRUE, if oObject is affected by effect type nEffectType
// Effects of a specific subtype can be specified, or 0 to ignore subtype
int GetHasEffectType( object oObject, int nEffectType, int nEffectSubType=0 )
{
	effect eEffect = GetFirstEffect( oObject );
	while ( GetIsEffectValid(eEffect) == TRUE )
	{
		if ( GetEffectType(eEffect) == nEffectType )
		{
			if ((nEffectSubType == 0)  || (GetEffectSubType(eEffect) == nEffectSubType))
				return ( TRUE );
		}
		eEffect = GetNextEffect( oObject );
	} 
	
	return ( FALSE );
}

// Removes all effects from oObject matching effect type nEffectType
// Returns number of matching effects removed
// Effects of a specific subtype can be specified, or 0 to ignore subtype
int RemoveEffectsByType( object oObject, int nEffectType, int nEffectSubType=0 )
{
	int nCount = 0;
	effect eEffect = GetFirstEffect( oObject );
	while ( GetIsEffectValid(eEffect) == TRUE )
	{
		if ( GetEffectType(eEffect) == nEffectType )
		{
			if ((nEffectSubType == 0)  || (GetEffectSubType(eEffect) == nEffectSubType))
			{
				nCount = nCount + 1;
				RemoveEffect( oObject, eEffect );
			}				
			// eEffect = GetFirstEffect( oObject );
		}
		else
		{
			// eEffect = GetNextEffect( oObject );
		}
		eEffect = GetNextEffect( oObject );
	}
	
	return ( nCount );
}



*/

/////These are being worked on for a future system, using what jailiax did for something that is more like a utility
////// a system derived from jailiax to serialize, queue, restore, save and basically copy a spell from being cast into something which is more portable
////// being used to create database storage, delayed casting of spells, proxy casting of spells, and spell redirection

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////
/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Structure that holds informations about a spellcasting action
/*
struct csl_action_castspell
{
	int iActionId;
	int iSpellId;
	object oTarget;
	location lTarget;
	int iCasterLevel;
	int iMetaMagicFeat;
	int iSpellSaveDC;
	int iClass;
	int bPreRoundAction;
};
*/

/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Structure that holds informations about a spellcasting action
/*
struct csl_action_castspell
{
	int iActionId;
	int iSpellId;
	object oTarget;
	location lTarget;
	int iCasterLevel;
	int iMetaMagicFeat;
	int iSpellSaveDC;
	int iClass;
	int bPreRoundAction;
};
*/

/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Transform a spellcasting action structure into a string
// - actionCastSpell Spellcasting action in strucure form
// * Returns the spellcasting action in string form
// JXActionCastSpellToString
/*
string CSLSerializeActionCastSpell(struct csl_action_castspell actionCastSpell)
{
	string sAction = IntToString( actionCastSpell.iActionId);
	sAction += ";" + IntToString( actionCastSpell.iSpellId);
	sAction += ";" + IntToString(ObjectToInt( actionCastSpell.oTarget));
	sAction += ";" + CSLSerializeLocation( actionCastSpell.lTarget);
	sAction += ";" + IntToString( actionCastSpell.iCasterLevel);
	sAction += ";" + IntToString( actionCastSpell.iMetaMagicFeat);
	sAction += ";" + IntToString( actionCastSpell.iSpellSaveDC);
	sAction += ";" + IntToString( actionCastSpell.iClass);
	sAction += ";" + IntToString( actionCastSpell.bPreRoundAction);

	return sAction;
}
*/

// Transform a spell being cast into a string, storing it's specific properties
// - actionCastSpell Spellcasting action in strucure form
// * Returns the spellcasting action in string form
// JXActionCastSpellToString
/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLSerializeSpell( int iSpellId, int iCasterLevel = -1, int iMetaMagic = METAMAGIC_NONE, int iSpellPower = -1, int iSaveDC = -1, int iDescriptor = SCMETA_DESCRIPTOR_NONE, int iClass = CLASS_TYPE_NONE, int iSpellLevel = -1, int iSpellSchool = SPELL_SCHOOL_NONE, int iSpellSubSchool = SPELL_SUBSCHOOL_NONE )
{
	string sSpell = "#SPL#"+IntToString(iSpellId);
	
	if ( iCasterLevel != -1 )
	{
		sSpell += "#LV#"+IntToString(iCasterLevel);
	}
	
	if ( iMetaMagic != METAMAGIC_NONE )
	{
		sSpell += "#MM#"+IntToString(iMetaMagic);
	}
	
	if ( iSpellPower != -1 )
	{
		sSpell += "#PW#"+IntToString(iSpellPower);
	}
	
	if ( iDescriptor != SCMETA_DESCRIPTOR_NONE )
	{
		sSpell += "#DE#"+IntToString(iDescriptor);
	}
	
	if ( iClass != CLASS_TYPE_NONE )
	{
		sSpell += "#CL#"+IntToString(iClass);
	}
	
	if ( iSaveDC != SCMETA_DESCRIPTOR_NONE )
	{
		sSpell += "#SV#"+IntToString(iSaveDC);
	}
	
	if ( iSpellLevel != -1 )
	{
		sSpell += "#SL#"+IntToString(iSpellLevel);
	}
	
	if ( iSpellSchool != SPELL_SCHOOL_NONE )
	{
		sSpell += "#SS#"+IntToString(iSpellSchool);
	}
	
	if ( iSpellSubSchool != SPELL_SUBSCHOOL_NONE )
	{
		sSpell += "#SU#"+IntToString(iSpellSubSchool);
	}

		
	return sSpell;	
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLUnserializeSpell(string sSpell, object oTarget = OBJECT_INVALID )
{
	string sSpellId = CSLUnserializeByHashValue( sSpell, "#SPL#" );
	if ( sSpellId != "" )
	{
		int iSpellId = StringToInt( sSpellId );
		int iCasterLevel = StringToInt( CSLUnserializeByHashValue( sSpell, "#LV#", "-1"));
		int iMetaMagic = StringToInt( CSLUnserializeByHashValue( sSpell, "#MM#","0"));
		int iSpellPower = StringToInt( CSLUnserializeByHashValue( sSpell, "#PW#","-1"));
		int iSaveDC = StringToInt( CSLUnserializeByHashValue( sSpell, "#SV#","-1"));
		int iDescriptor = StringToInt( CSLUnserializeByHashValue( sSpell, "#DE#","0"));
		int iClass = StringToInt( CSLUnserializeByHashValue( sSpell, "#CL#","255"));
		int iSpellLevel = StringToInt( CSLUnserializeByHashValue( sSpell, "#SL#","-1"));
		int iSpellSchool = StringToInt( CSLUnserializeByHashValue( sSpell, "#SS#","0"));
		int iSpellSubSchool = StringToInt( CSLUnserializeByHashValue( sSpell, "#SU#","0"));
		
		
		
		if ( iSaveDC != -1 )
		{
			SetLocalInt( oTarget, "HKTEMP_Save_DC", iSaveDC );
		}
		
		if ( iClass != CLASS_TYPE_NONE )
		{
			SetLocalInt( oTarget, "HKTEMP_Class", iClass );
		}
		
		if ( iSpellId != -1 )
		{
			SetLocalInt( oTarget, "HKTEMP_SpellId", iSpellId );
		}
		
		if ( iSpellLevel != -1 )
		{
			SetLocalInt( oTarget, "HKTEMP_SpellLevel", iSpellLevel );
		}
		
		if ( iDescriptor != SCMETA_DESCRIPTOR_NONE )
		{
			SetLocalInt( oTarget, "HKTEMP_Descriptor", iDescriptor );
		}
		
		if ( iSpellSchool != SPELL_SCHOOL_NONE )
		{
			SetLocalInt( oTarget, "HKTEMP_School", iSpellSchool );
		}
		
		if ( iSpellSubSchool != SPELL_SUBSCHOOL_NONE )
		{
			SetLocalInt( oTarget, "HKTEMP_SubSchool", iSpellSubSchool );
		}
		
		if ( iCasterLevel != -1 )
		{
			SetLocalInt( oTarget, "HKTEMP_CasterLevel", iCasterLevel );
		}
		
		if ( iSpellPower != -1 )
		{
			SetLocalInt( oTarget, "HKTEMP_Spell_Power", iSpellPower );
		}
		
		if ( iMetaMagic != METAMAGIC_NONE )
		{
			SetLocalInt( oTarget, "HKTEMP_Spell_MetaMagic", iMetaMagic );
		}
		return iSpellId;
	}

    return -1;
}



/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Transform a spellcasting action string into a structure 
// - actionCastSpell Spellcasting action in string form
// * Returns the spellcasting action in strucure form
// JXStringToActionCastSpell
/*
struct csl_action_castspell CSLUnserializeActionCastSpell(string sActionCastSpell)
{
	struct csl_action_castspell actionCastSpell;
	actionCastSpell.iActionId = StringToInt(CSLNth_GetNthElement(sActionCastSpell, 1, ";"));
	actionCastSpell.iSpellId = StringToInt(CSLNth_GetNthElement(sActionCastSpell, 2, ";"));
	actionCastSpell.oTarget = IntToObject(StringToInt(CSLNth_GetNthElement(sActionCastSpell, 3, ";")));
	actionCastSpell.lTarget = CSLUnserializeLocation(CSLNth_GetNthElement(sActionCastSpell, 4, ";"));
	actionCastSpell.iCasterLevel = StringToInt(CSLNth_GetNthElement(sActionCastSpell, 5, ";"));
	actionCastSpell.iMetaMagicFeat = StringToInt(CSLNth_GetNthElement(sActionCastSpell, 6, ";"));
	actionCastSpell.iSpellSaveDC = StringToInt(CSLNth_GetNthElement(sActionCastSpell, 7, ";"));
	actionCastSpell.iClass = StringToInt(CSLNth_GetNthElement(sActionCastSpell, 8, ";"));
	actionCastSpell.bPreRoundAction = StringToInt(CSLNth_GetNthElement(sActionCastSpell, 9, ";"));

	return actionCastSpell;
}
*/


/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Override the spellcasting action that is about to be added to the queue
// - actionCastSpell Informations about the action to enqueue
// - oCreature Creature for whom the action must be added to the queue
/*
void JXOverrideAddedActionCastSpell(struct csl_action_castspell actionCastSpell, object oCreature)
{
	string sAction = CSLSerializeActionCastSpell(actionCastSpell);	
	SetLocalString(oCreature, "JX_ACTION_CASTSPELL_OVERRIDE", sAction);
}
*/

/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Enqueue a new spellcasting action in the action queue
// - actionCastSpell Informations about the action to enqueue
// - oCreature Creature for whom the action must be added to the queue
// * Returns TRUE if the action has been successfully added to the queue
/*
int JXAddActionCastSpellToQueue(struct csl_action_castspell actionCastSpell, object oCreature)
{
	
	// Fire the spellcasting action enqueued event
	if (JXEventActionCastSpellEnqueued(oCreature, actionCastSpell.iSpellId, actionCastSpell.oTarget,  GetIsObjectValid(actionCastSpell.oTarget) ? GetLocation(actionCastSpell.oTarget) : actionCastSpell.lTarget,  actionCastSpell.iCasterLevel, actionCastSpell.iMetaMagicFeat, actionCastSpell.iSpellSaveDC, actionCastSpell.iClass))
	{
		int iCountActions = GetLocalInt(oCreature, "JX_ACTION_CASTSPELL_COUNT") + 1;
		SetLocalInt(oCreature, "JX_ACTION_CASTSPELL_COUNT", iCountActions);

		// Save the overriden action if it exists
		string sAction = GetLocalString(oCreature, "JX_ACTION_CASTSPELL_OVERRIDE");
		if (sAction != "")
		{
			SetLocalString(oCreature, "JX_ACTION_CASTSPELL_" + IntToString(iCountActions), sAction);
			DeleteLocalString(oCreature, "JX_ACTION_CASTSPELL_OVERRIDE");
		}
		else
		{
			sAction = CSLSerializeActionCastSpell(actionCastSpell);
			SetLocalString(oCreature, "JX_ACTION_CASTSPELL_" + IntToString(iCountActions), sAction);
		}

		return TRUE;
	}
	else
	{
		return FALSE;
	}	
	
	return FALSE;
}
*/

// This event is fired when a spellcasting action is finished
// - oCaster Caster of the spell
// - iSpellId SPELL_* constant
// - oTarget Target object of the spell (may be OBJECT_INVALID)
// - lTarget Target location of the spell (location of oTarget if oTarget is valid)
// - iCasterLevel Caster level for the spell
// - iMetaMagicFeat MetaMagic feat for the spell
// - iSpellSaveDC Save DC for the spell
// - iClass Class used to cast the spell
// - bResult FALSE if the spellcasting action hasn't been performed successfully
/*
void JXEventActionCastSpellFinished(object oCaster, int iSpellId, object oTarget, location lTarget, int iCasterLevel, int iMetaMagicFeat, int iSpellSaveDC, int iClass, int bResult)
{
	struct script_param_list paramList;
	paramList = JXScriptAddParameterObject(paramList, oCaster);
	paramList = JXScriptAddParameterInt(paramList, iSpellId);
	paramList = JXScriptAddParameterObject(paramList, oTarget);
	paramList = JXScriptAddParameterLocation(paramList, lTarget);
	paramList = JXScriptAddParameterInt(paramList, iCasterLevel);
	paramList = JXScriptAddParameterInt(paramList, iMetaMagicFeat);
	paramList = JXScriptAddParameterInt(paramList, iSpellSaveDC);
	paramList = JXScriptAddParameterInt(paramList, iClass);
	paramList = JXScriptAddParameterInt(paramList, bResult);

	JXScriptCallFork(JX_SPFMWK_FORKSCRIPT, JX_FORK_EVENTSPELLFINISHED, paramList);
}
*/

/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Remove the first (current) spellcasting action from the queue
// - iActionId Only remove the action from the queue if it has the specified action identifier
// - bResult Indicate if the action was performed successfully or not
// - oCreature Creature for whom the action must be removed from the queue
/*
void JXRemoveFirstActionCastSpellFromQueue(int bResult, int iActionId, object oCreature)
{
	string sAction = GetLocalString(oCreature, "JX_ACTION_CASTSPELL_1");
	struct csl_action_castspell actionCastSpell = CSLUnserializeActionCastSpell(sAction);
	if ((iActionId == 0) || (actionCastSpell.iActionId == iActionId))
	{
		// Fire the spellcasting action finished event
		
		// JXEventActionCastSpellFinished(oCreature, actionCastSpell.iSpellId,  actionCastSpell.oTarget GetIsObjectValid(actionCastSpell.oTarget) ? GetLocation(actionCastSpell.oTarget) : actionCastSpell.lTarget,  actionCastSpell.iCasterLevel,actionCastSpell.iMetaMagicFeat, actionCastSpell.iSpellSaveDC,  actionCastSpell.iClass, bResult);
									   
	
		// Move the actions that are after the removed spell
		int iCountActions = GetLocalInt(oCreature, "JX_ACTION_CASTSPELL_COUNT");
		int iLoopPos;
		for (iLoopPos = 1; iLoopPos < iCountActions; iLoopPos++)
		{
			SetLocalString(oCreature, "JX_ACTION_CASTSPELL_" + IntToString(iLoopPos),
			 GetLocalString(oCreature, "JX_ACTION_CASTSPELL_" + IntToString(iLoopPos + 1)));
		}
		DeleteLocalString(oCreature, "JX_ACTION_CASTSPELL_" + IntToString(iCountActions));
	
		// Update the action counter
		SetLocalInt(oCreature, "JX_ACTION_CASTSPELL_COUNT", iCountActions - 1);
	}
}
*/

/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Get informations about a spellcasting action currently in the queue
// - iPos Position of the action in the queue (starts at 1)
// - oCreature Creature for whom the action must be get
// * Returns informations about the specified action
/*
struct csl_action_castspell JXGetActionCastSpellFromQueue(int iPos, object oCreature)
{
	string sAction = GetLocalString(oCreature, "JX_ACTION_CASTSPELL_" + IntToString(iPos));

	return CSLUnserializeActionCastSpell(sAction);
}
*/

/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Remove all spellcasting actions from the queue
// - oCreature Creature for whom the actions must be removed from the queue
/*
void JXClearActionQueue(object oCreature)
{
	// Remove all the spellcasting actions from the queue
	int iCountActions = GetLocalInt(oCreature, "JX_ACTION_CASTSPELL_COUNT");
	int iLoopPos;
	for (iLoopPos = 1; iLoopPos <= iCountActions; iLoopPos++)
	{
		// Fire the spellcasting action finished event
		string sAction = GetLocalString(oCreature, "JX_ACTION_CASTSPELL_" + IntToString(iLoopPos));
		struct csl_action_castspell actionCastSpell = CSLUnserializeActionCastSpell(sAction);
		
		//JXEventActionCastSpellFinished(oCreature,   actionCastSpell.iSpellId,   actionCastSpell.oTarget,GetIsObjectValid(actionCastSpell.oTarget) ? GetLocation(actionCastSpell.oTarget) : actionCastSpell.lTarget, actionCastSpell.iCasterLevel, actionCastSpell.iMetaMagicFeat, actionCastSpell.iSpellSaveDC,  actionCastSpell.iClass,  FALSE);
		
		DeleteLocalString(oCreature, "JX_ACTION_CASTSPELL_" + IntToString(iLoopPos));
	}
	DeleteLocalInt(oCreature, "JX_ACTION_CASTSPELL_COUNT");
}
*/
/**  
* Description
* @author
* @param 
* @see 
* @todo rewrite this, it comes from jailiax's framework which needs to be integrated in
* @return 
*/
// Count the number of spellcasting actions currently in the queue
// - oCreature Creature with an action queue
// * Returns the number of actions in the queue
/*
int JXCountActionsInQueue(object oCreature)
{
	return GetLocalInt(oCreature, "JX_ACTION_CASTSPELL_COUNT");
}
*/


/**
 * Determines and applies the alignment shift for using spells/powers with the
 * [Evil] descriptor.  The amount of adjustment is equal to the square root of
 * the caster's distance from pure evil.
 * In other words, the amount of shift is higher the farther the caster is from
 * pure evil, with the extremes being 10 points of shift at pure good and 0
 * points of shift at pure evil.
 *
 * Does nothing if the PRC_SPELL_ALIGNMENT_SHIFT switch is not set.
 *
 * @param oPC The caster whose alignment to adjust
 * @replaces SPEvilShift
 */
void CSLSpellEvilShift(object oPC)
{
    // Check for alignment shift switch being active
    if(CSLGetPreferenceSwitch("SpellAlignmentSwitch"))
    {
        // Amount of adjustment is equal to the square root of your distance from pure evil.
        // In other words, the amount of shift is higher the farther you are from pure evil, with the
        // extremes being 10 points of shift at pure good and 0 points of shift at pure evil.
        AdjustAlignment(oPC, ALIGNMENT_EVIL,  FloatToInt(sqrt(IntToFloat(GetGoodEvilValue(oPC)))));
    }
}

/**
 * Determines and applies the alignment shift for using spells/powers with the
 * [Good] descriptor.  The amount of adjustment is equal to the square root of
 * the caster's distance from pure good.
 * In other words, the amount of shift is higher the farther the caster is from
 * pure good, with the extremes being 10 points of shift at pure evil and 0
 * points of shift at pure good.
 *
 * Does nothing if the PRC_SPELL_ALIGNMENT_SHIFT switch is not set.
 *
 * @param oPC The caster whose alignment to adjust
  * @replaces SPGoodShift
 */

void CSLSpellGoodShift(object oPC)
{
    // Check for alignment shift switch being active
    if(CSLGetPreferenceSwitch("SpellAlignmentSwitch"))
    {
        // Amount of adjustment is equal to the square root of your distance from pure good.
        // In other words, the amount of shift is higher the farther you are from pure good, with the
        // extremes being 10 points of shift at pure evil and 0 points of shift at pure good.
        AdjustAlignment(oPC, ALIGNMENT_GOOD, FloatToInt(sqrt(IntToFloat(100 - GetGoodEvilValue(oPC)))));
    }
}


void DMFI_CreateEffect(string sCommand, string sParam1, object oPC, object oTarget)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_CreateEffect Start", oPC ); }
	//Purpose: Creates simple effects with no parameters
	// Original scripter: Demetrious
	// Last Modified by:  Demetrious 8/16/6
	int bNumber;
	float fTime;
	effect eEffect;

	if (FindSubString(sCommand, "bli"))  eEffect = EffectBlindness();
	else if (FindSubString(sCommand, "cha"))  eEffect = EffectCharmed();
	else if (FindSubString(sCommand, "con"))  eEffect = EffectConfused();
	else if (FindSubString(sCommand, "cutscenedom"))  eEffect = EffectCutsceneDominated();
	else if (FindSubString(sCommand, "cutscenegho"))  eEffect = EffectCutsceneGhost();
	else if (FindSubString(sCommand, "cutsceneimm"))  eEffect = EffectCutsceneImmobilize();
	else if (FindSubString(sCommand, "cutscenepar"))  eEffect = EffectCutsceneParalyze();
	else if (FindSubString(sCommand, "dar"))  eEffect = EffectDarkness();
	else if (FindSubString(sCommand, "daz"))  eEffect = EffectDazed();
	else if (FindSubString(sCommand, "dea"))  eEffect = EffectDeaf();
	//else if (FindSubString(sCommand, "all"))  eEffect = EffectDispelMagicAll(); NWN2 edit
	//else if (FindSubString(sCommand, "best"))  eEffect = EffectDispelMagicBest(); NWN2 edit

	else if (FindSubString(sCommand, "dom"))  eEffect = EffectDominated();
	else if (FindSubString(sCommand, "ent"))  eEffect = EffectEntangle();
	else if (FindSubString(sCommand, "eth"))  eEffect = EffectEthereal();

	else if (FindSubString(sCommand, "fri"))  eEffect = EffectFrightened();
	else if (FindSubString(sCommand, "has"))  eEffect = EffectHaste();
	else if (FindSubString(sCommand, "kno"))  eEffect = EffectKnockdown();
	else if (FindSubString(sCommand, "par"))  eEffect = EffectParalyze();
	else if (FindSubString(sCommand, "pet"))  eEffect = EffectPetrify();
	else if (FindSubString(sCommand, "res"))  eEffect = EffectResurrection();
	else if (FindSubString(sCommand, "see"))  eEffect = EffectSeeInvisible();
	else if (FindSubString(sCommand, "sil"))  eEffect = EffectSilence();
	else if (FindSubString(sCommand, "sle"))  eEffect = EffectSleep();
	else if (FindSubString(sCommand, "slo"))  eEffect = EffectSlow();
	else if (FindSubString(sCommand, "stu"))  eEffect = EffectStunned();
	else if (FindSubString(sCommand, "tim"))  eEffect = EffectTimeStop();
	else if (FindSubString(sCommand, "tru"))  eEffect = EffectTrueSeeing();
	else if (FindSubString(sCommand, "tur"))  eEffect = EffectTurned();
	else if (FindSubString(sCommand, "ult"))  eEffect = EffectUltravision();

	if (GetIsEffectValid(eEffect))
	{
		bNumber = CSLGetIsNumber(sParam1);
		if (bNumber)
			fTime = StringToFloat(sParam1);
		else
			fTime = 30.0;
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fTime);
		SendMessageToPC(oPC, "DMFI Effect Applied: " + sCommand);
	}
	SendMessageToPC(oPC, "DMFI Effect not found.  Examine DMFI Tool for accurate list of effects.");
}

/** @file
* @brief Class related functions
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

#include "_CSLCore_Class_c"



/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCConstants"

#include "_CSLCore_Math"
#include "_CSLCore_Magic"
#include "_CSLCore_Config"

// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////


/*
//* Used to determine base classes for validation
int CSLGetBaseCasterType( int iClassId );

int CSLGetClassType( int iClass = 255 );

int CSLGetRogueLevel( object oCaster = OBJECT_SELF);
int CSLGetWildShapeLevel( object oCaster = OBJECT_SELF);

int CSLGetMainStatByClass( int iClass, string iType = "Spells" );
int CSLMaxSpellLevel( int iClass, int iClassLevel, object oCaster = OBJECT_SELF );
int CSLMaxSpellLevelByClass( int iClass, int iClassLevel );
int CSLGetClassBySpellId( object oCaster = OBJECT_SELF, int iSpellId = -1 );

int CSLGetProgrssionTable( int iClassId );

int CSLGetSpellLevelByDC(object oCaster, int iClass, int iSpellSaveDC);
int CSLGetBaseClassBasedOnPRC( int iClass, object oCaster = OBJECT_SELF );
string CSLGetClassesDataAbbrev(int iClass = 0);
string CSLClassToString(int iClass = 0, int bAbbr=FALSE);

string CSLClassLevels( object oPC, int bAbbrClass = FALSE, int bShowLevels = TRUE );
string CSLGetClassData(int nClassID, string sFld="");
*/

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


object oClassTable;
/**  
* Makes sure the oFeatTable is a valid pointer to the deities dataobject
* @author
* @see 
* @return 
*/
void CSLGetClassesDataObject()
{
	if ( !GetIsObjectValid( oClassTable ) )
	{
		oClassTable = CSLDataObjectGet( "classes" );
	}
	//return oSpellTable;
}


/**  
* Get the name of a Deity
* @param iDeityId Identifier of the Feat
* @return the name of the specified Deity
*/
string CSLGetClassesDataLabel(int iClassId)
{
	CSLGetClassesDataObject();
	if ( !GetIsObjectValid( oClassTable ) )
	{
		return Get2DAString("classes", "Label", iClassId);
	}
	return CSLDataTableGetStringByRow( oClassTable, "Label", iClassId );
}


/**  
* Get the name of a Deity
* @param iDeityId Identifier of the Feat
* @return the name of the specified Deity
*/
int CSLGetClassesDataFEATPracticedSpellcaster(int iClassId)
{
	CSLGetClassesDataObject();
	if ( !GetIsObjectValid( oClassTable ) )
	{
		return StringToInt(Get2DAString("classes", "FEATPracticedSpellcaster", iClassId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oClassTable, "FEATPracticedSpellcaster", iClassId ));
}


/**  
* Get the name of a Deity
* @param iDeityId Identifier of the Feat
* @return the name of the specified Deity
*/
string CSLGetClassesDataBonusCasterFeatByClassMap(int iClassId)
{
	CSLGetClassesDataObject();
	if ( !GetIsObjectValid( oClassTable ) )
	{
		return Get2DAString("classes", "BonusCasterFeatByClassMap", iClassId);
	}
	return CSLDataTableGetStringByRow( oClassTable, "BonusCasterFeatByClassMap", iClassId );
}

// other fields that might be of use here
// HasDivine,HasArcane,SpellAbil,MemorizesSpells,HasInfiniteSpells,AllSpellsKnown,HasDomains,Abbrev






string CSLGetClassesDataAbbrev(int iClass = 0)
{
	CSLGetClassesDataObject();
	string sString;
	if ( !GetIsObjectValid( oClassTable ) )
	{
		sString =  Get2DAString("classes", "Abbrev", iClass);
		if ( IntToString( StringToInt(sString) ) == sString )
		{
			string sResult=GetStringByStrRef(StringToInt(sString));
			if ( sResult != "" )
			{
				sString = CSLRemoveAllTags(sResult); // don't store any color information, if that is needed its likely larger fields which should not need it to begin with
			}
		}
		if ( sString != "" )
		{
			return sString;
		}
	}
	sString =  CSLDataTableGetStringByRow( oClassTable, "Abbrev", iClass );
	if ( sString != "" )
	{
		return sString;
	}
	
	// give up and do brute force, this is also in the 2da under the column Abbrev
	if (iClass==CLASS_TYPE_ABERRATION       ) return "AB";
	if (iClass==CLASS_TYPE_HUMANOID         ) return "HU";
	if (iClass==CLASS_TYPE_ANIMAL           ) return "AN";
	if (iClass==CLASS_TYPE_INVALID          ) return "IV";
	if (iClass==CLASS_TYPE_ARCANE_ARCHER    ) return "AA";
	if (iClass==CLASS_TYPE_INVISIBLE_BLADE  ) return "IB";
	if (iClass==CLASS_TYPE_ARCANE_SCHOLAR   ) return "AR";
	if (iClass==CLASS_TYPE_MAGICAL_BEAST    ) return "MB";
	if (iClass==CLASS_TYPE_ARCANETRICKSTER  ) return "AT";
	if (iClass==CLASS_TYPE_MONK             ) return "MK";
	if (iClass==CLASS_TYPE_ASSASSIN         ) return "AS";
	if (iClass==CLASS_TYPE_MONSTROUS        ) return "MO";
	if (iClass==CLASS_TYPE_BARBARIAN        ) return "BB";
	if (iClass==CLASS_TYPE_OOZE             ) return "OO";
	if (iClass==CLASS_TYPE_BARD             ) return "BD";
	if (iClass==CLASS_TYPE_OUTSIDER         ) return "OU";
	if (iClass==CLASS_TYPE_BEAST            ) return "BE";
	if (iClass==CLASS_TYPE_PALADIN          ) return "PA";
	if (iClass==CLASS_TYPE_BLACKGUARD       ) return "BG";
	if (iClass==CLASS_TYPE_PALEMASTER       ) return "PM";
	if (iClass==CLASS_TYPE_CLERIC           ) return "CL";
	if (iClass==CLASS_TYPE_RANGER           ) return "RA";
	if (iClass==CLASS_TYPE_COMMONER         ) return "CO";
	if (iClass==CLASS_TYPE_RED_WIZARD       ) return "RW";
	if (iClass==CLASS_TYPE_CONSTRUCT        ) return "CN";
	if (iClass==CLASS_TYPE_ROGUE            ) return "RO";
	if (iClass==CLASS_TYPE_DIVINECHAMPION   ) return "DC";
	if (iClass==CLASS_TYPE_SACREDFIST       ) return "SF";
	if (iClass==CLASS_TYPE_DRAGON           ) return "DR";
	if (iClass==CLASS_TYPE_SHADOWDANCER     ) return "SD";
	if (iClass==CLASS_TYPE_DRAGONDISCIPLE   ) return "RD";
	if (iClass==CLASS_TYPE_SHADOWTHIEFOFAMN ) return "ST";
	if (iClass==CLASS_TYPE_DRUID            ) return "DR";
	if (iClass==CLASS_TYPE_SHAPECHANGER     ) return "SC";
	if (iClass==CLASS_TYPE_DUELIST          ) return "DU";
	if (iClass==CLASS_TYPE_SHIFTER          ) return "SH";
	if (iClass==CLASS_TYPE_DWARVENDEFENDER  ) return "DD";
	if (iClass==CLASS_TYPE_SORCERER         ) return "SO";
	if (iClass==CLASS_TYPE_ELDRITCH_KNIGHT  ) return "EK";
	if (iClass==CLASS_TYPE_SPIRIT_SHAMAN    ) return "SS";
	if (iClass==CLASS_TYPE_ELEMENTAL        ) return "EL";
	if (iClass==CLASS_TYPE_STORMLORD        ) return "SL";
	if (iClass==CLASS_TYPE_FAVORED_SOUL     ) return "FS";
	if (iClass==CLASS_TYPE_UNDEAD           ) return "UD";
	if (iClass==CLASS_TYPE_FEY              ) return "FE";
	if (iClass==CLASS_TYPE_VERMIN           ) return "VE";
	if (iClass==CLASS_TYPE_FIGHTER          ) return "FI";
	if (iClass==CLASS_TYPE_WARLOCK          ) return "WA";
	if (iClass==CLASS_TYPE_FRENZIEDBERSERKER) return "FB";
	if (iClass==CLASS_TYPE_WARPRIEST        ) return "WP";
	if (iClass==CLASS_TYPE_GIANT            ) return "GI";
	if (iClass==CLASS_TYPE_WEAPON_MASTER    ) return "WM";
	if (iClass==CLASS_TYPE_HARPER           ) return "HS";
	if (iClass==CLASS_TYPE_WIZARD           ) return "WI";
	if (iClass==CLASS_HOSPITALER            ) return "HP";
	if (iClass==CLASS_WARRIOR_DARKNESS      ) return "WD";
	if (iClass==CLASS_BLADESINGER           ) return "BS";
	if (iClass==CLASS_STORMSINGER           ) return "SS";
	if (iClass==CLASS_TEMPEST               ) return "TM";
	if (iClass==CLASS_BLACK_FLAME_ZEALOT    ) return "BZ";
	if (iClass==CLASS_SHINING_BLADE         ) return "SH";
	if (iClass==CLASS_SWIFTBLADE            ) return "SB";
	if (iClass==CLASS_FOREST_MASTER         ) return "FM";
	if (iClass==CLASS_NIGHTSONG_ENFORCER    ) return "NE";
	if (iClass==CLASS_THUG             ) return "TG";
	// if (iClass==CLASS_DRAGON_SAMURAI        ) return "DS";
	if (iClass==CLASS_ELEM_ARCHER           ) return "EA";
	if (iClass==CLASS_DIVINE_SEEKER         ) return "DS";
	if (iClass==CLASS_ANOINTED_KNIGHT       ) return "AK";
	if (iClass==CLASS_NATURES_WARRIOR       ) return "NW";
	if (iClass==CLASS_FROST_MAGE            ) return "FM";
	if (iClass==CLASS_LION_TALISID          ) return "LT";
	if (iClass==CLASS_CHAMPION_WILD         ) return "CW";
	if (iClass==CLASS_SKULLCLAN_HUNTER      ) return "SH";
	if (iClass==CLASS_DARK_LANTERN          ) return "DL";
	if (iClass==CLASS_NIGHTSONG_INFILTRATOR ) return "NI";
	if (iClass==CLASS_MASTER_RADIANCE       ) return "MR";
	if (iClass==CLASS_HEARTWARDER           ) return "HW";
	if (iClass==CLASS_TYPE_AVENGER			) return "AV";
	if (iClass==CLASS_DREAD_COMMANDO        ) return "DC";
	if (iClass==CLASS_ELEMENTAL_WARRIOR     ) return "EW";
	if (iClass==CLASS_WHIRLING_DERVISH      ) return "WD";
	if (iClass==CLASS_DEATHBLADE			) return "DB";
	if (iClass==CLASS_OPTIMIST				) return "OP";
	if (iClass==CLASS_ELDRITCH_DISCIPLE		) return "ED";
	if (iClass==CLASS_TYPE_SWASHBUCKLER		) return "SB";
	if (iClass==CLASS_TYPE_DOOMGUIDE		) return "DG";
	if (iClass==CLASS_TYPE_HELLFIRE_WARLOCK	) return "HW";
	if (iClass==CLASS_CANAITH_LYRIST		) return "CN";
	if (iClass==CLASS_LYRIC_THAUMATURGE		) return "LY";
	if (iClass==CLASS_KNIGHT_TIERDRIAL		) return "KT";
	if (iClass==CLASS_SHADOWBANE_STALKER	) return "SS";
	if (iClass==CLASS_DRAGON_SHAMAN			) return "DS";
	if (iClass==CLASS_DREAD_COMMANDO		) return "DR";
	
	if (iClass==CLASS_CHAMP_SILVER_FLAME	) return "CF";
	if (iClass==CLASS_FIST_FOREST			) return "FF";
	
	
	if (iClass==CLASS_SWORD_DANCER			) return "SD";
	if (iClass==CLASS_DRAGON_WARRIOR		) return "DW";
	if (iClass==CLASS_CHILD_NIGHT			) return "CH";
	if (iClass==CLASS_DERVISH				) return "DV";
	if (iClass==CLASS_NINJA					) return "NJ";
	if (iClass==CLASS_GHOST_FACED_KILLER	) return "GF";
	if (iClass==CLASS_DREAD_PIRATE			) return "DP";
	if (iClass==CLASS_DAGGERSPELL_MAGE		) return "DM";
	if (iClass==CLASS_DAGGERSPELL_SHAPER	) return "DS";
	if (iClass==CLASS_SCOUT					) return "SC";
	if (iClass==CLASS_WILD_STALKER			) return "WS";
	if (iClass==CLASS_VERDANT_GUARDIAN 		) return "VG";
	if (iClass==CLASS_DISSONANT_CHORD		) return "DC";
	// we have an error, just give bogus data
	return "??";
}


/**  
* Get the name of a Deity
* @param iDeityId Identifier of the Feat
* @return the name of the specified Deity
*/
string CSLGetClassesDataName(int iClassId, int bAbbr=FALSE)
{
	if (bAbbr) 
	{
		return CSLGetClassesDataAbbrev(iClassId);
	}
	
	
	CSLGetClassesDataObject();
	if ( !GetIsObjectValid( oClassTable ) )
	{
		string sString = Get2DAString("classes", "Name", iClassId);
		
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
	return CSLDataTableGetStringByRow( oClassTable, "Name", iClassId );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// CSLGetClassData( "NAME", iClass )
/*
string CSLGetClassData(int nClassID, string sFld="")
{ // VALID sFLD = NAME

	string sName = GetLocalString(GetModule(), "SC_CLASS_NAME_" + IntToString(nClassID) );
	//string sLevel = GetLocalString(oModule, "SC_SPELL_LVL_" + IntToString(iSpellId) );
	
	
	if ( sName == "")
	{
		sName = Get2DAString("classes", "Label", nClassID);
		//sLevel = Get2DAString("spells", "LVL", iSpellId);
		
		SetLocalString(GetModule(), "SC_CLASS_NAME_" + IntToString(nClassID), sName );
		//SetLocalString(oModule, "SC_SPELL_LVL_" + IntToString(iSpellId), sLevel );
	}
	
	//if ( sFld = "LVL" )
	//{
	// return sLevel;
	//
	//}
	//else
	if ( sFld == "NAME" )
	{
		return sName;
	}
	//else if ( sFld = "Label" )
	//{
	// return sName;
	//}
	
	return "";
}
*/



/**  
* @author
* @param 
* @see 
* @return 
*/
/*
string CSLClassToString(int iClass = 0, int bAbbr=FALSE)
{
	if (bAbbr) return CSLGetClassesDataAbbrev(iClass);
	
	return CSLGetClassesDataName(iClass);
	*/
	/*
	if (iClass==CLASS_TYPE_ABERRATION       ) return "Aberration";
	if (iClass==CLASS_TYPE_HUMANOID         ) return "Humanoid";
	if (iClass==CLASS_TYPE_ANIMAL           ) return "Animal";
	if (iClass==CLASS_TYPE_INVALID          ) return "Invalid";
	if (iClass==CLASS_TYPE_ARCANE_ARCHER    ) return "Arcane Archer";
	if (iClass==CLASS_TYPE_INVISIBLE_BLADE  ) return "Invisible Blade";
	if (iClass==CLASS_TYPE_ARCANE_SCHOLAR   ) return "Arcane Scholar";
	if (iClass==CLASS_TYPE_MAGICAL_BEAST    ) return "Magical Beast";
	if (iClass==CLASS_TYPE_ARCANETRICKSTER  ) return "Arcane Trickster";
	if (iClass==CLASS_TYPE_MONK             ) return "Monk";
	if (iClass==CLASS_TYPE_ASSASSIN         ) return "Assassin";
	if (iClass==CLASS_TYPE_MONSTROUS        ) return "Monstrous";
	if (iClass==CLASS_TYPE_BARBARIAN        ) return "Barbarian";
	if (iClass==CLASS_TYPE_OOZE             ) return "Ooze";
	if (iClass==CLASS_TYPE_BARD             ) return "Bard";
	if (iClass==CLASS_TYPE_OUTSIDER         ) return "Outsider";
	if (iClass==CLASS_TYPE_BEAST            ) return "Beast";
	if (iClass==CLASS_TYPE_PALADIN          ) return "Paladin";
	if (iClass==CLASS_TYPE_BLACKGUARD       ) return "Blackguard";
	if (iClass==CLASS_TYPE_PALEMASTER       ) return "Palemaster";
	if (iClass==CLASS_TYPE_CLERIC           ) return "Cleric";
	if (iClass==CLASS_TYPE_RANGER           ) return "Ranger";
	if (iClass==CLASS_TYPE_COMMONER         ) return "Commoner";
	if (iClass==CLASS_TYPE_RED_WIZARD       ) return "Red Wizard";
	if (iClass==CLASS_TYPE_CONSTRUCT        ) return "Construct";
	if (iClass==CLASS_TYPE_ROGUE            ) return "Rogue";
	if (iClass==CLASS_TYPE_DIVINECHAMPION   ) return "Divine Champion";
	if (iClass==CLASS_TYPE_SACREDFIST       ) return "Sacred Fist";
	if (iClass==CLASS_TYPE_DRAGON           ) return "Dragon";
	if (iClass==CLASS_TYPE_SHADOWDANCER     ) return "Shadow Dancer";
	if (iClass==CLASS_TYPE_DRAGONDISCIPLE   ) return "Dragon Disciple";
	if (iClass==CLASS_TYPE_SHADOWTHIEFOFAMN ) return "Shadow Thief";
	if (iClass==CLASS_TYPE_DRUID            ) return "Druid";
	if (iClass==CLASS_TYPE_SHAPECHANGER     ) return "Shapechanger";
	if (iClass==CLASS_TYPE_DUELIST          ) return "Duelist";
	if (iClass==CLASS_TYPE_SHIFTER          ) return "Shifter";
	if (iClass==CLASS_TYPE_DWARVENDEFENDER  ) return "Dwarven Defender";
	if (iClass==CLASS_TYPE_SORCERER         ) return "Sorcerer";
	if (iClass==CLASS_TYPE_ELDRITCH_KNIGHT  ) return "Eldritch Knight";
	if (iClass==CLASS_TYPE_SPIRIT_SHAMAN    ) return "Spirit Shaman";
	if (iClass==CLASS_TYPE_ELEMENTAL        ) return "Elemental";
	if (iClass==CLASS_TYPE_STORMLORD        ) return "Stormlord";
	if (iClass==CLASS_TYPE_FAVORED_SOUL     ) return "Favored Soul";
	if (iClass==CLASS_TYPE_UNDEAD           ) return "Undead";
	if (iClass==CLASS_TYPE_FEY              ) return "Fey";
	if (iClass==CLASS_TYPE_VERMIN           ) return "Vermin";
	if (iClass==CLASS_TYPE_FIGHTER          ) return "Fighter";
	if (iClass==CLASS_TYPE_WARLOCK          ) return "Warlock";
	if (iClass==CLASS_TYPE_FRENZIEDBERSERKER) return "Frenzied Berserker";
	if (iClass==CLASS_TYPE_WARPRIEST        ) return "War Priest";
	if (iClass==CLASS_TYPE_GIANT            ) return "Giant";
	if (iClass==CLASS_TYPE_WEAPON_MASTER    ) return "Weapon Master";
	if (iClass==CLASS_TYPE_HARPER           ) return "Harper";
	if (iClass==CLASS_TYPE_WIZARD           ) return "Wizard";
	
	if (iClass==CLASS_HOSPITALER            ) return "Hospitaler";
	if (iClass==CLASS_WARRIOR_DARKNESS      ) return "Warrior Darkness";
	if (iClass==CLASS_BLADESINGER           ) return "Bladesinger";
	if (iClass==CLASS_STORMSINGER           ) return "Stormsinger";
	if (iClass==CLASS_TEMPEST               ) return "Tempest";
	if (iClass==CLASS_BLACK_FLAME_ZEALOT    ) return "Black Flame Zealot";
	if (iClass==CLASS_SHINING_BLADE         ) return "Shining Blade";
	if (iClass==CLASS_SWIFTBLADE            ) return "Swiftblade";
	if (iClass==CLASS_FOREST_MASTER         ) return "Forest Master";
	if (iClass==CLASS_NIGHTSONG_ENFORCER    ) return "Nightsong Enforcer";
	if (iClass==CLASS_THUG             ) return "Thug";
	// if (iClass==CLASS_DRAGON_SAMURAI        ) return "Dragon Samurai";
	if (iClass==CLASS_ELEM_ARCHER           ) return "Elemental Archer";
	if (iClass==CLASS_DIVINE_SEEKER         ) return "Divine Seeker";
	if (iClass==CLASS_ANOINTED_KNIGHT       ) return "Anointed Knight";
	if (iClass==CLASS_NATURES_WARRIOR       ) return "Natures Warrior";
	if (iClass==CLASS_FROST_MAGE            ) return "Frost Mage";
	if (iClass==CLASS_LION_TALISID          ) return "Lion Talisid";
	if (iClass==CLASS_CHAMPION_WILD         ) return "Champion Wild";
	if (iClass==CLASS_SKULLCLAN_HUNTER      ) return "Skullclan Hunter";
	if (iClass==CLASS_DARK_LANTERN          ) return "Dark Lantern";
	if (iClass==CLASS_NIGHTSONG_INFILTRATOR ) return "Nightsong Infiltrator";
	if (iClass==CLASS_MASTER_RADIANCE       ) return "Master Radiance";
	if (iClass==CLASS_HEARTWARDER           ) return "Heartwarder";
	if (iClass==CLASS_TYPE_AVENGER          ) return "Avenger";
	if (iClass==CLASS_DREAD_COMMANDO        ) return "Dread Commando";
	if (iClass==CLASS_ELEMENTAL_WARRIOR     ) return "Elemental Warrior";
	if (iClass==CLASS_WHIRLING_DERVISH      ) return "Whirling Dervish";
	
	if (iClass==CLASS_DEATHBLADE			) return "Death Blade";
	if (iClass==CLASS_OPTIMIST				) return "Optimist";
	if (iClass==CLASS_ELDRITCH_DISCIPLE		) return "Eldritch Disciple";
	if (iClass==CLASS_TYPE_SWASHBUCKLER		) return "Swash Buckler";
	if (iClass==CLASS_TYPE_DOOMGUIDE		) return "Doom Guide";
	if (iClass==CLASS_TYPE_HELLFIRE_WARLOCK	) return "Hellfire Warlock";
	if (iClass==CLASS_CANAITH_LYRIST		) return "Canaith Lyrist";
	if (iClass==CLASS_LYRIC_THAUMATURGE		) return "Lyric Thaumaturge";
	if (iClass==CLASS_KNIGHT_TIERDRIAL		) return "Knight Tierdrial";
	if (iClass==CLASS_SHADOWBANE_STALKER	) return "Shadowbane Stalker";
	if (iClass==CLASS_DRAGON_SHAMAN			) return "Dragon Shaman";
	if (iClass==CLASS_DREAD_COMMANDO		) return "Dread Commando";
	if (iClass==CLASS_CHAMP_SILVER_FLAME	) return "Champion of the Silver Flame";
	if (iClass==CLASS_FIST_FOREST			) return "Fist of the Forest";


	if (iClass==CLASS_SWORD_DANCER			) return "Sword Dancer";
	if (iClass==CLASS_DRAGON_WARRIOR		) return "Dragon Warrior";
	if (iClass==CLASS_CHILD_NIGHT			) return "Child of the Night";
	if (iClass==CLASS_DERVISH				) return "Dervish";
	if (iClass==CLASS_NINJA					) return "Ninja";
	if (iClass==CLASS_GHOST_FACED_KILLER	) return "Ghost Faced Killer";
	if (iClass==CLASS_DREAD_PIRATE			) return "Dread Pirate";
	if (iClass==CLASS_DAGGERSPELL_MAGE		) return "Daggerspell Mage";
	if (iClass==CLASS_DAGGERSPELL_SHAPER	) return "Daggerspell Shaper";
	if (iClass==CLASS_SCOUT					) return "Scout";
	if (iClass==CLASS_WILD_STALKER			) return "Wild Stalker";
	if (iClass==CLASS_VERDANT_GUARDIAN 		) return "Verdant Guardian";
	if (iClass==CLASS_DISSONANT_CHORD		) return "Dissonant Chord";

	// must be another class, pull it from the real data
	return CSLGetClassData( iClass, "NAME" );
	return "MissClass" + IntToString(iClass);
	*/
//}
//*/


object oDeityTable;
/**  
* Makes sure the oFeatTable is a valid pointer to the deities dataobject
* @author
* @see 
* @return 
*/
void CSLGetDeityDataObject()
{
	if ( !GetIsObjectValid( oDeityTable ) )
	{
		oDeityTable = CSLDataObjectGet( "deities" );
	}
	//return oSpellTable;
}



/**  
* Get the name of a Deity
* @param iDeityId Identifier of the Feat
* @return the name of the specified Deity
*/
string CSLGetDeityDataName(int iDeityId)
{
	CSLGetDeityDataObject();
	if ( !GetIsObjectValid( oDeityTable ) )
	{
		string sString = Get2DAString("nwn2_deities", "NameStringref", iDeityId);
		
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
	return CSLDataTableGetStringByRow( oDeityTable, "NameStringref", iDeityId );
}


/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int CSLGetDeityDataRowByName( string sDeityName )
{
	CSLGetDeityDataObject();
	int iDeityId;
	if ( GetIsObjectValid( oDeityTable ) )
	{
		iDeityId = CSLDataTableGetRowByValue( oDeityTable, sDeityName );
		if ( iDeityId != -1 )
		{
			return iDeityId;
		}
	}
	
	// lets try brute force now, no way to do an index, so use a stored list
	string sDeityInitital = GetStringUpperCase( GetStringLeft(sDeityName,1) );
	
	if ( sDeityInitital == "S" )
	{
		if ( sDeityName == "Savras" ) { return 86; } // 46; }
		if ( sDeityName == "Segojan Earthcaller" ) { return 45; } // 46; }
		if ( sDeityName == "Sehanine Moonbow" ) { return 10; } // 46; }
		if ( sDeityName == "Selune" ) { return 87; } // 46; }
		if ( sDeityName == "Seveltarm" ) { return 17; } // 46; }
		if ( sDeityName == "Shar" ) { return 88; } // 45; }
		if ( sDeityName == "Sharess" ) { return 89; } // 21; }
		if ( sDeityName == "Shargaas" ) { return 51; } // 45; }
		if ( sDeityName == "Sharindlar" ) { return 36; } // 45; }
		if ( sDeityName == "Shaundakul" ) { return 90; } // 45; }
		if ( sDeityName == "Sheela Peryroyl" ) { return 22; } // 46; }
		if ( sDeityName == "Shevarash" ) { return 11; } // 45; }
		if ( sDeityName == "Shiallia" ) { return 91; } // 46; }
		if ( sDeityName == "Siamorphe" ) { return 92; } // 46; }
		if ( sDeityName == "Silvanus" ) { return 93; } // 45; }
		if ( sDeityName == "Solonor Thelandira" ) { return 12; } // 45; }
		if ( sDeityName == "Sseth" ) { return 106; } // 46; }
		if ( sDeityName == "Sune" ) { return 94; } // 45; }
	}
	else if ( sDeityInitital == "G" )
	{
		if ( sDeityName == "Gaerdal Ironhand" ) { return 43; } // 45; }
		if ( sDeityName == "Garagos" ) { return 63; } // 45; }
		if ( sDeityName == "Gargauth" ) { return 64; } // 46; }
		if ( sDeityName == "Garl Glittergold" ) { return 44; } // 45; }
		if ( sDeityName == "Ghaunadaur" ) { return 14; } // 45; }
		if ( sDeityName == "Gond" ) { return 65; } // 45; }
		if ( sDeityName == "Gorm Gulthyn" ) { return 31; } // 44; }
		if ( sDeityName == "Grumbar" ) { return 66; } // 45; }
		if ( sDeityName == "Gruumsh" ) { return 48; } // 46; }
		if ( sDeityName == "Gwaeron Windstrom" ) { return 67; } // 45; }
	}
	else if ( sDeityInitital == "A" )
	{
		if ( sDeityName == "Abbathor" ) { return 25; } // 46; }
		if ( sDeityName == "Aerdrie Faenya" ) { return 2; } // 46; }
		if ( sDeityName == "Akadi" ) { return 53; } // 45; }
		if ( sDeityName == "Angharradh" ) { return 3; } // 46; }
		if ( sDeityName == "Ao" ) { return 1; } // 45; }
		if ( sDeityName == "Arvoreen" ) { return 19; } // 45; }
		if ( sDeityName == "Auril" ) { return 54; } // 45; }
		if ( sDeityName == "Azuth" ) { return 55; } // 46; }
	}
	else if ( sDeityInitital == "L" )
	{
		if ( sDeityName == "Labelas Enoreth" ) { return 8; } // 46; }
		if ( sDeityName == "Laduguer" ) { return 33; } // 45; }
		if ( sDeityName == "Lathander" ) { return 75; } // 46; }
		if ( sDeityName == "Leira" ) { return 107; } // 45; }
		if ( sDeityName == "Lliira" ) { return 76; } // 44; }
		if ( sDeityName == "Lolth" ) { return 16; } // 46; }
		if ( sDeityName == "Loviatar" ) { return 77; } // 45; }
		if ( sDeityName == "Lurue" ) { return 78; } // 46; }
		if ( sDeityName == "Luthic" ) { return 50; } // 21; }
	}
	else if ( sDeityInitital == "M" )
	{
		if ( sDeityName == "Malar" ) { return 79; } // 21; }
		if ( sDeityName == "Marthammor Duin" ) { return 34; } // 46; }
		if ( sDeityName == "Mask" ) { return 80; } // 45; }
		if ( sDeityName == "Mielikki" ) { return 81; } // 45; }
		if ( sDeityName == "Milil" ) { return 82; } // 45; }
		if ( sDeityName == "Moradin" ) { return 35; } // 45; }
		if ( sDeityName == "Mystra" ) { return 83; } // 44; }
	}
	else if ( sDeityInitital == "B" )
	{
		if ( sDeityName == "Baervan Wildwanderer" ) { return 39; } // 1105; }
		if ( sDeityName == "Bahgtru" ) { return 47; } // 45; }
		if ( sDeityName == "Bane" ) { return 56; } // 46; }
		if ( sDeityName == "Baravar Cloakshadow" ) { return 40; } // 46; }
		if ( sDeityName == "Berronar Truesilver" ) { return 26; } // 46; }
		if ( sDeityName == "Beshaba" ) { return 57; } // 45; }
		if ( sDeityName == "Brandobaris" ) { return 20; } // 46; }
	}
	else if ( sDeityInitital == "T" )
	{
		if ( sDeityName == "Talona" ) { return 95; } // 21; }
		if ( sDeityName == "Talos" ) { return 96; } // 46; }
		if ( sDeityName == "Tempus" ) { return 97; } // 45; }
		if ( sDeityName == "Thard Harr" ) { return 37; } // 45; }
		if ( sDeityName == "Torm" ) { return 98; } // 45; }
		if ( sDeityName == "Tymora" ) { return 99; } // 44; }
		if ( sDeityName == "Tyr" ) { return 100; } // 45; }
	}
	else if ( sDeityInitital == "C" )
	{
		if ( sDeityName == "Callarduran Smoothhands" ) { return 41; } // 45; }
		if ( sDeityName == "Chauntea" ) { return 58; } // 45; }
		if ( sDeityName == "Clangeddin Silverbeard" ) { return 27; } // 45; }
		if ( sDeityName == "Corellon Larethian" ) { return 4; } // 45; }
		if ( sDeityName == "Cyric" ) { return 59; } // 45; }
		if ( sDeityName == "Cyrrollalee" ) { return 21; } // 46; }
	}
	else if ( sDeityInitital == "U" )
	{
		if ( sDeityName == "Ubtao" ) { return 108; } // 46; }
		if ( sDeityName == "Umberlee" ) { return 101; } // 45; }
		if ( sDeityName == "Urdlen" ) { return 46; } // 21; }
		if ( sDeityName == "Urogalan" ) { return 23; } // 45; }
	}
	else if ( sDeityInitital == "V" )
	{
		if ( sDeityName == "Valkur" ) { return 102; } // 45; }
		if ( sDeityName == "Velsharoon" ) { return 103; } // 46; }
		if ( sDeityName == "Vergadain" ) { return 38; } // 45; }
		if ( sDeityName == "Vhaeraun" ) { return 18; } // 45; }
	}
	else if ( sDeityInitital == "D" )
	{
		if ( sDeityName == "Deep Duerra" ) { return 28; } // 45; }
		if ( sDeityName == "Deneir" ) { return 60; } // 46; }
		if ( sDeityName == "Dugmaren Brightmantle" ) { return 29; } // 45; }
		if ( sDeityName == "Dumathoin" ) { return 30; } // 45; }
	}
	else if ( sDeityInitital == "H" )
	{
		if ( sDeityName == "Haela Brightaxe" ) { return 32; } // 45; }
		if ( sDeityName == "Hanali Celanil" ) { return 7; } // 46; }
		if ( sDeityName == "Helm" ) { return 68; } // 44; }
		if ( sDeityName == "Hoar" ) { return 69; } // 46; }
	}
	else if ( sDeityInitital == "I" )
	{
		if ( sDeityName == "Ilmater" ) { return 70; } // 21; }
		if ( sDeityName == "Ilneval" ) { return 49; } // 45; }
		if ( sDeityName == "Istishia" ) { return 71; } // 45; }
	}
	else if ( sDeityInitital == "K" )
	{
		if ( sDeityName == "Kelemvor" ) { return 73; } // 44; }
		if ( sDeityName == "Kiransalee" ) { return 15; } // 46; }
		if ( sDeityName == "Kossuth" ) { return 74; } // 45; }
	}
	else if ( sDeityInitital == "E" )
	{
		if ( sDeityName == "Eilistraee" ) { return 13; } // 44; }
		if ( sDeityName == "Eldath" ) { return 61; } // 21; }
		if ( sDeityName == "Erevan Ilesere" ) { return 5; } // 45; }
	}
	else if ( sDeityInitital == "F" )
	{
		if ( sDeityName == "Fenmarel Mestarine" ) { return 6; } // 46; }
		if ( sDeityName == "Finder Wyvernspur" ) { return 62; } // 44; }
		if ( sDeityName == "Flandal Steelskin" ) { return 42; } // 45; }
	}
	else 
	{
		if ( sDeityName == "Red Knight" ) { return 85; } // 45; }
		if ( sDeityName == "Rillfane Rallathil" ) { return 9; } // 46; }
		if ( sDeityName == "Jergal" ) { return 72; } // 45; }
		if ( sDeityName == "No Deity" ) { return 0; } // 45; }
		if ( sDeityName == "None" ) { return 105; } // 45; }
		if ( sDeityName == "Oghma" ) { return 84; } // 45; }
		if ( sDeityName == "Waukeen" ) { return 104; } // 46; }
		if ( sDeityName == "Yondalla" ) { return 24; } // 45; }
		if ( sDeityName == "Yurtrus" ) { return 52; } // 21; }
	}
	return -1;
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int CSLGetDeityDataRowByFollower( object oCaster = OBJECT_SELF )
{
	return CSLGetDeityDataRowByName( GetDeity( oCaster ) );
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int CSLGetDeityDataFavoredWeapon( string sDeityName )
{
	CSLGetDeityDataObject();
	int iDeityId = CSLGetDeityDataRowByName( sDeityName );
	if ( iDeityId != -1 )
	{
		if ( GetIsObjectValid( oDeityTable ) )
		{
			return StringToInt(CSLDataTableGetStringByRow( oDeityTable, "FavoredWeaponProficiency", iDeityId ));
		}
		return StringToInt(Get2DAString("nwn2_deities", "FavoredWeaponProficiency", iDeityId));
	}
	return -1;
}


/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int CSLGetDeityDataFavoredWeaponFocus( string sDeityName )
{
	CSLGetDeityDataObject();
	int iDeityId = CSLGetDeityDataRowByName( sDeityName );
	if ( iDeityId != -1 )
	{
		if ( GetIsObjectValid( oDeityTable ) )
		{
			return StringToInt(CSLDataTableGetStringByRow( oDeityTable, "FavoredWeaponFocus", iDeityId ));
		}
		return StringToInt(Get2DAString("nwn2_deities", "FavoredWeaponFocus", iDeityId));
	}
	return -1;
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int CSLGetDeityDataFavoredWeaponSpecialization( string sDeityName )
{
	CSLGetDeityDataObject();
	int iDeityId = CSLGetDeityDataRowByName( sDeityName );
	if ( iDeityId != -1 )
	{
		if ( GetIsObjectValid( oDeityTable ) )
		{
			return StringToInt(CSLDataTableGetStringByRow( oDeityTable, "FavoredWeaponSpecialization", iDeityId ));
		}
		return StringToInt(Get2DAString("nwn2_deities", "FavoredWeaponSpecialization", iDeityId));
	}
	return -1;
}

		



// * Another one form Syrus
/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetHasDomain(int iDomainToCheck, object oCreature=OBJECT_SELF)
{    
    return GetHasFeat(iDomainToCheck, oCreature);
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetProgrssionTable( int iClassId )
{
	switch ( iClassId )
	{
		case CLASS_TYPE_ARCANETRICKSTER:
			return SC_CLASS_PROG_ARCANETRICKSTER;
			break;
		case CLASS_TYPE_ARCANE_SCHOLAR:
			return SC_CLASS_PROG_ARCANE_SCHOLAR;
			break;
		case CLASS_TYPE_BARD:
			return SC_CLASS_PROG_BARD;
			break;
		case CLASS_TYPE_CLERIC:
			return SC_CLASS_PROG_CLERIC;
			break;
		case CLASS_TYPE_DRUID:
			return SC_CLASS_PROG_DRUID;
			break;
		case CLASS_TYPE_ELDRITCH_KNIGHT:
			return SC_CLASS_PROG_ELDRITCH_KNIGHT;
			break;
			
		case CLASS_DAGGERSPELL_MAGE:
			return SC_CLASS_PROG_DAGGERSPELL_MAGE;
			break;
		case CLASS_DAGGERSPELL_SHAPER:
			return SC_CLASS_PROG_DAGGERSPELL_SHAPER;
			break;
			
		case CLASS_TYPE_FAVORED_SOUL:
			return SC_CLASS_PROG_FAVORED_SOUL;
			break;
		case CLASS_TYPE_HARPER:
			return SC_CLASS_PROG_HARPER;
			break;
		case CLASS_TYPE_PALADIN:
			return SC_CLASS_PROG_PALADIN;
			break;
		case CLASS_TYPE_PALEMASTER:
			return SC_CLASS_PROG_PALEMASTER;
			break;
		case CLASS_TYPE_RANGER:
			return SC_CLASS_PROG_RANGER;
			break;
		case CLASS_TYPE_RED_WIZARD:
			return SC_CLASS_PROG_RED_WIZARD;
			break;
		case CLASS_TYPE_SACREDFIST:
			return SC_CLASS_PROG_SACREDFIST;
			break;
		case CLASS_TYPE_SORCERER:
			return SC_CLASS_PROG_SORCERER;
			break;
		case CLASS_TYPE_SPIRIT_SHAMAN:
			return SC_CLASS_PROG_SPIRIT_SHAMAN;
			break;
		case CLASS_TYPE_STORMLORD:
			return SC_CLASS_PROG_STORMLORD;
			break;
		case CLASS_TYPE_WARLOCK:
			return SC_CLASS_PROG_WARLOCK;
			break;
		case CLASS_TYPE_WARPRIEST:
			return SC_CLASS_PROG_WARPRIEST;
			break;
		case CLASS_TYPE_WIZARD:
			return SC_CLASS_PROG_WIZARD;
			break;
		case CLASS_TYPE_ASSASSIN:
			return SC_CLASS_PROG_ASSASSIN;
			break;
		case CLASS_TYPE_BLACKGUARD:
			return SC_CLASS_PROG_BLACKGUARD;
			break;
		case CLASS_NWNINE_WARDER:
			return SC_CLASS_PROG_NWNINE_WARDER;
			break;		
		case CLASS_HOSPITALER:
			return SC_CLASS_PROG_HOSPITALER;
			break;
		case CLASS_BLADESINGER:
			return SC_CLASS_PROG_BLADESINGER;
			break;		
		case CLASS_STORMSINGER:
			return SC_CLASS_PROG_STORMSINGER;
			break;
		case CLASS_BLACK_FLAME_ZEALOT:
			return SC_CLASS_PROG_BLACK_FLAME_ZEALOT;
			break;		
		case CLASS_SHINING_BLADE:
			return SC_CLASS_PROG_SHINING_BLADE;
			break;
		case CLASS_SWIFTBLADE:
			return SC_CLASS_PROG_SWIFTBLADE;
			break;		
		case CLASS_FOREST_MASTER:
			return SC_CLASS_PROG_FOREST_MASTER;
			break;
		case CLASS_NATURES_WARRIOR:
			return SC_CLASS_PROG_NATURES_WARRIOR;
			break;		
		case CLASS_FROST_MAGE:
			return SC_CLASS_PROG_FROST_MAGE;
			break;
		case CLASS_LION_TALISID:
			return SC_CLASS_PROG_LION_TALISID;
			break;
		case CLASS_MASTER_RADIANCE:
			return SC_CLASS_PROG_MASTER_RADIANCE;
			break;		
		case CLASS_HEARTWARDER:
			return SC_CLASS_PROG_HEARTWARDER;
			break;
		case CLASS_TYPE_AVENGER:
			return SC_CLASS_PROG_AVENGER;
			break;
		case CLASS_SHADOWBANE_STALKER:
			return SC_CLASS_PROG_SHADOWBANE_STALKER;
			break;
		case CLASS_KNIGHT_TIERDRIAL:
			return SC_CLASS_PROG_KNIGHT_TIERDRIAL;
			break;
		case CLASS_DRAGONSLAYER:
			return SC_CLASS_PROG_DRAGONSLAYER;
			break;
		case CLASS_LYRIC_THAUMATURGE:
			return SC_CLASS_PROG_LYRIC_THAUMATURGE;
			break;
		case CLASS_CANAITH_LYRIST:
			return SC_CLASS_PROG_CANAITH_LYRIST;
			break;
		case CLASS_TYPE_DOOMGUIDE:
			return SC_CLASS_PROG_DOOMGUIDE;
			break;
		case CLASS_TYPE_HELLFIRE_WARLOCK:
			return SC_CLASS_PROG_HELLFIRE_WARLOCK;
			break;
		case CLASS_ELDRITCH_DISCIPLE:
			return SC_CLASS_PROG_ELDRITCH_DISCIPLE;
			break;
		default:
			return SC_PROG_NONE;
	}
	return SC_PROG_NONE;
	
/*
	these are not set yet, as they are not implemented yet in NWN2
	Look at adding community based classes as well that are casters
case CLASS_TYPE_CONTEMPLATIVE:
case CLASS_TYPE_MYSTICTHEURGE:
case CLASS_NWNINE_MAGUS:
case CLASS_TYPE_OOZE:
case CLASS_NWNINE_AGENT:
	return  PROG_XXX;
	break;
*/

}



/**  
* @author
* @param 
* @see 
* @return 
*/
// Might be wise to use a 2da lookup here, but also hardwired is better for PW's Performance
// This is focused on a stat for casters
// iType is either Spells or DC for the two split classes
int CSLGetMainStatByClass( int iClass, string sType = "Spells")
{
	int iPrimAbility = -1;
	/*
	
	Favored souls
	Spells Charisma - Must have a Charisma score of 10 + the spell's level to cast a spell.
	DC Wisdom
	
	Spirit Shaman
	Spells Wisdom - Must have a Wisdom score of 10 + the spell's level to cast a spell.
	DC Charisma
	
	*/
	switch (iClass)
	{
		case CLASS_TYPE_CLERIC:
		case CLASS_TYPE_DRUID:  
		case CLASS_TYPE_PALADIN:
		case CLASS_TYPE_RANGER:
		case CLASS_TYPE_SACREDFIST:
		case CLASS_TYPE_SHIFTER:
		case CLASS_TYPE_STORMLORD:
		case CLASS_TYPE_DIVINECHAMPION:
		case CLASS_TYPE_WARPRIEST:
			iPrimAbility = ABILITY_WISDOM;
			break;
		case CLASS_TYPE_FAVORED_SOUL:
			if ( sType == "Spells" )
			{
				iPrimAbility = ABILITY_CHARISMA;
			}
			else
			{
				iPrimAbility = ABILITY_WISDOM;
			}
			break;
		case CLASS_TYPE_SPIRIT_SHAMAN:
			if ( sType == "Spells" )
			{
				iPrimAbility = ABILITY_WISDOM;
			}
			else
			{
				iPrimAbility = ABILITY_CHARISMA;
			}
			break;
		case CLASS_TYPE_SORCERER:
		case CLASS_TYPE_WARLOCK:
		case CLASS_TYPE_BLACKGUARD:
		case CLASS_TYPE_BARD:
		case CLASS_TYPE_RACIAL:
			iPrimAbility = ABILITY_CHARISMA;
			break;
		case CLASS_TYPE_WIZARD:
		case CLASS_TYPE_ASSASSIN:
		case CLASS_TYPE_RED_WIZARD:
			iPrimAbility = ABILITY_INTELLIGENCE;
			break;
		case CLASS_TYPE_ARCANETRICKSTER:
			// should check for spellcasting feats, but PRCs should not hit this function
			iPrimAbility = ABILITY_INTELLIGENCE;
			//iPrimAbility = ABILITY_CHARISMA;
			break;
		case CLASS_NWNINE_WARDER:
			// should check for spellcasting feats, but PRCs should not hit this function
			iPrimAbility = ABILITY_INTELLIGENCE;
			//iPrimAbility = ABILITY_CHARISMA;
			break;
		case CLASS_TYPE_ARCANE_SCHOLAR:
			// should check for spellcasting feats, but PRCs should not hit this function
			iPrimAbility = ABILITY_INTELLIGENCE;
			//iPrimAbility = ABILITY_CHARISMA;
			break;
		case CLASS_TYPE_ELDRITCH_KNIGHT:
			// should check for spellcasting feats, but PRCs should not hit this function
			iPrimAbility = ABILITY_INTELLIGENCE;
			//iPrimAbility = ABILITY_CHARISMA;
			break;
		case CLASS_TYPE_PALEMASTER:
			// should check for spellcasting feats, but PRCs should not hit this function
			iPrimAbility = ABILITY_INTELLIGENCE;
			//iPrimAbility = ABILITY_CHARISMA;
			break;
		case CLASS_TYPE_HARPER:
			// should check for spellcasting feats, but PRCs should not hit this function
			iPrimAbility = ABILITY_CHARISMA;
			//iPrimAbility = ABILITY_INTELLIGENCE;
			break;
		default:
			iPrimAbility = -1;

	}
	return iPrimAbility;
}

/**  
*
* @author
* @param 
* @see 
* @return 
* @replaces XXXGetAbilityForClass
*/
int CSLGetAbilityScoreByClass( object oCaster, int iClass = 255, string sType = "Spells" )
{
	if ( iClass == 255 )
	{
		// recreating hkspell function for int HkGetSpellClass( object oCaster = OBJECT_SELF ) here to prevent include issues
		int iTempClass = CSLReadIntModifier( oCaster, "Class" )-1; // already stored and cached the class, so don't need to get it again.
		if ( iTempClass < 254 && iTempClass > -1 ) // Barbarian is not a real class
		{
			iClass = iTempClass;
		}
		else if ( iClass == CLASS_TYPE_BESTDIVINE )
		{
			iClass = GetLocalInt(oCaster, "SC_iBestDivineClass" );
		}
		else if ( iClass == CLASS_TYPE_BESTARCANE )
		{
			iClass = GetLocalInt(oCaster, "SC_iBestArcaneClass" );
		}
		else if ( iClass == CLASS_TYPE_BESTELDRITCH )
		{
			iClass = GetLocalInt(oCaster, "SC_iBestEldritchClass" );
		}
		else if ( iClass == CLASS_TYPE_BESTPSIONIC )
		{
			iClass = GetLocalInt(oCaster, "SC_iBestPsionicClass" );
		}
		else if ( iClass == CLASS_TYPE_BESTCASTER )
		{
			iClass = GetLocalInt(oCaster, "SC_iBestCasterClass" );
		}
		else
		{
			iClass = GetLastSpellCastClass();
		}
		
		if ( iClass == 255 || iClass == -1  )
		{
			iClass = CLASS_TYPE_RACIAL;
		}
	}
	
	int iStat = CSLGetMainStatByClass( iClass, sType);
	if ( iStat == -1 ) { return 0; }
	return GetAbilityScore(oCaster, iStat);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetPositionByClass( int iClass, object oCaster = OBJECT_SELF )
{
	if ( GetClassByPosition(1,oCaster) == iClass )
	{
		return 1;
	}
	if ( GetClassByPosition(2,oCaster) == iClass )
	{
		return 2;
	}
	if ( GetClassByPosition(3,oCaster) == iClass )
	{
		return 3;
	}
	if ( GetClassByPosition(4,oCaster) == iClass )
	{
		return 4;
	}
	return 0;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// same as SCGetClassMagicType
int CSLGetBaseCasterType( int iClassId )
{
	// this ignores PRCS, i figure out that later when i get the caster levels
	switch ( iClassId )
	{
		case CLASS_TYPE_BARD:
		case CLASS_TYPE_SORCERER:
		case CLASS_TYPE_WIZARD:
		case CLASS_TYPE_ASSASSIN:
			return SC_SPELLTYPE_ARCANE;
			break;
		case CLASS_TYPE_CLERIC:
		case CLASS_TYPE_DRUID:
		case CLASS_TYPE_FAVORED_SOUL:
		case CLASS_TYPE_SPIRIT_SHAMAN:
		case CLASS_TYPE_BLACKGUARD:
		case CLASS_TYPE_PALADIN:
		case CLASS_TYPE_RANGER:
			return SC_SPELLTYPE_DIVINE;
			break;
		case CLASS_TYPE_WARLOCK:
			return SC_SPELLTYPE_ELDRITCH;
			break;
		default:
			return SC_SPELLTYPE_NONE;
	}
	return SC_SPELLTYPE_NONE;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetClassType( int iClass = 255 )
{
	// this ignores PRCS, i figure out that later when i get the caster levels
	switch ( iClass )
	{
		case CLASS_TYPE_BARBARIAN:
		case CLASS_TYPE_BARD:
		case CLASS_TYPE_CLERIC:
		case CLASS_TYPE_DRUID:
		case CLASS_TYPE_MONK:
		case CLASS_TYPE_ROGUE:
		case CLASS_TYPE_WIZARD:
		case CLASS_TYPE_FIGHTER:
		case CLASS_TYPE_PALADIN:
		case CLASS_TYPE_RANGER:
		case CLASS_TYPE_FAVORED_SOUL:
		case CLASS_TYPE_WARLOCK:
		case CLASS_TYPE_SORCERER:
		case CLASS_TYPE_SPIRIT_SHAMAN:
		case CLASS_TYPE_SWASHBUCKLER:
		case CLASS_THUG: // kaedrins possible on first level
		case CLASS_NINJA:// kaedrins possible on first level
		case CLASS_SCOUT: // kaedrins possible on first level
			return SC_CLASS_BASE;
			break;
		
		case CLASS_TYPE_ARCANE_ARCHER:
		case CLASS_TYPE_ARCANE_SCHOLAR:
		case CLASS_TYPE_ARCANETRICKSTER:
		case CLASS_TYPE_ASSASSIN:
		case CLASS_TYPE_BLACKGUARD:
		case CLASS_TYPE_DUELIST:
		case CLASS_TYPE_DIVINECHAMPION:
		case CLASS_TYPE_DRAGONDISCIPLE:
		case CLASS_TYPE_DWARVENDEFENDER:
		case CLASS_TYPE_ELDRITCH_KNIGHT:
		case CLASS_TYPE_INVISIBLE_BLADE:
		case CLASS_TYPE_PALEMASTER:
		case CLASS_TYPE_RED_WIZARD:
		case CLASS_TYPE_SACREDFIST:
		case CLASS_TYPE_HARPER:
		case CLASS_TYPE_SHADOWDANCER:
		case CLASS_TYPE_SHADOWTHIEFOFAMN:
		case CLASS_TYPE_FRENZIEDBERSERKER:
		case CLASS_TYPE_WARPRIEST:
		case CLASS_TYPE_WEAPON_MASTER:
		case CLASS_TYPE_STORMLORD:
		case CLASS_TYPE_DOOMGUIDE:
		case CLASS_TYPE_HELLFIRE_WARLOCK:
			return SC_CLASS_PRC;
			break;
		
		case CLASS_ANOINTED_KNIGHT:
		case CLASS_TYPE_AVENGER:
		case CLASS_BLACK_FLAME_ZEALOT:
		case CLASS_DARK_LANTERN:
		case CLASS_DIVINE_SEEKER:
		// case CLASS_DRAGON_SAMURAI:
		case CLASS_DREAD_COMMANDO:
		case CLASS_ELEMENTAL_WARRIOR:
		case CLASS_ELEM_ARCHER:
		case CLASS_LION_TALISID:
		case CLASS_MASTER_RADIANCE:
		case CLASS_NATURES_WARRIOR:
		case CLASS_NIGHTSONG_ENFORCER:
		case CLASS_NIGHTSONG_INFILTRATOR:
		case CLASS_SHINING_BLADE:
		case CLASS_SKULLCLAN_HUNTER:
		case CLASS_STORMSINGER:
		case CLASS_TEMPEST:
		case CLASS_HOSPITALER:
		case CLASS_WARRIOR_DARKNESS:
		case CLASS_BLADESINGER: 
		case CLASS_WHIRLING_DERVISH:
		
		case CLASS_DEATHBLADE:
		case CLASS_OPTIMIST:
		case CLASS_ELDRITCH_DISCIPLE:
		
		case CLASS_SWORD_DANCER :

		case CLASS_DRAGON_WARRIOR:

		case CLASS_CHILD_NIGHT:
		case CLASS_DERVISH:
		case CLASS_GHOST_FACED_KILLER:
		case CLASS_DREAD_PIRATE:
		case CLASS_DAGGERSPELL_MAGE:
		case CLASS_DAGGERSPELL_SHAPER:
		case CLASS_WILD_STALKER:
		case CLASS_VERDANT_GUARDIAN:
		case CLASS_DISSONANT_CHORD:
					
			return SC_CLASS_KAEDRIN;
			break;
		
		case CLASS_FROST_MAGE:
		case CLASS_HEARTWARDER:
		case CLASS_FOREST_MASTER:			
		
		case CLASS_SWIFTBLADE:
		case CLASS_CHAMPION_WILD:
			return SC_CLASS_DISABLED;
			break;
				
		case CLASS_TYPE_ABERRATION:
		case CLASS_TYPE_ANIMAL:
		case CLASS_TYPE_BEAST:
		case CLASS_TYPE_COMMONER:
		case CLASS_TYPE_CONSTRUCT:
		case CLASS_TYPE_DRAGON:
		case CLASS_TYPE_ELEMENTAL:
		case CLASS_TYPE_FEY:
		case CLASS_TYPE_GIANT:
		case CLASS_TYPE_HUMANOID:
		case CLASS_TYPE_INVALID:
		case CLASS_TYPE_MAGICAL_BEAST:
		case CLASS_TYPE_MONSTROUS:
		case CLASS_TYPE_OOZE:
		case CLASS_TYPE_OUTSIDER:
		case CLASS_TYPE_SHAPECHANGER:
		case CLASS_TYPE_SHIFTER:
		case CLASS_TYPE_UNDEAD:
		case CLASS_TYPE_VERMIN:
			return SC_CLASS_NPC;
			break;
		
		default:
			return FALSE;
	}
	return FALSE;
}




//::///////////////////////////////////////////////
//:: GetSpellLevelByDC
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Determines the level of the cast spell
    
    Need to upgrade this to work in NWN2
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: July 30, 2004
//:://////////////////////////////////////////////

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSpellLevelByDC(object oCaster, int iClass, int iSpellSaveDC)
{

    return iSpellSaveDC-10-GetAbilityModifier(CSLGetMainStatByClass( iClass, "DC" ), oCaster);
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLMaxSpellLevelByClass( int iClass, int iClassLevel )
{
	int iMaxSpelLevel = 0;
	switch (iClass)
	{
		case CLASS_TYPE_BARD:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_bard", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_SORCERER:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_sorc", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_WIZARD:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_wiz", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_CLERIC:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_cler", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_DRUID:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_dru", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_PALADIN:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_pal", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_RANGER:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_rang", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_FAVORED_SOUL:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_sorc", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_SPIRIT_SHAMAN:
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_sorc", "NumSpellLevels", iClassLevel - 1));
			break;
		case CLASS_TYPE_WARLOCK: // not really applicable but good to know
			iMaxSpelLevel = StringToInt(Get2DAString("cls_spgn_wlck", "NumSpellLevels", iClassLevel - 1));
			//SendMessageToPC( OBJECT_SELF, "max spell is "+IntToString( iMaxSpelLevel )  );
			if ( iMaxSpelLevel == 1 ){ iMaxSpelLevel = 3; }
			else if ( iMaxSpelLevel == 2 ){ iMaxSpelLevel = 5; }
			else if ( iMaxSpelLevel == 3 ){ iMaxSpelLevel = 7; }
			else if ( iMaxSpelLevel == 4 ){ iMaxSpelLevel = 10; }
			else { iMaxSpelLevel = 10; }
			//if (DEBUGGING >= 6) { CSLDebug(  "max spell by class is "+IntToString( iMaxSpelLevel ),  OBJECT_SELF ); }
			break;
		default:
			iMaxSpelLevel = 0;

	}
	if (iMaxSpelLevel) iMaxSpelLevel--; // -1 CAUSE LEVEL 0 SPELL ABILITY RETURNS 1
	//if (DEBUGGING >= 6) { CSLDebug(  "Maximum class level is "+IntToString( iMaxSpelLevel ), OBJECT_SELF ); }
	return iMaxSpelLevel;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLMaxSpellLevel( int iClass, int iClassLevel, object oCaster = OBJECT_SELF )
{
	if ( !GetIsObjectValid(oCaster) ) { return 0;} // make sure it's only run on a valid object
	int iMaxSpelLevel = 0;
	if ( GetAssociateType(oCaster)==ASSOCIATE_TYPE_FAMILIAR )
	{
		//oCaster = GetMaster( oCaster );
		// Try this workaround instead soas to get the attributes for the master to stick to the familiar
		iMaxSpelLevel = CSLMaxSpellLevel( iClass, iClassLevel, GetMaster( oCaster ) );
		return iMaxSpelLevel;
	}
	/*
	int iPrimAbility = CSLGetMainStatByClass( iClass, "Spells" );
	
	int iCastingStat = -1;
	
	if ( iPrimAbility > -1 )
	{
		iCastingStat = CSLGetNaturalAbilityScore( oCaster, iPrimAbility );
	}
	else
	{
		// default to intelligence, if it uses this there is likely something wrong
		iCastingStat = CSLGetNaturalAbilityScore( oCaster, ABILITY_INTELLIGENCE );
	}
	
	iMaxSpelLevel = iCastingStat - 10;
	*/
	
	
	//if ( iClass == CLASS_TYPE_WARLOCK )
	//{
	//	return 10;
	//}
	
	//if (DEBUGGING >= 6) { CSLDebug(  "Maximum level by stat is "+IntToString( iMaxSpelLevel )+" using ability "+IntToString( iPrimAbility )+" with score of "+IntToString( iCastingStat ), oCaster ); }
	
	if ( iMaxSpelLevel > -1 )
	{
		iMaxSpelLevel = CSLGetMin( iMaxSpelLevel, CSLMaxSpellLevelByClass( iClass, iClassLevel ) );
	}
	else
	{
		return -1;
	}
	
	return iMaxSpelLevel;
	
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetClassBySpellId( object oCaster = OBJECT_SELF, int iSpellId = -1 )
{
	// this is only called when the default OEI code returns invalid 255
	// its' failover code to handle the fact that feats don't return the class involved
	
	int iClass = 255;
	
	// Lets see if we have a hint as to the actual class available
	// Then ensure we return the base caster class when these come up
	//if ( scSpellMetaData.iCurrentClass != 255 )
	//{
	//	iClass = CSLGetBaseClassBasedOnPRC( scSpellMetaData.iCurrentClass, oCaster );
	//	//iClass = SCSpellData.iCurrentClass;
	//	return iClass;
	//}
	
	if ( iSpellId == -1 )
	{
		int iSpellId = GetSpellId();
	}
	
	// this is used to get the caster class where it is hard to figure out, mainly due to feats not returning the class that did the spell
	// replace with constants
	//if (DEBUGGING >= 6) { CSLDebug(  "Spellid ="+IntToString(iSpellId), oCaster );
	
	switch ( iSpellId )
	{
		case 1762: //	ASN_Spellbook_1
		case 1701: //	ASN_Spellbook_2
		case 1705: //	ASN_Spellbook_3
		case 1710: //	ASN_Spellbook_4
		case 1698: //	ASN_GhostlyVisage
		case 1699: //	ASN_Sleep
		case 1700: //	ASN_True_Strike
		case 1702: //	ASN_Cats_Grace
		case 1703: //	ASN_Foxs_Cunning
		case 1704: //	ASN_Darkness
		case 1706: //	ASN_Invisibility
		case 1711: //	ASN_ImprovedInvisibility
		case 1707: //	ASN_Deep_Slumber
		case 1708: //	ASN_False_Life
		case 1709: //	ASN_Magic_Circle_against_Good
		case 1712: //	ASN_Freedom_of_Movement
		case 1713: //	ASN_Poison
		case 1714: //	ASN_Clairaudience_and_Clairvoyance
		case SPELLABILITY_AS_INVISIBILITY:
		case SPELLABILITY_AS_GHOSTLY_VISAGE:
			iClass = CLASS_TYPE_ASSASSIN;
			break;
		case 611:
		case 612:
		case 1715: //	BG_Spellbook_1
		case 1720: //	BG_Spellbook_2
		case 1726: //	BG_Spellbook_3
		case 1731: //	BG_Spellbook_4
		case 1735: //	BG_Poison
		case 1716: //	BG_BullsStrength
		case 1724: //	BG_Eagle_Splendor
		case 1717: //	BG_Magic_Weapon
		case 1718: //	BG_Doom
		case 1719: //	BG_Cure_Light_Wounds
		case 1721: //	BG_InflictSerious
		case 1733: //	BG_Cure_Critical_Wounds
		case 1723: //	BG_Cure_Moderate_Wounds
		case 1728: //	BG_Cure_Serious_Wounds
		case 1732: //	BG_InflictCritical
		case 1725: //	BG_Death_Knell
		case 1727: //	BG_Contagion
		case 1729: //	BG_Protection_from_Energy
		case 1730: //	BG_Summon_Creature_III
		case 1734: //	BG_Freedom_of_Movement
		case 1722: //	BG_Darkness
			iClass = CLASS_TYPE_BLACKGUARD;
			break;
		
		case 636: //	Hellball
		case 637: //	Mummy_Dust
		case 638: //	Dragon_Knight
		case 639: //	Epic_Mage_Armor
		case 640: //	Ruin
		case 695: //	Epic_Warding
		case 1076: //	Damnation
		case 1078: //	Epic_Gate
		case 1077: //	Entropic_Husk
		case 1079: //	Mass_Fowl
		case 1080: //	Vampiric_Feast
			// assuming this is coming from their best caster class and that cache stats has been run, which usually is the case
			iClass = GetLocalInt(oCaster, "SC_iBestCasterClass" );
			if ( iClass == 0 ) { iClass = 255; } // if cache stats was not run, this would return barbarian
			break;
		/*	
		case SPELL_BLADE_BARRIER:
		case SPELL_BLADE_BARRIER_SELF:
		case SPELL_BLADE_BARRIER_WALL:
			iClass = GetLocalInt(oCaster, "SC_iBestDivineClass" );
			break;	*/
		default:
			// not any class involved, return 255 for invalid we'll deal with it in the failover code in each script
			iClass = 255;
	}
	
	return iClass;	
}







/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetRogueLevel( object oCaster = OBJECT_SELF)
{
	int iLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oCaster);
	iLevel += GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oCaster);
	iLevel += GetLevelByClass(CLASS_TYPE_ASSASSIN, oCaster);
	iLevel += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oCaster);
	iLevel += GetLevelByClass(CLASS_TYPE_AVENGER, oCaster);
	iLevel += GetLevelByClass(CLASS_NIGHTSONG_INFILTRATOR, oCaster);
	iLevel += GetLevelByClass(CLASS_NIGHTSONG_ENFORCER, oCaster);
	iLevel += GetLevelByClass(CLASS_TYPE_SHADOWTHIEFOFAMN, oCaster);
	iLevel += GetLevelByClass(CLASS_THUG, oCaster);
	return iLevel;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetWildShapeLevel( object oCaster = OBJECT_SELF)
{
	int iLevel = GetLevelByClass(CLASS_TYPE_DRUID, oCaster);
	iLevel += CSLGetMax(GetLevelByClass(CLASS_LION_TALISID, oCaster)-2,0);
	iLevel += GetLevelByClass(CLASS_NATURES_WARRIOR, oCaster);
	iLevel += GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oCaster);
	return iLevel;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetBaseClassBasedOnPRC( int iClass, object oCaster = OBJECT_SELF )
{
	// Used to get the parent class for spellcasters, such as palemasters
	// who could be a bard, wizard, sorceror or the like
	if ( iClass == CLASS_TYPE_BARD ) { return CLASS_TYPE_BARD; }
	else if ( iClass == CLASS_TYPE_DRUID ) { return CLASS_TYPE_DRUID; }
	else if ( iClass == CLASS_TYPE_PALADIN ) { return CLASS_TYPE_PALADIN; }
	else if ( iClass == CLASS_TYPE_RANGER ) { return CLASS_TYPE_RANGER; }
	else if ( iClass == CLASS_TYPE_FAVORED_SOUL ) { return CLASS_TYPE_FAVORED_SOUL; }
	else if ( iClass == CLASS_TYPE_SPIRIT_SHAMAN ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
	else if ( iClass == CLASS_TYPE_SORCERER ) { return CLASS_TYPE_SORCERER; }
	else if ( iClass == CLASS_TYPE_WARLOCK ) { return CLASS_TYPE_WARLOCK; }
	else if ( iClass == CLASS_TYPE_WIZARD ) { return CLASS_TYPE_WIZARD; }
	else if ( iClass == CLASS_TYPE_CLERIC ) { return CLASS_TYPE_CLERIC; }
	else if ( iClass == CLASS_TYPE_ASSASSIN ) { return CLASS_TYPE_ASSASSIN; }
	else if ( iClass == CLASS_TYPE_BLACKGUARD ) { return CLASS_TYPE_BLACKGUARD; }	
	else if ( iClass == CLASS_TYPE_ARCANE_SCHOLAR )
	{
		if( GetHasFeat( FEAT_ARCANE_SCHOLAR_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_ARCANE_SCHOLAR_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_ARCANE_SCHOLAR_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_TYPE_ARCANETRICKSTER )
	{ 
		if( GetHasFeat( FEAT_ARCTRICKSTER_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_ARCTRICKSTER_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_ARCTRICKSTER_SPELLCASTING_WARLOCK, oCaster ) ) { return CLASS_TYPE_WARLOCK; }
		if( GetHasFeat( FEAT_ARCTRICKSTER_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_BLACK_FLAME_ZEALOT )
	{
		if( GetHasFeat( FEAT_BFZ_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_BFZ_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_BFZ_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_BFZ_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_BFZ_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_BFZ_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	else if ( iClass == CLASS_BLADESINGER )
	{
		if( GetHasFeat( FEAT_BLADESINGER_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_BLADESINGER_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_BLADESINGER_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	/*
	else if ( iClass == CLASS_TYPE_CONTEMPLATIVE )
	{
		if( GetHasFeat( FEAT_CONTEMPLATIVE_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_BARD; } //
		if( GetHasFeat( FEAT_CONTEMPLATIVE_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; } //
		if( GetHasFeat( FEAT_CONTEMPLATIVE_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }//
		if( GetHasFeat( FEAT_CONTEMPLATIVE_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }//
		return iClass;
	}
	*/
	else if ( iClass == CLASS_TYPE_ELDRITCH_KNIGHT )
	{ 
		if( GetHasFeat( FEAT_ELDRITCH_KNIGHT_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_ELDRITCH_KNIGHT_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_ELDRITCH_KNIGHT_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_FOREST_MASTER )
	{
		if( GetHasFeat( FEAT_FOREST_MASTER_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_FOREST_MASTER_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_FOREST_MASTER_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_FOREST_MASTER_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_FOREST_MASTER_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_FOREST_MASTER_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	else if ( iClass == CLASS_FROST_MAGE )
	{
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		if( GetHasFeat( FEAT_FROSTMAGE_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_TYPE_HARPER )
	{ 
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_WARLOCK, oCaster ) ) { return CLASS_TYPE_WARLOCK; }
		if( GetHasFeat( FEAT_HARPER_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_HEARTWARDER )
	{
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_WARLOCK, oCaster ) ) { return CLASS_TYPE_WARLOCK; }
		if( GetHasFeat( FEAT_HEARTWARDER_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_HOSPITALER )
	{
		if( GetHasFeat( FEAT_HOSPITALER_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_HOSPITALER_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_HOSPITALER_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_HOSPITALER_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_HOSPITALER_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_HOSPITALER_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	else if ( iClass == CLASS_LION_TALISID )
	{
		if( GetHasFeat( FEAT_LION_TALISID_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_LION_TALISID_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_LION_TALISID_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_LION_TALISID_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_LION_TALISID_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_LION_TALISID_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	else if ( iClass == CLASS_MASTER_RADIANCE )
	{
		if( GetHasFeat( FEAT_MASTER_RADIANCE_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_MASTER_RADIANCE_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_MASTER_RADIANCE_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_MASTER_RADIANCE_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_MASTER_RADIANCE_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_MASTER_RADIANCE_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	/*/
	else if ( iClass == CLASS_TYPE_MYSTICTHEURGE )
	{
		if( GetHasFeat( FEAT_MYSTICTHEURGE_SPELLCASTING_BARD, oChar ) ) { return CLASS_TYPE_BARD; } //
		if( GetHasFeat( FEAT_MYSTICTHEURGE_SPELLCASTING_CLERIC, oChar ) ) { return CLASS_TYPE_CLERIC; } //
		if( GetHasFeat( FEAT_MYSTICTHEURGE_SPELLCASTING_DRUID, oChar ) ) { return CLASS_TYPE_DRUID; }//
		if( GetHasFeat( FEAT_MYSTICTHEURGE_SPELLCASTING_PALADIN, oChar ) ) { return CLASS_TYPE_PALADIN; } //
		if( GetHasFeat( FEAT_MYSTICTHEURGE_SPELLCASTING_RANGER, oChar ) ) { return CLASS_TYPE_RANGER; }//
		if( GetHasFeat( FEAT_MYSTICTHEURGE_SPELLCASTING_SORCERER, oChar ) ) { return CLASS_TYPE_SORCERER; } //
		if( GetHasFeat( FEAT_MYSTICTHEURGE_SPELLCASTING_WARLOCK, oChar ) ) { return CLASS_TYPE_WARLOCK; }//
		if( GetHasFeat( FEAT_MYSTICTHEURGE_SPELLCASTING_WIZARD, oChar ) ) { return CLASS_TYPE_WIZARD; } //
		return iClass;
	}
	//*/
	else if ( iClass == CLASS_NATURES_WARRIOR )
	{
		if( GetHasFeat( FEAT_NATWAR_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_NATWAR_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		return iClass;
	}
	else if ( iClass == CLASS_NWNINE_WARDER )
	{ 
		if( GetHasFeat( FEAT_NW9_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_NW9_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_NW9_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_NW9_SPELLCASTING_WARLOCK, oCaster ) ) { return CLASS_TYPE_WARLOCK; }
		if( GetHasFeat( FEAT_NW9_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_TYPE_PALEMASTER )
	{ 
		if( GetHasFeat( FEAT_PALE_MASTER_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_PALE_MASTER_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_PALE_MASTER_SPELLCASTING_WARLOCK, oCaster ) ) { return CLASS_TYPE_WARLOCK; }
		if( GetHasFeat( FEAT_PALE_MASTER_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_TYPE_RED_WIZARD )
	{ 
		if( GetHasFeat( FEAT_RED_WIZARD_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_TYPE_SACREDFIST )
	{
		if( GetHasFeat( FEAT_SACREDFIST_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_SACREDFIST_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_SACREDFIST_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_SACREDFIST_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_SACREDFIST_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_SACREDFIST_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_SACREDFIST_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	else if ( iClass == CLASS_SHINING_BLADE )
	{
		if( GetHasFeat( FEAT_SHINING_BLADE_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_SHINING_BLADE_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_SHINING_BLADE_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_SHINING_BLADE_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_SHINING_BLADE_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_SHINING_BLADE_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	else if ( iClass == CLASS_TYPE_STORMLORD )
	{ 
		if( GetHasFeat( FEAT_STORMLORD_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_STORMLORD_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_STORMLORD_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_STORMLORD_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_STORMLORD_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_STORMLORD_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	else if ( iClass == CLASS_STORMSINGER )
	{
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		if( GetHasFeat( FEAT_STORMSINGER_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_SWIFTBLADE )
	{
		if( GetHasFeat( FEAT_SWIFTBLADE_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_SWIFTBLADE_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_SWIFTBLADE_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	else if ( iClass == CLASS_TYPE_WARPRIEST )
	{ 
	
		if( GetHasFeat( FEAT_WARPRIEST_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }		
		if( GetHasFeat( FEAT_WARPRIEST_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_WARPRIEST_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_WARPRIEST_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_WARPRIEST_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_WARPRIEST_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	else if ( iClass == CLASS_ELDRITCH_DISCIPLE )
	{ 
	
		if( GetHasFeat( FEAT_ELDDISC_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }		
		if( GetHasFeat( FEAT_ELDDISC_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_ELDDISC_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_ELDDISC_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_ELDDISC_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_ELDDISC_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		if( GetHasFeat( FEAT_ELDDISC_SPELLCASTING_WARLOCK, oCaster ) ) { return CLASS_TYPE_WARLOCK; }
		return iClass;
	}

	else if ( iClass == CLASS_KNIGHT_TIERDRIAL )
	{
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_WARLOCK, oCaster ) ) { return CLASS_TYPE_WARLOCK; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_ASSASSIN, oCaster ) ) { return CLASS_TYPE_ASSASSIN; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_AVENGER, oCaster ) ) { return CLASS_TYPE_AVENGER; }
		if( GetHasFeat( FEAT_KOT_SPELLCASTING_BLACKGUARD, oCaster ) ) { return CLASS_TYPE_BLACKGUARD; }

		return iClass;
	}
	
	else if ( iClass == CLASS_SHADOWBANE_STALKER )
	{
		if( GetHasFeat( FEAT_SHDWSTLKR_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_SHDWSTLKR_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_SHDWSTLKR_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_SHDWSTLKR_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_SHDWSTLKR_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_SHDWSTLKR_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		return iClass;
	}
	
	else if ( iClass == CLASS_DRAGONSLAYER )
	{
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_WARLOCK, oCaster ) ) { return CLASS_TYPE_WARLOCK; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_ASSASSIN, oCaster ) ) { return CLASS_TYPE_ASSASSIN; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_AVENGER, oCaster ) ) { return CLASS_TYPE_AVENGER; }
		if( GetHasFeat( FEAT_DRSLR_SPELLCASTING_BLACKGUARD, oCaster ) ) { return CLASS_TYPE_BLACKGUARD; }

		return iClass;
	}
	
	else if ( iClass == CLASS_LYRIC_THAUMATURGE )
	{
		if( GetHasFeat( FEAT_LYRIC_THAUM_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		return iClass;
	}
	
	else if ( iClass == CLASS_CANAITH_LYRIST )
	{
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_BARD, oCaster ) ) { return CLASS_TYPE_BARD; }
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_CLERIC, oCaster ) ) { return CLASS_TYPE_CLERIC; }
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_DRUID, oCaster ) ) { return CLASS_TYPE_DRUID; }
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_FAVORED_SOUL, oCaster ) ) { return CLASS_TYPE_FAVORED_SOUL; }
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_PALADIN, oCaster ) ) { return CLASS_TYPE_PALADIN; }
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_RANGER, oCaster ) ) { return CLASS_TYPE_RANGER; }
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_SORCERER, oCaster ) ) { return CLASS_TYPE_SORCERER; }
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_SPIRIT_SHAMAN, oCaster ) ) { return CLASS_TYPE_SPIRIT_SHAMAN; }
		if( GetHasFeat( FEAT_CANAITH_SPELLCASTING_WIZARD, oCaster ) ) { return CLASS_TYPE_WIZARD; }
		return iClass;
	}
	
	
	
	/*
	else if ( iClass == CLASS_TYPE_SHIFTER )
	{
	
	}
	else if ( iClass == CLASS_TYPE_DIVINECHAMPION )
	{ 
	
	}
	*/
	return iClass;

}

/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLClassLevels( object oPC, int bAbbrClass = FALSE, int bShowLevels = TRUE  )
{
   int iClass1 = GetClassByPosition(1, oPC);
   int iClass2 = GetClassByPosition(2, oPC);
   int iClass3 = GetClassByPosition(3, oPC);
   int iClass4 = GetClassByPosition(4, oPC);
   int iClassLevel1 = GetLevelByClass(iClass1, oPC);
   int iClassLevel2 = GetLevelByClass(iClass2, oPC);
   int iClassLevel3 = GetLevelByClass(iClass3, oPC);
   int iClassLevel4 = GetLevelByClass(iClass4, oPC);
   string sClasses;
   if (!bShowLevels)
   {
      int nMax = CSLGetMax(CSLGetMax(CSLGetMax(iClassLevel1, iClassLevel2), iClassLevel3), iClassLevel4);
      if (nMax==iClassLevel1) { return "<color=steelblue>"+CSLGetClassesDataName(iClass1, bAbbrClass)+"</color>"; }
      if (nMax==iClassLevel2) { return "<color=steelblue>"+CSLGetClassesDataName(iClass2, bAbbrClass)+"</color>"; }
      if (nMax==iClassLevel3) { return "<color=steelblue>"+CSLGetClassesDataName(iClass3, bAbbrClass)+"</color>"; }
      if (nMax==iClassLevel4) { return "<color=steelblue>"+CSLGetClassesDataName(iClass4, bAbbrClass)+"</color>"; }
      return "Unknown Class";
   }
   int iLevel = GetHitDice(oPC);
   sClasses = "<color=steelblue>"+CSLGetClassesDataName(iClass1, bAbbrClass)+"</color>";
   if (bShowLevels) sClasses += "<color=white> "+IntToString(iClassLevel1)+"</color>";
   if (iClass2 != CLASS_TYPE_INVALID) {
      sClasses += "<color=white> / </color><color=steelblue>"+CSLGetClassesDataName(iClass2, bAbbrClass)+"</color>";
      if (bShowLevels) sClasses += "<color=white> "+IntToString(iClassLevel2)+"</color>";
   }
   if (iClass3 != CLASS_TYPE_INVALID) {
      sClasses += "<color=white> / </color><color=steelblue>"+CSLGetClassesDataName(iClass3, bAbbrClass)+"</color>";
      if (bShowLevels) sClasses += "<color=white> "+IntToString(iClassLevel3)+"</color>";
   }
   if (iClass4 != CLASS_TYPE_INVALID) {
      sClasses += "<color=white> / </color><color=steelblue>"+CSLGetClassesDataName(iClass4, bAbbrClass)+"</color>";
      if (bShowLevels) sClasses += "<color=white> "+IntToString(iClassLevel4)+"</color>";
   }
   return sClasses;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLFixFavoredWeaponFeat( object oPC )
{
	if (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) > 0)
	{
		int iFeat = CSLGetDeityDataFavoredWeapon( GetDeity( oPC ) );

		if ( iFeat != -1 && !GetHasFeat(iFeat, oPC))
		{
			FeatAdd(oPC, iFeat, FALSE);
		}
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLFixCounterspellFeat( object oPC )
{
	
	if ( !GetHasFeat(FEAT_COUNTERSPELL, oPC))
	{
		if ( GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 3 ||
		GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 3 ||
		GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0 ||
		GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 )
		{
			FeatAdd(oPC, FEAT_COUNTERSPELL, FALSE);
		}
		// iClass == CLASS_TYPE_WARLOCK not a caster really since not spells -  also overpowered if they do have spells
		//iClass == CLASS_TYPE_ASSASSIN  - need ot really figure out how this works since it's feat vs feat really
		//iClass == CLASS_TYPE_BLACKGUARD - need ot really figure out how this works since it's feat vs feat really
	}

}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLIsCharacterFirstClassValid( object oPC )
{
	if ( !GetIsPC(oPC) )
	{
		return TRUE;
	}
	
	int iBaseClass = ( GetClassByPosition( 1, oPC ) );
	
	if ( CSLGetClassType( iBaseClass ) == SC_CLASS_BASE )
	{
		return TRUE;
	}
	
	return FALSE;
}

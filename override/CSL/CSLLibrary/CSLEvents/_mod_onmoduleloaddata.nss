//#include "_inc_helper_functions"
#include "_CSLCore_ObjectVars"
//#include "_SCInclude_Chat"

void main()
{
	CSLGetPreferenceDataObject(); // this just makes sure its loaded, should already be loaded
	
	SendMessageToPC(GetFirstPC(),"Loading Data");
	
	if ( !CSLPreferencesGetIsLoaded( ) )
	{
		//SendMessageToPC( GetFirstPC(), "Not Yet Loaded, trying again");
		// Dataobjects are not loaded yet, delay this script until they are ready
		DelayCommand( 15.0f, ExecuteScript("_mod_onmoduleloaddata", OBJECT_SELF) );
		return;
	}
	
		// DataObjectLoadOption can have the following values
	//    Cache - saves objects to bioware db as items, restores them on module start and if not found it loads them
	//    ReLoad - reload all values on module start - takes about 13 minutes
	//    Off - don't load it at all
	string sLoadOption = GetStringUpperCase( CSLGetPreferenceString( "DataObjectLoadOption", "OFF" ) );

	
	// tome of battle is required
	if ( CSLGetPreferenceSwitch( "EnableTomeOfBattle", FALSE) )
	{
		object oManeuversTable;
		if ( sLoadOption == "CACHE" )
		{
			 oManeuversTable = CSLDataObjectRetrieve( "maneuvers" );
		}
		if ( !GetIsObjectValid( oManeuversTable ) )
		{
			oManeuversTable = CSLDataObjectGet( "maneuvers", TRUE );
			CSLDataTableConfigure( oManeuversTable, "maneuvers", "StrRef,Type,Script,ICON,Level,Location,Mastery,Movement,SupressAoO,IsStance,Discipline,Range,Description","tlkref" );
			DelayCommand( CSLRandomBetweenFloat( 0.25f, 12.0f ), CSLDataTableLoad2da( oManeuversTable ) );
		}
	}
	
	// this is required
	if ( CSLGetPreferenceSwitch( "DataObjectLoadLanguages", FALSE) )
	{
		object oLanguagesTable;
		if ( sLoadOption == "CACHE" )
		{
			 oLanguagesTable = CSLDataObjectRetrieve( "languages" );
		}
		if ( !GetIsObjectValid( oLanguagesTable ) )
		{
			oLanguagesTable = CSLDataObjectGet( "languages", TRUE );
			CSLDataTableConfigure( oLanguagesTable, "csl_languages", "Label,Name,AltLabel,AltLabel2,Icon,Type,TranslateTable,BlockTable,FeatId,DMGranted,Difficulty,Family,SubGroup", "index,indexref,index,index", ",", "", "", "_mod_onmoduleloadlanguage" );
			DelayCommand( CSLRandomBetweenFloat( 0.25f, 12.0f ), CSLDataTableLoad2da( oLanguagesTable ) );
		}
	}
	
	
	if ( sLoadOption == "OFF" )
	{
		//SendMessageToPC(GetFirstPC(),"This is Off");
		//SendMessageToPC(GetFirstPC(),"Off");
		return;
	}
	
	// not sure if this is needed but this being on a module can force a full reload of the items involved
	if ( sLoadOption == "CACHE" && GetLocalInt( GetModule(), "CSL_DATAOBJECT_FORCE_RELOAD") )
	{
		sLoadOption == "ReLoad"; // force a reload, perhaps new 2da's so don't use the cache
	}
	
	object oAppearanceTable;
	if ( sLoadOption == "CACHE" )
	{
		 oAppearanceTable = CSLDataObjectRetrieve( "appearance" );
		 SendMessageToPC(GetFirstPC(),"Loading Appearance from Cache");
	}
	if ( !GetIsObjectValid( oAppearanceTable ) )
	{
		SendMessageToPC(GetFirstPC(),"Loading Appearance");
		oAppearanceTable = CSLDataObjectGet( "appearance", TRUE );
		CSLDataTableConfigure( oAppearanceTable, "appearance", "LABEL,PREFATCKDIST,HITDIST", "", ",", "alphabetical" ); // trying this out at this point
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oAppearanceTable ) );
	}
	//DelayCommand( CSLRandomBetweenFloat( 24.25f, 28.0f ), CSLDataTableSortByPrefix( oAppearanceTable ) );
	
	object oClassTable;
	if ( sLoadOption == "CACHE" )
	{
		 oClassTable = CSLDataObjectRetrieve( "classes" );
	}
	if ( !GetIsObjectValid( oClassTable ) )
	{
		oClassTable = CSLDataObjectGet( "classes", TRUE );
		CSLDataTableConfigure( oClassTable, "classes", "Label,Name,Icon,BonusCasterFeatByClassMap,FEATPracticedSpellcaster,HasDivine,HasArcane,SpellAbil,MemorizesSpells,HasInfiniteSpells,AllSpellsKnown,HasDomains,Abbrev", "string,tlkref", "," );
		DelayCommand( CSLRandomBetweenFloat( 0.25f, 12.0f ), CSLDataTableLoad2da( oClassTable ) );
	}
	
	
	object oRaceTable;
	if ( sLoadOption == "CACHE" )
	{
		 oClassTable = CSLDataObjectRetrieve( "racialsubtypes" );
	}
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		oRaceTable = CSLDataObjectGet( "racialsubtypes", TRUE );
		CSLDataTableConfigure( oRaceTable, "racialsubtypes", "Label,BaseRace,Name,ECL,ECLCap,StrAdjust,DexAdjust,ConAdjust,IntAdjust,WisAdjust,ChaAdjust,AppearanceIndex", "string,tlkref", "," );
		DelayCommand( CSLRandomBetweenFloat( 0.25f, 12.0f ), CSLDataTableLoad2da( oRaceTable ) );
	}
	
	
	object oBaseItemsTable;
	if ( sLoadOption == "CACHE" )
	{
		 oBaseItemsTable = CSLDataObjectRetrieve( "baseitems" );
	}
	if ( !GetIsObjectValid( oBaseItemsTable ) )
	{
		oBaseItemsTable = CSLDataObjectGet( "baseitems", TRUE );
		CSLDataTableConfigure( oBaseItemsTable, "baseitems", "label,Name,PrefAttackDist,NumDice,DieToRoll,CritThreat,CritHitMult,FEATImprCrit,FEATWpnFocus,FEATWpnSpec,FEATEpicDevCrit,FEATEpicWpnFocus,FEATEpicWpnSpec,FEATOverWhCrit,FEATWpnOfChoice,FEATGrtrWpnFocus,FEATGrtrWpnSpec,FEATPowerCrit,ReqFeat0,ReqFeat1,ReqFeat2,ReqFeat3,ReqFeat4,ReqFeat5","string,tlkref" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oBaseItemsTable ) );
	}
	
	object oIprpFeatsTable;
	if ( sLoadOption == "CACHE" )
	{
		 oIprpFeatsTable = CSLDataObjectRetrieve( "iprp_feats" );
	}
	if ( !GetIsObjectValid( oIprpFeatsTable ) )
	{
		oIprpFeatsTable = CSLDataObjectGet( "iprp_feats", TRUE );
		CSLDataTableConfigure( oIprpFeatsTable, "iprp_feats", "Label,FeatIndex" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oIprpFeatsTable ) );
	}
	
	object oAmbientSoundTable;
	if ( sLoadOption == "CACHE" )
	{
		 oAmbientSoundTable = CSLDataObjectRetrieve( "ambientsound" );
	}
	if ( !GetIsObjectValid( oAmbientSoundTable ) )
	{
		oAmbientSoundTable = CSLDataObjectGet( "ambientsound", TRUE );
		CSLDataTableConfigure( oAmbientSoundTable, "ambientsound", "Description,Resource", "tlkref" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oAmbientSoundTable ) );
	}
	
	object oAmbientMusicTable;
	if ( sLoadOption == "CACHE" )
	{
		 oAmbientMusicTable = CSLDataObjectRetrieve( "ambientmusic" );
	}
	if ( !GetIsObjectValid( oAmbientMusicTable ) )
	{
		oAmbientMusicTable = CSLDataObjectGet( "ambientmusic", TRUE );
		CSLDataTableConfigure( oAmbientMusicTable, "ambientmusic", "Description", "tlkref" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oAmbientMusicTable ) );
	}
	
	object oVisualEffectsTable;
	if ( sLoadOption == "CACHE" )
	{
		 oVisualEffectsTable = CSLDataObjectRetrieve( "visualeffects" );
	}
	if ( !GetIsObjectValid( oVisualEffectsTable ) )
	{
		oVisualEffectsTable = CSLDataObjectGet( "visualeffects", TRUE );
		CSLDataTableConfigure( oVisualEffectsTable, "visualeffects", "Label", "", ",", "alphabetical" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oVisualEffectsTable ) );
	}
	
	object oSkillsTable;
	if ( sLoadOption == "CACHE" )
	{
		 oSkillsTable = CSLDataObjectRetrieve( "skills" );
	}
	if ( !GetIsObjectValid( oSkillsTable ) )
	{
		oSkillsTable = CSLDataObjectGet( "skills", TRUE );
		CSLDataTableConfigure( oSkillsTable, "skills", "Label,Name,Icon,KeyAbility", "string,tlkref" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oSkillsTable ) );
	}
	
	object oItemValueTable;
	if ( sLoadOption == "CACHE" )
	{
		 oItemValueTable = CSLDataObjectRetrieve( "itemvalue" );
	}
	if ( !GetIsObjectValid( oItemValueTable ) )
	{
		oItemValueTable = CSLDataObjectGet( "itemvalue", TRUE );
		CSLDataTableConfigure( oItemValueTable, "itemvalue", "Label" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oItemValueTable ) );
	}
	
	object oDiseaseTable;
	if ( sLoadOption == "CACHE" )
	{
		 oDiseaseTable = CSLDataObjectRetrieve( "disease" );
	}
	if ( !GetIsObjectValid( oDiseaseTable ) )
	{
		oDiseaseTable = CSLDataObjectGet( "disease", TRUE );
		CSLDataTableConfigure( oDiseaseTable, "disease", "Label" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oDiseaseTable ) );
	}
	
	object oPoisonTable;
	if ( sLoadOption == "CACHE" )
	{
		 oPoisonTable = CSLDataObjectRetrieve( "poison" );
	}
	if ( !GetIsObjectValid( oPoisonTable ) )
	{
		oPoisonTable = CSLDataObjectGet( "poison", TRUE );
		CSLDataTableConfigure( oPoisonTable, "poison", "Label" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oPoisonTable ) );
	}
	
	object oPolymorphTable;
	if ( sLoadOption == "CACHE" )
	{
		 oPolymorphTable = CSLDataObjectRetrieve( "polymorph" );
	}
	if ( !GetIsObjectValid( oPolymorphTable ) )
	{
		oPolymorphTable = CSLDataObjectGet( "polymorph", TRUE );
		CSLDataTableConfigure( oPolymorphTable, "polymorph", "Name" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oPolymorphTable ) );
	}
	
	object oAnimModesTable;
	if ( sLoadOption == "CACHE" )
	{
		 oAnimModesTable = CSLDataObjectRetrieve( "anim_modes" );
	}
	if ( !GetIsObjectValid( oAnimModesTable ) )
	{
		oAnimModesTable = CSLDataObjectGet( "anim_modes", TRUE );
		CSLDataTableConfigure( oAnimModesTable, "anim_modes", "LABEL,RangeStart,ActionMode,StartScript,StopScript", "string,index" ); // , ",", "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoad2da( oAnimModesTable ) );
	}
	
	object oDeitiesTable;
	if ( sLoadOption == "CACHE" )
	{
		 oDeitiesTable = CSLDataObjectRetrieve( "deities" );
	}
	if ( !GetIsObjectValid( oDeitiesTable ) )
	{
		oDeitiesTable = CSLDataObjectGet( "deities", TRUE );
		CSLDataTableConfigure( oDeitiesTable, "nwn2_deities", "NameStringref,FavoredWeaponProficiency,FavoredWeaponFocus,FavoredWeaponSpecialization", "indexref,string" ); // , ",", "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z" );
		DelayCommand( CSLRandomBetweenFloat( 6.25f, 24.0f ), CSLDataTableLoad2da( oDeitiesTable ) );
	}
	
	object oAreasTable;
	if ( sLoadOption == "CACHE" )
	{
		 oAreasTable = CSLDataObjectRetrieve( "areas" );
	}
	if ( !GetIsObjectValid( oAreasTable ) )
	{
		oAreasTable = CSLDataObjectGet( "areas", TRUE );
		CSLDataTableConfigure( oAreasTable, "areas", "Name,objectid", "", ",", "alphabetical" );
		DelayCommand( CSLRandomBetweenFloat( 12.25f, 64.0f ), CSLDataTableLoadAreas( oAreasTable ) );
	}
	
	if ( CSLGetPreferenceSwitch( "DataObjectLoadSpells", FALSE) )
	{
		object oSpellsTable;
		if ( sLoadOption == "CACHE" )
		{
			 oSpellsTable = CSLDataObjectRetrieve( "spells" );
		}
		if ( !GetIsObjectValid( oSpellsTable ) )
		{
			oSpellsTable = CSLDataObjectGet( "spells", TRUE ); 
			CSLDataTableConfigure( oSpellsTable, "spells", "Label,NAME,IconResRef,Innate,Icon,School,Range,TargetType,iprpreference", "string,tlkref", ",", "alphabetical", "NAME", "_mod_onmoduleloadspellbooks" ); // , ",", "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
			DelayCommand( CSLRandomBetweenFloat( 0.25f, 12.0f ), CSLDataTableLoad2da( oSpellsTable ) );
		}
	}
		
	if ( CSLGetPreferenceSwitch( "DataObjectLoadFeats", FALSE) )
	{
		object oFeatsTable;
		if ( sLoadOption == "CACHE" )
		{
			 oFeatsTable = CSLDataObjectRetrieve( "feat" );
		}
		if ( !GetIsObjectValid( oFeatsTable ) )
		{
			oFeatsTable = CSLDataObjectGet( "feat", TRUE ); // iprpreference is a cross reference to iprp_feats, built after loading the 2da
			CSLDataTableConfigure( oFeatsTable, "feat", "LABEL,FEAT,ICON,ALLCLASSESCANUSE,FeatCategory,iprpreference,SPELLID,AlignRestrict,MAXCHA,MAXCON,MAXDEX,MAXINT,MaxLevel,MAXSTR,MAXWIS,MINATTACKBONUS,MINCHA,MINCON,MINDEX,MinFortSave,MININT,MinLevel,MinLevelClass,MINSTR,MINWIS,OrReqFeat0,OrReqFeat1,OrReqFeat2,OrReqFeat3,OrReqFeat4,OrReqFeat5,PREREQFEAT1,PREREQFEAT2,REQSKILL,REQSKILL2,ReqSkillMaxRanks,ReqSkillMaxRanks2,ReqSkillMinRanks,ReqSkillMinRanks2", "string,tlkref", ",", "alphabetical", "FEAT" ); // , ",", "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
			DelayCommand( CSLRandomBetweenFloat( 0.25f, 12.0f ), CSLDataTableLoad2da( oFeatsTable ) );
		}
	}
	

	
}
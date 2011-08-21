/*
* Loads all the language data being used by the module
*/
#include "_SCInclude_Language"
//#include "_SCInclude_Chat"

void main()
{
	//SendMessageToPC( GetFirstPC(), "Loading Language data now...");
	//return;
	// this is actually integrated the loading with getting, just because it's needed regardless of anything else being set up
	//DelayCommand( CSLRandomBetweenFloat( 0.1f, 0.25f ), CSLGetPreferenceDataObject() );
	CSLGetPreferenceDataObject(); // this just makes sure its loaded, should already be loaded
	
	float fLoadInterval = 3.0f;
	if (GetIsSinglePlayer())
	{
		fLoadInterval = 6.0f;
	}
	
	string sLoadOption = GetStringUpperCase( CSLGetPreferenceString( "DataObjectLoadOption", "OFF" ) );
	if ( sLoadOption == "OFF" )
	{
		return;
	}
	
	if ( CSLGetPreferenceSwitch( "DataObjectLoadLanguages", FALSE) ) // master config which makes languages go on or off
	{
		object oLanguageTable = CSLDataObjectGet( "languages" );
	
		int iRow, iCurrent;
		string sName, sTranslateTable;
		int iLanguageCount = CSLDataTableCount( oLanguageTable );
		
		for ( iCurrent = 0; iCurrent <= iLanguageCount; iCurrent++) 
		{
			iRow = CSLDataTableGetRowByIndex( oLanguageTable, iCurrent );
			
			
			
			if ( iRow > -1 )
			{
				sName = CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow );
				sTranslateTable = CSLDataTableGetStringByRow( oLanguageTable, "TranslateTable", iRow );
				
				// this makes a new language object each iteration
				object oLanguagesTable;
				
				if ( sLoadOption == "CACHE" )
				{
					 oLanguagesTable = CSLDataObjectRetrieve( "language_"+GetStringLowerCase(sName) );
				}
				if ( !GetIsObjectValid( oLanguagesTable ) )
				{
					oLanguagesTable = CSLDataObjectGet( "language_"+GetStringLowerCase(sName), TRUE );
					
					DelayCommand( CSLRandomBetweenFloat( 0.25f, fLoadInterval ), CSLLanguageDataTableSetup( oLanguagesTable, sTranslateTable ) );
					
					//CSLDataTableConfigure( oLanguagesTable, "csl_languages", "Name,Type,TranslateTable,BlockTable,FeatId,DMGranted,Icon", "", ",", "", "", "_mod_onmoduleloadlanguage" );
					//DelayCommand( CSLRandomBetweenFloat( 0.25f, 24.0f ), CSLDataTableLoad2da( oLanguagesTable ) );
				}
				
				
			}
			
			//SendMessageToPC( GetFirstPC(), "Loading Language "+IntToString(iCurrent)+" to get row "+IntToString(iRow)+" to get language "+"language_"+GetStringLowerCase(sName) ); 
		}
	}
	
	
	/*
	string sLoadOption = GetStringUpperCase( CSLGetPreferenceString( "DataObjectLoadOption", "OFF" ) );
	if ( sLoadOption == "OFF" )
	{
		return;
	}
	
	// not sure if this is needed but this being on a module can force a full reload of the items involved
	if ( sLoadOption == "CACHE" && GetLocalInt( GetModule(), "CSL_DATAOBJECT_FORCE_RELOAD") )
	{
		sLoadOption == "ReLoad"; // force a reload, perhaps new 2da's so don't use the cache
	}
	
	if ( CSLGetPreferenceSwitch( "DataObjectLoadSpellBooks", FALSE) )
	{
		
		float fIteration = 3.0f;
		
		// the core spell books are here
		string sSpellBooks = "Wiz_Sorc,Cleric,Warlock,Bard,Druid,Paladin,Ranger";
		
		// eventually adding these columns for new spell books to support that new feature, basically extending the engine --> adept,assasin,blackguard,psion,wilder,wujen,shugenja,warmage,hexblade,duskblade,healer,archivist,blighter,shair,pluma,hishna,witchdoctor,elementalist,necromancer for future features
		// probably not adding Demonologist,Exalted Arcanist,The Hoardstealer,Harper Guide,Mortal Hunter,Prime Underdark Guide,Slayer of Domiel,Apostle of Peace,Beloved of Valarian,Ghampion of Gwynharwyf,Emissary of Barachiel,Hunter of the Dead,Vassal of Bahamut,Artificer,Holder
		sSpellBooks = CSLNth_Shift(sSpellBooks, ",");
		string sCurrentSpellBook = CSLNth_GetLast();
		while ( sCurrentSpellBook != "" )
		{
			object oSpellBookTable = OBJECT_INVALID; // need to initalize this in the loop, other wise it just reuses the previous book which is valid and never creates one for each class
			
			fIteration += 6.0f;			
			if ( sLoadOption == "CACHE" )
			{
				oSpellBookTable = CSLDataObjectRetrieve( "spellbook_"+sCurrentSpellBook );
			}
			if ( !GetIsObjectValid( oSpellBookTable ) )
			{
				oSpellBookTable = CSLDataObjectGet( "spellbook_"+sCurrentSpellBook, TRUE ); 
				DelayCommand(CSLRandomBetweenFloat(0.5f+fIteration, 12.0f+fIteration), CSLDataTableSetupSpellBook( oSpellBookTable, sCurrentSpellBook ) );
				//SendMessageToPC( GetFirstPC(),"Creating spellbook "+sCurrentSpellBook);
			}
			sSpellBooks = CSLNth_Shift(sSpellBooks, ",");
			sCurrentSpellBook = CSLNth_GetLast();
		}
		//return;
	}
	
	DelayCommand(CSLRandomBetweenFloat(), CSLDataTableLoadSpellBookItemPropField() );
	*/
	// another custom column here rarity
	
}
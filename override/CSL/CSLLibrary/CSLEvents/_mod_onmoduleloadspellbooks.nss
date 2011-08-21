//#include "_inc_helper_functions"
#include "_CSLCore_ObjectVars"
//#include "_SCInclude_Chat"

void main()
{
	//SendMessageToPC( GetFirstPC(), "Loading SpellBook data now...");
	//return;
	// this is actually integrated the loading with getting, just because it's needed regardless of anything else being set up
	//DelayCommand( CSLRandomBetweenFloat( 0.1f, 0.25f ), CSLGetPreferenceDataObject() );
	CSLGetPreferenceDataObject(); // this just makes sure its loaded, should already be loaded
	
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
				DelayCommand(CSLRandomBetweenFloat(0.5f+(fIteration/3), 2.0f+fIteration), CSLDataTableSetupSpellBook( oSpellBookTable, sCurrentSpellBook ) );
				//SendMessageToPC( GetFirstPC(),"Creating spellbook "+sCurrentSpellBook);
			}
			sSpellBooks = CSLNth_Shift(sSpellBooks, ",");
			sCurrentSpellBook = CSLNth_GetLast();
		}
		//return;
	}
	
	DelayCommand(CSLRandomBetweenFloat(), CSLDataTableLoadSpellBookItemPropField() );
	// another custom column here rarity
	
}
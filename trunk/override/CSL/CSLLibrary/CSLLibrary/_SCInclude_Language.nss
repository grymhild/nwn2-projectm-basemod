/** @file
* @brief Include File for Languages ( from the DMFI )
* 
* This is a complete rewrite of the DMFI language system, to make it more moddable and efficient
*
* CREDITS: Originally Based on the DMFI language system by the DMFI team,
* Demetrious, QK and others. Also based on code originally derived from the SIMTools
* system, which we used in our PW and from which various languages were
* originally. SIMTools was created by FunkySwerve ( from Myth Drannor PW care of Lanessar )
*
* Major input advice and coaching from ALFA ( Curmugeon ) Sea of Dragons ( Akavit and Jester )
*
* @ingroup scinclude
* @author Brian T. Meyer and many others
*/

/*
Language dimensions

Overall UI 800x547

Top Title 800x32 Tall

Overall UI background X=0 Y=32 W=800 H=517
csl_book_BG.tga
csl_book_BG_Tablet.tga
csl_book_BG_Scroll.tga
csl_book_BG_Codex.tga
csl_book_BG_Parchment.tga

Icons down the left side ( top one only )
X=31 Y=72 W=36 H=36

Icons down the right side ( top one only )
X=744 Y=72 W=36 H=36

Button1 Far Left
X=59 Y=503  W=173 H=43

Button2 Left
X=233 Y=503  W=173 H=43

Button3 Right
X=403 Y=503  W=173 H=43

Button4 Far Right
X=575 Y=503  W=173 H=43

Now for Content, one of each for text and one each for images below, the text always being on top

FULL
X=113  Y=70  W=590 H=420

TOP LEFT HALF
X=110  Y=70  W=295 H=204

BOTTOM LEFT HALF
X=110  Y=275  W=295 H=217

TOP RIGHT HALF
X=410  Y=70  W=295 H=204

BOTTOM RIGHT HALF
X=410  Y=270  W=295 H=217

RIGHT HALF
X=110  Y=70  W=295 H=420

LEFT HALF
X=408  Y=70  W=295 H=420

TOP HALF
X=124  Y=70  W=582 H=197

BOTTOM HALF
X=124  Y=272  W=582 H=216
*/

/*
Feats and spells this system relates to

SPELLS
Comprehend languages -  allows comprehension of anything said or written which is held, does not give ability to speak or write in the given language
Tongues - Allows hearing any language, and speaking any language ( but not writing it ). Icon is temporarily added anytime this goes into effect whenever the language is heard.
Babble - Opposite of tongues, it is a custom language which prevents communication

FEATS
Linguist - Gives bonus to deciphering unknown languages, makes languages cost 1 less point to take, given for free to bards perhaps
Comprehension - Allows understanding, not reading or writing
TeleTranslation - Allows understanding via skimming the mind of any creature with a mind, monks get this at level 17 ( language of the sun and moon )
OmniLingual - Allows understanding and speaking any language 
OmniScriptor - Allows understanding of any written language 

Twisted Comprehension - allows those speaking to not be understood via magical spells of any sort

							Comprehend             Communicate
							Written  Spoken        Written   Spoken   Can Start in a New Langauge
Spell Comprehend languages -   x         x                        
Spell Tongues -                x         x              x        x      x
Feat Comprehension -           x         x              x        x
Feat Scribe                    x                        x
Feat Read Thoughts -                     x                       
Feat Linguistic Understanding -          x                       x
Feat Tongues -                 x         x              x        x      x

*/


const int FEAT_LANG_COMPRENSION = 8816; // understands all languages
const int FEAT_LANG_TELETRANSLATION = 8817; // understands all languages and is understood, only works if if other creatures are sentient with a mind - and can be shielded
const int FEAT_LANG_OMNILINGUAL = 8818; // knows all spoken languages
const int FEAT_LANG_OMNISCRIPTOR = 8819; // knows all written languages
const int FEAT_LANG_LINGUIST = 8820; // all languages are treated as one difficulty lower
/*
Language system

This is a project which is aimed at preserving how the current system works, while at the same time reducing the load on the compiler which is easily overloaded by having too many constants and functions ( items ), when you get things very complex. This may or may not cause an increased load on the server, but it will make the feature of higher quality and more flexible and the end result will be highly optimized for what it is doing.

Loads a set of 2da's into custom data objects based on a master language.2da, end users can easily add new languages just by adding a line to this language.2da and supplying a translation table.

Which language a character knows is configured via adding feats to the character, but this can be used other ways, this just allows languages to be integrated into the regular game system as well as by just granting feats up meeting certain requirements ( quest, reading a book, feats granted by using a given item, or via spells, or a dm just setting which languages a character should or should not know ) I am pretty sure i will keep DMFI support as is for those not wanting to migrate to the new system or who don't want a custom feats.2da.

The current DMFI does languages as a simple ciphper, imagine those simple codes which take every a and make it a b, thus shifting the letters by one value, thus making a word like "hello" into "ifmmp". This is similar to the decoder rings from the 50's or the enigma machine which made it quite a bit more complex. The DMFI is swapping letters which are vowels for vowels, and consonents for consonents so it ends up looking like a language but not something you can read, and it will tend to have the same number of letters. For those who can "understand" the language it sends the original message as what is translated is just jibberish which cannot be translated back. I will refer any letter by letter swapping like this as the "cipher" method.

However to improve things i want to add in support for translating a very small selection of well known words, most using this will recognize words used in movies and this will allow me to have it translate the word "friend" to "mellon" ( which is a famous translation featured in the lord of the rings ) which should make the end users beleive it actually has much more going on than just a few words. If a word is not found to use it will use the cipher method from the old DMFI, thus common words, well known words can be custom, but obscure words will just get gibberish that makes them look like elvish. While this could actually be used to put in the full Klingon language it cannot handle different grammar, it is just swapping words, and this addition is merely flavor, NWN2 cannot handle a full dictionary beyond just a small number of common words. If the server has enough memory it should be able to handle a good 3000-5000 words at most but i plan on only doing a 1000 or so custom words.

Differences i see are the following

Less optimized translation since it's happening via variables instead of compiled into the scripts.
Less constants which are making it so i have to use the PRC compiler, the toolset just can only have so many things before it crys uncle which it is doing.
Uses a hybrid of word substition followed by letter substition to allow things to feel more like a language.
Easier for end users who are not programmers to configure things how they want, just put in the before and after letters, then the before and after words.
More sophisticated in that it does both word substitution and letter subsition, and uses block words like deity names which are not translated.
Since it handles things word by word, increasing the number of words decreases processing load, 1 operation instead of 6 for a 6 letter word, at the cost of increased memory and setup load time.
ProtoLanguge not a Language - This is designed to make things feel like a language, with the idea that it will be a 1000 or so words at most used and not actually be used to put the entire klingon dictionary in, this is just for the words you remember from the movies.
Accents - This is designed to support things less than a language, to make it so a DM can use these as filters to make it so they can roleplay speaking like a pirate, shakespeare, or just having an accent easier if they are flipping between controlled npcs ( or as a wild magic effect which makes you speak with a lisp ).
Dynamic, the language can be given to players and removed from players on the fly, words can be added or removed or adjusted also on the fly ( and this can be made to work with a database as well to store those exceptions).
OOC text, and regular names, deity names and the like are skipped.
Requires loading and processing the language.2da's initially which requires waiting until they are loaded during which time they can create lag, since they are stored on objects this work can be stored in the bioware DB for later use and eliminate the setup time.
Version numbers stored in the 2da for each language on line 0 need to be incremented as they are updated to ensure any changes for a relaod of a given cached dataobject.
Does not support upper ascii foreign languages but should be something i can eventually handle by adding more "letters" or cleaning the words prior to handling.
For the most part will support the current DMFI system as is.

The 2da for a language is setup as the following

It is named as follows csl_lang_elvish.2da, which keeps it in it's own namespace. File only needs to be on the server. ( override 2da as opposed to needing to update the players haks all the time for PW's )
Other languages which are not official can use ANY name, so if you want to just not touch the official version you can name yours dex_lang_elvish.2da for example.

Columns
Key - Can have multiple values as follows
	<VERSION> - Current Version Number
	^A or ^B, one of these for each letter to be translated with a caret as a prefix both uppercase and lowercase, this sets up the cipher translation for when a word is not found
	Any other word is used as is, and the found word is replaced by the Value provided
	
Value - Value to use instead, if desire result to be a blank use a ^ instead since blanks, spaces are hard to input in a 2da ( will likely need to adjust this as needed to a code that makes more sense )

csl_lang_blockwords.2da
This stores all the words not to be tranlaates

csl_languages.2da
Columns
	Name - Name of language
	Type - Type - Accent or Language, Accents are not translated but only give flavor
	TranslateTable - 2da which defines letter ciphers and the word substitutions
	BlockTable - 2da which defines words ignored
	FeatId - Feat granted to allow usage of this language
	DMGranted - Y or N or ****, dms get this as an option, dm's can hear every language
	AllGranted - Y or N or ****, everyone gets this as an option, Common and the fun accents get this
	Icon - Icon for language
	More columns to support 2da based rules on who gets what, i think feat based

csl_lang_blockwords.2da
Columns
	Key - only column has words it does not translate

Implementation

Loading Data phase.

	1. Load general language information from csl_languages.2da.
	
	2. Load Language Tables ( loop thru all available, no sorting needed so should be quick, key is variable name on object )
	
	3. Load Block Tables

Loading Character Phase...
	
	1. Languages known on character creation or character load, this is something which will vary, current system, even though i favor granting feats for each spell
	
	2. Icons put on chat window to allow usage of specific languages based on what is known ( on same UI which handles chatting )
	
	3. Whether a character knows a language is a yes or no question, based on variable, spell effect or feat but determines if they can read a translation of what is said


Chat Processing

	1. Character hit button on chat ui to select a given language, flags character with a variable to indicate current language
	
	2. String character types in is sent to chat event
	
	3. String is parsed into separate words and each one is processed, those in OOC or emotes are skipped
	
	4. Each word is processed one at a time, if there is a variable with the same name as the word it's value is retrieved	
	
	5. If the Word is a stop word, it is not translated and left as is
	
	6. The word is processed letter by letter, using the cipher to determine the replacement letter
	
	7. The assembled text is used instead of the original text
	
	8. The original untranslated text is sent to all who happen to also know that language as a separate message right after the first.	


Code to pull preferences from preference object
if( CSLGetPreferenceSwitch("LanugagesAllPlayersGrantedCommon", FALSE ) )
{

if( CSLGetPreferenceSwitch("LanguagesGiveDefaults", FALSE ) )
{

if( CSLGetPreferenceSwitch("LanguagePlayerChoose", FALSE ) )
{


if( CSLGetPreferenceSwitch("LanguageAllowLoreToDecipher", FALSE ) )
{

*/

const int FEAT_LANG_BASE = 8600; // determines if they have languages feats configured, and this system is on
const int FEAT_LANG_ELVEN = 8601;
const int FEAT_LANG_DWARVEN = 8602;
const int FEAT_LANG_CELESTIAL = 8603;
const int FEAT_LANG_DRACONIC = 8604;
const int FEAT_LANG_SYLVAN = 8605;
const int FEAT_LANG_DROW = 8606;
const int FEAT_LANG_ORC = 8607;
const int FEAT_LANG_JOTUN = 8608;
const int FEAT_LANG_HALFLING = 8609;
const int FEAT_LANG_GNOME = 8610;
const int FEAT_LANG_IGNAN = 8611;
const int FEAT_LANG_INFERNAL = 8612;
const int FEAT_LANG_TERRAN = 8613;
const int FEAT_LANG_GNOLL = 8614;
const int FEAT_LANG_UNDERCOMMON = 8615;
const int FEAT_LANG_GOBLIN = 8616;
const int FEAT_LANG_AQUAN = 8617;
const int FEAT_LANG_AURAN = 8618;
const int FEAT_LANG_ABYSSAL = 8619;
const int FEAT_LANG_LANTANESE = 8620;
const int FEAT_LANG_ALGARONDAN = 8621;
const int FEAT_LANG_ALZHEDO = 8622;
const int FEAT_LANG_ANIMAL = 8623;
const int FEAT_LANG_ASSASSINCANT = 8624;
const int FEAT_LANG_CANT = 8625;
const int FEAT_LANG_CHESSENTAN = 8626;
const int FEAT_LANG_CHONDATHAN = 8627;
const int FEAT_LANG_CHULTAN = 8628;
const int FEAT_LANG_DAMARAN = 8629;
const int FEAT_LANG_DAMBRATHAN = 8630;
const int FEAT_LANG_DROWSIGN = 8631;
const int FEAT_LANG_DRUIDIC = 8632;
const int FEAT_LANG_DURPARI = 8633;
const int FEAT_LANG_HALARDRIM = 8634;
const int FEAT_LANG_HALRUAAN = 8635;
const int FEAT_LANG_ILLUSKAN = 8636;
const int FEAT_LANG_IMASKAR = 8637;
const int FEAT_LANG_LEETSPEAK = 8638;
const int FEAT_LANG_MIDANI = 8639;
const int FEAT_LANG_MULHORANDI = 8640;
const int FEAT_LANG_NEXALAN = 8641;
//const int FEAT_LANG_NEXALAN = 8641;
const int FEAT_LANG_OILLUSK = 8642;
const int FEAT_LANG_RASHEMI = 8643;
const int FEAT_LANG_RAUMVIRA = 8644;
const int FEAT_LANG_SERUSAN = 8645;
const int FEAT_LANG_SHAARAN = 8646;
const int FEAT_LANG_SHOU = 8647;
const int FEAT_LANG_TELFIR = 8648;
const int FEAT_LANG_TASHALAN = 8649;
const int FEAT_LANG_ENTISH = 8650;
const int FEAT_LANG_TUIGAN = 8651;
const int FEAT_LANG_TURMIC = 8652;
const int FEAT_LANG_ULUIK = 8653;
const int FEAT_LANG_UNTHERIC = 8654;
const int FEAT_LANG_VAASAN = 8655;
const int FEAT_LANG_PIRATE = 8656;
const int FEAT_LANG_SHAKESPEARE = 8657;
const int FEAT_LANG_THAYAN = 8658;
const int FEAT_LANG_YUANTI = 8659;
const int FEAT_LANG_BOTHII = 8660;
const int FEAT_LANG_CHARDIC = 8661;
const int FEAT_LANG_CHESSIC = 8662;
const int FEAT_LANG_CORMANTHAN = 8663;
const int FEAT_LANG_DTARIG = 8664;
const int FEAT_LANG_EASTING = 8665;
const int FEAT_LANG_ILLUSKI = 8666;
const int FEAT_LANG_JANNTI = 8667;
const int FEAT_LANG_KOZAKURAN = 8668;
const int FEAT_LANG_LOROSS = 8669;
const int FEAT_LANG_NETHERESE = 8670;
const int FEAT_LANG_PAYIT = 8671;
const int FEAT_LANG_REGHEDJIC = 8672;
const int FEAT_LANG_RUATHLEK = 8673;
const int FEAT_LANG_TULUNG = 8674;
const int FEAT_LANG_TABAXI = 8675;
const int FEAT_LANG_THARIAN = 8676;
const int FEAT_LANG_THORASS = 8677;
const int FEAT_LANG_TRUSKAN = 8678;
const int FEAT_LANG_ROUSHOUM = 8679;
const int FEAT_LANG_WAAN = 8680;
const int FEAT_LANG_WAELAN = 8681;
const int FEAT_LANG_YIPYAK = 8682;
const int FEAT_LANG_MAIDENTOUNGE = 8683;
const int FEAT_LANG_COMMON = 8684;
const int FEAT_LANG_ALAMBIK = 8685;
const int FEAT_LANG_THRESK = 8686;
const int FEAT_LANG_SELDRUIN = 8687;
const int FEAT_LANG_ARCANE = 8688;
const int FEAT_LANG_ARAGRAKH = 8689;
const int FEAT_LANG_HAN = 8690;
const int FEAT_LANG_TRADETONGUE = 8691;
const int FEAT_LANG_LOGOS = 8692;
const int FEAT_LANG_YSGARD = 8693;
const int FEAT_LANG_PATHOS = 8694;

#include "_CSLCore_Class"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_Math"
#include "_CSLCore_Info"
#include "_CSLCore_UI"
// #include "_SCInclude_Chat_c"


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

const string DMFI_LANGUAGE_TOGGLE = "DMFILangToggle";
const string DMFI_ACCENT_TOGGLE = "DMFIAccentToggle";

const string DMFI_LANGUAGE_CURLABEL= "DMFILangCurrent";
const string DMFI_LANGUAGE_CURFEAT= "DMFILangCurrentFeat";
const string DMFI_LANGUAGE_CURNAME = "DMFILangCurrentName";
const string DMFI_LANGUAGE_CURDIFFICULTY = "DMFILangCurrentDifficulty";
const string DMFI_LANGUAGE_CURFAMILY = "DMFILangCurrentFamily";
const string DMFI_LANGUAGE_CURSUBGROUP = "DMFILangCurrentSubGroup";


const string DMFI_LANGUAGE_HOTBARLIST = "DMFILangHotbarList";
const string DMFI_LANGUAGE_HOTBARLISTTEMP = "DMFILangHotbarListTemp";
const string DMFI_LANGUAGE_KNOWNLIST = "DMFILangKnownList";
const string DMFI_LANGUAGE_LEARNABLELIST = "DMFILangLearnableList";
const string DMFI_LANGUAGE_LEARNINGLIST = "DMFILangLearningList";

const string DMFI_LANGUAGE_POINTSUSED = "DMFILangPointsUsed";

/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////
#include "_SCInclude_DMFI_c"
#include "_SCInclude_Chat_c"
#include "_CSLCore_Config"
#include "_CSLCore_UI"
#include "_CSLCore_Magic"
#include "_CSLCore_Strings"
#include "_CSLCore_ObjectVars"
#include "_CSLCore_Appearance"
#include "_CSLCore_Visuals"
#include "_CSLCore_Messages"
#include "_CSLCore_Items"

// need to review these
//#include "_SCUtilityConstants"
// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


/**  
* Gets a language object
* @author
* @see 
* @return 
*/
object CSLLanguageGetTranslatorObject( string sLanguageVar )
{
	return CSLDataObjectGet( "language_"+GetStringLowerCase( sLanguageVar ) );	
}

// * takes all rows of the given prefix and sorts them to the end of the table -- will this cause TMI on larger tables??? last 3 parameters allow extended processing
void CSLLanguageDataTableSetup( object oLanguageTable, string sTranslateTable )
{
	// string s2daName = GetLocalString( oDataTable, "DATATABLE_SOURCEDATANAME" );
	string sKey, sValue, sLeft, sKeyType;
	
	SetLocalString(oLanguageTable, "DATATABLE_SOURCEDATANAME", sTranslateTable );
	
	int iMaxRows = GetNum2DARows( sTranslateTable );
	int iMaxRowsToProcess = 500;
	int iProcessed = 0;
	int iLastRowProcessed = GetLocalInt(oLanguageTable, "DATATABLE_LASTROWPROCESSED" );
	int iRow;
	
	if ( iMaxRows > iLastRowProcessed )
	{
		int iStartingRow = iLastRowProcessed+1;
		
		for (iRow = iStartingRow; iRow <= iMaxRows; iRow++) 
		{
			sKey = Get2DAString(sTranslateTable, "Key", iRow );
			sValue = Get2DAString(sTranslateTable, "Value", iRow );
			sKeyType = GetStringLeft(sKey, 1);
			
			if ( sKeyType == "^" ) // this is a cipher, can only be one letter
			{
				SetLocalString(oLanguageTable, "CIPHER_"+GetStringRight(sKey, GetStringLength(sKey)-1), sValue );
			}
			else if ( sKeyType == "<" ) // this is a code, usually version
			{
				if ( sKey == "<VERSION>" )
				{
					SetLocalInt(oLanguageTable, "DATATABLE_VERSION", StringToInt(sValue) );
					SetLocalInt(oLanguageTable, "DATATABLE_LANGVERSION", StringToInt(sValue) );
				}
			}
			else // this is a word substitution
			{
				SetLocalString(oLanguageTable, "WORD_"+GetStringUpperCase(sKey), sValue );
			}
			iProcessed++;
			SetLocalInt(oLanguageTable, "DATATABLE_LASTROWPROCESSED", iRow );

			if ( iProcessed > iMaxRowsToProcess )
			{
				DelayCommand( CSLRandomBetweenFloat( 0.25f, 3.0f ), CSLLanguageDataTableSetup( oLanguageTable, sTranslateTable ) );
				return;
			}
			
		}
	}
	
	SetLocalInt(oLanguageTable, "DATATABLE_FULLYLOADED", TRUE );
	CSLDataObjectStore( GetLocalString(oLanguageTable, "DATATABLE_NAME") );

}


string CSLLanguageTranslateWord( string sWord, string sLanguageVar, object oLanguageTranslator )
{
	string sNewWord = GetLocalString(oLanguageTranslator, "WORD_"+GetStringUpperCase( sWord ) );
	
	//SendMessageToPC( GetFirstPC(), "Translating Word "+sWord+" looking up "+"WORD_"+GetStringUpperCase( sWord )+" and getting "+sNewWord);
	if( sNewWord == "" )
	{
		int iCounter;
		string sLetter;
		int iLength = GetStringLength( sWord );
		for ( iCounter = 0; iCounter < iLength; iCounter++)
		{
			sLetter = GetSubString(sWord, iCounter, 1);
			string sNew = GetLocalString(oLanguageTranslator, "CIPHER_"+sLetter );
			
			//SendMessageToPC( GetFirstPC(), "Translating Letter "+sLetter+" looking up "+"CIPHER_"+sLetter+" and getting "+sNew);
			
			if ( sNew != "" )
			{
				sNewWord += sNew;
			}
			else
			{
				sNewWord += sLetter;
			}
		}
	}
	if ( sWord == GetStringUpperCase( sWord ) )
	{
		return GetStringUpperCase( sNewWord );
	}
	if ( sWord == GetStringLowerCase( sWord ) )
	{
		return GetStringLowerCase( sNewWord );
	}
	return sNewWord;
}

string CSLLanguageGetValidLanguageForSpeaker( object oSpeaker, string sLang )
{
	// deal with defaults for animals
	if ( sLang == "" && CSLGetIsAnimalOrBeast( oSpeaker ) && !GetHasFeat( FEAT_LANG_COMMON, oSpeaker) )
	{
		return "animal";
	}
	
	
	// force babble if they have that spell effect, require it in fact
	if ( GetHasSpell( SPELL_BABBLE, oSpeaker ) )
	{
		return "babble";	
	}
	else if ( sLang == "babble" )
	{
		sLang = ""; // prevent babble if they have that
	}
	
	int iFeatId;
	if ( GetLocalString(oSpeaker, DMFI_LANGUAGE_CURLABEL ) == sLang )
	{
		iFeatId = GetLocalInt(oSpeaker, DMFI_LANGUAGE_CURFEAT );
		//sName = GetLocalString(oSpeaker, DMFI_LANGUAGE_CURNAME );
		//sDifficulty = GetLocalString(oSpeaker, DMFI_LANGUAGE_CURDIFFICULTY );
		//sFamily = GetLocalString(oSpeaker, DMFI_LANGUAGE_CURFAMILY );
		//sSubGroup = GetLocalString(oSpeaker, DMFI_LANGUAGE_CURSUBGROUP );
	}
	else if ( sLang != "") // something is wrong, we need to fix something, or tweak things so it's an exact match
	{
		object oLanguageTable = CSLDataObjectGet( "languages" );
		int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLang );
		
		sLang = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
		string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
		string sName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow ) ;
		string sDifficulty = CSLDataTableGetStringByRow( oLanguageTable, "Difficulty", iRow ) ;
		string sFamily = CSLDataTableGetStringByRow( oLanguageTable, "Family", iRow ) ;
		string sSubGroup = CSLDataTableGetStringByRow( oLanguageTable, "SubGroup", iRow ) ;
		
		if ( sFeatId != "" && StringToInt(sFeatId) > 0 )
		{
			iFeatId = StringToInt(sFeatId);
		}
		// go ahead and save them for later
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURLABEL, sLang );
		SetLocalInt(oSpeaker, DMFI_LANGUAGE_CURFEAT, iFeatId );
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURNAME, sName );
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURDIFFICULTY, sDifficulty );
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURFAMILY, sFamily );
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURSUBGROUP, sSubGroup );
		
		// iFeatId = StringToInt(sFeatId);
	}
		
	
	
	if ( GetHasFeat( iFeatId, oSpeaker) || GetHasSpell(SPELL_TONGUES, oSpeaker) || GetHasFeat( FEAT_LANG_OMNILINGUAL, oSpeaker) || CSLGetIsDM(oSpeaker, TRUE) || GetIsDMPossessed(oSpeaker) ) // has feat for language
	{
		return sLang;
	}
	
	if ( CSLGetIsAnimalOrBeast(oSpeaker) && !GetHasFeat( FEAT_LANG_COMMON, oSpeaker) )
	{
		return "animal";
	}
	
	return "";
	
}



string CSLLanguageTranslate( string sMessage, string sLanguageVar )
{
	//sLanguageVar = GetStringLowerCase(sLanguageVar);
	if (sLanguageVar=="common")
	{
		return sMessage;
	}
	
	//object oLanguageTranslator = CSLLanguageGetTranslatorObject( sLanguageVar );
	//if ( !GetIsObjectValid( oLanguageTranslator ) )
	//{
	object oLanguageTable = CSLDataObjectGet( "languages" );
	// they are using an alias, so go ahead and look up the row number for it.
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLanguageVar );

	sLanguageVar = CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow );
	object oLanguageTranslator = CSLLanguageGetTranslatorObject( sLanguageVar );
	//}
	
	string sType = CSLDataTableGetStringByRow( oLanguageTable, "Type", iRow );
	if ( sType == "Sign" ) // skips translation, they need to use signing instead
	{
		return "<SIGNEMOTES>";
	}
	
	if ( GetIsObjectValid( oLanguageTranslator ) )
	{
		
		string sLetter, sWord, sNewMessage;
		int iLast = -1;
		int iCount;
		int iLength = GetStringLength( sMessage );
		
		int iIgnorePortion = FALSE;
		
		for ( iCount = 0; iCount < iLength; iCount++)
		{
			sLetter = GetSubString(sMessage, iCount, 1);
			if ( iIgnorePortion == TRUE )
			{
				if ( sLetter == ">" || sLetter == "*" )
				{
					iIgnorePortion = FALSE;
					// the following line might be an error, need to review
					sNewMessage += sLetter;
				}
				
			}
			else if ( sLetter == "<" || sLetter == "*" )
			{
				iIgnorePortion = TRUE;
				
			}
			else
			{
				if ( DEBUGGING > 2 ) { SendMessageToPC( GetFirstPC(), "Processing Letter "+sLetter+" = "+IntToString( FindSubString(sLetter, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" ) ) ); }
				if ( FindSubString("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", sLetter ) != -1 )
				{
					sWord += sLetter;
				}
				else
				{
					if ( sWord != "" )
					{
						sNewMessage += CSLLanguageTranslateWord( sWord, sLanguageVar, oLanguageTranslator );
						sWord = "";
					}
					sNewMessage += sLetter;
				}
			}
			
			if ( iIgnorePortion )
			{
				if ( sWord != "" )
				{
					sNewMessage += CSLLanguageTranslateWord( sWord, sLanguageVar, oLanguageTranslator );
					sWord = "";
				}
				sNewMessage += sLetter;
			}
			
		}
		
		// repeat to flush out the last one
		if ( sWord != "" )
		{
			sNewMessage += CSLLanguageTranslateWord( sWord, sLanguageVar, oLanguageTranslator );
		}
		//sNewMessage += sLetter;
		
		return sNewMessage;
	}
	//else
	//{
	//	SendMessageToPC( GetFirstPC(), "Translator "+sLanguageVar+" not found" );
	//}
	return sMessage;
}

// returns -1 if not valid
int CSLLanguageGetFeatFor( string sLanguageVar ) 
{
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLanguageVar );
	
	string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
	if ( sFeatId == "" )
	{
		return -1;
	}
	return StringToInt( sFeatId );
}

// returns -1 if not valid
int CSLLanguagesGetIsLoaded( ) 
{
	object oLanguageTable = CSLDataObjectGet( "languages" );
	return CSLDataObjectGetIsLoaded(oLanguageTable);
	// CSLDataObjectGetIsSorted
}


string CSLLanguageHandleOutsiderAlignExceptions( string sLangString, object oPC )
{
	string sLanguageVar = "";
	int iElement;

	if ( FindSubString( ","+sLangString+",", ","+"goodoutsider"+"," ) != -1 )
	{
		if (GetAlignmentLawChaos(oPC)==ALIGNMENT_CHAOTIC)
		{
			sLanguageVar="ysgard";
		}
		else
		{
			sLanguageVar="celestial";
		}
		
		// adjust the array
		iElement = CSLNth_Find(sLangString, "goodoutsider" );
		CSLNth_ReplaceElement( sLangString, sLanguageVar, iElement );
	}
	
	if ( FindSubString( ","+sLangString+",", ","+"eviloutsider"+"," ) != -1 )
	{
		if (GetAlignmentLawChaos(oPC)==ALIGNMENT_CHAOTIC)
		{
			sLanguageVar="abyssal";
		}
		else
		{
			sLanguageVar="infernal";
		}
		
		// adjust the array
		iElement = CSLNth_Find(sLangString, "goodoutsider" );
		CSLNth_ReplaceElement( sLangString, sLanguageVar, iElement );
	}
	
	return sLanguageVar;

}


// string CSLLanguageHandleOutsiderAlignExceptions( string sLangString, object oPC )
// this converts existing DMFI languages stored on the DMFI tool to language feats
string CSLLanguageMergeDMFIGranted( object oPC, string sLanguageString = "" )
{
	object oTool = CSLDMFI_GetTool(oPC);
	if ( GetIsObjectValid(oTool) )
	{
		string sMess;
		string sLang;
		int n;
		int nMax;
	
		nMax = GetLocalInt(oTool, "Language"+"MAX");
		for (n=0; n < nMax; n++)
		{
			sLang = GetStringLowerCase(GetLocalString(oTool, "Language" + IntToString(n)));			
			sLanguageString = CSLNth_Push(sLanguageString, sLang, ",", TRUE );
		}
	}
	return sLanguageString;	
}





// lists languages known by the given target and sends them to oReceiver as messages
void CSLLanguagesListLearnedToMessage( object oReceiver, object oTarget, int iStartRow = 0, int bShowKnownOnly = FALSE )
{
	object oLanguageTable = CSLDataObjectGet( "languages" );
	
	if ( !GetIsObjectValid(oLanguageTable) )
	{
		return;
	}
	
	
	
	SendMessageToPC(oReceiver, "Languages known by target: " + GetName(oTarget) );
	if ( CSLGetIsDM(oTarget, FALSE) && CSLGetIsDM(oReceiver, FALSE ) )
	{
		SendMessageToPC(oReceiver, "ALL LANGUAGES GRANTED TO DMs." );
		// return;
	}	
	
	
	int iTotalRows = CSLDataTableCount( oLanguageTable );
	int iMaxIterations = 100; // won't hit this, but just in case someone makes there be a lot more languages for whatever reason
	int iCurrentIteration = 0;
	int iRow, iCurrent;
	string sName;
	string sFeatId;
	string sCurrentLevel;

	for ( iCurrent = iStartRow; iCurrent <= iTotalRows; iCurrent++) // changed from <=
	{
		if ( iCurrentIteration > iMaxIterations )
		{
			DelayCommand( 0.1f, CSLLanguagesListLearnedToMessage( oReceiver, oTarget, iCurrent, bShowKnownOnly ) );
			return;
		}
		
		iRow = CSLDataTableGetRowByIndex( oLanguageTable, iCurrent );
		//Level
		
		if ( iRow > -1 )
		{
			sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
			
			if ( sFeatId != "" )
			{
				sName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow );
				if ( sName != "" )
				{
					if ( GetHasFeat( StringToInt(sFeatId), oTarget) )
					{
						SendMessageToPC( oReceiver, "<color=Ivory>"+sName+"</color>" );
					}
					else if ( bShowKnownOnly == FALSE )
					{
						SendMessageToPC( oReceiver, "<color=Yellow>"+sName+"</color>" );
					}
				}
			}
		}
	}
}

// lists languages known by the given target and sends them to oReceiver as messages
string CSLLanguagesLearnedToString( object oTarget, int iMaxToProcess = 99 )
{
	string sLanguageList = "";
	int iProcessed = 0;
	object oLanguageTable = CSLDataObjectGet( "languages" );
	if ( GetIsObjectValid(oLanguageTable) )
	{
		int iTotalRows = CSLDataTableCount( oLanguageTable );
		int iRow, iCurrent;
		string sName, sType, sCurrentLevel, sFeatId;
	
		for ( iCurrent = 0; iCurrent <= iTotalRows; iCurrent++) // changed from <=
		{	
			iRow = CSLDataTableGetRowByIndex( oLanguageTable, iCurrent );
			if ( iRow > -1 )
			{
				sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
				if ( sFeatId != "" && GetHasFeat( StringToInt(sFeatId), oTarget) )
				{
					sName = GetStringLowerCase( CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ) );
					sType = CSLDataTableGetStringByRow( oLanguageTable, "Type", iRow );
					if ( sType != "Accent" && sName != "" && sName != "common" && sName != "babel" )
					{
						sLanguageList = CSLNth_Push(sLanguageList, sName, ",", TRUE );
						iProcessed++;
					}
				}
			}
			
			if ( iProcessed >= iMaxToProcess )
			{
				// force an exit right away
				return sLanguageList;
			} 
			
		}
	}
	return sLanguageList;
}


// run this on rest or other actions where we need to remove temporary languages
void CSLLanguageRemoveTempLanguages( object oSpeaker ) // only applies when they have a right to use a given langauge
{
	string sLanguageList = GetLocalString(oSpeaker, DMFI_LANGUAGE_HOTBARLIST );
	string sLanguageListTemp = GetLocalString(oSpeaker, DMFI_LANGUAGE_HOTBARLISTTEMP );
	//SetLocalString(oPC, DMFI_LANGUAGE_HOTBARLIST, CSLNth_Push(GetLocalString(oPC, DMFI_LANGUAGE_HOTBARLIST ), sLang, ",", TRUE ) );
	//SetLocalString(oPC, DMFI_LANGUAGE_HOTBARLISTTEMP, "" );
	//CSLLanguageMonitorAppliedTempLanguages( oSpeaker);
	string sLanguageCurrent;
	int i, iAutomaticCount;
	if ( sLanguageListTemp != "" )
	{
		int iAutomaticCount = CSLNth_GetCount( sLanguageListTemp );
		for ( i=1; i <= iAutomaticCount; i++ )
		{
			sLanguageCurrent = CSLNth_GetNthElement(sLanguageListTemp, i);
			if ( sLanguageCurrent != "" )
			{
				sLanguageList = CSLNth_Replace( sLanguageList, sLanguageCurrent, "" );
			}
		}
	}
	
	SetLocalString(oSpeaker, DMFI_LANGUAGE_HOTBARLIST, sLanguageList );
	SetLocalString(oSpeaker, DMFI_LANGUAGE_HOTBARLISTTEMP, "");
	// invalidate the serial forcing current loops to end
	SetLocalInt(oSpeaker, "SERIAL_"+"TEMPLANGUAGE", CSLGetRandomSerialNumber() );
}


void CSLLanguageMonitorAppliedTempLanguages( object oSpeaker, int iSerial = -1 )
{
	if ( !GetIsObjectValid( oSpeaker ) || !CSLSerialRepeatCheck( oSpeaker, "TEMPLANGUAGE", iSerial ) )
	{
		// either no target or a new monitor is replacing the old, nothing can be done...
		return;
	}
	
	if ( GetIsDead( oSpeaker ) )
	{
		// player is dead, remove any lanuages here	
	}
	// redid logic so any one of these being true will make it repeat, since its generally the spell tongues it should reduce the amount of work being done each round
	else if ( GetHasSpell(SPELL_TONGUES, oSpeaker) || GetHasFeat( FEAT_LANG_OMNILINGUAL, oSpeaker) || CSLGetIsDM(oSpeaker, TRUE) || GetIsDMPossessed(oSpeaker)  )
	{
		if ( iSerial == -1 )
		{
			iSerial = CSLSerialGetCurrentValue( oSpeaker, "TEMPLANGUAGE" );
		}
		DelayCommand( 6.0f, CSLLanguageMonitorAppliedTempLanguages( oSpeaker, iSerial ) );
	}
	
	
	
	CSLLanguageRemoveTempLanguages( oSpeaker );
	
	return;
}

// sets a heard or spoken language as a new available hotbar icon
void CSLLanguageApplyTempLanguage( object oSpeaker, string sLang ) // only applies when they have a right to use a given langauge
{
	SetLocalString(oSpeaker, DMFI_LANGUAGE_HOTBARLIST, CSLNth_Push(GetLocalString(oSpeaker, DMFI_LANGUAGE_HOTBARLIST ), sLang, ",", TRUE ) );
	SetLocalString(oSpeaker, DMFI_LANGUAGE_HOTBARLISTTEMP, CSLNth_Push(GetLocalString(oSpeaker, DMFI_LANGUAGE_HOTBARLISTTEMP ), sLang, ",", TRUE ) );
	CSLLanguageMonitorAppliedTempLanguages( oSpeaker);
}



void CSLLanguageUIChatIconRow( object oPlayer, string sCurrentLanguage = "" )
{
	//oPlayer = GetControlledCharacter(oPlayer);
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int bFixListVar = FALSE;
	int iButtonCount = 8;
	
	string sScreenName;
	if ( GetIsSinglePlayer() )
	{
		sScreenName = "SCREEN_MESSAGE_1"; // defaultchat.XML
	}
	else
	{
		sScreenName = "SCREEN_MESSAGEMP_1"; // defaultmpchat1.XML
		// sScreenName = "SCREEN_MESSAGEMP_2"; // defaultmpchat2.XML		
	}
	
	if ( sCurrentLanguage == "" )
	{
		sCurrentLanguage = GetStringLowerCase( GetLocalString(oPlayer, DMFI_LANGUAGE_TOGGLE ) );
	}
	
	
	
	string sLanguageList = GetLocalString(oPlayer, DMFI_LANGUAGE_HOTBARLIST );
	if ( sLanguageList == "" )
	{
		bFixListVar = TRUE;
		sLanguageList = CSLLanguagesLearnedToString( oPlayer, iButtonCount );
	}
	//return;
	
	if ( FindSubString( ","+sLanguageList+",", ","+sCurrentLanguage+"," ) == -1 )
	{
		//sArray += ","+sNewItem;
		sLanguageList = CSLNth_Rotate(sLanguageList, sCurrentLanguage, iButtonCount );
		bFixListVar = TRUE;
	}
	
	if ( bFixListVar )
	{
		// store the list for later
		SetLocalString(oPlayer, DMFI_LANGUAGE_HOTBARLIST, sLanguageList );
	}
	
	//SendMessageToPC( oPlayer, GetName(oPlayer)+" sLanguageList="+sLanguageList);
	SetLocalGUIVariable(oPlayer, sScreenName, 920, sLanguageList );
	
	
	// draw the cancel button
	if ( sCurrentLanguage == "" || sCurrentLanguage == "common" || sCurrentLanguage == "babble"  )
	{
		SetGUIObjectHidden( oPlayer, sScreenName, "Language-0", TRUE ); // hides button
	}
	else
	{
		SetGUITexture( oPlayer, sScreenName, "Language-0", "lang_blank.tga" );
		SetGUIObjectHidden( oPlayer, sScreenName, "Language-0", FALSE ); // shows button
	}
	
	
	string sButtonName, sButtonLanguageLabel, sButtonLanguageName, sButtonLanguageIcon;
	// now do alternative lanuguage buttons
	int i, iItemCount, iCurrentButton;
	iItemCount = CSLNth_GetCount( sLanguageList );
	iCurrentButton = 0; // will increment prior to first usage..
	//for ( i=1; i <= iItemCount; i++ )
	int iSanityCap = 0;
	while ( iCurrentButton < iButtonCount && iSanityCap < 25 )
	{
		iSanityCap++; // safety, should never hit this but might if a lot of invalid strings in the languages known string
		sButtonLanguageLabel = "";
		if ( sLanguageList != "" )
		{
			sLanguageList = CSLNth_Shift(sLanguageList); // removes first item in array
			sButtonLanguageLabel = CSLNth_GetLast();
			
			//SendMessageToPC( oPlayer, "sLanguageList="+sLanguageList+" sButtonLanguageLabel="+sButtonLanguageLabel );
			int iRow = CSLDataTableGetRowByValue( oLanguageTable, sButtonLanguageLabel );
			if ( iRow > -1 )
			{
				sButtonLanguageLabel = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
				sButtonLanguageName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow );
				sButtonLanguageIcon = CSLDataTableGetStringByRow( oLanguageTable, "Icon", iRow )+".tga";
			}
			
			if ( sButtonLanguageLabel != "" && sButtonLanguageLabel != "common" && sButtonLanguageLabel != "babble" )
			{
				iCurrentButton++;
				sButtonName = "Language-"+IntToString(iCurrentButton);
				SetGUITexture( oPlayer, sScreenName, sButtonName, sButtonLanguageIcon );
				SetGUIObjectHidden( oPlayer, sScreenName, sButtonName, FALSE ); // shows button
				SetLocalGUIVariable(oPlayer, sScreenName, 900+iCurrentButton, sButtonLanguageLabel);
				SetLocalGUIVariable(oPlayer, sScreenName, 910+iCurrentButton, sButtonLanguageName);
			
				if ( sCurrentLanguage == sButtonLanguageLabel )
				{
					SetGUIObjectDisabled( oPlayer, sScreenName, sButtonName, TRUE );
					//SendMessageToPC( oPlayer,sButtonName+" showing="+sCurrentLanguage);
				}
				else
				{
					SetGUIObjectDisabled( oPlayer, sScreenName, sButtonName, FALSE );
					//SendMessageToPC( oPlayer,sButtonName+" showing disabled="+sCurrentLanguage);
				}
			
			}
		}
		else
		{
			iCurrentButton++;
			sButtonName = "Language-"+IntToString(iCurrentButton);
			SetGUIObjectHidden( oPlayer, sScreenName, sButtonName, TRUE ); // hides button
			SetLocalGUIVariable(oPlayer, sScreenName, 900+i, "");
			SetLocalGUIVariable(oPlayer, sScreenName, 910+i, "");
			//SendMessageToPC( oPlayer,sButtonName+" hiding "+sCurrentLanguage);
		}
	}
	
}

string CSLLanguagePartiallyTranslate( int iPercentage, string sTranslate, string sOriginal )
{
	int iAutomaticCount;
	string sUnderstood;
	int i;
	if ( sOriginal != "" )
	{
		int iAutomaticCount = CSLNth_GetCount( sOriginal, " " );
		for ( i=1; i <= iAutomaticCount; i++ )
		{
			if ( d100() < iPercentage )
			{				
				sUnderstood += " "+CSLNth_GetNthElement(sOriginal, i, " " ); // note leading space is used later on
			}
			else
			{
				sUnderstood += " "+"blah";//CSLNth_GetNthElement(sTranslate, i, " " ); // sTranslate
			}
		}
		return sUnderstood;
	}
	
	return sTranslate;
}

void CSLLanguageSendLoreResults( object oListener, object oSpeaker,  string sTranslate, string sUnTranslated, string sLanguageName )
{
	//SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, CSLColorText("Lore Check Passed ( Rolled "+IntToString(iTest)+" vs DC "+IntToString(iDC)+"): Language Translated.", COLOR_GREY), FALSE );	
	if ( sTranslate != sUnTranslated )
	{
		SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, CSLColorText( "  Lore: Language:" + sLanguageName + " Translation:" + sTranslate, COLOR_GREY), FALSE );	
	}
	else // they only can figure out what language is involved due to the lore score
	{
		SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, CSLColorText( "  Lore: Language: " + sLanguageName, COLOR_GREY), FALSE );
	}
}

// DMFI_TranslateToSpeakers(object oSpeaker, string sTranslate, string sLang, object oUI)
void CSLLanguageTranslateToListeners(object oSpeaker, string sTranslate, string sOriginal, string sLang )
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_TranslateToSpeakers Start", oSpeaker ); }
	//Purpose: Sends sTranslate to any nearby speakers of sLang
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 1/10/7
	int nTest;
	int iFeatId = -1;
	int n=1;
	string sFeatId, sName, sDifficulty, sFamily, sSubGroup;
	if ( sLang=="common" || sLang=="" )
	{
		return;
	}
	//{
	//	//CSLMessage_SendText(oUI, GetName(oSpeaker) + " : " + sTranslate, FALSE, COLOR_BROWN);
	//	SendChatMessage(oSpeaker, OBJECT_INVALID, CHAT_MODE_TALK, CSLColorText(sTranslate, COLOR_BROWN), FALSE );
	//}
	
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLang );
	
	if ( GetLocalString(oSpeaker, DMFI_LANGUAGE_CURLABEL ) == sLang )
	{
		iFeatId = GetLocalInt(oSpeaker, DMFI_LANGUAGE_CURFEAT );
		sName = GetLocalString(oSpeaker, DMFI_LANGUAGE_CURNAME );
		sDifficulty = GetLocalString(oSpeaker, DMFI_LANGUAGE_CURDIFFICULTY );
		sFamily = GetLocalString(oSpeaker, DMFI_LANGUAGE_CURFAMILY );
		sSubGroup = GetLocalString(oSpeaker, DMFI_LANGUAGE_CURSUBGROUP );
	}
	else // something is wrong, we need to fix something, or tweak things so it's an exact match
	{
		object oLanguageTable = CSLDataObjectGet( "languages" );
		int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLang );
		
		sLang = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
		sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
		sName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow ) ;
		sDifficulty = CSLDataTableGetStringByRow( oLanguageTable, "Difficulty", iRow ) ;
		sFamily = CSLDataTableGetStringByRow( oLanguageTable, "Family", iRow ) ;
		sSubGroup = CSLDataTableGetStringByRow( oLanguageTable, "SubGroup", iRow ) ;
		
		if ( sFeatId != "" && StringToInt(sFeatId) > 0 )
		{
			iFeatId = StringToInt(sFeatId);
		}
		// go ahead and save them for later
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURLABEL, sLang );
		SetLocalInt(oSpeaker, DMFI_LANGUAGE_CURFEAT, iFeatId );
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURNAME, sName );
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURDIFFICULTY, sDifficulty );
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURFAMILY, sFamily );
		SetLocalString(oSpeaker, DMFI_LANGUAGE_CURSUBGROUP, sSubGroup );
		
		// iFeatId = StringToInt(sFeatId);
	}
	
	
	// !CSLIsClose(oTarget, oCounterSpeller, 40.0f )
	int iDifficulty = StringToInt(sDifficulty);
	int iCurDifficulty;
	int iDifficultyCheck;  // 15 to 35 range 
	
	string sTranslated25perc, sTranslated50perc, sTranslated75perc;
	object oSecondaryCharacter = OBJECT_INVALID;
	
	if ( GetIsPC( oSpeaker ) )
	{
		SendChatMessage(oSpeaker, oSpeaker, CHAT_MODE_TELL, " " + "You Said: (" + sName + ") " + sOriginal, FALSE );
		if ( GetOwnedCharacter( oSpeaker ) != oSpeaker )
		{
			oSecondaryCharacter = GetOwnedCharacter( oSpeaker );
		}
	}
	
	/// oCreator = IntToObject( CSLGetTargetTagInt( SCSPELLTAG_CASTERPOINTER, oTarget, iSpellId ) );
	object oListener = GetFirstPC();
	while (GetIsObjectValid(oListener))
	{
		if (GetArea(oSpeaker)==GetArea(oListener))
		{
			if ( oListener!=oSpeaker && oListener!=oSecondaryCharacter )
			{
				if ( CSLGetIsDM(oListener, FALSE) || GetIsDMPossessed(oListener) )
				{
					CSLLanguageApplyTempLanguage( oListener, sLang );
					CSLLanguageUIChatIconRow( oListener, sLang );
					SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, " " + "DM "+GetName(oListener)+" Translated: (" + sName + ") " + sOriginal, FALSE );
				}
				else if ( 
				           ( sTranslate == "<SIGNEMOTES>" && CSLIsCreatureInView(oListener, 220.0f, oSpeaker ) && GetDistanceBetween(oSpeaker, oListener)<40.0 ) // sign language, requires seeing them to work which works at a longer range but only if character is facing the speaker
				           ||
				           ( sTranslate != "<SIGNEMOTES>" && GetObjectHeard(oSpeaker, oListener) && GetDistanceBetween(oSpeaker, oListener)<20.0 ) // not sign language, so you have to be able to hear them
				        )
				{
					if ( sLang == "babble" ) // special exception, this language only makes sense to others who are under the effects of the babble spell IF it has the same caster
					{
						if ( GetHasSpell( SPELL_BABBLE, oListener ) )
						{
							if ( CSLGetTargetTagInt( SCSPELLTAG_CASTERPOINTER, oListener, SPELL_BABBLE ) == CSLGetTargetTagInt( SCSPELLTAG_CASTERPOINTER, oSpeaker, SPELL_BABBLE ) )
							{
								SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, " " + "Translated: (" + sName + ") " + sOriginal, FALSE );
							}
						}
						// note that if they don't have the spell, there is no way to understand what is said...
					}
					else if ( GetHasFeat( iFeatId, oListener) )// has feat for language
					{
						SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, "  "+ sName + " : " + sOriginal, FALSE );
					}
					else if ( GetHasSpell(SPELL_TONGUES, oListener) || GetHasFeat( FEAT_LANG_OMNILINGUAL, oListener) )
					{
						// DMFI_LANGUAGE_HOTBARLISTTEMP
						CSLLanguageApplyTempLanguage( oListener, sLang );
						CSLLanguageUIChatIconRow( oListener, sLang );
						SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, " " + "Translated: (" + sName + ") " + sOriginal, FALSE );
					}
					else if ( GetHasFeat( FEAT_LANG_COMPRENSION, oListener) || GetHasSpell(SPELL_COMPREHEND_LANGUAGES, oListener) )
					{ // Speaks language
						SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, " " + "Translated: (" + sName + ") " + sOriginal, FALSE );
						//CSLMessage_SendText(oListener, " " + GetName(oSpeaker) + " " + "Translated: " + CSLStringToProper(sLang) + " " + sTranslate, FALSE, COLOR_GREY);
					} 
					else if ( ( GetHasFeat( FEAT_LANG_TELETRANSLATION, oSpeaker ) || GetHasFeat( FEAT_LANG_TELETRANSLATION, oListener ) ) && !CSLGetIsMindless( oSpeaker ) && !CSLGetIsMindless( oListener ) )
					{
						// understands language telepathically
						SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, " " + "Which means: " + sOriginal, FALSE );
					}
					else
					{	
						if ( CSLGetPreferenceSwitch("LanguageAllowLoreToDecipher", FALSE )  ==TRUE) //Qk: added as option
						{
							nTest = ( d20() + GetSkillRank(SKILL_LORE, oListener));
							if ( GetHasFeat( FEAT_LANG_LINGUIST, oListener) )
							{
								iCurDifficulty = CSLGetMax(iDifficulty-1,1);
							}
							else
							{
								iCurDifficulty = CSLGetMax(iDifficulty,1);
							}
							
							iDifficultyCheck = (iCurDifficulty*5)+10;
							
							if ( nTest > iDifficultyCheck )
							{
								if ( nTest > (iDifficultyCheck+15) )
								{
									if ( sTranslated75perc == "" )
									{
										sTranslated75perc = CSLLanguagePartiallyTranslate( 75, sTranslate, sOriginal );
									}
									DelayCommand( 0.0f, CSLLanguageSendLoreResults( oListener, oSpeaker, sTranslated75perc, sTranslate, sName ) );
				
								}
								else if ( nTest > (iDifficultyCheck+10) )
								{
								
									if ( sTranslated50perc == "" )
									{
										sTranslated50perc = CSLLanguagePartiallyTranslate( 50, sTranslate, sOriginal );
									}
									DelayCommand( 0.0f, CSLLanguageSendLoreResults( oListener, oSpeaker, sTranslated50perc, sTranslate, sName ) );
								}
								else if ( nTest > (iDifficultyCheck+5) )
								{
								
									if ( sTranslated25perc == "" )
									{
										sTranslated25perc = CSLLanguagePartiallyTranslate( 25, sTranslate, sOriginal );
									}
									DelayCommand( 0.0f, CSLLanguageSendLoreResults( oListener, oSpeaker, sTranslated25perc, sTranslate, sName ) );
								}
								else
								{
									DelayCommand( 0.0f, CSLLanguageSendLoreResults( oListener, oSpeaker, sTranslate, sTranslate, sName ) );
								}			
							}
						}
					}
				}	
			}
		}
		oListener = GetNextPC();
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_TranslateToSpeakers End", oSpeaker ); }
}


// DMFI_TranslateToSpeakers(object oSpeaker, string sTranslate, string sLang, object oUI)
int CSLLanguageUnderstood(object oListener, string sLang ) // option for if heard or read
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_TranslateToListeners Start", oListener ); }
	//Purpose: Sends sTranslate to any nearby speakers of sLang
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 1/10/7
	sLang = GetStringLowerCase(sLang);
	int nTest;
	int iFeatId = -1;
	int n=1;
	string sFeatId, sName, sDifficulty, sFamily, sSubGroup;
	if ( sLang=="common" || sLang=="" )
	{
		return TRUE;
	}
	//{
	//	//CSLMessage_SendText(oUI, GetName(oListener) + " : " + sTranslate, FALSE, COLOR_BROWN);
	//	SendChatMessage(oListener, OBJECT_INVALID, CHAT_MODE_TALK, CSLColorText(sTranslate, COLOR_BROWN), FALSE );
	//}
	
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLang );
	
	if ( GetLocalString(oListener, DMFI_LANGUAGE_CURLABEL ) == sLang )
	{
		iFeatId = GetLocalInt(oListener, DMFI_LANGUAGE_CURFEAT );
		sName = GetLocalString(oListener, DMFI_LANGUAGE_CURNAME );
		sDifficulty = GetLocalString(oListener, DMFI_LANGUAGE_CURDIFFICULTY );
		sFamily = GetLocalString(oListener, DMFI_LANGUAGE_CURFAMILY );
		sSubGroup = GetLocalString(oListener, DMFI_LANGUAGE_CURSUBGROUP );
	}
	else // something is wrong, we need to fix something, or tweak things so it's an exact match
	{
		object oLanguageTable = CSLDataObjectGet( "languages" );
		int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLang );
		
		sLang = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
		sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
		sName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow ) ;
		sDifficulty = CSLDataTableGetStringByRow( oLanguageTable, "Difficulty", iRow ) ;
		sFamily = CSLDataTableGetStringByRow( oLanguageTable, "Family", iRow ) ;
		sSubGroup = CSLDataTableGetStringByRow( oLanguageTable, "SubGroup", iRow ) ;
		
		if ( sFeatId != "" && StringToInt(sFeatId) > 0 )
		{
			iFeatId = StringToInt(sFeatId);
		}
		// go ahead and save them for later
		SetLocalString(oListener, DMFI_LANGUAGE_CURLABEL, sLang );
		SetLocalInt(oListener, DMFI_LANGUAGE_CURFEAT, iFeatId );
		SetLocalString(oListener, DMFI_LANGUAGE_CURNAME, sName );
		SetLocalString(oListener, DMFI_LANGUAGE_CURDIFFICULTY, sDifficulty );
		SetLocalString(oListener, DMFI_LANGUAGE_CURFAMILY, sFamily );
		SetLocalString(oListener, DMFI_LANGUAGE_CURSUBGROUP, sSubGroup );
		
		// iFeatId = StringToInt(sFeatId);
	}
	
	// !CSLIsClose(oTarget, oCounterSpeller, 40.0f )
	int iDifficulty = StringToInt(sDifficulty);
	int iCurDifficulty;
	int iDifficultyCheck;  // 15 to 35 range 
	
	
			
	if ( CSLGetIsDM(oListener, FALSE) || GetIsDMPossessed(oListener) )
	{
		//CSLLanguageApplyTempLanguage( oListener, sLang );
		//CSLLanguageUIChatIconRow( oListener, sLang );
		//SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, " " + "DM "+GetName(oListener)+" Translated: (" + sName + ") " + sOriginal, FALSE );
		return TRUE;
	}
	//else if ( 
	//		   ( sTranslate == "<SIGNEMOTES>" && CSLIsCreatureInView(oListener, 220.0f, oSpeaker ) && GetDistanceBetween(oSpeaker, oListener)<40.0 ) // sign language, requires seeing them to work which works at a longer range but only if character is facing the speaker
	//		   ||
	//		   ( sTranslate != "<SIGNEMOTES>" && GetObjectHeard(oSpeaker, oListener) && GetDistanceBetween(oSpeaker, oListener)<20.0 ) // not sign language, so you have to be able to hear them
	//		)
	//{
	
	if ( sLang == "babble" ) // special exception, this language only makes sense to others who are under the effects of the babble spell IF it has the same caster
	{
		if ( GetHasSpell( SPELL_BABBLE, oListener ) )
		{
			//if ( CSLGetTargetTagInt( SCSPELLTAG_CASTERPOINTER, oListener, SPELL_BABBLE ) == CSLGetTargetTagInt( SCSPELLTAG_CASTERPOINTER, oSpeaker, SPELL_BABBLE ) )
			//{
			return TRUE;
			//}
		}
		// note that if they don't have the spell, there is no way to understand what is said...
	}
	else if ( GetHasFeat( iFeatId, oListener) )// has feat for language
	{
		//SendChatMessage(oSpeaker, oListener, CHAT_MODE_TELL, "  "+ sName + " : " + sOriginal, FALSE );
		return TRUE;
	}
	else if ( GetHasSpell(SPELL_TONGUES, oListener) || GetHasFeat( FEAT_LANG_OMNILINGUAL, oListener) )
	{
		return TRUE;
	}
	else if ( GetHasFeat( FEAT_LANG_COMPRENSION, oListener) || GetHasSpell(SPELL_COMPREHEND_LANGUAGES, oListener) )
	{ // Speaks language
		return TRUE;
	} 
	else
	{	
		if ( CSLGetPreferenceSwitch("LanguageAllowLoreToDecipher", FALSE )  ==TRUE) //Qk: added as option
		{
			nTest = ( d20() + GetSkillRank(SKILL_LORE, oListener));
			if ( GetHasFeat( FEAT_LANG_LINGUIST, oListener) )
			{
				iCurDifficulty = CSLGetMax(iDifficulty-1,1);
			}
			else
			{
				iCurDifficulty = CSLGetMax(iDifficulty,1);
			}
			
			iDifficultyCheck = (iCurDifficulty*5)+10;
			
			if ( nTest > iDifficultyCheck )
			{
				if ( nTest > (iDifficultyCheck+15) )
				{
					//if ( sTranslated75perc == "" )
					//{
						//sTranslated75perc = CSLLanguagePartiallyTranslate( 75, sTranslate, sOriginal );
					//}
					//DelayCommand( 0.0f, CSLLanguageSendLoreResults( oListener, oSpeaker, sTranslated75perc, sTranslate, sName ) );
					return TRUE;

				}
				else if ( nTest > (iDifficultyCheck+10) )
				{
					return FALSE;
					//if ( sTranslated50perc == "" )
					//{
					//	sTranslated50perc = CSLLanguagePartiallyTranslate( 50, sTranslate, sOriginal );
					//}
					//DelayCommand( 0.0f, CSLLanguageSendLoreResults( oListener, oSpeaker, sTranslated50perc, sTranslate, sName ) );
				}
				else if ( nTest > (iDifficultyCheck+5) )
				{
					return FALSE;
					//if ( sTranslated25perc == "" )
					//{
					//	sTranslated25perc = CSLLanguagePartiallyTranslate( 25, sTranslate, sOriginal );
					//}
					//DelayCommand( 0.0f, CSLLanguageSendLoreResults( oListener, oSpeaker, sTranslated25perc, sTranslate, sName ) );
				}
				else
				{
					return FALSE;
					//DelayCommand( 0.0f, CSLLanguageSendLoreResults( oListener, oSpeaker, sTranslate, sTranslate, sName ) );
				}			
			}
		}
	}
	//}
	return FALSE;
			
}




int CSLLanguageGetLanguagePoints( object oPlayer )
{
	int iLanguagePoints = CSLFeatGroupToInteger( 8800, 8807, oPlayer );
	
	// increases in lore base rank are added directly to language points
	int iCurrentLore = GetSkillRank(SKILL_LORE, oPlayer, TRUE );
	iCurrentLore = CSLGetMin( iCurrentLore, 4+GetHitDice(oPlayer)  ); // sanity cap for dm's who have 100 points
	
	int iPreviousLore = CSLFeatGroupToInteger( 8808, 8815, oPlayer );
	
	int iCurrentIntBonus = CSLGetMax((GetAbilityScore(oPlayer, ABILITY_INTELLIGENCE, TRUE)-10)/2,0); // gets the actual base bonus, never goes negative as a gift to players
	int iPreviousIntBonus = CSLFeatGroupToInteger( 8821, 8828, oPlayer );
	
	if ( iCurrentLore > iPreviousLore || iCurrentIntBonus > iPreviousIntBonus )
	{
		if ( iCurrentLore > iPreviousLore ) // ignores issues where lore goes down after it goes up, it has to rise above whatever it was at its previous highest
		{
			CSLIntegerToFeatGroup( iCurrentLore, 8808, 8815, oPlayer );
			iLanguagePoints += ( iCurrentLore - iPreviousLore );
		}
		if ( iCurrentIntBonus > iPreviousIntBonus ) // ignores issues where Intelligence goes down after it goes up, it has to rise above whatever it was at its previous highest
		{
			CSLIntegerToFeatGroup( iCurrentIntBonus, 8821, 8828, oPlayer );
			iLanguagePoints += ( iCurrentIntBonus - iPreviousIntBonus );
		}
		CSLIntegerToFeatGroup( iLanguagePoints, 8800, 8807, oPlayer );
	}
	return iLanguagePoints;
}


// this returns list of available optional languages for that ui, but also preps the character with any languages they should know
string CSLLanguageDetermineAvailable( object oPC = OBJECT_SELF, int iRegion = -1, int iClass1 = 255, int iClass2 = 255, int iClass3 = 255, int iClass4 = 255, int iDeity = -1, int iSubRace = -1  ) 
{
	// oPC, int iClass1 = 255, int iClass2 = 255, int iClass3 = 255, int iClass4 = 255, int iDeity = -1, int iRegion
	string sAvailableLanguages = "";
	//string sLangArray;
	
	// fix things if end user decided to use default values with this function
	if ( iSubRace == -1 )
	{
		iSubRace = GetSubRace( oPC );
	}
	
	if ( iClass1 == 255 )
	{
		iClass1 =  GetClassByPosition(1, oPC);
		iClass2 =  GetClassByPosition(2, oPC);
		iClass3 =  GetClassByPosition(3, oPC);
		iClass4 =  GetClassByPosition(4, oPC);
	}
	
	if ( iDeity == -1 )
	{
		iDeity = CSLGetDeityDataRowByFollower( oPC );
	}
	if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: CSLLanguageDetermineAvailable for "+GetName(oPC)+" iClass1="+IntToString( iClass1 )+", iClass2="+IntToString( iClass2 )+", iClass3="+IntToString( iClass3 )+", iClass4="+IntToString( iClass4 )+", iDeity="+IntToString( iDeity )+", iRegion ="+IntToString( iRegion ) ,-1,CHAT_COLOR_DEBUG) ); }
	//SendMessageToPC( GetFirstPC(), "Class1= "+IntToString(iClass1)+" Class2= "+IntToString(iClass2)+" Class3= "+IntToString(iClass3)+" Class4= "+IntToString(iClass4)+" iDeity= "+IntToString(iDeity)+" iSubRace= "+IntToString(iSubRace) +" iRegion= "+IntToString(iRegion)  ); 
		
	string sLangAutomatic = ""; // these are the languages the player should know
	string sLangOptional = ""; // these are the languages the player can still learn
	
	if( CSLGetPreferenceSwitch("LanugagesAllPlayersGrantedCommon", FALSE ) ) // this makes sure everyone knows common
	{
		sLangAutomatic = "common";
	}

	if ( iClass1 != 255 )
	{
		
		//SendMessageToPC( GetFirstPC(), "Loading Class "+IntToString(iClass1) );
		sLangAutomatic = CSLNth_JoinUnique( sLangAutomatic, GetStringLowerCase(Get2DAString("csl_lang_classes", "Automatic", iClass1 )) );
		sLangOptional  = CSLNth_JoinUnique( sLangOptional, GetStringLowerCase(Get2DAString("csl_lang_classes", "Optional", iClass1 )) );
		
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: after iClass1="+IntToString(iClass1) ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangOptional="+sLangOptional ,-1,CHAT_COLOR_DEBUG) ); }
	}
	
	if ( iClass2 != 255 )
	{
		//SendMessageToPC( GetFirstPC(), "Loading Class "+IntToString(iClass2) );
		sLangAutomatic = CSLNth_JoinUnique( sLangAutomatic, GetStringLowerCase(Get2DAString("csl_lang_classes", "Automatic", iClass2 )) );
		sLangOptional  = CSLNth_JoinUnique( sLangOptional, GetStringLowerCase(Get2DAString("csl_lang_classes", "Optional", iClass2 )) );
		
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: after iClass2="+IntToString(iClass2) ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangOptional="+sLangOptional ,-1,CHAT_COLOR_DEBUG) ); }
	}
	
	if ( iClass3 != 255 )
	{
		//SendMessageToPC( GetFirstPC(), "Loading Class "+IntToString(iClass3) );
		sLangAutomatic = CSLNth_JoinUnique( sLangAutomatic, GetStringLowerCase(Get2DAString("csl_lang_classes", "Automatic", iClass3 )) );
		sLangOptional  = CSLNth_JoinUnique( sLangOptional, GetStringLowerCase(Get2DAString("csl_lang_classes", "Optional", iClass3 )) );
		
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: after iClass3="+IntToString(iClass3) ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangOptional="+sLangOptional ,-1,CHAT_COLOR_DEBUG) ); }
	}
	
	if ( iClass4 != 255 )
	{
		//SendMessageToPC( GetFirstPC(), "Loading Class "+IntToString(iClass4) );
		sLangAutomatic = CSLNth_JoinUnique( sLangAutomatic, GetStringLowerCase(Get2DAString("csl_lang_classes", "Automatic", iClass4 )) );
		sLangOptional  = CSLNth_JoinUnique( sLangOptional, GetStringLowerCase(Get2DAString("csl_lang_classes", "Optional", iClass4 )) );
		
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: after iClass4="+IntToString(iClass4) ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangOptional="+sLangOptional ,-1,CHAT_COLOR_DEBUG) ); }
	}
	
	if ( iSubRace != -1 )
	{
		//SendMessageToPC( GetFirstPC(), "Loading iSubRace "+IntToString(iSubRace) );
		sLangAutomatic = CSLNth_JoinUnique( sLangAutomatic, GetStringLowerCase(Get2DAString("csl_lang_races", "Automatic", iSubRace )) );
		sLangOptional  = CSLNth_JoinUnique( sLangOptional, GetStringLowerCase(Get2DAString("csl_lang_races", "Optional", iSubRace )) );
		
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: after iSubRace="+IntToString(iSubRace),-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangOptional="+sLangOptional ,-1,CHAT_COLOR_DEBUG) ); }
	}
	
	
	if ( iRegion != -1 )
	{
		//SendMessageToPC( GetFirstPC(), "Loading iRegion "+IntToString(iRegion) );
		sLangAutomatic = CSLNth_JoinUnique( sLangAutomatic, GetStringLowerCase(Get2DAString("csl_lang_regions", "Automatic", iRegion )) );
		sLangOptional  = CSLNth_JoinUnique( sLangOptional, GetStringLowerCase(Get2DAString("csl_lang_regions", "Optional", iRegion )) );
		
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: after iRegion="+IntToString(iRegion) ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangOptional="+sLangOptional ,-1,CHAT_COLOR_DEBUG) ); }
	}
	
	if ( iDeity != -1 ) // Automatic is ONLY granted IF deitylang is already in automatic list, other wise it's added to the optional list, deitylang is put in any class which is one which serves a god of some sort ( ie if you are a cleric it's automatic, if a mere follower the same languages become optional
	{
		//SendMessageToPC( GetFirstPC(), "Loading iDeity "+IntToString(iDeity) );
		if ( FindSubString( ","+sLangAutomatic+",", ","+"deitylang"+"," ) != -1 )
		{
			sLangAutomatic = CSLNth_JoinUnique( sLangAutomatic, GetStringLowerCase(Get2DAString("csl_lang_deity", "Automatic", iDeity )) );
		}
		else
		{
			sLangOptional  = CSLNth_JoinUnique( sLangOptional, GetStringLowerCase(Get2DAString("csl_lang_deity", "Optional", iDeity )) );
		}
		sLangOptional  = CSLNth_JoinUnique( sLangOptional, GetStringLowerCase(Get2DAString("csl_lang_deity", "Optional", iDeity )) );
		
		
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: after Deity="+IntToString(iDeity) ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangOptional="+sLangOptional ,-1,CHAT_COLOR_DEBUG) ); }
	}		
	
	if( !CSLGetPreferenceSwitch("LanguagesGiveDefaults", TRUE ) )
	{
		// put the automatic languages into the options
		//SendMessageToPC( GetFirstPC(), "Language Defaults not enabled" );
		sLangOptional = CSLNth_JoinUnique( sLangOptional, sLangAutomatic );
		sLangAutomatic = "";
	}
	
	if ( !GetHasFeat( FEAT_LANG_BASE, oPC ) ) // this is run the first time around only, soas anything that needs to be merged can be done
	{
		//SendMessageToPC( GetFirstPC(), "Language Merging in DMFI Languages" );
		// this gets the list of DMFI granted languages
		sLangAutomatic = CSLLanguageMergeDMFIGranted( oPC, sLangAutomatic );
		
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: add common=" ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
	}
	
		// handle any feats, fiendish heritage, fey heritage, being a speciality wizard ( illionist )
	// these are hard coded, if removed from system will just be ignored
	if ( GetHasFeat( FEAT_FEY_HERITAGE , oPC ) )
	{
		sLangOptional = CSLNth_Push(sLangOptional, "sylvan", ",", TRUE );
	}
	
	if ( GetHasFeat( FEAT_FIENDISH_HERITAGE , oPC ) )
	{
		if (GetAlignmentLawChaos(oPC)==ALIGNMENT_LAWFUL)
		{
			sLangOptional = CSLNth_Push(sLangOptional, "infernal", ",", TRUE );
		}
		else
		{
			sLangOptional = CSLNth_Push(sLangOptional, "abyssek", ",", TRUE );
		}
	}
	
	// this is intentionally calling a variable, it may or may not be set, but its part of the AI
	// prevents needing to include hkspell,and the only way to get this variable filled in is a gui callback
	// if its not present its not much impact on the player
	if ( GetLocalInt( oPC, "SC_iSpellSchool") == SPELL_SCHOOL_ILLUSION )
	{
		sLangOptional = CSLNth_Push(sLangOptional, "ruathlek", ",", TRUE );
	}
	
	
	if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "Debug: After optional feats" ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangAutomatic="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
		if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( "   sLangOptional="+sLangOptional ,-1,CHAT_COLOR_DEBUG) ); }
	
	object oLanguageTable = CSLDataObjectGet( "languages" );

	// now lets iterate the language 2da, and look for books to help learn a language, they only add it to the optional list
	int iTotalRows = CSLDataTableCount( oLanguageTable );
		int iRow, iCurrent, i;
		string sNewLanguage, sCurrentLevel;
	
		for ( iCurrent = 0; iCurrent <= iTotalRows; iCurrent++) // changed from <=
		{	
			iRow = CSLDataTableGetRowByIndex( oLanguageTable, iCurrent );
			if ( iRow > -1 )
			{
				sNewLanguage = GetStringLowerCase( CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ) );
				if ( sNewLanguage != "" && GetIsObjectValid( GetItemPossessedBy( oPC, "csl_book_"+sNewLanguage )) )
				{
					sLangOptional = CSLNth_Push(sLangOptional, sNewLanguage, ",", TRUE );
				}
			}
		}
	
	
	
	
	//SendMessageToPC( GetFirstPC(), "Language sLangAutomatic="+sLangAutomatic+" sLangOptional="+sLangOptional );
	
	
	
	
	if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( " Completed  sLangAutomatic and adding to character ="+sLangAutomatic ,-1,CHAT_COLOR_DEBUG) ); }
	
	//int iLanguageFeat;
	if ( sLangAutomatic != "" )
	{
		int iAutomaticCount = CSLNth_GetCount( sLangAutomatic );
		for ( i=1; i <= iAutomaticCount; i++ )
		{
			sNewLanguage = CSLNth_GetNthElement(sLangAutomatic, i);
			
			//iLanguageFeat = CSLLanguageGetFeatFor( sNewLanguage );
			iRow = CSLDataTableGetRowByValue( oLanguageTable, sNewLanguage );
			if ( iRow != -1 )
			{			
				string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
				
				if ( sFeatId != "" && !GetHasFeat( StringToInt( sFeatId ) , oPC ) )
				{
					FeatAdd( oPC, StringToInt( sFeatId ) , TRUE, FALSE );
				}
			}
		}
	}
	
	if ( !GetHasFeat( FEAT_LANG_BASE, oPC ) ) // this is run the first time around only, soas anything that needs to be merged can be done
	{	
		//SendMessageToPC( GetFirstPC(), "Language Addng in base feat");
		FeatAdd( oPC, FEAT_LANG_BASE , TRUE, FALSE );
	}
	
	if ( sLangOptional != "" && CSLGetPreferenceSwitch("LanguagePlayerChoose", FALSE ) )
	{
		int iOptionalCount = CSLNth_GetCount( sLangOptional );
		int iLanguagePoints = CSLLanguageGetLanguagePoints( oPC );
		string sFeatId, sLabel;
		int iDifficulty;
		for ( i=1; i <= iOptionalCount; i++ )
		{
			sNewLanguage = CSLNth_GetNthElement(sLangOptional, i);
			//iLanguageFeat = CSLLanguageGetFeatFor( sNewLanguage );
			iRow = CSLDataTableGetRowByValue( oLanguageTable, sNewLanguage );
			if ( iRow != -1 )
			{
				sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
				if ( sFeatId != "" && !GetHasFeat( StringToInt( sFeatId ) , oPC ) )
				{
					iDifficulty = StringToInt( CSLDataTableGetStringByRow( oLanguageTable, "Difficulty", iRow ) );					
					if ( iDifficulty <= iLanguagePoints )
					{
						sLabel = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
						sAvailableLanguages = CSLNth_Push(sAvailableLanguages, sLabel, ",", TRUE );
					}
				}
			}
		}
	}
		
		
	
	
	SetLocalString(oPC, DMFI_LANGUAGE_HOTBARLIST, "" );
	CSLLanguageUIChatIconRow( oPC );
	if ( sAvailableLanguages == "" )
	{
		sAvailableLanguages="-";
	}
	SetLocalString(oPC, DMFI_LANGUAGE_LEARNABLELIST, sAvailableLanguages );
	
	if ( DEBUGGING > 3 ) { SendMessageToPC(oPC,CSLColorText( " Completed  sAvailableLanguages="+sAvailableLanguages ,-1,CHAT_COLOR_DEBUG) ); }
	return sAvailableLanguages;
}




void CSLLanguageAdjustLanguagePoints( int iAdjustmentAmount, object oPlayer )
{
	int iLanguagePoints = CSLFeatGroupToInteger( 8800, 8807, oPlayer )+iAdjustmentAmount;	
	CSLIntegerToFeatGroup( iLanguagePoints, 8800, 8807, oPlayer );
}

// designed for a player to target themselves initially, will likely just integrate this into the character editor for DM adjustments later
void CSLLanguageOpenChooser( object oPC = OBJECT_SELF, string sLanguageLearnable = "", string sLanguageLearning = "" )
{
	//SendMessageToPC(oPC, "CSLLanguageOpenChooser");
	string sLanguageKnown = GetLocalString(oPC, DMFI_LANGUAGE_KNOWNLIST );
	sLanguageLearnable = GetLocalString(oPC, DMFI_LANGUAGE_LEARNABLELIST );
	sLanguageLearning = GetLocalString(oPC, DMFI_LANGUAGE_LEARNINGLIST );
	
	int iLanguagePointsUsed = GetLocalInt(oPC, DMFI_LANGUAGE_POINTSUSED );
	
	if ( sLanguageLearnable == "" && sLanguageLearning == "" )
	{
		CSLLanguageDetermineAvailable( oPC ); // fix things since it looks like nothing was run
		sLanguageLearnable = GetLocalString(oPC, DMFI_LANGUAGE_LEARNABLELIST );
		sLanguageLearning = GetLocalString(oPC, DMFI_LANGUAGE_LEARNINGLIST );
	}
	
	if ( sLanguageLearnable == "-" )
	{
		//SendMessageToPC(oPC, "Error, none learnable");
		return; // nothing to learn so skip it
	}
	
	if ( CSLGetPreferenceSwitch("LanguagePlayerChoose", FALSE ) )
	{
		// show dialog to the given player, this is just a placeholder at this point
		// SendMessageToPC( oPC, "UI is not implemented yet, but the available options for your character will be "+sLanguageOptions);
		//SendMessageToPC(oPC, "Choosing");
		object oLanguageTable = CSLDataObjectGet( "languages" );
		if ( GetIsObjectValid(oLanguageTable) )
		{
			//SendMessageToPC(oPC, "Have Table, opening5");
			int iLanguagePoints = CSLGetMax(CSLLanguageGetLanguagePoints( oPC )-iLanguagePointsUsed,0);
			int iShowNonLearnableLanguages = CSLGetPreferenceSwitch("LanguagesShowUnlearnableOnLevelup", FALSE );
			
			if ( iLanguagePoints > 0 ) // don't bother if they have no points to spend
			{
				DisplayGuiScreen(oPC, SCREEN_LEVELUPLANGUAGES, FALSE, XML_LEVELUPLANGUAGES);
				
				ClearListBox( oPC, SCREEN_LEVELUPLANGUAGES, "ADDED_LANGUAGE_LIST" );
				ClearListBox( oPC, SCREEN_LEVELUPLANGUAGES, "AVAILABLE_LANGUAGE_LIST" );
				
				SetLocalGUIVariable(oPC,SCREEN_LEVELUPLANGUAGES,999,IntToString(ObjectToInt(oPC)));
				
				
				
				SetGUIObjectText(oPC, SCREEN_LEVELUPLANGUAGES, "POINT_POOL_TEXT", -1, IntToString( iLanguagePoints ) );
				
				int iTotalRows = CSLDataTableCount( oLanguageTable );
				int iRow, iCurrent;
				string sName, sLabel, sType, sCurrentLevel, sFeatId,sListBox,sRowName,sFields,sTextures,sVariables,sHide;
			
				for ( iCurrent = 0; iCurrent <= iTotalRows; iCurrent++) // changed from <=
				{	
					
					iRow = CSLDataTableGetRowByIndex( oLanguageTable, iCurrent );
					if ( iRow > -1 )
					{
						sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
						if ( sFeatId != "" )
						{
							sLabel = GetStringLowerCase( CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ) );
							sType = CSLDataTableGetStringByRow( oLanguageTable, "Type", iRow );
							if ( sType != "Accent" )
							{
								sName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow ) ;
								//sFields="LANGUAGE_TEXT="+sName;
								//sVariables="25="+sLabel;
								sVariables = "25="+sLabel;
								sTextures = "LANGUAGE_IMAGE="+CSLDataTableGetStringByRow( oLanguageTable, "Icon", iRow )+".tga";;
								if ( GetHasFeat( StringToInt(sFeatId), oPC) )
								{
									// add this to the known column, and set as disabled							
									sHide =	"LANGUAGE_ACTION=hide";
									sFields="LANGUAGE_TEXTDISABLED="+sName;
									AddListBoxRow(oPC,SCREEN_LEVELUPLANGUAGES,"ADDED_LANGUAGE_LIST",sLabel,sFields,sTextures,sVariables,sHide);
								}
								else if ( FindSubString( ","+sLanguageLearning+",", ","+sLabel+"," ) != -1 )
								{
									sHide =	"LANGUAGE_ACTION=unhide";
									sFields="LANGUAGE_TEXTENABLED="+sName;
									AddListBoxRow(oPC,SCREEN_LEVELUPLANGUAGES,"ADDED_LANGUAGE_LIST",sLabel,sFields,sTextures,sVariables,sHide);
								}
								else if ( FindSubString( ","+sLanguageLearnable+",", ","+sLabel+"," ) != -1 )
								{
									sHide =	"LANGUAGE_ACTION=unhide";
									sFields="LANGUAGE_TEXTENABLED="+sName;
									AddListBoxRow(oPC,SCREEN_LEVELUPLANGUAGES,"AVAILABLE_LANGUAGE_LIST",sLabel,sFields,sTextures,sVariables,sHide);		
								}
								else if ( iShowNonLearnableLanguages )
								{
									sHide =	"LANGUAGE_ACTION=hide";
									sFields="LANGUAGE_TEXTDISABLED="+sName;
									AddListBoxRow(oPC,SCREEN_LEVELUPLANGUAGES,"AVAILABLE_LANGUAGE_LIST",sLabel,sFields,sTextures,sVariables,sHide);
								}
							}
							
						}
					}
				}
			}
		}
		// list of known languages
		
		// DISABLED list of unknowable languages, this is either going to be blank or show as a preference
		// LEARNABLE list of learnable languages as input to this function
		// LEARNING - list which you are about to learn
		// KNOWN - list what is already known
		
		/*
		const string DMFI_LANGUAGE_KNOWNLIST = "DMFILangKnownList";
		const string DMFI_LANGUAGE_LEARNABLELIST = "DMFILangLearnableList";
		const string DMFI_LANGUAGE_LEARNINGLIST = "DMFILangLearningList";
		*/
		

	}
}

void CSLLanguageAccentUse( string sLanguageVar, object oPC = OBJECT_SELF )
{
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLanguageVar );
	if ( iRow != -1 )
	{
		sLanguageVar = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
		//string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
		string sName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow );
		string sType = CSLDataTableGetStringByRow( oLanguageTable, "Type", iRow );

		if ( sType == "Accent" )
		{
			SetLocalString(oPC, DMFI_ACCENT_TOGGLE, sLanguageVar );
			SendMessageToPC(oPC,"Setting your accent to "+sName );
		}
	}
	
}

void CSLLanguageUse( string sLanguageVar, object oPC = OBJECT_SELF )
{
	// add in validity checks to make sure they have the proper feat for the given language, prevents cheating
	// add in things to check for being a dm, for special spells that add langauges and the like here
	// assume the variable is guarded well via this
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLanguageVar );
	int iFeatId = -1;
	sLanguageVar = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
	string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
	string sName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow );
	string sType = CSLDataTableGetStringByRow( oLanguageTable, "Type", iRow );
	if ( sType != "Accent" )
	{
		if ( CSLGetIsDM(oPC, TRUE) || GetIsDMPossessed(oPC) || GetHasSpell(SPELL_TONGUES, oPC) || ( StringToInt(sFeatId) > -1 && GetHasFeat(StringToInt(sFeatId), oPC) ) )
		{
			//SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, sLanguageVar );
			//CSLLanguageUse( sLanguageVar, oPC );
			SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, sLanguageVar );
			SendMessageToPC(oPC,"Setting your spoken language to "+sName );
			
			// the following caches this information for later usage by listeners
			
			if ( sFeatId != "" && StringToInt(sFeatId) > 0 )
			{
				iFeatId = StringToInt(sFeatId);
			}
			// go ahead and save them for later
			SetLocalInt(oPC, DMFI_LANGUAGE_CURFEAT, iFeatId );
			SetLocalString(oPC, DMFI_LANGUAGE_CURLABEL, sLanguageVar );
			//SetLocalString(oPC, DMFI_LANGUAGE_CURFEAT, sFeatId );
			SetLocalString(oPC, DMFI_LANGUAGE_CURNAME, sName );
			SetLocalString(oPC, DMFI_LANGUAGE_CURDIFFICULTY, CSLDataTableGetStringByRow( oLanguageTable, "Difficulty", iRow ) );
			SetLocalString(oPC, DMFI_LANGUAGE_CURFAMILY, CSLDataTableGetStringByRow( oLanguageTable, "Family", iRow ) );
			SetLocalString(oPC, DMFI_LANGUAGE_CURSUBGROUP, CSLDataTableGetStringByRow( oLanguageTable, "SubGroup", iRow ) );
			
			CSLLanguageUIChatIconRow( oPC );
		}
	}
}

/*
object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLanguageVar );
	
	string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
	if ( sFeatId == "" )
	{
		return -1;
	}
	return StringToInt( sFeatId );

*/

void CSLLanguageUseNone( object oPC = OBJECT_SELF )
{
	// add in validity checks to make sure they have the proper feats
	SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, "" );
	SendMessageToPC(oPC,"Setting your spoken language to Common");
	CSLLanguageUIChatIconRow( oPC );
	// adjust UI to reflect changes here
}

void CSLLanguageToggle( string sLanguageVar, object oPC = OBJECT_SELF )
{
	// add in validity checks to make sure they have the proper feats
	// string sOldLanguageVar = GetLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
	
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLanguageVar );

	sLanguageVar = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
	string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
	string sName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow );
	
	if ( sLanguageVar == "" || GetLocalString(oPC, DMFI_LANGUAGE_TOGGLE) == sLanguageVar || sLanguageVar == "common")
	{
		SendMessageToPC(oPC,"Setting your spoken language to Common");
		//SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, "" );
		SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, "" );
		CSLLanguageUIChatIconRow( oPC );
		// SendMessageToPC(oPC,"DeActivating");
	}
	else if ( StringToInt(sFeatId) > -1 && GetHasFeat(StringToInt(sFeatId), oPC) )
	{
		//SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, sLanguageVar );
		//CSLLanguageUse( sLanguageVar, oPC );
		SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, sLanguageVar );
		SendMessageToPC(oPC,"Setting your spoken language to "+sName );
		CSLLanguageUIChatIconRow( oPC );
	}
	else
	{
		SendMessageToPC(oPC,"Setting your spoken language to Common");
		SetLocalString(oPC, DMFI_LANGUAGE_TOGGLE, "" );
		CSLLanguageUIChatIconRow( oPC );
	}
}





	
	


// adds a given langauge to a target
// @replaces xxxDMFI_GrantChoosenLang DMFI_GrantLanguage
void CSLLanguageGive(object oPC, string sLang, int bInformTarget = FALSE)
{
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLang );
	
	if ( iRow > -1 )
	{
		string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
		string sLanguageLabel = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
		string sLanguageName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow );
		if ( sFeatId != "" && sLang != "" )
		{
			if ( StringToInt(sFeatId) > -1 && GetHasFeat(StringToInt(sFeatId), oPC) )
			{
				FeatAdd( oPC, StringToInt(sFeatId), TRUE, FALSE );
				if ( bInformTarget )
				{
					SendMessageToPC(oPC, "Language Added: " + sLanguageName );
				}
				SetLocalString(oPC, DMFI_LANGUAGE_HOTBARLIST, CSLNth_Push(GetLocalString(oPC, DMFI_LANGUAGE_HOTBARLIST ), sLanguageLabel, ",", TRUE ) );
				CSLLanguageUIChatIconRow( oPC );
			}
		}
	
	}
}

// removes a given langauge from target
// @replaces xxxDMFI_GrantChoosenLang
void CSLLanguageRemove(object oPC, string sLang, int bInformTarget = FALSE )
{
	object oLanguageTable = CSLDataObjectGet( "languages" );
	int iRow = CSLDataTableGetRowByValue( oLanguageTable, sLang );
	
	if ( iRow > -1 )
	{
		string sFeatId = CSLDataTableGetStringByRow( oLanguageTable, "FeatId", iRow );
		string sLanguageLabel = GetStringLowerCase(CSLDataTableGetStringByRow( oLanguageTable, "Label", iRow ));
		string sLanguageName = CSLDataTableGetStringByRow( oLanguageTable, "Name", iRow );
		if ( sFeatId != "" && sLang != "" )
		{
			if ( StringToInt(sFeatId) > -1 && !GetHasFeat(StringToInt(sFeatId), oPC) )
			{
				FeatRemove( oPC, StringToInt(sFeatId) );
				if ( bInformTarget )
				{
					SendMessageToPC(oPC, "Language Removed: " + sLanguageName );
				}
				SetLocalString(oPC, DMFI_LANGUAGE_HOTBARLIST, CSLNth_Replace( GetLocalString(oPC, DMFI_LANGUAGE_HOTBARLIST ), sLanguageLabel, "" ) );
				CSLLanguageUIChatIconRow( oPC );
			}
		}
	
	}
}





// gets if a language is known or not
// * @ replaces xxxDMFI_IsLanguageKnown
int CSLLanguageLearned( object oPC, string sLang )
{
	int iFeatId = CSLLanguageGetFeatFor( sLang );
	if (iFeatId > -1 && GetHasFeat(iFeatId, oPC) )
	{
		return TRUE;
	}
	return FALSE;
}

int CSLLanguageLearnable( object oPC, string sLang )
{
	int iFeatId = CSLLanguageGetFeatFor( sLang );
	if (iFeatId > -1 && !GetHasFeat(iFeatId, oPC) )
	{
		return TRUE;
	}
	return FALSE;
}

// this is just convenience to test out books and get some text in it, remove at some point
string CSLBookGetRandomVerbiage( int iIndexNumber = 1, int bReturnTitle = FALSE )
{
	int iSubItemNumber = iIndexNumber/10;
	
	if ( bReturnTitle )
	{
		switch(iSubItemNumber)
		{
			case 0:
				switch(iIndexNumber)
				{
					case 1: {return "101 Tales of Adventure";} break;
					case 2: {return "A Treatise on Forgotten Heroes and Villains";} break;
					case 3: {return "Adventurer's Note";} break;
					case 4: {return "Strange Book";} break;
					case 5: {return "Ancient Chronicles of Halueth Never";} break;
					case 6: {return "Burned Book";} break;
					case 7: {return "Complete History of the Creator Ruins";} break;
					case 8: {return "Defense Council Journal";} break;
					case 9: {return "Dispatch";} break;
	
				}
				break;
			case 1:
				switch(iIndexNumber)
				{
					case 10: {return "Dread Queen Morag";} break;
					case 11: {return "Explorer's Journal";} break;
					case 12: {return "Famous Citizens of the Sword Coast";} break;
					case 13: {return "Garg's Book";} break;
					case 14: {return "Halueth Dig Logbook";} break;
					case 15: {return "Halueth's Tomb: An Archeological Logbook";} break;
					case 16: {return "Helm's Hold";} break;
					case 17: {return "History of the Creator Races";} break;
					case 18: {return "History of the Slave Race";} break;
					case 19: {return "Host Tower Lab Notes";} break;
	
				}
				break;
			case 2:
				switch(iIndexNumber)
				{
					case 20: {return "Influential Sorcerers through the Ages";} break;
					case 21: {return "Initiate's Primer";} break;
					case 22: {return "Islegood's Complete History of Flight";} break;
					case 23: {return "Islegood's Complete History of Horses";} break;
					case 24: {return "Islegood's Complete History of Seafaring";} break;
					case 25: {return "Journal of Marcus Penhold";} break;
					case 26: {return "Journal of Meldanen";} break;
					case 27: {return "Journal of Synth La'neral";} break;
					case 28: {return "Kabbernacky's Guide to Mythals";} break;
					case 29: {return "Letter to Rimardo";} break;
	
				}
				break;
			case 3:
				switch(iIndexNumber)
				{
					case 30: {return "Letter";} break;
					case 31: {return "Letter";} break;
					case 32: {return "Luskan's Arcane Brotherhood";} break;
					case 33: {return "Maugrim's Journal";} break;
					case 34: {return "Mechanics of Flight";} break;
					case 35: {return "Notebook";} break;
					case 36: {return "Notebook";} break;
					case 37: {return "Old Scroll";} break;
					case 38: {return "On Riddles and the Dead";} break;
					case 39: {return "Port Llast";} break;
	
				}
				break;
			case 4:
				switch(iIndexNumber)
				{
					case 40: {return "Prayer Book of Lathander";} break;
					case 41: {return "Prayer to the Overgod";} break;
					case 42: {return "Prayers to Mystra";} break;
					case 43: {return "Prison Logbook";} break;
					case 44: {return "Prisoner's Journal";} break;
					case 45: {return "Religions of the Sword Coast";} break;
					case 46: {return "Return of the Beast";} break;
					case 47: {return "Ritual Book";} break;
					case 48: {return "Small Diary";} break;
					case 49: {return "Teleport Scroll";} break;
	
				}
				break;
			case 5:
				switch(iIndexNumber)
				{
					case 50: {return "The Adventures of Grin, Richard, and Wu-Wei ";} break;
					case 51: {return "The Alchemist's Cookbook";} break;
					case 52: {return "The Art of Lichdom";} break;
					case 53: {return "Journal";} break;
					case 54: {return "The Book of Tarmas";} break;
					case 55: {return "The City of Luskan";} break;
					case 56: {return "The City of Neverwinter";} break;
					case 57: {return "The Confessions of Karsus";} break;
					case 58: {return "The Dessarin River";} break;
					case 59: {return "The Doombringers";} break;
	
				}
				break;
			case 6:
				switch(iIndexNumber)
				{
					case 60: {return "The Ghost of Conyberry";} break;
					case 61: {return "The Imps' Prison";} break;
					case 62: {return "The Leadership of Neverwinter";} break;
					case 63: {return "The Nether Scrolls";} break;
					case 64: {return "The Neverwinter Wood";} break;
					case 65: {return "The Northern Four Adventuring Troupe";} break;
					case 66: {return "The Origin of Magic";} break;
					case 67: {return "The Poetry of Dagget Filth";} break;
					case 68: {return "The Rise & Fall of Netheril";} break;
					case 69: {return "The Rival Orc Tribes & their Great Battles";} break;
	
				}
				break;
			case 7:
				switch(iIndexNumber)
				{
					case 70: {return "The Ruins of Illusk";} break;
					case 71: {return "The Sword Coast";} break;
					case 72: {return "The Time of Troubles";} break;
					case 73: {return "The Trade of Blades";} break;
					case 74: {return "The War of Light and Darkness";} break;
					case 75: {return "Greasy Book";} break;
					case 76: {return "Legal Notebook";} break;
					case 77: {return "Legal Notebook";} break;
					case 78: {return "Tome of the Vix'thrite Elders";} break;
					case 79: {return "Treatise on Forgotten Heroes";} break;
	
				}
				break;
			case 8:
				switch(iIndexNumber)
				{
					case 80: {return "Treatise on the Spirit of the Wood";} break;
					case 81: {return "Uthgar's Legacy";} break;
					case 82: {return "Uthgardt Barbarians";} break;
					case 83: {return "Wars of the Creator Races";} break;
					case 84: {return "Waterdeep";} break;
					case 85: {return "Wind by the Fireside";} break;
					case 86: {return "Worn Book";} break;
				}
			break;
		}
		
		// default basically with this
		return "Treatise on the Spirit of the Wood";
	
	}
	else
	{
		switch(iSubItemNumber)
		{
			case 0:
				switch(iIndexNumber)
				{
					case 1: {return "This is a storybook that recounts the adventures of many of Faer�n's best-known heroes. Jam stains and scribbles render some of the stories almost illegible and many of the woodcut illustrations have been 'enhanced' with strategically placed moustaches.";} break;
					case 2:
						return "By Stuufshirt the Scribe\n\nAs the title suggests, this rather hefty tome deals with the lives of heroes and villains. It does not condone or condemn, but instead looks at how history defines the roles they played. A leather bookmark identifies the last passage read.\n\n'The ages have long since turned his enemies to dust, but it has done as much to his own people as well. There is no one left to curse or praise his name."; //  He suffers the same as many others; disinterest has allowed the location of his resting-place to fall into obscurity. The family Ortov has no living extensions, and even the long buried Mirialis Clan founded by his siblings has had its major works removed from the libraries of Candlekeep in favor of books more likely to be of interest to anyone.
						break;
					case 3: {return "This notebook identifies the bearer as an official representative of Tyr's justice in Rolgan's murder trial and explains the rules of court, including the right for defense council to question any of the participants involved before the trial begins.\n\nTo aid you in your task Neurik has included notes on the witnesses and jurors and where you might be able to locate them for questioning.\n\nWitnesses:\nRolgan - the accused. ";} break;
					case 4: {return "Almost everything you would want to know about strange items can be found in this book, though it has been used so much, it might fall apart at any moment.";} break;
					case 5: {return "This aged tome details the latter life of Halueth Never, and the trials that he overcame to found the city of Neverwinter. Much of it is written in an archaic script that will likely take Tyrran scholars years to decipher. ";} break;
					case 6: {return "This book is badly burnt, its charred pages illegible. It is worth less than nothing.";} break;
					case 7: {return "This musty old tome appears to be the type of book that was written and never read. It is a long, boring text written by a druid, Jordius Caini Getafix the Third, several hundred years ago. It uses large, complicated and often seemingly meaningless words to discuss his observations on the Spirit of the Wood. One page in the text has been earmarked and there is a small comment beside an underlined passage in the margin.";} break;
					case 8: {return "This book appears to be the final volume in Islegood's Complete History of Flight, a legendary series written well over a century ago. The work gives a detailed overview of the evolution of flight, both magical and mundane, throughout Faer�n's history, beginning with the earliest attempts by mages to master the art of levitation and concluding with the schematics for several outlandish flying machines created by the gnomes of Lantan.";} break;
					case 9: {return "This scrap of paper was obviously written in a great hurry.\n\n'Maugrim's forces have completely taken over the North Tower. Archmage Arklem is nowhere to be found. How did Maugrim gain so many followers without being noticed?! It is beyond belief!\n\n'Deltagar has commanded us to turn loose the experiments... with luck, they will be more trouble for Valinda and her men than for us.\n\n'If you find this and have not succumbed to Maugrim's lies, flee the Tower immediately!";} break;
	
				}
				break;
			case 1:
				switch(iIndexNumber)
				{
					case 10: {return "The letters in this book swim before your eyes, finally shaping themselves into text that you can understand. It tells the history of a Queen named Morag. While the book is lengthy, one passage of interest tells of Morag's ascension to the throne.\n \n'At the dawning of her first red moon, Morag, the future queen, began her slow and bloody climb toward the seat of power, her sen-mother's throne. Her ascension to the heights of the Dragon Throne was as that of a slow poison";} break;
					case 11: {return "Though this book has been severely damaged by exposure to the elements, large parts of it are surprisingly legible.\n\nIncluded in its pages are translations of the runic language used by the ancient Netherese.\n\nThe remainder seems to be the personal journal of an unnamed explorer who had come to this region determined to find an ancient Netherese temple which he referred to as 'the Ruin of Gur-Atol'.\n\nThe last page is of particular interest and reads:\n\n'I've decided to camp in the forest, tonight.";} break; // Whatever has happened in Charwood, it's something I certainly don't want to get involved in. The villagers there are frightening and will be no help in my search for the temple. It's best I just avoid them entirely.\n\n'Resting in the forest will not be much better, however. To think I scoffed at the tales I was told of it being haunted. It is so eerily silent... yet I will not be deterred. The secret portal that leads into the Ruins of Gur-Atol must be in this area... and I WILL find it. If I am right, the treasure that will still be there will make all these long months worthwhile.' ";} break;
					case 12: {return "The Sword Coast North is home to some of the most noteworthy personalities of the Realms. Many won their fame with deeds of great honor, but others are known for the depths of their depravity and wickedness.\n\nThe officers of Neverwinter fall into the first camp. Lord Nasher Alagondar, Lady Aribeth de Tylmarande, Watchknight Desther Indelayne, and Abbot Fenthick Moss are celebrated for their kindness and wisdom, and each of these heroes has taken the safety of Neverwinter as his or her sacred duty.";} break; // \n\nOn the more sinister side, the five High Captains of Luskan are some of the most cruel and ruthless warriors in the region. High Captains Taerl, Baram, Kurth, Suljack, and Rethnor are each vicious combatants, and together they enforce their will with merciless efficiency. \n\nThe most powerful and feared spellcasters on the Sword Coast are members of the Arcane Brotherhood of Luskan. Among their number are Jaluth Alaerth, Ornar of the Claw, and Deltagar Zelhund. Little is known of the Brotherhood's actual role in governing Luskan and the surrounding areas, and the members themselves are loath to discuss their activities.\n\nThe untamed lands outside the cities hold countless other instances of fame and infamy alike. King Obould Many-Arrows, for instance, reigns over his orc tribes with an iron fist while such well-known rakes and ne'er-do-wells as Elaith 'The Serpent' Craulnober move constantly from hamlet to hamlet to avoid detection.\n";} break;
					case 13: {return "This grease stained, water damaged book was obviously the journal of one of the bandits you killed. The writing is simplistic and the poor spelling and grammar make it almost unreadable.\n\nApparently the bandit was learning to be a scribe when a large stack of books fell over, landing on his head. The bandit must have taken a severe blow to the head, and he was fired from his job.\n\nRecently, he joined a small group of bandits. The bandits robbed and killed some merchants.";} break; //  They burned the notes and have been looking for the tomb, hoping it will have riches hidden within it.";} break;
					case 14: {return "This book details the initial search for the tomb of Halueth Never. It is unfinished, the writer obviously falling to the plague before he could include many details, but it does point to the possible locations for three tombs in addition to the one in the Peninsula District.\n\nBeggar's Nest: Great Graveyard\nDocks District: Northwestern quarter aqueducts\nBlacklake District: Southwestern quarter\n\nThe directions are vague, but the book does mention that each tomb is.";} break; //  A riddle of some sort is the 'key' to each. The solution to the Peninsula tomb door was 'Emerald,' which was answered by actually placing an emerald in the container immediately next to the door. It is worth noting that this action seemed to destroy the item, making it an expensive discovery.\n\nText of the 'Emerald riddle' on the Peninsula tomb:\nDiamond of the forest, if the seasons never changed.\n";} break;
					case 15: {return "This book details the initial search for the tomb of Halueth Never. It is unfinished, the writer obviously falling to the plague before he could include many details, but it does point to the possible locations for three tombs in addition to the one in the Peninsula District:\n\nBeggar's Nest: Eastern quarter\nDocks District: Northeastern quarter\nBlacklake District: Southwestern quarter\n\nThe directions are vague, but the book also mentions that each tomb may be sealed.";} break; //  A riddle of some sort is the 'key' to each. The solution to the Peninsula tomb door was 'Emerald,' which was answered by actually placing an emerald in the container immediately next to the opening. It is worth noting that this action seemingly destroyed the emerald.\n\nText of the 'Emerald riddle' on the Peninsula tomb:\n'Diamond of the forest, if the seasons never changed.'\n";} break;
					case 16: {return "Less than a day's travel southeast of Neverwinter is Helm's Hold, a fortified monastery dedicated to the God of Guardians. It was founded around the middle 1340s DR (Dale Reckoning) by Dumal Erard, a retired member of the Company of Crazed Venturers of Waterdeep. It has grown to a watchful community of over 700 faithful. The people here grow their own crops, herd their own cattle, dig deep wells for their own water, and patrol the area with vigilance.";} break; //  They will give shelter to any travelers beset or weakened by brigands or monsters.";} break;
					case 17: {return "In a time when the North was always warm and the seas of the world were deeper, empires of inhuman peoples dominated the lands of Toril. In the elven tradition, these were the days when the Iquar'Tel'Quessir, or creator races, tamed the wilds, built towering cities of stone and glass on the shores of the warm seas, spanned the wilderness with winding roads, and fought wars of extermination - such was their hatred toward each other. These were the Days of Thunder.";} break; // \n\nFirst of these ancient creators was a saurian race that built an extensive if short-lived civilization.";} break; //  Its survivors eventually became the naga, lizardfolk, troglodytes, and similar creatures.\n\nSupreme among the creator races were the dragons, powerful enough to raid large cities of the other creator races with impunity. Dragons dominated the surface world, claiming vast areas of territory and battling each other for land, mates, and status. The great drakes only suffered setbacks when lesser races mastered magic, and they remain influential today despite the advances of such rabble.\n\nDeveloping in the later stages of the civilization of the saurians was a race of amphibious shapechangers that crept onto the land to build their proud cities. These creatures contributed to the downfall of the saurians, but they themselves eventually fell into barbarism under pressure from sahuagin, merfolk, and tritons. The survivors of this race are the locathah and tako in the sea, and doppelgangers on the land.\n\nLeast known of the creator races are the sylvan people that populated the forests and other wooded areas, living in harmony with nature and leaving few traces. It is believed that their civilization fragmented after a great plague created by a draconic or demonic power. Their descendants are the sprites, korred, and other small woodfolk that populate secret parts of the Forgotten Realms today.\n\nThe last of the creator races, and the one that spent the longest time in a primitive state, are the humans. Always adaptable and ingenious, when circumstances allowed for their rise to prominence, humans make advances with incredible speed and efficiency. Of the five creator races, only they truly have a civilization today. The dragons war with each other as individuals, and the other kinds have vanished from the world.\n";} break;
					case 18: {return "The letters in this book swim before your eyes, finally shaping themselves into text you are capable of understanding. The book speaks of many things and appears to prove, beyond the shadow of a doubt, that a creator race lived in these ruins. A certain passage catches your eye...\n\n'In 501 SD, a few thousand members of the enslaved race revolted. The uprising took several years to quell, the most successful uprising the slaves had experienced to date.";} break; //  Though far from posing a military threat.";} break; // , the slaves complicated the recapture process by hiding in caves along the Sentiege Range where they lived like savages. \n\n'Further complications came in the form of the draconic presence in the Sentienge, as they refused to bow to our will. The dragons were defeated in the Second Great War of Hiromire, however, and our hunters were finally able to recover the missing slaves.\n\n'As is customary, the elderly were eliminated, the young males crippled and sent to work in the iron mines, and the virile females were returned to the pens for the purposes of breeding.";} break;
					case 19: {return "This book explains that the focus of a lab found on this level is to summon a powerful weapon. The arcane ritual appears to mention two ingredients to be placed within the Alchemist's Apparatus - a gargoyle's skull and a slaad's tongue. It is not clear which spell is to be the catalyst that summons the item but the final line reads: 'Dispel the magical essence from the components that you may reap your reward.'";} break;
	
				}
				break;
			case 2:
				switch(iIndexNumber)
				{
					case 20: {return "An engraved plate inside the front cover of the book identifies it as the property of Xanos Messarmos, one of your fellow apprentices, which is unsurprising considering that this is his room.\n\nThe book seems to concern the histories and deeds of powerful sorcerers who had a lasting effect on the lands of Faer�n. Several passages have been underlined and have cryptic notes in the margin. Without exception these noted sections deal with sorcerers who used their magic";} break; //  to gain control of some city or kingdom.";} break;
					case 21: {return "The letters swim before your eyes, shaping themselves into text that you can understand. This book seems to be a basic guide for priestly initiates who took care of the ancient tomb in which it was found. One passage catches your eye...\n\n'In the early years of the reign of the Thunder Queen, Lagosra, a call went out for the greatest architects and builders of the age. Kerik, hatched of Menron, came to the king and agreed to build a tomb that would house the rulers";} break; //  of our people for all time.";} break; // \n\n'Kerik took ten years to complete the project, but when it was finished the citizens of the kingdom gaped in amazement at the wonder that had been wrought. Lagosra was pleased and bestowed upon Kerik the honor of being first sacrifice at the tomb's blessing.";} break;
					case 22: {return "This book is the final volume in one of the lesser known works of Islegood, the famous historian and chronicler of the North who died well over a century ago. The Complete History of Seafaring chronicles the evolution of ship building, navigation and mapping methods. It also contains a detailed examination of all the perils associated with sea travel in general. A short chapter on the pleasures of swimming has been included as a hand-written appendix to the end of the book,";} break; //  but given Islegood's well-documented fear of water, the addendum is likely a forgery by some anonymous prankster.";} break;
					case 23: {return "This book is written in an ancient language you cannot understand. In the margins, however, someone has scribbled notes in the common tongue detailing how the time crystals can be used to travel back to ancient days:\n\n'The Creators built this complex over a time sink, and constructed several sundials that tap into the heart of the temporal instability. Using a time crystal on one of these sundials activates the time sink, drawing the person back into the ancient past.";} break; //  Using the crystal on the sundial in the past will return the person to the future.\n\n'In my explorations of the ancient past, I have discovered several interesting anomalies associated with time travel. First, it is not possible to travel beyond the range of the time sink's influence. For this reason I have only been able to explore the complex itself, despite my desire to see the world as it was before the changing climate covered the land in ice and snow. \n\nAlso, I have discovered that it is not possible to bring certain items back from the past into the present. This is likely an inherent aspect of temporal displacement that minimizes paradoxes and disruptions of the time stream. This is fortunate, for I shudder to think of the consequences if the Creators had ever discovered a way to travel from the past into our own time. \n\n'Had another run-in with the Creator Race during my last visit to the past. Those walking lizards surprised me in a dead-end hall. It was all I could do to escape with my life. I am beginning to wonder if further exploration of these ruins is truly worth the risk.";} break;
					case 24: {return "This is the final volume in Islegood's highly acclaimed Complete History of Horses. While earlier books in the series discuss equine breeding, the proper training methods for horses and a variety of recreational riding methods, this work deals exclusively with mounted combat. The chapter on jousting is particularly interesting, as is Islegood's account of the Tuigan riders from the Hordelands of the East.";} break;
					case 25: {return "This is the journal of Marcus Penhold, a young mage. The details of his life are uneventful, although the last entry is now likely more prophetic than the writer might have wished.\n\nExcerpt:\nI have hidden with the rest in fear of the plague, but I have no such anxiety about some pitiful shambling zombies. My brother awaits at the shrine the Helmites maintain in the Beggar's Nest, but I will not be joining him. Finally there is something real to fight.";} break;
					case 26: {return "This book is full of tightly-scripted dates and notes, a journal kept by the wizard Meldanen. Most entries are short and to the point, regarding his various magical experiments and some of the creatures he has paid to have smuggled into the city for his examination.\n\nMost recently, however, his entries become much more interesting:\n\nExcerpt:\nThe gods have smiled on my destiny. I had heard a little about the creatures being brought to the city from Waterdeep";} break; // , but thought little of my chances of even laying eyes upon them. Lo and behold, however, I discovered a dryad from that very shipment wandering the streets of the district, lost and frightened after the battle in the Academy. It was glad enough to accompany me and I have caged it for the moment until I decide what to do with it.\n\nExcerpt (the following day):\nI have decided to experiment upon this dryad and find a cure for this plague on my own. Think of all the gold the panicked nobles of this city would offer for a cure! It is too bad that the dryad must be sacrificed, however... she is comely, if inhuman.\n\nExcerpt (Several Days Later):\nI cannot get the dryad out of my mind. Thoughts of her are with me always. Today I attempted to draw blood from her to fuel my experiment and found I could not hurt her even that much. Has she enchanted me? Or am I simply lonely for such beauty? I cannot think clearly. Still she recoils from my touch... I must win her love, I must! I will not release her from the cage until she feels as I do!";} break;
					case 27: {return "This journal holds the personal thoughts of an elven archeologist named Synth La'neral.";} break;
					case 28: {return "This book appears to be an ill-organized reference almanac. It defines the term 'mythal' as 'a large, semi-permanent, spherical zone of interwoven and highly customized magics in which the laws of arcanism are altered or adjusted to better suit the day-to-day needs of those choosing to live within said sphere.' The text goes on to explain that every mythal depends on the existence of powerful artifacts known as mythallar and it is through these mythallar that the mythal";} break; //  is controlled. In a later appendix listing the various flying cities that were then a part of the Netherese Empire, it is noted that Undrentide's mythallar were housed atop a central structure called the Temple of the Winds.";} break;
					case 29: {return "This letter is written in a tight script, addressed to 'Rimardo.' It reads as follows:\n\n'The last war golem of your creation went berserk and killed almost an entire battalion of orcs. Needless to say, King Obould was not impressed. Ensure that the next three war golems that you deliver for the army are more stable... or the consequences shall be unpleasant, to say the least.'\n\nIt is signed by 'Maugrim, Archmage Arcane.";} break;
	
				}
				break;
			case 3:
				switch(iIndexNumber)
				{
					case 30: {return "This letter is written in dark reddish ink and reads as follows:\n\n'Valinda,\n\nHave the construction of the war golems hurried. The fool Deltagar left us little else to work with, they shall have to provide the brunt of our force in the coming battles.\nAlso ensure that my sanctum is not disturbed. The elf woman, Aribeth, has arrived and is being prepared for the ritual.\n\nPlease Morag and your place in the new order shall be certain.\n\nArchwizard Arcane Maugrim";} break;
					case 31: {return "This letter was found hidden away on the body of the cultist, carefully sealed. It is written in a fluid script and reads:\n\n'Support the High Captain as you see fit. Ensure that he believes he will be the one whom the cult supports to lead the coming war effort. Neverwinter is ripe for the plucking now that our plague has left them reeling... the High Captains should be delirious with greed just at the thought of it. With luck, we will soon have a host worthy enough";} break; //  to make the entire North tremble in fear.\n\n'Do this well and your place in the coming order will be assured.\n\n'-- Maugrim";} break;
					case 32: {return "The dangers of Illusk pale in comparison to the Host Tower of the Arcane - the home of the Arcane Brotherhood. This magically created stone structure is built to resemble a giant tree or an open human hand. It rises into a central spire surrounded by four spires at the points of the compass. All are of equal height, and each bristles with many lesser spires, balconies, and branching turrets.\n\nThe Arcane Brotherhood is a mercantile company and spellcaster's guild.";} break; //  It maintains several safe houses in Luskan and in other cities of the North, and at least one fortress somewhere in the mountains north and east of Luskan. The Host Tower, however, is the seat of its strength.\n\nHard information on the upper echelons of the Arcane Brotherhood is very difficult to come by. It is clear, though, that some of the senior wizards have recently been destroyed or trapped in forms from which they can't escape, communicate, or work magic. Some have been moved behind the scenes, and some have left the Brotherhood to pursue their own aims - lichdom, mastery in other lands or planes of existence, and so on. Even still, it should be noted that current activities of the Zhentarim, the Cult of the Dragon, and the Red Wizards of Thay reveal that they haven't managed to place agents or even spies in any positions of importance within the Brotherhood.\n\nThe Brotherhood has been known to change with menacing rapidity, as its internal feuds tend to be deadly. Travelers are advised to avoid even coming to the attention of this evil, manipulative group.\n";} break;
					case 33: {return "This small book is filled sparsely with notes in Maugrim's now-familiar scrawl. Several entries are of particular interest:\n\n'The tower is ours! That over-ambitious fool, Arklem, trusted me far too much. I would gladly have ended his undead existence had his demon witch not sent him away so quickly. Well, he'll not have use of her advice any longer, I've seen to that.'\n\n'Morag is displeased with me, however. So far the wizards I have sent forth from the tower";} break; //  have found only one of the Words of Power. She needs them all! We shall have the one in Neverwinter soon... and once the last three are located, all shall be as Morag wished. I remain confident of success.'\n\n'The plague ravages Neverwinter, just as Morag foretold. With each death by Wailing she grows stronger. Already she is able to appear in corporeal form... and with the coming war, she shall become even stronger still!'\n\n'I have received word that the old fool Nasher has been successful in stopping the plague, having acquired some help from adventurers. No matter...the deed is already done. Neverwinter is weakened and what strength it has lost, Morag has gained. Morag says that Nasher's execution of the fool Fenthick will only serve us... soon his greatest champion shall be ours, instead!'\n\n'The High Captains decimate each other daily, just as I suspected. I care not whether any of the fools actually succeed... better is they all die, for none of them will lead the army as I promised them. Morag's nightly visits to Aribeth have had the desired effect: the former paladin has come and lain herself willingly at our feet. She shall lead the great host herself as Morag's champion! The Words will be ours and Morag shall triumph! Glorious shall be the day!";} break;
					case 34: {return "This well-thumbed book is signed by the author, someone named The Great Karsus. The technical jargon is too difficult to decipher fully but, judging by the illustrations, it was a popular textbook outlining the fundamentals of how to shear off the top of a mountain and make it hover at varying heights above sea level.";} break;
					case 35: {return "This large tome is filled almost completely with scribbled notes, arcane diagrams, journal entries and often just poorly-drawn doodles. Much of the writing is in draconic, but some parts are in Common. Amongst them such notes as:\n\n'Must look into creating non-freezing ink. Damn kobolds tried thawing the last bottle over a fire and it exploded. Upper cave still dotted with ink marks.'\n\n'Swam to the outside today and encountered a group of orcs on my favorite ledge.";} break; //  Why do orcs have to taste so bad? Note to self: raid for salt.'\n\n'Received an interesting letter today. Interesting proposition. Must remember to practice my Common more often.'\n\n'J'Nah sent me the most interesting vial of poison today. She did not say where it comes from, but it smells like serpent venom. Deekin licked the vial and was in a coma for three days.'\n\n'DAMNATIONS!! Why must every greedy plan of mine end in ruin?!'\n\n'Acquired interesting powder today at great expense. It is only of use against that damned sorceress, but she will certainly not see *this* coming. I am so cunning!'\n\n'Note to self: writing plans out may be bad idea. Stop until after the witch is dead.'\n\nMost of the legible writing seems to end there, though there is one spectacular drawing showing an elven woman being torn to bloody, gory pieces by a large lizard-like creature.";} break;
					case 36: {return "This notebook is written in your own hand and describes your life as a slave at the hands of the cruel lizardman masters.\n\nIt details your escape from the slave pens of the Creator Race and describes how you organized other escaped slaves and set up an underground network to free your fellows from the bondage of the Old Ones.\n\nOf particular interest is the last entry:\n\n'The revolution will fail. I know this - I can sense our doom is near.";} break; //  It's like I'm caught in a trap, a terrible looping pattern repeated in a never ending cycle and there is no way to break out.\n\n'I had the dream again last night. I dreamt I was not a slave, but another person in another time, where the Old Ones no longer ruled. Sometimes the dream seems more real than this terrible nightmare.\n\n'But I know this world is real - the evidence is here in this notebook, written in my own words.";} break;
					case 37: {return "This weathered scroll is severely time-worn and covered with almost-indecipherable runes. There is a hand-written translation across the bottom, showing this to be some manner of religious text written by a Netherese priest. Part of the translation is of particular note:\n\n'The lands of NETHER will one day return to the destiny to which they were born. Its people SHALL rise up from their ancient graves and RULE all those which have come after them.";} break;
					case 38: {return "By Pragmatix the Sage\n\nExcerpt:\n\n'Curses notwithstanding, the debate is ongoing as to whether a great many of these encounters are manifestations of the actual dead creature or merely phantoms of what they represented in life. Many philosophers maintain that such a fate does not bode well for a purposeful afterlife, especially if the first several hundred years of death are spent waiting for some apathetic adventurer to guess the names of your stepchildren,";} break; //  or figure out that a 'tooth in the ocean' is an iceberg. Such a function would be far better performed by a simple triggered cantrip: a projection that assumes the tedium of delivering postmortem messages, hopefully allowing the deceased to get on with the business of resting in peace.";} break;
					case 39: {return "This village of 700 is found on the High Road between Luskan and Neverwinter, and sides with the latter in the feud between the two cities. Fifty men-at-arms from the City of Skilled Hands, bolstered by 30 of the Lords' Alliance troops, aid the local militia in guarding the town from brigand raids and the harassment of Luskan. The Lords' Alliance troops are mainly from Elturel and Baldur's Gate, so that a Luskan attack would risk war with two economically powerful cities.";} break; // \n\nPort Llast is a city of skilled stonecutters and has a fine harbor. The stonecutters work at quarries on the coastal headlands just south of the village. Other than harborage and stonecutting, there is little else to recommend it to the traveler today, for it is a tense, suspicious place, always expecting treachery or attack from Luskan. Today Port Llast is ruled by the soldier Kendrack, who recently replaced Haeromos Dothwintyl as First Captain. Haeromos was killed during the battle to protect Port Llast from a Sahuagin invasion. \n\nIn the distant past, when Luskan was held by orcs and duergar, Port Llast was a thriving city. It was the last port in human hands as one sailed north (hence the name). In those days, it was home to 14,000 miners and explorers eager to find gold, gems, and all the rest of the fabled mineral wealth of the North. The city was eventually smashed by orc raids, and the shattered remnants of the old walls still ring it, though much stone has been used to repair local homes or has been taken away and sold. Port Llast's outer reaches are overgrown by scrub forest or are used as gardens or graveyards.\n";} break;
	
				}
				break;
			case 4:
				switch(iIndexNumber)
				{
					case 40: {return "This prayer book was given to you by Father Merring, West Harbor's priest. He has been teaching you about the ways of the church of Lathander for several years, trying to sway you over to the Morninglord.";} break;
					case 41: {return "This immense book explains the history of Ao and the attempts at its priesthood to contact him. It is a long, dry and strange record, and since Ao has never responded, it is surprising how positive the scribes have remained. In the hope of getting Ao's attention, it has been enchanted to be able to cast several spells.";} break;
					case 42: {return "This dog-eared and well-worn book contains several dozen prayers to Mystra, goddess of magic, who is often called simply 'The Lady' by her devotees.";} break;
					case 43: {return "Entry 247:\n We guards are beginning to question Captain Alaefin's sanity. He has been out of sorts ever since he went to visit with his cousin, Lady Tanglebrook. The prisoners grow restless.\n\nEntry 248:\n Someone has unlocked the prisoners and cursed Captain Alaefin is nowhere to be found! We have had prison breaks before but this is serious. I don't know if we'll be able to keep it under control...\n\nEntry 249:\n Heh. This your pretty book, guards?";} break; //  Whoever reads this, we prisoners killed half your stupid guards and locked the rest away where they belong. Long live the Head Gaoler and may the Wailing get the rest of ya...";} break;
					case 44: {return "The Head Gaoler left my cell door open today... unlocked all of them on the block... Madman. Sure, I'm a criminal but I was a thief, that's all -- If I'm going to go free, I'm not going to do it alongside a bunch of cold-hearted killers like the lot of them. I've closed my door again, heard the lock click shut... I can hear them in the common room -- The Head Gaoler's rallying them to some cause, they're all shouting and cheering, it makes me sick.";} break; //  They're mad, all of them... I can hear them coming for me.";} break;
					case 45: {return "The deities of Faer�n take an active interest in their world, channeling power through their clerics and other worshipers and sometimes intervening directly in the affairs of mortals. At the same time, they have their own plots, conflicts, intrigues, and alliances with other deities, powerful mortals, and outsiders such as elemental lords and demons. In their pettiness the deities of the Realms appear almost mortal, and some were once mortals who won the divine spark";} break; //  through great heroism.\n\nWorship is the lifeblood of the gods, and a deity can actually die if his believers lose faith. To keep their worship strong, the gods work through their clerics to recruit new worshipers and keep the flames of faith alive. In return, their clerics are rewarded with spells and other manifestations of the divine will.\n\nMany of the deities of Faer�n are specific to a certain race, such as Corellon Larethian (elves) and Moradin (dwarves) or a profession, such as Cyric (thieves) and Mystra (spellcasters). Others hold sway over aspects of nature, such as Umberlee (storms). Some deities are more central to certain locations, such as Helm's Hold, though it is fairly common to see more than one deity honored in larger towns, such as Neverwinter's devotion to Tyr and Helm, or Luskan's worship of Auril, Umberlee, and Tempus. \n";} break;
					case 46: {return "At first glance, this ragged tome appears to detail the ancient history of the Sword Coast. Closer inspection reveals the words 'Return of the Beast' scrawled across the original title in an almost childlike hand. Whole sections of the book are crossed out and replaced by an indecipherable code, and weird sketches fill the margins. At one point the unnamed second author breaks into near-coherence, though the entry is obscured by some sort of fluid or slime:";} break; // \n\n'... a slow change. After ages of waiting the BEAST that ruled the land returns to take back their world [from the] upstarts. The BEAST will make slaves of the five crowns, and put whole races to the lash: the elves, the dwarves, and the kingdoms of men will all fall as one...'\n";} break;
					case 47: {return "This tome details the process of capturing a dragon's essence within a dragon sphere:\n\nThe ritual is most effective when used upon a newly-hatched wyrm whose growth has been accelerated through the use of spells and rituals: a beast whose mind is still empty and pure. Only these have the vitality and energy of youth necessary to prolong the life of the mighty Klauth. \n\nThe creature to be absorbed must be lured or trapped within the center of the ritual room,";} break; //  and the dragon sphere must be placed upon the pedestal. The dragon's body will be instantly consumed even as its very life force is sucked into the sphere for Klauth to feed on at his leisure.\n\nBut a warning, lest you displease the Master and suffer his terrible wrath: should a dead dragon's body be absorbed, the sphere must be destroyed immediately. If it is mistakenly presented to Klauth, the essence of the dead wyrm will poison him and deal a crippling blow to his awesome.";} break;
					case 48: {return "The book is a small journal of sorts that does not appear to have been in use for long. The entries appear to have been made by Lady Aribeth. Of particular note is the last:\n\n'Maugrim has assigned me quarters with the other ambassadors, though I don't know for how long. He tells me only that he serves a greater power, and hints that I will come to revere this being far more than I ever did Tyr.\n\n'I do not know if that is true. I am not sure of anything anymore";} break; //  except that I have Fallen. Fallen out of love with my lord, my people and my God. I am alone in a world where there is no justice and no hope and I cannot... I cannot get these thoughts out of my mind.\n\n'They burn my every waking moment and whisper to me in my dreams. I shall go mad, I think, if I am not mad already. To do the wrong thing seems far better, however, than to do nothing at all. I am on this path now, and it goes only forward... perhaps at its end I shall find my own justice and the dreams will stop.\n\n'I can only hope.";} break;
					case 49: {return "This parchment contains powerful magic and a single command word of the type used to activate a magic portal. Mages and sorcerers often employ such scrolls as 'keys' to protect the entrances to their lairs or laboratories.\n\nWhen read while standing within the area of an appropriate portal, the scroll will instantly draw the reader through to the destination on the other side, wherever that may be.";} break;
	
				}
				break;
			case 5:
				switch(iIndexNumber)
				{
					case 50: {return "Circumstance; she is a goddess in her own right for all she casts upon us. Witness the trials of our three heroes, and know of what I speak. Have knowledge first of young Wu-Wei, sheltered monk of the elven race. Thrown to the winds that he might find a path, instead he found a briar, but with good friends to share the pricking of his fortune.\n\nJoined with him were Grin and Richard, young and true, and in that order. They came with dreams and hopes for fortune;";} break; //  their homes long lost behind them, their bridges burning literal. In time they would address what cast them out, but food and aching feet would first need their attention.\n\nWayward went they all, breaking trail where dungeons hide. Tales had told of treasure here and treasure there, and they forgot that tales tell tales most of all. Lost they got, and plenty of it.\n\nThen one morn they cracked the dawn, and adventure didn't hide. They needed no scouting skill, no premonition; it landed in their lap, or rather, their camp. A tower, stretching high above as though yawing with them as they woke, somehow seeming just as surprised that its doorstep was there, as they were to be on it.\n\nIt was most peculiar, and a cheer went up, for that was what they wanted! Of course it wasn't right; it was adventure, and adventure, most of all, takes you where you shouldn't be. Up they clambered clamoring, sure of what must be done. They would search it well from top to tine, ready to let each corner yield its treasure. Wayward buildings scream of wizards and careless alchemy; there had to be something within, some fortune to walk away with.\n\nWalk away, it did. Grin and Wu were first to sprint the stairs, while Richard lagged behind. The air was wrong for headlong joy, and the walls were unwisely damp, and he thought to himself that something just wasn't right with this instant tower. The topmost rooms would reveal why, ceding no treasure, no gems, and no captured maidens. Instead, there was a mouth, and not just any mouth, but the very worst kind of mouth, it being one that they were already in. Understanding dripped down their spines. The tower was not a tower; what it was, was hungry. Mimic. A bloody great mimic.\n\nOur heroes lived, of course, for I would not wish to profit in their story had they met a tragic end. Although, truth be told, if they had skin on their teeth before their escape, they have surely lost it now, but gained a bit of trepidation and wisdom in its place. Remember well what has been told, and learn from their misfortune. Look for something long enough and you will find it; look for something without understanding, and it will find you.\n";} break;
					case 51: {return "Amongst the more interesting passages are:\n\n'Fenberries are a potent ingredient. The essence of several fenberries can be used to make the barkskin potion. A simple bottle is enough to hold the berries essence - no special precautions are needed.'\n\n'Pure quartz crystal is another valuable reagent. Necessary in many rituals that imbue magical power into various items.' \n";} break;
					case 52: {return "A foul odor clings to the pages of this ragged book. In rather gruesome terms, it discusses the process by which a powerful arcanist can slowly transform himself into a lich. The frankness with which the topic is discussed leads you to believe that this was a relatively common practice in ancient Netheril.";} break;
					case 53: {return "The book is a small journal of sorts that does not seem to have been in use for long. The entries, however, appear to have been made by Lady Aribeth. Of particular note is the last:\n\n'Maugrim has assigned me quarters with the other ambassadors, though I don't know for how long. He tells me that he serves a greater power, and hints that I will come to revere this being far more than I ever did Tyr.\n\n'I do not know if that is true. I am not sure of anything";} break; //  anymore except that I have Fallen. Fallen out of love with my lord, my people and my God. I am alone in a world where there is no justice and no hope and I cannot... I cannot get these thoughts out of my mind.\n\n'They burn my every waking moment and whisper to me in my dreams. I shall go mad, I think, if I am not mad already. To do the wrong thing seems far better, however, than to do nothing at all. I am on this path now, and it goes only forward... perhaps at its end I shall find my own justice and the dreams will stop.\n\n'I can only hope.";} break;
					case 54: {return "You have studied many years under the guidance of West Harbor's wizard, Tarmas. He has taught you in the ways of arcane magic. This is one of the books he's given you to study. It has been specially enchanted to protect you.";} break;
					case 55: {return "The City of Sails is a dangerous place, a port city filled with pirates and bloodthirsty thugs. It straddles the mouth of the icy river Mirar and stands as the gateway to the mineral wealth of Mirabar.\n\nLuskan is ostensibly ruled by five high captains: Taerl, Baram, Kurth, Suljack, and Rethnor. However, it is suspected that the real power in Luskan is wielded by the Arcane brotherhood from their island tower.\n\nThe seafaring merchants of Luskan have always been fierce";} break; // , proud, and warlike. Over their long history they have feuded with the inland city of Mirabar, the coastal city of Neverwinter, and the island realm of Ruathym. Even today they sponsor pirates who prey on ships and ports up and down the Sword Coast. They also trade with Amn, Calimshan, and many other towns that prefer not to be associated with them, but will meet them on the neutral ground of offshore Mintarn.\n\nThe Mirar River divides the city into two major parts. The northern section is a walled enclave, consisting almost entirely of warehouses. The southern half of the city is much older. Outlying walled caravan compounds surround this heavily fortified section of the city.\n\nThere are three bridges that connect the two halves of the city. They are the Harbor Cross, Dalath's Span, and the Upstream Span. Five major island crowd the mouth of the Mirar, and the three closest to the south bank are developed. The major areas within Luskan are the Captains' Close, the Harbor District, the Mirabar District, the Reach, and the Spans.\n";} break;
					case 56: {return "The City of Skilled Hands is a beautiful, relaxed place. It is a walled city of over 20,000, mainly humans and half-elves.\n\nCraftsmen love the beauty of Neverwinter, and constantly try to outdo each other in striving for ever-increasing efficiency and beauty of design.\n\nMany Harpers dwell in Neverwinter, as do a few skilled dwarven craftspeople of note. Many good-aligned spellcasters also make Neverwinter their home, including the Many-Starred Cloak, a band of wizards";} break; //  who support Lord Nasher's rule with their spells and some say hold the real power in the city. The 'Cloak also produces blastglobes for the 400-strong city militia. \n\nNeverwintans tend to be quiet, mannered, literate, efficient, and hard-working folk. Deadlines and precision are important in all they do. They respect not only the property of others, but also whatever interests another person holds important for personal happiness. 'Following one's weird' is a Neverwintan saying for odd or reckless behavior. Everyone native to this city understands the need to do such. \n\nAll in all, Neverwinter is perhaps the most cosmopolitan city in Faer�n, escaping Waterdeep's slums and grasping competitiveness, and Silverymoon's harsher climate and heavier need for defense against orcs and other evils. Cities in Amn and Calimshan commonly claim to be more civilized, but merchants who trade there all say that Neverwinter truly is civilized, unlike some showier rivals who, as the sage Mellomir once put it, 'have achieved decadence without the need for passing through civilization first.'\n\nNeverwinter is divided into several sections, called districts. They are the City Core, the Blacklake, the Docks, the Peninsula, and the Beggar's Nest. The City Core is the focal point of commerce, and houses Castle Never, the seat of government, and the Hall of Justice, a temple of Tyr. The Blacklake district is home to the nobility, while the Beggar's Nest is populated by many of Neverwinter's less wealthy citizens. The Peninsula is constructed around a prison complex, and the Docks district is home to one of the most extensive harbors of the Sword Coast.";} break;
					case 57: {return "This book is bound in human flesh and the edges of its pages are charred and black. Cinder holes have burned their way through much of the text. ";} break;
					case 58: {return "Long ago, before there were roads anywhere north of Tethyr, the Dessarin was known as the Road to the North. The river reaches up past Waterdeep to the Evermoors, and into the eastern end of the Spine of the World.\n\nWhen humankind first explored the North, they chose the surprisingly fertile Dessarin delta for their first settlements. To this date, more humans live in the long, broad valley of the Dessarin than in any other part of the Savage Frontier.";} break; //  The farms and ranches of the delta feed the remote mining settlements of the North, and fall prey to the orc hordes that sweep down the Dessarin every decade or so.\n\nThis great river carves the rough hills of the central North into a broad, gentle valley. It is the principal route for trade and commerce in the region, linking Waterdeep near its mouth with Yartar and Silverymoon hundreds of miles upstream.\n\nMinstrels sometimes describe the Dessarin as a sword thrusting up into the heart of the North. In fact, the river itself was once known as the Sword. This is important knowledge to those puzzling out Netherese and other ancient writings, trying to locate important sites or priceless treasure.\n";} break;
					case 59: {return "The world was not always as it is now. There was a time before time, when the land was shaped by the will of the creator races. These were not gods, but the power and magic they wielded was greater than anything seen since. For ages they ruled unchallenged, but at the time of the great cooling a new threat emerged. The new races, the lesser beasts that would become you and I, had grown in confidence and power and began asserting themselves on the land.";} break; // \n\nOne of the creator races - their name is now lost to the wastes, and let it never be found or spoken again - turned its awesome power to conquest, and brought forth the great warrior machines. They were fearsome to behold, and there was no doubt to their intent; they were the Doombringers, and they would unleash devastating power upon the world. The young races should have been trampled underfoot, but fate intervened.\n\nThe masters of the Doombringers had seen their empire pushed to the edges of the Realms, past the peaks of what would become the Spine of the World. They huddled in the lonely mountains, waiting for their old glory to return. But this race had upset the greater balance with their war machines, taking away the very life force of the earth around them. They did not heed the groaning of the stone until their great halls and vaults fell around them and closed them under the earth.\n\nEntombed, the Creators could not mind their Doombringers, now standing idle before the forces that would destroy them; the lesser races, the earliest of us but not yet us. They were as ants beneath the giants, but they slowly brought them down. It was victory, but it was only the inattention of the masters that allowed it. They would not stay buried. The threat would surely come again and all lived in fear... until the forgetting.\n\nSong and tale have passed the legends of the earliest times, but much has been lost of how we gained our foothold among giants. All we really know is that now we are the masters, the creators of things grand and beautiful, and whatever came before is gone. There are ants beneath our feet that we think nothing of... but it is best to remember that we were once as they, and above us were beings greater than we shall ever be. Let us be mindful, and not look away, lest our own Doombringers fall.\n";} break;
	
				}
				break;
			case 6:
				switch(iIndexNumber)
				{
					case 60: {return "This haunted grove is the chief landmark in the Conyberry area. The ghost of Neverwinter Wood is actually a banshee, known as Agatha. This name is almost certainly a corruption of the elven surname Auglathla, which means 'Winterbreeze' in one of the older elven dialects. She lairs in a grove in Neverwinter Wood, northwest of Conyberry. Her haunt is at the end of a path whose entrance is marked by a strand of birch trees.\n\nAt one time Agatha's lair was guarded";} break; //  by a magic mirror spell. This was set up to hide her real location, and give her time to hurl spells at intruders. The heroes Drizzt Do'Urden and Wulfgar son of Beornegar shattered these defenses. The two adventurers then stole her treasure.\n\nThe banshee had amassed her treasure hoard by thieving in the night, slaying travelers, and pillaging old tombs and ruins. Since her wealth was stolen, she has taken to looting the Dessarin again, trying to rebuild her riches. She also seeks revenge for the theft, and so considers any adventurers fitting recipients of death.\n\nAgatha's lair has new defenses now. Her spells enable her to charm the people of Conyberry into digging pitfall traps along the path to her lair. These servants have also been seen guarding her haunt. Other than this, Agatha does not bother the folk of Conyberry. Rather, she views them as allies. Agatha often uses her spells to bring them beasts for food in the worst winter weather. She also slaughters orcs and brigands who venture too near to the village. Folk in Conyberry regard Agatha almost affectionately as their guardian and friend. They often talk about her, and speculate on what she's up to.\n";} break;
					case 61: {return "Popular legends tell of sylvan creatures luring men within trees, where exists entire kingdoms, known as the faerie realms. A less-popular legend tells of a similarly mischievous group of imps.\n\nAccording to the tale, these imps lure people into their realms by taunting them with something that they may desire, such as wealth or pleasure. Once the person follows, entranced by the whisperings of the imps, he finds himself within a twisted abyss, bereft of hope";} break; //  or the possibility of escape.\n";} break;
					case 62: {return "The city of Neverwinter was originally founded by Lord Halueth Never. This great lord was laid to rest - so local tavern tales swear - on a huge slab of stone encircled by a ring of naked swords laid with their points radiating outward. These magic blades animate to attack all intruders if the precise instructions graven in cryptic verses on the flagstones are not followed.\n\nToday Neverwinter is ruled by Lord Nasher Alagondar, an amiable and balding warrior";} break; //  who keeps his city firmly in the Lords' Alliance. Lord Nasher has laid many intrigues and magical preparations against attacks from Neverwinter's warlike rival town, Luskan. Nasher doesn't allow maps of the city to be made. This is to keep the spies of Luskan busy and add a minor measure of difficulty to any Luskanite invasion plans. \n\nThe royal badge of the city is a white swirl - a sideways 'M,' with points to the right. It connects three white snowflakes; each flake is different, but all are encircled by silver and blue halos.\n\nLord Nasher is always accompanied by his bodyguard, the Neverwinter Nine. These warriors are entrusted with the many magic items Nasher accumulated over a very successful decade of adventuring.\n";} break;
					case 63: {return "Long ago, an unknown adventurer discovered a set of magic writings that held vast secrets of magic. These writings came to be called the Nether Scrolls. Taken together, they granted insight into the mysteries of spellcasting, the creation of magic items and constructs, the relations and structure of the planes, and even the making of artifacts. Although all of the Nether Scrolls were lost or stolen over the following 2,000 years, by then the information they";} break; //  contained had changed Netherese society forever.\n\nThe lords of Netheril developed forms of magic never before seen in the world. The mythallar was a invention by the Netherese wizard Ioulaum that gave power to nearby items, negating the need for expenditure of a spellcaster's energy to create magic items. The mythallar also allowed the creation of flying cities, formed by slicing off and inverting the top of a mountain. Netheril's people took to the skies in these flying enclaves of magic, safe from human barbarians and hordes of evil humanoids. Every citizen wielded minor magic, and the Netherese traded with nearby elven and dwarven nations, expanding the reach of their empire greatly.\n";} break;
					case 64: {return "This hefty tome attempts a complete history of the Neverwinter Wood, but the crux of what is known is summed up in the following passage:\n\nWhile many a tale has suggested that there are dark forces that call the wood their home, there is yet no definite answer as to what truly hides within. Many a glade has a guardian force watching over it, but never one so malevolent as is supposedly in residence there. These woods have never been logged by men, for they";} break; //  are feared and shunned by locals, and even orc hordes alter their course around and never through, though usually only after suffering a goodly number of stubborn casualties.\n";} break;
					case 65: {return "The Northern Four is the name of a band of adventurers that have each gone on to become key citizens of the Sword Coast. Led by Nasher Alagondar, who became Lord of Neverwinter, the group also consisted of Dumal Erard, who went on to found and watch over Helm's Hold, Ophala Cheldarstorn, matron of the Moonstone Mask who was thought to be an important figure among the mages of the Many-Starred Cloak, and Kurth, who has become a High Captain of Luskan.";} break; // \n\nThe band adventured together successfully for many years, and spawned many tales in their adventures around the region. One popular tale depicts the successful rescue of the Black Raven Tribe from a foul white dragon. As a symbol of gratitude from the tribe, Nasher was gifted with the noted Neverwintan Morregence as a 'debt-child.'\n\nThe success of the troupe eventually came to an end with a leadership struggle between Nasher and Kurth. Ophala was torn between her love for Kurth and her loyalty to Nasher, but after Kurth left, Ophala settled in Neverwinter, unwilling to compromise her hatred for Luskan and its Arcane Brotherhood; many assume that she still bears resentment against Nasher for the way things turned out. Regardless, Nasher and Erard have remained close, and Ophala still serves her Lord loyally. The same cannot be said of Kurth, who has joined forces with an army that would love nothing more than to see Neverwinter destroyed.\n";} break;
					case 66: {return "Long ago, magic was more raw and potent than it is today. The great civilizations of the creator races were based on endless experimentation with these energies, and during their long rules they created many new forms of life.\n\nThe cruel and decadent creator races chose to release their monstrous mistakes rather than destroy them. Most died in the jungles, yet many lived and - as thought awakened in them - they hid from their creators.";} break; //  When the end came at last, it was they - not the old races - who seized control of Faer�n. \n\nAnd so it was that the first of the elves, the dragons, the goblin races, and an endless list of creatures of a new age took possession of their heritage. Their creators - the ancestors of the lizardfolk, bullywugs, and aarakocra - declined into savage barbarism, never to rise again.\n\nSages speculate about the 'overnight' destruction of the creator races. There are wildly diverging theories, but all agree that a rapid climate change occurred, creating a world unsuitable to them. Many believe the change resulted from a cataclysm the races unleashed upon themselves. Proponents of this theory point to the Star Mounts in the High Forest, whose origins are most likely magical and otherworldly. The elves believe that around this time the greater and lesser powers manifested themselves, aiding the new races and confounding the survivors of the creator races. There was civilization in the North during this time period, yet little more than tantalizingly vague myths survive.\n";} break;
					case 67: {return "I can smell your feet.\nTheir odor lingers even these many years\nafter you last tread here.\nNow there is only dust and shadows,\nas my belly\nscrapes\nthe ground...\n\nDagget Filth\nYear 832 after The Fall\n\nDamn, I'm bored...";} break;
					case 68: {return "To the east, on the sandy shores of the calm and shining Narrow Sea, human fishing villages grew into small towns and then joined together as the nation of Netheril. Sages believe the fishing towns were unified by a powerful human wizard who had discovered a book of great magic power that had survived from the Days of Thunder - a book that legend calls the Nether Scrolls. Under this nameless wizard and those who followed, Netheril rose in power and glory";} break; // , becoming both the first human land in the North and the most powerful. Some say this discovery marked the birth of human wizardry, since before this time mankind had only shamans and witch doctors. For over 3,000 years Netheril dominated the North, but even its legendary wizards were unable to stop their final doom.\n\nDoom for Netheril came in the form of a desert, devouring the Narrow Sea and spreading to fills its banks with dry dust and blowing sand. Legend states when the great wizards of Netheril realized their land was lost, they abandoned it and their countrymen, fleeing to all corners of the world and taking the secrets of wizardry with them. More likely, this was a slow migration that began 3,000 years ago and reached its conclusion 1,500 years later.\n\nWhatever the truth, wizards no longer dwelled in Netheril. To the north, the once-majestic dwarven stronghold of Delzoun fell upon hard days. Then the orcs struck. Orcs have always been foes in the North, surging out of their holes every few tens of generations when their normal haunts can no longer support their burgeoning numbers. This time they charged out of their caverns in the Spine of the World, poured out of abandoned mines in the Graypeaks, screamed out of lost dwarfholds in the Ice Mountains, raged forth from crypt complexes in the Nether Mountains, and stormed upward from the bowels of the High Moon Mountains. Never before or since has then been such an outpouring of orcs.\n\nDelzoun crumbled before this onslaught and was driven in on itself. Netheril, without its wizards, was wiped from the face of history. The Eaerlann elves alone withstood the onslaught, and with the aid of treants of Turlang and other unnamed allies, were able to stave off the final days of their land for yet a few centuries more.\n\nIn the east, Eaerlann built the fortress of Ascalhorn and turned it over to refugees from Netheril as Netherese followers built the town of Karse in the High Forest. The fleeing Netherese founded Llorkh and Loudwater. Others wandered the mountains, hills, and moors north and west of the High Forest, becoming ancestors of the Uthgardt and founders of Silverymoon, Everlund, and Sundabar.\n";} break;
					case 69: {return "One portal opened by Mulhorand's rebellious wizards led to a world populated by savage orcs. These orcs used the portal to invade Faer�n, overrunning many northern settlements and slaying thousands. The manifestations of the god-kings of both Mulhorand and Unther battled the orcs, and the orcs retaliated by summoning divine avatars of their own deities. During these conflicts, known as the Orcgate Wars, the orc god Gruumsh slew the Mulhorandi sun god Re";} break; // , the first known deicide in the Realms. Many of the Untheric deities were slain as well. The human deities eventually prevailed and the orcs were slain or driven northward.\n\nThe deities Set and Osiris battled to succeed Re, and Set murdered his rival. Horus absorbed the divine power of Re and became Horus-Re, defeated Set, and cast the evil god into the desert. Isis resurrected Osiris. All of the Mulhorandi pantheon but Set united in support of Horus-Re. The two old nations paused to rebuild their power and lick their wounds. During this time the empires of Raumathar and Narfell rose in the battlefield territories to the north. In Unther, their chief god Enlil abdicated in favor of his son Gilgeam and vanished, and Ishtar, the only other surviving Untheric deity, gave the power of her manifestation to Isis and vanished as well. Gilgeam began his 2,000-year decline into despotic tyranny as the ruler of Unther.\n";} break;
	
				}
				break;
			case 7:
				switch(iIndexNumber)
				{
					case 70: {return "The remnants of the ancient city of Illusk stand on the southern shore of the Mirar, in the lee of Closeguard Island. All that remains of this once-proud city are a few shattered towers and toppled statues choked with creepers and thick brush. These ruins are bounded to the north by Luskan's busy market and to the south by the city's noisy slums, and bisected by the Darkwalk, the street that leads to the Dark Arch. The Darkwalk is named for the haunted reputation that";} break; //  clings to the ruins of Illusk.\n\nFear of the magical traps and guardian monsters, as well as the sleepless undead, has kept most of the tombs and treasure undisturbed. Still, a few enterprising rogues have escaped the ruins with spellbooks, scrolls, magic armor, and rich caches of gems and coins. The dead far outnumber these lucky few though, and Luskanites have a saying: 'Only the most desperate try to rob the dead of Illusk.' \n\nLuskanites rarely brave the overgrown northern ruins, even in the full light of day. There are persistent rumors of slave traders kidnapping folk and taking them below (a fate often threatened for unruly children by Luskanite mothers). No known maps of the underground chambers and passages exist, and no Luskanite will admit to knowing their ways.\n";} break;
					case 71: {return "Between Waterdeep and the Spine of the World lies a wedge-shaped piece of land along the coast of the Sea of Swords, roughly seven hundred miles north to south and almost two hundred miles across at its widest. At the western tip of the Spine of the World is Icewind Dale, the northernmost settled land in this part of Faer�n. The Long Road stretching from Waterdeep to Mirabar defines the eastern extent of the Sword Coast North.\n\nThe Sword Coast was the first part of";} break; //  the North to be inhabited by civilized people. Most of its area is covered in gently rolling grasslands, and herders and farmers found an easy living here. Sometimes the land touches the Sea of Swords in a pebble beach, but it more often meets the water in a series of sea caves, broken rock spits, and low cliffs marked by pillars of rock severed by the tireless waves. This terrain lends itself to smuggling, but it also forces ships that navigate close to the shore to be small and of shallow draft, and therefore they are vulnerable to the driving onshore storms that often pound the area.\n\nWooded hills and forbidding mountains bound the region to the east, and beyond this barrier is the expanse of the Dessarin river system.\n\nAlong the Sword Coast, the great trade towns of Leilon, Luskan, Neverwinter, Port Llast, and Waterdeep keep the area from descending into chaos. The central portion of the northern Sword Coast is underlain by several cavern systems; the Endless Caverns of the High Forest, the Underground River system of the High Moor (accessed from Dragonspear Castle far to the south), and the caverns under Mount Waterdeep that dwarves expanded into Undermountain.\n";} break;
					case 72: {return "When Ao cast out the gods from heaven, their avatars walked the earth, interacted with mortals (some more ruthlessly than others), and scrambled to find a way to return to their homes. Known as the Time of Troubles, the Godswar, or the Avatar Crisis, this period in the history of Faer�n is the most chaotic in recent memory.\n\nSudden mortality wreaked havoc on the deities. Mystra was destroyed and her essence merged with the land, causing magic to function erratically";} break; //  and creating many areas of wild and dead magic. Gond the Wonderbringer fell to earth as a gnome on the shores of Lantan. Grateful for the sanctuary offered by the city, he taught its citizens the secrets of smoke-powder. Tymora appeared at her temple in Arabel and it is thought that her presence there spared the city from destruction. Ibrandul, god of caverns, was slain by Shar and his portfolio stolen. \n\nHelm retained his divine power and was commanded by Ao to guard the path back to the outer planes. Due to his success in this endeavor, blame for much of the Godswar's destruction is laid at his feet. Malar battled Nobanion and was hunted by Gwaeron Windstrom. Shaundakul battled and destroyed the avatar of a minor orc deity. Sharess took the form of the favorite concubine of the pasha of Calimport and was liberated from the growing influence of Shar by Sune. The Red Knight appeared in Tethyr, helping that nation defeat monsters raiding from the Wealdath. \n\nHoar slew Ramman, Untheric god of war, but lost his foe's portfolio to Anhur. Clangeddin Silverbeard battled Labelas Enoreth over a misunderstanding. Waukeen vanished and custody of her portfolio was claimed by her ally Lliira. The avatar of the godling Iyachtu Xvim, half-demon offspring of Bane, was imprisoned under Zhentil Keep. Gilgeam, the god-king of Unther, was slain by his rival Tiamat, ending his two-millennia rule of that nation.\n\nBhaal, the god of murder, was greatly weakened at the time of the Godswar and existed only as a murderous force that could possess living beings. When Bane challenged Torm, the Black Lord slew all of the assassins in Faer�n and absorbed their essence, further weakening Bhaal. \n\nForging an alliance with Myrkul, Bhaal kidnapped the mortal Midnight and discovered one of the tablets of fate. But at the Boaraskyr Bridge Bhaal was killed by the mortal Cyric with the sword Godsbane (the avatar of Mask). Cyric absorbed some of Bhaal's power, while the rest went into the Winding Water, poisoning it.\n\nLeira, goddess of deception and illusions, was slain by Cyric with Godsbane and her portfolio absorbed by him. Cyric later broke Godsbane, greatly weakening Mask.\n\nBane was destroyed by Torm during a battle in Tantras, and his portfolio was given to Cyric by Ao. Torm himself was destroyed in the conflict with Bane, but because at the time his realm was actually Toril and because he died in service to his ethos (obedience and duty), lord Ao restored him to life and reinstated him as a deity.\n\nMyrkul's avatar battled Midnight, and she destroyed him. Midnight became the new incarnation of Mystra, absorbing the essence of the previous goddess from the land. Cyric became the new god of strife, tyranny, murder, and death, holding the portfolios of the slain Bane, Bhaal, and Myrkul (years later he lost the portfolio of death to the mortal Kelemvor when he was temporarily driven mad by an artifact he created).\n\nThe close of the Avatar Crisis brought a change to the way deities relate to their followers. By Ao's decree, a deity's power is related to the number and fervor of his worshippers, and so deities could no longer afford to ignore their faithful. While the Godswar reshaped the land and altered the Faer�nian pantheon dramatically, the accountability of divinity is the most powerful legacy of the Time of Troubles.";} break;
					case 73: {return "Penned by Augustavus Cale, founder of the notorious Trade of Blades guild and freehouse, this book appears to be a rather lengthy self-published rant on why the city guards of Neverwinter should not be wasting time trying to moderate the activities of mercenaries. His 'argument' appears to be thinly veiled extortion, implying untold mayhem if the needs of these sellswords are not accommodated.\n\nExcerpt:\nMuch has been made of the threat to our lands and homes posed ";} break; // by men and women of the sword, those that walk the roads with no ties to lord or lady. Many have argued that allowing these creatures to maintain quarters in Neverwinter is to invite trouble. I would say that to turn them away would bring double or triple hardship down upon the surrounding settlements. If you deny the mercenary his living, what recourse will he or she have but to turn to banditry?\n\nWould it not make sense to allow the Trade of Blades to welcome them, thus imparting a sense of kinship with the city? Does it need to be said that having them here for our hire is far better than turning them away and into the arms of our enemies? It is in the best interests of Neverwinter that not only is the mercenary tolerated, but welcomed.";} break;
					case 74: {return "Lord Ao created the universe that now holds the world of Toril. After this creation, there was a period of timeless nothingness, a misty realm of shadows that existed before light and darkness were separated. Eventually this shadowy essence coalesced to form twin beautiful goddesses, polar opposites of each other, one dark and one light. The twin goddesses created the bodies of the heavens, creating Chauntea, the embodiment of the world Toril. Toril was lit by the cool";} break; //  radiance of the goddess Sel�ne, and darkened by the welcoming embrace of the goddess Shar, but no heat yet existed in this place.\n\nChauntea begged for warmth that she might nurture life and living creatures upon her form, and this caused the twin goddesses to become divided in intent. The two fought, and from their divine conflict the deities of war, disease, murder, death, and others were created.\n\nSel�ne reached beyond the universe to a plane of fire, using pure flame to ignite one of the heavenly bodies so that Chauntea would be warmed. Shar became enraged and began to snuff out all light and warmth in the universe. Desperate and greatly weakened, Sel�ne tore the divine essence of magic from her body and hurled it at her sister, tearing through Shar's form and pulling with it like energy from the dark twin. This energy formed Mystryl, the goddess of magic. Composed of light and dark magic but favoring her first mother, Mystryl balanced the battle enough to establish an uneasy truce between the two sisters.\n\nShar, who remained powerful, nursed a bitter loneliness in the darkness and plotted her revenge. Sel�ne waxed and waned with the light, but drew strength from her allied daughters and sons, and even interloper deities from other planes. Their battle continues to this day.\n";} break;
					case 75: {return "This grease stained, water damaged book was obviously the journal of one of the bandits you killed. The writing is simplistic and the poor spelling and grammar make it almost unreadable. \n\nApparently the bandit was learning to be a scribe when a large stack of books fell over, landing on his head. The bandit must have taken a severe blow to the head, and he was fired from his job.\n\nRecently, he joined a small group of bandits. The bandits robbed and killed some merchants,";} break; //  finding a key and some notes about an old tomb. They burned the notes and have been looking for the tomb, hoping it will have riches hidden within it.";} break;
					case 76: {return "This notebook identifies the bearer as an official representative of Tyr's justice in Rolgan's murder trial and explains the rules of court, including the right for defense council to question any of the participants involved before the trial begins.\n\nTo aid you in your task Neurik has included notes on the witnesses and jurors and where you might be able to locate them for questioning.\n\nWitnesses:\nRolgan - the accused. Currently under my protection in the Temple of Tyr.";} break; // \nZed - a Lords' Alliance soldier. Recently has been spending most of his time in the soldiers' barracks.\nLodar - a Lords' Alliance soldier. Usually found in the drinking house when not on duty.\nVanda - wife of the accused. Spends her time on the plateau by Beorunna's Well.\n\nJurors: The jurors have been selected to ensure a fair representation to all sides in the dispute.\n\nEdegar - my assistant, a good and honest man. He is usually to be found here helping out in the temple.\nAverik - a Lords' Alliance soldier. When not in the company of a female he can be found in the drinking house.\nJevon - a Lords' Alliance soldier. A reliable young man who spends most of his free time in the barracks.\nDalcia - a female ranger. She spends her time living with the Uthgardt on the plateau near Beorunna's Well.\nPalla - a wise woman of the Uthgardt. She makes her home on the plateau near Beorunna's Well.";} break;
					case 77: {return "This notebook identifies the bearer as an official representative of Tyr's justice in Rolgan's murder trial. It explains the rules of court, including the right for defense council to question any of the participants involved before the trial begins.\n\nTo aid you in your task Neurik has included notes on the witnesses and jurors and where you might be able to locate them for questioning.\n\nWitnesses:\nRolgan - the accused. Currently under my protection in the Temple of Tyr.";} break; // \nZed - a Lords' Alliance soldier. Recently has been spending most of his time in the soldiers' barracks.\nLodar - a Lords' Alliance soldier. Usually found in the drinking house when not on duty.\nVanda - wife of the accused. Spends her time on the plateau by Beorunna's Well.\n\nJurors: The jurors have been selected to ensure a fair representation to all sides in the dispute.\n\nEdegard - my assistant, a good and honest man. He is usually to be found here helping out in the temple.\nAverik - a Lords' Alliance soldier. When not in the company of a female he can be found in the drinking house.\nJevon - a Lords Alliance soldier. A reliable young man who spends most of his free time in the barracks.\nDalcia - a female ranger. She spends her time living with the Uthgardt on the plateau near Beorunna's Well.\nPalla - a wise woman of the Uthgardt. She makes her home on the plateau near Beorunna's Well.";} break;
					case 78: {return "This book appears to be written in human blood, its ornate text apparently a mixture of the Common Tongue and Old Draconic. Trying to make sense of it gives you a headache.";} break;
					case 79: {return "This book is full of stories about the deeds of ancient heroes. A particular passage has been marked: The Mirialis Clan, led by the great warrior Maegal, braved near certain death to rid their lands of the Black Lich and his minions.";} break;
	
				}
				break;
			case 8:
				switch(iIndexNumber)
				{
					case 80: {return "This musty old tome appears to be the type of book that was written and never read. It is a long, boring text written by a druid, Jordius Caini Getafix III, several hundred years ago. It uses large, complicated and often seemingly meaningless words to discuss his observations on the Spirit of the Neverwinter Wood. One page in the text has been earmarked and there is a small comment beside an underlined passage in the margin.\n\n'This could mean that if one stood in the pool,";} break; //  below the waterfall, and somehow died, one could reappear, alive (presumably) in the realm of the Spirit.";} break;
					case 81: {return "Uthgar is the legendary founder and namesake of the Uthgardt barbarians of the Savage Frontier. Some of their legends claim that he is the son of Beorunna, and others that he is descended from Tempus. All the legends agree that Uthgar was a proud, strong warrior who lived three times a normal human life. He ascended to watch over the Uthgardt for all eternity after taking fatal wounds in a one-on-one battle with a frost giant named Gurt. Uthgar mastered all the primeval beast";} break; //  spirits in individual combat, passing down the divine gifts he gained from that mastery to his people, the Uthgardt, at his death. The Uthgardt tribes all follow a beast totem, representing one of the beasts that Uthgar bested.\n\nHistorical evidence suggests that Uthgar was probably a Ruathym Northman named Uther Gardolfsson. Uther led a long raiding career - including looting fabled Illuskan - before founding his barbarian dynasty. No one denies that Uthgar or Uther did indeed ascend to divinity on his deathbed, sponsored by the god of war, who admired his fighting spirit.\n";} break;
					case 82: {return "The Uthgardt are a race of black-haired and blue-eyed humans who are descendants of the Northmen, Netherese, and a few savage tribes. \n\nThe Uthgardt are presently divided into scattered tribes, each named after the beast totems which Uthgar conquered - Black Lion, Thunderbeast, Red Tiger, Blue Bear, Great Worm, Sky Pony, Tree Ghost, Black Raven, Griffon, and Gray Wolf. Although civilization has come north in waves throughout history, much of Uthgardt land is wild and untamed.";} break; //  Their lands extend north into the mountains of the Spine of the World, south to Stone Bridge, east to Cold Wood, and west to Neverwinter Wood.\n\nAlthough some tribes have embraced agriculture and fixed habitations, the Uthgardt have few stable villages. Most tribes wander the wilderness in small clans or family groups and live within a few weeks' travel of their ancestor's mounds. Tradition is the centerpiece of Uthgardt life, and this blind devotion to their heritage keeps them savage and primitive. Strength is everything to the Uthgardt, and civilization is a weakness that cannot be tolerated. Among the Uthgardt, men are warriors and hunters - women tend to gathering and family needs. They have no written language and no art beyond geometric carvings and clothing decoration. Their religion and philosophy focus on war, plunder, and survival. Their superstitious nature extends to a deep distrust of magic - particularly arcane magic.\n\nThe Uthgardt have little to do with city folk, other than as prey, though some tribes have made 'civilized' alliances. Both lone travelers and large caravans are considered ripe fruit for plunder. Though they attack civilized folk and frequently fight amongst themselves, they're quick to unite - even with non-Uthgardt - against their ancestral enemy: the orcs.\n";} break;
					case 83: {return "In the ancient days, before the rise of the created races, great wars were fought by the creator races: the reptile creatures, the amphibians, and the avian peoples. Though most of these wars were fought against other races, many were fought between themselves as well, as they sought to gain dominance over one realm or another.\n\nOnly a few tales from this time survive. One recounts a group of reptile creatures that betrayed their own kind for the sake of control over a powerful temple.";} break; //  The traitors used the trust of the simple townsfolk to infiltrate the temple area, and then used raw force to breech the temple's defenses, murdering the loyal guardians before seizing control of the site. Once in control of the temple, the city's rulers were caught and slain and the attackers seized the reigns of the whole city. Their efforts were for naught; within the year, the city was burned to the ground by an army of the avian peoples.\n";} break;
					case 84: {return "Waterdeep, often called the City of Splendors, lies on the southwestern edge of the North. It boasts a population of almost a million and a half, though the actual number varies seasonally. In times of busy trade, the city hosts five times this number. Almost every surface-dwelling race has representatives here, and many have taken up permanent residence. The halfling population grows annually, promising to become the largest nonhuman race in residence. To match the racial variety";} break; // , most religions have shrines or temples.\n\nWaterdeep was first used as a trading site more than two millennia ago. As recently as one thousand years ago, permanent farms had sprung up in the area. The first mention of a Waterdeep (not as a city, but as a collection of warlords) occurred just 400 years ago.\n\nThe city was truly established as a going concern by 1032 DR, the year Ahghairon became the first Lord of Waterdeep, and the date from which Northreckoning is counted. The city grew spectacularly, such that by 1248 DR both the City of the Dead and the guilds had been developed. The guildmasters seized control soon afterwards, ushering in a period of unrest and bitter conflict known as the Guildwars. These wars ended only when the two surviving guildmasters brought in their own period of misrule. Not until 1273 DR was the present system of government instituted, with the establishment of the Magisters and the secret Lords of Waterdeep firmly reestablished in power.\n\nSince that time, the city has continued to grow and prosper. Members of every race come from all over the Realms to earn hard coin in the City of Splendors. Over the years these successful merchants have set up guilds and become nobility themselves. The secretive Lords of Waterdeep police the city with a light hand, exercising polite authority by means of the city guard, city watch, and over 20 black-robed magistrates. As a result, Waterdeep has grown tolerant of different races, religions, and lifestyles. This in turn has encouraged commerce, and Waterdeep today is a huge, eclectic city, one of the most vibrant and prosperous in the whole of Faer�n. \n";} break;
					case 85: {return "'Wind by the Fireside' is a poem that has changed much over the ages - that much is clear to those who have studied it - but it is not know how much it has been altered, or why the alterations have taken place. Many scholars assume that these changes are representative of the natural evolution of language, as well as modern innovations of style. Little is known about the actual history of the poem, though some believe it to have some bearing upon the creator races of Faerun.";} break; //  Others have speculated that it may have been written as an ode by a follower of some ancient religion. The popular version sung in Neverwinter is noted as the following, though other regions have variations in theme.\n\nSo as you shiver in the cold and the dark,\nLook into the fire and see in its spark - \nMy eye\nWatching over you.\n\nAs you walk in the wind's whistling claws.\nListen past the howling of the wolf's jaws.\nMy song\nComes to you.\n\nAnd when you're lost in trackless snow,\nLook up high where the eagles go.\nMy star\nShines for you.\n\nIn deep, dark mine or on crumbling peak,\nHear the words of love I speak.\nMy thoughts\nAre with you.\n\nYou are not forsaken\nYou are not forgotten.\nThe North cannot swallow you.\nThe snows cannot bury you.\nI will come for you.\nFaer�n will grow warmer,\nAnd the gods will smile\nBut oh, my love, guard yourself well - \nAll this may not happen for a long, long while.\n";} break;
					case 86: {return "This large tome has a rather interesting title: 'Shadows of Undrentide', written by one 'D. Scalesinger'. Inside its pages is the full account of an adventure from earlier in your career... your first adventure, in fact. The facts seem a bit exaggerated, according to your memory, but that apparently didn't stop the book from becoming a great hit amongst the nobility in several major cities throughout Faer�n. For a time, you had the unique experience of becoming a household name...";} break; //  people who you didn't know would shout out to you happily as you passed or treated you like a trusted friend. The fame eventually died down somewhat, which was a relief at the time, but you have held onto a copy of the book as a souvenir.\n\nAs for the author, a kobold bard by the name of Deekin, you haven't met him since those early days. Part of you has to wonder if you aren't owed some royalties...";} break;
				}
				break;
			}
			// default basically with this
			return "This musty old tome appears to be the type of book that was written and never read. It is a long, boring text written by a druid, Jordius Caini Getafix III, several hundred years ago. It uses large, complicated and often seemingly meaningless words to discuss his observations on the Spirit of the Neverwinter Wood. One page in the text has been earmarked and there is a small comment beside an underlined passage in the margin.\n\n'This could mean that if one stood in the pool, below the waterfall.";

		}
	}



/*
void DMFI_BuildChoosenList(object oPC)
{	
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BuildChoosenList Start", oPC ); }
	// Make racial bonus languages available
	if (GetRacialType(oPC)==RACIAL_TYPE_DWARF)
	{
		CSLLanguageGive(oPC, "jotun");
		CSLLanguageGive(oPC, "gnome");
		CSLLanguageGive(oPC, "goblin");
		CSLLanguageGive(oPC, "Orcish");
		CSLLanguageGive(oPC, "terran");
		CSLLanguageGive(oPC, "undercommon");
	}
	else if (GetRacialType(oPC)==RACIAL_TYPE_ELF)
	{
		CSLLanguageGive(oPC, "draconic");
		CSLLanguageGive(oPC, "gnoll");
		CSLLanguageGive(oPC, "gnome");
		CSLLanguageGive(oPC, "goblin");
		CSLLanguageGive(oPC, "Orcish");
		CSLLanguageGive(oPC, "sylvan");
	}
	else if ((GetRacialType(oPC)==RACIAL_TYPE_HUMAN) || (GetRacialType(oPC)==RACIAL_TYPE_HALFELF))
	{
		CSLLanguageGive(oPC, "abyssal");
		CSLLanguageGive(oPC, "aquan");
		CSLLanguageGive(oPC, "auran");
		CSLLanguageGive(oPC, "celestial");
		CSLLanguageGive(oPC, "draconic");
		CSLLanguageGive(oPC, "dwarven");
		CSLLanguageGive(oPC, "elven");
		CSLLanguageGive(oPC, "jotun");
		CSLLanguageGive(oPC, "gnome");
		CSLLanguageGive(oPC, "goblin");
		CSLLanguageGive(oPC, "gnoll");
		CSLLanguageGive(oPC, "halfling");
		CSLLanguageGive(oPC, "ignan");
		CSLLanguageGive(oPC, "infernal");
		CSLLanguageGive(oPC, "Orcish");
		CSLLanguageGive(oPC, "sylvan");
		CSLLanguageGive(oPC, "terran");
		CSLLanguageGive(oPC, "undercommon");
	}
	else if (GetRacialType(oPC)==RACIAL_TYPE_HALFORC)
	{
		CSLLanguageGive(oPC, "draconic");
		CSLLanguageGive(oPC, "jotun");
		CSLLanguageGive(oPC, "gnoll");
		CSLLanguageGive(oPC, "goblin");
		CSLLanguageGive(oPC, "abyssal");
	}	
	else if (GetRacialType(oPC)==RACIAL_TYPE_HALFLING)
	{
		CSLLanguageGive(oPC, "dwarven");
		CSLLanguageGive(oPC, "elven");
		CSLLanguageGive(oPC, "gnome");
		CSLLanguageGive(oPC, "goblin");
		CSLLanguageGive(oPC, "Orcish");
	}
	else if (GetRacialType(oPC)==RACIAL_TYPE_HALFORC)
	{
		CSLLanguageGive(oPC, "draconic");
		CSLLanguageGive(oPC, "jotun");
		CSLLanguageGive(oPC, "gnoll");
		CSLLanguageGive(oPC, "goblin");
		CSLLanguageGive(oPC, "abyssal");
	}
	else if (GetRacialType(oPC)==RACIAL_TYPE_GNOME)
	{
		CSLLanguageGive(oPC, "draconic");
		CSLLanguageGive(oPC, "dwarven");
		CSLLanguageGive(oPC, "elven");
		CSLLanguageGive(oPC, "jotun");
		CSLLanguageGive(oPC, "goblin");
		CSLLanguageGive(oPC, "Orcish");
	}
	else if (GetSubRace(oPC)==RACIAL_SUBTYPE_AASIMAR)
	{
		CSLLanguageGive(oPC, "aquan");
		CSLLanguageGive(oPC, "auran");
		CSLLanguageGive(oPC, "celestial");
		CSLLanguageGive(oPC, "elven");
		CSLLanguageGive(oPC, "ignan");
		CSLLanguageGive(oPC, "sylvan");
		CSLLanguageGive(oPC, "terran");
	}	
	else if (GetSubRace(oPC)==RACIAL_SUBTYPE_TIEFLING)
	{
		CSLLanguageGive(oPC, "abyssal");
		CSLLanguageGive(oPC, "aquan");
		CSLLanguageGive(oPC, "auran");
		CSLLanguageGive(oPC, "ignan");
		CSLLanguageGive(oPC, "infernal");
		CSLLanguageGive(oPC, "sylvan");
		CSLLanguageGive(oPC, "terran");
	}	
	
	// Make CLASS bonus languages available
	if (GetLevelByClass(CLASS_TYPE_DRUID, oPC)!=0)
	{
		CSLLanguageGive(oPC, "sylvan");
	}
		
	if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC)!=0)
	{
		CSLLanguageGive(oPC, "draconic");
	}
		
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BuildChoosenList End", oPC ); }
}
*/



/*
void DMFI_GrantLanguage(object oPC, string sLang)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_GrantLanguage Start", oPC ); }
	//Purpose: Sets sLang as a valid Language for oPC.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 1/1/7
	object oTool = CSLDMFI_GetTool(oPC);
	if (!CSLLanguageLearned(oPC, sLang))
	{	
		int n = GetLocalInt(oTool, "Language"+"MAX");
		CSLMessage_SendText(oPC, "DMFI Langugage Granted: " + CSLStringToProper(sLang), FALSE, COLOR_GREY);
		sLang = GetStringLowerCase(sLang);
		SetLocalString(oTool, "Language" + IntToString(n), sLang);
		n++;
		SetLocalInt(oTool, "Language"+"MAX", n);
	}
	else
	{
		CSLMessage_SendText(oPC, "DMFI Language Already Known: " + CSLStringToProper(sLang), FALSE, COLOR_GREY);
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_GrantLanguage End", oPC ); }
}
*/

/*
void DMFI_ListLanguages(object oDM, object oTarget)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_ListLanguages Start", oDM ); }
	//Purpose:  Reports oTarget's known languages to oPC
//Original Scripter: Demetrious
//Last Modified By: Demetrious 10/16/6
	object oTool = CSLDMFI_GetTool(oTarget);
	string sMess;
	string sLang;
	int n;
	int nMax;
	
	sMess = "DMFI Languages known by target: " + GetName(oTarget) + "\n";
	
	if (CSLGetIsDM(oTarget))
	{
		CSLMessage_SendText(oDM, sMess + "ALL LANGUAGES GRANTED TO DMs.", FALSE, COLOR_GREY);
		return;
	}	

	nMax = GetLocalInt(oTool, "Language" + "MAX");
	for (n=0; n<nMax; n++)
	{
		sLang = CSLStringToProper(GetLocalString(oTool, "Language" + IntToString(n)));
		sMess = sMess + "DMFI Langugage Granted: " + sLang + "\n";
	}
	if (nMax==0) sMess = "Log Off!";

	CSLMessage_SendText(oDM, sMess, FALSE, COLOR_GREY);
}
*/

/*
string DMFI_NewLanguage(string sLang)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_NewLanguage Start", GetFirstPC() ); }
	//Purpose: Returns a default language that has been linked to a new name via
//a plugin.
//Original Scripter: Demetrious
//Last Modified By: Demetrious 6/28/6
	string sDefault = GetLocalString(GetModule(), sLang);
	if (sDefault!="")
	{
		return sDefault;
	}
	
	return sLang;
}
*/

/*
int DMFI_RemoveLanguage(object oPC, string sLang)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_RemoveLanguage Start", oPC ); }
	//Purpose: Removes sLang as a valid Language for oPC.  The player is informed
	//of the action.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 1/26/7
	object oTool = CSLDMFI_GetTool(oPC);
	string sTemp;
	int nReturn = FALSE;
	int n=0;
	int nMax = GetLocalInt(oTool, "Language"+"MAX");
	sLang = GetStringLowerCase(sLang);

	while (n<nMax)
	{
		if (GetLocalString(oTool, "Language" + IntToString(n))==sLang)
		{ // Match - remove language
			CloseGUIScreen(oPC, SCREEN_DMFI_TEXT);
		
			nReturn=TRUE;
			SetLocalInt(oTool, "Language" + "MAX", nMax-1);
			CSLMessage_SendText(oPC, "DMFI Language Removed: " + sLang, TRUE, COLOR_GREY);
			
			while (n<nMax)
			{
				sTemp = GetLocalString(oTool, "Language" + IntToString(n+1));
				SetLocalString(oTool, "Language" + IntToString(n), sTemp);
				n++;
			}
		}
		n++;
	}

	return nReturn;
}
*/



/*
void DMFI_GiveDefaultLanguages(object oPC)
{	
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_GiveDefaultLanguages Start", oPC ); }
	// PURPOSE:  Grants languages as close as possible to
	// PHB rules  1/19/7
	
	string sLang;
	// Grant basic Race related language
	switch(GetRacialType(oPC))
	{
		case RACIAL_TYPE_DWARF:				{ sLang="dwarven"; break;}
		case RACIAL_TYPE_ELF:				{ sLang="elven"; break;}
		case RACIAL_TYPE_HALFELF:			{ sLang="elven"; break;}
		case RACIAL_TYPE_GNOME:				{ sLang="gnome"; break;}
		case RACIAL_TYPE_HALFLING:			{ sLang="halfling"; break;}
		case RACIAL_TYPE_HUMANOID_ORC:		{ sLang="Orcish"; break;}
		case RACIAL_TYPE_HALFORC:			{ sLang="Orcish"; break;}
		
		
				
		default: sLang=""; break;;
	}
	
	if (sLang!="")
		DMFI_GrantLanguage(oPC, sLang);
	
	
	
	if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC)!=0)
		DMFI_GrantLanguage(oPC, "draconic");
	
	if (GetLevelByClass(CLASS_TYPE_DRUID, oPC)!=0)
		DMFI_GrantLanguage(oPC, "druidic");
	
	
	if (GetLevelByClass(CLASS_TYPE_ROGUE, oPC)!=0)
		DMFI_GrantLanguage(oPC, "cant");
		
		
		// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_GiveDefaultLanguages End", oPC ); }
}	
*/

/*
void DMFI_TransferTempLangData(object oStart, object oFinish)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_TransferTempLangData Start", GetFirstPC() ); }
		// Purpose: Transfers a listing of languages between two objects
	//Original Scripter: Demetrious
		//Last Modified By: Demetrious 1/2/7
	int n, nKnown;
	string sLang;
	
	nKnown = GetLocalInt(oStart, "Language"+"MAX");
	for (n=0; n<nKnown; n++)
	{
		sLang = GetLocalString(oStart, "Language" + IntToString(n));	
		SetLocalString(oFinish, "Language" + IntToString(n), sLang);
	}
	SetLocalInt(oFinish, "Language"+"MAX", nKnown);
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_TransferTempLangData End", GetFirstPC() ); }
}
*/

/*
void DMFI_BuildLanguageDMList(object oTool)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BuildLanguageDMList Start", GetFirstPC() ); }
	// Complete listing of languages AND grouping data

	SetLocalInt(oTool, "common", 0);
	SetLocalInt(oTool, "abyssal", 1);	
	SetLocalInt(oTool, "algarondan", 1);	
	SetLocalInt(oTool, "alzhedo", 1);	
	SetLocalInt(oTool, "animal", 1);
	SetLocalInt(oTool, "aquan", 1);
	SetLocalInt(oTool, "assassincant", 1);	
	SetLocalInt(oTool, "auran", 1);	
	SetLocalInt(oTool, "cant", 2);	
	SetLocalInt(oTool, "celestial", 2);	
	SetLocalInt(oTool, "chessentan", 2);
	SetLocalInt(oTool, "chondathan", 2);	
	SetLocalInt(oTool, "chultan", 2);	
	SetLocalInt(oTool, "damaran", 3);	
	SetLocalInt(oTool, "dambrathan", 3);	
	SetLocalInt(oTool, "draconic", 3);
	SetLocalInt(oTool, "drow", 3);	
	SetLocalInt(oTool, "drowsign", 3);	
	SetLocalInt(oTool, "druidic", 3);	
	SetLocalInt(oTool, "durpari", 3);	
	SetLocalInt(oTool, "dwarven", 3);
	SetLocalInt(oTool, "elven", 4);	
	SetLocalInt(oTool, "jotun", 4);	
	SetLocalInt(oTool, "gnoll", 4);	
	SetLocalInt(oTool, "gnome", 4);	
	SetLocalInt(oTool, "goblin", 4);
	SetLocalInt(oTool, "halardrim", 5);	
	SetLocalInt(oTool, "halfling", 5);	
	SetLocalInt(oTool, "halruaan", 5);	
	SetLocalInt(oTool, "ignan", 5);
	SetLocalInt(oTool, "illuskan", 5);
	SetLocalInt(oTool, "imaskar", 5);	
	SetLocalInt(oTool, "infernal", 5);	
	SetLocalInt(oTool, "lantanese", 6);	
	SetLocalInt(oTool, "leetspeak", 6);	
	SetLocalInt(oTool, "midani", 6);
	SetLocalInt(oTool, "mulhorandi", 6);	
	SetLocalInt(oTool, "nexalan", 9);	
	SetLocalInt(oTool, "oillusk", 9);	
	SetLocalInt(oTool, "Orcish", 9);	
	SetLocalInt(oTool, "rasheemi", 7);
	SetLocalInt(oTool, "raumvira", 7);	
	SetLocalInt(oTool, "serusan", 7);	
	SetLocalInt(oTool, "shaartan", 7);	
	SetLocalInt(oTool, "shou", 7);	
	SetLocalInt(oTool, "sylvan", 7);
	SetLocalInt(oTool, "talfiric", 8);	
	SetLocalInt(oTool, "tashalan", 8);	
	SetLocalInt(oTool, "terran", 8);	
	SetLocalInt(oTool, "entish", 8);	
	SetLocalInt(oTool, "tuigan", 8);	
	SetLocalInt(oTool, "turmic", 8);
	SetLocalInt(oTool, "uluik", 9);	
	SetLocalInt(oTool, "undercommon", 9);	
	SetLocalInt(oTool, "untheric", 9);	
	SetLocalInt(oTool, "vaasan", 9);	
	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("common") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("abyssal") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("algarondan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("alzhedo") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("animal") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("aquan") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("assassincant") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("auran") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("cant") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("celestial") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("chessentan") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("chondathan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("chultan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("damaran") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("dambrathan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("draconic") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("drow") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("drowsign") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("druidic") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("durpari") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("dwarven") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("elven") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("jotun") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("gnoll") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("gnome") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("goblin") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("halardrim") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("halfling") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("halruaan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("ignan") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("illuskan") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("imaskar") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("infernal") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("lantanese") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("leetspeak") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("midani") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("mulhorandi") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("nexalan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("oillusk") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("Orcish") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("rasheemi") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("raumvira") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("serusan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("shaartan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("shou") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("sylvan") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("talfiric") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("tashalan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("terran") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("entish") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("tuigan") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("turmic") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("uluik") );
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("undercommon") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("untheric") );	
	CSLDataArray_PushString( oTool, "LIST_DMLANGUAGE", CSLStringToProper("vaasan") );	
}
*/

/*
void DMFI_BuildLanguageList(object oTool, object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_BuildLanguageList Start", oPC ); }
	//Purpose: Build a complete list of oPCs known languages
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 7/10/6
	int n;
	string sLang;
	int nMax = GetLocalInt(oTool, "Language" + "MAX");
	for (n=0; n<nMax; n=n+1)
	{
		sLang = CSLStringToProper(GetLocalString(oTool, "Language" + IntToString(n)));
		CSLDataArray_PushString( oTool, "LIST_LANGUAGE", sLang );
	}
	if (nMax<1)
	{
		CSLDataArray_PushString(oTool, "LIST_LANGUAGE", "Log Off!" );
	}
}
*/




/*
void DMFI_LanguageOff(object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_LanguageOff Start", oPC ); }
	DeleteLocalString(oPC, DMFI_LANGUAGE_TOGGLE);
	CloseGUIScreen(oPC, SCREEN_DMFI_TEXT);
}
*/


//void main(){}

const int CSLBOOK_SPREADTYPE_FULL = 1;
const int CSLBOOK_SPREADTYPE_FACING = 2;

const int CSLBOOK_BOOKTYPE_PARCHMENT = 0;
const int CSLBOOK_BOOKTYPE_SCROLL = 1;
const int CSLBOOK_BOOKTYPE_TABLET = 2;
const int CSLBOOK_BOOKTYPE_CODEX = 3;


const int CSLBOOK_PAGETYPE_LEFT = 0;
const int CSLBOOK_PAGETYPE_LEFTHIDDEN = 1;
const int CSLBOOK_PAGETYPE_RIGHT = 2;
const int CSLBOOK_PAGETYPE_RIGHTHIDDEN = 3;



/*

csl_book_BG_Codex.tga
csl_book_BG_Parchment.tga
csl_book_BG_Scroll.tga
csl_book_BG_Tablet.tga

csl_book_BG.tga

csl_dexmap.tga
csl_horztemplate.tga

csl_iconicsorceress.tga
csl_verttemplate.tga

BOOKID
BOOKTYPE  Scroll - Parchment - Tablet - Codex
BOOKTOTALSPREADS #
BOOKTOTALSPELLLEVELS - just caching so i don't have to iterate books on detect magic.
PROTECTIONSCRIPT - onopen,onpageturn,onread
COVER
PICTURE
ICON
TITLE
OWNER
OWNERS LORE ROLL - so they can't just reopen over and over, all rolls will be the same for the entire book, but they eventually will succeed since they should increase in bonuses.

Spread ID Number
Spread type - FULL - SEPARATE

LEFTPAGE-PICTURE
LEFTPAGE-TEXT TlkEntry -1 if text
LEFTPAGE-TEXT String
LEFTPAGE-SPELL
LEFTPAGE-Language
LEFTPAGE-Trap
LEFTPAGE-TrapEffect
LEFTPAGE-Hidden

- basically ignored if full spread, only used if it's 2 column
RIGHTPAGE-PICTURE
RIGHTTPAGE-TEXT TlkEntry -1 if text
RIGHTPAGE-TEXT String
RIGHTPAGE-SPELL
RIGHTPAGE-Language
RIGHTPAGE-Trap
RIGHTPAGE-TrapEffect
RIGHTPAGE-Hidden

XML Elements listed
Spell Icons down the left side -> BOOK_ICON_LEFT_1 BOOK_ICON_LEFT_2 BOOK_ICON_LEFT_3 etc
Spell Icons down the Right side -> BOOK_ICON_RIGHT_1 BOOK_ICON_RIGHT_2 BOOK_ICON_RIGHT_3 etc

Customizeable buttons across the bottom- programmable,when text on them is set just like playerlist
BOOK_BUTTON1 BOOK_BUTTON2 BOOK_BUTTON3 BOOK_BUTTON4

BOOK_EDIT_BOTTOMRIGHT_CONTAINER
BOOK_EDIT_BOTTOMRIGHT_LISTBOX
BOOK_EDIT_BOTTOMRIGHT_LEFT


usable fonts
Default
NWN1_Dialog
NWN2_Dialog
Floating_Text_Default
Floating_Text_Special
International
Title_Font
Body_Font
Special_Font
Special_Font_2

DRACONIC
CELESTIAL
DETHEK
DROW
THORASS
ESPRUAR
IGANEK
ABYSSEK
TREANT
INFERNEK
AQUANEK
AURSSEK
TARRANEK
SYLVAN


Draconic
Celestial
Dethek
Drow
Thorass
Espruar
Iganek
Abyssek
Treant
Infernek
Aquanek
Aurssek
Tarranek
Sylvan

Common1
Translated

*/


int SCBookLanguagesInstalled( object oPC )
{
	int bLangInstalled = GetLocalInt( oPC, "CSL_LANGUAGEFONTS_INSTALLED" );
	
	if ( bLangInstalled == 0 )
	{
		CloseGUIScreen( oPC, "FONT_FAMILY" );
		SetLocalInt( oPC, "CSL_LANGUAGEFONTS_INSTALLED", -1 );
		DisplayGuiScreen(oPC, "FONT_FAMILY", FALSE, "fontfamily.xml");
		CloseGUIScreen( oPC, "FONT_FAMILY" );
		DisplayGuiScreen(oPC, "FONT_FAMILY", FALSE, "fontfamily.xml");
		DelayCommand( 0.5f, CloseGUIScreen( oPC, "FONT_FAMILY" ) );
	}
	
	return bLangInstalled;
}


void SCBook_DisplayRight( object oPC, string sTextRight, string sFontRight, string sTextureLeft, string sTextureRight )
{
	string sFontSuffixRight = "";
	
	if ( SCBookLanguagesInstalled( oPC ) ) // only deal with this IF languages are installed, probably can optimize this to remember the last languages used, and just unset those, ie all plain boxes and the last 2 languages used would cut down on number of operations here
	{
	
		if ( sFontRight != "" )
		{
			sFontSuffixRight += "_"+GetStringUpperCase(sFontRight);
			
			SetLocalString( oPC, "CSL_LANGUAAGES_LASTFONT_RIGHT", GetStringUpperCase(sFontRight) );
			
			sTextRight = CSLLanguageTranslate( GetStringLeft(sTextRight,900), sFontRight );
			///sTextRight = CSLLanguageTranslate( sTextRight, sFontRight );
		}
	}
	else
	{
		if ( sFontRight != "" )
		{
			sFontSuffixRight += "_"+GetStringUpperCase(sFontRight);
			
			SetLocalString( oPC, "CSL_LANGUAAGES_LASTFONT_RIGHT", GetStringUpperCase(sFontRight) );
			
			sTextRight = CSLLanguageTranslate( GetStringLeft(sTextRight,900), sFontRight );
			///sTextRight = CSLLanguageTranslate( sTextRight, sFontRight );
		}
	}
	
	string sImageRightSuffix = "_V";
	if ( FindSubString(sTextureRight, "_h_") != -1 )
	{
		sImageRightSuffix = "_H";
	}
	
	string sImageLeftSuffix = "_V"; // 290x425
	if ( FindSubString(sTextureLeft, "_h_") != -1 )
	{
		sImageLeftSuffix = "_H"; // 590x425
	}
	
		
	if ( sTextureRight == "" )
	{
		//if ( bEditRight )
		//{
		//	//SendMessageToPC(oPC,"BOOK_EDIT_RIGHT" );
		//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_RIGHT_CONTAINER", FALSE ); // true hides
		//	SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_EDIT_RIGHT", -1, sTextRight );
		//}
		//else
		//{
			//SendMessageToPC(oPC,"BOOK_TEXT_RIGHT"+sFontSuffixRight );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_RIGHT_CONTAINER"+sFontSuffixRight, FALSE ); // true hides
			SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_TEXT_RIGHT"+sFontSuffixRight, -1, sTextRight );
		//}
	}
	else
	{
		//if ( bEditRight )
		//{
		//	//SendMessageToPC(oPC,"BOOK_EDIT_BOTTOMRIGHT" );
		//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOMRIGHT_CONTAINER", FALSE ); // true hides
		//	SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOMRIGHT", -1, sTextRight );
		//	
		//	//SendMessageToPC(oPC,"BOOK_IMAGE_TOPRIGHT"+sImageRightSuffix );
		//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT_CONTAINER", FALSE ); // true hides
		//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT"+sImageRightSuffix, FALSE ); // true hides
		//	SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT"+sImageRightSuffix, sTextureRight);
		//}
		//else 
		if ( sTextRight != "" )
		{
			//SendMessageToPC(oPC,"BOOK_TEXT_BOTTOMRIGHT"+sFontSuffixRight );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMRIGHT_CONTAINER"+sFontSuffixRight, FALSE ); // true hides
			SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMRIGHT"+sFontSuffixRight, -1, sTextRight );
			
			//SendMessageToPC(oPC,"BOOK_IMAGE_TOPRIGHT"+sImageRightSuffix );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT_CONTAINER", FALSE ); // true hides
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT"+sImageRightSuffix, FALSE ); // true hides
			SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT"+sImageRightSuffix, sTextureRight);
		}
		else
		{
			//SendMessageToPC(oPC, "BOOK_IMAGE_RIGHT"+sImageRightSuffix );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT_CONTAINER", FALSE ); // true hides
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT"+sImageLeftSuffix, FALSE ); // true hides
			SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT"+sImageRightSuffix, sTextureRight);
		}
		
	}
	
	
	
	
}

void SCBook_DisplayLeft( object oPC, string sTextLeft, string sFontLeft, int bFacingPages, string sTextureLeft )
{
	
	string sFontSuffixLeft = ""; // need to implement left and right fonts
	
	
	
	
	
	
	if ( SCBookLanguagesInstalled( oPC ) ) // only deal with this IF languages are installed, probably can optimize this to remember the last languages used, and just unset those, ie all plain boxes and the last 2 languages used would cut down on number of operations here
	{
		if ( sFontLeft != "" )
		{
			sFontSuffixLeft += "_"+GetStringUpperCase(sFontLeft);
			
			SetLocalString( oPC, "CSL_LANGUAAGES_LASTFONT_LEFT", GetStringUpperCase(sFontLeft) );
			sTextLeft = CSLLanguageTranslate( GetStringLeft(sTextLeft,900), sFontLeft );
			//sTextLeft = CSLLanguageTranslate( sTextRight, sTextLeft );
		}
	}
	else
	{
		if ( sFontLeft != ""  )
		{
			sFontSuffixLeft += "_"+GetStringUpperCase(sFontLeft);
			
			SetLocalString( oPC, "CSL_LANGUAAGES_LASTFONT_LEFT", GetStringUpperCase(sFontLeft) );
			sTextLeft = CSLLanguageTranslate( GetStringLeft(sTextLeft,900), sFontLeft );
			//sTextLeft = CSLLanguageTranslate( sTextRight, sTextLeft );
		}
	}
	
	string sImageLeftSuffix = "_V"; // 290x425
	if ( FindSubString(sTextureLeft, "_h_") != -1 )
	{
		sImageLeftSuffix = "_H"; // 590x425
	}
	
	
	
	// sets the given text after its unhidden
	if ( bFacingPages )
	{
		if ( sTextureLeft == "" )
		{
			//if ( bEditLeft )
			//{
			//	//SendMessageToPC(oPC,"BOOK_EDIT_LEFT" );
			//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_LEFT_CONTAINER", FALSE ); // true hides
			//	SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_EDIT_LEFT", -1, sTextLeft );
			//}
			//else
			//{
				//SendMessageToPC(oPC,"BOOK_TEXT_LEFT"+sFontSuffixLeft );
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_LEFT_CONTAINER"+sFontSuffixLeft, FALSE ); // true hides
				SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_TEXT_LEFT"+sFontSuffixLeft, -1, sTextLeft );
			//}
		}
		else
		{
			//if ( bEditLeft )
			//{
			//	//SendMessageToPC(oPC,"BOOK_EDIT_BOTTOMLEFT" );
			//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOMLEFT_CONTAINER", FALSE ); // true hides
			//	SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOMLEFT", -1, sTextLeft );
			//	
			//	//SendMessageToPC(oPC,"BOOK_IMAGE_TOPLEFT"+sImageLeftSuffix );
			//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT_CONTAINER", FALSE ); // true hides
			//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT"+sImageLeftSuffix, FALSE ); // true hides
			//	SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT"+sImageLeftSuffix, sTextureLeft );
			//}
			//else 
			if ( sTextLeft != "" )
			{
				//SendMessageToPC(oPC,"BOOK_TEXT_BOTTOMLEFT"+sFontSuffixLeft );
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMLEFT_CONTAINER"+sFontSuffixLeft, FALSE ); // true hides
				SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMLEFT"+sFontSuffixLeft, -1, sTextLeft );
				
				//SendMessageToPC(oPC,"BOOK_IMAGE_TOPLEFT"+sImageLeftSuffix );
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT_CONTAINER", FALSE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT"+sImageLeftSuffix, FALSE ); // true hides
				SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT"+sImageLeftSuffix, sTextureLeft );
			}
			else
			{
				//SendMessageToPC(oPC,"BOOK_IMAGE_LEFT"+sImageLeftSuffix );
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_LEFT_CONTAINER"+sFontSuffixLeft, FALSE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_LEFT"+sImageLeftSuffix, FALSE ); // true hides
				SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_LEFT"+sImageLeftSuffix, sTextureLeft);
			}
		}
	
	}
	else
	{
		if ( sTextureLeft == "" )
		{
			//if ( bEditLeft )
			//{
			//	//SendMessageToPC(oPC,"BOOK_EDIT_FULL");
			//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_FULL_CONTAINER", FALSE ); // true hides
			//	SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_EDIT_FULL", -1, sTextLeft );
			//}
			//else
			//{
				//SendMessageToPC(oPC,"BOOK_TEXT_FULL"+sFontSuffixLeft );
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_FULL_CONTAINER"+sFontSuffixLeft, FALSE ); // true hides
				SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_TEXT_FULL"+sFontSuffixLeft, -1, sTextLeft );
			//}
		}
		else
		{
			//if ( bEditLeft )
			//{
			//	//SendMessageToPC(oPC,"BOOK_EDIT_BOTTOM" );
			//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOM_CONTAINER", FALSE ); // true hides
			//	SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOM", -1, sTextLeft );
			//	
			//	//SendMessageToPC(oPC,"BOOK_IMAGE_TOP"+sImageLeftSuffix);
			//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP_CONTAINER", FALSE ); // true hides
			//	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP"+sImageLeftSuffix, FALSE ); // true hides
			//	SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP"+sImageLeftSuffix, sTextureLeft);
			//}
			//else 
			if ( sTextLeft != "" )
			{
				//SendMessageToPC(oPC,"BOOK_TEXT_BOTTOM"+sFontSuffixLeft );
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOM_CONTAINER"+sFontSuffixLeft, FALSE ); // true hides
				SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOM"+sFontSuffixLeft, -1, sTextLeft );
				
				//SendMessageToPC(oPC,"BOOK_IMAGE_TOP"+sImageLeftSuffix );
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP_CONTAINER", FALSE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP"+sImageLeftSuffix, FALSE ); // true hides
				SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP"+sImageLeftSuffix, sTextureLeft);
			}
			else
			{
				//SendMessageToPC(oPC,"BOOK_IMAGE_FULL"+sImageLeftSuffix );
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_FULL_CONTAINER", FALSE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_FULL"+sImageLeftSuffix, FALSE ); // true hides
				SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_FULL"+sImageLeftSuffix, sTextureLeft);
			}
		}
	}

}

void SCBook_DisplayEditor( int iSpreadNumber, int iPageType, object oBook, object oPC = OBJECT_SELF ) // CSLBOOK_PAGETYPE_LEFT
{
	SetLocalGUIVariable(oPC,SCREEN_BOOK,999,IntToString(ObjectToInt(oPC)));
	SetLocalGUIVariable(oPC,SCREEN_BOOK,998,IntToString(ObjectToInt(oBook)));
	SetLocalGUIVariable(oPC,SCREEN_BOOK,997,IntToString(iPageType));
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "READING_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "EDIT_CONTAINER", FALSE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "PICTURE_CONTAINER", TRUE ); // true hides
}

void SCBook_DisplayPicture( int iSpreadNumber, int iPageType, object oBook, object oPC = OBJECT_SELF ) // CSLBOOK_PAGETYPE_LEFT
{
	SetLocalGUIVariable(oPC,SCREEN_BOOK,999,IntToString(ObjectToInt(oPC)));
	SetLocalGUIVariable(oPC,SCREEN_BOOK,998,IntToString(ObjectToInt(oBook)));
	SetLocalGUIVariable(oPC,SCREEN_BOOK,997,IntToString(iPageType));
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "READING_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "EDIT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "PICTURE_CONTAINER", FALSE ); // true hides
}

void SCBook_DisplaySpread( int iSpreadNumber, object oBook, object oPC = OBJECT_SELF )
{
	//SendMessageToPC(oPC,"SCBook_DisplaySpread" );
	
	SetLocalObject(oPC, "CSLBOOK_VIEWING", oBook);
	SetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD", iSpreadNumber );
	
	int iBookType = GetLocalInt(oBook, "CSLBOOK_BOOKTYPE" );
	int iSpreadType = GetLocalInt(oBook, "CSLSPREAD_TYPE" );
	int iTotalSpreads = GetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPREADS");
	
	/* I am randomly generating pages to allow implementation, the random results will be replaced by stored data on a given item, with variables storing text, picture URLs, links, spellid's and the rest to describe a page */
	
	
	string sTextLeft, sTextureLeft, sTextRight, sTextureRight;
	
	SetLocalGUIVariable(oPC,SCREEN_BOOK,999,IntToString(ObjectToInt(oPC)));
	SetLocalGUIVariable(oPC,SCREEN_BOOK,998,IntToString(ObjectToInt(oBook)));
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "READING_CONTAINER", FALSE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "EDIT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "PICTURE_CONTAINER", TRUE ); // true hides
	
	string sParameters = GetLocalString( oPC, "CSL_LANG_PARAMS" );
	
	//string sTextureList = "csl_v_dragoncrytstal.tga,csl_v_thayansymbol.tga,csl_v_dragonradiant.tga,csl_h_dragonbrass.tga,csl_h_dexmap.tga,csl_v_summoning.tga,csl_v_wizard.tga,csl_h_swords.tga,csl_h_correlion.tga,csl_v_succubus2.tga,csl_v_demonlord.tga,csl_v_demon.tga,csl_v_demon3.tga";
	 //sTextureList += ",csl_v_gnollgod.tga,csl_v_battleaxe.tga,csl_v_chaos.tga,csl_h_dragonsilver.tga,csl_v_demon2.tga,csl_h_dragonbronze.tga,csl_v_balorlord.tga,csl_h_crownbones.tga,csl_v_succubus1.tga,csl_v_iconicsorceress.tga,csl_h_skull.tga,csl_h_dragongold.tga,csl_v_sorcery.tga";
	 //sTextureList += ",csl_v_hellschaos.tga,csl_h_dragonpyro.tga,csl_v_demonlord3.tga,csl_h_dragoncopper.tga,csl_v_planescape.tga,csl_h_spider.tga,csl_v_demonlord2.tga,csl_v_tiefling.tga,csl_h_dragonchaos.tga,csl_v_balor.tga,csl_h_dragonstyx.tga";
	
	//string sLanguageList = "Draconic,Celestial,Dethek,Drow,Thorass,Espruar,Iganek,Abyssek,Treant,Infernek,Aquanek,Aurssek,Tarranek,Sylvan,Logos,Pathos,Shou,Hieroglyph,Maztican,Chult,Midani,Ysgard,Imaskari,Deven,Waelan,Barazhad,Rellanic";
	
	string sFontLeft = "";
	string sFontRight = "";
	
	int bLangInstalled = SCBookLanguagesInstalled( oPC );
	
	
	
	//SendMessageToPC(oPC,"CSL_LANGUAGEFONTS_INSTALLED bLangInstalled="+IntToString(bLangInstalled) );
	
	//if ( bLangInstalled == 0 )
	//{
	//	CloseGUIScreen( oPC, "FONT_FAMILY" );
	//	SetLocalInt( oPC, "CSL_LANGUAGEFONTS_INSTALLED", -1 );
	//	DisplayGuiScreen(oPC, "FONT_FAMILY", FALSE, "fontfamily.xml");
	//	CloseGUIScreen( oPC, "FONT_FAMILY" );
	//	DisplayGuiScreen(oPC, "FONT_FAMILY", FALSE, "fontfamily.xml");
	//	DelayCommand( 0.5f, CloseGUIScreen( oPC, "FONT_FAMILY" ) );
	//}
	//
	/*
	if ( bLangInstalled )
	{
		SetLocalGUIVariable(oPC,SCREEN_BOOK,100,"Espruar");
	}
	else
	{
		SetLocalGUIVariable(oPC,SCREEN_BOOK,100,"NWN1_Dialog");
	}
	*/
	
	// the following will vary based on content, doing it randomly to implement testing
	int bEditRight = FALSE;
	int bEditLeft = FALSE;
	int bEditableRight = FALSE;
	int bEditableLeft = FALSE;
	if (  GetHasSpell( SPELL_ALTERTEXT, oPC ) )
	{
		bEditableRight = TRUE;
		bEditableLeft = TRUE;
	}
	
	int bFacingPages = FALSE;
	int bShowHiddenLeft = FALSE;
	int bShowHiddenRight = FALSE;
	int bUnderstoodLeft = FALSE;
	int bUnderstoodRight = FALSE;
	
	int bTearableLeft = FALSE;
	int bTearableRight = FALSE;
	
	//if ( d2() == 1 )
	//{
	//	//bEdit = TRUE;
	//}
	string sSpellLeft = "";
	string sTrapLeft = "";
	string sSpellRight = "";
	string sTrapRight = "";
	int iHiddenLeft = FALSE;
	int iHiddenRight = FALSE;
	
	if ( iSpreadType == CSLBOOK_SPREADTYPE_FACING )
	{
		bFacingPages = TRUE;
	}
	
	if ( bShowHiddenLeft )
	{
		sTextLeft = GetLocalString(oBook, "LEFTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_TEXTSTRING" );
		sTextureLeft = GetLocalString(oBook, "LEFTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_PICTURE" );
		sFontLeft = GetLocalString(oBook, "LEFTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_LANGUAGE" );
		sSpellLeft = GetLocalString(oBook, "LEFTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_SPELL" );
		sTrapLeft = GetLocalString(oBook, "LEFTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_TRAP" );
		//iHiddenLeft = GetLocalInt(oBook, "LEFTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_HIDDEN" );
		if ( sTextLeft == "" && sTextureLeft == "" )
		{
			sTextLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_TEXTSTRING" );
			sTextureLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_PICTURE" );
			sFontLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_LANGUAGE" );
			//sSpellLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_SPELL" );
			//sTrapLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_TRAP" );
			//iHiddenLeft = GetLocalInt(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_HIDDEN" );
		}
	}
	else
	{
		sTextLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_TEXTSTRING" );
		sTextureLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_PICTURE" );
		sFontLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_LANGUAGE" );
		sSpellLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_SPELL" );
		sTrapLeft = GetLocalString(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_TRAP" );
		iHiddenLeft = GetLocalInt(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_"+"_HIDDEN" );
	}

	if ( bFacingPages )
	{
		if ( bShowHiddenRight )
		{
			sTextRight = GetLocalString(oBook, "RIGHTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_TEXTSTRING" );
			sTextureRight = GetLocalString(oBook, "RIGHTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_PICTURE" );
			sFontRight = GetLocalString(oBook, "RIGHTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_LANGUAGE" );
			sSpellRight = GetLocalString(oBook, "RIGHTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_SPELL" );
			sTrapRight = GetLocalString(oBook, "RIGHTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_TRAP" );
			//iHiddenRight = GetLocalInt(oBook, "RIGHTPAGE_HID_"+IntToString(iSpreadNumber)+"_"+"_HIDDEN" );
			if ( sTextRight == "" && sTextureRight == "" )
			{
				sTextRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_TEXTSTRING" );
				sTextureRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_PICTURE" );
				sFontRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_LANGUAGE" );
				//sSpellRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_SPELL" );
				//sTrapRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_TRAP" );
				//iHiddenRight = GetLocalInt(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_HIDDEN" );
			}
		}
		else
		{
			sTextRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_TEXTSTRING" );
			sTextureRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_PICTURE" );
			sFontRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_LANGUAGE" );
			sSpellRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_SPELL" );
			sTrapRight = GetLocalString(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_TRAP" );
			iHiddenRight = GetLocalInt(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_"+"_HIDDEN" );
		}
		
	}
	
	if ( sTextLeft == "" && sTextureLeft == "" )
	{
		bEditableLeft = TRUE;
		bUnderstoodLeft = TRUE;
	}
	else
	{
		sFontLeft = GetStringLowerCase(sFontLeft);
		if ( sFontLeft == "" || (sFontLeft) == "common"  )
		{
			sFontLeft = "";	// nothing to translate
			bUnderstoodLeft = TRUE;
		}
		else if ( CSLLanguageUnderstood(oPC, sFontLeft )  )
		{
			sFontLeft = "";	// understood
			bUnderstoodLeft = TRUE;
		}
		else
		{
			
			bEditableLeft = FALSE; // cannot edit if you don't know it
		}
	}
	
	if ( sTextRight == "" && sTextureRight == "" )
	{
		bEditableRight = TRUE;
		bUnderstoodRight = TRUE;
	}
	else
	{
		sFontRight = GetStringLowerCase(sFontRight);
		if ( sFontRight == "" || sFontRight == "common" )
		{
			sFontRight = ""; // nothing to translate
			bUnderstoodRight = TRUE;
		}
		else if ( CSLLanguageUnderstood(oPC, sFontRight )  )
		{
			sFontRight = ""; // understood
			bUnderstoodRight = TRUE;
		}
		else
		{
			bEditableRight = FALSE; // cannot edit if you don't know it
		}
	}
	
	
	if ( iTotalSpreads <= 1 ) // turn off paging entirely, only one page here
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_FIRST", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PREVIOUS", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_NEXT", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_LAST", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PAGE_LEFT", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_RIGHT", TRUE );
	}
	else
	{
		if ( bFacingPages )
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PAGE_LEFT", FALSE );
			SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_PAGE_LEFT", -1, IntToString( ((iSpreadNumber+1)*2)-1 ) );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PAGE_RIGHT", FALSE );
			SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_PAGE_RIGHT", -1, IntToString( (iSpreadNumber+1)*2 ) );
		}
		else
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PAGE_LEFT", FALSE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PAGE_RIGHT", TRUE );
			SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_PAGE_LEFT", -1, IntToString( iSpreadNumber+1 ) );
		}
		
		if ( iSpreadNumber == 0 )
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_FIRST", TRUE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PREVIOUS", TRUE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_NEXT", FALSE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_LAST", FALSE );
		}
		else if ( iSpreadNumber >= iTotalSpreads )
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_FIRST", FALSE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PREVIOUS", FALSE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_NEXT", TRUE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_LAST", TRUE );
		}
		else
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_FIRST", FALSE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_PREVIOUS", FALSE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_NEXT", FALSE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_LAST", FALSE );
		}
	
	}
	
	
	//string sTrapLeft = "";
	//string sTrapRight = "";
	
	
	if ( sSpellLeft != "" && bUnderstoodLeft )
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SPELL_LEFT", FALSE );
	}
	else
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SPELL_LEFT", TRUE );
	}
		
	if ( bTearableLeft )
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEAR_LEFT", FALSE );
	}
	else
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEAR_LEFT", TRUE );
	}
	
	if ( iHiddenLeft && GetHasSpell( SPELL_TRUE_SEEING, oPC ) )
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SECRET_LEFT", FALSE );
	}
	else
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SECRET_LEFT", TRUE );
	}
	
	
	if ( bEditableLeft == TRUE )
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_LEFT", FALSE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_LEFT", FALSE );
	}
	else
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_LEFT", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_LEFT", TRUE );
	}
	
	if ( !bFacingPages )
	{
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SPELL_RIGHT", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEAR_RIGHT", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SECRET_RIGHT", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT", TRUE );
		SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_RIGHT", TRUE );
	}
	else
	{
		
		if ( sSpellRight != "" && bUnderstoodRight )
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SPELL_RIGHT", FALSE );
		}
		else
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SPELL_RIGHT", TRUE );
		}

		if ( bTearableRight )
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEAR_RIGHT", FALSE );
		}
		else
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEAR_RIGHT", TRUE );
		}
		
		if ( iHiddenRight  && GetHasSpell( SPELL_TRUE_SEEING, oPC ) )
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SECRET_RIGHT", FALSE );
		}
		else
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_SECRET_RIGHT", TRUE );
		}
		
		if ( bEditableRight == TRUE )
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT", FALSE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_RIGHT", FALSE );
		}
		else
		{
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT", TRUE );
			SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_RIGHT", TRUE );
		}
	}
	
	
	
	
	
	// first hide all content panes to ensure previously displayed info is not still visible
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_FULL_CONTAINER", TRUE ); // true hides
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOM_CONTAINER", TRUE ); // true hides
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_LEFT_CONTAINER", TRUE ); // true hides
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_RIGHT_CONTAINER", TRUE ); // true hides
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOMLEFT_CONTAINER", TRUE ); // true hides
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_EDIT_BOTTOMRIGHT_CONTAINER", TRUE ); // true hides
	
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_FULL_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOM_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_LEFT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_RIGHT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMLEFT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMRIGHT_CONTAINER", TRUE ); // true hides
	
	
	if ( bLangInstalled ) // only deal with this IF languages are installed, probably can optimize this to remember the last languages used, and just unset those, ie all plain boxes and the last 2 languages used would cut down on number of operations here
	{
		string sLastFontLeft = GetLocalString( oPC, "CSL_LANGUAAGES_LASTFONT_LEFT" );
		string sLastFontRIght = GetLocalString( oPC, "CSL_LANGUAAGES_LASTFONT_RIGHT"  );
		if ( sLastFontLeft != "" || sLastFontRIght != "" )
		{
			if ( sLastFontLeft != "" )
			{
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_FULL_CONTAINER_"+sLastFontLeft, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOM_CONTAINER_"+sLastFontLeft, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_LEFT_CONTAINER_"+sLastFontLeft, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_RIGHT_CONTAINER_"+sLastFontLeft, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMLEFT_CONTAINER_"+sLastFontLeft, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMRIGHT_CONTAINER_"+sLastFontLeft, TRUE ); // true hides
			}
			if ( sLastFontRIght != ""  )
			{
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_FULL_CONTAINER_"+sLastFontRIght, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOM_CONTAINER_"+sLastFontRIght, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_LEFT_CONTAINER_"+sLastFontRIght, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_RIGHT_CONTAINER_"+sLastFontRIght, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMLEFT_CONTAINER_"+sLastFontRIght, TRUE ); // true hides
				SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_TEXT_BOTTOMRIGHT_CONTAINER_"+sLastFontRIght, TRUE ); // true hides
			}
		}
	}
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_FULL_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_FULL_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_FULL_V", TRUE ); // true hides
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPLEFT_V", TRUE ); // true hides
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMLEFT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMLEFT_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMLEFT_V", TRUE ); // true hides
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOPRIGHT_V", TRUE ); // true hides
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMRIGHT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMRIGHT_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMRIGHT_V", TRUE ); // true hides
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_LEFT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_LEFT_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_LEFT_V", TRUE ); // true hides
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_RIGHT_V", TRUE ); // true hides
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_TOP_V", TRUE ); // true hides
	
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOM_CONTAINER", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOM_H", TRUE ); // true hides
	SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOM_V", TRUE ); // true hides
	
	
	
	DelayCommand(0.0f, SCBook_DisplayLeft( oPC, sTextLeft, sFontLeft, bFacingPages, sTextureLeft) );
	
	if ( bFacingPages )
	{
		DelayCommand(0.0f, SCBook_DisplayRight( oPC, sTextRight, sFontRight, sTextureLeft, sTextureRight ) );
	}
	// need to get the icon for the given spell basically which is stored on the given page
	//SetGUITexture(oPC, SCREEN_BOOK, "BOOK_ICON_LEFT_1", sTexture);
	//SetGUITexture(oPC, SCREEN_BOOK, "BOOK_ICON_RIGHT_1", sTexture);
	
	
	//SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOM", sTexture);
	//SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMLEFT", sTexture);
	//SetGUITexture(oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMRIGHT", sTexture);
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMLEFT_CONTAINER", FALSE ); // true hides
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOMRIGHT_CONTAINER", FALSE ); // true hides
	//SetGUIObjectHidden( oPC, SCREEN_BOOK, "BOOK_IMAGE_BOTTOM_CONTAINER", FALSE ); // true hides
}



void SCBook_Display( object oBook, object oPC = OBJECT_SELF  )
{
	// oBook is player in this case, need to do real book
	
	if ( !GetIsObjectValid( oBook) )
	{
		CloseGUIScreen( oPC,SCREEN_BOOK );
		return;
	}
	
	string sTitle = GetLocalString(oBook, "CSLBOOK_TITLE");
	if ( sTitle == "" )
	{
		sTitle = GetName(oBook);
	}
	//CSLDMVariable_SetLvmTarget(oPCToShowVars, oBook);
	DisplayGuiScreen(oPC, SCREEN_BOOK, FALSE, XML_BOOK );
	SetGUIObjectText( oPC, SCREEN_BOOK, "BOOK_TITLE", -1, sTitle ); // random for now
	
	int iBookType = GetLocalInt(oBook, "CSLBOOK_BOOKTYPE" ); // random booktype for now
	
	if ( iBookType == CSLBOOK_BOOKTYPE_PARCHMENT )
	{
		SetGUITexture(oPC, SCREEN_BOOK, "BOOK_TYPE_IMAGE", "csl_book_BG_Parchment.tga");
	}
	else if  ( iBookType == CSLBOOK_BOOKTYPE_SCROLL )
	{
		SetGUITexture(oPC, SCREEN_BOOK, "BOOK_TYPE_IMAGE", "csl_book_BG_Scroll.tga");
	}
	else if  ( iBookType == CSLBOOK_BOOKTYPE_TABLET )
	{
		SetGUITexture(oPC, SCREEN_BOOK, "BOOK_TYPE_IMAGE", "csl_book_BG_Tablet.tga");
	}
	else if  ( iBookType == CSLBOOK_BOOKTYPE_CODEX )
	{
		SetGUITexture(oPC, SCREEN_BOOK, "BOOK_TYPE_IMAGE", "csl_book_BG_Codex.tga");
	}

	
	
	SCBook_DisplaySpread( 0, oBook, oPC );
	
	
	
	
	
	//CSLDMVariable_InitTargetVarRepository (oPCToShowVars, oBook);
	//SCCacheStats( oBook );
	//DelayCommand( 0.5, SCCharEdit_Build( oBook, oPC, sScreenName ) );
}


int CSLBookUnacquire( object oBook, object oLostBy = OBJECT_INVALID )
{
	// makes sure the book has the item property to activate
	
	// return true; to prevent more events from firing
	
	return FALSE;
}

// adding property here to activate, not sure if that is a good idea at all yet
int CSLBookAcquire( object oBook, object oAcquirer = OBJECT_INVALID ) // this might cause issues, but makes all books suddenly use the new GUI
{
	// makes sure the book has the item property to activate
	//
	//void CSLSafeAddItemProperty(object oItem, itemproperty ip, float fDuration =0.0f, int nAddItemPropertyPolicy = SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, int bIgnoreDurationType = FALSE, int bIgnoreSubType = FALSE)
	if ( GetIsPC( oAcquirer ) ) // BOOKS ARE NOT USABLE BY NPCS
	{
		// add ability for it to activate item so a person can get the book GUI
		CSLSafeAddItemProperty( oBook, ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE), 0.0f, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
	}
	// return true; to prevent more events from firing
	
	return FALSE;
}

int CSLBookActivate( object oBook, object oActivator = OBJECT_SELF )
{
	// makes sure the book has the item property to activate
	return FALSE;
}



void CSLBookSet( object oBook, int iBookType, int iBookTotalSpreads, string sTitle = "", string sDescription = "", int iIcon = -1, object oReceiver = OBJECT_SELF )
{
	if ( iIcon > -1 )
	{
		SetItemIcon(oBook, iIcon );
	}
	
	if ( sTitle != "" )
	{
		SetFirstName(oBook, sTitle);
	}
	
	SetLocalInt(oBook, "CSLBOOK_BOOK", TRUE );
	
	SetLocalInt(oBook, "CSLBOOK_BOOKID", -CSLGetRandomSerialNumber() ); // random negative number to identify, if it's in the database it will use a positive number which will indicate it's data is actually in the DB and not on the object
	
	SetLocalInt(oBook, "CSLBOOK_BOOKTYPE", iBookType );
	SetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPREADS", iBookTotalSpreads );
	SetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPELLLEVELS", 0 );
	
	SetLocalString(oBook, "CSLBOOK_OWNERNAME", "" );
	
	SetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPELLLEVELS", 0 );
	
	SetLocalString(oBook, "CSLBOOK_SCRIPT_ONOPEN", "" );
	SetLocalString(oBook, "CSLBOOK_SCRIPT_ONCLOSED", "" );
	SetLocalString(oBook, "CSLBOOK_SCRIPT_ONPAGETURN", "" );
	SetLocalString(oBook, "CSLBOOK_SCRIPT_ONREAD", "" );
	
	SetLocalString(oBook, "CSLBOOK_COVER", "" );
	
	SetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD", GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD" ) ); // just making sure the variable is set for later
	
	SetLocalString(oBook, "CSLBOOK_TITLE", sTitle );
	
	SetLocalInt(oBook, "CSLBOOK_OWNERSLOREROLL", -1 );
	
	
	if ( sDescription != "" )
	{
		if ( CSLGetIsNumber( sDescription ) )
		{
			sDescription = GetStringByStrRef( StringToInt( sDescription ) );
		}
		SetDescription( oBook, sDescription);
	}
	
}


// creates a blank book object
object CSLBookCreate( int iBookType, int iBookTotalSpreads, string sTitle = "", string sDecription = "", int iIcon = -1, object oReceiver = OBJECT_SELF )
{
	//return OBJECT_INVALID;
	// CreateObject(OBJECT_TYPE_ITEM, "csl_it_book", GetLocation(oLocator), FALSE, "CSLBOOK");
	
	object oBook = CreateItemOnObject("csl_it_book", oReceiver, 1, "csl_it_book", FALSE);
	
	CSLBookSet( oBook, iBookType, iBookTotalSpreads, sTitle, sDecription, iIcon, oReceiver );
	
	return oBook;
}



void CSLBookSetOwner( object oBook, object oOwner = OBJECT_SELF )
{
	SetLocalString(oBook, "CSLBOOK_OWNERNAME", GetName( oOwner ) );
}



void CSLBookSetSpread( object oBook, int iSpreadNumber, int iPageType = CSLBOOK_PAGETYPE_LEFT )
{

}

void CSLBookAddSpread( object oBook, int iSpreadType = CSLBOOK_SPREADTYPE_FULL )
{
	// adds page to end of book - if there are editable pages// spreads at end of book uses those	
	// returns the page number
}

void CSLBookTearPage( object oBook, int iSpreadNumber,  int iPageType = CSLBOOK_PAGETYPE_LEFT, int bTorn = TRUE )
{
	int iBookType = GetLocalInt(oBook, "CSLBOOK_BOOKTYPE" );
	
	int iSpreadType = GetLocalInt(oBook, "CSLSPREAD_TYPE" );
	string sPageVar = "";
	
	if ( iPageType == CSLBOOK_PAGETYPE_LEFT )
	{
		sPageVar = "LEFTPAGE_"+IntToString(iSpreadNumber)+"_";
	}
	else if ( iPageType == CSLBOOK_PAGETYPE_RIGHT && iBookType == CSLBOOK_BOOKTYPE_CODEX )
	{
		sPageVar = "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_";
		if ( iSpreadType != CSLBOOK_SPREADTYPE_FACING ) // spread type is not set, lets guess as to what type base on the book type
		{
			iSpreadType = CSLBOOK_SPREADTYPE_FACING;
			SetLocalInt(oBook, "CSLSPREAD_TYPE", iSpreadType );
		}
	}
	else if ( iPageType == CSLBOOK_PAGETYPE_LEFTHIDDEN )
	{
		sPageVar = "LEFTPAGE_HID_"+IntToString(iSpreadNumber)+"_";
	}
	else if ( iPageType == CSLBOOK_PAGETYPE_RIGHTHIDDEN && iBookType == CSLBOOK_BOOKTYPE_CODEX )
	{
		sPageVar = "RIGHTPAGE_HID_"+IntToString(iSpreadNumber)+"_";
		if ( iSpreadType != CSLBOOK_SPREADTYPE_FACING ) // spread type is not set, lets guess as to what type base on the book type
		{
			iSpreadType = CSLBOOK_SPREADTYPE_FACING;
			SetLocalInt(oBook, "CSLSPREAD_TYPE", iSpreadType );
		}
	}
	else
	{
		// error
		return;
	}
	
	SetLocalInt(oBook, sPageVar+"_TORN", bTorn );
}

void CSLBookSetPage( object oBook, int iSpreadNumber,  string sText = "", int iPageType = CSLBOOK_PAGETYPE_LEFT, string sLang = "common", string sPicture = "", string sSpell = "", int iTrap = -1, string sTrapEffect = "" )
{
	int iBookType = GetLocalInt(oBook, "CSLBOOK_BOOKTYPE" );
	
	int iSpreadType = GetLocalInt(oBook, "CSLSPREAD_TYPE" );
	string sPageVar = "";
	
	if ( iPageType == CSLBOOK_PAGETYPE_LEFT )
	{
		sPageVar = "LEFTPAGE_"+IntToString(iSpreadNumber)+"_";
	}
	else if ( iPageType == CSLBOOK_PAGETYPE_RIGHT && iBookType == CSLBOOK_BOOKTYPE_CODEX )
	{
		sPageVar = "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_";
		if ( iSpreadType != CSLBOOK_SPREADTYPE_FACING ) // spread type is not set, lets guess as to what type base on the book type
		{
			iSpreadType = CSLBOOK_SPREADTYPE_FACING;
			SetLocalInt(oBook, "CSLSPREAD_TYPE", iSpreadType );
		}
	}
	else if ( iPageType == CSLBOOK_PAGETYPE_LEFTHIDDEN )
	{
		sPageVar = "LEFTPAGE_HID_"+IntToString(iSpreadNumber)+"_";
		SetLocalInt(oBook, "LEFTPAGE_"+IntToString(iSpreadNumber)+"_HIDDEN", TRUE );
	}
	else if ( iPageType == CSLBOOK_PAGETYPE_RIGHTHIDDEN && iBookType == CSLBOOK_BOOKTYPE_CODEX )
	{
		sPageVar = "RIGHTPAGE_HID_"+IntToString(iSpreadNumber)+"_";
		SetLocalInt(oBook, "RIGHTPAGE_"+IntToString(iSpreadNumber)+"_HIDDEN", TRUE );
		if ( iSpreadType != CSLBOOK_SPREADTYPE_FACING ) // spread type is not set, lets guess as to what type base on the book type
		{
			iSpreadType = CSLBOOK_SPREADTYPE_FACING;
			SetLocalInt(oBook, "CSLSPREAD_TYPE", iSpreadType );
		}
	}
	else
	{
		// error
		return;
	}
	
	
	if ( iSpreadType == 0 ) // spread type is not set, lets guess as to what type base on the book type
	{
		if ( iBookType == CSLBOOK_BOOKTYPE_CODEX )
		{
			iSpreadType = CSLBOOK_SPREADTYPE_FACING;
		}
		else
		{
			iSpreadType = CSLBOOK_SPREADTYPE_FULL;
		}
		SetLocalInt(oBook, "CSLSPREAD_TYPE", iSpreadType );
	}
	
	SetLocalString(oBook, sPageVar+"_PICTURE", sPicture );
	SetLocalInt(oBook, sPageVar+"_TEXTDB", -1 ); // this is for future features
	SetLocalInt(oBook, sPageVar+"_TEXTTLK", -1 ); // this is for future features
	SetLocalString(oBook, sPageVar+"_TEXTSTRING", sText );
	SetLocalString(oBook, sPageVar+"_SPELL", sSpell );  // need to add other paramters like caster level, meta magic and descrptor for later
	SetLocalString(oBook, sPageVar+"_LANGUAGE", sLang );
	SetLocalInt(oBook, sPageVar+"_TRAP", iTrap );
	SetLocalString(oBook, sPageVar+"_TRAPEFFECT", sTrapEffect );
	
	
	int iTotalSpreads = GetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPREADS" );
	if ( (iTotalSpreads-1) < iSpreadNumber )
	{
		SetLocalInt(oBook, "CSLBOOK_BOOKTOTALSPREADS", iSpreadNumber+1  );
	}
}
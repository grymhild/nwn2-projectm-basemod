/** @file
* @brief Appearance related functions, animation overrides, appearance changing
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/



/*
These are the basic Appearance functions, used to
change, increment and get information out of a
creatures appearance.

This will need to be edited to match the
appearance.2da. Note that it's in the exact same order,
so just figure out where you changed or added things to
that 2da, make new constants, and adjust each function
accordingly in about the same relative spot so it stays
in order.

Ideally this can be coordinated, soas to allow creatures 
to keep reserved ranges. And to make using the library easier.

( per a post in the forums )
Incidentally for setting an appearance back you don't need to store anything Using GetRacialSubType() in the SetCreatureAppearance() call will set you back to your original appearance.

*/
/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////





/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////







/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCConstants"
//#include "_SCUtilityConstants"
#include "_CSLCore_Strings"
#include "_CSLCore_Math"
#include "_CSLCore_ObjectVars"


// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////
#include "_CSLCore_Appearance_c"
#include "_CSLCore_Magic_c"





/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////
/*
string CSLGetStringByAppearance( int iAppearanceType );


int CSLGetIncrementAppearance( int iAppearanceType );

int CSLGetDecrementAppearance( int iAppearanceType );

int CSLGetBaseAppearance( int iAppearance );

float CSLGetHeightByAppearance( int iAppearanceType );

int CSLGetAppearanceBySubrace( int iSubRace );

// * This Gets an index for a given appearance constant
// * used for iterating all the constants, or getting a random constant
// * tie into next and previous perhaps
int CSLGetIndexByAppearance( int iAppearanceType );

// * This Gets an appearance constant for a given index
// * used for iterating all the constants, or getting a random constant
int CSLGetAppearanceByIndex( int iAppearanceType );
*/

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

object oAppearanceTable;
/**  
* Makes sure the oRaceTable is a valid pointer to the Race dataobject
* @author
* @see 
* @return 
*/
void CSLGetAppearanceDataObject()
{
	if ( !GetIsObjectValid( oAppearanceTable ) )
	{
		oAppearanceTable = CSLDataObjectGet( "appearance" );
	}
	//return oSpellTable;
}

object oRaceTable;

/**  
* Makes sure the oRaceTable is a valid pointer to the Race dataobject
* @author
* @see 
* @return 
*/
void CSLGetRaceDataObject()
{
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		oRaceTable = CSLDataObjectGet( "racialsubtypes" );
	}
	//return oSpellTable;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Determines how wide across the target is.
// This is more of a practical way to determine squares than it is real size.
float CSLGetGirth(object oTarget)
{
	int iAppearance = GetAppearanceType(oTarget);
	
	string sGirth;
	CSLGetAppearanceDataObject();
	if ( !GetIsObjectValid( oAppearanceTable ) )
	{
		sGirth = Get2DAString("appearance", "PREFATCKDIST", iAppearance);
	}
	sGirth = CSLDataTableGetStringByRow( oAppearanceTable, "PREFATCKDIST", iAppearance );
	
	return StringToFloat(sGirth);
}


float CSLGetHitDistance(object oTarget)
{
	int iAppearance = GetAppearanceType(oTarget);
	
	string sHitDistance;
	CSLGetAppearanceDataObject();
	if ( !GetIsObjectValid( oAppearanceTable ) )
	{
		sHitDistance = Get2DAString("appearance", "HITDIST", iAppearance);
	}
	sHitDistance = CSLDataTableGetStringByRow( oAppearanceTable, "HITDIST", iAppearance );
	
	return StringToFloat(sHitDistance);
}


/**  
* Get the Name of the given Subrace
* @author
* @param iSubRace Subrace as returned by GetSubRace()
* @return the Name of the specified SubRace
*/
string CSLGetRaceDataName(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return Get2DAString("racialsubtypes", "StrAdjust", iSubRace);
	}
	return CSLDataTableGetStringByRow( oRaceTable, "Name", iSubRace );
	
}


/**  
* Get the ECL of the given Subrace
* @param iSubRace Subrace as returned by GetSubRace()
* @return the ECL the specified SubRace, 0 on error
*/
int CSLGetRaceDataECL(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "ECL", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "ECL", iSubRace ));
}

/**  
* Get the ECL level cap for a creature of the given race which is used to block leveling past a certain level on pw's
* @param iSubRace Subrace as returned by GetSubRace()
* @return the ECL Cap the specified SubRace, 0 on error
*/
int CSLGetRaceDataECLCap(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "ECLCap", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "ECLCap", iSubRace ));
}

/**  
* Get the appearance index for a creature of the given race
* @param iSubRace Subrace as returned by GetSubRace()
* @return the appearance index of the specified SubRace
*/
int CSLGetRaceDataAppearance(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "AppearanceIndex", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "AppearanceIndex", iSubRace ));
}


/**  
* Get the Strength stat Adjustment for a creature of the given race
* @param iSubRace Subrace as returned by GetSubRace()
* @return the  Strength stat Adjustment of the specified SubRace
*/
int CSLGetRaceDataStrAdjust(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "StrAdjust", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "StrAdjust", iSubRace ));
}

/**  
* Get the Dexterity stat Adjustment for a creature of the given race
* @param iSubRace Subrace as returned by GetSubRace()
* @return the Dexterity stat Adjustment of the specified SubRace
*/
int CSLGetRaceDataDexAdjust(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "DexAdjust", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "DexAdjust", iSubRace ));
}

/**  
* Get the Constitution stat Adjustment for a creature of the given race
* @param iSubRace Subrace as returned by GetSubRace()
* @return the Constitution stat Adjustment of the specified SubRace
*/
int CSLGetRaceDataConAdjust(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "ConAdjust", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "ConAdjust", iSubRace ));
}


/**  
* Get the Intelligence stat Adjustment for a creature of the given race
* @param iSubRace Subrace as returned by GetSubRace()
* @return the Intelligence stat Adjustment of the specified SubRace
*/
int CSLGetRaceDataIntAdjust(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "IntAdjust", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "IntAdjust", iSubRace ));
}

/**  
* Get the Wisdom stat Adjustment for a creature of the given race
* @param iSubRace Subrace as returned by GetSubRace()
* @return the Wisdom stat Adjustment of the specified SubRace
*/
int CSLGetRaceDataWisAdjust(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "WisAdjust", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "WisAdjust", iSubRace ));
}

/**  
* Get the Charisma stat Adjustment for a creature of the given race
* @param iSubRace Subrace as returned by GetSubRace()
* @return the Charisma stat Adjustment of the specified SubRace
*/
int CSLGetRaceDataChaAdjust(int iSubRace)
{
	CSLGetRaceDataObject();
	if ( !GetIsObjectValid( oRaceTable ) )
	{
		return StringToInt( Get2DAString("racialsubtypes", "ChaAdjust", iSubRace) );
	}
	return StringToInt(CSLDataTableGetStringByRow( oRaceTable, "ChaAdjust", iSubRace ));
}


/**  
* Get a string from a corresponding Creature which can be stored in a database and converted back into a Appearance
* @param oPC Creature from which to get the appearance
* @return a string corresponding to the Appearance
*/
string CSLSerializeAppearance( object oPC = OBJECT_SELF )
{
	if ( GetIsObjectValid( oPC ) )
	{
		int iAppearance = GetAppearanceType(oPC);
		int iGender = GetGender(oPC);
		float fScaleX = GetScale(oPC, SCALE_X );
		float fScaleY = GetScale(oPC, SCALE_Y );
		float fScaleZ = GetScale(oPC, SCALE_Z );
		
		return "#A#" + IntToString(iAppearance) + 
		"#G#" + IntToString(iGender) + 
		"#X#" + FloatToString(fScaleX) + 
		"#Y#" + FloatToString(fScaleY) + 
		"#Z#" + FloatToString(fScaleZ) + "#END#";
	}
	return "";
}


/**  
* Apply a Appearance from a corresponding string
* @author jaliax and NWNx
* @param sAppearance a serialized Appearance
* @param oPC Creature to apply appearance to
*/
void CSLUnserializeApplyAppearance( string sAppearance,  object oPC = OBJECT_SELF)
{
	int iAppearance, iGender;
	float fScaleX, fScaleY, fScaleZ;
	
	int iPos, iCount;
	int iLen = GetStringLength(sAppearance);
	
	if (iLen > 0)
	{
		iPos = FindSubString(sAppearance, "#A#") + 3;
		iCount = FindSubString(GetSubString(sAppearance, iPos, iLen - iPos), "#");
		iAppearance = StringToInt(GetSubString(sAppearance, iPos, iCount));
		
		iPos = FindSubString(sAppearance, "#G#") + 3;
		iCount = FindSubString(GetSubString(sAppearance, iPos, iLen - iPos), "#");
		iGender = StringToInt(GetSubString(sAppearance, iPos, iCount));
		
		iPos = FindSubString(sAppearance, "#X#") + 3;
		iCount = FindSubString(GetSubString(sAppearance, iPos, iLen - iPos), "#");
		fScaleX = StringToFloat(GetSubString(sAppearance, iPos, iCount));
		
		iPos = FindSubString(sAppearance, "#Y#") + 3;
		iCount = FindSubString(GetSubString(sAppearance, iPos, iLen - iPos), "#");
		fScaleY = StringToFloat(GetSubString(sAppearance, iPos, iCount));
		
		iPos = FindSubString(sAppearance, "#Z#") + 3;
		iCount = FindSubString(GetSubString(sAppearance, iPos, iLen - iPos), "#");
		fScaleZ = StringToFloat(GetSubString(sAppearance, iPos, iCount));
		
		SetCreatureAppearanceType(oPC, iAppearance);
		SetGender(oPC, iGender);
		SetScale(oPC, fScaleX, fScaleY, fScaleZ );
		
	}
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAnimationStartOffsetByAppearance( int iAppearance )
{
	if ( iAppearance < 3600 ) // all overrides are above 3600 this is a safety
	{
		return -1;
	}
	return (iAppearance/200)*200;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAnimationOverrideByAppearance( int iAppearance )
{
	if ( iAppearance < 3600 ) // all overrides are above 3600 this is a safety
	{
		return -1;
	}
	string sValue = IntToString( CSLGetAnimationStartOffsetByAppearance( iAppearance ) );
	
	object oTable = CSLDataObjectGet( "anim_modes" );
	return CSLDataTableGetRowByValue( oTable, sValue );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAnimationStartOffsetByOverride( int iAnimationOverride )
{
	if ( iAnimationOverride > -1 )
	{
		object oTable = CSLDataObjectGet( "anim_modes" );
		//int iRow = CSLDataTableGetRowByIndex( oTable, iAnimationOverride );
		string sRowText = CSLDataTableGetStringByRow( oTable, "RangeStart", iAnimationOverride );
		//string sRowText = CSLDataTableGetStringByIndex( oTable, "RangeStart", iRow );
		
		if ( sRowText != "" )
		{
			return StringToInt(sRowText);
		}
	}
	return -1;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLGetAnimationStartScriptByOverride( int iAnimationOverride )
{
	if ( iAnimationOverride > -1 )
	{
		object oTable = CSLDataObjectGet( "anim_modes" );
		//int iRow = CSLDataTableGetRowByIndex( oTable, iAnimationOverride );
		string sRowText = CSLDataTableGetStringByRow( oTable, "StartScript", iAnimationOverride );
		//string sRowText = CSLDataTableGetStringByIndex( oTable, "RangeStart", iRow );
		
		if ( sRowText != "" )
		{
			return sRowText;
		}
	}
	return "";
}

/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLGetAnimationStopScriptByOverride( int iAnimationOverride )
{
	if ( iAnimationOverride > -1 )
	{
		object oTable = CSLDataObjectGet( "anim_modes" );
		//int iRow = CSLDataTableGetRowByIndex( oTable, iAnimationOverride );
		string sRowText = CSLDataTableGetStringByRow( oTable, "StopScript", iAnimationOverride );
		//string sRowText = CSLDataTableGetStringByIndex( oTable, "RangeStart", iRow );
		
		if ( sRowText != "" )
		{
			return sRowText;
		}
	}
	return "";
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAnimateOffsetByAppearance( int iAppearanceIndex )
{
	int iSubAppearance = iAppearanceIndex / 100;
	
	switch( iSubAppearance )
	{
		
		case 0:
			switch ( iAppearanceIndex )
			{
				case APPEAR_TYPE_DWARF: { return 130;}//  =  0; // 4130	hid_swm_0_Dwarf
				case APPEAR_TYPE_ELF: { return 121;}//  =  1; // 4121	hid_swm_1_Elf
				case APPEAR_TYPE_GNOME: { return 155;}//  =  2; // 4155	hid_swm_2_Gnome
				case APPEAR_TYPE_HALFLING: { return 1;}//  =  3; // 4001	hid_swm_3_Halfling
				case APPEAR_TYPE_HALF_ELF: { return 2;}//  =  4; // 4002	hid_swm_4_Half_Elf
				case APPEAR_TYPE_HALF_ORC: { return 173;}//  =  5; // 4173	hid_swm_5_Half_Orc
				case APPEAR_TYPE_HUMAN: { return 3;}//  =  6; // 4003	hid_swm_6_Human
				case APPEAR_TYPE_PLANETAR: { return 4;}//  =  26; // 4004	hid_swm_26_Planetar
				case APPEAR_TYPE_LICH: { return 5;}//  =  39; // 4005	hid_swm_39_Lich
				case APPEAR_TYPE_YUANTIPUREBLOOD: { return 6;}//  =  40; // 4006	hid_swm_40_Yuanti_Pureblood
				case APPEAR_TYPE_GRAYORC: { return 174;}//  =  45; // 4174	hid_swm_45_GrayOrc
				case APPEAR_TYPE_NPC_SASANI: { return 7;}//  =  47; // 4007	hid_swm_47_NPC_Sasani_NX2
				case APPEAR_TYPE_NPC_VOLO: { return 8;}//  =  48; // 4008	hid_swm_48_NPC_Volo_NX2
				case APPEAR_TYPE_NPC_SEPTIMUND: { return 9;}//  =  50; // 4009	hid_swm_50_NPC_Septimund_NX2
				case APPEAR_TYPE_DRYAD: { return 10;}//  =  51; // 4010	hid_swm_51_Dryad
			}
			break;
		
		case 2:
			if ( iAppearanceIndex == APPEAR_TYPE_VAMPIRE_FEMALE ) { return 11;}//  =  288; // 4011	hid_swm_288_Vampire_Female_Male -- note removing 		case APPEAR_TYPE_VAMPIRE_MALE: { return -1;}//  =  289; since it can use the sex to do the same thing
			break;
			
		case 4:
			if ( iAppearanceIndex == APPEAR_TYPE_GITHYANKI ) { return 12;}//  =  483; // 4012	hid_swm_483_Githyanki
			break;
			
		case 5:
			switch ( iAppearanceIndex )
			{
				
				case APPEAR_TYPE_DEVIL_ERINYES: { return 13;}//  =  514; // 4013	hid_swm_514_Devil_Erinyes
				case APPEAR_TYPE_SKELETON: { return 14;}//  =  537; // 4014	hid_swm_537_Skeleton
				case APPEAR_TYPE_NPC_GARIUS: { return 15;}//  =  544; // 4015	hid_swm_544_NPC_Garius
				case APPEAR_TYPE_NPC_DUNCAN: { return 16;}//  =  549; // 4016	hid_swm_549_NPC_Duncan
				case APPEAR_TYPE_NPC_LORDNASHER: { return 17;}//  =  550; // 4017	hid_swm_550_NPC_LordNasher
				case APPEAR_TYPE_NPC_CHILDHHM: { return 156;}//  =  551; // 4156	hid_swm_551_NPC_ChildHHM
				case APPEAR_TYPE_NPC_CHILDHHF: { return 157;}//  =  553; // 4157	hid_swm_553_NPC_ChildHHF
				case APPEAR_TYPE_ASSIMAR: { return 18;}//  =  563; // 4018	hid_swm_563_Assimar
				case APPEAR_TYPE_TIEFLING: { return 19;}//  =  564; // 4019	hid_swm_564_Tiefling
				case APPEAR_TYPE_ELF_SUN: { return 20;}//  =  565; // 4020	hid_swm_565_Elf_Sun
				case APPEAR_TYPE_ELF_WOOD: { return 21;}//  =  566; // 4021	hid_swm_566_Elf_Wood
				case APPEAR_TYPE_ELF_DROW: { return 22;}//  =  567; // 4022	hid_swm_567_Elf_Drow
				case APPEAR_TYPE_GNOME_SVIRFNEBLIN: { return 158;}//  =  568; // 4158	hid_swm_568_Gnome_Svirfneblin
				case APPEAR_TYPE_DWARF_GOLD: { return 131;}//  =  569; // 4131	hid_swm_569_Dwarf_Gold
				case APPEAR_TYPE_DWARF_DUERGAR: { return 132;}//  =  570; // 4132	hid_swm_570_Dwarf,Duergar
				case APPEAR_TYPE_HALFLING_STRONGHEART: { return 23;}//  =  571; // 4023	hid_swm_571_Halfling_Strongheart
				case APPEAR_TYPE_NPC_GITHCAPTAIN: { return 24;}//  =  579; // 4024	hid_swm_579_NPC_GithCaptain
				case APPEAR_TYPE_NPC_LORNE: { return 25;}//  =  580; // 4025	hid_swm_580_NPC_Lorne
				case APPEAR_TYPE_NPC_TENAVROK: { return 26;}//  =  581; // 4026	hid_swm_581_NPC_Tenavrok
				case APPEAR_TYPE_NPC_CTANN: { return 27;}//  =  582; // 4027	hid_swm_582_NPC_Ctann
				case APPEAR_TYPE_NPC_SHANDRA: { return 28;}//  =  583; // 4028	hid_swm_583_NPC_Shandra
				case APPEAR_TYPE_NPC_ZEEAIRE: { return 29;}//  =  584; // 4029	hid_swm_584_NPC_Zeeaire
				case APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT: { return 30;}//  =  585; // 4030	hid_swm_585_NPC_Zeeaires_Lieutenant
				case APPEAR_TYPE_NPC_ZHJAEVE: { return 31;}//  =  588; // 4031	hid_swm_588_NPC_Zhjaeve
				case APPEAR_TYPE_NPC_AHJA: { return 32;}//  =  590; // 4032	hid_swm_590_NPC_Ahja
				case APPEAR_TYPE_NPC_HEZEBEL: { return 33;}//  =  592; // 4033	hid_swm_592_NPC_Hezebel
				case APPEAR_TYPE_NPC_ZOKAN: { return 34;}//  =  594; // 4034	hid_swm_594_NPC_Zokan
				case APPEAR_TYPE_NPC_ALDANON: { return 35;}//  =  595; // 4035	hid_swm_595_NPC_Aldanon
				case APPEAR_TYPE_NPC_JACOBY: { return 36;}//  =  596; // 4036	hid_swm_596_NPC_Jacoby
				case APPEAR_TYPE_NPC_JALBOUN: { return 37;}//  =  597; // 4037	hid_swm_597_NPC_Jalboun
				case APPEAR_TYPE_NPC_KHRALVER: { return 38;}//  =  598; // 4038	hid_swm_598_NPC_Khralver
				case APPEAR_TYPE_NPC_KRALWOK: { return 39;}//  =  599; // 4039	hid_swm_599_NPC_Kralwok
			}
			break;
		
		case 6:
			switch ( iAppearanceIndex )
			{
				
				case APPEAR_TYPE_NPC_MEPHASM: { return 40;}//  =  600; // 4040	hid_swm_600_NPC_Mephasm
				case APPEAR_TYPE_NPC_MORKAI: { return 41;}//  =  601; // 4041	hid_swm_601_NPC_Morkai
				case APPEAR_TYPE_NPC_SARYA: { return 42;}//  =  602; // 4042	hid_swm_602_NPC_Sarya
				case APPEAR_TYPE_NPC_SYDNEY: { return 43;}//  =  603; // 4043	hid_swm_603_NPC_Sydney
				case APPEAR_TYPE_NPC_TORIOCLAVEN: { return 44;}//  =  604; // 4044	hid_swm_604_NPC_TorioClaven
				case APPEAR_TYPE_NPC_UTHANCK: { return 175;}//  =  605; // 4175	hid_swm_605_NPC_Uthanck
				case APPEAR_TYPE_NPC_SHADOWPRIEST: { return 45;}//  =  606; // 4045	hid_swm_606_NPC_ShadowPriest
			}
			break;
			
		case 10:
			switch ( iAppearanceIndex )
			{
				
				case APPEAR_TYPE_AKACHI: { return 46;}//  =  1000; // 4046	hid_swm_1000_Akachi_NX1
				case APPEAR_TYPE_RED_WIZ_COMPANION: { return 47;}//  =  1007; // 4047	hid_swm_1007_Red_Wiz_Companion_NX1
				case APPEAR_TYPE_DEATH_KNIGHT: { return 48;}//  =  1008; // 4048	hid_swm_1008_Death_Knight_NX1
				case APPEAR_TYPE_SOLAR: { return 49;}//  =  1013; // 4049	hid_swm_1013_Solar_NX1
				case APPEAR_TYPE_MAGDA: { return 50;}//  =  1034; // 4050	hid_swm_1034_Magda_NX1
				case APPEAR_TYPE_NEFRIS: { return 51;}//  =  1035; // 4051	hid_swm_1035_Nefris_NX1
				case APPEAR_TYPE_ELF_WILD: { return 52;}//  =  1036; // 4052	hid_swm_1036_Elf_Wild_NX1
				case APPEAR_TYPE_EARTH_GENASI: { return 53;}//  =  1037; // 4053	hid_swm_1037_Earth_Genasi_NX1
				case APPEAR_TYPE_FIRE_GENASI: { return 54;}//  =  1038; // 4054	hid_swm_1038_Fire_Genasi_NX1
				case APPEAR_TYPE_AIR_GENASI: { return 55;}//  =  1039; // 4055	hid_swm_1039_Air_Genasi_NX1
				case APPEAR_TYPE_WATER_GENASI: { return 56;}//  =  1040; // 4056	hid_swm_1040_Water_Genasi_NX1
				case APPEAR_TYPE_HALF_DROW: { return 57;}//  =  1041; // 4057	hid_swm_1041_Half_Drow_NX1
				case APPEAR_TYPE_HAGSPAWN_VAR1: { return 176;}//  =  1043; // 4176	hid_swm_1043_Hagspawn_Var1_NX1
				case APPEAR_TYPE_ORBAKH: { return 58;}//  =  1046; // 4058	hid_swm_1046_NPC_Orbakh
			}
			break;
			
		case 12:
			switch ( iAppearanceIndex )
			{
				
				case APPEAR_TYPE_REE_YUANTIF: { return 59;}//  =  1204; // 4059	hid_swm_1204_YuantiF_ree
				case APPEAR_TYPE_TELETUBBIE: { return 60;}//  =  1205; // 4060	hid_swm_1205_Teletubbie
				case APPEAR_TYPE_LEXIREE: { return 61;}//  =  1220;  // 4061	hid_swm_1220_NPC_Lexi_Ree
				case APPEAR_TYPE_SIMZAREE: { return 62;}//  =  1221; // 4062	hid_swm_1221_NPC_Simza_ree
				case APPEAR_TYPE_RENYIL: { return 63;}//  =  1299; // 4063	hid_swm_1299_ree_Renyil
			}
			break;
		
		case 14:
			switch ( iAppearanceIndex )
			{
				
				case APPEAR_TYPE_AZERBLOOD_ROF: { return 133;}//  =  1400; // 4133	hid_swm_1400_Azerblood_RoF
				case APPEAR_TYPE_FROSTBLOT_ROF: { return 64;}//  =  1401; // 4064	hid_swm_1401_Frostblot_RoF
				case APPEAR_TYPE_ELDBLOT_ROF: { return 134;}//  =  1402; // 4134	hid_swm_1402_Eldblot_RoF
				case APPEAR_TYPE_ARCTIC_DWARF_ROF: { return 135;}//  =  1403; // 4135	hid_swm_1403_Arctic_Dwarf_RoF
				case APPEAR_TYPE_WILD_DWARF_ROF: { return 136;}//  =  1404; // 4136	hid_swm_1404_Wild_Dwarf_RoF
				case APPEAR_TYPE_TANARUKK_ROF: { return 177;}//  =  1405; // 4177	hid_swm_1405_Tanarukk_RoF
				case APPEAR_TYPE_HOBGOBLIN_ROF: { return 178;}//  =  1407; // 4178	hid_swm_1407_Hobgoblin_RoF
				case APPEAR_TYPE_FOREST_GNOME_ROF: { return 159;}//  =  1409; // 4159	hid_swm_1409_Forest_Gnome_RoF
				case APPEAR_TYPE_DRAGONKIN_ROF: { return 65;}//  =  1415; // 4065	hid_swm_1415_Dragonkin_RoF
				case APPEAR_TYPE_CHAOND_ROF: { return 66;}//  =  1417; // 4066	hid_swm_1417_Chaond_RoF
				case APPEAR_TYPE_ELF_DUNE_ROF: { return 67;}//  =  1418; // 4067	hid_swm_1418_Elf_Dune_RoF
				case APPEAR_TYPE_BROWNIE_ROF: { return 68;}//  =  1419; // 4068	hid_swm_1419_Brownie_RoF
				case APPEAR_TYPE_ULDRA_ROF: { return 69;}//  =  1420; // 4069	hid_swm_1420_Uldra_RoF
				case APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF: { return 137;}//  =  1421; // 4137	hid_swm_1421_Half_Fiend,Durzagon_RoF
				case APPEAR_TYPE_ELF_POSCADAR_ROF: { return 70;}//  =  1422; // 4070	hid_swm_1422_Elf_Poscadar_RoF
				case APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF: { return 71;}//  =  1423; // 4071	hid_swm_1423_Human_Deep_Imaskari_RoF
				case APPEAR_TYPE_FIRBOLG_ROF: { return 72;}//  =  1424; // 4072	hid_swm_1424_Giant_Firbolg_RoF
				case APPEAR_TYPE_FOMORIAN_ROF: { return 73;}//  =  1425; // 4073	hid_swm_1425_Fomorian_RoF
				case APPEAR_TYPE_VERBEEG_ROF: { return 74;}//  =  1426; // 4074	hid_swm_1426_Verbeeg_RoF
				case APPEAR_TYPE_VOADKYN_ROF: { return 75;}//  =  1427; // 4075	hid_swm_1427_Voadkyn_RoF
				case APPEAR_TYPE_FJELLBLOT_ROF: { return 76;}//  =  1428; // 4076	hid_swm_1428_Fjellblot_RoF
				case APPEAR_TYPE_TAKEBLOT_ROF: { return 77;}//  =  1429; // 4077	hid_swm_1429_Takeblot_RoF
				case APPEAR_TYPE_AIR_MEPHLING_ROF: { return 78;}//  =  1430; // 4078	hid_swm_1430_Air_Mephling_RoF
				case APPEAR_TYPE_EARTH_MEPHLING_ROF: { return 79;}//  =  1431; // 4079	hid_swm_1431_Earth_Mephling_RoF
				case APPEAR_TYPE_FIRE_MEPHLING_ROF: { return 80;}//  =  1432; // 4080	hid_swm_1432_Fire_Mephling_RoF
				case APPEAR_TYPE_WATER_MEPHLING_ROF: { return 81;}//  =  1433; // 4081	hid_swm_1433_Water_Mephling_RoF
				case APPEAR_TYPE_OGRILLON_ROF: { return 179;}//  =  1438; // 4179	hid_swm_1438_Ogrillon_RoF
				case APPEAR_TYPE_KRINTH_ROF: { return 180;}//  =  1439; // 4180	hid_swm_1439_Krinth_RoF
				case APPEAR_TYPE_HALFLING_SANDSTORM_ROF: { return 82;}//  =  1440; // 4082	hid_swm_1440_Sandstorm_Halfling_RoF
				case APPEAR_TYPE_DWARF_DEGLOSIAN_ROF: { return 138;}//  =  1441; // 4138	hid_swm_1441_Dwarf_Deglosian_A2
				case APPEAR_TYPE_DWARF_GALDOSIAN_ROF: { return 139;}//  =  1442; // 4139	hid_swm_1442_Dwarf_Galdosian_A2
				case APPEAR_TYPE_ELF_ROF: { return 122;}//  =  1443; // 4122	hid_swm_1443_Elf_A2
				case APPEAR_TYPE_ELF_DRANGONARI_ROF: { return 83;}//  =  1444; // 4083	hid_swm_1444_Elf_Drangonari_A2
				case APPEAR_TYPE_ELF_GHOST_ROF: { return 84;}//  =  1445; // 4084	hid_swm_1445_Elf_Ghost_A2
				case APPEAR_TYPE_FAERIE_ROF: { return 85;}//  =  1446; // 4085	hid_swm_1446_Faerie_A2
				case APPEAR_TYPE_GNOME_ROF: { return 160;}//  =  1447; // 4160	hid_swm_1447_Gnome_A2
				case APPEAR_TYPE_GOBLIN_ROF: { return 161;}//  =  1448; // 4161	hid_swm_1448_Goblin_A2
				case APPEAR_TYPE_HALF_ELF_ROF: { return 86;}//  =  1449; // 4086	hid_swm_1449_Half_Elf_A2
				case APPEAR_TYPE_HALF_ORC_ROF: { return 181;}//  =  1450; // 4181	hid_swm_1450_Half_Orc_A2
				case APPEAR_TYPE_HALFLING_ROF: { return 87;}//  =  1451; // 4087	hid_swm_1451_Halfling_A2
				case APPEAR_TYPE_HUMAN_ROF: { return 88;}//  =  1452; // 4088	hid_swm_1452_Human_A2
				case APPEAR_TYPE_OROG_ROF: { return 182;}//  =  1453; // 4182	hid_swm_1453_Orog_RoF
				case APPEAR_TYPE_AELFBORN_ROF: { return 89;}//  =  1454; // 4089	hid_swm_1454_Aelfborn_RoF
				case APPEAR_TYPE_FEYRI_ROF: { return 90;}//  =  1455; // 4090	hid_swm_1455_Feyri_RoF
				case APPEAR_TYPE_SEWER_GOBLIN_ROF: { return 162;}//  =  1456; // 4162	hid_swm_1456_Sewer_Goblin_RoF
				case APPEAR_TYPE_WOOD_GENASI_ROF: { return 91;}//  =  1457; // 4091	hid_swm_1457_Wood_Genasi_RoF
				case APPEAR_TYPE_HALF_CELESTIAL_ROF: { return 92;}//  =  1458; // 4092	hid_swm_1458_Half-Celestial_RoF
				case APPEAR_TYPE_DERRO_ROF: { return 163;}//  =  1459; // 4163	hid_swm_1459_Derro_RoF
				case APPEAR_TYPE_HALF_OGRE_ROF: { return 183;}//  =  1460; // 4183	hid_swm_1460_Half_Ogre_RoF
				case APPEAR_TYPE_DRAGONBORN_ROF: { return 93;}//  =  1461; // 4093	hid_swm_1461_Dragonborn_RoF
				case APPEAR_TYPE_CELADRIN_ROF: { return 94;}//  =  1463; // 4094	hid_swm_1463_Celadrin_RoF
			}
			break;
		
		case 15:
			if ( iAppearanceIndex == APPEAR_TYPE_ROBOT ) { return 95;}//  =  1561; // 4095	hid_swm_1561_Robot
			break;
		
		case 23:
			if ( iAppearanceIndex == APPEAR_TYPE_KUO_TOA ) { return 194;}//  =  2328; // 4194	hid_swm_2328_Kuoa_Toa
			if ( iAppearanceIndex == APPEAR_TYPE_SAHUAGIN ) { return 195;}//  =  2329;// 4195	hid_swm_2329_Sahuagin
			break;
		
		case 30:
			switch ( iAppearanceIndex )
			{
				case APPEAR_TYPE_GIANT_HILL: { return 96;}//  =  3000; // 4096	hid_swm_3000_Giant_Hill
				case APPEAR_TYPE_GIANT_STONE: { return 97;}//  =  3001; // 4097	hid_swm_3001_Giant_Stone
				case APPEAR_TYPE_GIANT_FIRE_ALT: { return 140;}//  =  3002; // 4140	hid_swm_3002_Giant_Fire
				case APPEAR_TYPE_GIANT_FROST_ALT: { return 98;}//  =  3003; // 4098	hid_swm_3003_Giant_Frost
				case APPEAR_TYPE_GIANT_CLOUD: { return 99;}//  =  3004; // 4099	hid_swm_3004_Giant_Cloud
				case APPEAR_TYPE_GIANT_FOREST: { return 123;}//  =  3005; // 4123	hid_swm_3005_Giant_Forest
				case APPEAR_TYPE_GIANT_STORM: { return 100;}//  =  3006; // 4100	hid_swm_3006_Giant_Storm
			}
			break;
			
		case 31:
			if ( iAppearanceIndex == APPEAR_TYPE_DRAGONMAN ) { return 101;}//  =  3100; // 4101	hid_swm_3100_Dragonman
			break;
		
		case 34:
			if ( iAppearanceIndex == APPEAR_TYPE_EFREETI ) { return 184;}//  =  3400; // 4184	hid_swm_3400_Efreeti
			break; 		
 	}
	
	return -1;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAppearanceByAnimateOffset( int iAnimateOffset )
{
	int iSubOffset = iAnimateOffset / 10;
	
	switch( iSubOffset )
	{
		 // hid_HH_HUMANS
		case 0:
			switch ( iAnimateOffset )
			{
				case 1: { return APPEAR_TYPE_HALFLING;}//  =  3; // 4001	hid_swm_3_Halfling
				case 2: { return APPEAR_TYPE_HALF_ELF;}//  =  4; // 4002	hid_swm_4_Half_Elf
				case 3: { return APPEAR_TYPE_HUMAN;}//  =  6; // 4003	hid_swm_6_Human
				case 4: { return APPEAR_TYPE_PLANETAR;}//  =  26; // 4004	hid_swm_26_Planetar
				case 5: { return APPEAR_TYPE_LICH;}//  =  39; // 4005	hid_swm_39_Lich
				case 6: { return APPEAR_TYPE_YUANTIPUREBLOOD;}//  =  40; // 4006	hid_swm_40_Yuanti_Pureblood
				case 7: { return APPEAR_TYPE_NPC_SASANI;}//  =  47; // 4007	hid_swm_47_NPC_Sasani_NX2
				case 8: { return APPEAR_TYPE_NPC_VOLO;}//  =  48; // 4008	hid_swm_48_NPC_Volo_NX2
				case 9: { return APPEAR_TYPE_NPC_SEPTIMUND;}//  =  50; // 4009	hid_swm_50_NPC_Septimund_NX2
			}
			break;
		
		case 1:
			switch ( iAnimateOffset )
			{
				case 10: { return APPEAR_TYPE_DRYAD;}//  =  51; // 4010	hid_swm_51_Dryad
				case 11: { return APPEAR_TYPE_VAMPIRE_FEMALE;}//  =  288; // 4011	hid_swm_288_Vampire_Female_Male -- note removing 		case APPEAR_TYPE_VAMPIRE_MALE: { return -1;}//  =  289; since it can use the sex to do the same thing
				case 12: { return APPEAR_TYPE_GITHYANKI;}//  =  483; // 4012	hid_swm_483_Githyanki
				case 13: { return APPEAR_TYPE_DEVIL_ERINYES;}//  =  514; // 4013	hid_swm_514_Devil_Erinyes
				case 14: { return APPEAR_TYPE_SKELETON;}//  =  537; // 4014	hid_swm_537_Skeleton
				case 15: { return APPEAR_TYPE_NPC_GARIUS;}//  =  544; // 4015	hid_swm_544_NPC_Garius
				case 16: { return APPEAR_TYPE_NPC_DUNCAN;}//  =  549; // 4016	hid_swm_549_NPC_Duncan
				case 17: { return APPEAR_TYPE_NPC_LORDNASHER;}//  =  550; // 4017	hid_swm_550_NPC_LordNasher
				case 18: { return APPEAR_TYPE_ASSIMAR;}//  =  563; // 4018	hid_swm_563_Assimar
				case 19: { return APPEAR_TYPE_TIEFLING;}//  =  564; // 4019	hid_swm_564_Tiefling
			}
			break;
		
		case 2:
			switch ( iAnimateOffset )
			{
				case 20: { return APPEAR_TYPE_ELF_SUN;}//  =  565; // 4020	hid_swm_565_Elf_Sun
				case 21: { return APPEAR_TYPE_ELF_WOOD;}//  =  566; // 4021	hid_swm_566_Elf_Wood
				case 22: { return APPEAR_TYPE_ELF_DROW;}//  =  567; // 4022	hid_swm_567_Elf_Drow
				case 23: { return APPEAR_TYPE_HALFLING_STRONGHEART;}//  =  571; // 4023	hid_swm_571_Halfling_Strongheart
				case 24: { return APPEAR_TYPE_NPC_GITHCAPTAIN;}//  =  579; // 4024	hid_swm_579_NPC_GithCaptain
				case 25: { return APPEAR_TYPE_NPC_LORNE;}//  =  580; // 4025	hid_swm_580_NPC_Lorne
				case 26: { return APPEAR_TYPE_NPC_TENAVROK;}//  =  581; // 4026	hid_swm_581_NPC_Tenavrok
				case 27: { return APPEAR_TYPE_NPC_CTANN;}//  =  582; // 4027	hid_swm_582_NPC_Ctann
				case 28: { return APPEAR_TYPE_NPC_SHANDRA;}//  =  583; // 4028	hid_swm_583_NPC_Shandra
				case 29: { return APPEAR_TYPE_NPC_ZEEAIRE;}//  =  584; // 4029	hid_swm_584_NPC_Zeeaire
			}
			break;
		
		case 3:
			switch ( iAnimateOffset )
			{
				case 30: { return APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT;}//  =  585; // 4030	hid_swm_585_NPC_Zeeaires_Lieutenant
				case 31: { return APPEAR_TYPE_NPC_ZHJAEVE;}//  =  588; // 4031	hid_swm_588_NPC_Zhjaeve
				case 32: { return APPEAR_TYPE_NPC_AHJA;}//  =  590; // 4032	hid_swm_590_NPC_Ahja
				case 33: { return APPEAR_TYPE_NPC_HEZEBEL;}//  =  592; // 4033	hid_swm_592_NPC_Hezebel
				case 34: { return APPEAR_TYPE_NPC_ZOKAN;}//  =  594; // 4034	hid_swm_594_NPC_Zokan
				case 35: { return APPEAR_TYPE_NPC_ALDANON;}//  =  595; // 4035	hid_swm_595_NPC_Aldanon
				case 36: { return APPEAR_TYPE_NPC_JACOBY;}//  =  596; // 4036	hid_swm_596_NPC_Jacoby
				case 37: { return APPEAR_TYPE_NPC_JALBOUN;}//  =  597; // 4037	hid_swm_597_NPC_Jalboun
				case 38: { return APPEAR_TYPE_NPC_KHRALVER;}//  =  598; // 4038	hid_swm_598_NPC_Khralver
				case 39: { return APPEAR_TYPE_NPC_KRALWOK;}//  =  599; // 4039	hid_swm_599_NPC_Kralwok
			}
			break;
		
		case 4:
			switch ( iAnimateOffset )
			{
				case 40: { return APPEAR_TYPE_NPC_MEPHASM;}//  =  600; // 4040	hid_swm_600_NPC_Mephasm
				case 41: { return APPEAR_TYPE_NPC_MORKAI;}//  =  601; // 4041	hid_swm_601_NPC_Morkai
				case 42: { return APPEAR_TYPE_NPC_SARYA;}//  =  602; // 4042	hid_swm_602_NPC_Sarya
				case 43: { return APPEAR_TYPE_NPC_SYDNEY;}//  =  603; // 4043	hid_swm_603_NPC_Sydney
				case 44: { return APPEAR_TYPE_NPC_TORIOCLAVEN;}//  =  604; // 4044	hid_swm_604_NPC_TorioClaven
				case 45: { return APPEAR_TYPE_NPC_SHADOWPRIEST;}//  =  606; // 4045	hid_swm_606_NPC_ShadowPriest
				case 46: { return APPEAR_TYPE_AKACHI;}//  =  1000; // 4046	hid_swm_1000_Akachi_NX1
				case 47: { return APPEAR_TYPE_RED_WIZ_COMPANION;}//  =  1007; // 4047	hid_swm_1007_Red_Wiz_Companion_NX1
				case 48: { return APPEAR_TYPE_DEATH_KNIGHT;}//  =  1008; // 4048	hid_swm_1008_Death_Knight_NX1
				case 49: { return APPEAR_TYPE_SOLAR;}//  =  1013; // 4049	hid_swm_1013_Solar_NX1
			}
			break;
		
		case 5:
			switch ( iAnimateOffset )
			{
				case 50: { return APPEAR_TYPE_MAGDA;}//  =  1034; // 4050	hid_swm_1034_Magda_NX1
				case 51: { return APPEAR_TYPE_NEFRIS;}//  =  1035; // 4051	hid_swm_1035_Nefris_NX1
				case 52: { return APPEAR_TYPE_ELF_WILD;}//  =  1036; // 4052	hid_swm_1036_Elf_Wild_NX1
				case 53: { return APPEAR_TYPE_EARTH_GENASI;}//  =  1037; // 4053	hid_swm_1037_Earth_Genasi_NX1
				case 54: { return APPEAR_TYPE_FIRE_GENASI;}//  =  1038; // 4054	hid_swm_1038_Fire_Genasi_NX1
				case 55: { return APPEAR_TYPE_AIR_GENASI;}//  =  1039; // 4055	hid_swm_1039_Air_Genasi_NX1
				case 56: { return APPEAR_TYPE_WATER_GENASI;}//  =  1040; // 4056	hid_swm_1040_Water_Genasi_NX1
				case 57: { return APPEAR_TYPE_HALF_DROW;}//  =  1041; // 4057	hid_swm_1041_Half_Drow_NX1
				case 58: { return APPEAR_TYPE_ORBAKH;}//  =  1046; // 4058	hid_swm_1046_NPC_Orbakh
				case 59: { return APPEAR_TYPE_REE_YUANTIF;}//  =  1204; // 4059	hid_swm_1204_YuantiF_ree
			}
			break;
		
		case 6:
			switch ( iAnimateOffset )
			{
				case 60: { return APPEAR_TYPE_TELETUBBIE;}//  =  1205; // 4060	hid_swm_1205_Teletubbie
				case 61: { return APPEAR_TYPE_LEXIREE;}//  =  1220;  // 4061	hid_swm_1220_NPC_Lexi_Ree
				case 62: { return APPEAR_TYPE_SIMZAREE;}//  =  1221; // 4062	hid_swm_1221_NPC_Simza_ree
				case 63: { return APPEAR_TYPE_RENYIL;}//  =  1299; // 4063	hid_swm_1299_ree_Renyil
				case 64: { return APPEAR_TYPE_FROSTBLOT_ROF;}//  =  1401; // 4064	hid_swm_1401_Frostblot_RoF
				case 65: { return APPEAR_TYPE_DRAGONKIN_ROF;}//  =  1415; // 4065	hid_swm_1415_Dragonkin_RoF
				case 66: { return APPEAR_TYPE_CHAOND_ROF;}//  =  1417; // 4066	hid_swm_1417_Chaond_RoF
				case 67: { return APPEAR_TYPE_ELF_DUNE_ROF;}//  =  1418; // 4067	hid_swm_1418_Elf_Dune_RoF
				case 68: { return APPEAR_TYPE_BROWNIE_ROF;}//  =  1419; // 4068	hid_swm_1419_Brownie_RoF
				case 69: { return APPEAR_TYPE_ULDRA_ROF;}//  =  1420; // 4069	hid_swm_1420_Uldra_RoF
			}
			break;
		
		case 7:
			switch ( iAnimateOffset )
			{
				case 70: { return APPEAR_TYPE_ELF_POSCADAR_ROF;}//  =  1422; // 4070	hid_swm_1422_Elf_Poscadar_RoF
				case 71: { return APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF;}//  =  1423; // 4071	hid_swm_1423_Human_Deep_Imaskari_RoF
				case 72: { return APPEAR_TYPE_FIRBOLG_ROF;}//  =  1424; // 4072	hid_swm_1424_Giant_Firbolg_RoF
				case 73: { return APPEAR_TYPE_FOMORIAN_ROF;}//  =  1425; // 4073	hid_swm_1425_Fomorian_RoF
				case 74: { return APPEAR_TYPE_VERBEEG_ROF;}//  =  1426; // 4074	hid_swm_1426_Verbeeg_RoF
				case 75: { return APPEAR_TYPE_VOADKYN_ROF;}//  =  1427; // 4075	hid_swm_1427_Voadkyn_RoF
				case 76: { return APPEAR_TYPE_FJELLBLOT_ROF;}//  =  1428; // 4076	hid_swm_1428_Fjellblot_RoF
				case 77: { return APPEAR_TYPE_TAKEBLOT_ROF;}//  =  1429; // 4077	hid_swm_1429_Takeblot_RoF
				case 78: { return APPEAR_TYPE_AIR_MEPHLING_ROF;}//  =  1430; // 4078	hid_swm_1430_Air_Mephling_RoF
				case 79: { return APPEAR_TYPE_EARTH_MEPHLING_ROF;}//  =  1431; // 4079	hid_swm_1431_Earth_Mephling_RoF
			}
			break;
		
		case 8:
			switch ( iAnimateOffset )
			{
				case 80: { return APPEAR_TYPE_FIRE_MEPHLING_ROF;}//  =  1432; // 4080	hid_swm_1432_Fire_Mephling_RoF
				case 81: { return APPEAR_TYPE_WATER_MEPHLING_ROF;}//  =  1433; // 4081	hid_swm_1433_Water_Mephling_RoF
				case 82: { return APPEAR_TYPE_HALFLING_SANDSTORM_ROF;}//  =  1440; // 4082	hid_swm_1440_Sandstorm_Halfling_RoF
				case 83: { return APPEAR_TYPE_ELF_DRANGONARI_ROF;}//  =  1444; // 4083	hid_swm_1444_Elf_Drangonari_A2
				case 84: { return APPEAR_TYPE_ELF_GHOST_ROF;}//  =  1445; // 4084	hid_swm_1445_Elf_Ghost_A2
				case 85: { return APPEAR_TYPE_FAERIE_ROF;}//  =  1446; // 4085	hid_swm_1446_Faerie_A2
				case 86: { return APPEAR_TYPE_HALF_ELF_ROF;}//  =  1449; // 4086	hid_swm_1449_Half_Elf_A2
				case 87: { return APPEAR_TYPE_HALFLING_ROF;}//  =  1451; // 4087	hid_swm_1451_Halfling_A2
				case 88: { return APPEAR_TYPE_HUMAN_ROF;}//  =  1452; // 4088	hid_swm_1452_Human_A2
				case 89: { return APPEAR_TYPE_AELFBORN_ROF;}//  =  1454; // 4089	hid_swm_1454_Aelfborn_RoF
			}
			break;
		
		case 9:
			switch ( iAnimateOffset )
			{
				case 90: { return APPEAR_TYPE_FEYRI_ROF;}//  =  1455; // 4090	hid_swm_1455_Feyri_RoF
				case 91: { return APPEAR_TYPE_WOOD_GENASI_ROF;}//  =  1457; // 4091	hid_swm_1457_Wood_Genasi_RoF
				case 92: { return APPEAR_TYPE_HALF_CELESTIAL_ROF;}//  =  1458; // 4092	hid_swm_1458_Half-Celestial_RoF
				case 93: { return APPEAR_TYPE_DRAGONBORN_ROF;}//  =  1461; // 4093	hid_swm_1461_Dragonborn_RoF
				case 94: { return APPEAR_TYPE_CELADRIN_ROF;}//  =  1463; // 4094	hid_swm_1463_Celadrin_RoF
				case 95: { return APPEAR_TYPE_ROBOT;}//  =  1561; // 4095	hid_swm_1561_Robot
				case 96: { return APPEAR_TYPE_GIANT_HILL;}//  =  3000; // 4096	hid_swm_3000_Giant_Hill
				case 97: { return APPEAR_TYPE_GIANT_STONE;}//  =  3001; // 4097	hid_swm_3001_Giant_Stone
				case 98: { return APPEAR_TYPE_GIANT_FROST_ALT;}//  =  3003; // 4098	hid_swm_3003_Giant_Frost
				case 99: { return APPEAR_TYPE_GIANT_CLOUD;}//  =  3004; // 4099	hid_swm_3004_Giant_Cloud
			}
			break;
		
		case 10:
			if ( iAnimateOffset == 100 ) { return APPEAR_TYPE_GIANT_STORM;}//  =  3006; // 4100	hid_swm_3006_Giant_Storm
			if ( iAnimateOffset == 101 ) { return APPEAR_TYPE_DRAGONMAN;}//  =  3100; // 4101	hid_swm_3100_Dragonman
			break;
		
		case 12:
			switch ( iAnimateOffset )
			{
				case 121: { return APPEAR_TYPE_ELF;}//  =  1; // 4121	hid_swm_1_Elf
				case 122: { return APPEAR_TYPE_ELF_ROF;}//  =  1443; // 4122	hid_swm_1443_Elf_A2
				case 123: { return APPEAR_TYPE_GIANT_FOREST;}//  =  3005; // 4123	hid_swm_3005_Giant_Forest
			}
			break;
		
		case 13:
			switch ( iAnimateOffset )
			{
				case 130: { return APPEAR_TYPE_DWARF;}//  =  0; // 4130	hid_swm_0_Dwarf
				case 131: { return APPEAR_TYPE_DWARF_GOLD;}//  =  569; // 4131	hid_swm_569_Dwarf_Gold
				case 132: { return APPEAR_TYPE_DWARF_DUERGAR;}//  =  570; // 4132	hid_swm_570_Dwarf,Duergar
				case 133: { return APPEAR_TYPE_AZERBLOOD_ROF;}//  =  1400; // 4133	hid_swm_1400_Azerblood_RoF
				case 134: { return APPEAR_TYPE_ELDBLOT_ROF;}//  =  1402; // 4134	hid_swm_1402_Eldblot_RoF
				case 135: { return APPEAR_TYPE_ARCTIC_DWARF_ROF;}//  =  1403; // 4135	hid_swm_1403_Arctic_Dwarf_RoF
				case 136: { return APPEAR_TYPE_WILD_DWARF_ROF;}//  =  1404; // 4136	hid_swm_1404_Wild_Dwarf_RoF
				case 137: { return APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF;}//  =  1421; // 4137	hid_swm_1421_Half_Fiend,Durzagon_RoF
				case 138: { return APPEAR_TYPE_DWARF_DEGLOSIAN_ROF;}//  =  1441; // 4138	hid_swm_1441_Dwarf_Deglosian_A2
				case 139: { return APPEAR_TYPE_DWARF_GALDOSIAN_ROF;}//  =  1442; // 4139	hid_swm_1442_Dwarf_Galdosian_A2
			}
			break;
		
		case 14:
			if ( iAnimateOffset == 140 ) { return APPEAR_TYPE_GIANT_FIRE_ALT; } //  =  3002; // 4140	hid_swm_3002_Giant_Fire
			break;
		
		case 15:
			switch ( iAnimateOffset )
			{
				case 155: { return APPEAR_TYPE_GNOME;} //  =  2; // 4155	hid_swm_2_Gnome
				case 156: { return APPEAR_TYPE_NPC_CHILDHHM;} //  =  551; // 4156	hid_swm_551_NPC_ChildHHM
				case 157: { return APPEAR_TYPE_NPC_CHILDHHF;} //  =  553; // 4157	hid_swm_553_NPC_ChildHHF
				case 158: { return APPEAR_TYPE_GNOME_SVIRFNEBLIN;} //  =  568; // 4158	hid_swm_568_Gnome_Svirfneblin
				case 159: { return APPEAR_TYPE_FOREST_GNOME_ROF;} //  =  1409; // 4159	hid_swm_1409_Forest_Gnome_RoF
			}
			break;
		
		case 16:
			switch ( iAnimateOffset )
			{
				case 160: { return APPEAR_TYPE_GNOME_ROF;}//  =  1447; // 4160	hid_swm_1447_Gnome_A2
				case 161: { return APPEAR_TYPE_GOBLIN_ROF;}//  =  1448; // 4161	hid_swm_1448_Goblin_A2
				case 162: { return APPEAR_TYPE_SEWER_GOBLIN_ROF;}//  =  1456; // 4162	hid_swm_1456_Sewer_Goblin_RoF
				case 163: { return APPEAR_TYPE_DERRO_ROF;}//  =  1459; // 4163	hid_swm_1459_Derro_RoF
			}
			break;
		
		case 17:
			switch ( iAnimateOffset )
			{
				case 173: { return APPEAR_TYPE_HALF_ORC;}//  =  5; // 4173	hid_swm_5_Half_Orc
				case 174: { return APPEAR_TYPE_GRAYORC;}//  =  45; // 4174	hid_swm_45_GrayOrc
				case 175: { return APPEAR_TYPE_NPC_UTHANCK;}//  =  605; // 4175	hid_swm_605_NPC_Uthanck
				case 176: { return APPEAR_TYPE_HAGSPAWN_VAR1;}//  =  1043; // 4176	hid_swm_1043_Hagspawn_Var1_NX1
				case 177: { return APPEAR_TYPE_TANARUKK_ROF;}//  =  1405; // 4177	hid_swm_1405_Tanarukk_RoF
				case 178: { return APPEAR_TYPE_HOBGOBLIN_ROF;}//  =  1407; // 4178	hid_swm_1407_Hobgoblin_RoF
				case 179: { return APPEAR_TYPE_OGRILLON_ROF;}//  =  1438; // 4179	hid_swm_1438_Ogrillon_RoF
			}
			break;
		
		case 18:
			switch ( iAnimateOffset )
			{
				case 180: { return APPEAR_TYPE_KRINTH_ROF;}//  =  1439; // 4180	hid_swm_1439_Krinth_RoF
				case 181: { return APPEAR_TYPE_HALF_ORC_ROF;}//  =  1450; // 4181	hid_swm_1450_Half_Orc_A2
				case 182: { return APPEAR_TYPE_OROG_ROF;}//  =  1453; // 4182	hid_swm_1453_Orog_RoF
				case 183: { return APPEAR_TYPE_HALF_OGRE_ROF;}//  =  1460; // 4183	hid_swm_1460_Half_Ogre_RoF
				case 184: { return APPEAR_TYPE_EFREETI;}//  =  3400; // 4184	hid_swm_3400_Efreeti
			}
			break;
		
		case 19:
			if ( iAnimateOffset == 194 ) { return APPEAR_TYPE_KUO_TOA;}//  =  2328; // 4194	hid_swm_2328_Kuoa_Toa
			if ( iAnimateOffset == 195 ) { return APPEAR_TYPE_SAHUAGIN;}//  =  2329;// 4195	hid_swm_2329_Sahuagin
			break;
 		}
	
	return -1;
}




/**  
* @author
* @param 
* @see 
* @return 
*/
// * gets the correct appearance for those who are using one of the fake appearance constants
// * only need to use if the appearance is not saved on the creature, like if they log out and come back on
int CSLGetBaseAppearance( int iAppearance ) 
{
	if ( iAppearance < 3600 ) // nothing below this is using an changed animation, only one above which really should not be used for anything
	{
		return iAppearance;
	}
	
	//int iOverrideStart = (iAppearance/200)*200;
	
	//object oTable = CSLDataObjectGet( "anim_modes" );
	
	int iOverride = CSLGetAnimationOverrideByAppearance( iAppearance );
	
	
	//int iRow = CSLDataTableGetRowByIndex( oTable, iOverride );
	
	if ( iOverride == -1 ) // not an active override, so just return the appearance
	{
		return iAppearance;
	}
	
	int iStartOffset = CSLGetAnimationStartOffsetByAppearance( iAppearance );
	
	int iCurrentAppearanceOffset = iAppearance - iStartOffset;
		
	int iNewAppearance = CSLGetAppearanceByAnimateOffset( iCurrentAppearanceOffset );
	if ( iNewAppearance != -1 )
	{
		iAppearance = iNewAppearance;
	}
	return iAppearance;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAnimateOverride( object oTarget )
{
	// repeat for each ANIMATEOVERRIDE
	int iAppearance = GetAppearanceType(oTarget);
	
	if ( iAppearance < 3600 ) // all overrides are above 3600 this is a safety
	{
		return CSL_ANIMATEOVERRIDE_NONE;
	}
	
	return CSLGetAnimationOverrideByAppearance( iAppearance );
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// stores the players original appearance, need to make this persistent
string CSLStoreTrueAppearance( object oPC = OBJECT_SELF, int bForceSettingCurrent = FALSE )
{
	// store previous appearance for safety
	string sAppear = GetLocalString(oPC, "CSL_TRUEAPPEARANCE");
	if ( sAppear == "" || bForceSettingCurrent )//if original appearance has not been stored, need to make sure this is done when not polymorphed
	{
		//sAppear = CSLGetPersistentString(oTarget, "CSL_TRUEAPPEARANCE");
		//if (sAppear = "" || bForceSettingCurrent )
		//{
			// need to add a check for effects like polymorph
			sAppear = CSLSerializeAppearance(oPC);
			SetLocalString(oPC, "CSL_TRUEAPPEARANCE", sAppear);
		//	CSLSetPersistentString(oTarget, "CSL_TRUEAPPEARANCE", sAppear);
		//}
		//else
		//{
		//	SetLocalString(oTarget, "CSL_TRUEAPPEARANCE", sAppear);
		//}
	}
	return sAppear;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAnimateOverrideAppearance( int iAppearance, int iAnimateOveride = CSL_ANIMATEOVERRIDE_NONE ) 
{	
	int iAppearanceOffset = CSLGetAnimateOffsetByAppearance( CSLGetBaseAppearance(iAppearance) );
	
	if ( iAppearanceOffset == -1 )
	{
		return iAppearance;
	}
	
	
	int iStartOffset = CSLGetAnimationStartOffsetByOverride( iAnimateOveride );
	
	//SendMessageToPC( GetFirstPC(), "CSLGetAnimateOverrideAppearance iAppearance="+IntToString(iAppearance)+" iAnimateOveride="+IntToString(iAnimateOveride)+"  iAppearanceOffset="+IntToString(iAppearanceOffset)+"  iStartOffset="+IntToString(iStartOffset)+"  which total as and returns "+IntToString(iStartOffset + iAppearanceOffset) );
	
	if ( iStartOffset  > -1 )
	{
		return iStartOffset + iAppearanceOffset;
	}
	/*
	// repeat for each CSL_ANIMATEOVERRIDE_* constant
	if ( iAnimateOveride == CSL_ANIMATEOVERRIDE_SWIMMING )
	{
		iAppearance = CSL_ANIMATERANGESTART_SWIMMING + iAppearanceOffset;
	}
	else if ( iAnimateOveride == CSL_ANIMATEOVERRIDE_LEVITATE )
	{
		iAppearance = CSL_ANIMATERANGESTART_LEVITATE + iAppearanceOffset;
	}
	else if ( iAnimateOveride == CSL_ANIMATEOVERRIDE_FLY )
	{
		iAppearance = CSL_ANIMATERANGESTART_FLY + iAppearanceOffset;
	}
	else if ( iAnimateOveride == CSL_ANIMATEOVERRIDE_CRAWL )
	{
		iAppearance = CSL_ANIMATERANGESTART_CRAWL + iAppearanceOffset;
	}
	else if ( iAnimateOveride == CSL_ANIMATEOVERRIDE_CLIMB )
	{
		iAppearance = CSL_ANIMATERANGESTART_CLIMB + iAppearanceOffset;
	}
	else if ( iAnimateOveride == CSL_ANIMATEOVERRIDE_MALE )
	{
		iAppearance = CSL_ANIMATERANGESTART_MALE + iAppearanceOffset;
	}
	else if ( iAnimateOveride == CSL_ANIMATEOVERRIDE_FEMALE )
	{
		iAppearance = CSL_ANIMATERANGESTART_FEMALE + iAppearanceOffset;
	}
	*/

	return iAppearance;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLAnimationOverride( object oTarget, int iAnimateOveride = CSL_ANIMATEOVERRIDE_NONE )
{
	// store original appearance if it's not been done yet
	int iAppearance = GetAppearanceType(oTarget);
	int iNewAppearance = iAppearance;
	string sScript;
	// store previous appearance for safety
	CSLStoreTrueAppearance( oTarget );
	
	if ( iAnimateOveride == CSL_ANIMATEOVERRIDE_NONE )
	{
		iNewAppearance = CSLGetBaseAppearance( iAppearance );
		SetLocalInt( oTarget, "CSL_ANIMATEOVERRIDE", FALSE);
		
		sScript = CSLGetAnimationStopScriptByOverride( CSLGetAnimationOverrideByAppearance( iAppearance ) );
		
	}
	else
	{
		sScript = CSLGetAnimationStartScriptByOverride( iAnimateOveride );
		iNewAppearance = CSLGetAnimateOverrideAppearance( iAppearance, iAnimateOveride );
		SetLocalInt( oTarget, "CSL_ANIMATEOVERRIDE", TRUE);
		
		// SendMessageToPC( GetFirstPC(), "Applying animation override "+IntToString(iAppearance) );
	}
	if ( iNewAppearance != iAppearance )
	{
		if ( sScript != "" )
		{
			ExecuteScript( sScript, oTarget );
		}
		SetCreatureAppearanceType( oTarget, iNewAppearance );
	}
}






/**  
* @author
* @param 
* @see 
* @return 
*/
// * This Gets an appearance constant for a given index
// * used for iterating all the constants, or getting a random constant
/*
int CSLGetAppearanceByIndex( int iAppearanceIndex )
{
	//int iAppearanceType = GetAppearanceType(oTarget);
	if ( iAppearanceIndex == -1 ) { return -1; }
	
	
	//int iAppearanceType = GetAppearanceType(oTarget);
	//if ( iAppearanceType == -1 ) { return 0.0f; }
	
	int iSubAppearance = iAppearanceIndex / 20;
	switch(iSubAppearance)
	{
		case 0:
			switch ( iAppearanceIndex )
			{
				case 0: { return APPEAR_TYPE_DWARF;} //0
				case 1: { return APPEAR_TYPE_ELF;} //1
				case 2: { return APPEAR_TYPE_GNOME;} //2
				case 3: { return APPEAR_TYPE_HALFLING;} //3
				case 4: { return APPEAR_TYPE_HALF_ELF;} //4
				case 5: { return APPEAR_TYPE_HALF_ORC;} //5
				case 6: { return APPEAR_TYPE_HUMAN;} //6
				case 7: { return APPEAR_TYPE_HORSE_BROWN;} //7
				case 8: { return APPEAR_TYPE_BADGER;} //8
				case 9: { return APPEAR_TYPE_BADGER_DIRE;} //9
				case 10: { return APPEAR_TYPE_BAT;} //10
				case 11: { return APPEAR_TYPE_HORSE_PINTO;} //11
				case 12: { return APPEAR_TYPE_HORSE_SKELETAL;} //12
				case 13: { return APPEAR_TYPE_BEAR_BROWN;} //13
				case 14: { return APPEAR_TYPE_HORSE_PALOMINO;} //14
				case 15: { return APPEAR_TYPE_BEAR_DIRE;} //15
				case 16: { return APPEAR_TYPE_DRAGON__BRONZE;} //16
				case 17: { return APPEAR_TYPE_YOUNG_BRONZE;} //17
				case 18: { return APPEAR_TYPE_BEETLE_FIRE;} //18
				case 19: { return APPEAR_TYPE_BEETLE_STAG;} //19
			}
			break;
		case 1:
			switch ( iAppearanceIndex )
			{				
				case 20: { return APPEAR_TYPE_YOUNG_BLUE;} //20
				case 21: { return APPEAR_TYPE_BOAR;} //21
				case 22: { return APPEAR_TYPE_BOAR_DIRE;} //22
				case 23: { return APPEAR_TYPE_YUANTI_ABOMINATION;} //23
				case 24: { return APPEAR_TYPE_WORG;} //24
				case 25: { return APPEAR_TYPE_YUANTI_HOLYGUARDIAN;} //25
				case 26: { return APPEAR_TYPE_PLANETAR;} //26
				case 27: { return APPEAR_TYPE_WILLOWISP;} //27
				case 28: { return APPEAR_TYPE_FIRE_NEWT;} //28
				case 29: { return APPEAR_TYPE_DROWNED;} //29
				case 30: { return APPEAR_TYPE_MEGARAPTOR;} //30
				case 31: { return APPEAR_TYPE_CHICKEN;} //31
				case 32: { return APPEAR_TYPE_WIGHT;} //32
				case 33: { return APPEAR_TYPE_CLOCKROACH;} //33
				case 34: { return APPEAR_TYPE_COW;} //34
				case 35: { return APPEAR_TYPE_DEER;} //35
				case 36: { return APPEAR_TYPE_DEINONYCHUS;} //36
				case 37: { return APPEAR_TYPE_DEER_STAG;} //37
				case 38: { return APPEAR_TYPE_BATIRI;} //38
				case 39: { return APPEAR_TYPE_LICH;} //39
			}
			break;
		case 2:
			switch ( iAppearanceIndex )
			{
				
				case 40: { return APPEAR_TYPE_YUANTIPUREBLOOD;} //40
				case 41: { return APPEAR_TYPE_DRAGON_BLACK;} //41
				case 42: { return APPEAR_TYPE_WAGON_LIGHT01;} //42
				case 43: { return APPEAR_TYPE_WAGON_LIGHT02;} //43
				case 44: { return APPEAR_TYPE_WAGON_LIGHT03;} //44
				case 45: { return APPEAR_TYPE_GRAYORC;} //45
				case 46: { return APPEAR_TYPE_YUANTI_HERALD;} //46
				case 47: { return APPEAR_TYPE_NPC_SASANI;} //47
				case 48: { return APPEAR_TYPE_NPC_VOLO;} //48
				case 49: { return APPEAR_TYPE_DRAGON_RED;} //49
				case 50: { return APPEAR_TYPE_NPC_SEPTIMUND;} //50
				case 51: { return APPEAR_TYPE_DRYAD;} //51
				case 52: { return APPEAR_TYPE_ELEMENTAL_AIR;} //52
				case 53: { return APPEAR_TYPE_ELEMENTAL_AIR_ELDER;} //53
				case 54: { return APPEAR_TYPE_ELEMENTAL_EARTH;} //56
				case 55: { return APPEAR_TYPE_ELEMENTAL_EARTH_ELDER;} //57
				case 56: { return APPEAR_TYPE_MUMMY_COMMON;} //58
				case 57: { return APPEAR_TYPE_ELEMENTAL_FIRE;} //60
				case 58: { return APPEAR_TYPE_ELEMENTAL_FIRE_ELDER;} //61
				case 59: { return APPEAR_TYPE_ELEMENTAL_WATER_ELDER;} //68
			}
			break;
		case 3:
			switch ( iAppearanceIndex )
			{				
				case 60: { return APPEAR_TYPE_ELEMENTAL_WATER;} //69
				case 61: { return APPEAR_TYPE_GARGOYLE;} //73
				case 62: { return APPEAR_TYPE_GHAST;} //74
				case 63: { return APPEAR_TYPE_GHOUL;} //76
				case 64: { return APPEAR_TYPE_GIANT_FIRE;} //80
				case 65: { return APPEAR_TYPE_GIANT_FROST;} //81
				case 66: { return APPEAR_TYPE_GOLEM_IRON;} //89
				case 67: { return APPEAR_TYPE_VROCK;} //105
				case 68: { return APPEAR_TYPE_IMP;} //105
				case 69: { return APPEAR_TYPE_MEPHIT_FIRE;} //109
				case 70: { return APPEAR_TYPE_MEPHIT_ICE;} //110
				case 71: { return APPEAR_TYPE_OGRE;} //127
				case 72: { return APPEAR_TYPE_OGRE_MAGE;} //129
				case 73: { return APPEAR_TYPE_ORC_A;} //140
				case 74: { return APPEAR_TYPE_SLAAD_BLUE;} //151
				case 75: { return APPEAR_TYPE_SLAAD_GREEN;} //154
				case 76: { return APPEAR_TYPE_SPECTRE;} //156
				case 77: { return APPEAR_TYPE_SPIDER_DIRE;} //158
				case 78: { return APPEAR_TYPE_SPIDER_GIANT;} //159
				case 79: { return APPEAR_TYPE_SPIDER_PHASE;} //160
			}
			break;
		case 4:
			switch ( iAppearanceIndex )
			{				
				case 80: { return APPEAR_TYPE_SPIDER_BLADE;} //161
				case 81: { return APPEAR_TYPE_SPIDER_WRAITH;} //162
				case 82: { return APPEAR_TYPE_SUCCUBUS;} //163
				case 83: { return APPEAR_TYPE_TROLL;} //167
				case 84: { return APPEAR_TYPE_UMBERHULK;} //168
				case 85: { return APPEAR_TYPE_WEREWOLF;} //171
				case 86: { return APPEAR_TYPE_DOG_DIRE_WOLF;} //175
				case 87: { return APPEAR_TYPE_DOG_HELL_HOUND;} //179
				case 88: { return APPEAR_TYPE_DOG_SHADOW_MASTIF;} //180
				case 89: { return APPEAR_TYPE_DOG_WOLF;} //181
				case 90: { return APPEAR_TYPE_DOG_WINTER_WOLF;} //184
				case 91: { return APPEAR_TYPE_DREAD_WRAITH;} //186
				case 92: { return APPEAR_TYPE_WRAITH;} //187
				case 93: { return APPEAR_TYPE_ZOMBIE;} //198
				case 94: { return APPEAR_TYPE_VAMPIRE_FEMALE;} //288
				case 95: { return APPEAR_TYPE_VAMPIRE_MALE;} //289
				case 96: { return APPEAR_TYPE_RAT;} //386
				case 97: { return APPEAR_TYPE_RAT_DIRE;} //387
				case 98: { return APPEAR_TYPE_MINDFLAYER;} //413
				case 99: { return APPEAR_TYPE_DEVIL_HORNED;} //481
			}
			break;
		case 5:
			switch ( iAppearanceIndex )
			{				
				case 100: { return APPEAR_TYPE_SPIDER_BONE;} //482
				case 101: { return APPEAR_TYPE_GITHYANKI;} //483
				case 102: { return APPEAR_TYPE_BIRD;} //485
				case 103: { return APPEAR_TYPE_BLADELING;} //486
				case 104: { return APPEAR_TYPE_CAT;} //487
				case 105: { return APPEAR_TYPE_DEMON_HEZROU;} //488
				case 106: { return APPEAR_TYPE_DEVIL_PITFIEND;} //489
				case 107: { return APPEAR_TYPE_GOLEM_BLADE;} //493
				case 108: { return APPEAR_TYPE_SHADOW;} //496
				case 109: { return APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER;} //497
				case 110: { return APPEAR_TYPE_PIG;} //498
				case 111: { return APPEAR_TYPE_RABBIT;} //499
				case 112: { return APPEAR_TYPE_SHADOW_REAVER;} //500
				case 113: { return APPEAR_TYPE_WEASEL;} //503
				case 114: { return APPEAR_TYPE_SYLPH;} //512
				case 115: { return APPEAR_TYPE_DEVIL_ERINYES;} //514
				case 116: { return APPEAR_TYPE_PIXIE;} //521
				case 117: { return APPEAR_TYPE_DEMON_BALOR;} //522
				case 118: { return APPEAR_TYPE_GNOLL;} //533
				case 119: { return APPEAR_TYPE_GOBLIN;} //534
			}
			break;
		case 6:
			switch ( iAppearanceIndex )
			{				
				case 120: { return APPEAR_TYPE_KOBOLD;} //535
				case 121: { return APPEAR_TYPE_LIZARDFOLK;} //536
				case 122: { return APPEAR_TYPE_SKELETON;} //537
				case 123: { return APPEAR_TYPE_BEETLE_BOMBARDIER;} //538
				case 124: { return APPEAR_TYPE_BUGBEAR;} //543
				case 125: { return APPEAR_TYPE_NPC_GARIUS;} //544
				case 126: { return APPEAR_TYPE_SPIDER_GLOW;} //546
				case 127: { return APPEAR_TYPE_SPIDER_KRISTAL;} //547
				case 128: { return APPEAR_TYPE_NPC_DUNCAN;} //549
				case 129: { return APPEAR_TYPE_NPC_LORDNASHER;} //550
				case 130: { return APPEAR_TYPE_NPC_CHILDHHM;} //551
				case 131: { return APPEAR_TYPE_NPC_CHILDHHF;} //553
				case 132: { return APPEAR_TYPE_ELEMENTAL_AIR_HUGE;} //554
				case 133: { return APPEAR_TYPE_ELEMENTAL_AIR_GREATER;} //555
				case 134: { return APPEAR_TYPE_ELEMENTAL_EARTH_HUGE;} //556
				case 135: { return APPEAR_TYPE_ELEMENTAL_EARTH_GREATER;} //557
				case 136: { return APPEAR_TYPE_ELEMENTAL_FIRE_HUGE;} //558
				case 137: { return APPEAR_TYPE_ELEMENTAL_FIRE_GREATER;} //559
				case 138: { return APPEAR_TYPE_ELEMENTAL_WATER_HUGE;} //560
				case 139: { return APPEAR_TYPE_ELEMENTAL_WATER_GREATER;} //561
			}
			break;
		case 7:
			switch ( iAppearanceIndex )
			{				
				case 140: { return APPEAR_TYPE_SIEGETOWER;} //562
				case 141: { return APPEAR_TYPE_ASSIMAR;} //563
				case 142: { return APPEAR_TYPE_TIEFLING;} //564
				case 143: { return APPEAR_TYPE_ELF_SUN;} //565
				case 144: { return APPEAR_TYPE_ELF_WOOD;} //566
				case 145: { return APPEAR_TYPE_ELF_DROW;} //567
				case 146: { return APPEAR_TYPE_GNOME_SVIRFNEBLIN;} //568
				case 147: { return APPEAR_TYPE_DWARF_GOLD;} //569
				case 148: { return APPEAR_TYPE_DWARF_DUERGAR;} //570
				case 149: { return APPEAR_TYPE_HALFLING_STRONGHEART;} //571
				case 150: { return APPEAR_TYPE_CARGOSHIP;} //572
				case 151: { return APPEAR_TYPE_N_HUMAN;} //573
				case 152: { return APPEAR_TYPE_N_ELF;} //574
				case 153: { return APPEAR_TYPE_N_DWARF;} //575
				case 154: { return APPEAR_TYPE_N_HALF_ELF;} //576
				case 155: { return APPEAR_TYPE_N_GNOME;} //577
				case 156: { return APPEAR_TYPE_N_TIEFLING;} //578
				case 157: { return APPEAR_TYPE_NPC_GITHCAPTAIN;} //579
				case 158: { return APPEAR_TYPE_NPC_LORNE;} //580
				case 159: { return APPEAR_TYPE_NPC_TENAVROK;} //581
			}
			break;
		case 8:
			switch ( iAppearanceIndex )
			{				
				case 160: { return APPEAR_TYPE_NPC_CTANN;} //582
				case 161: { return APPEAR_TYPE_NPC_SHANDRA;} //583
				case 162: { return APPEAR_TYPE_NPC_ZEEAIRE;} //584
				case 163: { return APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT;} //585
				case 164: { return APPEAR_TYPE_NPC_KINGOFSHADOWS;} //586
				case 165: { return APPEAR_TYPE_NPC_NOLALOTH;} //587
				case 166: { return APPEAR_TYPE_NPC_ZHJAEVE;} //588
				case 167: { return APPEAR_TYPE_NPC_ZAXIS;} //589
				case 168: { return APPEAR_TYPE_NPC_AHJA;} //590
				case 169: { return APPEAR_TYPE_NPC_DURLER;} //591
				case 170: { return APPEAR_TYPE_NPC_HEZEBEL;} //592
				case 171: { return APPEAR_TYPE_NPC_HOSTTOWER;} //593
				case 172: { return APPEAR_TYPE_NPC_ZOKAN;} //594
				case 173: { return APPEAR_TYPE_NPC_ALDANON;} //595
				case 174: { return APPEAR_TYPE_NPC_JACOBY;} //596
				case 175: { return APPEAR_TYPE_NPC_JALBOUN;} //597
				case 176: { return APPEAR_TYPE_NPC_KHRALVER;} //598
				case 177: { return APPEAR_TYPE_NPC_KRALWOK;} //599
				case 178: { return APPEAR_TYPE_NPC_MEPHASM;} //600
				case 179: { return APPEAR_TYPE_NPC_MORKAI;} //601
			}
			break;
		case 9:
			switch ( iAppearanceIndex )
			{				
				case 180: { return APPEAR_TYPE_NPC_SARYA;} //602
				case 181: { return APPEAR_TYPE_NPC_SYDNEY;} //603
				case 182: { return APPEAR_TYPE_NPC_TORIOCLAVEN;} //604
				case 183: { return APPEAR_TYPE_NPC_UTHANCK;} //605
				case 184: { return APPEAR_TYPE_NPC_SHADOWPRIEST;} //606
				case 185: { return APPEAR_TYPE_NPC_HUNTERSTATUE;} //607
				case 186: { return APPEAR_TYPE_SIEGETOWERB;} //608
				case 187: { return APPEAR_TYPE_PUSHBLOCK;} //609
				case 188: { return APPEAR_TYPE_SMUGGLERWAGON;} //610
				case 189: { return APPEAR_TYPE_INVISIBLEMAN;} //611
				case 190: { return APPEAR_TYPE_AKACHI;} //1000
				case 191: { return APPEAR_TYPE_OKKU_BEAR;} //1001
				case 192: { return APPEAR_TYPE_PANTHER;} //1002
				case 193: { return APPEAR_TYPE_WOLVERINE;} //1003
				case 194: { return APPEAR_TYPE_INVISIBLE_STALKER;} //1004
				case 195: { return APPEAR_TYPE_HOMUNCULUS;} //1005
				case 196: { return APPEAR_TYPE_GOLEM_IMASKARI;} //1006
				case 197: { return APPEAR_TYPE_RED_WIZ_COMPANION;} //1007
				case 198: { return APPEAR_TYPE_DEATH_KNIGHT;} //1008
				case 199: { return APPEAR_TYPE_BARROW_GUARDIAN;} //1009
			}
			break;
		case 10:
			switch ( iAppearanceIndex )
			{				
				case 200: { return APPEAR_TYPE_SEA_MONSTER;} //1010
				case 201: { return APPEAR_TYPE_ONE_OF_MANY;} //1011
				case 202: { return APPEAR_TYPE_SHAMBLING_MOUND;} //1012
				case 203: { return APPEAR_TYPE_SOLAR;} //1013
				case 204: { return APPEAR_TYPE_WOLVERINE_DIRE;} //1014
				case 205: { return APPEAR_TYPE_DRAGON_BLUE;} //1015
				case 206: { return APPEAR_TYPE_DJINN;} //1016
				case 207: { return APPEAR_TYPE_GNOLL_THAYAN;} //1017
				case 208: { return APPEAR_TYPE_GOLEM_CLAY;} //1018
				case 209: { return APPEAR_TYPE_GOLEM_FAITHLESS;} //1019
				case 210: { return APPEAR_TYPE_DEMILICH;} //1020
				case 211: { return APPEAR_TYPE_HAG_ANNIS;} //1021
				case 212: { return APPEAR_TYPE_HAG_GREEN;} //1022
				case 213: { return APPEAR_TYPE_HAG_NIGHT;} //1023
				case 214: { return APPEAR_TYPE_HORSE_WHITE;} //1024
				case 215: { return APPEAR_TYPE_DEMILICH_SMALL;} //1025
				case 216: { return APPEAR_TYPE_LEOPARD_SNOW;} //1026
				case 217: { return APPEAR_TYPE_TREANT;} //1027
				case 218: { return APPEAR_TYPE_TROLL_FELL;} //1028
				case 219: { return APPEAR_TYPE_UTHRAKI;} //1029
			}
			break;
		case 11:
			switch ( iAppearanceIndex )
			{				
				case 220: { return APPEAR_TYPE_WYVERN;} //1030
				case 221: { return APPEAR_TYPE_RAVENOUS_INCARNATION;} //1031
				case 222: { return APPEAR_TYPE_N_ELF_WILD;} //1032
				case 223: { return APPEAR_TYPE_N_HALF_DROW;} //1033
				case 224: { return APPEAR_TYPE_MAGDA;} //1034
				case 225: { return APPEAR_TYPE_NEFRIS;} //1035
				case 226: { return APPEAR_TYPE_ELF_WILD;} //1036
				case 227: { return APPEAR_TYPE_EARTH_GENASI;} //1037
				case 228: { return APPEAR_TYPE_FIRE_GENASI;} //1038
				case 229: { return APPEAR_TYPE_AIR_GENASI;} //1039
				case 230: { return APPEAR_TYPE_WATER_GENASI;} //1040
				case 231: { return APPEAR_TYPE_HALF_DROW;} //1041
				case 232: { return APPEAR_TYPE_DOG_WOLF_TELTHOR;} //1042
				case 233: { return APPEAR_TYPE_HAGSPAWN_VAR1;} //1043
				case 234: { return APPEAR_TYPE_BEHOLDER;} //1201
				case 235: { return APPEAR_TYPE_REE_YUANTIF;} //1204
				case 236: { return APPEAR_TYPE_DRIDER;} //1206
				case 237: { return APPEAR_TYPE_MINOTAUR;} //1208
				case 238: { return APPEAR_TYPE_AZERBLOOD_ROF;} //1400;
				case 239: { return APPEAR_TYPE_FROSTBLOT_ROF;} //1401;
			}
			break;
		case 12:
			switch ( iAppearanceIndex )
			{				
				case 240: { return APPEAR_TYPE_DEVEIL_PAELIRYON;} //1044;
				case 241: { return APPEAR_TYPE_WERERAT;} //1045;
				case 242: { return APPEAR_TYPE_ORBAKH;} //1046;
				case 243: { return APPEAR_TYPE_QUELZARN;} //1047;
				
				
				case 244: { return APPEAR_TYPE_ELDBLOT_ROF;} //1402;
				case 245: { return APPEAR_TYPE_ARCTIC_DWARF_ROF;} //1403;
				case 246: { return APPEAR_TYPE_WILD_DWARF_ROF;} //1404;
				case 247: { return APPEAR_TYPE_TANARUKK_ROF;} //1405;
				case 248: { return APPEAR_TYPE_HOBGOBLIN_ROF;} //1407;
				case 249: { return APPEAR_TYPE_FOREST_GNOME_ROF;} //1409;
				case 250: { return APPEAR_TYPE_YUANTI_HALFBLOOD_ROF;} //1410;
				case 251: { return APPEAR_TYPE_ASABI_ROF;} //1411;
				case 252: { return APPEAR_TYPE_LIZARDFOLD_ROF;} //1412;
				case 253: { return APPEAR_TYPE_OGRE_ROF;} //1413;
				case 254: { return APPEAR_TYPE_PIXIE_ROF;} //1414;
				case 255: { return APPEAR_TYPE_DRAGONKIN_ROF;} //1415;
				case 256: { return APPEAR_TYPE_GLOAMING_ROF;} //1416;
				case 257: { return APPEAR_TYPE_CHAOND_ROF;} //1417;
				case 258: { return APPEAR_TYPE_ELF_DUNE_ROF;} //1418;
				case 259: { return APPEAR_TYPE_BROWNIE_ROF;} //1419;
				case 260: { return APPEAR_TYPE_ULDRA_ROF;} //1420;
				case 261: { return APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF;} //1421;
				case 262: { return APPEAR_TYPE_ELF_POSCADAR_ROF;} //1422;
				case 263: { return APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF;} //1423;
			}
			break;
		case 13:
			switch ( iAppearanceIndex )
			{				
				case 264: { return APPEAR_TYPE_FIRBOLG_ROF;} //1424;
				case 265: { return APPEAR_TYPE_FOMORIAN_ROF;} //1425;
				case 266: { return APPEAR_TYPE_VERBEEG_ROF;} //1426;
				case 267: { return APPEAR_TYPE_VOADKYN_ROF;} //1427;
				case 268: { return APPEAR_TYPE_FJELLBLOT_ROF;} //1428;
				case 269: { return APPEAR_TYPE_TAKEBLOT_ROF;} //1429;
				case 270: { return APPEAR_TYPE_AIR_MEPHLING_ROF;} //1430;
				case 271: { return APPEAR_TYPE_EARTH_MEPHLING_ROF;} //1431;
				case 272: { return APPEAR_TYPE_FIRE_MEPHLING_ROF;} //1432;
				case 273: { return APPEAR_TYPE_WATER_MEPHLING_ROF;} //1433;
				case 274: { return APPEAR_TYPE_KHAASTA_ROF;} //1434;
				case 275: { return APPEAR_TYPE_MOUNTAIN_ORC_ROF;} //1435;
				case 276: { return APPEAR_TYPE_BOOGIN_ROF;} //1436;
				case 277: { return APPEAR_TYPE_ICE_SPIRE_OGRE_ROF;} //1437;
				case 278: { return APPEAR_TYPE_OGRILLON_ROF;} //1438;
				case 279: { return APPEAR_TYPE_KRINTH_ROF;} //1439;
				case 280: { return APPEAR_TYPE_HALFLING_SANDSTORM_ROF;} //1440;
				case 281: { return APPEAR_TYPE_DWARF_DEGLOSIAN_ROF;} //1441;
				case 282: { return APPEAR_TYPE_DWARF_GALDOSIAN_ROF;} //1442;
				case 283: { return APPEAR_TYPE_ELF_ROF;} //1443;
			}
			break;
		case 14:
			switch ( iAppearanceIndex )
			{				
				case 284: { return APPEAR_TYPE_ELF_DRANGONARI_ROF;} //1444;
				case 285: { return APPEAR_TYPE_ELF_GHOST_ROF;} //1445;
				case 286: { return APPEAR_TYPE_FAERIE_ROF;} //1446;
				case 287: { return APPEAR_TYPE_GNOME_ROF;} //1447;
				case 288: { return APPEAR_TYPE_GOBLIN_ROF;} //1448;
				case 289: { return APPEAR_TYPE_HALF_ELF_ROF;} //1449;
				case 290: { return APPEAR_TYPE_HALF_ORC_ROF;} //1450;
				case 291: { return APPEAR_TYPE_HALFLING_ROF;} //1451
				case 292: { return APPEAR_TYPE_HUMAN_ROF;} //1452
				case 293: { return APPEAR_TYPE_OROG_ROF;} //1453
				case 294: { return APPEAR_TYPE_AELFBORN_ROF;} //1454
				case 295: { return APPEAR_TYPE_FEYRI_ROF;} //1455
				case 296: { return APPEAR_TYPE_SEWER_GOBLIN_ROF;} //1456
				case 297: { return APPEAR_TYPE_WOOD_GENASI_ROF;} //1457
				case 298: { return APPEAR_TYPE_HALF_CELESTIAL_ROF;} //1458
				case 299: { return APPEAR_TYPE_DERRO_ROF;} //1459
				case 300: { return APPEAR_TYPE_HALF_OGRE_ROF;} //1460
				case 301: { return APPEAR_TYPE_DRAGONBORN_ROF;} //1461
				case 302: { return APPEAR_TYPE_URD_ROF;} //1462
				case 303: { return APPEAR_TYPE_CELADRIN_ROF;} //1463
			}
			break;
		case 15:
			switch ( iAppearanceIndex )
			{				
				case 304: { return APPEAR_TYPE_SYLPH_ROF;} //1464
				case 305: { return APPEAR_TYPE_FLAMEBROTHER_ROF;} //1465
				case 306: { return APPEAR_TYPE_RUST_MONSTER;} //1500
				case 307: { return APPEAR_TYPE_BASILIK;} //1501
				case 308: { return APPEAR_TYPE_SNAKE;} //1502
				case 309: { return APPEAR_TYPE_SCORPION;} //1504
				case 310: { return APPEAR_TYPE_XORN;} //1505
				case 311: { return APPEAR_TYPE_CARRION_CRAWLER;} //1506
				case 312: { return APPEAR_TYPE_DRACOLICH;} //1507
				case 313: { return APPEAR_TYPE_DISPLACER_BEAST;} //1508
				case 314: { return APPEAR_TYPE_RDS_PORTAL;} //2041
				case 315: { return APPEAR_TYPE_FLYING_BOOK;} //2042
				case 316: { return APPEAR_TYPE_RAT_CRANIUM;} //2043
				case 317: { return APPEAR_TYPE_SLIME;} //2044
				case 318: { return APPEAR_TYPE_MONODRONE;} //2045
				case 319: { return APPEAR_TYPE_SPIDER_HOOK;} //2046
				case 320: { return APPEAR_TYPE_DABUS;} //2047
				case 321: { return APPEAR_TYPE_BARIAUR;} //2049
				case 322: { return APPEAR_TYPE_DOGDEAD;} //2053
				case 323: { return APPEAR_TYPE_URIDEZU;} //2054
			}
			break;
		case 16:
			switch ( iAppearanceIndex )
			{				
				case 324: { return APPEAR_TYPE_DUODRONE;} //2055
				case 325: { return APPEAR_TYPE_TRIDRONE;} //2056
				case 326: { return APPEAR_TYPE_PENTADRONE;} //2057
				case 327: { return APPEAR_TYPE_GELATINOUS_CUBE;} //2300
				case 328: { return APPEAR_TYPE_OOZE;} //2301
				case 329: { return APPEAR_TYPE_HAMMERHEAD_SHARK;} //2302
				case 330: { return APPEAR_TYPE_MAKO_SHARK;} //2303
				case 331: { return APPEAR_TYPE_MYCONID;} //2304
				case 332: { return APPEAR_TYPE_NAGA;} //2305
				case 333: { return APPEAR_TYPE_PURRLE_WORM;} //2306
				case 334: { return APPEAR_TYPE_STIRGE;} //2307
				case 335: { return APPEAR_TYPE_STIRGE_TINT;} //2308
				case 336: { return APPEAR_TYPE_PURRLE_WORM_TINT;} //2309
				case 337: { return APPEAR_TYPE_GIANT_HILL;} //3000
				case 338: { return APPEAR_TYPE_GIANT_STONE;} //3001
				case 339: { return APPEAR_TYPE_GIANT_FIRE_ALT;} //3002
				case 340: { return APPEAR_TYPE_GIANT_FROST_ALT;} //3003
				case 341: { return APPEAR_TYPE_GIANT_CLOUD;} //3004
				case 342: { return APPEAR_TYPE_GIANT_FOREST;} //3005
				case 343: { return APPEAR_TYPE_GIANT_STORM;} //3006
				
				case 344: { return APPEAR_TYPE_GIBBERING_MOUTHER;} //3010
				case 345: { return APPEAR_TYPE_BIGBY_GRASPING;} //3020
				case 346: { return APPEAR_TYPE_BIGBY_INTERPOS;} //3021
				case 347: { return APPEAR_TYPE_BIGBY_FIST;} //3022
			}
			break;
		case 17:
			switch ( iAppearanceIndex )
			{
				
				case 348: { return APPEAR_TYPE_DRAGONMAN;} //3100
				case 349: { return APPEAR_TYPE_UNICORN;} //3101
				case 350: { return APPEAR_TYPE_ELEMENTAL_MAGMA;} //3102
				case 351: { return APPEAR_TYPE_ELEMENTAL_ADAMANTIT;} //3103
				case 352: { return APPEAR_TYPE_ELEMENTAL_ICE;} //3104
				case 353: { return APPEAR_TYPE_ELEMENTAL_SILVER;} //3105
				case 354: { return APPEAR_TYPE_FRISCHLING;} //3106
				case 355: { return APPEAR_TYPE_TIGER_01;} //3107
				case 356: { return APPEAR_TYPE_DOG_GERMAN;} //3108
				case 357: { return APPEAR_TYPE_FOURMI;} //3109
				case 358: { return APPEAR_TYPE_EFREETI;} //3400

			}
			break;
	}
	
	return -1;
}
*/


// this is used to get the creatures approximate physical height
// used to prevent creatures of a given size from entering certain areas, and for drowning logic.
/**  
* @author
* @param 
* @see 
* @return 
*/
float CSLGetHeightByAppearance( int iAppearanceType )
{
	// int iAppearanceType = GetAppearanceType(oTarget);
	if ( iAppearanceType == -1 ) { return 0.0f; }
	
	iAppearanceType = CSLGetBaseAppearance( iAppearanceType );
	
	int iSubAppearance = iAppearanceType / 50;
	switch(iSubAppearance)
	{
		case 0:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DWARF: { return 1.5289f;} //0 Skel= P_DD?_Skel Height= 1.5 Z= 0.75 SizeCat= 3
				case APPEAR_TYPE_ELF: { return 1.7669f;} //1 Skel= P_HH?_Skel Height= 1.75 Z= 0.9 SizeCat= 3
				case APPEAR_TYPE_GNOME: { return 1.252f;} //2 Skel= P_GG?_Skel Height= 1.5 Z= 0.65 SizeCat= 2
				case APPEAR_TYPE_HALFLING: { return 1.1903f;} //3 Skel= P_HH?_Skel Height= 1.5 Z= 0.6 SizeCat= 2
				case APPEAR_TYPE_HALF_ELF: { return 1.8765f;} //4 Skel= P_HH?_Skel Height= 2 Z= 0.95 SizeCat= 3
				case APPEAR_TYPE_HALF_ORC: { return 2.0625f;} //5 Skel= P_OO?_Skel Height= 2.25 Z= 1.05 SizeCat= 3
				case APPEAR_TYPE_HUMAN: { return 1.9721f;} //6 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_HORSE_BROWN: { return 1.79f;} //7 Skel= c_horse_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BADGER: { return 0.4895f;} //8 Skel= c_badger_skel Height= 1 Z= 1 SizeCat= 2
				case APPEAR_TYPE_BADGER_DIRE: { return 0.9657f;} //9 Skel= c_badger_skel Height= 1 Z= 2.2 SizeCat= 3
				case APPEAR_TYPE_BAT: { return 2.0754f;} //10 Skel= c_bat_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_HORSE_PINTO: { return 1.6823f;} //11 Skel= c_horse_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_HORSE_SKELETAL: { return 1.7869f;} //12 Skel= c_horse_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BEAR_BROWN: { return 1.4088f;} //13 Skel= c_bear_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_HORSE_PALOMINO: { return 1.895f;} //14 Skel= c_horse_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BEAR_DIRE: { return 3.4328f;} //15 Skel= c_bear_skel Height= 1 Z= 2.2 SizeCat= 4
				case APPEAR_TYPE_DRAGON__BRONZE: { return 7.0f;} //16 Skel= c_dragon_skel Height= 1 Z= 2 SizeCat= 5
				case APPEAR_TYPE_YOUNG_BRONZE: { return 1.8344f;} //17 Skel= c_dragon_skel Height= 1 Z= 0.4 SizeCat= 3
				case APPEAR_TYPE_BEETLE_FIRE: { return 0.8901f;} //18 Skel= c_beetle_skel Height= 1 Z= 1.2 SizeCat= 3
				case APPEAR_TYPE_BEETLE_STAG: { return 0.6983f;} //19 Skel= c_beetle_skel Height= 1 Z= 1.2 SizeCat= 3
				case APPEAR_TYPE_YOUNG_BLUE: { return 1.669f;} //20 Skel= c_bluedragon_skel Height= 1 Z= 0.4 SizeCat= 3
				case APPEAR_TYPE_BOAR: { return 1.1076f;} //21 Skel= c_boar_skel Height= 1 Z= 0.7 SizeCat= 3
				case APPEAR_TYPE_BOAR_DIRE: { return 2.3581f;} //22 Skel= c_boar_skel Height= 1 Z= 1.4 SizeCat= 3
				case APPEAR_TYPE_YUANTI_ABOMINATION: { return 3.1089f;} //23 Skel= c_ytAbom_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_WORG: { return 1.184f;} //24 Skel= c_wolf_skel Height= 1 Z= 0.82 SizeCat= 3
				case APPEAR_TYPE_YUANTI_HOLYGUARDIAN: { return 2.9926f;} //25 Skel= c_ytAbom_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_PLANETAR: { return 2.3053f;} //26 Skel= P_HH?_Skel Height= 2 Z= 1.2 SizeCat= 4
				case APPEAR_TYPE_WILLOWISP: { return 0.0f;} //27 Skel= c_floater_skel Height= 1 Z= 1 SizeCat= 2
				case APPEAR_TYPE_FIRE_NEWT: { return 1.8734f;} //28 Skel= c_dogleg_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DROWNED: { return 1.4835f;} //29 Skel= c_ghoul_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_MEGARAPTOR: { return 1.1592f;} //30 Skel= c_raptor_skel Height= 1 Z= 1.4 SizeCat= 4
				case APPEAR_TYPE_CHICKEN: { return 0.5084f;} //31 Skel= c_chicken_skel Height= 0.3 Z= 2 SizeCat= 1
				case APPEAR_TYPE_WIGHT: { return 1.828f;} //32 Skel= c_hag_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_CLOCKROACH: { return 0.5363f;} //33 Skel= c_beetle_skel Height= 1 Z= 1.2 SizeCat= 3
				case APPEAR_TYPE_COW: { return 1.7858f;} //34 Skel= c_cow_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DEER: { return 1.0747f;} //35 Skel= c_deer_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DEINONYCHUS: { return 1.0322f;} //36 Skel= c_raptor_skel Height= 1 Z= 1.2 SizeCat= 3
				case APPEAR_TYPE_DEER_STAG: { return 1.0716f;} //37 Skel= c_deer_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BATIRI: { return 1.4832f;} //38 Skel= c_small_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_LICH: { return 2.3241f;} //39 Skel= p_hhm_skel Height= 1 Z= 1.2 SizeCat= 3
				case APPEAR_TYPE_YUANTIPUREBLOOD: { return 1.9695f;} //40 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DRAGON_BLACK: { return 3.941f;} //41 Skel= C_Blackdragon_Skel Height= 1 Z= 1 SizeCat= 5
				case APPEAR_TYPE_WAGON_LIGHT01: { return 4.2068f;} //42 Skel= c_wagon_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_WAGON_LIGHT02: { return 4.1632f;} //43 Skel= c_wagon_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_WAGON_LIGHT03: { return 3.3063f;} //44 Skel= c_wagon_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_GRAYORC: { return 1.9631f;} //45 Skel= P_OO?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_YUANTI_HERALD: { return 3.5162f;} //46 Skel= c_YtAbom4arm_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_NPC_SASANI: { return 1.929f;} //47 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_VOLO: { return 1.9373f;} //48 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DRAGON_RED: { return 10.0f;} //49 Skel= c_dragon_skel Height= 1 Z= 2.5 SizeCat= 5
			}
			break;
		case 1:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_SEPTIMUND: { return 1.9758f;} //50 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DRYAD: { return 1.9535f;} //51 Skel= p_hhf_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_ELEMENTAL_AIR: { return 3.0455;} //52 Skel= c_floater_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_ELEMENTAL_AIR_ELDER: { return 4.0385;} //53 Skel= c_floater_skel Height= 1 Z= 1.75 SizeCat= 3
				case APPEAR_TYPE_ELEMENTAL_EARTH: { return 3.0982f;} //56 Skel= c_elmearth_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_EARTH_ELDER: { return 5.3233f;} //57 Skel= c_elmearth_skel Height= 1 Z= 1.75 SizeCat= 4
				case APPEAR_TYPE_MUMMY_COMMON: { return 1.8237f;} //58 Skel= c_mummy_skel Height= 1 Z= 1.15 SizeCat= 3
				case APPEAR_TYPE_ELEMENTAL_FIRE: { return 2.169f;} //60 Skel= c_elmfire_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_ELEMENTAL_FIRE_ELDER: { return 3.7844f;} //61 Skel= c_elmfire_skel Height= 1 Z= 1.75 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_WATER_ELDER: { return 3.2376f;} //68 Skel= c_elmwater_skel Height= 1 Z= 1.75 SizeCat= 3
				case APPEAR_TYPE_ELEMENTAL_WATER: { return 1.8378f;} //69 Skel= c_elmwater_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_GARGOYLE: { return 2.4498f;} //73 Skel= c_wingleg_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_GHAST: { return 1.4612f;} //74 Skel= c_ghoul_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_GHOUL: { return 1.4626f;} //76 Skel= c_ghoul_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_GIANT_FIRE: { return 3.4815f;} //80 Skel= c_giantfire_skel Height= 1 Z= 1.3 SizeCat= 5
				case APPEAR_TYPE_GIANT_FROST: { return 3.786f;} //81 Skel= c_giantfrost_skel Height= 5 Z= 1.2 SizeCat= 5
				case APPEAR_TYPE_GOLEM_IRON: { return 4.0661f;} //89 Skel= c_irongol_skel Height= 1 Z= 2.1 SizeCat= 4
			}
			break;
		case 2:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VROCK: { return 1.00f;} //105
				case APPEAR_TYPE_IMP: { return 2.1753f;} //105 Skel= c_imp_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_MEPHIT_FIRE: { return 2.098f;} //109 Skel= c_imp_skel Height= 1 Z= 1 SizeCat= 2
				case APPEAR_TYPE_MEPHIT_ICE: { return 2.0324f;} //110 Skel= c_imp_skel Height= 1 Z= 1 SizeCat= 2
				case APPEAR_TYPE_OGRE: { return 2.495f;} //127 Skel= c_ogre_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_OGRE_MAGE: { return 3.2903f;} //129 Skel= c_heavy_skel Height= 1 Z= 1.25 SizeCat= 4
				case APPEAR_TYPE_ORC_A: { return 1.8186f;} //140 Skel= c_orc_skel Height= 1 Z= 1 SizeCat= 3
			}
			break;
		case 3:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SLAAD_BLUE: { return 1.00f;} //151
				case APPEAR_TYPE_SLAAD_GREEN: { return 1.00f;} //154
				case APPEAR_TYPE_SPECTRE: { return 0.0f;} //156 Skel= c_ghost_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_SPIDER_DIRE: { return 1.1254f;} //158 Skel= c_spid_skel Height= 1 Z= 1.3 SizeCat= 4
				case APPEAR_TYPE_SPIDER_GIANT: { return 0.9419f;} //159 Skel= c_spid_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SPIDER_PHASE: { return 0.9434f;} //160 Skel= c_spid_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SPIDER_BLADE: { return 0.8276f;} //161 Skel= c_spid_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SPIDER_WRAITH: { return 0.9251f;} //162 Skel= c_spid_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SUCCUBUS: { return 1.9727f;} //163 Skel= C_Succubus_Skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_TROLL: { return 2.288f;} //167 Skel= c_troll_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_UMBERHULK: { return 2.7744f;} //168 Skel= c_umber_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_WEREWOLF: { return 1.402f;} //171 Skel= c_werewolf_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DOG_DIRE_WOLF: { return 1.6614f;} //175 Skel= c_wolf_skel Height= 1 Z= 1.3 SizeCat= 4
				case APPEAR_TYPE_DOG_HELL_HOUND: { return 1.3467f;} //179 Skel= c_dog_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DOG_SHADOW_MASTIF: { return 1.2659f;} //180 Skel= c_dog_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_DOG_WOLF: { return 0.9063f;} //181 Skel= c_wolf_skel Height= 1 Z= 0.75 SizeCat= 3
				case APPEAR_TYPE_DOG_WINTER_WOLF: { return 1.8866f;} //184 Skel= c_wolf_skel Height= 1 Z= 1.4 SizeCat= 4
				case APPEAR_TYPE_DREAD_WRAITH: { return 2.3469f;} //186 Skel= c_wraith_skel Height= 1 Z= 1.3 SizeCat= 4
				case APPEAR_TYPE_WRAITH: { return 1.8308f;} //187 Skel= c_wraith_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_ZOMBIE: { return 1.6035f;} //198 Skel= c_zombie_skel Height= 1 Z= 1 SizeCat= 3
			}
			break;
		case 5:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VAMPIRE_FEMALE: { return 1.9636f;} //288 Skel= P_HHF_Skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_VAMPIRE_MALE: { return 1.9708f;} //289 Skel= P_HHM_Skel Height= 1 Z= 1 SizeCat= 3
			}
			break;
		case 7:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RAT: { return 0.1574f;} //386 Skel= c_rat_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_RAT_DIRE: { return 0.4815f;} //387 Skel= c_rat_skel Height= 1 Z= 3 SizeCat= 2
			}
			break;
		case 8:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_MINDFLAYER: { return 1.9212f;} //413 Skel= c_Mindf_skel Height= 1 Z= 1 SizeCat= 3
			}
			break;
		case 9:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DEVIL_HORNED: { return 2.4021f;} //481 Skel= c_wingleg_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SPIDER_BONE: { return 1.018f;} //482 Skel= c_spid_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_GITHYANKI: { return 1.9903f;} //483 Skel= P_HH?_Skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BIRD: { return 0.4094f;} //485 Skel= c_bird_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_BLADELING: { return 1.476f;} //486 Skel= c_small_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_CAT: { return 0.396f;} //487 Skel= c_cat_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_DEMON_HEZROU: { return 3.0759f;} //488 Skel= c_hezrou_skel Height= 1 Z= 2 SizeCat= 4
				case APPEAR_TYPE_DEVIL_PITFIEND: { return 3.8648f;} //489 Skel= c_devil_skel Height= 1 Z= 1.25 SizeCat= 4
				case APPEAR_TYPE_GOLEM_BLADE: { return 2.6476f;} //493 Skel= c_bladegol_skel Height= 2 Z= 1.5 SizeCat= 4
				case APPEAR_TYPE_SHADOW: { return 3.0643f;} //496 Skel= c_night_skel Height= 1 Z= 2 SizeCat= 3
				case APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER: { return 3.138f;} //497 Skel= c_night_skel Height= 1 Z= 2 SizeCat= 4
				case APPEAR_TYPE_PIG: { return 0.6354f;} //498 Skel= c_pig_skel Height= 1 Z= 1 SizeCat= 2
				case APPEAR_TYPE_RABBIT: { return 0.3174f;} //499 Skel= c_rabbit_skel Height= 1 Z= 1 SizeCat= 1
			}
			break;
		case 10:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SHADOW_REAVER: { return 2.0091f;} //500 Skel= N_SReaver_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_WEASEL: { return 0.2021f;} //503 Skel= c_weasel_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_SYLPH: { return 1.7043f;} //512 Skel= c_pixie_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_DEVIL_ERINYES: { return 1.9421f;} //514 Skel= P_HHF_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_PIXIE: { return 1.8284f;} //521 Skel= c_pixie_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_DEMON_BALOR: { return 3.9288f;} //522 Skel= c_devil_skel Height= 1 Z= 1.25 SizeCat= 4
				case APPEAR_TYPE_GNOLL: { return 1.7678f;} //533 Skel= c_dogleg_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_GOBLIN: { return 0.9853f;} //534 Skel= c_small_skel Height= 1 Z= 0.7 SizeCat= 3
				case APPEAR_TYPE_KOBOLD: { return 0.8759f;} //535 Skel= c_dogleg_skel Height= 1 Z= 0.45 SizeCat= 3
				case APPEAR_TYPE_LIZARDFOLK: { return 1.8881f;} //536 Skel= c_dogleg_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_SKELETON: { return 1.9242f;} //537 Skel= P_HHM_Skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BEETLE_BOMBARDIER: { return 0.5868f;} //538 Skel= c_beetle_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BUGBEAR: { return 1.9572f;} //543 Skel= c_bugbear_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_GARIUS: { return 1.9387f;} //544 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_SPIDER_GLOW: { return 1.5818f;} //546 Skel= c_spid_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SPIDER_KRISTAL: { return 1.5444f;} //547 Skel= c_spid_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_NPC_DUNCAN: { return 1.8981f;} //549 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
			}
			break;
		case 11:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_LORDNASHER: { return 2.0728f;} //550 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_CHILDHHM: { return 1.2249f;} //551 Skel= P_GGM_Skel Height= 1 Z= 0.65 SizeCat= 3
				case APPEAR_TYPE_NPC_CHILDHHF: { return 1.259f;} //553 Skel= P_GGM_Skel Height= 1 Z= 0.65 SizeCat= 3
				case APPEAR_TYPE_ELEMENTAL_AIR_HUGE: { return 0.0f;} //554 Skel= c_floater_skel Height= 1 Z= 1.25 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_AIR_GREATER: { return 0.0f;} //555 Skel= c_floater_skel Height= 1 Z= 1.5 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_EARTH_HUGE: { return 3.6855f;} //556 Skel= c_elmearth_skel Height= 1 Z= 1.25 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_EARTH_GREATER: { return 4.4775f;} //557 Skel= c_elmearth_skel Height= 1 Z= 1.5 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_FIRE_HUGE: { return 2.6265f;} //558 Skel= c_elmfire_skel Height= 1 Z= 1.25 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_FIRE_GREATER: { return 3.2408f;} //559 Skel= c_elmfire_skel Height= 1 Z= 1.5 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_WATER_HUGE: { return 2.3315f;} //560 Skel= c_elmwater_skel Height= 1 Z= 1.25 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_WATER_GREATER: { return 2.8168f;} //561 Skel= c_elmwater_skel Height= 1 Z= 1.5 SizeCat= 4
				case APPEAR_TYPE_SIEGETOWER: { return 10.0f;} //562 Skel= c_siegetower_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_ASSIMAR: { return 1.9928f;} //563 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_TIEFLING: { return 1.9677f;} //564 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_ELF_SUN: { return 1.7189f;} //565 Skel= P_HH?_Skel Height= 1.75 Z= 0.9 SizeCat= 3
				case APPEAR_TYPE_ELF_WOOD: { return 1.734f;} //566 Skel= P_HH?_Skel Height= 1.75 Z= 0.9 SizeCat= 3
				case APPEAR_TYPE_ELF_DROW: { return 1.6414f;} //567 Skel= P_HH?_Skel Height= 1.75 Z= 0.83 SizeCat= 3
				case APPEAR_TYPE_GNOME_SVIRFNEBLIN: { return 1.2604f;} //568 Skel= P_GG?_Skel Height= 1.5 Z= 0.65 SizeCat= 2
				case APPEAR_TYPE_DWARF_GOLD: { return 1.4762f;} //569 1.4862f was close  1.5662f Skel= P_DD?_Skel Height= 1.5 Z= 0.75 SizeCat= 3
				case APPEAR_TYPE_DWARF_DUERGAR: { return 1.4395f;} //570 Skel= P_DD?_Skel Height= 1.5 Z= 0.75 SizeCat= 3
				case APPEAR_TYPE_HALFLING_STRONGHEART: { return 1.1602f;} //571 Skel= P_HH?_Skel Height= 1.5 Z= 0.6 SizeCat= 2
				case APPEAR_TYPE_CARGOSHIP: { return 15.0f;} //572 Skel= c_cargosh_skel Height= 2 Z= 1 SizeCat= 5
				case APPEAR_TYPE_N_HUMAN: { return 0.0f;} //573 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_N_ELF: { return 1.7882f;} //574 Skel= P_HH?_Skel Height= 1.75 Z= 0.9 SizeCat= 3
				case APPEAR_TYPE_N_DWARF: { return 1.4107f;} //575 Skel= P_DD?_Skel Height= 1.5 Z= 0.75 SizeCat= 3
				case APPEAR_TYPE_N_HALF_ELF: { return 0.0f;} //576 Skel= P_HH?_Skel Height= 2 Z= 0.95 SizeCat= 3
				case APPEAR_TYPE_N_GNOME: { return 1.2654f;} //577 Skel= P_GG?_Skel Height= 1.5 Z= 0.65 SizeCat= 2
				case APPEAR_TYPE_N_TIEFLING: { return 0.0f;} //578 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_GITHCAPTAIN: { return 1.9798f;} //579 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_LORNE: { return 1.9752f;} //580 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_TENAVROK: { return 1.9826f;} //581 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_CTANN: { return 1.9901f;} //582 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_SHANDRA: { return 1.9674f;} //583 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_ZEEAIRE: { return 1.9903f;} //584 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT: { return 2.0641f;} //585 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_KINGOFSHADOWS: { return 4.9961f;} //586 Skel= N_KOS_Skel Height= 2 Z= 3 SizeCat= 5
				case APPEAR_TYPE_NPC_NOLALOTH: { return 0.0f;} //587 Skel= c_dragon_skel Height= 2 Z= 2.5 SizeCat= 5
				case APPEAR_TYPE_NPC_ZHJAEVE: { return 1.9108f;} //588 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_ZAXIS: { return 1.6987f;} //589 Skel= c_hezrou_skel Height= 2 Z= 1 SizeCat= 4
				case APPEAR_TYPE_NPC_AHJA: { return 1.9283f;} //590 Skel= P_HHM_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_DURLER: { return 0.0f;} //591 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_HEZEBEL: { return 1.9403f;} //592 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_HOSTTOWER: { return 0.0f;} //593 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_ZOKAN: { return 2.0158f;} //594 Skel= P_HHM_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_ALDANON: { return 1.9608f;} //595 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_JACOBY: { return 1.9543f;} //596 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_JALBOUN: { return 2.0077f;} //597 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_KHRALVER: { return 1.9889f;} //598 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_KRALWOK: { return 1.9857f;} //599 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
			}
			break;
		case 12:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_MEPHASM: { return 1.9732f;} //600 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_MORKAI: { return 1.9783f;} //601 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_SARYA: { return 1.9473f;} //602 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_SYDNEY: { return 1.886f;} //603 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_TORIOCLAVEN: { return 1.9489f;} //604 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_UTHANCK: { return 1.9307f;} //605 Skel= P_OOM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_SHADOWPRIEST: { return 2.0053f;} //606 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NPC_HUNTERSTATUE: { return 1.844f;} //607 Skel= N_HunterStatue_Skel Height= 2 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SIEGETOWERB: { return 6.0438f;} //608 Skel= c_siegetower02_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_PUSHBLOCK: { return 2.3392f;} //609 Skel= c_pushblk_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SMUGGLERWAGON: { return 0.9241f;} //610 Skel= c_smugwagon_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_INVISIBLEMAN: { return 2.0f;} //611 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
			}
			break;
		case 20:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AKACHI: { return 1.9597f;} //1000 Skel= P_HHM_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_OKKU_BEAR: { return 2.2911f;} //1001 Skel= n_okku_skel Height= 1.6 Z= 1.2 SizeCat= 3
				case APPEAR_TYPE_PANTHER: { return 0.8933f;} //1002 Skel= c_panther_skel Height= 1 Z= 1.4 SizeCat= 3
				case APPEAR_TYPE_WOLVERINE: { return 0.4411f;} //1003 Skel= c_badger_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_INVISIBLE_STALKER: { return 1.8735f;} //1004 Skel= c_wraith_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_HOMUNCULUS: { return 2.0333f;} //1005 Skel= c_homunculus_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_GOLEM_IMASKARI: { return 1.9028f;} //1006 Skel= c_imaskarigolem_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_RED_WIZ_COMPANION: { return 1.9337f;} //1007 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DEATH_KNIGHT: { return 1.937f;} //1008 Skel= P_HHM_Skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BARROW_GUARDIAN: { return 3.4164f;} //1009 Skel= c_barrow_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_SEA_MONSTER: { return 12.0f;} //1010 Skel= c_seamonster_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_ONE_OF_MANY: { return 1.8128f;} //1011 Skel= n_oneofmany_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_SHAMBLING_MOUND: { return 2.9591f;} //1012 Skel= c_shamblingmound_skel Height= 1 Z= 2 SizeCat= 4
				case APPEAR_TYPE_SOLAR: { return 2.8559f;} //1013 Skel= P_HHM_Skel Height= 2 Z= 1.5 SizeCat= 4
				case APPEAR_TYPE_WOLVERINE_DIRE: { return 0.4384f;} //1014 Skel= c_badger_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_DRAGON_BLUE: { return 10.0f;} //1015 Skel= c_bluedragon_skel Height= 1 Z= 2.5 SizeCat= 5
				case APPEAR_TYPE_DJINN: { return 2.0531f;} //1016 Skel= c_jinn_skel Height= 2 Z= 1 SizeCat= 4
				case APPEAR_TYPE_GNOLL_THAYAN: { return 1.7807f;} //1017 Skel= c_dogleg_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_GOLEM_CLAY: { return 2.5502f;} //1018 Skel= c_claygolem_skel Height= 1 Z= 1.5 SizeCat= 4
				case APPEAR_TYPE_GOLEM_FAITHLESS: { return 2.4646f;} //1019 Skel= c_faithlessgolem_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_DEMILICH: { return 2.7529f;} //1020 Skel= c_demilich_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_HAG_ANNIS: { return 1.9611f;} //1021 Skel= c_hag_skel Height= 2 Z= 1.2 SizeCat= 4
				case APPEAR_TYPE_HAG_GREEN: { return 1.6558f;} //1022 Skel= c_hag_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_HAG_NIGHT: { return 1.6333f;} //1023 Skel= c_hag_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_HORSE_WHITE: { return 1.8718f;} //1024 Skel= c_horse_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DEMILICH_SMALL: { return 1.7574f;} //1025 Skel= c_demilichsmall_skel Height= 1 Z= 1 SizeCat= 1
				case APPEAR_TYPE_LEOPARD_SNOW: { return 0.5731f;} //1026 Skel= c_panther_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_TREANT: { return 6.4298f;} //1027 Skel= c_treant_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_TROLL_FELL: { return 4.5927f;} //1028 Skel= c_felltroll_skel Height= 1 Z= 2 SizeCat= 5
				case APPEAR_TYPE_UTHRAKI: { return 1.7063f;} //1029 Skel= c_uthraki_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_WYVERN: { return 2.485f;} //1030 Skel= c_wyvern_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_RAVENOUS_INCARNATION: { return 1.5473f;} //1031 Skel= c_ravenousinc_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_N_ELF_WILD: { return 0.0f;} //1032 Skel= P_HH?_Skel Height= 2 Z= 0.93 SizeCat= 3
				case APPEAR_TYPE_N_HALF_DROW: { return 0.0f;} //1033 Skel= P_HH?_Skel Height= 2 Z= 0.95 SizeCat= 3
				case APPEAR_TYPE_MAGDA: { return 1.9693f;} //1034 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_NEFRIS: { return 1.9596f;} //1035 Skel= P_HHF_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_ELF_WILD: { return 1.8005f;} //1036 Skel= P_HH?_Skel Height= 2 Z= 0.93 SizeCat= 3
				case APPEAR_TYPE_EARTH_GENASI: { return 1.9869f;} //1037 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_FIRE_GENASI: { return 2.0111f;} //1038 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_AIR_GENASI: { return 1.9907f;} //1039 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_WATER_GENASI: { return 1.9594f;} //1040 Skel= P_HH?_Skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_HALF_DROW: { return 1.846f;} //1041 Skel= P_HH?_Skel Height= 2 Z= 0.95 SizeCat= 3
				case APPEAR_TYPE_DOG_WOLF_TELTHOR: { return 1.72f;} //1042 Skel= c_wolf_skel Height= 1 Z= 1.3 SizeCat= 4
				case APPEAR_TYPE_HAGSPAWN_VAR1: { return 1.9623f;} //1043 Skel= P_OOM_Skel Height= 2 Z= 1 SizeCat= 3
				
				case APPEAR_TYPE_DEVEIL_PAELIRYON: { return 0.0f;} //1044
				case APPEAR_TYPE_WERERAT: { return 0.0f;} //1045
				case APPEAR_TYPE_ORBAKH: { return 0.0f;} //1046
				case APPEAR_TYPE_QUELZARN: { return 0.0f;} //1047

			}
			break;
		case 24:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_BEHOLDER: { return 0.0f;} //1201 Skel= c_reeBeholder_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_REE_YUANTIF: { return 0.0f;} //1204 Skel= P_HHF_skel Height= 2 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DRIDER: { return 1.00f;} //1206
				case APPEAR_TYPE_MINOTAUR: { return 1.00f;} //1208
			}
			break;
		case 28:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AZERBLOOD_ROF: { return 1.00f;} //1400;
				case APPEAR_TYPE_FROSTBLOT_ROF: { return 1.00f;} //1401;
				case APPEAR_TYPE_ELDBLOT_ROF: { return 1.00f;} //1402;
				case APPEAR_TYPE_ARCTIC_DWARF_ROF: { return 1.00f;} //1403;
				case APPEAR_TYPE_WILD_DWARF_ROF: { return 1.00f;} //1404;
				case APPEAR_TYPE_TANARUKK_ROF: { return 1.00f;} //1405;
				case APPEAR_TYPE_HOBGOBLIN_ROF: { return 1.00f;} //1407;
				case APPEAR_TYPE_FOREST_GNOME_ROF: { return 1.00f;} //1409;
				case APPEAR_TYPE_YUANTI_HALFBLOOD_ROF: { return 1.00f;} //1410;
				case APPEAR_TYPE_ASABI_ROF: { return 1.00f;} //1411;
				case APPEAR_TYPE_LIZARDFOLD_ROF: { return 1.00f;} //1412;
				case APPEAR_TYPE_OGRE_ROF: { return 1.00f;} //1413;
				case APPEAR_TYPE_PIXIE_ROF: { return 1.00f;} //1414;
				case APPEAR_TYPE_DRAGONKIN_ROF: { return 1.00f;} //1415;
				case APPEAR_TYPE_GLOAMING_ROF: { return 1.00f;} //1416;
				case APPEAR_TYPE_CHAOND_ROF: { return 1.00f;} //1417;
				case APPEAR_TYPE_ELF_DUNE_ROF: { return 1.00f;} //1418;
				case APPEAR_TYPE_BROWNIE_ROF: { return 1.00f;} //1419;
				case APPEAR_TYPE_ULDRA_ROF: { return 1.00f;} //1420;
				case APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF: { return 1.00f;} //1421;
				case APPEAR_TYPE_ELF_POSCADAR_ROF: { return 1.00f;} //1422;
				case APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF: { return 1.00f;} //1423;
				case APPEAR_TYPE_FIRBOLG_ROF: { return 1.00f;} //1424;
				case APPEAR_TYPE_FOMORIAN_ROF: { return 1.00f;} //1425;
				case APPEAR_TYPE_VERBEEG_ROF: { return 1.00f;} //1426;
				case APPEAR_TYPE_VOADKYN_ROF: { return 1.00f;} //1427;
				case APPEAR_TYPE_FJELLBLOT_ROF: { return 1.00f;} //1428;
				case APPEAR_TYPE_TAKEBLOT_ROF: { return 1.00f;} //1429;
				case APPEAR_TYPE_AIR_MEPHLING_ROF: { return 1.00f;} //1430;
				case APPEAR_TYPE_EARTH_MEPHLING_ROF: { return 1.00f;} //1431;
				case APPEAR_TYPE_FIRE_MEPHLING_ROF: { return 1.00f;} //1432;
				case APPEAR_TYPE_WATER_MEPHLING_ROF: { return 1.00f;} //1433;
				case APPEAR_TYPE_KHAASTA_ROF: { return 1.00f;} //1434;
				case APPEAR_TYPE_MOUNTAIN_ORC_ROF: { return 1.00f;} //1435;
				case APPEAR_TYPE_BOOGIN_ROF: { return 1.00f;} //1436;
				case APPEAR_TYPE_ICE_SPIRE_OGRE_ROF: { return 1.00f;} //1437;
				case APPEAR_TYPE_OGRILLON_ROF: { return 1.00f;} //1438;
				case APPEAR_TYPE_KRINTH_ROF: { return 1.00f;} //1439;
				case APPEAR_TYPE_HALFLING_SANDSTORM_ROF: { return 1.00f;} //1440;
				case APPEAR_TYPE_DWARF_DEGLOSIAN_ROF: { return 1.00f;} //1441;
				case APPEAR_TYPE_DWARF_GALDOSIAN_ROF: { return 1.00f;} //1442;
				case APPEAR_TYPE_ELF_ROF: { return 1.00f;} //1443;
				case APPEAR_TYPE_ELF_DRANGONARI_ROF: { return 1.00f;} //1444;
				case APPEAR_TYPE_ELF_GHOST_ROF: { return 1.00f;} //1445;
				case APPEAR_TYPE_FAERIE_ROF: { return 1.00f;} //1446;
				case APPEAR_TYPE_GNOME_ROF: { return 1.00f;} //1447;
				case APPEAR_TYPE_GOBLIN_ROF: { return 1.00f;} //1448;
				case APPEAR_TYPE_HALF_ELF_ROF: { return 1.00f;} //1449;
			}
			break;
		case 29:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_HALF_ORC_ROF: { return 1.00f;} //1450;
				case APPEAR_TYPE_HALFLING_ROF: { return 1.00f;} //1451
				case APPEAR_TYPE_HUMAN_ROF: { return 1.00f;} //1452
				case APPEAR_TYPE_OROG_ROF: { return 1.00f;} //1453
				case APPEAR_TYPE_AELFBORN_ROF: { return 1.00f;} //1454
				case APPEAR_TYPE_FEYRI_ROF: { return 1.00f;} //1455
				case APPEAR_TYPE_SEWER_GOBLIN_ROF: { return 1.00f;} //1456
				case APPEAR_TYPE_WOOD_GENASI_ROF: { return 1.00f;} //1457
				case APPEAR_TYPE_HALF_CELESTIAL_ROF: { return 1.00f;} //1458
				case APPEAR_TYPE_DERRO_ROF: { return 1.00f;} //1459
				case APPEAR_TYPE_HALF_OGRE_ROF: { return 1.00f;} //1460
				case APPEAR_TYPE_DRAGONBORN_ROF: { return 1.00f;} //1461
				case APPEAR_TYPE_URD_ROF: { return 1.00f;} //1462
				case APPEAR_TYPE_CELADRIN_ROF: { return 1.00f;} //1463
				case APPEAR_TYPE_SYLPH_ROF: { return 1.00f;} //1464
				case APPEAR_TYPE_FLAMEBROTHER_ROF: { return 1.00f;} //1465
			}
			break;
		case 30:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RUST_MONSTER: { return 0.6517f;} //1500 Skel= c_rustm_skel Height= 1 Z= 1 SizeCat= 2
				case APPEAR_TYPE_BASILIK: { return 0.8774f;} //1501 Skel= c_basilik_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_SNAKE: { return 0.4675f;} //1502 Skel= c_snake_skel Height= 1 Z= 1 SizeCat= 2
				case APPEAR_TYPE_SCORPION: { return 0.6527f;} //1504 Skel= c_scorpion_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_XORN: { return 2.0998f;} //1505 Skel= c_xorn_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_CARRION_CRAWLER: { return 0.9833f;} //1506 Skel= c_carrion_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_DRACOLICH: { return 4.9091f;} //1507 Skel= c_drglich_skel Height= 1 Z= 1 SizeCat= 5
				case APPEAR_TYPE_DISPLACER_BEAST: { return 1.0741f;} //1508 Skel= c_displacer_skel Height= 1 Z= 1 SizeCat= 4
			}
			break;
		case 40:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RDS_PORTAL: { return 0.0f;} //2041 Skel= c_rdsportal_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_FLYING_BOOK: { return 0.0f;} //2042 Skel= c_flyingbook_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_RAT_CRANIUM: { return 0.0f;} //2043 Skel= c_rat_skel Height= 1 Z= 3 SizeCat= 2
				case APPEAR_TYPE_SLIME: { return 0.0f;} //2044 Skel= c_slime_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_MONODRONE: { return 1.3285f;} //1503
				case APPEAR_TYPE_SPIDER_HOOK: { return 0.0f;} //2046 Skel= c_spid_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_DABUS: { return 0.0f;} //2047 Skel= c_dabus_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_BARIAUR: { return 0.0f;} //2049 Skel= p_ba?_skel Height= 1 Z= 1 SizeCat= 3
								
			}
			break;
		case 41:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DOGDEAD: { return 1.00f;} //2053
				case APPEAR_TYPE_URIDEZU: { return 1.00f;} //2054
				case APPEAR_TYPE_DUODRONE: { return 1.00f;} //2055
				case APPEAR_TYPE_TRIDRONE: { return 1.00f;} //2056
				case APPEAR_TYPE_PENTADRONE: { return 1.00f;} //2057
			}
			break;
		case 46:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GELATINOUS_CUBE: { return 3.0493f;} //2300 Skel= c_cube_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_OOZE: { return 0.0895f;} //2301 Skel= c_ooze_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_HAMMERHEAD_SHARK: { return 1.2219f;} //2302 Skel= c_sharkhm_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_MAKO_SHARK: { return 1.2427f;} //2303 Skel= c_sharkmk_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_MYCONID: { return 2.3355f;} //2304 Skel= c_myconid_skel Height= 1 Z= 1 SizeCat= 3
				
				case APPEAR_TYPE_NAGA: { return 0.0f;} //2305
				case APPEAR_TYPE_PURRLE_WORM: { return 0.0f;} //2306
				case APPEAR_TYPE_STIRGE: { return 0.0f;} //2307
				case APPEAR_TYPE_STIRGE_TINT: { return 0.0f;} //2308
				case APPEAR_TYPE_PURRLE_WORM_TINT: { return 0.0f;} //2309

			}
			break;
		case 60:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GIANT_HILL: { return 3.000f;} //3000 
				case APPEAR_TYPE_GIANT_STONE: { return 3.000f;} //3001
				case APPEAR_TYPE_GIANT_FIRE_ALT: { return 3.000f;} //3002
				case APPEAR_TYPE_GIANT_FROST_ALT: { return 3.000f;} //3003
				case APPEAR_TYPE_GIANT_CLOUD: { return 3.000f;} //3004
				case APPEAR_TYPE_GIANT_FOREST: { return 3.000f;} //3005
				case APPEAR_TYPE_GIANT_STORM: { return 3.000f;} //3006
				
				case APPEAR_TYPE_GIBBERING_MOUTHER: { return 0.0f;} //3010
				case APPEAR_TYPE_BIGBY_GRASPING: { return 0.0f;} //3020
				case APPEAR_TYPE_BIGBY_INTERPOS: { return 0.0f;} //3021
				case APPEAR_TYPE_BIGBY_FIST: { return 0.0f;} //3022
				
			}
			break;
		case 62:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DRAGONMAN: { return 2.3941f;} //3100 Skel= P_HH?_Skel Height= 2 Z= 1.25 SizeCat= 3
				case APPEAR_TYPE_UNICORN: { return 1.73f;} //3101 Skel= c_horse_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_ELEMENTAL_MAGMA: { return 3.1244f;} //3102 Skel= c_elmearth_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_ADAMANTIT: { return 3.0398f;} //3103 Skel= c_elmearth_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_ICE: { return 2.989f;} //3104 Skel= c_elmearth_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_ELEMENTAL_SILVER: { return 3.0679f;} //3105 Skel= c_elmearth_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_FRISCHLING: { return 0.6206f;} //3106 Skel= c_pig_skel Height= 1 Z= 1 SizeCat= 2
				case APPEAR_TYPE_TIGER_01: { return 0.6514f;} //3107 Skel= c_panther_skel Height= 1 Z= 1 SizeCat= 3
				case APPEAR_TYPE_DOG_GERMAN: { return 1.2045f;} //3108 Skel= c_wolf_skel Height= 1 Z= 1 SizeCat= 4
				case APPEAR_TYPE_FOURMI: { return 0.62f;} //3109 Skel= c_gant_skel Height= 1 Z= 1 SizeCat= 2
			}
			break;
		case 68:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_EFREETI: { return 0.0f;} //3400
			}
			break;
	}
	
	return 0.0f;
}



/**  
* this requires appearance include, perhaps add to appearance.2da to prevent this being an issue.
* @author
* @param 
* @see 
* @return 
*/
float CSLGetCreatureHeight( object oTarget )
{
	
	float fBaseHeight = GetLocalFloat( oTarget, "CSL_HEIGHT_"+IntToString( GetAppearanceType(oTarget) ) );
	if ( fBaseHeight == 0.0f )
	{
		// go ahead and cache it to lower the work needed, only an issue on races where i've not yet set a height
		fBaseHeight = CSLGetHeightByAppearance( GetAppearanceType(oTarget) );
		SetLocalFloat( oTarget, "CSL_HEIGHT_"+IntToString( GetAppearanceType(oTarget) ), fBaseHeight );
	}
	float fHeightMod = GetScale(oTarget, SCALE_Z); // might this do the actual effects of the various sizing functions???
	float fScaleZEffectMod = 1.0f;
	
	if ( GetHasSpellEffect( SPELL_ENLARGE_PERSON,oTarget) || GetHasSpellEffect( SPELLABILITY_GRAYENLARGE,oTarget) || GetHasSpellEffect( SPELL_RIGHTEOUS_MIGHT,oTarget) )
	{
		fScaleZEffectMod = 1.5f;
	}
	else if ( GetHasSpellEffect( SPELL_ENTROPIC_HUSK,oTarget) )
	{
		fScaleZEffectMod = 1.2f;
	}
	else if ( GetHasSpellEffect( SPELL_REDUCE_PERSON,oTarget) || GetHasSpellEffect( SPELL_REDUCE_PERSON_GREATER,oTarget) || GetHasSpellEffect( SPELL_REDUCE_ANIMAL,oTarget) || GetHasSpellEffect( SPELL_REDUCE_PERSON_MASS,oTarget) )
	{
		fScaleZEffectMod = 0.63f;
	}	
	
	return (fBaseHeight * fHeightMod * fScaleZEffectMod);
}



/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLScaleAppearance( float fPercentage, object oPC = OBJECT_SELF )
{
	if ( GetIsObjectValid( oPC ) )
	{
		float fScaleX = GetScale(oPC, SCALE_X )*fPercentage;
		float fScaleY = GetScale(oPC, SCALE_Y )*fPercentage;
		float fScaleZ = GetScale(oPC, SCALE_Z )*fPercentage;
		
		SetScale(oPC, fScaleX, fScaleY, fScaleZ );
	}
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// stores the players original appearance
void CSLRestoreTrueAppearance( object oPC = OBJECT_SELF )
{
	// store previous appearance for safety
	string sAppear = GetLocalString(oPC, "CSL_TRUEAPPEARANCE");
	//if (sAppear = ""  )//if original appearance has not been stored, need to make sure this is done when not polymorphed
	//{
	//	sAppear = CSLGetPersistentString(oTarget, "CSL_TRUEAPPEARANCE");
	//}
	
	if (sAppear != ""  )
	{
		CSLUnserializeApplyAppearance( sAppear, oPC );
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLGetSubraceName(int nSubRace)
{
	if ( nSubRace >= 0 && nSubRace <= 25 )
	{
		if (nSubRace==RACIAL_SUBTYPE_GOLD_DWARF				) { return "Gold Dwarf"; } //0;
		if (nSubRace==RACIAL_SUBTYPE_GRAY_DWARF				) { return "Gray Dwarf"; } //1;
		if (nSubRace==RACIAL_SUBTYPE_SHIELD_DWARF			) { return "Shield Dwarf"; } //2;
		if (nSubRace==RACIAL_SUBTYPE_DROW					) { return "Drow"; } //3;
		if (nSubRace==RACIAL_SUBTYPE_MOON_ELF				) { return "Moon Elf"; } //4;
		if (nSubRace==RACIAL_SUBTYPE_SUN_ELF				) { return "Sun Elf"; } //5;
		if (nSubRace==RACIAL_SUBTYPE_WILD_ELF				) { return "Wild Elf"; } //6;
		if (nSubRace==RACIAL_SUBTYPE_WOOD_ELF				) { return "Wood Elf"; } //7;
		if (nSubRace==RACIAL_SUBTYPE_SVIRFNEBLIN			) { return "Svirfneblin"; } //8;
		if (nSubRace==RACIAL_SUBTYPE_ROCK_GNOME				) { return "Rock Gnome"; } //9;
		if (nSubRace==RACIAL_SUBTYPE_GHOSTWISE_HALF			) { return "Ghostwise Halfling"; } //10;
		if (nSubRace==RACIAL_SUBTYPE_LIGHTFOOT_HALF			) { return "Lightfoot Halfling"; } //11;
		if (nSubRace==RACIAL_SUBTYPE_STRONGHEART_HALF		) { return "Strongheart Halfling"; } //12;
		if (nSubRace==RACIAL_SUBTYPE_AASIMAR				) { return "Aasimar"; } //13;
		if (nSubRace==RACIAL_SUBTYPE_TIEFLING				) { return "Tiefling"; } //14;
		if (nSubRace==RACIAL_SUBTYPE_HALFELF				) { return "Half Elf"; } //15;
		if (nSubRace==16									) { return "Half Orc"; } //16; // was having a compile error earlier RACIAL_SUBTYPE_HALFORC
		if (nSubRace==RACIAL_SUBTYPE_HUMAN					) { return "Human"; } //17;
		if (nSubRace==RACIAL_SUBTYPE_AIR_GENASI				) { return "Air Genasi"; } //18;
		if (nSubRace==RACIAL_SUBTYPE_EARTH_GENASI			) { return "Earth Genasi"; } //19;
		if (nSubRace==RACIAL_SUBTYPE_FIRE_GENASI			) { return "Fire Genasi"; } //20;
		if (nSubRace==RACIAL_SUBTYPE_WATER_GENASI			) { return "Water Genasi"; } //21;
		if (nSubRace==RACIAL_SUBTYPE_ABERRATION				) { return "Aberration"; } //22;
		if (nSubRace==RACIAL_SUBTYPE_ANIMAL					) { return "Animal"; } //23;
		if (nSubRace==RACIAL_SUBTYPE_BEAST					) { return "Beast"; } //24;
		if (nSubRace==RACIAL_SUBTYPE_CONSTRUCT				) { return "Construct"; } //25;
	}
	else if ( nSubRace >= 26 && nSubRace <= 99 )
	{
	
		if (nSubRace==RACIAL_SUBTYPE_HUMANOID_GOBLINOID		) { return "Goblin"; } //26;
		if (nSubRace==RACIAL_SUBTYPE_HUMANOID_MONSTROUS		) { return "Humanoid Monstrous"; } //27;
		if (nSubRace==RACIAL_SUBTYPE_HUMANOID_ORC			) { return "Humanoid Orc"; } //28;
		if (nSubRace==RACIAL_SUBTYPE_HUMANOID_REPTILIAN		) { return "Humanoid Reptilian"; } //29;
		if (nSubRace==RACIAL_SUBTYPE_ELEMENTAL				) { return "Elemental"; } //30;
		if (nSubRace==RACIAL_SUBTYPE_FEY					) { return "Fey"; } //31;
		if (nSubRace==RACIAL_SUBTYPE_GIANT					) { return "Giant"; } //32;
		if (nSubRace==RACIAL_SUBTYPE_OUTSIDER				) { return "Outsider"; } //33;
		if (nSubRace==RACIAL_SUBTYPE_SHAPECHANGER			) { return "Shapechanger"; } //34;
		if (nSubRace==RACIAL_SUBTYPE_UNDEAD					) { return "Undead"; } //35;
		if (nSubRace==RACIAL_SUBTYPE_VERMIN					) { return "Vermin"; } //36;
		if (nSubRace==RACIAL_SUBTYPE_OOZE					) { return "Ooze"; } //37;
		if (nSubRace==RACIAL_SUBTYPE_DRAGON					) { return "Dragon"; } //38;
		if (nSubRace==RACIAL_SUBTYPE_MAGICAL_BEAST			) { return "Magical Beast"; } //39
		if (nSubRace==RACIAL_SUBTYPE_INCORPOREAL			) { return "Incorporeal"; } //40
		if (nSubRace==RACIAL_SUBTYPE_GITHYANKI				) { return "Githyanki"; } //41
		if (nSubRace==RACIAL_SUBTYPE_GITHZERAI				) { return "Githzerai"; } //42
		if (nSubRace==RACIAL_SUBTYPE_HALFDROW				) { return "Half Drow"; } //43
		if (nSubRace==RACIAL_SUBTYPE_PLANT					) { return "Plant"; } //44
		if (nSubRace==RACIAL_SUBTYPE_HAGSPAWN				) { return "Hagspawn"; } //45
		if (nSubRace==RACIAL_SUBTYPE_HALFCELESTIAL			) { return "Half Celestial"; } //46
		if (nSubRace==RACIAL_SUBTYPE_YUANTI					) { return "Yuan-Ti Pureblood"; } //47
		if (nSubRace==RACIAL_SUBTYPE_GRAYORC				) { return "Gray Orc"; } //48
		if (nSubRace==RACIAL_SUBTYPE_ELF_STAR				) { return "Star Elf"; } //67
		if (nSubRace==RACIAL_SUBTYPE_PAINTED_ELF		) { return "Painted Elf"; } //68;
	}
	else if ( nSubRace >= 100 && nSubRace <= 175 )
	{
		if (nSubRace==RACIAL_SUBTYPE_MINOTAUR				) { return "Minotaur"; } //122;
		if (nSubRace==RACIAL_SUBTYPE_MOUNTAIN_ORC_ROF		) { return "Star Elf"; } //150;
		if (nSubRace==RACIAL_SUBTYPE_OROG_ROF				) { return "Orog"; } //151;
		if (nSubRace==RACIAL_SUBTYPE_OGRILLON_ROF			) { return "Ogrillon"; } //152;
		if (nSubRace==RACIAL_SUBTYPE_BOOGIN_ROF				) { return "Boogin"; } //153;
		if (nSubRace==RACIAL_SUBTYPE_ODONTI_ROF				) { return "Odonti"; } //154;
		if (nSubRace==RACIAL_SUBTYPE_GOBLIN_ROF				) { return "Goblin"; } //155;
		if (nSubRace==RACIAL_SUBTYPE_HOBGOBLIN_ROF			) { return "HobGoblin"; } //156;
		if (nSubRace==RACIAL_SUBTYPE_BUGBEAR_ROF			) { return "Bugbear"; } //157;
		if (nSubRace==RACIAL_SUBTYPE_ARCTIC_DWARF_ROF		) { return "Artic Dwarf"; } //158;
		if (nSubRace==RACIAL_SUBTYPE_WILD_DWARF_ROF			) { return "Wild Dwarf"; } //159;
		if (nSubRace==RACIAL_SUBTYPE_FOREST_GNOME_ROF		) { return "Forest Gnome"; } //160;
		if (nSubRace==RACIAL_SUBTYPE_HUMAN_DEEP_IMASKARI_ROF ) { return "Deep Imaskari"; } //161;
		if (nSubRace==RACIAL_SUBTYPE_FEYRI_ROF				) { return "Feyri"; } //162;
		if (nSubRace==RACIAL_SUBTYPE_TANARUKK_ROF			) { return "Tanarukk"; } //163;
		if (nSubRace==RACIAL_SUBTYPE_SPRIGGAN_ROF			) { return "Spriiggan"; } //164;
		if (nSubRace==RACIAL_SUBTYPE_WOOD_GENASI_ROF		) { return "Wood Genasi"; } //165;
		if (nSubRace==RACIAL_SUBTYPE_BATIRI_ROF				) { return "Batiri"; } //166;
		if (nSubRace==RACIAL_SUBTYPE_GNOLL_ROF				) { return "Gnoll"; } //167;
		if (nSubRace==RACIAL_SUBTYPE_KOBOLD_ROF				) { return "Kobold"; } //168;
		if (nSubRace==RACIAL_SUBTYPE_AZERBLOOD_ROF			) { return "Azerblood"; } //169;
		if (nSubRace==RACIAL_SUBTYPE_WECHSELBALG_ROF		) { return "Wechselbalg"; } //170;
		if (nSubRace==RACIAL_SUBTYPE_MORTIF_ROF				) { return "Mortif"; } //171;
		if (nSubRace==RACIAL_SUBTYPE_FROSTBLOT_ROF			) { return "Frostblot"; } //172;
		if (nSubRace==RACIAL_SUBTYPE_ELDBLOT_ROF			) { return "Eldblot"; } //173;
		if (nSubRace==RACIAL_SUBTYPE_VARCOLACI_ROF			) { return "Varcolaci"; } //174;
		if (nSubRace==RACIAL_SUBTYPE_KOROBOKURU_ROF			) { return "Korobokuru"; } //175;
	}
	else if ( nSubRace >= 176 && nSubRace <= 199 )
	{	
		if (nSubRace==RACIAL_SUBTYPE_POSCADAR_ROF			) { return "Poscadar"; } //176;
		if (nSubRace==RACIAL_SUBTYPE_JANNLING_ROF			) { return "Jannling"; } //177;
		if (nSubRace==RACIAL_SUBTYPE_YUANTI_HALFBLOOD_ROF	) { return "Yuan Ti"; } //178;
		if (nSubRace==RACIAL_SUBTYPE_EXTAMINAAR_ROF			) { return "Extaminaar"; } //179;
		if (nSubRace==RACIAL_SUBTYPE_OGRE_ROF				) { return "Ogre"; } //180;
		if (nSubRace==RACIAL_SUBTYPE_FIRENEWT_ROF			) { return "Fire Newt"; } //181;
		if (nSubRace==RACIAL_SUBTYPE_ASABI_ROF				) { return "Asabi"; } //182;
		if (nSubRace==RACIAL_SUBTYPE_LIZARDFOLK_ROF			) { return "Lizard Folk"; } //183;
		if (nSubRace==RACIAL_SUBTYPE_SANDSTORM_HALFLING_ROF	) { return "Sand Storm Halfling"; } //184;
		if (nSubRace==RACIAL_SUBTYPE_DUNE_ELF_ROF			) { return "Dune Elf"; } //185;
		if (nSubRace==RACIAL_SUBTYPE_SEWER_GOBLIN_ROF		) { return "Sewer Goblin"; } //186;
		if (nSubRace==RACIAL_SUBTYPE_BROWNIE_ROF			) { return "Brownie"; } //187;
		if (nSubRace==RACIAL_SUBTYPE_ULDRA_ROF				) { return "Uldra"; } //188;
		if (nSubRace==RACIAL_SUBTYPE_DRAGONKIN_ROF			) { return "Dragonkin"; } //189;
		if (nSubRace==RACIAL_SUBTYPE_BLADELING_ROF			) { return "Bladeling"; } //190;
		if (nSubRace==RACIAL_SUBTYPE_DURZAGON_ROF			) { return "Durzagon"; } //191;
		if (nSubRace==RACIAL_SUBTYPE_CHAOND_ROF				) { return "Chaond"; } //192;
		if (nSubRace==RACIAL_SUBTYPE_ZENYTHRI_ROF			) { return "Zenythri"; } //193;
		if (nSubRace==RACIAL_SUBTYPE_TAINTED_ONE_ROF		) { return "Tainted One"; } //194;
		if (nSubRace==RACIAL_SUBTYPE_GLOAMING_ROF			) { return "Gloamling"; } //195;
		if (nSubRace==RACIAL_SUBTYPE_FIRBOLG_ROF			) { return "Firbolg"; } //196;
		if (nSubRace==RACIAL_SUBTYPE_FOMORIAN_ROF			) { return "Fomorian"; } //197;
		if (nSubRace==RACIAL_SUBTYPE_VERBEEG_ROF			) { return "Verbeeg"; } //198;
		if (nSubRace==RACIAL_SUBTYPE_VOADKYN_ROF			) { return "Voadkyn"; } //199;
	}
	else if ( nSubRace >= 200 && nSubRace <= 299 )
	{
		if (nSubRace==RACIAL_SUBTYPE_FJELLBLOT_ROF			) { return "Fjellblot"; } //200;
		if (nSubRace==RACIAL_SUBTYPE_TAKEBLOT_ROF			) { return "Takeblot"; } //201;
		if (nSubRace==RACIAL_SUBTYPE_AIR_MEPHLING_ROF		) { return "Air Mephling"; } //202;
		if (nSubRace==RACIAL_SUBTYPE_EARTH_MEPHLING_ROF		) { return "Earth Mephling"; } //203;
		if (nSubRace==RACIAL_SUBTYPE_FIRE_MEPHLING_ROF		) { return "Fire Mephling"; } //204;
		if (nSubRace==RACIAL_SUBTYPE_WATER_MEPHLING_ROF		) { return "Water Mephling"; } //205;
		if (nSubRace==RACIAL_SUBTYPE_ICE_SPIRE_OGRE_ROF		) { return "Ice Spire Ogre"; } //206;
		if (nSubRace==RACIAL_SUBTYPE_SIND_ROF				) { return "Sind"; } //207;
		if (nSubRace==RACIAL_SUBTYPE_LIZARDKING_ROF			) { return "Lizard King"; } //208;
		if (nSubRace==RACIAL_SUBTYPE_KHAASTA_ROF			) { return "Khaasta"; } //209;
		if (nSubRace==RACIAL_SUBTYPE_TAER_ROF				) { return "Taer"; } //210;
		if (nSubRace==RACIAL_SUBTYPE_ALU_FIEND_ROF			) { return "Alu Fiend"; } //211;
		if (nSubRace==RACIAL_SUBTYPE_CAMBION_ROF			) { return "Cambion"; } //212;
		if (nSubRace==RACIAL_SUBTYPE_KRINTH_ROF				) { return "Krinth"; } //213;
		if (nSubRace==RACIAL_SUBTYPE_AELFBORN_ROF			) { return "Aelfborn"; } //214;
		if (nSubRace==RACIAL_SUBTYPE_VOLODNI_ROF			) { return "Volodni"; } //215;
		if (nSubRace==RACIAL_SUBTYPE_DERRO_ROF				) { return "Derro"; } //216;
		if (nSubRace==RACIAL_SUBTYPE_UNDA_ROF				) { return "Unda"; } //217;
		if (nSubRace==RACIAL_SUBTYPE_WORG_ROF				) { return "Worg"; } //218;
		if (nSubRace==RACIAL_SUBTYPE_HALF_OGRE_ROF			) { return "Half Ogre"; } //219;
		if (nSubRace==RACIAL_SUBTYPE_DRAGONBORN_ROF			) { return "Dragonborn"; } //220;
		if (nSubRace==RACIAL_SUBTYPE_SPELLSCALE_ROF			) { return "Spellscale"; } //221;
		if (nSubRace==RACIAL_SUBTYPE_URD_ROF				) { return "Urd"; } //222;
		if (nSubRace==RACIAL_SUBTYPE_CELADRIN_ROF			) { return "Celadrin"; } //223;
		if (nSubRace==RACIAL_SUBTYPE_DRIDER					) { return "Drider"; } //224;
		if (nSubRace==RACIAL_SUBTYPE_SYLPH_ROF				) { return "Sylph"; } //226;
		if (nSubRace==RACIAL_SUBTYPE_FLAMEBROTHER_ROF		) { return "Flame Brother"; } //227;
		
		
	}
	return "MissSubrace" + IntToString(nSubRace);
}

/*
// this is from gc_check_race_party, kind of crusty and needs to be revamped really
// returns TRUE if the race of anyone in the party corresponds with the race specified.
// race can be specified in two ways: by number or by string.  The number
// is still entered as a string, sRace.
//
// so gc_check_race_party("dwarf") and gc_check_race_dwarf("1") will do the same thing.
// 
*/
int CSLCheckRace(string sRace, object oPM)
{
	int nCheck;
	int nRacialType = GetSubRace(oPM);
	int nRace = StringToInt(sRace);
	
	//SETS OF SUBRACES
	if(sRace == "civdwarves" || nRace == 41)
	{
		return (nRacialType == 1 || nRacialType == 8);
	}
	else if(sRace == "civelves" || nRace == 42)
	{
		return (nRacialType == 2 || nRacialType == 11 || nRacialType == 13);
	}
	else if(sRace == "civhalflings" || nRace == 43)
	{
		return (nRacialType == 5 || nRacialType == 16);
	}
	else if(sRace == "civorcs" || nRace == 44)
	{
		return (nRacialType == 6 || nRacialType == 35);
	}

	//RACES
	else if(sRace == "dwarf" || nRace == 1)
	{
		nCheck = RACIAL_TYPE_DWARF;
	}
	else if (sRace == "elf" || nRace == 2)
	{
		nCheck = RACIAL_TYPE_ELF;
	}
	else if (sRace == "gnome" || nRace == 3)
	{
		nCheck = RACIAL_TYPE_GNOME;
	}
	else if (sRace == "halfelf" || nRace == 4)
	{
		nCheck = RACIAL_TYPE_HALFELF;
	}
	else if (sRace == "halfling" || nRace == 5)
	{
		nCheck = RACIAL_TYPE_HALFLING;
	}
	else if (sRace == "halforc" || nRace == 6)
	{
		nCheck = RACIAL_TYPE_HALFORC;
	}
	else if (sRace == "human" || nRace == 7)
	{
		nCheck = RACIAL_TYPE_HUMAN;
	}
	else if (sRace == "outsider" || nRace == 8)
	{
		nCheck = RACIAL_TYPE_OUTSIDER;
	}
	else if (sRace == "yuanti" || sRace == "yuan-ti" || nRace == 9)
	{
		nCheck = RACIAL_TYPE_YUANTI;
	}


	//SUBRACES
	else if(sRace == "shielddwarf" || nRace == 11)
	{
		nCheck = RACIAL_SUBTYPE_SHIELD_DWARF;
	}
	else if(sRace == "moonelf" || nRace == 12)
	{
		nCheck = RACIAL_SUBTYPE_MOON_ELF;
	}
	else if(sRace == "rockgnome" || nRace == 13)
	{
		nCheck = RACIAL_SUBTYPE_ROCK_GNOME;
	}
	else if(sRace == "halfelf" || nRace == 14)
	{
		nCheck = RACIAL_SUBTYPE_HALFELF;
	}
	else if(GetStringLeft(sRace, 13) == "lightfoothalf" || nRace == 15)
	{
		nCheck = RACIAL_SUBTYPE_LIGHTFOOT_HALF;
	}
	else if(sRace == "halforc" || nRace == 16)
	{
		nCheck = RACIAL_SUBTYPE_HALFORC;
	}
	else if(sRace == "human" || nRace == 17)
	{
		nCheck = RACIAL_SUBTYPE_HUMAN;
	}
	else if(sRace == "golddwarf" || nRace == 18)
	{
		nCheck = RACIAL_SUBTYPE_GOLD_DWARF;
	}
	else if(sRace == "duergar" || nRace == 19)
	{
		nCheck = RACIAL_SUBTYPE_GRAY_DWARF;
	}
	else if(sRace == "drow" || nRace == 20)
	{
		nCheck = RACIAL_SUBTYPE_DROW;
	}
	else if(sRace == "sunelf" || nRace == 21)
	{
		nCheck = RACIAL_SUBTYPE_SUN_ELF;
	}
	else if(sRace == "woodelf" || nRace == 23)
	{
		nCheck = RACIAL_SUBTYPE_WOOD_ELF;
	}
	else if(sRace == "svirfneblin" || nRace == 24)
	{
		nCheck = RACIAL_SUBTYPE_SVIRFNEBLIN;
	}
	else if(GetStringLeft(sRace,16) == "stronghearthalf" || nRace == 26)
	{
		nCheck = RACIAL_SUBTYPE_STRONGHEART_HALF;
	}
	else if(sRace == "aasimar" || nRace == 27)
	{
		nCheck = RACIAL_SUBTYPE_AASIMAR;
	}
	else if(sRace == "tiefling" || nRace == 28)
	{
		nCheck = RACIAL_SUBTYPE_TIEFLING;
	}
	else if(sRace == "halfdrow" || nRace == 29)
	{
		nCheck = 43; // Half-Drow
	}
	else if(sRace == "wildelf" || nRace == 30)
	{
		nCheck = RACIAL_SUBTYPE_WILD_ELF;
	}
	else if(sRace == "firegenasi" || nRace == 31)
	{
		nCheck = RACIAL_SUBTYPE_FIRE_GENASI;
	}
	else if(sRace == "watergenasi" || nRace == 32)
	{
		nCheck = RACIAL_SUBTYPE_WATER_GENASI;
	}
	else if(sRace == "earthgenasi" || nRace == 33)
	{
		nCheck = RACIAL_SUBTYPE_EARTH_GENASI;
	}
	else if(sRace == "airgenasi" || nRace == 34)
	{
		nCheck = RACIAL_SUBTYPE_AIR_GENASI;
	}
	else if(sRace == "grayorc" || sRace == "greyorc" || nRace == 35)
	{
		nCheck = RACIAL_SUBTYPE_GRAYORC;
	}

	nRacialType = GetRacialType(oPM);

	return (nRacialType == nCheck);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLGetRaceName(int nRace)
{
	if (nRace==RACIAL_TYPE_DWARF				) { return "Dwarf"; } // 0
	if (nRace==RACIAL_TYPE_ELF					) { return "Elf"; } // 1
	if (nRace==RACIAL_TYPE_GNOME				) { return "Gnome"; } // 2
	if (nRace==RACIAL_TYPE_HALFLING				) { return "Halfling"; } // 3
	if (nRace==RACIAL_TYPE_HALFELF				) { return "Halfelf"; } // 4
	if (nRace==RACIAL_TYPE_HALFORC				) { return "Halforc"; } // 5
	if (nRace==RACIAL_TYPE_HUMAN				) { return "Human"; } // 6	
	if (nRace==RACIAL_TYPE_ABERRATION			) { return "Aberration"; } // 7
	if (nRace==RACIAL_TYPE_ANIMAL				) { return "Animal"; } // 8
	if (nRace==RACIAL_TYPE_BEAST				) { return "Beast"; } // 9
	if (nRace==RACIAL_TYPE_CONSTRUCT			) { return "Construct"; } // 10
	if (nRace==RACIAL_TYPE_DRAGON				) { return "Dragon"; } // 11
	if (nRace==RACIAL_TYPE_HUMANOID_GOBLINOID	) { return "Goblin"; } // 12
	if (nRace==RACIAL_TYPE_HUMANOID_MONSTROUS	) { return "Monstrous"; } // 13
	if (nRace==RACIAL_TYPE_HUMANOID_ORC			) { return "Orc"; } // 14
	if (nRace==RACIAL_TYPE_HUMANOID_REPTILIAN	) { return "Reptilian"; } // 15
	if (nRace==RACIAL_TYPE_ELEMENTAL			) { return "Elemental"; } // 16
	if (nRace==RACIAL_TYPE_FEY					) { return "Fey"; } // 17	
	if (nRace==RACIAL_TYPE_GIANT				) { return "Giant"; } // 18
	if (nRace==RACIAL_TYPE_MAGICAL_BEAST		) { return "Magical Beast"; } // 19
	if (nRace==RACIAL_TYPE_OUTSIDER				) { return "Outsider"; } // 20
	if (nRace==RACIAL_TYPE_PLANETOUCHED			) { return "Planetouched"; } // 21
	if (nRace==RACIAL_TYPE_PLANT				) { return "Plant"; } // 22
	if (nRace==RACIAL_TYPE_SHAPECHANGER			) { return "Shapechanger"; } // 23
	if (nRace==RACIAL_TYPE_UNDEAD				) { return "Undead"; } // 24
	if (nRace==RACIAL_TYPE_VERMIN				) { return "Vermin"; } // 25
	if (nRace==RACIAL_TYPE_OOZE					) { return "Ooze"; } // 29
	if (nRace==RACIAL_TYPE_INCORPOREAL			) { return "Incorporeal"; } // 30
	if (nRace==RACIAL_TYPE_YUANTI				) { return "YuantiPureblood"; } //31
	if (nRace==RACIAL_TYPE_GRAYORC				) { return "GrayOrc"; } // 32
	if (nRace==RACIAL_TYPE_FEYTOUCHED			) { return "Fey Touched"; } // 50;
	if (nRace==RACIAL_TYPE_DEATHTOUCHED			) { return "Death Touched"; } // 51;
	if (nRace==RACIAL_TYPE_JOTUNBLOT			) { return "Jotunblot"; } // 52;
	if (nRace==RACIAL_TYPE_HUMANOID_EXTRAPLANAR	) { return "Extraplanar Humanoid"; } // 53;
	if (nRace==RACIAL_TYPE_DRAGONBLOOD			) { return "Dragon Blood"; } // 54;
	if (nRace==RACIAL_TYPE_BARIAUR				) { return "Bariaur"; } // 101;
	return "MissRace" + IntToString(nRace);
}


/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLGetFullRaceName(object oPC)
{
	string sRace = CSLGetRaceName(GetRacialType(oPC));
	string sSub = CSLGetSubraceName(GetSubRace(oPC));
	if (sRace==sSub) return sRace;
	return sRace + ": " + sSub;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLGetStringByAppearance( int iAppearanceType )
{
	// int iAppearanceType = GetAppearanceType(oTarget);
	if ( iAppearanceType == -1 ) { return "Invalid"; }
	
	iAppearanceType = CSLGetBaseAppearance( iAppearanceType );
	
	int iSubAppearance = iAppearanceType / 50;
	switch(iSubAppearance)
	{
		case 0:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DWARF: { return "Dwarf";} //0
				case APPEAR_TYPE_ELF: { return "Elf";} //1
				case APPEAR_TYPE_GNOME: { return "Gnome";} //2
				case APPEAR_TYPE_HALFLING: { return "Halfling";} //3
				case APPEAR_TYPE_HALF_ELF: { return "Half Elf";} //4
				case APPEAR_TYPE_HALF_ORC: { return "Half Orc";} //5
				case APPEAR_TYPE_HUMAN: { return "Human";} //6
				case APPEAR_TYPE_HORSE_BROWN: { return "Horse, Brown";} //7
				case APPEAR_TYPE_BADGER: { return "Badger";} //8
				case APPEAR_TYPE_BADGER_DIRE: { return "Badger, Dire";} //9
				case APPEAR_TYPE_BAT: { return "Bat";} //10
				case APPEAR_TYPE_HORSE_PINTO: { return "Horse, Pinto";} //11
				case APPEAR_TYPE_HORSE_SKELETAL: { return "Horse, Skeletal";} //12
				case APPEAR_TYPE_BEAR_BROWN: { return "Bear, Brown";} //13
				case APPEAR_TYPE_HORSE_PALOMINO: { return "Horse, Palomino";} //14
				case APPEAR_TYPE_BEAR_DIRE: { return "Bear, Dire";} //15
				case APPEAR_TYPE_DRAGON__BRONZE: { return "Dragon, Bronze";} //16
				case APPEAR_TYPE_YOUNG_BRONZE: { return "Young Bronze";} //17
				case APPEAR_TYPE_BEETLE_FIRE: { return "Beetle Fire";} //18
				case APPEAR_TYPE_BEETLE_STAG: { return "Beetle Stag";} //19
				case APPEAR_TYPE_YOUNG_BLUE: { return "Young Blue";} //20
				case APPEAR_TYPE_BOAR: { return "Boar";} //21
				case APPEAR_TYPE_BOAR_DIRE: { return "Boar, Dire";} //22
				case APPEAR_TYPE_YUANTI_ABOMINATION: { return "Yuan-Ti, Abomination";} //23
				case APPEAR_TYPE_WORG: { return "Worg";} //24
				case APPEAR_TYPE_YUANTI_HOLYGUARDIAN: { return "Yuan-Ti, HolyGuardian";} //25
				case APPEAR_TYPE_PLANETAR: { return "Planetar";} //26
				case APPEAR_TYPE_WILLOWISP: { return "Will-O-Wisp";} //27
				case APPEAR_TYPE_FIRE_NEWT: { return "Fire Newt";} //28
				case APPEAR_TYPE_DROWNED: { return "Drowned";} //29
				case APPEAR_TYPE_MEGARAPTOR: { return "Megaraptor";} //30
				case APPEAR_TYPE_CHICKEN: { return "Chicken";} //31
				case APPEAR_TYPE_WIGHT: { return "Wight";} //32
				case APPEAR_TYPE_CLOCKROACH: { return "Clockroach";} //33
				case APPEAR_TYPE_COW: { return "Cow";} //34
				case APPEAR_TYPE_DEER: { return "Deer";} //35
				case APPEAR_TYPE_DEINONYCHUS: { return "Deinonychus";} //36
				case APPEAR_TYPE_DEER_STAG: { return "Deer,Stag";} //37
				case APPEAR_TYPE_BATIRI: { return "Batiri";} //38
				case APPEAR_TYPE_LICH: { return "Lich";} //39
				case APPEAR_TYPE_YUANTIPUREBLOOD: { return "Yuanti, Pureblood";} //40
				case APPEAR_TYPE_DRAGON_BLACK: { return "Dragon, Black";} //41
				case APPEAR_TYPE_WAGON_LIGHT01: { return "Wagon, Light01";} //42
				case APPEAR_TYPE_WAGON_LIGHT02: { return "Wagon, Light02";} //43
				case APPEAR_TYPE_WAGON_LIGHT03: { return "Wagon, Light03";} //44
				case APPEAR_TYPE_GRAYORC: { return "GrayOrc";} //45
				case APPEAR_TYPE_YUANTI_HERALD: { return "Yuan-Ti Herald";} //46
				case APPEAR_TYPE_NPC_SASANI: { return "NPC Sasani";} //47
				case APPEAR_TYPE_NPC_VOLO: { return "NPC Volo";} //48
				case APPEAR_TYPE_DRAGON_RED: { return "Dragon Red";} //49
			}
			break;
		case 1:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_SEPTIMUND: { return "NPC Septimund";} //50
				case APPEAR_TYPE_DRYAD: { return "Dryad";} //51
				case APPEAR_TYPE_ELEMENTAL_AIR: { return "Elemental, Air";} //52
				case APPEAR_TYPE_ELEMENTAL_AIR_ELDER: { return "Elemental, Air Elder";} //53
				case APPEAR_TYPE_ELEMENTAL_EARTH: { return "Elemental, Earth";} //56
				case APPEAR_TYPE_ELEMENTAL_EARTH_ELDER: { return "Elemental, Earth Elder";} //57
				case APPEAR_TYPE_MUMMY_COMMON: { return "Mummy, Common";} //58
				case APPEAR_TYPE_ELEMENTAL_FIRE: { return "Elemental, Fire";} //60
				case APPEAR_TYPE_ELEMENTAL_FIRE_ELDER: { return "Elemental, Fire Elder";} //61
				case APPEAR_TYPE_ELEMENTAL_WATER_ELDER: { return "Elemental, Water Elder";} //68
				case APPEAR_TYPE_ELEMENTAL_WATER: { return "Elemental, Water";} //69
				case APPEAR_TYPE_GARGOYLE: { return "Gargoyle";} //73
				case APPEAR_TYPE_GHAST: { return "Ghast";} //74
				case APPEAR_TYPE_GHOUL: { return "Ghoul";} //76
				case APPEAR_TYPE_GIANT_FIRE: { return "Giant, Fire";} //80
				case APPEAR_TYPE_GIANT_FROST: { return "Giant, Frost";} //81
				case APPEAR_TYPE_GOLEM_IRON: { return "Golem, Iron";} //89
			}
			break;
		case 2:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VROCK: { return "Vrock";} //101
				
				case APPEAR_TYPE_IMP: { return "Imp";} //105
				case APPEAR_TYPE_MEPHIT_FIRE: { return "Mephit, Fire";} //109
				case APPEAR_TYPE_MEPHIT_ICE: { return "Mephit, Ice";} //110
				case APPEAR_TYPE_OGRE: { return "Ogre";} //127
				case APPEAR_TYPE_OGRE_MAGE: { return "Ogre Mage";} //129
				case APPEAR_TYPE_ORC_A: { return "Orc A";} //140
			}
			break;
		case 3:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SLAAD_BLUE: { return "Slaad, Blue";} //151
				case APPEAR_TYPE_SLAAD_GREEN: { return "Slaad, Green";} //154
				
				case APPEAR_TYPE_SPECTRE: { return "Spectre";} //156
				case APPEAR_TYPE_SPIDER_DIRE: { return "Spider, Dire";} //158
				case APPEAR_TYPE_SPIDER_GIANT: { return "Spider, Giant";} //159
				case APPEAR_TYPE_SPIDER_PHASE: { return "Spider, Phase";} //160
				case APPEAR_TYPE_SPIDER_BLADE: { return "Spider, Blade";} //161
				case APPEAR_TYPE_SPIDER_WRAITH: { return "Spider, Wraith";} //162
				case APPEAR_TYPE_SUCCUBUS: { return "Succubus";} //163
				case APPEAR_TYPE_TROLL: { return "Troll";} //167
				case APPEAR_TYPE_UMBERHULK: { return "Umberhulk";} //168
				case APPEAR_TYPE_WEREWOLF: { return "Werewolf";} //171
				case APPEAR_TYPE_DOG_DIRE_WOLF: { return "Dog, Dire Wolf";} //175
				case APPEAR_TYPE_DOG_HELL_HOUND: { return "Dog, Hell Hound";} //179
				case APPEAR_TYPE_DOG_SHADOW_MASTIF: { return "Dog, Shadow Mastif";} //180
				case APPEAR_TYPE_DOG_WOLF: { return "Dog, Wolf";} //181
				case APPEAR_TYPE_DOG_WINTER_WOLF: { return "Dog, Winter Wolf";} //184
				case APPEAR_TYPE_DREAD_WRAITH: { return "Dread Wraith";} //186
				case APPEAR_TYPE_WRAITH: { return "Wraith";} //187
				case APPEAR_TYPE_ZOMBIE: { return "Zombie";} //198
			}
			break;
		case 5:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VAMPIRE_FEMALE: { return "Vampire, Female";} //288
				case APPEAR_TYPE_VAMPIRE_MALE: { return "Vampire, Male";} //289
			}
			break;
		case 7:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RAT: { return "Rat";} //386
				case APPEAR_TYPE_RAT_DIRE: { return "Rat, Dire";} //387
				
			}
			break;
		case 8:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_MINDFLAYER: { return "Mindflayer";} //413
				
			}
			break;
		case 9:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DEVIL_HORNED: { return "Devil, Horned";} //481
				case APPEAR_TYPE_SPIDER_BONE: { return "Spider Bone";} //482
				case APPEAR_TYPE_GITHYANKI: { return "Githyanki";} //483
				case APPEAR_TYPE_BIRD: { return "Bird";} //485
				case APPEAR_TYPE_BLADELING: { return "Bladeling";} //486
				case APPEAR_TYPE_CAT: { return "Cat";} //487
				case APPEAR_TYPE_DEMON_HEZROU: { return "Demon, Hezrou";} //488
				case APPEAR_TYPE_DEVIL_PITFIEND: { return "Devil, PitFiend";} //489
				case APPEAR_TYPE_GOLEM_BLADE: { return "Golem Blade";} //493
				case APPEAR_TYPE_SHADOW: { return "Shadow";} //496
				case APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER: { return "Nightshade Nightwalker";} //497
				case APPEAR_TYPE_PIG: { return "Pig";} //498
				case APPEAR_TYPE_RABBIT: { return "Rabbit";} //499
			}
			break;
		case 10:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SHADOW_REAVER: { return "Shadow Reaver";} //500
				case APPEAR_TYPE_WEASEL: { return "Weasel";} //503
				case APPEAR_TYPE_SYLPH: { return "Sylph";} //512
				case APPEAR_TYPE_DEVIL_ERINYES: { return "Devil, Erinyes";} //514
				case APPEAR_TYPE_PIXIE: { return "Pixie";} //521
				case APPEAR_TYPE_DEMON_BALOR: { return "Demon, Balor";} //522
				case APPEAR_TYPE_GNOLL: { return "Gnoll";} //533
				case APPEAR_TYPE_GOBLIN: { return "Goblin";} //534
				case APPEAR_TYPE_KOBOLD: { return "Kobold";} //535
				case APPEAR_TYPE_LIZARDFOLK: { return "Lizardfolk";} //536
				case APPEAR_TYPE_SKELETON: { return "Skeleton";} //537
				case APPEAR_TYPE_BEETLE_BOMBARDIER: { return "Beetle, Bombardier";} //538
				case APPEAR_TYPE_BUGBEAR: { return "Bugbear";} //543
				case APPEAR_TYPE_NPC_GARIUS: { return "NPC Garius";} //544
				case APPEAR_TYPE_SPIDER_GLOW: { return "Spider, Glow";} //546
				case APPEAR_TYPE_SPIDER_KRISTAL: { return "Spider, Kristal";} //547
				case APPEAR_TYPE_NPC_DUNCAN: { return "NPC Duncan";} //549	
			}
			break;
		case 11:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_LORDNASHER: { return "NPC LordNasher";} //550
				case APPEAR_TYPE_NPC_CHILDHHM: { return "NPC ChildHHM";} //551
				case APPEAR_TYPE_NPC_CHILDHHF: { return "NPC ChildHHF";} //553
				case APPEAR_TYPE_ELEMENTAL_AIR_HUGE: { return "Elemental, Air Huge";} //554
				case APPEAR_TYPE_ELEMENTAL_AIR_GREATER: { return "Elemental, Air Greater";} //555
				case APPEAR_TYPE_ELEMENTAL_EARTH_HUGE: { return "Elemental, Earth Huge";} //556
				case APPEAR_TYPE_ELEMENTAL_EARTH_GREATER: { return "Elemental, Earth Greater";} //557
				case APPEAR_TYPE_ELEMENTAL_FIRE_HUGE: { return "Elemental, Fire Huge";} //558
				case APPEAR_TYPE_ELEMENTAL_FIRE_GREATER: { return "Elemental, Fire Greater";} //559
				case APPEAR_TYPE_ELEMENTAL_WATER_HUGE: { return "Elemental, Water Huge";} //560
				case APPEAR_TYPE_ELEMENTAL_WATER_GREATER: { return "Elemental, Water Greater";} //561
				case APPEAR_TYPE_SIEGETOWER: { return "Siegetower";} //562
				case APPEAR_TYPE_ASSIMAR: { return "Assimar";} //563
				case APPEAR_TYPE_TIEFLING: { return "Tiefling";} //564
				case APPEAR_TYPE_ELF_SUN: { return "Elf, Sun";} //565
				case APPEAR_TYPE_ELF_WOOD: { return "Elf, Wood";} //566
				case APPEAR_TYPE_ELF_DROW: { return "Elf, Drow";} //567
				case APPEAR_TYPE_GNOME_SVIRFNEBLIN: { return "Gnome, Svirfneblin";} //568
				case APPEAR_TYPE_DWARF_GOLD: { return "Dwarf, Gold";} //569
				case APPEAR_TYPE_DWARF_DUERGAR: { return "Dwarf, Duergar";} //570
				case APPEAR_TYPE_HALFLING_STRONGHEART: { return "Halfling, Strongheart";} //571
				case APPEAR_TYPE_CARGOSHIP: { return "CargoShip";} //572
				case APPEAR_TYPE_N_HUMAN: { return "N Human";} //573
				case APPEAR_TYPE_N_ELF: { return "N Elf";} //574
				case APPEAR_TYPE_N_DWARF: { return "N Dwarf";} //575
				case APPEAR_TYPE_N_HALF_ELF: { return "N Half Elf";} //576
				case APPEAR_TYPE_N_GNOME: { return "N Gnome";} //577
				case APPEAR_TYPE_N_TIEFLING: { return "N Tiefling";} //578
				case APPEAR_TYPE_NPC_GITHCAPTAIN: { return "NPC GithCaptain";} //579
				case APPEAR_TYPE_NPC_LORNE: { return "NPC Lorne";} //580
				case APPEAR_TYPE_NPC_TENAVROK: { return "NPC Tenavrok";} //581
				case APPEAR_TYPE_NPC_CTANN: { return "NPC Ctann";} //582
				case APPEAR_TYPE_NPC_SHANDRA: { return "NPC Shandra";} //583
				case APPEAR_TYPE_NPC_ZEEAIRE: { return "NPC Zeeaire";} //584
				case APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT: { return "NPC Zeeaire's Lieutenant";} //585
				case APPEAR_TYPE_NPC_KINGOFSHADOWS: { return "NPC KingofShadows";} //586
				case APPEAR_TYPE_NPC_NOLALOTH: { return "NPC Nolaloth";} //587
				case APPEAR_TYPE_NPC_ZHJAEVE: { return "NPC Zhjaeve";} //588
				case APPEAR_TYPE_NPC_ZAXIS: { return "NPC Zaxis";} //589
				case APPEAR_TYPE_NPC_AHJA: { return "NPC Ahja";} //590
				case APPEAR_TYPE_NPC_DURLER: { return "NPC Durler";} //591
				case APPEAR_TYPE_NPC_HEZEBEL: { return "NPC Hezebel";} //592
				case APPEAR_TYPE_NPC_HOSTTOWER: { return "NPC HostTower";} //593
				case APPEAR_TYPE_NPC_ZOKAN: { return "NPC Zokan";} //594
				case APPEAR_TYPE_NPC_ALDANON: { return "NPC Aldanon";} //595
				case APPEAR_TYPE_NPC_JACOBY: { return "NPC Jacoby";} //596
				case APPEAR_TYPE_NPC_JALBOUN: { return "NPC Jalboun";} //597
				case APPEAR_TYPE_NPC_KHRALVER: { return "NPC Khralver";} //598
				case APPEAR_TYPE_NPC_KRALWOK: { return "NPC Kralwok";} //599
			}
			break;
		case 12:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_MEPHASM: { return "NPC Mephasm";} //600
				case APPEAR_TYPE_NPC_MORKAI: { return "NPC Morkai";} //601
				case APPEAR_TYPE_NPC_SARYA: { return "NPC Sarya";} //602
				case APPEAR_TYPE_NPC_SYDNEY: { return "NPC Sydney";} //603
				case APPEAR_TYPE_NPC_TORIOCLAVEN: { return "NPC Torio Claven";} //604
				case APPEAR_TYPE_NPC_UTHANCK: { return "NPC Uthanck";} //605
				case APPEAR_TYPE_NPC_SHADOWPRIEST: { return "NPC Shadow Priest";} //606
				case APPEAR_TYPE_NPC_HUNTERSTATUE: { return "NPC Hunter Statue";} //607
				case APPEAR_TYPE_SIEGETOWERB: { return "Siegetower B";} //608
				case APPEAR_TYPE_PUSHBLOCK: { return "Push Block";} //609
				case APPEAR_TYPE_SMUGGLERWAGON: { return "Smuggler Wagon";} //610
				case APPEAR_TYPE_INVISIBLEMAN: { return "InvisibleMan";} //611
			}
			break;
		case 20:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AKACHI: { return "Akachi";} //1000
				case APPEAR_TYPE_OKKU_BEAR: { return "Okku, Bear";} //1001
				case APPEAR_TYPE_PANTHER: { return "Panther";} //1002
				case APPEAR_TYPE_WOLVERINE: { return "Wolverine";} //1003
				case APPEAR_TYPE_INVISIBLE_STALKER: { return "Invisible, Stalker";} //1004
				case APPEAR_TYPE_HOMUNCULUS: { return "Homunculus";} //1005
				case APPEAR_TYPE_GOLEM_IMASKARI: { return "Golem, Imaskari";} //1006
				case APPEAR_TYPE_RED_WIZ_COMPANION: { return "Red Wiz Companion";} //1007
				case APPEAR_TYPE_DEATH_KNIGHT: { return "Death Knight";} //1008
				case APPEAR_TYPE_BARROW_GUARDIAN: { return "Barrow Guardian";} //1009
				case APPEAR_TYPE_SEA_MONSTER: { return "Sea Monster";} //1010
				case APPEAR_TYPE_ONE_OF_MANY: { return "One Of Many";} //1011
				case APPEAR_TYPE_SHAMBLING_MOUND: { return "Shambling Mound";} //1012
				case APPEAR_TYPE_SOLAR: { return "Solar";} //1013
				case APPEAR_TYPE_WOLVERINE_DIRE: { return "Wolverine, Dire";} //1014
				case APPEAR_TYPE_DRAGON_BLUE: { return "Dragon, Blue";} //1015
				case APPEAR_TYPE_DJINN: { return "Djinn";} //1016
				case APPEAR_TYPE_GNOLL_THAYAN: { return "Gnoll, Thayan";} //1017
				case APPEAR_TYPE_GOLEM_CLAY: { return "Golem, Clay";} //1018
				case APPEAR_TYPE_GOLEM_FAITHLESS: { return "Golem, Faithless";} //1019
				case APPEAR_TYPE_DEMILICH: { return "Demilich";} //1020
				case APPEAR_TYPE_HAG_ANNIS: { return "Hag, Annis";} //1021
				case APPEAR_TYPE_HAG_GREEN: { return "Hag, Green";} //1022
				case APPEAR_TYPE_HAG_NIGHT: { return "Hag, Night";} //1023
				case APPEAR_TYPE_HORSE_WHITE: { return "Horse, White";} //1024
				case APPEAR_TYPE_DEMILICH_SMALL: { return "Demilich, Small";} //1025
				case APPEAR_TYPE_LEOPARD_SNOW: { return "Leopard, Snow";} //1026
				case APPEAR_TYPE_TREANT: { return "Treant";} //1027
				case APPEAR_TYPE_TROLL_FELL: { return "Troll, Fell";} //1028
				case APPEAR_TYPE_UTHRAKI: { return "Uthraki";} //1029
				case APPEAR_TYPE_WYVERN: { return "Wyvern";} //1030
				case APPEAR_TYPE_RAVENOUS_INCARNATION: { return "Ravenous Incarnation";} //1031
				case APPEAR_TYPE_N_ELF_WILD: { return "N Elf Wild";} //1032
				case APPEAR_TYPE_N_HALF_DROW: { return "N Half Drow";} //1033
				case APPEAR_TYPE_MAGDA: { return "Magda";} //1034
				case APPEAR_TYPE_NEFRIS: { return "Nefris";} //1035
				case APPEAR_TYPE_ELF_WILD: { return "Elf, Wild";} //1036
				case APPEAR_TYPE_EARTH_GENASI: { return "Earth, Genasi";} //1037
				case APPEAR_TYPE_FIRE_GENASI: { return "Fire, Genasi";} //1038
				case APPEAR_TYPE_AIR_GENASI: { return "Air, Genasi";} //1039
				case APPEAR_TYPE_WATER_GENASI: { return "Water, Genasi";} //1040
				case APPEAR_TYPE_HALF_DROW: { return "Half, Drow";} //1041
				case APPEAR_TYPE_DOG_WOLF_TELTHOR: { return "Dog Wolf, Telthor";} //1042
				case APPEAR_TYPE_HAGSPAWN_VAR1: { return "Hagspawn, Var1";} //1043
				
				case APPEAR_TYPE_DEVEIL_PAELIRYON: { return "Devil, Paeliryon";} //1044
				case APPEAR_TYPE_WERERAT: { return "Wererat";} //1045
				case APPEAR_TYPE_ORBAKH: { return "Orbakh";} //1046
				case APPEAR_TYPE_QUELZARN: { return "Quelzarn";} //1047
				
				
				}
			break;
		
		case 24:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_BEHOLDER: { return "Beholder";} //1201
				case APPEAR_TYPE_REE_YUANTIF: { return "Yuanti, Female Ree";} //1204
				case APPEAR_TYPE_DRIDER: { return "Drider";} //1206
				case APPEAR_TYPE_MINOTAUR: { return "Minotaur";} //1208
			}
			break;
			
			
		case 28:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AZERBLOOD_ROF: { return "Azerblood";} //1400;
				case APPEAR_TYPE_FROSTBLOT_ROF: { return "Frostblot";} //1401;
				case APPEAR_TYPE_ELDBLOT_ROF: { return "Eldblot";} //1402;
				case APPEAR_TYPE_ARCTIC_DWARF_ROF: { return "Dwarf, Arctic";} //1403;
				case APPEAR_TYPE_WILD_DWARF_ROF: { return "Dwarf, Wild";} //1404;
				case APPEAR_TYPE_TANARUKK_ROF: { return "Tanarukk";} //1405;
				case APPEAR_TYPE_HOBGOBLIN_ROF: { return "Hobgoblin";} //1407;
				case APPEAR_TYPE_FOREST_GNOME_ROF: { return "Gnome, Forest";} //1409;
				case APPEAR_TYPE_YUANTI_HALFBLOOD_ROF: { return "Yuanti, Halfblood";} //1410;
				case APPEAR_TYPE_ASABI_ROF: { return "Asabi";} //1411;
				case APPEAR_TYPE_LIZARDFOLD_ROF: { return "Lizardfolk";} //1412;
				case APPEAR_TYPE_OGRE_ROF: { return "Ogre";} //1413;
				case APPEAR_TYPE_PIXIE_ROF: { return "Pixie";} //1414;
				case APPEAR_TYPE_DRAGONKIN_ROF: { return "Dragonkin";} //1415;
				case APPEAR_TYPE_GLOAMING_ROF: { return "Gloaming";} //1416;
				case APPEAR_TYPE_CHAOND_ROF: { return "Chaond";} //1417;
				case APPEAR_TYPE_ELF_DUNE_ROF: { return "Elf, Dune";} //1418;
				case APPEAR_TYPE_BROWNIE_ROF: { return "Brownie";} //1419;
				case APPEAR_TYPE_ULDRA_ROF: { return "Uldra";} //1420;
				case APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF: { return "Half Fiend, Durzagon";} //1421;
				case APPEAR_TYPE_ELF_POSCADAR_ROF: { return "Elf, Poscadar";} //1422;
				case APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF: { return "Human, Deep Imaskari";} //1423;
				case APPEAR_TYPE_FIRBOLG_ROF: { return "Firbolg";} //1424;
				case APPEAR_TYPE_FOMORIAN_ROF: { return "Fomorian";} //1425;
				case APPEAR_TYPE_VERBEEG_ROF: { return "Verbeeg";} //1426;
				case APPEAR_TYPE_VOADKYN_ROF: { return "Voadkyn";} //1427;
				case APPEAR_TYPE_FJELLBLOT_ROF: { return "Fjellblot";} //1428;
				case APPEAR_TYPE_TAKEBLOT_ROF: { return "Takeblot";} //1429;
				case APPEAR_TYPE_AIR_MEPHLING_ROF: { return "Mephling, Air";} //1430;
				case APPEAR_TYPE_EARTH_MEPHLING_ROF: { return "Mephling, Earth";} //1431;
				case APPEAR_TYPE_FIRE_MEPHLING_ROF: { return "Mephling, Fire";} //1432;
				case APPEAR_TYPE_WATER_MEPHLING_ROF: { return "Mephling, Water";} //1433;
				case APPEAR_TYPE_KHAASTA_ROF: { return "Khaasta";} //1434;
				case APPEAR_TYPE_MOUNTAIN_ORC_ROF: { return "Orc, Mountain";} //1435;
				case APPEAR_TYPE_BOOGIN_ROF: { return "Boogin";} //1436;
				case APPEAR_TYPE_ICE_SPIRE_OGRE_ROF: { return "Ogre, Ice Spire";} //1437;
				case APPEAR_TYPE_OGRILLON_ROF: { return "Ogrillon";} //1438;
				case APPEAR_TYPE_KRINTH_ROF: { return "Krinth";} //1439;
				case APPEAR_TYPE_HALFLING_SANDSTORM_ROF: { return "Halfling, Sandstorm";} //1440;
				case APPEAR_TYPE_DWARF_DEGLOSIAN_ROF: { return "Dwarf, Deglosian";} //1441;
				case APPEAR_TYPE_DWARF_GALDOSIAN_ROF: { return "Dwarf, Galdosian";} //1442;
				case APPEAR_TYPE_ELF_ROF: { return "Elf";} //1443;
				case APPEAR_TYPE_ELF_DRANGONARI_ROF: { return "Elf, Drangonari";} //1444;
				case APPEAR_TYPE_ELF_GHOST_ROF: { return "Elf, Ghost";} //1445;
				case APPEAR_TYPE_FAERIE_ROF: { return "Faerie";} //1446;
				case APPEAR_TYPE_GNOME_ROF: { return "Gnome";} //1447;
				case APPEAR_TYPE_GOBLIN_ROF: { return "Goblin";} //1448;
				case APPEAR_TYPE_HALF_ELF_ROF: { return "Half Elf";} //1449;
			}
			break;
		case 29:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_HALF_ORC_ROF: { return "Half Orc";} //1450;
				case APPEAR_TYPE_HALFLING_ROF: { return "Halfling";} //1451
				case APPEAR_TYPE_HUMAN_ROF: { return "Human";} //1452
				case APPEAR_TYPE_OROG_ROF: { return "Orog";} //1453
				case APPEAR_TYPE_AELFBORN_ROF: { return "Aelfborn";} //1454
				case APPEAR_TYPE_FEYRI_ROF: { return "Feyri";} //1455
				case APPEAR_TYPE_SEWER_GOBLIN_ROF: { return "Goblin";} //1456
				case APPEAR_TYPE_WOOD_GENASI_ROF: { return "Genasi";} //1457
				case APPEAR_TYPE_HALF_CELESTIAL_ROF: { return "Half Celestial";} //1458
				case APPEAR_TYPE_DERRO_ROF: { return "Derro";} //1459
				case APPEAR_TYPE_HALF_OGRE_ROF: { return "Ogre";} //1460
				case APPEAR_TYPE_DRAGONBORN_ROF: { return "Dragonborn";} //1461
				case APPEAR_TYPE_URD_ROF: { return "Urd";} //1462
				case APPEAR_TYPE_CELADRIN_ROF: { return "Celadrin";} //1463
				case APPEAR_TYPE_SYLPH_ROF: { return "Sylph";} //1464
				case APPEAR_TYPE_FLAMEBROTHER_ROF: { return "Flamebrother";} //1465
			}
			break;
		case 30:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RUST_MONSTER: { return "Rust Monster";} //1500
				case APPEAR_TYPE_BASILIK: { return "Basilik";} //1501
				case APPEAR_TYPE_SNAKE: { return "Snake";} //1502
				case APPEAR_TYPE_SCORPION: { return "Scorpion";} //1504
				case APPEAR_TYPE_XORN: { return "Xorn";} //1505
				case APPEAR_TYPE_CARRION_CRAWLER: { return "Carrion crawler";} //1506
				case APPEAR_TYPE_DRACOLICH: { return "DracoLich";} //1507
				case APPEAR_TYPE_DISPLACER_BEAST: { return "Displacer Beast";} //1508
			}
			break;
		case 40:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RDS_PORTAL: { return "RDS Portal";} //2041
				case APPEAR_TYPE_FLYING_BOOK: { return "Flying Book";} //2042
				case APPEAR_TYPE_RAT_CRANIUM: { return "Rat, Cranium";} //2043
				case APPEAR_TYPE_SLIME: { return "Slime";} //2044
				case APPEAR_TYPE_MONODRONE: { return "Monodrone";} //2045
				case APPEAR_TYPE_SPIDER_HOOK: { return "Spider Hook";} //2046
				case APPEAR_TYPE_DABUS: { return "Dabus";} //2047
				case APPEAR_TYPE_BARIAUR: { return "Bariaur";} //2049
			}
			break;
		case 41:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DOGDEAD: { return "Dog, Dead";} //2053
				case APPEAR_TYPE_URIDEZU: { return "Uridezu";} //2054
				case APPEAR_TYPE_DUODRONE: { return "Duodrone";} //2055
				case APPEAR_TYPE_TRIDRONE: { return "Tridrone";} //2056
				case APPEAR_TYPE_PENTADRONE: { return "Pentadrone";} //2057
			}
			break;
		case 46:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GELATINOUS_CUBE: { return "Gelatinous Cube";} //2300
				case APPEAR_TYPE_OOZE: { return "Ooze";} //2301
				case APPEAR_TYPE_HAMMERHEAD_SHARK: { return "Hammerhead Shark";} //2302
				case APPEAR_TYPE_MAKO_SHARK: { return "Mako Shark";} //2303
				case APPEAR_TYPE_MYCONID: { return "Myconid";} //2304
				
				case APPEAR_TYPE_NAGA: { return "Naga";} //2305
				case APPEAR_TYPE_PURRLE_WORM: { return "Purple Worm";} //2306
				case APPEAR_TYPE_STIRGE: { return "Stirge";} //2307
				case APPEAR_TYPE_STIRGE_TINT: { return "Stirge";} //2308
				case APPEAR_TYPE_PURRLE_WORM_TINT: { return "Purple Worm";} //2309
			}
			break;
		case 60:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GIANT_HILL: { return "Giant, Hill";} //3000
				case APPEAR_TYPE_GIANT_STONE: { return "Giant, Stone";} //3001
				case APPEAR_TYPE_GIANT_FIRE_ALT: { return "Giant, Fire";} //3002
				case APPEAR_TYPE_GIANT_FROST_ALT: { return "Giant, Frost";} //3003
				case APPEAR_TYPE_GIANT_CLOUD: { return "Giant, Cloud";} //3004
				case APPEAR_TYPE_GIANT_FOREST: { return "Giant, Forest";} //3005
				case APPEAR_TYPE_GIANT_STORM: { return "Giant, Storm";} //3006
				
				case APPEAR_TYPE_GIBBERING_MOUTHER: { return "Gibbering Mouther";} //3010
				case APPEAR_TYPE_BIGBY_GRASPING: { return "Bigbys Grasping Hand";} //3020
				case APPEAR_TYPE_BIGBY_INTERPOS: { return "Bigbys Interposing Hand";} //3021
				case APPEAR_TYPE_BIGBY_FIST: { return "Bigbys Clenched Fist";} //3022
				
				
			}
			break;
		case 62:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DRAGONMAN: { return "Dragonman";} //3100
				case APPEAR_TYPE_UNICORN: { return "Unicorn";} //3101
				case APPEAR_TYPE_ELEMENTAL_MAGMA: { return "Elemental, Magma";} //3102
				case APPEAR_TYPE_ELEMENTAL_ADAMANTIT: { return "Elemental, Adamantit";} //3103
				case APPEAR_TYPE_ELEMENTAL_ICE: { return "Elemental, Ice";} //3104
				case APPEAR_TYPE_ELEMENTAL_SILVER: { return "Elemental, Silver";} //3105
				case APPEAR_TYPE_FRISCHLING: { return "Frischling";} //3106
				case APPEAR_TYPE_TIGER_01: { return "Tiger";} //3107
				case APPEAR_TYPE_DOG_GERMAN: { return "Dog, German";} //3108
				case APPEAR_TYPE_FOURMI: { return "Fourmi";} //3109
			}
			break;
		case 68:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_EFREETI: { return "Efreeti";} //3400
			}
			break;
	}
	
	return "Missing Reference";
}




/**  
* @author
* @param 
* @see 
* @return 
*/
// * This increments the appearance by one, soas to make it possible to iterate thru the various appearances by DM's
// * and it skips the invalid ones automatically
/*
int CSLGetIncrementAppearance( int iAppearanceType )
{
	//int iAppearanceType = GetAppearanceType(oTarget);
	if ( iAppearanceType == -1 ) { return -1; }
	
	iAppearanceType = CSLGetBaseAppearance( iAppearanceType );
	
	int iSubAppearance = iAppearanceType / 50;
	switch(iSubAppearance)
	{
		case 0:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DWARF: { return APPEAR_TYPE_ELF;} //0
				case APPEAR_TYPE_ELF: { return APPEAR_TYPE_GNOME;} //1
				case APPEAR_TYPE_GNOME: { return APPEAR_TYPE_HALFLING;} //2
				case APPEAR_TYPE_HALFLING: { return APPEAR_TYPE_HALF_ELF;} //3
				case APPEAR_TYPE_HALF_ELF: { return APPEAR_TYPE_HALF_ORC;} //4
				case APPEAR_TYPE_HALF_ORC: { return APPEAR_TYPE_HUMAN;} //5
				case APPEAR_TYPE_HUMAN: { return APPEAR_TYPE_HORSE_BROWN;} //6
				case APPEAR_TYPE_HORSE_BROWN: { return APPEAR_TYPE_BADGER;} //7
				case APPEAR_TYPE_BADGER: { return APPEAR_TYPE_BADGER_DIRE;} //8
				case APPEAR_TYPE_BADGER_DIRE: { return APPEAR_TYPE_BAT;} //9
				case APPEAR_TYPE_BAT: { return APPEAR_TYPE_HORSE_PINTO;} //10
				case APPEAR_TYPE_HORSE_PINTO: { return APPEAR_TYPE_HORSE_SKELETAL;} //11
				case APPEAR_TYPE_HORSE_SKELETAL: { return APPEAR_TYPE_BEAR_BROWN;} //12
				case APPEAR_TYPE_BEAR_BROWN: { return APPEAR_TYPE_HORSE_PALOMINO;} //13
				case APPEAR_TYPE_HORSE_PALOMINO: { return APPEAR_TYPE_BEAR_DIRE;} //14
				case APPEAR_TYPE_BEAR_DIRE: { return APPEAR_TYPE_DRAGON__BRONZE;} //15
				case APPEAR_TYPE_DRAGON__BRONZE: { return APPEAR_TYPE_YOUNG_BRONZE;} //16
				case APPEAR_TYPE_YOUNG_BRONZE: { return APPEAR_TYPE_BEETLE_FIRE;} //17
				case APPEAR_TYPE_BEETLE_FIRE: { return APPEAR_TYPE_BEETLE_STAG;} //18
				case APPEAR_TYPE_BEETLE_STAG: { return APPEAR_TYPE_YOUNG_BLUE;} //19
				case APPEAR_TYPE_YOUNG_BLUE: { return APPEAR_TYPE_BOAR;} //20
				case APPEAR_TYPE_BOAR: { return APPEAR_TYPE_BOAR_DIRE;} //21
				case APPEAR_TYPE_BOAR_DIRE: { return APPEAR_TYPE_YUANTI_ABOMINATION;} //22
				case APPEAR_TYPE_YUANTI_ABOMINATION: { return APPEAR_TYPE_WORG;} //23
				case APPEAR_TYPE_WORG: { return APPEAR_TYPE_YUANTI_HOLYGUARDIAN;} //24
				case APPEAR_TYPE_YUANTI_HOLYGUARDIAN: { return APPEAR_TYPE_PLANETAR;} //25
				case APPEAR_TYPE_PLANETAR: { return APPEAR_TYPE_WILLOWISP;} //26
				case APPEAR_TYPE_WILLOWISP: { return APPEAR_TYPE_FIRE_NEWT;} //27
				case APPEAR_TYPE_FIRE_NEWT: { return APPEAR_TYPE_DROWNED;} //28
				case APPEAR_TYPE_DROWNED: { return APPEAR_TYPE_MEGARAPTOR;} //29
				case APPEAR_TYPE_MEGARAPTOR: { return APPEAR_TYPE_CHICKEN;} //30
				case APPEAR_TYPE_CHICKEN: { return APPEAR_TYPE_WIGHT;} //31
				case APPEAR_TYPE_WIGHT: { return APPEAR_TYPE_CLOCKROACH;} //32
				case APPEAR_TYPE_CLOCKROACH: { return APPEAR_TYPE_COW;} //33
				case APPEAR_TYPE_COW: { return APPEAR_TYPE_DEER;} //34
				case APPEAR_TYPE_DEER: { return APPEAR_TYPE_DEINONYCHUS;} //35
				case APPEAR_TYPE_DEINONYCHUS: { return APPEAR_TYPE_DEER_STAG;} //36
				case APPEAR_TYPE_DEER_STAG: { return APPEAR_TYPE_BATIRI;} //37
				case APPEAR_TYPE_BATIRI: { return APPEAR_TYPE_LICH;} //38
				case APPEAR_TYPE_LICH: { return APPEAR_TYPE_YUANTIPUREBLOOD;} //39
				case APPEAR_TYPE_YUANTIPUREBLOOD: { return APPEAR_TYPE_DRAGON_BLACK;} //40
				case APPEAR_TYPE_DRAGON_BLACK: { return APPEAR_TYPE_WAGON_LIGHT01;} //41
				case APPEAR_TYPE_WAGON_LIGHT01: { return APPEAR_TYPE_WAGON_LIGHT02;} //42
				case APPEAR_TYPE_WAGON_LIGHT02: { return APPEAR_TYPE_WAGON_LIGHT03;} //43
				case APPEAR_TYPE_WAGON_LIGHT03: { return APPEAR_TYPE_GRAYORC;} //44
				case APPEAR_TYPE_GRAYORC: { return APPEAR_TYPE_YUANTI_HERALD;} //45
				case APPEAR_TYPE_YUANTI_HERALD: { return APPEAR_TYPE_NPC_SASANI;} //46
				case APPEAR_TYPE_NPC_SASANI: { return APPEAR_TYPE_NPC_VOLO;} //47
				case APPEAR_TYPE_NPC_VOLO: { return APPEAR_TYPE_DRAGON_RED;} //48
				case APPEAR_TYPE_DRAGON_RED: { return APPEAR_TYPE_NPC_SEPTIMUND;} //49
			}
			break;
		case 1:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_SEPTIMUND: { return APPEAR_TYPE_DRYAD;} //50
				case APPEAR_TYPE_DRYAD: { return APPEAR_TYPE_ELEMENTAL_AIR;} //51
				case APPEAR_TYPE_ELEMENTAL_AIR: { return APPEAR_TYPE_ELEMENTAL_AIR_ELDER;} //52
				case APPEAR_TYPE_ELEMENTAL_AIR_ELDER: { return APPEAR_TYPE_ELEMENTAL_EARTH;} //53
				case APPEAR_TYPE_ELEMENTAL_EARTH: { return APPEAR_TYPE_ELEMENTAL_EARTH_ELDER;} //56
				case APPEAR_TYPE_ELEMENTAL_EARTH_ELDER: { return APPEAR_TYPE_MUMMY_COMMON;} //57
				case APPEAR_TYPE_MUMMY_COMMON: { return APPEAR_TYPE_ELEMENTAL_FIRE;} //58
				case APPEAR_TYPE_ELEMENTAL_FIRE: { return APPEAR_TYPE_ELEMENTAL_FIRE_ELDER;} //60
				case APPEAR_TYPE_ELEMENTAL_FIRE_ELDER: { return APPEAR_TYPE_ELEMENTAL_WATER_ELDER;} //61
				case APPEAR_TYPE_ELEMENTAL_WATER_ELDER: { return APPEAR_TYPE_ELEMENTAL_WATER;} //68
				case APPEAR_TYPE_ELEMENTAL_WATER: { return APPEAR_TYPE_GARGOYLE;} //69
				case APPEAR_TYPE_GARGOYLE: { return APPEAR_TYPE_GHAST;} //73
				case APPEAR_TYPE_GHAST: { return APPEAR_TYPE_GHOUL;} //74
				case APPEAR_TYPE_GHOUL: { return APPEAR_TYPE_GIANT_FIRE;} //76
				case APPEAR_TYPE_GIANT_FIRE: { return APPEAR_TYPE_GIANT_FROST;} //80
				case APPEAR_TYPE_GIANT_FROST: { return APPEAR_TYPE_GOLEM_IRON;} //81
				case APPEAR_TYPE_GOLEM_IRON: { return APPEAR_TYPE_VROCK;} //89
			}
			break;
		case 2:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VROCK: { return APPEAR_TYPE_IMP;} //105
				case APPEAR_TYPE_IMP: { return APPEAR_TYPE_MEPHIT_FIRE;} //105
				case APPEAR_TYPE_MEPHIT_FIRE: { return APPEAR_TYPE_MEPHIT_ICE;} //109
				case APPEAR_TYPE_MEPHIT_ICE: { return APPEAR_TYPE_OGRE;} //110
				case APPEAR_TYPE_OGRE: { return APPEAR_TYPE_OGRE_MAGE;} //127
				case APPEAR_TYPE_OGRE_MAGE: { return APPEAR_TYPE_ORC_A;} //129
				case APPEAR_TYPE_ORC_A: { return APPEAR_TYPE_SLAAD_BLUE;} //140
			}
			break;
		case 3:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SLAAD_BLUE: { return APPEAR_TYPE_SLAAD_GREEN;} //151
				case APPEAR_TYPE_SLAAD_GREEN: { return APPEAR_TYPE_SPECTRE;} //154
				case APPEAR_TYPE_SPECTRE: { return APPEAR_TYPE_SPIDER_DIRE;} //156
				case APPEAR_TYPE_SPIDER_DIRE: { return APPEAR_TYPE_SPIDER_GIANT;} //158
				case APPEAR_TYPE_SPIDER_GIANT: { return APPEAR_TYPE_SPIDER_PHASE;} //159
				case APPEAR_TYPE_SPIDER_PHASE: { return APPEAR_TYPE_SPIDER_BLADE;} //160
				case APPEAR_TYPE_SPIDER_BLADE: { return APPEAR_TYPE_SPIDER_WRAITH;} //161
				case APPEAR_TYPE_SPIDER_WRAITH: { return APPEAR_TYPE_SUCCUBUS;} //162
				case APPEAR_TYPE_SUCCUBUS: { return APPEAR_TYPE_TROLL;} //163
				case APPEAR_TYPE_TROLL: { return APPEAR_TYPE_UMBERHULK;} //167
				case APPEAR_TYPE_UMBERHULK: { return APPEAR_TYPE_WEREWOLF;} //168
				case APPEAR_TYPE_WEREWOLF: { return APPEAR_TYPE_DOG_DIRE_WOLF;} //171
				case APPEAR_TYPE_DOG_DIRE_WOLF: { return APPEAR_TYPE_DOG_HELL_HOUND;} //175
				case APPEAR_TYPE_DOG_HELL_HOUND: { return APPEAR_TYPE_DOG_SHADOW_MASTIF;} //179
				case APPEAR_TYPE_DOG_SHADOW_MASTIF: { return APPEAR_TYPE_DOG_WOLF;} //180
				case APPEAR_TYPE_DOG_WOLF: { return APPEAR_TYPE_DOG_WINTER_WOLF;} //181
				case APPEAR_TYPE_DOG_WINTER_WOLF: { return APPEAR_TYPE_DREAD_WRAITH;} //184
				case APPEAR_TYPE_DREAD_WRAITH: { return APPEAR_TYPE_WRAITH;} //186
				case APPEAR_TYPE_WRAITH: { return APPEAR_TYPE_ZOMBIE;} //187
				case APPEAR_TYPE_ZOMBIE: { return APPEAR_TYPE_VAMPIRE_FEMALE;} //198
			}
			break;
		case 5:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VAMPIRE_FEMALE: { return APPEAR_TYPE_VAMPIRE_MALE;} //288
				case APPEAR_TYPE_VAMPIRE_MALE: { return APPEAR_TYPE_RAT;} //289
			}
			break;
		case 7:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RAT: { return APPEAR_TYPE_RAT_DIRE;} //386
				case APPEAR_TYPE_RAT_DIRE: { return APPEAR_TYPE_MINDFLAYER;} //387
			}
			break;
		case 8:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_MINDFLAYER: { return APPEAR_TYPE_DEVIL_HORNED;} //413
			}
			break;
		case 9:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DEVIL_HORNED: { return APPEAR_TYPE_SPIDER_BONE;} //481
				case APPEAR_TYPE_SPIDER_BONE: { return APPEAR_TYPE_GITHYANKI;} //482
				case APPEAR_TYPE_GITHYANKI: { return APPEAR_TYPE_BIRD;} //483
				case APPEAR_TYPE_BIRD: { return APPEAR_TYPE_BLADELING;} //485
				case APPEAR_TYPE_BLADELING: { return APPEAR_TYPE_CAT;} //486
				case APPEAR_TYPE_CAT: { return APPEAR_TYPE_DEMON_HEZROU;} //487
				case APPEAR_TYPE_DEMON_HEZROU: { return APPEAR_TYPE_DEVIL_PITFIEND;} //488
				case APPEAR_TYPE_DEVIL_PITFIEND: { return APPEAR_TYPE_GOLEM_BLADE;} //489
				case APPEAR_TYPE_GOLEM_BLADE: { return APPEAR_TYPE_SHADOW;} //493
				case APPEAR_TYPE_SHADOW: { return APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER;} //496
				case APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER: { return APPEAR_TYPE_PIG;} //497
				case APPEAR_TYPE_PIG: { return APPEAR_TYPE_RABBIT;} //498
				case APPEAR_TYPE_RABBIT: { return APPEAR_TYPE_SHADOW_REAVER;} //499
				
			}
			break;
		case 10:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SHADOW_REAVER: { return APPEAR_TYPE_WEASEL;} //500
				case APPEAR_TYPE_WEASEL: { return APPEAR_TYPE_SYLPH;} //503
				case APPEAR_TYPE_SYLPH: { return APPEAR_TYPE_DEVIL_ERINYES;} //512
				case APPEAR_TYPE_DEVIL_ERINYES: { return APPEAR_TYPE_PIXIE;} //514
				case APPEAR_TYPE_PIXIE: { return APPEAR_TYPE_DEMON_BALOR;} //521
				case APPEAR_TYPE_DEMON_BALOR: { return APPEAR_TYPE_GNOLL;} //522
				case APPEAR_TYPE_GNOLL: { return APPEAR_TYPE_GOBLIN;} //533
				case APPEAR_TYPE_GOBLIN: { return APPEAR_TYPE_KOBOLD;} //534
				case APPEAR_TYPE_KOBOLD: { return APPEAR_TYPE_LIZARDFOLK;} //535
				case APPEAR_TYPE_LIZARDFOLK: { return APPEAR_TYPE_SKELETON;} //536
				case APPEAR_TYPE_SKELETON: { return APPEAR_TYPE_BEETLE_BOMBARDIER;} //537
				case APPEAR_TYPE_BEETLE_BOMBARDIER: { return APPEAR_TYPE_BUGBEAR;} //538
				case APPEAR_TYPE_BUGBEAR: { return APPEAR_TYPE_NPC_GARIUS;} //543
				case APPEAR_TYPE_NPC_GARIUS: { return APPEAR_TYPE_SPIDER_GLOW;} //544
				case APPEAR_TYPE_SPIDER_GLOW: { return APPEAR_TYPE_SPIDER_KRISTAL;} //546
				case APPEAR_TYPE_SPIDER_KRISTAL: { return APPEAR_TYPE_NPC_DUNCAN;} //547
				case APPEAR_TYPE_NPC_DUNCAN: { return APPEAR_TYPE_NPC_LORDNASHER;} //549
			}
			break;
		case 11:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_LORDNASHER: { return APPEAR_TYPE_NPC_CHILDHHM;} //550
				case APPEAR_TYPE_NPC_CHILDHHM: { return APPEAR_TYPE_NPC_CHILDHHF;} //551
				case APPEAR_TYPE_NPC_CHILDHHF: { return APPEAR_TYPE_ELEMENTAL_AIR_HUGE;} //553
				case APPEAR_TYPE_ELEMENTAL_AIR_HUGE: { return APPEAR_TYPE_ELEMENTAL_AIR_GREATER;} //554
				case APPEAR_TYPE_ELEMENTAL_AIR_GREATER: { return APPEAR_TYPE_ELEMENTAL_EARTH_HUGE;} //555
				case APPEAR_TYPE_ELEMENTAL_EARTH_HUGE: { return APPEAR_TYPE_ELEMENTAL_EARTH_GREATER;} //556
				case APPEAR_TYPE_ELEMENTAL_EARTH_GREATER: { return APPEAR_TYPE_ELEMENTAL_FIRE_HUGE;} //557
				case APPEAR_TYPE_ELEMENTAL_FIRE_HUGE: { return APPEAR_TYPE_ELEMENTAL_FIRE_GREATER;} //558
				case APPEAR_TYPE_ELEMENTAL_FIRE_GREATER: { return APPEAR_TYPE_ELEMENTAL_WATER_HUGE;} //559
				case APPEAR_TYPE_ELEMENTAL_WATER_HUGE: { return APPEAR_TYPE_ELEMENTAL_WATER_GREATER;} //560
				case APPEAR_TYPE_ELEMENTAL_WATER_GREATER: { return APPEAR_TYPE_SIEGETOWER;} //561
				case APPEAR_TYPE_SIEGETOWER: { return APPEAR_TYPE_ASSIMAR;} //562
				case APPEAR_TYPE_ASSIMAR: { return APPEAR_TYPE_TIEFLING;} //563
				case APPEAR_TYPE_TIEFLING: { return APPEAR_TYPE_ELF_SUN;} //564
				case APPEAR_TYPE_ELF_SUN: { return APPEAR_TYPE_ELF_WOOD;} //565
				case APPEAR_TYPE_ELF_WOOD: { return APPEAR_TYPE_ELF_DROW;} //566
				case APPEAR_TYPE_ELF_DROW: { return APPEAR_TYPE_GNOME_SVIRFNEBLIN;} //567
				case APPEAR_TYPE_GNOME_SVIRFNEBLIN: { return APPEAR_TYPE_DWARF_GOLD;} //568
				case APPEAR_TYPE_DWARF_GOLD: { return APPEAR_TYPE_DWARF_DUERGAR;} //569
				case APPEAR_TYPE_DWARF_DUERGAR: { return APPEAR_TYPE_HALFLING_STRONGHEART;} //570
				case APPEAR_TYPE_HALFLING_STRONGHEART: { return APPEAR_TYPE_CARGOSHIP;} //571
				case APPEAR_TYPE_CARGOSHIP: { return APPEAR_TYPE_N_HUMAN;} //572
				case APPEAR_TYPE_N_HUMAN: { return APPEAR_TYPE_N_ELF;} //573
				case APPEAR_TYPE_N_ELF: { return APPEAR_TYPE_N_DWARF;} //574
				case APPEAR_TYPE_N_DWARF: { return APPEAR_TYPE_N_HALF_ELF;} //575
				case APPEAR_TYPE_N_HALF_ELF: { return APPEAR_TYPE_N_GNOME;} //576
				case APPEAR_TYPE_N_GNOME: { return APPEAR_TYPE_N_TIEFLING;} //577
				case APPEAR_TYPE_N_TIEFLING: { return APPEAR_TYPE_NPC_GITHCAPTAIN;} //578
				case APPEAR_TYPE_NPC_GITHCAPTAIN: { return APPEAR_TYPE_NPC_LORNE;} //579
				case APPEAR_TYPE_NPC_LORNE: { return APPEAR_TYPE_NPC_TENAVROK;} //580
				case APPEAR_TYPE_NPC_TENAVROK: { return APPEAR_TYPE_NPC_CTANN;} //581
				case APPEAR_TYPE_NPC_CTANN: { return APPEAR_TYPE_NPC_SHANDRA;} //582
				case APPEAR_TYPE_NPC_SHANDRA: { return APPEAR_TYPE_NPC_ZEEAIRE;} //583
				case APPEAR_TYPE_NPC_ZEEAIRE: { return APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT;} //584
				case APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT: { return APPEAR_TYPE_NPC_KINGOFSHADOWS;} //585
				case APPEAR_TYPE_NPC_KINGOFSHADOWS: { return APPEAR_TYPE_NPC_NOLALOTH;} //586
				case APPEAR_TYPE_NPC_NOLALOTH: { return APPEAR_TYPE_NPC_ZHJAEVE;} //587
				case APPEAR_TYPE_NPC_ZHJAEVE: { return APPEAR_TYPE_NPC_ZAXIS;} //588
				case APPEAR_TYPE_NPC_ZAXIS: { return APPEAR_TYPE_NPC_AHJA;} //589
				case APPEAR_TYPE_NPC_AHJA: { return APPEAR_TYPE_NPC_DURLER;} //590
				case APPEAR_TYPE_NPC_DURLER: { return APPEAR_TYPE_NPC_HEZEBEL;} //591
				case APPEAR_TYPE_NPC_HEZEBEL: { return APPEAR_TYPE_NPC_HOSTTOWER;} //592
				case APPEAR_TYPE_NPC_HOSTTOWER: { return APPEAR_TYPE_NPC_ZOKAN;} //593
				case APPEAR_TYPE_NPC_ZOKAN: { return APPEAR_TYPE_NPC_ALDANON;} //594
				case APPEAR_TYPE_NPC_ALDANON: { return APPEAR_TYPE_NPC_JACOBY;} //595
				case APPEAR_TYPE_NPC_JACOBY: { return APPEAR_TYPE_NPC_JALBOUN;} //596
				case APPEAR_TYPE_NPC_JALBOUN: { return APPEAR_TYPE_NPC_KHRALVER;} //597
				case APPEAR_TYPE_NPC_KHRALVER: { return APPEAR_TYPE_NPC_KRALWOK;} //598
				case APPEAR_TYPE_NPC_KRALWOK: { return APPEAR_TYPE_NPC_MEPHASM;} //599
			}
			break;
		case 12:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_MEPHASM: { return APPEAR_TYPE_NPC_MORKAI;} //600
				case APPEAR_TYPE_NPC_MORKAI: { return APPEAR_TYPE_NPC_SARYA;} //601
				case APPEAR_TYPE_NPC_SARYA: { return APPEAR_TYPE_NPC_SYDNEY;} //602
				case APPEAR_TYPE_NPC_SYDNEY: { return APPEAR_TYPE_NPC_TORIOCLAVEN;} //603
				case APPEAR_TYPE_NPC_TORIOCLAVEN: { return APPEAR_TYPE_NPC_UTHANCK;} //604
				case APPEAR_TYPE_NPC_UTHANCK: { return APPEAR_TYPE_NPC_SHADOWPRIEST;} //605
				case APPEAR_TYPE_NPC_SHADOWPRIEST: { return APPEAR_TYPE_NPC_HUNTERSTATUE;} //606
				case APPEAR_TYPE_NPC_HUNTERSTATUE: { return APPEAR_TYPE_SIEGETOWERB;} //607
				case APPEAR_TYPE_SIEGETOWERB: { return APPEAR_TYPE_PUSHBLOCK;} //608
				case APPEAR_TYPE_PUSHBLOCK: { return APPEAR_TYPE_SMUGGLERWAGON;} //609
				case APPEAR_TYPE_SMUGGLERWAGON: { return APPEAR_TYPE_INVISIBLEMAN;} //610
				case APPEAR_TYPE_INVISIBLEMAN: { return APPEAR_TYPE_AKACHI;} //611
			}
			break;
		case 20:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AKACHI: { return APPEAR_TYPE_OKKU_BEAR;} //1000
				case APPEAR_TYPE_OKKU_BEAR: { return APPEAR_TYPE_PANTHER;} //1001
				case APPEAR_TYPE_PANTHER: { return APPEAR_TYPE_WOLVERINE;} //1002
				case APPEAR_TYPE_WOLVERINE: { return APPEAR_TYPE_INVISIBLE_STALKER;} //1003
				case APPEAR_TYPE_INVISIBLE_STALKER: { return APPEAR_TYPE_HOMUNCULUS;} //1004
				case APPEAR_TYPE_HOMUNCULUS: { return APPEAR_TYPE_GOLEM_IMASKARI;} //1005
				case APPEAR_TYPE_GOLEM_IMASKARI: { return APPEAR_TYPE_RED_WIZ_COMPANION;} //1006
				case APPEAR_TYPE_RED_WIZ_COMPANION: { return APPEAR_TYPE_DEATH_KNIGHT;} //1007
				case APPEAR_TYPE_DEATH_KNIGHT: { return APPEAR_TYPE_BARROW_GUARDIAN;} //1008
				case APPEAR_TYPE_BARROW_GUARDIAN: { return APPEAR_TYPE_SEA_MONSTER;} //1009
				case APPEAR_TYPE_SEA_MONSTER: { return APPEAR_TYPE_ONE_OF_MANY;} //1010
				case APPEAR_TYPE_ONE_OF_MANY: { return APPEAR_TYPE_SHAMBLING_MOUND;} //1011
				case APPEAR_TYPE_SHAMBLING_MOUND: { return APPEAR_TYPE_SOLAR;} //1012
				case APPEAR_TYPE_SOLAR: { return APPEAR_TYPE_WOLVERINE_DIRE;} //1013
				case APPEAR_TYPE_WOLVERINE_DIRE: { return APPEAR_TYPE_DRAGON_BLUE;} //1014
				case APPEAR_TYPE_DRAGON_BLUE: { return APPEAR_TYPE_DJINN;} //1015
				case APPEAR_TYPE_DJINN: { return APPEAR_TYPE_GNOLL_THAYAN;} //1016
				case APPEAR_TYPE_GNOLL_THAYAN: { return APPEAR_TYPE_GOLEM_CLAY;} //1017
				case APPEAR_TYPE_GOLEM_CLAY: { return APPEAR_TYPE_GOLEM_FAITHLESS;} //1018
				case APPEAR_TYPE_GOLEM_FAITHLESS: { return APPEAR_TYPE_DEMILICH;} //1019
				case APPEAR_TYPE_DEMILICH: { return APPEAR_TYPE_HAG_ANNIS;} //1020
				case APPEAR_TYPE_HAG_ANNIS: { return APPEAR_TYPE_HAG_GREEN;} //1021
				case APPEAR_TYPE_HAG_GREEN: { return APPEAR_TYPE_HAG_NIGHT;} //1022
				case APPEAR_TYPE_HAG_NIGHT: { return APPEAR_TYPE_HORSE_WHITE;} //1023
				case APPEAR_TYPE_HORSE_WHITE: { return APPEAR_TYPE_DEMILICH_SMALL;} //1024
				case APPEAR_TYPE_DEMILICH_SMALL: { return APPEAR_TYPE_LEOPARD_SNOW;} //1025
				case APPEAR_TYPE_LEOPARD_SNOW: { return APPEAR_TYPE_TREANT;} //1026
				case APPEAR_TYPE_TREANT: { return APPEAR_TYPE_TROLL_FELL;} //1027
				case APPEAR_TYPE_TROLL_FELL: { return APPEAR_TYPE_UTHRAKI;} //1028
				case APPEAR_TYPE_UTHRAKI: { return APPEAR_TYPE_WYVERN;} //1029
				case APPEAR_TYPE_WYVERN: { return APPEAR_TYPE_RAVENOUS_INCARNATION;} //1030
				case APPEAR_TYPE_RAVENOUS_INCARNATION: { return APPEAR_TYPE_N_ELF_WILD;} //1031
				case APPEAR_TYPE_N_ELF_WILD: { return APPEAR_TYPE_N_HALF_DROW;} //1032
				case APPEAR_TYPE_N_HALF_DROW: { return APPEAR_TYPE_MAGDA;} //1033
				case APPEAR_TYPE_MAGDA: { return APPEAR_TYPE_NEFRIS;} //1034
				case APPEAR_TYPE_NEFRIS: { return APPEAR_TYPE_ELF_WILD;} //1035
				case APPEAR_TYPE_ELF_WILD: { return APPEAR_TYPE_EARTH_GENASI;} //1036
				case APPEAR_TYPE_EARTH_GENASI: { return APPEAR_TYPE_FIRE_GENASI;} //1037
				case APPEAR_TYPE_FIRE_GENASI: { return APPEAR_TYPE_AIR_GENASI;} //1038
				case APPEAR_TYPE_AIR_GENASI: { return APPEAR_TYPE_WATER_GENASI;} //1039
				case APPEAR_TYPE_WATER_GENASI: { return APPEAR_TYPE_HALF_DROW;} //1040
				case APPEAR_TYPE_HALF_DROW: { return APPEAR_TYPE_DOG_WOLF_TELTHOR;} //1041
				case APPEAR_TYPE_DOG_WOLF_TELTHOR: { return APPEAR_TYPE_HAGSPAWN_VAR1;} //1042
				case APPEAR_TYPE_HAGSPAWN_VAR1: { return APPEAR_TYPE_DEVEIL_PAELIRYON;} //1043
				
				case APPEAR_TYPE_DEVEIL_PAELIRYON: { return APPEAR_TYPE_WERERAT;} //1044
				case APPEAR_TYPE_WERERAT: { return APPEAR_TYPE_ORBAKH;} //1045
				case APPEAR_TYPE_ORBAKH: { return APPEAR_TYPE_QUELZARN;} //1046
				case APPEAR_TYPE_QUELZARN: { return APPEAR_TYPE_BEHOLDER;} //1047
			}
			break;
		case 24:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_BEHOLDER: { return APPEAR_TYPE_REE_YUANTIF;} //1201
				case APPEAR_TYPE_REE_YUANTIF: { return APPEAR_TYPE_DRIDER;} //1204
				case APPEAR_TYPE_DRIDER: { return APPEAR_TYPE_MINOTAUR;} //1206
				case APPEAR_TYPE_MINOTAUR: { return APPEAR_TYPE_AZERBLOOD_ROF;} //1208
			}
			break;
		case 28:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AZERBLOOD_ROF: { return APPEAR_TYPE_FROSTBLOT_ROF;} //1400;
				case APPEAR_TYPE_FROSTBLOT_ROF: { return APPEAR_TYPE_ELDBLOT_ROF;} //1401;
				case APPEAR_TYPE_ELDBLOT_ROF: { return APPEAR_TYPE_ARCTIC_DWARF_ROF;} //1402;
				case APPEAR_TYPE_ARCTIC_DWARF_ROF: { return APPEAR_TYPE_WILD_DWARF_ROF;} //1403;
				case APPEAR_TYPE_WILD_DWARF_ROF: { return APPEAR_TYPE_TANARUKK_ROF;} //1404;
				case APPEAR_TYPE_TANARUKK_ROF: { return APPEAR_TYPE_HOBGOBLIN_ROF;} //1405;
				case APPEAR_TYPE_HOBGOBLIN_ROF: { return APPEAR_TYPE_FOREST_GNOME_ROF;} //1407;
				case APPEAR_TYPE_FOREST_GNOME_ROF: { return APPEAR_TYPE_YUANTI_HALFBLOOD_ROF;} //1409;
				case APPEAR_TYPE_YUANTI_HALFBLOOD_ROF: { return APPEAR_TYPE_ASABI_ROF;} //1410;
				case APPEAR_TYPE_ASABI_ROF: { return APPEAR_TYPE_LIZARDFOLD_ROF;} //1411;
				case APPEAR_TYPE_LIZARDFOLD_ROF: { return APPEAR_TYPE_OGRE_ROF;} //1412;
				case APPEAR_TYPE_OGRE_ROF: { return APPEAR_TYPE_PIXIE_ROF;} //1413;
				case APPEAR_TYPE_PIXIE_ROF: { return APPEAR_TYPE_DRAGONKIN_ROF;} //1414;
				case APPEAR_TYPE_DRAGONKIN_ROF: { return APPEAR_TYPE_GLOAMING_ROF;} //1415;
				case APPEAR_TYPE_GLOAMING_ROF: { return APPEAR_TYPE_CHAOND_ROF;} //1416;
				case APPEAR_TYPE_CHAOND_ROF: { return APPEAR_TYPE_ELF_DUNE_ROF;} //1417;
				case APPEAR_TYPE_ELF_DUNE_ROF: { return APPEAR_TYPE_BROWNIE_ROF;} //1418;
				case APPEAR_TYPE_BROWNIE_ROF: { return APPEAR_TYPE_ULDRA_ROF;} //1419;
				case APPEAR_TYPE_ULDRA_ROF: { return APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF;} //1420;
				case APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF: { return APPEAR_TYPE_ELF_POSCADAR_ROF;} //1421;
				case APPEAR_TYPE_ELF_POSCADAR_ROF: { return APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF;} //1422;
				case APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF: { return APPEAR_TYPE_FIRBOLG_ROF;} //1423;
				case APPEAR_TYPE_FIRBOLG_ROF: { return APPEAR_TYPE_FOMORIAN_ROF;} //1424;
				case APPEAR_TYPE_FOMORIAN_ROF: { return APPEAR_TYPE_VERBEEG_ROF;} //1425;
				case APPEAR_TYPE_VERBEEG_ROF: { return APPEAR_TYPE_VOADKYN_ROF;} //1426;
				case APPEAR_TYPE_VOADKYN_ROF: { return APPEAR_TYPE_FJELLBLOT_ROF;} //1427;
				case APPEAR_TYPE_FJELLBLOT_ROF: { return APPEAR_TYPE_TAKEBLOT_ROF;} //1428;
				case APPEAR_TYPE_TAKEBLOT_ROF: { return APPEAR_TYPE_AIR_MEPHLING_ROF;} //1429;
				case APPEAR_TYPE_AIR_MEPHLING_ROF: { return APPEAR_TYPE_EARTH_MEPHLING_ROF;} //1430;
				case APPEAR_TYPE_EARTH_MEPHLING_ROF: { return APPEAR_TYPE_FIRE_MEPHLING_ROF;} //1431;
				case APPEAR_TYPE_FIRE_MEPHLING_ROF: { return APPEAR_TYPE_WATER_MEPHLING_ROF;} //1432;
				case APPEAR_TYPE_WATER_MEPHLING_ROF: { return APPEAR_TYPE_KHAASTA_ROF;} //1433;
				case APPEAR_TYPE_KHAASTA_ROF: { return APPEAR_TYPE_MOUNTAIN_ORC_ROF;} //1434;
				case APPEAR_TYPE_MOUNTAIN_ORC_ROF: { return APPEAR_TYPE_BOOGIN_ROF;} //1435;
				case APPEAR_TYPE_BOOGIN_ROF: { return APPEAR_TYPE_ICE_SPIRE_OGRE_ROF;} //1436;
				case APPEAR_TYPE_ICE_SPIRE_OGRE_ROF: { return APPEAR_TYPE_OGRILLON_ROF;} //1437;
				case APPEAR_TYPE_OGRILLON_ROF: { return APPEAR_TYPE_KRINTH_ROF;} //1438;
				case APPEAR_TYPE_KRINTH_ROF: { return APPEAR_TYPE_HALFLING_SANDSTORM_ROF;} //1439;
				case APPEAR_TYPE_HALFLING_SANDSTORM_ROF: { return APPEAR_TYPE_DWARF_DEGLOSIAN_ROF;} //1440;
				case APPEAR_TYPE_DWARF_DEGLOSIAN_ROF: { return APPEAR_TYPE_DWARF_GALDOSIAN_ROF;} //1441;
				case APPEAR_TYPE_DWARF_GALDOSIAN_ROF: { return APPEAR_TYPE_ELF_ROF;} //1442;
				case APPEAR_TYPE_ELF_ROF: { return APPEAR_TYPE_ELF_DRANGONARI_ROF;} //1443;
				case APPEAR_TYPE_ELF_DRANGONARI_ROF: { return APPEAR_TYPE_ELF_GHOST_ROF;} //1444;
				case APPEAR_TYPE_ELF_GHOST_ROF: { return APPEAR_TYPE_FAERIE_ROF;} //1445;
				case APPEAR_TYPE_FAERIE_ROF: { return APPEAR_TYPE_GNOME_ROF;} //1446;
				case APPEAR_TYPE_GNOME_ROF: { return APPEAR_TYPE_GOBLIN_ROF;} //1447;
				case APPEAR_TYPE_GOBLIN_ROF: { return APPEAR_TYPE_HALF_ELF_ROF;} //1448;
				case APPEAR_TYPE_HALF_ELF_ROF: { return APPEAR_TYPE_HALF_ORC_ROF;} //1449;
			}
			break;
		case 29:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_HALF_ORC_ROF: { return APPEAR_TYPE_HALFLING_ROF;} //1450;
				case APPEAR_TYPE_HALFLING_ROF: { return APPEAR_TYPE_HUMAN_ROF;} //1451
				case APPEAR_TYPE_HUMAN_ROF: { return APPEAR_TYPE_OROG_ROF;} //1452
				case APPEAR_TYPE_OROG_ROF: { return APPEAR_TYPE_AELFBORN_ROF;} //1453
				case APPEAR_TYPE_AELFBORN_ROF: { return APPEAR_TYPE_FEYRI_ROF;} //1454
				case APPEAR_TYPE_FEYRI_ROF: { return APPEAR_TYPE_SEWER_GOBLIN_ROF;} //1455
				case APPEAR_TYPE_SEWER_GOBLIN_ROF: { return APPEAR_TYPE_WOOD_GENASI_ROF;} //1456
				case APPEAR_TYPE_WOOD_GENASI_ROF: { return APPEAR_TYPE_HALF_CELESTIAL_ROF;} //1457
				case APPEAR_TYPE_HALF_CELESTIAL_ROF: { return APPEAR_TYPE_DERRO_ROF;} //1458
				case APPEAR_TYPE_DERRO_ROF: { return APPEAR_TYPE_HALF_OGRE_ROF;} //1459
				case APPEAR_TYPE_HALF_OGRE_ROF: { return APPEAR_TYPE_DRAGONBORN_ROF;} //1460
				case APPEAR_TYPE_DRAGONBORN_ROF: { return APPEAR_TYPE_URD_ROF;} //1461
				case APPEAR_TYPE_URD_ROF: { return APPEAR_TYPE_CELADRIN_ROF;} //1462
				case APPEAR_TYPE_CELADRIN_ROF: { return APPEAR_TYPE_SYLPH_ROF;} //1463
				case APPEAR_TYPE_SYLPH_ROF: { return APPEAR_TYPE_FLAMEBROTHER_ROF;} //1464
				case APPEAR_TYPE_FLAMEBROTHER_ROF: { return APPEAR_TYPE_RUST_MONSTER;} //1465
			}
			break;
		case 30:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RUST_MONSTER: { return APPEAR_TYPE_BASILIK;} //1500
				case APPEAR_TYPE_BASILIK: { return APPEAR_TYPE_SNAKE;} //1501
				case APPEAR_TYPE_SNAKE: { return APPEAR_TYPE_SCORPION;} //1502
				case APPEAR_TYPE_SCORPION: { return APPEAR_TYPE_XORN;} //1504
				case APPEAR_TYPE_XORN: { return APPEAR_TYPE_CARRION_CRAWLER;} //1505
				case APPEAR_TYPE_CARRION_CRAWLER: { return APPEAR_TYPE_DRACOLICH;} //1506
				case APPEAR_TYPE_DRACOLICH: { return APPEAR_TYPE_DISPLACER_BEAST;} //1507
				case APPEAR_TYPE_DISPLACER_BEAST: { return APPEAR_TYPE_RDS_PORTAL;} //1508
				
			}
			break;
		case 40:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RDS_PORTAL: { return APPEAR_TYPE_FLYING_BOOK;} //2041
				case APPEAR_TYPE_FLYING_BOOK: { return APPEAR_TYPE_RAT_CRANIUM;} //2042
				case APPEAR_TYPE_RAT_CRANIUM: { return APPEAR_TYPE_SLIME;} //2043
				case APPEAR_TYPE_SLIME: { return APPEAR_TYPE_MONODRONE;} //2044
				case APPEAR_TYPE_MONODRONE: { return APPEAR_TYPE_SPIDER_HOOK;} //1503
				case APPEAR_TYPE_SPIDER_HOOK: { return APPEAR_TYPE_DABUS;} //2046
				case APPEAR_TYPE_DABUS: { return APPEAR_TYPE_BARIAUR;} //2047
				case APPEAR_TYPE_BARIAUR: { return APPEAR_TYPE_GELATINOUS_CUBE;} //2049
								
			}
			break;
		case 41:
			switch ( iAppearanceType )
			{

				case APPEAR_TYPE_DOGDEAD: { return APPEAR_TYPE_URIDEZU;} //2053
				case APPEAR_TYPE_URIDEZU: { return APPEAR_TYPE_DUODRONE;} //2054
				case APPEAR_TYPE_DUODRONE: { return APPEAR_TYPE_TRIDRONE;} //2055
				case APPEAR_TYPE_TRIDRONE: { return APPEAR_TYPE_PENTADRONE;} //2056
				case APPEAR_TYPE_PENTADRONE: { return APPEAR_TYPE_GELATINOUS_CUBE;} //2057
			}
			break;
		case 46:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GELATINOUS_CUBE: { return APPEAR_TYPE_OOZE;} //2300
				case APPEAR_TYPE_OOZE: { return APPEAR_TYPE_HAMMERHEAD_SHARK;} //2301
				case APPEAR_TYPE_HAMMERHEAD_SHARK: { return APPEAR_TYPE_MAKO_SHARK;} //2302
				case APPEAR_TYPE_MAKO_SHARK: { return APPEAR_TYPE_MYCONID;} //2303
				case APPEAR_TYPE_MYCONID: { return APPEAR_TYPE_NAGA;} //2304
				
								
				case APPEAR_TYPE_NAGA: { return APPEAR_TYPE_PURRLE_WORM;} //2305
				case APPEAR_TYPE_PURRLE_WORM: { return APPEAR_TYPE_STIRGE;} //2306
				case APPEAR_TYPE_STIRGE: { return APPEAR_TYPE_STIRGE_TINT;} //2307
				case APPEAR_TYPE_STIRGE_TINT: { return APPEAR_TYPE_PURRLE_WORM_TINT;} //2308
				case APPEAR_TYPE_PURRLE_WORM_TINT: { return APPEAR_TYPE_GIANT_HILL;} //2309

				
			}
			break;
		case 60:
			switch ( iAppearanceType )
			{
				
				case APPEAR_TYPE_GIANT_HILL: { return APPEAR_TYPE_GIANT_STONE;} //3000
				case APPEAR_TYPE_GIANT_STONE: { return APPEAR_TYPE_GIANT_FIRE_ALT;} //3001
				case APPEAR_TYPE_GIANT_FIRE_ALT: { return APPEAR_TYPE_GIANT_FROST_ALT;} //3002
				case APPEAR_TYPE_GIANT_FROST_ALT: { return APPEAR_TYPE_GIANT_CLOUD;} //3003
				case APPEAR_TYPE_GIANT_CLOUD: { return APPEAR_TYPE_GIANT_FOREST;} //3004
				case APPEAR_TYPE_GIANT_FOREST: { return APPEAR_TYPE_GIANT_STORM;} //3005
				case APPEAR_TYPE_GIANT_STORM: { return APPEAR_TYPE_GIBBERING_MOUTHER;} //3006
				
				case APPEAR_TYPE_GIBBERING_MOUTHER: { return APPEAR_TYPE_BIGBY_GRASPING;} //3010
				case APPEAR_TYPE_BIGBY_GRASPING: { return APPEAR_TYPE_BIGBY_INTERPOS;} //3020
				case APPEAR_TYPE_BIGBY_INTERPOS: { return APPEAR_TYPE_BIGBY_FIST;} //3021
				case APPEAR_TYPE_BIGBY_FIST: { return APPEAR_TYPE_DRAGONMAN;} //3022
			}
			break;
		case 62:
			switch ( iAppearanceType )
			{
				
				case APPEAR_TYPE_DRAGONMAN: { return APPEAR_TYPE_UNICORN;} //3100
				case APPEAR_TYPE_UNICORN: { return APPEAR_TYPE_ELEMENTAL_MAGMA;} //3101
				case APPEAR_TYPE_ELEMENTAL_MAGMA: { return APPEAR_TYPE_ELEMENTAL_ADAMANTIT;} //3102
				case APPEAR_TYPE_ELEMENTAL_ADAMANTIT: { return APPEAR_TYPE_ELEMENTAL_ICE;} //3103
				case APPEAR_TYPE_ELEMENTAL_ICE: { return APPEAR_TYPE_ELEMENTAL_SILVER;} //3104
				case APPEAR_TYPE_ELEMENTAL_SILVER: { return APPEAR_TYPE_FRISCHLING;} //3105
				case APPEAR_TYPE_FRISCHLING: { return APPEAR_TYPE_TIGER_01;} //3106
				case APPEAR_TYPE_TIGER_01: { return APPEAR_TYPE_DOG_GERMAN;} //3107
				case APPEAR_TYPE_DOG_GERMAN: { return APPEAR_TYPE_FOURMI;} //3108
				case APPEAR_TYPE_FOURMI: { return APPEAR_TYPE_EFREETI;} //3109
				
			}
			break;
		case 68:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_EFREETI: { return APPEAR_TYPE_DWARF;} //3400
			}
			break;
	}
	
	return -1;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This decrements the appearance by one, soas to make it possible to iterate thru the various appearances by DM's
// * and it skips the invalid ones automatically
/*
int CSLGetDecrementAppearance( int iAppearanceType )
{
	//int iAppearanceType = GetAppearanceType(oTarget);
	if ( iAppearanceType == -1 ) { return -1; }
	
	iAppearanceType = CSLGetBaseAppearance( iAppearanceType );
	
	//int iAppearanceType = GetAppearanceType(oTarget);
	//if ( iAppearanceType == -1 ) { return 0.0f; }
	
	int iSubAppearance = iAppearanceType / 50;
	switch(iSubAppearance)
	{
		case 0:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DWARF: { return APPEAR_TYPE_EFREETI;} //0
				case APPEAR_TYPE_ELF: { return APPEAR_TYPE_DWARF;} //1
				case APPEAR_TYPE_GNOME: { return APPEAR_TYPE_ELF;} //2
				case APPEAR_TYPE_HALFLING: { return APPEAR_TYPE_GNOME;} //3
				case APPEAR_TYPE_HALF_ELF: { return APPEAR_TYPE_HALFLING;} //4
				case APPEAR_TYPE_HALF_ORC: { return APPEAR_TYPE_HALF_ELF;} //5
				case APPEAR_TYPE_HUMAN: { return APPEAR_TYPE_HALF_ORC;} //6
				case APPEAR_TYPE_HORSE_BROWN: { return APPEAR_TYPE_HUMAN;} //7
				case APPEAR_TYPE_BADGER: { return APPEAR_TYPE_HORSE_BROWN;} //8
				case APPEAR_TYPE_BADGER_DIRE: { return APPEAR_TYPE_BADGER;} //9
				case APPEAR_TYPE_BAT: { return APPEAR_TYPE_BADGER_DIRE;} //10
				case APPEAR_TYPE_HORSE_PINTO: { return APPEAR_TYPE_BAT;} //11
				case APPEAR_TYPE_HORSE_SKELETAL: { return APPEAR_TYPE_HORSE_PINTO;} //12
				case APPEAR_TYPE_BEAR_BROWN: { return APPEAR_TYPE_HORSE_SKELETAL;} //13
				case APPEAR_TYPE_HORSE_PALOMINO: { return APPEAR_TYPE_BEAR_BROWN;} //14
				case APPEAR_TYPE_BEAR_DIRE: { return APPEAR_TYPE_HORSE_PALOMINO;} //15
				case APPEAR_TYPE_DRAGON__BRONZE: { return APPEAR_TYPE_BEAR_DIRE;} //16
				case APPEAR_TYPE_YOUNG_BRONZE: { return APPEAR_TYPE_DRAGON__BRONZE;} //17
				case APPEAR_TYPE_BEETLE_FIRE: { return APPEAR_TYPE_YOUNG_BRONZE;} //18
				case APPEAR_TYPE_BEETLE_STAG: { return APPEAR_TYPE_BEETLE_FIRE;} //19
				case APPEAR_TYPE_YOUNG_BLUE: { return APPEAR_TYPE_BEETLE_STAG;} //20
				case APPEAR_TYPE_BOAR: { return APPEAR_TYPE_YOUNG_BLUE;} //21
				case APPEAR_TYPE_BOAR_DIRE: { return APPEAR_TYPE_BOAR;} //22
				case APPEAR_TYPE_YUANTI_ABOMINATION: { return APPEAR_TYPE_BOAR_DIRE;} //23
				case APPEAR_TYPE_WORG: { return APPEAR_TYPE_YUANTI_ABOMINATION;} //24
				case APPEAR_TYPE_YUANTI_HOLYGUARDIAN: { return APPEAR_TYPE_WORG;} //25
				case APPEAR_TYPE_PLANETAR: { return APPEAR_TYPE_YUANTI_HOLYGUARDIAN;} //26
				case APPEAR_TYPE_WILLOWISP: { return APPEAR_TYPE_PLANETAR;} //27
				case APPEAR_TYPE_FIRE_NEWT: { return APPEAR_TYPE_WILLOWISP;} //28
				case APPEAR_TYPE_DROWNED: { return APPEAR_TYPE_FIRE_NEWT;} //29
				case APPEAR_TYPE_MEGARAPTOR: { return APPEAR_TYPE_DROWNED;} //30
				case APPEAR_TYPE_CHICKEN: { return APPEAR_TYPE_MEGARAPTOR;} //31
				case APPEAR_TYPE_WIGHT: { return APPEAR_TYPE_CHICKEN;} //32
				case APPEAR_TYPE_CLOCKROACH: { return APPEAR_TYPE_WIGHT;} //33
				case APPEAR_TYPE_COW: { return APPEAR_TYPE_CLOCKROACH;} //34
				case APPEAR_TYPE_DEER: { return APPEAR_TYPE_COW;} //35
				case APPEAR_TYPE_DEINONYCHUS: { return APPEAR_TYPE_DEER;} //36
				case APPEAR_TYPE_DEER_STAG: { return APPEAR_TYPE_DEINONYCHUS;} //37
				case APPEAR_TYPE_BATIRI: { return APPEAR_TYPE_DEER_STAG;} //38
				case APPEAR_TYPE_LICH: { return APPEAR_TYPE_BATIRI;} //39
				case APPEAR_TYPE_YUANTIPUREBLOOD: { return APPEAR_TYPE_LICH;} //40
				case APPEAR_TYPE_DRAGON_BLACK: { return APPEAR_TYPE_YUANTIPUREBLOOD;} //41
				case APPEAR_TYPE_WAGON_LIGHT01: { return APPEAR_TYPE_DRAGON_BLACK;} //42
				case APPEAR_TYPE_WAGON_LIGHT02: { return APPEAR_TYPE_WAGON_LIGHT01;} //43
				case APPEAR_TYPE_WAGON_LIGHT03: { return APPEAR_TYPE_WAGON_LIGHT02;} //44
				case APPEAR_TYPE_GRAYORC: { return APPEAR_TYPE_WAGON_LIGHT03;} //45
				case APPEAR_TYPE_YUANTI_HERALD: { return APPEAR_TYPE_GRAYORC;} //46
				case APPEAR_TYPE_NPC_SASANI: { return APPEAR_TYPE_YUANTI_HERALD;} //47
				case APPEAR_TYPE_NPC_VOLO: { return APPEAR_TYPE_NPC_SASANI;} //48
				case APPEAR_TYPE_DRAGON_RED: { return APPEAR_TYPE_NPC_VOLO;} //49
			}
			break;
		case 1:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_SEPTIMUND: { return APPEAR_TYPE_DRAGON_RED;} //50
				case APPEAR_TYPE_DRYAD: { return APPEAR_TYPE_NPC_SEPTIMUND;} //51
				case APPEAR_TYPE_ELEMENTAL_AIR: { return APPEAR_TYPE_DRYAD;} //52
				case APPEAR_TYPE_ELEMENTAL_AIR_ELDER: { return APPEAR_TYPE_ELEMENTAL_AIR;} //53
				case APPEAR_TYPE_ELEMENTAL_EARTH: { return APPEAR_TYPE_ELEMENTAL_AIR_ELDER;} //56
				case APPEAR_TYPE_ELEMENTAL_EARTH_ELDER: { return APPEAR_TYPE_ELEMENTAL_EARTH;} //57
				case APPEAR_TYPE_MUMMY_COMMON: { return APPEAR_TYPE_ELEMENTAL_EARTH_ELDER;} //58
				case APPEAR_TYPE_ELEMENTAL_FIRE: { return APPEAR_TYPE_MUMMY_COMMON;} //60
				case APPEAR_TYPE_ELEMENTAL_FIRE_ELDER: { return APPEAR_TYPE_ELEMENTAL_FIRE;} //61
				case APPEAR_TYPE_ELEMENTAL_WATER_ELDER: { return APPEAR_TYPE_ELEMENTAL_FIRE_ELDER;} //68
				case APPEAR_TYPE_ELEMENTAL_WATER: { return APPEAR_TYPE_ELEMENTAL_WATER_ELDER;} //69
				case APPEAR_TYPE_GARGOYLE: { return APPEAR_TYPE_ELEMENTAL_WATER;} //73
				case APPEAR_TYPE_GHAST: { return APPEAR_TYPE_GARGOYLE;} //74
				case APPEAR_TYPE_GHOUL: { return APPEAR_TYPE_GHAST;} //76
				case APPEAR_TYPE_GIANT_FIRE: { return APPEAR_TYPE_GHOUL;} //80
				case APPEAR_TYPE_GIANT_FROST: { return APPEAR_TYPE_GIANT_FIRE;} //81
				case APPEAR_TYPE_GOLEM_IRON: { return APPEAR_TYPE_GIANT_FROST;} //89
			}
			break;
		case 2:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VROCK: { return APPEAR_TYPE_GOLEM_IRON;} //105
				
				case APPEAR_TYPE_IMP: { return APPEAR_TYPE_VROCK;} //105
				case APPEAR_TYPE_MEPHIT_FIRE: { return APPEAR_TYPE_IMP;} //109
				case APPEAR_TYPE_MEPHIT_ICE: { return APPEAR_TYPE_MEPHIT_FIRE;} //110
				case APPEAR_TYPE_OGRE: { return APPEAR_TYPE_MEPHIT_ICE;} //127
				case APPEAR_TYPE_OGRE_MAGE: { return APPEAR_TYPE_OGRE;} //129
				case APPEAR_TYPE_ORC_A: { return APPEAR_TYPE_OGRE_MAGE;} //140
			}
			break;
		case 3:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SLAAD_BLUE: { return APPEAR_TYPE_ORC_A;} //151
				case APPEAR_TYPE_SLAAD_GREEN: { return APPEAR_TYPE_SLAAD_BLUE;} //154
				case APPEAR_TYPE_SPECTRE: { return APPEAR_TYPE_SLAAD_GREEN;} //156
				case APPEAR_TYPE_SPIDER_DIRE: { return APPEAR_TYPE_SPECTRE;} //158
				case APPEAR_TYPE_SPIDER_GIANT: { return APPEAR_TYPE_SPIDER_DIRE;} //159
				case APPEAR_TYPE_SPIDER_PHASE: { return APPEAR_TYPE_SPIDER_GIANT;} //160
				case APPEAR_TYPE_SPIDER_BLADE: { return APPEAR_TYPE_SPIDER_PHASE;} //161
				case APPEAR_TYPE_SPIDER_WRAITH: { return APPEAR_TYPE_SPIDER_BLADE;} //162
				case APPEAR_TYPE_SUCCUBUS: { return APPEAR_TYPE_SPIDER_WRAITH;} //163
				case APPEAR_TYPE_TROLL: { return APPEAR_TYPE_SUCCUBUS;} //167
				case APPEAR_TYPE_UMBERHULK: { return APPEAR_TYPE_TROLL;} //168
				case APPEAR_TYPE_WEREWOLF: { return APPEAR_TYPE_UMBERHULK;} //171
				case APPEAR_TYPE_DOG_DIRE_WOLF: { return APPEAR_TYPE_WEREWOLF;} //175
				case APPEAR_TYPE_DOG_HELL_HOUND: { return APPEAR_TYPE_DOG_DIRE_WOLF;} //179
				case APPEAR_TYPE_DOG_SHADOW_MASTIF: { return APPEAR_TYPE_DOG_HELL_HOUND;} //180
				case APPEAR_TYPE_DOG_WOLF: { return APPEAR_TYPE_DOG_SHADOW_MASTIF;} //181
				case APPEAR_TYPE_DOG_WINTER_WOLF: { return APPEAR_TYPE_DOG_WOLF;} //184
				case APPEAR_TYPE_DREAD_WRAITH: { return APPEAR_TYPE_DOG_WINTER_WOLF;} //186
				case APPEAR_TYPE_WRAITH: { return APPEAR_TYPE_DREAD_WRAITH;} //187
				case APPEAR_TYPE_ZOMBIE: { return APPEAR_TYPE_WRAITH;} //198
			}
			break;
		case 5:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VAMPIRE_FEMALE: { return APPEAR_TYPE_ZOMBIE;} //288
				case APPEAR_TYPE_VAMPIRE_MALE: { return APPEAR_TYPE_VAMPIRE_FEMALE;} //289
				
			}
			break;
		case 7:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RAT: { return APPEAR_TYPE_VAMPIRE_MALE;} //386
				case APPEAR_TYPE_RAT_DIRE: { return APPEAR_TYPE_RAT;} //387
				
			}
			break;
		case 8:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_MINDFLAYER: { return APPEAR_TYPE_RAT_DIRE;} //413
			}
			break;
		case 9:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DEVIL_HORNED: { return APPEAR_TYPE_MINDFLAYER;} //481
				case APPEAR_TYPE_SPIDER_BONE: { return APPEAR_TYPE_DEVIL_HORNED;} //482
				case APPEAR_TYPE_GITHYANKI: { return APPEAR_TYPE_SPIDER_BONE;} //483
				case APPEAR_TYPE_BIRD: { return APPEAR_TYPE_GITHYANKI;} //485
				case APPEAR_TYPE_BLADELING: { return APPEAR_TYPE_BIRD;} //486
				case APPEAR_TYPE_CAT: { return APPEAR_TYPE_BLADELING;} //487
				case APPEAR_TYPE_DEMON_HEZROU: { return APPEAR_TYPE_CAT;} //488
				case APPEAR_TYPE_DEVIL_PITFIEND: { return APPEAR_TYPE_DEMON_HEZROU;} //489
				case APPEAR_TYPE_GOLEM_BLADE: { return APPEAR_TYPE_DEVIL_PITFIEND;} //493
				case APPEAR_TYPE_SHADOW: { return APPEAR_TYPE_GOLEM_BLADE;} //496
				case APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER: { return APPEAR_TYPE_SHADOW;} //497
				case APPEAR_TYPE_PIG: { return APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER;} //498
				case APPEAR_TYPE_RABBIT: { return APPEAR_TYPE_PIG;} //499
			}
			break;
		case 10:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SHADOW_REAVER: { return APPEAR_TYPE_RABBIT;} //500
				case APPEAR_TYPE_WEASEL: { return APPEAR_TYPE_SHADOW_REAVER;} //503
				case APPEAR_TYPE_SYLPH: { return APPEAR_TYPE_WEASEL;} //512
				case APPEAR_TYPE_DEVIL_ERINYES: { return APPEAR_TYPE_SYLPH;} //514
				case APPEAR_TYPE_PIXIE: { return APPEAR_TYPE_DEVIL_ERINYES;} //521
				case APPEAR_TYPE_DEMON_BALOR: { return APPEAR_TYPE_PIXIE;} //522
				case APPEAR_TYPE_GNOLL: { return APPEAR_TYPE_DEMON_BALOR;} //533
				case APPEAR_TYPE_GOBLIN: { return APPEAR_TYPE_GNOLL;} //534
				case APPEAR_TYPE_KOBOLD: { return APPEAR_TYPE_GOBLIN;} //535
				case APPEAR_TYPE_LIZARDFOLK: { return APPEAR_TYPE_KOBOLD;} //536
				case APPEAR_TYPE_SKELETON: { return APPEAR_TYPE_LIZARDFOLK;} //537
				case APPEAR_TYPE_BEETLE_BOMBARDIER: { return APPEAR_TYPE_SKELETON;} //538
				case APPEAR_TYPE_BUGBEAR: { return APPEAR_TYPE_BEETLE_BOMBARDIER;} //543
				case APPEAR_TYPE_NPC_GARIUS: { return APPEAR_TYPE_BUGBEAR;} //544
				case APPEAR_TYPE_SPIDER_GLOW: { return APPEAR_TYPE_NPC_GARIUS;} //546
				case APPEAR_TYPE_SPIDER_KRISTAL: { return APPEAR_TYPE_SPIDER_GLOW;} //547
				case APPEAR_TYPE_NPC_DUNCAN: { return APPEAR_TYPE_SPIDER_KRISTAL;} //549
			}
			break;
		case 11:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_LORDNASHER: { return APPEAR_TYPE_NPC_DUNCAN;} //550
				case APPEAR_TYPE_NPC_CHILDHHM: { return APPEAR_TYPE_NPC_LORDNASHER;} //551
				case APPEAR_TYPE_NPC_CHILDHHF: { return APPEAR_TYPE_NPC_CHILDHHM;} //553
				case APPEAR_TYPE_ELEMENTAL_AIR_HUGE: { return APPEAR_TYPE_NPC_CHILDHHF;} //554
				case APPEAR_TYPE_ELEMENTAL_AIR_GREATER: { return APPEAR_TYPE_ELEMENTAL_AIR_HUGE;} //555
				case APPEAR_TYPE_ELEMENTAL_EARTH_HUGE: { return APPEAR_TYPE_ELEMENTAL_AIR_GREATER;} //556
				case APPEAR_TYPE_ELEMENTAL_EARTH_GREATER: { return APPEAR_TYPE_ELEMENTAL_EARTH_HUGE;} //557
				case APPEAR_TYPE_ELEMENTAL_FIRE_HUGE: { return APPEAR_TYPE_ELEMENTAL_EARTH_GREATER;} //558
				case APPEAR_TYPE_ELEMENTAL_FIRE_GREATER: { return APPEAR_TYPE_ELEMENTAL_FIRE_HUGE;} //559
				case APPEAR_TYPE_ELEMENTAL_WATER_HUGE: { return APPEAR_TYPE_ELEMENTAL_FIRE_GREATER;} //560
				case APPEAR_TYPE_ELEMENTAL_WATER_GREATER: { return APPEAR_TYPE_ELEMENTAL_WATER_HUGE;} //561
				case APPEAR_TYPE_SIEGETOWER: { return APPEAR_TYPE_ELEMENTAL_WATER_GREATER;} //562
				case APPEAR_TYPE_ASSIMAR: { return APPEAR_TYPE_SIEGETOWER;} //563
				case APPEAR_TYPE_TIEFLING: { return APPEAR_TYPE_ASSIMAR;} //564
				case APPEAR_TYPE_ELF_SUN: { return APPEAR_TYPE_TIEFLING;} //565
				case APPEAR_TYPE_ELF_WOOD: { return APPEAR_TYPE_ELF_SUN;} //566
				case APPEAR_TYPE_ELF_DROW: { return APPEAR_TYPE_ELF_WOOD;} //567
				case APPEAR_TYPE_GNOME_SVIRFNEBLIN: { return APPEAR_TYPE_ELF_DROW;} //568
				case APPEAR_TYPE_DWARF_GOLD: { return APPEAR_TYPE_GNOME_SVIRFNEBLIN;} //569
				case APPEAR_TYPE_DWARF_DUERGAR: { return APPEAR_TYPE_DWARF_GOLD;} //570
				case APPEAR_TYPE_HALFLING_STRONGHEART: { return APPEAR_TYPE_DWARF_DUERGAR;} //571
				case APPEAR_TYPE_CARGOSHIP: { return APPEAR_TYPE_HALFLING_STRONGHEART;} //572
				case APPEAR_TYPE_N_HUMAN: { return APPEAR_TYPE_CARGOSHIP;} //573
				case APPEAR_TYPE_N_ELF: { return APPEAR_TYPE_N_HUMAN;} //574
				case APPEAR_TYPE_N_DWARF: { return APPEAR_TYPE_N_ELF;} //575
				case APPEAR_TYPE_N_HALF_ELF: { return APPEAR_TYPE_N_DWARF;} //576
				case APPEAR_TYPE_N_GNOME: { return APPEAR_TYPE_N_HALF_ELF;} //577
				case APPEAR_TYPE_N_TIEFLING: { return APPEAR_TYPE_N_GNOME;} //578
				case APPEAR_TYPE_NPC_GITHCAPTAIN: { return APPEAR_TYPE_N_TIEFLING;} //579
				case APPEAR_TYPE_NPC_LORNE: { return APPEAR_TYPE_NPC_GITHCAPTAIN;} //580
				case APPEAR_TYPE_NPC_TENAVROK: { return APPEAR_TYPE_NPC_LORNE;} //581
				case APPEAR_TYPE_NPC_CTANN: { return APPEAR_TYPE_NPC_TENAVROK;} //582
				case APPEAR_TYPE_NPC_SHANDRA: { return APPEAR_TYPE_NPC_CTANN;} //583
				case APPEAR_TYPE_NPC_ZEEAIRE: { return APPEAR_TYPE_NPC_SHANDRA;} //584
				case APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT: { return APPEAR_TYPE_NPC_ZEEAIRE;} //585
				case APPEAR_TYPE_NPC_KINGOFSHADOWS: { return APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT;} //586
				case APPEAR_TYPE_NPC_NOLALOTH: { return APPEAR_TYPE_NPC_KINGOFSHADOWS;} //587
				case APPEAR_TYPE_NPC_ZHJAEVE: { return APPEAR_TYPE_NPC_NOLALOTH;} //588
				case APPEAR_TYPE_NPC_ZAXIS: { return APPEAR_TYPE_NPC_ZHJAEVE;} //589
				case APPEAR_TYPE_NPC_AHJA: { return APPEAR_TYPE_NPC_ZAXIS;} //590
				case APPEAR_TYPE_NPC_DURLER: { return APPEAR_TYPE_NPC_AHJA;} //591
				case APPEAR_TYPE_NPC_HEZEBEL: { return APPEAR_TYPE_NPC_DURLER;} //592
				case APPEAR_TYPE_NPC_HOSTTOWER: { return APPEAR_TYPE_NPC_HEZEBEL;} //593
				case APPEAR_TYPE_NPC_ZOKAN: { return APPEAR_TYPE_NPC_HOSTTOWER;} //594
				case APPEAR_TYPE_NPC_ALDANON: { return APPEAR_TYPE_NPC_ZOKAN;} //595
				case APPEAR_TYPE_NPC_JACOBY: { return APPEAR_TYPE_NPC_ALDANON;} //596
				case APPEAR_TYPE_NPC_JALBOUN: { return APPEAR_TYPE_NPC_JACOBY;} //597
				case APPEAR_TYPE_NPC_KHRALVER: { return APPEAR_TYPE_NPC_JALBOUN;} //598
				case APPEAR_TYPE_NPC_KRALWOK: { return APPEAR_TYPE_NPC_KHRALVER;} //599
			}
			break;
		case 12:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_MEPHASM: { return APPEAR_TYPE_NPC_KRALWOK;} //600
				case APPEAR_TYPE_NPC_MORKAI: { return APPEAR_TYPE_NPC_MEPHASM;} //601
				case APPEAR_TYPE_NPC_SARYA: { return APPEAR_TYPE_NPC_MORKAI;} //602
				case APPEAR_TYPE_NPC_SYDNEY: { return APPEAR_TYPE_NPC_SARYA;} //603
				case APPEAR_TYPE_NPC_TORIOCLAVEN: { return APPEAR_TYPE_NPC_SYDNEY;} //604
				case APPEAR_TYPE_NPC_UTHANCK: { return APPEAR_TYPE_NPC_TORIOCLAVEN;} //605
				case APPEAR_TYPE_NPC_SHADOWPRIEST: { return APPEAR_TYPE_NPC_UTHANCK;} //606
				case APPEAR_TYPE_NPC_HUNTERSTATUE: { return APPEAR_TYPE_NPC_SHADOWPRIEST;} //607
				case APPEAR_TYPE_SIEGETOWERB: { return APPEAR_TYPE_NPC_HUNTERSTATUE;} //608
				case APPEAR_TYPE_PUSHBLOCK: { return APPEAR_TYPE_SIEGETOWERB;} //609
				case APPEAR_TYPE_SMUGGLERWAGON: { return APPEAR_TYPE_PUSHBLOCK;} //610
				case APPEAR_TYPE_INVISIBLEMAN: { return APPEAR_TYPE_SMUGGLERWAGON;} //611
			}
			break;
		case 20:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AKACHI: { return APPEAR_TYPE_INVISIBLEMAN;} //1000
				case APPEAR_TYPE_OKKU_BEAR: { return APPEAR_TYPE_AKACHI;} //1001
				case APPEAR_TYPE_PANTHER: { return APPEAR_TYPE_OKKU_BEAR;} //1002
				case APPEAR_TYPE_WOLVERINE: { return APPEAR_TYPE_PANTHER;} //1003
				case APPEAR_TYPE_INVISIBLE_STALKER: { return APPEAR_TYPE_WOLVERINE;} //1004
				case APPEAR_TYPE_HOMUNCULUS: { return APPEAR_TYPE_INVISIBLE_STALKER;} //1005
				case APPEAR_TYPE_GOLEM_IMASKARI: { return APPEAR_TYPE_HOMUNCULUS;} //1006
				case APPEAR_TYPE_RED_WIZ_COMPANION: { return APPEAR_TYPE_GOLEM_IMASKARI;} //1007
				case APPEAR_TYPE_DEATH_KNIGHT: { return APPEAR_TYPE_RED_WIZ_COMPANION;} //1008
				case APPEAR_TYPE_BARROW_GUARDIAN: { return APPEAR_TYPE_DEATH_KNIGHT;} //1009
				case APPEAR_TYPE_SEA_MONSTER: { return APPEAR_TYPE_BARROW_GUARDIAN;} //1010
				case APPEAR_TYPE_ONE_OF_MANY: { return APPEAR_TYPE_SEA_MONSTER;} //1011
				case APPEAR_TYPE_SHAMBLING_MOUND: { return APPEAR_TYPE_ONE_OF_MANY;} //1012
				case APPEAR_TYPE_SOLAR: { return APPEAR_TYPE_SHAMBLING_MOUND;} //1013
				case APPEAR_TYPE_WOLVERINE_DIRE: { return APPEAR_TYPE_SOLAR;} //1014
				case APPEAR_TYPE_DRAGON_BLUE: { return APPEAR_TYPE_WOLVERINE_DIRE;} //1015
				case APPEAR_TYPE_DJINN: { return APPEAR_TYPE_DRAGON_BLUE;} //1016
				case APPEAR_TYPE_GNOLL_THAYAN: { return APPEAR_TYPE_DJINN;} //1017
				case APPEAR_TYPE_GOLEM_CLAY: { return APPEAR_TYPE_GNOLL_THAYAN;} //1018
				case APPEAR_TYPE_GOLEM_FAITHLESS: { return APPEAR_TYPE_GOLEM_CLAY;} //1019
				case APPEAR_TYPE_DEMILICH: { return APPEAR_TYPE_GOLEM_FAITHLESS;} //1020
				case APPEAR_TYPE_HAG_ANNIS: { return APPEAR_TYPE_DEMILICH;} //1021
				case APPEAR_TYPE_HAG_GREEN: { return APPEAR_TYPE_HAG_ANNIS;} //1022
				case APPEAR_TYPE_HAG_NIGHT: { return APPEAR_TYPE_HAG_GREEN;} //1023
				case APPEAR_TYPE_HORSE_WHITE: { return APPEAR_TYPE_HAG_NIGHT;} //1024
				case APPEAR_TYPE_DEMILICH_SMALL: { return APPEAR_TYPE_HORSE_WHITE;} //1025
				case APPEAR_TYPE_LEOPARD_SNOW: { return APPEAR_TYPE_DEMILICH_SMALL;} //1026
				case APPEAR_TYPE_TREANT: { return APPEAR_TYPE_LEOPARD_SNOW;} //1027
				case APPEAR_TYPE_TROLL_FELL: { return APPEAR_TYPE_TREANT;} //1028
				case APPEAR_TYPE_UTHRAKI: { return APPEAR_TYPE_TROLL_FELL;} //1029
				case APPEAR_TYPE_WYVERN: { return APPEAR_TYPE_UTHRAKI;} //1030
				case APPEAR_TYPE_RAVENOUS_INCARNATION: { return APPEAR_TYPE_WYVERN;} //1031
				case APPEAR_TYPE_N_ELF_WILD: { return APPEAR_TYPE_RAVENOUS_INCARNATION;} //1032
				case APPEAR_TYPE_N_HALF_DROW: { return APPEAR_TYPE_N_ELF_WILD;} //1033
				case APPEAR_TYPE_MAGDA: { return APPEAR_TYPE_N_HALF_DROW;} //1034
				case APPEAR_TYPE_NEFRIS: { return APPEAR_TYPE_MAGDA;} //1035
				case APPEAR_TYPE_ELF_WILD: { return APPEAR_TYPE_NEFRIS;} //1036
				case APPEAR_TYPE_EARTH_GENASI: { return APPEAR_TYPE_ELF_WILD;} //1037
				case APPEAR_TYPE_FIRE_GENASI: { return APPEAR_TYPE_EARTH_GENASI;} //1038
				case APPEAR_TYPE_AIR_GENASI: { return APPEAR_TYPE_FIRE_GENASI;} //1039
				case APPEAR_TYPE_WATER_GENASI: { return APPEAR_TYPE_AIR_GENASI;} //1040
				case APPEAR_TYPE_HALF_DROW: { return APPEAR_TYPE_WATER_GENASI;} //1041
				case APPEAR_TYPE_DOG_WOLF_TELTHOR: { return APPEAR_TYPE_HALF_DROW;} //1042
				case APPEAR_TYPE_HAGSPAWN_VAR1: { return APPEAR_TYPE_DOG_WOLF_TELTHOR;} //1043
				
				case APPEAR_TYPE_DEVEIL_PAELIRYON: { return APPEAR_TYPE_HAGSPAWN_VAR1;} //1044
				case APPEAR_TYPE_WERERAT: { return APPEAR_TYPE_DEVEIL_PAELIRYON;} //1045
				case APPEAR_TYPE_ORBAKH: { return APPEAR_TYPE_WERERAT;} //1046
				case APPEAR_TYPE_QUELZARN: { return APPEAR_TYPE_ORBAKH;} //1047
			}
			break;
		case 24:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_BEHOLDER: { return APPEAR_TYPE_QUELZARN;} //1201
				case APPEAR_TYPE_REE_YUANTIF: { return APPEAR_TYPE_BEHOLDER;} //1204
				case APPEAR_TYPE_DRIDER: { return APPEAR_TYPE_REE_YUANTIF;} //1206
				case APPEAR_TYPE_MINOTAUR: { return APPEAR_TYPE_DRIDER;} //1208
			}
			break;
		case 28:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AZERBLOOD_ROF: { return APPEAR_TYPE_MINOTAUR;} //1400;
				case APPEAR_TYPE_FROSTBLOT_ROF: { return APPEAR_TYPE_AZERBLOOD_ROF;} //1401;
				case APPEAR_TYPE_ELDBLOT_ROF: { return APPEAR_TYPE_FROSTBLOT_ROF;} //1402;
				case APPEAR_TYPE_ARCTIC_DWARF_ROF: { return APPEAR_TYPE_ELDBLOT_ROF;} //1403;
				case APPEAR_TYPE_WILD_DWARF_ROF: { return APPEAR_TYPE_ARCTIC_DWARF_ROF;} //1404;
				case APPEAR_TYPE_TANARUKK_ROF: { return APPEAR_TYPE_WILD_DWARF_ROF;} //1405;
				case APPEAR_TYPE_HOBGOBLIN_ROF: { return APPEAR_TYPE_TANARUKK_ROF;} //1407;
				case APPEAR_TYPE_FOREST_GNOME_ROF: { return APPEAR_TYPE_HOBGOBLIN_ROF;} //1409;
				case APPEAR_TYPE_YUANTI_HALFBLOOD_ROF: { return APPEAR_TYPE_FOREST_GNOME_ROF;} //1410;
				case APPEAR_TYPE_ASABI_ROF: { return APPEAR_TYPE_YUANTI_HALFBLOOD_ROF;} //1411;
				case APPEAR_TYPE_LIZARDFOLD_ROF: { return APPEAR_TYPE_ASABI_ROF;} //1412;
				case APPEAR_TYPE_OGRE_ROF: { return APPEAR_TYPE_LIZARDFOLD_ROF;} //1413;
				case APPEAR_TYPE_PIXIE_ROF: { return APPEAR_TYPE_OGRE_ROF;} //1414;
				case APPEAR_TYPE_DRAGONKIN_ROF: { return APPEAR_TYPE_PIXIE_ROF;} //1415;
				case APPEAR_TYPE_GLOAMING_ROF: { return APPEAR_TYPE_DRAGONKIN_ROF;} //1416;
				case APPEAR_TYPE_CHAOND_ROF: { return APPEAR_TYPE_GLOAMING_ROF;} //1417;
				case APPEAR_TYPE_ELF_DUNE_ROF: { return APPEAR_TYPE_CHAOND_ROF;} //1418;
				case APPEAR_TYPE_BROWNIE_ROF: { return APPEAR_TYPE_ELF_DUNE_ROF;} //1419;
				case APPEAR_TYPE_ULDRA_ROF: { return APPEAR_TYPE_BROWNIE_ROF;} //1420;
				case APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF: { return APPEAR_TYPE_ULDRA_ROF;} //1421;
				case APPEAR_TYPE_ELF_POSCADAR_ROF: { return APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF;} //1422;
				case APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF: { return APPEAR_TYPE_ELF_POSCADAR_ROF;} //1423;
				case APPEAR_TYPE_FIRBOLG_ROF: { return APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF;} //1424;
				case APPEAR_TYPE_FOMORIAN_ROF: { return APPEAR_TYPE_FIRBOLG_ROF;} //1425;
				case APPEAR_TYPE_VERBEEG_ROF: { return APPEAR_TYPE_FOMORIAN_ROF;} //1426;
				case APPEAR_TYPE_VOADKYN_ROF: { return APPEAR_TYPE_VERBEEG_ROF;} //1427;
				case APPEAR_TYPE_FJELLBLOT_ROF: { return APPEAR_TYPE_VOADKYN_ROF;} //1428;
				case APPEAR_TYPE_TAKEBLOT_ROF: { return APPEAR_TYPE_FJELLBLOT_ROF;} //1429;
				case APPEAR_TYPE_AIR_MEPHLING_ROF: { return APPEAR_TYPE_TAKEBLOT_ROF;} //1430;
				case APPEAR_TYPE_EARTH_MEPHLING_ROF: { return APPEAR_TYPE_AIR_MEPHLING_ROF;} //1431;
				case APPEAR_TYPE_FIRE_MEPHLING_ROF: { return APPEAR_TYPE_EARTH_MEPHLING_ROF;} //1432;
				case APPEAR_TYPE_WATER_MEPHLING_ROF: { return APPEAR_TYPE_FIRE_MEPHLING_ROF;} //1433;
				case APPEAR_TYPE_KHAASTA_ROF: { return APPEAR_TYPE_WATER_MEPHLING_ROF;} //1434;
				case APPEAR_TYPE_MOUNTAIN_ORC_ROF: { return APPEAR_TYPE_KHAASTA_ROF;} //1435;
				case APPEAR_TYPE_BOOGIN_ROF: { return APPEAR_TYPE_MOUNTAIN_ORC_ROF;} //1436;
				case APPEAR_TYPE_ICE_SPIRE_OGRE_ROF: { return APPEAR_TYPE_BOOGIN_ROF;} //1437;
				case APPEAR_TYPE_OGRILLON_ROF: { return APPEAR_TYPE_ICE_SPIRE_OGRE_ROF;} //1438;
				case APPEAR_TYPE_KRINTH_ROF: { return APPEAR_TYPE_OGRILLON_ROF;} //1439;
				case APPEAR_TYPE_HALFLING_SANDSTORM_ROF: { return APPEAR_TYPE_KRINTH_ROF;} //1440;
				case APPEAR_TYPE_DWARF_DEGLOSIAN_ROF: { return APPEAR_TYPE_HALFLING_SANDSTORM_ROF;} //1441;
				case APPEAR_TYPE_DWARF_GALDOSIAN_ROF: { return APPEAR_TYPE_DWARF_DEGLOSIAN_ROF;} //1442;
				case APPEAR_TYPE_ELF_ROF: { return APPEAR_TYPE_DWARF_GALDOSIAN_ROF;} //1443;
				case APPEAR_TYPE_ELF_DRANGONARI_ROF: { return APPEAR_TYPE_ELF_ROF;} //1444;
				case APPEAR_TYPE_ELF_GHOST_ROF: { return APPEAR_TYPE_ELF_DRANGONARI_ROF;} //1445;
				case APPEAR_TYPE_FAERIE_ROF: { return APPEAR_TYPE_ELF_GHOST_ROF;} //1446;
				case APPEAR_TYPE_GNOME_ROF: { return APPEAR_TYPE_FAERIE_ROF;} //1447;
				case APPEAR_TYPE_GOBLIN_ROF: { return APPEAR_TYPE_GNOME_ROF;} //1448;
				case APPEAR_TYPE_HALF_ELF_ROF: { return APPEAR_TYPE_GOBLIN_ROF;} //1449;
			}
			break;
		case 29:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_HALF_ORC_ROF: { return APPEAR_TYPE_HALF_ELF_ROF;} //1450;
				case APPEAR_TYPE_HALFLING_ROF: { return APPEAR_TYPE_HALF_ORC_ROF;} //1451
				case APPEAR_TYPE_HUMAN_ROF: { return APPEAR_TYPE_HALFLING_ROF;} //1452
				case APPEAR_TYPE_OROG_ROF: { return APPEAR_TYPE_HUMAN_ROF;} //1453
				case APPEAR_TYPE_AELFBORN_ROF: { return APPEAR_TYPE_OROG_ROF;} //1454
				case APPEAR_TYPE_FEYRI_ROF: { return APPEAR_TYPE_AELFBORN_ROF;} //1455
				case APPEAR_TYPE_SEWER_GOBLIN_ROF: { return APPEAR_TYPE_FEYRI_ROF;} //1456
				case APPEAR_TYPE_WOOD_GENASI_ROF: { return APPEAR_TYPE_SEWER_GOBLIN_ROF;} //1457
				case APPEAR_TYPE_HALF_CELESTIAL_ROF: { return APPEAR_TYPE_WOOD_GENASI_ROF;} //1458
				case APPEAR_TYPE_DERRO_ROF: { return APPEAR_TYPE_HALF_CELESTIAL_ROF;} //1459
				case APPEAR_TYPE_HALF_OGRE_ROF: { return APPEAR_TYPE_DERRO_ROF;} //1460
				case APPEAR_TYPE_DRAGONBORN_ROF: { return APPEAR_TYPE_HALF_OGRE_ROF;} //1461
				case APPEAR_TYPE_URD_ROF: { return APPEAR_TYPE_DRAGONBORN_ROF;} //1462
				case APPEAR_TYPE_CELADRIN_ROF: { return APPEAR_TYPE_URD_ROF;} //1463
				case APPEAR_TYPE_SYLPH_ROF: { return APPEAR_TYPE_CELADRIN_ROF;} //1464
				case APPEAR_TYPE_FLAMEBROTHER_ROF: { return APPEAR_TYPE_SYLPH_ROF;} //1465
			}
			break;
		case 30:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RUST_MONSTER: { return APPEAR_TYPE_FLAMEBROTHER_ROF;} //1500
				case APPEAR_TYPE_BASILIK: { return APPEAR_TYPE_RUST_MONSTER;} //1501
				case APPEAR_TYPE_SNAKE: { return APPEAR_TYPE_BASILIK;} //1502
				//case APPEAR_TYPE_MONODRONE: { return APPEAR_TYPE_SNAKE;} //1503
				case APPEAR_TYPE_SCORPION: { return APPEAR_TYPE_SNAKE;} //1504
				case APPEAR_TYPE_XORN: { return APPEAR_TYPE_SCORPION;} //1505
				case APPEAR_TYPE_CARRION_CRAWLER: { return APPEAR_TYPE_XORN;} //1506
				case APPEAR_TYPE_DRACOLICH: { return APPEAR_TYPE_CARRION_CRAWLER;} //1507
				case APPEAR_TYPE_DISPLACER_BEAST: { return APPEAR_TYPE_DRACOLICH;} //1508	
			}
			break;
		case 40:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RDS_PORTAL: { return APPEAR_TYPE_DISPLACER_BEAST;} //2041
				case APPEAR_TYPE_FLYING_BOOK: { return APPEAR_TYPE_RDS_PORTAL;} //2042
				case APPEAR_TYPE_RAT_CRANIUM: { return APPEAR_TYPE_FLYING_BOOK;} //2043
				case APPEAR_TYPE_SLIME: { return APPEAR_TYPE_RAT_CRANIUM;} //2044
				case APPEAR_TYPE_MONODRONE: { return APPEAR_TYPE_SLIME;} //2045
				case APPEAR_TYPE_SPIDER_HOOK: { return APPEAR_TYPE_MONODRONE;} //2046
				case APPEAR_TYPE_DABUS: { return APPEAR_TYPE_SPIDER_HOOK;} //2047
				case APPEAR_TYPE_BARIAUR: { return APPEAR_TYPE_DABUS;} //2049
				
			}
			break;
		case 41:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DOGDEAD: { return APPEAR_TYPE_BARIAUR;} //2053
				case APPEAR_TYPE_URIDEZU: { return APPEAR_TYPE_DOGDEAD;} //2054
				case APPEAR_TYPE_DUODRONE: { return APPEAR_TYPE_URIDEZU;} //2055
				case APPEAR_TYPE_TRIDRONE: { return APPEAR_TYPE_DUODRONE;} //2056
				case APPEAR_TYPE_PENTADRONE: { return APPEAR_TYPE_TRIDRONE;} //2057
			}
			break;
		case 46:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GELATINOUS_CUBE: { return APPEAR_TYPE_PENTADRONE;} //2300
				case APPEAR_TYPE_OOZE: { return APPEAR_TYPE_GELATINOUS_CUBE;} //2301
				case APPEAR_TYPE_HAMMERHEAD_SHARK: { return APPEAR_TYPE_OOZE;} //2302
				case APPEAR_TYPE_MAKO_SHARK: { return APPEAR_TYPE_HAMMERHEAD_SHARK;} //2303
				case APPEAR_TYPE_MYCONID: { return APPEAR_TYPE_MAKO_SHARK;} //2304
				
								
				case APPEAR_TYPE_NAGA: { return APPEAR_TYPE_MYCONID;} //2305
				case APPEAR_TYPE_PURRLE_WORM: { return APPEAR_TYPE_NAGA;} //2306
				case APPEAR_TYPE_STIRGE: { return APPEAR_TYPE_PURRLE_WORM;} //2307
				case APPEAR_TYPE_STIRGE_TINT: { return APPEAR_TYPE_STIRGE;} //2308
				case APPEAR_TYPE_PURRLE_WORM_TINT: { return APPEAR_TYPE_STIRGE_TINT;} //2309

			}
			break;
		case 60:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GIANT_HILL: { return APPEAR_TYPE_PURRLE_WORM_TINT;} //3000
				case APPEAR_TYPE_GIANT_STONE: { return APPEAR_TYPE_GIANT_HILL;} //3001
				case APPEAR_TYPE_GIANT_FIRE_ALT: { return APPEAR_TYPE_GIANT_STONE;} //3002
				case APPEAR_TYPE_GIANT_FROST_ALT: { return APPEAR_TYPE_GIANT_FIRE_ALT;} //3003
				case APPEAR_TYPE_GIANT_CLOUD: { return APPEAR_TYPE_GIANT_FROST_ALT;} //3004
				case APPEAR_TYPE_GIANT_FOREST: { return APPEAR_TYPE_GIANT_CLOUD;} //3005
				case APPEAR_TYPE_GIANT_STORM: { return APPEAR_TYPE_GIANT_FOREST;} //3006
				
				case APPEAR_TYPE_GIBBERING_MOUTHER: { return APPEAR_TYPE_GIANT_STORM;} //3010
				case APPEAR_TYPE_BIGBY_GRASPING: { return APPEAR_TYPE_GIBBERING_MOUTHER;} //3020
				case APPEAR_TYPE_BIGBY_INTERPOS: { return APPEAR_TYPE_BIGBY_GRASPING;} //3021
				case APPEAR_TYPE_BIGBY_FIST: { return APPEAR_TYPE_BIGBY_INTERPOS;} //3022
				
			}
			break;
		case 62:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DRAGONMAN: { return APPEAR_TYPE_BIGBY_FIST;} //3100
				case APPEAR_TYPE_UNICORN: { return APPEAR_TYPE_DRAGONMAN;} //3101
				case APPEAR_TYPE_ELEMENTAL_MAGMA: { return APPEAR_TYPE_UNICORN;} //3102
				case APPEAR_TYPE_ELEMENTAL_ADAMANTIT: { return APPEAR_TYPE_ELEMENTAL_MAGMA;} //3103
				case APPEAR_TYPE_ELEMENTAL_ICE: { return APPEAR_TYPE_ELEMENTAL_ADAMANTIT;} //3104
				case APPEAR_TYPE_ELEMENTAL_SILVER: { return APPEAR_TYPE_ELEMENTAL_ICE;} //3105
				case APPEAR_TYPE_FRISCHLING: { return APPEAR_TYPE_ELEMENTAL_SILVER;} //3106
				case APPEAR_TYPE_TIGER_01: { return APPEAR_TYPE_FRISCHLING;} //3107
				case APPEAR_TYPE_DOG_GERMAN: { return APPEAR_TYPE_TIGER_01;} //3108
				case APPEAR_TYPE_FOURMI: { return APPEAR_TYPE_DOG_GERMAN;} //3109
			}
			break;
		case 68:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_EFREETI: { return APPEAR_TYPE_FOURMI;} //3400
			}
			break;
	}
	
	return -1;
}
*/

// used to reset a creatures appearance, note that this should also have a shortcut since subrace usually equals appearance
// int GetSubRace(object oTarget); should be passed into this function.
// but the previous appearance might be stored as an integer as well.


/*

int	   RACIAL_SUBTYPE_GOLD_DWARF		= 0;
int	   RACIAL_SUBTYPE_GRAY_DWARF		= 1;
int	   RACIAL_SUBTYPE_SHIELD_DWARF		= 2;
int	   RACIAL_SUBTYPE_DROW				= 3;
int	   RACIAL_SUBTYPE_MOON_ELF			= 4;
int	   RACIAL_SUBTYPE_SUN_ELF			= 5;
int	   RACIAL_SUBTYPE_WILD_ELF			= 6;
int	   RACIAL_SUBTYPE_WOOD_ELF			= 7;
int	   RACIAL_SUBTYPE_SVIRFNEBLIN		= 8;
int	   RACIAL_SUBTYPE_ROCK_GNOME		= 9;
int	   RACIAL_SUBTYPE_GHOSTWISE_HALF	= 10;
int	   RACIAL_SUBTYPE_LIGHTFOOT_HALF	= 11;
int	   RACIAL_SUBTYPE_STRONGHEART_HALF	= 12;
int	   RACIAL_SUBTYPE_AASIMAR			= 13;
int	   RACIAL_SUBTYPE_TIEFLING			= 14;
int	   RACIAL_SUBTYPE_HALFELF			= 15;
int    RACIAL_SUBTYPE_HALFORC			= 16;
int	   RACIAL_SUBTYPE_HUMAN				= 17;
int    RACIAL_SUBTYPE_AIR_GENASI		= 18;
int    RACIAL_SUBTYPE_EARTH_GENASI		= 19;
int    RACIAL_SUBTYPE_FIRE_GENASI		= 20;
int    RACIAL_SUBTYPE_WATER_GENASI		= 21;
int    RACIAL_SUBTYPE_ABERRATION		= 22;
int    RACIAL_SUBTYPE_ANIMAL			= 23;
int    RACIAL_SUBTYPE_BEAST				= 24;
int    RACIAL_SUBTYPE_CONSTRUCT			= 25;
int    RACIAL_SUBTYPE_HUMANOID_GOBLINOID	= 26;
int    RACIAL_SUBTYPE_HUMANOID_MONSTROUS	= 27;
int    RACIAL_SUBTYPE_HUMANOID_ORC			= 28;
int    RACIAL_SUBTYPE_HUMANOID_REPTILIAN	= 29;
int    RACIAL_SUBTYPE_ELEMENTAL			= 30;
int    RACIAL_SUBTYPE_FEY				= 31;
int    RACIAL_SUBTYPE_GIANT				= 32;
int    RACIAL_SUBTYPE_OUTSIDER			= 33;
int    RACIAL_SUBTYPE_SHAPECHANGER		= 34;
int    RACIAL_SUBTYPE_UNDEAD			= 35;
int    RACIAL_SUBTYPE_VERMIN			= 36;
int    RACIAL_SUBTYPE_OOZE				= 37;
int    RACIAL_SUBTYPE_DRAGON			= 38;
int    RACIAL_SUBTYPE_MAGICAL_BEAST		= 39;
int    RACIAL_SUBTYPE_INCORPOREAL		= 40;
int    RACIAL_SUBTYPE_GITHYANKI			= 41;
int    RACIAL_SUBTYPE_GITHZERAI			= 42;
int	   RACIAL_SUBTYPE_HALFDROW			= 43;
int	   RACIAL_SUBTYPE_PLANT				= 44;
int	   RACIAL_SUBTYPE_HAGSPAWN			= 45;
int	   RACIAL_SUBTYPE_HALFCELESTIAL		= 46;
int	   RACIAL_SUBTYPE_YUANTI			= 47;
int	   RACIAL_SUBTYPE_GRAYORC			= 48;





*/








/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAppearanceBySubrace( int iSubRace )
{
	
		switch(iSubRace)
		{
			case RACIAL_SUBTYPE_GOLD_DWARF: //0 
				return APPEAR_TYPE_DWARF_GOLD;
			case RACIAL_SUBTYPE_GRAY_DWARF: //1 
				return APPEAR_TYPE_DWARF_DUERGAR;
			case RACIAL_SUBTYPE_SHIELD_DWARF: //2 
				return APPEAR_TYPE_DWARF;
			case RACIAL_SUBTYPE_DROW: //3 
				return APPEAR_TYPE_ELF_DROW;
			case RACIAL_SUBTYPE_MOON_ELF: //4 
				return APPEAR_TYPE_ELF;
			case RACIAL_SUBTYPE_SUN_ELF: //5 
				return APPEAR_TYPE_ELF_SUN;
			case RACIAL_SUBTYPE_WILD_ELF: //6 
				return APPEAR_TYPE_ELF_WILD;
			case RACIAL_SUBTYPE_WOOD_ELF: //7 
				return APPEAR_TYPE_ELF_WOOD;
			case RACIAL_SUBTYPE_SVIRFNEBLIN: //8 
				return APPEAR_TYPE_GNOME_SVIRFNEBLIN;
			case RACIAL_SUBTYPE_ROCK_GNOME: //9 
				return APPEAR_TYPE_GNOME;
			case RACIAL_SUBTYPE_GHOSTWISE_HALF: //10 
				return APPEAR_TYPE_HALFLING_STRONGHEART;
			case RACIAL_SUBTYPE_LIGHTFOOT_HALF: //11 
				return APPEAR_TYPE_HALFLING;
			case RACIAL_SUBTYPE_STRONGHEART_HALF: //12 
				return APPEAR_TYPE_HALFLING_STRONGHEART;
			case RACIAL_SUBTYPE_AASIMAR: //13 
				return APPEAR_TYPE_ASSIMAR;
			case RACIAL_SUBTYPE_TIEFLING: //14 
				return APPEAR_TYPE_TIEFLING;
			case RACIAL_SUBTYPE_HALFELF: //15 
				return APPEAR_TYPE_HALF_ELF;
			case RACIAL_SUBTYPE_HALFORC: //16 
				return APPEAR_TYPE_HALF_ORC;
			case RACIAL_SUBTYPE_HUMAN: //17 
				return APPEAR_TYPE_HUMAN;
			case RACIAL_SUBTYPE_AIR_GENASI: //18 
				return APPEAR_TYPE_AIR_GENASI;
			case RACIAL_SUBTYPE_EARTH_GENASI: //19 
				return APPEAR_TYPE_EARTH_GENASI;
			case RACIAL_SUBTYPE_FIRE_GENASI: //20 
				return APPEAR_TYPE_FIRE_GENASI;
			case RACIAL_SUBTYPE_WATER_GENASI: //21; 
				return APPEAR_TYPE_WATER_GENASI;
			//case RACIAL_SUBTYPE_ABERRATION: //22;
			//case RACIAL_SUBTYPE_ANIMAL: //23;
			//case RACIAL_SUBTYPE_BEAST: //24;
			//case RACIAL_SUBTYPE_CONSTRUCT: //25;
			//case RACIAL_SUBTYPE_HUMANOID_GOBLINOID: //26;
			//case RACIAL_SUBTYPE_HUMANOID_MONSTROUS: //27;
			//case RACIAL_SUBTYPE_HUMANOID_ORC: //28;
			//case RACIAL_SUBTYPE_HUMANOID_REPTILIAN: //29;
			//case RACIAL_SUBTYPE_ELEMENTAL: //30;
			//case RACIAL_SUBTYPE_FEY: //31;
			//case RACIAL_SUBTYPE_GIANT: //32;
			//case RACIAL_SUBTYPE_OUTSIDER: //33;
			//case RACIAL_SUBTYPE_SHAPECHANGER: //34;
			//case RACIAL_SUBTYPE_UNDEAD: //35;
			//case RACIAL_SUBTYPE_VERMIN: //36;
			//case RACIAL_SUBTYPE_OOZE: //37;
			//case RACIAL_SUBTYPE_DRAGON: //38;
			//case RACIAL_SUBTYPE_MAGICAL_BEAST: //39;
			//case RACIAL_SUBTYPE_INCORPOREAL: //40;
			case RACIAL_SUBTYPE_GITHYANKI: //41 
				return APPEAR_TYPE_GITHYANKI;
			case RACIAL_SUBTYPE_GITHZERAI: //42 
				return APPEAR_TYPE_GITHYANKI;
			case RACIAL_SUBTYPE_HALFDROW: //43 
				return APPEAR_TYPE_HALF_DROW;
			//case RACIAL_SUBTYPE_PLANT: //44; 
			case RACIAL_SUBTYPE_HAGSPAWN: //45 
				return APPEAR_TYPE_HAGSPAWN_VAR1;
			case RACIAL_SUBTYPE_HALFCELESTIAL: //46 
				return APPEAR_TYPE_HALF_CELESTIAL_ROF;
			case RACIAL_SUBTYPE_YUANTI: //47 
				return APPEAR_TYPE_YUANTIPUREBLOOD;
			case RACIAL_SUBTYPE_GRAYORC: //48 
				return APPEAR_TYPE_GRAYORC;
			case RACIAL_SUBTYPE_ELF_STAR: //67 
				return APPEAR_TYPE_ELF;
			case RACIAL_SUBTYPE_MOUNTAIN_ORC_ROF: //150 
				return APPEAR_TYPE_ORC_A;
			case RACIAL_SUBTYPE_OROG_ROF: //151 
				return APPEAR_TYPE_OROG_ROF;
			case RACIAL_SUBTYPE_OGRILLON_ROF: //152 
				return APPEAR_TYPE_OGRILLON_ROF;
			case RACIAL_SUBTYPE_BOOGIN_ROF: //153 
				return APPEAR_TYPE_ORC_A;
			case RACIAL_SUBTYPE_ODONTI_ROF: //154 
				return APPEAR_TYPE_GRAYORC;
			case RACIAL_SUBTYPE_GOBLIN_ROF: //155 
				return APPEAR_TYPE_GOBLIN;
			case RACIAL_SUBTYPE_HOBGOBLIN_ROF: //156 
				return APPEAR_TYPE_HOBGOBLIN_ROF;
			case RACIAL_SUBTYPE_BUGBEAR_ROF: //157 
				return APPEAR_TYPE_BUGBEAR;
			case RACIAL_SUBTYPE_ARCTIC_DWARF_ROF: //158 
				return APPEAR_TYPE_ARCTIC_DWARF_ROF;
			case RACIAL_SUBTYPE_WILD_DWARF_ROF: //159 
				return APPEAR_TYPE_WILD_DWARF_ROF;
			case RACIAL_SUBTYPE_FOREST_GNOME_ROF: //160 
				return APPEAR_TYPE_FOREST_GNOME_ROF;
			case RACIAL_SUBTYPE_HUMAN_DEEP_IMASKARI_ROF: //161 
				return APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF;
			case RACIAL_SUBTYPE_FEYRI_ROF: //162 
				return APPEAR_TYPE_FEYRI_ROF;
			case RACIAL_SUBTYPE_TANARUKK_ROF: //163 
				return APPEAR_TYPE_TANARUKK_ROF;
			case RACIAL_SUBTYPE_SPRIGGAN_ROF: //164 
				return APPEAR_TYPE_ELEMENTAL_FIRE_HUGE;
			case RACIAL_SUBTYPE_WOOD_GENASI_ROF: //165 
				return APPEAR_TYPE_WOOD_GENASI_ROF;
			case RACIAL_SUBTYPE_BATIRI_ROF: //166 
				return APPEAR_TYPE_BATIRI;
			case RACIAL_SUBTYPE_GNOLL_ROF: //167 
				return APPEAR_TYPE_GNOLL;
			case RACIAL_SUBTYPE_KOBOLD_ROF: //168 
				return APPEAR_TYPE_KOBOLD;
			case RACIAL_SUBTYPE_AZERBLOOD_ROF: //169 
				return APPEAR_TYPE_AZERBLOOD_ROF;
			case RACIAL_SUBTYPE_WECHSELBALG_ROF: //170 
				return APPEAR_TYPE_HALF_ELF;
			case RACIAL_SUBTYPE_MORTIF_ROF: //171 
				return APPEAR_TYPE_HUMAN;
			case RACIAL_SUBTYPE_FROSTBLOT_ROF: //172 
				return APPEAR_TYPE_FROSTBLOT_ROF;
			case RACIAL_SUBTYPE_ELDBLOT_ROF: //173 
				return APPEAR_TYPE_ELDBLOT_ROF;
			case RACIAL_SUBTYPE_VARCOLACI_ROF: //174 
				return APPEAR_TYPE_GOBLIN;
			case RACIAL_SUBTYPE_KOROBOKURU_ROF: //175 
				return APPEAR_TYPE_WILD_DWARF_ROF;
			case RACIAL_SUBTYPE_POSCADAR_ROF: //176 
				return APPEAR_TYPE_ELF_POSCADAR_ROF;
			case RACIAL_SUBTYPE_JANNLING_ROF: //177 
				return APPEAR_TYPE_ASSIMAR;
			case RACIAL_SUBTYPE_YUANTI_HALFBLOOD_ROF: //178 
				return APPEAR_TYPE_YUANTI_HALFBLOOD_ROF;
			case RACIAL_SUBTYPE_EXTAMINAAR_ROF: //179 
				return APPEAR_TYPE_YUANTIPUREBLOOD;
			case RACIAL_SUBTYPE_OGRE_ROF: //180 
				return APPEAR_TYPE_OGRE_ROF;
			case RACIAL_SUBTYPE_FIRENEWT_ROF: //181 
				return APPEAR_TYPE_FIRE_NEWT;
			case RACIAL_SUBTYPE_ASABI_ROF: //182 
				return APPEAR_TYPE_ASABI_ROF;
			case RACIAL_SUBTYPE_LIZARDFOLK_ROF: //183 
				return APPEAR_TYPE_LIZARDFOLD_ROF;
			case RACIAL_SUBTYPE_SANDSTORM_HALFLING_ROF: //184 
				return APPEAR_TYPE_HALFLING_SANDSTORM_ROF;
			case RACIAL_SUBTYPE_DUNE_ELF_ROF: //185 
				return APPEAR_TYPE_ELF_DUNE_ROF;
			case RACIAL_SUBTYPE_SEWER_GOBLIN_ROF: //186 
				return APPEAR_TYPE_SEWER_GOBLIN_ROF;
			case RACIAL_SUBTYPE_BROWNIE_ROF: //187 
				return APPEAR_TYPE_BROWNIE_ROF;
			case RACIAL_SUBTYPE_ULDRA_ROF: //188 
				return APPEAR_TYPE_ULDRA_ROF;
			case RACIAL_SUBTYPE_DRAGONKIN_ROF: //189 
				return APPEAR_TYPE_DRAGONKIN_ROF;
			case RACIAL_SUBTYPE_BLADELING_ROF: //190 
				return APPEAR_TYPE_BLADELING;
			case RACIAL_SUBTYPE_DURZAGON_ROF: //191 
				return APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF;
			case RACIAL_SUBTYPE_CHAOND_ROF: //192 
				return APPEAR_TYPE_CHAOND_ROF;
			case RACIAL_SUBTYPE_ZENYTHRI_ROF: //193 
				return APPEAR_TYPE_HUMAN;
			case RACIAL_SUBTYPE_TAINTED_ONE_ROF: //194 
				return APPEAR_TYPE_HUMAN;
			case RACIAL_SUBTYPE_GLOAMING_ROF: //195 
				return APPEAR_TYPE_GLOAMING_ROF;
			case RACIAL_SUBTYPE_FIRBOLG_ROF: //196 
				return APPEAR_TYPE_FIRBOLG_ROF;
			case RACIAL_SUBTYPE_FOMORIAN_ROF: //197 
				return APPEAR_TYPE_OGRE_ROF;
			case RACIAL_SUBTYPE_VERBEEG_ROF: //198 
				return APPEAR_TYPE_VERBEEG_ROF;
			case RACIAL_SUBTYPE_VOADKYN_ROF: //199 
				return APPEAR_TYPE_VOADKYN_ROF;
			case RACIAL_SUBTYPE_FJELLBLOT_ROF: //200 
				return APPEAR_TYPE_FJELLBLOT_ROF;
			case RACIAL_SUBTYPE_TAKEBLOT_ROF: //201 
				return APPEAR_TYPE_TAKEBLOT_ROF;
			case RACIAL_SUBTYPE_AIR_MEPHLING_ROF: //202 
				return APPEAR_TYPE_AIR_MEPHLING_ROF;
			case RACIAL_SUBTYPE_EARTH_MEPHLING_ROF: //203 
				return APPEAR_TYPE_EARTH_MEPHLING_ROF;
			case RACIAL_SUBTYPE_FIRE_MEPHLING_ROF: //204 
				return APPEAR_TYPE_FIRE_MEPHLING_ROF;
			case RACIAL_SUBTYPE_WATER_MEPHLING_ROF: //205 
				return APPEAR_TYPE_WATER_MEPHLING_ROF;
			case RACIAL_SUBTYPE_ICE_SPIRE_OGRE_ROF: //206 
				return APPEAR_TYPE_ICE_SPIRE_OGRE_ROF;
			case RACIAL_SUBTYPE_SIND_ROF: //207 
				return APPEAR_TYPE_GITHYANKI;
			case RACIAL_SUBTYPE_LIZARDKING_ROF: //208 
				return APPEAR_TYPE_LIZARDFOLD_ROF;
			case RACIAL_SUBTYPE_KHAASTA_ROF: //209 
				return APPEAR_TYPE_KHAASTA_ROF;
			case RACIAL_SUBTYPE_TAER_ROF: //210 
				return APPEAR_TYPE_UTHRAKI;
			case RACIAL_SUBTYPE_ALU_FIEND_ROF: //211 
				return APPEAR_TYPE_SUCCUBUS;
			case RACIAL_SUBTYPE_CAMBION_ROF: //212 
				return APPEAR_TYPE_YUANTIPUREBLOOD;
			case RACIAL_SUBTYPE_KRINTH_ROF: //213 
				return APPEAR_TYPE_KRINTH_ROF;
			case RACIAL_SUBTYPE_AELFBORN_ROF: //214 
				return APPEAR_TYPE_AELFBORN_ROF;
			//case RACIAL_SUBTYPE_VOLODNI_ROF: //215 
			case RACIAL_SUBTYPE_DERRO_ROF: //216 
				return APPEAR_TYPE_DERRO_ROF;
			case RACIAL_SUBTYPE_UNDA_ROF: //217 
				return APPEAR_TYPE_WATER_GENASI;
			case RACIAL_SUBTYPE_WORG_ROF: //218 
				return APPEAR_TYPE_WORG;
			case RACIAL_SUBTYPE_HALF_OGRE_ROF: //219 
				return APPEAR_TYPE_HALF_OGRE_ROF;
			case RACIAL_SUBTYPE_DRAGONBORN_ROF: //220 
				return APPEAR_TYPE_DRAGONBORN_ROF;
			case RACIAL_SUBTYPE_SPELLSCALE_ROF: //221 
				return APPEAR_TYPE_YUANTIPUREBLOOD;
			case RACIAL_SUBTYPE_URD_ROF: //222 
				return APPEAR_TYPE_URD_ROF;
			case RACIAL_SUBTYPE_CELADRIN_ROF: //223 
				return APPEAR_TYPE_CELADRIN_ROF;
			case RACIAL_SUBTYPE_DRIDER: //224 
				return APPEAR_TYPE_DRIDER;
			case RACIAL_SUBTYPE_SYLPH_ROF: //226 
				return APPEAR_TYPE_SYLPH_ROF;
			case RACIAL_SUBTYPE_FLAMEBROTHER_ROF: //227 
				return APPEAR_TYPE_FLAMEBROTHER_ROF;

	}
	return -1;

}






/**  
* @author
* @param 
* @see 
* @return 
*/
// @deprecated
// * This Gets an index for a given appearance constant
// * used for iterating all the constants, or getting a random constant
// * tie into next and previous perhaps
/*
int CSLGetIndexByAppearance( int iAppearanceType )
{
	//int iAppearanceType = GetAppearanceType(oTarget);
	if ( iAppearanceType == -1 ) { return -1; }
	
	iAppearanceType = CSLGetBaseAppearance( iAppearanceType );
	
	//int iAppearanceType = GetAppearanceType(oTarget);
	//if ( iAppearanceType == -1 ) { return 0.0f; }
	
	int iSubAppearance = iAppearanceType / 50;
	switch(iSubAppearance)
	{
		case 0:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DWARF: { return 0;} //0
				case APPEAR_TYPE_ELF: { return 1;} //1
				case APPEAR_TYPE_GNOME: { return 2;} //2
				case APPEAR_TYPE_HALFLING: { return 3;} //3
				case APPEAR_TYPE_HALF_ELF: { return 4;} //4
				case APPEAR_TYPE_HALF_ORC: { return 5;} //5
				case APPEAR_TYPE_HUMAN: { return 6;} //6
				case APPEAR_TYPE_HORSE_BROWN: { return 7;} //7
				case APPEAR_TYPE_BADGER: { return 8;} //8
				case APPEAR_TYPE_BADGER_DIRE: { return 9;} //9
				case APPEAR_TYPE_BAT: { return 10;} //10
				case APPEAR_TYPE_HORSE_PINTO: { return 11;} //11
				case APPEAR_TYPE_HORSE_SKELETAL: { return 12;} //12
				case APPEAR_TYPE_BEAR_BROWN: { return 13;} //13
				case APPEAR_TYPE_HORSE_PALOMINO: { return 14;} //14
				case APPEAR_TYPE_BEAR_DIRE: { return 15;} //15
				case APPEAR_TYPE_DRAGON__BRONZE: { return 16;} //16
				case APPEAR_TYPE_YOUNG_BRONZE: { return 17;} //17
				case APPEAR_TYPE_BEETLE_FIRE: { return 18;} //18
				case APPEAR_TYPE_BEETLE_STAG: { return 19;} //19
				case APPEAR_TYPE_YOUNG_BLUE: { return 20;} //20
				case APPEAR_TYPE_BOAR: { return 21;} //21
				case APPEAR_TYPE_BOAR_DIRE: { return 22;} //22
				case APPEAR_TYPE_YUANTI_ABOMINATION: { return 23;} //23
				case APPEAR_TYPE_WORG: { return 24;} //24
				case APPEAR_TYPE_YUANTI_HOLYGUARDIAN: { return 25;} //25
				case APPEAR_TYPE_PLANETAR: { return 26;} //26
				case APPEAR_TYPE_WILLOWISP: { return 27;} //27
				case APPEAR_TYPE_FIRE_NEWT: { return 28;} //28
				case APPEAR_TYPE_DROWNED: { return 29;} //29
				case APPEAR_TYPE_MEGARAPTOR: { return 30;} //30
				case APPEAR_TYPE_CHICKEN: { return 31;} //31
				case APPEAR_TYPE_WIGHT: { return 32;} //32
				case APPEAR_TYPE_CLOCKROACH: { return 33;} //33
				case APPEAR_TYPE_COW: { return 34;} //34
				case APPEAR_TYPE_DEER: { return 35;} //35
				case APPEAR_TYPE_DEINONYCHUS: { return 36;} //36
				case APPEAR_TYPE_DEER_STAG: { return 37;} //37
				case APPEAR_TYPE_BATIRI: { return 38;} //38
				case APPEAR_TYPE_LICH: { return 39;} //39
				case APPEAR_TYPE_YUANTIPUREBLOOD: { return 40;} //40
				case APPEAR_TYPE_DRAGON_BLACK: { return 41;} //41
				case APPEAR_TYPE_WAGON_LIGHT01: { return 42;} //42
				case APPEAR_TYPE_WAGON_LIGHT02: { return 43;} //43
				case APPEAR_TYPE_WAGON_LIGHT03: { return 44;} //44
				case APPEAR_TYPE_GRAYORC: { return 45;} //45
				case APPEAR_TYPE_YUANTI_HERALD: { return 46;} //46
				case APPEAR_TYPE_NPC_SASANI: { return 47;} //47
				case APPEAR_TYPE_NPC_VOLO: { return 48;} //48
				case APPEAR_TYPE_DRAGON_RED: { return 49;} //49

			}
			break;
		case 1:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_SEPTIMUND: { return 50;} //50
				case APPEAR_TYPE_DRYAD: { return 51;} //51
				case APPEAR_TYPE_ELEMENTAL_AIR: { return 52;} //52
				case APPEAR_TYPE_ELEMENTAL_AIR_ELDER: { return 53;} //53
				case APPEAR_TYPE_ELEMENTAL_EARTH: { return 54;} //56
				case APPEAR_TYPE_ELEMENTAL_EARTH_ELDER: { return 55;} //57
				case APPEAR_TYPE_MUMMY_COMMON: { return 56;} //58
				case APPEAR_TYPE_ELEMENTAL_FIRE: { return 57;} //60
				case APPEAR_TYPE_ELEMENTAL_FIRE_ELDER: { return 58;} //61
				case APPEAR_TYPE_ELEMENTAL_WATER_ELDER: { return 59;} //68
				case APPEAR_TYPE_ELEMENTAL_WATER: { return 60;} //69
				case APPEAR_TYPE_GARGOYLE: { return 61;} //73
				case APPEAR_TYPE_GHAST: { return 62;} //74
				case APPEAR_TYPE_GHOUL: { return 63;} //76
				case APPEAR_TYPE_GIANT_FIRE: { return 64;} //80
				case APPEAR_TYPE_GIANT_FROST: { return 65;} //81
				case APPEAR_TYPE_GOLEM_IRON: { return 66;} //89
			}
			break;
		case 2:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VROCK: { return 67;} //105
				case APPEAR_TYPE_IMP: { return 68;} //105
				case APPEAR_TYPE_MEPHIT_FIRE: { return 69;} //109
				case APPEAR_TYPE_MEPHIT_ICE: { return 70;} //110
				case APPEAR_TYPE_OGRE: { return 71;} //127
				case APPEAR_TYPE_OGRE_MAGE: { return 72;} //129
				case APPEAR_TYPE_ORC_A: { return 73;} //140
			}
			break;
		case 3:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SLAAD_BLUE: { return 74;} //151
				case APPEAR_TYPE_SLAAD_GREEN: { return 75;} //154
				case APPEAR_TYPE_SPECTRE: { return 76;} //156
				case APPEAR_TYPE_SPIDER_DIRE: { return 77;} //158
				case APPEAR_TYPE_SPIDER_GIANT: { return 78;} //159
				case APPEAR_TYPE_SPIDER_PHASE: { return 79;} //160
				case APPEAR_TYPE_SPIDER_BLADE: { return 80;} //161
				case APPEAR_TYPE_SPIDER_WRAITH: { return 81;} //162
				case APPEAR_TYPE_SUCCUBUS: { return 82;} //163
				case APPEAR_TYPE_TROLL: { return 83;} //167
				case APPEAR_TYPE_UMBERHULK: { return 84;} //168
				case APPEAR_TYPE_WEREWOLF: { return 85;} //171
				case APPEAR_TYPE_DOG_DIRE_WOLF: { return 86;} //175
				case APPEAR_TYPE_DOG_HELL_HOUND: { return 87;} //179
				case APPEAR_TYPE_DOG_SHADOW_MASTIF: { return 88;} //180
				case APPEAR_TYPE_DOG_WOLF: { return 89;} //181
				case APPEAR_TYPE_DOG_WINTER_WOLF: { return 90;} //184
				case APPEAR_TYPE_DREAD_WRAITH: { return 91;} //186
				case APPEAR_TYPE_WRAITH: { return 92;} //187
				case APPEAR_TYPE_ZOMBIE: { return 93;} //198

			}
			break;
		case 5:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_VAMPIRE_FEMALE: { return 94;} //288
				case APPEAR_TYPE_VAMPIRE_MALE: { return 95;} //289
				
			}
			break;
		case 7:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RAT: { return 96;} //386
				case APPEAR_TYPE_RAT_DIRE: { return 97;} //387
				
			}
			break;
		case 8:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_MINDFLAYER: { return 98;} //413
			}
			break;
		case 9:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DEVIL_HORNED: { return 99;} //481
				case APPEAR_TYPE_SPIDER_BONE: { return 100;} //482
				case APPEAR_TYPE_GITHYANKI: { return 101;} //483
				case APPEAR_TYPE_BIRD: { return 102;} //485
				case APPEAR_TYPE_BLADELING: { return 103;} //486
				case APPEAR_TYPE_CAT: { return 104;} //487
				case APPEAR_TYPE_DEMON_HEZROU: { return 105;} //488
				case APPEAR_TYPE_DEVIL_PITFIEND: { return 106;} //489
				case APPEAR_TYPE_GOLEM_BLADE: { return 107;} //493
				case APPEAR_TYPE_SHADOW: { return 108;} //496
				case APPEAR_TYPE_NIGHTSHADE_NIGHTWALKER: { return 109;} //497
				case APPEAR_TYPE_PIG: { return 110;} //498
				case APPEAR_TYPE_RABBIT: { return 111;} //499

			}
			break;
		case 10:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_SHADOW_REAVER: { return 112;} //500
				case APPEAR_TYPE_WEASEL: { return 113;} //503
				case APPEAR_TYPE_SYLPH: { return 114;} //512
				case APPEAR_TYPE_DEVIL_ERINYES: { return 115;} //514
				case APPEAR_TYPE_PIXIE: { return 116;} //521
				case APPEAR_TYPE_DEMON_BALOR: { return 117;} //522
				case APPEAR_TYPE_GNOLL: { return 118;} //533
				case APPEAR_TYPE_GOBLIN: { return 119;} //534
				case APPEAR_TYPE_KOBOLD: { return 120;} //535
				case APPEAR_TYPE_LIZARDFOLK: { return 121;} //536
				case APPEAR_TYPE_SKELETON: { return 122;} //537
				case APPEAR_TYPE_BEETLE_BOMBARDIER: { return 123;} //538
				case APPEAR_TYPE_BUGBEAR: { return 124;} //543
				case APPEAR_TYPE_NPC_GARIUS: { return 125;} //544
				case APPEAR_TYPE_SPIDER_GLOW: { return 126;} //546
				case APPEAR_TYPE_SPIDER_KRISTAL: { return 127;} //547
				case APPEAR_TYPE_NPC_DUNCAN: { return 128;} //549

			}
			break;
		case 11:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_LORDNASHER: { return 129;} //550
				case APPEAR_TYPE_NPC_CHILDHHM: { return 130;} //551
				case APPEAR_TYPE_NPC_CHILDHHF: { return 131;} //553
				case APPEAR_TYPE_ELEMENTAL_AIR_HUGE: { return 132;} //554
				case APPEAR_TYPE_ELEMENTAL_AIR_GREATER: { return 133;} //555
				case APPEAR_TYPE_ELEMENTAL_EARTH_HUGE: { return 134;} //556
				case APPEAR_TYPE_ELEMENTAL_EARTH_GREATER: { return 135;} //557
				case APPEAR_TYPE_ELEMENTAL_FIRE_HUGE: { return 136;} //558
				case APPEAR_TYPE_ELEMENTAL_FIRE_GREATER: { return 137;} //559
				case APPEAR_TYPE_ELEMENTAL_WATER_HUGE: { return 138;} //560
				case APPEAR_TYPE_ELEMENTAL_WATER_GREATER: { return 139;} //561
				case APPEAR_TYPE_SIEGETOWER: { return 140;} //562
				case APPEAR_TYPE_ASSIMAR: { return 141;} //563
				case APPEAR_TYPE_TIEFLING: { return 142;} //564
				case APPEAR_TYPE_ELF_SUN: { return 143;} //565
				case APPEAR_TYPE_ELF_WOOD: { return 144;} //566
				case APPEAR_TYPE_ELF_DROW: { return 145;} //567
				case APPEAR_TYPE_GNOME_SVIRFNEBLIN: { return 146;} //568
				case APPEAR_TYPE_DWARF_GOLD: { return 147;} //569
				case APPEAR_TYPE_DWARF_DUERGAR: { return 148;} //570
				case APPEAR_TYPE_HALFLING_STRONGHEART: { return 149;} //571
				case APPEAR_TYPE_CARGOSHIP: { return 150;} //572
				case APPEAR_TYPE_N_HUMAN: { return 151;} //573
				case APPEAR_TYPE_N_ELF: { return 152;} //574
				case APPEAR_TYPE_N_DWARF: { return 153;} //575
				case APPEAR_TYPE_N_HALF_ELF: { return 154;} //576
				case APPEAR_TYPE_N_GNOME: { return 155;} //577
				case APPEAR_TYPE_N_TIEFLING: { return 156;} //578
				case APPEAR_TYPE_NPC_GITHCAPTAIN: { return 157;} //579
				case APPEAR_TYPE_NPC_LORNE: { return 158;} //580
				case APPEAR_TYPE_NPC_TENAVROK: { return 159;} //581
				case APPEAR_TYPE_NPC_CTANN: { return 160;} //582
				case APPEAR_TYPE_NPC_SHANDRA: { return 161;} //583
				case APPEAR_TYPE_NPC_ZEEAIRE: { return 162;} //584
				case APPEAR_TYPE_NPC_ZEEAIRES_LIEUTENANT: { return 163;} //585
				case APPEAR_TYPE_NPC_KINGOFSHADOWS: { return 164;} //586
				case APPEAR_TYPE_NPC_NOLALOTH: { return 165;} //587
				case APPEAR_TYPE_NPC_ZHJAEVE: { return 166;} //588
				case APPEAR_TYPE_NPC_ZAXIS: { return 167;} //589
				case APPEAR_TYPE_NPC_AHJA: { return 168;} //590
				case APPEAR_TYPE_NPC_DURLER: { return 169;} //591
				case APPEAR_TYPE_NPC_HEZEBEL: { return 170;} //592
				case APPEAR_TYPE_NPC_HOSTTOWER: { return 171;} //593
				case APPEAR_TYPE_NPC_ZOKAN: { return 172;} //594
				case APPEAR_TYPE_NPC_ALDANON: { return 173;} //595
				case APPEAR_TYPE_NPC_JACOBY: { return 174;} //596
				case APPEAR_TYPE_NPC_JALBOUN: { return 175;} //597
				case APPEAR_TYPE_NPC_KHRALVER: { return 176;} //598
				case APPEAR_TYPE_NPC_KRALWOK: { return 177;} //599

			}
			break;
		case 12:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_NPC_MEPHASM: { return 178;} //600
				case APPEAR_TYPE_NPC_MORKAI: { return 179;} //601
				case APPEAR_TYPE_NPC_SARYA: { return 180;} //602
				case APPEAR_TYPE_NPC_SYDNEY: { return 181;} //603
				case APPEAR_TYPE_NPC_TORIOCLAVEN: { return 182;} //604
				case APPEAR_TYPE_NPC_UTHANCK: { return 183;} //605
				case APPEAR_TYPE_NPC_SHADOWPRIEST: { return 184;} //606
				case APPEAR_TYPE_NPC_HUNTERSTATUE: { return 185;} //607
				case APPEAR_TYPE_SIEGETOWERB: { return 186;} //608
				case APPEAR_TYPE_PUSHBLOCK: { return 187;} //609
				case APPEAR_TYPE_SMUGGLERWAGON: { return 188;} //610
				case APPEAR_TYPE_INVISIBLEMAN: { return 189;} //611
			}
			break;
		case 20:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AKACHI: { return 190;} //1000
				case APPEAR_TYPE_OKKU_BEAR: { return 191;} //1001
				case APPEAR_TYPE_PANTHER: { return 192;} //1002
				case APPEAR_TYPE_WOLVERINE: { return 193;} //1003
				case APPEAR_TYPE_INVISIBLE_STALKER: { return 194;} //1004
				case APPEAR_TYPE_HOMUNCULUS: { return 195;} //1005
				case APPEAR_TYPE_GOLEM_IMASKARI: { return 196;} //1006
				case APPEAR_TYPE_RED_WIZ_COMPANION: { return 197;} //1007
				case APPEAR_TYPE_DEATH_KNIGHT: { return 198;} //1008
				case APPEAR_TYPE_BARROW_GUARDIAN: { return 199;} //1009
				case APPEAR_TYPE_SEA_MONSTER: { return 200;} //1010
				case APPEAR_TYPE_ONE_OF_MANY: { return 201;} //1011
				case APPEAR_TYPE_SHAMBLING_MOUND: { return 202;} //1012
				case APPEAR_TYPE_SOLAR: { return 203;} //1013
				case APPEAR_TYPE_WOLVERINE_DIRE: { return 204;} //1014
				case APPEAR_TYPE_DRAGON_BLUE: { return 205;} //1015
				case APPEAR_TYPE_DJINN: { return 206;} //1016
				case APPEAR_TYPE_GNOLL_THAYAN: { return 207;} //1017
				case APPEAR_TYPE_GOLEM_CLAY: { return 208;} //1018
				case APPEAR_TYPE_GOLEM_FAITHLESS: { return 209;} //1019
				case APPEAR_TYPE_DEMILICH: { return 210;} //1020
				case APPEAR_TYPE_HAG_ANNIS: { return 211;} //1021
				case APPEAR_TYPE_HAG_GREEN: { return 212;} //1022
				case APPEAR_TYPE_HAG_NIGHT: { return 213;} //1023
				case APPEAR_TYPE_HORSE_WHITE: { return 214;} //1024
				case APPEAR_TYPE_DEMILICH_SMALL: { return 215;} //1025
				case APPEAR_TYPE_LEOPARD_SNOW: { return 216;} //1026
				case APPEAR_TYPE_TREANT: { return 217;} //1027
				case APPEAR_TYPE_TROLL_FELL: { return 218;} //1028
				case APPEAR_TYPE_UTHRAKI: { return 219;} //1029
				case APPEAR_TYPE_WYVERN: { return 220;} //1030
				case APPEAR_TYPE_RAVENOUS_INCARNATION: { return 221;} //1031
				case APPEAR_TYPE_N_ELF_WILD: { return 222;} //1032
				case APPEAR_TYPE_N_HALF_DROW: { return 223;} //1033
				case APPEAR_TYPE_MAGDA: { return 224;} //1034
				case APPEAR_TYPE_NEFRIS: { return 225;} //1035
				case APPEAR_TYPE_ELF_WILD: { return 226;} //1036
				case APPEAR_TYPE_EARTH_GENASI: { return 227;} //1037
				case APPEAR_TYPE_FIRE_GENASI: { return 228;} //1038
				case APPEAR_TYPE_AIR_GENASI: { return 229;} //1039
				case APPEAR_TYPE_WATER_GENASI: { return 230;} //1040
				case APPEAR_TYPE_HALF_DROW: { return 231;} //1041
				case APPEAR_TYPE_DOG_WOLF_TELTHOR: { return 232;} //1042
				case APPEAR_TYPE_HAGSPAWN_VAR1: { return 233;} //1043
				
				
				case APPEAR_TYPE_DEVEIL_PAELIRYON: { return 234;} //1044
				case APPEAR_TYPE_WERERAT: { return 235;} //1045
				case APPEAR_TYPE_ORBAKH: { return 236;} //1046
				case APPEAR_TYPE_QUELZARN: { return 237;} //1047

			}
			break;
		case 24:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_BEHOLDER: { return 238;} //1201
				case APPEAR_TYPE_REE_YUANTIF: { return 239;} //1204
				case APPEAR_TYPE_DRIDER: { return 240;} //1206
				case APPEAR_TYPE_MINOTAUR: { return 241;} //1208
			}
			break;
		case 28:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_AZERBLOOD_ROF: { return 242;} //1400;
				case APPEAR_TYPE_FROSTBLOT_ROF: { return 243;} //1401;
				case APPEAR_TYPE_ELDBLOT_ROF: { return 244;} //1402;
				case APPEAR_TYPE_ARCTIC_DWARF_ROF: { return 245;} //1403;
				case APPEAR_TYPE_WILD_DWARF_ROF: { return 246;} //1404;
				case APPEAR_TYPE_TANARUKK_ROF: { return 247;} //1405;
				case APPEAR_TYPE_HOBGOBLIN_ROF: { return 248;} //1407;
				case APPEAR_TYPE_FOREST_GNOME_ROF: { return 249;} //1409;
				case APPEAR_TYPE_YUANTI_HALFBLOOD_ROF: { return 250;} //1410;
				case APPEAR_TYPE_ASABI_ROF: { return 251;} //1411;
				case APPEAR_TYPE_LIZARDFOLD_ROF: { return 252;} //1412;
				case APPEAR_TYPE_OGRE_ROF: { return 253;} //1413;
				case APPEAR_TYPE_PIXIE_ROF: { return 254;} //1414;
				case APPEAR_TYPE_DRAGONKIN_ROF: { return 255;} //1415;
				case APPEAR_TYPE_GLOAMING_ROF: { return 256;} //1416;
				case APPEAR_TYPE_CHAOND_ROF: { return 257;} //1417;
				case APPEAR_TYPE_ELF_DUNE_ROF: { return 258;} //1418;
				case APPEAR_TYPE_BROWNIE_ROF: { return 259;} //1419;
				case APPEAR_TYPE_ULDRA_ROF: { return 260;} //1420;
				case APPEAR_TYPE_HALF_FIEND_DURZAGON_ROF: { return 261;} //1421;
				case APPEAR_TYPE_ELF_POSCADAR_ROF: { return 262;} //1422;
				case APPEAR_TYPE_HUMAN_DEEP_IMASKARI_ROF: { return 263;} //1423;
				case APPEAR_TYPE_FIRBOLG_ROF: { return 264;} //1424;
				case APPEAR_TYPE_FOMORIAN_ROF: { return 265;} //1425;
				case APPEAR_TYPE_VERBEEG_ROF: { return 266;} //1426;
				case APPEAR_TYPE_VOADKYN_ROF: { return 267;} //1427;
				case APPEAR_TYPE_FJELLBLOT_ROF: { return 268;} //1428;
				case APPEAR_TYPE_TAKEBLOT_ROF: { return 269;} //1429;
				case APPEAR_TYPE_AIR_MEPHLING_ROF: { return 270;} //1430;
				case APPEAR_TYPE_EARTH_MEPHLING_ROF: { return 271;} //1431;
				case APPEAR_TYPE_FIRE_MEPHLING_ROF: { return 272;} //1432;
				case APPEAR_TYPE_WATER_MEPHLING_ROF: { return 273;} //1433;
				case APPEAR_TYPE_KHAASTA_ROF: { return 274;} //1434;
				case APPEAR_TYPE_MOUNTAIN_ORC_ROF: { return 275;} //1435;
				case APPEAR_TYPE_BOOGIN_ROF: { return 276;} //1436;
				case APPEAR_TYPE_ICE_SPIRE_OGRE_ROF: { return 277;} //1437;
				case APPEAR_TYPE_OGRILLON_ROF: { return 278;} //1438;
				case APPEAR_TYPE_KRINTH_ROF: { return 279;} //1439;
				case APPEAR_TYPE_HALFLING_SANDSTORM_ROF: { return 280;} //1440;
				case APPEAR_TYPE_DWARF_DEGLOSIAN_ROF: { return 281;} //1441;
				case APPEAR_TYPE_DWARF_GALDOSIAN_ROF: { return 282;} //1442;
				case APPEAR_TYPE_ELF_ROF: { return 283;} //1443;
				case APPEAR_TYPE_ELF_DRANGONARI_ROF: { return 284;} //1444;
				case APPEAR_TYPE_ELF_GHOST_ROF: { return 285;} //1445;
				case APPEAR_TYPE_FAERIE_ROF: { return 286;} //1446;
				case APPEAR_TYPE_GNOME_ROF: { return 287;} //1447;
				case APPEAR_TYPE_GOBLIN_ROF: { return 288;} //1448;
				case APPEAR_TYPE_HALF_ELF_ROF: { return 289;} //1449;

			}
			break;
		case 29:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_HALF_ORC_ROF: { return 290;} //1450;
				case APPEAR_TYPE_HALFLING_ROF: { return 291;} //1451
				case APPEAR_TYPE_HUMAN_ROF: { return 292;} //1452
				case APPEAR_TYPE_OROG_ROF: { return 293;} //1453
				case APPEAR_TYPE_AELFBORN_ROF: { return 294;} //1454
				case APPEAR_TYPE_FEYRI_ROF: { return 295;} //1455
				case APPEAR_TYPE_SEWER_GOBLIN_ROF: { return 296;} //1456
				case APPEAR_TYPE_WOOD_GENASI_ROF: { return 297;} //1457
				case APPEAR_TYPE_HALF_CELESTIAL_ROF: { return 298;} //1458
				case APPEAR_TYPE_DERRO_ROF: { return 299;} //1459
				case APPEAR_TYPE_HALF_OGRE_ROF: { return 300;} //1460
				case APPEAR_TYPE_DRAGONBORN_ROF: { return 301;} //1461
				case APPEAR_TYPE_URD_ROF: { return 302;} //1462
				case APPEAR_TYPE_CELADRIN_ROF: { return 303;} //1463
				case APPEAR_TYPE_SYLPH_ROF: { return 304;} //1464
				case APPEAR_TYPE_FLAMEBROTHER_ROF: { return 305;} //1465
			}
			break;
		case 30:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RUST_MONSTER: { return 306;} //1500
				case APPEAR_TYPE_BASILIK: { return 307;} //1501
				case APPEAR_TYPE_SNAKE: { return 308;} //1502
				case APPEAR_TYPE_SCORPION: { return 309;} //1504
				case APPEAR_TYPE_XORN: { return 310;} //1505
				case APPEAR_TYPE_CARRION_CRAWLER: { return 311;} //1506
				case APPEAR_TYPE_DRACOLICH: { return 312;} //1507
				case APPEAR_TYPE_DISPLACER_BEAST: { return 313;} //1508
			}
			break;
		case 40:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_RDS_PORTAL: { return 314;} //2041
				case APPEAR_TYPE_FLYING_BOOK: { return 315;} //2042
				case APPEAR_TYPE_RAT_CRANIUM: { return 316;} //2043
				case APPEAR_TYPE_SLIME: { return 317;} //2044
				case APPEAR_TYPE_MONODRONE: { return 318;} //2045
				case APPEAR_TYPE_SPIDER_HOOK: { return 319;} //2046
				case APPEAR_TYPE_DABUS: { return 320;} //2047
				case APPEAR_TYPE_BARIAUR: { return 321;} //2049
			}
			break;
		case 41:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DOGDEAD: { return 322;} //2053
				case APPEAR_TYPE_URIDEZU: { return 323;} //2054
				case APPEAR_TYPE_DUODRONE: { return 324;} //2055
				case APPEAR_TYPE_TRIDRONE: { return 325;} //2056
				case APPEAR_TYPE_PENTADRONE: { return 326;} //2057
			}
			break;
		case 46:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GELATINOUS_CUBE: { return 327;} //2300
				case APPEAR_TYPE_OOZE: { return 328;} //2301
				case APPEAR_TYPE_HAMMERHEAD_SHARK: { return 329;} //2302
				case APPEAR_TYPE_MAKO_SHARK: { return 330;} //2303
				case APPEAR_TYPE_MYCONID: { return 331;} //2304
				case APPEAR_TYPE_NAGA: { return 332;} //2305
				case APPEAR_TYPE_PURRLE_WORM: { return 333;} //2306
				case APPEAR_TYPE_STIRGE: { return 334;} //2307
				case APPEAR_TYPE_STIRGE_TINT: { return 335;} //2308
				case APPEAR_TYPE_PURRLE_WORM_TINT: { return 336;} //2309
			}
			break;
		case 60:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_GIANT_HILL: { return 337;} //3000
				case APPEAR_TYPE_GIANT_STONE: { return 338;} //3001
				case APPEAR_TYPE_GIANT_FIRE_ALT: { return 339;} //3002
				case APPEAR_TYPE_GIANT_FROST_ALT: { return 340;} //3003
				case APPEAR_TYPE_GIANT_CLOUD: { return 341;} //3004
				case APPEAR_TYPE_GIANT_FOREST: { return 342;} //3005
				case APPEAR_TYPE_GIANT_STORM: { return 343;} //3006
				
				case APPEAR_TYPE_GIBBERING_MOUTHER: { return 344;} //3010
				case APPEAR_TYPE_BIGBY_GRASPING: { return 345;} //3020
				case APPEAR_TYPE_BIGBY_INTERPOS: { return 346;} //3021
				case APPEAR_TYPE_BIGBY_FIST: { return 347;} //3022
				
			}
			break;
		case 62:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_DRAGONMAN: { return 348;} //3100
				case APPEAR_TYPE_UNICORN: { return 349;} //3101
				case APPEAR_TYPE_ELEMENTAL_MAGMA: { return 350;} //3102
				case APPEAR_TYPE_ELEMENTAL_ADAMANTIT: { return 351;} //3103
				case APPEAR_TYPE_ELEMENTAL_ICE: { return 352;} //3104
				case APPEAR_TYPE_ELEMENTAL_SILVER: { return 353;} //3105
				case APPEAR_TYPE_FRISCHLING: { return 354;} //3106
				case APPEAR_TYPE_TIGER_01: { return 355;} //3107
				case APPEAR_TYPE_DOG_GERMAN: { return 356;} //3108
				case APPEAR_TYPE_FOURMI: { return 357;} //3109
			}
			break;
		case 68:
			switch ( iAppearanceType )
			{
				case APPEAR_TYPE_EFREETI: { return 358;} //3400
			}
			break;
	}
	
	return -1;
}
*/
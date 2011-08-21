/** @file
* @brief Item and Item property functions
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/


/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////
/*
Integrated code from http://nwvault.ign.com/View.php?view=Nwn2hakpaksoriginal.Detail&id=153

For item placeables.
*/

/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCUtilityConstants"
#include "_CSLCore_Math"
#include "_CSLCore_Reputation"
#include "_CSLCore_Messages"
#include "_CSLCore_Info"
#include "_CSLCore_Position"
#include "_CSLCore_Class"

#include "_CSLCore_Items_c"
#include "_CSLCore_Feats_c"
#include "_CSLCore_Class_c"

/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////



// melee distance
const float CSL_MELEE_DISTANCE = 3.0;

/////////////////////////////////////////////////////
////////////////// Structs //////////////////////////
/////////////////////////////////////////////////////

/**  
* @author
* @param 
* @see 
* @return 
*/
struct ItemPropsStruct
{
   int ItemBase;
   string ItemType;
   int ItemLevel;
   int ItemCost;
   int ItemCostMult;
   int ValidProps;
   int UsedProps;
   int HasUnique;
   int SaveSpecificCurrent;
   int SaveVsCurrent;
   int AbilityCurrent;
   int AbilityType;
   int SkillCurrent;
   int SkullType;
   int ACCurrent;

   int Prop1Type;    int Prop1SubType;    int Prop1Bonus;   string Prop1Desc;
   int Prop2Type;    int Prop2SubType;    int Prop2Bonus;   string Prop2Desc;
   int Prop3Type;    int Prop3SubType;    int Prop3Bonus;   string Prop3Desc;
   int Prop4Type;    int Prop4SubType;    int Prop4Bonus;   string Prop4Desc;
   int Prop5Type;    int Prop5SubType;    int Prop5Bonus;   string Prop5Desc;
   int Prop6Type;    int Prop6SubType;    int Prop6Bonus;   string Prop6Desc;
   int Prop7Type;    int Prop7SubType;    int Prop7Bonus;   string Prop7Desc;
   int Prop8Type;    int Prop8SubType;    int Prop8Bonus;   string Prop8Desc;
   int PropCount;
   string PropList;
   string PropTag;
   int WeaponThrow;
   int WeaponAmmo;
   int WeaponRanged;
   int WeaponSize;
   int WeaponType;
   int WeaponMelee;
   int WeaponMods;
   int WeaponCritThreat;
   int WeaponCritMult;
   int WeaponModsCount;
   int WeaponDamageMax;
   int WeaponDamageCurrent;
   int WeaponVampRegenCurrent;
   int WeaponVampRegenMax;
   int WeaponMightyCurrent;
   int WeaponMightyMax;
   int WeaponMassCritCurrent;
   int WeaponMassCritMax;
   int WeaponExotic;

   int WeaponABEB;
   int WeaponABCurrent;

};

struct ItemPropsStruct ItemProps;

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////






/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


object oItemTable;
/**  
* Makes sure the oItemTable is a valid pointer to the Race dataobject
* @author
* @see 
* @return 
*/
void CSLGetItemDataObject()
{
	if ( !GetIsObjectValid( oItemTable ) )
	{
		oItemTable = CSLDataObjectGet( "baseitems" );
	}
	// label,Name,PrefAttackDist,NumDice,DieToRoll,CritThreat,CritHitMult,FEATImprCrit,FEATWpnFocus,FEATWpnSpec,FEATEpicDevCrit,FEATEpicWpnFocus,FEATEpicWpnSpec,FEATOverWhCrit,FEATWpnOfChoice,FEATGrtrWpnFocus,FEATGrtrWpnSpec,FEATPowerCrit,ReqFeat0,ReqFeat1,ReqFeat2,ReqFeat3,ReqFeat4,ReqFeat5 
}


/**  
* Get the Name of the given Subrace
* @author
* @param iSubRace Subrace as returned by GetSubRace()
* @return the Name of the specified SubRace
*/
float CSLGetItemDataPrefAttackDistance(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToFloat( Get2DAString("baseitems", "PrefAttackDist", iBaseItemType) );
	}
	return StringToFloat( CSLDataTableGetStringByRow( oItemTable, "PrefAttackDist", iBaseItemType ) );
	
}


int CSLGetItemDataPrefFeatWeaponFocus(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATWpnFocus", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATWpnFocus", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatGreaterWeaponFocus(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATGrtrWpnFocus", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATGrtrWpnFocus", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatEpicWeaponFocus(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATEpicWpnFocus", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATEpicWpnFocus", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatWeaponOfChoice(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATWpnOfChoice", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATWpnOfChoice", iBaseItemType ) );
	
}


int CSLGetItemDataPrefFeatWeaponSpecialization(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATWpnSpec", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATWpnSpec", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatEpicDevestatingCritical(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATEpicDevCrit", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATEpicDevCrit", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatEpicWeaponSpecialization(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATEpicWpnSpec", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATEpicWpnSpec", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatOverwhelmingCritical(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATOverWhCrit", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATOverWhCrit", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatGreaterWeaponSpecialization(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATGrtrWpnSpec", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATGrtrWpnSpec", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatPowerCritical(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATPowerCrit", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATPowerCrit", iBaseItemType ) );
	
}

int CSLGetItemDataPrefFeatImprovedCritical(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "FEATImprCrit", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "FEATImprCrit", iBaseItemType ) );
	
}


int CSLGetItemDataCriticalThreat(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "CritThreat", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "CritThreat", iBaseItemType ) );
	
}

int CSLGetItemDataCriticalHitMultiplier(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "CritHitMult", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "CritHitMult", iBaseItemType ) );
	
}


int CSLGetItemDataDieToRoll(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "DieToRoll", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "DieToRoll", iBaseItemType ) );
	
}

int CSLGetItemDataNumDice(int iBaseItemType )
{
	CSLGetItemDataObject();
	if ( !GetIsObjectValid( oItemTable ) )
	{
		return StringToInt( Get2DAString("baseitems", "NumDice", iBaseItemType) );
	}
	return StringToInt( CSLDataTableGetStringByRow( oItemTable, "NumDice", iBaseItemType ) );
	
}

/********************************************************************************************************/
/** @name Item Categorization Functions
* Description
********************************************************************************************************* @{ */

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetBaseItemProps( int iBaseItemType )
{
	if ( iBaseItemType == -1 || iBaseItemType == BASE_ITEM_INVALID ) { return ITEM_ATTRIB_NONE; }
	
	int iSubBaseItemType = iBaseItemType / 10;
	switch(iSubBaseItemType)
	{
		case 0:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_SHORTSWORD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_LIGHTWEAPON  | ITEM_ATTRIB_SETTINGSUN  | ITEM_ATTRIB_SHADOWHAND;} //0
				case BASE_ITEM_LONGSWORD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_ELEGANTSTRIKE | ITEM_ATTRIB_DEVOTEDSPIRIT | ITEM_ATTRIB_IRONHEART  | ITEM_ATTRIB_WHITERAVEN;} //1
				case BASE_ITEM_BATTLEAXE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_WHITERAVEN;} //2
				case BASE_ITEM_BASTARDSWORD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_DIAMONDMIND | ITEM_ATTRIB_IRONHEART;} //3
				case BASE_ITEM_LIGHTFLAIL: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM;} //4
				case BASE_ITEM_WARHAMMER: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_WHITERAVEN;} //5
				case BASE_ITEM_HEAVYCROSSBOW: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_INTUITIVEATTACK;} //6
				case BASE_ITEM_LIGHTCROSSBOW: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_INTUITIVEATTACK;} //7
				case BASE_ITEM_LONGBOW: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_LARGE | ITEM_ATTRIB_DEVOTEDSPIRIT;} //8
				case BASE_ITEM_LIGHTMACE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_INTUITIVEATTACK;} //9
			}
			break;
		case 1:
			switch ( iBaseItemType )
			{
				
				case BASE_ITEM_HALBERD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE | ITEM_ATTRIB_WHITERAVEN;} //10
				case BASE_ITEM_SHORTBOW: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_SHADOWHAND  | ITEM_ATTRIB_TIGERCLAW;} //11
				case BASE_ITEM_TWOBLADEDSWORD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE;} //12
				case BASE_ITEM_GREATSWORD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE  | ITEM_ATTRIB_STONEDRAGON | ITEM_ATTRIB_WHITERAVEN;} //13
				case BASE_ITEM_SMALLSHIELD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_SHIELD;} //14
				case BASE_ITEM_TORCH: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_SMALL;} //15
				case BASE_ITEM_ARMOR: { return ITEM_ATTRIB_EQUIPPABLE;} //16
				case BASE_ITEM_HELMET: { return ITEM_ATTRIB_EQUIPPABLE;} //17
				case BASE_ITEM_GREATAXE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE  | ITEM_ATTRIB_STONEDRAGON | ITEM_ATTRIB_TIGERCLAW;} //18
				case BASE_ITEM_AMULET: { return ITEM_ATTRIB_EQUIPPABLE;} //19
			}
			break;
		case 2:
			switch ( iBaseItemType )
			{
				
				case BASE_ITEM_ARROW: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_AMMO;} //20
				case BASE_ITEM_BELT: { return ITEM_ATTRIB_EQUIPPABLE;} //21
				case BASE_ITEM_DAGGER: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_TINY  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_INTUITIVEATTACK | ITEM_ATTRIB_SHADOWHAND;} //22
				case BASE_ITEM_MISCSMALL: { return ITEM_ATTRIB_NONE;} //24
				case BASE_ITEM_BOLT: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_AMMO;} //25
				case BASE_ITEM_BOOTS: { return ITEM_ATTRIB_EQUIPPABLE;} //26
				case BASE_ITEM_BULLET: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_AMMO;} //27
				case BASE_ITEM_CLUB: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_INTUITIVEATTACK;} //28
				case BASE_ITEM_MISCMEDIUM: { return ITEM_ATTRIB_NONE;} //29
			}
			break;
		case 3:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_DART: { return  ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_THROWN | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_TINY | ITEM_ATTRIB_INTUITIVEATTACK;} //31
				case BASE_ITEM_DIREMACE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_LARGE;} //32
				case BASE_ITEM_DOUBLEAXE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE;} //33
				case BASE_ITEM_MISCLARGE: { return ITEM_ATTRIB_NONE;} //34
				case BASE_ITEM_HEAVYFLAIL: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE;} //35
				case BASE_ITEM_GLOVES: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE;} //36
				case BASE_ITEM_LIGHTHAMMER: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_LIGHTWEAPON;} //37
				case BASE_ITEM_HANDAXE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //38
				case BASE_ITEM_HEALERSKIT: { return ITEM_ATTRIB_NONE;} //39
			}
			break;
		case 4:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_KAMA: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //40
				case BASE_ITEM_KATANA: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_DIAMONDMIND;} //41
				case BASE_ITEM_KUKRI: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_TINY  | ITEM_ATTRIB_LIGHTWEAPON  | ITEM_ATTRIB_TIGERCLAW;} //42
				case BASE_ITEM_MISCTALL: { return ITEM_ATTRIB_NONE;} //43
				case BASE_ITEM_MAGICROD: { return ITEM_ATTRIB_NONE;} //44
				case BASE_ITEM_MAGICSTAFF: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM;} //45
				case BASE_ITEM_MAGICWAND: { return ITEM_ATTRIB_NONE;} //46
				case BASE_ITEM_MORNINGSTAR: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_INTUITIVEATTACK;} //47
				case BASE_ITEM_POTIONS: { return ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL;} //49
			}
			break;
		case 5:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_QUARTERSTAFF: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_LARGE | ITEM_ATTRIB_INTUITIVEATTACK  | ITEM_ATTRIB_SETTINGSUN;} //50
				case BASE_ITEM_RAPIER: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_ELEGANTSTRIKE | ITEM_ATTRIB_DIAMONDMIND;} //51
				case BASE_ITEM_RING: { return ITEM_ATTRIB_EQUIPPABLE;} //52
				case BASE_ITEM_SCIMITAR: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_ELEGANTSTRIKE | ITEM_ATTRIB_DESERTWIND;} //53
				case BASE_ITEM_SCROLL: { return ITEM_ATTRIB_NONE;} //54
				case BASE_ITEM_SCYTHE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE  | ITEM_ATTRIB_SHADOWHAND;} //55
				case BASE_ITEM_LARGESHIELD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_SHIELD;} //56
				case BASE_ITEM_TOWERSHIELD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_SHIELD;} //57
				case BASE_ITEM_SHORTSPEAR: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_LARGE;} //58
				case BASE_ITEM_SHURIKEN: { return  ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_THROWN | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_TINY  | ITEM_ATTRIB_SHADOWHAND;} //59
			}
			break;
		case 6:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_SICKLE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_INTUITIVEATTACK | ITEM_ATTRIB_DIAMONDMIND;} //60
				case BASE_ITEM_SLING: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_INTUITIVEATTACK | ITEM_ATTRIB_SETTINGSUN;} //61
				case BASE_ITEM_THIEVESTOOLS: { return ITEM_ATTRIB_NONE;} //62
				case BASE_ITEM_THROWINGAXE: { return  ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_THROWN | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_TINY  | ITEM_ATTRIB_LIGHTWEAPON;} //63
				case BASE_ITEM_TRAPKIT: { return ITEM_ATTRIB_NONE;} //64
				case BASE_ITEM_KEY: { return ITEM_ATTRIB_NONE;} //65
				case BASE_ITEM_LARGEBOX: { return ITEM_ATTRIB_CONTAINER;} //66
				case BASE_ITEM_MISCWIDE: { return ITEM_ATTRIB_NONE;} //68
				case BASE_ITEM_CSLASHWEAPON: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //69
			}
			break;
		case 7:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_CPIERCWEAPON: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //70
				case BASE_ITEM_CBLUDGWEAPON: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //71
				case BASE_ITEM_CSLSHPRCWEAP: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //72
				case BASE_ITEM_CREATUREITEM: { return ITEM_ATTRIB_NONE;} //73
				case BASE_ITEM_BOOK: { return ITEM_ATTRIB_NONE;} //74
				case BASE_ITEM_SPELLSCROLL: { return ITEM_ATTRIB_NONE;} //75
				case BASE_ITEM_GOLD: { return ITEM_ATTRIB_NONE;} //76
				case BASE_ITEM_GEM: { return ITEM_ATTRIB_NONE;} //77
				case BASE_ITEM_BRACER: { return ITEM_ATTRIB_EQUIPPABLE;} //78
				case BASE_ITEM_MISCTHIN: { return ITEM_ATTRIB_NONE;} //79
			}
			break;
		case 8:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_CLOAK: { return ITEM_ATTRIB_EQUIPPABLE;} //80
				case BASE_ITEM_GRENADE: { return ITEM_ATTRIB_NONE;} //81
				case BASE_ITEM_BALORSWORD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM;} //82
				case BASE_ITEM_BALORFALCHION: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM;} //83
			}
			break;
		case 10:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_BLANK_POTION: { return ITEM_ATTRIB_NONE;} //101
				case BASE_ITEM_BLANK_SCROLL: { return ITEM_ATTRIB_NONE;} //102
				case BASE_ITEM_BLANK_WAND: { return ITEM_ATTRIB_NONE;} //103
				case BASE_ITEM_ENCHANTED_POTION: { return ITEM_ATTRIB_NONE;} //104
				case BASE_ITEM_ENCHANTED_SCROLL: { return ITEM_ATTRIB_NONE;} //105
				case BASE_ITEM_ENCHANTED_WAND: { return ITEM_ATTRIB_NONE;} //106
				case BASE_ITEM_DWARVENWARAXE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_IRONHEART;} //108
				case BASE_ITEM_CRAFTMATERIALMED: { return ITEM_ATTRIB_NONE;} //109
			}
			break;	
		case 11:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_CRAFTMATERIALSML: { return ITEM_ATTRIB_NONE;} //110
				case BASE_ITEM_WHIP: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_LIGHTWEAPON;} //111
				case BASE_ITEM_CRAFTBASE: { return ITEM_ATTRIB_NONE;} //112
				case BASE_ITEM_MACE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_DESERTWIND;} //113
				case BASE_ITEM_FALCHION: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE | ITEM_ATTRIB_DEVOTEDSPIRIT | ITEM_ATTRIB_DESERTWIND;} //114
				case BASE_ITEM_FLAIL: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_IRONHEART;} //116
				case BASE_ITEM_SPEAR: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_LARGE | ITEM_ATTRIB_INTUITIVEATTACK  | ITEM_ATTRIB_DESERTWIND;} //119
			}
			break;
		case 12:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_GREATCLUB: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_LARGE;} //120
				case BASE_ITEM_TRAINING_CLUB: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM;} //124
				case BASE_ITEM_SOFTBUNDLE: { return ITEM_ATTRIB_NONE;} //125
				case BASE_ITEM_WARMACE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_LARGE | ITEM_ATTRIB_DEVOTEDSPIRIT | ITEM_ATTRIB_STONEDRAGON;} //126
				case BASE_ITEM_STEIN: { return ITEM_ATTRIB_NONE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_TINY;} //127
				case BASE_ITEM_DRUM: { return ITEM_ATTRIB_NONE | ITEM_ATTRIB_TINY;} //128
				case BASE_ITEM_FLUTE: { return ITEM_ATTRIB_NONE | ITEM_ATTRIB_TINY;} //129
			}
			break;
		case 13:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_INK_WELL: { return ITEM_ATTRIB_NONE;} //130
				case BASE_ITEM_LOOTBAG: { return ITEM_ATTRIB_NONE;} //131
				case BASE_ITEM_MANDOLIN: { return ITEM_ATTRIB_NONE | ITEM_ATTRIB_TINY;} //132
				case BASE_ITEM_PAN: { return ITEM_ATTRIB_NONE;} //133
				case BASE_ITEM_POT: { return ITEM_ATTRIB_NONE;} //134
				case BASE_ITEM_RAKE: { return ITEM_ATTRIB_NONE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_MEDIUM;} //135
				case BASE_ITEM_SHOVEL: { return ITEM_ATTRIB_NONE;} //136
				case BASE_ITEM_SMITHYHAMMER: { return ITEM_ATTRIB_NONE;} //137
				case BASE_ITEM_SPOON: { return ITEM_ATTRIB_NONE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_TINY;} //138
				case BASE_ITEM_BOTTLE: { return ITEM_ATTRIB_NONE;} //139
			}
			break;
		case 14:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_CGIANT_SWORD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING;} //140
				case BASE_ITEM_CGIANT_AXE: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING;} //141
				case BASE_ITEM_ALLUSE_SWORD: { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_ELEGANTSTRIKE | ITEM_ATTRIB_INTUITIVEATTACK;} //142
				case BASE_ITEM_MISCSTACK: { return ITEM_ATTRIB_NONE;} //143
				case BASE_ITEM_BOUNTYITEM: { return ITEM_ATTRIB_NONE;} //144
				case BASE_ITEM_RECIPE: { return ITEM_ATTRIB_NONE;} //145
				case BASE_ITEM_INCANTATION: { return ITEM_ATTRIB_NONE;} //146
			}
			break;
		case 24: // @todo replace these below with above attributes, wait until the above are tested soas to prevent issues where these don't have same values as above
			switch ( iBaseItemType )
			{
				case BASE_ITEM_SHORTSWORD_R: { return ITEM_ATTRIB_NONE;} //241
				case BASE_ITEM_LONGSWORD_R: { return ITEM_ATTRIB_NONE;} //242
				case BASE_ITEM_BATTLEAXE_R: { return ITEM_ATTRIB_NONE;} //243
				case BASE_ITEM_BASTARDSWORD_R: { return ITEM_ATTRIB_NONE;} //244
				case BASE_ITEM_LIGHTFLAIL_R: { return ITEM_ATTRIB_NONE;} //245
				case BASE_ITEM_WARHAMMER_R: { return ITEM_ATTRIB_NONE;} //246
				case BASE_ITEM_MACE_R: { return ITEM_ATTRIB_NONE;} //247
				case BASE_ITEM_HALBERD_R: { return ITEM_ATTRIB_NONE;} //248
				case BASE_ITEM_GREATSWORD_R: { return ITEM_ATTRIB_NONE;} //249
			}
			break;
		case 25:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_GREATAXE_R: { return ITEM_ATTRIB_NONE;} //250
				case BASE_ITEM_DAGGER_R: { return ITEM_ATTRIB_NONE;} //251
				case BASE_ITEM_CLUB_R: { return ITEM_ATTRIB_NONE;} //252
				case BASE_ITEM_LIGHTHAMMER_R: { return ITEM_ATTRIB_NONE;} //253
				case BASE_ITEM_HANDAXE_R: { return ITEM_ATTRIB_NONE;} //254
				case BASE_ITEM_KAMA_R: { return ITEM_ATTRIB_NONE;} //255
				case BASE_ITEM_KATANA_R: { return ITEM_ATTRIB_NONE;} //256
				case BASE_ITEM_KUKRI_R: { return ITEM_ATTRIB_NONE;} //257
				case BASE_ITEM_MAGICSTAFF_R: { return ITEM_ATTRIB_NONE;} //258
				case BASE_ITEM_MORNINGSTAR_R: { return ITEM_ATTRIB_NONE;} //259
			}
			break;
		case 26:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_QUARTERSTAFF_R: { return ITEM_ATTRIB_NONE;} //260
				case BASE_ITEM_RAPIER_R: { return ITEM_ATTRIB_NONE;} //261
				case BASE_ITEM_SCIMITAR_R: { return ITEM_ATTRIB_NONE;} //262
				case BASE_ITEM_SCYTHE_R: { return ITEM_ATTRIB_NONE;} //263
				case BASE_ITEM_SICKLE_R: { return ITEM_ATTRIB_NONE;} //264
				case BASE_ITEM_DWARVENWARAXE_R: { return ITEM_ATTRIB_NONE;} //265
				case BASE_ITEM_WHIP_R: { return ITEM_ATTRIB_NONE;} //266
				case BASE_ITEM_FALCHION_R: { return ITEM_ATTRIB_NONE;} //267
				case BASE_ITEM_FLAIL_R: { return ITEM_ATTRIB_NONE;} //268
				case BASE_ITEM_SPEAR_R: { return ITEM_ATTRIB_NONE;} //269
			}
			break;
		case 27:
			switch ( iBaseItemType )
			{
				case BASE_ITEM_GREATCLUB_R: { return ITEM_ATTRIB_NONE;} //270
				case BASE_ITEM_TRAINING_CLUB_R: { return ITEM_ATTRIB_NONE;} //271
				case BASE_ITEM_WARMACE_R: { return ITEM_ATTRIB_NONE;} //272
			}
			break;

	}
	
	// unknown item type, lets hit the 2da's, should only hit this for custom defined items
	// Others are hard coded so it really should not need anything else
	int iItemAttributes = ITEM_ATTRIB_NONE;
	int iResult = -1;
	string sResult;
	
	sResult = Get2DAString("baseitems","EquipableSlots",iBaseItemType);
	if  ( sResult != "" && sResult != "0x00000")
	{
		iItemAttributes |= ITEM_ATTRIB_EQUIPPABLE;
	}
	
	sResult = Get2DAString("baseitems","WeaponType",iBaseItemType);
	if  ( sResult != "" )
	{
		iResult = StringToInt(sResult);
		switch ( iResult )
		{
			case 1:
				iItemAttributes |= ITEM_ATTRIB_PIERCING;
				break;
			case 2:
				iItemAttributes |= ITEM_ATTRIB_BLUDGEONING;
				break;
			case 3:
				iItemAttributes |= ITEM_ATTRIB_SLASHING;
				break;
			case 4:
				iItemAttributes |= ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING;
				break;
		}
		
	}
	
	 sResult = Get2DAString("baseitems","WeaponSize",iBaseItemType);
	if  ( sResult != "" )
	{
		iResult = StringToInt(sResult);
		switch ( iResult )
		{
			case 1:
				iItemAttributes |= ITEM_ATTRIB_TINY;
				break;
			case 2:
				iItemAttributes |= ITEM_ATTRIB_SMALL;
				break;
			case 3:
				iItemAttributes |= ITEM_ATTRIB_MEDIUM;
				break;
			case 4:
				iItemAttributes |= ITEM_ATTRIB_LARGE;
				break;
		}
	}
	
	return iItemAttributes;
	
}



/**  
* Returns the correct amount of damage for IP_CONST_DAMAGEBONUS_*.
* This function is not intended to return the IP_CONST_DAMAGEBONUS_* values as #d#. Only integers.
*  -nNumber: The damage bonus we're searching for.
* Provide mapping between numbers and bonus constants for ITEM_PROPERTY_DAMAGE_BONUS
* Note that nNumber should be > 0!
* @author
* @param 
* @see 
* @replaces XXXIPGetConstDamageBonusFromNumber
* @return 
*/
int CSLGetConstDamageBonusFromNumber(int nNumber)
{
	switch (nNumber)
	{
		case 1: return IP_CONST_DAMAGEBONUS_1;
		case 2: return IP_CONST_DAMAGEBONUS_2;
		case 3: return IP_CONST_DAMAGEBONUS_3;
		case 4: return IP_CONST_DAMAGEBONUS_4;
		case 5: return IP_CONST_DAMAGEBONUS_5;
		case 6: return IP_CONST_DAMAGEBONUS_6;
		case 7: return IP_CONST_DAMAGEBONUS_7;
		case 8: return IP_CONST_DAMAGEBONUS_8;
		case 9: return IP_CONST_DAMAGEBONUS_9;
		case 10: return IP_CONST_DAMAGEBONUS_10;
		case 11: return IP_CONST_DAMAGEBONUS_11;
		case 12: return IP_CONST_DAMAGEBONUS_12;
		case 13: return IP_CONST_DAMAGEBONUS_13;
		case 14: return IP_CONST_DAMAGEBONUS_14;
		case 15: return IP_CONST_DAMAGEBONUS_15;
		case 16: return IP_CONST_DAMAGEBONUS_16;
		case 17: return IP_CONST_DAMAGEBONUS_17;
		case 18: return IP_CONST_DAMAGEBONUS_18;
		case 19: return IP_CONST_DAMAGEBONUS_19;
		case 20: return IP_CONST_DAMAGEBONUS_20;
		case 21: return IP_CONST_DAMAGEBONUS_21;
		case 22: return IP_CONST_DAMAGEBONUS_22;
		case 23: return IP_CONST_DAMAGEBONUS_23;
		case 24: return IP_CONST_DAMAGEBONUS_24;
		case 25: return IP_CONST_DAMAGEBONUS_25;
		case 26: return IP_CONST_DAMAGEBONUS_26;
		case 27: return IP_CONST_DAMAGEBONUS_27;
		case 28: return IP_CONST_DAMAGEBONUS_28;
		case 29: return IP_CONST_DAMAGEBONUS_29;
		case 30: return IP_CONST_DAMAGEBONUS_30;
		case 31: return IP_CONST_DAMAGEBONUS_31;
		case 32: return IP_CONST_DAMAGEBONUS_32;
		case 33: return IP_CONST_DAMAGEBONUS_33;
		case 34: return IP_CONST_DAMAGEBONUS_34;
		case 35: return IP_CONST_DAMAGEBONUS_35;
		case 36: return IP_CONST_DAMAGEBONUS_36;
		case 37: return IP_CONST_DAMAGEBONUS_37;
		case 38: return IP_CONST_DAMAGEBONUS_38;
		case 39: return IP_CONST_DAMAGEBONUS_39;
		case 40: return IP_CONST_DAMAGEBONUS_40;
	}
		
	if (nNumber > 40)
   	{
       	return IP_CONST_DAMAGEBONUS_40;
   	}
	else
   	{
       	return -1;
   	}
}

/**  
* Gets a random damage amount based on a given damage bonus constant
* @author
* @param 
* @see 
* @replaces XXXGetDamageByIPConstDamageBonus
* @return 
*/
int CSLGetDamageByIPConstDamageBonus(int nDamageBonus)
{
	switch (nDamageBonus)
	{
		case IP_CONST_DAMAGEBONUS_1: return 1; break;
		case IP_CONST_DAMAGEBONUS_10: return 10; break;
		case IP_CONST_DAMAGEBONUS_1d10: return d10(1); break;	
		case IP_CONST_DAMAGEBONUS_1d12: return d12(1); break;
		case IP_CONST_DAMAGEBONUS_1d4: return d4(1); break;
		case IP_CONST_DAMAGEBONUS_1d6: return d6(1); break;	
		case IP_CONST_DAMAGEBONUS_1d8: return d8(1); break;
		case IP_CONST_DAMAGEBONUS_2: return 2; break;
		case IP_CONST_DAMAGEBONUS_2d10: return d10(2); break;	
		case IP_CONST_DAMAGEBONUS_2d12: return d12(2); break;
		case IP_CONST_DAMAGEBONUS_2d4: return d4(2); break;
		case IP_CONST_DAMAGEBONUS_2d6: return d6(2); break;	
		case IP_CONST_DAMAGEBONUS_2d8: return d8(2); break;
		case IP_CONST_DAMAGEBONUS_3: return 3; break;
		case IP_CONST_DAMAGEBONUS_3d10: return d10(3); break;	
		case IP_CONST_DAMAGEBONUS_3d12: return d12(3); break;
		case IP_CONST_DAMAGEBONUS_3d6: return d6(3); break;
		case IP_CONST_DAMAGEBONUS_4: return 4; break;	
		case IP_CONST_DAMAGEBONUS_4d10: return d10(4); break;
		case IP_CONST_DAMAGEBONUS_4d12: return d12(4); break;
		case IP_CONST_DAMAGEBONUS_4d6: return d6(4); break;	
		case IP_CONST_DAMAGEBONUS_4d8: return d8(4); break;
		case IP_CONST_DAMAGEBONUS_5: return 5; break;
		case IP_CONST_DAMAGEBONUS_5d12: return d12(5); break;	
		case IP_CONST_DAMAGEBONUS_5d6: return d6(5); break;
		case IP_CONST_DAMAGEBONUS_6: return 6; break;
		case IP_CONST_DAMAGEBONUS_6d12: return d12(6); break;	
		case IP_CONST_DAMAGEBONUS_6d6: return d6(6); break;
		case IP_CONST_DAMAGEBONUS_7: return 7; break;
		case IP_CONST_DAMAGEBONUS_8: return 8; break;	
		case IP_CONST_DAMAGEBONUS_9: return 9; break;
		default: return 1;break;																					
	}
	
	return 1;
}

/**  
* Provide mapping between numbers and bonus constants for ITEM_PROPERTY_DAMAGE_BONUS
* Note that nNumber should be > 0!
* @author
* @param 
* @see 
* @replaces XXXIPGetDamageBonusConstantFromNumber GetConstDamageBonusFromNumber GetDamageBonusByValue
* @return 
*/
int CSLGetDamageBonusConstantFromNumber(int nNumber, int bForceValidResult = FALSE)
{
    switch (nNumber)
    {
        case 1:  return DAMAGE_BONUS_1;
        case 2:  return DAMAGE_BONUS_2;
        case 3:  return DAMAGE_BONUS_3;
        case 4:  return DAMAGE_BONUS_4;
        case 5:  return DAMAGE_BONUS_5;
        case 6:  return DAMAGE_BONUS_6;
        case 7:  return DAMAGE_BONUS_7;
        case 8:  return DAMAGE_BONUS_8;
        case 9:  return DAMAGE_BONUS_9;
        case 10: return DAMAGE_BONUS_10;
        case 11:  return DAMAGE_BONUS_11;
        case 12:  return DAMAGE_BONUS_12;
        case 13:  return DAMAGE_BONUS_13;
        case 14:  return DAMAGE_BONUS_14;
        case 15:  return DAMAGE_BONUS_15;
        case 16:  return DAMAGE_BONUS_16;
        case 17:  return DAMAGE_BONUS_17;
        case 18:  return DAMAGE_BONUS_18;
        case 19:  return DAMAGE_BONUS_19;
        case 20: return DAMAGE_BONUS_20;
		case 21: return DAMAGE_BONUS_21;
        case 22: return DAMAGE_BONUS_22;
        case 23: return DAMAGE_BONUS_23;
        case 24: return DAMAGE_BONUS_24;
        case 25: return DAMAGE_BONUS_25;
        case 26: return DAMAGE_BONUS_26;
        case 27: return DAMAGE_BONUS_27;
        case 28: return DAMAGE_BONUS_28;
        case 29: return DAMAGE_BONUS_29;
        case 30: return DAMAGE_BONUS_30;
        case 31: return DAMAGE_BONUS_31;
        case 32: return DAMAGE_BONUS_32;
        case 33: return DAMAGE_BONUS_33;
        case 34: return DAMAGE_BONUS_34;
        case 35: return DAMAGE_BONUS_35;
        case 36: return DAMAGE_BONUS_36;
        case 37: return DAMAGE_BONUS_37;
        case 38: return DAMAGE_BONUS_38;
        case 39: return DAMAGE_BONUS_39;
        case 40: return DAMAGE_BONUS_40;
    }

    if (nNumber>40)
    {
        return DAMAGE_BONUS_40;
    }
    else  if ( bForceValidResult && nNumber < 1 )
    {
        return DAMAGE_BONUS_1;
    }
    return -1;
}


/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXGetDamageByDamageBonus
* @return 
*/
int CSLGetDamageByDamageBonus(int nDamageBonus)
{
	switch (nDamageBonus)
	{
		case DAMAGE_BONUS_1d10: return d10(1); break;	
		case DAMAGE_BONUS_1d12: return d12(1); break;	
		case DAMAGE_BONUS_1d4: return d4(1); break;	
		case DAMAGE_BONUS_1d6: return d6(1); break;	
		case DAMAGE_BONUS_1d8: return d8(1); break;	
		case DAMAGE_BONUS_2d10: return d10(2); break;	
		case DAMAGE_BONUS_2d12: return d12(2); break; 
		case DAMAGE_BONUS_2d4: return d4(2); break;	
		case DAMAGE_BONUS_2d6: return d6(2); break;	
		case DAMAGE_BONUS_2d8: return d8(2); break;	
		case DAMAGE_BONUS_1: return 1; break;
		case DAMAGE_BONUS_2: return 2; break;
		case DAMAGE_BONUS_3: return 3; break;
		case DAMAGE_BONUS_4: return 4; break;
		case DAMAGE_BONUS_5: return 5; break;	
		case DAMAGE_BONUS_6: return 6; break;	
		case DAMAGE_BONUS_7: return 7; break;	
		case DAMAGE_BONUS_8: return 8; break;	
		case DAMAGE_BONUS_9: return 9; break;
		case DAMAGE_BONUS_10: return 10; break;	
		case DAMAGE_BONUS_11: return 11; break;	
		case DAMAGE_BONUS_12: return 12; break;	
		case DAMAGE_BONUS_13: return 13; break;	
		case DAMAGE_BONUS_14: return 14; break;	
		case DAMAGE_BONUS_15: return 15; break;	
		case DAMAGE_BONUS_16: return 16; break;	
		case DAMAGE_BONUS_17: return 17; break;	
		case DAMAGE_BONUS_18: return 18; break;	
		case DAMAGE_BONUS_19: return 19; break;
		case DAMAGE_BONUS_20: return 20; break;	
		case DAMAGE_BONUS_21: return 21; break;	
		case DAMAGE_BONUS_22: return 22; break;	
		case DAMAGE_BONUS_23: return 23; break;	
		case DAMAGE_BONUS_24: return 24; break;	
		case DAMAGE_BONUS_25: return 25; break;	
		case DAMAGE_BONUS_26: return 26; break;	
		case DAMAGE_BONUS_27: return 27; break;	
		case DAMAGE_BONUS_28: return 28; break;	
		case DAMAGE_BONUS_29: return 29; break;
		case DAMAGE_BONUS_30: return 30; break;	
		case DAMAGE_BONUS_31: return 31; break; 
		case DAMAGE_BONUS_32: return 32; break;	
		case DAMAGE_BONUS_33: return 33; break;	
		case DAMAGE_BONUS_34: return 34; break;	
		case DAMAGE_BONUS_35: return 35; break;	
		case DAMAGE_BONUS_36: return 36; break;	
		case DAMAGE_BONUS_37: return 37; break; 
		case DAMAGE_BONUS_38: return 38; break;	
		case DAMAGE_BONUS_39: return 39; break;	
		case DAMAGE_BONUS_40: return 40; break;	
		default: return 1; break;																																																																				
	}
	return 1;
}

/**  
* Provide mapping between numbers and power constants for
* ITEM_PROPERTY_DAMAGE_BONUS
* @author
* @param 
* @see 
* @replaces XXXIPGetDamagePowerConstantFromNumber
* @return 
*/
int CSLGetDamagePowerConstantFromNumber(int nNumber)
{
    switch (nNumber)
    {
        case 0: return DAMAGE_POWER_NORMAL;
        case 1: return DAMAGE_POWER_PLUS_ONE;
        case 2: return  DAMAGE_POWER_PLUS_TWO;
        case 3: return DAMAGE_POWER_PLUS_THREE;
        case 4: return DAMAGE_POWER_PLUS_FOUR;
        case 5: return DAMAGE_POWER_PLUS_FIVE;
        case 6: return DAMAGE_POWER_PLUS_SIX;
        case 7: return DAMAGE_POWER_PLUS_SEVEN;
        case 8: return DAMAGE_POWER_PLUS_EIGHT;
        case 9: return DAMAGE_POWER_PLUS_NINE;
        case 10: return DAMAGE_POWER_PLUS_TEN;
        case 11: return DAMAGE_POWER_PLUS_ELEVEN;
        case 12: return DAMAGE_POWER_PLUS_TWELVE;
        case 13: return DAMAGE_POWER_PLUS_THIRTEEN;
        case 14: return DAMAGE_POWER_PLUS_FOURTEEN;
        case 15: return DAMAGE_POWER_PLUS_FIFTEEN;
        case 16: return DAMAGE_POWER_PLUS_SIXTEEN;
        case 17: return DAMAGE_POWER_PLUS_SEVENTEEN;
        case 18: return DAMAGE_POWER_PLUS_EIGHTEEN;
        case 19: return DAMAGE_POWER_PLUS_NINTEEN;
        case 20: return DAMAGE_POWER_PLUS_TWENTY;
    }

    if (nNumber>20)
    {
        return DAMAGE_POWER_PLUS_TWENTY;
    }
	else
    {
        return DAMAGE_POWER_NORMAL;
    }
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLInventorySlotToString(int nSlot = 0)
{
	if (nSlot == INVENTORY_SLOT_HEAD     ) return "Head"; // 0
	if (nSlot == INVENTORY_SLOT_CHEST    ) return "Chest"; // 1
	if (nSlot == INVENTORY_SLOT_BOOTS    ) return "Boots"; // 2
	if (nSlot == INVENTORY_SLOT_ARMS     ) return "Arms"; // 3
	if (nSlot == INVENTORY_SLOT_RIGHTHAND) return "Right Hand"; // 4
	if (nSlot == INVENTORY_SLOT_LEFTHAND ) return "Left Hand"; // 5
	if (nSlot == INVENTORY_SLOT_CLOAK    ) return "Cloak"; // 6
	if (nSlot == INVENTORY_SLOT_LEFTRING ) return "Left Ring"; // 7
	if (nSlot == INVENTORY_SLOT_RIGHTRING) return "Right Ring"; // 8
	if (nSlot == INVENTORY_SLOT_NECK     ) return "Neck"; // 9
	if (nSlot == INVENTORY_SLOT_BELT     ) return "Belt"; // 10
	if (nSlot == INVENTORY_SLOT_ARROWS   ) return "Arrows"; // 11
	if (nSlot == INVENTORY_SLOT_BULLETS  ) return "Bullets"; // 12
	if (nSlot == INVENTORY_SLOT_BOLTS    ) return "Bolts"; // 13
	if (nSlot == INVENTORY_SLOT_CWEAPON_L  ) return "Creature Weapon Left"; // 14
	if (nSlot == INVENTORY_SLOT_CWEAPON_R ) return "Creature Weapon Right"; // 15
	if (nSlot == INVENTORY_SLOT_CWEAPON_B ) return "Creature Weapon Bite"; //16
	if (nSlot == INVENTORY_SLOT_CARMOUR  ) return "Creature Hide"; // 17
	return "MissInvSlot" + IntToString(nSlot);
}

/**  
* returns TRUE if item can be equipped. Uses Get2DAString for custom items but most use stored data
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsEquipable( int iBaseItemType )
{
	if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_EQUIPPABLE )
	{
		return TRUE;
	}
	return FALSE;
}




/**  
* returns TRUE if item can be equipped. Uses Get2DAString for custom items but most use stored data
* @author
* @param 
* @see 
* @replaces XXXIPGetIsItemEquipable, CSLGetIsItemEquipable, GetIsEquippable
* @return 
*/
int CSLItemGetIsEquipable( object oItem )
{
	if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_EQUIPPABLE )
		{
			return TRUE;
		}
	}
	return FALSE;
}



/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetIsAWeapon( int iBaseItemType )
{
	if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_WEAPON )
	{
		return TRUE;
	}
	return FALSE;
}


/**  
* Is this a weapon. ( Does not include Ammo )
* @author
* @param 
* @see 
* @replaces XXXGetIsWeapon
* @return 
*/
int CSLItemGetIsAWeapon(object oItem)
{
	if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_WEAPON )
		{
			return TRUE;
		}
	}
	return FALSE;
}

/**  
* Returns TRUE if oItem is a melee weapon
* @author
* @param 
* @see 
* @replaces XXXIPGetIsMeleeWeapon, CSLGetIsItemMeleeWeapon
* @return 
*/
int CSLGetIsMeleeWeapon(int iBaseItemType)
{
	if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_MELEE )
	{
		return TRUE;
	}
	return FALSE;
}

/**  
* Returns TRUE if oItem is a melee weapon
* @author
* @param 
* @see 
* @replaces XXXIPGetIsMeleeWeapon, CSLGetIsItemMeleeWeapon
* @return 
*/
int CSLItemGetIsMeleeWeapon(object oItem)
{
	if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_MELEE )
		{
			return TRUE;
		}
	}
	return FALSE;
}


/**  
* Returns TRUE if oItem is a crafting base item
* @author
* @param iBaseItemType
* @see 
* @replaces 
* @return 
*/
int CSLGetIsCraftingBaseItem(int iBaseItemType)
{
	if (iBaseItemType == 101 || iBaseItemType == 102 || iBaseItemType == 103)
	{
		return TRUE;
	}
	return FALSE;
}


/**  
* Returns TRUE if oItem is a crafting base item
* @author
* @param 
* @see 
* @replaces XXXCIGetIsCraftFeatBaseItem
* @return 
*/
int CSLItemGetIsCraftingBaseItem(object oItem)
{
	return  CSLGetIsCraftingBaseItem( GetBaseItemType(oItem) );
}







/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXCSLGetIsSlashingWeapon
* @return 
*/
int CSLItemGetIsSlashingWeapon(object oItem)
{
	if ( GetIsObjectValid(oItem) && ( GetWeaponType(oItem) == WEAPON_TYPE_SLASHING || GetWeaponType(oItem) == WEAPON_TYPE_PIERCING_AND_SLASHING ) )
	{
		return TRUE;
	}
	return FALSE;
	
	//int nBT = GetBaseItemType(oItem);
	//int nWeapon =  ( StringToInt(Get2DAString("baseitems","WeaponType",nBT)));
	// 2 = bludgeoning
	//return (nWeapon == 2);
}

/**  
* Returns TRUE if weapon is a blugeoning weapon
* Uses Get2DAString!
* @author
* @param 
* @see 
* @replaces XXXCSLGetIsBludgeoningWeapon XXXIPGetIsBludgeoningWeapon
* @return 
*/
int CSLItemGetIsBludgeoningWeapon(object oItem)
{
	if ( GetIsObjectValid(oItem) && GetWeaponType(oItem) == WEAPON_TYPE_BLUDGEONING )
	{
		return TRUE;
	}
	return FALSE;
	/* I can just use engine function instead
	if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_BLUDGEONING )
		{
			return TRUE;
		}
	}
	return FALSE;
	*/
}




/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXCSLGetIsPiercingWeapon
* @return 
*/
int CSLItemGetIsPiercingWeapon(object oItem)
{
	if ( GetIsObjectValid(oItem) && ( GetWeaponType(oItem) == WEAPON_TYPE_PIERCING || GetWeaponType(oItem) == WEAPON_TYPE_PIERCING_AND_SLASHING ) )
	{
		return TRUE;
	}
	return FALSE;
  //int nBT = GetBaseItemType(oItem);
  //int nWeapon =  ( StringToInt(Get2DAString("baseitems","WeaponType", GetBaseItemType(oItem) )));
  // 2 = bludgeoning
  //return (nWeapon == 2);
}


/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXCSLGetIsPiercingOrSlashingWeapon CSLGetIsPiercingOrSlashingWeapon
* @return 
*/
int CSLItemGetIsPiercingOrSlashingWeapon(object oItem)
{
	if ( GetIsObjectValid(oItem) && ( GetWeaponType(oItem) == WEAPON_TYPE_SLASHING || GetWeaponType(oItem) == WEAPON_TYPE_PIERCING || GetWeaponType(oItem) == WEAPON_TYPE_PIERCING_AND_SLASHING ) )
	{
		return TRUE;
	}
	return FALSE;
  //int nBT = GetBaseItemType(oItem);
  //int nWeapon =  ( StringToInt(Get2DAString("baseitems","WeaponType",nBT)));
  // 2 = bludgeoning
  //return (nWeapon == 2);
}




int CSLGetConstDamageType(object oItem)
{
    if ( !GetIsObjectValid(oItem) )
	{
		return -1;
	}
	else if ( GetWeaponType(oItem) == WEAPON_TYPE_SLASHING || GetWeaponType(oItem) == WEAPON_TYPE_PIERCING_AND_SLASHING )
	{
		return IP_CONST_DAMAGETYPE_SLASHING;
	}
	else if ( GetWeaponType(oItem) == WEAPON_TYPE_BLUDGEONING )
	{
		return IP_CONST_DAMAGETYPE_BLUDGEONING;
	}
	else if ( GetWeaponType(oItem) == WEAPON_TYPE_PIERCING )
	{
		return IP_CONST_DAMAGETYPE_PIERCING;
	}
	return -1;
}
	
	
 /*  
    
    //Declare major variables
    int nItem = GetBaseItemType(oItem);

    if((nItem == BASE_ITEM_BASTARDSWORD) ||
      (nItem == BASE_ITEM_BATTLEAXE) ||	  
      (nItem == BASE_ITEM_SHORTSWORD) ||
      (nItem == BASE_ITEM_DOUBLEAXE) ||
      (nItem == BASE_ITEM_GREATAXE) ||
      (nItem == BASE_ITEM_GREATSWORD) ||
      (nItem == BASE_ITEM_HALBERD) ||
      (nItem == BASE_ITEM_HANDAXE) ||
      (nItem == BASE_ITEM_KAMA) ||
      (nItem == BASE_ITEM_KATANA) ||
      (nItem == BASE_ITEM_KUKRI) ||
      (nItem == BASE_ITEM_LONGSWORD) ||
      (nItem == BASE_ITEM_SCIMITAR) ||
      (nItem == BASE_ITEM_SCYTHE) ||
      (nItem == BASE_ITEM_SICKLE) ||
	  (nItem == BASE_ITEM_DAGGER) ||
	  (nItem == BASE_ITEM_FALCHION)	||	
      (nItem == BASE_ITEM_DWARVENWARAXE) ||  
      (nItem == BASE_ITEM_WHIP) ||
      (nItem == BASE_ITEM_TWOBLADEDSWORD)) return IP_CONST_DAMAGETYPE_SLASHING;
	if((nItem == BASE_ITEM_CLUB) ||
      (nItem == BASE_ITEM_DIREMACE) ||
	  (nItem == BASE_ITEM_BULLET) ||
      (nItem == BASE_ITEM_HEAVYFLAIL) ||
      (nItem == BASE_ITEM_LIGHTFLAIL) ||
      (nItem == BASE_ITEM_LIGHTHAMMER) ||
      (nItem == BASE_ITEM_LIGHTMACE) ||
      (nItem == BASE_ITEM_MORNINGSTAR) ||
      (nItem == BASE_ITEM_QUARTERSTAFF) ||
      (nItem == BASE_ITEM_MAGICSTAFF) ||	  
      (nItem == BASE_ITEM_WARHAMMER)  ||
	  (nItem == BASE_ITEM_MACE)	||
	  (nItem == BASE_ITEM_FLAIL)	||
	  (nItem == BASE_ITEM_WARMACE)) return IP_CONST_DAMAGETYPE_BLUDGEONING;
	  	  
    if((nItem == BASE_ITEM_SHORTSPEAR) ||	  
      (nItem == BASE_ITEM_RAPIER) ||
	  (nItem == BASE_ITEM_ARROW) ||
	  (nItem == BASE_ITEM_BOLT) ||
	  (nItem == BASE_ITEM_SPEAR)) return IP_CONST_DAMAGETYPE_PIERCING;
return -1;
}
*/


/**  
* Returns TRUE if oWeapon is vaild for Weapon Finesse and similar feats.
* @author
* @param 
* @see 
* @replaces CSLGetIsLightWeapon
* @return 
*/
int CSLItemGetIsLightWeapon(object oItem, object oPC = OBJECT_INVALID)
{
	if	(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_LIGHTWEAPON )
		{
			return TRUE;
		}
	}
	return FALSE;
}

/**  
* Returns TRUE if iBaseItemType is a ranged weapon
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetIsRangedWeapon( int iBaseItemType )
{
    if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_RANGED )
	{
		return TRUE;
	}
	return FALSE;
}


/**  
* Returns TRUE if oItem is a ranged weapon
* @author
* @param 
* @see 
* @replaces XXXIPGetIsRangedWeapon XXXCSLGetIsItemRangedWeapon
* @return 
*/
int CSLItemGetIsRangedWeapon(object oItem)
{
    //return GetWeaponRanged(oItem); // doh !
	if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_RANGED )
		{
			return TRUE;
		}
	}
	return FALSE;
}


/**  
* Description
* @author
* @param 
* @see 
* @replaces CSLGetIsHeldWeaponRanged
* @return 
*/
int CSLGetIsHoldingRangedWeapon(object oTarget = OBJECT_SELF)
{
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_RANGED )
		{
			return TRUE;
		}
	}
	return FALSE;
}

/**  
* Returns TRUE if iBaseItemType is a projectile
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsAmmo( int iBaseItemType )
{
	if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_AMMO )
	{
		return TRUE;
	}
	return FALSE;
}


/**  
* Returns TRUE if oItem is a projectile
* @author
* @param 
* @see 
* @replaces IPGetIsProjectile CSLGetIsProjectile
* @return 
*/
int CSLItemGetIsAmmo(object oItem)
{
	if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_AMMO )
		{
			return TRUE;
		}
	}
	return FALSE;
}


/**  
* Used in polymerge
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetIsAShield( int iBaseItemType )
{	
	if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_SHIELD )
	{
		return TRUE;
	}
	return FALSE;
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXGetIsShield
* @return 
*/
int CSLItemGetIsShield(object oItem)
{
 	if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_SHIELD )
		{
			return TRUE;
		}
	}
	return FALSE;
}

/**  
* Is this armor or shield?
* @author
* @param 
* @see 
* @replaces XXXGetIsArmorOrShield
* @return 
*/
int CSLItemGetIsArmorOrShield(object oItem)
{
    int iType = GetBaseItemType(oItem);
	return ((iType == BASE_ITEM_ARMOR) || CSLItemGetIsShield(oItem));
}


/**  
* any item that can be equipped except armor and weapons
* @author
* @param 
* @see 
* @replaces XXXGetIsMiscEquippable
* @return 
*/
int CSLItemGetIsMiscEquippable(object oItem)
{
    if(GetIsObjectValid(oItem))
	{
		int iBaseItemType = GetBaseItemType(oItem);
		if ( iBaseItemType == BASE_ITEM_ARMOR )
		{
			return FALSE;
		}
		int iBaseItemProps = CSLGetBaseItemProps( iBaseItemType );
		
		if (  iBaseItemProps & ITEM_ATTRIB_WEAPON || iBaseItemProps & ITEM_ATTRIB_SHIELD || iBaseItemProps & ITEM_ATTRIB_AMMO )
		{
			return FALSE;
		}
		
		if (  iBaseItemProps & ITEM_ATTRIB_EQUIPPABLE )
		{
			return TRUE;
		}
	}
	return FALSE;
}    



/**  
* written by caos as part of dm inventory system, integrating
* @author
* @param 
* @see 
* @return 
*/
int CSLGetArmorType( object oArmor )
{
	// int GetArmorRulesType(object oItem);
	
	if (GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)
	{
		return ARMOR_INVALID; // -1
	}
	
	return GetArmorRulesType(oArmor);
}



/**  
* Returns the number of possible armor part variations for the specified part
* nPart - ITEM_APPR_ARMOR_MODEL_* constant
* Uses Get2DAstring, so do not use in loops
* @author
* @param 
* @see 
* @replaces XXXIPGetNumberOfArmorAppearances
* @return 
*/
int CSLGetNumberOfArmorAppearances(int nPart)
{
    int nRet;
    //SpeakString(Get2DAString(SC_IP_ARMORPARTS_2DA ,"NumParts",nPart));
    nRet = StringToInt(Get2DAString(SC_IP_ARMORPARTS_2DA ,"NumParts",nPart));
    return nRet;
}

/**  
* (private)
* Returns the previous or next armor appearance type, depending on the specified
* mode (SC_IP_ARMORTYPE_NEXT || SC_IP_ARMORTYPE_PREV)
* @author
* @param 
* @see 
* @replaces XXXIPGetArmorAppearanceType
* @return 
*/
int CSLGetArmorAppearanceType(object oArmor, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        SC_IP_ARMORTYPE_NEXT : sMode ="Next";
                    break;
        case        SC_IP_ARMORTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
    int nRet;

    if (nPart ==ITEM_APPR_ARMOR_MODEL_TORSO)
    {
        nRet = StringToInt(Get2DAString(SC_IP_ARMORAPPEARANCE_2DA ,sMode,nCurrApp));
        return nRet;
    }
    else
    {
        int nMax =  CSLGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
        int nMin =  1; // this prevents part 0 from being chosen (naked)

        // return a random valid armor tpze
        if (nMode == SC_IP_ARMORTYPE_RANDOM)
        {
            return Random(nMax)+nMin;
        }

        else
        {
            if (nMode == SC_IP_ARMORTYPE_NEXT)
            {
                // current appearance is max, return min
                if (nCurrApp == nMax)
                {
                    return nMin;
                }
                // current appearance is min, return max  -1
                else if (nCurrApp == nMin)
                {
                    nRet = nMin+1;
                    return nRet;
                }

                //SpeakString("next");
                // next
                nRet = nCurrApp +1;
                return nRet;
            }
            else                // previous
            {
                // current appearance is max, return nMax-1
                if (nCurrApp == nMax)
                {
                    nRet = nMax--;
                    return nRet;
                }
                // current appearance is min, return max
                else if (nCurrApp == nMin)
                {
                    return nMax;
                }

                //SpeakString("prev");

                nRet = nCurrApp -1;
                return nRet;
            }
        }

     }

}

/**  
* Returns the next valid appearance type for oArmor
* Uses Get2DAstring, so do not use in loops
* @author
* @param 
* @see 
* @replaces XXXIPGetNextArmorAppearanceType
* @return 
*/
int CSLGetNextArmorAppearanceType(object oArmor, int nPart)
{
    return CSLGetArmorAppearanceType(oArmor, nPart,  SC_IP_ARMORTYPE_NEXT );

}

/**  
* Returns the next valid appearance type for oArmor
* Uses Get2DAstring, so do not use in loops
* @author
* @param 
* @see 
* @replaces XXXIPGetPrevArmorAppearanceType
* @return 
*/
int CSLGetPrevArmorAppearanceType(object oArmor, int nPart)
{
    return CSLGetArmorAppearanceType(oArmor, nPart,  SC_IP_ARMORTYPE_PREV );
}

/**  
* Returns the next valid appearance type for oArmor
* Uses Get2DAstring, so do not use in loops
* @author
* @param 
* @see 
* @replaces XXXIPGetRandomArmorAppearanceType
* @return 
*/
int CSLGetRandomArmorAppearanceType(object oArmor, int nPart)
{
    return  CSLGetArmorAppearanceType(oArmor, nPart,  SC_IP_ARMORTYPE_RANDOM );
}

/**  
* Function to determine the size of the weapon being used by the creature
* @author
* @param 
* @see 
* @replaces CSLGetWeaponSize
* @return 
*/
int CSLItemGetWeaponSize(object oItem=OBJECT_SELF)
{
	if (GetObjectType(oItem)==OBJECT_TYPE_CREATURE)
	{
		oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oItem);
	}
	
	if(GetIsObjectValid(oItem))
	{
		int iBaseItemProps = CSLGetBaseItemProps(GetBaseItemType(oItem) );
		if ( iBaseItemProps & ITEM_ATTRIB_MEDIUM )
		{
			return WEAPON_SIZE_MEDIUM;
		}
		else if ( iBaseItemProps & ITEM_ATTRIB_SMALL )
		{
			return WEAPON_SIZE_SMALL;
		}
		else if ( iBaseItemProps & ITEM_ATTRIB_LARGE )
		{
			return WEAPON_SIZE_LARGE;
		}
		else if ( iBaseItemProps & ITEM_ATTRIB_TINY )
		{
			return WEAPON_SIZE_TINY;
		}
	}
	return WEAPON_SIZE_INVALID;
}


/**  
* Returns the range of a weapon's base item.
* - oPC: oPC's weapon currently be equipped in the target's right hand.
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
float CSLGetWeaponRange(object oPC)
{
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	float fRange;
	object oWeapon;

	if (!GetIsObjectValid(oRight))
	{
		object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
		object oClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
		object oCrWeapon = GetLastWeaponUsed(oPC);

		if (GetIsObjectValid(oBite))
		{
			oWeapon = oBite;
		}
		else if (GetIsObjectValid(oClaw))
		{
			oWeapon = oClaw;
		}
		else if (GetIsObjectValid(oCrWeapon))
		{
			oWeapon = oCrWeapon;
		}
		else oWeapon = OBJECT_INVALID;
	}
	else oWeapon = oRight;

	int nRow = GetBaseItemType(oWeapon);
	object oToB = CSLGetDataStore(oPC);
	
	if (GetLocalInt(oToB, "bot9s_PrefAttackDist") == 1)
	{
		fRange = GetLocalFloat(oToB, "override_PrefAttackDist");
	}
	else if (oWeapon == OBJECT_INVALID)
	{
		fRange = CSLGetGirth( oPC );
	}
	else
	{
		fRange = CSLGetItemDataPrefAttackDistance( nRow );
	}

	return fRange;
}



/**  
* Since calculations of distance start from the center of the creature to the
* edge of area it occupies, range is calculated by the girth the creature 
* takes up plus its weapon's range.
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
float CSLGetMeleeRange(object oCreature)
{
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
	object oWeapon;

	if (!GetIsObjectValid(oRight))
	{
		object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature);
		object oClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
		object oCrWeapon = GetLastWeaponUsed(oCreature);

		if (GetIsObjectValid(oBite))
		{
			oWeapon = oBite;
		}
		else if (GetIsObjectValid(oClaw))
		{
			oWeapon = oClaw;
		}
		else if (GetIsObjectValid(oCrWeapon))
		{
			oWeapon = oCrWeapon;
		}
		else oWeapon = OBJECT_INVALID;
	}
	else 
	{
		oWeapon = oRight;
	}
	
	int nWeapon = GetBaseItemType(oWeapon);
	float fWeapon;

	fWeapon = CSLGetItemDataPrefAttackDistance(nWeapon);

	if (fWeapon <= 0.0f)
	{
		fWeapon = FeetToMeters(5.0f);
	}
	
	float fRange = fWeapon + CSLGetGirth(oCreature);

	return fRange;
}





/**  
* Returns the AC bonus of oItem. If oItem has no AC bonus, this function 
* returns 0.
* This function was written by Elysius, modified by Mithdradates May 3, 2008
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetItemACBonus(object oItem)
{
    int nBonus = 0;
    int nPenalty = 0;
    itemproperty ip = GetFirstItemProperty(oItem);
	int nIPType, nThisValue;
    while (GetIsItemPropertyValid(ip))
    {
       	nIPType = GetItemPropertyType(ip);
        if (nIPType == ITEM_PROPERTY_AC_BONUS)
        {
            nThisValue = GetItemPropertyCostTableValue(ip);
            if (nThisValue > nBonus)
                nBonus = nThisValue;
        }
        else if (nIPType == ITEM_PROPERTY_DECREASED_AC)
        {
            nThisValue = GetItemPropertyCostTableValue(ip);
            if (nThisValue > nPenalty)
                nPenalty = nThisValue;
        }
        ip = GetNextItemProperty(oItem);
    }
    return nBonus - nPenalty;
}





/**  
* Function to determine whether a creature is using a two-handed weapon
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetIsHeldWeaponTwoHanded(object oCreature=OBJECT_SELF)
{
	object oWeapon;
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);

	if (oRight == OBJECT_INVALID)
	{
		object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature);
		object oRClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature);
		object oCrWeapon = GetLastWeaponUsed(oCreature);

		if (GetIsObjectValid(oBite))
		{
			oWeapon = oBite;
		}
		else if (GetIsObjectValid(oRClaw))
		{
			oWeapon = oRClaw;
		}
		else if (GetIsObjectValid(oCrWeapon))
		{
			oWeapon = oCrWeapon;
		}
		else
		{
			oWeapon = OBJECT_INVALID;
		}
	}
	else
	{
		oWeapon = oRight;
	}

	object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
	object oOffhand;

	if (oLeft == OBJECT_INVALID)
	{
		object oLClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);

		if (GetIsObjectValid(oLClaw))
		{
			oOffhand = oLClaw;
		}
		else
		{
			oOffhand = OBJECT_INVALID;
		}
	}
	else 
	{
		oOffhand = oLeft;
	}

	if ((GetHasFeat(FEAT_MONKEY_GRIP, oCreature) && GetIsObjectValid(oOffhand)))
	{
		return FALSE;
	}
	else if ( !GetIsObjectValid(oOffhand) && CSLItemGetIsLightWeapon(oWeapon, oCreature) && CSLItemGetWeaponSize(oCreature) >= GetCreatureSize(oCreature) )
	{
		return FALSE;
	}
	else if ( !GetIsObjectValid(oOffhand) && CSLItemGetWeaponSize(oCreature) >= GetCreatureSize(oCreature) )
	{
		return TRUE;
	}
	
	return FALSE;
}







/**  
* this corrects the creature items being returned which are missing in the vanilla version
* @author
* @param 
* @see 
* @replaces XXXIPGetTargetedOrEquippedMeleeWeapon
* @return 
*/
object CSLGetTargetedOrEquippedMeleeWeapon()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (CSLItemGetIsMeleeWeapon(oTarget))
    {
        return oTarget;
    }
    else
    {
        return OBJECT_INVALID;
    }

  }

  object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && CSLItemGetIsMeleeWeapon(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && CSLItemGetIsMeleeWeapon(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }  
  
  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }
  
  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }
  
  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
  if (GetIsObjectValid(oWeapon1) && GetBaseItemType(oWeapon1) == BASE_ITEM_GLOVES)
  {
    return oWeapon1;
  } 

  return OBJECT_INVALID;

}


/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXIPGetTargetedOrEquippedArmor
* @return 
*/
object CSLGetTargetedOrEquippedArmor(int bAllowShields = FALSE)
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (GetBaseItemType(oTarget) == BASE_ITEM_ARMOR)
    {
        return oTarget;
    }
    else
    {
        if ((bAllowShields) && (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD))
        {
            return oTarget;
        }
        else
        {
            return OBJECT_INVALID;
        }
    }

  }

  object oArmor1 = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
  if (GetIsObjectValid(oArmor1) && GetBaseItemType(oArmor1) == BASE_ITEM_ARMOR)
  {
    return oArmor1;
  }
  if (bAllowShields != FALSE)
  {
      oArmor1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
      if (GetIsObjectValid(oArmor1) && (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD))
      {
        return oArmor1;
      }
    }



  return OBJECT_INVALID;

}

int CSLMatchSingleHandedWeapon(object oItem)
{
    switch (GetBaseItemType(oItem)) {
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_WHIP:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_WARHAMMER: 
		case BASE_ITEM_TRAINING_CLUB:
		case BASE_ITEM_ALLUSE_SWORD:
			return TRUE;
        	break;

        default: break;
     }
     return FALSE;
}

// TRUE if the item is a double-handed weapon
int CSLMatchDoubleHandedWeapon(object oItem)
{
    switch (GetBaseItemType(oItem)) 
	{
		case BASE_ITEM_WARMACE:
	    case BASE_ITEM_DIREMACE:
	    case BASE_ITEM_DOUBLEAXE:
	    case BASE_ITEM_GREATAXE:
	    case BASE_ITEM_GREATSWORD:
	    case BASE_ITEM_HALBERD:
	    case BASE_ITEM_MAGICSTAFF:
	    case BASE_ITEM_QUARTERSTAFF:
	    case BASE_ITEM_TWOBLADEDSWORD:
		case BASE_ITEM_SPEAR:
		case BASE_ITEM_FALCHION:
		case BASE_ITEM_GREATCLUB: 
		case BASE_ITEM_CGIANT_AXE:
		case BASE_ITEM_CGIANT_SWORD:
		case BASE_ITEM_SCYTHE:
        	return TRUE;
    }
    return FALSE;
}








int CSLGetMeleeWeaponSize(object oItem)
{
    if (GetWeaponRanged(oItem) || (GetWeaponType(oItem) == WEAPON_TYPE_NONE))
    {
        return 0;
    }
    int nBase = GetBaseItemType(oItem);
    string sWeaponSizeStr = "HENCH_AI_WEAPON_SIZE_" + IntToString(nBase);
    object oModule = GetModule();
    int iWeaponSize = GetLocalInt(oModule, sWeaponSizeStr);
    if (iWeaponSize == 0)
    {
        iWeaponSize = StringToInt(Get2DAString("baseitems", "WeaponSize", nBase));
        if (iWeaponSize == 0)
        {
            iWeaponSize = -1;
        }
        SetLocalInt(oModule, sWeaponSizeStr, iWeaponSize);
    }
    if (iWeaponSize > 0)
    {
        return iWeaponSize;
    }
    return 0;
}



/**  
* Returns TRUE if oItem has any item property that classifies it as magical item
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetIsMagicalItem(object oItem)
{
	if((GetItemHasItemProperty(oItem, ITEM_PROPERTY_ABILITY_BONUS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_FEAT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_REDUCTION)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_RESISTANCE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_VULNERABILITY)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ABILITY_SCORE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_AC)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_DAMAGE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_HOLY_AVENGER)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_KEEN)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_LIGHT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_MASSIVE_CRITICALS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIGHTY)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIND_BLANK)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_MONSTER_DAMAGE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_NO_DAMAGE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_HIT_PROPERTIES)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_MONSTER_HIT)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_POISON)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION_VAMPIRIC)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_SKILL_BONUS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_SPELL_RESISTANCE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_THIEVES_TOOLS)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRAP)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRUE_SEEING)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_TURN_RESISTANCE)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_UNLIMITED_AMMUNITION)) ||
		(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL))
		)
	{
			return TRUE;
	}
	return FALSE;
}



//Functions

/**  
* Returns the damage type of oWeapon as one of the DAMAGE_TYPE_* constants.
* WEAPON_TYPE_PIERCING_AND_SLASHING is returned as DAMAGE_TYPE_PIERCING.
* OBJECT_INVALID is returned as DAMAGE_TYPE_BLUDGEONING.
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetWeaponDamageType(object oWeapon)
{
	int nWeapon = GetWeaponType(oWeapon);
	int nDamageType;

	if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
	{
		nDamageType = DAMAGE_TYPE_PIERCING;
	}
	else if (nWeapon == WEAPON_TYPE_SLASHING)
	{
		nDamageType = DAMAGE_TYPE_SLASHING;
	}
	else nDamageType = DAMAGE_TYPE_BLUDGEONING;

	return nDamageType;
}




//@} ****************************************************************************************************

/********************************************************************************************************/
/** @name Item Appearance Functions
* Think most of these don't work and are based on NWN1 functions, need to rework for NWN2
********************************************************************************************************* @{ */



// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
/**  
* Returns a new armor based of oArmor with nPartModified
* nPart - ITEM_APPR_ARMOR_MODEL_* constant of the part to be changed
* nMode -
*          SC_IP_ARMORTYPE_NEXT    - next valid appearance
*          SC_IP_ARMORTYPE_PREV    - previous valid apperance;
*          SC_IP_ARMORTYPE_RANDOM  - random valid appearance (torso is never changed);
* bDestroyOldOnSuccess - Destroy oArmor in process?
* Uses Get2DAstring, so do not use in loops
* @author
* @param 
* @see 
* @replaces XXXIPGetModifiedArmor
* @return 
*/
/*
object CSLGetModifiedArmor(object oArmor, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp = CSLGetArmorAppearanceType(oArmor, nPart,  nMode );
    //SpeakString("old: " + IntToString(GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));

    object oNew = CopyItemAndModify(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL, nPart, nNewApp,TRUE);

    if (oNew != OBJECT_INVALID)
    {
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oArmor);
        }
        return oNew;
    }
    // Safety fallback, return old armor on failures
       return oArmor;
}
*/


/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXIPGetWeaponAppearanceType
* @private
* @return 
*/
/*
int CSLGetWeaponAppearanceType(object oWeapon, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        SC_IP_WEAPONTYPE_NEXT : sMode ="Next";
                    break;
        case        SC_IP_WEAPONTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,nPart);
    int nRet;

    int nMax =  9;// CSLGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
    int nMin =  1;

    // return a random valid armor tpze
    if (nMode == SC_IP_WEAPONTYPE_RANDOM)
    {
        return Random(nMax)+nMin;
    }

    else
    {
        if (nMode == SC_IP_WEAPONTYPE_NEXT)
        {
            // current appearance is max, return min
            if (nCurrApp == nMax)
            {
                return nMax;
            }
            // current appearance is min, return max  -1
            else if (nCurrApp == nMin)
            {
                nRet = nMin +1;
                return nRet;
            }

            //SpeakString("next");
            // next
            nRet = nCurrApp +1;
            return nRet;
        }
        else                // previous
        {
            // current appearance is max, return nMax-1
            if (nCurrApp == nMax)
            {
                nRet = nMax--;
                return nRet;
            }
            // current appearance is min, return max
            else if (nCurrApp == nMin)
            {
                return nMin;
            }

            //SpeakString("prev");

            nRet = nCurrApp -1;
            return nRet;
        }


     }
}
*/

/**  
* Returns a new armor based of oArmor with nPartModified
* nPart - ITEM_APPR_WEAPON_MODEL_* constant of the part to be changed
* nMode -
*          SC_IP_WEAPONTYPE_NEXT    - next valid appearance
*          SC_IP_WEAPONTYPE_PREV    - previous valid apperance;
*          SC_IP_WEAPONTYPE_RANDOM  - random valid appearance (torso is never changed);
* bDestroyOldOnSuccess - Destroy oArmor in process?
* Uses Get2DAstring, so do not use in loops

* @author
* @param 
* @see 
* @replaces XXXIPGetModifiedWeapon
* @return 
*/
/*
object CSLGetModifiedWeapon(object oWeapon, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp = CSLGetWeaponAppearanceType(oWeapon, nPart,  nMode );
    //SpeakString("old: " + IntToString(GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));
    object oNew = CopyItemAndModify(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL, nPart, nNewApp,TRUE);
    if (oNew != OBJECT_INVALID)
    {
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oWeapon);
        }
        return oNew;
    }
    // Safety fallback, return old weapon on failures
       return oWeapon;
}
*/


/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXIPCreateAndModifyArmorRobe
* @return 
*/
/*
object CSLCreateAndModifyArmorRobe(object oArmor, int nRobeType)
{
    object oRet = CopyItemAndModify(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_ROBE,nRobeType+2,TRUE);
    if (GetIsObjectValid(oRet))
    {
        return oRet;
    }
    else // safety net
    {
        return oArmor;
    }
}
*/




/**  
* Changes the color of an item armor
* oItem        - The armor
* nColorType   - ITEM_APPR_ARMOR_COLOR_* constant
* nColor       - color from 0 to 63
* Since oItem is destroyed in the process, the function returns
* the item created with the color changed
* @author
* @param 
* @see 
* @replaces XXXIPDyeArmor
* @return 
*/
/*
object CSLDyeArmor(object oItem, int nColorType, int nColor)
{
        object oRet = CopyItemAndModify(oItem,ITEM_APPR_TYPE_ARMOR_COLOR,nColorType,nColor,TRUE);
        DestroyObject(oItem); // remove old item
        return oRet; //return new item
}
*/

//@} ****************************************************************************************************




/********************************************************************************************************/
/** @name Item Property Functions
* Description
********************************************************************************************************* @{ */

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
string CSLGetItemIconImage(object oItem)
{ 
	string sIcon = Get2DAString("nwn2_icons", "ICON", GetItemIcon(oItem)); 
	if ( sIcon == "" || sIcon == "temp0.tga" )
	{
		int iBaseItemType = GetBaseItemType(oItem);
		int iSubBaseItemType = iBaseItemType / 10;
		switch(iSubBaseItemType)
		{
			case 0:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_SHORTSWORD: { return "it_wb_ssword00.tga";} // 0
					case BASE_ITEM_LONGSWORD: { return "it_wb_lsword00.tga";} // 1
					case BASE_ITEM_BATTLEAXE: { return "it_wa_battleaxe00.tga";} // 2
					case BASE_ITEM_BASTARDSWORD: { return "it_wb_bsword00.tga";} // 3
					case BASE_ITEM_LIGHTFLAIL: { return "it_wu_flail00.tga";} // 4
					case BASE_ITEM_WARHAMMER: { return "it_wu_whammer00.tga";} // 5
					case BASE_ITEM_HEAVYCROSSBOW: { return "it_wr_hxbow00.tga";} // 6
					case BASE_ITEM_LIGHTCROSSBOW: { return "it_wr_lxbow00.tga";} // 7
					case BASE_ITEM_LONGBOW: { return "it_wr_longbow00.tga";} // 8
					case BASE_ITEM_LIGHTMACE: { return "it_wu_mace00.tga";} // 9
				}
				break;
			case 1:
				switch ( iBaseItemType )
				{
					
					case BASE_ITEM_HALBERD: { return "it_wp_halberd00.tga";} // 10
					case BASE_ITEM_SHORTBOW: { return "it_wr_shortbow00.tga";} // 11
					case BASE_ITEM_TWOBLADEDSWORD: { return "temp0.tga";} // 12
					case BASE_ITEM_GREATSWORD: { return "it_wb_gsword00.tga";} //13
					case BASE_ITEM_SMALLSHIELD: { return "it_as_light00.tga";} //14
					case BASE_ITEM_TORCH: { return "temp0.tga";} //15
					case BASE_ITEM_ARMOR: { return "it_al_leather00.tga";} //16
					case BASE_ITEM_HELMET: { return "temp0.tga";} //17
					case BASE_ITEM_GREATAXE: { return "it_wa_greataxe00.tga";} //18
					case BASE_ITEM_AMULET: { return "temp0.tga";} //19
				}
				break;
			case 2:
				switch ( iBaseItemType )
				{
					
					case BASE_ITEM_ARROW: { return "it_wo_arrow00.tga";} //20
					case BASE_ITEM_BELT: { return "it_be_belt00.tga";} //21
					case BASE_ITEM_DAGGER: { return "it_wb_dagger00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_TINY  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_INTUITIVEATTACK | ITEM_ATTRIB_SHADOWHAND;} //22
					case BASE_ITEM_MISCSMALL: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //24
					case BASE_ITEM_BOLT: { return "it_wo_bolt00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_AMMO;} //25
					case BASE_ITEM_BOOTS: { return "temp0.tga";} // { return ITEM_ATTRIB_EQUIPPABLE;} //26
					case BASE_ITEM_BULLET: { return "it_wo_bullet00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_AMMO;} //27
					case BASE_ITEM_CLUB: { return "it_wu_club00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_INTUITIVEATTACK;} //28
					case BASE_ITEM_MISCMEDIUM: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //29
				}
				break;
			case 3:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_DART: { return "it_wo_dart00.tga";} // { return  ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_THROWN | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_TINY | ITEM_ATTRIB_INTUITIVEATTACK;} //31
					case BASE_ITEM_DIREMACE: { return "it_wu_dmace00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_LARGE;} //32
					case BASE_ITEM_DOUBLEAXE: { return "temp0.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE;} //33
					case BASE_ITEM_MISCLARGE: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //34
					case BASE_ITEM_HEAVYFLAIL: { return "temp0.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE;} //35
					case BASE_ITEM_GLOVES: { return "it_gl_glove00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE;} //36
					case BASE_ITEM_LIGHTHAMMER: { return "it_wu_lhammer00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_LIGHTWEAPON;} //37
					case BASE_ITEM_HANDAXE: { return "it_wa_handaxe00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //38
					case BASE_ITEM_HEALERSKIT: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //39
				}
				break;
			case 4:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_KAMA: { return "it_we_kama00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //40
					case BASE_ITEM_KATANA: { return "it_wb_katana00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_DIAMONDMIND;} //41
					case BASE_ITEM_KUKRI: { return "it_we_kukri00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_TINY  | ITEM_ATTRIB_LIGHTWEAPON  | ITEM_ATTRIB_TIGERCLAW;} //42
					case BASE_ITEM_MISCTALL: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //43
					case BASE_ITEM_MAGICROD: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //44
					case BASE_ITEM_MAGICSTAFF: { return "temp0.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM;} //45
					case BASE_ITEM_MAGICWAND: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //46
					case BASE_ITEM_MORNINGSTAR: { return "it_wu_mstar00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_INTUITIVEATTACK;} //47
					case BASE_ITEM_POTIONS: { return "temp0.tga";} // { return ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL;} //49
				}
				break;
			case 5:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_QUARTERSTAFF: { return "it_wd_qstaff00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_LARGE | ITEM_ATTRIB_INTUITIVEATTACK  | ITEM_ATTRIB_SETTINGSUN;} //50
					case BASE_ITEM_RAPIER: { return "it_wb_rapier00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_ELEGANTSTRIKE | ITEM_ATTRIB_DIAMONDMIND;} //51
					case BASE_ITEM_RING: { return "it_ring_copplain.tga";} // { return ITEM_ATTRIB_EQUIPPABLE;} //52
					case BASE_ITEM_SCIMITAR: { return "it_wb_scimitar00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_ELEGANTSTRIKE | ITEM_ATTRIB_DESERTWIND;} //53
					case BASE_ITEM_SCROLL: { return "it_genericscroll.tga";} // { return ITEM_ATTRIB_NONE;} //54
					case BASE_ITEM_SCYTHE: { return "it_wp_scythe00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE  | ITEM_ATTRIB_SHADOWHAND;} //55
					case BASE_ITEM_LARGESHIELD: { return "temp0.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_SHIELD;} //56
					case BASE_ITEM_TOWERSHIELD: { return "it_as_tower00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_SHIELD;} //57
					case BASE_ITEM_SHORTSPEAR: { return "it_wp_spear00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_LARGE;} //58
					case BASE_ITEM_SHURIKEN: { return "it_wt_shuriken00.tga";} // { return  ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_THROWN | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_TINY  | ITEM_ATTRIB_SHADOWHAND;} //59
				}
				break;
			case 6:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_SICKLE: { return "it_we_sickle00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_INTUITIVEATTACK | ITEM_ATTRIB_DIAMONDMIND;} //60
					case BASE_ITEM_SLING: { return "it_wr_sling00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_INTUITIVEATTACK | ITEM_ATTRIB_SETTINGSUN;} //61
					case BASE_ITEM_THIEVESTOOLS: { return "it_kit_lockpicks.tga";} // { return ITEM_ATTRIB_NONE;} //62
					case BASE_ITEM_THROWINGAXE: { return "it_wt_taxe00.tga";} // { return  ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_RANGED | ITEM_ATTRIB_THROWN | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_TINY  | ITEM_ATTRIB_LIGHTWEAPON;} //63
					case BASE_ITEM_TRAPKIT: { return "it_kit_spiketrap.tga";} // { return ITEM_ATTRIB_NONE;} //64
					case BASE_ITEM_KEY: { return "it_key_wood.tga";} // { return ITEM_ATTRIB_NONE;} //65
					case BASE_ITEM_LARGEBOX: { return "it_qi_tithebox.tga";} // { return ITEM_ATTRIB_CONTAINER;} //66
					case BASE_ITEM_MISCWIDE: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //68
					case BASE_ITEM_CSLASHWEAPON: { return "i_bite..tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //69
				}
				break;
			case 7:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_CPIERCWEAPON: { return "i_claw..tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //70
					case BASE_ITEM_CBLUDGWEAPON: { return "i_claw..tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //71
					case BASE_ITEM_CSLSHPRCWEAP: { return "i_claw..tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM  | ITEM_ATTRIB_LIGHTWEAPON | ITEM_ATTRIB_TIGERCLAW;} //72
					case BASE_ITEM_CREATUREITEM: { return "i_hide.tga";} // { return ITEM_ATTRIB_NONE;} //73
					case BASE_ITEM_BOOK: { return "it_plainbook01.tga";} // { return ITEM_ATTRIB_NONE;} //74
					case BASE_ITEM_SPELLSCROLL: { return "it_genericscroll.tga";} // { return ITEM_ATTRIB_NONE;} //75
					case BASE_ITEM_GOLD: { return "it_gold.tga";} // { return ITEM_ATTRIB_NONE;} //76
					case BASE_ITEM_GEM: { return "it_gem01.tga";} // { return ITEM_ATTRIB_NONE;} //77
					case BASE_ITEM_BRACER: { return "it_br_bracer00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE;} //78
					case BASE_ITEM_MISCTHIN: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //79
				}
				break;
			case 8:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_CLOAK: { return "it_ck_cloak00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE;} //80
					case BASE_ITEM_GRENADE: { return "it_wt_firegrenade.tga";} // { return ITEM_ATTRIB_NONE;} //81
					case BASE_ITEM_BALORSWORD: { return "it_wb_gsword00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM;} //82
					case BASE_ITEM_BALORFALCHION: { return "it_m_falchion.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM;} //83
				}
				break;
			case 10:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_BLANK_POTION: { return "it_emptypotionoval.tga";} // { return ITEM_ATTRIB_NONE;} //101
					case BASE_ITEM_BLANK_SCROLL: { return "it_blankscroll.tga";} // { return ITEM_ATTRIB_NONE;} //102
					case BASE_ITEM_BLANK_WAND: { return "it_wm_wandmagicmis.tga";} // { return ITEM_ATTRIB_NONE;} //103
					case BASE_ITEM_ENCHANTED_POTION: { return "it_healpotion.tga";} // { return ITEM_ATTRIB_NONE;} //104
					case BASE_ITEM_ENCHANTED_SCROLL: { return "it_genericscroll.tga";} // { return ITEM_ATTRIB_NONE;} //105
					case BASE_ITEM_ENCHANTED_WAND: { return "it_wm_wandmagicmis.tga";} // { return ITEM_ATTRIB_NONE;} //106
					case BASE_ITEM_DWARVENWARAXE: { return "it_wa_dwarfaxe00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_MEDIUM | ITEM_ATTRIB_IRONHEART;} //108
					case BASE_ITEM_CRAFTMATERIALMED: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //109
				}
				break;	
			case 11:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_CRAFTMATERIALSML: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //110
					case BASE_ITEM_WHIP: { return "temp0.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_LIGHTWEAPON;} //111
					case BASE_ITEM_CRAFTBASE: { return "temp0.tga";} // { return ITEM_ATTRIB_NONE;} //112
					case BASE_ITEM_MACE: { return "it_wu_mace00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_BLUDGEONING | ITEM_ATTRIB_SMALL | ITEM_ATTRIB_DESERTWIND;} //113
					case BASE_ITEM_FALCHION: { return "it_m_falchion.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_SLASHING | ITEM_ATTRIB_LARGE | ITEM_ATTRIB_DEVOTEDSPIRIT | ITEM_ATTRIB_DESERTWIND;} //114
					case BASE_ITEM_FLAIL: { return "it_wu_hflail00.tga";} // { return ITEM_ATTRIB_EQUIPPABLE | ITEM_ATTRIB_WEAPON | ITEM_ATTRIB_MELEE | ITEM_ATTRIB_PIERCING | ITEM_ATTRIB_SMALL  | ITEM_ATTRIB_IRONHEART;} //116
					case BASE_ITEM_SPEAR: { return "it_wp_spear00.tga";} //119
				}
				break;
			case 12:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_GREATCLUB: { return "it_wu_club00.tga";} //120
					case BASE_ITEM_TRAINING_CLUB: { return "it_qi_trainingclub.tga";} //124
					case BASE_ITEM_SOFTBUNDLE: { return "temp0.tga";} //125
					case BASE_ITEM_WARMACE: { return "it_wu_mace00.tga";} //126
					case BASE_ITEM_STEIN: { return "temp0.tga";} //127
					case BASE_ITEM_DRUM: { return "it_u_drum01.tga";} //128
					case BASE_ITEM_FLUTE: { return "it_u_flute01.tga";} //129
				}
				break;
			case 13:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_INK_WELL: { return "temp0.tga";} //130
					case BASE_ITEM_LOOTBAG: { return "it_qi_blacksilkbag.tga";} //131
					case BASE_ITEM_MANDOLIN: { return "it_u_mandolincan.tga";} //132
					case BASE_ITEM_PAN: { return "temp0.tga";} //133
					case BASE_ITEM_POT: { return "temp0.tga";} //134
					case BASE_ITEM_RAKE: { return "temp0.tga";} //135
					case BASE_ITEM_SHOVEL: { return "temp0.tga";} //136
					case BASE_ITEM_SMITHYHAMMER: { return "it_smithhammer.tga";} //137
					case BASE_ITEM_SPOON: { return "temp0.tga";} //138
					case BASE_ITEM_BOTTLE: { return "temp0.tga";} //139
				}
				break;
			case 14:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_CGIANT_SWORD: { return "it_wb_gsword00.tga";} //140
					case BASE_ITEM_CGIANT_AXE: { return "it_wa_greataxe00.tga";} //141
					case BASE_ITEM_ALLUSE_SWORD: { return "temp0.tga";} //142
					case BASE_ITEM_MISCSTACK: { return "temp0.tga";} //143
					case BASE_ITEM_BOUNTYITEM: { return "temp0.tga";} //144
					case BASE_ITEM_RECIPE: { return "temp0.tga";} //145
					case BASE_ITEM_INCANTATION: { return "temp0.tga";} //146
				}
				break;
			case 24: // @todo replace these below with above attributes, wait until the above are tested soas to prevent issues where these don't have same values as above
				switch ( iBaseItemType )
				{
					case BASE_ITEM_SHORTSWORD_R: { return "it_wb_ssword00.tga";} //241
					case BASE_ITEM_LONGSWORD_R: { return "it_wb_lsword00.tga";} //242
					case BASE_ITEM_BATTLEAXE_R: { return "it_wa_battleaxe00.tga";} //243
					case BASE_ITEM_BASTARDSWORD_R: { return "it_wb_bsword00.tga";} //244
					case BASE_ITEM_LIGHTFLAIL_R: { return "it_wu_flail00.tga";} //245
					case BASE_ITEM_WARHAMMER_R: { return "it_wu_whammer00.tga";} //246
					case BASE_ITEM_MACE_R: { return "it_wu_mace00.tga";} //247
					case BASE_ITEM_HALBERD_R: { return "it_wp_halberd00.tga";} //248
					case BASE_ITEM_GREATSWORD_R: { return "it_wb_gsword00.tga";} //249
				}
				break;
			case 25:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_GREATAXE_R: { return "it_wa_greataxe00.tga";} //250
					case BASE_ITEM_DAGGER_R: { return "it_wb_dagger00.tga";} //251
					case BASE_ITEM_CLUB_R: { return "it_wu_club00.tga";} //252
					case BASE_ITEM_LIGHTHAMMER_R: { return "it_wu_lhammer00.tga";} //253
					case BASE_ITEM_HANDAXE_R: { return "it_wa_handaxe00.tga";} //254
					case BASE_ITEM_KAMA_R: { return "it_we_kama00.tga";} //255
					case BASE_ITEM_KATANA_R: { return "it_wb_katana00.tga";} //256
					case BASE_ITEM_KUKRI_R: { return "it_we_kukri00.tga";} //257
					case BASE_ITEM_MAGICSTAFF_R: { return "temp0.tga";} //258
					case BASE_ITEM_MORNINGSTAR_R: { return "it_wu_mstar00.tga";} //259
				}
				break;
			case 26:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_QUARTERSTAFF_R: { return "it_wd_qstaff00.tga";} //260
					case BASE_ITEM_RAPIER_R: { return "it_wb_rapier00.tga";} //261
					case BASE_ITEM_SCIMITAR_R: { return "it_wb_scimitar00.tga";} //262
					case BASE_ITEM_SCYTHE_R: { return "it_wp_scythe00.tga";} //263
					case BASE_ITEM_SICKLE_R: { return "it_we_sickle00.tga";} //264
					case BASE_ITEM_DWARVENWARAXE_R: { return "it_wa_dwarfaxe00.tga";} //265
					case BASE_ITEM_WHIP_R: { return "temp0.tga";} //266
					case BASE_ITEM_FALCHION_R: { return "it_m_falchion.tga";} //267
					case BASE_ITEM_FLAIL_R: { return "it_wu_flail00.tga";} //268
					case BASE_ITEM_SPEAR_R: { return "it_wp_spear00.tga";} //269
				}
				break;
			case 27:
				switch ( iBaseItemType )
				{
					case BASE_ITEM_GREATCLUB_R: { return "it_wu_club00.tga";} //270
					case BASE_ITEM_TRAINING_CLUB_R: { return "it_qi_trainingclub.tga";} //271
					case BASE_ITEM_WARMACE_R: { return "it_wu_mace00.tga";} //272
				}
				break;

		}
		return "temp0.tga";
	}
	
	return sIcon + ".tga";
	
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces SCGetItemLevel
* @return 
*/
int CSLGetItemLevel(int iValue)
{
   if (iValue <=1000   ) { return 1 ; }
   if (iValue <=1500   ) { return 2 ; }
   if (iValue <=2500   ) { return 3 ; }
   if (iValue <=3500   ) { return 4 ; }
   if (iValue <=5000   ) { return 5 ; }
   if (iValue <=6500   ) { return 6 ; }
   if (iValue <=9000   ) { return 7 ; }
   if (iValue <=12000  ) { return 8 ; }
   if (iValue <=15000  ) { return 9 ; }
   if (iValue <=19500  ) { return 10; }
   if (iValue <=25000  ) { return 11; }
   if (iValue <=30000  ) { return 12; }
   if (iValue <=35000  ) { return 13; }
   if (iValue <=40000  ) { return 14; }
   if (iValue <=50000  ) { return 15; }
   if (iValue <=65000  ) { return 16; }
   if (iValue <=75000  ) { return 17; }
   if (iValue <=90000  ) { return 18; }
   if (iValue <=110000 ) { return 19; }
   if (iValue <=130000 ) { return 20; }
   if (iValue <=250000 ) { return 21; }
   if (iValue <=1000000) { return 22 + (iValue - 250001) / 250000; }
   else { return 25 + (iValue - 1000001) / 200000; }
}


/**  
* Returns an itemproperty from an item based on a desired itemproperty constant.
* nSubType by default ignores subtypes until a constant is entered as its value.
* @author
* @param 
* @see 
* @replaces XXXGetItemPropertyByConst
* @return 
*/
itemproperty CSLGetItemPropertyByConst(int nItemProp, object oItem, int nSubType = -1)
{
	itemproperty iNull = ItemPropertyNoDamage();
    itemproperty ip = GetFirstItemProperty(oItem);
	int nSub = GetItemPropertySubType(ip);
	
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == nItemProp)
        {
			if (nSubType == -1 || nSub == nSubType)
			{
            	return ip;
			}
        }
        ip = GetNextItemProperty(oItem);
		nSub = GetItemPropertySubType(ip);
    }
    return iNull; //47, No combat damage property.
}




/**  
* Returns the integer value of nSubType if it matches the subtype of the test item.
* @author
* @param 
* @see 
* @replaces XXXGetItemPropertySubTypeByConst
* @return 
*/
int CSLGetItemPropertySubTypeByConst(int nItemProp, object oItem, int nSubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);
	int nSub = GetItemPropertySubType(ip);
	
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == nItemProp)
        {
			if (nSubType == -1 || nSub == nSubType)
			{
            	return nSubType;
			}
        }
        ip = GetNextItemProperty(oItem);
		nSub = GetItemPropertySubType(ip);
    }
    return -1; // Nothing should have this subtype.
}

/*
Not used anywhere, delete it eventually
// Returns a constant from an item based on a desired itemproperty constant.
// nSubType by default ignores subtypes until a constant is entered as its value.
int GetItemPropertyConst(itemproperty ip, int nItemProp, object oItem, int nSubType = -1)
{
	int nSub = GetItemPropertySubType(ip);
	
	if (GetItemPropertyType(ip) == nItemProp)
	{
		if (nSubType == -1 || nSub == nSubType)
		{
           	return nItemProp;
		}
	}
    return -1;
}
*/

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLItemPropTypeToString(int nProp)
{
	switch (nProp)
	{
		case ITEM_PROPERTY_ABILITY_BONUS:						return "Ability Bonus"; // 0
		case ITEM_PROPERTY_AC_BONUS:							return "Ac Bonus"; // 1
		case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:			return "Ac Bonus Vs Alignment Group"; // 2
		case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:				return "Ac Bonus Vs Damage Type"; // 3
		case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:			return "Ac Bonus Vs Racial Group"; // 4
		case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:		return "Ac Bonus Vs Specific Alignment"; // 5
		case ITEM_PROPERTY_ENHANCEMENT_BONUS:					return "Enhancement Bonus"; // 6
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP: return "Enhancement Bonus Vs Alignment Group"; // 7
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:	return "Enhancement Bonus Vs Racial Group"; // 8
		case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT: return "Enhancement Bonus Vs Specific Alignement"; // 9
		case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:		return "Decreased Enhancement Modifier"; // 10
		case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:			return "Base Item Weight Reduction"; // 11
		case ITEM_PROPERTY_BONUS_FEAT:							return "Bonus Feat"; // 12
		case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:			return "Bonus Spell Slot Of Level N"; // 13
		case ITEM_PROPERTY_CAST_SPELL:							return "Cast Spell"; // 15
		case ITEM_PROPERTY_DAMAGE_BONUS:						return "Damage Bonus"; // 16
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:		return "Damage Bonus Vs Alignment Group"; // 17
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:		return "Damage Bonus Vs Racial Group"; // 18
		case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:	return "Damage Bonus Vs Specific Alignment"; // 19
		case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:				return "Immunity Damage Type"; // 20
		case ITEM_PROPERTY_DECREASED_DAMAGE:					return "Decreased Damage"; // 21
		case ITEM_PROPERTY_DAMAGE_REDUCTION_DEPRECATED:			return "Damage Reduction Deprecated"; // 22
		case ITEM_PROPERTY_DAMAGE_RESISTANCE:					return "Damage Resistance"; // 23
		case ITEM_PROPERTY_DAMAGE_VULNERABILITY:				return "Damage Vulnerability"; // 24
		case ITEM_PROPERTY_DARKVISION:							return "Darkvision"; // 26
		case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:				return "Decreased Ability Score"; // 27
		case ITEM_PROPERTY_DECREASED_AC:						return "Decreased Ac"; // 28
		case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:			return "Decreased Skill Modifier"; // 29
		case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:	return "Enhanced Container Reduced Weight"; // 32
		case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:				return "Extra Melee Damage Type"; // 33
		case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:			return "Extra Ranged Damage Type"; // 34
		case ITEM_PROPERTY_HASTE:								return "Haste"; // 35
		case ITEM_PROPERTY_HOLY_AVENGER:						return "Holy Avenger"; // 36
		case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:				return "Immunity Miscellaneous"; // 37
		case ITEM_PROPERTY_IMPROVED_EVASION:					return "Improved Evasion"; // 38
		case ITEM_PROPERTY_SPELL_RESISTANCE:					return "Spell Resistance"; // 39
		case ITEM_PROPERTY_SAVING_THROW_BONUS:					return "Saving Throw Bonus"; // 40
		case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:			return "Saving Throw Bonus Specific"; // 41
		case ITEM_PROPERTY_KEEN:								return "Keen"; // 43
		case ITEM_PROPERTY_LIGHT:								return "Light"; // 44
		case ITEM_PROPERTY_MIGHTY:								return "Mighty"; // 45
		case ITEM_PROPERTY_MIND_BLANK:							return "Mind Blank"; // 46
		case ITEM_PROPERTY_NO_DAMAGE:							return "No Damage"; // 47
		case ITEM_PROPERTY_ON_HIT_PROPERTIES:					return "On Hit Properties"; // 48
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS:				return "Decreased Saving Throws"; // 48
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:	return "Decreased Saving Throws Specific"; // 50
		case ITEM_PROPERTY_REGENERATION:						return "Regeneration"; // 51
		case ITEM_PROPERTY_SKILL_BONUS:							return "Skill Bonus"; // 52
		case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:				return "Immunity Specific Spell"; // 53
		case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:				return "Immunity Spell School"; // 54
		case ITEM_PROPERTY_THIEVES_TOOLS:						return "Thieves Tools"; // 55
		case ITEM_PROPERTY_ATTACK_BONUS:						return "Attack Bonus"; // 56
		case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:		return "Attack Bonus Vs Alignment Group"; // 57
		case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:		return "Attack Bonus Vs Racial Group"; // 58
		case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:	return "Attack Bonus Vs Specific Alignment"; // 59
		case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:			return "Decreased Attack Modifier"; // 60
		case ITEM_PROPERTY_UNLIMITED_AMMUNITION:				return "Unlimited Ammunition"; // 61
		case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:		return "Use Limitation Alignment Group"; // 62
		case ITEM_PROPERTY_USE_LIMITATION_CLASS:				return "Use Limitation Class"; // 63
		case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:			return "Use Limitation Racial Type"; // 64
		case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:	return "Use Limitation Specific Alignment"; // 65
		case ITEM_PROPERTY_BONUS_HITPOINTS:						return "Bonus Hitpoints"; // 66
		case ITEM_PROPERTY_REGENERATION_VAMPIRIC:				return "Regeneration Vampiric"; // 67
		case ITEM_PROPERTY_TRAP:								return "Trap"; // 70
		case ITEM_PROPERTY_TRUE_SEEING:							return "True Seeing"; // 71
		case ITEM_PROPERTY_ON_MONSTER_HIT:						return "On Monster Hit"; // 72
		case ITEM_PROPERTY_TURN_RESISTANCE:						return "Turn Resistance"; // 73
		case ITEM_PROPERTY_MASSIVE_CRITICALS:					return "Massive Criticals"; // 74
		case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:					return "Freedom Of Movement"; // 75
		case ITEM_PROPERTY_POISON:								return "Poison"; // 76
		case ITEM_PROPERTY_MONSTER_DAMAGE:						return "Monster Damage"; // 77
		case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:			return "Immunity Spells By Level"; // 78
		case ITEM_PROPERTY_SPECIAL_WALK:						return "Special Walk"; // 79
		case ITEM_PROPERTY_HEALERS_KIT:							return "Healers Kit"; // 80
		case ITEM_PROPERTY_WEIGHT_INCREASE:						return "Weight Increase"; // 81
		case ITEM_PROPERTY_ONHITCASTSPELL:						return "Onhitcastspell"; // 82
		case ITEM_PROPERTY_VISUALEFFECT:						return "Visualeffect"; // 83
		case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:				return "Arcane Spell Failure"; // 84
		case ITEM_PROPERTY_DAMAGE_REDUCTION:					return "Damage Reduction"; // 90
	}
	return "MissIP" + IntToString(nProp);
}




/**  
* Description
* @author Based on Reeron code
* @param 
* @see 
* @replaces XXX
* @return 
*/
string CSLListItemProperties( object oChar, object oSkipItem = OBJECT_INVALID)
{
	
	string sMessage = "";
	
	int nSR=0;
	object oCurItem;
	
	int nTable;
	int nTableValue;
	
	int nCounter;
	for( nCounter = 0; nCounter < NUM_INVENTORY_SLOTS; nCounter++)
	{
		
		
		oCurItem = GetItemInSlot( nCounter, oChar );
		
		
		
		if( oSkipItem == OBJECT_INVALID || oCurItem != oSkipItem)
		{
			if(GetIsObjectValid(oCurItem))
			{
				sMessage += "\nSlot "+CSLInventorySlotToString( nCounter );
				sMessage += " Name"+GetName( oCurItem );
				
				itemproperty iProp = GetFirstItemProperty( oCurItem );
				while ( GetIsItemPropertyValid(iProp) )
				{
					sMessage += "\n     "+CSLItemPropTypeToString( GetItemPropertyType( iProp ) );
					sMessage += " Table: "+IntToString(  GetItemPropertyCostTable( iProp ) );
					sMessage += " TableValue: "+IntToString( GetItemPropertyCostTableValue(iProp) );
					
					iProp = GetNextItemProperty(oCurItem);
				}
			
			}
		}
	}
	
	return sMessage;
}


// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
/**  
* Returns TRUE if a use limitation of any kind is present on oItem
* @author
* @param 
* @see 
* @replaces XXXIPGetHasUseLimitation
* @return 
*/
int CSLItemGetHasUseLimitation(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int nType;
    while (GetIsItemPropertyValid(ip))
    {
        nType = GetItemPropertyType(ip);
        if (
           nType == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP ||
           nType == ITEM_PROPERTY_USE_LIMITATION_CLASS ||
           nType == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE ||
           nType == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT  )
        {
            return TRUE;
        }
        ip = GetNextItemProperty(oItem);
    }
    return FALSE;

}


/**  
* Returns an integer with the number of properties present oItem
* @author GZ from game resources
* @param 
* @see 
* @replaces XXXIPGetNumberOfItemProperties
* @return 
*/
int CSLGetNumberOfItemProperties(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int nCount = 0;
    while (GetIsItemPropertyValid(ip))
    {
        nCount++;
        ip = GetNextItemProperty(oItem);
    }
    return nCount;
}



/**  
* used in poison weapon
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetItemPropertyExists(object oTarget, int nBonusType, int nSubType = -1)
{
	itemproperty ipLoop=GetFirstItemProperty(oTarget);
	while (GetIsItemPropertyValid(ipLoop))
	{
		if (GetItemPropertyType(ipLoop)==nBonusType)
		{
			if (nSubType == -1 || nSubType==GetItemPropertySubType(ipLoop)) return TRUE;
		}
		ipLoop=GetNextItemProperty(oTarget);
	}
	return FALSE;
}




/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetItemPropertyBonus(object oTarget, int nBonusType, int nSubType = -1)  // RETURN CURRENT ITEM BONUS LEVEL WITH OPTIONAL SUBTYPE
{
   itemproperty ipLoop=GetFirstItemProperty(oTarget);
   while (GetIsItemPropertyValid(ipLoop))
   {
      if (GetItemPropertyType(ipLoop)==nBonusType)
      {
         if (nSubType == -1 || nSubType==GetItemPropertySubType(ipLoop)) return GetItemPropertyCostTableValue(ipLoop);
      }
      ipLoop=GetNextItemProperty(oTarget);
   }
   return 0;
}




/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
itemproperty CSLCreateItemProperty(int iPropType, int iSubType, int iBonus)
{
    switch(iPropType)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:                return ItemPropertyAbilityBonus(iSubType, iBonus);
        case ITEM_PROPERTY_AC_BONUS:                     return ItemPropertyACBonus(iBonus);
        case ITEM_PROPERTY_ATTACK_BONUS:                 return ItemPropertyAttackBonus(iBonus);
        case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:  return ItemPropertyBonusLevelSpell(iSubType, iBonus);
        case ITEM_PROPERTY_DAMAGE_BONUS:                 return ItemPropertyDamageBonus(iSubType, iBonus);
        case ITEM_PROPERTY_DAMAGE_RESISTANCE:            return ItemPropertyDamageResistance(iSubType, iBonus);
        case ITEM_PROPERTY_DAMAGE_REDUCTION:             return ItemPropertyDamageReduction(iBonus, iSubType, 0, DR_TYPE_DMGTYPE);        
        case ITEM_PROPERTY_DARKVISION:                   return ItemPropertyDarkvision();
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:            return ItemPropertyEnhancementBonus(iBonus);
        case ITEM_PROPERTY_HASTE:                        return ItemPropertyHaste();
        case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:         return ItemPropertyDamageImmunity(iSubType, iBonus);
        case ITEM_PROPERTY_KEEN:                         return ItemPropertyKeen();
        case ITEM_PROPERTY_LIGHT:                        return ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, iBonus);
        case ITEM_PROPERTY_MASSIVE_CRITICALS:            return ItemPropertyMassiveCritical(iBonus);
        case ITEM_PROPERTY_MIGHTY:                       return ItemPropertyMaxRangeStrengthMod(iBonus);
        case ITEM_PROPERTY_ON_HIT_PROPERTIES:            return ItemPropertyOnHitProps(iSubType, iBonus, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS);
        case ITEM_PROPERTY_REGENERATION:                 return ItemPropertyRegeneration(iBonus);
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:        return ItemPropertyVampiricRegeneration(iBonus);
        case ITEM_PROPERTY_SAVING_THROW_BONUS:           return ItemPropertyBonusSavingThrowVsX(iSubType, iBonus);
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:  return ItemPropertyBonusSavingThrow(iSubType, iBonus);
        case ITEM_PROPERTY_SKILL_BONUS:                  return ItemPropertySkillBonus(iSubType, iBonus);
        case ITEM_PROPERTY_VISUALEFFECT:                 return ItemPropertyVisualEffect(iBonus);
    }
    return ItemPropertyAttackPenalty(iBonus);
}

/* way of caching feat item properties
itemproperty PRCItemPropertyBonusFeat(int nBonusFeatID)
{
    string sTag = "PRC_IPBF_"+IntToString(nBonusFeatID);
    object oTemp = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oTemp))
    {
        CSLDebug("PRCItemPropertyBonusFeat() : "+sTag+" is not valid");
        location lLimbo;
        object oLimbo = GetObjectByTag("HEARTOFCHAOS");
        if(GetIsObjectValid(oLimbo))
            lLimbo = GetLocation(oLimbo);
        else
            lLimbo = GetStartingLocation();
        oTemp = CreateObject(OBJECT_TYPE_ITEM, "base_prc_skin", lLimbo, FALSE, sTag);
    }
    itemproperty ipReturn = GetFirstItemProperty(oTemp);
    if(!GetIsItemPropertyValid(ipReturn))
    {
        CSLDebug("PRCItemPropertyBonusFeat() : ipReturn is not valid");
        ipReturn = ItemPropertyBonusFeat(nBonusFeatID);
        AddItemProperty(DURATION_TYPE_PERMANENT,ipReturn, oTemp);
    }
    return ipReturn;
}
*/

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLSpellResistanceToInt(int nSR)
{
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_10) return 10; // 0
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_12) return 12; // 1
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_14) return 14; // 2
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_16) return 16; // 3
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_18) return 18; // 4
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_20) return 20; // 5
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_22) return 22; // 6
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_24) return 24; // 7
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_26) return 26; // 8
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_28) return 28; // 9
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_30) return 30; // 10
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_32) return 32; // 11
	if (nSR==12)                               return 34; // 12
	if (nSR==13)                               return 36; // 13
	if (nSR==14)                               return 38; // 14
	if (nSR==15)                               return 40; // 15
	if (nSR==16)                               return 19; // 16
	return 0;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLSpellIntToResistanceProp(int nSR )
{
	if ( nSR >= 40) { return 15; } // 40
	if ( nSR >= 38) { return 14; } // 38
	if ( nSR >= 36) { return 13; } // 36
	if ( nSR >= 34) { return 12; } // 34
	if ( nSR >= 32) { return IP_CONST_SPELLRESISTANCEBONUS_32; }
	if ( nSR >= 30) { return IP_CONST_SPELLRESISTANCEBONUS_30; }
	if ( nSR >= 28) { return IP_CONST_SPELLRESISTANCEBONUS_28; }
	if ( nSR >= 26) { return IP_CONST_SPELLRESISTANCEBONUS_26; }
	if ( nSR >= 24) { return IP_CONST_SPELLRESISTANCEBONUS_24; }
	if ( nSR >= 22) { return IP_CONST_SPELLRESISTANCEBONUS_22; }
	if ( nSR >= 20) { return IP_CONST_SPELLRESISTANCEBONUS_20; }
	if ( nSR >= 19) { return 16; } // 19
	if ( nSR >= 18) { return IP_CONST_SPELLRESISTANCEBONUS_18; }
	if ( nSR >= 16) { return IP_CONST_SPELLRESISTANCEBONUS_16; }
	if ( nSR >= 14) { return IP_CONST_SPELLRESISTANCEBONUS_14; }
	if ( nSR >= 12) { return IP_CONST_SPELLRESISTANCEBONUS_12; }
	if ( nSR > 0) { return IP_CONST_SPELLRESISTANCEBONUS_10; }
	
	return 0;
}

/**  
* skip item is used on the on unequip script since it's gone
* This gets properties from items, gets the best of each one and applies it to char
* as a variable - run on initing a char or upon equip and unequip
* Purpose is to get hide spell resistance and spell immunity, will add more as time goes on
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
/*
void CSLApplyItemProperties( object oChar, object oSkipItem = OBJECT_INVALID)
{
	//string sMessage = "";
	
	int nSR=0;
	int nSpellsImmunity=0;
	
	object oCurItem;
	
	int nTable;
	int nTableValue;
	int iPropType;
	int nCounter;
	for( nCounter = 0; nCounter < NUM_INVENTORY_SLOTS; nCounter++)
	{
		oCurItem = GetItemInSlot( nCounter, oChar );
		
		//sMessage += "\nSlot "+CSLInventorySlotToString( nCounter );
		
		if( oSkipItem == OBJECT_INVALID || oCurItem != oSkipItem)
		{
			if(GetIsObjectValid(oCurItem))
			{
				//sMessage += " Name"+GetName( oCurItem );
				
				itemproperty iProp = GetFirstItemProperty( oCurItem );
				while ( GetIsItemPropertyValid(iProp) )
				{
					iPropType = GetItemPropertyType( iProp );
					if ( iPropType == ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL )
					{
						nSpellsImmunity = CSLGetMax( GetItemPropertyCostTableValue(iProp), nSpellsImmunity );
					}
					
					if ( iPropType == ITEM_PROPERTY_SPELL_RESISTANCE )
					{
						nSR = CSLSpellResistanceToInt( GetItemPropertyCostTableValue(iProp) );
					}
					//sMessage += "\n     "+CSLItemPropTypeToString( GetItemPropertyType( iProp ) );
					//sMessage += " Table: "+IntToString(  GetItemPropertyCostTable( iProp ) );
					//sMessage += " TableValue: "+IntToString( GetItemPropertyCostTableValue(iProp) );
					
					iProp = GetNextItemProperty(oCurItem);
				}
			
			}
		}
	}
	
	// now apply these to the target
	SetLocalInt( oChar , "SC_ITEM_APPLIED", TRUE );
	SetLocalInt( oChar , "SC_ITEM_SR", nSR );
	SetLocalInt( oChar , "SC_ITEM_SPELLIMMUNITY_BY_LEVEL", nSpellsImmunity );
	
	if (DEBUGGING >= 6) { CSLDebug(  "Applied Item Properties to Creature "+GetName(oChar)+" SR:"+IntToString(nSR)+" LevelImmunity:"+IntToString(nSpellsImmunity), oChar ); }
	//nSpellsImmunity
	
}
*/

/**  
* this is courtesy of REERON - only used here currently
* @author
* @param 
* @see 
* @replaces CSLGetItemSR
* @return 
*/
/*
int CSLHeldItemsGetSR( object oChar, object oSkipItem = OBJECT_INVALID)
{
	int nSR=0;
	object oCurItem;
	
	
	int nTable;
	int nTableValue;
	
	int nCounter;
	for( nCounter = 0; nCounter < NUM_INVENTORY_SLOTS; nCounter++)
	{
		oCurItem = GetItemInSlot( nCounter, oChar );
		if( oSkipItem == OBJECT_INVALID || oCurItem != oSkipItem)
		{
			if(GetIsObjectValid(oCurItem))
			{
				itemproperty iProp = GetFirstItemProperty( oCurItem );
				while (GetIsItemPropertyValid(iProp))
				{
					nTable = GetItemPropertyCostTable(iProp);
					
					if (nTable == 11) // Spell Resistance on creature hide.
					{
						nTableValue = GetItemPropertyCostTableValue(iProp);
						//nSR = CSLGetMax( nSR, StringToInt( Get2DAString("iprp_srcost", "Value", nTableValue) ) );
						//replace with a look up
						
						// Moved into script for performance, this needs to match iprp_srcost.2da which i don't think many folks bother to mod anyway
						nSR = CSLSpellResistanceToInt( nTableValue );
						
						
					}
					iProp = GetNextItemProperty(oCurItem);
				}
			
			}
		}
	}
	return nSR;
}
*/

// goes thru a creatures equipped items and caches all the properties currently in play, needs to be updated periodically if they re-equip their gear
// note this will keep track of SR and other similar properties as well.



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLItemPropClassToString(int iClass = 0)
{
	if (iClass == IP_CONST_CLASS_BARBARIAN    ) return "Barbarian"    ; // 0
	if (iClass == IP_CONST_CLASS_BARD    ) return "Bard"    ; // 1
	if (iClass == IP_CONST_CLASS_CLERIC  ) return "Cleric"  ; // 2
	if (iClass == IP_CONST_CLASS_DRUID   ) return "Druid"   ; // 3
	if (iClass == IP_CONST_CLASS_PALADIN ) return "Paladin" ; // 6
	if (iClass == IP_CONST_CLASS_RANGER  ) return "Ranger"  ; // 7
	if (iClass == IP_CONST_CLASS_SORCERER) return "Sorcerer"; // 9
	if (iClass == IP_CONST_CLASS_WIZARD  ) return "Wizard"  ; // 10
	if (iClass == CLASS_TYPE_FAVORED_SOUL  ) return "Favored Soul"  ;
	if (iClass == CLASS_TYPE_SPIRIT_SHAMAN) return "Spirit Shaman";
	return CSLGetClassesDataName( iClass, FALSE);
	return "MissIPClass" + IntToString(iClass);
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLUnlimitedAmmoDescToString(int iBonus)
{
	switch (iBonus) {
		case IP_CONST_UNLIMITEDAMMO_BASIC   : return "Basic";
		case IP_CONST_UNLIMITEDAMMO_1D6FIRE : return "1d6 Fire";
		case IP_CONST_UNLIMITEDAMMO_1D6COLD : return "1d6 Cold";
		case IP_CONST_UNLIMITEDAMMO_1D6LIGHT: return "1d6 Lightning";
		case IP_CONST_UNLIMITEDAMMO_NATURES_RAGE: return "Natures Rage";
		case IP_CONST_UNLIMITEDAMMO_PLUS1   : return "+1 Piercing";
		case IP_CONST_UNLIMITEDAMMO_PLUS2   : return "+2 Piercing";
		case IP_CONST_UNLIMITEDAMMO_PLUS3   : return "+3 Piercing";
		case IP_CONST_UNLIMITEDAMMO_PLUS4   : return "+4 Piercing";
		case IP_CONST_UNLIMITEDAMMO_PLUS5   : return "+5 Piercing";
		case 30                             : return "Duskwood Energy";
		case 31                             : return "Cold Iron Energy";
		case 32                             : return "Alchemical Silver Energy";
		case 33                             : return "Adamantine Energy";
	}
	return "MissULA" + IntToString(iBonus);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLOnHitDCToString(int nOnHit)
{
	if (nOnHit==IP_CONST_ONHIT_SAVEDC_14)  return "DC 14"; // 0
    if (nOnHit==IP_CONST_ONHIT_SAVEDC_16)  return "DC 16"; // 1
	if (nOnHit==IP_CONST_ONHIT_SAVEDC_18)  return "DC 18"; // 2
    if (nOnHit==IP_CONST_ONHIT_SAVEDC_20)  return "DC 20"; // 3
	if (nOnHit==IP_CONST_ONHIT_SAVEDC_22)  return "DC 22"; // 4 
    if (nOnHit==IP_CONST_ONHIT_SAVEDC_24)  return "DC 24"; // 5
	if (nOnHit==IP_CONST_ONHIT_SAVEDC_26)  return "DC 26"; // 6
	if (nOnHit==IP_CONST_ONHIT_SAVEDC_28)  return "DC 28"; // 7
    if (nOnHit==IP_CONST_ONHIT_SAVEDC_30)  return "DC 30"; // 8
	if (nOnHit==IP_CONST_ONHIT_SAVEDC_32)  return "DC 32"; // 9
    if (nOnHit==IP_CONST_ONHIT_SAVEDC_34)  return "DC 34"; // 10
	if (nOnHit==IP_CONST_ONHIT_SAVEDC_36)  return "DC 36"; // 11 
    if (nOnHit==IP_CONST_ONHIT_SAVEDC_38)  return "DC 38"; // 12
	if (nOnHit==IP_CONST_ONHIT_SAVEDC_40)  return "DC 40"; // 13
	
	return "MissOnHitDC" + IntToString(nOnHit);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLOnHitTypeToString(int nOnHitType)
{
	if (nOnHitType==IP_CONST_ONHIT_DAZE) return "Daze";
    if (nOnHitType==IP_CONST_ONHIT_FEAR) return "Fear";
	if (nOnHitType==IP_CONST_ONHIT_HOLD) return "Hold";
    if (nOnHitType==IP_CONST_ONHIT_SLOW) return "Slow";
	if (nOnHitType==IP_CONST_ONHIT_STUN) return "Stun";
	return "MissOnHitType" + IntToString(nOnHitType);
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLDamageBonusToString(int nDamageBonus)
{
	// Returns total damage done by property
	// Fixed damage ones are doubled due to lack of randomness
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1    ) return  "1";// 1
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2    ) return  "2";//  2;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_3    ) return  "3";//  3;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4    ) return  "4";//  4;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_5    ) return  "5";//  5;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d4  ) return  "1d4";//  6;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d6  ) return  "1d6";//  7;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d8  ) return  "1d8";//  8;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d10 ) return  "1d10";//  9;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d6  ) return  "2d6";//  10;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d8  ) return  "2d8";//  11;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d4  ) return  "2d4";//  12;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d10 ) return  "2d10";//  13;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d12 ) return  "1d12";//  14;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d12 ) return  "2d12";//  15;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_6    ) return  "6";//  16;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_7    ) return  "7";//  17;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_8    ) return  "8";//  18;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_9    ) return  "9";//  19;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_10   ) return  "10";//  20;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_3d10	) return  "3d10";//  51;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_3d12	) return  "3d12";//  52;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4d6  ) return  "4d6";//  53;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4d8  ) return  "4d8";//  54;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4d10	) return  "4d10";// 55;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4d12 ) return  "4d12";// 56;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_5d6  ) return  "5d6";// 57;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_5d12	) return  "5d12";//  58;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_6d12	) return  "6d12";//  59;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_3d6  ) return  "3d6";// 60;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_6d6  ) return  "6d6";//  61;
	return "MissDamBonus" + IntToString(nDamageBonus);
}


	
/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLDamageImmunityToString(int nDamageImmunity)
{
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_5_PERCENT)   return "5%";
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_10_PERCENT)  return "10%";
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_25_PERCENT)  return "25%";
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_50_PERCENT)  return "50%";
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_75_PERCENT)  return "75%";
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_90_PERCENT)  return "90%";
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_100_PERCENT) return "100%";
	return "MissDamImm" + IntToString(nDamageImmunity);
}

float CSLDamageImmunityToFloat(int nDamageImmunity)
{
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_5_PERCENT)   return 5.0f;
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_10_PERCENT)  return 10.0f;
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_25_PERCENT)  return 25.0f;
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_50_PERCENT)  return 50.0f;
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_75_PERCENT)  return 75.0f;
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_90_PERCENT)  return 90.0f;
	if (nDamageImmunity==IP_CONST_DAMAGEIMMUNITY_100_PERCENT) return 100.0f;
	return 0.0f;
}



	
/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLDamageSoakToString(int nDamageSoak)
{
	if (nDamageSoak==IP_CONST_DAMAGESOAK_5_HP)  return "5";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_10_HP) return "10";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_15_HP) return "15";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_20_HP) return "20";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_25_HP) return "25";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_30_HP) return "30";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_35_HP) return "35";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_40_HP) return "40";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_45_HP) return "45";
	if (nDamageSoak==IP_CONST_DAMAGESOAK_50_HP) return "50";
	return "MissDamSoak" + IntToString(nDamageSoak);
}
	
/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLDamageResistanceToString(int nDamageResistance)
{
	if (nDamageResistance==IP_CONST_DAMAGERESIST_5 )  return "5/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_10)  return "10/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_15)  return "15/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_20)  return "20/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_25)  return "25/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_30)  return "30/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_35)  return "35/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_40)  return "40/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_45)  return "45/-";
	if (nDamageResistance==IP_CONST_DAMAGERESIST_50)  return "50/-";
	return "MissDamRes" + IntToString(nDamageResistance);
}
	
/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLSpellResistanceToString(int nSR)
{
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_10) return "10"; // 0
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_12) return "12"; // 1
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_14) return "14"; // 2
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_16) return "16"; // 3
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_18) return "18"; // 4
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_20) return "20"; // 5
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_22) return "22"; // 6
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_24) return "24"; // 7
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_26) return "26"; // 8
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_28) return "28"; // 9
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_30) return "30"; // 10
	if (nSR==IP_CONST_SPELLRESISTANCEBONUS_32) return "32"; // 11
	if (nSR==12)                               return "34"; // 12
	if (nSR==13)                               return "36"; // 13
	if (nSR==14)                               return "38"; // 14
	if (nSR==15)                               return "40"; // 15
	if (nSR==16)                               return "19"; // 16
	return "MissSR" + IntToString(nSR);
}


// this is an experiment, not used for anything yet
void CSLCacheItemProperties( object oItem )
{
	itemproperty curItemProp = GetFirstItemProperty(oItem);
	while( GetIsItemPropertyValid(curItemProp)  )
	{
		int iItemTypeValue = GetItemPropertyType(curItemProp);
					switch(iItemTypeValue)
					{
						
						/*
						case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
							levelProtect = GetItemPropertyCostTableValue(curItemProp);
							if (levelProtect > iSpellLevelProt)
							{
								iSpellLevelProt = levelProtect;
							}
							break;
						case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
							sImmuneToSpell = Get2DAString("iprp_spellcost", "SpellIndex", GetItemPropertyCostTableValue(curItemProp) );
							if ( sImmuneToSpell != "" )
							{
								sSpecificSpellImmunity = CSLNth_Push(sSpecificSpellImmunity, sImmuneToSpell );
							}
							break;
						case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
							iSubType = GetItemPropertySubType(curItemProp);
							
							iSchoolImmunityMask |= CSLIntegertoBit( CSLSchoolItemPropToSchool(iSubType) );
							break;
						case ITEM_PROPERTY_SPELL_RESISTANCE:
							iSpellResistance = CSLSpellResistanceToInt( GetItemPropertyCostTableValue(curItemProp) );
							break;
						
						case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
							fDamImmuneTemp = CSLDamageImmunityToFloat( GetItemPropertyCostTableValue(curItemProp) );
							iSubType = GetItemPropertySubType(curItemProp);
							
							damageType = CSLIntegertoBit( iSubType-2);
							iDamageResistanceType |= damageType;
							
							switch ( iSubType )
							{
								case IP_CONST_DAMAGETYPE_MAGICAL:
									fDamImmuneMagic -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_ACID:
									fDamImmuneAcid -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_COLD:
									fDamImmuneCold -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_DIVINE:
									fDamImmuneDivine -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_ELECTRICAL:
									fDamImmuneElectrical -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_FIRE:
									fDamImmuneFire -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_NEGATIVE:
									fDamImmuneNegative -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_POSITIVE:
									fDamImmunePositive -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_SONIC:
									fDamImmuneSonic -= fDamImmuneTemp;
									break;
							}
							break;
						case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
							fDamImmuneTemp = CSLDamageImmunityToFloat( GetItemPropertyCostTableValue(curItemProp) );
							iSubType = GetItemPropertySubType(curItemProp);
							
							damageType = CSLIntegertoBit( iSubType-2);
							iDamageResistanceType |= damageType;
							
							switch ( iSubType )
							{
								case IP_CONST_DAMAGETYPE_MAGICAL:
									fDamImmuneMagic += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_ACID:
									fDamImmuneAcid += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_COLD:
									fDamImmuneCold += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_DIVINE:
									fDamImmuneDivine += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_ELECTRICAL:
									fDamImmuneElectrical += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_FIRE:
									fDamImmuneFire += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_NEGATIVE:
									fDamImmuneNegative += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_POSITIVE:
									fDamImmunePositive += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_SONIC:
									fDamImmuneSonic += fDamImmuneTemp;
									break;
							}
						case ITEM_PROPERTY_DAMAGE_RESISTANCE:
							iDamResistTemp = GetItemPropertyCostTableValue( curItemProp ) * 5;
							iSubType = GetItemPropertySubType(curItemProp);
							
							damageType = CSLIntegertoBit( iSubType-2);
							iDamageResistanceType |= damageType;
							
							switch ( iSubType )
							{
								case IP_CONST_DAMAGETYPE_MAGICAL:
									iDamResistMagic += iDamResistTemp; //  CSLGetMax( iACDamResistMagic, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_ACID:
									iDamResistAcid += iDamResistTemp; //  CSLGetMax( iACDamResistAcid, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_COLD:
									iDamResistCold += iDamResistTemp; //  CSLGetMax( iACDamResistCold, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_DIVINE:
									iDamResistDivine += iDamResistTemp; //  CSLGetMax( iACDamResistDivine, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_ELECTRICAL:
									iDamResistElectrical += iDamResistTemp; //  CSLGetMax( iACDamResistElectrical, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_FIRE:
									iDamResistFire += iDamResistTemp; //  CSLGetMax( iACDamResistFire, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_NEGATIVE:
									iDamResistNegative += iDamResistTemp; //  CSLGetMax( iACDamResistNegative, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_POSITIVE:
									iDamResistPositive += iDamResistTemp; //  CSLGetMax( iACDamResistPositive, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_SONIC:
									iDamResistSonic += iDamResistTemp; // CSLGetMax( iACDamResistSonic, iDamResistTemp);
									break;
							}
							break;
						
						case ITEM_PROPERTY_HASTE:
							posEffects |= HENCH_EFFECT_TYPE_HASTE;
							break;
						
						case ITEM_PROPERTY_TRUE_SEEING:
							posEffects |= HENCH_EFFECT_TYPE_TRUESEEING;
							break;
						
						case ITEM_PROPERTY_REGENERATION:
							iRegenerationRate += GetItemPropertyCostTableValue(curItemProp) * 4; // HENCH_AI_REGEN_RATE_ROUNDS is 4
							break;
						
						case ITEM_PROPERTY_ABILITY_BONUS:
							posEffects |= HENCH_EFFECT_TYPE_ABILITY_INCREASE;
							
							abilityType = GetItemPropertySubType(curItemProp);
							abilityBitMask = CSLIntegertoBit(abilityType);
							abilityMask |= abilityBitMask;
							
							iAbilIncrease = GetItemPropertyCostTableValue( curItemProp );
							switch ( abilityType )
							{
								 case ABILITY_STRENGTH:
									iAbilIncreaseStrength = CSLGetMax( iAbilIncreaseStrength, iAbilIncrease );
									break;
								 case ABILITY_DEXTERITY:
									iAbilIncreaseDexterity = CSLGetMax( iAbilIncreaseDexterity, iAbilIncrease );
									break;
								 case ABILITY_CONSTITUTION:
									iAbilIncreaseConstitution = CSLGetMax( iAbilIncreaseConstitution, iAbilIncrease );
									break;
								 case ABILITY_INTELLIGENCE:
									iAbilIncreaseIntelligence = CSLGetMax( iAbilIncreaseIntelligence, iAbilIncrease );
									break;
								 case ABILITY_WISDOM:
									iAbilIncreaseWisdom = CSLGetMax( iAbilIncreaseWisdom, iAbilIncrease );
									break;
								 case ABILITY_CHARISMA:
									iAbilIncreaseCharisma = CSLGetMax( iAbilIncreaseCharisma, iAbilIncrease );
									break;
							}
							break;
						case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
							negEffects |= HENCH_EFFECT_TYPE_ABILITY_DECREASE;
							
							abilityType = GetItemPropertySubType(curItemProp);
							abilityBitMask = CSLIntegertoBit(abilityType);
							abilityMask |= abilityBitMask;
							
							iAbilDecrease = GetItemPropertyCostTableValue( curItemProp );
							switch ( abilityType )
							{
								 case ABILITY_STRENGTH:
									iAbilDecreaseStrength = CSLGetMax( iAbilDecreaseStrength, iAbilDecrease );
									break;
								 case ABILITY_DEXTERITY:
									iAbilDecreaseDexterity = CSLGetMax( iAbilDecreaseDexterity, iAbilDecrease );
									break;
								 case ABILITY_CONSTITUTION:
									iAbilDecreaseConstitution = CSLGetMax( iAbilDecreaseConstitution, iAbilDecrease );
									break;
								 case ABILITY_INTELLIGENCE:
									iAbilDecreaseIntelligence = CSLGetMax( iAbilDecreaseIntelligence, iAbilDecrease );
									break;
								 case ABILITY_WISDOM:
									iAbilDecreaseWisdom = CSLGetMax( iAbilDecreaseWisdom, iAbilDecrease );
									break;
								 case ABILITY_CHARISMA:
									iAbilDecreaseCharisma = CSLGetMax( iAbilDecreaseCharisma, iAbilDecrease );
									break;
							}
							break;
							
						case ITEM_PROPERTY_AC_BONUS:
							posEffects |= HENCH_EFFECT_TYPE_AC_INCREASE;
							iACTemp = GetItemPropertyCostTableValue( curItemProp );
							
							switch (slotIndex)
							{
								case INVENTORY_SLOT_BOOTS:
									iACDodge += iACTemp;
									break;
								case INVENTORY_SLOT_NECK:
									iACNatural = CSLGetMax( iACNatural, iACTemp);
									break;
								case INVENTORY_SLOT_ARMS:
									if (GetBaseItemType(oItem) != BASE_ITEM_BRACER)
									{
										iACDeflection = CSLGetMax( iACDeflection, iACTemp);
									}
									else
									{
										iACArmor = CSLGetMax( iACArmor, iACTemp);
									}
									break;
								case INVENTORY_SLOT_CHEST:
									iACArmor = CSLGetMax( iACArmor, iACTemp);
									break;
								case INVENTORY_SLOT_LEFTHAND:
									// shield only
									itemType = GetBaseItemType(oItem);
									if ((itemType == BASE_ITEM_TOWERSHIELD) || (itemType == BASE_ITEM_LARGESHIELD) || (itemType == BASE_ITEM_SMALLSHIELD))
									{
										iACShield = CSLGetMax( iACShield, iACTemp);
										
									}
									else
									{
										iACDeflection = CSLGetMax( iACDeflection, iACTemp);
									}
									break;
								default:
									iACDeflection = CSLGetMax( iACDeflection, iACTemp);
									
							}
							
							break;
							
						case ITEM_PROPERTY_DECREASED_AC:
							iACTemp = GetItemPropertyCostTableValue( curItemProp );
							switch ( GetItemPropertySubType( curItemProp ) )
							{
								case IP_CONST_ACMODIFIERTYPE_DODGE:
									iACDodgePenalty += iACTemp;
									break;
								case IP_CONST_ACMODIFIERTYPE_NATURAL:
									iACNaturalPenalty = CSLGetMax( iACNaturalPenalty, iACTemp);
									break;
								case IP_CONST_ACMODIFIERTYPE_ARMOR:
									iACArmorPenalty = CSLGetMax( iACArmorPenalty, iACTemp);
									break;
								case IP_CONST_ACMODIFIERTYPE_SHIELD:
									iACShieldPenalty = CSLGetMax( iACShieldPenalty, iACTemp);
									break;
								case IP_CONST_ACMODIFIERTYPE_DEFLECTION:
									iACDeflectionPenalty = CSLGetMax( iACDeflectionPenalty, iACTemp);
									break;
							}
						
							break;
							*/
					}
	}
}



/**  
* skip item is used on the on unequip script since it's gone, not really going to use that much as this is going to be called in a delay
* This gets properties from items, gets the best of each one and applies it to char
* as a variable - run on initing a char or upon equip and unequip
* Purpose is to get hide spell resistance and spell immunity, will add more as time goes on
* @author
* @param 
* @see 
* @replaces XXXCSLHeldItemsGetSR, XXXCSLApplyItemProperties
* @return 
*/
void CSLCacheCreatureItemInformation( object oTarget, int bForceReload = FALSE,  object oSkipItem = OBJECT_INVALID, int iMaxPropertiesToProcess = 50 )
{
	if ( !bForceReload && GetLocalInt( oTarget , "SC_ITEM_CACHED") )
	{
		return; // exit out, it's already cached
	}
	
	int iIteration = 0; // capping at a max of 50 properties, need to adjust this based on tmi issues, also check functions involved if they are doing any extra work here, just a safety valve to prevent a possible TMI
	int iSubType; // used for various places
	
	int negEffects;
    int posEffects;
	int iSpellLevelProt = 0;
	int iSpellResistance = 0; 
	
	int iACTemp;
	int iACDodge, iACNatural, iACArmor, iACShield, iACDeflection;
	int iACDodgePenalty, iACNaturalPenalty, iACArmorPenalty, iACShieldPenalty, iACDeflectionPenalty;
	
	int iResistTemp;
	int iDamResistMagic, iDamResistAcid, iDamResistCold, iDamResistDivine, iDamResistElectrical, iDamResistFire, iDamResistNegative, iDamResistPositive, iDamResistSonic;
	
	int iAbilIncreaseStrength, iAbilIncreaseDexterity, iAbilIncreaseConstitution, iAbilIncreaseIntelligence, iAbilIncreaseWisdom, iAbilIncreaseCharisma;
	
	int iAbilDecreaseStrength, iAbilDecreaseDexterity, iAbilDecreaseConstitution, iAbilDecreaseIntelligence, iAbilDecreaseWisdom, iAbilDecreaseCharisma;
	int levelProtect;
	int damageType;
	float fDamImmuneTemp, fDamImmuneMagic, fDamImmuneAcid, fDamImmuneCold, fDamImmuneDivine, fDamImmuneElectrical, fDamImmuneFire, fDamImmuneNegative, fDamImmunePositive, fDamImmuneSonic;
	int iDamResistTemp;
	
	int iDamageResistanceType;
	string sImmuneToSpell, sSpecificSpellImmunity;
	int iSchoolImmunityMask;
	
	int abilityMask, abilityType, abilityBitMask;
	
	int iAbilIncrease, iAbilDecrease;
	
	int iRegenerationRate;
	int itemType;
	
	int iConductivity = GetCreatureSize( oTarget ); // overall mass helps
	if ( CSLGetIsConstruct( oTarget, TRUE  ) )
	{
		iConductivity *= 10;
	}
	else if ( CSLGetIsWaterBased( oTarget, TRUE ) )
	{
		iConductivity *= 5;
	}
	
	int slotIndex;
    for (slotIndex = INVENTORY_SLOT_HEAD; slotIndex < NUM_INVENTORY_SLOTS && iIteration < iMaxPropertiesToProcess ; slotIndex++)
    {
        object oItem = GetItemInSlot(slotIndex, oTarget);
		
		if( oSkipItem == OBJECT_INVALID || oItem != oSkipItem)
		{
			if (GetIsObjectValid(oItem) && iIteration < iMaxPropertiesToProcess )
			{
				if ( GetItemBaseMaterialType( oItem ) < 7 ) // includes invalid, but skips things like duskwood
				{
					int iItemType = GetBaseItemType(oItem);
					if ( slotIndex == INVENTORY_SLOT_RIGHTHAND || slotIndex == INVENTORY_SLOT_LEFTHAND )
					{
						
						// these base items are just ignored completely
						if (  iItemType != BASE_ITEM_LIGHTFLAIL &&  iItemType != BASE_ITEM_HEAVYCROSSBOW &&  iItemType != BASE_ITEM_LIGHTCROSSBOW && 
							iItemType != BASE_ITEM_LONGBOW &&  iItemType != BASE_ITEM_SHORTBOW &&  iItemType != BASE_ITEM_TORCH &&  iItemType != BASE_ITEM_CLUB && 
							iItemType != BASE_ITEM_MAGICROD &&  iItemType != BASE_ITEM_MAGICSTAFF &&  iItemType != BASE_ITEM_MAGICWAND && iItemType != BASE_ITEM_QUARTERSTAFF && 
							iItemType != BASE_ITEM_SHORTSPEAR &&  iItemType != BASE_ITEM_SLING &&  iItemType != BASE_ITEM_ENCHANTED_WAND &&  iItemType != BASE_ITEM_WHIP && 
							iItemType != BASE_ITEM_SPEAR &&  iItemType != BASE_ITEM_GREATCLUB &&  iItemType != BASE_ITEM_TRAINING_CLUB &&  iItemType != BASE_ITEM_DRUM &&  iItemType != BASE_ITEM_FLUTE &&  iItemType != BASE_ITEM_MANDOLIN )
						{
							iConductivity += GetWeight( oItem );
						}
					}
					else if ( slotIndex == INVENTORY_SLOT_CHEST && GetArmorRank(oItem) > ARMOR_RANK_LIGHT )
					{
						iConductivity += GetWeight( oItem )*2;
					}
					else if ( slotIndex == INVENTORY_SLOT_ARMS && iItemType == BASE_ITEM_BRACER )
					{
						iConductivity += GetWeight( oItem )/2;
					}
					else
					{
						iConductivity += GetWeight( oItem ) / 10;
					}
				
				}
				
				
				itemproperty curItemProp = GetFirstItemProperty(oItem);
				while( GetIsItemPropertyValid(curItemProp) && iIteration < iMaxPropertiesToProcess )
				{                
					int iItemTypeValue = GetItemPropertyType(curItemProp);
					switch(iItemTypeValue)
					{
						case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
							levelProtect = GetItemPropertyCostTableValue(curItemProp);
							if (levelProtect > iSpellLevelProt)
							{
								iSpellLevelProt = levelProtect;
							}
							break;
						case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
							sImmuneToSpell = Get2DAString("iprp_spellcost", "SpellIndex", GetItemPropertyCostTableValue(curItemProp) );
							if ( sImmuneToSpell != "" )
							{
								sSpecificSpellImmunity = CSLNth_Push(sSpecificSpellImmunity, sImmuneToSpell );
							}
							break;
						case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
							iSubType = GetItemPropertySubType(curItemProp);
							
							iSchoolImmunityMask |= CSLIntegertoBit( CSLSchoolItemPropToSchool(iSubType) );
							break;
						case ITEM_PROPERTY_SPELL_RESISTANCE:
							iSpellResistance = CSLSpellResistanceToInt( GetItemPropertyCostTableValue(curItemProp) );
							break;
						
						case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
							fDamImmuneTemp = CSLDamageImmunityToFloat( GetItemPropertyCostTableValue(curItemProp) );
							iSubType = GetItemPropertySubType(curItemProp);
							
							damageType = CSLIntegertoBit( iSubType-2);
							iDamageResistanceType |= damageType;
							
							switch ( iSubType )
							{
								case IP_CONST_DAMAGETYPE_MAGICAL:
									fDamImmuneMagic -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_ACID:
									fDamImmuneAcid -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_COLD:
									fDamImmuneCold -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_DIVINE:
									fDamImmuneDivine -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_ELECTRICAL:
									fDamImmuneElectrical -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_FIRE:
									fDamImmuneFire -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_NEGATIVE:
									fDamImmuneNegative -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_POSITIVE:
									fDamImmunePositive -= fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_SONIC:
									fDamImmuneSonic -= fDamImmuneTemp;
									break;
							}
							break;
						case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
							fDamImmuneTemp = CSLDamageImmunityToFloat( GetItemPropertyCostTableValue(curItemProp) );
							iSubType = GetItemPropertySubType(curItemProp);
							
							damageType = CSLIntegertoBit( iSubType-2);
							iDamageResistanceType |= damageType;
							
							switch ( iSubType )
							{
								case IP_CONST_DAMAGETYPE_MAGICAL:
									fDamImmuneMagic += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_ACID:
									fDamImmuneAcid += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_COLD:
									fDamImmuneCold += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_DIVINE:
									fDamImmuneDivine += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_ELECTRICAL:
									fDamImmuneElectrical += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_FIRE:
									fDamImmuneFire += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_NEGATIVE:
									fDamImmuneNegative += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_POSITIVE:
									fDamImmunePositive += fDamImmuneTemp;
									break;
								case IP_CONST_DAMAGETYPE_SONIC:
									fDamImmuneSonic += fDamImmuneTemp;
									break;
							}
						case ITEM_PROPERTY_DAMAGE_RESISTANCE:
							iDamResistTemp = GetItemPropertyCostTableValue( curItemProp ) * 5;
							iSubType = GetItemPropertySubType(curItemProp);
							
							damageType = CSLIntegertoBit( iSubType-2);
							iDamageResistanceType |= damageType;
							
							switch ( iSubType )
							{
								case IP_CONST_DAMAGETYPE_MAGICAL:
									iDamResistMagic += iDamResistTemp; //  CSLGetMax( iACDamResistMagic, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_ACID:
									iDamResistAcid += iDamResistTemp; //  CSLGetMax( iACDamResistAcid, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_COLD:
									iDamResistCold += iDamResistTemp; //  CSLGetMax( iACDamResistCold, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_DIVINE:
									iDamResistDivine += iDamResistTemp; //  CSLGetMax( iACDamResistDivine, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_ELECTRICAL:
									iDamResistElectrical += iDamResistTemp; //  CSLGetMax( iACDamResistElectrical, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_FIRE:
									iDamResistFire += iDamResistTemp; //  CSLGetMax( iACDamResistFire, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_NEGATIVE:
									iDamResistNegative += iDamResistTemp; //  CSLGetMax( iACDamResistNegative, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_POSITIVE:
									iDamResistPositive += iDamResistTemp; //  CSLGetMax( iACDamResistPositive, iDamResistTemp);
									break;
								case IP_CONST_DAMAGETYPE_SONIC:
									iDamResistSonic += iDamResistTemp; // CSLGetMax( iACDamResistSonic, iDamResistTemp);
									break;
							}
							break;
						
						case ITEM_PROPERTY_HASTE:
							posEffects |= HENCH_EFFECT_TYPE_HASTE;
							break;
						
						case ITEM_PROPERTY_TRUE_SEEING:
							posEffects |= HENCH_EFFECT_TYPE_TRUESEEING;
							break;
						
						case ITEM_PROPERTY_REGENERATION:
							iRegenerationRate += GetItemPropertyCostTableValue(curItemProp) * 4; // HENCH_AI_REGEN_RATE_ROUNDS is 4
							break;
						
						case ITEM_PROPERTY_ABILITY_BONUS:
							posEffects |= HENCH_EFFECT_TYPE_ABILITY_INCREASE;
							
							abilityType = GetItemPropertySubType(curItemProp);
							abilityBitMask = CSLIntegertoBit(abilityType);
							abilityMask |= abilityBitMask;
							
							iAbilIncrease = GetItemPropertyCostTableValue( curItemProp );
							switch ( abilityType )
							{
								 case ABILITY_STRENGTH:
									iAbilIncreaseStrength = CSLGetMax( iAbilIncreaseStrength, iAbilIncrease );
									break;
								 case ABILITY_DEXTERITY:
									iAbilIncreaseDexterity = CSLGetMax( iAbilIncreaseDexterity, iAbilIncrease );
									break;
								 case ABILITY_CONSTITUTION:
									iAbilIncreaseConstitution = CSLGetMax( iAbilIncreaseConstitution, iAbilIncrease );
									break;
								 case ABILITY_INTELLIGENCE:
									iAbilIncreaseIntelligence = CSLGetMax( iAbilIncreaseIntelligence, iAbilIncrease );
									break;
								 case ABILITY_WISDOM:
									iAbilIncreaseWisdom = CSLGetMax( iAbilIncreaseWisdom, iAbilIncrease );
									break;
								 case ABILITY_CHARISMA:
									iAbilIncreaseCharisma = CSLGetMax( iAbilIncreaseCharisma, iAbilIncrease );
									break;
							}
							break;
						case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
							negEffects |= HENCH_EFFECT_TYPE_ABILITY_DECREASE;
							
							abilityType = GetItemPropertySubType(curItemProp);
							abilityBitMask = CSLIntegertoBit(abilityType);
							abilityMask |= abilityBitMask;
							
							iAbilDecrease = GetItemPropertyCostTableValue( curItemProp );
							switch ( abilityType )
							{
								 case ABILITY_STRENGTH:
									iAbilDecreaseStrength = CSLGetMax( iAbilDecreaseStrength, iAbilDecrease );
									break;
								 case ABILITY_DEXTERITY:
									iAbilDecreaseDexterity = CSLGetMax( iAbilDecreaseDexterity, iAbilDecrease );
									break;
								 case ABILITY_CONSTITUTION:
									iAbilDecreaseConstitution = CSLGetMax( iAbilDecreaseConstitution, iAbilDecrease );
									break;
								 case ABILITY_INTELLIGENCE:
									iAbilDecreaseIntelligence = CSLGetMax( iAbilDecreaseIntelligence, iAbilDecrease );
									break;
								 case ABILITY_WISDOM:
									iAbilDecreaseWisdom = CSLGetMax( iAbilDecreaseWisdom, iAbilDecrease );
									break;
								 case ABILITY_CHARISMA:
									iAbilDecreaseCharisma = CSLGetMax( iAbilDecreaseCharisma, iAbilDecrease );
									break;
							}
							break;
							
						case ITEM_PROPERTY_AC_BONUS:
							posEffects |= HENCH_EFFECT_TYPE_AC_INCREASE;
							iACTemp = GetItemPropertyCostTableValue( curItemProp );
							
							switch (slotIndex)
							{
								case INVENTORY_SLOT_BOOTS:
									iACDodge += iACTemp;
									break;
								case INVENTORY_SLOT_NECK:
									iACNatural = CSLGetMax( iACNatural, iACTemp);
									break;
								case INVENTORY_SLOT_ARMS:
									if (GetBaseItemType(oItem) != BASE_ITEM_BRACER)
									{
										iACDeflection = CSLGetMax( iACDeflection, iACTemp);
									}
									else
									{
										iACArmor = CSLGetMax( iACArmor, iACTemp);
									}
									break;
								case INVENTORY_SLOT_CHEST:
									iACArmor = CSLGetMax( iACArmor, iACTemp);
									break;
								case INVENTORY_SLOT_LEFTHAND:
									// shield only
									itemType = GetBaseItemType(oItem);
									if ((itemType == BASE_ITEM_TOWERSHIELD) || (itemType == BASE_ITEM_LARGESHIELD) || (itemType == BASE_ITEM_SMALLSHIELD))
									{
										iACShield = CSLGetMax( iACShield, iACTemp);
										
									}
									else
									{
										iACDeflection = CSLGetMax( iACDeflection, iACTemp);
									}
									break;
								default:
									iACDeflection = CSLGetMax( iACDeflection, iACTemp);
									
							}
							
							break;
							
						case ITEM_PROPERTY_DECREASED_AC:
							iACTemp = GetItemPropertyCostTableValue( curItemProp );
							switch ( GetItemPropertySubType( curItemProp ) )
							{
								case IP_CONST_ACMODIFIERTYPE_DODGE:
									iACDodgePenalty += iACTemp;
									break;
								case IP_CONST_ACMODIFIERTYPE_NATURAL:
									iACNaturalPenalty = CSLGetMax( iACNaturalPenalty, iACTemp);
									break;
								case IP_CONST_ACMODIFIERTYPE_ARMOR:
									iACArmorPenalty = CSLGetMax( iACArmorPenalty, iACTemp);
									break;
								case IP_CONST_ACMODIFIERTYPE_SHIELD:
									iACShieldPenalty = CSLGetMax( iACShieldPenalty, iACTemp);
									break;
								case IP_CONST_ACMODIFIERTYPE_DEFLECTION:
									iACDeflectionPenalty = CSLGetMax( iACDeflectionPenalty, iACTemp);
									break;
							}
						
							break;
					}
					
					iIteration++;
					curItemProp = GetNextItemProperty(oItem);
				}
			}
		}
        // skip unneeded checks on ammunition, this will go to INVENTORY_SLOT_CARMOUR next
        if (slotIndex == INVENTORY_SLOT_BELT)
        {
            slotIndex = INVENTORY_SLOT_CWEAPON_B;
        }
    }
    
    SetLocalInt( oTarget , "SC_ITEM_CACHED", TRUE );
    
    SetLocalInt( oTarget , "SC_ITEM_CONDUCTIVITY", iConductivity );
    
    
    SetLocalInt(oTarget, "SC_ITEM_POSITIVE_EFFECTS", posEffects);
    SetLocalInt(oTarget, "SC_ITEM_NEGATIVE_EFFECTS", negEffects);
    
    // Store AC from Items
    iACDodge = CSLGetMin( iACDodge, 20);
    SetLocalInt(oTarget, "SC_ITEM_AC_TOTAL", (iACDodge-iACDodgePenalty) + (iACNatural-iACNaturalPenalty) + (iACArmor-iACArmorPenalty) + (iACShield-iACShieldPenalty) + (iACDeflection-iACDeflectionPenalty) );
    SetLocalInt(oTarget, "SC_ITEM_AC_TOTAL_TOUCH", (iACDodge-iACDodgePenalty) + (iACDeflection-iACDeflectionPenalty) );
    SetLocalInt(oTarget, "SC_ITEM_AC_TOTAL_FLATFOOTED", (iACNatural-iACNaturalPenalty) + (iACArmor-iACArmorPenalty) + (iACShield-iACShieldPenalty) + (iACDeflection-iACDeflectionPenalty) );
    SetLocalInt(oTarget, "SC_ITEM_AC_DODGE", iACDodge-iACDodgePenalty );
    SetLocalInt(oTarget, "SC_ITEM_AC_NATURAL", iACNatural-iACNaturalPenalty );
    SetLocalInt(oTarget, "SC_ITEM_AC_ARMOR", iACArmor-iACArmorPenalty );
    SetLocalInt(oTarget, "SC_ITEM_AC_SHIELD", iACShield-iACShieldPenalty );
    SetLocalInt(oTarget, "SC_ITEM_AC_DEFLECTION", iACDeflection-iACDeflectionPenalty );
    
    SetLocalInt(oTarget, "SC_ITEM_DAMAGE_RESIST_TYPES", iDamageResistanceType );
    // fixed amount of damage reductions per attack
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_MAGICAL),iDamResistMagic);
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_ACID),iDamResistAcid);
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_COLD),iDamResistCold);
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_DIVINE),iDamResistDivine);
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_ELECTRICAL),iDamResistElectrical);
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_FIRE),iDamResistFire);
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_NEGATIVE),iDamResistNegative);
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_POSITIVE),iDamResistPositive);
    SetLocalInt( oTarget, "SC_ITEM_DAMAGE_RESIST_"+IntToString(DAMAGE_TYPE_SONIC),iDamResistSonic);
    // immunity by percentage of attack, 0.0f to 100.0f
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_MAGICAL),fDamImmuneMagic);
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_ACID),fDamImmuneAcid);
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_COLD),fDamImmuneCold);
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_DIVINE),fDamImmuneDivine);
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_ELECTRICAL),fDamImmuneElectrical);
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_FIRE),fDamImmuneFire);
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_NEGATIVE),fDamImmuneNegative);
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_POSITIVE),fDamImmunePositive);
    SetLocalFloat( oTarget, "SC_ITEM_DAMAGE_IMMUNE_"+IntToString(DAMAGE_TYPE_SONIC),fDamImmuneSonic);
    
    SetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_TYPES", abilityMask);
    SetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_STRENGTH), iAbilIncreaseStrength-iAbilDecreaseStrength);
	SetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_DEXTERITY), iAbilIncreaseDexterity-iAbilDecreaseDexterity);
	SetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_CONSTITUTION), iAbilIncreaseConstitution-iAbilDecreaseConstitution);
	SetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_INTELLIGENCE), iAbilIncreaseIntelligence-iAbilDecreaseIntelligence);
	SetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_WISDOM), iAbilIncreaseWisdom-iAbilDecreaseWisdom);
	SetLocalInt(oTarget, "SC_ITEM_ABILITY_INCREASE_"+IntToString(ABILITY_CHARISMA), iAbilIncreaseCharisma-iAbilDecreaseCharisma);
    
    
	SetLocalInt( oTarget , "SC_ITEM_SR", iSpellResistance );
	SetLocalInt( oTarget , "SC_ITEM_SPELLIMMUNITY_BY_LEVEL", iSpellLevelProt );
	
	SetLocalInt(oTarget, "SC_ITEM_IMMUNITY_SCHOOLS", iSchoolImmunityMask);
    SetLocalString(oTarget, "SC_ITEM_IMMUNITY_SPELLS", sSpecificSpellImmunity);
	
	SetLocalInt(oTarget, "SC_ITEM_REGENERATION_RATE", iRegenerationRate);
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLLightPropToString(int nLight)
{
	if (nLight==IP_CONST_LIGHTCOLOR_BLUE  ) return "Blue";
	if (nLight==IP_CONST_LIGHTCOLOR_YELLOW) return "Yellow";
	if (nLight==IP_CONST_LIGHTCOLOR_PURPLE) return "Purple";
	if (nLight==IP_CONST_LIGHTCOLOR_RED   ) return "Red";
	if (nLight==IP_CONST_LIGHTCOLOR_GREEN ) return "Green";
	if (nLight==IP_CONST_LIGHTCOLOR_ORANGE) return "Orange";
	if (nLight==IP_CONST_LIGHTCOLOR_WHITE ) return "White";
	return "MissLight" + IntToString(nLight);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLVisualEffectToString(int nVE)
{
	if (nVE==ITEM_VISUAL_ACID   )    return "Acid";
	if (nVE==ITEM_VISUAL_COLD)       return "Cold";
	if (nVE==ITEM_VISUAL_ELECTRICAL) return "Electrical";
	if (nVE==ITEM_VISUAL_EVIL)       return "Evil";
	if (nVE==ITEM_VISUAL_FIRE   )    return "Fire";
	if (nVE==ITEM_VISUAL_HOLY)       return "Holy";
	if (nVE==ITEM_VISUAL_SONIC  )    return "Sonic";
	return "MissVisualEffect" + IntToString(nVE);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLSaveVsBonusToString(int iSaveType)
{
	if (iSaveType==IP_CONST_SAVEVS_ACID         ) return "Acid";
	if (iSaveType==IP_CONST_SAVEVS_COLD         ) return "Cold";
	if (iSaveType==IP_CONST_SAVEVS_DEATH        ) return "Death";
	if (iSaveType==IP_CONST_SAVEVS_DISEASE      ) return "Disease";
	if (iSaveType==IP_CONST_SAVEVS_DIVINE       ) return "Divine";
	if (iSaveType==IP_CONST_SAVEVS_ELECTRICAL   ) return "Electrical";
	if (iSaveType==IP_CONST_SAVEVS_FEAR         ) return "Fear";
	if (iSaveType==IP_CONST_SAVEVS_FIRE         ) return "Fire";
	if (iSaveType==IP_CONST_SAVEVS_MINDAFFECTING) return "Mindaffecting";
	if (iSaveType==IP_CONST_SAVEVS_NEGATIVE     ) return "Negative";
	if (iSaveType==IP_CONST_SAVEVS_POISON       ) return "Poison";
	if (iSaveType==IP_CONST_SAVEVS_POSITIVE     ) return "Positive";
	if (iSaveType==IP_CONST_SAVEVS_SONIC        ) return "Sonic";
	if (iSaveType==IP_CONST_SAVEVS_UNIVERSAL    ) return "Universal";
	return "MissSaveVs" + IntToString(iSaveType);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLSaveBaseTypeToString(int iSaveType)
{
	//if (iSaveType==IP_CONST_SAVEBASETYPE_All)       return"All";
	if (iSaveType==IP_CONST_SAVEBASETYPE_FORTITUDE) return"Fortitude";
	if (iSaveType==IP_CONST_SAVEBASETYPE_WILL     ) return"Will";
	if (iSaveType==IP_CONST_SAVEBASETYPE_REFLEX   ) return"Reflex";
	return "MissSaveSpec" + IntToString(iSaveType);
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLDamageBonusValue(int nDamageBonus)
{
	// Returns total damage done by property
	// Fixed damage ones are doubled due to lack of randomness
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1    ) return  2;// 1
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2    ) return  4;//  2;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_3    ) return  6;//  3;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4    ) return  8;//  4;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_5    ) return  10;//  5;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d4  ) return  4;//  6;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d6  ) return  6;//  7;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d8  ) return  8;//  8;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d10 ) return  10;//  9;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d6  ) return  12;//  10;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d8  ) return  16;//  11;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d4  ) return  8;//  12;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d10 ) return  20;//  13;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_1d12 ) return  12;//  14;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_2d12 ) return  24;//  15;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_6    ) return  12;//  16;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_7    ) return  14;//  17;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_8    ) return  16;//  18;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_9    ) return  18;//  19;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_10   ) return  20;//  20;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_3d10	) return  30;//  51;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_3d12	) return  36;//  52;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4d6  ) return  24;//  53;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4d8  ) return  32;//  54;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4d10	) return  40;// 55;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_4d12 ) return  48;// 56;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_5d6  ) return  30;// 57;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_5d12	) return  60;//  58;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_6d12	) return  72;//  59;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_3d6  ) return  18;// 60;
	if (nDamageBonus==IP_CONST_DAMAGEBONUS_6d6  ) return  36;//  61;
	return 1;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIPDamageTypeByDamageType(int iDamageType)
{
	if (iDamageType==DAMAGE_TYPE_ACID)			return IP_CONST_DAMAGETYPE_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)			return IP_CONST_DAMAGETYPE_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)		return IP_CONST_DAMAGETYPE_DIVINE; // VFX_HIT_SPELL_SEARING_LIGHT;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return IP_CONST_DAMAGETYPE_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)			return IP_CONST_DAMAGETYPE_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)		return IP_CONST_DAMAGETYPE_MAGICAL;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return IP_CONST_DAMAGETYPE_NEGATIVE; // VFX_HIT_SPELL_EVIL;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)		return IP_CONST_DAMAGETYPE_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)			return IP_CONST_DAMAGETYPE_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return IP_CONST_DAMAGETYPE_BLUDGEONING; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_PIERCING)		return IP_CONST_DAMAGETYPE_PIERCING; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_SLASHING)		return IP_CONST_DAMAGETYPE_SLASHING; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_ALL)			return IP_CONST_DAMAGETYPE_BLUDGEONING;
	return IP_CONST_DAMAGETYPE_BLUDGEONING;
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetDamageTypeByIPConstDamageType(int iIPConstDamageType)
{
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_ACID)			return DAMAGE_TYPE_ACID;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_COLD)			return DAMAGE_TYPE_COLD;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_DIVINE)		return DAMAGE_TYPE_DIVINE;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_ELECTRICAL)	return DAMAGE_TYPE_ELECTRICAL;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_FIRE)			return DAMAGE_TYPE_FIRE;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_MAGICAL)		return DAMAGE_TYPE_MAGICAL;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_NEGATIVE)		return DAMAGE_TYPE_NEGATIVE;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_POSITIVE)		return DAMAGE_TYPE_POSITIVE;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_SONIC)			return DAMAGE_TYPE_SONIC;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_BLUDGEONING)	return DAMAGE_TYPE_BLUDGEONING;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_PIERCING)		return DAMAGE_TYPE_PIERCING;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_SLASHING)		return DAMAGE_TYPE_SLASHING;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_SUBDUAL)		return DAMAGE_TYPE_BLUDGEONING;
	if (iIPConstDamageType==IP_CONST_DAMAGETYPE_PHYSICAL)		return DAMAGE_TYPE_BLUDGEONING;
	return DAMAGE_TYPE_ALL;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLAbilityIPToString(int nAbilityType, int bLong = FALSE)
{
	if (nAbilityType==IP_CONST_ABILITY_STR) return (bLong) ? "Strength"      : "STR";
	if (nAbilityType==IP_CONST_ABILITY_DEX) return (bLong) ? "Dexterity"     : "DEX";
	if (nAbilityType==IP_CONST_ABILITY_CON) return (bLong) ? "Consititution" : "CON";
	if (nAbilityType==IP_CONST_ABILITY_INT) return (bLong) ? "Intelligence"  : "INT";
	if (nAbilityType==IP_CONST_ABILITY_WIS) return (bLong) ? "Wisdom"        : "WIS";
	if (nAbilityType==IP_CONST_ABILITY_CHA) return (bLong) ? "Charisma"      : "CHA";
	return "Missing Ability Text";
}




/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLIPDamagetypeToString(int iDamageType)
{
	if (iDamageType==IP_CONST_DAMAGETYPE_ACID)       return "Acid";
	if (iDamageType==IP_CONST_DAMAGETYPE_NEGATIVE)   return "Negative";
	if (iDamageType==IP_CONST_DAMAGETYPE_COLD)       return "Cold";
	if (iDamageType==IP_CONST_DAMAGETYPE_POSITIVE)   return "Positive";
	if (iDamageType==IP_CONST_DAMAGETYPE_DIVINE)     return "Divine";
	if (iDamageType==IP_CONST_DAMAGETYPE_SONIC)      return "Sonic";
	if (iDamageType==IP_CONST_DAMAGETYPE_ELECTRICAL) return "Electrical";
	if (iDamageType==IP_CONST_DAMAGETYPE_BLUDGEONING)return "Blunt";
	if (iDamageType==IP_CONST_DAMAGETYPE_FIRE)       return "Fire";
	if (iDamageType==IP_CONST_DAMAGETYPE_PIERCING)   return "Piercing";
	if (iDamageType==IP_CONST_DAMAGETYPE_MAGICAL)    return "Magical";
	if (iDamageType==IP_CONST_DAMAGETYPE_SLASHING)   return "Slashing";
	return "MissDamageType" + IntToString(iDamageType);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLItemPropertyDescToString(int iPropType, int iSubType, int iBonus, int iParam1=0)
{
	switch (iPropType) {
		case ITEM_PROPERTY_ABILITY_BONUS:  
			return CSLAbilityIPToString(iSubType) + "+" + IntToString(iBonus);
		case ITEM_PROPERTY_AC_BONUS:      
			return "AC +" + IntToString(iBonus);
		case ITEM_PROPERTY_ATTACK_BONUS: 
			return "Attack +" + IntToString(iBonus);
		case ITEM_PROPERTY_BONUS_FEAT:
			if (iSubType==37) return "Disarm";
			return "Feat" + IntToString(iSubType);
		case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N: return CSLItemPropClassToString(iSubType) + " Level " + IntToString(iBonus);
		case ITEM_PROPERTY_CAST_SPELL:              
			{
				if (iSubType==335) return "Unique Power Self Only";
				string sSpell = Get2DAString("des_matcomp", "Label", iSubType);
				return "Cast " + sSpell; // "Cast Spell " + IntToString(iSubType);
			}
		case ITEM_PROPERTY_DAMAGE_BONUS:                return CSLIPDamagetypeToString(iSubType) + " " + CSLDamageBonusToString(iBonus);
		case ITEM_PROPERTY_DAMAGE_REDUCTION:            return "Damage Reduction " + CSLIPDamagetypeToString(iSubType) + " " + IntToString(iBonus) + "/- ";
		case ITEM_PROPERTY_DAMAGE_RESISTANCE:           return CSLIPDamagetypeToString(iSubType) + " " + CSLDamageResistanceToString(iBonus);
		case ITEM_PROPERTY_DARKVISION:                  return "Darkvision";
		case ITEM_PROPERTY_DECREASED_SAVING_THROWS:     return CSLSaveVsBonusToString(iSubType) + " save -" + IntToString(iBonus);
		case ITEM_PROPERTY_ENHANCEMENT_BONUS:           return "Enhancement +" + IntToString(iBonus);
		case ITEM_PROPERTY_HASTE:                       return "Haste";
		case ITEM_PROPERTY_HOLY_AVENGER:                return "Holy Avenger";
		case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:        return CSLIPDamagetypeToString(iSubType) + " immunity " + CSLDamageImmunityToString(iBonus);
		case ITEM_PROPERTY_KEEN:                        return "Keen";
		case ITEM_PROPERTY_LIGHT:                       return CSLLightPropToString(iParam1) + " Light";
		case ITEM_PROPERTY_MASSIVE_CRITICALS:           return "Massive Crits" + CSLDamageBonusToString(iBonus);
		case ITEM_PROPERTY_MIGHTY:                      return "Mighty +" + IntToString(iBonus);
		case ITEM_PROPERTY_ON_HIT_PROPERTIES:           return "On Hit " + CSLOnHitTypeToString(iSubType) + " " + CSLOnHitDCToString(iBonus);
		case ITEM_PROPERTY_REGENERATION:                return "Regeneration +" + IntToString(iBonus);
		case ITEM_PROPERTY_REGENERATION_VAMPIRIC:       return "Vampiric Regen +" + IntToString(iBonus);
		case ITEM_PROPERTY_SAVING_THROW_BONUS:          return "Save Vs " + CSLSaveVsBonusToString(iSubType) + " +" + IntToString(iBonus);
		case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC: return CSLSaveBaseTypeToString(iSubType) + " +" + IntToString(iBonus);
		case ITEM_PROPERTY_SKILL_BONUS:                 return CSLSkillTypeToString(iSubType) + " +" + IntToString(iBonus);
		case ITEM_PROPERTY_SPELL_RESISTANCE:            return "Spell Resistance " + CSLSpellResistanceToString(iBonus);
		case ITEM_PROPERTY_VISUALEFFECT:                return "Visual Effect " + CSLVisualEffectToString(iSubType);
		case ITEM_PROPERTY_UNLIMITED_AMMUNITION:        return "Unlimited Ammo: " + CSLUnlimitedAmmoDescToString(iBonus);
	}
	return "MissItemProperty " + IntToString(iPropType) + " : " + IntToString(iSubType) + " : " + IntToString(iBonus);
}



/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetItemHasProperty(object oItem, itemproperty ipCompareTo, int nDurationCompare, int bIgnoreSubType = FALSE)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    //PrintString ("Filter - T:" + IntToString(GetItemPropertyType(ipCompareTo))+ " S: " + IntToString(GetItemPropertySubType(ipCompareTo)) + " (Ignore: " + IntToString (bIgnoreSubType) + ") D:" + IntToString(nDurationCompare));
    while (GetIsItemPropertyValid(ip))
    {
        // PrintString ("Testing - T: " + IntToString(GetItemPropertyType(ip)));
        if ((GetItemPropertyType(ip) == GetItemPropertyType(ipCompareTo)))
        {
             //PrintString ("**Testing - S: " + IntToString(GetItemPropertySubType(ip)));
             if (GetItemPropertySubType(ip) == GetItemPropertySubType(ipCompareTo) || bIgnoreSubType)
             {
               // PrintString ("***Testing - d: " + IntToString(GetItemPropertyDurationType(ip)));
                if (GetItemPropertyDurationType(ip) == nDurationCompare || nDurationCompare == -1)
                {
                    //PrintString ("***FOUND");
                      return TRUE; // if duration is not ignored and durationtypes are equal, true
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    //PrintString ("Not Found");
    return FALSE;
}



/**  
* Removes all itemproperties with matching nItemPropertyType and
* nItemPropertyDuration (a DURATION_TYPE_* constant)
* @author
* @param 
* @see 
* @replaces XXXIPRemoveMatchingItemProperties
* @return 
*/
void CSLRemoveMatchingItemProperties(object oItem, int nItemPropertyType, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY, int nItemPropertySubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    // valid ip?
    while (GetIsItemPropertyValid(ip))
    {
        // same property type?
        if ( GetItemPropertyType(ip) == nItemPropertyType )
        {
            // same duration or duration ignored?
            if ( nItemPropertyDuration == -1 || GetItemPropertyDurationType(ip) == nItemPropertyDuration )
            {
                 // same subtype or subtype ignored
                 if ( nItemPropertySubType == -1 || GetItemPropertySubType(ip) == nItemPropertySubType )
                 {
                      // Put a warning into the logfile if someone tries to remove a permanent ip with a temporary one!
                      /*if (nItemPropertyDuration == DURATION_TYPE_TEMPORARY &&  GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
                      {
                         WriteTimestampedLogEntry("_CSLCore_Items:: CSLRemoveMatchingItemProperties() - WARNING: Permanent item property removed by temporary on "+GetTag(oItem));
                      }
                      */
                      RemoveItemProperty(oItem, ip);
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
}


/**  
* Removes all temporary itemproperties with option to filter by matching nItemPropertyType and nItemPropertySubType
* nItemPropertyType (a ITEM_PROPERTY_* constant)
* nItemPropertySubType ( refers to a value in a 2da file based on property type)
* @author
* @param 
* @see 
* @replaces XXXClearTempItemProps
* @return 
*/
void CSLRemoveTemporaryItemProperties(object oItem, int nItemPropertyType = -1, int nItemPropertySubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    // valid ip?
    while (GetIsItemPropertyValid(ip))
    {
		// same duration or duration ignored?
		if (GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY )
		{
			// same property type?
			if ( nItemPropertyType == -1 || GetItemPropertyType(ip) == nItemPropertyType)
			{
                 // same subtype or subtype ignored
                 if  ( nItemPropertySubType == -1 || GetItemPropertySubType(ip) == nItemPropertySubType )
                 {
                      // Put a warning into the logfile if someone tries to remove a permanent ip with a temporary one!
                      /*if (nItemPropertyDuration == DURATION_TYPE_TEMPORARY &&  GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
                      {
                         WriteTimestampedLogEntry("_CSLCore_Items:: CSLRemoveMatchingItemProperties() - WARNING: Permanent item property removed by temporary on "+GetTag(oItem));
                      }
                      */
                      RemoveItemProperty(oItem, ip);
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
}

/**  
* Add an item property in a safe fashion, preventing unwanted stacking
* Parameters:
*   oItem     - the item to add the property to
*   ip        - the itemproperty to add
*   fDuration - set 0.0f to add the property permanent, anything else is temporary
*   nAddItemPropertyPolicy - How to handle existing properties. Valid values are:
*     SC_IP_ADDPROP_POLICY_REPLACE_EXISTING - remove any property of the same type, subtype, durationtype before adding;
*     SC_IP_ADDPROP_POLICY_KEEP_EXISTING - do not add if any property with same type, subtype and durationtype already exists;
*     SC_IP_ADDPROP_POLICY_IGNORE_EXISTING - add itemproperty in any case - Do not Use with OnHit or OnHitSpellCast props!
*   bIgnoreDurationType  - If set to TRUE, an item property will be considered identical even if the DurationType is different. Be careful when using this
*                          with SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, as this could lead to a temporary item property removing a permanent one
*   bIgnoreSubType       - If set to TRUE an item property will be considered identical even if the SubType is different.
* 
* * WARNING: This function is used all over the game. Touch it and break it and the wrath
*            of the gods will come down on you faster than you can saz "I didn't do it"
* @author
* @param 
* @see 
* @replaces XXXIPSafeAddItemProperty
* @return 
*/
void CSLSafeAddItemProperty(object oItem, itemproperty ip, float fDuration =0.0f, int nAddItemPropertyPolicy = SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, int bIgnoreDurationType = FALSE, int bIgnoreSubType = FALSE)
{
    int nType = GetItemPropertyType(ip);
    int nSubType = GetItemPropertySubType(ip);
    int iDuration;
    // if duration is 0.0f, make the item property permanent
    if (fDuration == 0.0f)
    {

        iDuration = DURATION_TYPE_PERMANENT;
    } else
    {

        iDuration = DURATION_TYPE_TEMPORARY;
    }

    int nDurationCompare = iDuration;
    if (bIgnoreDurationType)
    {
        nDurationCompare = -1;
    }

    if (nAddItemPropertyPolicy == SC_IP_ADDPROP_POLICY_REPLACE_EXISTING)
    {

        // remove any matching properties
        if (bIgnoreSubType)
        {
            nSubType = -1;
        }
        CSLRemoveMatchingItemProperties(oItem, nType, nDurationCompare, nSubType );
    }
    else if (nAddItemPropertyPolicy == SC_IP_ADDPROP_POLICY_KEEP_EXISTING )
    {
         // do not replace existing properties
        if(CSLGetItemHasProperty(oItem, ip, nDurationCompare, bIgnoreSubType))
        {
          return; // item already has property, return
        }
    }
    else //SC_IP_ADDPROP_POLICY_IGNORE_EXISTING
    {

    }

    if (iDuration == DURATION_TYPE_PERMANENT)
    {
        AddItemProperty(iDuration,ip, oItem);
    }
    else
    {
        AddItemProperty(iDuration,ip, oItem,fDuration);
    }
}

/**  
* Removes ALL item properties from oItem matching nItemPropertyDuration
* @author
* @param 
* @see 
* @replaces XXXIPRemoveAllItemProperties
* @return 
*/
void CSLRemoveAllItemProperties(object oItem, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyDurationType(ip) == nItemPropertyDuration)
        {
            RemoveItemProperty(oItem, ip);
        }
        ip = GetNextItemProperty(oItem);
    }
}


/*
sorted list of item property constants from NWScript.nss
int ITEM_PROPERTY_ABILITY_BONUS                            = 0 ;
int ITEM_PROPERTY_AC_BONUS                                 = 1 ;
int ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP              = 2 ;
int ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE                  = 3 ;
int ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP                 = 4 ;
int ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT           = 5 ;
int ITEM_PROPERTY_ARCANE_SPELL_FAILURE                     = 84;
int ITEM_PROPERTY_ATTACK_BONUS                             = 56 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP          = 57 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP             = 58 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT       = 59 ;
int ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION               = 11 ;
int ITEM_PROPERTY_BONUS_FEAT                               = 12 ;
int ITEM_PROPERTY_BONUS_HITPOINTS                          = 66 ;
int ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N              = 13 ;
int ITEM_PROPERTY_CAST_SPELL                               = 15 ;
int ITEM_PROPERTY_DAMAGE_BONUS                             = 16 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP          = 17 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP             = 18 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT       = 19 ;
int ITEM_PROPERTY_DAMAGE_REDUCTION              		   = 90 ; 
int ITEM_PROPERTY_DAMAGE_REDUCTION_DEPRECATED              = 22 ; // not called
int ITEM_PROPERTY_DAMAGE_RESISTANCE                        = 23 ;
int ITEM_PROPERTY_DAMAGE_VULNERABILITY                     = 24 ;
int ITEM_PROPERTY_DARKVISION                               = 26 ;
int ITEM_PROPERTY_DECREASED_ABILITY_SCORE                  = 27 ;
int ITEM_PROPERTY_DECREASED_AC                             = 28 ;
int ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER                = 60 ;
int ITEM_PROPERTY_DECREASED_DAMAGE                         = 21 ;
int ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER           = 10 ;
int ITEM_PROPERTY_DECREASED_SAVING_THROWS                  = 49 ;
int ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC         = 50 ;
int ITEM_PROPERTY_DECREASED_SKILL_MODIFIER                 = 29 ;
int ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT        = 32 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS                        = 6 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP     = 7 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP        = 8 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT = 9 ;
int ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE                  = 33 ;
int ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE                 = 34 ;
int ITEM_PROPERTY_FREEDOM_OF_MOVEMENT                      = 75 ;
int ITEM_PROPERTY_HASTE                                    = 35 ;
int ITEM_PROPERTY_HEALERS_KIT                              = 80;
int ITEM_PROPERTY_HOLY_AVENGER                             = 36 ;
int ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE                     = 20 ;
int ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS                   = 37 ;
int ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL                  = 53 ;
int ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL                    = 54 ;
int ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL                 = 78 ;
int ITEM_PROPERTY_IMPROVED_EVASION                         = 38 ;
int ITEM_PROPERTY_KEEN                                     = 43 ;
int ITEM_PROPERTY_LIGHT                                    = 44 ;
int ITEM_PROPERTY_MASSIVE_CRITICALS                        = 74 ;
int ITEM_PROPERTY_MIGHTY                                   = 45 ;
int ITEM_PROPERTY_MIND_BLANK                               = 46 ;
int ITEM_PROPERTY_MONSTER_DAMAGE                           = 77 ;
int ITEM_PROPERTY_NO_DAMAGE                                = 47 ;
int ITEM_PROPERTY_ON_HIT_PROPERTIES                        = 48 ;
int ITEM_PROPERTY_ON_MONSTER_HIT                           = 72 ;
int ITEM_PROPERTY_ONHITCASTSPELL                           = 82;
int ITEM_PROPERTY_POISON                                   = 76 ; // no longer working, poison is now a on_hit subtype
int ITEM_PROPERTY_REGENERATION                             = 51 ;
int ITEM_PROPERTY_REGENERATION_VAMPIRIC                    = 67 ;
int ITEM_PROPERTY_SAVING_THROW_BONUS                       = 40 ;
int ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC              = 41 ;
int ITEM_PROPERTY_SKILL_BONUS                              = 52 ;
int ITEM_PROPERTY_SPECIAL_WALK                             = 79;
int ITEM_PROPERTY_SPELL_RESISTANCE                         = 39 ;
int ITEM_PROPERTY_THIEVES_TOOLS                            = 55 ;
int ITEM_PROPERTY_TRAP                                     = 70 ;
int ITEM_PROPERTY_TRUE_SEEING                              = 71 ;
int ITEM_PROPERTY_TURN_RESISTANCE                          = 73 ;
int ITEM_PROPERTY_UNLIMITED_AMMUNITION                     = 61 ;
int ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP           = 62 ;
int ITEM_PROPERTY_USE_LIMITATION_CLASS                     = 63 ;
int ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE               = 64 ;
int ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT        = 65 ;
//int ITEM_PROPERTY_USE_LIMITATION_TILESET                   = 66 ; <- replaced by ITEM_PROPERTY_BONUS_HITPOINTS
int ITEM_PROPERTY_VISUALEFFECT	                           = 83;
int ITEM_PROPERTY_WEIGHT_INCREASE                          = 81;

*/	

	
/**  
* This function needs to be rather extensive and needs to be updated if there are new
* ip types we want to use, but it goes into the item property include anyway
* ChazM - updated 11/17/06
* @author
* @param 
* @see 
* @replaces XXXIPGetItemPropertyByID
* @return 
*/
itemproperty CSLGetItemPropertyByID(int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0)
{
   itemproperty ipRet;

   if (nPropID == ITEM_PROPERTY_ABILITY_BONUS) // 0 
   {
        ipRet = ItemPropertyAbilityBonus(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS) // 1 
   {
        ipRet = ItemPropertyACBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP) // 2
   {
        ipRet = ItemPropertyACBonusVsAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE) // 3
   {
        ipRet = ItemPropertyACBonusVsDmgType(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP) // 4
   {
        ipRet = ItemPropertyACBonusVsRace(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) // 5
   {
        ipRet = ItemPropertyACBonusVsSAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ARCANE_SPELL_FAILURE) // 84
   {
        ipRet = ItemPropertyArcaneSpellFailure(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS) //56
   {
        ipRet = ItemPropertyAttackBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP) //57
   {
        ipRet = ItemPropertyAttackBonusVsAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP) // 58
   {
        ipRet = ItemPropertyAttackBonusVsRace(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT) // 59
   {
        ipRet = ItemPropertyAttackBonusVsSAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION) // 11
   {
        ipRet = ItemPropertyWeightReduction(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_BONUS_FEAT) // 12
   {
        ipRet = ItemPropertyBonusFeat(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N) // 13
   {
        ipRet = ItemPropertyBonusLevelSpell(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_CAST_SPELL) // 15
   {
        ipRet = ItemPropertyCastSpell(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS) // 16
   {
        ipRet = ItemPropertyDamageBonus(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP) // 17
   {
        ipRet = ItemPropertyDamageBonusVsAlign(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP) // 18
   {
        ipRet = ItemPropertyDamageBonusVsRace(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT) // 19
   {
        ipRet = ItemPropertyDamageBonusVsSAlign(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_REDUCTION) // 22 // JLR-OEI 04/03/06: NOW it is 85 (old one is deprecated!)
   {
        ipRet = ItemPropertyDamageReduction(nParam1, nParam2, nParam3, nParam4);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_RESISTANCE) // 23
   {
        ipRet = ItemPropertyDamageResistance(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_VULNERABILITY) // 24
   {
        ipRet = ItemPropertyDamageVulnerability(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DARKVISION) // 26
   {
        ipRet = ItemPropertyDarkvision();
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ABILITY_SCORE) // 27
   {
        ipRet = ItemPropertyDecreaseAbility(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_AC) // 28
   {
        ipRet = ItemPropertyDecreaseAC(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER) // 60
   {
        ipRet = ItemPropertyAttackPenalty(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_DAMAGE) // 21
   {
        ipRet = ItemPropertyDamagePenalty(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER) // 10
   {
        ipRet = ItemPropertyEnhancementPenalty(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_SAVING_THROWS) // 49
   {
        ipRet = ItemPropertyReducedSavingThrow(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC) // 50
   {
        ipRet = ItemPropertyReducedSavingThrowVsX(nParam1, nParam2);
   }
    else if (nPropID == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER) //29
   {
        ipRet = ItemPropertyDecreaseSkill(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT) //32
   {
        ipRet = ItemPropertyContainerReducedWeight(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS) // 6
   {
        ipRet = ItemPropertyEnhancementBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP) // 7
   {
        ipRet = ItemPropertyEnhancementBonusVsAlign(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT) // 8
   {
        ipRet = ItemPropertyEnhancementBonusVsSAlign(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP) // 9
   {
        ipRet = ItemPropertyEnhancementBonusVsRace(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE) // 33
   {
        ipRet = ItemPropertyExtraMeleeDamageType(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE) // 34
   {
        ipRet = ItemPropertyExtraRangeDamageType(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_FREEDOM_OF_MOVEMENT) // 75
   {
        ipRet = ItemPropertyFreeAction();
   }
   else if (nPropID == ITEM_PROPERTY_HASTE) // 35
   {
        ipRet = ItemPropertyHaste();
   }
   else if (nPropID == ITEM_PROPERTY_HEALERS_KIT) // 80
   {
        ipRet = ItemPropertyHealersKit(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_HOLY_AVENGER) // 36
   {
        ipRet = ItemPropertyHolyAvenger();
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE) // 20
   {
        ipRet = ItemPropertyDamageImmunity(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS) // 37
   {
        ipRet = ItemPropertyImmunityMisc(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL) // 53
   {
        ipRet = ItemPropertySpellImmunitySpecific(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL) // 54
   {
        ipRet = ItemPropertySpellImmunitySchool(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL) // 78 
   {
        ipRet = ItemPropertyImmunityToSpellLevel(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_IMPROVED_EVASION) // 38
   {
        ipRet = ItemPropertyImprovedEvasion();
   }
   else if (nPropID == ITEM_PROPERTY_KEEN) // 43
   {
        ipRet = ItemPropertyKeen();
   }
   else if (nPropID == ITEM_PROPERTY_LIGHT) // 44
   {
        ipRet = ItemPropertyLight(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_MASSIVE_CRITICALS) // 74
   {
        ipRet = ItemPropertyMassiveCritical(nParam1);
   }
/*	
   else if (nPropID == ITEM_PROPERTY_MIGHTY) // 45
   {
        ipRet = ?(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_MIND_BLANK) // 46
   {
        ipRet = ?(nParam1);
   }
*/	
   else if (nPropID == ITEM_PROPERTY_MONSTER_DAMAGE) // 77
   {
        ipRet = ItemPropertyMonsterDamage(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_NO_DAMAGE) // 47
   {
        ipRet = ItemPropertyNoDamage();
   }
   else if (nPropID == ITEM_PROPERTY_ON_HIT_PROPERTIES) // 48
   {
        ipRet = ItemPropertyOnHitProps(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_ON_MONSTER_HIT) // 72
   {
        ipRet = ItemPropertyOnMonsterHitProperties(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ONHITCASTSPELL) // 82
   {
        ipRet = ItemPropertyOnHitCastSpell(nParam1, nParam2);
   }
/*	
   else if (nPropID == ITEM_PROPERTY_POISON) // 76
   {	
		//NWSCRIPT.nss: no longer working, poison is now a on_hit subtype
        ipRet = ();
   }
*/
	else if (nPropID == ITEM_PROPERTY_REGENERATION) // 51
	{
	     ipRet = ItemPropertyRegeneration(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_REGENERATION_VAMPIRIC) // 67
	{
	     ipRet = ItemPropertyVampiricRegeneration(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_SAVING_THROW_BONUS) // 40
	{
	     ipRet = ItemPropertyBonusSavingThrow(nParam1, nParam2);
	}
	else if (nPropID == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC) // 41
	{
	     ipRet = ItemPropertyBonusSavingThrowVsX(nParam1, nParam2);
	}
	
	else if (nPropID == ITEM_PROPERTY_SKILL_BONUS) // 52
	{
	     ipRet = ItemPropertySkillBonus(nParam1, nParam2);
	}
	else if (nPropID == ITEM_PROPERTY_SPECIAL_WALK) // 79
	{
	     ipRet = ItemPropertySpecialWalk(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_SPELL_RESISTANCE)
	{
	     ipRet = ItemPropertyBonusSpellResistance(nParam1); // 39
	}
	else if (nPropID == ITEM_PROPERTY_THIEVES_TOOLS)
	{
	     ipRet = ItemPropertyThievesTools(nParam1); // 55
	}
	else if (nPropID == ITEM_PROPERTY_TRAP) // 70
	{
	     ipRet = ItemPropertyTrap(nParam1, nParam2);
	}
	else if (nPropID == ITEM_PROPERTY_TRUE_SEEING) // 71
	{
	     ipRet = ItemPropertyTrueSeeing();
	}
	else if (nPropID == ITEM_PROPERTY_TURN_RESISTANCE) // 73
	{
	     ipRet = ItemPropertyTurnResistance(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_UNLIMITED_AMMUNITION) // 61
	{
	     ipRet = ItemPropertyUnlimitedAmmo(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP) // 62
	{
	     ipRet = ItemPropertyLimitUseByAlign(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_CLASS) // 63
	{
	     ipRet = ItemPropertyLimitUseByClass(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE) // 64
	{
	     ipRet = ItemPropertyLimitUseByRace(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT) // 65
	{
	     ipRet = ItemPropertyLimitUseBySAlign(nParam1);
	}
/*
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_TILESET) // 66
	{
	     ipRet = ();
	}
*/

	else if (nPropID == ITEM_PROPERTY_VISUALEFFECT) // 83
	{
	     ipRet = ItemPropertyVisualEffect(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_WEIGHT_INCREASE) // 81 
	{
	     ipRet = ItemPropertyWeightIncrease(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_BONUS_HITPOINTS) // 86
	{
	     ipRet = ItemPropertyBonusHitpoints(nParam1);
	}

   return ipRet;
}


/**  
* Return the IP_CONST_CASTSPELL_* ID matching to the SPELL_* constant given
* in nSPELL_ID.
* This uses Get2DAstring, so it is slow. Avoid using in loops!
* returns -1 if there is no matching property for a spell
* @author
* @param 
* @see 
* @replaces XXXIPGetIPConstCastSpellFromSpellID
* @return 
*/
int CSLGetIPConstCastSpellFromSpellID(int nSpellID)
{
    // look up Spell Property Index
    string sTemp = Get2DAString("des_crft_spells","IPRP_SpellIndex",nSpellID);
    /*
    if (sTemp == "") // invalid nSpellID
    {
        PrintString("x2_inc_craft.nss::GetIPConstCastSpellFromSpellID called with invalid nSpellID" + IntToString(nSpellID));
        return -1;
    }
    */
    int nSpellPrpIdx = StringToInt(sTemp);
    return nSpellPrpIdx;
}


/**  
* Returns TRUE if an item has ITEM_PROPERTY_ON_HIT and the specified nSubType
* possible values for nSubType can be taken from IPRP_ONHIT.2da
* popular ones:
*       5 - Daze
*      19 - ItemPoison
*      24 - Vorpal
* @author
* @param 
* @see 
* @replaces XXXIPGetItemHasItemOnHitPropertySubType
* @return 
*/
int CSLGetItemHasItemOnHitPropertySubType(object oTarget, int nSubType)
{
    if (GetItemHasItemProperty(oTarget,ITEM_PROPERTY_ON_HIT_PROPERTIES))
    {
        itemproperty ipTest = GetFirstItemProperty(oTarget);

        // loop over item properties to see if there is already a poison effect
        while (GetIsItemPropertyValid(ipTest))
        {

            if (GetItemPropertySubType(ipTest) == nSubType)   //19 == onhit poison
            {
                return TRUE;
            }

          ipTest = GetNextItemProperty(oTarget);

         }
    }
    return FALSE;
}

/**  
* Creates a special ring on oCreature that gives
* all weapon and armor proficiencies to the wearer
* Item is set non dropable
* @author
* @param 
* @see 
* @replaces XXXIPCreateProficiencyFeatItemOnCreature
* @return 
*/
object CSLCreateProficiencyFeatItemOnCreature(object oCreature)
{
    // create a simple golden ring
    object  oRing = CreateItemOnObject("nw_it_mring023",oCreature);

    // just in case
    SetDroppableFlag(oRing, FALSE);

    itemproperty ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_HEAVY);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_MEDIUM);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_EXOTIC);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);

    return oRing;
}

/**  
* Returns FALSE it the item has no sequencer property
* Returns number of spells that can be stored in any other case
* @author
* @param 
* @see 
* @replaces XXXIPGetItemSequencerProperty
* @return 
*/
int CSLGetItemSequencerProperty(object oItem)
{
    if (!GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL))
    {
        return FALSE;
    }

    int nCnt;
    itemproperty ip;

    ip = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ip) && nCnt ==0)
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_CAST_SPELL)
        {
            if(GetItemPropertySubType(ip) == 523) // sequencer 3
            {
                nCnt =  3;
            }
            else if(GetItemPropertySubType(ip) == 522) // sequencer 2
            {
                nCnt =  2;
            }
            else if(GetItemPropertySubType(ip) == 521) // sequencer 1
            {
                nCnt =  1;
            }
        }
        ip = GetNextItemProperty(oItem);
    }

    return nCnt;
}

//------------------------------------------------------------------------------
// Created Brent Knowles, Georg Zoeller 2003-07-31
// Returns TRUE (and charges the sequencer item) if the spell
// ... was cast on an item AND
// ... the item has the sequencer property
// ... the spell was non hostile
// ... the spell was not cast from an item
// in any other case, FALSE is returned an the normal spellscript will be run
//------------------------------------------------------------------------------
int CSLGetSpellCastOnSequencerItem(object oItem)
{

    if (!GetIsObjectValid(oItem))
    {
        return FALSE;
    }

    int nMaxSeqSpells = CSLGetItemSequencerProperty(oItem); // get number of maximum spells that can be stored
    if (nMaxSeqSpells <1)
    {
        return FALSE;
    }

    if (GetIsObjectValid(GetSpellCastItem())) // spell cast from item?
    {
        // we allow scrolls
        int nBt = GetBaseItemType(GetSpellCastItem());
        if ( nBt !=BASE_ITEM_SPELLSCROLL && nBt != 105)
        {
            FloatingTextStrRefOnCreature(83373, OBJECT_SELF);
            return TRUE; // wasted!
        }
    }

    // Check if the spell is marked as hostile in spells.2da
    int nHostile = StringToInt(Get2DAString("spells","HostileSetting",GetSpellId()));
    if(nHostile ==1)
    {
        FloatingTextStrRefOnCreature(83885,OBJECT_SELF);
        return TRUE; // no hostile spells on sequencers, sorry ya munchkins :)
    }

    int nNumberOfTriggers = GetLocalInt(oItem, "X2_L_NUMTRIGGERS");
    // is there still space left on the sequencer?
    if (nNumberOfTriggers < nMaxSeqSpells)
    {
        // success visual and store spell-id on item.
        effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
        nNumberOfTriggers++;
        //NOTE: I add +1 to the SpellId to spell 0 can be used to trap failure
        int nSID = GetSpellId()+1;
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(nNumberOfTriggers), nSID);
        SetLocalInt(oItem, "X2_L_NUMTRIGGERS", nNumberOfTriggers);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
        FloatingTextStrRefOnCreature(83884, OBJECT_SELF);
    }
    else
    {
        FloatingTextStrRefOnCreature(83859,OBJECT_SELF);
    }

    return TRUE; // in any case, spell is used up from here, so do not fire regular spellscript
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXIPCopyItemProperties
* @return 
*/
void CSLCopyItemProperties(object oSource, object oTarget, int bIgnoreCraftProps = TRUE)
{
    itemproperty ip = GetFirstItemProperty(oSource);
    int nSub;

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {
            if (bIgnoreCraftProps)
            {
                if (GetItemPropertyType(ip) ==ITEM_PROPERTY_CAST_SPELL)
                {
                    nSub = GetItemPropertySubType(ip);
                    // filter crafting properties
                    if (nSub != 498 && nSub != 499 && nSub  != 526 && nSub != 527)
                    {
                        AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
                    }
                }
                else
                {
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
                }
            }
            else
            {
                AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
            }
        }
        ip = GetNextItemProperty(oSource);
    }
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXIPGetIsIntelligentWeapon
* @return 
*/
int CSLItemGetIsIntelligentWeapon(object oItem)
{
    int bRet = FALSE ;
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==  ITEM_PROPERTY_ONHITCASTSPELL)
        {
            if (GetItemPropertySubType(ip) == 135)
            {
                return TRUE;
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    return bRet;
}





/**  
* Special Version of Copy Item Properties for use with greater wild shape
* oOld - Item equipped before polymorphing (source for item props)
* oNew - Item equipped after polymorphing  (target for item props)
* bWeapon - Must be set TRUE when oOld is a weapon.
* @author
* @param 
* @see 
* @replaces XXXIPWildShapeCopyItemProperties
* @return 
*/
void CSLWildShapeCopyItemProperties(object oOld, object oNew, int bWeapon = FALSE)
{
    if (GetIsObjectValid(oOld) && GetIsObjectValid(oNew))
    {
        itemproperty ip = GetFirstItemProperty(oOld);
        while (GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyType(ip) != ITEM_PROPERTY_AC_BONUS)
			{
				if (bWeapon)
				{
					if (GetWeaponRanged(oOld) == GetWeaponRanged(oNew)   )
					{
						AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
					}
				}
				else
				{
						AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
				}
            }
            ip = GetNextItemProperty(oOld);
        }
    }
}

/**  
* Returns the current enhancement bonus of a weapon (+1 to +20), 0 if there is
* no enhancement bonus. You can test for a specific type of enhancement bonus
* by passing the appropritate ITEM_PROPERTY_ENHANCEMENT_BONUS* constant into
* nEnhancementBonusType
* @author
* @param 
* @see 
* @replaces XXXIPGetWeaponEnhancementBonus
* @return 
*/
int CSLGetWeaponEnhancementBonus(object oWeapon, int nEnhancementBonusType = ITEM_PROPERTY_ENHANCEMENT_BONUS)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    int nFound = 0;
    while (nFound == 0 && GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==nEnhancementBonusType)
        {
            nFound = GetItemPropertyCostTableValue(ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return nFound;
}


/**  
* Shortcut function to set the enhancement bonus of a weapon to a certain bonus
* Specifying bOnlyIfHigher as TRUE will prevent application of the bonus if the bonus is lower than currently present. Valid values for nBonus are 1 to 20.
* @author
* @param 
* @see 
* @replaces XXXIPSetWeaponEnhancementBonus
* @return 
*/
void CSLSetWeaponEnhancementBonus(object oWeapon, int nBonus, int bOnlyIfHigher = TRUE)
{
    int nCurrent = CSLGetWeaponEnhancementBonus(oWeapon);

    

    if (bOnlyIfHigher && nCurrent > nBonus)
    {
        return;
    }

    if (nBonus < 1 || nBonus > 20 )
    {
        return;
    }
	
	itemproperty ip = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            RemoveItemProperty(oWeapon,ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }

    ip = ItemPropertyEnhancementBonus(nBonus);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapon);
}


/**  
* Shortcut function to upgrade the enhancement bonus of a weapon by the
* number specified in nUpgradeBy. If the resulting new enhancement bonus
* would be out of bounds (>+20), it will be set to +20
* @author
* @param 
* @see 
* @replaces XXXIPUpgradeWeaponEnhancementBonus
* @return 
*/
void CSLUpgradeWeaponEnhancementBonus(object oWeapon, int nUpgradeBy)
{
    int nCurrent = CSLGetWeaponEnhancementBonus(oWeapon);

    itemproperty ip = GetFirstItemProperty(oWeapon);

    int nNew = nCurrent + nUpgradeBy;
    if (nNew <1 )
    {
        nNew = 1;
    }
    else if (nNew >20)
    {
       nNew = 20;
    }

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            RemoveItemProperty(oWeapon,ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }

    ip = ItemPropertyEnhancementBonus(nNew);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapon);

}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXIPGetHasItemPropertyByConst
* @return 
*/
int CSLGetHasItemPropertyByConst(int nItemProp, object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==nItemProp)
        {
            return TRUE;
        }
        ip = GetNextItemProperty(oItem);
    }
    return FALSE;

}

/**  
* Description
* @author 
* @param 
* @see 
* @replaces 
* @return 
*/
void CSLAddItemPropertyVisualEffect(object oPC, int nItemVisual)
{
   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
   itemproperty ipAdd = ItemPropertyVisualEffect(nItemVisual);
   effect AddVfx = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
   if(GetIsObjectValid(oItem))
   {
      CSLRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_VISUALEFFECT, -1);
      CSLSafeAddItemProperty(oItem, ipAdd);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, AddVfx, oPC);
      FloatingTextStringOnCreature("<color=indianred>"+"New visual added!"+"</color>", oPC, FALSE);
   }
   else
   {
      FloatingTextStringOnCreature("<color=indianred>"+"No Item in Righthand Slot!"+"</color>", oPC, FALSE);
   }
}

/**  
* Description
* @author Seed
* @param 
* @see 
* @replaces XXXSetProp
* @return 
*/
void CSLSetProp(int iPropNum, int PropType, int PropSubType, int PropBonus, string PropDesc)
{
	if (iPropNum==1)
	{
		ItemProps.Prop1Type = PropType;    ItemProps.Prop1SubType = PropSubType;
		ItemProps.Prop1Bonus = PropBonus;  ItemProps.Prop1Desc = PropDesc;
	}
	else if (iPropNum==2)
	{
		ItemProps.Prop2Type = PropType;    ItemProps.Prop2SubType = PropSubType;
		ItemProps.Prop2Bonus = PropBonus;  ItemProps.Prop2Desc = PropDesc;
	}
	else if (iPropNum==3)
	{
		ItemProps.Prop3Type = PropType;    ItemProps.Prop3SubType = PropSubType;
		ItemProps.Prop3Bonus = PropBonus;  ItemProps.Prop3Desc = PropDesc;
	}
	else if (iPropNum==4)
	{
		ItemProps.Prop4Type = PropType;    ItemProps.Prop4SubType = PropSubType;
		ItemProps.Prop4Bonus = PropBonus;  ItemProps.Prop4Desc = PropDesc;
	}
	else if (iPropNum==5)
	{
		ItemProps.Prop5Type = PropType;    ItemProps.Prop5SubType = PropSubType;
		ItemProps.Prop5Bonus = PropBonus;  ItemProps.Prop5Desc = PropDesc;
	}
	else if (iPropNum==6)
	{
		ItemProps.Prop6Type = PropType;    ItemProps.Prop6SubType = PropSubType;
		ItemProps.Prop6Bonus = PropBonus;  ItemProps.Prop6Desc = PropDesc;
	}
	else if (iPropNum==7)
	{
		ItemProps.Prop7Type = PropType;    ItemProps.Prop7SubType = PropSubType;
		ItemProps.Prop7Bonus = PropBonus;  ItemProps.Prop7Desc = PropDesc;
	}
	else if (iPropNum==8)
	{
		ItemProps.Prop8Type = PropType;    ItemProps.Prop8SubType = PropSubType;
		ItemProps.Prop8Bonus = PropBonus;  ItemProps.Prop8Desc = PropDesc;
	}
	if (ItemProps.PropList=="None")
	{
		ItemProps.PropList = "";
	}
	else
	{
		ItemProps.PropList += ", ";
	}
	ItemProps.PropList += PropDesc;
	ItemProps.PropCount = iPropNum;
	ItemProps.PropTag += "_" + IntToString(PropType);
	if (PropSubType>=0 && PropSubType<420) 
	{
		ItemProps.PropTag += "_" + IntToString(PropSubType);
	}
	if (PropBonus>=0 && PropBonus<420)
	{
		ItemProps.PropTag += "_" + IntToString(PropBonus);
	}
}


/**  
* Description
* @author Seed
* @param 
* @see 
* @replaces XXXLoadItemProps
* @return 
*/
void CSLLoadItemProps(object oItem)
{
   int iPropType;
   int iSubType;
   int iBonus;
   string sPropDesc;
   int iPropCnt = 0;
   ItemProps.SaveSpecificCurrent = 0;
   ItemProps.SaveVsCurrent = 0;
   ItemProps.AbilityCurrent = 0;
   ItemProps.SkillCurrent = 0;
   ItemProps.SkullType = 0;
   ItemProps.ACCurrent = 0;

   ItemProps.WeaponVampRegenCurrent = 0;
   ItemProps.WeaponVampRegenMax = 0;
   ItemProps.WeaponMightyCurrent = 0;
   ItemProps.WeaponMightyMax = 0;
   ItemProps.WeaponMassCritCurrent = 0;
   ItemProps.WeaponMassCritMax = 0;
   ItemProps.WeaponExotic = FALSE;
   ItemProps.WeaponABEB = 0;
   ItemProps.WeaponABCurrent = 0;

   ItemProps.ItemBase = GetBaseItemType(oItem);
   ItemProps.ItemType = CSLInitCap(Get2DAString("baseitems", "label", ItemProps.ItemBase));
   ItemProps.ItemCostMult = 100; // START AT BASE 100%, NO MARK UP AT ALL
   ItemProps.ItemLevel = CSLGetItemLevel(GetGoldPieceValue(oItem));
   ItemProps.WeaponType = StringToInt(Get2DAString("baseitems", "WeaponType", ItemProps.ItemBase));
   ItemProps.WeaponModsCount = 0;
   ItemProps.WeaponMods = 0;
   ItemProps.WeaponDamageCurrent = 0;
   ItemProps.WeaponAmmo = (ItemProps.ItemBase==BASE_ITEM_ARROW || ItemProps.ItemBase==BASE_ITEM_BOLT || ItemProps.ItemBase==BASE_ITEM_BULLET);
   ItemProps.ValidProps = 0;
   ItemProps.PropTag = "_" + IntToString(ItemProps.ItemBase);

   ItemProps.ValidProps = 0;

   if (ItemProps.ItemBase==BASE_ITEM_GLOVES) // MONK GLOVES PROPERTIES
   {
      ItemProps.WeaponMods = SMS_WEAPON_MODS_GLOVES;
      ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_DAMAGE | SHOW_AC);

   }
   else if (ItemProps.ItemBase==BASE_ITEM_MAGICSTAFF) // MAGIC STAFF PROPERTIES
   {
      ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_EB | SHOW_DAMAGE | SHOW_VAMP_REGEN | SHOW_MASSCRITS | SHOW_VISUAL | SHOW_SPELLSLOT);

   }
   else if (ItemProps.ItemBase==BASE_ITEM_RING) // MAGIC RING PROPERTIES
   {
      ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AC | SHOW_SAVEVS | SHOW_SPELLSLOT | SHOW_SAVESPECIFIC);

   }
   else if (ItemProps.WeaponAmmo) // AMMO
   {
      ItemProps.WeaponMods = SMS_WEAPON_MODS_AMMO;
      if (ItemProps.ItemBase==BASE_ITEM_BULLET) ItemProps.WeaponMods++;
      ItemProps.ValidProps = (SHOW_DAMAGE | SHOW_VAMP_REGEN);
      //ItemProps.ItemCostMult = GetBoxCount(); // MULT BY THE # OF BOXES OF STACKS

   }
   else if (ItemProps.WeaponType==0) // EQUIPABLE NON WEAPON
   {
      ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_SKILL); // ALL ITEMS CAN HAVE SKILLS
      if (!CSLGetIsAShield(ItemProps.ItemBase)) ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AC); // DON'T LET AC ON SHIELDS FOR NOW
      if (ItemProps.ItemBase==BASE_ITEM_HELMET) ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_DARKVISION | SHOW_LIGHT);

      if (ItemProps.ItemBase==BASE_ITEM_ARMOR) ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_ABILITY | SHOW_DAMAGERESIST | SHOW_DAMAGEREDUCT);
      if (ItemProps.ItemBase==BASE_ITEM_AMULET) ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_ABILITY);
      if (ItemProps.ItemBase==BASE_ITEM_BOOTS) ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_ABILITY | SHOW_DAMAGEIMMUNITY); //| SHOW_HASTE

   }
   else // WEAPON
   {
      int nAmmoType = StringToInt(Get2DAString("baseitems", "AmmunitionType", ItemProps.ItemBase));
      ItemProps.WeaponRanged = (nAmmoType==1 || nAmmoType==2 || nAmmoType==3); //1=arrow,2=bolt,3=bullet
      ItemProps.WeaponThrow = (nAmmoType==4 || nAmmoType==5 || nAmmoType==6); //4=dart,5=shuriken,6=throwingaxe
      ItemProps.WeaponMelee = !(ItemProps.WeaponRanged || ItemProps.WeaponThrow);
      ItemProps.WeaponSize = StringToInt(Get2DAString("baseitems", "WeaponSize", ItemProps.ItemBase));
      ItemProps.WeaponCritThreat = StringToInt(Get2DAString("baseitems", "CritThreat", ItemProps.ItemBase));
      ItemProps.WeaponCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult", ItemProps.ItemBase));
      ItemProps.WeaponExotic = (StringToInt(Get2DAString("baseitems", "ReqFeat0", ItemProps.ItemBase))==FEAT_WEAPON_PROFICIENCY_EXOTIC);

      if      (ItemProps.WeaponRanged)  ItemProps.WeaponMods = SMS_WEAPON_MODS_RANGED;
      else if (ItemProps.WeaponThrow)   ItemProps.WeaponMods = SMS_WEAPON_MODS_THROWING;
      else if (ItemProps.WeaponSize==1) ItemProps.WeaponMods = SMS_WEAPON_MODS_TINY;
      else if (ItemProps.WeaponSize==2) ItemProps.WeaponMods = SMS_WEAPON_MODS_SMALL;
      else if (ItemProps.WeaponSize==3) ItemProps.WeaponMods = SMS_WEAPON_MODS_MEDIUM;
      else if (ItemProps.WeaponSize==4) ItemProps.WeaponMods = SMS_WEAPON_MODS_LARGE;

      if      (ItemProps.WeaponCritThreat==1) ItemProps.WeaponMods += SMS_WEAPON_MODS_CRITTHREAT20;
      else if (ItemProps.WeaponCritThreat==2) ItemProps.WeaponMods += SMS_WEAPON_MODS_CRITTHREAT19;
      else if (ItemProps.WeaponCritThreat==3) ItemProps.WeaponMods += SMS_WEAPON_MODS_CRITTHREAT18;

      if      (ItemProps.WeaponCritMult==2) ItemProps.WeaponMods += SMS_WEAPON_MODS_CRITMULT2;
      else if (ItemProps.WeaponCritMult==3) ItemProps.WeaponMods += SMS_WEAPON_MODS_CRITMULT3;
      else if (ItemProps.WeaponCritMult==4) ItemProps.WeaponMods += SMS_WEAPON_MODS_CRITMULT4;

      if (ItemProps.WeaponExotic) ItemProps.WeaponMods += 1; // +1 FOR EXOTIC WEAPONS

      if      (ItemProps.WeaponRanged)  ItemProps.WeaponMassCritMax = SMS_WEAPON_MASSCRIT_RANGED;
      else if (ItemProps.WeaponThrow)   ItemProps.WeaponMassCritMax = SMS_WEAPON_MASSCRIT_THROWING;
      else if (ItemProps.WeaponSize==1) ItemProps.WeaponMassCritMax = SMS_WEAPON_MASSCRIT_TINY;
      else if (ItemProps.WeaponSize==2) ItemProps.WeaponMassCritMax = SMS_WEAPON_MASSCRIT_SMALL;
      else if (ItemProps.WeaponSize==3) ItemProps.WeaponMassCritMax = SMS_WEAPON_MASSCRIT_MEDIUM;
      else if (ItemProps.WeaponSize==4) ItemProps.WeaponMassCritMax = SMS_WEAPON_MASSCRIT_LARGE;

      if (ItemProps.WeaponRanged) {
         ItemProps.WeaponMightyMax = 4 + ItemProps.WeaponMods;
         ItemProps.WeaponMods = 0; // ZERO OUT THESE FOR RANGED SINCE YOU CAN"T PUT DAMAGE ON THEM
         ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_MASSCRITS | SHOW_MIGHTY);

      } else if (ItemProps.WeaponThrow) {
         ItemProps.WeaponMightyMax = 4 + ItemProps.WeaponMods;
         ItemProps.WeaponVampRegenMax = 2;
         ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_EB | SHOW_DAMAGE | SHOW_VAMP_REGEN | SHOW_MIGHTY);

      } else if (ItemProps.WeaponMods > 0) { // EVERYTHING ELSE SHOULD END UP IN HERE
         ItemProps.ValidProps = (ItemProps.ValidProps | SHOW_AB | SHOW_EB | SHOW_DAMAGE | SHOW_KEEN | SHOW_VAMP_REGEN | SHOW_MASSCRITS | SHOW_VISUAL);
         if (ItemProps.WeaponSize==4) ItemProps.WeaponVampRegenMax = 5; // TWO HANDERS
         else if (ItemProps.WeaponSize==3) ItemProps.WeaponVampRegenMax = 3; // ONE HANDERS
         else ItemProps.WeaponVampRegenMax = 2; // SMALL/LIGHT
      }
   }
   ItemProps.WeaponDamageMax = ItemProps.WeaponMods * MAX_DAMAGE_PER_MOD;
   ItemProps.PropList = "None";
   itemproperty ipProperty =  GetFirstItemProperty(oItem);
   while (GetIsItemPropertyValid(ipProperty))
   {
      iPropCnt++;
      iPropType = GetItemPropertyType(ipProperty);
      iSubType=GetItemPropertySubType(ipProperty);
      iBonus = GetItemPropertyCostTableValue(ipProperty);
      int iParam1 = GetItemPropertyParam1Value(ipProperty);
      sPropDesc = CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1);
      switch (iPropType)
      {
         case ITEM_PROPERTY_ABILITY_BONUS:
            ItemProps.AbilityCurrent = iBonus;
            ItemProps.AbilityType = iSubType;
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_ABILITY;
            break;
         case ITEM_PROPERTY_AC_BONUS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_AC;
            ItemProps.ACCurrent = iBonus;
            break;
         case ITEM_PROPERTY_ATTACK_BONUS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_AB | SHOW_EB;
            ItemProps.WeaponABEB = ITEM_PROPERTY_ATTACK_BONUS;
            ItemProps.WeaponABCurrent = iBonus;
            break;
         case ITEM_PROPERTY_BONUS_FEAT:
            break;
         case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_SPELLSLOT;
            break;
         case ITEM_PROPERTY_CAST_SPELL:
            break;
         case ITEM_PROPERTY_DAMAGE_BONUS:
            ItemProps.WeaponModsCount++;
            ItemProps.WeaponDamageCurrent += CSLDamageBonusValue(iBonus);
            if (ItemProps.WeaponModsCount>=3 || ItemProps.WeaponDamageCurrent+3>=ItemProps.WeaponDamageMax) { // +3 IS BECAUSE YOU CAN'T PUT LESS THAN 1D4 ON A WEAPON
               ItemProps.UsedProps = ItemProps.UsedProps | SHOW_DAMAGE;
            }
            break;
         case ITEM_PROPERTY_DAMAGE_REDUCTION:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_DAMAGEREDUCT;
            break;
         case ITEM_PROPERTY_DAMAGE_RESISTANCE:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_DAMAGERESIST;
            break;
         case ITEM_PROPERTY_DARKVISION:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_DARKVISION;
            break;
         case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
             sPropDesc = CSLColorText(sPropDesc, COLOR_YELLOW);
            break;
         case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_EB | SHOW_AB;
            ItemProps.WeaponABEB = ITEM_PROPERTY_ENHANCEMENT_BONUS;
            ItemProps.WeaponABCurrent = iBonus;
            break;
         case ITEM_PROPERTY_HASTE:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_HASTE;
            break;
         case ITEM_PROPERTY_HOLY_AVENGER:
            break;
         case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_DAMAGEIMMUNITY;
            break;
         case ITEM_PROPERTY_KEEN:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_KEEN;
            ItemProps.ItemCostMult+=100;
            break;
         case ITEM_PROPERTY_LIGHT:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_LIGHT;
            break;
         case ITEM_PROPERTY_MASSIVE_CRITICALS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_MASSCRITS;
            ItemProps.WeaponMassCritCurrent = iBonus;
            break;
         case ITEM_PROPERTY_MIGHTY:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_MIGHTY;
            ItemProps.WeaponMightyCurrent = iBonus;
            break;
         case ITEM_PROPERTY_ON_HIT_PROPERTIES:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_ONHIT;
            ItemProps.ItemCostMult += 200;
            break;
         case ITEM_PROPERTY_REGENERATION:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_REGEN;
            break;
         case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_VAMP_REGEN;
            ItemProps.WeaponVampRegenCurrent = iBonus;
            break;
         case ITEM_PROPERTY_SAVING_THROW_BONUS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_SAVEVS;
            break;
         case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_SAVESPECIFIC;
            break;
         case ITEM_PROPERTY_SKILL_BONUS:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_SKILL;
            ItemProps.SkullType = iSubType;
            ItemProps.SkillCurrent = iBonus;
            break;
         case ITEM_PROPERTY_SPELL_RESISTANCE:
            break;
         case ITEM_PROPERTY_VISUALEFFECT:
            ItemProps.UsedProps = ItemProps.UsedProps | SHOW_VISUAL;
            break;
      }
      CSLSetProp(iPropCnt, iPropType, iSubType, iBonus, sPropDesc);
      ipProperty =  GetNextItemProperty(oItem);
   }
   if (ItemProps.WeaponAmmo || ItemProps.WeaponThrow) // MARKUP ONLY MAGIC ITEMS THAT IS NOT AMMO
   {
       ItemProps.ItemCostMult = 50; // SELL DISCOUNTED AMMO
   }
   else if (iPropCnt)
   {
      ItemProps.ItemCostMult += 50 + ItemProps.ItemLevel * 10; // TOTAL MARKUP IS 200 + 10% PER LEVEL, MAX OF 400% AT LEVEL 20
   }
   ItemProps.ItemCost = (GetGoldPieceValue(oItem) * ItemProps.ItemCostMult / 100) + 10;
}

int CSLIsValidProp(int nProp)
{
   return (ItemProps.ValidProps & nProp);
}

int CSLIsUsedProp(int nProp)
{
   return (ItemProps.UsedProps & nProp);
}

//@} ****************************************************************************************************

/********************************************************************************************************/
/** @name Serialize Property Functions
* Description
********************************************************************************************************* @{ */


// Get a string from a corresponding item property 
// - ipProperty Item property from which the string is get
// * Returns a string corresponding to the item property
// JXItemPropertyToString
string CSLSerializeItemProperty(itemproperty ipProperty)
{
	// Get the identifier of the current item property
	int iIPType = GetItemPropertyType(ipProperty);

	if ((iIPType == ITEM_PROPERTY_MIND_BLANK)		// No ItemPropertyXXX() to create this property
	 || (iIPType == ITEM_PROPERTY_ON_MONSTER_HIT))	// ItemPropertyOnMonsterHitProperties() is bugged
	 	return "";

	// Get other item property parameters
	int iIPSubType = GetItemPropertySubType(ipProperty);
	int iIPParam1Value = GetItemPropertyParam1Value(ipProperty);
	int iIPCostTableValue = GetItemPropertyCostTableValue(ipProperty);

	string sItemProperty = IntToString(iIPType);

	// Sub-type
	if ((iIPType == ITEM_PROPERTY_BONUS_FEAT)
	 || (iIPType == ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS)
	 || (iIPType == ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL)
	 || (iIPType == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP)
	 || (iIPType == ITEM_PROPERTY_USE_LIMITATION_CLASS)
	 || (iIPType == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE)
	 || (iIPType == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT)
	 || (iIPType == ITEM_PROPERTY_SPECIAL_WALK)
	 || (iIPType == ITEM_PROPERTY_VISUALEFFECT))
		sItemProperty += "," + IntToString(iIPSubType);
	else
	// Cost table value
	if ((iIPType == ITEM_PROPERTY_AC_BONUS)
	 || (iIPType == ITEM_PROPERTY_ENHANCEMENT_BONUS)
	 || (iIPType == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER)
	 || (iIPType == ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION)
	 || (iIPType == ITEM_PROPERTY_DECREASED_DAMAGE)
	 || (iIPType == ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT)
	 || (iIPType == ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE)
	 || (iIPType == ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE)
	 || (iIPType == ITEM_PROPERTY_SPELL_RESISTANCE)
	 || (iIPType == ITEM_PROPERTY_REGENERATION)
	 || (iIPType == ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL)
	 || (iIPType == ITEM_PROPERTY_THIEVES_TOOLS)
	 || (iIPType == ITEM_PROPERTY_ATTACK_BONUS)
	 || (iIPType == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER)
	 || (iIPType == ITEM_PROPERTY_UNLIMITED_AMMUNITION)
	 || (iIPType == ITEM_PROPERTY_REGENERATION_VAMPIRIC)
	 || (iIPType == ITEM_PROPERTY_BONUS_HITPOINTS)
	 || (iIPType == ITEM_PROPERTY_TURN_RESISTANCE)
	 || (iIPType == ITEM_PROPERTY_MASSIVE_CRITICALS)
	 || (iIPType == ITEM_PROPERTY_MONSTER_DAMAGE)
	 || (iIPType == ITEM_PROPERTY_HEALERS_KIT)
	 || (iIPType == ITEM_PROPERTY_ARCANE_SPELL_FAILURE)
	 || (iIPType == ITEM_PROPERTY_MIGHTY))
		sItemProperty += "," + IntToString(iIPCostTableValue);
	else
	// Cost table value + 1
	if (iIPType == ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL)
		sItemProperty += "," + IntToString(iIPCostTableValue + 1);
	else
	// Param1 value
	if (iIPType == ITEM_PROPERTY_WEIGHT_INCREASE)
		sItemProperty += "," + IntToString(iIPParam1Value);
	else
	// Sub-type + Cost table value
	if ((iIPType == ITEM_PROPERTY_ABILITY_BONUS)
	 || (iIPType == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP)
	 || (iIPType == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE)
	 || (iIPType == ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP)
	 || (iIPType == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT)
	 || (iIPType == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP)
	 || (iIPType == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT)
	 || (iIPType == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP)
	 || (iIPType == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N)
	 || (iIPType == ITEM_PROPERTY_CAST_SPELL)
	 || (iIPType == ITEM_PROPERTY_DAMAGE_BONUS)
	 || (iIPType == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE)
	 || (iIPType == ITEM_PROPERTY_DAMAGE_RESISTANCE)
	 || (iIPType == ITEM_PROPERTY_DAMAGE_VULNERABILITY)
	 || (iIPType == ITEM_PROPERTY_DECREASED_ABILITY_SCORE)
	 || (iIPType == ITEM_PROPERTY_DECREASED_AC)
	 || (iIPType == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER)
	 || (iIPType == ITEM_PROPERTY_SAVING_THROW_BONUS)
	 || (iIPType == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC)
	 || (iIPType == ITEM_PROPERTY_DECREASED_SAVING_THROWS)
	 || (iIPType == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC)
	 || (iIPType == ITEM_PROPERTY_SKILL_BONUS)
	 || (iIPType == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP)
	 || (iIPType == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP)
	 || (iIPType == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT)
	 || (iIPType == ITEM_PROPERTY_TRAP))
		sItemProperty += "," + IntToString(iIPSubType) + "," + IntToString(iIPCostTableValue);
	else
	// Sub-type + Cost table value + 1
	if (iIPType == ITEM_PROPERTY_ONHITCASTSPELL)
		sItemProperty += "," + IntToString(iIPSubType) + "," + IntToString(iIPCostTableValue + 1);
	else
	// Cost table value + Param1 value
	if (iIPType == ITEM_PROPERTY_LIGHT)
		sItemProperty += "," + IntToString(iIPCostTableValue) + "," + IntToString(iIPParam1Value);
	else
	// Sub-type + Cost table value + Param1 value
	if (iIPType == ITEM_PROPERTY_ON_HIT_PROPERTIES)
		sItemProperty += "," + IntToString(iIPSubType) + "," + IntToString(iIPCostTableValue) + "," + IntToString(iIPParam1Value);
	else
	// Sub-type + Param1 value + Cost table value
	if ((iIPType == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
	 || (iIPType == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
	 || (iIPType == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT))
		sItemProperty += "," + IntToString(iIPSubType) + "," + IntToString(iIPParam1Value) + "," + IntToString(iIPCostTableValue);
	// No parameter required
	/*
	else
	if ((iIPType == ITEM_PROPERTY_DARKVISION)
	 || (iIPType == ITEM_PROPERTY_HASTE)
	 || (iIPType == ITEM_PROPERTY_HOLY_AVENGER)
	 || (iIPType == ITEM_PROPERTY_IMPROVED_EVASION)
	 || (iIPType == ITEM_PROPERTY_KEEN)
	 || (iIPType == ITEM_PROPERTY_NO_DAMAGE)
	 || (iIPType == ITEM_PROPERTY_TRUE_SEEING)
	 || (iIPType == ITEM_PROPERTY_FREEDOM_OF_MOVEMENT)) {}
	*/

	// Item properties that don't exist
	/*
	  ITEM_PROPERTY_DAMAGE_REDUCTION_DEPRECATED : deprecated !
	  25 (Dancing Weapon) : not implemented
	  30 (Double Stack) : not implemented
	  31 (Enhanced Container Bonus Slot) : not implemented
	  42 (unknown value) : not implemented
	  68 (Vorpal) : not implemented (now On Hit subtype)
	  69 (Wounding) : not implemented
	  ITEM_PROPERTY_POISON : not implemented (now a On Hit subtype)
	  ITEM_PROPERTY_DAMAGE_REDUCTION : ItemPropertyDamageReduction() is bugged and the property is never returned by GetFirst/NextItemProperty
	  								   Currently = 85 (Arrow Catching), should be 90)
	  86 (Bashing) : not implemented
	  87 (Animated) : not implemented
	  88 (Wild) : not implemented
	  89 (Etherealness) : not implemented
	  90 (Damage Reduction) : not implemented
	*/

	return sItemProperty;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Get an item property from a corresponding string
// - sItemProperty String from which the item property is get
// * Returns an item property corresponding to the string
// Originally JXStringToItemProperty
itemproperty CSLUnserializeItemProperty(string sItemProperty)
{
	itemproperty ipProperty;

	// Initialize all item property's parameters
	int iPrm = 1;
	int iIPType = 0;
	int iParam1 = 0;
	int iParam2 = 0;
	int iParam3 = 0;
	int iParam4 = 0;
	int iItemPropertyParam;

	// Loop on all item property's parameters
	int iPosComma = FindSubString(sItemProperty, ",");
	while (1)
	{
		// Get the current item property's parameter
		if (iPosComma == -1)
			iItemPropertyParam = StringToInt(sItemProperty);
		else
		{
			iItemPropertyParam = StringToInt(GetStringLeft(sItemProperty, iPosComma));
			sItemProperty = GetSubString(sItemProperty, iPosComma + 1, GetStringLength(sItemProperty) - iPosComma + 1);
		}
		// Define the value of the current item property's parameter
		if (iPrm == 1) iIPType = iItemPropertyParam;
		else if (iPrm == 2) iParam1 = iItemPropertyParam;
		else if (iPrm == 3) iParam2 = iItemPropertyParam;
		else if (iPrm == 4) iParam3 = iItemPropertyParam;
		else if (iPrm == 5) iParam4 = iItemPropertyParam;

		// End loop if there are no other item property's parameters
		if (iPosComma == -1) break;

		iPosComma = FindSubString(sItemProperty, ",");
		iPrm++;
	}
	ipProperty = CSLGetItemPropertyByID(iIPType, iParam1, iParam2, iParam3, iParam4);

	return ipProperty;
}

//@} ****************************************************************************************************


/********************************************************************************************************/
/** @name Container Functions
* Description
********************************************************************************************************* @{ */


/**  
* returns a value that will be subtracted from the oTarget's DC to resist APpraise or Persuasion
* @author
* @param 
* @see 
* @replaces XXXN2_GetNPCEasyMark
* @return 
*/
int CSLStoreAppraiseDCAdjust(object oTarget)
{
	int nCharmMod = 0;
	if (GetHasSpellEffect(SPELL_CHARM_PERSON, oTarget))
	{
		nCharmMod = 10;
	}
	else if (GetHasSpellEffect(SPELL_CHARM_MONSTER, oTarget))
	{
		nCharmMod = 10;
	}
	else if (GetHasSpellEffect(SPELL_CHARM_PERSON_OR_ANIMAL, oTarget))
	{
		nCharmMod = 10;
	}
	else if (GetHasSpellEffect(SPELL_MASS_CHARM, oTarget))
	{
		nCharmMod = 15;
	}
	else if (GetHasSpellEffect(SPELL_DOMINATE_MONSTER, oTarget))
	{
		nCharmMod = 20;
	}
	else if (GetHasSpellEffect(SPELL_DOMINATE_ANIMAL, oTarget))
	{
		nCharmMod = 20;
	}
	else if (GetHasSpellEffect(SPELL_DOMINATE_PERSON, oTarget))
	{
		nCharmMod = 20;
	}
	return nCharmMod;
}

/**  
* Open Store taking Appraise skill into account.
* changed from gplotAppraiseOpenStore() in NW_IO_PLOT - no longer random
*       An opposed skill ccomparison. Your appraise skill versus the shopkeepers appraise skill.
*       Possible Results:
*       Percentage Rebate/Penalty: The 'difference'
*       Feedback: [Appraise Skill]: Merchant's reaction is unfavorable.
*                 [Appraise Skill]: Merchant's reaction is neutral.
*                 [Appraise Skill]: Merchant's reaction is favorable.
* @author
* @param 
* @see 
* @replaces XXXN2_AppraiseOpenStore
* @return 
*/
void CSLStoreAppraiseOpenStore(object oStore, object oPC, int nBonusMarkUp = 0, int nBonusMarkDown = 0)
{
    int STATE_FAILED = 1;
    int STATE_TIE = 2;
    int STATE_WON = 3;

    int nPlayerSkillRank = GetSkillRank(SKILL_APPRAISE, oPC);

    int nNPCSkillRank = GetSkillRank(SKILL_APPRAISE, OBJECT_SELF) - CSLStoreAppraiseDCAdjust(OBJECT_SELF);


    if (nNPCSkillRank < 1 )
        nNPCSkillRank = 1;


    int nState = 0;
	int nAdjust = nNPCSkillRank - nPlayerSkillRank; // * determines the level of price modification

	if (nNPCSkillRank > nPlayerSkillRank)
	{
	    nState = STATE_FAILED;
	}
	else
	if (nNPCSkillRank < nPlayerSkillRank)
	{
	    nState = STATE_WON;
	}
	else
	if (nNPCSkillRank == nPlayerSkillRank)
	{
	    nState = STATE_TIE;
	}

    if (nState == STATE_FAILED  )
    {
        FloatingTextStrRefOnCreature(182468, oPC, FALSE);
    }
    else
    if (nState == STATE_WON)
    {
        FloatingTextStrRefOnCreature(182470, oPC, FALSE);
    }
    else
    if (nState == STATE_TIE)
    {
        FloatingTextStrRefOnCreature(182469, oPC, FALSE);
    }


    // * Hard cap of 30% max up or down
    if (nAdjust > 30)
        nAdjust = 30;
    if (nAdjust < -30)
        nAdjust = -30;

	// nBonusMarkUp is added to the stores default mark up percentage on items sold (-100 to 100)
	// (positive is good for player)
	// Effect on selling items is only half of effect on buying items.
    nBonusMarkUp = nBonusMarkUp + nAdjust/2;
	
	// nBonusMarkDown is added to the stores default mark down percentage on items bought (-100 to 100)
	// (negative is good for player)
	nBonusMarkDown = nBonusMarkDown - nAdjust;
    OpenStore(oStore, oPC, nBonusMarkUp, nBonusMarkDown);
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXVoidCreateItemOnObject
* @return 
*/
void CSLCreateItemOnObject_Void(string sItemTemplate, object oTarget = OBJECT_SELF, int nStackSize = 1, int bInfinite = FALSE)
{
	//CreateItemOnObject(sItemTemplate, oTarget, nStackSize);
	//PrettyDebug("Creating " + IntToString(nStackSize) + " of res ref: " + sItemTemplate);
	object oItem = CreateItemOnObject(sItemTemplate, oTarget, nStackSize);
	
	if(bInfinite)
		SetInfiniteFlag(oItem, TRUE);
	
	nStackSize = GetNumStackedItems(oItem);
	sItemTemplate = GetResRef(oItem);
	//PrettyDebug("Item created: " + IntToString(nStackSize) + " of res ref: " + sItemTemplate);
	
	
}


/**  
* Goes through an object's inventory and recreates the items from the blueprint.
* only applies to droppable items in inventory (not equipped).
* Description
* @author
* @param 
* @see 
* @replaces XXXRecreateItemsFromBlueprint
* @return 
*/
void CSLItemRecreateFromBlueprint(object oObject=OBJECT_SELF)
{
    int nRecreateItemsCount = 0;
    string sVarName;
    int nStackSize;
	int bInfinite;
    string sItemTemplate;
   
    // create list of items to recreate.
    // We delay creating and deleting objects so as to avoid 
    // porblems with the iterator used by GetFirst/NextItemInInventory()
    object oItem = GetFirstItemInInventory(oObject);
    while (GetIsObjectValid(oItem) == TRUE)
    {
        if ((GetLocalInt(oItem, "NO_DRR") == FALSE)
            && ((GetDroppableFlag(oItem) == TRUE)
                || GetObjectType(oObject) != OBJECT_TYPE_CREATURE))
        {
            nRecreateItemsCount++;
            sVarName = SC_VAR_PREFIX_RECREATE_LIST + IntToString(nRecreateItemsCount);
            SetLocalObject(oObject, sVarName, oItem); // save item to delete
			
            nStackSize = GetNumStackedItems(oItem);
            sItemTemplate = GetResRef(oItem);
			bInfinite = GetInfiniteFlag(oItem);
			
			// ok to use same var name 
			SetLocalInt(oObject, sVarName, nStackSize);
			SetLocalString(oObject, sVarName, sItemTemplate);
			SetLocalInt(oObject, sVarName + "IF", bInfinite);
        }
        oItem = GetNextItemInInventory(oObject);
    }
    
    int i;
    // Destory and recreate the "list of items"
	// Destroy before create, because creating new stackable items will cause them to merge,
	// and then DestroyObject would destroy	the merged items as well		
	
    for (i=1; i<= nRecreateItemsCount; i++)
    {
        sVarName = SC_VAR_PREFIX_RECREATE_LIST + IntToString(i);
        oItem = GetLocalObject(oObject, sVarName);
        if (GetIsObjectValid(oItem))
        {
            //nStackSize = GetNumStackedItems(oItem);
            //sItemTemplate = GetResRef(oItem);
           	DestroyObject(oItem);
            //CreateItemOnObject(sItemTemplate, oObject, nStackSize);
            DeleteLocalObject(oObject, sVarName); // clean up the var name.
        }            
    }
	
	// create the items
    for (i=1; i<= nRecreateItemsCount; i++)
    {
        sVarName = SC_VAR_PREFIX_RECREATE_LIST + IntToString(i);
		nStackSize = GetLocalInt(oObject, sVarName);
		sItemTemplate = GetLocalString(oObject, sVarName);
		bInfinite = GetLocalInt(oObject, sVarName + "IF");
		// Create has to be delayed long enough to ensure destroy has occured
		DelayCommand(0.01f, CSLCreateItemOnObject_Void(sItemTemplate, oObject, nStackSize, bInfinite));
		
		DeleteLocalInt(oObject, sVarName); // clean up the var name.
		DeleteLocalString(oObject, sVarName); // clean up the var name.
    }
	
}


/**  
* Returns the container used for item property and appearance modifications in the
* module. If it does not exist, it is created
* @author
* @param 
* @see 
* @replaces XXXIPGetIPWorkContainer
* @return 
*/
object CSLItemGetCraftingWorkContainer(object oCaller = OBJECT_SELF)
{
    object oRet = GetObjectByTag(SC_IP_WORK_CONTAINER_TAG);
    if (oRet == OBJECT_INVALID)
    {
        oRet = CreateObject(OBJECT_TYPE_PLACEABLE,SC_IP_WORK_CONTAINER_TAG,GetLocation(oCaller));
        effect eInvis =  EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY);
        eInvis = ExtraordinaryEffect(eInvis);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInvis,oRet);
        if (oRet == OBJECT_INVALID)
        {
            WriteTimestampedLogEntry("_CSLCore_Items - critical: Missing container with tag " +SC_IP_WORK_CONTAINER_TAG + "!!");
        }
    }


    return oRet;
}

/**  
* Returns the number of items in oContainer.
* @author
* @param 
* @see 
* @replaces XXXGetNumberOfItemsInInventory
* @return 
*/
int CSLCountNumberOfItemsInContainer(object oContainer)
{
	object oItem;
	int nReturn;
	
	oItem = GetFirstItemInInventory(oContainer);
	
	while (GetIsObjectValid(oItem))
	{
		nReturn += 1;
		oItem = GetNextItemInInventory(oContainer);
	}
	return nReturn;
}


/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLDestoryContentsAndSelf(object oChest)
{
   object oItem = GetFirstItemInInventory();
   while (GetIsObjectValid(oItem))
   {
      DestroyObject(oItem);
      oItem = GetNextItemInInventory();
   }
   DestroyObject(oChest);
}



//@} ****************************************************************************************************



/********************************************************************************************************/
/** @name Creature Inventory Functions
* Description
********************************************************************************************************* @{ */


/**  
* Return number of items of Base Type in inventory
* @author
* @param 
* @see 
* @replaces XXXCountInventoryItemsOfBaseType
* @return 
*/
int CSLCountInventoryItemsOfBaseType(int nBaseType, object oCreature=OBJECT_SELF)
{
    object oItem =  GetFirstItemInInventory(oCreature);
	int iItemCount=0;

    while (GetIsObjectValid(oItem))
    {
       if (GetBaseItemType(oItem) == nBaseType)
       {
			iItemCount++;
       }
       oItem =  GetNextItemInInventory(oCreature);
    }
    return iItemCount;
}






/**  
* Description
* @author kaedrin
* @param 
* @see 
* @replaces XXXIPGetTargetedOrEquippedShield
* @return 
*/
object CSLGetTargetedOrEquippedShield()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD)
    {
        return oTarget;
    }
    else
    {
		return OBJECT_INVALID;
    }


  }
  else
  {
      object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
      if (GetIsObjectValid(oShield) && (GetBaseItemType(oShield) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oShield) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oShield) == BASE_ITEM_TOWERSHIELD))
      {
        return oShield;
      }
    }



  return OBJECT_INVALID;

}


/**  
* Description
* @author Kaedrin
* @param 
* @see 
* @replaces XXXIPGetTargetedOrEquippedWeapon
* @return 
*/
object CSLGetTargetedOrEquippedWeapon()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
  
   if (CSLItemGetIsMeleeWeapon(oTarget) || CSLItemGetIsRangedWeapon(oTarget))
    {
        return oTarget;
    }
    else
    {
        return OBJECT_INVALID;
    }

  }

  object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && (CSLItemGetIsRangedWeapon(oWeapon1) || CSLItemGetIsMeleeWeapon(oWeapon1)))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && (CSLItemGetIsRangedWeapon(oWeapon1) || CSLItemGetIsMeleeWeapon(oWeapon1)))
  {
    return oWeapon1;
  }
  
   oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  } 

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  return OBJECT_INVALID;

}




/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXIdentifyEquippedItems
* @return 
*/
void CSLIdentifyEquippedItems(object oCreature=OBJECT_SELF)
{
	int i = 0;
	object oItem;
	for (i = 0; i< NUM_INVENTORY_SLOTS; i++)
	{
		oItem = GetItemInSlot(i, oCreature);
		if (GetIsObjectValid(oItem) == TRUE)
			SetIdentified( oItem, TRUE);
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXIdentifyInventory
* @return 
*/
void CSLIdentifyInventory(object oCreature=OBJECT_SELF)
{
    object oInventoryItem = GetFirstItemInInventory(oCreature);
    while (oInventoryItem != OBJECT_INVALID)
    {
	    SetIdentified(oInventoryItem, TRUE);
        oInventoryItem = GetNextItemInInventory(oCreature);
    }
}




/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXGetInventoryItemOfBaseType
* @return 
*/
object CSLGetInventoryItemOfBaseType(int nBaseType, int nNth=1, object oCreature=OBJECT_SELF)
{
    object oItem =  GetFirstItemInInventory(oCreature);
	int iItemCount=0;

    while (GetIsObjectValid(oItem))
    {
       if (GetBaseItemType(oItem) == nBaseType)
       {
			iItemCount++;
			if (iItemCount == nNth)
			{
				//PrettyDebug("Found requested item in inventory: " + GetName(oItem));
				return (oItem);
			}
       }
       oItem =  GetNextItemInInventory(oCreature);
    }
	
    return OBJECT_INVALID;
}


/**  
* list items in inventory.  Should work for placeables too.
* @author
* @param 
* @see 
* @replaces XXXListInventory
* @return 
*/
int CSLListInventory(object oCreature=OBJECT_SELF)
{
    object oItem = GetFirstItemInInventory(oCreature);
	int i;

	//PrettyDebug("*** Items in the inventory of " + GetName(oCreature));
    while (GetIsObjectValid(oItem))
    {
		i++;
		//PrettyDebug("Item " + IntToString(i) + ": " + GetName(oItem));
       	oItem =  GetNextItemInInventory(oCreature);
    }
    return i;
}

/**  
* Returns reference to item with Tag in inventory only (not equipped)
* @author
* @param 
* @see 
* @replaces XXXGetItemInInventory
* @return 
*/
object CSLGetItemInInventory(string sItemTag, object oCreature=OBJECT_SELF)
{
	object oRet = OBJECT_INVALID;
    object oItem = GetFirstItemInInventory(oCreature);

    while (GetIsObjectValid(oItem))
    {
		if (GetTag(oItem) == sItemTag)
			return oItem;
       	oItem =  GetNextItemInInventory(oCreature);
    }
    return oRet;
}

/**  
* Returns reference to item with Tag in inventory only (not equipped)
* @author
* @param 
* @see 
* @replaces XXXGetNumItems
* @return 
*/
int CSLGetNumItems(object oTarget, string sItem = "")
{
    int nNumItems = 0;
    object oItem = GetFirstItemInInventory(oTarget);

    while (GetIsObjectValid(oItem) == TRUE)
    {
        if (sItem == "" || GetTag(oItem) == sItem)
        {
            nNumItems = nNumItems + GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }

   return nNumItems;
}

/**  
* returns TRUE if an item was found
* @author
* @param 
* @see 
* @replaces XXXEquipRandomArmorFromInventory
* @return 
*/
int CSLEquipRandomArmorFromInventory()
{
	int bRet = FALSE;
	//PrettyDebug("Looking for something to change into");
	int iCount = CSLCountInventoryItemsOfBaseType(BASE_ITEM_ARMOR);
	int iChoice = Random(iCount)+1;
	object oArmor = CSLGetInventoryItemOfBaseType(BASE_ITEM_ARMOR, iChoice);
	if (GetIsObjectValid(oArmor))
	{
		bRet = TRUE;
		ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CHEST));
		ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST);
	}
	return (bRet);
}


/**  
* Returns TRUE if a character has any item equipped that has the itemproperty
* defined in nItemPropertyConst in it (ITEM_PROPERTY_* constant)
* @author
* @param 
* @see 
* @replaces XXXIPGetHasItemPropertyOnCharacter
* @return 
*/
int CSLGetHasItemPropertyOnCharacter(object oPC, int nItemPropertyConst)
{
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oLeftHand  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    int bHas =  CSLGetHasItemPropertyByConst(nItemPropertyConst, oWeaponOld);
     bHas = bHas ||  CSLGetHasItemPropertyByConst(nItemPropertyConst, oLeftHand);
    bHas = bHas || CSLGetHasItemPropertyByConst(nItemPropertyConst, oArmorOld);
    if (bHas)
        return TRUE;
    bHas = bHas || CSLGetHasItemPropertyByConst(nItemPropertyConst, oRing1Old);
    bHas = bHas || CSLGetHasItemPropertyByConst(nItemPropertyConst, oRing2Old);
    bHas = bHas || CSLGetHasItemPropertyByConst(nItemPropertyConst, oAmuletOld);
    bHas = bHas || CSLGetHasItemPropertyByConst(nItemPropertyConst, oCloakOld);
    if (bHas)
        return TRUE;
    bHas = bHas || CSLGetHasItemPropertyByConst(nItemPropertyConst, oBootsOld);
    bHas = bHas || CSLGetHasItemPropertyByConst(nItemPropertyConst, oBeltOld);
    bHas = bHas || CSLGetHasItemPropertyByConst(nItemPropertyConst, oHelmetOld);

    return bHas;

}

/**  
* returns true if item equipped
*  sItemTag - tag of the item to look for
*  oPartyMember - creature whose equipment is to be searched.
*  bExactMatch - whether or not to search tags with exact or partial matches
* @author
* @param 
* @see 
* @replaces XXXGetIsItemEquipped
* @return 
*/
int CSLGetIsItemEquipped(string sItemTag, object oCreature, int bExactMatch = TRUE)
{
    object oItem;
    string sFoundTag;
	int nSlot;
	
    for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
    {
        oItem = GetItemInSlot(nSlot, oCreature);

        if (TRUE == GetIsObjectValid(oItem))
		{
			sFoundTag = GetTag(oItem);

			if (FALSE == bExactMatch)
			{
				if (FindSubString(sFoundTag, sItemTag) != -1)
					return TRUE;
			}
			else
			{
				if (sFoundTag == sItemTag)
					return TRUE;
			}
        }
    }
    return FALSE;
}

/**  
* returns true if any party member has item equipped
*  sItemTag - tag of the item to look for
*  oPartyMember - Any member of the party
*  bPCOnly - Include only PC's or everyone in the party.  Default is only the PCs.
* @author
* @param 
* @see 
* @replaces XXXGetPartyMemberHasEquipped
* @return 
*/
int CSLGetPartyMemberHasEquipped(string sItemTag, object oPartyMember, int bPCOnly=TRUE, int bExactMatch = TRUE)
{
    object oMember = GetFirstFactionMember(oPartyMember, bPCOnly); // Needed GetFirstPC() to run through PC List

    while (oMember != OBJECT_INVALID)
    {
        if (CSLGetIsItemEquipped(sItemTag, oMember, bExactMatch))
            return TRUE;
        oMember = GetNextFactionMember(oPartyMember, bPCOnly);
    }
    return FALSE;
}

/**  
* Take item from player inventory if possessed
* currently if stackable, takes whole stack.
* return true if object was available to be removed
* @author
* @param 
* @see 
* @replaces XXXRemoveItem
* @return 
*/
int CSLRemoveItem (object oCreature, string sItemTag)
{
	int iRet = FALSE;
    object oItemToTake = GetItemPossessedBy(oCreature, sItemTag);
    if(GetIsObjectValid(oItemToTake))
	{
        DestroyObject(oItemToTake);
		iRet = TRUE;
	}
	return iRet;
}


/**  
* This is solely for items with a stack size where only a portion should be given and split between two players
* @author
* @param oItem Item to transfer
* @param oTarget the receive of the number of specified items
* @param iNumberItems number of items to transfer, if it's larger than the stack size it will transfer the entire item
* @todo look at notification on splitting, i have it hidden at the moment
* @see 
* @return 
*/
void CSLSplitAndTransferItem( object oItem, object oTarget, int iNumberItems )
{
	int nStackSize = GetNumStackedItems(oItem);
	int iNumberToGive = CSLGetMin(iNumberItems,nStackSize);
	int iNumberToKeep = CSLGetMax(0,nStackSize-iNumberToGive);
	if ( iNumberToKeep > 0 && iNumberToGive > 0 )
	{
		SetItemStackSize( oItem,iNumberToGive, FALSE);
		CopyItem(oItem, oTarget, TRUE);
		SetItemStackSize( oItem,nStackSize, FALSE);
		SetItemStackSize( oItem,iNumberToKeep, TRUE); // now notify the target
	}
	else if ( iNumberToGive > 0 )
	{
		ActionGiveItem(oItem,oTarget);
	}
}




/**  
* 
* @author
* @param 
* @see 
* @replaces XXXGiveNumItems
* @bug does not handle stacks properly, need to rework to properly handle items in stacks
* @return 
*/
void CSLGiveNumItems(object oTarget,string sItem,int nNumItems, int bAdjustStacks = FALSE, object oGiver = OBJECT_SELF )
{
    int iRemainingItems = nNumItems;
    int nStackSize;
    object oItem = GetFirstItemInInventory(oTarget);
	
	if ( bAdjustStacks && nNumItems != -1 ) // broke down logic into seperate so not re-evaluating this as much - nNumItems if unlimited will not deal with stacks
	{
		while (GetIsObjectValid(oItem) == TRUE && iRemainingItems > 0 )
		{
			if (GetTag(oItem) == sItem)
			{
				nStackSize = GetNumStackedItems(oItem);
				if ( nStackSize > iRemainingItems )
				{
					//SetItemStackSize( oItem, nStackSize-iRemainingItems, TRUE); // with feedback for now
					CSLSplitAndTransferItem(oItem,oTarget,iRemainingItems);
				}
				else
				{
					ActionGiveItem(oItem,oTarget);
				}
				iRemainingItems -= nStackSize;
			}
			oItem = GetNextItemInInventory(oTarget);
		}
	}
	else
	{
		while (GetIsObjectValid(oItem) == TRUE && ( nNumItems == -1 || iRemainingItems > 0 ) )
		{
			if (GetTag(oItem) == sItem)
			{
				ActionGiveItem(oItem,oTarget);
				iRemainingItems--;
			}
			oItem = GetNextItemInInventory(oTarget);
		}
	
	
	}
	return;
}


/**  
* 
* @author
* @param oTarget
* @param sItem
* @param nNumItems Number of items to remove, -1 makes it take an unlimited number of items
* @param bAdjustStacks
* @see 
* @replaces XXXTakeNumItems
* @bug does not handle stacks properly, need to rework to properly handle items in stacks
* @return 
*/
void CSLTakeNumItems(object oTarget,string sItem,int nNumItems, int bAdjustStacks = FALSE )
{
    int iRemainingItems = nNumItems;
    int nStackSize;
    object oItem = GetFirstItemInInventory(oTarget);
	
	if ( bAdjustStacks && nNumItems != -1 ) // broke down logic into seperate so not re-evaluating this as much - nNumItems if unlimited will not deal with stacks
	{
		while (GetIsObjectValid(oItem) == TRUE && iRemainingItems > 0 )
		{
			if (GetTag(oItem) == sItem)
			{
				nStackSize = GetNumStackedItems(oItem);
				if ( nStackSize > iRemainingItems )
				{
					SetItemStackSize( oItem, nStackSize-iRemainingItems, TRUE); // with feedback for now
				}
				else
				{
					ActionTakeItem(oItem,oTarget);
				}
				iRemainingItems -= nStackSize;
			}
			oItem = GetNextItemInInventory(oTarget);
		}
	}
	else
	{
		while (GetIsObjectValid(oItem) == TRUE && ( nNumItems == -1 || iRemainingItems > 0 ) )
		{
			if (GetTag(oItem) == sItem)
			{
				ActionTakeItem(oItem,oTarget);
				iRemainingItems--;
			}
			oItem = GetNextItemInInventory(oTarget);
		}
	}
	return;
}


/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXCreateItemOnFaction
* @return 
*/
void CSLCreateItemOnFaction(object oPC, string sItemResRef, int bPCOnly=TRUE)
{
    object oPartyMem = GetFirstFactionMember(oPC, bPCOnly);
    while (GetIsObjectValid(oPartyMem)) 
	{
		CreateItemOnObject(sItemResRef, oPC);
        oPartyMem = GetNextFactionMember(oPC, bPCOnly);
    }
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXDestroyItemInSlot
* @return 
*/
void CSLDestroyItemInSlot(object oTarget, int nEquipSlot)
{
	object oItem = GetItemInSlot(nEquipSlot, oTarget);
	///PrettyDebug("CSLDestroyItemInSlot() slot =" + IntToString(nEquipSlot) + " item=" + GetName(oItem));
	if (GetIsObjectValid(oItem))
	{
		DestroyObject(oItem);
	}
}
	
		
/**  
* give oTarget specified equipment and put in specified slot
* @author
* @param 
* @see 
* @replaces XXXEquipNewItem
* @return 
*/
void CSLEquipNewItem(object oTarget, string sItemResRef, int iEquipSlot, int bDestroyPrev=FALSE)
{
		
	object oItem = CreateItemOnObject(sItemResRef, oTarget, 1);
	//PrettyDebug("CSLEquipNewItem() slot =" + IntToString(iEquipSlot) + " item=" + GetName(oItem));
	
	// can't equip an unidentified item, so make sure it is identified.
	SetIdentified(oItem, TRUE);
	//Equip item (need time to allow item to appear)
	if (iEquipSlot >= 0)
	{
		if (bDestroyPrev)
			CSLDestroyItemInSlot(oTarget, iEquipSlot);
		DelayCommand(0.5, AssignCommand(oTarget, ActionEquipItem(oItem, iEquipSlot)));
	}		
}



/**  
* give all w/ sTargetTag, specified equipment and put in specified slot
* @author
* @param 
* @see 
* @replaces XXXDoEquipmentUpgrade
* @return 
*/
void CSLDoEquipmentUpgrade(string sTargetTag, string sItemResRef, int iEquipSlot)
{
	int i = 0;
	object oTarget = GetObjectByTag(sTargetTag, i);
	while (GetIsObjectValid(oTarget))
	{
//		PrintString("Equiping NPC " + GetName(oTarget) + " - index " + IntToString(i));
		CSLEquipNewItem(oTarget, sItemResRef, iEquipSlot);
		oTarget = GetObjectByTag(sTargetTag, ++i);
	}
	//DebugMessage("Total number of creatures updated: " + IntToString(i));
}


/**  
* store info on item about current owner and slot equipped
* @author
* @param 
* @see 
* @replaces XXXRememberEquippedItem
* @return 
*/
void CSLRememberEquippedItem(object oOwner, int iSlot)
{
	object oInventoryItem = GetItemInSlot(iSlot, oOwner);
	if (oInventoryItem != OBJECT_INVALID)
	{
		SetLocalInt(oInventoryItem, SC_LAST_SLOT_NUM, iSlot);
		SetLocalObject(oInventoryItem, SC_LAST_SLOT_OBJ, oOwner);
	}
}


/**  
* store info on all equipped items of owner
* @author
* @param 
* @see 
* @replaces XXXRememberEquippedItems
* @return 
*/
void CSLRememberEquippedItems(object oOwner)
{
    int iSlot;
    for (iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
    {
		CSLRememberEquippedItem(oOwner, iSlot);
    }
}



/**  
* restore item to slot last remembered
* @author
* @param 
* @see 
* @replaces XXXRestoreEquippedItem
* @return 
*/
void CSLRestoreEquippedItem(object oOwner, object oInventoryItem, int bReset=TRUE)
{
	int iSlot = GetLocalInt(oInventoryItem, SC_LAST_SLOT_NUM);
	//object oOrigOwner = GetLocalObject(oInventoryItem, SC_LAST_SLOT_OBJ);

	if (iSlot > 0)
	{
	    AssignCommand(oOwner, ActionEquipItem(oInventoryItem, iSlot));
		if (bReset)
		{
			DeleteLocalInt(oInventoryItem, SC_LAST_SLOT_NUM);
			DeleteLocalObject(oInventoryItem, SC_LAST_SLOT_OBJ);
		}
	}
}

/**  
* Restore all inventory items to equipment slot last remembered (if any)
* @author
* @param 
* @see 
* @replaces XXXRestoreEquippedItems
* @return 
*/
void CSLRestoreEquippedItems(object oOwner, int bReset=TRUE)
{
    object oInventoryItem = GetFirstItemInInventory(oOwner);
	object oLeftHandItem;
	int iSlot;
	
	while (oInventoryItem != OBJECT_INVALID)
    {
		iSlot = GetLocalInt(oInventoryItem, SC_LAST_SLOT_NUM);
		
		//EPF 8/29/06 left hand must be equipped after right.  Otherwise the engine
		//    will shift it to the right hand slot automatically.
		if(iSlot != INVENTORY_SLOT_LEFTHAND)
		{
			CSLRestoreEquippedItem(oOwner, oInventoryItem, bReset);
	        oInventoryItem = GetNextItemInInventory(oOwner);
		}
		else
		{
			oLeftHandItem = oInventoryItem;
		}
    }
	
	if(GetIsObjectValid(oLeftHandItem))
	{
		CSLRestoreEquippedItem(oOwner, oLeftHandItem, bReset);
	}
}

/**  
* unequip item in specified slot, if any
* @author
* @param 
* @see 
* @replaces XXXUnequipSlot
* @return 
*/
void CSLUnequipSlot(object oOwner, int iSlot)
{
	object oInventoryItem = GetItemInSlot(iSlot, oOwner);
	if (oInventoryItem != OBJECT_INVALID)
	{		
		AssignCommand(oOwner, ActionUnequipItem(oInventoryItem));
	}		
}


/**  
* Transfer an item from giver to receiver.
* objects lack an action queue, so 
* @author
* @param 
* @see 
* @replaces XXXTransferItem
* @return 
*/
void CSLTransferItem(object oGiver, object oReceiver, object oInventoryItem, int bDisplayFeedback=TRUE)
{
	// placeable give/take item commands are most dependable
	if (GetObjectType(oReceiver) == OBJECT_TYPE_PLACEABLE)
	{ // the receiver is a creature, so he can be assigned ActionTakeItem() commands to his queue
        AssignCommand(oReceiver, ActionTakeItem(oInventoryItem, oGiver, bDisplayFeedback));
	}
	else //if ((GetObjectType(oGiver) == OBJECT_TYPE_PLACEABLE)
	{ // if both are creatures, giving item better than taking since taking causes movement.
        AssignCommand(oGiver, ActionGiveItem(oInventoryItem, oReceiver, bDisplayFeedback));
	}
}



/**  
* passing around carried stuff.
* @author
* @param 
* @see 
* @replaces XXXGiveEquippedItem
* @return 
*/
void CSLGiveEquippedItem(object oGiver, object oReceiver, int iSlot, int bDisplayFeedback=TRUE)
{	
	if (GetObjectType(oGiver) != OBJECT_TYPE_CREATURE)
	{
		//PrettyError("CSLGiveEquippedItem(): Equipped Item Giver must be a creature!");		
		return;
	}

	object oInventoryItem = GetItemInSlot(iSlot, oGiver);

	if (oInventoryItem != OBJECT_INVALID)
	{
		AssignCommand(oGiver, ActionUnequipItem(oInventoryItem));
		//AssignCommand(oReceiver, ActionTakeItem(oInventoryItem, oGiver));
        //AssignCommand(oGiver, ActionGiveItem(oInventoryItem, oReceiver));
		CSLTransferItem(oGiver, oReceiver, oInventoryItem, bDisplayFeedback);
	}
}
	
/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXGiveAllEquippedItems
* @return 
*/
void CSLGiveAllEquippedItems(object oGiver, object oReceiver, int bDisplayFeedback=TRUE)
{	
    int iSlot;
    for (iSlot = 0; iSlot < NUM_INVENTORY_SLOTS; iSlot++)
    {
		CSLGiveEquippedItem(oGiver, oReceiver, iSlot, bDisplayFeedback);
    }
}



/**  
* are bags passed as full bags, or traversed?
* inventory space limits?
* stacked items?
* @author
* @param 
* @see 
* @replaces XXXGiveAllInventory
* @return 
*/
void CSLGiveAllInventory(object oGiver, object oReceiver, int bDisplayFeedback=TRUE)
{
	//if ((GetObjectType(oGiver) != OBJECT_TYPE_CREATURE) && (GetObjectType(oReceiver) != OBJECT_TYPE_CREATURE))
	//{
	//	PrettyError("CSLGiveAllInventory(): At least one of Giver or Receiver must be a creature.");		
	//	return;
	//}

    object oInventoryItem = GetFirstItemInInventory(oGiver);
    while (oInventoryItem != OBJECT_INVALID)
    {
		CSLTransferItem(oGiver, oReceiver, oInventoryItem, bDisplayFeedback);
        //AssignCommand(oGiver, ActionGiveItem(oInventoryItem, oReceiver));
        oInventoryItem = GetNextItemInInventory(oGiver);
    }
}

/**  
* give gold, equipped items, and inventory
* @author
* @param 
* @see 
* @replaces XXXGiveEverything
* @return 
*/
void CSLGiveEverything(object oGiver, object oReceiver, int bDisplayFeedback=TRUE)
{
	if (GetObjectType(oGiver) != OBJECT_TYPE_CREATURE)
	{
		//PrettyError("CSLGiveEverything(): Everything Giver must be a creature!");		
		return;
	}

    int iGold = GetGold(oGiver);// Remove gold to crate
    AssignCommand(oReceiver, TakeGoldFromCreature(iGold, oGiver, FALSE));
	CSLGiveAllEquippedItems(oGiver, oReceiver, bDisplayFeedback);
	CSLGiveAllInventory(oGiver, oReceiver, bDisplayFeedback);
}






/**  
* Wrapper for CreateItemOnObject.
* @author
* @param 
* @see 
* @replaces XXXWrapperCreateItemOnObject
* @return 
*/
void CSLWrapperCreateItemOnObject(string sItemTemplate, object oTarget=OBJECT_SELF, int nStackSize=1, string sNewTag="", int bDisplayFeedback=1)
{
	CreateItemOnObject(sItemTemplate, oTarget, nStackSize, sNewTag, bDisplayFeedback);
}


/**  
* Wrapper for CopyItem
* @author
* @param 
* @see 
* @replaces XXXWrapperCopyItem
* @return 
*/
void CSLWrapperCopyItem(object oItem, object oTargetInventory = OBJECT_INVALID, int bCopyVars = FALSE)
{
	CopyItem(oItem, oTargetInventory, bCopyVars);
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
object CSLGetAmmo(object oPC)
{
   object oWeapon=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
   int nWeaponType = GetBaseItemType(oWeapon);
   if (nWeaponType==BASE_ITEM_DART || nWeaponType==BASE_ITEM_SHURIKEN || nWeaponType==BASE_ITEM_THROWINGAXE) return oWeapon;
   if (nWeaponType==BASE_ITEM_LONGBOW || nWeaponType==BASE_ITEM_SHORTBOW) return GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
   else if (nWeaponType==BASE_ITEM_LIGHTCROSSBOW || nWeaponType == BASE_ITEM_HEAVYCROSSBOW) return GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
   else if (nWeaponType==BASE_ITEM_SLING) return GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
   return OBJECT_INVALID;
}



/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
object CSLGetWeapon(object oPC)
{
  object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if (GetIsObjectValid(oWeapon))
  {
     if (GetWeaponRanged(oWeapon)) return CSLGetAmmo(oPC);
     if (CSLItemGetIsMeleeWeapon(oWeapon)) return oWeapon;
  }
  oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
  if (GetIsObjectValid(oWeapon)) return oWeapon;
  oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
  if (GetIsObjectValid(oWeapon)) return oWeapon;
  oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
  if (GetIsObjectValid(oWeapon)) return oWeapon;
  return OBJECT_INVALID;
}



/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
* @todo need to make this actually work
*/
int CSLGetCanRaceWieldWeapon( object oItem, object oChar = OBJECT_SELF )
{
 	// need to filter out the **** results somehow, perhaps a -1 function wrapper to allow voids as -1
 	int iItemType = GetBaseItemType(oItem);
 	
 	/*
 	invslot
	x00000 ' Not equipable
	0x00001 ' Helmet
	0x00002 ' Armor
	0x00004 ' Boots
	0x00008 ' Arms
	0x00010 ' Right Hand
	0x00020 ' Left Hand
	0x00040 ' Cloak
	0x00080 ' Left Ring
	0x00100 ' Right Ring
	0x00200 ' Neck
	0x00400 ' Belt
	0x00800 ' Arrow
	0x01000 ' Bullet
	0x02000 ' Bolt
	0x1C000 ' Creature Weapon
	0x1C010 ' Two-handed Weapon
	0x1C030 ' One-handed Weapon
	0x20000 ' Creature Armor
 	*/
 	
	int iWeaponWield =  ( StringToInt(Get2DAString("baseitems","WeaponWield",iItemType)));
	// returns **** or 1 - 13
	/*
	0 = standard one-handed weapon;
	1 = not wieldable;
	4 = two-handed weapon;
	5 = bow;
	6 = crossbow;
	7 = shield;
	8 = double-sided weapon;
	9 = creature weapon;
	10 = dart or sling;
	11 = shuriken or throwing axe.
	*/

	int iWeaponType =  ( StringToInt(Get2DAString("baseitems","WeaponType",iItemType)));
	// returns **** or 1 - 4
	/*
	The type of damage inflicted by this weapon (item). 1 = piercing; 2 = bludgeoning; 3 = slashing; 4 = piercing-slashing; 5 = bludgeoning-piercing.*/
	
	
	int iWeaponSize =  ( StringToInt(Get2DAString("baseitems","WeaponSize",iItemType)));
	// returns **** or 0 - 4
 	/* The size of this weapon (item).
	1 - Tiny
	2 - Small
	3 - Medium
	4 - Large
	5 - Huge
	*/
 	
 // int CREATURE_SIZE_INVALID = 0;
//int CREATURE_SIZE_TINY =    1;
//int CREATURE_SIZE_SMALL =   2;
//int CREATURE_SIZE_MEDIUM =  3;
//int CREATURE_SIZE_LARGE =   4;
//int CREATURE_SIZE_HUGE =    5;
  
  // Get the size (CREATURE_SIZE_*) of oCreature.
//int GetCreatureSize(object oCreature);

//WeaponWield
	return TRUE;
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetHasFeatForItem( object oItem, object oChar = OBJECT_SELF )
{
	int bHasFeatForWeapon = FALSE;
	
	int iItemType = GetBaseItemType(oItem);
	int iReqFeat0 =  ( StringToInt(Get2DAString("baseitems","ReqFeat0",iItemType)));
	if ( iReqFeat0 != 0 && GetHasFeat( iReqFeat0, oChar ) ) // feat 0 is not a weapon feat, and will come up if item has **** in required feat
	{
		return TRUE;
	}
	
	int iReqFeat1 =  ( StringToInt(Get2DAString("baseitems","ReqFeat1",iItemType)));
	if ( iReqFeat1 != 0 && GetHasFeat( iReqFeat1, oChar ) )
	{
		return TRUE;
	}
	
	int iReqFeat2 =  ( StringToInt(Get2DAString("baseitems","ReqFeat2",iItemType)));
	if ( iReqFeat2 != 0 && GetHasFeat( iReqFeat2, oChar ) )
	{
		return TRUE;
	}
	
	int iReqFeat3 =  ( StringToInt(Get2DAString("baseitems","ReqFeat3",iItemType)));
	if ( iReqFeat3 != 0 && GetHasFeat( iReqFeat3, oChar ) )
	{
		return TRUE;
	}
	
	int iReqFeat4 =  ( StringToInt(Get2DAString("baseitems","ReqFeat4",iItemType)));
	if ( iReqFeat4 != 0 && GetHasFeat( iReqFeat4, oChar ) )
	{
		return TRUE;
	}
	
	int iReqFeat5 =  ( StringToInt(Get2DAString("baseitems","ReqFeat5",iItemType)));
	if ( iReqFeat5 != 0 && GetHasFeat( iReqFeat5, oChar ) )
	{
		return TRUE;
	}
	return FALSE;


//int FEAT_WEAPON_PROFICIENCY_MARTIAL     = 45;  
//int FEAT_WEAPON_PROFICIENCY_EXOTIC      = 44;
//int FEAT_WEAPON_PROFICIENCY_SIMPLE      = 46;
//int FEAT_WEAPON_PROFICIENCY_DRUID       = 48;
//int FEAT_WEAPON_PROFICIENCY_MONK        = 49;
//int FEAT_WEAPON_PROFICIENCY_ROGUE       = 50;
//int FEAT_WEAPON_PROFICIENCY_WIZARD      = 51;
//int FEAT_WEAPON_PROFICIENCY_ELF         = 256;
//int FEAT_WEAPON_PROFICIENCY_CREATURE    = 289;
//int FEAT_WEAPON_PROFICIENCY_GRAYORC = 2177;

//int IP_CONST_FEAT_WEAPON_PROF_EXOTIC            = 21;
//int IP_CONST_FEAT_WEAPON_PROF_SIMPLE            = 22;
//int IP_CONST_FEAT_WEAPON_PROF_MARTIAL           = 23;
//int IP_CONST_FEAT_ARMOR_PROF_HEAVY              = 24;
//int IP_CONST_FEAT_ARMOR_PROF_LIGHT              = 25;
//int IP_CONST_FEAT_ARMOR_PROF_MEDIUM             = 26;
  
  
  //int nBT = GetBaseItemType(oItem);
  //int nWeapon =  ( StringToInt(Get2DAString("baseitems","WeaponType",nBT)));
  // 2 = bludgeoning
  //return (nWeapon == 2);
}


/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLDestroyObjectDropped(object oItem)
{
   if (GetIsObjectValid(oItem))
   {
      if (GetLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM") == 1) 
      {
         DeleteLocalInt(oItem, "PC_DOES_NOT_POSSESS_ITEM");
         if (GetItemStackSize(oItem) > 1) SetItemStackSize(oItem, 1);
         DestroyObject(oItem);
      }
   }
}



/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetIsItemStackable(object oItem)
{
	int nType = GetBaseItemType(oItem);
	int nStacking = StringToInt(Get2DAString("baseitem", "Stacking", nType));
	if ( nStacking > 1 )
	{
	return TRUE;
	}
		else if ( nStacking == 1 )
	{
		return FALSE;
	}
	return -1;
}




/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXHasItem, HasItemByTag, XXXCSLHasItem, XXXBot9SHasItem
* @return 
*/
int CSLHasItemByTag(object oCreature, string sTag)
{
	if (GetIsObjectValid(oCreature))
	{
		return  GetIsObjectValid(GetItemPossessedBy(oCreature, sTag));
    }
	return FALSE;
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLDontDropGear(object oPC, int bIgnoreGems=FALSE)
{
	TakeGoldFromCreature(GetGold(oPC), oPC, TRUE);
	SetLootable(oPC, FALSE);
	object oItem = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(oItem))
	{
		SetPlotFlag(oPC, FALSE);
		if (!bIgnoreGems || GetBaseItemType(oItem)!=BASE_ITEM_GEM) DestroyObject(oItem);
		oItem = GetNextItemInInventory(oPC);
	}
	int i;
	for (i = 0; i < NUM_INVENTORY_SLOTS; i++)
	{
		oItem = GetItemInSlot(i, oPC);
		if (GetIsObjectValid(oItem))
		{
			SetDroppableFlag(oItem, FALSE);
			SetPickpocketableFlag(oItem, FALSE);
		}
	}
}


/**  
* Description
* @author PRC
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLForceEquip(object oPC, object oItem, int nSlot, int nThCall = 0)
{
	// Sanity checks
	// Make sure the parameters are valid
	if(!GetIsObjectValid(oPC)) return;
	if(!GetIsObjectValid(oItem)) return;
	
	// Make sure that the object we are attempting equipping is the latest one to be ForceEquipped into this slot
	if( GetIsObjectValid(GetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot))) && GetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot)) != oItem )
	{
		return;
	}
	float fDelay;
	
	// Check if the equipping has already happened
	if(GetItemInSlot(nSlot, oPC) != oItem)
	{
		// Test and increment the control counter
		if(nThCall++ == 0)
		{
			// First, try to do the equipping non-intrusively and give the target a reasonable amount of time to do it
			AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
			fDelay = 1.0f;
			
			// Store the item to be equipped in a local variable to prevent contest between two different calls to CSLForceEquip
			SetLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot), oItem);
		}
		else
		{
			// Nuke the target's action queue. This should result in "immediate" equipping of the item
			AssignCommand(oPC, ClearAllActions());
			AssignCommand(oPC, ActionEquipItem(oItem, nSlot));
			// Use a lenghtening delay in order to attempt handling lag and possible other interference. From 0.1s to 1s
			fDelay = CSLGetMin(nThCall, 10) / 10.0f;
		}
		
		// Loop
		DelayCommand(fDelay, CSLForceEquip(oPC, oItem, nSlot, nThCall));
	}
	else // It has, so clean up
	{
		DeleteLocalObject(oPC, "ForceEquipToSlot_" + IntToString(nSlot));
	}
}

/**  
* Description
* @author PRC
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLForceUnequip(object oPC, object oItem, int nSlot, int nThCall = 0)
{
    // Sanity checks
    if(!GetIsObjectValid(oPC)) return;
    if(!GetIsObjectValid(oItem)) return;

    float fDelay;

    // Delay the first unequipping call to avoid a bug that occurs when an object that was just equipped is unequipped right away
    // - The item is not unequipped properly, leaving some of it's effects in the creature's stats and on it's model.
    if(nThCall == 0)
    {
        //DelayCommand(0.5, CSLForceUnequip(oPC, oItem, nSlot, FALSE));
        fDelay = 0.5;
    }
    else if( GetItemInSlot(nSlot, oPC) == oItem )
    {
        // Attempt to avoid interference by not clearing actions before the first attempt
        if(nThCall > 1)
        {
            AssignCommand(oPC, ClearAllActions());
		}
        AssignCommand(oPC, ActionUnequipItem(oItem));

        // Ramp up the delay if the action is not getting through. Might let whatever is intefering finish
        fDelay = CSLGetMin(nThCall, 10) / 10.0f;
    }
    else // The item has already been unequipped
    {
        return;
	}
	
    // Loop
    DelayCommand(fDelay, CSLForceUnequip(oPC, oItem, nSlot, ++nThCall));
}



/**  
* written by caos as part of dm inventory system, integrating
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLEquipItem(object oItem, int iSlot)
{
    ClearAllActions();
    ActionEquipItem(oItem, iSlot);
}

/**  
* gets the skin for the creature, if it does not exist it creates one
* @author PRC did this, adapting to make it a standard
* @param 
* @see 
* @replaces XXXGetPCSkin
* @return 
*/
object CSLGetPCSkin( object oPC )
{
// According to a bug report, this is being called on non-creature objects. This should catch the culprit
//if(DEBUGGING) CSLAssert(GetObjectType(oPC) == OBJECT_TYPE_CREATURE, "GetObjectType(oPC) == OBJECT_TYPE_CREATURE", "GetPRCSkin() called on non-creature object: " + DebugObject2Str(oPC), "inc_item_props", "object CSLGetPCSkin(object oPC)");
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (!GetIsObjectValid(oSkin))
    {
        oSkin = GetLocalObject(oPC, "CSLSkinCache");
        if(!GetIsObjectValid(oSkin))
        {
            oSkin = GetItemPossessedBy(oPC, "csl_base_skin");
		}
		
		if(!GetIsObjectValid(oSkin))
        {
        	 oSkin = CreateItemOnObject("x2_it_emptyskin", oPC, 1, "csl_base_skin", FALSE);
        }
        
        if( GetIsObjectValid(oSkin) )
        {
			SetDroppableFlag(oSkin, FALSE);
			CSLForceEquip(oPC, oSkin, INVENTORY_SLOT_CARMOUR);

            // Cache the skin reference for further lookups during the same script
            SetLocalObject(oPC, "CSLSkinCache", oSkin);
            DelayCommand(0.1f, DeleteLocalObject(oPC, "CSLSkinCache"));
        }
    }
    return oSkin;
}



/**  
* keeps a given item in the given slot, mainly used so the tint works for minotaurs which look bad when actually naked, item should stick in the slot
 * CSLForceItem( oPC, "NOCRAFT_MINOARMOR", INVENTORY_SLOT_CHEST, "NW_CLOTH001", TRUE );
 * iForceNoProperties assumes the item has no properties that is placed, it can cause an issue if it's forcing no properties and the item has properties.
 * probably can modify soas to strip properties.
 * this is too messy and complicated, need to rewrite it later to do basically the same thing but make it cleaner
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLForceItem( object oPC, string sItemTag, int iInventorySlot, string sResRef, int iForceNoProperties ) // "NOCRAFT_MINOARMOR", INVENTORY_SLOT_CHEST, "nw_cloth015", TRUE
{
	object oItem = GetItemInSlot(iInventorySlot, oPC);	
	object oCorrectItem;
	int bEquipped = FALSE;
	
	
	if ( GetIsObjectValid(oItem) )
	{	
		if ( GetTag(oItem) != sItemTag )
		{
			AssignCommand( oPC, ActionUnequipItem(oItem) );
			oCorrectItem = GetItemPossessedBy(oPC, sItemTag);
		}
		else
		{
			oCorrectItem = oItem;
			bEquipped = TRUE;
		}
	}
	else
	{
		oCorrectItem = GetItemPossessedBy(oPC, sItemTag);
	}
	
	if ( GetIsObjectValid( oCorrectItem ) )
	{
		if (  iForceNoProperties && GetIsItemPropertyValid( GetFirstItemProperty( oCorrectItem ) ) )
		{
			DestroyObject( oCorrectItem, 0.0f, FALSE);
			oCorrectItem = CreateItemOnObject(sResRef, oPC, 1, sItemTag, FALSE);
			SetIdentified(oCorrectItem, TRUE);
			SetDroppableFlag(oCorrectItem, FALSE);
			SetPickpocketableFlag(oCorrectItem, FALSE);
			AssignCommand( oPC, ActionEquipItem(oCorrectItem, iInventorySlot ) );
		}
		else if ( !bEquipped )
		{
			AssignCommand( oPC, ActionEquipItem(oCorrectItem, iInventorySlot ) );
		}
		
	}
	else
	{
		oCorrectItem = CreateItemOnObject(sResRef, oPC, 1, sItemTag, FALSE);
		SetIdentified(oCorrectItem, TRUE);
		SetDroppableFlag(oCorrectItem, FALSE);
		SetPickpocketableFlag(oCorrectItem, FALSE);
		AssignCommand( oPC, ActionEquipItem(oCorrectItem, iInventorySlot ) );
	}
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
object CSLCreateSingleItemOnObject( string sResref, object oTarget = OBJECT_SELF, int nStackSize =1, string sNewTag = "", int bDisplayFeedback = 1 )
{
	object oItem = GetItemPossessedBy( oTarget, sNewTag );
	
	if ( !GetIsObjectValid( oItem ) )
	{
		oItem = CreateItemOnObject(sResref, oTarget, nStackSize, sNewTag, bDisplayFeedback);    // Loftenwood Stone
		//SendMessageToPC( oTarget, "Does not have item, new tag is "+GetTag( oItem ) );
	}
	return oItem;
}


/**  
* Description
* @author Cerea and Kivinen
* @param 
* @see 
* @replaces XXX
* @return 
*/
string CSLGetResrefItemBasedOnPlaceable( string sResRef )
{
	//SpeakString("CSLGetResrefItemBasedOnPlaceable: "+sResRef);
	if (sResRef == "plc_mc_bann201") { return "nw_it_bann201"; }
	else if (sResRef == "plc_mc_bann202") { return "nw_it_bann202"; }
	else if (sResRef == "plc_mc_bann203") { return "nw_it_bann203"; }
	else if (sResRef == "plc_mc_bann204") { return "nw_it_bann204"; }
	else if (sResRef == "plc_mc_bann205") { return "nw_it_bann205"; }
	else if (sResRef == "plc_mc_bann206") { return "nw_it_bann206"; }
	else if (sResRef == "plc_mc_bann207") { return "nw_it_bann207"; }
	else if (sResRef == "plc_mc_bann210") { return "nw_it_bann210"; }
	else if (sResRef == "plc_mc_bann211") { return "nw_it_bann211"; }
	else if (sResRef == "plc_mc_bann212") { return "nw_it_bann212"; }
	else if (sResRef == "plc_mc_bann213") { return "nw_it_bann213"; }
	else if (sResRef == "plc_mc_bann214") { return "nw_it_bann214"; }
	else if (sResRef == "plc_mc_bann215") { return "nw_it_bann215"; }
	else if (sResRef == "plc_mc_bann216") { return "nw_it_bann216"; }
	return "";
}



/**  
* Description
* @author Cerea and Kivinen
* @param 
* @see 
* @replaces XXX
* @return 
*/
string CSLGetResrefPlaceableBasedOnItem( string sResRef )
{
	//SpeakString("CSLGetResrefPlaceableBasedOnItem: "+sResRef);
	if (sResRef == "nw_it_bann201") { return "plc_mc_bann201"; }
	else if (sResRef == "nw_it_bann202") { return "plc_mc_bann202"; }
	else if (sResRef == "nw_it_bann203") { return "plc_mc_bann203"; }
	else if (sResRef == "nw_it_bann204") { return "plc_mc_bann204"; }
	else if (sResRef == "nw_it_bann205") { return "plc_mc_bann205"; }
	else if (sResRef == "nw_it_bann206") { return "plc_mc_bann206"; }
	else if (sResRef == "nw_it_bann207") { return "plc_mc_bann207"; }
	else if (sResRef == "nw_it_bann208") { return "plc_mc_bann208"; }
	else if (sResRef == "nw_it_bann209") { return "plc_mc_bann209"; }
	else if (sResRef == "nw_it_bann210") { return "plc_mc_bann210"; }
	else if (sResRef == "nw_it_bann211") { return "plc_mc_bann211"; }
	else if (sResRef == "nw_it_bann212") { return "plc_mc_bann212"; }
	else if (sResRef == "nw_it_bann213") { return "plc_mc_bann213"; }
	else if (sResRef == "nw_it_bann214") { return "plc_mc_bann214"; }
	else if (sResRef == "nw_it_bann215") { return "plc_mc_bann215"; }
	else if (sResRef == "nw_it_bann216") { return "plc_mc_bann216"; }
	return "";
}


/**  
* Description
* @author Cerea and Kivinen
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLDropItemAndMakePlaceable(object oPC, object oItem, int bForceDrop = FALSE )
{
	object oArea;
	string sRef;
	//SendMessageToPC( oPC, "CSLDropItemAndMakePlaceable start "+IntToString(bForceDrop)+ " Victim=" +GetName(oPC) + " Item=" +GetName( oItem) );
	// Check if it was dropped on the ground
	if ( bForceDrop )
	{
		//SendMessageToPC( oPC, "Area based on PC" );
		oArea = GetArea(oPC);
	}
	else
	{
		//SendMessageToPC( oPC, "Area Based on Item" );
		oArea = GetArea(oItem);
	}
	if (!GetIsObjectValid(oArea))
	{
		// No area, thus not dropped on the ground, return
		//SendMessageToPC( oPC, "Invalid area" );
		return;
	}
	
	sRef = CSLGetResrefPlaceableBasedOnItem( GetResRef( oItem ) );
	//if ( bForceDrop && sRef == "")
	//{
	//	sRef = "";
	//}
	//SendMessageToPC( oPC, "Working on dropping "+sRef );
	if (sRef != "")
	{
		object oPlc, oNewItem;
		string sNewRef;
		location lLoc;
		vector vVec;
		float fFace;
		if ( bForceDrop )
		{
			lLoc = GetLocation(oPC); // make this random
		}
		else
		{
			lLoc = GetLocation(oItem);
		}
		
		vVec = GetPositionFromLocation(lLoc);
		// The item placed on the ground seems to be bit high up, so adjust
		// it down a bit
		vVec.z -= 0.1;
		fFace = GetFacing(oPC);
		lLoc = Location(oArea, vVec, fFace);
		//SendMessageToPC( oPC, "Dropping at "+CSLSerializeLocation( lLoc ) );
		// Removing this, soas to just use the real tag name
		// sRef = "plc_fl_" + sRef;
		
		// Note that GetItemAppearance nType and nIndex defines do not match the
		// real use. To get weapon blade model you need to set nType = 1 and
		// nIndex = 0.
		//sNewRef = sRef +
		//  GetStringRight("00" +
		//                 IntToString(GetItemAppearance(oItem,
		//                                               1, 0)), 2);
		oPlc = CreateObject(OBJECT_TYPE_PLACEABLE, sRef, lLoc, FALSE);
		//removing the following since i am using hard coded items only
		//if (!GetIsObjectValid(oPlc)) {
		//  // Didn't work, so we do not have matching model, create base model.
		//  sNewRef = sRef + "01";
		//  oPlc = CreateObject(OBJECT_TYPE_PLACEABLE, sNewRef,
		//                      lLoc, FALSE);
		//}
		//SendMessageToPC( oPC, "Created "+GetName( oPlc ) );
		if (GetIsObjectValid(oPlc))
		{
		
			//SendMessageToPC( oPC, "Location "+CSLSerializeLocation( GetLocation( oPlc ) ) );
		
			// If you want to use locked placeables instead of the placeables doing
			// their magic on Open too, change the if (0) to if (1)
			if (0)
			{
				SetKeyRequiredFeedbackMessage(oPlc, "*Use this item to pick it up*");
				SetLocked(oPlc, TRUE);
			}
			else
			{
				// New version. We do not lock the placeable anymore, but do the same
				// thing on the OnOpen, OnUsed, and OnClosed events.
				SetLocked(oPlc, FALSE);
			}
			//SendMessageToPC( oPC, "Copying "+GetName( oItem ) );
			oNewItem = CopyItem(oItem, oPlc, TRUE);
		  	SetLocalInt(oItem, "ItemDestroyed", TRUE );
			if (GetIsObjectValid(oNewItem))
			{
				// Managed to create placeable and copy item there
				// Copy description and name
				// if (GetIdentified(oItem)) {
				// Only show the name and description if identified
				SetDescription(oPlc, GetDescription(oItem));
				SetFirstName(oPlc, GetName(oItem));
				SetLastName(oPlc, "");
				//SendMessageToPC( oPC, "Setting Name "+GetName( oItem ) );
				//  } else {
				//   // Show generic name otherwise.
				//   string sName;
				//    sName = Get2DAString("baseitems", "Name", GetBaseItemType(oItem));
				//   sName = GetStringByStrRef(StringToInt(sName));
				//   SetFirstName(oPlc, sName);
				//    SetLastName(oPlc, "");
				//    SetDescription(oPlc, "");
				//  }
				//SetDescription(oNewItem, GetDescription(oItem));
				//SetFirstName(oNewItem, GetFirstName(oItem));
				//SetLastName(oNewItem, GetLastName(oItem));
				//if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Original Item: " + GetResRef(oItem) + "--FullName: " + GetName(oItem) + "--FirstName:" + GetFirstName(oItem) + "--LastNAme:" + GetLastName(oItem) +", 4"); }
				//if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Placeable: " + GetResRef(oPlc) + "--FullName: " + GetName(oPlc) + "--FirstName:" + GetFirstName(oPlc) + "--LastNAme:" + GetLastName(oPlc) +", 4"); }
				//if (DEBUGGING >= 2) { SendMessageToPC(oPC, "New Item: " + GetResRef(oNewItem) + "--FullName: " + GetName(oNewItem) + "--FirstName:" + GetFirstName(oNewItem) + "--LastNAme:" + GetLastName(oNewItem) +", 4"); }
				
				DestroyObject(oItem);
			}
			else
			{
				// Failed to copy item, destroy placeable
				//SendMessageToPC(oPC, "Copying item failed, tag = " + GetResRef(oItem));
				//SendMessageToPC( oPC, "Failure" );
				DestroyObject(oPlc);
				DeleteLocalInt(oItem, "ItemDestroyed" );
			}
		}
		
	}
}



/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLDropItem( string sResref, object oTarget = OBJECT_SELF, int bRepeat = FALSE )
{
	object oItem = GetItemPossessedBy( oTarget, sResref );
	if ( GetIsObjectValid( oItem ) )
	{
		SetDroppableFlag( oItem, TRUE);
		CSLDropItemAndMakePlaceable(oTarget, oItem, TRUE);
		//SendMessageToPC( oTarget, "Dropping " + sResref );
		//AssignCommand( oTarget, ActionPutDownItem( oItem ) );
		bRepeat = FALSE;
		if ( bRepeat )
		{
			DelayCommand( 0.5f, CSLDropItem( sResref, oTarget, bRepeat ));
		}	
	}
	//SendMessageToPC( oTarget, "Not Dropping " + sResref );
}








/**  
* note uses some custom constants for things that go in multiple spots
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetItemSlot( object oItem )
{

	switch (GetBaseItemType(oItem))
	{
		case BASE_ITEM_BRACER:
		case BASE_ITEM_GLOVES:
			return INVENTORY_SLOT_ARMS;
			break;
	
		case BASE_ITEM_ARROW:
			return  INVENTORY_SLOT_ARROWS;
			break;
	
		case BASE_ITEM_BELT:
			return  INVENTORY_SLOT_BELT;
			break;
	
		case BASE_ITEM_BOLT:
			return  INVENTORY_SLOT_BOLTS;
			break;
	
		case BASE_ITEM_BOOTS:
			return  INVENTORY_SLOT_BOOTS;
			break;
	
		case BASE_ITEM_BULLET:
			return INVENTORY_SLOT_BULLETS;
			break;
	
		case BASE_ITEM_CREATUREITEM:
			return  INVENTORY_SLOT_CARMOUR;
			break;
	
		case BASE_ITEM_ARMOR:
			return  INVENTORY_SLOT_CHEST;
			break;
	
		case BASE_ITEM_CLOAK:
			return  INVENTORY_SLOT_CLOAK;
			break;
	
		case BASE_ITEM_CBLUDGWEAPON:
		case BASE_ITEM_CPIERCWEAPON:
		case BASE_ITEM_CSLASHWEAPON:
		case BASE_ITEM_CSLSHPRCWEAP:
			return  INVENTORY_SLOT_CWEAPON;
			break;
	
		case BASE_ITEM_HELMET:
			return  INVENTORY_SLOT_HEAD;
			break;
	
		case BASE_ITEM_DRUM:
		case BASE_ITEM_FLUTE:
		case BASE_ITEM_MANDOLIN:
		case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_SMALLSHIELD:
		case BASE_ITEM_TORCH:
		case BASE_ITEM_TOWERSHIELD:
			return  INVENTORY_SLOT_LEFTHAND;
			break;

		case BASE_ITEM_HEAVYCROSSBOW:
		case BASE_ITEM_DART:
		case BASE_ITEM_SLING:
		case BASE_ITEM_LONGBOW:
		case BASE_ITEM_SHORTBOW:
		case BASE_ITEM_SHURIKEN:
		case BASE_ITEM_THROWINGAXE:
		case BASE_ITEM_LIGHTCROSSBOW:
			return  INVENTORY_SLOT_RIGHTHAND;
			break;
				
		case BASE_ITEM_ALLUSE_SWORD:
		case BASE_ITEM_BASTARDSWORD:
		case BASE_ITEM_BATTLEAXE:
		case BASE_ITEM_CLUB:
		case BASE_ITEM_DAGGER:
		case BASE_ITEM_DWARVENWARAXE:
		case BASE_ITEM_FLAIL:
		case BASE_ITEM_HANDAXE:
		case BASE_ITEM_KAMA:
		case BASE_ITEM_KATANA:
		case BASE_ITEM_KUKRI:
		case BASE_ITEM_LIGHTFLAIL:
		case BASE_ITEM_LIGHTHAMMER:
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_LONGSWORD:
		case BASE_ITEM_MACE:
		case BASE_ITEM_MORNINGSTAR:
		case BASE_ITEM_RAPIER:
		case BASE_ITEM_SCIMITAR:
		case BASE_ITEM_SHORTSWORD:
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_TRAINING_CLUB:
		case BASE_ITEM_WARHAMMER:
		case BASE_ITEM_WHIP:
		case BASE_ITEM_DIREMACE:
		case BASE_ITEM_DOUBLEAXE:
		case BASE_ITEM_FALCHION:
		case BASE_ITEM_GREATAXE:
		case BASE_ITEM_GREATSWORD:
		case BASE_ITEM_HALBERD:
		case BASE_ITEM_HEAVYFLAIL:
		case BASE_ITEM_MAGICROD:
		case BASE_ITEM_QUARTERSTAFF:
		case BASE_ITEM_SCYTHE:
		case BASE_ITEM_SHORTSPEAR:
		case BASE_ITEM_SPEAR:
		case BASE_ITEM_TWOBLADEDSWORD:
		case BASE_ITEM_WARMACE:
		case BASE_ITEM_GREATCLUB:
		case BASE_ITEM_BALORFALCHION:
		case BASE_ITEM_BALORSWORD:
		case BASE_ITEM_CGIANT_AXE:
		case BASE_ITEM_CGIANT_SWORD:
			return  INVENTORY_SLOT_HANDS;
			break;
	
		case BASE_ITEM_RING:
			return  INVENTORY_SLOT_RINGS;
			break;
	
		case BASE_ITEM_AMULET:
			return  INVENTORY_SLOT_NECK;
			break;
			
		// these were missing, need to work them back in
		case BASE_ITEM_BLANK_POTION:
		case BASE_ITEM_BLANK_SCROLL:
		case BASE_ITEM_BLANK_WAND:
		case BASE_ITEM_BOOK:
		case BASE_ITEM_BOTTLE:
		case BASE_ITEM_BOUNTYITEM:
		case BASE_ITEM_CRAFTBASE:
		case BASE_ITEM_CRAFTMATERIALMED:
		case BASE_ITEM_CRAFTMATERIALSML:
		case BASE_ITEM_ENCHANTED_POTION:
		case BASE_ITEM_ENCHANTED_SCROLL:
		case BASE_ITEM_ENCHANTED_WAND:
		case BASE_ITEM_GEM:
		case BASE_ITEM_GOLD:
		case BASE_ITEM_GRENADE:
		case BASE_ITEM_HEALERSKIT:
		case BASE_ITEM_INCANTATION:
		case BASE_ITEM_INK_WELL:
		case BASE_ITEM_KEY:
		case BASE_ITEM_LARGEBOX:
		case BASE_ITEM_LOOTBAG:
		case BASE_ITEM_MAGICSTAFF:
		case BASE_ITEM_MAGICWAND:
		case BASE_ITEM_MISCLARGE:
		case BASE_ITEM_MISCMEDIUM:
		case BASE_ITEM_MISCSMALL:
		case BASE_ITEM_MISCSTACK:
		case BASE_ITEM_MISCTALL:
		case BASE_ITEM_MISCTHIN:
		case BASE_ITEM_MISCWIDE:
		case BASE_ITEM_PAN:
		case BASE_ITEM_POT:
		case BASE_ITEM_POTIONS:
		case BASE_ITEM_RAKE:
		case BASE_ITEM_RECIPE:
		case BASE_ITEM_SCROLL:
		case BASE_ITEM_SHOVEL:
		case BASE_ITEM_SMITHYHAMMER:
		case BASE_ITEM_SOFTBUNDLE:
		case BASE_ITEM_SPELLSCROLL:
		case BASE_ITEM_SPOON:
		case BASE_ITEM_STEIN:
		case BASE_ITEM_THIEVESTOOLS:
		case BASE_ITEM_TRAPKIT:
			return INVENTORY_SLOT_INVALID;
			break;
	}
	return INVENTORY_SLOT_INVALID;
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLGetCurrentSlotForItem( object oItem )
{
  	
	if( !GetIsObjectValid(oItem) || GetObjectType(oItem) != OBJECT_TYPE_ITEM )
	{
		return INVENTORY_SLOT_INVALID;
	}
	
	object oOwner = GetItemPossessor( oItem );
	if ( !GetIsObjectValid(oOwner) )
	{
		return INVENTORY_SLOT_INVALID;
	}
	
	int iIndex;
	
	for (iIndex = 0; iIndex < NUM_INVENTORY_SLOTS; iIndex++)
	{
		if (oItem == GetItemInSlot(iIndex, oOwner))
		{
			return iIndex;
		}
	}
	
	///return -1;
	
	
	/*
	int iPossibleSlot = CSLGetItemSlot( oItem );
	
	if ( iPossibleSlot == INVENTORY_SLOT_INVALID )
	{
		return INVENTORY_SLOT_INVALID;
	}
	
	if ( iPossibleSlot == INVENTORY_SLOT_HANDS )
	{
		if ( oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oOwner ) )
		{
			return INVENTORY_SLOT_RIGHTHAND;
		}
		if ( oItem == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oOwner ) )
		{
			return INVENTORY_SLOT_LEFTHAND;
		}
		return INVENTORY_SLOT_INVALID;
	}
	
	if ( iPossibleSlot == INVENTORY_SLOT_RINGS )
	{
		if ( oItem == GetItemInSlot(INVENTORY_SLOT_LEFTRING, oOwner ) )
		{
			return INVENTORY_SLOT_LEFTRING;
		}
		if ( oItem == GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oOwner ) )
		{
			return INVENTORY_SLOT_RIGHTRING;
		}
		return INVENTORY_SLOT_INVALID;
	}
	if ( iPossibleSlot == INVENTORY_SLOT_CWEAPON )
	{
		if ( oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oOwner ) )
		{
			return INVENTORY_SLOT_CWEAPON_L;
		}
		if ( oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oOwner ) )
		{
			return INVENTORY_SLOT_CWEAPON_R;
		}
		if ( oItem == GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oOwner ) )
		{
			return INVENTORY_SLOT_CWEAPON_B;
		}
		
	}
	
	
	// iPossibleSlot can only be one possible remaining slot now
	if ( oItem == GetItemInSlot(iPossibleSlot, oOwner ) )
	{
		return iPossibleSlot;
	}
	*/
	return INVENTORY_SLOT_INVALID;
}

// @replaces IPGetACType by Vanes
int CSLGetACType(object oItem)
{
	//Declare major variables
	int iSlot = CSLGetItemSlot( oItem );
	int itemType;
	switch (iSlot)
	{
		case INVENTORY_SLOT_BOOTS:
				return IP_CONST_ACMODIFIERTYPE_DODGE;
			break;
		case INVENTORY_SLOT_NECK:
				return IP_CONST_ACMODIFIERTYPE_NATURAL;
			break;
		case INVENTORY_SLOT_ARMS:
			if (GetBaseItemType(oItem) == BASE_ITEM_BRACER)
			{
				return IP_CONST_ACMODIFIERTYPE_ARMOR;
			}
			else
			{
				return IP_CONST_ACMODIFIERTYPE_DEFLECTION;
			}
			break;
		case INVENTORY_SLOT_CHEST:
				return IP_CONST_ACMODIFIERTYPE_ARMOR;
			break;
		case INVENTORY_SLOT_LEFTHAND:
			// shield only
			itemType = GetBaseItemType(oItem);
			if ((itemType == BASE_ITEM_TOWERSHIELD) || (itemType == BASE_ITEM_LARGESHIELD) || (itemType == BASE_ITEM_SMALLSHIELD))
			{
				return IP_CONST_ACMODIFIERTYPE_SHIELD;
				
			}
			else
			{
				return IP_CONST_ACMODIFIERTYPE_DEFLECTION;
			}
			break;
		case INVENTORY_SLOT_INVALID:
				return 0;
			break;
		default:
			return IP_CONST_ACMODIFIERTYPE_DEFLECTION;
	}
	return 0;	   
}



/**  
* Description
* @author
* @param 
* @see 
* @replaces XXXGetIsCreatureSlot
* @return 
*/
int CSLGetIsCreatureSlot(int iSlot)
{
	int iRet = FALSE;
	if ((iSlot == INVENTORY_SLOT_CWEAPON_B) ||
		(iSlot == INVENTORY_SLOT_CWEAPON_L) ||
		(iSlot == INVENTORY_SLOT_CWEAPON_R) ||
		(iSlot == INVENTORY_SLOT_CARMOUR))
		iRet = TRUE;

	return (iRet);			
}

/**  
* return slot item is equipped in on creature.  -1 if not found
* @author
* @param 
* @see 
* @replaces XXXGetSlotOfEquippedItem
* @return 
*/
int CSLGetSlotOfEquippedItem(object oItem, object oCreature)
{
	int iSlot;
	object oItemInSlot;
	
	for (iSlot=0; iSlot<NUM_INVENTORY_SLOTS; iSlot++)
	{
		oItemInSlot = GetItemInSlot(iSlot, oCreature);
		if (oItemInSlot == oItem)
		{
			return iSlot;
		}
	}
	return -1;
}

/**  
* this is pretty rough and needs testing
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
int CSLCanItemGoInSlot( object oItem, int iSlot, object oPC )
{
	int iPossibleSlot = CSLGetItemSlot( oItem );
	int iItemType = GetBaseItemType(oItem);
	
	if ( iPossibleSlot == iSlot )
	{
		return TRUE;
	}
	
	if ( iPossibleSlot == INVENTORY_SLOT_INVALID )
	{
		return FALSE;
	}
	
	
	if ( iPossibleSlot == INVENTORY_SLOT_HANDS )
	{
		if ( iSlot ==  INVENTORY_SLOT_RIGHTHAND )
		{
			return TRUE;
		}
		
		if (!GetWeaponRanged(oItem) && GetHasFeat(FEAT_MONKEY_GRIP, oPC))
		{
			if ( iItemType == BASE_ITEM_DIREMACE || iItemType == BASE_ITEM_DOUBLEAXE || iItemType ==  BASE_ITEM_FALCHION || 
			iItemType == BASE_ITEM_GREATAXE || iItemType == BASE_ITEM_GREATCLUB || iItemType == BASE_ITEM_GREATSWORD ||
			iItemType == BASE_ITEM_HALBERD || iItemType ==  BASE_ITEM_HEAVYFLAIL || iItemType ==  BASE_ITEM_MAGICROD || 
			iItemType ==  BASE_ITEM_QUARTERSTAFF || iItemType == BASE_ITEM_SCYTHE || iItemType == BASE_ITEM_SHORTSPEAR ||
			 iItemType == BASE_ITEM_SPEAR || iItemType == BASE_ITEM_TWOBLADEDSWORD || iItemType == BASE_ITEM_WARMACE )
			 {
			 	return TRUE;
			 }
			 
			return FALSE;
		}
	
	
	
	
	}
	
	if ( iPossibleSlot == INVENTORY_SLOT_RINGS )
	{
		if ( iSlot == INVENTORY_SLOT_RIGHTRING || iSlot == INVENTORY_SLOT_LEFTRING )
		{
			return TRUE;
		}
	}
	
	if ( iPossibleSlot == INVENTORY_SLOT_CWEAPON )
	{
		if ( iSlot == INVENTORY_SLOT_CWEAPON_R || iSlot == INVENTORY_SLOT_CWEAPON_L  || iSlot == INVENTORY_SLOT_CWEAPON_B )
		{
			return TRUE;
		}
	}
	return FALSE;
}

void CSLDestroyObjectAndInventory(object oTarget);
void CSLClearInventory(object oTarget);

/**  
* written by caos as part of dm inventory system, integrating
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLDestroyObjectAndInventory(object oTarget)
{
	SetPlotFlag(oTarget,FALSE);
    SetImmortal(oTarget,FALSE);
    AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE));
	CSLClearInventory(oTarget);
	DestroyObject(oTarget, 0.0, FALSE);
}


/**  
* written by caos as part of dm inventory system, integrating
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLClearInventory(object oTarget)
{
	object oItem = GetFirstItemInInventory(oTarget);
	
	while (GetIsObjectValid(oItem))
	{
	
		DelayCommand(0.0, CSLDestroyObjectAndInventory(oItem));
		oItem = GetNextItemInInventory(oTarget);
	}
	return;
}

/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLDestroyInventory(object oPC)  // LEAVES SKINS AND CLAWS
{
   object oItem = GetFirstItemInInventory( oPC );
   while(GetIsObjectValid(oItem))
   {
      SetPlotFlag(oItem, FALSE);
      DestroyObject(oItem);
      oItem = GetNextItemInInventory(oPC);
   }
   int i;
   for (i = 0;i<INVENTORY_SLOT_CWEAPON_L;i++)
   {
      oItem = GetItemInSlot(i, oPC);
      if (GetIsObjectValid(oItem))
      {
         SetPlotFlag(oItem, FALSE);
         DestroyObject(oItem);
      }
   }
}



/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLDestroyItem( object oItem )
{
	if( GetIsObjectValid(oItem) )
	{
		SetPlotFlag(oItem, FALSE);
		DestroyObject(oItem);
	}
	// can't destroy it, lets curse it...
	if( GetIsObjectValid(oItem))
	{
		SetFirstName(oItem, "Cursed " + GetName(oItem));
		SetLastName(oItem, "");
		SetItemCursedFlag(oItem, TRUE);	
	}
}




/**  
* Description
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLHideHeldItems( object oCreature = OBJECT_SELF, float fDuration = 6.0f, int nVisibile = ITEMS_SHOWN_INVISIBLE, int iItemType = ITEMS_SHOWN_WEAPON )
{
	// note iItemType does not seem to do anything per a comment that it's unused, so might just do held items and not helmits.
	if ( SetWeaponVisibility(oCreature, nVisibile, iItemType ) && fDuration > 0.0f )
	{
		DelayCommand( fDuration, CSLHideHeldItems( oCreature, 0.0f, ITEMS_SHOWN_DEFAULT, iItemType ) );
	}
	
	// deal with held items, not sure if this is even needed since only example by devs does not have this
	/*
	object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	if ( SetWeaponVisibility(oWeaponNew, FALSE, 0) )
	{
		DelayCommand(5.0f, SetWeaponVisibility(oWeaponNew, 4, 0 ) ); // reset to default
	}
	*/
}


/**  
* Temporarily removes the ability of an item to cause damage
* @author
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLStopItemDamage( object oItem, float fDuration = 6.0f )
{
	AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyNoDamage(), oItem, fDuration);
	DelayCommand( fDuration, CSLRemoveMatchingItemProperties( oItem, ITEM_PROPERTY_NO_DAMAGE, DURATION_TYPE_TEMPORARY ) );
}


/**  
* Wrapper for SetWeaponVisibility.
* -nVisible: 0 for invisibile, 1 for visible, and 4 is default engine action.
* -nType: 0 - weapon, 1 - helm, 2 - both.
* @author
* @param 
* @see 
* @replaces XXXWrapperSetWeaponVisibility
* @return 
*/
void CSLWrapperSetWeaponVisibility(object oPC, int nVisable, int nType)
{
	SetWeaponVisibility(oPC, nVisable, nType);
}


//@} ****************************************************************************************************





/********************************************************************************************************/
/** @name Items to Placeable Functions
* Description
********************************************************************************************************* @{ */



/**  
* Play pickup animation. This needs to be delayed as the PC is still running
* when OnOpen and OnUsed scripts are run. The animation will be run when the
* PC has stopped, i.e. vLastPos and current position of PC are same. It will
* be delayed at max nTries times, and each operation is delayed by fDelay
* seconds. When the pickup animation is played the given sound is also played.
* @author Cerea and Kivinen
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLPickupItemAnimation(object oPC, vector vLastPos, string sSound = "", int nTries = 10, float fDelay = 0.5)
{
  vector vPos;
  vPos = GetPosition(oPC);
                   
  if (fabs(VectorMagnitude(vPos - vLastPos)) < 0.01)
  {
    // Stopped, run animation
    if (sSound != "")
    {
      PlaySound(sSound);
    }
    PlayCustomAnimation(oPC, "getground", 0);
    return;
  }
  nTries--;
  if (nTries <= 0)
  {
    return;
  }
  DelayCommand(0.5, CSLPickupItemAnimation(oPC, vPos, sSound, nTries, fDelay));
}

/**  
* Get item on the ground and destroy the placeable. This is run either from
* the OnUsed, OnLeftClick or OnOpened script.
* @author Cerea and Kivinen
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLPickupPlaceableAndMakeItem(object oPC, object oPlc)
{
	object oItem = GetFirstItemInInventory(oPlc);
	int nDoAnimation = 0;
	object oNewItem;
	string sResRef;
	string sDesc;
	string sFirstName;
	string sLastName;
	string sFullName;
	
	if (!GetIsObjectValid(oItem))
	{
    
		int nStackSize;
		
		// If we have already destroyed this placable, do not do anything.
		if ( GetLocalInt(oPlc, "ItemPlaceableDestroyed") )
		{
			if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Placeable already destroyed"); }
			return;
		}
		
		// No item inside, check variables.
		sResRef = GetLocalString(oPlc, "item_resref");
		
		if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Starting to Get: " + sResRef + "--FullName: " + sFullName + "--FirstName:" + sFirstName + "--LastNAme:" + sLastName +", 4"); }
		
		if (sResRef == "")
		{
			sResRef = GetResRef(oPlc); //GetTag(oPlc);
			if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Got PLC ResRef: " + sResRef  +", 2"); }
		
			sResRef = CSLGetResrefItemBasedOnPlaceable( sResRef );
			if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Got ResRefBasedOnPlaceable: " + sResRef  +", 3"); }
		}
		
		sDesc = GetLocalString(oPlc, "item_description");
		if (sDesc == "")
		{
			sDesc = GetDescription(oPlc);
		}
		sFirstName = GetLocalString(oPlc, "item_first_name");
		if (sFirstName == "")
		{
			sFirstName = GetFirstName(oPlc);
		}
		sLastName = GetLocalString(oPlc, "item_last_name");
		if (sLastName == "")
		{
			sLastName = GetLastName(oPlc);
		}
		sFullName = GetLocalString(oPlc, "item_full_name");
		if (sFullName == "")
		{
			sFullName = GetName(oPlc);
		}
		
		// sResRef = C_RemovePlcPrefix(sResRef);
		nStackSize = GetLocalInt(oPlc, "item_stacksize");
		if (nStackSize == 0)
		{
			nStackSize = 1;
		}
		
		oNewItem = CreateItemOnObject(sResRef, oPC, nStackSize ) ;
		
		SetDescription(oNewItem, sDesc);
		SetFirstName(oNewItem, sFirstName);
		SetLastName(oNewItem, sLastName);
		
		if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Getting: " + sResRef + "--FullName: " + sFullName + "--FirstName:" + sFirstName + "--LastNAme:" + sLastName +", 4"); }
							//  GetLocalString(oPlc, "item_tag"));
		if (!GetIsObjectValid(oNewItem))
		{
			
		// Could not create item, create generic item for the placeable.
			//SendMessageToPC(oPC, "Placing: " + sResRef + ", 2");
		  //sResRef = GetResRef(oPlc);
		  sResRef = CSLGetResrefItemBasedOnPlaceable(sResRef);
		  if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Failed Getting: " + sResRef + "--FullName: " + sFullName + "--FirstName:" + sFirstName + "--LastNAme:" + sLastName +", 1"); }
		  //SendMessageToPC(oPC, "Placing: " + sResRef + ", 3");
		  if (sResRef == "")
		  {
			//SendMessageToPC(oPC, "Aborting: " + sResRef + ", 3");
			return;
		  }
		  oNewItem = CreateItemOnObject( sResRef, oPC, nStackSize, GetLocalString(oPlc, "item_tag"));
		  if (!GetIsObjectValid(oNewItem))
		  {
			if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Could not create item sResRef = " + sResRef); }
			return;
		  }
		}
		nDoAnimation = 1;
		// Set description and name
		
		SetDescription(oNewItem, sDesc);
		SetFirstName(oNewItem, sFirstName);
		SetLastName(oNewItem, sLastName);
  } 
  else
  {
    // Copy items to the user, and destroy them
    while (GetIsObjectValid(oItem)) {
      // Skip items which have already been processed and destroyed.
      if (!GetLocalInt(oItem, "ItemPlaceableDestroyed"))
      {
        oNewItem = CopyItem(oItem, oPC, TRUE);
        if (GetIsObjectValid(oNewItem))
		{
          if (DEBUGGING >= 2) { SendMessageToPC(oPC, "Starting to Get: " + GetResRef(oItem) + "--FullName: " + GetName(oItem) + "--FirstName:" + GetFirstName(oItem) + "--LastNAme:" + GetLastName(oItem) +", 4"); }
	
			// Managed to create item
          // Copy description and name
          //SetDescription(oNewItem, GetDescription(oItem));
          //SetFirstName(oNewItem, GetFirstName(oItem));
          //SetLastName(oNewItem, GetLastName(oItem));
          SetLocalInt(oItem, "ItemPlaceableDestroyed", 1);
          DestroyObject(oItem);
          nDoAnimation = 1;
        } else {
          // Could not copy item, do not destroy placeable
          //SendMessageToPC(oPC, "Copying item failed, tag = " + tTag(oItem));
          return;
        }
      }
      oItem = GetNextItemInInventory(oPlc);
    }
  }
  
	if (nDoAnimation)
	{
		int nInvSoundType, nBaseType;
		string sSound;
		
		nBaseType = GetBaseItemType(oNewItem);
		nInvSoundType = StringToInt(Get2DAString("baseitems", "InvSoundType", nBaseType));
		sSound = Get2DAString("inventorysnds", "InventorySound", nInvSoundType);
		AssignCommand(oPC, DelayCommand(0.5, CSLPickupItemAnimation(oPC, GetPosition(oPC), sSound)));
		AssignCommand(oPC, ActionWait(1.0));
	}
	SetLocalInt(oPlc, "ItemPlaceableDestroyed", 1);
	DestroyObject(oPlc);
}


/**  
* Description
* @author Cerea and Kivinen
* @param 
* @see 
* @replaces XXX
* @return 
*/
void CSLMoveToPlaceableAndPickup(object oPC, object oPlc, int nLoop = 0)
{
	float fLimit;
	
	fLimit = 0.5 * IntToFloat( nLoop ) + 0.5;
	if (GetDistanceBetween(oPlc, oPC) < fLimit )
	{
		// SendMessageToPC(oPC, "OnLeftClicked called");
		CSLPickupPlaceableAndMakeItem(oPC, oPlc);
	}
	else
	{
		if (nLoop >= 5)
		{
			// Could not reach the location, stop trying. 
			return;
		}
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, ActionMoveToObject(oPlc, TRUE, 0.0));
		AssignCommand(oPC, ActionDoCommand(CSLMoveToPlaceableAndPickup(oPC, oPlc, ++nLoop)) );
	}
}


/**  
* Remove plc_??_ prefix
* @author Cerea and Kivinen
* @param 
* @see 
* @replaces XXX
* @return 
*/
string CSLRemovePlcPrefix(string sResRef)
{
	return sResRef;
	string sTmp;
	if (GetStringLeft(sResRef, 4) == "plc_")
	{
		sTmp = GetSubString(sResRef, 4, 3);
		if (sTmp == "fl_" || sTmp == "dn_" || sTmp == "up_" ||  sTmp == "dl_" || sTmp == "ul_" ||  sTmp == "dw_" || sTmp == "uw_")
		{
			return GetSubString(sResRef, 7, -1);
		}
	}
  return sResRef;
}




	
object oBaseItemTable;

/**  
* Makes sure the oSpellTable is a valid pointer to the spells dataobject
* @author
* @see 
* @return 
*/
void CSLGetBaseItemDataObject()
{
	if ( !GetIsObjectValid( oBaseItemTable ) )
	{
		oBaseItemTable = CSLDataObjectGet( "baseitems" );
	}
	//return oSpellTable;
}

string CSLGetBaseItemDataName(int iBaseItem)
{
	CSLGetBaseItemDataObject();
	return CSLDataTableGetStringByRow( oBaseItemTable, "Name", iBaseItem );
	
	//string sSpellNameStrRef = Get2DAString("spells", "NAME", iSpellId);
	//if (sSpellNameStrRef == "") return "";
	//
	//return GetStringByStrRef(StringToInt(sSpellNameStrRef));
}




/**  
* Description
* @author Cerea and Kivinen
* @param 
* @see 
* @replaces XXX
* @return 
*/
string CSLGetBaseItemResRef(int nBaseItem, string sDefault = "")
{
	if (nBaseItem == BASE_ITEM_INVALID ) { return sDefault; } // 256;
	int iSubBaseItem = nBaseItem / 10;
	//SendMessageToPC(GetFirstPC(), "CSLGetBaseItemResRef nBaseItem="+IntToString(nBaseItem)+"  iSubBaseItem="+IntToString(iSubBaseItem) );
	switch(iSubBaseItem)
	{
		case 0:
			switch(nBaseItem)
			{
				case BASE_ITEM_SHORTSWORD:	{ return "nw_wswss001"; } // 0;
				case BASE_ITEM_LONGSWORD:	{ return "nw_wswls001"; } // 1;
				case BASE_ITEM_BATTLEAXE:	{ return "nw_waxbt001"; } // 2;
				case BASE_ITEM_BASTARDSWORD:	{ return "nw_wswbs001"; } // 3;
				case BASE_ITEM_LIGHTFLAIL:	{ return "nw_wblfl001"; } // 4;
				case BASE_ITEM_WARHAMMER:	{ return "nw_wblhw001"; } // 5;
				case BASE_ITEM_HEAVYCROSSBOW:	{ return "nw_wbwxh001"; } // 6;
				case BASE_ITEM_LIGHTCROSSBOW:	{ return "nw_wbwxl001"; } // 7;
				case BASE_ITEM_LONGBOW:	{ return "nw_wbwln001"; } // 8;
				case BASE_ITEM_LIGHTMACE:	{ return "nw_wblml001"; } // 9;
			}
			break;
		case 1:
			switch(nBaseItem)
			{
				case BASE_ITEM_HALBERD:	{ return "nw_wplhb001"; } // 10;
				case BASE_ITEM_SHORTBOW:	{ return "nw_wbwsh001"; } // 11;
				case BASE_ITEM_TWOBLADEDSWORD:	{ return "nw_wdbsw001"; } // 12;
				case BASE_ITEM_GREATSWORD:	{ return "nw_wswgs001"; } // 13;
				case BASE_ITEM_SMALLSHIELD:	{ return "nw_ashsw001"; } // 14;
				case BASE_ITEM_TORCH:	{ return "nw_it_torch001"; } // 15;
				case BASE_ITEM_ARMOR:	{ return sDefault; } // 16;
				case BASE_ITEM_HELMET:	{ return sDefault; } // 17;
				case BASE_ITEM_GREATAXE:	{ return "nw_waxgr001"; } // 18;
				case BASE_ITEM_AMULET:	{ return sDefault; } // 19;
			}
			break;
		case 2:
			switch(nBaseItem)
			{
				case BASE_ITEM_ARROW:	{ return "nw_wamar001"; } // 20;
				case BASE_ITEM_BELT:	 { return sDefault; } // 21;
				case BASE_ITEM_DAGGER:	{ return "nw_wswdg001"; } // 22;
				case BASE_ITEM_MISCSMALL:	{ return sDefault; } // 24;
				case BASE_ITEM_BOLT:	{ return "nw_wambo001"; } // 25;
				case BASE_ITEM_BOOTS:	{ return sDefault; } // 26;
				case BASE_ITEM_BULLET:	{ return "nw_wambu001"; } // 27;
				case BASE_ITEM_CLUB:	{ return "nw_wblcl001"; } // 28;
				case BASE_ITEM_MISCMEDIUM:	{ return sDefault; } // 29;
			}
			break;
		case 3:
			switch(nBaseItem)
			{
				case BASE_ITEM_DART:	{ return "nw_wthdt001"; } // 31;
				case BASE_ITEM_DIREMACE:	{ return "nw_wdbma001"; } // 32;
				case BASE_ITEM_DOUBLEAXE:	{ return "nw_wdbax001"; } // 33;
				case BASE_ITEM_MISCLARGE:	{ return sDefault; } // 34;
				case BASE_ITEM_HEAVYFLAIL:	{ return "nw_wblfh001"; } // 35;
				case BASE_ITEM_GLOVES:	{ return "flel_it_mgloves"; } // 36;
				case BASE_ITEM_LIGHTHAMMER:	{ return "nw_wblhl001"; } // 37;
				case BASE_ITEM_HANDAXE:	{ return "nw_waxhn001"; } // 38;
				case BASE_ITEM_HEALERSKIT:	{ return sDefault; } // 39;
			}
			break;
		case 4:
			switch(nBaseItem)
			{
				case BASE_ITEM_KAMA:	{ return "nw_wspka001"; } // 40;
				case BASE_ITEM_KATANA:	{ return "nw_wswka001"; } // 41;
				case BASE_ITEM_KUKRI:	{ return "nw_wspku001"; } // 42;
				case BASE_ITEM_MISCTALL:	{ return sDefault; } // 43;
				case BASE_ITEM_MAGICROD:	{ return sDefault; } // 44;
				case BASE_ITEM_MAGICSTAFF:	{ return sDefault; } // 45;
				case BASE_ITEM_MAGICWAND:	{ return sDefault; } // 46;
				case BASE_ITEM_MORNINGSTAR:	{ return "nw_wblms001"; } // 47;
				case BASE_ITEM_POTIONS:	{ return sDefault; } // 49;
			}
			break;
		case 5:
			switch(nBaseItem)
			{
				case BASE_ITEM_QUARTERSTAFF:	{ return "nw_wdbqs001"; } // 50;
				case BASE_ITEM_RAPIER:	{ return "nw_wswrp001"; } // 51;
				case BASE_ITEM_RING:	{ return sDefault; } // 52;
				case BASE_ITEM_SCIMITAR:	{ return "nw_wswsc001"; } // 53;
				case BASE_ITEM_SCROLL:	{ return sDefault; } // 54;
				case BASE_ITEM_SCYTHE:	{ return "nw_wplsc001"; } // 55;
				case BASE_ITEM_LARGESHIELD:	{ return "nw_ashlw001"; } // 56;
				case BASE_ITEM_TOWERSHIELD:	{ return "nw_ashto001"; } // 57;
				case BASE_ITEM_SHORTSPEAR:	{ return "nw_wplss001"; } // 58;
				case BASE_ITEM_SHURIKEN:	{ return "nw_wthsh001"; } // 59;
			}
			break;
		case 6:
			switch(nBaseItem)
			{
				case BASE_ITEM_SICKLE:	{ return "nw_wspsc001"; } // 60;
				case BASE_ITEM_SLING:	{ return "nw_wbwsl001"; } // 61;
				case BASE_ITEM_THIEVESTOOLS:	{ return sDefault; } // 62;
				case BASE_ITEM_THROWINGAXE:	{ return "nw_wthax001"; } // 63;
				case BASE_ITEM_TRAPKIT:	{ return sDefault; } // 64;
				case BASE_ITEM_KEY:	{ return sDefault; } // 65;
				case BASE_ITEM_LARGEBOX:	{ return sDefault; } // 66;
				//case BASE_ITEM_MISCWIDE			{ return sDefault; } // 68;
				case BASE_ITEM_CSLASHWEAPON:	{ return sDefault; } // 69;
			}
			break;
		case 7:
			switch(nBaseItem)
			{
				case BASE_ITEM_CPIERCWEAPON:	{ return sDefault; } // 70;
				case BASE_ITEM_CBLUDGWEAPON:	{ return sDefault; } // 71;
				case BASE_ITEM_CSLSHPRCWEAP:	{ return sDefault; } // 72;
				case BASE_ITEM_CREATUREITEM:	{ return sDefault; } // 73;
				case BASE_ITEM_BOOK:	{ return sDefault; } // 74;
				case BASE_ITEM_SPELLSCROLL:	{ return sDefault; } // 75;
				case BASE_ITEM_GOLD:	{ return sDefault; } // 76;
				case BASE_ITEM_GEM:	{ return sDefault; } // 77;
				case BASE_ITEM_BRACER:	{ return sDefault; } // 78;
				case BASE_ITEM_MISCTHIN:	{ return sDefault; } // 79;
			}
			break;
		case 8:
			switch(nBaseItem)
			{
				case BASE_ITEM_CLOAK:	{ return sDefault; } // 80;
				case BASE_ITEM_GRENADE:	{ return sDefault; } // 81;
				case BASE_ITEM_BALORSWORD:	{ return sDefault; } // 82;
				case BASE_ITEM_BALORFALCHION:	{ return sDefault; } // 83;
			}
			break;
		case 10:
			switch(nBaseItem)
			{
				case BASE_ITEM_BLANK_POTION:	{ return sDefault; } // 101;
				case BASE_ITEM_BLANK_SCROLL:	{ return sDefault; } // 102;
				case BASE_ITEM_BLANK_WAND:	{ return sDefault; } // 103;
				case BASE_ITEM_ENCHANTED_POTION:	{ return sDefault; } // 104;
				case BASE_ITEM_ENCHANTED_SCROLL:	{ return sDefault; } // 105;
				case BASE_ITEM_ENCHANTED_WAND:	{ return sDefault; } // 106;
				case BASE_ITEM_DWARVENWARAXE:	{ return "x2_wdwraxe001"; } // 108;
				case BASE_ITEM_CRAFTMATERIALMED:	{ return sDefault; } // 109;
			}
			break;
		case 11:
			switch(nBaseItem)
			{
				case BASE_ITEM_CRAFTMATERIALSML:	{ return sDefault; } // 110;
				case BASE_ITEM_WHIP:	{ return "x2_it_wpwhip"; } // 111;
				case BASE_ITEM_CRAFTBASE:	{ return sDefault; } // 112;
				//case BASE_ITEM_MACE:	{ return sDefault; } // 113;
				case BASE_ITEM_FALCHION:	{ return "n2_wswfl001"; } // 114;
				case BASE_ITEM_FLAIL:	{ return sDefault; } // 116;
				case BASE_ITEM_SPEAR:	{ return sDefault; } // 119;
			}
			break;
		case 12:
			switch(nBaseItem)
			{
				case BASE_ITEM_GREATCLUB:	{ return sDefault; } // 120;
				case BASE_ITEM_TRAINING_CLUB:	{ return sDefault; } // 124;
				case BASE_ITEM_SOFTBUNDLE:	{ return sDefault; } // 125;
				case BASE_ITEM_WARMACE:	{ return sDefault; } // 126;
				case BASE_ITEM_STEIN:	{ return "n2_it_stein"; } // 127;
				case BASE_ITEM_DRUM:	{ return "n2_it_drum"; } // 128;
				case BASE_ITEM_FLUTE:	{ return "n2_it_flute"; } // 129;
			}
			break;
		case 13:
			switch(nBaseItem)
			{
				case BASE_ITEM_INK_WELL:	{ return sDefault; } // 130;
				case BASE_ITEM_LOOTBAG:	{ return sDefault; } // 131;
				case BASE_ITEM_MANDOLIN:	{ return "n2_it_lute"; } // 132;
				case BASE_ITEM_PAN:	{ return sDefault; } // 133;
				case BASE_ITEM_POT:	{ return sDefault; } // 134;
				case BASE_ITEM_RAKE:	{ return sDefault; } // 135;
				case BASE_ITEM_SHOVEL:	{ return sDefault; } // 136;
				case BASE_ITEM_SMITHYHAMMER:	{ return sDefault; } // 137;
				case BASE_ITEM_SPOON:	{ return "n2_it_spoon"; } // 138;
				case BASE_ITEM_BOTTLE:	{ return "nw_it_mpotion023"; } // 139;
			}
			break;
		case 14:
			switch(nBaseItem)
			{
				case BASE_ITEM_CGIANT_SWORD:	{ return sDefault; } // 140;
				case BASE_ITEM_CGIANT_AXE:	{ return sDefault; } // 141;
				case BASE_ITEM_ALLUSE_SWORD:	{ return sDefault; } // 142;
				case BASE_ITEM_MISCSTACK:	{ return sDefault; } // 143;
				case BASE_ITEM_BOUNTYITEM:	{ return sDefault; } // 144;
				case BASE_ITEM_RECIPE:	{ return sDefault; } // 145;
				case BASE_ITEM_INCANTATION:	{ return sDefault; } // 146;
			}
		break;
	}
   return sDefault;
}


int CSLGetBestBaseItem( object oPC, int iFirstBaseItem = BASE_ITEM_INVALID, int iSecondBaseItem = BASE_ITEM_INVALID, int iThirdBaseItem = BASE_ITEM_INVALID, int iFourthBaseItem = BASE_ITEM_INVALID, int iFifthBaseItem = BASE_ITEM_INVALID, int iSixthhBaseItem = BASE_ITEM_INVALID, int iSeventhBaseItem = BASE_ITEM_INVALID, int iEighthBaseItem = BASE_ITEM_INVALID )
{
	int iBaseItem;
	
	string sFeat;
	int x;
	CSLGetBaseItemDataObject();
	
	
	for (x = 1;x<=8;x++)
	{
		if ( x == 1 ) { iBaseItem = iFirstBaseItem;}
		else if ( x == 2 ) { iBaseItem = iSecondBaseItem;}
		else if ( x == 3 ) { iBaseItem = iThirdBaseItem;}
		else if ( x == 4 ) { iBaseItem = iFourthBaseItem;}
		else if ( x == 5 ) { iBaseItem = iFifthBaseItem;}
		else if ( x == 6 ) { iBaseItem = iSixthhBaseItem;}
		else if ( x == 7 ) { iBaseItem = iSeventhBaseItem;}
		else if ( x == 8 ) { iBaseItem = iEighthBaseItem;}
		
		if (DEBUGGING >= 3) { CSLDebug(  "Working on "+CSLGetBaseItemDataName( iBaseItem ), oPC  ); }
	
		
		if ( iBaseItem != BASE_ITEM_INVALID )
		{
			
			if (DEBUGGING >= 3) { CSLDebug(  "Testing "+CSLGetBaseItemDataName( iBaseItem )+" with creature size of "+IntToString( GetCreatureSize(oPC) )+" item is small="+IntToString( CSLGetBaseItemProps(iBaseItem) & ITEM_ATTRIB_SMALL )+" item is medium="+IntToString(CSLGetBaseItemProps(iBaseItem) & ITEM_ATTRIB_MEDIUM), oPC  ); }
			
			// check if even usable due to stature - small creature cannot use certain weapons
			if ( GetCreatureSize(oPC) >= CREATURE_SIZE_MEDIUM || ( CSLGetBaseItemProps(iBaseItem) & ITEM_ATTRIB_SMALL || CSLGetBaseItemProps(iBaseItem) & ITEM_ATTRIB_MEDIUM ) )
			{
				// check for feats
				// need to swap this out with the cached data
				sFeat = CSLDataTableGetStringByRow( oBaseItemTable, "ReqFeat0",iBaseItem);
				if (DEBUGGING >= 3) { CSLDebug(  "Looking for feat "+sFeat, oPC  ); }
				if ( sFeat != "" && GetHasFeat( StringToInt(sFeat), oPC, TRUE ) )
				{
					if (DEBUGGING >= 3) { CSLDebug(  "Found on ReqFeat0 "+CSLGetBaseItemDataName( iBaseItem ), oPC  ); }
					return iBaseItem;
				}
				
				sFeat = CSLDataTableGetStringByRow( oBaseItemTable, "ReqFeat1",iBaseItem);
				if (DEBUGGING >= 3) { CSLDebug(  "Looking for feat "+sFeat, oPC  ); }
				if ( sFeat != "" && GetHasFeat( StringToInt(sFeat), oPC, TRUE ) ) 
				{
					if (DEBUGGING >= 3) { CSLDebug(  "Found on ReqFeat1 "+CSLGetBaseItemDataName( iBaseItem ), oPC  ); }
					return iBaseItem;
				}
				
				sFeat = CSLDataTableGetStringByRow( oBaseItemTable, "ReqFeat2",iBaseItem);
				if (DEBUGGING >= 3) { CSLDebug(  "Looking for feat "+sFeat, oPC  ); }
				if ( sFeat != "" && GetHasFeat( StringToInt(sFeat), oPC, TRUE ) ) 
				{
					if (DEBUGGING >= 3) { CSLDebug(  "Found on ReqFeat2 "+CSLGetBaseItemDataName( iBaseItem ), oPC  ); }
					return iBaseItem;
				}
				
				sFeat = CSLDataTableGetStringByRow( oBaseItemTable,"ReqFeat3",iBaseItem);
				if (DEBUGGING >= 3) { CSLDebug(  "Looking for feat "+sFeat, oPC  ); }
				if ( sFeat != "" && GetHasFeat( StringToInt(sFeat), oPC, TRUE ) ) 
				{
					if (DEBUGGING >= 3) { CSLDebug(  "Found on ReqFeat3 "+CSLGetBaseItemDataName( iBaseItem ), oPC  ); }
					return iBaseItem;
				}
				
				sFeat = CSLDataTableGetStringByRow( oBaseItemTable, "ReqFeat4",iBaseItem);
				if (DEBUGGING >= 3) { CSLDebug(  "Looking for feat "+sFeat, oPC  ); }
				if ( sFeat != "" && GetHasFeat( StringToInt(sFeat), oPC, TRUE ) ) 
				{
					if (DEBUGGING >= 3) { CSLDebug(  "Found on ReqFeat4 "+CSLGetBaseItemDataName( iBaseItem ), oPC  ); }
					return iBaseItem;
				}
				
				sFeat = CSLDataTableGetStringByRow( oBaseItemTable, "ReqFeat5",iBaseItem);
				if (DEBUGGING >= 3) { CSLDebug(  "Looking for feat "+sFeat, oPC  ); }
				if ( sFeat != "" && GetHasFeat( StringToInt(sFeat), oPC, TRUE ) ) 
				{
					if (DEBUGGING >= 3) { CSLDebug(  "Found on ReqFeat5 "+CSLGetBaseItemDataName( iBaseItem ), oPC  ); }
					return iBaseItem;
				}
				if (DEBUGGING >= 3) { CSLDebug(  CSLGetBaseItemDataName( iBaseItem )+"Is not valid for use", oPC  ); }
				
			}
		}
	}
	return BASE_ITEM_CLUB; // default to club since this is always usable by ANYONE, everything supplied does not work
}




/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetBestBaseItemByDeity( object oPC = OBJECT_SELF, int nBaseItemType = BASE_ITEM_INVALID )
{
	string sDeityName = GetDeity(oPC);
	
	string sDeityInitital = GetStringUpperCase( GetStringLeft(sDeityName,1) );
	
	if ( sDeityInitital == "S" )
	{
		if ( sDeityName == "Savras" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Segojan Earthcaller" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Sehanine Moonbow" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, nBaseItemType); }
		if ( sDeityName == "Selune" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Seveltarm" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Shar" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Sharess" ) { return nBaseItemType; }
		if ( sDeityName == "Shargaas" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Sharindlar" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_FLAIL, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Shaundakul" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_GREATSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Sheela Peryroyl" ) { return BASE_ITEM_SICKLE; }
		if ( sDeityName == "Shevarash" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGBOW, BASE_ITEM_SHORTBOW, nBaseItemType); }
		if ( sDeityName == "Shiallia" ) { return nBaseItemType; }
		if ( sDeityName == "Siamorphe" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Silvanus" ) { return nBaseItemType; }
		if ( sDeityName == "Solonor Thelandira" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGBOW, BASE_ITEM_SHORTBOW, nBaseItemType); }
		if ( sDeityName == "Sseth" ) { return nBaseItemType; }
		if ( sDeityName == "Sune" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_FLAIL, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
	}
	else if ( sDeityInitital == "G" )
	{
		if ( sDeityName == "Gaerdal Ironhand" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARHAMMER, BASE_ITEM_LIGHTHAMMER, nBaseItemType); }
		if ( sDeityName == "Garagos" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Gargauth" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Garl Glittergold" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BATTLEAXE, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Ghaunadaur" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARHAMMER, BASE_ITEM_LIGHTHAMMER, nBaseItemType); }
		if ( sDeityName == "Gond" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARHAMMER, BASE_ITEM_LIGHTHAMMER, nBaseItemType); }
		if ( sDeityName == "Gorm Gulthyn" ) { return nBaseItemType; }
		if ( sDeityName == "Grumbar" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARHAMMER, BASE_ITEM_LIGHTHAMMER, nBaseItemType); }
		if ( sDeityName == "Gruumsh" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SPEAR, nBaseItemType); }
		if ( sDeityName == "Gwaeron Windstrom" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_GREATSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
	}
	else if ( sDeityInitital == "A" )
	{
		if ( sDeityName == "Abbathor" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Aerdrie Faenya" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, nBaseItemType); }
		if ( sDeityName == "Akadi" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_FLAIL, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Angharradh" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SPEAR, nBaseItemType); }
		if ( sDeityName == "Ao" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Arvoreen" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Auril" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BATTLEAXE, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Azuth" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, nBaseItemType); }
	}
	else if ( sDeityInitital == "L" )
	{
		if ( sDeityName == "Labelas Enoreth" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, nBaseItemType); }
		if ( sDeityName == "Laduguer" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARHAMMER, BASE_ITEM_LIGHTHAMMER, nBaseItemType); }
		if ( sDeityName == "Lathander" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Leira" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_KUKRI, nBaseItemType); }
		if ( sDeityName == "Lliira" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHURIKEN, nBaseItemType); }
		if ( sDeityName == "Lolth" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Loviatar" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_FLAIL, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Lurue" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SPEAR, nBaseItemType); }
		if ( sDeityName == "Luthic" ) { return nBaseItemType; }
	}
	else if ( sDeityInitital == "M" )
	{
		if ( sDeityName == "Malar" ) { return nBaseItemType; }
		if ( sDeityName == "Marthammor Duin" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Mask" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Mielikki" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SCIMITAR, nBaseItemType); }
		if ( sDeityName == "Milil" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_RAPIER, nBaseItemType); }
		if ( sDeityName == "Moradin" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARHAMMER, BASE_ITEM_LIGHTHAMMER, nBaseItemType); }
		if ( sDeityName == "Mystra" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHURIKEN,BASE_ITEM_DAGGER, nBaseItemType); }
	}
	else if ( sDeityInitital == "B" )
	{
		if ( sDeityName == "Baervan Wildwanderer" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SPEAR, nBaseItemType); }
		if ( sDeityName == "Bahgtru" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_KUKRI, nBaseItemType); }
		if ( sDeityName == "Bane" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Baravar Cloakshadow" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SPEAR, nBaseItemType); }
		if ( sDeityName == "Berronar Truesilver" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Beshaba" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_FLAIL, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE,  nBaseItemType); }
		if ( sDeityName == "Brandobaris" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
	}
	else if ( sDeityInitital == "T" )
	{
		if ( sDeityName == "Talona" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Talos" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SPEAR, nBaseItemType); }
		if ( sDeityName == "Tempus" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_GREATAXE,BASE_ITEM_BATTLEAXE, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Thard Harr" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_KUKRI, nBaseItemType); }
		if ( sDeityName == "Torm" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_GREATSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Tymora" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHURIKEN, nBaseItemType); }
		if ( sDeityName == "Tyr" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
	}
	else if ( sDeityInitital == "C" )
	{
		if ( sDeityName == "Callarduran Smoothhands" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BATTLEAXE, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Chauntea" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SCYTHE, nBaseItemType); }
		if ( sDeityName == "Clangeddin Silverbeard" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BATTLEAXE, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Corellon Larethian" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Cyric" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Cyrrollalee" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_CLUB, nBaseItemType); }
	}
	else if ( sDeityInitital == "U" )
	{
		if ( sDeityName == "Ubtao" ) { return nBaseItemType; }
		if ( sDeityName == "Umberlee" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_HALBERD, nBaseItemType); }
		if ( sDeityName == "Urdlen" ) { return nBaseItemType; }
		if ( sDeityName == "Urogalan" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_FLAIL, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE,  nBaseItemType); }
	}
	else if ( sDeityInitital == "V" )
	{
		if ( sDeityName == "Valkur" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_RAPIER, nBaseItemType); }
		if ( sDeityName == "Velsharoon" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, nBaseItemType); }
		if ( sDeityName == "Vergadain" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Vhaeraun" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
	}
	else if ( sDeityInitital == "D" )
	{
		if ( sDeityName == "Deep Duerra" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BATTLEAXE,BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Deneir" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Dugmaren Brightmantle" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Dumathoin" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARMACE, BASE_ITEM_MACE, nBaseItemType); }
	}
	else if ( sDeityInitital == "H" )
	{
		if ( sDeityName == "Haela Brightaxe" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_GREATSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Hanali Celanil" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Helm" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BASTARDSWORD, BASE_ITEM_GREATSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Hoar" ) { return nBaseItemType; }
	}
	else if ( sDeityInitital == "I" )
	{
		if ( sDeityName == "Ilmater" ) { return nBaseItemType; }
		if ( sDeityName == "Ilneval" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR,  nBaseItemType); }
		if ( sDeityName == "Istishia" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARHAMMER, BASE_ITEM_LIGHTHAMMER, nBaseItemType); }
	}
	else if ( sDeityInitital == "K" )
	{
		if ( sDeityName == "Kelemvor" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BASTARDSWORD, BASE_ITEM_GREATSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Kiransalee" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Kossuth" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_FLAIL, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
	}
	else if ( sDeityInitital == "E" )
	{
		if ( sDeityName == "Eilistraee" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BASTARDSWORD, BASE_ITEM_GREATSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Eldath" ) { return nBaseItemType; }
		if ( sDeityName == "Erevan Ilesere" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
	}
	else if ( sDeityInitital == "F" )
	{
		if ( sDeityName == "Fenmarel Mestarine" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_DAGGER, nBaseItemType); }
		if ( sDeityName == "Finder Wyvernspur" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_BASTARDSWORD, BASE_ITEM_GREATSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Flandal Steelskin" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_WARHAMMER, BASE_ITEM_LIGHTHAMMER, nBaseItemType); }
	}
	else 
	{
		if ( sDeityName == "Red Knight" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Rillfane Rallathil" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, nBaseItemType); }
		if ( sDeityName == "Jergal" ) { return nBaseItemType; }
		if ( sDeityName == "No Deity" ) { return nBaseItemType; }
		if ( sDeityName == "None" ) { return nBaseItemType; }
		if ( sDeityName == "Oghma" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, nBaseItemType); }
		if ( sDeityName == "Waukeen" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_CLUB, nBaseItemType); }
		if ( sDeityName == "Yondalla" ) { return CSLGetBestBaseItem( oPC, BASE_ITEM_SHORTSWORD, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); }
		if ( sDeityName == "Yurtrus" ) { return nBaseItemType; }
	}
	return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_MORNINGSTAR, BASE_ITEM_MACE, nBaseItemType); // defaults for divine classes, if martial it's a paladin therefore a longsword, otherwise a mace which is the D&D cleric
}

string CSLGetBestArmorResref( object oPC )
{
	if ( GetLevelByClass(CLASS_TYPE_WIZARD, oPC) || GetLevelByClass(CLASS_TYPE_SORCERER, oPC) )
	{
		return "nw_cloth005"; // "nw_cloth008"
	}
	else if ( GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) )
	{
		if ( GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, oPC) && GetHasFeat(FEAT_BATTLE_CASTER, oPC) )
		{
			return "nw_aarcl004";
		}
		return "nw_armor_warlock";
	}
	else if ( GetLevelByClass(CLASS_TYPE_BARD, oPC) )
	{
		if ( GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, oPC) && GetHasFeat(FEAT_BATTLE_CASTER, oPC) )
		{
			return "nw_aarcl004";
		}
		return "nw_cloth017";
	}
	else if ( GetLevelByClass(CLASS_TYPE_DRUID, oPC) || GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC) )
	{
		return "nw_aarcl008"; // hide armor
	}
	else if ( GetLevelByClass(CLASS_TYPE_ROGUE, oPC) || GetLevelByClass(CLASS_NINJA, oPC) )
	{
		return "nw_cloth017"; // leather armor
	}
	else if ( GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC) || GetLevelByClass(CLASS_THUG, oPC) )
	{
		//return "nw_cloth015"; // hide
		return "nw_armor_barb"; //
	}
	else if ( GetLevelByClass(CLASS_TYPE_RANGER, oPC) || GetLevelByClass(CLASS_SCOUT, oPC) )
	{
		return "nw_aarcl002";
	}
	else if ( GetLevelByClass(CLASS_TYPE_MONK, oPC) )
	{
		return "nw_cloth016"; // monks outfit
	}
	else // CLASS_TYPE_PALADIN or CLASS_TYPE_FIGHTER
	{
		if( GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY, oPC) ) { return "nw_aarcl006";} // half plate
		if( GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, oPC) ) { return "nw_aarcl004";} // chainmail// nw_aarcl012";}
		if( GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, oPC) ) { return "nw_aarcl012";} // chain shirt
	}
	return "nw_cloth001";
}

string CSLGetBestShieldResref( object oPC )
{
	if( GetHasFeat(FEAT_SHIELD_PROFICIENCY, oPC) )
	{
		if ( GetCreatureSize(oPC) <= CREATURE_SIZE_SMALL )
		{
			return "nw_ashsw001"; // light shield
		}
	
		if( GetHasFeat(FEAT_TOWER_SHIELD_PROFICIENCY, oPC) )
		{
			return "nw_ashto001"; // tower shield
		}
		
		return "nw_ashlw001"; // tower shield
	
	
	}
	
	// just to be fair give them some magic to make up for not having the correct shield
	if ( GetLevelByClass(CLASS_TYPE_WIZARD, oPC) || GetLevelByClass(CLASS_TYPE_SORCERER, oPC) )
	{
		return "x1_it_sparscr103";
	}
	else
	{
		return "nw_it_mpotion005";
	}
}


int CSLGetBestBaseItemByClass( object oPC = OBJECT_SELF, int iClass = CLASS_TYPE_NONE, int nBaseItemType = BASE_ITEM_INVALID )
{
	if (iClass==CLASS_TYPE_NONE       ) return nBaseItemType; // "AB";
	if (iClass==CLASS_TYPE_INVALID    ) return nBaseItemType; // "IV";
	
	
	
	
	// Base classes
	if (iClass==CLASS_TYPE_MONK             ) return CSLGetBestBaseItem( oPC, FEAT_WEAPON_FOCUS_KAMA, nBaseItemType ); ; // "MK";
	if (iClass==CLASS_TYPE_BARBARIAN        ) return CSLGetBestBaseItem( oPC, FEAT_WEAPON_FOCUS_GREAT_AXE, BASE_ITEM_BATTLEAXE, nBaseItemType); // "BB";
	if (iClass==CLASS_TYPE_BARD             ) return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, nBaseItemType); // "BD";
	if (iClass==CLASS_TYPE_PALADIN          ) return CSLGetBestBaseItemByDeity( oPC, nBaseItemType ); // "PA";
	if (iClass==CLASS_TYPE_CLERIC           ) return CSLGetBestBaseItemByDeity( oPC, nBaseItemType ); // "CL";
	if (iClass==CLASS_TYPE_RANGER           ) return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, nBaseItemType); // "RA";
	if (iClass==CLASS_TYPE_ROGUE            ) return CSLGetBestBaseItem( oPC, BASE_ITEM_RAPIER, BASE_ITEM_DAGGER, nBaseItemType); // "RO";
	if (iClass==CLASS_TYPE_SORCERER         ) return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, BASE_ITEM_DAGGER, nBaseItemType); // "SO";
	if (iClass==CLASS_TYPE_DRUID            ) return CSLGetBestBaseItemByDeity( oPC, nBaseItemType ); // "DR";
	if (iClass==CLASS_TYPE_SPIRIT_SHAMAN    ) return CSLGetBestBaseItemByDeity(  oPC, nBaseItemType ); // "SS";
	if (iClass==CLASS_TYPE_FAVORED_SOUL     ) return CSLGetBestBaseItemByDeity( oPC, nBaseItemType ); // "FS";
	if (iClass==CLASS_TYPE_FIGHTER          ) return CSLGetBestBaseItem( oPC, BASE_ITEM_BASTARDSWORD, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, nBaseItemType ); // "FI";
	if (iClass==CLASS_TYPE_WARLOCK          ) return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, BASE_ITEM_DAGGER,nBaseItemType ); // "WA";
	if (iClass==CLASS_TYPE_WIZARD           ) return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, BASE_ITEM_DAGGER); // "WI";
	if (iClass==CLASS_THUG             		) return CSLGetBestBaseItem( oPC, BASE_ITEM_GREATCLUB, BASE_ITEM_BATTLEAXE, nBaseItemType); // "TG";
	if (iClass==CLASS_NINJA					) return CSLGetBestBaseItem( oPC, BASE_ITEM_BATTLEAXE, BASE_ITEM_SHORTSWORD, nBaseItemType); // "NJ";
	if (iClass==CLASS_SCOUT					) return CSLGetBestBaseItem( oPC, BASE_ITEM_HANDAXE, BASE_ITEM_RAPIER, BASE_ITEM_SHORTSWORD, nBaseItemType); // "SC";
	
	// PRC Classes
	if (iClass==CLASS_TYPE_ASSASSIN         ) return CSLGetBestBaseItem( oPC, BASE_ITEM_SHORTSWORD, BASE_ITEM_DAGGER, nBaseItemType); // "AS";
	if (iClass==CLASS_TYPE_ARCANE_SCHOLAR   ) return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, BASE_ITEM_DAGGER, nBaseItemType); // "AR";
	if (iClass==CLASS_TYPE_BLACKGUARD       ) return CSLGetBestBaseItemByDeity( oPC, nBaseItemType ); // "BG";
	if (iClass==CLASS_TYPE_PALEMASTER       ) return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, BASE_ITEM_DAGGER, nBaseItemType); // "PM";
	if (iClass==CLASS_TYPE_RED_WIZARD       ) return CSLGetBestBaseItem( oPC, BASE_ITEM_QUARTERSTAFF, BASE_ITEM_DAGGER, nBaseItemType); // "RW";
	if (iClass==CLASS_TYPE_DWARVENDEFENDER  ) return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, nBaseItemType); // "DD";
	if (iClass==CLASS_TYPE_ELDRITCH_KNIGHT  ) return CSLGetBestBaseItem( oPC, BASE_ITEM_LONGSWORD, BASE_ITEM_SHORTSWORD, nBaseItemType); // "EK";
	if (iClass==CLASS_TYPE_STORMLORD        ) return CSLGetBestBaseItemByDeity( oPC, nBaseItemType ); // "SL";
	if (iClass==CLASS_TYPE_FRENZIEDBERSERKER) return CSLGetBestBaseItem( oPC, BASE_ITEM_BATTLEAXE, nBaseItemType); // "FB";
	if (iClass==CLASS_TYPE_WARPRIEST        ) return CSLGetBestBaseItemByDeity(  oPC, nBaseItemType ); // "WP";
	if (iClass==CLASS_TYPE_SACREDFIST       ) return BASE_ITEM_GLOVES; // "SF";
	
	/*
	if (iClass==CLASS_TYPE_ARCANE_ARCHER    ) return nBaseItemType; // "AA";
	if (iClass==CLASS_TYPE_INVISIBLE_BLADE  ) return nBaseItemType; // "IB";
	if (iClass==CLASS_TYPE_ARCANETRICKSTER  ) return nBaseItemType; // "AT";
	if (iClass==CLASS_TYPE_DIVINECHAMPION   ) return nBaseItemType; // "DC";
	if (iClass==CLASS_TYPE_SHADOWTHIEFOFAMN ) return nBaseItemType; // "ST";
	if (iClass==CLASS_TYPE_SHIFTER          ) return nBaseItemType; // "SH";
	if (iClass==CLASS_TYPE_SHADOWDANCER     ) return nBaseItemType; // "SD";
	if (iClass==CLASS_TYPE_DRAGONDISCIPLE   ) return nBaseItemType; // "RD";
	if (iClass==CLASS_TYPE_DUELIST          ) return nBaseItemType; // "DU";
	
	if (iClass==CLASS_TYPE_WEAPON_MASTER    ) return nBaseItemType; // "WM";
	if (iClass==CLASS_TYPE_HARPER           ) return nBaseItemType; // "HS";
	if (iClass==CLASS_HOSPITALER            ) return nBaseItemType; // "HP";
	if (iClass==CLASS_WARRIOR_DARKNESS      ) return nBaseItemType; // "WD";
	if (iClass==CLASS_BLADESINGER           ) return nBaseItemType; // "BS";
	if (iClass==CLASS_STORMSINGER           ) return nBaseItemType; // "SS";
	if (iClass==CLASS_TEMPEST               ) return nBaseItemType; // "TM";
	if (iClass==CLASS_BLACK_FLAME_ZEALOT    ) return nBaseItemType; // "BZ";
	if (iClass==CLASS_SHINING_BLADE         ) return nBaseItemType; // "SH";
	if (iClass==CLASS_SWIFTBLADE            ) return nBaseItemType; // "SB";
	if (iClass==CLASS_FOREST_MASTER         ) return nBaseItemType; // "FM";
	if (iClass==CLASS_NIGHTSONG_ENFORCER    ) return nBaseItemType; // "NE";
	if (iClass==CLASS_ELEM_ARCHER           ) return nBaseItemType; // "EA";
	if (iClass==CLASS_DIVINE_SEEKER         ) return nBaseItemType; // "DS";
	if (iClass==CLASS_ANOINTED_KNIGHT       ) return nBaseItemType; // "AK";
	if (iClass==CLASS_NATURES_WARRIOR       ) return nBaseItemType; // "NW";
	if (iClass==CLASS_FROST_MAGE            ) return nBaseItemType; // "FM";
	if (iClass==CLASS_LION_TALISID          ) return nBaseItemType; // "LT";
	if (iClass==CLASS_CHAMPION_WILD         ) return nBaseItemType; // "CW";
	if (iClass==CLASS_SKULLCLAN_HUNTER      ) return nBaseItemType; // "SH";
	if (iClass==CLASS_DARK_LANTERN          ) return nBaseItemType; // "DL";
	if (iClass==CLASS_NIGHTSONG_INFILTRATOR ) return nBaseItemType; // "NI";
	if (iClass==CLASS_MASTER_RADIANCE       ) return nBaseItemType; // "MR";
	if (iClass==CLASS_HEARTWARDER           ) return nBaseItemType; // "HW";
	if (iClass==CLASS_TYPE_AVENGER			) return nBaseItemType; // "AV";
	if (iClass==CLASS_DREAD_COMMANDO        ) return nBaseItemType; // "DC";
	if (iClass==CLASS_ELEMENTAL_WARRIOR     ) return nBaseItemType; // "EW";
	if (iClass==CLASS_WHIRLING_DERVISH      ) return nBaseItemType; // "WD";
	if (iClass==CLASS_DEATHBLADE			) return nBaseItemType; // "DB";
	if (iClass==CLASS_OPTIMIST				) return nBaseItemType; // "OP";
	if (iClass==CLASS_ELDRITCH_DISCIPLE		) return nBaseItemType; // "ED";
	if (iClass==CLASS_TYPE_SWASHBUCKLER		) return nBaseItemType; // "SB";
	if (iClass==CLASS_TYPE_DOOMGUIDE		) return nBaseItemType; // "DG";
	if (iClass==CLASS_TYPE_HELLFIRE_WARLOCK	) return nBaseItemType; // "HW";
	if (iClass==CLASS_CANAITH_LYRIST		) return nBaseItemType; // "CN";
	if (iClass==CLASS_LYRIC_THAUMATURGE		) return nBaseItemType; // "LY";
	if (iClass==CLASS_KNIGHT_TIERDRIAL		) return nBaseItemType; // "KT";
	if (iClass==CLASS_SHADOWBANE_STALKER	) return nBaseItemType; // "SS";
	if (iClass==CLASS_DRAGON_SHAMAN			) return nBaseItemType; // "DS";
	if (iClass==CLASS_DREAD_COMMANDO		) return nBaseItemType; // "DR";
	if (iClass==CLASS_CHAMP_SILVER_FLAME	) return nBaseItemType; // "CF";
	if (iClass==CLASS_FIST_FOREST			) return nBaseItemType; // "FF";
	if (iClass==CLASS_SWORD_DANCER			) return nBaseItemType; // "SD";
	if (iClass==CLASS_DRAGON_WARRIOR		) return nBaseItemType; // "DW";
	if (iClass==CLASS_CHILD_NIGHT			) return nBaseItemType; // "CH";
	if (iClass==CLASS_DERVISH				) return nBaseItemType; // "DV";
	if (iClass==CLASS_GHOST_FACED_KILLER	) return nBaseItemType; // "GF";
	if (iClass==CLASS_DREAD_PIRATE			) return nBaseItemType; // "DP";
	if (iClass==CLASS_DAGGERSPELL_MAGE		) return nBaseItemType; // "DM";
	if (iClass==CLASS_DAGGERSPELL_SHAPER	) return nBaseItemType; // "DS";
	if (iClass==CLASS_WILD_STALKER			) return nBaseItemType; // "WS";
	if (iClass==CLASS_VERDANT_GUARDIAN 		) return nBaseItemType; // "VG";
	if (iClass==CLASS_DISSONANT_CHORD		) return nBaseItemType; // "DC";

	// animals and monster classes
	if (iClass==CLASS_TYPE_MAGICAL_BEAST    ) return nBaseItemType; // "MB";
	if (iClass==CLASS_TYPE_ABERRATION       ) return nBaseItemType; // "AB";
	if (iClass==CLASS_TYPE_HUMANOID         ) return nBaseItemType; // "HU";
	if (iClass==CLASS_TYPE_ANIMAL           ) return nBaseItemType; // "AN";
	if (iClass==CLASS_TYPE_MONSTROUS        ) return nBaseItemType; // "MO";
	if (iClass==CLASS_TYPE_OOZE             ) return nBaseItemType; // "OO";
	if (iClass==CLASS_TYPE_OUTSIDER         ) return nBaseItemType; // "OU";
	if (iClass==CLASS_TYPE_BEAST            ) return nBaseItemType; // "BE";
	if (iClass==CLASS_TYPE_COMMONER         ) return nBaseItemType; // "CO";
	if (iClass==CLASS_TYPE_CONSTRUCT        ) return nBaseItemType; // "CN";
	if (iClass==CLASS_TYPE_DRAGON           ) return nBaseItemType; // "DR";
	if (iClass==CLASS_TYPE_SHAPECHANGER     ) return nBaseItemType; // "SC";
	if (iClass==CLASS_TYPE_ELEMENTAL        ) return nBaseItemType; // "EL";
	if (iClass==CLASS_TYPE_UNDEAD           ) return nBaseItemType; // "UD";
	if (iClass==CLASS_TYPE_FEY              ) return nBaseItemType; // "FE";
	if (iClass==CLASS_TYPE_VERMIN           ) return nBaseItemType; // "VE";
	if (iClass==CLASS_TYPE_GIANT            ) return nBaseItemType; // "GI";
	// if (iClass==CLASS_DRAGON_SAMURAI        ) return nBaseItemType; // "DS";
	*/
	
	return nBaseItemType;
}



int CSLGetBestBaseItemByWeaponFeats( object oPC = OBJECT_SELF, int nBaseItemType = BASE_ITEM_INVALID )
{
	if(GetHasFeat( FEAT_WEAPON_FOCUS_BASTARD_SWORD, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_BASTARD_SWORD, oPC ) )
	{
		nBaseItemType = BASE_ITEM_BASTARDSWORD;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_BATTLE_AXE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_BATTLE_AXE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_BATTLEAXE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_CLUB, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_CLUB, oPC ) )
	{
		nBaseItemType = BASE_ITEM_CLUB;
	}
	//else if(GetHasFeat( FEAT_WEAPON_FOCUS_CREATURE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_CREATURE, oPC ) )
	//{
	///	nBaseItemType = BASE_ITEM_XXXX;
	//}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_DAGGER, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_DAGGER, oPC ) )
	{
		nBaseItemType = BASE_ITEM_DAGGER;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_DART, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_DART, oPC ) )
	{
		nBaseItemType = BASE_ITEM_DART;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_DIRE_MACE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_DIRE_MACE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_DIREMACE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_DOUBLE_AXE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_DOUBLE_AXE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_DOUBLEAXE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_DWAXE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_DWAXE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_DWARVENWARAXE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_FALCHION, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_FALCHION, oPC ) )
	{
		nBaseItemType = BASE_ITEM_FALCHION;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_GREATCLUB, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_GREATCLUB, oPC ) )
	{
		nBaseItemType = BASE_ITEM_GREATCLUB;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_GREAT_AXE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_GREAT_AXE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_GREATAXE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_GREAT_SWORD, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_GREAT_SWORD, oPC ) )
	{
		nBaseItemType = BASE_ITEM_GREATSWORD;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_HALBERD, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_HALBERD, oPC ) )
	{
		nBaseItemType = BASE_ITEM_HALBERD;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_HAND_AXE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_HAND_AXE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_HANDAXE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW, oPC ) )
	{
		nBaseItemType = BASE_ITEM_HEAVYCROSSBOW;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_HEAVY_FLAIL, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL, oPC ) )
	{
		nBaseItemType = BASE_ITEM_HEAVYFLAIL;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_KAMA, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_KAMA, oPC ) )
	{
		nBaseItemType = BASE_ITEM_KAMA;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_KATANA, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_KATANA, oPC ) )
	{
		nBaseItemType = BASE_ITEM_KATANA;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_KUKRI, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_KUKRI, oPC ) )
	{
		nBaseItemType = BASE_ITEM_KUKRI;
	}
	//else if(GetHasFeat( FEAT_WEAPON_FOCUS_LANCE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_LANCE, oPC ) )
	//{
	//	nBaseItemType = BASE_ITEM_XXXX;
	//}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW, oPC ) )
	{
		nBaseItemType = BASE_ITEM_LIGHTCROSSBOW;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_LIGHT_FLAIL, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL, oPC ) )
	{
		nBaseItemType = BASE_ITEM_LIGHTFLAIL;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_LIGHT_HAMMER, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER, oPC ) )
	{
		nBaseItemType = BASE_ITEM_LIGHTHAMMER;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_LIGHT_MACE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_LIGHT_MACE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_LIGHTMACE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_LONGBOW, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_LONGBOW, oPC ) )
	{
		nBaseItemType = BASE_ITEM_LONGBOW;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_LONG_SWORD, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_LONG_SWORD, oPC ) )
	{
		nBaseItemType = BASE_ITEM_LONGSWORD;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_MORNING_STAR, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_MORNING_STAR, oPC ) )
	{
		nBaseItemType = BASE_ITEM_MORNINGSTAR;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_RAPIER, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_RAPIER, oPC ) )
	{
		nBaseItemType = BASE_ITEM_RAPIER;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_SCIMITAR, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SCIMITAR, oPC ) )
	{
		nBaseItemType = BASE_ITEM_SCIMITAR;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_SCYTHE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SCYTHE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_SCYTHE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_SHORTBOW, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SHORTBOW, oPC ) )
	{
		nBaseItemType = BASE_ITEM_SHORTBOW;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_SHORT_SWORD, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SHORT_SWORD, oPC ) )
	{
		nBaseItemType = BASE_ITEM_SHORTSWORD;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_SHURIKEN, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SHURIKEN, oPC ) )
	{
		nBaseItemType = BASE_ITEM_SHURIKEN;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_SICKLE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SICKLE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_SICKLE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_SLING, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SLING, oPC ) )
	{
		nBaseItemType = BASE_ITEM_SLING;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_SPEAR, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SPEAR, oPC ) )
	{
		nBaseItemType = BASE_ITEM_SHORTSPEAR;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_STAFF, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_STAFF, oPC ) )
	{
		nBaseItemType = BASE_ITEM_QUARTERSTAFF;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_THROWING_AXE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_THROWING_AXE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_THROWINGAXE;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD, oPC ) )
	{
		nBaseItemType = BASE_ITEM_TWOBLADEDSWORD;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_WAR_HAMMER, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_WAR_HAMMER, oPC ) )
	{
		nBaseItemType = BASE_ITEM_WARHAMMER;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_WHIP, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_WHIP, oPC ) )
	{
		nBaseItemType = BASE_ITEM_WHIP;
	}
	else if(GetHasFeat( FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE, oPC ) )
	{
		nBaseItemType = BASE_ITEM_GLOVES;
	}
	//else if(GetHasFeat( FEAT_WEAPON_FOCUS_SAP, oPC ) || GetHasFeat( FEAT_IMPROVED_CRITICAL_SAP, oPC ) )
	//{
	//	nBaseItemType = BASE_ITEM_XXXX;
	//}
	
	// if (GetHasFeat(FEAT_WEAPON_FINESSE, oCreature, TRUE)
	// if (GetHasFeat(FEAT_ZEN_ARCHERY, oCreature, TRUE)
	// BASE_ITEM_RAPIER
	// GetCreatureSize(oCreature)
	return nBaseItemType;
} //





string CSLGetAppropriateWeaponResRef( object oPC )
{
	//DEBUGGING = 3;
	int iWeaponBaseItemType = BASE_ITEM_QUARTERSTAFF; // set a default if they don't know
	if (DEBUGGING >= 3) { CSLDebug(  "CSLGetAppropriateWeaponResRef club = "+CSLGetBaseItemDataName( iWeaponBaseItemType ), oPC  ); }
	
	iWeaponBaseItemType = CSLGetBestBaseItemByClass( oPC, GetClassByPosition(1, oPC), iWeaponBaseItemType );
	if (DEBUGGING >= 3) { CSLDebug(  "CSLGetAppropriateWeaponResRef CSLGetBestBaseItemByClass = "+CSLGetBaseItemDataName( iWeaponBaseItemType ), oPC  ); }
	
	iWeaponBaseItemType = CSLGetBestBaseItemByWeaponFeats( oPC, iWeaponBaseItemType );
	if (DEBUGGING >= 3) { CSLDebug(  "CSLGetAppropriateWeaponResRef CSLGetBestBaseItemByWeaponFeats = "+CSLGetBaseItemDataName( iWeaponBaseItemType ), oPC  ); }
	
	string sWeaponType = CSLGetBaseItemResRef(iWeaponBaseItemType, "nw_wblcl001");
	if (DEBUGGING >= 3) { CSLDebug(  "CSLGetAppropriateWeaponResRef CSLGetBaseItemResRef = "+sWeaponType, oPC  ); }
	
	if ( sWeaponType == "" )
	{
		if (DEBUGGING >= 3) { CSLDebug(  "No Resref, setting to club resref", oPC  ); }
		return "nw_wblcl001"; // invalid, lets give a club
		
	}
	return sWeaponType;
}


//@} ****************************************************************************************************




/********************************************************************************************************/
/** @name XXXX Functions
* Description
********************************************************************************************************* @{ */


//@} ****************************************************************************************************


//    Seeks out an enemy more than 5m away and alone
//:: Created By: Preston Watamaniuk
//:: Created On: October 5, 2001
object CSLFindSingleRangedTarget( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "CSLFindSingleRangedTarget Start", GetFirstPC() ); }
    float fArcheryRange = 30.0f;
    object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int iIteration = 0;
    if ( GetWeaponRanged(oRightHand) )
    {
    	int iBaseItemType = GetBaseItemType(oRightHand);
    
    	if ( iBaseItemType == BASE_ITEM_LONGBOW )
    	{
    		fArcheryRange = 80.0f;
    	}
    	else if ( iBaseItemType == BASE_ITEM_SHORTBOW )
    	{
    		fArcheryRange = 50.0f;
    	}
    	else if ( iBaseItemType == BASE_ITEM_SLING )
    	{
    		fArcheryRange = 20.0f;
    	}
    	else if ( iBaseItemType == BASE_ITEM_LIGHTCROSSBOW )
    	{
    		fArcheryRange = 40.0f;
    	}
    	else if ( iBaseItemType == BASE_ITEM_HEAVYCROSSBOW )
    	{
    		fArcheryRange = 60.0f;
    	}
    	else if ( iBaseItemType == BASE_ITEM_DART )
    	{
    		fArcheryRange = 20.0f;
    	}
    	else if ( iBaseItemType == BASE_ITEM_THROWINGAXE )
    	{
    		fArcheryRange = 25.0f;
    	}
    }
    
    
    int nCnt = FALSE;
    object oTarget;
    float fDistance = (fArcheryRange-10.0f);
    object oCount = GetFirstObjectInShape(SHAPE_SPHERE, fArcheryRange, GetLocation(oCharacter), TRUE);
    while (GetIsObjectValid(oCount) && nCnt == FALSE && iIteration < 50)
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        iIteration++;
        if(oCount != oCharacter)
        {
            if(GetIsEnemy(oCount) && oTarget != oCharacter && GetObjectSeen( oTarget, oCharacter) )
            {
                fDistance = GetDistanceBetween(oTarget, oCharacter);
                if(fDistance == 0.0)
                {
                    fDistance = fArcheryRange;
                }
                if(GetDistanceBetween(oCount, oCharacter) < fDistance && fDistance > 3.0)
                {
                    oTarget = oCount;
                    //nCnt = TRUE;
                }
            }
        }
        oCount = GetNextObjectInShape(SHAPE_SPHERE, fArcheryRange, GetLocation(oCharacter));
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "CSLFindSingleRangedTarget End", GetFirstPC() ); }
    return oTarget;
}

// Returns TRUE if the given opponent is wielding a
// ranged weapon.
/*
int SCGetIsWieldingRanged(object oAttacker)
{
    return GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker));
}
*/




// * returns true if out of ammo of currently equipped weapons
int CSLIsOutOfAmmo(int bIAmAHenc)
{
    //DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "CSLIsOutOfAmmo Start", GetFirstPC() ); }
    if (1 || bIAmAHenc == FALSE)
    {
		object oWeapon 	= GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        int nWeaponType = GetBaseItemType(oWeapon);
        object oAmmo 	= OBJECT_INVALID;
		
		// Get what's in item slot based on ranged weapon in our right hand.
        if (nWeaponType == BASE_ITEM_LONGBOW || nWeaponType == BASE_ITEM_SHORTBOW)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
        }
        else
        if (nWeaponType == BASE_ITEM_LIGHTCROSSBOW || nWeaponType == BASE_ITEM_HEAVYCROSSBOW)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
        }
        else
        if (nWeaponType == BASE_ITEM_SLING)
        {
            oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);
        } 
		else 
		{
			return FALSE;
		}
		
		// Unlimited ammo causes a problem...							
		itemproperty eff=GetFirstItemProperty(oWeapon);
		while(GetIsItemPropertyValid(eff)) 
		{
			//DEBUGGING// igDebugLoopCounter += 1;
			if(GetItemPropertyType(eff) == ITEM_PROPERTY_UNLIMITED_AMMUNITION) 
				return FALSE;
			eff = GetNextItemProperty(oWeapon);
		}
		
        if (GetIsObjectValid(oAmmo) == FALSE)
        {
            //PrintString("***out of ammo!!!***");
            return TRUE;
        }
    }
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "CSLIsOutOfAmmo End", GetFirstPC() ); }
	return FALSE;
}


// * New function February 28 2003. Need a wrapper for ranged
// * so I have quick access to exiting from it for OC henchmen
// * equipping
void CSLEquipRanged(object oTarget=OBJECT_INVALID, int bIAmAHenc = FALSE, int bForceEquip = FALSE, object oCharacter = OBJECT_SELF)
{  
		//DEBUGGING// if (DEBUGGING >= 7) { CSLDebug(  "CSLEquipRanged Start "+GetName(oTarget), GetFirstPC() ); }
	// Roster Companions will not try to switch weapons on their own
	if (GetIsRosterMember(oCharacter) || GetIsOwnedByPlayer(oCharacter))
		return;
	
	
    int bOldHench = FALSE;

    // * old OC henchmen have different equipping rules.
    if (GetLocalInt(oCharacter, "X0_L_NOTALLOWEDTOHAVEINVENTORY") ==  10)
    {
        bOldHench = TRUE;
    }

    // * If I am an XP1 henchmen and I have not been explicitly
    // * told to re-equip a ranged weapon
    // * than don't EVER equip ranged weapons (i.e., if I never
    // * started out with one in my hand then I shouldn't start
    // * using one unless I have no other weapons.
    if (bForceEquip == FALSE && bOldHench == FALSE && bIAmAHenc == TRUE)
    {
        return;
    }

    // * if I am a henchmen and been told to use only melee, I should obey
    if (bIAmAHenc = TRUE && bOldHench == TRUE && CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON) == FALSE) { return;}

    ActionEquipMostDamagingRanged(oTarget);
    
    //DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "CSLEquipRanged End", GetFirstPC() ); }
}




// stores the last Ranged weapons used for when the
// henchmen switches from Ranged to melee in XP1
void CSLStoreLastRanged(object oCharacter = OBJECT_SELF)
{
    if (GetLocalObject(oCharacter, "X0_L_RIGHTHAND") == OBJECT_INVALID )
    {
        object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        if (GetIsObjectValid(oItem1) && GetWeaponRanged(oItem1))
            SetLocalObject(oCharacter, "X0_L_RIGHTHAND", oItem1);
    }
}

// not used in new version of SC EquipMelee()
// * checks to see if oUser has ambidexteriy and two weapon fighting
int CSLWiseToDualWield(object oUser)
{

// JLR - OEI 06/03/05 NWN2 3.5 -- Ambidexterity was merged into Two-Weapon Fighting
    if (GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oUser))
    {
        return TRUE;
    }
    return FALSE;
}


// Equip melee weapon AND check for shield.
//    nClearActions: If this is False, it won't ever clear actions
//                   The henchmen requipping rules require this (BKNOV2002)
void CSLEquipMelee(object oTarget = OBJECT_INVALID, int nClearActions=TRUE, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "CSLEquipMelee Start "+GetName(oTarget), GetFirstPC() ); }
    
    // * BK Feb 2003: If I am an associate and have been ordered to use ranged
    // * weapons never try to equip my shield
    if (CSLGetAssociateState(CSL_ASC_USE_RANGED_WEAPON) == TRUE) { return;}

    int bOldHench = FALSE;
    if (GetLocalInt(oCharacter, "X0_L_NOTALLOWEDTOHAVEINVENTORY") ==  10)
    {
        bOldHench = TRUE;
    }

    object oLeftHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND); // What I have in my left hand current
    // * May 2003: If already holding a weapon and I am an XP1 henchmen
    // * do not try to equip another weapon melee weapon.
    // * XP1 henchmen should only switch weapons if going from ranged to melee.
    if (GetIsObjectValid(GetMaster()) && !bOldHench
        // * valid weapon in hand that is NOT a ranged weapon
        && (GetIsObjectValid(oLeftHand) == TRUE && GetWeaponRanged(oLeftHand) == FALSE) )
    {
        return;
    }

    object oShield=OBJECT_INVALID;
    object oLeft=OBJECT_INVALID;
    object oRight=OBJECT_INVALID;

    // Are we already dual-wielding? Don't do anything.
    if (CSLMatchSingleHandedWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) &&
        CSLMatchSingleHandedWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND)))
        return;

    // Check for the presence of a shield and the number of
    // single-handed weapons.
    object oSelf = OBJECT_SELF;
    object oItem = GetFirstItemInInventory(oSelf);

    int iHaveShield = FALSE;
    int nSingle = 0;

    while (GetIsObjectValid(oItem))
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        if (CSLMatchSingleHandedWeapon(oItem))
        {
            nSingle++;
            if (nSingle == 1)
            {
                oLeft = oItem;
            }
            else if (nSingle == 2)
            {
                oRight = oItem;
            }
            else 
            {
                // see if the one we just found is better?
            }
        }
        else if (CSLItemGetIsShield(oItem))
        {
            iHaveShield = TRUE;
            oShield = oItem;
        }
        oItem = GetNextItemInInventory(oSelf);
   }

   int bAlreadyClearedActions = FALSE;

    // * May 2003 -- Only equip if found a singlehanded weapon that I will equip
    if (GetIsObjectValid(oLeft) && iHaveShield && GetHasFeat(FEAT_SHIELD_PROFICIENCY,oSelf) && (CSLItemGetIsShield(oLeftHand) == FALSE)  )
    {
        if (nClearActions == TRUE)
        {
            ClearAllActions();
        }
        // HACK HACK HACK
        //   Need to do this three times to get the shield to actually equip in certain circumstances
        // HACK HACK HACK 
      //  SpeakString("*******************************************SHIELD");

        // * March 2003 : redundant code, but didn't want to break existing behavior
        if (GetIsObjectValid(oRight) == TRUE || GetIsObjectValid(oLeft))
        {
           // SpeakString("equip melee");
            //ActionEquipMostDamagingMelee(oTarget);
            ActionEquipItem(oLeft,INVENTORY_SLOT_RIGHTHAND);
            ActionEquipItem(oLeft,INVENTORY_SLOT_RIGHTHAND);
            ActionEquipItem(oLeft,INVENTORY_SLOT_RIGHTHAND);
        }
        ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
        ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
        ActionEquipItem(oShield,INVENTORY_SLOT_LEFTHAND);
        return;
    }
    else if (nSingle >= 2 && CSLWiseToDualWield(oCharacter))
    {
        // SpeakString("dual-wielding");
        if (nClearActions == TRUE )
            ClearAllActions();
        ActionEquipItem(oRight,INVENTORY_SLOT_RIGHTHAND);
        ActionEquipItem(oLeft,INVENTORY_SLOT_LEFTHAND);
        return;
    }


    // * don't switch to bare hands
    if (GetIsObjectValid(oRight) == TRUE || GetIsObjectValid(oLeft))
    {

        if (nClearActions == TRUE && bAlreadyClearedActions == FALSE)
            ClearAllActions();
        // * It would be better to use ActionEquipMostDamaging here, but it is inconsistent
        if (GetIsObjectValid(oRight) == TRUE)
            ActionEquipItem(oRight,INVENTORY_SLOT_RIGHTHAND);
        else
        if (GetIsObjectValid(oLeft) == TRUE)
            ActionEquipItem(oLeft,INVENTORY_SLOT_RIGHTHAND);

        return;
    }

    // Fallback: If I'm still here, try ActionEquipMostDamagingMelee
    ActionEquipMostDamagingMelee(oTarget);

    // * if not melee weapon found then try ranged
    // * April 2003 removed this beccause henchmen sometimes fall down into this
   // SC EquipRanged(oTarget);
}




//    Makes the user get his best weapons.  If the
//    user is a Henchmen then he checks the player
//    preference.
//:: Created By: Preston Watamaniuk
//:: Created On: April 2, 2002
//:: BK: Incorporated Pausanias' changes
//:: and moved to x0_inc_generic
//:: left EquipAppropriateWeapons in nw_i0_generic as a wrapper
//:: function passing in whether this creature
//:: prefers RANGED or MELEE attacks
void CSLEquipAppropriateWeapons(object oTarget, int nPrefersRanged=FALSE, int nClearActions=TRUE, object oCharacter = OBJECT_SELF)
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "CSLEquipAppropriateWeapons Start "+GetName(oTarget), GetFirstPC() ); }
	
	// Roster Companions and characters owned by players will not try to switch weapons on their own
	if (GetIsRosterMember(oCharacter) || GetIsOwnedByPlayer(oCharacter))
		return;
	
	
    // * Associates never try to switch weapons on their own
    // * but original campaign henchmen have to be able to do this.
    int bIAmAHench = GetIsObjectValid(GetMaster());
 //   if (bIAmAHench == TRUE
 //       && GetLocalInt(oCharacter, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0) return;

     int bEmptyHanded = FALSE;

    object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int bIsWieldingRanged = FALSE;
    object oEnemy = CSLGetNearestPerceivedEnemy();

    // * determine if I am wielding a ranged weapon
    bIsWieldingRanged = GetWeaponRanged(oRightHand) && (CSLIsOutOfAmmo(bIAmAHench) == FALSE);

    if (GetIsObjectValid(oRightHand) == FALSE)
    {
        bEmptyHanded = TRUE;
    }


    // * anytime there is no enemy around, try  a ranged weapon
    if (GetIsObjectValid(oEnemy) == FALSE) {
        if (nClearActions)
            ClearAllActions();


        // MODIFIED Feb 11 2003
        // henchmen should not equip ranged weapons here because its outside
        // of the weapon preference code (OC)
        if (bIAmAHench == FALSE)
        {
            CSLEquipRanged(OBJECT_INVALID, bIAmAHench);
            return;
        }
    }

    float fDistance = GetDistanceBetween(oCharacter, oEnemy);

    // * Equip the appropriate weapon for the distance of the enemy.
    // * If enemy is too close AND I do not have The Point Blank feat

    // * Point blank is only useful in Normal or less however (Oct 1 2003 BK)
    int bPointBlankShotMatters = FALSE;
    if (GetHasFeat(FEAT_POINT_BLANK_SHOT, oCharacter) == TRUE)
    {
        bPointBlankShotMatters = TRUE;
    }
    if (GetGameDifficulty()== GAME_DIFFICULTY_CORE_RULES || GetGameDifficulty()== GAME_DIFFICULTY_DIFFICULT)
    {
        bPointBlankShotMatters = FALSE;
    }

    if ((fDistance < CSL_MELEE_DISTANCE) && bPointBlankShotMatters == FALSE)
    {
        // If I'm using a ranged weapon, and I'm in close range,
        // AND I haven't already switched to melee, do so now.
        if (bIsWieldingRanged || bEmptyHanded)
        {
            // xp1 henchmen store ranged weapon so I can switch back to it later
            if (bIAmAHench == TRUE && GetLocalInt(oCharacter, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0)
            {
                CSLStoreLastRanged();
            }
            CSLEquipMelee(oTarget, nClearActions);
        }
    }
    else
    {
        // If I'm not at close range, AND I was told to use a ranged
        // weapon, BUT I switched to melee, switch back to missile.
        if ( ! bIsWieldingRanged && nPrefersRanged)
        {
            if (nClearActions)
                ClearAllActions();
            CSLEquipRanged(oTarget, bIAmAHench);
        }
        // * If I am at Ranged distance and I am equipped with a ranged weapon
        // * I might as well stay at range and continue shooting.
        if (bIsWieldingRanged == TRUE)
        {
            return;
        }
        else
        {
            // xp1 henchmen store ranged weapon so I can switch back to it later
            if (bIAmAHench == TRUE && GetLocalInt(oCharacter, "X0_L_NOTALLOWEDTOHAVEINVENTORY") == 0)
                CSLStoreLastRanged();
            CSLEquipMelee(oTarget, nClearActions);
        }
    }
}



// create a comma delimited list of items in the inventory of oTarget
// bIdentify: -1 leave as default, FALSE (0) - set as not identified, TRUE (1) - set as identified.
// @replaces xxxCreateListOfItemsInInventory
void CSLCreateItemsInInventoryBasedOnList(string sItemTemplateList, object oTarget, int bIdentify=TRUE)
{
	if ( sItemTemplateList != "" )
	{
		object oCreatedObject;
		string sItemCurrent;
		int i;
		int iCount = CSLNth_GetCount( sItemTemplateList );
		for ( i=1; i <= iCount; i++ )
		{
			sItemCurrent = CSLNth_GetNthElement(sItemTemplateList, i);
			if ( sItemCurrent != "" )
			{
				//output ("creating :" + sItemCurrent);
				oCreatedObject = CreateItemOnObject(sItemCurrent, oTarget);
				if (bIdentify != -1)
				{
					SetIdentified(oCreatedObject, bIdentify);
				}
			}
		}
	}
}

object DMFI_Storage(object oPC, object oTarget)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_Storage Start", oPC ); }
	//Purpose: Create a storage locker for the player in case we want to give back
// items to the player.  If there is not one valid, this creates one for you.
//Original Scripter: Demetrious
//Last Modified By: Demetrious 2/4/7, Qk 10/08/07  (dragonsbane fixes)
	object oStorage, oTemp, oTest;
	
	oStorage = GetItemPossessedBy(oPC, GetName(oTarget));
	if (!GetIsObjectValid(oStorage))
	{
		SendMessageToPC(oPC, "Creating Storage Bag: " + GetName(oTarget));
		oTest = CreateItemOnObject(DMFI_STORAGE, oPC);
		oStorage = CopyObject(oTest, GetLocation(oPC), oPC, DMFI_INVEN_TEMP);
		// QK -> Dragonsbane: Fix for NWN2 v1.10
		oStorage = GetNearestObjectByTag(DMFI_INVEN_TEMP,oPC);
		// End Update
		DestroyObject(oTest);
		SetFirstName(oStorage, GetName(oTarget));
		SetIdentified(oStorage, TRUE);
	}

	return oStorage;
}

void DMFI_RemoveUber(object oDM, object oTarget, string sLevel)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_RemoveUber Start", oDM ); }
	//Purpose: Removes items more valuable than the max value listed for sLevel
	// in the 2da max item value file.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/27/6
	int n;
	object oTest, oStorage;
	string sMax = Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", StringToInt(sLevel)-1);  // -1 is for 2da offset
	SendMessageToPC(oDM, "Maximum Allowed Value: " + sMax);
	
	oStorage = DMFI_Storage(oDM, oTarget);
	oTest = GetFirstItemInInventory(oTarget);
	AssignCommand(oTarget, ClearAllActions(TRUE));
	while (oTest!=OBJECT_INVALID)
	{
		if (GetGoldPieceValue(oTest)>(StringToInt(sMax)))
		{
			SetPlotFlag(oTest, FALSE);
			SetItemCursedFlag(oTest, FALSE);
			SetDroppableFlag(oTest, FALSE);
			AssignCommand(oTarget, ActionGiveItem(oTest, oStorage));
		}
		oTest = GetNextItemInInventory(oTarget);
	}
	
	for (n=0; n<18; n++)
	{  // Equiped
		oTest = GetItemInSlot(n, oTarget);
		if (GetGoldPieceValue(oTest)>(StringToInt(sMax)))
		{
			SetPlotFlag(oTest, FALSE);
			SetItemCursedFlag(oTest, FALSE);
			SetDroppableFlag(oTest, FALSE);
			AssignCommand(oTarget, ActionGiveItem(oTest, oStorage));
			n++;
		}
	}	
	AssignCommand(oDM, ActionPickUpItem(oStorage));
	SendMessageToPC(oDM, "Uber Items taken from target player");
	SendMessageToPC(oTarget, "DM has removed items from your inventory that are too strong for this module. SEVER LOG NOTED. ");
	WriteTimestampedLogEntry("DMFI Action Alert: " + GetName(oDM) + " " + "Uber Items taken from target player" + GetName(oTarget));
}


int DMFI_GetNetWorth(object oTarget)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_GetNetWorth Start", GetFirstPC() ); }
	//Purpose: Returns Net Worth value for oTarget
	//Gold Value, XP, Net Worth.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 12/23/6
	int n, nSlot;
	object oItem = GetFirstItemInInventory(oTarget);

	while(GetIsObjectValid(oItem))
	{
		n= n + GetGoldPieceValue(oItem);
		oItem = GetNextItemInInventory(oTarget);
	}
	for (nSlot=0; nSlot<18; nSlot++)
	{
		n= n + GetGoldPieceValue(GetItemInSlot(nSlot, oTarget));
	}
	n = n + GetGold(oTarget);	
		
	return n;
}

void DMFI_StripInventory(object oTarget, object oDM)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_StripInventory Start", oDM ); }
	//Purpose: Strips oTargets inventory as requested by oDM.  It will log the
//server that this action occurred.
//Original Scripter: Demetrious
//Last Modified By: Demetrious 12/27/6
	int n;
	object oStorage;
	object oTest;
	oStorage = DMFI_Storage(oDM, oTarget);
	oTest = GetFirstItemInInventory(oTarget);
	AssignCommand(oTarget, ClearAllActions(TRUE));
	while (oTest!=OBJECT_INVALID)
	{ // strip inventory items
		SetPlotFlag(oTest, FALSE);
		SetItemCursedFlag(oTest, FALSE);
		SetDroppableFlag(oTest, FALSE);
		AssignCommand(oTarget, ActionGiveItem(oTest, oStorage));
		oTest = GetNextItemInInventory(oTarget);
	}
	for (n=0; n<18; n++)
	{ // strip equiped items
		oTest = GetItemInSlot(n, oTarget);
		if (oTest!=OBJECT_INVALID)
		{
			AssignCommand(oTarget, ActionUnequipItem(oTest));
			SetPlotFlag(oTest, FALSE);
			SetItemCursedFlag(oTest, FALSE);
			SetDroppableFlag(oTest, FALSE);
			AssignCommand(oTarget, ActionGiveItem(oTest, oStorage));
		}
	}
	AssignCommand(oDM, ActionPickUpItem(oStorage));
	SendMessageToPC(oDM, "All inventory items removed from target");
	SendMessageToPC(oDM, "Note: Plot, Cursed, and Dropped Status toggled on items to ensure removal.");
	WriteTimestampedLogEntry("DMFI Action Alert: " + GetName(oDM) + " " + "All inventory items removed from target" + GetName(oTarget));
}

void DMFI_ManageInventory(object oTarget, object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_ManageInventory Start", oPC ); }
	
	int n;
	object oTest, oSubTest;
	object oNew;
	object oStorage = GetItemPossessedBy(oPC, DMFI_INVEN_TEMP);
	
	if (GetIsObjectValid(oStorage))
	{
		SetPlotFlag(oStorage, FALSE);
		DestroyObject(oStorage);
	}		
	
	SendMessageToPC(oPC, "Creating Storage Bag: " + DMFI_INVEN_TEMP);
	oTest = CreateItemOnObject(DMFI_STORAGE, oPC,1,DMFI_INVEN_TEMP);
	//oStorage = CopyObject(oTest, GetLocation(oPC), oPC, DMFI_INVEN_TEMP);
	oStorage = oTest;
	// Qk, dragonsbane fix didn't work
	// the workaround was to use the new CreateitemOnObject parameter, thanks god
	// oStorage = GetNearestObjectByTag(DMFI_INVEN_TEMP,oPC);
	//DestroyObject(oTest);
		// End Update
	SetFirstName(oStorage, DMFI_INVEN_TEMP + GetName(oTarget));
	SetIdentified(oStorage, TRUE);
	SetLocalObject(oPC, DMFI_INVENTORY_TARGET, oTarget);
	
	// Get Target's Inventory	
	oTest = GetFirstItemInInventory(oTarget);
	while (oTest!=OBJECT_INVALID)
	{ // strip inventory items
		oNew = CopyItem(oTest, oStorage, TRUE);
		SetLocalObject(oNew, DMFI_INVENTORY_TARGET, oTest);	
		oTest = GetNextItemInInventory(oTarget);
	}
	for (n=0; n<18; n++)
	{ // strip equiped items
		oTest = GetItemInSlot(n, oTarget);
		if (oTest!=OBJECT_INVALID)
		{
			oNew = CopyItem(oTest, oStorage, TRUE);
			SetLocalObject(oNew, DMFI_INVENTORY_TARGET, oTest);	
		}
	}
	AssignCommand(oPC, ActionPickUpItem(oStorage));
	SendMessageToPC(oPC, "Inventory Copied for Manipulation.");
}		




void DMFI_IdentifyInventory(object oTarget, object oDM)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_IdentifyInventory Start", oDM ); }
	//Purpose: Identifies all of oTargets inventory at the request of oDM
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 7/3/6
	int n;
	object oTest;
	oTest = GetFirstItemInInventory(oTarget);
	while (oTest!=OBJECT_INVALID)
	{ // identify inventory items
		if (!GetIdentified(oTest))
		{
			SetIdentified(oTest, TRUE);
		}
		oTest = GetNextItemInInventory(oTarget);
	}
	for (n=0; n<18; n++)
	{ // identify any equiped items
		oTest = GetItemInSlot(n, oTarget);
		if (oTest!=OBJECT_INVALID)
		{
			if (!GetIdentified(oTest))
			{
				SetIdentified(oTest, TRUE);
			}
		}
	}

	SendMessageToPC(oDM, "All inventory items for the target have been identified");
	SendMessageToPC(oTarget, "DM has identified all inventory items for you.");
}

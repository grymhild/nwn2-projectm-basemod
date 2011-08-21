/** @file
* @brief Include file for character editor and related User Interfaces
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



//#include "_SCInclude_Playerlist_C"
#include "_CSLCore_Strings"
#include "_CSLCore_Math"
#include "_CSLCore_UI"
#include "_CSLCore_Position"

#include "_CSLCore_ObjectVars"
#include "_CSLCore_Magic"
#include "_CSLCore_Reputation"
#include "_CSLCore_Player"
#include "_CSLCore_Combat"
#include "_CSLCore_Class"
#include "_CSLCore_UI"

#include "_SCInclude_CacheStats"


const int 		WAND_INV_AND_EQ_VALUE_LENGTH		= 26;
const int 		WAND_MIN_EQ_ITEM_NAME_LENGTH		= 26;
const int 		WAND_PIM_SLOT_OFFSET				= 10;
const int		WAND_PIM_SLOT_TOOLTIP_OFFSET		= 1000;

// Set this constant to:
// TRUE -> Item Level Restricion enabled
// FALSE -> Item Level Restriction disabled
const int ITEM_LEVEL_RESTRICTION = FALSE;
const int 		WAND_MAX_ITEM_NAME_LENGTH			= 25;

// written by caos as part of dm inventory system, integrating
struct structSCInvenGlobalValues 
{
	int iTotWeight;
	int iTotValue;
};

	/*
	// do the default resetting row now
	sRow = "-1";
	sRowName = "None";
	sHide = "";
	sTextures = "";
	sFields = "EFFECTLISTBOX_TEXT="+sRowName;
	sVariables = "5=None;6="+sRow;
	AddListBoxRow(oPC,sScreenName,"ANIMATIONMODES_LIST",sRowName,sFields, sTextures,sVariables,sHide);
	Label,Icon,KeyAbility
	*/



// iAction == CSL_LISTBOXROW_ADD
void SCCharEdit_Build_SkillsListBox( object oTarget, object oPC = OBJECT_SELF, int iAction = CSL_LISTBOXROW_ADD, string sScreenName = SCREEN_CHARACTEREDIT )
{
	if ( iAction == CSL_LISTBOXROW_ADD )
	{
		ClearListBox(oPC, sScreenName, "SKILLPANE_LIST");
	}
	string sRow, sRowText, sRowName,sFields,sTextures,sVariables,sHide;
	
	
	object oTable = CSLDataObjectGet( "skills" );
	if ( !GetIsObjectValid( oTable )  )
	{
		return; // SendMessageToPC( oPC, "Table is invalid");
	}
	
	
	int nCurrent = 0;
	int iTotalItems = CSLDataTableCount( oTable );
	int iRow;
	string sIcon, sRank;
	while (nCurrent<iTotalItems)
	{
		iRow = CSLDataTableGetRowByIndex( oTable, nCurrent );
		sRank = IntToString( GetSkillRank( iRow, oTarget, FALSE ) )+"/"+IntToString( GetSkillRank( iRow, oTarget, TRUE ) );
		sRow = IntToString(iRow);
		sRowName = CSLDataTableGetStringFromNameColumn( oTable, iRow );
		sRowText = CSLDataTableGetStringByIndex( oTable, "Name", nCurrent ); /// CSLDataTableGetStringFromNameColumn( oTable, iRow );
		
		sIcon = CSLDataTableGetStringByIndex( oTable, "Icon", nCurrent );
		sHide = "";
		sTextures = "SKILL_IMAGE="+sIcon+".tga";
		sFields = "SKILL_TEXT="+sRowText+";SKILL_RANK="+sRank;
		sVariables = "5="+sRowName+";6="+sRow;
		
		if ( iAction == CSL_LISTBOXROW_ADD )
		{
			AddListBoxRow(oPC,sScreenName,"SKILLPANE_LIST",sRowName,sFields, sTextures,sVariables,sHide);
		}
		else
		{
			ModifyListBoxRow(oPC,sScreenName,"SKILLPANE_LIST",sRowName,sFields, sTextures,sVariables,sHide);
		}
		nCurrent++;
	}
		
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
//void CSLRemoveItem (object oUiOwner, object oItem)
//{
//	
//	int iBaseItemType = GetBaseItemType(oItem);
//	string sObjectId = IntToString(ObjectToInt(oItem));
//	string sListBox = SCCharEdit_GetListBoxNameByItemType (iBaseItemType);
//	
//	RemoveListBoxRow(oUiOwner, WAND_GUI_PC_INVENTORY, sListBox, "Item_" + sObjectId);
//}


/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
object SCCharEdit_GetLastDraggedItem(object oPc)
{
	return GetLocalObject(oPc, "LAST_DRAGGED_ITEM");
}


void SCCharEdit_Build_AddEffectListRow( effect eEffect, object oPC = OBJECT_SELF,string sScreenName = SCREEN_CHARACTEREDIT )
{
		
	string sRow1, sRow2, sRowName,sFields,sTextures,sVariables,sHide;
	int iSpellId, iEffectType, iEffectSubType, iEffectInteger;

	iSpellId = GetEffectSpellId(eEffect);
	iEffectType = GetEffectType(eEffect);
	iEffectSubType = GetEffectSubType(eEffect);
	
	
		
		sRow1 = CSLGetSpellDataName(iSpellId);
		if ( sRow1 != "" )
		{
			sRow1 += " - ";
		}
		sRow1 += CSLGetEffectTypeName( iEffectType );
		
		
		iEffectInteger = GetEffectInteger( eEffect, 1 );
		if ( iEffectInteger > 0 )
		{
			sRow2 += " - "+IntToString(iEffectInteger);
			iEffectInteger = GetEffectInteger( eEffect, 2 );
			if ( iEffectInteger > 0 )
			{
				sRow2 += " / "+IntToString(iEffectInteger);
				iEffectInteger = GetEffectInteger( eEffect, 3 );
				if ( iEffectInteger > 0 )
				{
					sRow2 += " / "+IntToString(iEffectInteger);
					iEffectInteger = GetEffectInteger( eEffect, 4 );
					if ( iEffectInteger > 0 )
					{
						sRow2 += " / "+IntToString(iEffectInteger);
					}
				}
			}
		}
		if ( GetIsObjectValid( GetEffectCreator(eEffect) ) )
		{
			if ( sRow2 != "" )
			{
				sRow2 += " - ";
			}
			sRow2 += GetName(GetEffectCreator(eEffect));
		}
		if ( sRow2 != "" )
		{
			sRow2 += " - ";
		}
		sRow2 += CSLGetEffectSubTypeName(iEffectSubType);
		
		
		
		sRowName = "NAME"+IntToString(iSpellId)+" "+IntToString(iEffectType);
		
		sHide = "";
		string sIcon = CSLGetSpellDataIcon(iSpellId);
		if ( sIcon != "" )
		{
			sTextures = "EFFECT_ICON="+sIcon+".tga";
		}
		else
		{
			sTextures = "";
		}
		sFields = "EFFECT_TEXT1="+sRow1+"\n"+sRow2; //+"CSL_STATUS="+sStatus;
		//sVariables = "1="+IntToString(iSpellId)+";2="+IntToString(iEffectType);
		sVariables = "5="+IntToString(iSpellId);
		AddListBoxRow(oPC,sScreenName,"EFFECTLISTBOX",sRowName,sFields, sTextures,sVariables,sHide);
		//SendMessageToPC( oPC, sVariables );
}




void SCCharEdit_Build( object oTarget, object oPC = OBJECT_SELF,string sScreenName = SCREEN_CHARACTEREDIT )
{
	//SendMessageToPC( oPC, "Building "+GetName(oTarget)+" "+IntToString(ObjectToInt(oTarget)) );
	if ( !GetIsObjectValid( oTarget) )
	{
		CloseGUIScreen( oPC,sScreenName );
		return;
	}
	
	SCCacheStats( oTarget );
	// just as a default
	string sTexture = "";
	string sText = "XXXXX";
	int iLevel = GetHitDice(oTarget);
	
	int iXPLevel = CSLGetRealLevel(oTarget);
	
	int nXP = GetXP(oTarget);
	int nNextXP = (( iLevel * ( iLevel + 1 )) / 2 * 1000 );
	int nXPForNextLevel = nNextXP - nXP;
	if (iLevel==30) { nXPForNextLevel = 0; }
   
	string sHitDice = "Hit Dice: "+IntToString(iLevel);
	if ( iLevel != iXPLevel )
	{
		sHitDice += " / XP To: "+IntToString(iXPLevel);
	}
	
	SetLocalGUIVariable(oPC,sScreenName,999,IntToString(ObjectToInt(oTarget))); 
	
	//SetGUIObjectText( oPC, sScreenName, "EXP_RATIO", -1, IntToString( nXP )+" / " +IntToString(nNextXP) );
	SetGUIObjectText( oPC, sScreenName, "EXPER_CURRENT", -1, "Exp: "+IntToString(nXP)  );
	SetGUIObjectText( oPC, sScreenName, "EXPER_NEXT", -1, "Next: "+IntToString(nNextXP) );
	
	
	SetGUIObjectText( oPC, sScreenName, "EXPER_HITDICE", -1, sHitDice );
	SetGUIObjectText( oPC, sScreenName, "EXPER_OTHERLEVEL", -1, sHitDice );
	
	//SetGUITexture( oPC, sScreenName, "CHAR_ICON", sTexture );
	SetGUIObjectText( oPC, sScreenName, "TITLE", -1, GetName(oTarget) ); //GetFirstName(oTarget)+" "+GetLastName(oTarget) );
	SetGUIObjectText( oPC, sScreenName, "SUBRACE_TEXT", -1, CSLGetFullRaceName(oTarget) );
	
	SetGUIObjectText( oPC, sScreenName, "CHALLENGERATING_TEXT", -1, "Challenge Rating: "+CSLFormatFloat( CSLGetChallengeRating(oTarget) ) );
	
	string sActionMode = "Action Mode: "+CSLTargetActionModeToString( oTarget );
	
	string sActions = CSLActionToString( GetCurrentAction( oTarget ) );
	if ( sActions == "No Action" )
	{
		if ( GetLocalInt(oTarget, "CSL_CHATS_SENT" ) > 0 )
		{
			sActions = "Talking";
		}
	}	
	sActions = "Actions: "+sActions;
	int iNumActions = GetNumActions( oTarget );
	if ( iNumActions > 1 )
	{
		sActions += " of "+IntToString(iNumActions);
	}
	SetGUIObjectText( oPC, sScreenName, "ACTIONS_TEXT", -1, sActions );
	SetGUIObjectText( oPC, sScreenName, "ACTIONMODE_TEXT", -1, sActionMode );
	SetGUIObjectText( oPC, sScreenName, "FIRST_VALUE", -1, GetFirstName(oTarget) );
	SetGUIObjectText( oPC, sScreenName, "LAST_VALUE", -1, GetLastName(oTarget) );
	SetGUIObjectText( oPC, sScreenName, "ACCOUNT_VALUE", -1, GetPCPlayerName(oTarget) );
	
	if ( GetIsSinglePlayer() )
	{
		SetGUIObjectText( oPC, sScreenName, "CDKEY_VALUE", -1, "NA" );
		SetGUIObjectText( oPC, sScreenName, "IP_VALUE", -1, "Single Player" );
	}
	else
	{
		SetGUIObjectText( oPC, sScreenName, "CDKEY_VALUE", -1, GetPCPublicCDKey(oTarget) );
		SetGUIObjectText( oPC, sScreenName, "IP_VALUE", -1, GetPCIPAddress(oTarget) );
	}
	//SetGUITexture( oPC, sScreenName, "SUBRACE_ICON", sTexture );
	
	SetGUIObjectText( oPC, sScreenName, "ALIGNMENT_TEXT", -1, CSLGetAlignmentToString(CSLGetCreatureAlignment( oTarget ) )+"\n"+"Ethics: "+IntToString(GetLawChaosValue(oTarget))+" Moral: "+IntToString(GetGoodEvilValue(oTarget)) );
	SetGUITexture( oPC, sScreenName, "ALIGNMENT_ICON", CSLGetAlignmentToIcon( CSLGetCreatureAlignment( oTarget )  ) );
	//int ; 100 law // 0 chaotic
	//int ; 100 good // 0 evil
	//int iAlignmentGE = GetAlignmentGoodEvil(oCreature);
    //int iAlignmentLC = GetAlignmentLawChaos(oCreature);
	
	// look at weapons
	object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	if (!GetIsObjectValid(oRight) && (!GetIsPlayableRacialType(oTarget)) )
	{
		object oRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
	}
	
	string sModMainAttackDisplay = "";
	int iMainAttackMod = StringToInt( GetLocalString(oTarget,"CSL_MOD_ATTACK_1" ) );
	if ( iMainAttackMod > 0 )
	{ sModMainAttackDisplay = "<color=cyan>+"+IntToString( iMainAttackMod ) + "</color>"; }
	else if ( iMainAttackMod < 0 )
	{ sModMainAttackDisplay = "<color=red>-"+IntToString( iMainAttackMod ) + "</color>"; }
	
	
	string sModOffHandAttackDisplay = "";
	int iOffHandMod = StringToInt( GetLocalString(oTarget,"CSL_MOD_ATTACK_2" ) );
	if ( iOffHandMod > 0 )
	{ sModOffHandAttackDisplay = "<color=cyan>+"+IntToString( iOffHandMod ) + "</color>"; }
	else if ( iOffHandMod < 0 )
	{ sModOffHandAttackDisplay = "<color=red>-"+IntToString( iOffHandMod ) + "</color>"; }
	
	string sModDamageDisplay = "";
	int iDamageMod = StringToInt( GetLocalString(oTarget,"CSL_MOD_DAMAGE_3" ) );
	if ( iDamageMod > 0 )
	{ sModDamageDisplay = "<color=cyan>+"+IntToString( iDamageMod ) + "</color>"; }
	else if ( iDamageMod < 0 )
	{ sModDamageDisplay = "<color=red>-"+IntToString( iDamageMod ) + "</color>"; }
	
	string sAttackBonus = "";
	string sDamage = "";
	string sWeaponDescription = "Main Hand Weapon:";
	if ( CSLItemGetIsMeleeWeapon( oRight ) )
	{
		int iAB = CSLGetMaxAB(oTarget, oRight, GetAttackTarget(oTarget) );
		int nBaseItemType = GetBaseItemType(oRight); 
		int iBasedice = StringToInt(Get2DAString("baseitems", "DieToRoll", nBaseItemType));
		int iDiceNum = StringToInt(Get2DAString("baseitems", "NumDice", nBaseItemType));
		int iDamageBonus = 0;
		
		int iCriticalMultiplier = CSLGetCriticalMultiplier(oRight);
		int iCriticalRange = CSLGetCriticalRange(oRight);
		
		
		sWeaponDescription = GetName(oRight);
		if ( sWeaponDescription == ":" )
		{
			sWeaponDescription = "Main Hand Weapon:";
		}
		
		sAttackBonus = "+"+IntToString(iAB);
		iAB -= 5;
		while ( iAB > 0 )
		{
			sAttackBonus += "/+"+IntToString(iAB);
			iAB -= 5;
		}
		
		sDamage = "Damage: "+IntToString(iDiceNum)+"d"+IntToString(iBasedice);
		if ( iDamageBonus > 0 )
		{
			sDamage += " +"+IntToString(iDamageBonus);
		}
		else if ( iDamageBonus < 0 )
		{
			sDamage += " +"+IntToString(iDamageBonus);
		}
		
		sDamage += " (Critical: ";
		if ( iCriticalRange < 20 )
		{
			sDamage += IntToString(iCriticalRange)+"-20";
		}
		else
		{
			sDamage += "20";
		}
		sDamage += " ";
		if ( iCriticalMultiplier > 0 )
		{
			sDamage += "/ x"+IntToString(iCriticalMultiplier);
		}
		sDamage += ")";
	}
	
	
	SetGUIObjectText( oPC, sScreenName, "MAINHAND_TEXT", -1, sWeaponDescription+" (Approx.)" );
	SetGUIObjectText( oPC, sScreenName, "MAINHAND_ATTACK_TEXT", -1, "Attack Bonus: "+sAttackBonus );
	SetGUIObjectText( oPC, sScreenName, "MAINHAND_DAMAGE_TEXT", -1, "Damage: "+sDamage );
	SetGUIObjectText( oPC, sScreenName, "MAINHAND_ATTACK_MOD", -1, sModMainAttackDisplay );
	SetGUIObjectText( oPC, sScreenName, "MAINHAND_DAMAGE_MOD", -1, sModDamageDisplay );
	
	
	object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	if (!GetIsObjectValid(oLeft) && (!GetIsPlayableRacialType(oTarget)) )
	{
		object oLeft = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
	}
	
	if ( CSLItemGetIsMeleeWeapon( oLeft ) )
	{
		int iAB = CSLGetMaxAB(oTarget, oLeft, GetAttackTarget(oTarget) );
		int nBaseItemType = GetBaseItemType(oLeft); 
		int iBasedice = StringToInt(Get2DAString("baseitems", "DieToRoll", nBaseItemType));
		int iDiceNum = StringToInt(Get2DAString("baseitems", "NumDice", nBaseItemType));
		int iDamageBonus = 0;
		
		int iCriticalMultiplier = CSLGetCriticalMultiplier(oLeft);
		int iCriticalRange = CSLGetCriticalRange(oLeft);
		
		//
		sWeaponDescription = GetName(oLeft)+":";
		if ( sWeaponDescription == ":" )
		{
			sWeaponDescription = "Off Hand Weapon:";
		}
		sAttackBonus = "+"+IntToString(iAB);
		iAB -= 5;
		while ( iAB > 0 )
		{
			sAttackBonus += "/+"+IntToString(iAB);
			iAB -= 5;
		}
		
		sDamage = "Damage: "+IntToString(iDiceNum)+"d"+IntToString(iBasedice);
		if ( iDamageBonus > 0 )
		{
			sDamage += " +"+IntToString(iDamageBonus);
		}
		else if ( iDamageBonus < 0 )
		{
			sDamage += " +"+IntToString(iDamageBonus);
		}
		
		sDamage += " (Critical: ";
		if ( iCriticalRange < 20 )
		{
			sDamage += IntToString(iCriticalRange)+"-20";
		}
		else
		{
			sDamage += "20";
		}
		sDamage += " ";
		if ( iCriticalMultiplier > 0 )
		{
			sDamage += "/ x"+IntToString(iCriticalMultiplier);
		}
		sDamage += ")";
		
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_TEXT", -1, sWeaponDescription+" (Approx.)" );
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_ATTACK_TEXT", -1, "Attack Bonus: "+sAttackBonus );
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_DAMAGE_TEXT", -1, "Damage: "+sDamage );
		
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_ATTACK_MOD", -1, sModOffHandAttackDisplay );
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_DAMAGE_MOD", -1, sModDamageDisplay );
	}
	else
	{
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_TEXT", -1, "Off Hand Weapon:" );
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_ATTACK_TEXT", -1, "Attack Bonus: Not Applicable" );
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_DAMAGE_TEXT", -1, "Damage: Not Applicable" );
		
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_ATTACK_MOD", -1, sModOffHandAttackDisplay );
		SetGUIObjectText( oPC, sScreenName, "OFFHAND_DAMAGE_MOD", -1, sModDamageDisplay );
	}
	
		
	SetGUIObjectText( oPC, sScreenName, "BASEATTACK_TEXT", -1, "Base Attack Bonus "+IntToString( GetBaseAttackBonus(oTarget) ) );
	SetGUIObjectText( oPC, sScreenName, "DEITY_TEXT", -1, GetDeity(oTarget) );
	//SetGUITexture( oPC, sScreenName, "DEITY_ICON", sTexture );
	
	string sPackage = Get2DAString("packages", "Name", GetLevelUpPackage( oTarget ));
	if ( sPackage != "" )
	{
		sPackage = GetStringByStrRef( StringToInt(sPackage) );
	}

	SetGUIObjectText( oPC, sScreenName, "PACKAGE_TEXT", -1, "Package: "+sPackage );
	SetGUIObjectText( oPC, sScreenName, "DOMAINS_TEXT", -1, "Domains: "+sText );

	SetGUIObjectText( oPC, sScreenName, "SPELLRESIST_TEXT", -1, "Spell Resistance: "+IntToString( GetSpellResistance( oTarget ) )+"%" );
	SetGUIObjectText( oPC, sScreenName, "ARCANESPELLFAIL_TEXT", -1, "Arcane Spell Failure: "+IntToString( GetArcaneSpellFailure(oTarget) )+"%" );

	SetGUIObjectText(oPC, sScreenName, "TOT_GOLD", -1, IntToString(GetGold(oTarget)));
	
	SetGUIObjectText( oPC, sScreenName, "AC_PENALTY_TEXT", -1, "Armor Check Penalty: "+sText );
	SetGUIObjectText( oPC, sScreenName, "INFLUENCE_TEXT", -1, sText );
	// */
	string sStrDisplay, sStrModDisplay;
	int iBaseStr = CSLGetNaturalAbilityScore(oTarget, ABILITY_STRENGTH );
	int iCurrentStr = GetAbilityScore(oTarget, ABILITY_STRENGTH, FALSE);
	if ( iBaseStr == iCurrentStr )
	{ sStrDisplay = IntToString( iBaseStr );}
	else
	{ sStrDisplay = "<color=cyan>"+IntToString( iCurrentStr ) + "</color>/" +IntToString( iBaseStr );}
	int iModStr = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
	if ( iModStr > 0 )
	{ sStrModDisplay = "<color=cyan>+"+IntToString( iModStr ) + "</color>"; }
	else if ( iModStr < 0 )
	{ sStrModDisplay = "<color=red>-"+IntToString( iModStr ) + "</color>"; }
	else 
	{ sStrModDisplay = IntToString( iModStr ); }
	SetGUIObjectText( oPC, sScreenName, "STR_RANK", -1, sStrDisplay );
	SetGUIObjectText( oPC, sScreenName, "STR_MOD", -1, sStrModDisplay );
	
	string sDexDisplay, sDexModDisplay;
	int iBaseDex = CSLGetNaturalAbilityScore(oTarget, ABILITY_DEXTERITY );
	int iCurrentDex = GetAbilityScore(oTarget, ABILITY_DEXTERITY, FALSE);
	if ( iBaseDex == iCurrentDex )
	{ sDexDisplay = IntToString( iBaseDex );}
	else
	{ sDexDisplay = "<color=cyan>"+IntToString( iCurrentDex ) + "</color>/" +IntToString( iBaseDex );}	
	int iModDex = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
	if ( iModDex > 0 ){ sDexModDisplay = "<color=cyan>+"+IntToString( iModDex ) + "</color>"; }
	else if ( iModDex < 0 ){ sDexModDisplay = "<color=red>-"+IntToString( iModDex ) + "</color>"; }
	else { sDexModDisplay = IntToString( iModDex ); }
	SetGUIObjectText( oPC, sScreenName, "DEX_RANK", -1, sDexDisplay );
	SetGUIObjectText( oPC, sScreenName, "DEX_MOD", -1, sDexModDisplay );
	
	string sConDisplay, sConModDisplay;
	int iBaseCon = CSLGetNaturalAbilityScore(oTarget, ABILITY_CONSTITUTION );
	int iCurrentCon = GetAbilityScore(oTarget, ABILITY_CONSTITUTION, FALSE);
	if ( iBaseCon == iCurrentCon )
	{ sConDisplay = IntToString( iBaseCon );}
	else
	{ sConDisplay = "<color=cyan>"+IntToString( iCurrentCon ) + "</color>/" +IntToString( iBaseCon );}	
	int iModCon = GetAbilityModifier(ABILITY_CONSTITUTION, oTarget);
	if ( iModCon > 0 ){ sConModDisplay = "<color=cyan>+"+IntToString( iModCon ) + "</color>"; }
	else if ( iModCon < 0 ){ sConModDisplay = "<color=red>-"+IntToString( iModCon ) + "</color>"; }
	else { sConModDisplay = IntToString( iModCon ); }
	SetGUIObjectText( oPC, sScreenName, "CON_RANK", -1, sConDisplay );
	SetGUIObjectText( oPC, sScreenName, "CON_MOD", -1, sConModDisplay );
	
	string sIntDisplay, sIntModDisplay;
	int iBaseInt = CSLGetNaturalAbilityScore(oTarget, ABILITY_INTELLIGENCE );
	int iCurrentInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE, FALSE);
	if ( iBaseInt == iCurrentInt )
	{ sIntDisplay = IntToString( iBaseInt );}
	else
	{ sIntDisplay = "<color=cyan>"+IntToString( iCurrentInt ) + "</color>/" +IntToString( iBaseInt );}	
	int iModInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oTarget);
	if ( iModInt > 0 ){ sIntModDisplay = "<color=cyan>+"+IntToString( iModInt ) + "</color>"; }
	else if ( iModInt < 0 ){ sIntModDisplay = "<color=red>-"+IntToString( iModInt ) + "</color>"; }
	else { sIntModDisplay = IntToString( iModInt ); }
	SetGUIObjectText( oPC, sScreenName, "INT_RANK", -1, sIntDisplay );
	SetGUIObjectText( oPC, sScreenName, "INT_MOD", -1, sIntModDisplay );
	
	string sWisDisplay, sWisModDisplay;
	int iBaseWis = CSLGetNaturalAbilityScore(oTarget, ABILITY_WISDOM );
	int iCurrentWis = GetAbilityScore(oTarget, ABILITY_WISDOM, FALSE);
	if ( iBaseWis == iCurrentWis )
	{ sWisDisplay = IntToString( iBaseWis );}
	else
	{ sWisDisplay = "<color=cyan>"+IntToString( iCurrentWis ) + "</color>/" +IntToString( iBaseWis );}	
	int iModWis = GetAbilityModifier(ABILITY_WISDOM, oTarget);
	if ( iModWis > 0 ){ sWisModDisplay = "<color=cyan>+"+IntToString( iModWis ) + "</color>"; }
	else if ( iModWis < 0 ){ sWisModDisplay = "<color=red>-"+IntToString( iModWis ) + "</color>"; }
	else { sWisModDisplay = IntToString( iModWis ); }
	SetGUIObjectText( oPC, sScreenName, "WIS_RANK", -1, sWisDisplay );
	SetGUIObjectText( oPC, sScreenName, "WIS_MOD", -1, sWisModDisplay );
	
	string sChaDisplay, sChaModDisplay;
	int iBaseCha = CSLGetNaturalAbilityScore(oTarget, ABILITY_CHARISMA );
	int iCurrentCha = GetAbilityScore(oTarget, ABILITY_CHARISMA, FALSE);
	if ( iBaseCha == iCurrentCha )
	{ sChaDisplay = IntToString( iBaseCha );}
	else
	{ sChaDisplay = "<color=cyan>"+IntToString( iCurrentCha ) + "</color>/" +IntToString( iBaseCha );}	
	int iModCha = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
	if ( iModCha > 0 ){ sChaModDisplay = "<color=cyan>+"+IntToString( iModCha ) + "</color>"; }
	else if ( iModCha < 0 ){ sChaModDisplay = "<color=red>-"+IntToString( iModCha ) + "</color>"; }
	else { sChaModDisplay = IntToString( iModCha ); }
	SetGUIObjectText( oPC, sScreenName, "CHA_RANK", -1, sChaDisplay );
	SetGUIObjectText( oPC, sScreenName, "CHA_MOD", -1, sChaModDisplay );
	
	SetGUIObjectText( oPC, sScreenName, "FORT_SAVE", -1, IntToString( GetFortitudeSavingThrow( oTarget ) ) );
	
	SetGUIObjectText( oPC, sScreenName, "REF_SAVE", -1, IntToString( GetReflexSavingThrow( oTarget ) ) );
	
	SetGUIObjectText( oPC, sScreenName, "WILL_SAVE", -1, IntToString( GetWillSavingThrow( oTarget ) ) );
	
	SetGUIObjectText( oPC, sScreenName, "HP_RATIO", -1, IntToString( GetCurrentHitPoints( oTarget ))+"/"+IntToString( GetMaxHitPoints( oTarget )) );
	
	SetGUIObjectText( oPC, sScreenName, "ARMOR_CLASS", -1, IntToString( GetAC( oTarget )) );
	

	
	//SetGUITexture( oPC, sScreenName, HP_ICON, sTexture );
	//SetGUITexture( oPC, sScreenName, AC_ICON, sTexture );
	
	
	string sPosition = GetName(GetArea( oTarget ));
	vector lLocationVector = GetPosition(oTarget);
	sPosition += "\n("+CSLFormatFloat( (lLocationVector.x) ,1)+", "+CSLFormatFloat( (lLocationVector.y) ,1)+", "+CSLFormatFloat( (lLocationVector.z) ,1)+")";
	
	SetGUIObjectText( oPC, sScreenName, "MOVE_TEXT", -1, sPosition );
	
	// CLASS_PROTO
	SetGUIObjectText( oPC, sScreenName, "CLASS_TEXT", -1, CSLClassLevels(oTarget, FALSE, TRUE ) );
	
	//SetGUITexture( oPC, sScreenName, CLASS_ICON, sTexture );
	// CLASS_COL
	// CLASS_PROTO
	AddListBoxRow(oPC,sScreenName,"CLASS_COL","CLASS1","CSL_NAME=sName","","",""); // sTextures,sVariables,sHide
	
	// EFFECT_PROTO
	//SetGUIObjectText( oPC, sScreenName, EFFECT_TEXT, -1, sText );
	//SetGUITexture( oPC, sScreenName, EFFECT_ICON, sTexture );
	// */
	//SetGUIObjectText( oPC, sScreenName, "SCHOOL_TEXT", -1, "School:"+IntToString( GetCasterClassSpellSchool( oTarget, 1 ) ) );
	//SetGUITexture( oPC, sScreenName, "SCHOOL_ICON", sTexture );

	//SendMessageToPC( GetFirstPC(), "School:"+IntToString( GetCasterClassSpellSchool( GetFirstPC(), 1 ) ) );
	
	int iSpellSchool = GetLocalInt( oTarget, "SC_iSpellSchool");
	SetGUIObjectText( oPC, sScreenName, "SCHOOL_TEXT", -1, "School: "+CSLSchoolToString(iSpellSchool) );

	ClearListBox(oPC,sScreenName,"EFFECTLISTBOX");
	int iNumberOfEffects = 0; 
	//string sSpellList = "|";
	int iSpellId;
	int iEffectType, iEffectSubType, iEffectInteger;
	string sRow1, sRow2, sRowName,sFields,sTextures,sVariables,sHide;
	string sHandled = "|";
		
	effect eEffect = GetFirstEffect(oTarget);
	while ( GetIsEffectValid(eEffect) )
	{
		iNumberOfEffects++;
		iSpellId = GetEffectSpellId(eEffect);
		
		if  ( GetEffectType(eEffect) != EFFECT_TYPE_VISUALEFFECT )
		{
			sHandled += IntToString(iSpellId)+"|";
			
			SCCharEdit_Build_AddEffectListRow( eEffect );
		}
		eEffect = GetNextEffect(oTarget);
	}
	
	eEffect = GetFirstEffect(oTarget);
	while ( GetIsEffectValid(eEffect) )
	{
		iNumberOfEffects++;
		iSpellId = GetEffectSpellId(eEffect);
		
		if  ( GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT && FindSubString(sHandled, "|"+IntToString(iSpellId)+"|") == -1 )
		{
			SCCharEdit_Build_AddEffectListRow( eEffect );
		}
		eEffect = GetNextEffect(oTarget);
	}

	/* Dm Inventory */
	SetGUIObjectText(oPC, sScreenName, "RADIAL_EXAMINE", -1, "Examine");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_TAKE", -1, "Take");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_EQUIP_1", -1, "Equip Slot 1");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_EQUIP_2", -1, "Equip Slot 2");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_EQUIP_3", -1, "Equip Slot 3");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_LOCAL_VAR", -1, "Edit Loc. Variables");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_IDENTIFIED", -1, "Identified ON/OFF");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_PLOT", -1, "Plot ON/OFF");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_CURSED", -1, "Cursed ON/OFF");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_STOLEN", -1, "Stolen ON/OFF");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_DROPPABLE", -1, "Droppable ON/OFF");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_EXAMINE_EQUIPMENT", -1, "Examine");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_TAKE_EQUIPMENT", -1, "Take");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_UNEQUIP", -1, "Unequip");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_LOCAL_VAR_EQUIPMENT", -1, "Edit Loc. Variables");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_PLOT_EQUIPMENT", -1, "Plot ON/OFF");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_CURSED_EQUIPMENT", -1, "Cursed ON/OFF");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_STOLEN_EQUIPMENT", -1, "Stolen ON/OFF");
	SetGUIObjectText(oPC, sScreenName, "RADIAL_DROPPABLE_EQUIPMENT", -1, "Droppable ON/OFF");
	
	// Tooltips
	SetLocalGUIVariable(oPC, sScreenName, 1101, "Gold Pieces");
	SetLocalGUIVariable(oPC, sScreenName, 1102, "Encumbrance");
	
	SCCharEdit_Build_SkillsListBox( oTarget, oPC, CSL_LISTBOXROW_MODIFY, sScreenName );
	
}


void SCCharEdit_Display( object oTargetToDisplay, object oPC = OBJECT_SELF, string sScreenName = SCREEN_CHARACTEREDIT )
{
	if ( !GetIsObjectValid( oTargetToDisplay) )
	{
		CloseGUIScreen( oPC,sScreenName );
		return;
	}

	//CSLDMVariable_SetLvmTarget(oPCToShowVars, oTargetToDisplay);
	DisplayGuiScreen(oPC, sScreenName, FALSE, XML_CHARACTEREDIT);
	//CSLDMVariable_InitTargetVarRepository (oPCToShowVars, oTargetToDisplay);
	SCCacheStats( oTargetToDisplay );
	DelayCommand( 0.5, SCCharEdit_Build( oTargetToDisplay, oPC, sScreenName ) );
}




/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_HideInventoryTabs(object oSubject,string sScreenName = SCREEN_CHARACTEREDIT)
{
	SetGUIObjectHidden(oSubject, sScreenName, "INVENTORY_ARMORS_TAB", TRUE);
	SetGUIObjectHidden(oSubject, sScreenName, "INVENTORY_USABLES_TAB", TRUE);
	SetGUIObjectHidden(oSubject, sScreenName, "INVENTORY_MAGIC_OBJS_TAB", TRUE);
	SetGUIObjectHidden(oSubject, sScreenName, "INVENTORY_MISCS_TAB", TRUE);
	SetGUIObjectHidden(oSubject, sScreenName, "INVENTORY_WEAPONS_TAB", TRUE);
}


/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
string SCCharEdit_GetListBoxNameByItemType (int iBaseItemType) {

	string sListBox = "";
	
	switch (iBaseItemType) {
		case BASE_ITEM_ARMOR:
		case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_SMALLSHIELD:
		case BASE_ITEM_TOWERSHIELD:
		case BASE_ITEM_HELMET:
		case BASE_ITEM_BELT:
		case BASE_ITEM_BOOTS:
		case BASE_ITEM_GLOVES:
		case BASE_ITEM_CREATUREITEM:
		case BASE_ITEM_BRACER:
		case BASE_ITEM_CLOAK:
			sListBox = "INVENTORY_ARMORS_LIST";	break;
		
		case BASE_ITEM_POTIONS:
		case BASE_ITEM_SPELLSCROLL:
		case BASE_ITEM_BLANK_POTION:
		case BASE_ITEM_ENCHANTED_POTION:
		case BASE_ITEM_ENCHANTED_SCROLL:
			sListBox = "INVENTORY_USABLES_LIST";	break;
		
		case BASE_ITEM_AMULET:
		case BASE_ITEM_MAGICROD:
		case BASE_ITEM_MAGICSTAFF:
		case BASE_ITEM_MAGICWAND:
		case BASE_ITEM_RING:
		case BASE_ITEM_BLANK_WAND:
		case BASE_ITEM_ENCHANTED_WAND:
			sListBox = "INVENTORY_MAGIC_OBJS_LIST"; break;

		case BASE_ITEM_TORCH:
		case BASE_ITEM_MISCSMALL:
		case BASE_ITEM_MISCMEDIUM:
		case BASE_ITEM_MISCLARGE:
		case BASE_ITEM_HEALERSKIT:
		case BASE_ITEM_THIEVESTOOLS:
		case BASE_ITEM_TRAPKIT:
		case BASE_ITEM_KEY:
		case BASE_ITEM_LARGEBOX:
		case BASE_ITEM_BOOK:
		case BASE_ITEM_GOLD:
		case BASE_ITEM_GEM:
		case BASE_ITEM_MISCTHIN:
		case BASE_ITEM_GRENADE:
		case BASE_ITEM_CRAFTMATERIALMED:
		case BASE_ITEM_CRAFTMATERIALSML:
		case BASE_ITEM_DRUM:
		case BASE_ITEM_FLUTE:
		case BASE_ITEM_MANDOLIN:
			sListBox = "INVENTORY_MISCS_LIST";	break;
			
		default:
			sListBox = "INVENTORY_WEAPONS_LIST";	break;					
	}
	
	return sListBox;
}


/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
string SCCharEdit_GetTabNameByItemType(int iBaseItemType )
{
	string sPane = "";
	
	switch (iBaseItemType)
	{
		case BASE_ITEM_ARMOR:
		case BASE_ITEM_LARGESHIELD:
		case BASE_ITEM_SMALLSHIELD:
		case BASE_ITEM_TOWERSHIELD:
		case BASE_ITEM_HELMET:
		case BASE_ITEM_BELT:
		case BASE_ITEM_BOOTS:
		case BASE_ITEM_GLOVES:
		case BASE_ITEM_CREATUREITEM:
		case BASE_ITEM_BRACER:
		case BASE_ITEM_CLOAK:
			sPane = "INVENTORY_ARMORS_TAB";
			break;
		
		case BASE_ITEM_POTIONS:
		case BASE_ITEM_SPELLSCROLL:
		case BASE_ITEM_BLANK_POTION:
		case BASE_ITEM_ENCHANTED_POTION:
		case BASE_ITEM_ENCHANTED_SCROLL:
			sPane = "INVENTORY_USABLES_TAB";
			break;
		
		case BASE_ITEM_AMULET:
		case BASE_ITEM_MAGICROD:
		case BASE_ITEM_MAGICSTAFF:
		case BASE_ITEM_MAGICWAND:
		case BASE_ITEM_RING:
		case BASE_ITEM_BLANK_WAND:
		case BASE_ITEM_ENCHANTED_WAND:
			sPane = "INVENTORY_MAGIC_OBJS_TAB";
			break;

		case BASE_ITEM_TORCH:
		case BASE_ITEM_MISCSMALL:
		case BASE_ITEM_MISCMEDIUM:
		case BASE_ITEM_MISCLARGE:
		case BASE_ITEM_HEALERSKIT:
		case BASE_ITEM_THIEVESTOOLS:
		case BASE_ITEM_TRAPKIT:
		case BASE_ITEM_KEY:
		case BASE_ITEM_LARGEBOX:
		case BASE_ITEM_BOOK:
		case BASE_ITEM_GOLD:
		case BASE_ITEM_GEM:
		case BASE_ITEM_MISCTHIN:
		case BASE_ITEM_GRENADE:
		case BASE_ITEM_CRAFTMATERIALMED:
		case BASE_ITEM_CRAFTMATERIALSML:
		case BASE_ITEM_DRUM:
		case BASE_ITEM_FLUTE:
		case BASE_ITEM_MANDOLIN:
			sPane = "INVENTORY_MISCS_TAB";
			break;
			
		default:
			sPane = "INVENTORY_WEAPONS_TAB";
			break;					
	}
	
	return sPane;
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_SelectInvenListBoxItem (object oSubject, object oItem,string sScreenName = SCREEN_CHARACTEREDIT)
{
	string sListBoxName =  SCCharEdit_GetListBoxNameByItemType(GetBaseItemType(oItem));
	string sObjectId = IntToString(ObjectToInt(oItem));
	int iBaseItemType = GetBaseItemType(oItem);
	
	SCCharEdit_HideInventoryTabs (oSubject, sScreenName);
	SetGUIObjectHidden(oSubject, sScreenName, "PANE_INVENTORY_RADIAL", FALSE);
	SetGUIObjectHidden(oSubject, sScreenName,  SCCharEdit_GetTabNameByItemType (iBaseItemType), FALSE);
	SetListBoxRowSelected(oSubject, sScreenName, sListBoxName, "Item_" + sObjectId);
}




/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_SetPimTarget(object oSubject, object oTarget)
{
	if (GetIsObjectValid(oTarget))
	{
		SetLocalObject(oSubject, "WAND_PIM_TARGET", oTarget);
	}
	else
	{
		DeleteLocalObject(oSubject, "WAND_PIM_TARGET");
	}
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
object SCCharEdit_GetPimTarget(object oSubject)
{
	return GetLocalObject(oSubject, "WAND_PIM_TARGET");	
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_ResetInventoryListboxes (object oSubject,string sScreenName = SCREEN_CHARACTEREDIT)
{

	ClearListBox(oSubject, sScreenName, "INVENTORY_ARMORS_LIST");
	ClearListBox(oSubject, sScreenName, "INVENTORY_WEAPONS_LIST");
	ClearListBox(oSubject, sScreenName, "INVENTORY_USABLES_LIST");
	ClearListBox(oSubject, sScreenName, "INVENTORY_MAGIC_OBJS_LIST");
	ClearListBox(oSubject, sScreenName, "INVENTORY_MISCS_LIST");
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
string SCCharEdit_GetEquippedItemTooltip(object oItem)
{

	string sName = GetName(oItem);
	int iNameLength = GetStringLength(sName);
	
	if (iNameLength < WAND_MIN_EQ_ITEM_NAME_LENGTH)
	{		
		string sPaddingSpace = "                 ";
		int iPadding = (WAND_MIN_EQ_ITEM_NAME_LENGTH - iNameLength)/2 + 1;
		sPaddingSpace = GetStringLeft(sPaddingSpace, iPadding);
		sName = sPaddingSpace + sName + sPaddingSpace;
	}
	
	string sTooltip = "<b>" + sName + "</b>";
	sTooltip += "\n\n";
	sTooltip += "<i>Value</i>: " + IntToString(GetGoldPieceValue(oItem));
	sTooltip += "\n\n";
	sTooltip += "<i>Cursed</i>: ";
	sTooltip += (GetItemCursedFlag(oItem)) ? "YES" : "NO";
	sTooltip += "\n";
	sTooltip += "<i>Plot</i>: ";
	sTooltip += (GetPlotFlag(oItem)) ? "YES" : "NO";
	sTooltip += "\n";
	sTooltip += "<i>Stolen</i>: ";
	sTooltip += (GetStolenFlag(oItem)) ? "YES" : "NO";
	sTooltip += "\n";
	sTooltip += "<i>Droppable</i>: ";
	sTooltip += (GetDroppableFlag(oItem)) ? "YES" : "NO";
	
	return sTooltip;
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
string SCCharEdit_GetInventoryAndEquipmentValueTooltip (int iEquipmentValue, int iInventoryValue)
{
	
	string sTooltip = "<b>Total Inventory Value</b>";
	int iTooltipLength = GetStringLength(sTooltip);
	
	if (iTooltipLength < WAND_INV_AND_EQ_VALUE_LENGTH)
	{		
		string sPaddingSpace = "                 ";
		int iPadding = (WAND_INV_AND_EQ_VALUE_LENGTH - iTooltipLength)/2 + 1;
		sPaddingSpace = GetStringLeft(sPaddingSpace, iPadding);
		sTooltip = sPaddingSpace + sTooltip + sPaddingSpace;
	}
	
	sTooltip += "\n\n";
	sTooltip += "<i>Equipment</i>: " + IntToString(iEquipmentValue);
	sTooltip += "\n";
	sTooltip += "<i>Backpack</i>: " + IntToString(iInventoryValue);
	return sTooltip;
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_AddEquippedItem (object oSubject, int iSlot, object oItem,string sScreenName = SCREEN_CHARACTEREDIT)
{
	//SetGUIObjectHidden(oSubject, sScreenName, "SLOT_TEXTURE_" + IntToString(iSlot), FALSE);
	if (!GetIsObjectValid(oItem))
	{
		SetLocalGUIVariable(oSubject, sScreenName, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, "");
		SetLocalGUIVariable(oSubject, sScreenName, WAND_PIM_SLOT_OFFSET + iSlot, "-1");
		SetGUITexture(oSubject, sScreenName, "SLOT_TEXTURE_" + IntToString(iSlot),"");
		SetGUIObjectDisabled(oSubject, sScreenName, "SLOT_TEXTURE_" + IntToString(iSlot), TRUE);
		return;
	}
	
	
	string sItemIcon = CSLGetItemIconImage(oItem);
	/*
	switch (GetBaseItemType(oItem)) 
	{
		case BASE_ITEM_CBLUDGWEAPON:
		case BASE_ITEM_CPIERCWEAPON:
		case BASE_ITEM_CSLSHPRCWEAP:
			sItemIcon = "i_claw.tga";
			break;
		case BASE_ITEM_CSLASHWEAPON:
			sItemIcon = "i_bite.tga";
			break;
		case BASE_ITEM_CREATUREITEM:
			sItemIcon = "i_hide.tga";
			break;
		default:
			sItemIcon = CSLGetItemIconImage(oItem);
			break;
	}
	*/ 
	
	SetGUIObjectDisabled(oSubject, sScreenName, "SLOT_TEXTURE_" + IntToString(iSlot), FALSE);	
	SetGUITexture(oSubject, sScreenName, "SLOT_TEXTURE_" + IntToString(iSlot), sItemIcon);
	SetLocalGUIVariable(oSubject, sScreenName, WAND_PIM_SLOT_OFFSET + iSlot, IntToString(ObjectToInt(oItem)));
	SetLocalGUIVariable(oSubject, sScreenName, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, SCCharEdit_GetEquippedItemTooltip (oItem));
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_RemoveEquippedItem (object oSubject, int iSlot,string sScreenName = SCREEN_CHARACTEREDIT)
{
	SetGUIObjectHidden(oSubject, sScreenName, "SLOT_TEXTURE_" + IntToString(iSlot), FALSE);
	SetLocalGUIVariable(oSubject, sScreenName, WAND_PIM_SLOT_OFFSET + iSlot, "-1");
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_AddItem (object oUiOwner, object oItem, string sScreenName = SCREEN_CHARACTEREDIT)
{

	string sTexts, sTextures, sVariables, sHideUnhide;
	int iBaseItemType = GetBaseItemType(oItem);
	int iItemValue = GetGoldPieceValue(oItem);
	string sObjectId = IntToString(ObjectToInt(oItem));
	object oTarget = SCCharEdit_GetPimTarget(oUiOwner);	
	string sListBox = SCCharEdit_GetListBoxNameByItemType (iBaseItemType);

	sTexts = "ITEM_TEXT=" + CSLTruncate(GetName(oItem), WAND_MAX_ITEM_NAME_LENGTH);
	
	// Indico la quantità se l'oggetto è impilato
   	sTexts += (GetItemStackSize(oItem) > 1) 
		? " ("+IntToString(GetItemStackSize(oItem))+");"
		: ";";
		
	sTexts += "ITEM_VALUE=" + IntToString(iItemValue)+ "  ;";
	
	sTextures = "ITEM_ICON=" + CSLGetItemIconImage(oItem);
	
	sVariables = "0=" + sObjectId;
	
	sHideUnhide += "NOT_IDENTIFIED_ICON="; 
	sHideUnhide += (GetIdentified(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_PLOT_ICON="; 
	sHideUnhide += (GetPlotFlag(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_CURSED_ICON="; 
	sHideUnhide += (GetItemCursedFlag(oItem)) 
		? "hide;"
		: "unhide;";
	sHideUnhide += "NOT_STOLEN_ICON="; 
	sHideUnhide += (GetStolenFlag(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_DROPPABLE_ICON="; 
	sHideUnhide += (GetDroppableFlag(oItem)) 
		? "hide;"
		: "unhide;";
	sHideUnhide +=	"LEVEL_RESTRICTED_ICON=";
	sHideUnhide += (iItemValue <= StringToInt(Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", GetHitDice(oTarget) - 1)))
		? "hide;"
		: "unhide;";				
	AddListBoxRow(oUiOwner, sScreenName, sListBox, "Item_" + sObjectId, sTexts, sTextures, sVariables, sHideUnhide);

}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_ModifyItem(object oUiOwner, object oItem,string sScreenName = SCREEN_CHARACTEREDIT)
{
	string sTexts, sVariables, sHideUnhide, sTextures;
	int iBaseItemType = GetBaseItemType(oItem);
	string sObjectId = IntToString(ObjectToInt(oItem));
	object oTarget = SCCharEdit_GetPimTarget(oUiOwner);
	int iItemValue = GetGoldPieceValue(oItem);
	string sListBox = SCCharEdit_GetListBoxNameByItemType (iBaseItemType);

	sTexts = "ITEM_TEXT=" + CSLTruncate(GetName(oItem), WAND_MAX_ITEM_NAME_LENGTH);
	
	// Indico la quantità se l'oggetto è impilato
   	sTexts += (GetItemStackSize(oItem) > 1) 
		? " ("+IntToString(GetItemStackSize(oItem))+");"
		: ";";
		
	sTexts += "ITEM_VALUE=" + IntToString(GetGoldPieceValue(oItem))+ "  ;";
	
	sTextures = "ITEM_ICON=" + CSLGetItemIconImage(oItem);
	
	sVariables = "0=" + sObjectId;
	
	sHideUnhide += "NOT_IDENTIFIED_ICON="; 
	sHideUnhide += (GetIdentified(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_PLOT_ICON="; 
	sHideUnhide += (GetPlotFlag(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_CURSED_ICON="; 
	sHideUnhide += (GetItemCursedFlag(oItem)) 
		? "hide;"
		: "unhide;";
	sHideUnhide += "NOT_STOLEN_ICON="; 
	sHideUnhide += (GetStolenFlag(oItem)) 
		? "hide;"
		: "unhide;";	
	sHideUnhide += "NOT_DROPPABLE_ICON="; 
	sHideUnhide += (GetDroppableFlag(oItem)) 
		? "hide;"
		: "unhide;";
	sHideUnhide +=	"LEVEL_RESTRICTED_ICON=";
	sHideUnhide += (iItemValue <= StringToInt(Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", GetHitDice(oTarget) - 1)))
		? "hide;"
		: "unhide;";
				
	ModifyListBoxRow(oUiOwner, sScreenName, sListBox, "Item_" + sObjectId, sTexts, sTextures, sVariables, sHideUnhide);

}



/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
struct structSCInvenGlobalValues SCCharEdit_InitTargetInventory(object oSubject, object oTarget)
{

    object oItem = GetFirstItemInInventory(oTarget);
	struct structSCInvenGlobalValues sigvStruct;
    int iIndex;
	
	while (GetIsObjectValid(oItem))
	{
		SCCharEdit_AddItem(oSubject, oItem);
		sigvStruct.iTotWeight += GetWeight(oItem);
		sigvStruct.iTotValue += GetGoldPieceValue(oItem);
		oItem = GetNextItemInInventory(oTarget);
    }

	return sigvStruct;
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
struct structSCInvenGlobalValues SCCharEdit_InitTargetEquipment (object oSubject, object oTarget)
{
    
    int iIndex;
	object oItem;
	struct structSCInvenGlobalValues sigvStruct;
			
	for (iIndex = 0; iIndex < NUM_INVENTORY_SLOTS; iIndex++) {
		
		oItem = GetItemInSlot(iIndex, oTarget);

		SCCharEdit_AddEquippedItem (oSubject, iIndex, oItem);	
		
		sigvStruct.iTotWeight += GetWeight(oItem);
		sigvStruct.iTotValue += GetGoldPieceValue(oItem);
    }
	
	return sigvStruct;
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_DisplayInventory (object oSubject, object oTarget,string sScreenName = SCREEN_CHARACTEREDIT )
{
	SCCharEdit_ResetInventoryListboxes (oSubject,sScreenName);

	struct structSCInvenGlobalValues sigvStructEquip = SCCharEdit_InitTargetEquipment(oSubject, oTarget);
	struct structSCInvenGlobalValues sigvStructInv = SCCharEdit_InitTargetInventory(oSubject, oTarget);
	string sEncumbrance;
	int iStrength = GetAbilityScore(oTarget, ABILITY_STRENGTH);
	int iStateNormal = StringToInt(Get2DAString("encumbrance", "Normal", iStrength));
	int iStateHeavy = StringToInt(Get2DAString("encumbrance", "Heavy", iStrength));
	int iTotWeight = sigvStructEquip.iTotWeight + sigvStructInv.iTotWeight;

	if (iTotWeight > iStateHeavy)
	{
		sEncumbrance = "<color=red>";
	}
	else if (iTotWeight > iStateNormal)
	{
		sEncumbrance = "<color=yellow>";
	}
	else
	{
		sEncumbrance = "<color=white>";
	}
	
	sEncumbrance += IntToString(iTotWeight/10); 
	sEncumbrance += "/";
	sEncumbrance += IntToString(iStateHeavy/10);
	sEncumbrance += "</color>";
	
	SetGUIObjectText(oSubject, sScreenName, "TOT_INVENTORY_VALUE", -1, IntToString(sigvStructEquip.iTotValue + sigvStructInv.iTotValue));
	SetGUIObjectText(oSubject, sScreenName, "TOT_GOLD", -1, IntToString(GetGold(oTarget)));
	SetGUIObjectText(oSubject, sScreenName, "ENCUMBRANCE", -1, sEncumbrance);
	SetLocalGUIVariable(oSubject, sScreenName, 1100, SCCharEdit_GetInventoryAndEquipmentValueTooltip(sigvStructEquip.iTotValue, sigvStructInv.iTotValue));	
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_ResetListBoxesSelection (object oSubject,string sScreenName = SCREEN_CHARACTEREDIT)
{
	SetListBoxRowSelected(oSubject, sScreenName, "INVENTORY_ARMORS_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, sScreenName, "INVENTORY_WEAPONS_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, sScreenName, "INVENTORY_USABLES_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, sScreenName, "INVENTORY_MAGIC_OBJS_LIST", "HIDDEN_ROW");
	SetListBoxRowSelected(oSubject, sScreenName, "INVENTORY_MISCS_LIST", "HIDDEN_ROW");	
}

/*********************************************************************/
/*********************************************************************/
// written by caos as part of dm inventory system, integrating
void SCCharEdit_UpdateInventoryValue (object oSubject, object oTarget,string sScreenName = SCREEN_CHARACTEREDIT) {
    int iIndex, iValueEquipment = 0;
	object oItem;
			
	for (iIndex = 0; iIndex < NUM_INVENTORY_SLOTS; iIndex++)
	{
		oItem = GetItemInSlot(iIndex, oTarget);
		iValueEquipment += GetGoldPieceValue(oItem);
    }
	
	int iValueInventory = 0;
	oItem = GetFirstItemInInventory(oTarget);
	
	while (GetIsObjectValid(oItem))
	{
		iValueInventory += GetGoldPieceValue(oItem);
        oItem = GetNextItemInInventory(oTarget);
    }
	
	SetGUIObjectText(oSubject, sScreenName, "TOT_INVENTORY_VALUE", -1, IntToString(iValueEquipment + iValueInventory));
	SetLocalGUIVariable(oSubject, sScreenName, 1100, SCCharEdit_GetInventoryAndEquipmentValueTooltip(iValueEquipment, iValueInventory));	
}
//void main () {}


// written by caos as part of dm inventory system, integrating
void SCCharEdit_CheckActionResult (object oSubject, object oTarget, object oEquippedItem, int iSlot,string sScreenName = SCREEN_CHARACTEREDIT )
{
	if (GetItemInSlot(iSlot, oTarget) != oEquippedItem)
	{
		SCCharEdit_SelectInvenListBoxItem (oSubject, oEquippedItem, sScreenName);
		DisplayMessageBox(oSubject, -1, "An error occurred while equipping the item.\nIt's possible that the target doesn't have the requirements to equip the selected item.");
	}
	else
	{
		string sItemName = GetName(oEquippedItem);
		
		SetGUIObjectHidden(oSubject, sScreenName, "PANE_INVENTORY_RADIAL_EQUIP", FALSE);
		SetGUIObjectHidden(oSubject, sScreenName, "SLOT_TEXTURE_"+IntToString(iSlot)+"_OVERLAY", FALSE);
		SetGUIObjectText(oSubject, sScreenName, "SELECTED_ITEM_NAME", -1, sItemName);	
	}
}

// written by caos as part of dm inventory system, integrating
void SCCharEdit_GiveItem (object oSubject, object oTarget)
{
	object oNewItem, oItem = SCCharEdit_GetLastDraggedItem (oSubject);

	oNewItem = CopyItem(oItem, oTarget, TRUE);
	
	DestroyObject(oItem, 0.0);	
	
	SCCharEdit_ResetInventoryListboxes(oSubject);	
	DelayCommand(0.1, SCCharEdit_DisplayInventory (oSubject, oTarget));	
}
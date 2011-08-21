/** @file
* @brief Include file for custom classes
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_HkSpell"
#include "_CSLCore_Items"
//#include "cmi_includes"
//#include "_SCInclude_sneakattack"


int isDeadlyDefenseValid(object oPartyMember);
int IsTwoWeaponValid(object oPartyMember);

/////////////////////////
/// Immunity only message
/////////////////////////
/*
void SendMessageToCasterAndTarget( object oTarget, object oCaster, string sMessage );

// this can all be moved to a central include file later, or to bottom of file since prototype is above
void SendMessageToCasterAndTarget( object oTarget, object oCaster, string sMessage )
{
	SendMessageToPC(oTarget, sMessage );
	if ( oCaster != oTarget )
	{
		SendMessageToPC(oCaster, sMessage );
	}
}
*/
/////////////////////////
/// end Immunity messages
/////////////////////////


/* this is not needed since i have my own system to handle this */
int GetPrestigeCasterLevelByClassLevel(int nClass, int nClassLevel, object oTarget)
{
	
	if (nClass == CLASS_BLACK_FLAME_ZEALOT)
		return nClassLevel / 2;
		
	if (nClass == CLASS_FOREST_MASTER || nClass == CLASS_TYPE_SACREDFIST || nClass == CLASS_SHADOWBANE_STALKER)
	{
		//1, 2, 3, 5, 6, 7, 9, and 10
		return (nClassLevel + 1) * 3/4;
	}
	
	if (nClass == CLASS_SWIFTBLADE)
	{
		//2, 3, 5, 6, 8, and 9
		if (nClassLevel < 4)
			return nClassLevel - 1;
		else
		if (nClassLevel < 7)
			return nClassLevel - 2;
		else
		if (nClassLevel < 10)
			return nClassLevel - 3;
		else 
			return nClassLevel - 4;	
	}
	
	if (nClass == CLASS_HOSPITALER)
	{
		//2, 3, 4, 6, 7, 8, and 10	
		if (nClassLevel < 5)
			return nClassLevel - 1;
		else
		if (nClassLevel < 9)
			return nClassLevel - 2;
		else
			return nClassLevel - 3;	
	}	
	
	
	return 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Single Immunity Only Nerf - only works for last version cast, previous spells cast will be removed soas to only allow one immunity /
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int IsMWM_BValid( object oPC = OBJECT_SELF )
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC );	
	if	(CSLItemGetIsBludgeoningWeapon(oWeapon) && CSLItemGetIsMeleeWeapon(oWeapon) )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

int IsMWM_PValid( object oPC = OBJECT_SELF )
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC );	
	if	(CSLItemGetIsPiercingWeapon(oWeapon) && CSLItemGetIsMeleeWeapon(oWeapon)  )
	{
		return TRUE;
	}
	else
	{		
		return FALSE;
	}
}

int IsMWM_SValid( object oPC = OBJECT_SELF )
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC );	
	if	(CSLItemGetIsSlashingWeapon(oWeapon) && CSLItemGetIsMeleeWeapon(oWeapon) )
	{
		//
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);	
		if ( GetIsObjectValid(oWeapon) && CSLItemGetIsMeleeWeapon(oWeapon) ) // makes sure if two weapons that both are slashing
		{
			if ( !CSLItemGetIsSlashingWeapon(oWeapon) )
			{
				return FALSE; // his second weapon is not a slashing weapon
			}
		}
		return TRUE; // he only has slashing weapons
	}
	else
	{
		
		return FALSE;
		
	}
	
}


int isValidIntuitiveAttackWeapon(object oWpn)
{
	if	(GetIsObjectValid(oWpn))
	{
		int iBaseItemType = GetBaseItemType(oWpn);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_INTUITIVEATTACK )
		{
			return TRUE;
		}
	}
	return FALSE;
}

int IsIntuitiveAttackValid()
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oWeapon2    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
	
	int bWpn1Valid = FALSE;	
	int bWpn2Valid = FALSE;
	int bMain = FALSE;
	int bOffhand = FALSE;
	
	if	(GetIsObjectValid(oWeapon))
	{
		bWpn1Valid = TRUE;
		if (isValidIntuitiveAttackWeapon(oWeapon))
		{
			bMain = TRUE;
		}	
	}
	
	if	(GetIsObjectValid(oWeapon2))
	{
		bWpn2Valid = TRUE;
		if (isValidIntuitiveAttackWeapon(oWeapon2))
		{
			bOffhand = TRUE;
		}	
		if (!CSLItemGetIsMeleeWeapon(oWeapon2)) //Not a weapon, so it's ok
		{
			bWpn2Valid = FALSE;
		}
	}
	
	//Return Codes
	//0 FALSE
	//1 Character Bonus
	//2 Mainhand Only
	//3 Offhand Only
	
	if (bWpn1Valid == TRUE)
	{
		if (bMain)
		{
			if (bWpn2Valid && bOffhand) //Good main, good off
			{
				return 1;
			}
			else if (bWpn2Valid && !bOffhand) //Good main, bad off
			{
				//return 2;
				return FALSE;
			}
			else
			{
				return 1; //Good main, no off
			}
		}
		else
		{
			if (bWpn2Valid && bOffhand) //Bad main, good off
			{
				//return 3;
				return FALSE; //Nothing valid equipped
				
			}
			else
			{
				return FALSE; //Nothing valid equipped
			}
		}
	}
	else
	{
			return 1; //Unarmed, which is valid
	}

				
}

void DelayedDmgResFixApplication(object oPC, effect eEffect)
{
	if (GetHasSpellEffect(DMGRES_FIX,oPC))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, DMGRES_FIX );
	}
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
}

void ApplyDmgResFix(object oPC, int nEquip)
{	
    int nCostTableResRef;
	int nDR = 0;
	int nDRType = 0;
	object oItem;
    object oItemBelt = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
		
	if (nEquip)
	{
		oItem = GetPCItemLastEquipped();
	}
	else
	{
		oItem = GetPCItemLastUnequipped();
	}
		
	if(GetIsObjectValid(oItem) && oItem == oItemBelt)
	{
		if (GetHasSpellEffect(DMGRES_FIX,oPC))
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, DMGRES_FIX );
		}	
		if (nEquip)
		{
			itemproperty iProp = GetFirstItemProperty(oItem);
			while (GetIsItemPropertyValid(iProp))
			{
				nCostTableResRef = GetItemPropertyCostTable(iProp);
				if (nCostTableResRef == 7) //IPRP_RESISTCOST
				{
					int nVal;
					nVal = GetItemPropertyCostTableValue(iProp); //Resist Amount, 5/- * nVal
					if (nVal > 0)
					{
						nDR = nVal * 5;
						nVal = GetItemPropertySubType(iProp); //Damage Type, IPRP_DamageType or Toolset Consts
						if (nVal == IP_CONST_DAMAGETYPE_BLUDGEONING)
						{
							nDRType = IP_CONST_DAMAGETYPE_BLUDGEONING;
							SendMessageToPC(GetFirstPC(), "IP_CONST_DAMAGETYPE_BLUDGEONING");
						}
						else
						if (nVal == IP_CONST_DAMAGETYPE_SLASHING)
						{
							nDRType = IP_CONST_DAMAGETYPE_SLASHING;
							SendMessageToPC(GetFirstPC(), "IP_CONST_DAMAGETYPE_SLASHING");
						}
						else
						if (nVal == IP_CONST_DAMAGETYPE_PIERCING)
						{
							nDRType = IP_CONST_DAMAGETYPE_PIERCING;
							SendMessageToPC(GetFirstPC(), "IP_CONST_DAMAGETYPE_PIERCING");
						}
						else
							nDR = 0;										
					}
				}
				/*
				if (nCostTableResRef == 11) //iprp_srcost
				{
					int nVal;
					nVal = GetItemPropertyCostTable(iProp);
					SendMessageToPC(GetFirstPC(), "GetItemPropertyCostTable " + IntToString(nVal));
					nVal = GetItemPropertyCostTableValue(iProp);
					SendMessageToPC(GetFirstPC(), "GetItemPropertyCostTableValue " + IntToString(nVal));
					nVal = GetItemPropertyParam1(iProp);
					SendMessageToPC(GetFirstPC(), "GetItemPropertyParam1 " + IntToString(nVal));
					nVal = GetItemPropertyParam1Value(iProp);
					SendMessageToPC(GetFirstPC(), "GetItemPropertyParam1Value " + IntToString(nVal));
					nVal = GetItemPropertySubType(iProp);
					SendMessageToPC(GetFirstPC(), "GetItemPropertySubType " + IntToString(nVal));
					nVal = GetItemPropertyType(iProp);
					SendMessageToPC(GetFirstPC(), "GetItemPropertyType " + IntToString(nVal));	
					SendMessageToPC(GetFirstPC(), "-----");		
				}
				*/			
				iProp = GetNextItemProperty(oItem);
			}
		    if (nDR > 0)
			{
		
				effect eDR;
				eDR = EffectDamageReduction(nDR/2, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE);
				eDR = SetEffectSpellId(eDR, DMGRES_FIX);
				eDR = SupernaturalEffect(eDR);
				DelayCommand(0.3f, DelayedDmgResFixApplication(oPC, eDR));
			}			
		}		
	}	//end if valid object and belt item	     	
}

void DelayedSRFixApplication(object oPC, effect eEffect)
{
	if (GetHasSpellEffect(SR_FIX,oPC))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SR_FIX );
	}
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
}

int GetSRValueBy2DAValue(int nItemPropertyCostTableValueIndex)
{
	int nSR = 10;
	
	switch (nItemPropertyCostTableValueIndex)
	{
		case 0: nSR = 10;
			break;
		case 1: nSR = 12;
			break;
		case 2: nSR = 14;
			break;
		case 3: nSR = 16;
			break;
		case 4: nSR = 18;
			break;
		case 5: nSR = 20;
			break;
		case 6: nSR = 22;
			break;
		case 7: nSR = 24;
			break;
		case 8: nSR = 26;
			break;
		case 9: nSR = 28;
			break;
		case 10: nSR = 30;
			break;
		case 11: nSR = 32;
			break;
		case 12: nSR = 34;
			break;
		case 13: nSR = 36;
			break;
		case 14: nSR = 38;
			break;
		case 15: nSR = 40;
			break;
		case 16: nSR = 19;
			break;																																							
		default: nSR = 10;
			break;									
	}
	
	return nSR;
}

/*
void ApplySRFix(object oPC)
{
	if (GetHasSpellEffect(SR_FIX,oPC))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SR_FIX );
	}
	
    object oItem;
    int nSRMax=0;	
    int nSRCurrent=0;

    int nCostTableResRef;
    int nValue;

	int nSlotNum;
    for(nSlotNum = 0; nSlotNum < NUM_INVENTORY_SLOTS; nSlotNum++)
    {
        oItem = GetItemInSlot(nSlotNum, oPC);
        if(GetIsObjectValid(oItem))
        {
        	itemproperty iProp = GetFirstItemProperty(oItem);
        	while (GetIsItemPropertyValid(iProp))
            {
	            nCostTableResRef = GetItemPropertyCostTable(iProp);
	            if (nCostTableResRef == 11) //iprp_srcost
	            {
					nValue = GetItemPropertyCostTableValue(iProp);
	                //string nSRValue = Get2DAString("iprp_srcost", "Value", nValue);
	                //nSRCurrent = StringToInt(nSRValue);
					nSRCurrent = GetSRValueBy2DAValue(nValue);
		            if (nSRMax < nSRCurrent)
		            {
		                nSRMax = nSRCurrent;
		            }					
	            }
	            iProp = GetNextItemProperty(oItem);
            }
        }
    }
	
    if (nSRMax > 0)
	{
		effect eSR = EffectSpellResistanceIncrease(nSRMax);
		eSR = SetEffectSpellId(eSR, SR_FIX);
		eSR = SupernaturalEffect(eSR);
		DelayCommand(0.3f, DelayedSRFixApplication(oPC, eSR));
	}
	     	
}
*/

void CleanAssassin(object oPC)
{
	if (GetHasFeat(468, oPC, TRUE))
	{
		FeatRemove(oPC, 468);
	}
	if (GetHasFeat(469, oPC, TRUE))
	{
		FeatRemove(oPC, 469);
	}
	if (GetHasFeat(470, oPC, TRUE))
	{
		FeatRemove(oPC, 470);
	}
	if (GetHasFeat(471, oPC, TRUE))
	{
		FeatRemove(oPC, 471);						
	}
	SetLocalInt(oPC, "AssassinCleaned", 1);
}

void CleanBlackGuard(object oPC)
{
	if (GetHasFeat(476, oPC, TRUE))
	{
		FeatRemove(oPC, 476);
	}
	if (GetHasFeat(477, oPC, TRUE))
	{
		FeatRemove(oPC, 477);	
	}
	if (GetHasFeat(478, oPC, TRUE))
	{
		FeatRemove(oPC, 478);
	}
	if (GetHasFeat(479, oPC, TRUE))
	{
		FeatRemove(oPC, 479);				
	}
	SetLocalInt(oPC, "BlackGuardCleaned", 1);
}






void checkHeartBeatTwoWeaponDefense( object oPC )
{		
		effect e2WpnDef;
		int nACBonus = 1;
		if ( ( CSLGetPreferenceSwitch("UseTwoWpnDefense",FALSE) ) && (GetHasFeat(FEAT_TWO_WEAPON_DEFENSE, oPC)))
		{
			if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_DEFENSE, oPC))
			{
				nACBonus = 2;
			}
			if (GetHasFeat(FEAT_GTR_2WPN_DEFENSE, oPC))					
			{
				nACBonus = 4;
			}
				
			if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) )
			{
				if (!GetHasSpellEffect(-FEAT_TWO_WEAPON_DEFENSE,oPC))
				{

					if ( IsTwoWeaponValid( oPC ) )
					{	
						CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_Gtr_2Wpn_Defense );
						e2WpnDef = EffectACIncrease(nACBonus, AC_SHIELD_ENCHANTMENT_BONUS);
						e2WpnDef = SupernaturalEffect( e2WpnDef );
						e2WpnDef = SetEffectSpellId(e2WpnDef, -FEAT_TWO_WEAPON_DEFENSE);
						
						//DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, e2WpnDef, oPC, HoursToSeconds(24), -FEAT_TWO_WEAPON_DEFENSE ));			
						DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, e2WpnDef, oPC, 0.0f, -FEAT_TWO_WEAPON_DEFENSE ));
						SendMessageToPC(oPC, "Defensive fighting with two weapon defense active.");						
					}

				}
				else //They have it, check that it is still valid
				{
					if (!IsTwoWeaponValid(oPC))
					{
						SendMessageToPC(oPC, "Defensive fighting with two weapon defense is only valid when dual wielding.");
						CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oPC, -FEAT_TWO_WEAPON_DEFENSE );
					}					
				}				
				
			}
			else
			{
				if (GetHasSpellEffect(-FEAT_TWO_WEAPON_DEFENSE,oPC))
				{
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oPC, -FEAT_TWO_WEAPON_DEFENSE );
					SendMessageToPC(oPC, "Defensive fighting with two weapon defense disabled.");						
				}
				if (GetHasFeat(FEAT_GTR_2WPN_DEFENSE , oPC))
				{
					ExecuteScript("EQ_grt2weapdef", oPC);
				}
		
			}			
		}
}



void checkHeartBeatElaborateParry( object oPC )
{
	effect eElabParry;	
	if ( CSLGetPreferenceSwitch("ElaborateParry",FALSE) )
		{
		
			if (GetLevelByClass(CLASS_TYPE_DUELIST, oPC ) > 6)
			{
				//SendMessageToPC(oPC, "Over 6");		
				if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_PARRY) )
				{
					//SendMessageToPC(oPC, "1742 - Elaborate Parry");
					if ( !GetHasSpellEffect(-FEAT_ELABORATE_PARRY, oPC ) )
					{
							
						eElabParry = EffectACIncrease( GetLevelByClass(CLASS_TYPE_DUELIST, oPC ) );
						eElabParry = SupernaturalEffect( eElabParry );
						eElabParry = SetEffectSpellId(eElabParry, -FEAT_ELABORATE_PARRY );
						eElabParry = SupernaturalEffect(eElabParry);
						//ApplyEffectToObject( DURATION_TYPE_PERMANENT, eElabParry, oPC );
						DelayCommand(0.0f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eElabParry, oPC, 0.0f, -FEAT_ELABORATE_PARRY));
						SendMessageToPC(oPC, "Elaborate Parry enabled.");		
					}				
					
				}
				else
				{
					if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oPC, -FEAT_ELABORATE_PARRY ) )
					{
						SendMessageToPC(oPC, "Elaborate Parry disabled.");						
					}
			
				}
			}
		}

}


void checkHeartBeatDeadlyDefense( object oPC )
{
	effect eDeadlyDef;
	if (GetHasFeat(FEAT_DEADLY_DEFENSE, oPC))
	{		
		if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_PARRY) )
		{
			//SendMessageToPC(oPC, "1742 - Elaborate Parry");
			if (!GetHasSpellEffect(-FEAT_DEADLY_DEFENSE,oPC))
			{
				if (isDeadlyDefenseValid(oPC))
				{	
					eDeadlyDef = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_MAGICAL);
					eDeadlyDef = SupernaturalEffect( eDeadlyDef );
					eDeadlyDef = SetEffectSpellId(eDeadlyDef, -FEAT_DEADLY_DEFENSE);
					eDeadlyDef = SupernaturalEffect(eDeadlyDef);
					//DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeadlyDef, oPC, HoursToSeconds(24),-FEAT_DEADLY_DEFENSE ));			
					DelayCommand(0.0f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eDeadlyDef, oPC, 0.0f, -FEAT_DEADLY_DEFENSE ));
					SendMessageToPC(oPC, "Deadly Defense enabled.");						
				}
			}
			else //They have it, check that it is still valid
			{
				if (!isDeadlyDefenseValid(oPC))
				{
					SendMessageToPC(oPC, "Deadly Defense is only valid when wearing light or no armor and using a finessable weapon.");
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oPC, -FEAT_DEADLY_DEFENSE );
				}
			}
		}
		else
		{
			if (GetHasSpellEffect(-FEAT_DEADLY_DEFENSE,oPC))
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -FEAT_DEADLY_DEFENSE );
				SendMessageToPC(oPC, "Deadly Defense disabled.");						
			}
		}		
	}
}


void checkHeartBeatDervishParry( object oPC )
{
		if (GetLevelByClass(CLASS_DERVISH, oPC) > 0)
		{
			if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)  )
			{
				if (!GetHasSpellEffect(-FEAT_DERVISH_DEFENSIVE_PARRY,oPC))
				{
					effect eDefParry = EffectACIncrease(4);
					eDefParry = SetEffectSpellId(eDefParry, -FEAT_DEADLY_DEFENSE);
					eDefParry = SupernaturalEffect(eDefParry);
					DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24)));			
					SendMessageToPC(oPC, "Defensive Parry enabled.");						
				}
			}
			else
			{
				if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -FEAT_DERVISH_DEFENSIVE_PARRY ) )
				{
					SendMessageToPC(oPC, "Defensive Parry disabled.");						
				}
			}					
		}
}

int isValidElegantStrikeWeapon( object oWpn )
{
	if	(GetIsObjectValid(oWpn))
	{
		int iBaseItemType = GetBaseItemType(oWpn);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_ELEGANTSTRIKE )
		{
			return TRUE;
		}
	}
	return FALSE;
}

void StackEldBlast (object oPC)
{
	int nWarlock = GetLevelByClass(CLASS_TYPE_WARLOCK, oPC);
	int nHeartwarder = GetLevelByClass(CLASS_HEARTWARDER, oPC);
	int nStormSinger = GetLevelByClass(CLASS_STORMSINGER, oPC);
	int nChildNight = GetLevelByClass(CLASS_CHILD_NIGHT, oPC);
	if (nChildNight > 0 && !GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_WARLOCK, oPC) )
	{
		nChildNight = 0;
	}
	if (nHeartwarder > 0 && !GetHasFeat(FEAT_HEARTWARDER_SPELLCASTING_WARLOCK, oPC) )
	{
		nHeartwarder = 0;
	}
	if (nStormSinger > 0 && !GetHasFeat(FEAT_STORMSINGER_SPELLCASTING_WARLOCK, oPC) )
	{
		nStormSinger = 0;
	}
	
	int nKoT = GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oPC);
	if (nKoT > 0 && !GetHasFeat(FEAT_KOT_SPELLCASTING_WARLOCK, oPC) )
	{
		nKoT = 0;
	}
	
	int nDrgSlyr = GetLevelByClass(CLASS_DRAGONSLAYER, oPC);
	if (nDrgSlyr > 0 && !GetHasFeat(FEAT_DRSLR_SPELLCASTING_WARLOCK, oPC) )
	{
		nDrgSlyr = 0;
	}
	else
	{
		nDrgSlyr = (nDrgSlyr + 1) / 2;
	}
	int nDaggMage = GetLevelByClass(CLASS_DAGGERSPELL_MAGE, oPC);
	if (nDaggMage > 0 && !GetHasFeat(FEAT_DMAGE_SPELLCASTING_WARLOCK, oPC) )
	{
		nDaggMage = 0;
	}
	int nTotal = nDaggMage + nWarlock + nHeartwarder + nKoT + nDrgSlyr + nStormSinger + nChildNight; //Total Warlock level for blasts
	
	/*
	if (GetHasFeat(FEAT_FEY_POWER, oPC))
	{
		nTotal++;
	}
	
	if (GetHasFeat(FEAT_FIENDISH_POWER, oPC))
	{
		nTotal++;
	}
	
	int iDice;
	int nCount;	
	*/
	
	//if Hellfire Warlock is needed
	int nHfW = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, oPC);
	nTotal += nHfW; 
	
	//Eld Disciple always advances dice
	int nEldDisc = GetLevelByClass(CLASS_ELDRITCH_DISCIPLE, oPC);
	nTotal += nEldDisc;

	if (GetHasFeat(FEAT_PRACTICED_INVOKER,oPC))
	{
		int nHD = GetHitDice(oPC);
		if (nTotal < nHD)
		{
			nTotal += 4;
			if (nTotal > nHD)
			{
				nTotal = nHD;
			}
		}
	}
	
	if (GetHasFeat(FEAT_FEY_POWER, oPC))
	{
		if (nWarlock > 0)
		{
			nTotal++;
		}
		else
		{
			if (GetHasFeat(FEAT_ELDRITCH_BLAST_1, oPC))
			{
				FeatRemove(oPC, FEAT_ELDRITCH_BLAST_1);
			}
		}
	}
	if (GetHasFeat(FEAT_FIENDISH_POWER, oPC))
	{
		if (nWarlock > 0)
		{
			nTotal++;
		}
		else
		{
			if (GetHasFeat(FEAT_ELDRITCH_BLAST_1, oPC))
			{
				FeatRemove(oPC, FEAT_ELDRITCH_BLAST_1);
			}
		}
	}
		
	if (nTotal > 30)
	{
		nTotal = 30;
	}
	
	int iDice;
	int nCount;	

	


	
	//1411-1419 1-9
	//1948-1952 10-14
		
	if (nTotal > 20) //10-14
	{
		iDice = (nTotal - 20) / 2;
		for (nCount = 0; nCount < iDice; nCount++)
		{
			FeatAdd(oPC, nCount + 1948, FALSE);
		}		
		FeatAdd(oPC, 1411, FALSE);
		FeatAdd(oPC, 1412, FALSE);	
		FeatAdd(oPC, 1413, FALSE);	
		FeatAdd(oPC, 1414, FALSE);	
		FeatAdd(oPC, 1415, FALSE);	
		FeatAdd(oPC, 1416, FALSE);	
		FeatAdd(oPC, 1417, FALSE);	
		FeatAdd(oPC, 1418, FALSE);	
		FeatAdd(oPC, 1419, FALSE);				
	}
	else
	if (nTotal > 11) //7-9
	{
		iDice = (nTotal - 11) / 3;
		for (nCount = 0; nCount < iDice; nCount++)
		{
			FeatAdd(oPC, nCount + 1417, FALSE);
		}	
		FeatAdd(oPC, 1411, FALSE);
		FeatAdd(oPC, 1412, FALSE);	
		FeatAdd(oPC, 1413, FALSE);	
		FeatAdd(oPC, 1414, FALSE);	
		FeatAdd(oPC, 1415, FALSE);	
		FeatAdd(oPC, 1416, FALSE);										
	}
	else //1-6
	{

		iDice = (nTotal + 1) / 2;
		for (nCount = 0; nCount < iDice; nCount++)
		{
			FeatAdd(oPC, nCount + 1411, FALSE);
		}
		
	}

}

void SetupDragonDis()
{
	
	if (GetHasFeat(FEAT_DRAGON_DIS_GOLD, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 1);
		return;
	}
	if (GetHasFeat(FEAT_DRAGON_DIS_RED, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 1);
		return;
	}
	if (GetHasFeat(FEAT_DRAGON_DIS_BRASS, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 1);
		return;
	}	
	if (GetHasFeat(FEAT_DRAGON_DIS_BLACK, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 2);
		return;
	}	
	if (GetHasFeat(FEAT_DRAGON_DIS_GREEN, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 2);
		return;
	}	
	if (GetHasFeat(FEAT_DRAGON_DIS_COPPER, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 2);
		return;
	}	
	
	if (GetHasFeat(FEAT_DRAGON_DIS_BLUE, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 3);
		return;
	}	
	if (GetHasFeat(FEAT_DRAGON_DIS_BRONZE, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 3);
		return;
	}	
	
	if (GetHasFeat(FEAT_DRAGON_DIS_SILVER, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 4);
		return;
	}	
	if (GetHasFeat(FEAT_DRAGON_DIS_WHITE, OBJECT_SELF))
	{
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 4);
		return;
	}							

}




int isDeadlyDefenseValid(object oPartyMember)
{
	int nArmorRank = ARMOR_RANK_NONE;
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPartyMember);
 	if (GetIsObjectValid(oArmor))
 	{
		nArmorRank = GetArmorRank(oArmor);
	}
	//SendMessageToPC(oPartyMember, "Rank: " + IntToString(nArmorRank));	
	object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPartyMember);
	object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPartyMember);
	
	int nWpnType1;
	int nWpnType2;
	
 	if (GetIsObjectValid(oWeapon1))	
	{
		if (!CSLItemGetIsLightWeapon(oWeapon1, oPartyMember))
		{
			return FALSE;
		}
	}
	
 	if (GetIsObjectValid(oWeapon2))
	{
		if (!CSLItemGetIsLightWeapon(oWeapon2, oPartyMember))
		{
			return FALSE;
		}
	}
		
	if (nArmorRank == ARMOR_RANK_NONE || nArmorRank == ARMOR_RANK_LIGHT)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

int IsTwoWeaponValid(object oPartyMember)
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPartyMember);
    //object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oWeapon2    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPartyMember);
	
    if (GetIsObjectValid(oWeapon2))
    {
		int nBaseItemType = GetBaseItemType(oWeapon2);
		
        if (nBaseItemType == BASE_ITEM_LARGESHIELD ||
            nBaseItemType == BASE_ITEM_SMALLSHIELD ||
            nBaseItemType == BASE_ITEM_TOWERSHIELD )
        {
            oWeapon2 = OBJECT_INVALID;
        }
    }
	
	if	(GetIsObjectValid(oWeapon))
	{
		int nBaseItemType = GetBaseItemType(oWeapon);
		if (GetWeaponRanged(oWeapon))
		{
			oWeapon = OBJECT_INVALID;
		}
	}
	
	if ((oWeapon != OBJECT_INVALID) &&  (oWeapon2 != OBJECT_INVALID))
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

/* replaced with CSLGetIsHoldingRangedWeapon
int IsElemArcherStateValid()
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	
    if (GetIsObjectValid(oWeapon))
    {
		int iBaseItemType = GetBaseItemType(oWeapon);
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_RANGED )
		{
			return TRUE;
		}
    }
	return FALSE;
}
*/

int GetCurrentWildShapeFeat(object oPC)
{	
	if (GetHasFeat(1933, oPC)) //9
	{
		return 1933;
	}
	if (GetHasFeat(1932, oPC)) //8
	{
		return 1932;
	}
	if (GetHasFeat(1931, oPC)) //7
	{
		return 1931;
	}
	if (GetHasFeat(339, oPC)) //6
	{
		return 339;		
	}
	if (GetHasFeat(338, oPC)) //5
	{
		return 338;	
	}
	if (GetHasFeat(337, oPC)) //4
	{
		return 337;		
	}
	if (GetHasFeat(336, oPC)) //3
	{
		return 336;			
	}
	if (GetHasFeat(335, oPC)) //2
	{
		return 335;	
	}
	if (GetHasFeat(305, oPC)) //1
	{
		return 305;												
	}
	return -1;
}

void EvaluateUCM( object oPC = OBJECT_SELF )
{
		int iSpellId = SPELLABILITY_UNARMED_COMBAT_MASTERY;		
		int bUCMStateValid = FALSE;
		
	    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
	    object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
		
		if (GetIsObjectValid(oWeapon) || GetIsObjectValid(oWeapon2))
		{
			bUCMStateValid = FALSE;
		}
		else
		{
			bUCMStateValid = TRUE;	
		}
		
		int bHasUCM = GetHasSpellEffect(iSpellId,oPC);
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );
		if (bUCMStateValid)
		{
			effect eAB = SupernaturalEffect(EffectAttackIncrease(2));
			effect eDmg = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BLUDGEONING));
			effect eLink = SupernaturalEffect(EffectLinkEffects(eAB,eDmg));
			eLink = SetEffectSpellId(eLink,iSpellId);
				
			if (!bHasUCM)
			{
				SendMessageToPC(oPC,"Unarmed Combat Mastery enabled.");			
			}
			DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(48), iSpellId ));			
			
		}
		else
		{
			if (bHasUCM)
			{
				SendMessageToPC(oPC,"Unarmed Combat Mastery disabled, it is only valid when fighting unarmed or with creature weapons.");			
			}
		}		
}

void EvaluateOver2WpnFight()
{
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, SPELLABILITY_OVERSIZE_TWO_WEAPON_FIGHTING );
		
	int bValid = FALSE;
    object oWeapon2    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
    if (GetIsObjectValid(oWeapon2))
    {
		int nBaseItemType = GetBaseItemType(oWeapon2);
		
        if (nBaseItemType ==BASE_ITEM_LARGESHIELD ||
            nBaseItemType ==BASE_ITEM_SMALLSHIELD ||
            nBaseItemType ==BASE_ITEM_TOWERSHIELD)
        {
        	bValid = FALSE;
        }
		else
			bValid = TRUE;
    }
	if (bValid)
	{
		int nBaseItemType = GetBaseItemType(oWeapon2);
		if ( 		
			nBaseItemType == BASE_ITEM_LONGSWORD
			|| nBaseItemType == BASE_ITEM_BATTLEAXE
			|| nBaseItemType == BASE_ITEM_BASTARDSWORD
			|| nBaseItemType == BASE_ITEM_LIGHTFLAIL
			|| nBaseItemType == BASE_ITEM_FLAIL
			|| nBaseItemType == BASE_ITEM_WARHAMMER
			|| nBaseItemType == BASE_ITEM_HALBERD
			|| nBaseItemType == BASE_ITEM_GREATSWORD
			|| nBaseItemType == BASE_ITEM_GREATAXE
			|| nBaseItemType == BASE_ITEM_CLUB
			|| nBaseItemType == BASE_ITEM_KATANA
			|| nBaseItemType == BASE_ITEM_MAGICSTAFF
			|| nBaseItemType == BASE_ITEM_MORNINGSTAR
			|| nBaseItemType == BASE_ITEM_QUARTERSTAFF
			|| nBaseItemType == BASE_ITEM_RAPIER
			|| nBaseItemType == BASE_ITEM_SCIMITAR
			|| nBaseItemType == BASE_ITEM_SCYTHE
			|| nBaseItemType == BASE_ITEM_FALCHION
			|| nBaseItemType == BASE_ITEM_DWARVENWARAXE
			|| nBaseItemType == BASE_ITEM_SPEAR
			|| nBaseItemType == BASE_ITEM_GREATCLUB
			|| nBaseItemType == BASE_ITEM_WARMACE
			|| nBaseItemType == BASE_ITEM_ALLUSE_SWORD
		   )
		{
			bValid = TRUE; // Stays true;
		}
		else
		{
			bValid = FALSE;
		}
		
	}
	if (bValid)
	{
		effect eAB = EffectAttackIncrease(2);
		eAB = SetEffectSpellId(eAB, SPELLABILITY_OVERSIZE_TWO_WEAPON_FIGHTING);
		eAB = SupernaturalEffect(eAB);
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAB, OBJECT_SELF, HoursToSeconds(48), SPELLABILITY_OVERSIZE_TWO_WEAPON_FIGHTING ));		
	}	
}

void EvaluateBattleDancer( object oPC = OBJECT_SELF )
{
	effect eAB = EffectAttackIncrease(2);
	//eAB = SetEffectSpellId(eAB, SPELLABILITY_BATTLE_DANCER);
	eAB = SupernaturalEffect(eAB);
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAB, oPC, HoursToSeconds(48), SPELLABILITY_BATTLE_DANCER));
	//This needs to be improved to check if the bard is playing an inspiration in case of magic dead areas.
}

void EvaluateArmorSpec( object oPC = OBJECT_SELF)
{
	
	
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST);
	int nArmorRank = GetArmorRank(oArmor);
	
	if (GetHasSpellEffect(SPELLABILITY_ARMOR_SPECIALIZATION_MEDIUM,oPC))
	{
		if (nArmorRank == ARMOR_RANK_MEDIUM && GetHasFeat(FEAT_ARMOR_SPECIALIZATION_MEDIUM))
		{
			return;
		}
		else
		{		
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_ARMOR_SPECIALIZATION_MEDIUM );
		}
	}
	if (GetHasSpellEffect(SPELLABILITY_ARMOR_SPECIALIZATION_HEAVY,oPC))
	{	
		if (nArmorRank == ARMOR_RANK_HEAVY && GetHasFeat(FEAT_ARMOR_SPECIALIZATION_HEAVY))
		{
			return;
		}
		else
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_ARMOR_SPECIALIZATION_HEAVY );
		}
	}	
				
	if (nArmorRank == ARMOR_RANK_MEDIUM && GetHasFeat(FEAT_ARMOR_SPECIALIZATION_MEDIUM))
	{
		effect eDR = EffectDamageReduction(3, DR_TYPE_NONE, 0, DR_TYPE_NONE);
		eDR = SetEffectSpellId(eDR, SPELLABILITY_ARMOR_SPECIALIZATION_MEDIUM);
		eDR = SupernaturalEffect(eDR);
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC, 0.0f, SPELLABILITY_ARMOR_SPECIALIZATION_MEDIUM ));			
	}
	else if (nArmorRank == ARMOR_RANK_HEAVY && GetHasFeat(FEAT_ARMOR_SPECIALIZATION_HEAVY))
	{
		effect eDR = EffectDamageReduction(5, DR_TYPE_NONE, 0, DR_TYPE_NONE);
		eDR = SetEffectSpellId(eDR, SPELLABILITY_ARMOR_SPECIALIZATION_HEAVY);
		eDR = SupernaturalEffect(eDR);
		//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC);	
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, oPC, 0.0f, SPELLABILITY_ARMOR_SPECIALIZATION_HEAVY ));
	}
	
}


/*
int GetASFReducedPercent(object oPC)
{
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
 	if (GetIsObjectValid(oArmor))
	{
		int nArmorRank = GetArmorRank(oArmor);
		if (nArmorRank == ARMOR_RANK_LIGHT)
		{
			return 15;
		}
		else if (nArmorRank == ARMOR_RANK_MEDIUM)
		{
			return 30;
		}
		else
		{
			return 0;
		}
	}	
	else
	{
		return 0;
	}
}
*/

int GetASFReduction(object oPC, int nBattleCaster = 0)
{
	int nASF = 0;
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
 	if (GetIsObjectValid(oArmor))
	{
		int nArmorRank = GetArmorRank(oArmor);
		if (nArmorRank == ARMOR_RANK_MEDIUM)
		{
		 	if (nBattleCaster == 0)
				return 0;
			else
			{
				int nArmorRules = GetArmorRulesType(oArmor);
				string sASF = Get2DAString("armorrulestats", "ARCANEFAILURE%", nArmorRules);
				nASF = StringToInt(sASF);
				return nASF;
			}
		}
		if (nArmorRank == ARMOR_RANK_LIGHT)
		{
				int nArmorRules = GetArmorRulesType(oArmor);
				string sASF = Get2DAString("armorrulestats", "ARCANEFAILURE%", nArmorRules);
				nASF = StringToInt(sASF);
				return nASF;		
		}
	}
	return 0;
}

void EvaluateArmoredCaster()
{

	object oPC = OBJECT_SELF;
	int iSpellId = SPELLABILITY_Armored_Caster;
	int bArmoredCasterValid = GetASFReduction(oPC, FALSE);
	if (bArmoredCasterValid == 30)
	{
		bArmoredCasterValid = 0;
	}
	
	int bHasArmoredCaster = CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );

	if (bArmoredCasterValid)
	{
		if (!bHasArmoredCaster)
		{
			SendMessageToPC(oPC,"Armored Caster enabled.");
			//int iLevel = GetLevelByClass(CLASS_SWIFTBLADE,oPC);	
			int iValue = 0 - bArmoredCasterValid;			
			effect eASF = SupernaturalEffect(EffectArcaneSpellFailure(iValue));	
			eASF = SetEffectSpellId(eASF,iSpellId);
			DelayCommand(0.1f, HkSafeApplyEffectToObject(DURATION_TYPE_PERMANENT, eASF, oPC));			
		}				
	}
	else
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );
		
		if (bHasArmoredCaster)
		{
			SendMessageToPC(oPC,"Armored Caster disabled. You must be wearing light armor with arcane spell failure for this ability to work.");
		}
	}
}

void EvaluateBattleCaster()
{

	object oPC = OBJECT_SELF;
	int iSpellId = SPELLABILITY_Battle_Caster;
	int bBattleCasterValid = GetASFReduction(oPC, TRUE);
	int bHasBattleCaster = GetHasSpellEffect(iSpellId,oPC);
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_Armored_Caster, SPELLABILITY_Battle_Caster );
	
	
	if (bBattleCasterValid)
	{
		if (!bHasBattleCaster)
		{
			SendMessageToPC(oPC,"Battle Caster enabled.");
		}
			//int iLevel = GetLevelByClass(CLASS_SWIFTBLADE,oPC);	
			int iValue = 0 - bBattleCasterValid;			
			effect eASF = SupernaturalEffect(EffectArcaneSpellFailure(iValue));	
			eASF = SetEffectSpellId(eASF,iSpellId);
			DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eASF, oPC, 0.0f, iSpellId ));			
					
	}
	else
	{
		if (bHasBattleCaster)
		{
			SendMessageToPC(oPC,"Battle Caster disabled. You must be wearing light or medium armor with arcane spell failure for this ability to work.");
		}
	}
}

//For simple uses/day
int GetBardicClassLevelForUses(object oPC)
{
	int nBardicMusic;

	nBardicMusic = GetLevelByClass(CLASS_TYPE_BARD, oPC);
	nBardicMusic += GetLevelByClass(CLASS_STORMSINGER, oPC);
	nBardicMusic += GetLevelByClass(CLASS_CANAITH_LYRIST, oPC);
	nBardicMusic += GetLevelByClass(CLASS_LYRIC_THAUMATURGE, oPC);
	nBardicMusic += GetLevelByClass(CLASS_DISSONANT_CHORD, oPC);
	return nBardicMusic;	
}



int GetBardicClassLevelForSongs(object oPC)
{

	int nBardicMusic;	

	nBardicMusic = GetLevelByClass(CLASS_TYPE_BARD, oPC);
	nBardicMusic += GetLevelByClass(CLASS_CANAITH_LYRIST, oPC);
	return nBardicMusic;	


}

void StackSwashbucklerGrace(object oPC)
{
	int nRogue = GetLevelByClass(CLASS_TYPE_ROGUE,oPC);
	nRogue += GetLevelByClass(CLASS_NINJA, oPC);
	int nSwash = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC);
	
	int nDaringOutlawCap = CSLGetPreferenceInteger("DaringOutlawCap",0);	
	if (nDaringOutlawCap > 0)
	{
		if (nRogue > nDaringOutlawCap)
			nRogue = nDaringOutlawCap;
	}
	
	if (!GetHasFeat(FEAT_DARING_OUTLAW , oPC))
		nRogue = 0;
	
	int nTotal = nRogue + nSwash;
	
	//Grace
	if (nTotal > 28)
	{
		FeatAdd(oPC, 2140 , FALSE, FALSE, FALSE);
		FeatAdd(oPC, 2139 , FALSE, FALSE, FALSE);
		FeatAdd(oPC, 2138 , FALSE, FALSE, FALSE);						
	}
	else if (nTotal > 19)
	{
		FeatAdd(oPC, 2139 , FALSE, FALSE, FALSE);
		FeatAdd(oPC, 2138 , FALSE, FALSE, FALSE);		
	}
	else if (nTotal > 10)
	{
		FeatAdd(oPC, 2138 , FALSE, FALSE, FALSE);	
	}						
}

void StackSwashbucklerDodge(object oPC)
{

	int nTotal=0;
	int nDaringOutlawCap = CSLGetPreferenceInteger("DaringOutlawCap",0);
		
	int nWildStlk = GetLevelByClass(CLASS_WILD_STALKER,oPC);
	if (nWildStlk > 3)
		nTotal += nWildStlk/4;
	
	int nRogue = GetLevelByClass(CLASS_TYPE_ROGUE,oPC);
	int nNinja = GetLevelByClass(CLASS_NINJA, oPC);
	int nSwash = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC);	
		
	int nScout = GetLevelByClass(CLASS_SCOUT,oPC);
	
	if (GetHasFeat(FEAT_SWIFT_AMBUSHER , oPC))
	{
		if (GetHasFeat(FEAT_DARING_OUTLAW , oPC))
		{	
			nScout += nRogue;
			nScout += nNinja;
			nScout += nSwash;
		}
		else
		{
			nScout += nRogue;
			nScout += nNinja;		
		}
	}
	else
	{
		if (GetHasFeat(FEAT_DARING_OUTLAW , oPC))
		{
			if (nDaringOutlawCap > 0)
			{
				if (nRogue + nNinja > nDaringOutlawCap)
					nSwash += nDaringOutlawCap;
			}
			else
			{
				nSwash += nRogue;
				nSwash += nNinja;			
			}		
		
		}	
	}
	if (GetHasFeat(FEAT_SWIFT_HUNTER , oPC))
	{
		int nRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);	
		nScout += nRanger;
	}	
	
	nTotal += ((nScout + 1)/4);
	nTotal += nSwash/5; 	
	
	//Dodge
	if (nTotal > 6)
	{
		FeatAdd(oPC, FEAT_SCOUT_SKIRMISHAC , FALSE, FALSE, FALSE); //+7	
		FeatAdd(oPC, 2148 , FALSE, FALSE, FALSE); //+6
		FeatAdd(oPC, 2147 , FALSE, FALSE, FALSE); //+5
		FeatAdd(oPC, 2146 , FALSE, FALSE, FALSE); //+4
		FeatAdd(oPC, 2145 , FALSE, FALSE, FALSE); //+3
		FeatAdd(oPC, 2144 , FALSE, FALSE, FALSE); //+2
		FeatAdd(oPC, 2143 , FALSE, FALSE, FALSE); //+1		
	}
	if (nTotal == 6)
	{
		FeatAdd(oPC, 2148 , FALSE, FALSE, FALSE); //+6
		FeatAdd(oPC, 2147 , FALSE, FALSE, FALSE); //+5
		FeatAdd(oPC, 2146 , FALSE, FALSE, FALSE); //+4
		FeatAdd(oPC, 2145 , FALSE, FALSE, FALSE); //+3
		FeatAdd(oPC, 2144 , FALSE, FALSE, FALSE); //+2
		FeatAdd(oPC, 2143 , FALSE, FALSE, FALSE); //+1											
						
	}
	else if (nTotal == 5)
	{
		FeatAdd(oPC, 2147 , FALSE, FALSE, FALSE); //+5
		FeatAdd(oPC, 2146 , FALSE, FALSE, FALSE); //+4
		FeatAdd(oPC, 2145 , FALSE, FALSE, FALSE); //+3
		FeatAdd(oPC, 2144 , FALSE, FALSE, FALSE); //+2
		FeatAdd(oPC, 2143 , FALSE, FALSE, FALSE); //+1			
	}	
	else if (nTotal == 4)
	{
		FeatAdd(oPC, 2146 , FALSE, FALSE, FALSE); //+4
		FeatAdd(oPC, 2145 , FALSE, FALSE, FALSE); //+3
		FeatAdd(oPC, 2144 , FALSE, FALSE, FALSE); //+2
		FeatAdd(oPC, 2143 , FALSE, FALSE, FALSE); //+1		
	}	
	else if (nTotal == 3)
	{
		FeatAdd(oPC, 2145 , FALSE, FALSE, FALSE); //+3
		FeatAdd(oPC, 2144 , FALSE, FALSE, FALSE); //+2
		FeatAdd(oPC, 2143 , FALSE, FALSE, FALSE); //+1		
	}	
	else if (nTotal == 2)
	{
		FeatAdd(oPC, 2144 , FALSE, FALSE, FALSE); //+2
		FeatAdd(oPC, 2143 , FALSE, FALSE, FALSE); //+1			
	}	
	else if (nTotal == 1)
	{
		FeatAdd(oPC, 2143 , FALSE, FALSE, FALSE); //+1	
	}					
		
}


void StackBardicUses(object oPC)
{

	int nBardicUses =  GetBardicClassLevelForUses(oPC);
	if (GetHasFeat(FEAT_ARTIST, oPC))
	{
		nBardicUses += 3;
	}
	
	if (nBardicUses > 20)
	{
		nBardicUses = 20;
	}
	
	//1 = 257 No need to add 1 use, no bardic prc can be taken without Bard levels
	//2-20 = 355 - 373
	int nMax = nBardicUses - 1 + 355;
	int iFeatCurrent;
	
	if (nMax == 0)
	{
		return;
	}
		
	for (iFeatCurrent = 355; iFeatCurrent< nMax; iFeatCurrent++)
	{
		FeatAdd(oPC, iFeatCurrent,FALSE);
	}		

}

void StackBardMusicUses(object oPC)
{

	int nBard = GetLevelByClass(CLASS_TYPE_BARD, oPC);
	int nBardLevel =  GetBardicClassLevelForSongs(oPC);
	
/*
2 - 1467
3 - 1475
5 - 1468
6 - 1476
7 - 1469
8 - 1470
9 - 1477
11 - 1471
12 - 1478
14 - 1472
15 - 1479
18 - 1480	
*/
	
	if (nBardLevel > nBard)
	{
		if (nBardLevel > 17)
		{
			if (!GetHasFeat(1480, oPC, TRUE))
				FeatAdd(oPC, 1480, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1479, oPC, TRUE))
				FeatAdd(oPC, 1479, FALSE, FALSE, FALSE);	
			if (!GetHasFeat(1472, oPC, TRUE))
				FeatAdd(oPC, 1472, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1478, oPC, TRUE))
				FeatAdd(oPC, 1478, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);																																	
				
		} else
		if (nBardLevel > 14)
		{
			if (!GetHasFeat(1479, oPC, TRUE))
				FeatAdd(oPC, 1479, FALSE, FALSE, FALSE);	
			if (!GetHasFeat(1472, oPC, TRUE))
				FeatAdd(oPC, 1472, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1478, oPC, TRUE))
				FeatAdd(oPC, 1478, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else
		if (nBardLevel > 13)
		{
			if (!GetHasFeat(1472, oPC, TRUE))
				FeatAdd(oPC, 1472, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1478, oPC, TRUE))
				FeatAdd(oPC, 1478, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else		
		if (nBardLevel > 11)
		{
			if (!GetHasFeat(1478, oPC, TRUE))
				FeatAdd(oPC, 1478, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else
		if (nBardLevel > 10)
		{
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else
		if (nBardLevel > 8)
		{
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);		
		} else
		if (nBardLevel > 7)
		{
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else							
		if (nBardLevel > 6)
		{
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else		
		if (nBardLevel > 5)
		{
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else		
		if (nBardLevel > 4)
		{
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else	
		if (nBardLevel > 2)
		{
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else	
		if (nBardLevel > 2)
		{
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		}						
	}		

}




int GetDruidWildShapeUses(int nDruid, object oPC)
{	
	int nCount=0;

	if (nDruid > 29)
	{
		nCount = 9;
	}
	else if (nDruid > 25)
	{
		nCount = 8;
	}
	else if (nDruid > 21)
	{
		nCount = 7;
	}
	else if (nDruid > 17)
	{
		nCount = 6;
	}
	else if (nDruid > 13)
	{
		nCount = 5;
	}
	else if (nDruid > 9)
	{
		nCount = 4;
	}
	else if (nDruid > 6)
	{
		nCount = 3;
	}
	else if (nDruid == 6)
	{
		nCount = 2;
	}
	else if (nDruid== 5)
	{
		nCount = 1;
	}
	
	if (GetHasFeat(FEAT_REAL_EXTRA_WILD_SHAPE, oPC, TRUE))
	{
		nCount = nCount + 2;
	}	
	
	return nCount;				
}

void StackWildshapeUses (object oPC)
{
	int nDruid = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
	int nLionTalisid = GetLevelByClass(CLASS_LION_TALISID, oPC);
	int nNaturesWarrior = GetLevelByClass(CLASS_NATURES_WARRIOR, oPC);
	int nDaggerShaper = GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oPC);
	
	int nTotal = nDruid + nLionTalisid + nNaturesWarrior; //Total Druid level for shapes
	int nCount = GetDruidWildShapeUses(nTotal, oPC);
	nCount += ((nDaggerShaper + 2)/3);
	
	//Now that the count is done, add the levels for getting new shapes	

	if (nLionTalisid > 2)
	{
		nTotal += nLionTalisid - 2; 
	}
	nTotal += nDaggerShaper;
			
	if (nLionTalisid > 0)
	{
		if (nLionTalisid >= 8)
		{
			nCount += 4;
		}
		else if (nLionTalisid >= 5)
		{
			nCount += 3;
		}
		else if (nLionTalisid >= 4)
		{
			nCount += 2;
		}
		else if (nLionTalisid >= 3)
		{
			nCount += 1;
		}
	}
	if ((nCount > 9) && GetHasFeat(FEAT_EXTRA_WILD_SHAPE, oPC, TRUE))
	{
		nCount = nCount + 2;		
	}	
	
	
	
	//Wild Shapes	
	if (nCount > 16)
	{
		nCount = 16;
	}
		
	if (nCount > 9)
	{
		int n;
		//Add 10-13
		for (n = 9; n < nCount; n++)
		{
			if (!GetHasFeat(3747+n, oPC, TRUE))
				FeatAdd(oPC,3747+n,FALSE);			
		}

		//Add 7-9
		for (n = 6; n < 9; n++)
		{
			if (!GetHasFeat(1925+n, oPC, TRUE))
			{
				FeatAdd(oPC,1925+n,FALSE);
			}
		}
		for (n = 1; n < 6; n++)
		{
			if (!GetHasFeat(334+n, oPC, TRUE))
			{
				FeatAdd(oPC,334+n,FALSE);
			}
		}
	}
	else if (nCount > 6)
	{
		int n;
		//Add 7-9
		for (n = 6; n < nCount; n++)
		{
			if (!GetHasFeat(1925+n, oPC, TRUE))
			{
				FeatAdd(oPC,1925+n,FALSE);
			}
		}
		for (n = 1; n < 6; n++)

		{

			if (!GetHasFeat(334+n, oPC, TRUE))
			{
				FeatAdd(oPC,334+n,FALSE);
			}

		}
	}
	else if (nCount > 1)
	{
		int n;
		//Add 2-6
		for (n = 1; n < nCount; n++)
		{
			if (!GetHasFeat(334+n, oPC, TRUE))
			{
				FeatAdd(oPC,334+n,FALSE);
			}
		}
		
	}
	else if (nCount > 0)
	{
		//Add 1
		if (!GetHasFeat(305, oPC, TRUE))
		{
			FeatAdd(oPC,305,FALSE);
		}
	}
	
	//Plant Shape

	if (nTotal > 11)
	{
		if (!GetHasFeat(2111, oPC, TRUE))
		{
			FeatAdd(oPC,2111,FALSE);
		}
	}
	
	if (GetHasFeat(FEAT_REAL_EXTRA_WILD_SHAPE, oPC, TRUE))
	{
		nTotal = nTotal + 2;
	}	
	if (nTotal > 23 && GetHasFeat(FEAT_EXTRA_WILD_SHAPE, oPC, TRUE))
	{
		nTotal = nTotal + 2;
	}
	
	//Elemental Shapes
	if (nTotal > 33) //10
	{
		if (!GetHasFeat(3768, oPC, TRUE))
		{
			FeatAdd(oPC,3768,FALSE);
		}
	}	
	if (nTotal > 31) //9
	{
		if (!GetHasFeat(3767, oPC, TRUE))
		{
			FeatAdd(oPC,3767,FALSE);
		}
	}
	if (nTotal > 29) //8
	{
		if (!GetHasFeat(3766, oPC, TRUE))
		{
			FeatAdd(oPC,3766,FALSE);
		}	
	}	
	if (nTotal > 27) //7
	{
		if (!GetHasFeat(3765, oPC, TRUE))
		{
			FeatAdd(oPC,3765,FALSE);
		}
	}	
	if (nTotal > 25) //6
	{
		if (!GetHasFeat(3764, oPC, TRUE))
		{
			FeatAdd(oPC,3764,FALSE);
		}
	}	
	if (nTotal > 23) //5
	{
		if (!GetHasFeat(3763, oPC, TRUE))
		{
			FeatAdd(oPC,3763,FALSE);
		}
	}	
	if (nTotal > 21) //4
	{
		if (!GetHasFeat(342, oPC, TRUE))
			FeatAdd(oPC,342,FALSE);		
	}	
	if (nTotal > 19) //3
	{
		if (!GetHasFeat(341, oPC, TRUE))
		{
			FeatAdd(oPC,341,FALSE);
		}
	}
	if (nTotal > 17) //2
	{
		if (!GetHasFeat(340, oPC, TRUE))
		{
			FeatAdd(oPC,340,FALSE);	
		}
	}
	if (nTotal > 15) //1
	{
		if (!GetHasFeat(304, oPC, TRUE))
		{
			FeatAdd(oPC,304,FALSE);
		}
	}
	
	
	
}

effect GetSwiftbladeSurgeEffect(object oPC)
{

	int nSwiftblade = GetLevelByClass(CLASS_SWIFTBLADE, oPC);
	int iBonus;
	int nDamageBonus=0;
		
	if (nSwiftblade == 10)
	{
		iBonus = 2;		
		nDamageBonus = DAMAGE_BONUS_2d6;

	}
	else	
	if (nSwiftblade > 6)
	{
		iBonus = 2;
		nDamageBonus = DAMAGE_BONUS_1d6;
	}
	else
	{
		iBonus = 1;
	}

	effect eAtk = EffectAttackIncrease(iBonus);
	effect eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, iBonus, SAVING_THROW_TYPE_ALL);
	effect eAC = EffectACIncrease(iBonus, AC_DODGE_BONUS);
	
	effect eLink = EffectLinkEffects(eReflex, eAtk);
	eLink = EffectLinkEffects(eLink, eAC);
		
	if (nDamageBonus != 0)
	{
		effect eDmg = EffectDamageIncrease(nDamageBonus, DAMAGE_TYPE_PIERCING);
		eLink = EffectLinkEffects(eLink, eDmg);		
	}
	
	return eLink;

}

float GetSwiftbladeHasteDuration(int nSwiftblade, float fDuration)
{
	int nMeta = GetMetaMagicFeat();
	if (nMeta == METAMAGIC_PERSISTENT)
	{
		return fDuration;
	}
		
	if (nSwiftblade > 8)
	{
		fDuration += 6;
	}
	else if (nSwiftblade > 2)
	{
		fDuration += 3;
	}	
	return fDuration;
}

effect GetSwiftbladeHasteEffect (int nSwiftblade, effect eLink)
{
	switch (nSwiftblade)
	{
		case 2:
			{
			effect eConceal = EffectConcealment(20);
			eLink = EffectLinkEffects(eConceal, eLink);
			}
			break;
		case 3:
			{
			effect eConceal = EffectConcealment(30);
			eLink = EffectLinkEffects(eConceal, eLink);
			}
			break;
		case 4:
			{
			effect eConceal = EffectConcealment(40);
			eLink = EffectLinkEffects(eConceal, eLink);
			}
			break;
		case 5:
			{
			effect eConceal = EffectConcealment(50);
			eLink = EffectLinkEffects(eConceal, eLink);
			effect eSR = EffectSpellResistanceIncrease(15);
			eLink = EffectLinkEffects(eSR, eLink);
			}
			break;
		case 6:
			{
			effect eConceal = EffectConcealment(50);
			eLink = EffectLinkEffects(eConceal, eLink);
			effect eSR = EffectSpellResistanceIncrease(10 + GetHitDice(OBJECT_SELF));
			eLink = EffectLinkEffects(eSR, eLink);
			eLink = SupernaturalEffect(eLink);
			}
			break;
		case 7:
			{
			effect eConceal = EffectConcealment(50);
			eLink = EffectLinkEffects(eConceal, eLink);
			effect eSR = EffectSpellResistanceIncrease(10 + GetHitDice(OBJECT_SELF));
			eLink = EffectLinkEffects(eSR, eLink);
			eLink = SupernaturalEffect(eLink);
			}
			break;
		case 8:
			{
			effect eConceal = EffectConcealment(50);
			eLink = EffectLinkEffects(eConceal, eLink);
			effect eSR = EffectSpellResistanceIncrease(10 + GetHitDice(OBJECT_SELF));
			eLink = EffectLinkEffects(eSR, eLink);
			effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
			effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
			effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
			effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
			eLink = EffectLinkEffects(eLink, eParal);
			eLink = EffectLinkEffects(eLink, eEntangle);
			eLink = EffectLinkEffects(eLink, eSlow);
			eLink = EffectLinkEffects(eLink, eMove);
			eLink = SupernaturalEffect(eLink);
			}
			break;
		case 9:
			{
			effect eConceal = EffectConcealment(50);
			eLink = EffectLinkEffects(eConceal, eLink);
			effect eSR = EffectSpellResistanceIncrease(10 + GetHitDice(OBJECT_SELF));
			eLink = EffectLinkEffects(eSR, eLink);
			effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
			effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
			effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
			effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
			eLink = EffectLinkEffects(eLink, eParal);
			eLink = EffectLinkEffects(eLink, eEntangle);
			eLink = EffectLinkEffects(eLink, eSlow);
			eLink = EffectLinkEffects(eLink, eMove);
			eLink = SupernaturalEffect(eLink);
			}
			break;
		case 10:
			{
			effect eConceal = EffectConcealment(50);
			eLink = EffectLinkEffects(eConceal, eLink);
			effect eSR = EffectSpellResistanceIncrease(10 + GetHitDice(OBJECT_SELF));
			eLink = EffectLinkEffects(eSR, eLink);
			effect eParal = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
			effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
			effect eSlow = EffectImmunity(IMMUNITY_TYPE_SLOW);
			effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
			eLink = EffectLinkEffects(eLink, eParal);
			eLink = EffectLinkEffects(eLink, eEntangle);
			eLink = EffectLinkEffects(eLink, eSlow);
			eLink = EffectLinkEffects(eLink, eMove);
			eLink = SupernaturalEffect(eLink);
			}
			break;
	}
	return eLink;
}

int isRangedWeaponEquipped(object oPC)
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
	if (GetIsObjectValid(oWeapon))
	{
		//int nBaseItemType = GetBaseItemType(oWeapon);
		if (GetWeaponRanged(oWeapon))
		{
			return TRUE;
		}
	}
	return FALSE;	
}

void EvaluateRWM(object oPC = OBJECT_SELF)
{
	// testing things DISABLED
	//return;
	// end testing

	int iSpellId = SPELLABILITY_Ranged_Weapon_Mastery;
	int bRWMStateValid = isRangedWeaponEquipped(oPC);
	//SendMessageToPC(oPC,"TempStateValid: "+IntToString(bTempestStateValid));
	int bHasRWM = GetHasSpellEffect(iSpellId,oPC);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );
	
	if (bRWMStateValid)
	{
				effect eAB = SupernaturalEffect(EffectAttackIncrease(2));
				effect eDmg;
				object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
				if (GetBaseItemType(oWeapon) == BASE_ITEM_SLING)
				{
					eDmg = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BLUDGEONING));
				}
				else
				{
					eDmg = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_PIERCING));
				}
				effect eLink = SupernaturalEffect(EffectLinkEffects(eAB,eDmg));
				eLink = SetEffectSpellId(eLink,iSpellId);
				
				if (!bHasRWM)
				{
					SendMessageToPC(oPC,"Ranged Weapon Mastery enabled.");
				}
				DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(48), iSpellId ));		
	}
	else
	{
		if (bHasRWM)
		{
			SendMessageToPC(oPC,"Ranged Weapon Mastery disabled, it is only valid when wielding a ranged weapon.");
		}
	}	
}



int GetStormSongCasterLevel(object oPC)
{
	int iCasterLevel = 0;
	if (GetLevelByClass(CLASS_STORMSINGER, oPC) > 1)
	{
		iCasterLevel += 2;
	}
	iCasterLevel += GetSkillRank(SKILL_PERFORM,oPC);
	return iCasterLevel;	
	
}



int IsXbowSniperValid()
{
    object oWeapon    = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	if	(GetIsObjectValid(oWeapon))
	{
		if (CSLItemGetIsRangedWeapon(oWeapon))
		{
			int nBaseItemType = GetBaseItemType(oWeapon);
			if (nBaseItemType == BASE_ITEM_LIGHTCROSSBOW)
			{
				if (GetHasFeat(93,OBJECT_SELF,TRUE))
				{
					return TRUE;
				}
				else
				{
					return FALSE;
				}
			}
			else
			if (nBaseItemType == BASE_ITEM_HEAVYCROSSBOW)
			{
				if (GetHasFeat(92,OBJECT_SELF,TRUE))
				{
					return TRUE;
				}
				else
				{
					return FALSE;
				}
			}
			else
			{
				return FALSE;
			}
		}
		else
		{
			return FALSE;
		}

	}
	return FALSE;	
}

int IsBladesingerValid()
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oWeapon2    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
		
	if	(GetIsObjectValid(oWeapon))
	{
		int nBaseItemType = GetBaseItemType(oWeapon);	
		
		if (nBaseItemType != BASE_ITEM_RAPIER)
		{
			if (nBaseItemType != BASE_ITEM_LONGSWORD)
			{
				if (nBaseItemType != BASE_ITEM_ALLUSE_SWORD)
				{
					return FALSE;
				}
			}
		}	
		
	}
	else
	{
		return FALSE;
	}
	if	(GetIsObjectValid(oWeapon2))
	{
		if (CSLItemGetIsMeleeWeapon(oWeapon2) || CSLItemGetIsRangedWeapon(oWeapon2))
		{
			return FALSE;
		}
		int nBaseItemType = GetBaseItemType(oWeapon2);		
	    if (nBaseItemType == BASE_ITEM_LARGESHIELD || nBaseItemType == BASE_ITEM_SMALLSHIELD || nBaseItemType == BASE_ITEM_TOWERSHIELD)
	    {
			return FALSE;
		}
	}	
	
	if ( GetIsObjectValid(oArmor))
	{
		if (( GetArmorRank(oArmor) == ARMOR_RANK_HEAVY)  || (GetArmorRank(oArmor) ==  ARMOR_RANK_MEDIUM) )
		{
			return FALSE;
		}	
	}
					
	return TRUE;

}

void StackDeathAttack(object oPC)
{
	int nAssassin = GetLevelByClass(30,oPC);
	int nAvenger = GetLevelByClass(CLASS_TYPE_AVENGER,oPC);
	int nBFZ = GetLevelByClass(CLASS_BLACK_FLAME_ZEALOT,oPC);

	int iDice = 0;

	//Assassin/Avenger is 1,3,5,7,9,11,13,15,17,19
	//BFZ is 3,6,9
							
	if (nAssassin > 0)
	{
		iDice += ((nAssassin+1)/2);
	}
	if (nAvenger > 0)
	{
		iDice += ((nAvenger+1)/2);	
	}	
	
	if (nBFZ > 2)
	{
		if (nBFZ > 8)
		{
			iDice += 3;
		}
		else if (nBFZ > 5)
		{
			iDice += 2;
		}
		else
		{
			iDice += 1;
		}
	}
	
	if (iDice > 20)
	{
		iDice = 20;
	}
	
	if (iDice > 0)
	{
		int iFeatCurrent=0;
		
		if (iDice > 8) // 9+
		{
			for (iFeatCurrent = 455; iFeatCurrent< 460; iFeatCurrent++)
			{
				FeatAdd(oPC, iFeatCurrent,FALSE);
			}
			FeatAdd(oPC, 1004,FALSE); //6	
			FeatAdd(oPC, 1005,FALSE); //7			
			FeatAdd(oPC, 1006,FALSE); //8
			
			int iFeatLast = 1019 + (iDice - 8);
			for (iFeatCurrent = 1019; iFeatCurrent< iFeatLast; iFeatCurrent++)
			{
				FeatAdd(oPC, iFeatCurrent,FALSE);
			}								
		}
		else if (iDice > 5) // 6-8
		{
			for (iFeatCurrent = 455; iFeatCurrent< 460; iFeatCurrent++)
			{
				FeatAdd(oPC, iFeatCurrent,FALSE);
			}
			if (iDice == 6)
			{
				FeatAdd(oPC, 1004,FALSE); //6
			}
			else if (iDice == 7)
			{
				FeatAdd(oPC, 1004,FALSE); //6	
				FeatAdd(oPC, 1005,FALSE); //7
			}
			else //8
			{
				FeatAdd(oPC, 1004,FALSE); //6	
				FeatAdd(oPC, 1005,FALSE); //7			
				FeatAdd(oPC, 1006,FALSE); //8
			}					
		}
		else //1-5
		{
			int iFeatLast = 455 + (iDice);
			for (iFeatCurrent = 455; iFeatCurrent< iFeatLast; iFeatCurrent++)
			{
				FeatAdd(oPC, iFeatCurrent,FALSE);
			}										
		}
	
	
	}
		
}


void CleanBadDice(object oPC, int iFeatLast, int iDice)
{
		int iFeatCurrent=0;	
		//iFeatLast = 1032 + (iDice - 10); 1037+
		int iFeatBadLast= 1032 + (iDice);
		for (iFeatCurrent = iFeatLast; iFeatCurrent< iFeatBadLast; iFeatCurrent++) //11-20
		{
			if (GetHasFeat(iFeatCurrent, oPC, TRUE))
			{
				FeatRemove(oPC, iFeatCurrent);
			}
		}	
}


void SCStackSneakAttack(object oPC)
{

	//SendMessageToPC(oPC,"SCStackSneakAttack");
	int nNightsongEnforcer = GetLevelByClass(CLASS_NIGHTSONG_ENFORCER,oPC);
	int nNightsongInfiltrator = GetLevelByClass(CLASS_NIGHTSONG_INFILTRATOR,oPC);
	int nRogue = GetLevelByClass(8,oPC);
	int nDreadCommando = GetLevelByClass(CLASS_DREAD_COMMANDO,oPC);
	int nShadStalk = GetLevelByClass(CLASS_SHADOWBANE_STALKER,oPC);
	int nWhirlDerv = GetLevelByClass(CLASS_WHIRLING_DERVISH, oPC);
	int nDarkLantern = GetLevelByClass(CLASS_DARK_LANTERN,oPC);
	int nSkullclanHunter = GetLevelByClass(CLASS_SKULLCLAN_HUNTER,oPC);
	int nThug = GetLevelByClass(CLASS_THUG,oPC);
	int nCharnag = GetLevelByClass(CLASS_CHARNAG_MAELTHRA, oPC);
	
	int nNinja = GetLevelByClass(CLASS_NINJA,oPC);
	int nGFK = GetLevelByClass(CLASS_GHOST_FACED_KILLER,oPC);
	int nDreadPirate = GetLevelByClass(CLASS_DREAD_PIRATE,oPC);
	int nDagMage = GetLevelByClass(CLASS_DAGGERSPELL_MAGE,oPC);
	int nDagShape = GetLevelByClass(CLASS_DAGGERSPELL_SHAPER,oPC);
	int nWildStlk = GetLevelByClass(CLASS_WILD_STALKER,oPC);
	int nScout = GetLevelByClass(CLASS_SCOUT,oPC);
	
	
	if (GetHasFeat(FEAT_DARING_OUTLAW , oPC))
	{
		int nSwash = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC);
		int nDaringOutlawCap = CSLGetPreferenceInteger("DaringOutlawCap",0);
		if (nDaringOutlawCap > 0)
		{
			if (nSwash > nDaringOutlawCap)
			{
				nSwash = nDaringOutlawCap;
			}
		}
		nRogue += nSwash;
	}
	
	int iDice = 0;
	
	//Rogue is 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29
	//NE is 1,4,7,10
	//NI is 4,8	
	//DL is 2,4,6,8,10
	//SH is 3,6,9
	//Scout is 1,5,9
	
	int iFeatCurrent=0;	
	int iFeatLast=0;
	if (nCharnag > 0)
	{
		iDice += ((nCharnag + 1)/2);
	}


	if (nNinja > 0)
	{
		nRogue += nNinja;
		//iDice += ((nNinja+1)/2);
	}	
	if (nGFK > 1)
	{
		iDice += ((nGFK+1)/3);
	}		
	if (nDagMage > 2)
	{
		iDice += nDagMage/3;
	}	
	if (nDagShape > 2)
	{
		iDice += nDagShape/3;
	}	
	if (nWildStlk > 1)
	{
		iDice += ((nWildStlk+2)/4);
	}	
	if (nScout > 0)
	{
		if (GetHasFeat(FEAT_SWIFT_AMBUSHER , oPC))
		{
			nRogue += nScout;
			nScout = 0;
		}
		if (GetHasFeat(FEAT_SWIFT_HUNTER , oPC))
		{
			nScout += GetLevelByClass(CLASS_TYPE_RANGER,oPC);
			//iDice += ((nScout+nRanger+1)/2);
		}		
		iDice += (1 + ((nScout - 1)/4));
	}
	
	if (nShadStalk > 2)
	{
		iDice += nShadStalk/3;
	}
	
	if (nWhirlDerv > 2)
	{
		iDice += nWhirlDerv/3;
	}	

	if (nDarkLantern > 1)
	{
		iDice += nDarkLantern/2;
	}	
	
	if (nSkullclanHunter > 2)
	{
		iDice += (nSkullclanHunter / 3 );
	}			
	
	if (nDreadCommando > 0)
	{
		iDice += ((nDreadCommando+1)/2);
	}
	if (nThug > 0)
	{
		iDice += (nThug/2);
	}	
	if (nRogue > 0)
	{
		iDice += ((nRogue+1)/2);
	}
	if (nNightsongEnforcer > 0)
	{	
		iDice += ( (nNightsongEnforcer+2) /3 );
	}	
	if (nNightsongInfiltrator > 3)
	{
		if (nNightsongInfiltrator > 7)
		{
			iDice += 2;
		}
		else
		{
			iDice += 1;
		}
	}	
	//SendMessageToPC(oPC,IntToString(iDice));		
	//1 is 221
	//2-10 is 345-353
	//11-20 is 1032-1041
	
	if (iDice > 20)
	{
		iDice = 20;
	}
	
	if (iDice > 10) //11-20
	{
		//iFeatLast = 1032 + (iDice);
		
		iFeatLast = 1032 + (iDice - 10);
		CleanBadDice(oPC, iFeatLast, iDice);	
		
		FeatAdd(oPC, 221,FALSE); //1
		for (iFeatCurrent = 345; iFeatCurrent< 354; iFeatCurrent++) //2-10
		{
			FeatAdd(oPC, iFeatCurrent,FALSE);
		}						
		for (iFeatCurrent = 1032; iFeatCurrent< iFeatLast; iFeatCurrent++) //11-20
		{
			FeatAdd(oPC, iFeatCurrent,FALSE);
		}	
	}
	else if (iDice > 1) // 2-10
	{
		iFeatLast = 345 + (iDice - 1);
		
		FeatAdd(oPC, 221,FALSE); //1			
		for (iFeatCurrent = 345; iFeatCurrent< iFeatLast; iFeatCurrent++) //2-10
		{
			FeatAdd(oPC, iFeatCurrent,FALSE);
		}	

	}
	else if (iDice == 1) //1
	{
		FeatAdd(oPC, 221,FALSE); //1	
	}	
}



int GetAbilityScoreByAbility(object oPC, int iAbility)
{
	if (GetHasFeat(FEAT_SPELLCASTING_PRODIGY,oPC))
	{
		CSLGetNaturalAbilityScore( oPC, iAbility )+2;
	}
	return CSLGetNaturalAbilityScore( oPC, iAbility );
}

int GetAbilitySpellBonusByLevel(object oPC, int Spell_Level, int AbilityScore)
{
	
	string ColumnName = ("L" + IntToString(Spell_Level));
	string sBonus = Get2DAString("cmi_spellbonus",ColumnName,AbilityScore);	

	return StringToInt(sBonus);
}

void AddBGFeats(object oPC)
{

	int nAbilityScore = GetAbilityScoreByAbility(oPC, ABILITY_WISDOM);
	int nBonus1 = GetAbilitySpellBonusByLevel(oPC,1,nAbilityScore);
	int nBonus2 = GetAbilitySpellBonusByLevel(oPC,2,nAbilityScore);
	int nBonus3 = GetAbilitySpellBonusByLevel(oPC,3,nAbilityScore);
	int nBonus4 = GetAbilitySpellBonusByLevel(oPC,4,nAbilityScore);
	
	int iCount1=0;
	int iCount2=0;
	int iCount3=0;
	int iCount4=0;			
	int iCurrent=0;
	int iFeat=0;
						
	int iLevel = GetLevelByClass(31,oPC);
	int nKoT = GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oPC);
	int nDrSlr = GetLevelByClass(CLASS_DRAGONSLAYER, oPC);
	int nChildNight = GetLevelByClass(CLASS_CHILD_NIGHT, oPC);
	if (nKoT > 0 && GetHasFeat(FEAT_KOT_SPELLCASTING_BLACKGUARD, oPC))
	{
		iLevel += nKoT;
	}
	if (nChildNight > 0 && GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_BLACKGUARD, oPC))
	{
		iLevel += nChildNight;
	}
	if (nDrSlr > 0 && GetHasFeat(FEAT_DRSLR_SPELLCASTING_BLACKGUARD, oPC))
	{
		iLevel += nDrSlr / 2;				
	}
	if (iLevel > 10)
	{
		iLevel = 10;
	}
	switch (iLevel)
	{
			
	case 1:
		{

			iCount1 = 0 + nBonus1;
			iCount2 = -10 + nBonus2;
			iCount3 = -10 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;
		
			
		case 2:
		{

			iCount1 = 1 + nBonus1;
			iCount2 = -10 + nBonus2;
			iCount3 = -10 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;
		
		case 3:
		{

			iCount1 = 1 + nBonus1;
			iCount2 = 0 + nBonus2;
			iCount3 = -10 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;

		case 4:
		{

			iCount1 = 1 + nBonus1;
			iCount2 = 1 + nBonus2;
			iCount3 = -10 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;
		
		case 5:
		{

			iCount1 = 1 + nBonus1;
			iCount2 = 1 + nBonus2;
			iCount3 = 0 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;
		
		case 6:
		{

			iCount1 = 1 + nBonus1;
			iCount2 = 1 + nBonus2;
			iCount3 = 1 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;
		
		case 7:
		{

			iCount1 = 2 + nBonus1;
			iCount2 = 1 + nBonus2;
			iCount3 = 1 + nBonus3;
			iCount4 = 0 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;				
		
		case 8:
		{

			iCount1 = 2 + nBonus1;
			iCount2 = 1 + nBonus2;
			iCount3 = 1 + nBonus3;
			iCount4 = 1 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;
						
		case 9:
		{

			iCount1 = 2 + nBonus1;
			iCount2 = 2 + nBonus2;
			iCount3 = 1 + nBonus3;
			iCount4 = 1 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;				
															
		case 10:
		{

			iCount1 = 2 + nBonus1;
			iCount2 = 2 + nBonus2;
			iCount3 = 2 + nBonus3;
			iCount4 = 1 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3011;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3016;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3021;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3025;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;				
															
		default:
		break;			
	
	
	}
			
												
													
}

void SCAddASNFeats(object oPC)
{
	int nAbilityScore = GetAbilityScoreByAbility(oPC, ABILITY_INTELLIGENCE);
	int nBonus1 = GetAbilitySpellBonusByLevel(oPC,1,nAbilityScore);
	int nBonus2 = GetAbilitySpellBonusByLevel(oPC,2,nAbilityScore);
	int nBonus3 = GetAbilitySpellBonusByLevel(oPC,3,nAbilityScore);
	int nBonus4 = GetAbilitySpellBonusByLevel(oPC,4,nAbilityScore);
	
	int iCount1=0;
	int iCount2=0;
	int iCount3=0;
	int iCount4=0;			
	int iCurrent=0;
	int iFeat=0;
						
	int iLevel = GetLevelByClass(30,oPC);
	int nLevel2 = GetLevelByClass(142,oPC);
	
	int nKoT = GetLevelByClass(CLASS_KNIGHT_TIERDRIAL, oPC);
	int nDrSlr = GetLevelByClass(CLASS_DRAGONSLAYER, oPC);
	int nChildNight = GetLevelByClass(CLASS_CHILD_NIGHT, oPC);

	

	if (nChildNight > 0 && GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_ASSASSIN, oPC))
	{
		iLevel += nChildNight;
	}
	else if (nChildNight > 0 && GetHasFeat(FEAT_CHLDNIGHT_SPELLCASTING_AVENGER, oPC))
	{
		nLevel2 += nChildNight;
	}
	if (nKoT > 0 && GetHasFeat(FEAT_KOT_SPELLCASTING_ASSASSIN, oPC))
	{
		iLevel += nKoT;
	}
	else if (nKoT > 0 && GetHasFeat(FEAT_KOT_SPELLCASTING_AVENGER, oPC))
	{
		nLevel2 += nKoT;
	}
	
	if (nDrSlr > 0 && GetHasFeat(FEAT_DRSLR_SPELLCASTING_ASSASSIN, oPC))
	{
		iLevel += nDrSlr / 2;
	}
	else if (nDrSlr > 0 && GetHasFeat(FEAT_DRSLR_SPELLCASTING_AVENGER, oPC))
	{
		nLevel2 += nDrSlr / 2;
	}
	if (nLevel2 > iLevel)
	{
		iLevel = nLevel2;
	}
	//Only use the higher of the two, they shouldn't be on the same character
	
	
	if (iLevel > 10)
	{
		iLevel = 10;
	}
	
	switch (iLevel)
	{
	
				
	case 1:
		{

			iCount1 = 0 + nBonus1;
			iCount2 = -10 + nBonus2;
			iCount3 = -10 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3045;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;
		
			
		case 2:
		{

			iCount1 = 1 + nBonus1;
			iCount2 = -10 + nBonus2;
			iCount3 = -10 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3045;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}															
			
		}
		break;
		
		case 3:
		{

			iCount1 = 2 + nBonus1;
			iCount2 = 0 + nBonus2;
			iCount3 = -10 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3045;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}						
			
		}
		break;

		case 4:
		{

			iCount1 = 3 + nBonus1;
			iCount2 = 1 + nBonus2;
			iCount3 = -10 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3045;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}					
		}
		break;
		
		case 5:
		{

			iCount1 = 3 + nBonus1;
			iCount2 = 2 + nBonus2;
			iCount3 = 0 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3045;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}					
		}
		break;
		
		case 6:
		{

			iCount1 = 3 + nBonus1;
			iCount2 = 3 + nBonus2;
			iCount3 = 1 + nBonus3;
			iCount4 = -10 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3045;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}					
		}
		break;
		
		case 7:
		{

			iCount1 = 3 + nBonus1;
			iCount2 = 3 + nBonus2;
			iCount3 = 2 + nBonus3;
			iCount4 = 0 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3045;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}					
		}
		break;				
		
		case 8:
		{

			iCount1 = 3 + nBonus1;
			iCount2 = 3 + nBonus2;
			iCount3 = 3 + nBonus3;
			iCount4 = 1 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3046;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}					
		}
		break;
						
		case 9:
		{

			iCount1 = 3 + nBonus1;
			iCount2 = 3 + nBonus2;
			iCount3 = 3 + nBonus3;
			iCount4 = 2 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3046;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}					
		}
		break;				
															
		case 10:
		{

			iCount1 = 3 + nBonus1;
			iCount2 = 3 + nBonus2;
			iCount3 = 3 + nBonus3;
			iCount4 = 3 + nBonus4;
			
			if (iCount1 > 0)
			{
				iCurrent=0;
				iFeat = 3028;
				for (iCurrent = 0; iCurrent < iCount1; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}	
			}
			if (iCount2 > 0)
			{
				iCurrent=0;
				iFeat = 3034;
				for (iCurrent = 0; iCurrent < iCount2; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount3 > 0)
			{
				iCurrent=0;
				iFeat = 3040;
				for (iCurrent = 0; iCurrent < iCount3; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}
			if (iCount4 > 0)
			{
				iCurrent=0;
				iFeat = 3046;
				for (iCurrent = 0; iCurrent < iCount4; iCurrent++)
				{
					FeatAdd(oPC,iFeat+iCurrent,FALSE);
				}						
			}					
		}
		break;				
															
		default:
		break;			
	
	
	}												
													
}

int IsSnowflakeValid(object oPC, int bAllowTwoHanded = FALSE)
{

	object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
		
	int bArmor = FALSE;
	int nArmorRank = ARMOR_RANK_NONE;
 	if (GetIsObjectValid(oItem))
		nArmorRank = GetArmorRank(oItem);
	if (nArmorRank == ARMOR_RANK_NONE || nArmorRank == ARMOR_RANK_LIGHT)
		bArmor = TRUE;
	else
		bArmor = FALSE;	
		
	int bShield = FALSE;		
	oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);	
 	if (GetIsObjectValid(oItem))
	{
		int nBaseItemType = GetBaseItemType(oItem);
		if (nBaseItemType == BASE_ITEM_SMALLSHIELD || 
		nBaseItemType == BASE_ITEM_TOWERSHIELD ||
		nBaseItemType == BASE_ITEM_LARGESHIELD)
			bShield = TRUE;
	}
	int bSlashing = IsMWM_SValid();	
	
	if (bSlashing && (bAllowTwoHanded == FALSE))
	{
    	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		int nBaseItemType = GetBaseItemType(oWeapon);
		if (nBaseItemType == BASE_ITEM_SCYTHE || nBaseItemType == BASE_ITEM_HALBERD || nBaseItemType == BASE_ITEM_GREATSWORD  || nBaseItemType == BASE_ITEM_GREATAXE || nBaseItemType == BASE_ITEM_FALCHION)
			bSlashing = FALSE;		
	}
	
	if (bSlashing && !bShield && bArmor)
		return TRUE;
	else
		return FALSE;
}

void IsSnowflakeStillValid(object oPC, int bAllowTwoHanded = FALSE)
{
	int bValid = IsSnowflakeValid(oPC,bAllowTwoHanded);
	int bHasEffects = GetHasSpellEffect(SONG_SNOWFLAKE_WARDANCE, oPC);
	if (bHasEffects == TRUE && bValid == FALSE)
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SONG_SNOWFLAKE_WARDANCE );
		if ( !GetHasSpellEffect(-SONG_SNOWFLAKE_WARDANCE, oPC) )
		{
			SendMessageToPC(oPC, "You must be wearing light or no armor and wielding a one-handed slashing weapon (both must be slashing if two weapons are used).");
			SendMessageToPC(oPC, "You have been penalized with a -10 AB penalty for 10 rounds for trying to exploit snowflake wardance. Do not change your weapon or armor while the song is active.");
			effect eAB = EffectAttackDecrease(10);
			eAB = SetEffectSpellId(eAB, -SONG_SNOWFLAKE_WARDANCE);
			eAB = ExtraordinaryEffect(eAB);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAB, oPC, RoundsToSeconds(10));
		}
	}
}


//* changing this to use the CSL summon boost
void BuffSummons(object oPC, int nElemental = 0, int nAshbound = 0)
{
	object oTarget = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
	if (GetHasFeat(FEAT_BECKON_THE_FROZEN, oPC))
	{
		effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
		effect eDmgImm = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0);
		effect eDmgVul = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50);
		effect eLink = EffectLinkEffects(eDmgVul, eDmgImm);
		eLink = EffectLinkEffects(eLink, eDmg);
		eLink = SetEffectSpellId(eLink,FEAT_BECKON_THE_FROZEN);
		eLink = SupernaturalEffect(eLink);	
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
	}
	
	if (nElemental == 1 && GetHasFeat(FEAT_AUGMENT_ELEMENTAL, oPC))
	{	
		effect eLink = EffectTemporaryHitpoints(GetHitDice(oTarget)*2);
		eLink = SetEffectSpellId(eLink,FEAT_AUGMENT_ELEMENTAL);
		eLink = SupernaturalEffect(eLink);	
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
		
		itemproperty iEnhance = ItemPropertyEnhancementBonus(2);	
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
		if (GetIsObjectValid(oWeapon))
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
		}
		
		oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
		if (GetIsObjectValid(oWeapon))
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
		}
		
		oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
		if (GetIsObjectValid(oWeapon))
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, iEnhance, oWeapon);
		}
	
	}
	
	if (nAshbound == 1 && GetHasFeat(FEAT_ASHBOUND, oPC))
	{
		effect eLink = EffectAttackIncrease(3);
		eLink = SetEffectSpellId(eLink,FEAT_ASHBOUND);
		eLink = SupernaturalEffect(eLink);	
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
	}

}



effect IncorporealEffect(object oTarget)
{

	int nChaAC = GetAbilityModifier(ABILITY_CHARISMA, oTarget);
	effect eAC = EffectACIncrease(nChaAC, AC_DEFLECTION_BONUS);
	effect eConceal = EffectConcealment(50);
	effect eSR = EffectSpellResistanceIncrease(25);
	
	effect eLink = EffectLinkEffects(eAC,eConceal);
	eLink = EffectLinkEffects(eSR, eLink);
	eLink = SupernaturalEffect(eLink);

	return eLink;
	
}

void ApplyPhantomStats(object oOwner)
{
	object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oOwner);
	effect eLink = IncorporealEffect(oSummon);
	effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_2d10, DAMAGE_TYPE_COLD);
	eLink = EffectLinkEffects(eDamage, eLink);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon));
}











int GetDamageByDiceString(string sDice, int nNum)
{

	int iDamage = 1;
	if (sDice == "d2")
		iDamage = d3(nNum);
	else
	if (sDice == "d3")
		iDamage = d3(nNum);
	else
	if (sDice == "d4")
		iDamage = d3(nNum);
	else
	if (sDice == "d6")
		iDamage = d3(nNum);
	else
	if (sDice == "d8")
		iDamage = d3(nNum);
	else
	if (sDice == "d10")
		iDamage = d3(nNum);
	else
	if (sDice == "d12")
		iDamage = d3(nNum);													
	
	return iDamage;	
}

effect TOBGenerateAttackEffect(object oPC, object oWeapon, 
	int nbSlash = 0, int nbBlunt = 0, int nbPierce = 1, int nbAcid = 0, int nbCold = 0,
	int nbElec = 0, int nbFire = 0, int nbSonic = 0, int nbDivine = 0, 	int nbMagic = 0,
	int nbPosit = 0, int nbNegat = 0 )
	
{

	int nBaseItemType = GetBaseItemType(oWeapon); 
	int nIsRanged = GetWeaponRanged(oWeapon);
	
	string basedice = Get2DAString("baseitems", "DieToRoll", nBaseItemType);
	int nDiceNum = StringToInt( Get2DAString("baseitems", "NumDice", nBaseItemType) );
	
	int nBaseDamage = GetDamageByDiceString(basedice, nDiceNum);
	int nWeaponType = GetWeaponType(oWeapon);
	int nSlash = 0 + nbSlash;
	int nBlunt = 0 + nbBlunt;
	int nPierce = 1 + nbPierce;
	int nAcid = 0 + nbAcid;
	int nCold = 0 + nbCold;
	int nElec = 0 + nbElec;
	int nFire = 0 + nbFire;
	int nSonic = 0 + nbSonic;
	int nDivine = 0 + nbDivine;
	int nMagic = 0 + nbMagic;
	int nPosit = 0 + nbPosit;
	int nNegat = 0 + nbNegat;		
	
	int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	
	if (GetHasFeat(1957, oPC)) //Combat Insight
	{
		int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
		if (nIntMod > nStrMod)
		{
			if (!nIsRanged)
			{
				object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
				if (!GetIsObjectValid(oLeftHand))
				{
					//Two-Handed
					nStrMod = nStrMod + (((nIntMod - nStrMod)*3)/2);
				}
				else
				{
					//One-Handed
					nStrMod = nStrMod + (nIntMod - nStrMod);
				}	
			}
		
		}
				
	}
	nBaseDamage += nStrMod;
	
	//Needs Wpn Spec, Epic Wpn Spec
	
	if (GetHasFeat(1740, oPC)) //FEAT_PRECISE_STRIKE
	{
		object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
		if (!GetIsObjectValid(oLeftHand))
		{
			//Nothing in the left hand
			if (nWeaponType == WEAPON_TYPE_PIERCING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
			{
				//Valid Precise Strike weapon
				if (GetLevelByClass(CLASS_TYPE_DUELIST, oPC) == 10)
					nPierce += d6(2);
				else
					nPierce += d6(1);
			}
		}	
			
	}
	
	if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
		nSlash = nBaseDamage;
	else
	if (nWeaponType == WEAPON_TYPE_PIERCING)
		nPierce = nBaseDamage;
	else
	if (nWeaponType == WEAPON_TYPE_BLUDGEONING)
		nBlunt = nBaseDamage;		
	
	effect eEffect = GetFirstEffect(oPC);
	while(GetIsEffectValid(eEffect))
	{
		int nType = GetEffectType(eEffect);
		if(nType == EFFECT_TYPE_DAMAGE_INCREASE)
		{
//			int i0 = GetEffectInteger(eEffect, 0); //DamageBonus
//			int i1 = GetEffectInteger(eEffect, 1); //DamageType
			int iDamage = CSLGetDamageByDamageBonus(GetEffectInteger(eEffect, 0)); //DamageBonus
			
			switch (GetEffectInteger(eEffect, 1))  //DamageType
			{
				case DAMAGE_TYPE_ACID:
					nAcid += iDamage;
					break;
					
				case DAMAGE_TYPE_BLUDGEONING:
					nBlunt += iDamage;
					break;
					
				case DAMAGE_TYPE_COLD:
					nCold += iDamage;
					break;
					
				case DAMAGE_TYPE_DIVINE:
					nDivine += iDamage;
					break;	
					
				case DAMAGE_TYPE_ELECTRICAL:
					nElec += iDamage;
					break;
					
				case DAMAGE_TYPE_FIRE:
					nFire += iDamage;
					break;
					
				case DAMAGE_TYPE_MAGICAL:
					nMagic += iDamage;
					break;
					
				case DAMAGE_TYPE_NEGATIVE:
					nNegat += iDamage;
					break;	
					
				case DAMAGE_TYPE_PIERCING:
					nPierce += iDamage;
					break;
					
				case DAMAGE_TYPE_POSITIVE:
					nPosit += iDamage;
					break;
					
				case DAMAGE_TYPE_SLASHING:
					nSlash += iDamage;
					break;
					
				case DAMAGE_TYPE_SONIC:
					nSonic += iDamage;
					break;																									
					
			}
														
		}
		eEffect = GetNextEffect(oPC);
	}	
		
	int nEnhance = 0;	
	itemproperty iProp = GetFirstItemProperty(oWeapon);
	while (GetIsItemPropertyValid(iProp))
	{

		if (GetItemPropertyType(iProp)==ITEM_PROPERTY_DAMAGE_BONUS)
		{
		  	GetItemPropertyCostTableValue(iProp); //IP_CONST_DAMAGEBONUS
			GetItemPropertySubType(iProp); //IP_CONST_DAMAGETYPE
			
			int iDamage = CSLGetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
			
			switch (GetItemPropertySubType(iProp))  //DamageType
			{
				case IP_CONST_DAMAGETYPE_ACID:
					nAcid += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_BLUDGEONING:
					nBlunt += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_COLD:
					nCold += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_DIVINE:
					nDivine += iDamage;
					break;	
					
				case IP_CONST_DAMAGETYPE_ELECTRICAL:
					nElec += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_FIRE:
					nFire += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_MAGICAL:
					nMagic += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_NEGATIVE:
					nNegat += iDamage;
					break;	
					
				case IP_CONST_DAMAGETYPE_PHYSICAL:
					nSlash += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_PIERCING:
					nPierce += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_POSITIVE:
					nPosit += iDamage;
					break;
					
				case IP_CONST_DAMAGETYPE_SLASHING:
					nSlash += iDamage;
					break;		
					
				case IP_CONST_DAMAGETYPE_SONIC:
					nSonic += iDamage;
					break;																														
			}			
			
		}		
		else
		if (GetItemPropertyType(iProp)==ITEM_PROPERTY_ENHANCEMENT_BONUS)
		{
		  	int nItemEnhance = GetItemPropertyCostTableValue(iProp); //Enhance bonus
			if (nItemEnhance > nEnhance)
				nEnhance = nItemEnhance;
		}			
		iProp=GetNextItemProperty(oWeapon);
	}

	if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
		nSlash += nEnhance;
	else
	if (nWeaponType == WEAPON_TYPE_PIERCING)
		nPierce += nEnhance;
	else
	if (nWeaponType == WEAPON_TYPE_BLUDGEONING)
		nBlunt += nEnhance;	
		
	if ( nIsRanged )
	{
		int nBaseType = GetBaseItemType(oWeapon);
		object oAmmo;
		if (nBaseType == BASE_ITEM_LIGHTCROSSBOW || nBaseType == BASE_ITEM_HEAVYCROSSBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
		if (nBaseType == BASE_ITEM_LONGBOW || nBaseType == BASE_ITEM_SHORTBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
		if (nBaseType == BASE_ITEM_SLING)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);						
		
		int nEnhance = 0;	
		itemproperty iProp = GetFirstItemProperty(oAmmo);
		while (GetIsItemPropertyValid(iProp))
		{
	
			if (GetItemPropertyType(iProp)==ITEM_PROPERTY_DAMAGE_BONUS)
			{
			  	GetItemPropertyCostTableValue(iProp); //IP_CONST_DAMAGEBONUS
				GetItemPropertySubType(iProp); //IP_CONST_DAMAGETYPE
				
				int iDamage = CSLGetDamageByIPConstDamageBonus(GetItemPropertyCostTableValue(iProp));
				
				switch (GetItemPropertySubType(iProp))  //DamageType
				{
					case IP_CONST_DAMAGETYPE_ACID:
						nAcid += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_BLUDGEONING:
						nBlunt += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_COLD:
						nCold += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_DIVINE:
						nDivine += iDamage;
						break;	
						
					case IP_CONST_DAMAGETYPE_ELECTRICAL:
						nElec += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_FIRE:
						nFire += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_MAGICAL:
						nMagic += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_NEGATIVE:
						nNegat += iDamage;
						break;	
						
					case IP_CONST_DAMAGETYPE_PHYSICAL:
						nSlash += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_PIERCING:
						nPierce += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_POSITIVE:
						nPosit += iDamage;
						break;
						
					case IP_CONST_DAMAGETYPE_SLASHING:
						nSlash += iDamage;
						break;		
						
					case IP_CONST_DAMAGETYPE_SONIC:
						nSonic += iDamage;
						break;																														
				}			
				
			}		
			else
			if (GetItemPropertyType(iProp)==ITEM_PROPERTY_ENHANCEMENT_BONUS)
			{
			  	int nItemEnhance = GetItemPropertyCostTableValue(iProp); //Enhance bonus
				if (nItemEnhance > nEnhance)
					nEnhance = nItemEnhance;
			}			
			iProp=GetNextItemProperty(oAmmo);
		}
	
		if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
			nSlash += nEnhance;
		else
		if (nWeaponType == WEAPON_TYPE_PIERCING)
			nPierce += nEnhance;
		else
		if (nWeaponType == WEAPON_TYPE_BLUDGEONING)
			nBlunt += nEnhance;	
	
	
	}
			
	//Time to build a mega damage event	
	effect eLink = EffectDamage(nPierce, DAMAGE_TYPE_PIERCING);
	
	//= EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	
	if (nAcid > 0)
	{
		effect eDmg = EffectDamage(nAcid, DAMAGE_TYPE_ACID);
		eLink = EffectLinkEffects(eDmg, eLink);
	}
	
	if (nSlash > 0)
	{
		effect eDmg = EffectDamage(nSlash, DAMAGE_TYPE_SLASHING);
		eLink = EffectLinkEffects(eDmg, eLink);
	}
	
	if (nBlunt > 0)
	{
		effect eDmg = EffectDamage(nBlunt, DAMAGE_TYPE_BLUDGEONING);
		eLink = EffectLinkEffects(eDmg, eLink);
	}
	
	if (nCold > 0)
	{
		effect eDmg = EffectDamage(nCold, DAMAGE_TYPE_COLD);
		eLink = EffectLinkEffects(eDmg, eLink);
	}			
	
	if (nElec > 0)
	{
		effect eDmg = EffectDamage(nElec, DAMAGE_TYPE_ELECTRICAL);
		eLink = EffectLinkEffects(eDmg, eLink);
	}
	
	if (nFire > 0)
	{
		effect eDmg = EffectDamage(nFire, DAMAGE_TYPE_FIRE);
		eLink = EffectLinkEffects(eDmg, eLink);
	}
	
	if (nSonic > 0)
	{
		effect eDmg = EffectDamage(nSonic, DAMAGE_TYPE_SONIC);
		eLink = EffectLinkEffects(eDmg, eLink);
	}		
	
	if (nDivine > 0)
	{
		effect eDmg = EffectDamage(nDivine, DAMAGE_TYPE_DIVINE);
		eLink = EffectLinkEffects(eDmg, eLink);
	}			
	
	if (nMagic > 0)
	{
		effect eDmg = EffectDamage(nMagic, DAMAGE_TYPE_MAGICAL);
		eLink = EffectLinkEffects(eDmg, eLink);
	}
	
	if (nPosit > 0)
	{
		effect eDmg = EffectDamage(nPosit, DAMAGE_TYPE_POSITIVE);
		eLink = EffectLinkEffects(eDmg, eLink);
	}
	
	if (nNegat > 0)
	{
		effect eDmg = EffectDamage(nNegat, DAMAGE_TYPE_NEGATIVE);
		eLink = EffectLinkEffects(eDmg, eLink);
	}	
	
	return eLink;	

}


int GetAnimalCompanionLevel(object oPC)
{
	int nCompLevel = 0;
	if (GetHasFeat(1835 , oPC))
	{
		nCompLevel += GetLevelByClass(CLASS_TYPE_CLERIC , oPC); //Animal Domain Cleric
	}
	
	int nRanger = GetLevelByClass(CLASS_TYPE_RANGER , oPC); //Ranger
	if (nRanger > 3)
	{
		nCompLevel += (nRanger - 3);
	}
	
	nCompLevel += GetLevelByClass(CLASS_TYPE_DRUID , oPC); //Druid

	nCompLevel += GetLevelByClass(CLASS_LION_TALISID , oPC); //Lion of Talisid

	if (GetHasFeat(FEAT_DEVOTED_TRACKER, oPC))
	{
		int nPaladin = GetLevelByClass(CLASS_TYPE_PALADIN , oPC);
		nPaladin = nPaladin - 4;
		if (nPaladin > 0)
		{
			nCompLevel += nPaladin;
		}
	}
	
	if (GetHasFeat(FEAT_TELTHOR_COMPANION, oPC))
	{
		int nSS = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN , oPC);
		nSS = nSS - 3;
		if (nSS > 0)
		{
			nCompLevel += nSS;
		}
	}	
	
	if (GetHasFeat(FEAT_IMPROVED_NATURAL_BOND, oPC))
	{
		int nHD = GetHitDice(oPC);
		if (nHD > nCompLevel)
		{
			nCompLevel += 6;
			if (nCompLevel > nHD)
			{
				nCompLevel = nHD;
			}
		}	
	}
	else if (GetHasFeat(2106, oPC)) //Natural Bond
	{
		int nHD = GetHitDice(oPC);
		if (nHD > nCompLevel)
		{
			nCompLevel += 3;
			if (nCompLevel > nHD)
			{
				nCompLevel = nHD;
			}
		}
	}
	
	if (GetHasFeat(1959 , oPC)) //Epic Animal Companion
		nCompLevel += 3;	
	
	//Testing
	//nCompLevel += 10;
		
	return nCompLevel;

}

int GetAnimCompRange(object oPC)
{
	int nCompLevel = GetAnimalCompanionLevel(oPC);
	int nRange;
	if (nCompLevel > 2)
		nRange = (nCompLevel / 3) + 1;
	else 
		nRange = 1;
	//SendMessageToPC(oPC, IntToString(nRange));
	//SendMessageToPC(oPC, IntToString(nCompLevel));	
	return nRange;
}

string GetElemCompRange(object oPC)
{
	int nCompLevel = GetAnimalCompanionLevel(oPC);

	int nRange = 1;
	if (nCompLevel > 27)
		nRange = 6;
	else
	if (nCompLevel > 21)
		nRange = 5;
	else
	if (nCompLevel > 15)
		nRange = 4;
	else		
	if (nCompLevel > 9)
		nRange = 3;
	else
	if (nCompLevel > 3)
		nRange = 2;				
	
	//SendMessageToPC(oPC, "Range: " + IntToString(nRange));
	//SendMessageToPC(oPC, "Level: " + IntToString(nCompLevel));	
	return IntToString(nRange);
}

void SummonCMIAnimComp(object oPC)
{
	int nTelthor = 0;
	string sBlueprint = GetLocalString(oPC, "cmi_animcomp");
	string sRange;
	int nRange = GetAnimCompRange(oPC);
	sRange = IntToString(nRange);
	
	if (GetHasFeat(FEAT_TELTHOR_COMPANION, oPC))
	{
		sBlueprint = "cmi_ancom_telthor" + sRange;
		nTelthor = 1;
	}
	
	if (sBlueprint == "")
	{
			    
		SummonAnimalCompanion();
		object oComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
		string sTag = GetTag(oComp);
		//SendMessageToPC(oPC, "Tag: " + sTag);
		if (FindSubString(sTag, "blue") > -1)
		{
			sBlueprint = "c_ancom_blue" + sRange;	
		}
		else
		if (FindSubString(sTag, "bronze") > -1)
		{
			sBlueprint = "c_ancom_bronze" + sRange;	
		}
		else
		if (FindSubString(sTag, "dino") > -1)
		{
			sBlueprint = "c_ancom_dino" + sRange;	
		}
		else
		if (FindSubString(sTag, "elea") > -1)
		{
			sBlueprint = "cmi_ancom_elea" + GetElemCompRange(oPC);	
		}
		else
		if (FindSubString(sTag, "elee") > -1)
		{
			sBlueprint = "cmi_ancom_elee" + GetElemCompRange(oPC);	
		}
		else
		if (FindSubString(sTag, "elef") > -1)
		{
			sBlueprint = "cmi_ancom_elef" + GetElemCompRange(oPC);
		}
		else
		if (FindSubString(sTag, "elew") > -1)
		{
			sBlueprint = "cmi_ancom_elew" + GetElemCompRange(oPC);
		}
		else					
		if (FindSubString(sTag, "badger") > -1)
		{
			sBlueprint = "c_ancom_badger" + sRange;	
		}
		else
		if (FindSubString(sTag, "bear") > -1)
		{
			sBlueprint = "c_ancom_bear" + sRange;	
		}
		else
		if (FindSubString(sTag, "boar") > -1)
		{
			sBlueprint = "c_ancom_boar" + sRange;	
		}
		else
		if (FindSubString(sTag, "spider") > -1)
		{
			sBlueprint = "c_ancom_spider" + sRange;	
		}
		else
		if (FindSubString(sTag, "panther") > -1)
		{
			sBlueprint = "c_ancom_panther" + sRange;	
		}
		else
		if (FindSubString(sTag, "winter") > -1)
		{
			sBlueprint = "c_ancom_winter_wolf" + sRange;	
		}
		else
		if (FindSubString(sTag, "wolf") > -1)
		{
			sBlueprint = "c_ancom_wolf" + sRange;	
		}
		else
		if (FindSubString(sTag, "white_tiger") > -1)
		{
			sBlueprint = "c_ancom_white_tiger" + sRange;	
		}
	}
	
	if (GetHasFeat(2002, oPC, TRUE ))
	{
	    int nAlign = GetAlignmentGoodEvil(oPC);		
		if (nAlign == ALIGNMENT_GOOD || nAlign == ALIGNMENT_NEUTRAL)
		{
			sBlueprint = "c_ancom_bronze" + sRange;
		}
		else
		{
			sBlueprint = "c_ancom_blue" + sRange;
		}
	}
	else if (GetHasFeat(FEAT_DINOSAUR_COMPANION, oPC, TRUE ))
	{
		sBlueprint = "c_ancom_dino" + sRange;
	}
	else if (GetTag(OBJECT_SELF) == "co_umoja")
	{
		sBlueprint = "c_ancom_dino" + sRange;
	}
	SetLocalString(oPC, "cmi_animcomp", sBlueprint);
	SummonAnimalCompanion(oPC, sBlueprint); 				
	
	if (nTelthor)
	{
		SetFirstName( GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC), "Spirit of");
		SetLastName( GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC), "the Land");
	}	
	//object oComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
	//string sTag = GetTag(oComp);
	//SendMessageToPC(oPC, "Tag: " + sTag);	
}



void ApplySilverFangEffect(object oTarget)
{

  object oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
  if (GetIsObjectValid(oWeapon))
  {
	SetItemBaseMaterialType(oWeapon, GMATERIAL_METAL_ALCHEMICAL_SILVER); 
  } 

  oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
  if (GetIsObjectValid(oWeapon))
  {
	SetItemBaseMaterialType(oWeapon, GMATERIAL_METAL_ALCHEMICAL_SILVER);
  }

  oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
  if (GetIsObjectValid(oWeapon))
  {
	SetItemBaseMaterialType(oWeapon, GMATERIAL_METAL_ALCHEMICAL_SILVER);
  }
}


void InfuseDivineSpirit(object oPC)
{
	int nFixCompleted = GetLocalInt(oPC, "PaladinDivinelyInfused");
	if (!nFixCompleted)
	{
		int nPaladin = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
		if (nPaladin > 29)
		{
			//3601 - E
			//3602 - 5
			//3603 - 10
			//3604 - 15
			//3605 - 20
			//3693 - 25
			//3694 - 30	
			FeatAdd(oPC, 3601, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3602, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3603, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3604, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3605, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3693, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3694, FALSE, FALSE, FALSE);						
		}
		else
		if (nPaladin > 24)
		{
			//3601 - E
			//3602 - 5
			//3603 - 10
			//3604 - 15
			//3605 - 20
			//3693 - 25		
			FeatAdd(oPC, 3601, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3602, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3603, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3604, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3605, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3693, FALSE, FALSE, FALSE);
		}
		else
		if (nPaladin > 19)
		{
			//3601 - E
			//3602 - 5
			//3603 - 10
			//3604 - 15
			//3605 - 20	
			FeatAdd(oPC, 3601, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3602, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3603, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3604, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3605, FALSE, FALSE, FALSE);
		}
		else
		if (nPaladin > 14)
		{
			//3601 - E
			//3602 - 5
			//3603 - 10
			//3604 - 15
			FeatAdd(oPC, 3601, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3602, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3603, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3604, FALSE, FALSE, FALSE);		
		}
		else
		if (nPaladin > 9)
		{
			//3601 - E
			//3602 - 5
			//3603 - 10		
			FeatAdd(oPC, 3601, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3602, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3603, FALSE, FALSE, FALSE);
		}
		else
		if (nPaladin > 4)
		{
			//3601 - E
			//3602 - 5	
			FeatAdd(oPC, 3601, FALSE, FALSE, FALSE);
			FeatAdd(oPC, 3602, FALSE, FALSE, FALSE);
		}				
	}
	
}

void StackSpiritShaman(object oPC)
{
	int nSS = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC);
	int nCurrent = 0;
	
	//Spirit Form
	if (GetHasFeat(FEAT_EXTRA_SPIRIT_FORM, oPC))
	{
		int nSS = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC);
		if (nSS > 14)
			nCurrent = nSS/5 - 1;
		else
			nCurrent = 1;
			
		if (nCurrent == 5)
		{
//3700 - 6
//3701 - 7	
			FeatAdd(oPC, 3700, FALSE, FALSE, FALSE);	
			FeatAdd(oPC, 3701, FALSE, FALSE, FALSE);			
		}
		else
		if (nCurrent == 4)
		{
//2026 - 5		
//3700 - 6	
			FeatAdd(oPC, 2026, FALSE, FALSE, FALSE);	
			FeatAdd(oPC, 3700, FALSE, FALSE, FALSE);	
		}	
		else
		if (nCurrent == 3)
		{
//2025 - 4
//2026 - 5	
			FeatAdd(oPC, 2025, FALSE, FALSE, FALSE);	
			FeatAdd(oPC, 2026, FALSE, FALSE, FALSE);	
		}			
		else
		if (nCurrent == 2)
		{
//2024 - 3
//2025 - 4	
			FeatAdd(oPC, 2024, FALSE, FALSE, FALSE);	
			FeatAdd(oPC, 2025, FALSE, FALSE, FALSE);	
		}		
		else
		{
//2023 - 2
//2024 - 3	
			FeatAdd(oPC, 2023, FALSE, FALSE, FALSE);	
			FeatAdd(oPC, 2024, FALSE, FALSE, FALSE);	
		}		
			
	}
	
	//Spirit Journey
	if (GetHasFeat(FEAT_EXTRA_SPIRIT_JOURNEY, oPC))
	{
			FeatAdd(oPC, 3702, FALSE, FALSE, FALSE);	
			FeatAdd(oPC, 3703, FALSE, FALSE, FALSE);	
	}
	

}



void MakeStormy(object oCaster, object oWeapon, float fDuration )
{
	AssignCommand(oWeapon, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING), oCaster));
	
	if (GetHasFeat(FEAT_STORMLORD_SHOCK_WEAPON, oCaster, TRUE))
	{
		CSLSafeAddItemProperty(oWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d8), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	
	if (GetHasFeat(FEAT_STORMLORD_SHOCKING_BURST_WEAPON, oCaster, TRUE))
	{
		CSLSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
	}
	
	if (GetHasFeat(FEAT_STORMLORD_SONIC_WEAPON, oCaster, TRUE))
	{
		CSLSafeAddItemProperty(oWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d8), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
}

void DoStormWeapon(object oPC, object oItem)
{
	float fCnt = GetLocalFloat(oPC, "STORMWEAPON");
	if (fCnt > 0.0f ) {
		int nType = GetBaseItemType(oItem);
		if (nType==BASE_ITEM_DART || nType==BASE_ITEM_SHURIKEN || nType==BASE_ITEM_THROWINGAXE || nType==BASE_ITEM_SPEAR)
		{
			MakeStormy(oPC, oItem, fCnt);
		}
	}
}


int IsTempestStateValid()
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oWeapon2    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
	
    if (GetIsObjectValid(oWeapon2))
    {
		int nBaseItemType = GetBaseItemType(oWeapon2);
		
        if ( nBaseItemType ==BASE_ITEM_LARGESHIELD || nBaseItemType ==BASE_ITEM_SMALLSHIELD || nBaseItemType ==BASE_ITEM_TOWERSHIELD )
        {
            oWeapon2 = OBJECT_INVALID;
        }
    }
	
	if	(GetIsObjectValid(oWeapon))
	{
		int nBaseItemType = GetBaseItemType(oWeapon);
		if (GetWeaponRanged(oWeapon))
		{
			oWeapon = OBJECT_INVALID;
		}
	}
	
	int nArmorValid = 0;
	if ( GetIsObjectValid(oArmor))
	{
		if (( GetArmorRank(oArmor) == ARMOR_RANK_HEAVY)  || ( GetArmorRank(oArmor) ==  ARMOR_RANK_MEDIUM ) )
		{
			oArmor = OBJECT_INVALID;
		}
		else
		{
			nArmorValid = TRUE;
		}
		
	}
	else
	{
		nArmorValid = TRUE;
	}
	if ((oWeapon == OBJECT_INVALID) &&  (oWeapon2 == OBJECT_INVALID) &&  (nArmorValid == TRUE))	
	{
		object oCWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,OBJECT_SELF);
		object oCWeapon2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,OBJECT_SELF);
		if ((oCWeapon1 != OBJECT_INVALID) &&  (oCWeapon2 != OBJECT_INVALID))
		{
			return TRUE;
		}	
		else
			return FALSE;	
	}
	else
	
	
	if ( ( oWeapon != OBJECT_INVALID ) && ( oWeapon2 != OBJECT_INVALID ) &&  ( nArmorValid == TRUE ) )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

void EvaluateTempest()
{
	object oPC = OBJECT_SELF;

	int iSpellId = SPELL_Tempest_Defense;		
	int bTempestStateValid = IsTempestStateValid();
	//SendMessageToPC(oPC,"TempStateValid: "+IntToString(bTempestStateValid));
	int bHasTempestDefense = GetHasSpellEffect(iSpellId,oPC);
	if (bTempestStateValid)
	{
		//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
		// RemoveMethod = SC_REMOVE_FIRSTONLYCREATOR = 1, SC_REMOVE_ONLYCREATOR = 2, SC_REMOVE_FIRSTALLCREATORS = 3, SC_REMOVE_ALLCREATORS = 4
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );
		//else
		int nAC = 0;
		int nAB = 0;			
		int iLevel = GetLevelByClass( CLASS_TEMPEST, oPC);
		
		if (iLevel == 1) 
		{  
			nAC = 1;
		}
		else if (iLevel == 2) 
		{  
			nAC = 1;
			nAB = 1;				
		}	
		else if (iLevel == 3) 
		{  
			nAC = 2;
			nAB = 1;				
		}	
		else if (iLevel == 4) 
		{  
			nAC = 2;
			nAB = 2;			
		}	
		else if (iLevel == 5) 
		{  
			nAC = 3;
			nAB = 2;				
		}
		
		effect eLink;			
		effect eAC = SupernaturalEffect(EffectACIncrease(nAC, AC_DODGE_BONUS));	
				
		if (nAB > 0)
		{
			effect eAB = SupernaturalEffect(EffectAttackIncrease(nAB));
			eLink = SupernaturalEffect(EffectLinkEffects(eAB,eAC));
		}
		else
		{
			eLink = eAC;
		}
		eLink = SetEffectSpellId(eLink,iSpellId);
		if (!bHasTempestDefense)
		{
			SendMessageToPC(oPC,"Tempest Defense enabled.");
		}
		// HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(48));
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(48), iSpellId ));			
	}
	else
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );
		if (bHasTempestDefense)
		{
			SendMessageToPC(oPC,"Tempest Defense disabled, it is only valid when wielding two weapons and wearing light or no armor.");
		}
	}		
}
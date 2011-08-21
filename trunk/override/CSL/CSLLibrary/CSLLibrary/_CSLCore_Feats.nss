/** @file
* @brief Feat related functions
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

#include "_CSLCore_Feats_c"




/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCUtilityConstants"
// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

#include "_CSLCore_Config"
#include "_CSLCore_Position"
#include "_CSLCore_Class"
#include "_CSLCore_ObjectVars"

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////


object oFeatTable;

/**  
* Makes sure the oFeatTable is a valid pointer to the feats dataobject
* @author
* @see 
* @return 
*/
void CSLGetFeatDataObject()
{
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		oFeatTable = CSLDataObjectGet( "feat" );
	}
	//return oSpellTable;
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
string CSLGetFeatDataIcon(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return Get2DAString("feat", "ICON", iFeatId);
	}
	return CSLDataTableGetStringByRow( oFeatTable, "ICON", iFeatId );
}


string CSLGetFeatDataFeatCategory(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return Get2DAString("feat", "FeatCategory", iFeatId);
	}
	return CSLDataTableGetStringByRow( oFeatTable, "FeatCategory", iFeatId );
}

string CSLGetFeatDataSpellId(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return Get2DAString("feat", "SPELLID", iFeatId);
	}
	return CSLDataTableGetStringByRow( oFeatTable, "SPELLID", iFeatId );
}

int CSLGetFeatDataFeatAlignRestrict(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "AlignRestrict", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "AlignRestrict", iFeatId));
}











int CSLGetFeatDataFeatMaxLevel(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MaxLevel", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MaxLevel", iFeatId));
}





int CSLGetFeatDataFeatMinAttackBonus(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MINATTACKBONUS", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MINATTACKBONUS", iFeatId));
}


int CSLGetFeatDataFeatMaxStr(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MAXSTR", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MAXSTR", iFeatId));
}

int CSLGetFeatDataFeatMaxDex(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MAXDEX", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MAXDEX", iFeatId));
}

int CSLGetFeatDataFeatMaxCon(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MAXCON", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MAXCON", iFeatId));
}

int CSLGetFeatDataFeatMaxInt(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MAXINT", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MAXINT", iFeatId));
}

int CSLGetFeatDataFeatMaxWis(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MAXWIS", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MAXWIS", iFeatId));
}

int CSLGetFeatDataFeatMaxCHA(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MAXCHA", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MAXCHA", iFeatId));
}


int CSLGetFeatDataFeatMinStr(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MINSTR", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MINSTR", iFeatId));
}

int CSLGetFeatDataFeatMinDex(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MINDEX", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MINDEX", iFeatId));
}

int CSLGetFeatDataFeatMinCon(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MINCON", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MINCON", iFeatId));
}

int CSLGetFeatDataFeatMinInt(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MININT", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MININT", iFeatId));
}


int CSLGetFeatDataFeatMinWis(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MINWIS", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MINWIS", iFeatId));
}

int CSLGetFeatDataFeatMinCha(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MINCHA", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MINCHA", iFeatId));
}









int CSLGetFeatDataFeatMinFortSave(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MinFortSave", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MinFortSave", iFeatId));
}




int CSLGetFeatDataFeatMinLevel(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MinLevel", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MinLevel", iFeatId));
}


int CSLGetFeatDataFeatMinLevelClass(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "MinLevelClass", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "MinLevelClass", iFeatId));
}





int CSLGetFeatDataFeatOrReqFeat0(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "OrReqFeat0", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "OrReqFeat0", iFeatId));
}


int CSLGetFeatDataFeatOrReqFeat1(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "OrReqFeat1", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "OrReqFeat1", iFeatId));
}


int CSLGetFeatDataFeatOrReqFeat2(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "OrReqFeat2", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "OrReqFeat2", iFeatId));
}


int CSLGetFeatDataFeatOrReqFeat3(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "OrReqFeat3", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "OrReqFeat3", iFeatId));
}


int CSLGetFeatDataFeatOrReqFeat4(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "OrReqFeat4", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "OrReqFeat4", iFeatId));
}


int CSLGetFeatDataFeatOrReqFeat5(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "OrReqFeat5", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "OrReqFeat5", iFeatId));
}


int CSLGetFeatDataFeatPrereqFeat1(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "PREREQFEAT1", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "PREREQFEAT1", iFeatId));
}


int CSLGetFeatDataFeatPrereqFeat2(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "PREREQFEAT2", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "PREREQFEAT2", iFeatId));
}


int CSLGetFeatDataFeatReqSkill(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "REQSKILL", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "REQSKILL", iFeatId));
}


int CSLGetFeatDataFeatReqSkill2(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "REQSKILL2", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "REQSKILL2", iFeatId));
}


int CSLGetFeatDataFeatReqSkillMaxRanks(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "ReqSkillMaxRanks", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "ReqSkillMaxRanks", iFeatId));
}


int CSLGetFeatDataFeatReqSkillMaxRanks2(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "ReqSkillMaxRanks2", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "ReqSkillMaxRanks2", iFeatId));
}


int CSLGetFeatDataFeatReqSkillMinRanks(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "ReqSkillMinRanks", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "ReqSkillMinRanks", iFeatId));
}


int CSLGetFeatDataFeatReqSkillMinRanks2(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		return StringToInt(Get2DAString("feat", "ReqSkillMinRanks2", iFeatId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oFeatTable, "ReqSkillMinRanks2", iFeatId));
}


/**  
* Get the name of a Feat
* @param iFeatId Identifier of the Feat
* @return the name of the specified Feat
*/
string CSLGetFeatDataName(int iFeatId)
{
	CSLGetFeatDataObject();
	if ( !GetIsObjectValid( oFeatTable ) )
	{
		string sString = Get2DAString("feat", "FEAT", iFeatId);
		
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
	return CSLDataTableGetStringByRow( oFeatTable, "FEAT", iFeatId );
}








/**  
* @author
* @param 
* @see 
* @return 
*/
// * This makes no sense, need to really look at why it is used whereever it shows up, GetHasFeat seems to do the same thing
int CSLGetHasFeat(object oPC, int nFeatID) {
   talent tFeat = TalentFeat(nFeatID);
   if (!GetIsTalentValid(tFeat)) return FALSE;
   if (GetIdFromTalent(tFeat)==nFeatID) return TRUE;
   return FALSE;
}

// Functions


void CSLListFeatsOnTarget( object oReceiver, object oTarget, int iStartRow = 0, int iEndRow = -1 )
{
	CSLGetFeatDataObject( );
	if ( !GetIsObjectValid(oFeatTable) )
	{
		return;
	}
	
	int iStartRow = 0;
	if ( iEndRow == -1 )
	{
		int iEndRow = CSLDataTableCount( oFeatTable )-2;
	}
	
	int iMaxIterations = 75;
	int iCurrentIteration = 0;
	int iRow, iCurrent;
	int iUses;
	string sName, sMessage, sSpellAbility;

	for ( iCurrent = iStartRow; iCurrent <= iEndRow; iCurrent++) // changed from <=
	{
		if ( iCurrentIteration > iMaxIterations )
		{
			DelayCommand( 0.1f, CSLListFeatsOnTarget( oReceiver, oTarget, iCurrent, iEndRow ) );
			return;
		}
		iCurrentIteration++;
		
		iRow = CSLDataTableGetRowByIndex( oFeatTable, iCurrent );
		
		if ( iRow > -1 )
		{
			
			if (GetHasFeat(iRow, oTarget, TRUE))
			{
				sMessage += GetStringLeft(" "+IntToString(iRow)+"        ", 8);
				iUses = GetHasFeat(iRow, oTarget);	
				
				
				sName = CSLDataTableGetStringByRow( oFeatTable, "Name", iRow );
				if ( sName != "" )
				{
					sMessage += " - "+sName;
				}
				
				if ( iUses > 1 )
				{
					sMessage += " Uses "+IntToString(iUses);
				}
				else if ( iUses == 0  )
				{
					sMessage += " <b><color=red>No Uses</color></b>";
				}
				
				sSpellAbility = CSLDataTableGetStringByRow( oFeatTable, "SPELLID", iRow );
				if ( sSpellAbility != "" )
				{
					sMessage += " SpellAbility "+sSpellAbility;
				}
				
				if ( iUses == 0 )
				{
					SendMessageToPC( oReceiver, "<color=Yellow>"+sMessage+"</color>" );
				}
				else
				{
					SendMessageToPC( oReceiver, "<color=Ivory>"+sMessage+"</color>" );
				}
				
			}
			
			/*
			sName = CSLDataTableGetStringByRow( oFeatTable, "Name", iRow );
			if ( sName != "" )
			{
				
				// GetSpellKnown(oPC, SPELL_MAGIC_MISSILE)
				if ( GetSpellKnown(oTarget, iRow ) ) // && GetHasSpell(iRow, oTarget) > 0 && CSLGetHasSpell(oTarget, iRow) ) // doing both, there is an issue with monster summoning always returning odd numbers
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
			*/
		}
		
		
	}



	
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// Adds damage from unarmed attacks from Superior Unarmed Strike.
effect CSLSuperiorUnarmedStrikeForWeapon( object oPC = OBJECT_SELF )
{
	int nMonk  = GetLevelByClass(CLASS_TYPE_MONK, oPC) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);
	int nNotMonk = GetHitDice(oPC) - nMonk;
	int nMySize = GetCreatureSize(oPC);
	int nFists;
	int nMonkFists;
	
	effect eDamage;
	
	if (GetHasFeat(FEAT_SUPERIOR_UNARMED_STRIKE, oPC)) // Applies to all sizes oddly enough.
	{
		switch (nNotMonk)
		{
			case 1:	 nFists = nFists + d2();	break;
			case 2:	 nFists = nFists + d2();	break;
			case 3:	 nFists = nFists + d4();	break;
			case 4:	 nFists = nFists + d6();	break;
			case 5:	 nFists = nFists + d6();	break;
			case 6:	 nFists = nFists + d6();	break;
			case 7:	 nFists = nFists + d6();	break;
			case 8:	 nFists = nFists + d8();	break;
			case 9:	 nFists = nFists + d8();	break;
			case 10: nFists = nFists + d8();	break;
			case 11: nFists = nFists + d8();	break;
			case 12: nFists = nFists + d10();	break;
			case 13: nFists = nFists + d10();	break;
			case 14: nFists = nFists + d10();	break;
			case 15: nFists = nFists + d10();	break;
			case 16: nFists = nFists + d6(2);	break;
			case 17: nFists = nFists + d6(2);	break;
			case 18: nFists = nFists + d6(2);	break;
			case 19: nFists = nFists + d6(2);	break;
			case 20: nFists = nFists + d6(2);	break;
			case 21: nFists = nFists + d8(2);	break;
			case 22: nFists = nFists + d8(2);	break;
			case 23: nFists = nFists + d8(2);	break;
			case 24: nFists = nFists + d8(2);	break;
			case 25: nFists = nFists + d10(2);	break;
			case 26: nFists = nFists + d10(2);	break;
			case 27: nFists = nFists + d10(2);	break;
			case 28: nFists = nFists + d10(2);	break;
			case 29: nFists = nFists + d6(4);	break;
			case 30: nFists = nFists + d6(4);	break;
		}
		
		if (nMySize == CREATURE_SIZE_TINY || nMySize == CREATURE_SIZE_SMALL)
		{
			switch (nMonk)
			{
				case 1: nMonkFists = nMonkFists + d6();		break;
				case 2: nMonkFists = nMonkFists + d6();		break;
				case 3: nMonkFists = nMonkFists + d6();		break;
				case 4: nMonkFists = nMonkFists + d8();		break;
				case 5: nMonkFists = nMonkFists + d8();		break;
				case 6: nMonkFists = nMonkFists + d8();		break;
				case 7: nMonkFists = nMonkFists + d8();		break;
				case 8: nMonkFists = nMonkFists + d10();	break;
				case 9: nMonkFists = nMonkFists + d10();	break;
				case 10:nMonkFists = nMonkFists + d10();	break;
				case 11:nMonkFists = nMonkFists + d10();	break;
				case 12:nMonkFists = nMonkFists + d6(2);	break;
				case 13:nMonkFists = nMonkFists + d6(2);	break;
				case 14:nMonkFists = nMonkFists + d6(2);	break;
				case 15:nMonkFists = nMonkFists + d6(2);	break;
				case 16:nMonkFists = nMonkFists + d8(2);	break;
				case 17:nMonkFists = nMonkFists + d8(2);	break;
				case 18:nMonkFists = nMonkFists + d8(2);	break;
				case 19:nMonkFists = nMonkFists + d8(2);	break;
				case 20:nMonkFists = nMonkFists + d10(2);	break;
				case 21:nMonkFists = nMonkFists + d10(2);	break;
				case 22:nMonkFists = nMonkFists + d10(2);	break;
				case 23:nMonkFists = nMonkFists + d10(2);	break;
				case 24:nMonkFists = nMonkFists + d6(4);	break;
				case 25:nMonkFists = nMonkFists + d6(4);	break;
				case 26:nMonkFists = nMonkFists + d6(4);	break;
				case 27:nMonkFists = nMonkFists + d6(4);	break;
				case 28:nMonkFists = nMonkFists + d8(4);	break;
				case 29:nMonkFists = nMonkFists + d8(4);	break;
				case 30:nMonkFists = nMonkFists + d8(4);	break;
			}
		}
		else if (nMySize == CREATURE_SIZE_MEDIUM)
		{
			switch (nMonk)
			{
				case 1: nMonkFists = nMonkFists + d8();		break;
				case 2: nMonkFists = nMonkFists + d8();		break;
				case 3: nMonkFists = nMonkFists + d8();		break;
				case 4: nMonkFists = nMonkFists + d10();	break;
				case 5: nMonkFists = nMonkFists + d10();	break;
				case 6: nMonkFists = nMonkFists + d10();	break;
				case 7: nMonkFists = nMonkFists + d10();	break;
				case 8: nMonkFists = nMonkFists + d6(2);	break;
				case 9: nMonkFists = nMonkFists + d6(2);	break;
				case 10:nMonkFists = nMonkFists + d6(2);	break;
				case 11:nMonkFists = nMonkFists + d6(2);	break;
				case 12:nMonkFists = nMonkFists + d8(2);	break;
				case 13:nMonkFists = nMonkFists + d8(2);	break;
				case 14:nMonkFists = nMonkFists + d8(2);	break;
				case 15:nMonkFists = nMonkFists + d8(2);	break;
				case 16:nMonkFists = nMonkFists + d10(2);	break;
				case 17:nMonkFists = nMonkFists + d10(2);	break;
				case 18:nMonkFists = nMonkFists + d10(2);	break;
				case 19:nMonkFists = nMonkFists + d10(2);	break;
				case 20:nMonkFists = nMonkFists + d6(4);	break;
				case 21:nMonkFists = nMonkFists + d6(4);	break;
				case 22:nMonkFists = nMonkFists + d6(4);	break;
				case 23:nMonkFists = nMonkFists + d6(4);	break;
				case 24:nMonkFists = nMonkFists + d8(4);	break;
				case 25:nMonkFists = nMonkFists + d8(4);	break;
				case 26:nMonkFists = nMonkFists + d8(4);	break;
				case 27:nMonkFists = nMonkFists + d10(4);	break;
				case 28:nMonkFists = nMonkFists + d10(4);	break;
				case 29:nMonkFists = nMonkFists + d10(4);	break;
				case 30:nMonkFists = nMonkFists + d10(4);	break;
			}
		}
		else if (nMySize > CREATURE_SIZE_MEDIUM)
		{
			switch (nMonk)
			{
				case 1: nMonkFists = nMonkFists + d6(2);	break;
				case 2: nMonkFists = nMonkFists + d6(2);	break;
				case 3: nMonkFists = nMonkFists + d6(2);	break;
				case 4: nMonkFists = nMonkFists + d8(2);	break;
				case 5: nMonkFists = nMonkFists + d8(2);	break;
				case 6: nMonkFists = nMonkFists + d8(2);	break;
				case 7: nMonkFists = nMonkFists + d8(2);	break;
				case 8: nMonkFists = nMonkFists + d6(3);	break;
				case 9: nMonkFists = nMonkFists + d6(3);	break;
				case 10:nMonkFists = nMonkFists + d6(3);	break;
				case 11:nMonkFists = nMonkFists + d6(3);	break;
				case 12:nMonkFists = nMonkFists + d8(3);	break;
				case 13:nMonkFists = nMonkFists + d8(3);	break;
				case 14:nMonkFists = nMonkFists + d8(3);	break;
				case 15:nMonkFists = nMonkFists + d8(3);	break;
				case 16:nMonkFists = nMonkFists + d8(4);	break;
				case 17:nMonkFists = nMonkFists + d8(4);	break;
				case 18:nMonkFists = nMonkFists + d8(4);	break;
				case 19:nMonkFists = nMonkFists + d8(4);	break;
				case 20:nMonkFists = nMonkFists + d6(5);	break;
				case 21:nMonkFists = nMonkFists + d6(5);	break;
				case 22:nMonkFists = nMonkFists + d6(5);	break;
				case 23:nMonkFists = nMonkFists + d6(5);	break;
				case 24:nMonkFists = nMonkFists + d8(5);	break;
				case 25:nMonkFists = nMonkFists + d8(5);	break;
				case 26:nMonkFists = nMonkFists + d8(5);	break;
				case 27:nMonkFists = nMonkFists + d8(5);	break;
				case 28:nMonkFists = nMonkFists + d4(12);	break;
				case 29:nMonkFists = nMonkFists + d4(12);	break;
				case 30:nMonkFists = nMonkFists + d4(12);	break;
			}
		}
	}

	if (nMonk > 15)
	{
		eDamage = EffectDamage((nMonkFists + nFists), DAMAGE_TYPE_MAGICAL);
	}
	else eDamage = EffectDamage((nMonkFists + nFists), DAMAGE_TYPE_BLUDGEONING);

	return eDamage;
}

/**  
* @author
* @param 
* @see 
* @return 
*/	
// Applies the damage from Snap Kick if it is active, but not the attack penalty.
effect CSLSnapKickDamage(object oPC = OBJECT_SELF)
{
	object oToB = CSLGetDataStore(oPC);
	object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	int nMonk  = GetLevelByClass(CLASS_TYPE_MONK, oPC) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);
	int nNotMonk = GetHitDice(oPC) - nMonk;
	int nMySize = GetCreatureSize(oPC);
	int nFists, nMonkFists, nStrMod, nUnarmedDamage;
	effect eUnarmedDamage;

	if (GetAbilityModifier(ABILITY_STRENGTH, oPC) < 2)
	{
		nStrMod = 0;
	}
	else nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC) / 2;

	if ((GetLocalInt(oToB, "SnapKick") == 1) && GetHasFeat(FEAT_SUPERIOR_UNARMED_STRIKE, oPC))
	{
		eUnarmedDamage = CSLSuperiorUnarmedStrikeForWeapon();
	}
	else if (GetLocalInt(oToB, "SnapKick") == 1)
	{
		switch (nMySize)
		{	
			case CREATURE_SIZE_TINY:	 nFists = 1;	break;
			case CREATURE_SIZE_SMALL:	 nFists = d2();	break;
			case CREATURE_SIZE_MEDIUM:	 nFists = d3();	break;
			case CREATURE_SIZE_LARGE:	 nFists = d4();	break;
			case CREATURE_SIZE_HUGE:	 nFists = d6();	break;
			default:					 nFists = 2;	break;
		}		
		
		if (nMonk > 0)
		{
			if (nMySize == CREATURE_SIZE_TINY || nMySize == CREATURE_SIZE_SMALL)
			{
				switch (nMonk)
				{
					case 1: nMonkFists = nMonkFists + d4();		break;
					case 2: nMonkFists = nMonkFists + d4();		break;
					case 3: nMonkFists = nMonkFists + d4();		break;
					case 4: nMonkFists = nMonkFists + d6();		break;
					case 5: nMonkFists = nMonkFists + d6();		break;
					case 6: nMonkFists = nMonkFists + d6();		break;
					case 7: nMonkFists = nMonkFists + d6();		break;
					case 8: nMonkFists = nMonkFists + d8();		break;
					case 9: nMonkFists = nMonkFists + d8();		break;
					case 10:nMonkFists = nMonkFists + d8();		break;
					case 11:nMonkFists = nMonkFists + d8();		break;
					case 12:nMonkFists = nMonkFists + d10();	break;
					case 13:nMonkFists = nMonkFists + d10();	break;
					case 14:nMonkFists = nMonkFists + d10();	break;
					case 15:nMonkFists = nMonkFists + d10();	break;
					case 16:nMonkFists = nMonkFists + d6(2);	break;
					case 17:nMonkFists = nMonkFists + d6(2);	break;
					case 18:nMonkFists = nMonkFists + d6(2);	break;
					case 19:nMonkFists = nMonkFists + d6(2);	break;
					case 20:nMonkFists = nMonkFists + d8(2);	break;
					case 21:nMonkFists = nMonkFists + d8(2);	break;
					case 22:nMonkFists = nMonkFists + d8(2);	break;
					case 23:nMonkFists = nMonkFists + d8(2);	break;
					case 24:nMonkFists = nMonkFists + d10(2);	break;
					case 25:nMonkFists = nMonkFists + d10(2);	break;
					case 26:nMonkFists = nMonkFists + d10(2);	break;
					case 27:nMonkFists = nMonkFists + d10(2);	break;
					case 28:nMonkFists = nMonkFists + d6(4);	break;
					case 29:nMonkFists = nMonkFists + d6(4);	break;
					case 30:nMonkFists = nMonkFists + d6(4);	break;
				}
			}
			else if (nMySize == CREATURE_SIZE_MEDIUM)
			{
				switch (nMonk)
				{
					case 1: nMonkFists = nMonkFists + d6();		break;
					case 2: nMonkFists = nMonkFists + d6();		break;
					case 3: nMonkFists = nMonkFists + d6();		break;
					case 4: nMonkFists = nMonkFists + d8();		break;
					case 5: nMonkFists = nMonkFists + d8();		break;
					case 6: nMonkFists = nMonkFists + d8();		break;
					case 7: nMonkFists = nMonkFists + d8();		break;
					case 8: nMonkFists = nMonkFists + d10();	break;
					case 9: nMonkFists = nMonkFists + d10();	break;
					case 10:nMonkFists = nMonkFists + d10();	break;
					case 11:nMonkFists = nMonkFists + d10();	break;
					case 12:nMonkFists = nMonkFists + d6(2);	break;
					case 13:nMonkFists = nMonkFists + d6(2);	break;
					case 14:nMonkFists = nMonkFists + d6(2);	break;
					case 15:nMonkFists = nMonkFists + d6(2);	break;
					case 16:nMonkFists = nMonkFists + d8(2);	break;
					case 17:nMonkFists = nMonkFists + d8(2);	break;
					case 18:nMonkFists = nMonkFists + d8(2);	break;
					case 19:nMonkFists = nMonkFists + d8(2);	break;
					case 20:nMonkFists = nMonkFists + d10(2);	break;
					case 21:nMonkFists = nMonkFists + d10(2);	break;
					case 22:nMonkFists = nMonkFists + d10(2);	break;
					case 23:nMonkFists = nMonkFists + d10(2);	break;
					case 24:nMonkFists = nMonkFists + d6(4);	break;
					case 25:nMonkFists = nMonkFists + d6(4);	break;
					case 26:nMonkFists = nMonkFists + d6(4);	break;
					case 27:nMonkFists = nMonkFists + d6(4);	break;
					case 28:nMonkFists = nMonkFists + d8(4);	break;
					case 29:nMonkFists = nMonkFists + d8(4);	break;
					case 30:nMonkFists = nMonkFists + d8(4);	break;
				}
			}
			else if (nMySize > CREATURE_SIZE_MEDIUM)
			{
				switch (nMonk)
				{
					case 1: nMonkFists = nMonkFists + d8();		break;
					case 2: nMonkFists = nMonkFists + d8();		break;
					case 3: nMonkFists = nMonkFists + d8();		break;
					case 4: nMonkFists = nMonkFists + d6(2);	break;
					case 5: nMonkFists = nMonkFists + d6(2);	break;
					case 6: nMonkFists = nMonkFists + d6(2);	break;
					case 7: nMonkFists = nMonkFists + d6(2);	break;
					case 8: nMonkFists = nMonkFists + d8(2);	break;
					case 9: nMonkFists = nMonkFists + d8(2);	break;
					case 10:nMonkFists = nMonkFists + d8(2);	break;
					case 11:nMonkFists = nMonkFists + d8(2);	break;
					case 12:nMonkFists = nMonkFists + d6(3);	break;
					case 13:nMonkFists = nMonkFists + d6(3);	break;
					case 14:nMonkFists = nMonkFists + d6(3);	break;
					case 15:nMonkFists = nMonkFists + d6(3);	break;
					case 16:nMonkFists = nMonkFists + d8(3);	break;
					case 17:nMonkFists = nMonkFists + d8(3);	break;
					case 18:nMonkFists = nMonkFists + d8(3);	break;
					case 19:nMonkFists = nMonkFists + d8(3);	break;
					case 20:nMonkFists = nMonkFists + d8(4);	break;
					case 21:nMonkFists = nMonkFists + d8(4);	break;
					case 22:nMonkFists = nMonkFists + d8(4);	break;
					case 23:nMonkFists = nMonkFists + d8(4);	break;
					case 24:nMonkFists = nMonkFists + d6(5);	break;
					case 25:nMonkFists = nMonkFists + d6(5);	break;
					case 26:nMonkFists = nMonkFists + d6(5);	break;
					case 27:nMonkFists = nMonkFists + d6(5);	break;
					case 28:nMonkFists = nMonkFists + d8(5);	break;
					case 29:nMonkFists = nMonkFists + d8(5);	break;
					case 30:nMonkFists = nMonkFists + d8(5);	break;
				}
			}
		}
		if (nMonk > 15)
		{
			nUnarmedDamage = nMonkFists + nFists + nStrMod;
			eUnarmedDamage = EffectDamage(nUnarmedDamage, DAMAGE_TYPE_MAGICAL);
			SetLocalInt(oToB, "SnapKickStoredDam", nUnarmedDamage);
			SetLocalInt(oToB, "SnapKickType", DAMAGE_TYPE_MAGICAL);
		}
		else 
		{
			nUnarmedDamage = nMonkFists + nFists + nStrMod;
			eUnarmedDamage = EffectDamage(nUnarmedDamage, DAMAGE_TYPE_BLUDGEONING);
			SetLocalInt(oPC, "SnapKickStoredDam", nUnarmedDamage);
			SetLocalInt(oPC, "SnapKickType", DAMAGE_TYPE_BLUDGEONING);
		}
	}
	return eUnarmedDamage;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Not a feat per se, but this is a good place to put this function because all
// of the Tiger Claw maneuvers call this library.  Jump skill in the Tome of 
// Battle is determined by the PC's Str mod plus their ranks in Taunt.
// nBonus: Any misc bonuses to the skill that might be included.
int CSLGetJumpSkill(object oPC = OBJECT_SELF, int nBonus = 0)
{
	int nTaunt;

	nTaunt += GetSkillRank(SKILL_TAUNT, oPC, TRUE);
	nTaunt += nBonus;

	int nStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);

	nTaunt += nStr;

	if ((GetCurrentAction(oPC) == ACTION_MOVETOPOINT) || (GetLocalInt(oPC, "LeapingDragonStance") == 1))
	{
		if (GetHasFeat(FEAT_DASH)) // Using this instead of the "Run" feat.
		{
			nTaunt += 4;
		}
	}

	effect eSpeed;

	eSpeed = GetFirstEffect(oPC);

	while (GetIsEffectValid(eSpeed))
	{
		int nType = GetEffectType(eSpeed);

		if (nType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE)
		{
			int nSpeed = GetEffectInteger(eSpeed, 0);
			float fCheck = IntToFloat(nSpeed) / (5.0f/3.0f);

			if (fCheck >= 59.0f) //Double Speed. Max value of the movement increase % is 99.
			{
				nTaunt += 12;
			}
			else if (fCheck >= 50.0f)
			{
				nTaunt += 8;
			}
			else if (fCheck >= 40.0f)
			{
				nTaunt += 4;
			}
		}
		else if (nType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
		{
			int nSpeed = GetEffectInteger(eSpeed, 0);
			float fCheck = IntToFloat(nSpeed) / (5.0f/3.0f);

			if (fCheck >= 59.0f) //Immobile. Max value of the movement decrease % is 99.
			{
				nTaunt -= 18;
			}
			else if (fCheck >= 50.0f)
			{
				nTaunt -= 12;
			}
			else if (fCheck >= 40.0f)
			{
				nTaunt -= 6;
			}
		}

		eSpeed = GetNextEffect(oPC);
	}

	if (GetHasFeat(FEAT_SKILL_FOCUS_TAUNT, oPC))
	{
		nTaunt += 3;
	}

	if (GetHasFeat(FEAT_EPIC_SKILL_FOCUS_TAUNT, oPC))
	{
		nTaunt += 10;
	}

	if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) > 4)
	{
		nTaunt += 2; //Synergy
	}

	if (GetRacialType(oPC) == RACIAL_TYPE_HALFLING)
	{
		nTaunt += 2; //Racial Bonus
	}

	if (GetHasFeat(6913, oPC)) //Blade Meditation: Tiger Claw
	{
		nTaunt += 2;
	}

	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	int nArmor, nShield;

	if (oArmor == OBJECT_INVALID)
	{
		nArmor = 0; //Prevents the function from shutting down.
	}
	else nArmor = GetArmorRulesType(oArmor);

	int nArmorPenalty = abs(StringToInt(Get2DAString("armorrulestats", "ACCHECK", nArmor)));
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

	if (oShield == OBJECT_INVALID)
	{
		nShield = 0; //Prevents the function from shutting down.
	}
	else nShield = GetArmorRulesType(oShield);

	int nShieldPenalty = abs(StringToInt(Get2DAString("armorrulestats", "ACCHECK", nShield)));
	int nArmorCheckPenalty = nArmorPenalty + nShieldPenalty;

	nTaunt -= nArmorCheckPenalty;

	return nTaunt;
}



/**  
* @author
* @param 
* @see 
* @return 
*/
// Wrapper for FeatAdd.
void CSLWrapperFeatAdd(object oPC, int nFeat, int bCheckRequirements, int bFeedback=FALSE, int bNotice=FALSE)
{
	FeatAdd(oPC, nFeat, bCheckRequirements, bFeedback, bNotice);
}


/** @file
* @brief Include File for Tome of Battle
*
* 
* 
*
* @ingroup scinclude
* @author Drammel, Brian T. Meyer and others
*/




//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 5/18/2009								//
//	Title: bot9s_TB_crusaderecov					//
//	Description: Library file for the scripts	//
//	that govern the Crusader's recovery method.	//
//	The big long lists are used instead of a	//
//	while loop because these functions are run	//
//	from within one and doing that usually makes//
//	the script cry.								//
//////////////////////////////////////////////////
#include "_CSLCore_Feats"
#include "_CSLCore_Items"
#include "_CSLCore_Combat"
#include "_CSLCore_Environment"
#include "_HkSpell"


struct tob_main_damage
{
	int nSlash;
	int nBlunt;
	int nPierce;
	int nAcid;
	int nCold;
	int nElec;
	int nFire;
	int nSonic;
	int nDivine;
	int nMagic;
	int nPosit;
	int nNegat;
};




object oManeuversTable;

/**  
* Makes sure the oFeatTable is a valid pointer to the feats dataobject
* @author
* @see 
* @return 
*/
void TOBGetManeuversDataObject()
{
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		oManeuversTable = CSLDataObjectGet( "maneuvers" );
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
string TOBGetManeuversDataName(int iManeuversId)
{
	/*
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return Get2DAString("maneuvers", "StrRef", iManeuversId);
	}
	return CSLDataTableGetStringByRow( oManeuversTable, "StrRef", iManeuversId );
	*/
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		string sString = Get2DAString("maneuvers", "StrRef", iManeuversId);
		
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
	return CSLDataTableGetStringByRow( oManeuversTable, "StrRef", iManeuversId );
	
	
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
string TOBGetManeuversDataIcon(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return Get2DAString("maneuvers", "ICON", iManeuversId);
	}
	return CSLDataTableGetStringByRow( oManeuversTable, "ICON", iManeuversId );
}



/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
string TOBGetManeuversDataScript(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return Get2DAString("maneuvers", "Script", iManeuversId);
	}
	return CSLDataTableGetStringByRow( oManeuversTable, "Script", iManeuversId );
}





/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataDiscipline(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "Discipline", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "Discipline", iManeuversId ));
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataIsStance(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "IsStance", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "IsStance", iManeuversId ));
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataLevel(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "Level", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "Level", iManeuversId ));
}


/**  
* Description tlkref
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataDescription(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "Description", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "Description", iManeuversId ));
}


/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataLocation(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "Location", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "Location", iManeuversId ));
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataMastery(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "Mastery", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "Mastery", iManeuversId ));
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataMovement(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "Movement", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "Movement", iManeuversId ));
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataSupressAoO(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "SupressAoO", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "SupressAoO", iManeuversId ));
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
int TOBGetManeuversDataType(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToInt(Get2DAString("maneuvers", "Type", iManeuversId));
	}
	return StringToInt(CSLDataTableGetStringByRow( oManeuversTable, "Type", iManeuversId ));
}

/**  
* Description
* @author
* @param iSpellId
* @see 
* @return 
*/
float TOBGetManeuversDataRange(int iManeuversId)
{
	TOBGetManeuversDataObject();
	if ( !GetIsObjectValid( oManeuversTable ) )
	{
		return StringToFloat(Get2DAString("maneuvers", "Range", iManeuversId));
	}
	return StringToFloat(CSLDataTableGetStringByRow( oManeuversTable, "Range", iManeuversId ));
}





/*

These are the files to be renamed into the new spells.2da system

mv launch_martial_menu.nss TB_menumartial.nss;mv TB_desertdodge.nss TB_desertdodge.nss;mv TB_actstrike.nss TB_actstrike.nss;mv TB_desertfire.nss TB_desertfire.nss;mv TB_shadtrickste.nss TB_shadtrickste.nss;mv TB_shadblade.nss TB_shadblade.nss;mv TB_devotedbulwa.nss TB_devotedbulwa.nss;mv TB_ironheartaur.nss TB_ironheartaur.nss;mv TB_rapidassualt.nss TB_rapidassualt.nss;mv TB_supunarmstri.nss TB_supunarmstri.nss;mv TB_whiteravende.nss TB_whiteravende.nss;mv TB_avengingstri.nss TB_avengingstri.nss;mv TB_divinespirit.nss TB_divinespirit.nss;mv TB_songwhiterav.nss TB_songwhiterav.nss;mv TB_snapkick.nss TB_snapkick.nss;mv TB_stonepower.nss TB_stonepower.nss;mv TB_sensemagic.nss TB_sensemagic.nss;mv TB_swordsageac.nss TB_swordsageac.nss;mv TB_fallingsunat.nss TB_fallingsunat.nss;mv TB_suddenrecove.nss TB_suddenrecove.nss;mv TB_dualboost.nss TB_dualboost.nss;mv TB_ssweaponfocu.nss TB_ssweaponfocu.nss;mv TB_battleclarit.nss TB_battleclarit.nss;mv TB_battlecunnin.nss TB_battlecunnin.nss;mv TB_battleskill.nss TB_battleskill.nss;mv TB_battleardor.nss TB_battleardor.nss;mv TB_battlemaster.nss TB_battlemaster.nss;mv TB_weaponaptitu.nss TB_weaponaptitu.nss;mv TB_steelyresolv.nss TB_steelyresolv.nss;mv TB_furiouscount.nss TB_furiouscount.nss;mv TB_diehard.nss TB_diehard.nss;mv TB_smiteA.nss TB_smiteA.nss;mv TB_smite.nss TB_smite.nss;mv TB_indomitables.nss TB_indomitables.nss;mv TB_zealoussurge.nss TB_zealoussurge.nss;mv TB_crusaderecov.nss TB_crusaderecov.nss;mv TB_adaptstyle.nss TB_adaptstyle.nss;mv TB_furiouscountA.nss TB_furiouscntA.nss;mv TB_avengingstriA.nss TB_avengstrikA.nss;mv TB_martialstud1.nss TB_martialstud1.nss;mv TB_martialstud12.nss TB_martialstud2.nss;mv TB_martialstud13.nss TB_martialstud3.nss;mv TB_martialstan1.nss TB_martialstan1.nss;mv TB_martialstan12.nss TB_martialstan2.nss;mv TB_martialstan13.nss TB_martialstan3.nss;mv TB_menuumbral.nss TB_menuumbral.nss;mv TB_crbookssword.nss TB_crbookssword.nss;mv TB_crbookscrusa.nss TB_crbookscrusa.nss;mv TB_crbookswarbl.nss TB_crbookswarbl.nss;mv TB_crbookssaint.nss TB_crbookssaint.nss;

*/


//effect TOBGenerateItemProperties(object oPC, object oWeapon, object oTarget, int bIgnoreResistances = FALSE, int nMult = 1);

// Converts DAMAGE_BONUS_* constants into real numbers.
int TOBGetDamageByDamageBonus(int nDamageBonus)
{
	
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetDamageByDamageBonus Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	int nDamage;

	if (GetIsObjectValid(oToB))
	{
		if ( hkStanceGetHasActive( oPC, STANCE_AURA_OF_CHAOS ) )
		{// Sadly routing for this cannot be done in a loop, since this function is commonly run from within a while loop already.
			if (nDamageBonus == DAMAGE_BONUS_1d10 || nDamageBonus == DAMAGE_BONUS_1d12 || nDamageBonus == DAMAGE_BONUS_1d4
			|| nDamageBonus == DAMAGE_BONUS_1d8 || nDamageBonus == DAMAGE_BONUS_1d6 || nDamageBonus == DAMAGE_BONUS_2d10 
			|| nDamageBonus == DAMAGE_BONUS_2d12 || nDamageBonus == DAMAGE_BONUS_2d4 || nDamageBonus == DAMAGE_BONUS_2d8 
			|| nDamageBonus == DAMAGE_BONUS_2d6)
			{
				int nDie, nNum;

				switch (nDamageBonus)
				{
					case DAMAGE_BONUS_1d4:		nDie = 4;	nNum = 1;	break;
					case DAMAGE_BONUS_1d6:		nDie = 6;	nNum = 1;	break;
					case DAMAGE_BONUS_1d8:		nDie = 8;	nNum = 1;	break;
					case DAMAGE_BONUS_1d10:		nDie = 10;	nNum = 1;	break;
					case DAMAGE_BONUS_1d12:		nDie = 12;	nNum = 1;	break;
					case DAMAGE_BONUS_2d4:		nDie = 4;	nNum = 2;	break;
					case DAMAGE_BONUS_2d6:		nDie = 6;	nNum = 2;	break;
					case DAMAGE_BONUS_2d8:		nDie = 8;	nNum = 2;	break;
					case DAMAGE_BONUS_2d10:		nDie = 10;	nNum = 2;	break;
					case DAMAGE_BONUS_2d12:		nDie = 12;	nNum = 2;	break;
				}

				int nDie1Roll1 = Random(nDie); // Hard cap of 10 extra damage rolls per die.

				if (nDie1Roll1 == 0) //The function "Random" can return a zero which cannot be a damage number.
				{
					nDamage += 1;
				}
				else if (nDie1Roll1 < nDie)
				{
					nDamage += nDie1Roll1;
				}
				else // Max damage die is showing, Aura of Chaos kicks in.
				{
					nDamage += nDie1Roll1;

					int nDie1Roll2 = Random(nDie);

					if (nDie1Roll2 == 0)
					{
						nDamage += 1;
					}
					else if (nDie1Roll2 < nDie)
					{
						nDamage += nDie1Roll2;
					}
					else
					{
						nDamage += nDie1Roll2;

						int nDie1Roll3 = Random(nDie);

						if (nDie1Roll3 == 0)
						{
							nDamage += 1;
						}
						else if (nDie1Roll3 < nDie)
						{
							nDamage += nDie1Roll3;
						}
						else
						{
							nDamage += nDie1Roll3;

							int nDie1Roll4 = Random(nDie);

							if (nDie1Roll4 == 0)
							{
								nDamage += 1;
							}
							else if (nDie1Roll4 < nDie)
							{
								nDamage += nDie1Roll4;
							}
							else
							{
								nDamage += nDie1Roll4;

								int nDie1Roll5 = Random(nDie);

								if (nDie1Roll5 == 0)
								{
									nDamage += 1;
								}
								else if (nDie1Roll5 < nDie)
								{
									nDamage += nDie1Roll5;
								}
								else
								{
									nDamage += nDie1Roll5;

									int nDie1Roll6 = Random(nDie);

									if (nDie1Roll6 == 0)
									{
										nDamage += 1;
									}
									else if (nDie1Roll6 < nDie)
									{
										nDamage += nDie1Roll6;
									}
									else
									{
										nDamage += nDie1Roll6;

										int nDie1Roll7 = Random(nDie);

										if (nDie1Roll7 == 0)
										{
											nDamage += 1;
										}
										else if (nDie1Roll7 < nDie)
										{
											nDamage += nDie1Roll7;
										}
										else
										{
											nDamage += nDie1Roll7;

											int nDie1Roll8 = Random(nDie);

											if (nDie1Roll8 == 0)
											{
												nDamage += 1;
											}
											else if (nDie1Roll8 < nDie)
											{
												nDamage += nDie1Roll8;
											}
											else
											{
												nDamage += nDie1Roll8;

												int nDie1Roll9 = Random(nDie);

												if (nDie1Roll9 == 0)
												{
													nDamage += 1;
												}
												else if (nDie1Roll9 < nDie)
												{
													nDamage += nDie1Roll9;
												}
												else
												{
													int nDie1Roll10 = Random(nDie);
													nDamage += (nDie1Roll9 + nDie1Roll10);
												}
											}
										}
									}
								}
							}
						}
					}
				}

				if (nNum >= 2)
				{
					int nDie2Roll1 = Random(nDie);
	
					if (nDie2Roll1 == 0)
					{
						nDamage += 1;
					}
					else if (nDie2Roll1 < nDie)
					{
						nDamage += nDie2Roll1;
					}
					else
					{
						nDamage += nDie2Roll1;
	
						int nDie2Roll2 = Random(nDie);
	
						if (nDie2Roll2 == 0)
						{
							nDamage += 1;
						}
						else if (nDie2Roll2 < nDie)
						{
							nDamage += nDie2Roll2;
						}
						else
						{
							nDamage += nDie2Roll2;
	
							int nDie2Roll3 = Random(nDie);
	
							if (nDie2Roll3 == 0)
							{
								nDamage += 1;
							}
							else if (nDie2Roll3 < nDie)
							{
								nDamage += nDie2Roll3;
							}
							else
							{
								nDamage += nDie2Roll3;
	
								int nDie2Roll4 = Random(nDie);
	
								if (nDie2Roll4 == 0)
								{
									nDamage += 1;
								}
								else if (nDie2Roll4 < nDie)
								{
									nDamage += nDie2Roll4;
								}
								else
								{
									nDamage += nDie2Roll4;
	
									int nDie2Roll5 = Random(nDie);
	
									if (nDie2Roll5 == 0)
									{
										nDamage += 1;
									}
									else if (nDie2Roll5 < nDie)
									{
										nDamage += nDie2Roll5;
									}
									else
									{
										nDamage += nDie2Roll5;
	
										int nDie2Roll6 = Random(nDie);
	
										if (nDie2Roll6 == 0)
										{
											nDamage += 1;
										}
										else if (nDie2Roll6 < nDie)
										{
											nDamage += nDie2Roll6;
										}
										else
										{
											nDamage += nDie2Roll6;
	
											int nDie2Roll7 = Random(nDie);
	
											if (nDie2Roll7 == 0)
											{
												nDamage += 1;
											}
											else if (nDie2Roll7 < nDie)
											{
												nDamage += nDie2Roll7;
											}
											else
											{
												nDamage += nDie2Roll7;
	
												int nDie2Roll8 = Random(nDie);
	
												if (nDie2Roll8 == 0)
												{
													nDamage += 1;
												}
												else if (nDie2Roll8 < nDie)
												{
													nDamage += nDie2Roll8;
												}
												else
												{
													nDamage += nDie2Roll8;
	
													int nDie2Roll9 = Random(nDie);
	
													if (nDie2Roll9 == 0)
													{
														nDamage += 1;
													}
													else if (nDie2Roll9 < nDie)
													{
														nDamage += nDie2Roll9;
													}
													else
													{
														int nDie2Roll10 = Random(nDie);
														nDamage += (nDie2Roll9 + nDie2Roll10);
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			else
			{
				switch (nDamageBonus)
				{
					case DAMAGE_BONUS_1:	nDamage = 1;		break;
					case DAMAGE_BONUS_10: 	nDamage = 10;		break;
					case DAMAGE_BONUS_11: 	nDamage = 11;		break;
					case DAMAGE_BONUS_12: 	nDamage = 12;		break;
					case DAMAGE_BONUS_13: 	nDamage = 13;		break;
					case DAMAGE_BONUS_14: 	nDamage = 14;		break;
					case DAMAGE_BONUS_15: 	nDamage = 15;		break;
					case DAMAGE_BONUS_16: 	nDamage = 16;		break;
					case DAMAGE_BONUS_17: 	nDamage = 17;		break;
					case DAMAGE_BONUS_18: 	nDamage = 18;		break;
					case DAMAGE_BONUS_19: 	nDamage = 19;		break;
					case DAMAGE_BONUS_2: 	nDamage = 2;		break;
					case DAMAGE_BONUS_20: 	nDamage = 20;		break;
					case DAMAGE_BONUS_21: 	nDamage = 21;		break;
					case DAMAGE_BONUS_22: 	nDamage = 22;		break;
					case DAMAGE_BONUS_23: 	nDamage = 23;		break;
					case DAMAGE_BONUS_24: 	nDamage = 24;		break;
					case DAMAGE_BONUS_25: 	nDamage = 25;		break;
					case DAMAGE_BONUS_26: 	nDamage = 26;		break;
					case DAMAGE_BONUS_27: 	nDamage = 27;		break;
					case DAMAGE_BONUS_28: 	nDamage = 28;		break;
					case DAMAGE_BONUS_29: 	nDamage = 29;		break;
					case DAMAGE_BONUS_3: 	nDamage = 3;		break;
					case DAMAGE_BONUS_30: 	nDamage = 30;		break;
					case DAMAGE_BONUS_31: 	nDamage = 31;		break;
					case DAMAGE_BONUS_32:	nDamage = 32;		break;
					case DAMAGE_BONUS_33:	nDamage = 33;		break;
					case DAMAGE_BONUS_34:	nDamage = 34;		break;
					case DAMAGE_BONUS_35: 	nDamage = 35;		break;
					case DAMAGE_BONUS_36: 	nDamage = 36;		break;
					case DAMAGE_BONUS_37: 	nDamage = 37;		break;
					case DAMAGE_BONUS_38: 	nDamage = 38;		break;
					case DAMAGE_BONUS_39: 	nDamage = 39;		break;
					case DAMAGE_BONUS_4: 	nDamage = 4;		break;
					case DAMAGE_BONUS_40: 	nDamage = 40;		break;
					case DAMAGE_BONUS_5: 	nDamage = 5;		break;
					case DAMAGE_BONUS_6: 	nDamage = 6;		break;
					case DAMAGE_BONUS_7: 	nDamage = 7;		break;
					case DAMAGE_BONUS_8:	nDamage = 8;		break;
					case DAMAGE_BONUS_9: 	nDamage = 9;		break;
					default: 				nDamage = 1;		break;
				}
			}
		}
		else
		{
			switch (nDamageBonus)
			{
				case DAMAGE_BONUS_1:	nDamage = 1;		break;
				case DAMAGE_BONUS_10: 	nDamage = 10;		break;
				case DAMAGE_BONUS_11: 	nDamage = 11;		break;
				case DAMAGE_BONUS_12: 	nDamage = 12;		break;
				case DAMAGE_BONUS_13: 	nDamage = 13;		break;
				case DAMAGE_BONUS_14: 	nDamage = 14;		break;
				case DAMAGE_BONUS_15: 	nDamage = 15;		break;
				case DAMAGE_BONUS_16: 	nDamage = 16;		break;
				case DAMAGE_BONUS_17: 	nDamage = 17;		break;
				case DAMAGE_BONUS_18: 	nDamage = 18;		break;
				case DAMAGE_BONUS_19: 	nDamage = 19;		break;
				case DAMAGE_BONUS_1d10:	nDamage = d10(1);	break;
				case DAMAGE_BONUS_1d12: nDamage = d12(1);	break;
				case DAMAGE_BONUS_1d4: 	nDamage = d4(1);	break;
				case DAMAGE_BONUS_1d6: 	nDamage = d6(1);	break;
				case DAMAGE_BONUS_1d8: 	nDamage = d8(1);	break;
				case DAMAGE_BONUS_2: 	nDamage = 2;		break;
				case DAMAGE_BONUS_20: 	nDamage = 20;		break;
				case DAMAGE_BONUS_21: 	nDamage = 21;		break;
				case DAMAGE_BONUS_22: 	nDamage = 22;		break;
				case DAMAGE_BONUS_23: 	nDamage = 23;		break;
				case DAMAGE_BONUS_24: 	nDamage = 24;		break;
				case DAMAGE_BONUS_25: 	nDamage = 25;		break;
				case DAMAGE_BONUS_26: 	nDamage = 26;		break;
				case DAMAGE_BONUS_27: 	nDamage = 27;		break;
				case DAMAGE_BONUS_28: 	nDamage = 28;		break;
				case DAMAGE_BONUS_29: 	nDamage = 29;		break;
				case DAMAGE_BONUS_2d10: nDamage = d10(2);	break;
				case DAMAGE_BONUS_2d12: nDamage = d12(2);	break;
				case DAMAGE_BONUS_2d4: 	nDamage = d4(2);	break;
				case DAMAGE_BONUS_2d6: 	nDamage = d6(2);	break;
				case DAMAGE_BONUS_2d8: 	nDamage = d8(2);	break;
				case DAMAGE_BONUS_3: 	nDamage = 3;		break;
				case DAMAGE_BONUS_30: 	nDamage = 30;		break;
				case DAMAGE_BONUS_31: 	nDamage = 31;		break;
				case DAMAGE_BONUS_32:	nDamage = 32;		break;
				case DAMAGE_BONUS_33:	nDamage = 33;		break;
				case DAMAGE_BONUS_34:	nDamage = 34;		break;
				case DAMAGE_BONUS_35: 	nDamage = 35;		break;
				case DAMAGE_BONUS_36: 	nDamage = 36;		break;
				case DAMAGE_BONUS_37: 	nDamage = 37;		break;
				case DAMAGE_BONUS_38: 	nDamage = 38;		break;
				case DAMAGE_BONUS_39: 	nDamage = 39;		break;
				case DAMAGE_BONUS_4: 	nDamage = 4;		break;
				case DAMAGE_BONUS_40: 	nDamage = 40;		break;
				case DAMAGE_BONUS_5: 	nDamage = 5;		break;
				case DAMAGE_BONUS_6: 	nDamage = 6;		break;
				case DAMAGE_BONUS_7: 	nDamage = 7;		break;
				case DAMAGE_BONUS_8:	nDamage = 8;		break;
				case DAMAGE_BONUS_9: 	nDamage = 9;		break;
				default: 				nDamage = 1;		break;
			}
		}
	}
	else
	{
		switch (nDamageBonus)
		{
			case DAMAGE_BONUS_1:	nDamage = 1;		break;
			case DAMAGE_BONUS_10: 	nDamage = 10;		break;
			case DAMAGE_BONUS_11: 	nDamage = 11;		break;
			case DAMAGE_BONUS_12: 	nDamage = 12;		break;
			case DAMAGE_BONUS_13: 	nDamage = 13;		break;
			case DAMAGE_BONUS_14: 	nDamage = 14;		break;
			case DAMAGE_BONUS_15: 	nDamage = 15;		break;
			case DAMAGE_BONUS_16: 	nDamage = 16;		break;
			case DAMAGE_BONUS_17: 	nDamage = 17;		break;
			case DAMAGE_BONUS_18: 	nDamage = 18;		break;
			case DAMAGE_BONUS_19: 	nDamage = 19;		break;
			case DAMAGE_BONUS_1d10:	nDamage = d10(1);	break;
			case DAMAGE_BONUS_1d12: nDamage = d12(1);	break;
			case DAMAGE_BONUS_1d4: 	nDamage = d4(1);	break;
			case DAMAGE_BONUS_1d6: 	nDamage = d6(1);	break;
			case DAMAGE_BONUS_1d8: 	nDamage = d8(1);	break;
			case DAMAGE_BONUS_2: 	nDamage = 2;		break;
			case DAMAGE_BONUS_20: 	nDamage = 20;		break;
			case DAMAGE_BONUS_21: 	nDamage = 21;		break;
			case DAMAGE_BONUS_22: 	nDamage = 22;		break;
			case DAMAGE_BONUS_23: 	nDamage = 23;		break;
			case DAMAGE_BONUS_24: 	nDamage = 24;		break;
			case DAMAGE_BONUS_25: 	nDamage = 25;		break;
			case DAMAGE_BONUS_26: 	nDamage = 26;		break;
			case DAMAGE_BONUS_27: 	nDamage = 27;		break;
			case DAMAGE_BONUS_28: 	nDamage = 28;		break;
			case DAMAGE_BONUS_29: 	nDamage = 29;		break;
			case DAMAGE_BONUS_2d10: nDamage = d10(2);	break;
			case DAMAGE_BONUS_2d12: nDamage = d12(2);	break;
			case DAMAGE_BONUS_2d4: 	nDamage = d4(2);	break;
			case DAMAGE_BONUS_2d6: 	nDamage = d6(2);	break;
			case DAMAGE_BONUS_2d8: 	nDamage = d8(2);	break;
			case DAMAGE_BONUS_3: 	nDamage = 3;		break;
			case DAMAGE_BONUS_30: 	nDamage = 30;		break;
			case DAMAGE_BONUS_31: 	nDamage = 31;		break;
			case DAMAGE_BONUS_32:	nDamage = 32;		break;
			case DAMAGE_BONUS_33:	nDamage = 33;		break;
			case DAMAGE_BONUS_34:	nDamage = 34;		break;
			case DAMAGE_BONUS_35: 	nDamage = 35;		break;
			case DAMAGE_BONUS_36: 	nDamage = 36;		break;
			case DAMAGE_BONUS_37: 	nDamage = 37;		break;
			case DAMAGE_BONUS_38: 	nDamage = 38;		break;
			case DAMAGE_BONUS_39: 	nDamage = 39;		break;
			case DAMAGE_BONUS_4: 	nDamage = 4;		break;
			case DAMAGE_BONUS_40: 	nDamage = 40;		break;
			case DAMAGE_BONUS_5: 	nDamage = 5;		break;
			case DAMAGE_BONUS_6: 	nDamage = 6;		break;
			case DAMAGE_BONUS_7: 	nDamage = 7;		break;
			case DAMAGE_BONUS_8:	nDamage = 8;		break;
			case DAMAGE_BONUS_9: 	nDamage = 9;		break;
			default: 				nDamage = 1;		break;
		}
	}

	return nDamage;
}



// Functions

// The main weapon damage calculation function.
// -nMisc: Adds a damage bonus to the weapon's base damage type.
// -bIgnoreResistances: When set to true the damage of this effect will ignore
// the targeted enemey's resistances to damage.
// -nMult: Number to multiply total damage by.  Defaults to one.
struct tob_main_damage TOBGenerateAttackEffect(object oPC, object oWeapon, object oTarget, int nMisc = 0, int bIgnoreResistances = FALSE, int nMult = 1)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGenerateAttackEffect Start", GetFirstPC() ); }
	
	struct tob_main_damage main;
	int nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

	object oToB = CSLGetDataStore(oPC);
	object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND); //Creature type ignored here because this is only included for weapon size mods which claws do not influence.
	int nBaseItemType = GetBaseItemType(oWeapon); 
	int nIsRanged = GetWeaponRanged(oWeapon);
	int nBasedice = CSLGetItemDataDieToRoll(nBaseItemType);
	int nDiceNum = CSLGetItemDataNumDice(nBaseItemType);
	int nBaseDamage = CSLGetDamageByDice(nBasedice, nDiceNum);
	int nWeaponType = GetWeaponType(oWeapon);	
	int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);

/*	Drammel's Note: Split up TOBGenerateAttackEffect into TOBGenerateAttackEffect
	and TOBGenerateItemProperties to better simulate critical hit rules. Only
	enchantment bonuses have been left in this function.

	8/11/2009: Adjusting for monster damage.  Since the creature slot weapons
	use a special monster damage itemproptery for base damage they're being
	added here.*/

	// Apply Feat damage.

	if ((GetHasFeat(1957, oPC)) && (nIntMod > nStrMod))//Combat Insight
	{
		if (!nIsRanged)
		{
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

	if ((nIsRanged == TRUE) && (GetHasFeat(FEAT_POINT_BLANK_SHOT, oPC)))
	{
		float fDist = GetDistanceToObject(oTarget);
		
		if (fDist <= FeetToMeters(15.0f) + CSLGetGirth(oPC))
		{
			nStrMod += 1;
		}
	}

	if ((GetHasFeat(2141, oPC)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))) //Swashbuckler's Insightful Strike
	{
		object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
		
		if ((GetArmorRank(oArmor) == ARMOR_RANK_LIGHT) || (GetArmorRank(oArmor) == ARMOR_RANK_NONE))
		{
			if (CSLItemGetIsLightWeapon(oWeapon, oPC))
			{
				nStrMod += nIntMod;
			}
		}
	}

	if (CSLGetIsFavoredEnemy(oPC, oTarget)) // Favored Enemy
	{
		int nLevel = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
		
		if (nLevel > 29)
		{
			nStrMod += 7;
		}
		else if (nLevel > 24)
		{
			nStrMod += 6;
		}
		else if (nLevel > 19)
		{
			nStrMod += 5;
		}
		else if (nLevel > 14)
		{
			nStrMod += 4;
		}
		else if (nLevel > 9)
		{
			nStrMod += 3;
		}
		else if (nLevel > 4)
		{
			nStrMod += 2;
		}
		else nStrMod += 1;

		if (CSLGetIsImpFavoredEnemy(oPC, oTarget)) // Improved Favored Enemy
		{
			nStrMod += 3;
		}

		if (GetHasFeat(FEAT_EPIC_BANE_OF_ENEMIES, oPC))
		{
			nStrMod += CSLGetDamageByDice(6, 2);
		}
	}

	if (GetActionMode(oPC, ACTION_MODE_POWER_ATTACK))
	{
		if (GetHasFeat(FEAT_ENHANCED_POWER_ATTACK))
		{
			if ((CSLGetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
			{
				nStrMod += 15;
			}
			else if (CSLGetIsFavoredEnemyPA(oPC, oTarget))
			{
				nStrMod += 10;
			}
			else nStrMod += 5;
		}
		else if (GetHasFeat(FEAT_SUPREME_POWER_ATTACK))
		{
			if ((CSLGetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
			{
				nStrMod += 18;
			}
			else if (CSLGetIsFavoredEnemyPA(oPC, oTarget))
			{
				nStrMod += 12;
			}
			else nStrMod += 6;
		}
		else if ((CSLGetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
		{
			nStrMod += 9;
		}
		else if (CSLGetIsFavoredEnemyPA(oPC, oTarget))
		{
			nStrMod += 6;
		}
		else nStrMod += 3;
	}
	else if (GetActionMode(oPC, ACTION_MODE_IMPROVED_POWER_ATTACK))
	{
		if (GetHasFeat(FEAT_ENHANCED_POWER_ATTACK))
		{
			if ((CSLGetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
			{
				nStrMod += 30;
			}
			else if (CSLGetIsFavoredEnemyPA(oPC, oTarget))
			{
				nStrMod += 20;
			}
			else nStrMod += 10;
		}
		else if (GetHasFeat(FEAT_SUPREME_POWER_ATTACK))
		{
			if ((CSLGetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
			{
				nStrMod += 36;
			}
			else if (CSLGetIsFavoredEnemyPA(oPC, oTarget))
			{
				nStrMod += 24;
			}
			else nStrMod += 12;
		}
		else if ((CSLGetIsFavoredEnemyPA(oPC, oTarget)) && (!GetIsObjectValid(oLeftHand)))
		{
			nStrMod += 18;
		}
		else if (CSLGetIsFavoredEnemyPA(oPC, oTarget))
		{
			nStrMod += 12;
		}
		else nStrMod += 6;
	}

	if (GetHasFeat(FEAT_EPIC_PROWESS, oPC))
	{
		nStrMod += 1;
	}

	// Wpn Spec, Epic Wpn Spec
	if (GetIsObjectValid(oWeapon))
	{
		int iWeapon = GetBaseItemType(oWeapon);
		int nWSFeat = CSLGetItemDataPrefFeatWeaponSpecialization(iWeapon);
		int nEWSFeat = CSLGetItemDataPrefFeatEpicWeaponSpecialization(iWeapon);

		if (GetHasFeat(nEWSFeat, oPC))
		{
			nStrMod += 6; //Operating under the asumption that Epic and normal Weapon Spec stack.
		}
		else if (GetHasFeat(nWSFeat, oPC))
		{
			nStrMod += 2;
		}
	}
	else if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED, oPC))
	{
		nStrMod += 6;
	}
	else if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE, oPC))
	{
		nStrMod += 2;
	}

	if ((GetHasFeat(FEAT_TW_CIRCLE_OF_BLADES)) && (CSLIsFlankValid(oPC, oTarget)))
	{
		nStrMod += 2;
	}

	// Swordsage's Insightful Strike
	if (GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) > 3)
	{// The order of the logic is different here than in Blade Meditation.  It is assumed that as a class 
	 // feature, the Swordsage most likely has one of the feats, making the type of Strike check a better eliminator.
		if (GetLocalInt(oToB, "DesertWindStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DW, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DW2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "DiamondMindStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DM, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_DM2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "SettingSunStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SS, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SS2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "ShadowHandStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SH, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SH2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "StoneDragonStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SD, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_SD2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
		else if (GetLocalInt(oToB, "TigerClawStrike") == 1)
		{
			if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_TC, oPC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_INSIGHTFUL_STRIKE_TC2, oPC))
			{
				int nWis = GetAbilityModifier(ABILITY_WISDOM);
				nStrMod += nWis;
			}
		}
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_DW, oPC)) && (GetLocalInt(oToB, "DesertWindStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_DS, oPC)) && (GetLocalInt(oToB, "DevotedSpiritStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_DM, oPC)) && (GetLocalInt(oToB, "DiamondMindStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_IH, oPC)) && (GetLocalInt(oToB, "IronHeartStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_SS, oPC)) && (GetLocalInt(oToB, "SettingSunStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_SH, oPC)) && (GetLocalInt(oToB, "ShadowHandStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_SD, oPC)) && (GetLocalInt(oToB, "StoneDragonStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_TC, oPC)) && (GetLocalInt(oToB, "TigerClawStrike") == 1))
	{
		nStrMod += 1;
	}

	if ((GetHasFeat(FEAT_BLADE_MEDITATION_WR, oPC)) && (GetLocalInt(oToB, "WhiteRavenStrike") == 1))
	{
		nStrMod += 1;
	}

	nStrMod += nBaseDamage;
	nStrMod += nMisc;

	if (GetHasFeat(FEAT_PRECISE_STRIKE, oPC))
	{
		if (!GetIsObjectValid(oLeftHand) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			//Nothing in the left hand
			if (nWeaponType == WEAPON_TYPE_PIERCING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
			{
				//Valid Precise Strike weapon
				if (GetLevelByClass(CLASS_TYPE_DUELIST, oPC) > 9)
				{
					nPierce += CSLGetDamageByDice(6, 2);
				}
				else nPierce += CSLGetDamageByDice(6, 1);
			}
		}	
	}

	// Apply weapon modifiying damage.

	if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
	{
		nSlash += nStrMod;
	}
	else if (nWeaponType == WEAPON_TYPE_PIERCING)
	{
		nPierce += nStrMod;
	}
	else nBlunt += nStrMod;

	// Apply effect damage.

	effect eEffect = GetFirstEffect(oPC);

	while (GetIsEffectValid(eEffect))
	{
		int nType = GetEffectType(eEffect);

		if (nType == EFFECT_TYPE_DAMAGE_INCREASE)
		{
			int nDamage = TOBGetDamageByDamageBonus(GetEffectInteger(eEffect, 0)); //DamageBonus
			
			switch (GetEffectInteger(eEffect, 1))  //DamageType
			{
				case DAMAGE_TYPE_ACID:			nAcid += nDamage; 	break;		
				case DAMAGE_TYPE_BLUDGEONING:	nBlunt += nDamage;	break;		
				case DAMAGE_TYPE_COLD:			nCold += nDamage;	break;		
				case DAMAGE_TYPE_DIVINE:		nDivine += nDamage;	break;				
				case DAMAGE_TYPE_ELECTRICAL:	nElec += nDamage;	break;					
				case DAMAGE_TYPE_FIRE:			nFire += nDamage;	break;		
				case DAMAGE_TYPE_MAGICAL:		nMagic += nDamage;	break;		
				case DAMAGE_TYPE_NEGATIVE:		nNegat += nDamage;	break;			
				case DAMAGE_TYPE_PIERCING:		nPierce += nDamage;	break;		
				case DAMAGE_TYPE_POSITIVE:		nPosit += nDamage;	break;		
				case DAMAGE_TYPE_SLASHING:		nSlash += nDamage;	break;		
				case DAMAGE_TYPE_SONIC:			nSonic += nDamage;	break;					
			}											
		}
		else if (nType == EFFECT_TYPE_DAMAGE_DECREASE)
		{
			int nDamage = TOBGetDamageByDamageBonus(GetEffectInteger(eEffect, 0)); //DamageBonus
			
			switch (GetEffectInteger(eEffect, 1))  //DamageType
			{
				case DAMAGE_TYPE_ACID:			nAcid -= nDamage; 	break;		
				case DAMAGE_TYPE_BLUDGEONING:	nBlunt -= nDamage;	break;		
				case DAMAGE_TYPE_COLD:			nCold -= nDamage;	break;		
				case DAMAGE_TYPE_DIVINE:		nDivine -= nDamage;	break;				
				case DAMAGE_TYPE_ELECTRICAL:	nElec -= nDamage;	break;					
				case DAMAGE_TYPE_FIRE:			nFire -= nDamage;	break;		
				case DAMAGE_TYPE_MAGICAL:		nMagic -= nDamage;	break;		
				case DAMAGE_TYPE_NEGATIVE:		nNegat -= nDamage;	break;			
				case DAMAGE_TYPE_PIERCING:		nPierce -= nDamage;	break;		
				case DAMAGE_TYPE_POSITIVE:		nPosit -= nDamage;	break;		
				case DAMAGE_TYPE_SLASHING:		nSlash -= nDamage;	break;		
				case DAMAGE_TYPE_SONIC:			nSonic -= nDamage;	break;					
			}											
		}
		eEffect = GetNextEffect(oPC);
	}

	int nEnhance = 0;
	int nProp;

	itemproperty iProp;

	iProp = GetFirstItemProperty(oWeapon);

	while (GetIsItemPropertyValid(iProp))
	{
		nProp = GetItemPropertyType(iProp);

		if (nProp == ITEM_PROPERTY_ENHANCEMENT_BONUS)
		{
		  	int nItemEnhance = GetItemPropertyCostTableValue(iProp); //Enhance bonus
			if (nItemEnhance > nEnhance)
				nEnhance = nItemEnhance;
		}
		else if (nProp == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP)
		{	
			int nGoodEvil = GetAlignmentGoodEvil(oTarget);
			int nLawChaos = GetAlignmentLawChaos(oTarget);

			if ((GetItemPropertySubType(iProp) == nGoodEvil) || (GetItemPropertySubType(iProp) == nLawChaos))
			{
				int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));	
				nEnhance += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP)
		{
			int nTargetRace = GetRacialType(oTarget);

			if (GetItemPropertySubType(iProp) == nTargetRace)
			{
				int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));
				nEnhance += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT)
		{
			int nAlignment = CSLGetCreatureAlignment(oTarget);

			if (GetItemPropertySubType(iProp) == nAlignment)
			{
				int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));
				nEnhance += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_MONSTER_DAMAGE)
		{
			int nMonster = GetItemPropertyCostTableValue(iProp);

			switch (nMonster) // Monsters should get no Aura of Chaos, so it's okay to do it this way.
			{
				case IP_CONST_MONSTERDAMAGE_1d2:	nEnhance += d2(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d3:	nEnhance += d3(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d4:	nEnhance += d4(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d6:	nEnhance += d6(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d8:	nEnhance += d8(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d10:	nEnhance += d10(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d12:	nEnhance += d12(1);	break;
				case IP_CONST_MONSTERDAMAGE_1d20:	nEnhance += d20(1);	break;
				case IP_CONST_MONSTERDAMAGE_2d4:	nEnhance += d4(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d6:	nEnhance += d6(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d8:	nEnhance += d8(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d10:	nEnhance += d10(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d12:	nEnhance += d12(2);	break;
				case IP_CONST_MONSTERDAMAGE_2d20:	nEnhance += d20(2);	break;
				case IP_CONST_MONSTERDAMAGE_3d4:	nEnhance += d4(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d6:	nEnhance += d6(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d8:	nEnhance += d8(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d10:	nEnhance += d10(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d12:	nEnhance += d12(3);	break;
				case IP_CONST_MONSTERDAMAGE_3d20:	nEnhance += d20(3);	break;
				case IP_CONST_MONSTERDAMAGE_4d4:	nEnhance += d4(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d6:	nEnhance += d6(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d8:	nEnhance += d8(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d10:	nEnhance += d10(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d12:	nEnhance += d12(4);	break;
				case IP_CONST_MONSTERDAMAGE_4d20:	nEnhance += d20(4);	break;
				case IP_CONST_MONSTERDAMAGE_5d4:	nEnhance += d4(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d6:	nEnhance += d6(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d8:	nEnhance += d8(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d10:	nEnhance += d10(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d12:	nEnhance += d12(5);	break;
				case IP_CONST_MONSTERDAMAGE_5d20:	nEnhance += d20(5);	break;
				case IP_CONST_MONSTERDAMAGE_6d6:	nEnhance += d6(6);	break;
				case IP_CONST_MONSTERDAMAGE_6d8:	nEnhance += d8(6);	break;
				case IP_CONST_MONSTERDAMAGE_6d10:	nEnhance += d10(6);	break;
				case IP_CONST_MONSTERDAMAGE_6d12:	nEnhance += d12(6);	break;
				case IP_CONST_MONSTERDAMAGE_6d20:	nEnhance += d20(6);	break;
				case IP_CONST_MONSTERDAMAGE_7d6:	nEnhance += d6(7);	break;
				case IP_CONST_MONSTERDAMAGE_7d8:	nEnhance += d8(7);	break;
				case IP_CONST_MONSTERDAMAGE_7d10:	nEnhance += d10(7);	break;
				case IP_CONST_MONSTERDAMAGE_7d12:	nEnhance += d12(7);	break;
				case IP_CONST_MONSTERDAMAGE_7d20:	nEnhance += d20(7);	break;
				case IP_CONST_MONSTERDAMAGE_8d6:	nEnhance += d6(8);	break;
				case IP_CONST_MONSTERDAMAGE_8d8:	nEnhance += d8(8);	break;
				case IP_CONST_MONSTERDAMAGE_8d10:	nEnhance += d10(8);	break;
				case IP_CONST_MONSTERDAMAGE_8d12:	nEnhance += d12(8);	break;
				case IP_CONST_MONSTERDAMAGE_8d20:	nEnhance += d20(8);	break;
				case IP_CONST_MONSTERDAMAGE_9d6:	nEnhance += d6(9);	break;
				case IP_CONST_MONSTERDAMAGE_9d8:	nEnhance += d8(9);	break;
				case IP_CONST_MONSTERDAMAGE_9d10:	nEnhance += d10(9);	break;
				case IP_CONST_MONSTERDAMAGE_9d12:	nEnhance += d12(9);	break;
				case IP_CONST_MONSTERDAMAGE_9d20:	nEnhance += d20(9);	break;
				case IP_CONST_MONSTERDAMAGE_10d6:	nEnhance += d6(10);	break;
				case IP_CONST_MONSTERDAMAGE_10d8:	nEnhance += d8(10);	break;
				case IP_CONST_MONSTERDAMAGE_10d10:	nEnhance += d10(10);break;
				case IP_CONST_MONSTERDAMAGE_10d12:	nEnhance += d12(10);break;
				case IP_CONST_MONSTERDAMAGE_10d20:	nEnhance += d20(10);break; //I never want to fight the thing that does this!
			}
		}
		else if (nProp == ITEM_PROPERTY_DECREASED_DAMAGE || nProp == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER)
		{
			int nPenalty = GetItemPropertyCostTableValue(iProp);

			if (nPenalty < nEnhance)
			{
				nEnhance -= nPenalty;
			}
		}	
		iProp = GetNextItemProperty(oWeapon);
	}

	if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
	{
		nSlash += nEnhance;
	}
	else if (nWeaponType == WEAPON_TYPE_PIERCING)
	{
		nPierce += nEnhance;
	}
	else nBlunt += nEnhance;

	if (nIsRanged == TRUE)  // Gets bonuses from ammo as well as the bow, if it was called by the last set of routines.
	{
		int nBaseType = GetBaseItemType(oWeapon);
		int nEnhance = 0;

		object oAmmo;
		if (nBaseType == BASE_ITEM_LIGHTCROSSBOW || nBaseType == BASE_ITEM_HEAVYCROSSBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
		if (nBaseType == BASE_ITEM_LONGBOW || nBaseType == BASE_ITEM_SHORTBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
		if (nBaseType == BASE_ITEM_SLING)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);						

		itemproperty iProp = GetFirstItemProperty(oAmmo);

		while (GetIsItemPropertyValid(iProp))
		{
			if (GetItemPropertyType(iProp) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
			{
			  	int nItemEnhance = GetItemPropertyCostTableValue(iProp); //Enhance bonus
				if (nItemEnhance > nEnhance)
					nEnhance = nItemEnhance;
			}			
			iProp = GetNextItemProperty(oAmmo);
		}

		if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
		{	
			nSlash += nEnhance;
		}
		else if (nWeaponType == WEAPON_TYPE_PIERCING)
		{
			nPierce += nEnhance;
		}
		else nBlunt += nEnhance;
	}

	nSlash *= nMult;
	nBlunt *= nMult;
	nPierce *= nMult;
	nAcid *= nMult;
	nCold *= nMult;
	nElec *= nMult;
	nFire *= nMult;
	nSonic*= nMult;
	nDivine *= nMult;
	nMagic *= nMult;
	nPosit *= nMult;
	nNegat *= nMult;

	// Convert all damage to fire damage if we're using the maneuver Burning Brand.
	if (GetLocalInt(oPC, "BurningBrand") == 1)
	{
		if (nPierce > 0)
		{
			nFire += nPierce;
			nPierce = 0;
		}

		if (nBlunt > 0)
		{
			nFire += nBlunt;
			nBlunt = 0;
		}

		if (nSlash > 0)
		{
			nFire += nSlash;
			nSlash = 0;
		}

		if (nAcid > 0)
		{
			nFire += nAcid;
			nAcid = 0;
		}

		if (nCold > 0)
		{
			nFire += nCold;
			nCold = 0;
		}

		if (nSonic > 0)
		{
			nFire += nSonic;
			nSonic = 0;
		}

		if (nDivine > 0)
		{
			nFire += nDivine;
			nDivine = 0;
		}

		if (nElec > 0)
		{
			nFire += nElec;
			nElec = 0;
		}

		if (nMagic > 0)
		{
			nFire += nMagic;
			nMagic = 0;
		}

		if (nPosit > 0)
		{
			nFire += nPosit;
			nPosit = 0;
		}

		if (nNegat > 0)
		{
			nFire += nNegat;
			nNegat = 0;
		}
	}

	//Time to build a mega damage event.

	if (!GetIsObjectValid(oWeapon))
	{
		// Calling this function stores data to be used for calculating the struct.
		effect eDmg = CSLSnapKickDamage(); // Fortunately, Snap Kick will get apporpiate unarmed damage and runs a check for Superior Unarmed Strike.
		int nSnapDamage = GetLocalInt(oPC, "SnapKickStoredDam");
		int nSnapType = GetLocalInt(oPC, "SnapKickType");

		if (nSnapType == DAMAGE_TYPE_BLUDGEONING)
		{
			nBlunt += nSnapDamage;
		}
		else nMagic += nSnapDamage;
	}

	if (nBlunt > 0)
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15) && (!GetIsObjectValid(oWeapon)))
		{
			nMagic += nBlunt;
			nBlunt = 0;
		}
	}

	int nStrikeTotal = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nStrike = nSlash + nBlunt + nPierce + nAcid + nCold + nElec + nFire + nSonic + nDivine + nMagic + nPosit + nNegat;

	// Used in certain strikes.  The variable must be cleared out in the strike script or the damage will continue to pile.
	SetLocalInt(oPC, "bot9s_StrikeTotal", nStrikeTotal + nStrike);

	main.nPierce = nPierce;
	main.nAcid = nAcid;
	main.nSlash = nSlash;
	main.nBlunt = nBlunt;
	main.nCold = nCold;
	main.nElec = nElec;			
	main.nFire = nFire;
	main.nSonic = nSonic;
	main.nDivine = nDivine;
	main.nMagic = nMagic;			
	main.nPosit = nPosit;
	main.nNegat = nNegat;

	return main;	
}



// Calculates effects from item properties.
struct tob_main_damage TOBGenerateItemProperties(object oPC, object oWeapon, object oTarget, int bIgnoreResistances = FALSE, int nMult = 1)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGenerateItemProperties Start", GetFirstPC() ); }
	
	struct tob_main_damage main;
	int nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

	int nBaseItemType = GetBaseItemType(oWeapon); 
	int nIsRanged = GetWeaponRanged(oWeapon);
	int nProp;
		
	itemproperty iProp;

	iProp = GetFirstItemProperty(oWeapon);

	while (GetIsItemPropertyValid(iProp))
	{
		nProp = GetItemPropertyType(iProp);

		if (nProp == ITEM_PROPERTY_DAMAGE_BONUS)
		{	
			int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));
			
			switch (GetItemPropertySubType(iProp))  //DamageType
			{
				case IP_CONST_DAMAGETYPE_ACID:			nAcid += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_BLUDGEONING:	nBlunt += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_COLD:			nCold += nDamage;	break;		
				case IP_CONST_DAMAGETYPE_DIVINE:		nDivine += nDamage;	break;						
				case IP_CONST_DAMAGETYPE_ELECTRICAL:	nElec += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_FIRE:			nFire += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_MAGICAL:		nMagic += nDamage;	break;			
				case IP_CONST_DAMAGETYPE_NEGATIVE:		nNegat += nDamage;	break;			
				case IP_CONST_DAMAGETYPE_PHYSICAL:		nSlash += nDamage;	break;		
				case IP_CONST_DAMAGETYPE_PIERCING:		nPierce += nDamage;	break;					
				case IP_CONST_DAMAGETYPE_POSITIVE:		nPosit += nDamage;	break;					
				case IP_CONST_DAMAGETYPE_SLASHING:		nSlash += nDamage;	break;				
				case IP_CONST_DAMAGETYPE_SONIC:			nSonic += nDamage;	break;																														
			}
		}
		else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
		{	
			int nGoodEvil = GetAlignmentGoodEvil(oTarget);
			int nLawChaos = GetAlignmentLawChaos(oTarget);

			if ((GetItemPropertySubType(iProp) == nGoodEvil) || (GetItemPropertySubType(iProp) == nLawChaos))
			{
				int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));	
				nMagic += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
		{
			int nTargetRace = GetRacialType(oTarget);

			if (GetItemPropertySubType(iProp) == nTargetRace)
			{
				int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));
				nMagic += nDamage;
			}
		}
		else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
		{
			int nAlignment = CSLGetCreatureAlignment(oTarget);

			if (GetItemPropertySubType(iProp) == nAlignment)
			{
				int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));
				nMagic += nDamage;
			}
		}		
		iProp = GetNextItemProperty(oWeapon);
	}

	if (nIsRanged == TRUE)  // Gets bonuses from ammo as well as the bow, if it was called by the last set of routines.
	{
		int nBaseType = GetBaseItemType(oWeapon);

		object oAmmo;
		if (nBaseType == BASE_ITEM_LIGHTCROSSBOW || nBaseType == BASE_ITEM_HEAVYCROSSBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
		if (nBaseType == BASE_ITEM_LONGBOW || nBaseType == BASE_ITEM_SHORTBOW)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
		if (nBaseType == BASE_ITEM_SLING)
			oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);						

		itemproperty iProp = GetFirstItemProperty(oAmmo);

		while (GetIsItemPropertyValid(iProp))
		{
			nProp = GetItemPropertyType(iProp);

			if (nProp == ITEM_PROPERTY_DAMAGE_BONUS)
			{
			  	GetItemPropertyCostTableValue(iProp); //IP_CONST_DAMAGEBONUS
				GetItemPropertySubType(iProp); //IP_CONST_DAMAGETYPE

				int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));

				switch (GetItemPropertySubType(iProp))  //DamageType
				{
					case IP_CONST_DAMAGETYPE_ACID:			nAcid += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_BLUDGEONING:	nBlunt += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_COLD:			nCold += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_DIVINE:		nDivine += nDamage;	break;						
					case IP_CONST_DAMAGETYPE_ELECTRICAL:	nElec += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_FIRE:			nFire += nDamage;	break;						
					case IP_CONST_DAMAGETYPE_MAGICAL:		nMagic += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_NEGATIVE:		nNegat += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_PHYSICAL:		nSlash += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_PIERCING:		nPierce += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_POSITIVE:		nPosit += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_SLASHING:		nSlash += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_SONIC:			nSonic += nDamage;	break;																														
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
			{	
				int nGoodEvil = GetAlignmentGoodEvil(oTarget);
				int nLawChaos = GetAlignmentLawChaos(oTarget);

				if ((GetItemPropertySubType(iProp) == nGoodEvil) || (GetItemPropertySubType(iProp) == nLawChaos))
				{
					int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));	
					nMagic += nDamage;
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
			{
				int nTargetRace = GetRacialType(oTarget);

				if (GetItemPropertySubType(iProp) == nTargetRace)
				{
					int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));
					nMagic += nDamage;
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
			{
				int nAlignment = CSLGetCreatureAlignment(oTarget);

				if (GetItemPropertySubType(iProp) == nAlignment)
				{
					int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));
					nMagic += nDamage;
				}
			}					
			iProp = GetNextItemProperty(oAmmo);
		}
	}

	if (!GetIsObjectValid(oWeapon)) // love for monks
	{
		object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS);
		itemproperty iArm = GetFirstItemProperty(oArms);

		while (GetIsItemPropertyValid(iArm))
		{
			nProp = GetItemPropertyType(iArm);

			if (nProp == ITEM_PROPERTY_DAMAGE_BONUS)
			{	
				int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iArm));

				switch (GetItemPropertySubType(iArm))  //DamageType
				{
					case IP_CONST_DAMAGETYPE_ACID:			nAcid += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_BLUDGEONING:	nBlunt += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_COLD:			nCold += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_DIVINE:		nDivine += nDamage;	break;						
					case IP_CONST_DAMAGETYPE_ELECTRICAL:	nElec += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_FIRE:			nFire += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_MAGICAL:		nMagic += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_NEGATIVE:		nNegat += nDamage;	break;			
					case IP_CONST_DAMAGETYPE_PHYSICAL:		nSlash += nDamage;	break;		
					case IP_CONST_DAMAGETYPE_PIERCING:		nPierce += nDamage;	break;					
					case IP_CONST_DAMAGETYPE_POSITIVE:		nPosit += nDamage;	break;					
					case IP_CONST_DAMAGETYPE_SLASHING:		nSlash += nDamage;	break;				
					case IP_CONST_DAMAGETYPE_SONIC:			nSonic += nDamage;	break;																														
				}	
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
			{	
				int nGoodEvil = GetAlignmentGoodEvil(oTarget);
				int nLawChaos = GetAlignmentLawChaos(oTarget);

				if ((GetItemPropertySubType(iArm) == nGoodEvil) || (GetItemPropertySubType(iArm) == nLawChaos))
				{
					int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iArm));	
					nMagic += nDamage;
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
			{
				int nTargetRace = GetRacialType(oTarget);

				if (GetItemPropertySubType(iProp) == nTargetRace)
				{
					int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iArm));
					nMagic += nDamage;
				}
			}
			else if (nProp == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
			{
				int nAlignment = CSLGetCreatureAlignment(oTarget);

				if (GetItemPropertySubType(iArm) == nAlignment)
				{
					int nDamage = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iArm));
					nMagic += nDamage;
				}
			}		
			iArm = GetNextItemProperty(oArms);
		}
	}

	nSlash *= nMult;
	nBlunt *= nMult;
	nPierce *= nMult;
	nAcid *= nMult;
	nCold *= nMult;
	nElec *= nMult;
	nFire *= nMult;
	nSonic*= nMult;
	nDivine *= nMult;
	nMagic *= nMult;
	nPosit *= nMult;
	nNegat *= nMult;

	// Convert all damage to fire damage if we're using the maneuver Burning Brand.
	if (GetLocalInt(oPC, "BurningBrand") == 1)
	{
		if (nPierce > 0)
		{
			nFire += nPierce;
			nPierce = 0;
		}

		if (nBlunt > 0)
		{
			nFire += nBlunt;
			nBlunt = 0;
		}

		if (nSlash > 0)
		{
			nFire += nSlash;
			nSlash = 0;
		}

		if (nAcid > 0)
		{
			nFire += nAcid;
			nAcid = 0;
		}

		if (nCold > 0)
		{
			nFire += nCold;
			nCold = 0;
		}

		if (nSonic > 0)
		{
			nFire += nSonic;
			nSonic = 0;
		}

		if (nDivine > 0)
		{
			nFire += nDivine;
			nDivine = 0;
		}

		if (nElec > 0)
		{
			nFire += nElec;
			nElec = 0;
		}

		if (nMagic > 0)
		{
			nFire += nMagic;
			nMagic = 0;
		}

		if (nPosit > 0)
		{
			nFire += nPosit;
			nPosit = 0;
		}

		if (nNegat > 0)
		{
			nFire += nNegat;
			nNegat = 0;
		}
	}

	//Time to build a mega damage event.

	if (!GetIsObjectValid(oWeapon))
	{
		// Calling this function stores data to be used for calculating the struct.
		effect eDmg = CSLSnapKickDamage(); // Fortunately, Snap Kick will get apporpiate unarmed damage and runs a check for Superior Unarmed Strike.
		int nSnapDamage = GetLocalInt(oPC, "SnapKickStoredDam");
		int nSnapType = GetLocalInt(oPC, "SnapKickType");

		if (nSnapType == DAMAGE_TYPE_BLUDGEONING)
		{
			nBlunt += nSnapDamage;
		}
		else nMagic += nSnapDamage;
	}

	if (nBlunt > 0)
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15) && (!GetIsObjectValid(oWeapon)))
		{
			nMagic += nBlunt;
			nBlunt = 0;
		}
	}

	int nStrikeTotal = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nStrike = nSlash + nBlunt + nPierce + nAcid + nCold + nElec + nFire + nSonic + nDivine + nMagic + nPosit + nNegat;

	// Used in certain strikes.  The variable must be cleared out in the strike script or the damage will continue to pile.
	SetLocalInt(oPC, "bot9s_StrikeTotal", nStrikeTotal + nStrike);

	main.nPierce = nPierce;
	main.nAcid = nAcid;
	main.nSlash = nSlash;
	main.nBlunt = nBlunt;
	main.nCold = nCold;
	main.nElec = nElec;			
	main.nFire = nFire;
	main.nSonic = nSonic;
	main.nDivine = nDivine;
	main.nMagic = nMagic;			
	main.nPosit = nPosit;
	main.nNegat = nNegat;

	return main;
}


// Calculates Sneak Attack Damage
struct tob_main_damage TOBSneakAttack(object oWeapon, object oPC, object oFoe, int bIgnoreResistances = FALSE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBSneakAttack Start", GetFirstPC() ); }
	
	struct tob_main_damage main;
	int nSneakAttack, nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

	object oToB = CSLGetDataStore(oPC);
	int nBaseItemType = GetBaseItemType(oWeapon);
	int nWeaponType = GetWeaponType(oWeapon);
	int nDice = CSLGetTotalSneakDice(oPC, oFoe);
	
	nSneakAttack = CSLGetDamageByDice(6, nDice);
	
	// Get immuntiy and exceptions to immunity.	
	if (GetIsImmune(oFoe, IMMUNITY_TYPE_SNEAK_ATTACK) || GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT))
	{
		int nSub = GetSubRace(oFoe);

		if (GetHasFeat(2128, oPC)) // Epic Precision
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((nSub == RACIAL_SUBTYPE_UNDEAD) && (GetHasFeat(2129, oPC))) // Death's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((nSub == RACIAL_SUBTYPE_ELEMENTAL) && (GetHasFeat(2130, oPC))) // Elemental's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((nSub == RACIAL_SUBTYPE_PLANT) && (GetHasFeat(2131, oPC))) // Nature's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((GetIsSpirit(oFoe)) && (GetHasFeat(2132, oPC))) // Spirit's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else if ((nSub == RACIAL_SUBTYPE_CONSTRUCT) && (GetHasFeat(2133, oPC))) // Builder's Ruin
		{
			nSneakAttack = nSneakAttack / 2;
		}
		else nSneakAttack = 0;
	}

	if (nSneakAttack > 0)
	{
		SetLocalInt(oPC, "SneakHasHit", 1);
		DelayCommand(0.5f, SetLocalInt(oPC, "SneakHasHit", 0));

		if (GetLocalInt(oPC, "BurningBrand") == 1)
		{
			nFire += nSneakAttack;
		}
		else if (nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
		{
			nSlash += nSneakAttack;
		}
		else if (nWeaponType == WEAPON_TYPE_PIERCING)
		{
			nPierce += nSneakAttack;
		}
		else nBlunt += nSneakAttack;
	}

	//Time to build a mega damage event.

	if (nBlunt > 0)
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15) && (!GetIsObjectValid(oWeapon)))
		{
			nMagic += nBlunt;
			nBlunt = 0;
		}
	}

	int nStrikeTotal = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nStrike = nSlash + nBlunt + nPierce + nAcid + nCold + nElec + nFire + nSonic + nDivine + nMagic + nPosit + nNegat;

	// Used in certain strikes.  The variable must be cleared out in the strike script or the damage will continue to pile.
	SetLocalInt(oPC, "bot9s_StrikeTotal", nStrikeTotal + nStrike);

	main.nPierce = nPierce;
	main.nAcid = nAcid;
	main.nSlash = nSlash;
	main.nBlunt = nBlunt;
	main.nCold = nCold;
	main.nElec = nElec;			
	main.nFire = nFire;
	main.nSonic = nSonic;
	main.nDivine = nDivine;
	main.nMagic = nMagic;			
	main.nPosit = nPosit;
	main.nNegat = nNegat;

	return main;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// Creates a list of feats that the PC knows.
// Must be broken into several parts to avoid a TMI error.
int TOBAddKnownFeats(object oPC, object oToB, int nStart, int nFinish)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBAddKnownFeats Start", GetFirstPC() ); }
	
	//object oToB = CSLGetDataStore(oPC);
	string sScreen = "SCREEN_LEVELUP_RETRAIN_FEATS";
	string sPane = "RETRAINPANE_PROTO";
	int i, nFSWpnFocus, nFSWeaponSpec, nForbidden, nForbidden1, nForbidden2, nForbidden3, nForbidden4, nForbidden5, nForbidden6;
	string sFeatType, sIcon, sName, sVari;

	// Favored Soul Weapon Proficeny is granted as a bonus feat and if it is
	// removed is granted again on each levelup it isn't present.  A check must
	// be used to prevent the class from granting free feats.
	if (GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) > 0)
	{
		CSLGetDeityDataObject();
		int iDeityId = CSLGetDeityDataRowByName( GetDeity(oPC) );
		if ( GetIsObjectValid( oDeityTable ) ) // this is optional, if it's setup it will use the cache, if not 2da's
		{
			nFSWpnFocus = StringToInt(CSLDataTableGetStringByRow( oDeityTable, "FavoredWeaponFocus", iDeityId ));
			nFSWeaponSpec = StringToInt(CSLDataTableGetStringByRow( oDeityTable, "FavoredWeaponSpecialization", iDeityId ));
		}
		else
		{
			nFSWpnFocus = StringToInt(Get2DAString("nwn2_deities", "FavoredWeaponFocus", iDeityId));
			nFSWeaponSpec = StringToInt(Get2DAString("nwn2_deities", "FavoredWeaponSpecialization", iDeityId));
		}
	}

	i = nStart;

	while (i < nFinish)
	{
		nForbidden = 0;
		nForbidden1 = GetLocalInt(oToB, "ForbiddenRetrain1");
		nForbidden2 = GetLocalInt(oToB, "ForbiddenRetrain2");
		nForbidden3 = GetLocalInt(oToB, "ForbiddenRetrain3");
		nForbidden4 = GetLocalInt(oToB, "ForbiddenRetrain4");
		nForbidden5 = GetLocalInt(oToB, "ForbiddenRetrain5");
		nForbidden6 = GetLocalInt(oToB, "ForbiddenRetrain6");

		if (i == nForbidden1)
		{
			nForbidden = 1;
		}

		if ((i == nForbidden2) && (nForbidden2 > 0)) // Because Alertness is something we'd never think of retraining! ;)
		{
			nForbidden = 1;
		}

		if ((i == nForbidden3) && (nForbidden3 > 0))
		{
			nForbidden = 1;
		}

		if ((i == nForbidden4) && (nForbidden4 > 0))
		{
			nForbidden = 1;
		}

		if ((i == nForbidden5) && (nForbidden5 > 0))
		{
			nForbidden = 1;
		}

		if ((i == nForbidden6) && (nForbidden6 > 0))
		{
			nForbidden = 1;
		}

		// Special cases, like Use Poison.
		if (i == 0 || i == 1799 || i == 1800 || i == 2129 || i == 2130 || i == 2131
		|| i == 1912 || i == 1913 || i == 1914 || i == 1915 || i == 1916 || i == 960
		|| i == 1113 || i == 1116 || i == 1917 ||  i == 2132 || i == 2133 || i == 6945
		|| i == 6831 || i == FEAT_MARTIAL_STUDY || i == FEAT_MARTIAL_STANCE)
		{
			nForbidden = 1;
		}

		// Bonus feats for classes.  Must be forbidden because feats granted by classes are automatically regranted to the player on levelup if they have been removed.
		if ((GetLevelByClass(CLASS_TYPE_CRUSADER, oPC) > 9) && (i == FEAT_DIEHARD_CRUSADER))
		{
			nForbidden = 1;
		}

		if ((GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) > 4) && (i == FEAT_IMPROVED_INITIATIVE))
		{
			nForbidden = 1;
		}

		if ((GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC) > 0) && (i == FEAT_LUCK_OF_HEROES || i == FEAT_MOBILITY || i == FEAT_WEAPON_FINESSE))
		{
			nForbidden = 1;
		}

		if (i == nFSWpnFocus || i == nFSWeaponSpec) //Favored Soul Stuff
		{
			nForbidden = 1;
		}

		if (GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oPC) > 0)
		{
			if (i == FEAT_MAXIMIZE_SPELL || i == FEAT_QUICKEN_SPELL || i == FEAT_IMPROVED_EMPOWER_SPELL
			|| i == FEAT_IMPROVED_MAXIMIZE_SPELL || i == FEAT_IMPROVED_QUICKEN_SPELL)
			{
				nForbidden = 1;
			}
		}

		if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
		{
			if (i == 21 || i == 39 || i == 8 || i == 17 || i == 24)
			{
				nForbidden = 1;
			}
		}

		if ((GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0) && (i == FEAT_TOUGHNESS))
		{
			nForbidden = 1;
		}

		if ((GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER, oPC) > 0) && (i == FEAT_TOUGHNESS))
		{
			nForbidden = 1;
		}

		// Racial abilites that shouldn't be retrained as well.
		if (GetSubRace(oPC) == RACIAL_SUBTYPE_AASIMAR)
		{
			if (i == 427 || i == 428 || i == 430)
			{
				nForbidden = 1;
			}
		}
		else if (GetSubRace(oPC) == RACIAL_SUBTYPE_TIEFLING)
		{
			if (i == 427 || i == 429 || i == 430)
			{
				nForbidden = 1;
			}
		}
		else if (GetSubRace(oPC) == RACIAL_SUBTYPE_GRAYORC)
		{
			if (i == 2178 || i == 1116 || i == 2248)
			{
				nForbidden = 1;
			}
		}
		else if (GetSubRace(oPC) == RACIAL_SUBTYPE_YUANTI)
		{
			if (i == 0 || i == 408 || i == 2171)
			{
				nForbidden = 1;
			}
		}

		if ((GetHasFeat(i, oPC)) && (GetLocalInt(oToB, "FeatRetrain1") != i) && (nForbidden == 0) && (i != 0))
		{
			sFeatType = Get2DAString("feat", "FeatCategory", i);

			if (sFeatType == "GENERAL_FT_CAT" || sFeatType == "SKILLNSAVE_FT_CAT" || sFeatType == "SPELLCASTING_FT_CAT" || sFeatType == "METAMAGIC_FT_CAT" || sFeatType == "DIVINE_FT_CAT" || sFeatType == "EPIC_FT_CAT")
			{
				sIcon = "RETRAIN_IMAGE=" + CSLGetFeatDataIcon(i) + ".tga";
				sName = "RETRAIN_TEXT=" + CSLGetFeatDataName(i);
				sVari = "7=" + IntToString(i);

				AddListBoxRow(oPC, sScreen, "RETRAIN_FEATS_LIST", sPane + IntToString(i), sName, sIcon, sVari, "");
			}
		}
		i++;
	}
	return i;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Runs the above function for the entire feat.2da listing.
// Runs the above function for the entire feat.2da listing.
void TOBAddAllKnownFeats(object oPC, object oToB, int nStart, int nFinish)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBAddAllKnownFeats Start", GetFirstPC() ); }
	
	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loop if we just want to finish leveling.
	{
		return;
	}

	// nStart is at 1 because Alertness causes all sorts of problems and needs to be excluded.
	int nLimit = GetNum2DARows("feat");
	int i = TOBAddKnownFeats(oPC, oToB, nStart, nFinish);

	if (i < nLimit) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nFinish + 50 > nLimit)
		{
			nFinish = nLimit;
		}
		else nFinish = nFinish + 50;

		DelayCommand(0.01f, TOBAddAllKnownFeats(oPC, oToB, i, nFinish));
	}
}

// Filters which feats should be added and which should not.
int TOBCheckFeat(int i, object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCheckFeat Start", GetFirstPC() ); }
	
	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loops if we just want to finish leveling.
	{
		return 0;
	}

	string sFeatType = CSLGetFeatDataFeatCategory(i);

	if (sFeatType == "GENERAL_FT_CAT" || sFeatType == "SKILLNSAVE_FT_CAT" || sFeatType == "DIVINE_FT_CAT")
	{
		int nPending1 = GetLocalInt(oToB, "PendingFeat1");
		int nPending2 = GetLocalInt(oToB, "PendingFeat2");

		if (i == nPending1)
		{
			return FALSE;
		}
		else if (i == nPending2)
		{
			return FALSE;
		}

		int nRetrain1 = GetLocalInt(oToB, "FeatRetrain1");
		int nRetrain2 = GetLocalInt(oToB, "FeatRetrain2");

		if ((!GetHasFeat(i, oPC)) || (i == nRetrain1) || (i == nRetrain2))
		{
			// Special cases to enable, such as maneuver requirements.
			if ((i == FEAT_DESERT_FIRE) && (GetLocalInt(oToB, "DWTotal") >= 1))
			{
				return TRUE;
			}

			if ((i == FEAT_DESERT_WIND_DODGE) && (GetLocalInt(oToB, "DWTotal") >= 1) && (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) > 12))
			{
				return TRUE;
			}

			if ((i == FEAT_DEVOTED_BULWARK) && (GetLocalInt(oToB, "DSTotal") >= 1))
			{
				return TRUE;
			}

			if (i == FEAT_DIVINE_SPIRIT)
			{
				if ((GetLocalInt(oToB, "DSTotal") >= 1) && (GetHasFeat(FEAT_TURN_UNDEAD, oPC, TRUE)))
				{
					return TRUE;
				}
			}

			if (i == FEAT_FALLING_SUN_ATTACK)
			{
				if ((GetLocalInt(oToB, "SSTotal") >= 1) && (GetHasFeat(FEAT_STUNNING_FIST, oPC, TRUE)))
				{
					return TRUE;
				}
			}

			if ((i == FEAT_IRONHEART_AURA) && (GetLocalInt(oToB, "IHTotal") >= 1))
			{
				return TRUE;
			}

			if (i == FEAT_SHADOW_BLADE || i == FEAT_SHADOW_TRICKSTER)
			{
				if (GetLocalInt(oToB, "SHTotal") >= 1)
				{
					return TRUE;
				}
			}

			if (i == FEAT_SONG_OF_THE_WHITE_RAVEN)
			{
				if ((GetLocalInt(oToB, "WRTotal") >= 1) && (GetHasFeat(FEAT_BARDSONG_INSPIRE_COURAGE, oPC)))
				{
					return TRUE;
				}
			}

			if ((i == FEAT_STONE_POWER) && (GetLocalInt(oToB, "SDTotal") >= 1) && (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE)) > 12)
			{
				return TRUE;
			}

			if (i == FEAT_SUDDEN_RECOVERY || i == FEAT_MARTIAL_STANCE) //Not identical to what the actual checks are in the 2da, but equal.
			{
				int nDW = GetLocalInt(oToB, "DWTotal");
				int nDS = GetLocalInt(oToB, "DSTotal");
				int nDM = GetLocalInt(oToB, "DMTotal");
				int nIH = GetLocalInt(oToB, "IHTotal");
				int nSS = GetLocalInt(oToB, "SSTotal");
				int nSH = GetLocalInt(oToB, "SHTotal");
				int nSD = GetLocalInt(oToB, "SDTotal");
				int nTC = GetLocalInt(oToB, "TCTotal");
				int nWR = GetLocalInt(oToB, "WRTotal");

				if ((nDW >= 1) || (nDS >= 1) || (nDM >= 1) || (nIH >= 1) || (nSS >= 1) || (nSH >= 1) || (nSD >= 1) || (nTC >= 1) || (nWR >= 1))
				{
					return TRUE;
				}
			}

			if ((i == FEAT_TIGER_BLOODED) && (GetLocalInt(oToB, "TCTotal") >= 1))
			{
				if ((GetHasFeat(FEAT_BARBARIAN_RAGE, oPC, TRUE)) || (GetHasFeat(FEAT_WILD_SHAPE, oPC, TRUE)))
				{
					return TRUE;
				}
			}

			if (i == FEAT_VITAL_RECOVERY)
			{
				if (GetHasFeat(FEAT_MARTIAL_STANCE, oPC) || GetHasFeat(FEAT_MARTIAL_STUDY_2, oPC) || GetHasFeat(FEAT_SWORDSAGE, oPC) || GetHasFeat(FEAT_SAINT, oPC) || GetHasFeat(FEAT_WARBLADE, oPC) || GetHasFeat(FEAT_CRUSADER, oPC))
				{
					return TRUE;
				}
			}

			if ((i == FEAT_WHITE_RAVEN_DEFENSE) && (GetLocalInt(oToB, "WRTotal") >= 1))
			{
				return TRUE;
			}

			if ((i == FEAT_EXTRA_GRANTED_MANEUVER) && (GetLevelByClass(CLASS_TYPE_CRUSADER, oPC) > 0))
			{
				return TRUE;
			}

			if ((i == FEAT_EXTRA_READIED_MANEUVER) && (GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC) > 0))
			{
				return TRUE;
			}

			int nOrReq0 = CSLGetFeatDataFeatOrReqFeat0(i);
			int nOrReq1 = CSLGetFeatDataFeatOrReqFeat1(i);
			int nOrReq2 = CSLGetFeatDataFeatOrReqFeat2(i);
			int nOrReq3 = CSLGetFeatDataFeatOrReqFeat3(i);
			int nOrReq4 = CSLGetFeatDataFeatOrReqFeat4(i);
			int nOrReq5 = CSLGetFeatDataFeatOrReqFeat5(i);

			int nOrReq0State = 0;
			int nOrReq1State = 0;
			int nOrReq2State = 0;
			int nOrReq3State = 0;
			int nOrReq4State = 0;
			int nOrReq5State = 0;

			if (nOrReq0 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq0State = 1;
			}

			if (nOrReq1 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq1State = 1;
			}

			if (nOrReq2 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq2State = 1;
			}

			if (nOrReq3 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq3State = 1;
			}

			if (nOrReq4 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq4State = 1;
			}

			if (nOrReq5 == 0 || (GetHasFeat(nOrReq0, oPC)))
			{
				nOrReq5State = 1;
			}

			if ((nOrReq0State == 1) && (nOrReq1State == 1) && (nOrReq2State == 1) && (nOrReq3State == 1) && (nOrReq4State == 1) && (nOrReq5State == 1))
			{
				// it should already be removed and iterating my much smaller list of feats in the data object
				//int nRemoved = ;
	
				if ( Get2DAString("feat", "REMOVED", i) == "1")
				{
					return FALSE;
				}

				if (i == nRetrain1)
				{
					return TRUE;
				}

				if (i == nRetrain2)
				{
					return TRUE;
				}

				int nPrereq1 = CSLGetFeatDataFeatPrereqFeat1(i);

				if ((nPrereq1 != 0) && (!GetHasFeat(nPrereq1, oPC)))
				{
					return FALSE;
				}

				int nPrereq2 = CSLGetFeatDataFeatPrereqFeat2(i);

				if ((nPrereq2 != 0) && (!GetHasFeat(nPrereq2, oPC)))
				{
					return FALSE;
				}
	
				int nMinSTR = CSLGetFeatDataFeatMinStr(i);
				int nMinDEX = CSLGetFeatDataFeatMinDex(i);
				int nMinCON = CSLGetFeatDataFeatMinCon(i);
				int nMinINT = CSLGetFeatDataFeatMinInt(i);
				int nMinWIS = CSLGetFeatDataFeatMinWis(i);
				int nMinCHA = CSLGetFeatDataFeatMinCha(i);
	
				if (nMinSTR != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) < nMinSTR)
					{
						return FALSE;
					}
				}

				if (nMinDEX != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) < nMinDEX)
					{
						return FALSE;
					}
				}
	
				if (nMinCON != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) < nMinCON)
					{
						return FALSE;
					}
				}

				if (nMinINT != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) < nMinINT)
					{
						return FALSE;
					}
				}

				if (nMinWIS != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) < nMinWIS)
					{
						return FALSE;
					}
				}
	
				if (nMinCHA != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) < nMinCHA)
					{
						return FALSE;
					}
				}
	
				int nMaxSTR = CSLGetFeatDataFeatMaxStr(i);
				int nMaxDEX = CSLGetFeatDataFeatMaxDex(i);
				int nMaxCON = CSLGetFeatDataFeatMaxCon(i);
				int nMaxINT = CSLGetFeatDataFeatMaxInt(i);
				int nMaxWIS = CSLGetFeatDataFeatMaxWis(i);
				int nMaxCHA = CSLGetFeatDataFeatMaxCHA(i);

				if (nMaxSTR != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE) > nMaxSTR)
					{
						return FALSE;
					}
				}

				if (nMaxDEX != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE) > nMaxDEX)
					{
						return FALSE;
					}
				}
	
				if (nMaxCON != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE) > nMaxCON)
					{
						return FALSE;
					}
				}

				if (nMaxINT != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) > nMaxINT)
					{
						return FALSE;
					}
				}
	
				if (nMaxWIS != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_WISDOM, TRUE) > nMaxWIS)
					{
						return FALSE;
					}
				}

				if (nMaxCHA != 0)
				{
					if (GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE) > nMaxCHA)
					{
						return FALSE;
					}
				}
	
				int nReqSkill = CSLGetFeatDataFeatReqSkill(i);
				int nReqSkill2 = CSLGetFeatDataFeatReqSkill2(i);

				if (nReqSkill != 0)
				{
					int nMyRanks1 = GetSkillRank(nReqSkill, oPC, TRUE);
					int nReqSkillMinRank = CSLGetFeatDataFeatReqSkillMinRanks(i);
					int nReqSkillMaxRank = CSLGetFeatDataFeatReqSkillMaxRanks(i);

					if (nReqSkillMinRank != 0)
					{
						if (nMyRanks1 < nReqSkillMinRank)
						{
							return FALSE;
						}
					}
	
					if (nReqSkillMaxRank != 0)
					{
						if (nMyRanks1 >= nReqSkillMaxRank)
						{
							return FALSE;
						}
					}
				}
	
				if (nReqSkill2 != 0)
				{
					int nMyRanks2 = GetSkillRank(nReqSkill2, oPC, TRUE);
					int nReqSkillMinRank2 = CSLGetFeatDataFeatReqSkillMinRanks2(i);
					int nReqSkillMaxRank2 = CSLGetFeatDataFeatReqSkillMaxRanks2(i);
	
					if (nReqSkillMinRank2 != 0)
					{
						if (nMyRanks2 < nReqSkillMinRank2)
						{
							return FALSE;
						}
					}

					if (nReqSkillMaxRank2 != 0)
					{
						if (nMyRanks2 >= nReqSkillMaxRank2)
						{
							return FALSE;
						}
					}
				}
	
				int nMinFortSave = CSLGetFeatDataFeatMinFortSave(i);

				if (nMinFortSave != 0)
				{
					if (GetFortitudeSavingThrow(oPC) < nMinFortSave)
					{
						return FALSE;
					}
				}
	
				int nMinLevelClass = CSLGetFeatDataFeatMinLevelClass(i);
				int nMinLevel = CSLGetFeatDataFeatMinLevel(i);
				int nMaxLevel = CSLGetFeatDataFeatMaxLevel(i);
	
				if ((nMinLevelClass == 0) && (nMinLevel != 0))
				{
					int nHitDie = GetHitDice(oPC);
				
					if (nHitDie < nMinLevel)
					{
						return FALSE;
					}
				}
				else if (nMinLevelClass != 0)
				{
					int nClassLvl = GetLevelByClass(nMinLevelClass, oPC);
			
					if (nMinLevel != 0)
					{
						if (nClassLvl < nMinLevel)
						{
							return FALSE;
						}
					}

					if (nMaxLevel != 0)
					{
						if (nClassLvl > nMaxLevel)
						{
							return FALSE;
						}
					}
				}
	
				int nAlignRestrict = CSLGetFeatDataFeatAlignRestrict(i);

				if (nAlignRestrict != 0)
				{
					if (nAlignRestrict == 2)
					{
						int nLaw = GetAlignmentLawChaos(oPC);
	
						if (nLaw == ALIGNMENT_LAWFUL)
						{
							return FALSE;
						}
					}
					else if (nAlignRestrict == 3)
					{
						int nChaos = GetAlignmentLawChaos(oPC);
	
						if (nChaos == ALIGNMENT_CHAOTIC)
						{
							return FALSE;
						}
					}
					else if (nAlignRestrict == 4)
					{
						int nGood = GetAlignmentGoodEvil(oPC);
	
						if (nGood == ALIGNMENT_GOOD)
						{
							return FALSE;
						}
					}
					else if (nAlignRestrict == 5)
					{
						int nEvil = GetAlignmentGoodEvil(oPC);

						if (nEvil == ALIGNMENT_EVIL)
						{
							return FALSE;
						}
					}
				}

					/* Drammel's Notes on nMinSpellLvl, nMinCasterLvl:
					These checks are currently not supported due to the inability to reliably
					determine either via scripting.  Most of the feats that require these
					also check for other variables and as such are reliable for an accurate
					listing of available feats to retrain.  Hence, I will wait until Obsidian
					implements these checks, if ever.  The only feats that I am aware of that
					allow a 'cheat' on retraining are a handful of skill focus feats.  Considering
					the nature of the feats and the level 1 requirement on caster level, I'm not
					too concerned.*/

				int nMinAB = CSLGetFeatDataFeatMinAttackBonus(i);
				int nAB;

				if (nMinAB != 0)
				{
					// There is no pure way to determine the BAB at previous levels, but the level cap does help moderate a bit.
					if (GetBaseAttackBonus(oPC) > GetLocalInt(oToB, "LevelupCap"))
					{
						nAB = GetLocalInt(oToB, "LevelupCap");
					}
					else nAB = GetBaseAttackBonus(oPC);
	
					if (nAB < nMinAB)
					{
						return FALSE;
					}
				}

				// Special cases, like Use Poison.
				if (i == 0 || i == 1799 || i == 1800 || i == 2129 || i == 2130 || i == 2131 || i == 2132 
				|| i == 2133 || i == 1912 || i == 1913 || i == 1914 || i == 1915 || i == 1916 || i == 960
				|| i == 1113 || i == 1116 || i == 1917 || i == 6831 || i == 6945)
				{
					return FALSE;
				}

				string sScent = GetName(oPC) + "TB_sa_huntersns";
				object oScent = GetObjectByTag(sScent);

				if (GetIsObjectValid(oScent))
				{
					if (i == FEAT_SCENT) //Hunter's Sense actually grants the feat.  This prevents 'gaining a spare to trade'.
					{
						return FALSE;
					}
				}

				int nForbidden1 = GetLocalInt(oToB, "ForbiddenRetrain1");

				if (nForbidden1 > 0) // For the Swordsage's Insightful Strike: Weapon Focus, mostly.
				{
					int nForbidden2 = GetLocalInt(oToB, "ForbiddenRetrain2");
					int nForbidden3 = GetLocalInt(oToB, "ForbiddenRetrain3");
					int nForbidden4 = GetLocalInt(oToB, "ForbiddenRetrain4");
					int nForbidden5 = GetLocalInt(oToB, "ForbiddenRetrain5");
					int nForbidden6 = GetLocalInt(oToB, "ForbiddenRetrain6");

					if (i == nForbidden1)
					{
						return FALSE;
					}

					if ((i == nForbidden2) && (nForbidden2 > 0)) // Because Alertness is something we'd never think of retraining! ;)
					{
						return FALSE;
					}

					if ((i == nForbidden3) && (nForbidden3 > 0))
					{
						return FALSE;
					}
				
					if ((i == nForbidden4) && (nForbidden4 > 0))
					{
						return FALSE;
					}

					if ((i == nForbidden5) && (nForbidden5 > 0))
					{
						return FALSE;
					}

					if ((i == nForbidden6) && (nForbidden6 > 0))
					{
						return FALSE;
					}
				}

			}
			else return FALSE;
		}
		else return FALSE;
	}
	else return FALSE;

	return TRUE;
}

// Displays the feats that the PC qualifies for and does not already know.
// Again, this is a setup for the big TMI prevention function.
int TOBGetAvailableFeats2(int i, int nFinish, object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetAvailableFeats2 Start", GetFirstPC() ); }
	
	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loops if we just want to finish leveling.
	{
		return 0;
	}

	while (i <= nFinish)
	{
		if (TOBCheckFeat(i, oPC, oToB))
		{
			string sIcon = "RETRAIN_IMAGE=" + CSLGetFeatDataIcon(i) + ".tga";
			string sName = "RETRAIN_TEXT=" + CSLGetFeatDataName(i);
			string sVari = "7=" + IntToString(i);

			AddListBoxRow(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(i), sName, sIcon, sVari, "");
		}
		i++;
	}

	return i;
}

// Runs the above function in segments to avoid TMI errors.
void TOBGetAllAvailableFeats2(object oPC, object oToB, int nStart, int nFinish)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetAllAvailableFeats2 Start", GetFirstPC() ); }
	
	if (GetLocalInt(oToB, "HaltRetrainFeats") == 1) // Kill the loops if we just want to finish leveling.
	{
		return;
	}

	// nStart is at 1 because Alertness causes all sorts of problems and needs to be excluded.
	int nLimit = GetNum2DARows("feat");
	int i = TOBGetAvailableFeats2(nStart, nFinish, oPC, oToB);

	if (i < nLimit) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nFinish + 25 > nLimit)
		{
			nFinish = nLimit;
		}
		else
		{
			nFinish = nFinish + 25;
		}

		DelayCommand(0.01f, TOBGetAllAvailableFeats2(oPC, oToB, i, nFinish));
	}
	else 
	{
		DeleteLocalInt(oToB, "RetrainLoopCheck"); //Keeps us from running this function before the first loop has finished.
	}
}






// Used to only open the levelup xmls when all of the screen's data has been loaded.
void TOBEnforceDataOpening(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBEnforceDataOpening Start", GetFirstPC() ); }
	
	if ((GetLocalInt(oToB, "GUIOpeningSafe") == 1) && (GetLocalInt(oToB, "ManeuversCreated") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_LEVELUP_MANEUVERS", TRUE, "levelup_maneuvers.xml");
	}
	else
	{
		DelayCommand(1.5f, TOBEnforceDataOpening(oPC, oToB));
	}
}


//////////////////////////////////
//	Author: Drammel				//
//	Date: 3/29/2009				//
//	Title: bot9s_inc_misc		//
//	Description: Misc functions.//
//////////////////////////////////


// All of the Tome of Battle's persistent feats are linked to an effect which uses an
// ID number in spells.2da.  Sometimes this number will be marked by a placeholder when no
// actual spellscript is needed.  Sometimes the effect itself isn't needed for anything more
// than a placeholder to indicate that a recursive script is running (in this case a blank VFX).
// The idea is that when a recursive function is used, in order to prevent a duplicate from
// running (and causing a stack overflow error or other bugs) this function checks for the effect
// applied by the recursive loop.  If it finds the effect then another recursive isn't executed.
// If the effect isn't there it means that it is okay to start the recursive loop for the feat.
// Care must be taken as some events in the game can supress the detection of an effect, such as
// right after resting.  If the effect is found on the player this function returns TRUE.
int TOBCheckRecursive(int nId, object oPC = OBJECT_SELF )
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCheckRecursive Start", GetFirstPC() ); }
	
	effect eTest = GetFirstEffect(oPC);
	while (GetIsEffectValid(eTest))
	{
		if (nId == GetEffectSpellId(eTest))
		{
			return TRUE;
		}
		eTest = GetNextEffect(oPC);
	}
	return FALSE;
}








// Returns the object stored on the Tome of Battle object when the target was selected for the maneuver.  The
// objects are stored for individual maneuvers so that the action queue doesn't return the wrong object when a
// maneuver is enqueued.
// nManeuver: The 2da index number of the maneuver that this script is run from.
object TOBGetManeuverObject(object oToB, int nManeuver)
{
	return GetLocalObject(oToB, "Target" + IntToString(nManeuver));
}

// Returns the x vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float TOBGetManeuverX(object oToB, int nManeuver)
{
	return GetLocalFloat(oToB, IntToString(nManeuver) + "x");
}

// Returns the y vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float TOBGetManeuverY(object oToB, int nManeuver)
{
	return GetLocalFloat(oToB, IntToString(nManeuver) + "y");
}

// Returns the y vector value of the targeted location of a maneuver.  Only to be used with maneuvers that
// target a location.
float TOBGetManeuverZ(object oToB, int nManeuver)
{
	return GetLocalFloat(oToB, IntToString(nManeuver) + "z");
}


void TOBCloseScreens(object oPC, int bPC)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCloseScreens Start", GetFirstPC() ); }
	
	object oMartialAdept = GetControlledCharacter(oPC);
	object oParty, oToB;
	int nCrusader, nSaint, nSwordsage, nWarblade;

	oParty = GetFirstFactionMember(oPC, FALSE);

	while (GetIsObjectValid(oParty))
	{
		oToB = CSLGetDataStore(oParty);
		nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
		nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
		nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
		nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);


		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU_CR");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE_CR");
		SetLocalInt(oToB, "IsQStrikeActive_CR", 0);

		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU_SA");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE_SA");
		SetLocalInt(oToB, "IsQStrikeActive_SA", 0);

		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU_SS");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE_SS");
		SetLocalInt(oToB, "IsQStrikeActive_SS", 0);

		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU_WB");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE_WB");
		SetLocalInt(oToB, "IsQStrikeActive_WB", 0);

		CloseGUIScreen(oParty, "SCREEN_MARTIAL_MENU");
		CloseGUIScreen(oParty, "SCREEN_QUICK_STRIKE");
		SetLocalInt(oToB, "IsQStrikeActive___", 0);


		CloseGUIScreen(oParty, "SCREEN_SWIFT_ACTION");

		oParty = GetNextFactionMember(oPC);
	}
}


void TOBOpenScreens(object oPC)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBOpenScreens Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	int nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
	int nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);

	if ((nCrusader > 0) && (GetLocalInt(oToB, "Unfettered") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_CR", FALSE, "martial_menu_cr.xml");
	}

	if ((nSaint > 0) && (GetLocalInt(oToB, "SublimeWay") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_SA", FALSE, "martial_menu_sa.xml");
	}

	if ((nSwordsage > 0) && (GetLocalInt(oToB, "DesertWind") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_SS", FALSE, "martial_menu_ss.xml");
	}

	if ((nWarblade > 0) && (GetLocalInt(oToB, "SupernalClarity") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU_WB", FALSE, "martial_menu_wb.xml");
	}

	if ((GetHasFeat(FEAT_MARTIAL_STUDY, oPC)) && (GetLocalInt(oToB, "UmbralAwn") == 0))
	{
		DisplayGuiScreen(oPC, "SCREEN_MARTIAL_MENU", FALSE, "martial_menu.xml");
	}

	if (GetHasFeat(FEAT_MARTIAL_ADEPT, oPC))
	{
		DisplayGuiScreen(oPC, "SCREEN_SWIFT_ACTION", FALSE, "swift_action.xml");
	}
}


//Functions

// Targeting function for strike maneuvers.  This function takes object oTarget from gui_tob_execute_strike and 
// stores it on the Tome of Battle object as "Target" + nStrike, where nStrike is the row index of the strike in
// maneuvers.2da.  This is done to prevent the action queue from assigning the wrong target to a strike.
// -nStrike: The row number of the strike in maneuvers.2da.
// -oTarget: Data of the object targeted GUI-side by UIObject_Input_ActionTargetScript.
void TOBIndexStrikeTarget(object oToB, int nStrike, object oTarget)
{
	SetLocalObject(oToB, "Target" + IntToString(nStrike), oTarget);
}


// Placing a location value on an item tends to crash NWN2 so the location information here is stored in its 
// raw state as three floats.  The information is stored as nManeuver's index row numer on maneuvers.2da in the
// format of #x, #y, #z.
// -nManeuver: A maneuver of any type.
// -fx: The location's x position.
// -fy: The location's y position.
// -fz: The location's z position.
void TOBIndexManeuverPosition(object oPC, int nManeuver, float fx, float fy, float fz)
{
	SetLocalFloat(oPC, IntToString(nManeuver) + "x", fx);
	SetLocalFloat(oPC, IntToString(nManeuver) + "y", fy);
	SetLocalFloat(oPC, IntToString(nManeuver) + "z", fz);
}



//  Marks nRow as the next strike to be activated by the script TB_actstrike.
//  This is similar to the action queue, but works outside of it.  Strikes are
//  only removed from the action queue after they've been passed through the
//  script TB_actstrike or when the player fails to reach attacking range.
void TOBSetStrike(int nRow, object oToB = OBJECT_INVALID)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBSetStrike Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	if ( !GetIsObjectValid(oToB))
	{
		object oToB = CSLGetDataStore(oPC);
	}
	int i;

	i = 0;

	SetLocalInt(oToB, "Strike0", 1);

	while (GetLocalInt(oToB, "Strike" + IntToString(i)) > 0)
	{
		i++;

		if (GetLocalInt(oToB, "Strike" + IntToString(i)) == 0)
		{
			SetLocalInt(oToB, "Strike" + IntToString(i), nRow);
			SetLocalInt(oToB, "HighStrike", i);
			break;
		}
	}
}

// Switches the mask buttons for the Swordsage maneuver recovery method on and off.
void TOBToggleMasks(int bToggle, string sScreen, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBToggleMasks Start", GetFirstPC() ); }
	
	oPC = GetControlledCharacter(oPC);

	SetGUIObjectHidden(oPC, sScreen, "STRIKE_ONE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_TWO_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_THREE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_FOUR_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_FIVE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_SIX_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_SEVEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_EIGHT_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_NINE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_TEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_ELEVEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_TWELVE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_THIRTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_FOURTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_FIFTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_SIXTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_SEVENTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_EIGHTEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_NINETEEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "STRIKE_TWENTY_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_ONE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_TWO_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_THREE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_FOUR_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_FIVE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_SIX_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_SEVEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_EIGHT_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_NINE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "BOOST_TEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_ONE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_TWO_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_THREE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_FOUR_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_FIVE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_SIX_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_SEVEN_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_EIGHT_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_NINE_MASK", bToggle);
	SetGUIObjectHidden(oPC, sScreen, "COUNTER_TEN_MASK", bToggle);
}

void TOBRecoverAllMartialManeuvers(string sScreen)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRecoverAllMartialManeuvers Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = CSLGetDataStore(oPC);
	string sClass = GetStringRight(sScreen, 3);

	if (sClass == "_CR")
	{
		SetLocalInt(oToB, "EncounterR1", 0);
		return;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR1" + sClass) > 0) // The extra checks improve preformance.
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR11" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ELEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR12" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWELVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR13" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THIRTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR14" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOURTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR15" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIFTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR16" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIXTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR17" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVENTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR18" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR19" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINETEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR20" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWENTY", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TEN", FALSE);
	}
}

void TOBRecoverAllQuickStrikeManeuvers(string sScreen, object oPC, string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRecoverAllQuickStrikeManeuvers Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);

	if (sClass == "_CR")
	{
		SetLocalInt(oToB, "EncounterR1", 0);
		return;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR1" + sClass) > 0) // The extra checks improve preformance.
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR11" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ELEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR12" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWELVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR13" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THIRTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR14" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOURTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR15" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIFTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR16" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIXTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR17" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVENTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR18" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR19" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINETEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR20" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWENTY", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TEN", FALSE);
	}
}

// Recovers all maneuvers.  Intended use is for out of combat, the feat Adaptive
// Style and for use in the Warblade's recovery method.
// -sScreen: Xml screen for which we are recovering maneuvers.
// -bCheckLoc: For Warblade recovery only.  Checks the Warblade's current location against vStart.  If the
// Warblade is more than five feet away from vStart maneuver recovery is prevented.
void TOBRecoverAllManeuvers(string sScreen, int bCheckLoc = FALSE, vector vStart=[0.0,0.0,0.0])
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRecoverAllManeuvers Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = CSLGetDataStore(oPC);
	string sClass = GetStringRight(sScreen, 3);

	if (sClass == "_CR")
	{
		SetLocalInt(oToB, "EncounterR1", 0);
		return;
	}

	if (bCheckLoc == TRUE)
	{
		location lStart = Location(GetArea(oPC), vStart, GetFacing(oPC));
		location lPC = GetLocation(oPC);

		if (GetDistanceBetweenLocations(lStart, lPC) > FeetToMeters(5.0f))
		{
			SendMessageToPC(oPC, "<color=red>Warblade maneuver recovery was canceled by movement.</color>");
			return;
		}
	}

	if (GetLocalInt(oToB, "BlueBoxSTR1" + sClass) > 0) // The extra checks improve preformance.
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR11" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ELEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR12" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWELVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR13" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THIRTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR14" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOURTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR15" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIFTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR16" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIXTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR17" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVENTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR18" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR19" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINETEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR20" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWENTY", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TEN", FALSE);
	}
}


// Checks for stances that bypass the uneven terrain rule for charging.
int TOBCheckStanceChargeRules( object oPC = OBJECT_SELF)
{
	return  hkStanceGetHasActive( oPC, STANCE_STEP_OF_THE_WIND );
}



// Tracks movement for the Strike Desert Tempest.  If the player has stopped
// moving, this function sets the strike to an inactive status.
void TOBDoDesertTempestLoc( object oPC = OBJECT_SELF )
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDoDesertTempestLoc Start", GetFirstPC() ); }
	
	location lPC = GetLocation(oPC);

	if (GetLocalLocation(oPC, "DesertTempestLoc") != lPC)
	{
		SetLocalLocation(oPC, "DesertTempestLoc", lPC);
		DelayCommand(0.1f, TOBDoDesertTempestLoc());
	}
	else DeleteLocalInt(oPC, "DesertTempestActive");
}

// Determines the results of oPC's concealment roll against oFoe.
// 0 = Miss, 1 = Hit.
int TOBConcealmentRoll(object oPC, object oFoe)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBConcealmentRoll Start", GetFirstPC() ); }
	
	int bAttackerHasTrueSight = CSLGetHasEffectType(oPC, EFFECT_TYPE_TRUESEEING );
	int bAttackerCanSeeInvisble = CSLGetHasEffectType(oPC, EFFECT_TYPE_SEEINVISIBLE);
	int bAttackerUltraVision = CSLGetHasEffectType(oPC, EFFECT_TYPE_ULTRAVISION);
	effect eConcealment;
	int nHit, nConcealment;

	nHit = 1;
	eConcealment = GetFirstEffect(oFoe);

	while (GetIsEffectValid(eConcealment))
	{
		nConcealment = GetEffectType(eConcealment);
		if ((nConcealment == EFFECT_TYPE_SANCTUARY) && !bAttackerHasTrueSight)
		{
			int nSanctuary = GetEffectInteger(eConcealment, 0);
			int nWill = HkSavingThrow(SAVING_THROW_WILL, oPC, nSanctuary);

			if (nWill == 0)
			{
				nHit = 0;
				break;
			}
		}
		else if (nConcealment == EFFECT_TYPE_ETHEREAL)
		{
			SetLocalInt(oPC, "AttackRollConcealed", 100);
			nHit = 0;
			break;
		}
		else if (nConcealment == EFFECT_TYPE_CONCEALMENT_NEGATED)
		{
			nHit = 1;
			break;
		}
		else if (((nConcealment == EFFECT_TYPE_INVISIBILITY) || (nConcealment == EFFECT_TYPE_GREATERINVISIBILITY)) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble)
		{
			if (GetHasFeat(FEAT_BLIND_FIGHT, oPC))
			{
				int nd100 = d100(1);
				int nD100 = d100(1);

				if ((nd100 < 50) && (nD100 < 50))
				{
					SetLocalInt(oPC, "AttackRollConcealed", 50);
					nHit = 0;
					break;
				}
			}
			else if (d100(1) < 50)
			{
				SetLocalInt(oPC, "AttackRollConcealed", 50);
				nHit = 0;
				break;
			}
		}
		else if ((nConcealment == EFFECT_TYPE_DARKNESS) && !bAttackerHasTrueSight && !bAttackerUltraVision)
		{
			if (GetHasFeat(FEAT_BLIND_FIGHT, oPC))
			{
				int nd100 = d100(1);
				int nD100 = d100(1);

				if ((nd100 < 50) && (nD100 < 50))
				{
					SetLocalInt(oPC, "AttackRollConcealed", 50);
					nHit = 0;
					break;
				}
			}
			else if (d100(1) < 50)
			{
				SetLocalInt(oPC, "AttackRollConcealed", 50);
				nHit = 0;
				break;
			}
		}
		else if ((nConcealment == EFFECT_TYPE_CONCEALMENT) && !bAttackerHasTrueSight)
		{
			int nd100 = d100(1);
			int nConcealed = GetEffectInteger(eConcealment, 0);
	
			if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_50, oFoe)) && (nConcealed < 50))
			{
				if (nd100 < 50)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 50);
					nHit = 0;
					break;
				}
			}
			else if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_40, oFoe)) && (nConcealed < 40))
			{
				if (nd100 < 40)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 40);
					nHit = 0;
					break;
				}
			}
			else if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_30, oFoe)) && (nConcealed < 30))
			{
				if (nd100 < 30)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 30);
					nHit = 0;
					break;
				}
			}
			else if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_20, oFoe)) && (nConcealed < 20))
			{
				if (nd100 < 20)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 20);
					nHit = 0;
					break;
				}
			}
			else if ((GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_10, oFoe)) && (nConcealed < 10))
			{
				if (nd100 < 10)
				{
					SetLocalInt(oPC, "AttackRollConcealed", 10);
					nHit = 0;
					break;
				}
			}
			else if (nd100 < nConcealed)
			{
				SetLocalInt(oPC, "AttackRollConcealed", nConcealed);
				nHit = 0;
				break;
			}
			else break;
		}
		eConcealment = GetNextEffect(oFoe);
	}

	return nHit;
}

// Determines if an attack roll based on the input values is a hit, miss or
// critical hit.  0 = Miss, 1 = Hit, 2 = Critical Hit.
int TOBGetHit(object oWeapon, object oFoe, int nFoeAC, int nd20, int nD20, int nAB, int nCritRange, int nCritConfirmBonus, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetHit Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	int nHit, nConcealed, nMiss;

	nConcealed = 1; //Yes, things got a little confused, bear with me.
	nMiss = 0;

	if (CSLHasMissChance(oPC))
	{
		nMiss = GetLocalInt(oPC, "bot9s_misschance_int");
		DeleteLocalInt(oPC, "bot9s_misschance_int");
	}

	if (CSLIsTargetConcealed(oFoe, oPC))
	{
		nConcealed = TOBConcealmentRoll(oPC, oFoe);
	}

	if (GetLocalInt(oPC, "OverrideHit") == 1)
	{
		nHit = GetLocalInt(oPC, "HitOverrideNum");
	}
	else if (nD20 == 1)
	{
		nHit = 0;
	}
	else if ((nD20 == 20) && (nd20 == 1))
	{
		nHit = 1;
	}
	else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) < nFoeAC))
	{
		nHit = 1;
	}
	else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)))
	{
		nHit = 1;
	}
	else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC))
	{
		nHit = 2;
	}
	else if ((nD20 >= nCritRange) && (nd20 == 1) && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 1;
	}
	else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)) && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 1;
	}
	else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 2;
	}
	else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) < nFoeAC) && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 1;
	}
	else if ((nD20 < nCritRange) && ((nD20 + nAB) >= nFoeAC)  && (nConcealed == 1) && (nMiss == 0))
	{
		nHit = 1;
	}
	else nHit = 0;

	// Lightning Recovery
	if ((GetLocalInt(oPC, "LightningRecovery") == 1) && (nHit == 0) && (GetLocalInt(oPC, "OverrideHit") == 0))
	{
		int nL20 = d20();
		int nl20 = d20();

		nD20 = nL20;
		nd20 = nl20;
		nAB += 2;

		SetLocalInt(oPC, "LightningRecovery", 2);
		SetLocalInt(oToB, "AttackRollResult", nD20 + nAB);

		if (nD20 == 1)
		{
			nHit = 0;
		}
		else if ((nD20 == 20) && (nd20 == 1))
		{
			nHit = 1;
		}
		else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) < nFoeAC))
		{
			nHit = 1;
		}
		else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			nHit = 1;
		}
		else if ((nD20 == 20) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC))
		{
			nHit = 2;
		}
		else if ((nD20 >= nCritRange) && (nd20 == 1) && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 1;
		}
		else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)) && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 1;
		}
		else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) >= nFoeAC) && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 2;
		}
		else if ((nD20 >= nCritRange) && ((nD20 + nAB) >= nFoeAC) && ((nd20 + nAB + nCritConfirmBonus) < nFoeAC)  && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 1;
		}
		else if ((nD20 < nCritRange) && ((nD20 + nAB) >= nFoeAC)  && (nConcealed == 1) && (nMiss == 0))
		{
			nHit = 1;
		}
		else nHit = 0;
	}

	return nHit;
}

//Functions

// Sets the local Swift variable on the player's martial journal for six seconds and
// Displays the hourglass in Swift Action timer.
// nManeuver: Tells this function which .tga to display.
// sType: Used to specify special actions for certain feats.  Types currently
// used in this system are "B", "C", "STA", and "F".  Boosts, Counters
// Stances, and Swift Feats.
void TOBRunSwiftAction(int nManeuver, string sType, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRunSwiftAction Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	int nDualBoost = GetLocalInt(oToB, "DualBoostActive");
	string sTga = TOBGetManeuversDataIcon(nManeuver);
	string sIcon = sTga + ".tga";

	if ((nDualBoost == 1) && (sType == "B"))
	{
		SetLocalInt(oToB, "DualBoostActive", 0);

		int nDualUses = GetLocalInt(oToB, "DualBoost");
		int nDecrement = nDualUses - 1;

		SetLocalInt(oToB, "DualBoost", nDecrement);
	}
	else if ((GetLocalInt(oToB, "StanceOfAlacrity") == 1) && (sType == "C") && (GetLocalInt(oToB, "AlacrityCounter") != nManeuver))
	{
		//SetLocalInt(oToB, "Counter", 0);
		hkSetCounter(0,oPC);
		SetLocalInt(oToB, "StanceOfAlacrity", 0);
		SetLocalInt(oToB, "AlacrityCounter", nManeuver);
	}
	else
	{

		if (sType == "C")
		{
			hkSetCounter(0,oPC);
		}

		if (nManeuver == 69) //Quicksilver Motion
		{
			HkSwiftActionStart( oPC, nManeuver );
			SetLocalInt(oPC, "Swift", 0);
			
			//SetLocalInt(oToB, "Swift", 0);
			//SetLocalInt(oPC, "Swift", 0);
			SetLocalInt(oToB, "Quicksilver", 1);
			SetLocalInt(oPC, "Quicksilver", 1);
			DelayCommand(6.0f, SetLocalInt(oToB, "Quicksilver", 0));
			DelayCommand(6.0f, SetLocalInt(oPC, "Quicksilver", 0));
			//SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", sIcon);
			//DelayCommand(1.0f, SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", "b_empty.tga"));
		}
		else
		{
			HkSwiftActionStart( oPC, nManeuver );
			
			//SetLocalInt(oToB, "Swift", 1);
			//SetLocalInt(oPC, "Swift", 1);
			//DelayCommand(6.0f, SetLocalInt(oToB, "Swift", 0));
			//DelayCommand(6.0f, SetLocalInt(oPC, "Swift", 0));
			///SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", sIcon);
			//DelayCommand(6.0f, SetGUITexture(oPC, "SCREEN_SWIFT_ACTION", "SWIFT_ACTION", "b_empty.tga"));
		}
	}
}


// Determines the result of an attack roll for strikes.
// 0 = Miss, 1 = Hit, 2 = Critical Hit.
// -oWeapon: The weapon to make an attack roll with.
// -oFoe: The the target being attacked with oWeapon.
// -nMisc: Any additional bonus to the attack roll that hasn't been added.
// -bCombatLog: When set to true displays the attack roll data.
// -nConfirmBonus: Bonus to the critical confirmation roll.
// -oPC: Person executing the attack.
int TOBStrikeAttackRoll(object oWeapon, object oFoe, int nMisc = 0, int bCombatLog = TRUE, int nConfirmBonus = 0, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBStrikeAttackRoll Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	int nFoeAC, nd20, nD20, nAB, nCritRange, nCritConfirmBonus, nHit;

	if (GetLocalInt(oFoe, "OverrideTouchAC") == 1)
	{
		nFoeAC = CSLGetTouchAC(oFoe);
	}
	else if (GetLocalInt(oFoe, "OverrideFlatFootedAC") == 1)
	{
		nFoeAC = CSLGetFlatFootedAC(oFoe);
	}
	else if (GetLocalInt(oFoe, "OverrideAC") > 0)
	{
		nFoeAC = GetLocalInt(oFoe, "OverrideAC");
	}
	else nFoeAC = GetAC(oFoe);

	if (GetLocalInt(oPC, "AuraOfPerfectOrder") == 1)
	{
		nD20 = 11;
		SetLocalInt(oPC, "AuraOfPerfectOrder", 0); // Used only once per round.
	}
	else if (GetLocalInt(oPC, "OverrideD20") == 1)
	{
		nD20 = GetLocalInt(oPC, "D20OverrideNum");
	}
	else nD20 = d20(1);

	if (GetLocalInt(oPC, "OverrideCritConfirm") == 1)
	{
		nd20 = GetLocalInt(oPC, "CCOverrideNum");
	}
	else nd20 = d20(1) + nConfirmBonus;

	if (GetLocalInt(oFoe, "OverrideCritConfirm") == 2)
	{
		nd20 += GetLocalInt(oFoe, "CCOverrideNum");
	}

	if (GetLocalInt(oPC, "OverrideAttackBonus") == 1)
	{
		nAB = GetLocalInt(oPC, "ABOverrideNum");
	}
	else nAB = CSLGetMaxAB(oPC, oWeapon, oFoe) + nMisc;

	if (GetLocalInt(oPC, "OverrideCritRange") == 1)
	{
		nCritRange = GetLocalInt(oPC, "CROverrideNum");
	}
	else nCritRange = CSLGetCriticalRange(oWeapon);

	if (GetLocalInt(oPC, "OverrideCritConfirmBonus") == 1)
	{
		nCritConfirmBonus = GetLocalInt(oPC, "CCBOverrideNum");
	}
	else nCritConfirmBonus = CSLGetCriticalConfirmMod(oWeapon);

	SetLocalInt(oToB, "AttackRollResult", nD20 + nAB);
	SetLocalInt(oPC, "AttackRollConcealed", 0);

	nHit = TOBGetHit(oWeapon, oFoe, nFoeAC, nd20, nD20, nAB, nCritRange, nCritConfirmBonus, oPC);

	if (GetLocalInt(oPC, "LightningRecovery") == 2)
	{
		SetLocalInt(oPC, "LightningRecovery", 0);
		FloatingTextStringOnCreature("<color=cyan>*Lightning Recovery!*</color>", oPC, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);
		TOBRunSwiftAction(86, "C");
	}

	if (bCombatLog == TRUE)
	{
		//Combat log data.
		object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
		object oOffHand;

		if ((oLeft == OBJECT_INVALID) && (!GetIsPlayableRacialType(oPC)))
		{
			oOffHand = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
		}
		else oOffHand = oLeft;

		if ((nHit == 0) && (GetLocalInt(oToB, "AttackRollConcealed") > 0))
		{
			SendMessageToPC(oPC, "<color=chocolate>You missed the target due to concealment!</color>");
		}
		else if ((nHit == 0) && (oWeapon != OBJECT_INVALID) && (oWeapon == oOffHand))
		{
			SendMessageToPC(oPC, "<color=chocolate>Off Hand : </color>" + "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *miss* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + ").</color>");
		}
		else if ((nHit == 1) && (oWeapon != OBJECT_INVALID) && (oWeapon == oOffHand))
		{
			SendMessageToPC(oPC, "<color=chocolate>Off Hand : </color>" + "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *hit* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + ").</color>");
		}
		else if ((nHit == 2) && (oWeapon != OBJECT_INVALID) && (oWeapon == oOffHand))
		{
			FloatingTextStringOnCreature("<color=red>*Critical Hit!*</color>", oPC, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			SendMessageToPC(oPC, "<color=chocolate>Off Hand : </color>" + "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *critical hit* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + " : Threat Roll: " + IntToString(nAB + nCritConfirmBonus) + " + " + IntToString(nd20) + " = " + IntToString(nAB + nCritConfirmBonus + nd20) + ").</color>");
		}
		else if (nHit == 0)
		{
			SendMessageToPC(oPC, "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *miss* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + ").</color>");
		}
		else if (nHit == 1)
		{
			SendMessageToPC(oPC, "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *hit* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + ").</color>");
		}
		else if (nHit == 2)
		{
			FloatingTextStringOnCreature("<color=red>*Critical Hit!*</color>", oPC, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			SendMessageToPC(oPC, "<color=paleturquoise>" + GetName(oPC) + "</color>" + "<color=chocolate> attacks " + GetName(oFoe) + " : *critical hit* : (" + IntToString(nAB) + " + " + IntToString(nD20) + " = " + IntToString(nAB + nD20) + " : Threat Roll: " + IntToString(nAB + nCritConfirmBonus) + " + " + IntToString(nd20) + " = " + IntToString(nAB + nCritConfirmBonus + nd20) + ").</color>");
		}
	}

	return nHit;
}








// Converts IP_CONST_DAMAGEBONUS_* constants into real numbers.
int TOBGetDamageByIPConstDamageBonus(int nDamageBonus, object oPC = OBJECT_SELF )
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetDamageByIPConstDamageBonus Start", GetFirstPC() ); }
	
	int nDamage;
	if ( hkStanceGetHasActive( oPC, STANCE_AURA_OF_CHAOS ) )
	{// Sadly routing for this cannot be done in a loop, since this function is commonly run from within a while loop already.
		if (nDamageBonus == IP_CONST_DAMAGEBONUS_1d10 || nDamageBonus == IP_CONST_DAMAGEBONUS_1d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_1d4
		|| nDamageBonus == IP_CONST_DAMAGEBONUS_1d8 || nDamageBonus == IP_CONST_DAMAGEBONUS_1d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_2d10 
		|| nDamageBonus == IP_CONST_DAMAGEBONUS_2d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_2d4 || nDamageBonus == IP_CONST_DAMAGEBONUS_2d8 
		|| nDamageBonus == IP_CONST_DAMAGEBONUS_2d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_3d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_3d10
		|| nDamageBonus == IP_CONST_DAMAGEBONUS_3d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_4d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_4d8
		|| nDamageBonus == IP_CONST_DAMAGEBONUS_4d10 || nDamageBonus == IP_CONST_DAMAGEBONUS_4d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_5d6
		|| nDamageBonus == IP_CONST_DAMAGEBONUS_5d12 || nDamageBonus == IP_CONST_DAMAGEBONUS_6d6 || nDamageBonus == IP_CONST_DAMAGEBONUS_6d12)
		{
			int nDie, nNum;

			switch (nDamageBonus)
			{
				case IP_CONST_DAMAGEBONUS_1d4:		nDie = 4;	nNum = 1;	break;
				case IP_CONST_DAMAGEBONUS_1d6:		nDie = 6;	nNum = 1;	break;
				case IP_CONST_DAMAGEBONUS_1d8:		nDie = 8;	nNum = 1;	break;
				case IP_CONST_DAMAGEBONUS_1d10:		nDie = 10;	nNum = 1;	break;
				case IP_CONST_DAMAGEBONUS_1d12:		nDie = 12;	nNum = 1;	break;
				case IP_CONST_DAMAGEBONUS_2d4:		nDie = 4;	nNum = 2;	break;
				case IP_CONST_DAMAGEBONUS_2d6:		nDie = 6;	nNum = 2;	break;
				case IP_CONST_DAMAGEBONUS_2d8:		nDie = 8;	nNum = 2;	break;
				case IP_CONST_DAMAGEBONUS_2d10:		nDie = 10;	nNum = 2;	break;
				case IP_CONST_DAMAGEBONUS_2d12:		nDie = 12;	nNum = 2;	break;
				case IP_CONST_DAMAGEBONUS_3d10:		nDie = 10;	nNum = 3;	break;
				case IP_CONST_DAMAGEBONUS_3d12:		nDie = 12;	nNum = 3;	break;
				case IP_CONST_DAMAGEBONUS_3d6:		nDie = 6;	nNum = 3;	break;
				case IP_CONST_DAMAGEBONUS_4d10:		nDie = 10;	nNum = 4;	break;
				case IP_CONST_DAMAGEBONUS_4d12:		nDie = 12;	nNum = 4;	break;
				case IP_CONST_DAMAGEBONUS_4d6:		nDie = 6;	nNum = 4;	break;
				case IP_CONST_DAMAGEBONUS_4d8:		nDie = 8;	nNum = 4;	break;
				case IP_CONST_DAMAGEBONUS_5d12:		nDie = 12;	nNum = 5;	break;
				case IP_CONST_DAMAGEBONUS_5d6:		nDie = 6;	nNum = 5;	break;
				case IP_CONST_DAMAGEBONUS_6d12:		nDie = 12;	nNum = 6;	break;
				case IP_CONST_DAMAGEBONUS_6d6:		nDie = 6;	nNum = 6;	break;
			}

			int nDie1Roll1 = Random(nDie); // Hard cap of 10 extra damage rolls per die.

			if (nDie1Roll1 == 0) //The function "Random" can return a zero which cannot be a damage number.
			{
				nDamage += 1;
			}
			else if (nDie1Roll1 < nDie)
			{
				nDamage += nDie1Roll1;
			}
			else // Max damage die is showing, Aura of Chaos kicks in.
			{
				nDamage += nDie1Roll1;

				int nDie1Roll2 = Random(nDie);

				if (nDie1Roll2 == 0)
				{
					nDamage += 1;
				}
				else if (nDie1Roll2 < nDie)
				{
					nDamage += nDie1Roll2;
				}
				else
				{
					nDamage += nDie1Roll2;

					int nDie1Roll3 = Random(nDie);

					if (nDie1Roll3 == 0)
					{
						nDamage += 1;
					}
					else if (nDie1Roll3 < nDie)
					{
						nDamage += nDie1Roll3;
					}
					else
					{
						nDamage += nDie1Roll3;

						int nDie1Roll4 = Random(nDie);

						if (nDie1Roll4 == 0)
						{
							nDamage += 1;
						}
						else if (nDie1Roll4 < nDie)
						{
							nDamage += nDie1Roll4;
						}
						else
						{
							nDamage += nDie1Roll4;

							int nDie1Roll5 = Random(nDie);

							if (nDie1Roll5 == 0)
							{
								nDamage += 1;
							}
							else if (nDie1Roll5 < nDie)
							{
								nDamage += nDie1Roll5;
							}
							else
							{
								nDamage += nDie1Roll5;

								int nDie1Roll6 = Random(nDie);

								if (nDie1Roll6 == 0)
								{
									nDamage += 1;
								}
								else if (nDie1Roll6 < nDie)
								{
									nDamage += nDie1Roll6;
								}
								else
								{
									nDamage += nDie1Roll6;

									int nDie1Roll7 = Random(nDie);

									if (nDie1Roll7 == 0)
									{
										nDamage += 1;
									}
									else if (nDie1Roll7 < nDie)
									{
										nDamage += nDie1Roll7;
									}
									else
									{
										nDamage += nDie1Roll7;

										int nDie1Roll8 = Random(nDie);

										if (nDie1Roll8 == 0)
										{
											nDamage += 1;
										}
										else if (nDie1Roll8 < nDie)
										{
											nDamage += nDie1Roll8;
										}
										else
										{
											nDamage += nDie1Roll8;

											int nDie1Roll9 = Random(nDie);

											if (nDie1Roll9 == 0)
											{
												nDamage += 1;
											}
											else if (nDie1Roll9 < nDie)
											{
												nDamage += nDie1Roll9;
											}
											else
											{
												int nDie1Roll10 = Random(nDie);
												nDamage += (nDie1Roll9 + nDie1Roll10);
											}
										}
									}
								}
							}
						}
					}
				}
			}

			if (nNum >= 2)
			{
				int nDie2Roll1 = Random(nDie);

				if (nDie2Roll1 == 0)
				{
					nDamage += 1;
				}
				else if (nDie2Roll1 < nDie)
				{
					nDamage += nDie2Roll1;
				}
				else
				{
					nDamage += nDie2Roll1;

					int nDie2Roll2 = Random(nDie);

					if (nDie2Roll2 == 0)
					{
						nDamage += 1;
					}
					else if (nDie2Roll2 < nDie)
					{
						nDamage += nDie2Roll2;
					}
					else
					{
						nDamage += nDie2Roll2;

						int nDie2Roll3 = Random(nDie);

						if (nDie2Roll3 == 0)
						{
							nDamage += 1;
						}
						else if (nDie2Roll3 < nDie)
						{
							nDamage += nDie2Roll3;
						}
						else
						{
							nDamage += nDie2Roll3;

							int nDie2Roll4 = Random(nDie);

							if (nDie2Roll4 == 0)
							{
								nDamage += 1;
							}
							else if (nDie2Roll4 < nDie)
							{
								nDamage += nDie2Roll4;
							}
							else
							{
								nDamage += nDie2Roll4;

								int nDie2Roll5 = Random(nDie);

								if (nDie2Roll5 == 0)
								{
									nDamage += 1;
								}
								else if (nDie2Roll5 < nDie)
								{
									nDamage += nDie2Roll5;
								}
								else
								{
									nDamage += nDie2Roll5;

									int nDie2Roll6 = Random(nDie);

									if (nDie2Roll6 == 0)
									{
										nDamage += 1;
									}
									else if (nDie2Roll6 < nDie)
									{
										nDamage += nDie2Roll6;
									}
									else
									{
										nDamage += nDie2Roll6;

										int nDie2Roll7 = Random(nDie);

										if (nDie2Roll7 == 0)
										{
											nDamage += 1;
										}
										else if (nDie2Roll7 < nDie)
										{
											nDamage += nDie2Roll7;
										}
										else
										{
											nDamage += nDie2Roll7;

											int nDie2Roll8 = Random(nDie);

											if (nDie2Roll8 == 0)
											{
												nDamage += 1;
											}
											else if (nDie2Roll8 < nDie)
											{
												nDamage += nDie2Roll8;
											}
											else
											{
												nDamage += nDie2Roll8;

												int nDie2Roll9 = Random(nDie);

												if (nDie2Roll9 == 0)
												{
													nDamage += 1;
												}
												else if (nDie2Roll9 < nDie)
												{
													nDamage += nDie2Roll9;
												}
												else
												{
													int nDie2Roll10 = Random(nDie);
													nDamage += (nDie2Roll9 + nDie2Roll10);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}


			if (nNum >= 3)
			{
				int nDie3Roll1 = Random(nDie);

				if (nDie3Roll1 == 0)
				{
					nDamage += 1;
				}
				else if (nDie3Roll1 < nDie)
				{
					nDamage += nDie3Roll1;
				}
				else
				{
					nDamage += nDie3Roll1;

					int nDie3Roll2 = Random(nDie);

					if (nDie3Roll2 == 0)
					{
						nDamage += 1;
					}
					else if (nDie3Roll2 < nDie)
					{
						nDamage += nDie3Roll2;
					}
					else
					{
						nDamage += nDie3Roll2;

						int nDie3Roll3 = Random(nDie);

						if (nDie3Roll3 == 0)
						{
							nDamage += 1;
						}
						else if (nDie3Roll3 < nDie)
						{
							nDamage += nDie3Roll3;
						}
						else
						{
							nDamage += nDie3Roll3;

							int nDie3Roll4 = Random(nDie);

							if (nDie3Roll4 == 0)
							{
								nDamage += 1;
							}
							else if (nDie3Roll4 < nDie)
							{
								nDamage += nDie3Roll4;
							}
							else
							{
								nDamage += nDie3Roll4;

								int nDie3Roll5 = Random(nDie);

								if (nDie3Roll5 == 0)
								{
									nDamage += 1;
								}
								else if (nDie3Roll5 < nDie)
								{
									nDamage += nDie3Roll5;
								}
								else
								{
									nDamage += nDie3Roll5;

									int nDie3Roll6 = Random(nDie);

									if (nDie3Roll6 == 0)
									{
										nDamage += 1;
									}
									else if (nDie3Roll6 < nDie)
									{
										nDamage += nDie3Roll6;
									}
									else
									{
										nDamage += nDie3Roll6;

										int nDie3Roll7 = Random(nDie);

										if (nDie3Roll7 == 0)
										{
											nDamage += 1;
										}
										else if (nDie3Roll7 < nDie)
										{
											nDamage += nDie3Roll7;
										}
										else
										{
											nDamage += nDie3Roll7;

											int nDie3Roll8 = Random(nDie);

											if (nDie3Roll8 == 0)
											{
												nDamage += 1;
											}
											else if (nDie3Roll8 < nDie)
											{
												nDamage += nDie3Roll8;
											}
											else
											{
												nDamage += nDie3Roll8;

												int nDie3Roll9 = Random(nDie);

												if (nDie3Roll9 == 0)
												{
													nDamage += 1;
												}
												else if (nDie3Roll9 < nDie)
												{
													nDamage += nDie3Roll9;
												}
												else
												{
													int nDie3Roll10 = Random(nDie);
													nDamage += (nDie3Roll9 + nDie3Roll10);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			if (nNum >= 4)
			{
				int nDie4Roll1 = Random(nDie);

				if (nDie4Roll1 == 0)
				{
					nDamage += 1;
				}
				else if (nDie4Roll1 < nDie)
				{
					nDamage += nDie4Roll1;
				}
				else
				{
					nDamage += nDie4Roll1;

					int nDie4Roll2 = Random(nDie);

					if (nDie4Roll2 == 0)
					{
						nDamage += 1;
					}
					else if (nDie4Roll2 < nDie)
					{
						nDamage += nDie4Roll2;
					}
					else
					{
						nDamage += nDie4Roll2;

						int nDie4Roll3 = Random(nDie);

						if (nDie4Roll3 == 0)
						{
							nDamage += 1;
						}
						else if (nDie4Roll3 < nDie)
						{
							nDamage += nDie4Roll3;
						}
						else
						{
							nDamage += nDie4Roll3;

							int nDie4Roll4 = Random(nDie);

							if (nDie4Roll4 == 0)
							{
								nDamage += 1;
							}
							else if (nDie4Roll4 < nDie)
							{
								nDamage += nDie4Roll4;
							}
							else
							{
								nDamage += nDie4Roll4;

								int nDie4Roll5 = Random(nDie);

								if (nDie4Roll5 == 0)
								{
									nDamage += 1;
								}
								else if (nDie4Roll5 < nDie)
								{
									nDamage += nDie4Roll5;
								}
								else
								{
									nDamage += nDie4Roll5;

									int nDie4Roll6 = Random(nDie);

									if (nDie4Roll6 == 0)
									{
										nDamage += 1;
									}
									else if (nDie4Roll6 < nDie)
									{
										nDamage += nDie4Roll6;
									}
									else
									{
										nDamage += nDie4Roll6;

										int nDie4Roll7 = Random(nDie);

										if (nDie4Roll7 == 0)
										{
											nDamage += 1;
										}
										else if (nDie4Roll7 < nDie)
										{
											nDamage += nDie4Roll7;
										}
										else
										{
											nDamage += nDie4Roll7;

											int nDie4Roll8 = Random(nDie);

											if (nDie4Roll8 == 0)
											{
												nDamage += 1;
											}
											else if (nDie4Roll8 < nDie)
											{
												nDamage += nDie4Roll8;
											}
											else
											{
												nDamage += nDie4Roll8;

												int nDie4Roll9 = Random(nDie);

												if (nDie4Roll9 == 0)
												{
													nDamage += 1;
												}
												else if (nDie4Roll9 < nDie)
												{
													nDamage += nDie4Roll9;
												}
												else
												{
													int nDie4Roll10 = Random(nDie);
													nDamage += (nDie4Roll9 + nDie4Roll10);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			if (nNum >= 5)
			{
				int nDie5Roll1 = Random(nDie);

				if (nDie5Roll1 == 0)
				{
					nDamage += 1;
				}
				else if (nDie5Roll1 < nDie)
				{
					nDamage += nDie5Roll1;
				}
				else
				{
					nDamage += nDie5Roll1;

					int nDie5Roll2 = Random(nDie);

					if (nDie5Roll2 == 0)
					{
						nDamage += 1;
					}
					else if (nDie5Roll2 < nDie)
					{
						nDamage += nDie5Roll2;
					}
					else
					{
						nDamage += nDie5Roll2;

						int nDie5Roll3 = Random(nDie);

						if (nDie5Roll3 == 0)
						{
							nDamage += 1;
						}
						else if (nDie5Roll3 < nDie)
						{
							nDamage += nDie5Roll3;
						}
						else
						{
							nDamage += nDie5Roll3;

							int nDie5Roll4 = Random(nDie);

							if (nDie5Roll4 == 0)
							{
								nDamage += 1;
							}
							else if (nDie5Roll4 < nDie)
							{
								nDamage += nDie5Roll4;
							}
							else
							{
								nDamage += nDie5Roll4;

								int nDie5Roll5 = Random(nDie);

								if (nDie5Roll5 == 0)
								{
									nDamage += 1;
								}
								else if (nDie5Roll5 < nDie)
								{
									nDamage += nDie5Roll5;
								}
								else
								{
									nDamage += nDie5Roll5;

									int nDie5Roll6 = Random(nDie);

									if (nDie5Roll6 == 0)
									{
										nDamage += 1;
									}
									else if (nDie5Roll6 < nDie)
									{
										nDamage += nDie5Roll6;
									}
									else
									{
										nDamage += nDie5Roll6;

										int nDie5Roll7 = Random(nDie);

										if (nDie5Roll7 == 0)
										{
											nDamage += 1;
										}
										else if (nDie5Roll7 < nDie)
										{
											nDamage += nDie5Roll7;
										}
										else
										{
											nDamage += nDie5Roll7;

											int nDie5Roll8 = Random(nDie);

											if (nDie5Roll8 == 0)
											{
												nDamage += 1;
											}
											else if (nDie5Roll8 < nDie)
											{
												nDamage += nDie5Roll8;
											}
											else
											{
												nDamage += nDie5Roll8;

												int nDie5Roll9 = Random(nDie);

												if (nDie5Roll9 == 0)
												{
													nDamage += 1;
												}
												else if (nDie5Roll9 < nDie)
												{
													nDamage += nDie5Roll9;
												}
												else
												{
													int nDie5Roll10 = Random(nDie);
													nDamage += (nDie5Roll9 + nDie5Roll10);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			if (nNum >= 6)
			{
				int nDie6Roll1 = Random(nDie);

				if (nDie6Roll1 == 0)
				{
					nDamage += 1;
				}
				else if (nDie6Roll1 < nDie)
				{
					nDamage += nDie6Roll1;
				}
				else
				{
					nDamage += nDie6Roll1;

					int nDie6Roll2 = Random(nDie);

					if (nDie6Roll2 == 0)
					{
						nDamage += 1;
					}
					else if (nDie6Roll2 < nDie)
					{
						nDamage += nDie6Roll2;
					}
					else
					{
						nDamage += nDie6Roll2;

						int nDie6Roll3 = Random(nDie);

						if (nDie6Roll3 == 0)
						{
							nDamage += 1;
						}
						else if (nDie6Roll3 < nDie)
						{
							nDamage += nDie6Roll3;
						}
						else
						{
							nDamage += nDie6Roll3;

							int nDie6Roll4 = Random(nDie);

							if (nDie6Roll4 == 0)
							{
								nDamage += 1;
							}
							else if (nDie6Roll4 < nDie)
							{
								nDamage += nDie6Roll4;
							}
							else
							{
								nDamage += nDie6Roll4;

								int nDie6Roll5 = Random(nDie);

								if (nDie6Roll5 == 0)
								{
									nDamage += 1;
								}
								else if (nDie6Roll5 < nDie)
								{
									nDamage += nDie6Roll5;
								}
								else
								{
									nDamage += nDie6Roll5;

									int nDie6Roll6 = Random(nDie);

									if (nDie6Roll6 == 0)
									{
										nDamage += 1;
									}
									else if (nDie6Roll6 < nDie)
									{
										nDamage += nDie6Roll6;
									}
									else
									{
										nDamage += nDie6Roll6;

										int nDie6Roll7 = Random(nDie);

										if (nDie6Roll7 == 0)
										{
											nDamage += 1;
										}
										else if (nDie6Roll7 < nDie)
										{
											nDamage += nDie6Roll7;
										}
										else
										{
											nDamage += nDie6Roll7;

											int nDie6Roll8 = Random(nDie);

											if (nDie6Roll8 == 0)
											{
												nDamage += 1;
											}
											else if (nDie6Roll8 < nDie)
											{
												nDamage += nDie6Roll8;
											}
											else
											{
												nDamage += nDie6Roll8;

												int nDie6Roll9 = Random(nDie);

												if (nDie6Roll9 == 0)
												{
													nDamage += 1;
												}
												else if (nDie6Roll9 < nDie)
												{
													nDamage += nDie6Roll9;
												}
												else
												{
													int nDie6Roll10 = Random(nDie);
													nDamage += (nDie6Roll9 + nDie6Roll10);
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		else
		{
			switch (nDamageBonus)
			{
				case IP_CONST_DAMAGEBONUS_1:	nDamage = 1;		break;
				case IP_CONST_DAMAGEBONUS_10: 	nDamage = 10;		break;
				case IP_CONST_DAMAGEBONUS_11: 	nDamage = 11;		break;
				case IP_CONST_DAMAGEBONUS_12: 	nDamage = 12;		break;
				case IP_CONST_DAMAGEBONUS_13: 	nDamage = 13;		break;
				case IP_CONST_DAMAGEBONUS_14: 	nDamage = 14;		break;
				case IP_CONST_DAMAGEBONUS_15: 	nDamage = 15;		break;
				case IP_CONST_DAMAGEBONUS_16: 	nDamage = 16;		break;
				case IP_CONST_DAMAGEBONUS_17: 	nDamage = 17;		break;
				case IP_CONST_DAMAGEBONUS_18: 	nDamage = 18;		break;
				case IP_CONST_DAMAGEBONUS_19: 	nDamage = 19;		break;
				case IP_CONST_DAMAGEBONUS_2: 	nDamage = 2;		break;
				case IP_CONST_DAMAGEBONUS_20: 	nDamage = 20;		break;
				case IP_CONST_DAMAGEBONUS_21: 	nDamage = 21;		break;
				case IP_CONST_DAMAGEBONUS_22: 	nDamage = 22;		break;
				case IP_CONST_DAMAGEBONUS_23: 	nDamage = 23;		break;
				case IP_CONST_DAMAGEBONUS_24: 	nDamage = 24;		break;
				case IP_CONST_DAMAGEBONUS_25: 	nDamage = 25;		break;
				case IP_CONST_DAMAGEBONUS_26: 	nDamage = 26;		break;
				case IP_CONST_DAMAGEBONUS_27: 	nDamage = 27;		break;
				case IP_CONST_DAMAGEBONUS_28: 	nDamage = 28;		break;
				case IP_CONST_DAMAGEBONUS_29: 	nDamage = 29;		break;
				case IP_CONST_DAMAGEBONUS_3: 	nDamage = 3;		break;
				case IP_CONST_DAMAGEBONUS_30: 	nDamage = 30;		break;
				case IP_CONST_DAMAGEBONUS_31: 	nDamage = 31;		break;
				case IP_CONST_DAMAGEBONUS_32:	nDamage = 32;		break;
				case IP_CONST_DAMAGEBONUS_33:	nDamage = 33;		break;
				case IP_CONST_DAMAGEBONUS_34:	nDamage = 34;		break;
				case IP_CONST_DAMAGEBONUS_35: 	nDamage = 35;		break;
				case IP_CONST_DAMAGEBONUS_36: 	nDamage = 36;		break;
				case IP_CONST_DAMAGEBONUS_37: 	nDamage = 37;		break;
				case IP_CONST_DAMAGEBONUS_38: 	nDamage = 38;		break;
				case IP_CONST_DAMAGEBONUS_39: 	nDamage = 39;		break;
				case IP_CONST_DAMAGEBONUS_4: 	nDamage = 4;		break;
				case IP_CONST_DAMAGEBONUS_40: 	nDamage = 40;		break;
				case IP_CONST_DAMAGEBONUS_5: 	nDamage = 5;		break;
				case IP_CONST_DAMAGEBONUS_6: 	nDamage = 6;		break;
				case IP_CONST_DAMAGEBONUS_7: 	nDamage = 7;		break;
				case IP_CONST_DAMAGEBONUS_8:	nDamage = 8;		break;
				case IP_CONST_DAMAGEBONUS_9: 	nDamage = 9;		break;
				default: 						nDamage = 1;		break;
			}
		}
	}
	else
	{
		switch (nDamageBonus)
		{
			case IP_CONST_DAMAGEBONUS_1:	nDamage = 1;		break;
			case IP_CONST_DAMAGEBONUS_10: 	nDamage = 10;		break;
			case IP_CONST_DAMAGEBONUS_11: 	nDamage = 11;		break;
			case IP_CONST_DAMAGEBONUS_12: 	nDamage = 12;		break;
			case IP_CONST_DAMAGEBONUS_13: 	nDamage = 13;		break;
			case IP_CONST_DAMAGEBONUS_14: 	nDamage = 14;		break;
			case IP_CONST_DAMAGEBONUS_15: 	nDamage = 15;		break;
			case IP_CONST_DAMAGEBONUS_16: 	nDamage = 16;		break;
			case IP_CONST_DAMAGEBONUS_17: 	nDamage = 17;		break;
			case IP_CONST_DAMAGEBONUS_18: 	nDamage = 18;		break;
			case IP_CONST_DAMAGEBONUS_19: 	nDamage = 19;		break;
			case IP_CONST_DAMAGEBONUS_1d10:	nDamage = d10(1);	break;
			case IP_CONST_DAMAGEBONUS_1d12: nDamage = d12(1);	break;
			case IP_CONST_DAMAGEBONUS_1d4: 	nDamage = d4(1);	break;
			case IP_CONST_DAMAGEBONUS_1d6: 	nDamage = d6(1);	break;
			case IP_CONST_DAMAGEBONUS_1d8: 	nDamage = d8(1);	break;
			case IP_CONST_DAMAGEBONUS_2: 	nDamage = 2;		break;
			case IP_CONST_DAMAGEBONUS_20: 	nDamage = 20;		break;
			case IP_CONST_DAMAGEBONUS_21: 	nDamage = 21;		break;
			case IP_CONST_DAMAGEBONUS_22: 	nDamage = 22;		break;
			case IP_CONST_DAMAGEBONUS_23: 	nDamage = 23;		break;
			case IP_CONST_DAMAGEBONUS_24: 	nDamage = 24;		break;
			case IP_CONST_DAMAGEBONUS_25: 	nDamage = 25;		break;
			case IP_CONST_DAMAGEBONUS_26: 	nDamage = 26;		break;
			case IP_CONST_DAMAGEBONUS_27: 	nDamage = 27;		break;
			case IP_CONST_DAMAGEBONUS_28: 	nDamage = 28;		break;
			case IP_CONST_DAMAGEBONUS_29: 	nDamage = 29;		break;
			case IP_CONST_DAMAGEBONUS_2d10: nDamage = d10(2);	break;
			case IP_CONST_DAMAGEBONUS_2d12: nDamage = d12(2);	break;
			case IP_CONST_DAMAGEBONUS_2d4: 	nDamage = d4(2);	break;
			case IP_CONST_DAMAGEBONUS_2d6: 	nDamage = d6(2);	break;
			case IP_CONST_DAMAGEBONUS_2d8: 	nDamage = d8(2);	break;
			case IP_CONST_DAMAGEBONUS_3: 	nDamage = 3;		break;
			case IP_CONST_DAMAGEBONUS_30: 	nDamage = 30;		break;
			case IP_CONST_DAMAGEBONUS_31: 	nDamage = 31;		break;
			case IP_CONST_DAMAGEBONUS_32:	nDamage = 32;		break;
			case IP_CONST_DAMAGEBONUS_33:	nDamage = 33;		break;
			case IP_CONST_DAMAGEBONUS_34:	nDamage = 34;		break;
			case IP_CONST_DAMAGEBONUS_35: 	nDamage = 35;		break;
			case IP_CONST_DAMAGEBONUS_36: 	nDamage = 36;		break;
			case IP_CONST_DAMAGEBONUS_37: 	nDamage = 37;		break;
			case IP_CONST_DAMAGEBONUS_38: 	nDamage = 38;		break;
			case IP_CONST_DAMAGEBONUS_39: 	nDamage = 39;		break;
			case IP_CONST_DAMAGEBONUS_4: 	nDamage = 4;		break;
			case IP_CONST_DAMAGEBONUS_40: 	nDamage = 40;		break;
			case IP_CONST_DAMAGEBONUS_5: 	nDamage = 5;		break;
			case IP_CONST_DAMAGEBONUS_6: 	nDamage = 6;		break;
			case IP_CONST_DAMAGEBONUS_7: 	nDamage = 7;		break;
			case IP_CONST_DAMAGEBONUS_8:	nDamage = 8;		break;
			case IP_CONST_DAMAGEBONUS_9: 	nDamage = 9;		break;
			case IP_CONST_DAMAGEBONUS_3d10:	nDamage = d10(3);	break;
			case IP_CONST_DAMAGEBONUS_3d12:	nDamage = d12(3);	break;
			case IP_CONST_DAMAGEBONUS_3d6:	nDamage = d6(3);	break;
			case IP_CONST_DAMAGEBONUS_4d10:	nDamage = d10(4);	break;
			case IP_CONST_DAMAGEBONUS_4d12:	nDamage = d12(4);	break;
			case IP_CONST_DAMAGEBONUS_4d6: 	nDamage = d6(4);	break;
			case IP_CONST_DAMAGEBONUS_4d8: 	nDamage = d8(4);	break;
			case IP_CONST_DAMAGEBONUS_5d12:	nDamage = d12(5);	break;
			case IP_CONST_DAMAGEBONUS_5d6: 	nDamage = d6(5);	break;
			case IP_CONST_DAMAGEBONUS_6d12:	nDamage = d12(6);	break;
			case IP_CONST_DAMAGEBONUS_6d6: 	nDamage = d6(6);	break;
			default: 						nDamage = 1;		break;
		}
	}

	return nDamage;
}



// Returns the visual effect of the strike connecting with the target.
// -oWeapon: Used to determine which item property effects will influence the hit.
// -nHit: Only valid for 1 and 2; hit and critical hit.
// -oFoe: Our target, to which it is assumed we are attacking.
void TOBStrikeVFXDamage(object oWeapon, int nHit, object oFoe, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBStrikeVFXDamage Start", GetFirstPC() ); }
	
	int nArrowFx = DAMAGE_TYPE_SONIC;
	effect eAcid, eCold, eHoly, eElec, eFire, eDark, eSonic;
	effect eLink;

	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect))
	{
		int nType = GetEffectType(eEffect);
		if (nType == EFFECT_TYPE_DAMAGE_INCREASE)
		{
			switch (GetEffectInteger(eEffect, 1))  //DamageType
			{
				case DAMAGE_TYPE_ACID:			eAcid = EffectVisualEffect(VFX_HIT_SPELL_ACID);		nArrowFx = DAMAGE_TYPE_ACID;		break;		
				case DAMAGE_TYPE_COLD:			eCold = EffectVisualEffect(VFX_HIT_SPELL_ICE);		nArrowFx = DAMAGE_TYPE_COLD;		break;
				case DAMAGE_TYPE_DIVINE:		eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case DAMAGE_TYPE_ELECTRICAL:	eElec = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);nArrowFx = DAMAGE_TYPE_ELECTRICAL;	break;
				case DAMAGE_TYPE_FIRE:			eFire = EffectVisualEffect(VFX_HIT_SPELL_FIRE);		nArrowFx = DAMAGE_TYPE_FIRE;		break;
				case DAMAGE_TYPE_NEGATIVE:		eDark = EffectVisualEffect(VFX_HIT_SPELL_EVIL);		nArrowFx = DAMAGE_TYPE_SONIC;		break;
				case DAMAGE_TYPE_POSITIVE:		eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case DAMAGE_TYPE_SONIC:			eSonic = EffectVisualEffect(VFX_HIT_SPELL_SONIC);	nArrowFx = DAMAGE_TYPE_SONIC;		break;
			}											
		}
		eEffect = GetNextEffect(oPC);
	}

	itemproperty eVis;
	eVis = GetFirstItemProperty(oWeapon);

	while (GetIsItemPropertyValid(eVis))
	{
		if (GetItemPropertyType(eVis) == ITEM_PROPERTY_DAMAGE_BONUS)
		{	
			switch (GetItemPropertySubType(eVis))
			{
				case IP_CONST_DAMAGETYPE_ACID:			eAcid = EffectVisualEffect(VFX_HIT_SPELL_ACID);		nArrowFx = DAMAGE_TYPE_ACID;		break;
				case IP_CONST_DAMAGETYPE_COLD:			eCold = EffectVisualEffect(VFX_HIT_SPELL_ICE);		nArrowFx = DAMAGE_TYPE_COLD;		break;
				case IP_CONST_DAMAGETYPE_DIVINE:		eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case IP_CONST_DAMAGETYPE_ELECTRICAL:	eElec = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);nArrowFx = DAMAGE_TYPE_ELECTRICAL;	break;
				case IP_CONST_DAMAGETYPE_FIRE:			eFire = EffectVisualEffect(VFX_HIT_SPELL_FIRE);		nArrowFx = DAMAGE_TYPE_FIRE;		break;
				case IP_CONST_DAMAGETYPE_NEGATIVE:		eDark = EffectVisualEffect(VFX_HIT_SPELL_EVIL);		nArrowFx = DAMAGE_TYPE_SONIC;		break;
				case IP_CONST_DAMAGETYPE_POSITIVE:		eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case IP_CONST_DAMAGETYPE_SONIC:			eSonic = EffectVisualEffect(VFX_HIT_SPELL_SONIC);	nArrowFx = DAMAGE_TYPE_SONIC;		break;
			}
		}
		else if (GetItemPropertyType(eVis) == ITEM_PROPERTY_VISUALEFFECT)
		{	
			switch (GetItemPropertySubType(eVis))
			{
				case ITEM_VISUAL_ACID:			eAcid = EffectVisualEffect(VFX_HIT_SPELL_ACID);		nArrowFx = DAMAGE_TYPE_ACID;		break;
				case ITEM_VISUAL_COLD:			eCold = EffectVisualEffect(VFX_HIT_SPELL_ICE);		nArrowFx = DAMAGE_TYPE_COLD;		break;
				case ITEM_VISUAL_HOLY:			eHoly = EffectVisualEffect(VFX_HIT_SPELL_HOLY);		nArrowFx = DAMAGE_TYPE_DIVINE;		break;
				case ITEM_VISUAL_ELECTRICAL:	eElec = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);nArrowFx = DAMAGE_TYPE_ELECTRICAL;	break;
				case ITEM_VISUAL_FIRE:			eFire = EffectVisualEffect(VFX_HIT_SPELL_FIRE);		nArrowFx = DAMAGE_TYPE_FIRE;		break;
				case ITEM_VISUAL_EVIL:			eDark = EffectVisualEffect(VFX_HIT_SPELL_EVIL);		nArrowFx = DAMAGE_TYPE_SONIC;		break;
				case ITEM_VISUAL_SONIC:			eSonic = EffectVisualEffect(VFX_HIT_SPELL_SONIC);	nArrowFx = DAMAGE_TYPE_SONIC;		break;
			}
		}
		eVis = GetNextItemProperty(oWeapon);
	}

	if (nHit == 1)
	{
		effect eStandard = EffectNWN2SpecialEffectFile("fx_hit_spark_stand", oFoe);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eStandard, oFoe);
	
		eLink = EffectLinkEffects(eCold, eAcid);
		eLink = EffectLinkEffects(eLink, eHoly);
		eLink = EffectLinkEffects(eLink, eElec);
		eLink = EffectLinkEffects(eLink, eFire);
		eLink = EffectLinkEffects(eLink, eDark);
		eLink = EffectLinkEffects(eLink, eSonic);

		if ((CSLGetSneakLevels(oPC) > 0) && (CSLIsTargetValidForSneakAttack(oFoe, oPC) == TRUE))
		{
			effect eSneak = EffectNWN2SpecialEffectFile("fx_hit_spark_sneak", oFoe);
			eLink = EffectLinkEffects(eLink, eSneak);
		}

		if (GetWeaponRanged(oWeapon))
		{
			int nWeapon = GetBaseItemType(oWeapon);
			location lPC = GetLocation(oPC);
			location lFoe = GetLocation(oFoe);
			float fArrow = GetProjectileTravelTime(lPC, lFoe, PROJECTILE_PATH_TYPE_DEFAULT);
			
			SpawnItemProjectile(oPC, oFoe, lPC, lFoe, nWeapon, PROJECTILE_PATH_TYPE_DEFAULT, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, nArrowFx);
			DelayCommand(fArrow, SpawnBloodHit(oFoe, FALSE, oPC));
		}
		else SpawnBloodHit(oFoe, FALSE, oPC);
	}
	else if (nHit == 2)
	{
		effect eCrit = EffectNWN2SpecialEffectFile("fx_hit_spark_crit", oFoe);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eCrit, oFoe);
		
		eLink = EffectLinkEffects(eCold, eAcid); // If none of these effects are valid no other linked effects will run.
		eLink = EffectLinkEffects(eLink, eHoly);
		eLink = EffectLinkEffects(eLink, eElec);
		eLink = EffectLinkEffects(eLink, eFire);
		eLink = EffectLinkEffects(eLink, eDark);
		eLink = EffectLinkEffects(eLink, eSonic);

		if ((CSLGetSneakLevels(oPC) > 0) && (CSLIsTargetValidForSneakAttack(oFoe, oPC) == TRUE))
		{
			effect eSneak = EffectNWN2SpecialEffectFile("fx_hit_spark_sneak", oFoe);
			eLink = EffectLinkEffects(eLink, eSneak);
		}

		if (GetWeaponRanged(oWeapon))
		{
			int nWeapon = GetBaseItemType(oWeapon);
			location lPC = GetLocation(oPC);
			location lFoe = GetLocation(oFoe);
			float fArrow = GetProjectileTravelTime(lPC, lFoe, PROJECTILE_PATH_TYPE_DEFAULT);
			
			SpawnItemProjectile(oPC, oFoe, lPC, lFoe, nWeapon, PROJECTILE_PATH_TYPE_DEFAULT, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, nArrowFx);
			DelayCommand(fArrow, SpawnBloodHit(oFoe, TRUE, oPC));
		}
		else SpawnBloodHit(oFoe, TRUE, oPC);
	}
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oFoe);
}


// Applies instant critical hit damage to calculations.
struct tob_main_damage TOBStrikeCriticalEffect(object oPC, object oWeapon, object oTarget, int bIgnoreResistances = FALSE, int nMult = 1)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBStrikeCriticalEffect Start", GetFirstPC() ); }
	
	struct tob_main_damage main;
	int nDamage, nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

	object oToB = CSLGetDataStore(oPC);
	int nWeapon = GetWeaponType(oWeapon);
	int nBaseWeapon = GetBaseItemType(oWeapon);
	int nCritMult = CSLGetCriticalMultiplier(oWeapon);
	int nOCFeat = CSLGetItemDataPrefFeatOverwhelmingCritical(nBaseWeapon);

	itemproperty iProp = GetFirstItemProperty(oWeapon);
		
	while (GetIsItemPropertyValid(iProp))
	{
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_MASSIVE_CRITICALS)
		{	
			int nMassive = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iProp));
			
			switch (nWeapon)  //DamageType
			{		
				case WEAPON_TYPE_PIERCING_AND_SLASHING:		nPierce += nMassive;	break;					
				case WEAPON_TYPE_PIERCING:					nPierce += nMassive;	break;					
				case WEAPON_TYPE_SLASHING:					nSlash += nMassive;		break;				
				default: 									nBlunt += nMassive;		break;																														
			}
		}
		iProp=GetNextItemProperty(oWeapon);
	}
	
	if ((GetHasFeat(nOCFeat, oPC)) && (!GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))) // Overwhelming Critical
	{
		if (nCritMult == 2)
		{
			nDamage += CSLGetDamageByDice(6, 1);
		}
		else if (nCritMult == 3)
		{
			nDamage += CSLGetDamageByDice(6, 2);
		}
		else if (nCritMult == 4)
		{
			nDamage += CSLGetDamageByDice(6, 3);
		}
		else if (nCritMult > 4)
		{
			nDamage += CSLGetDamageByDice(6, 4);
		}
	}
	
	if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
	{
		nPierce += nDamage;
	}
	else if (nWeapon == WEAPON_TYPE_SLASHING)
	{
		nSlash += nDamage;
	}
	else nBlunt += nDamage;
	
	if ((GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, oPC)) && (CSLGetIsRaging(oPC)))
	{
		if (nCritMult == 2)
		{
			nSonic += CSLGetDamageByDice(8, 1);
		}
		else if (nCritMult == 3)
		{
			nSonic += CSLGetDamageByDice(8, 2);
		}
		else if (nCritMult == 4)
		{
			nSonic += CSLGetDamageByDice(8, 3);
		}
		else if (nCritMult > 4)
		{
			nSonic += CSLGetDamageByDice(8, 4);
		}
	}

	nPierce *= nMult;
	nSlash *= nMult;
	nBlunt *= nMult;
	nSonic *= nMult;

	//Time to build a mega damage event.

	if (nBlunt > 0)
	{
		if ((GetLevelByClass(CLASS_TYPE_MONK, oPC) > 15) && (!GetIsObjectValid(oWeapon)))
		{
			nMagic += nBlunt;
			nBlunt = 0;
		}
	}

	int nStrikeTotal = GetLocalInt(oPC, "bot9s_StrikeTotal");
	int nStrike = nSlash + nBlunt + nPierce + nAcid + nCold + nElec + nFire + nSonic + nDivine + nMagic + nPosit + nNegat;

	// Used in certain strikes.  The variable must be cleared out in the strike script or the damage will continue to pile.
	SetLocalInt(oPC, "bot9s_StrikeTotal", nStrikeTotal + nStrike);

	main.nPierce = nPierce;
	main.nAcid = nAcid;
	main.nSlash = nSlash;
	main.nBlunt = nBlunt;
	main.nCold = nCold;
	main.nElec = nElec;			
	main.nFire = nFire;
	main.nSonic = nSonic;
	main.nDivine = nDivine;
	main.nMagic = nMagic;			
	main.nPosit = nPosit;
	main.nNegat = nNegat;

	return main;
}







// Applies base weapon damage, visual effects and critical hit damage based on
// the results of TOBStrikeAttackRoll.  0 for miss, 1 for hit, 2 for critical hit.
// -oWeapon: The weapon we're generating attack damage for.
// -nHit: The type of hit or miss we're generating a visual effect for.
// nHit also will apply critical hit damage if it equals 2.
// -oFoe: Our target gets chances to defend against certain effects!
// -nMisc: Any misc bonues to damage.
// -bIgnoreResistances: Sets if this attack bypasses DR or not.  Defaults to FALSE.
// -nMult: Number to multiply total damage by.  Defaults to one.
effect TOBBaseStrikeDamage(object oWeapon, int nHit, object oFoe, int nMisc = 0, int bIgnoreResistances = FALSE, int nMult = 1)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBBaseStrikeDamage Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	effect eLink;

	TOBStrikeVFXDamage(oWeapon, nHit, oFoe);

	if (nHit > 0)
	{
		int nSlash, nBlunt, nPierce, nAcid, nCold, nElec, nFire, nSonic, nDivine, nMagic, nPosit, nNegat;

		struct tob_main_damage rDamage = TOBGenerateAttackEffect(oPC, oWeapon, oFoe, nMisc, bIgnoreResistances, nMult);
		struct tob_main_damage rWeapon = TOBGenerateItemProperties(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

		nSlash += rDamage.nSlash;
		nBlunt += rDamage.nBlunt;
		nPierce += rDamage.nPierce;
		nAcid += rDamage.nAcid;
		nFire += rDamage.nFire;
		nCold += rDamage.nCold;
		nElec += rDamage.nElec;
		nSonic += rDamage.nSonic;
		nDivine += rDamage.nDivine;
		nMagic += rDamage.nMagic;
		nPosit += rDamage.nPosit;
		nNegat += rDamage.nNegat;
		nSlash += rWeapon.nSlash;
		nBlunt += rWeapon.nBlunt;
		nPierce += rWeapon.nPierce;
		nAcid += rWeapon.nAcid;
		nFire += rWeapon.nFire;
		nCold += rWeapon.nCold;
		nElec += rWeapon.nElec;
		nSonic += rWeapon.nSonic;
		nDivine += rWeapon.nDivine;
		nMagic += rWeapon.nMagic;
		nPosit += rWeapon.nPosit;
		nNegat += rWeapon.nNegat;

		int nSneak = CSLGetSneakLevels(oPC);

		if ((nSneak > 0) && (CSLIsTargetValidForSneakAttack(oFoe, oPC)))
		{
			struct tob_main_damage rSneak = TOBSneakAttack(oWeapon, oPC, oFoe, bIgnoreResistances);

			nSlash += rSneak.nSlash;
			nBlunt += rSneak.nBlunt;
			nPierce += rSneak.nPierce;
			nAcid += rSneak.nAcid;
			nFire += rSneak.nFire;
			nCold += rSneak.nCold;
			nElec += rSneak.nElec;
			nSonic += rSneak.nSonic;
			nDivine += rSneak.nDivine;
			nMagic += rSneak.nMagic;
			nPosit += rSneak.nPosit;
			nNegat += rSneak.nNegat;
		}

		if ((nHit == 2) && (!GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)))
		{
			struct tob_main_damage rCrit = TOBGenerateAttackEffect(oPC, oWeapon, oFoe, nMisc, bIgnoreResistances, nMult);
			struct tob_main_damage rCritEffects = TOBStrikeCriticalEffect(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

			nSlash += rCrit.nSlash;
			nBlunt += rCrit.nBlunt;
			nPierce += rCrit.nPierce;
			nAcid += rCrit.nAcid;
			nFire += rCrit.nFire;
			nCold += rCrit.nCold;
			nElec += rCrit.nElec;
			nSonic += rCrit.nSonic;
			nDivine += rCrit.nDivine;
			nMagic += rCrit.nMagic;
			nPosit += rCrit.nPosit;
			nNegat += rCrit.nNegat;
			nSlash += rCritEffects.nSlash;
			nBlunt += rCritEffects.nBlunt;
			nPierce += rCritEffects.nPierce;
			nAcid += rCritEffects.nAcid;
			nFire += rCritEffects.nFire;
			nCold += rCritEffects.nCold;
			nElec += rCritEffects.nElec;
			nSonic += rCritEffects.nSonic;
			nDivine += rCritEffects.nDivine;
			nMagic += rCritEffects.nMagic;
			nPosit += rCritEffects.nPosit;
			nNegat += rCritEffects.nNegat;

			if (CSLGetCriticalMultiplier(oWeapon) > 2)
			{
				struct tob_main_damage rCrit3 = TOBGenerateAttackEffect(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

				nSlash += rCrit3.nSlash;
				nBlunt += rCrit3.nBlunt;
				nPierce += rCrit3.nPierce;
				nAcid += rCrit3.nAcid;
				nFire += rCrit3.nFire;
				nCold += rCrit3.nCold;
				nElec += rCrit3.nElec;
				nSonic += rCrit3.nSonic;
				nDivine += rCrit3.nDivine;
				nMagic += rCrit3.nMagic;
				nPosit += rCrit3.nPosit;
				nNegat += rCrit3.nNegat;
			}
	
			if (CSLGetCriticalMultiplier(oWeapon) > 3)
			{
				struct tob_main_damage rCrit4 = TOBGenerateAttackEffect(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

				nSlash += rCrit4.nSlash;
				nBlunt += rCrit4.nBlunt;
				nPierce += rCrit4.nPierce;
				nAcid += rCrit4.nAcid;
				nFire += rCrit4.nFire;
				nCold += rCrit4.nCold;
				nElec += rCrit4.nElec;
				nSonic += rCrit4.nSonic;
				nDivine += rCrit4.nDivine;
				nMagic += rCrit4.nMagic;
				nPosit += rCrit4.nPosit;
				nNegat += rCrit4.nNegat;
			}
	
			if (CSLGetCriticalMultiplier(oWeapon) > 4)
			{
				struct tob_main_damage rCrit5 = TOBGenerateAttackEffect(oPC, oWeapon, oFoe, bIgnoreResistances, nMult);

				nSlash += rCrit5.nSlash;
				nBlunt += rCrit5.nBlunt;
				nPierce += rCrit5.nPierce;
				nAcid += rCrit5.nAcid;
				nFire += rCrit5.nFire;
				nCold += rCrit5.nCold;
				nElec += rCrit5.nElec;
				nSonic += rCrit5.nSonic;
				nDivine += rCrit5.nDivine;
				nMagic += rCrit5.nMagic;
				nPosit += rCrit5.nPosit;
				nNegat += rCrit5.nNegat;
			}
		}

		eLink = EffectDamage(nPierce, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, bIgnoreResistances);

		if (nAcid > 0)
		{
			effect eDmg = EffectDamage(nAcid, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
		
		if (nSlash > 0)
		{
			effect eDmg = EffectDamage(nSlash, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nBlunt > 0)
		{
			effect eDmg = EffectDamage(nBlunt, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nCold > 0)
		{
			effect eDmg = EffectDamage(nCold, DAMAGE_TYPE_COLD, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}			
	
		if (nElec > 0)
		{
			effect eDmg = EffectDamage(nElec, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nFire > 0)
		{
			effect eDmg = EffectDamage(nFire, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nSonic > 0)
		{
			effect eDmg = EffectDamage(nSonic, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}		
	
		if (nDivine > 0)
		{
			effect eDmg = EffectDamage(nDivine, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}			
	
		if (nMagic > 0)
		{
			effect eDmg = EffectDamage(nMagic, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nPosit > 0)
		{
			effect eDmg = EffectDamage(nPosit, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	
		if (nNegat > 0)
		{
			effect eDmg = EffectDamage(nNegat, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, bIgnoreResistances);
			eLink = EffectLinkEffects(eDmg, eLink);
		}
	}

	return eLink;
}

// Applies misc permanent effects to a strike and must be applied seperately from TOBBaseStrikeDamage
effect TOBStrikePermanentEffects(object oWeapon, int nHit, object oFoe)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBStrikePermanentEffects Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	effect eLink;
	
	if (nHit > 0)
	{
		if ((GetHasFeat(FEAT_CRIPPLING_STRIKE, oPC)) && (!GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)) && (GetLocalInt(oPC, "SneakHasHit") == 1))
		{
			effect eCrippling = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
			eCrippling = ExtraordinaryEffect(eCrippling);
			eCrippling = SetEffectSpellId(eCrippling, -1);
			eLink = EffectLinkEffects(eCrippling, eLink);
		} 
	}
	// Critical Hit only.
	if ((nHit == 2) && (!GetIsImmune(oFoe, IMMUNITY_TYPE_CRITICAL_HIT)))
	{
		if (GetHasFeat(2150, oPC)) //Weakening Critical
		{
			effect eWeakeningCrit = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
			eWeakeningCrit = ExtraordinaryEffect(eWeakeningCrit);
			eWeakeningCrit = SetEffectSpellId(eWeakeningCrit, -1);
			eLink = EffectLinkEffects(eLink, eWeakeningCrit);
		}
		
		if (GetHasFeat(2151, oPC)) //Wounding Critical
		{
			effect eWoundingCrit = EffectAbilityDecrease(ABILITY_CONSTITUTION, 2);
			eWoundingCrit = ExtraordinaryEffect(eWoundingCrit);
			eWoundingCrit = SetEffectSpellId(eWoundingCrit, -1);
			eLink = EffectLinkEffects(eLink, eWoundingCrit);
		}
	}

	return eLink;
}

// A standard heal effect with routing for the Crusader's Delayed Damage Pool.
effect TOBManeuverHealing(object oTarget, int nHealAmount)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBManeuverHealing Start", GetFirstPC() ); }
	
	if (GetLevelByClass(CLASS_TYPE_CRUSADER, oTarget) > 0)
	{
		object oToB = CSLGetDataStore(oTarget);

		if ((GetIsObjectValid(oToB)) && (GetLocalInt(oToB, "FuriousCounterstrike") == 0))
		{
			int nHp = GetCurrentHitPoints(oTarget);
			int nMaxHp = GetMaxHitPoints(oTarget);
			int nSurplus = nHp + nHealAmount;

			if (nSurplus > nMaxHp)
			{
				int nHeal = nMaxHp - nSurplus;

				SetLocalInt(oToB, "DDPoolCanHeal", 1);
				SetLocalInt(oToB, "DDPoolHealValue", nHeal);
				DelayCommand(6.0f, SetLocalInt(oToB, "DDPoolCanHeal", 1));
				DelayCommand(6.0f, SetLocalInt(oToB, "DDPoolHealValue", 0));
			}
		}
	}
	effect eHeal = EffectHeal(nHealAmount);
	return eHeal;
}



// Tracks the number of critical hits the player makes for the Stance, Blood in the Water.
void TOBDoBloodInTheWater(object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDoBloodInTheWater Start", GetFirstPC() ); }
	
	if (hkStanceGetHasActive(oPC,165))
	{
		object oToB = CSLGetDataStore(oPC);
		int nCritCount = GetLocalInt(oToB, "CritCount");

		SetLocalInt(oToB, "CritCount", nCritCount + 1);
	}
}

// Handles the healing portion of the stance Martial Spirit.
void TOBDoMartialSpirit(object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDoMartialSpirit Start", GetFirstPC() ); }
	
	if (hkStanceGetHasActive(oPC,44))
	{
		object oHeal;
		object oWeak = GetFactionWeakestMember(oPC, TRUE);
		effect eHeal = TOBManeuverHealing(oPC, 2);

		if (GetDistanceBetween(oPC, oWeak) > (FeetToMeters(30.0f) + CSLGetGirth(oPC)))
		{
			oHeal = oPC;
		}
		else oHeal = oWeak;

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oHeal);
	}
}


// Handles the attack penalty for the boost Covering Strike.
void TOBDoCoveringStrike(object oFoe, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDoCoveringStrike Start", GetFirstPC() ); }
	
	if ((GetLocalInt(oPC, "CoveringStrike") == 1) && (GetAttackTarget(oFoe) != oPC))
	{
		int nRank = GetSkillRank(SKILL_DIPLOMACY, oPC);
		int nDiplomacy;

		nDiplomacy = (nRank - 4)/4;

		if (nDiplomacy < 1)
		{
			nDiplomacy = 1;
		}

		effect eCover = EffectAttackDecrease(nDiplomacy);
		eCover = ExtraordinaryEffect(eCover);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCover, oFoe, 6.0f);
	}
}

// Handles healing for the stance Aura of Triumph.
void TOBDoAuraOfTriumph(object oFoe, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDoAuraOfTriumph Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);

	if ((GetLocalInt(oPC, "ToB_Triumph") == 1) || (GetLocalInt(oPC, "AuraOfTriumph") == 1))
	{
		int nEvil = GetAlignmentGoodEvil(oFoe);

		if (nEvil == ALIGNMENT_EVIL)
		{
			effect eHeal = TOBManeuverHealing(oPC, 4);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);

			object oParty1 = GetLocalObject(oToB, "TriumphParty1");
			object oParty2 = GetLocalObject(oToB, "TriumphParty2");
			object oParty3 = GetLocalObject(oToB, "TriumphParty3");
			object oParty4 = GetLocalObject(oToB, "TriumphParty4");
			object oParty5 = GetLocalObject(oToB, "TriumphParty5");
			object oParty6 = GetLocalObject(oToB, "TriumphParty6");
			object oParty7 = GetLocalObject(oToB, "TriumphParty7");

			if (GetIsObjectValid(oParty1))
			{
				effect eHeal1 = TOBManeuverHealing(oParty1, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal1, oParty1);
			}

			if (GetIsObjectValid(oParty2))
			{
				effect eHeal2 = TOBManeuverHealing(oParty2, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal2, oParty2);
			}

			if (GetIsObjectValid(oParty3))
			{
				effect eHeal3 = TOBManeuverHealing(oParty3, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal3, oParty3);
			}

			if (GetIsObjectValid(oParty4))
			{
				effect eHeal4 = TOBManeuverHealing(oParty4, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal4, oParty4);
			}

			if (GetIsObjectValid(oParty5))
			{
				effect eHeal5 = TOBManeuverHealing(oParty5, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal5, oParty5);
			}

			if (GetIsObjectValid(oParty6))
			{
				effect eHeal6 = TOBManeuverHealing(oParty6, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal6, oParty6);
			}

			if (GetIsObjectValid(oParty7))
			{
				effect eHeal7 = TOBManeuverHealing(oParty7, 4);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal7, oParty7);
			}
		}
	}
}




// Matches an executing maneuver with the BlueBox Calling it.  Returns the BlueBox.
// -nManeuver: 2da reference number of the maneuver's script.  If we're going by
// the rules as written, there should only be one of these on any given screen.
// -sType: Valid only for STR, B, and C; Strikes, Boosts, and Counters.
string TOBMatchBlue(int nManeuver, string sType, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBMatchBlue Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	string sReturn;
	int i;

	i = 1;

	while (i < 21)
	{
		if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_CR") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "_CR";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_SA") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "_SA";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_SS") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "_SS";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_WB") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "_WB";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "___") == nManeuver)
		{
			sReturn = "BlueBox" + sType + IntToString(i) + "___";
			SetLocalInt(oToB, "BlueNumber", i);
			break;
		}
		else i++;
	}
	return sReturn;
}






// Clears the variables that govern the Quickstrike menu.
// -sClass: Determines which class's menu is cleared.
void TOBClearBoxes(string sClass, object oToB = OBJECT_INVALID)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBClearBoxes Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	if ( !GetIsObjectValid(oToB) )
	{
		oToB = CSLGetDataStore(oPC);
	}
	
	string sClassy;

	if (sClass == "")
	{
		sClassy = "___";
	}
	else if (sClass == "CR")
	{
		sClassy = "_CR";
	}
	else if (sClass == "SA")
	{
		sClassy = "_SA";
	}
	else if (sClass == "SS")
	{
		sClassy = "_SS";
	}
	else if (sClass == "WB")
	{
		sClassy = "_WB";
	}

	string sUse;

	if (GetStringLeft(sClass, 1) == "_")
	{
		sUse = sClass;
	}
	else sUse = sClassy;

	// Maneuvers Known variables.

	DeleteLocalInt(oToB, "Known" + sUse + "1Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "1Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "2Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "3Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "4Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "5Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "6Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "7Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "8Row10" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row1" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row2" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row3" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row4" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row5" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row6" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row7" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row8" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row9" + "Disabled");
	DeleteLocalInt(oToB, "Known" + sUse + "9Row10" + "Disabled");

	int i = 1;

	while (i < 18) //RedBoxes
	{
		SetLocalInt(oToB, "RedBox" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 18) //Readied Maneuver values.
	{
		DeleteLocalString(oToB, "Readied" + IntToString(i) + sUse);
		DeleteLocalInt(oToB, "ReadiedRow" + IntToString(i) + sUse);
		DeleteLocalInt(oToB, "Readied" + IntToString(i) + sUse + "Disabled");
		i++;
	}

	i = 1;

	while (i < 11) //GreenBoxes
	{
		SetLocalInt(oToB, "GreenBoxB" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 11)
	{
		SetLocalInt(oToB, "GreenBoxC" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 21)
	{
		SetLocalInt(oToB, "GreenBoxSTR" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 11) //BlueBoxes
	{
		SetLocalInt(oToB, "BlueBoxB" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 11)
	{
		SetLocalInt(oToB, "BlueBoxC" + IntToString(i) + sUse, 0);
		i++;
	}

	i = 1;

	while (i < 21)
	{
		SetLocalInt(oToB, "BlueBoxSTR" + IntToString(i) + sUse, 0);
		i++;
	}
}

// Clears all of the data on the Maneuvers Known screen.
// -sClass: Determines which class's screen is cleared.
void TOBClearManeuversKnown(string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBClearManeuversKnown Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);

	if (sClass == "" || sClass == "__")
	{
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "STANCE_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL1_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL2_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL3_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL4_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL5_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL6_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL7_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL8_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL9_LIST");
	}
	else
	{
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "STANCE_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL1_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL2_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL3_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL4_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL5_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL6_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL7_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL8_LIST");
		ClearListBox(oPC, "SCREEN_MANEUVERS_KNOWN" + "_" + sClass, "LEVEL9_LIST");
	}
}

// Clears all of the data on the Maneuvers Readied screen.
// -sClass: Determines which class's screen is cleared.
void TOBClearManeuversReadied(string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBClearManeuversReadied Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);

	if (sClass == "" || sClass == "__")
	{
		if (sClass == "SS")
		{
			ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_17");
		}

		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_1");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_2");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_3");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_4");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_5");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_6");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_7");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_8");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_9");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_10");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_11");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_12");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_13");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_14");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_15");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED", "READIED_16");
	}
	else
	{
		if (sClass == "SS")
		{
			ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_17");
		}

		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_1");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_2");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_3");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_4");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_5");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_6");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_7");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_8");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_9");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_10");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_11");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_12");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_13");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_14");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_15");
		ClearListBox(oPC, "SCREEN_MANEUVERS_READIED" + "_" + sClass, "READIED_16");
	}
}

// Clears all currently enqueued strikes.
void TOBClearStrikes()
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBClearStrikes Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = CSLGetDataStore(oPC);

	int i;

	i = 1;

	while (GetLocalInt(oToB, "Strike" + IntToString(i)) > 0)
	{
		DeleteLocalInt(oToB, "Strike" + IntToString(i));
		i++;
	}
}


// Flags sListBox as being used so that we don't attempt to disable the same box later.
void TOBSetDisabledStatus(string sListBox, int nTotal, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBSetDisabledStatus Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	string sScreen = "SCREEN_QUICK_STRIKE_CR";

	if ((GetLocalString(oToB, "RandomRecoveryFlag1") == "") && (1 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag1", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag2") == "") && (2 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag2", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag3") == "") && (3 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag3", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag4") == "") && (4 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag4", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag5") == "") && (5 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag5", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag6") == "") && (6 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag6", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag7") == "") && (7 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag7", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag8") == "") && (8 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag8", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag9") == "") && (9 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag9", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag10") == "") && (10 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag10", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag11") == "") && (11 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag11", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag12") == "") && (12 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag12", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag13") == "") && (13 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag13", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag14") == "") && (14 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag14", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag15") == "") && (15 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag15", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag16") == "") && (16 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag16", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag17") == "") && (17 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag17", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag18") == "") && (18 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag18", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag19") == "") && (19 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag19", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag20") == "") && (20 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag20", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag21") == "") && (21 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag21", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag22") == "") && (22 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag22", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag23") == "") && (23 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag23", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag24") == "") && (24 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag24", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag25") == "") && (25 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag25", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag26") == "") && (26 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag26", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag27") == "") && (27 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag27", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag28") == "") && (28 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag28", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag29") == "") && (29 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag29", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag30") == "") && (30 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag30", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag31") == "") && (31 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag31", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag32") == "") && (32 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag32", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag33") == "") && (33 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag33", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag34") == "") && (34 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag34", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag35") == "") && (35 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag35", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag36") == "") && (36 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag36", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag37") == "") && (37 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag37", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag38") == "") && (38 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag38", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag39") == "") && (39 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag39", sListBox);
	}
	else if ((GetLocalString(oToB, "RandomRecoveryFlag40") == "") && (40 <= nTotal))
	{
		SetLocalString(oToB, "RandomRecoveryFlag40", sListBox);
	}
}

// Enforces the rules about being reduced to zero in any stat automatically
// incapacitating a target since NWN2's engine will not do it.
// -oTarget: The creature who's ability we're checking.
// -nAbility: The ABILITY_* constant of the stat we're checking to see if it
// has reached zero.  If so, oTarget takes damage equal to its total hp value.
void TOBDropDead(object oTarget, int nAbility)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDropDead Start", GetFirstPC() ); }
	
	int nStat = GetAbilityScore(oTarget, nAbility);

	if (nStat < 1)
	{
		int nHp = GetCurrentHitPoints(oTarget);
		effect eDamage = EffectDamage(nHp, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);

		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	}
}


// Expends the maneuver upon it's execution.
// -nManeuver: 2DA reference number of the maneuver.
// -sType: The type of maneuver being executed.  Valid only for B, C, and STR.
// Boosts, Counters, and Strikes respectively.
void TOBExpendManeuver(int nManeuver, string sType, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBExpendManeuver Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	string sBlueBox = TOBMatchBlue(nManeuver, sType);
	string sClass = GetStringRight(sBlueBox, 3);
	string sScreen;

	if (sClass == "___") // Finding the Screen the maneuver is on.
	{
		sScreen = "SCREEN_QUICK_STRIKE";
	}
	else sScreen = "SCREEN_QUICK_STRIKE" + sClass;

	string sTypeName; // Convert type abbreviation to the name on the listbox.
	
	if (sType == "B")
	{
		sTypeName = "BOOST";
	}
	else if (sType == "C")
	{
		sTypeName = "COUNTER";
	}
	else 
	{
		sTypeName = "STRIKE";
		SetLocalInt(oToB, "Strike", 0);
	}

	int nNumber = GetLocalInt(oToB, "BlueNumber");
	string sNumber;

	switch (nNumber) // Converts the number to written form for the name of the listbox.
	{
		case 1:	sNumber = "ONE";		break;
		case 2:	sNumber = "TWO";		break;
		case 3:	sNumber = "THREE"; 		break;
		case 4:	sNumber = "FOUR";		break;
		case 5:	sNumber = "FIVE";		break;
		case 6:	sNumber = "SIX";		break;
		case 7:	sNumber = "SEVEN";		break;
		case 8:	sNumber = "EIGHT";		break;
		case 9:	sNumber = "NINE";		break;
		case 10:sNumber = "TEN";		break;
		case 11:sNumber = "ELEVEN";		break;
		case 12:sNumber = "TWELVE";		break;
		case 13:sNumber = "THIRTEEN";	break;
		case 14:sNumber = "FOURTEEN";	break;
		case 15:sNumber = "FIFTEEN";	break;
		case 16:sNumber = "SIXTEEN";	break;
		case 17:sNumber = "SEVENTEEN";	break;
		case 18:sNumber = "EIGHTEEN";	break;
		case 19:sNumber = "NINETEEN";	break;
		case 20:sNumber = "TWENTY";		break;
	}

	string sListBox = sTypeName + "_" + sNumber;

	if (sScreen == "SCREEN_QUICK_STRIKE_CR")
	{
		int nTotal = GetLocalInt(oToB, "CrLimit");
		TOBSetDisabledStatus(sListBox, nTotal);
	}

	SetGUIObjectDisabled(oPC, sScreen, sListBox, TRUE);
}


// Applies the results of weapon and feat modifiers on a martial strike.
// -oWeapon: Either right or left hand are vaild. (GetItemInSlot returning
// OBJECT_INVALID should return unarmed damage.
// -nHit: 0 for miss, 1 for hit, 2 for critical hit.
// -oFoe: The target of the strike.
// -nMisc: Any misc bonunes to damage.
// -bIgnoreResistances: Determines if the strike bypasses DR or not.
// -bSupressDamage: When set to TRUE prevents the strike from doing any damage
// but, all other events will occur, such as tracking for counter maneuvers.
// -nMult: Number to multiply total damage by.  Defaults to one.
void TOBStrikeWeaponDamage(object oWeapon, int nHit, object oTarget, int nMisc = 0, int bIgnoreResistances = FALSE, int bSupressDamage = FALSE, int nMult = 1)
{	
	if (DEBUGGING >= 7) { CSLDebug(  "TOBStrikeWeaponDamage Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oFoe;

	// Special Cases

	int nRedirect;

	if ((GetLocalInt(oTarget, "ManticoreParry") == 1) || (GetLocalInt(oTarget, "ScorpionParry") == 1) || (GetLocalInt(oTarget, "ShieldCounter") == 1) || (GetLocalInt(oTarget, "FoolsStrike") == 1) || (GetLocalInt(oTarget, "Ghostly") == 1))
	{
		if (HkSwiftActionIsActive(oTarget))
		{
			nRedirect = 1;
		}
	}

	if ((nRedirect == 1) && (GetLocalInt(oTarget, "ManticoreParry") == 1) && (GetIsObjectValid(oWeapon)) && (!GetWeaponRanged(oWeapon)))
	{
		nRedirect = 0;
		SetLocalInt(oTarget, "ManticoreParry", 2); // For this maneuver roles are reversed.  The oTarget should be a PC and oPC should be an enemey.

		object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		int nFoeAB = CSLGetMaxAB(oTarget, oFoeWeapon, oPC);
		int nAB = CSLGetMaxAB(oPC, oWeapon, oTarget);
		int nd20 = d20(1);
		int nFoed20 = d20(1);
		int nFoeRoll = nFoeAB + nFoed20;
		int nMyRoll = nAB + nd20;

		SendMessageToPC(oTarget, "<color=chocolate>Manticore Parry: Opposed Attack Roll: " + GetName(oTarget) + " (" + IntToString(nFoeAB) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ") vs. " + GetName(oPC) + " (" + IntToString(nAB) + " + " + IntToString(nd20) + " = " + IntToString(nMyRoll) + ").</color>");

		if (nFoeRoll > nMyRoll)
		{
			FloatingTextStringOnCreature("<color=cyan>*Manticore Parry!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);

			float fRange = CSLGetMeleeRange(oTarget);
			location lPC = GetLocation(oTarget);
			object oAlly;

			oAlly = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

			while (GetIsObjectValid(oAlly))
			{
				if ((oAlly != oPC) && (oAlly != oTarget) && (GetIsReactionTypeHostile(oAlly, oTarget)))
				{
					oFoe = oAlly;
					break;
				}
				else oFoe = OBJECT_INVALID;

				oAlly = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}

			if (GetIsObjectValid(oFoe))
			{
				effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
				SpawnBloodHit(oFoe, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, oPC);
			}
		}
		else 
		{
			FloatingTextStringOnCreature("<color=red>*Manticore Parry Failed!*</color>", oTarget, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			oFoe = oTarget;
		}
	}
	else oFoe = oTarget;

	if ((nRedirect == 1) && (GetLocalInt(oTarget, "ScorpionParry") == 1) && (!GetWeaponRanged(oWeapon)))// The only difference between this and Manticore Parry is that this can be used against unarmed attacks.
	{
		nRedirect = 0;
		SetLocalInt(oTarget, "ScorpionParry", 2); // For this maneuver roles are reversed.  The oTarget should be a PC and oPC should be an enemey.

		object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		int nFoeAB = CSLGetMaxAB(oTarget, oFoeWeapon, oPC);
		int nAB = CSLGetMaxAB(oPC, oWeapon, oFoe);
		int nd20 = d20(1);
		int nFoed20 = d20(1);
		int nFoeRoll = nFoeAB + nFoed20;
		int nMyRoll = nAB + nd20;

		SendMessageToPC(oTarget, "<color=chocolate>Scorpion Parry: Opposed Attack Roll: " + GetName(oTarget) + " (" + IntToString(nFoeAB) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ") vs. " + GetName(oPC) + " (" + IntToString(nAB) + " + " + IntToString(nd20) + " = " + IntToString(nMyRoll) + ").</color>");

		if (nFoeRoll > nMyRoll)
		{
			FloatingTextStringOnCreature("<color=cyan>*Scorpion Parry!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);

			float fRange = CSLGetMeleeRange(oTarget);
			location lPC = GetLocation(oTarget);
			object oAlly;

			oAlly = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

			while (GetIsObjectValid(oAlly))
			{
				if ((oAlly != oPC) && (oAlly != oTarget) && (GetIsReactionTypeHostile(oAlly, oTarget)))
				{
					oFoe = oAlly;
					break;
				}
				else oFoe = OBJECT_INVALID;

				oAlly = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
			}

			if (GetIsObjectValid(oFoe))
			{
				effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
				SpawnBloodHit(oFoe, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, oPC);
			}
		}
		else 
		{
			FloatingTextStringOnCreature("<color=red>*Scorpion Parry Failed!*</color>", oTarget, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			oFoe = oTarget;
		}
	}
	else oFoe = oTarget;

	if ((nRedirect == 1) && (GetLocalInt(oTarget, "ShieldCounter") == 1))
	{
		object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
		int nShield = GetBaseItemType(oShield);

		if (nShield == BASE_ITEM_SMALLSHIELD || nShield == BASE_ITEM_TOWERSHIELD || nShield == BASE_ITEM_LARGESHIELD)
		{
			nRedirect = 0;

			SetLocalInt(oTarget, "ShieldCounter", 2);
			CSLPlayCustomAnimation_Void(oTarget, "shieldbash", 0);
			SendMessageToPC(oTarget, "<color=chocolate>Shield Counter Attack Roll:</color>");

			int nBash = TOBStrikeAttackRoll(oShield, oPC, -2, TRUE, 0, oTarget);

			if (nBash > 0)
			{
				effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);
				oFoe = OBJECT_INVALID;

				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
				FloatingTextStringOnCreature("<color=cyan>*Shield Counter!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);
			}
			else 
			{
				FloatingTextStringOnCreature("*Shield Counter Failed!*", oTarget, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
				oFoe = oTarget;
			}
		}
		else oFoe = oTarget;
	}
	else oFoe = oTarget;

	if ((nRedirect == 1) && (GetLocalInt(oTarget, "FoolsStrike") == 1) && (!GetWeaponRanged(oWeapon)))
	{
		nRedirect = 0;
		SetLocalInt(oTarget, "FoolsStrike", 2); // For this maneuver roles are reversed.  The oTarget should be a PC and oPC should be an enemey.

		object oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
		int nFoeAB = CSLGetMaxAB(oTarget, oFoeWeapon, oPC);
		int nAB = CSLGetMaxAB(oPC, oWeapon, oFoe);
		int nd20 = d20(1);
		int nFoed20 = d20(1);
		int nFoeRoll = nFoeAB + nFoed20;
		int nMyRoll = nAB + nd20;

		SendMessageToPC(oTarget, "<color=chocolate>Fool's Strike: Opposed Attack Roll: " + GetName(oTarget) + " (" + IntToString(nFoeAB) + " + " + IntToString(nFoed20) + " = " + IntToString(nFoeRoll) + ") vs. " + GetName(oPC) + " (" + IntToString(nAB) + " + " + IntToString(nd20) + " = " + IntToString(nMyRoll) + ").</color>");

		if (nFoeRoll > nMyRoll)
		{
			FloatingTextStringOnCreature("<color=cyan>*FoolsStrike!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);

			oFoe = OBJECT_SELF;
			effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
			SpawnBloodHit(oFoe, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, oPC);
		}
		else 
		{
			FloatingTextStringOnCreature("<color=red>*Fool's Strike Failed!*</color>", oTarget, TRUE, 3.0f, COLOR_RED, COLOR_RED_DARK);
			oFoe = oTarget;
		}
	}
	else oFoe = oTarget;

	if ((nRedirect == 1) && (nHit == 0) && (GetLocalInt(oPC, "AttackRollConcealed") > 0) && (GetLocalInt(oPC, "Ghostly") == 0))
	{
		nRedirect = 0;
		SetLocalInt(oTarget, "Ghostly", 0); // For this maneuver roles are reversed.  The oTarget should be a PC and oPC should be an enemey.

		FloatingTextStringOnCreature("<color=cyan>*Ghostly Defense!*</color>", oTarget, TRUE, 3.0f, COLOR_CYAN, COLOR_BLUE_DARK);

		float fRange = CSLGetMeleeRange(oTarget);
		location lPC = GetLocation(oTarget);
		object oAlly;

		oAlly = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		while (GetIsObjectValid(oAlly))
		{
			if ((oAlly != oPC) && (oAlly != oTarget) && (GetIsReactionTypeHostile(oAlly, oTarget)))
			{
				oFoe = oAlly;
				break;
			}
			else oFoe = OBJECT_INVALID;

			oAlly = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}

		if (GetIsObjectValid(oFoe))
		{
			effect eRedirect = EffectVisualEffect(VFX_TOB_REDIRECT);
			nHit = TOBStrikeAttackRoll(oWeapon, oAlly);

			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRedirect, oTarget, 1.0f);
			SpawnBloodHit(oFoe, OVERRIDE_ATTACK_RESULT_CRITICAL_HIT, oPC);
		}
	}
	else oFoe = oTarget;

	if (oFoe == OBJECT_INVALID)
	{
		return; // Cancel everything else if the target has been negated.
	}

	CSLWatchOpponent(oFoe, oPC);
	DelayCommand(0.5f, CSLWatchOpponent(oFoe, oPC));
	DelayCommand(1.5f, CSLWatchOpponent(oFoe, oPC));
	DelayCommand(2.5f, CSLWatchOpponent(oFoe, oPC));
	DelayCommand(3.5f, CSLWatchOpponent(oFoe, oPC));
	DelayCommand(4.5f, CSLWatchOpponent(oFoe, oPC));
	DelayCommand(5.5f, CSLWatchOpponent(oFoe, oPC));

	if (nHit == 0) // Things that happen on a miss.
	{
		if (GetLocalInt(oFoe, "PearlofBlackDoubtActive") == 1)
		{
			int nPearlAC = GetLocalInt(oFoe, "PearlAC");
			SetLocalInt(oFoe, "PearlAC", nPearlAC + 2);
		}
	}

	if (nHit > 0) //Things that happen on hits.
	{
		if (bSupressDamage == FALSE)
		{
			effect eBase = TOBBaseStrikeDamage(oWeapon, nHit, oFoe, nMisc, bIgnoreResistances, nMult);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eBase, oFoe);
		}

		effect ePerm = TOBStrikePermanentEffects(oWeapon, nHit, oFoe);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePerm, oFoe);

		if (GetLocalInt(oPC, "SneakHasHit") == 1)
		{
			FloatingTextStringOnCreature("<color=red>*Sneak Attack!*</color>", oPC, TRUE, 3.0f, COLOR_GREY, COLOR_BLACK);
		}

		if ((GetHasFeat(2054, oPC)) || (GetHasFeat(2053, oPC)) || (GetHasFeat(2052, oPC))) //Bleeding Wound 1-3
		{
			effect eBlW = CSLIBBleedingWound();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlW, oFoe, 18.0f);
		}

		if ((GetWeaponRanged(oWeapon)) && (GetHasFeat(FEAT_TW_MISSILE_VOLLEYS, oPC)))
		{
			effect eVolley = CSLMissileVolley(oPC, oWeapon);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVolley, oFoe, 6.0f);
		}

		// Needs Testing Still!
		if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_REGENERATION_VAMPIRIC))
		{
			itemproperty iVamp = GetFirstItemProperty(oWeapon);
			
			while (GetIsItemPropertyValid(iVamp))
			{
				if (GetItemPropertyType(iVamp) == ITEM_PROPERTY_REGENERATION_VAMPIRIC)
				{
					int nVamp = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iVamp));
					effect eVamp = TOBManeuverHealing(oPC, nVamp);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVamp, oPC);
					break;
				}
				iVamp = GetNextItemProperty(oWeapon);
			}
		}

		if (GetWeaponRanged(oWeapon))
		{
			int nBaseType = GetBaseItemType(oWeapon);

			object oAmmo;
			if (nBaseType == BASE_ITEM_LIGHTCROSSBOW || nBaseType == BASE_ITEM_HEAVYCROSSBOW)
				oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS);
			if (nBaseType == BASE_ITEM_LONGBOW || nBaseType == BASE_ITEM_SHORTBOW)
				oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS);
			if (nBaseType == BASE_ITEM_SLING)
				oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS);						

			itemproperty iVamp = GetFirstItemProperty(oAmmo);
			while (GetIsItemPropertyValid(iVamp))
			{
				if (GetItemPropertyType(iVamp)== ITEM_PROPERTY_REGENERATION_VAMPIRIC)
				{
					int nVamp = TOBGetDamageByDamageBonus(GetItemPropertyCostTableValue(iVamp));
					effect eVamp = TOBManeuverHealing(oPC, nVamp);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVamp, oPC);
					break;
				}
				iVamp = GetNextItemProperty(oWeapon);
			}
		}

		//Maneuver Specific
		TOBDoMartialSpirit();
		TOBDoCoveringStrike(oFoe);
		TOBDoAuraOfTriumph(oFoe);

		if (GetLocalInt(oPC, "Girallon") == 1)
		{
			int g, nGirHits;
			object oTest;

			g = 1;
			oTest = GetLocalObject(oPC, "GirallonFoe" + IntToString(g));

			if (GetIsObjectValid(oTest))
			{
				while (GetIsObjectValid(oTest))
				{
					if (oTest == oFoe)
					{
						nGirHits = GetLocalInt(oPC, "GirallonHits" + IntToString(g));

						SetLocalObject(oPC, "GirallonFoe" + IntToString(g), oTest);
						SetLocalInt(oPC, "GirallonHits" + IntToString(g), nGirHits + 1);
						break;
					}

					g++;
					oTest = GetLocalObject(oPC, "GirallonFoe" +IntToString(g));
				}
			}
			else // Should be only for the first object found.
			{
				nGirHits = GetLocalInt(oPC, "GirallonHits" + IntToString(g));

				SetLocalObject(oPC, "GirallonFoe" + IntToString(g), oTest);
				SetLocalInt(oPC, "GirallonHits" + IntToString(g), nGirHits + 1);
			}
				
		}
	}

	if (nHit == 2) //Things that happen on Critical Hits.
	{
		TOBDoBloodInTheWater();
	}

	// Things that happen if you hit or miss.

	if ((GetLocalInt(oFoe, "BafflingDefenseActive") == 1) && HkSwiftActionIsActive(oFoe) == FALSE )
	{
		SetLocalInt(oFoe, "BafflingDefenseActive", 2);
	}

	if ((GetLocalInt(oFoe, "LeapingFlameActive") == 1) && HkSwiftActionIsActive(oFoe) == FALSE)
	{
		SetLocalInt(oFoe, "LeapingFlameActive", 2);
		SetLocalObject(oFoe, "LeapingFlameTarget", oPC);
	}

	if ((GetLocalInt(oFoe, "ShieldBlockActive") == 1) && HkSwiftActionIsActive(oFoe) == FALSE)
	{
		SetLocalInt(oFoe, "ShieldBlockActive", 2);
	}

	if ((GetLocalInt(oFoe, "WallofBladesActive") == 1) && HkSwiftActionIsActive(oFoe) == FALSE )
	{
		SetLocalInt(oFoe, "WallofBladesActive", 2);
	}

	if ((GetLocalInt(oFoe, "ZephyrDanceActive") == 1) && HkSwiftActionIsActive(oFoe) == FALSE)
	{
		SetLocalInt(oFoe, "ZephyrDanceActive", 2);
	}
}


// Runs the attack rolls and damage for the maneuver Desert Tempest while the 
// PC is moving by his opponents.  This maneuver has a cap of ten opponents.
void TOBDoDesertTempest(object oPC, object oToB, float fRange)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDoDesertTempest Start", GetFirstPC() ); }
	
	if (GetLocalInt(oPC, "DesertTempestActive") == 1)
	{
		location lPC = GetLocation(oPC);
		object oCreature;
		float fDist;
		int n;

		oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);
		n = 1;

		while (GetIsObjectValid(oCreature))
		{
			fDist = GetDistanceBetween(oPC, oCreature);

			if ((oCreature != oPC) && (GetLocalInt(oCreature, "DesertTempestHit") == 0) && (GetIsReactionTypeHostile(oCreature, oPC)) && (fDist <= fRange))
			{
				SetLocalInt(oCreature, "DesertTempestHit", 1);
				AssignCommand(oCreature, DelayCommand(6.0f, DeleteLocalInt(oCreature, "DesertTempestHit")));
				SetLocalObject(oToB, "DesertTempestFoe" + IntToString(n), oCreature);
				n++;

				if (n > 10)
				{
					break;
				}
			}
			oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}

		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		object oFoe1 = GetLocalObject(oToB, "DesertTempestFoe1");

		if (GetIsObjectValid(oFoe1))
		{
			int nHit1 = TOBStrikeAttackRoll(oWeapon, oFoe1);

			CSLStrikeAttackSound(oWeapon, oFoe1, nHit1, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit1, oFoe1);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe1"));
		}

		object oFoe2 = GetLocalObject(oToB, "DesertTempestFoe2");

		if (GetIsObjectValid(oFoe2))
		{
			int nHit2 = TOBStrikeAttackRoll(oWeapon, oFoe2);

			CSLStrikeAttackSound(oWeapon, oFoe2, nHit2, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit2, oFoe2);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe2"));
		}

		object oFoe3 = GetLocalObject(oToB, "DesertTempestFoe3");

		if (GetIsObjectValid(oFoe3))
		{
			int nHit3 = TOBStrikeAttackRoll(oWeapon, oFoe3);

			CSLStrikeAttackSound(oWeapon, oFoe3, nHit3, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit3, oFoe3);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe3"));
		}

		object oFoe4 = GetLocalObject(oToB, "DesertTempestFoe4");

		if (GetIsObjectValid(oFoe4))
		{
			int nHit4 = TOBStrikeAttackRoll(oWeapon, oFoe4);

			CSLStrikeAttackSound(oWeapon, oFoe4, nHit4, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit4, oFoe4);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe4"));
		}

		object oFoe5 = GetLocalObject(oToB, "DesertTempestFoe5");

		if (GetIsObjectValid(oFoe5))
		{
			int nHit5 = TOBStrikeAttackRoll(oWeapon, oFoe5);

			CSLStrikeAttackSound(oWeapon, oFoe5, nHit5, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit5, oFoe5);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe5"));
		}

		object oFoe6 = GetLocalObject(oToB, "DesertTempestFoe6");

		if (GetIsObjectValid(oFoe6))
		{
			int nHit6 = TOBStrikeAttackRoll(oWeapon, oFoe6);

			CSLStrikeAttackSound(oWeapon, oFoe6, nHit6, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit6, oFoe6);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe6"));
		}

		object oFoe7 = GetLocalObject(oToB, "DesertTempestFoe7");

		if (GetIsObjectValid(oFoe7))
		{
			int nHit7 = TOBStrikeAttackRoll(oWeapon, oFoe7);

			CSLStrikeAttackSound(oWeapon, oFoe7, nHit7, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit7, oFoe7);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe7"));
		}

		object oFoe8 = GetLocalObject(oToB, "DesertTempestFoe8");

		if (GetIsObjectValid(oFoe8))
		{
			int nHit8 = TOBStrikeAttackRoll(oWeapon, oFoe8);

			CSLStrikeAttackSound(oWeapon, oFoe8, nHit8, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit8, oFoe8);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe8"));
		}

		object oFoe9 = GetLocalObject(oToB, "DesertTempestFoe9");

		if (GetIsObjectValid(oFoe9))
		{
			int nHit9 = TOBStrikeAttackRoll(oWeapon, oFoe9);

			CSLStrikeAttackSound(oWeapon, oFoe9, nHit9, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit9, oFoe9);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe9"));
		}

		object oFoe10 = GetLocalObject(oToB, "DesertTempestFoe10");

		if (GetIsObjectValid(oFoe10))
		{
			int nHit10 = TOBStrikeAttackRoll(oWeapon, oFoe10);

			CSLStrikeAttackSound(oWeapon, oFoe10, nHit10, 0.0f);
			TOBStrikeWeaponDamage(oWeapon, nHit10, oFoe10);
			DelayCommand(0.1f, DeleteLocalObject(oToB, "DesertTempestFoe10"));
		}

		DelayCommand(1.0f, TOBDoDesertTempest(oPC, oToB, fRange));
	}
	else
	{
		DeleteLocalObject(oToB, "DesertTempestFoe1");
		DeleteLocalObject(oToB, "DesertTempestFoe2");
		DeleteLocalObject(oToB, "DesertTempestFoe3");
		DeleteLocalObject(oToB, "DesertTempestFoe4");
		DeleteLocalObject(oToB, "DesertTempestFoe5");
		DeleteLocalObject(oToB, "DesertTempestFoe6");
		DeleteLocalObject(oToB, "DesertTempestFoe7");
		DeleteLocalObject(oToB, "DesertTempestFoe8");
		DeleteLocalObject(oToB, "DesertTempestFoe9");
		DeleteLocalObject(oToB, "DesertTempestFoe10");
	}
}

// Determines if a Crusader has readied all aviablable maneuvers.
// Returns TRUE if the crusader has.
int TOBCheckRedCrusader(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCheckRedCrusader Start", GetFirstPC() ); }
	
	int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal_CR");
	int n, nRed, nReturn;
	string sRed;

	n = 1;
	nRed = 0;

	while (n < 18)
	{
		sRed = "RedBox" + IntToString(n) + "_CR";

		if (GetLocalInt(oToB, sRed) == 1)
		{
			nRed += 1;
		}

		if (nRed == nReadiedTotal)
		{
			nReturn = TRUE;
			break;
		}

		n++;
	}

	return nReturn;
}

//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 5/31/2009							//
//	Title: bot9s_inc_levelup				//
//	Description: Levelup functions for the	//
//	Book of the Nine Swords classes.		//
//////////////////////////////////////////////



// Functions

// Returns the maximum Maneuver level the PC can learn.
// -nLevelCap: The maximum martial adept level that we're allowed to check for.
int TOBGetInitiatorLevelup(object oPC, int nClass, int nLevelCap = 0)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetInitiatorLevelup Start", GetFirstPC() ); }
	
	int nMartialAdept;
	int nNonMartial;
	int nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
	int nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);

	if (nClass == CLASS_TYPE_CRUSADER)
	{
		nMartialAdept = nCrusader;
	}
	else if (nClass == CLASS_TYPE_SAINT)
	{
		nMartialAdept = nSaint;
	}
	else if (nClass == CLASS_TYPE_SWORDSAGE)
	{
		nMartialAdept = nSwordsage;
	}
	else if (nClass == CLASS_TYPE_WARBLADE)
	{
		nMartialAdept = nWarblade;
	}
	else // For Martial Study/Stance.
	{
		if (nCrusader > nSaint || nCrusader > nSwordsage || nCrusader > nWarblade)
		{
			nMartialAdept = nCrusader;
		}
		else if (nSaint > nCrusader || nSaint > nSwordsage || nSaint > nWarblade)
		{
			nMartialAdept = nSaint;
		}
		else if (nSwordsage > nCrusader || nSwordsage > nSaint || nSwordsage > nWarblade)
		{
			nMartialAdept = nSwordsage;
		}
		else if (nWarblade > nCrusader || nWarblade > nSaint || nWarblade > nSwordsage)
		{
			nMartialAdept = nWarblade;
		}
		else if (nCrusader > 0 || nSaint > 0 || nSwordsage > 0 || nWarblade > 0)
		{
			if (nCrusader == nSaint || nCrusader == nSwordsage || nCrusader == nWarblade)
			{
				nMartialAdept = nCrusader; // Fyi, purely an alphabetical preferance.
			}
			else if (nSaint == nSwordsage || nSaint == nWarblade)
			{
				nMartialAdept = nSaint;
			}
			else if (nSwordsage == nWarblade)
			{
				nMartialAdept = nSwordsage;
			}
			else nMartialAdept = 0;
		}
		else nMartialAdept = 0;
	}

	nNonMartial = ((GetHitDice(oPC) - nMartialAdept) / 2);

	if (nLevelCap > 0)
	{
		if (nMartialAdept > nLevelCap)
		{
			nMartialAdept = nLevelCap;
		}

		if (GetHitDice(oPC) > nLevelCap)
		{
			nNonMartial = ((nLevelCap - nMartialAdept) / 2);
		}
	}

	int nInitiator = nMartialAdept + nNonMartial;
	int nReturn;

	switch (nInitiator)
	{
		case 0: nReturn = 1;	break; // Minimum Initiator level.
		case 1:	nReturn = 1;	break;
		case 2:	nReturn = 1;	break;
		case 3:	nReturn = 2;	break;
		case 4:	nReturn = 2;	break;
		case 5:	nReturn = 3;	break;
		case 6:	nReturn = 3;	break;
		case 7:	nReturn = 4;	break;
		case 8:	nReturn = 4;	break;
		case 9:	nReturn = 5;	break;
		case 10:nReturn = 5;	break;
		case 11:nReturn = 6;	break;
		case 12:nReturn = 6;	break;
		case 13:nReturn = 7;	break;
		case 14:nReturn = 7;	break;
		case 15:nReturn = 8;	break;
		case 16:nReturn = 8;	break;
		default:nReturn = 9;	break;
	}

	return nReturn;
}


// Checks if the maneuver is a stance or not.
// Returns TRUE if it is.
int TOBGetIsStance(int nManeuver)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsStance Start", GetFirstPC() ); }
	
	int nReturn;

	switch (nManeuver)
	{
		case STANCE_ABSOLUTE_STEEL:					nReturn = TRUE;	break;
		case STANCE_ASSNS_STANCE:					nReturn = TRUE;	break;
		case STANCE_AURA_OF_CHAOS:					nReturn = TRUE;	break;
		case STANCE_AURA_OF_PERFECT_ORDER:			nReturn = TRUE;	break;
		case STANCE_AURA_OF_TRIUMPH:				nReturn = TRUE;	break;
		case STANCE_AURA_OF_TYRANNY:				nReturn = TRUE;	break;
		case STANCE_BALANCE_SKY:					nReturn = TRUE;	break;
		case STANCE_BLOOD_IN_THE_WATER:				nReturn = TRUE;	break;
		case STANCE_BOLSTERING_VOICE:				nReturn = TRUE;	break;
		case STANCE_CHILD_SHADOW:					nReturn = TRUE;	break;
		case STANCE_CRUSHING_WEIGHT_OF_THE_MOUNTAIN:nReturn = TRUE;	break;
		case STANCE_DANCE_SPIDER:					nReturn = TRUE;	break;
		case STANCE_DANCING_BLADE_FORM:				nReturn = TRUE;	break;
		case STANCE_DANCING_MOTH:					nReturn = TRUE;	break;
		case STANCE_FLMSBLSS:						nReturn = TRUE;	break;
		case STANCE_FRYASLT:						nReturn = TRUE;	break;
		case STANCE_GHOSTLY_DEFENSE:				nReturn = TRUE;	break;
		case STANCE_GIANT_KILLING_STYLE:			nReturn = TRUE;	break;
		case STANCE_GIANTS_STANCE:					nReturn = TRUE;	break;
		case STANCE_HEARING_THE_AIR:				nReturn = TRUE;	break;
		case STANCE_HOLOSTCLK:						nReturn = TRUE;	break;
		case STANCE_HUNTERS_SENSE:					nReturn = TRUE;	break;
		case STANCE_IMMORTAL_FORTITUDE:				nReturn = TRUE;	break;
		case STANCE_IRON_GUARDS_GLARE:				nReturn = TRUE;	break;
		case STANCE_ISLAND_OF_BLADES:				nReturn = TRUE;	break;
		case STANCE_LEADING_THE_CHARGE:				nReturn = TRUE;	break;
		case STANCE_LEAPING_DRAGON_STANCE:			nReturn = TRUE;	break;
		case STANCE_MARTIAL_SPIRIT:					nReturn = TRUE;	break;
		case STANCE_OF_ALACRITY:					nReturn = TRUE;	break;
		case STANCE_OF_CLARITY:						nReturn = TRUE;	break;
		case STANCE_PEARL_OF_BLACK_DOUBT:			nReturn = TRUE;	break;
		case STANCE_PRESS_THE_ADVANTAGE:			nReturn = TRUE;	break;
		case STANCE_PREY_ON_THE_WEAK:				nReturn = TRUE;	break;
		case STANCE_PUNISHING_STANCE:				nReturn = TRUE;	break;
		case STANCE_ROOTS_OF_THE_MOUNTAIN:			nReturn = TRUE;	break;
		case STANCE_RSNPHEONIX:						nReturn = TRUE;	break;
		case STANCE_SHIFTING_DEFENSE:				nReturn = TRUE;	break;
		case STANCE_STEP_OF_THE_WIND:				nReturn = TRUE;	break;
		case STANCE_STONEFOOT_STANCE:				nReturn = TRUE;	break;
		case STANCE_STRENGTH_OF_STONE:				nReturn = TRUE;	break;
		case STANCE_SUPREME_BLADE_PARRY:			nReturn = TRUE;	break;
		case STANCE_SWARM_TACTICS:					nReturn = TRUE;	break;
		case STANCE_TACTICS_OF_THE_WOLF:			nReturn = TRUE;	break;
		case STANCE_THICKET_OF_BLADES:				nReturn = TRUE;	break;
		case STANCE_WOLF_PACK_TACTICS:				nReturn = TRUE;	break;
		case STANCE_WOLVERINE_STANCE:				nReturn = TRUE;	break;
		default:									nReturn = FALSE;break;
	}
	return nReturn;
}

// Flags a Known Maneuver as unknown.
void TOBUnlearnManeuver(int nManeuver)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBUnlearnManeuver Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);

	if (GetLocalInt(oToB, "KnownManeuver1") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver1", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver2") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver2", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver3") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver3", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver4") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver4", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver5") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver5", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver6") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver6", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver7") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver7", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver8") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver8", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver9") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver9", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver10") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver10", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver11") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver11", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver12") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver12", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver13") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver13", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver14") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver14", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver15") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver15", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver16") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver16", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver17") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver17", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver18") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver18", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver19") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver19", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver20") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver20", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver21") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver21", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver22") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver22", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver23") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver23", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver24") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver24", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver25") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver25", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver26") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver26", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver27") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver27", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver28") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver28", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver29") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver29", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver30") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver30", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver31") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver31", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver32") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver32", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver33") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver33", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver34") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver34", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver35") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver35", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver36") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver36", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver37") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver37", 0);
	}
	else if (GetLocalInt(oToB, "KnownManeuver38") == nManeuver)
	{
		SetLocalInt(oToB, "KnownManeuver38", 0);
	}
}


// Creates a list of the PC's Known Maneuvers.
void TOBGenerateKnownManeuvers(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGenerateKnownManeuvers Start", GetFirstPC() ); }
	
	string sScreen = "SCREEN_LEVELUP_MANEUVERS";
	string sList = "RETRAIN_MANEUVER_LIST";
	string sPane = "MANEUVERPANE_PROTO";
	string sText, sTextures, sVari, sTga, sName;
	object oManeuver;
	int nManeuver, nClass, nIsStance, nLevel;
	int i;

	oManeuver = GetFirstItemInInventory(oToB);

	while (GetIsObjectValid(oManeuver))
	{
		nManeuver = GetLocalInt(oManeuver, "2da");
		nClass = GetLocalInt(oManeuver, "Class");
		nIsStance = TOBGetManeuversDataIsStance(nManeuver);
		nLevel = TOBGetManeuversDataLevel(nManeuver);

		if (( GetLocalInt(oToB, "LevelupRetrain") > 0) && (nIsStance == 0) && (nClass != 255) && (nLevel != 0) && (nManeuver != 0))
		{
			sTga = TOBGetManeuversDataIcon(nManeuver);
			sName = TOBGetManeuversDataName(nManeuver);
			sTextures = "MANEUVER_IMAGE=" + sTga + ".tga";
			sText = "MANEUVER_TEXT=" + sName;
			sVari = "7=" + IntToString(nManeuver);

			AddListBoxRow(oPC, sScreen, sList, sPane + IntToString(nManeuver), sText, sTextures, sVari, "");
		}

		oManeuver = GetNextItemInInventory(oToB);
	}

	SetLocalInt(oToB, "GUIOpeningSafe", 1);
	DelayCommand(6.0f, DeleteLocalInt(oToB, "GUIOpeningSafe"));
}



// Checks to see if the PC already knows this maneuver.
// -nManeuver: 2da reference number of the maneuver we're checking.
// This data is stored on the placeholder item.
// Returns TRUE if the PC knows the maneuver.
int TOBCheckIsManeuverKnown(int nManeuver)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCheckIsManeuverKnown Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);

	if (GetLocalInt(oToB, "KnownManeuver1") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver2") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver3") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver4") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver5") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver6") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver7") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver8") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver9") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver10") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver11") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver12") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver13") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver14") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver15") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver16") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver17") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver18") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver19") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver20") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver21") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver22") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver23") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver24") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver25") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver26") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver27") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver28") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver29") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver30") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver31") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver32") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver33") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver34") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver35") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver36") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver37") == nManeuver)
	{
		return TRUE;
	}
	else if (GetLocalInt(oToB, "KnownManeuver38") == nManeuver)
	{
		return TRUE;
	}
	else return FALSE;
}

// Adds a Listbox to the maneuver selection screen.
// -nManeuver: Current number of the maneuver's listboxe, added to the maneuver selection screen.
void TOBAddManeuver(object oPC, int nManeuver)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBAddManeuver Start", GetFirstPC() ); }
	
	if (nManeuver == 0)
	{
		return; //Sanity Check.
	}

	string sName = TOBGetManeuversDataName(nManeuver);
	string sScreen = "SCREEN_LEVELUP_MANEUVERS";
	string sList = "AVAILABLE_MANEUVER_LIST";
	string sPane = "MANEUVERPANE_PROTO";
	string sTga = TOBGetManeuversDataIcon(nManeuver);
	string sTextures = "MANEUVER_IMAGE=" + sTga + ".tga";
	string sText = "MANEUVER_TEXT=" + sName;
	string sVari = "7=" + IntToString(nManeuver);

	AddListBoxRow(oPC, sScreen, sList, sPane + IntToString(nManeuver), sText, sTextures, sVari, "");
}


// Filters which maneuvers can be displayed and adds them.  Returns the value of the last maneuver checked.
// -nLevel: Initiator level of the maneuvers to display.
// -nClass: Determines which maneuvers are availible to this class.
// -nInitLevel: Maximum initiator level allowed to generate maneuvers for.
int TOBGenerateManeuvers(object oPC, object oToB, int nLevel, int nClass, int n, int nFinish, int nInitLevel)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGenerateManeuvers Start", GetFirstPC() ); }
	
	if ((nLevel != 0) && (nLevel > nInitLevel)) //Don't run it if we don't need to.
	{
		return nFinish;
	}

	int nDW = GetLocalInt(oToB, "DWTotal");
	int nDS = GetLocalInt(oToB, "DSTotal");
	int nDM = GetLocalInt(oToB, "DMTotal");
	int nIH = GetLocalInt(oToB, "IHTotal");
	int nSS = GetLocalInt(oToB, "SSTotal");
	int nSH = GetLocalInt(oToB, "SHTotal");
	int nSD = GetLocalInt(oToB, "SDTotal");
	int nTC = GetLocalInt(oToB, "TCTotal");
	int nWR = GetLocalInt(oToB, "WRTotal");
	int nRetrain = GetLocalInt(oToB, "RetrainManeuver");
	int nIsStance, nDiscipline, nLevelOf, nMastery, nMasteryOf, nSpecial, nValid;
	string sScript, sAdded;
	object oManeuver;

	while (n <= nFinish)
	{
		nValid = 0;
		sScript = TOBGetManeuversDataScript(n);
		sAdded = GetLocalString(oToB, "AddedManeuver" + IntToString(n));
		oManeuver = GetObjectByTag(GetFirstName(oPC) + sScript);

		if ((nRetrain == n) && (StringToInt(sAdded) != n))
		{
			nValid = 1;
		}
		else if ((!GetIsObjectValid(oManeuver)) && (StringToInt(sAdded) != n))
		{
			nValid = 1;
		}

		if (nValid == 1) //Filter what we know or are learning.
		{
			if (nClass == CLASS_TYPE_CRUSADER)
			{
				nDiscipline = TOBGetManeuversDataDiscipline(n);
	
				if (nDiscipline == DEVOTED_SPIRIT || nDiscipline == STONE_DRAGON || nDiscipline == WHITE_RAVEN)
				{
					switch (nDiscipline)
					{
						case DEVOTED_SPIRIT:	nMasteryOf = nDS;	break;
						case STONE_DRAGON:		nMasteryOf = nSD;	break;
						case WHITE_RAVEN:		nMasteryOf = nWR;	break;
					}
	
					nLevelOf = TOBGetManeuversDataLevel(n);
					nIsStance = TOBGetManeuversDataIsStance(n);
					nMastery = TOBGetManeuversDataMastery(n);
	
					if (nLevel == 0) //Stances
					{
						nMastery = TOBGetManeuversDataMastery(n);
	
						if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery))
						{
							TOBAddManeuver(oPC, n);
						}
					}
					else if (nLevel == nLevelOf)
					{
						//Special Cases
						if ((n == STRIKE_DOOM_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_LAW_BEARER) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_RADIANT_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_TIDE_OF_CHAOS) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
						{
							nSpecial = 1;
						}
	
						if ((nMasteryOf >= nMastery) && (nIsStance != 1) && (nSpecial == 0))
						{
							TOBAddManeuver(oPC, n);
						}
					}
				}
			}
			else if (nClass == CLASS_TYPE_SAINT)
			{
				nDiscipline = TOBGetManeuversDataDiscipline(n);
	
				if (nDiscipline == DEVOTED_SPIRIT || nDiscipline == SHADOW_HAND)
				{
					switch (nDiscipline)
					{
						case DEVOTED_SPIRIT:	nMasteryOf = nDS;	break;
						case SHADOW_HAND:		nMasteryOf = nSH;	break;
					}
	
					nLevelOf = TOBGetManeuversDataLevel(n);
					nIsStance = TOBGetManeuversDataIsStance(n);
					nMastery = TOBGetManeuversDataMastery(n);
	
					if (nLevel == 0) //Stances
					{
						nMastery = TOBGetManeuversDataMastery(n);
	
						if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery))
						{
							TOBAddManeuver(oPC, n);
						}
					}
					else if (nLevel == nLevelOf)
					{
						//Special Cases
						if ((n == STRIKE_DOOM_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_LAW_BEARER) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_RADIANT_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD))
						{
							nSpecial = 1;
						}
						else if ((n == STRIKE_TIDE_OF_CHAOS) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
						{
							nSpecial = 1;
						}
	
						if ((nMasteryOf >= nMastery) && (nIsStance != 1) && (nSpecial == 0))
						{
							TOBAddManeuver(oPC, n);
						}
					}
				}
			}
			else if (nClass == CLASS_TYPE_SWORDSAGE)
			{
				nDiscipline = TOBGetManeuversDataDiscipline(n);
	
				if (nDiscipline == DESERT_WIND || nDiscipline == DIAMOND_MIND || nDiscipline == SETTING_SUN
				|| nDiscipline == SHADOW_HAND || nDiscipline == STONE_DRAGON || nDiscipline == TIGER_CLAW)
				{
					switch (nDiscipline)
					{
						case DESERT_WIND:		nMasteryOf = nDW;	break;
						case DIAMOND_MIND:		nMasteryOf = nDM;	break;
						case SETTING_SUN:		nMasteryOf = nSS;	break;
						case SHADOW_HAND:		nMasteryOf = nSH;	break;
						case STONE_DRAGON:		nMasteryOf = nSD;	break;
						case TIGER_CLAW:		nMasteryOf = nTC;	break;
					}
	
					nLevelOf = TOBGetManeuversDataLevel(n);
					nIsStance = TOBGetManeuversDataIsStance(n);
					nMastery = TOBGetManeuversDataMastery(n);
	
					if (nLevel == 0) //Stances
					{
						// Special Cases
						if ((n == STANCE_HUNTERS_SENSE) && (GetHasFeat(FEAT_SCENT, oPC)))
						{
							nSpecial = 1;
						}
						else if ((n == STANCE_HEARING_THE_AIR) && (GetHasFeat(FEAT_KEEN_SENSE, oPC)))
						{
							nSpecial = 1;
						}

						nMastery = TOBGetManeuversDataMastery(n);
	
						if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery) && (nSpecial == 0))
						{
							TOBAddManeuver(oPC, n);
						}
					}
					else if (nLevel == nLevelOf)
					{
						if ((nMasteryOf >= nMastery) && (nIsStance != 1))
						{
							TOBAddManeuver(oPC, n);
						}
					}
				}
			}
			else if (nClass == CLASS_TYPE_WARBLADE)
			{
				nDiscipline = TOBGetManeuversDataDiscipline( n);
	
				if (nDiscipline == DIAMOND_MIND || nDiscipline == IRON_HEART || nDiscipline == STONE_DRAGON
				|| nDiscipline == TIGER_CLAW || nDiscipline == WHITE_RAVEN)
				{
					switch (nDiscipline)
					{
						case DIAMOND_MIND:		nMasteryOf = nDM;	break;
						case IRON_HEART:		nMasteryOf = nIH;	break;
						case STONE_DRAGON:		nMasteryOf = nSD;	break;
						case TIGER_CLAW:		nMasteryOf = nTC;	break;
						case WHITE_RAVEN:		nMasteryOf = nWR;	break;
					}
	
					nLevelOf = TOBGetManeuversDataLevel(n);
					nIsStance = TOBGetManeuversDataIsStance(n);
					nMastery = TOBGetManeuversDataMastery(n);
	
					if (nLevel == 0) //Stances
					{
						// Special Cases
						if ((n == STANCE_HUNTERS_SENSE) && (GetHasFeat(FEAT_SCENT, oPC)))
						{
							nSpecial = 1;
						}
						else if ((n == STANCE_HEARING_THE_AIR) && (GetHasFeat(FEAT_KEEN_SENSE, oPC)))
						{
							nSpecial = 1;
						}

						nMastery = TOBGetManeuversDataMastery(n);
	
						if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery) && (nSpecial == 0))
						{
							TOBAddManeuver(oPC, n);
						}
					}
					else if (nLevel == nLevelOf)
					{
						if ((nMasteryOf >= nMastery) && (nIsStance != 1))
						{
							TOBAddManeuver(oPC, n);
						}
					}
				}
			}
			else // Martial Stance/Study
			{
				nDiscipline = TOBGetManeuversDataDiscipline(n);
	
				switch (nDiscipline)
				{
					case DESERT_WIND:		nMasteryOf = nDW;	break;
					case DEVOTED_SPIRIT:	nMasteryOf = nDS;	break;
					case DIAMOND_MIND:		nMasteryOf = nDM;	break;
					case IRON_HEART:		nMasteryOf = nIH;	break;
					case SETTING_SUN:		nMasteryOf = nIH;	break;
					case SHADOW_HAND:		nMasteryOf = nIH;	break;
					case STONE_DRAGON:		nMasteryOf = nIH;	break;
					case TIGER_CLAW:		nMasteryOf = nTC;	break;
					case WHITE_RAVEN:		nMasteryOf = nWR;	break;
				}
	
				nLevelOf = TOBGetManeuversDataLevel(n);
				nIsStance = TOBGetManeuversDataIsStance(n);
				nMastery = TOBGetManeuversDataMastery(n);
	
				if (nLevel == 0) //Stances
				{
					if (nMasteryOf == 0)
					{
						nMasteryOf = 1; // Martial Study requires the player to know at least one maneuver of the discipline.
					}
	
					// Special Cases
					if ((n == STANCE_HUNTERS_SENSE) && (GetHasFeat(FEAT_SCENT, oPC)))
					{
						nSpecial = 1;
					}
					else if ((n == STANCE_HEARING_THE_AIR) && (GetHasFeat(FEAT_KEEN_SENSE, oPC)))
					{
						nSpecial = 1;
					}

					nMastery = TOBGetManeuversDataMastery(n);
	
					if ((nIsStance == 1) && (nLevelOf <= nInitLevel) && (nMasteryOf >= nMastery) && (nSpecial == 0))
					{
						TOBAddManeuver(oPC, n);
					}
				}
				else if (nLevel == nLevelOf)
				{
					//Special Cases
					if ((n == STRIKE_DOOM_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL))
					{
						nSpecial = 1;
					}
					else if ((n == STRIKE_LAW_BEARER) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL))
					{
						nSpecial = 1;
					}
					else if ((n == STRIKE_RADIANT_CHARGE) && (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD))
					{
						nSpecial = 1;
					}
					else if ((n == STRIKE_TIDE_OF_CHAOS) && (GetAlignmentLawChaos(oPC) != ALIGNMENT_CHAOTIC))
					{
						nSpecial = 1;
					}

					if ((nMasteryOf >= nMastery) && (nIsStance != 1) && (nSpecial == 0))
					{
						TOBAddManeuver(oPC, n);
					}
				}
			}
		}

		n++;
	}

	return n;
}





// Displays the maneuvers the PC can learn for the class they are leveling in.
// All stances are under level 0.
// -nLevel: Initiator level of the maneuvers to display.
// -nClass: Determines which maneuvers are availible to this class.
// -nInitLevel: Maximum initiator level allowed to generate maneuvers for.
void TOBDisplayManeuversByClass(object oPC, object oToB, int nStart, int nFinish, int nLevel, int nClass, int nInitLevel)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDisplayManeuversByClass Start", GetFirstPC() ); }
	
	int nLimit = GetNum2DARows("maneuvers");
	int i = TOBGenerateManeuvers(oPC, oToB, nLevel, nClass, nStart, nFinish, nInitLevel);

	if (i < nLimit) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nFinish + 50 > nLimit)
		{
			nFinish = nLimit;
		}
		else nFinish = nFinish + 50;

		DelayCommand(0.01f, TOBDisplayManeuversByClass(oPC, oToB, i, nFinish, nLevel, nClass, nInitLevel));
	}
}


//////////////////////////////////////////////
//	Author: Drammel                         //
//	Date: 2/19/2009                         //
//	Title: bot9s_inc_maneuvers              //
//	Description: Scripts that are used by   //
//	most maneuvers.                         //
//////////////////////////////////////////////




// Returns the Intiator Level of oPC.
// -oPC: Target of the function.
int TOBGetInitiatorLevel(object oPC)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetInitiatorLevel Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	string sData = GetLocalString(oToB, "BlackBox");
	string sClass = GetStringRight(sData, 3);

	int nMartialAdept;
	int nCrusader = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	int nSaint = GetLevelByClass(CLASS_TYPE_SAINT, oPC);
	int nSwordsage = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);
	int nWarblade = GetLevelByClass(CLASS_TYPE_WARBLADE, oPC);

	if (sClass == "_CR")
	{
		nMartialAdept = nCrusader;
	}
	else if (sClass == "_SA")
	{
		nMartialAdept = nSaint;
	}
	else if (sClass == "_SS")
	{
		nMartialAdept = nSwordsage;
	}
	else if (sClass == "_WB")
	{
		nMartialAdept = nWarblade;
	}
	else // For Martial Study or for when this function is not called from a maneuver.
	{
		if (nCrusader > nSaint || nCrusader > nSwordsage || nCrusader > nWarblade)
		{
			nMartialAdept = nCrusader;
		}
		else if (nSaint > nCrusader || nSaint > nSwordsage || nSaint > nWarblade)
		{
			nMartialAdept = nSaint;
		}
		else if (nSwordsage > nCrusader || nSwordsage > nSaint || nSwordsage > nWarblade)
		{
			nMartialAdept = nSwordsage;
		}
		else if (nWarblade > nCrusader || nWarblade > nSaint || nWarblade > nSwordsage)
		{
			nMartialAdept = nWarblade;
		}
		else if (nCrusader > 0 || nSaint > 0 || nSwordsage > 0 || nWarblade > 0)
		{
			if (nCrusader == nSaint || nCrusader == nSwordsage || nCrusader == nWarblade)
			{
				nMartialAdept = nCrusader; // Fyi, purely an alphabetical preferance.
			}
			else if (nSaint == nSwordsage || nSaint == nWarblade)
			{
				nMartialAdept = nSaint;
			}
			else if (nSwordsage == nWarblade)
			{
				nMartialAdept = nSwordsage;
			}
			else nMartialAdept = 0;
		}
		else nMartialAdept = 0;
	}

	int nNonMartial = ((GetHitDice(oPC) - nMartialAdept) / 2);
	int nReturn = nMartialAdept + nNonMartial;

	if (nReturn < 1)
	{
		nReturn = 1;
	}

	return nReturn;
}


// Returns the value of a maneuver's DC, following the lines that declare what
// type of strike has been activated.  Used so that we're not 'counting feats'
// every other line in a maneuver.
// -nAbilityMod: The stat modifier for the maneuver.
// -nLevelMod: The modifier based on the PC's level that applies to the maneuver.
// Sometimes it will be 1/2 level of a specific level, sometimes not.
// -nBase: Usually a DC will be 10 + an ability modifier + 1/2 level, but I've
// added the option to edit these just in case.
// -nMisc: Any special modifiers, specific to the maneuver.
int TOBGetManeuverDC(int nAbilityMod, int nLevelMod, int nBase = 10, int nMisc = 0)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetManeuverDC Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);

	int nFeat;
	
	if (GetLocalInt(oToB, "DesertWindStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_DW))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "DiamondMindStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_DM))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "DevotedSpiritStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_DS))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "IronHeartStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_IH))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "SettingSunStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_SS))
		{
			nFeat += 1;
		}
		
		if (GetLocalInt(oToB, "FallingSun") == 1)
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "ShadowHandStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_DW))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "StoneDragonStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_SD))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "TigerClawStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_TC))
		{
			nFeat += 1;
		}
	}
	else if (GetLocalInt(oToB, "WhiteRavenStrike") == 1)
	{
		if (GetHasFeat(FEAT_BLADE_MEDITATION_WR))
		{
			nFeat += 1;
		}
	}

	int nReturn = nAbilityMod + nLevelMod + nBase + nMisc + nFeat;
	return nReturn;
}

// Applies a +2 saving throw bonus for the Swordsage's discipline focus feats.
void TOBDefensiveStance(object oPC, object oToB, int nStance)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDefensiveStance Start", GetFirstPC() ); }
	
	int nCheck = GetLocalInt(oToB, "Stance");
	int nCheck2 = GetLocalInt(oToB, "Stance2");

	if (nCheck == nStance || nCheck2 == nStance) // The function is recursive, so these checks are needed to end the effect properly.
	{
		effect eDefensiveStance = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
		eDefensiveStance = SupernaturalEffect(eDefensiveStance);

		if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DW) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DW2))
		{
			if (nStance == STANCE_FRYASLT || nStance == STANCE_FLMSBLSS
			|| nStance == STANCE_HOLOSTCLK || nStance == STANCE_RSNPHEONIX)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, TOBDefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DM) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_DM2))
		{
			if (nStance == STANCE_HEARING_THE_AIR || nStance == STANCE_PEARL_OF_BLACK_DOUBT
			|| nStance == STANCE_OF_ALACRITY || nStance == STANCE_OF_CLARITY)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, TOBDefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SS) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SS2))
		{
			if (nStance == STANCE_GHOSTLY_DEFENSE || nStance == STANCE_GIANT_KILLING_STYLE
			|| nStance == STANCE_SHIFTING_DEFENSE || nStance == STANCE_STEP_OF_THE_WIND)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, TOBDefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SH) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SH2))
		{
			if (nStance == STANCE_ASSNS_STANCE || nStance == STANCE_BALANCE_SKY
			|| nStance == STANCE_CHILD_SHADOW || nStance == STANCE_DANCE_SPIDER
			|| nStance == STANCE_ISLAND_OF_BLADES || nStance == STANCE_DANCING_MOTH)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, TOBDefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SD) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_SD2))
		{
			if (nStance == STANCE_CRUSHING_WEIGHT_OF_THE_MOUNTAIN || nStance == STANCE_GIANTS_STANCE
			|| nStance == STANCE_ROOTS_OF_THE_MOUNTAIN || nStance == STANCE_STONEFOOT_STANCE
			|| nStance == STANCE_STRENGTH_OF_STONE)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, TOBDefensiveStance(oPC, oToB, nStance));
			}
		}
		else if (GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_TC) || GetHasFeat(FEAT_DISCIPLINE_FOCUS_DEFENSIVE_STANCE_TC2))
		{
			if (nStance == STANCE_BLOOD_IN_THE_WATER || nStance == STANCE_HUNTERS_SENSE
			|| nStance == STANCE_LEAPING_DRAGON_STANCE || nStance == STANCE_PREY_ON_THE_WEAK
			|| nStance == STANCE_WOLF_PACK_TACTICS || nStance == STANCE_WOLVERINE_STANCE)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefensiveStance, oPC, 6.0f);
				DelayCommand(6.0f, TOBDefensiveStance(oPC, oToB, nStance));
			}
		}
	}
}





// Checks oToB to see if the target of the maneuver is the PC or a party member.
// If so the script prevents the caller of the function from preforming a hostile act on the target.
// -sVarName: Name of the variable in oToB that stores the target of the script.
// -bSupressMessage: When set to true this will prevent a message from being sent to the player by
// this function.
int TOBNotMyFoe(object oPC, object oTarget, int bSupressMessage = FALSE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBNotMyFoe Start", GetFirstPC() ); }
	
	if (GetCurrentHitPoints(oTarget) < 1)
	{
		if (bSupressMessage == FALSE)
		{
			SendMessageToPC(oPC, "Your target has less than one hit point.");
		}

		return TRUE;
	}
	else if (oPC == oTarget)
	{
		if (bSupressMessage == FALSE)
		{
			SendMessageToPC(oPC, "You cannot target yourself with this ability.");
		}

		return TRUE;
	}
	else if (GetIsReactionTypeFriendly(oTarget, oPC))
	{
		if (bSupressMessage == FALSE)
		{
			SendMessageToPC(oPC, "You cannot use your ability on this target.");
		}

		return TRUE;
	}
	else if (GetIsReactionTypeNeutral(oTarget, oPC))
	{
		if (bSupressMessage == FALSE)
		{
			SendMessageToPC(oPC, "You cannot use your ability on this target.");
		}

		return TRUE;
	}
	else return FALSE;
}





// GetHasSpellEffect(iSpellId0, oTarget)

// Returns TRUE for weapons favored by the Desert Wind school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsDesertWindWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsDesertWindWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_DESERTWIND )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns TRUE for weapons favored by the Devoted Spirit school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsDevotedSpiritWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsDevotedSpiritWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_DEVOTEDSPIRIT )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns TRUE for weapons favored by the Diamond Mind school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsDiamondMindWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsDiamondMindWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_DIAMONDMIND )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns TRUE for weapons favored by the Iron Heart school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsIronHeartWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsIronHeartWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_IRONHEART )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns TRUE for weapons favored by the Setting Sun school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsSettingSunWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsSettingSunWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_SETTINGSUN )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns TRUE for weapons favored by the Shadow Hand school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsShadowHandWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsShadowHandWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_SHADOWHAND )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns TRUE for weapons favored by the Stone Dragon school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsStoneDragonWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsStoneDragonWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_STONEDRAGON )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns TRUE for weapons favored by the Tiger Claw school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsTigerClawWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsTigerClawWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_TIGERCLAW )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns TRUE for weapons favored by the White Raven school.
// -oWeapon: The weapon weilded by the caller of the function.
int TOBGetIsWhiteRavenWeapon(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsWhiteRavenWeapon Start", GetFirstPC() ); }
	
	if(GetIsObjectValid(oWeapon))
	{
		int iBaseItemType = GetBaseItemType(oWeapon);	
		if ( CSLGetBaseItemProps(iBaseItemType) & ITEM_ATTRIB_WHITERAVEN )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// Returns true if the PC is in a Shadow Hand stance and is Weilding a Shadow Hand weapon.
// -oWeapon: Left or right hand.
int TOBGetIsShadowBladeValid(object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetIsShadowBladeValid Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	int nStance = GetLocalInt(oToB, "Stance");
	int nStance2 = GetLocalInt(oToB, "Stance2");
	int nReturn = FALSE;
	
	if (TOBGetIsShadowHandWeapon(oWeapon) == TRUE)
	{
		switch (nStance)
		{
			case STANCE_ASSNS_STANCE:		nReturn = TRUE; break;
			case STANCE_BALANCE_SKY:		nReturn = TRUE; break;
			case STANCE_CHILD_SHADOW:		nReturn = TRUE; break;
			case STANCE_DANCE_SPIDER:		nReturn = TRUE; break;
			case STANCE_DANCING_MOTH:		nReturn = TRUE; break;
			case STANCE_ISLAND_OF_BLADES:	nReturn = TRUE; break;
			default: 						nReturn = FALSE; break;
		}
	}
	
	if ((nReturn == FALSE) && (TOBGetIsShadowHandWeapon(oWeapon) == TRUE))
	{
		switch (nStance2)
		{
			case STANCE_ASSNS_STANCE:		nReturn = TRUE; break;
			case STANCE_BALANCE_SKY:		nReturn = TRUE; break;
			case STANCE_CHILD_SHADOW:		nReturn = TRUE; break;
			case STANCE_DANCE_SPIDER:		nReturn = TRUE; break;
			case STANCE_DANCING_MOTH:		nReturn = TRUE; break;
			case STANCE_ISLAND_OF_BLADES:	nReturn = TRUE; break;
			default: 						nReturn = FALSE; break;
		}
	}
	return nReturn;
}


// Applies a knockback effect while wildshaped or raging.
// This feat is not used outside of Tiger Claw strikes.
void TOBTigerBlooded(object oPC, object oWeapon, object oTarget)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBTigerBlooded Start", GetFirstPC() ); }
	
	int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	int nMyDC = 10 + (GetHitDice(oPC) / 2) + nStrMod;
	int nMySize = GetCreatureSize(oPC);
	int nTargetSize = GetCreatureSize(oTarget);
	
	if (nMySize >= nTargetSize)
	{
		float fDistance = FeetToMeters(5.0f);

		if ((GetHasFeat(FEAT_BLADE_MEDITATION_TC, oPC)) && (TOBGetIsTigerClawWeapon(oWeapon)))
		{
			nMyDC += 1;
		}
		
		effect eEffect = GetFirstEffect(oPC);
		
		while(GetIsEffectValid(eEffect))
		{
			int nType = GetEffectType(eEffect);

			if (nType == EFFECT_TYPE_POLYMORPH)
			{
				if (HkSavingThrow(SAVING_THROW_FORT, oTarget, nMyDC) == 0)
				{
					CSLThrowTarget(oTarget, fDistance);
				}
			}
			else if (nType == EFFECT_TYPE_WILDSHAPE)
			{
				if (HkSavingThrow(SAVING_THROW_FORT, oTarget, nMyDC) == 0)
				{
					CSLThrowTarget(oTarget, fDistance);
				}
			}

			eEffect = GetNextEffect(oPC);
		}
		
		if (CSLGetIsRaging(oPC))
		{
			if (HkSavingThrow(SAVING_THROW_FORT, oTarget, nMyDC) == 0)
			{
				CSLThrowTarget(oTarget, fDistance);
			}
		}
	}
}

// Applies a stun effect to a Setting Sun maneuver when called.
effect TOBFallingSunAttack(object oFoe, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBFallingSunAttack Start", GetFirstPC() ); }
	
	int nStunDC = 11 + (GetHitDice(oPC) / 2) + GetAbilityModifier(ABILITY_WISDOM, oPC);
	int nSub = GetSubRace(oFoe);
	effect eStun;
	
	if (GetHasFeat(FEAT_BLADE_MEDITATION_SS, oPC))
	{
		nStunDC += 1;
	}
	
	DecrementRemainingFeatUses(oPC, FEAT_STUNNING_FIST);
	
	if (nSub == RACIAL_SUBTYPE_CONSTRUCT || nSub == RACIAL_SUBTYPE_INCORPOREAL 
	|| nSub == RACIAL_SUBTYPE_OOZE || nSub == RACIAL_SUBTYPE_PLANT || nSub == RACIAL_SUBTYPE_UNDEAD)
	{
		return eStun;
	}
	else if (GetIsImmune(oFoe, IMMUNITY_TYPE_SNEAK_ATTACK))
	{
		return eStun;
	}
	else if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) != OBJECT_INVALID)
	{
		return eStun;
	}
	else if (HkSavingThrow(SAVING_THROW_FORT, oFoe, nStunDC) == 0)
	{
		eStun = EffectStunned();
		eStun = ExtraordinaryEffect(eStun);
	}

	return eStun;
}







// Returns the appropriate trail effect for the properties of oWeapon.
// Also overrides item visuals in the event of a critical hit (nHit == 2).
// These effects do not stack, so if there is more than one elemental property
// on an item, the last property will be the trail effect for the strike.
// -fExtend: Amount of time to extend the effect by.  Standard is 1.33 seconds.
void TOBStrikeTrailEffect(object oWeapon, int nHit, float fExtend = 0.0f, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBStrikeTrailEffect Start", GetFirstPC() ); }
	
	if (!GetIsObjectValid(oWeapon)) //Unarmed effects.
	{
		object oArms = GetItemInSlot(INVENTORY_SLOT_ARMS);
		effect eReturn;
		effect eLeft;

		if (nHit == 2)
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_crit", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_crit", oPC);
		}
		else if (GetItemHasItemProperty(oArms, ITEM_PROPERTY_HOLY_AVENGER))
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);
		}
		else if (GetItemHasItemProperty(oArms, ITEM_PROPERTY_REGENERATION_VAMPIRIC))
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_neg", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_neg", oPC);
		}
		else if (GetItemHasItemProperty(oArms, ITEM_PROPERTY_DAMAGE_BONUS) || GetItemHasItemProperty(oArms, ITEM_PROPERTY_VISUALEFFECT))
		{
			itemproperty iArms;
			iArms = GetFirstItemProperty(oArms);

			while (GetIsItemPropertyValid(iArms))
			{
				if (GetItemPropertyType(iArms) == ITEM_PROPERTY_DAMAGE_BONUS)
				{	
					switch (GetItemPropertySubType(iArms))
					{
						case IP_CONST_DAMAGETYPE_ACID:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_acid", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_acid", oPC);	break;
						case IP_CONST_DAMAGETYPE_COLD:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_frost", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_frost", oPC);	break;
						case IP_CONST_DAMAGETYPE_DIVINE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case IP_CONST_DAMAGETYPE_ELECTRICAL:	eReturn = EffectNWN2SpecialEffectFile("rh_trail_elect", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_elect", oPC);	break;
						case IP_CONST_DAMAGETYPE_FIRE:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_fire", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_fire", oPC);	break;
						case IP_CONST_DAMAGETYPE_NEGATIVE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_neg", oPC);		eLeft = EffectNWN2SpecialEffectFile("lh_trail_neg", oPC);	break;
						case IP_CONST_DAMAGETYPE_POSITIVE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case IP_CONST_DAMAGETYPE_SONIC:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_sonic", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_sonic", oPC);	break;
					}
				}
				else if (GetItemPropertyType(iArms) == ITEM_PROPERTY_VISUALEFFECT)
				{	
					switch (GetItemPropertySubType(iArms))
					{
						case ITEM_VISUAL_ACID:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_acid", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_acid", oPC);	break;
						case ITEM_VISUAL_COLD:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_frost", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_frost", oPC);	break;
						case ITEM_VISUAL_HOLY:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case ITEM_VISUAL_ELECTRICAL:	eReturn = EffectNWN2SpecialEffectFile("rh_trail_elect", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_elect", oPC);	break;
						case ITEM_VISUAL_FIRE:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_fire", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_fire", oPC);	break;
						case ITEM_VISUAL_EVIL:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_neg", oPC);		eLeft = EffectNWN2SpecialEffectFile("lh_trail_neg", oPC);	break;
						case ITEM_VISUAL_SONIC:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_sonic", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_sonic", oPC);	break;
					}
				}
				iArms = GetNextItemProperty(oArms);
			}
		}
		else
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_standard", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_standard", oPC);
		}

		effect eVis;

		eVis = GetFirstEffect(oPC);

		if (nHit == 2)
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_crit", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_crit", oPC);
		}
		else if (GetIsEffectValid(eVis))
		{
			while (GetIsEffectValid(eVis))
			{
				if (GetEffectType(eVis) == EFFECT_TYPE_DAMAGE_INCREASE)
				{	
					switch (GetEffectInteger(eVis, 1))  //DamageType
					{
						case DAMAGE_TYPE_ACID:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_acid", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_acid", oPC);	break;
						case DAMAGE_TYPE_COLD:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_frost", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_frost", oPC);	break;
						case DAMAGE_TYPE_DIVINE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case DAMAGE_TYPE_ELECTRICAL:	eReturn = EffectNWN2SpecialEffectFile("rh_trail_elect", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_elect", oPC);	break;
						case DAMAGE_TYPE_FIRE:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_fire", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_fire", oPC);	break;
						case DAMAGE_TYPE_NEGATIVE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_neg", oPC);		eLeft = EffectNWN2SpecialEffectFile("lh_trail_neg", oPC);	break;
						case DAMAGE_TYPE_POSITIVE:		eReturn = EffectNWN2SpecialEffectFile("rh_trail_holy", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_holy", oPC);	break;
						case DAMAGE_TYPE_SONIC:			eReturn = EffectNWN2SpecialEffectFile("rh_trail_sonic", oPC);	eLeft = EffectNWN2SpecialEffectFile("lh_trail_sonic", oPC);	break;
					}
				}
				eVis = GetNextEffect(oPC);
			}
		}
		else
		{
			eReturn = EffectNWN2SpecialEffectFile("rh_trail_standard", oPC);
			eLeft = EffectNWN2SpecialEffectFile("lh_trail_standard", oPC);
		}

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReturn, oPC, 0.3f);
		DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLeft, oPC, 0.3f)); //The second hand usually attacks a little after the first.
	}
	else
	{
		int nVis;

		if (nHit == 2)
		{
			nVis = DAMAGE_TYPE_MAGICAL; //Placeholder for crit visual.
		}
		else if (GetLocalInt(oPC, "BurningBrand") == 1)
		{
			nVis = DAMAGE_TYPE_FIRE;
		}
		else if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_HOLY_AVENGER))
		{
			nVis = DAMAGE_TYPE_DIVINE;
		}
		else if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_REGENERATION_VAMPIRIC))
		{
			nVis = DAMAGE_TYPE_NEGATIVE;
		}
		else if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_DAMAGE_BONUS) || GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_VISUALEFFECT))
		{
			itemproperty iWeapon;
			iWeapon = GetFirstItemProperty(oWeapon);
	
			while (GetIsItemPropertyValid(iWeapon))
			{
				if (GetItemPropertyType(iWeapon) == ITEM_PROPERTY_DAMAGE_BONUS)
				{	
					switch (GetItemPropertySubType(iWeapon))
					{
						case IP_CONST_DAMAGETYPE_ACID:			nVis = DAMAGE_TYPE_ACID;		break;
						case IP_CONST_DAMAGETYPE_COLD:			nVis = DAMAGE_TYPE_COLD;		break;
						case IP_CONST_DAMAGETYPE_DIVINE:		nVis = DAMAGE_TYPE_DIVINE;		break;
						case IP_CONST_DAMAGETYPE_ELECTRICAL:	nVis = DAMAGE_TYPE_ELECTRICAL;	break;
						case IP_CONST_DAMAGETYPE_FIRE:			nVis = DAMAGE_TYPE_FIRE;		break;
						case IP_CONST_DAMAGETYPE_NEGATIVE:		nVis = DAMAGE_TYPE_NEGATIVE;	break;
						case IP_CONST_DAMAGETYPE_POSITIVE:		nVis = DAMAGE_TYPE_DIVINE;		break;
						case IP_CONST_DAMAGETYPE_SONIC:			nVis = DAMAGE_TYPE_SONIC;		break;
					}
				}
				else if (GetItemPropertyType(iWeapon) == ITEM_PROPERTY_VISUALEFFECT)
				{	
					switch (GetItemPropertySubType(iWeapon))
					{
						case ITEM_VISUAL_ACID:			nVis = DAMAGE_TYPE_ACID;		break;
						case ITEM_VISUAL_COLD:			nVis = DAMAGE_TYPE_COLD;		break;
						case ITEM_VISUAL_HOLY:			nVis = DAMAGE_TYPE_DIVINE;		break;
						case ITEM_VISUAL_ELECTRICAL:	nVis = DAMAGE_TYPE_ELECTRICAL;	break;
						case ITEM_VISUAL_FIRE:			nVis = DAMAGE_TYPE_FIRE;		break;
						case ITEM_VISUAL_EVIL:			nVis = DAMAGE_TYPE_NEGATIVE;	break;
						case ITEM_VISUAL_SONIC:			nVis = DAMAGE_TYPE_SONIC;		break;
					}
				}
				iWeapon = GetNextItemProperty(oWeapon);
			}
		}
		else nVis = DAMAGE_TYPE_ALL; // Placeholder for normal trail effects.

		effect eElement;

		eElement = GetFirstEffect(oPC);

		if (nHit == 2)
		{
			nVis = DAMAGE_TYPE_MAGICAL; //Placeholder for crit visual.
		}
		else if (GetLocalInt(oPC, "BurningBrand") == 1)
		{
			nVis = DAMAGE_TYPE_FIRE;
		}
		else if (GetIsEffectValid(eElement))
		{
			while (GetIsEffectValid(eElement))
			{
				if (GetEffectType(eElement) == EFFECT_TYPE_DAMAGE_INCREASE)
				{	
					switch (GetEffectInteger(eElement, 1))  //DamageType
					{
						case DAMAGE_TYPE_ACID:			nVis = DAMAGE_TYPE_ACID;		break;
						case DAMAGE_TYPE_COLD:			nVis = DAMAGE_TYPE_COLD;		break;
						case DAMAGE_TYPE_DIVINE:		nVis = DAMAGE_TYPE_DIVINE;		break;
						case DAMAGE_TYPE_ELECTRICAL:	nVis = DAMAGE_TYPE_ELECTRICAL;	break;
						case DAMAGE_TYPE_FIRE:			nVis = DAMAGE_TYPE_FIRE;		break;
						case DAMAGE_TYPE_NEGATIVE:		nVis = DAMAGE_TYPE_NEGATIVE;	break;
						case DAMAGE_TYPE_POSITIVE:		nVis = DAMAGE_TYPE_DIVINE;		break;
						case DAMAGE_TYPE_SONIC:			nVis = DAMAGE_TYPE_SONIC;		break;
					}
				}
				eElement = GetNextEffect(oPC);
			}
		}
		else nVis = DAMAGE_TYPE_ALL; // Placeholder for normal trail effects.

		int nWeapon = GetBaseItemType(oWeapon);
		int nTrail;

		if (nWeapon == BASE_ITEM_SHORTSWORD || nWeapon == BASE_ITEM_SHORTSWORD_R
		|| nWeapon == BASE_ITEM_DAGGER || nWeapon == BASE_ITEM_DAGGER_R
		|| nWeapon == BASE_ITEM_HANDAXE || nWeapon == BASE_ITEM_HANDAXE_R || nWeapon == BASE_ITEM_KAMA_R
		|| nWeapon == BASE_ITEM_KAMA || nWeapon == BASE_ITEM_KUKRI || nWeapon == BASE_ITEM_KUKRI_R
		|| nWeapon == BASE_ITEM_SICKLE || nWeapon == BASE_ITEM_SICKLE_R || nWeapon == BASE_ITEM_LIGHTHAMMER_R
		|| nWeapon == BASE_ITEM_LIGHTHAMMER || nWeapon == BASE_ITEM_LIGHTFLAIL || nWeapon == BASE_ITEM_LIGHTFLAIL_R)
		{
			nTrail = TRAIL_TYPE_1HSS;
		}
		else if (nWeapon == BASE_ITEM_SCYTHE || nWeapon == BASE_ITEM_SCYTHE_R)
		{
			nTrail = TRAIL_TYPE_SCYTH;
		}
		else if (nWeapon == BASE_ITEM_WARMACE || nWeapon == BASE_ITEM_WARMACE_R
		|| nWeapon == BASE_ITEM_GREATCLUB || nWeapon == BASE_ITEM_GREATCLUB_R)
		{
			nTrail = TRAIL_TYPE_MACE;
		}
		else if (nWeapon == BASE_ITEM_BATTLEAXE || nWeapon == BASE_ITEM_BATTLEAXE_R
		|| nWeapon == BASE_ITEM_GREATAXE || nWeapon == BASE_ITEM_GREATAXE_R)
		{
			nTrail = TRAIL_TYPE_2AXE;
		}
		else if (nWeapon == BASE_ITEM_DWARVENWARAXE || nWeapon == BASE_ITEM_DWARVENWARAXE_R
		|| nWeapon == BASE_ITEM_FLAIL || nWeapon == BASE_ITEM_FLAIL_R 
		|| nWeapon == BASE_ITEM_WARHAMMER || nWeapon == BASE_ITEM_WARHAMMER_R)
		{
			nTrail = TRAIL_TYPE_1HMR;
		}
		else if (nWeapon == BASE_ITEM_SPEAR || nWeapon == BASE_ITEM_SPEAR_R
		|| nWeapon == BASE_ITEM_QUARTERSTAFF || nWeapon == BASE_ITEM_QUARTERSTAFF_R
		|| nWeapon == BASE_ITEM_MAGICSTAFF || nWeapon == BASE_ITEM_MAGICSTAFF_R
		|| nWeapon == BASE_ITEM_HALBERD || nWeapon == BASE_ITEM_HALBERD_R)
		{
			nTrail = TRAIL_TYPE_SPEAR;
		}
		else if (!GetWeaponRanged(oWeapon))
		{
			nTrail = TRAIL_TYPE_BLADE;
		}

		effect eVis;

		if (oWeapon == GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))
		{
			if (nTrail == TRAIL_TYPE_BLADE)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_BLADE_DEFAULT_LH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_BLADE_CRIT_LH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_BLADE_ACID_LH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_BLADE_ICE_LH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_BLADE_HOLY_LH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_BLADE_ELEC_LH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_BLADE_FIRE_LH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_BLADE_NEGA_LH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_BLADE_SONIC_LH);	break;
				}
			}
			else if (nTrail == TRAIL_TYPE_1HSS)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_1HSS_DEFAULT_LH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_1HSS_CRIT_LH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_1HSS_ACID_LH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_1HSS_ICE_LH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_1HSS_HOLY_LH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_1HSS_ELEC_LH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_1HSS_FIRE_LH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_1HSS_NEGA_LH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_1HSS_SONIC_LH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_1HMR)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_1HMR_DEFAULT_LH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_1HMR_CRIT_LH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_1HMR_ACID_LH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_1HMR_ICE_LH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_1HMR_HOLY_LH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_1HMR_ELEC_LH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_1HMR_FIRE_LH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_1HMR_NEGA_LH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_1HMR_SONIC_LH);		break;
				}
			}
		}
		else
		{
			if (nTrail == TRAIL_TYPE_BLADE)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_BLADE_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_BLADE_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_BLADE_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_BLADE_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_BLADE_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_BLADE_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_BLADE_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_BLADE_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_BLADE_SONIC_RH);	break;
				}
			}
			else if (nTrail == TRAIL_TYPE_1HSS)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_1HSS_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_1HSS_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_1HSS_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_1HSS_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_1HSS_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_1HSS_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_1HSS_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_1HSS_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_1HSS_SONIC_RH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_1HMR)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_1HMR_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_1HMR_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_1HMR_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_1HMR_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_1HMR_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_1HMR_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_1HMR_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_1HMR_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_1HMR_SONIC_RH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_SPEAR)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_SPEAR_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_SPEAR_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_SPEAR_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_SPEAR_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_SPEAR_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_SPEAR_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_SPEAR_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_SPEAR_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_SPEAR_SONIC_RH);	break;
				}
			}
			else if (nTrail == TRAIL_TYPE_2AXE)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_2AXE_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_2AXE_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_2AXE_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_2AXE_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_2AXE_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_2AXE_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_2AXE_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_2AXE_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_2AXE_SONIC_RH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_MACE)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_MACE_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_MACE_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_MACE_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_MACE_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_MACE_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_MACE_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_MACE_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_MACE_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_MACE_SONIC_RH);		break;
				}
			}
			else if (nTrail == TRAIL_TYPE_SCYTH)
			{
				switch (nVis)
				{
					case DAMAGE_TYPE_ALL:		eVis = EffectVisualEffect(TRAIL_SCYTH_DEFAULT_RH);	break;
					case DAMAGE_TYPE_MAGICAL:	eVis = EffectVisualEffect(TRAIL_SCYTH_CRIT_RH);		break;
					case DAMAGE_TYPE_ACID:		eVis = EffectVisualEffect(TRAIL_SCYTH_ACID_RH);		break;
					case DAMAGE_TYPE_COLD:		eVis = EffectVisualEffect(TRAIL_SCYTH_ICE_RH);		break;
					case DAMAGE_TYPE_DIVINE:	eVis = EffectVisualEffect(TRAIL_SCYTH_HOLY_RH);		break;
					case DAMAGE_TYPE_ELECTRICAL:eVis = EffectVisualEffect(TRAIL_SCYTH_ELEC_RH);		break;
					case DAMAGE_TYPE_FIRE:		eVis = EffectVisualEffect(TRAIL_SCYTH_FIRE_RH);		break;
					case DAMAGE_TYPE_NEGATIVE:	eVis = EffectVisualEffect(TRAIL_SCYTH_NEGA_RH);		break;
					case DAMAGE_TYPE_SONIC:		eVis = EffectVisualEffect(TRAIL_SCYTH_SONIC_RH);	break;
				}
			}
		}
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 1.33f + fExtend);
	}
}

// Routes specific instances of an effect to the type of weapon that the player
// has equipped.  Used to shape the effect to the weapon model to create custom
// pseudo-trail effects.
// -nManeuver: 2da reference of the strike that we want to produce the effect of.
// -oWeapon: Used to determine the weapon model shape of the effect.
void TOBApplyWeaponTypeVFX(int nManeuver, object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBApplyWeaponTypeVFX Start", GetFirstPC() ); }
	
	if (GetIsObjectValid(oWeapon))
	{
		int nWeapon = GetBaseItemType(oWeapon);
		int nTrail;

		if (nWeapon == BASE_ITEM_SHORTSWORD || nWeapon == BASE_ITEM_SHORTSWORD_R
		|| nWeapon == BASE_ITEM_DAGGER || nWeapon == BASE_ITEM_DAGGER_R
		|| nWeapon == BASE_ITEM_HANDAXE || nWeapon == BASE_ITEM_HANDAXE_R || nWeapon == BASE_ITEM_KAMA_R
		|| nWeapon == BASE_ITEM_KAMA || nWeapon == BASE_ITEM_KUKRI || nWeapon == BASE_ITEM_KUKRI_R
		|| nWeapon == BASE_ITEM_SICKLE || nWeapon == BASE_ITEM_SICKLE_R || nWeapon == BASE_ITEM_LIGHTHAMMER_R
		|| nWeapon == BASE_ITEM_LIGHTHAMMER || nWeapon == BASE_ITEM_LIGHTFLAIL || nWeapon == BASE_ITEM_LIGHTFLAIL_R)
		{
			nTrail = TRAIL_TYPE_1HSS;
		}
		else if (nWeapon == BASE_ITEM_SCYTHE || nWeapon == BASE_ITEM_SCYTHE_R)
		{
			nTrail = TRAIL_TYPE_SCYTH;
		}
		else if (nWeapon == BASE_ITEM_WARMACE || nWeapon == BASE_ITEM_WARMACE_R
		|| nWeapon == BASE_ITEM_GREATCLUB || nWeapon == BASE_ITEM_GREATCLUB_R)
		{
			nTrail = TRAIL_TYPE_MACE;
		}
		else if (nWeapon == BASE_ITEM_BATTLEAXE || nWeapon == BASE_ITEM_BATTLEAXE_R
		|| nWeapon == BASE_ITEM_GREATAXE || nWeapon == BASE_ITEM_GREATAXE_R)
		{
			nTrail = TRAIL_TYPE_2AXE;
		}
		else if (nWeapon == BASE_ITEM_DWARVENWARAXE || nWeapon == BASE_ITEM_DWARVENWARAXE_R
		|| nWeapon == BASE_ITEM_FLAIL || nWeapon == BASE_ITEM_FLAIL_R 
		|| nWeapon == BASE_ITEM_WARHAMMER || nWeapon == BASE_ITEM_WARHAMMER_R)
		{
			nTrail = TRAIL_TYPE_1HMR;
		}
		else if (nWeapon == BASE_ITEM_SPEAR || nWeapon == BASE_ITEM_SPEAR_R
		|| nWeapon == BASE_ITEM_QUARTERSTAFF || nWeapon == BASE_ITEM_QUARTERSTAFF_R
		|| nWeapon == BASE_ITEM_MAGICSTAFF || nWeapon == BASE_ITEM_MAGICSTAFF_R
		|| nWeapon == BASE_ITEM_HALBERD || nWeapon == BASE_ITEM_HALBERD_R)
		{
			nTrail = TRAIL_TYPE_SPEAR;
		}
		else if (!GetWeaponRanged(oWeapon))
		{
			nTrail = TRAIL_TYPE_BLADE;
		}

		effect eVis;

		if (nManeuver == STANCE_DANCING_BLADE_FORM)
		{
		}
	}
}




// Plays a basic attack animation with oWeapon.
// nHit: Used only in conjunction with bTrail to determine trail effects.
void TOBBasicAttackAnimation(object oWeapon, int nHit, int bTwoWeapon = FALSE, int bTrail = TRUE, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBBasicAttackAnimation Start", GetFirstPC() ); }
	
	object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	object oOffhand;

	if (bTrail == TRUE)
	{
		TOBStrikeTrailEffect(oWeapon, nHit);
	}

	if ((oLeft == OBJECT_INVALID) && (!GetIsPlayableRacialType(oPC)))
	{
		oOffhand = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
	}
	else oOffhand = oLeft;

	int nOffHand = GetBaseItemType(oOffhand);
	string sBow;
	string sAttack;

	if (GetWeaponRanged(oWeapon))
	{
		int nD2 = d2(1);

		switch (nD2)
		{
			case 1:	sBow = "*1attack01";	break;
			case 2:	sBow = "*1attack02";	break;
		}

		CSLPlayCustomAnimation_Void(oPC, sBow, 0);
	}
	else if ((bTwoWeapon == TRUE) && (GetIsObjectValid(oOffhand)) && (nOffHand != BASE_ITEM_LARGESHIELD) && (nOffHand != BASE_ITEM_SMALLSHIELD) && (nOffHand != BASE_ITEM_TOWERSHIELD))
	{
		int nD2 = d2(1);
		
		switch (nD2)
		{
			case 1:	sAttack = "*2attack01";	break;
			case 2:	sAttack = "*2attack02";	break;
		}

		CSLPlayCustomAnimation_Void(oPC, sAttack, 0);
	}
	else 
	{
		int nD4 = d4(1);

		switch (nD4)
		{
			case 1:	sAttack = "*1attack01";	break;
			case 2:	sAttack = "*1attack02";	break;
			case 3:	sAttack = "*1attack03";	break;
			case 4:	sAttack = "*1attack04";	break;
		}
		
		CSLPlayCustomAnimation_Void(oPC, sAttack, 0);
	}
}



// Manages a basic attack for the main override function.
// -oCreature: The creature calling the function.  Should not be a monster.
// -oTarget: The creature an attack is being made against.  Should be a monster.
// -nBonus: Misc modifier to the attack roll.
// -oWeapon: Weapon used to make this attack.
// -bWarcry: Determines if the person calling the function uses their attack grunt.
// -bAnimation: Set to TRUE to play an attack animation.
// -bSwing: Plays the sound of the weapon being swung when set to TRUE.
void TOBManageAttack(object oCreature, object oTarget, int nBonus, object oWeapon, int bWarcry = TRUE, int bAnimation = FALSE, int bSwing = FALSE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBManageAttack Start", GetFirstPC() ); }
	
	float fDist = GetDistanceBetween(oCreature, oTarget);
	float fRange = CSLGetMeleeRange(oCreature);

	if ((GetCurrentAction(oCreature) == ACTION_ATTACKOBJECT) && (fDist <= fRange) && (GetCurrentHitPoints(oTarget) > 0))
	{
		if ((oWeapon == OBJECT_INVALID) && (oWeapon != GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature)))
		{
			oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature); //Love for monks.
		}

		int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, nBonus);

		if (bAnimation == TRUE)
		{
			TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
		}

		if (bSwing == TRUE)
		{
			CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f, bWarcry);
		}

		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));

		if ((GetHasFeat(FEAT_CIRCLE_KICK, oCreature)) && (GetLocalInt(oCreature, "mimic_circle_k") == 0) && (nHit > 0))
		{
			if ((oWeapon == OBJECT_INVALID) || (oWeapon == GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature)))
			{
				SetLocalInt(oCreature, "mimic_circle_k", 1);// One per round.
				DelayCommand(6.0f, SetLocalInt(oCreature, "mimic_circle_k", 0));

				location lCreature = GetLocation(oCreature);
				object oCircle;

				oCircle = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lCreature);
	
				while (GetIsObjectValid(oCircle))
				{
					if ((oCircle != oTarget) && (GetIsReactionTypeHostile(oCircle, oCreature)))
					{
						int nCircle = TOBStrikeAttackRoll(oWeapon, oCircle);

						DelayCommand(0.7f, TOBStrikeWeaponDamage(oWeapon, nCircle, oCircle));
						DelayCommand(0.7f, CSLPlayCustomAnimation_Void(oCreature, "*kickcircle", 0));
						break;
					}

					oCircle = GetNextObjectInShape(SHAPE_SPHERE, fRange, lCreature);
				}
			}
		}
	}
	else if ((GetIsInCombat(oCreature)) && (GetCurrentHitPoints(oTarget) > 0))
	{
		DelayCommand(0.01f, TOBManageAttack(oCreature, oTarget, nBonus, oWeapon, bWarcry, bAnimation, bSwing));
	}
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// Removes the override flags and variables for the combat overrides.
// -nType: Which kind of override we're clearing, if not all of them.
// 0 = all, 1 = Armor Class, 2 = d20 roll, 3 = Critical Confirmation Roll,
// 4 = Attack Bonus, 5 = Critical Range, 6 = Critical Confirmation Bonus,
// 7 = Hit Result, 8 = Flank.
void TOBRemoveAttackRollOverride(object oTarget, int nType)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRemoveAttackRollOverride Start", GetFirstPC() ); }
	
	if (nType == 0 || nType == 1)
	{
		DeleteLocalInt(oTarget, "OverrideTouchAC");
		DeleteLocalInt(oTarget, "OverrideFlatFootedAC");
		DeleteLocalInt(oTarget, "OverrideAC");
	}

	if (nType == 0 || nType == 2)
	{
		DeleteLocalInt(oTarget, "OverrideD20");
		DeleteLocalInt(oTarget, "D20OverrideNum");
	}

	if (nType == 0 || nType == 3)
	{
		DeleteLocalInt(oTarget, "OverrideCritConfirm");
		DeleteLocalInt(oTarget, "CCOverrideNum");
	}

	if (nType == 0 || nType == 4)
	{
		DeleteLocalInt(oTarget, "OverrideAttackBonus");
		DeleteLocalInt(oTarget, "ABOverrideNum");
	}

	if (nType == 0 || nType == 5)
	{
		DeleteLocalInt(oTarget, "CSLOverrideCritRange");
		DeleteLocalInt(oTarget, "CROverrideNum");
	}

	if (nType == 0 || nType == 6)
	{
		DeleteLocalInt(oTarget, "OverrideCritConfirmBonus");
		DeleteLocalInt(oTarget, "CCBOverrideNum");
	}

	if (nType == 0 || nType == 7)
	{
		DeleteLocalInt(oTarget, "OverrideHit");
		DeleteLocalInt(oTarget, "HitOverrideNum");
	}

	if (nType == 0 || nType == 8)
	{
		DeleteLocalInt(oTarget, "OverrideFlank");
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Sets a bonus to hit for attacks of opportunity made while
// TOBManageCombatOverrides is active.
// -int nBonus: The bonus to the attack roll.
void TOBOverrideAoOHitBonus(object oTarget, int nBonus)
{
	SetLocalInt(oTarget, "OverrideAoOHitBonus", nBonus);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Sets a bonus to damage for attacks of opportunity made while
// TOBManageCombatOverrides is active.
// -int nBonus: The bonus to damage.
void TOBOverrideAoODamageBonus(object oTarget, int nBonus)
{
	SetLocalInt(oTarget, "OverrideAoODamageBonus", nBonus);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// Flags oTarget as qualifying for a flank.
void TOBOverrideFlank(object oTarget)
{
	SetLocalInt(oTarget, "OverrideFlank", 1);
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// Uses the function ClearCombatOverrides when the person using the function
// is not currently engaged in a conversation.  If they are, this function will
// repeat itself until the person is out of a conversation.  This has been
// implemented to prevent issues with cutscenes.
void TOBProtectedClearCombatOverrides(object oCreature)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBProtectedClearCombatOverrides Start", GetFirstPC() ); }
	
	DeleteLocalInt(oCreature, "bot9s_overridestate");
	DeleteLocalInt(oCreature, "bot9s_AoO_overridestate");
	DeleteLocalInt(oCreature, "Halt_AoO_override_loc");
	DeleteLocalObject(oCreature, "LastFoe");

	if ((!IsInConversation(oCreature)) && (GetNumCutsceneActionsPending() == 0))
	{
		ClearCombatOverrides(oCreature);
	}
	else DelayCommand(0.1f, TOBProtectedClearCombatOverrides(oCreature));
}



// Sets the location of oFoe once a second for the attacks of opportunity override.
void TOBManageAoOLocations(object oCreature, object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBManageAoOLocations Start", GetFirstPC() ); }
	
	location lCreature = GetLocation(oCreature);
	int nHalt = GetLocalInt(oCreature, "Halt_AoO_override_loc");

	if ((nHalt == 0) && (GetLocalInt(oCreature, "bot9s_overridestate") == 1) && (!GetWeaponRanged(oWeapon)) && (lCreature == (GetLocalLocation(oCreature, "bot9s_pc_pos_per_sec"))) && (!GetStealthMode(oCreature)))
	{
		float fReach = CSLGetMeleeRange(oCreature);
		object oFoe;
		location lFoe;

		if ((GetLocalInt(oCreature, "DancingBladeForm") == 1) && (GetLocalInt(oCreature, "BurningBrand") != 1))
		{
			fReach -= FeetToMeters(5.0f); // This stance doesn't apply its reach to AoO.
		}

		oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fReach, lCreature, TRUE);

		while (GetIsObjectValid(oFoe))
		{
			if (GetIsReactionTypeHostile(oFoe, oCreature))
			{
				lFoe = GetLocation(oFoe);
				SetLocalLocation(oFoe, "bot9s_override_AoO_loc", lFoe);
			}

			oFoe = GetNextObjectInShape(SHAPE_SPHERE, fReach, lCreature, TRUE);
		}

		DelayCommand(1.0f, TOBManageAoOLocations(oCreature, oWeapon));
	}
	else DeleteLocalInt(oCreature, "Halt_AoO_override_loc");
}

// Simulates attacks of opportunity while TOBManageCombatOverrides is running.
void TOBManageAttacksOfOpportunity(object oCreature, object oWeapon)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBManageAttacksOfOpportunity Start", GetFirstPC() ); }
	
	location lCreature = GetLocation(oCreature);

	if ((GetLocalInt(oCreature, "bot9s_overridestate") == 1) && (!GetWeaponRanged(oWeapon)) && (lCreature == (GetLocalLocation(oCreature, "bot9s_pc_pos_per_sec"))) && (!GetStealthMode(oCreature)))
	{
		SetLocalInt(oCreature, "bot9s_AoO_overridestate", 1);

		float fReach = CSLGetMeleeRange(oCreature);
		object oFoe;
		location lOld;

		if ((GetLocalInt(oCreature, "DancingBladeForm") == 1) && (GetLocalInt(oCreature, "BurningBrand") != 1))
		{
			fReach -= FeetToMeters(5.0f); // This stance doesn't apply its reach to AoO.
		}

		oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fReach, lCreature, TRUE);

		while (GetIsObjectValid(oFoe))
		{
			if (GetIsReactionTypeHostile(oFoe, oCreature))
			{
				if ((GetCurrentAction(oFoe) == ACTION_MOVETOPOINT) || ((GetCurrentAction(oFoe) == ACTION_ATTACKOBJECT) && (GetAttackTarget(oFoe) != oCreature)))
				{
					lOld = GetLocalLocation(oFoe, "bot9s_override_AoO_loc");

					float fFoe = GetDistanceBetween(oFoe, oCreature);
					float fOld = GetDistanceBetweenLocations(lCreature, lOld);

					if ((fOld <= fReach) && (fFoe > fReach))
					{
						int nBonusHit = GetLocalInt(oCreature, "OverrideAoOHitBonus");
						int nBonusDamage = GetLocalInt(oCreature, "OverrideAoODamageBonus");
						int nHit = TOBStrikeAttackRoll(oWeapon, oFoe, nBonusHit, TRUE);

						TOBStrikeWeaponDamage(oWeapon, nHit, oFoe, nBonusDamage);
						SetLocalInt(oCreature, "Halt_AoO_override_loc", 1);
						SetLocalInt(oCreature, "bot9s_AoO_overridestate", 0);
						return; //One per round.
					}
				}
				else if ((GetCurrentAction(oFoe) == ACTION_CASTSPELL) && (GetLocalInt(oFoe, "bot9s_maneuver_running") < 1))
				{
					int nBonusHit = GetLocalInt(oCreature, "OverrideAoOHitBonus");
					int nBonusDamage = GetLocalInt(oCreature, "OverrideAoODamageBonus");
					int nHit = TOBStrikeAttackRoll(oWeapon, oFoe, nBonusHit, TRUE);

					TOBStrikeWeaponDamage(oWeapon, nHit, oFoe, nBonusDamage);
					SetLocalInt(oCreature, "Halt_AoO_override_loc", 1);
					SetLocalInt(oCreature, "bot9s_AoO_overridestate", 0);
					return; //One per round.
				}
				else if (GetCurrentAction(oFoe) == ACTION_TAUNT)
				{
					int nBonusHit = GetLocalInt(oCreature, "OverrideAoOHitBonus");
					int nBonusDamage = GetLocalInt(oCreature, "OverrideAoODamageBonus");
					int nHit = TOBStrikeAttackRoll(oWeapon, oFoe, nBonusHit, TRUE);

					TOBStrikeWeaponDamage(oWeapon, nHit, oFoe, nBonusDamage);
					SetLocalInt(oCreature, "Halt_AoO_override_loc", 1);
					SetLocalInt(oCreature, "bot9s_AoO_overridestate", 0);
					return; //One per round.
				}
			}

			oFoe = GetNextObjectInShape(SHAPE_SPHERE, fReach, lCreature, TRUE);
		}

		DelayCommand(1.0f, TOBManageAttacksOfOpportunity(oCreature, oWeapon));
	}
	else DeleteLocalInt(oCreature, "bot9s_AoO_overridestate");
}




// Manages the use of the function SetCombatOverrides so that it can be used 
// by multiple maneuvers and allow the correct results of a combat round to be 
// determined with the combined data.  Precautions are taken so that this will 
// not interfere with a cutscene.  oCreature's default combat information is 
// normally used when -1 is entered as a parameter.
// -bModifyRounds: With a certain degree of timing, allows the PC to modify the
// results of indvidual attacks in the round.  Must be set to TRUE to fuction.
// -oCreature: The creature to set the overrides on.
// -oTarget: This should be a creature, door, or placeable. Setting this to
// OBJECT_INVALID will set oTarget to the current target oCreature has an action
// queued against.
// -nOnHandAttacks, nOffHandAttacks: Vaild for only 1-6.
// -nAttackResult: Uses the constants OVERRIDE_ATTACK_RESULT_* to set and attack's
// result as a Miss, Hit, Critical, Parry, or Defualt roll.
// -nMinDamage, nMaxDamage: Random damage range of the attack on a hit.
// -bSuppressBroadcastAOO: If TRUE then this creature can potentially cause an 
// attack of opportunity from nearby creatures. If FALSE, this will be supressed.
// -bSuppressMakeAOO: If TRUE then this creature will make attacks of opportunity
// when they are available. If FALSE, this will be supressed.  Testing shows that
// a PC's Plot flag must also be set to TRUE for this to work.
void TOBManageCombatOverrides(int bModifyRounds = FALSE, object oCreature = OBJECT_SELF, object oTarget = OBJECT_INVALID, int nOnHandAttacks = -1, int nOffHandAttacks = -1, int nAttackResult = OVERRIDE_ATTACK_RESULT_DEFAULT, int nMinDamage = -1, int nMaxDamage = -1, int bSuppressBroadcastAOO = TRUE, int bSuppressMakeAOO = TRUE)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBManageCombatOverrides Start", GetFirstPC() ); }
	
	object oFoe; // oTarget only returns a valid target after it has been passed into SetCombatOverrides.

	oFoe = GetAttackTarget(oCreature);

	if (GetIsObjectValid(oFoe)) // GetAttackTarget clears at the end of combat rounds.  This is to fill in the gaps.
	{
		SetLocalObject(oCreature, "LastFoe", oFoe);
	}
	else if ((!GetIsObjectValid(oFoe)) && (!GetIsObjectValid(GetLocalObject(oCreature, "LastFoe"))))
	{
		DelayCommand(0.01f, TOBManageCombatOverrides(TRUE));
		SetLocalInt(oCreature, "bot9s_overridestate", 2);
		return; //Should help pinpoint the beginning of the combat round a little more.
	}
	else oFoe = GetLocalObject(oCreature, "LastFoe");

	float fEight = FeetToMeters(8.0f); // Maximum range the engine allows a melee attack to be made at.
	float fMelee = CSLGetMeleeRange(oCreature);
	float fRange;

	if (fMelee > fEight)
	{
		fRange = fMelee;
	}
	else fRange = fEight;

	float fDist = GetDistanceBetween(oCreature, oFoe);
	int nRangeCheck;

	if (fDist <= fRange)
	{
		nRangeCheck = 1;
	}
	else if (CSLGetIsHoldingRangedWeapon(oCreature))
	{
		float fArrow = CSLGetWeaponRange(oCreature);

		if (fDist <= fArrow)
		{
			nRangeCheck = 1;
		}
		else nRangeCheck = 0;
	}
	else nRangeCheck = 0;

	if ((IsInConversation(oCreature)) || (GetNumCutsceneActionsPending() > 0))
	{
		return; // Prevent massive bugs if there's a cutscene in progress.
	}
	else if ((GetIsInCombat(oCreature)) && (GetCurrentAction(oCreature) == ACTION_ATTACKOBJECT) && (nRangeCheck == 1) && (GetCurrentHitPoints(oFoe) > 0))
	{
		SetLocalInt(oCreature, "bot9s_overridestate", 1);
		DelayCommand(5.99f, SetLocalInt(oCreature, "bot9s_overridestate", 0));
		DelayCommand(5.99f, DeleteLocalInt(oCreature, "OverrideAoOHitBonus"));
		DelayCommand(5.99f, DeleteLocalInt(oCreature, "OverrideAoODamageBonus"));

		if (bModifyRounds == TRUE)
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
				else oWeapon = OBJECT_INVALID;
			}
			else oWeapon = oRight;
		
			object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
			int nLeft = GetBaseItemType(oLeft);
			object oOffhand;
		
			if (oLeft == OBJECT_INVALID || nLeft == BASE_ITEM_LARGESHIELD || nLeft == BASE_ITEM_SMALLSHIELD || nLeft == BASE_ITEM_TOWERSHIELD)
			{
				object oLClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature);
			
				if (GetIsObjectValid(oLClaw))
				{
					oOffhand = oLClaw;
				}
				else oOffhand = OBJECT_INVALID;
			}
			else oOffhand = oLeft;

			if ((fDist <= fRange) || GetWeaponRanged(oWeapon))
			{
				int nRHandAttacks, nLHandAttacks, nPenalty;
				int nFlurry;

				nFlurry = 0;

				if ((GetActionMode(oCreature, ACTION_MODE_FLURRY_OF_BLOWS)) && (GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature)) == ARMOR_RANK_NONE))
				{
					object oRanged = GetItemInSlot(INVENTORY_SLOT_ARROWS, oCreature);
					int nType = GetBaseItemType(oWeapon);
					int nRangedType = GetBaseItemType(oRanged);
					int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oCreature) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oCreature);

					if (((!GetIsObjectValid(oWeapon)) && (!GetIsObjectValid(oOffhand))) || nType == BASE_ITEM_KAMA || nType == BASE_ITEM_QUARTERSTAFF || nRangedType == BASE_ITEM_SHURIKEN)
					{
						nFlurry += 1;

						if (nMonk > 10)
						{
							nFlurry += 1;
						}
					}

					if (nMonk < 5)
					{
						nPenalty -= 2;
					}
					else if (nMonk < 9)
					{
						nPenalty -= 1;
					}
				}

				int nSnap;

				nSnap = 0;

				object oToB = CSLGetDataStore(oCreature);

				if (GetLocalInt(oToB, "SnapKick") == 1)
				{
					nSnap = 1;
					nPenalty -= 2;
				}

				if (nOnHandAttacks == -1)
				{
					int nBAB = GetTRUEBaseAttackBonus(oCreature);

					switch (nBAB)
					{
						case 0:	nRHandAttacks = 1; break;
						case 1:	nRHandAttacks = 1; break;
						case 2:	nRHandAttacks = 1; break;
						case 3:	nRHandAttacks = 1; break;
						case 4:	nRHandAttacks = 1; break;
						case 5:	nRHandAttacks = 1; break;
						case 6:	nRHandAttacks = 2; break;
						case 7:	nRHandAttacks = 2; break;
						case 8:	nRHandAttacks = 2; break;
						case 9:	nRHandAttacks = 2; break;
						case 10:nRHandAttacks = 2; break;
						case 11:nRHandAttacks = 3; break;
						case 12:nRHandAttacks = 3; break;
						case 13:nRHandAttacks = 3; break;
						case 14:nRHandAttacks = 3; break;
						case 15:nRHandAttacks = 3; break;
						case 16:nRHandAttacks = 4; break;
						case 17:nRHandAttacks = 4; break;
						case 18:nRHandAttacks = 4; break;
						case 19:nRHandAttacks = 4; break;
						case 20:nRHandAttacks = 5; break;
						case 21:nRHandAttacks = 5; break;
						case 22:nRHandAttacks = 5; break;
						case 23:nRHandAttacks = 5; break;
						case 24:nRHandAttacks = 5; break;
						default:nRHandAttacks = 6; break;
					}
				}
				else nRHandAttacks = nOnHandAttacks;

				if ((nOffHandAttacks == -1) && (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature))))
				{
					if (GetHasFeat(FEAT_EPIC_PERFECT_TWO_WEAPON_FIGHTING, oCreature) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_PERFECT_TWO_WEAPON_FIGHTING, oCreature, TRUE))
					{
						int nBAB2 = GetTRUEBaseAttackBonus(oCreature);

						switch (nBAB2)
						{
							case 0:	nLHandAttacks = 1; break;
							case 1:	nLHandAttacks = 1; break;
							case 2:	nLHandAttacks = 1; break;
							case 3:	nLHandAttacks = 1; break;
							case 4:	nLHandAttacks = 1; break;
							case 5:	nLHandAttacks = 1; break;
							case 6:	nLHandAttacks = 2; break;
							case 7:	nLHandAttacks = 2; break;
							case 8:	nLHandAttacks = 2; break;
							case 9:	nLHandAttacks = 2; break;
							case 10:nLHandAttacks = 2; break;
							case 11:nLHandAttacks = 3; break;
							case 12:nLHandAttacks = 3; break;
							case 13:nLHandAttacks = 3; break;
							case 14:nLHandAttacks = 3; break;
							case 15:nLHandAttacks = 3; break;
							case 16:nLHandAttacks = 4; break;
							case 17:nLHandAttacks = 4; break;
							case 18:nLHandAttacks = 4; break;
							case 19:nLHandAttacks = 4; break;
							case 20:nLHandAttacks = 5; break;
							case 21:nLHandAttacks = 5; break;
							case 22:nLHandAttacks = 5; break;
							case 23:nLHandAttacks = 5; break;
							case 24:nLHandAttacks = 5; break;
							default:nLHandAttacks = 6; break;
						}
					}
					else if (GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oCreature) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_GREATER_TWO_WEAPON_FIGHTING, oCreature))
					{
						nLHandAttacks = 3;
					}
					else if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oCreature) || GetHasFeat(FEAT_COMBATSTYLE_RANGER_DUAL_WIELD_IMPROVED_TWO_WEAPON_FIGHTING, oCreature))
					{
						nLHandAttacks = 2;
					}
					else nLHandAttacks = 1;
				}
				else if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature)))
				{
					nLHandAttacks = 1;
				}
				else nLHandAttacks = 0;

				// Can't stop the first attack from going off, so we have to nullify it as best as is possible.
				SetCombatOverrides(oCreature, oTarget, -1, -1, OVERRIDE_ATTACK_RESULT_MISS, 0, 0, bSuppressBroadcastAOO, bSuppressMakeAOO, FALSE, FALSE);

				// After this point we're using the "Strike" brand functions to determine hits or misses.
				// Timing is crucial to land just the right modification to the correct attack.
				// These mods should be implemented via the "Override" brand of functions above.
				// For instance, to set an override on the second attack only, Delay the command by at most
				// 0.9f and use the Remove function after the roll function has been executed at about 1.1f.

				if (GetLocalInt(oCreature, "bot9s_AoO_overridestate") == 0)
				{
					TOBManageAoOLocations(oCreature, oWeapon);
					DelayCommand(0.5f, TOBManageAttacksOfOpportunity(oCreature, oWeapon));
				}

				TOBManageAttack(oCreature, oFoe, 0 + nPenalty, oWeapon, FALSE, FALSE, TRUE);

				if (nFlurry > 0)
				{
					TOBManageAttack(oCreature, oFoe, 0 + nPenalty, oWeapon, FALSE);
				}

				if (nFlurry > 1)
				{
					TOBManageAttack(oCreature, oFoe, 0 + nPenalty, oWeapon, FALSE);
				}

				if (nSnap > 0)
				{
					TOBManageAttack(oCreature, oFoe, 0 + nPenalty, oWeapon, FALSE);
				}

				if (nLHandAttacks > 0)
				{
					DelayCommand(0.1f, TOBManageAttack(oCreature, oFoe, 0 + nPenalty, oOffhand, FALSE, FALSE, TRUE));
				}

				if (nRHandAttacks > 1) // Two attacks.
				{
					DelayCommand(1.0f, TOBManageAttack(oCreature, oFoe, -5 + nPenalty, oWeapon, FALSE));
				}

				if (nLHandAttacks > 1)
				{
					DelayCommand(1.1f, TOBManageAttack(oCreature, oFoe, -5 + nPenalty, oOffhand, FALSE));
				}
	
				if (nRHandAttacks > 2) // Three attacks.
				{
					DelayCommand(2.0f, TOBManageAttack(oCreature, oFoe, -10 + nPenalty, oWeapon, TRUE, FALSE, TRUE));
				}

				if (nLHandAttacks > 2)
				{
					DelayCommand(2.1f, TOBManageAttack(oCreature, oFoe, -10 + nPenalty, oOffhand, FALSE, FALSE, TRUE));
				}

				if (nRHandAttacks > 3) // Four attacks.
				{
					DelayCommand(3.0f, TOBManageAttack(oCreature, oFoe, -15 + nPenalty, oWeapon, FALSE));
				}
	
				if (nLHandAttacks > 3)
				{
					DelayCommand(3.1f, TOBManageAttack(oCreature, oFoe, -15 + nPenalty, oOffhand, FALSE));
				}

				if (nRHandAttacks > 4) // Five attacks.
				{
					DelayCommand(4.0f, TOBManageAttack(oCreature, oFoe, -20 + nPenalty, oWeapon, FALSE));
				}

				if (nLHandAttacks > 4)
				{
					DelayCommand(4.1f, TOBManageAttack(oCreature, oFoe, -20 + nPenalty, oOffhand, FALSE));
				}
	
				if (nRHandAttacks > 5) // Six attacks.
				{
					DelayCommand(5.0f, TOBManageAttack(oCreature, oFoe, -25 + nPenalty, oWeapon, TRUE, FALSE, TRUE));
				}

				if (nLHandAttacks > 5)
				{
					DelayCommand(5.1f, TOBManageAttack(oCreature, oFoe, -25 + nPenalty, oOffhand, FALSE, FALSE, TRUE));
				}
			}
		}
	}
	else 
	{
		if (GetArea(oFoe) == GetArea(oCreature))
		{
			DelayCommand(0.01f, TOBManageCombatOverrides(TRUE));
			SetLocalInt(oCreature, "bot9s_overridestate", 2);
		}
		else
		{
			TOBProtectedClearCombatOverrides(oCreature); //Cleanup when we're not in the same area.
		}
	}
}


// Runs data needed by the Levelup screen before it opens.
// -nClass: Class constant of the class that is leveling.
// -nLearn: Number of maneuvers available to learn this level.
// -nRetrain: Number of maneuvers available to be retrained this level, typically
// at 4th and every even numbered level thereafter.
// -nStance: Number of stances available to learn this level.
// -nLevelcap: Level of the class that is being leveled.  Implemented to avoid
// abuse of the levelup system when a character is autoleveled or similar.
void TOBLoadLevelup(object oPC, object oToB, int nClass, int nLearn, int nRetrain, int nStance, int nLevelCap)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBLoadLevelup Start", GetFirstPC() ); }
	
	SetPause(FALSE);

	SetLocalInt(oToB, "LevelupClass", nClass);
	SetLocalInt(oToB, "LevelupLearn", nLearn); //Top number we can learn this level.
	SetLocalInt(oToB, "LevelupTotal", nLearn); //Total remaining to learn.
	SetLocalInt(oToB, "LevelupRetrain", nRetrain);
	SetLocalInt(oToB, "LevelupStanceLearn", nStance); //Top number we can learn this level.
	SetLocalInt(oToB, "LevelupStance", nStance);
	SetLocalInt(oToB, "LevelupCap", nLevelCap);
	TOBGenerateKnownManeuvers(oPC, oToB);
	TOBEnforceDataOpening(oPC, oToB);

	if (nLearn > 0 || nStance > 0)
	{
		DelayCommand(0.1f, SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE));
	}

	if (GetLocalInt(oToB, "CurrentLevelupLevel") == 0)
	{
		DelayCommand(0.1f, SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nStance)));
	}
	else
	{
		DelayCommand(0.1f, SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nLearn)));
	}
	
	DelayCommand(0.1f, SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "RETRAIN_POOL_TEXT", -1, IntToString(nRetrain)));
}




// Finds the number of readied maneuvers of each type.
void TOBGenerateReadiedManeuvers(string sType, int nBoxes, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGenerateReadiedManeuvers Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);

	int i;

	i = 1;

	while (i <= nBoxes)
	{
		if (GetLocalInt(oToB, "BlueBox" + sType + IntToString(i) + "_CR") > 0)
		{
			SetLocalInt(oToB, sType + "CrLimit", i);
			i++;
		}
		else break;
	}
}

// Generates the listbox of a random readied strike, boost, or counter.
string TOBRandomManeuver(object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRandomManeuver Start", GetFirstPC() ); }
	
	int nBoostLimit = GetLocalInt(oToB, "BCrLimit");
	int nCounterLimit = GetLocalInt(oToB, "CCrLimit");
	int nStrikeLimit = GetLocalInt(oToB, "STRCrLimit");

	string sType;
	int nLimit;

	// Double check to make sure that we actually have maneuvers readied for the type.
	if (nStrikeLimit == 0 && nCounterLimit == 0)
	{
		nLimit = nBoostLimit;
		sType = "BOOST";
	}
	else if (nStrikeLimit == 0 && nBoostLimit == 0)
	{
		nLimit = nCounterLimit;
		sType = "COUNTER";
	}
	else if (nCounterLimit == 0 && nBoostLimit == 0)
	{
		nLimit = nStrikeLimit;
		sType = "STRIKE";
	}
	else if (nStrikeLimit == 0)
	{
		int nRandomType = d2(1);

		switch (nRandomType)
		{
			case 1:	nLimit = nCounterLimit;	sType = "COUNTER";	break;
			case 2:	nLimit = nBoostLimit;	sType = "BOOST";	break;
		}
	}
	else if (nCounterLimit == 0)
	{
		int nRandomType = d2(1);

		switch (nRandomType)
		{
			case 1:	nLimit = nStrikeLimit;	sType = "STRIKE";	break;
			case 2:	nLimit = nBoostLimit;	sType = "BOOST";	break;
		}
	}
	else if (nBoostLimit == 0)
	{
		int nRandomType = d2(1);

		switch (nRandomType)
		{
			case 1:	nLimit = nStrikeLimit;	sType = "STRIKE";	break;
			case 2:	nLimit = nCounterLimit;	sType = "COUNTER";	break;
		}
	}
	else
	{
		int nRandomType = d3(1);

		switch (nRandomType)
		{
			case 1:	nLimit = nStrikeLimit;	sType = "STRIKE";	break;
			case 2:	nLimit = nCounterLimit;	sType = "COUNTER";	break;
			case 3:	nLimit = nBoostLimit;	sType = "BOOST";	break;
		}
	}


	int nRoll = CSLRandomBetween(1, nLimit);
	string sNumber;

	switch (nRoll)
	{
		case 1:	sNumber = "ONE";		break;
		case 2: sNumber = "TWO";		break;
		case 3: sNumber = "THREE";		break;
		case 4: sNumber = "FOUR";		break;
		case 5: sNumber = "FIVE";		break;
		case 6: sNumber = "SIX";		break;
		case 7: sNumber = "SEVEN";		break;
		case 8: sNumber = "EIGHT";		break;
		case 9: sNumber = "NINE";		break;
		case 10:sNumber = "TEN";		break;
		case 11:sNumber = "ELEVEN";		break;
		case 12:sNumber = "TWELVE";		break;
		case 13:sNumber = "THRITEEN";	break;
		case 14:sNumber = "FOURTEEN";	break;
		case 15:sNumber = "FIFTEEN";	break;
		case 16:sNumber = "SIXTEEN";	break;
		case 17:sNumber = "SEVENTEEN";	break;
		case 18:sNumber = "EIGHTEEN";	break;
		case 19:sNumber = "NINETEEN";	break;
		case 20:sNumber = "TWENTY";		break;
	}

	string sReturn = sType + "_" + sNumber;
	return sReturn;
}

// Disables all of the listboxes on the Crusader's Quickstrike screen.
void TOBDisableAll(object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDisableAll Start", GetFirstPC() ); }
	
	string sScreen = "SCREEN_QUICK_STRIKE_CR";
	object oToB = CSLGetDataStore(oPC);
	string sRRF = "RandomRecoveryFlag";
	int i;

	i = 1;

	if (GetLocalInt(oToB, "BlueBoxSTR1_CR") > 0) // The extra checks improve preformance.
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ONE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_ONE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR2_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWO", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_TWO");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR3_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THREE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_THREE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR4_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOUR", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_FOUR");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR5_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIVE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_FIVE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR6_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIX", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_SIX");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR7_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_SEVEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR8_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHT", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_EIGHT");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR9_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_NINE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR10_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_TEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR11_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ELEVEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_ELEVEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR12_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWELVE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_TWELVE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR13_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THIRTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_THIRTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR14_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOURTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_FOURTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR15_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIFTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_FIFTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR16_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIXTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_SIXTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR17_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVENTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_SEVENTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR18_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHTEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_EIGHTEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR19_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINETEEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_NINETEEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxSTR20_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWENTY", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "STRIKE_TWENTY");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB1_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_ONE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_ONE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB2_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TWO", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_TWO");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB3_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_THREE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_THREE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB4_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FOUR", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_FOUR");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB5_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FIVE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_FIVE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB6_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SIX", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_SIX");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB7_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SEVEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_SEVEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB8_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_EIGHT", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_EIGHT");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB9_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_NINE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_NINE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxB10_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "BOOST_TEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC1_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_ONE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_ONE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC2_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TWO", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_TWO");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC3_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_THREE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_THREE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC4_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FOUR", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_FOUR");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC5_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FIVE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_FIVE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC6_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SIX", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_SIX");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC7_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SEVEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_SEVEN");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC8_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_EIGHT", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_EIGHT");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC9_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_NINE", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_NINE");
		i++;
	}

	if (GetLocalInt(oToB, "BlueBoxC10_CR") > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TEN", TRUE);
		SetLocalString(oToB, sRRF + IntToString(i), "COUNTER_TEN");
		i++;
	}
}

// Clears all of the RandomRecovery# Flags.
void TOBClearRecoveryFlags(object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBClearRecoveryFlags Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);

	SetLocalString(oToB, "RandomRecoveryFlag1", "");
	SetLocalString(oToB, "RandomRecoveryFlag2", "");
	SetLocalString(oToB, "RandomRecoveryFlag3", "");
	SetLocalString(oToB, "RandomRecoveryFlag4", "");
	SetLocalString(oToB, "RandomRecoveryFlag5", "");
	SetLocalString(oToB, "RandomRecoveryFlag6", "");
	SetLocalString(oToB, "RandomRecoveryFlag7", "");
	SetLocalString(oToB, "RandomRecoveryFlag8", "");
	SetLocalString(oToB, "RandomRecoveryFlag9", "");
	SetLocalString(oToB, "RandomRecoveryFlag10", "");
	SetLocalString(oToB, "RandomRecoveryFlag11", "");
	SetLocalString(oToB, "RandomRecoveryFlag12", "");
	SetLocalString(oToB, "RandomRecoveryFlag13", "");
	SetLocalString(oToB, "RandomRecoveryFlag14", "");
	SetLocalString(oToB, "RandomRecoveryFlag15", "");
	SetLocalString(oToB, "RandomRecoveryFlag16", "");
	SetLocalString(oToB, "RandomRecoveryFlag17", "");
	SetLocalString(oToB, "RandomRecoveryFlag18", "");
	SetLocalString(oToB, "RandomRecoveryFlag19", "");
	SetLocalString(oToB, "RandomRecoveryFlag20", "");
	SetLocalString(oToB, "RandomRecoveryFlag21", "");
	SetLocalString(oToB, "RandomRecoveryFlag22", "");
	SetLocalString(oToB, "RandomRecoveryFlag23", "");
	SetLocalString(oToB, "RandomRecoveryFlag24", "");
	SetLocalString(oToB, "RandomRecoveryFlag25", "");
	SetLocalString(oToB, "RandomRecoveryFlag26", "");
	SetLocalString(oToB, "RandomRecoveryFlag27", "");
	SetLocalString(oToB, "RandomRecoveryFlag28", "");
	SetLocalString(oToB, "RandomRecoveryFlag29", "");
	SetLocalString(oToB, "RandomRecoveryFlag30", "");
	SetLocalString(oToB, "RandomRecoveryFlag31", "");
	SetLocalString(oToB, "RandomRecoveryFlag32", "");
	SetLocalString(oToB, "RandomRecoveryFlag33", "");
	SetLocalString(oToB, "RandomRecoveryFlag34", "");
	SetLocalString(oToB, "RandomRecoveryFlag35", "");
	SetLocalString(oToB, "RandomRecoveryFlag36", "");
	SetLocalString(oToB, "RandomRecoveryFlag37", "");
	SetLocalString(oToB, "RandomRecoveryFlag38", "");
	SetLocalString(oToB, "RandomRecoveryFlag39", "");
	SetLocalString(oToB, "RandomRecoveryFlag40", "");
}

// Returns TRUE if all RandomRecoveryFlags are cleared.
int TOBCheckWithheldManeuvers(object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCheckWithheldManeuvers Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	int nTotal = GetLocalInt(oToB, "CrLimit");

	string s1 = GetLocalString(oToB, "RandomRecoveryFlag1");
	string s2 = GetLocalString(oToB, "RandomRecoveryFlag2");
	string s3 = GetLocalString(oToB, "RandomRecoveryFlag3");
	string s4 = GetLocalString(oToB, "RandomRecoveryFlag4");
	string s5 = GetLocalString(oToB, "RandomRecoveryFlag5");
	string s6 = GetLocalString(oToB, "RandomRecoveryFlag6");
	string s7 = GetLocalString(oToB, "RandomRecoveryFlag7");
	string s8 = GetLocalString(oToB, "RandomRecoveryFlag8");
	string s9 = GetLocalString(oToB, "RandomRecoveryFlag9");
	string s10 = GetLocalString(oToB, "RandomRecoveryFlag10");
	string s11 = GetLocalString(oToB, "RandomRecoveryFlag11");
	string s12 = GetLocalString(oToB, "RandomRecoveryFlag12");
	string s13 = GetLocalString(oToB, "RandomRecoveryFlag13");
	string s14 = GetLocalString(oToB, "RandomRecoveryFlag14");
	string s15 = GetLocalString(oToB, "RandomRecoveryFlag15");
	string s16 = GetLocalString(oToB, "RandomRecoveryFlag16");
	string s17 = GetLocalString(oToB, "RandomRecoveryFlag17");
	string s18 = GetLocalString(oToB, "RandomRecoveryFlag18");
	string s19 = GetLocalString(oToB, "RandomRecoveryFlag19");
	string s20 = GetLocalString(oToB, "RandomRecoveryFlag20");
	string s21 = GetLocalString(oToB, "RandomRecoveryFlag21");
	string s22 = GetLocalString(oToB, "RandomRecoveryFlag22");
	string s23 = GetLocalString(oToB, "RandomRecoveryFlag23");
	string s24 = GetLocalString(oToB, "RandomRecoveryFlag24");
	string s25 = GetLocalString(oToB, "RandomRecoveryFlag25");
	string s26 = GetLocalString(oToB, "RandomRecoveryFlag26");
	string s27 = GetLocalString(oToB, "RandomRecoveryFlag27");
	string s28 = GetLocalString(oToB, "RandomRecoveryFlag28");
	string s29 = GetLocalString(oToB, "RandomRecoveryFlag29");
	string s30 = GetLocalString(oToB, "RandomRecoveryFlag30");
	string s31 = GetLocalString(oToB, "RandomRecoveryFlag31");
	string s32 = GetLocalString(oToB, "RandomRecoveryFlag32");
	string s33 = GetLocalString(oToB, "RandomRecoveryFlag33");
	string s34 = GetLocalString(oToB, "RandomRecoveryFlag34");
	string s35 = GetLocalString(oToB, "RandomRecoveryFlag35");
	string s36 = GetLocalString(oToB, "RandomRecoveryFlag36");
	string s37 = GetLocalString(oToB, "RandomRecoveryFlag37");
	string s38 = GetLocalString(oToB, "RandomRecoveryFlag38");
	string s39 = GetLocalString(oToB, "RandomRecoveryFlag39");
	string s40 = GetLocalString(oToB, "RandomRecoveryFlag40");

	if (nTotal == 1)
	{
		if (s1 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 2)
	{
		if (s1 == "" && s2 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 3)
	{
		if (s1 == "" && s2 == "" && s3 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 4)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 5)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 6)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 7)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 8)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 9)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 10)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 11)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 12)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 13)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 14)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 15)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 16)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 17)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 18)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 19)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 20)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 21)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 22)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 23)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 24)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 25)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 26)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 27)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 28)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 29)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 30)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 31)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 32)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 33)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 34)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 35)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 36)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 37)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "" && s37 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 38)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "" && s37 == "" && s38 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 39)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "" && s37 == "" && s38 == ""
		&& s39 == "")
		{
			return TRUE;
		}
	}
	else if (nTotal == 40)
	{
		if (s1 == "" && s2 == "" && s3 == "" && s4 == "" && s5 == "" && s6 == "" && s7 == ""
		&& s8 == "" && s9 == "" && s10 == "" && s11 == "" && s12 == "" && s13 == "" && s14 == "" 
		&& s15 == "" && s16 == "" && s17 == "" && s18 == "" && s19 == "" && s20 == ""
		&& s21 == "" && s22 == "" && s23 == "" && s24 == "" && s25 == "" && s26 == "" 
		&& s27 == "" && s28 == "" && s29 == "" && s30 == "" && s31 == "" && s32 == "" 
		&& s33 == "" && s34 == "" && s35 == "" && s36 == "" && s37 == "" && s38 == ""
		&& s39 == "" && s40 == "")
		{
			return TRUE;
		}
	}
	return FALSE;
}


// Clears sListBox from the RandomRecoveryFlag# it has been set in.
void TOBClearCrusaderRecoveryFlag(string sListBox, object oPC = OBJECT_SELF)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBClearCrusaderRecoveryFlag Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);

	if (GetLocalString(oToB, "RandomRecoveryFlag1") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag1", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag2") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag2", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag3") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag3", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag4") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag4", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag5") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag5", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag6") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag6", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag7") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag7", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag8") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag8", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag9") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag9", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag10") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag10", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag11") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag11", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag12") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag12", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag13") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag13", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag14") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag14", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag15") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag15", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag16") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag16", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag17") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag17", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag18") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag18", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag19") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag19", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag20") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag20", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag21") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag21", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag22") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag22", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag23") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag23", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag24") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag24", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag25") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag25", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag26") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag26", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag27") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag27", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag28") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag28", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag29") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag29", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag30") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag30", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag31") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag31", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag32") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag32", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag33") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag33", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag34") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag34", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag35") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag35", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag36") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag36", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag37") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag37", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag38") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag38", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag39") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag39", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}
	else if (GetLocalString(oToB, "RandomRecoveryFlag40") == sListBox)
	{
		SetLocalString(oToB, "RandomRecoveryFlag40", "");
		SetLocalInt(oToB, "RRFCleared", 1);
	}

	if (TOBCheckWithheldManeuvers() == TRUE)
	{
		SetLocalInt(oToB, "RRFCleared", 1);
	}
}

//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/12/2009							//
//	Title: bot9s_inc_index					//
//	Description: Indexing functions for the	//
//	Book of the Nine Swords classes.		//
//////////////////////////////////////////////


/*	Unique tags are created on the placeholder items, specific to the player they are generated for.
	Here we are making sure that we're checking for those tags and not the base item.
	This prevents PCs of the same class from interfering with another PC's interface.
	
	Red, Blue, and Green Boxes are local ints stored on the item oToB.  They are the heart
	of the indexing functions.  RedBox refers to the listboxes on the Maneuvers Readied screen.
	BlueBoxes come in four types and GreenBoxes come in three types each coresponding to a type of maneuver.
	STA for Stance, STR for Strike, B for Boost, and C for Counter.  GreenBoxes are not used for STA
	because Stances never are put on the Maneuvers Readied screen. BlueBoxes contain the 2da row number
	from the maneuvers 2da and tell the buttons on the QuickStrike menu what icon to display and which
	script to run.  GreenBoxes are bridges between Red and Blue.  When RedBox tells us that the player has
	selected a particular maneuver for the numbered box, GreenBox copies the number of the RedBox.  When
	another maneuver is added a check is run to find the first availible empty box on Maneuvers
	Readied.  Since RedBox# now has been set to 1 (indicating that it is used) the function TOBGetRed finds
	the next availible RedBox.  Once it has done that it looks for the next empty box on QuickStrike.  Since
	BlueBox holds the actual 2da information GreenBox is needed to properly determine which boxes are 
	occupied.  Once the function TOBGetGreen finds that listbox it is set to the RedBox number and TOBGetBlue sets the 
	2da for the approriate ListBox based on the ListBox TOBGetGreen tells it to use.  When a maneuver is removed, TOBRemoveManeuver
	checks the number on GreenBox (also the same number as RedBox) and the data can be reset to 0 for the specific
	listbox.  To clarify, no data from these boxes is ever stored on the GUI, it is stored in oToB.
	The GUI merely executes the script to check for or modify the variables when selected.
	
	4/10/2009: Major overhaul of the indexing system; reduced clutter scripts, added routing for
	Classes, and added support for swift feats. */


//Sets Variables, adds and modifies listboxes for the bo9s menus.
// - oPC: Person calling the menu.
// - oManeuver: Item in oToB that we extract variables from.
// - nLevel: Which teir of listboxes we're populating.
// - nIndexRow: Number of the listbox row and pertinet variables being modified.
// - nClassType: The menu of the class to populate the menu for.
void TOBPopulateBot9sMenu(object oPC, object oManeuver, int nLevel, int nIndexRow, int nClassType)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBPopulateBot9sMenu Start", GetFirstPC() ); }
	
	object oToB = CSLGetDataStore(oPC);
	int nClass = GetLocalInt(oManeuver, "Class"); // variable is set on item at creation
	int nRow, nType;
	string sLevel, sIndexRow, sScreen, sList, sText, sTextures, sClass, sTga, sName;

	switch (nClass)
	{
		case CLASS_TYPE_CRUSADER:	sScreen = "SCREEN_MANEUVERS_KNOWN_CR";	sClass = "_CR";	break;
		case CLASS_TYPE_SAINT:		sScreen = "SCREEN_MANEUVERS_KNOWN_SA";	sClass = "_SA";	break;
		case CLASS_TYPE_SWORDSAGE:	sScreen = "SCREEN_MANEUVERS_KNOWN_SS";	sClass = "_SS";	break;
		case CLASS_TYPE_WARBLADE:	sScreen = "SCREEN_MANEUVERS_KNOWN_WB";	sClass = "_WB";	break;
		case 255:					sScreen = "SCREEN_MANEUVERS_KNOWN";		sClass = "___";	break;
		default:					sScreen = "SCREEN_MANEUVERS_KNOWN";		sClass = "___";	break;
	}

	if ((nLevel == 0) && (nClass == nClassType))
	{
		nRow = GetLocalInt(oManeuver, "2da");
		nType = GetLocalInt(oManeuver, "Type");
		sName = TOBGetManeuversDataName(nRow);
		sTga = TOBGetManeuversDataIcon(nRow);
		sLevel = IntToString(nLevel);
		sIndexRow = IntToString(nIndexRow);
		sList = "STANCE_LIST";
		sText = "STANCE_ITEM_TEXT=" + sName;
		sTextures = "STANCE_ITEM_ICON=" + sTga + ".tga";

		SetLocalInt(oToB, "CheckI", 2);
		SetLocalInt(oToB, "BlueBoxSTA" + sIndexRow + sClass, nRow);
		AddListBoxRow(oPC, sScreen, sList, "STANCE_LISTBOX_ITEM" + sIndexRow, sText, sTextures, "", "");

		if (GetHasFeat(FEAT_STANCE_MASTERY, oPC))
		{
			SetLocalInt(oToB, "BlueBoxDSTA" + sIndexRow + sClass, nRow);
		}
	}
	else if (nClass == nClassType)
	{
		nRow = GetLocalInt(oManeuver, "2da");
		nType = GetLocalInt(oManeuver, "Type");
		sName = TOBGetManeuversDataName(nRow);
		sTga = TOBGetManeuversDataIcon(nRow);
		sLevel = IntToString(nLevel);
		sIndexRow = IntToString(nIndexRow);
		sList = "LEVEL" + sLevel + "_LIST";
		sText = "LEVEL" + sLevel + "_ITEM_TEXT=" + sName;
		sTextures = "LEVEL" + sLevel + "_ITEM_ICON=" + sTga + ".tga";

		SetLocalInt(oToB, "CheckI", 2);
		SetLocalInt(oToB, "Level" + sLevel + "Row" + sIndexRow + sClass, nRow);
		SetLocalInt(oToB, "L" + sLevel + "R" + sIndexRow + "Type" + sClass, nType);
		AddListBoxRow(oPC, sScreen, sList, "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, sText, sTextures, "", "");

		if (GetLocalInt(oToB, "Known" + sClass + sLevel + "Row" + sIndexRow + "Disabled") == 1)
		{
			if (sClass == "___")
			{
				SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, TRUE);
			}
			else SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_KNOWN" + sClass, "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, TRUE);
		}
	}
}

//Sets variables and disbaled status for the Maneuvers Readied screen.
// -sRed: Data string embeded into the listbox row.  Contains many values.
// -sClass: Class menu to populate.
// -sNumber: The number of the Readied Maneuver box on the screen.
void TOBPopulateManeuverReadied(string sRed, string sClass, string sNumber)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBPopulateManeuverReadied Start", GetFirstPC() ); }
	
	if (sRed != "")
	{
		object oOrigin = OBJECT_SELF;
		object oPC = GetControlledCharacter(oOrigin);
		object oToB = CSLGetDataStore(oPC);
		int nRow = GetLocalInt(oToB, "ReadiedRow" + sNumber + sClass);
		string sTga = TOBGetManeuversDataIcon(nRow);
		string sIcon = "RED_" + sNumber + "=" + sTga + ".tga";

		if (sClass == "___")
		{
			AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED", "READIED_" + sNumber, "RED_PANE_" + sNumber, "", sIcon, sRed, "");

			if (GetLocalInt(oToB, "Readied" + sNumber + sClass + "Disabled") == 1)
			{
				SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED", "READIED_" + sNumber, FALSE);
			}
		}
		else
		{
			AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED" + sClass, "READIED_" + sNumber, "RED_PANE_" + sNumber, "", sIcon, sRed, "");

			if (GetLocalInt(oToB, "Readied" + sNumber + sClass + "Disabled") == 1)
			{
				SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED" + sClass, "READIED_" + sNumber, FALSE);
			}
		}
	}
}

//Returns the first unoccupied RedBox with number.
string TOBGetRed(string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetRed Start", GetFirstPC() ); }
	
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = CSLGetDataStore(oPC);
	int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal" + sClass);
	
	string sRedBox; //Strings that do not exist always return as "".

	if ((GetLocalInt(oToB, "RedBox17" + sClass) == 0) && (GetHasFeat(FEAT_EXTRA_READIED_MANEUVER, oPC)))
	{
		sRedBox = "RedBox17" + sClass;
	}
	else if (GetLocalInt(oToB, "RedBox1" + sClass) == 0)
	{
		sRedBox = "RedBox1" + sClass;
	}
	else if (GetLocalInt(oToB, "RedBox2" + sClass) == 0)
	{
		sRedBox = "RedBox2" + sClass;
	}
	else if (GetLocalInt(oToB, "RedBox3" + sClass) == 0)
	{
		sRedBox = "RedBox3" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox4" + sClass) == 0) && (nReadiedTotal >= 4))
	{
		sRedBox = "RedBox4" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox5" + sClass) == 0) && (nReadiedTotal >= 5))
	{
		sRedBox = "RedBox5" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox6" + sClass) == 0) && (nReadiedTotal >= 6))
	{
		sRedBox = "RedBox6" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox7" + sClass) == 0) && (nReadiedTotal >= 7))
	{
		sRedBox = "RedBox7" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox8" + sClass) == 0) && (nReadiedTotal >= 8))
	{
		sRedBox = "RedBox8" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox9" + sClass) == 0) && (nReadiedTotal >= 9))
	{
		sRedBox = "RedBox9" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox10" + sClass) == 0) && (nReadiedTotal >= 10))
	{
		sRedBox = "RedBox10" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox11" + sClass) == 0) && (nReadiedTotal >= 11))
	{
		sRedBox = "RedBox11" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox12" + sClass) == 0) && (nReadiedTotal >= 12))
	{
		sRedBox = "RedBox12" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox13" + sClass) == 0) && (nReadiedTotal >= 13))
	{
		sRedBox = "RedBox13" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox14" + sClass) == 0) && (nReadiedTotal >= 14))
	{
		sRedBox = "RedBox14" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox15" + sClass) == 0) && (nReadiedTotal >= 15))
	{
		sRedBox = "RedBox15" + sClass;
	}
	else if ((GetLocalInt(oToB, "RedBox16" + sClass) == 0) && (nReadiedTotal >= 16))
	{
		sRedBox = "RedBox16" + sClass;
	}
	return sRedBox;
}

//Returns the number of the RedBox called by TOBGetRed
int TOBGetRedNumber(string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetRedNumber Start", GetFirstPC() ); }
	
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = CSLGetDataStore(oPC);
	int nReadiedTotal = GetLocalInt(oToB, "ReadiedTotal" + sClass);
	
	int r;

	if ((GetLocalInt(oToB, "RedBox17" + sClass) == 0) && (GetHasFeat(FEAT_EXTRA_READIED_MANEUVER, oPC)))
	{
		r = 17;
	}
	else if (GetLocalInt(oToB, "RedBox1" + sClass) == 0)
	{
		r = 1;
	}
	else if (GetLocalInt(oToB, "RedBox2" + sClass) == 0)
	{
		r = 2;
	}
	else if (GetLocalInt(oToB, "RedBox3" + sClass) == 0)
	{
		r = 3;
	}
	else if ((GetLocalInt(oToB, "RedBox4" + sClass) == 0) && (nReadiedTotal >= 4))
	{
		r = 4;
	}
	else if ((GetLocalInt(oToB, "RedBox5" + sClass) == 0) && (nReadiedTotal >= 5))
	{
		r = 5;
	}
	else if ((GetLocalInt(oToB, "RedBox6" + sClass) == 0) && (nReadiedTotal >= 6))
	{
		r = 6;
	}
	else if ((GetLocalInt(oToB, "RedBox7" + sClass) == 0) && (nReadiedTotal >= 7))
	{
		r = 7;
	}
	else if ((GetLocalInt(oToB, "RedBox8" + sClass) == 0) && (nReadiedTotal >= 8))
	{
		r = 8;
	}
	else if ((GetLocalInt(oToB, "RedBox9" + sClass) == 0) && (nReadiedTotal >= 9))
	{
		r = 9;
	}
	else if ((GetLocalInt(oToB, "RedBox10" + sClass) == 0) && (nReadiedTotal >= 10))
	{
		r = 10;
	}
	else if ((GetLocalInt(oToB, "RedBox11" + sClass) == 0) && (nReadiedTotal >= 11))
	{
		r = 11;
	}
	else if ((GetLocalInt(oToB, "RedBox12" + sClass) == 0) && (nReadiedTotal >= 12))
	{
		r = 12;
	}
	else if ((GetLocalInt(oToB, "RedBox13" + sClass) == 0) && (nReadiedTotal >= 13))
	{
		r = 13;
	}
	else if ((GetLocalInt(oToB, "RedBox14" + sClass) == 0) && (nReadiedTotal >= 14))
	{
		r = 14;
	}
	else if ((GetLocalInt(oToB, "RedBox15" + sClass) == 0) && (nReadiedTotal >= 15))
	{
		r = 15;
	}
	else if ((GetLocalInt(oToB, "RedBox16" + sClass) == 0) && (nReadiedTotal >= 16))
	{
		r = 16;
	}

	return r;
}

//Returns the first unoccupied GreenBox by type and number.
// - sType: Either STR, B, or C (STA is not used by GreenBoxes).
// - sClass: Type of Class that can use this particular box.
string TOBGetGreen(string sType, string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetGreen Start", GetFirstPC() ); }
	
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = CSLGetDataStore(oPC);

	string sGreenBox;
	
	if (GetLocalInt(oToB, "GreenBox" + sType + "1" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "1" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "2" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "2" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "3" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "3" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "4" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "4" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "5" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "5" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "6" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "6" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "7" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "7" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "8" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "8" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "9" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "9" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "10" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "10" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "11" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "11" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "12" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "12" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "13" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "13" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "14" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "14" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "15" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "15" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "16" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "16" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "17" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "17" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "18" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "18" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "19" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "19" + sClass;
	}
	else if (GetLocalInt(oToB, "GreenBox" + sType + "20" + sClass) == 0)
	{
		sGreenBox = "GreenBox" + sType + "20" + sClass;
	}
	return sGreenBox;
}

//Cross references the first availible GreenBox to determine the first unoccupied BlueBox.
//Returns the first unoccupied BlueBox.
// - sType:  Checks by types STR, B, or C (STA directly bypasses these checks because it is never used on Maneuvers Readied).
// - sClass: Type of Class that can use this particular box.
string TOBGetBlue(string sType, string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetBlue Start", GetFirstPC() ); }
	
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = CSLGetDataStore(oPC);
	
	string sBlueBox;
	
	int nCheck1 = GetLocalInt(oToB, "GreenBox" + sType + "1" + sClass);
	int nCheck2 = GetLocalInt(oToB, "GreenBox" + sType + "2" + sClass);
	int nCheck3 = GetLocalInt(oToB, "GreenBox" + sType + "3" + sClass);
	int nCheck4 = GetLocalInt(oToB, "GreenBox" + sType + "4" + sClass);
	int nCheck5 = GetLocalInt(oToB, "GreenBox" + sType + "5" + sClass);
	int nCheck6 = GetLocalInt(oToB, "GreenBox" + sType + "6" + sClass);
	int nCheck7 = GetLocalInt(oToB, "GreenBox" + sType + "7" + sClass);
	int nCheck8 = GetLocalInt(oToB, "GreenBox" + sType + "8" + sClass);
	int nCheck9 = GetLocalInt(oToB, "GreenBox" + sType + "9" + sClass);
	int nCheck10 = GetLocalInt(oToB, "GreenBox" + sType + "10" + sClass);
	int nCheck11 = GetLocalInt(oToB, "GreenBox" + sType + "11" + sClass);
	int nCheck12 = GetLocalInt(oToB, "GreenBox" + sType + "12" + sClass);
	int nCheck13 = GetLocalInt(oToB, "GreenBox" + sType + "13" + sClass);
	int nCheck14 = GetLocalInt(oToB, "GreenBox" + sType + "14" + sClass);
	int nCheck15 = GetLocalInt(oToB, "GreenBox" + sType + "15" + sClass);
	int nCheck16 = GetLocalInt(oToB, "GreenBox" + sType + "16" + sClass);
	int nCheck17 = GetLocalInt(oToB, "GreenBox" + sType + "17" + sClass);
	int nCheck18 = GetLocalInt(oToB, "GreenBox" + sType + "18" + sClass);
	int nCheck19 = GetLocalInt(oToB, "GreenBox" + sType + "19" + sClass);
	int nCheck20 = GetLocalInt(oToB, "GreenBox" + sType + "20" + sClass);
	int nCheckGreen = GetLocalInt(oToB, TOBGetGreen(sType, sClass));
		
	if (nCheck1 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "1" + sClass;
	}
	else if (nCheck2 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "2" + sClass;
	}
	else if (nCheck3 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "3" + sClass;
	}
	else if (nCheck4 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "4" + sClass;
	}
	else if (nCheck5 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "5" + sClass;
	}
	else if (nCheck6 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "6" + sClass;
	}
	else if (nCheck7 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "7" + sClass;
	}
	else if (nCheck8 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "8" + sClass;
	}
	else if (nCheck9 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "9" + sClass;
	}
	else if (nCheck10 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "10" + sClass;
	}
	else if (nCheck11 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "11" + sClass;
	}
	else if (nCheck12 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "12" + sClass;
	}
	else if (nCheck13 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "13" + sClass;
	}
	else if (nCheck14 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "14" + sClass;
	}
	else if (nCheck15 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "15" + sClass;
	}
	else if (nCheck16 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "16" + sClass;
	}
	else if (nCheck17 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "17" + sClass;
	}
	else if (nCheck18 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "18" + sClass;
	}
	else if (nCheck19 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "19" + sClass;
	}
	else if (nCheck20 == nCheckGreen)
	{
		sBlueBox = "BlueBox" + sType + "20" + sClass;
	}
	return sBlueBox;
}

// Returns the first empty swift feat box.
// - sClass: Absolutely necessary to display the box correctly.
string TOBGetSwiftFeat(string sData)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetSwiftFeat Start", GetFirstPC() ); }
	
	/* This is a depricated function since patch 1.23 introduced true swift
	feats.  However, I've kept it around because it is useful to display
	misc buttons related to the maneuvers.*/

	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	string sClass = GetStringRight(sData, 3);
	object oToB = CSLGetDataStore(oPC);
	
	string sFeatBox; //Variables that do not exist always return as 0.
	//BlueBoxF1 is reserved for Charge.
	if (GetLocalInt(oToB, "BlueBoxF2" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF2" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF3" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF3" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF4" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF4" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF5" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF5" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF6" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF6" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF7" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF7" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF8" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF8" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF9" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF9" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF10" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF10" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF11" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF11" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF12" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF12" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF13" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF13" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF14" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF14" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF15" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF15" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF16" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF16" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF17" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF17" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF18" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF18" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF19" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF19" + sClass;
	}
	else if (GetLocalInt(oToB, "BlueBoxF20" + sClass) == 0)
	{
		sFeatBox = "BlueBoxF20" + sClass;
	}
	return sFeatBox;
}

//Sets Red, Blue, and Green box variables when a Listbox under Level nLevel is selected
//from the Maneuvers Known Screen.  RedBox is for Maneuvers Readied, BlueBox is a 2da refrence
//for Quickstrike, and GreenBox determines if the Quickstrike buttons are occupied.
// - oPC: Person calling the menu.
// - nLevel: Level listing of the maneuver to add.
// - nIndexRow: Numeric value of the listbox row being selected. ie: "L1R#Type", "Level1Row#".
// - nRed: ID Number of "READIED_", "RED_PANE_", and "RED_" GUIObject (for textures) and the variable "RedBox#".
// - sClass: Class suffix of the screens to modify.
void TOBAddLevelRow(object oPC, int nLevel, int nIndexRow, int nRed, string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBAddLevelRow Start", GetFirstPC() ); }
	
	string sLevel = IntToString(nLevel);
	string sIndexRow = IntToString(nIndexRow);
	string sRed = IntToString(nRed);
	object oToB = CSLGetDataStore(oPC);

	int nRow = GetLocalInt(oToB, "Level" + sLevel + "Row" + sIndexRow + sClass);
	int nType = GetLocalInt(oToB, "L" + sLevel + "R" + sIndexRow + "Type" + sClass);
	string sTga = TOBGetManeuversDataIcon(nRow);

	string sTextures = "RED_" + sRed + "=" + sTga + ".tga";
	string sBox = "READIED_" + sRed;
	string sVari = sLevel + sRed + sClass + IntToString(nRow) + "_" + sIndexRow; // GetSubString type functions are used to break this apart.

	string sGreenBoxSTR = TOBGetGreen("STR", sClass);
	string sGreenBoxB = TOBGetGreen("B", sClass);
	string sGreenBoxC = TOBGetGreen("C", sClass);

	string sBlueBoxSTR = TOBGetBlue("STR", sClass);
	string sBlueBoxB = TOBGetBlue("B", sClass);
	string sBlueBoxC = TOBGetBlue("C", sClass);

	if (sClass == "___")
	{
		AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED", sBox, "RED_PANE_" + sRed, "", sTextures, "", "");
		SetLocalString(oToB, "Readied" + sRed + sClass, sVari);
		SetLocalInt(oToB, "ReadiedRow" + sRed + sClass, nRow);
	}
	else 
	{
		AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED" + sClass, sBox, "RED_PANE_" + sRed, "", sTextures, "", "");
		SetLocalString(oToB, "Readied" + sRed + sClass, sVari);
		SetLocalInt(oToB, "ReadiedRow" + sRed + sClass, nRow);
	}

	SetLocalInt(oToB, "RedBox" + sRed + sClass, 1);

	if (nType == 2)
	{
		SetLocalInt(oToB, sBlueBoxSTR, nRow);
		SetLocalInt(oToB, sGreenBoxSTR, nRed);
	}
	else if (nType == 3)
	{
		SetLocalInt(oToB, sBlueBoxB, nRow);
		SetLocalInt(oToB, sGreenBoxB, nRed);
	}
	else if (nType == 4)
	{
		SetLocalInt(oToB, sBlueBoxC, nRow);
		SetLocalInt(oToB, sGreenBoxC, nRed);
	}

	if (sClass == "___")
	{
		SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_KNOWN", "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, TRUE);
		SetLocalInt(oToB, "Known" + sClass + sLevel + "Row" + sIndexRow + "Disabled", 1);
	}
	else 
	{
		SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_KNOWN" + sClass, "LEVEL" + sLevel + "_LISTBOX_ITEM" + sIndexRow, TRUE);
		SetLocalInt(oToB, "Known" + sClass + sLevel + "Row" + sIndexRow + "Disabled", 1);
	}

	if (sClass == "___")
	{
		SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED", sBox, FALSE);
		SetLocalInt(oToB, "Readied" + sRed + sClass + "Disabled", 1);
	}
	else 
	{
		SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED" + sClass, sBox, FALSE);
		SetLocalInt(oToB, "Readied" + sRed + sClass + "Disabled", 1);
	}
}

//Sets the textures of the Quickstrike Listboxes
// - sListbox: Name of the ListBox to be modified.
// - sUIPane: Name of the UIPane to be modified.
// - sIndexType: Letter suffix of the BlueBox we're extracting the 2da refrence from.
// - nIndexRow: Index number of the 2da row which tells us which texture to use.
// - sClass: Which Quickstrike Menu to add to.
void TOBAddQuickstrike(string sListBox, string sUIPane, string sIndexType, int nIndexRow, string sData)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBAddQuickstrike Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	string sClass = GetStringRight(sData, 3);
	string sScreen;
	
	if (sClass != "___")
	{
		sScreen = "SCREEN_QUICK_STRIKE" + sClass;
	}
	else sScreen = "SCREEN_QUICK_STRIKE";
	
	string sIndexRow = IntToString(nIndexRow);
	string sBox;
	string sTextures;
	
	object oToB = CSLGetDataStore(oPC);
	int nRow = GetLocalInt(oToB, "BlueBox" + sIndexType + sIndexRow + sClass);
	
	if (nRow == 0)
	{
		sTextures = sIndexType + sIndexRow + "=" + "b_empty.tga";
		sBox = sListBox;

		ModifyListBoxRow(oPC, sScreen, sBox, sUIPane, "", sTextures, "", "");
		SetGUIObjectHidden(oPC, sScreen, sBox, TRUE);
	}
	else if (nRow != 0)
	{
		sTextures = sIndexType + sIndexRow + "=" + GetLocalString(oToB, "maneuvers_ICON" + IntToString(nRow)) + ".tga";
		sBox = sListBox;

		ModifyListBoxRow(oPC, sScreen, sBox, sUIPane, "", sTextures, "", "");
		SetGUIObjectHidden(oPC, sScreen, sBox, FALSE);
	}
}

//Cross References the number of the RedBox as nRed againt the local int of GreenBoxes
//in order to find and clear the appropriate maneuvers from Maneuvers Readied and Quickstrike.
// - nRed: Number of the calling RedBox and local int stored on GreenBox.
void TOBRemoveManeuver(int nRed, string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRemoveManeuver Start", GetFirstPC() ); }
	
	object oOrigin = OBJECT_SELF;
	object oPC = GetControlledCharacter(oOrigin);
	object oToB = CSLGetDataStore(oPC);
	
	SetLocalInt(oToB, "RedBox" + IntToString(nRed) + sClass, 0);
	
	if (GetLocalInt(oToB, "GreenBoxSTR1" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR1" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR1" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR2" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR2" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR2" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR3" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR3" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR3" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR4" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR4" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR4" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR5" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR5" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR5" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR6" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR6" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR6" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR7" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR7" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR7" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR8" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR8" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR8" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR9" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR9" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR9" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR10" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR10" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR10" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR11" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR11" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR11" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR12" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR12" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR12" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR13" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR13" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR13" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR14" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR14" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR14" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR15" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR15" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR15" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR16" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR16" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR16" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR17" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR17" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR17" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR18" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR18" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR18" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR19" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR19" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR19" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxSTR20" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxSTR20" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxSTR20" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB1" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB1" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB1" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB2" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB2" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB2" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB3" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB3" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB3" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB4" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB4" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB4" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB5" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB5" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB5" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB6" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB6" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB6" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB7" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB7" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB7" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB8" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB8" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB8" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB9" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB9" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB9" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxB10" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxB10" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxB10" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC1" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC1" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC1" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC2" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC2" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC2" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC3" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC3" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC3" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC4" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC4" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC4" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC5" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC5" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC5" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC6" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC6" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC6" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC7" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC7" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC7" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC8" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC8" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC8" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC9" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC9" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC9" + sClass, 0);
	}
	else if (GetLocalInt(oToB, "GreenBoxC10" + sClass) == nRed)
	{
		SetLocalInt(oToB, "GreenBoxC10" + sClass, 0);
		SetLocalInt(oToB, "BlueBoxC10" + sClass, 0);
	}
}
	


// Displays discplines for the Insightful Strike: Weapon Focus menu.
void TOBDisplaySSInsightfulStrike(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDisplaySSInsightfulStrike Start", GetFirstPC() ); }
	
	string sScreen = "SCREEN_LEVELUP_RETRAIN_FEATS";

	ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");

	if (GetLocalInt(oToB, "SSWeaponFocus") != 1)
	{
		string sDWIcon = "RETRAIN_IMAGE=desertwind.tga";
		string sDWName = "RETRAIN_TEXT=Desert Wind";
		string sDWVari = "7=" + IntToString(1);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(1), sDWName, sDWIcon, sDWVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 3)
	{
		string sDMIcon = "RETRAIN_IMAGE=diamondmind.tga";
		string sDMName = "RETRAIN_TEXT=Diamond Mind";
		string sDMVari = "7=" + IntToString(3);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(3), sDMName, sDMIcon, sDMVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 5)
	{
		string sSSIcon = "RETRAIN_IMAGE=settingsun.tga";
		string sSSName = "RETRAIN_TEXT=Setting Sun";
		string sSSVari = "7=" + IntToString(5);
	
		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(5), sSSName, sSSIcon, sSSVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 6)
	{
		string sSHIcon = "RETRAIN_IMAGE=greenhand.tga";
		string sSHName = "RETRAIN_TEXT=Shadow Hand";
		string sSHVari = "7=" + IntToString(6);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(6), sSHName, sSHIcon, sSHVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 7)
	{
		string sSDIcon = "RETRAIN_IMAGE=stonedragon.tga";
		string sSDName = "RETRAIN_TEXT=Stone Dragon";
		string sSDVari = "7=" + IntToString(7);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(7), sSDName, sSDIcon, sSDVari, "");
	}

	if (GetLocalInt(oToB, "SSWeaponFocus") != 8)
	{
		string sTCIcon = "RETRAIN_IMAGE=tigerclaw.tga";
		string sTCName = "RETRAIN_TEXT=Tiger Claw";
		string sTCVari = "7=" + IntToString(8);

		AddListBoxRow(oPC, sScreen, "AVAILABLE_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(8), sTCName, sTCIcon, sTCVari, "");
	}
}

// Determines how many maneuvers a player should have without actually creating
// the items for them.  Used to determine which maneuvers a player can access.
// 1 = Initiate, 2 = Novice, 3 = Adept, 4 = Veteran, 5 or more = Master.
// -nDiscipline: Which discpline to add or subtract from.
// -bAddSubtract: Add or subtract from the total number of maneuvers of 
// nDiscipline.  Use TRUE to add and FALSE to subtract.
void TOBPredictDisciplineStatus(int nDiscipline, int bAddSubtract)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBPredictDisciplineStatus Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = CSLGetDataStore(oPC);
	int nDW = GetLocalInt(oToB, "DWTotal");
	int nDS = GetLocalInt(oToB, "DSTotal");
	int nDM = GetLocalInt(oToB, "DMTotal");
	int nIH = GetLocalInt(oToB, "IHTotal");
	int nSS = GetLocalInt(oToB, "SSTotal");
	int nSH = GetLocalInt(oToB, "SHTotal");
	int nSD = GetLocalInt(oToB, "SDTotal");
	int nTC = GetLocalInt(oToB, "TCTotal");
	int nWR = GetLocalInt(oToB, "WRTotal");

	if (bAddSubtract == TRUE)
	{
		switch (nDiscipline)
		{
			case DESERT_WIND:	nDW += 1;	break;
			case DEVOTED_SPIRIT:nDS += 1;	break;
			case DIAMOND_MIND:	nDM += 1;	break;
			case IRON_HEART:	nIH += 1;	break;
			case SETTING_SUN:	nSS += 1;	break;
			case SHADOW_HAND:	nSH += 1;	break;
			case STONE_DRAGON:	nSD += 1;	break;
			case TIGER_CLAW:	nTC += 1;	break;
			case WHITE_RAVEN:	nWR += 1;	break;
		}
	}
	else if (bAddSubtract == FALSE)
	{
		switch (nDiscipline)
		{
			case DESERT_WIND:	nDW -= 1;	break;
			case DEVOTED_SPIRIT:nDS -= 1;	break;
			case DIAMOND_MIND:	nDM -= 1;	break;
			case IRON_HEART:	nIH -= 1;	break;
			case SETTING_SUN:	nSS -= 1;	break;
			case SHADOW_HAND:	nSH -= 1;	break;
			case STONE_DRAGON:	nSD -= 1;	break;
			case TIGER_CLAW:	nTC -= 1;	break;
			case WHITE_RAVEN:	nWR -= 1;	break;
		}
	}

	SetLocalInt(oToB, "DWTotal", nDW);
	SetLocalInt(oToB, "DSTotal", nDS);
	SetLocalInt(oToB, "DMTotal", nDM);
	SetLocalInt(oToB, "IHTotal", nIH);
	SetLocalInt(oToB, "SSTotal", nSS);
	SetLocalInt(oToB, "SHTotal", nSH);
	SetLocalInt(oToB, "SDTotal", nSD);
	SetLocalInt(oToB, "TCTotal", nTC);
	SetLocalInt(oToB, "WRTotal", nWR);
}



// Adds Feats pending to be switched for the feats the PC is retraining to the 
// Added Feats window.
void TOBDisplayAddedFeats(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDisplayAddedFeats Start", GetFirstPC() ); }
	
	int nPending1 = GetLocalInt(oToB, "PendingFeat1");
	int nPending2 = GetLocalInt(oToB, "PendingFeat2");

	ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST");

	if (nPending1 > 0)
	{
		string sIcon = "RETRAIN_IMAGE=" + CSLGetFeatDataIcon(nPending1) + ".tga";
		string sName = "RETRAIN_TEXT=" + CSLGetFeatDataName(nPending1);
		string sVari = "7=" + IntToString(nPending1);

		AddListBoxRow(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(nPending1), sName, sIcon, sVari, "");
	}

	if (nPending2 > 0)
	{
		string sIcon = "RETRAIN_IMAGE=" + CSLGetFeatDataIcon(nPending2) + ".tga";
		string sName = "RETRAIN_TEXT=" + CSLGetFeatDataName(nPending2);
		string sVari = "7=" + IntToString(nPending1);

		AddListBoxRow(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST", "RETRAINPANE_PROTO" + IntToString(nPending2), sName, sIcon, sVari, "");
	}
}
//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 5/31/2009							//
//	Title: bot9s_inc_levelup2				//
//	Description: Levelup functions for the	//
//	Book of the Nine Swords classes.		//
//////////////////////////////////////////////



// Functions

// Displays maneuvers that are chosen by the PC to gain on levelup.
void TOBDisplayAddedManeuvers(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDisplayAddedManeuvers Start", GetFirstPC() ); }
	
	string sScreen = "SCREEN_LEVELUP_MANEUVERS";
	string sListBox = "ADDED_MANEUVER_LIST";
	string sTexture, sPane, sVari, sTitle, sData, sTga;
	int nMax = GetNum2DARows("maneuvers");
	int nDW = GetLocalInt(oToB, "DWTotal");
	int nDS = GetLocalInt(oToB, "DSTotal");
	int nDM = GetLocalInt(oToB, "DMTotal");
	int nIH = GetLocalInt(oToB, "IHTotal");
	int nSS = GetLocalInt(oToB, "SSTotal");
	int nSH = GetLocalInt(oToB, "SHTotal");
	int nSD = GetLocalInt(oToB, "SDTotal");
	int nTC = GetLocalInt(oToB, "TCTotal");
	int nWR = GetLocalInt(oToB, "WRTotal");
	int nIsStance, nMastery, nMasteryOf, nDiscipline, s, m, i;

	i = 1;

	while (i <= nMax)
	{
		sData = GetLocalString(oToB, "AddedManeuver" + IntToString(i));

		if (sData != "")
		{
			nMastery = TOBGetManeuversDataMastery(i);
			nDiscipline = TOBGetManeuversDataDiscipline(i);

			switch (nDiscipline)
			{
				case DESERT_WIND:	nMasteryOf = nDW;	break;
				case DEVOTED_SPIRIT:nMasteryOf = nDS;	break;
				case DIAMOND_MIND:	nMasteryOf = nDM;	break;
				case IRON_HEART:	nMasteryOf = nIH;	break;
				case SETTING_SUN:	nMasteryOf = nSS;	break;
				case SHADOW_HAND:	nMasteryOf = nSH;	break;
				case STONE_DRAGON:	nMasteryOf = nSD;	break;
				case TIGER_CLAW:	nMasteryOf = nTC;	break;
				case WHITE_RAVEN:	nMasteryOf = nWR;	break;
			}

			if ((nMasteryOf - 1) >= nMastery) //Maneuvers count for themselves so we need to subtract one to find the true count.
			{
				nIsStance = TOBGetManeuversDataIsStance( i);

				if (nIsStance == 1)
				{
					s++;
				}
				else m++;

				sTitle = "MANEUVER_TEXT=" + TOBGetManeuversDataName(StringToInt(sData));
				sTexture = "MANEUVER_IMAGE=" + TOBGetManeuversDataIcon(StringToInt(sData))+".tga";
				sPane = "MANEUVERPANE_PROTO" + sData;
				sVari = "7=" + sData;

				AddListBoxRow(oPC, sScreen, sListBox, sPane, sTitle, sTexture, sVari, "");
			}
			else // Weeds out maneuvers we no longer meet the prereqs for.
			{
				DeleteLocalString(oToB, "AddedManeuver" + IntToString(i));
				RemoveListBoxRow(oPC, sScreen, sListBox, "MANEUVERPANE_PROTO" + sData);
				TOBPredictDisciplineStatus(nDiscipline, FALSE);
			}
		}
		i++;
	}

	int nNumber;
	int nLearn = GetLocalInt(oToB, "LevelupLearn");
	int nLearnStance = GetLocalInt(oToB, "LevelupStanceLearn");
	int nM = nLearn - m; // Possible to learn for the level minus the maneuvers that were flagged as added in the loop.
	int nS = nLearnStance - s; //Stances should never be more than one.

	SetLocalInt(oToB, "LevelupTotal", nM);
	SetLocalInt(oToB, "LevelupStance", nS);

	int nTotal = GetLocalInt(oToB, "LevelupTotal");
	int nStance = GetLocalInt(oToB, "LevelupStance");

	if (GetLocalInt(oToB, "CurrentLevelupLevel") == 0)
	{
		nNumber = nStance;
	}
	else nNumber = nTotal;

	SetGUIObjectText(oPC, "SCREEN_LEVELUP_MANEUVERS", "POINT_POOL_TEXT", -1, IntToString(nNumber));

	if ((nStance == 0) && (nTotal == 0))
	{
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", FALSE);
	}
	else SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_MANEUVERS", "CHOICE_NEXT", TRUE);
}


// Sets the PC's level of mastery based upon how many maneuvers of a certain
// discipline they have learned.  Used for determining prerequisites.
// 1 = Initiate, 2 = Novice, 3 = Adept, 4 = Veteran, 5 or more = Master.
void TOBDetermineDisciplineStatus()
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBDetermineDisciplineStatus Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = CSLGetDataStore(oPC);
	object oManeuver;
	int nManeuver, nDiscipline, nFeat;
	int nDW, nDS, nDM, nIH, nSS, nSH, nSD, nTC, nWR;

	oManeuver = GetFirstItemInInventory(oToB);

	while (GetIsObjectValid(oManeuver))
	{
		nManeuver = GetLocalInt(oManeuver, "2da");
		nDiscipline = TOBGetManeuversDataDiscipline(nManeuver);

		switch (nDiscipline)
		{
			case DESERT_WIND:	nDW += 1;	break;
			case DEVOTED_SPIRIT:nDS += 1;	break;
			case DIAMOND_MIND:	nDM += 1;	break;
			case IRON_HEART:	nIH += 1;	break;
			case SETTING_SUN:	nSS += 1;	break;
			case SHADOW_HAND:	nSH += 1;	break;
			case STONE_DRAGON:	nSD += 1;	break;
			case TIGER_CLAW:	nTC += 1;	break;
			case WHITE_RAVEN:	nWR += 1;	break;
		}
		oManeuver = GetNextItemInInventory(oToB);
	}

	SetLocalInt(oToB, "DWTotal", nDW);
	SetLocalInt(oToB, "DSTotal", nDS);
	SetLocalInt(oToB, "DMTotal", nDM);
	SetLocalInt(oToB, "IHTotal", nIH);
	SetLocalInt(oToB, "SSTotal", nSS);
	SetLocalInt(oToB, "SHTotal", nSH);
	SetLocalInt(oToB, "SDTotal", nSD);
	SetLocalInt(oToB, "TCTotal", nTC);
	SetLocalInt(oToB, "WRTotal", nWR);

	// Add Maneuver Rank Feats
	if ((nDW > 0) && (!GetHasFeat(FEAT_DW_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_INITIATE, TRUE);
	}

	if ((nDW > 1) && (!GetHasFeat(FEAT_DW_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_NOVICE, TRUE);
	}

	if ((nDW > 2) && (!GetHasFeat(FEAT_DW_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_ADEPT, TRUE);
	}

	if ((nDW > 3) && (!GetHasFeat(FEAT_DW_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_VETERAN, TRUE);
	}

	if ((nDW > 4) && (!GetHasFeat(FEAT_DW_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DW_MASTER, TRUE);
	}
	
	if ((nDS > 0) && (!GetHasFeat(FEAT_DS_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_INITIATE, TRUE);
	}

	if ((nDS > 1) && (!GetHasFeat(FEAT_DS_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_NOVICE, TRUE);
	}

	if ((nDS > 2) && (!GetHasFeat(FEAT_DS_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_ADEPT, TRUE);
	}

	if ((nDS > 3) && (!GetHasFeat(FEAT_DS_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_VETERAN, TRUE);
	}

	if ((nDS > 4) && (!GetHasFeat(FEAT_DS_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DS_MASTER, TRUE);
	}
	
	if ((nDM > 0) && (!GetHasFeat(FEAT_DM_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_INITIATE, TRUE);
	}

	if ((nDM > 1) && (!GetHasFeat(FEAT_DM_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_NOVICE, TRUE);
	}

	if ((nDM > 2) && (!GetHasFeat(FEAT_DM_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_ADEPT, TRUE);
	}

	if ((nDM > 3) && (!GetHasFeat(FEAT_DM_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_VETERAN, TRUE);
	}

	if ((nDM> 4) && (!GetHasFeat(FEAT_DM_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_DM_MASTER, TRUE);
	}
	
	if ((nIH > 0) && (!GetHasFeat(FEAT_IH_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_INITIATE, TRUE);
	}

	if ((nIH > 1) && (!GetHasFeat(FEAT_IH_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_NOVICE, TRUE);
	}

	if ((nIH > 2) && (!GetHasFeat(FEAT_IH_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_ADEPT, TRUE);
	}

	if ((nIH > 3) && (!GetHasFeat(FEAT_IH_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_VETERAN, TRUE);
	}

	if ((nIH > 4) && (!GetHasFeat(FEAT_IH_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_IH_MASTER, TRUE);
	}
	
	if ((nSS > 0) && (!GetHasFeat(FEAT_SS_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_INITIATE, TRUE);
	}

	if ((nSS > 1) && (!GetHasFeat(FEAT_SS_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_NOVICE, TRUE);
	}

	if ((nSS > 2) && (!GetHasFeat(FEAT_SS_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_ADEPT, TRUE);
	}

	if ((nSS > 3) && (!GetHasFeat(FEAT_SS_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_VETERAN, TRUE);
	}

	if ((nSS > 4) && (!GetHasFeat(FEAT_SS_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SS_MASTER, TRUE);
	}
	
	if ((nSH > 0) && (!GetHasFeat(FEAT_SH_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_INITIATE, TRUE);
	}

	if ((nSH > 1) && (!GetHasFeat(FEAT_SH_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_NOVICE, TRUE);
	}

	if ((nSH > 2) && (!GetHasFeat(FEAT_SH_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_ADEPT, TRUE);
	}

	if ((nSH > 3) && (!GetHasFeat(FEAT_SH_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_VETERAN, TRUE);
	}

	if ((nSH > 4) && (!GetHasFeat(FEAT_SH_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SH_MASTER, TRUE);
	}
	
	if ((nSD > 0) && (!GetHasFeat(FEAT_SD_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_INITIATE, TRUE);
	}

	if ((nSD > 1) && (!GetHasFeat(FEAT_SD_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_NOVICE, TRUE);
	}

	if ((nSD > 2) && (!GetHasFeat(FEAT_SD_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_ADEPT, TRUE);
	}

	if ((nSD > 3) && (!GetHasFeat(FEAT_SD_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_VETERAN, TRUE);
	}

	if ((nSD > 4) && (!GetHasFeat(FEAT_SD_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_SD_MASTER, TRUE);
	}
	
	if ((nTC > 0) && (!GetHasFeat(FEAT_TC_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_INITIATE, TRUE);
	}

	if ((nTC > 1) && (!GetHasFeat(FEAT_TC_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_NOVICE, TRUE);
	}

	if ((nTC > 2) && (!GetHasFeat(FEAT_TC_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_ADEPT, TRUE);
	}

	if ((nTC > 3) && (!GetHasFeat(FEAT_TC_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_VETERAN, TRUE);
	}

	if ((nTC > 4) && (!GetHasFeat(FEAT_TC_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_TC_MASTER, TRUE);
	}
	
	if ((nWR > 0) && (!GetHasFeat(FEAT_WR_INITIATE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_INITIATE, TRUE);
	}

	if ((nWR > 1) && (!GetHasFeat(FEAT_WR_NOVICE, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_NOVICE, TRUE);
	}

	if ((nWR > 2) && (!GetHasFeat(FEAT_WR_ADEPT, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_ADEPT, TRUE);
	}

	if ((nWR > 3) && (!GetHasFeat(FEAT_WR_VETERAN, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_VETERAN, TRUE);
	}

	if ((nWR > 4) && (!GetHasFeat(FEAT_WR_MASTER, oPC)))
	{
		nFeat = FeatAdd(oPC, FEAT_WR_MASTER, TRUE);
	}

	// Remove Maneuver Rank Feats
	if ((nDW < 5) && (GetHasFeat(FEAT_DW_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_MASTER);
	}

	if ((nDW < 4) && (GetHasFeat(FEAT_DW_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_VETERAN);
	}

	if ((nDW < 3) && (GetHasFeat(FEAT_DW_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_ADEPT);
	}

	if ((nDW < 2) && (GetHasFeat(FEAT_DW_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_NOVICE);
	}

	if ((nDW < 1) && (GetHasFeat(FEAT_DW_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_DW_INITIATE);
	}

	if ((nDS < 5) && (GetHasFeat(FEAT_DS_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_MASTER);
	}

	if ((nDS < 4) && (GetHasFeat(FEAT_DS_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_VETERAN);
	}
	
	if ((nDS < 3) && (GetHasFeat(FEAT_DS_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_ADEPT);
	}
	
	if ((nDS < 2) && (GetHasFeat(FEAT_DS_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_NOVICE);
	}
	
	if ((nDS < 1) && (GetHasFeat(FEAT_DS_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_DS_INITIATE);
	}

	if ((nDM < 5) && (GetHasFeat(FEAT_DM_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_MASTER);
	}
	
	if ((nDM < 4) && (GetHasFeat(FEAT_DM_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_VETERAN);
	}
	
	if ((nDM < 3) && (GetHasFeat(FEAT_DM_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_ADEPT);
	}
	
	if ((nDM < 2) && (GetHasFeat(FEAT_DM_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_NOVICE);
	}
	
	if ((nDM < 1) && (GetHasFeat(FEAT_DM_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_DM_INITIATE);
	}

	if ((nIH < 5) && (GetHasFeat(FEAT_IH_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_MASTER);
	}

	if ((nIH < 4) && (GetHasFeat(FEAT_IH_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_VETERAN);
	}

	if ((nIH < 3) && (GetHasFeat(FEAT_IH_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_ADEPT);
	}

	if ((nIH < 2) && (GetHasFeat(FEAT_IH_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_NOVICE);
	}

	if ((nIH < 1) && (GetHasFeat(FEAT_IH_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_IH_INITIATE);
	}

	if ((nSS < 5) && (GetHasFeat(FEAT_SS_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_MASTER);
	}

	if ((nSS < 4) && (GetHasFeat(FEAT_SS_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_VETERAN);
	}

	if ((nSS < 3) && (GetHasFeat(FEAT_SS_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_ADEPT);
	}

	if ((nSS < 2) && (GetHasFeat(FEAT_SS_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_NOVICE);
	}

	if ((nSS < 1) && (GetHasFeat(FEAT_SS_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_SS_INITIATE);
	}

	if ((nSH < 5) && (GetHasFeat(FEAT_SH_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_MASTER);
	}

	if ((nSH < 4) && (GetHasFeat(FEAT_SH_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_VETERAN);
	}

	if ((nSH < 3) && (GetHasFeat(FEAT_SH_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_ADEPT);
	}

	if ((nSH < 2) && (GetHasFeat(FEAT_SH_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_NOVICE);
	}

	if ((nSH < 1) && (GetHasFeat(FEAT_SH_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_SH_INITIATE);
	}

	if ((nSD < 5) && (GetHasFeat(FEAT_SD_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_MASTER);
	}

	if ((nSD < 4) && (GetHasFeat(FEAT_SD_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_VETERAN);
	}

	if ((nSD < 3) && (GetHasFeat(FEAT_SD_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_ADEPT);
	}

	if ((nSD < 2) && (GetHasFeat(FEAT_SD_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_NOVICE);
	}

	if ((nSD < 1) && (GetHasFeat(FEAT_SD_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_SD_INITIATE);
	}

	if ((nTC < 5) && (GetHasFeat(FEAT_TC_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_MASTER);
	}

	if ((nTC < 4) && (GetHasFeat(FEAT_TC_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_VETERAN);
	}

	if ((nTC < 3) && (GetHasFeat(FEAT_TC_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_ADEPT);
	}

	if ((nTC < 2) && (GetHasFeat(FEAT_TC_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_NOVICE);
	}

	if ((nTC < 1) && (GetHasFeat(FEAT_TC_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_TC_INITIATE);
	}

	if ((nWR < 5) && (GetHasFeat(FEAT_WR_MASTER, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_MASTER);
	}

	if ((nWR < 4) && (GetHasFeat(FEAT_WR_VETERAN, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_VETERAN);
	}

	if ((nWR < 3) && (GetHasFeat(FEAT_WR_ADEPT, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_ADEPT);
	}

	if ((nWR < 2) && (GetHasFeat(FEAT_WR_NOVICE, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_NOVICE);
	}

	if ((nWR < 1) && (GetHasFeat(FEAT_WR_INITIATE, oPC)))
	{
		FeatRemove(oPC, FEAT_WR_INITIATE);
	}
}



int TOBGetStrike(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBGetStrike Start", GetFirstPC() ); }
	
	int nMaxStrike = GetLocalInt(oToB, "HighStrike");
	int nAction = GetCurrentAction(oPC);
	int nStrike, nOk;

	nOk = 1;
	nStrike = GetLocalInt(oToB, "Strike1");//Always return this value.

	// Sanity checks.  A couple of these conditions should never occur, but I'm seeing if paranoia helps.
	if (GetCurrentHitPoints(oPC) < 1)
	{
		nOk = 0;
	}
	else if (nAction == ACTION_ATTACKOBJECT || nAction == ACTION_MOVETOPOINT) //Indicates that an attack or move action has been called which means that the strike will hang unless we clear it out.
	{
		nOk = 0;
	}
	else
	{
		effect eSuck;

		eSuck = GetFirstEffect(oPC);

		while (GetIsEffectValid(eSuck)) // In order to initiate a maneuver the player must be able to move(ToB p.38).
		{
			if (GetEffectType(eSuck) == EFFECT_TYPE_CHARMED || GetEffectType(eSuck) == EFFECT_TYPE_CONFUSED || GetEffectType(eSuck) == EFFECT_TYPE_CUTSCENE_PARALYZE
			|| GetEffectType(eSuck) == EFFECT_TYPE_DAZED || GetEffectType(eSuck) == EFFECT_TYPE_DOMINATED
			|| GetEffectType(eSuck) == EFFECT_TYPE_ENTANGLE || GetEffectType(eSuck) == EFFECT_TYPE_FRIGHTENED
			|| GetEffectType(eSuck) == EFFECT_TYPE_PARALYZE || GetEffectType(eSuck) == EFFECT_TYPE_PETRIFY
			|| GetEffectType(eSuck) == EFFECT_TYPE_STUNNED || GetEffectType(eSuck) == EFFECT_TYPE_TIMESTOP)
			{
				nOk = 0;
				break;
			}

			eSuck = GetNextEffect(oPC);
		}
	}

	if (nOk == 1)
	{
		int i, nNewStrike;
	
		i = 1;
	
		while (i <= nMaxStrike)
		{
			nNewStrike = GetLocalInt(oToB, "Strike" + IntToString(i + 1));
	
			if (nNewStrike > 0) // Move everything down one.
			{
				SetLocalInt(oToB, "Strike" + IntToString(i), nNewStrike);
			}
			else DeleteLocalInt(oToB, "Strike" + IntToString(i));
	
			i++;
		}
	}
	else // Clear out everything.
	{
		int i;

		i = 1;

		while (GetLocalInt(oToB, "Strike" + IntToString(i)) > 0)
		{
			DeleteLocalInt(oToB, "Strike" + IntToString(i));
			i++;
		}
		nStrike = 0;

		ClearAllActions();
	}

	return nStrike;
}


// from gui_tob_execute_strike

void TOBStrikeInRange(object oPC, object oToB, object oTarget, float fRange, int nTarget, int nRow, int nLocation, float fPosX, float fPosY, float fPosZ)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBStrikeInRange Start", GetFirstPC() ); }
	
	location lPC = GetLocation(oPC);
	location lMelee = GetLocalLocation(oPC, "bot9s_pc_pos_strike");
	
	if (lPC == lMelee) // The player has come to a stop.
	{
		float fSize = CSLGetGirth(oTarget);
		float fHitDist = CSLGetHitDistance(oTarget);

		if ((GetDistanceToObject(oTarget) - fSize) <= (fRange + fHitDist)) // Is the player in attack range of the target?
		{
			if (nLocation == 1) // Object or Location as the target?
			{
				TOBIndexManeuverPosition(oPC, nRow, fPosX, fPosY, fPosZ);
			}
			else if (IntToObject(nTarget) == OBJECT_INVALID)
			{
				return;
			}
			else TOBIndexStrikeTarget(oToB, nRow, oTarget);
	
			SetLocalInt(oToB, "StrikeMoveStatus", 0);
			//AssignCommand(oPC, TOBSetStrike(nRow));
			ActionUseFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC);
		}
		else // The player stopped, but wasn't in range of the target.  Clear out the action queue so that we can attempt the maneuver again.
		{
			SetLocalInt(oToB, "StrikeMoveStatus", 0);
			ClearAllActions();
			TOBClearStrikes();
		}
	}
	
	if (GetLocalInt(oToB, "StrikeMoveStatus") == 1)
	{
		DelayCommand(0.3f, TOBStrikeInRange(oPC, oToB, oTarget, fRange, nTarget, nRow, nLocation, fPosX, fPosY, fPosZ));
	}
}
		
void TOBRunPCStrikePosition(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRunPCStrikePosition Start", GetFirstPC() ); }
	
	location lPC = GetLocation(oPC);
	object oToB = CSLGetDataStore(oPC);

	if (GetLocalInt(oToB, "StrikeMoveStatus") == 1)
	{
		SetLocalLocation(oPC, "bot9s_pc_pos_strike", lPC);
		DelayCommand(0.3f, TOBRunPCStrikePosition(oPC, oToB));
	}
	else DeleteLocalLocation(oPC, "bot9s_pc_pos_strike");
}


// Removes the speed bonus and AC pentaly for the charge action.
void TOBRemoveChargeSpeed(object oPC)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRemoveChargeSpeed Start", GetFirstPC() ); }
	
	effect eTest; // Remove the speed effect since we've come to a stop.
	int nSpell;

	eTest = GetFirstEffect(oPC);

	while (GetIsEffectValid(eTest))
	{
		nSpell = GetEffectSpellId(eTest);
		
		if (nSpell == 6561)
		{
			RemoveEffect(oPC, eTest);
			eTest = GetFirstEffect(oPC); // Helps to clean out supernatural effects all the way.  Or so I hear.
		}
		else eTest = GetNextEffect(oPC);
	}
}

void TOBRunCharge(object oPC, object oToB, object oTarget, float fStart, float fRange)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRunCharge Start", GetFirstPC() ); }
	
	location lPC = GetLocation(oPC);
	location lCharge = GetLocalLocation(oPC, "bot9s_pc_pos_charge");
	vector vCharge = GetPositionFromLocation(lCharge);
	float fCharge = vCharge.z;

	effect eSpeed = EffectMovementSpeedIncrease(99);
	effect eAC = EffectACDecrease(2);
	effect eCharge = EffectLinkEffects(eAC, eSpeed);
	eCharge = SupernaturalEffect(eCharge);
	eCharge = SetEffectSpellId(eCharge, 6561); //Placeholder ID in spells.2da so that the effect can be removed properly.

	float fSize = CSLGetGirth(oTarget);
	float fDist = fRange + fSize;

	if ((GetLocalInt(oToB, "ChargeStatus") == 1) && (lPC != lCharge) && (GetLocalInt(oToB, "ChargeSpeedCheck") == 0))
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0f);
		SetLocalInt(oToB, "ChargeSpeedCheck", 1);
	}

	if (lPC == lCharge)// The player has come to a stop.
	{
		if (GetDistanceToObject(oTarget) <= fDist)
		{
			TOBRemoveChargeSpeed(oPC);
			SetLocalInt(oToB, "ChargeStatus", 0);
			SetLocalInt(oToB, "ChargeSpeedCheck", 0);
			TOBSetStrike(211);
			ActionUseFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC);
		}
		else // The player stopped, but wasn't in range of the target. Clear out the action queue so that we can attempt the maneuver again.
		{
			TOBRemoveChargeSpeed(oPC);
			DeleteLocalInt(oToB, "ChargeStatus");
			DeleteLocalInt(oToB, "ChargeSpeedCheck");
			ClearAllActions();
			TOBClearStrikes();
		}
	}
	else if ((fCharge < fStart - 0.25f) || (fCharge > fStart + 0.25f)) //Acounts for small bumps that aren't technically what you'd call 'rough terrain'.
	{
		TOBRemoveChargeSpeed(oPC);
		SetLocalInt(oToB, "ChargeStatus", 0);
		SetLocalInt(oToB, "ChargeSpeedCheck", 0);
		ClearAllActions();
		TOBClearStrikes();
		SendMessageToPC(oPC, "<color=red>You cannot charge over uneven terrain.</color>");
	}

	if ((GetLocalInt(oToB, "ChargeStatus") == 1) && (lPC != lCharge))
	{
		DelayCommand(0.3f, TOBRunCharge(oPC, oToB, oTarget, fStart, fRange));
	}
	else SetLocalInt(oToB, "ChargeSpeedCheck", 0);
}



void TOBChargeRules(object oPC, object oToB, object oTarget, float fStart, float fRange, int nTarget, int nRow, int nLocation, float fPosX, float fPosY, float fPosZ)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBChargeRules Start", GetFirstPC() ); }
	
	string sManeuver = GetFirstName(oPC) + TOBGetManeuversDataScript(nRow);
	object oManeuver = GetObjectByTag(sManeuver);
	int nSupressAoO = GetLocalInt(oManeuver, "SupressAoO");
	
	location lPC = GetLocation(oPC);
	location lCharge = GetLocalLocation(oPC, "bot9s_pc_pos_charge");
	vector vCharge = GetPositionFromLocation(lCharge);
	float fCharge = vCharge.z;
	
	effect eSpeed = EffectMovementSpeedIncrease(99);
	effect eAC = EffectACDecrease(2);
	effect eCharge = EffectLinkEffects(eAC, eSpeed);
	eCharge = SupernaturalEffect(eCharge);
	eCharge = SetEffectSpellId(eCharge, 6561); //Placeholder ID in spells.2da so that the effect can be removed properly.

	float fSize = CSLGetGirth(oTarget);
	float fHitDist = CSLGetHitDistance(oTarget) + fSize;
	float fDist = fRange + fHitDist;

	if ((GetLocalInt(oToB, "ChargeStatus") == 1) && (lPC != lCharge) && (GetLocalInt(oToB, "ChargeSpeedCheck") == 0))
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharge, oPC, 6.0f);
		SetLocalInt(oToB, "ChargeSpeedCheck", 1);
	}

	if (lPC == lCharge) // The player has come to a stop.
	{
		if (GetDistanceToObject(oTarget) <= fDist)
		{
			if (nSupressAoO == 1)
			{
				if ((!IsInConversation(oPC)) || (GetNumCutsceneActionsPending() == 0))
				{
					ClearCombatOverrides(oPC);
				}
			}
	
			if (nLocation == 1) // Object or Location as the target?
			{
				TOBIndexManeuverPosition(oPC, nRow, fPosX, fPosY, fPosZ);
			}
			else if (IntToObject(nTarget) == OBJECT_INVALID)
			{
				return;
			}
			else TOBIndexStrikeTarget(oToB, nRow, oTarget);

			TOBRemoveChargeSpeed(oPC);
			DeleteLocalInt(oToB, "ChargeStatus");
			DeleteLocalInt(oToB, "ChargeSpeedCheck");
			AssignCommand(oPC, TOBSetStrike(nRow));
			ActionUseFeat(FEAT_STUDENT_OF_THE_SUBLIME_WAY, oPC);
		}
		else // The player stopped, but wasn't in range of the target.  Clear out the action queue so that we can attempt the maneuver again.
		{
			TOBRemoveChargeSpeed(oPC);
			DeleteLocalInt(oToB, "ChargeStatus");
			DeleteLocalInt(oToB, "ChargeSpeedCheck");
			ClearAllActions();
			TOBClearStrikes();
		}
	}
	else if ((fCharge < fStart - 0.25f) || (fCharge > fStart + 0.25f)) //Accounts for small bumps that aren't technically what you'd call 'rough terrain'.
	{
		if (nSupressAoO == 1)
		{
			if ((!IsInConversation(oPC)) || (GetNumCutsceneActionsPending() == 0))
			{
				ClearCombatOverrides(oPC);
			}
		}

		if (!TOBCheckStanceChargeRules(oPC))
		{
			TOBRemoveChargeSpeed(oPC);
			ActionForceMoveToLocation(GetLocation(oPC));
			DeleteLocalInt(oToB, "ChargeStatus");
			DeleteLocalInt(oToB, "ChargeSpeedCheck");
			ClearAllActions();
			TOBClearStrikes();
			SendMessageToPC(oPC, "<color=red>You cannot charge over uneven terrain.</color>");
		}
	}
	
	if ((GetLocalInt(oToB, "ChargeStatus") == 1) && (lPC != lCharge))
	{
		DelayCommand(0.3f, TOBChargeRules(oPC, oToB, oTarget, fStart, fRange, nTarget, nRow, nLocation, fPosX, fPosY, fPosZ));
	}
	else SetLocalInt(oToB, "ChargeSpeedCheck", 0);
}

void TOBRunPCChargePosition(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID )
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRunPCChargePosition Start", GetFirstPC() ); }
	
	location lPC = GetLocation(oPC);
	if ( !GetIsObjectValid( oToB ) )
	{
		oToB = CSLGetDataStore(oPC);
	}
	
	if (GetLocalInt(oToB, "ChargeStatus") == 1)
	{
		SetLocalLocation(oPC, "bot9s_pc_pos_charge", lPC);
		DelayCommand(0.3f, TOBRunPCChargePosition(oPC, oToB));
	}
	else DeleteLocalLocation(oPC, "bot9s_pc_pos_charge");
}





void TOBWBLRecoverAllManeuvers(object oPC, object oToB, string sScreen)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBWBLRecoverAllManeuvers Start", GetFirstPC() ); }
	
	string sClass = GetStringRight(sScreen, 3);

	if (GetLocalInt(oToB, "BlueBoxSTR1" + sClass) > 0) // The extra checks improve preformance.
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR11" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_ELEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR12" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWELVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR13" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_THIRTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR14" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FOURTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR15" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_FIFTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR16" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SIXTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR17" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_SEVENTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR18" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_EIGHTEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR19" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_NINETEEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxSTR20" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "STRIKE_TWENTY", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxB10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "BOOST_TEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC1" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_ONE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC2" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TWO", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC3" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_THREE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC4" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FOUR", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC5" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_FIVE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC6" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SIX", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC7" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_SEVEN", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC8" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_EIGHT", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC9" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_NINE", FALSE);
	}

	if (GetLocalInt(oToB, "BlueBoxC10" + sClass) > 0)
	{
		SetGUIObjectDisabled(oPC, sScreen, "COUNTER_TEN", FALSE);
	}
}

void TOBWarbladeRecovery(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBWarbladeRecovery Start", GetFirstPC() ); }
	
	vector vStart = GetPosition(oPC);

	TOBRunSwiftAction(222, "");
	SetGUIObjectDisabled(oPC, "SCREEN_MARTIAL_MENU_WB", "RECOVERY_IMAGE", TRUE);
	DelayCommand(6.0f, SetGUIObjectDisabled(oPC, "SCREEN_MARTIAL_MENU_WB", "RECOVERY_IMAGE", FALSE));
	DelayCommand(6.0f, TOBWBLRecoverAllManeuvers(oPC, oToB, "SCREEN_QUICK_STRIKE_WB"));

	if ((GetHasFeat(FEAT_VITAL_RECOVERY, oPC)) && (GetLocalInt(oToB, "VitalRecovery") == 0))
	{
		int nMax = GetMaxHitPoints(oPC);
		int nHP = GetCurrentHitPoints(oPC);

		if (nHP < nMax) // Won't heal when we're at full HP.
		{
			int nHitDice = GetHitDice(oPC);
			effect eHeal = TOBManeuverHealing(oPC, 3 + nHitDice);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
			SetLocalInt(oToB, "VitalRecovery", 1);
		}
	}
}



void TOBAddLevel(object oPC, object oToB, string sClassType)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBAddLevel Start", GetFirstPC() ); }
	
	int nManeuvers = CSLCountNumberOfItemsInContainer(oToB);

	object oManeuver;
	int i, v;
	int nClassType;

	if (sClassType == "CR") // pulled off the second parameter of the gui
	{
		nClassType = CLASS_TYPE_CRUSADER;
	}
	else if (sClassType == "SA")
	{
		nClassType = CLASS_TYPE_SAINT;
	}
	else if (sClassType == "SS")
	{
		nClassType = CLASS_TYPE_SWORDSAGE;
	}
	else if (sClassType == "WB")
	{
		nClassType = CLASS_TYPE_WARBLADE;
	}
	else nClassType = CLASS_TYPE_INVALID;

	// Only run this when there's a reason to.
	//object oToB = CSLGetDataStore(oPC);
	if ( GetIsObjectValid(oToB) ) /* && (GetLocalInt(oToB, "CheckListboxStatus") == 0)*/
	{
		oManeuver = GetFirstItemInInventory(oToB);

		i = 1;	// counts rows per level
		v = 0;	// counts items in oToB to prevent an infinite loop

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 0)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 0, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 0)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{//set in TOBPopulateBot9sMenu to correctly assign row numbers to the listboxes
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}
		// reset values for the next loop
		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 1)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 1, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 1)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 2)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 2, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 2)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 3)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 3, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 3)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 4)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 4, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 4)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 5)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 5, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 5)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 6)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 6, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 6)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 7)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 7, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 7)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 8)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 8, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 8)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}

		i = 1;
		v = 0;
		oManeuver = GetFirstItemInInventory(oToB);

		while (v < nManeuvers + 1)
		{
			if (GetLocalInt(oManeuver, "Level") == 9)
			{
				TOBPopulateBot9sMenu(oPC, oManeuver, 9, i, nClassType);
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}
			else if (GetLocalInt(oManeuver, "Level") != 9)
			{
				oManeuver = GetNextItemInInventory(oToB);
				v++;
			}

			if (GetLocalInt(oToB, "CheckI") == 2)
			{
				i++;
				SetLocalInt(oToB, "CheckI", 1);
			}
		}
	}
}

void TOBAddReadied(object oPC, object oToB, string sClassType)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBAddReadied Start", GetFirstPC() ); }
	
	string sClass;

	if (sClassType == "CR") // pulled off the second parameter of the gui
	{
		sClass = "_CR";
	}
	else if (sClassType == "SA")
	{
		sClass = "_SA";
	}
	else if (sClassType == "SS")
	{
		sClass = "_SS";
	}
	else if (sClassType == "WB")
	{
		sClass = "_WB";
	}
	else sClass = "___";

	if (  GetIsObjectValid(oToB)  )/* && (GetLocalInt(oToB, "CheckListboxStatus") == 0)*/
	{
		string sRed1 = GetLocalString(oToB, "Readied1" + sClass);
		string sRed2 = GetLocalString(oToB, "Readied2" + sClass);
		string sRed3 = GetLocalString(oToB, "Readied3" + sClass);
		string sRed4 = GetLocalString(oToB, "Readied4" + sClass);
		string sRed5 = GetLocalString(oToB, "Readied5" + sClass);
		string sRed6 = GetLocalString(oToB, "Readied6" + sClass);
		string sRed7 = GetLocalString(oToB, "Readied7" + sClass);
		string sRed8 = GetLocalString(oToB, "Readied8" + sClass);
		string sRed9 = GetLocalString(oToB, "Readied9" + sClass);
		string sRed10 = GetLocalString(oToB, "Readied10" + sClass);
		string sRed11 = GetLocalString(oToB, "Readied11" + sClass);
		string sRed12 = GetLocalString(oToB, "Readied12" + sClass);
		string sRed13 = GetLocalString(oToB, "Readied13" + sClass);
		string sRed14 = GetLocalString(oToB, "Readied14" + sClass);
		string sRed15 = GetLocalString(oToB, "Readied15" + sClass);
		string sRed16 = GetLocalString(oToB, "Readied16" + sClass);

		if (sClass == "_SS")
		{
			string sRed17 = GetLocalString(oToB, "Readied17" + sClass);

			if (sRed17 != "")
			{
				int nRow17 = GetLocalInt(oToB, "ReadiedRow17" + sClass);
				string sIcon17 = "RED_17=" + GetLocalString(oToB, "maneuvers_ICON" + IntToString(nRow17)) + ".tga";

				AddListBoxRow(oPC, "SCREEN_MANEUVERS_READIED_SS", "READIED_17", "RED_PANE_17", "", sIcon17, sRed17, "");

				if (GetLocalInt(oToB, "Readied17_SSDisabled") == 1)
				{
					SetGUIObjectDisabled(oPC, "SCREEN_MANEUVERS_READIED_SS", "READIED_17", FALSE);
				}
			}
		}

		TOBPopulateManeuverReadied(sRed1, sClass, "1");
		TOBPopulateManeuverReadied(sRed2, sClass, "2");
		TOBPopulateManeuverReadied(sRed3, sClass, "3");
		TOBPopulateManeuverReadied(sRed4, sClass, "4");
		TOBPopulateManeuverReadied(sRed5, sClass, "5");
		TOBPopulateManeuverReadied(sRed6, sClass, "6");
		TOBPopulateManeuverReadied(sRed7, sClass, "7");
		TOBPopulateManeuverReadied(sRed8, sClass, "8");
		TOBPopulateManeuverReadied(sRed9, sClass, "9");
		TOBPopulateManeuverReadied(sRed10, sClass, "10");
		TOBPopulateManeuverReadied(sRed11, sClass, "11");
		TOBPopulateManeuverReadied(sRed12, sClass, "12");
		TOBPopulateManeuverReadied(sRed13, sClass, "13");
		TOBPopulateManeuverReadied(sRed14, sClass, "14");
		TOBPopulateManeuverReadied(sRed15, sClass, "15");
		TOBPopulateManeuverReadied(sRed16, sClass, "16");
	}
}


void TOBPhase1(object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBPhase1 Start", GetFirstPC() ); }
	
	DeleteLocalInt(oToB, "HaltRetrainFeats");
	DeleteLocalInt(oToB, "RetrainLoopCheck");
	DeleteLocalInt(oToB, "CurrentLevelupLevel");
	DeleteLocalInt(oToB, "LevelupClass");
	DeleteLocalInt(oToB, "LevelupStance");
	DeleteLocalInt(oToB, "LevelupStanceLearn");
	DeleteLocalInt(oToB, "LevelupRetrain");
	DeleteLocalInt(oToB, "LevelupLearn");
	DeleteLocalInt(oToB, "LevelupTotal");
	DeleteLocalInt(oToB, "RetrainManeuver");
	DeleteLocalInt(oToB, "FeatRetrainPhase");
	DeleteLocalInt(oToB, "FeatRetrainAmount");
	DeleteLocalInt(oToB, "AvialableToRetrain");
	DeleteLocalInt(oToB, "FeatRetrain1");
	DeleteLocalInt(oToB, "FeatRetrain2");
	DeleteLocalInt(oToB, "PendingFeat1");
	DeleteLocalInt(oToB, "PendingFeat2");
	DeleteLocalInt(oToB, "SSInsightSwitch");
	DeleteLocalInt(oToB, "MStudy1Pending");
	DeleteLocalInt(oToB, "MStudy2Pending");
	DeleteLocalInt(oToB, "MStudy3Pending");
	DeleteLocalInt(oToB, "MStance1Pending");
	DeleteLocalInt(oToB, "MStance2Pending");
	DeleteLocalInt(oToB, "MStance3Pending");
}

void TOBPhase2(object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBPhase2 Start", GetFirstPC() ); }
	
	if (GetLocalInt(oToB, "ManeuversCreated") == 1)
	{
		int nMax = GetNum2DARows("maneuvers");
		int i;

		i = 1;

		while (i < nMax)
		{
			DeleteLocalString(oToB, "AddedManeuver" + IntToString(i));
			i++;
		}

		DeleteLocalInt(oToB, "ManeuversCreated");
		TOBDetermineDisciplineStatus();
	}
	else DelayCommand(0.1f, TOBPhase2(oToB));
}


void TOBShowManeuver(int n, string s2da)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBShowManeuver Start", GetFirstPC() ); }
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	object oToB = CSLGetDataStore(oPC);
	string sName = TOBGetManeuversDataName(StringToInt(s2da));
	string sTga = TOBGetManeuversDataIcon(StringToInt(s2da));

	string sTextures = "MANEUVER_IMAGE=" + sTga;
	string sText = "MANEUVER_TEXT=" + sName;
	string sVari = "7=" + s2da;

	AddListBoxRow(oPC, "SCREEN_TOB_PRIMER", "SHOWN_MANEUVER_LIST", "MANEUVERPANE_PROTO" + IntToString(n), sText, sTextures + ".tga", sVari, "");
}


void TOBRunForcedClosed(object oMartialAdept)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRunForcedClosed Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oCheck = GetControlledCharacter(oPC);

	if (oCheck == oMartialAdept)
	{
		object oToB = CSLGetDataStore(oPC);
		int nAdaptive = GetLocalInt(oToB, "AdaptiveStyle");

		SetLocalInt(oToB, "Is9SMenuActive_CR", 1);
		SetLocalInt(oToB, "RedCrusader", 1);
		SetLocalInt(oToB, "CR_ForcedClose", 0);
		DisplayGuiScreen(oCheck, "SCREEN_MANEUVERS_READIED_CR", FALSE, "maneuvers_readied_cr.xml");
		DisplayGuiScreen(oCheck, "SCREEN_MANEUVERS_KNOWN_CR", FALSE, "maneuvers_known_cr.xml");

		if (nAdaptive == 1)
		{
			SetLocalInt(oToB, "AS_HaltCrCycle", 1); // Red Light on the Crusader's recovery method.
			SetLocalInt(oToB, "RedCrusader", 1);
			SetLocalInt(oToB, "EncounterR1", 0);
		}
	}
	else DelayCommand(0.1f, TOBRunForcedClosed(oMartialAdept));
}

void TOBRunScreenCheck(object oMartialAdept, string sClass)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBRunScreenCheck Start", GetFirstPC() ); }
	
	object oPC = OBJECT_SELF;
	object oCheck = GetControlledCharacter(oPC);
	object oToB = CSLGetDataStore(oMartialAdept);
	int nAdaptive = GetLocalInt(oToB, "AdaptiveStyle");
	int nOnOff = GetLocalInt(oToB, "Is9SMenuActive" + sClass);
	int nCloseValid;

	nCloseValid = 0;

	if ((sClass == "_CR") && (nOnOff == 1) && (oCheck == oMartialAdept) && (GetIsInCombat(oMartialAdept)) && (nAdaptive == 1))
	{
		nCloseValid = 0;
		SetLocalInt(oToB, "AS_HaltCrCycle", 1); // Red Light on the Crusader's recovery method.
		SetLocalInt(oToB, "RedCrusader", 1);
		SetLocalInt(oToB, "EncounterR1", 0);
	}
	else if ((sClass == "_CR") && (nOnOff == 1) && (oCheck == oMartialAdept) && (GetIsInCombat(oMartialAdept)) && (!TOBCheckRedCrusader(oMartialAdept, oToB)))
	{
		nCloseValid = 0;
	}
	else if ((sClass == "_CR") && (nOnOff == 1) && (oCheck != oMartialAdept))
	{
		nCloseValid = 1;
		SetLocalInt(oToB, "CR_ForcedClose", 1);
		SetLocalInt(oToB, "DisableQuickstrike", 0);
		TOBRunForcedClosed(oMartialAdept);
	}
	else if (!GetIsObjectValid(oToB))
	{
		nCloseValid = 1;
	}
	else if (nOnOff == 1)
	{
		if (oCheck != oMartialAdept)
		{
			nCloseValid = 1;
		}
		else if ((GetIsInCombat(oMartialAdept)) && (nAdaptive == 0))
		{
			nCloseValid = 1;
		}
	}
	else nCloseValid = 0;

	if (nCloseValid == 1)
	{
		if (sClass == "_CR")
		{
			SetLocalInt(oToB, "RedCrusader", 0);

			if (nAdaptive == 1) // Sometimes it will happen.
			{
				SetLocalInt(oToB, "CrusaderActive", 0);
				SetLocalInt(oMartialAdept, "CrusaderActive", 0);
				SetLocalInt(oToB, "AdaptiveStyle", 0);
				SetLocalInt(oToB, "DisableQuickstrike", 0);
				SetLocalInt(oToB, "AS_HaltCrCycle", 0); // Green Light on the Crusader's recovery method.
				DelayCommand(0.1f, ExecuteScript("TB_crusaderecov", oPC));
			}
		}

		if (sClass == "___")
		{
			SetLocalInt(oToB, "Is9SMenuActive___", 0);
			CloseGUIScreen(oCheck, "SCREEN_MANEUVERS_KNOWN");
			CloseGUIScreen(oCheck, "SCREEN_MANEUVERS_READIED");
		}
		else
		{
			SetLocalInt(oToB, "Is9SMenuActive" +sClass, 0);
			CloseGUIScreen(oCheck, "SCREEN_MANEUVERS_KNOWN" + sClass);
			CloseGUIScreen(oCheck, "SCREEN_MANEUVERS_READIED" + sClass);
		}
	}
	else DelayCommand(0.1f, TOBRunScreenCheck(oMartialAdept, sClass));
}



/*
// integrated in switch characters event now
void TOBSwitchCharacters()
{
	object oPC = OBJECT_SELF; //Despite who the player controls OBJECT_SELF is the person that opened the GUI.
	object oMartialAdept = GetControlledCharacter(oPC);

	TOBCloseScreens(oPC, FALSE);
	DelayCommand(0.05f, TOBOpenScreens(oMartialAdept));
}
*/


void TOBCheckForPhaseOne(object oPC, object oToB)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCheckForPhaseOne Start", GetFirstPC() ); }
	
	if (GetLocalInt(oToB, "FeatRetrainPhase") == 1)
	{
		SetLocalInt(oToB, "RetrainLoopCheck", 1);
		ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_FEATS_LIST");
		ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "ADDED_RETRAIN_LIST");
		ClearListBox(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "AVAILABLE_RETRAIN_LIST");
		SetGUITexture(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_IMAGE", "b_empty.tga");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TITLE", -1, "");
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "INFOPANE_TEXT", -1, "");

		int nRetrain;

		if (GetHitDice(oPC) == 1)
		{
			nRetrain += 1;

			if ((GetRacialType(oPC) == RACIAL_TYPE_HUMAN) || (GetSubRace(oPC) == RACIAL_SUBTYPE_STRONGHEART_HALF))
			{
				nRetrain += 1;
			}
		}
		else nRetrain = 1;

		int nAvailable = GetLocalInt(oToB, "AvialableToRetrain");
		SetGUIObjectDisabled(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "CHOICE_FINISH", FALSE);
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "POINT_POOL_TEXT", -1, IntToString(nAvailable));
		SetGUIObjectText(oPC, "SCREEN_LEVELUP_RETRAIN_FEATS", "RETRAIN_POOL_TEXT", -1, IntToString(nRetrain));
		SetLocalInt(oToB, "FeatRetrainAmount", nRetrain);
		DelayCommand(0.1f, TOBGetAllAvailableFeats2(oPC, oToB, 1, 25));
		TOBAddAllKnownFeats(oPC, oToB, 1, 50);
	}
	else DelayCommand(0.1f, TOBCheckForPhaseOne(oPC, oToB)); // Do it until the menu can offically be opened.
}


int TOBCreateManeuver(object oPC, object oToB, int nMartialAdept, string sName, int nMax, int i, int nFinish)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCreateManeuver Start", GetFirstPC() ); }
	
	object oManeuver;
	string sItem, sData, sName;
	int nManeuver, nRetrain, nLevel, nType, nMovement, nLocation, nSupressAoO, nDescription;
	float fRange;

	while (i <= nFinish)
	{
		sData = GetLocalString(oToB, "AddedManeuver" + IntToString(i));// AddedManeuver is the index number.
		sItem = TOBGetManeuversDataScript(i);
		nManeuver = StringToInt(sData);
		nRetrain = GetLocalInt(oToB, "RetrainManeuver");

		if (sItem == (TOBGetManeuversDataScript(nRetrain)))
		{
			DestroyObject(GetObjectByTag(sName + sItem));
		}

		if (nManeuver > 0)
		{
			oManeuver = CreateItemOnObject("maneuver", oToB, 1, sName + sItem, FALSE);
			sName = TOBGetManeuversDataName(nManeuver);
			nDescription = TOBGetManeuversDataDescription(nManeuver);
			nType = TOBGetManeuversDataType(nManeuver);
			nMovement = TOBGetManeuversDataMovement(nManeuver);
			nLocation = TOBGetManeuversDataLocation(nManeuver);
			nSupressAoO = TOBGetManeuversDataSupressAoO(nManeuver);
			fRange = TOBGetManeuversDataRange(nManeuver);

			SetFirstName(oManeuver, sName);
			SetDescription(oManeuver, GetStringByStrRef(nDescription));

			if (TOBGetManeuversDataIsStance(nManeuver) == 1)
			{
				nLevel = 0;
			}
			else nLevel = TOBGetManeuversDataLevel(nManeuver);

			SetLocalInt(oManeuver, "2da", nManeuver);
			SetLocalInt(oManeuver, "Level", nLevel);
			SetLocalInt(oManeuver, "Class", nMartialAdept);
			SetLocalInt(oManeuver, "Type", nType);

			if (nMovement > 0)
			{
				SetLocalInt(oManeuver, "Movement", nMovement);
			}

			if (nLocation > 0)
			{
				SetLocalInt(oManeuver, "Location", nLocation);
			}

			if (nSupressAoO > 0)
			{
				SetLocalInt(oManeuver, "SupressAoO", nSupressAoO);
			}

			if (fRange > 0.0f)
			{
				SetLocalFloat(oManeuver, "Range", fRange);
			}
		}

		DeleteLocalString(oToB, "AddedManeuver" + IntToString(i));
		i++;
	}

	return i;
}

void TOBCreateManeuverLoop(object oPC, object oToB, int nMartialAdept, string sName, int nMax, int nStart, int nFinish)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCreateManeuverLoop Start", GetFirstPC() ); }
	
	int i = TOBCreateManeuver(oPC, oToB, nMartialAdept, sName, nMax, nStart, nFinish);

	if (i < nMax) // The 2da hasn't been entirely run through yet, so we're picking up where we left off to avoid TMI.
	{
		if (nFinish + 50 > nMax)
		{
			nFinish = nMax;
		}
		else nFinish = nFinish + 50;

		DelayCommand(0.01f, TOBCreateManeuverLoop(oPC, oToB, nMartialAdept, sName, nMax, i, nFinish));
	}
	else SetLocalInt(oToB, "ManeuversCreated", 1);
}


void TOBCheckStatus(object oPC)
{
	if (DEBUGGING >= 7) { CSLDebug(  "TOBCheckStatus Start", GetFirstPC() ); }
	
	int nCheck;
	effect eSuck;

	eSuck = GetFirstEffect(oPC);

	while (GetIsEffectValid(eSuck)) // In order to initiate a maneuver the player must be able to move(ToB p.38).
	{
		nCheck = GetEffectType(eSuck);

		if (nCheck == EFFECT_TYPE_CHARMED || nCheck == EFFECT_TYPE_CONFUSED || nCheck == EFFECT_TYPE_CUTSCENE_PARALYZE
		|| nCheck == EFFECT_TYPE_DAZED || nCheck == EFFECT_TYPE_DOMINATED
		|| nCheck == EFFECT_TYPE_ENTANGLE || nCheck == EFFECT_TYPE_FRIGHTENED
		|| nCheck == EFFECT_TYPE_PARALYZE || nCheck == EFFECT_TYPE_PETRIFY
		|| nCheck == EFFECT_TYPE_STUNNED || nCheck == EFFECT_TYPE_TIMESTOP)
		{
			SetLocalInt(oPC, "bot9s_status_check", 1);
			break;
		}

		eSuck = GetNextEffect(oPC);
	}
}
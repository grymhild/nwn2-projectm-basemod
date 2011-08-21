//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 10/16/2009								//
//	Title: TB_st_avalanche 							//
//	Description: As part of this maneuver, you make //
// a single melee attack against an opponent. If 	//
// that attack hits, resolve your damage as normal.//
// You can then make another attack against that 	//
// foe with a -4 penalty on your attack roll. If 	//
// that attack hits, you can make another attack 	//
// against that opponent with a -8 penalty. You 	//
// continue to make additional attacks, each one 	//
// with an additional -4 penalty, until you miss or//
// your opponent is reduced to -1 hit points or 	//
// fewer. You direct all these attacks at a single //
// foe.											//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void AvalancheOfBlades(object oWeapon, object oTarget, int nHit)
{
	if (GetCurrentHitPoints(oTarget) > 0)
	{
		CSLStrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		TOBBasicAttackAnimation(oWeapon, nHit, TRUE);
		DelayCommand(0.3f, TOBStrikeWeaponDamage(oWeapon, nHit, oTarget));
	}
}


void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = TOBGetManeuverObject(oToB, 55);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "DiamondMindStrike", 1);
	DelayCommand(6.0f, SetLocalInt(oToB, "DiamondMindStrike", 0));

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	effect eVis = EffectVisualEffect(VFX_TOB_BLUR);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, 6.0f);
	TOBExpendManeuver(55, "STR");

	int nPenalty;

	if (GetActionMode(oPC, ACTION_MODE_FLURRY_OF_BLOWS))
	{
		int nMonk = GetLevelByClass(CLASS_TYPE_MONK, oPC) + GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC);

		if (nMonk < 5)
		{
			nPenalty -= 2;
		}
		else if (nMonk < 9)
		{
			nPenalty -= 1;
		}
	}

	if (GetLocalInt(oToB, "SnapKick") == 1)
	{
		nPenalty -= 2;
	}

	int nHit = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty); //Bleh, can't loop Strike functions. Too many while loops in em already.
	float fDelay;

	AvalancheOfBlades(oWeapon, oTarget, nHit);


	if (nHit > 0)
	{
		nPenalty -= 4;
		fDelay += 0.1f;

		DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit));

		int nHit1 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

		if (nHit1 > 0)
		{
			nPenalty -= 4;
			fDelay += 0.1f;

			DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit1));

			int nHit2 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

			if (nHit2 > 0)
			{
				nPenalty -= 4;
				fDelay += 0.1f;

				DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit2));

				int nHit3 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

				if (nHit3 > 0)
				{
					nPenalty -= 4;
					fDelay += 0.1f;

					DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit3));

					int nHit4 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

					if (nHit4 > 0)
					{
						nPenalty -= 4;
						fDelay += 0.1f;

						DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit4));

						int nHit5 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

						if (nHit5 > 0)
						{
							nPenalty -= 4;
							fDelay += 0.1f;

							DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit5));

							int nHit6 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

							if (nHit6 > 0)
							{
								nPenalty -= 4;
								fDelay += 0.1f;

								DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit6));

								int nHit7 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

								if (nHit7 > 0)
								{
									nPenalty -= 4;
									fDelay += 0.1f;

									DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit7));

									int nHit8 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

									if (nHit8 > 0)
									{
										nPenalty -= 4;
										fDelay += 0.1f;

										DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit8));

										int nHit9 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

										if (nHit9 > 0)
										{
											nPenalty -= 4;
											fDelay += 0.1f;

											DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit9));

											int nHit10 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

											if (nHit10 > 0)
											{
												nPenalty -= 4;
												fDelay += 0.1f;

												DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit10));

												int nHit11 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

												if (nHit11 > 0)
												{
													nPenalty -= 4;
													fDelay += 0.1f;

													DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit11));

													int nHit12 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

													if (nHit12 > 0)
													{
														nPenalty -= 4;
														fDelay += 0.1f;

														DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit12));

														int nHit13 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

														if (nHit13 > 0)
														{
															nPenalty -= 4;
															fDelay += 0.1f;

															DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit13));

															int nHit14 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

															if (nHit14 > 0)
															{
																nPenalty -= 4;
																fDelay += 0.1f;

																DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit14));

																int nHit15 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

																if (nHit15 > 0)
																{
																	nPenalty -= 4;
																	fDelay += 0.1f;

																	DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit15));

																	int nHit16 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

																	if (nHit16 > 0)
																	{
																		nPenalty -= 4;
																		fDelay += 0.1f;

																		DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit16));

																		int nHit17 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

																		if (nHit17 > 0)
																		{
																			nPenalty -= 4;
																			fDelay += 0.1f;

																			DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit17));

																			int nHit18 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

																			if (nHit18 > 0)
																			{
																				nPenalty -= 4;
																				fDelay += 0.1f;

																				DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit18));

																				int nHit19 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

																				if (nHit19 > 0)
																				{
																					nPenalty -= 4;
																					fDelay += 0.1f;

																					DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit19));

																					int nHit20 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

																					if (nHit20 > 0)
																					{
																						nPenalty -= 4;
																						fDelay += 0.1f;

																						DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit20));

																						int nHit21 = TOBStrikeAttackRoll(oWeapon, oTarget, nPenalty);

																						if (nHit21 > 0)
																						{
																							nPenalty -= 4;
																							fDelay += 0.1f;

																							DelayCommand(0.3f + fDelay, AvalancheOfBlades(oWeapon, oTarget, nHit21));
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
}

//::///////////////////////////////////////////////
//:: Beholder Ray Attacks
//:: x2_s2_beholdray
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Implementation for the new version of the
	beholder rays, using projectiles instead of
	rays
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-16
//:://////////////////////////////////////////////


#include "_HkSpell"
#include "_CSLCore_Player"

#include "_SCInclude_Events"

void DoBeholderPetrify(int iDuration,object oSource, object oTarget, int iSpellId);

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	int     iSpellId = GetSpellId();
	object  oTarget = HkGetSpellTarget();
	int     iSave, bSave;
	int     iSaveDC = 17;
	float   fDelay;
	effect  e1, eLink, eVis, eDur, eBeam;


	switch (iSpellId)
	{
			case 776 :
											iSave = SAVING_THROW_FORT;      //BEHOLDER_RAY_DEATH
											break;

			case  777:
											iSave = SAVING_THROW_WILL;     //BEHOLDER_RAY_TK
											break;

			case 778 :                                              //BEHOLDER_RAY_PETRI
											iSave = SAVING_THROW_FORT;
											break;

			case 779:                                                   // BEHOLDER_RAY_CHARM_MONSTER
											iSave = SAVING_THROW_WILL;
											break;

			case 780:                                                   //BEHOLDER_RAY_SLOW
											iSave = SAVING_THROW_WILL;
											break;

		case 783:
											iSave = SAVING_THROW_FORT;        //BEHOLDER_RAY_WOUND
											break;

		case 784:                                                    // BEHOLDER_RAY_FEAR
											iSave = SAVING_THROW_WILL;
											break;

		case 785: iSave = SAVING_THROW_WILL;        //charm person
											break;
									
		case 786:                  iSave = SAVING_THROW_WILL;        //sleep
											break;
									
		case 787:                  iSave = SAVING_THROW_FORT;        //distintegrate
											break;
	}

	SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId(),TRUE));
	fDelay  = 0.0f;  //old -- CSLGetSpellEffectDelay(GetLocation(oTarget),OBJECT_SELF);
	
	if (iSpellId == 785)
	{
		if( CSLGetIsHumanoid( oTarget ) )
		{
			if (iSave == SAVING_THROW_WILL)
			{
					bSave = WillSave(oTarget, iSaveDC, SAVING_THROW_TYPE_NONE);
			}
			else if (iSave == SAVING_THROW_FORT)
			{
					bSave = FortitudeSave(oTarget, iSaveDC, SAVING_THROW_TYPE_NONE);
			}
		}
		else
		{
			bSave = SAVING_THROW_CHECK_IMMUNE;
		}
	}
	else
	{
	if (iSave == SAVING_THROW_WILL)
	{
			bSave = WillSave(oTarget, iSaveDC, SAVING_THROW_TYPE_NONE);
	}
	else if (iSave == SAVING_THROW_FORT)
	{
		bSave = FortitudeSave(oTarget, iSaveDC, SAVING_THROW_TYPE_NONE);
	}
	}

	if (bSave == SAVING_THROW_CHECK_FAILED)
	{

		switch (iSpellId)
		{
			case 776:                 e1 = EffectDeath(TRUE);
												eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
												eLink = EffectLinkEffects(e1,eVis);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget);
									eBeam = EffectBeam(5007, OBJECT_SELF, BODY_NODE_MONSTER_0, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;

			case 777:                e1 = ExtraordinaryEffect(EffectKnockdown());
									eVis = EffectVisualEffect(VFX_HIT_SPELL_BALAGARN_IRON_HORN);
									HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,6.0f);
									eBeam = EffectBeam(5006, OBJECT_SELF, BODY_NODE_MONSTER_1, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
									if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
									{
										CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN", 6.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
									}									
									
									
												break;

			// Petrify for one round per SaveDC
			case 778:                eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
												DoBeholderPetrify(iSaveDC,OBJECT_SELF,oTarget,GetSpellId());
									eBeam = EffectBeam(5008, OBJECT_SELF, BODY_NODE_MONSTER_2, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;


			case 779:                e1 = EffectCharmed();
										eLink = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
									eLink = EffectLinkEffects(e1, eLink);
									eLink = SupernaturalEffect(eLink);
												eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
												HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,24.0f);
									eBeam = EffectBeam(5001, OBJECT_SELF, BODY_NODE_MONSTER_3, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;


			case 780:                e1 = EffectSlow();
												eLink = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
									eLink = EffectLinkEffects(e1, eLink);
									eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
												HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(6));
									eBeam = EffectBeam(5003, OBJECT_SELF, BODY_NODE_MONSTER_4, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;

			case 783:                e1 = EffectDamage(d8(2)+10);
												eVis = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_6);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,e1,oTarget);
									eBeam = EffectBeam(5002, OBJECT_SELF, BODY_NODE_MONSTER_5, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;


			case 784:
												e1 = EffectFrightened();
												eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
												eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
												e1 = EffectLinkEffects(eDur,e1);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
												HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,RoundsToSeconds(1+d4()));
									eBeam = EffectBeam(5004, OBJECT_SELF, BODY_NODE_MONSTER_6, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;
									
		case 785:
									e1 = EffectCharmed();
										eLink = EffectVisualEffect(VFX_DUR_SPELL_CHARM_PERSON);
									eLink = EffectLinkEffects(e1, eLink);
									eLink = SupernaturalEffect(eLink);
												eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
												HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,24.0f);
									eBeam = EffectBeam(5001, OBJECT_SELF, BODY_NODE_MONSTER_7, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;
										
		case 786:
									e1 = ExtraordinaryEffect(EffectSleep());
										eDur = EffectVisualEffect(VFX_DUR_SLEEP);
									eLink = EffectLinkEffects(eDur, e1);
									eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
									HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
												HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(13));
									eBeam = EffectBeam(5005, OBJECT_SELF, BODY_NODE_MONSTER_8, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;
									
		case 787:
		{
									string nName = GetName(oTarget);
										if (nName == "Mordenkainen's Sword")
										{
												effect eKill = EffectDamage(GetCurrentHitPoints(oTarget),DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_NORMAL,TRUE);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDisintegrate( oTarget ), oTarget);
												return;
										}
									int iDamage = d6(13);
									string sEventHandler = GetEventHandler(oTarget, CREATURE_SCRIPT_ON_DAMAGED);
									if (iDamage >= GetCurrentHitPoints(oTarget) && sEventHandler == "gb_troll_dmg")
									{
										SetEventHandler(oTarget,CREATURE_SCRIPT_ON_DAMAGED, SCRIPT_DEFAULT_DAMAGE);
										SetImmortal(oTarget, FALSE);
									}
									e1 = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
										eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
									HkApplyEffectToObject(DURATION_TYPE_INSTANT,e1,oTarget);
												HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
									eBeam = EffectBeam(5000, OBJECT_SELF, BODY_NODE_CHEST, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;
		}

		}

	}
	else
	{
			switch (iSpellId)
			{
				case 776: e1 = EffectDamage(d6(3)+13);
											eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
											eLink = EffectLinkEffects(e1,eVis);
											HkApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget);
								eBeam = EffectBeam(5007, OBJECT_SELF, BODY_NODE_MONSTER_0, FALSE);
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
								break;
			
			case 777:              HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;

			
			case 778:                eBeam = EffectBeam(5008, OBJECT_SELF, BODY_NODE_MONSTER_2, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;


			case 779:                eBeam = EffectBeam(5001, OBJECT_SELF, BODY_NODE_MONSTER_3, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;


			case 780:                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;

			case 783:                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;


			case 784:
												eBeam = EffectBeam(5004, OBJECT_SELF, BODY_NODE_MONSTER_6, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;
									
		case 785:
									eBeam = EffectBeam(5001, OBJECT_SELF, BODY_NODE_MONSTER_7, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;
										
		case 786: eBeam = EffectBeam(5005, OBJECT_SELF, BODY_NODE_MONSTER_8, FALSE);
									HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
												break;
								
			case 787: e1 = EffectDamage(d6(5), DAMAGE_TYPE_MAGICAL);
									eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
								HkApplyEffectToObject(DURATION_TYPE_INSTANT,e1,oTarget);
											HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
								eBeam = EffectBeam(5000, OBJECT_SELF, BODY_NODE_MONSTER_9, TRUE);
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam,oTarget,1.0);
								break;
			}
	}
}



void DoBeholderPetrify(int iDuration,object oSource, object oTarget, int iSpellId)
{

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && !GetIsDead(oTarget))
	{
			// * exit if creature is immune to petrification
			if (CSLGetIsImmuneToPetrification(oTarget) == TRUE)
			{
				return;
			}
			float fDifficulty = 0.0;
			int bIsPC = GetIsPC(oTarget);
			int bShowPopup = FALSE;

			// * calculate Duration based on difficulty settings
			int nGameDiff = GetGameDifficulty();
			switch (nGameDiff)
			{
				case GAME_DIFFICULTY_VERY_EASY:
				case GAME_DIFFICULTY_EASY:
				case GAME_DIFFICULTY_NORMAL:
							fDifficulty = RoundsToSeconds(iDuration); // One Round per hit-die or caster level
					break;
				case GAME_DIFFICULTY_CORE_RULES:
				case GAME_DIFFICULTY_DIFFICULT:
					if (!GetPlotFlag(oTarget))
					{
							bShowPopup = TRUE;
					}
				break;
			}

			effect ePetrify = EffectPetrify();
			effect eDur = EffectVisualEffect(VFX_DUR_SPELL_FLESH_TO_STONE);
			effect eLink = EffectLinkEffects(eDur, ePetrify);


					/// * The duration is permanent against NPCs but only temporary against PCs
					if (bIsPC == TRUE)
					{
							if (bShowPopup == TRUE)
							{
								// * under hardcore rules or higher, this is an instant death
								HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
								DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, 40579));
								// if in hardcore, treat the player as an NPC
								bIsPC = FALSE;
							}
							else
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDifficulty);
					}
					else
					{
							HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
							// * Feb 11 2003 BK I don't think this is necessary anymore
							//if the target was an NPC - make him uncommandable until Stone to Flesh is cast
							//SetCommandable(FALSE, oTarget);

							// Feb 5 2004 - Jon
							// Added kick-henchman-out-of-party code from generic petrify script
							if (GetAssociateType(oTarget) == ASSOCIATE_TYPE_HENCHMAN)
							{
								CSLFireHenchman(GetMaster(oTarget),oTarget);
							}
					}
					// April 2003: Clearing actions to kick them out of conversation when petrified
					AssignCommand(oTarget, ClearAllActions());
	}
}
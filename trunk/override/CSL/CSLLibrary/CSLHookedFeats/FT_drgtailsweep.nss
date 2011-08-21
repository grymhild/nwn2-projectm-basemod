//::///////////////////////////////////////////////
//:: Dragon Tail Slap
//:: NW_S1_DragTSlap
//:://////////////////////////////////////////////
/*
	Applies Dragon Tail Slap effects to creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Constant Gaw - 8/9/06
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Monster"


void TailSwipe(int iDamage, int iDC);
void DisarmCreature(object oTarget);

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	int iAge = GetHitDice(OBJECT_SELF);
	int iDamage, iDC, nDamStrike;
	float fDelay;
	object oTarget;
	effect eVis, eBreath;
	//Use the HD of the creature to determine damage and save DC
	if (iAge <= 6) //Wyrmling
	{
			iDamage = d4(2);
			iDC = 15;
	}
	else if (iAge >= 7 && iAge <= 9) //Very Young
	{
			iDamage = d4(4);
			iDC = 18;
	}
	else if (iAge >= 10 && iAge <= 12) //Young
	{
			iDamage = d4(6);
			iDC = 19;
	}
	else if (iAge >= 13 && iAge <= 15) //Juvenile
	{
			iDamage = d4(8);
			iDC = 22;
	}
	else if (iAge >= 16 && iAge <= 18) //Young Adult
	{
			iDamage = d4(10);
			iDC = 24;
	}
	else if (iAge >= 19 && iAge <= 22) //Adult
	{
			iDamage = d4(12);
			iDC = 25;
	}
	else if (iAge >= 23 && iAge <= 24) //Mature Adult
	{
			iDamage = d4(14);
			iDC = 28;
	}
	else if (iAge >= 25 && iAge <= 27) //Old
	{
			iDamage = d4(16);
			iDC = 30;
	}
	else if (iAge >= 28 && iAge <= 30) //Very Old
	{
			iDamage = d4(18);
			iDC = 33;
	}
	else if (iAge >= 31 && iAge <= 33) //Ancient
	{
			iDamage = d4(20);
			iDC = 35;
	}
	else if (iAge >= 34 && iAge <= 37) //Wyrm
	{
			iDamage = d4(22);
			iDC = 38;
	}
	else if (iAge > 37) //Great Wyrm
	{
			iDamage = d4(24);
			iDC = 40;
	}
	
	SCPlayDragonBattleCry();
	PlayCustomAnimation(OBJECT_SELF, "Una_tailslap", 0, 0.5f);
	//Get first target in spell area
	
	DelayCommand(1.0f, TailSwipe(iDamage, iDC));
}
	
void TailSwipe(int iDamage, int iDC)
{
	float fDelay;
	effect eVis = EffectNWN2SpecialEffectFile("sp_sonic_hit.sef");
	effect eKnockdown = EffectKnockdown();
	float fFacing = GetFacing(OBJECT_SELF);
	float fRandomDuration;
	location lLocation = CSLGetBehindLocation(OBJECT_SELF, 15.0f);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
			if(oTarget != OBJECT_SELF && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Reset the damage to full
				int nDamStrike = iDamage;
				effect eBreath = EffectDamage(nDamStrike, DAMAGE_TYPE_FIRE);
				//Fire cast spell at event for the specified target
//            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_FIRE));
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC - 5, SAVING_THROW_TYPE_NONE))
				{
					nDamStrike = nDamStrike/2;
					if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
					{
							nDamStrike = 0;
					}
				}
				else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
				{
					nDamStrike = nDamStrike/2;
				}
				if (nDamStrike > 0)
				{
						//Determine effect delay
						//fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
						//Apply the VFX impact and effects
					//ActionUseFeat(FEAT_IMPROVED_DISARM, oTarget);
					if (GetIsCreatureDisarmable(oTarget) == TRUE && !HkSavingThrow(SAVING_THROW_REFLEX,
						oTarget, iDC, SAVING_THROW_TYPE_NONE))
					{
						DelayCommand(0.7, AssignCommand(oTarget, DisarmCreature(oTarget)));
					}
					
					fRandomDuration = CSLRandomBetweenFloat(6.0, 12.0);
					
					DelayCommand(0.5, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
					DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0f));
					DelayCommand(0.5, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fRandomDuration));
					
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN", fRandomDuration, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}	
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLocation, FALSE, OBJECT_TYPE_CREATURE);
	}
	
}

void DisarmCreature(object oTarget)
{
	object oBag = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_mc_bag03", GetLocation(oTarget));
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	AssignCommand(oBag, ActionTakeItem(oItem, oTarget));
}
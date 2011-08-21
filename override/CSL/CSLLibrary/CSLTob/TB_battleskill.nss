////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: 4/28/2009											//
//	Name: TB_battlecunnin										//
//	Description: The PC gains a bonus equal to Int on any //
//	check made to oppose an enemy’s taunt, feint, or parry//
// attempt. Additionally, starting with the first round //
// of combat, the PC gains immunity to knockdown for an //
// amount of rounds equal to their Int mod (if any). 	//
////////////////////////////////////////////////////////////

/*	The following is depriciated.

	Can't directly influence the Disarm or Knockdown roll so we'll reduce it's
	use based on Int and end up with a similiar result to if we had done so. This
	script is run every round of combat so the probability of the oFoe using Disarm
	or Knockdown is negligible. We can determine the modified roll before the
	actual roll and thus determine if the roll will be allowed. Since
	we're determining the probability of allowing the original roll, our new roll
	is vaild since there will be an appropriate reduction in the amount of times
	the abilities are used which coresponds to if the modified roll had actually
	failed. If the abilites are never used we're still well off anyway.
	In essence one roll allows the other. For instance if I rolled 100 times with
	the modified roll I would still have an average number. A number slightly
	higher than the unmodifed roll, but since it's average only allows the normal
	roll to take place, the only influence on the effective roll is to reduce the
	amount of times that the normal roll would have succeeded. Thus a small
	defense bonus is achieved, based on the PC's Int mod. We're not rolling twice
	and taking the better of two rolls, but subracting how many successful rolls
	would have taken place.*/

//#include "bot9s_armor"
//#include "bot9s_attack"
//#include "bot9s_include"
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void BattleSkill(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "BATTLESKILL", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "BATTLESKILL" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6527);

	if (GetIsInCombat(oPC))
	{
		int nIntelligence = GetAbilityModifier(ABILITY_INTELLIGENCE);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
		DelayCommand(6.0f, BattleSkill( oPC, oToB, iSpellId, iSerial ));

		if (nIntelligence < 1) // Don't run any of this if there's no point.
		{
			return;
		}

		if (GetLocalInt(oToB, "Encounter") == 1)
		{
			float fTime = RoundsToSeconds(nIntelligence);
			effect eStout = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
			eStout = SupernaturalEffect(eStout);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStout, oPC, fTime);
		}

		effect eFeign = EffectSkillDecrease(SKILL_BLUFF, nIntelligence);
		effect eTaunt = EffectSkillDecrease(SKILL_TAUNT, nIntelligence);
		effect eParry = EffectSkillDecrease(SKILL_PARRY, nIntelligence);
		effect eLink = EffectLinkEffects(eFeign, eTaunt);
		eLink = EffectLinkEffects(eLink, eParry);
		eLink = SupernaturalEffect(eLink);

		float fRange = CSLGetMeleeRange(oPC);
		location lPC = GetLocation(oPC);
		object oFoe;

		oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		while (GetIsObjectValid(oFoe))
		{
			if (GetIsReactionTypeHostile(oFoe, oPC))
			{
				if (GetAttackTarget(oFoe) == oPC)
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oFoe, 5.99f);

					/*int nMySize = GetCreatureSize(oPC);
					int nFoeSize = GetCreatureSize(oFoe);

					object oWeapon;
					object oFoeWeapon;

					if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == OBJECT_INVALID)
					{
						oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
					}
					else oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

					if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oFoe) == OBJECT_INVALID)
					{
						oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oFoe);
					}
					else if (GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oFoe) == OBJECT_INVALID)
					{
						oFoeWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oFoe);
					}
					else oFoeWeapon = GetLastWeaponUsed(oFoe);

					int nWeaponSize = CSLItemGetWeaponSize(oPC);
					int nFoeWeaponSize = CSLItemGetWeaponSize(oFoe);

					if (GetHasFeat(FEAT_IMPROVED_DISARM, oFoe))
					{
						int nAB = CSLGetMaxAB(oPC, oWeapon, oFoe);
						int nFoeAB = CSLGetMaxAB(oFoe, oFoeWeapon, oPC);
						int nMyRoll = nAB + (4 * nMySize) + (4 * nWeaponSize) + d20(1) + nIntelligence;
						int nFoeRoll = nFoeAB + (4 * nFoeSize) + (4 * nFoeWeaponSize) + d20(1);

						if (nMyRoll >= nFoeRoll)
						{
							FeatRemove(oFoe, FEAT_IMPROVED_DISARM);
							FeatRemove(oFoe, FEAT_DISARM);
							AssignCommand(oFoe, DelayCommand(6.0f, CSLWrapperFeatAdd(oFoe, FEAT_IMPROVED_DISARM, FALSE)));
							AssignCommand(oFoe, DelayCommand(6.0f, CSLWrapperFeatAdd(oFoe, FEAT_DISARM, FALSE)));
						}
					}
					else if (GetHasFeat(FEAT_DISARM, oFoe))
					{
						int nAB = CSLGetMaxAB(oPC, oWeapon, oFoe);
						int nFoeAB = CSLGetMaxAB(oFoe, oFoeWeapon, oPC);
						int nMyRoll = nAB + (4 * nMySize) + d20(1) + nIntelligence;
						int nFoeRoll = nFoeAB + (4 * nFoeSize) + d20(1);

						if (nMyRoll >= nFoeRoll)
						{
							FeatRemove(oFoe, FEAT_DISARM);
							AssignCommand(oFoe, DelayCommand(6.0f, CSLWrapperFeatAdd(oFoe, FEAT_DISARM, FALSE)));
						}
					}

					if ((GetHasFeat(FEAT_IMPROVED_KNOCKDOWN, oFoe)) && (nMySize <= nFoeSize + 2))
					{
						int nDefStat;
						int nMyStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
						int nMyDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);

						if (nMyStr >= nMyDex)
						{
							nDefStat = nMyStr;
						}
						else nDefStat = nMyDex;

						int nFoeTouchAttack = CSLGetTouchAB(oFoe) + d20(1);
						int nMyTouchAC = CSLGetTouchAC(oPC);
						int nFoeStr = GetAbilityModifier(ABILITY_DEXTERITY, oFoe);
						int nMyRoll = nDefStat + (4 * nMySize) + d20(1) + nIntelligence;
						int nFoeRoll = nFoeStr + (4 * nFoeSize) + d20(1);

						if ((nFoeTouchAttack <= nMyTouchAC) && (nMyRoll >= nFoeRoll))
						{
							FeatRemove(oFoe, FEAT_IMPROVED_KNOCKDOWN);
							FeatRemove(oFoe, FEAT_KNOCKDOWN);
							AssignCommand(oFoe, DelayCommand(6.0f, CSLWrapperFeatAdd(oFoe, FEAT_IMPROVED_KNOCKDOWN, FALSE)));
							AssignCommand(oFoe, DelayCommand(6.0f, CSLWrapperFeatAdd(oFoe, FEAT_KNOCKDOWN, FALSE)));
						}
					}
					else if ((GetHasFeat(FEAT_KNOCKDOWN, oFoe)) && (nMySize <= nFoeSize + 1))
					{
						int nDefStat;
						int nMyStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
						int nMyDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);

						if (nMyStr >= nMyDex)
						{
							nDefStat = nMyStr;
						}
						else nDefStat = nMyDex;

						int nFoeTouchAttack = CSLGetTouchAB(oFoe) + d20(1);
						int nMyTouchAC = CSLGetTouchAC(oPC);
						int nFoeStr = GetAbilityModifier(ABILITY_DEXTERITY, oFoe);
						int nMyRoll = nDefStat + (4 * nMySize) + d20(1) + nIntelligence;
						int nFoeRoll = nFoeStr + (4 * nFoeSize) + d20(1);

						if ((nFoeTouchAttack <= nMyTouchAC) && (nMyRoll >= nFoeRoll))
						{
							FeatRemove(oFoe, FEAT_KNOCKDOWN);
							AssignCommand(oFoe, DelayCommand(6.0f, CSLWrapperFeatAdd(oFoe, FEAT_KNOCKDOWN, FALSE)));
						}
					}*/
				}
			}
			oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}
	}
	else
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 0.5f);
		DelayCommand(0.5f, BattleSkill( oPC, oToB, iSpellId, iSerial ));
	}
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6527, oPC))
	{
		BattleSkill(); //Only runs if the effect is no longer on the player.
	}
}

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	DelayCommand(6.0f, CheckLoopEffect(oPC, oToB)); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}
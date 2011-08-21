//::///////////////////////////////////////////////
//:: Name 	Grim Revenge
//:: FileName sp_grim_revng.nss
//:://////////////////////////////////////////////
/**@file Grim Revenge
Necromancy [Evil]
Level: Sor/Wiz 4
Components: V, S, Undead
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Target: One living humanoid
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The hand of the subject tears itself away from one
of his arms, leaving a bloody stump. This trauma
deals 6d6 points of damage. Then the hand, animated
and floating in the air, begins to attack the
subject. The hand attacks as if it were a wight
(see the Monster Manual) in terms of its statistics,
special attacks, and special qualities, except that
it is considered Tiny and gains a +4 bonus to AC
and a +4 bonus on attack rolls. The hand can be
turned or rebuked as a wight. If the hand is
defeated, only a regenerate spell can restore the
victim to normal.

Author: 	Tenjac
Created: 	5/20/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"

#include "_CSLCore_Items"
#include "_HkSpell"
#include "_CSLCore_Nwnx"
void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GRIM_REVENGE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}



	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nModelNumber = 0;
	int bLeftHandMissing;
	int bRightHandMissing;
	int bLeftAnimated = FALSE;
	int bRightAnimated = FALSE;
	/* needs rewrite for nwn2
	if(GetCreatureBodyPart(CREATURE_PART_LEFT_HAND, oTarget) == nModelNumber)
	{
		bLeftHandMissing = TRUE;
	}

	if(GetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, oTarget) == nModelNumber)
	{
		bRightHandMissing = TRUE;
	}

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_GRIM_REVENGE, oCaster);

	//Check for undead
	if( CSLGetIsUndead(oCaster) )
	{
		//Check Spell Resistance
		if(!MyPRCResistSpell(oCaster, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Will save
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				int nDam = d6(6);

				if(nMetaMagic == METAMAGIC_MAXIMIZE)
				{
				nDam = 36;
				}
				if(nMetaMagic == METAMAGIC_EMPOWER)
				{
				nDam += (nDam/2);
				}

				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);

				//Remove hand from oTarget - left hand first?
				//http://nwn.bioware.com/players/167/scripts_commandslist.html

				if(!bLeftHandMissing)
				{
				//deal damage
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);

				SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, nModelNumber, oTarget);
				CSLSetPersistentInt(oTarget, "LEFT_HAND_USELESS", 1);

				//Force unequip
				CSLForceUnequip(oTarget, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget), INVENTORY_SLOT_LEFTHAND);

				bLeftAnimated = TRUE;
				}

				else if(!bRightHandMissing)
				{
				//deal damage
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);

				SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, nModelNumber, oTarget);
				CSLSetPersistentInt(oTarget, "RIGHT_HAND_USELESS", 1);

				//Force unequip
				CSLForceUnequip(oTarget, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget), INVENTORY_SLOT_RIGHTHAND);

				bRightAnimated = TRUE;
				}

				else
				{
				SendMessageToPC(oCaster, "Your target has no hands!");
				}

				//Create copy of target, set all body parts null
				object oHand = CopyObject(oTarget, GetLocation(oTarget), OBJECT_INVALID);

				SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_PELVIS, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_TORSO, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_BELT, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_NECK, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER, nModelNumber, oHand);
				SetCreatureBodyPart(CREATURE_PART_HEAD, nModelNumber, oHand);

				if(!bLeftAnimated)
				{
				SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, nModelNumber, oHand);
				}

				if(!bRightAnimated)
				{
				SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, nModelNumber, oHand);
				}

				//Set Bonuses
				effect eLink = EffectACIncrease(4, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
					eLink = EffectLinkEffects(eLink, EffectAttackIncrease(4, ATTACK_BONUS_MISC));

				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oHand);

				itemproperty iUndead = ItemPropertyBonusFeat(FEAT_UNDEAD);
				CSLSafeAddItemProperty(CSLGetPCSkin(oHand), iUndead);

				//Make hand hostile to target
				AssignCommand(oHand, SetIsEnemy(oTarget));
			}
		}
	} */
	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


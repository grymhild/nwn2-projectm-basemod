//::///////////////////////////////////////////////
//:: Elemental Strike
//:: cmi_s2_elemstrike
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: August 11, 2008
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_chars"
//#include "cmi_ginc_spells"
//#include "cmi_ginc_wpns"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();

	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
			effect AttackEffect = TOBGenerateAttackEffect(OBJECT_SELF, oWeapon);

			int iTouch = CSLTouchAttackMelee(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				int nGFK = GetLevelByClass(CLASS_GHOST_FACED_KILLER, OBJECT_SELF);
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));

				//Apply the effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, AttackEffect, oTarget);

				effect eAB = EffectAttackDecrease(2);
				effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR);
				effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
				effect eStatusEffect = EffectLinkEffects(eAB, eSkill);
				eStatusEffect = EffectLinkEffects(eStatusEffect, eSave);

				int nDC = 10 + GetAbilityModifier(ABILITY_CHARISMA) + nGFK;
				if ((!GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) ) || (GetHitDice(oTarget) > GetHitDice(OBJECT_SELF)))
				{
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, DAMAGE_TYPE_ALL))
					{
						effect eDeath = EffectDeath(TRUE, TRUE, FALSE, TRUE);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
					}
					else
					{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatusEffect, oTarget, RoundsToSeconds(nGFK));
					}
				}

				location lTarget = HkGetSpellTargetLocation();
				object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE,OBJECT_TYPE_CREATURE);
				while (GetIsObjectValid(oTarget))
				{
					if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
					{
						//Fire cast spell at event for the specified target
						SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 2054));
						if ((!GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) ) || (GetHitDice(oTarget) > GetHitDice(OBJECT_SELF)))
						{
							if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, DAMAGE_TYPE_ALL))
							{
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatusEffect, oTarget, RoundsToSeconds(nGFK));
							}
						}
					}
					oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
				}
			}
		}
	}



}
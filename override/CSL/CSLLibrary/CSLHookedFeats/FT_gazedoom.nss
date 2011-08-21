//::///////////////////////////////////////////////
//:: Gaze of Doom
//:: NW_S1_GazeDoom.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If the target fails a save they recieve a -2
	penalty to all saves, attack rolls, damage and
	skill checks for the duration of the spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////


#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	if( CSLIsGazeAttackBlocked(OBJECT_SELF))
	{
			return;
	}


	//Declare major variables
	int iHD = GetHitDice(OBJECT_SELF);
	int iDuration = 1 + (iHD / 3);
	int iDC = 10 + (iHD/2);
	effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
	effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
	effect eAttack = EffectAttackDecrease(2);
	effect eDamage = EffectDamageDecrease(2);
	effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	effect eLink = EffectLinkEffects(eAttack, eDamage);
	eLink = EffectLinkEffects(eLink, eSaves);
	eLink = EffectLinkEffects(eLink, eSkill);
	eLink = EffectLinkEffects(eLink, eDur);

	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, HkGetSpellTargetLocation());
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				if(oTarget != OBJECT_SELF)
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_DOOM));
					//Spell Resistance and Saving throw
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
					{
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
					}
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, HkGetSpellTargetLocation());
	}
}
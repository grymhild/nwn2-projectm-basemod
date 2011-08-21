//::///////////////////////////////////////////////
//:: Name 	Wrack
//:: FileName sp_wrack.nss
//:://////////////////////////////////////////////
/**@file Wrack
Necromancy [Evil]
Level: Clr 3, Mortal Hunter 3, Pain 3, Sor/Wiz 4
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Area: One humanoid creature
Duration: 1 round/level
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject is wracked with such pain that he doubles
over and collapses. His face and hands blister and
drip fluid, and his eyes cloud with blood, rendering
him blind. For the duration of the spell the subject
is considered helpless and cannot take actions. The
subject's sight returns when the spell's duration
expires.

Even after the spell ends, the subject is still
visibly shaken and takes a -2 penalty on attack rolls,
saves, and checks for 3d10 minutes.

Author: 	Tenjac
Created: 	5/10/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WRACK; // put spell constant here
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
	//float fDuration = (6.0f * nCasterLvl);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eBlind = EffectBlindness();
	int nPenalty = 2;

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nPenalty += (nPenalty/2);
	}

	//Check Spell Resistance
	if(!HkResistSpell(oCaster, oTarget))
	{
		//Will save
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			//Blind
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, fDuration);

			//Clear all actions
			AssignCommand(oTarget, ClearAllActions());

			//Animation
			AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_SPASM, 6.0f));
			DelayCommand(6.0f,AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, (fDuration - 6.0f))));

			//Make them sit and wait.
			DelayCommand(6.2,SetCommandable(FALSE, oTarget));

			//Restore Control
			DelayCommand((fDuration - 6.2), SetCommandable(TRUE, oTarget));

			//After spell end
			effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
					eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
					eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));

			DelayCommand(fDuration, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (d10(3) * 60.0f)));
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


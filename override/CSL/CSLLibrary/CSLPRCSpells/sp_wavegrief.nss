//::///////////////////////////////////////////////
//:: Name 	Wave of Grief
//:: FileName sp_wave_grief.nss
//:://////////////////////////////////////////////
/**@file Wave of Grief
Enchantment [Evil, Mind-Affecting]
Level: Brd 2, Clr 2
Components: S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Area: Cone
Duration: 1 round/level
Saving Throw: Will negates
Spell Resistance: Yes

All within the cone when the spell is cast are
overcome with sorrow and grief. They take a -3 morale
penalty on all attack rolls, saving throws, ability
checks, and skill checks.

Material Component: Three tears.

Author: 	Tenjac
Created: 	5/9/2006
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
	int iSpellId = SPELL_WAVE_OF_GRIEF; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	location lLoc = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 7.62f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nPenalty = 3;
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	//float fDur = RoundsToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nPenalty += (nPenalty/2);
	}

	effect eVis = EffectVisualEffect(VFX_DUR_GLOW_BLUE);
	effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
			eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
			eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));
			eLink = EffectLinkEffects(eLink, eVis);


	while(GetIsObjectValid(oTarget))
	{
		if(!HkResistSpell(oCaster, oTarget))
		{
			//Save
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 7.62f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


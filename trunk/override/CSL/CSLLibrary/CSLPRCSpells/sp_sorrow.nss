//::///////////////////////////////////////////////
//:: Name 	Sorrow
//:: FileName sp_sorrow.nss
//:://////////////////////////////////////////////
/**@file Sorrow
Enchantment [Evil, Mind-Affecting]
Level: Brd 1, Clr 1
Components: V, S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: 1 round/level
Saving Throw: Will negates
Spell Resistance: Yes

Grief and sadness overcome the subject. She takes
a -3 morale penalty on all attack rolls, saving
throws, ability checks, and skill checks.

Material Component: A tear.

Author: 	Tenjac
Created: 	05/02/06
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
	int iSpellId = SPELL_SORROW; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	//float fDur = RoundsToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eVis = EffectVisualEffect(VFX_DUR_GLOW_BLUE);

		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_SORROW, oCaster);

	if(!HkResistSpell(oCaster, oTarget ))
	{
		//Save
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			effect eLink = EffectAttackDecrease(3, ATTACK_BONUS_MISC);
				eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 3, SAVING_THROW_TYPE_ALL));
				eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, 3));
				eLink = EffectLinkEffects(eLink, eVis);
				//Can't do ability without modifying the ability score itself; skipping

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget);
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

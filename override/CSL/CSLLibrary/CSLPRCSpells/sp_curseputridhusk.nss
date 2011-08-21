//::///////////////////////////////////////////////
//:: Name 	Curse of the Putrid Husk
//:: FileName sp_curse_phusk.nss
//:://////////////////////////////////////////////
/**@file Curse of the Putrid Husk
Illusion (Phantasm) [Fear, Mind Affecting, Evil]
Level: Brd 3, Sor/Wiz 3
Components: V, S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: 1 round + 1d10 minutes
Saving Throw: Will negates
Spell Resistance: Yes

This illusion forces the subject to believe his flesh
is rotting and falling off his body, and that his
internal organs are spilling out. If the target fails
his saving throw, he is dazed (and horrified) for 1
round. On the following round, he falls unconscious
for 1d10 minutes, during which time he cannot be roused
normally.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
#include "_HkSpell"

void PassOut(object oTarget)
{
	effect eBlind = EffectBlindness();
	effect eDeaf = EffectDeaf();
	effect eLink2 = EffectLinkEffects(eBlind, eDeaf);
	//float fDur = (d10(1) * 60.0f);
	
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(d10(), SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Blind/deaf
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, (fDuration - 1.0f));

	//Clear all actions
	AssignCommand(oTarget, ClearAllActions());

	//Animation
	AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, fDuration));

	//Make them sit and wait.
	DelayCommand(0.2,SetCommandable(FALSE, oTarget));

	//Restore Control
	DelayCommand((fDuration - 0.2), SetCommandable(TRUE, oTarget));
}




void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CURSE_OF_THE_PUTRID_HUSK; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//define vars
	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	effect eLink = EffectLinkEffects(EffectDazed(), EffectFrightened());
			eLink = EffectLinkEffects(eLink,EffectVisualEffect(VFX_IMP_DAZED_S));
			eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));


	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_CURSE_OF_THE_PUTRID_HUSK, oCaster);

	//Check Spell Resistance
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//Will save
		if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0f);

			DelayCommand(6.0f, PassOut(oTarget));
		}
	}

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

//:://////////////////////////////////////////////
//:: FileName: "ss_ep_nailedsky"
/* 	Purpose: Nailed to the Sky - the target, if it fails its Will save, is
		thrust into the sky, where is suffers from
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "_CSLCore_Magic"
//#include "inc_epicspells"
//#include "prc_inc_teleport"

void RunNailedToTheSky(object oTarget, int nDC);




#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_SCInclude_Transmutation"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_NAILSKY;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	object oTarget = HkGetSpellTarget();
	// HUMANOID SPELL ONLY!!!!
	if (CSLGetIsHumanoid(oTarget))
	{
		if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_NAILSKY))
		{
		
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));

			// Teleportation spell, so can be prevented by teleportation blocking effects
			if(CSLGetCanTeleport(oTarget))
			{
				RunNailedToTheSky(oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget));
			}
		}
	}
	else
	{
		FloatingTextStringOnCreature("*Invalid target for spell*", OBJECT_SELF, FALSE);
	}
	HkPostCast(oCaster);
}

void RunNailedToTheSky(object oTarget, int nDC)
{
	effect eVis1 = EffectVisualEffect(VFX_IMP_DEATH_WARD);
	effect eDam = HkEffectDamage(d6(2));
	if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC) && !GetIsDead(oTarget))
	{
		AssignCommand(oTarget, ClearAllActions(TRUE));
		AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0));
		DelayCommand(0.2, AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
		DelayCommand(0.3, AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
		DelayCommand(0.4, AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
		DelayCommand(0.5, AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
		DelayCommand(0.6, AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0, 6.0)));
		DelayCommand(0.8, SCDoPetrification(HkGetCasterLevel(),OBJECT_SELF,oTarget,HkGetSpellId(),nDC));
		DelayCommand(6.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
		DelayCommand(6.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		DelayCommand(6.0, RunNailedToTheSky(oTarget, nDC));
	}
	else CSLRemoveEffectPetrify(oTarget);
}

//::///////////////////////////////////////////////
//:: Name 	Bodak Birth
//:: FileName sp_bodak_birth.nss
//:://////////////////////////////////////////////
/**@file Bodak Birth
Transmutation [Evil]
Level: Clr 8
Components: V S, F, Drug
Casting Time: 1 minute
Range: Touch
Target: Caster or one creature touched
Duration: Instantaneous
Saving Throw: None (see text)
Spell Resistance: No

The caster transforms one willing subject (which can
be the caster) into a bodak. Ignore all of the subject's
old characteristics, using the bodak description in
the Monster Manual instead.

Before casting the spell, the caster must make a miniature
figurine that represents the subject, then bathe it in the
blood of at least three Small or larger animals. Once the
spell is cast, anyone that holds the figurine can attempt
to mentally communicate and control the bodak, but the
creature resists such control with a successful Will saving
throw. If the bodak fails, it must obey the holder of the
figurine, but it gains a new saving throw every day to break
the control. If the figurine is destroyed, the bodak
disintegrates.

Focus: Figurine of subject, bathed in animal blood.

Drug Component: Agony

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "prc_inc_spells"
//#include "spinc_common"


#include "_HkSpell"
#include "_CSLCore_Nwnx"
#include "_SCInclude_BarbRage"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BODAK_BIRTH; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//define vars
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	location lLoc = GetLocation(oTarget);
	effect eDeath = EffectDeath();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE, SPELL_BODAK_BIRTH, oCaster);

	//Agony check
	if(CSLGetPersistentInt(oCaster, "USING_AGONY"))
	{
		//"Willing" check
		if( CSLGetHasEffectTypeGroup(oTarget,EFFECT_TYPE_DAZED,EFFECT_TYPE_DOMINATED,EFFECT_TYPE_PARALYZE,EFFECT_TYPE_STUNNED,EFFECT_TYPE_CHARMED) || GetIsFriend(oTarget, oCaster) )
		{
			//Kill target
			SCDeathlessFrenzyCheck(oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);

			//Create Bodak
			object oBodak = CreateObject(OBJECT_TYPE_CREATURE, "nw_bodak", lLoc, FALSE);

			//Will save to avoid control
			if (!HkSavingThrow(SAVING_THROW_WILL, oBodak, (HkGetSpellSaveDC(oBodak,oCaster)), SAVING_THROW_TYPE_MIND_SPELLS, oCaster, 1.0))
			{
				effect eDom = SupernaturalEffect(EffectCutsceneDominated());
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDom, oBodak);
			}
		}

	}
	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
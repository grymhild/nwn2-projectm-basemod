//::///////////////////////////////////////////////
//:: Name 	Reality Blind
//:: FileName sp_real_blind.nss
//:://////////////////////////////////////////////
/**@file Reality Blind
Illusion (Phantasm) [Evil, Mind'Affecting]
Level: Sor/Wiz 3
Components: V, S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: Concentration (see below)
Saving Throw: Will negates
Spell Resistance: Yes

This spell overwhelms the target with hallucinations,
causing him to be blinded and stunned if he fails
the save. The subject can attempt a new saving throw
each round to end the spell.

Even after the subject succeeds at the save or the
caster stops concentrating, the subject is plagued
with nightmares every night. The nightmares prevent
the subject from benefiting from natural healing.
These nightmares continue until the caster dies or
the subject succeeds at a Will saving throw, attempted
once per night. This nightmare effect is treated as a
curse and thus cannot be dispelled. It is subject to
remove curse, however.

Material Component: A 2-inch diameter multicolored
disk of paper or ribbon.

Author: 	Tenjac
Created: 	6/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
void BlindLoop(object oTarget, object oCaster);
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REALITY_BLIND; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_REALITY_BLIND, oCaster);

	if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
		//Loop
		BlindLoop(oTarget, oCaster);
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
	CSLSpellEvilShift(oCaster);
}


void BlindLoop(object oTarget, object oCaster)
{
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);

	if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL)) //&& Conc check successful
	{
		effect eBlind = EffectLinkEffects(EffectBlindness(), EffectStunned());
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, 6.0f);

		//Schedule next round
		DelayCommand(6.0f, BlindLoop(oTarget, oCaster));
	}

	else
	{
		//Non healing code
		SetLocalInt(oCaster, "PRC_NoNaturalHeal", 1);
	}
}







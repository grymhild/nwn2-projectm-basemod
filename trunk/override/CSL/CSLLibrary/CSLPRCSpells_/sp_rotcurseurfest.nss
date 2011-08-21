//::///////////////////////////////////////////////
//:: Name: Rotting Curse of Urfestra
//:: Filename: sp_rotcurse_urf.nss
//::///////////////////////////////////////////////
/**@file Rotting Curse of Urfestra
Transmutation [Evil]
Level: Corrupt 3
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Living creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject's flesh and bones begin to rot. The subject
takes 1d6 points of Constitution damage immediately,
and a further 1d6 points of Constitution damage
every hour until the subject dies or the curse is
removed with a wish, miracle, or remove curse spell.

Corruption Cost: 1d6 points of Strength damage.

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "inc_abil_damage"
//#include "prc_inc_spells"
//#include "prc_spell_const"

//Pseudo-heartbeat function for abil damage
#include "_HkSpell"
#include "_SCInclude_Necromancy"

void DoCurseDam (object oTarget, object oCaster, int nMetaMagic)
{
	int nDam = HkApplyMetamagicVariableMods(d6(), 6);

	//Ability damage
	SCApplyAbilityDrainEffect(ABILITY_CONSTITUTION, nDam, oTarget, DURATION_TYPE_PERMANENT, 0.0f, FALSE, SPELL_ROTTING_CURSE_OF_URFESTRA, -1, oCaster);

	//Delay 1 hour, then hit the poor bastard again.
	DelayCommand(3600.0f, DoCurseDam(oTarget, oCaster, nMetaMagic));
}





void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ROTTING_CURSE_OF_URFESTRA; // put spell constant here
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
	int nCasterLvl = HkGetCasterLevel();
	int nMetaMagic = HkGetMetaMagicFeat();
	//	int nPenetr = nCasterLvl + SPGetPenetr();

		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_ROTTING_CURSE_OF_URFESTRA, oCaster);

	//Spell Resistance
	if (!HkResistSpell(OBJECT_SELF, oTarget ))
	{
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(oTarget,oCaster)))
		{
			DoCurseDam(oTarget, oCaster, nMetaMagic);
		}
	}

	//Corrupt spell cost
	int nCorrupt = d6(1);

	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, nCorrupt, 0);

	//Alignment shift if switch set
	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




//::///////////////////////////////////////////////
//:: Name: Red Fester
//:: Filename: sp_red_fester.nss
//::///////////////////////////////////////////////
/**Red Fester
Necromancy [Evil]
Level: Corrupt 3
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject's skin turns red and blisters. The
blisters quickly turn into oozing wounds. Furthermore,
the subject's sense of self becomes strangely clouded,
diminishing her self-esteem. The subject takes 1d6
points of Strength damage and 1d4 points of Charisma
damage.

Corruption Cost: 1d6 points of Strength damage.

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_inc_spells"
//#include "inc_abil_damage"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RED_FESTER; // put spell constant here
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

	//define vars
	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel();
	int nMetaMagic = HkGetMetaMagicFeat();

	//signal cast
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_RED_FESTER, oCaster);

	//Spell Resist
	if (!HkResistSpell(OBJECT_SELF, oTarget ))
	{
		//Fort save
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(oTarget,oCaster)))
		{
			//1d6 STR
			ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, d6(1), DURATION_TYPE_PERMANENT, FALSE, 0.0f, FALSE, SPELL_RED_FESTER, -1, oCaster);

			//1d4 CHA
			ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, d4(1), DURATION_TYPE_PERMANENT, FALSE, 0.0f, FALSE, SPELL_RED_FESTER, -1, oCaster);
		}
	}

	//Corruption cost 1d6 STR
	int nCost = d6(1);
	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, nCost, 0);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
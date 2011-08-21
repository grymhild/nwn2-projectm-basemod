//::///////////////////////////////////////////////
//:: Name 	Angry Ache
//:: FileName sp_angry_ache.nss
//:://////////////////////////////////////////////
/**@file Angry Ache
Necromancy
Level: Asn 1, Clr 1, Pain 1
Components: V, S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: 1 minute/level
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster temporarily strains the subject's muscles
in a very specific way. The subject feels a sharp
pain whenever she makes an attack. All her attack
rolls have a -2 circumstance penalty for every four
caster levels (maximum penalty -10).

Author: 	Tenjac
Created: 	02/05/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_inc_spells"


#include "_HkSpell"

void main()
{	
	

	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ANGRY_ACHE; // put spell constant here
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
	int nMetaMagic = HkGetMetaMagicFeat();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nPenalty = 2;
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_ANGRY_ACHE, oCaster);

	//Calculate DC
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);

	//Check Spell Resistance
	if(!HkResistSpell(oCaster, oTarget ))
	{
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{

			if(nCasterLvl > 7)
			{
				nPenalty = 4;
			}

			if(nCasterLvl > 11)
			{
				nPenalty = 6;
			}

			if(nCasterLvl > 15)
			{
				nPenalty = 8;
			}

			if(nCasterLvl > 19)
			{
				nPenalty = 10;
			}
		}
		//Construct effect
		effect ePenalty = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);

		//Apply Effect
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenalty, oTarget, fDuration);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}



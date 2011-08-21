//::///////////////////////////////////////////////
//:: Feeblemind
//:: [NW_S0_FeebMind.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Will save or take ability
//:: damage to Intelligence equaling 1d4 per 4 levels.
//:: Duration of 1 rounds per 2 levels.
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_feeblemind();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FEEBLEMIND;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	int iDuration = CSLGetMax(1, HkGetSpellDuration(oCaster)/2);
	int iDice = CSLGetMax(1, iSpellPower/4);    //Check to make at least 1d4 damage is done
	int nLoss;

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FEEBLEMIND));
		if (!HkResistSpell(oCaster, oTarget))
		{
			int iMetaMagic = GetMetaMagicFeat();
			int nWillResult = WillSave(oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS);
			if (nWillResult==SAVING_THROW_CHECK_FAILED)
			{
				nLoss = HkApplyMetamagicVariableMods(d4(iDice), 4 * iDice);

				effect eLink = EffectVisualEffect(VFX_DUR_SPELL_FEEBLEMIND);
				eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_INTELLIGENCE, nLoss));
				eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_CHARISMA, nLoss));

				float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
				
				HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
			}
			else
			{
				if (nWillResult==SAVING_THROW_CHECK_IMMUNE) SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
			}
		}
	}
	
	HkPostCast(oCaster);
}


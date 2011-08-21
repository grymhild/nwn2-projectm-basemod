/*
	----------------
	Vision of Heaven

	sp_visheaven
	----------------

	25/2/05 by Stratovarius

Enchantment
Level: Clr 1
Components: V
Casting Time: 1 action
Range: Close.
Target: One Evil Creature.
Duration: Instantaneous
Saving Throw: Will Negates
Spell Resistance: Yes

The target creature is dazed for one round.
*/
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VISION_OF_HEAVEN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDaze = EffectDazed();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	effect eLink = EffectLinkEffects(eMind, eDaze);
	eLink = EffectLinkEffects(eLink, eDur);

	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nDuration = 1;
	//check meta magic for extend
	if ((nMetaMagic & METAMAGIC_EXTEND))
	{
		nDuration = 2;
	}

	int CasterLvl = HkGetCasterLevel(OBJECT_SELF);
	//int nPenetr = CasterLvl + SPGetPenetr();

	// Evil only
	if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
			//Make SR check
			if (!HkResistSpell(OBJECT_SELF, oTarget ))
			{
				//Make Will Save to negate effect
				if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
				{
					//Apply VFX Impact and daze effect
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
				}
		}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );


}

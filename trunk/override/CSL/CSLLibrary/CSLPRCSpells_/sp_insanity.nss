/*
	----------------
	Insanity

	sp_insanity
	----------------

	25/2/05 by Stratovarius

	Class: Sorc/wiz 7
	Power Level: 7
	Range: Medium
	Target: One Humanoid
	Duration: Permanent
	Saving Throw: Will negates
	Spell Resistance: Yes

	Creatures affected by this power are permanently confused, as the spell.

	Modifed from psionic version by Primogenitor
*/
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_INSANITY; // put spell constant here
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
	
	

	

	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();

	int nDC = HkGetSpellSaveDC(oTarget,OBJECT_SELF);
	int nCaster = HkGetCasterLevel(OBJECT_SELF);
	effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
	effect eConfuse = EffectConfused();
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eConfuse);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = SupernaturalEffect(eLink);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		if (!HkResistSpell(OBJECT_SELF, oTarget ))
		{
			if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, 0.0 );
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

}
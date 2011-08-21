//::///////////////////////////////////////////////
//:: Aura of Protection: On Enter
//:: NW_S1_AuraProtA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Acts as a double strength Magic Circle against
	evil and a Minor Globe for those friends in
	the area.
*/

#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_FT_auraprot(); //SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oCreator = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCreator))
	{
		effect eLink = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
		eLink = EffectLinkEffects(eLink, EffectSpellLevelAbsorption(3, 0));
		eLink = EffectLinkEffects(eLink, SCCreateProtectionFromAlignmentLink(ALIGNMENT_EVIL, 2));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
}
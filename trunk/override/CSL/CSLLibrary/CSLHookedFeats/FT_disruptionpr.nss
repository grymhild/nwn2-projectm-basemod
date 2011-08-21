// nx_s1_disruption
//
// Disruption property: undead must make a DC 14 Will save or be destroyed. This is meant
// to be applied to blunt weapons only.
//
// JSH-OEI 6/26/07

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_disruptionpr();
	object oTarget = HkGetSpellTarget();
	effect eDisrupt = EffectDeath(FALSE, TRUE, TRUE);
	effect eHit = EffectNWN2SpecialEffectFile("sp_holy_hit");
	int iSaveDC = 14;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_TURNABLE;
	// Disruption has no effect against non-undead
	if ( !CSLGetIsUndead( oTarget ) )
		return;
		
	if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_NONE))
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDisrupt, oTarget);
	}
}
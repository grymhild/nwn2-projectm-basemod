#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_golemrangeds();
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oTarget = HkGetSpellTarget();
	int iDC = 32;
	effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

	effect eDamage;
	ActionCastFakeSpellAtObject(SPELL_BIGBYS_FORCEFUL_HAND, oTarget);
	int nSave = HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, SAVING_THROW_TYPE_NONE);
	int iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_REFLEX, SAVING_THROW_METHOD_FORHALFDAMAGE, Random(30) + 30, oTarget, iDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, nSave );
	if (!nSave)
	{
		effect eKnock = EffectKnockdown();
		float nDur = d6(1) + 1.0f;
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, nDur);
		eDamage = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING);
		if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
		{
			CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  nDur, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
		}
	}
	
	eDamage = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
}
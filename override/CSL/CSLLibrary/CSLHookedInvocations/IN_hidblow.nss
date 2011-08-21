//::///////////////////////////////////////////////
//:: Invocation: Hideous Blow
//:: NW_S0_IHideousB.nss
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"





void main()
{
	//scSpellMetaData = SCMeta_IN_hidblow();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	int iSpellDuration = HkGetSpellDuration( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
	int iBonus = HkGetWarlockBonus(oCaster);
	object oTarget = HkGetSpellTarget();
	CSLUnstackSpellEffects(oCaster, GetSpellId());
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	int iMetaMagic = GetMetaMagicFeat();
	int nDurVFX = VFX_INVOCATION_HIDEOUS_BLOW;
	if      (iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST)   nDurVFX = VFX_INVOCATION_DRAINING_BLOW;
	else if (iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST)  nDurVFX = VFX_INVOCATION_FRIGHTFUL_BLOW;
	else if (iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST) nDurVFX = VFX_INVOCATION_BESHADOWED_BLOW;
	else if (iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST)  nDurVFX = VFX_INVOCATION_BRIMSTONE_BLOW;
	else if (iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST)   nDurVFX = VFX_INVOCATION_HELLRIME_BLOW;
	else if (iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST) nDurVFX = VFX_INVOCATION_BEWITCHING_BLOW;
	else if (iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST)    nDurVFX = VFX_INVOCATION_NOXIOUS_BLOW;
	else if (iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST)  nDurVFX = VFX_INVOCATION_VITRIOLIC_BLOW;
	else if (iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST)  nDurVFX = VFX_INVOCATION_UTTERDARK_BLOW;
	effect eLink = EffectVisualEffect(nDurVFX);
	eLink = EffectLinkEffects(eLink, EffectHideousBlow(iMetaMagic));
	eLink = EffectLinkEffects(eLink, EffectAttackIncrease(iBonus));
	//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCaster);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, 12.0+RoundsToSeconds(iSpellDuration) );
	
	
	if ( GetIsObjectValid(oTarget) && oTarget != oCaster )
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			DelayCommand( 1.0f, ActionAttack(oTarget));
		}
	}
	
	HkPostCast(oCaster);
}
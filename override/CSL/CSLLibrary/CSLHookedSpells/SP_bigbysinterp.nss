//::///////////////////////////////////////////////
//:: Bigby's Interposing Hand
//:: [x0_s0_bigby1]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants -10 to hit to target for 1 round / level
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Evocation"
	
void main()
{
	//scSpellMetaData = SCMeta_SP_bigbysinterp();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BIGBYS_INTERPOSING_HAND;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iImpactSEF = VFX_DUR_BIGBYS_INTERPOSING_HAND;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = HkGetSpellTarget();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
		effect eLink = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);
		if (!HkResistSpell(oCaster, oTarget)) {
			if (!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC())) {
				float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(1 + HkGetSpellDuration(oCaster) / 6));
				int nMod = CSLGetMin(10, HkGetBestCasterModifier(oCaster, TRUE, FALSE));
				eLink = EffectLinkEffects(eLink, EffectAttackDecrease(nMod));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
				SendMessageToPC(oTarget, "Bigby's Interposing Hand Hit! -" + IntToString(nMod)+" AB applied.");
				SendMessageToPC(oCaster, "Bigby's Interposing Hand Hit! -" + IntToString(nMod)+" AB applied.");
				return;
			}
		}
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 1.0);
	}
	
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: Bigby's Forceful Hand
//:: [x0_s0_bigby2]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	dazed vs strength check (+14 on strength check); Target knocked down.
	Target dazed down for 1 round per level of caster

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





#include "_SCInclude_Evocation"

void main()
{
	//scSpellMetaData = SCMeta_SP_bigbysforcef();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BIGBYS_FORCEFUL_HAND;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iImpactSEF = VFX_IMP_BIGBYS_FORCEFUL_HAND;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
		effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
		if (!HkResistSpell(oCaster, oTarget)) {
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC())) {
				float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(3));
				effect eLink = EffectVisualEffect(VFX_DUR_SPELL_DAZE);
				eLink = EffectLinkEffects(eLink, EffectDazed());
				if (!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC()))
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, fDuration/2);
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  fDuration/2, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
					SendMessageToPC(oTarget, "Forceful Hand knocks you to the ground!");
					SendMessageToPC(oCaster, "Forceful Hand knocks your Target to the ground.");
				} else {
					SendMessageToPC(oTarget, "Forceful Hand slaps you silly.");
					SendMessageToPC(oCaster, "Forceful Hand slaps your Target silly.");
				}
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
	}
	
	HkPostCast(oCaster);
}


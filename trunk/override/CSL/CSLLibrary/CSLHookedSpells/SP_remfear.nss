//::///////////////////////////////////////////////
//:: Remove Fear
//:: NW_S0_RmvFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All allies within a 10ft radius have their fear
	effects removed and are granted a +4 Save versus
	future fear effects.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_remfear();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REMOVE_FEAR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_CONJURATION);
	effect eRemoved = EffectVisualEffect( VFX_HIT_SPELL_ABJURATION );
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(100));
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_CURE_AOE), HkGetSpellTargetLocation());
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REMOVE_FEAR, FALSE));
			
			if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELLABILITY_AURA_FEAR, SPELLABILITY_DRAGON_FEAR ) )
			{
				DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eRemoved, oTarget));	
			}
			CSLRemoveEffectByType(oTarget, EFFECT_TYPE_FRIGHTENED);
			float fDelay = CSLRandomBetweenFloat();
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, fDuration));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	}
	
	HkPostCast(oCaster);
}


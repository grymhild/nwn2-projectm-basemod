//::///////////////////////////////////////////////
//:: Aura of Glory
//:: x0_s0_auraglory.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +2 Charisma Bonus
 All allies in medium area of effect: +5 Saves against Fear
 All allies in medium area of effect: 1d4 hitpoints healing
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_auraofglory();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_AURAOFGLORY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster ) ));
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_AURA_OF_GLORY);   // NWN2 VFX

	effect eChaBonus = EffectLinkEffects(eVis, EffectAbilityIncrease(ABILITY_CHARISMA, 4));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eChaBonus, oCaster, fDuration);
	
	effect eLink = EffectLinkEffects(eVis, EffectSavingThrowIncrease(SAVING_THROW_ALL, 5, SAVING_THROW_TYPE_FEAR));
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) && oTarget!=oCaster)
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
			DelayCommand(CSLRandomBetweenFloat(0.4, 1.1), HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() ) );
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
	}
	
	HkPostCast(oCaster);
}


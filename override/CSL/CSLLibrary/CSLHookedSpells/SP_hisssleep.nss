//::///////////////////////////////////////////////
//:: Hiss Of Sleep
//:: nx_s0_hisssleep.nss
//:://////////////////////////////////////////////
/*
Caster Level(s): Wizard / Sorcerer 7
Innate Level: 7
School: Enchantment
Descriptor(s): Mind-Affecting
Component(s): Verbal
Range: Short
Area of Effect / Target: Large
Duration: 1 round/level
Save: Will negates
Spell Resistance: No

The targets of this spell fall into a comatose slumber.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"







void main()
{
	//scSpellMetaData = SCMeta_SP_hisssleep();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HISS_OF_SLEEP;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);

	
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_HISS_OF_SLEEP);
	eLink = EffectLinkEffects(eLink, EffectSleep());
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(7 + HkGetSpellDuration( oCaster )/5));
	location lTarget = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster)) {
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster)) {
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}


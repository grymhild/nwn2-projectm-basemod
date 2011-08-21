//:://///////////////////////////////////////////////
//::Song of Discord
//:: nw_s0_sngodisc.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/11/05
//::////////////////////////////////////////////////
/*
		5.4.5.2.2 Song of Discord
		PHB, pg. 281
		School:        Enchantment (Compulsion) [Mind-Affecting, Sonic]
		Components:  Verbal, Somatic
		Range:      Medium
		Target:        Creature within a 20-ft.-radius
		Duration:   Round / level
		Saving Throw:   Will negates
		Spell Resist:   Yes

		This spell causes those within its area to turn on each other rather than
		attack their foes. Each creature has a 50% chance of attacking their nearest
		target rather than each other


*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"








void main()
{
	//scSpellMetaData = SCMeta_SG_songdiscord();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel= HkGetSpellPower( oCaster, CLASS_TYPE_BARD ); // OldGetCasterLevel(oCaster);
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_SONG_OF_DISCORD);
	eLink = EffectLinkEffects(eLink, EffectConfused());
	location lTarget = HkGetSpellTargetLocation();
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT), lTarget);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
	while (GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
			SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_SONG_OF_DISCORD, TRUE ) );
			if (!HkResistSpell(oCaster, oTarget, 0.0)) {
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster, 0.0)) {
					float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(HkGetScaledDuration( HkGetSpellDuration( oCaster ), oTarget)));
					DelayCommand(CSLRandomBetweenFloat(), HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget);
	}
	HkPostCast(oCaster);
}


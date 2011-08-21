//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Countersong
//:: nw_s2_sngcountr.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/06/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*

	Countersong (Req: Perform 3): This song puts a buff on the targeted ally
	that lasts for 10 rounds or until discharged. Any hostile magic spell
	that would affect the countersong's target has to make a Spell Resistance
	check of 10 + levels of bard the singer possesses. Whether the spell is
	blocked or not, the counter-song is discharged.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"



void main()
{
	//scSpellMetaData = SCMeta_SG_songcounters();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_SONG_COUNTERSONG;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_DUR_BARD_SONG;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	
	if (!SCGetCanBardSing(oCaster)) return; // Awww :(
	if (!GetHasFeat(FEAT_BARD_SONGS, oCaster)) {
		FloatingTextStrRefOnCreature(SCSTR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS, oCaster); // no more bardsong uses left
		return;
	}
	if (GetSkillRank(SKILL_PERFORM)<3) { //Checks your perform skill so nubs can't use this song
		FloatingTextStrRefOnCreature (182800, oCaster);
		return;
	}

	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = HkGetSpellTarget();
	if (SCGetIsObjectValidSongTarget(oTarget))
	{
		int iLevel = GetBardicClassLevelForUses(OBJECT_SELF);
		int nCha = GetAbilityModifier(ABILITY_CHARISMA);
		if (nCha < 0)
		{
			nCha = 0;
		}	
		if (!GetHasFeat(FEAT_DISCHORD_IMPROVED_COUNTERSPELL , OBJECT_SELF))
		{
			nCha = 0;
		}
		float fDuration = RoundsToSeconds(SCApplySongDurationFeatMods(10+nCha, oCaster));
		effect eLink = EffectVisualEffect(VFX_HIT_BARD_COUNTERSONG);
		eLink = EffectLinkEffects(eLink, EffectSpellResistanceIncrease(10 + iLevel + nCha, 1 + nCha ));
		eLink = ExtraordinaryEffect(eLink);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}
	HkPostCast(oCaster);
}


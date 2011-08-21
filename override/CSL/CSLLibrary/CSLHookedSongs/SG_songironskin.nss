//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Ironskin Chant
//:: nw_s2_sngiron.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/09/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	Ironskin Chant (Req: 9th level, Perform 12): As a round action the player
	can expend one daily uses of his bardic music ability to provide damage
	reduction 5/- to the party for 4 rounds.

		[Rules Note] This is a Bardic Music feat from Complete Adventurer pg.113.
		This is granted as a class ability instead of a feat and it differs
		in several respects. It is a full round action to activate instead of
		a swift action (which doesn't exist in NWN2), the duration is 2 rounds
		instead of a single round, and it affects the entire party of 4
		instead of one person. In real-time having such a short targeted
		effect would be cumbersome for the user, so it's made simple.

*/
//:://////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"




void main()
{
	//scSpellMetaData = SCMeta_SG_songironskin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_DUR_BARD_SONG;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	if (GetSkillRank(SKILL_PERFORM)<12) { //Checks your perform skill so nubs can't use this song
		FloatingTextStrRefOnCreature (182800, oCaster);
		return;
	}

	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);

	effect eLink = EffectDamageReduction(5, 0, 0, DR_TYPE_NONE);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_BARD_SONG_IRONSKIN));
	eLink = ExtraordinaryEffect(eLink);
	
	float fDuration = RoundsToSeconds(SCApplySongDurationFeatMods(4, oCaster)); // Rounds
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	SCApplyFriendlySongEffectsToParty(oCaster, GetSpellId(), fDuration, eLink);
	
	HkPostCast(oCaster);
}


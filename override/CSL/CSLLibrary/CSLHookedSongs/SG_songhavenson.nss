//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Haven Song
//:: nw_s2_snghaven.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/12/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*

	Haven Song (Req: 3rd level, Perform 6)
	This song works like the Sanctuary spell except the saving throw is a
	Will save against a DC of 11 + ( Perform / 2) and its duration is
	10 rounds or until the bard does a hostile action. The Fascinate and
	Cloud Mind songs do not count as hostile actions.

*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"





void main()
{
	//scSpellMetaData = SCMeta_SG_songhavenson();
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
	if (GetSkillRank(SKILL_PERFORM)<6) { //Checks your perform skill so nubs can't use this song
		FloatingTextStrRefOnCreature (182800, oCaster);
		return;
	}

	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);

	object oTarget = HkGetSpellTarget();
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (SCGetIsObjectValidSongTarget(oTarget))
	{
		//int   nPerform    = GetSkillRank(SKILL_PERFORM);
		int   iSaveDC     = 11 + GetAbilityModifier(ABILITY_CHARISMA) + HkGetCasterLevel( oCaster, CLASS_TYPE_BARD)/2;
		float fDuration = RoundsToSeconds(SCApplySongDurationFeatMods(10, oCaster));
		effect eLink = EffectVisualEffect(VFX_HIT_BARD_HAVEN_SONG);
		eLink = EffectLinkEffects(eLink, EffectSanctuary(iSaveDC));
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SANCTUARY, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}
	
	HkPostCast(oCaster);
}


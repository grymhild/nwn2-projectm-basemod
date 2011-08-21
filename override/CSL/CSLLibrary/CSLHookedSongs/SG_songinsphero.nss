//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Heroics
//:: NW_S2_SngInHero
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/06/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	This spells applies bonuses to a specific ally
	target.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"




void main()
{
	//scSpellMetaData = SCMeta_SG_songinsphero();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_CAST_BARD_INS;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	if (GetSkillRank(SKILL_PERFORM)<18) { //Checks your perform skill so nubs can't use this song
		FloatingTextStrRefOnCreature (182800, oCaster);
		return;
	}

	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);

	object oTarget  = HkGetSpellTarget();

	float fDuration = RoundsToSeconds(SCApplySongDurationFeatMods(5, oCaster));
	int nHP = 4 * GetBardicClassLevelForUses(oCaster);
	int nAC         = 4;
    int iSave       = 4;
    
    if (GetHasFeat(FEAT_SONG_OF_THE_HEART, OBJECT_SELF))
	{
		nAC += 1;
		iSave += 1;
		nHP = nHP + 4;
	}
	
	effect eLink = EffectACIncrease(nAC, AC_DODGE_BONUS);
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, nAC));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_HIT_BARD_INS_HEROICS));
	eLink = ExtraordinaryEffect(eLink);
	effect eHP = ExtraordinaryEffect(EffectTemporaryHitpoints(nHP));
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	
	if (GetHasFeat(FEAT_EPIC_CHORUS_OF_HEROISM, OBJECT_SELF, TRUE))
	{
		SCApplyFriendlySongEffectsToParty(oCaster, GetSpellId(), fDuration, eLink);
		SCApplyFriendlySongEffectsToParty(oCaster, 550, fDuration, eHP); //HACK: To trick function to apply two effects
	}
	else
	{
		SCApplyFriendlySongEffectsToTarget(oCaster, GetSpellId(), fDuration, eLink);
		SCApplyFriendlySongEffectsToTarget(oCaster, 550, fDuration, eHP);
	}
	HkPostCast(oCaster);
}


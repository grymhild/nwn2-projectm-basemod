//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Legion
//:: NW_S2_SngInLegn
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/06/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	This spells applies bonuses to all allies
	within 60 feet.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"





void main()
{
	//scSpellMetaData = SCMeta_SG_songinsplegi();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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
	if (GetSkillRank(SKILL_PERFORM)<21) { //Checks your perform skill so nubs can't use this song
		FloatingTextStrRefOnCreature (182800, oCaster);
		return;
	}

	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);

	float fDuration = RoundsToSeconds(SCApplySongDurationFeatMods(10, oCaster));
	int nBABMin = 0;
	object oLeader = oCaster; //GetFactionLeader(oCaster);
	object oTarget = GetFirstFactionMember(oLeader, FALSE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLPCIsClose(oCaster, oTarget, 10)) 
		{
			nBABMin = CSLGetMax(nBABMin, GetTRUEBaseAttackBonus(oTarget) );
		}
		oTarget = GetNextFactionMember(oLeader, FALSE);
	}

	effect eLink = EffectVisualEffect(VFX_HIT_BARD_INS_LEGION);
	eLink = EffectLinkEffects(eLink, EffectBABMinimum(nBABMin));
	eLink = EffectLinkEffects(eLink, EffectDamageIncrease(4, DAMAGE_TYPE_BLUDGEONING ));
	eLink = ExtraordinaryEffect(eLink);

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_BARD_SONG), GetLocation(oCaster));
	SCApplyFriendlySongEffectsToArea(oCaster, GetSpellId(), fDuration, RADIUS_SIZE_COLOSSAL, eLink);

	HkPostCast(oCaster);
}


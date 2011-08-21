//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Cloud Mind
//:: nw_s2_sngcldmnd.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/19/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	Haven Song (Req: 3rd level, Perform 6): This song works like the Sanctuary
	spell except the saving throw is a Will save against a DC of 11 + ( Perform / 2)
	and its duration is 10 rounds or until the bard does a hostile action.
	The Fascinate and Cloud Mind songs do not count as hostile actions.
	
	SEED: From wiki: The saving throw DC is increased to 14 + 1/2 the bard's level + the bard's Charisma modifier
	
	NWN2WIKI:
	(Req: 6th level, Perform 9): This is a more potent, single-target
	version of the Fascinate bard song. The saving throw DC is increased to 14 + 1/2 the bard's level + the bard's Charisma modifier, 
	and enemies being attacked nearby don't break the effect. There is a 5-round cool down before this ability can be used again.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"




void main()
{
	//scSpellMetaData = SCMeta_SG_songcloudmin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_DUR_BARD_SONG;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	
	
	if (!SCGetCanBardSing(oCaster))
	{
		return;
	}
	if (!GetHasFeat(FEAT_BARD_SONGS, oCaster))
	{
		FloatingTextStrRefOnCreature(SCSTR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS, oCaster); // no more bardsong uses left
		return;
	}
	if (GetSkillRank(SKILL_PERFORM)<6) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature (182800, oCaster);
		return;
	}
	
	//int nSpellDC = d20(1) + HkGetCasterLevel( oCaster, CLASS_TYPE_BARD)/2 + GetAbilityModifier(ABILITY_CHARISMA);
	int     nSpellDC    = d20(1) + GetSkillRank(SKILL_PERFORM);
	if (GetHasFeat(FEAT_DRAGONSONG))
	{
		nSpellDC = nSpellDC + 2;
	}

	if (GetHasFeat(FEAT_ABILITY_FOCUS_BARDSONG))
	{
		nSpellDC = nSpellDC + 2;
	}
	
	if (GetHasFeat(FEAT_SONG_OF_THE_HEART))
	{
		nSpellDC++;
	}
				
	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = HkGetSpellTarget();
	if (GetIsObjectValid(oTarget))
	{
		if (SCGetIsObjectValidSongTarget(oTarget))
		{
			if (GetIsEnemy(oTarget))
			{
				
				if ( WillSave(oTarget, nSpellDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster)==SAVING_THROW_CHECK_FAILED )
				{
					float fDuration = RoundsToSeconds(SCApplySongDurationFeatMods(10, oCaster)); // Rounds
					effect eLink = EffectMesmerize(MESMERIZE_BREAK_ON_ATTACKED, 30.0f );
					eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_HIT_BARD_CLOUDMIND));
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
				}
			}
		}
	}
	HkPostCast(oCaster);
}


//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Fascinate
//:: nw_s2_sngfascin.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/06/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	Fascinate
	This song acts like a mesmerization effect from a MMO. Every hostile
	creature within 90' must make a Will save (against a DC of 11 + CHA modifier).
	This is an enchantment (compulsion) mind-affecting ability for purposes of
	resistance. If the target fails this save, then they are dazed for as long
	as the song is playing and the bard is within 90' of them. The dazed
	condition is identical to the Stinking Cloud spell, and means that the
	target can’t attack or cast spells. This effect is instantly broken if
	they are attacked by anyone. Additionally, if someone within 10' is being
	attacked the mesmerization effect automatically ends (potentially another
	saving throw may be allowed). There is a cool down of 10 rounds before
	this ability can be used again.
	Fascinate effects up to one enemy per level of the Bard.

	[Rules Note] The Fascinate ability has a different effect in 3.5, which
	makes it so that the targets sit in place and listen to the bard unless
	certain conditions are met (one of which is any obvious hostile actions).
	This interpretation of that song is more concrete making it easier for
	the computer to check. Unlike the PHB, this ability can be used in combat.
	
	NWN2WIKI:
	(Req: 1st level, Perform 3): Every hostile creature within 90 feet must make a Will save 
	(against a DC of 11 + 1/2 the bard's level + the bard's Charisma modifier). This is an enchantment (compulsion) 
	mind-affecting ability. If the target fails this save, then they are dazed for as long as the song is playing 
	and the bard is within 90 feet of them. If a creature is attacked, or is within 10 feet of a creature being attacked, 
	the effect ends for that creature, though anyone who fails their saving throw will be dazed for at least one round. There is a cool down 
	of 10 rounds before this ability can be used again. Fascinate effects up to one enemy per level of the bard.

*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"





void main()
{
	//scSpellMetaData = SCMeta_SG_songfascinat();
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

	float fDuration = RoundsToSeconds(SCApplySongDurationFeatMods(10, oCaster));
	int nAffectedCreatures = GetBardicClassLevelForUses( oCaster );// HkGetCasterLevel( oCaster, CLASS_TYPE_BARD);
	//int nSpellDC = 11 + GetAbilityModifier(ABILITY_CHARISMA) + GetLevelByClass(CLASS_TYPE_BARD, oCaster)/2;
	int     nChaMod     = GetAbilityModifier(ABILITY_CHARISMA);
	int     nSpellDC    = 11 + HkGetCasterLevel( oCaster, CLASS_TYPE_BARD)/2 + GetAbilityModifier(ABILITY_CHARISMA);

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
		
	effect eImpact = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);
	effect eMesmerized = EffectMesmerize(MESMERIZE_BREAK_ON_ATTACKED + MESMERIZE_BREAK_ON_NEARBY_COMBAT, 30.0);
	location lCaster = GetLocation(oCaster);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCaster);
	while(GetIsObjectValid(oTarget))
	{
		if (SCGetIsObjectValidSongTarget(oTarget))
		{
			if (GetIsEnemy(oTarget))
			{
				if ( WillSave(oTarget, nSpellDC, SAVING_THROW_TYPE_MIND_SPELLS , oCaster)==SAVING_THROW_CHECK_FAILED )
				{
					float fDelay = 0.15 * GetDistanceToObject(oTarget);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMesmerized, oTarget, fDuration));
					if (--nAffectedCreatures < 1) break;
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCaster);
	}
	HkPostCast(oCaster);
}


//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Song of Freedom
//:: nw_s2_sngfreedm.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/06/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	Song of Freedom (Req: 12th level, Perform 15):
	At 12th level a bard gains this ability which allows them to do the
	equivalent of a Break Enchantment spell, with the caster level being
	equal to the bard's spell level.

A bard of 12th level or higher with 15 or more ranks in a Perform skill can
use music or poetics to create an effect equivalent to the break
enchantment spell (caster level equals the character’s bard level). Using
this ability requires 1 minute of uninterrupted concentration and music,
and it functions on a single target within 30 feet. A bard can’t use song
of freedom on himself.


		Break Enchantment
		Abjuration
		Level:   Brd 4, Clr 5, Luck 5, Pal 4, Sor/Wiz 5
		Components:     V, S
		Casting Time:      1 minute
		Range:            Close (25 ft. + 5 ft./2 levels)
		Targets:        Up to one creature per level, all within 30 ft. of each other
		Duration:         Instantaneous
		Saving Throw:      See text
		Spell Resistance:  No

		This spell frees victims from enchantments, transmutations, and curses.
		Break enchantment can reverse even an instantaneous effect. For each
		such effect, you make a caster level check (1d20 + caster level,
		maximum +15) against a DC of 11 + caster level of the effect. Success
		means that the creature is free of the spell, curse, or effect. For a
		cursed magic item, the DC is 25.

		If the spell is one that cannot be dispelled by dispel magic, break
		enchantment works only if that spell is 5th level or lower.

		If the effect comes from some permanent magic item break enchantment
		does not remove the curse from the item, but it does frees the victim
		from the items effects.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"
#include "_SCInclude_Abjuration"





void main()
{
	//scSpellMetaData = SCMeta_SG_songfree();
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
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	
	if (!SCGetCanBardSing(oCaster)) return; // Awww :(
	if (!GetHasFeat(FEAT_BARD_SONGS, oCaster)) {
		FloatingTextStrRefOnCreature(SCSTR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS, oCaster); // no more bardsong uses left
		return;
	}
	if (GetSkillRank(SKILL_PERFORM)<15) { //Checks your perform skill so nubs can't use this song
		FloatingTextStrRefOnCreature (182800, oCaster);
		return;
	}

	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);

	//int iLevel = GetLevelByClass(CLASS_TYPE_BARD);
	int iLevel = GetBardicClassLevelForUses(oCaster);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	object oTarget = HkGetSpellTarget();
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	location lLocal = HkGetSpellTargetLocation();
	float fDelay;
	int nStripCnt = SCGetDispellCount(iSpellId, FALSE);
	if (  GetIsObjectValid(oTarget)  )
	{
		fDelay = 0.15 * GetDistanceBetween(oCaster, oTarget);
		DelayCommand( fDelay, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELL_BREAK_ENCHANTMENT) );
		nStripCnt--;
	}
	else
	{
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lImpactLoc, FALSE, OBJECT_TYPE_CREATURE );
		while (GetIsObjectValid(oTarget) && nStripCnt > 0)
		{
			if (SCGetIsObjectValidSongTarget(oTarget))
			{
				if (oTarget != oCaster && CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) )
				{
					fDelay = 0.15 * GetDistanceBetween(oCaster, oTarget);
					DelayCommand( fDelay, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELL_BREAK_ENCHANTMENT) );
					nStripCnt--;
					
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lImpactLoc, FALSE, OBJECT_TYPE_CREATURE );
		}
	}	
		

	
	HkPostCast(oCaster);
}


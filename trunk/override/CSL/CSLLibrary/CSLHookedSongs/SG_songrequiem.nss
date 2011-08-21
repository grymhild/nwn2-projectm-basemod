//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Song/Hymn of Requiem
//:: nx_s2_sngrequiem
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/23/2007
//:: Copyright (c) 2007 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	Song of Requiem:
	This song damages all enemies within 20 feet for 5 rounds.
	The total sonic damage caused is equal to 2*Perform skill; the minimum damage
	caused per target is Perform/3. For example, with Perform 30, a total of
	60 points of damage is inflicted each round. If six (or more) enemies are
	affected, they would each take 10 sonic damage per round. This ability has a
	cooldown of 20 rounds.
	
	Hymn of Requiem:
	The character's Song of Requiem now also heals all party members. The amount
	healed is the same as the damage caused by the Hymn and is divided among all
	party members; the minimum amount healed per ally is Perform/3. For example,
	if the total damage dealt is 60 and four characters are in the party, each is
	healed 15 hit points per round.
*/
// ChazM 5/31/07 renamed SCDoHealing() to DoPartyHealing() (SCDoHealing() is declared in nw_i0_spells)
// AFW-OEI 07/20/2007: NX1 VFX.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"




int GetBasePerform(object oPC)
{
	int nSkill = 0;
	nSkill += GetSkillRank(SKILL_PERFORM, oPC, TRUE);
	nSkill += GetAbilityModifier(ABILITY_CHARISMA, oPC);
	nSkill += GetHasFeat(FEAT_SKILL_FOCUS_PERFORM, oPC) * 3;
	nSkill += GetHasFeat(FEAT_ARTIST, oPC) * 2;
	return nSkill;
}

void DoDamage(object oCaster, int iSpellId)
{
	location locCaster = GetLocation(oCaster);
	int nNumTargets = 0;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster);
	while (GetIsObjectValid(oTarget))
	{
		if (SCGetIsObjectValidSongTarget(oTarget) && GetIsEnemy(oTarget, oCaster)) nNumTargets++;
		if (nNumTargets >= 6) break;  // Don't need to go higher than 6 enemies.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster);
	}
	if (!nNumTargets) return;
	
	int nPerformSkill = GetBasePerform(oCaster);
	int iDamage = ( 2 * nPerformSkill ) / nNumTargets;   // Damage per target is (2*Perform)/Number of Enemies, capped at most 6 enemies.
	float fDelay;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	effect eDam;
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster);
	while (GetIsObjectValid(oTarget))
	{
		if (SCGetIsObjectValidSongTarget(oTarget) && GetIsEnemy(oTarget, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));     
			eDam = EffectDamage(iDamage, DAMAGE_TYPE_SONIC);
			fDelay = 0.15 * GetDistanceToObject(oTarget);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, locCaster);
	}
}

void DoPartyHealing(object oCaster, int iSpellId) {
	int nNumTargets = 0;
	object oLeader = GetFactionLeader(oCaster);
	
	location lTarget = GetLocation( oCaster ); //GetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF) &&  SCGetIsObjectValidSongTarget(oTarget) )
		{
			if ( GetCurrentHitPoints(oTarget) < GetMaxHitPoints(oTarget) )
			{
				nNumTargets++;
			}	
		}        	
     	//Get the next target in the specified area around the caster
     	if (nNumTargets >= 6) break;
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	if (!nNumTargets) return;
	
	
	
	//object oTarget = GetFirstFactionMember(oLeader, FALSE);
	//while (GetIsObjectValid(oTarget))
	//{
	//	if (SCGetIsObjectValidSongTarget(oTarget, RADIUS_SIZE_COLOSSAL) && GetCurrentHitPoints(oTarget) < GetMaxHitPoints(oTarget) ) 
	//	{
	//		nNumTargets++;
	//	}
	//	if (nNumTargets >= 6) break;
	//	oTarget = GetNextFactionMember(oLeader, FALSE);
	//}
	//if (!nNumTargets) return;
	
	int nPerformSkill = GetBasePerform(oCaster);
	int nHeal = 2 * nPerformSkill / nNumTargets;
	float fDelay;
	effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
	effect eHeal;
	
	
	
	//location lTarget = GetLocation( oCaster ); //GetSpellTargetLocation();
	oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF) &&  SCGetIsObjectValidSongTarget(oTarget) )
		{
			
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			eHeal = EffectHeal(nHeal);
			fDelay = 0.15 * GetDistanceToObject(oTarget);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				
		}        	
     	//Get the next target in the specified area around the caster
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	
	
	//oTarget = GetFirstFactionMember(oLeader, FALSE);
	//while (GetIsObjectValid(oTarget))
	//{
	//	if (SCGetIsObjectValidSongTarget(oTarget, RADIUS_SIZE_COLOSSAL))
	//	{
	//		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//		eHeal = EffectHeal(nHeal);
	//		fDelay = 0.15 * GetDistanceToObject(oTarget);
	//		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
	//		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	//	}
	//	oTarget = GetNextFactionMember(oLeader, FALSE);
	//}
}
			
void RunSongEffects(int nCallCount, object oCaster, int iSpellId) {
	//if (!SCGetCanBardSing(oCaster)) return;
	int nPerformRanks = GetSkillRank(SKILL_PERFORM, oCaster, TRUE);
	if (nPerformRanks<24)
	{
		FloatingTextStrRefOnCreature (182800, oCaster);
		return;
	}
	//int nSingingSpellId = SCFindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
	//if (nSingingSpellId==iSpellId) {
		effect ePulse = EffectVisualEffect(VFX_HIT_BARD_REQUIEM);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePulse, oCaster);
		DoDamage(oCaster, iSpellId);
		if (GetHasFeat(FEAT_EPIC_HYMN_OF_REQUIEM, oCaster)) DoPartyHealing(oCaster, iSpellId);
		nCallCount++;
		if (nCallCount>SCApplySongDurationFeatMods(5, oCaster)) { // Requiem is for 5 rounds.
			SCRemoveBardSongSingingEffect(oCaster, GetSpellId());   // AFW-OEI 07/19/2007: Terminate song.
			return;
		} else {   // Run once per "round" (5.5 secs gives time for some processing lag).
			DelayCommand(5.5f, RunSongEffects(nCallCount, oCaster, iSpellId));
		}
	//}
}


void main()
{
	//scSpellMetaData = SCMeta_SG_songrequiem();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	
	//if (!SCGetCanBardSing(oCaster)) return;
	//if (!SCAttemptNewSong(oCaster, TRUE)) return;
	if (!GetHasFeat(FEAT_BARD_SONGS, oCaster)) {
		FloatingTextStrRefOnCreature(SCSTR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS, oCaster); // no more bardsong uses left
		return;
	}
	effect eFNF = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_BARD_SONG));
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oCaster));
	DelayCommand(0.1f, RunSongEffects(1, oCaster, GetSpellId()));
	DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
	
	HkPostCast(oCaster);
}


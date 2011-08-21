//::///////////////////////////////////////////////
//:: Snowflake Wardance
//:: cmi_s2_sngsnwflkwar
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: August 29, 2009
//:://////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"


#include "_HkSpell"

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
	int iImpactSEF = VFX_DUR_BARD_SONG;
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

	int bValid = IsSnowflakeValid(oCaster);

	if ( bValid )
	{
		int nChaBonus = GetAbilityModifier(ABILITY_CHARISMA);
		if (nChaBonus < 1)
			nChaBonus = 1;
		effect eAB = EffectAttackIncrease(nChaBonus);
		eAB = SupernaturalEffect(eAB);
		eAB = SetEffectSpellId(eAB, SONG_SNOWFLAKE_WARDANCE );

		int nDuration = 1 + GetSkillRank(SKILL_PERFORM);
		
		effect eDur  = EffectVisualEffect( VFX_DUR_SPELL_RAGE );
		float nFatigueDuration = RoundsToSeconds(nDuration + 2);
		eDur = SupernaturalEffect(eDur);
		eDur = SetEffectSpellId(eDur, SONG_SNOWFLAKE_WARDANCE );
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, OBJECT_SELF, nFatigueDuration));
		
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SONG_SNOWFLAKE_WARDANCE );
		CSLApplyFatigue(OBJECT_SELF, TurnsToSeconds(10), ( RoundsToSeconds(nDuration+1) ), SONG_SNOWFLAKE_WARDANCE );
		DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAB, OBJECT_SELF, RoundsToSeconds(nDuration)));
		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
		
		location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
		effect eImpactVis = EffectVisualEffect( iImpactSEF );
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
		
	}
	else
	{
		SendMessageToPC(oCaster, "You must be wearing light or no armor and wielding a one-handed slashing weapon (both must be slashing if two weapons are used)." );
	}
	HkPostCast(oCaster);
}
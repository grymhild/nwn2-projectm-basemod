//::///////////////////////////////////////////////
//:: Epic of the Lost King
//:: cmi_s2_sngepiclstking
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: August 29, 2009
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"



#include "_HkSpell"

void main()
{	
	
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
	
	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	if ( SCGetCanBardSing( OBJECT_SELF ) == FALSE )
	{
		return; // Awww :(
	}

	if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
	{
		FloatingTextStrRefOnCreature(SCSTR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS,OBJECT_SELF); // no more bardsong uses left
		return;
	}

	int		nPerform	= GetSkillRank(SKILL_PERFORM);

	if (nPerform < 6 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}
	
	/*
	object oTarget = GetFirstFactionMember( OBJECT_SELF, FALSE );
	while ( GetIsObjectValid( oTarget ) )
	{
		if ( SCGetIsObjectValidSongTarget(oTarget) && GetArea(oTarget) == GetArea(OBJECT_SELF) )
		{
				if(GetHasSpellEffect(FATIGUE,oTarget) || GetHasSpellEffect(EXHAUSTED,oTarget))
				{
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, FATIGUE );
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, EXHAUSTED );
				}
		}
		oTarget = GetNextFactionMember( OBJECT_SELF, FALSE );
	}
	*/
	
	location lTarget = GetLocation( oCaster ); //GetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF) &&  SCGetIsObjectValidSongTarget(oTarget) )
		{
			
			CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, FATIGUE, EXHAUSTED );
				
		}        	
     	//Get the next target in the specified area around the caster
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
	
	HkPostCast(oCaster);

}
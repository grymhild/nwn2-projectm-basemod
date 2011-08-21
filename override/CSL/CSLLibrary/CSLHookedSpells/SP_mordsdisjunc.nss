//::///////////////////////////////////////////////
//:: Mordenkainen's Disjunction
//:: NW_S0_MordDisj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Massive Dispel Magic and Spell Breach rolled into one
	If the target is a general area of effect they lose
	6 spell protections.  If it is an area of effect everyone
	in the area loses 2 spells protections.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_mordsdisjunc();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MORDENKAINENS_DISJUNCTION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iImpactSEF = VFX_HIT_AOE_ABJURATION;
	if ( GetSpellId() == SPELLABILITY_DISCHORD_DISJUNCT)
	{
		//nCasterLevel = GetLevelByClass(CLASS_TYPE_BARD);
		iClass = CLASS_TYPE_BARD; // force it to use the bard class
	}
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	object oTarget = HkGetSpellTarget();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	effect eImpact;
	
	
	if ( GetSpellId() == SPELLABILITY_DISCHORD_DISJUNCT) // reduce songs by 3
	{
		DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
		DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
		DecrementRemainingFeatUses(oCaster, FEAT_BARD_SONGS);
	}
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (  GetIsObjectValid(oTarget)  )
	{
		DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, SCGetDispellCount(iSpellId, TRUE), iSpellId ) );
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//SendMessageToPC( oCaster, "About to Breach");
			SCSpellBreach(oCaster, oTarget, 6, 10, iSpellId);
			//SendMessageToPC( oCaster, "Finish Breach");
		}
	}
	else
	{
		location lLocal = HkGetSpellTargetLocation();
		float fDelay;
		int nStripCnt = SCGetDispellCount(iSpellId, FALSE);
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		while (GetIsObjectValid(oTarget) && nStripCnt > 0)
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT)
			{
				SCDispelAoE(oTarget, oCaster);
				nStripCnt--;
			}
			else
			{
				fDelay = 0.15 * GetDistanceBetween(oCaster, oTarget);
				DelayCommand( fDelay, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELL_MORDENKAINENS_DISJUNCTION) );
				if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
				{
					SCSpellBreach(oCaster, oTarget, 2, 10, iSpellId);
				}
				nStripCnt--;
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		}
	}
	//SendMessageToPC( oCaster, "Finish Spell");
	HkPostCast(oCaster);
}

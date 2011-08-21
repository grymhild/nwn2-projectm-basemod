//::///////////////////////////////////////////////
//:: Name 	Slashing Dispell
//:: FileName sp_slash_displ.nss
//:://////////////////////////////////////////////
/**@file Slashing Dispell
Abjuration/Evocation
Level: Duskblade 5, sorcerer/wizard 4
Components: V,S
Casting Time: 1 standard action
Range: Medium
Target or Area: One creature or 20ft radius burst
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

This spell functions like dispel magic, except as
noted here. Any creature that has a spell effect
removed from it takes 2 points of damage per level
of the dispelled effect. If a creature loses the
effects of multiple spells, it takes damage for
each one.
**/
//#include "prc_alterations"
//#include "spinc_common"
//#include "x2_inc_spellhook"
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_dispmagic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SLASHING_DISPEL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 10;
	int iImpactSEF = VFX_FNF_DISPEL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (  GetIsObjectValid(oTarget)  )
	{
		DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, SCGetDispellCount(SPELL_SLASHING_DISPEL, TRUE),SPELL_SLASHING_DISPEL ) );
	}
	else
	{
		location lLocal = HkGetSpellTargetLocation();
		int nStripCnt = SCGetDispellCount(iSpellId, FALSE);
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		while (GetIsObjectValid(oTarget) && nStripCnt > 0)
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT)
			{
				SCDispelAoE(oTarget, oCaster);
			}
			else
			{
				DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELL_SLASHING_DISPEL) );
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		}
	}
	HkPostCast(oCaster);	
}


/*

#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SLASHING_DISPEL; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	

	effect 	eVis = EffectVisualEffect(VFX_IMP_BREACH);
	effect 	eImpact = EffectVisualEffect(VFX_FNF_DISPEL);
	object 	oTarget = HkGetSpellTarget();
	location lLocal = HkGetSpellTargetLocation();
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 10 ); 
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	
	//--------------------------------------------------------------------------
	// Dispel Magic is capped at caster level 10, remove already handled
	//--------------------------------------------------------------------------
	if (GetIsObjectValid(oTarget))
	{
		//----------------------------------------------------------------------
		// Targeted Dispel - Dispel all
		//----------------------------------------------------------------------
		spellsDispelMagicMod(oTarget, iSpellPower, eVis, eImpact);

	}
	else
	{
		//----------------------------------------------------------------------
		// Area of Effect - Only dispel best effect
		//----------------------------------------------------------------------

		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
		while (GetIsObjectValid(oTarget))
		{
			if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
			{
				//--------------------------------------------------------------
				// Handle Area of Effects
				spellsDispelAoEMod(oTarget, oCaster,iSpellPower);
			}
			else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId()));
			}
			else
			{
				spellsDispelMagicMod(oTarget, iSpellPower, eVis, eImpact, FALSE);
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
*/


/*
object oTarget = HkGetSpellTarget();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	effect eImpact;
	
		
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
*/



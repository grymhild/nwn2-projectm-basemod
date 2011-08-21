//::///////////////////////////////////////////////
//:: Epic Spell: Superb Dispelling
//:: Author: Boneshank (Don Armstrong)
//#include "inc_dispel"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_SCInclude_Abjuration"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_SUP_DIS;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_SUP_DIS))
	{
		effect 	eVis 		= EffectVisualEffect(VFX_IMP_BREACH);
		effect 	eImpact 	= EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
		int 	nCasterLevel = HkGetCasterLevel(OBJECT_SELF);
		object oTarget = HkGetSpellTarget();
		float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
		location lLocal 		= HkGetSpellTargetLocation();
		// If this option has been enabled, the caster will take the damage
		// as he/she should in accordance with the ELHB.
		if ( CSLGetPreferenceSwitch("EpicBacklashDamage") )
		{
			effect eCast = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
			int nDam = d6(10);
			effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_NEGATIVE);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF);
		}
		
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
					DelayCommand( fDelay, SCDispelTarget(oTarget, oCaster, nStripCnt, iSpellId) );
					if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
					{
						SCSpellBreach(oCaster, oTarget, 2, 10, iSpellId);
					}
					nStripCnt--;
				}
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
			}
		}
		/*
		// Superb Dispelling's bonus is capped at caster level 40
		if(nCasterLevel >40 )
			nCasterLevel = 40;

		// Targeted Dispelling
		if (GetIsObjectValid(oTarget))
			spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);

		// Area of Effect - Only dispel best effect
		else
		{
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
			while (GetIsObjectValid(oTarget))
			{
				if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
				spellsDispelAoEMod(oTarget, OBJECT_SELF, nCasterLevel);
				else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
				else
				spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact, FALSE);
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);
			}
		}
		*/
	}
	HkPostCast(oCaster);
}




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
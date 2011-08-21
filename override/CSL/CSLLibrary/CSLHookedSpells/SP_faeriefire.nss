//::///////////////////////////////////////////////
//:: Faerie Fire
//:: cmi_s0_faeriefire
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 19, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_faeriefire();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Faerie_Fire;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELLABILITY_FAERIEFIRE )
	{
		iClass = CLASS_TYPE_RACIAL;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE|SCMETA_DESCRIPTOR_LIGHT, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iRealSpellId = GetSpellId();

  	object oTarget = HkGetSpellTarget();
	
	int iVisualEffect = VFXSC_DUR_FAERYAURA_BLUE; // set up a default just in case
	
	if ( iRealSpellId == SPELL_FAERIE_FIRE_BLUE || iRealSpellId == SPELLABILITY_FAERIE_FIRE_BLUE)
	{
		iVisualEffect = VFXSC_DUR_FAERYAURA_BLUE;
	}
	else if ( iRealSpellId == SPELL_FAERIE_FIRE_PURPLE || iRealSpellId == SPELLABILITY_FAERIE_FIRE_PURPLE)
	{
		iVisualEffect = VFXSC_DUR_FAERYAURA_PURPLE;
	}
	else if ( iRealSpellId == SPELL_FAERIE_FIRE_GREEN || iRealSpellId == SPELLABILITY_FAERIE_FIRE_GREEN)
	{
		iVisualEffect = VFXSC_DUR_FAERYAURA_GREEN;
	}
	else
	{
		//int nAlign = GetAlignmentGoodEvil(oCaster); // can make it alignment based, just make it random if it's from the AI
		switch (d3())
		{
			case 1:
				iVisualEffect = VFXSC_DUR_FAERYAURA_BLUE;
				break;
			case 2:
				iVisualEffect = VFXSC_DUR_FAERYAURA_GREEN;
				break;
			case 3:
				iVisualEffect = VFXSC_DUR_FAERYAURA_PURPLE;
				break;
		}
	}
	effect eVis = EffectVisualEffect(iVisualEffect);
	
	
	
	effect eConcealNegated = EffectConcealmentNegated();
	effect eLink = EffectLinkEffects(eVis,eConcealNegated);
	
	int iCasterLevel = HkGetSpellDuration(OBJECT_SELF);
	
	if ( iRealSpellId == SPELLABILITY_RACIAL_FAERIE_FIRE || iRealSpellId == SPELLABILITY_FAERIE_FIRE_BLUE || iRealSpellId == SPELLABILITY_FAERIE_FIRE_PURPLE || iRealSpellId == SPELLABILITY_FAERIE_FIRE_GREEN )
	{
		iCasterLevel = GetHitDice(OBJECT_SELF);
	}
		
	float fDuration = TurnsToSeconds( iCasterLevel );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_SMALL);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    object oAreaTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget));
    while(GetIsObjectValid(oAreaTarget))
    {
        if (CSLSpellsIsTarget(oAreaTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
			if(HkResistSpell(OBJECT_SELF, oTarget) == 0)
			{
			    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, iSpellId );	
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE));
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId );	
			}		
		}
	    oAreaTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget));	
	}
		
	HkPostCast(oCaster);	
}


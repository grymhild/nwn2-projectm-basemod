//::///////////////////////////////////////////////
//:: Inntervated Speed
//:: cmi_s2_inrvtspd
//:: Purpose: 
//:: Altered By: Kaedrin (Matt)
//:: Created On: March 23, 2008
//:: Based on script: nw_s0_slow
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"

//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_sbinnervspee();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_TRANSMUTATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE;
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

    //Declare major variables
    object oTarget;
    effect eSlow = EffectSlow();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
	eSlow = EffectLinkEffects( eSlow, eVis );
	
	//Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int iDuration = 10;
    int iLevel = iDuration;
    int nCount = 0;
    location lSpell = HkGetSpellTargetLocation();
    //int nDC = GetSpellSaveDC();
	int nCha = GetAbilityModifier(ABILITY_CHARISMA);
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE);
	int nWis = GetAbilityModifier(ABILITY_WISDOM);
	int nDCMod;
	if (nCha > nInt)
	{
		nDCMod = nCha;
	}
	else
	{
		if (nInt > nWis)
		{
			nDCMod = nInt;
		}
		else
		{
			nDCMod = nWis;
		}
	}	
	
	int nDC = 10 + 9 + nDCMod; // HkGetSpellSaveDC()
	
	float fDuration = HkApplyMetamagicDurationMods(  HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_INNERVATE_SPEED, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oTarget) && nCount < iLevel)
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLOW));
            if (!HkResistSpell(OBJECT_SELF, oTarget) && !/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC))
            {
                //Apply the slow effect and VFX impact
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, fDuration );
                //HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                //Count the number of creatures affected
                nCount++;
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_INNERVATE_SPEED, lSpell);
    }
    
    HkPostCast(oCaster);
}


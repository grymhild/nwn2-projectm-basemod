//::///////////////////////////////////////////////
//:: Adrenaline Boost
//:: cmi_s2_adrenboost
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_nsadrenaline();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	

    	
	
	int iCasterLevel = GetLevelByClass(CLASS_NIGHTSONG_INFILTRATOR,OBJECT_SELF);
	float fDuration = TurnsToSeconds( iCasterLevel );
	
	effect eBonus;
	effect eVis;
	effect eLink;			

	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
		
		    float fDelay = CSLRandomBetweenFloat(0.4, 1.1);
			
			if (GetCurrentHitPoints(oTarget) > (GetMaxHitPoints(oTarget)/2))
			{
				eBonus = EffectTemporaryHitpoints(iCasterLevel);
				eVis = EffectVisualEffect(VFX_DUR_SPELL_HEROISM);
				eLink = EffectLinkEffects(eVis, eBonus);				
			}
			else
			{
				eBonus = EffectTemporaryHitpoints(iCasterLevel*2);
				eVis = EffectVisualEffect(VFX_DUR_SPELL_HEROISM);
				eLink = EffectLinkEffects(eVis, eBonus);				
			}
			
		    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() );
			
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
            DelayCommand(fDelay, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() ));
				
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }	
	HkPostCast(oCaster);
}
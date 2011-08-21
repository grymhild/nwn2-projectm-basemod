//::///////////////////////////////////////////////
//:: Scourge
//:: cmi_s0_scourge
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 25, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_FT_scourge();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iImpactSEF = VFX_HIT_AOE_NECROMANCY;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

  
	int nStrMod = HkApplyMetamagicVariableMods(d6(),6);
	int nDexMod = HkApplyMetamagicVariableMods(d6(),6);
	
	effect eCurse = EffectCurse(nStrMod,nDexMod,0,0,0,0);	
		
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BESTOW_CURSE);
	effect eLink = EffectLinkEffects(eVis, eCurse);
	eLink = SupernaturalEffect(eLink);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
		
			if (!GetIsImmune(oTarget,IMMUNITY_TYPE_DISEASE))
			{
		
				if (!HkResistSpell(OBJECT_SELF, oTarget))
				{
					if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
					{
					    float fDelay = CSLRandomBetweenFloat(0.4, 1.1);
									
			            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			            DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
					}
				}
			}					
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, GetLocation(OBJECT_SELF));
    }	
	HkPostCast(oCaster);
}


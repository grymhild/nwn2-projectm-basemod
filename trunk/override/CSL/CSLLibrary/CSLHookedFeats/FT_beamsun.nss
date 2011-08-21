//::///////////////////////////////////////////////
//:: Beam of Sunlight (Master of Radiance)
//:: cmi_s2_searlght
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:://////////////////////////////////////////////
//:: Based on Sunbeam by OEI

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"

void main()
{	
	//scSpellMetaData = SCMeta_FT_beamsun();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iImpactSEF = VFX_HIT_AOE_HOLY;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


// End of Spell Cast Hook

	if (!GetHasSpellEffect(SPELLABILITY_MASTER_RADIANCE_RADIANT_AURA))
	{
        SpeakString("This ability can only be used while Radiant Aura is active.");
	}
	else
	{
	
	    //Declare major variables
	    effect eVis2 = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	    effect eDam;
	    effect eBlind = EffectBlindness();
	    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	    effect eLink = EffectLinkEffects(eBlind, eDur);
	
	    int iCasterLevel= HkGetSpellPower(OBJECT_SELF, 18) +2;
	    int iDamage;
	    int nOrgDam;
	    int nMax;
	    float fDelay;
	    int nBlindLength = 3;
	    	
		int iImpactSEF = VFX_NONE;
		//--------------------------------------------------------------------------
		//Apply effects
		//--------------------------------------------------------------------------
		location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
		effect eImpactVis = EffectVisualEffect( iImpactSEF );
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	    //Get the first target in the spell area
	    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, HkGetSpellTargetLocation());
	    while(GetIsObjectValid(oTarget))
	    {
	        // Make a faction check
	        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	        {
	            fDelay = CSLRandomBetweenFloat(1.0, 2.0);
	            //Fire cast spell at event for the specified target
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBEAM));
	            //Make an SR check
	            if ( !HkResistSpell(OBJECT_SELF, oTarget, 1.0))
	            {
	                //Check if the target is an undead
	                if ( CSLGetIsUndead( oTarget ) )
	                {
	                    iDamage = HkApplyMetamagicVariableMods(d6(iCasterLevel), 6 * iCasterLevel);
	                }
	                else
	                {
	                    int iDamage = HkApplyMetamagicVariableMods(d6(4), 6 * 4);
	                }
					
	                nOrgDam = iDamage;
	                iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DIVINE);
	
	                //Set damage effect
	                eDam = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
	                if(iDamage > 0)
	                {
	                    if (iDamage == nOrgDam || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget) ) // Reverse Engineer if the save was made based on the damage, if they have any damage and evasion it means they did not save
	                    {
	                        DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nBlindLength)));
						}
	                    //Apply the damage effect and VFX impact
	                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
	                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	                }
	            }
	        }
	        //Get the next target in the spell area
	        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, HkGetSpellTargetLocation());
	    }
	}
	
	HkPostCast(oCaster);
}


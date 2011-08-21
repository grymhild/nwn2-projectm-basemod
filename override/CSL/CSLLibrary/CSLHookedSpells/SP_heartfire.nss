//::///////////////////////////////////////////////
//:: Heartfire
//:: cmi_s0_heartfire
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 19, 2007
//:: NOTE: This needs to be revised with a custom DoT
//:: 	that accounts for half damage Fortitude Saves
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_heartfire();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Heartfire;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


  	object oTarget = HkGetSpellTarget();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_SMALL);
	
	effect eVis = EffectVisualEffect(VFXSC_DUR_FAERYAURA_RED);
	effect eConcealNegated = EffectConcealmentNegated();
	effect eDoT = EffectDamageOverTime(d4(1),5.5f);
	effect eDoT_half = EffectDamageOverTime(d2(1),5.5f);	
	effect eLink = EffectLinkEffects(eVis,eConcealNegated);
	
	
	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
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
			
                if(!HkSavingThrow(SAVING_THROW_FORT, oAreaTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FIRE)) //, OBJECT_SELF, 3.0))
				{
					eLink = EffectLinkEffects(eLink,eDoT);
				}
				else
					eLink = EffectLinkEffects(eLink,eDoT_half);
								
			    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() );	
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, GetSpellId() );	
			}		
		}
	    oAreaTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oTarget));	
	}	
	HkPostCast(oCaster);	
}
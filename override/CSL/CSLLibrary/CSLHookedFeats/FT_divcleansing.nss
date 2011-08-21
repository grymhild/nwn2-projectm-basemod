//::///////////////////////////////////////////////
//:: Divine Cleansing
//:: cmi_s2_divcleanse
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 13, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_divcleansing();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_Divine_Cleansing;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE ;
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
   if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
   {
        SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
   }
   else
   {
        effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2);
        effect eLink = EffectLinkEffects(eSave, eDur);
		float fDelay;
		
        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
        if (nCharismaBonus>0)
        {

			eLink = SetEffectSpellId(eLink, iSpellId);
            eLink = SupernaturalEffect(eLink);
		
		    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, GetLocation(OBJECT_SELF));
		    while(GetIsObjectValid(oTarget))
		    {
		        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		        {
					fDelay = CSLRandomBetweenFloat(0.4, 1.0);
		            CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  OBJECT_SELF, iSpellId );
		            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));			
		            DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nCharismaBonus)));
		            DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));			
		        }
		        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, GetLocation(OBJECT_SELF));
		    }
		
		}	
		

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    }
    
    HkPostCast(oCaster);
}
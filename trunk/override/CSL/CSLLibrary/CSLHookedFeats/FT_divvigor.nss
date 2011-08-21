//::///////////////////////////////////////////////
//:: Divine Vigor
//:: cmi_s2_divvigor
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 12, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_divvigor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_Divine_Vigor;
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
        SpeakStringByStrRef( SCSTR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS );
   }
   else
   {
        effect eVis = EffectVisualEffect( VFX_HIT_SPELL_EVOCATION );
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA);
        if (nCharismaBonus>0)
        {
        
			effect eMove = EffectMovementSpeedIncrease(133);
			effect eHP = EffectTemporaryHitpoints(GetHitDice(OBJECT_SELF)*2);
            effect eLink = EffectLinkEffects(eMove, eDur);
			eLink = EffectLinkEffects(eHP,eLink);
			eLink = SetEffectSpellId(eLink, iSpellId);
            eLink = SupernaturalEffect(eLink);

            CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF,iSpellId);
			
            SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nCharismaBonus));
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
        }

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    }
    
    HkPostCast(oCaster);
}
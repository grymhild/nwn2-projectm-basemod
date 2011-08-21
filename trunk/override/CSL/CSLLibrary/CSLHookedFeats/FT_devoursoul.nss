// this script was goofed, and had devourspirit instead
// nx_s2_devour_soul
/*
    Spirit Eater Devour Soul Feat
    
Devour Soul
This feat allows the Devour Spirit ability to work on humanoids as well as spirits. This is just a modifier, and 
is not an ability unto itself, so it should not be quickslottable. 
In other words, the impact script of Devour Spirit will check to see if its caster has this feat and if it does 
it will allow humanoids as valid targets.

*/
// ChazM 2/23/07
// ChazM 4/12/07 VFX/string update
// MDiekmann 7/3/07 - modified to meet new description
// MDiekmann 7/5/07 - various fixes for new implementation
// MDiekmann 7/13/07 - addition of Ravenous Incarnation to cooldown

#include "_HkSpell"
#include "_SCInclude_SpiritEater"

//#include "x0_I0_SPELLS"
//#include "x2_inc_spellhook"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
    object oTarget  = HkGetSpellTarget();
   	
	//if we have already attempted to devour said soul, give back use, inform user
	if (GetLocalInt(oTarget, VAR_SE_HAS_BEEN_DEVOURED))
    {   
		ResetFeatUses(oCaster, FEAT_DEVOUR_SOUL, FALSE, TRUE);
		PostFeedbackStrRef(oCaster, STR_REF_MULTIPLE_DEVOUR);
        return;
    }
	
    if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && ( GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) && GetIsSoul(oTarget) )
    {
		// sets up cooldown timer for devour abilities
		ResetFeatUses(oCaster, FEAT_DEVOUR_SOUL, FALSE, TRUE);
		DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SOUL);
		DecrementRemainingFeatUses(oCaster, FEAT_SPIRIT_GORGE);
		DecrementRemainingFeatUses(oCaster, FEAT_ETERNAL_REST);
		DecrementRemainingFeatUses(oCaster, FEAT_RAVENOUS_INCARNATION);
		DecrementRemainingFeatUses(oCaster, FEAT_DEVOUR_SPIRIT_1);
		
		// Visual effect on caster
	    effect eCasterVis = EffectVisualEffect(VFX_CAST_SPELL_DEVOUR_SPIRIT);
	    ApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster);
		
        // no alignment shift
        DoDevour(oTarget);
		
	    //Fire cast spell at event for the specified target
	    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
		
		// Set flag showing a devour ability has been used
		SetGlobalInt(VAR_SE_HAS_USED_DEVOUR_ABILITY, TRUE);
		
		// Set local flag showing that a devour has been attempted
		SetLocalInt(oTarget, VAR_SE_HAS_BEEN_DEVOURED, TRUE);
		
			// Clear out uses of suppress since it can no longer be used this day
		if(GetHasFeat(FEAT_SUPPRESS))
		{
			int nCount;
			for(nCount = 0; nCount < 10; nCount++)
			{
				DecrementRemainingFeatUses(oCaster, FEAT_SUPPRESS);
			}
			ResetFeatUses(oCaster, FEAT_SUPPRESS, FALSE, TRUE);
		}
    }
    else
    {   // used on invalid target, so abort and give back.
        PostFeedbackStrRef(oCaster, STR_REF_INVALID_TARGET);
		// It won't have been auto decremented, so no need to increment
        // IncrementRemainingFeatUses(OBJECT_SELF, FEAT_DEVOUR_SOUL);
		ResetFeatUses(oCaster, FEAT_DEVOUR_SOUL, FALSE, TRUE);
        return;
    }
}
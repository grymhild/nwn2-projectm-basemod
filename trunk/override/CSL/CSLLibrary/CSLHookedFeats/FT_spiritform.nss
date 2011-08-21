//::///////////////////////////////////////////////
//:: Spirit Form
//:: nx_s2_spiritform.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    A spirit shaman learns how to temporarily
    transform herself into a spirit.  As a standard
    action, she can grant herself a 50% concealment
    bonus for 5 rounds.  This ability is usable 1
    time per day at 9th level, 2 times per day at
    15th level, and 1 additional time per day every
    5 levels thereafter.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/15/2007
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_spiritform();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
    object oTarget = OBJECT_SELF; //HkGetSpellTarget();

    // Does not stack with itself
    if (!GetHasSpellEffect(GetSpellId(), oTarget) )
    {
        effect eConceal = EffectConcealment(50);
        effect eVis     = EffectVisualEffect(VFX_DUR_SPELL_SPIRIT_FORM);
        effect eLink    = EffectLinkEffects(eConceal, eVis);
    	effect eSR = EffectSpellResistanceIncrease(11 + GetHitDice(oCaster));
		eLink = EffectLinkEffects(eLink, eSR);
		int nCha = GetAbilityModifier(ABILITY_CHARISMA);
		if (nCha >= 1)
		{
			effect eDefl = EffectACIncrease(nCha, AC_DEFLECTION_BONUS);
			eLink = EffectLinkEffects(eLink, eDefl);
    	}


        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    
        //Apply the VFX impact and effects
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
    }
    
    HkPostCast(oCaster);
}


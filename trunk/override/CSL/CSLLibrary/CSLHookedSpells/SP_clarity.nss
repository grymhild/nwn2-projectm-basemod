//::///////////////////////////////////////////////
//:: Clarity
//:: SOZ UPDATE BTM
//:: NW_S0_Clarity.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell removes Charm, Daze, Confusion, Stunned
    and Sleep.  It also protects the user from these
    effects for 1 round / level.  Does 1 point of
    damage for each effect removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_CLARITY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	
	object oTarget = HkGetSpellTarget();
	
	int iDuration = HkGetSpellDuration( oCaster );
    float fDuration = RoundsToSeconds( iDuration );
    fDuration = HkApplyMetamagicDurationMods(fDuration);
    int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    
    //Declare major variables
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    
    effect eWillSaves = EffectSavingThrowIncrease(SAVING_THROW_WILL, 8);
    effect eDam = HkEffectDamage(1, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);

    effect eLink = EffectLinkEffects(eWillSaves, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    
    effect eSearch = GetFirstEffect(oTarget);
    

    int bValid;
    int bVisual;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
	
	// string sSpellList = "|"; // LIST OF SPELLS CHECKED
	
    //Search through effects
    while(GetIsEffectValid(eSearch))
    {
        bValid = FALSE;
        //Check to see if the effect matches a particular type defined below
        if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)        { bValid = TRUE; }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)  { bValid = TRUE; }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)    { bValid = TRUE; }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED) { bValid = TRUE; }
        else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)  { bValid = TRUE; }
        //Apply damage and remove effect if the effect is a match
        if (bValid == TRUE)
        {
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
            RemoveEffect(oTarget, eSearch);
            bVisual = TRUE;
        }
        eSearch = GetNextEffect(oTarget);
    }
    float fTime = 30.0  + fDuration;
    //After effects are removed we apply the immunity to mind spells to the target
    
    
    //boost the saving throws for a little bit
    HkApplyEffectToObject(iDurType, eLink, oTarget, fTime);
    
    HkPostCast(oCaster);
}
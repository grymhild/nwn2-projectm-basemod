//::///////////////////////////////////////////////
//:: Nybor's Reminders
//:: sg_s0_nybor.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Nybor's Gentle Reminder
     Nybor's Mild Admonishment
     Nybor's Stern Reproof
     Nybor's Wrathful Castigation
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 5, 2004
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    //int     iDieType        = 0;
    //int     iNumDice        = 0;
    int     iBonus          = 0;
    //int     iDamage         = 0;
    int     iPenalty;
    float   fDazeDuration;
	float fDuration;
	
    switch(iSpellId) {
        case SPELL_NYBORS_GENTLE_REMINDER:
            iPenalty = 1;
            iBonus = 1;
            fDuration = HkApplyDurationCategory(2);
            fDazeDuration = HkApplyDurationCategory(1);
            break;
        case SPELL_NYBORS_MILD_ADMONISHMENT:
        case SPELL_NYBORS_STERN_REPROOF:
            iPenalty = 2;
            iBonus = 2;
            fDuration = HkApplyDurationCategory(iCasterLevel);
            fDazeDuration = HkApplyDurationCategory(d4());
            break;
        case SPELL_NYBORS_WRATHFUL_CASTIGATION:
            iPenalty = 4;
            iBonus = 0;
            fDuration = HkApplyDurationCategory(iCasterLevel);
            fDazeDuration = fDuration;
            break;
    }
	fDuration = HkApplyMetamagicDurationMods( fDuration );
	fDazeDuration = HkApplyMetamagicDurationMods( fDazeDuration );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);

    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
    effect eDaze = EffectDazed();
    effect eDeath = EffectLinkEffects(EffectDeath(), EffectVisualEffect(VFX_IMP_DEATH));
    effect eAttackPenalty = EffectAttackDecrease(iPenalty);
    effect eSavePenalty = EffectSavingThrowDecrease(SAVING_THROW_ALL,iPenalty);
    effect eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH, iBonus);
    effect eCheckPenalty = EffectSkillDecrease(SKILL_ALL_SKILLS, iPenalty);
    effect eLink=EffectLinkEffects(eAttackPenalty, eDur);
    eLink=EffectLinkEffects(eSavePenalty, eLink);
    eLink=EffectLinkEffects(eCheckPenalty, eLink);
    eLink=EffectLinkEffects(eStrBonus, eLink);

   	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
    if(!HkResistSpell(oCaster, oTarget) && CSLGetIsLiving(oTarget))
    {
        switch(iSpellId)
        {
            case SPELL_NYBORS_GENTLE_REMINDER:
            case SPELL_NYBORS_MILD_ADMONISHMENT:
                if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDazeDuration);
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                }
                break;
            case SPELL_NYBORS_STERN_REPROOF:
                if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_DEATH)) {
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                    DelayCommand(0.5f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                } else {
                    if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
                        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDazeDuration);
                        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                    }
                }
                break;
            case SPELL_NYBORS_WRATHFUL_CASTIGATION:
                if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_DEATH)) {
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                    DelayCommand(0.5f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                } else {
                    if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS)) {
                        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                        eLink = EffectLinkEffects(eDaze, eSavePenalty);
                        eLink = EffectLinkEffects(eDur, eLink);
                        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                    }
                }
                break;
        }
    }

    HkPostCast(oCaster);
}



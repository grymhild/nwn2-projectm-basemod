//::///////////////////////////////////////////////
//:: Curse of Ill Fortune
//:: sg_s0_curseill.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Transmutation
     Level: Clr 2 (Beshaba)
     Components: V, S
     Casting Time: 1 action
     Range: Medium (100 ft + 10 ft/level)
     Target: One living creature
     Duration: 1 minute/level
     Saving Throw: Will negates
     Spell Resistance: Yes

    You place a temporary curse upon the target,
    giving her a -3 enhancement penalty on attack
    rolls, saving throws, abilities, and skill
    checks.  Curse of Ill Fortune is removed by
    any spell that removes a bestow curse spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 3, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     SGSetSpellInfo( );
// 
//
//
//
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);  // Visible impact effect

    effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eAtt = EffectAttackDecrease(3);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 3);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 3);
    effect eCurse = EffectCurse(3,3,3,3,3,3);
    effect eLink = EffectLinkEffects(eVis, eAtt);
    eLink = EffectLinkEffects(eSave, eLink);
    eLink = EffectLinkEffects(eSkill, eLink);
    eLink = EffectLinkEffects(eCurse, eLink);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CURSE_OF_ILL_FORTUNE));
    if(!HkResistSpell(oCaster, oTarget)) {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && CSLGetIsLiving(oTarget)) {
            if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC)) {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            }
        }
    }

    HkPostCast(oCaster);
}



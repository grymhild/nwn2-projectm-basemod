//::///////////////////////////////////////////////
//:: Loviatar's Torments
//:: sg_s0_lovtorm.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Originally used only by priests of Loviatar,
     this spell has been seen being used by priests
     of other evil gods.

     School: Evocation [Evil]
     Level: Clr 3, Evil 3
     Target: One creature
     Duration: 1 rnd/lvl
     Save:  Fortitude negates
     SR:  Yes

     Causes d6 dmg per round (max 10 rounds without
     metamagic).  Also applies a -2 morale penalty
     to attacks, saves, and skill checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 25, 2003
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 10 );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = 1;
    int     iBonus          = 0;
    int     iDamage         = 0;
	
	
	iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice );
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eDamage  = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_TWENTY);
    effect eVis     = EffectVisualEffect(VFX_FNF_LOS_EVIL_20);
    effect eImp     = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
    effect eLink    = EffectLinkEffects(eDamage,eImp);
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_LOV_TORM, "", "", "", sAOETag);
    effect eAttDec  = EffectAttackDecrease(2);
    effect eSaveDec = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect eSkillDec= EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eTmpLink = EffectLinkEffects(eAttDec, eSaveDec);
    eTmpLink = EffectLinkEffects(eTmpLink, eSkillDec);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if(GetAlignmentGoodEvil(oCaster)==ALIGNMENT_EVIL)
    {
        oTarget = oCaster;
    }
        
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
    SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_LOV_TORMENTS));
    if(!HkResistSpell(oCaster, oTarget) || oTarget==oCaster) {
        if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC) || oTarget==oCaster) {
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTmpLink, oTarget, fDuration);
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink,oTarget);
        }
    }

    HkPostCast(oCaster);
}



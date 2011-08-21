//::///////////////////////////////////////////////
//:: Condemned
//:: sg_s0_condemn.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     This spell makes the target immune to magical
     healing until a remove curse is cast upon the
     target.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 28, 2003
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
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	
	
	
	


    int     iCasterAlignment = GetAlignmentGoodEvil(oCaster);
    int     iTargetAlignment = GetAlignmentGoodEvil(oTarget);
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eCurse       = EffectCurse(0,0,0,0,0,1);
    effect eCastVis     = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
    effect eImp1        = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eImp2        = EffectVisualEffect(VFX_IMP_DOOM);
    effect eImpLink     = EffectLinkEffects(eImp1,eImp2);
    effect eVisDur      = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eCurseLink   = EffectLinkEffects(eVisDur,eCurse);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_CONDEMNED));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT,eCastVis,oCaster);
    if( CSLGetIsLiving(oTarget) && CSLTouchAttackMelee(oTarget,TRUE) )
    {
        if(!HkResistSpell(oCaster,oTarget))
        {
            if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
            {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT,eImpLink,oTarget);
                DelayCommand(1.0f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT,eCurseLink,oTarget));
            }
        }
    }

    if((iCasterAlignment==ALIGNMENT_GOOD) && ((iTargetAlignment==ALIGNMENT_NEUTRAL) || (iTargetAlignment==ALIGNMENT_GOOD)))
    {
       AdjustAlignment(oCaster,ALIGNMENT_EVIL,5);
    }
    HkPostCast(oCaster);
}



//::///////////////////////////////////////////////
//:: Purifying Flames
//:: SG_S0_PurifyFl.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     The target of this spell bursts into flames.
     Each round it takes 3d6 dmg, fort save for half
     each round.  Creatures within 5 ft take 1d6 dmg,
     no save.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 17, 2003
//:://////////////////////////////////////////////
// #include "sg_inc_elements"
//
//
//
// 
// void main()
// {
//     location lTarget        = GetLocation(oTarget);
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
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
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
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS ) );
	location lTarget;
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_FIRE, SC_SHAPE_BEAM ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = 3;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iProxDmg;
    int     iProxVisualType = VFX_COM_HIT_FIRE; //SGGetElementalVisualType(VFX_COM_HIT_FIRE, iDamageType);
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------


    iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice );
    iProxDmg = HkApplyMetamagicVariableMods( d6(1), 6);

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eBeam    = EffectBeam(iShapeEffect, oCaster, BODY_NODE_HAND);
    effect eImp     = EffectVisualEffect(iHitEffect);
    effect eProxImp = EffectVisualEffect(iProxVisualType);
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_PURIFY_FLAMES, "", "", "", sAOETag);
    effect eDam;
    effect eLink;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_PURIFY_FLAMES));
    if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && !GetHasSpellEffect(SPELL_PURIFY_FLAMES, oTarget))
    {
        int iTouch = CSLTouchAttackRanged(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5f);
            if(!HkResistSpell(oCaster, oTarget))
            {
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
                
                //if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType))
                //{
                //    iDamage /= 2;
                //}
                iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, iSaveType, oCaster );
				
                eDam=EffectDamage(iDamage,iDamageType);
                eLink=EffectLinkEffects(eImp,eDam);
                DelayCommand(1.5f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));

                lTarget=GetLocation(oTarget);
                oTarget=GetFirstObjectInShape(SHAPE_SPHERE,FeetToMeters(5.0),lTarget, TRUE);
                while(GetIsObjectValid(oTarget)) {
                    eDam=HkEffectDamage(iProxDmg,iDamageType);
                    eLink=EffectLinkEffects(eDam,eProxImp);
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                    oTarget=GetNextObjectInShape(SHAPE_SPHERE,FeetToMeters(5.0),lTarget, TRUE);
                }
            }
        }
        else
        {
            eBeam = EffectBeam(iShapeEffect, oCaster, BODY_NODE_HAND, TRUE);
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5f);
        }
    }

    HkPostCast(oCaster);
}


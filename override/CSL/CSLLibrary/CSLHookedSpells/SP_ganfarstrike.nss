//::///////////////////////////////////////////////
//:: Ganest's Farstrike
//:: SG_S0_GanFar.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     The caster releases a parabolic arc bolt of fire
     at the target. Range is as far as the caster can
     see.  The bolt does 1d4 dmg/lvl (max 10d4).
     A Reflex save negates the damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 10, 2003
//:://////////////////////////////////////////////
// #include "sg_inc_elements"

#include "_HkSpell"

void main()
{
	// Need to ( if(iSpellId==SPELL_MSE_GANSTRIKE) then make the damage magical )
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_ELEMENTAL;
		
	if(iSpellId!=SPELL_MSE_GANSTRIKE)
	{
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW | SPELL_SUBSCHOOL_ELEMENTAL;
	}

	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
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
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_FIRE, SC_SHAPE_BEAM ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 4;
    int     iNumDice        = iCasterLevel;
    int     iBonus          = 0;
    int     iDamage         = 0;
    
    float   fDelay;
    
    if(iNumDice>10) iNumDice=10;

    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
    iDamage = HkApplyMetamagicVariableMods( d4(iNumDice), 4 * iNumDice );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectBeam(iShapeEffect, oCaster, BODY_NODE_HAND);
    effect eImp     = EffectVisualEffect(iHitEffect);
    effect eDamage  = EffectDamage(iDamage, iDamageType);
    effect eLink;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_GANEST_FARSTRIKE));
    if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, iSaveType)) {
        eVis = EffectBeam(VFX_BEAM_FIRE, oCaster, BODY_NODE_HAND, TRUE);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.5f);
    }
    else
    {
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.5f);
        if(!HkResistSpell(oCaster, oTarget)) {
            if(iSpellId==SPELL_MSE_GANSTRIKE && HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
            {
                iDamage = FloatToInt(iDamage*0.20); // will disbelief - spell 20% as strong as real thing
                if(iDamage<1) iDamage=1;
                eDamage = HkEffectDamage(iDamage, iDamageType);
            }
            eLink = EffectLinkEffects(eImp, eDamage);
            fDelay= GetDistanceBetween(oCaster,oTarget)/20.0;
            DelayCommand(fDelay,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
        }
    }

    HkPostCast(oCaster);
}



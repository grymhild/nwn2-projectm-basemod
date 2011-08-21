//::///////////////////////////////////////////////
//:: Acid Spittle
//:: sg_s0_acidspit.nss
//:: 2005 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On:
//:://////////////////////////////////////////////

//#include "sg_i0_spconst"
// 
// #include "sg_inc_elements"
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
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
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_MIRV_ACID, SC_SHAPE_MIRV );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = 1;
    int     iBonusDmg       = iCasterLevel;
    int     iDamage         = 0;

    location lSpCenter      = GetLocation(oTarget);
    float   fDelay;
    object  oOrigTarget     = oTarget;
    
    if (iBonusDmg>20)
        iBonusDmg=20;

    int iSplashDmg=1+iBonusDmg/2;

	if (iSplashDmg>10)
	{
		iSplashDmg=10;
	}
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------

	iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice )+iBonusDmg;
	
    iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect( iShapeEffect );
    effect eImp     = EffectVisualEffect( iHitEffect );
    effect eDamage  = HkEffectDamage(iDamage, iDamageType );
    effect eMain    = EffectLinkEffects( eDamage, eImp );
    effect eSpDmg;
    effect eSplash;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    fDelay = CSLRandomBetweenFloat(0.4, 1.1);
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ACID_SPITTLE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
    int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
        if(!HkResistSpell(oCaster, oTarget))
        {
            iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCH_RANGED, oCaster );
		
            if(iDamage>0)
            {
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMain, oTarget));
            }
        }

        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lSpCenter, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while (GetIsObjectValid(oTarget))
        {
            if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oOrigTarget)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ACID_SPITTLE));
                fDelay = GetDistanceBetweenLocations(lSpCenter, GetLocation(oTarget))/5;
                if (!HkResistSpell(oCaster, oTarget, fDelay))
                {
                    iDC = HkGetSpellSaveDC(oCaster, oTarget);
                    iSplashDmg = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iSplashDmg, oTarget, iDC, iSaveType);
                    eSpDmg = HkEffectDamage(iSplashDmg, iDamageType);
                    eSplash = EffectLinkEffects(eSpDmg,eImp);
                    if(iSplashDmg > 0)
                    {
                        DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eSplash,oTarget));
                    }
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(5.0), lSpCenter, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    HkPostCast(oCaster);
}



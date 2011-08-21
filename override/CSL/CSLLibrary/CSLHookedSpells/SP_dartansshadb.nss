//::///////////////////////////////////////////////
//:: Dartan's Shadow Bolt
//:: SG_S0_DartBolt.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     The caster creates a black pulsating bolt of
     shadowstuff which is aimed at the target.  If
     the caster succeeds at a ranged touch attack,
     the target sustains 1d6 dmg/lvl (max 12d6).  A
     successful fortitude save will halve the damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
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
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
    int     iDieType        = 6;
    int     iNumDice        = iCasterLevel;
    int     iBonus          = 0;
    int     iDamage         = 0;

    if(iNumDice>12) iNumDice=12;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
    iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eRay = EffectBeam(VFX_BEAM_ODD, OBJECT_SELF, BODY_NODE_HAND);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DARTAN_SBOLT));
    int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
        if(!HkResistSpell(oCaster, oTarget))
        {
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.5f);
            //if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
            //{
            //    eDam=HkEffectDamage(iDamage/2,DAMAGE_TYPE_MAGICAL);
            //}
            iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster, SAVING_THROW_RESULT_ROLL );
            iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
		
            DelayCommand(1.6f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            if ( iDamage > 0 )
            {
            	DelayCommand(1.7f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage,DAMAGE_TYPE_MAGICAL), oTarget));
            }
        }
    }
    else
    {
        eRay = EffectBeam(VFX_BEAM_ODD, oCaster, BODY_NODE_HAND, TRUE);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.5f);
    }

    HkPostCast(oCaster);
}



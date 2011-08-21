//::///////////////////////////////////////////////
//:: Darkbolt
//:: SG_S0_Darkbolt.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     You unleash a beam of darkness from your open
     palm.  You must succed at a ranged touch attack
     to strike your target.  A darkbolt deals 2d8 dmg
     per two caster levels, to a maximum of 14d8.
     Creatures struck are also dazed for 2 rounds unless
     they make a Will save.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 5, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DARKNESS, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(2) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	
    int     iDieType        = 8;
    int     iNumDice        = iCasterLevel/2;
    int     iBonus          = 0;
    int     iDamage         = 0;
    
    
    if(iNumDice>14) iNumDice=14;
    
	
    iDamage = HkApplyMetamagicVariableMods( d8(iNumDice), 8 * iNumDice );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eBeam    = EffectBeam(VFX_BEAM_BLACK, oCaster, BODY_NODE_HAND);
    effect eDamage  = EffectDamage(iDamage);
    effect eDaze    = EffectDazed();

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DARKBOLT));
    int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
        if(!HkResistSpell(oCaster, oTarget))
        {
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5f);
            if(!CSLGetIsUndead(oTarget))
            {
                DelayCommand(1.5f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
            }
            if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
            {
                if(CSLGetIsUndead(oTarget))
                {
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDaze), oTarget, fDuration);
                }
                else
                {
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDuration);
                }
            }
        }
    }
    else
    {
        eBeam = EffectBeam(VFX_BEAM_EVIL, oCaster, BODY_NODE_HAND, TRUE);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5f);
    }

    HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: Blessed Warmth
//:: sg_s0_blsdwarm.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Alteration
Level: Clr 4
Components: V,S
Casting Time: 1 action
Range: Personal
Area of Effect: Special
Duration: 1 round/level
Saving Throw: No (harmless)
Spell Resistance: Yes (harmless)

This spell causes a narrow shaft of light to shine down
upon the cleric, granting a 25% immunity to cold damage
and a +3 bonus to saving throws vs cold effects, such as
white dragon breath.
For each level the cleric is above 6th, an additional beam
of light will be created to protect any ally standing within
3 feet of the cleric.  Clerics with the Sun domain receive
an additional 10% immunity and +1 to saves vs cold.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: November 10, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
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
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
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
    //int     iDieType        = 0;
    //int     iNumDice        = 0;
    int     iBonus          = 3;
    //int     iDamage         = 0;

    float   fRadius         = FeetToMeters(3.0);
    int     iPercent        = 25;
    int     iNumAffected    = iCasterLevel-6;

    if(CSLGetHasDomain(DOMAIN_SUN, oCaster))
    {
        iBonus=4;
        iPercent=35;
    }
	

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_IMP_HEALING_X);
    effect eDurVis  = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eImmune  = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, iPercent);
    effect eSaveInc = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus, SAVING_THROW_TYPE_COLD);

    effect eLink    = EffectLinkEffects(eDurVis, eImmune);
    eLink = EffectLinkEffects(eLink, eSaveInc);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLESSED_WARMTH, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

    if(iNumAffected>0) {
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
        while(GetIsObjectValid(oTarget) && iNumAffected>0) {
            if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_ALLALLIES, oCaster)) {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLESSED_WARMTH, FALSE));
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                iNumAffected--;
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
        }
    }

    HkPostCast(oCaster);
}



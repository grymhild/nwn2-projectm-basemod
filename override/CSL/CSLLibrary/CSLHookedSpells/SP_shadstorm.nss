//::///////////////////////////////////////////////
//:: Shadow Storm
//:: SG_S0_ShadStorm.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Necromancy
Level: Sor/Wiz 8
Casting Time: 1 action
Range: Long (400 ft + 40 ft/level)
Area: 2 ft radius/level spread
Duration: Instantaneous
Saving Throw: Reflex Half and Fortitude Half
Spell Resistance: Yes

This violent pairing of the energy of the Plane of
Shadow and the Negative Material Plane creates a brief
but intense storm.

Those within the area of the spread of this spell
roll a Fortitude saving throw.  Those who fail this
check suffer the catastophic loss of the caster's level/2
(maximum loss of 12) in both temporary Strength and
temporary Constitution points.  A successful save indicates
that they lose only half that number of temporary points.
Additionally, everyone in the spread must roll a Reflex
save or suffer 4d12 + 1/level hp (maximum +25) damage. A
successful save halves the damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 18, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     SGSetSpellInfo( );
// 
//
//     object  oTarget;         //= HkGetSpellTarget();
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration/2) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 12;
    int     iNumDice        = 4;
    int     iBonus          = iCasterLevel;
    int     iDamage         = 0;
    int     iAbilityDmg     = iCasterLevel/2;

    if(iAbilityDmg>12) iAbilityDmg=12;
    if(iBonus>25) iBonus=25;
    
    //float   fRadius         = ;
    int     iSTRDamage      = iAbilityDmg;
    int     iCONDamage      = iAbilityDmg;
	int     iDC;
	

	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	float fRadius = HkApplySizeMods( FeetToMeters(2.0 * iCasterLevel) );
	int iShapeEffect = HkGetShapeEffect( CSLGetAOEExplodeByDamageType(DAMAGE_TYPE_NEGATIVE, fRadius ), SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	
    effect eVis1    = EffectVisualEffect(iShapeEffect);
    effect eVis2    = EffectVisualEffect(VFX_FNF_PWSTUN);
    effect eVis3    = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    effect eVisLink = EffectLinkEffects(eVis1,eVis2);
    eVisLink        = EffectLinkEffects(eVis3,eVisLink);
    effect eImp1    = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    effect eHPVis   = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eSTRDamage;
    effect eCONDamage;
    effect eAbilDmg;
    effect eHPDamage;
    effect eHPDamLink;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisLink, lTarget);

    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SHADOW_STORM));
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp1, oTarget);
            if(!HkResistSpell(oCaster, oTarget))
            {
                iDC = HkGetSpellSaveDC(oCaster, oTarget);
                if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType))
                {
                    iSTRDamage /= 2;
                    iCONDamage /= 2;
                }
                eSTRDamage = EffectAbilityDecrease(ABILITY_STRENGTH, iSTRDamage);
                eCONDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, iCONDamage);
                eAbilDmg = EffectLinkEffects(eSTRDamage, eCONDamage);
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbilDmg, oTarget, fDuration);
                iDamage = HkApplyMetamagicVariableMods( d12(iNumDice), 12 * iNumDice )+iBonus;
                iDamage=HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType, oCaster);
                if( iDamage > 0 )
                {
                    eHPDamage = HkEffectDamage(iDamage, iDamageType);
                    eHPDamLink = EffectLinkEffects(eHPVis, eHPDamage);
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHPDamLink, oTarget);
                }
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}
	HkPostCast(oCaster);
}



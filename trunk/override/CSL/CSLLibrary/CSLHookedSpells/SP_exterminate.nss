//::///////////////////////////////////////////////
//:: Exterminate
//:: sg_s0_extermin.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Necromancy
     Level: Sor/Wiz 1
     Components: V, S
     Casting Time: 1 action
     Range: Short
     Area of Effect: 10 ft/3 level radius sphere
     Target: Small vermin
     Duration: Instantaneous
     Saving Throw: No
     Spell Resistance: No

     This spell instantaneously snuffs out the life forces
     of small vermin within the area of effect.  Only
     creatures with 1-3 hp per caster level (9 hp maximum)
     and intelligence less than 4 can be exterminated. A
     maximum of 10 creatures are affected. More powerful
     wizards can thus affect bigger pests.  This spell is
     a favorite among necromancers who live among pestilence.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: November 10, 2004
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	


    int     iMaxHPAffected  = 3*iCasterLevel;
    int     iNumAffected    = 0;
    int     iRadius         = 10*(iCasterLevel/3+1);

    if(iRadius>30) iRadius=30;
    float   fRadius         = FeetToMeters(iRadius*1.0);
    if(iMaxHPAffected>9) iMaxHPAffected=9;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
    effect eVis     = EffectVisualEffect(VFX_IMP_DEATH);
    effect eDeath   = EffectDeath();
    effect eLink    = EffectLinkEffects(eVis,eDeath);

   	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    while(GetIsObjectValid(oTarget) && iNumAffected<=10)
    {
        if(CSLGetIsVermin(oTarget) && GetCurrentHitPoints(oTarget)<=iMaxHPAffected &&
            GetAbilityScore(oTarget,ABILITY_INTELLIGENCE)<4) {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_EXTERMINATE));
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                iNumAffected++;
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    }

    HkPostCast(oCaster);
}



//::///////////////////////////////////////////////
//:: Leech Field
//:: SG_S0_LeechF.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     This spell creates a purple haze which sucks
     damage from targets in area of effect and grants
     the hp to the caster.  The caster can absorb an
     amount of hp up to a total of twice his max hp.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 10, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     object  oTarget;         //= HkGetSpellTarget();
//
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
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
	int iSpellId = SPELL_LEECH_FIELD; // put spell constant here
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
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = iCasterLevel/2;
    int     iBonus          = 0;
    int     iDamage         = 0;

    float   fDelay          = 0.2;
    float   fRadius         = FeetToMeters(10.0);
    int     iHeal           = 0;
    int     iTempHP         = 0;
    int     iCasterDamage   = 0;
    int     iNumUndead      = 0;
    int     iCurrHP         = GetCurrentHitPoints(oCaster);
    int     iMaxHP          = GetMaxHitPoints(oCaster);
    
    if(iNumDice<1) iNumDice=1;
    if(iNumDice>20) iNumDice=20;
	int iDC;

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImp1    = EffectVisualEffect(VFX_FNF_LEECH_FIELD);
    effect eImp2    = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eVisDmg  = EffectVisualEffect(VFX_IMP_CHARM);
    effect eDamage;
    effect eHeal;
    effect eTempHP;
    effect eDamageLink;
    effect eHealLink;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    
    // Need to look at this, oTarget Can't exist yet
    //CSLRemoveEffectSpellIdSingle(SC_REMOVE_ONLYCREATOR, oCaster, oTarget, SPELL_LEECH_FIELD);
    SignalEvent(oCaster,EventSpellCastAt(oCaster, SPELL_LEECH_FIELD, FALSE));
    HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eImp1, lTarget, fDuration);
    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp2, lTarget);
    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oCaster)
        {
            SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_LEECH_FIELD));
            iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice );
            
            if( !CSLGetIsUndead(oTarget) && !HkResistSpell(oCaster, oTarget) )
            {
                if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE))
                {
                    iDamage/=2;
                }
                if(iDamage>(GetCurrentHitPoints(oTarget)+10))
                {
                    iDamage=GetCurrentHitPoints(oTarget)+10;
                }
                iHeal+=iDamage;
                eDamage=EffectDamage(iDamage,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_PLUS_TWENTY);
                eDamageLink=EffectLinkEffects(eVisDmg,eDamage);
                DelayCommand(fDelay,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageLink, oTarget));
            }
            else if ( CSLGetIsUndead(oTarget) )
            {
                if(!HkSavingThrow(SAVING_THROW_FORT, oCaster, iDC, SAVING_THROW_TYPE_NEGATIVE))
                {
                    iDamage/=2;
                }
                iCasterDamage+=iDamage;
                iNumUndead++;
                eDamage=EffectDamage(iDamage,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_PLUS_FIVE);
                eDamageLink=EffectLinkEffects(eVisDmg,eDamage);
                DelayCommand(fDelay,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageLink, oCaster));
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    }
    if(!GetIsDead(oCaster) && iHeal>0)
    {
        SignalEvent(oCaster,EventSpellCastAt(oCaster,SPELL_LEECH_FIELD,FALSE));
        iCurrHP=GetCurrentHitPoints(oCaster);
        if(iHeal+iCurrHP<=iMaxHP)
        {
            eHeal=EffectHeal(iHeal);
            eHealLink=EffectLinkEffects(eVisHeal,eHeal);
        }
        else if(iMaxHP<=iCurrHP)
        {
            iTempHP=iHeal;
            iHeal=0;
            if(iTempHP+iCurrHP>iMaxHP)
            {
               iTempHP=iCurrHP-iMaxHP;
            }
            eTempHP=EffectTemporaryHitpoints(iTempHP);
            eHealLink=eVisHeal;
        }
        else // iCurrHP<iMaxHP and iHeal+iCurrHP>iMaxHP
        {
            iTempHP=iHeal-(iMaxHP-iCurrHP);
            eHeal=EffectHeal(iMaxHP-iCurrHP);
            eHealLink=EffectLinkEffects(eVisHeal,eHeal);
            if(iTempHP>iMaxHP)
            {
               iTempHP=iMaxHP;
            }
            eTempHP=EffectTemporaryHitpoints(iTempHP);
        }
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHealLink, oCaster);
        
        if(iTempHP>0)
        {
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oCaster, HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS));
        }
    }
    if(iCasterDamage>0)
    {
        iHeal=iCasterDamage/iNumUndead;
        eHeal=EffectHeal(iHeal);
        eHealLink=EffectLinkEffects(eVisHeal,eHeal);
        oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
        while(GetIsObjectValid(oTarget) && iCasterDamage>0)
        {
            if(CSLGetIsUndead(oTarget))
            {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHealLink, oTarget);
                iCasterDamage-=iHeal;
            }
            oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
        }
    }

    HkPostCast(oCaster);
}


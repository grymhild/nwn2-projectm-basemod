//::///////////////////////////////////////////////
//:: Natures Balance
//:: SOZ UPDATE BTM
//:: NW_S0_NatureBal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

Transmutation
Level: Drd 4
Components: V,S
Casting Time: 1 action
Range: Touch
Target: Creature Touched
Duration: 1 hour/level
Saving Throw: Fortitude negates (harmless)
Spell Resistance: Yes (harmless)

You lend some of your ability score points to your target.
You suffer a penalty of 1d4+1 points to a single ability
score, and your target gains an equal enhancement bonus
to the same ability score (You don't get a saving throw to
avoid the loss).
If you cast this spell a second time within 1 hour, you
suffer 2d10 points of damage.


    Reduces the SR of all enemies by 1d4 per 5 caster
    levels for 1 round per 3 caster levels. Also heals
    all friends for 3d8 + Caster Level
    Radius is 15 feet from the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_NATURES_BALANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
    //Declare major variables
    effect eHeal;
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eSR;
    effect eVis2 = EffectVisualEffect(VFX_IMP_BREACH);
    effect eNature = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    int nRand;
    int iDuration = HkGetSpellDuration( oCaster )/3;
	int iSpellPower = HkGetSpellPower( oCaster );
    //int iCasterLevel = GetCasterLevel(OBJECT_SELF);
    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    //int iDuration = iCasterLevel/3;
   
    float fDelay;
    //Set off fire and forget visual
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eNature, GetLocation(OBJECT_SELF));
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    
    float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), FALSE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        fDelay = CSLRandomBetweenFloat();
        //Check to see how the caster feels about the targeted object
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
              //Fire cast spell at event for the specified target
              SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
              
               nRand = HkApplyMetamagicVariableMods( d8(3)+iSpellPower, 24 + iSpellPower);

              eHeal = EffectHeal(nRand);
              //Apply heal effects
              DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
              DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        else
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Check for saving throw
                if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC()))
                {
                      iSpellPower /= 5;
                      if(iSpellPower < 1 )
                      {
							iSpellPower = 1;
                      }
                      
                      nRand = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);
                       
                      eSR = EffectSpellResistanceDecrease(nRand);
                      effect eLink = EffectLinkEffects(eSR, eDur);
                      //Apply reduce SR effects
                      DelayCommand(fDelay, HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration ));
                      DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), FALSE);
	}
    
    HkPostCast(oCaster);
}


/*
Syrus Version
//::///////////////////////////////////////////////
//:: Nature's Balance
//:: sg_s0_naturebal.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
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

	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    int iAbilityAffected;
    
    int iBonusPenalty = HkApplyMetamagicVariableMods( d4(), 4 )+1;
    
    int iTooSoon=FALSE;

    switch(iSpellId)
    {
        case SPELL_NAT_BALANCE:
        case SPELL_NAT_BALANCE_STR:
            iAbilityAffected=ABILITY_STRENGTH;
            break;
        case SPELL_NAT_BALANCE_DEX:
            iAbilityAffected=ABILITY_DEXTERITY;
            break;
        case SPELL_NAT_BALANCE_INT:
            iAbilityAffected=ABILITY_INTELLIGENCE;
            break;
        case SPELL_NAT_BALANCE_WIS:
            iAbilityAffected=ABILITY_WISDOM;
            break;
        case SPELL_NAT_BALANCE_CHA:
            iAbilityAffected=ABILITY_CHARISMA;
            break;
    }

    int iLastCastDay=GetLocalInt(oCaster,"SG_NATBAL_DAY");
    if(iLastCastDay>0 && GetCalendarDay()-iLastCastDay==0)
    {
        int iLastCastHour = GetLocalInt(oCaster,"SG_NATBAL_HOUR");
        int iLastCastMinute = GetLocalInt(oCaster,"SG_NATBAL_MINUTE");
        if(GetTimeHour()-iLastCastHour==0)
        {
            iTooSoon=TRUE;
        }
        if(GetTimeHour()-iLastCastHour==1)
        {
            if(GetTimeMinute()-iLastCastMinute<=0)
            {
                iTooSoon=TRUE;
            }
        }
    }
	
	int iDamage = HkApplyMetamagicVariableMods( d10(2), 10 * 2 );
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eScoreImprove = EffectAbilityIncrease(iAbilityAffected, iBonusPenalty);
    effect eDurImprove = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eImproveLink = EffectLinkEffects(eScoreImprove, eDurImprove);
    effect eCasterVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eScoreDecrease = EffectAbilityDecrease(iAbilityAffected, iBonusPenalty);
    effect eDurDecrease = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDecreaseLink = EffectLinkEffects(eScoreDecrease, eDurDecrease);
    effect eDmgVis = EffectVisualEffect(246);
    effect eDamage = HkEffectDamage(iDamage);
    effect eDamageLink = EffectLinkEffects(eDmgVis, eDamage);

    //--------------------------------------------------------------------------
    //Apply effects
    //--------------------------------------------------------------------------
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_NAT_BALANCE, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImproveLink, oTarget, fDuration);
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_NAT_BALANCE, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterVis, oCaster);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDecreaseLink, oCaster);
    if(iTooSoon)
    {
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageLink, oCaster);
    }
    SetLocalInt(oCaster,"SG_NATBAL_MINUTE",GetTimeMinute());
    SetLocalInt(oCaster,"SG_NATBAL_HOUR",GetTimeHour());
    SetLocalInt(oCaster,"SG_NATBAL_DAY",GetCalendarDay());

    HkPostCast(oCaster);
}
*/


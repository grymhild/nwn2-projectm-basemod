//::///////////////////////////////////////////////
//:: Chaos Hammer/Holy Smite/Order's Wrath/
//:: Unholy Blight (Alignment Smite spells)
//:: SG_S0_AlignSmt.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     You unleash chaotic power to smite you enemies.
     The power takes the form of a multicolored
     explosion of leaping, ricocheting energy.  Only
     Lawful and Neutral (not Chaotic) creatures are
     harmed by this spell.

     This spell deals 1d8 points of damage per two
     caster levels (max 5d8) to lawful creatures and
     staggers (dazes) them for 1d6 rounds.  A successful will
     save reduces the damage by half and negates the
     stagger (daze) effect.

     The spell only deals half damage against creatures
     who are not lawful or chaotic, and does not stagger
     them.  A successful Will save reduces the damage to
     one quarter.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 7, 2003
//:://////////////////////////////////////////////
//:: Edited On: October 10, 2003
//:://////////////////////////////////////////////
/*
     Changed to include all domain "smite" spells
     based on spell id
*/
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
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
    int     iDieType        = 8;
    int     iNumDice        = iCasterLevel/2;
    //int     iBonus          = 0;
    int     iDamage         = 0;

    float   fRadius         = RADIUS_SIZE_HUGE;
    int     iSaveType;
    int     iAlignNotAffected;
    int     iAlignVersus;
    
    if(iNumDice>5) iNumDice=5;
	float fDuration;
	int iDC;

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eDam;
    effect eDazed       = EffectDazed();
    effect eDazedImp    = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eBlind       = EffectBlindness();
    effect eBlindImp    = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eAttDec      = EffectAttackDecrease(2);
    effect eDmgDec      = EffectDamageDecrease(2);
    effect eSaveDec     = EffectSavingThrowDecrease(SAVING_THROW_TYPE_ALL,2);
    effect eSkillDec    = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
    effect eSicken      = EffectLinkEffects(eAttDec,eDmgDec);
    eSicken             = EffectLinkEffects(eSicken, eSaveDec);
    eSicken             = EffectLinkEffects(eSicken, eSkillDec);
    effect eSickenImp   = EffectVisualEffect(VFX_IMP_DISEASE_S);
    effect eSpellImp;
    effect eImp;
    effect eVis         = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eDur;
    effect eLink;

    switch(iSpellId)
    {
        case SPELL_CHAOS_HAMMER:
            iAlignNotAffected = ALIGNMENT_CHAOTIC;
            iAlignVersus = ALIGNMENT_LAWFUL;
            eSpellImp=EffectVisualEffect(VFX_IMP_LIGHTNING_M);
            eImp=eDazedImp;
            eDur=eDazed;
            fDuration=HkApplyDurationCategory(1);
            iSaveType=SAVING_THROW_WILL;
            break;
        case SPELL_HOLY_SMITE:
            iAlignNotAffected = ALIGNMENT_GOOD;
            iAlignVersus = ALIGNMENT_EVIL;
            eSpellImp=EffectVisualEffect(VFX_IMP_HEALING_X);
            eImp=eBlindImp;
            eDur=eBlind;
            fDuration=HkApplyDurationCategory(1);
            iSaveType=SAVING_THROW_REFLEX;
            break;
        case SPELL_ORDERS_WRATH:
            iAlignNotAffected = ALIGNMENT_LAWFUL;
            iAlignVersus = ALIGNMENT_CHAOTIC;
            fRadius=RADIUS_SIZE_GARGANTUAN;
            eSpellImp=EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
            eImp=eDazedImp;
            eDur=eDazed;
            fDuration=HkApplyDurationCategory(1);
            iSaveType=SAVING_THROW_REFLEX;
            break;
        case SPELL_UNHOLY_BLIGHT:
            iAlignNotAffected = ALIGNMENT_EVIL;
            iAlignVersus = ALIGNMENT_GOOD;
            eSpellImp=EffectVisualEffect(VFX_IMP_HARM);
            eImp=eSickenImp;
            eDur=eSicken;
            fDuration=HkApplyDurationCategory( HkApplyMetamagicVariableMods( d4(), 4 ) );
            iSaveType=SAVING_THROW_FORT;
            break;
    }

	fDuration = HkApplyMetamagicDurationMods( fDuration );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//int iImpactSEF = VFX_NONE;
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	//location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	//effect eImpactVis = EffectVisualEffect( iImpactSEF );
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSpellImp, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    while (GetIsObjectValid(oTarget))
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oCaster)
        {
            if(!HkResistSpell(oCaster, oTarget))
            {
                iDC = HkGetSpellSaveDC(oCaster, oTarget);
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                iDamage = HkApplyMetamagicVariableMods(d8(iNumDice), 8*iNumDice );

                switch(iSpellId)
                {
                    case SPELL_CHAOS_HAMMER:
                    case SPELL_ORDERS_WRATH:
                        if(GetAlignmentLawChaos(oTarget)!=iAlignNotAffected)
                        {
                            SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
                            if(GetAlignmentLawChaos(oTarget)==iAlignVersus)
                            {
                                if(!HkSavingThrow(iSaveType,oTarget,iDC,SAVING_THROW_TYPE_DIVINE))
                                {
                                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
                                }
                                else
                                {
                                    iDamage/=2;
                                }
                            }
                            else
                            {
                                iDamage/=2;
                                if(!HkSavingThrow(iSaveType,oTarget,iDC,SAVING_THROW_TYPE_DIVINE))
                                {
                                    iDamage/=2;
                                }
                            }
                            eDam = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
                            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                        }
                        break;
                    case SPELL_HOLY_SMITE:
                    case SPELL_UNHOLY_BLIGHT:
                        if(GetAlignmentGoodEvil(oTarget)!=iAlignNotAffected)
                        {
                            SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
                            if(GetAlignmentLawChaos(oTarget)==iAlignVersus)
                            {
                                if(!HkSavingThrow(iSaveType,oTarget,iDC,SAVING_THROW_TYPE_DIVINE))
                                {
                                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
                                }
                                else
                                {
                                    iDamage/=2;
                                }
                            }
                            else
                            {
                                iDamage/=2;
                                if(!HkSavingThrow(iSaveType,oTarget,iDC,SAVING_THROW_TYPE_DIVINE))
                                    iDamage/=2;
                            }
                            eDam = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
                            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                        }
                        break;
                }
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
    }

    HkPostCast(oCaster);
}



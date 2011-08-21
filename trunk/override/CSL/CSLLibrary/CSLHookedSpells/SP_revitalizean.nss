//::///////////////////////////////////////////////
//:: Revitalize Animal
//:: sg_s0_revani.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Necromancy
Level: Ranger 1
Components: V, S
Casting Time: 1 action
Range: Touch
Duration: Permanent
Area of Effect: One animal
Saving Throw: No (harmless)
Spell Resistance: No (harmless)

This spell allows the caster to heal an animal by transferring
life force (hit points) from himself to the animal. If the
animal is touched with one hand, it regains 1d4 hit points,
just as if it had received a cure light wounds spell. Touching
the animal with both hands restores 2d4 hit points. In either
case, the caster temporarily loses the number of hit points
that the animal regains. The caster will recover his lost hit
points 1-4 hours later. During the 1-4 hours before the caster
recovers his transferred hit points, he feels weak and dizzy,
making all attack rolls at a -1 penalty during that time. The
animal cannot recover hit points beyond the normal allotment,
and the caster will have at least 1 hit point remaining after
using this spell.  Revitalize animal works on animals only.
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
//     SGSetSpellInfo( );
// 
//
//
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
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory( HkApplyMetamagicVariableMods( d4(), 4 ), SC_DURCATEGORY_HOURS) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 4;
    int     iNumDice        = 0;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iTargetDmg      = GetMaxHitPoints(oTarget)-GetCurrentHitPoints(oTarget);
    int     iPossibleHealAmt = GetCurrentHitPoints(oCaster)-1;

    switch(iSpellId)
    {
        case SPELL_REVITALIZE_ANIMAL_1:
            iNumDice=1;
            break;
        case SPELL_REVITALIZE_ANIMAL_2:
        case SPELL_REVITALIZE_ANIMAL:
            iNumDice=2;
            break;
    }
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
    iDamage = HkApplyMetamagicVariableMods( d4(iNumDice), 4 * iNumDice );

    if(iDamage>iTargetDmg) iDamage=iTargetDmg;
    if(iDamage>iPossibleHealAmt) iDamage=iPossibleHealAmt;
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis          = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eHeal            = EffectHeal(iDamage);
    effect eTargetLink      = EffectLinkEffects(eImpVis, eHeal);
    effect eAttackPenalty   = EffectAttackDecrease(1);
    effect eDurVis          = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eCasterLink      = EffectLinkEffects(eAttackPenalty, eDurVis);
    effect eCasterDmg       = HkEffectDamage(iDamage);

	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_REVITALIZE_ANIMAL, FALSE));
    if(CSLGetIsAnimal(oTarget)  && !CSLGetIsImmuneToMagicalHealing(oTarget))
    {
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eTargetLink, oTarget);
        SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_REVITALIZE_ANIMAL, FALSE));
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCasterLink, oCaster, fDuration);
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCasterDmg, oCaster);
        DelayCommand(fDuration, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eTargetLink, oCaster));
    } else if(!CSLGetIsImmuneToMagicalHealing(oTarget))
    {
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_SMALL_SMOKEPUFF), oTarget);
        FloatingTextStringOnCreature("This spell works on animals only!", oCaster, FALSE);
    }

    HkPostCast(oCaster);
}


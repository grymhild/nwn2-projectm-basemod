//::///////////////////////////////////////////////
//:: Animal Growth
//:: sg_s0_AniGrowth.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Transmutation
     Level: Drd 5, Sor/Wiz 5
     Components: V,S
     Casting Time: 1 action
     Range: Medium (100 ft + 10 ft/level)
     Targets: Up to one animal/two levels, within
        a 15' radius spread
     Duration: 1 minute/level
     Saving Throw: None
     Spell Resistance: Yes

     A number of animals grow to twice their normal
     size.  This doubles each animal's Hit Dice, reduces
     its AC according to its new size and increase
     Strength and Constitution scores.  This spell
     does not affect Colossal sized creatures.
     This spell gives no means of command or influence
     over the affected creatures.  Casting this spell again
     on an affected creature merely extends the duration
     of the spell and provides no further benefit.
*/
//:://////////////////////////////////////////////
//:: Animal Growth
//:: Transmutation
//:: Levels: Druid 5, Ranger 4
//:: Components: V, S
//:: Target: Animal Companion.
//:: Duration: 1 minute/level.
//:: Your animal companion grows in size and strength. This alteration grants
//:: your animal companion a +8 enhancement bonus to Strength, a +4 enhancement
//:: bonus to Constitution, a +1 Dodge AC bonus, and imposes a -2 penalty to
//:: Dexterity and -1 penalty to attack bonus. This spell only affects animals
//:: (standard animal companions and the dinosaur).
//:://////////////////////////////////////////////

//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 28, 2004
//:://////////////////////////////////////////////
// 
// #include "sg_inc_elements"
//
// 
// 
// void main()
// {
// 
//
//
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
//     //int     iDieType        = 0;
//     //int     iNumDice        = 0;
//     //int     iBonus          = 0;
//     //int     iDamage         = 0;
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

    float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
    int     iNumCreatures   = iCasterLevel/2;
    int     iNumAffected    = 0;
    int     iCreatureSize   = 0;    // GetCreatureSize(oTarget)
    int     iHitDice        = 0;    // GetHitDice(oTarget)
    int     iHitPoints      = 0;    // GetMaxHitPoints(oTarget)
    int     iStrIncrease    = 0;    // depends upon size
    int     iDexDecrease    = 0;    // depends upon size
    int     iConIncrease    = 0;    // depends upon size
    int     iBABIncrease    = 0;    // =HD * 3/4
    int     iAttackInc      = 0;    // depends upon size
    int     iDmgInc         = 0;    // depends upon size
    int     iACInc          = 0;    // depends upon size
    int     iCount          = 1;

    if(iNumCreatures<1) iNumCreatures=1;
    

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis              = EffectVisualEffect(VFX_IMP_GOOD_HELP);  // Visible impact effect
    effect eHPIncrease;
    effect eStrIncrease;
    effect eDexDecrease;
    effect eConIncrease;
    effect eAttackIncrease;
    effect eDamageIncrease;
    effect eRefSaveIncrease     = EffectSavingThrowIncrease(SAVING_THROW_REFLEX,1);
    effect eFortSaveIncrease    = EffectSavingThrowIncrease(SAVING_THROW_FORT,1);
    effect eLink                = EffectLinkEffects(eRefSaveIncrease,eFortSaveIncrease);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    object oTarget = GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, TRUE, lTarget, iCount);
    while(GetIsObjectValid(oTarget) && iNumAffected<=iNumCreatures &&
        GetDistanceBetweenLocations(lTarget,GetLocation(oTarget))<=fRadius) {
            if(!CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster) && CSLGetIsAnimal(oTarget) )
            {
                iCreatureSize = GetCreatureSize(oTarget);
                switch(iCreatureSize) {
                    case CREATURE_SIZE_TINY:
                        iStrIncrease=4;
                        iDexDecrease=2;
                        iAttackInc=1;
                        iDmgInc=1;
                        break;
                    case CREATURE_SIZE_SMALL:
                        iStrIncrease=4;
                        iDexDecrease=2;
                        iConIncrease=2;
                        iAttackInc=1;
                        iDmgInc=1;
                        break;
                    case CREATURE_SIZE_MEDIUM:
                        iStrIncrease=8;
                        iDexDecrease=2;
                        iConIncrease=4;
                        iAttackInc=1;
                        iDmgInc=1;
                        iACInc=2;
                        break;
                    case CREATURE_SIZE_LARGE:
                        iStrIncrease=8;
                        iDexDecrease=2;
                        iConIncrease=4;
                        iACInc=3;
                        iAttackInc=1;
                        iDmgInc=1;
                        break;
                    case CREATURE_SIZE_HUGE:
                        iStrIncrease=8;
                        iConIncrease=4;
                        iACInc=4;
                        iAttackInc=2;
                        iDmgInc=2;
                        break;
                }
                iHitDice=GetHitDice(oTarget);
                iHitPoints=GetMaxHitPoints(oTarget);
                iBABIncrease=iHitDice*3/4;
                iAttackInc+=iBABIncrease;
                eHPIncrease = EffectTemporaryHitpoints(iHitPoints);
                eStrIncrease = EffectAbilityIncrease(ABILITY_STRENGTH, iStrIncrease);
                eDexDecrease = EffectAbilityDecrease(ABILITY_DEXTERITY, iDexDecrease);
                eConIncrease = EffectAbilityIncrease(ABILITY_CONSTITUTION, iConIncrease);
                eAttackIncrease = EffectAttackIncrease(iAttackInc);
                eDamageIncrease = EffectDamageIncrease(iDmgInc);
                eLink = EffectLinkEffects(eLink,eHPIncrease);
                eLink = EffectLinkEffects(eLink, eStrIncrease);
                eLink = EffectLinkEffects(eLink, eDexDecrease);
                eLink = EffectLinkEffects(eLink, eConIncrease);
                eLink = EffectLinkEffects(eLink, eAttackIncrease);
                eLink = EffectLinkEffects(eLink, eDamageIncrease);

                SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_ANIMAL_GROWTH,FALSE));
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ANIMAL_GROWTH );
                
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                iNumAffected++;
            }
            iCount++;
            oTarget=GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, TRUE, lTarget, iCount);
    }

    HkPostCast(oCaster);
}


/*
Kaedrins version here

//::///////////////////////////////////////////////
//:: Animal Growth
//:: cmi_s0_animgrow
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_ginc_spells"

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nCasterLevel = GetPalRngCasterLevel();

	object oTarget = HkGetSpellTarget();

	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_AWAKEN );	// NWN2 VFX
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,8);
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,4);
	effect eAC = EffectACIncrease(1);
	effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY,2);
	effect eAB = EffectAttackDecrease(1);
	effect eLink = EffectLinkEffects(eVis, eStr);
	eLink = EffectLinkEffects(eLink, eCon);
	eLink = EffectLinkEffects(eLink, eDex);
	eLink = EffectLinkEffects(eLink, eAB);
	eLink = EffectLinkEffects(eLink, eAC);

	int nSpellId = HkGetSpellId();

	int nMetaMagic = HkGetMetaMagicFeat();
	float fDuration = TurnsToSeconds(nCasterLevel);
	fDuration = HkApplyMetamagicDurationMods(fDuration);


	if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
	{
		if(GetHasSpellEffect(nSpellId))
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, nSpellId, oTarget );
		}
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}
}
*/
//::///////////////////////////////////////////////
//:: Energy Spell Script
//:: SG_S0_EneSpell
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Script for the elemental protection spells -
    Endure Elements
    Resist Elements
    Protection from Elements
    Mass Resist Elements
    Energy Immunity

    This way it keeps all of them together so you
    can take care of avoiding stacking in the same
    script.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: Oct 28, 2003
//:://////////////////////////////////////////////

// Place holders to make it compile, need to sort this out later if it's even needed
// The mass version of the spells i'll probably implement
const int SPELL_AURA_AGAINST_FLAME = -1500;
const int SPELL_ENDURE_ELEMENTS_ACID = -1501;
const int SPELL_ENDURE_ELEMENTS_ELECTRICITY = -1502;
const int SPELL_ENDURE_ELEMENTS_FIRE = -1503;
const int SPELL_ENDURE_ELEMENTS_SONIC = -1504;
const int SPELL_ENDURE_ELEMENTS_COLD = -1520;
const int SPELL_ENERGY_IMMUNE_ACID = -1505;
const int SPELL_ENERGY_IMMUNE_ELECTRICITY = -1506;
const int SPELL_ENERGY_IMMUNE_FIRE = -1507;
const int SPELL_ENERGY_IMMUNE_SONIC = -1508;
const int SPELL_ENERGY_IMMUNE_COLD = -1523;
const int SPELL_PROTECTION_FROM_ELEMENTS = -1509;
const int SPELL_PROTECTION_FROM_ELEMENTS_ACID = -1510;
const int SPELL_PROTECTION_FROM_ELEMENTS_ELECTRICITY = -1511;
const int SPELL_PROTECTION_FROM_ELEMENTS_FIRE = -1512;
const int SPELL_PROTECTION_FROM_ELEMENTS_SONIC = -1513;
const int SPELL_PROTECTION_FROM_ELEMENTS_COLD = -1521;
const int SPELL_RESIST_ELEMENTS = -1514;
const int SPELL_RESIST_ELEMENTS_ACID = -1515;
const int SPELL_RESIST_ELEMENTS_COLD = -1516;
const int SPELL_RESIST_ELEMENTS_ELECTRICITY = -1517;
const int SPELL_RESIST_ELEMENTS_FIRE  = -1518;
const int SPELL_RESIST_ELEMENTS_SONIC = -1519;

//#include "sg_i0_spconst"
//
//
//
// 
// void main()
// {
//
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
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget; // = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------



        
    int     iResistAmount       = 5;
    int     iUpperLimit         = 0;
    int     iSpellType          = GetSpellId();
    int     iDamageType;
    int     iHasGreaterEffect   = FALSE;
    int     iMassTargets        = FALSE;
    int     iNumTargets         = 1;
    int     iLoop               = 0;
    float   fRadius             = FeetToMeters(30.0);

    switch(iSpellType)
    {
        case SPELL_ENDURE_ELEMENTS:
            iSpellType=SPELL_ENDURE_ELEMENTS_FIRE;
            break;
        case SPELL_RESIST_ELEMENTS:
            iSpellType=SPELL_RESIST_ELEMENTS_FIRE;
            break;
        case SPELL_PROTECTION_FROM_ELEMENTS:
            iSpellType=SPELL_PROTECTION_FROM_ELEMENTS_FIRE;
            break;
        case SPELL_ENERGY_IMMUNITY:
            iSpellType=SPELL_ENERGY_IMMUNE_FIRE;
            break;
        case SPELL_MASS_RESIST_ELEMENTS:
            iSpellType=SPELL_MASS_RESIST_ELEMENTS_FIRE;
        case SPELL_MASS_RESIST_ELEMENTS_ACID:
        case SPELL_MASS_RESIST_ELEMENTS_COLD:
        case SPELL_MASS_RESIST_ELEMENTS_ELECTRICITY:
        case SPELL_MASS_RESIST_ELEMENTS_FIRE:
        case SPELL_MASS_RESIST_ELEMENTS_SONIC:
            iMassTargets=TRUE;
            iNumTargets=iCasterLevel;
            break;
    }
    
    switch(iSpellType) {
        // ENDURE ELMENTS
        case SPELL_ENDURE_ELEMENTS_ACID:
            iDamageType=DAMAGE_TYPE_ACID;
            iResistAmount=5;
            break;
        case SPELL_ENDURE_ELEMENTS_COLD:
            iDamageType=DAMAGE_TYPE_COLD;
            iResistAmount=5;
            break;
        case SPELL_ENDURE_ELEMENTS_ELECTRICITY:
            iDamageType=DAMAGE_TYPE_ELECTRICAL;
            iResistAmount=5;
            break;
        case SPELL_ENDURE_ELEMENTS_FIRE:
            iDamageType=DAMAGE_TYPE_FIRE;
            iResistAmount=5;
            break;
        case SPELL_ENDURE_ELEMENTS_SONIC:
            iDamageType=DAMAGE_TYPE_SONIC;
            iResistAmount=5;
            break;
        // RESIST ELEMENTS & MASS RESIST ELEMENTS
        case SPELL_MASS_RESIST_ELEMENTS_ACID:
        case SPELL_RESIST_ELEMENTS_ACID:
            iDamageType=DAMAGE_TYPE_ACID;
            iResistAmount=12;
            break;
        case SPELL_MASS_RESIST_ELEMENTS_COLD:
        case SPELL_RESIST_ELEMENTS_COLD:
            iDamageType=DAMAGE_TYPE_COLD;
            iResistAmount=12;
            break;
        case SPELL_MASS_RESIST_ELEMENTS_ELECTRICITY:
        case SPELL_RESIST_ELEMENTS_ELECTRICITY:
            iDamageType=DAMAGE_TYPE_ELECTRICAL;
            iResistAmount=12;
            break;
        case SPELL_MASS_RESIST_ELEMENTS_FIRE:
        case SPELL_RESIST_ELEMENTS_FIRE:
            iDamageType=DAMAGE_TYPE_FIRE;
            iResistAmount=12;
            break;
        case SPELL_MASS_RESIST_ELEMENTS_SONIC:
        case SPELL_RESIST_ELEMENTS_SONIC:
            iDamageType=DAMAGE_TYPE_SONIC;
            iResistAmount=12;
            break;
        // PROTECTION FROM ELEMENTS && ENERGY IMMUNITY
        case SPELL_PROTECTION_FROM_ELEMENTS_ACID:
            iUpperLimit=12*iCasterLevel;
            fDuration=HkApplyDurationCategory(iCasterLevel, SC_DURCATEGORY_MINUTES);
        case SPELL_ENERGY_IMMUNE_ACID:
            iDamageType=DAMAGE_TYPE_ACID;
            iResistAmount=9999;
            break;
        case SPELL_PROTECTION_FROM_ELEMENTS_COLD:
            iUpperLimit=12*iCasterLevel;
            fDuration=HkApplyDurationCategory(iCasterLevel, SC_DURCATEGORY_MINUTES);
        case SPELL_ENERGY_IMMUNE_COLD:
            iDamageType=DAMAGE_TYPE_COLD;
            iResistAmount=9999;
            break;
        case SPELL_PROTECTION_FROM_ELEMENTS_ELECTRICITY:
            iUpperLimit=12*iCasterLevel;
            fDuration=HkApplyDurationCategory(iCasterLevel, SC_DURCATEGORY_MINUTES);
        case SPELL_ENERGY_IMMUNE_ELECTRICITY:
            iDamageType=DAMAGE_TYPE_ELECTRICAL;
            iResistAmount=9999;
            break;
        case SPELL_PROTECTION_FROM_ELEMENTS_FIRE:
            iUpperLimit=12*iCasterLevel;
            fDuration=HkApplyDurationCategory(iCasterLevel, SC_DURCATEGORY_MINUTES);
        case SPELL_ENERGY_IMMUNE_FIRE:
            iDamageType=DAMAGE_TYPE_FIRE;
            iResistAmount=9999;
            break;
        case SPELL_PROTECTION_FROM_ELEMENTS_SONIC:
            iUpperLimit=12*iCasterLevel;
            fDuration=HkApplyDurationCategory(iCasterLevel, SC_DURCATEGORY_MINUTES);
        case SPELL_ENERGY_IMMUNE_SONIC:
            iDamageType=DAMAGE_TYPE_SONIC;
            iResistAmount=9999;
            break;
    }

	fDuration = HkApplyMetamagicDurationMods( fDuration );


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eDur     = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
    effect eVis     = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    effect eDur2    = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eEnergyAbsorb;
    effect eLink    = EffectLinkEffects(eDur, eDur2);

    //--------------------------------------------------------------------------
    //Apply effects
    //--------------------------------------------------------------------------
    if(iMassTargets) {
        lTarget=GetLocation(oTarget);
        oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    }

    while(GetIsObjectValid(oTarget) && iNumTargets>0) {
        if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_ALLALLIES, oCaster)) {
            switch(iSpellType) {
                // ENDURE ELMENTS
                case SPELL_ENDURE_ELEMENTS_ACID:
                    if(GetHasSpellEffect(SPELL_RESIST_ELEMENTS_ACID,oTarget) || GetHasSpellEffect(SPELL_MASS_RESIST_ELEMENTS_ACID, oTarget) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_ACID );
                    break;
                case SPELL_ENDURE_ELEMENTS_COLD:
                    if(GetHasSpellEffect(SPELL_RESIST_ELEMENTS_COLD,oTarget) || GetHasSpellEffect(SPELL_MASS_RESIST_ELEMENTS_COLD, oTarget) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_COLD );
                    break;
                case SPELL_ENDURE_ELEMENTS_ELECTRICITY:
                    if(GetHasSpellEffect(SPELL_RESIST_ELEMENTS_ELECTRICITY,oTarget) || GetHasSpellEffect(SPELL_MASS_RESIST_ELEMENTS_ELECTRICITY, oTarget) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_ELECTRICITY );
                    break;
                case SPELL_ENDURE_ELEMENTS_FIRE:
                    if(GetHasSpellEffect(SPELL_RESIST_ELEMENTS_FIRE,oTarget) || GetHasSpellEffect(SPELL_MASS_RESIST_ELEMENTS_FIRE, oTarget) || GetHasSpellEffect(SPELL_AURA_AGAINST_FLAME, oTarget))
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_FIRE );
                    break;
                case SPELL_ENDURE_ELEMENTS_SONIC:
                    if(GetHasSpellEffect(SPELL_RESIST_ELEMENTS_SONIC,oTarget) || GetHasSpellEffect(SPELL_MASS_RESIST_ELEMENTS_SONIC) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_SONIC );
                    break;
                // RESIST ELEMENTS & MASS RESIST ELEMENTS
                case SPELL_MASS_RESIST_ELEMENTS_ACID:
                case SPELL_RESIST_ELEMENTS_ACID:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_ACID );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_RESIST_ELEMENTS_ACID );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MASS_RESIST_ELEMENTS_ACID );
                    break;
                case SPELL_MASS_RESIST_ELEMENTS_COLD:
                case SPELL_RESIST_ELEMENTS_COLD:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_COLD );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_RESIST_ELEMENTS_COLD );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MASS_RESIST_ELEMENTS_COLD );
                    break;
                case SPELL_MASS_RESIST_ELEMENTS_ELECTRICITY:
                case SPELL_RESIST_ELEMENTS_ELECTRICITY:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_ELECTRICITY );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_RESIST_ELEMENTS_ELECTRICITY );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MASS_RESIST_ELEMENTS_ELECTRICITY );
                    break;
                case SPELL_MASS_RESIST_ELEMENTS_FIRE:
                case SPELL_RESIST_ELEMENTS_FIRE:
                    if(GetHasSpellEffect(SPELL_AURA_AGAINST_FLAME, oTarget))
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_FIRE );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_RESIST_ELEMENTS_FIRE );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MASS_RESIST_ELEMENTS_FIRE );
                    break;
                case SPELL_MASS_RESIST_ELEMENTS_SONIC:
                case SPELL_RESIST_ELEMENTS_SONIC:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENDURE_ELEMENTS_SONIC );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_RESIST_ELEMENTS_SONIC );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MASS_RESIST_ELEMENTS_SONIC );
                    break;
                // PROTECTION FROM ELEMENTS
                case SPELL_PROTECTION_FROM_ELEMENTS_ACID:
                    if(GetHasSpellEffect(SPELL_ENERGY_IMMUNE_ACID,oTarget) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_ACID );
                    break;
                case SPELL_PROTECTION_FROM_ELEMENTS_COLD:
                    if(GetHasSpellEffect(SPELL_ENERGY_IMMUNE_COLD,oTarget) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_COLD );
                    break;
                case SPELL_PROTECTION_FROM_ELEMENTS_ELECTRICITY:
                    if(GetHasSpellEffect(SPELL_ENERGY_IMMUNE_ELECTRICITY,oTarget) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_ELECTRICITY );
                    break;
                case SPELL_PROTECTION_FROM_ELEMENTS_FIRE:
                    if(GetHasSpellEffect(SPELL_ENERGY_IMMUNE_FIRE,oTarget) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_FIRE );
                    break;
                case SPELL_PROTECTION_FROM_ELEMENTS_SONIC:
                    if(GetHasSpellEffect(SPELL_ENERGY_IMMUNE_SONIC,oTarget) )
                    {
                        FloatingTextStringOnCreature("You already have a greater effect.  Spell ineffective.", oTarget);
                        iHasGreaterEffect=TRUE;
                    }
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_SONIC );
                    break;
                // ENERGY IMMUNITY
                case SPELL_ENERGY_IMMUNE_ACID:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_ACID );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENERGY_IMMUNE_ACID );
                    break;
                case SPELL_ENERGY_IMMUNE_COLD:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_COLD );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENERGY_IMMUNE_COLD );
                    break;
                case SPELL_ENERGY_IMMUNE_ELECTRICITY:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_ELECTRICITY );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENERGY_IMMUNE_ELECTRICITY );
                    break;
                case SPELL_ENERGY_IMMUNE_FIRE:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_FIRE );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENERGY_IMMUNE_FIRE );
                    break;
                case SPELL_ENERGY_IMMUNE_SONIC:
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_PROTECTION_FROM_ELEMENTS_SONIC );
                    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENERGY_IMMUNE_SONIC );
                    break;
            }
            eEnergyAbsorb=EffectDamageResistance(iDamageType, iResistAmount,iUpperLimit);

            if(!iLoop)
            {
				eLink=EffectLinkEffects(eLink, eEnergyAbsorb);
            }
            
            if(!iHasGreaterEffect)
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellType, FALSE));
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            }
            iNumTargets--;
            iLoop=1;
        }
        if(iMassTargets)
        {
            oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
		}
    }

    HkPostCast();
}

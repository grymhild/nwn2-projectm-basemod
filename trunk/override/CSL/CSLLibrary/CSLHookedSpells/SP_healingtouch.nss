//::///////////////////////////////////////////////
//:: Spell Template
//:: spell template.nss
//:: 2005 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 14, 2005
//:://////////////////////////////////////////////
// #include "sg_inc_cure"
// 
//     //--------------------------------------------------------------------------
//     // Spellcast Hook Code
//     // Added 2003-06-20 by Georg
//     // If you want to make changes to all spells, check x2_inc_spellhook.nss to
//     // find out more
//     //--------------------------------------------------------------------------
//     if (!X2PreSpellCastCode())
//     {
//         return;
//     }
    // End of Spell Cast Hook
#include "_HkSpell"
#include "_SCInclude_Healing"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iSpellSchool = SPELL_SCHOOL_GENERAL;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	if( iSpellId != SPELLABILITY_LESSER_BODY_ADJUSTMENT )
	{
		iSpellSchool = SPELL_SCHOOL_CONJURATION;
		iSpellSubSchool = SPELL_SUBSCHOOL_HEALING;
	}
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 8;
    int     iNumDice        = 1;
    int     iBonus          = iCasterLevel;
    int     iDamage         = 0;


    int iVis = VFX_IMP_SUNSTRIKE;
    int iVis2;

    switch(iSpellId)
    {
        case SPELL_CURE_MINOR_WOUNDS:
            iDieType = 1;
            iNumDice = 1;
            iBonus = 0;
            iDamage = 1;
            iVis2 = VFX_IMP_HEAD_HEAL;
            break;
        case SPELL_CURE_LIGHT_WOUNDS:
        case SPELLABILITY_LESSER_BODY_ADJUSTMENT:
            iNumDice = 1;
            if(iBonus>5) iBonus = 5;
            iVis2 = VFX_IMP_HEALING_S;
            break;
        case SPELL_CURE_MODERATE_WOUNDS:
            iNumDice = 2;
            if(iBonus>10) iBonus = 10;
            iVis2 = VFX_IMP_HEALING_M;
            break;
        case SPELL_CURE_SERIOUS_WOUNDS:
            iNumDice = 3;
            if(iBonus>15) iBonus = 15;
            iVis2 = VFX_IMP_HEALING_L;
            break;
        case SPELL_CURE_CRITICAL_WOUNDS:
            iNumDice = 4;
            if(iBonus>20) iBonus = 20;
            iVis2 = VFX_IMP_HEALING_G;
            break;
        case SPELL_MASS_CURE_LIGHT_WOUNDS:
            iNumDice = 1;
            if(iBonus>25) iBonus = 25;
            iVis2 = VFX_IMP_HEALING_M;
            break;
        case SPELL_MASS_CURE_MODERATE_WOUNDS:
            iNumDice = 2;
            if(iBonus>30) iBonus = 30;
            iVis2 = VFX_IMP_HEALING_L;
            break;
        case SPELL_MASS_CURE_SERIOUS_WOUNDS:
            iNumDice = 3;
            if(iBonus>35) iBonus = 35;
            iVis2 = VFX_IMP_HEALING_G;
            break;
        case SPELL_MASS_CURE_CRITICAL_WOUNDS:
            iNumDice = 4;
            if(iBonus>40) iBonus = 40;
            iVis2 = VFX_IMP_HEALING_G;
            break;
        case SPELL_HEALING_TOUCH:
            iDieType = 6;
            iNumDice = iCasterLevel/2;
            iBonus = 0;
            if(iNumDice>10) iNumDice=10;
            if(iNumDice<1) iNumDice=1;
            iVis2 = VFX_IMP_HEALING_L;
            break;
    }

	iDamage = HkApplyMetamagicVariableMods( CSLDieX( iDieType,iNumDice), iDieType * iNumDice )+iBonus;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SCspellsCure(iDamage, iBonus, iDieType*iNumDice, iVis, iVis2, iSpellId);

    HkPostCast();
}



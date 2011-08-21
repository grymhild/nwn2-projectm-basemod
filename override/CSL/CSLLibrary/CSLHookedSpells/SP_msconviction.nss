//::///////////////////////////////////////////////
//:: Conviction
//:: sg_s0_convictn.nss
//:: 2006 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Spell Compendium
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 9, 2006
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
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*10, SC_DURCATEGORY_MINUTES) );
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
    int     iBonus          = 2 + iCasterLevel / 6;
    //int     iDamage         = 0;
    float   fRange          = FeetToMeters(20.0);
    int     bSingleTarget   = TRUE;
    int     bContinue       = TRUE;

    if (iBonus > 5 ) iBonus=5;
    if ( iSpellId==SPELL_MASS_CONVICTION )
    {
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE);
        bSingleTarget = FALSE;
    }
    




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eBonus   = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus);
 
    //--------------------------------------------------------------------------
    //Apply effects
    //--------------------------------------------------------------------------
    while(GetIsObjectValid(oTarget) && bContinue)
    {
        if ( bSingleTarget || CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) )
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oTarget, fDuration);
        }

        if(bSingleTarget)
        {
            bContinue = FALSE;
		}
		else
		{
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRange, lTarget, TRUE);
		}
	}
    
    
    HkPostCast(oCaster);
}



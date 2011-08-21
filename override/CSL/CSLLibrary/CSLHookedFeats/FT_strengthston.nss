//::///////////////////////////////////////////////
//:: Strength of Stone (2E Spells & Magic p. 162)
//:: sg_s0_strstone.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation
     Level: Earth 2
     Components: V, S
     Casting Time: 1 action
     Range: Touch
     Target: 1 creature
     Duration: 3 rounds + 1 round/level
     Saving Throw: Yes (harmless)
     Spell Resistance: Yes (harmless)

     This spell grants supernatural strength to the
     recipient by raising his Strength score by 1d4
     points or to a minimum of 16, whichever is
     higher.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 29, 2004
//:://////////////////////////////////////////////

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
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
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
	object  oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration+3) );
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 4;
    int     iNumDice        = 1;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iTargetStr      = GetAbilityScore(oTarget, ABILITY_STRENGTH);
	

	iDamage = HkApplyMetamagicVariableMods( d4(iNumDice), 4 * iNumDice );

    if(iTargetStr+iDamage<=16) iDamage=16-iTargetStr;   //  check whether to use die roll or minimum of 16
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis      = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eStrIncrease = EffectAbilityIncrease(ABILITY_STRENGTH, iDamage);
    effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink        = EffectLinkEffects(eStrIncrease,eDur);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_STRENGTH_OF_STONE, SPELL_BULLS_STRENGTH );

    SignalEvent(oTarget, EventSpellCastAt(oCaster,SPELL_STRENGTH_OF_STONE, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

    HkPostCast(oCaster);
}



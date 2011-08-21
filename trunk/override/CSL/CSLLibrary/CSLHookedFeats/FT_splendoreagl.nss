//::///////////////////////////////////////////////
//:: Splendor of Eagles
//:: sg_s2_spleneag.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Charm Domain Power
     Adds 4 to Charisma for 1 minute
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: February 24, 2004
//:://////////////////////////////////////////////

//#include "sg_i0_spconst"
//
//
//
// 
// void main()
// {
// /*
//   Spellcast Hook Code
//   Added 2003-06-20 by Georg
//   If you want to make changes to all spells,
//   check x2_inc_spellhook.nss to find out more
// 
// */
// 
//     if (!X2PreSpellCastCode())
//     {
//     // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
//         return;
//     }
// 
// // End of Spell Cast Hook
//     //Declare major variables
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP;
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
	//int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	
    int iCasterLevel=HkGetSpellPower(oCaster);
    object oTarget=oCaster;
    location lTarget;
    float fDuration=HkApplyDurationCategory(1, SC_DURCATEGORY_MINUTES);
    fDuration = HkApplyMetamagicDurationMods( fDuration );
    int iDC=GetSpellSaveDC();
    int iResist;
    int iMetamagic=HkGetMetaMagicFeat();

    //spell variables
    /*int iDieType;
    int iNumDice;*/
    int iBonus=4;
    /*int iDamage;*/


    //resolve metamagic
    /*if(iMetamagic==METAMAGIC_EXTEND)
    {
        fDuration*=2;
    }*/
    //iDamage=MaximizeOrEmpower(iDieType,iNumDice,iMetamagic,iBonus);

    //effects

    //Apply effects
    effect eRaise;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Set Adjust Ability Score effect
    eRaise = EffectAbilityIncrease(ABILITY_CHARISMA, iBonus);
    effect eLink = EffectLinkEffects(eRaise, eDur);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_SG_SPLENDOR_OF_EAGLES, FALSE));
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}




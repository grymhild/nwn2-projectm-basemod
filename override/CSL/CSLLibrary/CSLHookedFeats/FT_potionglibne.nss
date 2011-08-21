//::///////////////////////////////////////////////
//:: Potion of Glibness
//:: sg_s3_glibness.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    This potion enables the imbiber to speak fluently and even
    to tell lies smoothly, believabley, and undetectably for 1 hour
    (add +30 to Bluff checks).

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: December 6, 2004
//:://////////////////////////////////////////////

//#include "sg_i0_spconst"
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
// 
// 
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
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = 0;
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
	//int iSpellPower = HkGetCasterLevel(oCaster);
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
    //int   iSpellPower = HkGetSpellPower(oCaster);
    object oTarget = HkGetSpellTarget();
    //location lTarget; // = HkGetSpellTargetLocation();
    //int   iDC = GetSpellSaveDC();
    //int   iMetamagic = HkGetMetaMagicFeat();
    float     fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS);
    fDuration = HkApplyMetamagicDurationMods( fDuration );
    //int   iDieType = 0;
    //int   iNumDice = 0;
    //int   iBonus = 0;
    //int   iDamage = 0;
    //float fRadius;    // = RADIUS_SIZE_LARGE;


    //resolve metamagic
    //if(iMetamagic==METAMAGIC_EXTEND) fDuration *= 2;
    //iDamage=MaximizeOrEmpower(iDieType,iNumDice,iMetamagic,iBonus);

    //effects
    effect eImpVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eBluffInc = EffectSkillIncrease(SKILL_BLUFF, 30);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, GetSpellId());
    
    
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBluffInc, oTarget, fDuration);
}



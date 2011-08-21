//::///////////////////////////////////////////////
//:: Halfling Domain Power
//:: sg_s2_halfdom.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Add Charisma bonus to hide and skill checks.
     10 minute duration
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 11, 2004
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
    //object    oTarget;    // = HkGetSpellTarget();
    //location lTarget; // = HkGetSpellTargetLocation();
    //int   iDC = GetSpellSaveDC();
    //int   iResist;    // = MyResistSpell(oCaster,oTarget);
    //int   iMetamagic = HkGetMetaMagicFeat();
    float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory( 1, SC_DURCATEGORY_MINUTES) );
    //int   iDieType = 0;
    //int   iNumDice = 0;
    int iBonus = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    //int   iDamage = 0;
    //float fRadius;    // = RADIUS_SIZE_LARGE;


    //resolve metamagic
    //if(iMetamagic==METAMAGIC_EXTEND) fDuration *= 2;
    //iDamage=MaximizeOrEmpower(iDieType,iNumDice,iMetamagic,iBonus);

    //effects
    effect eImpVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eHideBonus = EffectSkillIncrease(SKILL_HIDE, iBonus);
    effect eMoveBonus = EffectSkillIncrease(SKILL_MOVE_SILENTLY, iBonus);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHideBonus, eMoveBonus);
    eLink = EffectLinkEffects(eDur, eLink);
    effect ePower = ExtraordinaryEffect(eLink);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //Apply effects
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELLABILITY_SG_HALFLING_DOMAIN_POWER, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePower, oCaster, fDuration);
}


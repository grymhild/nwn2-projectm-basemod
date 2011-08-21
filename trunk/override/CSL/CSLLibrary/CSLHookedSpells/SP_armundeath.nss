//::///////////////////////////////////////////////
//:: Armor of Undeath
//:: sg_s0_armund.nss
//:: 2002 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     creates magical armor from remains of a humanoid
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 24, 2003
//:://////////////////////////////////////////////
// 
// #include "sg_inc_effects"
//
// 
// 
// void main()
// {
// 
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
//     //int     iDieType        = 0;
    //int     iNumDice        = 0;
    //int     iBonus          = 0;
    //int     iDamage         = 0;
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
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
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    int     iGoodEvil       = GetAlignmentGoodEvil(oTarget);
    
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eArmorCheck  = EffectArmorCheckPenaltyIncrease(oTarget, 1 );
    /* This part is to attach heartbeat script to spell to see how much damage the
       caster has taken each round to remove the spell when 25hp dmg has occurred. */
    effect eAOE         = EffectAreaOfEffect(AOE_MOB_ARMOR_UNDEATH, "", "", "", sAOETag);
    effect eImp         = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eImp1        = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eImpact      = EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM);
    effect eACImp       = EffectACIncrease(2,AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eTempHP      = EffectTemporaryHitpoints(25);
    effect eImpLink     = EffectLinkEffects(eImp,eImp1);

    effect eLink        = EffectLinkEffects(eACImp,eTempHP);
    eLink = EffectLinkEffects(eArmorCheck,eLink);
    eLink = EffectLinkEffects(eAOE,eLink);

	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ARMOR_UNDEATH ) || GetLocalInt(oTarget,"ARMUND_HP"))
    {
        DeleteLocalInt(oTarget, "ARMUND_HP");
        DeleteLocalInt(oTarget, "ARMUND_USED");
    }
	
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ARMOR_UNDEATH, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
    DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpLink, oTarget));
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    SetLocalInt(oTarget,"ARMUND_HP",GetCurrentHitPoints());

    if(iGoodEvil==ALIGNMENT_GOOD) {
        AdjustAlignment(oTarget, ALIGNMENT_EVIL, 1);
    }

    HkPostCast(oCaster);
}



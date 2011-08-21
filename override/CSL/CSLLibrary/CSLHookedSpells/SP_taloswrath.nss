//::///////////////////////////////////////////////
//:: Talos' Wrath
//:: SG_S0_TalWrath.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     This spell creates a column of raging electrical
     energy at a target specified by the caster for a
     duration of 1 round for every 6 levels of the caster.
     Targets caught within the area of effect suffer
     1d6 pts of damage (up to 15d6 max).
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////
//:: Edited On: October 3, 2003
//:://////////////////////////////////////////////
// #include "sg_inc_elements"
//
//
// 
// void main()
// {
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
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
	int iSpellId = SPELL_TALOS_WRATH; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster, 15 );
	
	//int iCasterLevel = HkGetCasterLevel(oCaster);
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration/6) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	
	
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	

    location lRgtLocation = CSLGenerateNewLocationFromLocation(lTarget, SC_DISTANCE_SHORT,CSLGetRightDirection(GetFacing(oCaster)), GetFacing(oCaster));
    location lLftLocation = CSLGenerateNewLocationFromLocation(lTarget, SC_DISTANCE_SHORT, CSLGetLeftDirection(GetFacing(oCaster)), GetFacing(oCaster));
    location lFrtLocation = CSLGenerateNewLocationFromLocation(lTarget, SC_DISTANCE_SHORT, GetFacing(oCaster), GetFacing(oCaster));
    location lBckLocation = CSLGenerateNewLocationFromLocation(lTarget, SC_DISTANCE_SHORT, CSLGetOppositeDirection(GetFacing(oCaster)), GetFacing(oCaster));
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_PER_TALOS_WRATH, "", "", "", sAOETag);
    //effect eImp = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
    //effect eImp2= EffectVisualEffect(VFX_IMP_DOOM);
    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    //effect eDam;
    //effect eLink;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget);

    //HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
	
	
	DelayCommand( 0.5f, SetLocalLocation( GetObjectByTag( sAOETag ), "MY_LOC", lTarget ) );
	//DelayCommand( 0.5f, SetLocalLocation( GetObjectByTag( sAOETag ), "MY_RGT_LOC", lRgtLocation ) );
	//DelayCommand( 0.5f, SetLocalLocation( GetObjectByTag( sAOETag ), "MY_LFT_LOC", lLftLocation ) );
	//DelayCommand( 0.5f, SetLocalLocation( GetObjectByTag( sAOETag ), "MY_FRT_LOC", lFrtLocation ) );
	//DelayCommand( 0.5f, SetLocalLocation( GetObjectByTag( sAOETag ), "MY_BCK_LOC", lBckLocation ) );
	//DelayCommand( 0.5f, SetLocalInt( GetObjectByTag( sAOETag ), "CSL_ENVIRO", CSL_ENVIRO_HOLY ) );
	
    HkPostCast(oCaster);
}



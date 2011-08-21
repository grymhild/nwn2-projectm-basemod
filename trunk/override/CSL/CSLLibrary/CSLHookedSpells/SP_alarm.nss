//::///////////////////////////////////////////////
//:: Alarm
//:: SG_S0_Alarm.nss
//:: 2002 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    Sounds a mental alarm upon any creature entering
    the warded area.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: Dec 19, 2002
//:://////////////////////////////////////////////
//:: Edited On: October 6, 2003
//:://////////////////////////////////////////////
/*
    Changed to include spell helper object and array-like
    list to track multiple alarms.
*/
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
// 
// #include "sg_inc_elements"
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	
	// float fDuration = HkApplyMetamagicDurationMods(HkApplyDurationCategory(nCasterLevel, SC_DURCATEGORY_MINUTES));
	// float fDuration = HkApplyMetamagicDurationMods(HkApplyDurationCategory(nCasterLevel, SC_DURCATEGORY_MINUTES));
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, TRUE  );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_PER_ALARM, "SP_alarma","****","SP_alarmb", sAOETag);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);

    if(GetIsPC(oCaster))
    {
        SendMessageToPC(oCaster,"Alarm successfully placed.");
	}

    HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: Fog Cloud
//:: sg_s0_fogcloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a cloud of fog that is indistinguishable from
    cloudkill, but is harmless.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
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
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*10, SC_DURCATEGORY_MINUTES ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGCLOUD, "", "", "", sAOETag);
    effect eImpact = EffectVisualEffect(258);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
    
    HkPostCast(oCaster);
}



//::///////////////////////////////////////////////
//:: Cloud of Bewilderment
//:: X2_S0_CldBewld
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A cone of noxious air goes forth from the caster.
	Enemies in the area of effect are stunned and blinded
	1d6 rounds. Foritude save negates effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: November 04, 2002
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_cloudbewilde();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CLOUD_OF_BEWILDERMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_POISON|SCMETA_DESCRIPTOR_GAS, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	//Declare major variables
	
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect( AOE_PER_FOG_OF_BEWILDERMENT, "", "", "", sAOETag);
	
	effect eImpact = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Create the AOE object at the selected location
	DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	
	HkPostCast(oCaster);
}


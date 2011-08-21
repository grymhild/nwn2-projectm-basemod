//::///////////////////////////////////////////////
//:: Spike Growth
//:: x0_s0_spikegro.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All creatures within the AoE take 1d4 points of damage
	every round.
	If you are in the area of the effect, you also get a 24 hour slow
	effect on you (will only add one)
	
	Lasts 1 hour/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Transmutation"

void main()
{
	//scSpellMetaData = SCMeta_SP_spikegrowth();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPIKE_GROWTH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_TRANSMUTATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
	int iSpellPower = HkGetSpellPower( oCaster );
	
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	//Declare major variables including Area of Effect Object
	// * passing dirge script for exit because it is an empty script (i.e., there is no special exit effects)
	effect eAOE = EffectAreaOfEffect(AOE_PER_SPIKE_GROWTH, "", "", "", sAOETag);
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Create an instance of the AOE Object using the Apply Effect function
	DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: GreaterWildShape III - Drider Darkness Ability
//:: x2_s2_driderdark
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

	Drider Darkness Ability for polymorph type
	drider

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 07, 2003
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Polymorph"
void main()
{
	//scSpellMetaData = SCMeta_FT_gwildshapedr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	// Enforce artifical use limit on that ability
	//--------------------------------------------------------------------------
	if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
	{
			FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
			return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	int iDuration = 6;
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );

	//--------------------------------------------------------------------------
	// Create an darkness AOE object for 6 rounds
	//--------------------------------------------------------------------------
	effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS, "", "", "", sAOETag);
	location lTarget = HkGetSpellTargetLocation();
	
	DelayCommand( 0.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration ) );
	
	HkPostCast(oCaster);
}
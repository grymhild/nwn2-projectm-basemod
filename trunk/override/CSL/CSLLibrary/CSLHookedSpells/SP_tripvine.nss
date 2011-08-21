//::///////////////////////////////////////////////
//:: Trip Vine
//:: cmi_s0_tripvine
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Trip Vine
//:: Transmutation
//:: Level: Druid 2, Ranger 2
//:: Components: VS
//:: Range: Medium
//:: Area: 20-ft.-radius
//:: Duration: 3 minutes
//:: Saving Throw: Reflex negates
//:: Spell Resistance: No
//:: Trip vine causes plants within the area to grow together to form a tangle.
//:: Any creature entering or within the affected area must succeed on a Reflex
//:: save or be knocked down.
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TRIP_VINE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(3, SC_DURCATEGORY_MINUTES) );
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect(VFX_PER_TRIP_VINE, "", "", "", sAOETag);

	location lTarget = HkGetSpellTargetLocation();

	//Create an instance of the AOE Object using the Apply Effect function
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration );
	
	HkPostCast(oCaster);
}
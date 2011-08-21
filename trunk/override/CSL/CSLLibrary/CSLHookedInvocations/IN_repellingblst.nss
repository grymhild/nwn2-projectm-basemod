//::///////////////////////////////////////////////
//:: Repelling Blast
//:: cmi_s0_repellblst
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:: Repelling Blast
//:: Invocation Type: Greater; Eldritch Essence
//:: Spell Level Equivalent: 6
//:: This eldritch essence invocation allows you to change your eldritch blast
//:: into a repelling blast. Anyone failing a Reflex save is knocked down for 4
//:: seconds.
//:: NOTE: This blast is a point-blank area-of-effect blast centered on the
//:: caster that only affects hostiles and requires a ranged touch attack to
//:: hit.
//:://////////////////////////////////////////////
// const int SPELL_I_REPELL_BLAST = 2086;



#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_REPELL_BLAST;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	DoShapeMetaDoom(oCaster,METAMAGIC_INVOC_REPELL_BLAST);
	
	HkPostCast(oCaster);

}
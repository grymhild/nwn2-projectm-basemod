//::///////////////////////////////////////////////
//:: Undead Bane Blast
//:: cmi_s0_undbaneblst
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Undead Baneful Blast
//:: Invocation Type: Lesser; Eldritch Essence
//:: Spell Level Equivalent: 3
//:: This eldritch essence invocation allows you to change your eldritch blast
//:: into an undead bane blast. Undead take an additional +2d6 damage from this
//:: essence.
//:: NOTE: This blast is a point-blank area-of-effect blast centered on the
//:: caster that only affects hostiles and requires a ranged touch attack to
//:: hit.
//:://////////////////////////////////////////////
// const int SPELL_I_UNDEADBANEBLST = 2077;


#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_UNDEADBANEBLST;
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
	
	DoShapeMetaDoom(oCaster, METAMAGIC_INVOC_UNDBANE_BLAST);
	
	HkPostCast(oCaster);
}
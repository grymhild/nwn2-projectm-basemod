//::///////////////////////////////////////////////
//:: Hellspawned Grace
//:: cmi_s0_hellgrace
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Hellspawned Grace
//:: Invocation Type: Greater;
//:: Spell Level Equivalent: 6
//:: You take on the form and statistics of an agile hellhound for a number of
//:: rounds equal to your invocation caster level. This is a polymorph effect.
//:: 
//:: Hellhound statistics
//:: Speed: Fast
//:: AC: +7 Natural AC
//:: Melee: 2 claws (d8), 1 bite (2d8)
//:: Special Qualities: Damage Reduction: 5/Good, Darkvision, Improved
//:: Invisibility, Resistance to fire 10, Blind-Fight, Spell Resistance 19,
//:: Dodge, Improved Initiative, and 50% concealment.
//:: Abilities: Str 23, Dex 21, Con 17
//:://////////////////////////////////////////////
// const int SPELL_I_HELLSPAWNGRACE = 2070;




#include "_HkSpell"
#include "_SCInclude_Invocations"
#include "_SCInclude_Polymorph"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_HELLSPAWNGRACE;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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

	int iDuration = HkGetSpellDuration( oCaster, 30 )/2;
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	// SendMessageToPC( oCaster, "Hell Grace");
	PolyMerge(oCaster, iSpellId, fDuration);
		
	HkPostCast(oCaster);
}
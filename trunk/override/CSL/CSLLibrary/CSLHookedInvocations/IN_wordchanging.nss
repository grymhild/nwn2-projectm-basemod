//:://///////////////////////////////////////////////
//:: Warlock Dark Invocation: Word of Changing
//:: nw_s0_iwordchng.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
/*
		Word of Changing   Complete Arcane, pg. 136
		Spell Level:      2
		Class:            Misc

		This invocation is the equivalent of the
		shapechange spell (9th level wizard).

		[Rules Note] In the rules this invocation is
		the equivalent of the baleful polymorph spell.
		That spell isn't in NWN2, so shapechange is used
		instead.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"
#include "_SCInclude_Polymorph"

void main()
{
	//scSpellMetaData = SCMeta_IN_wordchanging();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_WORD_OF_CHANGING;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	// SendMessageToPC( oCaster, "Word of Changing");
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	
	PolyMerge(oCaster, iSpellId, fDuration);
		
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Silence: On Enter
//:: NW_S0_SilenceC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target is surrounded by a zone of silence
	that allows them to move without sound.  Spell
	casters caught in this area will be unable to cast
	spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	
	// 	//--------------------------------------------------------------------------
	// 	//Prep the spell
	// 	//--------------------------------------------------------------------------
	// 	int iSpellId = SPELL_SILENCE;
	// 	int iClass = CLASS_TYPE_NONE;
	// 	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	// 	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_GLAMER );
	// 	
	// 	//--------------------------------------------------------------------------
	// 	//Declare major variables
	// 	//--------------------------------------------------------------------------
	// 	
	
}
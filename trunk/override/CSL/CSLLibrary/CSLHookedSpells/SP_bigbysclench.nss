//::///////////////////////////////////////////////
//:: Bigby's Clenched Fist
//:: [x0_s0_bigby4]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Does an attack EACH ROUND for 1 round/level.
	If the attack hits does
	1d8 +12 points of damage

	Any creature struck must make a FORT save or
	be stunned for one round.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Evocation"

void main()
{
	//scSpellMetaData = SCMeta_SP_bigbysclench();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BIGBYS_CLENCHED_FIST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	SCBigHands( iSpellId );
	
	HkPostCast(oCaster);
}


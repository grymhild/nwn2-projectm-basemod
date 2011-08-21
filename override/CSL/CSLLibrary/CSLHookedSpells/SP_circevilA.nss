//::///////////////////////////////////////////////
//:: Magic Cirle Against Evil
//:: NW_S0_CircEvilA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Add basic protection from evil effects to
	entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"


void main()
{
	//scSpellMetaData = SCMeta_SP_circevil(); //SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_MAGIC_CIRCLE_AGAINST_EVIL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_GOOD, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster)) {
		effect eLink = SCCreateProtectionFromAlignmentLink(ALIGNMENT_EVIL);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MAGIC_CIRCLE_AGAINST_EVIL, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
}
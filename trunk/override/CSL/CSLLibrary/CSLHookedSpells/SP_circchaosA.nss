//::///////////////////////////////////////////////
//:: Magic Cirle Against Chaos
//:: NW_S0_CircchoasA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Add basic protection from chaos effects to
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
	//scSpellMetaData = SCMeta_SP_circchaos(); //SPELL_MAGIC_CIRCLE_AGAINST_CHAOS;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_MAGIC_CIRCLE_AGAINST_CHAOS;
	int iClass = CLASS_TYPE_NONE;

	int iSpellLevel = 3;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_LAW, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
	{
		effect eLink = SCCreateProtectionFromAlignmentLink(ALIGNMENT_CHAOTIC);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MAGIC_CIRCLE_AGAINST_CHAOS, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
}
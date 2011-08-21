//::///////////////////////////////////////////////
//:: Dragon Knight
//:: X2_S2_DragKnght
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
		Summons an adult red dragon for you to
		command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////
#include "x2_inc_toollib"

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_SP_dragonknight();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_DRAGON_KNIGHT;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	



	//Declare major variables
	int iDuration = 20;
	effect eSummon;
	effect eVis = EffectVisualEffect(460);
	eSummon = EffectSummonCreature("csl_sum_dragon_redancient",481,0.0f,TRUE);
	
	
	// * make it so dragon cannot be dispelled
	eSummon = ExtraordinaryEffect(eSummon);
	//Apply the summon visual and summon the dragon.
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,HkGetSpellTargetLocation(), HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	DelayCommand(1.0f,HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,HkGetSpellTargetLocation()));
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	
	HkPostCast(oCaster);
}


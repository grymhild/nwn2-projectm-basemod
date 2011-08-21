//::///////////////////////////////////////////////
//:: Mummy Dust
//:: X2_S2_MumDust
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
		Summons a strong warrior mummy for you to
		command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_SP_mummydust();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_MUMMY_DUST;
	int iClass = CLASS_TYPE_NONE;
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
	int iDuration = 24;
	//effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
	effect eSummon;
	//Summon the appropriate creature based on the summoner level
	//Warrior Mummy
	eSummon = EffectSummonCreature("csl_sum_undead_mummy3",496,1.0f);
	eSummon = ExtraordinaryEffect(eSummon);
	//Apply the summon visual and summon the undead.
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, HkGetSpellTargetLocation());
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	DelayCommand(6.0f, BuffSummons(OBJECT_SELF));
	
	HkPostCast(oCaster);
}


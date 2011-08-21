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

/*
	Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/
//#include "prc_alterations"
//#include "inc_epicspells"

#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_SCInclude_Summon"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_DRG_KNI;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DRG_KNI))
	{
		
		int nDuration = 20;
		effect eSummon;
		effect eVis = EffectVisualEffect(460);
		eSummon = EffectSummonCreature("csl_sum_dragon_redancient",481,0.0f,TRUE);

		// * make it so dragon cannot be dispelled
		eSummon = ExtraordinaryEffect(eSummon);
		//Apply the summon visual and summon the dragon.
		CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,HkGetSpellTargetLocation(), RoundsToSeconds(nDuration));
		DelayCommand(1.0f,HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,HkGetSpellTargetLocation()));
	}
	HkPostCast(oCaster);
}



//:://////////////////////////////////////////////
//:: FileName: "ss_ep_unholydisc"
/* 	Purpose: Unholy Disciple
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
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
	int iSpellId = SPELL_EPIC_UNHOLYD;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_UNHOLYD))
	{
		effect eSummon;
		eSummon = EffectSummonCreature("unholy_disciple",496,1.0f);
		eSummon = ExtraordinaryEffect(eSummon);
		if (GetAlignmentGoodEvil(OBJECT_SELF) != ALIGNMENT_GOOD)
		{
			//Apply the summon visual and summon the disciple.
			CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, HkGetSpellTargetLocation());
		}
		else
			SendMessageToPC(OBJECT_SELF, "You must be non-good to summon an unholy disciple.");
	}
	HkPostCast(oCaster);
}



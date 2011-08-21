//:://////////////////////////////////////////////
//:: FileName: "ss_ep_summonaber"
/* 	Purpose: Summon Aberration - summons a semi-random aberration for 20 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
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
	int iSpellId = SPELL_EPIC_SUMABER;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_SUMABER))
	{
		effect eSummon;
		float fDuration = HoursToSeconds(20);
		int nX = d10();
		switch (nX)
		{
			case 1:
			case 2:
			case 3: eSummon = EffectSummonCreature("csl_sum_aber_choker",496,1.0f);
				break;
			case 4:
			case 5:
			case 6: eSummon = EffectSummonCreature("csl_sum_aber_carrion",496,1.0f);
				break;
			case 7:
			case 8: eSummon = EffectSummonCreature("csl_sum_aber_minotaur",496,1.0f);
				break;
			case 9: eSummon = EffectSummonCreature("csl_sum_aber_umber",496,1.0f);
				break;
			case 10: eSummon = EffectSummonCreature("csl_sum_aber_drider",496,1.0f);
		}
		eSummon = ExtraordinaryEffect(eSummon);
		//Apply the summon visual and summon the aberration.
		CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon,
			HkGetSpellTargetLocation(), fDuration);
	}
	HkPostCast(oCaster);
}



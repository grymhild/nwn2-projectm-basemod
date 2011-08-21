//:://////////////////////////////////////////////
//:: FileName: "ss_ep_rainoffire"
/* 	Purpose: Rain of Fire - AoE spell that lasts 20 hours and does 3d6 points
		of fire damage per round to all in the AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "x2_inc_spellhook"

int VFX_PER_RAIN_OF_FIRE = 100;


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_RAINFIR;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_RAINFIR))
	{
		effect eAOE = EffectAreaOfEffect(VFX_PER_RAIN_OF_FIRE);
		location lTarget = GetLocation(OBJECT_SELF);
		int nDuration = 20;
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
			eAOE, lTarget, HoursToSeconds(nDuration));
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
			eAOE, lTarget, HoursToSeconds(nDuration));
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
			eAOE, lTarget, HoursToSeconds(nDuration));
	}
	HkPostCast(oCaster);
}


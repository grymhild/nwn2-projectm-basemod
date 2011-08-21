//:://////////////////////////////////////////////
//:: FileName: "ss_ep_epicrepuls"
/* 	Purpose: Epic Repulsion - repel a specific creature type for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "x2_inc_spellhook"



#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_EP_RPLS;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_EP_RPLS))
	{
		object oTarget = HkGetSpellTarget();
		location lTarget = GetLocation(oTarget);
		effect eVis = EffectVisualEffect(VFX_FNF_PWSTUN);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
		SetLocalObject(OBJECT_SELF, "oRepulsionTarget", oTarget);
		AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF,
			"ss_ep_repulsion", TRUE, FALSE));
	}
	HkPostCast(oCaster);
}

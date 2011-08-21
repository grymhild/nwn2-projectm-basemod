//:://////////////////////////////////////////////
//:: FileName: "ss_ep_continreun"
/* 	Purpose: Contingent Reunion - upon casting this at a target, the caster
		must choose a condition which will later trigger the teleportation to
		the target.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
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
	int iSpellId = SPELL_EPIC_CON_REU;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_CON_REU))
	{
		// Is the target a place, creature, or object?
		object oTarget = HkGetSpellTarget();
		location lTarget = HkGetSpellTargetLocation();
		effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
		if (oTarget != OBJECT_INVALID)
		{
			if (oTarget == OBJECT_SELF) // If target is self, becomes location
			{
				SetLocalLocation(OBJECT_SELF, "lSpellTarget", lTarget);
				SetLocalObject(OBJECT_SELF, "oSpellTarget", OBJECT_INVALID);
			}
			else
			{
				SetLocalObject(OBJECT_SELF, "oSpellTarget", oTarget);
				if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
				SetLocalInt(OBJECT_SELF, "nMyTargetIsACreature", TRUE);
			}
		}
		else
		{
			SetLocalLocation(OBJECT_SELF, "lSpellTarget", lTarget);
			SetLocalObject(OBJECT_SELF, "oSpellTarget", OBJECT_INVALID);
		}
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
		AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF,
			"ss_cont_reunion", TRUE, FALSE));
	}
	HkPostCast(oCaster);
}


// The error code 5 prevention entry. Comment out or uncomment as necessary.
//Part Deux, Primogenitor 05/07/05
//const int COMPILER_BREAKS_ON_ME_OR_NOT_AGAIN = 0xffffffff;

//:://////////////////////////////////////////////
//:: FileName: "ss_ep_alliedmart"
/* 	Purpose: Allied Martyr - The subject of this spell willingly allows all
		damage suffered by the caster to be transfered to the subject.
		NOTE: It is ASSUMED that any NPC partymember is automatically willing.
			Other party members who are actual players will have a conversation
			pop up where they are asked if they are willing to let it happen.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "inc_dispel"
//#include "x2_inc_spellhook"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_AL_MART;
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

	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_AL_MART))
	{
		object oTarget = HkGetSpellTarget();
		// Twice per round, for 20 hours.
		int nDuration = FloatToInt(HoursToSeconds(20) / 3);
		// Is the target an ally (in the caster's party)?
		effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
		if (GetFactionEqual(oTarget, OBJECT_SELF))
		{
			SetLocalObject(oTarget, "oAllyForMyMartyrdom", OBJECT_SELF);
			SetLocalString(oTarget,
				"sAllyForMyMartyrdom", GetName(OBJECT_SELF));
			SetLocalInt(oTarget, "nTimeForMartyrdomFor", nDuration);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
			// Is the party member another player?
			if (GetIsPC(oTarget))
			{
				//We have to get the player's permission for this.
				// A "Yes" from the player will use ActionTaken to run script.
				AssignCommand(oTarget, ActionStartConversation(OBJECT_SELF,
				"ss_alliedmartyr", TRUE, FALSE));
			}
			// The party member is NOT a player.
			else
			{
				ExecuteScript("run_all_martyr", oTarget);
			}

		}
	}
	HkPostCast(oCaster);
}

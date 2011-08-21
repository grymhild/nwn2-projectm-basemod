//:://////////////////////////////////////////////
//:: FileName: "ss_ep_spellworm"
/* 	Purpose: Spell Worm - the target loses one spell slot of his/her highest
		available level at the rate of 1 per round, for 20 hours, or until the
		target has no remaining spell slots available.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "x2_inc_spellhook"
//#include "prc_getbest_inc"

void RunWorm(object oTarget, int nRoundsRemaining);


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_SP_WORM;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_SP_WORM))
	{
		object oTarget = HkGetSpellTarget();
		int nDuration = FloatToInt(HoursToSeconds(20) / 6);
		effect eVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
			oTarget != OBJECT_SELF)
		{
			if (GetLocalInt(oTarget, "sSpellWormActive") != TRUE)
			{
				//Make SR check
				if (!HkResistSpell(OBJECT_SELF, oTarget))
				{
					//Make Will save
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget),
					SAVING_THROW_TYPE_MIND_SPELLS))
					{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						SetLocalInt(oTarget, "sSpellWormActive", TRUE);
						RunWorm(oTarget, nDuration);
					}
				}
			}
		}
	}
	HkPostCast(oCaster);
}

void RunWorm(object oTarget, int nRoundsRemaining)
{
	int nSpell = CSLGetBestAvailableSpell(oTarget);
	if (nSpell != 99999)
	{
		DecrementRemainingSpellUses(oTarget, nSpell);
		nRoundsRemaining -= 1;
	}
	if (nRoundsRemaining > 0)
		DelayCommand(6.0, RunWorm(oTarget, nRoundsRemaining));
	if (nSpell == 99999 || nRoundsRemaining < 1)
		SetLocalInt(oTarget, "sSpellWormActive", FALSE);
}

//:://////////////////////////////////////////////
//:: FileName: "ss_ep_dweomerthf"
/* 	Purpose: Dweomer Thief - the target loses a spell from the highest level,
		which subsequently turns into a scroll in the caster's inventory.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "x2_inc_spellhook"
//#include "prc_getbest_inc"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_DWEO_TH;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DWEO_TH))
	{
		object oTarget = HkGetSpellTarget();
		int nTargetSpell;
		effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);
		effect eVis2 = EffectVisualEffect(VFX_IMP_DOOM);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && oTarget != OBJECT_SELF)
		{
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget)+5, SAVING_THROW_TYPE_NONE))
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
					nTargetSpell = CSLGetBestAvailableSpell(oTarget);
					if (nTargetSpell != 99999)
					{
						int nSpellIP = StringToInt(Get2DAString("des_crft_spells", "IPRP_SpellIndex", nTargetSpell));
						object oScroll = CreateItemOnObject("it_dweomerthief", OBJECT_SELF);
						AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyCastSpell(nSpellIP, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE), oScroll);
						DecrementRemainingSpellUses(oTarget, nTargetSpell);
					}
				}
			}
		}
	}
	HkPostCast(oCaster);
}


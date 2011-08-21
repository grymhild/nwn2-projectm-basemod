//:://////////////////////////////////////////////
//:: FileName: "ss_ep_singsunder"
/* 	Purpose: Singular Sunder - spell target's an enemy's equipment, and
		irrevocably destroys a single item, on a failed will save.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"

object GetSunderTarget(object oTarget);


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_SINGSUN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_SINGSUN))
	{
		object oTarget = HkGetSpellTarget();
		effect eImp = EffectVisualEffect(VFX_IMP_BREACH);
		effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
		object oItem = GetSunderTarget(oTarget);
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
		// Does the target have an equipped item to sunder?
		if (oItem != OBJECT_INVALID)
		{
			// SR check.
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				// Will save.
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget)))
				{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				DestroyObject(oItem, 1.0);
				}
			}
		}
		else
			SendMessageToPC(OBJECT_SELF,
				"That creature has nothing equipped to sunder!");
	}
	HkPostCast(oCaster);
}

object GetSunderTarget(object oTarget)
{
	object oItem = OBJECT_INVALID;
	object oTemp;
	// Search for item hierarchy, lowest to highest priority, and non-plot.
	oTemp = GetItemInSlot(12, oTarget); // Bullets
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(13, oTarget); // Bolts
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(11, oTarget); // Arrows
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(7, oTarget); // Left ring
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(8, oTarget); // Right ring
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(0, oTarget); // Helmet
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(10, oTarget); // Belt
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(2, oTarget); // Boots
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(6, oTarget); // Cloak
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(9, oTarget); // Neck
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(3, oTarget); // Arms (gauntlets)
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(5, oTarget); // Left (off) hand
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(1, oTarget); // Armor
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	oTemp = GetItemInSlot(4, oTarget); // Right (main) hand
	if (oTemp != OBJECT_INVALID && !GetPlotFlag(oTemp)) oItem = oTemp;
	return oItem;
}


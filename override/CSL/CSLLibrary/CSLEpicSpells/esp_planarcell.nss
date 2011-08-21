//:://////////////////////////////////////////////
//:: FileName: "ss_ep_planarcell"
/* 	Purpose: Planar Cell - You must cast this spell on the ground somewhere to
		assign a "Cell" location. Then you can cast it on creatures to teleport
		them to the cell, even across the planes.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"

#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_PLANCEL;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_PLANCEL))
	{
		object oTarget = HkGetSpellTarget();
		location lTarget = HkGetSpellTargetLocation();
		location lCell;
		effect eVis1 = EffectVisualEffect(VFX_FNF_IMPLOSION);
		effect eVis2 = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
		// If there is a cell location, and the target is a valid creature.
		if (GetLocalInt(OBJECT_SELF, "nHasPlanarCell") == TRUE &&
			oTarget != OBJECT_INVALID &&
			oTarget != OBJECT_SELF &&
			!GetIsDM(oTarget))
		{
			lCell = GetLocalLocation(OBJECT_SELF, "lPlanarCell");
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget)))
				{
				HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis1, lTarget);
				HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget);
				DelayCommand(1.0,
					AssignCommand(oTarget, JumpToLocation(lCell)));
				DelayCommand(1.0,
					AssignCommand(oTarget, ActionDoCommand(ClearAllActions(TRUE))));
				DelayCommand(1.0,
					HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis1, lCell));
				DelayCommand(1.0,
					HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lCell));
				}
			}
		}
		// If no cell location known, or the target is not a creature,
		// 	assign the target location as the cell.
		if (GetLocalInt(OBJECT_SELF, "nHasPlanarCell") != TRUE &&
			oTarget == OBJECT_INVALID)
		{
			SetLocalInt(OBJECT_SELF, "nHasPlanarCell", TRUE);
			SetLocalLocation(OBJECT_SELF, "lPlanarCell", lTarget);
			SendMessageToPC(OBJECT_SELF, "The planar cell is prepared.");
			SendMessageToPC(OBJECT_SELF,
				"You can now teleport creatures to the cell's location.");
		}
		// If the target is yourself, delete the planar cell's location.
		if (GetLocalInt(OBJECT_SELF, "nHasPlanarCell") == TRUE &&
			oTarget == OBJECT_SELF)
		{
			SetLocalInt(OBJECT_SELF, "nHasPlanarCell", FALSE);
			DeleteLocalLocation(OBJECT_SELF, "lPlanarCell");
			SendMessageToPC(OBJECT_SELF,
				"The planar cell's location is lost.");
			SendMessageToPC(OBJECT_SELF,
				"You must prepare a new cell to teleport creatures to.");
		}
	}
	HkPostCast(oCaster);
}

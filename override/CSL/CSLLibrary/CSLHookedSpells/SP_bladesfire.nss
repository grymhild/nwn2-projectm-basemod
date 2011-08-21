//::///////////////////////////////////////////////
//:: Blades of Fire
//:: nx2_s0_blades_of_fire.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
		Blades of Fire
	Conjuration (Creation) [Fire]
	Level: Ranger 1, sorceror/wizard 1
	Components: V
	Range: Touch
	Targets: Up to two melee weapons you are weilding
	Duration: 2 rounds
	Saving throw: None
	Spell Resistance: None
	
	Your melee weapons each deal an extra 1d8 points of fire damage.
	This damage stacks with any energy damage your weapons already deal.

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_CSLCore_Items"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLADES_OF_FIRE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//SpawnScriptDebugger();
	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
	// Spell Duration
	float fDuration = RoundsToSeconds(2);
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	// Effects
	itemproperty ipFire = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
	
	//without this, one round is lost because caster can't attack in same round he cast the spell
	if (oTarget == oCaster)
	{
		fDuration += 6.0; 
	}
	
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// check to see if ally
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			// check to make sure right hand weapon is meleee and valid
			if(GetIsObjectValid(oRightHand) && CSLItemGetIsMeleeWeapon(oRightHand))
			{
				// fire it up, since it stacks with any energy damge no need for a safe add
				CSLSafeAddItemProperty(oRightHand, ipFire, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			// check to make sure left hand weapon is meleee and valid
			if(GetIsObjectValid(oLeftHand) && CSLItemGetIsMeleeWeapon(oLeftHand))
			{
				// fire it up, since it stacks with any energy damge no need for a safe add
				CSLSafeAddItemProperty(oLeftHand, ipFire, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
			}
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
	}
	HkPostCast(oCaster);	
}


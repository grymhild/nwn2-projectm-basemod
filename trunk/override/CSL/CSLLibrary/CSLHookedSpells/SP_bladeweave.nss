//::///////////////////////////////////////////////
//:: Bladeweave
//:: nx2_s0_bladeweave.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Bladeweave
	Illusion [Pattern]
	Level: Bard 2, Wizard/Sorcerer 2
	Components: V
	Range: Personal
	Target: You
	Duration: 1 round/level
	Saving Thow: See Text
	Spell Resistance: See text
	
	For the duration of the spell, your weapon gains the ability to daze opponents who fail their will save for one round.
	The save is calculated based on the caster's abilities.

	*NOTE* Currently the save is set at 16, need further support to make save based on caster level.
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
	int iSpellId = SPELL_BLADEWEAVE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	object oWeapon = CSLGetTargetedOrEquippedMeleeWeapon();
	object oTarget = GetItemPossessor(oWeapon);
	// Spell Duration
	float fDuration = RoundsToSeconds(HkGetSpellDuration(oCaster));
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	// Effects
	itemproperty ipDaze = ItemPropertyOnHitProps(IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_16, IP_CONST_ONHIT_DURATION_100_PERCENT_1_ROUND);
	effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_BLADEWEAVE);
	
	// Make sure spell target is valid
	if (!GetIsObjectValid(oWeapon))
	{
		SendMessageToPC(oCaster, GetStringByStrRef(228878) ); // Weapon is Invalid: Bladeweave will have no effect!
		return;
	}
	else
	{
		CSLSafeAddItemProperty(oWeapon, ipDaze, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
		//Fire cast spell at event for the specified target
		SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	}
	
	HkPostCast(oCaster);
}


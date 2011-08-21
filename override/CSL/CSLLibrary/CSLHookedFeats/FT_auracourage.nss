//::///////////////////////////////////////////////
//:: Aura of Courage
//:: NW_S2_CourageA.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Paladin ability.  Grants +4 morale bonus on saves
	vs. fear effects to all allies within 10'.  The
	paladin herself gains an immunity to fear that's
	implemented in the code.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/30/2006
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_FT_auracourage();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	object oTarget = HkGetSpellTarget();
	
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, -iSpellId, iSpellPower, -1.0f, FALSE  );
	
	CSLRemoveAuraById( oTarget, SPELLABILITY_AURA_OF_COURAGE );
	// Strip any Protective Auras first
	//SCRemoveSpellEffects(SPELLABILITY_AURA_OF_COURAGE, OBJECT_SELF, oTarget);
	
	// AFW-OEI 08/30/2006: Only apply effects if you don't already have them.
	// The SCRemoveSpellEffects brute-force call was causing problems with effect icons.
	//if (!GetHasSpellEffect(SPELLABILITY_AURA_OF_COURAGE, OBJECT_SELF))
	//{
	effect eAOE = EffectAreaOfEffect(AOE_PER_AURA_OF_COURAGE, "", "", "", sAOETag);
	eAOE = ExtraordinaryEffect(eAOE);
	eAOE = SetEffectSpellId(eAOE, -iSpellId);
	
		//Create an instance of the AOE Object using the Apply Effect function
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_AURA_OF_COURAGE, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget);
	//}
	
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Protective Aura
//:: NW_S2_ProtAura.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Grants a bonus to saves and AC to allies within
	the spell radius.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/17/2006
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_FT_protaura();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_PROTECTIVE_AURA;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	
	int iLevel = GetLevelByClass(CLASS_NWNINE_WARDER);


	// Strip any Protective Auras first
	//SCRemoveSpellEffects(SPELLABILITY_PROTECTIVE_AURA, OBJECT_SELF, oTarget);
	
	// Default to Protective Aura; if you have 4 or more levels of NW9, then use Protective Aura II.
	// AFW-OEI 10/24/2006: Only apply effects if you don't already have them; the SCRemoveSpellEffects brute-force call was causing problems.
	if (!GetHasSpellEffect(SPELLABILITY_PROTECTIVE_AURA, OBJECT_SELF))
	{
		effect eAOE;
		if (iLevel >= 4)
		{
			eAOE = EffectAreaOfEffect(AOE_PER_PROTECTIVE_AURA_II, "", "", "", sAOETag);
		}
		else
		{
			eAOE = EffectAreaOfEffect(AOE_PER_PROTECTIVE_AURA, "", "", "", sAOETag);
		}
		eAOE = ExtraordinaryEffect(eAOE);	 //Make effect extraordinary
	
		//Create an instance of the AOE Object using the Apply Effect function
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
		DelayCommand(0.0f,  HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget, 0.0f, iSpellId) ); 
	}
	
	HkPostCast(oCaster);
}
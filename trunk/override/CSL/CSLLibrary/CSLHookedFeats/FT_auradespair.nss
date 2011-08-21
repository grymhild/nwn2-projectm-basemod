//::///////////////////////////////////////////////
//:: Aura of Despair
//:: NW_S2_AuraDespair.nss
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Blackguard supernatural ability that causes all
	enemies within 10' to take a -2 penalty on all saves.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_FT_auradespair();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	// Just added the following, if it works look at making a remove aura function //
	
	// Strip any Auras first
	CSLRemoveAuraById( oTarget, SPELLABLILITY_AURA_OF_DESPAIR );
	
	// Just added the above //
	effect eAOE;
	if (GetHasFeat(FEAT_EPIC_WIDEN_AURA_DESPAIR,OBJECT_SELF))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELLABLILITY_AURA_OF_DESPAIR );
		eAOE = ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_AURA_OF_DESPAIR, "", "", "", sAOETag));
		
	}
	else
	{
		//if (GetHasSpellEffect(SPELLABLILITY_AURA_OF_DESPAIR, oCaster)) return; // NO STACKING ON THIS, REMOVAL/REAPPLY IS NOT NEEDED SINCE IT IS PERM
		eAOE = ExtraordinaryEffect(EffectAreaOfEffect(AOE_PER_AURA_OF_DESPAIR, "", "", "", sAOETag));
	}
	SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELLABLILITY_AURA_OF_DESPAIR, FALSE));
	DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oCaster) );
	
	HkPostCast(oCaster);
}
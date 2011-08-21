//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation:
//:: nw_s0_iwallflam.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
			Wall of Perilous Flame
			Complete Arcane, pg. 136
			Spell Level: 5
			Class: Misc

			The warlock can conjure a wall of fire (4th level wizard spell).
			It behaves identically to the wizard spell, except half of the damage
			is considered magical energy and fire resistance won't affect it.

*/
//:://////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"


void main()
{
	//scSpellMetaData = SCMeta_IN_wallperilous();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	location lTarget = HkGetSpellTargetLocation();
	
	int iSpellPower = HkGetSpellPower( oCaster );

	int iDuration = HkGetSpellDuration(oCaster);
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	SCWarlockAdjustMetamagic( oCaster );	
	string sAOETag = HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect(AOE_PER_WALL_PERILOUS_FLAME, "", "", "", sAOETag);
	
	//Create the Area of Effect Object declared above.
	DelayCommand( 0.1f, HkApplyEffectAtLocation(iDurType, eAOE, lTarget, fDuration ));
	
	HkPostCast(oCaster);
}
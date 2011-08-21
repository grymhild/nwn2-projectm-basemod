//::///////////////////////////////////////////////
//:: Immunity to Electricity
//:: nx_s2_immunityelectricity.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At 9th level, a stormlord gains immunity to
	electricity.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_FT_immuelectric();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	
	int iAttributes =18818;
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

	if (!GetHasSpellEffect(GetSpellId(), oTarget)) {
		effect eImmune = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999, 0);
		eImmune = ExtraordinaryEffect(eImmune); // Make it not dispellable.
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmune, oTarget);
	}
	
	HkPostCast(oCaster);
}
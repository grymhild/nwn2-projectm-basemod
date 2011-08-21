//::///////////////////////////////////////////////
//:: Mass Heal
//:: [NW_S0_MasHeal.nss]
//:: Copyright (c) 2005 Obisidian Entertainment
//:://////////////////////////////////////////////
/*
	Mass Heal

	This acts like the Heal spell except it heals
	multiple targets.
*/
//:://////////////////////////////////////////////
//:: Created By: Brock Heinz - OEI
//:: Created On: 10/06/05
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Healing"





void main()
{
	//scSpellMetaData = SCMeta_SP_msheal();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_HEAL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_POSITIVE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel  = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	effect  eVis    = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
	effect  eVis2   = EffectVisualEffect(VFX_IMP_HEALING_M);
	effect  eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());
	int nMaxToCure = iCasterLevel;
	int nCuredInFaction = SCHealHarmFaction(nMaxToCure, eVis, eVis2, iCasterLevel, GetSpellId());
	nMaxToCure = nMaxToCure - nCuredInFaction;
	SCHealHarmNearby(nMaxToCure, eVis, eVis2, iCasterLevel, SPELL_MASS_HEAL);
	
	HkPostCast(oCaster);
}


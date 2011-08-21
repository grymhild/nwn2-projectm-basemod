//::///////////////////////////////////////////////
//:: Warpriest Mass Heal
//:: [NW_S2_WPMasHeal.nss]
//:: Copyright (c) 2006 Obisidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Mass Heal

	This acts like the Heal spell except it heals
	multiple targets.

	Warpriest's spell-like ability to cast Mass Heal.
	Just like Mass Heal, except variable effects are
	controlled by Warpriest class level.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////
//:: PKM-OEI 07.11.06 - VFX Pass

#include "_HkSpell"
#include "_SCInclude_Healing"

void main()
{
	//scSpellMetaData = SCMeta_FT_wpmsheal();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iImpactSEF = VFX_IMP_HEALING_G;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE;
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
	


	int iCasterLevel  = GetLevelByClass(CLASS_TYPE_WARPRIEST);  // AFW-OEI 05/20/2006: main difference w/ Mass Heal
	effect  eVis    = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
	effect  eVis2   = EffectVisualEffect(VFX_IMP_HEALING_M);
	effect  eImpact = EffectVisualEffect(VFX_HIT_CURE_AOE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());

	int nMaxToCure = iCasterLevel;
	int nCuredInFaction = SCHealHarmFaction( nMaxToCure, eVis, eVis2, iCasterLevel, GetSpellId() );
	nMaxToCure = nMaxToCure - nCuredInFaction;
	SCHealHarmNearby(nMaxToCure, eVis, eVis2, iCasterLevel, GetSpellId());
	
	HkPostCast(oCaster);
}



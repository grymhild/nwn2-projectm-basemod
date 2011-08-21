//::///////////////////////////////////////////////
//:: [Barkskin]
//:: [NW_S0_BarkSkin.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Enhances the casters Natural AC by an amount
	dependant on the caster's level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 21, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 5, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001

// JLR - OEI 08/24/05 -- Metamagic changes
// BDF - 6/20/06: revised to work with NWN2 visual effects
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_barkskin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BARKSKIN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int iSpellPower = HkGetSpellPower( oCaster );
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int iBonus;

	//effect eVis = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN); // BDF - 6/20/06: this original constant is still valid, but we elect to use our new constants for consistency
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BARKSKIN);
	
	// BDF - 6/20/06: invalid for NWN2, all impact and cessation effects are now integrated in the visual effect (see visualeffects.2da)
	//effect eHead = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX
	
	effect eAC;

	//Signal spell cast at event
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	
	//Determine AC Bonus based Level.
	// make this so it scales up to max ac given by module, defaults work same as vanilla OEI
	iBonus = HkCapAC( 3 + (iSpellPower-1)/6 ); // Limit to maximum
	
	//Make sure the Armor Bonus is of type Natural
	eAC = EffectACIncrease(iBonus, AC_NATURAL_BONUS);
	effect eLink = EffectLinkEffects(eVis, eAC);
	//eLink = EffectLinkEffects(eLink, eDur); // NWN1 VFX

	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHead, oTarget); // BDF - 6/20/06: effect eHead is no longer valid
	
	HkPostCast(oCaster);
}


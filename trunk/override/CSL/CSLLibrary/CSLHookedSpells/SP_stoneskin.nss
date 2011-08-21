//::///////////////////////////////////////////////
//:: Stoneskin
//:: NW_S0_Stoneskin
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the creature touched 10/Adamantine
	damage reduction.  This lasts for 1 hour per
	caster level or until 10 * Caster Level (150 Max)
	is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001


// (Update JLR - OEI 07/22/05) -- Changed Damage Reduction

// JLR - OEI 08/24/05 -- Metamagic changes



/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_stoneskin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_STONESKIN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_ABJURATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	if ( GetSpellId() == SPELL_SHADES_STONESKIN )
	{
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	effect eVis1 = EffectVisualEffect( VFX_DUR_SPELL_STONESKIN );
	//effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_STONESKIN );

	object oTarget = HkGetSpellTarget();
	int nAmount = HkGetSpellPower(oCaster,15);
	//float fDuration = HoursToSeconds(HkGetSpellDuration(OBJECT_SELF));
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONESKIN, FALSE));

	//Limit the amount protection to 100 points of damage	
	int iDamage = nAmount * 10;
	
	//Meta Magic
	//fDuration = HkApplyMetamagicDurationMods(fDuration);
	//int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// (JLR - OEI 07/22/05) -- Changed Damage Reduction
	//Define the damage reduction effect
//    eStone = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, nAmount);
	effect eStone = EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, iDamage, DR_TYPE_GMATERIAL); // JLR-OEI 02/14/06: NWN2 3.5 -- New Damage Reduction Rules
	eStone = EffectLinkEffects( eStone, eVis1 );

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_STONESKIN);

	//Apply the linked effects.
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
	//HkApplyEffectToObject(iDurType, eVis1, oTarget, fDuration);
	HkUnstackApplyEffectToObject(iDurType, eStone, oTarget, fDuration, SPELL_STONESKIN);
	
	HkPostCast(oCaster);
}


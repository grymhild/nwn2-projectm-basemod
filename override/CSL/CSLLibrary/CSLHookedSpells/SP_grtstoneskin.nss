//::///////////////////////////////////////////////
//:: Greater Stoneskin
//:: NW_S0_GrStoneSk
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the gives the creature touched 20/Adamantine
	damage reduction.  This lasts for 1 hour per
	caster level or until 10 * Caster Level (150 Max)
	is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs March 4, 2003


// (Update JLR - OEI 07/22/05) -- Changed Damage Reduction


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_grtstoneskin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_STONESKIN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	int nAmount = HkGetSpellPower( oCaster, 20 ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration( oCaster );
	object oTarget = HkGetSpellTarget();

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_STONESKIN, FALSE));
	
	int iDamage = nAmount * 10;
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);



	effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_GREATER_STONESKIN );
	// (JLR - OEI 07/22/05) -- Changed Damage Reduction
//    effect eStone = EffectDamageReduction(20, DAMAGE_POWER_PLUS_FIVE, iDamage);
	effect eStone = EffectDamageReduction(20, GMATERIAL_METAL_ADAMANTINE, iDamage, DR_TYPE_GMATERIAL); // JLR-OEI 02/14/06: NWN2 3.5 -- New Damage Reduction Rules
	eStone = EffectLinkEffects( eStone, eVis2 );
	
	//Remove effects from target if they have Greater Stoneskin cast on them already.
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_GREATER_STONESKIN);

	//Apply the linked effect
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
	HkUnstackApplyEffectToObject( iDurType, eStone, oTarget, fDuration, SPELL_GREATER_STONESKIN );
	
	HkPostCast(oCaster);
}


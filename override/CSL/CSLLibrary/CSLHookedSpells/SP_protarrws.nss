//::///////////////////////////////////////////////
//:: Protection from Arrows
//:: NW_S0_ProtArrow
//:://////////////////////////////////////////////
/*
	Gives the creature touched 10/+1 vs Ranged
	damage reduction.  This lasts for 1 minute per
	caster level or until 10 * Caster Level (100 Max)
	is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 21, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_protarrws();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PROTECTION_FROM_ARROWS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	effect eLink;
	object oTarget = HkGetSpellTarget();
	int nAmount = HkGetSpellPower(OBJECT_SELF) * 10;
	float fDuration = HoursToSeconds(HkGetSpellDuration(OBJECT_SELF));
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	//Limit the amount protection to 100 points of damage
	if (nAmount > 100)
	{
			nAmount = 100;
	}
	//Meta Magic
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Define the damage reduction effect
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PROT_ARROWS);
	effect eProt = EffectDamageReduction(10, 0, nAmount, DR_TYPE_NON_RANGED); // JLR-OEI 02/14/06: NWN2 3.5 -- New Damage Reduction Rules
	//Link the effects
	eLink = EffectLinkEffects(eProt, eVis);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
	CSLRemovePermanencySpells(oTarget);

	//Apply the linked effects.
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, HkGetSpellId());
	
	HkPostCast(oCaster);
}


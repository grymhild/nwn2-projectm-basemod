//::///////////////////////////////////////////////
//:: Bless Weapon
//:: X2_S0_BlssWeap
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

	If cast on a crossbow bolt, it adds the ability to
	slay rakshasa's on hit

	If cast on a melee weapon, it will add the
		grants a +1 enhancement bonus.
		grants a +2d6 damage divine to undead

	will add a holy vfx when command becomes available

	If cast on a creature it will pick the first
	melee weapon without these effects

	Now considered "Good" for Damage Reduction purposes...
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System


// (Updated JLR - OEI 08/01/05 NWN2 3.5 -- "Good" chnage)


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void AddBlessEffectToWeapon(object oTarget, float fDuration)
{
	CSLSafeAddItemProperty(oTarget, ItemPropertyEnhancementBonusVsAlign(ALIGNMENT_EVIL, 1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE);
	int iDamage = IP_CONST_DAMAGEBONUS_2d6;
	if (GetTag(OBJECT_SELF)=="BABA_YAGA")
	{
		iDamage = IP_CONST_DAMAGEBONUS_1d6;
	}
	CSLSafeAddItemProperty(oTarget, ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, iDamage), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	CSLSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
	return;
}

void main()
{
	//scSpellMetaData = SCMeta_SP_blessweapon();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLESS_WEAPON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

		
	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS_WEAPON ); // NWN2 VFX
	object oTarget;
	object oItem;
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(2 * HkGetSpellDuration(oCaster)));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	
	// ---------------- TARGETED ON BOLT  -------------------
	oItem = HkGetSpellTarget();
	if (GetIsObjectValid(oItem) && GetObjectType(oItem)==OBJECT_TYPE_ITEM)
	{
		if (GetBaseItemType(oItem)==BASE_ITEM_BOLT) { // special handling for blessing crossbow bolts that can slay rakshasa's
			oTarget = GetItemPossessor(oItem);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
			CSLSafeAddItemProperty(oItem, ItemPropertyOnHitCastSpell(123,1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
			HkApplyEffectToObject(iDurType, eVis, GetItemPossessor(oItem), fDuration);
			return;
		}
	}
	oItem = CSLGetTargetedOrEquippedMeleeWeapon();
	if (GetIsObjectValid(oItem))
	{
		oTarget = GetItemPossessor(oItem);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
		AddBlessEffectToWeapon(oItem, fDuration);
		HkApplyEffectToObject(iDurType, eVis, oTarget, fDuration);
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, oCaster);
	}
	
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: Storm Avatar
//:: nw_s0_stormavatar.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	You become empowered by the swift strength and destructive
	fury of a fierce storm, lightning crackling from your eyes for the
	duration of the spell.  Wind under your feet enables you to travel
	at 200% normal speed (effects do not stack with haste, expeditious retreat
	and similar spells) and prevents you from being knocked down by any force
	shot of death.  Missile Weapons fired at you are deflected harmlesly.  Finally
	all melee attacks you make do an additional 3d6 points of electrical damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 11, 2006
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_stormavatar();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_STORM_AVATAR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	effect eLink = EffectVisualEffect(VFX_SPELL_DUR_STORM_AVATAR);
	eLink =  EffectLinkEffects( eLink, EffectMovementSpeedIncrease(200));
	eLink =  EffectLinkEffects( eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
	eLink =  EffectLinkEffects( eLink, EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED));
	
	int nDamProp = IP_CONST_DAMAGEBONUS_2d4;
	if (iSpellPower > 25) nDamProp = IP_CONST_DAMAGEBONUS_2d8;
	else if (iSpellPower > 21) nDamProp = IP_CONST_DAMAGEBONUS_2d6;
	itemproperty ipElectrify = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, nDamProp);
		
		
	//eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_ELECTRICAL, 0));
	object oMyWeapon = CSLGetTargetedOrEquippedMeleeWeapon();
	if (GetIsObjectValid(oMyWeapon))
	{
		CSLSafeAddItemProperty(oMyWeapon, ipElectrify, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); // FIX: should work with shock weapons too
	}
	
	
	// Apply to Creature Weapons
	oMyWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oCaster);
	if (GetIsObjectValid(oMyWeapon))
	{
		CSLSafeAddItemProperty(oMyWeapon, ipElectrify, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
	}
	
	oMyWeapon  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oCaster);		
	if (GetIsObjectValid(oMyWeapon))
	{

		CSLSafeAddItemProperty(oMyWeapon, ipElectrify, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
	}
	
	oMyWeapon  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oCaster);		
	if (GetIsObjectValid(oMyWeapon))
	{		
		CSLSafeAddItemProperty(oMyWeapon, ipElectrify, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
	}
	
	oMyWeapon  = GetItemInSlot(INVENTORY_SLOT_ARMS,oCaster);		
	if (GetIsObjectValid(oMyWeapon))
	{		
		CSLSafeAddItemProperty(oMyWeapon, ipElectrify, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
	}
	
	CSLUnstackSpellEffects(oCaster, GetSpellId());
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	
	HkPostCast(oCaster);
}


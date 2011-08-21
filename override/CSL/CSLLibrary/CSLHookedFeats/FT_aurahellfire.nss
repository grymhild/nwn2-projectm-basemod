//::///////////////////////////////////////////////
//:: Aura of Fire
//:: NW_S1_AuraFire.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura of the creature the player
	must make a will save or be stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"


void BurstWeapon(object oWeapon, float fDur)
{
	itemproperty ipFlames = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_2d8);
	DelayCommand(2.0, AddItemProperty(DURATION_TYPE_TEMPORARY, ipFlames, oWeapon, fDur));
}

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);

	object oTarget = OBJECT_SELF;
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_ELEMENTAL_SHIELD, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eVis = EffectVisualEffect(iShapeEffect);


	effect eShield = EffectDamageShield(iDuration, DAMAGE_BONUS_2d6, iDamageType);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eFire = EffectDamageResistance(iDamageType, 9999,0);

	//Link effects
	effect eLink = EffectLinkEffects(eShield, eFire);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = EffectLinkEffects(eLink, eVis);
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 761, FALSE));
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect(AOE_MOB_FIRE, "FT_aurahellfireA", "FT_aurahellfireC", "", sAOETag);
	HkApplyEffectToObject(iDurType, eAOE, OBJECT_SELF, fDuration );

	// weapon burst into flames... (with a little delay so enemies can see the weapon bursting).
	object oWeaponRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
	object oWeaponLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
	if(oWeaponRight != OBJECT_INVALID)
	{
		BurstWeapon(oWeaponRight, fDuration);
	}
	
	if(oWeaponLeft != OBJECT_INVALID)
	{
		BurstWeapon(oWeaponLeft, fDuration);
	}
	
	HkPostCast(oCaster);
}
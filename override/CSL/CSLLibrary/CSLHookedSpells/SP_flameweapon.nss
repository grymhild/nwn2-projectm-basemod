//::///////////////////////////////////////////////
//:: Flame Weapon
//:: X2_S0_FlmeWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//  Gives a melee weapon 1d4 fire damage +1 per caster
//  level to a maximum of +10.
	3.5: Gives a melee weapon +1d6 fire damage (flat).
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_flameweapon();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FLAME_WEAPON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int bValid = FALSE;
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory( HkGetSpellDuration(oCaster), SC_DURCATEGORY_MINUTES) );
	object oTarget = HkGetSpellTarget();
	
	object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();
	if (GetIsObjectValid(oMyWeapon) )
	{
		object oTarget = GetItemPossessor(oMyWeapon);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
		
		itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
		CSLSafeAddItemProperty(oMyWeapon, ipFlame, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
		bValid = TRUE;
	}
	
	if (GetIsObjectValid(oTarget) && (GetObjectType(oTarget) != OBJECT_TYPE_ITEM))	
	{
		itemproperty ipFlame = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);	
		object oCWeapon  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oTarget);
		if (GetIsObjectValid(oCWeapon))
		{
			bValid = TRUE;
			CSLSafeAddItemProperty(oCWeapon, ipFlame, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
		}
		
		oCWeapon  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oTarget);		
		if (GetIsObjectValid(oCWeapon))
		{
			bValid = TRUE;
			CSLSafeAddItemProperty(oCWeapon, ipFlame, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
		}
		
		oCWeapon  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oTarget);		
		if (GetIsObjectValid(oCWeapon))
		{		
			bValid = TRUE;
			CSLSafeAddItemProperty(oCWeapon, ipFlame, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
		}	
		
		oCWeapon  = GetItemInSlot(INVENTORY_SLOT_ARMS,oTarget);		
		if (GetIsObjectValid(oCWeapon))
		{	
			bValid = TRUE;			
			CSLSafeAddItemProperty(oCWeapon, ipFlame, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
		}
		
		oCWeapon  = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget);		
		if (GetIsObjectValid(oCWeapon) && CSLItemGetIsAWeapon(oCWeapon))
		{	
			bValid = TRUE;			
			CSLSafeAddItemProperty(oCWeapon, ipFlame, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
		}
		
		oCWeapon  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oTarget);		
		if (GetIsObjectValid(oCWeapon) && CSLItemGetIsAWeapon(oCWeapon))
		{	
			bValid = TRUE;			
			CSLSafeAddItemProperty(oCWeapon, ipFlame, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);	// FIX: should work with shock weapons too
		}
	}
	
	if ( bValid == FALSE )
	{
		FloatingTextStrRefOnCreature(83615, oCaster);
	}
	
	HkPostCast(oCaster);
}
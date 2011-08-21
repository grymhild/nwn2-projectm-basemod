//::///////////////////////////////////////////////
//:: Magic Weapon
//:: X2_S0_MagcWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants a +1 enhancement bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"






void  AddEnhancementEffectToWeapon(object oMyWeapon, float fDuration)
{
	CSLSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
	return;
}

void main()
{
	//scSpellMetaData = SCMeta_SP_magicweapon();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MAGIC_WEAPON;
	int iClass = CLASS_TYPE_NONE;
	if ( iSpellId == SPELL_BG_Magic_Weapon )
	{
		int iClass = CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	//Declare major variables
	//effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_WEAPON );
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	

	object oMyWeapon   =  CSLGetTargetedOrEquippedWeapon();
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	if(GetIsObjectValid(oMyWeapon) )
	{
		SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		if (iDuration>0)
		{
			//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), fDuration );
			AddEnhancementEffectToWeapon(oMyWeapon, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
		}
		return;
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
		return;
	}
	
	HkPostCast(oCaster);
}


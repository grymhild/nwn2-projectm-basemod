//::///////////////////////////////////////////////
//:: Flamebound Weapon
//:: cmi_s0_flmbndwpn
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////
//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FLAMEBOUND_WEAPON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );

	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
	object oMyWeapon 	= CSLGetTargetedOrEquippedMeleeWeapon();

		if(GetIsObjectValid(oMyWeapon) )
	{
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING,FALSE,TRUE );
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);
			return;
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, oCaster);
		return;
	}
	HkPostCast(oCaster);

}
//::///////////////////////////////////////////////
//:: Greater Magic Weapon
//:: X2_S0_GrMagWeap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants a +1 enhancement bonus per 3 caster levels
	(maximum of +5).
	lasts 1 hour per level
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_grtweapon();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_MAGIC_WEAPON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	
	
	
	object oMyWeapon = CSLGetTargetedOrEquippedWeapon();
	if (GetIsObjectValid(oMyWeapon))
	{
		SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(oCaster, GetSpellId(), FALSE));
		int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
		/*
		if (GetTag(oCaster) == "BABA_YAGA")
		{
			iSpellPower = 8;
		}
		*/
		
		int iBonus = HkCapAB( iSpellPower / 4 );
		effect eDur = EffectVisualEffect(VFX_DUR_SPELL_GREATER_MAGIC_WEAPON);
		float fDuration = HkApplyMetamagicDurationMods(HoursToSeconds( HkGetSpellDuration( oCaster ) ));
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
		HkApplyEffectToObject( iDurType, eDur, GetItemPossessor(oMyWeapon), fDuration);
		
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonus(iBonus), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, oCaster);
	}
	
	HkPostCast(oCaster);
}


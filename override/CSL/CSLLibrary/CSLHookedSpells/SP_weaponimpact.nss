//::///////////////////////////////////////////////
//:: Weapon of Impact
//:: X2_S0_WpnOImpct
//:://////////////////////////////////////////////
/*
	Adds the keen property to one Blunt melee weapon,
	increasing its critical threat range.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 12, 2005
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System


// JLR - OEI 08/24/05 -- Metamagic changes
// PMills - OEI 07.07.06 -- VFX pass


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void  AddKeenEffectToWeapon(object oMyWeapon, float fDuration)
{
	CSLSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
	CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
	return;
}

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WEAPON_OF_IMPACT;
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
	//effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);//NWN1 VFX
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);// NWN1 VFX
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_WEAPON_OF_IMPACT);// NWN2 VFX
	float fDuration = TurnsToSeconds(10 * HkGetSpellDuration(OBJECT_SELF));

	object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();

	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if(GetIsObjectValid(oMyWeapon) )
	{
		SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		if (CSLItemGetIsBludgeoningWeapon(oMyWeapon))
		{
			if (fDuration>0.0)
			{
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon)); //NWN1 VFX
				HkApplyEffectToObject(iDurType, eDur, GetItemPossessor(oMyWeapon), fDuration);
				AddKeenEffectToWeapon(oMyWeapon, fDuration);
			}
			return;
		}
		else
		{
			FloatingTextStrRefOnCreature(112038, OBJECT_SELF); // not a blunt weapon
			return;
		}
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
		return;
	}

	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: Blackstaff
//:: X2_S0_Blckstff
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Adds +4 enhancement bonus, On Hit: Dispel.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 29, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 07, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void AddBlackStaffEffectOnWeapon (object oTarget, float fDuration)
{
	CSLSafeAddItemProperty(oTarget, ItemPropertyEnhancementBonus(4), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE, TRUE);
	CSLSafeAddItemProperty(oTarget, ItemPropertyOnHitProps(IP_CONST_ONHIT_DISPELMAGIC, IP_CONST_ONHIT_SAVEDC_16), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING );
	CSLSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
	return;
}

void main()
{
	//scSpellMetaData = SCMeta_SP_blackstaff();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLACKSTAFF;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	//effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP); // NWN1 VFX
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLACKSTAFF ); // NWN2 VFX
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	

	if(GetIsObjectValid(oMyWeapon) )
	{
			SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

			if (GetBaseItemType(oMyWeapon) == BASE_ITEM_QUARTERSTAFF)
			{
				if (iDuration>0)
				{
					//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon)); // NWN1 VFX
					HkApplyEffectToObject(iDurType, eVis, GetItemPossessor(oMyWeapon), fDuration );
					AddBlackStaffEffectOnWeapon(oMyWeapon, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				}
				return;
			}
			else
			{
				FloatingTextStrRefOnCreature(83620, OBJECT_SELF);  // not a qstaff
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
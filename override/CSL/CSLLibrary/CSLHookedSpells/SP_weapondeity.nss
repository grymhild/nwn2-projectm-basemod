//::///////////////////////////////////////////////
//:: Weapon of the Deity
//:: cmi_s0_wpnDeity
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//_CSLCore_Items for item properties, reference marker.

#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_weapondeity();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Weapon_of_the_Deity;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	int iSpellPower = HkGetSpellPower( oCaster );
	//float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	//fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	int iDuration = HkGetSpellDuration(oCaster);
	float fDuration;
	if (HkGetSpellClass(oCaster) == CLASS_TYPE_PALADIN)
	{
		fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	}
	else
	{
		fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	}
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
    object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();	
	
	int nEnhanceBonus = (iSpellPower / 3) - 1;
	if (nEnhanceBonus > 5)
	{
		nEnhanceBonus = 5;
	}
	else if (nEnhanceBonus < 1)
	{
		nEnhanceBonus = 1;
	}
	
   	if(GetIsObjectValid(oMyWeapon) )
	{
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyKeen(), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonus(nEnhanceBonus), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING );

	   	HkApplyEffectToObject(iDurType, eVis, GetItemPossessor(oMyWeapon), fDuration);
	   	return;
    }
    else
    {
    	FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    	return;
    }	
	HkPostCast(oCaster);
}      


//::///////////////////////////////////////////////
//:: Energy Weapon
//:: cmi_s0_energywpn
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: October 25, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//_CSLCore_Items for item properties, reference marker.

#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_weapenergy();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Weapon_Energy;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ENERGY, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	iSpellId = GetSpellId();
	int DamageType;
	
	if (iSpellId == SPELL_Weapon_Energy || iSpellId == SPELL_Weapon_Energy_F)
		DamageType = DAMAGE_TYPE_FIRE;
	else
	if (iSpellId == SPELL_Weapon_Energy_A)
		DamageType = DAMAGE_TYPE_ACID;
	else
	if (iSpellId == SPELL_Weapon_Energy_C)
		DamageType = DAMAGE_TYPE_COLD;
	else
	if (iSpellId == SPELL_Weapon_Energy_E)
		DamageType = DAMAGE_TYPE_ELECTRICAL;
						

	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
    object oMyWeapon   =  CSLGetTargetedOrEquippedWeapon();
		

		
   	if(GetIsObjectValid(oMyWeapon) )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  GetItemPossessor(oMyWeapon), SPELL_Weapon_Energy );	
		
		
		effect DamageBonus = EffectDamageIncrease(DAMAGE_BONUS_1d6, DamageType);
		DamageBonus = SetEffectSpellId(DamageBonus, SPELL_Weapon_Energy);
		
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		//CSLSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(ipDamageType, IP_CONST_DAMAGEBONUS_1d6), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
	   	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, DamageBonus, GetItemPossessor(oMyWeapon), fDuration);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d10), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		return;
    }
    else
    {
    	FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    	return;
    }	
	HkPostCast(oCaster);
}


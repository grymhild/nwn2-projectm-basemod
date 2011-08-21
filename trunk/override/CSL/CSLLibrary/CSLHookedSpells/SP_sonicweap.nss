//::///////////////////////////////////////////////
//:: Sonic Weapons
//:: cmi_s0_sonicwpn
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: October 26, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//_CSLCore_Items for item properties, reference marker.

#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_sonicweap();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Sonic_Weapon;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	
	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
    object oMyWeapon   =  CSLGetTargetedOrEquippedWeapon();		
	
   	if(GetIsObjectValid(oMyWeapon) )
	{
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d6), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING );
	   	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);
	   	return;
    }
	else
	{
    	FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    	return;	
	}
	HkPostCast(oCaster);
}      


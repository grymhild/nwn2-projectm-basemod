//::///////////////////////////////////////////////
//:: Deafening Clang
//:: cmi_s0_deafclang
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Deafening_Clang;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	// DC = 10 + Spelll Level (1) + cha mod
	int iDC = 0;
	int nCha = GetAbilityScore(OBJECT_SELF,ABILITY_CHARISMA);
	
	if (nCha < 17)  // Up to 17 Cha
		iDC = 0; // DC = 14
	else if (nCha < 21) // Up to 21 Cha
		iDC = 1; // DC = 16
	else if (nCha < 25) // Up to 25 Cha
		iDC = 2; // DC = 18
	else if (nCha < 29) // Up to 29 Cha
		iDC = 3; // DC = 20
	else if (nCha < 33) // Up to 33 Cha
		iDC = 4; // DC = 22
	else if (nCha < 37) // Up to 37 Cha
		iDC = 5; // DC = 24
	 
	
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
    object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();	
	
   	if(GetIsObjectValid(oMyWeapon) )
	{
        CSLSafeAddItemProperty(oMyWeapon, ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS, iDC), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE,FALSE );
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SONIC, IP_CONST_DAMAGEBONUS_1d6), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING,FALSE,TRUE );
	   	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);
    }
    else
    {
    	FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    }
    
	HkPostCast(oCaster);
}      


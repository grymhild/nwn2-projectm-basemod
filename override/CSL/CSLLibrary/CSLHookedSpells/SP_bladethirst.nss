//::///////////////////////////////////////////////
//:: Blade Thrist
//:: SOZ UPDATE BTM
//:: X2_S0_BldeThst
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +3 enhancement bonus to a slashing weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 27, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-21: Complete Rewrite to make use of Item Property System

//#include "nw_i0_spells"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"
#include "_HkSpell"

void  AddEnhanceEffectToWeapon(object oMyWeapon, float fDuration)
{
   CSLSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(3), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING,FALSE,TRUE);
}

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_BLADE_THIRST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//Declare major variables
	

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int iDuration = 2 * HkGetSpellDuration( oCaster );
    
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	object oMyWeapon = CSLGetTargetedOrEquippedMeleeWeapon();
		
    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
		int nWeaponType = GetWeaponType(oMyWeapon);
        if ( nWeaponType == WEAPON_TYPE_SLASHING || nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING  )
        {
            if (iDuration>0)
            {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                HkApplyEffectToObject(iDurType, eDur, GetItemPossessor(oMyWeapon), fDuration );
                AddEnhanceEffectToWeapon(oMyWeapon,HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
            }
            return;
        }
        else
        {
          FloatingTextStrRefOnCreature(83621, OBJECT_SELF); // not a slashing weapon
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
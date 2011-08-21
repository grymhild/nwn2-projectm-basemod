//::///////////////////////////////////////////////
//:: Darkling Weapon
//:: cmi_s2_darkwpn
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: January 18, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_woddarkweap();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes =114688;
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
	



	int iCasterLevel = GetLevelByClass(CLASS_WARRIOR_DARKNESS);
	float fDuration = RoundsToSeconds( 4 * iCasterLevel );

    object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();
	
	itemproperty ipDarkWpn;	
	int nItemVisual = ITEM_VISUAL_EVIL;
	
	int bUseItemProp = FALSE;
	effect eDmgIncrease;
	
	if (iSpellId == WOD_DARKLING_WEAPON || iSpellId == WOD_DARKLING_WEAPON_FLAMING)
	{
		nItemVisual = ITEM_VISUAL_FIRE;
		eDmgIncrease = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		//ipDarkWpn = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
		
	}
	else if (iSpellId == WOD_DARKLING_WEAPON_FROST)
	{
		nItemVisual = ITEM_VISUAL_COLD;	
		eDmgIncrease = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
		//ipDarkWpn = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6);		
	}
	else if (iSpellId == WOD_DARKLING_WEAPON_SHOCK)
	{
		nItemVisual = ITEM_VISUAL_ELECTRICAL;
		eDmgIncrease = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL);
		//ipDarkWpn = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d6);			
	}
	else if (iSpellId == WOD_DARKLING_WEAPON_VAMP)
	{
		//ipDarkWpn = ItemPropertyBonusFeat(45); //Great Cleave
		ipDarkWpn = ItemPropertyVampiricRegeneration(2);
		bUseItemProp = TRUE;
	}
	else if (iSpellId == WOD_DARKLING_WEAPON_CRITS)
	{
		ipDarkWpn = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d10);
		bUseItemProp = TRUE;
	}				
	
    if(GetIsObjectValid(oMyWeapon) )
    {
        //SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		if (bUseItemProp) // Add Vamp/Crits
		{
			CSLSafeAddItemProperty(oMyWeapon, ipDarkWpn, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}
		else
		{
			DelayCommand(0.8f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmgIncrease, OBJECT_SELF, fDuration)); 
		}
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(nItemVisual), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);//Make the sword glow	
   
        DelayCommand(1.0f, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY ),GetLocation(HkGetSpellTarget())));
    }
	else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    }
	HkPostCast(oCaster);
}
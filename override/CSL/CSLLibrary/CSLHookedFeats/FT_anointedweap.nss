//::///////////////////////////////////////////////
//:: Anoint Weapon
//:: cmi_s2_anointwpn
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: March 23, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_anointedweap();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_ANOINTED_KNIGHT;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
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
	int iCasterLevel = GetLevelByClass(CLASS_ANOINTED_KNIGHT);
	float fDuration = HkApplyDurationCategory( iCasterLevel * 4, SC_DURCATEGORY_ROUNDS );

    object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();
	
	itemproperty ipAnointWpn;	
	int nItemVisual = ITEM_VISUAL_HOLY;
	
	int bUseItemProp = FALSE;
	effect eDmgIncrease;
	
	if (iSpellId == AKNIGHT_ANOINT_WEAPON || iSpellId == AKNIGHT_ANOINT_WEAPON_FLAMING)
	{
		nItemVisual = ITEM_VISUAL_FIRE;
		eDmgIncrease = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		//ipAnointWpn = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
	}
	else if (iSpellId == AKNIGHT_ANOINT_WEAPON_FROST)
	{
		nItemVisual = ITEM_VISUAL_COLD;
		eDmgIncrease = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
		//ipAnointWpn = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6);		
	}
	
	else if (iSpellId == AKNIGHT_ANOINT_WEAPON_SHOCK)
	{
		nItemVisual = ITEM_VISUAL_ELECTRICAL;
		eDmgIncrease = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL);
		//ipAnointWpn = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEBONUS_1d6);			
	}
	else if (iSpellId == AKNIGHT_ANOINT_WEAPON_VAMP)
	{
		//ipAnointWpn = ItemPropertyBonusFeat(45); //Great Cleave
		ipAnointWpn = ItemPropertyVampiricRegeneration(2);
		bUseItemProp = TRUE;
		//ipAnointWpn = ItemPropertyVampiricRegeneration(2);
	}
	else if (iSpellId == AKNIGHT_ANOINT_WEAPON_CRITS)
	{
		ipAnointWpn = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d10);
		bUseItemProp = TRUE;
	}				
	
    if(GetIsObjectValid(oMyWeapon) )
    {
        //SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        if (bUseItemProp) // Add Vamp/Crits
        {
			CSLSafeAddItemProperty(oMyWeapon, ipAnointWpn, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}
		else // Apply Elem Dmg to Char
		{
        	DelayCommand(0.8f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmgIncrease, OBJECT_SELF, fDuration)); 
		}
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(nItemVisual), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);//Make the sword glow	
   
        DelayCommand(1.0f, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HOLY_AID ),GetLocation(HkGetSpellTarget())));

	}
	else
	{
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    }
    HkPostCast(oCaster);
}
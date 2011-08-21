//::///////////////////////////////////////////////
//:: Forest Hammer
//:: cmi_s2_forsthammr
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 12, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
//#include "_SCInclude_Class"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_FT_formasthamfr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	/*
	object oCaster = OBJECT_SELF;
	
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	*/
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

		object oMyWeapon = CSLGetTargetedOrEquippedMeleeWeapon();

			
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  OBJECT_SELF, FOREST_MASTER_FOREST_HAMMER );
			
		if(!GetIsObjectValid(oMyWeapon))
	    {
			SendMessageToPC(OBJECT_SELF,"Forest Hammer disabled.  You must use a warmace for this ability to work.");			
	    	return;
	    }
		else
		{
			if (GetBaseItemType(oMyWeapon) != BASE_ITEM_WARMACE)
			{
				SendMessageToPC(OBJECT_SELF,"Forest Hammer disabled.  You must use a warmace for this ability to work.");			
		    	return;			
			}
		}
			
		int nForestMaster = GetLevelByClass(CLASS_FOREST_MASTER);
	
		effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );	
		float fDuration = HoursToSeconds(24);	

		
		itemproperty ipFMWpn;
		itemproperty ipFMWpn_Cleave;
		itemproperty ipFMWpn_Crits;	
		
		int nItemVisual;
		int nEnhance;
		
		if (nForestMaster > 8)
			nEnhance = 3;
		else
			nEnhance = 2;
		
		ipFMWpn_Cleave = ItemPropertyBonusFeat(45); //Great Cleave
 		ipFMWpn_Crits = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d10);

		int DamageType;		
		if (iSpellId == FOREST_MASTER_FOREST_HAMMER_SHOCK)
		{
			nItemVisual = ITEM_VISUAL_ELECTRICAL;
			DamageType = DAMAGE_TYPE_ELECTRICAL;
		}
		else
		{
			nItemVisual = ITEM_VISUAL_COLD;		
			DamageType = DAMAGE_TYPE_COLD;		
		}
		
		effect DamageBonus = EffectDamageIncrease(DAMAGE_BONUS_1d6, DamageType);
		DamageBonus = SetEffectSpellId(DamageBonus, FOREST_MASTER_FOREST_HAMMER);
		HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, DamageBonus, GetItemPossessor(oMyWeapon), fDuration, FOREST_MASTER_FOREST_HAMMER);
			
	    SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonus(nEnhance), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE);
		
		if (nForestMaster > 5)
		{
			CSLSafeAddItemProperty(oMyWeapon, ipFMWpn_Crits, fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}
		if (nForestMaster > 8)
		{
			CSLSafeAddItemProperty(oMyWeapon, ipFMWpn_Cleave, fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}		
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(nItemVisual), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration, FOREST_MASTER_FOREST_HAMMER ));
		return;

}
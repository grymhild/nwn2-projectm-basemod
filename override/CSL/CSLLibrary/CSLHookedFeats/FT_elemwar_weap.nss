//::///////////////////////////////////////////////
//:: Elemental Weapon
//:: cmi_s2_elemwpn
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: August 12, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"
//#include "_CSLCore_Items"

void main()
{	
	//scSpellMetaData = SCMeta_FT_elemwar_weap();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_ELEMWAR_WEAPON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

		
    
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
	
	int DamageType;	
	int nItemVisual;
	
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR))
	{	
		DamageType = DAMAGE_TYPE_ELECTRICAL;
		nItemVisual = ITEM_VISUAL_ELECTRICAL;
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH))
	{	
		DamageType = DAMAGE_TYPE_ACID;
		nItemVisual = ITEM_VISUAL_ACID;				
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE))
	{
		DamageType = DAMAGE_TYPE_FIRE;
		nItemVisual = ITEM_VISUAL_FIRE;			
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER))
	{
		DamageType = DAMAGE_TYPE_COLD;
		nItemVisual = ITEM_VISUAL_COLD;	
	}
	
	float fDuration =  RoundsToSeconds(10);
	
	int nElemWar = GetLevelByClass(CLASS_ELEMENTAL_WARRIOR);
	if (nElemWar == 5)
	{
		object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	    if (GetIsObjectValid(oWeapon1))
	    {
			CSLSafeAddItemProperty(oWeapon1, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_4d6), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);	
		}	
		object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
		if (GetIsObjectValid(oWeapon2))
	    {
			if (CSLItemGetIsMeleeWeapon(oWeapon2))
			{
				CSLSafeAddItemProperty(oWeapon2, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_4d6), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);			
			}
		}
	}	
	
	effect eLink = EffectDamageIncrease(DAMAGE_BONUS_2d6, DamageType);			
		
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );		
	eLink = EffectLinkEffects(eDur, eLink);	
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, iSpellId);
		
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration, iSpellId));
	
	HkPostCast(oCaster);
}
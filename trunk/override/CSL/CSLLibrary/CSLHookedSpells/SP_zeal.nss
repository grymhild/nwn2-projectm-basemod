//::///////////////////////////////////////////////
//:: Zeal
//:: cmi_s0_zeal
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: June 25, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x0_i0_spells"
//#include "x2_inc_spellhook"
//#include "_SCInclude_Class"


void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Zeal;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    //int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, fDuration);	
	
	itemproperty iBonusFeat1 = ItemPropertyBonusFeat(90);  //Spring Attack
	itemproperty iBonusFeat2 = ItemPropertyBonusFeat(IPRP_FEAT_UNCANNYDODGE1);	//Uncanny Dodge
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
	if (oArmorNew == OBJECT_INVALID)
	{
		oArmorNew = CreateItemOnObject("x2_it_emptyskin", OBJECT_SELF, 1, "", FALSE);
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat1,oArmorNew,fDuration);
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat2,oArmorNew,fDuration);
		DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
		ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);		
	}
	else
	{
        CSLSafeAddItemProperty(oArmorNew, iBonusFeat1, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );	
        CSLSafeAddItemProperty(oArmorNew, iBonusFeat2, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );	
	}	
	
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Strategic Charge
//:: cmi_s0_stratcharge
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: June 25, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"


void main()
{	
	//scSpellMetaData = SCMeta_SP_strategiccha();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Strategic_Charge;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	itemproperty iBonusFeat = ItemPropertyBonusFeat(27);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
	if (oArmorNew == OBJECT_INVALID)
	{
		oArmorNew = CreateItemOnObject("x2_it_emptyskin", OBJECT_SELF, 1, "", FALSE);
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oArmorNew,fDuration);
		DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));		
	}
	else
	{
        CSLSafeAddItemProperty(oArmorNew, iBonusFeat, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );	
	}	
	ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);
	
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: Trackless Step (Allies)
//:: cmi_s2_grptrackstep
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_includes"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	float fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);
	itemproperty iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_TRACKLESSSTEP);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
		    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
			if (oArmorNew == OBJECT_INVALID)
			{
				oArmorNew = CreateItemOnObject("x2_it_emptyskin", OBJECT_SELF, 1, "", FALSE);
				AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oArmorNew,fDuration);
				DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
				ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);		
			}
			else
			{
		        CSLSafeAddItemProperty(oArmorNew, iBonusFeat, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );	
			}				
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }	
	HkPostCast(oCaster);
}
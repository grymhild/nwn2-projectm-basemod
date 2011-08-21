//::///////////////////////////////////////////////
//:: Repellant Flesh
//:: cmi_s2_repelflesh
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Jan 17, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"
//#include "_CSLCore_Items"

void main()
{	
	//scSpellMetaData = SCMeta_FT_sacredfistco();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = -SACREDFIST_CODE_OF_CONDUCT;
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
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );	
	
	object oWpn1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
	object oWpn2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
	
	if (GetIsObjectValid(oWpn1) || (GetIsObjectValid(oWpn2)))
	{
		//Rut roh shaggy, you have something in your hands
		effect eAB =  EffectAttackDecrease(8);
		eAB = SetEffectSpellId(eAB,iSpellId);
		eAB = SupernaturalEffect(eAB);
		
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAB, OBJECT_SELF, HoursToSeconds(48), iSpellId));
			
	}
	
}
//::///////////////////////////////////////////////
//:: Child of Night, Night Form
//:: cmi_s2_nightfrm
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 3, 2009
//:://////////////////////////////////////////////
//#include "x2_inc_spellhook"
//#include "nwn2_inc_metmag"
//#include "cmi_ginc_spells"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nSpell = SPELLABILITY_CHLDNIGHT_NIGHT_FORM;
	effect eVis = EffectVisualEffect(VFX_INVOCATION_WORD_OF_CHANGING);
	effect ePoly = EffectPolymorph(POLYMORPH_TYPE_NIGHTWALKER, FALSE, TRUE);
	ePoly = EffectLinkEffects(ePoly, eVis);

	//Fire cast spell at event for the specified target
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, TurnsToSeconds(1));

	itemproperty iBonusFeat = ItemPropertyBonusFeat(125);
	
	 DelayCommand(2.0f,  CSLSafeAddItemProperty( GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF), iBonusFeat, TurnsToSeconds(1),SC_IP_ADDPROP_POLICY_KEEP_EXISTING) );
	 
	

}
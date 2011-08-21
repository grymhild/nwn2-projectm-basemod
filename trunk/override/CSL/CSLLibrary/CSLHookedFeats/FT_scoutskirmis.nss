//::///////////////////////////////////////////////
//:: Skirmish AC
//:: cmi_s2_skirmishac
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: November 23, 2009
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_SCOUT_SKIRMISHAC;
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
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
	

	effect eAC = EffectACIncrease(1);
	eAC = SetEffectSpellId(eAC,iSpellId);
	eAC = SupernaturalEffect(eAC);
	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, OBJECT_SELF, HoursToSeconds(72)));
}
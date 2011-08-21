//::///////////////////////////////////////////////
//:: Maximize Eldritch Blast
//:: cmi_s2_maxeldblst
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//#include "x2_inc_spellhook"
//#include "nwn2_inc_metmag"
//#include "cmi_ginc_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_MAXIMIZE_ELDBLAST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_NONE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
	SetLocalInt(OBJECT_SELF, "MaxEldBlast", 1);	
	
	//SetLocalInt(oCaster, "MaxEldBlast", 1);
	//effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	//eVis = SetEffectSpellId(eVis,SPELLABILITY_MAXIMIZE_ELDBLAST);
	//eVis = SupernaturalEffect(eVis);
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, HoursToSeconds(24));
	
	HkPostCast(oCaster);

}
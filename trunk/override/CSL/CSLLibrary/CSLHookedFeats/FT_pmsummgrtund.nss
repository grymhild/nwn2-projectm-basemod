//::///////////////////////////////////////////////
//:: Summon Greater Undead
//:: X2_S2_SumGrUnd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_PM_SUMMON_GREATER_UNDEAD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes =  SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}
	
	
	//scSpellMetaData = SCMeta_FT_pmsummgrtund();
	SummonUndead();
	
	HkPostCast(oCaster);
}
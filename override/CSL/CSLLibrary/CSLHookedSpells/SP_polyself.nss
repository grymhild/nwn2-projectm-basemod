//::///////////////////////////////////////////////
//:: Polymorph Self
//:: NW_S0_PolySelf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The PC is able to changed their form to one of
	several forms.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Polymorph"

void main()
{
	//scSpellMetaData = SCMeta_SP_polyself();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POLYMORPH_SELF;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_POLYMORPH_GARGOYLE )
	{
		iSpellId=SPELL_POLYMORPH_GARGOYLE;
	}
	else if ( GetSpellId() == SPELL_POLYMORPH_MINDFLAYER )
	{
		iSpellId=SPELL_POLYMORPH_MINDFLAYER;
	}
	else if ( GetSpellId() == SPELL_POLYMORPH_SWORD_SPIDER )
	{
		iSpellId=SPELL_POLYMORPH_SWORD_SPIDER;
	}
	else if ( GetSpellId() == SPELL_POLYMORPH_TROLL )
	{
		iSpellId=SPELL_POLYMORPH_TROLL;
	}
	else if ( GetSpellId() == SPELL_POLYMORPH_UMBER_HULK )
	{
		iSpellId=SPELL_POLYMORPH_UMBER_HULK;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(HkGetSpellDuration(oCaster)));
	PolyMerge(oCaster, SPELL_POLYMORPH_SELF, fDuration, FALSE, TRUE);
	
	HkPostCast(oCaster);
}

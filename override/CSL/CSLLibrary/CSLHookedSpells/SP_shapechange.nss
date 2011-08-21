//::///////////////////////////////////////////////
//:: Shapechange
//:: NW_S0_ShapeChg.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Polymorph"

void main()
{
	//scSpellMetaData = SCMeta_SP_shapechange();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHAPECHANGE;
	int iDescriptor = SCMETA_DESCRIPTOR_NONE;
	int iClass = CLASS_TYPE_NONE;
	if ( iSpellId == SPELL_SHAPECHANGE_FIRE_GIANT )
	{
		iSpellId = SPELL_SHAPECHANGE_FIRE_GIANT;
		iDescriptor = SCMETA_DESCRIPTOR_FIRE;
	}
	else if ( iSpellId == SPELL_SHAPECHANGE_FROST_GIANT )
	{
		iSpellId = SPELL_SHAPECHANGE_FROST_GIANT;
		iDescriptor = SCMETA_DESCRIPTOR_COLD;
	}
	else if ( iSpellId == SPELL_SHAPECHANGE_HORNED_DEVIL )
	{
		iSpellId = SPELL_SHAPECHANGE_HORNED_DEVIL;
		iDescriptor = SCMETA_DESCRIPTOR_EVIL;
	}
	else if ( iSpellId == SPELL_SHAPECHANGE_IRON_GOLEM )
	{
		iSpellId = SPELL_SHAPECHANGE_IRON_GOLEM;
		iDescriptor = SCMETA_DESCRIPTOR_NONE;
	}
	else if ( iSpellId == SPELL_SHAPECHANGE_NIGHTWALKER )
	{
		iSpellId = SPELL_SHAPECHANGE_NIGHTWALKER;
		iDescriptor = SCMETA_DESCRIPTOR_NONE;
	}
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(HkGetSpellDuration(oCaster)));
	PolyMerge(oCaster, SPELL_SHAPECHANGE, fDuration);
	
	HkPostCast(oCaster);
}
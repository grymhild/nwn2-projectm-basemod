//:://///////////////////////////////////////////////
//:: Pilfer Magic
//:: nw_s0_pilfermagic.nss
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 08/07/2006
//::////////////////////////////////////////////////
/*
	Copied mostly from nw_s0_idevmagic, the Warlock
	Devour Magic spell.

	This Arcane Trickster spell-like ability does
	a single-target dispel effect that only strips
	one effect.  If successful, it grants the caster
	+2 attack bonus and +2 to all saves for 10 rounds.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_FT_pilfermagic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_PILFER_MAGIC;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	
	object oTarget = HkGetSpellTarget();
	
	
	if (  GetIsObjectValid(oTarget)  )
	{
		DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, SCGetDispellCount(iSpellId, TRUE), SPELLABILITY_PILFER_MAGIC ) );
	}
	else
	{
		location lLocal = HkGetSpellTargetLocation();
		int nStripCnt = SCGetDispellCount(iSpellId, FALSE);
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		while (GetIsObjectValid(oTarget) && nStripCnt > 0)
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT)
			{
				SCDispelAoE(oTarget, oCaster);
			}
			else
			{
				//SCDispelTarget(oTarget, oCaster, nStripCnt);
				DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELLABILITY_PILFER_MAGIC ) );
				
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		}
	}
	
	HkPostCast(oCaster);	
}
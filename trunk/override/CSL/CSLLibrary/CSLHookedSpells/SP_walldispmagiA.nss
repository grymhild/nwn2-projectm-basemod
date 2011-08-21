//::///////////////////////////////////////////////
//:: Wall of Dispel Magic (on enter script)
//:: nw_s0_walldispa.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Wall of Dispel Magic
	Abjuration
	Level: Cleric 5, sorceror/wizard 5
	Components: V, S
	Range: Short
	Effect: 10-ft. by 1-ft. wall
	Duration: 1 minute/level
	Saving Throw: None
	Spell Resistance: No
	
	This spell creates a magic, permiable barrier.
	Anyone passing through it becomes the target of
	a dispel magic effect at your caster level.  A
	summoned creature targeted in this way can be
	dispelled by the effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.07.2006
//:://////////////////////////////////////////////
//:: AFW-OEI 07/12/2007: NX1 VFX

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_walldispmagi(); //SPELL_WALL_DISPEL_MAGIC;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_WALL_DISPEL_MAGIC;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	
	int nStripCnt = SCGetDispellCount(SPELL_WALL_DISPEL_MAGIC);
	
	if (GetIsObjectValid(oTarget))
	{
		SCDispelTarget(oTarget, oCaster, nStripCnt);
	}
}      
//::///////////////////////////////////////////////
//:: Wall of Dispel Magic, Greater (on enter script)
//:: nw_s0_grwalldispa.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Wall of Dispel Magic, Greater
	Abjuration
	Level: Cleric 8, sorceror/wizard 8
	Components: V, S
	Range: Short
	Effect: 10-ft. by 1-ft. wall
	Duration: 1 minute/level
	Saving Throw: None
	Spell Resistance: No
	
	This spell creates a magic, permiable barrier.
	Anyone passing through it becomes the target of
	a greater dispel magic effect at your caster level.  A
	summoned creature targeted in this way can be
	dispelled by the effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.07.2006
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_grtwalldispm(); //SPELL_GREATER_WALL_DISPEL_MAGIC;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_GREATER_WALL_DISPEL_MAGIC;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	
	int nStripCnt = SCGetDispellCount(SPELL_GREATER_WALL_DISPEL_MAGIC);
	
	if (GetIsObjectValid(oTarget))
	{
		DelayCommand( 0.0f, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELL_GREATER_WALL_DISPEL_MAGIC ) );
	 }
}
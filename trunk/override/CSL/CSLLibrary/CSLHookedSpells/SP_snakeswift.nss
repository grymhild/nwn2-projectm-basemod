//::///////////////////////////////////////////////
//:: SnakesSwiftnessMass
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 09/05/2008
//:://////////////////////////////////////////////
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"


#include "_HkSpell"

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
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
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
	
	object oTarget = HkGetSpellTarget();
	if( GetIsObjectValid(oTarget) && CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF ) && !GetHasSpellEffect(SPELL_SNAKES_SWIFTNESS, oTarget) )
	{
		effect eHaste = EffectHaste();
		effect eDur = EffectVisualEffect( VFX_HIT_SPELL_SNAKESSWIFTNESS );
		effect eLink = EffectLinkEffects(eHaste, eDur);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1), SPELL_SNAKES_SWIFTNESS);
	}
	HkPostCast(oCaster);
}
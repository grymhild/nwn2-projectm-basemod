//::///////////////////////////////////////////////
//:: Name 	Dimension Hop
//:: FileName sp_dimens_hop.nss
//:://////////////////////////////////////////////
/**@file Dimension Hop
Conjuration (Teleportation)
Level: Duskblade 2, sorcerer/wizard 2
Components: V
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Will negates
Spell Resistance: Yes

You instantly teleport the subject creature a distance
of 5 feet per two caster levels. The destination must
be an unoccupied space within line of sight.
**/
/////////////////////////////////////////////////////
// Author: Tenjac (nearly completely copied from Ornedan)
// Date: 	3.10.06
/////////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DIMENSION_HOP; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	location lTarget = HkGetSpellTargetLocation();

	//Remember to set range to medium and change the tlk description.

	// Assign jump command with delay to prevent the damn infinite action loop
	DelayCommand(1.0f, AssignCommand(oCaster, JumpToLocation(lTarget)));

	// Do some VFX
	DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oCaster, 0.55));
	DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_TORNADO, GetArea(oCaster), GetPosition(oCaster), GetPositionFromLocation(lTarget), 0.0, FloatToInt(GetDistanceBetweenLocations(GetLocation(oCaster), lTarget)), 0.5);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

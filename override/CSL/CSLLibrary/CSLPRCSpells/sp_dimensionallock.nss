//::///////////////////////////////////////////////
//:: Spell: Dimensional Lock
//:: sp_dimens_lock
//::///////////////////////////////////////////////
/** @ file
	Dimensional Lock

	Abjuration
	Level: Clr 8, Sor/Wiz 8
	Components: V, S
	Casting Time: 1 standard action
	Range: Medium (100 ft. + 10 ft./level)
	Area: 20-ft.-radius emanation centered on a point in space
	Duration: One day/level
	Saving Throw: None
	Spell Resistance: Yes

	You create a shimmering emerald barrier that completely blocks
	extradimensional travel. Forms of movement barred include astral projection,
	blink, dimension door, ethereal jaunt, etherealness, gate, maze,
	plane shift, shadow walk, teleport, and similar spell-like or psionic
	abilities. Once dimensional lock is in place, extradimensional travel into
	or out of the area is not possible.

	A dimensional lock does not interfere with the movement of creatures already
	in ethereal or astral form when the spell is cast, nor does it block
	extradimensional perception or attack forms. Also, the spell does not
	prevent summoned creatures from disappearing at the end of a summoning
	spell.


	@author Ornedan
	@date 	Created - 2005.10.22
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_inc_teleport"


#include "_HkSpell"

void main()
{	
	
	//SPSetSchool();
	// Spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DIMENSIONAL_LOCK; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//

	/* Main spellscript */
	location lTarget = HkGetSpellTargetLocation();
	int nCasterLvl 	= HkGetCasterLevel();
	int nSpellID 	= HkGetSpellId();
	effect eVis 	= EffectLinkEffects(EffectVisualEffect(VFX_IMP_ACID_L), EffectVisualEffect(VFX_IMP_ACID_S));
	//float fDur 		= HkApplyMetamagicDurationMods(HoursToSeconds(24 * nCasterLvl));
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_DAYS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// Do VFX
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);

	// Spawn invisible caster object
	object oApplyObject = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_invisobj", lTarget);

	// Store data on it
	SetLocalObject(oApplyObject, "PRC_Spell_DimLock_Caster", oCaster);
	SetLocalLocation(oApplyObject, "PRC_Spell_DimLock_Target", lTarget);
	SetLocalInt(oApplyObject, "PRC_Spell_DimLock_SpellPenetr", nCasterLvl);
	SetLocalFloat(oApplyObject, "PRC_Spell_DimLock_Duration", fDuration);

	// Assign commands
	AssignCommand(oApplyObject, ExecuteScript("sp_dimens_lock_x", oApplyObject));
	AssignCommand(oApplyObject, DelayCommand(fDuration, DestroyObject(oApplyObject))); // The AoE is likely to destroy it before this, but paranoia

	// Cleanup
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
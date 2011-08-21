//::///////////////////////////////////////////////
//:: Spell Template
//:: sp_template.nss
//:: 2009 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
Abjuration
Level:	Clr 6
Components:	V, S, M, DF
Casting Time:	6 rounds
Range:	Medium (100 ft. + 10 ft./level)
Area:	60-ft. cube/level (S)
Duration:	Permanent
Saving Throw:	See text
Spell Resistance:	Yes
Forbiddance seals an area against all planar travel into or within it. This includes all teleportation spells (such as dimension door and teleport), plane shifting, astral travel, ethereal travel, and all summoning spells. Such effects simply fail automatically.
In addition, it damages entering creatures whose alignments are different from yours. The effect on those attempting to enter the warded area is based on their alignment relative to yours (see below). A creature inside the area when the spell is cast takes no damage unless it exits the area and attempts to reenter, at which time it is affected as normal.
Alignments identical
No effect. The creature may enter the area freely (although not by planar travel).
Alignments different with respect to either law/chaos or good/evil
The creature takes 6d6 points of damage. A successful Will save halves the damage, and spell resistance applies.
Alignments different with respect to both law/chaos and good/evil
The creature takes 12d6 points of damage. A successful Will save halves the damage, and spell resistance applies.
At your option, the abjuration can include a password, in which case creatures of alignments different from yours can avoid the damage by speaking the password as they enter the area. You must select this option (and the password) at the time of casting.
Dispel magic does not dispel a forbiddance effect unless the dispeller’s level is at least as high as your caster level.
You can’t have multiple overlapping forbiddance effects. In such a case, the more recent effect stops at the boundary of the older effect.
Material Component
A sprinkling of holy water and rare incenses worth at least 1,500 gp, plus 1,500 gp per 60-foot cube. If a password is desired, this requires the burning of additional rare incenses worth at least 1,000 gp, plus 1,000 gp per 60-foot cube.
*/
//:://////////////////////////////////////////////
//:: Based on Work of: Author
//:: Created On:
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	
	location lTarget = HkGetSpellTargetLocation();

	int iDuration = HkGetSpellDuration(oCaster);
	int iSpellPower = HkGetSpellPower(oCaster, 10);
	
	int iSaveDC = HkGetSpellSaveDC();
	
	int iDamageType = HkGetDamageType(DAMAGE_TYPE_FIRE);
	int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_FIRE);
	
	float fTargetSize = HkApplySizeMods( RADIUS_SIZE_HUGE );
	int iTargetShape = HkApplyShapeMods( SHAPE_SPHERE );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	int iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect( HkGetHitEffect(VFX_IMP_FLAME_M) );
	effect eHit;
	
	//--------------------------------------------------------------------------
	// AOE
	//--------------------------------------------------------------------------
	//string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	//effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "", "", "", sAOETag);
	//DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	
	//--------------------------------------------------------------------------
	// Remove Previous Versions of this spell
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	
	
	//--------------------------------------------------------------------------
	// Apply effects
	//--------------------------------------------------------------------------
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	// Visual
	effect eExplode = EffectVisualEffect( HkGetShapeEffect( VFX_FNF_FIREBALL ) );
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
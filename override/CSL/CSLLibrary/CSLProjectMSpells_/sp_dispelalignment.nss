//::///////////////////////////////////////////////
//:: Spell Template
//:: sp_template.nss
//:: 2009 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
Dispel Evil
Abjuration [Good]
Level:	Clr 5, Good 5, Pal 4
Components:	V, S, DF
Casting Time:	1 standard action
Range:	Touch
Target or Targets:	You and a touched evil creature from another plane; or you and an enchantment or evil spell on a touched creature or object
Duration:	1 round/level or until discharged, whichever comes first
Saving Throw:	See text
Spell Resistance:	See text
Shimmering, white, holy energy surrounds you. This power has three effects.
First, you gain a +4 deflection bonus to AC against attacks by evil creatures.
Second, on making a successful melee touch attack against an evil creature from another plane, you can choose to drive that creature back to its home plane. The creature can negate the effects with a successful Will save (spell resistance applies). This use discharges and ends the spell.
Third, with a touch you can automatically dispel any one enchantment spell cast by an evil creature or any one evil spell. Exception: Spells that can’t be dispelled by dispel magic also can’t be dispelled by dispel evil. Saving throws and spell resistance do not apply to this effect. This use discharges and ends the spell.

Dispel Good
Abjuration [Evil]
Level:	Clr 5, Evil 5
Components:	 V, S, DF
Casting time:	 1 standard action
Range:	 Touch
Targets:	 You and a touched evil creature from another plane; or you and an enchantment or evil spell on a touched creature or object
Duration:	 1 round/level or until discharged, whichever comes first
Saving Throw:	 See text
Spell Resistance:	 See text
You are surrounded by dark, wavering, unholy energy.
First, you gain a +4 deflection bonus to AC against attacks by good creatures.
Second, on making a successful melee touch attack against an good creature from another plane, you can choose to drive that creature back to its home plane. The creature can negate the effects with a successful Will save (spell resistance applies). This use discharges and ends the spell.
Third, with a touch you can automatically dispel any one enchantment spell cast by an good creature or any one good spell. Exception: Spells that can’t be dispelled by dispel magic also can’t be dispelled by dispel evil. Saving throws and spell resistance do not apply to this effect. This use discharges and ends the spell.

Dispel Chaos
Abjuration [Lawful]
Level:	Clr 5, Law 5, Pal 4
Components:	 V, S, DF
Casting time:	 1 standard action
Range:	 Touch
Targets:	 You and a touched evil creature from another plane; or you and an enchantment or evil spell on a touched creature or object
Duration:	 1 round/level or until discharged, whichever comes first
Saving Throw:	 See text
Spell Resistance:	 See text
You are surrounded by constant, blue, lawful energy.
First, you gain a +4 deflection bonus to AC against attacks by chaotic creatures.
Second, on making a successful melee touch attack against an chaotic creature from another plane, you can choose to drive that creature back to its home plane. The creature can negate the effects with a successful Will save (spell resistance applies). This use discharges and ends the spell.
Third, with a touch you can automatically dispel any one enchantment spell cast by an chaotic creature or any one chaotic spell. Exception: Spells that can’t be dispelled by dispel magic also can’t be dispelled by dispel evil. Saving throws and spell resistance do not apply to this effect. This use discharges and ends the spell.


Dispel Law
Abjuration [Chaotic]
Level:	Chaos 5, Clr 5
Components:	 V, S, DF
Casting time:	 1 standard action
Range:	 Touch
Targets:	 You and a touched lawful creature from another plane; or you and an enchantment or lawful spell on a touched creature or object
Duration:	 1 round/level or until discharged, whichever comes first
Saving Throw:	 See text
Spell Resistance:	 See text
You are surrounded by flickering, yellow, chaotic energy.
First, you gain a +4 deflection bonus to AC against attacks by lawful creatures.
Second, on making a successful melee touch attack against an lawful creature from another plane, you can choose to drive that creature back to its home plane. The creature can negate the effects with a successful Will save (spell resistance applies). This use discharges and ends the spell.
Third, with a touch you can automatically dispel any one enchantment spell cast by an lawful creature or any one lawful spell. Exception: Spells that can’t be dispelled by dispel magic also can’t be dispelled by dispel law. Saving throws and spell resistance do not apply to this effect. This use discharges and ends the spell.
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
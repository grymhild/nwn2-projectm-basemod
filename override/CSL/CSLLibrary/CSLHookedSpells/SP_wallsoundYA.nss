//::///////////////////////////////////////////////
//:: Wall of Sound: On Enter (within 10ft - chance deafness)
//:: SG_S0_WallSndD.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation
	Level: Brd 3
	Components: V, S
	Casting Time: 1 action
	Range: Short
	Duration: 1 round/level
	Area of Effect: Special
	Saving Throw: See text
	Spell Resistance: No

	The wall of sound spell brings forth an immobile, shimmering curtain of violently
	disturbed air. The wall is 10 meters wide x 2 meters thick. One side of the wall (away from the caster),
	produces a voluminous roar that completely disrupts all communication, command words, verbal spell components, and
	any other form of organized sound within 30 feet. In addition, those within 10 feet are
	deafened for 1d4 turns if they fail a fortitude save.
	On the other side of the wall, a loud roar can be heard, but communication is possible
	by shouting, and verbal components and command words function normally.
	Anyone passing through the wall suffers 1d8 points of damage and is permanently
	deafened unless he makes a successful Fortitude save.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 5, 2004
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	float 	fDuration 		= RoundsToSeconds(HkApplyMetamagicVariableMods(d4(1), 4));
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	//int iShapeEffect = HkGetShapeEffect( VFX_NONE, SC_SHAPE_NONE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC);
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eDeafVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	effect eDeaf = EffectDeaf();

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WALL_OF_SOUND));
	if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType))
	{
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeafVis, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
	}

}
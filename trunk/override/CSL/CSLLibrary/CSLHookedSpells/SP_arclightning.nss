//::///////////////////////////////////////////////
//:: Arc of Lighting
//:: nx2_s0_arc_of_lightning.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Arc of Lighting
	Conjuration (Creation) [Electricity]
	Level: Druid 4, sorceror/wizard 5
	Components: V, S
	Range: Close
	Area: A line between two creatures
	Saving Throw: Reflex half
	Spell Resistance: No
	
	This bolt deal 1d6 points of electricity damage to per caster level (maximum 15d6) to
	both creatures and to anything in the line beteen them.

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



// Gets a random creature near target creature
object GetRandomCreature(object oTarget)
{
	location lTarget = GetLocation(oTarget);
	// Get first object in area around the target
	object oTarget2 = GetFirstObjectInShape(SHAPE_SPHERE, 15.0, lTarget);
	// as long as we have a valid target
	while(GetIsObjectValid(oTarget2))
	{
		// make sure it is in the hostile faction as well and not the original target
		if(GetFactionEqual(oTarget, oTarget2) && oTarget != oTarget2)
			return oTarget2;
		oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, 15.0, lTarget);
	}
	return OBJECT_INVALID;
}
void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ARC_OF_LIGHTNING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	
	//Get random second target
	object oTarget2 = GetRandomCreature(oTarget);
	// Get locations and positions
	location lTarget = GetLocation(oTarget);
	location lTarget2 = GetLocation(oTarget2);
	vector vTarget = GetPositionFromLocation(lTarget);
	// Caster level
	int iSpellPower = HkGetSpellPower( oCaster, 15 ); // OldGetCasterLevel(oCaster);
	
	// Effect placeholders
	int iDamage = d6(iSpellPower);
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_LIGHTNING, SC_SHAPE_BEAM); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDamage;// = EffectDamage(iDamage, iDamageType);
	effect eBeam = EffectBeam( iShapeEffect, oTarget2, BODY_NODE_CHEST);
	effect eHit = EffectVisualEffect( iHitEffect );
	
	// no matter what damage original target
	if(GetIsObjectValid(oTarget))
	{
		//iDamage = d6(iSpellPower);
		iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
		iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType, oCaster);
		eDamage = HkEffectDamage(iDamage, iDamageType);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget);
	}

	// if we have a valid second object
	if(GetIsObjectValid(oTarget2))
	{
		// create a lightning bolt between the two target
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 5.0f);
		// in order to get all object in a line between the two target, create a cone starting
		// at one and ending at the other with a small width, creating a line
		oTarget = GetFirstObjectInShape(SHAPE_CONE, 0.1, lTarget2, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_ITEM | OBJECT_TYPE_PLACEABLE, vTarget);
		// While spell target is valid
		while (GetIsObjectValid(oTarget))
		{
			// check to see if hostile
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				// Get damage apply effects
				iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType, oCaster);
				eDamage = HkEffectDamage(iDamage, iDamageType);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget);
				
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
			}
			oTarget = GetNextObjectInShape(SHAPE_CONE, 0.1, lTarget2, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_ITEM | OBJECT_TYPE_PLACEABLE, vTarget);
		}
	}
	
	HkPostCast(oCaster);
}


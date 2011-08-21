//::///////////////////////////////////////////////
//:: Blood to Water
//:: nx2_s0_blood_to_water.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Blood to Water
	Necromancy [Water]
	Level: Cleric 7
	Components: V, S
	Range: Close
	Effect: Up to five living creatures withint a 30ft. radius.
	Duration: Instantaneous
	Saving Throw: Fortitude half
	Spell Resistance: Yes
	
	You transmute the subjects' blood into pure water, dealing 2d6 points of Constitution damage.
	A sucessful Fortitude save halves the Constitution damage.
	
	NOTE: The spell specifies that water and fire subtypes are immune to this spell.
	I am fine with ignoring this rule or special casing fire/water genasi and fire giants from the list.
	Outsiders, elementals, undead, etc, are already covered under the "living targets" rule.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


//#include "x0_i0_match"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLOOD_TO_WATER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	// Get necessary objects
	location lTarget = HkGetSpellTargetLocation();
	
	// Effect placeholders
	int iDamage;
	effect eDamage;
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_BLOOD_TO_WATER);
	effect eVisual = EffectVisualEffect(VFX_AOE_SPELL_BLOOD_TO_WATER);
	float fDelay;
	//counter
	int nCount = 1;
	// Succesful save?
	int nSaved;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	int iDC;
	int iAdjustedDamage;
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisual, lTarget);
	
	//Get first target
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	// as long as target is valid and count is less than 5
	while(nCount <=5 && GetIsObjectValid(oTarget))
	{
		// Make sure spell target has blood
		if ( CSLGetIsBloodBased(oTarget) )
		{
			// check to see if hostile
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				iDC = HkGetSpellSaveDC(oCaster, oTarget);
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget) ) / 20;
				if ( !HkResistSpell( oCaster, oTarget, fDelay) )
				{
					// remove previous usages of this spell
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
					iDamage = HkApplyMetamagicVariableMods(d6(2), 6 * 2);
					//nSaved = FortitudeSave(oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE, oCaster);
					iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE, oCaster );
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
					{
						iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE, oCaster, SAVING_THROW_RESULT_SUCCESS );
						eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, iDamage);
						eDamage = SetEffectSpellId(eDamage, -1); // set to invalid spell ID for stacking
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
						HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eDamage), oTarget, 0.0f, -2);
						if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
						{
							iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_NEGATIVE, oCaster, SAVING_THROW_RESULT_FAILED );
							eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, iDamage);
							eDamage = SetEffectSpellId(eDamage, -1); // set to invalid spell ID for stacking
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
							
							HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eDamage), oTarget, 0.0f, -2);
						}
					}
					
				}
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
				nCount++;
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}


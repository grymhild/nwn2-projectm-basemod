//::///////////////////////////////////////////////
//:: Flame Strike
//:: NW_S0_FlmStrike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A flame strike is a vertical column of divine fire
// roaring downward. The spell deals 1d6 points of
// damage per level, to a maximum of 15d6. Half the
// damage is fire damage, but the rest of the damage
// results directly from divine power and is therefore
// not subject to protection from elements (fire),
// fire shield (chill shield), etc.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 19, 2000
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
// ChazM 7/18/07 - Fire and Holy effect order swapped. (GetDamageDealtByType() will not return Fire damage)

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_flamestrike();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FLAME_STRIKE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_FLAMESTRIKE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower(oCaster, 15);
	int nFireDamage;
	int nDivineDamage;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_HIT_SPELL_FLAMESTRIKE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	int iDC = HkGetSpellSaveDC();
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	effect eDam;
	effect eFireVis = EffectVisualEffect(iHitEffect);  // NWN2 VFX
	effect eDivineVis = EffectVisualEffect(VFX_HIT_SPELL_DIVINATION);
	location lTarget = HkGetSpellTargetLocation();
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( iShapeEffect ), lTarget);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	while (GetIsObjectValid(oTarget))
	{
		if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE )
		{
			CSLEnviroBurningStart( 10, oTarget );
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroIgniteAOE( iDC, oTarget );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FLAME_STRIKE, TRUE ));
			if (!HkResistSpell(oCaster, oTarget, 0.6))
			{
				nFireDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower) / 2; // SPLITS THIS BETWEEN FIRE & DIVINE
				nDivineDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nFireDamage, oTarget, iDC, SAVING_THROW_TYPE_DIVINE);
				if (nDivineDamage)
				{
					eDam = EffectDamage(nDivineDamage, DAMAGE_TYPE_DIVINE);
					DelayCommand(0.6, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(0.6, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDivineVis, oTarget));
				}
				nFireDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nFireDamage, oTarget, iDC, iSaveType);
				if (nFireDamage)
				{
					eDam = HkEffectDamage(nFireDamage, iDamageType);
					DelayCommand(0.6, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(0.6, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFireVis, oTarget));
				}
			}
			CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
		}
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
	}
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////////////////////////////////
//::
//::  nw_s0_metswarm_creature.nss
//::
//::  This is the spell script for the "target-creature" version of Meteor Swarm.
//::
//::///////////////////////////////////////////////////////////////////////////
//::
//::  Created by: Brian Fox
//::  Created on: 7/13/06
//::  Modified by: Constant Gaw
//::
//::///////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




int DetermineFireDamageForTargetCreature(object oTarget, int nTouchAttackRanged)
{
	int iDamage = HkApplyMetamagicVariableMods(d6(6), 36);
	if (nTouchAttackRanged==TOUCH_ATTACK_RESULT_MISS)
	{
		iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(),SAVING_THROW_TYPE_FIRE);
	}
	else
	{
		iDamage = HkApplyTouchAttackCriticalDamage(oTarget, nTouchAttackRanged, iDamage, SC_TOUCHSPELL_RANGED );
	}
	return iDamage;     
}

int DetermineBluntDamageForTargetCreature(object oTarget, int nTouchAttackRanged)
{
	if ( nTouchAttackRanged==TOUCH_ATTACK_RESULT_MISS ) { return 0; }
	int iDamage = HkApplyMetamagicVariableMods(d6(2), 12);
	iDamage = HkApplyTouchAttackCriticalDamage(oTarget, nTouchAttackRanged, iDamage, SC_TOUCHSPELL_RANGED );
	return iDamage;     
}

effect DetermineFireEffect(object oTarget, int nTouchAttack, int iDamageType )
{
	int iDamage = DetermineFireDamageForTargetCreature(oTarget, nTouchAttack);
	return EffectDamage(iDamage, iDamageType, DAMAGE_POWER_ENERGY);
}

effect DetermineBluntEffect(object oTarget, int nTouchAttack)
{
	int iDamage = DetermineBluntDamageForTargetCreature(oTarget, nTouchAttack); 
	return EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY);
}

void main()
{
	//scSpellMetaData = SCMeta_SP_meteorswarm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_METEOR_SWARM_TARGET_LOCATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	object oTarget = HkGetSpellTarget();
	if (!CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) return;
	
	location lSourceLoc = GetLocation(oCaster);
	location lTargetLoc = GetLocation(oTarget);
	int iDC = HkGetSpellSaveDC();
	int iDamage;
	int nBluntDamage;
	int nDamageMainTarget;
	int nBluntDamageMainTarget;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_TREMENDOUS);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	effect eBlunt;
	effect eFire;
	effect eBlunt2;
	effect eFire2;
	effect eBlunt3;
	effect eFire3;
	effect eBlunt4;
	effect eFire4;
	effect eVis = EffectNWN2SpecialEffectFile("sp_meteor_swarm_tiny_imp.sef"); // makes use of NWN2 VFX
	effect eVis2 = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM_LRG);  // makes use of NWN2 VFX
	effect eShake = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );
	int nCounter;
	int i;
	int nTouchAttack;
	float fDelay = 6.0 / 4;
	
	float fTravelTime = GetProjectileTravelTime( lSourceLoc, lTargetLoc, PROJECTILE_PATH_TYPE_DEFAULT );
	
	if (!HkResistSpell(oCaster, oTarget, 0.5))
	{
		for (i=1;i<=4;i++)
		{
			nTouchAttack = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
			eFire = DetermineFireEffect(oTarget, nTouchAttack, iDamageType);
			eBlunt = DetermineBluntEffect(oTarget, nTouchAttack);
			DelayCommand((fDelay * i) + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
			DelayCommand((fDelay * i) + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBlunt, oTarget));
			DelayCommand((fDelay * i) + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
			DelayCommand((fDelay * i) + fTravelTime, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShake, lTargetLoc));
			DelayCommand( fDelay * i, SpawnSpellProjectile(oCaster, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM_TARGET_CREATURE, PROJECTILE_PATH_TYPE_DEFAULT));
		}
	}
	
	object oTarget2 = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTargetLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
	while (GetIsObjectValid(oTarget2))
	{
		
		if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroIgniteAOE( iDC, oTarget );
		}
		else if (oTarget2!=oTarget)
		{
			if (CSLSpellsIsTarget(oTarget2, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oTarget2, EventSpellCastAt(oCaster, SPELL_METEOR_SWARM, TRUE));
				if (!HkResistSpell(oCaster, oTarget2, 0.5))
				{
					for (i=1;i<=4;i++)
					{
						eFire = DetermineFireEffect(oTarget2, TOUCH_ATTACK_RESULT_MISS, iDamageType);
						DelayCommand( (fDelay * i) + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget2));
						DelayCommand( (fDelay * i) + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget2));
					}
				}
				CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
			}
			
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE )
		{
			CSLEnviroBurningStart( 10, oTarget );
		}
		oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTargetLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	}
	
	HkPostCast(oCaster);
}

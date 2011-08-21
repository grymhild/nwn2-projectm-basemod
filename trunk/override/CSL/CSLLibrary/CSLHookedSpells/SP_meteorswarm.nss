//::///////////////////////////////////////////////
//:: Meteor Swarm
//:: NW_S0_MetSwarm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Everyone in a 50ft radius around the caster
	takes 20d6 fire damage.  Those within 6ft of the
	caster will take no damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 24 , 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: 6/21/06 - BDF-OEI: modified to use NWN2 VFX

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




// stubs for possible extensions to the targeting
void HandleTargetSelf();
void HandleTargetCreature();
void HandleTargetLocation();

void main()
{
	//scSpellMetaData = SCMeta_SP_meteorswarm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_METEOR_SWARM_TARGET_SELF;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = CSLGetMax(20, HkGetSpellPower( OBJECT_SELF, 20 ) ); // Making it so we can boost it via empowerment

	//Declare major variables
	int iMetaMagic;
	int iDamage;
	int iDC = HkGetSpellSaveDC();
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_METEOR_SWARM );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eFire;
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE); // no longer using NWN1 VFX
	effect eVis = EffectVisualEffect( iHitEffect ); // makes use of NWN2 VFX
	//Get first object in the spell area
	//    float fTravelDelay;
	// float fHitDelay;
	
	location lSourceLoc = GetLocation( OBJECT_SELF );
	location lTargetLoc;
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	int nCounter = 0;
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	while(GetIsObjectValid(oTarget))
	{
		if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE )
		{
			CSLEnviroBurningStart( 10, oTarget );
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroIgniteAOE( iDC, oTarget );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_METEOR_SWARM));
			//Make sure the target is outside the 2m safe zone
			if (GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0)
			{
				//Make SR check
				if (!HkResistSpell(OBJECT_SELF, oTarget, 0.5))
				{
					lTargetLoc = GetLocation( oTarget );
					float fTravelTime = GetProjectileTravelTime( lSourceLoc, lTargetLoc, nPathType );
					float fDelay;// = CSLRandomBetweenFloat( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCounter));
					if ( nCounter == 0 ) fDelay = 0.0f;
					else fDelay = CSLRandomBetweenFloat( 0.1f, 0.5f ) + (0.5f * IntToFloat(nCounter));
					nCounter++;
					
					//Roll damage
					iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6*iSpellPower );
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC,iSaveType);
					//Set the damage effect
					eFire = HkEffectDamage(iDamage, iDamageType);
					if(iDamage > 0)
					{
						//Apply damage effect and VFX impact.
						DelayCommand( fDelay, SpawnSpellProjectile(OBJECT_SELF, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM, nPathType) );
						DelayCommand( fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget) );
						DelayCommand( fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );
					}
				}
				CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
			}
		}
		//Get next target in the spell area
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
	}
	
	HkPostCast(oCaster);
}

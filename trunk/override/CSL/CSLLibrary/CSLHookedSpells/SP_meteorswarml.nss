//::///////////////////////////////////////////////////////////////////////////
//::
//::  nw_s0_metswarm_other.nss
//::
//::  This is the spell script for the "target-location" version of Meteor Swarm.
//::

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Evocation"





void main()
{
	//scSpellMetaData = SCMeta_SP_meteorswarm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_METEOR_SWARM_TARGET_CREATURE;
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
	object oTarget = HkGetSpellTarget();
	if (oTarget==oCaster) oTarget=OBJECT_INVALID;
	location lSpellTargetLocation = HkGetSpellTargetLocation();

	SCExecuteDefaultMeteorSwarmBehavior(oTarget, lSpellTargetLocation);
	int iDC = HkGetSpellSaveDC();
	int iDamage;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_VAST);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eFire;
	effect eVis;
	effect eBump = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);

	location lSourceLoc = GetLocation(oCaster);
	location lTargetLoc;
	int i;
	float fDelay = 6.0f / IntToFloat( SCGetNumMeteorSwarmProjectilesToSpawnA(lSpellTargetLocation) );
	float fDelay2 = 0.0f;
	float fTravelTime;

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lSpellTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	while (GetIsObjectValid(oTarget)) {
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
			SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_METEOR_SWARM, TRUE ) );
			if (!HkResistSpell(oCaster, oTarget, 0.5))
			{
				lTargetLoc = GetLocation(oTarget);
				fTravelTime = GetProjectileTravelTime(lSourceLoc, lTargetLoc, PROJECTILE_PATH_TYPE_DEFAULT);
				if (GetLocalInt(oTarget, "MeteorSwarmCentralTarget"))
				{
					i = 3;
					eVis = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM_SML);  // makes use of NWN2 VFX
				}
				else if (GetLocalInt(oTarget, "MeteorSwarmNormalTarget"))
				{
					i = 4;
					eVis = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM_SML);  // makes use of NWN2 VFX
				}
				else
				{
					i = 4;
					eVis = EffectVisualEffect(VFX_HIT_SPELL_METEOR_SWARM);   // makes use of NWN2 VFX
				}
				for (i;i<=4;i++)
				{
					if (GetLocalInt(oTarget, "MeteorSwarmCentralTarget") || GetLocalInt(oTarget, "MeteorSwarmNormalTarget"))
					{
						iDamage = HkApplyMetamagicVariableMods(d6(12), 72);
					}
					else
					{
						iDamage = HkApplyMetamagicVariableMods(d6(6), 36);
					}
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
					eFire = HkEffectDamage(iDamage, iDamageType, DAMAGE_POWER_ENERGY);
					if (iDamage)
					{
						DelayCommand( fDelay2 + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
						DelayCommand( fDelay2 + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
						DelayCommand( fDelay2 + fTravelTime, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eBump, lTargetLoc));
					}
					DelayCommand(fDelay2, SpawnSpellProjectile(oCaster, oTarget, lSourceLoc, lTargetLoc, SPELL_METEOR_SWARM, PROJECTILE_PATH_TYPE_DEFAULT));
					fDelay2 += fDelay;
				}
			}
			CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
			DeleteLocalInt(oTarget, "MeteorSwarmCentralTarget");
			DeleteLocalInt(oTarget, "MeteorSwarmNormalTarget");
		}
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lSpellTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
	}
	
	HkPostCast(oCaster);
}

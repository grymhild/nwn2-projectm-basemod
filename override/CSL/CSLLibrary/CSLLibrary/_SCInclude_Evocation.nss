/** @file
* @brief Include File for Evocation Magic
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



//::///////////////////////////////////////////////
//:: _SCInclude_Evocation.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Include file for Evocations
*/
//:://////////////////////////////////////////////
// ChazM 1/2/07 Added Placeholder effect for CSLEffectFatigue()
// ChazM 1/8/07 removed CSLEffectFatigue(), changed includes

//#include "_SCUtility"

#include "_HkSpell"
#include "_CSLCore_Messages"
#include "_CSLCore_Position"



/*
	-Bigby's Interposing Hand (x0_s0_bigby1)
	-Bigby's Forceful Hand (x0_s0_bigby2)
	-Bigby's Grasping Hand (x0_s0_bigby3)
	-Bigby's Clenched Fist (x0_s0_bigby4)
	-Bigby's Crushing Hand (x0_s0_bigby5)

*/

const int VFX_HIT_BIGBYS_CLENCHED_FIST = 837;

/*
//void main(){}
void SCEffectFireBall( location lTarget, int nHitDice = 10, int iDamageType = DAMAGE_TYPE_FIRE, object oCaster = OBJECT_SELF  );

//* fires a storm of nCap missiles at targets in area
//void SCDoMissileStorm(int nD6Dice, int nCap, int iSpellId, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE, int nMaxHits = 10 );
void SCDoMissileStorm(int nD6Dice, int nCap, int iSpellId, int nVIS = VFX_IMP_MAGBLUE, int iDamageType = DAMAGE_TYPE_MAGICAL, int iReflexSaveType = -1, int nMaxHits = 10 );
int SCRollMissileDamage(object oTarget, int nD6Dice, int iMetaMagic, int iReflexSaveType);
void SCShootMissilesAtTarget(object oTarget, location lSourceLoc, location lTargetLoc, int iSpellId, int nPathType, int nMissilesForThisTarget, effect eVis, float fDelay, int nCnt, int nD6Dice, int iDamageType, int iMetaMagic, int iReflexSaveType);


// * Does a stinking cloud. If oTarget is Invalid, then does area effect, otherwise
// * just attempts on otarget
void SCStinkingCloud(object oTarget = OBJECT_INVALID, int iSaveDC = 15);


// * Generic apply area of effect Wrapper
// * lTargetLoc = where spell was targeted
// * fRadius = RADIUS_SIZE_ constant
// * iSpellId
// * eImpact = ring impact
// * eLink = Linked effects to apply to targets in area
// * eVis
void SCspellsGenericAreaOfEffect( object oCaster, location lTargetLoc, int nShape, float fRadiusSize, int iSpellId, effect eImpact, effect eLink, effect eVis, int iDurationType=DURATION_TYPE_INSTANT, float fDuration = 0.0, int nTargetType=SCSPELL_TARGET_ALLALLIES, int bHarmful = FALSE, int nRemoveEffectSpell=FALSE, int nRemoveEffect1=0, int nRemoveEffect2=0, int nRemoveEffect3=0, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, int bPersistentObject=FALSE, int bResistCheck=FALSE, int nSavingThrowType=SCSAVING_THROW_NONE, int nSavingThrowSubType=SAVING_THROW_TYPE_ALL );
*/

int AdjustPiercingColdDamage(int nDam, object oTgt)
{		
	int nDamage = nDam;
	if (GetIsObjectValid(oTgt))
	{
		int PercentVuln = 0;
	    effect eVuln = GetFirstEffect(oTgt);	
	    while (GetIsEffectValid(eVuln))
	    {
			if (GetEffectType(eVuln) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE)
			{
				int nDamageType = GetEffectInteger(eVuln, 0);	//Dmg Type
				if (nDamageType == DAMAGE_TYPE_COLD)
				{
					int iVuln = GetEffectInteger(eVuln, 1);	 //Vuln %
					PercentVuln += iVuln;
				}				
			}
	        eVuln = GetNextEffect(oTgt);
	    }	
			
		object oChest = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTgt);
		if (GetIsObjectValid(oChest))
		{
			int iHasVuln = GetItemHasItemProperty(oChest, ITEM_PROPERTY_DAMAGE_VULNERABILITY);	
			if (iHasVuln)
			{	
				int iTable;
				int iTableVal;
				int iSubType;
				itemproperty ip = GetFirstItemProperty(oChest);
				while (GetIsItemPropertyValid(ip))
				{	
					iTable = GetItemPropertyCostTable(ip); // 22 = Dmg Vuln Table
					iSubType = GetItemPropertySubType(ip); //Dmg Type
					
					if (iTable == 22 && iSubType == IP_CONST_DAMAGETYPE_COLD)	
					{		
						iTableVal = GetItemPropertyCostTableValue(ip); //Vuln %
						if (iTableVal == 4)
							PercentVuln += 50;
						else
						if (iTableVal == 7)
							PercentVuln += 100;	
						else
						if (iTableVal == 3)
							PercentVuln += 25;
						else
						if (iTableVal == 1)
							PercentVuln += 5; 
						else
						if (iTableVal == 5)
							PercentVuln += 75;
						else
						if (iTableVal == 6)
							PercentVuln += 90;
						else
						if (iTableVal == 2)
							PercentVuln += 10;																										
					}													
					ip = GetNextItemProperty(oChest);
				}
			}
		}
		
		if (PercentVuln > 100)
		{
			PercentVuln = 100;	
		}
			
		if (PercentVuln > 0)
		{
			nDamage = nDamage + (nDamage * PercentVuln / 100);
		}
	}
	return nDamage;
}

void SCDoCreepingCold(object oCaster, object oTarget, int iDamageType, int iNumDice, int iSave, int iSpellId, int iMetaMagic)
{
	if (CSLGetDelayedSpellEffectsExpired(iSpellId, oTarget, oCaster)) return; // IF SPELL EFFECT IS GONE, DON'T CONTINUE DOING DAMAGE
	
	int nHasPierceCold = FALSE;
	if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD, oCaster ))
	{
		//iDamage = AdjustPiercingColdDamage(iDamage, oTarget);
		nHasPierceCold = TRUE;
	}
	
	int iDamage = HkApplyMetamagicVariableMods(d6(iNumDice), 6 * iNumDice, iMetaMagic );
	
	//if (iSave)
	//{
	//	iDamage /= 2;
	//}
	iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_COLD, oCaster, iSave );
	if ( iDamage > 0 )
	{
		effect eLink = EffectVisualEffect( CSLGetHitEffectByDamageType(iDamageType) );
		eLink = EffectLinkEffects(eLink, HkEffectDamage(iDamage, iDamageType, DAMAGE_POWER_NORMAL, nHasPierceCold, oTarget, oCaster ) );
		
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	}
}

object SCGetElectricalTargetInShape(  location lTarget, object oCaster = OBJECT_SELF, float fRadius = RADIUS_SIZE_TREMENDOUS, int iShape = SHAPE_SPHERE, int iHostileSetting = SCSPELL_TARGET_SELECTIVEHOSTILE  )
{
	int iConductivity, iMainConductivity;
	object oMainTarget;
	// find next rounds target
	object oTarget = GetFirstObjectInShape(iShape, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE  );
	{
		if ( !GetLocalInt( oTarget , "SC_BOLT") && oTarget != oCaster )
		{
			if ( CSLSpellsIsTarget( oTarget, iHostileSetting, oCaster ) )
			{
				iConductivity = GetLocalInt( oTarget , "SC_ITEM_CONDUCTIVITY")+d20(6); // this makes it pretty random
				if ( iConductivity > iMainConductivity )
				{
					oMainTarget = oTarget;
					iMainConductivity = iConductivity;
				}
			}
		}
		oTarget = GetNextObjectInShape(iShape, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE  );
	}
	
	
	// this prevents over saturation of targets, only one per round and 50/50 on if can hit twice in a row same target
	CSLIncrementLocalInt(oTarget, "SC_BOLT", 1);
	DelayCommand ( 4.0f+CSLRandomUpToFloat(48.0f), CSLDecrementLocalInt_Void(oTarget, "SC_BOLT", 1, TRUE) );
	
	return oMainTarget;
}


void SCDoLightningEffectsInArea(object oCaster, location lTarget, int iNumDice, int iDieSize, int iSpellId, int iMaxToHit, float fStrikeInterval, int iMetaMagic, int bFirstRound = TRUE)
{
	if( iMaxToHit < 1 || !GetIsObjectValid(oCaster) || GetIsDead(oCaster) || GetAreaFromLocation(lTarget) != GetArea( oCaster ) || GetIsResting( oCaster ) )
	{
		return;
	}
	
	if ( GetLocalInt( GetArea(oCaster), "SC_WEATHERCALMED" ) )
	{
		return;
	}
	
	if ( bFirstRound || ( GetCurrentAction( oCaster ) != ACTION_CASTSPELL  &&  GetCurrentAction( oCaster ) != ACTION_DISABLETRAP &&  GetCurrentAction( oCaster ) != ACTION_OPENLOCK && GetCurrentAction( oCaster ) != ACTION_ITEMCASTSPELL && GetCurrentAction( oCaster ) != ACTION_COUNTERSPELL ) )
	{
		effect eDam;
		location lStrikeLocation;
		int bDoStrike = FALSE;
		int iDamage;
		
		object oTempTarget = GetPlayerCurrentTarget(oCaster);
		object oTarget;
		if ( GetIsObjectValid( oTempTarget ) && CSLIsClose(oCaster,oTempTarget,RADIUS_SIZE_TREMENDOUS) )
		{
			if ( !GetLocalInt( oTempTarget , "SC_BOLT") && oTempTarget != oCaster )
			{
				oTarget = oTempTarget;
				CSLIncrementLocalInt(oTarget, "SC_BOLT", 1);
				DelayCommand ( 4.0f+CSLRandomUpToFloat(48.0f), CSLDecrementLocalInt_Void(oTarget, "SC_BOLT", 1, TRUE) );

			}
		}
		
		
		if ( !GetIsObjectValid( oTarget ) || oTarget == oCaster  ) // && d2() == 1
		{
			oTarget = SCGetElectricalTargetInShape( lTarget, oCaster );
		}
		
	
		if ( GetIsObjectValid(oTarget) && oTarget != oCaster ) // move the bolt to hit the first target
		{
			lStrikeLocation = GetLocation(oTarget);
			bDoStrike = TRUE;
		}
		else if ( d4() == 1 ) // will do strikes sometimes even if no target is around
		{
			
			if ( GetIsLocationValid( lTarget ) )
			{
				if (DEBUGGING >= 2) { CSLDebug( "lTarget = "+CSLSerializeLocation( lTarget ), oCaster ); }
				lStrikeLocation = CSLGetRandomLocationAroundLocation(RADIUS_SIZE_VAST, lTarget, FALSE );
				bDoStrike = TRUE;
			}
			else
			{
				if (DEBUGGING >= 2) { CSLDebug( "lTarget not valid = "+CSLSerializeLocation( lTarget ), oCaster ); }
				bDoStrike = FALSE;
			}
			
			
		}
			//bDoStrike = TRUE;
			//lStrikeLocation = GetLocation(oCaster);
		/*
		int iTargetState = CSLEnviroLocationGetStatus( lStrikeLocation );
			
		if ( iTargetState & CSL_ENVIRO_WATER ) // get depth if any
		{
			float fWaterHeight = CSLEnviroGetWaterHeightAtLocation( lStrikeLocation );
			if ( fWaterHeight == 0.0f )
			{
				iTargetState &= ~CSL_ENVIRO_WATER;
			}
			else
			{
				vector vPosition = GetPositionFromLocation( lStrikeLocation );
				if (  fWaterHeight < vPosition.z )
				{
					iTargetState &= ~CSL_ENVIRO_WATER;
				}
			}
		}
		
		if ( iTargetState & CSL_ENVIRO_WATER )
		{
			bDoStrike = FALSE;
		}
		*/
		
		
		
		if ( bDoStrike )
		{
			float fDelay;
			int iSave;
			int iShapeEffect = CSLPickOneInt(VFXSC_FX_LIGHTNINGSTRIKE1, VFXSC_FX_LIGHTNINGSTRIKE2, VFXSC_FX_LIGHTNINGSTRIKE3, VFXSC_FX_LIGHTNINGSTRIKE4, VFXSC_FX_LIGHTNINGSTRIKE5, VFXSC_FX_LIGHTNINGSTRIKE6 );
			ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(iShapeEffect), lStrikeLocation );
			
			object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lStrikeLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
			while (GetIsObjectValid(oTarget))
			{
				
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
				{
					SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ) );
					
					fDelay = CSLRandomBetweenFloat(0.05f, 0.45f);
					if (!HkResistSpell(oCaster, oTarget, fDelay))
					{
				
						
						iDamage = HkApplyMetamagicVariableMods( CSLDieX(iDieSize, iNumDice), iDieSize * iNumDice, iMetaMagic );
						iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(oCaster,oTarget), SAVING_THROW_TYPE_ELECTRICITY, oCaster );
						if(iDamage > 0)
						{
							eDam = EffectDamage(iDamage, DAMAGE_TYPE_ELECTRICAL );
							// Apply effects to the currently selected target.
							DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							
							DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_HIT_SPELL_LIGHTNING ), oTarget));
						}
					}
				}
				
				oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lStrikeLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );	
			}
		
		}
	}
	
	iMaxToHit--;
	
	DelayCommand( CSLRandomBetweenFloat( fStrikeInterval-2.0f, fStrikeInterval+2.0f), SCDoLightningEffectsInArea( oCaster, lTarget, iNumDice, iDieSize, iSpellId, iMaxToHit, fStrikeInterval, iMetaMagic, FALSE ) );
}






//creeping cold function
void SCEffectCreepingCold(int iNumDice, int iSave, object oTarget, object oCaster, int iMetaMagic)
{
	
	int nDmgType = DAMAGE_TYPE_COLD;
	int nHasPierceCold = FALSE;
	int iDamage = HkApplyMetamagicVariableMods(d6(iNumDice), 6 * iNumDice);
	if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD, oCaster ))
	{
		//iDamage = AdjustPiercingColdDamage(iDamage, oTarget);
		nHasPierceCold = TRUE;
	}
	
	//if (iSave == 1)
	//{
	//	//Reduce damage based on fort save?
	//	if (GetHasFeat(FEAT_METTLE, oTarget) ) //Mettle
	//	{
	//		iDamage = 0;
	//	}
	//	else
	//	{
	//		iDamage = iDamage/2;
	//	}
	//}
	iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_COLD, oCaster, iSave );			
	effect eDam = HkEffectDamage(iDamage, nDmgType, DAMAGE_POWER_NORMAL, nHasPierceCold, oTarget, oCaster );
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	effect eLink = EffectLinkEffects(eDam, eVis);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
}


void SCDoStinkingCloud(object oTarget, object oSource, int iSaveDC, effect eVis, effect eStink)
{
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
		SignalEvent(oTarget, EventSpellCastAt(oSource, GetSpellId(), TRUE));
		if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_POISON))
		{
			if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
			{
				float fDelay = CSLRandomBetweenFloat(0.75, 1.75);
				//Apply the VFX impact and linked effects
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStink, oTarget, RoundsToSeconds(2), GetSpellId()));
			}
		}
	}
}


// * Does a stinking cloud. If oTarget is Invalid, then does area effect, otherwise
// * just attempts on otarget
//
// BrianH - OEI: 04/22/2006 - changed to use own logic rather than GenericAOE. SaveDC is now passed in.
void SCStinkingCloud(object oTarget = OBJECT_INVALID, int iSaveDC = 15)
{
	effect eStink = EffectDazed();
	effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); // NWN1 VFX
	effect eLink = EffectLinkEffects(eMind, eStink);
	//eLink = EffectLinkEffects(eLink, eDur);   // NWN1 VFX

	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_CONJURATION);

	if (GetIsObjectValid(oTarget) == TRUE)
	{
		SCDoStinkingCloud(oTarget, OBJECT_SELF, iSaveDC, eVis, eStink);
	}
	else
	{
		oTarget = GetFirstInPersistentObject();
		while (GetIsObjectValid(oTarget))
		{
			SCDoStinkingCloud(oTarget, OBJECT_SELF, iSaveDC, eVis, eStink);
			oTarget = GetNextInPersistentObject();
		}
	}
}



// designed to vary the damage done in the sphere, and the damage effect
/*
float RADIUS_SIZE_SMALL           =  1.524f; // ~5 feet
float RADIUS_SIZE_MEDIUM          =  3.048f; // ~10 feet
float RADIUS_SIZE_LARGE           =  4.572f; // ~15 feet
float RADIUS_SIZE_HUGE            =  6.069f; // ~20 feet
float RADIUS_SIZE_GARGANTUAN      =  7.620f; // ~25 feet
float RADIUS_SIZE_COLOSSAL        =  9.144f; // ~30 feet
float RADIUS_SIZE_TREMENDOUS	  =  12.191f; // ~40 feet	CG-OEI 7/16/2006
float RADIUS_SIZE_GINORMOUS	 	  =  15.240f; // ~50 feet	AFW-OEI 04/24/2006
float RADIUS_SIZE_VAST			  =  18.288f; // ~60 feet	CG-OEI 7/16/2006
float RADIUS_SIZE_ASTRONOMIC	  =  24.384f; // ~80 feet   CG-OEI 7/16/2006


/*
// Create a Beam effect.
// - nBeamVisualEffect: VFX_BEAM_*
// - oEffector: the beam is emitted from this creature
// - nBodyPart: BODY_NODE_*
// - bMissEffect: If this is TRUE, the beam will fire to a random vector near or
//   past the target
// * Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nBeamVisualEffect is
//   not valid.
effect EffectBeam(int nBeamVisualEffect, object oEffector, int nBodyPart, int bMissEffect=FALSE);

// Brock H. - OEI 04/12/06
// Creates a projectile that uses effects values based on a spell.  This does not actually do damage or have any combat impact, 
// it simply creates a visual effect. 
// Use PROJECTILE_PATH_TYPE_DEFAULT to use the pathing values for that spell
void SpawnSpellProjectile( object oSource, object oTaget, location lSource, location lTarget, int iSpellId, int iProjectilePathType );


// Brock H. - OEI 04/12/06
// Creates a projectile that uses the models and effects for weapons. This does not actually do damage or have any combat impact, 
// it simply creates a visual effect. 
// Currently, the only damage type flags supported are Acid, Cold, Electrical, Fire, and Sonic. 
// nBaseItemID - This is the row in the baseitemtypes.2DA that defines the launcher for this projectile. It is used to determine the ammunition type for the projectile
// iProjectilePathType - must be PROJECTILE_PATH_TYPE_* from above
// iAttackType - This must be OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, PARRIED, CRITICAL_HIT, or MISS             
// nDamageTypeFlag - Used to attach a visual to the projectile. Supported types are DAMAGE_TYPE_ACID, COLD, ELECTRICAL, FIRE, DIVINE, SONIC     
void SpawnItemProjectile( object oSource, object oTaget, location lSource, location lTarget, int nBaseItemID, int iProjectilePathType, int iAttackType, int nDamageTypeFlag );

// * Create a Visual Effect that can be applied to an object.
// - nVisualEffectId
// - nMissEffect: if this is TRUE, a random vector near or past the target will
//   be generated, on which to play the effect
effect EffectVisualEffect(int nVisualEffectId, int nMissEffect=FALSE);
*/



// * float fSize default to RADIUS_SIZE_HUGE, 1.524f is 5 feet,  designed to use the constant sizes of RADIUS_SIZE_SMALL=5,
// *        RADIUS_SIZE_MEDIUM=10, RADIUS_SIZE_LARGE=15, RADIUS_SIZE_HUGE=20, RADIUS_SIZE_GARGANTUAN=25, RADIUS_SIZE_COLOSSAL=30,
// *        RADIUS_SIZE_TREMENDOUS=40, RADIUS_SIZE_GINORMOUS=50, RADIUS_SIZE_VAST=60, RADIUS_SIZE_ASTRONOMIC=80
// * int iDescriptor controls the type of damage done
// * int iNumDice  is how many hit dice or how many dice will be rolled, using 0 will make it so no dice are rolled
// * int iDiceType is the size of said dice, which can be normal dice sizes or non standard ones
// * int iIntegerDamage  is the additional damage, if iNumDice is 0, this is used instead, if iNumDice is more than 0 this is added to it, if both are 0 no damage is done.
// * effect iEffect  additional damage effect which can be piped in
void SCEffectShapeSphere( location lTarget, float fSize=RADIUS_SIZE_HUGE, int iDescriptor=0, int iNumDice = 0, int iDiceType = SC_DIETYPE_D6, int iIntegerDamage = 0 )
{
   //SendMessageToAllDMs("Bunny Script Running");
	
	//string sProjSEF = 'sp_fireball'; // sLowProjSEF
	//string sImpactSEF = 'sp_fireball_hit_aoe'; // sLowImpactSEF // actual SEF Files
	
	//string ProjType = 'homing';
	
	
	object oCaster = OBJECT_SELF;
	//int nHitDice = 5;
	int iDamage;
	float fDelay;
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
	effect eDam;
	effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	//ActionCastFakeSpellAtLocation( SPELL_FIREBALL)
	//ActionCastFakeSpellAtLocation(SPELL_GREATER_FIREBURST, GetLocation(OBJECT_SELF) );
	//	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT )
	//nw_c2_default7
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oTarget))
	{
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALL, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL, TRUE ));
			//Get the distance between the explosion and the target to calculate delay
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
			{
				//Roll damage for each target
				iDamage = CSLDieX( iDiceType, iNumDice) + iIntegerDamage; //d6(nHitDice);
				//Resolve metamagic
				
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
				//Set the damage effect
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
				if(iDamage > 0)
				{
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					//This visual effect is applied to the target object not the location as above.  This visual effect
					//represents the flame that erupts on the target not on the ground.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
		}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}

}


void SCEffectFireBall( location lTarget, int nHitDice = 10, int iDamageType = DAMAGE_TYPE_FIRE, object oCaster = OBJECT_SELF, float fRadius = RADIUS_SIZE_HUGE  )
{
   //SendMessageToAllDMs("Bunny Script Running");
	int iDamage;
	float fDelay;
	effect eVis = EffectVisualEffect( CSLGetImpactEffectByDamageType(iDamageType) );
	effect eDam;
	effect eExplode = EffectVisualEffect( CSLGetAOEExplodeByDamageType(iDamageType, fRadius) );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	
	int iSaveType = CSLGetSaveTypeByDamageType(iDamageType);
	int iDC = HkGetSpellSaveDC();
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	while (GetIsObjectValid(oTarget))
	{
		if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE )
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL, TRUE ));
			CSLEnviroBurningStart( 10, oTarget );
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroIgniteAOE( iDC, oTarget );
		}
		else if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALL, oCaster))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FIREBALL, TRUE ));
			//Get the distance between the explosion and the target to calculate delay
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{
				//Roll damage for each target
				iDamage = d6(nHitDice);
				//Resolve metamagic
				
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType );
				//Set the damage effect
				eDam = EffectDamage(iDamage, iDamageType);
				if(iDamage > 0)
				{
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					//This visual effect is applied to the target object not the location as above.  This visual effect
					//represents the flame that erupts on the target not on the ground.
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
			CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
		}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT );
	}
}






/*
effect CSLEffectFatigue()
{
	//what will this do???  it is a mystery
	
	// placeholder effect
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	return (eVis);
}
*/
//********************************
// Missile Storm functions
//********************************


// int nD6Dice - dice to roll per missile
// int iMetaMagic - MetaMagic used
// int iReflexSaveType - A SAVING_THROW_TYPE_* constant, or -1 if no reflex save allowed.
int SCRollMissileDamage(object oTarget, int nD6Dice, int iMetaMagic, int iReflexSaveType)
{
	//Roll damage
	int iDamage = HkApplyMetamagicVariableMods(d6(nD6Dice), 6 * nD6Dice);
	// Jan. 29, 2004 - Jonathan Epp
	// Reflex save was not being calculated for Firebrand
	if(iReflexSaveType != -1)
	{
		iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iReflexSaveType);
	}
	return (iDamage);
}

// oTarget, lSourceLoc, lTargetLoc, iSpellId, nPathType - spell projectile params
// int nMissilesForThisTarget - Number of missiles to shoot
// effect eVis - Visual impact effect
// float fDelay - Delay for the projectile travel time.
// int nCnt - the count of enemies processed (used for delaying/spreading out the impacts)
// int nD6Dice - dice to roll per missile
// int iDamageType - The Type of Damage being applied
// int iMetaMagic - MetaMagic used
// int iReflexSaveType - A SAVING_THROW_TYPE_* constant, or -1 if no reflex save allowed.

void SCShootMissilesAtTarget(object oTarget, location lSourceLoc, location lTargetLoc, int iSpellId, int nPathType, int nMissilesForThisTarget, effect eVis, float fDelay, int nCnt, int nD6Dice, int iDamageType, int iMetaMagic, int iReflexSaveType) {
	object oCaster = OBJECT_SELF;
	float fTime    = fDelay + ((nCnt - 1) * 0.25);
	float fTime2   = ((nCnt - 1) * 0.25);
	effect eDam;
	int nDam;
	int bMantle = HkHasSpellAbsorption(oTarget);
	int bResist = HkResistSpell(oCaster, oTarget, fDelay); // DO THIS ONCE OUTSIDE LOOP TO REMOVE THE MANTLE LEVELS & CHECK SR
	for (nCnt=1; nCnt <= nMissilesForThisTarget; nCnt++)
	{
		if (nCnt!=1 && !bMantle) bResist = HkResistSpell(oCaster, oTarget, fDelay); // DO THIS ON 2nd+ LOOP ONLY IF THEY HAVE NO MANTLE TO DO SR CHECK PER MISSLE
		DelayCommand(fTime2, SpawnSpellProjectile(oCaster, oTarget, lSourceLoc, lTargetLoc, iSpellId, nPathType) );
		if (!bResist && !bMantle) { // ONLY APPLY DAMAGE IF THEY HAVE NO MANTLE AND FAILED SR CHECK
			nDam = SCRollMissileDamage(oTarget, nD6Dice, iMetaMagic, iReflexSaveType);
			if (iSpellId == SPELL_ISAACS_LESSER_MISSILE_STORM ||iSpellId == SPELL_ISAACS_GREATER_MISSILE_STORM )
			{
				eDam = EffectDamage(nDam/2, iDamageType);
				nDam = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nDam/2, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_ALL);
				if (nDam) eDam = EffectLinkEffects(eDam, EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING));        
			}
			else
			{
				eDam = EffectDamage(nDam, iDamageType);
			}
			eDam = EffectLinkEffects(eDam, eVis);
			DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		}
	}
}

//::///////////////////////////////////////////////
//:: SCDoMissileStorm
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Fires a volley of missiles around the area
	of the object selected.

	Each missiles (nD6Dice)d6 damage.
	There are casterlevel missiles (to a cap as specified)
*/

// int nD6Dice    - Dice of damage (d6) each missile does
// int nCap    - The max number of missiles that can be fired
// int iSpellId  - Spell id
// int nVIS    - Visual impact effect to use
// int iDamageType - type of damage
// int iReflexSaveType - A SAVING_THROW_TYPE_* constant, or -1 if no reflex save allowed.
// int nMaxHits - Maximum number of hits any one target.
void SCDoMissileStorm(int nD6Dice, int nCap, int iSpellId, int nVIS = VFX_IMP_MAGBLUE, int iDamageType = DAMAGE_TYPE_MAGICAL, int iReflexSaveType = -1, int nMaxHits = 10 ) {
	//SpawnScriptDebugger();

	location lTargetLoc  = GetSpellTargetLocation(); // missile spread centered around target location
	location lSourceLoc = GetLocation( OBJECT_SELF );

	int iSpellId   = GetSpellId();
	int iMetaMagic = GetMetaMagicFeat();
	effect eVis    = EffectVisualEffect(nVIS);

	float fDelay   = 0.0;
	int nMissiles  = HkGetSpellPower(OBJECT_SELF, nCap); // GetCappedCasterLevel(nCap);
	int nPathType  = PROJECTILE_PATH_TYPE_BURST;
	int nEnemies   = CSLCountEnemies(lTargetLoc, RADIUS_SIZE_GARGANTUAN, nMissiles); // how many enemies (up to max number of missiles)

	// * Exit if no enemies to hit
	if (nEnemies == 0) return;

		// divide the missles evenly amongst the enemies;
	int nMissilesPerTarget = nMissiles / nEnemies;
	int nExtraMissiles     = nMissiles % nEnemies;

	int nMissilesForThisTarget = 0;
	location lThisTargetLoc;
	int nCnt = 1; // # of enemies processed

	//Cycle through the targets within the spell shape until an invalid object is captured.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTargetLoc, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget) && nCnt <= nEnemies) {
		// * caster cannot be harmed by this spell
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && (oTarget != OBJECT_SELF) && (GetObjectSeen(oTarget,OBJECT_SELF))) {
			lThisTargetLoc = GetLocation( oTarget );
			fDelay = GetProjectileTravelTime( lSourceLoc, lThisTargetLoc, nPathType );

			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE ));

			// * determine the number of missles to fire at this target
			nMissilesForThisTarget = nMissilesPerTarget;
			if (nCnt <= nExtraMissiles) nMissilesForThisTarget++;

			// ensure we observe cap
			nMissilesForThisTarget = CSLGetWithinRange(nMissilesForThisTarget, 0, nMaxHits);

			if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay)) {
				DelayCommand( 0.0f, SCShootMissilesAtTarget(oTarget, lSourceLoc, lThisTargetLoc, iSpellId, nPathType, nMissilesForThisTarget, eVis, fDelay, nCnt, nD6Dice, iDamageType, iMetaMagic, iReflexSaveType) );
			}

			nCnt++;// * increment count of enemies processed
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTargetLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
}


// 7/13/06 - BDF: this helper function takes care of the default graphical appearance of the spell Meteor Swarm;
void SCExecuteDefaultMeteorSwarmBehavior( object oTarget, location lTarget )
{
	// Major variables
	location lCaster = GetLocation( OBJECT_SELF );
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_METEOR_SWARM );
	float fTravelTime;
	float fLocationDistance;
	location lAhead, lBehind, lLeft, lRight, lFlankingLeft, lFlankingRight, lAheadLeft, lAheadRight;
	object oAheadWP, oBehindWP, oLeftWP, oRightWP, oFlankingLeftWP, oFlankingRightWP, oAheadLeftWP, oAheadRightWP;
	int bDestroyoTarget = FALSE;
	
	if ( !GetIsObjectValid(oTarget) )   // Just in case the object that was passed isn't valid (i.e. when targeting the ground)
	{
		// Create the waypoint that will act as the centerpoint for the projectile swarm
		oTarget = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lTarget );
		bDestroyoTarget = TRUE;
	}
	
	float fDelay = 6.0f / IntToFloat(8);   // 6.0 is the duration of the bombardment;
											// 8 is the number of meteors that will spawn regardless of targets
	float fDelay2 = 0.0f;
		
	lAhead = CSLGetAheadLocation( oTarget );
	lBehind = CSLGetBehindLocation( oTarget );
	lRight = CSLGetRightLocation( oTarget );
	lLeft = CSLGetLeftLocation( oTarget );
	lAheadLeft = CSLGetAheadLeftLocation( oTarget );
	lAheadRight = CSLGetAheadRightLocation( oTarget );
	lFlankingLeft = CSLGetFlankingLeftLocation( oTarget );
	lFlankingRight = CSLGetFlankingRightLocation( oTarget );

	fTravelTime = GetProjectileTravelTime( lCaster, lAhead, nPathType );
	oAheadWP = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lAhead );
	DelayCommand( fDelay2, SpawnSpellProjectile(OBJECT_SELF, oAheadWP, lCaster, lAhead, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lAhead) );
	
	fTravelTime = GetProjectileTravelTime( lCaster, lBehind, nPathType );
	oBehindWP = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lBehind );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oBehindWP, lCaster, lBehind, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lBehind) );
	
	fTravelTime = GetProjectileTravelTime( lCaster, lLeft, nPathType );
	oLeftWP = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lLeft );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oLeftWP, lCaster, lLeft, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLeft) );
	
	fTravelTime = GetProjectileTravelTime( lCaster, lRight, nPathType );
	oRightWP = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lRight );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oRightWP, lCaster, lRight, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lRight) );

	fTravelTime = GetProjectileTravelTime( lCaster, lAheadLeft, nPathType );
	oAheadLeftWP = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lAheadLeft );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oAheadLeftWP, lCaster, lAheadLeft, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lAheadLeft) );

	fTravelTime = GetProjectileTravelTime( lCaster, lAheadRight, nPathType );
	oAheadRightWP = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lAheadLeft );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oAheadRightWP, lCaster, lAheadRight, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lAheadRight) );

	fTravelTime = GetProjectileTravelTime( lCaster, lFlankingLeft, nPathType );
	oFlankingLeftWP = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lFlankingLeft );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oFlankingLeftWP, lCaster, lFlankingLeft, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lFlankingLeft) );
	
	fTravelTime = GetProjectileTravelTime( lCaster, lFlankingRight, nPathType );
	oFlankingRightWP = CreateObject( OBJECT_TYPE_WAYPOINT, SCRESREF_DEFAULT_WAYPOINT, lFlankingRight );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oFlankingRightWP, lCaster, lFlankingRight, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lFlankingRight) );
	
	// Cleanup the placeholder waypoints
	if ( bDestroyoTarget )
	{
		DelayCommand( (fDelay2 += 0.1f), DestroyObject(oTarget) );
	}
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oAheadWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oBehindWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oLeftWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oRightWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oFlankingLeftWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oFlankingRightWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oAheadLeftWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oAheadRightWP) );
}

// 7/13/06 - BDF: this helper function determine the number of meteors to spawn;
int SCGetNumMeteorSwarmProjectilesToSpawnA( location lCenterOfAOE )
{
	float fRadiusSize;
	int i;
	int nCounter = 0;
	location lTargetLocation;
	object oTarget;
		
	oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, lCenterOfAOE );
		
	while ( GetIsObjectValid(oTarget) )
	{
		lTargetLocation = GetLocation(oTarget);
		
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
		{
			//if (!HkResistSpell(OBJECT_SELF, oTarget, 0.5))
			{    
				if ( GetDistanceBetweenLocations(lTargetLocation, lCenterOfAOE) <= (RADIUS_SIZE_VAST / 3.0f) )
				{
					nCounter = nCounter + 2;
					SetLocalInt(oTarget, "MeteorSwarmCentralTarget", 1);
				}
				
				else if ( GetDistanceBetweenLocations(lTargetLocation, lCenterOfAOE) <= (RADIUS_SIZE_VAST / 2.0f) )
				{
					nCounter = nCounter+1;
					SetLocalInt(oTarget, "MeteorSwarmNormalTarget", 1);           
				}
				
				else
				{
					nCounter++;            
				}          
			}
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, lCenterOfAOE );
	}
		
	if ( nCounter == 0 )
	{
		return 1;
	}
		
	return nCounter;
}

int SCGetNumMeteorSwarmProjectilesToSpawnB( location lCenterOfAOE )
{
	float fRadiusSize;
	int i;
	int nCounter = 0;
	location lTargetLocation;
	object oTarget;
		
	oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lCenterOfAOE );
			
	while ( GetIsObjectValid(oTarget) )
	{
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
		{
			if (!HkResistSpell(OBJECT_SELF, oTarget, 0.5))
			{
				if ( GetLocation(OBJECT_SELF) == lCenterOfAOE )
				{
					if (GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0)
					{
							nCounter++;
					}
				}
										
				else
				{
					nCounter++;
				}          
			}
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lCenterOfAOE );
	}
		
	if ( nCounter == 0 )
	{
		return 1;
	}
			
	return nCounter;
}


// * generic area of effect constructor
void SCspellsGenericAreaOfEffect( object oCaster, location lTargetLoc, int nShape, float fRadiusSize, int iSpellId, effect eImpact, effect eLink, effect eVis, int iDurationType=DURATION_TYPE_INSTANT, float fDuration = 0.0, int nTargetType=SCSPELL_TARGET_ALLALLIES, int bHarmful = FALSE, int nRemoveEffectSpell=FALSE, int nRemoveEffect1=0, int nRemoveEffect2=0, int nRemoveEffect3=0, int bLineOfSight=FALSE, int nObjectFilter=OBJECT_TYPE_CREATURE, int bPersistentObject=FALSE, int bResistCheck=FALSE, int nSavingThrowType=SCSAVING_THROW_NONE, int nSavingThrowSubType=SAVING_THROW_TYPE_ALL )
{
	//Apply Impact
	if (GetEffectType(eImpact) != 0)
	{
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTargetLoc);
	}

	object oTarget = OBJECT_INVALID;
	float fDelay = 0.0;

	//Get the first target in the radius around the caster
	if (bPersistentObject == TRUE)
			oTarget = GetFirstInPersistentObject();
	else
			oTarget = GetFirstObjectInShape(nShape, fRadiusSize, lTargetLoc, bLineOfSight, nObjectFilter);

	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, nTargetType, oCaster) == TRUE)
			{
				//Fire spell cast at event for target
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, bHarmful));
				int nResistSpellSuccess = FALSE;
				// * actually perform the resist check
				if (bResistCheck == TRUE)
				{
					nResistSpellSuccess = HkResistSpell(oCaster, oTarget);
				}
			if(!nResistSpellSuccess)
			{
					int nSavingThrowSuccess = FALSE;
					// * actually roll saving throw if told to
					if (nSavingThrowType != SCSAVING_THROW_NONE)
					{
						nSavingThrowSuccess = HkSavingThrow(nSavingThrowType, oTarget, HkGetSpellSaveDC(), nSavingThrowSubType);
					}
					if (!nSavingThrowSuccess)
					{
							fDelay = CSLRandomBetweenFloat(0.4, 1.1);
							//Apply VFX impact
							if (GetEffectType(eVis) != 0)
							{
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
							}

							// * Apply effects
						// if (GetEffectType(eLink) != 0)
						// * Had to remove this test because LINKED effects have no valid type.
							{

								DelayCommand(fDelay, HkApplyEffectToObject(iDurationType, eLink, oTarget, fDuration));
							}

							// * If this is a removal spell then perform the appropriate removals
							if (nRemoveEffectSpell == TRUE)
							{
								//Remove effects
								//SCRemoveSpecificEffect(nRemoveEffect1, oTarget);
								CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, nRemoveEffect1);
								if(nRemoveEffect2 != 0)
								{
									//SCRemoveSpecificEffect(nRemoveEffect2, oTarget);
										CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, nRemoveEffect2);
								}
								if(nRemoveEffect3 != 0)
								{
									//SCRemoveSpecificEffect(nRemoveEffect3, oTarget);
										CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, nRemoveEffect3);
								}

							}
					}// saving throw
				} // resist spell check
			}
			//Get the next target in the specified area around the caster
			if (bPersistentObject == TRUE)
			{
				oTarget = GetNextInPersistentObject();
			}
			else
			{
				oTarget = GetNextObjectInShape(nShape, fRadiusSize, lTargetLoc, bLineOfSight, nObjectFilter);
			}

	}
}








void SCBigApplyDamage(object oTarget, int iDice, int iBonus)
{
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(iDice)+iBonus, DAMAGE_TYPE_BLUDGEONING), oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_EVOCATION), oTarget);
}

void SCBigHandCheck(object oCaster, object oTarget, int iBonus, int iSpellId, int iDuration)
{
	if (CSLGetDelayedSpellEffectsExpired(iSpellId, oTarget, oCaster)) 
	{
		return; // VFX GONE, END THE SPELL
	}
	
	if (GetArea(oTarget)!=GetArea(oCaster)) 
	{
		return; // ANOTHER AREA
	}
	int iDice = 6;
	if (iSpellId==SPELL_BIGBYS_CLENCHED_FIST)
	{
		iDice = 8;
	}
	else if (iSpellId==SPELL_BIGBYS_CRUSHING_HAND)
	{
		iDice = 10;
	}
	if (!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC())) 
	{
		if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC())) 
		{
			if (CSLGetHasEffectType(oTarget, EFFECT_TYPE_DAZED ))
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 5.0);
				if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
				{
					CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  5.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
				}
			}
			else
			{
				effect eLink = EffectVisualEffect(VFX_DUR_SPELL_DAZE);
				eLink = EffectLinkEffects(eLink, EffectDazed());
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ); // APPLY DAZE FOR DURATION
			}
		}
	}
	else
	{
		iDice /= 2;
	}
	DelayCommand(0.8, SCBigApplyDamage(oTarget, iDice, iBonus));
	iDuration--;
	if (iDuration) DelayCommand(6.0, SCBigHandCheck(oCaster, oTarget, iBonus, iSpellId, iDuration));
}

void SCBigHands( int iSpellId = -1 )
{

	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	if (GetHasSpellEffect(SPELL_BIGBYS_GRASPING_HAND, oTarget) || GetHasSpellEffect(SPELL_BIGBYS_CLENCHED_FIST, oTarget) || GetHasSpellEffect(SPELL_BIGBYS_CRUSHING_HAND, oTarget)) {
		SendMessageToPC(oCaster, "Target already has a Bigby spell in effect.");
		return;
	}
	//int iSpellId = GetSpellId();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
		if (!HkResistSpell(oCaster, oTarget))
		{
			int iBonus = HkGetBestCasterModifier(oCaster, TRUE, FALSE);
			int iDuration = 3;
			int nVFX = VFX_DUR_BIGBYS_GRASPING_HAND;
			if (iSpellId==SPELL_BIGBYS_CLENCHED_FIST)
			{
				iDuration = 4;
				nVFX = VFX_HIT_BIGBYS_CLENCHED_FIST;
			}
			else if (iSpellId==SPELL_BIGBYS_CRUSHING_HAND)
			{
				iDuration = 5;
				nVFX = VFX_DUR_BIGBYS_CRUSHING_HAND;
			}
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nVFX), oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ); // APPLY BIGBY EFFECT FOR DURATION
			SCBigHandCheck(oCaster, oTarget, iBonus, iSpellId, iDuration); // MAKE PER ROUND CHECKS
		}
	}
}

void TLVFXPillar(int nVFX, location lStart, int nIterations=3, float fDelay=0.1f, float fZOffset= 6.0f, float fStepSize = -2.0f )
{
     vector vLoc = GetPositionFromLocation(lStart);
     vector vNew = vLoc;
     vNew.z += fZOffset;
     location lNew;
     int nCount;

     for (nCount=0; nCount < nIterations ; nCount ++)
     {
          lNew = Location(GetAreaFromLocation(lStart),vNew,0.0f);
          if (fDelay > 0.0f)
          {
              DelayCommand(fDelay*nCount, ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(nVFX),lNew));
          }
          else
          {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(nVFX),lNew);
          }
          vNew.z += fStepSize;
     }
}
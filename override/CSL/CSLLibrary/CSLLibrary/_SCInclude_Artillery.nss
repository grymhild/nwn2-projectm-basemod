/** @file
* @brief Include file for Artillery and Siege Engines
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



/*
Include for artillery

This has the following parameters.

Location for Artillery Piece
Location for Target


Can have multiple modes.

Direct Fire - Ballista or Cannon
Direct Attack - Battering ram
Lobbed Attack - Catapult or boulder item, mortar, etc.

It has Automatic and Manual Modes

Manual Mode
	This mode is done only by players.
	
	Location - Creature Catapult has movement controls of some sort
	Facing - They select the direction(facing) by rotating the catapult.
	Power - They select the power by cranking a winch which stores said power. ( Requires Strength Checks )
	Weight - Weight of the given bullet or item
	Wind Direction - Modifies the shot
	Wind Power - controls how much wind can affect shot
	Wind Variability - random variance affecting each shot
	
	

Automatic Mode, based on engineering skills, gnomish mastery, and intelligence ( knowing the math )
	First Shot is ranging the shot, adjusting angle and the like. Second is generally an overshot, then it divides it to get an accurate shot.
	Basically the first shot is assumed to be only on a natural 20, with 50% over or under, followed by a roll to hit based on how close the last shot was until it finds a location.

	
	Fired shot is sent to target on a trajectory and to the given location. Items along the path are looked for to find anything that interupts the shot. If that happens the bullet hits that target instead.
	Walls of stone, iron, etc can block catapult bullets
	Giants can catch bullets and throw them back
	Bullet can roll or deflect as well
	
	SEF is the projectile animation, whatever that might be
	Payload is effect on target hit



*/

/*

void main()
{
	//scSpellMetaData = SCMeta_FT_bouldertoss();
	//Do damage here...//354 for impact
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	effect eImpact = EffectVisualEffect(354);
	int iDamage;
	location lImpact = GetSpellTargetLocation();
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lImpact);
	RockDamage(lImpact);
}
void RockDamage(location lImpact)
{
	float fDelay;
	int iDamage;
	effect eDam;
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_CUBE, RADIUS_SIZE_HUGE, lImpact, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Cycle through the targets within the spell shape until an invalid object is captured.

	while (GetIsObjectValid(oTarget))
	{
			if (!GetPlotFlag(oTarget))
			{
				//Get the distance between the explosion and the target to calculate delay
				fDelay = GetDistanceBetweenLocations(lImpact, GetLocation(oTarget))/20;
				//Roll damage for each target, but doors are always killed
				if  (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
					iDamage = 55;
				else
					iDamage = d6(3)+5;
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
				iDamage = HkGetReflexAdjustedDamage(iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
				//Set the damage effect
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING);
				if(iDamage > 0)
				{
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				}
			//Select the next target within the spell shape.
			}
			oTarget = GetNextObjectInShape(SHAPE_CUBE, RADIUS_SIZE_HUGE, lImpact, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}
*/



#include "_CSLCore_Position"
#include "_CSLCore_UI"
#include "_CSLCore_Visuals"

// display the artillery view
void SCArtillery_Display( object oTargetToDisplay, object oPC = OBJECT_SELF, string sScreenName = SCREEN_ARTILLERY )
{
	if ( !GetIsObjectValid( oTargetToDisplay) )
	{
		CloseGUIScreen( oPC,sScreenName );
		return;
	}

	DisplayGuiScreen(oPC, sScreenName, FALSE, XML_ARTILLERY);
}




/*
  Drag is dependent on speed in a non-obvious way.
  This is the result of the British 1909 firings.
  Converted to metric units by OHK.
  Other drag functions may be substituted at will
*/
/*
float SCDragResist_British(float fVelocity )
{
    if (fVelocity > 7.9248E+02)
	{
		return 3.406205170590E-03*pow(fVelocity,1.67);
	}	
    else if (fVelocity > 6.096E+02)
	{
		return 1.059525135209E-02*pow(fVelocity,1.5);
	}	
    else if (fVelocity > 4.45008E+02)
	{
		return 1.547358255244E-03*pow(fVelocity,1.8);
	}	
    else if (fVelocity > 3.62712E+02)
	{
		return 1.026963165037E-06*pow(fVelocity,3.0);
	}	
    else if (fVelocity > 3.16992E+02)
	{
		return 1.517245393852E-15*pow(fVelocity,6.45);
	}	
    else if (fVelocity > 2.56032E+02)
	{
		return 6.451780264672E-07*pow(fVelocity,3.0);
	}	
    return 1.518071962790E-03*pow(fVelocity,1.6);
}
*/

/*
   These are the Mayevski functions, which is the basis for Ingalls' tables.
   Converted to US units by Ingalls, and back to metric by OHK.
*/
/*
float SCDragResist_Mayevski(float fVelocity)
{
    if (fVelocity > 7.924800000000E+02)
	{
		return 7.813394824668E-03 * pow(fVelocity,1.55);
	}	
    else if (fVelocity > 5.486400000000E+02)
	{
		return 2.866733530400E-03 * pow(fVelocity,1.7);
	}	
    else if (fVelocity > 4.175760000000E+02)
	{
		return 4.317622192537E-04 * pow(fVelocity,2.0);
	}	
    else if (fVelocity > 3.749040000000E+02)
	{
		return 1.030083367220E-06 * pow(fVelocity,3.0);
	}	
    else if (fVelocity > 2.956560000000E+02)
	{
		return 7.341948762102E-12 * pow(fVelocity,5.0);
	}
    else if (fVelocity > 2.407920000000E+02)
    {
		return 6.388708526449E-07 * pow(fVelocity,3.0);
	}
    return 1.534180425570E-04*pow(fVelocity,2.0);
}
*/

const int CSL_PROJECTILESLOWFACTOR = 3;
// oCannon is the object firing the munition
// fMaxDuration is both a safety, and it handles firing munitions with timers of some sort, by defaults it will only do 40 iterations regardless
// fTimeInterval how quickly to increment the spacing of the bursts, really should be just enough to make a solid trail so should vary based on velocity
//			this is pretty important as it is doing a lot of things usually done in C++ plus detecting targets at each spot, so a good interval is important
void SCFireProjectile( object oCannon, float fMaxDuration = 10.0f )
{
	float fElapsedTime = 0.0f; // starting time at 0.0, will handle the current timing
	
	
	
	location lCannonLoc = GetLocation( oCannon );
	location lProjectileLocation;
	object oArea = GetArea( oCannon );
	
	
	float fWindSpeed = GetLocalFloat( oArea, "CSLENVIRO_WINDSPEED" );
	float fWindDirection = GetLocalFloat( oArea, "CSLENVIRO_WINDDIRECTION" );
	float fWindForceCoefficient = GetLocalFloat( oArea, "CSLENVIRO_WINDCOEFFICIENT" );
	
	// CSLDefineLocalFloat will get works just like getlocalfloat unless the value is empty, in which case it sets and uses the default 
	float fAirDragCoefficient = CSLDefineLocalFloat( oArea, "CSLENVIRO_AIRDRAGCOEFFICIENT", 30.0f );
	float fCannonElevation = CSLDefineLocalFloat( oCannon, "CSLARTILLERY_ELEVATION", 45.0f );
	float fCannonVelocity = CSLDefineLocalFloat( oCannon, "CSLARTILLERY_VELOCITY", 50.0f );
	float fCannonLength = CSLDefineLocalFloat( oCannon, "CSLARTILLERY_CANNONLENGTH", 0.5f );
	float fProjectileMass = CSLDefineLocalFloat( oCannon, "CSLARTILLERY_PROJETILEMASS", 100.0f );
	
	// fCannonElevation is actually angle
	float fEstimatedDistance = CSLProjectileDistanceTraveled( fCannonElevation, fCannonVelocity, 15.0f );
	float fEstimatedDuration = CSLProjectileTimeofFlight( fCannonElevation, fCannonVelocity, fEstimatedDistance );
	
	// get the interval needed to make it so on average it travels 1 meter per interval
	float fTimeInterval = 0.1f;
	if ( fEstimatedDuration > 0.0f ) // block divide by zeros
	{
		fTimeInterval = fEstimatedDistance/fEstimatedDuration; // this should result in a lot of smoke puffs along trajectory, hopefully enough to be visible
	}
	fTimeInterval = CSLGetWithinRangef(fTimeInterval, 0.001f, 0.100f);
	int bHitTarget = FALSE;
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_SMALL_SMOKEPUFF), lCannonLoc);
	
	//DelayCommand( fElapsedTime,SendMessageToPC( GetFirstPC(), " fCannonElevation="+FloatToString(fCannonElevation)+" fCannonVelocity="+FloatToString(fCannonVelocity)+" fCannonLength="+FloatToString(fCannonLength)+" fProjectileMass="+FloatToString(fProjectileMass)+" fAirDragCoefficient="+FloatToString(fAirDragCoefficient)+" "+CSLSerializeVector(GetPositionFromLocation( lCannonLoc )) ) );
	
	// ideas are, get distance to last location, divide by 2, use that as the radius to detect creatures and the like, assuming distance is small
	
	// auto adjusting interval
	// if distance is too small on first iteration, adjust the fTimeInterval to be larger
	// if distance is too great more than a single combat space ( 3-5.0m i am thinking reduce interval so it can't miss anything )
	
	// if mid flight impact, decide if blocked - high strength and caught, placeable, wall of force, net, or huge creature
	// if not blocked do a scatter to move target out of the way ( jump to location and knock down to small opponents
	
	// if impact do full impace script
	
	while ( bHitTarget == FALSE )
	{
		fElapsedTime += fTimeInterval;
		
		lProjectileLocation = CSLPlotProjectile( lCannonLoc, fElapsedTime, fCannonVelocity, fCannonElevation ); // fCannonElevation = fLaunchAngle
		
		//lProjectileLocation = CSLPlotProjectile( lCannonLoc, fElapsedTime, fCannonElevation, fCannonVelocity, fCannonLength, fProjectileMass, fWindSpeed, fWindDirection, fWindForceCoefficient, fAirDragCoefficient );
		
		if ( fElapsedTime > fMaxDuration )
		{
			bHitTarget = TRUE;
		}
		
		// slowing the appearance by a third soas to make the visual more obvious
		DelayCommand( fElapsedTime*CSL_PROJECTILESLOWFACTOR, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_SMALL_SMOKEPUFF), lProjectileLocation) );
		if( CSLGetZFromLocation(lProjectileLocation) <= CSLGetHeightAtLocation(lProjectileLocation) )
		{
			bHitTarget = TRUE;
		}
		
		//DelayCommand( fElapsedTime*CSL_PROJECTILESLOWFACTOR,SendMessageToPC( GetFirstPC(), "Interval "+FloatToString(fElapsedTime)+" "+CSLSerializeVector(GetPositionFromLocation( lProjectileLocation )) ) );
		if ( bHitTarget == TRUE )
		{
			//DelayCommand( (fElapsedTime*3), SendMessageToPC( GetFirstPC(), "BOOM"+" "+CSLSerializeVector(GetPositionFromLocation( lProjectileLocation )) ) );
			DelayCommand( (fElapsedTime*CSL_PROJECTILESLOWFACTOR), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_SMALL_FIRE), lProjectileLocation) );
			DelayCommand( ((fElapsedTime+0.25f)*CSL_PROJECTILESLOWFACTOR), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_HUGE_SMOKEPUFF), lProjectileLocation) );
			DelayCommand( ((fElapsedTime+0.50f)*CSL_PROJECTILESLOWFACTOR), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_HUGE_SMOKEPUFF), lProjectileLocation) );
			// do the boom effect here
		}
	}
}




//
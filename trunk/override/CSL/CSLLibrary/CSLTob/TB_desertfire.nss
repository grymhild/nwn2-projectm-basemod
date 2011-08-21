//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/28/2009									//
//	Title: TB_desertfire							//
//	Description: If you move at least 10 feet from	//
//	your original position, you deal an extra 1d6	//
//	points of fire damage with any attack you make	//
//	with a Desert Wind weapon.						//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void RunDesertFire(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "RUNDESERTFIRE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "RUNDESERTFIRE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}


	location lPC = GetLocation(oPC);
	location lLast = GetLocalLocation(oPC, "DesertFireLoc");

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6536);

	if ((GetLocalInt(oToB, "DesertWindStrike") == 1) && (GetDistanceBetweenLocations(lPC, lLast) >= FeetToMeters(10.0f)))
	{
		effect eFire = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		eFire = SupernaturalEffect(eFire);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 5.5f);
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, RunDesertFire( oPC, oToB, iSpellId, iSerial ));
}

void RunDesertFireLocation()
{
	object oPC = OBJECT_SELF;

	SetLocalLocation(oPC, "DesertFireLoc", GetLocation(oPC));
	DelayCommand(6.0f, RunDesertFireLocation());
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6506, oPC))
	{
		
		object oToB = CSLGetDataStore(oPC); // get the TOME
	
		RunDesertFire(); //Only runs if the effect is no longer on the player.
		DelayCommand(5.8f, RunDesertFireLocation());
	}
}

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	DelayCommand(6.0f, CheckLoopEffect(oPC, oToB)); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}
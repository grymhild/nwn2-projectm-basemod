//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/31/2009									//
//	Title: TB_devotedbulwa							//
//	Description: If damaged with a melee attack,	//
//	gain +1 AC for 6 seconds.						//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void DevotedBulwark(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "DEVOTEDBULWARK", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "DEVOTEDBULWARK" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	object oAttacker = GetLastDamager();
	object oAttacked = GetAttackTarget(oAttacker);

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6509);

	if ((oPC == oAttacked) && (GetDistanceBetween(oPC, oAttacker) <= CSLGetMeleeRange(oPC)))
	{
		int nMyHp = GetLocalInt(oToB, "DevotedBulwarkHP");
		int nMyHp2 = GetLocalInt(oToB, "DevotedBulwarkHP2");

		if (nMyHp > nMyHp2)
		{
			effect eBulwark = EffectACIncrease(1);
			eBulwark = SupernaturalEffect(eBulwark);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBulwark, oPC, 6.0f);
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, DevotedBulwark( oPC, oToB, iSpellId, iSerial ));
}

void RunDBHealth()
{
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);

	SetLocalInt(oToB, "DevotedBulwarkHP", GetCurrentHitPoints());
	DelayCommand(5.7f, SetLocalInt(oToB, "DevotedBulwarkHP2", GetCurrentHitPoints()));
	// Window of .2 seconds to determine if the PC has lost Hit points in the round.
	DelayCommand(6.0f, RunDBHealth());
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6509, oPC))
	{
		RunDBHealth();
		DelayCommand(5.8f, DevotedBulwark()); //Only runs if the effect is no longer on the player.
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
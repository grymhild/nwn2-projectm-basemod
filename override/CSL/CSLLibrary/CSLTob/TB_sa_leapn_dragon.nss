//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/26/2009									//
//	Title: TB_sa_leapn_dragon							//
//	Description: While you are in this stance, you //
// gain a +10-foot enhancement bonus on Taunt 		//
// checks. In addition, any jumps you make while //
// in this stance are considered running jumps.	//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void LeapingDragonStance( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "LEAPINGDRAGONSTANCE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "LEAPINGDRAGONSTANCE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,175))
	{
		effect eDragon = EffectSkillIncrease(SKILL_TAUNT, 10);
		eDragon = ExtraordinaryEffect(eDragon);

		SetLocalInt(oPC, "LeapingDragonStance", 1);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDragon, oPC, 6.0f);
		DelayCommand(6.0f, LeapingDragonStance(oPC, oToB, iSpellId, iSerial));
	}
	else DeleteLocalInt(oPC, "LeapingDragonStance");
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
	
	LeapingDragonStance(oPC, oToB);
}

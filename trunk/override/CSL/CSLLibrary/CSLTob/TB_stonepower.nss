//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 4/14/2009									//
//	Name: TB_stonepower								//
//	Description: Reduces attack by 5 and grants ten //
//	temporary hitpoints for six seconds.			//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void StonePower( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "STONEPOWER", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "STONEPOWER" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	effect eDecrease = EffectAttackDecrease(5);
	effect eHp = EffectTemporaryHitpoints(10);
	effect eStonePower = EffectLinkEffects(eDecrease, eHp);
	eStonePower = SupernaturalEffect(eStonePower);

	if (GetLocalInt(oToB, "StonePower") == 1)
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStonePower, oPC, 6.0f);
		DelayCommand(6.0f, StonePower(oPC, oToB, iSpellId, iSerial));
	}
	else FloatingTextStringOnCreature("<color=cyan>Stone Power mode was deactivated.</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
}



void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	if (GetLocalInt(oToB, "StonePower") == 0)
	{
		FloatingTextStringOnCreature("<color=cyan>*Stone Power mode activated.*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, FOG_COLOR_BLUE_DARK);
		SetLocalInt(oToB, "StonePower", 1);
		StonePower(oPC, oToB);
	}
	else if (GetLocalInt(oToB, "StonePower") == 1)
	{
		SetLocalInt(oToB, "StonePower", 0);
	}
}

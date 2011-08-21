//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: TB_sa_ironguard						//
//	Description: Stance; Applies a minus 4	//
//	penalty to attack rolls to an creature	//
//	that is not targeting the initiator of	//
//	this stance.							//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void RunLoop(float fRange, object oPC = OBJECT_SELF )
{
	location lPC = GetLocation(oPC);
	object oFoe;

	oFoe = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

	while (GetIsObjectValid(oFoe))
	{
		if ((GetIsReactionTypeHostile(oFoe, oPC)) && (GetAttackTarget(oFoe) != oPC) && (GetIsInCombat(oFoe)))
		{
			effect eMinus = EffectAttackDecrease(4);
			eMinus = ExtraordinaryEffect(eMinus);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMinus, oFoe, 6.0f);
			AssignCommand(oFoe, ClearAllActions(TRUE));
			AssignCommand(oFoe, ActionAttack(oPC));
		}
		oFoe = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
	}
}

void IronGuardsGlare( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "IRONGUARDSGLARE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "IRONGUARDSGLARE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,42))
	{
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		float fRange = CSLGetMeleeRange(oPC);

		if ((fRange < FeetToMeters(8.0f)) || (GetWeaponRanged(oWeapon)))
		{
			fRange = FeetToMeters(8.0f);
		}

		AssignCommand(oPC, RunLoop(fRange,oPC));
		DelayCommand(6.0f, IronGuardsGlare(oPC, oToB, iSpellId, iSerial));
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
	
	IronGuardsGlare(oPC, oToB);
}

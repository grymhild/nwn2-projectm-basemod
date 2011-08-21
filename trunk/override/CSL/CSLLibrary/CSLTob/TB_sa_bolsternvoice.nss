//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 6/19/2009							//
//	Title: TB_sa_bolsternvoice					//
//	Description: Stance; Grants allies +2 vs//
//	will saves and +4 vs fear effects.		//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void BolsteringVoice( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "BOLSTERINGVOICE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "BOLSTERINGVOICE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,189))
	{
		float fRange = FeetToMeters(60.0f);
		location lPC = GetLocation(oPC);
		object oFriend;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

		while (GetIsObjectValid(oFriend))
		{
			if ((!GetIsReactionTypeHostile(oFriend, oPC)) && (oFriend != oPC) && (GetObjectHeard(oPC, oFriend)))
			{
				effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);
				effect eFear = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_FEAR);
				effect eBolster = EffectLinkEffects(eWill, eFear);
				eBolster = ExtraordinaryEffect(eBolster);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolster, oFriend, 6.0f);
			}
			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		}
		DelayCommand(6.0f, BolsteringVoice(oPC, oToB, iSpellId, iSerial));
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
	
	BolsteringVoice(oPC, oToB);
}
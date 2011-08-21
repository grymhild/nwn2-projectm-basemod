//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/31/2009									//
//	Title: TB_ironheartaur								//
//	Description: While in an ironheart stance all	//
//	adjacent allies gain +2 saves.					//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void IronHeartAura(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "IRONHEARTAURA", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "IRONHEARTAURA" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6510);
	
	if ( hkStanceGetHasActive( oPC, STANCE_ABSOLUTE_STEEL, STANCE_DANCING_BLADE_FORM, STANCE_PUNISHING_STANCE, STANCE_SUPREME_BLADE_PARRY ) )
	{
		location lPC = GetLocation(oPC);
		float fRange = CSLGetGirth(oPC) + FeetToMeters(5.0f);

		object oFriend;
		float fDist;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

		while (GetIsObjectValid(oFriend))
		{
			fDist = GetDistanceBetween(oPC, oFriend);

			if ((fDist <= fRange) && (!GetIsReactionTypeHostile(oFriend, oPC)))
			{
				effect eSaves = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
				eSaves = ExtraordinaryEffect(eSaves);

				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSaves, oFriend, 6.0f);
			}

			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, IronHeartAura(oPC, oToB, iSpellId, iSerial));
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6510, oPC))
	{
		IronHeartAura(); //Only runs if the effect is no longer on the player.
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
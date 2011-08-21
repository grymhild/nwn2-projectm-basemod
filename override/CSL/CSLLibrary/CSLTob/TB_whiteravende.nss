//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: April Fool's Day 2009						//
//	Title: TB_whiteravende							//
//	Description: While in a White Raven stance if at//
//	least one ally is within 5 feet, gain +1 AC.	//
//	Additionally, while you wield a White Raven		//
//	weapon, they gain +1 AC.						//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_inc_variables"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void WhiteRavenDefense( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "WHITERAVENDEFENSE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "WHITERAVENDEFENSE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}	

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6513);

	if ( hkStanceGetHasActive(oPC,STANCE_BOLSTERING_VOICE,STANCE_LEADING_THE_CHARGE,STANCE_PRESS_THE_ADVANTAGE,STANCE_SWARM_TACTICS,STANCE_TACTICS_OF_THE_WOLF) )
	{
		float f8 = CSLGetGirth(oPC) + FeetToMeters(5.0f);
		float fRange = FeetToMeters(60.0f);
		float fDist;
		location lPC = GetLocation(oPC);
		object oFriend;

		oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);

		while (GetIsObjectValid(oFriend))
		{
			fDist = GetDistanceBetween(oPC, oFriend);

			if ((fDist <= f8) && (!GetIsReactionTypeHostile(oFriend, oPC)) && (oFriend != oPC))
			{
				object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

				if (TOBGetIsWhiteRavenWeapon(oWeapon) == TRUE)
				{
					effect eBuddyAC = EffectACIncrease(1);
					eBuddyAC = ExtraordinaryEffect(eBuddyAC);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuddyAC, oFriend, 6.0f);
				}

				if (GetLocalInt(oToB, "WhiteRavenDefense") == 0) //Needed because there's often more than one party member.
				{
					SetLocalInt(oToB, "WhiteRavenDefense", 1);
					DelayCommand(5.99f, SetLocalInt(oToB, "WhiteRavenDefense", 0));

					effect eAC = EffectACIncrease(1);
					eAC = ExtraordinaryEffect(eAC);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);
				}
			}
			oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC, TRUE);
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, WhiteRavenDefense(oPC, oToB, iSpellId, iSerial));
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6513, oPC))
	{
		WhiteRavenDefense( oPC, oToB ); //Only runs if the effect is no longer on the player.
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

//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/8/2009							//
//	Title: TB_sa_aura_of_good					//
//	Description: While you are in this 	//
// stance, you and any ally within 10 feet //
// of you both heal 4 points of damage with//
// each successful melee attack either of //
// you makes against an evil target. 		//
//////////////////////////////////////////////

	/*The healing portion of this stance is handled in bot9s_inc_maneuvers
	under the functions TOBDoAuraOfTriumph and TOBStrikeWeaponDamage. This script
	places combat overrides on the player and party memebers in order to take
	advantage of these functions.*/
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void AuraOfTriumph(int bPlayerControlled, object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "AURAOFTRIUMPH", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "AURAOFTRIUMPH" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	

	if (hkStanceGetHasActive(oPC,30))
	{
		object oParty;
		float fRange;
		int i;

		SetLocalInt(oPC, "AuraOfTriumph", 1); // Status check to prevent extra callbacks of this function from running.

		oParty = GetFirstFactionMember(oPC, bPlayerControlled); //I think PC in bPCOnly referrers to Player Controlled and not Player Character, based on my testing.
		i = 1;

		while (GetIsObjectValid(oParty))
		{
			fRange = FeetToMeters(10.0f);

			if ((oParty != oPC) && (GetDistanceBetween(oParty, oPC) - CSLGetGirth(oParty) <= fRange))
			{
				SetLocalInt(oParty, "ToB_Triumph", 1);
				AssignCommand(oParty, DelayCommand(6.0f, DeleteLocalInt(oParty, "ToB_Triumph")));
				SetLocalObject(oToB, "TriumphParty" + IntToString(i), oParty);
				i++;
			}

			if (GetLocalInt(oParty, "AuraOfTriumph") == 0) //In case more than one member of the party has this stance active.
			{
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oParty));
			}

			if (i > 7)
			{
				break;
			}

			oParty = GetNextFactionMember(oPC, bPlayerControlled);
		}

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else TOBManageCombatOverrides(TRUE); //Doesn't work when called from a loop and we're not checking too many variables.

		object oParty1 = GetLocalObject(oToB, "TriumphParty1");

		if (GetIsObjectValid(oParty1))
		{
			if (GetLocalInt(oParty1, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty1, TOBManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty1"));
		}

		object oParty2 = GetLocalObject(oToB, "TriumphParty2");

		if (GetIsObjectValid(oParty2))
		{
			if (GetLocalInt(oParty2, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty2, TOBManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty2"));
		}

		object oParty3 = GetLocalObject(oToB, "TriumphParty3");

		if (GetIsObjectValid(oParty3))
		{
			if (GetLocalInt(oParty3, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty3, TOBManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty3"));
		}

		object oParty4 = GetLocalObject(oToB, "TriumphParty4");

		if (GetIsObjectValid(oParty4))
		{
			if (GetLocalInt(oParty4, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty4, TOBManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty4"));
		}

		object oParty5 = GetLocalObject(oToB, "TriumphParty5");

		if (GetIsObjectValid(oParty5))
		{
			if (GetLocalInt(oParty5, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty5, TOBManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty5"));
		}

		object oParty6 = GetLocalObject(oToB, "TriumphParty6");

		if (GetIsObjectValid(oParty6))
		{
			if (GetLocalInt(oParty6, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty6, TOBManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty6"));
		}

		object oParty7 = GetLocalObject(oToB, "TriumphParty7");

		if (GetIsObjectValid(oParty7))
		{
			if (GetLocalInt(oParty7, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty7, TOBManageCombatOverrides(TRUE));

			DelayCommand(5.95f, DeleteLocalObject(oToB, "TriumphParty7"));
		}

		DelayCommand(6.0f, AuraOfTriumph(bPlayerControlled,oPC, oToB, iSpellId, iSerial));
	}
	else
	{
		DeleteLocalInt(oPC, "AuraOfTriumph");
		DeleteLocalObject(oToB, "TriumphParty1");
		DeleteLocalObject(oToB, "TriumphParty2");
		DeleteLocalObject(oToB, "TriumphParty3");
		DeleteLocalObject(oToB, "TriumphParty4");
		DeleteLocalObject(oToB, "TriumphParty5");
		DeleteLocalObject(oToB, "TriumphParty6");
		DeleteLocalObject(oToB, "TriumphParty7");
		TOBProtectedClearCombatOverrides(oPC);
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

	if (GetLocalInt(oPC, "AuraOfTriumph") == 0)
	{
		effect eTriumph = EffectVisualEffect(VFX_TOB_TRIUMPH);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTriumph, oPC, 6.0f);
		AuraOfTriumph(FALSE);

		if (!GetIsSinglePlayer()) //Multiplayer Support
		{
			AssignCommand(oPC, AuraOfTriumph(TRUE,oPC, oToB));
		}
	}
}
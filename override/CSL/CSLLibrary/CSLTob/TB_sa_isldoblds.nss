//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 7/17/2009							//
//	Title: TB_sa_isldoblds						//
//	Description: When you and an ally are	//
//	adjacent to a creature both of you		//
//	qualify for a flank against it.			//
//////////////////////////////////////////////
//#include "bot9s_combat_overrides"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void IslandOfBlades(int bPlayerControlled, object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "ISLANDOFBLADES", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "ISLANDOFBLADES" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,129))
	{
		object oParty, oFoe;
		float fRange;
		int i;

		SetLocalInt(oPC, "IslandOfBlades", 1); // Status check to prevent extra callbacks of this function from running.

		oParty = GetFirstFactionMember(oPC, bPlayerControlled); //I think PC in bPCOnly referrers to Player Controlled and not Player Character, based on my testing.
		i = 1;

		while (GetIsObjectValid(oParty))
		{
			oFoe = GetAttackTarget(oParty);
			fRange = CSLGetMeleeRange(oFoe);

			if ((oParty != oPC) && (GetDistanceBetween(oParty, oFoe) - CSLGetGirth(oFoe) <= fRange) && (GetDistanceBetween(oPC, oFoe) - CSLGetGirth(oFoe) <= fRange))
			{
				if (GetAttackTarget(oPC) == oFoe)
				{
					TOBOverrideFlank(oPC);
					DelayCommand(6.0f, TOBRemoveAttackRollOverride(oPC, 8));
				}

				TOBOverrideFlank(oParty);
				DelayCommand(6.0f, TOBRemoveAttackRollOverride(oParty, 8));
				SetLocalObject(oToB, "IoBParty" + IntToString(i), oParty);
				i++;
			}

			if (GetLocalInt(oParty, "IslandOfBlades") == 0) //In case more than one member of the party has this stance active.
			{
				DelayCommand(5.99f, TOBProtectedClearCombatOverrides(oParty));
			}

			oParty = GetNextFactionMember(oPC, bPlayerControlled);
		}

		if (GetLocalInt(oPC, "bot9s_overridestate") > 0)
		{
			//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
			//2 = Combat round is pending and the command has already been sent, do nothing.
		}
		else TOBManageCombatOverrides(TRUE); //Doesn't work when called from a loop and we're not checking too many variables.

		object oParty1 = GetLocalObject(oToB, "IoBParty1");

		if (GetIsObjectValid(oParty1))
		{
			if (GetLocalInt(oParty1, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty1, TOBManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty1");
		}

		object oParty2 = GetLocalObject(oToB, "IoBParty2");

		if (GetIsObjectValid(oParty2))
		{
			if (GetLocalInt(oParty2, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty2, TOBManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty2");
		}

		object oParty3 = GetLocalObject(oToB, "IoBParty3");

		if (GetIsObjectValid(oParty3))
		{
			if (GetLocalInt(oParty3, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty3, TOBManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty3");
		}

		object oParty4 = GetLocalObject(oToB, "IoBParty4");

		if (GetIsObjectValid(oParty4))
		{
			if (GetLocalInt(oParty4, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty4, TOBManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty4");
		}

		object oParty5 = GetLocalObject(oToB, "IoBParty5");

		if (GetIsObjectValid(oParty5))
		{
			if (GetLocalInt(oParty5, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty5, TOBManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty5");
		}

		object oParty6 = GetLocalObject(oToB, "IoBParty6");

		if (GetIsObjectValid(oParty6))
		{
			if (GetLocalInt(oParty6, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty6, TOBManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty6");
		}

		object oParty7 = GetLocalObject(oToB, "IoBParty7");

		if (GetIsObjectValid(oParty7))
		{
			if (GetLocalInt(oParty7, "bot9s_overridestate") > 0)
			{
				//1 = Combat round is active and therefore we're not starting another by clicking this stance again.
				//2 = Combat round is pending and the command has already been sent, do nothing.
			}
			else AssignCommand(oParty7, TOBManageCombatOverrides(TRUE));

			DeleteLocalObject(oToB, "IoBParty7");
		}

		DelayCommand(6.0f, IslandOfBlades(bPlayerControlled,oPC, oToB, iSpellId, iSerial));
	}
	else
	{
		DeleteLocalInt(oPC, "IslandOfBlades");
		DeleteLocalObject(oToB, "IoBParty1");
		DeleteLocalObject(oToB, "IoBParty2");
		DeleteLocalObject(oToB, "IoBParty3");
		DeleteLocalObject(oToB, "IoBParty4");
		DeleteLocalObject(oToB, "IoBParty5");
		DeleteLocalObject(oToB, "IoBParty6");
		DeleteLocalObject(oToB, "IoBParty7");
		TOBProtectedClearCombatOverrides(oPC);
		TOBRemoveAttackRollOverride(oPC, 8);
	}
}


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------

	if (GetLocalInt(oPC, "IslandOfBlades") == 0)
	{
		IslandOfBlades(FALSE,oPC);

		if (!GetIsSinglePlayer()) //Multiplayer Support
		{
			IslandOfBlades(TRUE,oPC);
		}
	}
}
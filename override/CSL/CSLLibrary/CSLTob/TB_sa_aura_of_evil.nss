//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 10/9/2009							//
//	Title: TB_sa_aura_of_evil					//
//	Description: While you are in this 	//
// stance, you drain hit points from your //
// allies. Every turn, deal 2 points of 	//
// damage to each ally with more than 2 hit//
// points that is within 10 feet. For each //
// ally who takes this damage, you heal 1 //
// point of damage. 					//
//////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void AuraOfTyranny(int bPlayerControlled, object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "AURAOFTYRANNY", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "AURAOFTYRANNY" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,31))
	{
		effect eTyranny = EffectDamage(2, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, TRUE);
		effect eHeal;
		object oParty;
		float fRange;
		int i;

		oParty = GetFirstFactionMember(oPC, bPlayerControlled); //I think PC in bPCOnly referrers to Player Controlled and not Player Character, based on my testing.
		i = 1;

		while (GetIsObjectValid(oParty))
		{
			fRange = FeetToMeters(10.0f);

			if ((oParty != oPC) && (GetDistanceBetween(oParty, oPC) - CSLGetGirth(oParty) <= fRange))
			{
				eHeal = TOBManeuverHealing(oPC, 1);

				AssignCommand(oParty, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eTyranny, oParty));//Assigned to prevent faction issues from popping up.
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
				i++;
			}

			if (i > 7)
			{
				break;
			}

			oParty = GetNextFactionMember(oPC, bPlayerControlled);
		}

		DelayCommand(6.0f, AuraOfTyranny(bPlayerControlled,oPC, oToB, iSpellId, iSerial));
	}
	else DeleteLocalInt(oPC, "AuraOfTyranny");
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
	
	effect eTriumph = EffectVisualEffect(VFX_TOB_TYRANNY);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTriumph, oPC, 6.0f);
	

	if (!GetIsSinglePlayer()) //Multiplayer Support
	{
		AssignCommand(oPC, AuraOfTyranny(TRUE,oPC, oToB));
	}
	else
	{
		AssignCommand(oPC, AuraOfTyranny(FALSE,oPC, oToB));
	}
}
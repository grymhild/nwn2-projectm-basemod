//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 5/17/2009								//
//	Title: TB_crusaderecov							//
//	Description: Initiates the recovery method	//
//	for a crusader's maneuvers.					//
//////////////////////////////////////////////////
//#include "bot9s_TB_crusaderecov"
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void CrusaderRecovery(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "CRUSADERRECOVERY", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "CRUSADERRECOVERY" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	
	int nHp = GetCurrentHitPoints(oPC);

	if (nHp < 1) // Death tends to gum up the works.
	{
		TOBClearRecoveryFlags();
		TOBDisableAll();
	}

	if (GetLocalInt(oToB, "AS_HaltCrCycle") == 1)
	{
		return; // For use in conjunction with Adaptive Style.
	}

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6538);

	if ((GetIsInCombat(oPC)) && (nHp > 0))
	{
		TOBGenerateReadiedManeuvers("B", 10);
		TOBGenerateReadiedManeuvers("C", 10);
		TOBGenerateReadiedManeuvers("STR", 20);

		string sScreen = "SCREEN_QUICK_STRIKE_CR";
		int nBoostLimit = GetLocalInt(oToB, "BCrLimit");
		int nCounterLimit = GetLocalInt(oToB, "CCrLimit");
		int nStrikeLimit = GetLocalInt(oToB, "STRCrLimit");
		int nTotal = nBoostLimit + nCounterLimit + nStrikeLimit;

		SetLocalInt(oToB, "CrLimit", nTotal);

		if (GetLocalInt(oToB, "EncounterR1") == 0) // First round of combat grants more maneuvers.
		{
			SetLocalInt(oToB, "EncounterR1", 1);
			TOBClearRecoveryFlags();
			TOBDisableAll();

			int nStarting;
			int nLevel = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);

			if (GetHasFeat(FEAT_EXTRA_GRANTED_MANEUVER, oPC))
			{
				nStarting += 1;
			}

			if (nLevel > 29)
			{
				nStarting += 5;
			}
			else if (nLevel > 19)
			{
				nStarting += 4;
			}
			else if (nLevel > 9)
			{
				nStarting += 3;
			}
			else nStarting += 2;

			if (nStarting > nTotal)
			{
				nStarting = nTotal;
			}

			int i;
			int nCheck;
			string sRandomManeuver;

			i = 1;

			while (i <= nStarting)
			{
				sRandomManeuver = TOBRandomManeuver(oToB);
				TOBClearCrusaderRecoveryFlag(sRandomManeuver);
				nCheck = GetLocalInt(oToB, "RRFCleared");

				if (nCheck == 1)
				{
					SetLocalInt(oToB, "RRFCleared", 0);
					SetGUIObjectDisabled(oPC, sScreen, sRandomManeuver, FALSE);
					i++;
				}
			}
		}
		else if (GetLocalInt(oToB, "EncounterR1") == 1)
		{
			int i;
			int nCheck;
			string sRandomManeuver;

			i = 1;

			while (i < 2) // Just one this round.
			{
				sRandomManeuver = TOBRandomManeuver(oToB);

				// If all of the Crusader's Maneuvers are enabled, clear em out and start over.
				if (TOBCheckWithheldManeuvers() == TRUE)
				{
					SetLocalInt(oToB, "EncounterR1", 0);
					DelayCommand(0.1f, CrusaderRecovery());
					return;
				}
				else TOBClearCrusaderRecoveryFlag(sRandomManeuver);

				nCheck = GetLocalInt(oToB, "RRFCleared");

				if (nCheck == 1)
				{
					SetLocalInt(oToB, "RRFCleared", 0);
					SetGUIObjectDisabled(oPC, sScreen, sRandomManeuver, FALSE);
					break;
				}
			}

			if ((GetHasFeat(FEAT_VITAL_RECOVERY)) && (GetLocalInt(oToB, "VitalRecovery") == 0))
			{
				int nMax = GetMaxHitPoints(oPC);
				int nHP = GetCurrentHitPoints(oPC);

				if (nHP < nMax) // Won't heal when we're at full HP.
				{
					int nHitDice = GetHitDice(oPC);
					effect eHeal = TOBManeuverHealing(oPC, 3 + nHitDice);

					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
					SetLocalInt(oToB, "VitalRecovery", 1);
				}
			}
		}

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
		DelayCommand(6.0f, CrusaderRecovery(oPC, oToB, iSpellId, iSerial ));
	}
	else
	{
		SetLocalInt(oToB, "EncounterR1", 0);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 0.1f);
		DelayCommand(0.1f, CrusaderRecovery( oPC, oToB, iSpellId, iSerial ));
	}
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6538, oPC))
	{		
		object oToB = CSLGetDataStore(oPC); // get the TOME
		CrusaderRecovery(); //Only runs if the effect is no longer on the player.
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
//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 8/21/2009									//
//	Title: TB_ct_fire_riposte							//
//	Description: When a creature successfully 		//
// strikes you with a melee or natural weapon, you //
// can use this maneuver to give yourself the 		//
// ability to make an immediate melee touch attack.//
// If your attack hits, your target takes 4d6 		//
// points of fire damage.							//
//////////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void FireRiposte(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "FIRERIPOSTE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "FIRERIPOSTE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkCounterGetHasActive(oPC,10))
	{
		object oAttacker = GetLastDamager();
		object oAttacked = GetAttackTarget(oAttacker);

		if ((oPC == oAttacked) && (GetDistanceBetween(oPC, oAttacker) - CSLGetGirth(oAttacker) <= FeetToMeters(8.0f)))
		{
			int nMyHp = GetLocalInt(oToB, "FireRiposteHP");
			int nMyHp2 = GetCurrentHitPoints();

			if (nMyHp > nMyHp2)
			{
				int nTouch = TouchAttackMelee(oAttacker);

				if (nTouch > 0)
				{
					effect eFire, eFireRiposte;
					effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

					if (nTouch == 1)
					{
						eFire = EffectDamage(d6(4), DAMAGE_TYPE_FIRE);
						eFireRiposte = EffectLinkEffects(eFire, eVis);

					}
					else //Crit
					{
						eFire = EffectDamage(d6(8), DAMAGE_TYPE_FIRE);
						eFireRiposte = EffectLinkEffects(eFire, eVis);
					}

					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFireRiposte, oAttacker);
					FloatingTextStringOnCreature("<color=cyan>*Fire Riposte!*</color>", oPC, TRUE, 5.0f, COLOR_CYAN, COLOR_BLUE_DARK);
					TOBRunSwiftAction(10, "C");
				}
			}
			else DelayCommand(0.1f, FireRiposte(oPC, oToB, iSpellId, iSerial));
		}
		else DelayCommand(0.1f, FireRiposte(oPC, oToB, iSpellId, iSerial));
	}
}

void RunRoundHealth( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "RUNROUNDHEALTH", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "RUNROUNDHEALTH" );
	}
	
	
	if (hkCounterGetHasActive(oPC,10))
	{
		SetLocalInt(oToB, "FireRiposteHP", GetCurrentHitPoints());
		DelayCommand(6.0f, RunRoundHealth(oPC, oToB, iSpellId, iSerial));
	}
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

	TOBExpendManeuver(10, "C");
	SetLocalInt(oToB, "FireRiposteHP", GetCurrentHitPoints());
	DelayCommand(6.0f, RunRoundHealth(oPC, oToB));
	FireRiposte(oPC, oToB);
}
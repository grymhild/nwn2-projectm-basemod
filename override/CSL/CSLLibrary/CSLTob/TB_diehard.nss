///////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 5/15/2009										//
//	Name: TB_diehard									//
//	Description: When reduced to below 0 hitpoints the PC//
//	automatically heals one hit point.					//
///////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void Diehard(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "DIEHARD", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "DIEHARD" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}


	int nHp = GetCurrentHitPoints(oPC);

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6533);

	if (nHp >= 0)
	{
		SetLocalInt(oToB, "DiehardFlag", 0);
	}

	if ((nHp < 0) && (GetLocalInt(oToB, "DiehardFlag") == 0))
	{
		effect eHeal = EffectHeal(1);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
		SetLocalInt(oToB, "DiehardFlag", 1);
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, Diehard( oPC, oToB, iSpellId, iSerial ));
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6533, oPC))
	{
		Diehard(); //Only runs if the effect is no longer on the player.
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
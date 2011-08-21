//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 5/15/2009										//
//	Name: TB_indomitables									//
//	Description: Gratns a bonus to the Crusader's will	//
//	based on the Crusader's CHA modifier.				//
//////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void IndomitableSoul(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "INDOMITABLESOUL", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "INDOMITABLESOUL" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6536);

	if (!GetHasFeat(FEAT_DIVINE_GRACE, oPC) && !GetHasFeat(FEAT_PRESTIGE_DARK_BLESSING, oPC))
	{
		int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);

		if (nCha > 0)
		{
			effect eSoul = EffectSavingThrowIncrease(SAVING_THROW_WILL, nCha);
			eSoul = SupernaturalEffect(eSoul);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSoul, oPC, 6.0f);
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, IndomitableSoul(oPC, oToB, iSpellId, iSerial));
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6536, oPC))
	{
		IndomitableSoul(); //Only runs if the effect is no longer on the player.
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
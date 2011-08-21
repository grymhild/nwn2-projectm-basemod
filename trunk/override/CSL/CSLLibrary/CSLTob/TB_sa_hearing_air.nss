//////////////////////////////////////////
// Author: Drammel						//
// Date: 9/15/2009						//
// Title: TB_sa_hearing_air				//
// Description: Grants the feat Keen	//
//	Senses while the Stance is active.	//
//////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void HearingTheAir( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "HEARINGTHEAIR", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "HEARINGTHEAIR" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,61))
	{
		if (!GetHasFeat(FEAT_KEEN_SENSE, oPC))
		{
			CSLWrapperFeatAdd(oPC, FEAT_KEEN_SENSE, FALSE);
		}

		effect eAir = EffectSkillIncrease(SKILL_LISTEN, 5);
		eAir = ExtraordinaryEffect(eAir);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAir, oPC, 6.0f);
		DelayCommand(6.0f, HearingTheAir(oPC, oToB, iSpellId, iSerial));
	}
	else if (GetRacialType(oPC) != RACIAL_TYPE_ELF)
	{
		FeatRemove(oPC, FEAT_KEEN_SENSE);
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
	
	HearingTheAir(oPC, oToB);
}

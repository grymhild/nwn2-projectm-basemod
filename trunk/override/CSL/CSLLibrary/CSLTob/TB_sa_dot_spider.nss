//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 8/27/2009							//
//	Title: TB_sa_dot_spider					//
//	Description: Grants a bonus to Move		//
// Silently that makes it equal to your 	//
// skill in Hide.							//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void DanceOfTheSpider( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "DANCEOFTHESPIDER", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "DANCEOFTHESPIDER" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,122))
	{
		int nHide = GetSkillRank(SKILL_HIDE, oPC);
		int nMoveSilently = GetSkillRank(SKILL_MOVE_SILENTLY, oPC);

		if (nHide > nMoveSilently)
		{
			int nBonus = nHide - nMoveSilently;
			effect eSpider = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus);
			eSpider = SupernaturalEffect(eSpider);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpider, oPC, 5.99f);
		}

		DelayCommand(6.0f, DanceOfTheSpider(oPC, oToB, iSpellId, iSerial));
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
	
	DanceOfTheSpider(oPC, oToB);
}
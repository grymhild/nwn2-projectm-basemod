//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/8/2009							//
//	Title: TB_sa_flmsblss						//
//	Description: Stance; Grants resitance to//
//	fire based on the player's ranks in 	//
//	Tumble.									//
//////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void FlamesBlessing( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "FLAMESBLESSING", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "FLAMESBLESSING" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,12))
	{
		float fDuration = 6.0f;

		DelayCommand(6.0f, FlamesBlessing(oPC, oToB, iSpellId, iSerial));

		if ((GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 4) && (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) <= 8))
		{
			effect eFlmsBlss = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 5, 0));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlmsBlss, oPC, fDuration);
		}
		else if ((GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 9) && (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) <= 13))
		{
			effect eFlmsBlss = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 10, 0));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlmsBlss, oPC, fDuration);
		}
		else if ((GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 14) && (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) <= 18))
		{
			effect eFlmsBlss = SupernaturalEffect(EffectDamageResistance(DAMAGE_TYPE_FIRE, 20, 0));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlmsBlss, oPC, fDuration);
		}
		else if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 19)
		{
			effect eFlmsBlss = SupernaturalEffect(EffectImmunity(DAMAGE_TYPE_FIRE));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFlmsBlss, oPC, fDuration);
		}
		else return;
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
	FlamesBlessing(oPC, oToB);
}

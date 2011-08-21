//////////////////////////////////////////////
//	Author: Drammel							//
//	Date: 2/8/2009							//
//	Title: TB_sa_stncoclr						//
//	Description: Stance; +2 to AC vs one foe//
//	and -2 AC vs all others.				//
//////////////////////////////////////////////
//#include "tob_x0_i0_enemy"
//#include "bot9s_inc_maneuvers"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void StanceOfClarity(object oPC, object oToB)
{
	if (hkStanceGetHasActive(oPC,74))
	{
		object oTarget = IntToObject(GetLocalInt(oToB, "StanceOfClarity"));
		effect eACPlus = ExtraordinaryEffect(EffectACIncrease(2));
		effect eACMinus = ExtraordinaryEffect(EffectACDecrease(2));

		if (CSLGetNearestEnemy(oPC, 1) == oTarget)
		{
			RemoveEffect(oPC, eACMinus);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACPlus, oPC, 1.0f);
		}
		else HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACMinus, oPC, 1.0f);

		DelayCommand(1.0f, StanceOfClarity(oPC, oToB));
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
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	int nTarget = GetLocalInt(oToB, "Target");
	object oTarget = IntToObject(nTarget);

	if (TOBNotMyFoe(oPC, oTarget))
	{
		return;
	}

	SetLocalInt(oToB, "StanceOfClarity", nTarget);
	StanceOfClarity(oPC, oToB);
}

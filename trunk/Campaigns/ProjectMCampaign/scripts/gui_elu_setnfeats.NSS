
#include "elu_feats_i"

void main()
{
	object oPC = GetControlledCharacter(OBJECT_SELF);
	int bShowBonusFeats = GetHasBonusFeatsThisLevel(oPC);
	if (bShowBonusFeats)
	{	
		SetLocalInt(oPC, "BonusFeatCount", 1);
		SetupFeatsListBox(oPC, FALSE);
	}	
}
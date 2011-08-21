//::///////////////////////////////////////////////////
//:: X0_S1_PETRBREATH
//:: Petrification breath monster ability.
//:: Fortitude save (DC 17) or be turned to stone permanently.
//:: This will be changed to a temporary effect.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////



#include "_HkSpell"
#include "_SCInclude_Transmutation"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oTarget = HkGetSpellTarget();
	int nHitDice = GetHitDice(OBJECT_SELF);
	

	location lTargetLocation = HkGetSpellTargetLocation();

	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
			float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			int iSpellId = GetSpellId();
			object oSelf = OBJECT_SELF;
			DelayCommand(fDelay,  SCDoPetrification(nHitDice, oSelf, oTarget, iSpellId, 17));

			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
	}



}
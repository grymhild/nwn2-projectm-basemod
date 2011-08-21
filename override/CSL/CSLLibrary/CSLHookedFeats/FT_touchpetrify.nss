//::///////////////////////////////////////////////////
//:: X0_S1_PETRGAZE
//:: Petrification touch attack monster ability.
//:: Fortitude save (DC 15) or be turned to stone permanently.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::///////////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Transmutation"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oTarget = HkGetSpellTarget();
	int nHitDice = GetHitDice(oTarget);
	
	SCDoPetrification(nHitDice, OBJECT_SELF, oTarget, GetSpellId(), 15);
}
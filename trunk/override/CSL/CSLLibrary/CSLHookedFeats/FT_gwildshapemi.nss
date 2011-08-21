//::///////////////////////////////////////////////
//:: GreaterWildShape IV - Mindflayer Mindblast
//:: x2_s2_riderdark
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

	Does a Mindblast against the selected Target

	Range    : 15.0f,
	DC       : 10+ casterlevel/2 + wisdome modifier
	Duration : d4()

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 07, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Polymorph"
#include "_SCInclude_Monster"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	// Enforce artifical use limit on that ability
	//--------------------------------------------------------------------------
	if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
	{
			FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
			return;
	}
	int iDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_EASY) + GetAbilityModifier(ABILITY_WISDOM,OBJECT_SELF);

	// Do the mind blast DC 19 ....
	SCDoMindBlast(iDC, d4(1), 15.0f);
}
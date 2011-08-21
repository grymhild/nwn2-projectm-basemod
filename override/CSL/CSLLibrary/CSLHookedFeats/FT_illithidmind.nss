//::///////////////////////////////////////////////
//:: GreaterWildShape IV - Mindflayer Mindblast
//:: x2_s1_illithidb
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

	Does a Mindblast against the selected Target

	Range    : 15.0f,
	DC       : 10+Caster Level
	Duration : d4()

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 07, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Monster"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	// Do the mind blast DC 19 ....
	SCDoMindBlast(19, d4(1), 15.0f);
}
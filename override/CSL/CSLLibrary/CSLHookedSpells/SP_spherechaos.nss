//::///////////////////////////////////////////////
//:: Sphere of Chaos
//:: NW_S0_SphChaos.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This applies random effects to everyone in the
	AOE depending on the level of the caster.  Enemies
	get negative effects and allies get positive
	effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 9, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_INTERNAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//  *GZ: This spell was cut from NWN and would cause stack underflows if you use it...
	WriteTimestampedLogEntry("** WARNING: 'Sphere of Chaos' was cast by " + GetName(OBJECT_SELF) + " " + GetTag(OBJECT_SELF) + "  This spell does not exist in the game resources!");
}


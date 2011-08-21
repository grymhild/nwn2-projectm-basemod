//::///////////////////////////////////////////////
//:: Actuvate Item Script
//:: LG_Elven.nss
//:: Copyright (c) 2010 Pain - Brian Meyer and rest of NWN2 community
//:://////////////////////////////////////////////
/*
	This allows selecting language via a feat.
*/
//:://////////////////////////////////////////////
//:: Created By: Brian Meyer
//:: Created On: Nov 28, 2010
//:://////////////////////////////////////////////
#include "_SCInclude_Language"

void main()
{	
	object oPC = OBJECT_SELF;
	CSLLanguageToggle( "halfling", oPC );
}
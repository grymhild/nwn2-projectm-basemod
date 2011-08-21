//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: x2_s3_onhitcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This file can hold your module specific
	OnHitCastSpell definitions

	How to use:
	- Add the Item Property OnHitCastSpell: UniquePower (OnHit)
	- Add code to this spellscript (see below)

	WARNING!
	This item property can be a major performance hog when used
	extensively in a multi player module. Especially in higher
	levels, with each player having multiple attacks, having numerous
	of OnHitCastSpell items in your module this can be a problem.

	It is always a good idea to keep any code in this script as
	optimized as possible.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

//#include "_HkSpell"
//#include "x2_inc_switches"
#include "_SCInclude_Events"
//#include "nw_i0_generic"
//#include "x2_inc_switches"
#include "_SCInclude_AI_IntellDev"




void main()
{
	object oSpellOrigin = OBJECT_SELF;
	object oSpellTarget = GetSpellTargetObject();
	object oItem =  GetSpellCastItem();
	
	//*CW
	//Handles the intellect devouerer
	if (GetIsObjectValid(oItem))
	{
		if(GetTag(oItem)=="cw_intellectclaw")
		{
			CW_IntellectOnHitCast(oSpellTarget, oSpellOrigin);
			return;
		}
		SCActivateItemBasedScript( oItem, X2_ITEM_EVENT_ONHITCAST );
	}
}
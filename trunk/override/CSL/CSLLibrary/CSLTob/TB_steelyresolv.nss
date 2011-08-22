///////////////////////////////////////////////////////////////
//	Author: Drammel											//
//	Date: 5/9/2009											//
//	Name: TB_steelyresolv									//
//	Description: Creates a Delayed Damage Pool from which the//
//	player can draw multiple benefits.						//
///////////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void DelayedDamagePool()
{
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
//	int nPC = ObjectToInt(oPC);
	string sName = GetFirstName(oPC);
	int nLevel = GetLevelByClass(CLASS_TYPE_CRUSADER, oPC);
	object oArea = GetArea(oPC);

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6531);

//	SetLocalString(oToB, "PC", sName);

	string sTemplate;

	if (nLevel < 4)
	{
		sTemplate = "c_ddp_5";
	}
	else if (nLevel < 8)
	{
		sTemplate = "c_ddp_10";
	}
	else if (nLevel < 12)
	{
		sTemplate = "c_ddp_15";
	}
	else if (nLevel < 16)
	{
		sTemplate = "c_ddp_20";
	}
	else if (nLevel < 20)
	{
		sTemplate = "c_ddp_25";
	}
	else if (nLevel < 24)
	{
		sTemplate = "c_ddp_30";
	}
	else if (nLevel < 28)
	{
		sTemplate = "c_ddp_35";
	}
	else sTemplate = "c_ddp_40";

	string sNewTag = sName + sTemplate;
	object oPool = GetObjectByTag(sNewTag);

	if ((GetIsInCombat(oPC)) && (!GetIsObjectValid(oPool)))
	{
		location lLocation = GetLocation(oPC);

		SetLocalString(oArea, sNewTag, sName);
		CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, sTemplate, lLocation, FALSE, sNewTag);
	}
	else if (!GetIsInCombat(oPC))
	{
		if (GetIsObjectValid(oPool))
		{
			DestroyObject(oPool);
			DeleteLocalString(oArea, sNewTag);
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 0.1f);
	DelayCommand(0.1f, DelayedDamagePool());
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6531, oPC))
	{
		DelayedDamagePool(); //Only runs if the effect is no longer on the player.
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
	
	DelayCommand(6.0f, CheckLoopEffect(oPC, oToB)); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}
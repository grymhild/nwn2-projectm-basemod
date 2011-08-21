//////////////////////////////////////////
//	Author: Drammel						//
//	Date: 3/6/2009						//
//	Title: TB_actstrike				//
//	Description: Funnel script which is	//
//	used to enqueue strikes.			//
//////////////////////////////////////////
//#include "bot9s_inc_2da"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	int nRow = TOBGetStrike(oPC, oToB);
	//--------------------------------------------------------------------------

	if (nRow == 0)
	{
		return;
	}

	string sScript = TOBGetManeuversDataScript(nRow);

	SetLocalInt(oPC, "bot9s_maneuver_running", nRow); // Tells many functions what maneuver is currently being used.
	DelayCommand(6.0f, DeleteLocalInt(oPC, "bot9s_maneuver_running"));
	ExecuteScript(sScript, oPC);
}

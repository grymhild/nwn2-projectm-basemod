//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 4/23/2009								//
//	Name: TB_suddenrecove						//
//	Description: As a swift action, the PC can	//
//	recovery an expended maneuver, once per day.//
//////////////////////////////////////////////////
//#include "bot9s_inc_maneuvers"
//#include "bot9s_inc_misc"
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
	//--------------------------------------------------------------------------
	
	string sData = GetLocalString(oToB, "BlackBox");
	string sClass = GetStringRight(sData, 3);
	string sScreen;

	if (sClass == "___")
	{
		string sScreen = "SCREEN_QUICK_STRIKE";
	}
	else sScreen = "SCREEN_QUICK_STRIKE" + sClass;

	if ((GetLocalInt(oToB, "SuddenRecovery") == 0) && !HkSwiftActionIsActive(oPC) )
	{
		TOBToggleMasks(FALSE, sScreen, oPC);
		SetLocalInt(oToB, "SuddenRecovery", 1);
	}
	else SendMessageToPC(oPC, "<color=red>You cannot use Sudden Recovery again until you have rested.</color>");
}

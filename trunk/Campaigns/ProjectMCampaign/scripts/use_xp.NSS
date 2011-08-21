
//oPC = Player who will be given a targeting cursor
//sTargetingScreenName, sTargetingXml
//  this is the screen name and xml file name of a custom
//  gui xml file which calls UIObject_Input_ActionTargetScript
//  to create a targeting cursor for oPC.
//  Some of the input values for ActionTargetScript are specified here
//  other values (cursors, and spell target index) have to be hardcoded
//  into the custom gui xml file itself.
//sValidTargets = list of valid targets
//   values can be: self,creature,ground,item,door,placeable,trigger
//	 values can be single or multiple, seperated by a comma (w/ no spaces)
//bHostile = TRUE or FALSE (sets bHostile flag for UIObject_Input_ActionTargetScript
//sScriptName = the name of the gui callback script to execute.
//  this script must support the following parameters on main:
//  void main(int objectID, float locationX, float locationY, float locationZ)
void ExecuteTargetingScript(object oPC, string sTargetingScreenName, string sTargetingXml, string sValidTargets, int bHostile, string sScriptName)
{
	DisplayGuiScreen(oPC, sTargetingScreenName, FALSE, sTargetingXml);	
	SetLocalGUIVariable(oPC, sTargetingScreenName, 0, sScriptName);	
	SetLocalGUIVariable(oPC, sTargetingScreenName, 1, sValidTargets);
	string sHostile = (bHostile ? "true" : "false");
	SetLocalGUIVariable(oPC, sTargetingScreenName, 2, sHostile);	
}

void main()
{
	object oPC = GetLastUsedBy();	
	int nXP = GetXP(oPC);
	SetXP(oPC, nXP + 1000);	
	
	string s = Get2DAString("skills", "ActiveScript", 2);
	SendMessageToPC(oPC, "script:" + s);
	//ExecuteTargetingScript(oPC, "SCREEN_TARGETSCRIPT", "targetscript.xml", "creature", TRUE, "gui_targetscript");	
	
	int mr = GetMovementRate(oPC);
	float mrf = GetMovementRateFactor(oPC);
	SendMessageToPC(oPC, "MR: " + IntToString(mr) + " MRF: " + FloatToString(mrf));
	
	object m1 = GetObjectByTag("marker1");
	object m2 = GetObjectByTag("marker2");
	float dist = GetDistanceBetween(m1,m2);
	SendMessageToPC(oPC, "Distance between markers: " + FloatToString(dist));
	
	SetMovementRateFactor(oPC, 0.41465614);
	SetScale(oPC, 0.41465614, 0.41465614, 0.41465614);
	
	 
}
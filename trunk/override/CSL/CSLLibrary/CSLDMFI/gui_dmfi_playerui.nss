////////////////////////////////////////////////////////////////////////////////
// gui_dmfi_playerui - DM Friendly Initiative - GUI script for Player UI
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           12/4/6	qk 10/07/07
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

// This script routes or executes all Player UI input.

#include "_SCInclude_DMFI"
#include "_SCInclude_DMFIComm"

void main(string sInput, string sInput2)
{
	object oPC = OBJECT_SELF;
	object oRename, oTest, oTarget, oRef;
	object oTool = CSLDMFI_GetTool(oPC);
	string sText;
	
	int n=1;
	
	// RENAMING FUNCTIONS	
	if (GetStringLeft(sInput, 1)!=".")
	{  // ONLY options for players are code to run commands OR change names
	   // so if we aren't running a command, we are changing a name.
		object oRename = GetLocalObject(oTool, DMFI_TARGET);
		
		if (GetObjectType(oRename)==OBJECT_TYPE_CREATURE)
		{
			SetFirstName(oRename, sInput);
			SetLastName(oRename, sInput2);
			CSLMessage_SendText(oPC, "Name Successfully Changed.", TRUE, COLOR_GREEN);	
			CloseGUIScreen(OBJECT_SELF, SCREEN_DMFI_CHGNAME);
		}
		else
		{
			oRef = GetLocalObject(oRename, DMFI_INVENTORY_TARGET);
			SetFirstName(oRef, sInput);
			SetFirstName(oRename, sInput);
			CSLMessage_SendText(oPC, "Item Name Successfully Changed.  Note:  You must move the item to 'refresh' the item name.", TRUE, COLOR_GREEN);	
			CloseGUIScreen(OBJECT_SELF, SCREEN_DMFI_CHGITEM);
		}
	}	
	
	// ALL OTHER FUNCTIONS
	else
	{
		sInput = GetStringRight(sInput, GetStringLength(sInput)-1);
		sInput = CSLStringSwapChars(sInput, "_", " ");	
		
		if (sInput=="ability")
		{		
			SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_ABILITY);
			DisplayGuiScreen(oPC, SCREEN_DMFI_LIST, TRUE, "dmfilist.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LISTTITLE, -1, "Choose an Ability/Save:");
			n=0;
			while (n<10)
			{
				//sText = GetLocalString(oTool, LIST_PREFIX + "LIST_ABILITY" + "." + IntToString(n));
				sText = CSLDataArray_GetString(oTool, "LIST_ABILITY", n);
				SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LIST + IntToString(n+1), -1, sText);
				n++;
			}		
		}	
       	else if (sInput=="skill")
		{		
		    DisplayGuiScreen(oPC, SCREEN_DMFI_SKILLS, TRUE, "dmfiskillsui.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_SKILLS, DMFI_UI_SKILLTITLE, -1, "Please select a skill:");
			n = 0;
			while (n<28)
			{
				//sText = GetLocalString(oTool, LIST_PREFIX + "LIST SKILL" + "." + IntToString(n));
				sText = CSLDataArray_GetString(oTool, "LIST SKILL", n);
				SetGUIObjectText(oPC, SCREEN_DMFI_SKILLS, "skill"+IntToString(n+1), -1, sText);				
				n++;
			}
			
			SetGUIObjectHidden(oPC, SCREEN_DMFI_SKILLS, "btn29", TRUE);
			SetGUIObjectHidden(oPC, SCREEN_DMFI_SKILLS, "btn30", TRUE);	
		}
		else if (sInput=="language on")	
		{		
			SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_LANG);
			CSLDataArray_DeleteEntire( oTool, "LIST_LANGUAGE" );
            //DMFI_BuildLanguageList(oTool, oPC);
		
			DisplayGuiScreen(oPC, SCREEN_DMFI_LIST, TRUE, "dmfilist.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LISTTITLE, -1, "Please select a language:");
			n=0;
			while (n<10)
			{
				//sText = GetLocalString(oTool, LIST_PREFIX + "LIST_LANGUAGE" + "." + IntToString(n));
				sText = CSLDataArray_GetString(oTool, "LIST_LANGUAGE", n);
				if (sText!="")
				{
					SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LIST  +IntToString(n+1), -1, sText);
				}
				else
				{
					SetGUIObjectHidden(oPC, SCREEN_DMFI_LIST, "btn" +IntToString(n+1), TRUE);	
				}
				n++;
			}		
		}
		else if (sInput=="dice")
		{
			SetLocalInt(oPC, DMFI_LIST_PRIOR, DMFI_LIST_NUMBER);	
			DisplayGuiScreen(oPC, SCREEN_DMFI_LIST, TRUE, "dmfilist.xml");
			SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LISTTITLE, -1, "Select number of dice:");
			n=1;
			while (n<10)
			{
				SetGUIObjectText(oPC, SCREEN_DMFI_LIST, DMFI_UI_LIST + IntToString(n), -1, IntToString(n));
				n++;
			}			
		}
		else
		{
			DMFI_UITarget(oPC, oTool);	
			DMFI_DefineStructure(oPC, sInput);
			DMFI_RunCommandCode(oTool, oPC, sInput);
		}		
	}
}			
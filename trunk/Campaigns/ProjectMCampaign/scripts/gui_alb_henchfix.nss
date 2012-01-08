// END GAME HENCHMAN FIX (PREVENTS GAME CRASH ON EXIT WHEN USING HENCHMEN) BY LANCE BOTELLE
// USES UPDATED optionsmenu.xml file.

#include "ginc_henchman"

void main(string sOption)
{
	object oPlayerMenu = OBJECT_SELF;
	object oArea = GetArea(oPlayerMenu);	
	
	// SEARCH FOR CURENT HENCHMEN
	
	object oHench = GetFirstObjectInArea(oArea);		
		
		while(oHench != OBJECT_INVALID)
		{				
			if(GetObjectType(oHench) == OBJECT_TYPE_CREATURE)
			{	
				// REMOVE THE HENCHMEN
				if(sOption == "HenchRemove")
				{						
					if(GetAssociateType(oHench) == ASSOCIATE_TYPE_HENCHMAN)
					{
					object oMaster = GetMaster(oHench);					
					SetLocalObject(oHench, "MYBOSSTEMPHOLD", oMaster);
					AssignCommand(oHench, ClearAllActions());
					HenchmanRemove(oMaster, oHench);
					}
				}
			
				// ADD THE HENCHMEN BACK (AFTER RESUMING GAME)
				if(sOption == "HenchAdd")
				{
					object oMaster = GetLocalObject(oHench, "MYBOSSTEMPHOLD");
					DeleteLocalObject(oHench, "MYBOSSTEMPHOLD");
					
					if(oMaster != OBJECT_INVALID)
					{					
					HenchmanAdd(oMaster,oHench,1,1);		
					AssignCommand(oHench, ActionForceFollowObject(oMaster));		
					}
				}
			}
				
		oHench = GetNextObjectInArea(oArea);
		}	
}
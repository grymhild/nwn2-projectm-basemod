#include "_SCInclude_Graves"

void main()
{ 
   object oPC = GetLastUsedBy();
   string sTag = GetTag(OBJECT_SELF);
   if (sTag=="townportal") {
      UseTownPortal(oPC);
   }
   else if (sTag=="yeeportal")
   {
      //if (IsWarpAllowed(oPC))
	  //{   
         UseTownPortal(oPC);
         int nUses = GetLocalInt(OBJECT_SELF, "USES");
         if (nUses<1) DestroyObject(GetObjectByTag("PORT_YEENOGHU"));
      //} 
   }
   else if (sTag=="yeereturn")
   {
      //if (IsWarpAllowed(oPC))
	  //{   
         UseReturnPortal(oPC);
      //}        
   }
   else if (sTag=="dp_gravestone")
   {
      oPC = GetLastDamager(); 
      GiveGraveGold(oPC, OBJECT_SELF); 
      SendMessageToPC(GetGraveOwner(OBJECT_SELF), GetName(oPC) + " has descreted your grave.");
   }
} 
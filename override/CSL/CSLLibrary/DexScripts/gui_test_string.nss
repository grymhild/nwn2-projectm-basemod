void main(string sToggle) {
   object oTarget = StringToObject(sToggle);	
   string sName = "UNKNOWN";  
   if (oTarget!=OBJECT_INVALID) sName = GetName(oTarget);
   SendMessageToPC(OBJECT_SELF, sToggle + ") You clicked on " + sName);	   
   
}
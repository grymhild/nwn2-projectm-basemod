void main(int nToggle) {
   object oTarget = IntToObject(nToggle);	
   string sName = "UNKNOWN";  
   if (oTarget!=OBJECT_INVALID) sName = GetName(oTarget);
   SendMessageToPC(OBJECT_SELF, IntToString(nToggle) + ") You clicked on " + sName);	
   
   
}
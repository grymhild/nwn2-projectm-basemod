

void main()
{
	if (GetObjectType(OBJECT_SELF) != OBJECT_TYPE_CREATURE)
		return;
	
	string sMsg = "Enter the spell ID, classID, and a 0 or a 1 to indicate the spell is to be removed (0) or added (1) to " + GetName(OBJECT_SELF) + "\n";
	sMsg = sMsg + "For Example, enter '165:10:1' to set the Sleep spell as a known wizard spell.";
	
	DisplayInputBox(OBJECT_SELF, -1, sMsg, "gui_dbug_setspellcb", "", TRUE);
}
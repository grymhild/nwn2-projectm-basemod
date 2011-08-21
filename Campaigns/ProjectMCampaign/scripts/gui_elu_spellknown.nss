

void main()
{
	object oPC = OBJECT_SELF;
	SendMessageToPC(oPC, "Executed gui_elu_spellknown");
	string sRowName = GetStringByStrRef(766);
	AddListBoxRow(oPC, "SCREEN_SPELLS_KNOWN", "AVAILABLE_SPELL_LIST", sRowName, "SPELL_TEXTFIELD=" + sRowName, "SPELL_IMAGE=is_charmperson.tga", "0=16;1=77;2=0", "" );
}
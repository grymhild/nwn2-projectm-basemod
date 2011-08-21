// gui_death_waitforhelp.nss
/*
   Death GUI 'Wait For Help' callback: displays full-screen hidden death button
*/

#include "_SCInclude_Graves"

void main() {
   object oPC = OBJECT_SELF;
   if (GetIsDead(oPC)) DisplayGuiScreen(oPC, GUI_DEATH_HIDDEN, FALSE);
   CloseGUIScreen(oPC, GUI_DEATH);
}
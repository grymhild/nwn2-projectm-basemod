// gui_death_hidden_click.nss
/*
   Hidden Death GUI 'Click' callback
*/

#include "_SCInclude_Graves"

void main() {
   object oPC = OBJECT_SELF;
   CloseGUIScreen(oPC, GUI_DEATH);
   CloseGUIScreen(oPC, GUI_DEATH_HIDDEN);
   ShowDeathScreen(oPC);
}
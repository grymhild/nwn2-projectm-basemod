/*
    Include file to be included in the NPC's OnConversation script. Simply call
    either of the four DoStart...Crafter() functions from within main()

    06/01/15 * Seed       * Change CSLStartDlg to CSLOpenNextDlg
*/
//#include "dmfi_inc_conv"

#include "_CSLCore_Math"
#include "_CSLCore_Messages"
#include "_SCInclude_DynamConvos"

const int CRAFT_ARMOR             = 1;
const int CRAFT_MAGIC             = 2;
const int CRAFT_WEAPONS           = 4;
const int CRAFT_RANGED            = 8;
const int CRAFT_ALL               = 15;

void DoStartArmorCrafter()
{
    CSLDefineLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_ARMOR);
    CSLOpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

void DoStartProjectileCrafter() 
{
    CSLDefineLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_RANGED);
    CSLOpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

void DoStartMagicItemCrafter()
{
    CSLDefineLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_MAGIC);
    CSLOpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

void DoStartWeaponCrafter()
{
    CSLDefineLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_WEAPONS);
    CSLOpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

void DoStartAllCrafter()
{
    CSLDefineLocalInt(OBJECT_SELF, "CRAFTER_TYPE", CRAFT_ALL);
    CSLOpenNextDlg(GetLastSpeaker(), OBJECT_SELF,"seed_crafter",TRUE,FALSE);
}

void main()
{
   object oPC = GetLastSpeaker();
   CSLDefineLocalInt(OBJECT_SELF, "CRAFTER_MAX_LEVEL", 5);
   CSLOpenNextDlg(GetLastSpeaker(), OBJECT_SELF, "seed_crafter", TRUE, FALSE);
}
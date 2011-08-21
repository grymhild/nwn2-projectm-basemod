#include "_CSLCore_Appearance"
#include "_CSLCore_Math"

void main() {
   string sTag = GetTag(OBJECT_SELF);
   if (CSLStringStartsWith(sTag, "drakkenlegion")) {
      SetCreatureAppearanceType(OBJECT_SELF, CSLPickOneInt(APPEAR_TYPE_DWARF, APPEAR_TYPE_ELF, APPEAR_TYPE_HUMAN, APPEAR_TYPE_HALF_ELF));
   } else if (CSLStringStartsWith(sTag, "drakkenmage")) {
      SetCreatureAppearanceType(OBJECT_SELF, CSLPickOneInt(APPEAR_TYPE_DWARF, APPEAR_TYPE_ELF, APPEAR_TYPE_HUMAN, APPEAR_TYPE_HALF_ELF, APPEAR_TYPE_GNOME, APPEAR_TYPE_HALFLING));
   } else if (CSLStringStartsWith(sTag, "drakkensneak")) {
      SetCreatureAppearanceType(OBJECT_SELF, CSLPickOneInt(APPEAR_TYPE_GNOME, APPEAR_TYPE_HALFLING));  
   }
   ExecuteScript("nw_c2_default9", OBJECT_SELF);
}
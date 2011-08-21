#include "_CSLCore_Appearance"
#include "_CSLCore_Math"

void main() {
   string sTag = GetTag(OBJECT_SELF);
   if (sTag=="aniarmor_warlock") {
      int nAppear = CSLPickOneInt(APPEAR_TYPE_GNOME, APPEAR_TYPE_HALFLING);
      SetCreatureAppearanceType(OBJECT_SELF, nAppear);
   }
   ExecuteScript("nw_c2_default9", OBJECT_SELF);
}
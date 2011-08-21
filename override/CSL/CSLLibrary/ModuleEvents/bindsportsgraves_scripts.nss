#include "_SCInclude_Graves"

void main(string sAction) {
   object oPC = GetPCSpeaker();
   object oGrave = GetGrave(oPC);

   if (sAction == "JUMPLOFT") { // PLAYER PORTING OUT OF EP TO LOFTENWOOD
      PortFromEthereal(oPC, GetLocation(GetObjectByTag("dp_return")));

   } else if (sAction == "JUMPGRAVE") { // PLAYER PORTING OUT OF EP TO GRAVE LOCATION
      if (oGrave!=OBJECT_INVALID) {
         PortFromEthereal(oPC, GetLocation(oGrave));
         DestroyObject(oGrave);
      } else {
         FloatingTextStringOnCreature("Your grave has been desecrated!", oPC, FALSE);
      }

   } else if (sAction == "JUMPBIND") { // PLAYER PORTING OUT OF EP TO BIND LOCATION
      PortFromEthereal(oPC, SDB_GetBind(oPC));

   } else if (sAction == "PRAYALTAR") { // PLAYER PRAYING AT ALTAR OF LIFE
      if (GetGender(oPC)==GENDER_MALE) PlaySound("as_pl_chantingm2");
      else PlaySound("as_pl_chantingf2");
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 8.0));
      if (!GetHasPrayed(oPC)) {
         SetHasPrayed(oPC, TRUE);
         if (Random(30)+1 >= GetHitDice(oPC)) { // 5% CHANCE PER LEVEL
            DelayCommand(2.0, GiveGraveXP(oPC, "The Gods have favored you!"));
         } else {
            DelayCommand(4.0, FloatingTextStringOnCreature("The Gods feel you are not worthy!", oPC));
         }
      } else {
         DelayCommand(6.0, FloatingTextStringOnCreature("The Gods no longer listen to your prayers.", oPC));
      }

   } else if (sAction == "PRAYGRAVE") { // PLAYER PRAYING AT GRAVE
      if (GetGender(oPC)==GENDER_MALE) PlaySound("as_pl_chantingm2");
      else PlaySound("as_pl_chantingf2");
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 8.0));
      if (oGrave!=OBJECT_INVALID) {
         AssignCommand(oPC, DelayCommand(2.0, GiveGraveXP(oPC, "The Gods have heard your prayers.")));
         AssignCommand(oPC, DelayCommand(2.1, GiveGraveGold(oPC, oGrave)));
         DestroyObject(oGrave, 2.2f);
      }

   } else if (sAction == "BINDPLAYER") { // PLAYER BINDING AT CURRENT LOCATION
      BindPlayerToObject(oPC);

   } else if (sAction == "USERETURNPORTAL") { // PLAYER RETURNING TO TOWN PORTAL
      UseReturnPortal(oPC);

   }

}
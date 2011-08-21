
void CheckBreath(object oPC, int iDC=6) {
   if (!GetLocalInt(oPC, "UNDERWATER")) {
      SendMessageToPC(oPC, "You are no longer submerged...");
      return; // NO LONGER UNDER WATER EXIT FUNCTION
   }	  
   if (!GetLocalInt(oPC, "AQUALUNG")) {
      if (WillSave(oPC, iDC)==SAVING_THROW_CHECK_FAILED) {
	     SendMessageToPC(oPC, "You cannot fight the urge to breath any longer! With a gasp, you inhale a large amount of sea water into your lungs!");
		 int iDamage = GetMaxHitPoints(oPC) / 4;
		 ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY), oPC);
         FloatingTextStringOnCreature("*choke*", oPC, TRUE);
	  }
      iDC++;
   } else {
	  FloatingTextStringOnCreature("*bloop*", oPC, TRUE);
   }
   DelayCommand(6.0, CheckBreath(oPC, iDC));
}

void main() {
   object oPC = GetEnteringObject();
   SetLocalInt(oPC, "UNDERWATER", TRUE);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(50)), oPC);
   int nFort = GetFortitudeSavingThrow(oPC); //GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
   float fFirstCheck = 10.0 + nFort;
   DelayCommand(fFirstCheck, CheckBreath(oPC, 6));
   string sMsg = "You are in deep water now.";
   if (!GetLocalInt(oPC, "AQUALUNG")) sMsg += " You can hold your breath for " + IntToString(nFort+10) + " seconds before fighting the urge to gasp for air.";
   SendMessageToPC(oPC, sMsg);
}
void main() {
   object oPC = GetLastClosedBy();
   object oDoll = GetLocalObject(oPC, "DOLL");
   DeleteLocalObject(oPC, "DOLL");
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_rebuke_undead.sef", oDoll), oDoll);
   DestroyObject(oDoll, 1.0);
}
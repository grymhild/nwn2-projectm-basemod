void main() {
   FloatingTextStringOnCreature("Pissed!", OBJECT_SELF);
   SendMessageToPC(GetFirstPC(), GetName(OBJECT_SELF) + " is now pissed.");
}
void main() {
   object oPC = GetLastSpeaker();
   AssignCommand(OBJECT_SELF, ActionStartConversation(oPC, "", TRUE, TRUE));
}
//::////////////////////////////////////////////////////////////////////////:://
//:: SIMTools V3.0 Speech Integration & Management Tools Version 3.0        :://
//:: Created By: FunkySwerve                                                :://
//:: Created On: April 4 2006                                               :://
//:: Last Updated: March 27 2007                                            :://
//:: With Thanks To:                                                        :://
//:: Dumbo - for his amazing plugin                                         :://
//:: Virusman - for Linux versions, and for the reset plugin, and for       :://
//::    his excellent events plugin, without which this update would not    :://
//::    be possible                                                         :://
//:: Dazzle - for his script samples                                        :://
//:: Butch - for the emote wand scripts                                     :://
//:: The DMFI project - for the languages conversions and many of the emotes:://
//:: Lanessar and the players of the Myth Drannor PW - for the new languages:://
//:: The players and DMs of Higher Ground for their input and playtesting   :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat_c" 
 
void main()
{
   object oItem = GetItemActivated();
   object oPC = GetItemActivator();
   string sTag = GetTag(oItem);
   object oTarget = GetItemActivatedTarget();

   if (GetIsObjectValid(oTarget))
   {
		SetLocalObject(oPC, "FKY_CHT_VENTRILO", oTarget);
		FloatingTextStringOnCreature("Target Set", oPC, FALSE);
   }
   else
   {
		FloatingTextStringOnCreature("Invalid Target", oPC, FALSE);
   }
}
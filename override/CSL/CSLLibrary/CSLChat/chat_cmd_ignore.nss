//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	int nChannel = CSLGetChatChannel();
	if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	{
		return;
	}

	{
               if (((nChannel==4) ||(nChannel==20)) && GetIsObjectValid(oTarget)) {
                  if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget))) { //CAN'T IGNORE DMS OR ADMINS
                     if (oPC != oTarget) {
                        string sTarget = CSLGetMyPlayerName(oTarget);
                        if (GetLocalInt(oPC, "FKY_CHT_IGNORE" + sTarget)==FALSE) {
                          string sPlayer = CSLGetMyPlayerName(oPC);
                           SetLocalInt(oPC, "FKY_CHT_IGNORE" + sTarget, TRUE); //IGNORE LIST STORED ON PC IGNORING
                           SendMessageToPC(oPC, "<color=indianred>"+"You are now ignoring tells from "+ sTarget + "."+"</color>");
                           SendMessageToPC(oTarget, "<color=indianred>" + sPlayer +" is now ignoring tells from you."+"</color>");
                        } else FloatingTextStringOnCreature("<color=indianred>"+"You are already ignoring "+ sTarget + "!"+"</color>", oPC, FALSE);
                     } else FloatingTextStringOnCreature("<color=indianred>"+"You may not ignore tells from yourself!"+"</color>", oPC, FALSE);
                  } else FloatingTextStringOnCreature("<color=indianred>"+"You may not ignore tells from DMs!"+"</color>", oPC, FALSE);
               } else FloatingTextStringOnCreature("<color=indianred>"+"Ignore commands must be sent as tells!"+"</color>", oPC, FALSE);
            }
}
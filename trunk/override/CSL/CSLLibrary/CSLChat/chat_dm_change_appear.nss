//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	// store previous appearance for safety
	string sAppear = CSLStoreTrueAppearance( oTarget );
	
	if (CSLVerifyDMKey(oTarget) && (oTarget != oDM))
	{
		FloatingTextStringOnCreature("<color=indianred>"+"You cannot change the appearance of other DMs!"+"</color>", oDM);
	}
	else
	{
		if (sParameters=="base")
		{
			CSLRestoreTrueAppearance(oTarget);
		}
		else
		{
			SetCreatureAppearanceType(oTarget, StringToInt(sParameters));
		}
	}
}
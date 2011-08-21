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

	sParameters = GetStringLowerCase( CSLTrim(sParameters ) );
	
	if ( sParameters == "lg" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_LAWFUL,  ALIGNMENT_GOOD);
	}
	else if ( sParameters == "cg" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD);
	}
	else if ( sParameters == "ng" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD);
	}
	else if ( sParameters == "ln" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_LAWFUL,  ALIGNMENT_NEUTRAL);
	}
	else if ( sParameters == "cn" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL);
	}
	else if ( sParameters == "tn" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL);
	}
	else if ( sParameters == "le" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_LAWFUL,  ALIGNMENT_EVIL);
	}
	else if ( sParameters == "ce" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL);
	}
	else if ( sParameters == "ne" )
	{
		CSLSetAlignment(oTarget, ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL);
	}
	else 
	{
		// bad command
	}

}
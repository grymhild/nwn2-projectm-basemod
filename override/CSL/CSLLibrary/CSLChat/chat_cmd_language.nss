//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oPC = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	object oTarget = CSLGetChatTarget();
	
	if ( oTarget != oPC )
	{
		if ( !GetIsObjectValid( oTarget ) )
		{
			oTarget = oPC;
		}
		else if ( !CSLGetIsDM( oPC, TRUE ) )
		{
			oTarget = oPC;
		}
		else if ( GetMaster(oTarget) != oPC  )
		{
			oTarget = oPC;
		}
	}
	
	if ( !GetIsObjectValid( oTarget ) || GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE )
	{
		SendMessageToPC( oPC, "Select a valid target");
		return;
	}
	
	// SetLocalString(oTarget, DMFI_LANGUAGE_TOGGLE, sParameters);
	
	CSLLanguageUse( sParameters, oTarget );
	if ( oTarget != oPC )
	{
		SendMessageToPC( oPC, "Language Changed to "+sParameters);
	}

}
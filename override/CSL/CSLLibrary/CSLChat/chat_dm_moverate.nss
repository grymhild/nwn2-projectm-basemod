//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	string sMessage;
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	if ( GetStringLowerCase(sParameters) == "default" || GetStringLowerCase(sParameters) == "reset" )
	{
		int iMoveRate;
		if ( GetIsPC( oTarget ) && CSLGetAppearanceBySubrace( GetSubRace(oTarget) ) == GetAppearanceType(oTarget) )
		{
			iMoveRate = 0;
		}
		else
		{
			iMoveRate = GetMovementRate(oTarget);
		}
		SetMovementRateFactor(  oTarget, StringToFloat( Get2DAString("creaturespeed", "WALKRATE", iMoveRate) )  );
	}
	else if( sParameters != "" )
	{
		SetMovementRateFactor(  oTarget, StringToFloat(sParameters) );
	
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+GetName(oTarget)+" has a movement rate of "+ FloatToString( GetMovementRateFactor(  oTarget ) ) +"</color>");
		return;
	}
	
	SendMessageToPC(oDM, "<color=indianred>"+GetName(oTarget)+" has had their movement rate set to "+ FloatToString( GetMovementRateFactor(  oTarget ) ) + "</color>");

}
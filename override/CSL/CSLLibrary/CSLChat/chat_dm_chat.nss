//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_Playerlist"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = GetStringLowerCase( CSLGetChatParameters() );
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	
	if ( sParameters == "toggle")
	{
		CSLPlayerList_HiddenToggle( oTarget );
	}
	else if ( sParameters == "show")
	{
		CSLPlayerList_SetHidden( oTarget, FALSE  );
	}
	else if ( sParameters == "hide")
	{
		CSLPlayerList_SetHidden( oTarget, TRUE  );
	}
	else
	{
		SendMessageToPC( oDM, "Usage: dm_chat show");
		SendMessageToPC( oDM, "Parameters are:");
		SendMessageToPC( oDM, " show = shows target in chat");
		SendMessageToPC( oDM, " hide = hides target in chat");
		SendMessageToPC( oDM, " toggle = toggles target visibility");
		
	}
	
	/*
	if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget)))//this command may not be used on dms or admins
	{
		SetPlotFlag(oTarget, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath( FALSE, FALSE, TRUE )), oTarget);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(GetCurrentHitPoints(oTarget))), oTarget);
		
		SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget)+" is now dead."+"</color>");
	}
	
	
	if ( GetStringLowerCase(sParameters) == "mass")
	{
		location lTarget = GetLocation( oTarget );
		object oAlly = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		while ( GetIsObjectValid(oAlly) )
		{
			if ( !GetIsOwnedByPlayer( oAlly ) && !GetIsPC( oAlly ) )
			{
				SetPlotFlag(oAlly, FALSE);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath( FALSE, FALSE, TRUE )), oAlly);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(GetCurrentHitPoints(oAlly))), oAlly);
				SendMessageToPC(oDM, "<color=indianred>" + GetName(oAlly)+" is now dead."+"</color>");
			}
			oAlly = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	
	}
	*/

}
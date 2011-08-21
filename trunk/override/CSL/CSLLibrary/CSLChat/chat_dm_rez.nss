//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_CSLCore_Player"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}
	if ( !GetIsObjectValid( oTarget )  )
	{
		SendMessageToPC(oDM, "ERROR: Target was Invalid, please select a target or send via a tell");
		return;
	}
	
	if ( sParameters == "Mass")
	{
		CSLDMHeal( oTarget, oDM, TRUE );
	}
	else
	{
		CSLDMHeal( oTarget, oDM );
	}
	/*
	if ((!CSLVerifyDMKey(oTarget)) && (!CSLVerifyAdminKey(oTarget)) || (oTarget==oDM))
	{
		ApplyEffectToObject(0, EffectResurrection(), oTarget);
		CloseGUIScreen( oTarget, GUI_DEATH );
		CloseGUIScreen(oTarget, GUI_DEATH_HIDDEN);
		CSLEnviroRemoveEffects( oTarget );
		ApplyEffectToObject(0, EffectHeal(GetMaxHitPoints(oTarget)- GetCurrentHitPoints(oTarget)), oTarget);
		SendMessageToPC(oDM, "<color=indianred>" + GetName(oTarget) +" is now resurrected."+"</color>");
		
		if ( sParameters == "Mass")
		{
			location lTarget = GetLocation( oTarget );
			object oAlly = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			while ( GetIsObjectValid(oAlly) )
			{
				if ( GetIsOwnedByPlayer( oAlly ) || GetIsPC( oAlly ) )
				{
					ApplyEffectToObject(0, EffectResurrection(), oAlly);
					CloseGUIScreen( oAlly, GUI_DEATH );
					CloseGUIScreen(oAlly, GUI_DEATH_HIDDEN);
					CSLEnviroRemoveEffects( oAlly );
					ApplyEffectToObject(0, EffectHeal(GetMaxHitPoints(oAlly)- GetCurrentHitPoints(oAlly)), oAlly);
					SendMessageToPC(oDM, "<color=indianred>" + GetName(oAlly) +" is now resurrected."+"</color>");
				}
				oAlly = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
		
		}
	}
	*/
}
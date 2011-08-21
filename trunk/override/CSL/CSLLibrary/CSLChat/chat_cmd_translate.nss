//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
//#include "_CSLCore_ObjectVars"

#include "_SCInclude_Language"

void main()
{
	object oPC = CSLGetChatSender();
	string sParameters = CSLGetChatParameters();
	object oTarget = CSLGetChatTarget();
	
	//if ( !CSLCheckPermissions( oPC, CSL_PERM_PCLIVING  ) )
	//{
	//	return;
	//}
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
	
	if ( GetIsDead( oTarget ) || GetCurrentHitPoints(oTarget) < 1 )
	{
		SendMessageToPC(oPC, GetName(oTarget)+" is Dead and cannot speak now." );
		return;
	}
	
	if( CSLGetPreferenceSwitch("SilenceBlocksChat", FALSE ) )
	{
		if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_SILENCE ))
		{
			SendMessageToPC(oPC, GetName(oTarget)+" is Silenced and cannot speak now." );
			return;
		}
	}
	
	string sMessage = CSLNth_Shift( sParameters, " ");
	
	string sLanguageVar = CSLLanguageGetValidLanguageForSpeaker( oTarget, CSLTrim(CSLNth_GetLast()) );
	
	string sTranslate = CSLLanguageTranslate( sMessage, sLanguageVar );
	
	AssignCommand(oTarget, SpeakString(sTranslate, TALKVOLUME_TALK ));
	DelayCommand( 0.0f, CSLLanguageTranslateToListeners( oTarget, sTranslate, sMessage, sLanguageVar ) );
}
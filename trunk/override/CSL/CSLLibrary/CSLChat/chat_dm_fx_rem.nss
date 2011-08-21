//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"

void main()
{
	object oDM = CSLGetChatSender();
	object oTarget = CSLGetChatTarget();
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		return;
	}

	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		if (GetEffectCreator(eEffect)==oDM)
		{
			if (GetEffectType(eEffect)==EFFECT_TYPE_VISUALEFFECT || GetEffectType(eEffect)==EFFECT_TYPE_BEAM)
			{
				DelayCommand(0.1, RemoveEffect(oTarget, eEffect));
			}
		}
		eEffect = GetNextEffect(oTarget);
	}
}
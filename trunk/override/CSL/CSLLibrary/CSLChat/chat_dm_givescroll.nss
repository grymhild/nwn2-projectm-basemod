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
	if ( !GetIsObjectValid(oTarget))
	{
		oTarget = oDM;
	}
	//sParameters = GetStringRight(sParameters, GetStringLength(sParameters) - 7);
	object oNewItem = CreateItemOnObject("x2_it_cfm_bscrl", oTarget);
	if (GetIsObjectValid(oNewItem))
	{
		//void SetItemIcon(object oItem, int nIcon);
		//void AddItemProperty(int nDurationType, itemproperty ipProperty, object oItem, float fDuration=0.0f);
		//itemproperty ItemPropertyCastSpell(int nSpell, int nNumUses);
		
		
		//SendMessageToPC(oDM, "<color=indianred>"+"You have created a "+ GetName(oNewItem) +" on "+ GetName(oTarget) + "!"+"</color>");
	}
	else
	{
		SendMessageToPC(oDM, "<color=indianred>"+"Invalid ResRef! Cannot create Scroll on " + GetName(oTarget)+"</color>");
	}
}
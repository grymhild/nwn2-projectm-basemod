//Function To toggle debug info on/off on target Object.
//Changes the sChange from 1 to 0 or from 0 to 1 depending on what it was
//

//#include "ginc_param_const"
//#include "ginc_var_ops"

void main(string sChange,int iMinutes=10)
{
    object oDM = GetPCSpeaker();
	object oTarget = GetLocalObject(oDM, "loDM_WAND_TARGET");
	if (GetIsObjectValid(oTarget) == FALSE)
	{
	//	PrintString("Invalid Target");
	}
		
	if ( GetLocalInt(oTarget, sChange) == 0)
	{
		SendMessageToAllDMs("**Debug Mode Turned On: "+GetName(oTarget));
		SetLocalInt(oTarget, sChange, 1);
		if( iMinutes != 0 )
		DelayCommand( IntToFloat(iMinutes*60), DeleteLocalInt(oTarget, sChange));
		DelayCommand( IntToFloat(iMinutes*60), SendMessageToAllDMs("**Debug Mode Turned ON: "+GetName(oTarget)));
	}
	else
	{
		SendMessageToAllDMs("**Debug Mode Turned OFF: "+GetName(oTarget));
		DeleteLocalInt(oTarget, sChange);
	}	  
}
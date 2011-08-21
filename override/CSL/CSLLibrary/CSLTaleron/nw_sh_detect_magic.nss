//#include "sh_custom_functions"

#include "_HkSpell"

void main()
{	
	
		object 		oPC 	= OBJECT_SELF;
	vector 		vPC 	= GetPosition(oPC);
	location 	lTarget = GetLocationInFront(oPC,30.0);
	object 		oTarget = GetFirstObjectInShape(SHAPE_CONE,30.0,lTarget,FALSE,OBJECT_TYPE_CREATURE,vPC);
	location	lPC 	= GetLocation(oPC);
	int 		PlaceHolderValue = 0;





//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo//
	while (GetIsObjectValid(oTarget))
	{


	if 	(GetCreatureMagicAura(oTarget) > 0 && oTarget != oPC)
		{
		SendMessageToPC(oPC,"You detect the presence of magic.");
		SetLocalLocation(oPC,"Location",lPC);
		DelayCommand(5.5f,ExecuteScript("nw_sh_detect_magic_2",oPC));
		return;
		}
	oTarget = GetNextObjectInShape(SHAPE_CONE,30.0,lTarget,FALSE,OBJECT_TYPE_CREATURE,vPC);
	}

oTarget = GetFirstObjectInShape(SHAPE_CONE,30.0,lTarget,FALSE,OBJECT_TYPE_ITEM,vPC);
//oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo//

//-----------------------------------------------------------------------------//
	while (GetIsObjectValid(oTarget))
	{
	if (GetMagicAuraValue(GetIdentifiedGoldPieceValue(oTarget))> 0)
		{
		SendMessageToPC(oPC,"You detect the presence of magic.");
		SetLocalLocation(oPC,"Location",lPC);
		DelayCommand(5.5f,ExecuteScript("nw_sh_detect_magic_2",oPC));
		return;
		}
	oTarget = GetNextObjectInShape(SHAPE_CONE,30.0,lTarget,FALSE,OBJECT_TYPE_ITEM,vPC);
	}
//------------------------------------------------------------------------------//

SendMessageToPC(oPC,"You do not detect the presence of magic.");




} //End of Void Main
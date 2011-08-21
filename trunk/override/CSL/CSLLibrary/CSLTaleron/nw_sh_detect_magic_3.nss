//#include "sh_custom_functions"






string sAuraPower(int nAuraPower)
//***************assign a strong to greatest aura power*****************

{
	if (nAuraPower == 4){return "Overwhelming";}
	else if (nAuraPower == 3){return "Strong";}
	else if (nAuraPower == 2){return "Moderate";}
	else {return "Faint";}


}


	//***********************************************************************










#include "_HkSpell"

void main()
{	
	
	object 		oPC = OBJECT_SELF;
	vector 		vPC = GetPosition(oPC);
	location 	lTarget = GetLocationInFront(oPC,30.0);
	object 		oTarget = GetFirstObjectInShape(SHAPE_CONE,30.0,lTarget,TRUE,OBJECT_TYPE_CREATURE,vPC);
	location	lPC = GetLocalLocation(oPC,"Location");
	int			nHighestAuraPower = 0;
	int			nAuraPower = 0;


	if (lPC != GetLocation(oPC)) //Are we still in the same spot?
	{
	DeleteLocalLocation(oPC,"Location");
	return;
	}
	FloatingTextStringOnCreature("Continues Concentrating",oPC,FALSE,5.0);


////////////////////Loop to check all creatures in cone///////////////////////////
while (GetIsObjectValid(oTarget))
{
	nAuraPower = GetCreatureMagicAura(oTarget);
	if (nAuraPower	> 0&& oTarget != oPC)
		{
		SendMessageToPC(oPC,GetName(oTarget)+" has a "+sAuraPower(nAuraPower) + " aura");
		}
	oTarget = GetNextObjectInShape(SHAPE_CONE,30.0,lTarget,TRUE,OBJECT_TYPE_CREATURE,vPC);
}
//////////////////////////////////////////////////////////////////////////////////


//////////Check Items For Magic//////////////////

oTarget = GetFirstObjectInShape(SHAPE_CONE,30.0,lTarget,TRUE,OBJECT_TYPE_ITEM,vPC);
string sTemp;
while (GetIsObjectValid(oTarget))
	{
	nAuraPower = GetMagicAuraValue(GetIdentifiedGoldPieceValue(oTarget));

		if (nAuraPower	> 0)
		{
			sTemp = GetName(oTarget);
			if (!GetIdentified(oTarget))
			{
			sTemp = "Un-Identified Object";
			}

			SendMessageToPC(oPC, sTemp +" has a "+ sAuraPower(nAuraPower) + " aura");
		}



	oTarget = GetNextObjectInShape(SHAPE_CONE,30.0,lTarget,TRUE,OBJECT_TYPE_ITEM,vPC);
	}
//////////////////////////////////////////////////////////////////////



	return;

}
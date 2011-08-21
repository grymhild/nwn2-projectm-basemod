//#include "sh_custom_functions"

/////////////////Returns The aura strength based on value//////////////
int GetMagicAuraBasedOnValue(int MaxValue)
{
if (MaxValue > 100000) return 4;
else if (MaxValue > 500000) return 3;
else if (MaxValue > 25000) return 2;
else if (MaxValue > 100) return 1;
else return 0;
}
////////////////////////////////////////////////////////////////////////




#include "_HkSpell"

void main()
{	
	
	object 		oPC = OBJECT_SELF;
	vector 		vPC = GetPosition(oPC);
	location 	lTarget = GetLocationInFront(oPC,30.0f);
	object 		oTarget = GetFirstObjectInShape(SHAPE_CONE,30.0,lTarget,TRUE,OBJECT_TYPE_CREATURE,vPC);
	location	lPC = GetLocalLocation(oPC,"Location");
	int 		nNumberOfAuras = 0;
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
if (nAuraPower	> 0 && oTarget != oPC)
{
nNumberOfAuras = nNumberOfAuras +1; //if the creature has an aura, increment the number
}

if (nAuraPower > nHighestAuraPower)
{
nHighestAuraPower = nAuraPower; //simple check to find highest aura in area.
}

oTarget = GetNextObjectInShape(SHAPE_CONE,30.0,lTarget,TRUE,OBJECT_TYPE_CREATURE,vPC);
}
//////////////////////////////////////////////////////////////////////////////////


//////////Check Items For Magic//////////////////

oTarget = GetFirstObjectInShape(SHAPE_CONE,30.0,lTarget,TRUE,OBJECT_TYPE_ITEM,vPC);

while (GetIsObjectValid(oTarget))
	{
	nAuraPower = GetMagicAuraBasedOnValue(GetIdentifiedGoldPieceValue(oTarget));

		if (nAuraPower	> 0)
		{
			nNumberOfAuras = nNumberOfAuras +1; //if the item has an aura, increment the number
		}

		if (nAuraPower > nHighestAuraPower)
		{
			nHighestAuraPower = nAuraPower; //simple check to find highest aura in area.
		}


	oTarget = GetNextObjectInShape(SHAPE_CONE,30.0,lTarget,TRUE,OBJECT_TYPE_ITEM,vPC);
	}
//////////////////////////////////////////////////////////////////////

string sAuraPower;
//***************assign a strong to greatest aura power*****************
	if (nHighestAuraPower == 4){sAuraPower = "Overwhelming";}
	else if (nHighestAuraPower == 3){sAuraPower = "Strong";}
	else if (nHighestAuraPower == 2){sAuraPower = "Moderate";}
	else if (nHighestAuraPower == 1){sAuraPower = "Faint";}

//***********************************************************************

if (nNumberOfAuras > 0)
{
SendMessageToPC(oPC,"There are "+ IntToString(nNumberOfAuras) +" Auras detected.");
SendMessageToPC(oPC,"The Strongest Aura is " + sAuraPower);
DelayCommand(5.5f,ExecuteScript("nw_sh_detect_magic_3",oPC));
return;

}
else
{SendMessageToPC(oPC,"You don't detect magic in the area");}


}

t
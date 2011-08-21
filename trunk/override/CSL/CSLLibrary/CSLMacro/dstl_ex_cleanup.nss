//:://////////////////////////////////////////////////
//:: dstl_ex_cleanup
/*
v2.07
	Part of extended library of the DS-TL (see dstl_hbdirector).

destroys all dynamic objects in the area of OBJECT_SELF. Uncomment line 29-42,
if you want "BodyBag"s cleaned.

*/
//:://////////////////////////////////////////////////
//:: Copyright
//:: Created By: DSenset
//:: Created On: 2009
//:://////////////////////////////////////////////////

#include "_SCInclude_Macro"

void main()
{

object o;
object a;

a=GetArea(OBJECT_SELF);

o=GetFirstObjectInArea(a);
do
{
	/*
	if (GetTag(o) == "BodyBag") //not sure if that's true for NWN2
		{
		object oin;
		oin=GetFirstItemInInventory(o);
		while (oin!=OBJECT_INVALID)
		{
		//no plot items
		DestroyObject(oin,0.1f);
		oin=GetNextItemInInventory(o);
		}
		DestroyObject(o,0.2f);
		}
	else
	*/
	if (GetLocalInt(o,DSTL_DSTLPREFIX+"dynamic")==1)
	{
		int donot;
		donot=FALSE;
		// don't destroy if a PC is sitting on it (showbreaking NWN-bug):
		object sc;
		sc=GetSittingCreature(o);
		if (sc!=OBJECT_INVALID)
		if (GetIsPC(sc)==TRUE)
		{
			donot=TRUE;
		}
		
		if (donot==FALSE)
		{
			SetPlotFlag(o,FALSE);
			DestroyObject(o,0.1f);
		}
	}
	o=GetNextObjectInArea(a);
}
while (o!=OBJECT_INVALID);

}
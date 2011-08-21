#include "_SCInclude_Mode"
#include "_CSLCore_Items"

void main()
{
   object oPC = OBJECT_SELF;
	if ( !GetIsObjectValid( oPC) )
	{
		return;
	}
	//SendMessageToPC( oPC, "Swim Mode Stop Script");
	CSLHideHeldItems( oPC, 0.0f, ITEMS_SHOWN_DEFAULT );
}
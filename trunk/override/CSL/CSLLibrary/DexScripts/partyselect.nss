#include "_CSLCore_Messages"

void main()
{
	object oPC=GetPCSpeaker();
	CSLShowPartySelect( oPC, TRUE, "", TRUE );
}
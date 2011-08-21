#include "_SCInclude_Artillery"

void main()
{
	object oPC =  GetLastUsedBy();
	object oArtillery = OBJECT_SELF;
	
	SCArtillery_Display( oArtillery, oPC );

}
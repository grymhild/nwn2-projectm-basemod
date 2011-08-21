#include "_SCInclude_AI"

void main()
{
    // TK removed SCSendForHelp
//    SCSendForHelp();
	SCInitializeCreatureInformation(OBJECT_SELF);
    
	SetCommandable(TRUE);

    ClearAllActions();

	SetCommandable(FALSE);
}
#include "_SCInclude_AI"


void main()
{
    // TK removed SCSendForHelp
    //   SCSendForHelp();
	SCInitializeCreatureInformation(OBJECT_SELF);

    SetCommandable(TRUE);

   	SCHenchResetCombatRound();
    SCHenchDetermineCombatRound();

    SetCommandable(FALSE);
}
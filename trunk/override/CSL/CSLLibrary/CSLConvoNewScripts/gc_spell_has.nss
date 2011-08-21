/*
    This checks to see if the PC Speaker knows a given spell ( regardless of class )
*/
int StartingConditional( int nSpell )
{

    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());

    return GetSpellKnown(oPC, nSpell);

}

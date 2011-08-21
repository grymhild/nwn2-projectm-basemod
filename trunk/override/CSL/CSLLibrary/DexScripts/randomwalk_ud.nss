// Randowm walking animals
// Put on UserDefined event of the animal
void main()
{
    int nUser = GetUserDefinedEventNumber();
    if (nUser == 1001)
    {
        if (!GetIsObjectValid(GetAttemptedAttackTarget())
        && !GetIsObjectValid(GetAttemptedSpellTarget())
        && !IsInConversation(OBJECT_SELF))
        {
            ActionRandomWalk();
        }
    }
}

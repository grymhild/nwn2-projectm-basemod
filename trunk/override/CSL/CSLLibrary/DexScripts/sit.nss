void main()
{
object oPlayer=GetLastUsedBy();

if(GetIsPC(oPlayer))
    {
    object oChair = OBJECT_SELF;
    if (GetIsObjectValid(oChair) && !GetIsObjectValid(GetSittingCreature(oChair)))
       {
       AssignCommand(oPlayer, ActionSit(oChair));
       }
    }
}
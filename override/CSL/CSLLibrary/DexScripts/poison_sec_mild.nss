//#include "_SCUtility"

void main() {
    object oTarget = OBJECT_SELF;
    int iDice = 2;
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(iDice), DAMAGE_TYPE_ACID), oTarget);
FloatingTextStringOnCreature("<color=pink>*Secondary Poison*m", oTarget);
}
//#include "_SCUtility"

void main() {
    object oTarget = OBJECT_SELF;
    int iDice = 3;
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d4(iDice), DAMAGE_TYPE_ACID), oTarget);
FloatingTextStringOnCreature("<color=pink>*Primary Poison*p", oTarget);

}
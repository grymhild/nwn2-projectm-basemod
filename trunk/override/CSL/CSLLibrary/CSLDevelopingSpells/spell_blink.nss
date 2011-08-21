/** @file spell_blink.nss Casts the spell Blink.
 * @ingroup CustomSpells
 * @author Grinning Fool
 *
 * Caster is "blinked" to locations from 5 to 15 meters away at random intervals, for the full duration of the spell.
 * Physical attacks against you have a 25% miss chance (concealment).
 * Likewise, your own attacks have a 25% miss chance, since you sometimes go ethereal just as you are about to strike.
 * Any individually targeted spell has a 25% chance to fail against you while you’re blinking unless your attacker can target invisible, ethereal creatures. This is handled in-game as temporary spell resistance.
 * Your own spells have a 25% chance to activate just as you go ethereal, in which case they typically do not affect the Material Plane. This is represented in-game as 25% chance of spell failure.
 * While blinking, you take only half damage from area attacks. This is represented in-game as damage resistance.
*/

#include "inc_pw"
#include "x2_inc_spellhook"
#include "x0_i0_position"

void _doJump()
{
    LogObjectMessage(OBJECT_SELF, "Starting doJump");
    if (!GetLocalInt(OBJECT_SELF, "SPBLINKING"))
        return; // spell expired.
    ClearAllActions(TRUE);
    location lStart = GetLocation(OBJECT_SELF);
    float fDist = 3.0 + (IntToFloat(Random(10) + 2) / 2.0);
    location lEnd = CSLGetRandomLocation(GetArea(OBJECT_SELF), OBJECT_SELF, fDist);

    effect eVis = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
    DelayCommand(0.05, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lStart, 0.7));
    DelayCommand(0.25, ActionJumpToLocation(lEnd));
    DelayCommand(0.30, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lEnd, 0.7));
    float delay = IntToFloat(d6(2) / 2) + 1.0; // time 'til next jump
    DelayCommand(delay, _doJump());
    return;
}


void _clearSpell()
{
    DeleteLocalInt(OBJECT_SELF, "SPBLINKING");
}


void main()
{
    object oCaster = OBJECT_SELF;
    LogObjectMessage(GetLastSpellCaster(), "spell_blink: start");
    if (!X2PreSpellCastCode())
        return;
    effect eLinkedZero = EffectLinkEffects(EffectMissChance(25), EffectConcealment(25) );
    effect eLinkedOne = EffectLinkEffects(EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 25), eLinkedZero);
    effect eLinkedTwo = EffectLinkEffects(EffectSpellFailure(25), eLinkedOne);
    effect eLinkedMaster = EffectLinkEffects( EffectSpellResistanceIncrease(15), eLinkedOne);
    float fDur = RoundsToSeconds(GetCasterLevel(oCaster));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkedMaster, OBJECT_SELF, fDur);
    DelayCommand(0.1, SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_BLINK, FALSE)));
    DelayCommand(1.0, _doJump());
    DelayCommand(fDur, _clearSpell());
    SetLocalInt(OBJECT_SELF, "SPBLINKING", TRUE);

}

/** @file spell_detlies Casts the Detect Lies spell.
 * @ingroup CustomSpells
 *  Gives the caster a boost to  skill Sense Motive of 4
 *  plus 1 / 2 caster levels.  Lasts for 1 Turn per
 *  caster level.
 */

#include "x2_inc_spellhook"
#include "inc_pw"
void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }

    object oTarget = HkGetSpellTarget();
    int nLevel = GetCasterLevel(oTarget);
    int nBonus = 4 + (nLevel / 2);
    effect eLore = EffectSkillIncrease(SKILL_SENSE_MOTIVE, nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eLore, eDur);

    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_DISCERN_LIES, oTarget))
    {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISCERN_LIES, FALSE));
         //Apply linked and VFX effects
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nLevel));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}


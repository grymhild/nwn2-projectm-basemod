/** @file spell_commnature.nss Casts the spell Commune with Nature.
 * This RP-based spell notifies DMs that the caster has completed the spell and provides
 * instructions to the DMs.
 * @ingroup CustomSpells
 */
#include "inc_pw"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    object oCaster = OBJECT_SELF;
    if (!X2PreSpellCastCode())
        return;
    LogObjectMessage(oCaster, "spell_commnature: begin posthook");
    object oArea = GetArea(oCaster);
    if (!GetIsAreaNatural(oArea)) {
        FloatingTextStringOnCreature("You feel no connection with this unnatural terrain.", oArea, FALSE);
        LogObjectMessage(oCaster, "spell_commnature: abort for unnatural terrain");
        return;
    }

    effect eVis = EffectVisualEffect(VFX_FNF_NATURES_BALANCE, FALSE);
    FloatingTextStringOnCreature("You get a sense of the land around you.", oCaster, FALSE);
    AssignCommand(oCaster, ActionSpeakString("<color=#11EE11>PC has cast Commune with Nature.   Please refer to the journal entry you have for this spell for details on how to handle it.</color>", TALKVOLUME_SILENT_SHOUT));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oCaster));
    ExploreAreaForPlayer(oArea, oCaster);

}

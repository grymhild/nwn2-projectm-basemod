/** @file spell_augury.nss
 * @ingroup CustomSpells
 * Casts the spell Augury.  This RP-based spell will notify any DMs online
 * that the spell has been cast.
 */

#include "inc_pw"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    object oCaster = OBJECT_SELF;
    if (!X2PreSpellCastCode())
        return;
    LogObjectMessage(oCaster, "spell_augury: begin posthook");
    int level = GetCasterLevel(oCaster);
    if (level == 0) {
        LogObjectMessage(oCaster, "spell_augury: User does not have any appropriate spell caster levels!", LOGLEVEL_ERROR);
        return;

    }

    effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10, FALSE);
    FloatingTextStringOnCreature("You cast your mind about seeking a glimpse of the future.", oCaster, FALSE);
    SendMessageToPC(oCaster, "Make sure that you BRIEFLY describe your planned course of action to the DM.");
    if ((d100() + level) > 60) {
        AssignCommand(oCaster, ActionSpeakString("<color=#11EE11>PC has cast Augury and will receive a useful response. Valid responses. Response should ONLY take into account the IMMEDIATE (30 minute) future: Weal [good results for actions], Woe [bad results], Weal and Woe [if both will occur], or Nothing [if neither Weal nor Woe]></color>", TALKVOLUME_SILENT_SHOUT));
    } else {
        AssignCommand(oCaster, ActionSpeakString("<color=#11EE11>PC has cast Augury but will get a response of Nothing due to a failed roll.</color>", TALKVOLUME_SILENT_SHOUT));
    }
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eVis,GetLocation(oCaster));

}

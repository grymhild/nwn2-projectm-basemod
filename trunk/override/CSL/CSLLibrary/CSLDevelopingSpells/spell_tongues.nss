/** @file spell_tongues.nss Casts the spell Tongues
 * @ingroup CustomSpell
 * Gives the PC knowledge of all spoken standard languages for a
 * period of one round per level. PC can both speak and understand the languages.
 *
 * @todo Need to make a lower-level version of this,
 * where the caster can impart knowledge of 1 specific language known.
 */

#include "inc_pw"
#include "inc_pw_pcdata"
#include "x2_inc_spellhook"
#include "inc_lang"

void doExpireTongues()
{
    if (GetLocalInt(OBJECT_SELF, LANG_HAS_EFFECT_TONGUES)) {
        DeleteLocalInt(OBJECT_SELF, LANG_HAS_EFFECT_TONGUES);
        SendMessageToPC(OBJECT_SELF, "The knowledge of languages deserts you.  Your world seems some more drab now.");
        // They may have been set to speak a language they di d not know
        if (!lang_getDoesPCKnowLanguage(OBJECT_SELF, lang_getCurrentLanguage(OBJECT_SELF))) {
            int lang = lang_getDefaultClassLanguage(OBJECT_SELF);
            if (lang == LANG_COMMON) {
                lang = lang_getDefaultRacialLanguage(OBJECT_SELF);
            }
            lang_setCurrentLanguage(OBJECT_SELF, lang); // set to a safe language; this will be common if no class/racial
        }
    }
}
void expireTongues(int nLevel)
{
    DelayCommand(RoundsToSeconds(nLevel), doExpireTongues());
}
void main()
{
    location lTarget = HkGetSpellTargetLocation();
    object oObject = HkGetSpellTarget();
    object oCaster = OBJECT_SELF;

    string sAllow = Get2DAString(X2_CI_CRAFTING_SP_2DA,"CastOnItems",GetSpellId());
    LogObjectMessage(OBJECT_SELF, "Checking for spell idx " + IntToString(GetSpellId()) + " result is " + sAllow);

    if (!X2PreSpellCastCode())
        return;
    if (!GetIsObjectValid(oObject))
        return;
    SignalEvent(oObject, EventSpellCastAt(oObject, 1520, FALSE));
    SetLocalInt(oObject, LANG_HAS_EFFECT_TONGUES, TRUE);
    SendMessageToPC(oObject, "You feel the knowledge of many languages filling your head in a rush.");
    AssignCommand(oObject, ClearAllActions(TRUE));
    AssignCommand(oObject, expireTongues(GetHitDice(oCaster)));
}
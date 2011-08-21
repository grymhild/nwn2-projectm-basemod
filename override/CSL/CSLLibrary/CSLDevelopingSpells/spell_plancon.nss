/** @file spell_plancon.nss Casts the spell Contact Other Plane.
 * @ingroup CustomSpells
 * This RP based spell allows the PC to attempt to contact another plane for advice or information.
 * Upon casting the DMs are notified and provided with instructions.
 * Note that this can carry significant drawbacks if the entity contacted is malevolent...
 */
#include "inc_pw"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

const int SECONDS_IN_REAL_DAY = 86400;
void doIllEffects(int duration)
{
    float fDuration = IntToFloat(duration * SECONDS_IN_REAL_DAY);
    // int reduction, cha reduciton, auto spell failure.
    int nIntMod = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) - 8;
    int nChaMod = GetAbilityScore(OBJECT_SELF, ABILITY_CHARISMA) - 8;
    effect eCharisma;
    /// @todo This will apply to creature skins on PC automatically on login!
    if (nChaMod > 0) {
        eCharisma = EffectAbilityDecrease(ABILITY_CHARISMA, nChaMod);
    }

    effect eMain = EffectLinkEffects(EffectAbilityDecrease(ABILITY_INTELLIGENCE, nIntMod), EffectSpellFailure(100));
    effect eApply;
    if (GetIsEffectValid(eCharisma)) {
        eApply = SupernaturalEffect(EffectLinkEffects(eCharisma, eMain));
    } else {
        eApply = SupernaturalEffect(eMain);
    }

    SendMessageToPC(OBJECT_SELF, "<color=#FF0000>Remember, even if this effect is removed, it will last for " + IntToString(duration) + " real-time days.  You must RP that you are unable to cast spells, and suffer from an int and cha reduction to 8.");
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApply, OBJECT_SELF, fDuration);


}
void main()
{
    object oCaster = OBJECT_SELF;
    if (!X2PreSpellCastCode())
        return;
    float f = 0.0;
    LogObjectMessage(oCaster, "spell_plancon: begin posthook");
    int level = GetCasterLevel(oCaster);
    if (level == 0) {
        LogObjectMessage(oCaster, "spell_plancon: User does not have any appropriate spell caster levels!", LOGLEVEL_ERROR);
        return;
    }
    int nRoll = d100() + level;
    int questions = level /2 ;
    int DC = 0;
    int duration = 0;
    string where;
    int nType;
    LogObjectMessage(oCaster, "Communicate with Planar: Caster rolled " + IntToString(nRoll) + " for initial roll.");
    if (nRoll >= 111) { // outer plane, greater deity
        nType = 6;
        duration = 7;
        DC = 18;
        where = "deep outer planes";
    } else if (nRoll >= 106) { // outer plane, lesser deity
        nType = 5;
        duration = 5;
        DC = 16;
        where = "outer planes";
    } else if (nRoll >= 91) { // astral plane -- POSSIBLY importal such as Angela or whatserface
        nType = 4;
        DC = 10;
        duration = 2;
        where = "astral plane";
    } else if (nRoll >= 61) { // pos/neg energy plane
        nType = 3;
        DC = 8;
        duration = 1;
        where = "energy planes";
    } else { // elemental plane.
        nType = 2;
        DC = 7;
        duration = 1;
        where = "elemental planes";
    }
    int x;
    string sMsg;
    int bLie = FALSE;
    int bKnowsIt = FALSE;
    int bMakesItUp = FALSE;
    string sAction;
    FloatingTextStringOnCreature("You relax and cast your mind far abroad.", oCaster, FALSE);
    SendMessageToPC(oCaster, "You have cast your mind far into the " + where + ".  You may ask " + IntToString(questions) + " questions.");
    SendMessageToPC(oCaster, "<color=#FF0000>Remember, attempting to do ANYTHING else will cause this spell to end.  This includes moving or speaking to ANYONE else (either in IC or OOC).</color>");
    /// @todo capture any speach  and apply consequences if this spell is active...
    float fTime = HoursToSeconds(3);
    ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, fTime);
    ActionSpeakString("<color=#11EE11>PC has cast Contact Other Plane and reached the " + where + ". S/he  may ask " + IntToString(questions) + " questions. </color>", TALKVOLUME_SILENT_SHOUT);

    int ndcroll = d20() + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
    LogObjectMessage(oCaster, "Rolled " + IntToString(ndcroll) + " against DC " + IntToString(DC) + " to avoid intelligence damage.");

    for (x = 0; x < questions; x++) {
        sMsg = "Question " + IntToString(x + 1) + ": Entity ";
        nRoll = d100();

        switch (nType) {
            case 6: // deep outer plane
                if (nRoll >= 100) sAction = "does not know and makes up an answer";
                else if ( nRoll >= 91 ) sAction = "knows the answer and lies";
                else if ( nRoll >= 89 ) sAction = "admits not knowing";
                else sAction = "knows and answers honestly";
                break;

            case 5: // outer plane
                if (nRoll >= 97) sAction = "does not know and makes up an answer";
                else if ( nRoll >= 76 ) sAction = "knows the answer and lies";
                else if ( nRoll >= 61 ) sAction = "admits not knowing";
                else sAction = "knows and answers honestly";
                break;

            case 4: // astral plane
                if (nRoll >= 89) sAction = "does not know and makes up an answer";
                else if ( nRoll >= 68 ) sAction = "knows the answer and lies";
                else if ( nRoll >= 45 ) sAction = "admits not knowing";
                else sAction = "knows and answers honestly";
                break;

            case 3: // Pos/Neg plane
                if (nRoll >= 87) sAction = "does not know and makes up an answer";
                else if ( nRoll >= 66 ) sAction = "knows the answer and lies";
                else if ( nRoll >= 40 ) sAction = "admts not knowing";
                else sAction = "knows and answers honestly";
                break;

            case 2: // Elemental plane
                if (nRoll >= 84) sAction = "does not know and makes up an answer";
                else if ( nRoll >= 63 ) sAction = "knows the answer and lies";
                else if ( nRoll >= 35 ) sAction = "admits not knowing";
                else sAction = "knows and answers honestly";
                break;
        }

        // Tell the DM what answers the player will likely be getting ahead of time (in terms of accuracy and honesty.
        // answer will vary based on which plane is contacted.
        sMsg = sMsg + sAction;

        LogObjectMessage(oCaster, sMsg);
        f += 0.1;
        //DelayCommand(f, ActionSpeakString(PEACH + sMsg + ENDCOLOR, TALKVOLUME_SILENT_SHOUT));
        DelayCommand(f, SendMessageToAllDMs(sMsg));
    }


    DelayCommand(fTime, ActionSpeakString( "<color=#FF0000>This PC's Contact Other Plane  session has expired, if they have not already caused it to end.</color>", TALKVOLUME_SILENT_SHOUT));
    if (ndcroll < DC) {
        f += 0.1;
        SendMessageToPC(oCaster, "<color=#FF0000>Contact with this entity has overwhelmed you! After the spell's expiration (3 game-hours), you will suffer from an Int and Cha of 8, and an inability to cast arcane spells.</color>");
        DelayCommand(f, SendMessageToAllDMs(GetName(oCaster) + " will have int/cha lowered to 8 for " + IntToString(duration) + " days as a result of this contact."));
        DelayCommand(fTime + 1.0, doIllEffects(duration));
    }
}


// spell_commune : Script for the spell Commune
// Copyright (C) 2006 dragonwell.org / GRinning Fool (Marc A. Paradise)
// Description
/*
Caster Level(s): Cleric 5
Innate Level: 5
School: Divination
Component(s): Verbal, Somatic, XP
Range: Personal
Area of Effect / Target: Special
Duration: 1 hour
Additional Counter Spells: None
Save: None
Spell Resistance:None
XP Cost: 100

You contact your deity — or more likely an agent thereof — and ask questions that
can be answered by a simple yes or no.  You are allowed one such question per caster level.
The answers given are correct within the limits of the entity’s knowledge. “Unclear” is a legitimate answer,
because powerful beings of the Outer Planes are not necessarily omniscient.
In cases where a one-word answer would be misleading or contrary to the deity’s interests,
a short phrase (five words or less) may be given as an answer instead.

The spell, at best, provides information to aid character decisions.
The entities contacted structure their answers to further their own purposes.
If you lag, discuss the answers, or go off to do anything else, the spell ends.
*/
#include "inc_pw"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_pw_xp"

void main()
{
    object oCaster = OBJECT_SELF;
    if (!X2PreSpellCastCode())
        return;
    LogObjectMessage(oCaster, "spell_commune: begin posthook");
    string sQuestions = IntToString(GetCasterLevel(oCaster));
    string sDeity = GetDeity(oCaster);
    if (sDeity == "") {
        FloatingTextStringOnCreature("You have no god!", oCaster);
        return;
    }
    float fTime = HoursToSeconds(3);

    FloatingTextStringOnCreature("You relax and fall into a trance of prayer to " + sDeity + ".", oCaster, FALSE);
    xp_TakeFromCreature(oCaster, XPTYPE_PEN_DEITY, 0.0, 100, FALSE);

    AssignCommand(oCaster, ActionSpeakString("<color=#11EE11>PC has cast Commune, attempting to contact their god " + sDeity + " or a representative.  READ the journal entry for this spell before responding!</color>", TALKVOLUME_SILENT_SHOUT));
    AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, fTime));
    SendMessageToPC(oCaster, "<color=#FF0000>Remember, attempting to do ANYTHING else will cause this spell to end and risk offending the deity.  This includes moving or speaking to ANYONE else (either in IC or OOC).  Attempting to argue with the entity or wasting his/her/its time with foolish questions is also not recommended.</color>");
    DelayCommand(fTime, ActionSpeakString("<color=#FF0000>This PC's Commune session has expired, if they have not already caused it to end.</color>", TALKVOLUME_SILENT_SHOUT));

}

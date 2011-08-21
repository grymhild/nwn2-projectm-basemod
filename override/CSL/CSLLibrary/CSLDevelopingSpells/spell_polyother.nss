/** @file spell_polyother.nss Casts the spell Polymorph Other.
 * @ingroup CustomSpells
 */
 #include "inc_pw"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = HkGetSpellTarget();
    object oCaster = OBJECT_SELF;
    if (!X2PreSpellCastCode())
        return;
    LogObjectMessage(oCaster, "spell_polyother: begin posthook");
    if (!GetIsObjectValid(oTarget)) {
        LogObjectMessage(oCaster, "spell_polyother: abort for invalid target");
        return;
    }
    if (!GetIsPC(oTarget) && GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && !GetIsPossessedFamiliar(oTarget) && !GetIsPC(GetMaster(oTarget))) {
        LogObjectMessage(oCaster, "spell_polyother: abort for bad target");
        return;
    }


    //Determine correct save
    int nSpellDC = GetSpellSaveDC();
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLYMORPH_OTHER));
    //Make SR and save checks
    if (MyResistSpell(OBJECT_SELF, oTarget) || HkSavingThrow(SAVING_THROW_FORT, oTarget, nSpellDC, SAVING_THROW_TYPE_SPELL)) {
        LogObjectMessage(oCaster, "spell_polyother: Target creature made its save. Aboring");
        return;
    }
    int nType;
    if (GetIsPC(oTarget) || GetIsPossessedFamiliar(oTarget) || GetIsPC(GetMaster(oTarget))) {
        // harmless stuff for PCs -- so it can't be abused
        switch (d4()) {
            case 1: nType = POLYMORPH_TYPE_BADGER; break;
            case 2: nType = POLYMORPH_TYPE_COW; break;
            case 3: nType = POLYMORPH_TYPE_CHICKEN; break;
            case 4: nType = POLYMORPH_TYPE_PENGUIN; break;
        }
    } else {
        int nRandom = d100();
        if (nRandom > 90) {
            switch (Random(26) + 5) {
                case 5: nType = POLYMORPH_TYPE_SUPER_CHICKEN; break;
                case 6: nType = POLYMORPH_TYPE_ANCIENT_GREEN_DRAGON; break;
                case 7: nType = POLYMORPH_TYPE_SUPER_CHICKEN; break;
                case 8: nType = POLYMORPH_TYPE_BASILISK; break;
                case 9: nType = POLYMORPH_TYPE_BEHOLDER; break;
                case 10:    nType = POLYMORPH_TYPE_DEATH_SLAAD; break;
                case 11:    nType = POLYMORPH_TYPE_DIRE_BOAR; break;
                case 12:    nType = POLYMORPH_TYPE_DIRE_BROWN_BEAR; break;
                case 13:    nType = POLYMORPH_TYPE_DIRE_PANTHER; break;
                case 14:    nType = POLYMORPH_TYPE_DIRE_WOLF; break;
                case 15:    nType = POLYMORPH_TYPE_DIRETIGER; break;
                case 16:    nType = POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL; break;
                case 17:    nType = POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL; break;
                case 18:    nType = POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL; break;
                case 19:    nType = POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL; break;
                case 20:    nType = POLYMORPH_TYPE_FIRE_GIANT; break;
                case 21:    nType = POLYMORPH_TYPE_FROST_GIANT_FEMALE; break;
                case 22:    nType = POLYMORPH_TYPE_FROST_GIANT_MALE; break;
                case 23:    nType = POLYMORPH_TYPE_GOLEM_AUTOMATON; break;
                case 24:    nType = POLYMORPH_TYPE_MEDUSA; break;
                case 25:    nType = POLYMORPH_TYPE_SUPER_CHICKEN; break;
                case 26:    nType = POLYMORPH_TYPE_VAMPIRE_MALE; break;
                case 27:    nType = POLYMORPH_TYPE_SUPER_CHICKEN; break;
            }
        } else {
            switch (d4()) {
                case 1: nType = POLYMORPH_TYPE_BADGER; break;
                case 2: nType = POLYMORPH_TYPE_COW; break;
                case 3: nType = POLYMORPH_TYPE_CHICKEN; break;
                case 4: nType = POLYMORPH_TYPE_PENGUIN; break;
            }
        }


        // hostile creatures, on the other hand... might l u ck out, might get something that clobbers you...
    }
    LogObjectMessage(oCaster, "spell_polyother: poly target success, poly ID: " + IntToString(nType));

    effect ePoly = SupernaturalEffect(EffectPolymorph(nType, TRUE));
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH, FALSE);
    int nLevel = GetHitDice(oCaster);
    int nHours = Random(nLevel) + nLevel;
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, 1 + HoursToSeconds(nHours));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget);

}

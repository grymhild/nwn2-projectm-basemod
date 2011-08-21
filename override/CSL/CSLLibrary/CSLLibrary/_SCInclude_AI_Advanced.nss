/** @file
* @brief Include File for AI Artificial Intelligence, for use by custom AI Routines
*
* Using TonyK's AI as a base, heavily reworked 
* 
*
* @ingroup scinclude
* @author TonyK, Brian T. Meyer and others

this file combines the following files

hench_i0_act.nss
hench_i0_ai.nss
hench_i0_assoc.nss
hench_i0_attack.nss
hench_i0_buff.nss
hench_i0_custom.nss
hench_i0_dispel.nss
hench_i0_equip.nss
hench_i0_generic.nss
hench_i0_heal.nss
hench_i0_hensho.nss
hench_i0_initialize.nss
hench_i0_itemsp.nss
hench_i0_melee.nss
hench_i0_monsho.nss
hench_i0_options.nss
hench_i0_spells.nss
hench_i0_strings.nss
hench_i0_target.nss
x0_i0_anims.nss
x0_i0_behavior.nss
//#include "nwn2_inc_spells"
//#include "x0_i0_assoc"
//#include "x0_i0_henchman"
//#include "x0_i0_voice"
//#include "x2_i0_spells"
//#include "ginc_debug"
//#include "x0_i0_equip"
x0_i0_voice
x0_i0_modes
x0_i0_walkway
x0_i0_equip
x0_i0_enemy.nss
x0_i0_match.nss
x0_i0_spawncond.nss
*/


// includes regular AI
#include "_SCInclude_AI"
#include "_SCInclude_AI_c"

const int NW_TALENT_PROTECT = 1;


// This structure is used to represent the number and type of
// enemies that a creature is facing, divided into four main
// categories: fighters, clerics, mages, monsters.
struct sEnemies
{
    int FIGHTERS;
    int FIGHTER_LEVELS;
    int CLERICS;
    int CLERIC_LEVELS;
    int MAGES;
    int MAGE_LEVELS;
    int MONSTERS;
    int MONTERS_LEVELS;
    int TOTAL;
    int TOTAL_LEVELS;
};



// This function simply attempts to get the best protective
// talent that the caller has, the protective talents as
// follows:
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE
// TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT
talent SCStartProtectionLoop()
{
    talent tUse;
    int nCRMax = SCGetCRMax();
    tUse = SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF,
                                 nCRMax);
    if(GetIsTalentValid(tUse))
        return tUse;

    tUse = SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                 nCRMax);
    if(GetIsTalentValid(tUse))
        return tUse;

    tUse = SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT,
                                 nCRMax);
    return tUse;
}

//    Uses four general categories to determine what
//    kinds of enemies the NPC is facing.
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
struct sEnemies SCDetermineEnemies()
{
    struct sEnemies sEnemyCount;

    int nCnt = 1;
    int nClass;
    int nHD;
    object oTarget = CSLGetNearestPerceivedEnemy();

    while(GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget) <= 40.0)
    {
        nClass = GetClassByPosition(1, oTarget);
        nHD = GetHitDice(oTarget);
        if(nClass == CLASS_TYPE_ANIMAL ||
           nClass == CLASS_TYPE_BARBARIAN ||
           nClass == CLASS_TYPE_BEAST ||
           nClass == CLASS_TYPE_COMMONER ||
           nClass == CLASS_TYPE_CONSTRUCT ||
           nClass == CLASS_TYPE_ELEMENTAL ||
           nClass == CLASS_TYPE_FIGHTER ||
           nClass == CLASS_TYPE_GIANT ||
           nClass == CLASS_TYPE_HUMANOID ||
           nClass == CLASS_TYPE_MONSTROUS ||
           nClass == CLASS_TYPE_PALADIN ||
           nClass == CLASS_TYPE_RANGER ||
           nClass == CLASS_TYPE_ROGUE ||
           nClass == CLASS_TYPE_VERMIN ||
           nClass == CLASS_TYPE_MONK ||
           nClass == CLASS_TYPE_SHAPECHANGER)
        {
            sEnemyCount.FIGHTERS += 1;
            sEnemyCount.FIGHTER_LEVELS += nHD;
        }
        else if(nClass == CLASS_TYPE_CLERIC ||
           nClass == CLASS_TYPE_DRUID)
        {
            sEnemyCount.CLERICS += 1;
            sEnemyCount.CLERIC_LEVELS += nHD;
        }
        else if(nClass == CLASS_TYPE_BARD ||
                nClass == CLASS_TYPE_FEY ||
                nClass == CLASS_TYPE_SORCERER ||
                nClass == CLASS_TYPE_WIZARD)
        {
           sEnemyCount.MAGES += 1;
           sEnemyCount.MAGE_LEVELS += nHD;
        }
        else if(nClass == CLASS_TYPE_ABERRATION ||
                nClass == CLASS_TYPE_DRAGON ||
                nClass == 29 || //oozes
                nClass == CLASS_TYPE_MAGICAL_BEAST ||
                nClass == CLASS_TYPE_OUTSIDER)
        {
           sEnemyCount.MONSTERS += 1;
           sEnemyCount.MONTERS_LEVELS += nHD;
        }
        sEnemyCount.TOTAL += 1;
        sEnemyCount.TOTAL_LEVELS += nHD;
        nCnt++;
        oTarget = CSLGetNearestPerceivedEnemy(OBJECT_SELF, nCnt);
    }
    return sEnemyCount;
}


// JLR - OEI 07/11/05 -- Name Changed

int SCMatchSpellProtections(talent tUse)
{
    int nIndex = GetIdFromTalent(tUse);

    if(nIndex == SPELL_GREATER_SPELL_MANTLE ||
       nIndex == SPELL_SPELL_MANTLE ||
       nIndex == SPELL_LESSER_SPELL_MANTLE ||
       nIndex == SPELL_SHADOW_SHIELD ||
       nIndex == SPELL_GLOBE_OF_INVULNERABILITY ||
       nIndex == SPELL_LESSER_GLOBE_OF_INVULNERABILITY ||
       nIndex == SPELL_ETHEREAL_VISAGE ||
       nIndex == SPELL_GHOSTLY_VISAGE ||
       nIndex == SPELL_SPELL_RESISTANCE ||
       nIndex == SPELL_PROTECTION_FROM_SPELLS ||
       nIndex == SPELL_NEGATIVE_ENERGY_PROTECTION   )
    {
        return TRUE;
    }
    return FALSE;
}



int SCMatchElementalProtections(talent tUse)
{
    int nIndex = GetIdFromTalent(tUse);

    if(nIndex == SPELL_ENERGY_BUFFER ||
       nIndex == SPELL_PROTECTION_FROM_ENERGY ||
       nIndex == SPELL_RESIST_ENERGY ||
       nIndex == SPELL_ENDURE_ELEMENTS)
    {
        return TRUE;
    }
    return FALSE;
}



int SCMatchCombatProtections(talent tUse)
{
    int nIndex = GetIdFromTalent(tUse);

    if(nIndex == SPELL_PREMONITION ||
       nIndex == SPELL_ELEMENTAL_SHIELD ||
       nIndex == SPELL_GREATER_STONESKIN ||
       nIndex == SPELL_SHADOW_SHIELD ||
       nIndex == SPELL_ETHEREAL_VISAGE ||
       nIndex == SPELL_STONESKIN ||
       nIndex == SPELL_GHOSTLY_VISAGE ||
       nIndex == SPELL_MESTILS_ACID_SHEATH ||
       nIndex == SPELL_DEATH_ARMOR||
       nIndex == 695 // epic warding

       )
    {
        return TRUE;
    }
    return FALSE;
}

int SCGetMatchCompatibility(talent tUse, string sClass, int nType)
{
    int bValid;
    if(nType == NW_TALENT_PROTECT)
    {
        if(sClass == "FIGHTER")
        {
            if(SCMatchCombatProtections(tUse))
            {
                bValid = TRUE;
            }
        }
        else if(sClass == "MAGE")
        {
            if(SCMatchSpellProtections(tUse))
            {
                bValid = TRUE;
            }
            else if(SCMatchElementalProtections(tUse))
            {
                bValid = TRUE;
            }
        }
        else if(sClass == "CLERIC" || sClass == "MONSTER")
        {
            if(SCMatchCombatProtections(tUse))
            {
                bValid = TRUE;
            }
            else if(SCMatchElementalProtections(tUse))
            {
                bValid = TRUE;
            }
        }
    }

    return bValid;
}

//    Use the four archetypes to determine the
//    most dangerous group type facing the NPC
//:: Created By: Preston Watamaniuk
//:: Created On: April 4, 2002
string SCGetMostDangerousClass(struct sEnemies sCount)
{
    string sClass;
    int nFighter = ((sCount.FIGHTER_LEVELS) * 13)/10;
    //SpeakString(IntToString(nFighter) + " " + IntToString(sCount.CLERIC_LEVELS) + " " + IntToString(sCount.MAGE_LEVELS) + " " + IntToString(sCount.MONTERS_LEVELS));

    if(nFighter >= sCount.CLERIC_LEVELS)
    {
        if(nFighter >= sCount.MAGE_LEVELS)
        {
            if(nFighter >= sCount.MONTERS_LEVELS)
            {
                sClass = "FIGHTER";
            }
            else
            {   sClass = "MONSTER";

            }
        }
        else if(sCount.MAGE_LEVELS >= sCount.MONTERS_LEVELS)
        {
            sClass = "MAGE";
        }
        else
        {
            sClass = "MONSTER";
        }
    }
    else if(sCount.CLERIC_LEVELS >= sCount.MAGE_LEVELS)
    {
        if(sCount.CLERIC_LEVELS >= sCount.MONTERS_LEVELS)
        {
            sClass = "CLERIC";
        }
        else
        {
            sClass = "MONSTER";
        }
    }
    else if(sCount.MAGE_LEVELS >= sCount.MONTERS_LEVELS)
    {
        sClass = "MAGE";
    }
    else
    {
        sClass = "MONSTER";
    }
    return sClass;
}


// ADVANCED PROTECT SELF Talent 2.0
// This will use the class specific defensive spells first and
// leave the rest for the normal defensive AI
int SCTalentAdvancedProtectSelf()
{
    //MyPrintString("SCTalentAdvancedProtectSelf Enter");

    struct sEnemies sCount = SCDetermineEnemies();
    int bValid = FALSE;
    int nCnt;
    string sClass = SCGetMostDangerousClass(sCount);
    talent tUse = SCStartProtectionLoop();
    while(GetIsTalentValid(tUse) && nCnt < 10)
    {
        //MyPrintString("SCTalentAdvancedProtectSelf Search Self");
        tUse = SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF,
                                     SCGetCRMax());
        if(GetIsTalentValid(tUse)
           && SCGetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
        {
            bValid = TRUE;
            nCnt = 11;
        } else {
            //MyPrintString(" TalentAdvancedProtectSelfSearch Single");
            tUse =
                SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                      SCGetCRMax());
            if(GetIsTalentValid(tUse)
               && SCGetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
            {
                bValid = TRUE;
                nCnt = 11;
            } else {
                //MyPrintString("SCTalentAdvancedProtectSelf Search Area");
                tUse =
                    SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_AREAEFFECT,
                                          SCGetCRMax());
                if(GetIsTalentValid(tUse)
                   && SCGetMatchCompatibility(tUse, sClass, NW_TALENT_PROTECT))
                {
                    bValid = TRUE;
                    nCnt = 11;
                }
            }
        }
        nCnt++;
    }

    if(bValid == TRUE)
    {
        int nType = GetTypeFromTalent(tUse);
        int nIndex = GetIdFromTalent(tUse);

        if(nType == TALENT_TYPE_SPELL)
        {
            if(!GetHasSpellEffect(nIndex)) {
                //MyPrintString("SCTalentAdvancedProtectSelf Successful Exit");
                SCEvenTalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
        } else if(nType == TALENT_TYPE_FEAT) {
            if(!GetHasFeatEffect(nIndex)) {
                //MyPrintString("SCTalentAdvancedProtectSelf Successful Exit");
                SCEvenTalentFilter(tUse, OBJECT_SELF);
                return TRUE;
            }
        } else {
            //MyPrintString("SCTalentAdvancedProtectSelf Successful Exit");
            SCEvenTalentFilter(tUse, OBJECT_SELF);
            return TRUE;
        }
    }
    //MyPrintString("SCTalentAdvancedProtectSelf Failed Exit");
    return FALSE;
}


object SCGetCurrentRealMaster( object oFollower=OBJECT_SELF )
{
    object oMaster = GetMaster( oFollower );
	
	if ( GetIsObjectValid(oMaster) == FALSE )
	{
		oMaster = oFollower;
	}
	
	return ( oMaster );
}

int SCGetIsRangedAttacker(object oAttacker)
{
    if (GetDistanceToObject(oAttacker) > MELEE_DISTANCE)
        return TRUE;
    return FALSE;
}


// Try a given talent.
// This will only cast spells and feats if the targets do not already
// have the effects of those feats, and will funnel all talents
// through SCEvenTalentFilter for a final check.
int SCTryTalent(talent tUse, object oTarget=OBJECT_SELF, int area=FALSE)
{
	if(!GetIsTalentValid(tUse)) return FALSE;
    int nType = GetTypeFromTalent(tUse);
    int nIndex = GetIdFromTalent(tUse);
    if(nType == TALENT_TYPE_SPELL  && (GetHasSpellEffect(nIndex, oTarget) || (area && GetHasSpellEffect(nIndex, OBJECT_SELF))))
    {
        return FALSE;
    }
    else if(nType == TALENT_TYPE_FEAT && (GetHasFeatEffect(nIndex, oTarget) || (area && GetHasFeatEffect(nIndex, OBJECT_SELF))))
    {
        return FALSE;
    }
	if(SCEvenTalentCheck(tUse, oTarget))
	{
    	SCEvenTalentFilter(tUse, OBJECT_SELF);
	    return TRUE;
	}
    return FALSE;
}



// PROTECT SELF
int SCTalentUseProtectionOnSelf()
{
    //MyPrintString("SCTalentUseProtectionOnSelf Enter");
    talent tUse;
    int nType, nIndex;
    int bValid = FALSE;
    int nCR = SCGetCRMax();

    tUse = SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SELF, SCGetCRMax());

    if(!GetIsTalentValid(tUse)) {
        tUse = SCGetCreatureTalent(TALENT_CATEGORY_BENEFICIAL_PROTECTION_SINGLE,
                                     SCGetCRMax());
        if(GetIsTalentValid(tUse))  {
            ////MyPrintString("I have found a way to protect my self");
            bValid = TRUE;
        }
    } else {
        ////MyPrintString("I have found a way to protect my self");
        bValid = TRUE;
    }


    if (bValid == TRUE) {
        if (SCTryTalent(tUse)) {
            //MyPrintString("SCTalentUseProtectionOnSelf Successful Exit");
            return TRUE;
        }
    }

    //MyPrintString("SCTalentUseProtectionOnSelf Failed Exit");
    return FALSE;
}






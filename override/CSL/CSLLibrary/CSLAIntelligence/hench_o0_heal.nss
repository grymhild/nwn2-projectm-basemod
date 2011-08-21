/*

    Companion and Monster AI

    Heals ally from command, currently only from shout (could reenable auto heal later)  

*/


#include "_SCInclude_AI"


void main()
{
//    Jug_Debug(GetName(OBJECT_SELF) + " healing code start");
	object oCharacter = OBJECT_SELF;
    int nHealingType = GetLocalInt(oCharacter, "HenchHealType");

    if (nHealingType == HENCH_CNTX_MENU_OFF)
    {    
        DeleteLocalInt(oCharacter, "HenchCurHealCount");
        DeleteLocalInt(oCharacter, "HenchHealType");
        DeleteLocalInt(oCharacter, "HenchHealState");
        DeleteLocalObject(oCharacter, "Henchman_Spell_Target");
        return;
    }

    SetCommandable(TRUE);
//	SpawnScriptDebugger();
	object oMaster = CSLGetCurrentMaster(); 

	gfBuffSelfWeight = 1.0;
	gfBuffOthersWeight = 1.0;

	SCIntitializeHealingInfo(TRUE, oCharacter);

    SCInitializeBasicTargetInfo();
    // clear enemy target lists
    DeleteLocalObject(oCharacter, "HenchObjectSeen");
    DeleteLocalObject(oCharacter, "HenchLineOfSight");
	
	gsAttackTargetInfo.spellID = -1;	// SPELL_ACID_FOG is zero
	gsBuffTargetInfo.spellID = -1;	// SPELL_ACID_FOG is zero
		
	int iNegEffectsOnSelf = SCGetCreatureNegEffects(oCharacter);		
	int iPosEffectsOnSelf = SCGetCreaturePosEffects(oCharacter);
    
    object oHealTarget = GetLocalObject(oCharacter, "Henchman_Spell_Target");
    int curHealCount = GetLocalInt(oCharacter, "HenchCurHealCount");

    if (!GetIsObjectValid(oHealTarget))
    {
        SCInitializeAllyList(FALSE);
        if (curHealCount == 1)
        {
            SCReportUnseenAllies();
        }
    }
    else
    {
        int bTargetSeen = SCInitializeSingleAlly(oHealTarget);
        if (!bTargetSeen)
        {
			//	"I can't see "
            SpeakString(GetStringByStrRef(230439) + GetName(oHealTarget));
        }
    }
        
    if (nHealingType == HENCH_CNTX_MENU_HEAL)
    {    
	    gbDisableNonHealorCure = TRUE;        
        gbSpellInfoCastMask = HENCH_SPELL_INFO_HEAL_OR_CURE;
        DeleteLocalInt(oCharacter, "HenchHealState");
    }
    else
    {
        gbDoingBuff = TRUE;
        // initialize all buffing flags
        object oFriend = oCharacter;
        while (GetIsObjectValid(oFriend))
        {
    	    SetLocalFloat(oFriend, "HenchMeleeTarget", 1.0);
            object oLast = oFriend;
	    	oFriend = GetLocalObject(oFriend, "HenchAllyLineOfSight");
            SetLocalObject(oLast, "HenchMeleeTarget", oFriend);
        }
                
        giHenchUseSpellProtectionsChecked = HENCH_GLOBAL_FLAG_TRUE;
		goBestSpellCaster = oCharacter;	// give good default for buff
        gbMeleeTargetInit = TRUE;
        gbIAmMeleeTarget = TRUE;
        
        int currentBuffState = GetLocalInt(oCharacter, "HenchHealState");        
        if (currentBuffState == HENCH_CNTX_MENU_BUFF_LONG)
        {    
            gbSpellInfoCastMask = HENCH_SPELL_INFO_LONG_DUR_BUFF;
        }
        else if (currentBuffState == HENCH_CNTX_MENU_BUFF_MEDIUM)
        {    
            gbSpellInfoCastMask = HENCH_SPELL_INFO_MEDIUM_DUR_BUFF;
        }
        else if (currentBuffState == HENCH_CNTX_MENU_BUFF_SHORT)
        {    
            gbSpellInfoCastMask = HENCH_SPELL_INFO_SHORT_DUR_BUFF;
        }
        else
        {
            DeleteLocalInt(oCharacter, "HenchCurHealCount");
            DeleteLocalInt(oCharacter, "HenchHealType");
            DeleteLocalInt(oCharacter, "HenchHealState");
            DeleteLocalObject(oCharacter, "Henchman_Spell_Target");
            return;
        }
    }
//    Jug_Debug(GetName(oCharacter) + " cont heal target " + GetName(oHealTarget) + " mask " + IntToHexString(gbSpellInfoCastMask));
    
    SCInitializeItemSpells(iNegEffectsOnSelf, iPosEffectsOnSelf, oCharacter);
      
    if ((nHealingType == HENCH_CNTX_MENU_BUFF_MEDIUM) || (nHealingType == HENCH_CNTX_MENU_BUFF_SHORT))
    {
        int currentBuffState = GetLocalInt(oCharacter, "HenchHealState");
        if (!SCHenchCheckSpellToCast(0, TRUE))
        {
            // try the next shorter duration        
//            Jug_Debug(GetName(oCharacter) + " skipping buff " + IntToString(currentBuffState));
            if (currentBuffState == HENCH_CNTX_MENU_BUFF_LONG)
            {
//                Jug_Debug(GetName(oCharacter) + " try medium");
                SetLocalInt(oCharacter, "HenchCurHealCount", curHealCount + 1);
                SetLocalInt(oCharacter, "HenchHealState", HENCH_CNTX_MENU_BUFF_MEDIUM);
                DelayCommand(0.01, ExecuteScript("hench_o0_heal", oCharacter));
                return;
            }
            if ((currentBuffState == HENCH_CNTX_MENU_BUFF_MEDIUM) && (nHealingType == HENCH_CNTX_MENU_BUFF_SHORT))
            {
//                Jug_Debug(GetName(oCharacter) + " try short");
                SetLocalInt(oCharacter, "HenchCurHealCount", curHealCount + 1);
                SetLocalInt(oCharacter, "HenchHealState", HENCH_CNTX_MENU_BUFF_SHORT);
                DelayCommand(0.01, ExecuteScript("hench_o0_heal", oCharacter));
                return;
            }
//            Jug_Debug(GetName(oCharacter) + " continue on");
        }
        else
        {
            // check to see if we should wait        
//            Jug_Debug(GetName(oCharacter) + " checking next buff " + IntToString(currentBuffState));
            object oPartyMember = GetFirstFactionMember(oCharacter, FALSE);
            while (GetIsObjectValid(oPartyMember))
            {
         		if (!(GetIsPC(oPartyMember) && SCGetHenchPartyState(HENCH_PARTY_DISABLE_SELF_HEAL_OR_BUFF))
					&& (oPartyMember != oCharacter))
        		{
                    int partyMemberHealState = GetLocalInt(oPartyMember, "HenchHealState");
                    if (partyMemberHealState && (partyMemberHealState < currentBuffState))
                    {
                        // need to wait
//                        Jug_Debug(GetName(oCharacter) + " waiting for next buff " + IntToString(currentBuffState));
                        return;
                    }
        		}
                oPartyMember = GetNextFactionMember(oCharacter, FALSE);
            }
        }
    }
    
    if (SCHenchCheckSpellToCast(0))
    {
        if (gbAnyValidTarget && (curHealCount < 10))
        {
            DelayCommand(2.0, SCVoiceCanDo());
        }
        SetLocalInt(oCharacter, "HenchCurHealCount", curHealCount + 10);
		
		if (GetIsPC(oCharacter))
		{		
			ActionWait(4.0);
			ActionDoCommand(DelayCommand(0.01, ExecuteScript("hench_o0_heal", oCharacter)));		
		}		
		
        return;
    }
    
    if (curHealCount < 10)
    {
            // didn't find any heal or buff spells
        DelayCommand(2.5, SCVoiceCannotDo());
    }
    else
    {
        SCVoiceTaskComplete(TRUE);
    }
    
    DeleteLocalInt(oCharacter, "HenchCurHealCount");
    DeleteLocalInt(oCharacter, "HenchHealType");
    DeleteLocalInt(oCharacter, "HenchHealState");
    DeleteLocalObject(oCharacter, "Henchman_Spell_Target");
}
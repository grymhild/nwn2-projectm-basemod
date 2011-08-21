//#include "_SCUtility"
#include "_SCInclude_CharEdit"
#include "_SCInclude_DMAppear"
//#include "_SCInclude_DMInven"


void main( string sInput, string sPlayerID = "",  string sCommand = "", string sParameter= "")
{
	if ( !CSLCheckPermissions( OBJECT_SELF, CSL_PERM_DMONLY ) )
	{
		CloseGUIScreen(OBJECT_SELF, SCREEN_DM_CSLTABLELIST);
		return;
	}
	
	object oPC = GetControlledCharacter(OBJECT_SELF);
	
	sInput = GetStringLowerCase( sInput );
	
	object oTarget;
	if ( sPlayerID == "targeted" )
	{
		oTarget = GetPlayerCurrentTarget( OBJECT_SELF );
		//if ( !GetIsObjectValid( oTarget )  )
		//{		
		//	oTarget == OBJECT_SELF;
		//}
	}
	else
	{
		oTarget = IntToObject(StringToInt(sPlayerID));
	}
	
	// SendMessageToPC(oPC,"charedit sInput="+sInput+" sPlayerID="+sPlayerID+" sCommand="+sCommand+" sParameter="+sParameter );
	
	
	SCCharEdit_SetPimTarget(oPC, oTarget);
	
	// basic interface issues up front
	if ( sInput=="update" )
	{
		SCCharEdit_Build( oTarget, oPC );
		return;
	}
	else if ( sInput=="remove" )
	{

		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, StringToInt(sCommand) );
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( sInput == "appearance" )
	{
		CSLDMAppear_Display( oPC, oTarget );
		return;
	}
	else if ( sInput=="freeze" )
	{
		if ( CSLGetIsDM(oTarget) )
		{
			CSLMessage_SendText(oPC, "You cannot freeze other DM's.", FALSE, COLOR_RED);
			return;// DMFI_STATE_ERROR;
		}
		
		if ( GetObjectType(oTarget) == OBJECT_TYPE_CREATURE )
		{	
			effect eEffect = EffectCutsceneImmobilize();
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0);
			eEffect = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE_NO_SOUND);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0);
			CSLMessage_SendText(oTarget, "Your character is DM frozen for 60 seconds.", TRUE, COLOR_RED);
			CSLMessage_SendText(oPC, "DMFI Target is frozen for 60 seconds.", TRUE, COLOR_GREEN);
		}
		else
		{
			CSLMessage_SendText(oPC, "DMFI Target must be NPC or PC for this function.", FALSE, COLOR_RED);
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( sInput=="boot" )
	{
		if ( !GetIsPC(oTarget) )
		{
			CSLMessage_SendText(oPC, "You can only boot PC's.", FALSE, COLOR_RED);
			return;// DMFI_STATE_ERROR;
		}
		
		if ( CSLGetIsDM(oTarget) )
		{
			CSLMessage_SendText(oPC, "You cannot boot other DM's.", FALSE, COLOR_RED);
			return;// DMFI_STATE_ERROR;
		}
		
		BootPC(oTarget);
        CSLMessage_SendText(oPC, "DMFI Removed Player from Server: " + GetName(oTarget), TRUE, COLOR_RED);
        WriteTimestampedLogEntry("DMFI Action Alert: " + GetName(oPC) + "DMFI Removed Player from Server: " + GetName(oTarget));

		
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,7)=="faction")
	{
		string sCommand = CSLNth_GetNthElement(sInput,2,"-");
		if ( sCommand == "merchant" )
		{
			AssignCommand(oTarget, ClearAllActions(TRUE));
			ChangeToStandardFaction(oTarget, STANDARD_FACTION_MERCHANT);
			CSLMessage_SendText(oPC, "Target set to faction: Merchant", TRUE, COLOR_GREEN);
		}
		else if ( sCommand == "defender" )
		{
			AssignCommand(oTarget, ClearAllActions(TRUE));
			ChangeToStandardFaction(oTarget, STANDARD_FACTION_DEFENDER);
			CSLMessage_SendText(oPC, "Target set to faction: Defender", TRUE, COLOR_GREEN);
		}
		else if ( sCommand == "commoner" )
		{
			AssignCommand(oTarget, ClearAllActions(TRUE));
			ChangeToStandardFaction(oTarget, STANDARD_FACTION_COMMONER);
			CSLMessage_SendText(oPC, "Target set to faction: Commoner", TRUE, COLOR_GREEN);
		}
		else if ( sCommand == "hostile" )
		{
			AssignCommand(oTarget, ClearAllActions(TRUE));
			ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
			CSLMessage_SendText(oPC, "Target set to faction: Hostile", TRUE, COLOR_GREEN);
		}
		object oTest = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oTarget, 1);
		if (GetIsObjectValid(oTest))
		{
			DelayCommand(1.0, AssignCommand(oTarget, ActionAttack(oTest, FALSE)));
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,4)=="move")
	{
		string sCommand = CSLNth_GetNthElement(sInput,2,"-");
		string sCommand2 = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "rotate" )
		{
			if ( sCommand2 == "right" )
			{
				AssignCommand( oTarget, ClearAllActions() );
				AssignCommand(oTarget, ActionDoCommand( SetFacing( CSLGetHalfRightDirection(GetFacing(oTarget)) ) ) );
			}
			else if ( sCommand2 == "left" )
			{
				AssignCommand( oTarget, ClearAllActions() );
				AssignCommand(oTarget, ActionDoCommand( SetFacing( CSLGetHalfLeftDirection(GetFacing(oTarget)) ) ));
			}
			else if ( sCommand2 == "rightfull" )
			{
				AssignCommand( oTarget, ClearAllActions() );
				AssignCommand(oTarget, ActionDoCommand( SetFacing( CSLGetRightDirection(GetFacing(oTarget)) ) ));
			}
			else if ( sCommand2 == "leftfull" )
			{
				AssignCommand( oTarget, ClearAllActions() );
				AssignCommand(oTarget, ActionDoCommand( SetFacing( CSLGetLeftDirection(GetFacing(oTarget)) ) ));
			}
		}
		else if ( sCommand == "move" )
		{
			if ( sCommand2 == "forward" )
			{
				location lNewLocation = CSLGetAheadLocation( oTarget, SC_DISTANCE_MEDIUM );
				AssignCommand( oTarget, ClearAllActions() );
				CSLMoveToNewLocation(lNewLocation, oTarget);
			}
			else if ( sCommand2 == "back" )
			{
				location lNewLocation = CSLGetBehindLocation( oTarget, SC_DISTANCE_MEDIUM );
				AssignCommand( oTarget, ClearAllActions() );
				CSLMoveToNewLocation(lNewLocation, oTarget);
			}
			else if ( sCommand2 == "left" )
			{
				location lNewLocation = CSLGetLeftLocation( oTarget, SC_DISTANCE_MEDIUM );
				AssignCommand( oTarget, ClearAllActions() );
				CSLMoveToNewLocation(lNewLocation, oTarget);
			}
			else if ( sCommand2 == "right" )
			{
				location lNewLocation = CSLGetRightLocation( oTarget, SC_DISTANCE_MEDIUM );
				AssignCommand( oTarget, ClearAllActions() );
				CSLMoveToNewLocation(lNewLocation, oTarget);
			}
			if ( sCommand2 == "forward10" )
			{
				location lNewLocation = CSLGetAheadLocation( oTarget, SC_DISTANCE_LARGE );
				AssignCommand( oTarget, ClearAllActions() );
				CSLMoveToNewLocation(lNewLocation, oTarget);
			}
			else if ( sCommand2 == "back10" )
			{
				location lNewLocation = CSLGetBehindLocation( oTarget, SC_DISTANCE_LARGE );
				AssignCommand( oTarget, ClearAllActions() );
				CSLMoveToNewLocation(lNewLocation, oTarget);
			}
			else if ( sCommand2 == "left10" )
			{
				location lNewLocation = CSLGetLeftLocation( oTarget, SC_DISTANCE_LARGE );
				AssignCommand( oTarget, ClearAllActions() );
				CSLMoveToNewLocation(lNewLocation, oTarget);
			}
			else if ( sCommand2 == "right10" )
			{
				location lNewLocation = CSLGetRightLocation( oTarget, SC_DISTANCE_LARGE );
				AssignCommand( oTarget, ClearAllActions() );
				CSLMoveToNewLocation(lNewLocation, oTarget);
			}
		}
		
		//DelayCommand( 0.35f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,4)=="jump")
	{
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "there" )
		{
			CSLDMPortThere( oTarget, oPC );
		}
		else if ( sCommand == "here" )
		{
			CSLDMPortHere( oTarget, oPC );
		}
		
		//DelayCommand( 0.35f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if (GetStringLeft(sInput,6)=="battle")
	{
		string sCommand = CSLNth_GetNthElement(sInput,2,"-");
		int n;
		object oTest;
		if (sCommand=="on")
		{
			n = 1;
			oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			while (GetIsObjectValid(oTarget))
			{
				AssignCommand(oTarget, ClearAllActions(TRUE));
				ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
				oTest = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oTarget, 1);
				if (GetIsObjectValid(oTest))
					DelayCommand(1.0, AssignCommand(oTarget, ActionAttack(oTest, FALSE)));
				n++;
				oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			}
			CSLMessage_SendText(oPC, "START BATTLE: All NPCs set to HOSTILE", TRUE, COLOR_GREEN);
		}
		else 
		{
			n = 1;
			oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			while (GetIsObjectValid(oTarget))
			{
				AssignCommand(oTarget, ClearAllActions(TRUE));
				ChangeToStandardFaction(oTarget, STANDARD_FACTION_COMMONER);
				n++;
				oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, n);
			}
			CSLMessage_SendText(oPC, "STOP BATTLE:  All NPCs set to Commoner", TRUE, COLOR_GREEN);
		}	
	}
	else if ( sInput=="xpadd" )
	{
		int iXPToAdd = StringToInt(sCommand);
		if ( iXPToAdd > 0 )
		{
			CSLGiveXP(oTarget, oPC, iXPToAdd);
		}
		else if ( iXPToAdd < 0 )
		{
			CSLGiveXP(oTarget, oPC, iXPToAdd);
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( sInput=="xplevel" )
	{
		int iLevels = StringToInt(sCommand);
		if ( iLevels > 0 )
		{
			CSLGiveLevel(oTarget, oPC, iLevels, TRUE);
		}
		else if ( iLevels < 0 )
		{
			CSLTakeLevel(oTarget, oPC, -iLevels, TRUE);
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,11)=="savingthrow")
	{
		//int CSLAdjustSaveEffect( int iAdjustmentAmount, int iSaveThrowType, object oTarget = OBJECT_SELF )
		int iSaveThrowType;
		string sSave = CSLNth_GetNthElement(sInput,2,"-");
		if ( sSave == "fortitude" ) { iSaveThrowType = SAVING_THROW_FORT; }
		else if ( sSave == "reflex" ) { iSaveThrowType = SAVING_THROW_REFLEX; }
		else if ( sSave == "will" ) { iSaveThrowType = SAVING_THROW_WILL; }
		else { return; }
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustSaveEffect( 1, iSaveThrowType, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+sSave+" increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustSaveEffect( -1, iSaveThrowType, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+sSave+" decrease effect of "+IntToString(iModifier)+" applied" );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,15)=="challengerating")
	{
		float fNewCR, fOldCR;
		fOldCR = CSLGetChallengeRating(oTarget);
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			CSLSetChallengeRating( oTarget, CSLGetWithinRangef(fOldCR,0.0f, 100.0f )+1.0f );
		}
		else if ( sCommand == "down" )
		{
			CSLSetChallengeRating( oTarget, CSLGetWithinRangef(fOldCR,0.0f, 100.0f )-1.0f );
		}	
		fNewCR = CSLGetChallengeRating(oTarget);
		if ( fNewCR != fOldCR )
		{
			SendMessageToPC( oPC, "Set CR of "+GetName(oTarget)+" from "+CSLFormatFloat(fOldCR)+" to "+CSLFormatFloat(fNewCR) );
		}
		else
		{
			SendMessageToPC( oPC, "CR of "+GetName(oTarget)+" was not changed, is at "+CSLFormatFloat(fOldCR) );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,4)=="gold")
	{
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustGold( 1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" was given "+IntToString(iModifier)+" gold pieces." );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustGold( -1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had "+IntToString(iModifier)+" gold pieces taken away." );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,11)=="encumbrance")
	{
		/*
		no option to do this
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			//int iModifier = CSLAdjustEncumbranceEffect( 1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a Arcane Spell Failure increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			//int iModifier = CSLAdjustEncumbranceEffect( -1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a Arcane Spell Failure decrease effect of "+IntToString(iModifier)+" applied" );
		}
		DelayCommand( 0.25f, SCCharEdit_Build( oTarget, oPC ) );
		*/
		return;
	}
	else if ( GetStringLeft(sInput,9)=="hitpoints")
	{
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			iModifier = CSLAdjustHitPoints( 1, oTarget);
			//SendMessageToPC( oPC, GetName(oTarget)+" had their hitpoints increased by "+IntToString(iModifier)+" points" );
		}
		else if ( sCommand == "down" )
		{
			iModifier = CSLAdjustHitPoints( -1, oTarget);
			//SendMessageToPC( oPC, GetName(oTarget)+" had their hitpoints decreased by "+IntToString(iModifier)+" points" );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,12)=="spellfailure")
	{
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustArcaneSpellFailureEffect( 1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a Arcane Spell Failure increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustArcaneSpellFailureEffect( -1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a Arcane Spell Failure decrease effect of "+IntToString(iModifier)+" applied" );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,10)=="armorcheck")
	{
		//int CSLAdjustACEffect( int iAdjustmentAmount, int iACType = AC_DODGE_BONUS, object oTarget = OBJECT_SELF )
		/*
		int iACType;
		string sAC = CSLNth_GetNthElement(sInput,2,"-");
		if ( sAC == "dodge" ) { iACType = AC_DODGE_BONUS; }
		else if ( sAC == "natural" ) { iACType = AC_NATURAL_BONUS; }
		else if ( sAC == "echantment" ) { iACType = AC_ARMOUR_ENCHANTMENT_BONUS; }
		else if ( sAC == "shield" ) { iACType = AC_SHIELD_ENCHANTMENT_BONUS; }
		else if ( sAC == "deflection" ) { iACType = AC_DEFLECTION_BONUS; }
		else { return; }
		*/
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustArmorCheckPenaltyEffect( 1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a Armor Check Penalty increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustArmorCheckPenaltyEffect( -1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a Armor Check Penalty decrease effect of "+IntToString(iModifier)+" applied" );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,2)=="ac")
	{
		//int CSLAdjustACEffect( int iAdjustmentAmount, int iACType = AC_DODGE_BONUS, object oTarget = OBJECT_SELF )
		int iACType;
		string sAC = CSLNth_GetNthElement(sInput,2,"-");
		if ( sAC == "dodge" ) { iACType = AC_DODGE_BONUS; }
		else if ( sAC == "natural" ) { iACType = AC_NATURAL_BONUS; }
		else if ( sAC == "echantment" ) { iACType = AC_ARMOUR_ENCHANTMENT_BONUS; }
		else if ( sAC == "shield" ) { iACType = AC_SHIELD_ENCHANTMENT_BONUS; }
		else if ( sAC == "deflection" ) { iACType = AC_DEFLECTION_BONUS; }
		else { return; }
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustACEffect( 1, iACType, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+sAC+" AC increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustACEffect( -1, iACType, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+sAC+" AC decrease effect of "+IntToString(iModifier)+" applied" );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,5)=="skill")
	{
		//int CSLAdjustSkillEffect( int iAdjustmentAmount, int iSkill, object oTarget = OBJECT_SELF )
		int iSkill;
		//string sSkill = CSLNth_GetNthElement(sInput,2,"-");
		string sButton = CSLNth_GetNthElement(sInput,3,"-");
		if ( CSLGetIsNumber(sCommand) ) { iSkill = StringToInt(sCommand); }
		else { return; }
		int iModifier;
		
		if ( sButton == "up" )
		{
			int iModifier = CSLAdjustSkillEffect( 1, iSkill, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+CSLSkillTypeToString(iSkill)+" Skill increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sButton == "down" )
		{
			int iModifier = CSLAdjustSkillEffect( -1, iSkill, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+CSLSkillTypeToString(iSkill)+" Skill  decrease effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sButton == "upf" )
		{
			int iModifier = CSLAdjustSkillBase( 1, iSkill, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had their "+CSLSkillTypeToString(iSkill)+" Skill set to "+IntToString(iModifier)+"" );
		}
		else if ( sButton == "downf" )
		{
			int iModifier = CSLAdjustSkillBase( -1, iSkill, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had their "+CSLSkillTypeToString(iSkill)+" Skill set to "+IntToString(iModifier)+"" );
		}
		
		DelayCommand( 0.05f, SCCharEdit_Build_SkillsListBox(oTarget, oPC, CSL_LISTBOXROW_MODIFY ) ); // rebuilds the skills list again
		return;
	}
	else if ( sInput == "tabopenskills" )
	{			
		DelayCommand( 0.00f, SCCharEdit_Build_SkillsListBox(oTarget, oPC, CSL_LISTBOXROW_ADD ) ); // rebuilds the skills list again
		
		return;
	}
	else if ( GetStringLeft(sInput,6)=="attack")
	{
		//int CSLAdjustAttackEffect( int iAdjustmentAmount, int iAttackType = ATTACK_BONUS_MISC, object oTarget = OBJECT_SELF )
		int iAttackType;
		string sAttack = CSLNth_GetNthElement(sInput,2,"-");
		if ( sAttack == "all" ) { iAttackType = ATTACK_BONUS_MISC; }
		else if ( sAttack == "onhand" ) { iAttackType = ATTACK_BONUS_ONHAND; }
		else if ( sAttack == "offhand" ) { iAttackType = ATTACK_BONUS_OFFHAND; }
		else { return; }
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustAttackEffect( 1, iAttackType, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+sAttack+" attack increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustAttackEffect( -1, iAttackType, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+sAttack+" attack decrease effect of "+IntToString(iModifier)+" applied" );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,6)=="damage")
	{
		//int CSLAdjustAttackEffect( int iAdjustmentAmount, int iAttackType = ATTACK_BONUS_MISC, object oTarget = OBJECT_SELF )
		int iDamageType;
		string sDamageType = CSLNth_GetNthElement(sInput,2,"-");
		if ( sDamageType == "varied" ) { iDamageType = DAMAGE_TYPE_VARIED; }
		else if ( sDamageType == "bludgeoning" ) { iDamageType = DAMAGE_TYPE_BLUDGEONING; }
		else if ( sDamageType == "piercing" ) { iDamageType = DAMAGE_TYPE_PIERCING; }
		else if ( sDamageType == "slashing" ) { iDamageType = DAMAGE_TYPE_SLASHING; }
		else if ( sDamageType == "magical" ) { iDamageType = DAMAGE_TYPE_MAGICAL; }
		else if ( sDamageType == "acid" ) { iDamageType = DAMAGE_TYPE_ACID; }
		else if ( sDamageType == "cold" ) { iDamageType = DAMAGE_TYPE_COLD; }
		else if ( sDamageType == "divine" ) { iDamageType = DAMAGE_TYPE_DIVINE; }
		else if ( sDamageType == "electrical" ) { iDamageType = DAMAGE_TYPE_ELECTRICAL; }
		else if ( sDamageType == "fire" ) { iDamageType = DAMAGE_TYPE_FIRE; }
		else if ( sDamageType == "negative" ) { iDamageType = DAMAGE_TYPE_NEGATIVE; }
		else if ( sDamageType == "positive" ) { iDamageType = DAMAGE_TYPE_POSITIVE; }
		else if ( sDamageType == "sonic" ) { iDamageType = DAMAGE_TYPE_SONIC; }
		else { return; }
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustDamageEffect( 1, iDamageType, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+sDamageType+" damage increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustDamageEffect( -1, iDamageType, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+sDamageType+" damage decrease effect of "+IntToString(iModifier)+" applied" );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,11)=="spellresist")
	{
		//int CSLAdjustAttackEffect( int iAdjustmentAmount, int iAttackType = ATTACK_BONUS_MISC, object oTarget = OBJECT_SELF )
		//int iAttackType;
		//string sAttack = CSLNth_GetNthElement(sInput,2,"-");
		//if ( sAttack == "all" ) { iAttackType = ATTACK_BONUS_MISC; }
		//else if ( sAttack == "onhand" ) { iAttackType = ATTACK_BONUS_ONHAND; }
		//else if ( sAttack == "offhand" ) { iAttackType = ATTACK_BONUS_OFFHAND; }
		//else { return; }
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustSREffect( 1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a Spell Resistan increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustSREffect( -1, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a Spell Resistance decrease effect of "+IntToString(iModifier)+" applied" );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,9)=="alignment")
	{
		//int CSLAdjustAttackEffect( int iAdjustmentAmount, int iAttackType = ATTACK_BONUS_MISC, object oTarget = OBJECT_SELF )
		int iAxis;
		string sAxis = CSLNth_GetNthElement(sInput,2,"-");
		if ( sAxis == "goodevil" ) { iAxis = ALIGNMENT_AXIS_GOODEVIL; sAxis = "Good Evil";}
		else if ( sAxis == "lawchaos" ) { iAxis = ALIGNMENT_AXIS_LAWCHAOS; sAxis = "Law Chaos"; }
		//else if ( sAttack == "offhand" ) { iAttackType = ATTACK_BONUS_OFFHAND; }
		//else { return; }
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		if ( sCommand == "up" )   // 
		{
			int iNewValue = CSLAdjustAlignment( 1, iAxis, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had their "+sAxis+" Alignment adjusted up by 1 to "+IntToString(iNewValue) );
		}
		else if ( sCommand == "down" )
		{
			int iNewValue = CSLAdjustAlignment( -1, iAxis, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had their "+sAxis+" Alignment adjusted down by 1 to "+IntToString(iNewValue) );
		}
		else if ( sCommand == "up10" )
		{
			int iNewValue = CSLAdjustAlignment( 10, iAxis, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had their "+sAxis+" Alignment adjusted up by 10 to "+IntToString(iNewValue) );
		}
		else if ( sCommand == "down10" )
		{
			int iNewValue = CSLAdjustAlignment( -10, iAxis, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had their "+sAxis+" Alignment adjusted down by 10 to "+IntToString(iNewValue) );
		}
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	else if ( GetStringLeft(sInput,4)=="stat")
	{
		int iStat;
		string sStat = CSLNth_GetNthElement(sInput,2,"-");
		if ( sStat == "str" ) { iStat = ABILITY_STRENGTH; }
		else if ( sStat == "con" ) { iStat = ABILITY_CONSTITUTION; }
		else if ( sStat == "dex" ) { iStat = ABILITY_DEXTERITY; }
		else if ( sStat == "wis" ) { iStat = ABILITY_WISDOM; }
		else if ( sStat == "int" ) { iStat = ABILITY_INTELLIGENCE; }
		else if ( sStat == "cha" ) { iStat = ABILITY_CHARISMA; }
		else { return; }
		int iModifier;
		string sCommand = CSLNth_GetNthElement(sInput,3,"-");
		
		if ( sCommand == "up" )
		{
			int iModifier = CSLAdjustAbilityEffect( 1, iStat, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+CSLAbilityStatToString(iStat,TRUE)+" increase effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "down" )
		{
			int iModifier = CSLAdjustAbilityEffect( -1, iStat, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had a "+CSLAbilityStatToString(iStat,TRUE)+" decrease effect of "+IntToString(iModifier)+" applied" );
		}
		else if ( sCommand == "upf" )
		{ 
			int iModifier = CSLAdjustAbilityBase( 1, iStat, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had their "+CSLAbilityStatToString(iStat,TRUE)+" set to "+IntToString(iModifier)+"" );
		}
		else if ( sCommand == "downf" )
		{ 
			int iModifier = CSLAdjustAbilityBase( -1, iStat, oTarget);
			SendMessageToPC( oPC, GetName(oTarget)+" had their "+CSLAbilityStatToString(iStat,TRUE)+" set to "+IntToString(iModifier)+"" );
		} 
		
		//stat-cha-down
		DelayCommand( 0.05f, SCCharEdit_Build( oTarget, oPC ) );
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "initradialeq" )
	{			
		///***********************************///
		//gui_wand_pim_init_radial_eq.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,initradialeq)
		//void main(int iItemId, int iSlot)
		int iItemId = StringToInt( sCommand );
		int iSlot = StringToInt( sParameter );
		
		object oItem = IntToObject(iItemId);
		
		if (!GetIsObjectValid(oItem))
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		string sItemName = GetName(oItem);
		// object oTarget = SCCharEdit_GetPimTarget(oPC);
		
		SCCharEdit_ResetListBoxesSelection (oPC);
		SetGUIObjectText(oPC, SCREEN_CHARACTEREDIT, "SELECTED_ITEM_NAME_EQUIPMENT", -1, sItemName);
		SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, 0, IntToString(iItemId));
		SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, 4, IntToString(iSlot));
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "initradial" )
	{			
		///***********************************///
		//gui_wand_pim_init_radial.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,initradial)
		//void main(int iItemId)
		int iItemId = StringToInt( sCommand );
		
		object oItem = IntToObject(iItemId);
		
		if (!GetIsObjectValid(oItem))
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		int iSlot1 = -1;
		int iSlot2 = -1;
		int iSlot3 = -1;
		string sItemName = GetName(oItem);
		// object oTarget = SCCharEdit_GetPimTarget(oPC);
		
		switch (GetBaseItemType(oItem))
		{
			case BASE_ITEM_BRACER:
			case BASE_ITEM_GLOVES:
				iSlot1 = INVENTORY_SLOT_ARMS;
				break;
		
			case BASE_ITEM_ARROW:
				iSlot1 = INVENTORY_SLOT_ARROWS;
				break;
		
			case BASE_ITEM_BELT:
				iSlot1 = INVENTORY_SLOT_BELT;
				break;
		
			case BASE_ITEM_BOLT:
				iSlot1 = INVENTORY_SLOT_BOLTS;
				break;
		
			case BASE_ITEM_BOOTS:
				iSlot1 = INVENTORY_SLOT_BOOTS;
				break;
		
			case BASE_ITEM_BULLET:
				iSlot1 = INVENTORY_SLOT_BULLETS;
				break;
		
			case BASE_ITEM_CREATUREITEM:
				iSlot1 = INVENTORY_SLOT_CARMOUR;
				break;
		
			case BASE_ITEM_ARMOR:
				iSlot1 = INVENTORY_SLOT_CHEST;
				break;
		
			case BASE_ITEM_CLOAK:
				iSlot1 = INVENTORY_SLOT_CLOAK;
				break;
		
			case BASE_ITEM_CBLUDGWEAPON:
			case BASE_ITEM_CPIERCWEAPON:
			case BASE_ITEM_CSLASHWEAPON:
			case BASE_ITEM_CSLSHPRCWEAP:
				iSlot1 = INVENTORY_SLOT_CWEAPON_R;
				iSlot2 = INVENTORY_SLOT_CWEAPON_L;
				iSlot3 = INVENTORY_SLOT_CWEAPON_B;
				break;
		
			case BASE_ITEM_HELMET:
				iSlot1 = INVENTORY_SLOT_HEAD;
				break;
		
			case BASE_ITEM_DRUM:
			case BASE_ITEM_FLUTE:
			case BASE_ITEM_MANDOLIN:
			case BASE_ITEM_LARGESHIELD:
			case BASE_ITEM_SMALLSHIELD:
			case BASE_ITEM_TORCH:
			case BASE_ITEM_TOWERSHIELD:
				iSlot2 = INVENTORY_SLOT_LEFTHAND;
				break;
		
			case BASE_ITEM_ALLUSE_SWORD:
			case BASE_ITEM_BASTARDSWORD:
			case BASE_ITEM_BATTLEAXE:
			case BASE_ITEM_CLUB:
			case BASE_ITEM_DAGGER:
			case BASE_ITEM_DWARVENWARAXE:
			case BASE_ITEM_FLAIL:
			case BASE_ITEM_HANDAXE:
			case BASE_ITEM_KAMA:
			case BASE_ITEM_KATANA:
			case BASE_ITEM_KUKRI:
			case BASE_ITEM_LIGHTFLAIL:
			case BASE_ITEM_LIGHTHAMMER:
			case BASE_ITEM_LIGHTMACE:
			case BASE_ITEM_LONGSWORD:
			case BASE_ITEM_MACE:
			case BASE_ITEM_MORNINGSTAR:
			case BASE_ITEM_RAPIER:
			case BASE_ITEM_SCIMITAR:
			case BASE_ITEM_SHORTSWORD:
			case BASE_ITEM_SICKLE:
			case BASE_ITEM_TRAINING_CLUB:
			case BASE_ITEM_WARHAMMER:
			case BASE_ITEM_WHIP:
				iSlot1 = INVENTORY_SLOT_RIGHTHAND;
				iSlot2 = INVENTORY_SLOT_LEFTHAND;
				break;
		
			case BASE_ITEM_DART:
			case BASE_ITEM_DIREMACE:
			case BASE_ITEM_DOUBLEAXE:
			case BASE_ITEM_FALCHION:
			case BASE_ITEM_GREATAXE:
			case BASE_ITEM_GREATCLUB:
			case BASE_ITEM_GREATSWORD:
			case BASE_ITEM_HALBERD:
			case BASE_ITEM_HEAVYCROSSBOW:
			case BASE_ITEM_HEAVYFLAIL:
			case BASE_ITEM_LIGHTCROSSBOW:
			case BASE_ITEM_LONGBOW:
			case BASE_ITEM_MAGICROD:
			case BASE_ITEM_QUARTERSTAFF:
			case BASE_ITEM_SCYTHE:
			case BASE_ITEM_SHORTBOW:
			case BASE_ITEM_SHORTSPEAR:
			case BASE_ITEM_SHURIKEN:
			case BASE_ITEM_SLING:
			case BASE_ITEM_SPEAR:
			case BASE_ITEM_THROWINGAXE:
			case BASE_ITEM_TWOBLADEDSWORD:
			case BASE_ITEM_WARMACE:
				iSlot1 = INVENTORY_SLOT_RIGHTHAND;
				if (!GetWeaponRanged(oItem) && GetHasFeat(FEAT_MONKEY_GRIP, oTarget))
				{
					iSlot2 = INVENTORY_SLOT_LEFTHAND;
				}
				break;
		
			case BASE_ITEM_RING:
				iSlot1 = INVENTORY_SLOT_RIGHTRING;
				iSlot2 = INVENTORY_SLOT_LEFTRING;
				break;
		
			case BASE_ITEM_AMULET:
				iSlot1 = INVENTORY_SLOT_NECK;
				break;
		
			default:
				break;
		}
		SetGUIObjectText(oPC, SCREEN_CHARACTEREDIT, "SELECTED_ITEM_NAME", -1, sItemName);
		
		if (iSlot1 == -1)
		{
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_1_ICON", TRUE);
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_1", TRUE);
		}
		else
		{
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_1_ICON", FALSE);
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_1", FALSE);
			SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, 1, IntToString(iSlot1));
		}
		
		if (iSlot2 == -1)
		{
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_2_ICON", TRUE);
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_2", TRUE);
		}
		else
		{
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_2_ICON", FALSE);
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_2", FALSE);
			SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, 2, IntToString(iSlot2));
		}
		
		if (iSlot3 == -1)
		{
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_3_ICON", TRUE);
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_3", TRUE);
		}
		else
		{
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_3_ICON", FALSE);
			SetGUIObjectDisabled(oPC, SCREEN_CHARACTEREDIT, "RADIAL_EQUIP_3", FALSE);
			SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, 3, IntToString(iSlot3));
		}
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "cursed" )
	{			
		///***********************************///
		//gui_wand_pim_cursed.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,cursed)
		///void main(int iItemId, int iSlot)
		int iItemId = StringToInt( sCommand );
		int iSlot = StringToInt( sParameter );
		
		object oItem = IntToObject(iItemId);
		
		if (GetItemCursedFlag(oItem))
		{
			SetItemCursedFlag(oItem, FALSE);
		}
		else
		{
			SetItemCursedFlag(oItem, TRUE);
		}
		if (iSlot == -1)
		{
			SCCharEdit_ModifyItem(oPC, oItem,SCREEN_CHARACTEREDIT);
		}
		else
		{
			SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, SCCharEdit_GetEquippedItemTooltip (oItem));
		}
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "droppable" )
	{			
		///***********************************///
		//gui_wand_pim_droppable.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,droppable)
		//void main(int iItemId, int iSlot)
		int iItemId = StringToInt( sCommand );
		int iSlot = StringToInt( sParameter );
		
		object oItem = IntToObject(iItemId);
		
		if (GetDroppableFlag(oItem))
		{
			SetDroppableFlag(oItem, FALSE);
		}
		else
		{
			SetDroppableFlag(oItem, TRUE);
		}
		if (iSlot == -1)
		{
			SCCharEdit_ModifyItem(oPC, oItem, SCREEN_CHARACTEREDIT);
		}
		else
		{
			SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, SCCharEdit_GetEquippedItemTooltip (oItem));
		}
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "equip" )
	{			
		///***********************************///
		//gui_wand_pim_equip.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,equip)
		//void main(int iItemId, int iSlot)
		int iItemId = StringToInt( sCommand );
		int iSlot = StringToInt( sParameter );
		
		object oItem = IntToObject(iItemId);
		// object oTarget = SCCharEdit_GetPimTarget(oPC);
		
		if (GetItemPossessor(oItem) != oTarget)
		{
			DisplayMessageBox(oPC, -1, "It's not possible to make equipping an item that is not present within the target's inventory!");
			return;
		}
		
		if (ITEM_LEVEL_RESTRICTION && GetGoldPieceValue(oItem) > StringToInt(Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", GetHitDice(oTarget) - 1)))
		{
			SetGUIObjectHidden(oPC, SCREEN_CHARACTEREDIT, "PANE_INVENTORY_RADIAL", FALSE);
			DisplayMessageBox(oPC, -1, "Item level restrictions don't allow to make equipping this item!");
			return;
		}
		
		if (!GetIdentified(oItem))
		{
			SetGUIObjectHidden(oPC, SCREEN_CHARACTEREDIT, "PANE_INVENTORY_RADIAL", FALSE);
			DisplayMessageBox(oPC, -1, "It's not possible to make equipping an unidentified item!");
			return;
		}
		
		AssignCommand(oTarget, CSLEquipItem(oItem, iSlot));
		SCCharEdit_ResetInventoryListboxes(oPC);
		DelayCommand(0.1, SCCharEdit_DisplayInventory (oPC, oTarget,SCREEN_CHARACTEREDIT));
		DelayCommand(0.4, SCCharEdit_CheckActionResult (oPC, oTarget, oItem, iSlot,SCREEN_CHARACTEREDIT));
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "examine" )
	{			
		///***********************************///
		//gui_wand_pim_examine.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,examine)
		//void main(int iItemId)
		int iItemId = StringToInt( sCommand );
		
		object oItem = IntToObject(iItemId);
		if ( GetIsObjectValid( oItem ) )
		{
			DisplayGuiScreen(oPC, "SCREEN_INVENTORY", FALSE);
			
			oItem = CopyItem(oItem, oPC, TRUE);
			if ( GetIsObjectValid( oItem ) )
			{
				SetIdentified(oItem, TRUE);
				//DelayCommand(0.4, AssignCommand(oPC, ActionExamine(oItem)));
				CSLExamine( oItem, oPC, 0.4 );
				DestroyObject(oItem, 0.6, FALSE);
			}
			DelayCommand(0.6, CloseGUIScreen(oPC, "SCREEN_INVENTORY"));
		}
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "give" )
	{			
		///***********************************///
		//gui_wand_pim_give.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,give)
		//void main()
		DelayCommand(0.2, SCCharEdit_GiveItem (oPC, SCCharEdit_GetPimTarget(oPC)));
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "identified" )
	{			
		///***********************************///
		//gui_wand_pim_identified.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,identified)
		//void main(int iItemId, int iSlot)
		int iItemId = StringToInt( sCommand );
		int iSlot = StringToInt( sParameter );
		
		object oItem = IntToObject(iItemId);
		// object oTarget = SCCharEdit_GetPimTarget(oPC);
		
		if (GetIdentified(oItem))
		{
			SetIdentified(oItem, FALSE);
		}
		else
		{
			SetIdentified(oItem, TRUE);
		}
		if (iSlot == -1)
		{
			SCCharEdit_ModifyItem(oPC, oItem, SCREEN_CHARACTEREDIT);
			SCCharEdit_UpdateInventoryValue(oPC, oTarget,SCREEN_CHARACTEREDIT);
		}
		else
		{
			SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, SCCharEdit_GetEquippedItemTooltip (oItem));
		}
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "plot" )
	{			
		///***********************************///
		//gui_wand_pim_plot.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,plot)
		//void main(int iItemId, int iSlot)
		int iItemId = StringToInt( sCommand );
		int iSlot = StringToInt( sParameter );
		
		object oItem = IntToObject(iItemId);
		// object oTarget = SCCharEdit_GetPimTarget(oPC);
		
		if (GetPlotFlag(oItem))
		{
			SetPlotFlag(oItem, FALSE);
		}
		else
		{
			SetPlotFlag(oItem, TRUE);
		}
		
		if (iSlot == -1)
		{
			SCCharEdit_ModifyItem(oPC, oItem,SCREEN_CHARACTEREDIT);
			SCCharEdit_UpdateInventoryValue(oPC, oTarget,SCREEN_CHARACTEREDIT);
		}
		else
		{
			SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, SCCharEdit_GetEquippedItemTooltip (oItem));
		}
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "reload" )
	{			
		///***********************************///
		//gui_wand_pim_reload.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,reload)
		//void main()
		// object oTarget = SCCharEdit_GetPimTarget(oPC);
		SCCharEdit_ResetInventoryListboxes(oPC,SCREEN_CHARACTEREDIT);
		SCCharEdit_DisplayInventory(oPC, oTarget,SCREEN_CHARACTEREDIT);
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "showtab" )
	{			
		///***********************************///
		//gui_wand_pim_show_tab.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,showtab)
		//void main(string sTabName)
		string sTabName = sCommand;
		
		SCCharEdit_ResetListBoxesSelection(oPC, SCREEN_CHARACTEREDIT);
		SCCharEdit_HideInventoryTabs(oPC, SCREEN_CHARACTEREDIT );
		//SendMessageToPC( GetFirstPC(), "Showing Tab "+sTabName );
		SetGUIObjectHidden(oPC, SCREEN_CHARACTEREDIT, sTabName, FALSE);
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "show" )
	{			
		///***********************************///
		//gui_wand_pim_show.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,show)
		//void main(int iTarget)
		
		// object oTarget = IntToObject(StringToInt( sCommand ));
		SCCharEdit_SetPimTarget(oPC, oTarget);
		DisplayGuiScreen(oPC, SCREEN_CHARACTEREDIT, FALSE, SCREEN_CHARACTEREDIT);
		SCCharEdit_DisplayInventory (oPC, oTarget, SCREEN_CHARACTEREDIT);
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "stolen" )
	{			
		///***********************************///
		//gui_wand_pim_stolen.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,stolen)
		//void main(int iItemId, int iSlot)	
		int iItemId = StringToInt( sCommand );
		int iSlot = StringToInt( sParameter );
		
		object oItem = IntToObject(iItemId);
		if (GetStolenFlag(oItem))
		{
			SetStolenFlag(oItem, FALSE);
		}
		else
		{
			SetStolenFlag(oItem, TRUE);
		}
		
		//SendMessageToPC(oPC, "iSlot: " + IntToString(iSlot));
		
		if (iSlot == -1)
		{
			SCCharEdit_ModifyItem(oPC, oItem,SCREEN_CHARACTEREDIT);
		}
		else
		{
			SetLocalGUIVariable(oPC, SCREEN_CHARACTEREDIT, WAND_PIM_SLOT_TOOLTIP_OFFSET + iSlot, SCCharEdit_GetEquippedItemTooltip (oItem));
		}
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "take" )
	{			
		///***********************************///
		//gui_wand_pim_take.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,take)
		//void main(string sItemId)
		object oItem = IntToObject(StringToInt(sCommand));
		// object oTarget = SCCharEdit_GetPimTarget(oPC);
		
		CopyItem(oItem, oPC, TRUE);
		
		DestroyObject(oItem, 0.0, FALSE);
		
		SCCharEdit_ResetInventoryListboxes(oPC,SCREEN_CHARACTEREDIT);
		DelayCommand(0.1, SCCharEdit_DisplayInventory(oPC, oTarget,SCREEN_CHARACTEREDIT));
		return;
	}
	// DM Inventory, from Caos81
	else if ( sInput == "unequip" )
	{			
		///***********************************///
		//gui_wand_pim_unequip.NSS
		// UIObject_Misc_ExecuteServerScript(gui_dminventory,pim,unequip)
		//void main(int iItemId)
		int iItemId = StringToInt( sCommand );
		
		object oItem = IntToObject(iItemId);
		// object oTarget = SCCharEdit_GetPimTarget(oPC);
		int iSlot = CSLGetCurrentSlotForItem( oItem );
		
		if (!GetIsObjectValid(oItem))
		{
			DisplayMessageBox(oPC, -1, "Values are incorrect!");
			return;
		}
		
		if (GetItemPossessor(oItem) != oTarget)
		{
			DisplayMessageBox(oPC, -1, "It's not possible to make equipping an item that is not present within the target's inventory!");
			return;
		}
		
		AssignCommand(oTarget, ActionUnequipItem(oItem));
		SCCharEdit_ResetInventoryListboxes(oPC,SCREEN_CHARACTEREDIT);
		DelayCommand(0.1, SCCharEdit_DisplayInventory(oPC, oTarget,SCREEN_CHARACTEREDIT));
		//DelayCommand(0.3, SCCharEdit_CheckActionResult(oPC, oTarget, oItem, iSlot,SCREEN_CHARACTEREDIT));
		return;
	}
	else if ( sInput == "tabopeninventory" )
	{			
		SCCharEdit_SetPimTarget(oPC, oTarget);
		SCCharEdit_DisplayInventory (oPC, oTarget);
		return;
	}
	
	else if ( sInput == "tabcloseinventory" )
	{			
		SCCharEdit_SetPimTarget(oPC, OBJECT_INVALID);
		return;
	}
	

}
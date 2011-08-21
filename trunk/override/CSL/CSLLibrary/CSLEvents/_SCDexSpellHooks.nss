/*

	This file is called each time a hook is done.
	
	Bascially the code here, and a few other scripts is run by each spell before it is run
	
*/
#include "_HkSpell"
#include "_CSLCore_Player"
// includes function to stop the spell script from firing
#include "x2_inc_switches"


//#include "_SCUtility"


void SCfizzleSpell( string sMessage = "Spell Fizzled", object oCaster = OBJECT_SELF );
void SCIncStack(object oCaster, int nInc = 1, int nStackLimit = 3);
int SCSpellStack(int iSpell, object oCaster);



//Note that this follows the reasoning that things should be permitted
void main()
{
	//if ( GetIsSinglePlayer() ) {DEBUGGING = 0;}	
	//DEBUGGING = GetLocalInt( GetModule(), "DEBUGLEVEL" );
	//if ( GetLocalInt( OBJECT_SELF, "SC_TESTER" ) )
	//{
	//	SendMessageToPC( OBJECT_SELF, "Running SpellHook Now for "+IntToString(GetSpellId()));;
	//}
	
	//if ( GetLocalInt( OBJECT_SELF, "SC_TESTER" ) )
	//{
	//	SendMessageToPC( OBJECT_SELF, "Spellhook:"+SCCacheStatsToString( OBJECT_SELF ) );
	//}
	
	// note that HKPERM_damagemodtype sets it for multiple castings...
	
	//this does random damage types
	//SetLocalInt( OBJECT_SELF, "HKTEMP_damagemodtype", CSLPickOneInt(DAMAGE_TYPE_COLD, DAMAGE_TYPE_FIRE, DAMAGE_TYPE_ACID, DAMAGE_TYPE_ELECTRICAL, DAMAGE_TYPE_SONIC, DAMAGE_TYPE_NEGATIVE, DAMAGE_TYPE_POSITIVE ) );
	//if (DEBUGGING >= 8) { CSLDebug( "Hook: Damage Set to <color=red>"+CSLDamagetypeToString( GetLocalInt( OBJECT_SELF, "HKTEMP_damagemodtype"))+"</color>" ); }
	
	// int nSpellDC=GetSpellSaveDC();
	object oTarget = HkGetSpellTarget();
	object oCaster = OBJECT_SELF;
	int iSpellId=GetSpellId();
	if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: Caster = "+GetName( oCaster )+" Target = "+GetName( oTarget )+" Spell="+IntToString( iSpellId ), oCaster ); }
	int iAttributes = CSLGetSpellAttributes( oCaster );
	//CSLDebug( CSLCharacterStatsToString( oCaster ) );
	
	if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: 2", oCaster ); }
	//SendMessageToPC( OBJECT_SELF, "Spellhook:"+SCCacheStatsToString( OBJECT_SELF ) );
	
	
	if ( !GetIsObjectValid(GetAreaFromLocation(GetLocation(oCaster))) )
	{
		SCfizzleSpell("Invalid Area.", oCaster );
		SetLocalString( oCaster, "CSL_ERRORSTRING", "Invalid Area" );
		return;
	}
	
	
	if ( CSLGetIsDM( oCaster, FALSE ) ) //  || GetIsDMPossessed( oCaster )
	{
		if (DEBUGGING >= 6) { CSLDebug( "Ending SpellHook, DM's are Not Restricted by This" ); }
		return; // DM's can do anything without regard for this
	}
		
	if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: 3", oCaster ); }
	
	if ( !HkCheckIfCanCastSpell( oCaster, iSpellId, GetLastSpellCastClass() ) )
	{
		string sErrorMessage = GetLocalString( oCaster, "CSL_ERRORSTRING" );
		if ( sErrorMessage != "" )
		{
			SCfizzleSpell(sErrorMessage, oCaster);
		}
		else
		{
			SCfizzleSpell("You don't have the requirements to cast spells of that level!", oCaster);
		}
		SetLocalString( oCaster, "CSL_ERRORSTRING", "" );
		return;
	}
	
	//if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: 4", oCaster ); }
	//if ( GetLocalInt( OBJECT_SELF, "SC_TESTER" ) )
	//{
	//SendMessageToPC( OBJECT_SELF, "Spellhook2:"+SCCacheStatsToString( OBJECT_SELF ) );
	//}
	
	//if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: 5", oCaster ); }
	int nRange = 10; // perhaps store this as a module int, so it can be varied at the whim of DM's
	
	
	
	if ( iAttributes & SCMETA_ATTRIBUTES_BUFF ) 
	{
		if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: 6 Buff", oCaster ); }
		// When not in town, don't let folks buff their enemies, most likely for their strategic advantage
		if ( !CSLGetIsInTown(oCaster) && GetIsReactionTypeHostile( oTarget, oCaster) && GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE  )
		{
			// GetCurrentMaster(oTarget);
			SCfizzleSpell("He doesn't like you, and helping him is not going to change that!",oCaster);
			return;
		}
		
		// Only permit buffs upon characters within a given range, with some accomodation for ECL
		if ( GetIsPC(oTarget) && GetIsPC(oCaster) && oTarget != oCaster  )
		{
			int nTargetEffectiveLevel = GetHitDice(oTarget) + CSLGetRaceDataECLCap( GetSubRace(oTarget) )+CSLGetRaceDataECL( GetSubRace(oTarget) ) ;
			int nCasterEffectiveLevel = GetHitDice(oCaster);
			if ( !CSLIsWithinRange( nTargetEffectiveLevel, nCasterEffectiveLevel - nRange, 30 ) )
			{
				SCfizzleSpell("You really should try helping someone your own size",oCaster);
				return;
			}
		}
		
	}
	//else if ( CSLGetIsRestorative(iSpellId) ) // a healing, rezing, or removing of harmful effects
	//{
	//	// check for if its beneficial or not to the target, only allow beneficial spells in town
	//	// the logic for these is very complicated i think so i'm going to be adding these in later
	//	
	//}
	//else
	//{
	if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: 7 Attack", oCaster ); }
	// this must be a hostile type spell, as it's not a buff or resorative type spell
	if ( iAttributes & SCMETA_ATTRIBUTES_CANTCASTINTOWN && CSLGetIsInTown(oCaster)  )
	{
		if ( d8() == 1 || GetSpellId() == SPELL_ICE_STORM  || GetSpellId() == SPELL_EARTHQUAKE || GetSpellId() == SPELL_PRISMATIC_SPRAY || GetSpellId() == SPELL_MORDENKAINENS_DISJUNCTION  || GetSpellId() ==  SPELL_LESSER_DISPEL  || GetSpellId() == SPELL_GREATER_DISPELLING || GetSpellId() ==  SPELL_DISPEL_MAGIC  || GetSpellId() == SPELL_GATE)
		{
			CSLStoneCasterInTown(oCaster);
		}
		SCfizzleSpell("You cannot cast this spell in town!", oCaster);
		return;
	}
		
		// need to think out whether it should return false or true on a counterspelling happening
	//if ( CSLCounterSpellHookCasting( oCaster, iSpellId ) )
	//{
	//	SCfizzleSpell("Counterspelled",oCaster);
	//	return;
	//}
		
	//}
	if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: 8", oCaster ); }
	if ( SCSpellStack(GetSpellId(), oCaster ) )
	{
		// fizzle message is in above function
		return;
	}
	if (DEBUGGING >= 4) { CSLDebug(  "_SCDexSpellHooks: 9", oCaster ); }
	//return;
	
	if ( GetLocalInt( oCaster, "CSL_MACRORECORDING") )
	{
		string sCurrentSpell = "SPELL:";
		sCurrentSpell += IntToString(iSpellId);
		
		sCurrentSpell += ":";
		if (oTarget==oCaster)
		{
			sCurrentSpell += "SELF";
		}
		
		CSLAppendLocalString( oCaster, "CSL_MACRO", sCurrentSpell+"|" );
	}

	if (DEBUGGING >= 6) { CSLDebug(  "Ending SpellHook, Spell is Permitted" ); }
}


void SCfizzleSpell( string sMessage = "Spell Fizzled", object oCaster = OBJECT_SELF )
{
	
	SendMessageToPC( oCaster, sMessage );
	SetLocalInt( oCaster, "HKTEMP_Blocked", TRUE );
	SetModuleOverrideSpellScriptFinished();
	//return;
	// need to determine when things should fizzle and when things should stone
	// I might be able to put a local int, and increment on each fizzle in town for each hostile spell
	// then increment warnings, and once stoned increment stoning
}


//#include "x2_inc_switches"
//#include "seed_db_inc"

void SCIncStack(object oCaster, int nInc = 1, int nStackLimit = 3)
{
	int nStack = CSLGetMax(0, GetLocalInt(oCaster, "AOESTACK") + nInc);
	SetLocalInt(oCaster, "AOESTACK", nStack);
	string sMsg = "<color=cyan>AOE Stack:</color><color=green> Clear</color>";
	if (nStack)
	{
		sMsg="<color=cyan>AOE Stack:</color> ";
		if (nInc==1) sMsg += "<color=red>"; // GOING UP
		else sMsg +="<color=yellow>"; // COOLING DOWN
		sMsg += IntToString(nStack) + " of " + IntToString(nStackLimit) + "</color>";
	}
	FloatingTextStringOnCreature(sMsg, oCaster, FALSE);
}



int SCSpellStack(int iSpell, object oCaster)
{
	int iMaxAOEs = CSLGetPreferenceInteger( "MaxAOEs", 0 );
	
	if (!GetIsPC(OBJECT_SELF) || iMaxAOEs < 1 )
	{
		return TRUE;
	}
	
	int nRadius = CSLGetAOERadius(iSpell);
	if (nRadius>0)
	{
		int nStack = GetLocalInt(oCaster, "AOESTACK");
		int nStackLimit = iMaxAOEs;
		int nDur = 8;
		int nSkill = GetSkillRank(SKILL_CONCENTRATION, oCaster, TRUE) / 10;
		if (nSkill)
		{
			nStackLimit+=nSkill;
			nDur+= nSkill * 2;
		}
		if (nStack >= nStackLimit)
		{
			//SetModuleOverrideSpellScriptFinished();
			SCfizzleSpell("Your concentration is too strained to cast another AOE spell (" + IntToString(nStackLimit) + " per " + IntToString(nDur) + " rounds)", oCaster);
			//SendMessageToPC(oCaster, "Your concentration is too strained to cast another AOE spell (" + IntToString(nStackLimit) + " per " + IntToString(nDur) + " rounds)");
			return TRUE;
		}
		else
		{
			SCIncStack(oCaster, 1, nStackLimit);
			AssignCommand(oCaster, DelayCommand(RoundsToSeconds(nDur), SCIncStack(oCaster, -1, nStackLimit)));
			return FALSE;
		}
	}
	return TRUE;
}

//void main() {
// if (!GetIsPC(OBJECT_SELF)) return;
//
//}
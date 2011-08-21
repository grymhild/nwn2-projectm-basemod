
#include "_CSLCore_Magic_c"
#include "_CSLCore_Messages"
#include "_SCInclude_Necromancy"
// Handles desecration and consecration of an altar


void removeIntruderAboveMax( object oPC, int iRoundsCanRemain, int bInitialRound = TRUE )
{
	if ( CSLGetIsDM( oPC, FALSE ) )
	{
		return; // ignore DM's
	}
	
	int nMax = GetLocalInt(GetArea(oPC), "MAXLEVEL");
	if ( nMax == 0 || nMax >  GetHitDice(oPC) )
	{
		if ( !GetIsInCombat( oPC ) && !GetIsDead(oPC,TRUE) )
		{
			if ( bInitialRound || iRoundsCanRemain < 6 || !( iRoundsCanRemain % 10 ) )
			{
				SendMessageToPC( oPC, "You will die in "+IntToString(iRoundsCanRemain)+" rounds unless you leave "+GetName(GetArea(oPC)) );
			}
			if ( d4() == 1 && GetAbilityScore(oPC, ABILITY_CONSTITUTION, FALSE) < iRoundsCanRemain ) // this gives them a strong hint to leave, is semi random
			{
				DelayCommand(0.5f, SCApplyDeadlyAbilityDrainEffect( d4(), ABILITY_CONSTITUTION, oPC, DURATION_TYPE_PERMANENT, 0.0f, OBJECT_SELF ) );
				DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_POISON), oPC));
			}
			
			if ( iRoundsCanRemain < 1 ) // go ahead and kill them, note this will happen again the minute they get rezzed
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE, TRUE, TRUE, TRUE), oPC);
				if ( iRoundsCanRemain < -5 ) // really force it
				{
					SetPlotFlag(oPC, FALSE);
					SetImmortal(oPC, FALSE);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath( FALSE, FALSE, TRUE )), oPC);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDamage(GetCurrentHitPoints(oPC))), oPC);
				}
			}
			iRoundsCanRemain--; // only do countdown while they are not fighting, that way they can finish
		}
		DelayCommand(6.0, removeIntruderAboveMax( oPC, iRoundsCanRemain, FALSE ) );
	}
}

void removeIntrudersAboveMax( object oArea, int iRoundsCanRemain )
{
	object oPC = GetFirstPC();
	while ( oPC != OBJECT_INVALID )
	{
		if ( GetArea( oPC ) == oArea && !CSLGetIsDM( oPC, FALSE ) )
		{
			removeIntruderAboveMax( oPC, iRoundsCanRemain );
		}
		oPC = GetNextPC();
	}
}



void main()
{
	object oPlaceable = OBJECT_SELF;               	// The target of the given spell
	object oCaster = GetLastSpellCaster();     // The item targeted by the spell
	int iSpell = GetLastSpell();                  // The id of the spell that was cast See the list of SPELL_* constants
	int bHarmful = GetLastSpellHarmful();
	object oArea = GetArea(oPlaceable);
                                            	// 
 	int iMaxLevel;
	if ( iSpell == SPELL_DESECRATE )
	{
		iMaxLevel = GetLocalInt( oArea, "MAXLEVEL" );
		if ( iMaxLevel == 20 )
		{
			CSLPlayerMessageBroadcast( GetName(oArea)+" has been Desecrated, and restrictions removed", FALSE, TRUE, GetTag(oArea) );
			SetLocalInt( oArea, "MAXLEVEL", 30 );
		}
	}
	else if ( iSpell == SPELL_CONSECRATE )
	{
		iMaxLevel = GetLocalInt( oArea, "MAXLEVEL" );
		if ( iMaxLevel == 30 )
		{
			CSLPlayerMessageBroadcast( GetName(oArea)+" has been Consecrated, and restrictions restored, all intruders should flee or else", FALSE, TRUE, GetTag(oArea) );
			SetLocalInt( oArea, "MAXLEVEL", 20 );
			
			DelayCommand(6.0, removeIntruderAboveMax( oArea, 30 ) );
		}
	}

	
}
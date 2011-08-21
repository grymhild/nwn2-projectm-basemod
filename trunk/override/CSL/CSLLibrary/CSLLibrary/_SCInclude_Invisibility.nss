/** @file
* @brief Include File for Invisibility Magic
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/




//::///////////////////////////////////////////////
/// Includes OEI invis functions and MP Invis Fix Heavily Edited, need to review PRC code for useful additions
//:: PW Invisibility FIX include
//:: dd_inv_inc.nss
//:: Copyright (c) 2007 Dedo
//:://////////////////////////////////////////////


#include "_HkSpell"
#include "_SCInclude_Invocations"
#include "_SCInclude_Abjuration"

/*
	Constants and utility functions for MP invisibility
*/


const float F_DELAY = 10.0f;

const int INVISIBLE = 2;
const int TRANSPARENT = 1;
const int VISIBLE = 0;
const int INVISID = 999;
const int TRANSPID = 998;
const int SVIRNEFBLIN_INVISIBILITY = 944;
const int DUERGAR_INVISIBILITY = 804;

/*
void SCHeartBeatInvisCheck( object oPC );
int EnemySeeing(object oPC);
void SetInvisible(object oTarget, float fDuration);
void SCOnDispelRetributiveCallback(object oCaster, int iSaveDC);
void SwitchInvisibility(object oPC, int iStatus);
void SCApplyInvisibility( object oTarget, object oCaster, float fDuration, int iSpellId, int iConcealment = 0, int bSignal = TRUE );
void SCReapplyCanceledInvisibility(object oTarget, float fDuration, int iSpellId );
*/


int EnemySeeing(object oPC)
{
	// can probably put some spot type checks here
	location lPCPosition = GetLocation(oPC);
	object oEnemy = GetFirstObjectInShape(SHAPE_SPHERE,30.0,lPCPosition,FALSE,OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oEnemy))
	{
		if (  CSLGetHasEffectSpellIdGroup( oEnemy,  SPELL_SEE_INVISIBILITY, SPELL_BLINDSIGHT, SPELL_TRUE_SEEING, SPELL_I_SEE_THE_UNSEEN ) && (oEnemy != oPC) )
		{
			if (LineOfSightObject(oPC, oEnemy)) { return 1; }
		}
		oEnemy=GetNextObjectInShape(SHAPE_SPHERE,20.0,lPCPosition,FALSE,OBJECT_TYPE_CREATURE);
	}
	return 0;
}

/**  
* This is the MP invisibility Fix
* @author
* @param 
* @see 
* @return 
*/
void SwitchInvisibility(object oPC, int iStatus)
{
	effect eLook = GetFirstEffect(oPC);
	effect e1 = EffectVisualEffect( VFX_DUR_INVISIBILITY );
	effect e2 = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
	while (GetIsEffectValid(eLook))
	{
		if (GetEffectSpellId(eLook) == INVISID && iStatus != INVISIBLE) {RemoveEffect(oPC, eLook);}
		if (GetEffectSpellId(eLook) == TRANSPID && iStatus != TRANSPARENT) {RemoveEffect(oPC, eLook);}
		eLook = GetNextEffect(oPC);
	}
	switch (iStatus)
	{
	case 1:
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, SetEffectSpellId(e1, TRANSPID), oPC);
		SetLocalInt(oPC, "STATUS", TRANSPARENT);
		break;
	case 2:
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, SetEffectSpellId(e2, INVISID), oPC);
		SetLocalInt(oPC, "STATUS", INVISIBLE);
		break;
	default:
		DeleteLocalInt(oPC, "STATUS");
		break;
	}
}


/* This applies or removes the invisibility override soas to make characters visible, transparent, or completely invisible */
void SCHeartBeatInvisCheck( object oPC )
{
	if (  GetLocalInt( GetModule(), "SC_MPINVISFIX" ) == TRUE )
	{
		if ( CSLGetHasEffectSpellIdGroup( oPC, SPELL_INVISIBILITY,  SPELL_GREATER_INVISIBILITY, SPELL_INVISIBILITY_SPHERE, SPELL_MASS_INVISIBILITY, SPELL_I_RETRIBUTIVE_INVISIBILITY, SPELL_I_WALK_UNSEEN, SPELLABILITY_AS_INVISIBILITY, DUERGAR_INVISIBILITY, SVIRNEFBLIN_INVISIBILITY ) )
		{
			if ( CSLGetHasEffectType( oPC, EFFECT_TYPE_INVISIBILITY  ) || CSLGetHasEffectType( oPC, EFFECT_TYPE_GREATERINVISIBILITY  ) )
			{
				int iEnemySeeing = EnemySeeing(oPC);
				if (iEnemySeeing == 1 && GetLocalInt(oPC, "STATUS") != TRANSPARENT ) //INVISIBLE)
				{
					SwitchInvisibility(oPC, TRANSPARENT);
				}
				if (iEnemySeeing == 0 && GetLocalInt(oPC, "STATUS") != INVISIBLE ) //TRANSPARENT)
				{
					SwitchInvisibility(oPC, INVISIBLE);
				}
			}
			else if ( GetLocalInt(oPC, "STATUS") != TRANSPARENT )
			{ // must only have concealment so make transparent, invis will flip back on if out of combat
				SwitchInvisibility(oPC, TRANSPARENT);
			}
		}
		else
		{
			if ( GetLocalInt(oPC, "STATUS") != VISIBLE) // don't bother if they are already visible
			{
				SwitchInvisibility(oPC, VISIBLE);
			}
		}
	}
}



void SetInvisible(object oTarget, float fDuration)
{
	effect eTrueInvis = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrueInvis, oTarget, fDuration, INVISID);
	SetLocalInt(oTarget, "STATUS", INVISIBLE);
}





void SCReapplyCanceledInvisibility(object oTarget, float fDuration, int iSpellId )
{
	float fDurationLeft = fDuration - F_DELAY;
	if (fDurationLeft < F_DELAY) return; // we be done - duration has expired
	if ( ( !GetLocalInt(oTarget, "UNDERWATER") && GetIsInCombat(oTarget) ) || GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oTarget )  || GetHasSpellEffect( SPELL_GLITTERDUST, oTarget )  ) // check again later
	{ 
		if (DEBUGGING >= 6) { CSLDebug( "Invis: A You are in combat, waiting to apply", oTarget ); }
		DelayCommand(F_DELAY, SCReapplyCanceledInvisibility(oTarget, fDurationLeft, iSpellId));
		return;
	}
	// check for both concealment (doesn't get canceled by anything but resting/dispel) and for invis effect
	effect eEffectLoop = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffectLoop))
	{
		//if (GetEffectType(eEffectLoop) == INVISIBILITY_TYPE_NORMAL)
		//{     // if we find invis, we don't need to do anything yet
		//	if (DEBUGGING >= 6) { CSLDebug(  "Invis: B Still has invisibility", oTarget ); }
		//	DelayCommand(F_DELAY, SCReapplyCanceledInvisibility(oTarget, fDurationLeft, iSpellId));
		//	return;
		//}
		// if we find concealment, and it was applied by impr invis, we know the spell is still active
		if (GetEffectType(eEffectLoop)==EFFECT_TYPE_CONCEALMENT)
		{
			if (GetEffectSpellId(eEffectLoop) == iSpellId )
			{
				/*
				effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
				effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_GREATER_INVISIBILITY));
				eInvis = EffectLinkEffects(eInvis, eOnDispell);
				eInvis = SetEffectSpellId(eInvis, SPELL_GREATER_INVISIBILITY);
				*/
				//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDurationLeft);
				
				//SCApplyInvisibility( oTarget, OBJECT_INVALID, fDuration, iSpellId, 0, FALSE );
				if ( GetLocalInt(oTarget, "UNDERWATER") )
				{
					if ( GetEffectInteger(eEffectLoop,1) != 30 )
					{
						SendMessageToPC( oTarget, "Adjusting the Concealment to 30% from "+IntToString(GetEffectInteger(eEffectLoop,1)) );
						RemoveEffect(oTarget, eEffectLoop );
						effect eConcealment = EffectConcealment( 30 );
						eConcealment = SetEffectSpellId( eConcealment, iSpellId );
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConcealment, oTarget, fDurationLeft );
					}
				}
				else
				{
					effect eInvis = EffectInvisibility( INVISIBILITY_TYPE_NORMAL );
					eInvis = EffectLinkEffects( eInvis, EffectSkillIncrease(SKILL_HIDE,20) );
					eInvis = EffectLinkEffects( eInvis, EffectAttackIncrease(2) );
					eInvis = EffectLinkEffects( eInvis, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK) );
					eInvis = SetEffectSpellId( eInvis, iSpellId );
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDurationLeft );
				}
				
				DelayCommand(F_DELAY, SCReapplyCanceledInvisibility(oTarget, fDurationLeft, iSpellId )); // check again later
				return;
			}
			else
			{
				if (DEBUGGING >= 6) { CSLDebug(  "Invis: D Does not have greater invis", oTarget ); }
			}
		}
		else
		{
			if (DEBUGGING >= 6) { CSLDebug(  "Invis: C Does not have concealment", oTarget ); }
		}
		eEffectLoop = GetNextEffect(oTarget);
	}
}

int CSLRemoveInvisibilityWhenUnderwater(object oPC )
{
	int bRemove = FALSE;
	effect eSearch = GetFirstEffect(oPC);
	while (GetIsEffectValid(eSearch))
	{
		int bRestart = FALSE;
		//Check to see if the effect matches a particular type defined below
		if ( GetEffectType(eSearch)==EFFECT_TYPE_INVISIBILITY || GetEffectType(eSearch)==EFFECT_TYPE_GREATERINVISIBILITY )
		{
			RemoveEffect(oPC, eSearch);
			bRemove = TRUE;
			bRestart = TRUE;
		}
		if (bRestart) eSearch = GetFirstEffect(oPC);
		else eSearch = GetNextEffect(oPC);
	}
	return bRemove;
}

void SCApplyImpEtheralness( object oTarget, object oCaster, float fDuration, int iSpellId, int iVfxEffect = VFX_DUR_SPELL_ETHEREALNESS )
{
	
	if ( CSLGetPreferenceSwitch("EtherealRemovedByInvisPurge",FALSE) && GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oTarget ))
	{
		// Cannot be cast when in a purge AOE
		CSLPlayerMessageSplit( "Invisibility Purge Prevents Going Etheral", oTarget, oCaster );
		return;
	}
	
	if ( !CSLGetCanEthereal( oTarget ) )
	{
		SendMessageToPC( oTarget, "You are Dimensionally Anchored");
		return;
	}
					
	/* These spells should ignore etheralness, probably need to work on these from inside their spell
	// Things with the foce descriptor basically
	SPELL_BLADE_BARRIER 5 Force
	SPELL_MAGE_ARMOR 102 Force
	SPELL_MAGIC_MISSILE 107 Force
	SPELL_MORDENKAINENS_SWORD 123 Force
	SPELL_BIGBYS_INTERPOSING_HAND 459 Force
	SPELL_BIGBYS_FORCEFUL_HAND 460 Force
	SPELL_BIGBYS_GRASPING_HAND 461 Force
	SPELL_BIGBYS_CLENCHED_FIST 462 Force
	SPELL_BIGBYS_CRUSHING_HAND 463 Force
	SPELL_BLADE_BARRIER_WALL 986 Force
	SPELL_BLADE_BARRIER_SELF 987 Force
	*/
	effect eEtheral;
	
	eEtheral = EffectInvisibility( INVISIBILITY_TYPE_IMPROVED );
	// does not go away
	//eEtheral = EffectInvisibility( INVISIBILITY_TYPE_NORMAL );
	// goes away on hostile perhaps
	eEtheral = EffectLinkEffects(eEtheral, EffectEthereal() );
	if ( GetLocalInt( GetModule(), "SC_MPINVISFIX" ) != TRUE ) // only do visual effects when not using MP Invisibility fix
	{
		eEtheral = EffectLinkEffects(eEtheral, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE) );
		eEtheral = EffectLinkEffects(eEtheral, EffectVisualEffect( iVfxEffect ));
	}
	
	// need to make sure the following go away on dispel or ending, would make players too uber
	// really just trying to protec them from various bugs

	// AOEs affecting
	eEtheral = EffectLinkEffects( eEtheral, EffectSpellLevelAbsorption(9, 999, SPELL_SCHOOL_GENERAL) ); // Absorbs all spells with spell resistance.

	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_ACID, 9999, 0) ); // this is to block AOE damage and attacks like whirlwind
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_SONIC, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_DIVINE, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 9999, 0) );
	// eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_MAGICAL, 9999, 0) ); // assuming magical damage should be permitted, otherwise might be able to avoid magic missle

	// whirlwind attacks
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 9999, 0) );
	eEtheral = EffectLinkEffects( eEtheral, EffectDamageReduction(999, 0, 0, DR_TYPE_NONE) );
	
	eEtheral = EffectLinkEffects( eEtheral, EffectCutsceneGhost() );
	
	// Might as well try concealment
	eEtheral = EffectLinkEffects( eEtheral, EffectConcealment( 100 ) );
	
	// make sure the above go away upon the end of this
	eEtheral = EffectLinkEffects( eEtheral, EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId ))  ); // ensures all these cool immunities come off
	eEtheral = SetEffectSpellId( eEtheral, iSpellId );
	// eEtheral = SupernaturalEffect(eEtheral);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_GLITTERDUST, SPELL_DECK_BUTTERFLYSPRAY );


	DelayCommand(0.0f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEtheral, oTarget, fDuration, iSpellId) );
	
}


//SCApplyInvisibility( oTarget, oCaster, fDuration, SPELL_GREATER_INVISIBILITY, 50 );

//SCApplyInvisibility( oTarget, oCaster, fDuration, SPELL_INVISIBILITY, 0 );

// note that this sets the spell id, so it can be called from any script with the proper id and it will act like the proper effect
void SCApplyInvisibility( object oTarget, object oCaster, float fDuration, int iSpellId, int iConcealment = 0, int bSignal = TRUE )  // , int bReapply = FALSE
{
	int bSplitEffects = FALSE;
	
	if ( GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oTarget ))
	{
		// Cannot be cast when in a purge AOE
		SendMessageToPC( oTarget, "Invisibility Purge Prevents Invisibility" );
		return;
	}
	
	if ( GetHasSpellEffect( SPELL_GLITTERDUST, oTarget ))
	{
		// Cannot be cast when in a purge AOE
		//SendMessageToPC( oTarget, "Glitterdust Prevents Invisibility" );
		return;
	}
	
	effect eConceal;
	effect eInvis;
	eInvis = EffectLinkEffects( eInvis, EffectSkillIncrease(SKILL_HIDE,20) );
	eInvis = EffectLinkEffects( eInvis, EffectAttackIncrease(2) );
	eInvis = EffectLinkEffects( eInvis, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK) );
	/*
	if ( iSpellId == SPELL_I_RETRIBUTIVE_INVISIBILITY ) // single effect with both conceal and invis, with call back if dispelled
	{
		int iSaveDC = GetInvocationSaveDC(oCaster, TRUE);
		//float fDuration = 2.0 + HkGetWarlockBonus(oCaster);
		//eInvis = EffectInvisibility( INVISIBILITY_TYPE_IMPROVED ); // does not go away
		eInvis = EffectInvisibility( INVISIBILITY_TYPE_NORMAL ); // goes away on hostile
		eInvis = EffectLinkEffects( eInvis, EffectOnDispel( 0.5f, SCOnDispelRetributiveCallback(oCaster, iSaveDC )) );
		eInvis = EffectLinkEffects( eInvis, EffectVisualEffect(VFX_DUR_INVOCATION_RETRIBUTIVE_INVISIBILITY));
		if ( GetLocalInt( GetModule(), "SC_MPINVISFIX" ) != TRUE )
		{
			eInvis = EffectLinkEffects( eInvis, EffectVisualEffect( VFX_DUR_INVISIBILITY ) );
		}
		
		eInvis = EffectLinkEffects( eInvis, EffectConcealment( iConcealment ) );
		eInvis = SetEffectSpellId( eInvis, iSpellId );
	}
	else 
	*/
	if ( iSpellId == SPELL_DISAPPEAR )
	{
		eInvis = EffectInvisibility( INVISIBILITY_TYPE_IMPROVED );
		eInvis = EffectLinkEffects( eInvis, EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY ) );
		eInvis = SetEffectSpellId( eInvis, iSpellId );
	}
	else if ( iConcealment > 0 ) // dual effects with conceal and invis, and callback to dispel both if one goes away
	{
		bSplitEffects = TRUE;
		
		if ( GetLocalInt(oTarget, "UNDERWATER") )
		{
			eConceal = EffectConcealment( iConcealment-20 );
			eInvis = EffectLinkEffects( EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectVisualEffect(VFX_DUR_INVISIBILITY) );
		}
		else if ( GetLocalInt( GetModule(), "SC_MPINVISFIX" ) == TRUE )
		{
			//eInvis = EffectInvisibility( INVISIBILITY_TYPE_IMPROVED ); // does not go away
			eInvis = EffectInvisibility( INVISIBILITY_TYPE_NORMAL ); // goes away on hostile
			eConceal = EffectConcealment( iConcealment );
			effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId ));
			eConceal = EffectLinkEffects(eConceal, eOnDispell);
			eInvis = EffectLinkEffects(eInvis, eOnDispell);
		}
		else
		{
			eInvis = EffectInvisibility( INVISIBILITY_TYPE_NORMAL );
		
			// On Dispel Handling  - This is put on both effects, this is needed when both are applied
			effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId ));
			
			eConceal = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
			eConceal = EffectLinkEffects(eConceal, EffectConcealment( iConcealment ));
			eConceal = EffectLinkEffects(eConceal, EffectVisualEffect(VFX_DUR_INVISIBILITY));
			
			eConceal = EffectLinkEffects(eConceal, eOnDispell);
			eInvis = EffectLinkEffects(eInvis, eOnDispell);
		}
		if ( iSpellId == SPELL_I_RETRIBUTIVE_INVISIBILITY )
		{
			int iSaveDC = GetInvocationSaveDC(oCaster, TRUE);
			eInvis = EffectLinkEffects( eInvis, EffectOnDispel( 0.5f, SCOnDispelRetributiveCallback(oCaster, iSaveDC )) );
		}
		eConceal = SetEffectSpellId( eConceal, iSpellId );
		eInvis = SetEffectSpellId( eInvis, iSpellId );
	}
	else // single effect with invis
	{
		if ( GetLocalInt(oTarget, "UNDERWATER") )
		{
			eInvis = EffectLinkEffects( EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), EffectVisualEffect(VFX_DUR_INVISIBILITY) );
		}
		else
		{
			eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
			if ( GetLocalInt( GetModule(), "SC_MPINVISFIX" ) != TRUE )
			{
				eInvis = EffectInvisibility( INVISIBILITY_TYPE_NORMAL );
				eInvis = EffectLinkEffects( eInvis, EffectVisualEffect( VFX_DUR_INVISIBILITY ) );
				eInvis = EffectLinkEffects(eInvis, EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId )) );
			}
		}
		eInvis = SetEffectSpellId( eInvis, iSpellId );
	}
	
	if ( bSignal == TRUE )
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	}
	
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ILLUSION), oTarget);
	if ( bSplitEffects == TRUE )
	{
		// Apply Concealment effect, note that retributive has more than
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, fDuration, iSpellId);
	}
	
	int iDurType = DURATION_TYPE_TEMPORARY;
	if ( iSpellId == SPELL_GLITTERDUST)
	{
		iDurType = DURATION_TYPE_PERMANENT;
		fDuration = 0.0f;
	}
	HkApplyEffectToObject(iDurType, eInvis, oTarget, fDuration, iSpellId);
	
	// MP Invisibility Fix
	if ( GetIsPC(oTarget) && GetLocalInt( GetModule(), "SC_MPINVISFIX" ) == TRUE )
	{
		SetInvisible(oTarget, fDuration);
	}
}

//(int RemoveMethod, object oCreator, object oTarget, int iEffectID )



/**  
* This is the MP invisibility Fix
* @author
* @param 
* @see 
* @return 
*/
/*
void CSLToggleInvisibility(object oPC, int iStatus)
{
	effect eLook = GetFirstEffect(oPC);
	effect e1 = EffectVisualEffect( VFX_DUR_INVISIBILITY );
	effect e2 = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY );
	while (GetIsEffectValid(eLook))
	{
		if (GetEffectSpellId(eLook) == INVISID2 && iStatus != INVISIBLE2) {RemoveEffect(oPC, eLook);}
		if (GetEffectSpellId(eLook) == TRANSPID2 && iStatus != TRANSPARENT2) {RemoveEffect(oPC, eLook);}
		eLook = GetNextEffect(oPC);
	}
	switch (iStatus)
	{
	case 1:
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SetEffectSpellId(e1, TRANSPID2), oPC);
		SetLocalInt(oPC, "STATUS", TRANSPARENT2);
		break;
	case 2:
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SetEffectSpellId(e2, INVISID2), oPC);
		SetLocalInt(oPC, "STATUS", INVISIBLE2);
		break;
	default:
		DeleteLocalInt(oPC, "STATUS");
		break;
	}

}
*/
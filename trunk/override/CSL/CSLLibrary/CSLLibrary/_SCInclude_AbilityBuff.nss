/** @file
* @brief Include for Ability Buffs and related exploit preventions
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_HkSpell"

/*
	-Bigby's Interposing Hand (x0_s0_bigby1)
	-Bigby's Forceful Hand (x0_s0_bigby2)
	-Bigby's Grasping Hand (x0_s0_bigby3)
	-Bigby's Clenched Fist (x0_s0_bigby4)
	-Bigby's Crushing Hand (x0_s0_bigby5)

*/

//const int VFX_HIT_BIGBYS_CLENCHED_FIST = 837;

void SCPreCheckHitpoints(object oTarget )
{
	// lets store the current hit points, max hit points, base con, and buffed con
	// going to check if this changes with the current buff being applied
	int nHP = GetCurrentHitPoints(oTarget);
    int nMaxHP = GetMaxHitPoints(oTarget);
    
    int iHD = GetHitDice(oTarget);
    
    int nConBuffedScore = GetAbilityModifier(ABILITY_CONSTITUTION, oTarget);
    int nConRawScore = GetAbilityScore(oTarget, ABILITY_CONSTITUTION, TRUE);
    
    
	// might be a good idea to check other things at this time, and perhaps keep track of what spells that have taken affect that increase the maximum hit points
	
	
	
	
}


// this is called as the end result of various scripts, it is only for a pure buffing effect
void SCStatBuff( object oTarget, int iStatToBuff, int iStatModifier, float fDuration,  int iDurType )
{
	effect eStatBuff;
	
	// for an exploit prevention
	int nBuffedScore;
	int nRawScore;
	//int nMaxPossibleScore;
	
	int nNewBuffedScore;
	int nMaxHP;
	int nHP;
	int nAbilityModifier;
	int nNewMaxHP;
	int nNewHP;
	int nNewAbilityModifier;
	
	nBuffedScore = GetAbilityScore(oTarget, iStatToBuff );
    nRawScore = GetAbilityScore(oTarget, iStatToBuff, TRUE);
    
    
    //nMaxPossibleScore = nRawScore + 12;
    
    
    // now if this does not have an effect, don't bother applying, as it most likely will cause issues
    // generally this happens with buffs from items being greater than the possible modifier
    if ( ( nRawScore + iStatModifier ) <= nBuffedScore )
    {
		if (DEBUGGING >= 8) { CSLDebug(  "BearEnd: No Possible Benefit, RawStat :" + IntToString( nRawScore ) + " Pre: Stat "+ IntToString( nBuffedScore ) + " and Post Stat would be "+ IntToString( nRawScore + iStatModifier ), oTarget); }
    	return;
    }
	
	eStatBuff = EffectAbilityIncrease( iStatToBuff, iStatModifier);
	
	if ( iStatToBuff == ABILITY_CONSTITUTION )
	{
		// for detecting an unwarranted increase
    	nHP = GetCurrentHitPoints(oTarget);
		nMaxHP = GetMaxHitPoints(oTarget);
		nAbilityModifier = GetAbilityModifier(ABILITY_CONSTITUTION, oTarget);
	
		// now do the visual effect and force the spell id to be a known spell, note that the mass version will thus also just apply the lower level spell enmasse
		// need to revise so it is more varied, but still allows freely calling this via scripts		
		eStatBuff = EffectLinkEffects( eStatBuff, EffectVisualEffect(VFX_DUR_SPELL_BEAR_ENDURANCE) );
		eStatBuff = SetEffectSpellId(eStatBuff, SPELL_BEARS_ENDURANCE);
	}
	
	HkApplyEffectToObject(iDurType, eStatBuff, oTarget, fDuration);
	
	nNewBuffedScore = GetAbilityScore(oTarget, iStatToBuff );	

	if ( iStatToBuff == ABILITY_CONSTITUTION ) // now check for unwarranted hp increases
	{
    	nNewHP = GetCurrentHitPoints(oTarget);
		nNewMaxHP = GetMaxHitPoints(oTarget);
		nNewAbilityModifier = GetAbilityModifier(ABILITY_CONSTITUTION, oTarget);
			
		
		int iAllowedHPIncrease = CSLGetMax( 0 ,( nNewAbilityModifier - nAbilityModifier ) * GetHitDice(oTarget) );

		if (DEBUGGING >= 6) { CSLDebug(  "BearEnd: RawStat :" + IntToString( nRawScore ) + " Pre: Stat "+ IntToString( nBuffedScore ) + " MaxHP"+ IntToString( nMaxHP ) + " CurHP"+ IntToString( nHP ) + " Post: Stat "+ IntToString( nNewBuffedScore ) + " MaxHP"+ IntToString( nNewMaxHP ) + " CurHP"+ IntToString( nNewHP ) + " Allowed Increase "+ IntToString( iAllowedHPIncrease ), oTarget ); }
		
		if ( nNewHP > ( nHP + iAllowedHPIncrease )  )
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage( nNewHP - ( nHP + iAllowedHPIncrease ), DAMAGE_TYPE_MAGICAL), oTarget);
		}
	}
	else
	{
		if (DEBUGGING >= 6) { CSLDebug(  "BearEnd: RawStat :" + IntToString( nRawScore ) + " Pre: Stat "+ IntToString( nBuffedScore ) + " Post: Stat "+ IntToString( nNewBuffedScore ), oTarget ); }
	}
}
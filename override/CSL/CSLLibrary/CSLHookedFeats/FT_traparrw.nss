//::///////////////////////////////////////////////////
//:: X0_S3_ARROW
//:: Fires arrow(s) at the target and surrounding targets
//:: with increasing damage and attack bonuses for higher
//:: caster level.
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/10/2002
//::
//:: CGaw 6/3/06 - Modified to be compatible with existing trap blueprints.
//:: 8/8/06 - BDF-OEI: revised DoAttack to handle non-creature "casters"
//:: and revised main() to fire multiple projectiles at the same target
//::///////////////////////////////////////////////////
#include "_HkSpell"

void DoAttack( object oTarget, int nDamageBonus, int nAttackBonus, object oCaster = OBJECT_SELF )
{
	int iDamage = d6() + nDamageBonus;
	// the HkGetSpellSaveDC() below returns 10 by default
	int iDC = HkGetSpellSaveDC();
	iDC += nAttackBonus;
	iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_TRAP );
	effect eDamage = EffectDamage( iDamage, DAMAGE_TYPE_PIERCING );
	
	// For creature casters we preserve the original "to hit" functionality...
	if ( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE )
	{
		// Apply the attack bonus if we should have one
		if (nAttackBonus > 0)
		{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(nAttackBonus), OBJECT_SELF, 5.0f);
		}
		// Don't display feedback
		int iTouch = CSLTouchAttackRanged( oTarget, FALSE );
		if ( iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			// a 2 means the attack scored a crit
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
		
			eDamage = EffectDamage( iDamage, DAMAGE_TYPE_PIERCING );
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
		}
	}
	else // ...but for non-creatures, we can't apply the attack bonus so we determine "to hit"
	{ // using a reflex saving throw, which is more consistent with most other traps.
		if ( !ReflexSave(oTarget, iDC, SAVING_THROW_TYPE_TRAP) )
		{
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
		}
	}
}

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//SpawnScriptDebugger();
	
	int iSpellPower;
	//PrintString("Caster level: " + IntToString(iSpellPower));
	// Temporary kludge for placeable caster level
	object oCaster = OBJECT_SELF;
	
	if (GetObjectType(OBJECT_SELF) != OBJECT_TYPE_CREATURE)
	{
		iSpellPower = GetReflexSavingThrow( OBJECT_SELF );
		if ( iSpellPower <= 0 )
		{
			iSpellPower = GetLocalInt( OBJECT_SELF, "NWN2_PROJECTILE_TRAP_CASTER_LEVEL" );
		}
	}
	else iSpellPower = HkGetSpellPower( OBJECT_SELF );
/*
	string sMyTag = GetTag( OBJECT_SELF );
	object oTrap = GetNearestObjectByTag( sMyTag, OBJECT_SELF );
	string sTrapLevel = GetResRef( oTrap );
*/
	//PrintString("New caster level: " + IntToString(iSpellPower));

	// Determine the level-based changes
	int nExtraProjectiles = 0;
	int nDamageBonus = 0;
	int nAttackBonus = 0;

	// Possible levels: 1, 4, 7, 11, 15
	if (iSpellPower < 4) {
			// no changes
	} else if (iSpellPower < 7) {
			nExtraProjectiles = 1;
			nDamageBonus = 1;
			nAttackBonus = 1;
	} else if (iSpellPower < 11) {
			nExtraProjectiles = 2;
			nDamageBonus = 2;
			nAttackBonus = 2;
	} else if (iSpellPower < 15) {
			nExtraProjectiles = 3;
			nDamageBonus = 3;
			nAttackBonus = 3;
	} else {
			nExtraProjectiles = 4;
			nDamageBonus = 4;
			nAttackBonus = 4;
	}
/*
	// Possible levels: 1, 4, 7, 11, 15
	if (sTrapLevel == "x0_trapwk_arrow") {
			nExtraTargets = 0;
			nDamageBonus = 0;
			nAttackBonus = 0;
	} else if (sTrapLevel == "x0_trapavg_arrow") {
			nExtraTargets = 1;
			nDamageBonus = 1;
			nAttackBonus = 1;
	} else if (sTrapLevel == "x0_trapstr_arrow") {
			nExtraTargets = 2;
			nDamageBonus = 2;
			nAttackBonus = 2;
	} else if (sTrapLevel == "x0_trapdly_arrow") {
			nExtraTargets = 3;
			nDamageBonus = 3;
			nAttackBonus = 3;
	} else if (sTrapLevel == "x0_trapftl_arrow") {
			nExtraTargets = 4;
			nDamageBonus = 4;
			nAttackBonus = 4;
	}
*/
			
	object oTarget = HkGetSpellTarget();
	location lTarget = GetLocation( oTarget );
	location lSource = GetLocation( OBJECT_SELF );
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
	float fTravelTime = GetProjectileTravelTime( lSource, lTarget, nPathType );
	DoAttack( oTarget, nDamageBonus, nAttackBonus, oCaster );
	int i;
	float fDelay1 = 0.1f;
	float fDelay2 = 0.1f;
	
	// The functionality below is not so good because there is no guarantee that
	// the next-nearest target should even be in range of the trap
	//object oNextTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget);
	
	for ( i = 1; i <= nExtraProjectiles; i++ )
	{
			// Fire another arrow at the target, but fakely
			DelayCommand( fDelay1, ActionCastFakeSpellAtObject(SPELL_TRAP_ARROW, oTarget, nPathType) );
			DelayCommand( fDelay1 + fTravelTime, DoAttack(oTarget, nDamageBonus, nAttackBonus) );
		fDelay1 += fDelay2;
			//oNextTarget = GetNearestObject( OBJECT_TYPE_CREATURE, oTarget, i+1 );
	}
}
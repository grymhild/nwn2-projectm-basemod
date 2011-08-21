//::///////////////////////////////////////////////////
//:: X0_S3_SHURIK
//:: Shoots a shuriken at the target.
//:: The shuriken animation effect is produced by the
//:: projectile settings in spells.2da; this impact script
//:: merely does the hit check and applies the damage.
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//:: 8/8/06 - BDF-OEI: revised to handle non-creature "casters"
//::///////////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
/*
	object oTarget = HkGetSpellTarget();

	if (CSLTouchAttackRanged(oTarget, TRUE) > 0)
	{
			effect eDamage = EffectDamage(d8());
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
	}
*/

	//SpawnScriptDebugger();
	object oCaster = OBJECT_SELF;
	int iSpellPower;
	//PrintString("Caster level: " + IntToString(iSpellPower));
	// Temporary kludge for placeable caster level
	if (GetObjectType(OBJECT_SELF) != OBJECT_TYPE_CREATURE)
	{
			iSpellPower = GetReflexSavingThrow( OBJECT_SELF );
		if ( iSpellPower <= 0 )
		{
			iSpellPower = GetLocalInt( OBJECT_SELF, "NWN2_PROJECTILE_TRAP_CASTER_LEVEL" );
		}
	}
	else iSpellPower = HkGetSpellPower( OBJECT_SELF );

	object oTarget = HkGetSpellTarget();
	//string sTrapLevel = GetResRef(OBJECT_SELF);
	
	// Determine the level-based changes
	int nDamageBonus = 0;
	int nAttackBonus = 0;

	// Possible levels: 1, 4, 7, 11, 15
	if (iSpellPower < 4) {
			nDamageBonus = 0;
			nAttackBonus = 0;
	} else if (iSpellPower < 7) {
			nDamageBonus = 3;
			nAttackBonus = 3;
	} else if (iSpellPower < 11) {
			nDamageBonus = 6;
			nAttackBonus = 6;
	} else if (iSpellPower < 15) {
			nDamageBonus = 12;
			nAttackBonus = 12;
	} else {
			nDamageBonus = 24;
			nAttackBonus = 24;
	}

/*
	// Possible levels: 1, 4, 7, 11, 15
	if (sTrapLevel == "x0_trapwk_bolt")
	{
			nDamageBonus = 0;
			nAttackBonus = 0;
	}
	else if (sTrapLevel == "x0_trapavg_bolt")
	{
			nDamageBonus = 3;
			nAttackBonus = 3;
	}
	else if (sTrapLevel == "x0_trapstr_bolt")
	{
			nDamageBonus = 6;
			nAttackBonus = 6;
	}
	else if (sTrapLevel == "x0_trapdly_bolt")
	{
			nDamageBonus = 12;
			nAttackBonus = 12;
	}
	else if (sTrapLevel == "x0_trapftl_bolt")
	{
			nDamageBonus = 24;
			nAttackBonus = 24;
	}

	// Apply the attack bonus if we should have one
	if (nAttackBonus > 0)
	{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,
									EffectAttackIncrease(nAttackBonus),
									OBJECT_SELF, 5.0);
	}
			
	// Don't display feedback
	if (CSLTouchAttackRanged(oTarget, FALSE) > 0)
	{
			effect eDamage = EffectDamage(d8() + nDamageBonus,
													DAMAGE_TYPE_PIERCING);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT,
									eDamage,
									oTarget);
	}
*/

	int iDamage = d8() + nDamageBonus;
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
		if ( iTouch > 0 )
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
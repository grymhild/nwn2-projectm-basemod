//::///////////////////////////////////////////////////
//:: X0_S3_DART
//:: Shoots a dart at the target. The dart animation is produced
//:: by the projectile specifications for this spell in the
//:: spells.2da file, so this merely does a check for a hit
//:: and applies damage as appropriate.
//::
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/14/2002
//::
//:: CGaw 6/3/06 - Modified to be compatible with existing trap blueprints.
//:: 8/8/06 - BDF-OEI: revised to handle non-creature "casters"
//::///////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//SpawnScriptDebugger();
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
	
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	//string sTrapLevel = GetResRef(OBJECT_SELF);
	int iDamage;
	int nDCModifier = 0;
	effect eDamage;

	//if (sTrapLevel == "x0_trapwk_dart")
	if (iSpellPower < 4)
	{
		iDamage = d4();
		nDCModifier = 0;
			//effect eDamage = EffectDamage(d4());
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
	}
	//else if (sTrapLevel == "x0_trapavg_dart")
	else if (iSpellPower < 7)
	{
		iDamage = d6();
		nDCModifier = 2;
			//effect eDamage = EffectDamage(d6());
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
	}
	//else if (sTrapLevel == "x0_trapstr_dart")
	else if (iSpellPower < 11)
	{
		iDamage = d10();
		nDCModifier = 4;
			//effect eDamage = EffectDamage(d10());
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
	}
	//else if (sTrapLevel == "x0_trapdly_dart")
	else if (iSpellPower < 15)
	{
		iDamage = d6(3);
		nDCModifier = 8;
			//effect eDamage = EffectDamage(d15());
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
	}
	//else if (sTrapLevel == "x0_trapftl_dart")
	else
	{
		iDamage = d20();
		nDCModifier = 16;
			//effect eDamage = EffectDamage(d20());
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDamage, oTarget);
	}
	
	// the HkGetSpellSaveDC() below returns 10 by default
	int iDC = HkGetSpellSaveDC();
	iDC += nDCModifier;
	iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_TRAP );
	eDamage = EffectDamage( iDamage, DAMAGE_TYPE_PIERCING );
	
	// For creature casters we preserve the original "to hit" functionality...
	if ( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE )
	{
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
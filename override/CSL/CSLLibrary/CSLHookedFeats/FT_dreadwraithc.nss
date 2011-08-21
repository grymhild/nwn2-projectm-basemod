// nx_s1_dwraith_drain
//
// Constitution Drain attack of a dread wraith.
//
// JSH-OEI 6/20/07

#include "_HkSpell"

void DoConDrain(object oTarget, int nConDamage, effect eTempHP, effect eHit)
{
	effect eConDrain = EffectAbilityDecrease(ABILITY_CONSTITUTION, nConDamage);
	effect eDeath = EffectDeath();
	int nDifficulty = GetGameDifficulty();
	
	eConDrain = SupernaturalEffect(eConDrain);
	
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eTempHP, OBJECT_SELF);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eConDrain, oTarget);
	
	// If target's CON reaches 0 on greater than Normal mode, he's dead
	if (GetAbilityScore(oTarget, ABILITY_CONSTITUTION)==0 && nDifficulty > GAME_DIFFICULTY_NORMAL)
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
	}
}
	
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oTarget = HkGetSpellTarget();
	
	int nChaModifier = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	int iSaveDC = 18 + nChaModifier;
	int nConDamage = d8(1);
	
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	effect eTempHP = EffectTemporaryHitpoints(5);
	
	
	
	// Constructs and Undead are immune to this effect
	if ( CSLGetIsConstruct(oTarget) || CSLGetIsUndead( oTarget ) )
	{
		return;
	}	
	// If target fails the Fortitude save
	if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_NONE))
	{
		//PrettyDebug("Charisma modifier is " + IntToString(nChaModifier) + ".");
		//PrettyDebug("DC is " + IntToString(iSaveDC) + ".");
		//PrettyDebug("Draining " + IntToString(nConDamage) + " of Constitution.");
		
		// A DelayCommand allows the ability damage to stack... for some reason.
		DelayCommand(0.01f, DoConDrain(oTarget, nConDamage, eTempHP, eHit));
		
	}
}
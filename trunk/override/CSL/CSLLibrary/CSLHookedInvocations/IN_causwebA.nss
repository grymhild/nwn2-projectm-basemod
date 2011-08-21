//::///////////////////////////////////////////////
//:: Caustic Web - OnEnter
//:: cmi_s0_causweba
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Caustic Web
//:: Invocation Type: Greater;
//:: Spell Level Equivalent: 4
//:: Sticky strands cling to all creatures within the area of effect, entangling
//:: them. Creatures who make their save can move, but at a reduced rate
//:: dependent on their Strength. Entering the web causes 2d6 points of acid
//:: damage while those that remain within the area suffer 1d6 points of damage
//:: each round.
//:://////////////////////////////////////////////
//const int SPELL_I_CAUSTIC_MIRE = 2092;


#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_I_CAUSTIC_MIRE;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
	effect eVis = EffectVisualEffect(VFX_DUR_WEB);
	effect eAcidDmg = EffectDamage(d6(2), DAMAGE_TYPE_ACID);
	object oTarget = GetEnteringObject();
	effect eSlow = EffectMovementSpeedDecrease(50);

	// * the lower the number the faster you go
	/*
	int nSlow = 65 - (GetAbilityScore(oTarget, ABILITY_STRENGTH)*2);
	if (nSlow <= 0)
	{
		nSlow = 1;
	}

	if (nSlow > 99)
	{
		nSlow = 99;
	}
	*/

	//effect eSlow = EffectMovementSpeedDecrease(nSlow);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster ))
	{
		// if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
		if( !CSLGetIsIncorporeal(oTarget) ) //if( (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
		{
			//Fire cast spell at event for the target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			//Spell resistance check
			//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
			//{
				//Make a Fortitude Save to avoid the effects of the entangle.
				//if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, GetInvocationSaveDC(OBJECT_SELF, TRUE)))
				//{
					//Entangle effect and Web VFX impact
					 DelayCommand(0.01f,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1), iSpellId) ); 
					DelayCommand(0.02f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eAcidDmg, oTarget) );
				//}
				//Slow down the creature within the Web
				DelayCommand(0.03f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget, 0.0f, iSpellId ) );
			//}
		}
	}
}
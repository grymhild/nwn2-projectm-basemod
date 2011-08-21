//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Tenacious Plague   ON ENTER
//:: nw_s0_itenplagea.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
			Tenacious Plague [B]
			Complete Arcane, pg. 135
			Spell Level: 6
			Class: Misc

			This invocation functions similar to the creeping doom spell (7th level
			druid). But the progression of damage works differently - 1d6 the first
			round, 2d6 the second, 3d6 the third, etc. until the 10th round when the
			invocation effect ends. Tenacious plagues cannot be stacked on top of
			each other.

			[Rules Note] This spell is extremely different from the Complete Arcane
			spell because in NWN2 we won't have swarms that can be summoned. So a
			lesser version of the creeping doom spell is used here.

*/
//:://////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"




void main()
{
	//scSpellMetaData = SCMeta_IN_tenaciouspla(); //SPELL_I_TENACIOUS_PLAGUE;
	//SpawnScriptDebugger();

	//Declare major variables
	int iDamage;
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	object oTarget = GetEnteringObject();
	effect eSpeed = EffectMovementSpeedDecrease(50);
	float fDelay;

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
			//Fire cast spell at event for the target
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_I_TENACIOUS_PLAGUE));
			fDelay = CSLRandomBetweenFloat(1.0, 1.8);
			//Spell resistance check
			if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
			{
				//Roll Damage
				iDamage = d20();
				//Set Damage Effect with the modified damage
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING);
				//Apply damage and visuals
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			}
	}

}
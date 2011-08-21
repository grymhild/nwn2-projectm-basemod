//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Wall of Perilous Flame     ON ENTER
//:: nw_s0_iwallflama.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
			Wall of Perilous Flame
			Complete Arcane, pg. 136
			Spell Level: 5
			Class: Misc

			The warlock can conjure a wall of fire (4th level wizard spell).
			It behaves identically to the wizard spell, except half of the damage
			is considered magical energy and fire resistance won't affect it.

*/
//:://////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_IN_wallperilous(); //SPELL_I_WALL_OF_PERILOUS_FLAME;
	
	//Declare major variables
	object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);
	int iSpellPower = HkGetSpellPower(oCreator, 20);
	
	int iDamage;
	effect eDam;
	object oTarget;
	
	//Declare and assign personal impact visual effect.
	effect eVisFire = EffectVisualEffect(VFX_IMP_FLAME_M);
	effect eVisMagic = EffectVisualEffect(VFX_HIT_SPELL_MAGIC);

	// Fire damage effects will be applied this long after the magic damage
	float fFireDelay = 1.0f;

	//Capture the first target object in the shape.
	oTarget = GetEnteringObject();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE, TRUE ));
		//Make SR check, and appropriate saving throw(s).
		if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
		{
			//Roll damage.
			iDamage = HkApplyMetamagicVariableMods(d6(2), 12 )+iSpellPower; //+GetAbilityModifier(ABILITY_CHARISMA, oCreator );
			
			if ( CSLGetIsUndead( oTarget ) )
			{
				iDamage *= 2;
			}
			int nFireDamage = iDamage / 2;
			int nMagicDamage = iDamage - nFireDamage;

			// Magic damage is just applied regardless of resistance
			eDam = EffectDamage(nFireDamage, DAMAGE_TYPE_FIRE);
			effect eDam2 = EffectDamage(nMagicDamage, DAMAGE_TYPE_MAGICAL);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisMagic, oTarget, 1.0);

			// Fire damage gets a saving throw
			nFireDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORFULLDAMAGE,nFireDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
			if(nFireDamage > 0)
			{
					// Apply effects to the currently selected target.
					eDam = EffectDamage(nFireDamage, DAMAGE_TYPE_FIRE);
					DelayCommand( fFireDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget) );
					DelayCommand( fFireDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisFire, oTarget, 1.0) );
			}

		}
	}
}
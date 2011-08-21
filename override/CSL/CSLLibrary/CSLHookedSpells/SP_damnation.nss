//::///////////////////////////////////////////////
//:: Damnation
//:: nx_s2_damnation
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Classes: Cleric, Warlock
	Spellcraft Required: 33
	Caster Level: Epic
	Innate Level: Epic
	School: Enchantment
	Descriptor(s): Teleportation
	Components: Verbal, Somatic
	Range: Touch
	Area of Effect / Target: Creature touched
	Duration: Instant
	Save: Will negates (DC +5)
	Spell Resistance: Yes
	
	You banish a single foe to the Hells, with no possibility of return.
	You must succeed at a melee touch attack, and the target must fail
	at a Will saving throw (DC +5). If the target fails the saving throw,
	it is dragged screaming into the Hells, to be tormented and ultimately
	devoured by fiends.
	
	Creatures that succeed at their saving throw are nonetheless exhausted
	from resisting so powerful an enchantment, and they are Dazed for 1d6+1 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/12/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.
//:: AFW-OEI 07/11/2007: Defer to NX1 Damnation hit VFX in spells.2da.
//:: RPGplayer1 03/25/2008: Uses epic spell save workaround


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



//#include "nx1_inc_epicsave"

void main()
{

	//scSpellMetaData = SCMeta_SP_damnation();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_DAMNATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 10;
	int iImpactSEF = VFXSC_HIT_DAMNATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iSaveDC = HkGetSpellSaveDC() + 5;
	int nDazeDuration = d6(1) + 1;
	
	object oTarget = HkGetSpellTarget();
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	effect eDeath = EffectDeath(FALSE, TRUE, TRUE); // No spectacular death, yes display feedback, yes ignore death immunity.
	effect eDaze = EffectDazed();
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	// Make a melee touch attack.
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{ // If we succeed at a melee touch attack
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
		{
			SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE ) );
			
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF))
				{ // Fail save and die.
					DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
				}
				else
				{ // Make save, so be dazed.
					DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, RoundsToSeconds(nDazeDuration)));
				}
				
			}
		}
	}
	
	HkPostCast(oCaster);
}


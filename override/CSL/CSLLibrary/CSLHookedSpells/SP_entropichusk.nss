//::///////////////////////////////////////////////
//:: Entropic Husk
//:: nx_s2_entropic_husk
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Classes: Druid, Spirit Shaman, Wizard, Sorcerer, Warlock
	Spellcraft Required: 31
	Caster Level: Epic
	Innate Level: Epic
	School: Conjuration
	Descriptor(s): Chaos
	Components: Verbal, Somatic
	Range: Touch
	Area of Effect / Target: Creature Touched
	Duration: 20 rounds
	Save: Will negates (DC +5)
	Spell Resistance: No
	
	You transform a single enemy into a vessel of pure chaos
	which randomly attacks all nearby creatures.
	
	You must succeed at a melee touch attack, and the target
	must fail at a Will saving throw (DC +5). If the target
	fails the saving throw, its soul is instantly annihilated,
	and its body is animated by primal entropy. For the
	duration of the spell, the creature becomes a juggernaut
	of destruction, gaining a +8 bonus to Strength and
	Constitution, and randomly attacking former allies and
	enemies alike. After 20 rounds, the entropic force
	animating the creature's body burns itself out, and the
	creature collapses into dust.

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/16/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.
//:: RPGplayer1 03/25/2008: Uses epic spell save workaround
//:: RPGplayer1 03/28/2008: Insanity will work on creatures immune to mind effects


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



//#include "nx1_inc_epicsave"

void main()
{
	//scSpellMetaData = SCMeta_SP_entropichusk();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENTROPIC_HUSK;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_ENTROPIC_HUSK;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	int iSaveDC = HkGetSpellSaveDC() + 5;
	float fDuration = RoundsToSeconds(20);
	
	object oTarget = HkGetSpellTarget();
	
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	effect eDeath = EffectDeath(FALSE, TRUE, TRUE); // No spectacular death, yes display feedback, yes ignore death immunity.
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 8);
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 8);
	effect eEnlarge = EffectSetScale(1.2); // 20% size increase.
	effect eInsane = EffectInsane();
	
	effect eLink = EffectLinkEffects(eStr, eCon);
	eLink = EffectLinkEffects(eLink, eInsane);
	
	if (CSLGetHasSizeIncreaseEffect(oTarget) != TRUE)
	{ // Only link in enlarge if not already enlarged
		eLink = EffectLinkEffects(eLink, eEnlarge);
	}
		
	eLink = ExtraordinaryEffect(eLink); // No dispelling!
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{ // If we succeed at a melee touch attack
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE ));
			//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF))
			{ // Fail save, so go insane & get buffed, then die.
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
				CSLConstitutionBugCheck( oTarget );
				DelayCommand(fDuration, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget)); // You're already dead and you don't even know it!

				if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF)) //FIX: will work on mind spell immune too
				{
					float fDelay = 0.0f;
					while (fDelay < fDuration)
					{
						DelayCommand(fDelay, ExecuteScript("nw_g0_insane", oTarget));
						fDelay += 6.0f;
					}
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}


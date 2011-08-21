//::///////////////////////////////////////////////
//:: Briar Web - OnEnter
//:: cmi_s0_briarweba
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Briar Web
//:: Transmutation
//:: Caster Level(s): Druid 2, Ranger 2
//:: Component(s): Verbal, Somatic
//:: Range: Medium
//:: Area of Effect / Target: 40-ft.-radius spread
//:: Duration: 3 minutes.
//:: Save: None
//:: Spell Resistance: No
//:: This spell causes grasses, weeds, bushes, and even trees to grow thorns and
//:: wrap and twist around creatures in or entering the area. The spell's area
//:: becomes difficult terrain and creatures move at half speed within the
//:: affected area. Any creature moving through the area or that stays within it
//:: takes 6 points of piercing damage.
//:: 
//:: A creature with Freedom of Movement or the woodland stride ability
//:: is unaffected by this spell.
//:: 
//:: With a sound like a thousand knives being unsheathed, the plants in the
//:: area grow sharp thorns and warp into a thick briar patch.
//:://////////////////////////////////////////////



#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_BRIAR_WEB;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
	//effect eWeb = EffectEntangle();
	effect eVis = EffectVisualEffect(VFX_DUR_WEB);
	effect ePierceDmg = EffectDamage(6, DAMAGE_TYPE_PIERCING);
	//effect eLink = EffectLinkEffects(eWeb, eVis);
	object oTarget = GetEnteringObject();

	effect eSlow = EffectMovementSpeedDecrease(50);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		if( !CSLGetIsIncorporeal(oTarget) && !CSLGetIsMagicallyFreeToMove( oTarget, TRUE ) ) //if( (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
		{
			//Fire cast spell at event for the target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE));

			//Entangle effect and Web VFX impact
			DelayCommand(0.01f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1)) );
			DelayCommand(0.02f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePierceDmg, oTarget) );
			//Slow down the creature within the Web
			DelayCommand(0.03f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget) );
		}
	}
}
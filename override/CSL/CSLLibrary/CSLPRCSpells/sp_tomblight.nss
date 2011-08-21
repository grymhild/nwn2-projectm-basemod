//::///////////////////////////////////////////////
//:: Name 	Tomb of Light
//:: FileName sp_tomb_light.nss
//:://////////////////////////////////////////////
/**@file Tomb of Light
Transmutation [Good]
Level: Clr 7, Sor/Wiz 7
Components: V, S, M
Casting Time: 1 round
Range: Touch
Target: Evil extraplanar creature touched
Duration: Concentration
Saving Throw: Fortitude negates
Spell Resistance: Yes

When you cast this spell, you attempt to draw out
the impure substance of an evil extraplanar
creature and replace it with your own pure
substance. The spell is draining for you to cast,
but it is deadly to evil outsiders and other
extraplanar creatures with the taint of evil.

When you touch the target creature, it must make a
Fortitude saving throw. If it succeeds, it is
unaffected by the spell.

If it fails, its skin becomes translucent and
faintly radiant and the creature is immobilized,
standing helpless. The subject is aware and
breathes normally, but cannot take any physical
actions, even speech. It can, however, execute
purely mental actions (such as using a spell-like
ability). The effect is similar to hold person.

Each round you maintain the spell, the creature
must attempt another Fortitude save. If it fails
the save, it takes 1d6 points of permanent
Constitution drain. Each round you maintain the
spell, however, you take 1d6 points of non-lethal
damage. If you fall unconscious, or if the
creature succeeds at its Fortitude save, the spell
ends.

Material Component: A pure crystal or clear
gemstone worth at least 50 gp.

Author: 	Tenjac
Created: 	7/7/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void TombLoop(object oCaster, object oTarget);
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_CSLCore_Combat"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TOMB_OF_LIGHT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId()));

	if(!HkResistSpell(oCaster, oTarget))
	{
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			if((GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL) && (CSLGetIsOutsider( oTarget )))
			{
				TombLoop(oCaster, oTarget);
			}
		}
	}

	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


void TombLoop(object oCaster, object oTarget)
{
	CSLDoBreakConcentrationCheck();
	//Save

	if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(oCaster,oTarget), SAVING_THROW_TYPE_GOOD))
	{
		//Hold
		effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), EffectParalyze());
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.02f);

		//Ability Drain
		SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, d6(1), oTarget, DURATION_TYPE_PERMANENT, 0.0f);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);

		//Damage self
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(d6(1), DAMAGE_TYPE_MAGICAL), oCaster);

		DelayCommand(6.0f, TombLoop(oCaster, oTarget));
	}
}








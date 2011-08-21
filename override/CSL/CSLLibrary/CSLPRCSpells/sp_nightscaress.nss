/*
	sp_nght_caress

	School: Necromancy [Evil]
	Level: Sorc/Wiz 5
	Compnents: V,S
	Range: Touch
	Duration: Instantaneous
	Save: Fortitude partial
	Spell Resistance: Yes

	A touch from your hand, which sheds darkness like
	the blackest of night, disrupts the life force of
	a living creature. Your touch deals 1d6 points of
	damage per caster level (max 15d6), and 1d6+2
	points of Constituion damage (a sucessful Fortitude
	saving throw negates the Constitution damage.)

	The spell has a special effect on an undead creature.
	An undead touched by you takes no damage, but it
	must make a successful Will saving throw or flee
	as if panicked for 1d4 rounds + 1 round per caster
	level.

	By: Tenjac
	Created: Dec 13, 2005
	Modified: Jul 2, 2006

	added spell betrayal/spellstrike damage, touch attack damage
	set vfx to DURATION_TYPE_INSTANT
*/
//#include "prc_sp_func"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_CSLCore_Combat"
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	

	return iTouch; 	//return TRUE if spell charges should be decremented
}
*/



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_NIGHTS_CARESS; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster, 15 ); 

	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nMetaMagic = HkGetMetaMagicFeat();
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_NIGHTS_CARESS, oCaster);

	//Make touch attack
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if(CSLGetIsUndead( oTarget ))
		{
			//Will saving throw
			if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				int iDuration = d4(1)+HkGetSpellDuration( oCaster, 30 );
				float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
				
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_IMP_HEAD_EVIL)), oTarget, fDuration);
			}
		}
		//Spell Resistance
		else if (!HkResistSpell(oCaster, oTarget ))
		{
			int iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower),6 * iSpellPower);
			
			//iDamage += ApplySpellBetrayalStrikeDamage(oTarget, oCaster);
			//Apply damage as magical
			//ApplyTouchAttackDamage(oCaster, oTarget, nTouch, iDamage, DAMAGE_TYPE_MAGICAL);
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_MELEE, oCaster );
			if ( iDamage > 0 )
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
			}
			// Fort saving throw
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				int nConDam = HkApplyMetamagicVariableMods( d6()+2, 8);
				//Ability damage healing 1 point per hour
				SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, nConDam, oTarget, DURATION_TYPE_TEMPORARY, -1.0, FALSE, SPELL_NIGHTS_CARESS );
				//Drain VFX
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
			}
		}
	}
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
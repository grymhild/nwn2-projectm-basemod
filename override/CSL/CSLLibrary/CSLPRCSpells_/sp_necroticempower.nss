//::///////////////////////////////////////////////
//:: Name 	Necrotic Empowerment
//:: FileName sp_nec_empower.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Empowerment
Necromancy [Evil]
Level: Clr 8, sor/wiz 8
Components: V, S, F
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level

You call upon the mother cyst that your body hosts,
drawing from it strength, vigor, speed, and vicious
certainty. While the spell is in effect, you gain a
+8 enhancement bonus to Dexterity, Intelligence, and

Wisdom, a +8 natural armor bonus to Armor Class as
your skin briefly crusts and hardens, a +5 competence
bonus on Fortitude saves, and 100 temporary hit points.

While the empowerment lasts, you are unable to cast any
other mother cyst feat-enabled spell.

Focus: Caster must possess a mother cyst.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "spinc_necro_cyst"
//#include "inc_item_props"
//#include "inc_utility"
//#include "prc_inc_spells"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_NECROTIC_EMPOWERMENT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//Check for casting ability
	if(!GetCanCastNecroticSpells(OBJECT_SELF))
	return;

	//Define vars
	
	object oSkin = CSLGetPCSkin(oCaster);
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Define Ability bonuses
	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 8);
	effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 8);
	effect eWis = EffectAbilityIncrease(ABILITY_WISDOM, 8);

	//Define Natural Armor bonus
	effect eNatArm = EffectACIncrease(8, AC_NATURAL_BONUS);

	//Define Fortitude save bonus
	effect eFortSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5, SAVING_THROW_TYPE_ALL);

	//Define HP bonus
	effect eHP = EffectTemporaryHitpoints(100);

	//Define VFX
	effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);

	//Link effects
	effect eLink = EffectLinkEffects(eDex, eInt);
			eLink = EffectLinkEffects(eLink, eWis);
			eLink = EffectLinkEffects(eLink, eNatArm);
			eLink = EffectLinkEffects(eLink, eFortSave);
			eLink = EffectLinkEffects(eLink, eHP);
			eLink = EffectLinkEffects(eLink, eVis);

	//Apply all effects
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

	CSLSpellEvilShift(oCaster);
}
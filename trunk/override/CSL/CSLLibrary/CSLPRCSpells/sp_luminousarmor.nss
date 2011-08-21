//::///////////////////////////////////////////////
//:: Name 	Luminous Armor
//:: FileName sp_lumins_armr.nss
//:://////////////////////////////////////////////
/**@file Luminous Armor
Abjuration
Level: Sactified 2
Components: Sacrifice
Casting Time: 1 standard action
Range: Touch
Target: 1 good creature touched
Duration: 1 hour/level
Saving Throw: None
Spell Resistance: Yes (harmless)

This spell, favored among eldarins visiting the
Material Plane, envelops the target in a protective,
shimmering aura of light. The luminous armor
resembles a suit of dazzling full plate, but it is
weightless and does not restrict the target's
movement or mobility in any way. In addition to
imparting the benefits of a breatplate (+5 armor
bonus to AC), the luminous armor has no maximum
Dexterity restriction, no armor check penalty, and
no chance for aracane spell failure.

Luminous armor sheds light equivalent to a daylight
spell and dispells darkness spells of 2nd level or
lower with which it comes into contact. In addition,
the armor causes opponents to take a -4 penalty on
melee attacks made against the target. This penalty
stacks with the penalty suffered by creatures
sensitive to bright light (such as dark elves).

Sacrifice: 1d2 points of Strength damage.

//::///////////////////////////////////////////////
//:: Name 	Greater Luminous Armor
//:: FileName sp_lumins_armr.nss
//:://////////////////////////////////////////////

Luminous Armor, Greater
Abjuration
Level: Sanctified 4

This spell functions like luminous armor, except
that it imparts the benefits of full plate (+8
armor bonus to AC).

Sacrifice: 1d3 points of Strength damage.

Author: 	Tenjac
Created: 	6/20/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LUMINOUS_ARMOR; // SPELL_GREATER_LUMINOUS_ARMOR
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	object oTarget = HkGetSpellTarget();
	int nSpell = HkGetSpellId();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nAlign = GetAlignmentGoodEvil(oTarget);
	int nMetaMagic = HkGetMetaMagicFeat();
	//float fDur = HoursToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if(nAlign == ALIGNMENT_GOOD)
	{
		

		//VFX
			//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_LUMINOUS_ARMOR), oTarget, fDuration);

		//Light as a daylight spell

		//-4 penalty to enemy attacks


		int nArmor;
		if(nSpell == SPELL_LUMINOUS_ARMOR)
		{
			nArmor = 5;
			SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d2(1), 0);
		}

		else if(nSpell == SPELL_GREATER_LUMINOUS_ARMOR)
		{
			nArmor = 8;
			SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d3(), 0);
		}

		else
		{
			return;
		}

		effect eArmor = EffectACIncrease(nArmor, AC_ARMOUR_ENCHANTMENT_BONUS, AC_VS_DAMAGE_TYPE_ALL);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eArmor, oTarget, fDuration);
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}





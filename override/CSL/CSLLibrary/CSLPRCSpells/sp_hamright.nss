//::///////////////////////////////////////////////
//:: Name 	Hammer of Righteousness
//:: FileName sp_ham_right.nss
//:://////////////////////////////////////////////
/**@file Hammer of Righteousness
Evocation [Force, Good]
Level: Sanctified 3
Components: V, S, Sacrifice
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Effect: Magic warhammer of force
Duration: Instantaneous
Saving Throw: Fortitude half
Spell Resistance: Yes

A great warhammer of positive energy springs into
existence, launches toward a target that you can
see within the range of the spell, and strikes
unerringly.

The hammer of righteousness deals 1d6 points of
damage per caster level to the target, or 1d8
points of damage per caster level if the target is
evil. The caster can decide to deal non-lethal
damage instead of lethal damage with the hammer,
or can split the damage evenly between the two
types. How the damage is split must be decided
before damage is rolled. The hammer is considered
a force effect and has no miss chance when striking
an incorporeal target. A successful Fortitude save
halves the damage.

Sacrifice: 1d3 points of Strength damage.

Author: 	Tenjac
Created: 	6/14/06
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
	int iSpellId = SPELL_HAMMER_OF_RIGHTEOUSNESS; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nAlign = GetAlignmentGoodEvil(oTarget);
	int nMetaMagic = HkGetMetaMagicFeat();
	int iAdjustedDamage;

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_HAMMER_OF_RIGHTEOUSNESS, oCaster);

	if(!HkResistSpell(OBJECT_SELF, oTarget ))
		{
		int nDam = d6(nCasterLvl);

		if(nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDam = 6 * (nCasterLvl);
		}

		if(nAlign == ALIGNMENT_EVIL)
		{
			nDam = d8(nCasterLvl);

			if(nMetaMagic == METAMAGIC_MAXIMIZE)
			{
				nDam = 8 * (nCasterLvl);
			}
		}

		if(nMetaMagic == METAMAGIC_EMPOWER)
		{
			nDam += (nDam/2);
		}


		nDam = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, nDam, oTarget, nDC, SAVING_THROW_TYPE_GOOD, oCaster, SAVING_THROW_RESULT_ROLL );
				
		

		//Play VFX


		//Apply damage
		if ( nDam > 0 )
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
		}
	}
	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d3(1), 0);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}



//::///////////////////////////////////////////////
//:: Name 	Spores of the Vrock
//:: FileName sp_spore_vrock.nss
//:://////////////////////////////////////////////
/**@file Spores of the Vrock
Conjuration (Creation) [Evil]
Level: Clr 2, Demonologist 1
Components: V S, M/DF
Casting Time: 1 full round
Area: 5-ft. radius, centered on caster
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster summons a mass of spores that fill the
area around him.

The spores deal 1d8 points of damage to all
creatures within 5 feet other than the caster. Then
they penetrate the skin and grow, dealing an
additional 1d2 points of damage each round for 10
rounds. At the end of this time, a tangle of viny
growths covers each subject. A delay poison spell
stops the spores' growth for its duration. Bless,
neutralize poison, or remove disease kills the
spores, as does sprinkling the victim with a vial
of holy water.

Arcane Material Component: The feathers of an
avian creature with an intelligence score of at
least 3 (a harpy, achaierai, or similar creature).

Author: 	Tenjac
Created: 	5/10/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
#include "_HkSpell"

void SporeLoop(object oTarget, int nMetaMagic, int nRounds)
{
	if(nRounds > 0)
	{
		nDam2 = HkApplyMetamagicVariableMods(d2(1), 2);

		HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam2, DAMAGE_TYPE_MAGICAL), oTarget);

		nRounds--;

		DelayCommand(6.0f, SporeLoop(oTarget, nMetaMagic, nRounds));
	}
}



void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPORES_OF_THE_VROCK; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	
	location lLoc = GetLocation(oCaster);
	effect eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
	int nRounds = 10;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lLoc);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nCasterLvl = HkGetCasterLevel(oTarget);
	int nMetaMagic = HkGetMetaMagicFeat();
	
	int nDam = HkApplyMetamagicVariableMods(d8(), 8);
	

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);

	while(GetIsObjectValid(oTarget))
	{
		if(!HkResistSpell(oCaster, oTarget ))
		{
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
				SporeLoop(oTarget, nMetaMagic, nRounds);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lLoc);
	}
	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

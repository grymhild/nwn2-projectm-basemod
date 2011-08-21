//::///////////////////////////////////////////////
//:: Name 	Rain of Embers
//:: FileName sp_rain_ember.nss
//:://////////////////////////////////////////////
/**@file Rain of Embers
Evocation [Fire, Good]
Level: Sanctified 7
Components: V, S, Sacrifice
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Area: Cylinder (40-ft. radius, 120 ft. high)
Duration: 1 round/level (D)
Saving Throw: Reflex half; see text
Spell Resistance: Yes

This spell causes orange, star-like embers to rain
steadily from above. Each round, the falling embers
deal 10d6 points of damage to evil creatures within
the spell's area. Half of the damage is fire damage,
but the other half results directly from divine
power and is therefore not subject to being reduced
by resistance to fire-based attacks, such as that
granted by protection from energy (fire),
fire shield (chill shield), and similar magic.
Creatures may leave the area to avoid taking
additional damage, but a new saving throw is required
each round a creature is caught in the Fiery downpour.

A shield provides a cover bonus on the Reflex save,
depending on its size small +2, large +4, tower +7.
A shield spell oriented upward provides a +4 cover
bonus on the Reflex save. A creature using its
shield (or shield spell) to block the rain of embers
cannot use it for defense in combat.

Sacrifice: 1d2 points of Strength drain.

Author: 	Tenjac
Created: 	6/21/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void EmberLoop(int nCounter, int nCasterLvl, int nMetaMagic, object oCaster, location lLoc);
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RAIN_OF_EMBERS; // put spell constant here
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
	location lLoc = HkGetSpellTargetLocation();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//fDuration = RoundsToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nCounter = FloatToInt(fDuration/6);
	int nMetaMagic = HkGetMetaMagicFeat();

	//VFX
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_FIRESTORM), lLoc, fDuration);

	EmberLoop(nCounter, nCasterLvl, nMetaMagic, oCaster, lLoc);

	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, d2(), 1);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
	CSLSpellGoodShift(oCaster);
}

void EmberLoop(int nCounter, int nCasterLvl, int nMetaMagic, object oCaster, location lLoc)
{
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nDam;
	int nDam2;

	while(GetIsObjectValid(oTarget))
	{
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			//Spell Resist
			if(!HkResistSpell(OBJECT_SELF, oTarget ))
			{
				int nDC = HkGetSpellSaveDC(oCaster,oTarget);
				//Save

				nDam = d6(10);
				
				int nDam = HkApplyMetamagicVariableMods(d6(10), 60);
				

				if (HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					nDam = (nDam/2);
				}

				nDam2 = (nDam/2);
				nDam = (nDam - nDam2);

				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_FIRE), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam2, DAMAGE_TYPE_DIVINE), oTarget);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	nCounter--;

	if(nCounter > 0)
	{
		DelayCommand(6.0f, EmberLoop(nCounter, nCasterLvl, nMetaMagic, oCaster, lLoc));
	}
}







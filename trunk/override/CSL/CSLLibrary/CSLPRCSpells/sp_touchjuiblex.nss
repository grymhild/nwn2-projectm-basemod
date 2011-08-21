//::///////////////////////////////////////////////
//:: Name 	Touch of Juiblex
//:: FileName sp_tch_Juiblex.nss
//:://////////////////////////////////////////////
/**@file Touch of Juiblex
Transmutation [Evil]
Level: Corrupt 3
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject turns into green slime over the course of
4 rounds. If a remove curse, polymorph other, heal,
greater restoration, limited wish, miracle, or wish
spell is cast during the 4 rounds of transformation,
the subject is restored to normal but still takes 3d6
points of damage.

Corruption Cost: 1d6 points of Strength damage.

Author: 	Tenjac
Created: 	2/19/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_inc_spells"
#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_SCInclude_BarbRage"

void CountdownToSlime(object oTarget, int nCounter)
{
	if(nCounter > 0)
	{
		nCounter--;
		DelayCommand(6.0f, CountdownToSlime(oTarget, nCounter));
	}
	else
	{
		location lLoc = GetLocation(oTarget);

		//kill target
						SCDeathlessFrenzyCheck(oTarget);
		effect eDeath = EffectDeath();
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);

		CreateObject(OBJECT_TYPE_CREATURE, "nw_ochrejellymed", lLoc);
	}
}




void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TOUCH_OF_JUIBLEX; // put spell constant here
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

	object oTarget = HkGetSpellTarget();
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nCounter = 4;

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_TOUCH_OF_JUIBLEX, oCaster);

	//Spell Resistance
	if (!HkResistSpell(oCaster, oTarget))
	{
		//Save
		if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			//It's the final countdown
			CountdownToSlime(oTarget, nCounter);
		}
	}

	//Alignment shift
	CSLSpellEvilShift(oCaster);

	//Corruption cost
	int nCost = d6(1);
	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, nCost, 0);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




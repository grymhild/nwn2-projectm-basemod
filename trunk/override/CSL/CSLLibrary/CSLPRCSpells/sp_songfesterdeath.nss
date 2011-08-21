//::///////////////////////////////////////////////
//:: Name 	Song of Festering Death
//:: FileName sp_fester_death.nss
//:://////////////////////////////////////////////
/**@file Song of Festering Death
Evocation [Evil]
Level: Brd 2
Components: V
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: Concentration
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster sings a wailing ululation, requiring a
successful Perform (singing) check (DC 20). If the
Perform check succeeds and the target fails a
Fortitude saving throw, the subject's flesh
bubbles and festers into pestilent blobs, dealing
the subject 2d6 points of damage each round. If the
subject dies, she bursts with a sickening pop as
steamy gore spills onto the ground.

Author: 	Tenjac
Created: 	3/26/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
#include "_HkSpell"
#include "_SCInclude_BarbRage"

void FesterLoop(object oTarget, int nConc, int nHP)
{
	if (nConc == FALSE)
	{
		return;
	}

	int nDam = d6(2);
	nHP = GetCurrentHitPoints(oTarget);
	effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL);

	if(nDam > nHP)
	{
		//esplode!
						SCDeathlessFrenzyCheck(oTarget);
		effect eDeath = EffectDeath(TRUE, TRUE);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
	}
	else
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	}

	//Loop
	DelayCommand(6.0f, FesterLoop(oTarget, nConc, nHP));

}





void main()
{		
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SONG_OF_FESTERING_DEATH; // put spell constant here
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

	
	object oTarget = HkGetSpellTarget();
	int nConc = TRUE;
	int nDC = HkGetSpellSaveDC(oTarget, oCaster);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nHP = GetCurrentHitPoints(oTarget);

	//Check for skill
	if(GetIsSkillSuccessful(oCaster, SKILL_PERFORM, 20))
	{
		//Spell Resist
		if(!HkResistSpell(oCaster, oTarget ))
		{
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, 1.0))
			{
				FesterLoop(oTarget, nConc, nHP);
			}
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

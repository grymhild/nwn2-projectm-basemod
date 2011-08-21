//::///////////////////////////////////////////////
//:: Name 	Stop Heart
//:: FileName sp_stop_hrt.nss
//:://////////////////////////////////////////////
/**@file Stop Heart
Necromancy [Evil]
Level: Asn 4, Clr 4, Sor/Wiz 5
Components: S, Drug
Casting Time: 1 action
Range: Touch
Area: One living humanoid or animal
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

Channeling hatred and spite, the caster calls upon
dark power to give the subject a massive heart
attack. The subject suddenly drops to -8 hit points,
then -9 hit points at the end of this round. If
someone immediately makes a successful Heal check
(DC 15) or somehow gives the subject more hit points,
she stabilizes. Otherwise, at the end of the next
round, the subject reaches -10 hit points and dies.

Drug Component: Baccaran.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"

#include "_HkSpell"
#include "_SCInclude_BarbRage"

void Deathloop(object oTarget, int nHP, int nCounter)
{
	//if the target's HP has increased, break loop
	if(GetCurrentHitPoints(oTarget) > nHP)
	{
		nCounter = 0;
	}

	effect eDam;

	if(nCounter > 0)
	{
		//Round 1
		if(nCounter == 3)
		{
			eDam = HkEffectDamage(DAMAGE_TYPE_MAGICAL, (nHP - 2));
		}

		//Round 2
		if(nCounter == 2)
		{
			eDam = HkEffectDamage(DAMAGE_TYPE_MAGICAL, (nHP -1));
		}

		//Round 3 - should have drank that healing potion
		if (nCounter == 1)
		{
			SCDeathlessFrenzyCheck(oTarget);
			eDam = EffectDeath();
		}

		//Apply appropriate effect
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

		//Reset nHP
		nHP = GetCurrentHitPoints(oTarget);

		nCounter--;

		DelayCommand(6.0f, Deathloop(oTarget, nHP, nCounter));
	}
}




void main()
{	
	
	

	//Spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_STOP_HEART; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int nHP = GetCurrentHitPoints(oTarget);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nCounter = 2;
	int nCasterLvl = HkGetCasterLevel(oCaster);
	
	//must be under effect of baccaran
	if(GetHasSpellEffect(SPELL_BACCARAN, oCaster))
	{
		//Spell Resistance
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			//Fort save
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
			{
				//They should be unable to act via PnP
				effect ePar = EffectCutsceneParalyze();
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, 19.0f);

				//Sucker...
				Deathloop(oTarget, nHP, nCounter);
			}
		}
	}


	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

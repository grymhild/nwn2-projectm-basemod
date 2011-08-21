//::///////////////////////////////////////////////
//:: Name 	Rapture of Rupture
//:: FileName sp_rapt_rupt.nss
//:://////////////////////////////////////////////
/** @file
Rapture of Rupture
Transmutation [Evil]
Level: Corrupt 7
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: One living creature touched per level
Duration: Instantaneous
Saving Throw: Fortitude half
Spell Resistance: Yes

With this spell, the caster's touch deals grievous
wounds to multiple targets. After rapture of rupture
is cast, the caster can touch one target per round
until she has touched a number of targets equal to
her caster level. The same creature cannot be
affected twice by the same rapture of rupture. A
creature with no discernible anatomy is unaffected by
this spell.

When the caster touches a subject, his flesh bursts
open suddenly in multiple places. Each subject takes
6d6 points of damage and is stunned for 1 round; a
successful Fortitude save reduces damage by half and
negates the stun effect. Subjects who fail their
Fortitude save continue to take 1d6 points of damage
per round until they receive magical healing, succeed
at a Heal check (DC 20), or die. If a subject takes 6
points of damage from rapture of rupture in a single
round, he is stunned in the following round.

Corruption Cost: 1 point of Strength damage per target
touched.

*/
// Author: 	Tenjac
// Created: 5/31/2006
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_sp_func"
#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_CSLCore_Combat"


void WoundLoop(object oTarget, int nDamage = 0)
{
	// If previous round's damage roll was 6, stun this round
	if(nDamage == 6)
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0f);

	// Roll and apply new damage
	nDamage = d6();
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDamage, DAMAGE_TYPE_MAGICAL), oTarget);

	DelayCommand(6.0f, WoundLoop(oTarget, nDamage));
}



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RAPTURE_OF_RUPTURE; // put spell constant here
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
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	object oTarget = HkGetSpellTarget();

	//string sScript = Get2DAString("spells", "ImpactScript", iSpellId);
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------

	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC 	= HkGetSpellSaveDC(oTarget, oCaster);
	string sCaster = GetLocalString(oCaster, "PRCRuptureID");
	string sTest 	= GetLocalString(oTarget, "PRCRuptureTargetID");
	int iAdjustedDamage, iSave, nDC;
	
	// Roll to hit
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		// Target validity check - should not have been targeted before
		// and should have discernible anatomy (excludes constructs, elementals, oozes, plants, undead)
		if( !set_contains_object(oCaster, "PRC_Spell_RoRTargets", oTarget) && CSLGetIsLiving(oTarget) && !CSLGetIsOoze(oTarget) )
		{
			if(!HkResistSpell(oCaster, oTarget))
			{
				// Roll damage and apply metamagic
				int nDam = HkApplyMetamagicVariableMods( d6(6), 36);
				

				// Save for half damage
				iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_EVIL, oCaster);
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nSaveDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
				
					
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
					{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0f);
						WoundLoop(oTarget); // Init the wound loop. This will deal d6 damage, which in turn determines whether the target will be stunned again next round
					}
					
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);

				}
				
				/*
				if(HkSavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_EVIL))
				{
				nDam /= 2;

				// If the target has Mettle, do no damage. However, the target will still count as having been affected by the spell
					if (GetHasMettle(oTarget, SAVING_THROW_FORT))
						nDam = 0;
				}
				// On failed save, stun for a round and start bleeding
				else
				{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, 6.0f);
				WoundLoop(oTarget); // Init the wound loop. This will deal d6 damage, which in turn determines whether the target will be stunned again next round
				}

				// Apply Damage
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
				*/
				// If this spell was a held charge, it can have multiple targets. So we need to keep track of who has been already affected
				//if(nEvent)
				//set_add_object(oCaster, "PRC_Spell_RoRTargets", oTarget);
			}
		}

		// Corruption cost is paid whenever something is hit
		SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, 1, 0);
		CSLSpellEvilShift(oCaster);
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
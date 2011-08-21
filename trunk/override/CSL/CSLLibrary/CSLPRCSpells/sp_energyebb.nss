//::///////////////////////////////////////////////
//:: Name 	Energy Ebb
//:: FileName sp_energy_ebb.nss
//:://////////////////////////////////////////////
/** @file

	Energy Ebb
	Necromancy (Evil)
	Cleric 7, Sorc/Wiz 7
	Duration 1 round/level
	Saving throw: Fortitude negates

	This spell functions like enervation except that
	the creature struck gains negative levels over an
	extended period. You point your finger and utter
	the incantation, releasing a black needle of
	crackling negative energy that suppresses the life
	force of any living creature it strikes. You must
	make a ranged touch attack to hit. If the attack
	succeeds, the subject immediately gains one negative
	level, then continues to gain another each round
	thereafter as her life force slowly bleeds away. The
	drain can only be stopped by a successful Heal check
	(DC 23) or the application of a heal, restoration, or
	greater restoration spell.

	If the black needle strikes an undead creature, that
	creature gains 4d4 * 5 temporary hp that last for up
	to 1 hour.


	Author: 	Tenjac
	Created: 	12/07/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_inc_spells"
#include "_HkSpell"
#include "_SCInclude_Necromancy"


void Ebb(object oTarget, int nDrainAmount, int nRounds, object oCaster = OBJECT_SELF, int iSneakDamage = 0 )
{
	//check duration
	if((nRounds < 1) || (GetIsDead(oTarget)))
	{
		return;
	}

	// effect eNegLev = EffectNegativeLevel(1);
	effect eDur = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
	//	effect eLink = EffectLinkEffects(eNegLev, eDur);

	//apply
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget);
	SCApplyDeadlyAbilityLevelEffect( nDrainAmount, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oCaster, iSneakDamage );
	
	//decrement duration
	nRounds--;

	//Reapply after 1 round
	DelayCommand(6.0f, Ebb(oTarget, nDrainAmount, nRounds, oCaster));
}




void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENERGY_EBB; // put spell constant here
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
	
	
	
	object oSkin = CSLGetPCSkin(oCaster);
	object oTarget = HkGetSpellTarget();
	
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_ENERGY_EBB, oCaster);

	//if undead
	if(CSLGetIsUndead( oTarget ))
	{
		//roll temp hp
		int nHP = (d4(4) * 5);

		//give temp hp
		effect eHP = EffectTemporaryHitpoints(nHP);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, 3600.00);
	}
	else //not undead
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ENERGY_DRAIN));
			effect eBeam = EffectBeam( VFX_BEAM_NECROMANCY, oCaster, BODY_NODE_HAND);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7);
			int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS)
			{
				//if (!HkResistSpell(oCaster, oTarget))
				//{
				if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
				{
					// int nDrain = HkApplyMetamagicVariableMods(1, 1);
					int nDrain = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, 1, SC_TOUCH_RANGED );
					
					int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
					Ebb(oTarget, nDrain, FloatToInt(fDuration/6.0f), oCaster, iSneakDamage  );
					
					
					ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE), oTarget);
				}
				//}
			}
		}
		
		//int nDC = HkGetSpellSaveDC(oCaster,oTarget);
		//
		//if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
		//{
		//	int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
		//	
		//	Ebb(oTarget, FloatToInt(fDuration/6.0f), oCaster, iSneakDamage  );
		//}
	}

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

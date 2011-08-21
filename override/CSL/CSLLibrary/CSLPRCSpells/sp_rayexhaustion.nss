//::///////////////////////////////////////////////
//:: Name 	Ray of Exhaustion
//:: FileName sp_ray_exhst.nss
//:://////////////////////////////////////////////
/**@file Ray of Exhaustion
Necromancy
Level: 	Sor/Wiz 3, Duskblade 3
Components: 	V, S, M
Casting Time: 	1 standard action
Range: 	Close (25 ft. + 5 ft./2 levels)
Effect: 	Ray
Duration: 	1 min./level
Saving Throw: 	Fortitude partial; see text
Spell Resistance: 	Yes

A black ray projects from your pointing finger. You
must succeed on a ranged touch attack with the ray
to strike a target.

The subject is immediately exhausted for the spell's
duration. A successful Fortitude save means the
creature is only fatigued.

A character that is already fatigued instead becomes
exhausted.

This spell has no effect on a creature that is
already exhausted. Unlike normal exhaustion or fatigue,
the effect ends as soon as the spell's duration expires.
Material Component

A drop of sweat.

**/
//::////////////////////////////////////////////////
//:: Author: Tenjac
//:: Date : 29.9.06
//::////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_sp_func"

#include "_HkSpell"
#include "_CSLCore_Combat"
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	
	return iTouch; 	//return TRUE if spell charges should be decremented
}
*/




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RAYOFEXHAUSTION; // put spell constant here
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
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC = HkGetSpellSaveDC(oTarget, oCaster);
	//float fDur = (60.0f * nCasterLevel);
	int iAdjustedDamage;

	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE);

	//INSERT SPELL CODE HERE
	effect eSpeed;
	int nDrain;
	//Beam
	int iTouch = CSLTouchAttackMelee(oTarget);
	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_BLACK, oCaster, BODY_NODE_HAND, !iTouch), oTarget, 1.0f);

	
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		//Touch attack code goes here
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			effect eSpeed = EffectMovementSpeedDecrease(50);
			int nDrain = 6;

			//Fort save
			iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL, oCaster, SAVING_THROW_RESULT_ROLL );
			if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
			{
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
				{
					eSpeed = EffectMovementSpeedDecrease(50);
					nDrain = 6;
				}
				else
				{
					eSpeed = EffectMovementSpeedDecrease(25);
					nDrain = 2;
				}
				effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, nDrain), EffectAbilityDecrease(ABILITY_DEXTERITY, nDrain));
				eLink = EffectLinkEffects(eLink, eSpeed);
	
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
			/*
			if(HkSavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_SPELL))
			{
				if(GetHasMettle(oTarget, SAVING_THROW_FORT))
				{
					
					//--------------------------------------------------------------------------
					// Clean up
					//--------------------------------------------------------------------------
					HkPostCast( oCaster );
					return iAttackRoll;
				}

				else
				{
					eSpeed = EffectMovementSpeedDecrease(25);
					nDrain = 2;
				}
			}

			effect eLink = EffectLinkEffects(EffectAbilityDecrease(ABILITY_STRENGTH, nDrain), EffectAbilityDecrease(ABILITY_DEXTERITY, nDrain));
			eLink = EffectLinkEffects(eLink, eSpeed);

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			*/
		}
	}
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
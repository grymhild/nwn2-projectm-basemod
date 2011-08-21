//::///////////////////////////////////////////////
//:: Name 	Death by Thorns
//:: FileName sp_dth_thorns.nss
//:://////////////////////////////////////////////
/**@file Death by Thorns
Conjuration (Creation) [Evil, Death]
Level: Corrupt 7
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Targets: Up to three creatures, no two of which can
be more than 15 ft. apart
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: Yes

The caster causes thorns to sprout from the insides
of the subject creatures, which writhe in agony for
1d4 rounds, incapacitated, before dying. A wish or
miracle spell cast on a subject during this time can
eliminate the thorns and save that creature.
Creatures that succeed at their Fortitude saving
throws are still incapacitated for 1d4 rounds in
horrible agony, taking 1d6 points of damage per round.
At the end of the agony, however, the thorns disappear.

Corruption Cost: 1d3 points of Wisdom drain.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_inc_spells"

#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_SCInclude_BarbRage"

void DamageLoop(object oTarget, int nCount)
{
	effect eDam = HkEffectDamage(d6(1), DAMAGE_TYPE_MAGICAL);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	nCount--;

	if(nCount > 0)
	{
		DelayCommand(6.0f, DamageLoop(oTarget, nCount));
	}
}




void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DEATH_BY_THORNS; // put spell constant here
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

	
	object oTarget = HkGetSpellTarget();
	int nTargetCount;
	location lTarget = GetLocation(oTarget);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nDelay;
	float fDuration;
	effect ePar = EffectCutsceneImmobilize();
	effect eDeath = EffectDeath();
	int iAdjustedDamage;

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_DEATH_BY_THORNS, oCaster);

	//Check Spell Resistance
	if (!HkResistSpell(oCaster, oTarget ))
	{
		//loop the thorn giving 			max 3 targets
		while(GetIsObjectValid(oTarget) && nTargetCount < 3)
		{

		//if target isn't a friend
		if(!GetIsFriend(oTarget, oCaster))
		{
			nDelay = d4(1);
			fDuration = RoundsToSeconds(nDelay);

			//Immobilize target
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, fDuration);

			//Loop torture animation
			ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, fDuration);

			//Give thorns if spell if failed save
			iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_DEATH, oCaster, SAVING_THROW_RESULT_ROLL );
			if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
			{
				SCDeathlessFrenzyCheck(oTarget);
				DelayCommand(fDuration, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
			}
			else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
			{
					
				int nCount = nDelay;
				DamageLoop(oTarget, nCount);
				
			}

			//Increment targets
			nTargetCount++;
		}

			//Get next creature within 15 ft
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 7.5f, lTarget, FALSE, OBJECT_TYPE_CREATURE);
		}
	}

	//Corruption cost

	int nCost = d3(1);

	SCApplyCorruptionCost(oCaster, ABILITY_WISDOM, nCost, 1);

	//Alignment Shift
	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

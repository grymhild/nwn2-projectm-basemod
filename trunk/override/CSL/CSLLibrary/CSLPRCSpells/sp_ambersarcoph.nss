//::///////////////////////////////////////////////
//:: Name 	Amber Sarcophagus
//:: FileName sp_amber_sarc.nss
//:://////////////////////////////////////////////
/**@file Amber Sarcophagus
Evocation
Level: Sorcerer/wizard 7
Components: V,S,M
Casting Time: 1 standard action
Range: Close
Target: One creature
Duration: 1 day/level
Saving Throw: None
Spell Resistance: Yes

You infuse an amber sphere with magical power and
hurl it toward the target. If you succeed on a
ranged touch attack, the amber strikes the target
and envelops it in coruscating energy that hardens
immediately, trapping the target within a
translucent, immobile amber shell. The target is
perfectly preserved and held in stasis, unharmed
yet unable to take any actions. Within the amber
sarcophagus, the target is protected against all
attacks, including purely mental ones.

The amber sarcophagus has hardness 5 and 10hp per
caster level(maximum 200hp). If it is reduced to
0 hp, it shatters and crumbles to worhless amber
dust, at which point the target is released from
stasis (although it is flat footed until next
turn). Left alone, the amber sarcophagus traps
the target for the duration of the spell, then
disappears before releasing the target from
captive stasis.

Material Component: An amber sphere worth at
least 500 gp.

Author: 	Tenjac
Created: 	6/19/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void SarcMonitor(object oTarget, object oCaster, int nNormHP);
void RemoveSarc(object oTarget, object oCaster);
void MakeImmune(object oTarget, float fDur);
//#include "spinc_common"


#include "_HkSpell"
#include "_CSLCore_Combat"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_AMBER_SARCOPHAGUS; // put spell constant here
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

	//


	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	//float fDuration = HoursToSeconds(24 * nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_DAYS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_AMBER_SARCOPHAGUS, oCaster);

	//Make touch attack
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		//Sphere projectile VFX

		if(!HkResistSpell(oCaster, oTarget) )
		{
			//Apply effects
			effect eSarc = EffectLinkEffects(EffectTemporaryHitpoints(10 * CSLGetMin(20, nCasterLvl)), EffectCutsceneParalyze());
			// 	eSarc = EffectLinkEffects(eSarc, EffectVisualEffect(VFX_DUR_AMBER_SARCOPHAGUS));

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSarc, oTarget, fDuration);

			//Get starting HP
			int nNormHP = GetCurrentHitPoints(oTarget);

			//Make immune to pretty much everything
			MakeImmune(oCaster, fDuration);

			SarcMonitor(oCaster, oTarget, nNormHP);
		}
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

void SarcMonitor(object oCaster, object oTarget, int nNormHP)
{
	int nHP = GetCurrentHitPoints(oTarget);

	if(nHP <= nNormHP)
	{
		RemoveSarc(oTarget, oCaster);
	}

	else
	{
		DelayCommand(3.0f, SarcMonitor(oCaster, oTarget, nNormHP));

	}
}

void RemoveSarc(object oTarget, object oCaster)
{
	effect eTest = GetFirstEffect(oTarget);

	while(GetIsEffectValid(eTest))
	{
		if(GetEffectSpellId(eTest) == SPELL_AMBER_SARCOPHAGUS)
		{
			if(GetEffectCreator(eTest) == oCaster)
			{
				RemoveEffect(oTarget, eTest);
			}
		}
		eTest = GetNextEffect(oTarget);
	}
}

void MakeImmune(object oTarget, float fDuration)
{
	effect eLink;
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SILENCE));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_TRAP));
			eLink 	= EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
}
//::///////////////////////////////////////////////
//:: Living Undeath
//:: nx2_s0_living_undeath.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Living Undeath
	Necromancy
	Level: Cleric 2
	Components: V, S
	Range: Touch
	Target: Creature Touched
	Duration: 1 minute/level
	
	The spell imparts a physical transformation upon the subject, not unlike the process that produces a zombie.
	While the subject does not actually become undead, its vital processes are temporarily bypassed with no seeming ill effect.
	The subject is not subject to sneak attacks and critical hits for the duration of this spell, as though it were undead.
	
	While the spell is in effect, the subject takes a -4 penalty to Charisma score (to a minimum of 1).
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_livingundeat();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Living_Undeath;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	// Spell Duration
	float fDuration = TurnsToSeconds( HkGetSpellDuration( oCaster ) );
	// Effects
	int nDecrease = 4;
	int nTemp = GetAbilityScore(oTarget, ABILITY_CHARISMA) - nDecrease;
	if (nTemp < 1)
		nDecrease = abs(nTemp) + 1;
	if(GetAbilityScore(oTarget, ABILITY_CHARISMA) == 1)
		nDecrease = 0;
	effect eImmuneSA = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eImmuneCH = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	effect eDecreaseChar = EffectAbilityDecrease(ABILITY_CHARISMA, nDecrease);
	effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_LIVING_UNDEATH);
	effect eFrame = EffectVisualEffect(VFX_DUR_SPELL_LIVING_UNDEATH);
	effect eLink = EffectLinkEffects(eImmuneSA, eImmuneCH);
	eLink = EffectLinkEffects(eLink, eDecreaseChar);
	eLink = EffectLinkEffects(eLink, eFrame);
	
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
		// check to see if ally
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			// apply linked effect to target
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
	}
	
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Name 	Heartclutch
//:: FileName sp_heartclutch.nss
//:://////////////////////////////////////////////
/**@file Heartclutch
Transmutation [Evil]
Level: Clr 5
Components: V, S, Disease
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: The heart of one creature
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: Yes

The caster holds forth his empty hand, and the
stillbeating heart of the subject appears within it.
The subject dies in 1d3 rounds, and only a heal,
regenerate, miracle, or wish spell will save it
during this time. The target is entitled to a
Fortitude saving throw to survive the attack. If the
target succeeds at the save, it instead takes 3d6
points of damage +1 point per caster level from
general damage to the chest and internal organs.
(The target might die from damage even if it
succeeds at the saving throw.)

A creature with no discernible anatomy is unaffected
by this spell.

Disease Component: Soul rot.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void ClutchLoop(object oTarget, int nDelay, object oCaster);
int GetHasSoulRot(object oCaster);
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_BarbRage"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HEARTCLUTCH; // put spell constant here
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
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDelay = d3(1);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int iAdjustedDamage;

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_HEARTCLUTCH, oCaster);

	if( CSLGetIsLiving(oTarget) && !CSLGetIsOoze(oTarget) )
	{
		//Check for Soul rot

		if(GetHasSoulRot(oCaster))
		{
			//Check for Spell resistance
			if(!HkResistSpell(oCaster, oTarget ))
			{
			iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster, SAVING_THROW_RESULT_ROLL );
			if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
			{
				ClutchLoop(oTarget, nDelay, oCaster);
			}
			else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(d6(3) + nCasterLvl, DAMAGE_TYPE_MAGICAL), oTarget);
			}
			/*
			if(HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
			if(!GetHasMettle(oTarget, SAVING_THROW_FORT))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(d6(3) + nCasterLvl, DAMAGE_TYPE_MAGICAL), oTarget);
			}

			}
			else
			{
					//Clutching loop
					ClutchLoop(oTarget, nDelay, oCaster);
			}
			}
			*/
		}
	}
	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

void ClutchLoop(object oTarget, int nDelay, object oCaster)
{
	if(nDelay < 1)
	{
			SCDeathlessFrenzyCheck(oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
	}

	nDelay--;

	//Round we go...
	ClutchLoop(oTarget, nDelay, oCaster);
}

int GetHasSoulRot(object oCaster)
{
	int bHasDisease = FALSE;
	effect eTest = GetFirstEffect(oCaster);
	effect eDisease = SupernaturalEffect(EffectDisease(DISEASE_SOUL_ROT));

	if (CSLGetHasEffectType(oCaster,EFFECT_TYPE_DISEASE))
	{
		while (GetIsEffectValid(eTest))
		{
			if(eTest == eDisease)
			{
				bHasDisease = TRUE;

			}
			eTest = GetNextEffect(oCaster);
		}
	}
	return bHasDisease;
}



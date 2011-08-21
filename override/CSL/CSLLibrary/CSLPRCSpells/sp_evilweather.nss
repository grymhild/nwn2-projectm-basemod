//::///////////////////////////////////////////////
//:: Name 	Evil Weather
//:: FileName sp_evil_wthr.nss
//:://////////////////////////////////////////////
/**@file Evil Weather
Conjuration (Creation) [Evil]
Level: Corrupt 8
Components: V, S, M, XP, Corrupt (see below)
Casting Time: 1 hour
Range: Personal
Area: 1-mile/level radius, centered on caster
Duration: 3d6 minutes
Saving Throw: None
Spell Resistance: No

The caster conjures a type of evil weather. It
functions as described in Chapter 2 of this book,
except that area and duration are as given for this
spell. To conjure violet rain, the caster must
sacrifice 10,000 gp worth of amethysts and spend
200 XP. Other forms of evil weather have no material
component or experience point cost.

Corruption Cost: 3d6 points of Constitution damage.

Author: 	Tenjac
Created: 	3/10/2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_inc_spells"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EVIL_WEATHER; // put spell constant here
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

	
	object oArea = GetArea(oCaster);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nSpell = HkGetSpellId();
	//added argument, no idea what to do with the function now - NWN2
	int nWeather = GetWeather(oArea, WEATHER_TYPE_RAIN);
		
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(d6(3), SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Rain of Blood -1 to attack, damage, saves and checks living, +1 undead
	if (nSpell == SPELL_EVIL_WEATHER_RAIN_OF_BLOOD)
	{
		//Change to rain
		SetWeather(oArea, WEATHER_TYPE_RAIN);
		DelayCommand(fDuration, SetWeather(oArea, nWeather));

		//Spell VFX

		//Define effects
		effect eBuff = EffectAttackIncrease(1);
			eBuff = EffectLinkEffects(eBuff, EffectDamageIncrease(1));
			eBuff = EffectLinkEffects(eBuff, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));
			eBuff = SupernaturalEffect(eBuff);
		effect eDebuff = EffectAttackDecrease(1);
			eDebuff = EffectLinkEffects(eDebuff, EffectDamageDecrease(1));
			eDebuff = EffectLinkEffects(eDebuff, EffectSavingThrowDecrease(SAVING_THROW_ALL, 1));
			eDebuff = SupernaturalEffect(eDebuff);

		//GetFirst
		object oObject = GetFirstObjectInArea(oArea);

		//Loop
		while(GetIsObjectValid(oObject))
		{
			if ( CSLGetIsUndead(oObject) )
			{
				//Apply bonus
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oObject, fDuration);
			}

			else
			{ 	//Apply penalty if alive
				if( CSLGetIsLiving(oObject) )
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oObject, fDuration);
				}
			}

			oObject = GetNextObjectInArea();
		}
	}

	//Violet Rain 	No divine spells/abilities for 24 hours
	if (nSpell == SPELL_EVIL_WEATHER_VIOLET_RAIN)
	{
		if( GetGold(oCaster) >= 10000 )
		{
			//Spend Gold
			TakeGoldFromCreature(10000, oCaster, TRUE);

			//Handle 200XP cost
			int nXP = GetXP(oCaster);
			int nNewXP = (nXP - 200);
			SetXP(oCaster, nNewXP);

			//Set local on area
			SetLocalInt(oArea, "VIOLET_RAIN_MARKER", 1);

			//Change to rain
			SetWeather(oArea, WEATHER_TYPE_RAIN);

			DelayCommand(fDuration, SetWeather(oArea, nWeather));
			DelayCommand(fDuration, DeleteLocalInt(oArea, "VIOLET_RAIN_MARKER"));
		}
	}

	//Green Fog
	if (nSpell == SPELL_EVIL_WEATHER_GREEN_FOG)
	{
		string sFog = "nw_green_fog";

	}

	//Rain of Frogs or Fish
	if (nSpell == SPELL_EVIL_WEATHER_RAIN_OF_FISH)
	{
		//Change to rain
		SetWeather(oArea, WEATHER_TYPE_RAIN);
		DelayCommand(fDuration, SetWeather(oArea, nWeather));

	}

	CSLSpellEvilShift(oCaster);

	//Corruption cost
	int nCost = d6(3);

	SCApplyCorruptionCost(oCaster, ABILITY_CONSTITUTION, nCost, 0);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
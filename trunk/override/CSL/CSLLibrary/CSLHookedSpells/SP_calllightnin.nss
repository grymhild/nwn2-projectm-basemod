//::///////////////////////////////////////////////
//:: Call Lightning
//:: NX_s0_callstorm.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	PNP version...
	Call Lightning
	Evocation [Electricity]
	Level:	Drd 3
	Components:	V, S
	Casting Time:	1 round
	Range:	Medium (100 ft. + 10 ft./level)
	Effect:	One or more 30-ft.-long vertical lines of lightning
	Duration:	1 min./level
	Saving Throw:	Reflex half
	Spell Resistance:	Yes
	Immediately upon completion of the spell, and once per round thereafter, you may call down a 5-foot-wide, 30-foot-long, vertical bolt of lightning that deals 3d6 points of electricity damage. The bolt of lightning flashes down in a vertical stroke at whatever target point you choose within the spell�s range (measured from your position at the time). Any creature in the target square or in the path of the bolt is affected.
	
	You need not call a bolt of lightning immediately; other actions, even spellcasting, can be performed. However, each round after the first you may use a standard action (concentrating on the spell) to call a bolt. You may call a total number of bolts equal to your caster level (maximum 10 bolts).
	
	If you are outdoors and in a stormy area�a rain shower, clouds and wind, hot and cloudy conditions, or even a tornado (including a whirlwind formed by a djinni or an air elemental of at least Large size)�each bolt deals 3d10 points of electricity damage instead of 3d6.
	
	This spell functions indoors or underground but not underwater.
	
	OEI version below...
	This spells smites an area around the caster
	with bolts of lightning which strike all enemies.
	Bolts do 3d6 per level up 15d6 and the reflex save
	is made at a -4 penalty.
	
	NOTE: The bioware implimentation of this spell
	is nothing like the PHB, so this is an approximation
	of the intended behavior.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills based on nw_s0_calllghtn (05.22.01 Preston Watamaniuk)
//:: Created On: 11.29.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here. level 3, row 11

/*
 All enemies within the area of effect take 1d6 points of electrical damage per caster level, to a maximum of 10d6.
 Line 75: This doesn't make use of the much better NWN2 ApplyMetamagicVariableMods() function for metamagic empower/maximise.

As opposed to the in-game description, this spell is actually self-centered (range:personal).
This is essentially a Fireball spell but it only ever affects enemies, and does electrical damage instead of fire damage. This makes it one Druid spell which ranks quite highly for damage and utility. It also can affect objects like doors to batter them down.
Like Fireball and all direct-damage spells, its usefulness is diminished if the damage doesn't kill the enemies it is targeted at, since they can still fight perfectly well and possibly heal themselves of the damage in the meantime.
This spell is also, like Fireball, a lot less effective against anyone with Evasion, which can ignore the damage done by this spell on a successful reflex save.
Note: The 3.5E version of this spell differs quite a bit. Instead of simply being a Druid Fireball, it instead fired separate bolts of lightning. The first one is automatic, but up to a maximum number of bolts equal to the caster's level can be called (maximum 10). Each round, a single bolt will do 3d6 damage to one creature, if the caster concentrates on doing it as a standard action. The area of effect lasts for 1 minute / caster level. The damage is also increased to 3d10 if in storm/rainy weather.
Of course, it would be much harder to implement this in NWN2, however, it is odd how Bioware/Obsidian didn't think that 1 bolt / level at 3d6/3d10 damage would be sufficient (which is what the original spell did), maybe even allowing 2 or bolts per creature.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Environment"
#include "_SCInclude_Evocation"
#include "_CSLCore_ObjectVars"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CALL_LIGHTNING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	if ( CSLGetPreferenceSwitch("PNPCallLightning", FALSE ) )
	{
		int iDieSize = 6;
		int iMaxToHit = HkGetSpellPower( oCaster, 10 );
		
		if ( GetLocalInt( GetArea(oCaster), "SC_WEATHERCALMED" ) )
		{
			iDieSize = 0;
		}
		else if ( GetLocalInt( GetArea(oCaster), "CSL_ENVIRO" ) & CSL_ENVIRO_WATER )
		{
			iDieSize = 0;
		}
		else if ( GetIsAreaInterior( GetArea(oCaster) )  )
		{
			iDieSize = 4;
			if ( CSLGetIsAirElementalWithinRange(  GetLocation(oCaster), oCaster ) )
			{
				iDieSize = 10;
			}
		}
		else
		{
			int iWeatherState = GetLocalInt( GetArea(oCaster), "CSL_WEATHERSTATE");
			
			int iWeatherPower = CSLEnviroGetEnviroStatePower( iWeatherState );
			int iRainPower = GetWeather(GetArea(oCaster), WEATHER_TYPE_RAIN);
			int iThunderPower = GetWeather(GetArea(oCaster), WEATHER_TYPE_LIGHTNING);
			
			if ( iWeatherPower > 4 || iRainPower > 4 || iThunderPower > 4 )
			{
				iDieSize = 14;
			}
			else if ( iWeatherPower > 3 || iRainPower > 3 || iThunderPower > 3 )
			{
				iDieSize = 12;
			}
			else if ( iWeatherPower > 2 || iRainPower > 2 || iThunderPower > 2 )
			{
				iDieSize = 10;
			}
			else if ( CSLGetIsAirElementalWithinRange( GetLocation(oCaster), oCaster ) )
			{
				iDieSize = 10;
			}
			else if ( iWeatherPower > 0 || iRainPower > 0 || iThunderPower > 0 )
			{
				iDieSize = 8;
			}
			
		}
		
		if ( iDieSize > 0 )
		{
			SCDoLightningEffectsInArea( oCaster, GetLocation(oCaster), 3, iDieSize, iSpellId, iMaxToHit, 6.0f, HkGetMetaMagicFeat() );
		}
		else
		{
			SendMessageToPC( oCaster, "Lightning cannot be called in this area." );
		}
	
	}
	else
	{
		
		//Declare major variables
		
		int iSpellPower = HkGetSpellPower( oCaster, 10 );
		
		int iDamage;
		float fDelay;
		
		//--------------------------------------------------------------------------
		// Elemental Damage Modifiers
		//--------------------------------------------------------------------------
		int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
		//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
		int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
		int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
		float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
		//--------------------------------------------------------------------------
		// Effects
		//--------------------------------------------------------------------------	

		
		effect eVis = EffectVisualEffect(iHitEffect);
		effect eVis2 = EffectVisualEffect(916); //VFX_SPELL_HIT_CALL_LIGHTNING
		effect eDur = EffectVisualEffect(915); //VFX_SPELL_DUR_CALL_LIGHTNING
		effect eLink = EffectLinkEffects(eVis, eVis2);
		effect eDam;
		//Get the spell target location as opposed to the spell target.
		location lTarget = HkGetSpellTargetLocation();
		
		//Declare the spell shape, size and the location.  Capture the first target object in the shape.
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, 1.75);
		//Cycle through the targets within the spell shape until an invalid object is captured.
		while (GetIsObjectValid(oTarget))
		{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
					//Get the distance between the explosion and the target to calculate delay
					fDelay = CSLRandomBetweenFloat(1.4, 2.25); // AFW-OEI 07/10/2007: Increase delay to synch better with AoE VFX.
					if (!HkResistSpell(oCaster, oTarget, fDelay))
					{
						//Roll damage for each target
						iDamage = d6(iSpellPower);
						//Resolve metamagic
						iDamage = HkApplyMetamagicVariableMods(iDamage, 60);
					
						//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
						iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, ( HkGetSpellSaveDC() ), iSaveType);
						//Set the damage effect
						eDam = HkEffectDamage(iDamage, iDamageType);
						if(iDamage > 0)
						{
								// Apply effects to the currently selected target.
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
								//This visual effect is applied to the target object not the location as above.  This visual effect
								//represents the flame that erupts on the target not on the ground.
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
						}
					}
				}
			//Select the next target within the spell shape.
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		}
	}
	
	HkPostCast(oCaster);
}
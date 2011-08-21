//::///////////////////////////////////////////////
//:: Planar Tear
//:: sg_s0_consecrat.nss
//:: 2009 Brian Meyer (Pain)
//:://////////////////////////////////////////////
/*
Planar Tear
Caster Level(s): Sorcerer/Wizard 9
Innate Level: 9
School: Conjuration
Descriptor(s): Varies by plane
Component(s): Verbal, Somatic
Range: Caster
Area of Effect: 40-ft.-radius burst around caster
Duration: 1 round per caster level
Save: Reflex half (see text)
Spell Resistance: None ( see text )

This is a dangerous spell which opens a tear to one of the other planes of existance. Unlike an
evocation, this is more of a conjuration which makes the environs around the caster filled with the
essence of that other plane.

This is not under the casters control, and it affects friend and foe alike and can easily kill the
caster. The plane which is connected to is entirely random, unless the caster is capable of
controlling the energy type which is summoned. ( energy mastery and certain other things can allow
this to be controlled somewhat, even then it is not automatic. ) The rift can never be to the same
plane as that which the caster is on. Hopefully for the caster and those near him he's managed to
prepare ahead of casting this spell some magic which allows him to survive.

Generally this is viewed by most druids, whether good or evil, as a direct attack on the balance
they hold dear.

The first round is burst of pure energy, doing damage up to the caster level in hit dice ( up to
30d6 with a reflex check) to all those in the area of effect except for the caster. All after
effects, affect ALL those in the area of effect so the caster generally needs some sort of
protection. The damage type and effect vary based on the plane connected to.

After the rift is opened the caster cannot do anything until it closes, and the rift remain open for
2d6 rounds. An area of effect of 40 foot remains in the area of effect and it affects all those who
are within it like they are on the plane the rift is connected to. This will modify spells within
the area of effect to work as they would on the plane the rift is to, which can have far reaching
effects. Those within the area are all, including the caster, affected as if they are on that plane
which often is quite inhospitable. The weather in the area the spell is cast might also be affected.
There is a chance of creatures from said plane showing up in the rift as well. If the caster dies
the spell immediately ends.

Planes the rift opens to can vary a great deal, some previously recorded planes a rift have been
opened to include:

The elemental plane of Water: everything in the area is underwater, damage is bludgeoning damage
from a tidal wave as it fills up a sphere. Afterwards all those within the area must hold their
breath or they can drown.

The elemental plane of Negative: everything in the area is filled with intense darkness, damage is
negative damage all those in the area of effect, and doing 1d6 per round. Undead are healed in the
area of effect.

The elemental plane of Positive: everything in the area is filled with intense light, damage is
positive heallng all those in the area of effect, and doing 1d6 per round.  This healing exceeds the
maximum total of hit points and provides temporary hit points for a short duration. If the creature
exceeds double his normal hit points, he explodes. Undead suffer damage instead.

Feywilde: The area of effect does not do normal damage but instead does random effects, which have
includes flowers, butterflies with razorblade wings, polymorphs, and dead magic and wild magic
zones, singing daggers.

Plane of fire: Everything is damaged by fire and the area does 1d6 fire damage per round.

Other planes have had rifts opened to, but little is known since quite often the caster of this
dangerous spell does not survive.
*/

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CONTROLWEATHER; // put spell constant here
	int iTrueSpellId = GetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iDescriptor = SCMETA_DESCRIPTOR_AIR;
	if ( iTrueSpellId == SPELL_CONTROLWEATHER_RAINSTORM )
	{
		iDescriptor |= SCMETA_DESCRIPTOR_WATER;
	}
	else if ( iTrueSpellId == SPELL_CONTROLWEATHER_THUNDERSTORM )
	{
		iDescriptor |= SCMETA_DESCRIPTOR_ELECTRICAL|SCMETA_DESCRIPTOR_WATER;
	}
	else if ( iTrueSpellId == SPELL_CONTROLWEATHER_SNOWSTORM )
	{
		iDescriptor |= SCMETA_DESCRIPTOR_COLD;
	}
	else if ( iTrueSpellId == SPELL_CONTROLWEATHER_SANDSTORM )
	{
		iDescriptor |= SCMETA_DESCRIPTOR_AIR;
	}
	else if ( iTrueSpellId == SPELL_CONTROLWEATHER_CALM )
	{
		iDescriptor |= SCMETA_DESCRIPTOR_AIR;
	}
	
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	object oArea = GetArea(oCaster);
	if (  GetIsAreaInterior( oArea ) )
	{
		SendMessageToPC( oCaster, "Spell Failed: Not Outside");
		return;
	}
	
	if (  !GetIsAreaNatural( oArea ) )
	{
		SendMessageToPC( oCaster, "Spell Failed: Not Natural");
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iWeatherState = GetLocalInt( oArea, "CSL_WEATHERSTATE"); // for weather changing effects
	int iOrigWeatherState = iWeatherState;
	int iWeatherPower = CSLEnviroGetEnviroStatePower( iWeatherState  );
	
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower(oCaster, 60);
	//object  oTarget = HkGetSpellTarget();
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	//int iDuration = HkGetSpellDuration( oCaster, 60 );
	//float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration/2, SC_DURCATEGORY_ROUNDS) );
	
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	//int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    //float fRadius = FeetToMeters(40.0);
    //int iShape = SHAPE_SPHERE;
    object oAOE;
    int iDispelledWeather = FALSE;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    //effect eImpVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
    

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	//location lImpactLoc = GetLocation(oCaster); // GetLocation( oCreator );
	//effect eImpactVis = EffectVisualEffect( iImpactSEF );
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, lTarget);
	

    // set up defaults
    
	if ( iTrueSpellId == SPELL_CONTROLWEATHER_THUNDERSTORM )
	{
		iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FOG );
		iWeatherState &= ~CSL_WEATHER_TYPE_SNOW;
		iWeatherState |= CSL_WEATHER_TYPE_RAIN;
		iWeatherState &= ~CSL_WEATHER_ATMOS_SAND;
		
		iWeatherState |= CSL_WEATHER_RANDOMLIGHTNING;
		iWeatherState |= CSL_WEATHER_TYPE_THUNDER;
		
		DelayCommand( 12.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
		DelayCommand( 48.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
		if ( HkGetSpellClass( oCaster ) == CLASS_TYPE_DRUID )
		{
			DelayCommand( 36.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			DelayCommand( 48.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			//DelayCommand( 60.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			DelayCommand( 72.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
		}
		CSLEnviroSetWeather( GetArea(oCaster), iWeatherState );
		
		SendMessageToPC( oCaster, "You hear distant thunder");
	}
	else if ( iTrueSpellId == SPELL_CONTROLWEATHER_SNOWSTORM )
	{
		iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FOG );
		iWeatherState |= CSL_WEATHER_TYPE_SNOW;
		iWeatherState &= ~CSL_WEATHER_TYPE_RAIN;
		iWeatherState &= ~CSL_WEATHER_ATMOS_SAND;
		
		DelayCommand( 12.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
		//DelayCommand( 48.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
		if ( HkGetSpellClass( oCaster ) == CLASS_TYPE_DRUID )
		{
			DelayCommand( 36.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			DelayCommand( 48.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			//DelayCommand( 60.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			DelayCommand( 72.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
		}
		CSLEnviroSetWeather( GetArea(oCaster), iWeatherState );
		
		SendMessageToPC( oCaster, "The area gets colder");
		
		
	}
	else if ( iTrueSpellId == SPELL_CONTROLWEATHER_SANDSTORM )
	{
		iWeatherState &= CSL_WEATHER_TYPE_SNOW;
		iWeatherState &= CSL_WEATHER_TYPE_RAIN;
		iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_SAND );
		
		iWeatherState |= CSL_WEATHER_RANDOMGUSTS;
		
		DelayCommand( 12.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
		if ( HkGetSpellClass( oCaster ) == CLASS_TYPE_DRUID )
		{
			DelayCommand( 36.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			DelayCommand( 48.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			DelayCommand( 48.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
			//DelayCommand( 60.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		}
		
		//DelayCommand( 72.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, 1 ) );
		CSLEnviroSetWeather( GetArea(oCaster), iWeatherState );
		
		SendMessageToPC( oCaster, "The wind starts to pick up");
	}
	else if ( iTrueSpellId == SPELL_CONTROLWEATHER_CALM )
	{
		DelayCommand( 12.0f, CSLEnviroAdjustEnviroStatePower( oArea, -1 ) );
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStatePower( oArea, -1 ) );
		DelayCommand( 36.0f, CSLEnviroAdjustEnviroStatePower( oArea, -1 ) );
		if ( HkGetSpellClass( oCaster ) == CLASS_TYPE_DRUID )
		{
			DelayCommand( 60.0f, CSLEnviroAdjustEnviroStatePower( oArea, -1 ) );
			DelayCommand( 48.0f, CSLEnviroAdjustEnviroStatePower( oArea, -1 ) );
			DelayCommand( 72.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, -1 ) );
		}
		DelayCommand( 72.0f, CSLEnviroAdjustEnviroStatePower( oArea, -1 ) );
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, -1 ) );
		DelayCommand( 48.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, -1 ) );
		
		
		CSLIncrementLocalInt(oArea, "SC_WEATHERCALMED", 1);
		DelayCommand ( 24.0f, CSLDecrementLocalInt_Void(oArea, "SC_WEATHERCALMED", 1, TRUE) );
		
		//DelayCommand( 72.0f, CSLEnviroSetWeather( oArea, CSL_WEATHER_TYPE_NONE );
		
		SendMessageToPC( oCaster, "The wind starts to die");
	}
	else
	{
	//if ( iTrueSpellId == SPELL_CONTROLWEATHER_RAINSTORM || iTrueSpellId == SPELL_CONTROLWEATHER )
		iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FOG );
		iWeatherState |= CSL_WEATHER_TYPE_RAIN;
		iWeatherState &= ~CSL_WEATHER_TYPE_SNOW;
		iWeatherState &= ~CSL_WEATHER_ATMOS_SAND;
		
		DelayCommand( 12.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		DelayCommand( 24.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
		if ( HkGetSpellClass( oCaster ) == CLASS_TYPE_DRUID )
		{
			DelayCommand( 36.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			DelayCommand( 48.0f, CSLEnviroAdjustEnviroStatePower( oArea, 1 ) );
			DelayCommand( 24.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, -1 ) );
		}
		
		DelayCommand( 48.0f, CSLEnviroAdjustEnviroStateFrequency( oArea, -1 ) );

		CSLEnviroSetWeather( GetArea(oCaster), iWeatherState );
		SendMessageToPC( oCaster, "A Rain Starts to fall");
	}
	//if ( iWeatherState != iOrigWeatherState )
	//{
	//	CSLEnviroSetWeather( GetArea(oCaster), iWeatherState );
	//	DelayCommand( fDuration+4.0f, CSLEnviroSetWeather( GetArea(oCaster), iOrigWeatherState ) );
    //}
    HkPostCast(oCaster);
}
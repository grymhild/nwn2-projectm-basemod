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
	int iSpellId = SPELL_PLANAR_TEAR; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	int iDescriptor = SCMETA_DESCRIPTOR_NONE;
	
	// random switch
	int iRoll = d12();
	switch (iRoll)
	{
		case 1:
			iDescriptor = SCMETA_DESCRIPTOR_FIRE;
			break;
		case 2:
			iDescriptor = SCMETA_DESCRIPTOR_COLD;
			break;
		case 3:
			iDescriptor = SCMETA_DESCRIPTOR_NEGATIVE;
			break;
		case 4:
			iDescriptor = SCMETA_DESCRIPTOR_POSITIVE;
			break;
		case 5:
			iDescriptor = SCMETA_DESCRIPTOR_WATER;
			break;
		case 6:
			iDescriptor = SCMETA_DESCRIPTOR_EVIL;
			break;
		case 7:
			iDescriptor = SCMETA_DESCRIPTOR_GOOD;
			break;
		case 8:
			iDescriptor = SCMETA_DESCRIPTOR_ELECTRICAL;
			break;
		case 9:
			iDescriptor = SCMETA_DESCRIPTOR_ACID;
			break;
		case 10:
			iDescriptor = SCMETA_DESCRIPTOR_DIVINE;
			break;
		case 11:
			iDescriptor = SCMETA_DESCRIPTOR_MAGICAL;
			break;
		case 12:
			iDescriptor = SCMETA_DESCRIPTOR_AIR;
			break;
		case 13:
			iDescriptor = SCMETA_DESCRIPTOR_EARTH;
			break;
		case 14:
			iDescriptor = SCMETA_DESCRIPTOR_LAW;
			break;
		case 15:
			iDescriptor = SCMETA_DESCRIPTOR_CHAOS;
			break;
		case 16:
			iDescriptor = SCMETA_DESCRIPTOR_FORCE;
			break;
		case 17:
			iDescriptor = SCMETA_DESCRIPTOR_ENERGY;
			break;
		case 18:
			iDescriptor = SCMETA_DESCRIPTOR_SONIC;
			break;
		
		
	}
	

	
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oArea = GetArea(oCaster);
	int iWeatherState = GetLocalInt( oArea, "CSL_WEATHERSTATE"); // for weather changing effects
	int iOrigWeatherState = iWeatherState;
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower(oCaster, 60);
	//object  oTarget = HkGetSpellTarget();
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 60 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration/2, SC_DURCATEGORY_ROUNDS) );
	
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    float fRadius = FeetToMeters(40.0);
    int iShape = SHAPE_SPHERE;
    object oAOE;
    int iDispelledDesecrate = FALSE;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
   // effect eImpVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
    

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = GetLocation(oCaster); // GetLocation( oCreator );
	//effect eImpactVis = EffectVisualEffect( iImpactSEF );
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, lTarget);
	

    // set up defaults
    int iAOEType = AOE_PLANARTEAR_FIRE;
	int iEnviroType = CSL_ENVIRO_FIRE;
	string sEnterScript = "TG_AM_Fire_OnEnter";
	string sExitScript = "TG_AM_Fire_OnExit";
	string sPlaneName = "A Rip is torn to the Elemental Plane of Fire";
	int iDamageType = DAMAGE_TYPE_FIRE;
	int iSaveType = SAVING_THROW_TYPE_FIRE;
 
 	if ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )
	{
		iAOEType = AOE_PLANARTEAR_FIRE;
		iEnviroType = CSL_ENVIRO_FIRE;
		sEnterScript = "TG_AM_Fire_OnEnter";
		sExitScript = "TG_AM_Fire_OnExit";
		sPlaneName = "A Rip is torn to the Elemental Plane of Fire";
		iDamageType = DAMAGE_TYPE_FIRE;
		iSaveType = SAVING_THROW_TYPE_FIRE;
		iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_SMOKE );
		iWeatherState &= ~CSL_WEATHER_RANDOM_RARELY; 
		iWeatherState &= ~CSL_WEATHER_RANDOM_SELDOM;
		iWeatherState |= CSL_WEATHER_RANDOM_OFTEN;
		iWeatherState |= CSL_WEATHER_RANDOMEXPLODE;
		iWeatherState |= CSL_WEATHER_TYPE_FIERY;
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_COLD )
	{
		iAOEType = AOE_PLANARTEAR_COLD;
		iEnviroType = CSL_ENVIRO_COLD;
		sEnterScript = "TG_AM_Cold_OnEnter";
		sExitScript = "TG_AM_Cold_OnExit";
		sPlaneName = "A Rip is torn to the Elemental Plane of Cold";
		iDamageType = DAMAGE_TYPE_COLD;
		iSaveType = SAVING_THROW_TYPE_COLD;
		iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FOG );
		iWeatherState |= CSL_WEATHER_TYPE_SNOW;
		iWeatherState &= ~CSL_WEATHER_TYPE_RAIN;
		iWeatherState &= ~CSL_WEATHER_ATMOS_SAND;
		iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_STORMY );
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE )
	{
		iAOEType = AOE_PLANARTEAR_NEGATIVE;
		iEnviroType = CSL_ENVIRO_NEGATIVE;
		sEnterScript = "TG_AM_Negative_OnEnter";
		sExitScript = "TG_AM_Negative_OnExit";
		sPlaneName = "A Rip is torn to Shadowfell";
		iDamageType = DAMAGE_TYPE_NEGATIVE;
		iSaveType = SAVING_THROW_TYPE_NEGATIVE;
		CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_BLACK );
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE )
	{
		iAOEType = AOE_PLANARTEAR_POSITIVE;
		iEnviroType = CSL_ENVIRO_POSITIVE;
		sEnterScript = "TG_AM_Positive_OnEnter";
		sExitScript = "TG_AM_Positive_OnExit";
		sPlaneName = "A Rip is torn to the Elemental Plane of Positive";
		iDamageType = DAMAGE_TYPE_POSITIVE;
		iSaveType = SAVING_THROW_TYPE_POSITIVE;
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )
	{
		iAOEType = AOE_PLANARTEAR_FLOOD;
		iEnviroType = CSL_ENVIRO_WATER;
		sEnterScript = "TG_AM_Water_OnEnter";
		sExitScript = "TG_AM_Water_OnExit";
		sPlaneName = "A Rip is torn to the Elemental Plane of Water";
		iDamageType = DAMAGE_TYPE_BLUDGEONING;
		iSaveType = SAVING_THROW_TYPE_FIRE;
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )
	{
		iAOEType = AOE_PLANARTEAR_HELL;
		iEnviroType = CSL_ENVIRO_PROFANE|CSL_ENVIRO_MAGMA;
		sEnterScript = "TG_AM_Generic_OnEnter";
		sExitScript = "TG_AM_Generic_OnExit";
		sPlaneName = "A Rip is torn to Hell";
		iDamageType = DAMAGE_TYPE_SLASHING;
		iSaveType = SAVING_THROW_TYPE_EVIL;
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL || iDescriptor & SCMETA_DESCRIPTOR_AIR)
	{
		iAOEType = AOE_PLANARTEAR_ELECTRICAL;
		iEnviroType = CSL_ENVIRO_PROFANE;
		sEnterScript = "TG_AM_Profane_OnEnter";
		sExitScript = "TG_AM_Profane_OnExit";
		sPlaneName = "A Rip is torn to the Elemental Plane of Storm";
		iDamageType = DAMAGE_TYPE_ELECTRICAL;
		iSaveType = SAVING_THROW_TYPE_ELECTRICITY;
		iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_FOG );
		iWeatherState &= ~CSL_WEATHER_RANDOM_RARELY; 
		iWeatherState &= ~CSL_WEATHER_RANDOM_SELDOM;
		iWeatherState |= CSL_WEATHER_RANDOM_OFTEN;
		iWeatherState |= CSL_WEATHER_RANDOMLIGHTNING;
		iWeatherState |= CSL_WEATHER_TYPE_RAIN;
		iWeatherState &= ~CSL_WEATHER_TYPE_SNOW;
		iWeatherState &= ~CSL_WEATHER_ATMOS_SAND;
		iWeatherState = CSLEnviroSetEnviroStatePower( iWeatherState, WEATHER_POWER_STORMY );
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ACID || iDescriptor & SCMETA_DESCRIPTOR_EARTH)
	{
		iAOEType = AOE_PLANARTEAR_ACID;
		iEnviroType = CSL_ENVIRO_ACIDIC;
		sEnterScript = "TG_AM_Profane_OnEnter";
		sExitScript = "TG_AM_Profane_OnExit";
		sPlaneName = "A Rip is torn to the Elemental Plane of Acid";
		iDamageType = DAMAGE_TYPE_ACID;
		iSaveType = SAVING_THROW_TYPE_ACID;
		iWeatherState = CSLEnviroSetEnviroStateFog( iWeatherState, CSL_WEATHER_ATMOS_ACIDIC );
		iWeatherState |= CSL_WEATHER_TYPE_ACIDIC;
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_MAGICAL )
	{
		iAOEType = AOE_PLANARTEAR_MAGIC;
		iEnviroType = CSL_ENVIRO_WILDMAGIC;
		sEnterScript = "TG_AM_Profane_OnEnter";
		sExitScript = "TG_AM_Profane_OnExit";
		sPlaneName = "A Rip is torn to Fey Wilde";
		iDamageType = DAMAGE_TYPE_MAGICAL;
		iSaveType = SAVING_THROW_TYPE_EVIL;
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD || iDescriptor & SCMETA_DESCRIPTOR_DIVINE )
	{
		iAOEType = AOE_PLANARTEAR_HEAVEN;
		iEnviroType = CSL_ENVIRO_HOLY;
		sEnterScript = "TG_AM_Profane_OnEnter";
		sExitScript = "TG_AM_Profane_OnExit";
		sPlaneName = "A Rip is torn to Heaven";
		iDamageType = DAMAGE_TYPE_MAGICAL;
		iSaveType = SAVING_THROW_TYPE_EVIL;
	}
	else if ( iDescriptor & SCMETA_DESCRIPTOR_SONIC )
	{
		iAOEType = AOE_PLANARTEAR_SONIC;
		iEnviroType = CSL_ENVIRO_NONE;
		sEnterScript = "";
		sExitScript = "";
		sPlaneName = "A Rip is torn to the Elemental Plane of Sound";
		iDamageType = DAMAGE_TYPE_SONIC;
		iSaveType = SAVING_THROW_TYPE_SONIC;
	}
	
	FloatingTextStringOnCreature( ""+sPlaneName, oCaster, TRUE);
	
 	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, TRUE  ); // only one permitted at a time
	effect eAOE = EffectAreaOfEffect(iAOEType, sEnterScript, "", sExitScript, sAOETag);
	eAOE = EffectLinkEffects(eAOE, EffectCutsceneImmobilize());
	eAOE = EffectLinkEffects(eAOE, EffectSpellFailure(100));
	eAOE = EffectLinkEffects(eAOE, EffectMissChance(100));
	//eAOE = EffectLinkEffects(eAOE, EffectCutsceneParalyze());
	DelayCommand( 0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration) );
	DelayCommand( 0.5f, SetLocalInt( GetObjectByTag( sAOETag ), "CSL_ENVIRO", iEnviroType ) );
    if ( iEnviroType & CSL_ENVIRO_WATER )
    {
		DelayCommand( 0.5f, SetLocalFloat( GetObjectByTag( sAOETag ), "CSL_WATERSURFACEHEIGHT", 999999999999.99f ) );
    }
    
    //effect eDam;
	float fDelay;
	int iDamage;
	int iNewDamage;
	//location lImpactLoc = GetLocation(oTarget);
	
	effect eDamage;
	effect eKnock = EffectKnockdown();

// explode them
	//effect eExplode = EffectVisualEffect( CSLGetAOEExplodeByDamageType( iDamageType, fRadius ) );
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lImpactLoc );
	object oCurrentTarget = GetFirstObjectInShape(iShape, fRadius, lImpactLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE  );
	while (GetIsObjectValid(oCurrentTarget))
	{
		if ( oCurrentTarget != oCaster )
		{
			if (CSLSpellsIsTarget(oCurrentTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oCurrentTarget, EventSpellCastAt(oCurrentTarget, SPELL_PLANAR_TEAR, TRUE ) );
			}
			else
			{
				SignalEvent(oCurrentTarget, EventSpellCastAt(oCurrentTarget, SPELL_PLANAR_TEAR, FALSE ) );
			}			
			iDamage = d6(iSpellPower);
			iNewDamage = GetReflexAdjustedDamage(iDamage, oCurrentTarget, HkGetSpellSaveDC(oCaster, oCurrentTarget), iSaveType );
			//Set the damage effect
			//eDam = EffectDamage(iDamage, iDamageType);
			if(iDamage == iNewDamage ) // they did not save at all
			{
				if ( iDamageType == DAMAGE_TYPE_POSITIVE)
				{
					CSLEnviroApplyPositiveEffect( oCurrentTarget, iNewDamage);
				}
				else
				{
					eDamage = EffectDamage(iNewDamage, iDamageType);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCurrentTarget);
				}
				CSLHurlTargetFromLocation(lImpactLoc, oCurrentTarget, fRadius/4 );
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oCurrentTarget, 4.0f);
				if ( !GetIsImmune( oCurrentTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
				{
					CSLIncrementLocalInt_Timed(oCurrentTarget, "CSL_KNOCKDOWN",  4.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
				}
			
			}
			else if ( iNewDamage > 0 ) // they saved and take some damage
			{
				if ( iDamageType == DAMAGE_TYPE_POSITIVE)
				{
					CSLEnviroApplyPositiveEffect( oCurrentTarget, iNewDamage);
				}
				else
				{
					eDamage = EffectDamage(iNewDamage, iDamageType);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCurrentTarget);
				}
			}
		}
		//Select the next target within the spell shape.
		oCurrentTarget = GetNextObjectInShape(iShape, fRadius, lImpactLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
	}
	
	
	if ( iWeatherState != iOrigWeatherState )
	{
		if ( !GetIsAreaInterior( oArea ) && GetIsAreaNatural( oArea ) )
		{
			CSLEnviroSetWeather( oArea, iWeatherState );
			DelayCommand( fDuration+4.0f, CSLEnviroSetWeather( oArea, iOrigWeatherState ) );
		}
    }
    HkPostCast(oCaster);
}

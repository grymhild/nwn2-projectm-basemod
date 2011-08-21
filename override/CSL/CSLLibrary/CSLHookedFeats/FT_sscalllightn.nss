//::///////////////////////////////////////////////
//:: Stormsingers Call Lightning
//:: cmi_s2_calllight
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 15, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//Based on Call Lightning by OEI

#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
#include "_SCInclude_Class"
#include "_CSLCore_Environment"
#include "_SCInclude_Evocation"
#include "_CSLCore_ObjectVars"

void main()
{	
	//scSpellMetaData = SCMeta_FT_sscalllightn();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = STORMSINGER_CALL_LIGHTNING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	if ( CSLGetPreferenceSwitch("PNPCallLightning", FALSE ) )
	{
		
		int iCasterLevel = GetStormSongCasterLevel(oCaster);
		
		if (iCasterLevel < 13) //Short circuit
		{
			SendMessageToPC(OBJECT_SELF, "Insufficient Perform skill, you need 13 or more to use this ability.");
			return;
		}
		if (!GetHasFeat(257))
		{
			SpeakString("No uses of the Bard Song ability are available");
			return;
		}
		else
		{
			DecrementRemainingFeatUses(OBJECT_SELF, 257);		
		}
		
		
		int iDieSize = 6;
		int iMaxToHit = HkGetSpellPower( oCaster, 10, CLASS_STORMSINGER );
		
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
		//--------------------------------------------------------------------------
		//Declare major variables
		//--------------------------------------------------------------------------
		int iCasterLevel = GetStormSongCasterLevel(oCaster);
		
		if (iCasterLevel < 13) //Short circuit
		{
			SendMessageToPC(OBJECT_SELF, "Insufficient Perform skill, you need 13 or more to use this ability.");
			return;
		}
		if (!GetHasFeat(257))
		{
			SpeakString("No uses of the Bard Song ability are available");
			return;
		}
		else
		{
			DecrementRemainingFeatUses(OBJECT_SELF, 257);		
		}
			
		
		int iDamage;
		float fDelay;
		//--------------------------------------------------------------------------
		// Elemental Damage Modifiers
		//--------------------------------------------------------------------------
		int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
		//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
		int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
		int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
		
		//--------------------------------------------------------------------------
		// Effects
		//--------------------------------------------------------------------------	
	
		effect eVis = EffectVisualEffect(iHitEffect);
		effect eVis2 = EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING); //VFX_SPELL_HIT_CALL_LIGHTNING
		effect eDur = EffectVisualEffect(VFX_SPELL_DUR_CALL_LIGHTNING); //VFX_SPELL_DUR_CALL_LIGHTNING
		effect eLink = EffectLinkEffects(eVis, eVis2);
		effect eDam;
		//Get the spell target location as opposed to the spell target.
		location lTarget = HkGetSpellTargetLocation();
		//Limit Caster level for the purposes of damage
		if (iCasterLevel > 10)
		{
			iCasterLevel = 10;
		}
		//Declare the spell shape, size and the location.  Capture the first target object in the shape.
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, 1.75);
		//Cycle through the targets within the spell shape until an invalid object is captured.
		while (GetIsObjectValid(oTarget))
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
			{
			   //Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
				//Get the distance between the explosion and the target to calculate delay
				fDelay = CSLRandomBetweenFloat(0.4, 1.75);
				if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
					//Roll damage for each target
					iDamage = d6(iCasterLevel);
					//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType );
					//Set the damage effect
					eDam = EffectDamage(iDamage, iDamageType);
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
		   oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		}
    }
    HkPostCast(oCaster);
}
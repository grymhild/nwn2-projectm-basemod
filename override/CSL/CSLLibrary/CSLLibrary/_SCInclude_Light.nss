/** @file
* @brief Include File for Light and Darkness Effects
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/





/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCConstants"
//#include "_SCUtilityConstants"
// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"
#include "_HkSpell"
#include "_CSLCore_Environment"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////





/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////




// * this does the light dazzlement that some races suffer from in daylight, where it renders them immobilized for a duration
void SCApplyLightDazzlementEffect( object oTarget, object oCaster = OBJECT_SELF, float fDuration = 6.0f, int iDurationType = DURATION_TYPE_TEMPORARY )
{
	if ( CSLGetIsLightSensitiveCreature( oTarget ) ) // If they are light sensitive add in a dazed effect as well for a round
	{
		effect eDazzle = EffectAttackDecrease(1);
		eDazzle = EffectLinkEffects( eDazzle, EffectSkillDecrease( SKILL_SPOT, 1) );
		eDazzle = EffectLinkEffects( eDazzle, EffectSkillDecrease( SKILL_SEARCH, 1) );
		//Apply the VFX impact and damage effect
		HkApplyEffectToObject(iDurationType, eDazzle, oTarget, RoundsToSeconds(10));
	}
}

// * this does the light dazzlement that some races suffer from in daylight, where it renders them immobilized for a duration
void SCApplyLightStunEffect( object oTarget, object oCaster = OBJECT_SELF, float fDuration = 6.0f, int iDurationType = DURATION_TYPE_TEMPORARY )
{
	if ( CSLGetIsLightSensitiveCreature( oTarget ) ) // If they are light sensitive add in a dazed effect as well for a round
	{
		if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DAZED, oCaster ) ) // this is for if they are immune to mind affecting, this is not a mind affecting daze
		{
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDazed(), oTarget, fDuration );
		}
		else
		{
			HkApplyEffectToObject(iDurationType, EffectCutsceneParalyze(), oTarget, fDuration );
		}
	}
}

  
void SCApplyLightAtLocation( location lLocation, object oCaster = OBJECT_SELF, int iSpellId = SPELL_NONMAGICLIGHT, int iSpellPower = 0, int iSpellLevel = 0, float fDuration=0.0f, int iDurationType = DURATION_TYPE_PERMANENT, int iLightFX = VFX_DUR_LIGHT, int iAOE = AOE_MOB_LIGHT, float fRadius = 6.0f )
{
	if(!CSLEnviroGetIsHigherLevelDarknessEffectsInArea( lLocation, iSpellLevel, fRadius ) )
	{
		if ( CSLEnviroRemoveLowerLevelDarknessEffectsInArea( lLocation, iSpellLevel ) )
		{
			SendMessageToPC( oCaster, "The Dark Was Extinguished By The Light");
		}
		
		string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower,  -1.0f,FALSE  );
		
		// daylight does VFX_DUR_LIGHT_WHITE_20
		effect eLight = EffectVisualEffect(iLightFX);
		eLight = EffectLinkEffects(eLight, EffectAreaOfEffect(AOE_MOB_LIGHT, "", "", "", sAOETag) );
			
		ApplyEffectAtLocation( iDurationType, eLight, lLocation, fDuration );
	}
	else
	{
		SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Darkness");
	}
}

void SCApplyLightToObject( object oTarget, object oCaster = OBJECT_SELF, int iSpellId = SPELL_NONMAGICLIGHT, int iSpellPower = 0, int iSpellLevel = 0, float fDuration=0.0f, int iDurationType = DURATION_TYPE_PERMANENT, int iLightFX = VFX_DUR_LIGHT, int iAOE = AOE_MOB_LIGHT, float fRadius = 6.0f )
{
	if(!CSLEnviroGetIsHigherLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel, fRadius ) )
	{
		
		if ( CSLEnviroRemoveLowerLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel ) )
		{
			SendMessageToPC( oCaster, "The Dark Was Extinguished By The Light");
		}
		string sAOETag = HkAOETag( oCaster, iSpellId, iSpellPower,  -1.0f,FALSE  );
			
		effect eLight = EffectVisualEffect(iLightFX);
		eLight = EffectLinkEffects(eLight, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE) );
		eLight = EffectLinkEffects(eLight, EffectAreaOfEffect(AOE_MOB_LIGHT, "", "", "", sAOETag) );
		
		if ( iSpellId > -1 )
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
		}
		HkApplyTargetTag( oTarget, oCaster, iSpellId, 255, fDuration );
		ApplyEffectToObject( iDurationType, eLight, oTarget, fDuration );
	}
	else
	{
		SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Darkness");
	}
}
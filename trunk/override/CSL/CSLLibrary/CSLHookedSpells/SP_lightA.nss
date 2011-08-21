//::///////////////////////////////////////////////
//:: Light (Enter)
//:: NW_S0_Light.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Light
	Evocation [Light]
	Level:	Brd 0, Clr 0, Drd 0, Sor/Wiz 0
	Components:	V, M/DF
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	This spell causes an object to glow like a torch, shedding bright light
	in a 20-foot radius (and dim light for an additional 20 feet) from the
	point you touch. The effect is immobile, but it can be cast on a
	movable object. Light taken into an area of magical darkness does not
	function.
	
	A light spell (one with the light descriptor) counters and dispels a
	darkness spell (one with the darkness descriptor) of an equal or lower
	level.
	
	Arcane Material Component A firefly or a piece of phosphorescent moss.
	
	
	Applies a light source to the target for
	1 hour per level

	XP2
	If cast on an item, item will get temporary
	property "light" for the duration of the spell
	Brightness on an item is lower than on the
	continual light version.

*/

#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_LIGHT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 0;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_LIGHT, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//location lTarget 	= HkGetSpellTargetLocation();
	//int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	//int 	iMetamagic 	= HkGetMetaMagicFeat();
	//float 	fDuration 		= TurnsToSeconds(iCasterLevel*10);
	int iSaveDC = HkGetSpellSaveDC();

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	//effect eVis 	= EffectVisualEffect(VFX_DUR_LIGHT_WHITE_10);
	//effect eLightEffect 	= EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	//eLightEffect = EffectLinkEffects( eLightEffect, EffectSkillDecrease( SKILL_HIDE, 10 ) );
	effect eLightEffect = EffectSkillDecrease( SKILL_HIDE, 10 );
	//effect eLink 	= EffectLinkEffects(eVis, eDur);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(!CSLEnviroGetHasHigherLevelDarknessEffect(iSpellLevel, oTarget))
	{
		if ( CSLEnviroRemoveLowerLevelDarknessEffect(iSpellLevel, oTarget) )
		{
			SendMessageToPC( oTarget, "The Dark Was Extinguished By The Light");
		}

		if( CSLGetIsLightSensitiveCreature(oTarget) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			if ( !HkSavingThrow( SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_SPELL ) )
			{
				SCApplyLightStunEffect( oTarget, oCaster, RoundsToSeconds( 1 ) );
			}
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds( d4() ),-SPELL_LIGHT );
		}
		else
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
		}
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLightEffect, oTarget, 0.0f, -SPELL_LIGHT );

	}
}

//EffectSkillIncrease(SKILL_HIDE,2);
//eDazzle = EffectLinkEffects( eDazzle, EffectSkillDecrease( SKILL_HIDE, 10 ) );
//		eDazzle = EffectLinkEffects( eDazzle, EffectSkillDecrease( SKILL_SEARCH, 1) );
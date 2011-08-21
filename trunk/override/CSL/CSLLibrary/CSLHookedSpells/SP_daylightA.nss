//::///////////////////////////////////////////////
//:: Daylight (Enter)
//:: SP_daylightA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*

	Daylight
	Evocation [Light]
	Level:	Brd 3, Clr 3, Drd 3, Pal 3, Sor/Wiz 3
	Components:	V, S
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	
	The object touched sheds light as bright as full daylight in a 60-foot
	radius, and dim light for an additional 60 feet beyond that. Creatures
	that take penalties in bright light also take them while within the
	radius of this magical light. Despite its name, this spell is not the
	equivalent of daylight for the purposes of creatures that are damaged
	or destroyed by bright light.
	
	If daylight is cast on a small object that is then placed inside or
	under a light-proof covering, the spell’s effects are blocked until the
	covering is removed.
	
	Daylight brought into an area of magical darkness (or vice versa) is
	temporarily negated, so that the otherwise prevailing light conditions
	exist in the overlapping areas of effect.
	
	Daylight counters or dispels any darkness spell of equal or lower
	level, such as darkness.
*/

#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	
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
	effect eVis 	= EffectVisualEffect(VFX_DUR_LIGHT_WHITE_10);
	effect eDur 	= EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink 	= EffectLinkEffects(eVis, eDur);

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
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
			if ( !HkSavingThrow( SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_SPELL ) )
			{
				SCApplyLightStunEffect( oTarget, oCaster, RoundsToSeconds( 1 ) );
			}
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), oTarget);
		}
		else
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
		}
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);

	}
}

//::///////////////////////////////////////////////
//:: Deeper Darkness (OnEnter)
//:: sg_s0_deepdarkA.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation [Darkness]
	Level: Clr 3
	Components: V,S
	Casting Time: 1 action
	Range: Touch
	Target: Object touched
	Duration: 1 day (24 hours)/level
	Saving Throw: None
	Spell Resistance: No

	The spell causes the object touched to shed absolute
	darkness in a 60 foot radius. Even creatures who can
	normally see in the dark cannot see through this
	magical darkness.

	Deeper Darkness counters or dispels any light spell of
	equal or lower level, including Daylight or Light.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 4, 2004
//:://////////////////////////////////////////////
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
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_DARKNESS, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eInvis 	= EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
	effect eDark 	= EffectDarkness();
	effect eDur 	= EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink 	= EffectLinkEffects(eDark, eDur);

	effect eLink2 	= EffectLinkEffects(eInvis, eDur);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	
	
	if(!CSLEnviroGetHasHigherLevelDarknessEffect(iSpellLevel, oTarget))
	{
		if ( CSLEnviroRemoveLowerLevelLightEffect(iSpellLevel, oTarget) )
		{
			SendMessageToPC( oTarget, "The Light Was Extinguished By Darkness");
		}
	
		// * July 2003: If has darkness then do not put it on it again
		if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_DARKNESS ))
		{
			return;
		}
	
		//if(GetHasSpellEffect(SPELL_LIGHT,oTarget)) {
		//	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LIGHT );
		//}
		//if(GetHasSpellEffect(SPELL_DAYLIGHT, oTarget)) {
		//	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DAYLIGHT );
		//}
		//if(GetHasSpellEffect(SPELL_DAYLIGHT_CLERIC, oTarget)) {
		//	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_DAYLIGHT_CLERIC );
		//}
		if(GetIsObjectValid(oTarget) && oTarget != oCaster)
		{
			if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId()));
			}
			else
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId(), FALSE));
			}
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
		}
		else if (oTarget == oCaster)
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId(), FALSE));
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget );
		}
	}
	else
	{
		SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Light");
	}

}
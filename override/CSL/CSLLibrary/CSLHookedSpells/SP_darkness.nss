//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S0_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a globe of darkness around those in the area
	of effect.
	
	Darkness
	Evocation [Darkness]
	Level:	Brd 2, Clr 2, Sor/Wiz 2
	Components:	V, M/DF
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	This spell causes an object to radiate shadowy illumination out to a
	20-foot radius. All creatures in the area gain concealment (20% miss
	chance). Even creatures that can normally see in such conditions (such
	as with darkvision or low-light vision) have the miss chance in an area
	shrouded in magical darkness.
	
	Normal lights (torches, candles, lanterns, and so forth) are incapable
	of brightening the area, as are light spells of lower level. Higher
	level light spells are not affected by darkness.
	
	If darkness is cast on a small object that is then placed inside or
	under a lightproof covering, the spell’s effect is blocked until the
	covering is removed.
	
	Darkness counters or dispels any light spell of equal or lower spell
	level.
	
	Arcane Material Component A bit of bat fur and either a drop of pitch
	or a piece of coal.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
// ChazM 7/14/06 If cast on an object, signal the object cast on (needed for crafting)
//:: AFW-OEI 08/03/2007: Account for Assassins.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DARKNESS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	if ( GetSpellId() == SPELLABILITY_AS_DARKNESS )
	{
		iSpellId = SPELLABILITY_AS_DARKNESS;
	}
	else if ( GetSpellId() == SPELL_ASN_Darkness ||  GetSpellId() == SPELL_ASN_Spellbook_2  )
	{
		iSpellId = SPELL_ASN_Darkness;
		iClass = CLASS_TYPE_ASSASSIN;
	}
	else if ( GetSpellId() == SPELL_BG_Darkness )
	{
		iSpellId = SPELL_BG_Darkness;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	else if ( GetSpellId() == SPELL_SHADOW_CONJURATION_DARKNESS )
	{
		iSpellId = SPELL_SHADOW_CONJURATION_DARKNESS;
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	else if ( GetSpellId() == SPELL_MSE_DARKNESS || GetSpellId() == SPELL_MINOR_SHAD_EVOC )
	{
		iSpellId = SPELL_MSE_DARKNESS;
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = 2;
	int iImpactSEF = VFX_HIT_AOE_EVIL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DARKNESS, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	int iDuration = HkGetSpellDuration( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( iDuration ));
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS, "", "", "", sAOETag);
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	if(!CSLEnviroGetIsHigherLevelLightEffectsInArea( lImpactLoc, iSpellLevel ) )
	{
		if ( CSLEnviroRemoveLowerLevelLightEffectsInArea( lImpactLoc, iSpellLevel ) )
		{
			SendMessageToPC( oCaster, "The Light Was Extinguished By Darkness");
		}
		
		effect eImpactVis = EffectVisualEffect( iImpactSEF );
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	
		DelayCommand( 0.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lImpactLoc, fDuration) );
	}
	else
	{
		SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Light");
	}
	HkPostCast(oCaster);
}
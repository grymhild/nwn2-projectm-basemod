//::///////////////////////////////////////////////
//:: Blacklight
//:: sg_s0_blklight.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Blacklight
	Evocation [Darkness]
	Level:	Darkness 3, Sor/Wiz 3
	Components:	V, S, M
	Casting Time:	1 standard action
	Range:	Close (25 ft. + 5 ft./2 levels)
	Area:	A 20-ft.-radius emanation centered on a creature, object, or point in space
	Duration:	1 round/level (D)
	Saving Throw:	Will negates or none (object)
	Spell Resistance:	Yes or no (object)
	The caster creates an area of total darkness. The darkness is
	impenetrable to normal vision and darkvision, but the caster can see
	normally within the blacklit area. Creatures outside the spell’s area,
	even the caster, cannot see through it.
	
	The spell can be cast on a point in space, but the effect is stationary
	when cast on a mobile object. A character can cast the spell on a
	creature, and the effect then radiates from the creature and moves as
	it moves. Unattended objects and points in space do not get saving
	throws or benefit from spell resistance.
	
	Blacklight counters or dispels any light spell of equal or lower level.
	The 3rd-level cleric spell daylight counters or dispels blacklight.
    
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DARKNESS, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_PER_BLACKLIGHT, "", "", "", sAOETag);

    	
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
	
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lImpactLoc, fDuration);
    }
	else
	{
		SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Light");
	}
    HkPostCast(oCaster);
}
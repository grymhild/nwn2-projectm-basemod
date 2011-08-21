//::///////////////////////////////////////////////
//:: Stabilize
//:: NX2_S0_Stabilize.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 07/31/2008
//:://////////////////////////////////////////////
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(2.0 * RADIUS_SIZE_GARGANTUAN); // ~= 25.0 ft
	
	object oCreator = HkGetSpellTarget(); // hopefully OBJECT_SELF since this spell is a radius around you
	location lMyLocation = GetLocation( oCreator );
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fRadius, lMyLocation, TRUE ); // here we go!

	effect eImpactVis = EffectVisualEffect(VFX_FEAT_TURN_UNDEAD);	// no longer using NWN1 VFX
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lMyLocation);	// no longer using NWN1 VFX

	while( GetIsObjectValid(oTarget) )
	{
		if (!GetIsDead(oTarget, TRUE))
		{
			// they're alive
			if ( CSLGetIsUndead(oTarget, TRUE) )
			{
				// we don't like undead
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC()))
				{
					effect eDam = HkEffectDamage(1, DAMAGE_TYPE_POSITIVE);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
			}
			else // we're alive and NOT undead...
			{
				// This prevents the spell hemorage
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_HEMORRHAGE );
				CSLRemoveEffectTypeSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, EFFECT_TYPE_WOUNDING );
				
				effect eHeal = EffectHeal(1);
				effect eVFX 	= EffectVisualEffect(VFX_IMP_HEALING_S);
				effect eLink = EffectLinkEffects(eHeal, eVFX);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
		}
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lMyLocation, TRUE );

	}
}


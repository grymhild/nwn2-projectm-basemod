//::///////////////////////////////////////////////
//:: Ethereal Purge
//:: NW_S2_EthPurge.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Doomguide ability. At the 8th level, once per day
	the doomguide may surround himself with a sphere of
	power with a radius of 5 feet per class level that
	forces all ethereal creatures in the area to manifest
	themseves to the Material plane as appropriate.
	(Faith & Pantheons pg188)

	Note we don't have Etherealness, but we do have concealment.
	This ability has been adapted to negate concealment for
	1 min/level on any creatures within the radius.
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 05/30/2008
//:://////////////////////////////////////////////
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "ginc_debug"


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
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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

	int nDoomguideLevel = GetLevelByClass(CLASS_TYPE_DOOMGUIDE);
	int nWisMod = GetAbilityModifier(ABILITY_WISDOM);

	// basic variables for spell
	// radius is based on level 5* Doomguide class level
	float fSize = nDoomguideLevel * RADIUS_SIZE_SMALL; // RADIUS_SIZE_SMALL ~5ft
	location lMyLocation = GetLocation( OBJECT_SELF );
	float fDuration = 60.0 * nDoomguideLevel;
	int nDC = (nDoomguideLevel/2) + 10 + nWisMod;

	// visual effect
	effect eImpactVis = EffectVisualEffect(VFX_AOE_ETHEREAL_PURGE);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lMyLocation);

	// actual effect
	effect eNegConceal = EffectConcealmentNegated();

	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
	while( oTarget != OBJECT_INVALID )
	{
		// only apply effect to enemies in the radius, not self of allies :D
		if( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF )
		{
			//SpeakString("Attempting Will Save For :"+GetName(oTarget));
			// attempt Will Save
			if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC))
			{
				// apply effect
				//	SpeakString("Applying Ethereal Purge to "+GetName(oTarget));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegConceal, oTarget, fDuration);
				CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId, SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY );
			}
		}
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
	}
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Animal Trance
//:: nw_s0_animaltrance.NSS
//:: Copyright (c) 2008 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Fascinates nearby animals.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
// JWR-OEI 07/02/2008
// RPGplayer1 11/22/2008: Added support for metamagic
#include "_HkSpell"

//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "ginc_debug"
//#include "nwn2_inc_spells"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_ANIMAL_TRANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	// initial main variables
	int nTotalHD = d6(2); 													// total number of HD we can 'mesmerize'
	nTotalHD = HkApplyMetamagicVariableMods(nTotalHD, 12);
	int nCurrHD = 0;														// how many HD we turned so far
	int nTotalLevels = HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); //GetTotalLevels(oCaster, FALSE);					// total levels of caster												
	float fSize = 25.0 + (5.0 * (nTotalLevels/2));							// how big of radius we affect
	fSize = fSize * (RADIUS_SIZE_GARGANTUAN/25.0);
	effect eMes;															// mesmerize effect
	int nDur = 1 * nTotalLevels;
	//if it returns valid class, use caster level (it's a spell, not racial ability)
	if (GetLastSpellCastClass() != CLASS_TYPE_INVALID)
	{
		nDur = GetCasterLevel(OBJECT_SELF);
	}

										// # of rounds effect lasts
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(nDur));
	int nInt;
	int iHD;
	effect eVFX, eLink;
	
	// debug
	//PrettyDebug("Starting Animal Trance!! Total HD: "+IntToString(nTotalHD));

	
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSize, HkGetSpellTargetLocation());
	
	while( GetIsObjectValid( oTarget ) )
	{
		
		// loop through all the objects inside the sphere
		// check conditionals
		if ( CSLGetIsAnimalOrBeast(oTarget) )
		{
			nInt = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
			iHD = GetHitDice(oTarget);
			// only applies to creatures with low intelligence
			if ( nInt < 3 && (nCurrHD + iHD) <= nTotalHD )
			{
				if ( !HkResistSpell( oCaster, oTarget ) )
				{
					//PrettyDebug("Animal Trance :: Applying Effect to "+GetName(oTarget));
					// apply effect
					eMes = EffectMesmerize(MESMERIZE_BREAK_ON_ATTACKED);
					eVFX = EffectVisualEffect(VFX_HIT_TURN_UNDEAD);
					eLink = EffectLinkEffects(eVFX, eMes); 
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration /*RoundsToSeconds(nDur)*/);
					nCurrHD += iHD;
				}
			}
		}
		// get next object
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSize, HkGetSpellTargetLocation());
	}
	
	HkPostCast(oCaster);
}


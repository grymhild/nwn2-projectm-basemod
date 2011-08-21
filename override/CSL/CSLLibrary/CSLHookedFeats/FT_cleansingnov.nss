//::///////////////////////////////////////////////
//:: Feat: Cleansing Nova
//:: nw_s2_clnsnova.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	A persistent, immobile cylinder of light that
	inflicts 20 holy damage per round to any
	undead or outsiders in it.  No save, but spell
	resistance.
	
	BDF-EDIT: this feat is no longer a persistent AOE
	and instead is an instant AOE that causes
	1 point of fire damage per character level
	for 4 seconds to everyone in its area of effect.
	Additionally, if any target of the Cleansing Nova
	is also currently under the effects of Web of
	Purity, then ALL creatures that are under the
	effects of WoP will suffer the same effects from
	CN.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 04/24/2006
//:://////////////////////////////////////////////
//:: Modified By: Brian Fox (BDF-OEI)
//:: Modified On: 08/30/2006
//:://////////////////////////////////////////////

#include "_HkSpell" 
#include "_HkSpell"

const float CLEANSING_NOVA_RADIUS_SIZE = RADIUS_SIZE_LARGE;
const int NUM_CLEANSING_NOVA_IMPACTS = 4;

int GetIsValidNovaTarget( object oTarget )
{
	if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	{
		int nRacialType = GetRacialType(oTarget);
		
		if ( CSLGetIsUndead( oTarget ) || // Only target Undead OR Outsiders
			nRacialType == RACIAL_TYPE_OUTSIDER )
			return TRUE;
	}

	return FALSE;
}

void ApplyCleansingNovaEffects( effect eEffect, object oTarget, int iDurationType = DURATION_TYPE_INSTANT, int nNumImpacts = NUM_CLEANSING_NOVA_IMPACTS )
{
	float fDelay;
	int i;
	
	for ( i = 0; i < nNumImpacts; i++ )
	{
		if ( GetIsDead(oTarget) ) return;
		
		fDelay = IntToFloat(i);
		DelayCommand( fDelay, HkApplyEffectToObject(iDurationType, eEffect, oTarget) );
	}
}

int HandleWebOfPurityVictims( effect eEffect, int iDurationType = DURATION_TYPE_INSTANT, int nNumImpacts = NUM_CLEANSING_NOVA_IMPACTS )
{
	int nCounter = 1;
	object oWebbed = GetNearestCreature( CREATURE_TYPE_HAS_SPELL_EFFECT, 948, OBJECT_SELF, nCounter++ ); // 948 = SPELLABILITY_WEB_OF_PURITY
	
	while (GetIsObjectValid(oWebbed) )
	{
			ApplyCleansingNovaEffects( eEffect, oWebbed, iDurationType, nNumImpacts );
		
		oWebbed = GetNearestCreature( CREATURE_TYPE_HAS_SPELL_EFFECT, 948, OBJECT_SELF, nCounter++ ); // 948 = SPELLABILITY_WEB_OF_PURITY
	}
	
	return TRUE;
}

void main()
{
	//scSpellMetaData = SCMeta_FT_cleansingnov();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	//Declare major variables
	int    iCasterLevel = HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); // GetTotalLevels( oCaster, TRUE );
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_HIT_CLEANSING_NOVA, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDam = EffectDamage( iCasterLevel, iDamageType ); // Nova damage = character level
	//object oTarget = HkGetSpellTarget();
	location lTarget = HkGetSpellTargetLocation();
	int bWebVictimsHandled = FALSE;
	effect eImpact = EffectVisualEffect( iShapeEffect );
	
	HkApplyEffectAtLocation( DURATION_TYPE_INSTANT, eImpact, lTarget );
	
	//Declare and assign personal impact visual effect.
	effect eVis = EffectVisualEffect( iHitEffect ); //
	effect eLink = EffectLinkEffects( eDam, eVis );
	
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, CLEANSING_NOVA_RADIUS_SIZE, lTarget );
	
	// string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	
	while ( GetIsObjectValid(oTarget) )
	{
			//Fire cast spell at event for the specified target
			SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELLABILITY_CLEANSING_NOVA) );

		if ( GetIsValidNovaTarget(oTarget) )
		{
				//Make SR check.
				if ( !HkResistSpell(oCaster, oTarget) )
				{
				if ( GetHasSpellEffect(948, oTarget) && !bWebVictimsHandled ) // 948 = SPELLABILITY_WEB_OF_PURITY
				{
					bWebVictimsHandled = HandleWebOfPurityVictims( eLink );
				}
				else if ( !GetHasSpellEffect(948, oTarget) )
				{
						// Apply effects to the currently selected target.
						ApplyCleansingNovaEffects( eLink, oTarget, DURATION_TYPE_INSTANT, NUM_CLEANSING_NOVA_IMPACTS );
				}
				}
		}

		oTarget = GetNextObjectInShape( SHAPE_SPHERE, CLEANSING_NOVA_RADIUS_SIZE, lTarget );
	}
	
	// The code below represents this feat's original implementation and is preserved for reference
/*
	// Declare Area of Effect object using the appropriate constant
	effect eAOE = EffectAreaOfEffect(AOE_PER_CLEANSING_NOVA, "", "", "", sAOETag);
	
	// Get the location where the cylinder is to be placed
	location lTarget = HkGetSpellTargetLocation();

	float fDuration = RoundsToSeconds(5); // Spell duration if fixed to 5 rounds

	// Create the Area of Effect Object declared above.
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
*/
	HkPostCast(oCaster);
}
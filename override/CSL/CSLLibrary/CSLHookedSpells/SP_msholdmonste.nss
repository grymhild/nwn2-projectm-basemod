//:://////////////////////////////////////////////////////////////////////////
//:: Level 7 Arcane Spell: Mass Hold Monster
//:: nw_s0_mshldmon.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 10/07/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
			Mass Hold Person
			PHB, pg. 241

			School: Evocation
			Components: Verbal, Somatic
			Range: Medium
			Target: All targets within a 30 ft. radius
			Duration: 1 round / level
			Saving Throw: Will negates
			Spell Resist: Yes

			Paralyzes all targets that fail their saves. Each round targets
			can try and make a new save.

*/
//:://////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
 






void HoldTarget( object oTarget, float fDuration, int iSaveDC );


void main()
{
	//scSpellMetaData = SCMeta_SP_msholdmonste();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_HOLD_MONSTER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


// SpawnScriptDebugger();

	//Declare major variables
	location locTarget = HkGetSpellTargetLocation();
	
	//int nRounds = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster );
	int iSaveDC = HkGetSpellSaveDC();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fRadius, locTarget );
	while (GetIsObjectValid(oTarget) )
	{
		if ( TRUE == CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster ) )
		{
			float fDuration = RoundsToSeconds( HkGetScaledDuration(iDuration, oTarget) );
			fDuration = HkApplyMetamagicDurationMods(fDuration);
			HoldTarget( oTarget, fDuration, iSaveDC );
		}

			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, locTarget );
	}
	HkPostCast(oCaster);
}



void HoldTarget( object oTarget, float fDuration, int iSaveDC)
{

	effect eParal = EffectParalyze(iSaveDC, SAVING_THROW_WILL);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_HOLD_MONSTER );
	eParal = EffectLinkEffects( eParal, eVis );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_PERSON));

	float fDelay = CSLRandomBetweenFloat( 0.25, 1.25 );

	//Make SR Check
	if ( HkResistSpell(OBJECT_SELF, oTarget, fDelay) == 0 )
	{
		//Make Will save
		if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
		{
			//Apply paralyze effect and VFX impact

			DelayCommand( fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, fDuration ) );
			//DelayCommand( fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		}
	}
	
}


//::///////////////////////////////////////////////
//:: Cacophonic Burst
//:: NX_s0_cacburst.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Cacophonic Burst
	Evocation [Sonic]
	Level: Bard 5, sorceror/wizard 5
	Components: V,S
	Range: Long
	Area: 20 ft. radius
	Saving Throw: Reflex half
	Spell Resistance: Yes
	
	You create a burst of low, discordant noise to
	erupt at the chosen location.  It deals 1d6 points
	of sonic damage per caster level (maximum 15d6)
	to all creatures within the area.
	
	NOTE: The rule stating that this spell cannot penetrate
	the silence spell is omitted because it's really hard
	to do that and none of our other sonic spells use this rule.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"






void main()
{
	//scSpellMetaData = SCMeta_SP_cacophonicbu();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CACOPHONIC_BURST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;	
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster, 15 );
	int iDamage;
	float fDelay;
	
	location lTarget = HkGetSpellTargetLocation();
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);	
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	int iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_HUGE_SONIC, SC_SHAPE_AOEEXPLODE, oCaster, fRadius );
	int iHitEffect = HkGetHitEffect( VFX_COM_HIT_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eHitEffect = EffectVisualEffect(iHitEffect);
	effect eDam;
	effect eImpactVis = EffectVisualEffect( iShapeEffect );
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CACOPHONIC_BURST, TRUE));
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20.0;
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{
				iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
				if ( iDamageType == DAMAGE_TYPE_SONIC && GetHasSpellEffect(FEAT_LYRIC_THAUM_SONIC_MIGHT,OBJECT_SELF))
				{
					iDamage += d6(5);		
				}
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType );
				if (iDamage)
				{
					eDam = HkEffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHitEffect, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

//::///////////////////////////////////////////////
//:: Sunburst
//:: X0_S0_Sunburst
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Brilliant globe of heat
// All creatures in the globe are blinded and
// take 6d6 damage
// Undead creatures take 1d6 damage per level (max 25d6)
// The blindness is permanent unless cast to remove it
// Light sensitive creatures are dazed by the effect
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Light"

void main()
{
	//scSpellMetaData = SCMeta_SP_sunburst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SUNBURST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DIVINE|SCMETA_DESCRIPTOR_LIGHT, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower(oCaster, 25);   //Limit Caster level for the purposes of damage, only affects undead
	int iDamage = 0;
	int nOrgDam = 0;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iImpactEffect = HkGetShapeEffect( VFX_FNF_SUNBEAM, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eExplode = EffectVisualEffect( iHitEffect );
	effect eHitVis = EffectVisualEffect( VFX_HIT_SPELL_HOLY );
	effect eDam;
	location lTarget = HkGetSpellTargetLocation();
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), HkGetSpellTargetLocation());
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SUNBURST));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHitVis, oTarget);
			if (!HkResistSpell(oCaster, oTarget, 0.0))
			{
				if ( CSLGetIsUndead( oTarget ) || CSLGetIsOoze( oTarget ) )
				{
					nOrgDam = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
				}
				else
				{
					nOrgDam = HkApplyMetamagicVariableMods(d6(6), 36 );
				}
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nOrgDam, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_SPELL);
				// * if vampire destroy it
				if (!GetLocalInt(oTarget, "BOSS") && CSLGetIsSunDamagedCreature(oTarget) )
				{
					if (iDamage==nOrgDam || ( iDamage > 0 && GetHasFeat(FEAT_IMPROVED_EVASION, oTarget) ) )
					{
						iDamage = GetCurrentHitPoints(oTarget);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oTarget);
					}
				}
				if (iDamage)
				{
					eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
					DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					if ( iDamage==nOrgDam || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget) )
					{
						SCApplyLightStunEffect( oTarget, oCaster, RoundsToSeconds(1) );
						HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectBlindness(), oTarget);
					}
					else if ( CSLGetIsLightSensitiveCreature( oTarget ) ) // they saved, if light sensitive they are blind anyway for a round
					{
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(1) );
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	HkPostCast(oCaster);
}
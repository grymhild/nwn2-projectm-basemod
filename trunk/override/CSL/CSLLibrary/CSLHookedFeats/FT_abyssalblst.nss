//::///////////////////////////////////////////////
//:: Abyssal Blast
//:: nx_s0_abyssal_blast.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Death Knights can cast an infernal fireball called Abyssal Blast.
	It functions like a combination of the fireball and flamestrike
	spells, exploding in a sphere which does half fire damage and half
	divine damage. It deals 1d6 points of damage per HD of the death knight
	(maximum 20d6), and a Reflex save (DC 10 + 1/2 the death knight's HD +
	death knight's CHA modifier) is allowed for half damage.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_FT_abyssalblst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = HkGetSpellPower( oCaster, 20, CLASS_TYPE_RACIAL ); // OldGetCasterLevel(oCaster);
	int nFireDamage;
	int nDivineDamage;
	int iSaveDC = 10 + iSpellPower/2 + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	// iSpellPower = CSLGetMin(20, iSpellPower);
	float fDelay;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	int iImpactEffect = HkGetShapeEffect( VFX_FNF_FIREBALL, SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eFireVis = EffectVisualEffect( iHitEffect );
	effect eDivineVis = EffectVisualEffect(VFX_HIT_SPELL_FLAMESTRIKE);
	effect eFireDam;
	effect eDivineDam;
	effect eLink;
	location lTarget = HkGetSpellTargetLocation();
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE)); // hostile spell
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20.0;
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{
				nDivineDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,d3(iSpellPower), oTarget, iSaveDC, SAVING_THROW_TYPE_DIVINE);
				nFireDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,d3(iSpellPower), oTarget, iSaveDC, iSaveType);
				if (nFireDamage || nDivineDamage) 
				{
					eLink = EffectDamage(nFireDamage, iDamageType);
					eLink = EffectLinkEffects(eLink, eFireVis);
					eLink = EffectLinkEffects(eLink, EffectDamage(nDivineDamage, DAMAGE_TYPE_DIVINE));
					eLink = EffectLinkEffects(eLink, eDivineVis);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget ));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	HkPostCast(oCaster);
}


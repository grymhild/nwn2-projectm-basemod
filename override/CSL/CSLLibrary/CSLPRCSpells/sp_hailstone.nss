//#include "spinc_common"


#include "_HkSpell"
#include "_CSLCore_Combat"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HAIL_OF_STONE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = HkGetSpellTargetLocation();

	// Apply area vfx.
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT,
		EffectVisualEffect(VFX_COM_CHUNK_STONE_SMALL), lTarget);
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT,
		EffectVisualEffect(356 /*VFX_FNF_SCREEN_SHAKE2*/), lTarget);

	float fDelay;

	// Determine damage dice.
	int nCasterLvl = HkGetCasterLevel();
	int nDice = nCasterLvl;
	if (nDice > 5) nDice = 5;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_SMALL);
	
	// Declare the spell shape, size and the location. Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	int nTargets = 0;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE,
		OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oTarget))
	{
		fDelay = CSLGetSpellEffectDelay(lTarget, oTarget);
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			// Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

			if (!HkResistSpell(OBJECT_SELF, oTarget ))
			{
				// Make touch attack, saving result for possible critical
				int iTouch = CSLTouchAttackRanged(oTarget);
				if (iTouch != TOUCH_ATTACK_RESULT_MISS )
				{
					// Roll the damage of (1d6+1) / level, doing double damage on a crit.
					int iDamage = HkApplyMetamagicVariableMods(d4(nDice), 4*nDice);
					iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
		
					// iDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);

					// Apply the damage and the damage visible effect to the target.
					ApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING), oTarget);
					//PRCBonusDamage(oTarget);
//TODO: need VFX
// 					HkApplyEffectToObject(DURATION_TYPE_INSTANT,
// 						EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
				}
			}
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE,
			OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

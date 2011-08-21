//#include "spinc_common"
// changed to astronomic, was 30.0f

#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SINSABURS_BALEFUL_BOLT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	// Set the lightning stream to start at the caster's hands
	effect eBolt = EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_HAND);
	effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

	object oTarget = HkGetSpellTarget();
	location lTarget = GetLocation(oTarget);
	object oNextTarget, oTarget2;
	float fDelay;
	int nCnt = 1;

	// Calculate bonus damage to the str/con drain.
	int nCasterLevel = HkGetCasterLevel();
	int nBonusDam = nCasterLevel / 4;
	if (nBonusDam > 3) nBonusDam = 3;
	//int nPenetr = nCasterLevel + SPGetPenetr();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_ASTRONOMIC);
	
	oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
	while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
	{
		//Get first target in the lightning area by passing in the location of first target and the casters vector (position)
		oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
		while (GetIsObjectValid(oTarget))
		{
			// Exclude the caster from the damage effects
			if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
			{
			if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE);

					//Make an SR check
					if (!HkResistSpell(OBJECT_SELF, oTarget ))
					{
						// Roll the drain damage and adjust for a reflex save/evasion.
						int nDamage = HkApplyMetamagicVariableMods(d3(1)+nBonusDam*3,3+nBonusDam*3);
						//nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
						nDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nDamage, oTarget, HkGetSpellSaveDC(oTarget,OBJECT_SELF), SAVING_THROW_TYPE_NEGATIVE);

						// Apply str/con drain if any.
						/*
						if(nDamage > 0)
						{
							int i;
							for (i = 1; i <= nDamage; i++)
							{
								/*effect eDamage = SupernaturalEffect(EffectAbilityDecrease(ABILITY_STRENGTH, nDamage));
								eDamage = EffectLinkEffects(eDamage,
									SupernaturalEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, nDamage)));*/

								// Recovery is supposed to be 1 pt / day, so apply each point
								// individually to make them last the full day.
								/*HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oTarget,
									HoursToSeconds(24) * i,TRUE,-1,nCasterLevel);*/
								//------------------------------------------------------------------
								// The trick that allows this spellscript to do stacking ability
								// score damage (which is not possible to do from normal scripts)
								// is that the ability score damage is done from a delaycommanded
								// function which will sever the connection between the effect
								// and the SpellId
								//------------------------------------------------------------------
								/*
								DelayCommand(0.01f, SCApplyAbilityDrainEffect( ABILITY_STRENGTH, 	1, oTarget, DURATION_TYPE_TEMPORARY, HoursToSeconds(24) * i));
								DelayCommand(0.01f, SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, 1, oTarget, DURATION_TYPE_TEMPORARY, HoursToSeconds(24) * i));
							}

							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						}*/

						SCApplyAbilityDrainEffect( ABILITY_STRENGTH, oTarget, nDamage, DURATION_TYPE_TEMPORARY, -1.0);
						SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, oTarget, nDamage, DURATION_TYPE_TEMPORARY, -1.0);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					}

					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0,-2);

					// Set the currect target as the holder of the lightning effect
					oNextTarget = oTarget;
					eBolt = EffectBeam(VFX_BEAM_BLACK, oNextTarget, BODY_NODE_CHEST);
				}
			}

			//Get the next object in the lightning cylinder
			oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
		}

		nCnt++;
		oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

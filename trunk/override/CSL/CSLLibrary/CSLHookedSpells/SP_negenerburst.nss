//::///////////////////////////////////////////////
//:: Negative Energy Burst
//:: SOZ UPDATE BTM
//:: NW_S0_NegBurst
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster releases a burst of negative energy
    at a specified point doing 1d8 + 1 / level
    negative energy damage.

    Reeron modified on 1-18-08
    Spell was enabled. Added a visual effect for the 
    strength-drain that gets applied to non-undead.
    
    Reeron modified on 1-19-08
    Added feedback if target is immune to strength-drain effect.
    Capped at 20 levels.
    
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 13, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_NEGATIVE_ENERGY_BURST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster, 20 );
    int iDamage;
    float fDelay;
    float fDelay2;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	int iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_HUGE_NEGATIVE, SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); 
	int iHitEffect = HkGetHitEffect( VFX_IMP_NEGATIVE_ENERGY );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	int iSave, iAdjustedDamage, iDC;
				
				
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eExplode = EffectVisualEffect(iShapeEffect); //Replace with Negative Pulse
    effect eVis = EffectVisualEffect(iHitEffect);
    effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eDam, eHeal;
    int nStr = iSpellPower / 4;
    if (nStr == 0)
    {
        nStr = 1;
    }
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
    effect eStr_Low = EffectAbilityDecrease(ABILITY_STRENGTH, nStr);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur3 = EffectVisualEffect( VFX_DUR_SPELL_RAY_ENFEEBLE );
    
    effect eGood = EffectLinkEffects(eStr, eDur);
    effect eBad = EffectLinkEffects(eStr_Low, eDur2);

    //Get the spell target location as opposed to the spell target.
    location lTarget = HkGetSpellTargetLocation();
    //Apply the explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    
    
    while (GetIsObjectValid(oTarget))
    {
		//Get the distance between the explosion and the target to calculate delay
		

		// * any undead should be healed, not just Friendlies
		if ( CSLGetIsUndead(oTarget) )
		{
			iDamage = HkApplyMetamagicVariableMods( d8() + iSpellPower , 8 + iSpellPower);
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			//Set the heal effect
			eHeal = EffectHeal(iDamage);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
			//This visual effect is applied to the target object not the location as above.  This visual effect
			//represents the flame that erupts on the target not on the ground.
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eGood, oTarget));
		}
		else if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
			if(!HkResistSpell(oCaster, oTarget, fDelay))
			{
				fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
				
				iDC = HkGetSpellSaveDC(oCaster, oTarget);
				iSave = HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, iSaveType, oCaster, fDelay);
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_WILL, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, iSaveType, oCaster, iSave, fDelay );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					iDamage = HkApplyMetamagicVariableMods( d8() + iSpellPower , 8 + iSpellPower);
					//if(HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), iSaveType, oCaster, fDelay))
					//{
					//	iDamage /= 2;
					//}
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORPARTIALDAMAGE, iDamage, oTarget, iDC, iSaveType, oCaster, iSave, fDelay );
				
					//Set the damage effect
					eDam = HkEffectDamage(iDamage, iDamageType);
					// Apply effects to the currently selected target.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					//This visual effect is applied to the target object not the location as above.  This visual effect
					//represents the flame that erupts on the target not on the ground.
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBad, oTarget));
					if (!GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE, oCaster))
					{
						DelayCommand(fDelay  + 1.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDur3, oTarget));
					}
					else
					{
						FloatingTextStringOnCreature("Target is Immune to Strength-drain!", oTarget, TRUE, 2.0f);
					}
				}
			}
		}
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    }
    HkPostCast(oCaster);
}
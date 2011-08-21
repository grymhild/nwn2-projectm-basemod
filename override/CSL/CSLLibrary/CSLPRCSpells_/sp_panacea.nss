/*
	nw_s0_remeffect

	Takes the place of
		Remove Disease
		Neutralize Poison
		Remove Paralysis
		Remove Curse
		Remove Blindness / Deafness

		Lesser Restoration
		Restoration
		Greater Restoration

		Panacea

	By: Preston Watamaniuk
	Created: Jan 8, 2002
	Modified: Jun 16, 2006

	Flaming_Sword: Added Restoration spells, cleaned up
	added panacea, attack roll before SR check
*/
//#include "prc_sp_func"

#include "_HkSpell"
#include "_CSLCore_Combat"

int GetIsSupernaturalCurse(effect eEff)
{
	return GetTag(GetEffectCreator(eEff)) == "q6e_ShaorisFellTemple";
}

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	

	return iTouch; 	//return TRUE if spell charges should be decremented
}*/




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PANACEA; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	SpellRemovalCheck(oCaster, oTarget);
	int nVis;
	int iAdjustedDamage;
	int iAttackRoll = TRUE;
	switch(iSpellId)
	{ 	//Setting visual effect
		case SPELL_GREATER_RESTORATION: nVis = VFX_IMP_RESTORATION_GREATER; break;
		case SPELL_RESTORATION: nVis = VFX_IMP_RESTORATION; break;
		case SPELL_LESSER_RESTORATION: nVis = VFX_IMP_RESTORATION_LESSER; break;
		default: nVis = VFX_IMP_REMOVE_CONDITION; break;
	}
	if(iSpellId == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS)
	{ 	//Remove Blindness and Deafness aoe hack largely untouched
		effect eLink;
		spellsGenericAreaOfEffect(OBJECT_SELF, HkGetSpellTargetLocation(), SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,
			SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), eLink, EffectVisualEffect(nVis),
			DURATION_TYPE_INSTANT, 0.0,
			SCSPELL_TARGET_ALLALLIES, FALSE, TRUE, EFFECT_TYPE_BLINDNESS, EFFECT_TYPE_DEAF);
		return TRUE;
	}
	effect eEffect = GetFirstEffect(oTarget);
	if(!((iSpellId == SPELL_PANACEA) && (CSLGetIsUndead( oTarget ))))
	{
		while(GetIsEffectValid(eEffect))
		{ 	//Effect removal - see prc_sp_func for list of effects removed
			if(CheckRemoveEffects(iSpellId, GetEffectType(eEffect)) && !GetIsSupernaturalCurse(eEffect))
				RemoveEffect(oTarget, eEffect);
			eEffect = GetNextEffect(oTarget);
		}
	}
	if(iSpellId == SPELL_GREATER_RESTORATION &&  !CSLGetIsUndead( oTarget ) )
	{ 	//Greater Restoration healing
		int nHeal = 10 * nCasterLevel;
		if(nHeal > 250 && !CSLGetPreferenceSwitch(PRC_BIOWARE_GRRESTORE))
			nHeal = 250;
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
		SetLocalInt(oTarget, "WasRestored", TRUE);
		DelayCommand(HoursToSeconds(1), DeleteLocalInt(oTarget, "WasRestored"));
	}
	if(iSpellId == SPELL_PANACEA)
	{
		int nAdd = (nCasterLevel > 20) ? 20 : nCasterLevel;
		if(CSLGetIsUndead( oTarget ) && (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);
			if (!HkResistSpell(oCaster, oTarget ))
			{
				int iTouch = CSLTouchAttackMelee(oTarget);
				if (iTouch != TOUCH_ATTACK_RESULT_MISS )
				{
					// Roll the damage (allowing for a critical) and let the target make a will save to
					// halve the damage.
					int iDamage = HkApplyMetamagicVariableMods(d8(1),8)+nAdd;
					iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
					
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(oTarget,OBJECT_SELF), SAVING_THROW_TYPE_NONE, oCaster, SAVING_THROW_RESULT_ROLL );

					/*
					if (HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(oTarget,OBJECT_SELF)))
					{
						nDamage /= 2;
						if (GetHasMettle(oTarget, SAVING_THROW_WILL)) nDamage = 0;
					}
					*/
					// Apply damage and VFX.
					if ( nDamage > 0 )
					{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_POSITIVE), oTarget);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTarget);
					}
				}
			}
		}
		else
		{
			// Roll the healing 'damage'.
			int nHeal = HkApplyMetamagicVariableMods(d8(1),8)+nAdd;
			// Apply the healing and VFX.
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oTarget);
		}
	}
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), oTarget);
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
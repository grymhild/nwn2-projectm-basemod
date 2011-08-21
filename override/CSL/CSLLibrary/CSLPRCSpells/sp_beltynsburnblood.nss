//#include "spinc_common"
//#include "x2_i0_spells"

#include "_HkSpell"

//
// This function runs the burning blood effect for a round, then recursing itself one
// round later to do the effect again. It relies on a dummy visual effect to act
// as the spell's timer, expiring itself when the effect expires.
//
void RunSpell(object oCaster, object oTarget, int nMetaMagic, int nSpellID,
	float fDuration,int nCasterLvl )
{
	// If our timer spell effect has worn off (or been dispelled) then we are
	// done, just exit.
	if ( !GetIsObjectValid(oTarget) || GetIsDead(oTarget) || !GetHasSpellEffect(nSpellID, oTarget) )
	{
		return;
	}
	
	// If the target is dead then there is no point in going any further.
	if (GetIsDead(oTarget)) return;

	if (HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(oTarget,oCaster), SAVING_THROW_TYPE_SPELL))
	{
		// Give feedback that a save was made.
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE), oTarget);
	}
	else
	{
		// The bad thing happens, 1d8 acid and fire damage, and slowed for 1 round.
		int nDamage = HkApplyMetamagicVariableMods( d8(),8);
		effect eDamage = HkEffectDamage(nDamage, DAMAGE_TYPE_FIRE);
		eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_FLAME_S));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		//PRCBonusDamage(oTarget);

		nDamage = HkApplyMetamagicVariableMods( d8(),8);
		//nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
		eDamage = HkEffectDamage(nDamage, DAMAGE_TYPE_ACID);
		eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_ACID_S));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

		eDamage = EffectSlow();
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oTarget, RoundsToSeconds(1),-2);
	}

	// Decrement our duration counter by a round and if we still have time left keep
	// going.
	fDuration -= RoundsToSeconds(1);
	if (fDuration > 0.0)
	{
		DelayCommand(RoundsToSeconds(1), RunSpell(oCaster, oTarget, nMetaMagic, nSpellID, fDuration,nCasterLvl));
	}
}





void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BELTYNS_BURNING_BLOOD; // put spell constant here
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
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	object oTarget = HkGetSpellTarget();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);

		// Get the target and raise the spell cast event.
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

		if (!HkResistSpell(OBJECT_SELF, oTarget ))
		{
			// Apply a persistent vfx to the target.
			// RunSpell uses our persistant vfx to determine it's duration.
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,
				EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, fDuration,FALSE);

			// Stick OBJECT_SELF into a local because it's a function under the hood,
			// and we need a real object reference.
			object oCaster = OBJECT_SELF;
			DelayCommand(0.5, RunSpell(oCaster, oTarget, HkGetMetaMagicFeat(), HkGetSpellId(), fDuration,nCasterLvl));
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

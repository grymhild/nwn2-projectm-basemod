/////////////////////////////////////////////////////////////////////
//
// Slashing Darkness - Project a damaging ray of negative energy.
//
/////////////////////////////////////////////////////////////////////
//::Added hold ray functionality - HackyKid
//#include "spinc_common"
//#include "prc_sp_func"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary

#include "_HkSpell"
#include "_CSLCore_Combat"
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	

	return iAttackRoll; 	//return TRUE if spell charges should be decremented
}
*/




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SLASHING_DARKNESS; // put spell constant here
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
	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC = HkGetSpellSaveDC(oTarget, oCaster);
	//int nPenetr = nCasterLevel + SPGetPenetr();

	int nDice = (nCasterLevel + 1) / 2;
	if (nDice > 5) nDice = 5;

	// Adjust the damage type if necessary.
	int nDamageType = HkGetDamageType(DAMAGE_TYPE_NEGATIVE, OBJECT_SELF);

	int iAttackRoll = 0;

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);


		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,
		EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_HAND, 0 == iAttackRoll), oTarget, 1.0,FALSE);

		int iTouch = CSLTouchAttackRanged(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				int iDamage = HkApplyMetamagicVariableMods(d8(nDice), 8 * nDice );
				iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
		
				// Apply the damage and the vfx to the target.
				//iDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
				effect eEffect = CSLGetIsUndead(oTarget) ? EffectHeal(iDamage) : HkEffectDamage(iDamage, nDamageType);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
				//PRCBonusDamage(oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oTarget);
			}
		}
	}
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
/////////////////////////////////////////////////////////////////////
//
// Burning Bolt, fires 1 rta fire bolt doing 1d4+1 damage, +1 bolt
// for ever 2 levels above first.
//
/////////////////////////////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_inc_sp_tch"


#include "_HkSpell"
#include "_CSLCore_Combat"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BURNING_BOLT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	


	object oTarget = HkGetSpellTarget();
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Declare major variables ( fDist / (3.0f * log( fDist ) + 2.0f) )
		int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
		int nCnt;
		effect eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);
		effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
		int nMissiles = (nCasterLvl + 1)/2;
		float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
		float fDelay = fDist/(3.0 * log(fDist) + 2.0);
		float fDelay2, fTime;

		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget);

		// Get the proper damage type adjusted for classes/feats.
		int nDamageType = HkGetDamageType(DAMAGE_TYPE_FIRE);

		//Make SR Check
		if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
		{
			//Apply a single damage hit for each missile instead of as a single mass
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				int nDamage = 0;
				int iTouch = CSLTouchAttackRanged(oTarget,TRUE);
				if (iTouch != TOUCH_ATTACK_RESULT_MISS )
				{
					nDamage = HkApplyMetamagicVariableMods( d4(2)+2, 10);
					nDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nDamage, SC_TOUCH_RANGED, oCaster );
					if(nCnt == 1)
					{
						nDamage += CSLEvaluateSneakAttack(oTarget, oCaster);
						//nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
						//PRCBonusDamage(oTarget);
					}
				}
				// if this is the first target / first attack do sneak damage
				
				fTime = fDelay;
				fDelay2 += 0.1;
				fTime += fDelay2;

				// If the touch attack hit apply the damage and the damage visual effect.
				if (nDamage > 0)
				{
					effect eDamage = HkEffectDamage(nDamage, HkGetDamageType(nDamageType, OBJECT_SELF));
					DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
					DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}

				// Always apply the MIRV effect because we're trying to hit the target whether we
				// actually succeed or not.
				DelayCommand(fDelay2, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
			}
		}
		else
		{
			// SR check failed, have to make animation for missiles but no damage.
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
			}
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

//::///////////////////////////////////////////////
//:: Enervation
//:: NW_S0_Enervat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target Loses 1d4 levels for 1 hour per caster
	level
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"




void main()
{
	//scSpellMetaData = SCMeta_SP_enervation();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENERVATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	// HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); //

	
	object oTarget = HkGetSpellTarget();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ENERVATION));
		int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
		if (iTouch!=TOUCH_ATTACK_RESULT_MISS)
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
				//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
				float fDuration = HkApplyMetamagicDurationMods(HoursToSeconds(HkGetSpellDuration( oCaster )));
				int nDrain = HkApplyMetamagicVariableMods(d4(), 4);
				nDrain = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, nDrain, SC_TOUCH_RANGED );
				
				//int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
				//if ( iSneakDamage > 0 )
				//{
				//	HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iSneakDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
				//}
	
				effect eDrain = EffectNegativeLevel(nDrain);
				eDrain = SupernaturalEffect(eDrain);
				
				int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
				SCApplyDeadlyAbilityLevelEffect( nDrain, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oCaster, iSneakDamage );
				
				effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
				//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, fDuration);
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				
				//if ( HkGetHitDice(oTarget, 1) < 1 )
				//{
					//if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH)) {
				//	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, TRUE, TRUE), oTarget));
					//}
					//else
					//{
					//	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(GetCurrentHitPoints(oTarget)+10), oTarget));
					//}
				//}
			}
		}
		effect eBeam = EffectBeam(VFX_BEAM_NECROMANCY, oCaster, BODY_NODE_HAND);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.7);
	}
	
	HkPostCast(oCaster);
}


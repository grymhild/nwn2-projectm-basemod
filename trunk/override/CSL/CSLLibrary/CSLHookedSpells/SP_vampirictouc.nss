//::///////////////////////////////////////////////
//:: Vampiric Touch
//:: NW_S0_VampTch
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	drain 1d6
	HP per 2 caster levels from the target.
*/
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_vampirictouc();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VAMPIRIC_TOUCH;
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
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	

	if (GetObjectType(oTarget)!=OBJECT_TYPE_CREATURE) return;
	if (!CSLGetIsLiving(oTarget) ) return;
	if (GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget)) return;

	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_VAMPIRIC_TOUCH, TRUE));
		int iTouch = CSLTouchAttackMelee(oTarget, !CSLIsItemValid(GetSpellCastItem()) );
		if (iTouch != TOUCH_ATTACK_RESULT_MISS)
		{
			if ( !HkResistSpell(oCaster, oTarget) )
			{
				int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
				int iDuration = HkGetSpellDuration( oCaster );
				int nDDice = CSLGetMin(10, CSLGetMax(1, iSpellPower/2)); //Min 1, Max 10
				nDDice = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, nDDice);
				int iDamage = HkApplyMetamagicVariableMods(d6(nDDice), 6 * nDDice);
				iDamage = CSLGetMin(GetCurrentHitPoints(oTarget) + 10, iDamage); //Limit damage to max hp + 10
				float fDuration = HkApplyMetamagicDurationMods(HoursToSeconds(iDuration/2));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iHitEffect), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, iDamageType), oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oCaster);
				CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, EFFECT_TYPE_TEMPORARY_HITPOINTS );
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(iDamage), oCaster, fDuration);
			}
		}
	}
	
	HkPostCast(oCaster);
}


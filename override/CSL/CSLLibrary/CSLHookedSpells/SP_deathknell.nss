//::///////////////////////////////////////////////
//:: Death Knell
//:: NW_S0_DeathKnel.nss
//:://////////////////////////////////////////////
/*
	Decompose closest recently-killed living target,
	caster gains 1d8 Temporary HPs, +2 Strength,
	and effective Caster Level +1.
	Note that this spell is inherently Evil, and
	could adjust the Caster's alignment potentially...
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DEATH_KNELL;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_BG_Death_Knell )
	{
		iSpellId = SPELL_BG_Death_Knell;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DEATH|SCMETA_DESCRIPTOR_EVIL|SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget  = HkGetSpellTarget();
	int iCasterLevel  = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType    = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int iBonus      = HkApplyMetamagicVariableMods(d8(), 8);
	int iTouch      = CSLTouchAttackMelee(oTarget, TRUE);

	int iDamage = HkApplyMetamagicVariableMods(d4(2), 8);
	iDamage = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, iDamage, SC_TOUCHSPELL_MELEE );
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_SPELL_DEATH_KNELL, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_EVIL );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDamage = HkEffectDamage(iDamage, iDamageType);
	effect eDamageVis = EffectVisualEffect(iHitEffect);
	effect eDamageLink = EffectLinkEffects(eDamage, eDamageVis);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		if (iTouch != TOUCH_ATTACK_RESULT_MISS)
		{
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE)) // Fire cast spell at event for the specified target
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DEATH_KNELL, TRUE));
					if (iDamage >= GetCurrentHitPoints(oTarget)) // HE'S GONNA DIE FROM THIS
					{
						effect eHP = EffectTemporaryHitpoints(iBonus);
						effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
						effect eDur = EffectVisualEffect(iShapeEffect);   // NWN2 VFX
						//effect eLink = EffectLinkEffects(eHP, eStr);
						effect eLink = EffectLinkEffects(eStr, eDur);
						effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, SPELL_DEATH_KNELL));
						eLink = EffectLinkEffects(eLink, eOnDispell);
						eHP = EffectLinkEffects(eHP, eOnDispell);

						CSLUnstackSpellEffects(OBJECT_SELF, GetSpellId());

						//Apply the VFX impact and effects
						HkApplyEffectToObject(iDurType, eHP, OBJECT_SELF, fDuration);
						HkApplyEffectToObject(iDurType, eLink, OBJECT_SELF, fDuration);
					}
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageLink, oTarget);
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: [Inflict Wounds]
//:: [X0_S0_Inflict.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: This script is used by all the inflict spells

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void InflictTouchAttack(object oCaster, int iSpellId, int iDamage, int nExtraDamage, int nMaximized, int vfx_impactHeal)
{
	object oTarget = HkGetSpellTarget();
		
	
	iDamage = HkApplyMetamagicVariableMods(iDamage, nMaximized, HkGetMetaMagicFeat()  );
	
	
	if ( CSLGetIsUndead( oTarget, TRUE ) ) //Check that the target is undead
	{
		effect eVis2 = EffectVisualEffect(vfx_impactHeal);
		effect eHeal = EffectHeal(iDamage + nExtraDamage);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
		return;
	}
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			if (!HkResistSpell(oCaster, oTarget))
			{
				iDamage = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, iDamage + nExtraDamage, SC_TOUCHSPELL_MELEE );
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_ALL, oCaster );

				effect eVis = EffectVisualEffect(VFX_IMP_HARM);
				effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE);
				DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
	}
}

void main()
{
	//scSpellMetaData = SCMeta_SP_inflict();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_INFLICT_LIGHT_WOUNDS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	if ( GetSpellId() == SPELL_BG_InflictSerious || GetSpellId() == SPELL_BG_Spellbook_2 )
	{
		iSpellId = SPELLABILITY_BG_INFLICT_SERIOUS_WOUNDS;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	else if ( GetSpellId() == SPELL_BG_InflictCritical || GetSpellId() == SPELL_BG_Spellbook_4 )
	{
		iSpellId = SPELLABILITY_BG_INFLICT_CRITICAL_WOUNDS;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	else if ( GetSpellId() == SPELL_INFLICT_CRITICAL_WOUNDS )
	{
		iSpellId = SPELL_INFLICT_CRITICAL_WOUNDS;
	}
	else if ( GetSpellId() == SPELL_INFLICT_LIGHT_WOUNDS )
	{
		iSpellId = SPELL_INFLICT_LIGHT_WOUNDS;
	}
	else if ( GetSpellId() == SPELL_INFLICT_MINOR_WOUNDS )
	{
		iSpellId = SPELL_INFLICT_MINOR_WOUNDS;
	}
	else if ( GetSpellId() == SPELL_INFLICT_MODERATE_WOUNDS )
	{
		iSpellId = SPELL_INFLICT_MODERATE_WOUNDS;
	}
	else if ( GetSpellId() == SPELL_INFLICT_SERIOUS_WOUNDS )
	{
		iSpellId = SPELL_INFLICT_SERIOUS_WOUNDS;		
	}
	int iImpactSEF = VFX_HIT_SPELL_INFLICT_1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
		

	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	int iSpellPower = HkGetSpellPower( oCaster );
	switch (iSpellId)
	{
		case SPELL_INFLICT_MINOR_WOUNDS: InflictTouchAttack(oCaster, iSpellId, d4(1), 0,  4,           VFX_HIT_SPELL_INFLICT_1); break;  /*Minor*/
		case SPELL_INFLICT_LIGHT_WOUNDS: InflictTouchAttack(oCaster, iSpellId, d8(1), CSLGetMin( 5, iSpellPower),  8,           VFX_HIT_SPELL_INFLICT_2); break;  /*Light*/
		case SPELL_INFLICT_MODERATE_WOUNDS: InflictTouchAttack(oCaster, iSpellId, d8(2), CSLGetMin(10, iSpellPower), 16,           VFX_HIT_SPELL_INFLICT_3); break;  /*Moderate*/
		case SPELL_INFLICT_SERIOUS_WOUNDS: InflictTouchAttack(oCaster, iSpellId, d8(3), CSLGetMin(15, iSpellPower), 24,           VFX_HIT_SPELL_INFLICT_4); break;  /*Serious*/
		case SPELL_INFLICT_CRITICAL_WOUNDS: InflictTouchAttack(oCaster, iSpellId, d8(4), CSLGetMin(20, iSpellPower), 32,           VFX_HIT_SPELL_INFLICT_5); break;  /*Critical*/
		case SPELLABILITY_BG_INFLICT_SERIOUS_WOUNDS: InflictTouchAttack(oCaster, iSpellId, d4(iSpellPower), iSpellPower            , 4*iSpellPower, VFX_HIT_SPELL_INFLICT_4); break;  /*Serious*/
		case SPELLABILITY_BG_INFLICT_CRITICAL_WOUNDS: InflictTouchAttack(oCaster, iSpellId, d6(iSpellPower), iSpellPower            , 6*iSpellPower, VFX_HIT_SPELL_INFLICT_5); break;  /*Critical*/
	}
	
	HkPostCast(oCaster);
}


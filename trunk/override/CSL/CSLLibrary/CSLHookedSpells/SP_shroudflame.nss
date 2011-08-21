//::///////////////////////////////////////////////
//:: Shroud of Flame
//:: NW_S0_shdoflm
//:: Created By: Brock Heinz (JBH - OEI)
//:: Created On: August 9th, 2005
//:://////////////////////////////////////////////
/*
	From GDD:

	Player's Guide to Faern, pg. 110
	School:    Evocation [Fire]
	Components:   Verbal, Somatic
	Range:     Close
	Target:    One creature
	Duration:   1 round / level
	Saving Throw:  Reflex negates
	Spell Resist:  Yes

	A single creature bursts into flames, taking 2d6 points of damage immediately
	upon failing the saving throw. Each round the target makes a Reflex save, and
	if unsuccessful takes an additional 2d6 points of damage. Any creature within
	10 feet of the burning creature takes 1d4 points of fire damage per round, a
	successful Reflex save negates all damage.

*/

////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void DamageTarget(object oTarget, object oCaster, int iDamageType, int nSpellSaveDC, int iDamage)
{
	int iSave = ReflexSave(oTarget, nSpellSaveDC, CSLGetSaveTypeByDamageType(iDamageType), oCaster);
	if (iSave==SAVING_THROW_CHECK_FAILED)
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect( CSLGetHitEffectByDamageType(iDamageType) ), oTarget, 0.75 + (iDamage*0.25));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, iDamageType), oTarget);
	}
}

void RunRecurringEffects(object oTarget, object oCaster, int iDamageType, float fDuration, int iMetaMagic, float fRadius, int iDC )
{
	if ( !GetIsObjectValid(oTarget) || GetIsDead(oTarget) || !GetHasSpellEffect(SPELL_SHROUD_OF_FLAME, oTarget) )
	{
		return;
	}
	// int iDC = SCGetDelayedSpellInfoSaveDC(SPELL_SHROUD_OF_FLAME, oTarget, oCaster);

	DamageTarget(oTarget, oCaster, iDamageType, iDC, HkApplyMetamagicVariableMods(d6(2), 12, iMetaMagic));

	location lTarget = GetLocation(oTarget);
	object oOther = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oOther))
	{
		if (CSLSpellsIsTarget(oOther, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oOther!=oTarget)
		{
			float fDistance = GetDistanceBetweenLocations(lTarget, GetLocation(oOther));
			float fDelay = CSLGetMinf(1.75, 0.15f * fDistance);
			DelayCommand(fDelay, DamageTarget(oOther, oCaster, iDamageType, iDC, HkApplyMetamagicVariableMods(d4(1), 4, iMetaMagic)));
		}
		oOther = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
	}

	if (!GetIsDead(oTarget) && fDuration > 0.0)
	{
		DelayCommand(6.0, RunRecurringEffects(oTarget, oCaster, iDamageType, fDuration-6.0, iMetaMagic, fRadius, iDC ));
	}
	else
	{ // The spell is not going to run another cycle, so get rid of the saved info
		//SCRemoveDelayedSpellInfo(SPELL_SHROUD_OF_FLAME, oTarget, oCaster);
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_SHROUD_OF_FLAME );
	}
}

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHROUD_OF_FLAME;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int iMetaMagic = GetMetaMagicFeat();

	CSLUnstackSpellEffects(oTarget, iSpellId );
	
		
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_FIRE, SC_SHAPE_CONTDAMAGE );
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_FIRE, SC_SHAPE_AOE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	if (GetIsObjectValid(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SHROUD_OF_FLAME, TRUE));
		//SCSaveDelayedSpellInfo(SPELL_SHROUD_OF_FLAME, oTarget, oCaster, HkGetSpellSaveDC());
		float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(HkGetSpellDuration(oCaster)));
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(iShapeEffect), oTarget, fDuration);
		RunRecurringEffects(oTarget, oCaster, iDamageType, fDuration, iMetaMagic, fRadius, HkGetSpellSaveDC() );
	}
	HkPostCast(oCaster);
}


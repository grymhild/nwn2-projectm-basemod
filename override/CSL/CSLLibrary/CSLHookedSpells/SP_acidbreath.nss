//::///////////////////////////////////////////////
//:: Mestil's Acid Breath
//:: X2_S0_AcidBrth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You breathe forth a cone of acidic droplets. The
// cone inflicts 1d6 points of acid damage per caster
// level (maximum 10d6).
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
	int iSpellId = SPELL_MESTILS_ACID_BREATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetSpellPower(oCaster,10);
	float fDelay;
	int iDamage;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_CONE_ACID, SC_SHAPE_BREATHCONE ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	if ( !GetIsPC(oCaster) && GetTag(oCaster)=="drakkenmage")
	{
		iDamageType = DAMAGE_TYPE_NEGATIVE;
		iShapeEffect = VFX_DUR_CONE_EVIL;
		iHitEffect = VFX_HIT_SPELL_NECROMANCY;
		iSaveType = SAVING_THROW_TYPE_NEGATIVE;
	}
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	
	effect eAcid;
	effect eVis = EffectVisualEffect(iHitEffect);

	float fMaxDelay = 0.0f;
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
			fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
			fMaxDelay = CSLGetMaxf(fDelay, fMaxDelay);
			if ( oTarget!=oCaster ) //FIX: prevents caster from getting SR check against himself && !HkResistSpell(oCaster, oTarget, fDelay)
			{
				iDamage = HkApplyMetamagicVariableMods(d6(iCasterLevel), 6 * iCasterLevel);
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
				if (iDamage)
				{
					eAcid = HkEffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 8.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	}
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(iShapeEffect), oCaster, fMaxDelay+0.5);
	
	HkPostCast(oCaster);
}


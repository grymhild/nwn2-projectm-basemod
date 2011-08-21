//::///////////////////////////////////////////////
//:: Cone of Cold
//:: NW_S0_ConeCold
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Cone of cold creates an area of extreme cold,
// originating at your hand and extending outward
// in a cone. It drains heat, causing 1d6 points of
// cold damage per caster level (maximum 15d6).
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_SP_conecold();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CONE_OF_COLD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_ELEMENTAL;
	if ( iSpellId == SPELL_SHADES_CONE_OF_COLD )
	{
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower(oCaster, 15);
	float fDelay;
	int iDamage;
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_CONE_ICE, SC_SHAPE_SPELLCONE ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD) && iDamageType == DAMAGE_TYPE_COLD )
	{
		iDamageType = DAMAGE_TYPE_MAGICAL;
		iSaveType = SAVING_THROW_TYPE_ALL;
	}
	
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eCold;
	effect eVis = EffectVisualEffect( iHitEffect );
	float fMaxDelay = 0.0f; // Used to determine duration of cold cone
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CONE_OF_COLD));
			fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
			fMaxDelay = CSLGetMaxf(fDelay, fMaxDelay);
			if (oTarget!=oCaster && !HkResistSpell(oCaster, oTarget, fDelay)) //FIX: prevents caster from getting SR check against himself
			{
				iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
				iDamage = HkApplyTargetModifiers(iDamage, iDamageType, oTarget, iHitEffect, fDelay, oCaster );
				
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
				//  GetHasFeat(FEAT_ENERGY_SUBSTITUTION , oCaster)
				if (iDamage)
				{
					eCold = HkEffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
				
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	}
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect( iShapeEffect ), oCaster, fMaxDelay+0.5);
	
	HkPostCast(oCaster);
}
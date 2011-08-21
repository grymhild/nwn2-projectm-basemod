//::///////////////////////////////////////////////
//:: Burning Hands
//:: NW_S0_BurnHand
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A thin sheet of searing flame shoots from your
// outspread fingertips. You must hold your hands
// with your thumbs touching and your fingers spread
// The sheet of flame is about as thick as your thumbs.
// Any creature in the area of the flames suffers
// 1d4 points of fire damage per your caster level
// (maximum 5d4).
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_burninghands();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BURNING_HANDS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = HkGetSpellPower(oCaster, 5);
	float fDelay;
	int iDamage;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_SPELL_BURNING_HANDS, SC_SHAPE_SHORTCONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eFire;
	effect eVis = EffectVisualEffect(iHitEffect);
	location lTargetLocation = HkGetSpellTargetLocation();
	float fMaxDelay = 0.0f; // Used to determine the duration of the flame cone.
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BURNING_HANDS, TRUE ));
			fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
			fMaxDelay = CSLGetMaxf(fDelay, fMaxDelay);
			if (oTarget!=oCaster && !HkResistSpell(oCaster, oTarget, fDelay))  //FIX: prevents caster from getting SR check against himself
			{
				iDamage = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
				if (iDamage)
				{
					eFire = HkEffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	}
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(iShapeEffect), oCaster, fMaxDelay+0.5);
	
	HkPostCast(oCaster);
}

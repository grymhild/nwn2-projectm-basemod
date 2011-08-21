//::///////////////////////////////////////////////
//:: Frost Breath
//:: cmi_s0_frostbrth
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: May 6, 2009
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//int iDamageType = DAMAGE_TYPE_COLD;
	//if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD))
	//{
	//	iDamageType = DAMAGE_TYPE_MAGICAL;
	//}

	int nMetaMagic = HkGetMetaMagicFeat();
	float fDelay;
	location lTargetLocation = HkGetSpellTargetLocation();
	float fMaxDelay = 0.0f;
	int iDamage;
	int iOrigDmg;
	//int iSpellPower = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 5  );
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------		
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_CONE_ICE, SC_SHAPE_BREATHCONE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	effect eVis = EffectVisualEffect( iHitEffect );
	effect eDaze = EffectDazed();
	effect eCold;
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId()));
			fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
			if ( fDelay > fMaxDelay )
			{
				fMaxDelay = fDelay;
			}
			if(oTarget != oCaster)
			{
				iDamage = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);
				iOrigDmg = iDamage;
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType ) ;
				
				if ( iOrigDmg == iDamage )
				{
					eCold = EffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, 6.0f));
				}
				else if ( iDamage > 0 )
				{
					eCold = EffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE);
	}
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect(iShapeEffect);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, fMaxDelay);
}
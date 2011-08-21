//::///////////////////////////////////////////////
//:: Sound Blast
//:: cmi_s0_sndblast
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nMetaMagic = HkGetMetaMagicFeat();
	float fDelay;
	location lTargetLocation = HkGetSpellTargetLocation();
	float fMaxDelay = 0.0f;
	int iDamage;
	int iDC = HkGetSpellSaveDC();
	//int iSpellPower = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 60  );
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------		
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_CONE_SONIC, SC_SHAPE_BREATHCONE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eVis = EffectVisualEffect(iHitEffect);
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, HkGetSpellId()));
			fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
			if(oTarget != oCaster)
			{
				if( !HkResistSpell(oCaster, oTarget) )
				{
					iDamage = HkApplyMetamagicVariableMods(d8(iSpellPower), 8 * iSpellPower);
					
					
					//if ( FortitudeSave(oTarget, iDC, SAVING_THROW_TYPE_ALL)  )
					//{
					//	iDamage = iDamage/2;
					//	effect eBoom = EffectDamage(iDamage, iDamageType);
					//	DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					//	DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBoom, oTarget));
					//}
					//else
					//{
					//	effect eBoom = EffectDamage(iDamage, iDamageType);
					//	DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					//	DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBoom, oTarget));
					//}
					
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster );
					effect eBoom = EffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBoom, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE);
	}
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect( iShapeEffect );
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, fMaxDelay);
}
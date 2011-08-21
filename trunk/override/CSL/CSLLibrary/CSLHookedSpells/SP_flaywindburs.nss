//::///////////////////////////////////////////////
//:: Flaywind Burst
//:: cmi_s0_flaywndbrst
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
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
	int iOrigDmg;
	//int iSpellPower = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 10  );
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------		
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ALL );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_CONE_MAGIC, SC_SHAPE_BREATHCONE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_MAGICAL );
	float fRadius = HkApplySizeMods(FeetToMeters(60.0f));
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect(iHitEffect);
	effect eFire;
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE);
	effect eKD = EffectKnockdown();
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
				iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
				iOrigDmg = iDamage;
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType ) ;
				
				if ( iOrigDmg == iDamage )
				{
					eFire = EffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKD, oTarget, 5.0f));
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  5.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
				}
				else if ( iDamage > 0 )
				{
					eFire = EffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRadius, lTargetLocation, TRUE);
	}
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect(iShapeEffect);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, fMaxDelay);
}
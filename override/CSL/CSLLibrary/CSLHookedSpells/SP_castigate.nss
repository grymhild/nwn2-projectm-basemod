//::///////////////////////////////////////////////
//:: Castigate
//:: cmi_s0_castigate
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On:  July 5, 2007
//:://////////////////////////////////////////////
//:: Castigate
//:: Caster Level(s): Paladin 4, Cleric 4, Purification 4
//:: Innate Level: 4
//:: School: Evocation
//:: Descriptor(s): Sonic
//:: Component(s): Verbal
//:: Range: 10 ft.
//:: Area of Effect / Target: 10-ft.-radius burst centered on you
//:: Duration: Instantaneous
//:: Save: Fortitude half
//:: Spell Resistance: Yes
//:: This spell has no effect on creatures that cannot hear. All creatures whose
//:: alignment differs from yours on both the law-chaos and the good-evil axes
//:: take 1d4 points of damage per caster level (maximum 10d4). All creatures
//:: whose alignment differs from yours on one component take half damage, and
//:: this spell does not deal damage to those who share your alignment.
//:: 
//:: Shouting your deity's teachings, you rebuke your foes with the magic of
//:: your sacred words.
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

int AdjustAlignDamage(object oTarget, int nAlignDamage)
{
	if (GetAlignmentLawChaos(oTarget) != GetAlignmentLawChaos(OBJECT_SELF))
	{
		if (GetAlignmentGoodEvil(oTarget) != GetAlignmentGoodEvil(OBJECT_SELF))
		{
			// Full Damage
		}
		else
		{
			nAlignDamage = nAlignDamage / 2;
		}
	}
	else
	{
		if (GetAlignmentGoodEvil(oTarget) != GetAlignmentGoodEvil(OBJECT_SELF))
		{
			nAlignDamage = nAlignDamage / 2;
		}
		else
		{
			nAlignDamage = 0;
		}
	}
	return nAlignDamage;

}

void main()
{	
	//scSpellMetaData = SCMeta_SP_castigate();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Castigate;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	// opposite alignment basis	
	int iImpactSEF = VFX_HIT_AOE_HOLY;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
		
	int iNumDice = HkGetSpellPower( oCaster, 10 );
	
	//int iDamage = HkApplyMetamagicVariableMods(d4(iNumDice), 4*iNumDice);
	int iDamage;
	int iSave, iDC;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
			iDamage = HkApplyMetamagicVariableMods(d4(iNumDice), 4 * iNumDice);
			iDamage = AdjustAlignDamage(oTarget, iDamage );
			if ( iDamage > 0 )
			{
				if( !HkResistSpell(oCaster, oTarget) )
				{	
					iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_RESULT_ROLL, oCaster, iSave );
					if ( iDamage > 0 )
					{
						SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
						eDam = HkEffectDamage(iDamage,iDamageType);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					}
				}
			}		
		}
	    oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));	
	}
	HkPostCast(oCaster);
}
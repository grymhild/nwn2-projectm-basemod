//::///////////////////////////////////////////////
//:: Acid Storm
//:: SG_S0_AcidStm.nss
//:: 2003 Karl Nickels
//:://////////////////////////////////////////////
/*
    Evocation [Acid]
    Level: Sor/Wiz 6
    Casting Time: 1 Action
    Range: Medium (100 ft + 10 ft/lvl
    Area: Cylinder (20 ft rad, 20 ft high)
    Duration: Instantaneous
    Saving Throw: Reflex Half
    Spell Resistance: Yes

    Everyone in the area takes d6/caster lvl of
    acid damage.  15d6 max
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 28, 2003
//:: Edited On: July 28, 2003
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 15 );
	
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS ) );
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	int iShapeEffect = HkGetShapeEffect( VFX_FNF_GAS_EXPLOSION_ACID, SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	// 
	//
	//     int     iDC;            //= HkGetSpellSaveDC(oCaster, oTarget);

    int     iDieType        = 6;
    int     iNumDice        = iCasterLevel;
    //int     iBonus          = 0;
    int     iDamage         = 0;

    float fDelay;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eExplode = EffectAreaOfEffect(AOE_PER_ACID_STORM, "", "", "", sAOETag);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDam;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eExplode, lTarget, 4.0f);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget))
    {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			fDelay = CSLRandomBetweenFloat(0.75, 2.25);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_STORM));
			if(!HkResistSpell(oCaster, oTarget, fDelay))
			{
				iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower );
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(oCaster, oTarget), iSaveType);
				eDam = HkEffectDamage(iDamage, iDamageType);
				DelayCommand(1.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
    HkPostCast(oCaster);
}
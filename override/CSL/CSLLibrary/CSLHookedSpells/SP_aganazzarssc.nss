//::///////////////////////////////////////////////
//:: Aganazzar's Scorcher
//:: SG_S0_AgScorch.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation [Fire]
     Level: Sor/Wiz 2
     Casting Time: 1 action
     Range: Close (25 ft. + 5 ft/2 levels)
     Area: 5 ft wide path to close range
     Duration: Instantaneous
     Saving Throw: Reflex Half
     Spell Resistance: Yes

     A jet of roaring flame bursts from your outstretched
     hand, scorching any creature in a 5' wide path
     to the edge of the spells range.  The spell
     deals 1d8 points of damage per two caster levels,
     to a maximum of 5d8 points of damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 5, 2003
//:: Edited On: April 15, 2004
//:://////////////////////////////////////////////
/*
    Edited to include double damage if target is
    employing the cold version of Fire Shield.
*/
//:://////////////////////////////////////////////
// 
// #include "sg_inc_elements"
//
// 
// 
// void main()
// {
//     location lTarget        = GetLocation(oTarget);
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS ) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	location lTarget = GetLocation(oTarget);
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 8;
    int     iNumDice        = iCasterLevel/2;
    int     iBonus          = 0;
    int     iDamage         = 0;

    object  oNextTarget;
    float   fDelay          = 1.5 + GetDistanceBetween(oCaster, oTarget)/20;
    
    if(iNumDice>5) iNumDice=5;
    
    float fRadius;
    int iShapeEffect;
    int bDryRules;
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	
    if(!CSLEnviroGetIsUnderWater(oCaster) && iDamageType!= DAMAGE_TYPE_ELECTRICAL)
    {
    	bDryRules = TRUE;
		fRadius = HkApplySizeMods(RADIUS_SIZE_SMALL);
		iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_SMALL_FIRE, SC_SHAPE_SPELLCYLINDER, oCaster, fRadius ); // note this does not return a visual effect ID, but an AOE ID for walls
    }
    else
    {
    	bDryRules = FALSE;
		fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
		iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_MEDIUM_FIRE, SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); // note this does not return a visual effect ID, but an AOE ID for walls
    }
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eVis=EffectBeam(iShapeEffect, oCaster, BODY_NODE_HAND);
    effect eDamage;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iShapeEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if( bDryRules )
    {
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.5f);
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_AGANAZZARS_SCORCHER));
        if(!HkResistSpell(oCaster,oTarget))
        {
            iDamage = HkApplyMetamagicVariableMods( d8(iNumDice), 8 * iNumDice );
            iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
            eDamage = HkEffectDamage(iDamage, iDamageType);
            if(iDamage>0)
            {
                DelayCommand(fDelay,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
            }
        }
        oNextTarget=GetFirstObjectInShape(SHAPE_SPELLCYLINDER, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oNextTarget))
        {
            if(CSLSpellsIsTarget(oNextTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oNextTarget!=oCaster && oNextTarget!=oTarget)
            {
                SignalEvent(oNextTarget, EventSpellCastAt(oCaster, SPELL_AGANAZZARS_SCORCHER));
                fDelay = 1.5 + GetDistanceBetween(oCaster, oTarget)/20;
                if(!HkResistSpell(oCaster,oNextTarget))
                {
                    iDamage = HkApplyMetamagicVariableMods( d8(iNumDice), 8 * iNumDice );
                    iDC = HkGetSpellSaveDC(oCaster, oNextTarget);
                    iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oNextTarget, iDC, iSaveType);
                    eDamage = HkEffectDamage(iDamage,iDamageType);
                    if(iDamage>0)
                    {
                        DelayCommand(fDelay,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oNextTarget));
                    }
                }
            }
            oNextTarget=GetNextObjectInShape(SHAPE_SPELLCYLINDER, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
        }
    }
    else
    {
        eVis = EffectVisualEffect( iHitEffect );
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget))
        {
            if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
            {
                SignalEvent(oNextTarget, EventSpellCastAt(oCaster, SPELL_AGANAZZARS_SCORCHER));
                fDelay = 1.5 + GetDistanceBetween(oCaster, oTarget)/20;
                if(!HkResistSpell(oCaster,oTarget))
                {
                    iDamage = HkApplyMetamagicVariableMods( d8(iNumDice), 8 * iNumDice );
                    iDC = HkGetSpellSaveDC(oCaster, oTarget);
                    iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
                    eDamage = HkEffectDamage(iDamage,iDamageType);
                    if(iDamage>0)
                    {
                        DelayCommand(fDelay,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oNextTarget));
                    }
                }
            }
            oNextTarget=GetNextObjectInShape(SHAPE_SPELLCYLINDER, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);
        }
    }

    HkPostCast(oCaster);
}
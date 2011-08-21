//::///////////////////////////////////////////////
//:: Desecrate
//:: sg_s0_desecrate.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation
     Level: Clr 2, Evil 2
     Components: V, S
     Casting Time: 1 action
     Range: Close
     Area: 20-ft. radius emanation
     Duration: 2 hours/level
     Saving Throw: None
     Spell Resistance: No

     This spell imbues an area with negative energy.
     All Charisma checks made to turn undead within
     this area suffer a -3 profane penalty.  Undead entering
     this area gain a +1 sacred bonus on attack rolls, damage rolls,
     and saves.  Undead created within or
     summoned into a desecrated area gain +1 hit
     point per HD.

     Desecrate counters and dispels Consecrate.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 30, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//
//     object  oTarget;         //= HkGetSpellTarget();
//
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
	int iSpellId = SPELL_DESECRATE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*2, SC_DURCATEGORY_HOURS) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

	//int     iDieType        = 0;
    //int     iNumDice        = 0;
    int     iBonus          = 1;
    //int     iDamage         = 0;

    float   fRadius         = FeetToMeters(20.0);
    object  oTarget;
    int     iDispelledConsecrate = FALSE;
    
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);
    

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	// ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, lTarget);
	/*
	oAOE = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
	while(GetIsObjectValid(oAOE))
    {
        if( CSLGetAreaOfEffectSpellIdGroup( oAOE, SPELL_CONSECRATE ) )
        {
            DestroyObject(oAOE);
            iDispelledConsecrate = TRUE;
        }
        oAOE = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    }
    */
    
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT|OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE ) // for desecration and desecration of altars and the like, this triggers the spell cast at event
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			CSLEnviroBurningStart( 10, oTarget );
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			if( CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_CONSECRATE ) )
			{
				DestroyObject(oTarget);
				iDispelledConsecrate = TRUE;
			}
		}
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT|OBJECT_TYPE_PLACEABLE);
    }
    
    
    if(iDispelledConsecrate)
    {
        FloatingTextStringOnCreature("You destroyed a consecrated area.", oCaster, FALSE);
    }
    else
    {
        effect eAOE = EffectAreaOfEffect(AOE_PER_DESECRATE, "", "", "", sAOETag);
        HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
        DelayCommand( 0.5f, SetLocalInt( GetObjectByTag( sAOETag ), "CSL_ENVIRO", CSL_ENVIRO_PROFANE ) );
    }

    HkPostCast(oCaster);
}
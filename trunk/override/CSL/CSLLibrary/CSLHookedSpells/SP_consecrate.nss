//::///////////////////////////////////////////////
//:: Consecrate
//:: sg_s0_consecrat.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation
     Level: Clr 2
     Components: V, S
     Casting Time: 1 action
     Range: Close
     Area: 20-ft. radius emanation
     Duration: 2 hours/level
     Saving Throw: None
     Spell Resistance: No

     This spell blesses an area with positive energy.
     All Charisma checks made to turn undead within
     this area gain a +3 sacred bonus.  Undead entering
     this area suffer minor disruption, giving them a
     -1 sacred penalty on attack rolls, damage rolls,
     and saves.  Undead cannot be created within or
     summoned into a consecrated area.

     Consecrate counters and dispels Desecrate.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 29, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//     //--------------------------------------------------------------------------
//     // Spellcast Hook Code
//     // Added 2003-06-20 by Georg
//     // If you want to make changes to all spells, check x2_inc_spellhook.nss to
//     // find out more
//     //--------------------------------------------------------------------------
//     if (!X2PreSpellCastCode())
//     {
//         return;
//     }
    // End of Spell Cast Hook
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CONSECRATE; // put spell constant here
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
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*2, SC_DURCATEGORY_HOURS) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    float fRadius = FeetToMeters(20.0);
    object oTarget;
    int iDispelledDesecrate = FALSE;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_FIRE);
    

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, lTarget);
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
			if( CSLGetAreaOfEffectSpellIdGroup( oTarget, SPELL_DESECRATE ) )
			{
				DestroyObject(oTarget);
				iDispelledDesecrate = TRUE;
			}
		}
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT|OBJECT_TYPE_PLACEABLE);
    }
    
    if(iDispelledDesecrate)
    {
        FloatingTextStringOnCreature("You dispelled a desecrated area with your spell.", oCaster, FALSE);
    }
    else
    {
        effect eAOE = EffectAreaOfEffect(AOE_PER_CONSECRATE, "", "", "", sAOETag);
        HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);
        DelayCommand( 0.5f, SetLocalInt( GetObjectByTag( sAOETag ), "CSL_ENVIRO", CSL_ENVIRO_HOLY ) );
    }

    HkPostCast(oCaster);
}

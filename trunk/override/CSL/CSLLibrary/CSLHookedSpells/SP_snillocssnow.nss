//::///////////////////////////////////////////////
//:: Snilloc's Snowball Swarm
//:: sg_s0_snilloc.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation [Cold]
     Level: Sor/Wiz 2
     Casting Time: 1 action
     Range: Medium (100 ft + 10ft/level)
     Effect: 10' Radius Burst
     Duration: Instantaneous
     Saving Throw: Reflex Half
     Spell Resistance: Yes

     A flurry of magic snowballs erupts from a point
     you select.  The swarm deals 2d6 points of cold
     damage to creatures and objects within the burst.
     For every two levels beyond 3rd, the snowballs
     deal an extra die of damage, to a max of 5d6
     at 9th level and above.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: July 28, 2003
//:://////////////////////////////////////////////
// #include "sg_inc_elements"
//
//
//
// 
// void main()
// {
//     int     iDamageType  = SGGetElementalDamageType(DAMAGE_TYPE_COLD);
//     int     iSpellType      = SGGetElementalSpellType(iDamageType);
// 
//     SGSetSpellInfo(, SPELL_SUBSCHOOL_NONE, iSpellType, oCaster);
// 
//
//
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
//     int     iMetamagic      = HkGetMetaMagicFeat();
//
// 
// 
//
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	int iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_MEDIUM_COLD, SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = 2+(iCasterLevel-3)/2;
    int     iBonus          = 0;
    int     iDamage         = 0;

    float   fDist           = 0.0;
    float   fDelay          = 0.0;
    
    if(iNumDice>5) iNumDice=5;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImp = EffectVisualEffect(iShapeEffect);
    effect eVis = EffectVisualEffect(iHitEffect);
    effect eDam;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);

    while(GetIsObjectValid(oTarget))
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SNILLOC_SNOWBALL));
            fDist = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget));
            fDelay = fDist/20.0;
            if(!HkResistSpell(oCaster, oTarget, fDelay))
            {
                int iDC = HkGetSpellSaveDC(oCaster, oTarget);
                iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice );
                iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, iSaveType);
                eDam = HkEffectDamage(iDamage, iDamageType);
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                if(iDamage>0)
                {
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE || OBJECT_TYPE_PLACEABLE || OBJECT_TYPE_DOOR);
    }
    HkPostCast(oCaster);
}


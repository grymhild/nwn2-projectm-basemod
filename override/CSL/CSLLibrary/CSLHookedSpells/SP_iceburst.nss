//::///////////////////////////////////////////////
//:: Ice Burst
//:: sg_s0_iceburst.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     creates a burst of ice shards, 30ft rad.
     causes 1d4 cold damage +1 pt blunt damage per
     caster level - max 10d4+10
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 23, 2003
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
//     object  oTarget;         //= HkGetSpellTarget();
//
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
//     int     iMetamagic      = HkGetMetaMagicFeat();
//
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
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	int iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_COLOS_COLD, SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_ICE, SC_SHAPE_AOE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 4;
    int     iNumDice        = iCasterLevel;
    int     iBonus          = 0;
    int     iDamage         = 0;

    float   fDelay;
    int     iColdDmg;

    if(iNumDice>10) iNumDice=10;
    iBonus=iNumDice;
	int iDC;

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eColdDmg;
    effect eBluntDmg;
    effect eVis         = EffectVisualEffect(iShapeEffect);
    effect eImp         = EffectVisualEffect(iHitEffect);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
    while(GetIsObjectValid(oTarget))
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_ICE_BURST));
            fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
            if(!HkResistSpell(oCaster, oTarget, fDelay))
            {
                iDC = HkGetSpellSaveDC(oCaster, oTarget); 
                iColdDmg = HkApplyMetamagicVariableMods( d4(iNumDice), 4 * iNumDice );
                
                iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iColdDmg,oTarget,iDC,iSaveType);
                if(iDamage!=iColdDmg)
                {
                    if(iDamage==iColdDmg/2)
                    {
                        iBonus/=2;
                    }
                }

                if(iDamage>0)
                {
                    eColdDmg = HkEffectDamage(iDamage,iDamageType);
                    eBluntDmg = HkEffectDamage(iBonus, DAMAGE_TYPE_BLUDGEONING);
                    effect eLink = EffectLinkEffects(eColdDmg, eBluntDmg);    
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                }
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
    }

    HkPostCast(oCaster);
}



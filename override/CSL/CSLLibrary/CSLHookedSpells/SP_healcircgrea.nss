//::///////////////////////////////////////////////
//:: Greater Healing Circle
//:: SG_S0_GrHealCr.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
// Positive energy spreads out in all directions
// from the point of origin, curing 2d8 points of
// damage plus 2 point per caster level (maximum +40)
// to nearby living allies.
//
// Like cure spells, healing circle damages undead in
// its area rather than curing them.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 10, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
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
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
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
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 8;
    int     iNumDice        = 2;
    int     iBonus          = iCasterLevel*2;
    int     iDamage         = 0;

    int     iHeal;
    float   fRadius         = FeetToMeters(3.0f*iCasterLevel);
    float   fDelay;

    if(iBonus>40) iBonus=40;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eKill;
    effect eHeal;
    effect eVis     = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eVis2    = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eImpact  = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        fDelay = CSLRandomBetweenFloat();
        if(CSLGetIsUndead(oTarget))
        {
            if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
            {
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GREATER_HEALING_CIRCLE, TRUE));
                if(!HkResistSpell(oCaster, oTarget))
                {
                    iDamage = HkApplyMetamagicVariableMods( d8(iNumDice), 8 * iNumDice );
                    
                    //if(HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(oCaster, oTarget), SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                    //{
                     //   iDamage /= 2;
                    //}
                    iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget,  HkGetSpellSaveDC(oCaster, oTarget), SAVING_THROW_TYPE_NONE, oCaster, SAVING_THROW_RESULT_ROLL, fDelay );
                    eKill = HkEffectDamage(iDamage, DAMAGE_TYPE_POSITIVE);
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        else
        {
            if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) && CSLGetIsLiving(oTarget) && !CSLGetIsImmuneToMagicalHealing(oTarget))
			{
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_HEALING_CIRCLE, FALSE));
                iHeal = HkApplyMetamagicVariableMods( d8(iNumDice), 8 * iNumDice )+iBonus;
                eHeal = EffectHeal(iHeal);
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    }

    HkPostCast(oCaster);
}



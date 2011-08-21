//::///////////////////////////////////////////////
//:: Freezing Curse
//:: SG_S0_FrzCurse.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Target is frozen solid in ice.  Upon taking 5hp
     dmg, target shatters and is killed.

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////
//
// #include "_CSLCore_Items"
// 
// void main()
// {
// 
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//
#include "_HkSpell"
#include "_CSLCore_Combat"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FREEZING_CURSE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
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
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(5, SC_DURCATEGORY_HOURS) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = Hk DC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 8;
    int     iNumDice        = 5;
    int     iBonus          = 0;
    int     iDamage         = 0;

    object  oPCHide;
    int     iOnHitSpell     = IP_CONST_ONHIT_CASTSPELL_FREEZING_CURSE_HIT;
    itemproperty ipOnHitCastSpell = ItemPropertyOnHitCastSpell(iOnHitSpell, iCasterLevel);
    
	
    iDamage = HkApplyMetamagicVariableMods( d8(iNumDice), 8 * iNumDice );

    
	//COLD
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_ICE, SC_SHAPE_AOE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eVis     = EffectVisualEffect(VFX_IMP_FROST_L);
	
    effect eImpact    = EffectVisualEffect(VFX_IMP_FROST_S);

    effect eParalyze   = EffectLinkEffects(EffectVisualEffect(VFX_DUR_ICESKIN), EffectCutsceneParalyze());
    effect eDamage = EffectLinkEffects( HkEffectDamage(iDamage,iDamageType),EffectVisualEffect(VFX_IMP_FROST_S) );

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    
    SignalEvent(oTarget,EventSpellCastAt(oCaster,iSpellId));
    int iTouch = CSLTouchAttackMelee(oTarget,TRUE);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
        if(!HkResistSpell(oCaster, oTarget))
        {
            if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType))
            {
                HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eParalyze, oTarget);
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
                CSLSetOnDamagedScript( oTarget, "SP_freezingcursB" );
				SetLocalInt(oTarget, "SG_FRZCURSE_HP", GetCurrentHitPoints( oTarget ) );
            }
            else
            {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
            }
        }
    }

    HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Larloch's Minor Drain
//:: sg_s0_larmindr.nss
//:: 2005 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Necromancy
Level: 1
Components: V,S,M
Range: Long
Casting Time: 1 action
Area of Effect: 1 living creature
Duration: Instantaneous
Saving Throw: None

With this spell the wizard drains the life force from a target and adds
it to his own. The target creature suffers 1-6 points of damage, while
the wizard gains 1-6 hit points. If the wizard goes over his maximum hit
point total with this spell, he looses them after 10 rounds.
  The material component for this spell is a living leech which is
flicked at the target during the casting of the spell.

Thanks to - the Baldur's Gate CRPG
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 12, 2005
//:://////////////////////////////////////////////
//
// 
// void main()
// {
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(10) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 4;
    int     iNumDice        = 1;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iCurrHP         = GetCurrentHitPoints();
    int     iMaxHP          = GetMaxHitPoints();
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	iDamage = HkApplyMetamagicVariableMods( d4(), 4 );
	

	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_IMP_NEGATIVE_ENERGY );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	
    effect eVis     = EffectVisualEffect( iHitEffect);
    effect eDam;     //= HkEffectDamage( iDamage, iDamageType );
    effect eLink    = EffectLinkEffects(eVis, eDam);
    effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eHeal;
    effect eTempHP;
    
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if( !HkResistSpell(oCaster, oTarget) )
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            int iTouch = CSLTouchAttackRanged(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_LARLOCHS_MINOR_DRAIN));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
				eDam = HkEffectDamage( iDamage, iDamageType );
				
                if(iCurrHP+iDamage<=iMaxHP)
                {
                    eHeal = EffectHeal(iDamage);
                    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_LARLOCHS_MINOR_DRAIN, FALSE));
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oCaster);
                }
                else if(iCurrHP>=iMaxHP && iCurrHP<iMaxHP+20)
                {
                    if(iCurrHP+iDamage>iMaxHP+20)
                    {
                        iDamage = iMaxHP+20-iCurrHP;
                    }
                    eTempHP = EffectTemporaryHitpoints(iDamage);
                    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_LARLOCHS_MINOR_DRAIN, FALSE));
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oCaster);
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oCaster, fDuration);
                }
                else if(iCurrHP<iMaxHP && iCurrHP+iDamage>iMaxHP)
                {
                    eHeal = EffectHeal(iMaxHP-iCurrHP);
                    eTempHP = EffectTemporaryHitpoints(iDamage-(iMaxHP-iCurrHP));
                    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_LARLOCHS_MINOR_DRAIN, FALSE));
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oCaster);
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, oCaster, fDuration);
                }
            }
        }
    }
            

    HkPostCast(oCaster);
}



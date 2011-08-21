//::///////////////////////////////////////////////
//:: Repair Damage series (Min,Lgt,Mod,Ser,Crit)
//:: SG_S0_RepDamage.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Repair Damage Series from Tome & Blood
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 21, 2003
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 8;
    int     iNumDice        = 0;
    int     iBonus          = iCasterLevel;
    int     iDamage         = 0;
    int     iVisual;

    switch(iSpellId) {
        case SPELL_REP_MINOR_DAMAGE:
            iDieType=1;
            iNumDice=1;
            iBonus=0;
            iVisual=VFX_IMP_HEAD_HEAL;
            break;
        case SPELL_REP_LIGHT_DAMAGE:
            iNumDice=1;
            if(iBonus>5) iBonus=5;
            iVisual=VFX_IMP_HEALING_L;
            break;
        case SPELL_REP_MODERATE_DAMAGE:
            iNumDice=2;
            if(iBonus>10) iBonus=10;
            iVisual=VFX_IMP_HEALING_M;
            break;
        case SPELL_REP_SERIOUS_DAMAGE:
            iNumDice=3;
            if(iBonus>15) iBonus=15;
            iVisual=VFX_IMP_HEALING_S;
            break;
        case SPELL_REP_CRITICAL_DAMAGE:
            iNumDice=4;
            if(iBonus>20) iBonus=20;
            iVisual=VFX_IMP_HEALING_G;
            break;
    }
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	iDamage = HkApplyMetamagicVariableMods( CSLDieX(iDieType, iNumDice), 6 * iNumDice )+iBonus;
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(iVisual);
    effect eHeal    = EffectHeal(iDamage);
    effect eLink    = EffectLinkEffects(eHeal, eVis);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if(CSLGetIsConstruct(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
    }

    HkPostCast(oCaster);
}



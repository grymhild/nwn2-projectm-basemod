//::///////////////////////////////////////////////
//:: Life Force Transfer
//:: SG_S0_LifeTrans.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     The caster can "absorb" hp dmg from the target.
     For each HP "absorbed" the target is healed 2hp,
     the caster takes the "absorbed" dmg as dmg.Caster
     may absorb up to 2hp/level up to 30hp (15th level)
     Max healing is 60 hp.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 11, 2003
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    //int     iDieType        = 0;
    int     iNumDice        = iCasterLevel;
    //int     iBonus          = 0;
    //int     iDamage         = 0;

    int     iHPDmg          = GetMaxHitPoints(oTarget)-GetCurrentHitPoints(oTarget);
    int     iAbsorb;
    int     iHeal;

    if(iNumDice>15) iNumDice=15;    // limit to 15th level (2*level - max is 30hp absorbed)
    iAbsorb = 2*iNumDice;
    if(iHPDmg<(2*iAbsorb)) {        // if there is less dmg, only absorb enough to fully heal
        iAbsorb = iHPDmg/2;
    }
    if(iAbsorb>(GetCurrentHitPoints(oCaster)+10)) iAbsorb = GetCurrentHitPoints(oCaster)+10;
                                    // if caster does not have 30 hp, can only absorb curr hp+10 (enough to kill)
    iHeal = iAbsorb*2;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eHealVis     = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eHeal        = EffectHeal(iHeal);
    effect eBeam        = EffectBeam(VFX_BEAM_COLD, oCaster, BODY_NODE_CHEST);
    effect eDmgVis      = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect eDamage      = EffectDamage(iAbsorb,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_PLUS_TWENTY);
    effect eHealLink    = EffectLinkEffects(eHealVis,eHeal);
    effect eDamageLink  = EffectLinkEffects(eDmgVis,eDamage);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_LIFE_TRANSFER, FALSE));
    if(CSLGetIsLiving(oTarget)) {
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5f);
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHealLink, oTarget);
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamageLink, oCaster);
    }

    HkPostCast(oCaster);
}



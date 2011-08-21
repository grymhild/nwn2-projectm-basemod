//::///////////////////////////////////////////////
//:: Armor of Darkness
//:: SG_S0_ArmDark.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Abjuration [Darkness]
     Level: Darkness 4
     Casting Time: 1 action
     Range: Touch
     Target: Creature Touched
     Duration: 10 minutes/level
     Saving Throw: Will negates (harmless)
     Spell Resistance: Yes (harmless)

     The spell envelops the target in a shroud of
     flickering shadows.  The shroud grants a +3
     deflection bonus to AC, plus an additional +1
     per four caster levels (maximum bonus +8).  The
     target is afforded Darkvision with a range of 60'
     and gains a +2 bonus to saving throws against holy,
     good, or light spells or effects. Undead receiving
     this spell also gain +4 turn resistance.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 5, 2003
//:: Edited On: October 6, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
//     //int     iDieType        = 0;
//     //int     iNumDice        = 0;
//     //int     iBonus          = 0;
//     //int     iDamage         = 0;
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DARKNESS, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(10*iDuration, SC_DURCATEGORY_MINUTES) );

	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	
    int     iACIncrease     = 3+1*iCasterLevel/4;

    if(iACIncrease>8) iACIncrease=8;
    	

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
    effect eAC      = EffectACIncrease(iACIncrease, AC_DEFLECTION_BONUS);
    effect eSaveGood= EffectSavingThrowIncrease(2, SAVING_THROW_TYPE_GOOD);
    effect eSaveHoly= EffectSavingThrowIncrease(2, SAVING_THROW_TYPE_DIVINE);
    effect eVis1    = EffectVisualEffect(VFX_DUR_ULTRAVISION);
    effect eVis2    = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eUltra   = EffectUltravision();
    effect eTurn    = EffectTurnResistanceIncrease(4);

    effect eLink    = EffectLinkEffects(eVis1, eVis2);
    eLink = EffectLinkEffects(eLink, eUltra);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eSaveGood);
    eLink = EffectLinkEffects(eLink, eSaveHoly);
    eLink = EffectLinkEffects(eLink, eVis);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ARMOR_DARKNESS, FALSE));
    if(CSLGetIsUndead(oTarget))
    {
        eLink=EffectLinkEffects(eLink,eTurn);
    }
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

    HkPostCast(oCaster);
}



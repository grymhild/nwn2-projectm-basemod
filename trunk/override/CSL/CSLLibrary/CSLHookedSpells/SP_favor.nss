//::///////////////////////////////////////////////
//:: Favor of Ilmater
//:: sg_s0_favor.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Necromancy
     Level: Clr 4 (Ilmater), Pal 4
     Components: V, S
     Casting Time: 1 action
     Range: Medium
     Target: Willing Creature
     Duration: 1 minute/level or instantaneous
     Saving Throw: None
     Spell Resistance: Yes

     This spell has two possible effects:
         Divine Fortitude:  The target becomes immune to
            charm effects and compulsions, and is immune
            to effects that would cause the target to be
            dazed or stunned.
         Pact of Martyrdom:  You and the target exchange
            hit point totals.  This variant of the spell
            only works if you have more hit points than
            the target when the spell is cast.  If the
            target was unconscious and dying, you become
            unconscious and dying.

     Clerics and paladins who don't worship Ilmater name
     this spell after their own deity - Favor of Torm,
     for example.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 5, 2004
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
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    int     iHPDifference   = GetCurrentHitPoints(oCaster) - GetCurrentHitPoints(oTarget);
    
	




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);

        // Divine Fortitude version of spell
    effect eDFCharm = EffectImmunity(IMMUNITY_TYPE_CHARM);
    effect eDFCompulsion = EffectImmunity(IMMUNITY_TYPE_DOMINATE);
    //effect eDFCompulsion2 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eDFDaze = EffectImmunity(IMMUNITY_TYPE_DAZED);
    effect eDFStun = EffectImmunity(IMMUNITY_TYPE_STUN);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDFLink = EffectLinkEffects(eDur, eDFCharm);
    eDFLink = EffectLinkEffects(eDFCompulsion, eDFLink);
    //eDFLink = EffectLinkEffects(eDFCompulsion2, eDFLink);
    eDFLink = EffectLinkEffects(eDFDaze, eDFLink);
    eDFLink = EffectLinkEffects(eDFStun, eDFLink);

        // Pact of Martyrdom version of spell
    effect ePMTargetHeal = EffectHeal(iHPDifference);
    effect ePMCasterDamage = EffectDamage(iHPDifference);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FAVOR_OF_ILMATER, FALSE));
    if(iSpellId==SPELL_FAVOR_OF_ILMATER_DF)
    {
        CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_FAVOR_OF_ILMATER );
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDFLink, oTarget, fDuration);
    } else if(iHPDifference>0){
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePMTargetHeal, oTarget);
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, ePMCasterDamage, oCaster);
    }

    HkPostCast(oCaster);
}



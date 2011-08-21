//::///////////////////////////////////////////////
//:: Enhance Familiar
//:: sg_s0_EnhFamil.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     You infuse your familiar with vigor.  Familiar
     receives +2 competence bonus to attacks, saves,
     and damage.  Familiar also receives +2 dodge
     bonus to AC.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 23, 2003
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    object  oFamiliar       = GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oCaster);


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAttBonus    = EffectAttackIncrease(2);
    effect eSaveBonus   = EffectSavingThrowIncrease(SAVING_THROW_ALL,2);
    effect eDamageBonus = EffectDamageIncrease(DAMAGE_BONUS_2);
    effect eACBonus     = EffectACIncrease(2);
    effect eVis         = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink        = EffectLinkEffects(eAttBonus,eSaveBonus);
    eLink   = EffectLinkEffects(eLink,eDamageBonus);
    eLink   = EffectLinkEffects(eLink,eACBonus);
    eLink   = EffectLinkEffects(eLink,eDur);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if(GetIsObjectValid(oTarget) && oTarget==oFamiliar)
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster,SPELL_ENHANCE_FAMILIAR, FALSE));
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_ENHANCE_FAMILIAR );
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    }
    else if ( GetIsObjectValid(oTarget) && GetDistanceBetween(oCaster,oTarget) > FeetToMeters(120.0) )
    {
        FloatingTextStringOnCreature("You can only use this spell on your familiar.", oCaster, FALSE);
    }

    HkPostCast(oCaster);
}



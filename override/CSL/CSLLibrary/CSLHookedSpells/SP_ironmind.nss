//::///////////////////////////////////////////////
//:: Iron Mind
//:: sg_s0_ironmind.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Abjuration
     Level: Brd 4, Sor/Wiz 3
     Components: S
     Casting Time: 1 action
     Range: Touch
     Area: Creature touched
     Duration: 1 hour
     Saving Throw: Will negates (harmless)
     Spell Resistance: Yes (harmless)

     The person or creature affected by this spell is immune
     to all charm and hold spells for a full hour.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 4, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
// 
//
//
//
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCharmImmune = EffectImmunity(IMMUNITY_TYPE_CHARM);
    effect eHoldImmune1 = EffectSpellImmunity(SPELL_HOLD_PERSON);
    effect eHoldImmune2 = EffectSpellImmunity(SPELL_HOLD_ANIMAL);
    effect eHoldImmune3 = EffectSpellImmunity(SPELL_HOLD_MONSTER);
    effect eLink = EffectLinkEffects(eDur, eCharmImmune);
    eLink = EffectLinkEffects(eLink, eHoldImmune1);
    eLink = EffectLinkEffects(eLink, eHoldImmune2);
    eLink = EffectLinkEffects(eLink, eHoldImmune3);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_IRON_MIND, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

    HkPostCast(oCaster);
}



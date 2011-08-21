//::///////////////////////////////////////////////
//:: Fortify Familiar
//:: sg_s0_fortfam.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     You make your familiar tougher.  While the spell
     lasts, it gains a +2 enhancement modifier to
     natural armor and has a 25% chance to avoid extra
     damage from sneak attacks and critical hits.  The
     familiar also receives 2d8 temporary hit points
*/
//:://////////////////////////////////////////////
//:: NOTE:  Cannot do the 25% effect.  Will instead
//:: change to a 10% miss effect
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: November 4, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     SGSetSpellInfo( );
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
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
    int     iDieType        = 8;
    int     iNumDice        = 2;
    int     iBonus          = 0;
    int     iDamage         = 0;

    object  oFamiliar       = GetAssociate(ASSOCIATE_TYPE_FAMILIAR,oCaster);
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
    iDamage = HkApplyMetamagicVariableMods( d8(iNumDice), 8 * iNumDice );

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eMissChance  = EffectConcealment(50);
    effect eACIncrease  = EffectACIncrease(2,AC_NATURAL_BONUS);
    effect eTempHP      = EffectTemporaryHitpoints(iDamage);
    effect eACVis       = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eTempVis     = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
    effect eVisLink     = EffectLinkEffects(eACVis, eTempVis);
    effect eLink        = EffectLinkEffects(eMissChance,eACIncrease);
    eLink=EffectLinkEffects(eLink,eTempHP);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if(GetIsObjectValid(oTarget) && oTarget==oFamiliar) {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FORTIFY_FAMILIAR, FALSE));
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisLink, oTarget);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
    } else if(GetIsObjectValid(oTarget) && GetDistanceBetween(oCaster,oTarget)>FeetToMeters(120.0f)) {
        FloatingTextStringOnCreature("You can only cast this spell on your familiar!", oCaster, FALSE);
    }

    HkPostCast(oCaster);
}



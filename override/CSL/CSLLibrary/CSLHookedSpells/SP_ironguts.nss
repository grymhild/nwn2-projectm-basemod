//::///////////////////////////////////////////////
//:: Ironguts
//:: SOZ UPDATE BTM
//:: X2_S0_Ironguts
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: When touched the target creature gains a +4
//:: circumstance bonus on Fortitude saves against
//:: all poisons.
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 22, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg 19/10/2003
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_IRONGUTS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
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
	
    //Declare major variables
    object oTarget = HkGetSpellTarget();
    effect eSave;
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEAD_ACID);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

   CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );

    int iBonus = 4; //Saving throw bonus to be applied

    int iDuration = HkGetSpellDuration( oCaster ) * 10;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
    //Check for metamagic extend
    
    float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //Set the bonus save effect
    eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, iBonus, SAVING_THROW_TYPE_POISON);
    effect eLink = EffectLinkEffects(eSave, eDur);

    //Apply the bonus effect and VFX impact
    HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    DelayCommand(0.3f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    
    HkPostCast(oCaster);
}
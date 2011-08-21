//::///////////////////////////////////////////////
//:: One with the Land
//:: SOZ UPDATE BTM
//:: x0_s0_oneland.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 bonus +3: animal empathy, move silently, search, hide
 Duration: 1 hour/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 19, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003
// (Updated JLR - OEI 07/05/05 NWN2 3.5)
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_ONE_WITH_THE_LAND;
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
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    

//    effect eSkillAnimal = EffectSkillIncrease(SKILL_ANIMAL_EMPATHY, 4);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, 4);
    effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4);
    effect eSearch = EffectSkillIncrease(SKILL_SET_TRAP, 4);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
//    effect eLink = EffectLinkEffects(eSkillAnimal, eMove);
    effect eLink = EffectLinkEffects(eMove, eHide);
    eLink = EffectLinkEffects(eLink, eSearch);

    eLink = EffectLinkEffects(eLink, eDur);

    int iDuration = HkGetSpellDuration( oCaster );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
    //Apply VFX impact and bonus effects
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
	
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Blood Frenzy
//:: SOZ UPDATE BTM
//:: x0_s0_bldfrenzy.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Similar to Barbarian Rage.
 +2 Strength, Con. +1 morale bonus to Will
 -1 AC
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 19, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_BLOOD_FRENZY;
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
	
	

    if(!GetHasSpellEffect(iSpellId))
    {
        //Declare major variables
        int iDuration = HkGetSpellDuration( oCaster );
        int nIncrease;
        int iSave;
        nIncrease = 2;
        iSave = 1;

		float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

        effect eStr = EffectAbilityIncrease(ABILITY_CONSTITUTION, nIncrease);
        effect eCon = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, iSave);
        effect eAC = EffectACDecrease(1, AC_DODGE_BONUS);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        effect eLink = EffectLinkEffects(eCon, eStr);
        eLink = EffectLinkEffects(eLink, eSave);
        eLink = EffectLinkEffects(eLink, eAC);
        eLink = EffectLinkEffects(eLink, eDur);
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
        //Make effect extraordinary
        eLink = MagicalEffect(eLink);
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Change to the Rage VFX

        //Apply the VFX impact and effects
        HkApplyEffectToObject(iDurType, eLink, OBJECT_SELF, fDuration );
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;
    }
    
    HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Wounding Whispers
//:: SOZ UPDATE BTM
//:: x0_s0_WoundWhis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Magical whispers cause 1d8 sonic damage to attackers who hit you.
    Made the damage slightly more than the book says because we cannot
    do the +1 per level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Modified for wounding whispers, July 30 2002, Brent
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WOUNDING_WHISPERS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    int iDuration = HkGetSpellDuration( oCaster );
    int iSpellPower = HkGetSpellPower( oCaster );
    
    int iBonus = iDuration;

    object oTarget = OBJECT_SELF;
    
   	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC);
	int iShapeEffect = HkGetShapeEffect( VFXSC_DUR_SPELLSHIELD_SONIC, SC_SHAPE_SHIELD ); // note this does not return a visual effect ID, but an AOE ID for walls
	//int iHitEffect = HkGetHitEffect( VFX_IMP_FLAME_M );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
    
   	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	//Declare major variables
    effect eVis = EffectVisualEffect(iShapeEffect);
    effect eShield = EffectDamageShield( HkApplyMetamagicVariableMods(d6()+iSpellPower, 6+iSpellPower), 0, iDamageType);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

	//CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_Sonic_Shield, SPELLR_WOUNDING_WHISPERS );
    CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_MESTILS_ACID_SHEATH, SPELL_ELEMENTAL_SHIELD, SPELL_DEATH_ARMOR, SPELL_Sonic_Shield, SPELLR_WOUNDING_WHISPERS );
        
    float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //Apply the VFX impact and effects
    HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
    
    HkPostCast(oCaster);
}
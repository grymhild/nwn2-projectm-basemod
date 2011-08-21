//::///////////////////////////////////////////////
//:: Deathwatch
//:: SOZ UPDATE BTM
//:: NW_S0_Deathwtch.nss
//:://////////////////////////////////////////////
/*
    Target gains ability to see Opponent's true
    Hit Point values.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 16, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DEATHWATCH;
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

    int iDuration = HkGetSpellDuration( oCaster );
    //int iCasterLevel = GetCasterLevel(OBJECT_SELF);

    //Enter Metamagic conditions
    float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds(iDuration * 10) );
    int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eDeath = EffectSeeTrueHPs();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDeath, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

    //Apply the VFX impact and effects
    HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration,  iSpellId );
    //HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
    
    HkPostCast(oCaster);
}
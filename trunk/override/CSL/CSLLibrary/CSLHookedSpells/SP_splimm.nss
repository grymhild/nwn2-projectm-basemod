//::///////////////////////////////////////////////
//:: Spell Immunity
//:: SOZ UPDATE BTM
//:: NW_S0_SpellImmu.nss
//:://////////////////////////////////////////////
/*
    Target gains Immunity to certain spells:
    Lvl  7: Fireball, Magic Missile
    Lvl 10: Lightning Bolt, Web
    Lvl 13: Stinking Cloud, Grease
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 16, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_SPELL_IMMUNITY;
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
    object oTarget = HkGetSpellTarget();
    int iDuration = HkGetSpellDuration( oCaster );
    int iSpellPower = HkGetSpellPower( oCaster );
    float fDuration = TurnsToSeconds(iDuration * 10);

    //Enter Metamagic conditions
    fDuration = HkApplyMetamagicDurationMods(fDuration);
    int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    effect eImmu1 = EffectSpellImmunity(SPELL_FIREBALL);
    effect eImmu2 = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
    effect eLink = EffectLinkEffects(eImmu1, eImmu2);

    if ( iSpellPower >= 10 )
    {
        effect eImmu3 = EffectSpellImmunity(SPELL_LIGHTNING_BOLT);
        effect eImmu4 = EffectSpellImmunity(SPELL_WEB);
        eLink = EffectLinkEffects(eLink, eImmu3);
        eLink = EffectLinkEffects(eLink, eImmu4);
        if ( iSpellPower >= 13 )
        {
            effect eImmu5 = EffectSpellImmunity(SPELL_STINKING_CLOUD);
            effect eImmu6 = EffectSpellImmunity(SPELL_GREASE);
            eLink = EffectLinkEffects(eLink, eImmu5);
            eLink = EffectLinkEffects(eLink, eImmu6);
        }
    }

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

    //Apply the VFX impact and effects
    HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
    
    HkPostCast(oCaster);
}
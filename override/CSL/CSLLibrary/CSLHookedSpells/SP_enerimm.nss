//:://////////////////////////////////////////////////////////////////////////
//:: Level 7 Arcane Spell: Energy Immunity
//:: nw_s0_enerimmu.nss
//:: Created By: Brock Heinz - OEI
//:: Created On:
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
			Energy Immunity (B)
			E-mail from WotC, up-coming Complete Arcane
			School: Abjuration
			Components: Verbal, Somatic
			Range: Touch
			Target: Creature Touched
			Duration: 24 hours

			This provides complete protection from one of the five energy types:
		acid, cold, electricity, fire, or sonic. They take no damage from the
		selected elemental type.
			[Art] This is a buff spell. This may need an effect depending on
		decisions later.

*/
//:://////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"



void main()
{
	//scSpellMetaData = SCMeta_SP_enerimm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENERGY_IMMUNITY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(OBJECT_SELF);
	float fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);
	
	// block this if its an enemy
	if (GetIsObjectValid(oTarget))
	{
		if ( GetIsEnemy( oTarget ) )
		{
				return;
		}
	}
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Single Immunity Only Nerf - only works for last version cast, previous spells cast will be removed soas to only allow one immunity /
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if( CSLGetPreferenceSwitch("PreventEnergyImmunityStacking", FALSE ) )
{
	string sMessageToPlayers = "";
	// Comment out the current one, this just tests soas to do messages
	if ( GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_ACID, oTarget) ) { sMessageToPlayers = "Removed acid energy immunity";}
	if ( GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_ELECTRICAL, oTarget) ) { sMessageToPlayers = "Removed electrical energy immunity"; }
	if ( GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_FIRE, oTarget) ) { sMessageToPlayers = "Removed fire energy immunity"; }
	if ( GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_SONIC, oTarget) ) { sMessageToPlayers = "Removed sonic energy immunity"; }
	if ( GetHasSpellEffect(SPELL_ENERGY_IMMUNITY_COLD, oTarget) ) { sMessageToPlayers = "Removed cold energy immunity"; }
	if ( GetHasSpellEffect(SPELL_ENERGY_IMMUNITY, oTarget) ) { sMessageToPlayers = "Removed complete energy immunity"; }
	
	if ( CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_ENERGY_IMMUNITY, SPELL_ENERGY_IMMUNITY_ACID, SPELL_ENERGY_IMMUNITY_COLD, SPELL_ENERGY_IMMUNITY_ELECTRICAL, SPELL_ENERGY_IMMUNITY_FIRE, SPELL_ENERGY_IMMUNITY_SONIC ) )
	{
		CSLPlayerMessageSplit( sMessageToPlayers, oCaster, oTarget );
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////                      End Single Immunity Only Nerf                                                                      //////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eImmu1 = EffectDamageResistance(DAMAGE_TYPE_ACID, 9999, 0);
	effect eImmu2 = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0);
	effect eImmu3 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999, 0);
	effect eImmu4 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999, 0);
	effect eImmu5 = EffectDamageResistance(DAMAGE_TYPE_SONIC, 9999, 0);
	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION); // NWN1 VFX
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_ENERGY_IMMUNITY ); // NWN2 VFX

	effect eLink = EffectLinkEffects(eImmu1, eImmu2);
	eLink = EffectLinkEffects(eLink, eImmu3);
	eLink = EffectLinkEffects(eLink, eImmu4);
	eLink = EffectLinkEffects(eLink, eImmu5);
	eLink = EffectLinkEffects(eLink, eHit);


	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget); // NWN1 VFX
	
	HkPostCast(oCaster);
}


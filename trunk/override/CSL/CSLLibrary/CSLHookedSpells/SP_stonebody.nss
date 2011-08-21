//:://///////////////////////////////////////////////
//:: Level 6 Arcane Spell: Stone Body
//:: nw_s0_stonebody.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
/*
		5.1.6.3.5 Stone Body
		Players Guide to Faern, pg. 113
		School:       Transmutation
		Components:  Verbal, Somatic
		Range:      Personal
		Target:       You
		Duration:   1 minute / level

		You gain damage reduction 10/adamantine and a +4 enhancement bonus to
		Strength, but you take a -4 penalty to Dexterity. You move at half speed.
		You have a 50% arcane failure chance and a -8 armor check penalty. You are
		also immune to blindness, critical hits, ability score damage, deafness,
		disease, electricity, poison, and stunning. You take only half damage from
		acid and fire of all kinds.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_stonebody();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_STONE_BODY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget  = HkGetSpellTarget(); // should be the caster
	int iCasterLevel  = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(45.0 * HkGetSpellDuration( oCaster ) );
	int nDRAmount   = CSLGetMin(150, iCasterLevel * 10);
	int iDurType    = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int nDex = GetAbilityScore (oTarget, ABILITY_DEXTERITY);
	int nDexMod = (nDex <= 4) ? nDex - 1 : 4;
	
	if( CSLGetPreferenceSwitch("FreedomDeathwardBuffExclude", FALSE ) )
	{
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_FREEDOM_OF_MOVEMENT, SPELL_ASN_Freedom_of_Movement, SPELL_BG_Freedom_of_Movement, SPELL_DEATH_WARD );
	}
	
	// Link the effects together
	effect eLink = EffectVisualEffect( VFX_DUR_SPELL_STONEBODY );
	eLink = EffectLinkEffects(eLink, EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, nDRAmount, DR_TYPE_GMATERIAL));
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
	eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, nDexMod));
	eLink = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));
	eLink = EffectLinkEffects(eLink, EffectArcaneSpellFailure(50));
	eLink = EffectLinkEffects(eLink, EffectArmorCheckPenaltyIncrease(oTarget, 8));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
	if( CSLGetPreferenceSwitch("AllowCritImmuneEffectsInSpells", TRUE ) )
	{
		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
	}
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
	
	if (!GetHasSpellEffect(1106, oTarget)) //SPELLABILITY_IMMUNITY_TO_ELECTRICITY to prevent bug with stormlords
	{
			eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999,0));
	}
	
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
	eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50));
	eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 50));
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_STONE_BODY, FALSE));
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_STONE_BODY );
	HkPostCast(oCaster);
}


//:://///////////////////////////////////////////////
//:: Level 8 Arcane Spell: Iron Body
//:: nw_s0_ironbody.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/15/05
//::////////////////////////////////////////////////
/*
		5.1.8.3.1   Iron Body
		PHB pg. 245
		School:        Transmutation
		Components:    Verbal, Somatic
		Range:         Personal
		Target:        You
		Duration:      1 minute / level

		You gain damage reduction 15/adamantine and a +6 enhancement bonus to Strength,
		but you take a -6 penalty to Dexterity. You move at half speed. You have a 50%
		arcane failure chance and a -8 armor check penalty. You are also immune to blindness,
		critical hits, ability score damage, deafness, disease, electricity, poison, and stunning.
		You take only half damage from acid and fire of all kinds.
		[Art] Same as Stone Body except with gray skin and hopefully iron textures.

*/


// JLR - OEI 08/24/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_ironbody();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_IRON_BODY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int nDex = GetAbilityScore (oTarget, ABILITY_DEXTERITY);
	int nDexMod = (nDex <= 6) ? nDex - 1 : 6;
	
	if ( CSLGetPreferenceSwitch("FreedomDeathwardBuffExclude", FALSE ) )
	{
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_FREEDOM_OF_MOVEMENT, SPELL_ASN_Freedom_of_Movement, SPELL_BG_Freedom_of_Movement, SPELL_DEATH_WARD );
	}
	// Link the effects together
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_IRON_BODY);
	eLink = EffectLinkEffects(eLink, EffectDamageReduction(15, GMATERIAL_METAL_ADAMANTINE, nDRAmount, DR_TYPE_GMATERIAL));
	eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 6));
	eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_DEXTERITY, nDexMod));
	eLink = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));
	eLink = EffectLinkEffects(eLink, EffectArcaneSpellFailure(50));
	eLink = EffectLinkEffects(eLink, EffectArmorCheckPenaltyIncrease(oTarget, 8));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
	
	if ( CSLGetPreferenceSwitch("AllowCritImmuneEffectsInSpells", TRUE ) )
	{
		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
	}
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999,0));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
	eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50));
	eLink = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 50));
	//eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELLABILITY_PULSE_DROWN));  // IMMUNITY TO THE WATER ELEMENTAL PULSE DROWN ABILITY
	eLink = EffectLinkEffects(eLink, EffectSpellImmunity(1019));
	eLink = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_DROWN)); // IMMUNITY TO THE DROWN SPELL
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK)); // Immunity to sneak attacks
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IRON_BODY, FALSE));
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_IRON_BODY);
	
	HkPostCast(oCaster);
}


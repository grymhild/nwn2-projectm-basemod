//::///////////////////////////////////////////////
//:: Shield
//:: x0_s0_shield.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Immune to magic Missile
	+4 general AC
	DIFFERENCES: should be +7 against one opponent
	but this cannot be done.
	Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003


// JLR - OEI 08/23/05 -- Metamagic changes


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_shield();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHIELD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = OBJECT_SELF;
	
	if (GetHasSpellEffect( SPELL_SHADES_TARGET_CASTER, oCaster))
	{
		SendMessageToPC(oCaster, "You already have a shield from Shades in effect.");
		HkPostCast(oCaster);
		return;
	}
	
	int iShapeEffect = VFX_DUR_SPELL_SHIELD;
	/*
	if ( CSLGetIsHumanoid( oCaster ) )
	{
		iShapeEffect = HkGetShapeEffect( VFXSC_DUR_SPELLWEAP_SHIELD_FORCE, SC_SHAPE_SPELLWEAP_SHIELD  );
	}
	*/
	
	//effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

	effect eArmor = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS); // AFW-OEI 11/02/2006 change from Deflection to Shield bonus.
	eArmor = EffectLinkEffects(eArmor, EffectSpellImmunity(SPELL_MAGIC_MISSILE));
	eArmor = EffectLinkEffects(eArmor, EffectVisualEffect( iShapeEffect ));

	float fDuration = TurnsToSeconds(HkGetSpellDuration(OBJECT_SELF)); // * Duration 1 turn
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Fire spell cast at event for target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SHIELD, FALSE));
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, SPELL_SHIELD, SPELL_SHIELDIMPROVED, SPELL_SHADES_TARGET_CASTER );
	
	//Apply VFX impact and bonus effects
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	HkUnstackApplyEffectToObject(iDurType, eArmor, oTarget, fDuration, SPELL_SHIELD);
	HkPostCast(oCaster);
}


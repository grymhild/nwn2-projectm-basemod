//::///////////////////////////////////////////////
//:: Ghostly Visage
//:: nw_s0_ghostvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Caster gains 5/+1 Damage reduction and immunity
	to 1st level spells.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GHOSTLY_VISAGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_ILLUSION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	if ( GetSpellId() == SPELLABILITY_AS_GHOSTLY_VISAGE || GetSpellId() == SPELL_ASN_GhostlyVisage || GetSpellId() == SPELL_ASN_Spellbook_1 )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	else if ( GetSpellId() == 351 )
	{
		iClass = CLASS_TYPE_BLACKGUARD;
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	//if (GetSpellId()==SPELLABILITY_AS_GHOSTLY_VISAGE) iSpellPower = GetLevelByClass(CLASS_TYPE_ASSASSIN);
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster ) ));
	
	//effect eLink = EffectDamageReduction( 5, DAMAGE_POWER_PLUS_ONE, 0, DR_TYPE_MAGICBONUS );    // 3.5 DR approximation
	effect eLink = EffectDamageReduction(5, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
	//effect eLink = EffectDamageReduction( 5, 0, 0, DR_TYPE_NONE);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_GHOSTLY_VISAGE));
	eLink = EffectLinkEffects(eLink, EffectSpellLevelAbsorption(1));
	eLink = EffectLinkEffects(eLink, EffectConcealment(10));	
	eLink = SetEffectSpellId(eLink, SPELL_GHOSTLY_VISAGE);
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GHOSTLY_VISAGE, FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELL_GHOSTLY_VISAGE );
	
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: Etherealness -> Ethereal Jaunt
//:: x2_s1_ether.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Turns a creature ethereal
	Used by one of the undead shape forms for
	shifter/druids. lasts 5 rounds

	Changed to Ethereal Jaunt:
	Last for 1 round/caster level.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Invisibility"

void main()
{
	//scSpellMetaData = SCMeta_SP_etherealjaun();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ETHEREAL_JAUNT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
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
	

	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oCaster,  SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY  );

	//float fDuration = HkApplyMetamagicDurationMods( HkGetSpellDuration( oCaster ) + 0.0);
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(HkGetSpellDuration( oCaster ), SC_DURCATEGORY_ROUNDS) );

	effect eLink;
	// this is normal
	
	if ( CSLGetPreferenceSwitch("EtherealRemovedByInvisPurge",FALSE) && GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oCaster ))
	{
		// Cannot be cast when in a purge AOE
		SendMessageToPC( oCaster, "Invisibility Purge Prevents Going Etheral");
	}
	else if ( !CSLGetCanEthereal( oCaster ) )
	{
		SendMessageToPC( oCaster, "You are Dimensionally Anchored");
	}
	else if ( CSLGetPreferenceSwitch("ImprovedEthereal",FALSE) ) // they can ethereal
	{
		SCApplyImpEtheralness( oCaster, oCaster, fDuration, SPELL_ETHEREAL_JAUNT );
		SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_ETHEREALNESS, FALSE));	
	}
	else // they can ethereal
	{
		effect eLink = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );  // NWN2 VFX
		eLink = EffectLinkEffects(eLink, EffectEthereal() );
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
		SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_ETHEREALNESS, FALSE));	
	}
	HkPostCast(oCaster);
}


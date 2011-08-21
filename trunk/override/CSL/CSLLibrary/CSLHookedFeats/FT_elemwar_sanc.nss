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
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003/08/01
//:://////////////////////////////////////////////
//:: AFW-OEI 05/30/2006:
//::	Changed to Ethereal Jaunt

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Invisibility"
//#include "x2_inc_spellhook"

void main()
{
	//scSpellMetaData = SCMeta_FT_elemwar_sanc();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_ELEMWAR_SANCTUARY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
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
	
	
	// prevent ethereal effects from stacking
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oCaster,  SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY  );

	float fDuration = 10.0f;
	effect eLink;
	// this is normal
	
	SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));

	if ( CSLGetPreferenceSwitch("ImprovedEthereal",FALSE) )
	{
		SCApplyImpEtheralness( oCaster, oCaster, fDuration, SPELLABILITY_SPIRIT_JOURNEY, VFX_DUR_SPELL_ETHEREALNESS );
	}
	else
	{
		if ( CSLGetPreferenceSwitch("EtherealRemovedByInvisPurge",FALSE) && GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oCaster ))
		{
			// Cannot be cast when in a purge AOE
			SendMessageToPC( oCaster, "Invisibility Purge Prevents Going Etheral");
			return;
		}
		eLink = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );  // NWN2 VFX
		eLink = EffectLinkEffects(eLink, EffectEthereal() );
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);	
	}
	HkPostCast(oCaster);

}
//::///////////////////////////////////////////////
//:: Spirit Journey
//:: nx_s2_spiritjourney.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
   A spirit shaman knows how to vanish bodily into
   the spirit world. This ability functions like the
   spell Ethereal Jaunt; the spirit shaman cannot
   attack or be attacked. A spirit shaman can use
   this ability once per day.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/15/2007
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invisibility"

void main()
{
	//scSpellMetaData = SCMeta_FT_spiritjourne();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oCaster,  SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY  );

	float fDuration = IntToFloat( GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN) ) + 6.0;
	effect eLink;
	// this is normal
	if ( CSLGetPreferenceSwitch("ImprovedEthereal",FALSE) )
	{
		SCApplyImpEtheralness( oCaster, oCaster, fDuration, SPELLABILITY_SPIRIT_JOURNEY, VFX_DUR_SPELL_SPIRIT_JOURNEY );
	}
	else
	{
		if ( CSLGetPreferenceSwitch("EtherealRemovedByInvisPurge",FALSE) && GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oCaster ))
		{
			// Cannot be cast when in a purge AOE
			SendMessageToPC( oCaster, "Invisibility Purge Prevents Going Etheral");
			return;
		}
		eLink = EffectVisualEffect( VFX_DUR_SPELL_SPIRIT_JOURNEY );  // NWN2 VFX
		eLink = EffectLinkEffects(eLink, EffectEthereal() );
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);	
	}

	SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELLABILITY_SPIRIT_JOURNEY, FALSE));
	
	HkPostCast(oCaster);
}


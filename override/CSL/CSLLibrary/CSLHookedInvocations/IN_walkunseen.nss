//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Walk Unseen
//:: nw_s0_iwalkunsn.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
			Complete Arcane, pg. 136
			Spell Level: 2
			Class: Misc

			This works like the invisibility spell (2nd level wizard) except
			lasts up to 24 hours.

*/



// JLR - OEI 08/24/05 -- Metamagic changes

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"
#include "_SCInclude_Invisibility"




void main()
{
	//scSpellMetaData = SCMeta_IN_walkunseen();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	/*
		if ( GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, HkGetSpellTarget() ))
		{
		// Cannot be cast when in a purge AOE
		SendMessageToPC(OBJECT_SELF, "Invisibility was Purged");
		return;
		}
	*/
	//Declare major variables
	
	object oTarget = OBJECT_SELF; //HkGetSpellTarget(); // Should be the caster..
	//effect eInvis   = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
	//effect eDur     = EffectVisualEffect( VFX_DUR_INVISIBILITY );
	//effect eLink = EffectLinkEffects(eInvis, eDur);
	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ILLUSION);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));

	float fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS); // Hours
	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_I_WALK_UNSEEN);

	//Apply the VFX impact and effects
	//HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	
	SCApplyInvisibility( oTarget, oCaster, fDuration, SPELL_I_WALK_UNSEEN, 0 );
	
	HkPostCast(oCaster);
}
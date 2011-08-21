//::///////////////////////////////////////////////
//:: lionheart
//:: NX_s0_lionheart.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
	Lionheart
	Abjuration [Mind-Affecting]
	Level: Paladin 1
	Components: V, S
	Range: Touch
	Target: Creature touched
	Duration: 1 round/level
	
	The subject gains immunity to fear effects.

*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.22.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_lionheart();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LIONHEART;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	



	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_LIONHEART );
	effect eLink;

	int iBonus = 3; //Saving throw bonus to be applied
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE)); //replace with proper cast at event when the 2da is updated

	//Check for metamagic extend
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//link vis and immunity
	eLink = EffectLinkEffects( eFear, eVis );

	//Apply the bonus effect and VFX impact
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, GetSpellId());
	
	HkPostCast(oCaster);
}


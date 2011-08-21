//::///////////////////////////////////////////////
//:: Vigorous Cycle
//:: NX_s0_Vigorcycle.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Classes: Cleric 6, Druid 6
	
	Fast healing 1 on entire party for 10 rounds + 1
	round/level (max 25).
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.04.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/18/2007: Weaker versions of vigor will not override the stronger versions,
//:: but versions of the same or greater strength will replace each other.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_vigorouscycl();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VIGOROUS_CYCLE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	



	//Declare major variables
	location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	effect eRegen;
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_VIGOROUS_CYCLE );
	
	// int iSpellPower = HkGetSpellPower( OBJECT_SELF, 30 ); // OldGetCasterLevel(OBJECT_SELF);
	
	int iBonus = 3;
	float fDuration = RoundsToSeconds(10+HkGetSpellDuration(OBJECT_SELF));
	
	//Set the bonus regen effect
	eRegen = EffectRegenerate(iBonus, 6.0);
	eRegen = EffectLinkEffects( eRegen, eVis );

	//Check for metamagic
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			// AFW-OEI 07/18/2007: Strip all vigor effcts and replace them with this spell's effects.
			CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_LESSER_VIGOR, SPELL_MASS_LESSER_VIGOR, SPELL_VIGOR, SPELL_VIGOROUS_CYCLE);
		
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1023, FALSE));

			//Apply the bonus effect and VFX impact
			HkUnstackApplyEffectToObject(iDurType, eRegen, oTarget, fDuration, 1023);
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}


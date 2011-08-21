//::///////////////////////////////////////////////
//:: Rage
//:: NW_S0_Rage
//:://////////////////////////////////////////////
/*
	Gives Barbarian Rage effect to targets, but
	without the associated negative effects.
	Note that this is the Wizard spell Rage.
	The Str and Con of the target increases +2,
	Will Saves are +2, AC -2.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 12, 2005
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Group"


void main()
{
	//scSpellMetaData = SCMeta_SP_rage();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RAGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	



	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds (iDuration) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	
	effect eStr = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
	effect eCon = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 1);
	effect eAC = EffectACDecrease(2, AC_DODGE_BONUS);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_RAGE );
	effect eLink = EffectLinkEffects(eCon, eStr);
	eLink = EffectLinkEffects(eLink, eSave);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eDur);
	//Make effect extraordinary
	eLink = ExtraordinaryEffect(eLink);

	
	location lTarget = GetLocation( oTarget );
	
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	// First, affect Caster...
	object oAlly = GetFirstObjectInShape( SHAPE_SPHERE, fRadius, lTarget );
	while ( GetIsObjectValid(oAlly) )
	{
		if (CSLSpellsIsTarget ( oAlly, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oAlly, SPELL_RAGE);
				PlayVoiceChat(VOICE_CHAT_BATTLECRY1, oAlly);
		
				//Fire cast spell at event for the specified target
				SignalEvent(oAlly, EventSpellCastAt(OBJECT_SELF, SPELL_RAGE, FALSE));
		
				// Apply effects to the currently selected target.
				HkApplyEffectToObject( iDurType, eLink, oAlly, fDuration );
		}
		oAlly = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lTarget );
	}
	
	
	HkPostCast(oCaster);
}


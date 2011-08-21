//::///////////////////////////////////////////////
//:: Greater Heroism
//:: NW_S0_GrHeroism.nss
//:://////////////////////////////////////////////
/*
	Target gets a +2 morale bonus to Attack, saves,
	and skill checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_ObjectVars"



void main()
{
	//scSpellMetaData = SCMeta_SP_grtheroism();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_HEROISM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	int iDurationCategory = SC_DURCATEGORY_MINUTES;
	if( CSLGetPreferenceSwitch("ReducedHeroismDuration", FALSE ) )
	{
		iDurationCategory = SC_DURCATEGORY_ROUNDS;
	}
	

	//Declare major variables
	int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	//float fDuration = RoundsToSeconds( HkGetSpellDuration( OBJECT_SELF ) * 10);
	int nHPs = CSLGetMin(20, iSpellPower); // CAPPED AT 20

	//Enter Metamagic conditions
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, iDurationCategory ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	object oTarget = HkGetSpellTarget();
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Prevent stacking with heroism
	CSLUnstackSpellEffects(oTarget, SPELL_HEROISM);
	CSLUnstackSpellEffects(oTarget, GetSpellId());

	if (oTarget != OBJECT_INVALID)
	{
		effect eAttack = EffectAttackIncrease(4);
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
		effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 4);
		effect eHP = EffectTemporaryHitpoints(nHPs);
		effect eFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
		effect eDur = EffectVisualEffect(VFX_DUR_SPELL_GREATER_HEROISM);

		effect eLink = EffectLinkEffects(eAttack, eSave);
		eLink = EffectLinkEffects(eLink, eSkill);
//      eLink = EffectLinkEffects(eLink, eHP); // DON'T LINK THE HP's SO SPELL DOESN"T END
		eLink = EffectLinkEffects(eLink, eFear);
		eLink = EffectLinkEffects(eLink, eDur);

		//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);

		effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_GREATER_HEROISM));
		eLink = EffectLinkEffects(eLink, eOnDispell);
		eHP = EffectLinkEffects(eHP, eOnDispell);

		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		//Apply the VFX impact and effects
		//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		HkApplyEffectToObject(iDurType, eHP, oTarget, fDuration);
		HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	}
	
	HkPostCast(oCaster);
}


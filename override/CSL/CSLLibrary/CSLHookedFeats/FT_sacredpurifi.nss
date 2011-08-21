//::///////////////////////////////////////////////
//:: Sacred Purification
//:: NX2_S0_SacredPurif.nss
//:: Copyright (c) 2008 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	you can expend a turn undead
	attempt to create a pulse of divine energy. All living
	creatures within 60 feet of you heal an amount of damage
	equal to 1d8 points + your Charisma bonus (if any). All undead
	creatures in this area take damage equal to 1d8 points + your
	Charisma bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: JWR-OEI
//:: Created On: May 23 2008
//:://////////////////////////////////////////////
//#include "x0_i0_spells"
//#include "_CSLCore_Items"
//#include "nwn2_inc_spells"



#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = 1;
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------


	if (!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
	{
		SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);
	}
	else
	{
		// we have turn undead attempts left.
		object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, GetLocation(OBJECT_SELF), TRUE);
		int nDam;
		int nBonus = GetAbilityModifier(ABILITY_CHARISMA);
		effect eDamage;

		while(GetIsObjectValid(oTarget))
		{
			nDam = HkApplyMetamagicVariableMods( d8(), 8 )+nBonus;
			if ( CSLGetIsUndead(oTarget) )
			{
				eDamage = EffectDamage(nDam, DAMAGE_TYPE_DIVINE);
				eDamage = EffectLinkEffects( eDamage, EffectVisualEffect( VFX_HIT_SPELL_HOLY ) );
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			}
			else if(CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF ))
			{
				eDamage = EffectHeal(nDam);
				eDamage = EffectLinkEffects( eDamage, EffectVisualEffect( VFX_HIT_CURE_AOE ) );
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

			}
			oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, GetLocation(OBJECT_SELF), TRUE);
		}
		effect eImpactVis = EffectVisualEffect(VFX_FEAT_TURN_UNDEAD);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));
		DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
	}
	HkPostCast(oCaster);
}

// -DATA- // int iAttributes =98560;
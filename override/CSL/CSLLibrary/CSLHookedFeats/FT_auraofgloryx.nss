//::///////////////////////////////////////////////
//:: Aura of Glory
//:: x2_s0_auraglory.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +2 Charisma Bonus
 All allies in medium area of effect: +6 Saves against Fear
 All allies in medium area of effect: 1d4 hitpoints healing
 40% chance of disease on the caster when used.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 24, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
#include "_HkSpell"

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_auraofgloryx();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	



	//Declare major variables
	object oTarget = OBJECT_SELF;
	//effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); // NWN1 VFX
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_AURA_OF_GLORY ); // NWN2 VFX
	

	effect eChar = EffectAbilityIncrease(ABILITY_CHARISMA, 2);

	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eChar, eVis);

	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF); // * Duration 1 turn/level
	
	float fDuration = HkApplyMetamagicDurationMods(HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	

	//Apply VFX impact and bonus effects
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget); // NWN1 VFX
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, HkGetSpellId() );

	// * now setup benefits for allies
			//Apply Impact
	//effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
	float fDelay = 0.0;
	//eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
	effect eFear = EffectSavingThrowIncrease(SAVING_THROW_ALL, 6, SAVING_THROW_TYPE_FEAR);
	effect eHeal = EffectHeal( HkApplyMetamagicVariableMods(d4(), 4) );
	eLink = EffectLinkEffects(eFear, eHeal);
	eLink = EffectLinkEffects(eLink, eVis);
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());

	//Get the first target in the radius around the caster
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF) || GetFactionEqual(oTarget))
		{
				fDelay = CSLRandomBetweenFloat(0.4, 1.1);
				//Fire spell cast at event for target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
				//Apply VFX impact and bonus effects
				//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, HkGetSpellId() ));
			}
			//Get the next target in the specified area around the caster
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
	
	//Create a disease effect on the caster 40% of the time
	if (d100() < 41)
	{
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDisease(DISEASE_DEMON_FEVER)), oTarget);
	}
	HkPostCast(oCaster);
}
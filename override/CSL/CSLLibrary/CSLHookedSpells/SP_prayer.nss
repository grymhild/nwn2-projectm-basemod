//::///////////////////////////////////////////////
//:: Prayer
//:: NW_S0_Prayer.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Allies gain +1 Attack, damage, saves, skill checks
	Enemies gain -1 to these stats
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
// JLR - OEI 08/24/05 -- Metamagic changes




void main()
{
	//scSpellMetaData = SCMeta_SP_prayer();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PRAYER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	object oTarget;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	
	effect ePosVis = EffectVisualEffect(VFX_DUR_SPELL_PRAYER);
	effect eNegVis = EffectVisualEffect(VFX_DUR_SPELL_PRAYER_VIC);
	effect eImpact = EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT);

	int iBonus = 1;
	effect eBonAttack = EffectAttackIncrease(iBonus);
	effect eBonSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, iBonus);
	effect eBonDam = EffectDamageIncrease(iBonus, DAMAGE_TYPE_SLASHING );
	effect eBonSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, iBonus);

	
	effect ePosLink = EffectLinkEffects(eBonAttack, eBonSave);
	ePosLink = EffectLinkEffects(ePosLink, eBonDam);
	ePosLink = EffectLinkEffects(ePosLink, eBonSkill);
	ePosLink = EffectLinkEffects(ePosLink, ePosVis);

	effect eNegAttack = EffectAttackDecrease(iBonus);
	effect eNegSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, iBonus);
	effect eNegDam = EffectDamageDecrease(iBonus, DAMAGE_TYPE_SLASHING);
	effect eNegSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, iBonus);

	effect eNegLink = EffectLinkEffects(eNegAttack, eNegSave);
	eNegLink = EffectLinkEffects(eNegLink, eNegDam);
	eNegLink = EffectLinkEffects(eNegLink, eNegSkill);
	eNegLink = EffectLinkEffects(eNegLink, eNegVis);

	float fDuration = RoundsToSeconds(HkGetSpellDuration(OBJECT_SELF));

	//Metamagic duration check
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Apply Impact
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation());

	//Get the first target in the radius around the caster
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		//if(GetIsFriend(oTarget))
		if (CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF ))
		{
			//Fire spell cast at event for target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRAYER, FALSE));
			
			//Apply VFX impact and bonus effects
			HkUnstackApplyEffectToObject(iDurType, ePosLink, oTarget, fDuration, SPELL_PRAYER );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire spell cast at event for target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRAYER));
			
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Apply VFX impact and bonus effects
				HkApplyEffectToObject(iDurType, eNegLink, oTarget, fDuration, SPELL_PRAYER );
			}
		}
		//Get the next target in the specified area around the caster
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
	}
	
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: War Cry
//:: NW_S0_WarCry
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The bard lets out a terrible shout that gives
	him a +2 bonus to attack and damage and causes
	fear in all enemies that hear the cry
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"



void main()
{
	//scSpellMetaData = SCMeta_SP_warcry();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WAR_CRY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC|SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget;
	int iDuration = HkGetSpellDuration( OBJECT_SELF );  // OldGetCasterLevel(OBJECT_SELF);
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	effect eAttack = EffectAttackIncrease(2);
	effect eDamage = EffectDamageIncrease(2, DAMAGE_TYPE_SLASHING );
	effect eFear = EffectFrightened();
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
	effect eLOS = EffectVisualEffect(VFX_HIT_AOE_SONIC);
	effect eBuf = EffectVisualEffect ( VFX_DUR_SPELL_WAR_CRY );
	effect eVisFear = EffectVisualEffect (VFX_DUR_SPELL_CAUSE_FEAR);
	effect eLink = EffectLinkEffects(eAttack, eDamage);
	eLink = EffectLinkEffects(eLink, eBuf);
	eFear = EffectLinkEffects (eFear, eVisFear);
	//Meta Magic
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLOS, OBJECT_SELF);
	//Determine enemies in the radius around the bard
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY));
				//Make SR and Will saves
				if(!HkResistSpell(OBJECT_SELF, oTarget)  && !HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FEAR))
				{
					DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, RoundsToSeconds(4)));
				//DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));VFX we don't need
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
	}
	//Apply bonus and VFX effects to bard.
	//SCRemoveSpellEffects(GetSpellId(),OBJECT_SELF,OBJECT_SELF);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF); //PMils OEI 07.08.06- NWN1 stuff, in NWN2 we're trying to not use the hit fx for buffs
	DelayCommand(0.01, HkApplyEffectToObject(iDurType, eLink, OBJECT_SELF, fDuration ));
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_WAR_CRY, FALSE));
	HkPostCast(oCaster);
}


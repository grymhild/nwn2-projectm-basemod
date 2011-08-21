//::///////////////////////////////////////////////
//:: Awaken
//:: NW_S0_Awaken
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spell makes an animal ally more
	powerful, intelligent and robust for the
	duration of the spell.  Requires the caster to
	make a Will save to succeed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 10, 2001
//:://////////////////////////////////////////////
//:: Modifications:
//:: * AFW-OEI 05/09/2006:
//:: Wisdom bonus instead of Intelligence bonus.
//:: No Will save necessary.
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_awaken();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_AWAKEN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE); // NWN1 VFX
	effect eWis;
	effect eAttack = EffectAttackIncrease(2);
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION); // NWN1 VFX
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_AWAKEN ); // NWN2 VFX
	int nWis;
	
	if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
	{
			if(!GetHasSpellEffect(SPELL_AWAKEN))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
				//Enter Metamagic conditions
				
				nWis = HkApplyMetamagicVariableMods(d10(1), 10);
				eWis = EffectAbilityIncrease(ABILITY_WISDOM, nWis);
				effect eLink = EffectLinkEffects(eStr, eCon);
				eLink = EffectLinkEffects(eLink, eAttack);
				eLink = EffectLinkEffects(eLink, eWis);
				//eLink = EffectLinkEffects(eLink, eDur); // NWN1 VFX
				eLink = EffectLinkEffects(eLink, eVis); // NWN2 VFX
				eLink = SupernaturalEffect(eLink);
				//Apply the VFX impact and effects
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget); // NWN1 VFX
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
			}
	}
	
	HkPostCast(oCaster);
}


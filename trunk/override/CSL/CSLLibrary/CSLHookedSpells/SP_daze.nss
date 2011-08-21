//::///////////////////////////////////////////////
//:: [Daze]
//:: [NW_S0_Daze.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dazed for 1 round
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 15, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 27, 2001


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
 


void main()
{
	//scSpellMetaData = SCMeta_SP_daze();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DAZE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 0;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	//effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE); // NWN1 VFX
	effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
	effect eDaze = EffectDazed();
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); // NWN1 VFX
	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT); // NWN1 VFX

	effect eLink = EffectLinkEffects(eMind, eDaze);
	//eLink = EffectLinkEffects(eLink, eDur);

	//effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S); // no longer using NWN1 VFX
	
	int iDuration = 2;
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Make sure the target is a humaniod
	if (CSLGetIsHumanoid(oTarget) == TRUE)
	{
		if(GetHitDice(oTarget) <= 5)
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DAZE));
				//Make SR check
				if (!HkResistSpell(OBJECT_SELF, oTarget))
				{
					//Make Will Save to negate effect
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS)) /*Will Save*/
					{
						//Apply VFX Impact and daze effect
						HkApplyEffectToObject( iDurType, eLink, oTarget, fDuration);
					}
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}


//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Charm
//:: nw_s0_icharm.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
		Charm
		Complete Arcane, pg. 132
		Spell Level: 4
		Class:      Misc

		You can beguile a creature within 60 feet. If the target fails a Will
		save theysuffer the effects of the Charm Monster spell (4th level wizard)
		except only one target can be affected at a given time.

		[Rules Note] In the rules this is a language dependent ability, but
		there is no concept of languages in NWN2.
*/
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"


void main()
{
	//scSpellMetaData = SCMeta_IN_charm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	//int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	effect eLink = HkGetScaledEffect(EffectCharmed(), oTarget);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
	if (CSLGetIsHumanoid(oTarget))
	{
		eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_CHARM_PERSON));
	}
	else
	{
		eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER));
	}
	int iDuration = HkGetScaledDuration(2  + HkGetSpellDuration( oCaster, 30, CLASS_TYPE_WARLOCK )/3, oTarget);
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CHARM_MONSTER));
		if (!HkResistSpell(oCaster, oTarget))
		{
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
			{
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELL_CHARM_MONSTER );
			}
		}
	}
	
	HkPostCast(oCaster);
}


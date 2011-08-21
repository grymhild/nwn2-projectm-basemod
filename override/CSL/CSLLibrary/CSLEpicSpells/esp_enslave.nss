//::///////////////////////////////////////////////
//:: Epic Spell: Enslave
//:: Author: Boneshank (Don Armstrong)
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void RemoveDomination(object oCreature, object oSlaver = OBJECT_SELF)
{
	effect eComp = SupernaturalEffect(EffectCutsceneDominated());
	effect e = GetFirstEffect(oCreature);

	while (GetIsEffectValid(e))
	{
		if (GetEffectType(e) == GetEffectType(eComp) && GetEffectCreator(e) == oSlaver)
		{
			RemoveEffect(oCreature, e);
		}
		e = GetNextEffect(oCreature);
	}
}




void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_ENSLAVE;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ENSLAVE))
	{
		
		object oTarget = HkGetSpellTarget();
		object oOldSlave = GetLocalObject(OBJECT_SELF, "EnslavedCreature");
		effect eDom = EffectCutsceneDominated();
		effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

		//Link domination and persistant VFX
		effect eLink = EffectLinkEffects(eMind, eDom);
		eLink = EffectLinkEffects(eLink, eDur);
		effect eLink2 = SupernaturalEffect(eLink);

		effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_MONSTER, FALSE));
		//Make sure the target is a monster
		if(!GetIsReactionTypeFriendly(oTarget))
		{
			//Make SR Check
			if (!HkResistSpell(OBJECT_SELF, oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS) && !GetIsImmune(oTarget, IMMUNITY_TYPE_DOMINATE) && !GetIsPC(oTarget))
			{
				//Make a Will Save
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget), SAVING_THROW_TYPE_MIND_SPELLS))
				{
				//Release old slave
				if (GetIsObjectValid(oOldSlave)) RemoveDomination(oOldSlave);

				//Apply linked effects and VFX Impact
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				SetLocalObject(OBJECT_SELF, "EnslavedCreature", oTarget);
				}
				else
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
			}
			else
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
		}
		else
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
	}
	HkPostCast(oCaster);
}

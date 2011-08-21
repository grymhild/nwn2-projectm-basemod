//::///////////////////////////////////////////////
//:: Epic Spell: Eternal Freedom
//:: Author: Boneshank (Don Armstrong)
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"
//#include "inc_dispel"


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_CSLCore_Items"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_ET_FREE;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ET_FREE))
	{
		
		object oTarget = HkGetSpellTarget();
		object oSkin;
		itemproperty ip1 = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS);
		itemproperty ip2 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_ENTANGLE);
		itemproperty ip3 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLOW);
		itemproperty ip4 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_MONSTER);
		itemproperty ip5 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON);
		itemproperty ip6 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLEEP);
		itemproperty ip7 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_ANIMAL);
		itemproperty ip8 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_POWER_WORD_STUN);
		itemproperty ip9 = ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_WEB);
		effect eDur = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);

		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FREEDOM_OF_MOVEMENT, FALSE));

		//Search for and remove the above negative effects
		effect eLook = GetFirstEffect(oTarget);
		while(GetIsEffectValid(eLook))
		{
			if(GetEffectType(eLook) == EFFECT_TYPE_PARALYZE ||
				GetEffectType(eLook) == EFFECT_TYPE_ENTANGLE ||
				GetEffectType(eLook) == EFFECT_TYPE_SLOW ||
				GetEffectType(eLook) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ||
				GetEffectType(eLook) == EFFECT_TYPE_PETRIFY ||
				GetEffectType(eLook) == EFFECT_TYPE_SLEEP ||
				GetEffectType(eLook) == EFFECT_TYPE_STUNNED)
			{
				RemoveEffect(oTarget, eLook);
			}
			eLook = GetNextEffect(oTarget);
		}
		//Apply properties.
		oSkin = CSLGetPCSkin(oTarget);
		CSLSafeAddItemProperty(oSkin, ip1);
		CSLSafeAddItemProperty(oSkin, ip2);
		CSLSafeAddItemProperty(oSkin, ip3);
		CSLSafeAddItemProperty(oSkin, ip4);
		CSLSafeAddItemProperty(oSkin, ip5);
		CSLSafeAddItemProperty(oSkin, ip6);
		CSLSafeAddItemProperty(oSkin, ip7);
		CSLSafeAddItemProperty(oSkin, ip8);
		CSLSafeAddItemProperty(oSkin, ip9);
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eDur), oTarget);

		DelayCommand(6.0, GiveFeat(oTarget, 398));
		FloatingTextStringOnCreature("You have gained the ability " +
							"to move freely at all times!", oTarget, FALSE);

	}
	HkPostCast(oCaster);
}


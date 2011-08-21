//::///////////////////////////////////////////////
//:: Primal Senses
//:: cmi_s0_primalsense
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 24, 2010
//:://////////////////////////////////////////////
//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PRIMAL_SENSES;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	object oTarget = HkGetSpellTarget();
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS) );

	effect eSkill1 = EffectSkillIncrease(SKILL_SPOT, 5);
	effect eSkill2 = EffectSkillIncrease(SKILL_LISTEN, 5);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_PREMONITION );
	effect eLink = EffectLinkEffects(eSkill1, eSkill2);
	eLink = EffectLinkEffects(eLink, eVis);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

	itemproperty iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_LOWLIGHTVISION);
	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oCaster);
	if (oArmorNew == OBJECT_INVALID)
	{
		oArmorNew = CreateItemOnObject("x2_it_emptyskin", oCaster, 1, "", FALSE);
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oArmorNew,fDuration);
		DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
		ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);
	}
	else
	{
		CSLSafeAddItemProperty(oArmorNew, iBonusFeat, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Favor of the Martyr
//:: cmi_s0_favormartyr
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 24, 2010
//:://////////////////////////////////////////////
//#include "x0_i0_spells"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_spells"

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FAVOR_MARTYR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );

	effect eCharm = EffectImmunity(IMMUNITY_TYPE_CHARM);
	effect eDom = EffectImmunity(IMMUNITY_TYPE_DOMINATE);
	effect eDaze = EffectImmunity(IMMUNITY_TYPE_CHARM);
	effect eStun = EffectImmunity(IMMUNITY_TYPE_STUN);
	effect eFati = EffectSpellImmunity(FATIGUE);
	effect eExh = EffectSpellImmunity(EXHAUSTED);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_PREMONITION );

	effect eLink = EffectLinkEffects(eCharm, eDom);
	eLink = EffectLinkEffects(eLink, eDaze);
	eLink = EffectLinkEffects(eLink, eStun);
	eLink = EffectLinkEffects(eLink, eFati);
	eLink = EffectLinkEffects(eLink, eExh);
	eLink = EffectLinkEffects(eLink, eVis);

	object oTarget = HkGetSpellTarget();	

	itemproperty iBonusFeat = ItemPropertyBonusFeat(92);
	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
	if (oArmorNew == OBJECT_INVALID)
	{
		oArmorNew = CreateItemOnObject("x2_it_emptyskin", oTarget, 1, "", FALSE);
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oArmorNew,fDuration);
		DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
		ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);
	}
	else
	{
		CSLSafeAddItemProperty(oArmorNew, iBonusFeat, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}
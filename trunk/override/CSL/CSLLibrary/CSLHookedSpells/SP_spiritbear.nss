//::///////////////////////////////////////////////
//:: Spirit of the Bear
//:: cmi_s0_spirbear
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
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
	int iSpellId = SPELL_SPIRIT_BEAR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_NONE | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 12);
	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 8);
	effect eAB = EffectAttackIncrease(2);
	effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_SLASHING);
	effect eAC = EffectACIncrease(7, AC_NATURAL_BONUS);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_PREMONITION );

	effect eLink = EffectLinkEffects(eStr, eDex);
	eLink = EffectLinkEffects(eLink, eCon);
	eLink = EffectLinkEffects(eLink, eAB);
	eLink = EffectLinkEffects(eLink, eDmg);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eVis);

	itemproperty iBonusFeat1 = ItemPropertyBonusFeat(386); //Blind-Fight
	itemproperty iBonusFeat2 = ItemPropertyBonusFeat(16); //Power Attack
	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oCaster);
	if (oArmorNew == OBJECT_INVALID)
	{
		oArmorNew = CreateItemOnObject("x2_it_emptyskin", oCaster, 1, "", FALSE);
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat1,oArmorNew,fDuration);
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat2,oArmorNew,fDuration);
		DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
		ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);
	}
	else
	{
		CSLSafeAddItemProperty(oArmorNew, iBonusFeat1, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		CSLSafeAddItemProperty(oArmorNew, iBonusFeat2, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
	SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	
	CSLConstitutionBugCheck( oCaster );
	
	HkPostCast(oCaster);
}
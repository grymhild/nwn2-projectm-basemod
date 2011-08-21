//::///////////////////////////////////////////////
//:: Champion of the Silver Flame, Blessing of the Champion
//:: cmi_s2_cotsfbless
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Aug 16, 2009
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_chars"
//#include "cmi_ginc_spells"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_COTSF_BLESSING_CHAMP;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId, -iSpellId );
	//if (GetHasSpellEffect(iSpellId,oCaster))
	//	RemoveSpellEffects(iSpellId, oCaster, oCaster);

	int nLevel = GetLevelByClass(CLASS_CHAMP_SILVER_FLAME, oCaster);
	
	effect eLink = EffectAttackIncrease(1);
	
	effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);			
	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmg, oCaster, HoursToSeconds(48), -iSpellId, oCaster ));
	

	if (nLevel > 9)
	{
		effect eSave2 = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
		effect eAC = EffectACIncrease(2);
		effect eSR = EffectSpellResistanceIncrease(12 + GetHitDice(oCaster));

		effect eDmg3 = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_DIVINE);
		effect eDmg2 = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
		eLink = EffectLinkEffects(eLink, eSave);
		eLink = EffectLinkEffects(eLink, eDmg2);
		eLink = EffectLinkEffects(eLink, eDmg3);
		eLink = EffectLinkEffects(eLink, eSave2);
		eLink = EffectLinkEffects(eLink, eAC);
		eLink = EffectLinkEffects(eLink, eSR);
	}
	else
	if (nLevel > 8)
	{
		effect eDmg3 = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_DIVINE);
		effect eDmg2 = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
		eLink = EffectLinkEffects(eLink, eSave);
		eLink = EffectLinkEffects(eLink, eDmg2);
		eLink = EffectLinkEffects(eLink, eDmg3);
	}
	else
	if (nLevel > 5)
	{
		effect eDmg2 = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
		eLink = EffectLinkEffects(eLink, eSave);
		eLink = EffectLinkEffects(eLink, eDmg2);
	}
	else
	if (nLevel > 2)
	{
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
		eLink = EffectLinkEffects(eLink, eSave);
	}

	//eLink = SetEffectSpellId(eLink,iSpellId);
	//eLink = SupernaturalEffect(eLink);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HoursToSeconds(48), iSpellId ));

	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Way of the Kinslayer
//:: cmi_s2_charnag
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: November 1st, 2010
//:://////////////////////////////////////////////

//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nSpellId = SPELLABILITY_CHARNAG_WAY_KINSLAYER;
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, nSpellId );
	

	int nCharnag = GetLevelByClass(CLASS_CHARNAG_MAELTHRA, OBJECT_SELF);

	effect eAC = EffectACIncrease(1);
	effect eAB = EffectAttackIncrease(1);
	effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2);

	if (nCharnag > 2)
		eAC = EffectLinkEffects(eAC, eAB);
	if (nCharnag > 4)
		eAC = EffectLinkEffects(eAC, eDmg);

	eAC = SetEffectSpellId(eAC,nSpellId);
	eAC = SupernaturalEffect(eAC);

	DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, OBJECT_SELF, HoursToSeconds(72)));

}
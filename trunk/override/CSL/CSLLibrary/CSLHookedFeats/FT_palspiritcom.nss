//::///////////////////////////////////////////////
//:: Paladin - Spirit of Combat
//:: cmi_s2_spircombat
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 1, 2009
//:://////////////////////////////////////////////
//#include "nwn2_inc_spells"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_includes"


#include "_HkSpell"
#include "_SCInclude_Class"

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
	
	int nSpellId = SPELLABILITY_PALADIN_SPIRIT_COMBAT;

	int nPaladin = GetLevelByClass(CLASS_TYPE_PALADIN);
	int nBonus = nPaladin/4;
	if (nBonus <= 0)
		nBonus = 1;
	float fDuration = RoundsToSeconds(nPaladin);

	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLESS);

	effect eAttack = EffectAttackIncrease(nBonus);
	effect eDmg = EffectDamageIncrease(CSLGetDamageBonusConstantFromNumber(nBonus), DAMAGE_TYPE_DIVINE);

	effect eLink = EffectLinkEffects(eAttack, eDmg);
	eLink = EffectLinkEffects(eLink, eVis);
	eLink = SetEffectSpellId(eLink,nSpellId);
	eLink = SupernaturalEffect(eLink);

	float fDelay;
	location lLoc = HkGetSpellTargetLocation();

	//Get the first target in the radius around the caster
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			fDelay = CSLRandomBetweenFloat(0.4f, 1.1f);
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
	}
}
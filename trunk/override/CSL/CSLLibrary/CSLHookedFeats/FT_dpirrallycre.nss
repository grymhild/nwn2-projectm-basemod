//::///////////////////////////////////////////////
//:: Blessing of the Righteous
//:: cmi_s0_blessright
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////
//#include "cmi_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"


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
	
	if (GetHasSpellEffect(SPELLABILITY_SONG_INSPIRE_COURAGE,OBJECT_SELF))
	{
		SendMessageToPC(OBJECT_SELF, "You may not use Rally the Crew while under the effect of Inspire Courage");
		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_DRPIRATE_RALLY_THE_CREW_1);
		return;
	}

	int nSpellId = SPELLABILITY_DRPIRATE_RALLY_THE_CREW;
	int nCasterLvl = GetLevelByClass(CLASS_DREAD_PIRATE, OBJECT_SELF);

	float fDuration = TurnsToSeconds( nCasterLvl );
	int nBonus = 1;
	if (nCasterLvl > 6)
		nBonus = 2;

	effect eAB = EffectAttackIncrease(nBonus);
	effect eDmgBonus = EffectDamageIncrease(nBonus, DAMAGE_TYPE_MAGICAL);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
	effect eLink = EffectLinkEffects(eDmgBonus,eVis);
	eLink = EffectLinkEffects(eLink, eAB);
	eLink = SetEffectSpellId(eLink, nSpellId);
	eLink = SupernaturalEffect(eLink);


	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellId, FALSE));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}

	//DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DRPIRATE_RALLY_THE_CREW_1);
}
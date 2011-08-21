//::///////////////////////////////////////////////
//:: Insignia of Healing
//:: cmi_s0_insgheal
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
	int iSpellId = SPELL_INSIGNIA_HEALING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_RESTORATIVE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iSpellPower = HkGetSpellPower( oCaster, 10 );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	location lLocation = GetLocation(oCaster);
	float fDelay;
	effect eHeal;
	effect eVis = EffectVisualEffect(VFX_IMP_HEALING_S);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocation);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			eHeal = EffectHeal(d8() + iSpellPower);
			fDelay = CSLRandomBetweenFloat(0.4, 1.1);
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			DelayCommand(fDelay, CSLRemoveEffectByType_Void(oTarget, EFFECT_TYPE_WOUNDING));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocation);
	}
	
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Epic Mage Armor
//:: X2_S2_EpMageArm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the target +20 AC Bonus to Deflection,
	Armor Enchantment, Natural Armor and Dodge.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////

/*
	Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_EP_M_AR;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, iSpellId))
	{
		object oTarget = HkGetSpellTarget();
		int nDuration = HkGetCasterLevel(OBJECT_SELF);
		effect eVis = EffectVisualEffect(495);
		effect eAC;
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId(), FALSE));

		//Set the four unique armor bonuses
		eAC = EffectACIncrease(20, AC_ARMOUR_ENCHANTMENT_BONUS);
		effect eDur = EffectVisualEffect(VFX_DUR_SANCTUARY);

		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, iSpellId );

		// * Brent, Nov 24, making extraodinary so cannot be dispelled
		eAC = ExtraordinaryEffect(eAC);

		//Apply the armor bonuses and the VFX impact
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oTarget, HoursToSeconds(nDuration) );
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0 );
	}
	HkPostCast(oCaster);
}

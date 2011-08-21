//::///////////////////////////////////////////////
//:: Drown
//:: [X0_S0_Drown.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	if the creature fails a FORT throw.
	Does not work against Undead, Constructs, or Elementals.

January 2003:
- Changed to instant kill the target.
May 2003:
- Changed damage to 90% of current HP, instead of instant kill.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 26 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003
//#include "NW_I0_SPELLS"
//#include "x2_inc_spellhook"


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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();
	int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);
	int nDam = GetCurrentHitPoints(oTarget);
	//Set visual effect
	effect eVis = EffectVisualEffect( VFX_HIT_DROWN );
	effect eDam;
	//Check faction of target
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 437));
		//Make SR Check
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			// * certain racial types are immune
			if ((GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
				&&(GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
				&&(GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL))
			{
				//Make a fortitude save
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
				{
				nDam = FloatToInt(nDam * 0.9);
				eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

				}
			}
		}
	}
	HkPostCast(oCaster);
}
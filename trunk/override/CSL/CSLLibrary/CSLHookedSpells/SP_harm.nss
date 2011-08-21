//::///////////////////////////////////////////////
//:: [Harm]
//:: [NW_S0_Harm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reduces target to 1d4 HP on successful touch
//:: attack.  If the target is undead it is healed.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Last Update: Georg Zoeller On: Oct 10, 2004
//:://////////////////////////////////////////////
//:: Update Pass By: Brock H. - OEI - 08/17/05
/*
	5.2.6.1.2   Harm
	This spell works very differently now. Negative energy deals 10 damage
	per caster level (maximum 150). If the target makes a successful Will save,
	they only take half damage and can't be reduced below 1 hit point.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Healing"





void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HARM;
	int iClass = CLASS_TYPE_NONE;
	//if ( GetSpellId() == SPELLABILITY_UNDEADSELFHARM )
	//{
	//	// iDescriptor = SCMETA_DESCRIPTOR_POSITIVE;
	//}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel  = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget    = HkGetSpellTarget();
	SCHealHarmTarget(oTarget, iCasterLevel, SPELL_HARM, FALSE);
	
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Armor of Undeath (b) - hearbeat
//:: sg_s0_armundb.nss
//:: 2002 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	creates magical armor from remains of a humanoid.
	Spell is removed if caster takes 25 hp of damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 24, 2003
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_wrappers"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	
	int iCurrTargetHP=GetCurrentHitPoints(oTarget);
	int iStartingHP=GetLocalInt(oTarget,"ARMUND_HP");
	int iAmtUsed = GetLocalInt(oTarget, "ARMUND_USED");

	if(GetIsObjectValid(oTarget))
	{
		if(iStartingHP-iCurrTargetHP>=25 || (iStartingHP-iCurrTargetHP)<iAmtUsed)
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_ARMOR_UNDEATH );
			DeleteLocalInt(oTarget,"ARMUND_HP");
			DeleteLocalInt(oTarget,"ARMUND_USED");
		}
		else if(iCurrTargetHP<iStartingHP)
		{
			SetLocalInt(oTarget, "ARMUND_USED", iStartingHP-iCurrTargetHP);
		}
	}
}



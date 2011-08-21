//::///////////////////////////////////////////////
//:: Hellfire Blast
//:: nx2_s0_hlfrblst
//:: Copyright (c) 2008 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Hellfire Warlock can turn on Hellfire Blast
	to get 2*HellfireWarlockLevel d6 bonus to all
	Eldritch Blasts. This spell cast once will
	turn all eldritch blasts into Hellfire Blasts
	until cast again, which will turn it off.
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 06/18/2008
//:://////////////////////////////////////////////
//#include "nw_i0_invocatns"

#include "_HkSpell"
#include "_SCInclude_Invocations"

const int STRREF_HELLFIRE_GO 	= 220794;
const int STRREF_HELLFIRE_STOP = 220795;

// THUNDERCATS HOOOOOOOOOOO!
void HellfirePowersGo(int nString)
{
	string sLocalizedText = GetStringByStrRef( nString );
	string sDiceBonus = " ("+IntToString(GetHellfireBlastDiceBonus())+"d6)";
	string sName = GetName( OBJECT_SELF );
	string sHellfireFeedbackMsg = "<c=tomato>" + sName + sLocalizedText + " </c>";
	if (nString == STRREF_HELLFIRE_STOP)
		sHellfireFeedbackMsg + sDiceBonus;
	SendMessageToPC( OBJECT_SELF, sHellfireFeedbackMsg );
}




void main()
{	
	SendMessageToPC( OBJECT_SELF, "This spell should not work, and needs to be pulled, make a note if you see this in game so i know it's actually something that should work -- Pain" );
	
	/*
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_HELLFIRE_BLAST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_ELDRITCH;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	object oTarget = HkGetSpellTarget();
	int nCurrCon = GetAbilityScore( oTarget, ABILITY_CONSTITUTION );
	// if feat is active, turn it off
	//if ( GetHasFeatEffect(FEAT_HELLFIRE_BLAST) == TRUE )
	if ( IsHellfireBlastActive(oTarget) )
	{
		// this won't remove the CON down because they're not attached
		// to the hlfrblst spell ID
		CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
		HellfirePowersGo(STRREF_HELLFIRE_STOP);
	}
	// else turn it on!
	else
	{
		if ( nCurrCon > 0 )
		{
			SignalEvent(oTarget, EventSpellCastAt(oTarget, iSpellId, FALSE));
			// ?? What the hellp is this lol
			
			//effect e = EffectHellfireBlast();
			//	effect evfx = EffectVisualEffect(VFX_AURA_BLADE_BARRIER);
			//FloatingTextStringOnCreature("NEEDS VISUAL EFFECT", oTarget);
			//	effect eLink = EffectLinkEffects(evfx, e);
			//e = SetEffectSpellId(e, iSpellId);
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, e , oTarget);
			//HellfirePowersGo(STRREF_HELLFIRE_GO);
		}
		else
		{
			// ConTooLow(STRREF_HELLFIRE_BLAST_NAME);
		}
	}

	HkPostCast(oCaster);
	*/
}
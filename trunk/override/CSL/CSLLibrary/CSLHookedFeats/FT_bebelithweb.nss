//::///////////////////////////////////////////////
//:: Bebelith Web
//:: NW_S0_Web.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a mass of sticky webs that cling to
	and entangle target who fail a Reflex Save
	Those caught can make a new save every
	round.  Movement in the web is 1/6 normal.
	The higher the creatures Strength the faster
	they move out of the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_bebelithweb();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	int iDuration = CSLGetMax( 1, GetHitDice(OBJECT_SELF) / 2 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_PER_WEB, "x2_s1_bebweba", "x2_s1_bebwebc", "x2_s1_bebwebb", sAOETag);

	location lTarget = HkGetSpellTargetLocation();
	
	
		
	
	
	//Create an instance of the AOE Object using the Apply Effect function
	HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration );
	
	HkPostCast(oCaster);
}
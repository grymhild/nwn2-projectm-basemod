//::///////////////////////////////////////////////
//:: Glyph of Warding
//:: x2_s0_glphwarda.nss
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	The caster creates a trapped area which detects
	the entrance of enemy creatures into 3 m area
	around the spell location.  When tripped it
	causes an explosion that does 1d8 per
	two caster levels up to a max of 5d8 damage.
	Damage type is dependent on caster alignment.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: August 01, 2006
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_glyphwarding();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GLYPH_OF_WARDING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster, 10 );
	location lTarget = HkGetSpellTargetLocation();
	
	if ( CSLGetNearestAOE(lTarget, RADIUS_SIZE_HUGE)!=OBJECT_INVALID )
	{
		SendMessageToPC(OBJECT_SELF, "You cannot stack this AOE on top of another AOE.");
		return;
	}
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	//Define the AOE and then place it at the location permanently (until triggered)
	effect eAOE = EffectAreaOfEffect( AOE_PER_GLYPH_OF_WARDING, "", "", "", sAOETag );
	DelayCommand( 0.1f, HkApplyEffectAtLocation( DURATION_TYPE_PERMANENT, eAOE, lTarget ) );
	
	HkPostCast(oCaster);
}


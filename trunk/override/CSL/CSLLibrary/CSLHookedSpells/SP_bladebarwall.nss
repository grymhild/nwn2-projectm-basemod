//::///////////////////////////////////////////////
//:: Blade Barrier, Wall
//:: NW_S0_BladeBarWall.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a wall 10m long and 2m thick of whirling
	blades that hack and slice anything moving into
	them.  Anything caught in the blades takes
	2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 08.10.06 - Adapted to new functionality
//:: PKM-OEI 08.31.06 - Stacking rules

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_bladebarwall();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLADE_BARRIER_WALL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iImpactSEF = VFX_HIT_SPELL_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	

	int iSpellPower = HkGetSpellPower( oCaster, 15 );
	
		
	
	location lTarget = HkGetSpellTargetLocation();
	
	float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds( HkGetSpellDuration( oCaster ) ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, TRUE  );
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_WALLBLADE, "", "", "", sAOETag );
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	DelayCommand( 0.1f, HkApplyEffectAtLocation(iDurType, eAOE, lTarget, fDuration ) );
	
	HkPostCast(oCaster);
}


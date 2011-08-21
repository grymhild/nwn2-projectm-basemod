//::///////////////////////////////////////////////
//:: Wall of Fire
//:: NW_S0_WallFire.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a wall of fire that burns any creature
	entering the area around the wall.  Those moving
	through the AOE are burned for 4d6 fire damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 17, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_wallfire();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WALL_OF_FIRE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_ELEMENTAL;
	if ( GetSpellId() == SPELL_SHADES_WALL_OF_FIRE )
	{
		// iSpellId=SPELL_SHADES_WALL_OF_FIRE;
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster, 20 );
		
	//Get the location where the wall is to be placed.
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = CSLGetMax( 1, HkGetSpellDuration(OBJECT_SELF)/2 );
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( AOE_PER_WALLFIRE, SC_SHAPE_WALL ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	/////////////////////////////////////////////////////////////////////////////////
	
	//--------------------------------------------------------------------------
	// Area of Effect
	//--------------------------------------------------------------------------
	string sAOETag = HkAOETag( oCaster, GetSpellId(), iSpellPower,  fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect(iShapeEffect, "", "", "", sAOETag);
	
	//Create the Area of Effect Object declared above.
	DelayCommand( 0.1f, HkApplyEffectAtLocation(iDurType, eAOE, lTarget, fDuration ) );
	DelayCommand( 1.5f, SetLocalInt( GetObjectByTag( sAOETag ), "CSL_ENVIRO", CSL_ENVIRO_FIRE ) );
	
	HkPostCast(oCaster);
}


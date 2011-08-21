//::///////////////////////////////////////////////
//:: Ball Lightning
//:: SOZ UPDATE BTM
//:: x2_s0_balllghtng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 10 missiles, each doing 1d6 damage to all
 targets in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By:
// ChazM 1/29/07 - updated call to DoMissileStorm() w/ new interface

#include "_HkSpell"
#include "_SCInclude_Evocation"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BALL_LIGHTNING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iShapeEffect = HkGetShapeEffect( VFX_IMP_LIGHTNING_S, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	
	//Declare major variables
	
	
   //SpawnScriptDebugger();                         503
   // old prototype and instance
	//void DoMissileStorm(int nD6Dice, int nCap, int iSpellId, int nMIRV = VFX_IMP_MIRV, int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE, int nReflexSave = FALSE, int nMaxHits = 10 );
    //DoMissileStorm(1, 15, GetSpellId(), 503,VFX_IMP_LIGHTNING_S ,iDamageType, FALSE, TRUE );

   // new prototype and instance
	//void DoMissileStorm(int nD6Dice, int nCap, int iSpellId, int nVIS = VFX_IMP_MAGBLUE, int iDamageType = DAMAGE_TYPE_MAGICAL, int iReflexSaveType = -1, int nMaxHits = 10 )
    SCDoMissileStorm(1, 15, iSpellId, iShapeEffect, iDamageType, iSaveType);
    
    HkPostCast(oCaster);
}
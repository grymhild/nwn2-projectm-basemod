//////////////////////////////////////////
// Author: Drammel						//
// Date: 8/25/2009						//
// Title: TB_sa_holo_cloak				//
// Description: Grants the feat Scent	//
//	while the Stance is active.			//
//////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void HolocaustCloak(object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1)
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "HOLOCAUSTCLOAK", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "HOLOCAUSTCLOAK" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,15))
	{
		effect eCloak = EffectDamageShield(5, 0, DAMAGE_TYPE_FIRE);
		effect eFire = EffectVisualEffect(VFX_TOB_HOLOCLOAK);
		eCloak = SupernaturalEffect(eCloak);

		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCloak, oPC, 6.0f);
		DelayCommand(6.0f, HolocaustCloak( oPC, oToB, iSpellId, iSerial ));
	}
}


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	effect eFire = EffectVisualEffect(VFX_TOB_HOLOCLOAK);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oPC, 12.0f);
	HolocaustCloak(oPC, oToB);
}

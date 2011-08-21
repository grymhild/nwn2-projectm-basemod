//////////////////////////////////////////////////////
//	Author: Drammel									//
//	Date: 3/29/2009									//
//	Title: TB_shadblade							//
//	Description: While in a Shadow Hand stance, 	//
//	apply Dex mod to weapon damage.					//
//////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "bot9s_inc_variables"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void ShadowBlade( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "SHADOWBLADE", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "SHADOWBLADE" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6508);

	if (TOBGetIsShadowBladeValid(oRightHand))
	{
		int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oPC);

		if (nDexMod > 0) //Only do this if it actually matters.
		{
			object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
			int nBonus, nDamage;

			if (!GetIsObjectValid(oLeftHand))
			{
				//Two-Handed
				nBonus = ((nDexMod * 3)/2);
			}
			else
			{
				//One-Handed
				nBonus = nDexMod;
			}

			nDamage = CSLGetDamageBonusConstantFromNumber(nBonus);

			int nWeapon = GetWeaponType(oRightHand);

			if (nWeapon == WEAPON_TYPE_PIERCING_AND_SLASHING || nWeapon == WEAPON_TYPE_PIERCING)
			{
				effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_PIERCING);
				eDamage = SupernaturalEffect(eDamage);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 6.0f);
			}
			else if (nWeapon == WEAPON_TYPE_SLASHING)
			{
				effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_SLASHING);
				eDamage = SupernaturalEffect(eDamage);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 6.0f);
			}
			else
			{
				effect eDamage = EffectDamageIncrease(nDamage, DAMAGE_TYPE_BLUDGEONING);
				eDamage = SupernaturalEffect(eDamage);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamage, oPC, 6.0f);
			}
		}
	}

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, ShadowBlade(oPC, oToB, iSpellId, iSerial));
}

void CheckLoopEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6508, oPC))
	{
		ShadowBlade(oPC); //Only runs if the effect is no longer on the player.
	}
}



void main()
{	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC); // get the TOME
	//--------------------------------------------------------------------------
	
	DelayCommand(6.0f, CheckLoopEffect(oPC, oToB)); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}

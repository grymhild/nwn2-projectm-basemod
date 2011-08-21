//////////////////////////////////////////////////////////
//	Author: Drammel										//
//	Date: 9/1/2009										//
//	Title: TB_sa_crushing_wotm								//
//	Description: While you are in this stance, you gain //
// the ability to constrict for 2d6 points of damage + //
// 1-1/2 times your Str bonus (if any). You can 		//
// constrict an opponent that you grapple by making a //
// successful grapple check.							//
//////////////////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_maneuvers"
//#include "bot9s_include"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void CrushingWeightOfTheMountain( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "CRUSHINGWEIGHTOFTHEMOUNTAIN", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "CRUSHINGWEIGHTOFTHEMOUNTAIN" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	if (hkStanceGetHasActive(oPC,149))
	{
		object oTarget = IntToObject(GetLocalInt(oToB, "CrushingWotM"));
		float fDist = GetDistanceBetween(oPC, oTarget) - CSLGetGirth(oTarget);
		float fRange = CSLGetMeleeRange(oPC);
		int nTouch = TouchAttackMelee(oTarget, FALSE);

		if ((nTouch > 0) && (fDist <= fRange))
		{
			int nAbility = GetAbilityModifier(ABILITY_STRENGTH, oPC);
			int nFoeAbility = GetAbilityModifier(ABILITY_STRENGTH, oTarget);
			int nMySize = GetCreatureSize(oPC);
			int nFoeSize = GetCreatureSize(oTarget);
			int nBonus, nFoeBonus;

			if (nMySize > CREATURE_SIZE_MEDIUM)
			{
				nBonus += (nMySize - CREATURE_SIZE_MEDIUM) * 4;
			}
			else if (nMySize < CREATURE_SIZE_MEDIUM)
			{
				nBonus -= (CREATURE_SIZE_MEDIUM - nMySize) * 4;
			}

			if (nFoeSize > CREATURE_SIZE_MEDIUM)
			{
				nFoeBonus += (nFoeSize - CREATURE_SIZE_MEDIUM) * 4;
			}
			else if (nFoeSize < CREATURE_SIZE_MEDIUM)
			{
				nFoeBonus -= (CREATURE_SIZE_MEDIUM - nFoeSize) * 4;
			}

			int nMyBAB = GetTRUEBaseAttackBonus(oPC);
			int nFoeBAB = GetTRUEBaseAttackBonus(oTarget);
			int nMyd20 = d20(1);
			int nFoed20 = d20(1);
			int nMyRoll = nMyBAB + nAbility + nBonus + nMyd20;
			int nFoeRoll = nFoeBAB + nFoeAbility + nFoeBonus + nFoed20;

			if (nMyRoll >= nFoeRoll)
			{
				object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
				int nStr;

				if (!GetIsObjectValid(oLeft))
				{
					float fAbility = IntToFloat(nAbility);
					nStr = FloatToInt(1.5f * fAbility);
				}
				else nStr = nAbility;

				effect eDamage = EffectDamage(d6(2) + nStr, DAMAGE_TYPE_BLUDGEONING);
				effect eVis = EffectVisualEffect(VFX_TOB_CRUSHING_WOTM);

				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
		DelayCommand(6.0f, CrushingWeightOfTheMountain(oPC, oToB, iSpellId, iSerial));
	}
	else DeleteLocalInt(oToB, "CrushingWotM");
}


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the Maneuver
	//--------------------------------------------------------------------------
	int iSpellId = -1;
	object oPC = OBJECT_SELF;
	object oToB = CSLGetDataStore(oPC);
	//--------------------------------------------------------------------------
	
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));

	SetLocalInt(oToB, "CrushingWotM", ObjectToInt(oTarget));

	if (GetIsReactionTypeHostile(oTarget, oPC))
	{
		CrushingWeightOfTheMountain(oPC, oToB);
	}
	else SendMessageToPC(oPC, "<color=red>You can only select a hostile enemy with this maneuver.</color>");
}

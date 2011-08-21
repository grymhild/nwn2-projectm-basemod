//////////////////////////////////////////////
//	Author: Drammel 							//
//	Date: 4/15/2009 						//
//	Title: TB_swordsageac						//
//	Description: Grants a wisdom bonus to AC//
//	while the swordsage is wearing light or	//
//	less armor and has no shield equipped.	//
//////////////////////////////////////////////
//#include "bot9s_inc_constants"
//#include "bot9s_inc_feats"
//#include "tob_i0_spells"
#include "_HkSpell"
#include "_SCInclude_TomeBattle"

void ApplySSAC(int nWisdom)
{
	object oPC = OBJECT_SELF;
	effect eAC = EffectACIncrease(nWisdom, AC_SHIELD_ENCHANTMENT_BONUS); // Valid vs flatfoot and we're not using a shield anyway.
	eAC = SupernaturalEffect(eAC);
	eAC = SetEffectSpellId(eAC, SPELL_FEAT_SSAC);

	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
}

void RemoveSSAC()
{
	object oPC = OBJECT_SELF;
	effect eTest;
	int nSpell;

	eTest = GetFirstEffect(oPC);

	while (GetIsEffectValid(eTest))
	{
		nSpell = GetEffectSpellId(eTest);

		if (nSpell == SPELL_FEAT_SSAC)
		{
			RemoveEffect(oPC, eTest);
			eTest = GetFirstEffect(oPC); // Clean up supernatural effects.
		}
		else eTest = GetNextEffect(oPC);
	}
}

void CheckSSAC()
{
	object oPC = OBJECT_SELF;
	int nWisdom = GetAbilityModifier(ABILITY_WISDOM);

	effect eTest, eCheck;
	int nSpell, nTest, nEffect, nArmor, nWis;

	eTest = GetFirstEffect(oPC);
	nTest = 0;

	while (GetIsEffectValid(eTest))
	{
		nSpell = GetEffectSpellId(eTest);
		nEffect = GetEffectType(eTest);

		if (nSpell == SPELL_FEAT_SSAC)
		{
			eCheck = eTest;
		}
		else if (nEffect == EFFECT_TYPE_AC_INCREASE)
		{// nIdx zero seems to return the AC constant value rather than the bonus integer. For this effect, the positions appear to be reversed.
			nArmor = GetEffectInteger(eTest, 1);

			if (nArmor == AC_SHIELD_ENCHANTMENT_BONUS)
			{// If we're past the first check, this cannot be the sheild AC effect bonus we're looking for.
				nTest = 1;
			}
		}
		else if (nEffect == EFFECT_TYPE_ENTANGLE || nEffect == EFFECT_TYPE_PARALYZE
		|| nEffect == EFFECT_TYPE_PETRIFY || nEffect == EFFECT_TYPE_DAZED
		|| nEffect == EFFECT_TYPE_CUTSCENE_PARALYZE || nEffect == EFFECT_TYPE_STUNNED
		|| nEffect == EFFECT_TYPE_TIMESTOP || nEffect == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE)
		{
			nTest = 1;
		}

		eTest = GetNextEffect(oPC);
	}

	if (GetIsEffectValid(eCheck))
	{
		nWis = GetEffectInteger(eCheck, 1);

		if (nTest == 1 || nWisdom < 1)
		{
			RemoveSSAC();
		}
		else if ((nWis != nWisdom) && (nWisdom > 0))
		{
			RemoveSSAC();
			DelayCommand(0.1f, ApplySSAC(nWisdom));
		}
	}
	else if (nTest == 0)
	{
		ApplySSAC(nWisdom);
	}
}

void SwordsageAC( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
{
	// void LoopFunction( object oPC = OBJECT_SELF, object oToB = OBJECT_INVALID, int iSpellId = -1, int iSerial = -1 )
	// oPC, oToB, iSpellId, iSerial
	if ( !GetIsObjectValid( oPC ) || !CSLSerialRepeatCheck( oPC, "SWORDSAGEAC", iSerial ) )
	{
		// either no target or a new loop is replacing the old
		return;
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oPC, "SWORDSAGEAC" );
		if ( !GetIsObjectValid( oToB ) ) 
		{
			oToB = CSLGetDataStore(oPC);
		}
	}
	
	
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	object oOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	int nArmor = GetArmorRank(oArmor);
	int nOffhand = GetBaseItemType(oOffhand);

	if ((GetHasFeat(FEAT_MONK_AC_BONUS)) && (nArmor == ARMOR_RANK_NONE))
	{
		RemoveSSAC();
	}
	else if (nOffhand == BASE_ITEM_LARGESHIELD || nOffhand == BASE_ITEM_SMALLSHIELD
	|| nOffhand == BASE_ITEM_TOWERSHIELD)
	{
		RemoveSSAC();
	}
	else if (nArmor <= ARMOR_RANK_LIGHT)
	{
		CheckSSAC();
	}

	effect eLoop = EffectVisualEffect(VFX_TOB_BLANK); // Paceholder effect to detect the recursive loop.
	eLoop = SupernaturalEffect(eLoop);
	eLoop = SetEffectSpellId(eLoop, 6562);

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLoop, oPC, 6.0f);
	DelayCommand(6.0f, SwordsageAC(oPC, oToB, iSpellId, iSerial));
}

void CheckEffect( object oPC, object oToB = OBJECT_INVALID )
{
	if(!TOBCheckRecursive(6562, oPC))
	{
		SwordsageAC(oPC); //Only runs if the effect is no longer on the player.
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
	
	DelayCommand(6.0f, CheckEffect(oPC)); // Needs to be delayed because when the feat fires after resting the engine doesn't detect effects immeadiately.
}

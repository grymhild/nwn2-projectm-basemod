/** @file
* @brief Include file for Barbarians and Rage related functions
*
* 
* 
*
* @ingroup scinclude
* @author Brian T. Meyer and others
*/



#include "_HkSpell"

#include "_CSLCore_Items"
#include "_CSLCore_ObjectVars"

//------------------------------------------------------------------------------
// GZ, 2003-07-09
// If the character calling this function from a spellscript has the thundering
// rage feat, his weapons are upgraded to deafen and cause 2d6 points of massive
// criticals
//------------------------------------------------------------------------------
// AFW-OEI 03/06/2007: Now does 2d6 massive critical and no deafness.
void SCCheckAndApplyThunderingRage(int nRounds)
{
	if (GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, OBJECT_SELF))
	{
			object oWeapon =  GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
			if (GetIsObjectValid(oWeapon))
			{
				CSLSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6),
											RoundsToSeconds(nRounds),SC_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
				CSLSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), RoundsToSeconds(nRounds),
											SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
				/*
				CSLSafeAddItemProperty(oWeapon, ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS,IP_CONST_ONHIT_SAVEDC_14,IP_CONST_ONHIT_DURATION_100_PERCENT_3_ROUND),
											RoundsToSeconds(nRounds), SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
				*/
			}

			oWeapon =  GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
			if (GetIsObjectValid(oWeapon) )
			{
				CSLSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d6),
											RoundsToSeconds(nRounds),SC_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
				CSLSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), RoundsToSeconds(nRounds),
											SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
				/*
				CSLSafeAddItemProperty(oWeapon, ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS,IP_CONST_ONHIT_SAVEDC_14,IP_CONST_ONHIT_DURATION_100_PERCENT_3_ROUND),
											RoundsToSeconds(nRounds), SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
				*/
			}
		}
}

//------------------------------------------------------------------------------
// GZ, 2003-07-09
// If the character calling this function from a spellscript has the terrifying
// rage feat, he gets an aura of fear for the specified duration
// The saving throw against this fear is a check opposed to the character's
// intimidation skill
//------------------------------------------------------------------------------
void SCCheckAndApplyTerrifyingRage(int nRounds)
{
	object oCaster = OBJECT_SELF;	
	if (GetHasFeat(989, oCaster))
	{
			
			int iSpellPower = HkGetSpellPower( oCaster );
			string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower,  -1.0f,FALSE  );
			
			effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR,"x2_s2_terrage_A", "","", sAOETag);
			eAOE = ExtraordinaryEffect(eAOE);
			HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAOE,oCaster,RoundsToSeconds(nRounds), -989);
	}
}


//------------------------------------------------------------------------------
// GZ, 2003-07-09
// Hub function for the epic barbarian feats that upgrade rage. Call from
// the end of the barbarian rage spellscript
//------------------------------------------------------------------------------
void SCCheckAndApplyEpicRageFeats(int nRounds)
{
	SCCheckAndApplyThunderingRage(nRounds);
	SCCheckAndApplyTerrifyingRage(nRounds);
}

int SCThunderWeapon(int nSlot, int nRounds, int nMassive)
{
	object oWeapon =  GetItemInSlot(nSlot);
	if (!GetIsObjectValid(oWeapon)) return FALSE;
	CSLSafeAddItemProperty(oWeapon, ItemPropertyMassiveCritical(nMassive), RoundsToSeconds(nRounds),SC_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
	CSLSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_SONIC), RoundsToSeconds(nRounds), SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
	return TRUE;
}

void SCApplyThunderingRage(object oBarb, int iLevel, int nRounds)
{
	int nSonic;
	int nMassive;
	if (iLevel<20)
	{
		nSonic   = DAMAGE_BONUS_1d4; //IP_CONST_DAMAGEBONUS_1d4;
		nMassive = IP_CONST_DAMAGEBONUS_1d6;
	}
	else if (iLevel<25)
	{
		nSonic   = DAMAGE_BONUS_1d6; //IP_CONST_DAMAGEBONUS_1d6;
		nMassive = IP_CONST_DAMAGEBONUS_2d4;
	}
	else if (iLevel<30)
	{
		nSonic   = DAMAGE_BONUS_2d4; //IP_CONST_DAMAGEBONUS_2d4;
		nMassive = IP_CONST_DAMAGEBONUS_1d10;
	}
	else
	{
		nSonic   = DAMAGE_BONUS_1d10; //IP_CONST_DAMAGEBONUS_1d10;
		nMassive = IP_CONST_DAMAGEBONUS_2d6;
	}
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(nSonic, DAMAGE_TYPE_SONIC ), oBarb);
	if (SCThunderWeapon(INVENTORY_SLOT_RIGHTHAND, nRounds, nMassive))
	{
		SCThunderWeapon(INVENTORY_SLOT_LEFTHAND, nRounds, nMassive); // ONLY DO LEFT IF RIGHT SUCCEEDS
	}
}

void SCApplyTerrifyingRage(object oBarb, int nRounds)
{
	int iSpellPower = GetLevelByClass( CLASS_TYPE_BARBARIAN );
	string sAOETag =  HkAOETag( oBarb, GetSpellId(), iSpellPower,  -1.0f,FALSE  );

	effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR,"x2_s2_terrage_A", "","", sAOETag);
	eAOE = ExtraordinaryEffect(eAOE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oBarb, RoundsToSeconds(nRounds));
}

void SCEndRageFatigue(object oTarget, int nFatigueDuration, int bApply=FALSE)
{
	if (!bApply)
	{
		if (!GetIsResting() && (GetHasFeatEffect(FEAT_BARBARIAN_RAGE)))
		{
			DelayCommand(0.6f, SCEndRageFatigue(oTarget, nFatigueDuration, TRUE));
		}
	}
	else
	{
		if (!GetHasFeatEffect(FEAT_BARBARIAN_RAGE))
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, CSLEffectFatigue(), oTarget, RoundsToSeconds(nFatigueDuration));
		}
	}
}


void SCDeathlessFrenzyCheck(object oTarget)
{
    //if its immune to death, e.g via items
    //then dont do this
    if(GetIsImmune( oTarget, IMMUNITY_TYPE_DEATH))
    {
        return;
	}
    if(GetHasFeat(FEAT_DEATHLESS_FRENZY, oTarget)  && GetHasFeatEffect(FEAT_FRENZY, oTarget)  && GetImmortal(oTarget)) 
    {
		SetImmortal(oTarget, FALSE);
    }
    
    //mark them as being magically killed for death system, need to look at how this works with HCR
    if(CSLGetPreferenceSwitch("PNPDeathEnable"))
    {
        SetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied", GetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied")+1);
        AssignCommand(oTarget, DelayCommand(1.0, SetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied", GetLocalInt(oTarget, "PRC_PNP_EfectDeathApplied")-1)));
    }
}
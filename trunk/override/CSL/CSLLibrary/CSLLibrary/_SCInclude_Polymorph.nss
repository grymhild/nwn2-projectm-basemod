/** @file
* @brief Include File for Polymorph support
*
* 
* 
*
* @ingroup scinclude
* @author Kaedrin, Brian T. Meyer and others
*/


#include "_HkSpell"
#include "_SCInclude_Class"
// * These constants are used with the ShifterGetSaveDC function
const int SHIFTER_DC_VERY_EASY    = 0;
const int SHIFTER_DC_EASY         = 1;
const int SHIFTER_DC_EASY_MEDIUM  = 2;
const int SHIFTER_DC_NORMAL       = 3;
const int SHIFTER_DC_HARD         = 4;


// * These constants mark the shifter level from which a new polymorph
// * type is selected to upgrade an older one.
const int X2_GW2_EPIC_THRESHOLD = 11;
const int X2_GW3_EPIC_THRESHOLD = 15;



#include "_HkSpell"

// * Returns and decrements the number of times this ability can be used
// * while in this shape. See x2_s2_gwildshp for more information
// * Do not place this on any spellscript that is not called
// * exclusively from Greater Wildshape
int ShifterDecrementGWildShapeSpellUsesLeft();

// * Introduces an artifical limit on the special abilities of the Greater
// * Wildshape forms,in order to work around the engine limitation
// * of being able to cast any assigned spell an unlimited number of times
// * Current settings:
// *  Darkness (Drow/Drider) : 1+ 1 use per 5 levels
// *  Stonegaze(Medusa) :      1+ 1 use per 5 levels
// *  Stonegaze(Basilisk) :    1+ 1 use per 5 levels
// *  Stonegaze(Basilisk) :    1+ 1 use per 5 levels
// *  MindBlast(Illithid) :    1+ 1 use per 3 levels
// *  Domination(Vampire) :    1+ 1 use per 5 levels
void ShifterSetGWildshapeSpellLimits(int iSpellId);

// * Used for the scaling DC of various shifter abilities.
// * Parameters:
// * oPC              - The Shifter
// * nShifterDCConst  - SHIFTER_DC_EASY, SHIFTER_DC_NORMAL, SHIFTER_DC_HARD
// * bAddDruidLevels  - Take druid levels into account
int ShifterGetSaveDC(object oPC, int nShifterDCConst = SHIFTER_DC_NORMAL, int bAddDruidLevels = FALSE);

// * Returns TRUE if the shifter's current weapon should be merged onto his
// * newly equipped melee weapon
int ShifterMergeWeapon (int nPolymorphConstant);

// * Returns TRUE if the shifter's current armor should be merged onto his
// * creature hide after shifting.
int ShifterMergeArmor  (int nPolymorphConstant);

// * Returns TRUE if the shifter's current items (gloves, belt, etc) should
// * be merged onto his creature hide after shiftng.
int ShifterMergeItems  (int nPolymorphConstant);
//#include "_inc_propertystrings"


//#include "seed_db_inc"

//void SCWildshapeCheck(object oTarget, object oCursedPolyItem, int iCurrentSpellid = -1);
//void SCAddSpellSlotsToObject(object oSource, object oTarget, float iDuration );

//void PolyApplyClassFeats( object oPC, float fDuration, object oRightHand = OBJECT_INVALID, object oLeftHand = OBJECT_INVALID );
//void PolyApplyNatureWarrior( object oAmuletOld, float fDuration, object oPC = OBJECT_SELF );
//void PolyMerge(object oCaster, int nMasterSpellID, float fDuration, int bElder = FALSE, int bMerge = FALSE, int bWildShape = FALSE);
//int PolyVFX(int nMasterSpellID);
//int PolyCaster(object oCaster, int iSpellId);
//int PolyForm(int bElder=FALSE,oCaster);
//string PolyMergeIP(object oOld, object oNew, itemproperty ipProperty);
//void PolyMergeItem(object oOld, object oNew, int bWeapon = FALSE);

//void PolyApplyElementalBonuses( object oPC, float fDuration, int nPoly );

void SCRemoveWildShapeEffects( object oTarget, int iCurrentSpellid = -1)
{
	if ( iCurrentSpellid != -1 )
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, iCurrentSpellid );									
	}
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oTarget, oTarget, SPELLABILITY_WILD_SHAPE, SPELLABILITY_ELEMENTAL_SHAPE, SPELL_POLYMORPH_SELF, SPELL_SHAPECHANGE, SPELL_I_WORD_OF_CHANGING, SPELL_TENSERS_TRANSFORMATION, SPELLABILITY_VGUARD_PLANT_SHAPE);									
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oTarget, oTarget, -SPELLABILITY_EXALTED_WILD_SHAPE, -FEAT_NATWARR_NATARM_CROC, -FEAT_NATWARR_NATARM_GRIZZLY, -FEAT_NATWARR_NATARM_GROWTH, -FEAT_NATWARR_NATARM_BLAZE, -FEAT_NATWARR_NATARM_CLOUD, -FEAT_NATWARR_NATARM_EARTH );									
}



void SCWildshapeCheck(object oTarget, object oCursedPolyItem, int iCurrentSpellid = -1)
{

    if ( GetIsObjectValid(oTarget) && !CSLGetHasEffectType( oTarget, EFFECT_TYPE_POLYMORPH ))
    {
    	DelayCommand(0.3f, DestroyObject(oCursedPolyItem, 0.1f, FALSE));
		SCRemoveWildShapeEffects( oTarget );
		if (GetLevelByClass(CLASS_FIST_FOREST, oTarget) > 0)
		{
			ExecuteScript("FT_fotfacbonus",oTarget);
		}
        return;
    }
	else
	{
	    DelayCommand(6.0f, SCWildshapeCheck(oTarget, oCursedPolyItem, iCurrentSpellid ) );
	}

}


void SCAddSpellSlotsToObject(object oSource, object oTarget, float iDuration )
{

		if (GetIsObjectValid(oSource))
		{
			itemproperty ipLoop=GetFirstItemProperty(oSource);
			while (GetIsItemPropertyValid(ipLoop))
			{
			
				//SendMessageToPC(OBJECT_SELF, "InLoop");
			  	if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N)
				{
				  //SendMessageToPC(OBJECT_SELF, "Bonus Slot Found on Item");
				  AddItemProperty(DURATION_TYPE_TEMPORARY, ipLoop, oTarget,iDuration);
				}
			
			   	ipLoop=GetNextItemProperty(oSource);
			}
		}

}


string PolyMergeIP(object oOld, object oNew, itemproperty ipProperty)
{
	int iPropType = GetItemPropertyType(ipProperty);
	int iSubType=GetItemPropertySubType(ipProperty);
	int iBonus = GetItemPropertyCostTableValue(ipProperty);
	int iParam1 = GetItemPropertyParam1Value(ipProperty);
	AddItemProperty(DURATION_TYPE_PERMANENT,ipProperty, oNew);
	return CSLItemPropertyDescToString(iPropType, iSubType, iBonus, iParam1);
}

void PolyMergeItem(object oOld, object oNew, int bWeapon = FALSE)
{
	if (GetIsObjectValid(oOld) && GetIsObjectValid(oNew))
	{
		itemproperty ipProperty = GetFirstItemProperty(oOld);
		string sProps = "";
		while (GetIsItemPropertyValid(ipProperty))
		{
			if (bWeapon)
			{
				if (GetWeaponRanged(oOld)==GetWeaponRanged(oNew)) 
				{
					sProps += PolyMergeIP(oOld, oNew, ipProperty) + ", ";
				}
			}
			else
			{
				sProps += PolyMergeIP(oOld, oNew, ipProperty) + ", ";
			}
			ipProperty = GetNextItemProperty(oOld);
		}
		if (sProps!="")
		{
			sProps = GetStringLeft(sProps, GetStringLength(sProps)-2);
			SendMessageToPC(OBJECT_SELF, "<color=gold> Merging " + GetName(oOld) + " --> " + GetName(oNew) + "\n" + sProps);
		}
	}

}



int PolyVFX(int nMasterSpellID)
{
	if (nMasterSpellID==SPELL_I_WORD_OF_CHANGING) return VFX_INVOCATION_WORD_OF_CHANGING;
	if (nMasterSpellID==SPELL_I_HELLSPAWNGRACE) return VFX_INVOCATION_WORD_OF_CHANGING;
	if (nMasterSpellID==SPELL_TENSERS_TRANSFORMATION) return VFX_DUR_SPELL_TENSERS_TRANSFORM;
	return VFX_DUR_POLYMORPH;
}

void PolyBuffHellhound(float fDuration, int nHasGutturalInvoc)
{
	object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
	itemproperty ipBonusFeat1 = ItemPropertyBonusFeat(IP_CONST_FEAT_DODGE);
	itemproperty ipBonusFeat2 = ItemPropertyBonusFeat(IPRP_FEAT_DARKVISION);
	itemproperty ipBonusFeat3 = ItemPropertyBonusFeat(84);
	itemproperty ipBonusFeat4 = ItemPropertyBonusFeat(386);
	CSLSafeAddItemProperty(oHide, ipBonusFeat1,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	CSLSafeAddItemProperty(oHide, ipBonusFeat2,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	CSLSafeAddItemProperty(oHide, ipBonusFeat3,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	CSLSafeAddItemProperty(oHide, ipBonusFeat4,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	if (nHasGutturalInvoc)
	{
		itemproperty ipBonusFeat5 = ItemPropertyBonusFeat(125);
		CSLSafeAddItemProperty(oHide, ipBonusFeat5,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
}

void PolyApplyNatureWarrior( object oAmuletOld, float fDuration, object oPC = OBJECT_SELF )
{
	if (GetHasFeat(FEAT_NATWARR_NATARM_CROC))
	{
		int nAC = 0;
		
		//Amulet based AC
		if (GetItemHasItemProperty(oAmuletOld, ITEM_PROPERTY_AC_BONUS))
		{
			itemproperty ipLoop=GetFirstItemProperty(oAmuletOld);
			while (GetIsItemPropertyValid(ipLoop))
			{
			
				//SendMessageToPC(OBJECT_SELF, "InLoop");
			  	if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_AC_BONUS)
				{
				  nAC = GetItemPropertyParam1Value(ipLoop);
				}
			
			   	ipLoop=GetNextItemProperty(oAmuletOld);
			}		
		}
		//Spell based AC
		int nEffAC;
		int nType;
		effect eEffect = GetFirstEffect(oPC);
		while(GetIsEffectValid(eEffect))
	   	{
	      nType = GetEffectType(eEffect);
	      if(nType == EFFECT_TYPE_AC_INCREASE)
		  {

			if (GetEffectInteger(eEffect, 0) == 1)
				nEffAC = GetEffectInteger(eEffect, 1);			
	      }
	      eEffect = GetNextEffect(oPC);
	   	}	
		
		//Final AC	
		if (nEffAC > nAC)
			nAC = nEffAC;
		nAC = nAC + GetLevelByClass(CLASS_NATURES_WARRIOR, oPC);
		if (GetHasFeat(FEAT_EPIC_ARMOR_SKIN, oPC))
		{
			nAC++;
		}
		effect eAC = EffectACIncrease(nAC, AC_NATURAL_BONUS);
		eAC = ExtraordinaryEffect(eAC);	
		//eAC = SetEffectSpellId(eAC,);		
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, fDuration, -FEAT_NATWARR_NATARM_CROC));				
	}
	if (GetHasFeat(FEAT_NATWARR_NATARM_GRIZZLY, oPC))
	{
		effect eDmg = EffectDamageIncrease(3);
		eDmg = ExtraordinaryEffect(eDmg);
		//eDmg = SetEffectSpellId(eDmg,);		
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmg, oPC, fDuration, -FEAT_NATWARR_NATARM_GRIZZLY));		
	
	}
	if (GetHasFeat(FEAT_NATWARR_NATARM_GROWTH, oPC))
	{
		effect eRegen = EffectRegenerate(1, 6.0f);
		eRegen = ExtraordinaryEffect(eRegen);
		//eRegen = SetEffectSpellId(eRegen,);		
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPC, fDuration, -FEAT_NATWARR_NATARM_GROWTH));		
	}		
	if (GetHasFeat(FEAT_NATWARR_NATARM_EARTH, oPC))
	{
		int nDR = 3;

		if (GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_9, oPC ))
		{
			nDR += 9;
		}
		else if (GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_6, oPC ))
		{
			nDR += 6;
		}	
		else if (GetHasFeat(FEAT_EPIC_DAMAGE_REDUCTION_3, oPC ))
		{
			nDR += 3;
		}

		if (GetHasFeat(FEAT_GREATER_RESILIENCY, oPC ))
		{
			nDR++;
		}
		
		effect eDR = EffectDamageReduction(nDR, DR_TYPE_NONE, 0, DR_TYPE_NONE);
		//effect eDR = EffectDamageReduction(3, DR_TYPE_NONE, 0, DR_TYPE_NONE);
		//eDR = SetEffectSpellId(eDR,);
		eDR = ExtraordinaryEffect(eDR);		
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDR, oPC, fDuration, -FEAT_NATWARR_NATARM_EARTH));		
		
	}
	
	if (GetHasFeat(FEAT_SILVER_FANG, oPC))
	{
		ApplySilverFangEffect(oPC);	
	}
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_FOTF_AC_BONUS );
}


/*
void WildshapeAbilityBuffs(object oPC, float fDuration)
{

	//FEAT_EXALTED_NATURAL_ATTACK
	if (GetHasFeat(FEAT_EXALTED_NATURAL_ATTACK, oPC))
	{

		object oCWeapon1  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
		if (GetIsObjectValid(oCWeapon1))
		{
			CSLSafeAddItemProperty(oCWeapon1,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
			CSLSafeAddItemProperty(oCWeapon1,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
			CSLSafeAddItemProperty(oCWeapon1,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);		
		}
		
		object oCWeapon2  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);		
		if (GetIsObjectValid(oCWeapon2))
		{

			CSLSafeAddItemProperty(oCWeapon2,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
			CSLSafeAddItemProperty(oCWeapon2,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
			CSLSafeAddItemProperty(oCWeapon2,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);		
		}
		
		object oCWeapon3  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);		
		if (GetIsObjectValid(oCWeapon3))
		{		
			CSLSafeAddItemProperty(oCWeapon3,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
			CSLSafeAddItemProperty(oCWeapon3,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
			CSLSafeAddItemProperty(oCWeapon3,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);		
		}
	}


}
*/

void PolyApplyElementalBonuses( object oPC, float fDuration, int nPoly )
{
	int iDescriptor = HkGetDescriptor();
	if (iDescriptor & SCMETA_DESCRIPTOR_AIR && GetHasFeat(FEAT_NATWARR_NATARM_CLOUD, oPC))
	{
		effect eConceal = EffectConcealment(20);
		//eConceal = SetEffectSpellId(eConceal,);
		eConceal = ExtraordinaryEffect(eConceal);
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oPC, fDuration, -FEAT_NATWARR_NATARM_CLOUD));		
	}

	if (iDescriptor & SCMETA_DESCRIPTOR_FIRE && GetHasFeat(FEAT_NATWARR_NATARM_BLAZE))
	{
		effect eShield = EffectDamageShield( CSLGetWildShapeLevel(oPC), DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		//eShield = SetEffectSpellId(eShield,);
		eShield = ExtraordinaryEffect(eShield);	
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oPC, fDuration, -FEAT_NATWARR_NATARM_BLAZE));		
	}	
	else if (iDescriptor & SCMETA_DESCRIPTOR_FIRE && nPoly == POLYMORPH_TYPE_EMBER_GUARD)
	{
		effect eShield = EffectDamageShield(CSLGetWildShapeLevel(oPC), DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
		eShield = EffectLinkEffects(eShield, EffectSpellResistanceIncrease(24));
		eShield = EffectLinkEffects(eShield, EffectDamageReduction(15, DR_TYPE_NONE, 0, DR_TYPE_NONE) );
		eShield = ExtraordinaryEffect(eShield);
		//eShield = SetEffectSpellId(eShield,);
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oPC, fDuration, -FEAT_NATWARR_NATARM_BLAZE));		
	}
	
	if (GetHasFeat(FEAT_SILVER_FANG, oPC))
	{
		ApplySilverFangEffect(oPC);	
	}
	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, SPELLABILITY_FOTF_AC_BONUS );
	

}

void PolyApplyClassFeats( object oPC, float fDuration, object oRightHand = OBJECT_INVALID, object oLeftHand = OBJECT_INVALID )
{
	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
	
	int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID);
	nDruidLevel+= GetLevelByClass(CLASS_LION_TALISID);
	nDruidLevel+= GetLevelByClass(CLASS_NATURES_WARRIOR);
	nDruidLevel+= GetLevelByClass(CLASS_DAGGERSPELL_SHAPER);

	object oCWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
	object oCWeapon2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
	object oCWeapon3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
	object oCHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

	//FEAT_EXALTED_NATURAL_ATTACK
	if (GetHasFeat(FEAT_EXALTED_NATURAL_ATTACK))
	{

		//object oCWeapon1  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
		if (GetIsObjectValid(oCWeapon1))
		{
			CSLSafeAddItemProperty(oCWeapon1,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
			CSLSafeAddItemProperty(oCWeapon1,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
			CSLSafeAddItemProperty(oCWeapon1,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );		
		}
		
		//object oCWeapon2  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);		
		if (GetIsObjectValid(oCWeapon2))
		{

			CSLSafeAddItemProperty(oCWeapon2,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
			CSLSafeAddItemProperty(oCWeapon2,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
			CSLSafeAddItemProperty(oCWeapon2,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );		
		}
		
		//object oCWeapon3  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);		
		if (GetIsObjectValid(oCWeapon3))
		{		
			CSLSafeAddItemProperty(oCWeapon3,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
			CSLSafeAddItemProperty(oCWeapon3,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
			CSLSafeAddItemProperty(oCWeapon3,ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_OUTSIDER, IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_1), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );		
		}
	}
	
		//Jagged Tooth

	if (GetHasSpellEffect(1002, oPC))

	{

		int CL = GetCasterLevel(oPC);				

		float fSpellDuration = 10 * TurnsToSeconds(CL);	

		itemproperty iKeen = ItemPropertyKeen();	

		itemproperty iImpCritUnarm = ItemPropertyBonusFeat(IP_CONST_FEAT_IMPCRITUNARM);

		itemproperty iNatCritUnarm = ItemPropertyBonusFeat(IPRP_FEAT_IMPCRITCREATURE);		

		if (GetIsObjectValid(oCHide))

		{

			CSLSafeAddItemProperty(oCHide, iKeen, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			CSLSafeAddItemProperty(oCHide, iImpCritUnarm, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);

			CSLSafeAddItemProperty(oCHide, iNatCritUnarm, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);						

		}	
		/*
				if (GetIsObjectValid(oCWeapon1))

				{

					if (!CSLItemGetIsBludgeoningWeapon(oCWeapon1))

					{

						CSLSafeAddItemProperty(oCWeapon1, iKeen, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);

						CSLSafeAddItemProperty(oCWeapon1, iImpCritUnarm, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);

						CSLSafeAddItemProperty(oCWeapon1, iNatCritUnarm, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);												

					}

				}

				else if (GetIsObjectValid(oCWeapon2))

				{

					if (!CSLItemGetIsBludgeoningWeapon(oCWeapon2))

					{

						CSLSafeAddItemProperty(oCWeapon2, iKeen, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);

						CSLSafeAddItemProperty(oCWeapon2, iImpCritUnarm, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);

						CSLSafeAddItemProperty(oCWeapon2, iNatCritUnarm, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);						

					}

				}

				else if (GetIsObjectValid(oCWeapon3))

				{

					if (!CSLItemGetIsBludgeoningWeapon(oCWeapon3))
					{
						CSLSafeAddItemProperty(oCWeapon3, iKeen, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
						CSLSafeAddItemProperty(oCWeapon3, iImpCritUnarm, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
						CSLSafeAddItemProperty(oCWeapon3, iNatCritUnarm, fSpellDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);						
					}
				}
				*/
	}

	

	//Greater Magic Fang

	if (GetHasSpellEffect(453, oPC))
	{

		int CL = GetCasterLevel(oPC);
    	int nPower = (CL + 1) / 3;	
		int nFangBuff = CSLGetPreferenceSwitch("FangLineExceeds20",FALSE);
		float fSpellDuration = TurnsToSeconds(CL);
	    if ((nPower > 5) && (!nFangBuff))
	    {
	    	nPower = 5;  // * max of +5 bonus	
		}
			
		itemproperty iEbonus = ItemPropertyEnhancementBonus(nPower);
		float fDuration = TurnsToSeconds(nDruidLevel);
		
		if (GetIsObjectValid(oCWeapon1))
		{
			CSLSafeAddItemProperty(oCWeapon1, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
		}
		if (GetIsObjectValid(oCWeapon2))
		{
			CSLSafeAddItemProperty(oCWeapon2, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
		}
		if (GetIsObjectValid(oCWeapon3))
		{
			CSLSafeAddItemProperty(oCWeapon3, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
		}
	}	
	//Magic Fang
	else if (GetHasSpellEffect(SPELL_MAGIC_FANG, oPC))
	{

		itemproperty iEbonus = ItemPropertyEnhancementBonus(1);

		float fSpellDuration = TurnsToSeconds(nDruidLevel);

		if (GetIsObjectValid(oCWeapon1))
		{
			CSLSafeAddItemProperty(oCWeapon1, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
		}
		if (GetIsObjectValid(oCWeapon2))
		{
			CSLSafeAddItemProperty(oCWeapon2, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
		}
		if (GetIsObjectValid(oCWeapon3))
		{
			CSLSafeAddItemProperty(oCWeapon3, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
		}	
	}		
	
	if (GetLevelByClass(CLASS_DAGGERSPELL_SHAPER, oPC) > 1)
	{
		
		if (GetIsObjectValid(oRightHand) && (GetBaseItemType(oRightHand) == BASE_ITEM_DAGGER) )
		{
			itemproperty iEbonus = ItemPropertyEnhancementBonus(CSLGetWeaponEnhancementBonus(oRightHand));
			float fSpellDuration = TurnsToSeconds(nDruidLevel);
			if (GetIsObjectValid(oCWeapon1))
			{
				CSLSafeAddItemProperty(oCWeapon1, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
			}
			if (GetIsObjectValid(oCWeapon2))
			{
				CSLSafeAddItemProperty(oCWeapon2, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
			}
			if (GetIsObjectValid(oCWeapon3))
			{
				CSLSafeAddItemProperty(oCWeapon3, iEbonus, fSpellDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING);
			}		
		}	
	}
	
	int iHD = GetTotalLevels(oPC,FALSE);
		
	
	//FEAT_EXALTED_WILD_SHAPE
	if (GetHasFeat(FEAT_EXALTED_WILD_SHAPE))
	{
		
			
		int nDR = 0;
		int nResist = 0;
		int nSR = 5 + iHD;
		
		if (iHD > 7)
			nResist = 10;
		else
			nResist = 5;
			
		if (iHD > 11)
			nDR = 10;
		else
			nDR = 5;			
		
		effect eDarkVis = EffectDarkVision();
		effect eDR = EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
		//effect eDR = EffectDamageReduction(nDR); // 10 unless a magic weapon
		effect eSR = EffectSpellResistanceIncrease(nSR);
		effect eLink;
					
		if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
		{
			//Fiendish
			effect eDmgRes1 = EffectDamageResistance(DAMAGE_TYPE_FIRE,nResist);
			effect eDmgRes2 = EffectDamageResistance(DAMAGE_TYPE_COLD,nResist);
			
			eLink = EffectLinkEffects(eDmgRes1, eDmgRes2);
	
		}
		else
		{	
			//Celestial
			effect eDmgRes1 = EffectDamageResistance(DAMAGE_TYPE_ACID,nResist);
			effect eDmgRes2 = EffectDamageResistance(DAMAGE_TYPE_COLD,nResist);
			effect eDmgRes3 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL,nResist);
			
			eLink = EffectLinkEffects(eDmgRes1, eDmgRes2);
			eLink = EffectLinkEffects(eLink, eDmgRes3);						
		}				
			
		eLink = EffectLinkEffects(eLink, eDarkVis);	
		eLink = EffectLinkEffects(eLink, eSR);		
		eLink = EffectLinkEffects(eLink, eDR);
		
		//eLink = SetEffectSpellId(eLink,);
		eLink = SupernaturalEffect(eLink);
	
		HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fDuration, -SPELLABILITY_EXALTED_WILD_SHAPE);		
					
	}





}

int SCPolyIsArcane( int iSpellId )
{
	switch(iSpellId)
	{
		case SPELL_POLYMORPH_SELF: // master spells here
		case SPELL_SHAPECHANGE:
		case SPELL_I_WORD_OF_CHANGING: //)           return WORD_OF_CHANGING_HORNED_DEVIL; //POLYMORPH_TYPE_HORNED_DEVIL;      // WORD OF CHANGING // not sure why, but this was at 161, and it's 171 in 2da file
		case SPELL_TENSERS_TRANSFORMATION:
		case SPELL_I_HELLSPAWNGRACE:
		// put these in just in case
		case 387: // POLYMORPH_TYPE_SWORD_SPIDER;      // POLYMORPH SELF
		case 388: // POLYMORPH_TYPE_TROLL;             // POLYMORPH SELF
		case 389: // POLYMORPH_TYPE_UMBER_HULK;        // POLYMORPH SELF
		case 390: // POLYMORPH_TYPE_GARGOYLE;          // POLYMORPH SELF
		case 391: // POLYMORPH_TYPE_MINDFLAYER;        // POLYMORPH SELF
		case 392: // POLYMORPH_TYPE_FROST_GIANT_MALE;  // SHAPECHANGE
		case 393: // POLYMORPH_TYPE_FIRE_GIANT;        // SHAPECHANGE
		case 394: // POLYMORPH_TYPE_HORNED_DEVIL;      // SHAPECHANGE
		case 395: // POLYMORPH_TYPE_NIGHTWALKER;       // SHAPECHANGE
		case 396: // POLYMORPH_TYPE_IRON_GOLEM;        // SHAPECHANGE
			return TRUE;
			break;
		default:
			return FALSE;
	}
	return FALSE;
}

int PolyCaster(object oCaster, int iSpellId) // CAN THIS FORM CAST?
{
	if ((iSpellId==SPELLABILITY_ELEMENTAL_SHAPE || iSpellId==SPELLABILITY_ELEMENTAL_SHAPE) && GetHasFeat(FEAT_NATURAL_SPELL, oCaster)) return TRUE;
	if (iSpellId==SPELL_I_WORD_OF_CHANGING) return TRUE;
	if (iSpellId==SPELL_I_HELLSPAWNGRACE) return TRUE;
	if ( SCPolyIsArcane( iSpellId ) && CSLGetPreferenceSwitch("ArcaneShapesCanCast",FALSE)  ) return TRUE;
	return FALSE;
}

int PolyForm(int bElder=FALSE, object oCaster = OBJECT_SELF)
{
	int iSpellId = GetSpellId();

	// this makes the spell give a random form when an NPC triggers the script
	// from greater wildshape
	int iDescriptor = HkGetDescriptor();
	switch(iSpellId)
	{
			case 320:  // regular wildshape
				switch(Random(5))
				{
					case 0: iSpellId = 401; break;
					case 1: iSpellId = 402; break;
					case 2: iSpellId = 403; break;
					case 3: iSpellId = 404; break;
					case 4: iSpellId = 405; break;

				}
				break;
			case 319:  // elemental shape
			
				if (iDescriptor & SCMETA_DESCRIPTOR_FIRE )
				{
					iSpellId = SPELLABILITY_ELEMENTAL_SHAPE_FIRE;
				}
				else if (iDescriptor & SCMETA_DESCRIPTOR_WATER )
				{
					iSpellId = SPELLABILITY_ELEMENTAL_SHAPE_WATER;
				}
				else if (iDescriptor & SCMETA_DESCRIPTOR_EARTH )
				{
					iSpellId = SPELLABILITY_ELEMENTAL_SHAPE_EARTH;
				}
				else if (iDescriptor & SCMETA_DESCRIPTOR_AIR )
				{
					iSpellId = SPELLABILITY_ELEMENTAL_SHAPE_AIR;
				}
				else 
				{
					switch(Random(4))
					{
						case 0: iSpellId = SPELLABILITY_ELEMENTAL_SHAPE_FIRE; CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_FIRE );break;
						case 1: iSpellId = SPELLABILITY_ELEMENTAL_SHAPE_WATER;CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_WATER); break;
						case 2: iSpellId = SPELLABILITY_ELEMENTAL_SHAPE_EARTH;CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EARTH); break;
						case 3: iSpellId = SPELLABILITY_ELEMENTAL_SHAPE_AIR;  CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_AIR); break;
	
					}
				}
				break;
			case 646:  // Greater Wildshape I
				iSpellId = Random(5)+658; 
				break;
			case 675:  // Greater Wildshape II
				switch(Random(3))
						{
							case 0: iSpellId = 672; break;
							case 1: iSpellId = 678; break;
							case 2: iSpellId = 680; break;
						}
						break;
			// Greater Wildshape III
			case 676: switch(Random(3))
						{
							case 0: iSpellId = 670; break;
							case 1: iSpellId = 673; break;
							case 2: iSpellId = 674;
						}
						break;
			// Greater Wildshape IV
			case 677: switch(Random(3))
						{
							case 0: iSpellId = 679; break;
							case 1: iSpellId = 691; break;
							case 2: iSpellId = 694;
						}
						break;
			
			case 681:  iSpellId = Random(3)+682; break; // Humanoid Shape
			
			case 685:  iSpellId = Random(3)+704; break; // Undead Shape
			
			case 725:  iSpellId = Random(3)+707; break; // Dragon Shape
			
			case 732:  iSpellId = Random(3)+733; break; // Outsider Shape
			
			case 737:  iSpellId = Random(3)+738; break; // Construct Shape
			
			case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE: // Magical Beast Wild Shape
				iSpellId = Random(3)+SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_CELESTIAL_BEAR; break;
			// Plant Wild Shape
			case SPELLABILITY_PLANT_WILD_SHAPE:
				iSpellId = Random(2) + SPELLABILITY_PLANT_WILD_SHAPE_SHAMBLING_MOUND; break; // 2 forms to choose from
	}
	
	
	if      (iSpellId==SPELL_POLYMORPH_SELF)               return CSLPickOneInt(POLYMORPH_TYPE_SWORD_SPIDER, POLYMORPH_TYPE_TROLL, POLYMORPH_TYPE_UMBER_HULK, POLYMORPH_TYPE_GARGOYLE, POLYMORPH_TYPE_MINDFLAYER);
	else if (iSpellId==SPELLABILITY_WILD_SHAPE)            return CSLPickOneInt(SPELLABILITY_WILD_SHAPE_BROWN_BEAR, SPELLABILITY_WILD_SHAPE_PANTHER, SPELLABILITY_WILD_SHAPE_WOLF, SPELLABILITY_WILD_SHAPE_BOAR, SPELLABILITY_WILD_SHAPE_BADGER);
	
	
	else if (iSpellId==SPELLABILITY_ELEMENTAL_SHAPE) 
	{
		switch(Random(4))
		{
			case 0: CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_FIRE);return POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL; break;
			case 1: CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_WATER);return POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL; break;
			case 2: CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EARTH);return POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL; break;
			case 3: CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_AIR);return POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL; break;
		}
	
	}
	
	else if (iSpellId==SPELLABILITY_WILD_SHAPE_BROWN_BEAR) return (bElder) ? POLYMORPH_TYPE_DIRE_BROWN_BEAR : POLYMORPH_TYPE_BROWN_BEAR;
	else if (iSpellId==SPELLABILITY_WILD_SHAPE_PANTHER)    return (bElder) ? POLYMORPH_WILDSHAPE_TYPE_DIRE_PANTHER    : POLYMORPH_WILDSHAPE_TYPE_PANTHER; // POLYMORPH_TYPE_DIRE_PANTHER    : POLYMORPH_TYPE_PANTHER;
	else if (iSpellId==SPELLABILITY_WILD_SHAPE_WOLF)       return (bElder) ? POLYMORPH_TYPE_DIRE_WOLF       : POLYMORPH_TYPE_WOLF;
	else if (iSpellId==SPELLABILITY_WILD_SHAPE_BOAR)       return (bElder) ? POLYMORPH_TYPE_DIRE_BOAR       : POLYMORPH_TYPE_BOAR;
	else if (iSpellId==SPELLABILITY_WILD_SHAPE_BADGER)     return (bElder) ? POLYMORPH_TYPE_DIRE_BADGER     : POLYMORPH_TYPE_BADGER;
	else if (iSpellId==SPELL_I_WORD_OF_CHANGING)
	{
		
		
		if ( GetHasFeat( FEAT_FIENDISH_POWER,  oCaster) || GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL )
		{
			CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EVIL);
			if (GetGender( oCaster ) == GENDER_FEMALE )
			{
				return WORD_OF_CHANGING_HEZEBEL;
			}
			else
			{
				return WORD_OF_CHANGING_PIT_FIEND;
			}
		}
		else if ( GetHasFeat( FEAT_FEY_POWER,  oCaster) ) // || GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL )
		{
			CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_CHAOS);
			return WORD_OF_CHANGING_HORNED_DEVIL; // need to do some new shapes really
		}
		
			
		// CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EVIL);	
		return WORD_OF_CHANGING_HORNED_DEVIL; //POLYMORPH_TYPE_HORNED_DEVIL;      // WORD OF CHANGING // not sure why, but this was at 161, and it's 171 in 2da file
	}
	
	else if (iSpellId==SPELL_I_HELLSPAWNGRACE)           return POLYMORPH_TYPE_HELLCAT;

	else if (iSpellId==SPELL_TENSERS_TRANSFORMATION) return POLYMORPH_TYPE_DOOM_KNIGHT;      // Tensers Transformation
	
	else if (iSpellId==387) return POLYMORPH_TYPE_SWORD_SPIDER;      // POLYMORPH SELF
	else if (iSpellId==388) return POLYMORPH_TYPE_TROLL;             // POLYMORPH SELF
	else if (iSpellId==389) return POLYMORPH_TYPE_UMBER_HULK;        // POLYMORPH SELF
	else if (iSpellId==390) return POLYMORPH_TYPE_GARGOYLE;          // POLYMORPH SELF
	else if (iSpellId==391) return POLYMORPH_TYPE_MINDFLAYER;        // POLYMORPH SELF
	else if (iSpellId==392) {CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_COLD);return POLYMORPH_TYPE_FROST_GIANT_MALE;}  // SHAPECHANGE
	else if (iSpellId==393) {CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_FIRE);return POLYMORPH_TYPE_FIRE_GIANT;}        // SHAPECHANGE
	else if (iSpellId==394) { CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EVIL);return POLYMORPH_TYPE_HORNED_DEVIL; }      // SHAPECHANGE
	else if (iSpellId==395) return POLYMORPH_TYPE_NIGHTWALKER;       // SHAPECHANGE
	else if (iSpellId==396) return POLYMORPH_TYPE_IRON_GOLEM;        // SHAPECHANGE
	else if (iSpellId==397) { CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_FIRE); return (bElder) ? POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL  : POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL; }
	else if (iSpellId==398) { CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_WATER); return (bElder) ? POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL : POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL; }
	else if (iSpellId==399) { CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_EARTH); return (bElder) ? POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL : POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL; }
	else if (iSpellId==400) { CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_AIR); return (bElder) ? POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL   : POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL; }
	
	else if (iSpellId==2010) { CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_FIRE); DecrementRemainingFeatUses(oCaster, 304); return POLYMORPH_TYPE_EMBER_GUARD; }
	
	
	else if (iSpellId==402) 
	{
		if (GetLevelByClass(CLASS_TYPE_DRUID) == 0 && GetLevelByClass(CLASS_LION_TALISID) > 0)
		{
			return POLYMORPH_TYPE_CELESTIAL_LEOPARD;
		}
		else if (bElder) 
		{
			return POLYMORPH_WILDSHAPE_TYPE_DIRE_PANTHER;
		}
		return POLYMORPH_WILDSHAPE_TYPE_PANTHER;
	}
	else if (iSpellId==403) return (bElder) ? POLYMORPH_TYPE_DIRE_WOLF   : POLYMORPH_TYPE_WOLF;		
	else if (iSpellId==404) return (bElder) ? POLYMORPH_TYPE_DIRE_BOAR   : POLYMORPH_TYPE_BOAR;	
	else if (iSpellId==405) return (bElder) ? POLYMORPH_TYPE_DIRE_BADGER   : POLYMORPH_TYPE_BADGER;
	else if (iSpellId==406) return (bElder) ? POLYMORPH_TYPE_DIRE_BROWN_BEAR   : POLYMORPH_TYPE_BROWN_BEAR;	
	
	// greater wildshape
	// dragon shapes
	else if (iSpellId==707)
	{
		int nHD = GetHitDice(oCaster);
		if (nHD > 29 && GetLevelByClass(CLASS_TYPE_DRUID,oCaster) > 29)
		{
			return DRAGONSHAPE_RED_DRAGON_30;
		}
		else if (nHD > 27)
		{
			return DRAGONSHAPE_RED_DRAGON_28;
		}
		else
		{
			return DRAGONSHAPE_RED_DRAGON_25;		
		}
		return POLYMORPH_TYPE_RED_DRAGON; // Red Dragon
	}
	else if (iSpellId==708)
	{
		int nHD = GetHitDice(oCaster);
		if (nHD > 29 && GetLevelByClass(CLASS_TYPE_DRUID,oCaster) > 29)
		{
			return DRAGONSHAPE_BLUE_DRAGON_30;
		}
		else if (nHD > 26)
		{
			return DRAGONSHAPE_BLUE_DRAGON_27;
		}
		else
		{
			return DRAGONSHAPE_BLUE_DRAGON_24;	
		}
		return POLYMORPH_TYPE_BLUE_DRAGON; // Blue Dragon
	}
	else if (iSpellId==709)
	{
		int nHD = GetHitDice(oCaster);
		if (nHD > 29 && GetLevelByClass(CLASS_TYPE_DRUID,oCaster) > 29)
		{
			return DRAGONSHAPE_BLACK_DRAGON_30;
		}
		else if (nHD > 27)
		{
			return DRAGONSHAPE_BLACK_DRAGON_28;
		}
		else
		{
			return DRAGONSHAPE_BLACK_DRAGON_25;
		}
		return POLYMORPH_TYPE_BLACK_DRAGON; // Black Dragon
	}
	
	// outsiders
	else if (iSpellId==733) return ( GetGender(oCaster) == GENDER_MALE ) ? 85 : 86; //azer
	else if (iSpellId==734) return ( GetGender(oCaster) == GENDER_MALE ) ? 88 : 89; //rakshasa
	else if (iSpellId==735) return 87; // slaad
	
	// construct shapes
	else if (iSpellId==738) return 91; // stone golem
	else if (iSpellId==739) return 92; // demonflesh golem
	else if (iSpellId==740) return 90; // iron golem
	
	// Magical Beast
	else if (iSpellId==SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_CELESTIAL_BEAR) return POLYMORPH_TYPE_CELESTIAL_LEOPARD; // Celestial Leopard; yes, everything says bear, but we don't have a bear in NX1
	else if (iSpellId==SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_PHASE_SPIDER) return POLYMORPH_TYPE_PHASE_SPIDER;
	else if (iSpellId==SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_WINTER_WOLF) { CSLAddLocalBit(oCaster, "HKTEMP_Descriptor", SCMETA_DESCRIPTOR_COLD);return POLYMORPH_TYPE_WINTER_WOLF;}
	
	else if (iSpellId==SPELLABILITY_PLANT_WILD_SHAPE_SHAMBLING_MOUND) return POLYMORPH_TYPE_SHAMBLING_MOUND; // Shambling Mound
	else if (iSpellId==SPELLABILITY_PLANT_WILD_SHAPE_TREANT) return POLYMORPH_TYPE_TREANT; // treant
	else if (iSpellId==SPELLABILITY_VGUARD_PLANT_SHAPE) return POLYMORPH_TYPE_TREANT; // treant
	
	else if ( iSpellId==SPELL_ANISHAPE_BEAR) { return POLYMORPH_TYPE_BROWN_BEAR; }
	else if ( iSpellId==SPELL_ANISHAPE_NORMAL) { return POLYMORPH_TYPE_BROWN_BEAR; }
	else if ( iSpellId==SPELL_ANISHAPE_PANTHER) { return POLYMORPH_TYPE_PANTHER; }
	else if ( iSpellId==SPELL_ANISHAPE_WOLF) { return POLYMORPH_TYPE_WOLF; }
	else if ( iSpellId==SPELL_ANISHAPE_BOAR) { return POLYMORPH_TYPE_BOAR;}
	else if ( iSpellId==SPELL_ANISHAPE_BADGER) { return POLYMORPH_TYPE_BADGER;}
	else if ( iSpellId==SPELL_ANISHAPE_DBEAR) { return  POLYMORPH_TYPE_DIRE_BROWN_BEAR; }
	else if ( iSpellId==SPELL_ANISHAPE_DIRE) { return POLYMORPH_TYPE_DIRE_BROWN_BEAR;}
	else if ( iSpellId==SPELL_ANISHAPE_DPANTHER) { return POLYMORPH_TYPE_DIRE_PANTHER;}
	else if ( iSpellId==SPELL_ANISHAPE_DWOLF) { return POLYMORPH_TYPE_DIRE_WOLF;}
	else if ( iSpellId==SPELL_ANISHAPE_DBOAR) { return POLYMORPH_TYPE_DIRE_BOAR;}
	else if ( iSpellId==SPELL_ANISHAPE_DBADGER) { return POLYMORPH_TYPE_DIRE_BADGER;}
	
	
	if (DEBUGGING >= 4) { CSLDebug("Unknown PolySpell " + IntToString(iSpellId) + " cast by " + GetName(oCaster) ); }
	return POLYMORPH_TYPE_SWORD_SPIDER;
}


void WildShape_Unarmed(object oPC, float fDuration)
{
	object oHide = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oPC );	
	
	itemproperty iBonusFeat;
	
	if (GetHasFeat(FEAT_POWER_CRITICAL_UNARMED, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(293); //	Power Crit Cr. 
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
	
	if (GetHasFeat(FEAT_GREATER_WEAPON_FOCUS_UNARMED, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(345); //	G Wpn Foc Cr. 
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}	
	
	if (GetHasFeat(FEAT_GREATER_WEAPON_SPECIALIZATION_UNARMED, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(385); //	G Wpn Spec Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
	
	if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(402); //	Wpn Foc Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
	
	if (GetHasFeat(FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_IMPCRITCREATURE); //	Imp Crit Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}	
	
	if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_WPNSPEC_CREATURE); //	Wpn Spec Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
	
	if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_EPICWPNFOC_CREATURE); //	 Epic Wpn Foc Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}	
	
	if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_EPICWPNSPEC_CREATURE); //	 Epic Wpn Spec Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}	
	
	if (GetHasFeat(FEAT_EPIC_OVERWHELMING_CRITICAL_UNARMED, oPC))
	{
		iBonusFeat = ItemPropertyBonusFeat(IPRP_FEAT_EPICOVERWHELMCRIT_CREATURE); //	 Epic Over Crit Cr.
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat,oHide,fDuration);	
	}
												
	//IPRP   xxx       Unarmed_FeatId
	//293 Power Crit Cr. 1355
	//345 G Wpn Foc Cr. 1129
	//385 G Wpn Spec Cr. 1169
	//402 Wpn Foc Cr.  100
	//804 Imp Crit Cr.   62
	//805 Wpn Spec Cr. 138
	//806 Epic Wpn Foc Cr. 	630
	//807 Epic Wpn Spec Cr. 668
	//808 Epic Over Crit Cr. 720
	
}


void PolyMerge(object oCaster, int nMasterSpellID, float fDuration, int bElder = FALSE, int bMerge = FALSE, int bWildShape = FALSE)
{

	int nPoly = PolyForm(bElder, oCaster );
	int iSpellId = GetSpellId();
	
	int nSR = 0;
	
	
	switch ( nPoly ) 
	{
		case DRAGONSHAPE_RED_DRAGON_30: nSR = 26; break;
		case DRAGONSHAPE_RED_DRAGON_28: nSR = 24; break;
		case DRAGONSHAPE_RED_DRAGON_25: nSR = 23; break;
		case DRAGONSHAPE_BLUE_DRAGON_30: nSR = 25; break;
		case DRAGONSHAPE_BLUE_DRAGON_27: nSR = 24; break;
		case DRAGONSHAPE_BLUE_DRAGON_24: nSR = 22; break;
		case DRAGONSHAPE_BLACK_DRAGON_30: nSR = 25; break;
		case DRAGONSHAPE_BLACK_DRAGON_28: nSR = 23; break;
		case DRAGONSHAPE_BLACK_DRAGON_25: nSR = 22; break;
	}
	
	//SendMessageToPC(OBJECT_SELF, "<color=gold> Polymerge MasterSpell: " + IntToString(nMasterSpellID) + "   SpellID: " + IntToString(iSpellId) );

	//if (iSpellId==SPELL_I_WORD_OF_CHANGING && GetLocalInt(oCaster, "POLYTEST")) nPoly = 161; // OVERRIDE FOR TESTING

	SignalEvent(oCaster, EventSpellCastAt(oCaster, nMasterSpellID, FALSE)); // mainly used to signal

	int bWeapon;
	int bArmor;
	int bItems;

	object oWeapon1Old;
	object oWeapon2Old;
	object oArmorOld;
	object oRing1Old;
	object oRing2Old;
	object oAmuletOld;
	object oCloakOld;
	object oBootsOld;
	object oBeltOld;
	object oHelmetOld;
	object oBracerOld;
	object oShield;
	//object oBracerOld;

	if (bMerge)
	{
		bWeapon = StringToInt(Get2DAString("polymorph", "MergeW", nPoly)) == 1;
		bArmor  = StringToInt(Get2DAString("polymorph", "MergeA", nPoly)) == 1;
		bItems  = StringToInt(Get2DAString("polymorph", "MergeI", nPoly)) == 1;
		// bWeapon == FALSE;
		if ( bWeapon )
		{
			oWeapon1Old = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
			oWeapon2Old = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
			if (GetIsObjectValid(oWeapon2Old) && CSLGetIsAShield(GetBaseItemType(oWeapon2Old))) { oWeapon2Old = OBJECT_INVALID; }
		}
		if (bArmor) {
			oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST, oCaster);
			oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD, oCaster);
			oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
			if (GetIsObjectValid(oShield) && !CSLGetIsAShield(GetBaseItemType(oShield))) { oShield = OBJECT_INVALID; }

		}
		if (bItems) {
			oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oCaster);
			oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oCaster);
			oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK, oCaster);
			oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK, oCaster);
			oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS, oCaster);
			oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT, oCaster);
			
			oBracerOld = GetItemInSlot(INVENTORY_SLOT_ARMS,oCaster);
			if (GetIsObjectValid(oBracerOld) && ( GetBaseItemType(oBracerOld) != BASE_ITEM_BRACER ) ) {  oBracerOld = OBJECT_INVALID; }
			
			
			
		}
	}
	
	// this is new
	// this is completed of new things
	int iAC;
	int iEnhanceAC;
	int iDeflAC;
	int iNatAC;
	int iDodgeAC;
	//int iShieldAC;
	
	//Armor Enhance
	iEnhanceAC = GetItemACValue(oBracerOld);
	iAC = CSLGetWeaponEnhancementBonus(oArmorOld, ITEM_PROPERTY_AC_BONUS);
	if (iAC > iEnhanceAC)
	{
		iEnhanceAC = iAC;
	}
	//Defl
	iDeflAC = GetItemACValue(oRing1Old);
	iAC = GetItemACValue(oRing2Old);
	if (iAC > iDeflAC)
	{
		iDeflAC = iAC;
	}
	iAC = GetItemACValue(oCloakOld);
	if (iAC > iDeflAC)
	{
		iDeflAC = iAC;
	}
	iAC = GetItemACValue(oHelmetOld);
	if (iAC > iDeflAC)
	{
		iDeflAC = iAC;	
	}
	
	iAC = GetItemACValue(oBeltOld);

	if (iAC > iDeflAC)
	{
		iDeflAC = iAC;
	}
	//Nat AC	
	iNatAC = GetItemACValue(oAmuletOld);	

	//Dodge
	iDodgeAC = GetItemACValue(oBootsOld);
	
	//Shield AC
	//iShieldAC = IPGetWeaponEnhancementBonus(oShield, ITEM_PROPERTY_AC_BONUS);
		
	
	
	
	/// kaedrins fix for lost spells here, slightly modified and put into the SC core library ///
	//Fix for Spell Slot loss
	
	// CSLGetNaturalAbilityScore(oCaster, ABILITY_INTELLIGENCE );
	 
	int nWisBonus = GetAbilityScore(oCaster, ABILITY_WISDOM, FALSE) - GetAbilityScore(oCaster, ABILITY_WISDOM, TRUE);
	int nIntBonus = GetAbilityScore(oCaster, ABILITY_INTELLIGENCE, FALSE) - GetAbilityScore(oCaster, ABILITY_INTELLIGENCE, TRUE);
	int nChaBonus = GetAbilityScore(oCaster, ABILITY_CHARISMA, FALSE) - GetAbilityScore(oCaster, ABILITY_CHARISMA, TRUE);
	
	/*
	int nWisBonus = GetAbilityScore(oCaster, ABILITY_WISDOM, FALSE) - CSLGetNaturalAbilityScore(oCaster, ABILITY_WISDOM );
	int nIntBonus = GetAbilityScore(oCaster, ABILITY_INTELLIGENCE, FALSE) - CSLGetNaturalAbilityScore(oCaster, ABILITY_INTELLIGENCE );
	int nChaBonus = GetAbilityScore(oCaster, ABILITY_CHARISMA, FALSE) - CSLGetNaturalAbilityScore(oCaster, ABILITY_CHARISMA );
	*/
	
		
	object oCursedPolyItem = CreateItemOnObject("cmi_cursedpoly",oCaster,1,"",FALSE);
	if (oCursedPolyItem == OBJECT_INVALID)
	{
		SendMessageToPC(oCaster, "Your Inventory was full so bonus spell slots from items and racial spellcasting stat modifiers will not survive the transition to your new form.");
	}
	
	SCAddSpellSlotsToObject(oWeapon1Old,oCursedPolyItem, fDuration);
	SCAddSpellSlotsToObject(oWeapon2Old,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oArmorOld,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oRing1Old,oCursedPolyItem, fDuration);
	SCAddSpellSlotsToObject(oRing2Old,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oAmuletOld,oCursedPolyItem, fDuration);
	SCAddSpellSlotsToObject(oCloakOld,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oBootsOld,oCursedPolyItem, fDuration);			
	SCAddSpellSlotsToObject(oBeltOld,oCursedPolyItem, fDuration);
	SCAddSpellSlotsToObject(oHelmetOld,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oShield,oCursedPolyItem, fDuration);
	
	if (nWisBonus > 12) { nWisBonus = 12; }
	if (nIntBonus > 12) { nIntBonus = 12; }
	if (nChaBonus > 12) { nChaBonus = 12; }
						
	itemproperty ipNewEnhance = ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, nWisBonus);  	  
	CSLSafeAddItemProperty(oCursedPolyItem, ipNewEnhance,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	ipNewEnhance = ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, nIntBonus);  	  
	CSLSafeAddItemProperty(oCursedPolyItem, ipNewEnhance,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	ipNewEnhance = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, nChaBonus);  	  
	CSLSafeAddItemProperty(oCursedPolyItem, ipNewEnhance,fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	
	
	
	///***************************End Kaedrins fix here*********************************///
	int bCastWhileShaped = FALSE;
	effect ePoly = EffectVisualEffect( PolyVFX(nMasterSpellID) );
	
	// this is previously set up
	if (iEnhanceAC > 0)
	{
		effect eEnhAC = EffectACIncrease(iEnhanceAC, AC_ARMOUR_ENCHANTMENT_BONUS);
		ePoly = EffectLinkEffects(ePoly, eEnhAC);
	}
	if (iDeflAC > 0)
	{
		effect eDefAC = EffectACIncrease(iDeflAC, AC_DEFLECTION_BONUS);
		ePoly = EffectLinkEffects(ePoly, eDefAC);
	}
	if (iNatAC > 0)
	{
		effect eNatAC = EffectACIncrease(iNatAC, AC_NATURAL_BONUS);
		ePoly = EffectLinkEffects(ePoly, eNatAC);
	}
	if (iDodgeAC > 0)
	{
		effect eDodAC = EffectACIncrease(iDodgeAC, AC_DODGE_BONUS);
		ePoly = EffectLinkEffects(ePoly, eDodAC);
	}
	//if (iShieldAC > 0)
	//{
	//	effect eShiAC = EffectACIncrease(iShieldAC, AC_SHIELD_ENCHANTMENT_BONUS);
	//	ePoly = EffectLinkEffects(ePoly, eShiAC);
	//}				
	//ePoly = SupernaturalEffect(ePoly);
	
	
	
	// if (!PolyCaster(oCaster, nMasterSpellID)) {
	if ( ( nMasterSpellID==SPELL_I_WORD_OF_CHANGING || nMasterSpellID==SPELL_I_HELLSPAWNGRACE ) && GetHasFeat(FEAT_GUTTURAL_INVOCATIONS, oCaster) )
	{ // WILDSHAPED DRUIDS AND WARLOCKS MAY CAST IN FORM
		SendMessageToPC(oCaster, "You can cast invocations while polymorphed.");
		bCastWhileShaped = TRUE;
	}
	else if ( (bWildShape && GetHasFeat(FEAT_NATURAL_SPELL, oCaster)) || ( SCPolyIsArcane( nMasterSpellID ) && CSLGetPreferenceSwitch("ArcaneShapesCanCast",FALSE) ) )
	{ // WILDSHAPED DRUIDS AND WARLOCKS MAY CAST IN FORM
		SendMessageToPC(oCaster, "You may cast spells while polymorphed.");
		bCastWhileShaped = TRUE;
	}
	else
	{
		ePoly = EffectLinkEffects(ePoly, EffectSpellFailure(100));
	}
	
	if ( bCastWhileShaped )
	{
		SendMessageToPC(oCaster, "Castable polymorph effect here.");
		ePoly = EffectLinkEffects( ePoly, EffectPolymorph(nPoly, FALSE, TRUE ) );
	}
	else
	{
		ePoly = EffectLinkEffects(ePoly, EffectPolymorph(nPoly, FALSE, bWildShape)); // AFW-OEI 11/27/2006: Use 3rd boolean to say this is a wildshape polymorph.
	}
	
	if ( nMasterSpellID == SPELL_TENSERS_TRANSFORMATION )
	{
		int iSpellPower = HkGetSpellPower( oCaster );
		ePoly = EffectLinkEffects(ePoly, EffectSavingThrowIncrease(SAVING_THROW_FORT, 5));
		ePoly = EffectLinkEffects(ePoly, EffectAttackIncrease(iSpellPower/2));
		ePoly = EffectLinkEffects(ePoly, EffectModifyAttacks(2));
	}
	else if ( nMasterSpellID==SPELL_I_HELLSPAWNGRACE )
	{
		// 
		ePoly = EffectLinkEffects(ePoly, EffectDamageReduction(5, DR_TYPE_NONE, 0, DR_TYPE_NONE) );
		nSR = 19;
		ePoly = EffectLinkEffects(ePoly, EffectConcealment(50));
		ePoly = EffectLinkEffects(ePoly, EffectDamageResistance(DAMAGE_TYPE_FIRE, 10));
	}
	else if ( nMasterSpellID==SPELL_I_WORD_OF_CHANGING )
	{
		ePoly = EffectLinkEffects(ePoly, EffectDamageReduction(10, GMATERIAL_METAL_ALCHEMICAL_SILVER, 0, DR_TYPE_GMATERIAL)  );
	}
	
	if ( nSR > 0 )
	{
		ePoly = EffectLinkEffects(ePoly, EffectSpellResistanceIncrease(nSR) );
	}
	
	if (bWildShape)
	{	
		ePoly = SupernaturalEffect(ePoly); // IF WILDSHAPE, MAKE SUPERNATURAL
	}
	else
	{
		ePoly = EffectLinkEffects(ePoly,  EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oCaster, iSpellId ) ) );
	}
	
	
	
	CSLTimedFlag(oCaster, "LOADING", 2.0); // THIS SKIPS THE ON-EQUIP CHECK
	SCRemoveWildShapeEffects( oCaster, nMasterSpellID );
	
	int nHeal = GetMaxHitPoints() - GetCurrentHitPoints();
	if (nHeal > 0 && CSLGetPreferenceSwitch("AllowWildshapeHeal",FALSE) )
	{
		effect eHeal = EffectHeal(nHeal);
	    DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oCaster));		
	}
	else
	{
		DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), oCaster));	
	}
	
	
	ClearAllActions(); // prevents an exploit
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oCaster, fDuration, nMasterSpellID);
	
	// hell hounds are invisible as well
	if ( nMasterSpellID==SPELL_I_HELLSPAWNGRACE )
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility( INVISIBILITY_TYPE_NORMAL ), oCaster, fDuration, nMasterSpellID);
	}
	
	
	if (bMerge)
	{
		if (bWeapon)
		{
			SendMessageToPC(oCaster, "Merging Weapons into new form...");
			object oWeapon1New = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
			PolyMergeItem(oWeapon1Old, oWeapon1New, TRUE);
			if (GetIsObjectValid(oWeapon2Old))
			{
				object oWeapon2New = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
				PolyMergeItem(oWeapon2Old, oWeapon2New, TRUE);
			}
		}
		object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCaster);
		if (bArmor)
		{
			SendMessageToPC(oCaster, "Merging Armor into new form...");
			PolyMergeItem(oHelmetOld, oArmorNew);
			PolyMergeItem(oArmorOld, oArmorNew);
			PolyMergeItem(oShield, oArmorNew);
		}
		if (bItems)
		{
			SendMessageToPC(oCaster, "Merging Items into new form...");
			PolyMergeItem(oRing1Old, oArmorNew);
			PolyMergeItem(oRing2Old, oArmorNew);
			PolyMergeItem(oAmuletOld, oArmorNew);
			PolyMergeItem(oCloakOld, oArmorNew);
			PolyMergeItem(oBootsOld, oArmorNew);
			PolyMergeItem(oBeltOld, oArmorNew);
			
			//PolyMergeItem(oBracerOld,oArmorNew); // if it's not bracers, the properties will have been removed
		}
		
		int iWildShapeTierLevel = CSLGetPreferenceInteger("UseWildshapeTiers",3);
		if (iWildShapeTierLevel)
		{
			if (iWildShapeTierLevel > 2)
			{
				CSLWildShapeCopyItemProperties(oCloakOld,oArmorNew);	
			}
			///object oBracer = GetItemInSlot(INVENTORY_SLOT_ARMS,OBJECT_SELF);
			if (iWildShapeTierLevel > 1)
			{
				CSLWildShapeCopyItemProperties(oBootsOld,oArmorNew);
				CSLWildShapeCopyItemProperties(oBeltOld,oArmorNew);	
				if (GetIsObjectValid(oBracerOld))	
				{
					if (GetBaseItemType(oBracerOld) == BASE_ITEM_GLOVES)
					{
						CSLWildShapeCopyItemProperties(oBracerOld,oArmorNew);
					}
				}					
			}
			if (iWildShapeTierLevel > 0)
			{
				CSLWildShapeCopyItemProperties(oRing1Old,oArmorNew);
				CSLWildShapeCopyItemProperties(oRing2Old,oArmorNew);
				CSLWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
				if (GetIsObjectValid(oBracerOld))	
				{
					if (GetBaseItemType(oBracerOld) == BASE_ITEM_BRACER)
					{
						CSLWildShapeCopyItemProperties(oBracerOld,oArmorNew);
					}
				}		
			}
		
		
		}
	}
	
	if (bWildShape)
	{
		PolyApplyElementalBonuses( oCaster, fDuration, nPoly );
		PolyApplyClassFeats( oCaster, fDuration, oWeapon1Old, oWeapon2Old );
		PolyApplyNatureWarrior( oAmuletOld, fDuration);
	}
	
	if ( nMasterSpellID==SPELL_I_HELLSPAWNGRACE )
	{
		DelayCommand(2.0, PolyBuffHellhound(fDuration, GetHasFeat(FEAT_GUTTURAL_INVOCATIONS, oCaster) ));
	}
	SCWildshapeCheck( oCaster, oCursedPolyItem, nMasterSpellID );
	
	if ( CSLGetPreferenceSwitch("UnarmedPolymorphFeatFix",FALSE) )
	{
		DelayCommand(2.0f, WildShape_Unarmed(oCaster, fDuration));
	}	
}





//------------------------------------------------------------------------------
// GZ, 2003-07-09
// Introduces an artifical limit on the special abilities of the Greater
// Wildshape forms,in order to work around the engine limitation
// of being able to cast any assigned spell an unlimited number of times
//------------------------------------------------------------------------------
void ShifterSetGWildshapeSpellLimits(int iSpellId)
{
	string sId;
	int iLevel = GetLevelByClass(CLASS_TYPE_SHIFTER);
	switch (iSpellId)
	{
			case 673:       // Drider Shape
								sId = "688"; // SpellIndex of Drider Darkness Ability
								SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1 + iLevel/10);
								break;

			case  670 :     // Basilisk Shape
								sId = "687"; // SpellIndex of Petrification Gaze Ability
								SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1 + iLevel/5);
								break;

			case 679 :      // Medusa Shape
								sId = "687"; // SpellIndex of Petrification Gaze Ability
								SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1+ iLevel/5);
								break;

			case 682 :      // Drow shape
								sId = "688"; // Darkness Ability
								SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId,1+ iLevel/10);
								break;

			case 691 :      // Mindflayer shape
								sId = "693"; // SpellIndex Mind Blast Ability
								SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1 + iLevel/3);
								break;

			case 705:       // Vampire Domination Gaze
								sId = "800";
								SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, 1 + iLevel/5);
								break;

	}
}


//------------------------------------------------------------------------------
// GZ, 2003-07-09
// Returns and decrements the number of times this ability can be used
// while in this shape. See x2_s2_gwildshp for more information
// Do not place this on any spellscript that is not called
// exclusively from Greater Wildshape
//------------------------------------------------------------------------------
int ShifterDecrementGWildShapeSpellUsesLeft()
{
	string sId = IntToString(GetSpellId());
	int nLimit = GetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId);
	nLimit --;
	{
			SetLocalInt(OBJECT_SELF,"X2_GWILDSHP_LIMIT_" + sId, nLimit);
	}
	nLimit++;
	return nLimit;
}

//------------------------------------------------------------------------------
// GZ, Oct 19, 2003
// Used for the scaling DC of various shifter abilities.
// Parameters:
// oPC              - The Shifter
// nShifterDCConst  - SHIFTER_DC_VERY_EASY, SHIFTER_DC_EASY,
 //                   SHIFTER_DC_NORMAL, SHIFTER_DC_HARD, SHIFTER_DC_EASY_MEDIUM
// bAddDruidLevels  - Take druid levels into account
//------------------------------------------------------------------------------
int ShifterGetSaveDC(object oPC, int nShifterDCConst = SHIFTER_DC_NORMAL, int bAddDruidLevels = FALSE)
{
	int iDC;

	//--------------------------------------------------------------------------
	// Calculate the overall level of the shifter used for DC determination
	//--------------------------------------------------------------------------
	int iLevel = GetLevelByClass(CLASS_TYPE_SHIFTER,oPC);
	if (bAddDruidLevels)
	{
			iLevel += GetLevelByClass(CLASS_TYPE_DRUID,oPC);
	}

	//--------------------------------------------------------------------------
	// Calculate the DC based on the requested DC constant
	//--------------------------------------------------------------------------
	switch(nShifterDCConst)
	{

			case  SHIFTER_DC_VERY_EASY :
											iDC = 10 + iLevel /3;
											break;

			case  SHIFTER_DC_EASY  : iDC = 10 + iLevel /2;
											break;

			case  SHIFTER_DC_EASY_MEDIUM:
											iDC = 12 + iLevel/2;
											break;

			case  SHIFTER_DC_NORMAL:
											iDC = 15 + iLevel /2;
											break;
			case  SHIFTER_DC_HARD  :
											iDC = 10 + iLevel;
											break;
	}

	return iDC;
}

//------------------------------------------------------------------------------
// GZ, Oct 19, 2003
// Returns TRUE if the shifter's current weapon should be merged onto his
// newly equipped melee weapon
//------------------------------------------------------------------------------
int ShifterMergeWeapon (int nPolymorphConstant)
{
	int nRet = StringToInt(Get2DAString("polymorph","MergeW",nPolymorphConstant)) == 1;
	return nRet;
}

//------------------------------------------------------------------------------
// GZ, Oct 19, 2003
// Returns TRUE if the shifter's current armor should be merged onto his
// creature hide after shifting.
//------------------------------------------------------------------------------
int ShifterMergeArmor  (int nPolymorphConstant)
{
	int nRet  = StringToInt(Get2DAString("polymorph","MergeA",nPolymorphConstant)) == 1;
	return nRet;
}

//------------------------------------------------------------------------------
// GZ, Oct 19, 2003
// Returns TRUE if the shifter's current items (gloves, belt, etc) should
// be merged onto his creature hide after shifting.
//------------------------------------------------------------------------------
int ShifterMergeItems  (int nPolymorphConstant)
{
	int nRet = StringToInt(Get2DAString("polymorph","MergeI",nPolymorphConstant)) == 1;
	return nRet;
}
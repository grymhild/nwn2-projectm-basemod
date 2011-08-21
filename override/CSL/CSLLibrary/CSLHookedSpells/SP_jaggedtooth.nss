//::///////////////////////////////////////////////
//:: Jagged Tooth
//:: nw_s0_jagtooth.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	This spell doubles the critical threat range of one natural weapon
	that deals either slashing or peircing damage.  Multiple spell effects
	that increase a weapon's threat range don't stack.  This spell is
	typically cast on animal companions.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 19, 2006
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008:
//::  Workarond: adds Improved Critical instead of Keen
//::  Works on Magical Beasts and Dragons
//:: RPGplayer1 04/04/2008: Added feedback for wrong target


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




#include "_CSLCore_Items"

void main()
{
	//scSpellMetaData = SCMeta_SP_jaggedtooth();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_JAGGED_TOOTH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );



//Declare major variables
	object oTarget = HkGetSpellTarget();
	//object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
	//object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
	//object oWeapon3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget);
	object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
	//itemproperty iKeen = ItemPropertyKeen();
	//itemproperty iKeen = ItemPropertyKeen();
	itemproperty iImpCritUnarm = ItemPropertyBonusFeat(IP_CONST_FEAT_IMPCRITUNARM);
	itemproperty iNatCritUnarm = ItemPropertyBonusFeat(IPRP_FEAT_IMPCRITCREATURE);
	
	//float fDuration = IntToFloat(600*HkGetSpellDuration(oCaster));
	effect eVis = EffectVisualEffect(VFX_SPELL_DUR_JAGGED_TOOTH);
	
//Determine duration
	fDuration = HkApplyMetamagicDurationMods(fDuration);

//Validate target and apply effect, CSLSafeAddItemProperty automatically handles stacking rules.
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			if ( CSLGetIsAnimalOrBeastOrDragon(oTarget) ) //  GetRacialType(oTarget) == 22 )//Plant	)
			{
				object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
				if (GetIsObjectValid(oHide))	
				{			
					//CSLSafeAddItemProperty(oHide, iKeen, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
					CSLSafeAddItemProperty(oHide, iImpCritUnarm, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
					CSLSafeAddItemProperty(oHide, iNatCritUnarm, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);												
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
				}
				else
				{
					oHide = CreateItemOnObject("x2_it_emptyskin", oTarget, 1, "", FALSE);
					//CSLSafeAddItemProperty(oHide, iKeen, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
					CSLSafeAddItemProperty(oHide, iImpCritUnarm, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
					CSLSafeAddItemProperty(oHide, iNatCritUnarm, fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING);												
					DelayCommand(fDuration, DestroyObject(oHide,0.0f,FALSE));
					AssignCommand(oTarget, ClearAllActions());
					AssignCommand(oTarget, ActionEquipItem(oHide,INVENTORY_SLOT_CARMOUR));	
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);				
				}
				/*
				if (GetIsObjectValid(oWeapon1))
				{
					if (!CSLItemGetIsBludgeoningWeapon(oWeapon1))
					{
						CSLSafeAddItemProperty(oHide, iKeen, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
					}
				}
				else if (GetIsObjectValid(oWeapon2))
				{
					if (!CSLItemGetIsBludgeoningWeapon(oWeapon2))
					{
						CSLSafeAddItemProperty(oHide, iKeen, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
					}
				}
				else if (GetIsObjectValid(oWeapon3))
				{
					if (!CSLItemGetIsBludgeoningWeapon(oWeapon3))
					{
						CSLSafeAddItemProperty(oHide, iKeen, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);
					}
				}
				*/
			}
			else FloatingTextStrRefOnCreature(SCSTR_REF_FEEDBACK_SPELL_INVALID_TARGET, oTarget);
		}
	}
	
	HkPostCast(oCaster);
}


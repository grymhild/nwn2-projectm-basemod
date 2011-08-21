//::///////////////////////////////////////////////
//:: Stormlord Elemental Weapons
//:: nx_s2_stormlordelementalweapons
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	At 2nd level, a stormlord may enchant any equipped
	thrown weapon or spear to deal an additional 1d8
	points of electricity damage.  This effect lasts
	20 rounds.
	
	At 5th level, a stormlord may enchant any equipped
	thrown weapon or spear to deal an additional 1d8
	points of electricity damage and an extra 2d8 points
	of weapon damage on a critical hit (4d8 if the
	critical multiplier is x3, 6d8 if the critical
	multiplier is x4).  This effect lasts 20 rounds.

	At 8th level, a stormlord may enchant any equipped
	thrown weapon or spear to deal an additional 1d8
	points of electricity damage, an extra 1d8 points
	of sonic damage, and an extra 2d8 points of weapon
	damage on a critical hit (4d8 if the critical
	multiplier is x3, 6d8 if the critical multiplier
	is x4).  This effect lasts 20 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/22/2007
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Class"


void DecStormWeapon(object oCaster)
{
	float fCnt = CSLIncrementLocalFloat(oCaster, "STORMWEAPON", -6.0f);
	if (fCnt > 0.0f ) DelayCommand(6.0f, DecStormWeapon(oCaster));
	if (fCnt < 24.0f) SendMessageToPC(oCaster, "Storm Weapon will expire in " + IntToString( FloatToInt(fCnt/6) ) + " rounds.");
}




void main()
{
	//scSpellMetaData = SCMeta_FT_stormlordwea();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	
	
	float fDuration;
	
	if ( CSLGetPreferenceSwitch("Stormlord24HrBuffDuration",FALSE) )
	{
		fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);	
	}
	else
	{
		fDuration = RoundsToSeconds(20);
	}
	
	
	float fCnt = GetLocalFloat(oCaster, "STORMWEAPON");
	if ( fCnt==0.0f ) // NO COUNTDOWN, START ONE NOW
	{
		DelayCommand(6.0, DecStormWeapon(oCaster));
	}
	SetLocalFloat(oCaster, "STORMWEAPON", fDuration );
	
	
	
	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oCaster, GetSpellId());

//   HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_WAUKEEN_HALO), oCaster, RoundsToSeconds(20));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile("fx_defaultitem_elect.sef"), oCaster, fDuration );

	// Make sure that a thrown weapon or spear is equipped.
	object oTarget = HkGetSpellTarget();
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	if (GetIsObjectValid(oWeapon))
	{
		int nItemType = GetBaseItemType(oWeapon);
		if (!((nItemType == BASE_ITEM_DART) ||
				(nItemType == BASE_ITEM_SHURIKEN) ||
				(nItemType == BASE_ITEM_THROWINGAXE) ||
				(nItemType == BASE_ITEM_SPEAR)) )
		{
			oWeapon = OBJECT_INVALID;
		}
	}

	if (GetIsObjectValid(oWeapon))
	{
		SignalEvent(GetItemPossessor(oWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		MakeStormy(oCaster, oWeapon, fDuration);
	}
	else
	{
		FloatingTextStringOnCreature("Equip a throwing weapon or spear to apply Storm Weapon Damage.", oCaster);
	}
	
	HkPostCast(oCaster);
}
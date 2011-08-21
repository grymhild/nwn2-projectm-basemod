//::///////////////////////////////////////////////
//:: Black Blade of Disaster
//:: SOZ UPDATE BTM
//:: X2_S0_BlckBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a greatsword to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, July 28 - 2003

//#include "x2_i0_spells"
#include "_HkSpell"

//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned( object oCaster, int iClass, int iSpellPower, float fDuration, string sSummonResRef )
{
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
    
    if ( GetIsObjectValid(oSummon) && GetResRef(oSummon) == sSummonResRef ) // make sure it's valid and that it's the correct creature since i will be adding multiple summons later
    {
		//Declare major variables
		int iAbilityBonus;
		
		// "csl_sum_anim_bblade"
		
		// cast from scroll, we just assume +5 ability modifier
		if ( GetSpellCastItem() != OBJECT_INVALID )
		{
			iAbilityBonus = 5;
		}
		else
		{
			int iAbility = CSLGetMainStatByClass( iClass, "DC" );
			int bProdigy = GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCaster );
			int iAbilityBonus = GetAbilityModifier(iAbility, oCaster)+bProdigy;
			
			if (iAbilityBonus > 20 )
			{
				iAbilityBonus = 20;
			}
			
			if (iAbilityBonus > iSpellPower )
			{
				iAbilityBonus = iSpellPower;
			}
			
			if ( iAbilityBonus < 1 )
			{
				iAbilityBonus = 1;
			}
		}
		
		// Make the blade require concentration
		SetLocalInt(oSummon,"X2_L_CREATURE_NEEDS_CONCENTRATION",TRUE);
		SetPlotFlag (oSummon,TRUE);
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oSummon);
		if ( !GetIsObjectValid( oWeapon ) )
		{
			oWeapon = CreateItemOnObject("csl_sum_anim_bbladesword", oSummon); // double check this is the correct item
			AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
		}
		SetDroppableFlag(oWeapon, FALSE);
		
		//Create item on the creature, epuip it and add properties.
		if (iAbilityBonus > 0)
		{
			CSLSetWeaponEnhancementBonus(oWeapon, iAbilityBonus );
		}
    }
}



void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_BLACK_BLADE_OF_DISASTER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;

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
	


	//Declare major variables
	
	
    //Declare major variables
    int iDuration = HkGetSpellDuration( oCaster );
    effect eSummon = EffectSummonCreature("csl_sum_anim_bblade");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	iClass = HkGetSpellClass();
	int iSpellPower = HkGetSpellPower( oCaster, 20, iClass );
	

    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, HkGetSpellTargetLocation());
    ApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fDuration);
    DelayCommand(1.5, spellsCreateItemForSummoned( oCaster, iClass, iSpellPower, fDuration, "csl_sum_anim_bblade"  ));
	
	HkPostCast(oCaster);
}

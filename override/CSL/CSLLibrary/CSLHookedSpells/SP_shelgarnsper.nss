//::///////////////////////////////////////////////
//:: Shelgarn's Persistent Blade
//:: SOZ UPDATE BTM
//:: X2_S0_PersBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dagger to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, Aug 2003

//#include "x2_i0_spells"
//#include "x2_inc_spellhook"
#include "_HkSpell"

//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned(object oCaster, int iClass, int iSpellPower, float fDuration, string sSummonResRef )
{
    //Declare major variables
    // int nStat = GetIsMagicStatBonus(oCaster) / 2;
	
	 object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
	 
	 // "nx1_dagger01"
	if ( GetIsObjectValid(oSummon) && GetResRef(oSummon) == sSummonResRef ) // make sure it's valid and that it's the correct creature since i will be adding multiple summons later
    {
		int iAbilityBonus;
		// cast from scroll, we just assume +1 ability modifier
		if ( GetSpellCastItem() != OBJECT_INVALID )
		{
			iAbilityBonus = 1;
		}
		else
		{
			int iAbility = CSLGetMainStatByClass( iClass, "DC" );	
			int bProdigy = GetHasFeat(FEAT_SPELLCASTING_PRODIGY, oCaster );
			int iAbilityBonus =  GetAbilityModifier(iAbility, oCaster)+bProdigy;
				
			// GZ: Just in case...
			if ( iAbilityBonus > iSpellPower )
			{
				iAbilityBonus = 20;
			}
			
			if ( iAbilityBonus > 20 )
			{
				iAbilityBonus = 20;
			}
			
			if ( iAbilityBonus < 0 )
			{
				iAbilityBonus = 0;
			}
		}
    
    
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oSummon);
        //Create item on the creature, epuip it and add properties.
        if ( !GetIsObjectValid( oWeapon ) )
        {
        	oWeapon = CreateItemOnObject("nx1_dagger01", oSummon); // double check this is the correct item
        	AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
        }
        // GZ: Fix for weapon being dropped when killed
        SetDroppableFlag(oWeapon,FALSE);
        
        // GZ: Check to prevent invalid item properties from being applies
        if (iAbilityBonus>0)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus( iAbilityBonus ), oWeapon,fDuration);
        }
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageReduction(5,IP_CONST_DAMAGEREDUCTION_1),oWeapon,fDuration );
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
	int iSpellId = SPELLR_SHELGARNS_PERSISTENT_BLADE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
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
    iClass = HkGetSpellClass();
	int iSpellPower = HkGetSpellPower( oCaster, 5, iClass );
	
	
    int iDuration = CSLGetMax( 1, HkGetSpellDuration( oCaster )/2 );

    effect eSummon = EffectSummonCreature("csl_sum_anim_dagger1");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    
    float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, HkGetSpellTargetLocation());
    ApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fDuration );

    DelayCommand(1.5, spellsCreateItemForSummoned(oCaster, iClass, iSpellPower, fDuration, "nx1_dagger01" ));
    
    HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Spell Template
//:: sp_template.nss
//:: 2009 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
Divination
Level:	Clr 0, Drd 0, Pal 1, Rgr 1, Sor/Wiz 0
Components:	V, S
Casting Time:	1 standard action
Range:	Close (25 ft. + 5 ft./2 levels)
Target or Area:	One creature, one object, or a 5-ft. cube
Duration:	Instantaneous
Saving Throw:	None
Spell Resistance:	No
You determine whether a creature, object, or area has been poisoned or is poisonous. You can determine the exact type of poison with a DC 20 Wisdom check. A character with the Craft (alchemy) skill may try a DC 20 Craft (alchemy) check if the Wisdom check fails, or may try the Craft (alchemy) check prior to the Wisdom check.
The spell can penetrate barriers, but 1 foot of stone, 1 inch of common metal, a thin sheet of lead, or 3 feet of wood or dirt blocks it.
*/
//:://////////////////////////////////////////////
//:: Based on Work of: Author
//:: Created On:
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	
	location lTarget = HkGetSpellTargetLocation();

	int iDuration = HkGetSpellDuration(oCaster);
	int iSpellPower = HkGetSpellPower(oCaster, 10);
	
	int iSaveDC = HkGetSpellSaveDC();
	
	int iDamageType = HkGetDamageType(DAMAGE_TYPE_FIRE);
	int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_FIRE);
	
	float fTargetSize = HkApplySizeMods( RADIUS_SIZE_HUGE );
	int iTargetShape = HkApplyShapeMods( SHAPE_SPHERE );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	int iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect( HkGetHitEffect(VFX_IMP_FLAME_M) );
	effect eHit;
	
	//--------------------------------------------------------------------------
	// AOE
	//--------------------------------------------------------------------------
	//string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	//effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "", "", "", sAOETag);
	//DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	
	//--------------------------------------------------------------------------
	// Remove Previous Versions of this spell
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	
	
	//--------------------------------------------------------------------------
	// Apply effects
	//--------------------------------------------------------------------------
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	// Visual
	effect eExplode = EffectVisualEffect( HkGetShapeEffect( VFX_FNF_FIREBALL ) );
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

// detect poison from taleron, review this to see if it's workable
/*//
// Detect Poison Script
// By: Terry Reinert
//
// A character can determine the type of poison with a successful
// Wisdom check against DC20. A character with Craft(Alchemy) skill
// can make a skill check if the wisdom check fails.
//
//#include "x2_inc_itemprop"
//#include "sh_custom_functions"

const int DetectPoisonDC = 20;	// DC of wisdom and skill checks

//
// Forward Declarations
//
int IPGetItemHasItemOnMonsterHitPropertySubType(object oTarget, int nSubType);


#include "_HkSpell"

void main()
{	
	
	object 	oPC 	= OBJECT_SELF;
	object 	oTarget = GetSpellTargetObject();

	//
	// Error Check: Target must be valid.
	//
	if ( !GetIsObjectValid( oTarget ) )
	{
		return;
	}

	//
	// In order to cast the detect poison PNP spell the PC must have a specific spell memorized
	// to act as though they had memorized detect poison. The spell requirements are as follows:
	// Level: 	Clr 0, Drd 0, Pal 1, Rgr 1, Sor/Wiz 0
	//
	// Thus, for cleric, druid, paladin, sorceror, or wizard the spell RESISTANCE is used. For
	// a ranger class PC the spell RESIST ENERGY is used.
	//
//	int didCastSpell = FALSE;

	//
	// In order to determine which spell to use check to see if the PC has any levels in any of
	// the spell casting classes. The number of levels does not matter; this is only concerned
	// with selecting the spell casting class they have levels in.
	//
//	if ( ( GetLevelByClass( CLASS_TYPE_CLERIC , oPC ) > 0 ) ||
//		( GetLevelByClass( CLASS_TYPE_DRUID 	, oPC ) > 0 ) ||/
//		( GetLevelByClass( CLASS_TYPE_PALADIN , oPC ) > 0 ) ||
//		( GetLevelByClass( CLASS_TYPE_SORCERER, oPC ) > 0 ) ||
//		( GetLevelByClass( CLASS_TYPE_WIZARD , oPC ) > 0 ) )
//	{
//		didCastSpell = BurnASpell( SPELL_RESISTANCE, oPC );
//	}
//	else if ( GetLevelByClass( CLASS_TYPE_RANGER, oPC ) > 0 )
//	{
//		didCastSpell = BurnASpell( SPELL_RESIST_ENERGY, oPC );
//	}

	//
	// If the PC was able to cast the spell, run the algorithm.
	//
//	if ( didCastSpell )
//	{
	//
	// TARGET IS POISONED
	//
		int thePoisonType = -1;

		//
		// Iterate through all the effects on the target object and check to see
		// if any are a poison. If so, then set the integer associated with
		// the poison type.
		//
		effect eEffect = GetFirstEffect( oTarget );

		while ( GetIsEffectValid( eEffect ) )
		{
			if ( GetEffectType( eEffect ) == EFFECT_TYPE_POISON )
			{
				thePoisonType = GetEffectInteger( eEffect, EFFECT_TYPE_POISON );
			}

			eEffect = GetNextEffect( oTarget );
		}

		if ( thePoisonType > 0 )
		{
			//
			// Before doing anything else roll the wisdom check and apply modifiers then check
			// to see if the any of the rolls were successful. If not, do nothing. If so, then
			// run the detect poison algorithm.
			//
			int wisdomCheck = ( ( Random( 20 ) + 1 ) + GetAbilityModifier( ABILITY_WISDOM ) );

			int detectedPoisonType = ( wisdomCheck >= DetectPoisonDC ) || (
					GetHasSkill( SKILL_CRAFT_ALCHEMY ) &&
					GetIsSkillSuccessful( oPC, SKILL_CRAFT_ALCHEMY, DetectPoisonDC ) );
			//
			// If the check was successful then inform the PC of the poison type. If the
			// check isn't successful then inform the PC that the target is poisoned but
			// do not indicate which type of poison.
			//
			if ( detectedPoisonType )
			{
				string poisonName = Get2DAString( "poison", "Label", thePoisonType );

				string message = GetName( oTarget ) + " is poisoned with "
					+ poisonName + ".";

				SendMessageToPC( oPC, message );
			}
			else
			{
				SendMessageToPC( oPC, GetName( oTarget ) + " is poisoned." );
			}
		}
		else
		{
			SendMessageToPC( oPC, GetName( oTarget ) + " is not poisoned." );
		}
	//
	// TARGET IS POISONOUS
	//

		//
		// Check to see if the targets equiped weapon or natural weapon is poisonous.
		//
		if (
			// Creature Natural Attacks (Bite, Left Claw, Right Claw)
			IPGetItemHasItemOnMonsterHitPropertySubType ( GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oTarget ), IP_CONST_ONMONSTERHIT_POISON ) ||
			IPGetItemHasItemOnMonsterHitPropertySubType ( GetItemInSlot( INVENTORY_SLOT_CWEAPON_L, oTarget ), IP_CONST_ONMONSTERHIT_POISON ) ||
			IPGetItemHasItemOnMonsterHitPropertySubType ( GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oTarget ), IP_CONST_ONMONSTERHIT_POISON ) ||

			// Equiped Weapons (Left Hand, Right Hand)
			IPGetItemHasItemOnHitPropertySubType ( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oTarget ), IP_CONST_ONHIT_ITEMPOISON ) ||
			IPGetItemHasItemOnHitPropertySubType ( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oTarget ), IP_CONST_ONHIT_ITEMPOISON ) ||

			// Ammunition (Arrows, Bolts, Bullets)
			IPGetItemHasItemOnHitPropertySubType ( GetItemInSlot( INVENTORY_SLOT_ARROWS, 	oTarget ), IP_CONST_ONHIT_ITEMPOISON ) ||
			IPGetItemHasItemOnHitPropertySubType ( GetItemInSlot( INVENTORY_SLOT_BOLTS, 	oTarget ), IP_CONST_ONHIT_ITEMPOISON ) ||
			IPGetItemHasItemOnHitPropertySubType ( GetItemInSlot( INVENTORY_SLOT_BULLETS, 	oTarget ), IP_CONST_ONHIT_ITEMPOISON ) ||

			// Item on the ground or selected in inventory
			IPGetItemHasItemOnHitPropertySubType ( oTarget, IP_CONST_ONHIT_ITEMPOISON ) )
		{
			//
			// The item or creature is poisonous
			//
			SendMessageToPC( oPC, GetName( oTarget ) + " is poisonous." );
		}
		else
		{
			//
			// The item or creature is no poisonous
			//
			SendMessageToPC( oPC, GetName( oTarget ) + " is not poisonous." );
		}

}

// ----------------------------------------------------------------------------
// Returns TRUE if an item has ITEM_PROPERTY_ON_MONSTER_HIT.
//
// Note that this function is copied from IPGetItemHasItemOnHitPropertySubType
// but modified for monster hits instead of on hits. The script above does
// not account for monster hits so it had to be duplicated and modified so that
// the detect poison spell will determine if a monster is poisonous. Very annoying
// but obviously an oversight on Obsidians part.
// ----------------------------------------------------------------------------
int IPGetItemHasItemOnMonsterHitPropertySubType(object oTarget, int nSubType)
{
	itemproperty ipTest = GetFirstItemProperty(oTarget);

	//
	// loop over item properties to see if there is already a poison effect
	//
	while (GetIsItemPropertyValid(ipTest))
	{
		if (GetItemPropertySubType(ipTest) == nSubType)
		{
			return TRUE;
		}

	ipTest = GetNextItemProperty(oTarget);

	}

	return FALSE;
}
*/
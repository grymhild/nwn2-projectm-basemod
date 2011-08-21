//::///////////////////////////////////////////////
//:: Light (Drow/Aasimar Racial Ability)
//:: NW_S2_Light.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Light
	Evocation [Light]
	Level:	Brd 0, Clr 0, Drd 0, Sor/Wiz 0
	Components:	V, M/DF
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	This spell causes an object to glow like a torch, shedding bright light
	in a 20-foot radius (and dim light for an additional 20 feet) from the
	point you touch. The effect is immobile, but it can be cast on a
	movable object. Light taken into an area of magical darkness does not
	function.
	
	A light spell (one with the light descriptor) counters and dispels a
	darkness spell (one with the darkness descriptor) of an equal or lower
	level.
	
	Arcane Material Component A firefly or a piece of phosphorescent moss.
	
	
	Applies a light source to the target for
	1 hour per level

	XP2
	If cast on an item, item will get temporary
	property "light" for the duration of the spell
	Brightness on an item is lower than on the
	continual light version.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: Added XP2 cast on item code: Georg Z, 2003-06-05
//:://////////////////////////////////////////////
// JLR-OEI 03/16/06: For GDD Update
#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_LIGHT, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//Declare major variables
	object oTarget = HkGetSpellTarget();

	int iDuration;
	int iMetaMagic;

	// Handle spell cast on item....
	if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CSLItemGetIsCraftingBaseItem(oTarget))
	{
		if( !CSLEnviroGetIsHigherLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel, 1.0f ) )
        {
			// Do not allow casting on not equippable items
			if (!CSLItemGetIsEquipable(oTarget))
			{
			// Item must be equipable...
				FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
				return;
			}
	
			itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE);
	
			if (GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT))
			{
				CSLRemoveMatchingItemProperties(oTarget,ITEM_PROPERTY_LIGHT,DURATION_TYPE_TEMPORARY);
			}
	
			iDuration = HkGetSpellDuration(oCaster,60,CLASS_TYPE_RACIAL); // GetTotalLevels( OBJECT_SELF, TRUE); //HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
			//Enter Metamagic conditions
			
			float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
			int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
			AddItemProperty(iDurType,ip,oTarget, fDuration);
		}
		else
		{
			SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Darkness");
		}
	}
	else
	{
		
		if(!CSLEnviroGetIsHigherLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel ) )
        {
			if ( CSLEnviroRemoveLowerLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel ) )
			{
				SendMessageToPC( oCaster, "The Dark Was Extinguished By The Light");
			}


			// JLR-OEI 03/21/06: Changed to match normal light spell changes
			//effect eVis = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
			//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
			//effect eLink = EffectLinkEffects(eVis, eDur);
			effect eVis = EffectVisualEffect(VFX_DUR_LIGHT);
	
			iDuration = HkGetSpellDuration(oCaster,60,CLASS_TYPE_RACIAL); // GetTotalLevels(OBJECT_SELF, TRUE); //HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
			
			float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
			int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHT, FALSE));
	
			//Apply the VFX impact and effects
			//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
			HkApplyEffectToObject(iDurType, eVis, oTarget, fDuration );
		}
		else
		{
			SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Darkness");
		}
	}
	HkPostCast(oCaster);
}
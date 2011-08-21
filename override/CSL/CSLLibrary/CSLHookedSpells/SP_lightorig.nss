//::///////////////////////////////////////////////
//:: Light
//:: NW_S0_Light.nss
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

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{
	//scSpellMetaData = SCMeta_SP_light();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LIGHT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 0;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_LIGHT, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//SetLocalObject(OBJECT_SELF,"LastUser", oPC);
	//DisplayInputBox(oCaster, 0, "Please enter the school of specialization for your character", "gui_set_school", "", FALSE, "", 181744, "", 181745, "", "General","");
	
	//DisplayGuiScreen( oCaster, "SCREEN_CHARACTER", TRUE );
	//	"SCREEN_PLAYERLIST"
	//DisplayGuiScreen( oCaster, "SCREEN_PLAYERLIST", FALSE  );

	
	//Declare major variables
	object oTarget = HkGetSpellTarget();

	int iDuration = HkGetSpellDuration( OBJECT_SELF, 60 ); // OldGetCasterLevel(OBJECT_SELF);
			
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	// Handle spell cast on item....
	if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CSLItemGetIsCraftingBaseItem(oTarget))
	{
		if(!CSLEnviroGetIsHigherLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel, 1.0f ) )
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
	
			AddItemProperty(iDurType,ip,oTarget,fDuration);
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
			
			effect eVis = EffectVisualEffect(VFX_DUR_LIGHT);

			iDuration = HkGetSpellDuration( OBJECT_SELF, 60 ); // OldGetCasterLevel(OBJECT_SELF);
			
			float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
			int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LIGHT, FALSE));

			//Apply the VFX impact and effects
			HkApplyEffectToObject(iDurType, eVis, oTarget, fDuration );
		}
		else
		{
			SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Darkness");
		}
	}
	HkPostCast(oCaster);
}
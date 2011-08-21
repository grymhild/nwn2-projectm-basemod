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
#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LIGHT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 0;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP;
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
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag = HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink    = EffectLinkEffects(eVis, eDur);
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_LIGHT, "", "", "", sAOETag);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CSLItemGetIsCraftingBaseItem(oTarget) )
    {
		SendMessageToPC( oCaster, "Light On Items Is Back Under Development");
		/*
		
		// So basically mark the item as having light, and on equip, or placing on the ground, create a light effect anew
		
		if(!CSLEnviroGetIsHigherLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel, 1.0f ) )
        {
			// Do not allow casting on not equippable items
			if (!CSLItemGetIsEquipable(oTarget)) {
			// Item must be equipable...
				FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
				return;
			}
	
			itemproperty ip = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE);
	
			if(GetItemHasItemProperty(oTarget, ITEM_PROPERTY_LIGHT))
			{
				CSLRemoveMatchingItemProperties(oTarget,ITEM_PROPERTY_LIGHT,DURATION_TYPE_TEMPORARY);
			}
			CSLSafeAddItemProperty(oTarget, ip, fDuration);
        }
		else
		{
			SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Darkness");
		}
		*/
        
    }
    else
    {
		iDuration = HkGetSpellDuration( OBJECT_SELF, 60 ); // OldGetCasterLevel(OBJECT_SELF);
			
		float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
		int iDurationType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
		SCApplyLightToObject( oTarget, oCaster, SPELL_LIGHT, iSpellPower, iSpellLevel, fDuration, iDurationType, VFX_DUR_LIGHT, AOE_MOB_LIGHT, 6.0f );
    }

    HkPostCast();
}
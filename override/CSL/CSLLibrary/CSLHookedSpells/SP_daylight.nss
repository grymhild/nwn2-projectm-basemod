//::///////////////////////////////////////////////
//:: Daylight
//:: SP_daylight.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*

	Daylight
	Evocation [Light]
	Level:	Brd 3, Clr 3, Drd 3, Pal 3, Sor/Wiz 3
	Components:	V, S
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	
	The object touched sheds light as bright as full daylight in a 60-foot
	radius, and dim light for an additional 60 feet beyond that. Creatures
	that take penalties in bright light also take them while within the
	radius of this magical light. Despite its name, this spell is not the
	equivalent of daylight for the purposes of creatures that are damaged
	or destroyed by bright light.
	
	If daylight is cast on a small object that is then placed inside or
	under a light-proof covering, the spell’s effects are blocked until the
	covering is removed.
	
	Daylight brought into an area of magical darkness (or vice versa) is
	temporarily negated, so that the otherwise prevailing light conditions
	exist in the overlapping areas of effect.
	
	Daylight counters or dispels any darkness spell of equal or lower
	level, such as darkness.
*/
#include "_HkSpell"
#include "_SCInclude_Light"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*10, SC_DURCATEGORY_MINUTES) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink    = EffectLinkEffects(eVis, eDur);
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_DAYLIGHT, "", "", "", sAOETag);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CSLItemGetIsCraftingBaseItem(oTarget) )
    {
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
        
    }
    else
    {
		if(!CSLEnviroGetIsHigherLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel, 60.0f ) )
        {
			if ( CSLEnviroRemoveLowerLevelDarknessEffectsInArea( GetLocation(oTarget), iSpellLevel ) )
			{
				SendMessageToPC( oCaster, "The Dark Was Extinguished By The Light");
			}
			
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
        }
		else
		{
			SendMessageToPC( oCaster, "The Spell Fizzled In The Stronger Darkness");
		}
    }

    HkPostCast();
}
//::///////////////////////////////////////////////
//:: Continual Flame
//:: SOZ UPDATE BTM
//:: x0_s0_clight.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Permanent Light spell

    XP2
    If cast on an item, item will get permanently
    get the property "light".
    Previously existing permanent light properties
    will be removed!

*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 18, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
//:: Added XP2 cast on item code: Georg Z, 2003-06-05
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_CONTINUAL_FLAME;
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
	
		
	
    int iDuration;
    int iMetaMagic;

    object oTarget = HkGetSpellTarget();

    // Handle spell cast on item....
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && ! CSLItemGetIsCraftingBaseItem(oTarget))
    {
        // Do not allow casting on not equippable items
        if (!CSLItemGetIsEquipable(oTarget))
        {
            // Item must be equipable...
            FloatingTextStrRefOnCreature(83326,OBJECT_SELF);
            return;
        }
        itemproperty ip = ItemPropertyLight (IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE);
        CSLSafeAddItemProperty(oTarget, ip, 0.0f,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,TRUE,TRUE);
    }
    else
    {

        //Declare major variables
        effect eVis = (EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20));
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = SupernaturalEffect(EffectLinkEffects(eVis, eDur));

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

        //Apply the VFX impact and effects
        HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
   }
   
   HkPostCast(oCaster);
}
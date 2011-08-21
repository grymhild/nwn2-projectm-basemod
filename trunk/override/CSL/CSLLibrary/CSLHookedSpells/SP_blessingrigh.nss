//::///////////////////////////////////////////////
//:: Blessing of the Righteous
//:: cmi_s0_blessright
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////
//:: Blessing of the Righteous
//:: Caster Level(s): Paladin 4, Cleric 4
//:: Innate Level: 4
//:: School: Evocation
//:: Descriptor(s): Good
//:: Component(s): Verbal, Somatic
//:: Range: Personal
//:: Area of Effect / Target: All allies in a 40-ft.-radius burst centered on
//:: you
//:: Duration: 1 round/level
//:: Save: None
//:: Spell Resistance: No
//:: You bless yourself and your allies. You and your allies' melee and ranged
//:: attacks deal an extra 1d6 points of holy damage and are considered
//:: good-aligned for the purpose of overcoming damage reduction.
//:: 
//:: A sudden burst of warm, radiant light engulfs you and your allies. The
//:: light fades quickly but lingers on the weapons of those affected.
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_blessingrigh();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Blessing_Righteous;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

		
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_TREMENDOUS);
	
	effect eDmgBonus = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_DIVINE);	
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
	effect eLink = EffectLinkEffects(eDmgBonus,eVis);
	
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
			
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			/*
			object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);		
		   	if(GetIsObjectValid(oWeapon) )
			{
		     
				CSLSafeAddItemProperty(oWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING );
				CSLSafeAddItemProperty(oWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
			   	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oWeapon), fDuration);
		    }
			object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);		
		   	if(GetIsObjectValid(oWeapon2) )
			{
		     
				CSLSafeAddItemProperty(oWeapon2, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING );
				CSLSafeAddItemProperty(oWeapon2, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
			   	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oWeapon2), fDuration);
		    }
			*/			
			
			HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
			
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
    }	
	
	HkPostCast(oCaster);
}      


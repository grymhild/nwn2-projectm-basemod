//::///////////////////////////////////////////////
//:: Flame of Faith
//:: cmi_s0_flamefaith
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//_CSLCore_Items for item properties, reference marker.

#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_flamefaith();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Flame_Faith;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
    object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();	
	
   	if(GetIsObjectValid(oMyWeapon) )
	{
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyEnhancementBonus(1), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_1d10), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE );
	   	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), fDuration);
	   	return;
    }
    else
    {
    	FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    	return;
    }	
	
	HkPostCast(oCaster);
}


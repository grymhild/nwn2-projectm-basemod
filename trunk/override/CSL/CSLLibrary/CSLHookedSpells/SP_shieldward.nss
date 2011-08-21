//::///////////////////////////////////////////////
//:: Shield of Warding
//:: cmi_s0_shldward
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 5, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


// Known issues: This should stack with vs Align, vs Damage, vs Racial, and vs Specific_Align as well.
//  Will need to redo the GetAC to account for it, wrapping it as a new function in the cmi_ginc_spells.
//  "StackShieldBonus(object oShield, int iBonus)" that checks all Item_Props listed above.

//_CSLCore_Items for item properties, reference marker.

#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_shieldward();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Shield_Warding;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	float fDuration = TurnsToSeconds( HkGetSpellDuration( oCaster ) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	
	
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
	eVis = SetEffectSpellId(eVis, iSpellId);
	eVis = SupernaturalEffect(eVis);
	
	
    object oShield   =  CSLGetTargetedOrEquippedShield();	
	object oHolder = GetItemPossessor(oShield);	
	
	if ( GetHasSpellEffect(iSpellId, oHolder))
	{
		SendMessageToPC(OBJECT_SELF, "Shield of Warding is already active on the target. Wait for the spell to expire.");
	}
	
	int nEnhanceBonus = HkCapAB( 1 + (iSpellPower/5) );	
	int nReflex = nEnhanceBonus;
	
   	if(GetIsObjectValid(oShield) )
	{
        SignalEvent(oShield, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		int nCurrent = CSLGetWeaponEnhancementBonus(oShield,ITEM_PROPERTY_AC_BONUS);
		if ( GetLastSpellCastClass() == CLASS_TYPE_PALADIN )
		{
			nEnhanceBonus = nEnhanceBonus + nCurrent;
		}
		else
		{
			nEnhanceBonus = nCurrent++;
		}
		if (GetLastSpellCastClass() == 6)
		{
			CSLSafeAddItemProperty(oShield, ItemPropertyACBonus(nEnhanceBonus), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
		}
		CSLSafeAddItemProperty(oShield, ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_REFLEX, nReflex), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	   	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oHolder, fDuration);
	   	return;
    }
    else
    {
    	FloatingTextStringOnCreature("*Spell Failed: Target must be a shield or creature with a shield equipped.*", OBJECT_SELF);
    	return;
    }
    
	HkPostCast(oCaster);
}


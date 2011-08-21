//::///////////////////////////////////////////////
//:: Blessing of Bahamut
//:: cmi_s0_blessbahamut
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: June 28, 2007
//:: Based on X2_S0_HolySwrd
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_toollib"
#include "_SCInclude_Class"
#include "_SCInclude_Evocation"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_lawfulsword();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Lawful_Sword;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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

    object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();

    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_HOLY_SWORD);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, fDuration);

		CSLSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC,5), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
		CSLSafeAddItemProperty(oMyWeapon,ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_CHAOTIC,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );//Make the sword glow	
   
        //TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(HkGetSpellTarget()), 4, 0.0f, 6.0f);
        DelayCommand(1.0f, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SUNSTRIKE ),GetLocation(HkGetSpellTarget())));
    }
	else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    }
	
	HkPostCast(oCaster);
}


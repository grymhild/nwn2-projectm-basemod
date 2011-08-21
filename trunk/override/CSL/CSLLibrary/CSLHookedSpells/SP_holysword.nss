//::///////////////////////////////////////////////
//:: Holy Sword
//:: X2_S0_HolySwrd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants holy avenger properties.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Evocation"

void main()
{
	//scSpellMetaData = SCMeta_SP_holysword();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HOLY_SWORD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oMyWeapon = CSLGetTargetedOrEquippedMeleeWeapon();
	if (GetIsObjectValid(oMyWeapon))
	{
		float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( HkGetSpellDuration( oCaster ) ));
		object oTarget = GetItemPossessor(oMyWeapon);
		SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SPELL_HOLY_SWORD), oTarget, fDuration);
		CSLSafeAddItemProperty(oMyWeapon,ItemPropertyHolyAvenger(), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE);
		TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(HkGetSpellTarget()), 4, 0.0f, 6.0f);
		DelayCommand(1.0f, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), GetLocation(oTarget)));
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
	}
	
	HkPostCast(oCaster);
}


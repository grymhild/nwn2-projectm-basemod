//::///////////////////////////////////////////////
//:: Magic Vestment
//:: X2_S0_MagcVest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants a +1 AC bonus to armor touched per 4 caster
	levels (maximum of +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller

// Updated (JLR - OEI) 07/12/05 NWN2 3.5


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"






void  AddACBonusToArmor(object oMyArmor, float fDuration, int nAmount)
{
	CSLSafeAddItemProperty(oMyArmor,ItemPropertyACBonus(nAmount), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
		return;
}

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MAGIC_VESTMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	//effect eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MAGIC_VESTMENT );

	int iDuration  = HkGetSpellDuration(oCaster); // OldGetCasterLevel(oCaster);
	
	int nAmount = HkCapAC( HkGetSpellPower(oCaster)/4 ); // JLR - OEI 07/12/05 NWN2 3.5
	
	object oMyArmor = CSLGetTargetedOrEquippedArmor(TRUE);

	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	if(GetIsObjectValid(oMyArmor) )
	{
		SignalEvent(GetItemPossessor(oMyArmor ), EventSpellCastAt(oCaster, GetSpellId(), FALSE));
		if (DEBUGGING >= 8) { CSLDebug(  "AC added "+IntToString( nAmount )+"with original power of "+IntToString(HkGetSpellPower(oCaster))+" should be power divided by 4, capped by 5", oCaster ); }
		if ( iDuration > 0 )
		{
			location lLoc = GetLocation(HkGetSpellTarget());
			//DelayCommand(1.3f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyArmor)));
			HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyArmor), fDuration, GetSpellId() );
			AddACBonusToArmor(oMyArmor, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) ,nAmount);
		}
		return;
	}
	else
	{
		FloatingTextStrRefOnCreature(83826, oCaster);
		return;
	}
	
	HkPostCast(oCaster);
}


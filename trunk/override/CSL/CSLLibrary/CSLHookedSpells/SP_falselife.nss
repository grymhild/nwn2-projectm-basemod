//::///////////////////////////////////////////////
//:: False Life
//:: NW_S0_FalseLife.nss
//:://////////////////////////////////////////////
/*
	Target creature gains +1d10 +1/lvl (max 10)
	temporary HPs.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 11, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_falselife();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FALSE_LIFE;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_ASN_False_Life )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	
	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration( oCaster ); // OldGetCasterLevel(OBJECT_SELF);
	//iDuration += GetLevelByClass(CLASS_TYPE_ASSASSIN);
	//iDuration += GetLevelByClass(CLASS_TYPE_AVENGER);
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS);
	
	int iSpellPower = HkGetSpellPower( oCaster, 10 ); // OldGetCasterLevel(OBJECT_SELF);
	//iSpellPower += GetLevelByClass(CLASS_TYPE_ASSASSIN);
	//iSpellPower += GetLevelByClass(CLASS_TYPE_AVENGER);
		
	int iBonus = d10(1);
	iBonus = HkApplyMetamagicVariableMods(iBonus, 10);
	iBonus = CSLGetMin(20, iSpellPower + iBonus);

	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	CSLUnstackSpellEffects(oTarget, GetSpellId());

	effect eHP = EffectTemporaryHitpoints(iBonus);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_FALSE_LIFE);

	effect eLink = EffectLinkEffects(eHP, eVis);
	eLink = SetEffectSpellId(eLink, SPELL_FALSE_LIFE);
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}


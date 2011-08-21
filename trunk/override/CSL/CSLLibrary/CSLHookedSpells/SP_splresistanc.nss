//::///////////////////////////////////////////////
//:: Spell Resistance
//:: NW_S0_SplResis
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target creature gains 12 + Caster Level SR.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_splresistanc();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPELL_RESISTANCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	object oTarget = HkGetSpellTarget();
	CSLUnstackSpellEffects(oTarget, GetSpellId());
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster );
	int nSR = GetSpellResistance(oTarget);
	int iBonus = (12 + iSpellPower) - nSR;
	if (iBonus<=0) {
		SendMessageToPC(oCaster, "Target already has " + IntToString(nSR) + " SR and is unaffected by your spell.");
		return;
	} else {
		SendMessageToPC(oCaster, "Target's SR was increased by " + IntToString(iBonus) + ".");
	}
	effect eLink = EffectVisualEffect( VFX_DUR_SPELL_SPELL_RESISTANCE );
	eLink = EffectLinkEffects(eLink, EffectSpellResistanceIncrease(iBonus));
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SPELL_RESISTANCE, FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELL_SPELL_RESISTANCE );
	
	HkPostCast(oCaster);
}

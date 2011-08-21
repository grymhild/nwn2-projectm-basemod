//::///////////////////////////////////////////////
//:: Spiderskin
//:: [NW_S0_Spidrskin.nss]
//:://////////////////////////////////////////////
/*
	Gives the target +1 Natural AC, +1 Saves vs.
	Poison, +1 Hide Skill bonus.  At 3rd lvl & every
	3 levels after, bonuses are increased by +1 up
	to maximum of +5 (at 12th lvl).
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 11, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.23
- dodge bonus was stacking
*/



// JLR - OEI 08/24/05 -- Metamagic changes


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_SP_spiderskin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPIDERSKIN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	object oTarget = HkGetSpellTarget();
	int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	float fDuration = TurnsToSeconds( HkGetSpellDuration( OBJECT_SELF ) * 10);

	//effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPIDERSKIN, FALSE));

	int nLvlBonus;
	
	nLvlBonus = iSpellPower / 3;

	int nACBonus = HkCapAC( 1 + nLvlBonus );
	int nPoisonSaveBonus = HkCapSaves( 1 + nLvlBonus );
	int nHideSkillBonus = HkCapSaves( 1 + nLvlBonus );

	//Check for metamagic extend
	fDuration = HkApplyMetamagicDurationMods( fDuration );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Set the bonuses
	effect eAC = EffectACIncrease(nACBonus, AC_NATURAL_BONUS);
	effect ePoison = EffectSavingThrowIncrease(SAVING_THROW_ALL, nPoisonSaveBonus , SAVING_THROW_TYPE_POISON);
	effect eHide = EffectSkillIncrease(SKILL_HIDE, nHideSkillBonus);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_SPIDERSKIN );
	effect eLink = EffectLinkEffects(eAC, ePoison);
	eLink = EffectLinkEffects(eLink, eHide);
	eLink = EffectLinkEffects(eLink, eDur);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());

	//Apply the armor bonuses and the VFX impact
	HkUnstackApplyEffectToObject(iDurType, eLink, oTarget, fDuration, HkGetSpellId());
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	HkPostCast(oCaster);
}


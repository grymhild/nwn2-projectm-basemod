//::///////////////////////////////////////////////
//:: Blindness and Deafness (Svirfneblin Racial Ability)
//:: [NW_S2_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_FT_racialblindn();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


	
	object oTarget = HkGetSpellTarget();
	int iCasterLevel = HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); // GetTotalLevels(oCaster, TRUE);
	int iDC = 14 + HkGetSpellLevel(SPELL_BLINDNESS_AND_DEAFNESS) + GetAbilityModifier(ABILITY_CHARISMA); //+4 from racial bonus
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLINDNESS_AND_DEAFNESS));
		if (!HkResistSpell(oCaster, oTarget))
		{
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
			{
				effect eLink = EffectVisualEffect( VFX_DUR_SPELL_BLIND_DEAF );
				eLink = EffectLinkEffects(eLink, EffectDeaf());
				eLink = EffectLinkEffects(eLink, EffectBlindness());
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iCasterLevel));
			}
		}
	}
	
	HkPostCast(oCaster);
}


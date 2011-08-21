//::///////////////////////////////////////////////
//:: Name 	Evil Eye
//:: FileName sp_evil_eye.nss
//:://////////////////////////////////////////////
/**@file Evil Eye
Enchantment [Evil]
Level: Mortal Hunter 2, Sor/Wiz 3
Components: S
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: Instantaneous (see text)
Saving Throw: Will negates
Spell Resistance: Yes

The caster focuses malevolent wishes through her
gaze and curses someone with bad luck. The subject
takes a -4 luck penalty on all attack rolls,
saves, and checks. The spell ends at the next
sunrise, when dismissed, when a remove curse is
cast on the subject, or when the caster takes at
least 1 point of damage from the subject.

Author: 	Tenjac
Created: 	5/14/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


void DawnCheck(object oTarget, object oCaster, int nRemove)
{
	if(!GetIsDawn())
	{
		nRemove = 1;
	}

	if((nRemove == 1) && (GetIsDawn()))
	{
		RemoveSpellEffects(SPELL_EVIL_EYE, oCaster, oTarget);
		return;
	}

	DelayCommand(HoursToSeconds(1), DawnCheck(oTarget, oCaster, nRemove));
}


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EVIL_EYE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nPenalty = 4;
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);

	//Check Spell Resistance
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//Will save
		if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
		{
			effect eLink = EffectAttackDecrease(nPenalty, ATTACK_BONUS_MISC);
			eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty, SAVING_THROW_TYPE_ALL));
			eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_ALL_SKILLS, nPenalty));

			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);

			//Handle removal via damage
			SetLocalString(oTarget, "EvilEyeCaster", GetName(oCaster));

			//Handle removal via sunrise
			{
				DawnCheck(oTarget, oCaster, 0);
			}
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


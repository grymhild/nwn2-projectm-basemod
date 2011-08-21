//::///////////////////////////////////////////////
//:: Name 	Command Undead
//:: FileName sp_comm_undead.nss
//:://////////////////////////////////////////////
/**@file Command Undead
Necromancy
Level: Sor/Wiz 2
Components: V, S, M
Casting Time: 1 action
Range: Close (25 ft. + 5 ft/2 levels)
Targets: 1 undead creature
Duration: 1 day/level
Saving Throw: See text
Spell Resistance: Yes

This spell allows you some degree of control over an
undead creature. Assuming the subject is intelligent,
it perceives your words and actions in the most
favorable way (treat its attitude as friendly). It
will not attack you while the spell lasts. You can
try to give the subject orders, but you must win an
opposed Charisma check to convince it to do anything
it wouldn't ordinarily do. (Retries are not allowed.)
An intelligent commanded undead never obeys suicidal
or obviously harmful orders, but it might be convinced
that something very dangerous is worth doing.

A nonintelligent undead creature gets no saving throw
against this spell. When you control a mindless being,
you can communicate only basic commands. Nonintelligent
undead won't resist suicidal or obviously harmful orders.

Any act by you or your apparent allies that threatens
the commanded undead (regardless of its Intelligence)
breaks the spell.

Your commands are not telepathic. The undead creature
must be able to hear you.

Material Components: A shred of raw meat and a splinter
of bone.

Author: 	Tenjac
Created: 	02/21/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "prc_inc_spells"


#include "_HkSpell"

void main()
{		
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_COMMAND_UNDEAD; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//Define vars
	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	effect eCharm = EffectCharmed();
	effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eDom = EffectDominated();
	int nMetaMagic = HkGetMetaMagicFeat();
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_DAYS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Link charm and persistant VFX
	effect eLink = EffectLinkEffects(eVis, eDur);
		eLink = SupernaturalEffect(eLink);

	//Link domination and persistant VFX
	effect eLink2 = EffectLinkEffects(eVis, eDom);
	eLink2 = EffectLinkEffects(eLink2, eDur);
	eLink2 = SupernaturalEffect(eLink2);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_COMMAND_UNDEAD, oCaster);

	//Undead
	if(CSLGetIsUndead( oTarget ))
	{
		//Check Spell Resistance
		if (!HkResistSpell(oCaster, oTarget ))
		{
			//Dominate mindless
			if(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 11)

			{
				HkApplyEffectToObject(iDurType, eLink2, oTarget, fDuration);
			}

			else
			{
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					SetIsTemporaryNeutral(oTarget, oCaster, TRUE, fDuration);
				}
			}
		}
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


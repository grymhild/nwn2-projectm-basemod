//::///////////////////////////////////////////////
//:: Name 	Gutwrench
//:: FileName sp_gutwrench.nss
//:://////////////////////////////////////////////
/**@file Gutwrench
Necromancy [Evil, Death]
Level: Sor/Wiz 8
Components: V, S, Undead
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: Yes

The innards of the target creature roil. If the
target fails its saving throw, its intestines burst
forth, killing it. The intestines fly toward the
caster and are absorbed into her form, granting her
4d6 temporary hit points and a +4 enhancement bonus
to Strength. If the target's save is successful, it
takes 10d6 points of damage instead.

A creature with no discernible anatomy is unaffected
by this spell.

Author: 	Tenjac
Created: 	16.3.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_BarbRage"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GUTWRENCH; // put spell constant here
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
	int nMetaMagic = HkGetMetaMagicFeat();
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int iAdjustedDamage;

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_GUTWRENCH, oCaster);

	//Caster must be undead. If not, hit 'em with alignment change anyway.
	//Try reading the description of the spell moron. =P

	if( CSLGetIsUndead(oCaster) )
	{
		if( CSLGetIsLiving(oTarget) && !CSLGetIsOoze(oTarget) )
		{
			if(!HkResistSpell(OBJECT_SELF, oTarget ))
			{
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_DEATH, oCaster, SAVING_THROW_RESULT_ROLL );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
				{
					//define effects
					effect eDeath = EffectDeath();
					effect eGut = EffectBeam(VFX_BEAM_SILENT_EVIL, oTarget, BODY_NODE_CHEST);
					effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
					effect eBonus = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
					effect eLink = EffectLinkEffects(eDeath, eGut);

					//Apply to target
					SCDeathlessFrenzyCheck(oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

					//PC
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oCaster, HoursToSeconds(24));
				
				}
				//Otherwise, take 10d6 damage, be thankful, and RUN.
				else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					
					int nDam = d6(10);
	
					//evaluate metamagic
					if(nMetaMagic == METAMAGIC_MAXIMIZE)
					{
						nDam = (8 * nCasterLvl);
					}
	
					if(nMetaMagic == METAMAGIC_EMPOWER)
					{
						nDam += (nDam/2);
					}
	
					//define damage
					effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
	
	
					//Apply damage
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
			}
		}
	}

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


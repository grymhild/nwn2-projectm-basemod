//::///////////////////////////////////////////////
//:: Name 	Righteous Smite
//:: FileName sp_right_smt.nss
//:://////////////////////////////////////////////
/**@file Righteous Smite
Evocation [Good]
Level: Clr 7, exalted arcanist 7, Wrath 7
Components: V, S
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Area: 20-ft. radius spread
Duration: Instantaneous
Saving Throw: Will partial; see text
Spell Resistance: Yes

You draw down holy power to smite your enemies. Only
evil and neutral creatures are harmed by the spell;
good creatures are unaffected.

The spell deals 1d6 points of damage per caster
level (maximum 20d6) to evil creatures (or 1d8
points of damage per caster level, maximum 20d8,
to evil outsiders) and blinds them for 1d4 rounds.
A successful Will saving throw reduces damage to
half and negates the blinding effect.

The spell deals only half damage against creatures
that are neither good nor evil, and they are not
blinded. They can reduce that damage by half (down
to one quarter of the roll) with a successful Will
save.

Author: 	Tenjac
Created: 	6/22/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RIGHTEOUS_SMITE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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

	location lLoc = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.10, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int iDamage;
	int nAlign;
	int nMetaMagic = HkGetMetaMagicFeat();
	int nDC;
	//float fDur = RoundsToSeconds(d4(1));
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(d4(), SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int iAdjustedDamage, iSave;
	int iSpellPower = HkGetSpellPower( oCaster, 20 );
	
	while(GetIsObjectValid(oTarget))
	{
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			nAlign = GetAlignmentGoodEvil(oTarget);
			if(nAlign != ALIGNMENT_GOOD)
			{
				nDC = HkGetSpellSaveDC(oCaster,oTarget);
	
				if((CSLGetIsOutsider( oTarget )) && (nAlign == ALIGNMENT_EVIL))
				{
					iDamage = HkApplyMetamagicVariableMods( d8(iSpellPower), 8 * iSpellPower );
				}
				else
				{
					iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower );
				}
			
				//Save for 1/2
				if ( nAlign == ALIGNMENT_EVIL )
				{
					iSave = HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster);
					iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_WILL, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
					if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
					{
						iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
						
						if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
						{
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, fDuration);
						}
					}
				}
				/*
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					if(nAlign == ALIGNMENT_EVIL)
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, fDuration);
				}
				else
				{
					if (GetHasMettle(oTarget, SAVING_THROW_WILL))
					// This script does nothing if it has Mettle, bail
						return;
					iDamage = (iDamage/2);
				}
				*/
	
				if(nAlign == ALIGNMENT_NEUTRAL)
				{
					// neutral takes 1/2 damage
					iDamage = (iDamage/2);
				}
	
				//Deal damage to non-good
				
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.10, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


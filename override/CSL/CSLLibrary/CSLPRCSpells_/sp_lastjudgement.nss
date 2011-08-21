//::///////////////////////////////////////////////
//:: Name 	Last Judgment
//:: FileName sp_lst_jdgmnt.nss
//:://////////////////////////////////////////////
/**@file Last Judgment
Necromancy [Death, Good]
Level: Clr 8, Sor/Wiz 8, Wrath 8
Components: V, Celestial
Casting Time: 1 round
Range: Close (25 ft. + 5 ft./2 levels)
Target: One evil humanoid, monstrous humanoid, or
giant/2 levels
Duration: Instantaneous
Saving Throw: Will partial
Spell Resistance: Yes

Reciting a list of the targets' evil deeds, you call
down the judgment of the heavens upon their heads.
Creatures that fail their saving throw are struck
dead and bodily transported to the appropriate Lower
Planes to suffer their eternal punishment. Creatures
that succeed nevertheless take 3d6 points of
temporary Wisdom damage as guilt for their misdeeds
overwhelms their minds.

This spell affects only humanoids, monstrous
humanoids, and giants of evil alignment.

A true resurrection or miracle spell can restore life
to a creature slain by this spell normally. A
resurrection spell works only if the creature's body
can be recovered from the Lower Planes before the
resurrection is cast.

Author: 	Tenjac
Created: 	7/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_inc_template"



#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LAST_JUDGEMENT; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nToBeAffected = nCasterLvl / 2;
	int nDC;
	location lLoc = HkGetSpellTargetLocation();
	int iAdjustedDamage;

	//Must be Celestial
	if(GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD)
	{
		if(( CSLGetIsOutsider(oCaster) ) || (GetHasTemplate(TEMPLATE_CELESTIAL)) || (GetHasTemplate(TEMPLATE_HALF_CELESTIAL)))
		{
			object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 7.62, lLoc, FALSE, OBJECT_TYPE_CREATURE);

			while(GetIsObjectValid(oTarget))
			{
				if(nToBeAffected > 0)
				{
					if( CSLGetIsHumanoid(oTarget) && CSLGetIsLiving(oTarget) && !CSLGetIsOoze(oTarget)  )
					{
						if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
						{
							//decrement the counter
							nToBeAffected--;

							if(!HkResistSpell(oCaster, oTarget ))
							{
								nDC = HkGetSpellSaveDC(oCaster,oTarget);
								iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_WILL, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_DEATH, oCaster, SAVING_THROW_RESULT_ROLL );
								if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
								{
										
									if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
									{
										HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
									}
									SCApplyAbilityDrainEffect( ABILITY_WISDOM, d6(3), oTarget, DURATION_TYPE_TEMPORARY, -1.0f);
								}
								/*
								if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
								{
									HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);


									//Any module specific code for moving the body to another plane would go here
								}
								else
								{
									if(!GetHasMettle(oTarget, SAVING_THROW_WILL))
									{
										//made save, apply ability damage
										SCApplyAbilityDrainEffect( ABILITY_WISDOM, d6(3), oTarget, DURATION_TYPE_TEMPORARY, -1.0f);
									}
								}
								*/
							}
						}
					}
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 7.62, lLoc, FALSE, OBJECT_TYPE_CREATURE);
		}
	}
	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}





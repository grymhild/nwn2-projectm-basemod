//::///////////////////////////////////////////////
//:: Name 	Wretched Blight
//:: FileName sp_wrtch_blght.nss
//:://////////////////////////////////////////////
/**@file Wretched Blight
Evocation [Evil]
Level: Clr 7
Components: V, S
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Area: 20-ft.-radius spread
Duration: Instantaneous
Saving Throw: Fortitude partial (see text)
Spell Resistance: Yes

The caster calls up unholy power to smite his enemies.
The power takes the form of a soul chilling mass of
clawing darkness. Only good and neutral (not evil)
creatures are harmed by the spell.

The spell deals 1d8 pts of damage per caster level
(maximum 15d8) to good creatures and renders them
stunned for 1d4 rounds. A successful Fortitude save
reduces damage to half and negates the stunning effect.

The spell deals only half damage to creatures that
are neither evil nor good, and they are not stunned.
Such creatures can reduce the damage in half again
(down to one'quarter of the roll) with a successful
Reflex save.

Author: 	Tenjac
Created: 	5/9/06
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
	int iSpellId = SPELL_WRETCHED_BLIGHT; // put spell constant here
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
	int iSpellPower = HkGetSpellPower( oCaster, 15 );
	int iDamage;
	int nDC;
	int nMetaMagic = HkGetMetaMagicFeat();
	location lLoc = HkGetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_DUR_DARKNESS);
	effect eDam;
	int nAlign;
	int iAdjustedDamage, iSave;
	

	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lLoc, 3.0f);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
		nAlign = GetAlignmentGoodEvil(oTarget);
		
		iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 8 * iSpellPower );
		

		//SR
		if(!HkResistSpell(oCaster, oTarget))
		{
			nDC = HkGetSpellSaveDC(oCaster,oTarget);
			if(nAlign == ALIGNMENT_GOOD)
			{
				//Save for 1/2 dam
				iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster);
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
				
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(d4(1)));
				}
				
				/*
				if(HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					if (GetHasMettle(oTarget, SAVING_THROW_FORT))
						// This script does nothing if it has Mettle, bail
						return;
					iDamage = iDamage/2;
				}
				else
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(d4(1)));
				}
				*/

			}
			else if(nAlign == ALIGNMENT_NEUTRAL)
			{
				//Start at 1/2 dam
				iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster);
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
				
				
				/*
				iDamage = iDamage/2;

				//Save for furter 1/2
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, SAVING_THROW_RESULT_ROLL  );
				if(HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					if (GetHasMettle(oTarget, SAVING_THROW_FORT))
						// This script does nothing if it has Mettle, bail
						return;
					iDamage = iDamage/2;
				}
				*/
			}

			else
			{
				//Yay, you're evil, have a VFX.
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, 1.0f);
			}

			//Apply Damage
			if ( iDamage > 0 )
			{
				eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
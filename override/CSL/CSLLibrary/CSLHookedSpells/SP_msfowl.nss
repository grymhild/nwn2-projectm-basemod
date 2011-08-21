//::///////////////////////////////////////////////
//:: Mass Fowl
//:: nx_s2_mass_fowl.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Classes: Bard, Druid, Spirit Shaman, Wizard, Sorcerer
	Spellcraft Required: 24
	Caster Level: Epic
	Innate Level: Epic
	School: Transmutation
	Descriptor(s):
	Components: Verbal, Somatic
	Range: Long
	Area of Effect / Target: 20-ft radius hemisphere
	Duration: Permanent
	Save: Fortitude negates
	Spell Resistance: Yes
	
	This spell transforms all hostile creatures of Medium-size or
	smaller in the area into chickens. Targets are allowed a
	Fortitude save (DC +5) to negate the effects of the spell.
	The transformation is permanent.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/11/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.
//:: Remove hard HD caps, reduce radius to 20'.
//:: AFW-OEI 07/11/2007: NX1 VFX.
//:: AFW-OEI 07/16/2007: Reduce INT, WIS, & CHA to 9 to block spellcasting.
//:: RPGplayer1 03/19/2008: Non-player faction creatures will stop using spell-like abilities
//:: RPGplayer1 03/25/2008: Uses epic spell save workaround

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


//#include "nx1_inc_epicsave"

void main()
{
	//scSpellMetaData = SCMeta_SP_msfowl();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_MASS_FOWL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	//int iHD, nCreatureSize;
	int nCreatureSize;
	float fDelay;
	int iSaveDC = HkGetSpellSaveDC() + 5;
	location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	effect eDeath = EffectDeath(FALSE, TRUE, TRUE);		// No spectacular death, yes display feedback, yes ignore death immunity.
	
	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_MASS_FOWL );
	
	effect ePoly = EffectPolymorph(POLYMORPH_TYPE_CHICKEN, TRUE);
	ePoly = ExtraordinaryEffect(ePoly); // AFW-OEI 07/11/2007: No dispelling extraordinary effects.
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) ) // Only ever effects enemies.
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE));
			
			//Get the distance between the explosion and the target to calculate delay
			//iHD = GetHitDice(oTarget);
			nCreatureSize = GetCreatureSize(oTarget);
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			
			//if ( iHD <= 15 && nCreatureSize <= CREATURE_SIZE_MEDIUM && // Only affects Medium or smaller creatures with 15 or less HD
			if ( nCreatureSize <= CREATURE_SIZE_MEDIUM && !HkResistSpell(OBJECT_SELF, oTarget, fDelay) && !HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay) )
			{
				//Apply the VFX impact and effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				AssignCommand(oTarget, ClearAllActions()); // prevents an exploit
				
				
				if (GetIsPC(oTarget))
				{
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
				}
				else
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oTarget));
					
					if (GetFactionLeader(oTarget) == OBJECT_INVALID)
					{
						SetLocalInt(oTarget, "X2_L_STOPCASTING", 10); //FIX: blocks spellcasting for monsters
					}
					
					// Reduce mental stats to 9.
					int nINT = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE);
					int nWIS = GetAbilityScore(oTarget, ABILITY_WISDOM);
					int iCHA = GetAbilityScore(oTarget, ABILITY_CHARISMA);
					
					if (nINT > 9)
					{
						effect eINT = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nINT - 9);
						eINT = ExtraordinaryEffect(eINT);
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eINT, oTarget));
					}
					if (nWIS > 9)
					{
						effect eWIS = EffectAbilityDecrease(ABILITY_WISDOM, nWIS - 9);
						eWIS = ExtraordinaryEffect(eWIS);
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eWIS, oTarget));
					}
					if (iCHA > 9)
					{
						effect eCHA = EffectAbilityDecrease(ABILITY_CHARISMA, iCHA - 9);
						eCHA = ExtraordinaryEffect(eCHA);
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eCHA, oTarget));
					}
				}
			}
		}
		
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}


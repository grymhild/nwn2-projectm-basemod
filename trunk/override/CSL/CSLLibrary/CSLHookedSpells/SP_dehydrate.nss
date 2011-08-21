//::///////////////////////////////////////////////
//:: Dehydrate
//:: nx2_s0_dehydrate.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Dehydrate
	Necromancy
	Level: Druid 3
	Components: V, S
	Range: Medium
	Target: One living creature
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	
	You afflict the target with a horrible, dessicating curse that deals 1d6 points of Constitution damage, plus 1 additional point of Constitution damage per three caster levels, to a maximum of 1d6+5 at 15th level.
	Oozes and plants are more susceptible to this spell than other targets.
	Such creatures take 1d8 points of Constitution damage plus 1 additional point of Constitution damage per three caster levels to a maximim of 1d8+5.

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/29/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"


//#include "x0_i0_match"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DEHYDRATE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	
	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	
	// Get caster level
	int iSpellPower = HkGetSpellPower( oCaster, 15 ); // OldGetCasterLevel(oCaster);
	// check if plant or ooze
	int bSpecialCase;
	if( CSLGetIsOoze(oTarget)  || CSLGetIsPlant(oTarget) )
	{
		bSpecialCase = TRUE;
	}
	// Cap caster level
	//if(iSpellPower > 15)
	//{
	//	iSpellPower = 15;
	//}
	//if(bSpecialCase)
	//{
	//	iSpellPower = CSLGetMax( 12, iSpellPower );
	//}
	//calculate extra damage
	
	
	
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
		// check to see if hostile
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
			if (!HkResistSpell(oCaster, oTarget) && !FortitudeSave(oTarget, HkGetSpellSaveDC() ) )
			{
				int nConDamage;
				if(bSpecialCase)
				{
					nConDamage = HkApplyMetamagicVariableMods(d8(1)+(iSpellPower/3)+1, 8 + (iSpellPower/3)+1 );
				}
				else
				{
					nConDamage = HkApplyMetamagicVariableMods(d6(1)+ (iSpellPower/3), 6 + (iSpellPower/3) );
				}
				//effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nConDamage);
				effect eHit = EffectVisualEffect(VFX_HIT_SPELL_DEHYDRATION);
				//effect eLink = EffectLinkEffects(eHit, eDamage);
				
				
				HkApplyEffectToObject( DURATION_TYPE_INSTANT, eHit, oTarget);
				DelayCommand( 0.0f, SCApplyDeadlyAbilityDrainEffect( nConDamage, ABILITY_CONSTITUTION, oTarget, DURATION_TYPE_PERMANENT, 0.0f, oCaster ) );
				//Fire cast spell at event for the specified target
			}
		}
	}
	
	HkPostCast(oCaster);
}


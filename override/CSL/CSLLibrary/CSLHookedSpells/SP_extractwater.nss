//::///////////////////////////////////////////////
//:: Extract Water Elemental
//:: [nx_s0_extractwaterelemental.nss]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
/*
	Extract Water Elemental
	Transmutation [Water]
	Level: Druid 6, sorceror/wizard 6
	Components: V, S
	Range: Close
	Target: One living creature
	Saving Throw: Fortitude half
	Spell Resistance: Yes
	
	This brutal spell causes the targeted creature to
	dehydrate horriby as the moisture in its body is
	forcibly extracted through its eyes, nostile, mouth,
	and pores.  This deals 1d6 points of damage per
	caster level (maximum 20d6), or half damage on a
	successful Fortitude save.  If the targeted creature
	is slain by this spell, the extracted moisture is
	transformed into a water elemental of a size equal
	to the slain creature (up to Huge).  The water
	elemental is under your control, as though you had
	summoned it, and disappears after 1 minute.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008: Made only non-living immune to it (Construct, Undead)

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_extractwater();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EXTRACT_WATER_ELEMENTAL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFXSC_HIT_EXTRACTWATERELEMENTAL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_WATER, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	
	int iSpellPower = HkGetSpellPower( oCaster, 20 ); // OldGetCasterLevel(oCaster);

	// Things that are not alive are immune to this spell.
	//if (GetIsImmune(oTarget,IMMUNITY_TYPE_DEATH))
	if( !CSLGetIsWaterBased( oTarget, TRUE, TRUE ) )
	{
		FloatingTextStrRefOnCreature(184683, oCaster, FALSE); // "Target is immune to that effect."
		return;
	}
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

		//Make SR check
		if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
			int iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower );
			
			float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds(10) );
			
			
			//if(HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
			//{ // Fort save for 1/2 damage.
			//	iDamage = iDamage / 2;
			//}
			iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_ALL, oCaster, SAVING_THROW_RESULT_ROLL );
			// Inflict damage.
			effect eDamage = HkEffectDamage(iDamage);
			//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE); // replace with dehydration effect
			//effect eLink = EffectLinkEffects(eDamage, eVis);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget); // deal some damage
			
			// If target was killed, summon an appropriately-sized water elemental
			if ( GetIsDead(oTarget) )
			{
				int nCreatureSize = GetCreatureSize(oTarget);
				effect eSummon;
			
				if (nCreatureSize >= CREATURE_SIZE_HUGE)
				{ // Huge is as big as the elemental gets
					eSummon = EffectSummonCreature("csl_sum_elem_wat_16huge");
				}
				else if (nCreatureSize == CREATURE_SIZE_LARGE)
				{
					eSummon = EffectSummonCreature("csl_sum_elem_wat_08large");
				}
				else if (nCreatureSize == CREATURE_SIZE_MEDIUM)
				{
					eSummon = EffectSummonCreature("csl_sum_elem_wat_04medium");
				}
				else if (nCreatureSize <= CREATURE_SIZE_SMALL)
				{ // Small is as small as the elemental gets
					eSummon = EffectSummonCreature("csl_sum_elem_wat_02small");
				}

				HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetLocation(oTarget), fDuration);
				//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
			}
		}
	}
	
	HkPostCast(oCaster);
}


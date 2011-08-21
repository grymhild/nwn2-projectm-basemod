//::///////////////////////////////////////////////
//:: Bodak's Glare
//:: nx2_s0_bodaks_glare.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Bodak's Glare
	Necromancy [Death, Evil]
	Level: Cleric 8
	Components: V, S
	Range: Close
	Target: One living creature
	Duration: TBD
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	
	Upon completion of the spell, you target a creature within range.
	That creature dies instantly unless it succeeds on a Fortitude save.
	
	If you slay a humanoid creature with this attack, it will return as a bodak under your control.
	
	*NOTE* Currently using zombie as bodak place holder, also duration set at caster level is temporary as well
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/29/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


//#include "x0_i0_match"

void main()
{
	//scSpellMetaData = SCMeta_SP_bodaksglare();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BODAKS_GLARE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DEATH, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	
	location lTarget = GetLocation(oTarget);
	// Caster Level
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = RoundsToSeconds( HkGetSpellDuration( oCaster ) );
	// Effects
	effect eDeath = EffectDeath();
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_BODAKS_GLARE);
	effect eSummon = EffectSummonCreature("csl_sum_undead_zombie3", VFX_SUMMON_SPELL_BODAKS_GLARE, 0.8f);
	effect eLink = EffectLinkEffects(eHit, eDeath);
	// Succesful save?
	int nSaved;
	
	// Make sure spell target valid
	if (GetIsObjectValid(oTarget))
	{
		// check to see if hostile
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			nSaved = FortitudeSave(oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, oCaster);
			if(nSaved == 2)
			{
				// do nothing, immune
			}
			else if(nSaved == 1)
			{
				// do nothing, succesful save
			}
			else if(nSaved == 0)
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				if(CSLGetIsHumanoid(oTarget))
				{
					HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
					//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
				}
			}
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
		}
	}
	
	HkPostCast(oCaster);
}


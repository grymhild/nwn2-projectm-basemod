//::///////////////////////////////////////////////
//:: Solipsism
//:: nx_s0_solipsism.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Illusion (Phantasm)
	Level: Wizard/Sorcerer 7
	Components: V
	Range: Medium
	Target: One creature
	Duration: 1 round/level (D)
	Saving Throw: Will negates
	Spell Resistance: Yes
	
	You manipulate the senses of one creature so that
	it perceives itself to be the only real creature
	in all of existence and everything around it to
	be merely an illusion.
	
	If the target fails its save, it is convinced
	of the unreality of every situation it might
	encounter. It takes no actions, not even purely
	mental actions, and instead watches the world
	around it with bemusement. The subject becomes
	effectively helpless and takes no steps to defend
	itself from any threat, since it considers any
	hostile action merely another illusion.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/07/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
 


void main()
{

	//scSpellMetaData = SCMeta_SP_solipsism();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SOLIPSISM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_PHANTASM, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration( OBJECT_SELF );
	iDuration = HkGetScaledDuration(iDuration, oTarget);
	
	int iSaveDC = HkGetSpellSaveDC();
	
	int bSaveEveryRound = FALSE;
	effect eParal = EffectCutsceneParalyze(); // EffectParalyze(iSaveDC, SAVING_THROW_WILL, bSaveEveryRound);
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_SOLIPSISM );
	eParal = EffectLinkEffects( eParal, eHit );


	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		
		//Make SR check
		if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
				
			if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF ))
			{
				return;
			}
			
			//Make Will save
			if ( !HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_MIND_SPELLS) )
			{
				//Check for metamagic extend
				float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
							
				//Apply the paralyze effect and the VFX impact
				HkApplyEffectToObject( iDurType, eParal, oTarget, fDuration );
			}
		}
	}
	
	HkPostCast(oCaster);
}


//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Jarring
//:: NW_S2_SngInJrng
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/07/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	This spells applies negative modifiers to all enemies
	within 20 feet.
*/
//:: AFW-OEI 06/06/2006:
//:: Change from a "Jarring" effect to -4 Discipline/Concentration
//:: and -2 to all Will saves.
//:: PKM-OEI 07.13.06 VFX Pass
//:: PKM-OEI 07.20.06 Added Perform skill check


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Songs"
#include "_SCInclude_Class"





void RunPersistentSong(object oCaster, int iSpellId)
{
	if ( SCGetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(
	}
	
	int nPerform = GetSkillRank(SKILL_PERFORM);
	
	if (nPerform < 3 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

	// Verify that we are still singing the same song...
	int nSingingSpellId = SCFindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
	if(nSingingSpellId == iSpellId)
	{
			//Declare major variables
			float fDuration = 4.0; //RoundsToSeconds(5);

			//effect eJarring = ExtraordinaryEffect( EffectJarring() );
		effect eDiscPenalty = ExtraordinaryEffect( EffectSkillDecrease( SKILL_DISCIPLINE, 4 ) );
		effect eConcPenalty = ExtraordinaryEffect( EffectSkillDecrease( SKILL_CONCENTRATION, 4 ) );
		effect eWillPenalty = ExtraordinaryEffect( EffectSavingThrowDecrease( SAVING_THROW_WILL, 2) );
			effect eDur     = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_JARRING) );
			effect eLink    = EffectLinkEffects( eDiscPenalty, eConcPenalty );
		eLink = EffectLinkEffects( eLink, eWillPenalty);
		eLink = ExtraordinaryEffect( EffectLinkEffects( eLink, eDur ) );

			SCApplyHostileSongEffectsToArea( oCaster, iSpellId, fDuration, RADIUS_SIZE_HUGE, eLink );
			// Schedule the next ping
			DelayCommand(2.5f, RunPersistentSong(oCaster, iSpellId));
	}
}


void main()
{
	//scSpellMetaData = SCMeta_SG_songinspjarr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	if ( SCGetCanBardSing( OBJECT_SELF ) == FALSE )
	{
		return; // Awww :(
	}

	if(SCAttemptNewSong(OBJECT_SELF, TRUE))
	{
		effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));
	
			DelayCommand(0.1f, RunPersistentSong(OBJECT_SELF, GetSpellId()));
	}
	
	HkPostCast(oCaster);
}

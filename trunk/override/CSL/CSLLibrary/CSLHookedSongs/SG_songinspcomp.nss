//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Competence
//:: NW_S2_SngInComp
//:: Created By: Jesse Reynolds (JLR-OEI)
//:: Created On: 04/06/06
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	This spells applies bonuses to all of the
	bard's allies within 30ft for as long as
	it is kept up.
*/
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
	
	if (nPerform < 3 )//Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

	// Verify that we are still singing the same song...
	int nSingingSpellId = SCFindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
	if(nSingingSpellId == iSpellId)
	{
			//Declare major variables
			int iLevel = GetBardicClassLevelForUses(OBJECT_SELF);

			float fDuration = 4.0; //RoundsToSeconds(5);
			int nSkill = 2; // AFW-OEI 02/09/2007: Default to +2

			/* AFW-OEI 02/09/2007: Switch to a formula instead of a hard-coded list.
			if(iLevel >= 19)       { nSkill = 6; }
			else if(iLevel >= 11)  { nSkill = 4; }
			else                   { nSkill = 2; }
			*/
			
			if (iLevel >= 11)
			{   // +2 every 8 levels starting at level 3
				nSkill = nSkill + (2 * ((iLevel - 3) / 8));
			}
			if (GetHasFeat(FEAT_EPIC_INSPIRATION, oCaster))
			{
				nSkill = nSkill+2;				
			}
			if (GetHasFeat(FEAT_SONG_OF_THE_HEART, oCaster))
			{
				nSkill++;
			}
			

			effect eSkill  = ExtraordinaryEffect( EffectSkillIncrease(SKILL_ALL_SKILLS, nSkill) );
			effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_COMPETENCE) );
			effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eSkill, eDur) );

			SCApplyFriendlySongEffectsToArea( oCaster, iSpellId, fDuration, RADIUS_SIZE_COLOSSAL, eLink );
			// Schedule the next ping
			DelayCommand(2.5f, RunPersistentSong(oCaster, iSpellId));
	}
}


void main()
{
	//scSpellMetaData = SCMeta_SG_songinspcomp();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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


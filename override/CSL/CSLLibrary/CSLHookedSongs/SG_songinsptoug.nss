//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Toughness
//:: NW_S2_SngInTufn
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

	int nPerform = GetSkillRank(SKILL_PERFORM);
	
	if (nPerform < 3 ) //Checks your perform skill so nubs can't use this song
	{
		FloatingTextStrRefOnCreature ( 182800, OBJECT_SELF );
		return;
	}

	if ( SCGetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(
	}

	// Verify that we are still singing the same song...
	int nSingingSpellId = SCFindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
	if(nSingingSpellId == iSpellId)
	{
			//Declare major variables
			float fDuration = 4.0; //RoundsToSeconds(5);
			//int iLevel      = GetLevelByClass(CLASS_TYPE_BARD, oCaster);
			int iLevel      = GetBardicClassLevelForUses(oCaster);
			int iSave = 1;  // AFW-OEI 02/09/2007: Default to +1

			/* AFW-OEI 02/09/2007: switch to formula instead of hard-coded list.
			if(iLevel >= 18)       { iSave = 3; }
			else if(iLevel >= 13)  { iSave = 2; }
			else                   { iSave = 1; }
			*/
			
			if (iLevel >= 13)
			{   // +1 every five levels starting at level 8
				iSave = iSave + ((iLevel - 8) / 5);
			}
			
			if (GetHasFeat(FEAT_EPIC_INSPIRATION, oCaster))
			{
				iSave = iSave+2;
			}
			if (GetHasFeat(FEAT_SONG_OF_THE_HEART, oCaster))
			{
				iSave += 1;
			}
			
			effect eSave   = ExtraordinaryEffect( EffectSavingThrowIncrease(SAVING_THROW_ALL, iSave) );
			effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_TOUGHNESS) );
			effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eSave, eDur) );

			SCApplyFriendlySongEffectsToArea( oCaster, iSpellId, fDuration, RADIUS_SIZE_COLOSSAL, eLink );
			// Schedule the next ping
			DelayCommand(2.5f, RunPersistentSong(oCaster, iSpellId));
	}
}


void main()
{
	//scSpellMetaData = SCMeta_SG_songinsptoug();
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


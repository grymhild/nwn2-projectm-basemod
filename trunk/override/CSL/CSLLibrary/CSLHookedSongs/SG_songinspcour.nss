//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Inspire Courage
//:: NW_S2_SngInCour
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
	//scSpellMetaData = SCMeta_Generic();
	if ( SCGetCanBardSing( oCaster ) == FALSE )
	{
		return; // Awww :(
	}
	
	if (DEBUGGING >= 6) { CSLDebug("Persistent Song Running", oCaster ); }
	
	
	
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
			int iLevel = GetBardicClassLevelForUses(oCaster);
			
			if (GetHasFeat(FEAT_SONG_OF_THE_WHITE_RAVEN))
			{
				iLevel += GetLevelByClass(CLASS_TYPE_CRUSADER, oCaster) + GetLevelByClass(CLASS_TYPE_WARBLADE, oCaster);
			}
			
			
			float fDuration = 4.0; //RoundsToSeconds(5);
			//int nAttack;
			//int iDamage;

			/* AFW-OEI 02/09/2007: switch to a formula instead of a hard-coded list.
			if(iLevel >= 20)       { nAttack = 4; iDamage = 4; }
			else if(iLevel >= 14)  { nAttack = 3; iDamage = 3; }
			else if(iLevel >= 8)   { nAttack = 2; iDamage = 2; }
			else                   { nAttack = 1; iDamage = 1; }
			*/
			int iBonus = 1; // Default to +1
			if (iLevel >= 8)
			{   // +1 every six levels starting at level 2.
				iBonus += ((iLevel - 2) / 6);
			}
			if (GetHasFeat(FEAT_EPIC_INSPIRATION, oCaster))
			{
				iBonus += 2;		
			}
			if (GetHasSpellEffect(SPELL_Inspirational_Boost, oCaster))
			{
				iBonus += 1;
			}
			if (GetHasFeat(FEAT_SONG_OF_THE_HEART, oCaster))
			{
				iBonus += 1;
			}
			if (GetHasFeat(FEAT_LEADERSHIP, oCaster))
			{
				iBonus += 1;
			}
			//Dread Pirate

			int nPirate = GetLevelByClass(CLASS_DREAD_PIRATE,oCaster);	
			if (nPirate > 6)
			{
				iBonus += 2;
			}
			else if (nPirate > 2)
			{
				iBonus += 1;	
			}
			int iDamage = CSLGetDamageBonusConstantFromNumber(iBonus);   // Map raw bonus to a DAMAGE_BONUS_* constant.

			effect eAttack = ExtraordinaryEffect( EffectAttackIncrease(iBonus) );
			effect eDamage = ExtraordinaryEffect( EffectDamageIncrease(iDamage, DAMAGE_TYPE_BLUDGEONING ) );
			effect eLink   = ExtraordinaryEffect( EffectLinkEffects(eAttack, eDamage) );
			effect eDur    = ExtraordinaryEffect( EffectVisualEffect(VFX_HIT_BARD_INS_COURAGE) );
			eLink          = ExtraordinaryEffect( EffectLinkEffects(eLink, eDur) );

			SCApplyFriendlySongEffectsToArea( oCaster, iSpellId, fDuration, RADIUS_SIZE_COLOSSAL, eLink );
			// Schedule the next ping
			DelayCommand(2.5f, RunPersistentSong(oCaster, iSpellId));
	}
}


void main()
{
	//scSpellMetaData = SCMeta_SG_songinspcour();
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


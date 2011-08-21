//::///////////////////////////////////////////////
//:: Last Stand
//:: nx_s2_laststand.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	The character and all party members gain 20d10 temporary hitpoints
	for 1 round per Cha bonus of the character. Minimum duration is 2 rounds.
	This ability can be used once per day and requires a standard action.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/22/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_FT_splabllastst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	// Create the Effects
	int nHP = d10(20);
	effect eHP   = EffectTemporaryHitpoints(nHP);
	effect eDur  = EffectVisualEffect( VFX_DUR_SPELL_LAST_STAND );
	effect eLink = EffectLinkEffects(eHP, eDur);

	// Figure out duration of effect
	int nRounds = GetAbilityModifier (ABILITY_CHARISMA);
	if (nRounds < 2)
	{   // Lasts a minimum of 2 rounds.
			nRounds = 2;
	}
	
	float fDuration = RoundsToSeconds( nRounds );
	int iDurType = DURATION_TYPE_TEMPORARY;
	
	// Apply effects to everyone in your party
	int bPCOnly = FALSE;
	object oLeader = GetFactionLeader(OBJECT_SELF);
	object oTarget = GetFirstFactionMember(oLeader, bPCOnly);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLPCIsClose(OBJECT_SELF, oTarget, 10) &&
			CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF) &&
				!GetHasSpellEffect(SPELLABILITY_LAST_STAND, oTarget))               // Effects don't stack
		{
			SignalEvent(oTarget, EventSpellCastAt( OBJECT_SELF, SPELLABILITY_LAST_STAND, FALSE ));
				HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
		}

			oTarget = GetNextFactionMember(oLeader, bPCOnly);
	}
	
	HkPostCast(oCaster);
 }
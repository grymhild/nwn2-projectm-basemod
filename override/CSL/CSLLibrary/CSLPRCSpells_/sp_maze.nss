//:://////////////////////////////////////////////
//:: Maze spellscript
//:: sp_maze
//:://////////////////////////////////////////////
/** @file

	Maze

	Conjuration (Teleportation)
	Level: Sor/Wiz 8
	Components: V, S
	Casting Time: 1 standard action
	Range: Close (25 ft. + 5 ft./2 levels)
	Target: One creature
	Duration: See text
	Saving Throw: None
	Spell Resistance: Yes

	You banish the subject into an extradimensional labyrinth of force planes.
	Each round on its turn, it may attempt a DC 20 Intelligence check to escape
	the labyrinth as a full-round action. If the subject doesn't escape, the
	maze disappears after 10 minutes, forcing the subject to leave. *

	On escaping or leaving the maze, the subject reappears where it had been
	when the maze spell was cast. If this location is filled with a solid
	object, the subject appears in the nearest open space. Spells and abilities
	that move a creature within a plane, such as teleport and dimension door,
	do not help a creature escape a maze spell, although a plane shift spell
	allows it to exit to whatever plane is designated in that spell.
	Minotaurs are not affected by this spell.


	* Implemented such that NPCs always try escape and PCs are given a choice
	whether to attempt escape or not.

	@author Ornedan
	@date 	Created - 2005.10.18
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_maze"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MAZE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//


	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel();
	//int nSpellID 	= HkGetSpellId();

	// Fire cast spell at event for the specified target. For friendlies, Maze is considered non-hostile
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, !GetIsFriend(oTarget));

	// Minotaur check
	if(GetRacialType(oTarget) == RACIAL_TYPE_MINOTAUR 		||
		GetRacialType(oTarget) == RACIAL_TYPE_KRYNN_MINOTAUR
		)
	{
		SendMessageToPCByStrRef(oCaster, 16825703); // "The spell fails - minotaurs cannot be mazed."
		return;
	}

	// Make SR check
	if(!HkResistSpell(oCaster, oTarget ))
	{
		// Get the maze area
		object oMazeArea = GetObjectByTag("prc_maze_01");

		if(DEBUGGING && !GetIsObjectValid(oMazeArea))
			CSLDebug("Maze: ERROR: Cannot find maze area!", oCaster);

		// Determine which entry to use
		int nMaxEntry = GetLocalInt(oMazeArea, "PRC_Maze_Entries_Count");
		int nEntry = Random(nMaxEntry) + 1;
		object oEntryWP = GetWaypointByTag("PRC_MAZE_ENTRY_WP_" + IntToString(nEntry));
		location lTarget = GetLocation(oEntryWP);

		// Validity check
		if(DEBUGGING && !GetIsObjectValid(oEntryWP))
			CSLDebug("Maze: ERROR: Selected waypoint does not exist!");

		// Make sure the target can be teleported
		if(CSLGetCanTeleport(oTarget))
		{
			// Store the target's current location for return
			SetLocalLocation(oTarget, "PRC_Maze_Return_Location", GetLocation(oTarget));

			// Jump the target to the maze - the maze's scripts will handle the rest
			DelayCommand(1.5f, AssignCommand(oTarget, JumpToLocation(lTarget)));

			// Clear the action queue, so there's less chance of getting to abuse the ghost effect
			AssignCommand(oTarget, ClearAllActions());

			// Make the character ghost for the duration of the maze. Apply here so the effect gets a spellID association
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneGhost(), oTarget, 600.0f);

			// Apply some VFX
			DoMazeVFX(GetLocation(oTarget));
		}
		else
			SendMessageToPCByStrRef(oCaster, 16825702); // "The spell fails - the target cannot be teleported."
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
//::///////////////////////////////////////////////
//:: Arcane Lock
//:: SP_arcanelock
//:: Copyright (c) 2008 Brian Meyer
//:: designed for DungeonEternal.com
//:: Released for all usage, while preserving authorship credit
//:://////////////////////////////////////////////
/*
		Arcane Lock
		SRDBTM
		School: Abjuration
		Components: V, S, M
		Casting Time: 1 standard action
		Rangle: Touch
		TargetAOE: The door, chest, or portal touched, up to 30 sq. ft./level in size
		Duration: Permanent
		Saving Throw: None
		Spell resist: No
		Level 2
		Exp to cast: 25gp
		
		An arcane lock spell cast upon a door, chest, or portal magically locks it.
		You can freely pass your own arcane lock without affecting it; otherwise,
		a door or object secured with this spell can be opened only by breaking in or 
		with a successful dispel magic or knock spell. Add 10 to the normal DC to 
		break open a door or portal affected by this spell. 
		(A knock spell does not remove an arcane lock; it only suppresses the effect for 10 minutes.) 
		
		Magically locks a portal or chest.
		
		Focus on just doors to begin with, makes it so only the caster can open or close said door
		A successful dispel will remove the lock, via on spell cast at script. Knock probably will affect it as well. Destroying the door might also be a factor but its made stronger.
		
		The plan is to set the event script on the open/click event to keep the door closed
		(it's permanent but) it will also set will be an delayed command to remove the lock at the end of a given duration, comment this out to make it permanent
		
		If the door is locked or impassable by the PC then the door will still be unpassable by the PC. But to those who can normally pass said door it is unpassable due to the magic.
		The door if it is locked or requires a key will still require unlocking or to get the correct key. Another character can unlock said door by the caster is only one who can open it while the spell is in effect.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Doors"


void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ARCANE_LOCK;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	object oDoor1 = HkGetSpellTarget();
	if ( GetLocalInt( oDoor1, "SC_ARCANELOCK_CASTERLEVEL" ) > HkGetCasterLevel( oCaster ) )
	{
		SendMessageToPC( oCaster, "This door is already blocked by a more powerful wizard than you");
		return;
	}
	
	SCApplyArcaneLock( oDoor1, oCaster );
	
	
	
	 /*
	if ( GetObjectType( oDoor1 ) == OBJECT_TYPE_DOOR ) // ||  GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE )
	{
		ActionCloseDoor(oDoor1);
		SetLocalInt(oDoor1, "SC_ARCANELOCK_CASTERPOINTER", ObjectToInt(oCaster));
		SetLocalInt(oDoor1, "SC_ARCANELOCK_CASTERLEVEL", HkGetCasterLevel( oCaster ) );
		SetLocalString(oDoor1, "SC_ARCANELOCK_CASTERTAG", GetName( oCaster ) );
		SetLocalString(oDoor1, "SC_ARCANELOCK_OLDONOPEN",GetEventHandler(oDoor1, SCRIPT_DOOR_ON_OPEN ) );//SCRIPT_DOOR_ON_OPEN
		SetEventHandler(oDoor1, SCRIPT_DOOR_ON_OPEN, "SP_arcanelockonopen");
		//SetEventHandler(oDoor1, SCRIPT_DOOR_ON_SPELLCASTAT, "SP_arcanelockondispel");
		//SetLocked(OBJECT_SELF, TRUE);
	}
	*/
	
	object 	oDoor2 	= GetTransitionTarget(oDoor1);
	SCApplyArcaneLock( oDoor2, oCaster );
	/*
	if ( GetObjectType( oDoor2 ) == OBJECT_TYPE_DOOR )
	{
		ActionCloseDoor(oDoor2);
		SetLocalInt(oDoor2, "SC_ARCANELOCK_CASTERPOINTER", ObjectToInt(oCaster));
		SetLocalInt(oDoor2, "SC_ARCANELOCK_CASTERLEVEL", HkGetCasterLevel( oCaster ) );
		SetLocalString(oDoor2, "SC_ARCANELOCK_CASTERTAG", GetName( oCaster ) );
		SetLocalString(oDoor2, "SC_ARCANELOCK_OLDONOPEN",GetEventHandler(oDoor1, SCRIPT_DOOR_ON_OPEN ) );
		SetEventHandler(oDoor2, SCRIPT_DOOR_ON_OPEN, "SP_arcanelockonopen");
	}
	*/
	
	HkPostCast(oCaster);
}


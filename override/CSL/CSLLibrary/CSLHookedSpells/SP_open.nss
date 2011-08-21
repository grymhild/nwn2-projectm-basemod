//::///////////////////////////////////////////////
//:: Open
//:: NW_S0_Knock
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Opens doors that are not locked.

Transmutation
Level: Sor/Wiz 0
Components: V 
Casting Time: 1 standard action 
Range: Medium (100 ft. + 10 ft./level) 
Target: One door, box, or chest with an area of up to 10 sq. ft./level 
Duration: Instantaneous; see text 
Saving Throw: None 
Spell Resistance: No 

The open spell can open a single item, chest, door as if the caster is standing there, but can do it at range. This is useful when dealing with traps, or it can be used to close/open a door as needed.

It does not affect items that are locked, or where opening is magically blocked.
	
*/
//:://////////////////////////////////////////////
//:: Created By: Brian Meyer
//:: Created On: Nov 29, 2001
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Doors"


void main()
{
	//scSpellMetaData = SCMeta_SP_knock();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_OPEN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 0;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
	//oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	float fDelay;
	int nResist;

	if (GetIsObjectValid(oTarget))
	{
			SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId(), FALSE ));
			//fDelay = CSLRandomBetweenFloat(0.5, 2.5);
			
			// * Returns TRUE if oObject (which is a placeable or a door) is currently open.
			if ( GetIsOpen( oTarget ) )
			{
				// close it
				if ( GetObjectType(oTarget) == OBJECT_TYPE_DOOR )
				{
					ActionCloseDoor( oTarget );
				}
				// Cause the action subject to open oDoor
//void ActionOpenDoor(object oDoor);

// Cause the action subject to close oDoor
//void ActionCloseDoor(object oDoor);
			
			// - oPlaceable
// - nPlaceableAction: PLACEABLE_ACTION_*
// * Returns TRUE if nPlacebleAction is valid for oPlaceable.
//int GetIsPlaceableObjectActionPossible(object oPlaceable, int nPlaceableAction);

// The caller performs nPlaceableAction on oPlaceable.
// - oPlaceable
// - nPlaceableAction: PLACEABLE_ACTION_*
//void DoPlaceableObjectAction(object oPlaceable, int nPlaceableAction);


//int    DOOR_ACTION_OPEN                 = 0;
//int    DOOR_ACTION_UNLOCK               = 1;
//int    DOOR_ACTION_BASH                 = 2;
//int    DOOR_ACTION_IGNORE               = 3;
//int    DOOR_ACTION_KNOCK                = 4;

//int    PLACEABLE_ACTION_USE                  = 0;
//int    PLACEABLE_ACTION_UNLOCK               = 1;
//int    PLACEABLE_ACTION_BASH                 = 2;
///int    PLACEABLE_ACTION_KNOCK                = 4;
			
			
			}
			else if( !GetLockKeyRequired(oTarget) && !GetLocked(oTarget))
			{
				if ( GetObjectType(oTarget) == OBJECT_TYPE_DOOR )
				{
					SCOpenDoor( oTarget, oCaster ); // this opens the door IF it's not protected by arcane lock
				
				}
				
				
				
				
				//nResist =  GetDoorFlag( oTarget, DOOR_FLAG_RESIST_KNOCK );
				//if (nResist == 0)
				//{
				//	DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				//	AssignCommand(oTarget, ActionUnlockObject(oTarget));
				//	
				//	
				//}
				//else if  (nResist == 1)
				//{
				//	FloatingTextStrRefOnCreature(83887,OBJECT_SELF);   //
				//}
			}
			
			//SCKnockArcaneLock( oTarget );
			
			//oTarget = GetNextObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	HkPostCast(oCaster);
}


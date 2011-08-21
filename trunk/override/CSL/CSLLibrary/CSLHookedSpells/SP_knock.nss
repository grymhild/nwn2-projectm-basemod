//::///////////////////////////////////////////////
//:: Knock
//:: NW_S0_Knock
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Opens doors not locked by magical means.

Transmutation
Level: Sor/Wiz 2 
Components: V 
Casting Time: 1 standard action 
Range: Medium (100 ft. + 10 ft./level) 
Target: One door, box, or chest with an area of up to 10 sq. ft./level 
Duration: Instantaneous; see text 
Saving Throw: None 
Spell Resistance: No 

	The knock spell opens stuck, barred, locked, held, or arcane 
	locked doors. It opens secret doors, as well as locked 
	or trick-opening boxes or chests. It also loosens welds,
	shackles, or chains (provided they serve to hold closures shut).
	If used to open a arcane locked door, the spell does not remove 
	the arcane lock but simply suspends its functioning for 10 minutes. 
	In all other cases, the door does not relock itself or become stuck 
	again on its own. Knock does not raise barred gates or similar impediments 
	(such as a portcullis), nor does it affect ropes, vines, and the like. 
	The effect is limited by the area. Each spell can undo as many as
	two means of preventing egress. 


	
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg 2003/07/31 - Added signal event and custom door flags
//:: VFX Pass By: Preston W, On: June 22, 2001


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
	int iSpellId = SPELL_KNOCK;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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
	


	object oTarget;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	float fDelay;
	int nResist;

	while(GetIsObjectValid(oTarget))
	{
			SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId(), FALSE ));
			fDelay = CSLRandomBetweenFloat(0.5, 2.5);
			
			
			if( !GetLockKeyRequired(oTarget) && GetLocked(oTarget))
			{
				nResist =  GetDoorFlag( oTarget, DOOR_FLAG_RESIST_KNOCK );
				if (nResist == 0)
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					AssignCommand(oTarget, ActionUnlockObject(oTarget));
					
					
				}
				else if  (nResist == 1)
				{
					FloatingTextStrRefOnCreature(83887,OBJECT_SELF);   //
				}
			}
			
			SCKnockArcaneLock( oTarget );
			
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	HkPostCast(oCaster);
}


//::///////////////////////////////////////////////
//:: Name 	Regroup
//:: FileName sp_regroup.nss
//:://////////////////////////////////////////////
/**@file Regroup
Conjuration (Teleportation)
Level: Duskblade 3, sorcerer/wizard 3
Components: V,S
Casting Time: 1 standard action
Range: Close
Targets: One willing creature/level
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

Each subject of this spell teleports to a square
adjacent to you. If those squares are occupied or
cannot support the teleported creatures, the creatures
appear as close to you as possible, on a surface that
can support them, in an unoccupied square.

**/
////////////////////////////////////////////////////
// Author: Tenjac
// Date: 	26.9.06
////////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REGROUP; // put spell constant here
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
	object oArea = GetArea(oCaster);
	object oTarget;
	int iSpellPower = HkGetSpellPower( oCaster, 10 );
	int nCounter = 0;
	
	if ( GetIsSinglePlayer() )
	{
		oTarget = GetFirstObjectInArea(oArea);
		
		while(nCounter <= iSpellPower && GetIsObjectValid(oTarget))
		{
			if( oTarget != oCaster && GetIsFriend(oTarget, oCaster) && !GetPlotFlag(oTarget) && CSLGetCanTeleport(oTarget) )
			{
				AssignCommand(oTarget, ClearAllActions() );
				DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_HIT_SPELL_CONJURATION ), GetLocation(oTarget) ) );
				DelayCommand(0.55f, AssignCommand(oTarget, ClearAllActions()) );
				DelayCommand(0.6f, AssignCommand(oTarget, JumpToObject(oCaster)) );
				nCounter++;
			}
			oTarget = GetNextObjectInArea(oArea);
		}
	
	}
	else
	{
		oTarget = GetFirstFactionMember(oCaster, FALSE);
		while ( nCounter <= iSpellPower && GetIsObjectValid(oTarget) && CSLGetCanTeleport(oTarget) )
		{
			if ( oTarget != oCaster && oArea == GetArea(oTarget) ) 
			{
				AssignCommand(oTarget, ClearAllActions() );
				DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_HIT_SPELL_CONJURATION ), GetLocation(oTarget) ) );
				DelayCommand(0.55f, AssignCommand(oTarget, ClearAllActions()) );
				DelayCommand(0.6f, AssignCommand(oTarget, JumpToObject(oCaster)) );
				nCounter++;
			}
			oTarget = GetNextFactionMember(oCaster, FALSE);
		}
	}
	
	if ( nCounter > 0 )
	{
		DelayCommand(0.6f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_HIT_AOE_CONJURATION ), GetLocation(oCaster) ) );
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}



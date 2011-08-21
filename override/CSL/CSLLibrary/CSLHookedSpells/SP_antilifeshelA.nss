//::///////////////////////////////////////////////
//:: Antilife Shell
//:: sg_s0_antilife.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Abjuration
	Level: Animal 6, Clr 6, Drd 6
	Components: V, S, DF
	Casting time: 1 Full Round
	Range: 10 ft
	Area: 10 ft radius centered on you
	Duration: 10 minutes/level
	Saving Throw: None
	Spell Resistance: Yes

	You bring into being a mobile, hemispherical energy
	field that prevents the entrance of most sorts of
	living creatures. The effect hedges out animals,
	aberrations, beasts, magical beasts, dragons, fey,
	giants, humanoids, monstrous humanoids, oozes, plants,
	shapechangers, and vermin, but not constructs,
	elementals, outsiders, or undead.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 28, 2004
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	location lTarget 		= CSLGenerateNewLocation(oTarget, SC_DISTANCE_SHORT, CSLGetOppositeDirection(GetFacing(oTarget)), GetFacing(oTarget));
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	//---
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	//float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	//int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//---
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if( oTarget!=oCaster && CSLGetIsLiving(oTarget, TRUE) && CSLGetIsOutsider(oTarget, TRUE) )
	{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ANTILIFE_SHELL, FALSE ) );
			if(!HkResistSpell(oCaster,oTarget))
			{
				AssignCommand( oTarget, ClearAllActions() );
				//DelayCommand( 1.0f, oTarget, JumpToLocation(lTarget) );
				DelayCommand( 1.0f, AssignCommand( oTarget, JumpToLocation(lTarget) ) );
			}
	}

}

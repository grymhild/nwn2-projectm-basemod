//::///////////////////////////////////////////////
//:: Vine Mine, Camouflage: On Enter
//:: X2_S0_VineMCamA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Friendly creatures entering the zone of Vine Mine,
	Camouflage have a +4 added to hide checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_vineminecamo(); //SPELL_VINE_MINE_CAMOUFLAGE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_VINE_MINE_CAMOUFLAGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_CAMOFLAGE);
	effect eSkill = EffectSkillIncrease(SKILL_HIDE, 4);
	effect eLink = EffectLinkEffects(eDur, eSkill);

	object oTarget = GetEnteringObject();
	if (DEBUGGING >= 6) { CSLDebug("VineMineCamoA: Entering AOE", oTarget ); }
	
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, GetAreaOfEffectCreator()))
	{
		if(!GetHasSpellEffect( GetSpellId(), oTarget))
		{
			//Fire cast spell at event for the target
		//bRemovedEffect =
		//CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, GetAreaOfEffectCreator(), oTarget, SPELL_VINE_MINE_CAMOUFLAGE, SPELL_MASS_CAMOFLAGE, SPELL_CAMOFLAGE );
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, GetAreaOfEffectCreator(), oTarget, SPELL_VINE_MINE_CAMOUFLAGE, SPELL_MASS_CAMOFLAGE, SPELL_CAMOFLAGE );
		
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), GetSpellId(), FALSE));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
		}
	}
	
}
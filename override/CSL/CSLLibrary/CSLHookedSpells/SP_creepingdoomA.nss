//::///////////////////////////////////////////////
//:: Creeping Doom: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature caught in the swarm take an initial
	damage of 1d20, but there after they take
	1d4 per swarm counter on the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_creepingdoom(); //SPELL_CREEPING_DOOM;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_CREEPING_DOOM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	int iDamage;
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
	object oTarget = GetEnteringObject();
	effect eSpeed = EffectMovementSpeedDecrease(50);
	//effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); // NWN1 VFX
	effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_SLOW ); // NWN2 VFX
	effect eLink = EffectLinkEffects(eSpeed, eVis2);
	float fDelay;
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
	{
			//Fire cast spell at event for the target
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_CREEPING_DOOM, TRUE ));
			fDelay = CSLRandomBetweenFloat(1.0, 1.8);
			//Spell resistance check
			if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
			{
				//Roll Damage
				iDamage = d20();
				//Set Damage Effect with the modified damage
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING);
				//Apply damage and visuals
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			}
	}
}
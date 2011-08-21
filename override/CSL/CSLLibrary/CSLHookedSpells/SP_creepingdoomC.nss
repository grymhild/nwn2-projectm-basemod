//::///////////////////////////////////////////////
//:: Creeping Doom: Heartbeat
//:: NW_S0_CrpDoomC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creature caught in the swarm take an initial
	damage of 1d20, but there after they take
	1d6 per swarm counter on the AOE.
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
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_CREEPING_DOOM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDamage;
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
	object oTarget = GetEnteringObject();
	string sConstant1 = "NW_SPELL_CONSTANT_CREEPING_DOOM1" + ObjectToString(GetAreaOfEffectCreator());
	string sConstant2 = "NW_SPELL_CONSTANT_CREEPING_DOOM2" + ObjectToString(GetAreaOfEffectCreator());
	int nSwarm = GetLocalInt(OBJECT_SELF, sConstant1);
	int nDamCount = GetLocalInt(OBJECT_SELF, sConstant2);
	float fDelay;
	if(nSwarm < 1)
	{
			nSwarm = 1;
	}


	//Get first target in spell area
	oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget) && nDamCount < 1000)
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
			{
				fDelay = CSLRandomBetweenFloat(1.0, 2.2);
				//------------------------------------------------------------------
				// According to the book, SR Does not count against creeping doom
				//------------------------------------------------------------------
				//Spell resistance check
//            if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
//            {
					SignalEvent(oTarget,EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_CREEPING_DOOM));
					//Roll Damage
					iDamage = d6(nSwarm);
					//Set Damage Effect with the modified damage
					eDam = EffectDamage(iDamage, DAMAGE_TYPE_PIERCING);
					//Apply damage and visuals
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					nDamCount = nDamCount + iDamage;
//            }
			}
			//Get next target in spell area
			oTarget = GetNextInPersistentObject();
	}
	if(nDamCount >= 1000)
	{
			DestroyObject(OBJECT_SELF, 1.0);
	}
	else
	{
			nSwarm++;
			SetLocalInt(OBJECT_SELF, sConstant1, nSwarm);
			SetLocalInt(OBJECT_SELF, sConstant2, nDamCount);
	}
}
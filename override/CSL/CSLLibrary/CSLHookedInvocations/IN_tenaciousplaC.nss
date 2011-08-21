//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Tenacious Plague   HEARTBEAT
//:: nw_s0_itenplagec.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
			Tenacious Plague [B]
			Complete Arcane, pg. 135
			Spell Level: 6
			Class: Misc

			This invocation functions similar to the creeping doom spell (7th level
			druid). But the progression of damage works differently - 1d6 the first
			round, 2d6 the second, 3d6 the third, etc. until the 10th round when the
			invocation effect ends. Tenacious plagues cannot be stacked on top of
			each other.

			[Rules Note] This spell is extremely different from the Complete Arcane
			spell because in NWN2 we won't have swarms that can be summoned. So a
			lesser version of the creeping doom spell is used here.

*/
//:://////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDamage;
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
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
					SignalEvent(oTarget,EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_I_TENACIOUS_PLAGUE));
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

	/*
	if(nDamCount >= 1000)
	{
			DestroyObject(OBJECT_SELF, 1.0);
	}
	else */
	{
			nSwarm++;

		if ( nSwarm >= 10 )
		{
			DestroyObject(OBJECT_SELF, 1.0);
		}
		else
		{
				SetLocalInt(OBJECT_SELF, sConstant1, nSwarm);
				SetLocalInt(OBJECT_SELF, sConstant2, nDamCount);
		}
	}
}
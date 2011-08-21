//::///////////////////////////////////////////////
//:: Caustic Web - Heartbeat
//:: cmi_s0_causwebc
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Caustic Web
//:: Invocation Type: Greater;
//:: Spell Level Equivalent: 4
//:: Sticky strands cling to all creatures within the area of effect, entangling
//:: them. Creatures who make their save can move, but at a reduced rate
//:: dependent on their Strength. Entering the web causes 2d6 points of acid
//:: damage while those that remain within the area suffer 1d6 points of damage
//:: each round.
//:://////////////////////////////////////////////
//const int SPELL_I_CAUSTIC_MIRE = 2092;


#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_I_CAUSTIC_MIRE;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------		
		
	effect eVis = EffectVisualEffect(VFX_DUR_WEB);
	effect eDmg;
	//Spell resistance check
	object oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{
		// if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
		if( !CSLGetIsIncorporeal(oTarget) ) //if( (GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )	// AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE));

				
				//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
				//{
					//Make a Reflex Save to avoid the effects of the entangle.
					//if(!/*Reflex Save*/ HkSavingThrow(SAVING_THROW_REFLEX, oTarget, GetInvocationSaveDC(oCaster, TRUE)))
					//{
						eDmg = EffectDamage(d6(1), DAMAGE_TYPE_ACID);
						 DelayCommand(0.02f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget) );
						//Entangle effect and Web VFX impact
						//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeb, oTarget, RoundsToSeconds(1));
						 DelayCommand(0.02, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1)) );
				//	}
				//}
			}
		}
		oTarget = GetNextInPersistentObject();
	}
}
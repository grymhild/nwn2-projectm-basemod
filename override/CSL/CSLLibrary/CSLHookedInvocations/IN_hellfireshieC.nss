//::///////////////////////////////////////////////
//:: Hellfire Shield HEARTBEAT
//:: NW_S2_hellfireshield.nss
//:: Copyright (c) 2008 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    Hellfire Warlock aura. Hits everyone in melee
	range on heartbeat with a Heallfire Blast in
	exchange for 1 Con per hit.  HEARTBEAT SCRIPT
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: 06/20/2008
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"

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
	
	
	//SpeakString("DEBUGGING MESSAGE (JWR-OEI 08.22.08): HellfireShield Heartbeat");
	int bIsShieldActive = GetActionMode(oCaster, ACTION_MODE_HELLFIRE_SHIELD);
	if (!bIsShieldActive)
	{
		//CSLRemoveAuraById( oCaster, SPELLABILITY_HELLFIRE_SHIELD );
		//SendMessageToPC( oCaster, "DEBUGGING MESSAGE(JWR-OEI 08.22.08): HellfireShield  not active");
		return;
	}
	
	if (GetIsDead(oCaster, FALSE))
	{
		//SendMessageToPC( oCaster, "Dead");
		SetActionMode(oCaster, ACTION_MODE_HELLFIRE_SHIELD, 0);
		return;
	}
	
	//SendMessageToPC( oCaster,"DEBUGGING MESSAGE(JWR-OEI 08.22.08): HellfireShield on");
	int nLevels = GetLevelByClass(CLASS_TYPE_HELLFIRE_WARLOCK, oCaster) + GetLevelByClass(CLASS_TYPE_WARLOCK, oCaster);
	int nChrMod = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	int nDC = 10 + (nLevels/2) + nChrMod;
	int nTotal = 0; // number of creatures we hit.
	int nDice = GetEldritchBlastLevel(oCaster) + GetHellfireBlastDiceBonus(oCaster); // number of dice to roll
	int nDmg = 0; // amount to damage
	effect eDmg; // damage effect
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_FIRE); // hit vfx VFX_HIT_SPELL_FIRE
	effect eLink; // linked effect
	
	// make sure we have valid const to cast this
	int nCurrCon = GetAbilityScore( oCaster, ABILITY_CONSTITUTION );
	if ( nCurrCon < 1 )
	{
		//Display Stopping Text
		//SendMessageToPC( oCaster,"Con Depleted So Cannot Use");
		FloatingTextStringOnCreature(GetStringByStrRef(STRREF_HELLFIRE_SHIELD_NO_CON), oCaster);
		SetActionMode(oCaster, ACTION_MODE_HELLFIRE_SHIELD, 0);
		//CSLRemoveAuraById( oCaster, SPELLABILITY_HELLFIRE_SHIELD );
		return;	
	}
	//FIX: if immune to ability damage, no hellfire for you!
	else if ( GetIsImmune(oCaster, IMMUNITY_TYPE_ABILITY_DECREASE) )
	{
		//SendMessageToPC( oCaster,"Immune to drain so cannot use");
		SetActionMode(oCaster, ACTION_MODE_HELLFIRE_SHIELD, 0); 
		//CSLRemoveAuraById( oCaster, SPELLABILITY_HELLFIRE_SHIELD );
		return;	
	}
	
	//SendMessageToPC( oCaster,"DEBUGGING MESSAGE(JWR-OEI 08.22.08): HellfireShield damaging things");
	object oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	 {
	 	if (  oTarget != oCaster && GetIsEnemy(oTarget, oCaster)) 
		{
			if ( !HkResistSpell(oCaster, oTarget) )
			{
				nDmg = d6(nDice);
				/*// Relex Throw chance to halve the damage
				if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
				{
					nDmg=nDmg/2;
				}*/
				nDmg = GetReflexAdjustedDamage(nDmg, oTarget, nDC, SAVING_THROW_TYPE_NONE);
			}
			else 
			{
				nDmg = 0; //needed to remove value from previous loop
			}
				
			if (nDmg > 0)
			{
				eDmg = EffectDamage(nDmg, DAMAGE_TYPE_MAGICAL);
				eLink = EffectLinkEffects(eHit, eDmg);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
			nTotal++;
			
					
		}
		oTarget = GetNextInPersistentObject();
	 }
	
	// Apply CON Damage
	if (nTotal > 0)
	{
		effect eConst = EffectAbilityDecrease(ABILITY_CONSTITUTION, nTotal);
		eConst = SetEffectSpellId(eConst, -1); // set to invalid spell ID to allow stacking.
		eConst = ExtraordinaryEffect(eConst);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eConst, oCaster);
		HellfireShieldFeedbackMsg(nTotal, STRREF_HELLFIRE_SHIELD_NAME, oCaster);
	} 
}
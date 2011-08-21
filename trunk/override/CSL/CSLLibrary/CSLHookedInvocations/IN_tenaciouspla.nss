//::///////////////////////////////////////////////
//:: Tenacious Plague
//:: NW_S0_itenplage
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	The warlock calls forth swarms of magical
	locusts that harass and bite hostile targets within
	the defined area.

	One swarm is summoned for every three character levels.
	Swarms attack at +4 and deal 2d6 magical damage.

	This script is based on my implementation of
	Creeping Doom.  Notable changes are that this
	spell cannot stack, there are fewer swarms summoned,
	and swarms deal magical damage instead of poison.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"





int RunRollToHit(object oTarget, object oCaster)
{
	//roll against the AC of the target bab +6 + caster's wisdom modifier * 2
	int iRoll = d20();
	if (iRoll==20) return TRUE;
	if (iRoll==1)  return FALSE;
	iRoll += GetBaseAttackBonus(oCaster) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	//iRoll += 6 + 2 * GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	return (iRoll>=GetAC(oTarget));
}

void RunSwarmAttack(object oTarget, object oCaster, int nRounds)
{
	//if ( !GetIsObjectValid(oTarget) || GetIsDead(oTarget) || nRounds < 1 || !GetHasSpellEffect(SPELL_I_TENACIOUS_PLAGUE, oTarget) ) { return; }
	if (CSLGetDelayedSpellEffectsExpired(SPELL_I_TENACIOUS_PLAGUE, oTarget, oCaster)) return; // IF SPELL EFFECT IS GONE, DON'T CONTINUE DOING DAMAGE
	//if (RunRollToHit(oTarget, oCaster)) { //ROLL TO HIT TARGET
		//Determine and apply damage + poison, DC save against this poison is 11
		int iBonus = HkGetWarlockBonus(oCaster);
		effect eHurt = EffectDamage(d6(2)+iBonus, DAMAGE_TYPE_MAGICAL);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHurt, oTarget);
	//}
	if (nRounds) DelayCommand(6.0, RunSwarmAttack(oTarget, oCaster, nRounds-1)); // RECURSE THE SWARM FUNCTION UNTIL THE EFFECT EXPIRES OR ROUNDS RUN OUT
}

void main()
{
	//scSpellMetaData = SCMeta_IN_tenaciouspla();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lTarget = HkGetSpellTargetLocation();
	int iCasterLevel   = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
	int nSwarms      = iCasterLevel / 3;
	int nMaxSwarms   = nSwarms;
	float fDuration  = HkApplyMetamagicDurationMods(RoundsToSeconds(3)); //Meta-magic fun
	int iDuration    = FloatToInt(fDuration)/6;
	//effect ePedes    = EffectVisualEffect(VFX_DUR_INVOCATION_TENACIOUS_PLAGUE);
	effect ePedes    = EffectVisualEffect(VFXSC_SWARM_BROWN);
	
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	//effect eImpactVis = EffectVisualEffect( iImpactSEF );
	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Find the first victim
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	object oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	//If the first object is the caster and the second object is invalid, we do not have any valid targets
	if (oTarget==oCaster && !GetIsObjectValid(oTarget2)) return;
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
	while (nSwarms > 0 ) //While we still have swarms to assign, run the following logic
	{
		if (GetIsObjectValid(oTarget)) 
		{
			if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && d2()==1) // ADDED D2() FOR RANDOMNESS AS DESCRIBED
			{
				if (!CSLGetHasSpellEffectByCaster(SPELL_I_TENACIOUS_PLAGUE, oTarget, oCaster)) // ONLY APPLY EFFECT ONCE AND SIGNAL SPELL WAS CAST
				{
					DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePedes, oTarget, fDuration));
					SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_I_TENACIOUS_PLAGUE));
				}
				DelayCommand(6.0, RunSwarmAttack(oTarget, oCaster, iDuration-1)); //Run Swarm function
				nSwarms--; //Remove a swarm
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, FALSE, OBJECT_TYPE_CREATURE); //Grab the next target
		} 
		else  // If the target was not valid, start loop over again until all are applied
		{
			if (nSwarms==nMaxSwarms) 
			{
				SendMessageToPC(oCaster,"No valid targets for swarms to attack.");	
				return; //If no swarms have been applied we know there are no valid targets for the spell.
			}
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
		}
	}
	HkPostCast(oCaster);
}
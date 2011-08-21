//::///////////////////////////////////////////////
//:: Creeping Doom
//:: NW_S0_CrpDoom
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	The druid summons masses of centipedes and biting
	insects, one per two caster levels, that attack targets
	at random within the effected area.

	Swarms have a BAB of +6 and must roll to hit the target
	normally.  They do 2d6 points of damage in addition
	to poisoning the target.  Swarms persist for three rounds
	before dissipating.

	The swarms, when summoned, will iterate between targets
	in the defined shape, attaching themselves as a DoT
	to each target in turn.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"


int RunRollToHit(object oTarget, object oCaster) {
	//roll against the AC of the target bab +6 + caster's wisdom modifier * 2
	int iRoll = d20();
	if (iRoll==20) return TRUE;
	if (iRoll==1)  return FALSE;
	iRoll += 6 + 2 * GetAbilityModifier(ABILITY_WISDOM, oCaster);
	return (iRoll>=GetAC(oTarget));
}

void RunSwarmAttack(object oTarget, object oCaster, int nRounds) {
	if (CSLGetDelayedSpellEffectsExpired(SPELL_CREEPING_DOOM, oTarget, oCaster)) return; // IF SPELL EFFECT IS GONE, DON'T CONTINUE DOING DAMAGE
	if (RunRollToHit(oTarget, oCaster)) { //ROLL TO HIT TARGET
		//Determine and apply damage + poison, DC save against this poison is 11
		effect eHurt = EffectDamage(d6(2), DAMAGE_TYPE_PIERCING);
		effect ePoison = EffectPoison(POISON_SMALL_CENTIPEDE_POISON);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHurt, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoison, oTarget, 30.0f);
	}
	if (nRounds) DelayCommand(6.0, RunSwarmAttack(oTarget, oCaster, nRounds-1)); // RECURSE THE SWARM FUNCTION UNTIL THE EFFECT EXPIRES OR ROUNDS RUN OUT
}


void main()
{
	//scSpellMetaData = SCMeta_SP_creepingdoom();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CREEPING_DOOM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iImpactSEF = VFX_HIT_AOE_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_SUMMONING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	location lTarget = HkGetSpellTargetLocation();
	int iCasterLevel   = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nSwarms      = iCasterLevel / 2;
	int nMaxSwarms   = nSwarms;
	float fDuration  = HkApplyMetamagicDurationMods(RoundsToSeconds(3)); //Meta-magic fun
	int iDuration    = FloatToInt(fDuration)/6;
	effect ePedes    = EffectVisualEffect(VFX_DUR_SPELL_CREEPING_DOOM);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	
	
	//Find the first victim
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	object oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	//If the first object is the caster and the second object is invalid, we do not have any valid targets
	
	if (oTarget==oCaster && !GetIsObjectValid(oTarget2)) return;
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while (nSwarms>0) { //While we still have swarms to assign, run the following logic
		if (GetIsObjectValid(oTarget)) {
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && d2()==1) { // ADDED D2() FOR RANDOMNESS AS DESCRIBED
				if (!CSLGetHasSpellEffectByCaster(SPELL_CREEPING_DOOM, oTarget, oCaster)) { // ONLY APPLY EFFECT ONCE AND SIGNAL SPELL WAS CAST
					DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePedes, oTarget, fDuration));
					SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CREEPING_DOOM));
				}
				DelayCommand(6.0, RunSwarmAttack(oTarget, oCaster, iDuration-1)); //Run Swarm function
				nSwarms--; //Remove a swarm
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE); //Grab the next target
		} else { // If the target was not valid, start loop over again until all are applied
			if (nSwarms==nMaxSwarms) return; //If no swarms have been applied we know there are no valid targets for the spell.
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
		}
	}
	
	HkPostCast(oCaster);
}


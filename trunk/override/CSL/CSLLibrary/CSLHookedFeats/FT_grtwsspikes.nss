//::///////////////////////////////////////////////////
//:: x2_s1_gwspikes
//:: Shifter version of the manticore attack
//:: Copyright (c) 2003, 2004 Bioware Corp
//:: Created By: Georg ZOeller
//:: Created On: 10/2003
//:: Updated On: 03/2004 - signalling hostile event
//::///////////////////////////////////////////////////

#include "_HkSpell"
void SHManticoreAttack(int nMissiles, int nCap, int iSpellId, int nMIRV = VFX_IMP_MIRV,
	int nVIS = VFX_IMP_MAGBLUE, int nDAMAGETYPE = DAMAGE_TYPE_MAGICAL, int nONEHIT = FALSE)
{
	object oCaster = OBJECT_SELF;
	object oTarget = OBJECT_INVALID;
	int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDamage = 0;
	int nCnt =1;
	effect eMissile = EffectVisualEffect(nMIRV);
	effect eVis = EffectVisualEffect(nVIS);
	float fDist = 0.0;
	float fDelay = 0.0;
	float fDelay2, fTime;
	location lTarget = HkGetSpellTargetLocation(); // missile spread centered around caster

	if (nMissiles > nCap)
	{
			nMissiles = nCap;
	}
	int nd4Dice = nMissiles;

			/* New Algorithm
				1. Count # of targets
				2. Determine number of missiles
				3. First target gets a missile and all Excess missiles
				4. Rest of targets (max nMissiles) get one missile
		*/
	int nEnemies = 0;

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget) )
	{
			// * caster cannot be harmed by this spell
			if (CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && (oTarget != OBJECT_SELF))
			{
				nEnemies++;
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}

		if (nEnemies == 0) return; // * Exit if no enemies to hit

		// by default the Remainder will be 0 (if more than enough enemies for all the missiles)
		int nRemainder = 0;

	if (nEnemies > nMissiles)
			nEnemies = nMissiles;

	int nExtraMissiles = nMissiles / nEnemies;

		// April 2003
		// * if more enemies than missiles, need to make sure that at least
		// * one missile will hit each of the enemies
		nRemainder = nMissiles % nEnemies;


	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget) && nCnt <= nEnemies)
	{
			// * caster cannot be harmed by this spell
			if (CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && (oTarget != OBJECT_SELF))
			{

		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

					// * recalculate appropriate distances

					fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
					fDelay = fDist/(3.0 * log(fDist) + 2.0);

					int i = 0;
					// * first target will get excess missiles
					for (i=1; i <= nExtraMissiles + nRemainder; i++)
					{
							//Make SR Check and a succesful touch attack
							int iTouch = CSLTouchAttackRanged(oTarget, TRUE);
							if ( iTouch != TOUCH_ATTACK_RESULT_MISS )
							{
								//Roll damage
								int nDam = d4(nd4Dice);
								nDam = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nDam, SC_TOUCHSPELL_RANGED, oCaster );
		
								fTime = fDelay;
								fDelay2 += 0.1;
								fTime += fDelay2;

								//Set damage effect
								effect eDam = EffectDamage(nDam, nDAMAGETYPE);
								//Apply the MIRV and damage effect
								DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
								DelayCommand(fDelay2, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));

								DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
								// Play the sound of a dart hitting
								DelayCommand(fTime, PlaySound("cb_ht_dart1"));

							}
							else
							{  // * apply a dummy visual effect
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
							}
					} // for
					nCnt++;// * increment count of missiles fired
					nRemainder = 0;
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}

}

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	int iSpellPower = GetLevelByClass( CLASS_TYPE_SHIFTER);
	if (iSpellPower == 0)
	{
			iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	}

	int nMissiles = iSpellPower / 2;


	SHManticoreAttack(nMissiles, 5, GetSpellId(), 359, VFX_COM_BLOOD_SPARK_SMALL, DAMAGE_TYPE_PIERCING);

}
//::///////////////////////////////////////////////
//:: Gedlee's Electric Loop
//:: X2_S0_ElecLoop
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	You create a small stroke of lightning that
	cycles through all creatures in the area of effect.
	The spell deals 1d6 points of damage per 2 caster
	levels (maximum 5d6). Those who fail their Reflex
	saves must succeed at a Will save or be stunned
	for 1 round.

	Spell is standard hostile, so if you use it
	in hardcore mode, it will zap yourself!

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 19 2003
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GEDLEES_ELECTRIC_LOOP;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lTarget    = HkGetSpellTargetLocation();
	float    fDelay;
	int      iDamage;
	int      nPotential;
	object   oLastValid;

	//--------------------------------------------------------------------------
	// Calculate Damage Dice. 1d per 2 caster levels, max 5d
	//--------------------------------------------------------------------------
	int iNumDice = CSLGetMax( HkGetSpellPower(OBJECT_SELF, 10)/2, 1);
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_LIGHTNING, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect   eStrike  = EffectVisualEffect(iHitEffect);
	effect   eBeam;
	effect   eDam;
	effect   eStun = EffectLinkEffects(EffectVisualEffect(VFX_IMP_STUN),EffectStunned());

	//--------------------------------------------------------------------------
	// Loop through all targets
	//--------------------------------------------------------------------------
	// BCH - OEI 03/17/06, bumped up to MEDIUM size otherwise it only hits one target
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

				//------------------------------------------------------------------
				// Calculate delay until spell hits current target. If we are the
				// first target, the delay is the time until the spell hits us
				//------------------------------------------------------------------
				if (GetIsObjectValid(oLastValid))
				{
						fDelay += 0.2f;
						fDelay += GetDistanceBetweenLocations(GetLocation(oLastValid), GetLocation(oTarget))/20;
				}
				else
				{
					fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
				}

				//------------------------------------------------------------------
				// If there was a previous target, draw a lightning beam between us
				// and iterate delay so it appears that the beam is jumping from
				// target to target
				//------------------------------------------------------------------
				if (GetIsObjectValid(oLastValid))
				{
						eBeam = EffectBeam(iShapeEffect, oLastValid, BODY_NODE_CHEST);
						DelayCommand(fDelay,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam,oTarget,1.5f));
				}

				if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{

					nPotential = HkApplyMetamagicVariableMods( d6(iNumDice), 6*iNumDice );;
					iDamage    = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nPotential, oTarget, HkGetSpellSaveDC(), iSaveType);

					//--------------------------------------------------------------
					// If we failed the reflex save, we save vs will or are stunned
					// for one round
					//--------------------------------------------------------------
					if (nPotential == iDamage || (GetHasFeat(FEAT_IMPROVED_EVASION,oTarget) &&  iDamage == (nPotential/2)))
					{
							if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
							{
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eStun,oTarget, RoundsToSeconds(1)));
							}

					}


					if (iDamage >0)
					{
							eDam = HkEffectDamage(iDamage, iDamageType);
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, oTarget));
						}
				}

				//------------------------------------------------------------------
				// Store Target to make it appear that the lightning bolt is jumping
				// from target to target
				//------------------------------------------------------------------
				oLastValid = oTarget;

			}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE );
	}
	HkPostCast(oCaster);
}


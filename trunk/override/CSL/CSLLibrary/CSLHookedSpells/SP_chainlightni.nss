//::///////////////////////////////////////////////
//:: Chain Lightning
//:: NW_S0_ChLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The primary target is struck with 1d6 per caster,
	1/2 with a reflex save.  1 secondary target per
	level is struck for 1d6 / 2 caster levels.  No
	repeat targets can be chosen.
*/
//:://////////////////////////////////////////////
//:: Created By: Brennon Holmes
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 26, 2001
//:: Update Pass By: Preston W, On: July 26, 2001

/*
bugfix by Kovi 2002.07.28
- successful saving throw and (improved) evasion was ignored for
 secondary targets,
- all secondary targets suffered exactly the same damage
2002.08.25
- primary target was not effected
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_chainlightni();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CHAIN_LIGHTNING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = HkGetSpellPower( OBJECT_SELF, 20 ); // OldGetCasterLevel(OBJECT_SELF);
	
	// calculates for the first target only
 	int iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
	int nDamStrike;
	int nNumAffected = 0;
	object oFirstTarget = HkGetSpellTarget();
	object oHolder;
	object oTarget;
	location lSpellLocation;

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_LIGHTNING, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	//Declare lightning effect connected the casters hands
	effect eLightning = EffectBeam(iShapeEffect, OBJECT_SELF, BODY_NODE_HAND);;
	effect eVis  = EffectVisualEffect(iHitEffect);
	effect eDamage;
	//Enter Metamagic conditions
	
	//Damage the initial target
	if (CSLSpellsIsTarget(oFirstTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
			//Make an SR Check
			if (!HkResistSpell(OBJECT_SELF, oFirstTarget))
			{
				//Adjust damage via Reflex Save or Evasion or Improved Evasion
				nDamStrike = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oFirstTarget, HkGetSpellSaveDC(), iSaveType);
				//Set the damage effect for the first target
				eDamage = HkEffectDamage(nDamStrike, iDamageType);
				//Apply damage to the first target and the VFX impact.
				if(nDamStrike > 0)
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oFirstTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
				}
			}
	}
	//Apply the lightning stream effect to the first target, connecting it with the caster
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5);
	

	//Reinitialize the lightning effect so that it travels from the first target to the next target
	eLightning = EffectBeam(iShapeEffect, oFirstTarget, BODY_NODE_CHEST);


	float fDelay = 0.2;
	int nCnt = 0;


	// *
	// * Secondary Targets
	// *


	//Get the first target in the spell shape
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oFirstTarget), TRUE );
	while (GetIsObjectValid(oTarget) && nCnt < iSpellPower)
	{
			//Make sure the caster's faction is not hit and the first target is not hit
			if (oTarget != oFirstTarget && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				//Connect the new lightning stream to the older target and the new target
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5));

				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
				//Do an SR check
				if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
					int iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
					//Adjust damage via Reflex Save or Evasion or Improved Evasion
					nDamStrike = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
					//Apply the damage and VFX impact to the current target
					eDamage = HkEffectDamage(nDamStrike /2, iDamageType);
					if(nDamStrike > 0) //age > 0)
					{
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
					}
				}
				oHolder = oTarget;

				//change the currect holder of the lightning stream to the current target
				if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
				{
					eLightning = EffectBeam(iShapeEffect, oHolder, BODY_NODE_CHEST);
					nCnt++;
				}
				else
				{
					// * April 2003 trying to make sure beams originate correctly
					effect eNewLightning = EffectBeam(iShapeEffect, oHolder, BODY_NODE_CHEST);
					if(GetIsEffectValid(eNewLightning))
					{
							eLightning =  eNewLightning;
					}
				}

				fDelay = fDelay + 0.1f;
			}
			//Count the number of targets that have been hit.
			//if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
			//{
			//	nCnt++;
			//}

			// April 2003: Setting the new origin for the beam
		// oFirstTarget = oTarget;

			//Get the next target in the shape.
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oFirstTarget), TRUE );
		}
		
		HkPostCast(oCaster);
 }


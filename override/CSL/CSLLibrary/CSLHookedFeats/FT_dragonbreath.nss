//::///////////////////////////////////////////////
//:: Epic Dragon Breath
//:: NW_S1_DragLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Calculates the proper damage and DC Save for the
	breath weapon based on the HD of the dragon.

	This spell is only intended to be used by the
	shifter's/druids dragon breath ability

	Druid's without at least 10 levels of shifter
	will do 4 dice damage less than a true shifter

	Green Dragon Gas also poisons the creatures
	to make up for its lower damage

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-Oct-14
//:://////////////////////////////////////////////
//:: RPGplayer1 03/27/2008:
//::  Retooled for dragon companion use (iDice & iDC)
//::  Make damage roll for each target
//::  Show dragon breath VFX

#include "_HkSpell"
#include "_HkSpell"
#include "_SCInclude_Polymorph"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	int iAge;
	int bShifter = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF)>=10);
	int bDragon = (GetLevelByClass(CLASS_TYPE_DRAGON,OBJECT_SELF) > 0);
	int bPoison = FALSE;

/* This totally doesn't work right, GetHasFeat has been incorrectly used.
	If this is the last use per day of Dragon Shape, GetHasFeat will return 0
	because it is no longer useable. Therefore, the damage calculation will be wrong.
	// -------------------------------------------------------------------------
	// We assume this spell is only used in dragon form
	// -------------------------------------------------------------------------
	if (GetHasFeat(873,OBJECT_SELF))
	{
			iAge = GetLevelByClass(CLASS_TYPE_DRUID,OBJECT_SELF) +  GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF);
	}
	// -------------------------------------------------------------------------
	// .. this case should never happen, but people do strange things with
	//    the toolset
	// -------------------------------------------------------------------------
	else if (GetIsPC(OBJECT_SELF))
	{
			iAge = GetHitDice(OBJECT_SELF)/2;
	}
	else
	{
			iAge = GetHitDice(OBJECT_SELF);
	}
*/
	// This should work better.
	if (bDragon)
	{
			iAge = GetHitDice(OBJECT_SELF);
	}
	else iAge = GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF)  +  GetLevelByClass(CLASS_TYPE_SHIFTER, OBJECT_SELF);

	// Just in case...
	if (iAge==0)
	{
			if (GetIsPC(OBJECT_SELF))
			{
				iAge = GetHitDice(OBJECT_SELF)/2;
			}
			else
			{
				iAge = GetHitDice(OBJECT_SELF);
			}
	}

	int iDice;
	int iDamage;
	int iDC;
	// -------------------------------------------------------------------------
	// Your damage dice and save DC are dependent on your hit dice
	// -------------------------------------------------------------------------
	if (iAge <= 6) //Wyrmling
	{
			iDice = 1;
	}
	else if (iAge >= 7 && iAge <= 9) //Very Young
	{
			iDice = 2;
	}
	else if (iAge >= 10 && iAge <= 12) //Young
	{
			iDice = 4;
	}
	else if (iAge >= 13 && iAge <= 15) //Juvenile
	{
			iDice = 6;
	}
	else if (iAge >= 16 && iAge <= 18) //Young Adult
	{
			iDice = 8;
	}
	else if (iAge >= 19 && iAge <= 21) //Adult
	{
			iDice = 10;
	}
	else if (iAge >= 22 && iAge <= 24) //Mature Adult
	{
			iDice = 12;
	}
	else if (iAge >= 25 && iAge <= 27) //Old
	{
			iDice = 14;
	}
	else if (iAge >= 28 && iAge <= 30) //Very Old
	{
			iDice = 16;
	}
	else if (iAge >= 31 && iAge <= 33) //Ancient
	{
			iDice = 18;
	}
	else if (iAge >= 34 && iAge <= 37) //Wyrm
	{
			iDice = 20;
	}
	else if (iAge > 37 && iAge <40) //Great Wyrm
	{
			iDice = 22;
	}
	else
	{
			iDice = 24;
	}

	if (bDragon)
	{
			iDC = 15 + iAge/2;
	}
	else iDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_NORMAL,TRUE);

	if (!bShifter && !bDragon) // a shifter is a bit better at controlling this weapon
	{
		iDice -=4;
		iDC -=4;
	}

	int iSpellId= GetSpellId();
	int nVis;
	int nType;
	int iSave;

	if (iSpellId == 796) // lightning
	{
			nVis = VFX_IMP_LIGHTNING_S;
			nType = DAMAGE_TYPE_ELECTRICAL;
			iSave = SAVING_THROW_TYPE_ELECTRICITY;
			iDamage = d8(iDice);

			//FIX: added cone visuals
			effect eBreath = EffectVisualEffect(VFX_DUR_CONE_LIGHTNING);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBreath, OBJECT_SELF, 1.0f);
	}
	else if (iSpellId == 797) // fire
	{
			nVis = VFX_IMP_FLAME_M;
			nType = DAMAGE_TYPE_FIRE;
			iSave = SAVING_THROW_TYPE_FIRE;
			iDamage = d10(iDice);
	}
	else //gas
	{
			nVis = VFX_IMP_POISON_L;
			nType = DAMAGE_TYPE_ACID;
			iSave = SAVING_THROW_TYPE_ACID;
			iDamage = d6(iDice);
			bPoison = TRUE;
	}

	effect eVis  = EffectVisualEffect(nVis);
	effect eDamage;
	effect ePoison;
	object oTarget;
	int nDamStrike;
	float fDelay;
		//------------------------------------------------------------------
	// Loop over all creatures, doors and placeables in the area of effect
	//------------------------------------------------------------------
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 15.0, HkGetSpellTargetLocation(), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oTarget))
	{
			if(oTarget != OBJECT_SELF && CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

				//FIX: roll damage for each target
				if (iSpellId == 796) // lightning
				{
					iDamage = d8(iDice);
				}
				else if (iSpellId == 797) // fire
				{
					iDamage = d10(iDice);
				}
				else //gas
				{
					iDamage = d6(iDice);
				}

				//------------------------------------------------------------------
				// Calculate and Apply Reflex Save Adjusted Damage
				//------------------------------------------------------------------
				nDamStrike = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage,oTarget, iDC,iSave, OBJECT_SELF);
				if(nDamStrike > 0)
				{

					eDamage = EffectDamage(nDamStrike, nType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
				}

				//------------------------------------------------------------------
				// Green Dragon Breath is poisonous for creatures!
				//------------------------------------------------------------------
				if (bPoison && GetObjectType(oTarget) ==OBJECT_TYPE_CREATURE)
				{
					ePoison = EffectPoison(44);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT,ePoison,oTarget));
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 15.0, HkGetSpellTargetLocation(), OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
	}
}
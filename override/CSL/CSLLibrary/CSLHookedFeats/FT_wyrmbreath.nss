//::///////////////////////////////////////////////
//:: Dragon Breath for Wyrmling Shape
//:: x2_s2_dragbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*
	Calculates the power of the dragon breath
	used by a player polymorphed into wyrmling
	shape

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: June, 17, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Polymorph"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	//--------------------------------------------------------------------------
	// Set up variables
	//--------------------------------------------------------------------------
	int nType = GetSpellId();
	int iDamageType;
	int nDamageDie;
	int nVfx;
	int iSave;
	int iSpellId;
	int iDice;


	//--------------------------------------------------------------------------
	// Decide on breath weapon type, vfx based on spell id
	//--------------------------------------------------------------------------
	switch (nType)
	{
			case 663: //white
				nDamageDie  = 4;
				iDamageType = DAMAGE_TYPE_COLD;
				nVfx        = VFX_IMP_FROST_S;
				iSave       = SAVING_THROW_TYPE_COLD;
				iSpellId      = SPELLABILITY_DRAGON_BREATH_COLD;
				iDice       = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /2)+1;
				break;

			case 664: //black
				nDamageDie  = 4;
				iDamageType = DAMAGE_TYPE_ACID;
				nVfx        = VFX_IMP_ACID_S;
				iSave       = SAVING_THROW_TYPE_ACID;
				iSpellId      = SPELLABILITY_DRAGON_BREATH_ACID;
				iDice       = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /2)+1;
				break;

			case 665: //red
				nDamageDie   = 10;
				iDamageType  = DAMAGE_TYPE_FIRE;
				nVfx         = VFX_IMP_FLAME_M;
				iSave        = SAVING_THROW_TYPE_FIRE;
				iSpellId       = SPELLABILITY_DRAGON_BREATH_FIRE;
				iDice        = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /3)+1;
				break;

			case 666: //green
				nDamageDie   = 6;
				iDamageType  = DAMAGE_TYPE_ACID;
				nVfx         = VFX_IMP_ACID_S;
				iSave        = SAVING_THROW_TYPE_ACID;
				iSpellId       = SPELLABILITY_DRAGON_BREATH_GAS;
				iDice        = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /2)+1;
				break;

			case 667: //blue
				nDamageDie   = 8;
				iDamageType  = DAMAGE_TYPE_ELECTRICAL;
				nVfx         = VFX_IMP_LIGHTNING_S;
				iSave        = SAVING_THROW_TYPE_ELECTRICITY;
				iSpellId       = SPELLABILITY_DRAGON_BREATH_LIGHTNING;
				iDice        = (GetLevelByClass(CLASS_TYPE_SHIFTER,OBJECT_SELF) /3)+1;
				break;

	}

	//--------------------------------------------------------------------------
	// Calculate Save DC based on shifter level
	//--------------------------------------------------------------------------
	int  iDC  = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_NORMAL);

	//--------------------------------------------------------------------------
	// Calculate Damage
	//--------------------------------------------------------------------------


	int iDamage = (Random(nDamageDie)+1)* iDice;

	int nDamStrike;
	float fDelay;
	object oTarget;
	effect eVis, eBreath;

	//--------------------------------------------------------------------------
	//Loop through all targets and do damage
	//--------------------------------------------------------------------------
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, HkGetSpellTargetLocation(), TRUE);
	while(GetIsObjectValid(oTarget))
	{
			if(oTarget != OBJECT_SELF && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
				fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
				nDamStrike =  HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC);
				if (nDamStrike > 0)
				{
					eBreath = EffectDamage(nDamStrike, iDamageType);
					eVis = EffectVisualEffect(nVfx);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, HkGetSpellTargetLocation(), TRUE);
	}
}
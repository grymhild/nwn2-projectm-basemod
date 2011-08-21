//::///////////////////////////////////////////////
//:: Circle of Death
//:: NW_S0_CircDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The caster slays a number of HD worth of creatures equal to 1d4 times level. The creature gets a Fort Save or dies.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_circledeath();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CIRCLE_OF_DEATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iImpactSEF = VFX_DUR_SPELL_BESTOW_CURSE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DEATH, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oLowest;
	effect eDeath = EffectDeath();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	int bContinueLoop = TRUE; //Used to determine if we have a next valid target
	int iHD = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower) ; //Roll to see how many HD worth of creature will be killed
	int nCurrentHD;
	int nMax = 10;
	float fDelay;
	string sIdentifier = "bDEATH" + ObjectToString(oCaster);
	location lLocation = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget;
	while (iHD>0 && bContinueLoop)
	{
		int nLow = nMax; //Set nLow to the lowest HD creature in the last pass through the loop
		bContinueLoop = FALSE; //Set this to false so that the loop only continues in the case of new low HD creature
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocation);
		while (GetIsObjectValid(oTarget))
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oCaster)
			{
				if (!GetLocalInt(oTarget, sIdentifier))
				{
					nCurrentHD = GetHitDice(oTarget);
					if (nCurrentHD<nLow && nCurrentHD<=iHD)
					{
						nLow = nCurrentHD;
						oLowest = oTarget;
						bContinueLoop = TRUE;
					}
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocation);
		}
		if (bContinueLoop)
		{
			SignalEvent(oLowest, EventSpellCastAt(oCaster, SPELL_CIRCLE_OF_DEATH, TRUE ));
			fDelay = CSLRandomBetweenFloat();
			if (!HkResistSpell(oCaster, oLowest, fDelay))
			{
				if (!HkSavingThrow(SAVING_THROW_FORT, oLowest, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, oCaster, fDelay))
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oLowest));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oLowest));
				}
			}
			CSLTimedFlag(oLowest, sIdentifier, fDelay + 0.25);
			iHD -= GetHitDice(oLowest);
			oLowest = OBJECT_INVALID;
		}
	}
	
	HkPostCast(oCaster);
}


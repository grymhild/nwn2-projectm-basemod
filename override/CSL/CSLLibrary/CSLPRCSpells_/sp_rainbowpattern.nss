/*
	sp_pattern

	Illusion (Pattern) [Mind-Affecting]
	Level: Brd 4, Sor/Wiz 4
	Components: V (Brd only), S, M, F; see text
	Casting Time: 1 standard action
	Range: Medium (100 ft. + 10 ft./level)
	Effect: Colorful lights with a 20-ft.-radius spread
	Duration: Concentration +1 round/ level (D)
	Saving Throw: Will negates
	Spell Resistance: Yes
	A glowing, rainbow-hued pattern of interweaving colors fascinates those within it. Rainbow pattern fascinates a maximum of 24 Hit Dice of creatures. Creatures with the fewest HD are affected first. Among creatures with equal HD, those who are closest to the spell's point of origin are affected first. An affected creature that fails its saves is fascinated by the pattern.
	With a simple gesture (a free action), you can make the rainbow pattern move up to 30 feet per round (moving its effective point of origin). All fascinated creatures follow the moving rainbow of light, trying to get or remain within the effect. Fascinated creatures who are restrained and removed from the pattern still try to follow it. If the pattern leads its subjects into a dangerous area each fascinated creature gets a second save. If the view of the lights is completely blocked creatures who can't see them are no longer affected.
	The spell does not affect sightless creatures.
	Verbal Component: A wizard or sorcerer need not utter a sound to cast this spell, but a bard must sing, play music, or recite a rhyme as a verbal component.
	Material Component: A piece of phosphor.
	Focus: A crystal prism.

	By: Flaming_Sword
	Created: Sept 29, 2006
	Modified: Sept 30, 2006
*/
//#include "prc_sp_func"

#include "_HkSpell"
#include "_CSLCore_ObjectArray"

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
	if ((--nBeatsRemaining == 0)  || !GetIsObjectValid(oTarget) || GetIsDead(oTarget) || !GetHasSpellEffect(nSpellID, oTarget) )
	{
		if(DEBUGGING) CSLDebug("sp_pattern: Spell expired, clearing");
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, nSpellID, oTarget );

	}
	else
		DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));
}

void ConcentrationHB(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
	if(GetBreakConcentrationCheck(oCaster))
	{
		//FloatingTextStringOnCreature("Crafting: Concentration lost!", oCaster);
		//DeleteLocalInt(oCaster, PRC_CRAFT_HB);
		//return;
		DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining);
	}
	else
		DelayCommand(6.0f, ConcentrationHB(oCaster, oTarget, nSpellID, nBeatsRemaining));
}
//#include "_HkSpell"




void main()
{	
	

	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RAINBOW_PATTERN; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	object oTarget;// = HkGetSpellTarget();
	location lLocation = HkGetSpellTargetLocation();
	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC = HkGetSpellSaveDC(oTarget, oCaster);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	effect eLink = EffectCharmed();
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

	int nMaxHD = 24;
	int nSumHD = 0;
	int nCount = 0;
	int i;
	string sPrefix = "PRC_PATTERN_";
	string sObj = sPrefix + "OBJECT_";
	string sHD = sPrefix + "HD_";
	string sDistance = sPrefix + "DISTANCE_";
	string sFlag = sPrefix + "FLAG_";
	if(CSLDataArray_ExistsEntire(oCaster, sObj)) CSLDataArray_DeleteEntire(oCaster, sPrefix + sObj);
	if(CSLDataArray_ExistsEntire(oCaster, sHD)) CSLDataArray_DeleteEntire(oCaster, sPrefix + sHD);
	if(CSLDataArray_ExistsEntire(oCaster, sDistance)) CSLDataArray_DeleteEntire(oCaster, sPrefix + sDistance);
	if(CSLDataArray_ExistsEntire(oCaster, sFlag)) CSLDataArray_DeleteEntire(oCaster, sPrefix + sFlag);
	array_create(oCaster, sObj);
	array_create(oCaster, sHD);
	array_create(oCaster, sDistance);
	array_create(oCaster, sFlag);
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocation, TRUE);
	HkApplyEffectAtLocation(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GLOW_YELLOW), lLocation);

	while(GetIsObjectValid(oTarget))
	{
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{ 	//fill arrays
			CSLDataArray_SetObject(oCaster, sObj, nCount, oTarget);
			CSLDataArray_SetInt(oCaster, sHD, nCount, GetHitDice(oTarget));
			CSLDataArray_SetFloat(oCaster, sDistance, nCount, GetDistanceBetweenLocations(lLocation, GetLocation(oTarget)));
			CSLDataArray_SetInt(oCaster, sFlag, nCount, 1);
			nCount++;
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocation, TRUE);
	}

	int nIndex;
	while(TRUE)
	{ 	//big risk here
		//nIndex = -1; //FIX nIndex RESET
	for(i = 0; i < CSLDataArray_LengthEntire(oCaster, sFlag); i++)
	{
		if(CSLDataArray_GetInt(oCaster, sFlag, i))
		{
			nIndex = i;
			break;
		}
	}
		for(i = 0; i < CSLDataArray_LengthEntire(oCaster, sFlag); i++)
		{ 	//search for target to affect
			if(i != nIndex && CSLDataArray_GetInt(oCaster, sFlag, i))
			{ 	//sort by HD
				if(CSLDataArray_GetInt(oCaster, sHD, i) < CSLDataArray_GetInt(oCaster, sHD, nIndex))
				{
				nIndex = i;
				}
				else if(CSLDataArray_GetInt(oCaster, sHD, i) == CSLDataArray_GetInt(oCaster, sHD, nIndex))
				{ 	//sort by distance
				if(CSLDataArray_GetFloat(oCaster, sDistance, i) < CSLDataArray_GetFloat(oCaster, sDistance, nIndex))
				{
					nIndex = i;
				}
				}
			}
		}
		oTarget = CSLDataArray_GetObject(oCaster, sObj, nIndex);
		CSLDataArray_SetInt(oCaster, sFlag, nIndex, 0);
		if(nSumHD + CSLDataArray_GetInt(oCaster, sHD, nIndex) > nMaxHD)
			break;
		else
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);
			nSumHD += CSLDataArray_GetInt(oCaster, sHD, nIndex);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
			ConcentrationHB(oCaster, oTarget, iSpellId, FloatToInt(fDuration));
		}
	}

	CSLDataArray_DeleteEntire(oCaster, sObj);
	CSLDataArray_DeleteEntire(oCaster, sHD);
	CSLDataArray_DeleteEntire(oCaster, sDistance);
	CSLDataArray_DeleteEntire(oCaster, sFlag);


	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
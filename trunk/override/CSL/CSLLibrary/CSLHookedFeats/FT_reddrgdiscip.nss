//::///////////////////////////////////////////////
//:: Breath Weapon for Dragon Disciple Class
//:: x2_s2_discbreath
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*
	Damage Type is Fire
	Save is Reflex
	Save DC = 20 + class level + Con modifier
	Shape is cone, 15' + 3' per Lvl ~= RADIUS_SIZE_COLOSSAL
	DamageDice = d8 per level
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"









void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nDragonDis = GetLocalInt(OBJECT_SELF, "DragonDisciple");	
	if (!GetHasFeat(FEAT_DRAGON_DIS_GENERAL, OBJECT_SELF))
	{
		FeatAdd(OBJECT_SELF, FEAT_DRAGON_DIS_GENERAL, FALSE);
		FeatAdd(OBJECT_SELF, FEAT_DRAGON_DIS_RED, FALSE);
		SetLocalInt(OBJECT_SELF, "DragonDisciple", 1);	
	}
	else // Has Feat
	{
		if (nDragonDis < 1)
		{
			SetupDragonDis();
			nDragonDis = GetLocalInt(OBJECT_SELF, "DragonDisciple");
		}
	}

	int nResistType = SAVING_THROW_TYPE_FIRE;
	int iDamageType = DAMAGE_TYPE_FIRE;
	int nHitEffect = VFX_HIT_SPELL_FIRE;
	int nConeEffect = VFX_DUR_CONE_FIRE;
	
	if (nDragonDis == 2)
	{
		iDamageType = DAMAGE_TYPE_ACID;
		nResistType = SAVING_THROW_TYPE_ACID;
		nHitEffect = VFX_HIT_SPELL_ACID;
		nConeEffect = VFX_DUR_CONE_ACID;
	}
	else
	if (nDragonDis == 3)
	{	
		iDamageType = DAMAGE_TYPE_ELECTRICAL;
		nResistType = SAVING_THROW_TYPE_ELECTRICITY;
		nHitEffect = VFX_HIT_SPELL_LIGHTNING;
		nConeEffect = VFX_DUR_CONE_LIGHTNING;
	}
	else
	if (nDragonDis == 4)
	{
		iDamageType = DAMAGE_TYPE_COLD;	
		nResistType = SAVING_THROW_TYPE_COLD;
		nHitEffect = VFX_HIT_SPELL_ICE;
		nConeEffect = VFX_DUR_CONE_ICE;
	}
	
	// SendMessageToPC(OBJECT_SELF, "Dragon Dis Type is " + IntToString(nDragonDis));
	
   
	
	// Determine breath damage
	int iLevel = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oCaster);
	
	int nDamageDice = iLevel; //CSLGetMax(1, iLevel/2);
	int iDamage;
	int iSaveDC = 13 + iLevel + GetAbilityModifier(ABILITY_CONSTITUTION, oCaster);
	float fRange = 5.0 + iLevel;
	float fDelay;
	float fMaxDelay = 0.0f; // Used to determine the duration of the flame cone
	effect eElemDamage;
	effect eVis = EffectVisualEffect(nHitEffect);   // Visual effect from taking damage from spell
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRange, HkGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) 
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
			fDelay = 2.0f + GetDistanceBetween(oCaster, oTarget)/20;
			fMaxDelay = CSLGetMaxf(fMaxDelay, fDelay);
			if (oTarget!=oCaster)
			{
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,d8(nDamageDice), oTarget, iSaveDC, nResistType);
				if (iDamage)
				{
					eElemDamage = EffectDamage(iDamage, iDamageType);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eElemDamage, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRange, HkGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
	}
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(nConeEffect), oCaster, fMaxDelay);
	
	HkPostCast(oCaster);
}
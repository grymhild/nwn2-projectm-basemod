//::///////////////////////////////////////////////
//:: Elemental Shot
//:: cmi_s2_elemshot
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: May 12, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"

void main()
{	
	// testing things DISABLED
	//return;
	// end testing
	
	//scSpellMetaData = SCMeta_FT_elemarchshot();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = ELEM_ARCHER_ELEM_SHOT;
	object oCaster = OBJECT_SELF;
	/*
	
	
	int iClass = CLASS_ELEM_ARCHER;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	*/
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int bHasEffects = GetHasSpellEffect(iSpellId, oCaster);		
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
	
	if (CSLGetIsHoldingRangedWeapon( oCaster ))
	{
		int nRaceBonus = 0;
		int iDamageType = DAMAGE_TYPE_PIERCING;
		int iLevel = GetLevelByClass(CLASS_ELEM_ARCHER, oCaster);
			
		if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_AIR))
		{
			if (GetSubRace(oCaster) == RACIAL_SUBTYPE_AIR_GENASI)
			{
				nRaceBonus = 2;
			}
			iDamageType = DAMAGE_TYPE_ELECTRICAL;
		}
		else
		if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_EARTH))
		{
			if (GetSubRace(oCaster) == RACIAL_SUBTYPE_EARTH_GENASI)
			{
				nRaceBonus = 2;
			}
			iDamageType = DAMAGE_TYPE_ACID;
		}
		else
		if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_FIRE))
		{
			if (GetSubRace(oCaster) == RACIAL_SUBTYPE_FIRE_GENASI)
			{
				nRaceBonus = 2;
			}
			iDamageType = DAMAGE_TYPE_FIRE;
		}
		else
		if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_WATER))
		{
			if (GetSubRace(oCaster) == RACIAL_SUBTYPE_WATER_GENASI)
			{
				nRaceBonus = 2;
			}
			iDamageType = DAMAGE_TYPE_COLD;
		}
		
		int nDAMAGE_BONUS = CSLGetDamageBonusConstantFromNumber(iLevel + nRaceBonus, TRUE);
		effect eLink = EffectDamageIncrease(nDAMAGE_BONUS, iDamageType);
		
		if (iLevel > 3)
		{
			effect eAB = EffectAttackIncrease(2);
			eLink = EffectLinkEffects(eAB, eLink);
		}
		else
		if (iLevel > 1)
		{
			effect eAB = EffectAttackIncrease(1);
			eLink = EffectLinkEffects(eAB, eLink);
		}
		
		eLink = SupernaturalEffect(eLink);
		eLink = SetEffectSpellId(eLink, iSpellId);
		
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCaster, 0.0f, iSpellId ) );
		
		if (!bHasEffects)
		{								
			SendMessageToPC(oCaster,"Elemental Shot enabled.");
		}
	}
	else if (bHasEffects)
	{
		SendMessageToPC(oCaster,"Elemental Shot disabled.  You must use a ranged or thrown weapon for this ability to work.");
		return;	
	}	

}
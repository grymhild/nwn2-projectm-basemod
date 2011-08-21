//::///////////////////////////////////////////////
//:: Elemental Manifestation
//:: cmi_s2_elemmanif
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: May 13, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
//#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_elemwar_mani();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_ELEMWAR_MANIFESTATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
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
	


		
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
	
	effect eLink;
	
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_AIR))
	{
		eLink = EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_EARTH))
	{	
		eLink =	EffectACIncrease(3, AC_NATURAL_BONUS);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_FIRE))
	{
		eLink = EffectDamageShield(0, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
	}
	else
	if (GetHasFeat(FEAT_ELEMWAR_AFFINITY_WATER))
	{
		eLink =	EffectDamageReduction(3, DAMAGE_TYPE_PIERCING, 0, DR_TYPE_DMGTYPE);
	}
		
    effect eDur = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);	
	eLink = EffectLinkEffects(eDur, eLink);	
	eLink = SupernaturalEffect(eLink);
	eLink = SetEffectSpellId(eLink, iSpellId);
		
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(10), iSpellId));
	
	HkPostCast(oCaster);		
}
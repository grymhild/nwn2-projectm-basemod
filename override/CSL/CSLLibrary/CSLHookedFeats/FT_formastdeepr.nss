
/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
//#include "x2_inc_spellhook" 

void bDidYouMove(int iSpellId, location MyLoc)
{
	location CurrentLoc = GetLocation(OBJECT_SELF);
	float fDist = GetDistanceBetweenLocations(CurrentLoc, MyLoc);
	if (fDist > 1.0f)
	{
		if (GetHasSpellEffect(iSpellId,OBJECT_SELF))
		{
			
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
	
		}	
	}
	else
	{
		DelayCommand(2.0f, bDidYouMove(iSpellId, MyLoc));
	}

}

void main()
{	
	//scSpellMetaData = SCMeta_FT_formastdeepr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = FOREST_MASTER_DEEP_ROOTS;
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
			
	
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_G);
	
	int nDexPenalty = GetAbilityScore(OBJECT_SELF, ABILITY_DEXTERITY) - 1;
		
    effect eRegen = EffectRegenerate(5, 6.0);
    effect eDur = EffectVisualEffect(VFX_DUR_REGENERATE);
	effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nDexPenalty);
    effect eLink = EffectLinkEffects(eRegen, eDur);
	eLink = EffectLinkEffects(eLink, eDex);
	
	location MyLoc = GetLocation(OBJECT_SELF);

    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
    DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, HkApplyDurationCategory(2, SC_DURCATEGORY_DAYS), iSpellId));
    DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF));
	
	DelayCommand(2.0f, bDidYouMove(iSpellId, MyLoc));
	
	HkPostCast(oCaster);
}
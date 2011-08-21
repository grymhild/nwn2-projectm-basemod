//::///////////////////////////////////////////////
//:: Righteous Fury
//:: cmi_s0_rightfury
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_rightfury();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Righteous_Fury;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId, SPELL_Strength_Stone  );
	
	int nHPBonus;	
	int iSpellPower = HkGetSpellPower( OBJECT_SELF, 10 );
	
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);	

	nHPBonus = iSpellPower * 5;
	
//	int nStrMod = GetAbilityModifier(ABILITY_STRENGTH, OBJECT_SELF);
//	nStrMod = nStrMod + 4;
	
	int nStrMod;
	int nBaseNum = GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, TRUE);
	int nModNum = GetAbilityScore(OBJECT_SELF,ABILITY_STRENGTH,FALSE);
	int nSubRace = GetSubRace(OBJECT_SELF);
	nBaseNum += CSLGetRaceDataStrAdjust(nSubRace);		
	
	nStrMod = (nModNum - nBaseNum);
	nStrMod = nStrMod + 4;
	if (nStrMod > 12)
	{
		nStrMod = 12;
	}
	
	effect eStrBonus = EffectAbilityIncrease(ABILITY_STRENGTH, nStrMod);
	
	
	//effect eAB = EffectAttackIncrease(2);
	//effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);	
	effect eHPBonus = EffectTemporaryHitpoints(nHPBonus);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	//effect eLink = EffectLinkEffects(eVis, eAB);
	//eLink = EffectLinkEffects(eLink, eDmg);
	effect eLink = EffectLinkEffects(eVis, eStrBonus);
	
	//effect eOnDispell1 = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() ));
	//effect eOnDispell2 = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() ));
	
		
	//eHPBonus = EffectLinkEffects(eHPBonus, eOnDispell1);    	
	
	//eLink = EffectLinkEffects(eLink, eStrBonus);
	//eLink = EffectLinkEffects(eLink, eOnDispell2);	
	
   

	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHPBonus, OBJECT_SELF, HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS), HkGetSpellId() );
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration, HkGetSpellId() );
	
	HkPostCast(oCaster);
}
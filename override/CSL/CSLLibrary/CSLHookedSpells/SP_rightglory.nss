//::///////////////////////////////////////////////
//:: Righteous Glory
//:: cmi_s0_rightglory
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 5, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_rightglory();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Righteous_Glory;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, GetSpellId() );
    	
//	int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
//	nChaMod = nChaMod + 4;
	
	int nChaMod;
	int nBaseNum = GetAbilityScore(OBJECT_SELF, ABILITY_CHARISMA, TRUE);
	int nModNum = GetAbilityScore(OBJECT_SELF,ABILITY_CHARISMA,FALSE);
	int nSubRace = GetSubRace(OBJECT_SELF);
	nBaseNum = nBaseNum + CSLGetRaceDataChaAdjust(nSubRace);
	
	nChaMod = (nModNum - nBaseNum);
	nChaMod = nChaMod + 4;
	if (nChaMod > 12)
		nChaMod = 12;	
	
	effect eChaBonus = EffectAbilityIncrease(ABILITY_CHARISMA, nChaMod);	
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_EAGLE_SPLENDOR );	
	effect eLink = EffectLinkEffects(eVis, eChaBonus);
		
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	float fDuration = TurnsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
			
    
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration, HkGetSpellId());
	
	HkPostCast(oCaster);
}      


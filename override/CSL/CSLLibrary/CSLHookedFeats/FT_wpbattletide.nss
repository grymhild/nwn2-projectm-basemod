//::///////////////////////////////////////////////
//:: Warpriest Battletide
//:: NW_S2_WPBattTide
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	You create an aura that steals energy from your
	enemies. Your enemies suffer a -2 circumstance
	penalty on saves, attack rolls, and damage rolls,
	once entering the aura. On casting, you gain a
	+2 circumstance bonus to your saves, attack rolls,
	and damage rolls.

	Warpriest's spell-like ability; main difference
	is that is uses the Warpriest level for variable
	effects.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Transmutation"





void main()
{
	//scSpellMetaData = SCMeta_FT_wpbattletide();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	int iDuration = CSLGetMax( GetLevelByClass(CLASS_TYPE_WARPRIEST) , HkGetSpellDuration(oCaster));
	
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);
	
	effect eLink = SCCreateGoodTideEffectsLink();
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_HASTE));
	eLink = EffectLinkEffects(eLink, EffectHaste());
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect(AOE_MOB_TIDE_OF_BATTLE, "", "", "", sAOETag);
	
	CSLUnstackSpellEffects(oCaster, SPELLABILITY_WARPRIEST_BATTLETIDE);
	CSLUnstackSpellEffects(oCaster, SPELL_BATTLETIDE, "Battletide");
	
	DelayCommand( 0.01f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration ) );
	DelayCommand( 0.02f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration ) );
	
	HkPostCast(oCaster);
}
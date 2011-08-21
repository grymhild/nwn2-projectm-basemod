//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTide
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	You create an aura that steals energy from your
	enemies. Your enemies suffer a -2 circumstance
	penalty on saves, attack rolls, and damage rolls,
	once entering the aura. On casting, you gain a
	+2 circumstance bonus to your saves, attack rolls,
	and damage rolls.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Transmutation"





void main()
{
	//scSpellMetaData = SCMeta_SP_battletide();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BATTLETIDE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iImpactSEF = VFX_HIT_AOE_TRANSMUTATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds( HkGetSpellDuration(oCaster) ) );
	effect eLink = SCCreateGoodTideEffectsLink();
	//eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_HASTE));
	eLink = EffectLinkEffects(eLink, EffectHaste() );
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectLinkEffects(EffectAreaOfEffect(AOE_MOB_TIDE_OF_BATTLE, "", "", "", sAOETag), eLink);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	
	CSLUnstackSpellEffects(oCaster, SPELL_BATTLETIDE);
	CSLUnstackSpellEffects(oCaster, SPELLABILITY_WARPRIEST_BATTLETIDE, "Battletide");
	
	DelayCommand( 0.01f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration) );
	
	HkPostCast(oCaster);
}


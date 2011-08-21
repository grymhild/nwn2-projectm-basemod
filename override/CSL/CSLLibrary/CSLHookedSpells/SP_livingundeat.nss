//::///////////////////////////////////////////////
//:: Living Undeath
//:: cmi_s0_livundeath
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 22, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_livingundeat();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Living_Undeath;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
// -DATA- // int iAttributes =115104;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EVIL, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	object oTarget = HkGetSpellTarget();
	
	if ( GetHasSpellEffect(SPELL_DEATH_WARD, oTarget) )
	{
		CSLPlayerMessageSplit( "Death ward blocks casting of Living Undeath", oCaster, oTarget );
		return;
	}
	
	int nCurScore = GetAbilityScore(oTarget, ABILITY_CHARISMA);
	int nDecrease = 0;
	if ( ( nCurScore > 4 ) )
	{
		nDecrease = 4;
	}
	else if ( ( nCurScore == 4 ) )
	{
		nDecrease = 3;
	}
	else if ( ( nCurScore == 3 ) )
	{
		nDecrease = 2;
	}
	else if ( ( nCurScore == 2 ) )
	{
		nDecrease = 1;
	}
	
	
	effect eLink = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	if ( nDecrease > 0 )
	{
		eLink = EffectLinkEffects( eLink, EffectAbilityDecrease(ABILITY_CHARISMA,nDecrease) );
	}
	eLink = EffectLinkEffects( eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK) );
	//effect eLink = EffectLinkEffects( eLink, EffectVisualEffect(VFX_DUR_SPELL_PREMONITION) );
	eLink = EffectLinkEffects( eLink, EffectVisualEffect(VFX_DUR_SPELL_LIVING_UNDEATH) );
	effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_LIVING_UNDEATH);
	/*
	
	effect eImmuneSA = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eImmuneCH = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	effect eDecreaseChar = EffectAbilityDecrease(ABILITY_CHARISMA, nDecrease);
	effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_LIVING_UNDEATH);
	effect eFrame = EffectVisualEffect(VFX_DUR_SPELL_LIVING_UNDEATH);
	effect eLink = EffectLinkEffects(eImmuneSA, eImmuneCH);
	eLink = EffectLinkEffects(eLink, eDecreaseChar);
	eLink = EffectLinkEffects(eLink, eFrame);
	*/
	
	
	
	
	
	//int iSpellPower = HkGetSpellPower(OBJECT_SELF);
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() );	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, GetSpellId() );
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
	
	HkPostCast(oCaster);
}


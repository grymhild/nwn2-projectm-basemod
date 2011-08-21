//::///////////////////////////////////////////////
//:: Achille's Heel
//:: tm_s0_epachilles.nss
//:://////////////////////////////////////////////
/*
	Grants the caster immunity to all spells level 9 and lower
	at the price of CON: dropping to 3.
*/
//:://////////////////////////////////////////////
//:: Created By: Nron Ksr
//:: Created On: March 9, 2004
//:://////////////////////////////////////////////

/*
	March 17, 2004- Boneshank - added RunHeel() func to keep CON penalty
*/
//#include "prc_alterations"
//#include "_SCInclude_Epic"
//#include "inc_dispel"
//#include "x2_inc_spellhook"

void RunHeel(object oTarget, int nDuration);


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_ACHHEEL;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ACHHEEL))
	{
		
		object oPC = OBJECT_SELF;
		effect eVis = EffectVisualEffect( VFX_DUR_SPELLTURNING );
		effect eVis2 = EffectVisualEffect( VFX_DUR_GLOBE_INVULNERABILITY );
		effect eDur = EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE );
		int nDuration = 20;

		//Link Effects
	// 	effect eAbsorb = EffectSpellLevelAbsortption( 9, 0, SPELL_SCHOOL_NONE );
		effect eAbsorb = EffectSpellImmunity( SPELL_ALL_SPELLS );
		effect eLink = EffectLinkEffects( eVis, eAbsorb );
		eLink = EffectLinkEffects( eLink, eVis2 );
		eLink = EffectLinkEffects( eLink, eDur );

		//Fire cast spell at event for the specified target
	// 	SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellID(), FALSE) );
		SignalEvent(oPC,
			EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_SPELL_MANTLE, FALSE));
		//Apply the VFX impact and effects

		// * Can not be dispelled
		eLink = ExtraordinaryEffect(eLink);

		HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(nDuration) );
		RunHeel(oPC, nDuration);
	}

	HkPostCast(oCaster);
}

void RunHeel(object oTarget, int nDuration)
{
	int nPen = GetAbilityScore(oTarget, ABILITY_CONSTITUTION) - 3;
	effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, nPen);
	if (nDuration > 0)
	{
		UnequipAnyImmunityItems(oTarget, IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
		DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCon, oTarget, 6.0f));
		nDuration -= 1;
		DelayCommand(6.0, RunHeel(oTarget, nDuration));
	}
}
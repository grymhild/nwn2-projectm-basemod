//::///////////////////////////////////////////////
//:: Healing Sting
//:: nx2_s0_healing_sting.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Healing Sting
	Necromancy
	Level: Druid 2
	Components: V, S
	Range: Touch
	Targets: You and one living creature
	Saving Throw: None
	Spell Resistance: Yes
	
	Focusing the power of negative energy, you deal 1d12 points of damage +1 per caster level
	(maximum 1d12+10) to a living creature and gain and equal amount of hit points if you make a successful melee touch attack.
	A healing sting cannot give you more hit points than your full normal total.
	Excess hit points are lost.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


//#include "x0_i0_match"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_HEALING_STING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	
	// Caster level
	int iSpellPower = HkGetSpellPower( oCaster, 10 ); // OldGetCasterLevel(oCaster);
	
	// Effects
	int iDamage = d12(1) + iSpellPower;
	iDamage = HkApplyMetamagicVariableMods( d12()+iSpellPower, 12+iSpellPower);
	int nHeal = iDamage;
	int nMaxHP = GetMaxHitPoints(oCaster);
	int nCurrentHP = GetCurrentHitPoints(oCaster);
	if(nHeal + nCurrentHP > nMaxHP)
	{
		nHeal = nMaxHP - nCurrentHP;
	}

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_HEALING_STING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	
	effect eDamage = HkEffectDamage(iDamage, iDamageType);
	effect eHeal = EffectHeal(nHeal);
	effect eVisual = EffectVisualEffect(iHitEffect);
	effect eVisual2 = EffectVisualEffect(VFX_HEAL_SPELL_HEALING_STING);
	effect eLink = EffectLinkEffects(eVisual, eDamage);
	effect eLink2 = EffectLinkEffects(eVisual2, eHeal);
	
	// Make sure spell target is valid and living
	if ( GetIsObjectValid(oTarget) && CSLGetIsBloodBased(oTarget) )
	{
		// check to see if hostile
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oCaster);
				//Fire cast spell at event for the specified target
			}
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
		}
	}
	
	HkPostCast(oCaster);
}


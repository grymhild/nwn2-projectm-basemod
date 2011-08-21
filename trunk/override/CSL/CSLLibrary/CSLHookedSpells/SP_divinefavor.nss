//::///////////////////////////////////////////////
//:: Divine Favor
//:: x0_s0_divfav.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
+1 bonus to attack and damage for every three
caster levels (+1 to max +3)
Duration: 1 turn
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:


// JLR - OEI 08/24/05 -- Metamagic changes
// JSH-OEI 8/15/07 - Reduced maximum bonus to +3.


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_divinefavor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DIVINE_FAVOR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget;
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_DIVINE_FAVOR);
	
	int nScale = HkCapAB( HkGetSpellPower( OBJECT_SELF, 10 ) / 3 ); // to give a maximum of +3
	// * must fall between +1 and +5
	
	//nScale = ( nScale );
	/*
	if (nScale < 1)
			nScale = 1;
	else
	if (nScale > 3)
			nScale = 3;
	*/
	// * determine the damage bonus to apply
	effect eAttack = EffectAttackIncrease(nScale);
	effect eDamage = EffectDamageIncrease(nScale, DAMAGE_TYPE_MAGICAL );
	effect eLink = EffectLinkEffects(eAttack, eDamage);
	eLink = EffectLinkEffects(eLink, eVis);

	float fDuration = TurnsToSeconds(1); // * Duration 1 turn
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	oTarget = OBJECT_SELF;
	
	//Fire spell cast at event for target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 414, FALSE));

	//Apply VFX impact and bonus effects
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}


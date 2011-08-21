//::///////////////////////////////////////////////
//:: Truestrike
//:: x0_s0_truestrike.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
+20 attack bonus for 9 seconds.
CHANGE: Miss chance still applies, unlike rules.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////

#include "_HkSpell"



void main()
{	
	//scSpellMetaData = SCMeta_SP_truestrike();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TRUE_STRIKE;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_ASN_True_Strike )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_DIVINATION);


	// * determine the damage bonus to apply
	effect eAttack = EffectAttackIncrease(20);
	
	//Fire spell cast at event for target
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 415, FALSE));
	//Apply VFX impact and bonus effects
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, OBJECT_SELF, 9.0, 415);
	
	HkPostCast(oCaster);
}


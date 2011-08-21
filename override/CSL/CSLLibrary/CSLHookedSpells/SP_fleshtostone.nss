//::///////////////////////////////////////////////
//:: Flesh to Stone
//:: x0_s0_fleshsto
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: October 16, 2002
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Transmutation"

void main()
{
	//scSpellMetaData = SCMeta_SP_fleshtostone();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FLESH_TO_STONE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iSpellPower = HkGetSpellPower( oCaster, 60 ); // OldGetCasterLevel(OBJECT_SELF);
	
	if ( !HkResistSpell( oCaster, oTarget) )
	{
		SCDoPetrification(iSpellPower, oCaster, oTarget, iSpellId, HkGetSpellSaveDC());
		//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION); // VFX are handled in SCDoPetrification()
		//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	}
	//SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)));
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE)); // makes target hostile upon use of this spell
	
	HkPostCast(oCaster);
}
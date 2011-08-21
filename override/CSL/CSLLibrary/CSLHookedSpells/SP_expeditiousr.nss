//::///////////////////////////////////////////////
//:: Expeditious retreat
//:: x0_s0_exretreat.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Increases movement rate to the max, allowing
 the spell-caster to flee.
 Also gives + 2 AC bonus
*/
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



//#include "_inc_propertystrings"
#include "_SCInclude_Transmutation"


void main()
{
	//scSpellMetaData = SCMeta_SP_expeditiousr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EXPEDITIOUS_RETREAT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
	object oTarget = HkGetSpellTarget();
	if (DEBUGGING >= 4) { CSLDebug(  "SP_Expeditousr: Caster = "+GetName( oCaster )+" Target = "+GetName( oTarget )+" Spell="+IntToString( iSpellId ), oCaster ); }
	
	if ( CSLGetHasEffectSpellIdGroup( oTarget, SPELL_HASTE, SPELL_MASS_HASTE ) ) return ; // does nothing if caster already has haste
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	//effect eDur = EffectVisualEffect( VFX_DUR_SPELL_EXPEDITIOUS_RETREAT );  // NWN2 VFX
	//effect eFast = EffectMovementSpeedIncrease(150);
	//effect eLink = EffectLinkEffects(eFast, eDur);
	
	float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds( HkGetSpellDuration( oCaster ) ));
	int iDurType = HkApplyMetamagicDurationTypeMods( DURATION_TYPE_TEMPORARY );
	
	// BABA YAGA DURATION EDIT
	//if (CSLStringStartsWith(GetTag(oCaster),"BABA_")) fDuration = HoursToSeconds(24);
	//SignalEvent(oTarget, EventSpellCastAt(oCaster, 455, FALSE));
	//HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, 455);
	
	SCApplyHasteEffect( oTarget, oCaster, SPELL_EXPEDITIOUS_RETREAT, fDuration, iDurType );
	
	HkPostCast(oCaster);	
}

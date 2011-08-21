//::///////////////////////////////////////////////
//:: x0_s3_butter
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
For Wand of Wonder
creates butterflies
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
//#include "x0_i0_spells"
// Do a blindness spell on all in the given radius of a cone for the given
// number of rounds in duration.

#include "_HkSpell"

void DoButterflyCone(object oCaster, location lTarget, float fRadius, int nDuration)
{
	int nMetaMagic = HkGetMetaMagicFeat();
	vector vOrigin = GetPosition(oCaster);
	float fDelay;
	float fMaxDelay = 0.0f; // Used to determine the duration of the flame cone
	
	///SendMessageToPC( oCaster, "InsideButterflyCone"); 
	if (DEBUGGING >= 4) { CSLDebug(  "DoButterflyCone1: Doing Cone Effect Now"+FloatToString( fMaxDelay ), oCaster ); }	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFXSC_DUR_SPELLCONEHAND_BUTTERFLIES), oCaster, fMaxDelay+0.5);

	effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	// 	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eDur = EffectVisualEffect( VFXSC_DUR_SPELL_BLIND_BUTTERFLIES );
	effect eLink = EffectBlindness();
	eLink = EffectLinkEffects(eLink, eDur);
			
	object oTarget = GetFirstObjectInShape(SHAPE_CONE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DECK_BUTTERFLYSPRAY, TRUE ));
		fDelay = 2.0f + GetDistanceBetween(oCaster, oTarget)/20;
		fMaxDelay = CSLGetMaxf(fMaxDelay, fDelay);
		
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Do SR check
			// 	if ( !HkResistSpell(OBJECT_SELF, oTarget)) {
			if( oTarget != oCaster && !HkResistSpell(OBJECT_SELF, oTarget)) //FIX: prevents caster from getting SR check against himself
			{
				// Make Fortitude save to negate
				if (! HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
				{
					
					float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds( HkApplyMetamagicVariableMods(d4(), 4) ) );
					int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
					
					//Apply visual and effects
					DelayCommand(fDelay, HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_DECK_BUTTERFLYSPRAY ) );
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget ) );
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_CONE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
	}
	
	if (DEBUGGING >= 4) { CSLDebug(  "DoButterflyCone: Doing Cone Effect Now"+FloatToString( fMaxDelay ), oCaster ); }	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFXSC_DUR_SPELLCONEHAND_BUTTERFLIES), oCaster, fMaxDelay+0.5);

		//fMaxDelay += 0.5f;
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFXSC_DUR_SPELLCONEHAND_BUTTERFLIES), oCaster, fMaxDelay);
	//if ( d6() > 3 )
	//{
	//	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CONE_ICE), oCaster, fMaxDelay+0.5);
	//}
}

void main ()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DECK_BUTTERFLYSPRAY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//SendMessageToPC( oCaster, "Pre ButterflyCone"); 
	DoButterflyCone(oCaster, HkGetSpellTargetLocation(), 11.0, d4()); // originally 20 metres
	//SendMessageToPC( oCaster, "Post ButterflyCone"); 
	HkPostCast(oCaster);
}
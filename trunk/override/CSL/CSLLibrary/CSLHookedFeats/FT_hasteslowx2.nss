  //::///////////////////////////////////////////////
//:: Haste or Slow
//:: x2_s0_HasteSlow.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	2/3rds of the time, Gives the targeted creature one extra partial
	action per round.
	1/3 of the time, Character can take only one partial action
	per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 3/03
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Transmutation"

void main()
{
	//scSpellMetaData = SCMeta_FT_hasteslowx2();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	

	if (d100() > 33)
	{// 2/3 of the time - do haste effect
	//Declare major variables
			object oTarget = HkGetSpellTarget();
			//effect eHaste = EffectHaste();
			effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
			//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
			//effect eLink = EffectLinkEffects(eHaste, eDur);

			int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);

			//Fire cast spell at event for the specified target
			//SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HASTE, FALSE));
			
			//int iDurType = DURATION_TYPE_TEMPORARY;
			//SCApplyHasteEffect( oPC, oPC, SPELL_HASTE, fDuration, iDurType );
			SCApplyHasteEffect( oTarget, oCaster, SPELL_HASTE, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS), DURATION_TYPE_TEMPORARY );
			// Apply effects to the currently selected target.
			//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
			HkApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	else
	{//1/3 of the time - do slow effect
	
			//Declare major variables
			object oTarget1 = HkGetSpellTarget();
			effect eSlow = EffectSlow();
			effect eDur1 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
			effect eLink1 = EffectLinkEffects(eSlow, eDur1);

			effect eVis1 = EffectVisualEffect(VFX_IMP_SLOW);
			effect eImpact1 = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);

			//Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
			int nDuration1 = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);

			//Fire cast spell at event for the specified target
			SignalEvent(oTarget1, EventSpellCastAt(OBJECT_SELF, SPELL_SLOW, FALSE));
			// Apply effects to the currently selected target.
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget1, RoundsToSeconds(nDuration1));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget1);


	}
	
	HkPostCast(oCaster);
}
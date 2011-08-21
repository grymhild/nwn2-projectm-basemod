//:://///////////////////////////////////////////////
//:: Warlock Dark Invocation: Retributive Invisibility
//:: nw_s0_iretinvis.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 12/08/05
//::////////////////////////////////////////////////
/*

		Retributive Invisibility   Complete Arcane, pg. 135
		Spell Level:          6
		Class:                  Misc

		The warlock can use the greater invisibility spell (5th level wizard)
		but only himself at the target. If the invocation is dispelled, a
		shockwave releases from your body (the visual equivalent of an
		eldritch doom blast centered on the player) that does 4d6 damage in
		a 20' radius burst and stuns all enemies for one round. A Fortitude
		save halves the damage and eliminates the stun effect.

		Target creature can attack and cast spells while
		invisible
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Invocations"
#include "_SCInclude_Invisibility"
/*
void OnDispellCallback(object oCaster, int iSaveDC) {

	if (!GetIsObjectValid(oCaster)) return;
	location lTarget = GetLocation(oCaster);
	float fDistToDelay = 0.25f;
	int nDamageAmt;
	float fDelay;
	float fDuration = 2.0 + HkGetWarlockBonus(oCaster);

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_INVOCATION_ELDRITCH_AOE), lTarget);

	effect eStun = EffectVisualEffect(VFX_DUR_STUN);
	eStun = EffectLinkEffects(eStun, EffectStunned());
	eStun = EffectLinkEffects(eStun, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oCaster) {
			nDamageAmt = GetEldritchBlastDmg(oCaster, oTarget, FALSE, TRUE, FALSE);
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget)) * fDistToDelay ;
			int nSaveResult = FortitudeSave(oTarget, iSaveDC, SAVING_THROW_TYPE_NONE, oCaster);
			if (nSaveResult==SAVING_THROW_CHECK_FAILED) { // saving throw failed
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fDuration));
			} else if (nSaveResult==SAVING_THROW_CHECK_SUCCEEDED) { // Saving throw successful
				nDamageAmt /= 2; // halve the damage
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_SONIC), oTarget));
			} else {
				nDamageAmt = 0;
			}
			if (nDamageAmt) {
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamageAmt, DAMAGE_TYPE_SONIC), oTarget));
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}
*/

void main()
{
	/*
	if ( GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, HkGetSpellTarget() ))
	{
		// Cannot be cast when in a purge AOE
	SendMessageToPC(OBJECT_SELF, "Invisibility was Purged");
		return;
	}
	*/
	
	//scSpellMetaData = SCMeta_IN_retributivei();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_RETRIBUTIVE_INVISIBILITY;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory( HkGetSpellDuration( oCaster ), SC_DURCATEGORY_ROUNDS) );
	// SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	SCApplyInvisibility( OBJECT_SELF, OBJECT_SELF, fDuration, SPELL_I_RETRIBUTIVE_INVISIBILITY, 50 );
	
	/*
	
	int iSaveDC = GetInvocationSaveDC(oCaster); //GetSpellSaveDC();
	effect eLink = EffectInvisibility(INVISIBILITY_TYPE_IMPROVED);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_INVISIBILITY));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_INVOCATION_RETRIBUTIVE_INVISIBILITY));
	eLink = EffectLinkEffects(eLink, EffectConcealment(50));
	eLink = EffectLinkEffects(eLink, EffectOnDispel(0.5f, OnDispellCallback(oCaster, iSaveDC)));
	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, 18.0);
	*/
	
	HkPostCast(oCaster);
}
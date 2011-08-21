///::///////////////////////////////////////////////
//:: Improved Invisibility
//:: NW_S0_ImprInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target creature can attack and cast spells while
	invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Invisibility"

//const float F_DELAY = 10.0f;

/*
void ReapplyIfCanceled(object oTarget, float fDuration) {
	float fDurationLeft = fDuration - F_DELAY;
	if (fDurationLeft < F_DELAY) return; // we be done - duration has expired
	if (GetIsInCombat(oTarget) || GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, HkGetSpellTarget() ) ) { // check again later
		DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft));
		return;
	}
	// check for both concealment (doesn't get canceled by anything but resting/dispel) and for invis effect
	effect eEffectLoop = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffectLoop)) {
		if (GetEffectType(eEffectLoop) == INVISIBILITY_TYPE_NORMAL) {     // if we find invis, we don't need to do anything yet
			DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft));
			return;
		}
		// if we find concealment, and it was applied by impr invis, we know the spell is still active
		if (GetEffectType(eEffectLoop)==EFFECT_TYPE_CONCEALMENT) {
			if (GetEffectSpellId(eEffectLoop)==SPELLABILITY_AS_GREATER_INVISIBLITY) {
				effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
				effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELLABILITY_AS_GREATER_INVISIBLITY));
				eInvis = EffectLinkEffects(eInvis, eOnDispell);
				eInvis = SetEffectSpellId(eInvis, SPELLABILITY_AS_GREATER_INVISIBLITY);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDurationLeft);
				DelayCommand(F_DELAY, ReapplyIfCanceled(oTarget, fDurationLeft)); // check again later
				return;
			}
		}
		eEffectLoop = GetNextEffect(oTarget);
	}
}
*/

void main()
{
	//scSpellMetaData = SCMeta_SP_ImpInvisibil();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	if (GetSpellId() == SPELLABILITY_AS_GREATER_INVISIBLITY)
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_GLAMER, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	object oTarget = HkGetSpellTarget();
	
	// int iCasterLevel = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	float fDuration;
	
	
	fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster, iClass ) ));
	
	
	/*
	effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
	effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELLABILITY_AS_GREATER_INVISIBLITY));
	effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	eLink = EffectLinkEffects(eLink, EffectConcealment(50));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_INVISIBILITY));
	eLink = EffectLinkEffects(eLink, eOnDispell);
	eInvis = EffectLinkEffects(eInvis, eOnDispell);
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ILLUSION), oTarget);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink,  oTarget, fDuration);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, fDuration);
	*/
	SCApplyInvisibility( oTarget, oCaster, fDuration, SPELLABILITY_AS_GREATER_INVISIBLITY, 50 );
	
	float fDurationLeft = fDuration - F_DELAY;
	DelayCommand(F_DELAY, SCReapplyCanceledInvisibility(oTarget, fDurationLeft, SPELLABILITY_AS_GREATER_INVISIBLITY));
	
	HkPostCast(oCaster);
}


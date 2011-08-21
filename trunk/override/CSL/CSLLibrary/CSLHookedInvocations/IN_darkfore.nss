//::///////////////////////////////////////////////
//:: Dark Foresight
//:: cmi_s0_darkfore
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:: Dark Foresight
//:: Invocation Type: Dark
//:: Spell Level Equivalent: 9
//:: Your dark powers allow you to foresee flashes of the future, granting you
//:: +2 Dodge AC, +2 Reflex AC, and Immunity to Sneak Attacks for 10 minutes per
//:: warlock level. This invocation can only be used on one target at a time.
//:://////////////////////////////////////////////
//const int SPELL_I_DARK_FORESIGHT = 2069;


#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_DARK_FORESIGHT;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	object oTarget = HkGetSpellTarget();
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) ); // SC_DURCATEGORY_MINUTES SC_DURCATEGORY_HOURS SC_DURCATEGORY_DAYS 
	
	object oLastTarget = GetLocalObject(oCaster, "LastDarkForeTgt");
	if (GetIsObjectValid(oLastTarget) )
	{
		int bHasEffect = CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oLastTarget, iSpellId );
		if ( bHasEffect && (oLastTarget != oCaster))
		{
			SendMessageToPC(oLastTarget, "Your Dark Foresight has been given to another.");
		}
	}
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	
	effect eAC = EffectACIncrease(2);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2);
	effect eImm = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_PREMONITION );	// NWN2 VFX
	effect eLink = EffectLinkEffects(eAC, eSave);
	eLink = EffectLinkEffects(eLink, eImm);
	eLink = EffectLinkEffects(eLink, eVis);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));

	//Apply the linked effect
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId );
	SetLocalObject(oCaster, "LastDarkForeTgt", oTarget);
	
	HkPostCast(oCaster);
}
//::///////////////////////////////////////////////
//:: Frightful Presence
//:: cmi_s0_frightpres
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 10, 2010
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Frightful Presence
//:: Invocation Type: Lesser;
//:: Spell Level Equivalent: 3
//:: Any enemies within 30 feet of you who fail a Will save become shaken for 10
//:: minutes. This is a mind-affecting fear effect. The shaken effect applies a
//:: -2 penalty to attack bonus, skills, and damage.
//:://////////////////////////////////////////////
//const int SPELL_I_FRIGHTFUL_PRESENCE = 2090;


#include "_HkSpell"
#include "_SCInclude_Invocations"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_FRIGHTFUL_PRESENCE;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(10, SC_DURCATEGORY_MINUTES) );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	float fDelay;

	location lLocation = HkGetSpellTargetLocation();

	effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2, SAVING_THROW_TYPE_MIND_SPELLS);
	effect eDamagePenalty = EffectDamageDecrease(2);
	effect eAttackPenalty = EffectAttackDecrease(2);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FEAR );

	effect eLink = EffectLinkEffects(eSave, eDamagePenalty);
	eLink = EffectLinkEffects(eLink, eAttackPenalty);
	eLink = EffectLinkEffects(eLink, eVis);
	eLink = SetEffectSpellId(eLink, iSpellId); //needed to keep different essences stack, if using same shape


	object oTarget;
	//Get first target in the spell cone
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
			fDelay = CSLRandomBetweenFloat();
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
			//Make SR Check
			if(!HkResistSpell(oCaster, oTarget, fDelay))
			{
				//Make a will save
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oCaster, TRUE), SAVING_THROW_TYPE_FEAR, oCaster, fDelay))
				{
				//Apply the linked effects and the VFX impact
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				}
			}
		}
		//Get next target in the spell
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocation, TRUE, OBJECT_TYPE_CREATURE);
	}
	HkPostCast(oCaster);
}
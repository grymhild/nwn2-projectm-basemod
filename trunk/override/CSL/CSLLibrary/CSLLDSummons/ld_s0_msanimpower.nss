// ld_s0_mechmind.nss
//
// Mechanus Mind
//
//
//
//#include "ld_ginc_spells"
//#include "x2_inc_spellhook"
//#include "x2_i0_spells"




#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
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
	
	location lTarget = HkGetSpellTargetLocation();
		//object oTarget = JXGetSpellTargetObject();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	//effect eWill = EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS);

	effect eSTR = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	effect eCON = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
	effect eDEX = EffectAbilityIncrease(ABILITY_DEXTERITY, 2);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId ) );


	effect eLink = EffectLinkEffects(eOnDispell, eSTR);
	eLink = EffectLinkEffects(eLink, eCON);
	eLink = EffectLinkEffects(eLink, eVis);
	eLink = EffectLinkEffects(eLink, eDEX);


	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	float fDuration = RoundsToSeconds( nCasterLvl );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	/*SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, JXGetSpellId(), FALSE));
	JXApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);*/
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 4037, FALSE));

			//Apply the bonus effect and VFX impact
			if (GetHasSpellEffect(4036, oTarget) || GetHasSpellEffect(4037, oTarget))// Spell 4036 is Animalistic Power in Spells.2da. 4037 is Mass Animalistic Power.
			{
			FloatingTextStringOnCreature("You can't stack Animalistic Power", OBJECT_SELF);
			}
			if (!GetHasSpellEffect(4036, oTarget) && !GetHasSpellEffect(4037, oTarget))
			{
				HkApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
			}

	}
	oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}
//::///////////////////////////////////////////////
//:: Bless
//:: NW_S0_Bless.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	http://www.d20srd.org/srd/spells/bless.htm
	
	Enchantment (Compulsion) [Mind-Affecting]
	Level:	Clr 1, Pal 1
	Components:	V, S, DF
	Casting Time:	1 standard action
	Range:	50 ft.
	Area:	The caster and all allies within a 50-ft. burst, centered on the caster
	Duration:	1 min./level
	Saving Throw:	None
	Spell Resistance:	Yes (harmless)
	
	All allies within 30ft of the caster gain a
	+1 attack bonus and a +1 save bonus vs fear
	effects
	
	Bless fills your allies with courage. Each ally gains a +1 morale bonus on attack rolls and on saving throws against fear effects.
	Bless counters and dispels bane.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BLESS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFXSC_HIT_AOE_BLESS;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	//float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(1 + HkGetSpellDuration(oCaster) ));
	//int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES ) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_BLESS);
	eLink = EffectLinkEffects(eLink, EffectAttackIncrease(1));
	eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR));
	
	location lLoc = HkGetSpellTargetLocation();
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);	
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_BANE);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			DelayCommand(CSLRandomBetweenFloat(0.4, 1.1), HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration));
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
	}
	
	HkPostCast(oCaster);
}


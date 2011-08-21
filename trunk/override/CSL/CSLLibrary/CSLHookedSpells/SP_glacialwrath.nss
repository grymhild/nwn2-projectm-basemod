//::///////////////////////////////////////////////
//:: Burst of Glacial Wrath
//:: NX_s0_glacial.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Burst of Glacial Wrath
	Evocation Level: Sorceror/Wizard 9
	Components: V, S
	Range: Medium
	Area: Cone Shaped Burst
	Duration: See Text
	Saving Throw: Fortitude half Spell
	Resistance: Yes
	
	You create a burst of icy energy that flash-
	freezes any creatures within the spell's area.
	The spell deals 1d6 points of cold damager per
	caster level (maximum 25d6 points). Any living
	creature reduced to 10 hit points or lower is
	encased in ice for 1 round/ two caster levels
	(max 10 rounds). Creatures turned to ice in
	this fashion gain DR 10/fire and immunity to
	cold and electricity.
	
	NOTE: Numerous changes were made to this spell.
	This spell is now evocation only, rather than
	evocation/transmutation. Creatures turned to
	ice eventually thaw out. vulnurability to fire
	and hardness 10 is replaced with DR 10/fire.
	Negative hitpoints rules are ignored and reversed.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void FreezeDamage(int nDam, int iDamageType, effect eFreeze, object oTarget, float fDuration)
{
	//int nDmgType = DAMAGE_TYPE_COLD;	
	//if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD))
	//{
	//	nDmgType = DAMAGE_TYPE_MAGICAL;
	//}
	
	int bPlotImmortal = GetImmortal(oTarget);
	SetImmortal(oTarget, TRUE); //spell should never kill creatures
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, iDamageType), oTarget);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect( CSLGetHitEffectByDamageType(iDamageType) ), oTarget, fDuration);
	if (!bPlotImmortal) SetImmortal(oTarget, FALSE); //remove immortality only from targets that were not immortal before spell is cast
	if (GetCurrentHitPoints(oTarget)<= 10) HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oTarget, fDuration);
}

void main()
{
	//scSpellMetaData = SCMeta_SP_glacialwrath();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GLACIAL_WRATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	int iCasterLevel = CSLGetMin(25, HkGetSpellPower(oCaster));
	int nDam;
	float fDist;
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(CSLGetMin(10, HkGetSpellDuration( oCaster )/2)));
	
	
	
	
	//COLD
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_CONE_ICE, SC_SHAPE_SPELLCONE ); 
	int iImpactEffect = HkGetShapeEffect( VFX_HIT_AOE_ICE, SC_SHAPE_AOE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eLink = EffectVisualEffect(iHitEffect);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_GLACIAL_WRATH));
	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_COLD, 9999,0));
	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999,0));
	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999,0));
	eLink = EffectLinkEffects(eLink, EffectDamageReduction(10, 0, 0, DR_TYPE_NONE));
	eLink = EffectLinkEffects(eLink, EffectPetrify());
	
	//int iSaveType = iSaveType;	
	//if (GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD))
	//{
	//	iSaveType = SAVING_THROW_TYPE_ALL;
	//}
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	location lLocation = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 15.0, lLocation, FALSE);
	while (GetIsObjectValid(oTarget))  //FoF discrimination
	{
		if (oTarget != oCaster && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, 1045, TRUE));
			fDist = GetDistanceBetween(OBJECT_SELF, oTarget) / 10.0;
			if (!HkResistSpell(oCaster, oTarget))
			{
				nDam = HkApplyMetamagicVariableMods(d6(iCasterLevel), 6 * iCasterLevel);
				if (HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), iSaveType, oCaster)) nDam /= 2;
				DelayCommand(fDist, FreezeDamage(nDam, iDamageType, eLink, oTarget, fDuration)); //FIX: damage needs to be delayed, otherwise bad things happen
			}
		}
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect( iShapeEffect ), oCaster, 3.0);
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 15.0, lLocation, FALSE);
	}
	
	HkPostCast(oCaster);
}

